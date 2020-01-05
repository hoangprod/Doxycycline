AIBehaviour.archer_attack = {
  Name = "archer_attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    entity.AI.makeAGapCount = 0
    entity.AI.phase = "base"
    AI.BeginGoalPipe("archerAttack_Base")
    AI.PushGoal("strafe", 1, 2, 50, 1)
    AI.PushGoal("bodypos", 1, BODYPOS_STAND)
    AI.PushGoal("run", 1, 2)
    AI.PushLabel("USE_SKILL")
    AI.PushGoal("useskill", 1, USF_PICK_BASE_SKILL_IN_BAD_CASE + USF_ALLOW_STICK_STOP_CHECK + USF_AUTO_STICK)
    AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "OnUseSkillDone", SIGNALFILTER_SENDER)
    AI.PushGoal("branch", 1, "USE_SKILL", IF_TARGET_DIST_GREATER, X2AI.backoffThresholdDist)
    AI.PushGoal("backoff", 1, 0, X2AI.backoffTime, AI_BACKOFF_FROM_TARGET + AI_BACKOFF_BREAK_ON_ERROR_CASES, X2AI.backoffDist)
    AI.PushGoal("branch", 1, "USE_SKILL", BRANCH_ALWAYS)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "archerAttack_Base")
    entity.unit:NpcActivateAITimeEvent(true, 1)
  end,
  Destructor = function(self, entity)
    entity.AI.makeAGapCount = nil
    entity.AI.phase = nil
    entity.unit:NpcActivateAITimeEvent(false, 0)
    entity:ClearAICombat("archer_attack")
  end,
  OnRequestSkillInfo = function(self, entity)
    local targetDist = entity.unit:GetTargetDistance()
    local inMeleeAttackRange = targetDist <= entity.AI.param.meleeAttackRange
    local skillList = {}
    if entity.AI.phase == "usedMeleeSkill" then
      local needMakeAGap = inMeleeAttackRange and entity.AI.makeAGapCount < entity.AI.param.maxMakeAGapCount
      if needMakeAGap then
        skillList = entity.AI.param.combatSkills.makeAGap
        entity.AI.phase = "tryingMakeAGapSkill"
      else
        entity.AI.phase = "base"
        self:OnRequestSkillInfo(entity)
        return
      end
    elseif entity.AI.phase == "usedRangedDefSkill" then
      skillList = entity.AI.param.combatSkills.rangedStrong
    end
    if skillList == nil or table.getn(skillList) == 0 then
      if inMeleeAttackRange == true then
        skillList = entity.AI.param.combatSkills.melee
        entity.AI.phase = "tryingMeleeSkill"
      else
        skillList = entity.AI.param.combatSkills.rangedDef
        entity.AI.phase = "tryingRangedDefSkill"
      end
    end
    entity.unit:NpcSetSkillList(skillList)
  end,
  OnUseSkillDone = function(self, entity, sender, data)
    if entity.AI.phase == "tryingMeleeSkill" then
      entity.AI.phase = "usedMeleeSkill"
    elseif entity.AI.phase == "tryingRangedDefSkill" then
      entity.AI.phase = "usedRangedDefSkill"
    elseif entity.AI.phase == "tryingMakeAGapSkill" then
      entity.AI.phase = "needMakeAGap"
      AI.BeginGoalPipe("archerAttack_MakeAGap")
      AI.PushGoal("backoff", 1, entity.AI.param.preferedCombatDist, 3, AI_BACKOFF_FROM_TARGET, entity.AI.param.preferedCombatDist)
      AI.EndGoalPipe()
      entity:InsertSubpipe(0, "archerAttack_MakeAGap")
      entity.AI.makeAGapCount = entity.AI.makeAGapCount + 1
      return
    else
      entity.AI.phase = "base"
    end
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end
}
