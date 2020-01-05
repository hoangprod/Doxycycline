function ParseCombatMessage(combatEvent, ...)
  local pos = combatEvent:find("_")
  local prefix = combatEvent:sub(1, pos - 1)
  local suffix = combatEvent:sub(pos + 1)
  local result = {}
  local index = 0
  local function GetNextIndex()
    index = index + 1
    return index
  end
  if prefix == "MELEE" then
  elseif prefix == "SPELL" then
    result.spellId = arg[GetNextIndex()]
    result.spellName = arg[GetNextIndex()]
    result.spellSchool = arg[GetNextIndex()]
  elseif prefix == "ENVIRONMENTAL" then
    result.source = arg[GetNextIndex()]
    result.subType = arg[GetNextIndex()]
    if result.subType ~= nil and result.subType ~= -1 then
      result.mySlave = arg[GetNextIndex()]
    end
  end
  if suffix == "DAMAGE" or suffix == "DOT_DAMAGE" then
    result.damage = arg[GetNextIndex()]
    result.powerType = arg[GetNextIndex()]
    result.hitType = arg[GetNextIndex()]
    result.reduced = arg[GetNextIndex()]
    result.weaponUsage = arg[GetNextIndex()]
    result.weaponUsageDamage = arg[GetNextIndex()]
    if result.weaponUsageDamage ~= nil and result.weaponUsageDamage ~= 0 then
      result.damage = result.damage + result.weaponUsageDamage
    end
    result.synergy = arg[GetNextIndex()]
  elseif suffix == "MISSED" then
    result.missType = arg[GetNextIndex()]
    result.damage = arg[GetNextIndex()]
    result.reduced = arg[GetNextIndex()]
    result.weaponUsage = arg[GetNextIndex()]
    result.weaponUsageDamage = arg[GetNextIndex()]
    if result.weaponUsageDamage ~= nil and result.weaponUsageDamage ~= 0 then
      result.damage = result.damage + result.weaponUsageDamage
    end
  elseif suffix == "HEALED" then
    result.heal = arg[GetNextIndex()]
    result.hitType = arg[GetNextIndex()]
  elseif suffix == "ENERGIZE" then
    result.amount = arg[GetNextIndex()]
    result.powerType = arg[GetNextIndex()]
  elseif suffix == "DRAIN" then
    result.amount = arg[GetNextIndex()]
    result.powerType = arg[GetNextIndex()]
  elseif suffix == "LEECH" then
    result.amount = arg[GetNextIndex()]
    result.powerType = arg[GetNextIndex()]
  elseif suffix == "CAST_FAILED" then
    result.failType = arg[GetNextIndex()]
  elseif suffix == "AURA_APPLIED" or suffix == "AURA_REMOVED" then
    result.auraType = arg[GetNextIndex()]
    result.combatText = arg[GetNextIndex()]
  end
  return result
end
function AlertMsgToSecondPasswordUnlockRemainTime()
  local remainDate = X2Security:GetSecondPasswordUnlockRemainTime()
  if remainDate ~= nil then
    local msg = GetRemainDate(remainDate.year, remainDate.month, remainDate.day, remainDate.hour, remainDate.minute, remainDate.second)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "lock_state_played", tostring(msg)))
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "lock_state_played", tostring(msg)))
  end
end
function envSourceToStr(envSource, subType)
  if envSource == "DROWNING" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "drowning")
  elseif envSource == "FALLING" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "falling")
  elseif envSource == "COLLISION" then
    if subType == COLLISION_PART_FRONT then
      return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_front")
    elseif subType == COLLISION_PART_SIDE then
      return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_side")
    elseif subType == COLLISION_PART_REAR then
      return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_rear")
    elseif subType == COLLISION_PART_BOTTOM then
      return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_bottom")
    else
      return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision")
    end
  end
end
