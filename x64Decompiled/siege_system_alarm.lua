function siegeSystemAlarmWindow:OnUpdate(dt)
  self.showingTime = dt + self.showingTime
  if self.showingTime > 5000 then
    self:Show(false, 1000)
    self:ReleaseHandler("OnUpdate")
  end
end
function siegeSystemAlarmWindow:UpdateSiegeSchedule(zoneGroupType, periodName, zoneGroupName, defenseName, offenseName, onEvent, isMyInfo, action)
  if X2Quest:IsQuestDirectingMode() == true or X2Dominion:CanUpdateSiegeSchedule() == false then
    return false
  end
  if isMyInfo == nil then
    isMyInfo = false
  end
  self.periodName = periodName
  local siegeInfoText = ""
  local defenseWin = false
  if periodName == "siege_period_ready_to_siege" then
    if action == "change_state" then
      siegeInfoText = locale.dominion.GetSiegeMsgForAlarm(periodName, zoneGroupName, onEvent)
    elseif action == "declared_siege" then
      siegeInfoText = X2Locale:LocalizeUiText(DOMINION, action, offenseName, zoneGroupName)
    end
  elseif periodName == "siege_period_siege" then
    siegeInfoText = locale.dominion.GetSiegeMsgForAlarm(periodName, zoneGroupName, onEvent)
  elseif periodName == "siege_period_peace" then
    local ownerFaction = X2Dominion:GetOwnerFactionName(zoneGroupType)
    if defenseName == ownerFaction then
      defenseWin = true
    end
    if isMyInfo then
      siegeInfoText = ""
      if self.engravingName ~= nil then
        siegeInfoText = locale.dominion.engravingSucceed(self.engravingName, ownerFaction)
      end
    elseif defenseName == ownerFaction then
      siegeInfoText = X2Locale:LocalizeUiText(DOMINION, "alarm_dominion_win_defense", defenseName, zoneGroupName)
    else
      siegeInfoText = X2Locale:LocalizeUiText(DOMINION, "alarm_dominion_win_offense", ownerFaction, zoneGroupName)
    end
  else
    return false
  end
  self:SetInfo(periodName, siegeInfoText)
  self:SetLayoutSiegeSchedule(periodName, action, onEvent, isMyInfo, defenseWin, zoneGroupType)
  self:Show(true)
  self:SetHandler("OnUpdate", self.OnUpdate)
  self.showingTime = 0
  self.engravingName = nil
  return true
end
function siegeSystemAlarmWindow:ReinforcementsArrived(reinforcementsExpeditionName)
  if X2Quest:IsQuestDirectingMode() == true then
    return false
  end
  local message = locale.dominion.GetReinforcementsArrived(reinforcementsExpeditionName)
  self:SetInfoReinforcement(message)
  self:SetLayoutReinforcement()
  self:Show(true)
  self:SetHandler("OnUpdate", self.OnUpdate)
  self.showingTime = 0
  return true
end
function siegeSystemAlarmWindow:AlertGuardTower(status)
  if X2Quest:IsQuestDirectingMode() == true then
    return false
  end
  local message = locale.dominion.GetGuardTowerStatusMsg(status)
  self:SetInfoGuardTower(message)
  self:SetLayoutGuardTower(status)
  self:Show(true)
  self:SetHandler("OnUpdate", self.OnUpdate)
  self.showingTime = 0
  return true
end
function siegeSystemAlarmWindow:AlertEngraving(status, name, factionName)
  if X2Quest:IsQuestDirectingMode() == true then
    return false
  end
  local message = locale.dominion.GetEngravingStatusMsg(status, name, factionName)
  self:SetInfoEngraving(status, message)
  self:SetLayoutEngraving(status)
  self:Show(true)
  self:SetHandler("OnUpdate", self.OnUpdate)
  self.showingTime = 0
  return true
end
function siegeSystemAlarmWindow:DeclareTerritory(str)
  if X2Quest:IsQuestDirectingMode() == true then
    return false
  end
  self:SetInfoDeclareTerritor(str)
  self:SetLayoutDeclareTerritory()
  self:Show(true)
  self:SetHandler("OnUpdate", self.OnUpdate)
  self.showingTime = 0
  return true
end
