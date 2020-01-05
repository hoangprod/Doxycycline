FAMILY_MEMBER_PER_COUNT = 16
function SetViewOfFamilyMember(tabWnd)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local guide = W_ICON.CreateGuideIconWidget(tabWnd)
  guide:AddAnchor("BOTTOMLEFT", tabWnd, 0, -4)
  local OnEnter = function(self)
    SetTargetAnchorTooltip(GetCommonText("family_question_mark"), "BOTTOMLEFT", self, "BOTTOMRIGHT", 0, 0)
  end
  guide:SetHandler("OnEnter", OnEnter)
  local joinLabel = tabWnd:CreateChildWidget("label", "joinLabel", 0, false)
  joinLabel:SetAutoResize(true)
  joinLabel:SetHeight(FONT_SIZE.MIDDLE)
  joinLabel:AddAnchor("LEFT", guide, "RIGHT", 0, 0)
  ApplyTextColor(joinLabel, FONT_COLOR.DEFAULT)
  joinLabel:SetText(GetCommonText("family_join"))
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local inputName = W_CTRL.CreateEdit("inputName", tabWnd)
  inputName:SetExtent(282, 29)
  inputName:SetMaxTextLength(namePolicyInfo.max)
  inputName:AddAnchor("LEFT", joinLabel, "RIGHT", 25, 0)
  inputName:CreateGuideText(locale.common.input_name_guide, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local joinButton = tabWnd:CreateChildWidget("button", "joinButton", 0, true)
  joinButton:SetText(GetCommonText("family_join"))
  joinButton:AddAnchor("LEFT", inputName, "RIGHT", 4, 0)
  ApplyButtonSkin(joinButton, BUTTON_BASIC.DEFAULT)
  local viewOffMember = CreateCheckButton("viewOffMember", tabWnd, GetCommonText("family_view_off_member"), TEXTURE_PATH.CHECK_EYE_SHAPE)
  viewOffMember:SetButtonStyle("eyeShape")
  viewOffMember:AddAnchor("BOTTOMLEFT", guide, "TOPLEFT", viewOffMember.textButton:GetWidth() + 3, -5)
  viewOffMember.textButton:RemoveAllAnchors()
  viewOffMember.textButton:AddAnchor("RIGHT", viewOffMember, "LEFT", -3, 0)
  tabWnd.viewOffMember = viewOffMember
  local leaveButton = tabWnd:CreateChildWidget("button", "leaveButton", 0, true)
  leaveButton:SetText(GetCommonText("family_leave"))
  leaveButton:AddAnchor("BOTTOMRIGHT", tabWnd, 0, 0)
  ApplyButtonSkin(leaveButton, BUTTON_BASIC.DEFAULT)
  local memberCountTextbox = tabWnd:CreateChildWidget("textbox", "memberCountTextbox", 0, true)
  memberCountTextbox:SetAutoResize(true)
  memberCountTextbox:SetWidth(300)
  memberCountTextbox:SetHeight(FONT_SIZE.LARGE)
  memberCountTextbox.style:SetFontSize(FONT_SIZE.LARGE)
  memberCountTextbox:AddAnchor("BOTTOMRIGHT", leaveButton, "TOPRIGHT", 0, -5)
  memberCountTextbox.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(memberCountTextbox, FONT_COLOR.DEFAULT)
  local memberList = CreatePageListCtrl(tabWnd, "memberList", 0)
  memberList:Show(true)
  memberList:SetExtent(tabWnd:GetWidth(), tabWnd:GetHeight() - 70)
  memberList:AddAnchor("TOPLEFT", tabWnd, "TOPLEFT", 0, 21)
  memberList:AddAnchor("BOTTOMLEFT", viewOffMember.textButton, "TOPLEFT", 0, -40)
  tabWnd.memberList = memberList
  local LayoutFunc = function(applicantList, rowIndex, colIndex, subItem)
    local lockButton = subItem:GetParent():CreateChildWidget("button", "lockButton", 0, true)
    ApplyButtonSkin(lockButton, BUTTON_CONTENTS.FAMILY_LOCK)
    lockButton:AddAnchor("TOPLEFT", subItem:GetParent(), 0, 0)
    local line = CreateLine(subItem:GetParent(), "TYPE1")
    line:AddAnchor("TOPLEFT", subItem:GetParent(), "BOTTOMLEFT", 0, 0)
    line:AddAnchor("TOPRIGHT", subItem:GetParent(), "BOTTOMRIGHT", 0, 0)
    subItem:GetParent().line = line
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
  local SetNameFunc = function(subItem, info, setValue)
    if setValue and info.lock == false then
      if info.empty then
        subItem:SetText("")
      else
        subItem.charId = info.charId
        subItem.name = info.name
        subItem.title = info.title
        subItem.online = info.online
        subItem:SetText(info.name)
        ChangeSubItemTextColorForOnline(subItem, info.online)
      end
      subItem:GetParent().lockButton:Show(false)
      subItem:GetParent().line:Show(info.line)
    else
      subItem:SetText("")
      subItem:GetParent().lockButton:Show(true)
      subItem:GetParent().line:Show(false)
    end
  end
  local SetLevelFunc = function(subItem, info, setValue)
    if setValue and info.lock == false then
      if info.empty then
        subItem:SetText("")
        subItem.heirIcon:Show(false)
      else
        local lv = info.level
        if info.heirLevel > 0 then
          lv = info.heirLevel
          subItem.heirIcon:Show(true)
          if info.online then
            subItem.heirIcon:SetTextureInfo("successor_small")
          else
            subItem.heirIcon:SetTextureInfo("successor_small_gray")
          end
        else
          subItem.heirIcon:Show(false)
        end
        subItem:SetText(tostring(lv))
        ChangeSubItemTextColorForOnline(subItem, info.online)
      end
    else
      subItem:SetText("")
      subItem.heirIcon:Show(false)
    end
  end
  local SetTitleFunc = function(subItem, info, setValue)
    if setValue and info.lock == false then
      if info.empty then
        subItem:SetText("")
      else
        subItem:SetText(info.title)
        ChangeSubItemTextColorForOnline(subItem, info.online)
      end
    else
      subItem:SetText("")
    end
  end
  local SetRoleFunc = function(subItem, info, setValue)
    if setValue and info.lock == false then
      if info.empty then
        subItem:SetText("")
      else
        subItem:SetText(info.role)
        ChangeSubItemTextColorForOnline(subItem, info.online)
      end
    else
      subItem:SetText("")
    end
  end
  memberList:InsertColumn(GetCommonText("name"), 267, LCCIT_STRING, SetNameFunc, nil, nil, LayoutFunc)
  memberList:InsertColumn(GetCommonText("level"), 80, LCCIT_STRING, SetLevelFunc, nil, nil, LevelLayoutFunc)
  memberList:InsertColumn(GetCommonText("family_title"), 224, LCCIT_STRING, SetTitleFunc, nil, nil, nil)
  memberList:InsertColumn(GetCommonText("family_role"), 257, LCCIT_STRING, SetRoleFunc, nil, nil, nil)
  memberList:InsertRows(FAMILY_MEMBER_PER_COUNT, false)
  DrawListCtrlUnderLine(memberList)
  for i = 1, #memberList.listCtrl.column do
    SettingListColumn(memberList.listCtrl, memberList.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(memberList.listCtrl.column[i], #memberList.listCtrl.column, i)
    memberList.listCtrl.column[i]:Enable(false)
  end
  local refreshButton = tabWnd:CreateChildWidget("button", "refreshButton", 0, true)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  refreshButton:AddAnchor("TOPRIGHT", tabWnd, 3, 13)
end
