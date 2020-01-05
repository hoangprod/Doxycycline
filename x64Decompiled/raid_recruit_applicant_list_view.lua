RAID_APPLICANT_PER_COUNT = 12
function SetViewOfRaidApplicantList(parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow("raidApplicant", parent)
  wnd:SetExtent(680, 525)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetCommonText("expedition_applicant_managemanet"))
  local list = CreatePageListCtrl(wnd, "list", 0)
  list:SetExtent(wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2, 325)
  list:AddAnchor("TOPLEFT", wnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE + 33)
  wnd.list = list
  local checkAll = CreateCheckButton("checkboxAll", wnd, "")
  local SetNameFunc = function(subItem, data, setValue)
    if setValue then
      subItem.charId = data.charId
      subItem.name:SetText(data.name)
      subItem.check:Show(true)
      function OnEnter(self)
        if "" == data.expedition then
          data.expedition = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "nobody")
        end
        local expedition = string.format("%s: %s", GetCommonText("expedition"), data.expedition)
        local job = string.format("%s: %s", X2Locale:LocalizeUiText(COMMUNITY_TEXT, "job"), F_UNIT.GetCombinedAbilityName(data.abilities[1], data.abilities[2], data.abilities[3]))
        local gearPoint = string.format("%s: %d", GetCommonText("gear_score"), data.gearPoint)
        local tooltip = string.format([[
%s
%s
%s%s|r]], expedition, job, F_COLOR.GetColor("bright_blue", true), gearPoint)
        SetTooltip(tooltip, self, true)
      end
      subItem.name:SetHandler("OnEnter", OnEnter)
    else
      subItem.name:SetText("")
      subItem.check:Show(false)
      subItem.check:SetChecked(false)
    end
  end
  local SetLevelFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(GetLevelToString(data.level))
    else
      subItem:SetText("")
    end
  end
  local SetRoleFunc = function(subItem, data, setValue)
    if setValue then
      subItem.roleLabel:Show(true)
      subItem.roleLabel:SetRole(data.role)
    else
      subItem.roleLabel:Show(false)
    end
  end
  local SetTextFunc = function(subItem, data, setValue)
    if setValue then
      do
        local pos = GetConvertingPosString(true, data.position)
        subItem:SetText(pos)
        function OnEnter(self)
          SetTooltip(pos, self, true)
        end
        subItem:SetHandler("OnEnter", OnEnter)
      end
    else
      subItem:SetText("")
    end
  end
  local function LayoutNameFunc(list, rowIndex, colIndex, subItem)
    ApplyTextColor(list.listCtrl.column[colIndex], FONT_COLOR.DEFAULT)
    local check = CreateCheckButton("checkbox", subItem, "")
    check:AddAnchor("LEFT", subItem, "LEFT", 0, 0)
    subItem.check = check
    local name = subItem:CreateChildWidget("textbox", "name", 0, true)
    name:Raise()
    name.style:SetAlign(ALIGN_LEFT)
    name:AddAnchor("TOPLEFT", subItem, "TOPLEFT", check:GetWidth(), 2)
    name:AddAnchor("BOTTOMRIGHT", subItem, "BOTTOMRIGHT", -2, -2)
    ApplyTextColor(name, FONT_COLOR.DEFAULT)
    function check:OnCheckChanged()
      wnd:UpdateCheckButton()
      if self:GetChecked() then
        return
      end
      checkAll:SetChecked(false)
    end
    check:SetHandler("OnCheckChanged", check.OnCheckChanged)
  end
  local LayoutLevelFunc = function(list, rowIndex, colIndex, subItem)
    subItem:Raise()
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutRoleFunc = function(list, rowIndex, colIndex, subItem)
    local roleLabel = CreateRoleLabel("roleLabel", subItem)
    roleLabel:AddAnchor("CENTER", subItem, 0, 0)
  end
  local LayoutTextFunc = function(list, rowIndex, colIndex, subItem)
    subItem.style:SetEllipsis(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(10, 0, 0, 0)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  list:InsertColumn(GetCommonText("name"), 226, LCCIT_WINDOW, SetNameFunc, nil, nil, LayoutNameFunc)
  list:InsertColumn(GetCommonText("level"), 58, LCCIT_TEXTBOX, SetLevelFunc, nil, nil, LayoutLevelFunc)
  list:InsertColumn(X2Locale:LocalizeUiText(COMMUNITY_TEXT, "role"), 95, LCCIT_WINDOW, SetRoleFunc, nil, nil, LayoutRoleFunc)
  list:InsertColumn(X2Locale:LocalizeUiText(COMMUNITY_TEXT, "position"), 262, LCCIT_STRING, SetTextFunc, nil, nil, LayoutTextFunc)
  list:InsertRows(RAID_APPLICANT_PER_COUNT, false)
  list.listCtrl:DisuseSorting()
  DrawListCtrlUnderLine(list)
  for i = 1, #list.listCtrl.column do
    SettingListColumn(list.listCtrl, list.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(list.listCtrl.column[i], #list.listCtrl.column, i)
    SetButtonFontColor(list.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  checkAll:AddAnchor("LEFT", list.listCtrl.column[1], 0, -1)
  checkAll:Show(true)
  wnd.checkAll = checkAll
  local joinTypeLabel = wnd:CreateChildWidget("label", "joinTypeLabel", 0, true)
  joinTypeLabel:SetAutoResize(true)
  joinTypeLabel:SetHeight(FONT_SIZE.LARGE)
  joinTypeLabel.style:SetAlign(ALIGN_CENTER)
  joinTypeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  joinTypeLabel:AddAnchor("BOTTOMLEFT", list, "TOPLEFT", 0, -8)
  joinTypeLabel:SetText(GetCommonText("raid_join_type"))
  ApplyTextColor(joinTypeLabel, FONT_COLOR.DEFAULT)
  local JOIN_TEXTS = GetRiadJoinTextList(false)
  local joinRadioBoxes = CreateRadioGroup("applicantJoinRadioBoxes", wnd, "horizen")
  joinRadioBoxes:SetData(JOIN_TEXTS)
  joinRadioBoxes:Check(1)
  joinRadioBoxes:AddAnchor("LEFT", joinTypeLabel, "RIGHT", 9, 0)
  wnd.joinRadioBoxes = joinRadioBoxes
  local bg = CreateContentBackground(joinRadioBoxes, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", joinTypeLabel, -6, -6)
  bg:AddAnchor("BOTTOMRIGHT", joinRadioBoxes, 6, 6)
  local refreshButton = wnd:CreateChildWidget("button", "refreshButton", 0, true)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  refreshButton:AddAnchor("BOTTOMRIGHT", list, "TOPRIGHT", 0, 0)
  local applicantCount = wnd:CreateChildWidget("textbox", "applicantCount", 0, true)
  applicantCount.style:SetAlign(ALIGN_CENTER)
  applicantCount.style:SetFontSize(FONT_SIZE.LARGE)
  applicantCount:AddAnchor("TOPLEFT", refreshButton, "TOPLEFT", -(193 - refreshButton:GetWidth()), 0)
  applicantCount:AddAnchor("BOTTOMRIGHT", refreshButton, "BOTTOMLEFT", 0, 0)
  ApplyTextColor(applicantCount, FONT_COLOR.DEFAULT)
  local bg = CreateContentBackground(applicantCount, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", applicantCount, "TOPLEFT", -2, -2)
  bg:AddAnchor("BOTTOMRIGHT", refreshButton, "BOTTOMRIGHT", 2, 2)
  local tooltipIcon = W_ICON.CreateGuideIconWidget(wnd)
  tooltipIcon:AddAnchor("BOTTOMLEFT", wnd, MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE - 10)
  local tooltipText = wnd:CreateChildWidget("label", "tooltipText", 0, true)
  tooltipText:SetAutoResize(true)
  tooltipText:SetHeight(FONT_SIZE.MIDDLE)
  tooltipText.style:SetAlign(ALIGN_CENTER)
  tooltipText.style:SetFontSize(FONT_SIZE.MIDDLE)
  tooltipText:AddAnchor("LEFT", tooltipIcon, "RIGHT", 0, 0)
  tooltipText:SetText(GetCommonText("raid_join_type"))
  ApplyTextColor(tooltipText, FONT_COLOR.DEFAULT)
  local tooltip = wnd:CreateChildWidget("label", "tooltip", 0, true)
  tooltip:AddAnchor("TOPLEFT", tooltipIcon, "TOPLEFT", 0, 0)
  tooltip:AddAnchor("BOTTOMRIGHT", tooltipText, "BOTTOMRIGHT", 0, 0)
  local OnEnter = function(self)
    SetTooltip(GetCommonText("raid_recruit_join_tooltip"), self)
  end
  tooltip:SetHandler("OnEnter", OnEnter)
  local rejectButton = wnd:CreateChildWidget("button", "rejectButton", 0, true)
  rejectButton:SetText(expeditionLocale.texts.reject)
  rejectButton:AddAnchor("BOTTOMRIGHT", wnd, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  ApplyButtonSkin(rejectButton, BUTTON_BASIC.DEFAULT)
  local acceptButton = wnd:CreateChildWidget("button", "acceptButton", 0, true)
  acceptButton:SetText(expeditionLocale.texts.accept)
  acceptButton:AddAnchor("RIGHT", rejectButton, "LEFT", 0, 0)
  ApplyButtonSkin(acceptButton, BUTTON_BASIC.DEFAULT)
  return wnd
end
