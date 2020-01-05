local MAX_RAID_MEMBERS = X2Team:GetMaxMembers()
local MAX_RAID_PARTIES = X2Team:GetMaxParties()
local MAX_RAID_PARTY_MEMBERS = X2Team:GetMaxPartyMembers()
function GetPartyAndSlotIndex(memberIndex)
  if memberIndex == nil then
    return
  end
  memberIndex = memberIndex - 1
  if memberIndex < 0 then
    LuaAssert("memberIndex is invalid")
    return
  end
  local party = math.floor(memberIndex / MAX_RAID_PARTY_MEMBERS) + 1
  local slot = math.floor(memberIndex % MAX_RAID_PARTY_MEMBERS) + 1
  return party, slot
end
function CreateRaidTeamManagerFrame(id, parent)
  local w = SetViewOfRaidTeamManagerFrame(id, parent)
  w.jointOrder = X2Team:GetMyTeamJointOrder()
  local self_texture = w:CreateDrawable(TEXTURE_PATH.RAID, "paint_bg", "artwork")
  self_texture:SetVisible(false)
  w.self_texture = self_texture
  local OnEnter = function(self)
    if X2Team:IsSiegeRaidTeam() then
      SetTooltip(GetUIText(COMMON_TEXT, "excute_area_siege_raid_invite"), self, false)
    else
      SetTooltip(GetUIText(TEAM_TEXT, "excute_area_invite"), self, false)
    end
  end
  w.rangeInviteBtn:SetHandler("OnEnter", OnEnter)
  function w:ShowProc()
    self:Refresh()
    w.raidOptionFrame:Show(false)
    w.raidRoleFrame:Show(false)
  end
  function w:CheckAuthority()
    local isBattleField = X2BattleField:IsInInstantGame()
    local isPartyTeam = X2Team:IsPartyTeam()
    local isRaidTeam = X2Team:IsRaidTeam()
    local isSiegeRaidTeam = X2Team:IsSiegeRaidTeam()
    local myIndex = X2Team:GetTeamPlayerIndex()
    local memberCount = X2Team:CountTeamMembers(X2Team:GetMyTeamJointOrder())
    local jointOrder = X2Team:GetMyTeamJointOrder()
    if not isPartyTeam and not isRaidTeam then
      w.changeToRaidBtn:Show(true)
      w.changeToRaidBtn:Enable(false)
      if isBattleField then
        w.rangeInviteBtn:Enable(false)
      else
        w.rangeInviteBtn:Enable(X2Team:GetCanUseAreaInvitation())
      end
      w.dismissRaidBtn:Show(false)
      w.raidRoleBtn:Enable(false)
      w.summonBtn:Show(false)
      w.searchBtn:Enable(not isBattleField)
      w.raidOptionBtn:Enable(not isBattleField)
    elseif X2Team:IsTeamOwner(jointOrder, myIndex) == true then
      w.changeToRaidBtn:Show(not isRaidTeam)
      w.changeToRaidBtn:Enable(not isRaidTeam)
      if memberCount < MAX_RAID_MEMBERS and isRaidTeam and not isBattleField then
        w.rangeInviteBtn:Enable(X2Team:GetCanUseAreaInvitation())
      else
        w.rangeInviteBtn:Enable(false)
      end
      if isRaidTeam == true then
        w.dismissRaidBtn:Show(true)
        w.dismissRaidBtn:SetText(locale.team.dismiss())
        if isBattleField then
          w.dismissRaidBtn:Enable(false)
        elseif X2Team:IsJointTeam() == true then
          w.dismissRaidBtn:Enable(X2Team:IsJointLeader())
        else
          w.dismissRaidBtn:Enable(X2Team:IsRaidTeam())
        end
        w.raidRoleBtn:Enable(true)
        w.searchBtn:Enable(not isBattleField)
        w.raidOptionBtn:Enable(not isBattleField)
        if isSiegeRaidTeam then
          w.dismissRaidBtn:Enable(false)
          w.summonBtn:Show(false)
        else
          w.summonBtn:Show(not isBattleField)
        end
      else
        w.dismissRaidBtn:Show(false)
        w.summonBtn:Show(false)
      end
    elseif X2Team:IsTeamOwner(jointOrder, myIndex) == false then
      w.changeToRaidBtn:Show(not isRaidTeam)
      w.changeToRaidBtn:Enable(false)
      w.rangeInviteBtn:Enable(false)
      w.summonBtn:Show(false)
      if isRaidTeam == true then
        w.dismissRaidBtn:Show(true)
        if isSiegeRaidTeam then
          w.dismissRaidBtn:Enable(false)
          w.rangeInviteBtn:Enable(X2Team:IsTeamOfficer(myIndex))
        else
          w.dismissRaidBtn:SetText(locale.team.leave())
          w.dismissRaidBtn:Enable(not isBattleField)
        end
        w.raidRoleBtn:Enable(true)
        w.searchBtn:Enable(not isBattleField)
        w.raidOptionBtn:Enable(not isBattleField)
      else
        w.dismissRaidBtn:Show(false)
      end
    else
      w.changeToRaidBtn:Enable(false)
      w.rangeInviteBtn:Enable(false)
      w.dismissRaidBtn:Show(false)
      w.raidRoleBtn:Enable(false)
      w.summonBtn:Show(false)
      w.searchBtn:Enable(not isBattleField)
      w.raidOptionBtn:Enable(not isBattleField)
    end
  end
  function w:Refresh(memberIndex)
    local party, slot = GetPartyAndSlotIndex(memberIndex)
    self:CheckAuthority()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if myJointOrder == 0 then
      if self.tab:GetSelectedTab() == 2 then
        self.tab:SelectTab(1)
      end
      self.tab.unselectedButton[2]:Enable(false)
    else
      self.tab.unselectedButton[2]:Enable(true)
    end
    self:InvisibleSelfTexture()
    if party ~= nil then
      if slot ~= nil then
        w.party[party].member[slot]:Refresh()
      else
        w.party[party]:Refresh()
      end
    else
      for i = 1, MAX_RAID_PARTIES do
        w.party[i]:Refresh()
      end
    end
  end
  function w.tab:OnTabChangedProc(selected)
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if myJointOrder ~= 0 then
      RaidTeamManager.jointOrder = selected
      RaidTeamManager:Refresh()
    end
  end
  function w.changeToRaidBtn:OnClick()
    X2Team:ConvertToRaidTeam()
  end
  w.changeToRaidBtn:SetHandler("OnClick", w.changeToRaidBtn.OnClick)
  function w.rangeInviteBtn:OnClick()
    X2Team:InviteArea()
  end
  w.rangeInviteBtn:SetHandler("OnClick", w.rangeInviteBtn.OnClick)
  function w.dismissRaidBtn:OnClick()
    if X2Team:IsSiegeRaidTeam() == false then
      local myIndex = X2Team:GetTeamPlayerIndex()
      if X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myIndex) == true then
        X2Team:DismissTeam()
      else
        X2Team:LeaveTeam(X2Team:GetTeamRoleType())
      end
    end
  end
  w.dismissRaidBtn:SetHandler("OnClick", w.dismissRaidBtn.OnClick)
  function w.raidOptionBtn:OnClick()
    w.raidOptionFrame:Show(not w.raidOptionFrame:IsVisible())
  end
  w.raidOptionBtn:SetHandler("OnClick", w.raidOptionBtn.OnClick)
  function w.raidRoleBtn:OnClick()
    w.raidRoleFrame:Show(not w.raidRoleFrame:IsVisible())
  end
  w.raidRoleBtn:SetHandler("OnClick", w.raidRoleBtn.OnClick)
  function w.searchBtn:OnClick()
    ADDON:ToggleContent(UIC_RAID_RECRUIT)
  end
  function w.searchBtn:OnEnter(self)
    local msg = GetCommonText("raid_invite_button_tooltip_text")
    SetTooltip(msg, w.searchBtn)
  end
  w.searchBtn:SetHandler("OnClick", w.searchBtn.OnClick)
  w.searchBtn:SetHandler("OnEnter", w.searchBtn.OnEnter)
  local summonWnd
  function w.summonBtn:OnClick()
    summonWnd = ShowTeamSummon(wnd)
  end
  w.summonBtn:SetHandler("OnClick", w.summonBtn.OnClick)
  function w:ResetAllPartyVisible()
    for i = 1, MAX_RAID_PARTIES do
      w.party[i].visiblePartyBtn:SetChecked(true, true)
      w.party[i].bg:SetVisible(true)
    end
  end
  function w:InvisibleSelfTexture()
    if RaidTeamManager.self_texture ~= nil then
      RaidTeamManager.self_texture:SetVisible(false)
    end
  end
  function w:OnHide()
    if summonWnd ~= nil then
      summonWnd:Show(false)
    end
  end
  w:SetHandler("OnHide", w.OnHide)
  return w
end
RaidTeamManager = CreateRaidTeamManagerFrame("raidTeamManager", "UIParent")
if RaidTeamManager.jointOrder > 0 then
  RaidTeamManager.tab:SelectTab(RaidTeamManager.jointOrder)
else
  RaidTeamManager.tab:SelectTab(1)
end
function ToggleRaidManager(show)
  if show == nil then
    show = not RaidTeamManager:IsVisible()
  end
  if show and (RaidTeamManager.jointOrder == 0 and 0 < X2Team:GetMyTeamJointOrder() or RaidTeamManager.jointOrder > 0 and X2Team:GetMyTeamJointOrder() == 0) then
    RaidTeamManager.jointOrder = X2Team:GetMyTeamJointOrder()
    if RaidTeamManager.jointOrder == 0 then
      RaidTeamManager.tab:SelectTab(1)
    else
      RaidTeamManager.tab:SelectTab(RaidTeamManager.jointOrder)
    end
  end
  RaidTeamManager:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_RAID_TEAM_MANAGER, ToggleRaidManager)
local raidFrameEvents = {
  CONVERT_TO_RAID_TEAM = function()
    RaidTeamManager:Refresh()
    RaidTeamManager:ResetAllPartyVisible()
  end,
  LEFT_LOADING = function()
    RaidTeamManager:Refresh()
  end,
  TEAM_MEMBERS_CHANGED = function(reason, value)
    if reason == "joined" and value.isParty == false or reason == "leaved" and value.isParty == false then
      if RaidTeamManager.jointOrder == value.jointOrder then
        RaidTeamManager:Refresh(value.memberIndex)
      end
    elseif reason == "joined_by_self" then
      if value.isParty == false then
        RaidTeamManager:ResetAllPartyVisible()
      end
      if X2Team:GetMyTeamJointOrder() == 0 then
        RaidTeamManager.jointOrder = 0
        RaidTeamManager.tab:SelectTab(1)
        RaidTeamManager:Refresh()
      else
        RaidTeamManager.tab:SelectTab(X2Team:GetMyTeamJointOrder())
      end
      RaidTeamManager:Refresh()
    elseif reason == "leaved_by_self" and value.isParty == false or reason == "kicked_by_self" or reason == "dismissed" and value.isParty == false then
      RaidTeamManager:Refresh()
      RaidTeamManager:InvisibleSelfTexture()
    elseif reason == "moved" then
      if RaidTeamManager.jointOrder == value.jointOrder then
        RaidTeamManager:Refresh(value.memberIndex)
        RaidTeamManager:Refresh(value.newMemberIndex)
      end
    elseif reason == "refresh" then
      RaidTeamManager:Refresh()
    elseif RaidTeamManager.jointOrder == value.jointOrder then
      RaidTeamManager:Refresh()
    end
  end,
  TEAM_ROLE_CHANGED = function(jointOrder, memberIndex, role)
    local party, slot = GetPartyAndSlotIndex(memberIndex)
    if RaidTeamManager.jointOrder == jointOrder then
      RaidTeamManager.party[party].member[slot]:SetRole(role)
      RaidTeamManager.party[party].member[slot]:UpdateRoleColor(role)
      if X2Team:GetTeamPlayerParty() == party and X2Team:GetTeamPlayerSlot() == slot then
        RaidTeamManager.party[party].member[slot]:UpdateMyRoleBGTexture(role)
      end
    end
  end,
  LOOTING_RULE_MASTER_CHANGED = function()
    for i = 1, MAX_RAID_PARTIES do
      for j = 1, MAX_RAID_PARTY_MEMBERS do
        RaidTeamManager.party[i].member[j]:UpdateLeaderMark()
      end
    end
  end,
  LOOTING_RULE_METHOD_CHANGED = function()
    for i = 1, MAX_RAID_PARTIES do
      for j = 1, MAX_RAID_PARTY_MEMBERS do
        RaidTeamManager.party[i].member[j]:UpdateLeaderMark()
      end
    end
  end,
  ENABLE_TEAM_AREA_INVITATION = function(enable)
    RaidTeamManager.rangeInviteBtn:Enable(enable)
    local message = ""
    if enable == true then
      message = GetUIText(TEAM_TEXT, "enable_area_invite")
    elseif X2Team:IsSiegeRaidTeam() then
      message = GetUIText(COMMON_TEXT, "excute_area_siege_raid_invite")
    else
      message = GetUIText(TEAM_TEXT, "excute_area_invite")
    end
    X2Chat:DispatchChatMessage(CMF_PARTY_AND_RAID_INFO, message)
  end,
  TEAM_JOINT_BREAK = function(enable)
    local DialogHandler = function(wnd)
      wnd:SetTitle(GetCommonText("raid_joint_dismiss"))
      wnd:SetContent(GetCommonText("raid_joint_dismiss_context"))
      function wnd:OkProc()
        X2Team:JointBreakRes(true)
      end
      function wnd:CancelProc()
        X2Team:JointBreakRes(false)
      end
      wnd.time = 0
      function wnd:OnUpdate(dt)
        local REPLY_TIMEOUT = 60000
        self.time = self.time + dt
        if REPLY_TIMEOUT < self.time then
          self:ReleaseHandler("OnUpdate")
          X2DialogManager:OnCancel(wnd:GetId())
        end
      end
      wnd:SetHandler("OnUpdate", wnd.OnUpdate)
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, RaidTeamManager:GetId())
  end,
  TEAM_JOINT_BROKEN = function()
    if RaidTeamManager == nil then
      return
    end
    RaidTeamManager.jointOrder = X2Team:GetMyTeamJointOrder()
    RaidTeamManager.tab:SelectTab(1)
    RaidTeamManager:Refresh()
  end,
  TEAM_JOINTED = function()
    if RaidTeamManager == nil then
      return
    end
    RaidTeamManager.tab:SelectTab(X2Team:GetMyTeamJointOrder())
  end
}
RaidTeamManager:SetHandler("OnEvent", function(this, event, ...)
  raidFrameEvents[event](...)
end)
RegistUIEvent(RaidTeamManager, raidFrameEvents)
