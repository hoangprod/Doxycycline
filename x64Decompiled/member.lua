local MAX_RAID_PARTY_MEMBERS = X2Team:GetMaxPartyMembers()
function CreateRaidTeamManagerMember(id, parent, party, slot)
  local w = SetViewOfRaidTeamManagerMember(id, parent, slot)
  w.memberIndex = (party - 1) * MAX_RAID_PARTY_MEMBERS + (slot - 1) + 1
  w.party = party
  w.slot = slot
  function w:Target()
    if RaidTeamManager.jointOrder == 0 then
      return string.format("team%d", self.memberIndex)
    else
      return string.format("team_%d_%d", RaidTeamManager.jointOrder, self.memberIndex)
    end
  end
  function w:UpdateName()
    local name = X2Unit:UnitName(w:Target())
    if name ~= nil then
      self.nameLabel:SetText(name)
    end
    if RaidTeamManager.self_texture ~= nil and X2Unit:UnitName("player") == name then
      RaidTeamManager.self_texture:SetVisible(true)
      RaidTeamManager.self_texture:RemoveAllAnchors()
      RaidTeamManager.self_texture:AddAnchor("TOPLEFT", w, -5, -6)
      RaidTeamManager.self_texture:AddAnchor("BOTTOMRIGHT", w, 0, 8)
    end
  end
  function w:UpdateLevel()
    local level = X2Unit:UnitLevel(w:Target())
    local heirLevel = X2Unit:UnitHeirLevel(w:Target())
    if heirLevel ~= nil and heirLevel > 0 then
      level = heirLevel
      w.heirIcon:Show(true)
    else
      w.heirIcon:Show(false)
    end
    if level ~= nil then
      self.levelLabel:SetText(tostring(level))
    end
  end
  function w:UpdateAbility()
    local templates = X2Unit:GetTargetAbilityTemplates(w:Target())
    if templates == nil then
      return
    end
    local abilityIndex = {}
    for index = 1, #templates do
      local ability = templates[index]
      abilityIndex[index] = X2Ability:FindAbilityIndexForStr(ability.name)
    end
    local ability
    if F_UNIT.GetCombinedAbilityName ~= nil then
      ability = F_UNIT.GetCombinedAbilityName(abilityIndex[1], abilityIndex[2], abilityIndex[3])
    end
    if ability ~= nil then
      self.abilityLabel:SetText(ability)
    end
  end
  function w:UpdateLeaderMark()
    local authority = X2Unit:UnitTeamAuthority(self:Target())
    local targetName = X2Unit:UnitName(self:Target())
    local distributorName = X2Team:GetTeamDistributorName()
    local heirLevel = X2Unit:UnitHeirLevel(self:Target())
    if distributorName == targetName or authority ~= nil then
      self.nameLabel:RemoveAllAnchors()
      self.nameLabel:AddAnchor("LEFT", self.leaderMark, "RIGHT", 2, 0)
      if heirLevel ~= nil and heirLevel > 0 then
        self.nameLabel:AddAnchor("RIGHT", self.heirIcon, "LEFT", 0, 0)
      else
        self.nameLabel:AddAnchor("RIGHT", self.levelLabel, -13, 0)
      end
      if authority ~= "subleader" or distributorName ~= targetName then
        self.lootIcon:Show(false)
        self.leaderMark:SetMark(authority, true)
      elseif distributorName == targetName then
        self.lootIcon:Show(true)
        self.leaderMark:Show(false)
      end
    else
      self.lootIcon:Show(false)
      self.leaderMark:Show(false)
      self.nameLabel:RemoveAllAnchors()
      self.nameLabel:AddAnchor("LEFT", self.roleMark, "RIGHT", 2, 0)
      if heirLevel ~= nil and heirLevel > 0 then
        self.nameLabel:AddAnchor("RIGHT", self.heirIcon, "LEFT", 0, 0)
      else
        self.nameLabel:AddAnchor("RIGHT", self.levelLabel, -15, 0)
      end
    end
  end
  function w:UpdateOffline()
    local isOffline = X2Unit:UnitIsOffline(self:Target())
    if isOffline then
      ApplyTextColor(self.nameLabel, FONT_COLOR.GRAY)
      ApplyTextColor(self.levelLabel, FONT_COLOR.GRAY)
    else
      ApplyTextColor(self.levelLabel, FONT_COLOR.BLACK)
    end
  end
  function w:UpdateRoleColor(role)
    local info = W_MODULE:GetRoleInfoByRole(role)
    ApplyTextColor(self.nameLabel, info.fontColor)
  end
  function w:UpdateMyRoleBGTexture(role)
    if RaidTeamManager.self_texture == nil then
      return
    end
    local info = W_MODULE:GetRoleInfoByRole(role)
    local color = info.fontColor
    RaidTeamManager.self_texture:SetColor(color[1], color[2], color[3], 0.5)
  end
  function w:UpdateRoleMark()
    local role = X2Team:GetRole(RaidTeamManager.jointOrder, self.memberIndex)
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if role == TMROLE_NONE and (myMemberIndex ~= self.memberIndex or myJointOrder ~= RaidTeamManager.jointOrder) then
      self.roleMark:Show(false)
    else
      if myMemberIndex == self.memberIndex and myJointOrder == RaidTeamManager.jointOrder then
        self:UpdateMyRoleBGTexture(role)
      end
      self:SetRole(role)
    end
    self:UpdateRoleColor(role)
  end
  function w:Refresh()
    if X2Team:IsRaidTeam() == true and X2Unit:UnitIsTeamMember(w:Target()) == true then
      self:Show(true)
      self:UpdateName()
      self:UpdateLevel()
      self:UpdateLeaderMark()
      self:UpdateRoleMark()
      self:UpdateOffline()
      return true
    else
      self:Show(false)
    end
    return false
  end
  function w:SetRole(role)
    if role ~= nil then
      self.roleMark:Show(true)
      self.roleMark:SetMark(role)
    else
      self.roleMark:Show(false)
    end
  end
  local event = w.eventWindow
  event:EnableDrag(true)
  function event:OnClick(arg)
    if w.Click ~= nil then
      local result = w:Click(arg)
      if result ~= nil then
        return
      end
    end
    if arg == "LeftButton" and w:Target() ~= nil then
      X2Unit:TargetUnit(w:Target())
    end
  end
  event:SetHandler("OnClick", event.OnClick)
  function event:OnShow()
    self.bg:SetVisible(false)
  end
  event:SetHandler("OnShow", event.OnShow)
  function event:OnHide()
    self.bg:SetVisible(false)
  end
  event:SetHandler("OnHide", event.OnHide)
  function event:OnEnter()
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if raidteam_moving_member_index == nil then
      local name = X2Unit:UnitName(w:Target())
      local level = X2Unit:UnitLevel(w:Target())
      local heirLevel = X2Unit:UnitHeirLevel(w:Target())
      if heirLevel ~= nil and heirLevel > 0 then
        level = GetCommonText("heir") .. " " .. heirLevel
      end
      local abilityTemplates = X2Unit:GetTargetAbilityTemplates(w:Target())
      if abilityTemplates == nil then
        return
      end
      local tooltipText = name .. "    " .. level
      if abilityTemplates[1].index < COMBAT_ABILITY_MAX then
        tooltipText = tooltipText .. "    " .. locale.common.abilityNameWithStr(abilityTemplates[1].name)
      end
      if abilityTemplates[2].index < COMBAT_ABILITY_MAX then
        tooltipText = tooltipText .. "/" .. locale.common.abilityNameWithStr(abilityTemplates[2].name)
      end
      if abilityTemplates[3].index < COMBAT_ABILITY_MAX then
        tooltipText = tooltipText .. "/" .. locale.common.abilityNameWithStr(abilityTemplates[3].name)
      end
      SetTooltip(tooltipText, self)
    end
    if X2Team:IsTeamOwner(myJointOrder, myMemberIndex) and myJointOrder == RaidTeamManager.jointOrder then
      self.bg:SetVisible(true)
    elseif X2Team:IsPossibleMoveTeamMember(myMemberIndex) then
      self.bg:SetVisible(true)
    end
  end
  event:SetHandler("OnEnter", event.OnEnter)
  function event:OnLeave()
    HideTooltip()
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if raidteam_moving_member_index == nil or raidteam_moving_member_index ~= w.memberIndex then
      if X2Team:IsTeamOwner(myJointOrder, myMemberIndex) and myJointOrder == RaidTeamManager.jointOrder then
        self.bg:SetVisible(false)
      elseif X2Team:IsPossibleMoveTeamMember(myMemberIndex) then
        self.bg:SetVisible(false)
      end
    end
  end
  event:SetHandler("OnLeave", event.OnLeave)
  function event:OnDragStart()
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if X2Team:IsTeamOwner(myJointOrder, myMemberIndex) and myJointOrder == RaidTeamManager.jointOrder then
      raidteam_moving_member_party = w.party
      raidteam_moving_member_index = w.memberIndex
    elseif X2Team:IsPossibleMoveTeamMember(myMemberIndex) then
      raidteam_moving_member_party = w.party
      raidteam_moving_member_index = w.memberIndex
    end
  end
  event:SetHandler("OnDragStart", event.OnDragStart)
  function event:OnDragReceive()
    self.bg:SetVisible(false)
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if X2Team:IsTeamOwner(myJointOrder, myMemberIndex) and myJointOrder == RaidTeamManager.jointOrder then
      if raidteam_moving_member_index ~= nil then
        X2Team:MoveTeamMember(raidteam_moving_member_index, w.memberIndex)
      end
    elseif X2Team:IsPossibleMoveTeamMember(myMemberIndex) and raidteam_moving_member_index ~= nil then
      X2Team:MoveTeamMember(raidteam_moving_member_index, w.memberIndex)
    end
  end
  event:SetHandler("OnDragReceive", event.OnDragReceive)
  function event:OnDragStop(arg)
    self.bg:SetVisible(false)
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if X2Team:IsTeamOwner(myJointOrder, myMemberIndex) and myJointOrder == RaidTeamManager.jointOrder then
      raidteam_moving_member_party = nil
      raidteam_moving_member_index = nil
    elseif X2Team:IsPossibleMoveTeamMember(myMemberIndex) then
      raidteam_moving_member_party = nil
      raidteam_moving_member_index = nil
    end
  end
  event:SetHandler("OnDragStop", event.OnDragStop)
  function event:OnEvent(event, ...)
    if event == "TEAM_MEMBERS_CHANGED" then
      if (arg[1] == "owner_changed" or arg[1] == "officer_changed") and (arg[2].memberIndex == w.memberIndex or arg[2].newMemberIndex == w.memberIndex) then
        w:UpdateLeaderMark()
      end
    elseif event == "TEAM_MEMBER_DISCONNECTED" and arg[1] == false and arg[2] == RaidTeamManager.jointOrder and arg[4] == w.memberIndex then
      w:UpdateOffline()
    end
  end
  event:SetHandler("OnEvent", event.OnEvent)
  event:RegisterEvent("TEAM_MEMBERS_CHANGED")
  event:RegisterEvent("TEAM_MEMBER_DISCONNECTED")
  function w:Click(arg)
    local myMemberIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    if arg == "RightButton" then
      if w.memberIndex == myMemberIndex and myJointOrder == RaidTeamManager.jointOrder then
        ActivatePopupMenu(w, "player")
      else
        local data = {
          jointOrder = RaidTeamManager.jointOrder,
          memberIndex = w.memberIndex
        }
        ActivatePopupMenu(w, "team", data)
      end
    end
  end
  return w
end
