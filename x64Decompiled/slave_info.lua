function CreateSlaveInfoFrame(id, parent)
  local w = SetViewOfSlaveInfoFrame(id, parent)
  w.unitId = nil
  function w:UpdateSlaveDefaultInfo()
    local info = X2SiegeWeapon:GetMountedSiegeWeaponInfo()
    local isShip = false
    if info ~= nil then
      self.name:SetText(info.name)
      self.kind:SetText(locale.map.slaveKind(info.kind))
      self.class:SetText(info.desc_name)
      isShip = info.isShip
      self.unitId = info.unitId
      self.class.style:SetEllipsis(true)
      local function OnEnter()
        SetTooltip(info.desc_name, self.class)
      end
      self.class:SetHandler("OnEnter", OnEnter)
    end
    local vehicleInfo = X2SiegeWeapon:GetVehicleInfo()
    self.customizingType = X2SiegeWeapon:GetSlaveCustomizingType()
    local height = SLAVE_INFO_WND_HEIGHT
    if vehicleInfo ~= nil then
      self.speedInfoPart:Show(false)
      self.vehicleInfoPart:Show(true)
      self.shipInfoPart:Show(false)
      height = height + VEHICLE_INFO_WND_HEIGHT
    elseif isShip then
      self.speedInfoPart:Show(false)
      self.vehicleInfoPart:Show(false)
      self.shipInfoPart:Show(true)
      height = height + EQUIPMENT_INFO_WND_HEIGHT
      if self.customizingType ~= nil then
        self.shipInfoPart.equipmentWnd:InitEquipment(w.customizingType)
        self.shipInfoPart.toggleBtn:Show(true)
      else
        self.shipInfoPart.toggleBtn:Show(false)
      end
    else
      self.speedInfoPart:Show(true)
      self.vehicleInfoPart:Show(false)
      self.shipInfoPart:Show(false)
      height = height + SPEED_INFO_WND_HEIGHT
    end
    self:SetHeight(height)
  end
  function w:OnHide()
    self.unitId = nil
    self.shipInfoPart.equipmentWnd:Show(false)
  end
  w:SetHandler("OnHide", w.OnHide)
  local UpdateSpeedInfo = function(widget)
    local moveSpeed = X2SiegeWeapon:GetSiegeWeaponSpeed()
    local turnSpeed = X2SiegeWeapon:GetSiegeWeaponTurnSpeed()
    moveSpeed = math.abs(math.floor(moveSpeed * 10 + 0.5) / 10)
    turnSpeed = math.abs(math.floor(turnSpeed * 10 + 0.5) / 10)
    widget.moveSpeed:SetText(string.format("%s %s", tostring(moveSpeed), locale.util.speed_unit))
    widget.turnSpeed:SetText(string.format("%s %s", tostring(turnSpeed), locale.util.rotation_unit))
  end
  function w.speedInfoPart:Update()
    UpdateSpeedInfo(self)
  end
  function w.vehicleInfoPart:Update()
    UpdateSpeedInfo(self)
    local info = X2SiegeWeapon:GetVehicleInfo()
    if info == nil then
      return
    end
    local gear = info.gear
    local handbrake = info.handbrake
    local tractionCtrl = info.tractionCtrl
    local str = ""
    if gear > 1 then
      str = X2Locale:LocalizeUiText(SLAVE_TEXT, "foward_movement", locale.slave.gearGrade[gear - 1])
    else
      str = locale.slave.gearValue[gear + 1]
    end
    if str ~= "" then
      self.gear:SetText(str)
    end
    if handbrake then
      ApplyTextColor(self.brake, FONT_COLOR.BLUE)
      self.brake:SetText(locale.slave.on)
    else
      ApplyTextColor(self.brake, FONT_COLOR.DEFAULT)
      self.brake:SetText(locale.slave.off)
    end
    if tractionCtrl then
      ApplyTextColor(self.tractionCtrl, FONT_COLOR.BLUE)
      self.tractionCtrl:SetText(locale.slave.on)
    else
      ApplyTextColor(self.tractionCtrl, FONT_COLOR.DEFAULT)
      self.tractionCtrl:SetText(locale.slave.off)
    end
  end
  function w.shipInfoPart:Update()
    UpdateSpeedInfo(self)
    local info = X2SiegeWeapon:GetShipInfo()
    if info == nil then
      return
    end
    self.health:SetText(string.format("%d / %d", math.min(info.health, info.maxHealth), info.maxHealth))
    self.siegeDmgReduce:SetText(string.format("%0.1f %%", info.siege_incoming_dmg_mul))
    self.weight:SetText(string.format("%d kg", info.mass))
    self.collisionDmg:SetText(string.format("%d", info.collisionDmg))
    self.collisionAmr:SetText(string.format("%d", info.collisionAmr))
    local resultValue = 100
    if info.now and info.max and info.max > 0 then
      if info.now > info.max then
        local maxExceed = info.sinkingMax - info.max
        local nowExceed = info.now - info.max
        if maxExceed > 0 and nowExceed > 0 then
          local tmp = nowExceed / maxExceed * 100
          resultValue = 100 - tmp
        else
          UIParent:Warning(string.format("[Lua Error] invalid values.. (%d / %d)", maxExceed, nowExceed))
        end
        ApplyTextColor(self.passengers, FONT_COLOR.RED)
      else
        ApplyTextColor(self.passengers, FONT_COLOR.DEFAULT)
      end
    end
    self.passengers:SetText(string.format("%d", resultValue))
    self.equipmentWnd:CheckPossibleToChange()
  end
  local updateDelay = 0
  function w:OnUpdate(dt)
    updateDelay = updateDelay + dt
    if updateDelay < 300 then
      return
    end
    updateDelay = 0
    if self.speedInfoPart:IsVisible() then
      self.speedInfoPart:Update()
    elseif self.vehicleInfoPart:IsVisible() then
      self.vehicleInfoPart:Update()
    elseif self.shipInfoPart:IsVisible() then
      self.shipInfoPart:Update()
    end
  end
  w:SetHandler("OnUpdate", w.OnUpdate)
  return w
end
slaveInfoFrame = CreateSlaveInfoFrame("slaveInfo", "UIParent")
local slaveFrameEvents = {
  UNIT_NAME_CHANGED = function(unitId)
    if unitId == slaveInfoFrame.unitId and slaveInfoFrame:IsVisible() then
      slaveInfoFrame:UpdateSlaveDefaultInfo()
    end
  end
}
slaveInfoFrame:SetHandler("OnEvent", function(this, event, ...)
  slaveFrameEvents[event](...)
end)
RegistUIEvent(slaveInfoFrame, slaveFrameEvents)
