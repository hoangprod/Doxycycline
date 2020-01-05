AICharacter.almighty_npc = {
  Class = UNIT_CLASS_INFANTRY,
  TeamRole = GU_HUMAN_COVER,
  Constructor = function(self, entity)
    entity.AI.idlePos = entity:GetPos()
    entity.AI.idleDir = entity:GetDirectionVector()
    entity.AI.param = {
      msgs = {},
      idle_ai = "hold_position",
      alertDuration = 3,
      alertSafeTargetRememberTime = 5,
      canChangeAiUnitAttr = 0,
      meleeAttackRange = entity.Properties.attackStartRange,
      preferedCombatDist = 0,
      maxMakeAGapCount = 0,
      aiPhaseChangeType = PHASE_TYPE_NONE,
      attackPath = "",
      roamingMinDist = 1,
      roamingMaxDist = 6,
      clearSCtrlWhenClearCombat = false,
      aiPhase = {},
      aiSkillLists = {},
      aiPathSkillLists = {},
      aiPathDamageSkillLists = {}
    }
    function entity.AI:SetParamX2(paramBlock)
      local paramF = loadstring("return {" .. paramBlock .. "}")
      if paramF ~= nil then
        local param = paramF()
        mergeOverwriteF(entity.AI.param, param, true)
      else
        local pos = entity:GetPos()
        System.Error("NPC AI param is incorrect!!! / unit id: " .. tostring(entity.unit:GetId()) .. ", unit name: " .. tostring(entity.unit:GetName()) .. ", pos: (" .. tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z) .. ")")
      end
      entity.unit:SaveUnitAttr(entity.AI.param.canChangeAiUnitAttr)
    end
    AI.SetSkillUsePattern(entity.id, SUP_BIG_MONSTER)
  end,
  AnyBehavior = {
    GO_TO_SPAWN = "spawning",
    GO_TO_IDLE = "idle",
    GO_TO_RUN_COMMAND_SET = "run_command_set",
    GO_TO_TALK = "talk",
    GO_TO_ALERT = "alert",
    GO_TO_COMBAT = "almighty_attack",
    GO_TO_FOLLOW_PATH = "follow_path",
    GO_TO_FOLLOW_UNIT = "follow_unit",
    GO_TO_RETURN = "return_state",
    GO_TO_DEAD = "dead",
    GO_TO_DESPAWN = "despawning"
  },
  spawning = {},
  idle = {
    OnAggroTargetChanged = "almighty_attack",
    ReturnToIdlePos = "return_state",
    OnTalk = "talk"
  },
  run_command_set = {
    OnAggroTargetChanged = "almighty_attack",
    OnTalk = "talk"
  },
  talk = {
    OnReturnToTalkPos = "return_state",
    OnAggroTargetChanged = "almighty_attack"
  },
  alert = {
    OnAggroTargetChanged = "almighty_attack"
  },
  almighty_attack = {
    OnNoAggroTarget = "return_state"
  },
  follow_path = {OnTalk = "talk"},
  follow_unit = {
    OnAggroTargetChanged = "almighty_attack",
    OnTalk = "talk"
  },
  return_state = {},
  dead = {},
  despawning = {}
}
