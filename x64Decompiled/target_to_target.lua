local TARGET_TO_TARGET_FRAME_WIDTH = 120
function CreateTargetToTargetFrame(id, parent)
  local frame = CreateUnitFrame(id, parent, UNIT_FRAME_TYPE.TARGET_TO_TARGET)
  function frame:ApplyFrameStyle()
    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_FRIENDLY)
    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP)
    self.buffWindow:AddAnchor("TOPLEFT", self.mpBar, "BOTTOMLEFT", 2, 4)
    self.buffWindow:SetLayout(5, 24)
    self.debuffWindow:SetLayout(5, 24)
  end
  frame:ApplyFrameStyle()
  frame:SetTarget("targettarget")
  frame.id = nil
  return frame
end
local ttargetFrame = CreateTargetToTargetFrame("ttargetFrame", "UIParent")
ttargetFrame:Show(false)
function ttargetFrame:MakeOriginWindowPos(reset)
  if ttargetFrame == nil then
    return
  end
  ttargetFrame:RemoveAllAnchors()
  if reset then
    ttargetFrame:AddAnchor("TOPLEFT", targetFrame, "TOPRIGHT", F_LAYOUT.CalcDontApplyUIScale(20), 0)
  else
    ttargetFrame:AddAnchor("TOPLEFT", targetFrame, "TOPRIGHT", 20, 0)
  end
end
ttargetFrame:MakeOriginWindowPos()
AddUISaveHandlerByKey("targettotarget", ttargetFrame)
ttargetFrame:ApplyLastWindowOffset()
function ttargetFrame:IsTargetTargetVisible()
  local ttargetName = X2Unit:UnitName("targettarget")
  if ttargetName ~= nil then
    local targetType = X2Unit:GetTargetTypeString() or ""
    if targetType == "npc" and X2Unit:UnitCombatState("target") then
      return true
    elseif targetType == "character" then
      return true
    end
  end
  return false
end
function ttargetFrame:Update()
  local ttargetId = X2Unit:GetUnitId("targettarget")
  if ttargetId ~= nil and self:IsTargetTargetVisible() then
    if self.id == nil or self.id ~= ttargetId then
      self.id = ttargetId
      self:Show(true)
      self:SetTarget("targettarget")
    end
  else
    self.id = nil
    self:Show(false)
  end
  return true
end
function ttargetFrame:TargetChanged()
  if self:IsTargetTargetVisible() then
    self:Show(true)
    self:SetTarget("targettarget")
  else
    self:Show(false)
  end
end
local targetToTargetEvent = {
  TARGET_CHANGED = function(this, stringId, targetType)
    this:TargetChanged()
  end,
  TARGET_TO_TARGET_CHANGED = function(this, stringId, targetType)
    this:TargetChanged()
  end,
  ENTERED_WORLD = function(this, w)
    local stringId = X2Unit:GetTargetUnitId()
    if stringId == nil then
      return
    end
    this:TargetChanged()
    this:UpdateCombatIcon()
  end,
  TEAM_MEMBER_DISCONNECTED = function(this, isParty, jointOrder, stringId, memberIndex)
    if X2Unit:UnitIsOffline("targettarget") then
      this:Show(false)
    end
  end,
  LEFT_LOADING = function(this)
    this:UpdateCombatIcon()
  end
}
ttargetFrame:AddOnEvents(targetToTargetEvent)
ttargetCastingBar = W_BAR.CreateCastingBar("ttargetCastingBar", ttargetFrame, "targettarget")
ttargetCastingBar:Show(false)
ttargetCastingBar:AddAnchor("TOPLEFT", ttargetFrame.debuffWindow, "BOTTOMLEFT", 0, 0)
ttargetCastingBar:AddAnchor("RIGHT", ttargetFrame, "RIGHT", 0, 0)
ttargetCastingBar:RegisterEvent("SPELLCAST_START")
ttargetCastingBar:RegisterEvent("SPELLCAST_STOP")
ttargetCastingBar:RegisterEvent("SPELLCAST_SUCCEEDED")
local SetTargetToTarget = function(bar, stringId)
  if stringId == nil then
    bar.unit = "none"
  elseif X2Unit:GetUnitId("player") == stringId then
    bar.unit = "player"
  elseif X2Unit:GetUnitId("target") == stringId then
    bar.unit = "target"
  else
    bar.unit = "targettarget"
  end
end
local targetChangeEvent = {
  TARGET_CHANGED = function(stringId, targetType)
    local ttargetId = X2Unit:GetUnitId("targettarget")
    SetTargetToTarget(ttargetCastingBar, ttargetId)
    ttargetCastingBar:Refresh()
  end,
  TARGET_TO_TARGET_CHANGED = function(stringId, targetType)
    SetTargetToTarget(ttargetCastingBar, stringId)
    ttargetCastingBar:Refresh()
  end
}
ttargetCastingBar:SetEventProc(targetChangeEvent)
ttargetCastingBar:RegisterEvent("TARGET_CHANGED")
ttargetCastingBar:RegisterEvent("TARGET_TO_TARGET_CHANGED")
