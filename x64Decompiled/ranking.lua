local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateRankingContent(id, parent, tabCodes)
  local contents = {}
  local rewardWndEx = CreateRenewaledRewardWindow("rewardWindowEx", parent)
  local rewardWnd = CreateRewardWindow("rewardWindow", parent)
  rewardWndEx:Show(false)
  rewardWnd:Show(false)
  for i = 1, #tabCodes do
    local code = tabCodes[i]
    local content
    if featureSet.rankingRenewal == true then
      if code == "tab_ranking_battlefield" then
        content = CreateRenewalRankingBattleFieldWidget(code, parent, rewardWndEx)
      elseif code == "tab_ranking_achievement" then
        content = CreateRenewalRankingAchievementWidget(code, parent, rewardWndEx)
      elseif code == "tab_ranking_expedition" then
        content = CreateExpeditionWidget(code, parent)
      else
        content = CreateCommonRankingWidget(code, parent, rewardWnd)
      end
    else
      content = CreateCommonRankingWidget(code, parent, rewardWnd)
    end
    if content ~= nil then
      contents[i] = content
    end
  end
  return contents
end
function ActivateContent(frame)
  if frame.content ~= nil then
    if frame.content.HideRewardWindow ~= nil then
      frame.content:HideRewardWindow()
    end
    frame.content:Show(false)
  end
  frame.content = frame.contents[selectedRankTabIdx]
  frame.content:Show(true)
  frame:SetHeight(frame.content:GetContentHeight() + BUTTON_SIZE.TAB_SELECT.HEIGHT + titleMargin + sideMargin + 30)
end
function SetViewOfRankingWindow(id, parent)
  local frame = CreateWindow(id, parent)
  frame:SetExtent(800, 705)
  frame:SetTitle(locale.ranking.title)
  frame:SetSounds("ranking")
  frame:SetCloseOnEscape(true, true)
  frame.valueInfos = {}
  local tabCodes = {}
  local tabName = {}
  local renewaledRankingCount = 0
  if featureSet.rankingRenewal == true then
    local renewalRankings = X2Rank:GetRankingTabs()
    for i = 1, #renewalRankings do
      local ranking = renewalRankings[i]
      table.insert(tabCodes, ranking.code)
      table.insert(tabName, GetUIText(COMMON_TEXT, ranking.name))
    end
    renewaledRankingCount = #renewalRankings
  end
  local info = X2Rank:GetRankInfo()
  for i = 1, X2Rank:GetRankCount() do
    if info[i] ~= nil then
      table.insert(tabCodes, string.format("%s%s", "legacy", info[i].code))
      table.insert(tabName, info[i].name)
      frame.valueInfos[i + renewaledRankingCount] = {}
      frame.valueInfos[i + renewaledRankingCount].v1 = info[i].v1
      frame.valueInfos[i + renewaledRankingCount].v2 = info[i].v2
      frame.valueInfos[i + renewaledRankingCount].processExplain = info[i].process_explain
      frame.valueInfos[i + renewaledRankingCount].valueColumnTooltip = info[i].value_column_tooltip
      frame.valueInfos[i + renewaledRankingCount].guideDesc = info[i].guide_desc
    end
  end
  local tab = W_BTN.CreateTab("tab", frame)
  tab:AddTabs(tabName)
  frame.contents = CreateRankingContent("content", frame, tabCodes)
  for i = 1, #frame.contents do
    if frame.contents[i] ~= nil then
      frame.contents[i]:AddAnchor("TOPLEFT", frame, sideMargin, titleMargin + sideMargin * 1.5)
      frame.contents[i]:AddAnchor("BOTTOMRIGHT", frame, -sideMargin, -sideMargin)
      frame.contents[i]:Show(false)
    end
  end
  ActivateContent(frame)
  local modalLoadingWindow = CreateLoadingTextureSet(frame)
  modalLoadingWindow:AddAnchor("TOPLEFT", frame.contents[1], -sideMargin + 1, 0)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", frame, -1, 0)
  onlyPlayerRecordUpdate = false
  return frame
end
function CreateRankingWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = SetViewOfRankingWindow(id, parent)
  local function OnTabChanged(self, selected)
    if selectedRankTabIdx == selected then
      return
    end
    selectedRankTabIdx = selected
    ActivateContent(frame)
    ReAnhorTabLine(self, selected)
    onlyPlayerRecordUpdate = false
    frame.content.tip:Show(true)
    F_SOUND.PlayUISound("event_tab_changed_raking", true)
    frame.content:Activate(selectedRankTabIdx)
  end
  frame.tab:SetHandler("OnTabChanged", OnTabChanged)
  function frame:ShowProc()
    frame.content:Activate(selectedRankTabIdx)
    frame.content.tip:Show(true)
  end
  local function FillRankingTypeUnit()
    if frame.valueInfos[selectedRankTabIdx] == nil then
      return
    end
    local str = ""
    local v1 = frame.valueInfos[selectedRankTabIdx].v1
    local v2 = frame.valueInfos[selectedRankTabIdx].v2
    local processExplain = frame.valueInfos[selectedRankTabIdx].processExplain
    local valueColumnTooltip = frame.valueInfos[selectedRankTabIdx].valueColumnTooltip
    local guideDesc = frame.valueInfos[selectedRankTabIdx].guideDesc
    local rankKind = X2Rank:GetRankKind(selectedRankTabIdx)
    if rankKind == RANKING.TAB_BATTLEFIELD then
      str = string.format("%s / %s", v1, v2)
    elseif rankKind == RANKING.TAB_FISH_LENGTH then
      str = rankingLocale:GetStringBySpace(v1 or v2, string.format("(%s)", GetUIText(COMMON_TEXT, "centimeter")))
    elseif rankKind == RANKING.TAB_FISH_WEIGHT then
      str = rankingLocale:GetStringBySpace(v1 or v2, string.format("(%s)", GetUIText(COMMON_TEXT, "kilogram")))
    else
      str = string.format("%s", v1 or v2)
    end
    frame.content:RefreshRankTypeUI(str, valueColumnTooltip, processExplain, guideDesc)
  end
  local function FillMyRecord(myCurRecord)
    if myCurRecord == nil then
      return
    end
    local str = string.format("%s:", GetUIText(RANKING_TEXT, "my_cur_record"))
    local v1 = myCurRecord.v1
    local v2 = myCurRecord.v2
    local rankKind = X2Rank:GetRankKind(selectedRankTabIdx)
    if rankKind == RANKING.TAB_BATTLEFIELD or rankKind == RANKING.TAB_GEAR_SCORE then
      str = string.format("%s %s/%s", str, v1, v2)
    elseif rankKind == RANKING.TAB_FISH_LENGTH then
      str = rankingLocale:GetStringBySpace(string.format("%s %.2f", str, tonumber(v1 or v2) / 1000), GetUIText(COMMON_TEXT, "centimeter"))
    elseif rankKind == RANKING.TAB_FISH_WEIGHT then
      str = rankingLocale:GetStringBySpace(string.format("%s %.2f", str, tonumber(v1 or v2) / 1000), GetUIText(COMMON_TEXT, "kilogram"))
    else
      str = string.format("%s %s", str, v1 or v2)
    end
    frame.content.upperFrame.myCurRecord:SetText(str)
  end
  local function FillRewardInfo(rewardInfo, periodInfo)
    frame.content:FillRewardInfo(rewardInfo, periodInfo)
  end
  local function FillSnapshot(snapShotInfo, snapshotScopeInfo)
    if snapShotInfo == nil then
      return
    end
    frame.content:FillSnapshot(snapShotInfo, snapshotScopeInfo)
  end
  local function FillPeriod(periodInfo)
    if periodInfo == nil then
      return
    end
    local startFilter = rankingLocale.timeFilter.periodStart
    local endFilter = rankingLocale.timeFilter.periodEnd
    local str = string.format("%s: %s", locale.common.period, locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter)))
    if periodInfo.periodEnd.year <= 2010 or periodInfo.periodStart.year <= 2010 then
      str = string.format("%s: ", locale.common.period)
    end
    frame.content.upperFrame:FillPeriod(str, X2Rank:IsActivatedPeriod())
  end
  local function FillUpdateTime(updateTimeInfo)
    if updateTimeInfo == nil then
      return
    end
    local remainHour = 0
    local remainMinute = 0
    local timeStr = ""
    if updateTimeInfo.term.hour ~= nil and updateTimeInfo.prev.hour ~= nil and updateTimeInfo.term.minute ~= nil and updateTimeInfo.prev.minute ~= nil then
      local timeTable = {
        year = 0,
        month = 0,
        day = 0,
        hour = updateTimeInfo.term.hour,
        minute = updateTimeInfo.term.minute,
        second = 0
      }
      timeStr = locale.time.GetRemainDateToDateFormat(timeTable, DEFAULT_FORMAT_FILTER)
    end
    local str = string.format("%s %s (%s)", locale.time.GetDateToDateFormat(updateTimeInfo.prev, DEFAULT_FORMAT_FILTER), locale.ranking.standard, locale.ranking.updateTip(timeStr))
    frame.content.updateTime:SetText(str)
  end
  local events = {
    RANK_PLAYER_RECORDS = function()
      local tabSelected = X2Rank:GetSelectedTabIndex()
      if tabSelected == 0 then
        frame:WaitPage(false)
        return
      end
      frame.tab:SelectTab(tabSelected)
      local playerRecord = X2Rank:GetPlayerRecord()
      if playerRecord == nil then
        frame:WaitPage(false)
        return
      end
      if onlyPlayerRecordUpdate then
        FillMyRecord(playerRecord)
        onlyPlayerRecordUpdate = false
        return
      end
      X2Rank:RequestRankSnapshots()
    end,
    RANK_SNAPSHOTS = function()
      local snapShotInfo = X2Rank:GetSnapshot()
      if snapShotInfo == nil then
        frame:WaitPage(false)
        return
      end
      FillRankingTypeUnit()
      local playerRecord = X2Rank:GetPlayerRecord()
      FillMyRecord(playerRecord)
      local periodInfo = X2Rank:GetResetPeriod()
      FillPeriod(periodInfo)
      local updateTimeInfo = X2Rank:GetSnapshotUpdatedTime()
      FillUpdateTime(updateTimeInfo)
      local snapshotScopeInfo = X2Rank:GetSnapshotScope()
      FillSnapshot(snapShotInfo, snapshotScopeInfo)
      local rewardInfo = X2Rank:GetReward()
      FillRewardInfo(rewardInfo, periodInfo.periodReward)
      frame:WaitPage(false)
    end,
    RANK_LOCK = function()
      for i = 1, #frame.tab.unselectedButton do
        frame.tab.unselectedButton[i]:Enable(false)
      end
      frame.content:Lock()
    end,
    RANK_UNLOCK = function()
      for i = 1, #frame.tab.unselectedButton do
        frame.tab.unselectedButton[i]:Enable(true)
      end
      frame.content:Unlock()
    end,
    RANK_DATA_RECEIVED = function(division, rankType)
      local rankData = X2Rank:GetRankData(division, rankType)
      local myScore = X2Rank:GetMyRankScore(rankType, division)
      frame.content:FillRankData(rankData)
      frame.content:FillMyRecord(myScore)
      frame.content:RefreshSeasonState()
      frame:WaitPage(false)
    end,
    RANK_SEASON_RESULT_RECEIVED = function(division, rankType)
      local data = X2Rank:GetRankingSeasonResult(division, rankType)
      frame.content:FillRankData(data)
      frame.content:RefreshSeasonState()
      frame:WaitPage(false)
    end,
    RANKER_APPEARANCE_LOADED = function(charID)
      targetEquippedItem:Show(true)
    end,
    ENTERED_WORLD = function(firstEnter)
      if featureSet.rankingRenewal == true and firstEnter == true then
        X2Rank:RequestMyWorldInitialData()
      end
    end,
    HEIR_LEVEL_UP = function(isMyLevelUp)
      if featureSet.rankingRenewal == true and isMyLevelUp == true then
        X2Rank:RequestMyWorldInitialData()
      end
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end, false)
  RegistUIEvent(frame, events)
  return frame
end
local rankingWindow
if featureSet.ranking then
  rankingWindow = CreateRankingWindow("rankingWindow", "UIParent")
  rankingWindow:Show(false)
  rankingWindow:AddAnchor("CENTER", "UIParent", 0, 0)
end
function ToggleRankingWindow(show)
  if rankingWindow == nil then
    return
  end
  if show == nil then
    show = not rankingWindow:IsVisible()
  end
  rankingWindow:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_RANK, ToggleRankingWindow)
