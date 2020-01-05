function formatSkillMessage(code, param, skillId)
  if code == "URK_EQUIP_RANGED" then
    if param == "0" then
      return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "skill_urk_equip_ranged")
    elseif param == "1" then
      return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "skill_urk_equip_instrument")
    elseif param == "2" then
      return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "skill_urk_cannot_use_with_non_combat_instument")
    end
  elseif code == "URK_LESS_ACTABILITY_POINT" then
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "skill_" .. string.lower(code), param or "", skillId or "")
  end
  return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "skill_" .. string.lower(code), param or "")
end
function CreateSystemAlertWindow(id, parent)
  local chatWindow = UIParent:CreateWidget("message", id, parent)
  chatWindow.style:SetAlign(ALIGN_CENTER)
  chatWindow.style:SetSnap(true)
  chatWindow.style:SetShadow(true)
  chatWindow.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  chatWindow.style:SetColor(1, 0, 0, 1)
  chatWindow:SetTimeVisible(2)
  chatWindow:SetMaxLines(CENTER_MSG_MAX_LINE.SYS_ALERT)
  return chatWindow
end
systemAlertWindow = CreateSystemAlertWindow("systemAlertWindow", systemLayerParent)
systemAlertWindow:SetExtent(UIParent:GetScreenWidth(), 50)
systemAlertWindow:AddAnchor("TOP", "UIParent", "TOP", 0, 180)
systemAlertWindow.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
ApplyTextColor(systemAlertWindow, FONT_COLOR.RED)
systemAlertWindowBack = systemAlertWindow:CreateColorDrawable(1, 0, 0, 0, "background")
systemAlertWindowBack:AddAnchor("TOPLEFT", systemAlertWindow, 0, 0)
systemAlertWindowBack:AddAnchor("BOTTOMRIGHT", systemAlertWindow, 0, 0)
systemAlertWindow:Show(true)
systemAlertWindow:Clickable(false)
