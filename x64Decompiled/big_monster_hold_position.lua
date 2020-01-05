AICharacter.big_monster_hold_position = {
  Class = UNIT_CLASS_INFANTRY,
  TeamRole = GU_HUMAN_COVER,
  Constructor = function(self, entity)
    entity.AI.idlePos = entity:GetPos()
    entity.AI.idleDir = entity:GetDirectionVector()
    entity.AI.param = {
      msgs = {},
      alertDuration = 3,
      alertSafeTargetRememberTime = 5,
      combatSkills = {}
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
    end
    AI.SetSkillUsePattern(entity.id, SUP_BIG_MONSTER)
  end,
  AnyBehavior = {
    GO_TO_SPAWN = "spawning",
    GO_TO_IDLE = "hold_position",
    GO_TO_RUN_COMMAND_SET = "run_command_set",
    GO_TO_TALK = "talk",
    GO_TO_ALERT = "alert",
    GO_TO_COMBAT = "big_monster_attack",
    GO_TO_FOLLOW_PATH = "follow_path",
    GO_TO_FOLLOW_UNIT = "follow_unit",
    GO_TO_RETURN = "return_state",
    GO_TO_DEAD = "dead",
    GO_TO_DESPAWN = "despawning"
  },
  spawning = {},
  hold_position = {
    OnAggroTargetChanged = "big_monster_attack",
    ReturnToIdlePos = "return_state",
    OnTalk = "talk"
  },
  run_command_set = {
    OnAggroTargetChanged = "big_monster_attack",
    OnTalk = "talk"
  },
  talk = {
    OnReturnToTalkPos = "return_state",
    OnAggroTargetChanged = "big_monster_attack"
  },
  alert = {
    OnAggroTargetChanged = "big_monster_attack"
  },
  big_monster_attack = {
    OnNoAggroTarget = "return_state"
  },
  follow_path = {OnTalk = "talk"},
  follow_unit = {
    OnAggroTargetChanged = "big_monster_attack",
    OnTalk = "talk"
  },
  return_state = {},
  dead = {},
  despawning = {}
}
