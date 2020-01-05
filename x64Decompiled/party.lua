local MAX_PARTY_MEMBERS = X2Team:GetMaxPartyMembers()
local partyFrame
local function CreatePartyFrame(id, parent)
  local w = CreateEmptyWindow(id, parent)
  w:AddAnchor("TOPLEFT", "UIParent", 0, 70)
  w:Show(true)
  w.parties = {}
  for i = 1, MAX_PARTY_MEMBERS - 1 do
    do
      local frameId = string.format("%s.party_%d", id, i)
      local party = CreatePartyMemberFrame(frameId, w)
      function party:MakeOriginWindowPos()
        self:RemoveAllAnchors()
        self:AddAnchor("TOPLEFT", w, 5, 70 + (i - 1) * (50 + party:GetHeight()))
      end
      party:MakeOriginWindowPos()
      party:Show(true)
      AddUISaveHandlerByKey("partyFrame" .. i, party)
      party:ApplyLastWindowOffset()
      w.parties[i] = party
    end
  end
  function w:Refresh()
    self.myMemberIndex = X2Team:GetTeamPlayerIndex()
    local partyHeadIndex = X2Team:GetTeamPlayerPartyHeadIndex()
    if self.myMemberIndex <= 0 then
      for i = 1, #self.parties do
        self.parties[i]:Release()
      end
      return
    end
    local memberFrameIndex = 1
    for i = 1, MAX_PARTY_MEMBERS do
      local index = partyHeadIndex + i - 1
      local target = string.format("team%d", index)
      if X2Unit:UnitIsTeamMember(target) == true and index ~= self.myMemberIndex then
        self.parties[memberFrameIndex]:Set(index, target)
        memberFrameIndex = memberFrameIndex + 1
      end
    end
    for i = memberFrameIndex, #self.parties do
      self.parties[i]:Release()
    end
  end
  function w:OnHide()
    partyFrame = nil
  end
  w:SetHandler("OnHide", w.OnHide)
  w:EnableHidingIsRemove(true)
  return w
end
local events = {
  TEAM_MEMBER_DISCONNECTED = function(isParty, jointOrder, stringId, memberIndex)
    for i = 1, #partyFrame.parties do
      local party = partyFrame.parties[i]
      if party.unitId == stringId then
        party:SetOffline()
        return
      end
    end
  end,
  TEAM_MEMBER_UNIT_ID_CHANGED = function(oldStringId, stringId)
    for i = 1, #partyFrame.parties do
      local party = partyFrame.parties[i]
      if party.unitId == oldStringId then
        party.unitId = stringId
        return
      end
    end
  end,
  ENTERED_WORLD = function()
    for i = 1, #partyFrame.parties do
      local party = partyFrame.parties[i]
      if party.unitId ~= nil then
        party:UpdateMarker()
        party:UpdateNameWidth()
      end
    end
  end
}
local function ShowPartyFrame(isShow)
  if partyFrame == nil then
    if isShow == true then
      partyFrame = CreatePartyFrame("partyFrame", "UIParent")
      partyFrame:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(partyFrame, events)
      partyFrame:Refresh()
    end
  else
    if isShow == true then
      partyFrame:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      partyFrame:Refresh()
    else
      partyFrame:ReleaseHandler("OnEvent")
      for i = 1, #partyFrame.parties do
        local party = partyFrame.parties[i]
        party:Release()
      end
    end
    partyFrame:Show(isShow)
  end
end
local function UpdatePartyFrame()
  if partyFrame == nil then
    LuaAssert("error!! partyFrame is nil - UpdatePartyFrame()")
    return
  end
  if partyFrame:IsVisible() == false then
    LuaAssert("error!! partyFrame is invisible - UpdatePartyFrame()")
    return
  end
  partyFrame:Refresh()
end
local IsValidTeamState = function()
  if X2Team:IsPartyTeam() == true then
    return true
  elseif X2Team:IsRaidTeam() == true and X2Team:GetPartyFrameVisible() == true then
    return true
  end
  return false
end
if IsValidTeamState() == true then
  ShowPartyFrame(true)
end
local function ConvertToRaidTeam()
  ShowPartyFrame(X2Team:GetPartyFrameVisible())
end
UIParent:SetEventHandler("CONVERT_TO_RAID_TEAM", ConvertToRaidTeam)
local function TeamMembersChanged(reason, value)
  if reason == "joined_by_self" then
    if IsValidTeamState() == true then
      ShowPartyFrame(true)
      for i = 1, #partyFrame.parties do
        local party = partyFrame.parties[i]
        if party:IsVisible() then
          party:UpdateMarker()
          party:UpdateNameWidth()
        end
      end
    end
  elseif reason == "leaved_by_self" or reason == "kicked_by_self" or reason == "dismissed" then
    ShowPartyFrame(false)
  elseif reason == "owner_changed" then
    if IsValidTeamState() then
      UpdatePartyFrame()
      for i = 1, #partyFrame.parties do
        local party = partyFrame.parties[i]
        party:UpdateMarkerAnchor()
      end
    end
  elseif IsValidTeamState() == true then
    UpdatePartyFrame()
  end
  local func = locale.team.msgFunc[reason]
  if func ~= nil then
    local notifyMsg = func(value.isParty, value.jointOrder, value.name, value.teamRoleType)
    if notifyMsg ~= nil then
      X2Chat:DispatchChatMessage(CMF_PARTY_AND_RAID_INFO, notifyMsg)
    end
  end
end
UIParent:SetEventHandler("TEAM_MEMBERS_CHANGED", TeamMembersChanged)
local function TogglePartyFrame(show)
  if X2Team:IsRaidTeam() == false then
    return
  end
  ShowPartyFrame(show)
end
UIParent:SetEventHandler("TOGGLE_PARTY_FRAME", TogglePartyFrame)
local function LeftLoading()
  ShowPartyFrame(IsValidTeamState())
end
UIParent:SetEventHandler("LEFT_LOADING", LeftLoading)
function SetPartyFrameVisibleBuffDebuffText(visible)
  if partyFrame == nil then
    return
  end
  for i = 1, #partyFrame.parties do
    local party = partyFrame.parties[i]
    party:SetVisibleBuffDebuffText(visible)
  end
end
function Test_GetPartyOpenEvents()
  return openEvents
end
function Test_GetPartyEvents()
  return events
end
