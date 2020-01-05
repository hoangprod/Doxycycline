local clockBar = GetIndicators().clockBar
defaultOption = false
local saveOption = true
local beforeMin = -1
local amImg = clockBar.amImg
local pmImg = clockBar.pmImg
local sun = clockBar.sun
local moon = clockBar.moon
local IsMorning = function()
  local isAm, hour, minute = X2Time:GetGameTime()
  if isAm == false then
    hour = hour + 12
  end
  minute = hour * 60 + minute
  if minute >= 210 and minute <= 1230 then
    return true
  else
    return false
  end
end
local GetDayCoords = function()
  local isAm, hour, minute = X2Time:GetGameTime()
  local copyMin = minute
  if isAm == false then
    hour = hour + 12
  end
  minute = hour * 60 + minute
  local minTime = 210
  local limitTime = 1230
  local currentTime = hour * 60 + copyMin
  limitTime = limitTime - minTime
  currentTime = currentTime - minTime
  local ratio = currentTime / limitTime
  local r = 100
  local startAng = math.pi / 4
  local endAng = startAng + math.pi / 2
  local currAng = startAng + (endAng - startAng) * ratio
  x = math.cos(currAng) * r * -1
  y = math.sin(currAng) * r
  return x, y
end
local GetNightCoords = function()
  local isAm, hour, minute = X2Time:GetGameTime()
  local x, y
  if isAm == false then
    hour = hour + 12
  end
  minute = hour * 60 + minute
  local copyMin = minute
  if minute >= 1230 then
    minute = minute - 1230
  else
    minute = minute + 210
  end
  local limitTime = 1650
  if copyMin < 1230 then
    copyMin = copyMin + 1440
  end
  limitTime = limitTime - 1230
  copyMin = copyMin - 1230
  local ratio = copyMin / limitTime
  local r = 100
  local startAng = math.pi / 4
  local endAng = startAng + math.pi / 2
  local currAng = startAng + (endAng - startAng) * ratio
  x = math.cos(currAng) * r * -1
  y = math.sin(currAng) * r
  return x, y
end
local tipText = locale.tooltip
function GetRemainTimeString(msec)
  totalSec = msec / 1000
  if totalSec < 60 then
    return string.format("%s %s", GetUIText(SERVER_TEXT, "timeBelowOneMinute"), locale.housing.left)
  end
  totalMinute = math.floor(totalSec / 60)
  if 60 > totalMinute then
    return string.format("%d%s %s", totalMinute, tipText.minute, locale.housing.left)
  end
  minute = totalMinute % 60
  totalHour = math.floor(totalMinute / 60)
  if totalHour < 24 then
    if minute == 0 then
      return string.format("%d%s %s", totalHour, tipText.hour, locale.housing.left)
    end
    return string.format("%d%s %d%s %s", totalHour, tipText.hour, minute, tipText.minute, locale.housing.left)
  end
  hour = totalHour % 24
  day = math.floor(totalHour / 24)
  if hour == 0 then
    return string.format("%d%s %s", day, tipText.day, locale.housing.left)
  end
  return string.format("%d%s %d%s %s", day, tipText.day, hour, tipText.hour, locale.housing.left)
end
local UpdateHonorPointWarRemainTime = function(dt)
  if honorPointWarStateWnd.zoneInfo.conflictState < HPWS_BATTLE then
    return
  end
  if honorPointWarStateWnd.remainTime > 0 then
    local strTime = GetRemainTimeString(honorPointWarStateWnd.remainTime)
    honorPointWarStateWnd.remainTime = honorPointWarStateWnd.remainTime - dt
    if honorPointWarStateWnd.strRemainTime == strTime then
      return
    end
    honorPointWarStateWnd.strRemainTime = strTime
    honorPointWarRemainTime:SetText(honorPointWarStateWnd.strRemainTime)
  else
    honorPointWarStateWnd.strRemainTime = ""
    honorPointWarRemainTime:SetText(honorPointWarStateWnd.strRemainTime)
  end
end
function clockBar:OnEffect(dt)
  if saveOption ~= defaultOption then
    clockBar:Show(true)
  else
    clockBar:Show(false)
  end
  local isAm, hour, minute = X2Time:GetGameTime()
  if math.abs(minute - beforeMin) <= 0.5 then
    return
  end
  beforeMin = minute
  if defaultOption == false then
    local x, y
    if IsMorning() == true then
      amImg:SetVisible(true)
      pmImg:SetVisible(false)
      sun:SetVisible(true)
      moon:SetVisible(false)
      x, y = GetDayCoords()
      sun:AddAnchor("BOTTOMLEFT", clockBar, x + 80, 5)
    else
      amImg:SetVisible(false)
      pmImg:SetVisible(true)
      sun:SetVisible(false)
      moon:SetVisible(true)
      x, y = GetNightCoords()
      moon:AddAnchor("BOTTOMLEFT", clockBar, x + 80, -2)
    end
  end
end
clockBar:SetHandler("OnEffect", clockBar.OnEffect)
clockBar.isShowTooltip = false
clockBar.minute = -1
function clockBar:OnUpdate(dt)
  if self.isShowTooltip == true then
    local isAm, hour, minute = X2Time:GetGameTime()
    minute = math.floor(minute)
    if minute ~= self.minute then
      local tip = hudLocale.MakeHudTimeString()
      self.minute = minute
      SetTargetAnchorTooltip(tip, "RIGHT", self, "LEFT", 0, 0)
    end
  end
end
clockBar:SetHandler("OnUpdate", clockBar.OnUpdate)
function clockBar:OnEnter()
  local isAm, hour, minute = X2Time:GetGameTime()
  local tip = hudLocale.MakeHudTimeString()
  self.minute = math.floor(minute)
  self.isShowTooltip = true
  SetTargetAnchorTooltip(tip, "RIGHT", self, "LEFT", 0, 0)
end
clockBar:SetHandler("OnEnter", clockBar.OnEnter)
function clockBar:OnLeave()
  self.isShowTooltip = false
  self.minute = -1
  HideTooltip()
end
clockBar:SetHandler("OnLeave", clockBar.OnLeave)
