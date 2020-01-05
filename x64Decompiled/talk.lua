AIBehaviour.talk = {
  Name = "talk",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("talk")
    local pos = entity.AI.talkPos
    AI.SetRefPointPosition(entity.id, pos)
    local returnThresholdDist = 3
    entity.unit:SetDefaultPosture(true)
    entity.unit:SetDefaultSoState(true)
    AI.BeginGoalPipe("talk")
    AI.PushGoal("bodypos", 1, BODYPOS_RELAX)
    AI.PushGoal("run", 1, 0)
    AI.PushGoal("branch", 1, "SKIP_RETURN_TO_TALK_POS", IF_POSITION_DIST_LESS, returnThresholdDist, pos.x, pos.y, pos.z)
    AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "OnReturnToTalkPos", SIGNALFILTER_SENDER)
    AI.PushLabel("SKIP_RETURN_TO_TALK_POS")
    AI.PushGoal("timeout", 1, 1)
    AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "UpdateTalk", SIGNALFILTER_SENDER)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "talk")
    entity.unit:NpcSetCheckPosContext(AICPC_TALK)
  end,
  Destructor = function(self, entity)
    entity.unit:NpcSetCheckPosContext(AICPC_NONE)
    entity.unit:SetDefaultPosture(false)
    entity.unit:SetDefaultSoState(false)
  end,
  OnReturnToTalkPos = function(self, entity, sender, data)
    entity.AI.returnSignal = "GO_TO_TALK"
  end,
  UpdateTalk = function(self, entity, sender, data)
    entity.unit:SetDefaultPosture(true)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    entity.AI.returnSignal = "GO_TO_TALK"
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end,
  OnTalkEnd = function(self, entity, sender, data)
    AI.Signal(SIGNALFILTER_SENDER, AISIGNAL_INCLUDE_DISABLED, "GO_TO_RUN_COMMAND_SET", entity.id)
  end,
  OnFriendSeend = function(self, entity)
  end,
  OnPostureChanged = function(self, entity)
    entity.unit:SetDefaultPosture(true)
  end
}
