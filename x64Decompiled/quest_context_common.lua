local firstQuestType
function SetFitstQuestType(qtype)
  firstQuestType = qtype
end
function GetFitstQuestType()
  return firstQuestType
end
function IndexFromQuestType(questType)
  local qcount = X2Quest:GetActiveQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetActiveQuestType(i)
    if qtype == questType then
      return i
    end
  end
  return 0
end
function IsCompleteQuest(qtype)
  return X2Quest:GetActiveQuestListStatus(IndexFromQuestType(qtype)) == 3
end
function GetQuestObjectives(questIndex, questType)
  local objectveItems = {}
  local count = X2Quest:GetQuestJournalObjectiveCount(questIndex)
  local index = 1
  for i = 1, count do
    objectveItems[i] = X2Quest:GetActiveQuestObjectiveText(questType, i)
    if objectveItems[i] == false then
      objectveItems[i] = ""
    end
  end
  return objectveItems
end
function GetQuestObjectivesByType(questType)
  local objectveItems = {}
  local count = X2Quest:GetQuestJournalObjectiveCountByType(questType)
  local index = 1
  for i = 1, count do
    objectveItems[i] = X2Quest:GetActiveQuestObjectiveText(questType, i)
    if objectveItems[i] == false then
      objectveItems[i] = ""
    end
  end
  return objectveItems
end
function SetQuestReportObjective(questInfo)
  if #questInfo.objectives == 0 and questInfo.status == 3 then
    local npcName = X2Quest:GetQuestReportNpcNameByQuestType(questInfo.questType)
    if npcName ~= nil then
      local item = {}
      local obj = {}
      obj.category = "talk"
      obj.name = npcName
      item.object = obj
      questInfo.objectives[1] = item
    end
  end
end
function GetQuestInfo(idx, qtype)
  local item = {}
  item.questIndex = idx
  item.questType = qtype
  item.isMainQuest = X2Quest:IsMainQuest(qtype)
  item.title = X2Quest:GetQuestContextMainTitle(qtype)
  item.listTitle = X2Quest:GetActiveQuestTitle(qtype)
  item.summary = X2Quest:GetQuestContextSummary(qtype)
  item.body = X2Quest:GetQuestContextBody(qtype)
  item.status = X2Quest:GetActiveQuestListStatus(idx)
  item.letItDone = X2Quest:IsLetItDoneQuest(idx)
  item.overDone = X2Quest:IsOverDoneQuest(idx)
  item.objectives = GetQuestObjectives(idx, qtype)
  SetQuestReportObjective(item)
  item.questLevel = X2Quest:GetActiveQuestLevel(idx)
  item.Difficulty = X2Quest:GetActiveQuestComparedLevel(idx)
  item.category = X2Quest:GetQuestCategoryNameByQuestType(qtype)
  item.categoryType = X2Quest:GetQuestCategoryTypeByQuestType(qtype)
  item.chapterIdx = X2Quest:GetQuestContextQuestChapterIdxByType(qtype)
  item.isAggroComponent = X2Quest:NowIsAggroComponent(qtype)
  return item
end
function GetMainQuestInfo(idx, qtype)
  local item = {}
  item.questIndex = idx
  item.questType = qtype
  item.isMainQuest = X2Quest:IsMainQuest(qtype)
  item.title = X2Quest:GetQuestContextMainTitle(qtype)
  item.listTitle = X2Quest:GetActiveQuestTitle(qtype)
  item.summary = X2Quest:GetQuestContextSummary(qtype)
  item.body = X2Quest:GetQuestContextBody(qtype)
  item.status = X2Quest:GetActiveQuestListStatusByType(qtype)
  item.letItDone = X2Quest:IsLetItDoneQuest(idx)
  item.overDone = X2Quest:IsOverDoneQuest(idx)
  item.objectives = GetQuestObjectivesByType(qtype)
  SetQuestReportObjective(item)
  item.questLevel = X2Quest:GetActiveQuestLevelByType(qtype)
  item.Difficulty = X2Quest:GetActiveQuestComparedLevelByType(qtype)
  item.category = X2Quest:GetQuestCategoryNameByQuestType(qtype)
  item.categoryType = X2Quest:GetQuestCategoryTypeByQuestType(qtype)
  item.chapterIdx = X2Quest:GetQuestContextQuestChapterIdxByType(qtype)
  item.isAggroComponent = X2Quest:NowIsAggroComponent(qtype)
  item.isCompleted = X2Quest:IsCompleted(qtype)
  item.orgQuestIndex = X2Quest:GetQuestContextQuestIdxByType(qtype)
  item.isCinema = X2Quest:IsExistCinema(qtype)
  item.hideChapterIdx = X2Quest:GetQuestContextQuestIsHideChapterIdxByType(qtype)
  if item.isMainQuest == true then
    if item.isCompleted == true then
      item.listTitle = string.format("%d. %s", item.orgQuestIndex, item.title)
    end
    if item.status == 0 then
      item.listTitle = string.format("%d. ???", item.orgQuestIndex)
    end
    if item.chapterIdx == 1 and item.orgQuestIndex == 1 then
      SetFitstQuestType(qtype)
    end
  end
  return item
end
function AddableQuest(qtype)
  return not X2Quest:IsHiddenQuest(qtype) and not X2Quest:IsTaskQuest(qtype) and not X2Quest:IsTodayQuest(qtype)
end
function GetQuestItemsGroupedByCategory()
  local mainQuest = {}
  local zoneQuest = {}
  local mainCategoryGroup = {}
  local zoneCategoryGroup = {}
  local mainCount = 0
  local zoneCount = 0
  local subItemCount = 0
  local qcount = X2Quest:GetActiveQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetActiveQuestType(i)
    if AddableQuest(qtype) then
      local item = GetQuestInfo(i, qtype)
      if item.isMainQuest == false and zoneCategoryGroup[item.category] == nil then
        zoneCategoryGroup[item.category] = {}
        zoneCount = zoneCount + 1
      end
      if item.isMainQuest == false then
        item.tooltip = X2Quest:GetQuestCategoryTextByType(qtype) or ""
        table.insert(zoneCategoryGroup[item.category], item)
      end
    end
  end
  qcount = X2Quest:GetMainQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetMainQuestType(i)
    if AddableQuest(qtype) then
      local item = GetMainQuestInfo(i, qtype)
      if item.isMainQuest == true and mainCategoryGroup[item.chapterIdx] == nil then
        mainCategoryGroup[item.chapterIdx] = {}
        mainCount = mainCount + 1
      end
      if item.isMainQuest then
        local category = locale.questContext.Get_category(tonumber(item.chapterIdx)) or ""
        local subTitle = X2Quest:GetQuestJournalSubTitleByType(qtype) or ""
        if item.status == 0 then
          subTitle = "???"
        end
        if item.hideChapterIdx == true then
          category = ""
        end
        item.category = string.format("%s%s", category, subTitle)
        item.tooltip = item.category
        table.insert(mainCategoryGroup[item.chapterIdx], item)
      end
    end
  end
  mainQuest.categoryGroup = mainCategoryGroup
  zoneQuest.categoryGroup = zoneCategoryGroup
  return mainQuest, zoneQuest
end
function GetQuestItemGroupedByCategory(bMain, qtype)
  local questItem
  if bMain == true then
    local i = X2Quest:GetMainQuestVecIndex(qtype)
    if AddableQuest(qtype) then
      questItem = GetMainQuestInfo(i, qtype)
      local category = locale.questContext.Get_category(tonumber(questItem.chapterIdx)) or ""
      local subTitle = X2Quest:GetQuestJournalSubTitleByType(qtype) or ""
      if questItem.status == 0 then
        subTitle = "???"
      end
      if questItem.hideChapterIdx == true then
        category = ""
      end
      questItem.category = string.format("%s%s", category, subTitle)
      questItem.tooltip = questItem.category
    end
  else
    local i = X2Quest:GetZoneQuestVecIndex(qtype)
    if AddableQuest(qtype) then
      questItem = GetQuestInfo(i, qtype)
    end
  end
  local mergedQuests = GetLastMergedQuests()
  local categoryCount = table.getn(mergedQuests.categoryGroup)
  for i = 1, categoryCount do
    local questCount = table.getn(mergedQuests.categoryGroup[i])
    for j = 1, questCount do
      local quest = mergedQuests.categoryGroup[i][j]
      if quest.questType == qtype then
        mergedQuests.categoryGroup[i][j] = questItem
        SetLastMergedQuests(mergedQuests)
        break
      end
    end
  end
  return questItem
end
local lastmergedItem = {}
function GetLastMergedQuests()
  return lastmergedItem
end
function SetLastMergedQuests(quests)
  lastmergedItem = quests
end
function GetMergedQuests(bMain)
  local mainQuestItems, zoneQuestItems = GetQuestItemsGroupedByCategory()
  local index = 1
  local mergedItem = {}
  mergedItem.categoryGroup = {}
  if bMain == true then
    for _, item in pairs(mainQuestItems.categoryGroup) do
      mergedItem.categoryGroup[index] = item
      index = index + 1
    end
  else
    for _, item in pairs(zoneQuestItems.categoryGroup) do
      mergedItem.categoryGroup[index] = item
      index = index + 1
    end
  end
  mergedItem.count = index - 1
  SetLastMergedQuests(mergedItem)
  return mergedItem
end
function GetMergedQuest(bMain, qtype)
  return GetQuestItemGroupedByCategory(bMain, qtype)
end
local FlickeringTable = {}
local function GetFlickeringTime(qtype)
  local time = FlickeringTable[qtype]
  if time == nil or time < 0 then
    time = 0
  end
  return time
end
function SetFlickeringTime(qtype, time)
  if qtype == nil then
    return
  end
  FlickeringTable[qtype] = time
end
local notifierEvent = {
  END_QUEST_CHAT_BUBBLE = function(widget, playedBubble)
    if widget.bubbleWaitTime == 2000 then
      widget:ReleaseHandler("OnEvent")
      widget:SetHandler("OnUpdate", widget.OnUpdate)
    end
  end
}
function SetFlickeringHandler(widget, qtype)
  widget.questType = qtype
  widget.alpha = 1
  widget.dir = -1
  function widget:OnUpdate(dt)
    if self.bubbleWaitTime > 0 then
      self.bubbleWaitTime = self.bubbleWaitTime - dt
      return
    end
    self.alpha = self.alpha + dt / 400 * self.dir
    self.durationTime = self.durationTime - dt
    SetFlickeringTime(self.questType, self.durationTime)
    if 0 >= self.durationTime then
      self:ReleaseHandler("OnUpdate")
      self:SetAlpha(1)
      SetFlickeringTime(self.questType, 0)
      return
    end
    if self.alpha >= 1 then
      self.dir = -1
      self.alpha = 1
    elseif 0 >= self.alpha then
      self.dir = 1
      self.alpha = 0
    end
    self:SetAlpha(self.alpha)
  end
  local fliceringTime = GetFlickeringTime(widget.questType)
  if fliceringTime == questNotifyAnimationTime then
    widget.bubbleWaitTime = 2000
    widget.durationTime = fliceringTime
  else
    widget.bubbleWaitTime = 0
    widget.durationTime = fliceringTime
    widget:SetHandler("OnUpdate", widget.OnUpdate)
  end
  widget:SetHandler("OnEvent", function(this, event, ...)
    notifierEvent[event](widget, ...)
  end)
  widget:RegisterEvent("END_QUEST_CHAT_BUBBLE")
end
function SetLevelColor(w, item)
  local playerLevel = X2Unit:UnitLevel("player")
  local variable = math.floor((playerLevel + 1) / 5 + 0.5)
  local minQuestLevel = playerLevel - math.max(variable, 5)
  local color
  local isDaily, _ = X2Quest:IsDailyQuest(item.questType)
  local bMainQuest = X2Quest:IsMainQuest(item.questType)
  if X2Quest:IsTaskQuest(item.questType) then
    color = FONT_COLOR.QUEST_TASK
  elseif X2Quest:IsLivelihoodQuest(item.questType) or isDaily or X2Quest:IsGroupQuest(item.questType) and isDaily then
    color = FONT_COLOR.WHITE
  elseif item.questLevel - playerLevel >= 6 then
    color = FONT_COLOR.RED
  elseif item.questLevel - playerLevel >= 3 then
    color = FONT_COLOR.YELLOW_OCHER
  elseif item.questLevel - playerLevel < 3 and minQuestLevel < item.questLevel then
    color = FONT_COLOR.WHITE
  elseif minQuestLevel >= item.questLevel then
    color = FONT_COLOR.WHITE
  end
  if bMainQuest == true then
    if item.isCompleted == true then
      color = FONT_COLOR.DEFAULT
    else
      color = FONT_COLOR.WHITE
    end
  end
  ApplyTextColor(w, color)
  SetFlickeringHandler(w, item.questType)
  return w
end
function IsExistQuestTypeInJournal(qType)
  local count = X2Quest:GetActiveQuestListCount()
  for i = 1, count do
    if X2Quest:GetActiveQuestType(i) == qType then
      if X2Quest:IsMainQuest(qType) == true then
        if X2Quest:GetActiveQuestListStatusByType(qType) ~= 0 and X2Quest:IsCompleted(qType) == false then
          return true
        end
      else
        return true
      end
    end
  end
  return false
end
