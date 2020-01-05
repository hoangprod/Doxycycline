local space_bigFont = 5
local space_normalFont = 8
local space_setItem = 2
local tipText = locale.tooltip
local GetTooltipOffsetX = function(stickTo)
  local textWidth = stickTo.style:GetTextWidth(stickTo:GetText())
  local width = stickTo:GetWidth()
  return textWidth > width and width or textWidth
end
function SetDefaultTooltipAnchor(stickTo, tooltip, useTextLengthOffset)
  local posX, posY = stickTo:GetEffectiveOffset()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local myAnchor = ""
  local targetAnchor = ""
  local offsetX = 0
  local offsetY = 0
  if useTextLengthOffset == nil then
    useTextLengthOffset = false
  end
  local sWidth, _ = stickTo:GetEffectiveExtent()
  local tWidth, tHeight = tooltip:GetEffectiveExtent()
  if screenWidth < posX + sWidth + tWidth then
    if tHeight < screenHeight - posY then
      myAnchor = "TOPRIGHT"
      targetAnchor = "BOTTOMLEFT"
    else
      myAnchor = "BOTTOMRIGHT"
      targetAnchor = "TOPLEFT"
      if posY < tHeight then
        offsetY = tHeight - posY
      end
    end
  elseif tHeight > screenHeight - posY then
    myAnchor = "BOTTOMLEFT"
    targetAnchor = "TOPRIGHT"
    if posY < tHeight then
      offsetY = tHeight - posY
    end
    if useTextLengthOffset then
      targetAnchor = "TOPLEFT"
      offsetX = GetTooltipOffsetX(stickTo)
    end
  else
    myAnchor = "TOPLEFT"
    targetAnchor = "BOTTOMRIGHT"
    if useTextLengthOffset then
      targetAnchor = "BOTTOMLEFT"
      offsetX = GetTooltipOffsetX(stickTo)
    end
  end
  tooltip:RemoveAllAnchors()
  tooltip:AddAnchor(myAnchor, stickTo, targetAnchor, offsetX, offsetY)
end
local SetTooltipDefaultHeight = function(widget)
  widget:SetInset(10, 10, 10, 10)
end
local SetTooltipOffsetScreenLimit = function(tooltipWindow)
  if tooltipWindow:CheckOutOfScreen() then
    local x, y = tooltipWindow:CorrectOffsetByScreen()
    tooltipWindow:RemoveAllAnchors()
    tooltipWindow:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(x), F_LAYOUT.CalcDontApplyUIScale(y))
  end
end
local SetTooltipWindow = function(tooltipWindow, stickTo)
  SetDefaultTooltipAnchor(stickTo, tooltipWindow)
end
function SetTooltip(tooltipText, stickTo, useTextLengthOffset)
  if tooltipText == nil or tooltipText == "" then
    HideTooltip()
    return
  end
  local strWidth = tooltip.window.style:GetTextWidth(tooltipText)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltip.window:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    tooltip.window:SetAutoWordwrap(true)
  else
    tooltip.window:SetAutoWordwrap(false)
  end
  tooltip.window:ClearLines()
  SetTooltipDefaultHeight(tooltip.window)
  tooltip.window:AddLine(tooltipText, "", 0, "left", ALIGN_LEFT, 0)
  SetDefaultTooltipAnchor(stickTo, tooltip.window, useTextLengthOffset)
  tooltip.window:Show(true)
  tooltip.rootWnd:Raise()
  if not stickTo:HasHandler("OnLeave") then
    local OnLeave = function()
      HideTooltip()
    end
    stickTo:SetHandler("OnLeave", OnLeave)
  end
end
function SetTargetAnchorTooltip(tooltipText, myAnchor, target, targetAnchor, offsetX, offsetY, width)
  if tooltipText == nil then
    HideTooltip()
    return
  end
  if offsetX == nil then
    offsetX = 0
  end
  if offsetY == nil then
    offsetY = 0
  end
  if width == nil then
    width = DEFAULT_SIZE.TOOLTIP_MAX_WIDTH
  end
  local strWidth = tooltip.window.style:GetTextWidth(tooltipText)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltip.window:SetWidth(width)
    tooltip.window:SetAutoWordwrap(true)
  else
    tooltip.window:SetAutoWordwrap(false)
  end
  tooltip.window:ClearLines()
  SetTooltipDefaultHeight(tooltip.window)
  tooltip.window:AddLine(tooltipText, "", 0, "left", ALIGN_LEFT, 0)
  tooltip.window:RemoveAllAnchors()
  tooltip.window:AddAnchor(myAnchor, target, targetAnchor, offsetX, offsetY)
  tooltip.window:Show(true)
  if not target:HasHandler("OnLeave") then
    local OnLeave = function()
      HideTooltip()
    end
    target:SetHandler("OnLeave", OnLeave)
  end
end
function SetVerticalTooltip(tooltipText, stickTo)
  local posX, posY = stickTo:GetOffset()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local myAnchor = "BOTTOM"
  local targetAnchor = "TOP"
  local strWidth = tooltip.window.style:GetTextWidth(tooltipText)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltip.window:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    tooltip.window:SetAutoWordwrap(true)
  else
    tooltip.window:SetAutoWordwrap(false)
  end
  tooltip.window:ClearLines()
  SetTooltipDefaultHeight(tooltip.window)
  tooltip.window:AddLine(tooltipText, "", 0, "left", ALIGN_LEFT, 0)
  if posY < tooltip.window:GetHeight() then
    myAnchor = "TOP"
    targetAnchor = "BOTTOM"
  elseif posX < tooltip.window:GetWidth() then
    myAnchor = "BOTTOMLEFT"
    targetAnchor = "TOPRIGHT"
  elseif screenWidth < posX + tooltip.window:GetWidth() then
    myAnchor = "BOTTOMRIGHT"
    targetAnchor = "TOPLEFT"
  end
  tooltip.window:RemoveAllAnchors()
  tooltip.window:AddAnchor(myAnchor, stickTo, targetAnchor, 0, 0)
  tooltip.window:Show(true)
  if not stickTo:HasHandler("OnLeave") then
    local OnLeave = function()
      HideTooltip()
    end
    stickTo:SetHandler("OnLeave", OnLeave)
  end
end
function SetHorizonTooltip(tooltipText, stickTo, offsetX)
  local posX, posY = stickTo:GetOffset()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local strWidth = tooltip.window.style:GetTextWidth(tooltipText)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltip.window:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    tooltip.window:SetAutoWordwrap(true)
  else
    tooltip.window:SetAutoWordwrap(false)
  end
  local myAnchor = ""
  local targetAnchor = ""
  if offsetX == nil then
    offsetX = 0
  end
  tooltip.window:ClearLines()
  SetTooltipDefaultHeight(tooltip.window)
  tooltip.window:AddLine(tooltipText, "", 0, "left", ALIGN_LEFT, 0)
  if screenHeight < posY + tooltip.window:GetHeight() then
    if posX - offsetX < tooltip.window:GetWidth() then
      myAnchor = "BOTTOMLEFT"
      targetAnchor = "TOPRIGHT"
    else
      myAnchor = "BOTTOMRIGHT"
      targetAnchor = "TOPLEFT"
      offsetX = -offsetX
    end
  elseif posX - offsetX < tooltip.window:GetWidth() then
    myAnchor = "LEFT"
    targetAnchor = "RIGHT"
  else
    myAnchor = "RIGHT"
    targetAnchor = "LEFT"
    offsetX = -offsetX
  end
  tooltip.window:RemoveAllAnchors()
  tooltip.window:AddAnchor(myAnchor, stickTo, targetAnchor, offsetX, 0)
  tooltip.window:Show(true)
  if not stickTo:HasHandler("OnLeave") then
    local OnLeave = function()
      HideTooltip()
    end
    stickTo:SetHandler("OnLeave", OnLeave)
  end
end
function SetTooltipOnPos(tooltipText, target, posX, posY)
  if tooltipText == nil then
    HideTooltip()
    return
  end
  local strWidth = tooltip.window.style:GetTextWidth(tooltipText)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltip.window:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    tooltip.window:SetAutoWordwrap(true)
  else
    tooltip.window:SetAutoWordwrap(false)
  end
  tooltip.window:ClearLines()
  SetTooltipDefaultHeight(tooltip.window)
  tooltip.window:AddLine(tooltipText, "", 0, "left", ALIGN_LEFT, 0)
  tooltip.window:RemoveAllAnchors()
  local offsetX, offsetY = target:GetOffset()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local insetY = 0
  if screenHeight < posY + tooltip.window:GetHeight() then
    insetY = tooltip.window:GetHeight()
  end
  if offsetX > screenWidth * 0.7 then
    tooltip.window:AddAnchor("BOTTOMRIGHT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(posX) - target:GetWidth(), F_LAYOUT.CalcDontApplyUIScale(posY) - insetY)
  else
    tooltip.window:AddAnchor("BOTTOMLEFT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(posX), F_LAYOUT.CalcDontApplyUIScale(posY) - -insetY)
  end
  tooltip.window:Raise()
  tooltip.window:Show(true)
end
function SetExpTooltip(tooltipText, stickTo, sideAnchor, width)
  if tooltipText == nil then
    HideTooltip()
    return
  end
  local posX, posY = UIParent:GetCursorPosition()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local myAnchor, targetAnchor
  if not sideAnchor then
    if posY > screenHeight / 2 then
      myAnchor = "BOTTOM"
      targetAnchor = "TOP"
      posY = -1
    else
      myAnchor = "TOP"
      targetAnchor = "BOTTOM"
      posY = 1
    end
    posX = 0
  elseif posX > screenWidth / 2 then
    myAnchor = "TOPRIGHT"
    targetAnchor = "TOPLEFT"
    posX = -20
  else
    myAnchor = "TOPLEFT"
    targetAnchor = "TOPLEFT"
    stickTo = "UIParent"
    posX = 10
  end
  local strWidth = tooltip.window.style:GetTextWidth(tooltipText)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltip.window:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    tooltip.window:SetAutoWordwrap(true)
  else
    tooltip.window:SetAutoWordwrap(false)
  end
  tooltip.window:ClearLines()
  SetTooltipDefaultHeight(tooltip.window)
  tooltip.window:AddLine(tooltipText, "", 0, "left", ALIGN_LEFT, 0)
  tooltip.window:RemoveAllAnchors()
  tooltip.window:AddAnchor(myAnchor, stickTo, targetAnchor, posX, posY)
  tooltip.window:Show(true)
  SetTooltipOffsetScreenLimit(tooltip.window)
end
function tooltip.window:OnUpdate()
  self:Raise()
end
tooltip.window:SetHandler("OnUpdate", tooltip.window.OnUpdate)
function HideTextTooltip()
  if textTooltip == nil then
    return
  end
  textTooltip:Show(false)
  textTooltip.titleLine:SetVisible(false)
  textTooltip:SetAutoWordwrap(false)
end
function HideTooltip()
  local groups = {
    tooltipGroups[TOOLTIP_KIND.ITEM],
    tooltipGroups[TOOLTIP_KIND.SKILL],
    tooltipGroups[TOOLTIP_KIND.BUFF]
  }
  for i = 1, #groups do
    for j = 1, #groups[i] do
      if tooltip.tooltipWindows[groups[i][j]] ~= nil then
        tooltip.tooltipWindows[groups[i][j]]:ShowTooltip(false)
      end
    end
  end
  tooltip.window:Show(false)
  tooltip.window:SetAutoWordwrap(false)
  if tooltip.window.moneyWnd ~= nil then
    tooltip.window.moneyWnd:Show(false)
  end
  if premiumServiceToolTip ~= nil then
    premiumServiceToolTip:Show(false)
  end
  HideTextTooltip()
end
local FormatMsec = function(msec, processPoint)
  local r = math.floor(msec / 100 + 0.5)
  if processPoint == false or r % 10 == 0 then
    return string.format("%d", r / 10)
  end
  return string.format("%.1f", r / 10)
end
function FormatTime(timeValue, processPoint, timeUnit)
  if processPoint == nil then
    processPoint = true
  end
  if timeUnit == nil then
    timeUnit = "msec"
  end
  totalSec = 0
  if timeUnit == "msec" then
    totalSec = timeValue / 1000
    if totalSec < 60 then
      return string.format("%s%s", FormatMsec(timeValue, processPoint), tipText.second)
    end
  elseif timeUnit == "sec" then
    totalSec = timeValue
  end
  sec = math.floor(totalSec % 60)
  totalMinute = math.floor(totalSec / 60)
  if 60 > totalMinute then
    if sec == 0 then
      return string.format("%d%s", totalMinute, tipText.minute)
    end
    return string.format("%d%s %d%s", totalMinute, tipText.minute, sec, tipText.second)
  end
  minute = totalMinute % 60
  totalHour = math.floor(totalMinute / 60)
  if totalHour < 24 then
    if minute == 0 then
      return string.format("%d%s", totalHour, tipText.hour)
    end
    return string.format("%d%s %d%s", totalHour, tipText.hour, minute, tipText.minute)
  end
  hour = totalHour % 24
  day = math.floor(totalHour / 24)
  if hour == 0 then
    return string.format("%d%s", day, tipText.day)
  end
  return string.format("%d%s %d%s", day, tipText.day, hour, tipText.hour)
end
local function FormatCastingTime(casting, channeling)
  if casting > 0 then
    return tipText.GetCastTime(FormatMsec(casting))
  end
  if channeling > 0 then
    return GetUIText(TOOLTIP_TEXT, "channeling")
  end
  return tipText.now
end
local function FormatCooldownTime(msec)
  if msec == 0 then
    return ""
  end
  return tipText.GetCooldown(FormatTime(msec))
end
function FormatDurationTimeInDesc(description)
  description = string.gsub(description, "#$hour", locale.tooltip.hour)
  description = string.gsub(description, "#$minute", locale.tooltip.minute)
  description = string.gsub(description, "#$second", locale.tooltip.second)
  return description
end
local SetItemName = function(name, grade, gradeColor)
  local resultText = ""
  if grade == nil then
    resultText = name
  else
    resultText = "|c" .. gradeColor .. name
  end
  return resultText
end
local IsScalable = function(tipInfo)
  if not tipInfo.scalable then
    return false
  end
  return true
end
local GetSoulBindText = function(tipInfo)
  if tipInfo.soul_bound == 1 then
    return locale.tooltip.soul_bound
  end
  local soul_bind = tipInfo.soul_bind
  if soul_bind == "soulbound_pickup" or soul_bind == "soulbound_pickup_pack" then
    return locale.tooltip.soulbound_pickup
  end
  if soul_bind == "soulbound_equip" then
    return locale.tooltip.soulbound_equip
  end
  if soul_bind == "soulbound_unpack" then
    return locale.tooltip.soulbound_unpack
  end
  if soul_bind == "soulbound_pickup_auction_win" then
    return GetUIText(TOOLTIP_TEXT, "soulbound_auction_win")
  end
  return
end
local GetCannotEquipText = function(tipInfo)
  if tipInfo.item_flag_cannot_equip == true then
    return locale.tooltip.item_flag_cannot_equip
  end
end
local GetGenderText = function(tipInfo)
  if tipInfo.gender == nil then
    return
  end
  if tipInfo.gender == "none" then
    return
  end
  local gender = X2Unit:UnitGender("player")
  if gender == nil then
    return
  end
  local color
  if tipInfo.gender == gender then
    color = FONT_COLOR_HEX.SOFT_BROWN
  else
    color = FONT_COLOR_HEX.RED
  end
  local genderStr = ""
  if tipInfo.gender == "male" then
    genderStr = GetUIText(GENDER_TEXT, "only_male")
  else
    genderStr = GetUIText(GENDER_TEXT, "only_female")
  end
  return string.format("%s%s", color, genderStr)
end
local GetDurabilityColor = function(durability, maxDurability)
  if durability == 0 then
    return FONT_COLOR_HEX.RED
  end
  if durability / maxDurability <= 0.25 then
    return FONT_COLOR_HEX.RED
  end
  return FONT_COLOR_HEX.SOFT_BROWN
end
local GetDamageStrength = function(value)
  if value >= 80 then
    return locale.tooltip.attackStrength[1]
  end
  if value >= 20 then
    return locale.tooltip.attackStrength[2]
  end
  if value > 0 then
    return locale.tooltip.attackStrength[3]
  end
end
local function GetExtraDamageTooltipText(tipInfo)
  local extra1 = tipInfo.extraDamage1
  local extra2 = tipInfo.extraDamage2
  local extra3 = tipInfo.extraDamage3
  if extra1 == nil then
    return
  end
  local gotValue = false
  local space = ""
  local lineText = ""
  local strength = GetDamageStrength(extra1)
  if strength ~= nil then
    local extraText = FONT_COLOR_HEX.GRAY .. tipText.attack[1] .. " " .. FONT_COLOR_HEX.SOFT_BROWN .. strength
    gotValue = true
    lineText = extraText
  end
  local strength = GetDamageStrength(extra2)
  if strength ~= nil then
    local extraText = FONT_COLOR_HEX.GRAY .. tipText.attack[2] .. " " .. FONT_COLOR_HEX.SOFT_BROWN .. strength
    gotValue = true
    if gotValue then
      space = "    "
    else
      space = ""
    end
    lineText = lineText .. space .. extraText
  end
  local strength = GetDamageStrength(extra3)
  if strength ~= nil then
    local extraText = FONT_COLOR_HEX.GRAY .. tipText.attack[3] .. " " .. FONT_COLOR_HEX.SOFT_BROWN .. strength
    gotValue = true
    if gotValue then
      space = "    "
    else
      space = ""
    end
    lineText = lineText .. space .. extraText
  end
  if gotValue then
    return lineText
  end
end
local GetDyeingTooltipText = function(tipInfo)
  if tipInfo.dyeingColor == nil then
    return
  end
  local colorTable = tipInfo.dyeingColor
  return GetUIText(TOOLTIP_TEXT, "dyed", tostring(colorTable.r), tostring(colorTable.g), tostring(colorTable.b))
end
local IsStat = function(attrName)
  if attrName == "str" or attrName == "dex" or attrName == "sta" or attrName == "int" or attrName == "spi" then
    return true
  end
  return false
end
local ExistItemDiffInfo = function(tipInfo, keyName)
  if tipInfo == nil or tipInfo.diffInfo == nil or tipInfo.diffInfo[keyName] == nil or tipInfo.diffInfo[keyName] == 0 then
    return false
  end
  return true
end
local GetItemDiffValue = function(tipInfo, keyName)
  if tipInfo == nil or tipInfo.diffInfo == nil then
    return nil
  end
  return tipInfo.diffInfo[keyName]
end
local MakeItemDiffText = function(value, toStringFormat)
  local tooltipUpperMark = "\226\150\178"
  local tooltipLowerMark = "\226\150\188"
  if toStringFormat == nil or toStringFormat == "" then
    toStringFormat = "%d"
  end
  local finalText = ""
  if value > 0 then
    finalText = FONT_COLOR_HEX.DETAIL_DEMAGE .. tooltipUpperMark .. string.format(toStringFormat, value)
  elseif value < 0 then
    finalText = FONT_COLOR_HEX.RED .. tooltipLowerMark .. string.format(toStringFormat, value * -1)
  end
  return finalText
end
local CalcDiffValue = function(sourceValue, targetValue, toStringFormat)
  if sourceValue == nil and targetValue == nil then
    return 0
  end
  if toStringFormat == nil or toStringFormat == "" then
    toStringFormat = "%d"
  end
  local realSourceValue = sourceValue and tonumber(string.format(toStringFormat, sourceValue)) or 0
  local realTargetValue = targetValue and tonumber(string.format(toStringFormat, targetValue)) or 0
  return realSourceValue - realTargetValue
end
local function MakeItemDiffInfo(sourceTip, targetTip)
  sourceDiffTipInfo = {}
  targetDiffTipInfo = {}
  local compareDPS = false
  local compareDefence = false
  local compareGearScore = false
  local sourceArmor = sourceTip.armor or 0
  local targetArmor = targetTip.armor or 0
  local implWeapon = sourceTip.item_impl == "weapon" and targetTip.item_impl == "weapon"
  local implArmor = (sourceTip.item_impl == "armor" or sourceTip.item_impl == "mate_armor") and (targetTip.item_impl == "armor" or targetTip.item_impl == "mate_armor")
  local implAccessory = sourceTip.item_impl == "accessory" and targetTip.item_impl == "accessory"
  if implWeapon and sourceArmor == 0 and targetArmor == 0 then
    compareDPS = true
  end
  if implArmor then
    compareDefence = true
  elseif implAccessory == true then
    compareDefence = true
  elseif sourceArmor ~= 0 and targetArmor ~= 0 then
    compareDefence = true
  end
  if sourceTip.gearScore ~= nil and sourceTip.gearScore.total ~= nil and sourceTip.gearScore.total ~= 0 and targetTip.gearScore ~= nil and targetTip.gearScore.total ~= nil and targetTip.gearScore.total ~= 0 then
    compareGearScore = true
  end
  if compareDPS == true then
    sourceDiffTipInfo.DPS = CalcDiffValue(sourceTip.DPS, targetTip.DPS, "%0.1f")
    targetDiffTipInfo.DPS = sourceDiffTipInfo.DPS * -1
  end
  if compareDefence == true then
    sourceDiffTipInfo.armor = CalcDiffValue(sourceTip.armor, targetTip.armor)
    targetDiffTipInfo.armor = sourceDiffTipInfo.armor * -1
  end
  if implWeapon == true then
    sourceDiffTipInfo.magicDps = CalcDiffValue(sourceTip.magicDps, targetTip.magicDps)
    sourceDiffTipInfo.healDps = CalcDiffValue(sourceTip.healDps, targetTip.healDps)
    sourceDiffTipInfo.extraDPS = CalcDiffValue(sourceTip.extraDPS, targetTip.extraDPS)
    sourceDiffTipInfo.attackDelay = CalcDiffValue(sourceTip.attackDelay, targetTip.attackDelay)
    sourceDiffTipInfo.magicResistance = CalcDiffValue(sourceTip.magicResistance, targetTip.magicResistance)
    if sourceDiffTipInfo.magicDps ~= nil then
      targetDiffTipInfo.magicDps = sourceDiffTipInfo.magicDps * -1
    end
    if sourceDiffTipInfo.healDps ~= nil then
      targetDiffTipInfo.healDps = sourceDiffTipInfo.healDps * -1
    end
    if sourceDiffTipInfo.extraDPS ~= nil then
      targetDiffTipInfo.extraDPS = sourceDiffTipInfo.extraDPS * -1
    end
    if sourceDiffTipInfo.attackDelay ~= nil then
      targetDiffTipInfo.attackDelay = sourceDiffTipInfo.attackDelay * -1
    end
    if sourceDiffTipInfo.magicResistance ~= nil then
      targetDiffTipInfo.magicResistance = sourceDiffTipInfo.magicResistance * -1
    end
  elseif implArmor == true or impeAccessory == true then
    sourceDiffTipInfo.magicResistance = CalcDiffValue(sourceTip.magicResistance, targetTip.magicResistance)
    sourceDiffTipInfo.extraArmor = CalcDiffValue(sourceTip.extraArmor, targetTip.extraArmor, "0.1f")
    if sourceDiffTipInfo.magicResistance ~= nil then
      targetDiffTipInfo.magicResistance = sourceDiffTipInfo.magicResistance * -1
    end
    if sourceDiffTipInfo.extraArmor ~= nil then
      targetDiffTipInfo.extraArmor = sourceDiffTipInfo.extraArmor * -1
    end
  end
  local modifierMap = {}
  local mapCount = 0
  if sourceTip.modifier ~= nil then
    mapCount = #sourceTip.modifier
    for i = 1, #sourceTip.modifier do
      local attrName = sourceTip.modifier[i].name
      if IsStat(attrName) then
        modifierMap[attrName] = {}
        modifierMap[attrName][1] = i
      end
    end
  end
  if targetTip.modifier ~= nil then
    for i = 1, #targetTip.modifier do
      local attrName = targetTip.modifier[i].name
      if IsStat(attrName) then
        if modifierMap[attrName] == nil then
          modifierMap[attrName] = {}
          mapCount = mapCount + 1
        end
        modifierMap[attrName][2] = i
      end
    end
  end
  if mapCount > 0 then
    sourceDiffTipInfo.modifier = {}
    targetDiffTipInfo.modifier = {}
    for attrName, data in pairs(modifierMap) do
      local sourceModifierIdx = data[1] or 0
      local targetModifierIdx = data[2] or 0
      local sourceModifierValue = 0
      if sourceModifierIdx ~= 0 then
        sourceModifierValue = sourceTip.modifier[sourceModifierIdx].value
      end
      local targetModifierValue = 0
      if targetModifierIdx ~= 0 then
        targetModifierValue = targetTip.modifier[targetModifierIdx].value
      end
      local diffValue = CalcDiffValue(sourceModifierValue, targetModifierValue)
      if sourceModifierIdx ~= 0 then
        sourceDiffTipInfo.modifier[sourceModifierIdx] = diffValue
      end
      if targetModifierIdx ~= 0 then
        targetDiffTipInfo.modifier[targetModifierIdx] = diffValue * -1
      end
    end
  end
  if compareGearScore then
    sourceDiffTipInfo.gearScore = {}
    targetDiffTipInfo.gearScore = {}
    sourceDiffTipInfo.gearScore = CalcDiffValue(sourceTip.gearScore.total, targetTip.gearScore.total)
    if sourceDiffTipInfo.gearScore ~= nil then
      targetDiffTipInfo.gearScore = sourceDiffTipInfo.gearScore * -1
    end
  end
  sourceTip.diffInfo = sourceDiffTipInfo
  targetTip.diffInfo = targetDiffTipInfo
end
local modifierValueConvertFuncMap = {
  persistent_health_regen = function(value)
    return value / 5
  end,
  persistent_mana_regen = function(value)
    return value / 5
  end
}
local function GetModifierText(tip, modifier, diffValue, bPostString)
  if modifier == nil then
    return
  end
  diffValue = diffValue or 0
  local valueType
  local preString = "+"
  local postString = ""
  if modifier.type == 1 then
    valueType = "%"
  else
    valueType = ""
  end
  if bPostString == true then
    if 0 > modifier.value then
      preString = FONT_COLOR_HEX.RED
      postString = tipText.dec
    else
      preString = FONT_COLOR_HEX.SOFT_BROWN
      postString = tipText.inc
    end
  else
    if 0 > modifier.value then
      preString = FONT_COLOR_HEX.RED .. "-"
    else
      preString = FONT_COLOR_HEX.SOFT_BROWN
    end
    postString = ""
  end
  local modifierName = locale.attribute(modifier.name)
  if modifierName == nil then
    modifierName = modifier.name
  end
  local modifierValue = modifier.value
  local diffValueStr = MakeItemDiffText(diffValue)
  return FONT_COLOR_HEX.GRAY .. modifierName .. "  " .. preString .. modifierValue .. valueType .. " " .. postString .. diffValueStr
end
function IsAttackSpeedAttributes(attribute)
  if attribute == "melee_speed_mul" or attribute == "ranged_speed_mul" or attribute == "global_cooldown_mul" or attribute == "attack_anim_speed_mul" or attribute == "attack_speed_mul" then
    return true
  end
  return false
end
function GetAddModifierText(modifier, textColor)
  if modifier == nil then
    return
  end
  if modifier.type == 0 then
    local name = modifier.name
    if IsAttackSpeedAttributes(name) then
      name = "attack_anim_speed_mul"
    end
    local value = GetModifierCalcValue(name, modifier.value)
    local status = GetModiferStatusStr(name, modifier.value)
    if textColor == nil then
      textColor = GetModifierColor(name, modifier.value)
    end
    if status == "" then
      return string.format("%s%s %s", textColor, locale.attribute(name), value)
    end
    return string.format("%s%s", textColor, X2Locale:LocalizeUiText(ATTRIBUTE_VARIATION_TEXT, string.format("%s_%s", status, name), value))
  end
end
local TEXT_MAGIC_ATTR = 1
local TEXT_EXTRA_ATTR = 2
local TEXT_MODIFIER_ATTR = 3
local TEXT_GEM_MODIFIER_ATTR = 4
local TEXT_HEAL_ATTR = 5
local function GetFullModifierText(tipInfo, kind)
  local attrStrings = {}
  if kind == TEXT_MODIFIER_ATTR then
    if tipInfo.item_impl == "enchanting_gem" or tipInfo.item_impl == "socket" then
      if tipInfo.modifier ~= nil then
        for j = 1, #tipInfo.modifier do
          local str = GetAddModifierText(tipInfo.modifier[j])
          table.insert(attrStrings, str)
        end
      end
      local skill_modifier_tooltip = tipInfo.skill_modifier_tooltip
      if skill_modifier_tooltip ~= nil and skill_modifier_tooltip ~= "" then
        local str = string.format("%s%s", FONT_COLOR_HEX.GREEN, skill_modifier_tooltip)
        table.insert(attrStrings, str)
      end
      local buff_modifier_tooltip = tipInfo.buff_modifier_tooltip
      if buff_modifier_tooltip ~= nil and buff_modifier_tooltip ~= "" then
        local str = string.format("%s%s", FONT_COLOR_HEX.GREEN, buff_modifier_tooltip)
        table.insert(attrStrings, str)
      end
    elseif tipInfo.modifier ~= nil then
      for j = 1, #tipInfo.modifier do
        if tipInfo.modifier[j].value ~= 0 then
          local attrName = tipInfo.modifier[j].name
          local diffValue = 0
          if ExistItemDiffInfo(tipInfo, "modifier") == true then
            diffValue = GetItemDiffValue(tipInfo, "modifier")[j]
          end
          if IsStat(attrName) then
            local str = GetModifierText(nil, tipInfo.modifier[j], diffValue, false)
            table.insert(attrStrings, str)
          end
        end
      end
    end
  elseif kind == TEXT_GEM_MODIFIER_ATTR then
    if tipInfo.gemModifireTable ~= nil then
      for j = 1, #tipInfo.gemModifireTable do
        local gemString = GetAddModifierText(tipInfo.gemModifireTable[j])
        table.insert(attrStrings, gemString)
      end
    end
    if tipInfo.gemInfo ~= nil then
      local gemItem = tipInfo.gemInfo or 0
      if gemItem ~= 0 then
        local gemItemInfo = X2Item:GetItemInfoByType(gemItem, 0, IIK_SOCKET_MODIFIER)
        if gemItemInfo.skill_modifier_tooltip ~= nil and gemItemInfo.skill_modifier_tooltip ~= "" then
          local gemString = string.format("%s%s", FONT_COLOR_HEX.GREEN, gemItemInfo.skill_modifier_tooltip)
          table.insert(attrStrings, gemString)
        end
        if gemItemInfo.buff_modifier_tooltip ~= nil and gemItemInfo.buff_modifier_tooltip ~= "" then
          local gemString = string.format("%s%s", FONT_COLOR_HEX.GREEN, gemItemInfo.buff_modifier_tooltip)
          table.insert(attrStrings, gemString)
        end
      end
    end
  end
  local fullModifierText = ""
  local first = true
  for i = 1, #attrStrings do
    local str = attrStrings[i]
    if first then
      fullModifierText = fullModifierText .. str
      first = false
    else
      fullModifierText = fullModifierText .. "\n" .. str
    end
  end
  return fullModifierText
end
local Round = function(value)
  return math.floor(value + 0.5)
end
local function GetMainAttrText(tipInfo)
  local armor = tipInfo.armor or 0
  local str = ""
  if tipInfo.item_impl == "weapon" and armor == 0 then
    local dps = tipInfo.DPS or 0
    local minDmg = Round(tipInfo.minDamage or 0)
    local maxDmg = Round(tipInfo.maxDamage or 0)
    if ExistItemDiffInfo(tipInfo, "DPS") == true then
      local diffText = MakeItemDiffText(GetItemDiffValue(tipInfo, "DPS"), "%0.1f")
      str = string.format("%s%s %s%s(%s) %s", FONT_COLOR_HEX.GRAY, tipText.attackPower, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("DPS", dps), locale.common.from_to(minDmg, maxDmg), diffText)
    elseif dps ~= 0 then
      str = string.format("%s%s %s%s (%s)", FONT_COLOR_HEX.GRAY, tipText.attackPower, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("DPS", dps), locale.common.from_to(minDmg, maxDmg))
    end
  elseif tipInfo.item_impl == "armor" or tipInfo.item_impl == "mate_armor" or tipInfo.item_impl == "accessory" or armor ~= 0 then
    if ExistItemDiffInfo(tipInfo, "armor") == true then
      local diffText = MakeItemDiffText(GetItemDiffValue(tipInfo, "armor"))
      str = string.format("%s%s %s%s %s", FONT_COLOR_HEX.GRAY, tipText.defencePower, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("armor", armor), diffText)
    elseif armor ~= 0 then
      str = string.format("%s%s %s%s", FONT_COLOR_HEX.GRAY, tipText.defencePower, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("armor", armor))
    end
  end
  return str
end
local function GetBottomAttrText(tipInfo, kind)
  local str = ""
  if kind == TEXT_MAGIC_ATTR then
    if tipInfo.item_impl == "weapon" then
      local value = tipInfo.magicDps or 0
      local resistValue = tipInfo.magicResistance or 0
      if value ~= 0 then
        str = string.format("%s%s %s+%s", FONT_COLOR_HEX.GRAY, tipText.magicAttackPower, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("magicDps", value))
        if ExistItemDiffInfo(tipInfo, "magicDps") == true then
          str = str .. " " .. MakeItemDiffText(GetItemDiffValue(tipInfo, "magicDps"))
        end
      elseif resistValue ~= 0 then
        str = string.format("%s%s %s%s", FONT_COLOR_HEX.GRAY, tipText.magicResistance, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("magicResistance", resistValue))
        if ExistItemDiffInfo(tipInfo, "magicResistance") == true then
          str = str .. " " .. MakeItemDiffText(GetItemDiffValue(tipInfo, "magicResistance"))
        end
      end
    elseif tipInfo.item_impl == "armor" or tipInfo.item_impl == "mate_armor" or tipInfo.item_impl == "accessory" then
      local value = tipInfo.magicResistance or 0
      if value ~= 0 then
        str = string.format("%s%s %s%s", FONT_COLOR_HEX.GRAY, tipText.magicResistance, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("magicResistance", value))
        if ExistItemDiffInfo(tipInfo, "magicResistance") == true then
          str = str .. " " .. MakeItemDiffText(GetItemDiffValue(tipInfo, "magicResistance"))
        end
      end
    end
    return str
  end
  if kind == TEXT_HEAL_ATTR then
    if tipInfo.item_impl == "weapon" then
      local value = tipInfo.healDps or 0
      if value ~= 0 then
        str = string.format("%s%s %s+%s", FONT_COLOR_HEX.GRAY, tipText.healPower, FONT_COLOR_HEX.SOFT_BROWN, GetModifierCalcValue("healDps", value))
        if ExistItemDiffInfo(tipInfo, "healDps") == true then
          str = str .. " " .. MakeItemDiffText(GetItemDiffValue(tipInfo, "healDps"))
        end
      end
    end
    return str
  end
  if kind == TEXT_EXTRA_ATTR then
    if tipInfo.item_impl == "weapon" then
      local value = tipInfo.extraDPS or 0
      local speed = tipInfo.attackDelay or 0
      if speed * value ~= 0 then
        str = string.format("%s%s +%0.1f", FONT_COLOR_HEX.SKYBLUE, tipText.attackPower, speed * value)
        local diffExtraDPS = GetItemDiffValue(tipInfo, "extraDPS") or 0
        local diffExtraDelay = GetItemDiffValue(tipInfo, "attackDelay") or 0
        if diffExtraDPS * diffExtraDelay ~= 0 then
          str = str .. " " .. MakeItemDiffText(diffExtraDPS * diffExtraDelay, "%0.1f")
        end
      end
    elseif tipInfo.item_impl == "armor" or tipInfo.item_impl == "mate_armor" or tipInfo.item_impl == "accessory" then
      local value = tipInfo.extraArmor or 0
      if value ~= 0 then
        str = string.format("%s%s +%0.1f", FONT_COLOR_HEX.SKYBLUE, tipText.defencePower, value)
        if ExistItemDiffInfo(tipInfo, "extraArmor") == true then
          str = str .. " " .. MakeItemDiffText(GetItemDiffValue(tipInfo, "extraArmor"), "%0.1f")
        end
      end
    end
    return str
  end
  if kind == TEXT_MODIFIER_ATTR or kind == TEXT_GEM_MODIFIER_ATTR then
    return GetFullModifierText(tipInfo, kind)
  end
end
local CanUpgradeSkillByTipInfo = function(tipInfo)
  local lenLevel = tipInfo.nextLearnLevel or tipInfo.firstLearnLevel or tipInfo.passive_buff_learn_level
  local lenCost = tipInfo.upgrade_cost
  local abilityLevel = X2Ability:GetAbilityLevel(tipInfo.ability)
  local myMoney = tonumber(X2Util:GetMyMoneyString())
  local levelReq = false
  if lenLevel ~= nil and lenLevel <= abilityLevel then
    levelReq = true
  end
  local moneyReq = false
  if lenCost ~= nil and lenCost <= myMoney then
    moneyReq = true
  end
  local total, use = X2Ability:GetSkillPoint()
  local pointReq = false
  if total ~= use then
    pointReq = true
  end
  local enoughAbilityReqPoints = false
  local abilityIdx = X2Ability:FindAbilityIndexForStr(tipInfo.ability)
  local abilityTotalPoints, abilityReqPoints = X2Ability:GetAbilitySkillReqPoint(abilityIdx)
  if tipInfo.reqPoints ~= nil and abilityReqPoints >= tipInfo.reqPoints then
    enoughAbilityReqPoints = true
  end
  return levelReq, moneyReq, pointReq, enoughAbilityReqPoints
end
local GetSkillLevelColor = function(levelReq)
  if levelReq then
    return FONT_COLOR_HEX.SOFT_BROWN
  else
    return FONT_COLOR_HEX.RED
  end
end
local GetSkillPointColor = function(pointReq)
  if pointReq then
    return FONT_COLOR_HEX.SOFT_BROWN
  else
    return FONT_COLOR_HEX.RED
  end
end
local GetSkillReqPointColor = function(pointReq)
  if pointReq then
    return FONT_COLOR_HEX.SOFT_BROWN
  else
    return FONT_COLOR_HEX.RED
  end
end
local GetSkillMoneyColor = function(moneyReq)
  if moneyReq then
    return FONT_COLOR_HEX.SOFT_BROWN
  else
    return FONT_COLOR_HEX.RED
  end
end
local MakeUnsatisfiedSetEffectText = function(numPieces, effect, wear)
  if wear == false then
    return F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "amount", tostring(numPieces)), effect)
  end
  return string.format("(%d%s) %s", numPieces, locale.tooltip.set, effect)
end
local GetItemLevelRestrictionColor = function(isPet, levelLimit, levelRequirement)
  local level
  if isPet then
    level = X2Unit:UnitLevel("playerpet")
  else
    level = X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player")
  end
  if level == nil then
    return FONT_COLOR_HEX.RED
  end
  if levelLimit ~= nil and levelRequirement ~= nil and levelLimit ~= 0 and levelRequirement ~= 0 then
    if levelRequirement <= level and levelLimit >= level then
      return FONT_COLOR_HEX.SOFT_BROWN
    end
    return FONT_COLOR_HEX.RED
  elseif levelLimit ~= nil and levelLimit ~= 0 then
    if levelLimit >= level then
      return FONT_COLOR_HEX.SOFT_BROWN
    end
    return FONT_COLOR_HEX.RED
  elseif levelRequirement ~= nil and levelRequirement ~= 0 then
    if levelRequirement <= level then
      return FONT_COLOR_HEX.SOFT_BROWN
    end
    return FONT_COLOR_HEX.RED
  else
    return FONT_COLOR_HEX.SOFT_BROWN
  end
end
local GetLimitLevel = function(isPet)
  local featureSet = X2Player:GetFeatureSet()
  if isPet then
    return featureSet.mateLevelLimit
  else
    return X2Unit:HeirLimitLevelByCharLevel()
  end
end
local IsCombatAbility = function(tipInfo)
  if tipInfo.ability == "general" or tipInfo.ability == "predator" or tipInfo.ability == "trooper" then
    return false
  end
  return true
end
for tipNum = 1, tooltip.num do
  do
    local tipItemTitle = tooltip.itemTitles[tipNum]
    local tipSecurityState = tooltip.securityState[tipNum]
    local tipUserMusicInfos = tooltip.userMusicInfos[tipNum]
    local tipTreasureInfos = tooltip.treasureInfos[tipNum]
    local tipLocationInfos = tooltip.locationInfos[tipNum]
    local tipItemLookState = tooltip.itemLookState[tipNum]
    local tipItemTimeInfos = tooltip.itemTimeInfos[tipNum]
    local tipEvolvingExpInfos = tooltip.itemEvolvingExpInfos[tipNum]
    local tipItemInfoEx = tooltip.itemInfosEx[tipNum]
    local tipItemInfo = tooltip.itemInfos[tipNum]
    local tipSpecialty = tooltip.specialty[tipNum]
    local tipItemSocketInfos = tooltip.itemSocketInfos[tipNum]
    local tipItemGearScore = tooltip.gearScore[tipNum]
    local tipDescription = tooltip.descriptions[tipNum]
    local tipEffectDescription = tooltip.effectDescriptions[tipNum]
    local tipSetItemsInfo = tooltip.setItemsInfo[tipNum]
    local tipEtcItemsInfo = tooltip.etcItemsInfo[tipNum]
    local tipCrafterInfo = tooltip.crafterInfo[tipNum]
    local tipSellable = tooltip.sellables[tipNum]
    local tipAttrInfo = tooltip.attrInfos[tipNum]
    local tipOption = tooltip.options[tipNum]
    local tipSkillTitle = tooltip.skillTitles[tipNum]
    local tipSkillSimpleInfo = tooltip.skillSimpleInfo[tipNum]
    local tipSkillTimeInfo = tooltip.skillTimeInfo[tipNum]
    local tipSkillEffectInfo = tooltip.skillEffectInfo[tipNum]
    local tipSkillDesc = tooltip.skillDescs[tipNum]
    local tipSkillSynergyInfos = tooltip.skillSynergyInfos[tipNum]
    local tipSkillBody = tooltip.skillBodys[tipNum]
    local tipBuffInfo = tooltip.buffInfos[tipNum]
    local tipPortalInfo = tooltip.portalInfos[tipNum]
    local tipCrimeInfo = tooltip.crimeInfo[tipNum]
    local tipMountInfo = tooltip.mountInfo[tipNum]
    local tipQuestInfo = tooltip.questBody[tipNum]
    local tipCraftOrderInfo = tooltip.craftOrderInfo[tipNum]
    local tipUccViewer = tooltip.uccViewer[tipNum]
    if tipQuestInfo ~= nil then
      function tipQuestInfo:SetInfo(tooltipItemAndSkill, questType)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local questTooltip = tooltipItemAndSkill
        local lastIndex = 0
        local color = FONT_COLOR_HEX.DEFAULT
        local title = X2Quest:GetQuestContextMainTitle(questType)
        if title ~= nil then
          color = FONT_COLOR_HEX.SOFT_BROWN
          lastIndex = questTooltip:AddLine(title, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0, 0.85)
        end
        if X2Quest:IsProgressQuestInJournal(questType) or X2Quest:IsReadyQuestInJournal(questType) then
          color = FONT_COLOR_HEX.SKYBLUE
          questTooltip:AddAnotherSideLine(lastIndex, string.format("%s%s", color, locale.questContext.doing), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
        end
        questTooltip:AttachLowerSpaceLine(lastIndex, space_bigFont * 2)
        local summary = X2Quest:GetLinkedQuestSummary(questType)
        if summary ~= nil then
          lastIndex = questTooltip:AddLine(summary, "", 0, "left", ALIGN_LEFT, 0)
          questTooltip:AttachLowerSpaceLine(lastIndex, space_bigFont * 2)
        end
        color = FONT_COLOR_HEX.SINERGY
        if X2Quest:IsSelectiveQuest(questType) then
          local str = locale.questContext.selectiveObj
          lastIndex = questTooltip:AddLine(string.format("%s - %s", color, str), "", 0, "left", ALIGN_LEFT, 0)
        end
        local isScore = X2Quest:IsScoreQuest(questType)
        if isScore then
          local str = X2Quest:GetScoreQuestObjective(questType)
          lastIndex = questTooltip:AddLine(string.format("%s - %s", color, str), "", 0, "left", ALIGN_LEFT, 0)
        end
        local isGroupQuest = X2Quest:IsGroupQuest(questType)
        if isGroupQuest then
          lastIndex = questTooltip:AddLine(string.format("%s - %s", color, locale.questContext.groupObj), "", 0, "left", ALIGN_LEFT, 0)
        end
        local isAggroQuest = X2Quest:NowIsAggroComponent(questType)
        if isAggroQuest then
          lastIndex = questTooltip:AddLine(string.format("%s - %s", color, locale.questContext.aggroObj), "", 0, "left", ALIGN_LEFT, 0)
        end
        local obj = X2Quest:GetLinkedQuestObjectives(questType)
        if obj ~= nil then
          for i = 1, #obj do
            local str
            if not isScore and obj[i].count ~= nil and obj[i].count ~= 0 then
              str = string.format("%s %d", obj[i].obj, obj[i].count)
            elseif isGroupQuest then
              str = string.format("[%s] %s", obj[i].obj, locale.questContext.questComplete)
            else
              str = string.format("%s", obj[i].obj)
            end
            lastIndex = questTooltip:AddLine(string.format("%s\194\183%s", color, str), "", 0, "left", ALIGN_LEFT, 0)
          end
        end
        local onlyLine1, includeSpace_2 = questTooltip:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace + space_bigFont)
      end
    end
    if tipItemTitle ~= nil then
      function tipItemTitle:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local height = 0
        local grade = tipInfo.grade
        local itemString = ""
        self.iconFrame.icon:ClearAllTextures()
        if tipInfo.itemType ~= nil then
          local iconInfo
          if tipInfo.iconInfo then
            iconInfo = tipInfo.iconInfo
          else
            iconInfo = X2Item:GetItemIconSet(tipInfo.lookType, tipInfo.itemGrade)
          end
          if tipInfo.equip ~= nil then
            self.iconFrame.equipIcon:SetVisible(tipInfo.equip)
          else
            self.iconFrame.equipIcon:SetVisible(false)
          end
          self.iconFrame.icon:AddTexture(iconInfo.itemIcon)
          if iconInfo.overIcon ~= nil then
            self.iconFrame.icon:AddTexture(iconInfo.overIcon)
          end
          if iconInfo.frameIcon ~= nil then
            self.iconFrame.icon:AddTexture(iconInfo.frameIcon)
          end
          self.iconFrame:SetLookIcon(tipInfo)
          self.iconFrame:SetDyeingInfo(tipInfo)
          self.iconFrame:SetLifeTimeIcon(tipInfo)
          self.iconFrame:SetPaperInfo(tipInfo)
          if baselibLocale.itemSideEffect then
            self.iconFrame:Anim_Item_Side_effect(X2Item:GetItemSideEffect(tipInfo.lookType))
          end
          self.iconFrame.blackImage:SetVisible(lockState ~= ITEM_SECURITY_UNLOCKED and lockState ~= nil)
          self.iconFrame:SetLockInfo(tipInfo)
          self.iconFrame:SetPackInfo(tipInfo)
          self.iconFrame:SetDisableEnchantInfo(tipInfo)
        else
          if tipInfo.tipType == "appStamp" then
            self.iconFrame.equipIcon:SetVisible(false)
          end
          self.iconFrame.icon:AddTexture(tipInfo.path)
        end
        local iconHeight = self.iconFrame.icon:GetHeight()
        local typeText = ""
        if tipInfo.category ~= nil then
          if tipInfo.tipType ~= nil and tipInfo.tipType == "passive" then
            typeText = GetUIText(COMMON_TEXT, "channeling_passive_skill")
          else
            typeText = tipInfo.category
          end
        elseif tipInfo.tipType == "appStamp" then
          typeText = string.format("%s%s", "|cFFFF9C27", GetCommonText("appellation_stamp"))
        end
        local itemCategoryIndex = tooltipItemAndSkill:AddLine(typeText, "", 0, "left", ALIGN_LEFT, 45)
        tooltipItemAndSkill:AttachUpperSpaceLine(itemCategoryIndex, 5)
        if grade ~= nil and (tipInfo.itemUsage == "equip" or tipInfo.itemGrade > 1) then
          local gradeColor = tipInfo.gradeColor or "FFFFFFFF"
          local itemGrameStr = "|c" .. gradeColor .. grade
          if tooltipLocale.forclyUseLeftSection then
            tooltipItemAndSkill:AddLine(itemGrameStr, "", 13, "left", ALIGN_LEFT, 45)
          else
            tooltipItemAndSkill:AddAnotherSideLine(itemCategoryIndex, itemGrameStr, "", 13, ALIGN_RIGHT, 0)
          end
        elseif tipInfo.tipType == "appStamp" then
          local str = GetCommonText("appellation_grade") .. tipInfo.reqlevel
          tooltipItemAndSkill:AddAnotherSideLine(itemCategoryIndex, str, "", 13, ALIGN_RIGHT, 0)
        end
        local itemString = SetItemName(tipInfo.name, grade, tipInfo.gradeColor)
        local index = tooltipItemAndSkill:AddLine(itemString, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 45)
        local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        if iconHeight > includeSpace_2 - includeSpace then
          tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont + (iconHeight - (includeSpace_2 - includeSpace)))
        else
          tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
        end
        onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace)
      end
    end
    if tipSecurityState ~= nil then
      function tipSecurityState:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local str = ""
        if tipInfo.securityState == ITEM_SECURITY_LOCKED then
          str = string.format("%s%s", FONT_COLOR_HEX.SKYBLUE, X2Locale:LocalizeUiText(TOOLTIP_TEXT, "item_lock"))
        elseif tipInfo.securityState == ITEM_SECURITY_UNLOCKING then
          local remainDate = tipInfo.securityRemainDate
          local remainDateString = locale.time.GetRemainDateToDateFormat(remainDate)
          str = string.format("%s%s %s %s", FONT_COLOR_HEX.RED, locale.trade.unlock, remainDateString, locale.housing.left)
        else
          return
        end
        local index = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
        local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
      end
    end
    if tipItemLookState ~= nil then
      function tipItemLookState:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = 0
        local lastLineIndex = 0
        if tipInfo.lookChanged ~= nil and tipInfo.lookChanged then
          local itemName = X2Item:Name(tipInfo.lookType)
          local str = string.format("%s%s [%s]", F_COLOR.GetColor("original_dark_orange", true), locale.tooltip.lookItem, itemName)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        local dyeingText = GetDyeingTooltipText(tipInfo)
        if dyeingText ~= nil and dyeingText ~= "" then
          lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s|r", FONT_COLOR_HEX.SINERGY, dyeingText), "", 0, "left", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
      end
    end
    if tipCraftOrderInfo ~= nil then
      function tipCraftOrderInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local craftOrder = tipInfo.craftOrder
        if craftOrder.invalid then
          local str = string.format("%s%s", FONT_COLOR_HEX.RED, GetUIText(TOOLTIP_TEXT, "not_orderable_craft_order_sheet"))
          local index = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
        else
          local str = string.format("%s%s", FONT_COLOR_HEX.SET_ORANGE, GetCommonText("craft_info"))
          local index1 = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          local color = X2Item:GradeColor(craftOrder.grade)
          str = string.format("|c%s%s", color, craftOrder.name)
          tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if craftOrder.actability ~= nil then
            str = string.format("%s: [%s]", GetCommonText("actability"), craftOrder.actability)
            tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          end
          str = string.format("%s %s", GetUIText(TOOLTIP_TEXT, "crafting_amount"), GetCommonText("amount", tostring(craftOrder.count)))
          local index2 = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(index1, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(index2, space_bigFont)
        end
        local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
      end
    end
    if tipUccViewer ~= nil then
      function tipUccViewer:SetInfo(tooltipItemAndSkill, tipInfo)
        if tipInfo.uccId ~= nil then
          self.group.uccBack:SetUccTextureByUccId(tipInfo.uccId, true)
          if self.group.uccBack:IsGrayTexture() then
            self.group.uccFront:SetExtent(self.uccWidth, self.uccWidth)
            self.group.uccBack:SetVisible(false)
          else
            self.group.uccFront:SetExtent(self.uccWidth / 2, self.uccWidth / 2)
            self.group.uccBack:SetVisible(true)
          end
          self.group.uccFront:SetUccTextureByUccId(tipInfo.uccId, false)
          self.group:Show(true)
        else
          self.group:Show(false)
        end
      end
    end
    if tipUserMusicInfos ~= nil then
      function tipUserMusicInfos:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local myInfo = X2Ability:GetMyActabilityInfo(33)
        local gradeInfo = X2Ability:GetGradeInfo(tipInfo.userMusicRequireGrade)
        if myInfo.grade > gradeInfo.grade then
          color = FONT_COLOR_HEX.GREEN
        elseif myInfo.grade < gradeInfo.grade then
          color = FONT_COLOR_HEX.RED
        else
          color = FONT_COLOR_HEX.SOFT_BROWN
        end
        local str = string.format("%s%s : %s (%s)", locale.tooltip.actabilityRequirement, color, myInfo.name, gradeInfo.name)
        local index1 = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        str = string.format("%s : %s%s", locale.mail.title, F_COLOR.GetColor("original_dark_orange", true), tipInfo.userMusicTitle)
        index2 = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachUpperSpaceLine(index1, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(index2, space_bigFont)
        local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
      end
    end
    if tipTreasureInfos ~= nil then
      function tipTreasureInfos:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local str = locale.chatSystem.ShowSextantPos(tipInfo.longitudeDir, tipInfo.longitudeDeg, tipInfo.longitudeMin, tipInfo.longitudeSec, tipInfo.latitudeDir, tipInfo.latitudeDeg, tipInfo.latitudeMin, tipInfo.latitudeSec)
        local index = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
        local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
      end
    end
    if tipLocationInfos ~= nil then
      function tipLocationInfos:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        if tipInfo.location_zone_name ~= nil then
          local firstLineIndex = tooltipItemAndSkill:AddLine(locale.tooltip.movePosition, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          local lastLineIndex = tooltipItemAndSkill:AddLine(locale.tooltip.movePositionInfo(tipInfo.location_world_name, tipInfo.location_zone_name), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipItemTimeInfos ~= nil then
      function tipItemTimeInfos:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        local rightIndex = 0
        if tipInfo.level_limit ~= nil and tipInfo.level_requirement ~= nil then
          local maxLimitLevel = tipInfo.level_limit
          local usableStr = tipInfo.isPetOnly and GetCommonText("tooltip_pet_item_usable_level") or GetCommonText("tooltip_player_item_usable_level")
          local color = GetItemLevelRestrictionColor(tipInfo.isPetOnly, maxLimitLevel, tipInfo.level_requirement)
          if tipInfo.level_requirement ~= 0 and maxLimitLevel == 0 then
            maxLimitLevel = GetLimitLevel(tipInfo.isPetOnly)
          end
          local requireLevelStr, limitLevelStr
          if color ~= FONT_COLOR_HEX.RED and IsHeirLevel(tipInfo.level_requirement) then
            requireLevelStr = GetLevelToString(tipInfo.level_requirement, F_COLOR.GetColor("successor_exp", true))
          else
            requireLevelStr = GetLevelToString(tipInfo.level_requirement, color)
          end
          if color ~= FONT_COLOR_HEX.RED and IsHeirLevel(maxLimitLevel) then
            limitLevelStr = GetLevelToString(maxLimitLevel, F_COLOR.GetColor("successor_exp", true))
          else
            limitLevelStr = GetLevelToString(maxLimitLevel, color)
          end
          if maxLimitLevel ~= 0 and tipInfo.level_requirement ~= 0 then
            if maxLimitLevel == tipInfo.level_requirement then
              lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s:%s", color, usableStr, limitLevelStr), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
              if firstLineIndex == -1 then
                firstLineIndex = lastLineIndex
              end
            elseif maxLimitLevel > tipInfo.level_requirement then
              lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s:%s ~%s", color, usableStr, requireLevelStr, limitLevelStr), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
              if firstLineIndex == -1 then
                firstLineIndex = lastLineIndex
              end
            end
          elseif maxLimitLevel ~= 0 then
            lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s:%s ~%s", color, usableStr, 1, limitLevelStr), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            end
          elseif tipInfo.level_requirement ~= 0 then
            lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s:%s ~%s", color, usableStr, requireLevelStr, limitLevelStr), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            end
          end
        end
        local soulBindText = GetSoulBindText(tipInfo)
        if soulBindText ~= nil and soulBindText ~= "" then
          if tooltipLocale.forclyUseLeftSection then
            rightIndex = 0
            lastLineIndex = tooltipItemAndSkill:AddLine(soulBindText, "", 13, "left", ALIGN_LEFT, 0)
          else
            if lastLineIndex ~= -1 and rightIndex == 0 then
              tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, soulBindText, "", 13, ALIGN_RIGHT, 0)
            else
              lastLineIndex = tooltipItemAndSkill:AddLine(soulBindText, "", 13, "right", ALIGN_RIGHT, 0)
            end
            rightIndex = rightIndex + 1
          end
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        local cannotEquipText = GetCannotEquipText(tipInfo)
        if cannotEquipText ~= nil and cannotEquipText ~= "" then
          if tooltipLocale.forclyUseLeftSection then
            rightIndex = 0
            lastLineIndex = tooltipItemAndSkill:AddLine(cannotEquipText, "", 13, "left", ALIGN_LEFT, 0)
          else
            if lastLineIndex ~= -1 and rightIndex == 0 then
              tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, cannotEquipText, "", 13, ALIGN_RIGHT, 0)
            else
              lastLineIndex = tooltipItemAndSkill:AddLine(cannotEquipText, "", 13, "right", ALIGN_RIGHT, 0)
            end
            rightIndex = rightIndex + 1
          end
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if tipInfo.extractable ~= nil and not tipInfo.extractable then
          local notExtractable = GetCommonText("not_extractable")
          if tooltipLocale.forclyUseLeftSection then
            rightIndex = 0
            lastLineIndex = tooltipItemAndSkill:AddLine(notExtractable, "", 13, "left", ALIGN_LEFT, 0)
          else
            if lastLineIndex ~= -1 and rightIndex == 0 then
              tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, notExtractable, "", 13, ALIGN_RIGHT, 0)
            else
              lastLineIndex = tooltipItemAndSkill:AddLine(notExtractable, "", 13, "right", ALIGN_RIGHT, 0)
            end
            rightIndex = rightIndex + 1
          end
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        local genderStr = GetGenderText(tipInfo)
        if genderStr ~= nil and genderStr ~= "" then
          if tooltipLocale.forclyUseLeftSection then
            rightIndex = 0
            lastLineIndex = tooltipItemAndSkill:AddLine(genderStr, "", 13, "left", ALIGN_LEFT, 0)
          else
            if lastLineIndex ~= -1 and rightIndex == 0 then
              tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, genderStr, "", 13, ALIGN_RIGHT, 0)
            else
              lastLineIndex = tooltipItemAndSkill:AddLine(genderStr, "", 13, "right", ALIGN_RIGHT, 0)
            end
            rightIndex = rightIndex + 1
          end
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if tipInfo.lifeSpan ~= nil and tipInfo.lifeSpanType ~= nil then
          local outputTime = tipInfo.lifeSpan
          local timeDisplayType = tipInfo.lifeSpanType
          local timeString = ""
          if outputTime > 0 then
            local dateFormat = X2Time:PeriodToDate(outputTime)
            local dateFilter = FORMAT_FILTER.HOUR
            if 0 < dateFormat.month then
              dateFormat.day = dateFormat.day + dateFormat.month * 30
              dateFormat.month = 0
            end
            if 0 < dateFormat.day then
              dateFilter = dateFilter + FORMAT_FILTER.DAY
            else
              dateFilter = dateFilter + FORMAT_FILTER.MINUTE + FORMAT_FILTER.SECOND
            end
            timeString = locale.time.GetRemainDateToDateFormat(dateFormat, dateFilter)
            if timeDisplayType == "period" then
              timeString = tipText.GetItemLifespanTime(timeString)
            else
              timeString = tipText.GetItemExpireRemainTime(timeString)
            end
          else
            timeString = tipText.itemTimeExpired
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(F_COLOR.GetColor("original_dark_orange", true) .. timeString, "", 13, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if firstLineIndex ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipEvolvingExpInfos ~= nil then
      function tipEvolvingExpInfos:SetInfo(tooltipItemAndSkill, tipInfo)
        local _, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex
        local lastLineIndex = -1
        local evolvingInfo = tipInfo.evolvingInfo
        if evolvingInfo ~= nil and evolvingInfo.minExp ~= nil then
          local str = string.format("%s%s %d/%d (%d%%)", F_COLOR.GetColor("original_dark_orange", true), GetUIText(COMMON_TEXT, "exp"), evolvingInfo.minExp, evolvingInfo.minSectionExp, evolvingInfo.percent)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if firstLineIndex ~= 0 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipItemInfo ~= nil then
      function tipItemInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local slotType = tipInfo.slotType
        local freshnessState = tipInfo.freshnessTooltip
        local freshnessRemainTime = tipInfo.freshnessRemainTime
        local speed = tipInfo.attackDelay
        local durability = tipInfo.durability
        local maxDurability = tipInfo.maxDurability
        local extraDamage = GetExtraDamageTooltipText(tipInfo)
        local useAsSkin = tipInfo.useAsSkin or false
        local useAsStat = tipInfo.useAsStat == nil and true or tipInfo.useAsStat
        local canEvolve = tipInfo.canEvolve
        local enchantable = tipInfo.gradeEnchantable or false
        local smeltable = tipInfo.smeltable or false
        local convertable = tipInfo.convertibleItem or false
        local scalable = tipInfo.scalable
        local isMaterial = tipInfo.isMaterial or false
        local isEnchantDisable = tipInfo.isEnchantDisable
        if tooltipLocale.forclyUseLeftSection then
          useAsSkin = false
          useAsStat = true
          enchantable = false
          convertable = false
          isEnchantDisable = false
        end
        local slotText
        if locale.common.equipSlotType[slotType] ~= nil then
          slotText = locale.common.equipSlotType[slotType]
        end
        local firstLineIndex
        local lastLineIndex = -1
        if isMaterial == false and slotText ~= nil then
          lastLineIndex = tooltipItemAndSkill:AddLine(slotText, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if speed ~= nil and slotType ~= "instrument" then
          local str = string.format("%s%s%s %0.1f", FONT_COLOR_HEX.GRAY, tipText.attackSpeed, FONT_COLOR_HEX.SOFT_BROWN, speed)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if durability ~= nil then
          local durabilityColor = GetDurabilityColor(durability, maxDurability)
          local str = string.format("%s%s %s%d/%d", FONT_COLOR_HEX.GRAY, tipText.durability, durabilityColor, durability, maxDurability)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if extraDamage ~= nil then
          lastLineIndex = tooltipItemAndSkill:AddLine(extraDamage, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if freshnessState ~= nil and slotType == "backpack" then
          local str = string.format("%s%s", F_COLOR.GetColor("medium_yellow", true), freshnessState)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if freshnessRemainTime ~= nil and slotType == "backpack" then
          local remainTime = string.format("%s", locale.time.GetRemainDateToDateFormat(freshnessRemainTime, DATE_FORMAT_FILTER1))
          str = string.format("%s%s", F_COLOR.GetColor("medium_yellow", true), X2Locale:LocalizeUiText(COMMON_TEXT, "freshness_remain_time", remainTime))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        firstLineIndex = firstLineIndex or lastLineIndex + 1
        local rightIndex = firstLineIndex
        if useAsSkin then
          local str = string.format("|c%s[%s]|r", Dec2Hex(FONT_COLOR.SKIN_ITEM), GetUIText(COMMON_TEXT, "skinize_item"))
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if isMaterial == false and not useAsStat then
          local str = string.format("|c%s[%s]|r", Dec2Hex(FONT_COLOR.STAT_ITEM), GetUIText(COMMON_TEXT, "stat_item"))
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if isEnchantDisable then
          local str = ""
          str = X2Locale:LocalizeUiText(COMMON_TEXT, "disable_enchant")
          str = string.format("%s%s", F_COLOR.GetColor("red", true), str)
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if not tooltipLocale.forclyUseLeftSection and canEvolve ~= nil and not isEnchantDisable then
          local str = ""
          if tipInfo.isMaxEvolvingGrade then
            str = X2Locale:LocalizeUiText(COMMON_TEXT, "max_grade")
            str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), str)
          elseif canEvolve then
            str = tooltipLocale.GradeString(GetUIText(COMMON_TEXT, "can_evlve"), tipInfo.maxEvolvingGrade)
            str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), str)
          else
            str = X2Locale:LocalizeUiText(COMMON_TEXT, "cant_evolving")
            str = string.format("%s%s", F_COLOR.GetColor("red", true), str)
          end
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if enchantable and not isEnchantDisable then
          local str = ""
          if tipInfo.isMaxGrade then
            str = X2Locale:LocalizeUiText(COMMON_TEXT, "max_grade")
          else
            str = tooltipLocale.GradeString(tipText.enchantable, tipInfo.maxEnchantableGrade)
          end
          str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), str)
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if smeltable then
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(GetCommonText("item_smelting_smeltable_tooltip"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, GetCommonText("item_smelting_smeltable_tooltip"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if convertable then
          local str = ""
          if isEnchantDisable then
            str = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "doNotMagicItem")
            str = string.format("%s%s", F_COLOR.GetColor("red", true), str)
          else
            str = tipText.magicItem
          end
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if not tooltipLocale.forclyUseLeftSection and IsScalable(tipInfo) then
          if lastLineIndex < rightIndex then
            lastLineIndex = tooltipItemAndSkill:AddLine(GetUIText(COMMON_TEXT, "scalable"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(rightIndex, GetUIText(COMMON_TEXT, "scalable"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
          end
          rightIndex = rightIndex + 1
        end
        if firstLineIndex ~= 0 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipSpecialty ~= nil then
      function tipSpecialty:SetInfo(tooltipItemAndSkill, tipInfo)
        local _, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex
        local lastLineIndex = -1
        local slotType = tipInfo.slotType
        local rebuyWorldGroup = tipInfo.rebuyWorldGroup
        local tradegoodsCreated = tipInfo.tradegoodsCreated
        if rebuyWorldGroup ~= nil and slotType == "backpack" then
          if rebuyWorldGroup == 3 then
            str = GetCommonText("tradegoods_rebuy_tooltip_nuia")
          elseif rebuyWorldGroup == 4 then
            str = GetCommonText("tradegoods_rebuy_tooltip_harihara")
          elseif rebuyWorldGroup == 5 then
            str = GetCommonText("tradegoods_rebuy_tooltip_origin")
          else
            str = GetCommonText("tradegoods_rebuy_tooltip")
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if tradegoodsCreated ~= nil and X2Store:GetSpecialtyDebug() == true then
          str = string.format("%s!!Created!!: %s", F_COLOR.GetColor("red", true), tradegoodsCreated)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = firstLineIndex or lastLineIndex
        end
        if firstLineIndex ~= 0 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipAttrInfo ~= nil then
      function tipAttrInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local attrString = "default"
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        attrString = GetMainAttrText(tipInfo)
        if attrString ~= "" then
          firstLineIndex = tooltipItemAndSkill:AddLine(attrString, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          lastLineIndex = firstLineIndex
        else
          attrString = ""
        end
        local attrs
        attrs = {
          TEXT_EXTRA_ATTR,
          TEXT_MAGIC_ATTR,
          TEXT_HEAL_ATTR,
          TEXT_MODIFIER_ATTR
        }
        for i = 1, #attrs do
          local str = GetBottomAttrText(tipInfo, attrs[i])
          if str ~= "" then
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            end
          end
        end
        local reinforceLevel = tipInfo.equipSlotReinforceLevel
        if reinforceLevel ~= nil and reinforceLevel > 0 then
          local str = GetUIText(COMMON_TEXT, "gear_score_euqip_slot_reinforce", tostring(reinforceLevel))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if lastLineIndex ~= -1 then
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        end
        local gemModifierStr = GetBottomAttrText(tipInfo, TEXT_GEM_MODIFIER_ATTR)
        if gemModifierStr ~= "" then
          lastLineIndex = tooltipItemAndSkill:AddLine(gemModifierStr, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if lastLineIndex ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(onlyLine1 - onlyLine - space_bigFont * 2)
        end
      end
    end
    if tipItemSocketInfos ~= nil then
      function tipItemSocketInfos:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local lastLineIndex = tooltipItemAndSkill:AddLine("", "", 0, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, 4)
        local firstLineIndex = lastLineIndex
        local socketInfo = tipInfo.socketInfo
        local upperSpace = 2
        local maxSocket = socketInfo.maxSocket
        if socketInfo.socketItem ~= nil then
          maxSocket = math.min(#socketInfo.socketItem, socketInfo.maxSocket)
        end
        for i = 1, MAX_ITEM_SOCKETS do
          if i > maxSocket then
            self.socket[i]:Show(false)
          else
            local _, height = tooltipItemAndSkill:GetHeightToLastLine()
            self.socket[i]:RemoveAllAnchors()
            self.socket[i]:Show(true)
            self.socket[i]:AddAnchor("TOPLEFT", self, 1, height - includeSpace + FORM_WIDGET_TOOPTIP.SOCKET_ANCHOR_OFFSET)
            local itemType = 0
            if socketInfo.socketItem ~= nil then
              itemType = socketInfo.socketItem[i] or 0
            end
            if itemType ~= 0 then
              local socketItemInfo = X2Item:GetItemInfoByType(itemType, 0, IIK_TYPE + IIK_SOCKET_MODIFIER)
              local modifierStr = ""
              for index = 1, #socketItemInfo.modifier do
                if socketItemInfo.eiset then
                  modifierStr = GetAddModifierText(socketItemInfo.modifier[index], FONT_COLOR_HEX.LIGHT_SKYBLUE)
                else
                  modifierStr = GetAddModifierText(socketItemInfo.modifier[index])
                end
              end
              self.socket[i]:SetItemIcon(socketItemInfo.lookType, 0)
              if modifierStr ~= "" then
                lastLineIndex = tooltipItemAndSkill:AddLine(modifierStr, "", 0, "left", ALIGN_LEFT, 22)
                tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, upperSpace)
              end
              if socketItemInfo.skill_modifier_tooltip ~= nil and socketItemInfo.skill_modifier_tooltip ~= "" then
                lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s", FONT_COLOR_HEX.GREEN, socketItemInfo.skill_modifier_tooltip), "", 0, "left", ALIGN_LEFT, 22)
                tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, upperSpace)
              end
              if socketItemInfo.buff_modifier_tooltip ~= nil and socketItemInfo.buff_modifier_tooltip ~= "" then
                lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s", FONT_COLOR_HEX.GREEN, socketItemInfo.buff_modifier_tooltip), "", 0, "left", ALIGN_LEFT, 22)
                tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, upperSpace)
              end
            else
              self.socket[i]:SetItemIcon()
              lastLineIndex = tooltipItemAndSkill:AddLine("|c00000000.", "", 0, "left", ALIGN_LEFT, 20)
              tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, upperSpace)
            end
          end
        end
        if lastLineIndex ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont * 2)
          local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(onlyLine1 - onlyLine - space_bigFont * 1.5)
        end
      end
    end
    if tipItemGearScore ~= nil then
      function tipItemGearScore:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = 0
        local lastLineIndex = -1
        local isMaterial = tipInfo.isMaterial
        local gearScore = tipInfo.gearScore
        if gearScore == nil or isMaterial then
          return
        end
        if gearScore.total == 0 and gearScore.bare == 0 then
          return
        end
        local str = GetUIText(COMMON_TEXT, "gear_score")
        lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
        if firstLineIndex == 0 then
          firstLineIndex = lastLineIndex
        end
        local totalScore = gearScore.total
        local str = string.format("%s|,%d;", F_COLOR.GetColor("item_level", true), totalScore)
        if ExistItemDiffInfo(tipInfo, "gearScore") == true then
          str = string.format("%s|r %s", str, MakeItemDiffText(GetItemDiffValue(tipInfo, "gearScore"), "|,%d;"))
        end
        lastLineIndex = tooltipItemAndSkill:AddLine(str, "", FONT_SIZE.XXLARGE, "right", ALIGN_RIGHT, 0)
        if firstLineIndex == 0 then
          firstLineIndex = lastLineIndex
        end
        if firstLineIndex ~= 0 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 1.7)
        end
      end
    end
    if tipItemInfoEx ~= nil then
      function tipItemInfoEx:SetInfo(tooltipItemAndSkill, tipInfo)
        if not tooltipLocale.forclyUseLeftSection then
          self:SetHeight(0)
          return
        end
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = 0
        local lastLineIndex = -1
        local useAsSkin = tipInfo.useAsSkin or false
        if useAsSkin then
          local str = string.format("|c%s[%s]|r", Dec2Hex(FONT_COLOR.SKIN_ITEM), GetUIText(COMMON_TEXT, "skinize_item"))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        local useAsStat = tipInfo.useAsStat == nil and true or tipInfo.useAsStat
        local isMaterial = tipInfo.isMaterial or false
        if isMaterial == false and not useAsStat then
          local str = string.format("|c%s[%s]|r", Dec2Hex(FONT_COLOR.STAT_ITEM), GetUIText(COMMON_TEXT, "stat_item"))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if tipInfo.isEnchantDisable then
          local str = ""
          str = X2Locale:LocalizeUiText(COMMON_TEXT, "disable_enchant")
          str = string.format("%s%s", F_COLOR.GetColor("red", true), str)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        else
          if tipInfo.canEvolve ~= nil then
            local str = ""
            if tipInfo.isMaxEvolvingGrade then
              str = X2Locale:LocalizeUiText(COMMON_TEXT, "max_grade")
              str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), str)
            elseif tipInfo.canEvolve then
              str = tooltipLocale.GradeString(GetUIText(COMMON_TEXT, "can_evlve"), tipInfo.maxEvolvingGrade)
              str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), str)
            else
              str = X2Locale:LocalizeUiText(COMMON_TEXT, "cant_evolving")
              str = string.format("%s%s", F_COLOR.GetColor("red", true), str)
            end
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == 0 then
              firstLineIndex = lastLineIndex
            end
          end
          if tipInfo.gradeEnchantable then
            if tipInfo.isMaxGrade then
              str = X2Locale:LocalizeUiText(COMMON_TEXT, "max_grade")
            else
              str = tooltipLocale.GradeString(tipText.enchantable, tipInfo.maxEnchantableGrade)
            end
            str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), str)
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == 0 then
              firstLineIndex = lastLineIndex
            end
          end
        end
        if tipInfo.convertibleItem then
          local str = ""
          if tipInfo.isEnchantDisable then
            str = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "doNotMagicItem")
            str = string.format("%s%s", F_COLOR.GetColor("red", true), str)
          else
            str = tipText.magicItem
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if IsScalable(tipInfo) then
          lastLineIndex = tooltipItemAndSkill:AddLine(GetUIText(COMMON_TEXT, "scalable"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "right", ALIGN_LEFT, 0)
          if firstLineIndex == 0 then
            firstLineIndex = lastLineIndex
          end
        end
        if firstLineIndex ~= 0 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine1, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipOption ~= nil then
      function tipOption:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = tooltipItemAndSkill:AddLine(tipText.addEffect, "", 0, "left", ALIGN_LEFT, 0)
        local lastLineIndex = firstLineIndex
        local attrString = ""
        if tipInfo.modifier ~= nil then
          for j = 1, #tipInfo.modifier do
            if not IsStat(tipInfo.modifier[j].name) then
              if attrString ~= "" then
                attrString = attrString .. "\n"
              end
              local value = tipInfo.modifier[j].value
              if value ~= nil and value ~= 0 then
                attrString = attrString .. GetAddModifierText(tipInfo.modifier[j])
              end
            end
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(attrString, FONT_PATH.DEFAULT, 12, "left", ALIGN_LEFT, 0)
        end
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(onlyLine1 - onlyLine - space_bigFont * 2)
      end
    end
    if tipSkillTitle ~= nil then
      function tipSkillTitle:SetInfo(tooltipItemAndSkill, tipInfo)
        local _, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        self.icon:ClearAllTextures()
        self.icon:AddTexture(tipInfo.path)
        local iconHeight = self.slotBackground:GetHeight()
        local abilityCategoryStr
        if tipInfo.isRaceSkill == true then
          abilityCategoryStr = GetUIText(COMMUNITY_TEXT, "race")
        else
          abilityCategoryStr = locale.common.abilityNameWithStr(tipInfo.ability)
        end
        local right_str = string.format("%s%s", tooltip.abilityColor[tipInfo.ability], abilityCategoryStr)
        index = tooltipItemAndSkill:AddLine(right_str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 45)
        tooltipItemAndSkill:AttachUpperSpaceLine(index, 5)
        right_str = nil
        if tipInfo.heirSkillName ~= 0 then
          right_str = string.format("%s%s", F_COLOR.GetColor("successor_exp", true), locale.common.heirSkills[tipInfo.heirSkillName])
        elseif tipInfo.isRaceSkill == false and IsCombatAbility(tipInfo) then
          right_str = string.format("%s%s", tooltip.abilityColor[tipInfo.ability], locale.tooltip.default)
        end
        if right_str ~= nil then
          tooltipItemAndSkill:AddAnotherSideLine(index, right_str, "", 0, ALIGN_RIGHT, 0)
        end
        local skillLevel = ""
        if tipInfo.skillLevel ~= 0 then
          skillLevel = string.format(" (%s)", tipText.GetSkillLevel(tipInfo.skillLevel))
        end
        local left_str = string.format("%s%s%s", tooltip.skilNameColor[tipInfo.ability], tipInfo.name, skillLevel)
        index = tooltipItemAndSkill:AddLine(left_str, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 45)
        local _, temp = tooltipItemAndSkill:GetHeightToLastLine()
        local addedSpace = 0
        if iconHeight > temp - includeSpace then
          addedSpace = iconHeight - (temp - includeSpace)
        end
        tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont + addedSpace)
        local _, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace)
      end
    end
    local SettingSynergyIcon = function(icon, isBuff)
      if isBuff == true then
        icon.bg:SetTextureInfo("buff_back", "buff")
        icon.deco:SetTextureInfo("buff_deco", "default")
        icon.deco:RemoveAllAnchors()
        icon.deco:AddAnchor("BOTTOM", icon, 0, 1)
      else
        icon.bg:SetTextureInfo("buff_back", "debuff")
        icon.deco:SetTextureInfo("debuff_deco", "default")
        icon.deco:RemoveAllAnchors()
        icon.deco:AddAnchor("TOP", icon, 0, -1)
      end
    end
    local ShowSynergyIcon = function(icon, show)
      icon:SetVisible(show)
      icon.bg:SetVisible(show)
      icon.deco:SetVisible(show)
    end
    local function SetSynergyIcon(widget, tipInfo, offsetX, offsetY, isLeftAnchor)
      local iconVisible = false
      if widget.synergyIcon2 == nil or widget.synergyIcon1 == nil then
        return iconVisible
      end
      if tipInfo.synergyicon2 ~= nil then
        widget.synergyIcon2:ClearAllTextures()
        widget.synergyIcon2:AddTexture(tipInfo.synergyicon2)
        widget.synergyIcon2:RemoveAllAnchors()
        if tipInfo.synergybuffkind2 then
          SettingSynergyIcon(widget.synergyIcon2, true)
        else
          SettingSynergyIcon(widget.synergyIcon2, false)
        end
        ShowSynergyIcon(widget.synergyIcon2, true)
        iconVisible = true
      else
        ShowSynergyIcon(widget.synergyIcon2, false)
      end
      if tipInfo.synergyicon1 ~= nil then
        widget.synergyIcon1:ClearAllTextures()
        widget.synergyIcon1:AddTexture(tipInfo.synergyicon1)
        widget.synergyIcon1:RemoveAllAnchors()
        if tipInfo.synergybuffkind1 then
          SettingSynergyIcon(widget.synergyIcon1, true)
        else
          SettingSynergyIcon(widget.synergyIcon1, false)
        end
        ShowSynergyIcon(widget.synergyIcon1, true)
        iconVisible = true
      else
        ShowSynergyIcon(widget.synergyIcon1, false)
      end
      if isLeftAnchor then
        if widget.synergyIcon1:IsVisible() then
          widget.synergyIcon1:AddAnchor("TOPLEFT", widget, offsetX, offsetY)
          offsetX = offsetX + (widget.synergyIcon1:GetWidth() + space_normalFont)
        end
        if widget.synergyIcon2:IsVisible() then
          widget.synergyIcon2:AddAnchor("TOPLEFT", widget, offsetX, offsetY)
        end
      else
        if widget.synergyIcon2:IsVisible() then
          widget.synergyIcon2:AddAnchor("TOPRIGHT", widget, offsetX, offsetY)
          offsetX = offsetX - (widget.synergyIcon1:GetWidth() + space_normalFont)
        end
        if widget.synergyIcon1:IsVisible() then
          widget.synergyIcon1:AddAnchor("TOPRIGHT", widget, offsetX, offsetY)
        end
      end
      return iconVisible
    end
    if tipSkillSimpleInfo ~= nil then
      function tipSkillSimpleInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        if tipInfo.mana ~= 0 then
          local mp_str = string.format("%s %d", tipText.mp, tipInfo.mana)
          lastLineIndex = tooltipItemAndSkill:AddLine(mp_str, "", 0, "left", ALIGN_LEFT, 0)
          firstLineIndex = lastLineIndex
        end
        local cast_str = FormatCastingTime(tipInfo.casting, tipInfo.channeling)
        if not tooltipLocale.forclyUseLeftSection then
          if lastLineIndex == -1 then
            lastLineIndex = tooltipItemAndSkill:AddLine(cast_str, "", 0, "right", ALIGN_RIGHT, 0)
          else
            tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, cast_str, "", 0, ALIGN_RIGHT, 0)
          end
        end
        if firstLineIndex == -1 then
          firstLineIndex = lastLineIndex
        end
        if tipInfo.minRange == nil then
          local range_str = tipText.rangeSelf
          lastLineIndex = tooltipItemAndSkill:AddLine(range_str, "", 0, "left", ALIGN_LEFT, 0)
        else
          local range_str = tipText.GetRange(tipInfo.minRange, tipInfo.maxRange)
          lastLineIndex = tooltipItemAndSkill:AddLine(range_str, "", 0, "left", ALIGN_LEFT, 0)
        end
        if firstLineIndex == -1 then
          firstLineIndex = lastLineIndex
        end
        if tipInfo.targetAreaRadius ~= nil and 0 < tipInfo.targetAreaRadius then
          local radius_str = tipText.GetTargetAreaRadius(tipInfo.targetAreaRadius)
          lastLineIndex = tooltipItemAndSkill:AddLine(radius_str, "", 0, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        local cooldown_str = FormatCooldownTime(tipInfo.cooldown)
        if not tooltipLocale.forclyUseLeftSection then
          tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, cooldown_str, "", 0, ALIGN_RIGHT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        local anchorOffsetForIconX, anchorOffsetForIconY = tooltipItemAndSkill:GetHeightToLastLine()
        anchorOffsetForIconX = -(space_bigFont / 2)
        anchorOffsetForIconY = anchorOffsetForIconY - includeSpace
        anchorOffsetForIconY = anchorOffsetForIconY + space_normalFont
        local iconVisible = false
        if not tooltipLocale.forclyUseLeftSection then
          iconVisible = SetSynergyIcon(self, tipInfo, anchorOffsetForIconX, anchorOffsetForIconY, false)
        end
        local iconHeight = 0
        if iconVisible then
          iconHeight = self.synergyIcon1:GetHeight()
        end
        if tipInfo.meleeDpsMultiplier ~= nil or tipInfo.rangedDpsMultiplier ~= nil or tipInfo.spellDpsMultiplier ~= nil or tipInfo.meleeDpsMultiplier ~= nil then
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        end
        if tipInfo.meleeDpsMultiplier ~= nil then
          local str = locale.attribute("melee_dps_inc") .. " +" .. tostring(tipInfo.meleeDpsMultiplier) .. "%"
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if tipInfo.rangedDpsMultiplier ~= nil then
          local str = locale.attribute("ranged_dps_inc") .. " +" .. tostring(tipInfo.rangedDpsMultiplier) .. "%"
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if tipInfo.spellDpsMultiplier ~= nil then
          local str = locale.attribute("spell_dps_inc") .. " +" .. tostring(tipInfo.spellDpsMultiplier) .. "%"
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        if tipInfo.healMultiplier ~= nil then
          local str = locale.attribute("heal_dps_inc") .. " +" .. tostring(tipInfo.healMultiplier) .. "%"
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        local _, temp = tooltipItemAndSkill:GetHeightToLastLine()
        local addedSpace = 0
        if iconHeight > temp - (anchorOffsetForIconY + includeSpace) then
          addedSpace = iconHeight - (temp - (anchorOffsetForIconY + includeSpace)) + space_bigFont
        end
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont + addedSpace)
        local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_normalFont)
      end
    end
    if tipSkillTimeInfo ~= nil then
      function tipSkillTimeInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        if not tooltipLocale.forclyUseLeftSection then
          self:SetHeight(0)
          return
        end
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        local cast_str = FormatCastingTime(tipInfo.casting, tipInfo.channeling)
        firstLineIndex = tooltipItemAndSkill:AddLine(cast_str, "", 0, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont)
        local cooldown_str = FormatCooldownTime(tipInfo.cooldown)
        lastLineIndex = tooltipItemAndSkill:AddLine(cooldown_str, "", 0, "left", ALIGN_LEFT, 0)
        local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_normalFont)
      end
    end
    if tipSkillEffectInfo ~= nil then
      function tipSkillEffectInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        if not tooltipLocale.forclyUseLeftSection then
          self:SetHeight(0)
          return
        end
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        firstLineIndex = tooltipItemAndSkill:AddLine(GetUIText(COMMON_TEXT, "skill_effect_occur"), "", 0, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont)
        local anchorOffsetForIconX, anchorOffsetForIconY = tooltipItemAndSkill:GetHeightToLastLine()
        anchorOffsetForIconX = space_bigFont / 2
        anchorOffsetForIconY = anchorOffsetForIconY - includeSpace
        local iconVisible = false
        iconVisible = SetSynergyIcon(self, tipInfo, anchorOffsetForIconX, anchorOffsetForIconY, true)
        local iconHeight = 0
        if iconVisible then
          iconHeight = self.synergyIcon1:GetHeight()
        end
        local _, temp = tooltipItemAndSkill:GetHeightToLastLine()
        local addedSpace = 0
        if iconHeight > temp - (anchorOffsetForIconY + includeSpace) then
          addedSpace = iconHeight - (temp - (anchorOffsetForIconY + includeSpace)) + space_bigFont
        end
        tooltipItemAndSkill:AttachLowerSpaceLine(firstLineIndex, space_bigFont + addedSpace)
        local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_normalFont)
      end
    end
    if tipSkillDesc ~= nil then
      function tipSkillDesc:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local desc_str = string.format("%s", FormatDurationTimeInDesc(tipInfo.description))
        index = tooltipItemAndSkill:AddLine(desc_str, "", 0, "left", ALIGN_LEFT, 0)
        tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont * 2)
        if tipInfo.linkSkillItem ~= nil then
          local linkTipInfo = X2Item:GetItemInfoByType(tipInfo.linkSkillItem)
          local skillType = linkTipInfo.skillType
          if skillType ~= nil then
            local skillInfo = X2Skill:GetSkillTooltip(skillType, linkTipInfo.itemType, SIK_DESCRIPTION)
            local description = skillInfo.description
            if description ~= nil and description ~= "" then
              local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.use_effect)
              str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(description))
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
              tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
              if firstLineIndex == -1 then
                firstLineIndex = lastLineIndex
              end
              local rSkillInfo = linkTipInfo.rechargeSkill
              if rSkillInfo ~= nil then
                local outputTime = rSkillInfo.remainTime
                local timeDisplayType = "remain"
                if linkTipInfo.needsUnpack == true or linkTipInfo.isLootBag == true or rSkillInfo.remainTime == nil then
                  outputTime = rSkillInfo.chargeLifetime
                  timeDisplayType = "period"
                end
                local timeString = ""
                if locale.time.IsEmptyDateFormat(outputTime) then
                  timeString = locale.tooltip.expireChargeLifetime
                else
                  timeString = locale.time.GetRemainDateToDateFormat(outputTime)
                  if timeDisplayType == "period" then
                    timeString = locale.tooltip.chargeLifetime(timeString)
                  else
                    timeString = locale.tooltip.chargeTimeRemained(timeString)
                  end
                end
                str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), timeString)
                lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
              end
              tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
            end
          end
        end
        tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
        local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace_2 - includeSpace - space_normalFont)
      end
    end
    if tipSkillSynergyInfos ~= nil then
      function tipSkillSynergyInfos:DynamicPushSection(tooltipWindow, needSectionCount)
        for i = #self + 1, needSectionCount do
          do
            local index = #self + 1
            local sectionSeparateType
            local sectionSeparateEmtpyWidth = 0
            local useSeparate = i == 1 and true or false
            local newSection = CreateSection("skillSynergyInfos[" .. index .. "]", tooltipWindow, useSeparate)
            newSection.index = i
            if i == 1 then
              local synergyTitle = newSection:CreateDrawable(TEXTURE_PATH.TOOLTIP, "chain", "overlay")
              synergyTitle:SetVisible(true)
              synergyTitle:AddAnchor("CENTER", newSection, "TOP", 0, -3)
            end
            local conditionIcon = newSection:CreateIconImageDrawable("ui/icon/move_item_bg.dds", "overlay")
            conditionIcon:SetMask("ui/common/slot_over.dds")
            conditionIcon:SetMaskCoords(0, 0, 40, 40)
            conditionIcon:SetExtent(24, 24)
            conditionIcon:SetCoords(0, 0, 48, 48)
            conditionIcon:SetColor(1, 1, 1, 1)
            local bg = newSection:CreateDrawable(TEXTURE_PATH.HUD, "buff_back", "background")
            bg:AddAnchor("TOPLEFT", conditionIcon, -2, -2)
            bg:AddAnchor("BOTTOMRIGHT", conditionIcon, 2, 2)
            conditionIcon.bg = bg
            local deco = newSection:CreateDrawable(TEXTURE_PATH.HUD, "debuff_deco", "overlay")
            deco:AddAnchor("TOP", conditionIcon, 0, -2)
            conditionIcon.deco = deco
            newSection.conditionIcon = conditionIcon
            local resultIcon = newSection:CreateIconImageDrawable("ui/icon/move_item_bg.dds", "overlay")
            resultIcon:SetMask("ui/common/slot_over.dds")
            resultIcon:SetMaskCoords(0, 0, 40, 40)
            resultIcon:SetExtent(24, 24)
            resultIcon:SetCoords(0, 0, 48, 48)
            resultIcon:SetColor(1, 1, 1, 1)
            local bg = newSection:CreateDrawable(TEXTURE_PATH.HUD, "buff_back", "background")
            bg:AddAnchor("TOPLEFT", resultIcon, -2, -2)
            bg:AddAnchor("BOTTOMRIGHT", resultIcon, 2, 2)
            resultIcon.bg = bg
            local deco = newSection:CreateDrawable(TEXTURE_PATH.HUD, "debuff_deco", "overlay")
            deco:AddAnchor("TOP", resultIcon, 0, -2)
            resultIcon.deco = deco
            newSection.resultIcon = resultIcon
            local arrow = newSection:CreateDrawable(TEXTURE_PATH.HUD, "tooltip_arrow", "overlay")
            arrow:SetTextureColor("white")
            arrow:AddAnchor("LEFT", newSection.conditionIcon, "RIGHT", 1, 1)
            newSection.arrow = arrow
            function newSection:SetInfo(tooltipItemAndSkill, tipInfo)
              local synergyInfo = tipInfo.synergyIconInfo[self.index]
              local onlyLine1, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
              local widthRatio = 0.68
              if synergyInfo.resulticon == nil then
                widthRatio = 0.88
              end
              local str = string.format("%s%s", FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(synergyInfo.desc))
              local idx = tooltipItemAndSkill:AddLine(str, "", 0, "right", ALIGN_LEFT, 0, widthRatio)
              local offset = 0
              if i == 1 then
                offset = tooltipLocale.skillSynergySection.startOffsetY
                conditionIcon:AddAnchor("LEFT", newSection, space_bigFont / 2, 5)
              else
                offset = space_normalFont + space_bigFont + 3
                conditionIcon:AddAnchor("LEFT", newSection, space_bigFont / 2, 0)
              end
              tooltipItemAndSkill:AttachUpperSpaceLine(idx, offset)
              local onlyLine2, _ = tooltipItemAndSkill:GetHeightToLastLine()
              local _, includeSpace2 = tooltipItemAndSkill:GetHeightToLastLine()
              local sectionHeight = includeSpace2 - includeSpace - self.anchorY
              if sectionHeight < self.conditionIcon:GetHeight() then
                sectionHeight = self.conditionIcon:GetHeight() + space_normalFont
                tooltipItemAndSkill:AttachLowerSpaceLine(idx, space_normalFont)
                tooltipItemAndSkill:AttachLowerSpaceLine(idx, space_normalFont)
              end
              self:SetHeight(sectionHeight)
              self.conditionIcon:ClearAllTextures()
              if synergyInfo.conditionicon ~= nil then
                self.conditionIcon:AddTexture(synergyInfo.conditionicon)
                ShowSynergyIcon(self.conditionIcon, true)
                if synergyInfo.conditionbuffkind == true then
                  SettingSynergyIcon(self.conditionIcon, true)
                else
                  SettingSynergyIcon(self.conditionIcon, false)
                end
              else
                ShowSynergyIcon(self.conditionIcon, false)
              end
              self.resultIcon:ClearAllTextures()
              self.resultIcon:AddAnchor("LEFT", self.arrow, "RIGHT", 4, -1)
              if synergyInfo.resulticon ~= nil then
                self.resultIcon:AddTexture(synergyInfo.resulticon)
                ShowSynergyIcon(self.resultIcon, true)
                self.arrow:SetVisible(true)
                if synergyInfo.resultbuffkind == true then
                  SettingSynergyIcon(self.resultIcon, true)
                else
                  SettingSynergyIcon(self.resultIcon, false)
                end
              else
                ShowSynergyIcon(self.resultIcon, false)
                self.arrow:SetVisible(false)
              end
            end
            self[index] = newSection
          end
        end
        for i = 1, needSectionCount do
          tooltipWindow:PushSection(self[i])
        end
      end
    end
    if tipSkillBody ~= nil then
      function tipSkillBody:SetInfo(tooltipItemAndSkill, tipInfo)
        local levelReq, moneyReq, pointReq, enoughReqPoints = CanUpgradeSkillByTipInfo(tipInfo)
        local levelColor = GetSkillLevelColor(levelReq)
        local pointColor = GetSkillPointColor(pointReq)
        local moneyColor = GetSkillMoneyColor(moneyReq)
        local reqPointColor = GetSkillReqPointColor(enoughReqPoints)
        if tipInfo.skillPoints == nil then
          if tipInfo.ability == "predator" or tipInfo.ability == "trooper" then
            tipInfo.skillPoints = 0
          else
            tipInfo.skillPoints = 1
          end
        end
        local firstLineIndex = -1
        local lastLineIndex = -1
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        if tipInfo.displayPetSkillLearnLevel ~= nil then
          firstLineIndex = tooltipItemAndSkill:GetLastLine() + 1
          local str = FONT_COLOR_HEX.RED .. locale.tooltip.GetPetSkillLearnLevel(tipInfo.learnLevel)
          firstLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          lastLineIndex = firstLineIndex
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont + space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(firstLineIndex, space_bigFont)
        elseif tipInfo.nextSkill ~= nil then
          local ability = locale.common.abilityNameWithStr(tipInfo.ability)
          local level = tipInfo.nextLearnLevel
          local str = levelColor .. locale.tooltip.GetNextLvRequirements(ability, level)
          firstLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          local str = string.format("%s%s |m%s;", moneyColor, locale.tooltip.cost, tostring(tipInfo.upgrade_cost))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont + space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        elseif tipInfo.firstLearnLevel ~= nil then
          firstLineIndex = tooltipItemAndSkill:GetLastLine() + 1
          local ability = locale.common.abilityNameWithStr(tipInfo.ability)
          local level = tipInfo.firstLearnLevel
          if level > 1 and level > tipInfo.abilityLevel then
            local str = ""
            if X2Ability:IsSpecialAbility(tipInfo.ability) then
              str = levelColor .. GetCommonText("first_level_special_abil_skill_req", GetUIText(RACE_TEXT, X2Unit:UnitRace("player")), level)
            else
              str = levelColor .. locale.tooltip.GetFirstLvRequirements(ability, level)
            end
            if tipInfo.learn == "cannot" then
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
          end
          if ability ~= locale.common.abilityNameWithStr("general") then
            if tipInfo.learn == "cannot" and 0 < tipInfo.reqPoints then
              local str = reqPointColor .. locale.tooltip.GetLearnPtRequirements(ability, tipInfo.reqPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            if tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
              local str = pointColor .. locale.skillTrainingMsg.skill_init_msg_4(tipInfo.skillPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
          end
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont + space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        elseif tipInfo.firstStartHeirLevel ~= nil then
          firstLineIndex = tooltipItemAndSkill:GetLastLine() + 1
          if tipInfo.activeType ~= nil and tipInfo.activeType == SAT_NONACTIVE then
            if tipInfo.activeTypeDesc ~= nil then
              lastLineIndex = tooltipItemAndSkill:AddLine(tipInfo.activeTypeDesc, "", 13, "left", ALIGN_LEFT, 0)
            end
          else
            local ability = locale.common.abilityNameWithStr(tipInfo.ability)
            local level = tipInfo.firstStartHeirLevel
            if level > 1 and tipInfo.SuccessStartHeirLevel == false then
              local levelColor = GetSkillLevelColor(tipInfo.SuccessStartHeirLevel)
              local str = ""
              if X2Ability:IsSpecialAbility(tipInfo.ability) then
                str = GetCommonText("first_level_special_abil_skill_req", GetUIText(RACE_TEXT, X2Unit:UnitRace("player")), level)
              else
                str = levelColor .. locale.tooltip.GetFirstLvRequirements(ability, level)
              end
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            level = tipInfo.firstLearnHeirLevel
            if level > 0 and tipInfo.SuccessLearnHeirLevel == false then
              local levelColor = GetSkillLevelColor(tipInfo.SuccessLearnHeirLevel)
              str = levelColor .. locale.tooltip.GetHeirLearnPtRequirements(level)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            if tipInfo.remainPoint ~= nil and tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
              local pointColor = GetSkillPointColor(tipInfo.remainPoint)
              local str = pointColor .. locale.skillTrainingMsg.consume_heir_points(tipInfo.skillPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
          end
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont + space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        elseif tipInfo.passive_buff_learn_level ~= nil then
          firstLineIndex = tooltipItemAndSkill:GetLastLine() + 1
          if tipInfo.learn ~= "master" then
            local ability = locale.common.abilityNameWithStr(tipInfo.ability)
            local level = tipInfo.passive_buff_learn_level
            if level > 1 and level > tipInfo.abilityLevel then
              local str = ""
              if X2Ability:IsSpecialAbility(tipInfo.ability) then
                str = levelColor .. GetCommonText("first_level_special_abil_skill_req", GetUIText(RACE_TEXT, X2Unit:UnitRace("player")), level)
              else
                str = levelColor .. locale.tooltip.GetNextLvRequirements(ability, level)
              end
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            if tipInfo.learn == "cannot" and 0 < tipInfo.reqPoints then
              ability = locale.common.abilityNameWithStr(tipInfo.ability)
              local str = reqPointColor .. locale.tooltip.GetLearnPtRequirements(ability, tipInfo.reqPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            if tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
              local str = pointColor .. locale.skillTrainingMsg.skill_init_msg_4(tipInfo.skillPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
          end
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont * 3.5)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, 0)
        elseif 0 < tipInfo.levelStep and not X2Ability:IsSpecialAbility(tipInfo.ability) then
          firstLineIndex = tooltipItemAndSkill:GetLastLine() + 1
          if tipInfo.learn ~= "master" then
            local ability = locale.common.abilityNameWithStr(tipInfo.ability)
            local level = tipInfo.firstLearnLevel
            if level ~= nil then
              if level > 1 then
                local str = levelColor .. locale.tooltip.GetNextLvRequirements(ability, level)
                lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
              end
              if tipInfo.reqPoints ~= nil and 0 < tipInfo.reqPoints and levelReq == false then
                ability = locale.common.abilityNameWithStr(tipInfo.ability)
                local str = reqPointColor .. locale.tooltip.GetLearnPtRequirements(ability, tipInfo.reqPoints)
                lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
              end
              if tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
                local str = levelColor .. locale.skillTrainingMsg.skill_init_msg_4(tipInfo.skillPoints)
                lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
              end
            elseif tipInfo.firstStartHeirLevel ~= nil then
              if tipInfo.activeType ~= nil and tipInfo.activeType == SAT_NONACTIVE then
                if tipInfo.activeTypeDesc ~= nil then
                  lastLineIndex = tooltipItemAndSkill:AddLine(tipInfo.activeTypeDesc, "", 13, "left", ALIGN_LEFT, 0)
                end
              else
                level = tipInfo.firstStartHeirLevel
                if level > 1 and tipInfo.SuccessStartHeirLevel == false then
                  local levelColor = GetSkillLevelColor(tipInfo.SuccessStartHeirLevel)
                  local str = levelColor .. locale.tooltip.GetNextLvRequirements(ability, level)
                  lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
                end
                level = tipInfo.firstLearnHeirLevel
                if level > 0 and tipInfo.SuccessLearnHeirLevel == false then
                  local levelColor = GetSkillLevelColor(tipInfo.SuccessLearnHeirLevel)
                  str = levelColor .. locale.tooltip.GetHeirLearnPtRequirements(level)
                  lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
                end
                if tipInfo.remainPoint ~= nil and tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
                  local pointColor = GetSkillPointColor(tipInfo.remainPoint)
                  local str = pointColor .. locale.skillTrainingMsg.consume_heir_points(tipInfo.skillPoints)
                  lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
                end
              end
            end
            if tipInfo.learn == "cannot" and tipInfo.reqPoints ~= nil and 0 < tipInfo.reqPoints then
              ability = locale.common.abilityNameWithStr(tipInfo.ability)
              local str = reqPointColor .. locale.tooltip.GetLearnPtRequirements(ability, tipInfo.reqPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            if tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
              local str = pointColor .. locale.skillTrainingMsg.skill_init_msg_4(tipInfo.skillPoints)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
          end
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, 0)
        elseif tipInfo.reqPoints ~= nil and tipInfo.skillPoints ~= nil then
          firstLineIndex = tooltipItemAndSkill:GetLastLine() + 1
          if tipInfo.reqPoints ~= nil and 0 < tipInfo.reqPoints then
            ability = locale.common.abilityNameWithStr(tipInfo.ability)
            local str = reqPointColor .. locale.tooltip.GetLearnPtRequirements(ability, tipInfo.reqPoints)
            lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          end
          if tipInfo.skillPoints > 0 and not X2Ability:IsSpecialAbility(tipInfo.ability) then
            local str = pointColor .. locale.skillTrainingMsg.skill_init_msg_4(tipInfo.skillPoints)
            lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          end
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_normalFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, 0)
        end
        if lastLineIndex ~= -1 then
          local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_normalFont)
        end
      end
    end
    if tipBuffInfo ~= nil then
      function tipBuffInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        if tipInfo.timeLeft ~= nil and tipInfo.timeLeft ~= 0 then
          local index = tooltipItemAndSkill:AddLine(tipText.leftTime .. " " .. FormatTime(tipInfo.timeLeft, nil, tipInfo.timeUnit), "", 0, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
          local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace1 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipPortalInfo ~= nil then
      function tipPortalInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local firstLineindex = -1
        local lastLineIndex = -1
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        if tipInfo.portalZone ~= nil then
          local str = string.format("%s - %s", locale.zoneText[tipInfo.portalZone], tipInfo.portalCoordinate)
          firstLineindex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AddLine(tipInfo.portalMemo, "", 13, "left", ALIGN_LEFT, 0)
          lastLineIndex = tooltipItemAndSkill:AddLine(locale.portal.itemDescUsed, "", 13, "left", ALIGN_LEFT, 0)
        else
          lastLineIndex = tooltipItemAndSkill:AddLine(locale.portal.itemDescUnused, "", 13, "left", ALIGN_LEFT, 0)
          firstLineindex = lastLineIndex
        end
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineindex, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(includeSpace1 - includeSpace - space_bigFont * 2)
      end
    end
    if tipCrimeInfo ~= nil then
      function tipCrimeInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local index = -1
        if tipInfo.attacker ~= nil then
          index = tooltipItemAndSkill:AddLine(locale.common.crime .. tipInfo.attacker, FONT_PATH.DEFAULT, 13, "left", ALIGN_LEFT, 0)
        end
        if index ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
          local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace1 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipMountInfo ~= nil then
      function tipMountInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local index = -1
        if tipInfo.dead ~= nil and tipInfo.dead == true then
          if tipInfo.item_impl == "summon_mate" then
            index = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.RED .. GetUIText(INSTANT_GAME_TEXT, "death"), FONT_PATH.DEFAULT, 13, "left", ALIGN_LEFT, 0)
          else
            index = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.RED .. locale.common.dead, FONT_PATH.DEFAULT, 13, "left", ALIGN_LEFT, 0)
          end
        end
        if index ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(index, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(index, space_bigFont)
          local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace1 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipDescription ~= nil then
      function tipDescription:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        if tipInfo.weight ~= nil and tipInfo.length ~= nil then
          local length = string.format("%s%.2f", F_COLOR.GetColor("original_dark_orange", true), tonumber(tipInfo.length))
          local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.length(length))
          local weight = string.format("%s%.2f", F_COLOR.GetColor("original_dark_orange", true), tonumber(tipInfo.weight))
          str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.GRAY, locale.tooltip.weight(weight))
          if tipInfo.catched ~= nil then
            local catched = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), locale.time.GetDateToDateFormat(tipInfo.catched))
            str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.GRAY, locale.tooltip.catchedDate(catched))
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
        end
        local itemInfoString = tipInfo.description
        if itemInfoString ~= nil and itemInfoString ~= "" then
          local str = string.format("%s", FormatDurationTimeInDesc(tipInfo.description))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          else
            tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
          end
        end
        if tipInfo.uccTooltip ~= nil and 0 < string.len(tipInfo.uccTooltip) then
          lastLineIndex = tooltipItemAndSkill:AddLine(tipInfo.uccTooltip, "", 13, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          else
            tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
          end
        end
        local skillType = tipInfo.skillType
        if skillType ~= nil then
          local skillInfo = X2Skill:GetSkillTooltip(skillType, tipInfo.itemType, SIK_DESCRIPTION)
          local description = skillInfo.description
          if description ~= nil and description ~= "" then
            local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.use_effect)
            str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(description))
            lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            end
            local rSkillInfo = tipInfo.rechargeSkill
            if rSkillInfo ~= nil then
              local outputTime = rSkillInfo.remainTime
              local timeDisplayType = "remain"
              if tipInfo.needsUnpack == true or tipInfo.isLootBag == true or rSkillInfo.remainTime == nil then
                outputTime = rSkillInfo.chargeLifetime
                timeDisplayType = "period"
              end
              local timeString = ""
              if locale.time.IsEmptyDateFormat(outputTime) then
                timeString = locale.tooltip.expireChargeLifetime
              else
                timeString = locale.time.GetRemainDateToDateFormat(outputTime)
                if timeDisplayType == "period" then
                  timeString = locale.tooltip.chargeLifetime(timeString)
                else
                  timeString = locale.tooltip.chargeTimeRemained(timeString)
                end
              end
              str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), timeString)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            end
            tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          end
        end
        if tipInfo.moveSpeed ~= nil then
          local str = string.format("%s%s %s%.1f%s", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "default_move_speed"), F_COLOR.GetColor("original_dark_orange", true), tipInfo.moveSpeed, GetUIText(UTIL_TEXT, "speed_unit"))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        end
        if tipInfo.swimSpeed ~= nil then
          local str = string.format("%s%s %s%.1f%s", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "default_swim_speed"), F_COLOR.GetColor("original_dark_orange", true), tipInfo.swimSpeed, GetUIText(UTIL_TEXT, "speed_unit"))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        end
        if tipInfo.procs ~= nil then
          local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.proc)
          for i = 0, #tipInfo.procs do
            str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(tipInfo.procs[i].desc))
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
          local rechargeProcInfo = tipInfo.rechargeProc
          if rechargeProcInfo ~= nil then
            local outputTime = rechargeProcInfo.remainTime
            local timeDisplayType = "remain"
            if tipInfo.needsUnpack == true or tipInfo.isLootBag == true or rechargeProcInfo.remainTime == nil then
              outputTime = rechargeProcInfo.chargeLifetime
              timeDisplayType = "period"
            end
            local timeString = ""
            if locale.time.IsEmptyDateFormat(outputTime) then
              timeString = locale.tooltip.expireChargeLifetime
            else
              timeString = locale.time.GetRemainDateToDateFormat(outputTime)
              if timeDisplayType == "period" then
                timeString = locale.tooltip.chargeLifetime(timeString)
              else
                timeString = locale.tooltip.chargeTimeRemained(timeString)
              end
            end
            str = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), timeString)
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          end
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        end
        if tipInfo.gem_procs ~= nil then
          local gemTypeStr = X2Locale:LocalizeUiText(AUCTION_TEXT, "item_category_moon_stone")
          local str = string.format("%s%s(%s)", FONT_COLOR_HEX.GRAY, locale.tooltip.proc, gemTypeStr)
          for i = 0, #tipInfo.gem_procs do
            str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(tipInfo.gem_procs[i].desc))
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          else
            tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
          end
        end
        local buffType = tipInfo.buffType
        if buffType ~= nil then
          local buffInfo = X2Ability:GetBuffTooltip(buffType, tipInfo.level, BIK_DESCRIPTION)
          local description = buffInfo.description
          if description ~= nil and description ~= "" then
            local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.equip_effect)
            str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(description))
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            else
              tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
            end
          end
        end
        local rBuffInfo = tipInfo.rechargeBuff
        if rBuffInfo ~= nil then
          local outputTime = rBuffInfo.remainTime
          local timeDisplayType = "remain"
          if tipInfo.needsUnpack == true or rBuffInfo.remainTime == nil then
            outputTime = rBuffInfo.chargeLifetime
            timeDisplayType = "period"
          end
          local buffInfo = X2Ability:GetBuffTooltip(rBuffInfo.buffType, tipInfo.level, BIK_DESCRIPTION)
          local description = buffInfo.description
          if description ~= nil and description ~= "" then
            local str = string.format("%s%s (%s)", FONT_COLOR_HEX.GRAY, locale.tooltip.equip_effect, locale.tooltip.rechargeItem)
            local timeString = ""
            if locale.time.IsEmptyDateFormat(outputTime) then
              timeString = locale.tooltip.expireChargeLifetime
            else
              timeString = locale.time.GetRemainDateToDateFormat(outputTime)
              if timeDisplayType == "period" then
                timeString = locale.tooltip.chargeLifetime(timeString)
              else
                timeString = locale.tooltip.chargeTimeRemained(timeString)
              end
            end
            str = string.format([[
%s
%s%s%s 
%s]], str, FONT_COLOR_HEX.SINERGY, FormatDurationTimeInDesc(description), F_COLOR.GetColor("original_dark_orange", true), timeString)
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            else
              tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
            end
          end
        end
        if tipInfo.evolvingCategory ~= nil then
          local evolvingInfo = tipInfo.evolvingInfo
          if evolvingInfo ~= nil then
            local outputTime = evolvingInfo.remainTime
            local timeDisplayType = "remain"
            if outputTime == nil then
              outputTime = tipInfo.rndAttrUnitModifierChargeLifetime
              timeDisplayType = "period"
            end
            local str = ""
            if evolvingInfo.minExp and evolvingInfo.modifier ~= nil then
              if outputTime ~= nil then
                str = string.format("%s%s (%s)", FONT_COLOR_HEX.GRAY, X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_effect"), locale.tooltip.rechargeItem)
              else
                str = string.format("%s%s", FONT_COLOR_HEX.GRAY, X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_effect"))
              end
              local evolveChance = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "reroll_evolving_chance", tostring(evolvingInfo.evolveChance))
              str = F_TEXT.SetEnterString(str, evolveChance)
              local attrString = ""
              for j = 1, #evolvingInfo.modifier do
                local value = evolvingInfo.modifier[j].value
                if value ~= nil and value ~= 0 then
                  attrString = F_TEXT.SetEnterString(attrString, GetAddModifierText(evolvingInfo.modifier[j]))
                end
              end
              if attrString ~= "" then
                str = F_TEXT.SetEnterString(str, attrString)
              end
            end
            if outputTime ~= nil then
              local timeString = ""
              if locale.time.IsEmptyDateFormat(outputTime) then
                timeString = locale.tooltip.expireChargeLifetime
              else
                timeString = locale.time.GetRemainDateToDateFormat(outputTime)
                if timeDisplayType == "period" then
                  timeString = locale.tooltip.chargeLifetime(timeString)
                else
                  timeString = locale.tooltip.chargeTimeRemained(timeString)
                end
              end
              timeString = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), timeString)
              str = F_TEXT.SetEnterString(str, timeString)
            end
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            else
              tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
            end
          else
            local str = ""
            if tipInfo.evolvingCategoryDesc ~= nil then
              str = string.format("%s%s", FONT_COLOR_HEX.GRAY, X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_effect"))
              str = F_TEXT.SetEnterString(str, string.format("%s%s", FONT_COLOR_HEX.SOFT_BROWN, tipInfo.evolvingCategoryDesc))
            end
            local outputTime = tipInfo.rndAttrUnitModifierChargeLifetime
            if outputTime ~= nil then
              timeString = locale.time.GetRemainDateToDateFormat(outputTime)
              timeString = locale.tooltip.chargeLifetime(timeString)
              timeString = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), timeString)
              str = F_TEXT.SetEnterString(str, timeString)
            end
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            else
              tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
            end
          end
        end
        if lastLineIndex ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont * 2)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipEffectDescription ~= nil then
      function tipEffectDescription:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        local itemInfoString = tipInfo.effectDescription
        if itemInfoString ~= nil and itemInfoString ~= "" then
          local str = string.format("%s%s|r", FONT_COLOR_HEX.GRAY, locale.tooltip.equip_effect)
          str = string.format([[
%s
%s]], str, FormatDurationTimeInDesc(tipInfo.effectDescription))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          else
            tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_bigFont)
          end
        end
        if lastLineIndex ~= -1 then
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
          tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
          self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
        end
      end
    end
    if tipSetItemsInfo ~= nil then
      function tipSetItemsInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local equipSetInfo = tipInfo.equipSetInfo
        if equipSetInfo == nil then
          return
        end
        local iconLineIndex = 1
        local firstLineIndex = -1
        local lastLineIndex = -1
        local startLine = tooltipItemAndSkill:GetLineCount()
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local setItems = equipSetInfo.setItems
        if equipSetInfo.wear == false then
          firstLineIndex = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.LIGHT_SKYBLUE .. locale.tooltip.addEffect, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont + space_setItem)
          lastLineIndex = firstLineIndex
          for i = 1, MAX_SET_ITEMS do
            self.setItem[i]:Show(false)
          end
        else
          local setItemTitle = string.format("%s (%d/%d)", equipSetInfo.equipSetItemInfoDesc, equipSetInfo.equippedSetItemCount, equipSetInfo.maxSetItemCount)
          firstLineIndex = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.SET_ORANGE .. setItemTitle, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont + space_setItem)
          local currentLine = tooltipItemAndSkill:GetLineCount()
          local _, height = tooltipItemAndSkill:GetHeightToLastLine()
          self.setItem[1]:RemoveAllAnchors()
          self.setItem[1]:AddAnchor("TOPLEFT", self, 3, height - includeSpace)
          for i = 1, MAX_SET_ITEMS do
            local setItem = setItems[i]
            local itemType = 0
            if setItem and setItem.item_type then
              itemType = setItem.item_type
            end
            if itemType ~= 0 then
              local setItemInfo = X2Item:GetItemInfoByType(itemType, 0, IIK_TYPE + IIK_SOCKET_MODIFIER)
              self.setItem[i]:SetItemIcon(setItemInfo.lookType, 0)
              self.setItem[i]:Show(true)
              self.setItem[i].itemBg:SetVisible(setItem.equipped)
              if setItem.equipped == false then
                self.setItem[i]:SetAlpha(0.3)
              else
                self.setItem[i]:SetAlpha(1)
              end
              if i > MAX_SET_ITEMS / 2 then
                iconLineIndex = 2
              end
            else
              self.setItem[i]:Show(false)
              self.setItem[i].itemBg:SetVisible(false)
            end
          end
          tooltipItemAndSkill:AttachLowerSpaceLine(firstLineIndex, iconLineIndex * (ICON_SIZE.SET_ITEM + 3))
          lastLineIndex = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.GREEN .. locale.tooltip.set_effect, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          tooltipItemAndSkill:AttachUpperSpaceLine(lastLineIndex, space_normalFont)
        end
        local bonuses = equipSetInfo.bonuses
        for i = 1, #bonuses do
          local bonus = bonuses[i]
          local effect = bonus.bufDesc or bonus.procDesc or "none"
          local effect_str = string.format("%s", FormatDurationTimeInDesc(effect))
          if bonus.satisfied then
            lastLineIndex = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.GREEN .. effect_str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 10)
          else
            lastLineIndex = tooltipItemAndSkill:AddLine(FONT_COLOR_HEX.GRAY .. MakeUnsatisfiedSetEffectText(bonus.numPieces, effect_str, equipSetInfo.wear), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 10)
          end
        end
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(onlyLine1 - onlyLine - space_bigFont * 2)
      end
    end
    if tipEtcItemsInfo ~= nil then
      function tipEtcItemsInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        if tipInfo.craftType ~= nil and tipInfo.craftType ~= 0 then
          local craftInfo = X2Craft:GetCraftBaseInfo(tipInfo.craftType)
          if craftInfo ~= nil then
            lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), GetUIText(CRAFT_TEXT, "craftInfo")), "", 13, "left", ALIGN_LEFT, 0)
            if firstLineIndex == -1 then
              firstLineIndex = lastLineIndex
            end
            if craftInfo.required_actability_type ~= 19 and craftInfo.required_actability_type ~= 32 and craftInfo.required_actability_name ~= nil then
              local actabilityStr = GetUIText(SKILL_TEXT, "actabilityButtonText")
              local str = string.format("%s: [%s]", actabilityStr, craftInfo.required_actability_name)
              if craftInfo.required_actability_point ~= nil and craftInfo.required_actability_point > 1 then
                local pointStr = X2Locale:LocalizeUiText(COMMON_TEXT, "tooltip_craft_required_actability_point", tostring(craftInfo.required_actability_point))
                str = string.format("%s %s", str, pointStr)
              end
              tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            if craftInfo.doodad_name ~= nil then
              local str = string.format("%s: %s", GetUIText(CRAFT_TEXT, "require_doodad"), craftInfo.doodad_name)
              lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
            end
            tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
          end
        end
        if tipInfo.requiredCondition ~= nil then
          local enchantInfo = tipInfo.requiredCondition
          local enchantInfoStr = ""
          lastLineIndex = tooltipItemAndSkill:AddLine(string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), locale.tooltip.reqEnchantCondition), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
          if enchantInfo.equipLevel ~= nil and 0 < enchantInfo.equipLevel then
            local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.reqEnchantLevelOver(FONT_COLOR_HEX.SOFT_BROWN .. enchantInfo.equipLevel))
            tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          end
          if enchantInfo.itemGrade ~= nil then
            local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.reqEnchantGradeOver(FONT_COLOR_HEX.SOFT_BROWN .. enchantInfo.itemGrade))
            tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          end
          if enchantInfo.equipSlotTypes ~= nil then
            local slotText = FONT_COLOR_HEX.SOFT_BROWN
            for x = 1, #enchantInfo.equipSlotTypes do
              local text = locale.common.equipSlotType[enchantInfo.equipSlotTypes[x]]
              if x ~= 1 then
                slotText = string.format("%s, %s", slotText, text)
              else
                slotText = string.format("%s%s", slotText, text)
              end
            end
            enchantInfoStr = enchantInfoStr .. string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.reqEnchantSlot(slotText))
          end
          lastLineIndex = tooltipItemAndSkill:AddLine(enchantInfoStr, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if enchantInfo.equipItemName ~= nil then
            local text = string.format("%s%s", FONT_COLOR_HEX.SOFT_BROWN, enchantInfo.equipItemName)
            local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.reqEnchantItem(text))
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          elseif enchantInfo.equipItemTagName ~= nil then
            local text = string.format("%s%s", FONT_COLOR_HEX.SOFT_BROWN, enchantInfo.equipItemTagName)
            local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.reqEnchantItem(text))
            lastLineIndex = tooltipItemAndSkill:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          end
        end
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont * 2)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(onlyLine1 - onlyLine - space_bigFont * 2)
      end
    end
    if tipCrafterInfo ~= nil then
      function tipCrafterInfo:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        if tipInfo.crafter ~= nil then
          local text = FONT_COLOR_HEX.GRAY .. tipText.crafter .. "|r " .. tipInfo.crafter
          lastLineIndex = tooltipItemAndSkill:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          if firstLineIndex == -1 then
            firstLineIndex = lastLineIndex
          end
          if tipInfo.isMyWorld == false and tipInfo.craftedWorldName ~= nil and tipInfo.craftedWorldName ~= "" then
            text = FONT_COLOR_HEX.GRAY .. tipText.craftedWorld .. "|r " .. tipInfo.craftedWorldName
            lastLineIndex = tooltipItemAndSkill:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          end
          if lastLineIndex ~= -1 then
            tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
            tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
            local onlyLine_2, includeSpace_2 = tooltipItemAndSkill:GetHeightToLastLine()
            self:SetHeight(includeSpace_2 - includeSpace - space_bigFont * 2)
          end
        end
      end
    end
    if tipSellable ~= nil then
      function tipSellable:SetInfo(tooltipItemAndSkill, tipInfo)
        local onlyLine, includeSpace = tooltipItemAndSkill:GetHeightToLastLine()
        local firstLineIndex = -1
        local lastLineIndex = -1
        tipSellable.kindImg:Show(false)
        if tipInfo.linkKind ~= nil then
          if tipInfo.linkKind == "auction" then
            lastLineIndex = tooltipItemAndSkill:AddLine("-", "", 13, "left", ALIGN_LEFT, 0, 0.35)
            tipSellable.kindImg:Show(true)
            tipSellable.kindImg:SetTextureInfo("auction")
          elseif tipInfo.linkKind == "coffer" then
            lastLineIndex = tooltipItemAndSkill:AddLine("-", "", 13, "left", ALIGN_LEFT, 0, 0.35)
            tipSellable.kindImg:Show(true)
            tipSellable.kindImg:SetTextureInfo("storage")
          end
        elseif tipInfo.sellable then
          if tipInfo.slotType == "backpack" then
            lastLineIndex = tooltipItemAndSkill:AddLine(tipText.sellPrice, "", 13, "left", ALIGN_LEFT, 0, 0.35)
          else
            lastLineIndex = tooltipItemAndSkill:AddLine(tipText.sellYes, "", 13, "left", ALIGN_LEFT, 0, 0.35)
          end
          local refund = tipInfo.refund
          if tipInfo.isStackable and tipInfo.stack ~= nil then
            refund = F_CALC.MulNum(refund, tipInfo.stack or 1)
          end
          tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, "|m" .. string.format("%d", refund) .. ";", "", 13, ALIGN_RIGHT, 0, 0.65)
        else
          local str = string.format("%s%s", FONT_COLOR_HEX.RED, tipText.sellNo)
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0)
        end
        firstLineIndex = lastLineIndex
        local repairable = tipInfo.repairable
        if repairable ~= nil and tipInfo.linkKind == nil then
          if not repairable and tipInfo.maxDurability ~= nil then
            local str = string.format("%s%s", FONT_COLOR_HEX.RED, GetUIText(REPAIR_TEXT, "cantRepair"))
            lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0, 1)
          elseif X2Item:IsInRepairMode() and tipInfo.repairCost ~= nil then
            lastLineIndex = tooltipItemAndSkill:AddLine(GetUIText(REPAIR_TEXT, "repair_cost"), "", 13, "left", ALIGN_LEFT, 0, 0.4)
            tooltipItemAndSkill:AddAnotherSideLine(lastLineIndex, "|m" .. string.format("%d", tipInfo.repairCost) .. ";", "", 13, ALIGN_RIGHT, 0, 0.65)
          end
        end
        local indestructible = tipInfo.indestructible
        if indestructible then
          local str = string.format("%s%s|r", FONT_COLOR_HEX.RED, GetUIText(COMMON_TEXT, "indestructible"))
          lastLineIndex = tooltipItemAndSkill:AddLine(str, "", 13, "left", ALIGN_LEFT, 0, 1)
        end
        tooltipItemAndSkill:AttachUpperSpaceLine(firstLineIndex, space_bigFont)
        tooltipItemAndSkill:AttachLowerSpaceLine(lastLineIndex, space_bigFont)
        local onlyLine1, includeSpace1 = tooltipItemAndSkill:GetHeightToLastLine()
        self:SetHeight(onlyLine1 - onlyLine - space_bigFont * 2)
      end
    end
  end
end
local CalcCombinedExtent = function(wnd1, wnd2, wnd3)
  local extent = {}
  if wnd3 ~= nil then
    local width1, _ = wnd1:GetExtent()
    local height1 = wnd1:GetTotalSectionHeight()
    local width2, _ = wnd2:GetExtent()
    local height2 = wnd2:GetTotalSectionHeight()
    local width3, _ = wnd3:GetExtent()
    local height3 = wnd3:GetTotalSectionHeight()
    extent.width = width1 + width2 + width3
    if height1 > height2 then
      extent.height = height1
    else
      extent.height = height2
    end
    if height3 > extent.height then
      extent.height = height3
    end
  else
    local width1, _ = wnd1:GetExtent()
    local height1 = wnd1:GetTotalSectionHeight()
    local width2, _ = wnd2:GetExtent()
    local height2 = wnd2:GetTotalSectionHeight()
    extent.width = width1 + width2
    if height1 > height2 then
      extent.height = height1
    else
      extent.height = height2
    end
  end
  return extent
end
local function HasExtraAttr(modifiers)
  if modifiers == nil then
    return false
  end
  for j = 1, #modifiers do
    if not IsStat(modifiers[j].name) then
      return true
    end
  end
  return false
end
local HasGearScoreSecitonData = function(tipInfo)
  local gearScore = tipInfo.gearScore
  if gearScore == nil then
    return false
  end
  if gearScore.total == 0 and gearScore.bare == 0 then
    return false
  end
  return true
end
local HasDescriptionSectionData = function(tipInfo)
  local hasDescription = tipInfo.description ~= nil and tipInfo.description ~= ""
  local hasProcs = tipInfo.procs ~= nil
  local hasGemProcs = tipInfo.gem_procs ~= nil
  local hasBuffDescription = false
  local hasSkillDescription = false
  local uccApplicable = tipInfo.uccTooltip ~= nil and string.len(tipInfo.uccTooltip) > 0
  local hasRechargeBuff = tipInfo.rechargeBuff ~= nil
  local hasEvolvingCategory = false
  if tipInfo.evolvingCategory then
    local evolvingInfo = tipInfo.evolvingInfo
    if evolvingInfo ~= nil then
      hasEvolvingCategory = tipInfo.evolvingInfo.modifier ~= nil
    else
      hasEvolvingCategory = tipInfo.evolvingCategoryDesc ~= nil or tipInfo.rndAttrUnitModifierChargeLifetime ~= nil
    end
  end
  local buffType = tipInfo.buffType
  if buffType ~= nil then
    local buffInfo = X2Ability:GetBuffTooltip(buffType, tipInfo.level, BIK_DESCRIPTION)
    local description = buffInfo.description
    hasBuffDescription = description ~= nil and description ~= ""
  end
  local skillType = tipInfo.skillType
  if skillType ~= nil then
    local skillInfo = X2Skill:GetSkillTooltip(skillType, tipInfo.itemType, SIK_DESCRIPTION)
    local description = skillInfo.description
    hasSkillDescription = description ~= nil and description ~= ""
  end
  local hasSwimSpeed = tipInfo.swimSpeed ~= nil
  local hasMoveSpeed = tipInfo.moveSpeed ~= nil
  return hasDescription or hasProcs or hasBuffDescription or hasSkillDescription or hasGemProcs or uccApplicable or hasRechargeBuff or hasSwimSpeed or hasMoveSpeed or hasEvolvingCategory
end
local HasEffectDescriptionSectionData = function(tipInfo)
  return tipInfo.effectDescription ~= nil and tipInfo.effectDescription ~= ""
end
local HasEtcSectionData = function(tipInfo)
  if tipInfo.craftType ~= nil and tipInfo.craftType ~= 0 then
    return true
  end
  if tipInfo.requiredCondition ~= nil then
    return true
  end
  return false
end
local HasCrafterSectionData = function(tipInfo)
  local hasCrafter = false
  if tipInfo.crafter ~= nil then
    hasCrafter = true
  end
  return hasCrafter
end
local HasUcc = function(tipInfo)
  if tipInfo.uccId ~= nil then
    return true
  end
  return false
end
local IsSpecialtyBackPack = function(tipInfo)
  local refund = tipInfo.refund
  return tipInfo.sellable == true and refund == 0
end
local function HasItemLookData(tipInfo)
  if tipInfo.lookChanged ~= nil and tipInfo.lookChanged then
    return true
  end
  local dyeingText = GetDyeingTooltipText(tipInfo)
  if dyeingText ~= nil and dyeingText ~= "" then
    return true
  end
  return false
end
local function HasItemTimeInfosSectionData(tipInfo)
  if tipInfo.level_requirement ~= nil and tipInfo.level_requirement ~= 0 then
    return true
  end
  if tipInfo.level_limit ~= nil and tipInfo.level_limit ~= 0 then
    return true
  end
  local soulBindText = GetSoulBindText(tipInfo)
  if soulBindText ~= nil and soulBindText ~= "" then
    return true
  end
  if tipInfo.extractable ~= nil and not tipInfo.extractable then
    return true
  end
  if tipInfo.lifeSpan ~= nil then
    return true
  end
  local genderText = GetGenderText(tipInfo)
  if genderText ~= nil and genderText ~= "" then
    return true
  end
  return false
end
local HasItemEvolvingExpData = function(tipInfo)
  local canEvolve = tipInfo.canEvolve or false
  if canEvolve == false then
    return false
  end
  local evolvingInfo = tipInfo.evolvingInfo
  if evolvingInfo == nil then
    return false
  end
  if evolvingInfo.minExp == nil then
    return false
  end
  if evolvingInfo.minSectionExp == nil then
    return false
  end
  return true
end
local function HasItemInfosExSectionData(tipInfo)
  if not tooltipLocale.forclyUseLeftSection then
    return false
  end
  local isMaterial = tipInfo.isMaterial or false
  if tipInfo.useAsSkin ~= nil and tipInfo.useAsSkin then
    return true
  end
  if tipInfo.useAsStat ~= nil and not tipInfo.useAsStat and not isMaterial then
    return true
  end
  if tipInfo.canEvolve ~= nil and tipInfo.canEvolve == true then
    return true
  end
  if tipInfo.gradeEnchantable ~= nil and tipInfo.gradeEnchantable == true then
    return true
  end
  if tipInfo.smeltable ~= nil and tipInfo.smeltable == true then
    return true
  end
  if tipInfo.freshnessState ~= nil and tipInfo.freshnessState == true then
    return true
  end
  if tipInfo.freshnessRemainTime ~= nil and tipInfo.freshnessRemainTime == true then
    return true
  end
  if tipInfo.convertibleItem ~= nil and tipInfo.convertibleItem == true then
    return true
  end
  if IsScalable(tipInfo) then
    return true
  end
  return false
end
local HasSpecialtySectionData = function(tipInfo)
  if tipInfo.rebuyWorldGroup ~= nil then
    return true
  end
  if tipInfo.tradegoodsCreated ~= nil and X2Store:GetSpecialtyDebug() == true then
    return true
  end
  return false
end
local function HasItemInfosSectionData(tipInfo)
  local slotText = tipInfo.slotType
  local durability = tipInfo.durability
  local isMaterial = tipInfo.isMaterial or false
  if locale.common.equipSlotType[slotText] ~= nil then
    slotText = locale.common.equipSlotType[slotText]
  end
  if slotText ~= nil and not isMaterial then
    return true
  end
  if durability ~= nil then
    return true
  end
  local extraDamageText = GetExtraDamageTooltipText(tipInfo)
  if extraDamageText ~= nil then
    return true
  end
  if not tooltipLocale.forclyUseLeftSection then
    if tipInfo.useAsSkin ~= nil and tipInfo.useAsSkin then
      return true
    end
    if tipInfo.useAsStat ~= nil and not tipInfo.useAsStat and not isMaterial then
      return true
    end
    if tipInfo.canEvolve ~= nil and tipInfo.canEvolve == true then
      return true
    end
    if tipInfo.gradeEnchantable ~= nil and tipInfo.gradeEnchantable == true then
      return true
    end
    if tipInfo.smeltable ~= nil and tipInfo.smeltable == true then
      return true
    end
    if tipInfo.freshnessState ~= nil and tipInfo.freshnessState == true then
      return true
    end
    if tipInfo.freshnessRemainTime ~= nil and tipInfo.freshnessRemainTime == true then
      return true
    end
    if tipInfo.convertibleItem ~= nil and tipInfo.convertibleItem == true then
      return true
    end
    if IsScalable(tipInfo) then
      return true
    end
  end
  return false
end
local function HasAttrSectionData(tipInfo)
  local hasMainAttr = GetMainAttrText(tipInfo) ~= ""
  local hasBottomAttr = false
  local attrString = ""
  local attrs
  attrs = {
    TEXT_EXTRA_ATTR,
    TEXT_MAGIC_ATTR,
    TEXT_HEAL_ATTR,
    TEXT_MODIFIER_ATTR,
    TEXT_GEM_MODIFIER_ATTR
  }
  for i = 1, #attrs do
    local str = GetBottomAttrText(tipInfo, attrs[i])
    if str ~= "" then
      attrString = attrString .. str .. "\n"
    end
  end
  hasBottomAttr = attrString ~= ""
  return hasMainAttr or hasBottomAttr
end
local function FillTooltipInfo(tipInfo, tipNum)
  tooltip.tooltipWindows[tipNum]:ClearSection()
  local tooltipWnd = tooltip.tooltipWindows[tipNum]
  tooltipWnd.minWindowWidth = 250
  if HasUcc(tipInfo) and tooltipWnd.compareType ~= nil then
    tooltipWnd:PushSection(tooltip.uccViewer[tipNum])
  else
    tooltipWnd:PushSection(tooltip.itemTitles[tipNum])
    if HasGearScoreSecitonData(tipInfo) then
      tooltipWnd:PushSection(tooltip.gearScore[tipNum])
    end
    if tipInfo.securityState == ITEM_SECURITY_LOCKED or tipInfo.securityState == ITEM_SECURITY_UNLOCKING then
      tooltipWnd:PushSection(tooltip.securityState[tipNum])
    end
    if HasItemLookData(tipInfo) then
      tooltipWnd:PushSection(tooltip.itemLookState[tipNum])
    end
    if tipInfo.userMusicTitle ~= nil then
      tooltipWnd:PushSection(tooltip.userMusicInfos[tipNum])
    end
    if tipInfo.location_zone_name ~= nil then
      tooltipWnd:PushSection(tooltip.locationInfos[tipNum])
    end
    if HasItemTimeInfosSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.itemTimeInfos[tipNum])
    end
    if HasItemEvolvingExpData(tipInfo) then
      tooltipWnd:PushSection(tooltip.itemEvolvingExpInfos[tipNum])
    end
    if HasItemInfosSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.itemInfos[tipNum])
    end
    if HasSpecialtySectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.specialty[tipNum])
    end
    if HasAttrSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.attrInfos[tipNum])
    end
    if tipInfo.socketInfo ~= nil then
      tooltipWnd:PushSection(tooltip.itemSocketInfos[tipNum])
    end
    if HasItemInfosExSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.itemInfosEx[tipNum])
    end
    if HasExtraAttr(tipInfo.modifier) == true then
      tooltipWnd:PushSection(tooltip.options[tipNum])
    end
    if HasDescriptionSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.descriptions[tipNum])
    end
    if tipInfo.equipSetInfo then
      tooltipWnd:PushSection(tooltip.setItemsInfo[tipNum])
    end
    if HasEtcSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.etcItemsInfo[tipNum])
    end
    if HasCrafterSectionData(tipInfo) then
      tooltipWnd:PushSection(tooltip.crafterInfo[tipNum])
    end
    if tipInfo.longitudeDir ~= nil then
      tooltipWnd:PushSection(tooltip.treasureInfos[tipNum])
    end
    if not IsSpecialtyBackPack(tipInfo) then
      tooltipWnd:PushSection(tooltip.sellables[tipNum])
    end
  end
  tooltipWnd:SetInfo(tipInfo)
end
local IsSingleTooltip = function(tipInfos)
  local selfInfo = tipInfos[1]
  local mainHandInfo = tipInfos[2]
  local offHandInfo = tipInfos[3]
  local slotType = selfInfo.slotType
  if mainHandInfo == nil and offHandInfo == nil then
    return true
  end
  if slotType == "shield" and offHandInfo == nil then
    return true
  end
  return false
end
local IsDoubleTooltip = function(tipInfos)
  local selfInfo = tipInfos[1]
  local mainHandInfo = tipInfos[2]
  local offHandInfo = tipInfos[3]
  local slotType = selfInfo.slotType
  local emptyOne = mainHandInfo ~= nil and offHandInfo == nil or mainHandInfo == nil and offHandInfo ~= nil
  if slotType == "2handed" and emptyOne then
    return true
  end
  if slotType == "shield" and offHandInfo ~= nil then
    return true
  end
  if slotType == "1handed" and emptyOne then
    return true
  end
  return false
end
local IsTripleTooltip = function(tipInfos)
  local selfInfo = tipInfos[1]
  local mainHandInfo = tipInfos[2]
  local offHandInfo = tipInfos[3]
  local slotType = selfInfo.slotType
  if slotType == "1handed" and mainHandInfo ~= nil and offHandInfo ~= nil then
    return true
  end
  if slotType == "2handed" and mainHandInfo ~= nil and offHandInfo ~= nil then
    return true
  end
  return false
end
local function ShowMeleeWeaponAndShieldTooltip(tipInfo, stickTo)
  local slotType = tipInfo.slotType
  local tooltipWnd = tooltip.tooltipWindows
  local infos = {}
  infos[1] = tipInfo
  infos[2] = X2Equipment:GetEquippedItemTooltipInfo(ES_MAINHAND)
  infos[3] = X2Equipment:GetEquippedItemTooltipInfo(ES_OFFHAND)
  if infos[2] ~= nil then
    infos[2].equip = true
  end
  if infos[3] ~= nil then
    infos[3].equip = true
  end
  local isMainHandOnly = slotType == "2handed"
  local isOffHandOnly = slotType == "shield"
  local isOffHand = slotType == "1handed"
  local firstSlot = false
  local secondSlot = false
  local tooltipCount = 0
  if IsSingleTooltip(infos) then
    tooltipCount = 1
  elseif IsDoubleTooltip(infos) then
    tooltipCount = 2
    firstSlot = infos[2] ~= nil
    secondSlot = infos[3] ~= nil
    if isOffHandOnly and infos[3] ~= nil then
      firstSlot = false
      secondSlot = true
    end
    if firstSlot then
      MakeItemDiffInfo(infos[1], infos[2])
    elseif secondSlot then
      MakeItemDiffInfo(infos[1], infos[3])
    end
  elseif IsTripleTooltip(infos) then
    tooltipCount = 3
    MakeItemDiffInfo(infos[1], infos[2])
  end
  local index = 1
  for i = 1, 3 do
    if infos[i] ~= nil then
      FillTooltipInfo(infos[i], i)
    end
  end
  if tooltipCount == 1 then
    tooltipWnd[1]:ShowTooltip(true, stickTo, ONLY_BASE)
  elseif tooltipCount == 2 then
    if firstSlot then
      local combinedExtent = CalcCombinedExtent(tooltipWnd[1], tooltipWnd[2])
      tooltipWnd[1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
      tooltipWnd[2]:ShowTooltip(true, tooltipWnd[1], FIRST_COMPARE)
      ChangeTooltipTexture(tooltipWnd[2], "compare")
    elseif secondSlot then
      local combinedExtent = CalcCombinedExtent(tooltipWnd[1], tooltipWnd[3])
      tooltipWnd[1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
      tooltipWnd[3]:ShowTooltip(true, tooltipWnd[1], FIRST_COMPARE)
      ChangeTooltipTexture(tooltipWnd[3], "compare")
    end
  elseif tooltipCount == 3 then
    local combinedExtent = CalcCombinedExtent(tooltipWnd[1], tooltipWnd[2], tooltipWnd[3])
    tooltipWnd[1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
    ChangeTooltipTexture(tooltipWnd[2], "compare")
    ChangeTooltipTexture(tooltipWnd[3], "compare")
    tooltipWnd[2]:ShowTooltip(true, tooltipWnd[1], FIRST_COMPARE)
    tooltipWnd[3]:ShowTooltip(true, tooltipWnd[2], SECOND_COMPARE)
  end
end
local slotTable = {
  [ES_HEAD] = EST_HEAD,
  [ES_NECK] = EST_NECK,
  [ES_CHEST] = EST_CHEST,
  [ES_WAIST] = EST_WAIST,
  [ES_LEGS] = EST_LEGS,
  [ES_HANDS] = EST_HANDS,
  [ES_FEET] = EST_FEET,
  [ES_ARMS] = EST_ARMS,
  [ES_BACK] = EST_BACK,
  [ES_EAR_1] = EST_EAR,
  [ES_EAR_2] = EST_EAR,
  [ES_FINGER_1] = EST_FINGER,
  [ES_FINGER_2] = EST_FINGER,
  [ES_UNDERSHIRT] = EST_UNDERSHIRT,
  [ES_UNDERPANTS] = EST_UNDERPANTS,
  [ES_MAINHAND] = EST_MAINHAND,
  [ES_OFFHAND] = EST_OFFHAND,
  [ES_RANGED] = EST_RANGED,
  [ES_MUSICAL] = EST_INSTRUMENT,
  [ES_FACE] = EST_FACE,
  [ES_HAIR] = EST_HAIR,
  [ES_GLASSES] = EST_EYE_LEFT,
  [ES_HORNS] = EST_HORNS,
  [ES_TAIL] = EST_TAIL,
  [ES_BODY] = EST_BODY,
  [ES_BEARD] = EST_BEARD,
  [ES_BACKPACK] = EST_BACKPACK,
  [ES_COSPLAY] = EST_COSPLAY
}
local function IsCompatibleEquipSlot(equipSlotNum, slotTypeNum)
  if equipSlotNum <= ES_INVALID or equipSlotNum > ES_COSPLAY then
    return false
  end
  if slotTable[equipSlotNum] == slotTypeNum then
    return true
  else
    return false
  end
end
local function FindCompatibleEquipSlot(slotTypeNum)
  local compatibleSlots = {}
  local index = 1
  for i = 1, #slotTable do
    if IsCompatibleEquipSlot(i, slotTypeNum) then
      compatibleSlots[index] = i
      index = index + 1
    end
  end
  return compatibleSlots
end
local function ShowAwakenEnchantCompareTooltip(tipInfo, stickTo)
  local tooltipWnd = tooltip.tooltipWindows
  local targetInfo = X2ItemEnchant:GetTargetItemInfo()
  if targetInfo then
    MakeItemDiffInfo(tipInfo, targetInfo)
    FillTooltipInfo(tipInfo, 1)
    FillTooltipInfo(targetInfo, 2)
    ChangeTooltipTexture(tooltipWnd[1], "origin")
    ChangeTooltipTexture(tooltipWnd[2], "compare")
    local combinedExtent = CalcCombinedExtent(tooltipWnd[1], tooltipWnd[2])
    tooltipWnd[1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
    tooltipWnd[2]:ShowTooltip(true, tooltipWnd[1], FIRST_COMPARE)
  else
    FillTooltipInfo(tipInfo, 1)
    tooltipWnd[1]:ShowTooltip(true, stickTo, ONLY_BASE)
  end
end
local function ShowEtcNeedCompareTooltip(tipInfo, stickTo)
  local slotType = tipInfo.slotType
  local slotTypeNum = tipInfo.slotTypeNum
  local tooltipWnd = tooltip.tooltipWindows
  local equipInfos = {}
  local compatibleSlots = FindCompatibleEquipSlot(slotTypeNum)
  local index = 1
  local firstCompatibleSlot = true
  for i = 1, #compatibleSlots do
    local info = X2Equipment:GetEquippedItemTooltipInfo(compatibleSlots[i])
    if info ~= nil then
      if firstCompatibleSlot == true then
        MakeItemDiffInfo(tipInfo, info)
        firstCompatibleSlot = false
      end
      info.equip = true
      equipInfos[index] = info
      index = index + 1
    end
  end
  FillTooltipInfo(tipInfo, 1)
  if #equipInfos == 0 then
    tooltipWnd[1]:ShowTooltip(true, stickTo, ONLY_BASE)
    return
  end
  FillTooltipInfo(equipInfos[1], 2)
  ChangeTooltipTexture(tooltipWnd[1], "origin")
  ChangeTooltipTexture(tooltipWnd[2], "compare")
  if #equipInfos == 1 then
    local combinedExtent = CalcCombinedExtent(tooltipWnd[1], tooltipWnd[2])
    tooltipWnd[1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
    tooltipWnd[2]:ShowTooltip(true, tooltipWnd[1], FIRST_COMPARE)
    return
  end
  FillTooltipInfo(equipInfos[2], 3)
  if #equipInfos == 2 then
    local combinedExtent = CalcCombinedExtent(tooltipWnd[1], tooltipWnd[2], tooltipWnd[2])
    tooltipWnd[1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
    tooltipWnd[2]:ShowTooltip(true, tooltipWnd[1], FIRST_COMPARE)
    tooltipWnd[3]:ShowTooltip(true, tooltipWnd[2], SECOND_COMPARE)
  end
end
local function ShowUccViewerTooltip(tipInfo, stickTo, tipNum)
  local tooltipWnd = tooltip.tooltipWindows
  FillTooltipInfo(tipInfo, tipNum)
  ChangeTooltipTexture(tooltipWnd[tipNum], "origin")
  local uccViewerTooltipNum = 2
  local group = tooltipGroups[TOOLTIP_KIND.ITEM_LINK]
  for i = 1, #group do
    if group[i] == tipNum then
      uccViewerTooltipNum = 9
      break
    end
  end
  FillTooltipInfo(tipInfo, uccViewerTooltipNum)
  ChangeTooltipTexture(tooltipWnd[uccViewerTooltipNum], "origin")
  local combinedExtent = CalcCombinedExtent(tooltipWnd[tipNum], tooltipWnd[uccViewerTooltipNum])
  tooltipWnd[tipNum]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
  tooltipWnd[uccViewerTooltipNum]:ShowTooltip(true, tooltipWnd[tipNum], FIRST_COMPARE)
end
function PrepareTooltip(tipInfo, tipNum, equipped)
  local impl = tipInfo.item_impl
  tooltip.tooltipWindows[tipNum].minWindowWidth = 250
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTitles[tipNum])
  if HasGearScoreSecitonData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.gearScore[tipNum])
  end
  if tipInfo.securityState == ITEM_SECURITY_LOCKED or tipInfo.securityState == ITEM_SECURITY_UNLOCKING then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.securityState[tipNum])
  end
  if impl == "weapon" or impl == "armor" or impl == "mate_armor" or impl == "accessory" then
    tipInfo.equip = equipped
    if HasItemLookData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemLookState[tipNum])
    end
    if HasItemTimeInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTimeInfos[tipNum])
    end
    if HasItemEvolvingExpData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemEvolvingExpInfos[tipNum])
    end
    if HasItemInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
    end
    if HasAttrSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.attrInfos[tipNum])
    end
    if tipInfo.socketInfo ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemSocketInfos[tipNum])
    end
    if HasItemInfosExSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfosEx[tipNum])
    end
    if HasExtraAttr(tipInfo.modifier) == true then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.options[tipNum])
    end
    if HasDescriptionSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
    end
    if tipInfo.equipSetInfo then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.setItemsInfo[tipNum])
    end
    if HasEtcSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.etcItemsInfo[tipNum])
    end
    if HasCrafterSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.crafterInfo[tipNum])
    end
    if not IsSpecialtyBackPack(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.sellables[tipNum])
    end
  elseif impl == "enchanting_gem" or impl == "socket" then
    if HasItemTimeInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTimeInfos[tipNum])
    end
    if HasItemEvolvingExpData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemEvolvingExpInfos[tipNum])
    end
    if HasItemInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
    end
    if HasAttrSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.attrInfos[tipNum])
    end
    if HasDescriptionSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
    end
    if tipInfo.equipSetInfo then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.setItemsInfo[tipNum])
    end
    if HasEtcSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.etcItemsInfo[tipNum])
    end
    if HasCrafterSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.crafterInfo[tipNum])
    end
    if not IsSpecialtyBackPack(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.sellables[tipNum])
    end
  elseif impl == "portal" or impl == "summon_slave" or impl == "summon_mate" then
    if HasItemLookData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemLookState[tipNum])
    end
    if HasItemTimeInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTimeInfos[tipNum])
    end
    if HasItemInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
    end
    if impl == "portal" then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.portalInfos[tipNum])
    elseif impl == "report_crime" and tipInfo.attacker ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.crimeInfo[tipNum])
    end
    if HasDescriptionSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
    end
    if HasEtcSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.etcItemsInfo[tipNum])
    end
    if not IsSpecialtyBackPack(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.sellables[tipNum])
    end
    if (impl == "summon_slave" or impl == "summon_mate") and tipInfo.dead == true then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.mountInfo[tipNum])
    end
  elseif impl == "slave_equipment" then
    if HasItemTimeInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTimeInfos[tipNum])
    end
    if HasItemEvolvingExpData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemEvolvingExpInfos[tipNum])
    end
    if HasDescriptionSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
    end
    if HasEtcSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.etcItemsInfo[tipNum])
    end
    if tipInfo.dead == true then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.mountInfo[tipNum])
    end
    if not IsSpecialtyBackPack(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.sellables[tipNum])
    end
  else
    if impl == "backpack" then
      tipInfo.equip = equipped
    end
    if tipInfo.userMusicTitle ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.userMusicInfos[tipNum])
    end
    if tipInfo.longitudeDir ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.treasureInfos[tipNum])
    end
    if HasItemTimeInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTimeInfos[tipNum])
    end
    if HasItemEvolvingExpData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemEvolvingExpInfos[tipNum])
    end
    if HasItemInfosSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
    end
    if HasSpecialtySectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.specialty[tipNum])
    end
    if HasDescriptionSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
    end
    if HasEtcSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.etcItemsInfo[tipNum])
    end
    if HasCrafterSectionData(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.crafterInfo[tipNum])
    end
    if tipInfo.location_zone_name ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.locationInfos[tipNum])
    end
    if tipInfo.craftOrder ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.craftOrderInfo[tipNum])
    end
    if not IsSpecialtyBackPack(tipInfo) then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.sellables[tipNum])
    end
  end
  if tipNum == 2 or tipNum == 3 then
    tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo, true)
  else
    tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo)
  end
end
function ShowSingleTooltip(stickTo, tipNum, stickType)
  if tipNum ~= 1 then
    tooltip.tooltipWindows[tipNum]:ShowTooltip(true, stickTo, tipNum)
  else
    tooltip.tooltipWindows[1]:ShowTooltip(true, stickTo, stickType)
  end
end
local function ShowItemTooltip(tipInfo, stickTo, tipNum, equipped, stickType)
  if tipInfo.itemType == 500 then
    return
  end
  if X2Debug:GetDevMode() then
    DebugTooltipInfo(tipInfo)
  end
  if equipped == nil then
    equipped = false
  end
  if stickType == nil then
    stickType = ONLY_BASE
  end
  local impl = tipInfo.item_impl
  tipNum = tipNum or 1
  if tipInfo.itemChangeMappingType ~= nil and tipInfo.itemChangeMappingType ~= 0 then
    ShowAwakenEnchantCompareTooltip(tipInfo, stickTo)
    return
  elseif equipped == false and tipInfo.isPetOnly == false then
    tipInfo.equip = equipped
    local slotType = tipInfo.slotType
    if slotType == "1handed" or slotType == "2handed" or slotType == "shield" then
      ShowMeleeWeaponAndShieldTooltip(tipInfo, stickTo, equipped)
      return
    end
    local slotTypeNum = tipInfo.slotTypeNum
    if slotTypeNum ~= nil then
      local compatibles = FindCompatibleEquipSlot(slotTypeNum)
      if compatibles ~= nil and #compatibles > 0 then
        ShowEtcNeedCompareTooltip(tipInfo, stickTo, equipped)
        return
      end
    end
  end
  if HasUcc(tipInfo) then
    ShowUccViewerTooltip(tipInfo, stickTo, tipNum)
    return
  end
  PrepareTooltip(tipInfo, tipNum, equipped)
  ShowSingleTooltip(stickTo, tipNum, stickType)
end
local IsSingleSpellTooltip = function(tipInfo, equipped)
  local lenLevel = tipInfo.nextLearnLevel or tipInfo.firstLearnLevel or tipInfo.passive_buff_learn_level or tipInfo.firstStartHeirLevel
  local myLevel = X2Unit:UnitLevel("player")
  if equipped == nil or equipped == true then
    return true
  elseif tipInfo.nextSkill == nil then
    return true
  elseif lenLevel > myLevel then
    return true
  end
  return false
end
local IsNeedSkillDescSection = function(tipInfo)
  if tipInfo.description ~= nil then
    return true
  end
  return false
end
local IsNeedSkillBodySection = function(tipInfo)
  if tipInfo.nextSkill ~= nil then
    return true
  end
  if tipInfo.firstLearnLevel ~= nil and locale.common.abilityNameWithStr(tipInfo.ability) ~= locale.common.abilityNameWithStr("general") and tipInfo.firstLearnLevel > tipInfo.abilityLevel then
    return true
  end
  if tipInfo.displayPetSkillLearnLevel ~= nil then
    return true
  end
  if tipInfo.firstStartHeirLevel ~= nil then
    return true
  end
  if tipInfo.activeType ~= nil and tipInfo.activeTypeDesc ~= nil then
    return true
  end
  if tipInfo.learn ~= "master" then
    if tipInfo.passive_buff_learn_level == nil then
      if tipInfo.skillPoints ~= nil and tipInfo.skillPoints > 0 and locale.common.abilityNameWithStr(tipInfo.ability) ~= locale.common.abilityNameWithStr("general") then
        return true
      end
    elseif tipInfo.passive_buff_learn_level > 0 then
      return true
    end
  end
  return false
end
local function ShowSpellTooltip(tipInfo, stickTo, tipNum, equipped, stickType)
  local category = tipInfo.category
  tooltip.tooltipWindows[tipNum].minWindowWidth = 300
  tooltip.tooltipWindows[tipNum].tipType = tipInfo.tipType
  tooltip.tooltipWindows[tipNum].skillInfo = tipInfo
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillTitles[tipNum])
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillSimpleInfo[tipNum])
  if tooltipLocale.forclyUseLeftSection then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillTimeInfo[tipNum])
    if tipInfo.synergyicon1 ~= nil or tipInfo.synergyicon2 ~= nil then
      tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillEffectInfo[tipNum])
    end
  end
  if IsNeedSkillDescSection(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillDescs[tipNum])
  end
  if tipInfo.synergyIconInfo ~= nil and X2Option:GetOptionItemValue(OPTION_ITEM_SKILL_SYNERGY_INFO_SHOW_TOOLTIP) == 1 then
    tooltip.skillSynergyInfos[tipNum]:DynamicPushSection(tooltip.tooltipWindows[tipNum], #tipInfo.synergyIconInfo)
  end
  if tipInfo.showReq == true and IsNeedSkillBodySection(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillBodys[tipNum])
  end
  tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo)
  if IsSingleSpellTooltip(tipInfo, equipped) then
    tooltip.tooltipWindows[tipNum]:ShowTooltip(true, stickTo, stickType)
    return
  end
  local nextInfo = tipInfo.nextSkill
  if nextInfo == nil then
    return
  end
  tipInfo = nextInfo
  tipNum = 6
  tooltip.tooltipWindows[tipNum]:ClearSection()
  tooltip.tooltipWindows[tipNum].bg:SetColor(1, 1, 1, 1)
  tooltip.tooltipWindows[tipNum].minWindowWidth = 300
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillTitles[tipNum])
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillSimpleInfo[tipNum])
  if IsNeedSkillDescSection(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillDescs[tipNum])
  end
  if tipInfo.synergyIconInfo ~= nil and X2Option:GetOptionItemValue(OPTION_ITEM_SKILL_SYNERGY_INFO_SHOW_TOOLTIP) == 1 then
    tooltip.skillSynergyInfos[tipNum]:DynamicPushSection(tooltip.tooltipWindows[tipNum], #tipInfo.synergyIconInfo)
  end
  if tipInfo.nextSkill ~= nil or tipInfo.firstLearnLevel ~= nil then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillBodys[tipNum])
  end
  tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo)
  local combinedExtent = CalcCombinedExtent(tooltip.tooltipWindows[tipNum - 1], tooltip.tooltipWindows[tipNum])
  tooltip.tooltipWindows[tipNum - 1]:ShowTooltip(true, stickTo, BASE_WITH_COMPARE_EXTENT, combinedExtent)
  ChangeTooltipTexture(tooltip.tooltipWindows[tipNum], "compare")
  tooltip.tooltipWindows[tipNum]:ShowTooltip(true, tooltip.tooltipWindows[tipNum - 1], FIRST_COMPARE)
end
local function ShowBuffTooltip(tipInfo, stickTo, tipNum, equipped, stickType)
  tooltip.tooltipWindows[tipNum].minWindowWidth = 250
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTitles[tipNum])
  if HasItemInfosSectionData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
  end
  if tipInfo.description ~= nil and tipInfo.description ~= "" then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
  end
  if tipInfo.stack ~= nil and tipInfo.timeLeft ~= nil and tipInfo.timeLeft ~= 0 then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.buffInfos[tipNum])
  end
  if IsNeedSkillBodySection(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.skillBodys[tipNum])
  end
  tooltip.tooltipWindows[tipNum].tipType = tipInfo.tipType
  tooltip.tooltipWindows[tipNum].buffInfo = tipInfo
  tooltip.tooltipWindows[tipNum].bufTarget = stickTo
  tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo)
  tooltip.tooltipWindows[tipNum]:ShowTooltip(true, stickTo, stickType)
end
local function ShowStampTooltip(tipInfo, stickTo, tipNum, stickType)
  tooltip.tooltipWindows[tipNum].minWindowWidth = 250
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTitles[tipNum])
  if HasItemInfosSectionData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
  end
  if HasDescriptionSectionData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
  end
  if HasEffectDescriptionSectionData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.effectDescriptions[tipNum])
  end
  tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo)
  tooltip.tooltipWindows[1]:ShowTooltip(true, stickTo, stickType)
end
local function ShowOtherTooltip(tipInfo, stickTo, tipNum, equipped, stickType)
  tooltip.tooltipWindows[tipNum].minWindowWidth = 250
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemTitles[tipNum])
  if HasItemInfosSectionData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.itemInfos[tipNum])
  end
  if HasDescriptionSectionData(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.descriptions[tipNum])
  end
  if not IsSpecialtyBackPack(tipInfo) then
    tooltip.tooltipWindows[tipNum]:PushSection(tooltip.sellables[tipNum])
  end
  tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo)
  tooltip.tooltipWindows[tipNum]:ShowTooltip(true, stickTo, stickType)
end
function SetTooltipDelayTime(delayTime)
  local groups = {
    tooltipGroups[TOOLTIP_KIND.ITEM],
    tooltipGroups[TOOLTIP_KIND.SKILL],
    tooltipGroups[TOOLTIP_KIND.BUFF]
  }
  for i = 1, #groups do
    for j = 1, #groups[i] do
      if tooltip.tooltipWindows[groups[i][j]] ~= nil then
        tooltip.tooltipWindows[groups[i][j]]:SetDelayTime(delayTime)
      end
    end
  end
end
function ShowTooltip(tipInfo, stickTo, tipNum, equipped, stickType)
  if tipInfo == nil then
    return
  end
  if tipInfo.name == "invalid item type" then
    return
  end
  if tipNum == nil then
    tipNum = 1
  end
  tooltip.tooltipWindows[tipNum]:ClearSection()
  tooltip.tooltipWindows[tipNum].bg:SetColor(1, 1, 1, 1)
  tooltip.tooltipWindows[1].tipType = nil
  if tipInfo.item_impl ~= nil then
    ShowItemTooltip(tipInfo, stickTo, tipNum, equipped, stickType)
  else
    local category = tipInfo.category
    local tipType = tipInfo.tipType
    if tipType == "skill" or tipType == "mate_skill" or tipType == "siege_weapon_skill" then
      tipNum = 5
      tooltip.tooltipWindows[tipNum]:ClearSection()
      tooltip.tooltipWindows[tipNum].bg:SetColor(1, 1, 1, 1)
      tooltip.tooltipWindows[tipNum].tipType = nil
      ShowSpellTooltip(tipInfo, stickTo, tipNum, equipped, ONLY_BASE)
    elseif tipType == "buff" or tipType == "debuff" or tipType == "passive" then
      tipNum = 7
      tooltip.tooltipWindows[tipNum]:ClearSection()
      tooltip.tooltipWindows[tipNum].bg:SetColor(1, 1, 1, 1)
      tooltip.tooltipWindows[tipNum].tipType = nil
      ShowBuffTooltip(tipInfo, stickTo, tipNum, equipped, ONLY_BASE)
    elseif tipType == "appStamp" then
      ShowStampTooltip(tipInfo, stickTo, 1, ONLY_BASE)
    else
      ShowOtherTooltip(tipInfo, stickTo, 1, equipped, ONLY_BASE)
    end
  end
end
function ShowItemLinkTooltip(tipInfo)
  local equipped = false
  local stickType = ONLY_BASE
  local tipNum = 4
  local stickTo
  if tipInfo == nil then
    return
  end
  if tipInfo.name == "invalid item type" then
    return
  end
  tooltip.tooltipWindows[tipNum]:ClearSection()
  if tipInfo.linkKind == nil then
    ChangeTooltipTexture(tooltip.tooltipWindows[tipNum], "origin")
  elseif tipInfo.linkKind == "auction" or tipInfo.linkKind == "coffer" then
    ChangeTooltipTexture(tooltip.tooltipWindows[tipNum], "linked")
  end
  if tipInfo.item_impl ~= nil then
    if HasUcc(tipInfo) then
      ShowUccViewerTooltip(tipInfo, stickTo, tipNum)
      return
    end
    if tooltip.tooltipWindows[tipNum].HideCompareTooltip ~= nil then
      tooltip.tooltipWindows[tipNum]:HideCompareTooltip()
    end
    PrepareTooltip(tipInfo, tipNum, equipped)
    ShowSingleTooltip(stickTo, tipNum, stickType)
  end
end
function ShowQuestLinkTooltip(tipInfo)
  local tipNum = 8
  tooltip.tooltipWindows[tipNum]:ClearSection()
  tooltip.tooltipWindows[tipNum].minWindowWidth = 250
  tooltip.tooltipWindows[tipNum]:PushSection(tooltip.questBody[tipNum])
  tooltip.tooltipWindows[tipNum]:SetInfo(tipInfo.questType)
  ShowSingleTooltip(nil, tipNum, ONLY_BASE)
end
function TooltipRaise()
  for i = 1, #tooltip.tooltipWindows do
    if tooltip.tooltipWindows[i] ~= nil then
      tooltip.tooltipWindows[i]:Raise()
    end
  end
end
local targetEvent = {
  TARGET_OVER = function(arg, arg2)
    if arg == "nothing" or arg == "ui" then
      HideFixedTooltip()
    elseif arg == "unit" then
      local unitInfo = X2Unit:GetUnitInfoById(arg2)
      if unitInfo == nil then
        return
      end
      FillFixedTooltipInfo_Unit(unitInfo, fixedTooltip)
      ShowFixedTooltip("unit")
      fixedTooltip:Show(true)
    end
  end
}
fixedTooltip:SetHandler("OnEvent", function(this, event, ...)
  targetEvent[event](...)
end)
fixedTooltip:RegisterEvent("TARGET_OVER")
function UpdateFixedTooltipAnchor()
  fixedTooltip:RemoveAllAnchors()
  fixedTooltip:AddAnchor("BOTTOMRIGHT", "UIParent", -20, -40)
end
function UpdateFixedTooltipDynamicAnchor()
  local mouseX, mouseY = X2Input:GetMousePos()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local width, height = fixedTooltip:GetEffectiveExtent()
  local vertOver = screenHeight <= mouseY + height
  local horzOver = screenWidth <= mouseX + width
  mouseX = F_LAYOUT.CalcDontApplyUIScale(mouseX)
  mouseY = F_LAYOUT.CalcDontApplyUIScale(mouseY)
  fixedTooltip:RemoveAllAnchors()
  if vertOver and horzOver then
    fixedTooltip:AddAnchor("BOTTOMRIGHT", "UIParent", "TOPLEFT", mouseX, mouseY)
  elseif horzOver then
    fixedTooltip:AddAnchor("TOPRIGHT", "UIParent", "TOPLEFT", mouseX, mouseY + 20)
  elseif vertOver then
    fixedTooltip:AddAnchor("BOTTOMLEFT", "UIParent", "TOPLEFT", mouseX, mouseY)
  else
    fixedTooltip:AddAnchor("TOPLEFT", "UIParent", mouseX + 30, mouseY + 20)
  end
end
function ClearFixedTooltip()
  fixedTooltip:ClearLines()
end
function HideFixedTooltip()
  fixedTooltip:Show(false)
end
function ShowFixedTooltip(unitType)
  if unitType == "doodad" then
    fixedTooltip:DoodadAnchorFunc()
  else
    UpdateFixedTooltipAnchor()
  end
  fixedTooltip:Show(true)
end
function FillFixedTooltipInfo_Unit(info, tooltip)
  local unitType = tostring(info.type)
  ClearFixedTooltip()
  local width = 50
  local height = 100
  if unitType == "character" then
    width, height = FillCharacterInfo(info, tooltip)
  elseif unitType == "npc" and info.is_portal then
    width, height = FillPortalInfo(info, tooltip)
  elseif unitType == "npc" then
    width, height = FillNpcInfo(info, tooltip)
  elseif unitType == "slave" then
    width, height = FillSlaveInfo(info, tooltip)
  elseif unitType == "housing" then
    width, height = FillHousingInfo(info, tooltip)
  elseif unitType == "transfer" then
    width, height = FilltransferInfo(info, tooltip)
  elseif unitType == "mate" then
    width, height = FillMateInfo(info, tooltip)
  elseif unitType == "shipyard" then
    width, height = FillShipyardInfo(info, tooltip)
  end
end
function FillFixedTooltipLine(texts, tooltip, colors)
  local width, maxWidth, height = 0, 0, 0
  local size = table.getn(texts)
  if colors == nil then
    colors = {}
  end
  for i = 1, size do
    local color = colors[i] or FONT_COLOR_HEX.SOFT_BROWN
    tooltip:AddLine(color .. texts[i], "", 0, "left", ALIGN_CENTER, 0)
  end
  return maxWidth, height
end
function FillCharacterInfo(info, tooltip)
  local guild = info.expeditionName or "none"
  local level = info.level or 0
  local heirLevel = info.heirLevel or 0
  local name = info.name or "none"
  local social = info.social or "none"
  local faction = info.faction or "none"
  local abil = info.class
  local class = "none"
  local family_owner = info.family_owner
  local family_title = info.family_title
  local family_role = info.family_role
  local family_name = info.family_name
  if abil["1"] ~= nil and abil["2"] ~= nil and abil["3"] ~= nil then
    local i, j, k = abil["1"], abil["2"], abil["3"]
    class = F_UNIT.GetCombinedAbilityName(i, j, k)
  end
  local color = ColorFromFactionAndSocial_Pc(faction, social)
  local texts = {}
  local colors = {}
  local index = 1
  if heirLevel > 0 then
    texts[index] = string.format("%s %s %s", GetCommonText("heir"), X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(heirLevel)), name)
  else
    texts[index] = string.format("%s %s", X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(level)), name)
  end
  colors[index] = color
  index = index + 1
  if guild ~= "none" then
    texts[index] = string.format("<%s>", guild)
    colors[index] = color
    index = index + 1
  end
  if family_name ~= nil and 0 < string.len(family_name) then
    texts[index] = string.format("(%s)", family_name)
    colors[index] = color
    index = index + 1
  elseif family_owner then
    if family_role == 1 then
      local title = family_title
      if title == "" then
        title = locale.family.family_leader
      end
      texts[index] = string.format("(%s)", locale.family.owner_title(family_owner, title))
      colors[index] = color
      index = index + 1
    else
      texts[index] = string.format("(%s)", locale.family.tooltip_text(family_owner, family_title))
      colors[index] = color
      index = index + 1
    end
  end
  texts[index] = string.format("%s (%s)", class, locale.tooltip.player)
  index = index + 1
  return FillFixedTooltipLine(texts, tooltip, colors)
end
function NpcKindToText(kind)
  if kind == nil then
    return "none"
  end
  local kindText = locale.kindName[kind]
  if kindText == nil then
    kindText = kind
  end
  return kindText
end
function NpcGradeToText(grade)
  if grade == nil then
    return "none"
  end
  local gradeText = locale.gradeName[grade]
  if gradeText == nil then
    gradeText = grade
  end
  return gradeText
end
function FillNpcInfo(info, tooltip)
  local level = info.level or 0
  local heirLevel = info.heirLevel or 0
  local name = info.name or "none"
  local grade = info.grade or 0
  local kind = info.kind or 0
  local faction = info.faction
  local social = info.social
  local texts = {}
  local colors = {}
  local color = ColorFromFactionAndSocial_Npc(faction, social)
  local nickName = info.nick_name or "none"
  local index = 1
  if nickName ~= "none" then
    texts[index] = string.format("[%s]", nickName)
    colors[index] = color
    index = index + 1
  end
  if heirLevel > 0 then
    texts[index] = string.format("%s %s %s", GetCommonText("heir"), X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(heirLevel)), name)
  else
    texts[index] = string.format("%s %s", X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(level)), name)
  end
  colors[index] = color
  index = index + 1
  texts[index] = string.format("%s / %s", NpcGradeToText(grade), NpcKindToText(kind))
  index = index + 1
  return FillFixedTooltipLine(texts, tooltip, colors)
end
function FillPortalInfo(info, tooltip)
  local name = info.name or "none"
  local owner = info.portal_owner or "none"
  local faction = info.faction
  local social = info.social
  local color = ColorFromFactionAndSocial_Npc(faction, social)
  local colors = {}
  local texts = {}
  local index = 1
  if owner ~= "none" then
    texts[index] = string.format("[%s]", owner)
    colors[index] = color
    index = index + 1
  end
  texts[index] = info.name
  colors[index] = color
  index = index + 1
  return FillFixedTooltipLine(texts, tooltip, colors)
end
function FillSlaveInfo(info, tooltip)
  local ownerName = info.owner_name or "none"
  local name = info.name or "none"
  local hp = info.hp or 0
  local maxHp = info.max_hp or 0
  local faction = info.faction or "none"
  local social = info.social or "none"
  local texts = {}
  local colors = {}
  local color = ColorFromFactionAndSocial_Npc(faction, social)
  local index = 1
  if ownerName ~= "none" then
    texts[index] = string.format("[%s]", ownerName)
    colors[index] = color
    index = index + 1
  end
  texts[index] = string.format("%s", name)
  colors[index] = color
  return FillFixedTooltipLine(texts, tooltip, colors)
end
function FillHousingInfo(info, tooltip)
  local ownerName = info.owner_name or "none"
  local name = info.name or "none"
  local buildingState = info.building_state or "done"
  local houseCategory = info.house_category or "none"
  local hp = info.hp or 0
  local maxHp = info.max_hp or 0
  local remineProgress = info.remain_progress or 1
  local baseProgress = info.base_progress or 1
  local percent = math.floor((baseProgress - remineProgress) / baseProgress * 100)
  local faction = info.faction or "none"
  local social = info.social or "none"
  local texts = {}
  local colors = {}
  local color = ColorFromFactionAndSocial_Npc(faction, social)
  if buildingState == "done" then
    texts[1] = string.format("[%s]", ownerName)
    colors[1] = color
    texts[2] = string.format("%s", name)
    colors[2] = color
  else
    texts[1] = string.format("[%s]", ownerName)
    colors[1] = color
    texts[2] = string.format("%s (%d%%)", name, percent)
    colors[2] = color
  end
  return FillFixedTooltipLine(texts, tooltip, colors)
end
function FillShipyardInfo(info, tooltip)
  local name = info.name
  local ownerName = info.owner_name
  local holderName = info.holder_name
  local remain_progress = info.remain_progress
  local total_actions = info.total_actions
  local progress = (total_actions - remain_progress) / total_actions
  local faction = info.faction or "none"
  local social = info.social or "none"
  local texts = {}
  local colors = {}
  local color = ColorFromFactionAndSocial_Npc(faction, social)
  if ownerName == nil or ownerName == "none" or ownerName == "" then
    texts[1] = string.format("%s (%d%%)", name, progress * 100)
    colors[1] = color
  else
    texts[1] = string.format("[%s]", ownerName)
    colors[1] = color
    texts[2] = string.format("%s (%d%%)", name, progress * 100)
    colors[2] = color
  end
  return FillFixedTooltipLine(texts, tooltip, colors)
end
function FilltransferInfo(info, tooltip)
  local name = info.name or "none"
  local path = info.path
  local pathString = ""
  local texts = {}
  texts[1] = string.format("%s", name)
  return FillFixedTooltipLine(texts, tooltip)
end
function FillMateInfo(info, tooltip)
  local ownerName = info.owner_name or "none"
  local npcName = info.mate_npc_name or "none"
  local level = info.level or 0
  local heirLevel = info.heirLevel or 0
  local texts = {}
  local index = 1
  if ownderName ~= "none" then
    texts[index] = string.format("[%s]", ownerName)
    index = index + 1
  end
  if heirLevel > 0 then
    texts[index] = string.format("%s %s %s", GetCommonText("heir"), X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(heirLevel)), npcName)
  else
    texts[index] = string.format("%s %s", X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(level)), npcName)
  end
  return FillFixedTooltipLine(texts, tooltip)
end
function ShowSummaryTooltip(text, anchorTarget, myAnchor, targetAnchor)
  if text == nil then
    return
  end
  local msg = X2Util:ApplyUIMacroString(text)
  summaryTooltip:ClearLines()
  summaryTooltip:AddLine(msg, "", 0, "left", ALIGN_LEFT, 0)
  summaryTooltip:RemoveAllAnchors()
  summaryTooltip:AddAnchor(myAnchor, anchorTarget, targetAnchor, 0, 0)
  summaryTooltip:Show(true)
end
function HideSummaryTooltip()
  summaryTooltip:Show(false)
end
function ShowHotKeyOverrideTooltip(text, stickTo, sideAnchor, withoutTopBottom)
  if text == nil then
    return
  end
  local width = hotKeyOverrideTooltip.width
  local gameTooltip = hotKeyOverrideTooltip.text
  local window = hotKeyOverrideTooltip.window
  window:SetWidth(width + 3)
  gameTooltip:ClearLines()
  gameTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
  local _, height = gameTooltip:GetExtent()
  window:SetHeight(height + 10)
  window:RemoveAllAnchors()
  SetTooltipWindow(window, stickTo, sideAnchor, withoutTopBottom)
  window:Show(true)
  window.leftTime = 2000
  function window:OnUpdate(dt)
    self.leftTime = self.leftTime - dt
    if self.leftTime <= 0 then
      self:Show(false, 500)
      self:ReleaseHandler("OnUpdate")
    end
  end
  window:SetHandler("OnUpdate", window.OnUpdate)
end
function HideHotKeyOverrideTooltip()
  hotKeyOverrideTooltip.window:ReleaseHandler("OnUpdate")
  hotKeyOverrideTooltip.window:Show(false)
end
function ShowUnitFrameTooltip(targetUnit, tooltipText, gradeText, extentTarget, anchorTarget)
  if unitFrameTooltip == nil then
    return
  end
  if tooltipText == nil then
    HideUnitFrameTooltip()
    return
  end
  if targetUnit == nil then
    HideUnitFrameTooltip()
    return
  end
  if gradeText == nil then
    gradeText = ""
  end
  unitFrameTooltip:SetTooltipData(targetUnit)
  unitFrameTooltip:ClearLines()
  unitFrameTooltip:SetAutoWordwrap(false)
  local index = unitFrameTooltip:AddLine(tooltipText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  unitFrameTooltip:SetAutoWordwrap(true)
  unitFrameTooltip:AddAnotherSideLine(index, gradeText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local tipWidth, tipHeight = unitFrameTooltip:GetExtent()
  unitFrameTooltip:SetWidth(tipWidth + 5)
  local x, y = extentTarget:GetOffset()
  local width, height = extentTarget:GetExtent()
  local myAnchor = "TOPLEFT"
  local targetAnchor = "TOPRIGHT"
  local offsetX = 5
  local offsetY = -3
  if tipHeight > screenHeight - y then
    myAnchor = "BOTTOMLEFT"
    targetAnchor = "TOPRIGHT"
    offsetY = -offsetY
    if tipWidth > screenWidth - x - width then
      myAnchor = "BOTTOMRIGHT"
      targetAnchor = "TOPLEFT"
      offsetX = -offsetX
    end
  elseif tipWidth > screenWidth - x - width then
    myAnchor = "TOPRIGHT"
    targetAnchor = "TOPLEFT"
    offsetX = -offsetX
  end
  unitFrameTooltip:RemoveAllAnchors()
  unitFrameTooltip:AddAnchor(myAnchor, anchorTarget, targetAnchor, offsetX, offsetY)
  unitFrameTooltip:Show(true)
end
function ShowUnitFrameTooltipCursor(eventWidget, tooltipText)
  if unitFrameTooltip == nil or tooltipText == nil then
    return
  end
  unitFrameTooltip:SetTooltipData("")
  unitFrameTooltip:ClearLines()
  unitFrameTooltip:SetAutoWordwrap(false)
  local index = unitFrameTooltip:AddLine(tooltipText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  unitFrameTooltip:SetAutoWordwrap(true)
  unitFrameTooltip:AddAnotherSideLine(index, "", FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
  unitFrameTooltip:RemoveAllAnchors()
  local mouseX, mouseY = X2Input:GetMousePos()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local width, height = unitFrameTooltip:GetEffectiveExtent()
  local vertOver = screenHeight <= mouseY + height
  local horzOver = screenWidth <= mouseX + width
  local x = F_LAYOUT.CalcDontApplyUIScale(mouseX) + 30
  local y = F_LAYOUT.CalcDontApplyUIScale(mouseY) + 30
  if vertOver and horzOver then
    unitFrameTooltip:AddAnchor("BOTTOMRIGHT", "UIParent", "TOPLEFT", x, y)
  elseif horzOver then
    unitFrameTooltip:AddAnchor("TOPRIGHT", "UIParent", "TOPLEFT", x, y)
  elseif vertOver then
    unitFrameTooltip:AddAnchor("BOTTOMLEFT", "UIParent", "TOPLEFT", x, y)
  else
    unitFrameTooltip:AddAnchor("TOPLEFT", "UIParent", x, y)
  end
  unitFrameTooltip:Show(true)
end
function HideUnitFrameTooltip()
  if unitFrameTooltip ~= nil then
    unitFrameTooltip:Show(false)
  end
end
function RaiseUnitFrameTooltip()
  unitFrameTooltip:Raise()
end
function HideMapTooltip()
  mapTooltip:ClearLines()
  mapTooltip:Show(false)
  mapTooltip.line:SetVisible(false)
  mapTooltip.hpBar:Show(false)
  mapTooltip:ReleaseHandler("OnUpdate")
end
local GetLongestWidth = function(width, targetStr)
  local targetWidth = mapTooltip.style:GetTextWidth(targetStr)
  return width < targetWidth and targetWidth or width
end
function ShowMapTooltip(tooltipTable, tooltipCount, target, offsetX, offsetY, reverseX, reverseY)
  if tooltipTable == nil then
    HideMapTooltip()
    return
  end
  mapTooltip:ClearLines()
  mapTooltip.line:SetVisible(false)
  mapTooltip.hpBar:Show(false)
  SetTooltipDefaultHeight(mapTooltip)
  mapTooltip.targetId = nil
  for i = 1, tooltipCount do
    do
      local strWidth = 0
      local tooltipInfo = tooltipTable[i]
      if tooltipInfo.tooltipType == "normal" then
        local text = tooltipInfo.text
        mapTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, text)
      elseif tooltipInfo.tooltipType == "carrying_backpack_slave" then
        local text = GetCommonText("carrying_backpack_slave")
        mapTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, text)
      elseif tooltipInfo.tooltipType == "corpse" then
        local text = GetUIText(MAP_TEXT, "M_CORPSE_POS")
        mapTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, text)
      elseif tooltipInfo.tooltipType == "common_farm" then
        local text = GetUIText(MAP_TEXT, "M_COMMON_FARM")
        mapTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, text)
      elseif tooltipInfo.tooltipType == "slave" and tooltipInfo.kind == "sea_gimic" then
        local text = X2Util:UTF8StringLimit(tostring(tooltipInfo.name), 12, "...")
        mapTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, text)
      elseif tooltipInfo.tooltipType == "slave" or tooltipInfo.tooltipType == "shipyard" then
        mapTooltip:SetExtent(250, 20)
        mapTooltip:SetAutoWordwrap(true)
        mapTooltip.targetId = tooltipInfo.id
        local lastIndex = 0
        if tooltipInfo.name ~= nil then
          local name = X2Util:UTF8StringLimit(tostring(tooltipInfo.name), 12, "...")
          if tooltipInfo.enemy then
            name = FONT_COLOR_HEX.RED .. name
          end
          lastIndex = mapTooltip:AddLine(name, FONT_PATH.DEFAULT, 13, "left", ALIGN_LEFT, 0)
          if tooltipInfo.tooltipType == "slave" and tooltipInfo.kind ~= nil then
            mapTooltip:AddAnotherSideLine(lastIndex, locale.map.slaveKind(tooltipInfo.kind), "", 0, ALIGN_RIGHT, 0)
          elseif tooltipInfo.tooltipType == "shipyard" then
            mapTooltip:AddAnotherSideLine(lastIndex, locale.map.shipyard, "", 0, ALIGN_RIGHT, 0.3)
          end
          mapTooltip:AttachLowerSpaceLine(lastIndex, 10)
          mapTooltip.line:SetVisible(true)
        end
        if tooltipInfo.battleship ~= nil and tooltipInfo.battleship == false then
          if tooltipInfo.owner ~= nil then
            lastIndex = mapTooltip:AddLine(locale.map.telescopeOwner(tooltipInfo.owner), "", 0, "left", ALIGN_LEFT, 0)
          end
          if tooltipInfo.expedition ~= nil then
            lastIndex = mapTooltip:AddLine(locale.map.telescopeExpedition(tooltipInfo.expedition), "", 0, "left", ALIGN_LEFT, 0)
          else
            local typeStr = {
              slave = GetUIText(MAP_TEXT, "none"),
              shipyard = GetUIText(MAP_TEXT, "unknown")
            }
            if typeStr[tooltipInfo.tooltipType] ~= nil then
              local str = string.format("%s: %s", GetUIText(INFOBAR_MENU_TIP_TEXT, "expedition"), typeStr[tooltipInfo.tooltipType])
              lastIndex = mapTooltip:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
            end
          end
          if tooltipInfo.buff then
            lastIndex = mapTooltip:AddLine(locale.map.telescopeBuff, "", 0, "left", ALIGN_LEFT, 0)
          end
        end
        if tooltipInfo.hp ~= nil and tooltipInfo.maxHp ~= nil then
          mapTooltip:AttachLowerSpaceLine(lastIndex, 22)
          mapTooltip.hpBar:SetValue(tooltipInfo.hp, tooltipInfo.maxHp)
          mapTooltip.hpBar:Show(true)
        end
        function mapTooltip:OnUpdate()
          local hp, maxhp = X2Map:GetTelescopeUnitHealth(mapTooltip.targetId)
          if hp == nil or maxhp == nil then
            HideMapTooltip()
          else
            mapTooltip.hpBar:SetValue(hp, maxhp)
          end
        end
        mapTooltip:SetHandler("OnUpdate", mapTooltip.OnUpdate)
      elseif tooltipInfo.tooltipType == "commonFarm" then
        local count = tooltipInfo.count
        local list = tooltipInfo.list
        for i = 1, count do
          local name = list[i].name
          strWidth = GetLongestWidth(strWidth, name)
          if list[i].growthDone then
            name = FONT_COLOR_HEX.BLUE .. name
          end
          mapTooltip:AddLine(name, "", 0, "left", ALIGN_LEFT, 0)
        end
      elseif tooltipInfo.tooltipType == "zoneState" then
        do
          local zoneId = tooltipInfo.zoneId
          local delay = 1000
          function mapTooltip:OnUpdate(dt)
            delay = delay + dt
            if delay < 1000 then
              return
            end
            delay = 0
            self:ClearLines()
            local name = X2Dominion:GetZoneGroupName(zoneId)
            strWidth = GetLongestWidth(strWidth, name)
            mapTooltip:AddLine(name, "", 0, "left", ALIGN_LEFT, 0)
            local minLv, maxLv = X2Dominion:GetRecommendLevelToZoneGroup(zoneId)
            if minLv > 0 and maxLv > 0 then
              local strLevel = GetCommonText("zone_recommend_level", GetLevelToString(minLv, FONT_COLOR_HEX.SOFT_BROWN), GetLevelToString(maxLv, FONT_COLOR_HEX.SOFT_BROWN))
              strWidth = GetLongestWidth(strWidth, strLevel)
              mapTooltip:AddLine(strLevel, "", 0, "left", ALIGN_LEFT, 0)
            end
            local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
            if zoneInfo == nil then
              return
            end
            local fontColor = GetTooltipZoneStateFontColor(zoneInfo)
            if zoneInfo.isFestivalZone then
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetCommonText("festival_zone")), "", 0, "left", ALIGN_LEFT, 0)
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), zoneInfo.festivalName), "", 0, "left", ALIGN_LEFT, 0)
              strWidth = GetLongestWidth(strWidth, GetCommonText("festival_zone"))
              strWidth = GetLongestWidth(strWidth, zoneInfo.festivalName)
              if zoneInfo.remainTime ~= nil and 0 < zoneInfo.remainTime then
                mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetRemainTimeString(zoneInfo.remainTime * 1000)), "", 0, "left", ALIGN_LEFT, 0)
              end
              strWidth = GetLongestWidth(strWidth, GetRemainTimeString(zoneInfo.remainTime * 1000))
            elseif zoneInfo.isConflictZone then
              local stateStr = ""
              if zoneInfo.conflictState < HPWS_BATTLE then
                stateStr = locale.honorPointWar.getZoneState(zoneInfo.conflictState)
              else
                stateStr = locale.honorPointWar.getZoneStateHud(zoneInfo.conflictState)
              end
              strWidth = GetLongestWidth(strWidth, stateStr)
              mapTooltip:AddLine(GetHexColorForString(Dec2Hex(fontColor)) .. stateStr, "", 0, "left", ALIGN_LEFT, 0)
              if zoneInfo.remainTime ~= 0 then
                local timeStr = GetRemainTimeString(zoneInfo.remainTime * 1000)
                strWidth = GetLongestWidth(strWidth, timeStr)
                mapTooltip:AddLine(GetHexColorForString(Dec2Hex(fontColor)) .. timeStr, "", 0, "left", ALIGN_LEFT, 0)
              end
            elseif zoneInfo.isSiegeZone then
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetCommonText("conflict_zone")), "", 0, "left", ALIGN_LEFT, 0)
              strWidth = GetLongestWidth(strWidth, GetCommonText("conflict_zone"))
            elseif zoneInfo.isNuiaProtectedZone then
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetCommonText("nuia_protection_zone")), "", 0, "left", ALIGN_LEFT, 0)
              strWidth = GetLongestWidth(strWidth, GetCommonText("nuia_protection_zone"))
            elseif zoneInfo.isHariharaProtectedZone then
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetCommonText("harihara_protection_zone")), "", 0, "left", ALIGN_LEFT, 0)
              strWidth = GetLongestWidth(strWidth, GetCommonText("harihara_protection_zone"))
            elseif zoneInfo.isPeaceZone then
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetCommonText("non_pvp_zone")), "", 0, "left", ALIGN_LEFT, 0)
              strWidth = GetLongestWidth(strWidth, GetCommonText("non_pvp_zone"))
            else
              mapTooltip:AddLine(string.format("%s%s", GetHexColorForString(Dec2Hex(fontColor)), GetCommonText("conflict_zone")), "", 0, "left", ALIGN_LEFT, 0)
              strWidth = GetLongestWidth(strWidth, GetCommonText("conflict_zone"))
            end
          end
          mapTooltip:SetHandler("OnUpdate", mapTooltip.OnUpdate)
        end
      elseif tooltipInfo.tooltipType == "mySlave" then
        mapTooltip:SetExtent(250, 20)
        mapTooltip:SetAutoWordwrap(true)
        local lastIndex = 0
        if tooltipInfo.name ~= nil then
          local name = X2Util:UTF8StringLimit(tostring(tooltipInfo.name), 12, "...")
          lastIndex = mapTooltip:AddLine(name, FONT_PATH.DEFAULT, 13, "left", ALIGN_LEFT, 0)
          mapTooltip:AddAnotherSideLine(lastIndex, locale.map.slaveKind(tooltipInfo.kind), "", 0, ALIGN_RIGHT, 0)
          mapTooltip:AttachLowerSpaceLine(lastIndex, 10)
          mapTooltip.line:SetVisible(true)
        end
        if tooltipInfo.hp ~= nil and tooltipInfo.maxHp ~= nil then
          mapTooltip:AttachLowerSpaceLine(lastIndex, 22)
          mapTooltip.hpBar:SetValue(tooltipInfo.hp, tooltipInfo.maxHp)
          mapTooltip.hpBar:Show(true)
        end
        function mapTooltip:OnUpdate()
          local hp, maxhp = X2Map:GetMySlaveHealth()
          if hp == nil or maxhp == nil then
            HideMapTooltip()
          else
            mapTooltip.hpBar:SetValue(hp, maxhp)
          end
        end
        mapTooltip:SetHandler("OnUpdate", mapTooltip.OnUpdate)
      elseif tooltipInfo.tooltipType == "conquest" then
        local lastIndex = -1
        if tooltipInfo.npcName then
          lastIndex = mapTooltip:AddLine(tooltipInfo.npcName, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, tooltipInfo.npcName)
        end
        if tooltipInfo.factionName then
          lastIndex = mapTooltip:AddLine(tooltipInfo.factionName, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, tooltipInfo.factionName)
        end
        local isAttackable = false
        if tooltipInfo.spawnRemainTime and 0 < tonumber(tooltipInfo.spawnRemainTime) then
          isAttackable = true
        end
        if isAttackable then
          local msg = string.format("%s: %s", GetCommonText("conquest_cant_attack"), MakeTimeString(tooltipInfo.spawnRemainTime))
          lastIndex = mapTooltip:AddLine(msg, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, msg)
        else
          if tooltipInfo.npcHp then
            local msg = string.format("%s: %s", GetCommonText("conquest_durability"), tostring(tooltipInfo.npcHp))
            lastIndex = mapTooltip:AddLine(msg, "", 0, "left", ALIGN_LEFT, 0)
            strWidth = GetLongestWidth(strWidth, msg)
          end
          if tooltipInfo.expectScore then
            local msg = string.format("%s: %s", GetCommonText("conquest_expect_scroe"), tostring(tooltipInfo.expectScore))
            lastIndex = mapTooltip:AddLine(msg, "", 0, "left", ALIGN_LEFT, 0)
            strWidth = GetLongestWidth(strWidth, msg)
          end
        end
        if lastIndex == -1 then
          lastIndex = mapTooltip:AddLine(GetCommonText("conquest_base_empty_faction"), "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, GetCommonText("conquest_base_empty_faction"))
        end
      elseif tooltipInfo.tooltipType == "territory" then
        lastIndex = mapTooltip:AddLine(tooltipInfo.factionName, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, tooltipInfo.factionName)
        lastIndex = mapTooltip:AddLine(tooltipInfo.territoryName, "", 0, "left", ALIGN_LEFT, 0)
        strWidth = GetLongestWidth(strWidth, tooltipInfo.territoryName)
      elseif tooltipInfo.tooltipType == "light_house" then
        if tooltipInfo.name ~= nil then
          mapTooltip:AddLine(tooltipInfo.name, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, tooltipInfo.name)
        end
        if tooltipInfo.factionId ~= nil then
          local protectFactionInfo = X2Faction:GetFactionInfo(tooltipInfo.factionId)
          if protectFactionInfo ~= nil then
            local factionStr = ""
            if tooltipInfo.factionId == 1 then
              factionStr = string.format("%s%s %s", M_NPC_NICKNAME_TOOLTIP_COLOR, GetCommonText("usable_faction"), GetCommonText("all"))
            else
              factionStr = string.format("%s%s %s", M_NPC_NICKNAME_TOOLTIP_COLOR, GetCommonText("usable_faction"), protectFactionInfo.name)
            end
            mapTooltip:AddLine(factionStr, "", 0, "left", ALIGN_LEFT, 0)
            strWidth = GetLongestWidth(strWidth, factionStr)
          end
        end
        if tooltipInfo.possible ~= nil then
          local str = ""
          if tooltipInfo.possible then
            str = string.format("%s%s", M_NPC_NICKNAME_TOOLTIP_COLOR, GetCommonText("friendly_light_house_area"))
          else
            str = string.format("%s%s", M_NPC_NICKNAME_TOOLTIP_COLOR, GetCommonText("hostile_light_house_area", tooltipInfo.name))
          end
          mapTooltip:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, str)
        end
      elseif tooltipInfo.tooltipType == "towerDef" then
        if tooltipInfo.name ~= nil then
          mapTooltip:AddLine(tooltipInfo.name, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, tooltipInfo.name)
        end
        local factions = ""
        if tooltipInfo.factions ~= nil then
          for i = 1, #tooltipInfo.factions do
            local factionName = X2Faction:GetFactionName(tonumber(tooltipInfo.factions[i]), true)
            if factionName ~= nil then
              if factions == "" then
                factions = factionName
              else
                factions = string.format("%s, %s", factions, factionName)
              end
            end
          end
          if factions ~= "" then
            local str = string.format("%s%s", F_COLOR.GetColor("tooltip_zone_color_state_peace", true), GetCommonText("tooltip_map_tower_def_faction", factions))
            mapTooltip:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
            strWidth = GetLongestWidth(strWidth, str)
          end
        end
        if tooltipInfo.remain ~= nil and tonumber(tooltipInfo.remain) ~= 0 then
          local remainStr = GetRemainTimeString(tonumber(tooltipInfo.remain) * 1000)
          local str = string.format("%s%s", F_COLOR.GetColor("tooltip_zone_color_state_high", true), GetCommonText("tooltip_map_tower_def_remain", remainStr))
          mapTooltip:AddLine(str, "", 0, "left", ALIGN_LEFT, 0)
          strWidth = GetLongestWidth(strWidth, str)
        end
      end
      if tooltipInfo.tooltipType ~= "slave" and tooltipInfo.tooltipType ~= "shipyard" and tooltipInfo.tooltipType ~= "mySlave" then
        if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
          tooltip.window:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
          tooltip.window:SetAutoWordwrap(true)
        else
          tooltip.window:SetAutoWordwrap(false)
        end
      end
    end
  end
  if offsetX == nil then
    offsetX = M_TOOLTIP_OFFSET_X
  end
  if offsetY == nil then
    offsetY = M_TOOLTIP_OFFSET_Y
  end
  if reverseX == nil then
    reverseX = M_TOOLTIP_OFFSET_REVERSE_X
  end
  if reverseY == nil then
    reverseY = M_TOOLTIP_OFFSET_REVERSE_Y
  end
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local posX, posY = UIParent:GetCursorPosition()
  local cx, cy = mapTooltip:GetExtent()
  mapTooltip:RemoveAllAnchors()
  if screenWidth > posX + cx + offsetX and posY - cy - offsetY > 0 then
    mapTooltip:AddAnchor("BOTTOMLEFT", target, "CENTER", offsetX, offsetY)
  elseif posX - cx - reverseX > 0 and screenHeight > posY + cy + reverseY then
    mapTooltip:AddAnchor("TOPRIGHT", target, "CENTER", reverseX, reverseY)
  else
    mapTooltip:AddAnchor("BOTTOMRIGHT", target, "CENTER", 2, 2)
  end
  mapTooltip:Show(true)
end
function mapTooltip.hpBar:SetValue(hp, maxHp)
  hp = math.min(hp, maxHp)
  mapTooltip.hpLabel:SetText(string.format("%d / %d", hp, maxHp))
  mapTooltip.hp:AddAnchor("BOTTOMRIGHT", self, "BOTTOMLEFT", hp / maxHp * self:GetWidth(), 0)
end
function SecondToHHMMSS(period)
  local SECOND = 1
  local MINUTE = SECOND * 60
  local HOUR = MINUTE * 60
  local DAY = HOUR * 24
  local MONTH = DAY * 30
  local YEAR = MONTH * 12
  dateFormat = {}
  dateFormat.hour = math.floor(period / HOUR)
  if dateFormat.hour > 0 then
    period = period - dateFormat.hour * HOUR or period
  end
  dateFormat.minute = math.floor(period / MINUTE)
  if 0 < dateFormat.minute then
    period = period - dateFormat.minute * MINUTE or period
  end
  dateFormat.second = period
  return dateFormat
end
function MakeTimeString(time)
  local dateFormat = SecondToHHMMSS(time)
  local timeStr = ""
  if dateFormat.hour > 24 then
    local day = math.floor(dateFormat.hour / 24)
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "day", tostring(day))
    dateFormat.hour = dateFormat.hour % 24
  end
  if dateFormat.hour > 0 then
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "hour", tostring(dateFormat.hour))
  end
  if 0 < dateFormat.minute then
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "minute", tostring(dateFormat.minute))
  end
  if 0 < dateFormat.second then
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "second", tostring(dateFormat.second))
  end
  return timeStr
end
function ShowTextTooltip(target, titleText, tip, anchorInfos)
  if tip == nil then
    HideTextTooltip()
    return
  end
  local strWidth = 0
  if titleText ~= nil then
    strWidth = GetLongestWidth(strWidth, titleText)
  end
  strWidth = GetLongestWidth(strWidth, tip)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    textTooltip:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    textTooltip:SetAutoWordwrap(true)
  else
    textTooltip:SetAutoWordwrap(false)
  end
  textTooltip:ClearLines()
  if titleText ~= nil then
    local offset = 15
    local index = textTooltip:AddLine(titleText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    textTooltip:AttachLowerSpaceLine(index, offset)
    local onlyLineHeight, includeSpceHeight = textTooltip:GetHeightToLastLine()
    textTooltip.titleLine:SetVisible(true)
    textTooltip.titleLine:AddAnchor("TOPLEFT", textTooltip, 0, includeSpceHeight - offset / 2.5)
    textTooltip.titleLine:AddAnchor("TOPRIGHT", textTooltip, 0, includeSpceHeight - offset / 2.5)
  end
  textTooltip:AddLine(tip, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  if anchorInfos == nil then
    textTooltip:RemoveAllAnchors()
    textTooltip:AddAnchor("TOPLEFT", target, "BOTTOMRIGHT", 5, 5)
  else
    textTooltip:RemoveAllAnchors()
    textTooltip:AddAnchor(anchorInfos.myAnchor, target, anchorInfos.targetAnchor, anchorInfos.x, anchorInfos.y)
    local x, y = textTooltip:GetEffectiveOffset()
    if UIParent:GetScreenHeight() - y <= textTooltip:GetHeight() then
      textTooltip:RemoveAllAnchors()
      textTooltip:AddAnchor("BOTTOMLEFT", target, "BOTTOMRIGHT", 0, 0)
    end
  end
  if titleText ~= nil and textTooltip:GetWidth() < 150 then
    textTooltip.titleLine:SetCoords(446, 574, 148, 3)
  else
    textTooltip.titleLine:SetCoords(0, 1007, 311, 3)
  end
  textTooltip:Show(true)
  if not target:HasHandler("OnLeave") then
    local OnLeave = function()
      HideTextTooltip()
    end
    target:SetHandler("OnLeave", OnLeave)
  end
end
function SetPremiumServiceToolTip(geade, endTime, buffToolTip, target)
  local lastIndex = 0
  if premiumServiceToolTip == nil then
    return
  end
  local tooltipWindow = premiumServiceToolTip
  local strWidth = tooltipWindow.style:GetTextWidth(buffToolTip)
  if strWidth > DEFAULT_SIZE.TOOLTIP_MAX_WIDTH then
    tooltipWindow:SetWidth(DEFAULT_SIZE.TOOLTIP_MAX_WIDTH)
    tooltipWindow:SetAutoWordwrap(true)
  else
    tooltipWindow:SetAutoWordwrap(false)
  end
  tooltipWindow:ClearLines()
  tooltipWindow:RemoveAllAnchors()
  tooltipWindow:AddAnchor("BOTTOMRIGHT", target, "TOPLEFT", 0, 0)
  tooltipWindow:SetAutoWordwrap(true)
  local color = FONT_COLOR_HEX.SOFT_BROWN
  lastIndex = tooltipWindow:AddLine(color .. GetUIText(PREMIUM_TEXT, "premium_service"), FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
  tooltipWindow:AttachLowerSpaceLine(lastIndex, space_bigFont * 2)
  local onlyLine, includeSpace = tooltipWindow:GetHeightToLastLine()
  tooltipWindow.titleLine:AddAnchor("TOPLEFT", tooltipWindow, 0, includeSpace - space_bigFont)
  tooltipWindow.titleLine:AddAnchor("TOPRIGHT", tooltipWindow, 0, includeSpace - space_bigFont)
  color = FONT_COLOR_HEX.YELLOW_OCHER
  if baselibLocale.premiumService.usePremiumGrade then
    local gradeText = tostring(geade - 1)
    lastIndex = tooltipWindow:AddLine(color .. locale.premium.grade(gradeText), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  else
    lastIndex = tooltipWindow:AddLine(color .. locale.premium.use_premium_service, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  end
  if baselibLocale.premiumService.showEndTime and endTime ~= nil and endTime ~= "" then
    color = FONT_COLOR_HEX.RED
    if baselibLocale.premiumService.endTimeTooltipLine then
      lastIndex = tooltipWindow:AddLine(color .. endTime .. locale.housing.untilTerm, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    else
      tooltipWindow:AddAnotherSideLine(lastIndex, color .. endTime .. locale.housing.untilTerm, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    end
  end
  tooltipWindow:AttachLowerSpaceLine(lastIndex, space_bigFont * 2)
  onlyLine, includeSpace = tooltipWindow:GetHeightToLastLine()
  tooltipWindow.infoLine:AddAnchor("TOPLEFT", tooltipWindow, 0, includeSpace - space_bigFont)
  tooltipWindow.infoLine:AddAnchor("TOPRIGHT", tooltipWindow, 0, includeSpace - space_bigFont)
  lastIndex = tooltipWindow:AddLine(buffToolTip, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  onlyLine, includeSpace = tooltipWindow:GetHeightToLastLine()
  tooltipWindow:SetHeight(includeSpace + 10)
  tooltipWindow:Show(true)
end
