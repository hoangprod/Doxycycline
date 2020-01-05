AIBehaviour.big_monster_attack = {
  Name = "big_monster_attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    AI.BeginGoalPipe("bigMonsterAttack_Base")
    AI.PushGoal("strafe", 1, 2, 100, 1)
    AI.PushGoal("bodypos", 1, BODYPOS_STAND)
    AI.PushGoal("run", 1, 2)
    AI.PushLabel("USE_SKILL")
    AI.PushGoal("useskill", 1, USF_PICK_BASE_SKILL_IN_BAD_CASE + USF_ALLOW_STICK_STOP_CHECK + USF_AUTO_STICK)
    AI.PushGoal("branch", 1, "USE_SKILL", BRANCH_ALWAYS)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "bigMonsterAttack_Base")
  end,
  Destructor = function(self, entity)
    entity:ClearAICombat("big_monster_attack")
  end,
  OnRequestSkillInfo = function(self, entity)
    local healthRatio = entity.actor:GetHealth() / entity.actor:GetMaxHealth() * 100
    local skillList = {}
    local combatSkills = entity.AI.param.combatSkills
    local numOfSkills = table.getn(combatSkills)
    for i = 1, numOfSkills do
      local skillData = combatSkills[i]
      if healthRatio >= skillData.healthRange[1] and healthRatio <= skillData.healthRange[2] then
        local delay = skillData.skillDelay
        if delay == nil then
          delay = 0
        end
        local strafe = skillData.strafeDuringDelay
        if strafe == nil then
          strafe = true
        end
        skillList[skillData.skillType] = {delay, strafe}
      end
    end
    entity.unit:NpcSetSkillList(skillList)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end
}
