if X2Player:GetFeatureSet().preliminaryEquipment then
  do
    local masterParent = equippedItem
    local CanUseInBattlefield = function()
      if UIParent:GetPermission(UIC_PLAYER_EQUIPMENT) == false then
        AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_USE_IN_BATTLE_FIELD"))
        return false
      end
      return true
    end
    local prelimEquipWnd = CreatePreliminaryEquipmentsWindow("prelimEquipWnd", masterParent)
    masterParent.preliminaryEquipWnd = prelimEquipWnd
    local prelimEquipBtn = CreatePreliminaryEquipmentsButton("prelimEquipBtn", masterParent)
    prelimEquipBtn:AddAnchor("TOPRIGHT", masterParent.slot[16], "BOTTOMLEFT", 7, -13)
    prelimEquipWnd:AddAnchor("RIGHT", prelimEquipBtn, "LEFT", 2, -14)
    local function OnClickPrelimEquipBtn(self, arg)
      if not CanUseInBattlefield() then
        return
      end
      if arg == "LeftButton" then
        X2Equipment:SwapPrelimEquipments()
        return
      end
      if arg == "RightButton" then
        prelimEquipWnd:Show(not prelimEquipWnd:IsVisible())
        if prelimEquipWnd:IsVisible() then
          ADDON:ShowContent(UIC_BAG, true)
        end
        return
      end
    end
    prelimEquipBtn:SetHandler("OnClick", OnClickPrelimEquipBtn)
    local OnShowPrelimEquipWindow = function()
      X2Equipment:StartPrelimBagInteraction()
    end
    prelimEquipWnd:SetHandler("OnShow", OnShowPrelimEquipWindow)
    local OnHidePrelimEquipWindow = function()
      X2Equipment:EndPrelimBagInteraction()
    end
    prelimEquipWnd:SetHandler("OnHide", OnHidePrelimEquipWindow)
    for i = 1, #prelimEquipWnd.prelimSlots do
      local slot = prelimEquipWnd.prelimSlots[i]
      function slot:OnClickProc(arg)
        if not CanUseInBattlefield() then
          return
        end
        if arg == "LeftButton" then
          X2Equipment:PickupPreliminaryItem(self.slotType)
        end
        if arg == "RightButton" then
          X2Equipment:UnequipPreliminaryItem(self.slotType)
        end
      end
      function slot:OnDragStart()
        if not CanUseInBattlefield() then
          return
        end
        X2Equipment:PickupPreliminaryItem(self.slotType)
      end
      slot:SetHandler("OnDragStart", slot.OnDragStart)
      function slot:OnDragReceive()
        if not CanUseInBattlefield() then
          return
        end
        X2Equipment:PickupPreliminaryItem(self.slotType)
      end
      slot:SetHandler("OnDragReceive", slot.OnDragReceive)
      local lockButton = prelimEquipWnd.prelimLocks[i]
      local OnClickLockButton = function(self, arg)
        X2Equipment:SetPrelimSlotLock(self.slotType, not self.lockStatus)
      end
      lockButton:SetHandler("OnClick", OnClickLockButton)
    end
    function prelimEquipBtn:Update()
      self:SetBtnStatus(X2Equipment:HasAnyPrelimEquipments())
    end
    prelimEquipBtn:Update()
    function prelimEquipWnd:UpdatePrelimSlots()
      for i = 1, #self.prelimSlots do
        local slot = self.prelimSlots[i]
        local tooltip = X2Equipment:GetPreliminaryItemTooltipText(slot.slotType)
        slot:SetItemInfo(tooltip)
        slot.back:SetColor(1, 1, 1, 1)
      end
    end
    function prelimEquipWnd:UpdatePrelimLocks()
      local lockStatus = X2Equipment:GetPrelimSlotLockInfo()
      for i = 1, #self.prelimLocks do
        local slot = self.prelimSlots[i]
        local slotLock = self.prelimLocks[i]
        local buttonStatus = lockStatus[slotLock.slotType]
        slot:SetSlotLock(not buttonStatus.isDisabled and buttonStatus.isLocked)
        slotLock:SetSlotLock(buttonStatus.isLocked, buttonStatus.isDisabled)
      end
    end
    function prelimEquipWnd:Update()
      self:UpdatePrelimSlots()
      self:UpdatePrelimLocks()
    end
    prelimEquipWnd:Update()
    local prelimEquipEvents = {
      PRELIMINARY_EQUIP_UPDATE = function()
        prelimEquipBtn:Update()
        prelimEquipWnd:Update()
      end
    }
    prelimEquipWnd:SetHandler("OnEvent", function(this, event, ...)
      prelimEquipEvents[event](...)
    end)
    RegistUIEvent(prelimEquipWnd, prelimEquipEvents)
  end
end
