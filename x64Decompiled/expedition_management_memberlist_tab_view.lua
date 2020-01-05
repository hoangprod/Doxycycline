local ML = GetTabViewOrderList()
function SetViewOfExpeditionMemberList(id, parent)
  EXPEDITION_MEMBER_COL = {
    NAME = 1,
    LV = 2,
    CLASS = 3,
    ROLE = 4,
    POS = 5,
    MEMO = 6,
    ONLINE = 7,
    PARTY = 8,
    CONTRIBUTION = 9,
    HEIR_LV = 10,
    CHK = 11
  }
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = W_CTRL.CreatePageScrollListCtrl("frame", parent)
  frame:Show(true)
  frame:AddAnchor("TOPLEFT", parent, 0, sideMargin / 2)
  frame:AddAnchor("BOTTOMRIGHT", parent, 0, bottomMargin * 1.5)
  function frame:CheckProc_inviteButton()
    parent.inviteRaid:Enable(frame:GetSelctedCheckBoxs())
    parent.summon:Enable(frame:GetSelctedCheckBoxs())
  end
  local function NameDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem.nameLabel:SetText(data[EXPEDITION_MEMBER_COL.NAME])
      subItem.selectCheck:Show(true)
      subItem.selectCheck:Enable(data[EXPEDITION_MEMBER_COL.ONLINE])
      subItem.selectCheck:SetChecked(data[EXPEDITION_MEMBER_COL.CHK], true)
      subItem.icon:Show(data[EXPEDITION_MEMBER_COL.PARTY])
      ChangeSubItemTextColorForOnline(subItem.nameLabel, data[EXPEDITION_MEMBER_COL.ONLINE])
      if data[EXPEDITION_MEMBER_COL.NAME] == X2Unit:UnitName("player") then
        subItem.selectCheck:Enable(false)
      end
    else
      subItem.nameLabel:SetText("")
      subItem.icon:Show(false)
      subItem.selectCheck:SetChecked(false, false)
      subItem.selectCheck:Show(false)
      frame.allSelectCheck:SetChecked(false, false)
    end
  end
  local ContributionPointSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format("%d", data[EXPEDITION_MEMBER_COL.CONTRIBUTION]))
      ChangeSubItemTextColorForOnline(subItem, data[EXPEDITION_MEMBER_COL.ONLINE])
    end
  end
  local LevelDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local lv = data[EXPEDITION_MEMBER_COL.LV]
      if data[EXPEDITION_MEMBER_COL.HEIR_LV] > 0 then
        lv = data[EXPEDITION_MEMBER_COL.HEIR_LV]
        subItem.heirIcon:Show(true)
      else
        subItem.heirIcon:Show(false)
      end
      if data[EXPEDITION_MEMBER_COL.ONLINE] then
        subItem.heirIcon:SetTextureInfo("successor_small")
      else
        subItem.heirIcon:SetTextureInfo("successor_small_gray")
      end
      subItem:SetText(tostring(lv))
      ChangeSubItemTextColorForOnline(subItem, data[EXPEDITION_MEMBER_COL.ONLINE])
    end
  end
  local RoleDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.roleIcon:SetRoleIcon(data[EXPEDITION_MEMBER_COL.ROLE], 5, 8)
    end
  end
  local PosDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local posStr = GetConvertingPosString(data[EXPEDITION_MEMBER_COL.ONLINE], data[EXPEDITION_MEMBER_COL.POS])
      subItem.posLabel:SetText(posStr)
      ChangeSubItemTextColorForOnline(subItem.posLabel, data[EXPEDITION_MEMBER_COL.ONLINE])
    end
  end
  local JobAscendingSortFunc = function(a, b)
    local aString = F_UNIT.GetCombinedAbilityName(a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][1], a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][2], a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][3])
    local bString = F_UNIT.GetCombinedAbilityName(b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][1], b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][2], b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][3])
    return aString < bString and true or false
  end
  local JobDescendingSortFunc = function(a, b)
    local aString = F_UNIT.GetCombinedAbilityName(a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][1], a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][2], a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][3])
    local bString = F_UNIT.GetCombinedAbilityName(b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][1], b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][2], b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.CLASS][3])
    return aString > bString and true or false
  end
  local RoleAscendingSortFunc = function(a, b)
    return a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ROLE] < b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ROLE] and true or false
  end
  local RoleDescendingSortFunc = function(a, b)
    return a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ROLE] > b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ROLE] and true or false
  end
  local function RoleLayoutSetFunc(frame, rowIndex, colIndex, subItem)
    CreateRoleIconDrawable(subItem)
    subItem.roleIcon:SetExtent(expeditionLocale.width.memberListColumn[ML.ROLE], 25)
  end
  local PosAscendingSortFunc = function(a, b)
    local aPos = GetConvertingPosString(a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ONLINE], a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.POS])
    local bPos = GetConvertingPosString(b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ONLINE], b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.POS])
    return aPos < bPos and true or false
  end
  local PosDescendingSortFunc = function(a, b)
    local aPos = GetConvertingPosString(a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ONLINE], a[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.POS])
    local bPos = GetConvertingPosString(b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.ONLINE], b[ROWDATA_COLUMN_OFFSET + 1][EXPEDITION_MEMBER_COL.POS])
    return aPos < bPos and true or false
  end
  local PosLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
    local posLabel = subItem:CreateChildWidget("label", "posLabel", 0, true)
    posLabel:Raise()
    posLabel:Show(true)
    posLabel:AddAnchor("TOPLEFT", subItem, 10, 0)
    posLabel:AddAnchor("BOTTOMRIGHT", subItem, -10, 0)
    posLabel.style:SetEllipsis(true)
    posLabel.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(posLabel, FONT_COLOR.DEFAULT)
  end
  local LevelLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:Raise()
    subItem:Show(true)
    subItem:SetAutoResize(true)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local heirIcon = subItem:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor_small", "artwork")
    heirIcon:AddAnchor("RIGHT", subItem, "LEFT", -4, 0)
    subItem.heirIcon = heirIcon
  end
  local NameColumnLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
    local selectCheck = CreateCheckButton(subItem:GetId() .. ".selectCheck", subItem)
    selectCheck:Show(false)
    selectCheck:AddAnchor("LEFT", subItem, 5, -1)
    subItem.selectCheck = selectCheck
    subItem.selectCheck.rowIndex = rowIndex
    function selectCheck:CheckBtnCheckChagnedProc(checked)
      local data = frame:GetDataByViewIndex(rowIndex, colIndex)
      data[EXPEDITION_MEMBER_COL.CHK] = checked
      if not checked then
        frame.allSelectCheck:SetChecked(false, false)
      else
        frame.allSelectCheck:SetChecked(frame:IsAllChecked(), false)
      end
      if frame.CheckProc_inviteButton ~= nil then
        frame:CheckProc_inviteButton()
      end
    end
    local icon = W_ICON.CreatePartyIconWidget(subItem)
    icon:Show(false)
    icon:AddAnchor("LEFT", subItem, 20, 1)
    local nameLabel = subItem:CreateChildWidget("label", "nameLabel", 0, true)
    nameLabel:Show(true)
    nameLabel:SetExtent(140, 25)
    nameLabel:AddAnchor("LEFT", icon, "RIGHT", 3, -1)
    nameLabel.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(nameLabel, FONT_COLOR.DEFAULT)
  end
  local JobDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local str = F_UNIT.GetCombinedAbilityName(data[EXPEDITION_MEMBER_COL.CLASS][1], data[EXPEDITION_MEMBER_COL.CLASS][2], data[EXPEDITION_MEMBER_COL.CLASS][3])
      subItem:SetText(str)
      ChangeSubItemTextColorForOnline(subItem, data[EXPEDITION_MEMBER_COL.ONLINE])
    else
      subItem:SetText("")
    end
  end
  local JobLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetInset(10, 0, 0, 0)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetAlign(ALIGN_LEFT)
  end
  frame:InsertColumn(locale.faction.name, expeditionLocale.width.memberListColumn[ML.NAME], LCCIT_WINDOW, NameDataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, NameColumnLayoutSetFunc)
  frame:InsertColumn(locale.auction.level, expeditionLocale.width.memberListColumn[ML.LEVEL], LCCIT_STRING, LevelDataSetFunc, LevelAscendingSortFunc, LevelDescendingSortFunc, LevelLayoutSetFunc)
  frame:InsertColumn(locale.community.job, expeditionLocale.width.memberListColumn[ML.CLASS], LCCIT_STRING, JobDataSetFunc, JobAscendingSortFunc, JobDescendingSortFunc, JobLayoutSetFunc)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "expedition_member_contribution"), expeditionLocale.width.memberListColumn[ML.CONTRIBUTION], LCCIT_STRING, ContributionPointSetFunc, nil, nil)
  frame:InsertColumn(locale.expedition.role, expeditionLocale.width.memberListColumn[ML.ROLE], LCCIT_WINDOW, RoleDataSetFunc, RoleAscendingSortFunc, RoleDescendingSortFunc, RoleLayoutSetFunc)
  frame:InsertColumn(locale.expedition.position, expeditionLocale.width.memberListColumn[ML.POS], LCCIT_WINDOW, PosDataSetFunc, nil, nil, PosLayoutSetFunc)
  frame:InsertRows(18, false)
  frame.listCtrl:DisuseSorting()
  DrawListCtrlUnderLine(frame.listCtrl)
  frame.listCtrl:UseOverClickTexture()
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    if i == #frame.listCtrl.column then
      frame.listCtrl.column[i]:Enable(false)
    end
  end
  local allSelectCheck = CreateCheckButton(frame:GetId() .. ".allSelectCheck", frame)
  allSelectCheck:AddAnchor("LEFT", frame.listCtrl.column[1], 5, -1)
  frame.allSelectCheck = allSelectCheck
  local inviteRaid = parent:CreateChildWidget("button", "inviteRaid", 0, true)
  inviteRaid:Enable(false)
  inviteRaid:SetText(locale.expedition.inviteRaid)
  inviteRaid:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  ApplyButtonSkin(inviteRaid, BUTTON_BASIC.DEFAULT)
  local summon = parent:CreateChildWidget("button", "summon", 0, true)
  summon:SetText(GetCommonText("expedition_summon"))
  summon:AddAnchor("RIGHT", inviteRaid, "LEFT", -3, 0)
  summon:Show(X2Player:GetFeatureSet().expeditionSummon)
  summon:Enable(false)
  ApplyButtonSkin(summon, BUTTON_BASIC.DEFAULT)
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local inputName = W_CTRL.CreateEdit("inputName", parent)
  inputName:SetExtent(326, 29)
  inputName:AddAnchor("BOTTOMLEFT", parent, 0, 0)
  inputName:SetMaxTextLength(namePolicyInfo.max)
  inputName:CreateGuideText(locale.common.input_name_guide, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local inviteExped = parent:CreateChildWidget("button", "inviteExped", 0, true)
  inviteExped:Enable(false)
  inviteExped:SetText(locale.expedition.invite)
  inviteExped:AddAnchor("LEFT", inputName, "RIGHT", 0, 0)
  ApplyButtonSkin(inviteExped, BUTTON_BASIC.DEFAULT)
  local numOfonlineMember = parent:CreateChildWidget("textbox", "numOfonlineMember", 0, true)
  numOfonlineMember:Show(true)
  numOfonlineMember:SetExtent(220, 16)
  numOfonlineMember:AddAnchor("BOTTOMRIGHT", inviteRaid, "TOPRIGHT", -3, -7)
  numOfonlineMember.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(numOfonlineMember, FONT_COLOR.TITLE)
  local viewOffMember = CreateCheckButton(id .. ".viewOffMember", parent, locale.expedition.viewOffMember, TEXTURE_PATH.CHECK_EYE_SHAPE)
  viewOffMember:SetButtonStyle("eyeShape")
  viewOffMember:AddAnchor("BOTTOMLEFT", inputName, "TOPLEFT", viewOffMember.textButton:GetWidth() + 6, -5)
  parent.viewOffMember = viewOffMember
  local buttonTable = {inviteRaid, summon}
  AdjustBtnLongestTextWidth(buttonTable)
  local refreshButton = parent:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:AddAnchor("TOPRIGHT", parent, 3, 13)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  local modalWindow = parent:CreateChildWidget("emptywidget", "modalWindow", 0, true)
  modalWindow:AddAnchor("TOPLEFT", parent, 0, 0)
  modalWindow:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local bg = modalWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "modal_bg", "background")
  bg:SetTextureColor("expedition")
  bg:AddAnchor("TOPLEFT", modalWindow, -15, 3)
  bg:AddAnchor("BOTTOMRIGHT", modalWindow, 15, -3)
  local loading_effect = modalWindow:CreateEffectDrawable("ui/tutorials/loading.dds", "background")
  loading_effect:SetExtent(32, 32)
  loading_effect:SetCoords(100, 1, 32, 32)
  loading_effect:AddAnchor("CENTER", modalWindow, 0, 0)
  loading_effect:SetRepeatCount(0)
  loading_effect:SetEffectPriority(1, "rotate", 1.5, 1.5)
  loading_effect:SetEffectRotate(1, 0, 360)
  parent.loading_effect = loading_effect
  function parent:WaitPage(isShow)
    self.modalWindow:Show(isShow)
    self.loading_effect:SetStartEffect(isShow)
  end
end
