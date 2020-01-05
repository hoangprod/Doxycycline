AIBehaviour.idle = {
  Name = "idle",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("idle")
    X2AI:AttackReservedTarget(entity)
    AI.SetRefPointPosition(entity.id, entity.AI.idlePos)
    AI.SetRefPointDirection(entity.id, entity.AI.idleDir)
    if entity.AI.param.idle_ai == "hold_position" then
      if entity.AI.param.returnSpawnPos == nil or entity.AI.param.returnSpawnPos == true then
        entity.unit:NpcSetCheckPosContext(AICPC_HOLD_POSITION)
      end
      if not AI.IsSimilarRefPointDirection(entity.id) then
        entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "idle_hold_position")
        return
      end
    else
      entity.unit:NpcSetCheckPosContext(AICPC_ROAMING)
    end
    X2AI:InitRoamingDistance(entity)
    self:UpdateIdle(entity)
  end,
  Destructor = function(self, entity)
    entity.unit:NpcSetCheckPosContext(AICPC_NONE)
    entity.unit:SetDefaultPosture(false)
    entity.unit:SetDefaultSoState(false)
  end,
  UpdateIdle = function(self, entity, sender, data)
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "_first_")
    local isGroupMember, leaderEntity = X2AI:IsGroupMember(entity)
    if isGroupMember then
      if leaderEntity == nil or AI.IsMoving(leaderEntity.id, 0) ~= 0 then
        if leaderEntity ~= nil and leaderEntity ~= entity then
          AI.SetAttentionTargetOf(entity.id, leaderEntity.id, AITARGETREASON_ALERT)
        end
        entity.unit:SetDefaultPosture(false)
        entity.unit:SetDefaultSoState(false)
        PipeManager:Create_formation_GoToOnPoint(entity)
        entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "formation_GoToOnPoint")
        return
      end
      entity.unit:SetDefaultPosture(true)
      entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "common_WaitASec")
      return
    end
    local idle_ai = entity.AI.param.idle_ai
    if idle_ai == "hold_position" then
      entity.unit:SetDefaultPosture(true)
      entity.unit:SetDefaultSoState(true)
      PipeManager:Create_hold_position(entity)
    elseif idle_ai == "roaming" then
      entity.unit:SetDefaultPosture(false)
      entity.unit:SetDefaultSoState(false)
      X2AI:CalcNextRoamingPosition(entity)
      PipeManager:Create_roaming(entity)
    end
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, idle_ai)
  end,
  UpdateIdleEnd = function(self, entity, sender, data)
    if entity.AI.param.idle_ai == "roaming" then
      entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "idle_roaming")
    else
      entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "idle_hold_position")
    end
  end,
  OnASecPassed = function(self, entity, sender, data)
    self:UpdateIdleEnd(entity, sender, data)
  end,
  OnArrivedOnFormationPoint = function(self, entity, sender, data)
    self:UpdateIdleEnd(entity, sender, data)
  end,
  OnPathStuck = function(self, entity, sender, data)
    self:UpdateIdleEnd(entity, sender, data)
  end,
  OnRequestSkillInfo = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.skills.idle)
  end,
  OnAlertTargetChanged = function(self, entity, sender, data)
    local isGroupMember, leaderEntity = X2AI:IsGroupMember(entity)
    if isGroupMember then
      entity.AI.idlePos = leaderEntity:GetPos()
      entity.AI.idlePos.z = entity.AI.idlePos.z + 0.5
    end
    AIBehaviour.DEFAULT:OnAlertTargetChanged(entity, sender, data)
  end,
  OnAggroTargetChanged = function(self, entity, sender, data)
    local idle_ai = entity.AI.param.idle_ai
    if idle_ai == "roaming" then
      local pos = entity:GetPos()
      AI.SetRefPointPosition(entity.id, pos)
    elseif idle_ai == "hold_position" and X2AI:IsGroupMember(entity) then
      entity.AI.idlePos = entity:GetPos()
      AI.SetRefPointPosition(entity.id, entity.AI.idlePos)
    end
    AI.SetAttentionTargetOf(entity.id, data.id, AITARGETREASON_ATTACK)
  end,
  OnPostureChanged = function(self, entity)
    self:UpdateIdle(entity)
  end
}
