AIBehaviour.follow_path = {
  Name = "follow_path",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("follow_path")
    X2AI:AttackReservedTarget(entity)
    entity.AI.damaged = false
    if entity.AI.param.aiPathSkillLists ~= nil and table.getn(entity.AI.param.aiPathSkillLists) > 0 then
      entity.unit:StartAiSkillLists(PHASE_TYPE_FOLLOW_PATH, entity.AI.param.aiPathSkillLists)
    end
    AI.SetPathToFollow(entity.id, entity.AI.followPathName)
    AI.SetPathAttributeToFollow(entity.id, true)
    local usePointList = false
    local loop = 0
    if entity.AI.followPathType == PT_LOOP then
      usePointList = true
      loop = -1
    end
    AI.BeginGoalPipe("followPath")
    AI.PushGoal("bodypos", 1, BODYPOS_RELAX)
    AI.PushGoal("run", 1, entity.AI.followPathSpeed)
    AI.PushGoal("followpath", 1, false, false, false, loop, 10, usePointList, false)
    AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "OnFollowPathEnded")
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "followPath")
  end,
  Destructor = function(self, entity)
    entity.unit:EndAiSkillLists()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "_first_")
  end,
  OnAlertTargetChanged = function(self, entity, sender, data)
    local laPos = AI.GetPathFollowLAPos(entity.id)
    if IsNotNullVector(laPos) then
      entity.AI.idlePos = laPos
    end
    AIBehaviour.DEFAULT:OnAlertTargetChanged(entity, sender, data)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    if entity.AI.param.aiPathDamageSkillLists ~= nil and table.getn(entity.AI.param.aiPathDamageSkillLists) > 0 then
      if entity.AI.damaged == false then
        entity.unit:StartAiSkillLists(PHASE_TYPE_FOLLOW_PATH, entity.AI.param.aiPathDamageSkillLists)
        entity.AI.damaged = true
      end
    else
      entity.unit:EndAiSkillLists()
      entity.AI.damaged = false
      local pos = entity:GetPos()
      AI.SetRefPointPosition(entity.id, pos)
      AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
      AI.Signal(SIGNALFILTER_SENDER, AISIGNAL_INCLUDE_DISABLED, "GO_TO_COMBAT", entity.id)
    end
  end,
  OnNoAggroTarget = function(self, entity, sender, data)
    if entity.AI.param.aiPathSkillLists ~= nil and table.getn(entity.AI.param.aiPathSkillLists) > 0 then
      entity.unit:StartAiSkillLists(PHASE_TYPE_FOLLOW_PATH, entity.AI.param.aiPathSkillLists)
      entity.AI.damaged = false
    end
  end,
  OnPathStuck = function(self, entity, sender, data)
    if entity.AI.commandSet.canInteract then
      entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "common_WaitFiveSec")
    end
  end,
  OnFiveSecPassed = function(self, entity, sender, data)
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "followPath")
  end,
  OnFollowPathEnded = function(self, entity, sender, data)
    local followPathType = entity.AI.followPathType
    if followPathType == PT_NONE or followPathType == PT_REMOVE then
      local npcRemoveTime = 9
      entity.unit:NpcRemoveAfter(npcRemoveTime)
      entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "common_DoNothing")
    elseif followPathType == PT_IDLE then
      entity.AI.idlePos = entity:GetPos()
      entity.AI.idleDir = entity:GetDirectionVector()
      if entity.AI.commandSet:GetCurrentProcessingCommand() == AICC_FOLLOW_PATH then
        entity.AI.commandSet:OnCommandCompleted(entity, AICC_FOLLOW_PATH)
      else
        AI.Signal(SIGNALFILTER_SENDER, AISIGNAL_INCLUDE_DISABLED, "GO_TO_IDLE", entity.id)
      end
    elseif followPathType == PT_LOOP then
      return
    end
    entity.unit:NpcOnEndedFollowPath()
  end
}
