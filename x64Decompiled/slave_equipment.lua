local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateSlaveEquipmentWnd(id, parent)
  local width = WINDOW_SIZE.SMALL
  local height = 528 + titleMargin + sideMargin
  local window = CreateWindow(id, parent)
  window:SetExtent(width, height)
  window:Show(false)
  window:SetTitle(GetCommonText("equipment_info"))
  local autoToggleBtn = CreateCheckButton("autoToggleBtn", window, GetCommonText("toggle_with_slave_info"))
  window.autoToggleBtn = autoToggleBtn
  function autoToggleBtn:CheckBtnCheckChagnedProc(checked)
    X2:SetAutoToggleSlaveEquipmentUiData(checked)
  end
  function window:SlaveEquipOnClick(arg, slotType)
    if arg == "LeftButton" then
      X2SiegeWeapon:PickEquipSlotOfSlave(slotType)
    elseif arg == "RightButton" then
      X2SiegeWeapon:UninstallEquipSlotOfSlave(slotType)
    end
  end
  function window:SlaveEquipOnDragStart(slotType)
    X2SiegeWeapon:PickEquipSlotOfSlave(slotType)
  end
  function window:SlaveEquipOnDragReceive(slotType)
    X2SiegeWeapon:PickEquipSlotOfSlave(slotType)
  end
  function window:GetSlaveEquipSlotInfo(slotType)
    return X2SiegeWeapon:GetSlaveEquipSlotInfo(slotType)
  end
  function window:SlaveEquipUpdate(equipSlot)
    if equipSlot.slotType ~= nil then
      local result = X2SiegeWeapon:CanRepairEquipSlot(equipSlot.slotType)
      if result then
        equipSlot:SetAlpha(1)
        equipSlot:Enable(true)
      else
        result = X2SiegeWeapon:CanSlaveEquipPickedItem(equipSlot.slotType)
        if result == nil then
          equipSlot:SetAlpha(1)
          equipSlot:Enable(window.equipWnd ~= nil and window.equipWnd:IsEnabled())
        elseif result then
          equipSlot:SetAlpha(1)
          equipSlot:Enable(window.equipWnd ~= nil and window.equipWnd:IsEnabled())
        else
          equipSlot:SetAlpha(0.3)
          equipSlot:Enable(false)
        end
      end
    end
  end
  function window:SlaveEquipPostInit()
    local autoToggle = X2:GetAutoToggleSlaveEquipmentUiData()
    self:Show(autoToggle)
    autoToggleBtn:SetChecked(autoToggle, false)
  end
  local equipWnd = CreateSlaveEquipmentPanel(window)
  equipWnd:AddAnchor("TOP", window, 0, titleMargin - sideMargin / 2)
  window.equipWnd = equipWnd
  autoToggleBtn:AddAnchor("TOPLEFT", equipWnd, "BOTTOMLEFT", 5, 3)
  local possibleWnd = equipWnd:CreateChildWidget("emptywidget", "possibleWnd", 0, true)
  possibleWnd:SetExtent(40, 40)
  possibleWnd:AddAnchor("TOPRIGHT", equipWnd, -2, 0)
  local possible = possibleWnd:CreateDrawable(TEXTURE_PATH.SLAVE_ETC, "possible", "background")
  possible:AddAnchor("TOPRIGHT", equipWnd, -2, 0)
  equipWnd.possible = possible
  local changable
  function window:ShowProc()
    self:CheckPossibleToChange()
  end
  function window:CheckPossibleToChange()
    local can = X2SiegeWeapon:CanExchangeSlaveEquipment()
    local blueColor = FONT_COLOR_HEX.SKYBLUE
    if can then
      possible:SetTextureInfo("possible")
      equipWnd:Enable(true)
      possibleWnd.tooltip = GetCommonText("enable_to_exchange_equip", blueColor)
    else
      possible:SetTextureInfo("impossible")
      equipWnd:Enable(false)
      possibleWnd.tooltip = X2Util:ApplyUIMacroString(GetCommonText("disable_to_exchange_equip", FONT_COLOR_HEX.RED, blueColor))
    end
    if changable ~= can then
      changable = can
      for i = 1, #equipWnd.slots do
        if equipWnd.slots[i].Update ~= nil then
          equipWnd.slots[i]:Update(false)
        end
      end
    end
  end
  function possibleWnd:OnEnter()
    SetTooltip(self.tooltip, self)
  end
  possibleWnd:SetHandler("OnEnter", possibleWnd.OnEnter)
  function possibleWnd:OnLeave()
    HideTooltip()
  end
  possibleWnd:SetHandler("OnLeave", possibleWnd.OnLeave)
  ADDON:RegisterContentWidget(UIC_SLAVE_EQUIPMENT, window)
  window:Show(false)
  local slaveEquipEventHandler = {
    UPDATE_SLAVE_EQUIPMENT_SLOT = function(reload)
      for i = 1, #equipWnd.slots do
        local equipSlot = equipWnd.slots[i]
        if equipSlot.slotType ~= nil then
          equipSlot:Update(reload)
        end
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    slaveEquipEventHandler[event](...)
  end)
  RegistUIEvent(window, slaveEquipEventHandler)
  return window
end
