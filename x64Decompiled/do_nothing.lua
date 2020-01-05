AIBehaviour.do_nothing = {
  Name = "do_nothing",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("do_nothing")
    X2AI:AttackReservedTarget(entity)
    AI.SetRefPointPosition(entity.id, entity.AI.idlePos)
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "common_DoNothing")
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    local pos = entity:GetPos()
    AI.SetRefPointPosition(entity.id, pos)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end
}
