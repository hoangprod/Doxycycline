local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateBattleFieldRankUpperFrame(id, parent, rewardWindow)
  local frame = SetViewOfUpperFrame(id, parent)
  frame:AddAnchor("TOPLEFT", parent, 0, 40)
  local rankInfo
  function frame:SetRankInfo(info)
    rankInfo = info
    self:SetReward(rankInfo)
  end
  local function OnEnter(self)
    local seasonInfo = BuildSeasonInformation(rankInfo.code)
    SetTooltip(seasonInfo.periodTooltip, self)
  end
  frame.period:SetHandler("OnEnter", OnEnter)
  function frame:SetReward(rankInfo)
    local divisions = X2Rank:GetRankingRewardDivisions(rankInfo.code)
    rewardWindow:SetReward(rankInfo)
    self.rewardButton:Enable(#divisions > 0)
  end
  local function RewardButtonLeftClickFunc(self)
    rewardWindow:RemoveAllAnchors()
    rewardWindow:AddAnchor("TOPRIGHT", self, "BOTTOMRIGHT", 0, sideMargin / 2)
    rewardWindow:Raise()
    rewardWindow:Show(not rewardWindow:IsVisible())
  end
  ButtonOnClickHandler(frame.rewardButton, RewardButtonLeftClickFunc)
  local tooltipMyScore
  local function OnEnter(self)
    SetTooltip(tooltipMyScore, self)
  end
  frame.myCurRecord:SetHandler("OnEnter", OnEnter)
  local function OnClick()
    parent:RefreshBattleFieldRanking()
  end
  frame.refreshButton:SetHandler("OnClick", OnClick)
  function frame:Lock()
    self.refreshButton:Enable(false)
  end
  function frame:Unlock()
    self.refreshButton:Enable(true)
  end
  function frame:RefreshSeasonState()
    local seasonInfo = BuildSeasonInformation(rankInfo.code)
    self.period:SetPeriod(seasonInfo.periodStr, seasonInfo.onSeason, true)
  end
  function frame:FillMyRecord(myScore)
    if myScore.ranking > 0 then
      tooltipMyScore = X2Locale:LocalizeUiText(COMMON_TEXT, "ranking_tip_battle_field_score_mine", tostring(myScore.ranking))
    else
      tooltipMyScore = X2Locale:LocalizeUiText(COMMON_TEXT, "ranking_tip_gear_score_mine", GetUIText(COMMON_TEXT, "no_ranking"))
    end
    local str = string.format("%s: %d", GetUIText(RANKING_TEXT, "my_cur_record"), myScore.score)
    self.myCurRecord:SetText(str)
  end
  return frame
end
local CreateBattleFieldRankingListCtrl = function(id, parent, height)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame:Show(true)
  frame:SetExtent(760, height)
  local function SetSubItemWidth(subItem, colIndex)
    subItem:SetWidth(frame.currentColumnWidth[colIndex])
    subItem:Show(subItem:GetWidth() ~= 0)
  end
  local function GradeDataSetFunc(subItem, data, setValue)
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
    SetSubItemWidth(subItem, 1)
  end
  local GradeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    CommonGradeLayoutFunc(widget.listCtrl, subItem)
    local icon = subItem:CreateImageDrawable(TEXTURE_PATH.RANKING_GRADE, "overlay")
    icon:AddAnchor("CENTER", subItem, 2, 0)
    subItem.icon = icon
  end
  local function RankDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.rank))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 2)
  end
  local function NameDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.name))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 3)
  end
  local function ScoreSetFunc(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.rating))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 4)
  end
  local function WinRatioSetFunc(subItem, data, setValue)
    if setValue then
      local str = string.format("%.1f%%", data.win_ratio)
      subItem:SetText(str)
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 5)
  end
  local function KillSetFunc(subItem, data, setValue)
    if setValue then
      local str = string.format("%d", data.kill_count)
      subItem:SetText(str)
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 6)
  end
  local function DeathSetFunc(subItem, data, setValue)
    if setValue then
      local str = string.format("%d", data.death_count)
      subItem:SetText(str)
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 7)
  end
  local function ServerNameDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.worldName))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
    SetSubItemWidth(subItem, 8)
  end
  frame.currentColumnWidth = {}
  frame.currentColumnWidth = rankingLocale.battlefieldRankColumnWidth.default
  frame:InsertColumn(locale.ranking.rank, frame.currentColumnWidth[1], LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  frame:InsertColumn(locale.ranking.placing, frame.currentColumnWidth[2], LCCIT_STRING, RankDataSetFunc, nil, nil, nil)
  frame:InsertColumn(locale.common.name, frame.currentColumnWidth[3], LCCIT_CHARACTER_NAME, NameDataSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "ranking"), frame.currentColumnWidth[4], LCCIT_STRING, ScoreSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "win_ratio"), frame.currentColumnWidth[5], LCCIT_STRING, WinRatioSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "kill_count"), frame.currentColumnWidth[6], LCCIT_STRING, KillSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "death_count"), frame.currentColumnWidth[7], LCCIT_STRING, DeathSetFunc, nil, nil, nil)
  frame:InsertColumn("", frame.currentColumnWidth[8], LCCIT_STRING, ServerNameDataSetFunc, nil, nil, nil, nil)
  frame:InsertRows(20, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  local worldCombo
  function frame:RegisterCallbackWorldSelectedFunc(func)
    function worldCombo:SelectedProc(selIdx)
      func(selIdx)
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
    if i == 4 then
      local OnEnter = function(self)
        SetTooltip(GetUIText(COMMON_TEXT, "ranking_tip_battle_field_score"), self)
      end
      frame.listCtrl.column[i]:SetHandler("OnEnter", OnEnter)
    end
    if i == #frame.listCtrl.column then
      WorldLayoutFunc(frame.listCtrl.column[i])
    end
    frame.listCtrl.column[i]:Enable(false)
    SetButtonFontColor(frame.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  local insetInfo = {leftInset = 70, rightInset = 10}
  for i = 1, frame:GetRowCount() do
    ListCtrlItemGuideLine(frame.listCtrl.items, frame:GetRowCount(), insetInfo)
  end
  function frame:FillRankData(rankDatas, rankCode)
    local rankName = "default"
    frame.currentColumnWidth = rankingLocale.battlefieldRankColumnWidth[rankName]
    if rankDatas.rankName ~= nil and rankingLocale.battlefieldRankColumnWidth[rankDatas.rankName] then
      rankName = rankDatas.rankName
      frame.currentColumnWidth = rankingLocale.battlefieldRankColumnWidth[rankName]
    end
    for i = 1, #frame.listCtrl.column do
      frame.listCtrl:SetColumnWidth(i, frame.currentColumnWidth[i])
      frame.listCtrl.column[i]:Show(frame.currentColumnWidth[i] > 0)
    end
    self:DeleteAllDatas()
    for i = 1, self:GetRowCount() do
      if self.listCtrl.items[i].line ~= nil then
        self.listCtrl.items[i].line:SetVisible(false)
      end
    end
    local visibleCnt = #rankDatas >= self:GetRowCount() and self:GetRowCount() or #rankDatas
    for i = 1, visibleCnt do
      if self.listCtrl.items[i].line ~= nil then
        self.listCtrl.items[i].line:SetVisible(true)
      end
    end
    for i = 1, #rankDatas do
      self:InsertRowData(i, #frame.listCtrl.column, rankDatas[i])
      do
        local function OnEnter(self)
          local rankData = frame:GetDataByViewIndex(i, 1)
          if rankData == nil then
            return
          end
          local data = X2Rank:GetRankerInformation(rankData.worldID, rankData.charID)
          if data ~= nil then
            local abilityNames = {
              data.ability_name_0,
              data.ability_name_1,
              data.ability_name_2
            }
            local abilities = ""
            for index = 1, #abilityNames do
              if abilityNames[index] ~= "invalid ability" then
                if abilities == "" then
                  abilities = locale.common.abilityNameWithStr(abilityNames[index])
                else
                  abilities = string.format("%s, %s", abilities, locale.common.abilityNameWithStr(abilityNames[index]))
                end
              end
            end
            local abilityIndex = {
              data.ability_idx_0,
              data.ability_idx_1,
              data.ability_idx_2
            }
            local str = ""
            if data.expedition ~= "" then
              str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.expedition, tostring(data.expedition))
            end
            str = makeTooltip(str, "%s%s: %s (%s)", FONT_COLOR_HEX.SOFT_BROWN, locale.community.job, F_UNIT.GetCombinedAbilityName(abilityIndex[1], abilityIndex[2], abilityIndex[3]), abilities)
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.hp, tostring(data.health))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.mp, tostring(data.mana))
            str = makeTooltip(str, "%s%s: %s", F_COLOR.GetColor("bright_blue", true), GetUIText(COMMON_TEXT, "gear_score"), tostring(data.gear))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.tooltip.leadership, tostring(data.leadership))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_honor_point, tostring(data.pvp_honor))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_kill_point, tostring(data.pvp_kill_count))
            ShowUnitFrameTooltipCursor(self, str)
          end
        end
        local OnLeave = function(self)
          HideUnitFrameTooltip()
        end
        local function OnClick(self, arg)
          HideUnitFrameTooltip()
          if arg == "RightButton" and X2Rank:IsRankerQueriable(rankCode) == true then
            local rankData = frame:GetDataByViewIndex(i, 1)
            if rankData ~= nil then
              ActivateRankerPopupMenu(self, rankData.worldID, rankData.charID, rankData.name)
            end
          end
        end
        if self.listCtrl.items[i] ~= nil then
          self.listCtrl.items[i]:SetHandler("OnEnter", OnEnter)
          self.listCtrl.items[i]:SetHandler("OnLeave", OnLeave)
          self.listCtrl.items[i]:SetHandler("OnClick", OnClick)
        end
      end
    end
    self:UpdateView()
  end
  return frame
end
function CreateRenewalRankingBattleFieldWidget(id, parent, rewardWindow)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  widget.code = id
  widget.rankList = CreateBattleFieldRankingListCtrl("battlefieldList", widget, 516)
  widget.upperFrame = CreateBattleFieldRankUpperFrame("battlefieldUpper", widget, rewardWindow)
  widget.rankList:AddAnchor("TOPLEFT", widget.upperFrame, "BOTTOMLEFT", 0, 5)
  local datas = {}
  local rankings = X2Rank:BuildRankingTabInfo(id)
  for i = 1, #rankings do
    local desc = rankings[i]
    local data = {
      text = GetUIText(COMMON_TEXT, desc.name),
      value = i
    }
    table.insert(datas, data)
  end
  local tip = widget:CreateChildWidget("textbox", "tip", 0, true)
  tip:Show(false)
  tip:SetExtent(760, FONT_SIZE.MIDDLE)
  tip:AddAnchor("BOTTOMLEFT", widget, "BOTTOMLEFT", 0, 0)
  tip:SetText(GetUIText(COMMON_TEXT, "ranking_tip_battle_field_score_widget"))
  tip:SetHeight(tip:GetTextHeight())
  tip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  local rankKindLabel = widget:CreateChildWidget("label", "rankKindLabel", 0, true)
  rankKindLabel:SetAutoResize(true)
  rankKindLabel:SetHeight(FONT_SIZE.LARGE)
  rankKindLabel.style:SetFontSize(FONT_SIZE.LARGE)
  rankKindLabel:AddAnchor("TOPLEFT", widget, "TOPLEFT", 10, sideMargin - 5)
  rankKindLabel:SetText(GetUIText(COMMON_TEXT, "detail_rank"))
  ApplyTextColor(rankKindLabel, FONT_COLOR.DEFAULT)
  local rankingCombo = W_CTRL.CreateComboBox("rankingCombo", widget)
  rankingCombo:SetWidth(150)
  rankingCombo:AddAnchor("LEFT", rankKindLabel, "RIGHT", 5, 0)
  rankingCombo:AppendItems(datas, false)
  function rankingCombo:SelectedProc(idx)
    local ranking = rankings[idx]
    widget:HideRewardWindow()
    tip:SetText(GetUIText(COMMON_TEXT, ranking.tooltip))
    widget.rankList:SetWorldInfo(ranking)
    widget:Activate()
  end
  widget.upperFrame:SetRankInfo(rankings[1])
  function widget:HideRewardWindow()
    rewardWindow:Show(false)
  end
  function widget:RefreshBattleFieldRanking()
    local selIdx = rankingCombo:GetSelectedIndex()
    local worldIdx = self.rankList:GetSelectedWorldIdx()
    local ranking = rankings[selIdx]
    local division = ranking[worldIdx].id
    widget.upperFrame:SetRankInfo(ranking)
    X2Rank:RequestRankData(ranking.code, division)
  end
  function widget:Activate()
    if rankingCombo:IsSelected() == false then
      rankingCombo:Select(1)
    end
    widget:RefreshBattleFieldRanking()
    parent:WaitPage(true)
  end
  local function WorldSelected()
    widget:Activate()
  end
  widget.rankList:RegisterCallbackWorldSelectedFunc(WorldSelected)
  function widget:Lock()
    widget.upperFrame:Lock()
  end
  function widget:Unlock()
    widget.upperFrame:Unlock()
  end
  function widget:FillRankData(rankDatas)
    local selIdx = rankingCombo:GetSelectedIndex()
    self.rankList:FillRankData(rankDatas, rankings[selIdx].code)
  end
  function widget:FillRewardInfo(rewardInfo, periodInfo)
  end
  function widget:FillMyRecord(myScore)
    widget.upperFrame:FillMyRecord(myScore)
  end
  function widget:RefreshSeasonState()
    widget.upperFrame:RefreshSeasonState()
  end
  function widget:GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(rankingCombo, self.rankList)
    return height + sideMargin / 1.7
  end
  return widget
end
