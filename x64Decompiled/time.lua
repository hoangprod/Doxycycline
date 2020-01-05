function GetWorldLeaveTime(leaveTime)
  if leaveTime.year ~= 0 then
    return leaveTime.year .. locale.expedition.before_year
  elseif leaveTime.month ~= 0 then
    return leaveTime.month .. locale.expedition.before_month
  elseif leaveTime.day ~= 0 then
    return leaveTime.day .. locale.expedition.before_day
  elseif leaveTime.hour ~= 0 then
    return leaveTime.hour .. locale.expedition.before_hour
  elseif leaveTime.minute ~= 0 then
    return leaveTime.minute .. locale.expedition.before_min
  else
    return locale.expedition.less_min
  end
end
function GetMinuteSecondeFromSec(sec)
  local min = math.floor(sec / 60)
  sec = sec - min * 60
  return min, sec
end
function GetHourMinuteSecondeFromSec(sec)
  local hour = math.floor(sec / 3600)
  sec = sec - hour * 3600
  local min = math.floor(sec / 60)
  sec = sec - min * 60
  return hour, min, sec
end
function GetHourMinuteSecondeFromMsec(msec)
  return GetHourMinuteSecondeFromSec(math.floor(msec / 1000))
end
function GetMescFromHourMinuteSecond(hour, minute, sec)
  local msec = 0
  if hour ~= nil then
    mesc = hour * 60 * 60 * 1000
  end
  if minute ~= nil then
    mesc = mesc + minute * 60 * 1000
  end
  if sec ~= nil then
    mesc = mesc + sec * 1000
  end
  return mesc
end
