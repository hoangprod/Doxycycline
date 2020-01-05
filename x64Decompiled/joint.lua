local RaidJointRequest = SetViewOfRaidJointRequestFrame("raidJointRequest", "UIParent")
local raidJointReqEvents = {
  TEAM_JOINT_REQUEST = function(name, count)
    RaidJointRequest:Show(true)
    RaidJointRequest:Init(name, count)
  end
}
RaidJointRequest:SetHandler("OnEvent", function(this, event, ...)
  raidJointReqEvents[event](...)
end)
RegistUIEvent(RaidJointRequest, raidJointReqEvents)
local RaidJointResponse = SetViewOfRaidJointReponseFrame("raidJointResponse", "UIParent")
local raidJointResEvents = {
  TEAM_JOINT_RESPONSE = function(name, count, leader)
    RaidJointResponse:Show(true)
    RaidJointResponse:Init(name, count, leader)
  end,
  TEAM_JOINT_BROKEN = function()
    RaidJointResponse:Show(false)
  end
}
RaidJointResponse:SetHandler("OnEvent", function(this, event, ...)
  raidJointResEvents[event](...)
end)
RegistUIEvent(RaidJointResponse, raidJointResEvents)
