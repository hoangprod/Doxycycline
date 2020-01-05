AIBehaviour.follow_unit = {
  Name = "follow_unit",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("follow_unit")
    X2AI:AttackReservedTarget(entity)
    AI.SetAttentionTargetOf(entity.id, entity.AI.followUnit, AITARGETREASON_FRIENDLY)
    AI.BeginGoalPipe("followUnit")
    AI.PushGoal("bodypos", 1, BODYPOS_RELAX)
    AI.PushGoal("branch", 1, "DO_STICK", IF_TARGET_ZALIGN_NEED)
    AI.PushGoal("branch", 1, "SKIP_STICK", IF_TARGET_DIST_LESS, 4.5)
    AI.PushLabel("DO_STICK")
    AI.PushGoal("run", 1, 1)
    AI.PushGoal("stick", 1, 0, AILASTOPRES_LOOKAT + AI_DONT_STEER_AROUND_TARGET + AI_ADJUST_SPEED_BY_DISTANCE + AI_REQUEST_PARTIAL_PATH + AI_FOLLOW_SIDE_ON, STICK_BREAK + STICK_SHORTCUTNAV, 0, 0)
    AI.PushLabel("SKIP_STICK")
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "followUnit")
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
