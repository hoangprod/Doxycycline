local HP_BAR_STYLES = {
  hostile = {
    short = STATUSBAR_STYLE.S_HP_HOSTILE,
    long = STATUSBAR_STYLE.L_HP_HOSTILE
  },
  neutral = {
    short = STATUSBAR_STYLE.S_HP_NEUTRAL,
    long = STATUSBAR_STYLE.L_HP_NEUTRAL
  },
  friendly = {
    short = STATUSBAR_STYLE.S_HP_FRIENDLY,
    long = STATUSBAR_STYLE.L_HP_FRIENDLY
  },
  team = {
    long = STATUSBAR_STYLE.S_HP_PARTY
  },
  preemtive_strike = {
    short = STATUSBAR_STYLE.S_HP_PREEMTIVE_STRIKE,
    long = STATUSBAR_STYLE.L_HP_PREEMTIVE_STRIKE
  }
}
local MP_BAR_STYLES = {
  short = STATUSBAR_STYLE.S_MP,
  long = STATUSBAR_STYLE.L_MP
}
function CreateUnitFrame(id, parent, frameType)
  parent = parent or "UIParent"
  local w = SetViewOfUnitFrame(id, parent, frameType)
  local event = w.eventWindow
  local dist = false
  local hpBar = w.hpBar
  local mpBar = w.mpBar
  hpBar.statusBar:SetMinMaxValues(0, 1000)
  mpBar.statusBar:SetMinMaxValues(0, 1000)
  w.frameType = frameType
  w.target = nil
  w.party = false
  w.unableGageAni = true
  w.barStyleKey = nil
  w.barSizeKey = nil
  w.drag = false
  function w:UpdateAll()
    self:UpdateLevel()
    self:UpdateName()
    self:UpdateHpMp()
    self:UpdateBuffDebuff()
    self:UpdateTooltip()
    self:UpdateLeaderMark()
    self:UpdateMarker()
    self:UpdateLootIcon()
    self:UpdatePVPIcon()
    self:UpdateCombatIcon()
    self:UpdateStyle()
  end
  function w:UpdateStyle()
    self:UpdateFrameStyle()
    self:UpdateBarStyle()
    if self.UpdateStyle_Post then
      self:UpdateStyle_Post()
    end
    self:UpdateExtent()
    self:UpdateNameWidth()
  end
  function w:SetTarget(target)
    self.target = target
    self:UpdateAll()
    self:SetHandler("OnUpdate", self.OnUpdate)
  end
  function w:SetVisibleHealthText(visible)
    self.hpBar.hpLabel:Show(visible)
  end
  function w:SetVisibleBuffDebuffText(visible)
    self.buffWindow:ShowLifeTime(visible)
    self.debuffWindow:ShowLifeTime(visible)
  end
  function w:SetLevel(level, heirLevel)
    self.level:ChangedLevel(level, heirLevel)
    self:ShowHeirIcon(heirLevel)
  end
  function w:SetHp(curHp, maxHp)
    maxHp = maxHp or 0
    local statusBarAni = false
    local aniTime = 0
    self.hpBar.statusBar:SetMinMaxValues(0, maxHp)
    if curHp > self.hpBar.statusBar:GetValue() then
      statusBarAni = true
      aniTime = 0.2
      self.hpBar:ChangeAfterImageColor(true)
    end
    if self.unableGageAni or self.target ~= "player" and self.target ~= "target" then
      statusBarAni = false
    end
    self.hpBar.statusBar:SetValue(curHp or 0, statusBarAni, aniTime)
    statusBarAni = false
    aniTime = 0
    self.hpBar.statusBarAfterImage:SetMinMaxValues(0, maxHp)
    if curHp < self.hpBar.statusBarAfterImage:GetValue() then
      statusBarAni = true
      aniTime = 0.3
      self.hpBar:ChangeAfterImageColor(false)
    end
    if self.unableGageAni or self.target ~= "player" and self.target ~= "target" then
      statusBarAni = false
    end
    self.hpBar.statusBarAfterImage:SetValue(curHp or 0, statusBarAni, aniTime)
    self.unableGageAni = false
    local show = GetOptionItemValue("ShowHeatlthNumber") == 1
    self.hpBar.hpLabel:Show(show)
    local hpStr = string.format("%d", curHp)
    self.hpBar.hpLabel:SetText(hpStr)
  end
  function w:SetMp(curMp, maxMp)
    self.mpBar.statusBar:SetMinMaxValues(0, maxMp or 0)
    self.mpBar.statusBar:SetValue(curMp or 0)
    local show = GetOptionItemValue("ShowMagicPointNumber") == 1
    self.mpBar.mpLabel:Show(show)
    local hpStr = string.format("%d", curMp)
    self.mpBar.mpLabel:SetText(hpStr)
  end
  function w:ShowLeaderMark(show)
    show = show or false
    self.leaderMark:Show(show)
  end
  function w:ShowPVPIcon(stringId, on)
    local stringUnitId = X2Unit:GetUnitId(self.target)
    if stringUnitId == nil then
      return
    end
    if stringUnitId ~= stringId then
      return
    end
    self.pvpIcon:Show(on)
  end
  function w:ShowLootIcon(show)
    show = show or false
    self.lootIcon:Show(show)
  end
  function w:ShowCombatIcon(show)
    show = show or false
    self.combatIcon:SetVisible(show)
  end
  function w:UpdateLevel()
    local level = X2Unit:UnitLevel(self.target) or 0
    local heirLevel = X2Unit:UnitHeirLevel(self.target) or 0
    self:SetLevel(level, heirLevel)
  end
  function w:UpdateName()
    local name = X2Unit:UnitName(self.target) or ""
    self.name:SetText(name)
  end
  function w:UpdateHpMp()
    local curHp = X2Unit:UnitHealth(self.target)
    local maxHp = X2Unit:UnitMaxHealth(self.target)
    if self.target == "player" then
      LifeAlertEffect(curHp, maxHp)
      if PlayerFrameLifeAlertEffect ~= nil then
        PlayerFrameLifeAlertEffect(curHp, maxHp)
      end
    end
    if curHp ~= nil and maxHp ~= nil then
      self:SetHp(curHp, maxHp)
    end
    local curMp = X2Unit:UnitMana(self.target) or 0
    local maxMp = X2Unit:UnitMaxMana(self.target) or 0
    self:SetMp(curMp, maxMp)
  end
  function w:UpdateBuffDebuff()
    w.buffWindow:BuffUpdate(self.target)
    w.debuffWindow:BuffUpdate(self.target)
    if w.hiddenWindow then
      w.hiddenWindow:BuffUpdate(self.target)
    end
  end
  function w:UpdateTooltip()
    local unit_type = X2Unit:GetUnitType(self.target)
    self.tooltipText = ""
    self.gradeText = ""
    if unit_type == "transfer" then
      self.tooltipText = string.format([[
%s
%s]], locale.unitFrame.transfer, UFT_NAME)
    elseif unit_type == "npc" then
      local str = ""
      local npcTypeString = X2Unit:GetNpcInfo(self.target)
      if npcTypeString ~= nil then
        str = npcTypeString
      else
        local kind = X2Unit:GetTargetKindType(self.target)
        if kind ~= nil then
          str = locale.kindName[kind]
        end
      end
      local grade = tostring(GetUnitGrade(self.target))
      if unitframeLocale.tooltipForceLeft then
        if str ~= "" then
          str = string.format([[
%s
%s%s|r]], str, GetUnitGradeColor(grade), X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, grade))
        else
          str = string.format("%s%s", GetUnitGradeColor(grade), X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, grade))
        end
      else
        self.gradeText = string.format("%s%s", GetUnitGradeColor(grade), X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, grade))
      end
      if str ~= "" then
        str = string.format([[
%s
%s: %s / %s (%s%%)
%s: %s / %s (%s%%)]], str, locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP, locale.tooltip.mp, UFT_CURMP, UFT_MAXMP, UFT_PERMP)
      else
        str = string.format([[
%s: %s / %s (%s%%)
%s: %s / %s (%s%%)]], locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP, locale.tooltip.mp, UFT_CURMP, UFT_MAXMP, UFT_PERMP)
      end
      self.tooltipText = str
    elseif unit_type == "housing" or unit_type == "slave" or unit_type == "shipyard" then
      local unitId = X2Unit:GetUnitId(self.target)
      local unitInfo = X2Unit:GetUnitInfoById(unitId)
      if unitInfo.owner_name == nil then
        self.tooltipText = string.format("%s: %s / %s (%s%%)", locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP)
      else
        self.tooltipText = string.format([[
%s: %s
%s : %s / %s (%s%%)]], locale.tooltip.owner, unitInfo.owner_name, locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP)
      end
    elseif unit_type == "mate" then
      local unitId = X2Unit:GetUnitId(self.target)
      local unitInfo = X2Unit:GetUnitInfoById(unitId)
      self.tooltipText = string.format([[
%s: %s
%s: %s / %s (%s%%)
%s: %s / %s (%s%%)]], locale.tooltip.owner, unitInfo.owner_name or "none", locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP, locale.tooltip.mp, UFT_CURMP, UFT_MAXMP, UFT_PERMP)
    elseif unit_type == "portal" then
      self.tooltipText = locale.unitFrame.portal
    else
      local templates = X2Unit:GetTargetAbilityTemplates(self.target)
      if templates == nil then
        return
      end
      local abilityNames = ""
      local abilityIndex = {}
      for index = 1, #templates do
        local ability = templates[index]
        abilityIndex[index] = ability.index
        if ability.name ~= "invalid ability" then
          if abilityNames == "" then
            abilityNames = locale.common.abilityNameWithStr(ability.name)
          else
            abilityNames = string.format("%s, %s", abilityNames, locale.common.abilityNameWithStr(ability.name))
          end
        end
      end
      local featureSet = X2Player:GetFeatureSet()
      if featureSet.hero and not X2BattleField:IsInGlobalField() and not X2Indun:IsEntranceIndunMatch() then
        self.tooltipText = string.format([[
%s%s: %s (%s)
%s%s: %s / %s (%s%%)
%s%s: %s / %s (%s%%)
%s%s: %s
%s%s: %s
%s%s: %s
%s : %s]], FONT_COLOR_HEX.SOFT_BROWN, locale.community.job, F_UNIT.GetCombinedAbilityName(abilityIndex[1], abilityIndex[2], abilityIndex[3]), abilityNames, FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP, FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.mp, UFT_CURMP, UFT_MAXMP, UFT_PERMP, F_COLOR.GetColor("bright_blue", true), GetUIText(COMMON_TEXT, "gear_score"), UFT_GEARSCORE, FONT_COLOR_HEX.SOFT_BROWN, locale.tooltip.leadership, UFT_PERIOD_LEADERSHIP, FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_honor_point, UFT_PVPHONOR, locale.unitFrame.pvp_kill_point, UFT_PVPKILL)
      else
        self.tooltipText = string.format([[
%s%s: %s (%s)
%s%s: %s / %s (%s%%)
%s%s: %s / %s (%s%%)
%s%s: %s
%s%s: %s
%s : %s]], FONT_COLOR_HEX.SOFT_BROWN, locale.community.job, F_UNIT.GetCombinedAbilityName(abilityIndex[1], abilityIndex[2], abilityIndex[3]), abilityNames, FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.hp, UFT_CURHP, UFT_MAXHP, UFT_PERHP, FONT_COLOR_HEX.BRIGHT_GREEN, locale.tooltip.mp, UFT_CURMP, UFT_MAXMP, UFT_PERMP, F_COLOR.GetColor("bright_blue", true), GetUIText(COMMON_TEXT, "gear_score"), UFT_GEARSCORE, FONT_COLOR_HEX.SOFT_BROWN, locale.unitFrame.pvp_honor_point, UFT_PVPHONOR, locale.unitFrame.pvp_kill_point, UFT_PVPKILL)
      end
    end
  end
  function w:UpdateLeaderMark()
    local authority = X2Unit:UnitTeamAuthority(self.target)
    if authority ~= nil then
      self:ShowLeaderMark(true)
      self.leaderMark:SetMark(authority, true)
    else
      self:ShowLeaderMark(false)
    end
  end
  function w:UpdateLootIcon()
    local targetName = X2Unit:UnitName(self.target)
    local name = X2Team:GetTeamDistributorName()
    if name == targetName then
      self:ShowLootIcon(true)
    else
      self:ShowLootIcon(false)
    end
  end
  function w:UpdatePVPIcon()
    local stringId = X2Unit:GetUnitId(self.target)
    local forceAttack = X2Unit:UnitIsForceAttack(self.target)
    self:ShowPVPIcon(stringId, forceAttack)
  end
  function w:UpdateCombatIcon()
    if self:IsVisible() ~= true then
      return
    end
    local isCombatState = X2Unit:UnitCombatState(self.target)
    if self.combatIcon:IsVisible() == isCombatState then
      return
    end
    self:ShowCombatIcon(isCombatState)
  end
  function w:UpdateMarker()
    self.marker:SetVisible(self.marker:SetMarker(X2Unit:GetOverHeadMarker(self.target)))
    self:UpdateMarkerAnchor()
  end
  function w:UpdateMarkerAnchor()
    if self.marker == nil then
      return
    end
    self.marker:RemoveAllAnchors()
    if self.leaderMark:IsVisible() then
      self.marker:AddAnchor("LEFT", self.leaderMark, "RIGHT", -1, -1)
    else
      self.marker:AddAnchor("LEFT", self.name, "RIGHT", 0, 0)
    end
  end
  function w:IsPreemtiveStrike()
    local unitType, detailType = F_UNIT.GetUnitType(self.target)
    local isPreemtiveStrike = detailType == "npc" and X2Unit:UnitCombatState(self.target) and X2Unit:IsFirstHitByMeOrMyTeam(self.target) == false
    return isPreemtiveStrike
  end
  function w:GetBarStyleKey()
    if self:IsPreemtiveStrike() then
      return "preemtive_strike"
    end
    if self.frameType == UNIT_FRAME_TYPE.PARTY then
      return "team"
    end
    local faction = X2Unit:GetCombatRelationshipStr(self.target)
    if faction == nil then
      return "neutral"
    end
    return faction
  end
  function w:GetBarSizeKey()
    local grade = GetUnitGrade(self.target)
    if grade == "weak" then
      return "short"
    else
      return "long"
    end
  end
  function w:UpdateBarStyle()
    if X2Unit:GetUnitId(self.target) == nil then
      return
    end
    local styleKey = self:GetBarStyleKey()
    local sizeKey = self:GetBarSizeKey()
    if styleKey == nil or sizeKey == nil then
      return
    end
    if self.barStyleKey == styleKey and self.barSizeKey == sizeKey then
      return
    end
    self.barStyleKey = styleKey
    self.barSizeKey = sizeKey
    self.hpBar:ApplyBarTexture(HP_BAR_STYLES[styleKey][sizeKey])
    self.mpBar:ApplyBarTexture(MP_BAR_STYLES[sizeKey])
  end
  function w:SetFrameStyle_Player()
    self.level:Show(true)
    self.name:RemoveAllAnchors()
    self.name:AddAnchor("BOTTOMLEFT", self.level, "BOTTOMRIGHT", 2, -1)
    self.mpBar:Show(true)
    self.combatIcon:RemoveAllAnchors()
    self.combatIcon:AddAnchor("TOPLEFT", self.hpBar, -UNIT_FRAME_COMBAT_ICON_OFFSET, -UNIT_FRAME_COMBAT_ICON_OFFSET)
    self.combatIcon:AddAnchor("BOTTOMRIGHT", self.mpBar, UNIT_FRAME_COMBAT_ICON_OFFSET, UNIT_FRAME_COMBAT_ICON_OFFSET)
    self.buffWindow:RemoveAllAnchors()
    self.buffWindow:AddAnchor("TOPLEFT", self.mpBar, "BOTTOMLEFT", 2, 4)
  end
  function w:SetFrameStyle_ETC()
    self.level:Show(false)
    self.name:RemoveAllAnchors()
    self.name:AddAnchor("TOPLEFT", self, 0, 4)
    self.pvpIcon:Show(false)
    self.lootIcon:Show(false)
    self.leaderMark:Show(false)
    self.mpBar:Show(false)
    self.buffWindow:RemoveAllAnchors()
    self.buffWindow:AddAnchor("TOPLEFT", self.hpBar, "BOTTOMLEFT", 2, 4)
    self.combatIcon:RemoveAllAnchors()
    self.combatIcon:AddAnchor("TOPLEFT", self.hpBar, -UNIT_FRAME_COMBAT_ICON_OFFSET, -UNIT_FRAME_COMBAT_ICON_OFFSET)
    self.combatIcon:AddAnchor("BOTTOMRIGHT", self.hpBar, UNIT_FRAME_COMBAT_ICON_OFFSET, UNIT_FRAME_COMBAT_ICON_OFFSET)
  end
  function w:UpdateFrameStyle()
    local _, detailType = F_UNIT.GetUnitType(self.target)
    if detailType == nil then
      return
    end
    if detailType == "slave" or detailType == "housing" or detailType == "transfer" or detailType == "shipyard" then
      self:SetFrameStyle_ETC()
    else
      self:SetFrameStyle_Player()
    end
  end
  local timeCheck = 0
  function w:OnUpdate(dt)
    timeCheck = timeCheck + dt
    if timeCheck < 100 then
      return
    end
    timeCheck = dt
    if w.Update ~= nil and w:Update(dt) == false then
      return
    end
    if self.drag then
      local shift = X2Input:IsShiftKeyDown()
      if not shift then
        event:OnDragStop()
      end
    end
    if X2Unit:UnitIsOffline(self.target) == true then
      return
    end
    self:UpdateBuffDebuff()
    self:UpdateCombatIcon()
    self:UpdateHpMp()
    self:UpdateBarStyle()
  end
  function event:OnClick(arg)
    RaiseUnitFrameTooltip()
    if w.Click ~= nil and w:Click(arg) ~= nil then
      return
    end
    if arg == "LeftButton" then
      X2Unit:TargetUnit(w.target)
    end
  end
  event:SetHandler("OnClick", event.OnClick)
  function event:OnEnter()
    if w.Enter ~= nil and w:Enter() ~= nil then
      return
    end
    w.tooltipText = w.tooltipText or ""
    w.gradeText = w.gradeText or ""
    if w.tooltipText ~= "" then
      ShowUnitFrameTooltip(w.target, w.tooltipText, w.gradeText, w.eventWindow, w.hpBar)
    end
  end
  event:SetHandler("OnEnter", event.OnEnter)
  function event:OnLeave()
    if w.Leave ~= nil and w:Leave() ~= nil then
      return
    end
    HideUnitFrameTooltip()
  end
  event:SetHandler("OnLeave", event.OnLeave)
  local OnDragStart = function(delegator, callbacker)
    HideTooltip()
    local shift = X2Input:IsShiftKeyDown()
    if delegator.DragStart ~= nil then
      local result = delegator:DragStart(arg, shift)
      if result ~= nil then
        return
      end
    end
    if shift then
      delegator:StartMoving()
      X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
      delegator.drag = true
    end
  end
  event:SetDelegator("OnDragStart", w, OnDragStart)
  local OnDragStop = function(delegator, callbacker)
    if delegator.DragStop ~= nil then
      local result = delegator:DragStop()
      if result ~= nil then
        return
      end
    end
    delegator.drag = false
    delegator:StopMovingOrSizing()
    X2Cursor:ClearCursor()
  end
  event:SetDelegator("OnDragStop", w, OnDragStop)
  local events = {
    SET_OVERHEAD_MARK = function(this, unitId, index, visible)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateMarker()
      this:UpdateNameWidth()
    end,
    UNIT_COMBAT_STATE_CHANGED = function(this, bool, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:ShowCombatIcon(bool)
    end,
    TEAM_MEMBERS_CHANGED = function(this, reason, value)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateLootIcon()
      this:UpdateLeaderMark()
      this:UpdateMarker()
      this:UpdateNameWidth()
      if (X2BattleField:IsInGlobalField() or X2Indun:IsEntranceIndunMatch()) and reason ~= "refresh" and reason ~= "moved" then
        X2BattleField:RequestLeaveUserList()
      end
    end,
    UNIT_NAME_CHANGED = function(this, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateName()
      this:UpdateNameWidth()
    end,
    TEAM_JOINTED = function(this)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateLeaderMark()
      this:UpdateMarkerAnchor()
    end,
    TEAM_JOINT_BROKEN = function(this)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateLeaderMark()
      this:UpdateMarkerAnchor()
    end,
    LOOTING_RULE_MASTER_CHANGED = function(this)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateLootIcon()
    end,
    LOOTING_RULE_METHOD_CHANGED = function(this)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateLootIcon()
    end,
    FORCE_ATTACK_CHANGED = function(this, unitId, on)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:ShowPVPIcon(unitId, on)
    end,
    LEVEL_CHANGED = function(this, _, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateLevel()
    end,
    HEIR_LEVEL_UP = function(this, _, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateLevel()
    end,
    UNITFRAME_ABILITY_UPDATE = function(this, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateTooltip()
    end,
    STARTED_DUEL = function(this, unitId)
      if this:IsVisible() ~= true then
        return
      end
      local targetUnit = X2Unit:GetUnitId(this.target)
      if unitId ~= targetUnit then
        return
      end
      this:UpdateBarStyle()
    end,
    ENDED_DUEL = function(this, unitId)
      if this:IsVisible() ~= true then
        return
      end
      local targetUnit = X2Unit:GetUnitId(this.target)
      if unitId ~= targetUnit then
        return
      end
      this:UpdateBarStyle()
    end,
    UI_PERMISSION_UPDATE = function(this)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateTooltip()
    end,
    LEAVED_INSTANT_GAME_ZONE = function(this)
      if this:IsVisible() ~= true then
        return
      end
      this:UpdateTooltip()
    end,
    DOMINION_GUARD_TOWER_UPDATE_TOOLTIP = function(this, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateTooltip()
    end,
    UPDATE_HOUSING_TOOLTIP = function(this, unitId)
      if this:IsVisible() ~= true then
        return
      end
      if unitId ~= X2Unit:GetUnitId(this.target) then
        return
      end
      this:UpdateTooltip()
    end
  }
  w.events = events
  w:SetHandler("OnEvent", function(this, event, ...)
    w.events[event](this, ...)
  end)
  RegistUIEvent(w, w.events)
  function w:AddOnEvent(key, func)
    self.events[key] = func
  end
  function w:AddOnEvents(events)
    for key, func in pairs(events) do
      self:AddOnEvent(key, func)
    end
    RegistUIEvent(self, events)
  end
  return w
end
