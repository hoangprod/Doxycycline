AIBehaviour.binded_attack = {
  Name = "binded_attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    local temporaryBindOffset = {
      0,
      0,
      0.5
    }
    AI.BeginGoalPipe("attack_Based_on_Bind")
    AI.PushGoal("strafe", 1, 2, 50, 1)
    AI.PushGoal("bindedUseskill", 1, entity.AI.param.bindJointName, entity.AI.param.bindOffset, entity.AI.param.waitingTime)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "attack_Based_on_Bind")
  end,
  Destructor = function(self, entity)
    entity:ClearAICombat("binded_attack")
  end,
  OnRequestSkillInfo = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.skills.combat)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end
}
