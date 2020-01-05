local HP_ALPHA_VALUE = 0.5
REINFORCEMENTS_STATE = {
  INVALID = 1,
  NOT_YET = 2,
  ARRIVED = 3
}
function siegeScheduleIcons:OnEnter()
  siegeScheduleIcons.scrollWindow:Lock(false)
end
siegeScheduleIcons:SetHandler("OnEnter", siegeScheduleIcons.OnEnter)
function siegeScheduleIcons:OnLeave()
  siegeScheduleIcons.scrollWindow:Lock(true)
end
siegeScheduleIcons:SetHandler("OnLeave", siegeScheduleIcons.OnLeave)
local GetIdleFuncTable = function()
  local IdleFunction = function()
    return false
  end
  local funcs = {
    OnHealthChanged = IdleFunction,
    OnEnteredSight = IdleFunction,
    OnLeavedSight = IdleFunction
  }
  return funcs
end
for k = 1, #siegeScheduleIcons.icons do
  local icon = siegeScheduleIcons.icons[k]
  local alarm = icon.alarm
  function alarm:ClearData()
    self.guardTowerId = nil
    self.guardTowerVisible = nil
    self.funcTable = GetIdleFuncTable()
  end
  function icon:InitData()
    self.zoneGroupType = 0
    self.zoneGroupName = ""
    self.defenseName = ""
    self.periodName = ""
    self.team = ""
  end
  function icon:Clear()
    self:InitData()
    self.alarm:ClearData()
    self.alarm:ShowButton(false)
    self.alarm:ShowHpBar(false)
    self.alarm:RemoveAllAnchors()
  end
  icon:Clear()
end
function siegeScheduleIcons:SetIconsHandler()
  for k = 1, siegeScheduleIcons.TOTAL_SCHEDULE do
    do
      local btn = self.icons[k].alarm
      local icon = self.icons[k]
      function btn:OnClick(arg)
        ShowSiegeScheduleTab()
      end
      btn:SetHandler("OnClick", btn.OnClick)
      function btn:OnEnter()
        SetTargetAnchorTooltip(btn.tooltipText, "RIGHT", self, "LEFT", -15, btn.toolTipY)
      end
      btn:SetHandler("OnEnter", btn.OnEnter)
      btn:SetHandler("OnLeave", function()
        HideTooltip()
      end)
    end
  end
end
siegeScheduleIcons:SetIconsHandler()
function siegeScheduleIcons:GetIcon(zoneGroupType)
  local icons = self.icons
  local function GetNewIcon()
    for k = 1, #icons do
      if icons[k].zoneGroupType == 0 then
        icons[k].alarm:Show(true)
        return icons[k]
      end
    end
    return nil
  end
  for k = 1, #icons do
    if icons[k].zoneGroupType == zoneGroupType then
      return icons[k]
    end
  end
  return GetNewIcon()
end
function siegeScheduleIcons:DeleteAllIcons()
  for k = 1, #self.icons do
    if self.icons[k].zoneGroupType ~= 0 then
      self.icons[k]:Clear()
    end
  end
  self:Show(false)
end
local UnitHealthChanged = function(alarm, target, curHp, maxHp)
  if target ~= string.format("guardTower%d", alarm.guardTowerId) then
    return false
  end
  alarm:SetHp(curHp, maxHp)
  alarm.hpText.style:SetColor(1, 1, 1, 1)
  if not alarm.guardTowerVisible then
    alarm.guardTowerVisible = true
    alarm.hpBar:SetAlpha(1)
    alarm.hpText:Show(true)
  end
  return true
end
local UnitEnteredSight = function(alarm, unitId, curHp, maxHp)
  if alarm.guardTowerId ~= unitId then
    return false
  end
  alarm.guardTowerVisible = true
  alarm:SetHp(curHp, maxHp)
  alarm.hpBar:SetAlpha(1)
  alarm.hpText:Show(true)
  alarm.hpText.style:SetColor(1, 1, 1, 1)
  return true
end
local function UnitLeavedSight(alarm, unitId)
  if alarm.guardTowerId ~= unitId then
    return false
  end
  alarm.guardTowerVisible = false
  alarm:SetHp(0, 0)
  alarm.hpBar:SetAlpha(HP_ALPHA_VALUE)
  alarm.hpText:SetText(locale.dominion.unknown)
  alarm.hpText.style:SetColor(1, 1, 1, HP_ALPHA_VALUE)
  return true
end
local function GetSiegePeriodFuncTable()
  local funcs = {
    OnHealthChanged = UnitHealthChanged,
    OnEnteredSight = UnitEnteredSight,
    OnLeavedSight = UnitLeavedSight
  }
  return funcs
end
function GetMemberCountText(zoneGroupType, team)
  if team == "defense_team" then
    local memberCount, memberLimit, reinforcedLimit = X2Dominion:GetCurDefenseSiegeParticipantCount(zoneGroupType)
    return string.format("%d/%s", memberCount, locale.common.GetPeopleCount(memberLimit))
  elseif team == "offense_team" then
    local memberCount, memberLimit, reinforcedLimit = X2Dominion:GetCurOffenseSiegeParticipantCount(zoneGroupType)
    return string.format("%d/%s", memberCount, locale.common.GetPeopleCount(memberLimit))
  end
end
function siegeScheduleIcons:UpdateIcon(zoneGroupType, zoneGroupName, defenseName, offenseName, periodName, team, remainDate)
  local icon = self:GetIcon(zoneGroupType)
  if icon == nil then
    return
  end
  local remainDateString = locale.time.GetRemainDateToDateFormat(remainDate)
  function icon.alarm:UpdateIcon()
    if periodName == "siege_period_siege" and X2Dominion:IsSiegeSecondHalf(zoneGroupType) == false then
      self.memberCount:Show(true)
      self.tooltipText = locale.dominion.GetSiegeIconTooltip(zoneGroupName, defenseName, "")
      self.toolTipY = -10
      local labelColor = FONT_COLOR.WHITE
      if remainDate.hour == 0 and remainDate.minute < 10 then
        labelColor = FONT_COLOR.RED
      end
      if team == "defense_team" then
        ChangeButtonSkin(self, BUTTON_CONTENTS.DEFENSE)
      elseif team == "offense_team" then
        ChangeButtonSkin(self, BUTTON_CONTENTS.OFFENSE)
      else
        ChatLog("invalid_team - icon.alarm:UpdateIcon")
        return
      end
      self.memberCount:SetWidth(500)
      self.memberCount:SetText(GetMemberCountText(zoneGroupType, team))
      self.memberCount:SetWidth(self.memberCount:GetLongestLineWidth() + 5)
      self:ShowLabel(true, remainDateString)
      labelColor = FONT_COLOR.WHITE
      ApplyTextColor(self.label, labelColor)
      self:ShowHpBar(true)
      local curHp, maxHp = X2Dominion:GetGuardTowerHp(zoneGroupType)
      local guardTowerVisible = true
      if curHp == nil then
        self:SetHp(0, 0)
        self.hpBar:SetAlpha(HP_ALPHA_VALUE)
        self.hpText:SetText(locale.dominion.unknown)
        self.hpText.style:SetColor(1, 1, 1, HP_ALPHA_VALUE)
        guardTowerVisible = false
      else
        self:SetHp(curHp, maxHp)
        self.hpBar:SetAlpha(1)
        self.hpText.style:SetColor(1, 1, 1, 1)
      end
      self.guardTowerId = X2Dominion:GetGuardTowerId(zoneGroupType)
      self.guardTowerVisible = guardTowerVisible
      self.funcTable = GetSiegePeriodFuncTable()
    elseif periodName == "siege_period_ready_to_siege" then
      self.tooltipText = locale.dominion.GetSiegeIconTooltip(zoneGroupName, defenseName, "")
      self.toolTipY = 0
      local labelColor = FONT_COLOR.WHITE
      if remainDate.hour == 0 and remainDate.minute < 10 then
        labelColor = FONT_COLOR.RED
      end
      icon.alarm:ShowLabel(true, remainDateString)
      ChangeButtonSkin(self, BUTTON_CONTENTS.SIEGE_PERIOD_DECLARE)
      ApplyTextColor(self.label, labelColor)
      self.memberCount:Show(false)
      self:ClearData()
    else
      self.tooltipText = locale.dominion.GetSiegeIconTooltip(zoneGroupName, defenseName, remainDateString)
      self.toolTipY = 0
      self:Show(false)
      self.memberCount:Show(false)
      self:ShowLabel(false, "")
      self:ShowHpBar(false)
      self:ClearData()
    end
  end
  icon.zoneGroupType = zoneGroupType
  icon.zoneGroupName = zoneGroupName
  icon.defenseName = defenseName
  icon.periodName = periodName
  icon.team = team
  icon.alarm:UpdateIcon()
  local height = 0
  for k = #self.icons, 1, -1 do
    if self.icons[k].zoneGroupType ~= 0 then
      self.icons[k].alarm:AddAnchor("TOPRIGHT", self.scrollWindow.content, 0, height)
      height = height + self.BUTTONHEIGHT
    end
  end
  self.scrollWindow:ResetScroll(height)
  self:Show(true)
end
local events = {
  GUARDTOWER_HEALTH_CHANGED = function(target, curHp, maxHp)
    for k = 1, #siegeScheduleIcons.icons do
      local alarm = siegeScheduleIcons.icons[k].alarm
      if alarm.funcTable.OnHealthChanged(alarm, target, curHp, maxHp) then
        return
      end
    end
  end,
  UNIT_ENTERED_SIGHT = function(unitId, unitType, curHp, maxHp)
    if unitType ~= "housing" then
      return
    end
    for k = 1, #siegeScheduleIcons.icons do
      local alarm = siegeScheduleIcons.icons[k].alarm
      if alarm.funcTable.OnEnteredSight(alarm, unitId, curHp, maxHp) then
        return
      end
    end
  end,
  UNIT_LEAVED_SIGHT = function(unitId, unitType)
    if unitType ~= "housing" then
      return
    end
    for k = 1, #siegeScheduleIcons.icons do
      local alarm = siegeScheduleIcons.icons[k].alarm
      if alarm.funcTable.OnLeavedSight(alarm, unitId) then
        return
      end
    end
  end,
  DOMINION_SIEGE_PARTICIPANT_COUNT_CHANGED = function(zoneGroupType)
    for k = 1, #siegeScheduleIcons.icons do
      local icon = siegeScheduleIcons.icons[k]
      if icon.zoneGroupType == zoneGroupType then
        local text = GetMemberCountText(zoneGroupType, icon.team)
        icon.alarm.memberCount:SetWidth(500)
        icon.alarm.memberCount:SetText(text)
        icon.alarm.memberCount:SetWidth(self.memberCount:GetLongestLineWidth() + 5)
        return
      end
    end
  end
}
siegeScheduleIcons:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(siegeScheduleIcons, events)
