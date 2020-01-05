local notifierData
local saveFlag = false
function SaveNotifierUiData()
  if saveFlag then
    X2:SetQuestNotifierListUiData(notifierData)
  end
end
function GetNotifierOpenState()
  return notifierData.listOpen
end
function SetNotifierOpenState(isOpen)
  notifierData.listOpen = isOpen
  SaveNotifierUiData()
end
function GetTodayQuestOpenState()
  return notifierData.todayQuestOpen
end
function SetTodayQuestOpenState(isOpen)
  notifierData.todayQuestOpen = isOpen
  SaveNotifierUiData()
end
function GetTodayArchePassQuestOpenState()
  return notifierData.todayArchePassQuestOpen
end
function SetTodayArchePassQuestOpenState(isOpen)
  notifierData.todayArchePassQuestOpen = isOpen
  SaveNotifierUiData()
end
function GetTodayExpeditionQuestOpenState()
  return notifierData.todayExpeditionQuestOpen
end
function SetTodayExpeditionQuestOpenState(isOpen)
  notifierData.todayExpeditionQuestOpen = isOpen
  SaveNotifierUiData()
end
function GetTodayFamilyQuestOpenState()
  return notifierData.todayExpeditionQuestOpen
end
function SetTodayFamilyQuestOpenState(isOpen)
  notifierData.todayFamilyQuestOpen = isOpen
  SaveNotifierUiData()
end
function GetHeroQuestOpenState()
  return notifierData.heroQuestOpen
end
function SetHeroQuestOpenState(isOpen)
  notifierData.heroQuestOpen = isOpen
  SaveNotifierUiData()
end
function GetRacialAchievementOpenState()
  return notifierData.racialAchievementOpen
end
function SetRacialAchievementOpenState(isOpen)
  notifierData.racialAchievementOpen = isOpen
  SaveNotifierUiData()
end
function GetGeneralAchievementOpenState()
  return notifierData.generalAchievementOpen
end
function SetGeneralAchievementOpenState(isOpen)
  notifierData.generalAchievementOpen = isOpen
  SaveNotifierUiData()
end
function GetCollectionAchievementOpenState()
  if notifierData.collectionAchievementOpen == nil then
    notifierData.collectionAchievementOpen = true
  end
  return notifierData.collectionAchievementOpen
end
function SetcollectionAchievementOpenState(isOpen)
  notifierData.collectionAchievementOpen = isOpen
  SaveNotifierUiData()
end
function GetNofifierHeight()
  return notifierData.openHeight
end
function SetNofifierHeight(height)
  notifierData.openHeight = height
  SaveNotifierUiData()
end
function GetNotifierQuestList()
  return notifierData.questList
end
function GetNotifierQuestListCount()
  return #notifierData.questList
end
function HasNotifierQuestList(qType)
  local questList = notifierData.questList
  for i = 1, #questList do
    if questList[i] == qType then
      return true
    end
  end
  return false
end
function AddNotifierQuestList(qType)
  notifierData.questList[#notifierData.questList + 1] = qType
  SaveNotifierUiData()
end
function GetTodayQuestList()
  return notifierData.todayQuestList
end
function GetTodayQuestListCount()
  return #notifierData.todayQuestList
end
function HasTodayQuestList(qType)
  local todayQuestList = notifierData.todayQuestList
  for i = 1, #todayQuestList do
    if todayQuestList[i] == qType then
      return true
    end
  end
  return false
end
local function AddTodayQuestList(qType)
  if #notifierData.todayQuestList >= todayNotifierLimit then
    return false
  end
  notifierData.todayQuestList[#notifierData.todayQuestList + 1] = qType
  SaveNotifierUiData()
  return true
end
local UpdateNotifierDecal = function(decalIndex, qType)
  if GetNotifierDecal(qType) ~= decalIndex then
    return
  end
  X2Decal:SetQuestGuidDecalByIndex(decalIndex, qType, true)
  X2Map:UpdateNotifyQuestInfo(decalIndex, qType, true)
end
function UpdateAllNotifierDecal()
  for i = 0, notifierData.maxDecalCount do
    if notifierData.decalStates[i] ~= 0 then
      UpdateNotifierDecal(i, notifierData.decalStates[i])
    end
  end
end
function SetNotifierDecal(decalIndex, qType)
  if decalIndex == nil or decalIndex > notifierData.maxDecalCount then
    return
  end
  if GetNotifierDecal(qType) ~= nil then
    return
  end
  notifierData.decalStates[decalIndex] = qType
  X2Decal:SetQuestGuidDecalByIndex(decalIndex, qType, true)
  X2Map:UpdateNotifyQuestInfo(decalIndex, qType, true)
  SaveNotifierUiData()
end
function RemoveNotifierDecal(decalIndex, qType)
  if qType == nil or qType == 0 then
    return
  end
  notifierData.decalStates[decalIndex] = 0
  X2Decal:SetQuestGuidDecalByIndex(decalIndex, qType, false)
  X2Map:RemoveNotifyQuestInfo(qType)
  SaveNotifierUiData()
end
function GetNotifierDecal(qType)
  if qType == nil or qType == 0 then
    return nil
  end
  for index = 0, notifierData.maxDecalCount do
    if qType == notifierData.decalStates[index] then
      return index
    end
  end
  return nil
end
function GetNotifierEmptyDecal(qType)
  if qType == nil or qType == 0 then
    return nil
  end
  if X2Quest:IsMainQuest(qType) then
    return 0
  end
  if X2Quest:IsTodayQuest(qType) then
    if notifierData.decalStates[notifierData.maxDecalCount] == 0 then
      return notifierData.maxDecalCount
    end
    return nil
  end
  for index = 1, notifierData.maxDecalCount - 1 do
    if notifierData.decalStates[index] == 0 then
      return index
    end
  end
  return nil
end
function CheckNotifierLimit()
  local questList = notifierData.questList
  local count = #questList
  if count >= notifierLimit then
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "QUEST_NOTIFIER_LIMIT"))
    return false
  end
  return true
end
local function InsertAndSortQuestNotifyList(qtype)
  local questList = notifierData.questList
  local count = #questList
  if count >= notifierLimit then
    return false
  end
  for i = 1, count do
    if questList[i] == qtype then
      return true
    end
  end
  if X2Quest:IsHiddenQuest(qtype) or X2Quest:IsTodayQuest(qtype) then
    return true
  end
  if X2Quest:IsMainQuest(qtype) then
    if count > 0 then
      for i = #questList, 1, -1 do
        local questType = questList[i]
        if X2Quest:IsMainQuest(questType) then
          questList[i + 1] = qtype
          break
        end
        questList[i + 1] = questType
        if i == 1 then
          questList[1] = qtype
        end
      end
    else
      questList[1] = qtype
    end
  else
    questList[count + 1] = qtype
  end
  notifierData.questList = questList
  return true
end
function SyncNotifierQuestList()
  local tempQuestList = {}
  local count = #notifierData.questList
  local index = 1
  local missMatch = false
  for i = 1, count do
    local questType = notifierData.questList[i]
    if IsExistQuestTypeInJournal(questType) then
      tempQuestList[index] = questType
      index = index + 1
    else
      missMatch = true
    end
  end
  if missMatch then
    notifierData.questList = nil
    notifierData.questList = tempQuestList
  end
end
local function SyncNotifierTodayQuestList()
  local tempQuestList = {}
  local missMatch = false
  local index = 1
  for i = 1, #notifierData.todayQuestList do
    local questType = notifierData.todayQuestList[i]
    if X2Achievement:IsTodayAssignmentQuest(TADT_MAX, questType) then
      tempQuestList[index] = questType
      index = index + 1
    else
      missMatch = true
    end
  end
  if missMatch then
    notifierData.todayQuestList = nil
    notifierData.todayQuestList = tempQuestList
  end
end
local function SyncNotifierQuestDecal()
  for i = 0, notifierData.maxDecalCount do
    local qType = notifierData.decalStates[i]
    if qType ~= nil and qType ~= 0 then
      local has = false
      local count = X2Quest:GetActiveQuestListCount()
      for i = 1, count do
        if X2Quest:GetActiveQuestType(i) == qType then
          has = true
          break
        end
      end
      if not has then
        RemoveNotifierDecal(i, qType)
      else
        X2Decal:SetQuestGuidDecalByIndex(i, qType, true)
        X2Map:UpdateNotifyQuestInfo(i, qType, true)
      end
    end
  end
end
local function InitEmptyNotifierData()
  if notifierData == nil then
    notifierData = {}
  end
  if notifierData.listOpen == nil then
    notifierData.listOpen = true
  end
  if notifierData.todayQuestOpen == nil then
    notifierData.todayQuestOpen = true
  end
  if notifierData.todayArchePassQuestOpen == nil then
    notifierData.todayArchePassQuestOpen = true
  end
  if notifierData.todayExpeditionQuestOpen == nil then
    notifierData.todayExpeditionQuestOpen = true
  end
  if notifierData.todayFamilyQuestOpen == nil then
    notifierData.todayFamilyQuestOpen = true
  end
  if notifierData.heroQuestOpen == nil then
    notifierData.heroQuestOpen = true
  end
  if notifierData.racialAchievementOpen == nil then
    notifierData.racialAchievementOpen = true
  end
  if notifierData.generalAchievementOpen == nil then
    notifierData.generalAchievementOpen = true
  end
  if notifierData.openHeight == nil then
    notifierData.openHeight = questContext.notifierGrid.height
  end
  local init = false
  if notifierData.questList == nil then
    notifierData.questList = {}
    init = true
  end
  notifierData.maxDecalCount = X2Decal:GetMaxDecalCount() - 1
  if notifierData.decalStates == nil then
    notifierData.decalStates = {}
    for i = 0, notifierData.maxDecalCount do
      notifierData.decalStates[i] = 0
    end
  end
  if notifierData.todayQuestList == nil then
    notifierData.todayQuestList = {}
  end
  return init
end
function InitQuestNotifierData()
  notifierData = X2:GetQuestNotifierListUiData()
  local init = InitEmptyNotifierData()
  local count = X2Quest:GetActiveQuestListCount()
  for i = 1, count do
    local qtype = X2Quest:GetActiveQuestType(i)
    if init or X2Quest:IsTaskQuest(qtype) then
      InsertAndSortQuestNotifyList(qtype)
    end
  end
  SyncNotifierQuestList()
  SyncNotifierQuestDecal()
  if saveFlag then
    SyncNotifierTodayQuestList()
  end
  saveFlag = true
  SaveNotifierUiData()
end
function FirstTimeInitQuestNotifierData()
  if saveFlag == false then
    InitQuestNotifierData()
  end
end
function UpdateNotifierQuestDecal()
  for i = 0, notifierData.maxDecalCount do
    local qType = notifierData.decalStates[i]
    if qType ~= nil and qType ~= 0 and X2Decal:CanMakeGuidedDecal(qType) then
      X2Decal:SetQuestGuidDecalByIndex(i, qType, true)
      X2Map:UpdateNotifyQuestInfo(i, qType, true)
    end
  end
end
local UpdateQuestGuideInfo = function(qType)
  if X2Quest:GetQuestDirInfo(qType) ~= nil then
    X2Decal:SetQuestGuidDecalByIndex(-1, qType, false)
  end
end
local function ExistMainQuest()
  for i = 1, #notifierData.questList do
    if X2Quest:IsMainQuest(notifierData.questList[i]) then
      return true
    end
  end
  return false
end
local function UpdateMainQuests(qType)
  local quests = {}
  for i = 1, #notifierData.questList do
    if X2Quest:IsMainQuest(notifierData.questList[i]) and qType ~= notifierData.questList[i] then
      table.insert(quests, notifierData.questList[i])
    end
  end
  for i = 1, #quests do
    RemoveQuestFromNotifier(quests[i])
  end
end
local function AddNotifierDecalState(decalIndex, qType)
  if decalIndex ~= nil and qType ~= nil then
    notifierData.decalStates[decalIndex] = qType
  end
end
function AddQuestToNotifier(qType)
  if X2Quest:IsMainQuest(qType) and ExistMainQuest() then
    UpdateMainQuests(qType)
    return true
  end
  if not IsExistQuestTypeInJournal(qType) then
    return true
  end
  local result = true
  if X2Quest:IsTodayQuest(qType) then
    if HasTodayQuestList(qType) then
      return true
    end
    result = AddTodayQuestList(qType)
  else
    if HasNotifierQuestList(qType) then
      return true
    end
    UpdateQuestGuideInfo(qType)
    result = InsertAndSortQuestNotifyList(qType)
  end
  local decalIndex = GetNotifierEmptyDecal(qType)
  local canDecal = X2Decal:CanMakeGuidedDecal(qType)
  if decalIndex ~= nil then
    if canDecal then
      SetNotifierDecal(decalIndex, qType)
    else
      AddNotifierDecalState(decalIndex, qType)
    end
  end
  local notifier = GetNotifierWnd()
  notifier:Refresh()
  SaveNotifierUiData()
  return result
end
function RemoveQuestFromNotifier(qType, trigger)
  local decalIndex = GetNotifierDecal(qType)
  local emptyIndex = GetNotifierEmptyDecal(qType)
  if decalIndex ~= nil then
    RemoveNotifierDecal(decalIndex, qType)
  end
  if trigger == nil then
    trigger = false
  end
  local list
  if X2Quest:IsTodayQuest(qType) then
    list = notifierData.todayQuestList
  else
    list = notifierData.questList
  end
  local count = #list
  local tempQuestList = {}
  local index = 1
  for i = 1, count do
    local questType = list[i]
    if questType ~= qType then
      tempQuestList[index] = questType
      index = index + 1
      if trigger and emptyIndex == nil then
        local canDecal = X2Decal:CanMakeGuidedDecal(questType)
        local index = GetNotifierDecal(questType)
        if index == nil and canDecal then
          SetNotifierDecal(decalIndex, questType)
          trigger = false
        end
      end
    end
  end
  if X2Quest:IsTodayQuest(qType) then
    notifierData.todayQuestList = nil
    notifierData.todayQuestList = tempQuestList
  else
    notifierData.questList = nil
    notifierData.questList = tempQuestList
  end
  local notifier = GetNotifierWnd()
  notifier:Refresh()
  SaveNotifierUiData()
end
function UpdateQuestInNotifier(qType)
  if X2Quest:IsTodayQuest(qType) then
    if not HasTodayQuestList(qType) then
      return
    end
  elseif not HasNotifierQuestList(qType) then
    UpdateQuestGuideInfo(qType)
    return
  end
  local decalIndex = GetNotifierDecal(qType)
  local enable = X2Decal:CanMakeGuidedDecal(qType)
  if enable then
    if decalIndex ~= nil then
      UpdateNotifierDecal(decalIndex, qType)
    end
  elseif decalIndex ~= nil then
    RemoveNotifierDecal(decalIndex, qType)
    local isChecked = GetQuestListCheckValue(qType)
    if isChecked ~= nil and isChecked == true then
      AddNotifierDecalState(decalIndex, qType)
    end
  end
  local notifier = GetNotifierWnd()
  notifier:Refresh()
  SaveNotifierUiData()
end
InitEmptyNotifierData()
