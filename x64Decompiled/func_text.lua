F_TEXT = {}
function F_TEXT.GetCommonText(key, a, b, c)
  if a and b and c then
    return X2Locale:LocalizeUiText(COMMON_TEXT, key, tostring(a), tostring(b), tostring(c))
  end
  if a and b then
    return X2Locale:LocalizeUiText(COMMON_TEXT, key, tostring(a), tostring(b))
  end
  if a then
    return X2Locale:LocalizeUiText(COMMON_TEXT, key, tostring(a))
  end
  return X2Locale:LocalizeUiText(COMMON_TEXT, key)
end
function F_TEXT.HasLocalizeUiText(category, key)
  return X2Locale:HasLocalizeUiText(category, key)
end
function F_TEXT.GetUIText(category, key, ...)
  return X2Locale:LocalizeUiText(category, key, ...)
end
function F_TEXT.SetEnterString(str, addStr, enterCount)
  if enterCount == nil then
    enterCount = 1
  end
  local enterStr = ""
  for i = 1, enterCount do
    enterStr = string.format("%s\n", enterStr)
  end
  if str ~= "" then
    str = string.format("%s%s%s", str, enterStr, addStr)
  else
    str = addStr
  end
  return str
end
function F_TEXT.SetColonFormat(key, value)
  return string.format("%s: %s", key, value)
end
function F_TEXT.ConvertAbbreviatedBindingText(text)
  text = string.upper(text)
  for k, v in pairs(baselibLocale.bindingKeyModifierName) do
    text = string.gsub(text, k, v)
  end
  local offset = 0
  for k, v in pairs(baselibLocale.bindingKeyModifierName) do
    local l, r = string.find(text, v)
    if r ~= nil then
      offset = math.max(offset, r)
    end
  end
  local key = string.sub(text, -(string.len(text) - offset))
  local converted = baselibLocale.bindingKeyName[key]
  if converted ~= nil then
    text = string.gsub(text, key, converted)
  end
  return text
end
function F_TEXT.ApplyEllipsisText(widget, width, attachParam)
  if attachParam == nil then
    attachParam = {
      "RIGHT",
      widget,
      "LEFT",
      0,
      0
    }
  end
  if widget.SetAutoResize then
    widget:SetAutoResize(false)
  end
  widget:SetWidth(width)
  widget.style:SetEllipsis(true)
  local function OnEnter(self)
    if self:GetText() == "" then
      return
    end
    SetTargetAnchorTooltip(self:GetText(), attachParam[1], attachParam[2], attachParam[3], attachParam[4])
  end
  widget:SetHandler("OnEnter", OnEnter)
end
function F_TEXT.GetLimitInfoText(namePolicy)
  local isSameLen = namePolicy.local_min == namePolicy.eng_min and namePolicy.local_max == namePolicy.eng_max
  local strLimitLength
  if isSameLen then
    local strLocalMin = tostring(namePolicy.local_min)
    local strLocalMax = tostring(namePolicy.local_max)
    strLimitLength = locale.changeName.limit_alphabet(strLocalMin, strLocalMax)
  else
    local strLocalLang = locale.changeName.korean
    local strEngLang = locale.changeName.english
    local strLocalMin = tostring(namePolicy.local_min)
    local strLocalMax = tostring(namePolicy.local_max)
    local strEngMin = tostring(namePolicy.eng_min)
    local strEngMax = tostring(namePolicy.eng_max)
    strLimitLength = locale.changeName.limit_multi_lang_alphabet(strLocalLang, strLocalMin, strLocalMax, strEngLang, strEngMin, strEngMax)
  end
  local strAllowOption
  if namePolicy.is_allow_mix_case == true then
    strAllowOption = locale.changeName.allow_mixcase
  end
  if namePolicy.is_allow_space == true then
    if namePolicy.limit_space_cnt == 0 then
      strAllowOption = string.format("%s, %s", strAllowOption, locale.changeName.allow_space)
    else
      strAllowOption = string.format("%s, %s", strAllowOption, locale.changeName.allow_space_limit(tostring(namePolicy.limit_space_cnt)))
    end
  end
  if namePolicy.is_allow_special_letter == true then
    strAllowOption = string.format("%s, %s", strAllowOption, locale.changeName.allow_special_character)
  end
  if strAllowOption ~= nil then
    return string.format("%s (%s)", strLimitLength, strAllowOption)
  else
    return strLimitLength
  end
end
function GetCommonText(key, a, b, c)
  return F_TEXT.GetCommonText(key, a, b, c)
end
function GetUIText(category, key, ...)
  return F_TEXT.GetUIText(category, key, ...)
end
function HasLocalizeUiText(category, key)
  return F_TEXT.HasLocalizeUiText(category, key)
end
