F_UNIT = {}
local IsInvalidAbility = function(ability)
  if ability == nil or ability <= ABILITY_GENERAL or ability >= COMBAT_ABILITY_MAX then
    return true
  end
  return false
end
local GetNewbieJobName = function(ability)
  local abilName = X2Ability:GetAbilityStr(ability)
  local key = string.format("name_%s", abilName)
  return GetUIText(COMBINED_ABILITY_NAME_TEXT, key)
end
function F_UNIT.GetCombinedAbilityName(index1, index2, index3)
  index1 = index1 or COMBAT_ABILITY_MAX
  index2 = index2 or COMBAT_ABILITY_MAX
  index3 = index3 or COMBAT_ABILITY_MAX
  local indices = {
    index1,
    index2,
    index3
  }
  for i = 1, #indices do
    if IsInvalidAbility(indices[i]) then
      return GetNewbieJobName(indices[1])
    end
  end
  table.sort(indices)
  local keyStr = string.format("name_%d_%d_%d", indices[1], indices[2], indices[3])
  local name = GetUIText(COMBINED_ABILITY_NAME_TEXT, keyStr)
  if name == nil then
    name = GetUIText(COMBINED_ABILITY_NAME_TEXT, "name_9_9_9")
  end
  return name
end
function F_UNIT.GetPlayerJobName(abilityType1, abilityType2, abilityType3)
  local abilities = X2Ability:GetActiveAbility()
  local abilityTypes = {}
  local abilityCount = #abilities
  for i = 1, abilityCount do
    abilityTypes[i] = abilities[i].type
  end
  if abilityType1 ~= nil then
    abilityTypes[1] = abilityType1
  end
  if abilityType2 ~= nil and abilityCount >= 1 then
    abilityTypes[2] = abilityType2
  end
  if abilityType3 ~= nil and abilityCount >= 2 then
    abilityTypes[3] = abilityType3
  end
  return F_UNIT.GetCombinedAbilityName(abilityTypes[1], abilityTypes[2], abilityTypes[3])
end
function F_UNIT.GetUnitType(target)
  local unitType, detail = X2Unit:GetUnitTypeString(target)
  return unitType or target, detail or target
end
function F_UNIT.GetPetTargetName(mateType)
  if mateType == MATE_TYPE_NONE then
    return "playerpet"
  end
  return "playerpet" .. tostring(mateType)
end
