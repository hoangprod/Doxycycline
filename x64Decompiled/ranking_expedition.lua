local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreateExpeditionUpperFrame = function(id, parent)
  local frame = SetViewOfUpperFrame(id, parent)
  frame:AddAnchor("TOPLEFT", parent, 0, 40)
  frame.rewardButton:Show(false)
  frame.myCurRecord:Show(false)
  frame.refreshButton:RemoveAllAnchors()
  frame.refreshButton:AddAnchor("RIGHT", frame, -5, 0)
  local rankInfo
  function frame:SetRankInfo(info)
    rankInfo = info
  end
  local function OnEnter(self)
    local seasonInfo = BuildSeasonInformation(rankInfo.code)
    SetTooltip(seasonInfo.periodTooltip, self)
  end
  frame.period:SetHandler("OnEnter", OnEnter)
  local function OnClick()
    parent:RefreshExpeditionRanking()
  end
  frame.refreshButton:SetHandler("OnClick", OnClick)
  function frame:Lock()
    self.refreshButton:Enable(false)
  end
  function frame:Unlock()
    self.refreshButton:Enable(true)
  end
  function frame:FillMyRecord(category, myScore)
  end
  function frame:RefreshSeasonState()
    local seasonInfo = BuildSeasonInformation(rankInfo.code)
    self.period:SetPeriod(seasonInfo.periodStr, seasonInfo.onSeason, true)
  end
  return frame
end
local CreateExpeditionRankingListCtrl = function(id, parent, height, desc)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame:Show(true)
  frame:SetExtent(760, height)
  function frame:FillRankData(rankData)
    self:DeleteAllDatas()
    for i = 1, self:GetRowCount() do
      if self.listCtrl.items[i].line ~= nil then
        self.listCtrl.items[i].line:SetVisible(false)
      end
    end
    local visibleCnt = #rankData >= self:GetRowCount() and self:GetRowCount() or #rankData
    for i = 1, visibleCnt do
      if self.listCtrl.items[i].line ~= nil then
        self.listCtrl.items[i].line:SetVisible(true)
      end
    end
    for i = 1, #rankData do
      if rankData[i] ~= nil then
        self:InsertRowData(i, #self.listCtrl.column, rankData[i])
      end
    end
    self:UpdateView()
  end
  local GradeDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.bg:SetVisible(false)
      if data.grade > 0 then
        SetRankingGradeDataFunc(subItem.bg, subItem.icon, data.grade)
      end
      subItem.icon:SetVisible(data.gradeLeader)
    else
      subItem.bg:SetVisible(false)
      if subItem.icon ~= nil then
        subItem.icon:SetVisible(false)
      end
    end
  end
  local GradeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    CommonGradeLayoutFunc(widget.listCtrl, subItem)
    local icon = subItem:CreateImageDrawable(TEXTURE_PATH.RANKING_GRADE, "overlay")
    icon:AddAnchor("CENTER", subItem, 2, 0)
    subItem.icon = icon
  end
  local RankSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = tostring(data.rank)
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local LvlSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = tostring(data.lvl)
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local function ExpeditionNameLayoutSetFunc(widget, rowIndex, colIndex, subItem)
    subItem:SetLimitWidth(true)
    local function OnEnter(self)
      local data = frame:GetDataByViewIndex(rowIndex, 1)
      local str = ""
      if data ~= nil then
        str = makeTooltip(str, "%s%s", FONT_COLOR_HEX.SOFT_BROWN, data.name)
        SetTooltip(str, subItem)
      end
    end
    local OnLeave = function(self)
      HideTooltip()
    end
    local OnClick = function(self, arg)
      HideTooltip()
    end
    subItem:SetHandler("OnEnter", OnEnter)
    subItem:SetHandler("OnLeave", OnLeave)
    subItem:SetHandler("OnClick", OnClick)
  end
  local ExpeditionNameSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = data.name
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local GearScoreSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = string.format("%d / %d", data.totalGearScore, data.totalGearScore / data.members)
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local BattleRecordScoreSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = string.format("%d / %d", data.win, data.lose)
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local MemberCountSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = tostring(data.members)
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local ServerNameSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = data.worldName
    end
    subItem:SetText(str)
    local curWorldId = X2:GetCurrentWorldId()
    if data.worldID == curWorldId and X2Faction:GetMyExpeditionId() == data.id then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
    else
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    end
  end
  local columnWidth = rankingLocale.expeditionRankColumnWidth
  frame:InsertColumn(locale.ranking.rank, columnWidth[1], LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  frame:InsertColumn(locale.ranking.placing, columnWidth[2], LCCIT_STRING, RankSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "level"), columnWidth[3], LCCIT_STRING, LvlSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "expedition"), columnWidth[4], LCCIT_STRING, ExpeditionNameSetFunc, nil, nil, ExpeditionNameLayoutSetFunc)
  if desc.code == "ranking_expedition_gear_score" then
    frame:InsertColumn(GetUIText(COMMON_TEXT, "gear_score"), columnWidth[5], LCCIT_STRING, GearScoreSetFunc, nil, nil, nil, nil)
  elseif desc.code == "ranking_expedition_battle_record" then
    frame:InsertColumn(GetUIText(COMMON_TEXT, "expedition_rank_category_battle_record"), columnWidth[5], LCCIT_STRING, BattleRecordScoreSetFunc, nil, nil, nil, nil)
  end
  frame:InsertColumn(GetUIText(COMMON_TEXT, "number_of_people"), columnWidth[6], LCCIT_STRING, MemberCountSetFunc, nil, nil, nil, nil)
  frame:InsertColumn("", columnWidth[7], LCCIT_STRING, ServerNameSetFunc, nil, nil, nil, nil)
  frame:InsertRows(20, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  local worldCombo
  function frame:RegisterCallbackWorldSelectedFunc(func)
    function worldCombo:SelectedProc()
      func()
    end
  end
  function frame:SetWorldInfo(info)
    worldCombo:AppendItems(BuildWorldName(info))
  end
  local function WorldLayoutFunc(column)
    worldCombo = W_CTRL.CreateComboBox("worldCombo", column)
    worldCombo:SetWidth(column:GetWidth() - 8)
    worldCombo:AddAnchor("TOPLEFT", column, "TOPLEFT", 4, 4)
  end
  function frame:GetSelectedWorldIdx()
    return worldCombo:GetSelectedIndex()
  end
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    if i == 7 then
      WorldLayoutFunc(frame.listCtrl.column[i])
    end
    frame.listCtrl.column[i]:Enable(false)
    SetButtonFontColor(frame.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  return frame
end
function CreateExpeditionWidget(id, parent)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  widget.code = id
  widget.upperFrame = CreateExpeditionUpperFrame("expeditionUpper", widget)
  local activeRankList
  widget.rankLists = {}
  local datas = {}
  local rankings = X2Rank:BuildRankingTabInfo(id)
  for i = 1, #rankings do
    local desc = rankings[i]
    local data = {
      text = GetUIText(COMMON_TEXT, desc.name),
      value = i
    }
    table.insert(datas, data)
    widget.rankLists[i] = CreateExpeditionRankingListCtrl(desc.code, widget, 516, desc)
    widget.rankLists[i]:AddAnchor("TOPLEFT", widget.upperFrame, "BOTTOMLEFT", 0, 5)
    widget.rankLists[i]:Show(false)
  end
  activeRankList = widget.rankLists[1]
  activeRankList:Show(true)
  local rankKindLabel = widget:CreateChildWidget("label", "rankKindLabel", 0, true)
  rankKindLabel:SetAutoResize(true)
  rankKindLabel:SetHeight(FONT_SIZE.LARGE)
  rankKindLabel.style:SetFontSize(FONT_SIZE.LARGE)
  rankKindLabel:AddAnchor("TOPLEFT", widget, "TOPLEFT", 10, sideMargin - 5)
  rankKindLabel:SetText(GetUIText(COMMON_TEXT, "detail_rank"))
  ApplyTextColor(rankKindLabel, FONT_COLOR.DEFAULT)
  local categoryCombo = W_CTRL.CreateComboBox("categoryCombo", widget)
  categoryCombo:SetWidth(200)
  categoryCombo:AddAnchor("LEFT", rankKindLabel, "RIGHT", 5, 0)
  categoryCombo:AppendItems(datas, false)
  local tip = widget:CreateChildWidget("textbox", "tip", 0, true)
  tip:Show(false)
  tip:SetExtent(760, FONT_SIZE.MIDDLE)
  tip:AddAnchor("BOTTOMLEFT", widget, "BOTTOMLEFT", 0, 0)
  tip:SetText(GetUIText(COMMON_TEXT, "expedition_rank_tip"))
  tip:SetHeight(tip:GetTextHeight())
  tip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  local function WorldSelected()
    widget:Activate()
  end
  for i = 1, #widget.rankLists do
    widget.rankLists[i]:RegisterCallbackWorldSelectedFunc(WorldSelected)
  end
  function widget:ChangeRankTypeUI(selectedRank)
    activeRankList:Show(false)
    activeRankList = widget.rankLists[selectedRank]
    activeRankList:Show(true)
  end
  widget:ChangeRankTypeUI(1)
  function widget:RefreshExpeditionRanking()
    local selIdx = categoryCombo:GetSelectedIndex()
    local worldIdx = activeRankList:GetSelectedWorldIdx()
    local ranking = rankings[selIdx]
    local division = ranking[worldIdx].id
    widget.upperFrame:SetRankInfo(ranking)
    X2Rank:RequestRankData(ranking.code, division)
  end
  function categoryCombo:SelectedProc(idx)
    local ranking = rankings[idx]
    widget:ChangeRankTypeUI(idx)
    activeRankList:SetWorldInfo(ranking)
    widget:Activate()
  end
  widget.upperFrame:SetRankInfo(rankings[1])
  function widget:Activate()
    if categoryCombo:IsSelected() == false then
      categoryCombo:Select(1)
    end
    widget:RefreshExpeditionRanking()
    parent:WaitPage(true)
  end
  function widget:Lock()
    widget.upperFrame:Lock()
  end
  function widget:Unlock()
    widget.upperFrame:Unlock()
  end
  function widget:FillRankData(rankData)
    activeRankList:FillRankData(rankData)
  end
  function widget:FillMyRecord(category, myScore)
  end
  function widget:RefreshSeasonState()
    widget.upperFrame:RefreshSeasonState()
  end
  function widget:GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(categoryCombo, activeRankList)
    return height + sideMargin / 1.7
  end
  return widget
end
