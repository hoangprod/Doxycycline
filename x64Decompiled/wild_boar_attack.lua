AIBehaviour.wild_boar_attack = {
  Name = "wild_boar_attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    AI.BeginGoalPipe("wildBoarAttack_Base")
    AI.PushGoal("strafe", 1, 2, 50, 1)
    AI.PushGoal("bodypos", 1, BODYPOS_STAND)
    AI.PushGoal("run", 1, 2)
    AI.PushGoal("useskill", 1, USF_AUTO_STICK, "onCombatStartSkill")
    AI.PushLabel("USE_SKILL")
    AI.PushGoal("useskill", 1, USF_PICK_BASE_SKILL_IN_BAD_CASE + USF_ALLOW_STICK_STOP_CHECK + USF_AUTO_STICK)
    AI.PushGoal("branch", 1, "USE_SKILL", IF_TARGET_DIST_GREATER, X2AI.backoffThresholdDist)
    AI.PushGoal("backoff", 1, 0, X2AI.backoffTime, AI_BACKOFF_FROM_TARGET + AI_BACKOFF_BREAK_ON_ERROR_CASES, X2AI.backoffDist)
    AI.PushGoal("branch", 1, "USE_SKILL", BRANCH_ALWAYS)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "wildBoarAttack_Base")
    entity.AI.healthPercentage = entity.actor:GetHealth() / entity.actor:GetMaxHealth() * 100
    entity.AI.spurtSkills = {}
    entity.unit:NpcActivateAITimeEvent(true, 1)
  end,
  Destructor = function(self, entity)
    entity.unit:NpcActivateAITimeEvent(false, 0)
    entity.AI.spurtSkills = nil
    entity.AI.healthPercentage = nil
    entity:ClearAICombat("wild_boar_attack")
  end,
  OnRequestSkillInfo_onCombatStartSkill = function(self, entity)
    local skillList = entity.AI.param.onCombatStartSkill or {}
    entity.unit:NpcSetSkillList(skillList)
  end,
  OnRequestSkillInfo = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.skills.combat)
  end,
  OnAITimeEvent = function(self, entity, sender, data)
    local prevHealth = entity.AI.healthPercentage
    local currHealth = entity.actor:GetHealth() / entity.actor:GetMaxHealth() * 100
    entity.AI.healthPercentage = currHealth
    local spurtSkills = entity.AI.param.onSpurtSkill
    if spurtSkills == nil then
      return
    end
    if table.getn(entity.AI.spurtSkills) > 0 then
      return
    end
    entity.AI.spurtSkills = {}
    local numOfSkills = table.getn(spurtSkills)
    for i = 1, numOfSkills do
      local skillData = spurtSkills[i]
      if currHealth < skillData.healthCondition and prevHealth >= skillData.healthCondition then
        table.insert(entity.AI.spurtSkills, skillData.skillType)
      end
    end
    if table.getn(entity.AI.spurtSkills) > 0 then
      entity.unit:NpcStopAutoAttack()
      X2AI:UseSkill(entity, USF_AUTO_STICK + USF_WAIT_UNIT_STATUS_PROBLEM, "onSpurtSkill")
    end
  end,
  OnRequestSkillInfo_onSpurtSkill = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.spurtSkills)
    entity.AI.spurtSkills = {}
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end
}
