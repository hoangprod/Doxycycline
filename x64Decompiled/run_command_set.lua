AIBehaviour.run_command_set = {
  Name = "run_command_set",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    if entity.AI.commandSet:CanRunCommandSet() then
      entity:ClearAICombat("run_command_set")
      X2AI:AttackReservedTarget(entity)
      entity.AI.commandSet:RunCommandSetStep(entity)
      return
    end
    entity.AI.commandSet:EndCommandSet(entity)
  end,
  Destructor = function(self, entity)
    local currTime = System.GetCurrTime()
    entity.AI.commandSet.commandRunningTime = entity.AI.commandSet.commandRunningTime + (currTime - entity.AI.commandSet.commandStepStartTime)
  end,
  OnRequestSkillInfo_ByCommandSet = function(self, entity)
    cmdInfo = entity.AI.commandSet:GetCurrentCommandWithParam()
    if cmdInfo == 0 then
      entity.unit:NpcSetSkillList({})
      return
    end
    entity.unit:NpcSetSkillList({
      cmdInfo[2]
    })
  end,
  OnUseSkillPipeDone_ByCommandSet = function(self, entity)
    entity.AI.commandSet:OnCommandCompleted(entity, AICC_USE_SKILL)
  end,
  OnWaitForDone = function(self, entity)
    entity.AI.commandSet:OnCommandCompleted(entity, AICC_TIMEOUT)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    local pos = entity:GetPos()
    AI.SetRefPointPosition(entity.id, pos)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end,
  OnGroupLeaderDied = function(self, entity)
    local skills = entity.AI.param.onGroupLeaderDied
    if skills then
      X2AI:UseSkillPipe(entity, 0, "OnGroupLeaderDied")
    end
  end,
  OnGroupMemberDied = function(self, entity)
    local skills = entity.AI.param.onGroupMemberDied
    if skills then
      X2AI:UseSkillPipe(entity, 0, "OnGroupMemberDied")
    end
  end,
  OnUseSkillPipeDone_OnGroupLeaderDied = function(self, entity)
    self:Destructor(entity)
    self:Constructor(entity)
  end,
  OnUseSkillPipeDone_OnGroupMemberDied = function(self, entity)
    self:Destructor(entity)
    self:Constructor(entity)
  end
}
