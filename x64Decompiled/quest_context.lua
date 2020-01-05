function StartQuestContext(who, qtype, stype, doodadId, npcId)
  X2Quest:TryStartQuestContext(who, qtype, stype, doodadId, npcId)
end
local ToggleQuestContextWindow = function(show)
  if show == nil then
    show = not questContext.contextListBack:IsVisible()
  end
  if show then
    if not questContext.contextListBack:IsVisible() then
      questContext.contextListBack:Show(true)
      if questContext.contextListBack.tab.window[2]:IsVisible() then
        if questContext.contextListBack.alarmIcon:IsVisible() then
          questContext.contextListBack.alarmIcon:Show(false)
        end
        if main_menu_bar.alarmIcon:IsVisible() then
          main_menu_bar.alarmIcon:Show(false)
        end
      end
    else
      F_SOUND.PlayUISound("event_quest_list_changed", true)
    end
  elseif questContext.contextListBack:IsVisible() then
    questContext.contextListBack:Show(false)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_QUEST_LIST, ToggleQuestContextWindow)
local ClearQuestValues = function(qtype)
  ClearDetailInfosCompareQuestType(qtype)
  RemoveQuestFromNotifier(qtype, true)
  RemoveQuestListCheckBoxState(qtype)
end
local questNotifyAnimationTime = 6000
function UpdateQuestContext(qtype, status)
  UpdateQuestListData(qtype, status)
  if status ~= nil and status == "updated" then
    RefreshQuestUI(qtype, status)
  else
    RefreshAllQuestUI(false, qtype, status)
  end
  UpdateQuestList(qtype, status)
  local tabWind
  if qtype ~= nil then
    if X2Quest:IsMainQuest(qtype) == false then
      tabWind = questContext.contextListBack.tab.window[1]
    elseif AddableQuest(qtype) then
      tabWind = questContext.contextListBack.tab.window[2]
      qstatus = X2Quest:GetActiveQuestListStatusByType(qtype)
      if (status == "started" or status == "updated") and (qstatus == 1 or qstatus == 3) then
        main_menu_bar.alarmIcon:Show(true)
        questContext.contextListBack.alarmIcon:Show(true)
      end
    end
    if status == "started" then
      SetFlickeringTime(qtype, questNotifyAnimationTime)
      X2:StopChatBubble(qtype)
      local result = AddQuestToNotifier(qtype)
      if not result then
        RemoveQuestListCheckBoxState(qtype)
      end
    elseif status == "completed" then
      ClearQuestValues(qtype)
    elseif status == "dropped" then
      tabWind.journal:SetCurQuestType(qtype)
      ClearQuestValues(qtype)
    elseif status == "updated" then
      UpdateQuestInNotifier(qtype)
    end
  end
  RefreshDetailWindow(tabWind)
  if IsAllCompleted() == true then
    return
  end
  if AddableQuest(qtype) then
    if status == "started" or status == "updated" or status == "completed" then
      if status == "completed" then
        if qtype == 5811 or qtype == 6839 or qtype == 6840 or qtype == 6841 or qtype == 6842 then
          local firstQtype = GetFitstQuestType()
          SelectQuestList(firstQtype)
        else
          SelectQuestList(qtype)
        end
      else
        SelectQuestList(qtype)
      end
      if X2Quest:IsMainQuest(qtype) == false then
        questContext.contextListBack.tab:SelectTab(1)
      else
        questContext.contextListBack.tab:SelectTab(2)
      end
      FillDetailInfos(qtype)
    elseif status == "dropped" and X2Quest:IsMainQuest(qtype) == true then
      SetQuestListState(false, false)
    end
  end
end
function ProgressTalkQuest(qType, npcId)
  local count = X2Quest:GetActiveQuestListCount()
  for i = 1, count do
    local talkData = X2Quest:GetNpcQuestContextQuestTypeTalk(i)
    if talkData ~= nil then
      local quest = talkData.qtype
      local questC = talkData.ctype
      local questA = talkData.atype
      X2Quest:TryProgressTalkQuestComponent(quest, questC, questA, npcId)
    end
  end
end
local questContextEvents = {
  START_QUEST_CONTEXT = function(qtype)
    StartQuestContext(0, qtype, 0, "", "")
  end,
  START_QUEST_CONTEXT_NPC = function(qtype, useDirectingMode, npcId)
    if useDirectingMode == false then
      StartQuestContext(1, qtype, 0, "", npcId)
    end
  end,
  START_QUEST_CONTEXT_DOODAD = function(qtype, useDirectingMode, doodadId)
    if useDirectingMode == false then
      StartQuestContext(2, qtype, 0, doodadId, "")
    end
  end,
  START_QUEST_CONTEXT_SPHERE = function(qtype, stype)
    StartQuestContext(3, qtype, stype, "", "")
  end,
  PROGRESS_TALK_QUEST_CONTEXT = function(qtype, useDirectingMode, npcId)
    if useDirectingMode == false then
      ProgressTalkQuest(qtype, npcId)
    end
  end,
  DOMINION = function(action)
    if action == "owner_changed" then
      RefreshAllQuestUI()
    end
  end,
  QUEST_CONTEXT_UPDATED = UpdateQuestContext,
  QUEST_CONTEXT_OBJECTIVE_EVENT = function(objText)
    AddMessageToQuestNotifyMessage(objText)
  end,
  QUEST_CONTEXT_CONDITION_EVENT = function(objText, condition)
    local msg = X2Quest:GetActiveQuestContextConditionMessage()
    AddMessageToQuestNotifyMessage(msg)
    X2Chat:DispatchChatMessage(CMF_QUEST_INFO, msg)
  end,
  QUEST_ERROR_INFO = function(errNum, questType, questDetail)
    local str = ""
    if questDetail ~= nil and questDetail ~= "" then
      str = locale.questContext.errors[errNum](questDetail)
    else
      str = locale.questContext.errors[errNum]
    end
    AddMessageToSysMsgWindow(str)
    if errNum ~= QSTATFAILED_MAYBE_QUEST_LIST_FULL then
      return
    end
    local arrow = questContext.contextListBack.tab.window[1].guide.arrow
    if not questContext.contextListBack:IsVisible() then
      UpdateQuestFullAnim(true)
      return
    end
    if arrow:IsVisible() then
      return
    end
    arrow:Animation(true, false)
  end,
  LEVEL_CHANGED = function(_, stringId)
    if not W_UNIT.IsMyUnitId(stringId) then
      return
    end
    RefreshAllQuestUI()
  end,
  ENTERED_WORLD = function()
    InitQuestListData(true)
    RefreshAllQuestUI(true)
    if IsAllCompleted() == false then
      main_menu_bar.alarmIcon:Show(true)
      questContext.contextListBack.alarmIcon:Show(true)
    end
  end,
  LEFT_LOADING = function()
    InitQuestListData(true)
    RefreshAllQuestUI(true)
    UpdateCurrentQuestNotifier()
  end,
  QUEST_NOTIFIER_START = function()
    InitQuestListData(true)
    RefreshAllQuestUI(true)
  end,
  UI_RELOADED = function()
    InitQuestListData(true)
    RefreshAllQuestUI(true)
    if IsAllCompleted() == false then
      main_menu_bar.alarmIcon:Show(true)
      questContext.contextListBack.alarmIcon:Show(true)
    end
  end
}
questContext:SetHandler("OnEvent", function(this, event, ...)
  questContextEvents[event](...)
end)
RegistUIEvent(questContext, questContextEvents)
function RefreshAllQuestUI(bEnterWorld, qtype, status)
  if bEnterWorld == nil then
    bEnterWorld = false
  end
  MakeQuestList(bEnterWorld, qtype, status)
  SetQuestListState(bEnterWorld, true)
  if bEnterWorld == true then
    ProgressMainQuestsFolderOpen()
  end
end
function RefreshQuestUI(qtype, status)
  if qtype == nil or status == nil then
    return
  end
  MakeQuestList(false, qtype, status)
  if X2Quest:IsMainQuest(qtype) then
    UpdateMainQuestListState(qtype, false, true)
  end
end
local folderEvents = {
  FOLDER_STATE_CHANGED = function(arg)
    if arg == nil or arg == "" then
      return
    end
    local folder = GetQuestFolderByName(arg)
    if folder ~= nil then
      SetQuestFolderState(folder.categoryType, folder:GetState())
    end
    local scrollWnd = questContext.contextListBack.tab.window[1].scrollWnd
    scrollWnd.emptyWidget:SetHeight(GetFolderListTotalHeight(false))
    ResetEmptyWidgetListScroll(scrollWnd, scrollWnd.emptyWidget)
    scrollWnd = questContext.contextListBack.tab.window[2].scrollWnd
    scrollWnd.emptyWidget:SetHeight(GetFolderListTotalHeight(true))
    ResetEmptyWidgetListScroll(scrollWnd, scrollWnd.emptyWidget)
  end
}
questContext.contextListBack:SetHandler("OnEvent", function(this, event, ...)
  folderEvents[event](...)
end)
questContext.contextListBack:RegisterEvent("FOLDER_STATE_CHANGED")
