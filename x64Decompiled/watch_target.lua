local WATCH_TARGET_FRAME_WIDTH = 120
local WATCH_TARGET_NAME_WIDTH = 57
function CreateWatchTargetFrame(id, parent)
  local w = CreateUnitFrame(id, parent, UNIT_FRAME_TYPE.WATCH)
  w:Show(false)
  local playerFrame = ADDON:GetContent(UIC_PLAYER_UNITFRAME)
  if playerFrame == nil then
    return
  end
  function w:MakeOriginWindowPos(reset)
    if w == nil then
      return
    end
    w:RemoveAllAnchors()
    if X2Player:GetFeatureSet().mateTypeSummon then
      if reset then
        w:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(401), F_LAYOUT.CalcDontApplyUIScale(345))
      else
        w:AddAnchor("TOPLEFT", "UIParent", 401, 345)
      end
    else
      w:AddAnchor("TOPLEFT", "UIParent", 325, 145)
    end
  end
  w:MakeOriginWindowPos()
  function w:ApplyFrameStyle()
    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_FRIENDLY)
    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP)
    self.name:SetExtent(90, FONT_SIZE.MIDDLE)
    self.buffWindow:SetLayout(5, 24)
    self.buffWindow:AddAnchor("TOPLEFT", self.mpBar, "BOTTOMLEFT", 2, 4)
    self.debuffWindow:SetLayout(5, 24)
    self.leaderMark:Show(false)
    self.lootIcon:Show(false)
  end
  function w:Click(arg)
    if arg == "RightButton" then
      ActivatePopupMenu(w, "watchtarget")
    end
  end
  function w:ChangeVisibleState(isFar)
    if isFar then
      self:SetAlpha(0.5)
    else
      self:SetAlpha(1)
    end
  end
  function w:UpdateHpMp()
    local info = X2Unit:UnitDistance(self.target)
    if info == nil then
      self:ChangeVisibleState(true)
      return
    end
    local curHp = X2Unit:UnitHealth(self.target)
    local maxHp = X2Unit:UnitMaxHealth(self.target)
    local curMp = X2Unit:UnitMana(self.target)
    local maxMp = X2Unit:UnitMaxMana(self.target)
    local isFar = info.distance >= UNIT_VISIBLE_MAX_DISTANCE
    self:ChangeVisibleState(isFar)
    if isFar == false then
      if curHp ~= nil and maxHp ~= nil then
        self:SetHp(curHp, maxHp)
      end
      if curMp ~= nil and maxMp ~= nil then
        self:SetMp(curMp, maxMp)
      end
    end
  end
  function w:Enter()
    local info = X2Unit:UnitDistance("watchtarget")
    if info == nil then
      self.tooltipText = locale.dominion.unknown
      self.gradeText = nil
    else
      w:UpdateTooltip()
    end
  end
  w:ApplyFrameStyle()
  w:SetTarget("watchtarget")
  return w
end
local events = {
  ENTERED_WORLD = function(this)
    this:UpdateMarker()
  end,
  LEFT_LOADING = function(this)
    local watchTargetId = X2Unit:GetUnitId("watchtarget")
    if not watchTargetId then
      this:Show(false)
    end
  end
}
watchTargetFrame = CreateWatchTargetFrame("watchTargetFrame", "UIParent")
watchTargetFrame:AddOnEvents(events)
AddUISaveHandlerByKey("watchtarget", watchTargetFrame)
watchTargetFrame:ApplyLastWindowOffset()
local watchTargetCastingBar = W_BAR.CreateCastingBar("watchTargetCastingBar", watchTargetFrame, "watchtarget")
watchTargetCastingBar:Show(false)
watchTargetCastingBar:AddAnchor("TOPLEFT", watchTargetFrame.debuffWindow, "BOTTOMLEFT", 0, 0)
watchTargetCastingBar:AddAnchor("RIGHT", watchTargetFrame, "RIGHT", 0, 0)
watchTargetCastingBar:RegisterEvent("SPELLCAST_START")
watchTargetCastingBar:RegisterEvent("SPELLCAST_STOP")
watchTargetCastingBar:RegisterEvent("SPELLCAST_SUCCEEDED")
local SetWatchTarget = function(bar, stringId)
  if stringId == nil then
    bar.unit = "none"
  elseif X2Unit:GetUnitId("player") == stringId then
    bar.unit = "player"
  elseif X2Unit:GetUnitId("target") == stringId then
    bar.unit = "target"
  elseif X2Unit:GetUnitId("targettarget") == stringId then
    bar.unit = "targettarget"
  else
    bar.unit = "watchtarget"
  end
end
local targetChangeEvent = {
  TARGET_CHANGED = function(stringId, targetType)
    local watchTargetId = X2Unit:GetUnitId("watchtarget")
    SetWatchTarget(watchTargetCastingBar, watchTargetId)
    watchTargetCastingBar:Refresh()
  end,
  TARGET_TO_TARGET_CHANGED = function(stringId, targetType)
    local watchTargetId = X2Unit:GetUnitId("watchtarget")
    SetWatchTarget(watchTargetCastingBar, watchTargetId)
    watchTargetCastingBar:Refresh()
  end
}
watchTargetCastingBar:SetEventProc(targetChangeEvent)
watchTargetCastingBar:RegisterEvent("TARGET_CHANGED")
watchTargetCastingBar:RegisterEvent("TARGET_TO_TARGET_CHANGED")
function ToggleWatchTargetFrame(isShow)
  if watchTargetFrame ~= nil then
    watchTargetFrame:Show(isShow)
  end
  if isShow then
    watchTargetFrame:SetTarget("watchtarget")
    local watchTargetId = X2Unit:GetUnitId("watchtarget")
    SetWatchTarget(watchTargetCastingBar, watchTargetId)
  else
    watchTargetCastingBar.unit = "none"
  end
end
local WatchTargetChanged = function(stringId)
  local isShow = stringId and true or false
  ToggleWatchTargetFrame(isShow)
end
UIParent:SetEventHandler("WATCH_TARGET_CHANGED", WatchTargetChanged)
local watchTargetUnitId = X2Unit:GetUnitId("watchtarget")
if watchTargetUnitId then
  ToggleWatchTargetFrame(true)
else
  X2Unit:ReleaseWatchTarget()
end
