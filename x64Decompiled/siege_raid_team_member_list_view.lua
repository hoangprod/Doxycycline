local upState = true
local testSize2 = 20
function SetViewOfTeamMemberListWnd(parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow("siegeRaidTeamMemberListWnd", parent)
  wnd:SetExtent(680, 574)
  wnd:AddAnchor("CENTER", parent, 0, 0)
  wnd:SetTitle(locale.nationMgr.siegeRaidTeamMemberList)
  local NameSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.name)
    else
      subItem:SetText("")
    end
  end
  local LevelSetFunc = function(subItem, data, setValue)
    if setValue then
      local level = data.level + data.heirLevel
      subItem:SetText(GetLevelToString(level))
    else
      subItem:SetText("")
    end
  end
  local GearScoreSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.gearScore))
    else
      subItem:SetText("")
    end
  end
  local JobSetFunc = function(subItem, data, setValue)
    if setValue then
      local job = F_UNIT.GetCombinedAbilityName(data.ability[1], data.ability[2], data.ability[3])
      subItem:SetText(job)
    else
      subItem:SetText("")
    end
  end
  local LayoutNameFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutLevelFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutGearScoreFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutJobFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local teamMemberListCtrl = W_CTRL.CreateScrollListCtrl("teamMemberListCtrl", wnd)
  teamMemberListCtrl:Show(true)
  teamMemberListCtrl:SetExtent(640, 510)
  teamMemberListCtrl:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, 0)
  teamMemberListCtrl:InsertColumn(X2Locale:LocalizeUiText(COMMON_TEXT, "name"), 200, LCCIT_STRING, NameSetFunc, nil, nil, LayoutNameFunc)
  teamMemberListCtrl:InsertColumn(X2Locale:LocalizeUiText(COMMON_TEXT, "level"), 85, LCCIT_TEXTBOX, LevelSetFunc, nil, nil, LayoutLevelFunc)
  teamMemberListCtrl:InsertColumn(X2Locale:LocalizeUiText(COMMON_TEXT, "gear_score"), 150, LCCIT_STRING, GearScoreSetFunc, nil, nil, LayoutGearScoreFunc)
  teamMemberListCtrl:InsertColumn(X2Locale:LocalizeUiText(COMMUNITY_TEXT, "job"), 177, LCCIT_STRING, JobSetFunc, nil, nil, LayoutJobFunc)
  for i = 1, #teamMemberListCtrl.listCtrl.column do
    SettingListColumn(teamMemberListCtrl.listCtrl, teamMemberListCtrl.listCtrl.column[i], 28)
    DrawListCtrlColumnSperatorLine(teamMemberListCtrl.listCtrl.column[i], #teamMemberListCtrl.listCtrl.column, i)
  end
  DrawListCtrlUnderLine(teamMemberListCtrl.listCtrl, 26)
  teamMemberListCtrl:InsertRows(20, false)
  teamMemberListCtrl.listCtrl:DisuseSorting()
  ListCtrlItemGuideLine(teamMemberListCtrl.listCtrl.items, teamMemberListCtrl:GetRowCount() + 1)
  for i = 1, teamMemberListCtrl:GetRowCount() do
    if teamMemberListCtrl.listCtrl.items[i].line ~= nil then
      teamMemberListCtrl.listCtrl.items[i].line:SetVisible(true)
    end
  end
  local refreshButton = wnd:CreateChildWidget("button", "refreshButton", 0, true)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  refreshButton:AddAnchor("TOPRIGHT", teamMemberListCtrl, "TOPRIGHT", 0, 2)
  function wnd:UpdateSiegeRaidTeamMembers(siegeRaidTeamInfo)
    if siegeRaidTeamInfo == nil or siegeRaidTeamInfo.memberInfo == nil then
      teamMemberListCtrl.listCtrl:DeleteAllDatas()
      return
    end
    local oldListSize = teamMemberListCtrl.dataCount
    local membersSize = #siegeRaidTeamInfo.memberInfo
    for i = 1, membersSize do
      for j = 1, 4 do
        teamMemberListCtrl:InsertData(i, j, siegeRaidTeamInfo.memberInfo[i])
      end
    end
    if oldListSize > membersSize then
      for k = oldListSize, membersSize + 1, -1 do
        teamMemberListCtrl.listCtrl:DeleteData(k)
      end
    end
  end
  return wnd
end
