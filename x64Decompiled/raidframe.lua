function GetPartyAndSlotIndex(memberIndex)
  if memberIndex == nil then
    return
  end
  memberIndex = memberIndex - 1
  if memberIndex < 0 then
    LuaAssert(string.format("memberIndex is invalid"))
    return
  end
  local maxPartyMember = X2Team:GetMaxPartyMembers()
  local party = math.floor(memberIndex / maxPartyMember) + 1
  local slot = math.floor(memberIndex % maxPartyMember) + 1
  return party, slot
end
function CreateRaidFrame(id)
  local w = SetViewOfRaidFrame(id)
  w.jointOrder = X2Team:GetMyTeamJointOrder()
  function w:OnShow()
    self:Refresh()
  end
  w:SetHandler("OnShow", w.OnShow)
  function w:Refresh(memberIndex)
    local MAX_RAID_PARTIES = X2Team:GetMaxParties()
    local party, slot = GetPartyAndSlotIndex(memberIndex)
    if X2Team:IsRaidTeam() == false then
      return
    end
    if self.UpdateTroopButton ~= nil then
      self:UpdateTroopButton()
    end
    if party ~= nil then
      if slot ~= nil then
        if w.party[party].members[slot]:Refresh() then
          w.party[party]:Show(true)
        end
      else
        w.party[party]:Refresh()
      end
      if X2Team:CountTeamMembersInParty(w.jointOrder, party) > 0 and X2Team:GetPartyVisible(w.jointOrder, party) == true then
        w.party[party]:Show(true)
      else
        w.party[party]:Show(false)
      end
    else
      for i = 1, MAX_RAID_PARTIES do
        w.party[i]:Refresh()
        if X2Team:CountTeamMembersInParty(w.jointOrder, i) > 0 and X2Team:GetPartyVisible(w.jointOrder, i) == true then
          w.party[i]:Show(true)
        else
          w.party[i]:Show(false)
        end
      end
    end
  end
  function w:UpdateMovedMembers(fromMemberIndex, toMemberIndex)
    local party1, slot1 = GetPartyAndSlotIndex(fromMemberIndex)
    local party2, slot2 = GetPartyAndSlotIndex(toMemberIndex)
    if party1 == nil or slot1 == nil or party2 == nil or slot2 == nil then
      return
    end
    local MAX_RAID_PARTY_MEMBERS = X2Team:GetMaxPartyMembers()
    local memberIndex_1 = (party1 - 1) * MAX_RAID_PARTY_MEMBERS + (slot1 - 1) + 1
    local memberIndex_2 = (party2 - 1) * MAX_RAID_PARTY_MEMBERS + (slot2 - 1) + 1
    local member_1 = string.format("team%d", memberIndex_1)
    local member_2 = string.format("team%d", memberIndex_2)
    self.party[party1].members[slot1].combatIcon:SetVisible(X2Unit:UnitCombatState(member_1))
    self.party[party2].members[slot2].combatIcon:SetVisible(X2Unit:UnitCombatState(member_2))
    self.party[party1].members[slot1]:UpdateMarker()
    self.party[party1].members[slot1]:UpdateNameLabelWidth()
    self.party[party2].members[slot2]:UpdateMarker()
    self.party[party2].members[slot2]:UpdateNameLabelWidth()
  end
  function w:SetPartyVisible(party, visible)
    w.party[party]:Show(visible)
    if visible then
      w.party[party]:Refresh()
    end
  end
  function w:UpdateAllMembersCombatState()
    local maxPartyMembers = X2Team:GetMaxPartyMembers()
    local maxParties = X2Team:GetMaxParties()
    for i = 1, maxParties do
      for j = 1, maxPartyMembers do
        local memberIndex = (i - 1) * maxPartyMembers + (j - 1) + 1
        RaidFrame.party[i].members[j].combatIcon:SetVisible(X2Unit:UnitCombatState(string.format("team%d", memberIndex)))
      end
    end
  end
  function w:OnScale()
    self:OnShow()
  end
  w:SetHandler("OnScale", w.OnScale)
  function w.troop1Btn:CheckBtnCheckChagnedProc(checked)
    if not checked then
      w.troop1Btn:SetChecked(true, true)
    else
      w.troop1Btn:SetChecked(true, false)
      w.troop2Btn:SetChecked(false, false)
      w.jointOrder = 1
      w:Refresh()
    end
  end
  function w.troop2Btn:CheckBtnCheckChagnedProc(checked)
    if not checked then
      w.troop2Btn:SetChecked(true, true)
    else
      w.troop2Btn:SetChecked(true, false)
      w.troop1Btn:SetChecked(false, false)
      w.jointOrder = 2
      w:Refresh()
    end
  end
  function w:ShowTroopBtn(visible)
    if visible ~= true then
      visible = false
    end
    w.troop1Btn:Show(visible)
    w.troop2Btn:Show(visible)
    w.troopBtnBg:Show(visible)
  end
  w:ShowTroopBtn(false)
  function w:SelectTroopBtn(order)
    if order == 1 then
      w.troop1Btn:CheckBtnCheckChagnedProc(true)
    elseif order == 2 then
      w.troop2Btn:CheckBtnCheckChagnedProc(true)
    else
      w.troop1Btn:SetChecked(false, false)
      w.troop2Btn:SetChecked(false, false)
    end
  end
  w:SelectTroopBtn(w.jointOrder)
  function w:UpdateTroopButton()
    if X2Team:GetMyTeamJointOrder() == 0 then
      self:ShowTroopBtn(false)
    else
      self:ShowTroopBtn(true)
    end
  end
  return w
end
local raidFrameEvents = {
  TEAM_MEMBERS_CHANGED = function(reason, value)
    if RaidFrame == nil then
      return
    end
    if reason == "joined" and value.isParty == false or reason == "refreshed" and value.isParty == false or reason == "leaved" and value.isParty == false or reason == "kicked" and value.isParty == false then
      if RaidFrame.jointOrder == value.jointOrder then
        RaidFrame:Refresh(value.memberIndex)
      end
    elseif reason == "leaved_by_self" and value.isParty == false or reason == "dismissed" and value.isParty == false or reason == "kicked_by_self" and value.isParty == false then
      ToggleRaidFrame(false)
    elseif reason == "moved" then
      if RaidFrame.jointOrder == value.jointOrder then
        RaidFrame:Refresh(value.memberIndex)
        RaidFrame:Refresh(value.newMemberIndex)
        RaidFrame:UpdateMovedMembers(value.memberIndex, value.newMemberIndex)
      end
    elseif reason == "refresh" then
      RaidFrame:Refresh()
    elseif RaidFrame.jointOrder == value.jointOrder then
      RaidFrame:Refresh()
    end
    if reason ~= "refresh" and reason ~= "moved" then
      X2BattleField:RequestLeaveUserList()
    end
  end,
  TOGGLE_RAID_FRAME_PARTY = function(party, visible)
    if RaidFrame == nil then
      return
    end
    RaidFrame:SetPartyVisible(party, visible)
  end,
  TEAM_ROLE_CHANGED = function(jointOrder, memberIndex, role)
    local party, slot = GetPartyAndSlotIndex(memberIndex)
    if RaidFrame.jointOrder == jointOrder then
      RaidFrame.party[party].members[slot]:ChangeHpBarTexture_role(RaidFrame.simple, role)
    end
  end,
  LOOTING_RULE_MASTER_CHANGED = function()
    if RaidFrame == nil then
      return
    end
    local maxPartyMembers = X2Team:GetMaxPartyMembers()
    local maxParties = X2Team:GetMaxParties()
    for i = 1, maxParties do
      for j = 1, maxPartyMembers do
        RaidFrame.party[i].members[j]:UpdateLeaderMark()
      end
    end
  end,
  LOOTING_RULE_METHOD_CHANGED = function()
    if RaidFrame == nil then
      return
    end
    local maxPartyMembers = X2Team:GetMaxPartyMembers()
    local maxParties = X2Team:GetMaxParties()
    for i = 1, maxParties do
      for j = 1, maxPartyMembers do
        RaidFrame.party[i].members[j]:UpdateLeaderMark()
      end
    end
  end,
  RAID_FRAME_SIMPLE_VIEW = function(simple)
    if RaidFrame == nil then
      return
    end
    RaidFrame:SetSimpleMode(simple)
  end,
  UNIT_COMBAT_STATE_CHANGED = function(arg1, arg2)
    if RaidFrame == nil then
      return
    end
    local maxPartyMembers = X2Team:GetMaxPartyMembers()
    local maxParties = X2Team:GetMaxParties()
    for i = 1, maxParties do
      for j = 1, maxPartyMembers do
        RaidFrame.party[i].members[j]:ShowCombatIcon(arg1, arg2)
      end
    end
  end,
  TEAM_JOINT_BROKEN = function()
    if RaidFrame == nil then
      return
    end
    RaidFrame.jointOrder = X2Team:GetMyTeamJointOrder()
    RaidFrame:SelectTroopBtn(RaidFrame.jointOrder)
    RaidFrame:Refresh()
  end,
  TEAM_JOINTED = function()
    if RaidFrame == nil then
      return
    end
    RaidFrame.jointOrder = X2Team:GetMyTeamJointOrder()
    RaidFrame:SelectTroopBtn(RaidFrame.jointOrder)
    RaidFrame:Refresh()
  end
}
RaidFrame = nil
function ToggleRaidFrame(show)
  if show and not X2Team:IsRaidTeam() then
    return
  end
  if show == false and RaidFrame == nil then
    return
  end
  if RaidFrame == nil then
    RaidFrame = CreateRaidFrame("raidFrame", "UIParent")
    RaidFrame:SetSimpleMode(X2Team:GetSimpleView())
    RaidFrame:EnableHidingIsRemove(true)
    RaidFrame:SetHandler("OnEvent", function(this, event, ...)
      raidFrameEvents[event](...)
    end)
    RegistUIEvent(RaidFrame, raidFrameEvents)
    AddUISaveHandlerByKey("raidFrame", RaidFrame)
    RaidFrame:ApplyLastWindowOffset()
  end
  local isShow = show
  if isShow == nil then
    isShow = not RaidFrame:IsVisible()
  end
  if isShow == true and X2Team:GetRaidFrameVisible() == false then
    RaidFrame:Show(false)
    RaidFrame = nil
    return
  end
  RaidFrame:Show(isShow)
  RaidFrame:UpdateAllMembersCombatState()
  if isShow == false then
    RaidFrame = nil
  elseif RaidFrame.jointOrder ~= X2Team:GetMyTeamJointOrder() then
    RaidFrame.jointOrder = X2Team:GetMyTeamJointOrder()
    RaidFrame:SelectTroopBtn(RaidFrame.jointOrder)
    RaidFrame:Refresh()
  end
end
UIParent:SetEventHandler("TOGGLE_RAID_FRAME", ToggleRaidFrame)
if X2Team:IsRaidTeam() then
  ToggleRaidFrame(true)
end
local ConvertToRaidTeam = function()
  ToggleRaidFrame(true)
end
UIParent:SetEventHandler("CONVERT_TO_RAID_TEAM", ConvertToRaidTeam)
local LeftLoading = function()
  ToggleRaidFrame(X2Team:IsRaidTeam() and X2Team:GetRaidFrameVisible())
end
UIParent:SetEventHandler("LEFT_LOADING", LeftLoading)
