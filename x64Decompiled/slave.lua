local SLAVE_FRAME_WIDTH = 120
local unitFrameSlave
local BATTLE_SHIP_SLAVE_TARGET = "versusBattleShip"
local function CreateSlaveFrame(id, parent)
  local window = CreateUnitFrame(id, parent, UNIT_FRAME_TYPE.SLAVE)
  window.oldUnitId = nil
  local playerFrame = ADDON:GetContent(UIC_PLAYER_UNITFRAME)
  if playerFrame == nil then
    return
  end
  function window:ApplyFrameStyle()
    self.level:Show(false)
    self.mpBar:Show(false)
    self.pvpIcon:Show(false)
    self.lootIcon:Show(false)
    self.leaderMark:Show(false)
    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_FRIENDLY)
    self.name:SetExtent(90, FONT_SIZE.MIDDLE)
    self.name:RemoveAllAnchors()
    self.name:AddAnchor("TOPLEFT", self, 0, 4)
    self.buffWindow:SetLayout(5, 24, 2, 2, false)
    self.buffWindow:AddAnchor("TOPLEFT", self.hpBar, "BOTTOMLEFT", 2, 6)
    self.debuffWindow:SetLayout(5, 24, 2, 2, false)
    self.marker:SetExtent(24, 24)
    self.marker:AddAnchor("LEFT", self.name, "RIGHT", 0, 0)
  end
  function window:MakeOriginWindowPos(reset)
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    local xPos = 20
    local yPos = 0
    if reset then
      xPos = F_LAYOUT.CalcDontApplyUIScale(xPos)
      yPos = F_LAYOUT.CalcDontApplyUIScale(yPos)
    end
    window:AddAnchor("TOPLEFT", playerFrame, "TOPRIGHT", xPos, yPos)
  end
  window:MakeOriginWindowPos()
  function window:UpdateSlaveBarStyle()
    if self.oldUnitId == nil then
      if self.target == BATTLE_SHIP_SLAVE_TARGET then
        self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_OFFLINE)
      end
    elseif self.target == BATTLE_SHIP_SLAVE_TARGET then
      self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_FRIENDLY)
    end
  end
  function window:Update(dt)
    local newUnitId = X2Unit:GetUnitId(self.target)
    if self.oldUnitId == newUnitId then
      return
    end
    self.oldUnitId = newUnitId
    if self.oldUnitId ~= nil then
      self:UpdateAll()
    end
    self:UpdateSlaveBarStyle()
  end
  function window:OnHide()
    unitFrameSlave = nil
  end
  window:ApplyFrameStyle()
  window:EnableHidingIsRemove(true)
  AddUISaveHandlerByKey("playerSlaveFrame", window, false)
  window:ApplyLastWindowOffset()
  window:SetHandler("OnHide", window.OnHide)
  local events = {
    INSTANT_GAME_END = function(this)
      this:Show(false)
    end,
    INSTANT_GAME_RETIRE = function(this)
      this:Show(false)
    end
  }
  window:AddOnEvents(events)
  return window
end
local function ShowSlaveFrame(targetType)
  if unitFrameSlave == nil then
    unitFrameSlave = CreateSlaveFrame("unitFrameSlave", "UIParent")
  end
  if unitFrameSlave ~= nil then
    unitFrameSlave:SetTarget(targetType)
    unitFrameSlave:Show(true)
  end
end
UIParent:SetEventHandler("SPAWN_SLAVE", ShowSlaveFrame)
local function EnteredWorld()
  if X2BattleField:HasBindBattleShip() then
    ShowSlaveFrame(BATTLE_SHIP_SLAVE_TARGET)
  elseif unitFrameSlave ~= nil then
    unitFrameSlave:Show(false)
  end
end
UIParent:SetEventHandler("ENTERED_WORLD", EnteredWorld)
UIParent:SetEventHandler("LEFT_LOADING", EnteredWorld)
