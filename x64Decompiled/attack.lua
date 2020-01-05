AIBehaviour.attack = {
  Name = "attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    AI.BeginGoalPipe("attack_Base")
    AI.PushGoal("strafe", 1, 2, 50, 1)
    AI.PushGoal("bodypos", 1, BODYPOS_STAND)
    AI.PushGoal("run", 1, 2)
    AI.PushLabel("USE_SKILL")
    AI.PushGoal("useskill", 1, USF_PICK_BASE_SKILL_IN_BAD_CASE + USF_ALLOW_STICK_STOP_CHECK + USF_AUTO_STICK)
    AI.PushGoal("branch", 1, "USE_SKILL", IF_TARGET_DIST_GREATER, X2AI.backoffThresholdDist)
    AI.PushGoal("backoff", 1, 0, X2AI.backoffTime, AI_BACKOFF_FROM_TARGET + AI_BACKOFF_BREAK_ON_ERROR_CASES, X2AI.backoffDist)
    AI.PushGoal("branch", 1, "USE_SKILL", BRANCH_ALWAYS)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "attack_Base")
    local skillCount = table.getn(entity.AI.skills.onCombat)
    if skillCount > 0 then
      X2AI:UseSkill(entity, USF_AUTO_STICK, "onCombat")
    end
  end,
  Destructor = function(self, entity)
    entity:ClearAICombat("attack")
  end,
  OnRequestSkillInfo = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.skills.combat)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end,
  OnRequestSkillInfo_onCombat = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.skills.onCombat)
  end
}
