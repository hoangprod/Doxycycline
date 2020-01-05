AIBehaviour.almighty_attack = {
  Name = "almighty_attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    entity:InitAICombat()
    entity.unit:StartAiSkillLists(entity.AI.param.aiPhaseChangeType, entity.AI.param.aiSkillLists)
  end,
  Destructor = function(self, entity)
    entity.unit:EndAiSkillLists()
    entity:ClearAICombat("almighty_attack")
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end,
  OnBasePathChanged = function(self, entity, sender, data)
    if entity.AI.followPathName ~= nil and entity.AI.followPathName ~= "" then
      AI.SetPathToFollow(entity.id, entity.AI.followPathName)
    end
  end,
  OnAttackPathChanged = function(self, entity, sender, data)
    if entity.AI.param.attackPath ~= nil and entity.AI.param.attackPath ~= "" then
      AI.SetPathToFollow(entity.id, entity.AI.param.attackPath)
    end
  end,
  OnGoToPathEnded = function(self, entity, sender, data)
    entity.AI.idlePos = entity:GetPos()
    entity.AI.idleDir = entity:GetDirectionVector()
    entity.unit:NpcOnEndedGoToPath()
  end
}
