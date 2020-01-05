local FireFirstEnteredWorldChatMessage = function(firstEnteredWorld, zoneGroupType)
  if firstEnteredWorld ~= true or zoneGroupType == nil then
    return
  end
  local periodName = X2Dominion:GetSiegePeriodName()
  if periodName ~= "siege_period_ready_to_siege" and periodName ~= "siege_period_siege" and periodName ~= "siege_period_hero_volunteer" then
    return
  end
  local zoneGroupName = X2Dominion:GetZoneGroupName(zoneGroupType)
  local func = locale.dominion.GetSiegeMsgInProgress
  local text = func(periodName, zoneGroupName)
  X2Chat:DispatchChatMessage(CMF_DOMINION_AND_SIEGE_INFO, text)
end
function UpdateSiegeSchedule(firstEnteredWorld)
  local GetTeamString = function(zoneGroupType)
    local result, team = X2Dominion:IsSiegeExpedition(zoneGroupType)
    if result == true then
      return team
    end
    return "invalid_team"
  end
  siegeScheduleIcons:DeleteAllIcons()
  local periodName = X2Dominion:GetSiegePeriodName()
  local zoneGroupType = X2Dominion:GetSiegeZoneGroup()
  if periodName == "siege_period_ready_to_siege" or periodName == "siege_period_siege" then
    local zoneGroupName = X2Dominion:GetZoneGroupName(zoneGroupType)
    local defenseName = X2Dominion:GetSiegeCurDeffenseExpeditionName(zoneGroupType)
    local offenseName = X2Dominion:GetSiegeCurOffenseExpeditionName(zoneGroupType)
    local team = GetTeamString(zoneGroupType)
    if team ~= "invalid_team" then
      siegeScheduleIcons:UpdateIcon(zoneGroupType, zoneGroupName, defenseName, offenseName, periodName, team, X2Dominion:GetCurPeriodRemainDate(zoneGroupType))
    end
    if firstEnteredWorld == true and zoneGroupType ~= nil then
      local imgEventInfo = MakeImgEventInfo("DOMINION_SIEGE_PERIOD_CHANGED", AddSiegeScheduleMsg, {
        zoneGroupType,
        periodName,
        zoneGroupName,
        defenseName,
        offenseName,
        false,
        true,
        "change_state"
      })
      AddImgEventQueue(imgEventInfo)
      ShowSiegeAlarm(true, periodName)
    end
  end
  FireFirstEnteredWorldChatMessage(firstEnteredWorld, zoneGroupType)
end
function SiegePeriodChanged(action, zoneGroupType, zoneGroupName, defenseName, offenseName, periodName, isMyInfo, team)
  if action == "ignore" then
    return
  end
  if action == "change_state" or action == "declared_siege" then
    local remainDate = X2Dominion:GetCurPeriodRemainDate(zoneGroupType)
    local remainDateFormat = locale.time.GetRemainDateToDateFormat(remainDate)
    local func = locale.dominion.GetSiegeMsg
    local text = func(periodName, zoneGroupName, remainDateFormat)
    if action == "declared_siege" then
      text = X2Locale:LocalizeUiText(DOMINION, "declared_siege", offenseName, zoneGroupName)
    end
    X2Chat:DispatchChatMessage(CMF_DOMINION_AND_SIEGE_INFO, text)
    local imgEventInfo = MakeImgEventInfo("DOMINION_SIEGE_PERIOD_CHANGED", AddSiegeScheduleMsg, {
      zoneGroupType,
      periodName,
      zoneGroupName,
      defenseName,
      offenseName,
      true,
      isMyInfo,
      action
    })
    AddImgEventQueue(imgEventInfo)
    if periodName == "siege_period_ready_to_siege" then
      F_SOUND.PlayUISound("event_siege_ready_to_siege")
    end
    if periodName == "siege_period_ready_to_siege" or periodName == "siege_period_siege" then
      ShowSiegeAlarm(true, periodName)
    end
  end
  if periodName == "siege_period_peace" then
    ShowSiegeAlarm(false, periodName)
    if action == "unearned_win" then
      X2Chat:DispatchChatMessage(CMF_DOMINION_AND_SIEGE_INFO, X2Locale:LocalizeUiText(DOMINION, action, zoneGroupName))
    elseif action == "change_state" then
      local ownerFaction = X2Dominion:GetOwnerFactionName(zoneGroupType)
      if defenseName == ownerFaction then
        X2Chat:DispatchChatMessage(CMF_DOMINION_AND_SIEGE_INFO, X2Locale:LocalizeUiText(DOMINION, "siege_win_defense", zoneGroupName, defenseName))
      end
    end
    local winner = X2Dominion:IsSiegeWinnerMyFaction(zoneGroupType)
    if winner then
      F_SOUND.PlayUISound("event_siege_victory")
    else
      F_SOUND.PlayUISound("event_siege_defeat")
    end
  end
  if isMyInfo == false then
    return
  end
  UpdateSiegeSchedule(false)
end
