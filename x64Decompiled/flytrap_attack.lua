AIBehaviour.flytrap_attack = {
  Name = "flytrap_attack",
  alertness = AIALERTNESS_COMBAT,
  Constructor = function(self, entity)
    entity.unit:StopCasting()
    AI.BeginGoalPipe("flytrapAttack_Base")
    AI.PushGoal("strafe", 1, 2, 50, 1)
    AI.PushGoal("bodypos", 1, BODYPOS_STAND)
    AI.PushGoal("run", 1, 2)
    AI.PushGoal("useskill", 1, 0)
    AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "Update", SIGNALFILTER_SENDER)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "flytrapAttack_Base")
    if entity.AI.param.alwaysTeleportOnReturn then
      entity.unit:NpcSetCheckPosContext(AICPC_FLYTRAP)
    end
  end,
  Destructor = function(self, entity)
    entity.unit:NpcSetCheckPosContext(AICPC_NONE)
    entity:ClearAICombat("flytrap_attack")
    entity.unit:NpcActivateAggroUpdate(true)
    entity.unit:RemoveBuff(NPC_RETURN_BUFF_TYPE)
  end,
  Update = function(self, entity, sender, data)
    entity.unit:NpcRemoveAggroOutOfRange(entity.AI.param.attackEndDistance)
  end,
  OnRequestSkillInfo = function(self, entity)
    local targetDist = entity.unit:GetTargetDistance()
    local skillList
    if targetDist <= entity.AI.param.meleeAttackRange then
      skillList = entity.AI.param.combatSkills.melee
    else
      skillList = entity.AI.param.combatSkills.ranged
    end
    entity.unit:NpcSetSkillList(skillList)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    AI.SetAttentionTargetOf(entity.id, data.id)
  end,
  OnNoAggroTarget = function(self, entity, sender, data)
    entity.unit:NpcActivateAggroUpdate(false)
    local needRestorationOnReturn = entity.AI.param.restorationOnReturn == nil or entity.AI.param.restorationOnReturn == true
    if needRestorationOnReturn then
      entity.unit:StartSkill(entity.unit, NPC_RETURN_SKILL_TYPE, true)
    end
    entity.unit:CreateBuff(NPC_RETURN_BUFF_TYPE)
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "common_RunCommandSetAfterHalfSec")
  end
}
