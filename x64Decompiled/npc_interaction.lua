PRIEST_NPC = 5
STABLER_NPC = 7
BATTLE_GROUND_RECRUITER = 8
LOOKCONVERTER_NPC = 15
local SetInteractionWindows = function()
  interactionWindows = {}
  interactionWindows[STABLER_NPC] = {}
  interactionWindows[STABLER_NPC].window = GetStablerMessageBoxHandleWindow()
  interactionWindows[STABLER_NPC].Toggle = nil
  interactionWindows[BATTLE_GROUND_RECRUITER] = {}
  interactionWindows[BATTLE_GROUND_RECRUITER].window = instanceEntrance
  interactionWindows[BATTLE_GROUND_RECRUITER].Toggle = ToggleInstanceEntrance
  interactionWindows[LOOKCONVERTER_NPC] = {}
  interactionWindows[LOOKCONVERTER_NPC].window = changeItemLookWindow
  interactionWindows[LOOKCONVERTER_NPC].Toggle = ToggleChangeItemLookWindow
end
UIParent:SetEventHandler("ENTERED_WORLD", SetInteractionWindows)
local preInteractionNum
local IgnoreVisibleCheck = function(num, addedValue)
  if num == BATTLE_GROUND_RECRUITER or num == AUCTION_NPC then
    return not addedValue
  end
  return false
end
function ShowInteraction(num, addedValue)
  if IgnoreVisibleCheck(num, addedValue) == false and interactionWindows[num].window ~= nil and interactionWindows[num].window:IsVisible() == true then
    return
  end
  if preInteractionNum ~= nil then
    local preInteraction = interactionWindows[preInteractionNum]
    if preInteractionNum ~= num and preInteraction.window ~= nil and preInteraction.window:IsVisible() then
      preInteraction.window:Show(false)
    end
    preInteractionNum = nil
  end
  local activated = true
  if interactionWindows[num].Toggle ~= nil then
    activated = interactionWindows[num].Toggle(true, num, addedValue)
  elseif interactionWindows[num].window ~= nil then
    interactionWindows[num].window:Show(true)
  else
    return
  end
  if not activated then
    return
  end
  preInteractionNum = num
  if interactionWindows[num].window == nil then
    return
  end
  interactionWindows[num].window:AddAnchor("LEFT", "UIParent", 100, 0)
  if num == BANKER_NPC or num == TRADER_NPC or num == AUCTION_NPC then
    interactionWindows[num].window:Init()
  elseif num == STORE_NPC then
    X2Store:SetStoreOpenType(0)
    interactionWindows[num].window:Init()
  elseif num == BLACK_SMITH then
    interactionWindows[num].window:Init()
    interactionWindows[num].window:RemoveAllAnchors()
    interactionWindows[num].window:AddAnchor("CENTER", "UIParent", 0, 0)
  end
  if interactionWindows[num].window.Update ~= nil then
    interactionWindows[num].window:Update()
  end
end
local GetCompleteNpcQuestType = function()
  local completeCount = X2Quest:GetNpcQuestContextCountComplete()
  if completeCount > 0 then
    return X2Quest:GetNpcQuestContextQuestTypeComplete()
  end
  return 0
end
function CanCompleteNpcQuest()
  local qtype = GetCompleteNpcQuestType()
  if qtype == 0 then
    return false
  end
  return true
end
function DoNpcQuestComplete(npcId)
  local qtype = GetCompleteNpcQuestType() or 0
  if qtype ~= 0 then
    X2Quest:CallQuestUi(2, qtype, npcId)
  end
end
function DoAcceptNpcQuest(qtype, npcId)
  X2Quest:CallQuestUi(0, qtype, npcId)
end
local GetBestPriorityNpcQuestType = function()
  local startCount = X2Quest:GetNpcQuestContextCountStart()
  if startCount > 0 then
    return X2Quest:GetNpcQuestContextQuestTypeStart(1)
  end
  return 0
end
local CanQuestTalk = function()
  local talkCount = X2Quest:GetNpcQuestContextCountTalk()
  if talkCount > 0 then
    return true
  end
  return false
end
local DoQuestTalk = function(npcId)
  local count = X2Quest:GetActiveQuestListCount()
  for i = 1, count do
    local talkData = X2Quest:GetNpcQuestContextQuestTypeTalk(i)
    if talkData ~= nil then
      local quest = talkData.qtype
      local questC = talkData.ctype
      X2Quest:CallQuestTalk(quest, questC, npcId)
    end
  end
end
local function StartQuest(value, npcId)
  if value == "talk" and CanQuestTalk() == true then
    DoQuestTalk(npcId)
    return
  end
  if value == "complete" and CanCompleteNpcQuest() then
    DoNpcQuestComplete(npcId)
    return
  end
  if value == "start" then
    local qtype = GetBestPriorityNpcQuestType()
    if qtype ~= nil and qtype ~= 0 then
      DoAcceptNpcQuest(qtype, npcId)
      return
    end
  end
end
local function NpcInteractionStart(value, addedValue, npcId)
  if value == "stabler" then
    ShowInteraction(STABLER_NPC)
  elseif value == "recruiter" then
    ShowInteraction(BATTLE_GROUND_RECRUITER, addedValue)
  elseif value == "quest" or value == nil then
    StartQuest(addedValue, npcId)
  elseif value == "look_converter" then
    ShowInteraction(LOOKCONVERTER_NPC)
  end
end
UIParent:SetEventHandler("NPC_INTERACTION_START", NpcInteractionStart)
local NpcInteractionEnd = function()
  X2Interaction:CancelNPCInteraction()
end
UIParent:SetEventHandler("NPC_INTERACTION_END", NpcInteractionEnd)
