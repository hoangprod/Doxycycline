X2AI = {
  backoffDist = 0.5,
  backoffThresholdDist = 0.3,
  backoffTime = 0.5
}
Script.ReloadScript("scripts/AI/Logic/x2ai_command_set.lua")
function X2AI:InitRoamingDistance(entity)
  if entity.AI.param.roamingMinDist == nil then
    entity.AI.param.roamingMinDist = 1
  end
  if entity.AI.param.roamingMaxDist == nil then
    entity.AI.param.roamingMaxDist = 6
  end
  if entity.AI.param.roamingMinDist < 1 then
    entity.AI.param.roamingMinDist = 1
  end
  if entity.AI.param.roamingMaxDist < entity.AI.param.roamingMinDist + 1 then
    entity.AI.param.roamingMaxDist = entity.AI.param.roamingMinDist + 1
  end
end
function X2AI:GetRoamingDistance(entity)
  local randDist = (math.random() - 0.5) * (entity.AI.param.roamingMaxDist - entity.AI.param.roamingMinDist)
  if randDist < 0 then
    return randDist - entity.AI.param.roamingMinDist
  end
  return randDist + entity.AI.param.roamingMinDist
end
function X2AI:CalcNextRoamingPosition(entity)
  local newPos = {}
  local roamingCenterPos = entity.AI.idlePos
  newPos.x = roamingCenterPos.x + X2AI:GetRoamingDistance(entity)
  newPos.y = roamingCenterPos.y + X2AI:GetRoamingDistance(entity)
  newPos.z = roamingCenterPos.z
  local terrainHeight = System.GetTerrainElevation(newPos)
  if terrainHeight > newPos.z and terrainHeight - entity.AI.param.roamingMaxDist < newPos.z then
    newPos.z = terrainHeight
  end
  if entity.Properties.bUnderwaterCreature == true then
    if AI.IsPointInWaterRegion(newPos) > AI.GetStanceSize(entity.id).z / 2 then
      AI.SetRefPointPosition(entity.id, newPos)
    end
  else
    AI.SetRefPointPosition(entity.id, newPos)
  end
end
function X2AI:AttackReservedTarget(entity)
  if entity.AI.reservedAttackTargetEntity ~= nil then
    local targetEntity = System.GetEntity(entity.AI.reservedAttackTargetEntity)
    entity.AI.reservedAttackTargetEntity = nil
    if targetEntity ~= nil then
      entity.unit:NpcAddAggro(targetEntity.unit, 1)
    end
  end
end
function X2AI:UseSkill(entity, flags, tag)
  if entity:IsUsingPipe(tag) == true then
    return
  end
  AI.BeginGoalPipe(tag)
  AI.PushGoal("useskill", 1, flags, tag)
  AI.EndGoalPipe()
  entity:InsertSubpipe(0, tag)
end
function X2AI:UseSkillPipe(entity, flags, tag)
  local pipeName = "useSkill_" .. tag
  if entity:IsUsingPipe(pipeName) == true then
    return
  end
  AI.BeginGoalPipe(pipeName)
  AI.PushGoal("useskill", 1, flags, tag)
  AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "OnUseSkillPipeDone_" .. tag, SIGNALFILTER_SENDER)
  AI.EndGoalPipe()
  entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG + AIGOALPIPE_DONT_RESET_STRAFE, pipeName)
end
function X2AI:WaitFor(entity, waitTime)
  entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG + AIGOALPIPE_DONT_RESET_STRAFE, "_first_")
  local goalPipeName = "wait_for"
  AI.BeginGoalPipe(goalPipeName)
  AI.PushGoal("bodypos", 1, BODYPOS_RELAX)
  AI.PushGoal("timeout", 1, waitTime)
  AI.PushGoal("signal", 1, AISIGNAL_INCLUDE_DISABLED, "OnWaitForDone", SIGNALFILTER_SENDER)
  AI.EndGoalPipe()
  entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG + AIGOALPIPE_DONT_RESET_STRAFE, goalPipeName)
end
function X2AI:IsGroupMember(entity)
  local groupId = AI.GetGroupOf(entity.id)
  if groupId < 1 then
    return false, nil
  end
  local leaderEntity = AI.GetLeader(groupId)
  if leaderEntity == nil or leaderEntity.id ~= entity.id then
    return true, leaderEntity
  end
  return false, nil
end
