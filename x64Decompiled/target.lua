function TargetWindowHide()
  if targetFrame ~= nil then
    targetFrame:Show(false)
  end
end
function CreateTargetFrame(id, parent)
  local w = CreateUnitFrame(id, parent, UNIT_FRAME_TYPE.TARGET)
  local gradeBg = w:CreateDrawable(TEXTURE_PATH.UNITFRAME_GRADE, "elite", "background")
  gradeBg:SetVisible(false)
  w.gradeBg = gradeBg
  local gradeStar = w:CreateDrawable(TEXTURE_PATH.HUD, "level_02", "background")
  gradeStar:SetVisible(false)
  w.gradeStar = gradeStar
  w.gradeStar:AddAnchor("BOTTOMLEFT", w.level, "BOTTOMRIGHT", -1, 2)
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.GRADE_STAR, w.gradeStar, 5)
  local reporterIcon = w:CreateDrawable(TEXTURE_PATH.REPORTER, "icon_unitframe_reporter", "background")
  reporterIcon:SetVisible(false)
  reporterIcon:AddAnchor("TOPLEFT", w, -23, 20)
  w.reporterIcon = reporterIcon
  local gradeDeco = w.mpBar:CreateDrawable(TEXTURE_PATH.UNITFRAME_GRADE, "deco", "overlay")
  gradeDeco:SetVisible(false)
  w.gradeDeco = gradeDeco
  local distanceLabel = w:CreateChildWidget("label", "distanceLabel", 0, true)
  distanceLabel:Show(true)
  distanceLabel:SetHeight(FONT_SIZE.MIDDLE)
  distanceLabel:AddAnchor("TOPRIGHT", w, 0, 5)
  distanceLabel:SetAutoResize(true)
  distanceLabel.style:SetAlign(ALIGN_LEFT)
  distanceLabel.style:SetShadow(true)
  w.distanceLabel = distanceLabel
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.DISTANCE, w.distanceLabel, 0)
  CreateAbilityIcon("abilityIconFrame", w, "player")
  w.abilityIconFrame:AddAnchor("TOPRIGHT", w, -48, 3)
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.ABILITY, w.abilityIconFrame, 20)
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.LEADER_MARK, w.leaderMark, 10)
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.MARKER, w.marker, 2)
  local reputationButton = W_REPUTATION_BUTTON.Create(w)
  reputationButton:Show(true)
  reputationButton:AddAnchor("TOPRIGHT", w.hpBar, "TOPLEFT", 0, -7)
  w.reputationButton = reputationButton
  function w:UpdateBuffLayout()
    local grade = GetUnitGrade(self.target)
    if grade == nil then
      return
    end
    if grade == "weak" then
      self.buffWindow:SetLayout(6, 30)
      self.debuffWindow:SetLayout(6, 30)
    elseif grade == "normal" then
      self.buffWindow:SetLayout(9, 30)
      self.debuffWindow:SetLayout(9, 30)
    else
      self.buffWindow:SetLayout(14, 30)
      self.debuffWindow:SetLayout(14, 30)
    end
  end
  function w:UpdateGradeStyle(grade)
    self.gradeStar:SetVisible(false)
    self.name:AddAnchor("BOTTOMLEFT", self.level, "BOTTOMRIGHT", 3, -1)
    local coords = {
      GetTextureInfo(TEXTURE_PATH.HUD, "level_01"):GetCoords()
    }
    w.gradeStar:SetCoords(coords[1], coords[2], coords[3], coords[4])
    if grade == nil then
      return
    end
    local hpKey, mpKey
    if grade == "weak" then
      hpKey = "target_hp_bg_weak"
      mpKey = "target_mp_bg_weak"
    elseif grade == "normal" then
      hpKey = "target_hp_bg"
      mpKey = "target_mp_bg"
    elseif grade == "strong" then
      hpKey = "target_hp_bg_strong"
      mpKey = "target_mp_bg_strong"
      self.gradeStar:SetVisible(true)
      self.name:AddAnchor("BOTTOMLEFT", self.level, "BOTTOMRIGHT", 70, -1)
    else
      hpKey = "target_hp_bg_strong"
      mpKey = "target_mp_bg_strong"
      self.gradeBg:SetVisible(true)
      self.gradeStar:SetVisible(true)
      self.name:AddAnchor("BOTTOMLEFT", self.level, "BOTTOMRIGHT", 70, -1)
    end
    if hpKey ~= nil then
      self.hpBar:ChangeBgStyle(hpKey)
    end
    if mpKey ~= nil then
      self.mpBar:ChangeBgStyle(mpKey)
    end
    self:UpdateExtent()
  end
  function w:UpdateGradeBg(unitGrade)
    self.gradeBg:RemoveAllAnchors()
    self.gradeBg:SetVisible(true)
    self.gradeDeco:RemoveAllAnchors()
    self.gradeDeco:SetVisible(false)
    if unitGrade == "elite" then
      self.gradeBg:SetTextureInfo(unitGrade)
      self.gradeBg:AddAnchor("CENTER", self, 5, 12)
    elseif unitGrade == "boss_a" then
      self.gradeBg:SetTextureInfo(unitGrade)
      self.gradeBg:AddAnchor("CENTER", self, -3, 18)
    elseif unitGrade == "boss_b" then
      self.gradeBg:SetTextureInfo(unitGrade)
      self.gradeBg:AddAnchor("CENTER", self, 33, 15)
    elseif unitGrade == "boss_c" then
      self.gradeBg:SetTextureInfo(unitGrade)
      self.gradeBg:AddAnchor("CENTER", self, 30, 15)
    elseif unitGrade == "boss_s" then
      self.gradeBg:SetTextureInfo(unitGrade)
      self.gradeBg:AddAnchor("CENTER", self, 0, 13)
      self.gradeDeco:SetVisible(true)
      self.gradeDeco:AddAnchor("CENTER", self, 0, 8)
    else
      self.gradeBg:SetVisible(false)
      return
    end
    local gradeCoords = {
      elite = "level_02",
      boss_c = "level_03",
      boss_b = "level_04",
      boss_a = "level_05",
      boss_s = "level_06"
    }
    local coords = gradeCoords[unitGrade]
    if coords ~= nil then
      w.gradeStar:SetTextureInfo(coords)
    end
  end
  function w:UpdateDistanceLabel()
    local info = X2Unit:UnitDistance(self.target)
    if info == nil then
      return
    end
    local str
    if info.over_distance then
      str = X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", string.format("???"))
    else
      if info.distance < 0 then
        info.distance = 0
      end
      str = X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", string.format("%.1f", info.distance))
    end
    self.distanceLabel:SetText(str)
  end
  function w:Update()
    self:UpdateDistanceLabel()
  end
  function w:UpdateAbil()
    local unitType, _ = F_UNIT.GetUnitType(self.target)
    if unitType == "player" or unitType == "character" then
      self.abilityIconFrame:Show(true)
      self.abilityIconFrame:SetAbility("target")
    else
      self.abilityIconFrame:Show(false)
    end
  end
  function w:UpdateGrade()
    local unitGrade = GetUnitGrade(self.target)
    self:UpdateGradeStyle(unitGrade)
    self:UpdateGradeBg(unitGrade)
  end
  function w:UpdateReporterIcon()
    self.reporterIcon:SetVisible(X2Unit:IsReporter(self.target))
  end
  function w:UpdateReputationButton()
    self.reputationButton:ToggleReputationWindow(false)
    self.reputationButton:Show(X2Hero:CanAddReputation())
  end
  function w:UpdateStyle_Post()
    self:UpdateDistanceLabel()
    self:UpdateReporterIcon()
    self:UpdateReputationButton()
    self:UpdateGrade()
    self:UpdateAbil()
    self:UpdateBuffLayout()
  end
  function w:Click(arg)
    local unitType, detail = F_UNIT.GetUnitType(w.target)
    if detail == "mate" then
      if arg == "RightButton" then
        if X2Mate:IsTargetMyMate() then
          local mateType = X2Unit:GetUnitMateType(w.target)
          ActivatePopupMenu(w, F_UNIT.GetPetTargetName(mateType))
        else
          ActivatePopupMenu(w, "mate")
        end
      end
    elseif detail == "slave" then
      if arg == "RightButton" then
        ActivatePopupMenu(w, "slave")
      end
    elseif detail == "housing" or detail == "shipyard" or detail == "transfer" or detail == "doodad" then
      return
    elseif arg == "RightButton" then
      if unitType == "character" then
        local name = X2Unit:UnitName("target")
        local targetJointOrder = X2Team:GetMemberIndexByName(name, false)
        local myMemberIndex = X2Team:GetTeamPlayerIndex()
        if targetJointOrder == nil and X2Team:IsRaidTeam() and not X2Team:IsJointTeam() and X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), myMemberIndex) then
          X2Team:JointInfoReq(TEAM_JOINT_MENU_TARGET, "")
          return
        end
      end
      ActivatePopupMenu(w, "target")
    end
  end
  local OnHide = function(self)
    self.reputationButton:ToggleReputationWindow(false)
  end
  w:SetHandler("OnHide", OnHide)
  local OnShow = function(self)
    if X2:IsInClientDrivenZone() == true then
      local stringId = X2Unit:GetTargetUnitId()
      if stringId == nil then
        TargetWindowHide()
        return
      end
      X2Unit:TargetFrameOpened()
    end
  end
  w:SetHandler("OnShow", OnShow)
  w:SetTarget("target")
  return w
end
targetFrame = CreateTargetFrame("targetFrame", "UIParent")
function targetFrame:MakeOriginWindowPos(reset)
  if targetFrame == nil then
    return
  end
  targetFrame:RemoveAllAnchors()
  if reset then
    targetFrame:AddAnchor("TOP", 0, F_LAYOUT.CalcDontApplyUIScale(10))
  else
    targetFrame:AddAnchor("TOP", 0, 10)
  end
end
targetFrame:MakeOriginWindowPos()
AddUISaveHandlerByKey("targetFrame", targetFrame)
targetFrame:ApplyLastWindowOffset()
ADDON:RegisterContentWidget(UIC_TARGET_UNITFRAME, targetFrame)
local targetEvent = {
  TARGET_CHANGED = function(this, stringId, targetType)
    TargetChanged(stringId, targetType)
  end,
  ENTERED_WORLD = function(this)
    local stringId = X2Unit:GetTargetUnitId()
    if stringId == nil then
      return
    end
    local unitType = X2Unit:GetUnitTypeString("target")
    if unitType == "character" or unitType == "player" then
      unitType = "npc"
    end
    TargetChanged(stringId, unitType)
  end,
  TEAM_MEMBER_DISCONNECTED = function(this, isParty, jointOrder, stringId, memberIndex)
    if X2Unit:UnitIsOffline("target") then
      this:Show(false)
    end
  end,
  LEFT_LOADING = function(this)
    local stringId = X2Unit:GetTargetUnitId()
    if this ~= nil and stringId == nil then
      this:Show(false)
    end
  end,
  SHOW_HIDDEN_BUFF = function(this)
    this:ShowHiddenBuffWindow()
  end,
  TEAM_JOINT_TARGET = function(this, isJointable)
    if this:IsVisible() then
      local data = {jointable = isJointable}
      ActivatePopupMenu(this, "target", data)
    end
  end
}
targetFrame:AddOnEvents(targetEvent)
function TargetChanged(stringId, targetType)
  targetFrame.unableGageAni = true
  HideEditDialog(targetFrame)
  if targetType == "npc" then
    targetFrame:Show(true)
    targetFrame:SetTarget("target")
  else
    targetFrame:Show(false)
  end
  HidePopUpMenu(targetFrame)
end
targetCastingBar = W_BAR.CreateCastingBar("targetCastingBar", targetFrame, "target")
targetCastingBar:Show(false)
targetCastingBar:AddAnchor("TOPLEFT", targetFrame.debuffWindow, "BOTTOMLEFT", 0, 0)
targetCastingBar:AddAnchor("RIGHT", targetFrame, "RIGHT", 0, 0)
targetCastingBar:RegisterEvent("SPELLCAST_START")
targetCastingBar:RegisterEvent("SPELLCAST_STOP")
targetCastingBar:RegisterEvent("SPELLCAST_SUCCEEDED")
local targetChangeEvent = {
  TARGET_CHANGED = function(stringId, targetType)
    if stringId == nil then
      targetCastingBar.unit = "none"
    elseif X2Unit:GetUnitId("player") == stringId then
      targetCastingBar.unit = "player"
    else
      targetCastingBar.unit = "target"
    end
    targetCastingBar:Refresh()
  end
}
targetCastingBar:SetEventProc(targetChangeEvent)
targetCastingBar:RegisterEvent("TARGET_CHANGED")
