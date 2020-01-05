AIBehaviour.bind_unit = {
  Name = "bind_unit",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("bind_unit")
    X2AI:AttackReservedTarget(entity)
    AI.SetAttentionTargetOf(entity.id, entity.AI.followUnit, AITARGETREASON_FRIENDLY)
    AI.BeginGoalPipe("bindUnit")
    AI.PushGoal("bodypos", 1, BODYPOS_RELAX)
    AI.PushGoal("run", 1, 1)
    AI.PushGoal("bind", 1, entity.AI.param.bindJointName, entity.AI.param.bindOffset, entity.AI.param.waitingTime)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "bindUnit")
  end,
  Destructor = function(self, entity)
  end,
  OnAlertTargetChanged = function(self, entity, sender, data)
    local followTarget = System.GetEntity(entity.AI.followUnit)
    if followTarget ~= nil then
      entity.AI.idlePos = followTarget:GetPos()
      entity.AI.idlePos.z = entity.AI.idlePos.z + 0.5
    end
    AIBehaviour.DEFAULT:OnAlertTargetChanged(entity, sender, data)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    local pos = entity:GetPos()
    AI.SetRefPointPosition(entity.id, pos)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end,
  OnLostFollowUnit = function(self, entity, sender, data)
    local cmdSet = entity.AI.commandSet
    local needRemove = false
    if cmdSet:GetCurrentCommand() == AICC_FOLLOW_UNIT then
      cmdSet:OnCommandCompleted(entity, AICC_FOLLOW_UNIT)
      if cmdSet:CanRunCommandSet() == false then
        cmdSet:EndCommandSet(entity)
        if cmdSet:CanRunCommandSet() == false then
          needRemove = true
        end
      end
    else
      needRemove = true
    end
    if needRemove then
      entity.unit:NpcRemoveAfter(5)
      entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "common_DoNothing")
    end
  end
}
