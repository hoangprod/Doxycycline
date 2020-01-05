function GetSlotText(slotIdx)
  local emptyTip = {
    [ES_HEAD] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_head"),
    [ES_NECK] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_neck"),
    [ES_CHEST] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_chest"),
    [ES_WAIST] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_waist"),
    [ES_LEGS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_legs"),
    [ES_HANDS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_hands"),
    [ES_FEET] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_feet"),
    [ES_ARMS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_arms"),
    [ES_BACK] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_back"),
    [ES_EAR_1] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_ear_1"),
    [ES_EAR_2] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_ear_2"),
    [ES_FINGER_1] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_finger_1"),
    [ES_FINGER_2] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_finger_2"),
    [ES_UNDERSHIRT] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_undershirt"),
    [ES_UNDERPANTS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_underpants"),
    [ES_MAINHAND] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_mainhand"),
    [ES_OFFHAND] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_offhand"),
    [ES_RANGED] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_ranged"),
    [ES_MUSICAL] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_musical"),
    [ES_BACKPACK] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_backpack"),
    [ES_COSPLAY] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_cosplay")
  }
  if emptyTip[slotIdx] ~= nil then
    return emptyTip[slotIdx]
  else
    return "unknown"
  end
end
function GetAttibuteTextColor(attributeType)
  local colors = {
    [ESRA_OFFENCE] = F_COLOR.GetColor("red", false),
    [ESRA_DEFENCE] = F_COLOR.GetColor("bright_blue", false),
    [ESRA_SUPPORT] = F_COLOR.GetColor("original_orange", false)
  }
  if colors[attributeType] ~= nil then
    return colors[attributeType]
  else
    return colors[ESRA_OFFENCE]
  end
end
function GetAttibuteText(attributeType)
  local texts = {
    [ESRA_OFFENCE] = X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_offense"),
    [ESRA_DEFENCE] = X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_defense"),
    [ESRA_SUPPORT] = X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_support")
  }
  if texts[attributeType] ~= nil then
    return texts[attributeType]
  else
    return "unknown"
  end
end
function StartReinforceLevelup(equipSlot)
  X2EquipSlotReinforce:StartReinforceLevelup(equipSlot)
end
function StartReinforceAddExp(equipSlot, materialType)
  X2EquipSlotReinforce:StartReinforceAddExp(equipSlot, materialType)
end
function ChangeLevelEffect(equipSlot, levelEffectIndex)
  X2EquipSlotReinforce:ChangeLevelEffect(equipSlot, levelEffectIndex)
end
function GetReinforceEffectItemLevel(equipSlot, level)
  return X2EquipSlotReinforce:GetReinforceEffectItemLevel(equipSlot, level)
end
function EnableLevelUp(equipSlot)
  return X2EquipSlotReinforce:EnableLevelUp(equipSlot)
end
function HasNextSetEffect(equipSlot)
  return X2EquipSlotReinforce:HasNextSetEffect(equipSlot)
end
function GetReinforceInfo(equipSlot)
  return X2EquipSlotReinforce:GetReinforceInfo(equipSlot)
end
function IsFullExp(equipSlot)
  return X2EquipSlotReinforce:IsFullExp(equipSlot) > 0
end
function GetSetEffects(attributeType)
  return X2EquipSlotReinforce:GetSetEffects(attributeType)
end
function GetTotalReinforceLevel()
  return X2EquipSlotReinforce:GetTotalReinforceLevel()
end
function GetSlotReinforceMaterialInfo(equipSlot, level)
  return X2EquipSlotReinforce:GetMaterialInfo(equipSlot, level)
end
function GetSetEffectTopLevel(attributeType)
  return X2EquipSlotReinforce:GetSetEffectTopLevel(attributeType)
end
function GetAttributeTotalLevel(attributeType)
  return X2EquipSlotReinforce:GetAttributeTotalLevel(attributeType)
end
function GetNextSetApplyLevel(attributeType)
  return X2EquipSlotReinforce:GetNextSetApplyLevel(attributeType)
end
function GetLevelEffectChangeUIInfo(equipSlot)
  return X2EquipSlotReinforce:GetLevelEffectChangeUIInfo(equipSlot)
end
function GetLevelEffectStep(equipSlot)
  return X2EquipSlotReinforce:GetLevelEffectStep(equipSlot)
end
function GetAppliedAllLevelEffect()
  return X2EquipSlotReinforce:GetAppliedAllLevelEffect()
end
function GetAppliedAllSetEffect()
  return X2EquipSlotReinforce:GetAppliedAllSetEffect()
end
function GetLevelEffectInfoByEquipSlot(equipSlot)
  return X2EquipSlotReinforce:GetLevelEffectInfoByEquipSlot(equipSlot)
end
function SuitableLevelForEquipSlotReinforce()
  return X2EquipSlotReinforce:SuitableLevelForEquipSlotReinforce()
end
