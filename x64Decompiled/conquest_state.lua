local UpdateTime = function(nowTime)
  if nowTime <= 0 then
    nowTime = 0
  end
  local hour, minute, second = GetHourMinuteSecondeFromSec(nowTime)
  local timeStr = string.format("%02d:%02d", minute, second)
  conquestStateWnd.remainTime:SetText(timeStr)
end
local UpdateScoreInfo = function(zoneGroup)
  local scoreInfos = X2ZoneGroupState:GetConquestScoreInfos(zoneGroup)
  conquestStateWnd.itemListFrame.itemBgImg:SetVisible(false)
  for i = 1, 6 do
    local info = scoreInfos[i]
    if i <= #scoreInfos then
      conquestStateWnd:AddItem(i, info.name, info.score, info.rank, info.addScore)
    else
      conquestStateWnd:AddItem(i, "", 0, 0, 0)
    end
  end
end
local UpdateBriefingInfo = function(zoneGroup)
  conquestStateWnd.zoneGroup = zoneGroup
  if conquestStateWnd:HasHandler("OnUpdate") == false then
    conquestStateWnd:SetHandler("OnUpdate", conquestStateWnd.OnUpdateTime)
  end
end
function ShowConquestStateWnd(zoneGroup)
  if X2ZoneGroupState:IsPlaying(zoneGroup) == false then
    if conquestStateWnd and conquestStateWnd:IsVisible() then
      conquestStateWnd:Show(false)
    end
    return
  else
    return
  end
  if conquestStateWnd ~= nil then
    return
  end
  conquestStateWnd = CreateConquestStateWindow()
  local oldTime = 0
  local timeCheck = 0
  function conquestStateWnd:OnUpdateTime(dt)
    timeCheck = timeCheck + dt
    if timeCheck < 500 then
      return
    end
    timeCheck = dt
    local remainTime = X2ZoneGroupState:GetConquestRemainTime(self.zoneGroup)
    if remainTime == nil then
      return
    end
    local remain = math.floor(remainTime / 1000)
    if remain <= 0 then
      UpdateTime(0)
      self:ReleaseHandler("OnUpdate")
    end
    if oldTime ~= remain then
      oldTime = remain
      UpdateTime(remain)
    end
  end
  local OnShow = function()
    conquestStateWnd:MakeOriginWindowPos()
    AddUISaveHandlerByKey("conquest_state", conquestStateWnd)
    conquestStateWnd:ApplyLastWindowOffset()
  end
  conquestStateWnd:SetHandler("OnShow", OnShow)
  local conquestStateEvents = {
    ZONEGROUP_STATE_END = function(zoneGroup)
      if conquestStateWnd then
        conquestStateWnd:Show(false)
      end
    end,
    ZONEGROUP_STATE_SCORE = function(zoneGroup)
      if conquestStateWnd then
        UpdateScoreInfo(zoneGroup)
      end
    end,
    ZONEGROUP_STATE_BRIEFING = function(zoneGroup)
      if conquestStateWnd then
        UpdateBriefingInfo(zoneGroup)
      else
        ReloadConquestStateWnd()
      end
    end
  }
  conquestStateWnd:SetHandler("OnEvent", function(this, event, ...)
    conquestStateEvents[event](...)
  end)
  RegistUIEvent(conquestStateWnd, conquestStateEvents)
  conquestStateWnd:Show(true)
end
function ReloadConquestStateWnd()
  local zoneGroup = X2Unit:GetCurrentZoneGroup()
  ShowConquestStateWnd(zoneGroup)
  if conquestStateWnd and conquestStateWnd:IsVisible() then
    UpdateScoreInfo(zoneGroup)
    UpdateBriefingInfo(zoneGroup)
  end
end
UIParent:SetEventHandler("ZONEGROUP_STATE_START", ShowConquestStateWnd)
UIParent:SetEventHandler("ENTERED_WORLD", ReloadConquestStateWnd)
UIParent:SetEventHandler("LEFT_LOADING", ReloadConquestStateWnd)
UIParent:SetEventHandler("UPDATE_ZONE_INFO", ReloadConquestStateWnd)
