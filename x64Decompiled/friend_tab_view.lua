function SetViewOfFriendTabWindow(window)
  FRIEND_COL = {
    NAME = 1,
    LV = 2,
    CLASS = 3,
    POS = 4,
    RACE = 5,
    ONLINE = 6,
    PARTY = 7,
    HEIR_LV = 8,
    CHK = 9
  }
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = W_CTRL.CreatePageScrollListCtrl("frame", window)
  frame:Show(true)
  frame:AddAnchor("TOPLEFT", window, 0, sideMargin / 2)
  frame:AddAnchor("BOTTOMRIGHT", window, 0, bottomMargin + -sideMargin / 1.5)
  frame:SetUseDoubleClick(true)
  function frame:CheckProc_inviteButton()
    window.invitePartyButton:Enable(window:GetSelctedCheckBoxs())
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data[FRIEND_COL.NAME])
      subItem.selectCheck:Show(true)
      subItem.selectCheck:Enable(data[FRIEND_COL.ONLINE])
      subItem.selectCheck:SetChecked(data[FRIEND_COL.CHK], false)
      subItem.icon:Show(data[FRIEND_COL.PARTY])
      ChangeSubItemTextColorForOnline(subItem, data[FRIEND_COL.ONLINE])
    else
      subItem:SetText("")
      subItem.icon:Show(false)
      subItem.selectCheck:SetChecked(false, false)
      subItem.selectCheck:Show(false)
    end
  end
  local LevelLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:Raise()
    subItem:Show(true)
    subItem:SetAutoResize(true)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local heirIcon = subItem:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor_small", "artwork")
    heirIcon:AddAnchor("RIGHT", subItem, "LEFT", -4, 0)
    subItem.heirIcon = heirIcon
  end
  local LevelDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local lv = data[FRIEND_COL.LV]
      if data[FRIEND_COL.HEIR_LV] > 0 then
        lv = data[FRIEND_COL.HEIR_LV]
        subItem.heirIcon:Show(true)
      else
        subItem.heirIcon:Show(false)
      end
      if data[FRIEND_COL.ONLINE] then
        subItem.heirIcon:SetTextureInfo("successor_small")
      else
        subItem.heirIcon:SetTextureInfo("successor_small_gray")
      end
      subItem:SetText(tostring(lv))
      ChangeSubItemTextColorForOnline(subItem, data[FRIEND_COL.ONLINE])
    end
  end
  local RaceDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(locale.raceText[data[FRIEND_COL.RACE]])
      ChangeSubItemTextColorForOnline(subItem, data[FRIEND_COL.ONLINE])
    end
  end
  local JobDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(F_UNIT.GetCombinedAbilityName(data[FRIEND_COL.CLASS][1], data[FRIEND_COL.CLASS][2], data[FRIEND_COL.CLASS][3]))
      ChangeSubItemTextColorForOnline(subItem, data[FRIEND_COL.ONLINE])
    end
  end
  function frame:IsAllChecked()
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[FRIEND_COL.ONLINE] and not data[FRIEND_COL.CHK] then
        return false
      end
    end
    return true
  end
  local function NameColumnLayoutSetFunc(frame, rowIndex, colIndex, subItem)
    local selectCheck = CreateCheckButton(subItem:GetId() .. ".selectCheck", subItem)
    selectCheck:Show(false)
    selectCheck:AddAnchor("LEFT", subItem, 5, 0)
    subItem.selectCheck = selectCheck
    subItem.selectCheck.rowIndex = rowIndex
    function selectCheck:CheckBtnCheckChagnedProc(checked)
      local data = frame:GetDataByViewIndex(rowIndex, colIndex)
      data[FRIEND_COL.CHK] = checked
      if not checked then
        window.allSelectCheck:SetChecked(false, false)
      else
        window.allSelectCheck:SetChecked(frame:IsAllChecked(), false)
      end
      if frame.CheckProc_inviteButton ~= nil then
        frame:CheckProc_inviteButton(checked)
      end
    end
    local icon = W_ICON.CreatePartyIconWidget(subItem)
    icon:Show(true)
    icon:AddAnchor("LEFT", subItem, 20, 1)
    subItem:Show(true)
    subItem:SetExtent(140, 25)
    subItem:SetInset(20 + icon:GetWidth() + 4, 0, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local columnWidth = relationshipLocale.friendTab.columnWidth
  frame:InsertColumn(locale.faction.name, columnWidth.name, LCCIT_STRING, NameDataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, NameColumnLayoutSetFunc)
  frame:InsertColumn(relationshipLocale:GetLevelText(), columnWidth.level, LCCIT_STRING, LevelDataSetFunc, LevelAscendingSortFunc, LevelDescendingSortFunc, LevelLayoutFunc)
  frame:InsertColumn(locale.community.race, columnWidth.race, LCCIT_STRING, RaceDataSetFunc, RaceAscendingSortFunc, RaceDescendingSortFunc, nil)
  frame:InsertColumn(locale.community.job, columnWidth.job, LCCIT_STRING, JobDataSetFunc, JobAscendingSortFunc, JobDescendingSortFunc, nil)
  frame:InsertRows(10, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  frame.listCtrl:UseOverClickTexture()
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    frame.listCtrl.column[i]:Enable(false)
  end
  local allSelectCheck = CreateCheckButton(window:GetId() .. ".allSelectCheck", window)
  allSelectCheck:AddAnchor("LEFT", frame.listCtrl.column[1], 5, 0)
  window.allSelectCheck = allSelectCheck
  local invitePartyButton = window:CreateChildWidget("button", "invitePartyButton", 0, true)
  invitePartyButton:Enable(false)
  invitePartyButton:SetText(locale.expedition.inviteParty)
  invitePartyButton:AddAnchor("BOTTOMRIGHT", window, 0, 1)
  ApplyButtonSkin(invitePartyButton, BUTTON_BASIC.DEFAULT)
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local inputNameExtent = relationshipLocale.friendTab.inputName.extent
  local inputName = W_CTRL.CreateEdit("inputName", window)
  inputName:SetExtent(inputNameExtent[1], inputNameExtent[2])
  inputName:AddAnchor("BOTTOMLEFT", window, 0, 0)
  inputName:SetMaxTextLength(namePolicyInfo.max)
  inputName:CreateGuideText(locale.common.input_name_guide, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local showOffMember = CreateCheckButton(window:GetId() .. ".showOffMember", window, locale.friend.showOffMember, TEXTURE_PATH.CHECK_EYE_SHAPE)
  showOffMember:SetButtonStyle("eyeShape")
  showOffMember:AddAnchor("BOTTOMLEFT", inputName, "TOPLEFT", showOffMember.textButton:GetWidth() + 6, -5)
  window.showOffMember = showOffMember
  local numOfonlineMember = window:CreateChildWidget("textbox", "numOfonlineMember", 0, true)
  numOfonlineMember:Show(true)
  numOfonlineMember:SetExtent(220, 16)
  numOfonlineMember:AddAnchor("BOTTOMRIGHT", invitePartyButton, "TOPRIGHT", -3, -5)
  numOfonlineMember.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(numOfonlineMember, FONT_COLOR.TITLE)
  local refreshButton = window:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:AddAnchor("TOPRIGHT", window, 3, 13)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  local addFriendButton = window:CreateChildWidget("button", "addFriendButton", 0, true)
  addFriendButton:Enable(false)
  addFriendButton:SetText(locale.friend.addFriend)
  addFriendButton:AddAnchor("BOTTOMLEFT", inputName, "BOTTOMRIGHT", 3, 1)
  ApplyButtonSkin(addFriendButton, BUTTON_BASIC.DEFAULT)
  local modalLoadingWindow = CreateLoadingTextureSet(window)
  modalLoadingWindow:AddAnchor("TOPLEFT", frame, -sideMargin + 1, 0)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", frame, sideMargin + -1, 0)
  local buttonTable = {invitePartyButton, addFriendButton}
  AdjustBtnLongestTextWidth(buttonTable)
end
