local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local OnEnter_HeirRankingGuide = function(eventObj)
  if eventObj.tooltipText == nil then
    return
  end
  SetTooltip(eventObj.tooltipText, eventObj)
end
local function CreateAchievementRankUpperFrame(id, parent, rewardWindow)
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
    parent:Activate()
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
    self.period:SetPeriod(seasonInfo.periodStr, seasonInfo.onSeason, false)
  end
  function frame:FillMyRecord(myScore, tooltipWidget)
    local myScoreText
    if myScore.code == "ranking_item_gear" then
      myScoreText = "ranking_tip_gear_score_mine"
    elseif myScore.code == "ranking_item_onehand" then
      myScoreText = "ranking_tip_item_rank_1_mine"
    elseif myScore.code == "ranking_item_twohand" then
      myScoreText = "ranking_tip_item_rank_2_mine"
    elseif myScore.code == "ranking_item_bow" then
      myScoreText = "ranking_tip_item_rank_3_mine"
    end
    local recordText
    if myScore.code ~= "ranking_heir_level" then
      if myScore.ranking > 0 then
        tooltipMyScore = X2Locale:LocalizeUiText(COMMON_TEXT, myScoreText, tostring(myScore.ranking))
      else
        tooltipMyScore = X2Locale:LocalizeUiText(COMMON_TEXT, myScoreText, GetUIText(COMMON_TEXT, "no_ranking"))
      end
      recordText = string.format("%s: %d (%d + %d)", GetUIText(RANKING_TEXT, "my_cur_record"), myScore.score, myScore.bareScore, myScore.score - myScore.bareScore)
    else
      tooltipMyScore = nil
      recordText = 0 < myScore.expBonusPercent and X2Locale:LocalizeUiText(COMMON_TEXT, "exp_take_rate_increase", string.format("%d", myScore.expBonusPercent)) or ""
    end
    self.myCurRecord:SetText(recordText)
    if myScore.expBonusPercent ~= nil and 0 < myScore.expBonusPercent then
      tooltipWidget.tooltipText = X2Locale:LocalizeUiText(COMMON_TEXT, "ranking_tip_heir_level_exp_increase", myScore.topRankerName, string.format("%d", myScore.expBonusPercent))
    else
      tooltipWidget.tooltipText = X2Locale:LocalizeUiText(COMMON_TEXT, "ranking_tip_heir_level_exp_no_increase")
    end
  end
  return frame
end
local CreateGearScoreRankingListCtrl = function(id, parent, height)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame:Show(true)
  frame:SetExtent(760, height)
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
  local RankDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.rank))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.name))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local ScoreSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.v1))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local DetailScoreSetFunc = function(subItem, data, setValue)
    if setValue then
      local score = tonumber(data.v1)
      local bareScore = tonumber(data.v2)
      local extScore = score - bareScore
      local str = string.format("%d + %d", bareScore, extScore)
      subItem:SetText(str)
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local ServerNameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.worldName))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local columnWidth = rankingLocale.gearRankColumnWidth
  frame:InsertColumn(locale.ranking.rank, columnWidth[1], LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  frame:InsertColumn(locale.ranking.placing, columnWidth[2], LCCIT_STRING, RankDataSetFunc, nil, nil, nil)
  frame:InsertColumn(locale.common.name, columnWidth[3], LCCIT_CHARACTER_NAME, NameDataSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "gear_score"), columnWidth[4], LCCIT_STRING, ScoreSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "detail_score"), columnWidth[5], LCCIT_STRING, DetailScoreSetFunc, nil, nil, nil)
  frame:InsertColumn("", columnWidth[6], LCCIT_STRING, ServerNameDataSetFunc, nil, nil, nil, nil)
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
  local score_tips = {
    GetUIText(COMMON_TEXT, "ranking_tip_gear_score_value"),
    GetUIText(COMMON_TEXT, "ranking_tip_gear_score_detail_value")
  }
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    if i == 4 or i == 5 then
      local function OnEnter(self)
        local tooltipString = score_tips[i - 4 + 1]
        SetTooltip(tooltipString, self)
      end
      frame.listCtrl.column[i]:SetHandler("OnEnter", OnEnter)
    end
    if i == 6 then
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
      self:InsertRowData(i, #self.listCtrl.column, rankDatas[i])
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
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.hp, string.format("%d", data.health))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.mp, string.format("%d", data.mana))
            str = makeTooltip(str, "%s%s: %s", F_COLOR.GetColor("bright_blue", true), GetUIText(COMMON_TEXT, "gear_score"), string.format("%d", data.gear))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.tooltip.leadership, string.format("%d", data.leadership))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_honor_point, string.format("%d", data.pvp_honor))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_kill_point, string.format("%d", data.pvp_kill_count))
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
local CreateItemRankingListCtrl = function(id, parent, height)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame:Show(true)
  frame:SetExtent(760, height)
  function frame:FillRankData(rankData, rankCode)
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
        local function OnEnter(self)
          local itemData = frame:GetDataByViewIndex(i, 1)
          if itemData == nil then
            return
          end
          local data = X2Rank:GetRankerInformation(itemData.worldID, itemData.charID)
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
          if X2Rank:IsRankerQueriable(rankCode) == true and arg == "RightButton" then
            local data = frame:GetDataByViewIndex(i, 1)
            if data ~= nil then
              ActivateRankerPopupMenu(self, data.worldID, data.charID, data.charName)
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
    ChangeColorForPlayer(subItem, data.charName, data.world)
  end
  local OwnerSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = data.charName
    end
    subItem:SetText(str)
    ChangeColorForPlayer(subItem, data.charName, data.world)
  end
  local GearNameLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    rankingLocale:SetItemNameLayout(subItem)
  end
  local GearNameSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = data.itemName
    end
    subItem:SetText(str)
    ChangeColorForPlayer(subItem, data.charName, data.world)
  end
  local GearScoreSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      local extValue = data.gearScore - data.bareScore
      str = string.format("%d (%d + %d)", data.gearScore, data.bareScore, extValue)
    end
    subItem:SetText(str)
    ChangeColorForPlayer(subItem, data.charName, data.world)
  end
  local ServerNameSetFunc = function(subItem, data, setValue)
    local str = ""
    if setValue then
      str = data.worldName
    end
    subItem:SetText(str)
    ChangeColorForPlayer(subItem, data.charName, data.world)
  end
  local columnWidth = rankingLocale.itemRankColumnWidth
  frame:InsertColumn(locale.ranking.rank, columnWidth[1], LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  frame:InsertColumn(locale.ranking.placing, columnWidth[2], LCCIT_STRING, RankSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "owner"), columnWidth[3], LCCIT_CHARACTER_NAME, OwnerSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "equipment_name"), columnWidth[4], LCCIT_STRING, GearNameSetFunc, nil, nil, GearNameLayoutFunc)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "gear_score"), columnWidth[5], LCCIT_STRING, GearScoreSetFunc, nil, nil, nil, nil)
  frame:InsertColumn("", columnWidth[6], LCCIT_STRING, ServerNameSetFunc, nil, nil, nil, nil)
  frame:InsertRows(20, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  local worldCombo
  function frame:RegisterCallbackWorldSelectedFunc(func)
    function worldCombo:SelectedProc(selIdx)
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
  local item_ranking_gear_score_tip = GetUIText(COMMON_TEXT, "ranking_tip_item_score_value")
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    local columnEnable = false
    if i == 5 then
      local column = frame.listCtrl.column[i]
      local function OnEnter(self)
        if item_ranking_gear_score_tip == "" then
          return
        end
        SetTooltip(item_ranking_gear_score_tip, self)
      end
      column:SetHandler("OnEnter", OnEnter)
    end
    if i == 6 then
      WorldLayoutFunc(frame.listCtrl.column[i])
    end
    frame.listCtrl.column[i]:Enable(columnEnable)
    SetButtonFontColor(frame.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  local insetInfo = {leftInset = 70, rightInset = 10}
  for i = 1, frame:GetRowCount() do
    ListCtrlItemGuideLine(frame.listCtrl.items, frame:GetRowCount(), insetInfo)
  end
  return frame
end
local CreateHeirExpRankingListCtrl = function(id, parent)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame:Show(true)
  frame:SetExtent(760, 516)
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
  local RankDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.rank))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.name))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local HeirLevelDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.heirLevel))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local HeirExpDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format("%.2f", string.sub(data.heirExpPercent, 1, 5)))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local ServerNameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.worldName))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local columnWidth = rankingLocale.heirExpColumnWidth
  frame:InsertColumn(locale.ranking.rank, columnWidth[1], LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  frame:InsertColumn(locale.ranking.placing, columnWidth[2], LCCIT_STRING, RankDataSetFunc, nil, nil, nil)
  frame:InsertColumn(locale.common.name, columnWidth[3], LCCIT_CHARACTER_NAME, NameDataSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "heir_level"), columnWidth[4], LCCIT_STRING, HeirLevelDataSetFunc, nil, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "ranking_exp_percent"), columnWidth[5], LCCIT_STRING, HeirExpDataSetFunc, nil, nil, nil)
  frame:InsertColumn("", columnWidth[6], LCCIT_STRING, ServerNameDataSetFunc, nil, nil, nil, nil)
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
    if i == 6 then
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
      self:InsertRowData(i, #self.listCtrl.column, rankDatas[i])
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
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.hp, string.format("%d", data.health))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.mp, string.format("%d", data.mana))
            str = makeTooltip(str, "%s%s: %s", F_COLOR.GetColor("bright_blue", true), GetUIText(COMMON_TEXT, "gear_score"), string.format("%d", data.gear))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.tooltip.leadership, string.format("%d", data.leadership))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_honor_point, string.format("%d", data.pvp_honor))
            str = makeTooltip(str, "%s%s: %s", FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_kill_point, string.format("%d", data.pvp_kill_count))
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
function CreateRenewalRankingAchievementWidget(id, parent, rewardWindow)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  widget.code = id
  widget.upperFrame = CreateAchievementRankUpperFrame("gearUpper", widget, rewardWindow)
  local gearRankList = CreateGearScoreRankingListCtrl("gearList", widget, 516)
  local itemRankList = CreateItemRankingListCtrl("itemList", widget, 516)
  local heirRankList = CreateHeirExpRankingListCtrl("heirList", widget)
  gearRankList:AddAnchor("TOPLEFT", widget.upperFrame, "BOTTOMLEFT", 0, 5)
  itemRankList:AddAnchor("TOPLEFT", widget.upperFrame, "BOTTOMLEFT", 0, 5)
  heirRankList:AddAnchor("TOPLEFT", widget.upperFrame, "BOTTOMLEFT", 0, 5)
  gearRankList:Show(false)
  itemRankList:Show(false)
  heirRankList:Show(false)
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
    if desc.code == "ranking_item_gear" then
      widget.rankLists[i] = gearRankList
    elseif desc.code == "ranking_heir_level" then
      widget.rankLists[i] = heirRankList
    else
      widget.rankLists[i] = itemRankList
    end
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
  local bottomGuide = W_ICON.CreateGuideIconWidget(widget)
  bottomGuide:AddAnchor("BOTTOMLEFT", widget, "BOTTOMLEFT", 0, 0)
  bottomGuide:Show(false)
  bottomGuide:SetHandler("OnEnter", OnEnter_HeirRankingGuide)
  local tip = widget:CreateChildWidget("textbox", "tip", 0, true)
  tip:Show(false)
  tip:SetExtent(760, FONT_SIZE.MIDDLE)
  tip:AddAnchor("BOTTOMLEFT", widget, "BOTTOMLEFT", 0, 0)
  tip:SetText(GetUIText(COMMON_TEXT, "ranking_tip_gear_score"))
  tip:SetHeight(tip:GetTextHeight())
  tip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  function widget:HideRewardWindow()
    rewardWindow:Show(false)
  end
  function widget:ChangeRankTypeUI(selectedRank)
    activeRankList:Show(false)
    activeRankList = widget.rankLists[selectedRank]
    activeRankList:Show(true)
  end
  widget:ChangeRankTypeUI(1)
  local achieveCombo = W_CTRL.CreateComboBox("achieveCombo", widget)
  achieveCombo:SetWidth(150)
  achieveCombo:AddAnchor("LEFT", rankKindLabel, "RIGHT", 5, 0)
  achieveCombo:AppendItems(datas, false)
  function widget:Activate()
    if achieveCombo:IsSelected() == false then
      achieveCombo:Select(1)
    end
    local index = achieveCombo:GetSelectedIndex()
    local rankDesc = rankings[index]
    if rankDesc.code == "ranking_item_gear" then
      widget:RefreshGearRanking()
    elseif rankDesc.code == "ranking_heir_level" then
      widget:RefreshHeirRanking()
    else
      widget:RefreshItemRanking()
    end
    parent:WaitPage(true)
  end
  function widget:SetBottomTooltip(idx)
    local ranking = rankings[idx]
    if ranking.code == "ranking_heir_level" then
      bottomGuide:Show(true)
      tip:RemoveAllAnchors()
      tip:AddAnchor("LEFT", bottomGuide, "RIGHT", 6, 0)
    else
      bottomGuide:Show(false)
      tip:RemoveAllAnchors()
      tip:AddAnchor("BOTTOMLEFT", widget, "BOTTOMLEFT", 0, 0)
    end
    tip:SetText(GetUIText(COMMON_TEXT, ranking.tooltip))
  end
  function achieveCombo:SelectedProc(idx)
    local ranking = rankings[idx]
    widget:HideRewardWindow()
    widget:SetBottomTooltip(idx)
    widget:ChangeRankTypeUI(idx)
    activeRankList:SetWorldInfo(ranking)
    widget:Activate()
  end
  widget.upperFrame:SetRankInfo(rankings[1])
  local function WorldSelected()
    widget:Activate()
  end
  for i = 1, #widget.rankLists do
    widget.rankLists[i]:RegisterCallbackWorldSelectedFunc(WorldSelected)
  end
  function widget:RefreshGearRanking()
    local selIdx = achieveCombo:GetSelectedIndex()
    if rankings[selIdx].code ~= "ranking_item_gear" then
      return
    end
    local worldIdx = activeRankList:GetSelectedWorldIdx()
    local ranking = rankings[selIdx]
    local division = ranking[worldIdx].id
    widget.upperFrame:SetRankInfo(ranking)
    X2Rank:RequestRankData(ranking.code, division)
  end
  function widget:RefreshItemRanking()
    local selIdx = achieveCombo:GetSelectedIndex()
    if rankings[selIdx].code == "ranking_item_gear" then
      return
    end
    local worldIdx = activeRankList:GetSelectedWorldIdx()
    local ranking = rankings[selIdx]
    local division = ranking[worldIdx].id
    widget.upperFrame:SetRankInfo(ranking)
    X2Rank:RequestItemRank(division, ranking.code)
  end
  function widget:RefreshHeirRanking()
    local selIdx = achieveCombo:GetSelectedIndex()
    if rankings[selIdx].code ~= "ranking_heir_level" then
      return
    end
    local worldIdx = activeRankList:GetSelectedWorldIdx()
    local ranking = rankings[selIdx]
    local division = ranking[worldIdx].id
    widget.upperFrame:SetRankInfo(ranking)
    X2Rank:RequestRankData(ranking.code, division)
  end
  function widget:Lock()
    widget.upperFrame:Lock()
  end
  function widget:Unlock()
    widget.upperFrame:Unlock()
  end
  function widget:FillRankData(rankDatas)
    local selIdx = achieveCombo:GetSelectedIndex()
    activeRankList:FillRankData(rankDatas, rankings[selIdx].code)
  end
  function widget:FillRewardInfo(rewardInfo, periodInfo)
  end
  function widget:FillMyRecord(myScore)
    widget.upperFrame:FillMyRecord(myScore, bottomGuide)
  end
  function widget:RefreshSeasonState()
    widget.upperFrame:RefreshSeasonState()
  end
  function widget:GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(achieveCombo, activeRankList)
    return height + sideMargin / 1.7
  end
  return widget
end
