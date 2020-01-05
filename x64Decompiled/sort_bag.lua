local bagAdepter = {}
function bagAdepter:HandleClick(virtualSlotIdx)
  X2Bag:HandleClick(virtualSlotIdx)
end
function bagAdepter:HandleUse(virtualSlotIdx)
  X2Bag:HandleUse(virtualSlotIdx)
end
function bagAdepter:GetBagItemInfo(realSlotIdx, needInfo)
  if needInfo ~= nil then
    return X2Bag:GetBagItemInfo(1, realSlotIdx, needInfo)
  end
  return X2Bag:GetBagItemInfo(1, realSlotIdx)
end
function bagAdepter:GetBagCooldown(realSlotIdx)
  return X2Bag:GetBagCooldown(realSlotIdx)
end
function bagAdepter:ItemIdentifier(realSlotIdx)
  return X2Bag:ItemIdentifier(realSlotIdx)
end
function bagAdepter:IsLocked(realSlotIdx)
  return X2Bag:IsLocked(realSlotIdx)
end
function bagAdepter:IsConfirmedSlot(virtualSlotIdx)
  return X2Bag:IsConfirmedSlot(virtualSlotIdx)
end
function bagAdepter:IsInvalidSlot(virtualSlotIdx)
  return X2Bag:IsInvalidSlot(virtualSlotIdx)
end
function bagAdepter:SlotByIdx(virtualSlotIdx)
  return X2Bag:SlotByIdx(virtualSlotIdx)
end
function bagAdepter:CreateTab(iconIdx, tabDescText, itemGroupTypes)
  return X2Bag:CreateTab(iconIdx, tabDescText, itemGroupTypes)
end
function bagAdepter:EditTab(tabIdx, iconIdx, tabDescText, itemGroupTypes)
  X2Bag:EditTab(tabIdx, iconIdx, tabDescText, itemGroupTypes)
end
function bagAdepter:SwitchTab(tabIdx)
  X2Bag:SwitchTab(tabIdx)
end
function bagAdepter:RemoveCurrentTab()
  X2Bag:RemoveTab(X2Bag:CurrentTabIdx())
end
function bagAdepter:RemoveTab(tabIdx)
  X2Bag:RemoveTab(tabIdx)
end
function bagAdepter:Sort()
  X2Bag:Sort()
end
function bagAdepter:ManualSort()
  X2Bag:ManualSort()
end
function bagAdepter:Slots()
  return X2Bag:Slots()
end
function bagAdepter:TabCount()
  return X2Bag:TabCount()
end
function bagAdepter:ItemDurability(realSlotIdx)
  local checkRepairable = false
  return X2Bag:ItemDurability(realSlotIdx, checkRepairable)
end
function bagAdepter:ItemRequireLevel(realSlotIdx)
  return X2Bag:ItemRequireLevel(realSlotIdx)
end
function bagAdepter:Confirm()
  X2Bag:Confirm()
end
function bagAdepter:TabInfo(tabIdx)
  local descText, iconIdx, filterGroups = X2Bag:TabInfo(tabIdx)
  return descText, iconIdx, filterGroups
end
function bagAdepter:TabInfos()
  local descTexts, icons = X2Bag:TabInfos()
  return descTexts, icons
end
function bagAdepter:CurrentTabIdx()
  return X2Bag:CurrentTabIdx()
end
function bagAdepter:ItemStackStr(realSlotIdx)
  local itemType, _ = X2Bag:ItemIdentifier(realSlotIdx)
  if itemType == nil then
    return ""
  end
  if X2Item:IsStackable(itemType) == false then
    return ""
  end
  local count = X2Bag:ItemStack(realSlotIdx)
  if count == nil or count <= 1 then
    return ""
  end
  return tostring(count)
end
function bagAdepter:Capacity()
  return X2Bag:Capacity()
end
function bagAdepter:IsExpandable()
  local count = X2Bag:Capacity()
  local maxcount = X2Bag:ExpansionMaxSlotCount()
  if count == maxcount then
    return false
  end
  return true
end
function bagAdepter:ExpandBtnVisible()
  return true
end
function bagAdepter:Expand()
  X2Bag:Expand()
end
function bagAdepter:SetItemSlotForCooldown(btn, slot)
  btn:SetBagItemSlot(slot)
end
function bagAdepter:CanSaveMoney()
  return true
end
function bagAdepter:CanManualSort()
  return true
end
function bagAdepter:WindowClosed()
  X2DialogManager:Delete(DLG_TASK_EXPAND_INVENTORY)
  X2DialogManager:Delete(DLG_TASK_DESTROY_ITEM)
  X2DialogManager:Delete(DLG_TASK_CONVERT_ITEM)
  X2Craft:LeaveCraftOrderMode()
end
local bagViewAdepter = {}
function bagViewAdepter:GetTitleText()
  return locale.inven.bagTitle
end
function bagViewAdepter:GetExpandButtonText()
  return locale.inven.expandBag
end
function bagViewAdepter:CreateItemAndCapacityCounterLabel(id, parent)
  local widget = W_CTRL.CreateLabel(id, parent)
  widget:SetAutoResize(true)
  widget.style:SetAlign(ALIGN_RIGHT)
  widget.style:SetFontSize(FONT_SIZE.SMALL)
  local function bagUpdateEvent(...)
    local itemCount = X2Bag:CountItems()
    local capacity = X2Bag:Capacity()
    widget:SetText(string.format("%d/%d", itemCount, capacity))
  end
  widget:SetHandler("OnEvent", function(this, event, ...)
    bagUpdateEvent(...)
  end)
  widget:RegisterEvent("BAG_UPDATE")
  widget:RegisterEvent("BAG_EXPANDED")
  bagUpdateEvent()
  return widget
end
function bagViewAdepter:CreateMoneyLabel(id, parent)
  return W_MODULE:CreateFundInHand(id, parent, CURRENCY_GOLD)
end
function bagViewAdepter:GetCurrency()
  return X2Bag:GetCurrency()
end
function bagViewAdepter:CreateAAPointLabel(id, parent)
  local module = W_MODULE:CreateFundInHand(id, parent, CURRENCY_AA_POINT)
  local autoUseAAPoint = CreateCheckButton("autoUseAAPoint", module)
  autoUseAAPoint:AddAnchor("LEFT", module, 15, 1)
  module.title:RemoveAllAnchors()
  module.title:AddAnchor("LEFT", autoUseAAPoint, "RIGHT", 0, 0)
  function autoUseAAPoint:CheckBtnCheckChagnedProc(checked)
    X2Bag:SetAutoUseAAPoint(checked)
  end
  local OnEnter = function(self)
    SetTooltip(locale.tooltip.autoUseAAPoint, self)
  end
  autoUseAAPoint:SetHandler("OnEnter", OnEnter)
  local function autoAAPointUseEvent(use)
    autoUseAAPoint:SetChecked(use, false)
  end
  autoUseAAPoint:SetHandler("OnEvent", function(this, event, use)
    autoAAPointUseEvent(use)
  end)
  autoUseAAPoint:RegisterEvent("CHANGED_AUTO_USE_AAPOINT")
  function module:Procedure()
    autoUseAAPoint:SetChecked(X2Bag:GetAutoUseAAPoint(), false)
  end
  return module
end
function bagViewAdepter:CreateStoreButton(parent)
  return nil
end
function bagViewAdepter:CreateLootGachaButton(parent)
  local lootGachaBtn = parent:CreateChildWidget("button", "lootGachaButton", 0, true)
  ApplyButtonSkin(lootGachaBtn, BUTTON_CONTENTS.INVENTORY_LOOT_GACHA)
  local OnEnter = function(self)
    SetVerticalTooltip(GetUIText(WINDOW_TITLE_TEXT, "loot_gacha"), self)
  end
  lootGachaBtn:SetHandler("OnEnter", OnEnter)
  local ClickFunc = function(self)
    ToggleLootGachaWindow()
  end
  ButtonOnClickHandler(lootGachaBtn, ClickFunc)
  return lootGachaBtn
end
function bagViewAdepter:CreateLockButton(parent)
  local lockButton = parent:CreateChildWidget("button", "lockButton", 0, true)
  ApplyButtonSkin(lockButton, BUTTON_CONTENTS.INVENTORY_LOCK)
  local OnEnter = function(self)
    SetVerticalTooltip(GetUIText(WINDOW_TITLE_TEXT, "item_lock"), self)
  end
  lockButton:SetHandler("OnEnter", OnEnter)
  local LockButtonLeftClickFunc = function(self)
    if X2Item:CheckSecondPassword() and not X2Security:IsSecondPasswordCreated() then
      AddMessageToSysMsgWindow(GetUIText(ERROR_MSG, "SECOND_PASS_NOT_SETTED_MSG"))
      ToggleSecondPasswordWnd()
      return
    else
      ToggleItemLockWindow()
    end
  end
  ButtonOnClickHandler(lockButton, LockButtonLeftClickFunc)
  return lockButton
end
function bagViewAdepter:CreateEnchantButton(parent)
  local enchantBtn = parent:CreateChildWidget("button", "gradeEnchantBtn", 0, false)
  ApplyButtonSkin(enchantBtn, BUTTON_CONTENTS.INVENTORY_ENCHANT)
  local OnEnter = function(self)
    SetVerticalTooltip(GetUIText(WINDOW_TITLE_TEXT, "enchant"), self)
  end
  enchantBtn:SetHandler("OnEnter", OnEnter)
  local LeftClickFunc = function()
    ToggleEnchantWindow()
  end
  ButtonOnClickHandler(enchantBtn, LeftClickFunc)
  return enchantBtn
end
function bagViewAdepter:CreateRepairButton(parent)
  local repairBtn = parent:CreateChildWidget("button", "repairBtn", 0, false)
  ApplyButtonSkin(repairBtn, BUTTON_CONTENTS.INVENTORY_REPAIR)
  function repairBtn:Update()
    local enable = X2Bag:HasRepairAuthorityInBag()
    repairBtn:Enable(enable)
  end
  local OnEnter = function(self)
    if self:IsEnabled() then
      SetVerticalTooltip(GetUIText(REPAIR_TEXT, "ui_title"), self)
    else
      SetVerticalTooltip(GetCommonText("require_repair_authority_in_bag"), self)
    end
  end
  repairBtn:SetHandler("OnEnter", OnEnter)
  local RepairButtonLeftClickFunc = function()
    ToggleRepairWindow()
  end
  ButtonOnClickHandler(repairBtn, RepairButtonLeftClickFunc)
  local repairBtnEvents = {
    BUFF_UPDATE = function(action, target)
      if target == "character" then
        repairBtn:Update()
      end
    end
  }
  repairBtn:SetHandler("OnEvent", function(this, event, ...)
    repairBtnEvents[event](...)
  end)
  RegistUIEvent(repairBtn, repairBtnEvents)
  repairBtn:Update()
  return repairBtn
end
function bagViewAdepter:CreateLookConvertButton(parent)
  local lookConvertBtn = parent:CreateChildWidget("button", "lookConvertBtn", 0, false)
  ApplyButtonSkin(lookConvertBtn, BUTTON_CONTENTS.INVENTORY_CONVERT)
  local OnEnter = function(self)
    SetVerticalTooltip(GetUIText(WINDOW_TITLE_TEXT, "look_convert"), self)
  end
  lookConvertBtn:SetHandler("OnEnter", OnEnter)
  local RepairButtonLeftClickFunc = function()
    ToggleChangeItemLookWindow()
  end
  ButtonOnClickHandler(lookConvertBtn, RepairButtonLeftClickFunc)
  return lookConvertBtn
end
function bagViewAdepter:CreateItemGuideButton(parent)
  local itemGuideBtn = parent:CreateChildWidget("button", "itemGuideButton", 0, false)
  ApplyButtonSkin(itemGuideBtn, BUTTON_CONTENTS.INVENTORY_ITEM_GUIDE)
  local OnEnter = function(self)
    SetVerticalTooltip(GetUIText(COMMON_TEXT, "equip_item_guide"), self)
  end
  itemGuideBtn:SetHandler("OnEnter", OnEnter)
  local LeftClickFunc = function()
    ToggleItemGuide()
  end
  ButtonOnClickHandler(itemGuideBtn, LeftClickFunc)
  return itemGuideBtn
end
function bagViewAdepter:CreateTipIcon(parent)
  local guide = W_ICON.CreateGuideIconWidget(parent)
  local str = GetUIText(INVEN_TEXT, "bag_mouse_control_tip")
  if X2Player:GetFeatureSet().marketPrice then
    str = F_TEXT.SetEnterString(str, GetUIText(COMMON_TEXT, "additional_bag_mouse_control_tip"))
  end
  SetGuideTooltipIncludeItemGrade(guide, str)
  return guide
end
local bagInjector = {}
function bagInjector:PreClickSlot(realSlot)
  if not X2Input:IsShiftKeyDown() then
    return false
  end
  if X2Chat:IsActivatedChatInput() then
    local linkText = X2Bag:GetLinkText(realSlot)
    if AddLinkItem(linkText) == true then
      return true
    end
  end
  if auctionWindow and auctionWindow:IsVisible() then
    if not auctionWindow.tab.window[1]:IsVisible() then
      return false
    end
    local tipInfo = X2Bag:GetBagItemInfo(1, realSlot)
    if tipInfo ~= nil then
      auctionWindow.tab.window[1].searchFrame.nameEditbox:LinkText(tipInfo.name)
      return true
    end
  end
  if VisibleCraftFrame() then
    local tipInfo = X2Bag:GetBagItemInfo(1, realSlot)
    if tipInfo ~= nil then
      SetItemLinkCraftFrame(tipInfo.name)
      return true
    end
  end
  return false
end
function bagInjector:PreUseSlot(realSlot)
  if X2Cursor:GetCursorInfo() ~= nil then
    return false
  end
  if X2Input:IsControlKeyDown() then
    local itemType, itemGrade = X2Bag:ItemIdentifier(realSlot)
    if itemType == 0 then
      return true
    end
    if X2Player:GetFeatureSet().marketPrice then
      local tipInfo = bagAdepter:GetBagItemInfo(realSlot)
      if tipInfo.soul_bound == 1 then
        AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "disable_market_price_by_store_not_sellable_item"))
        return true
      end
      ShowMarketPriceWindow(itemType, itemGrade)
      return true
    end
    return true
  end
  if AddSellItem(realSlot) then
    return true
  end
  if PutupTradeItem(realSlot) then
    return true
  end
  if AddMailItem(1, realSlot) then
    return true
  end
  if BagItemToEmptyBankSlot(realSlot) then
    return true
  end
  if BagItemToEmptyCofferSlot(realSlot) then
    return true
  end
  if AttachItemToAuction(realSlot) then
    return true
  end
  return false
end
function bagInjector:Update(realSlot)
  if UpdateSlaveEquipChangeItemColor ~= nil and UpdateSlaveEquipChangeItemColor(realSlot) then
    return
  end
  if UpdateSecurityLockItemColor ~= nil and UpdateSecurityLockItemColor(realSlot) then
    return
  end
  if UpdateSecurityUnlockItemColor ~= nil and UpdateSecurityUnlockItemColor(realSlot) then
    return
  end
  local isInteractionMode, enable = X2Bag:IsBagSlotDimCheck(realSlot.realSlotIdx)
  if isInteractionMode == true then
    realSlot:Enable(enable)
  end
end
function bagInjector:Show()
end
function bagInjector:Hide()
end
newbag = CreateInventory("bag", "UIParent", bagAdepter, bagViewAdepter, bagInjector)
newbag:Show(false)
newbag:AddAnchor("RIGHT", -30, 0)
newbag:SetCloseOnEscape(true)
newbag:SetSounds("bag")
newbag.spinner = CreateSplitItemWindow("bagWindow.bagSpinner", "UIParent")
newbag.spinner:Show(false)
newbag.spinner:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
function IsActivatedItemSecurityLock()
  return newbag.itemLockWnd ~= nil and newbag.itemLockWnd:IsVisible()
end
function newbag.spinner:Click()
  local amount = tonumber(self:GetText())
  X2Bag:PickupBagItemPartial(1, self.oldSlot, amount)
end
local ShowBag = function(show)
  if show == nil then
    show = not newbag:IsVisible()
  end
  newbag:Show(show)
end
ADDON:RegisterContentWidget(UIC_BAG, newbag, ShowBag)
local bagEvents = {
  BAG_UPDATE = function(bagId, slotId)
    if bagId == -1 or slotId == -1 then
      newbag:Update()
    end
  end,
  BAG_TAB_SORTED = function()
    newbag:Update()
  end,
  BAG_TAB_SWITCHED = function()
    newbag:Update()
    newbag.tab:Update()
    newbag.tab:SetCurrentTab()
  end,
  BAG_TAB_CREATED = function()
    newbag:Update()
    newbag.tab:Update()
    newbag.tab:SetCurrentTab()
  end,
  BAG_TAB_REMOVED = function()
    newbag.tab:Update()
  end,
  BAG_ITEM_CONFIRMED = function()
    newbag:Update()
  end,
  ENTERED_WORLD = function()
    newbag:Update()
  end,
  LEFT_LOADING = function()
    newbag:Update()
    X2DialogManager:Delete(DLG_TASK_CONVERT_ITEM)
    X2DialogManager:Delete(DLG_TASK_RECHARGE_ITEM)
    X2DialogManager:Delete(DLG_TASK_SKINIZE_ITEM)
  end,
  BAG_REAL_INDEX_SHOW = function(isRealSlotShow)
    bagAdepter.isRealSlotShow = isRealSlotShow
    newbag:Update()
  end,
  INVEN_SLOT_SPLIT = function(invenType, slot)
    if invenType == "bag" then
      local maxValue = X2Bag:ItemStack(slot) - 1
      if maxValue < 0 then
        maxValue = 0
      end
      newbag.spinner:SetMinMaxValues(0, maxValue)
      newbag.spinner.oldSlot = slot
      newbag.spinner:Show(true)
    end
  end,
  BAG_EXPANDED = function()
    newbag:Update()
    newbag:UpdateExtent()
    if X2Bag:Capacity() ~= X2Bag:ExpansionMaxSlotCount() then
      newbag.expandBtn:OnClick()
    else
      newbag.expandBtn:Enable(false)
    end
  end,
  BAG_LOCK_UPDATE = function(slotId)
    newbag:UpdateAt(slotId)
  end,
  UPDATE_ENCHANT_ITEM_MODE = function()
    newbag:Update()
  end,
  UPDATE_GACHA_LOOT_MODE = function()
    newbag:Update()
  end,
  UPDATE_ITEM_LOOK_CONVERT_MODE = function()
    newbag:Update()
  end,
  ENTER_SLAVE_EQUIP_CHANGE_MODE = function()
    newbag:Update()
  end,
  LEAVE_SLAVE_EQUIP_CHANGE_MODE = function()
    newbag.leaveSlaveEquipChangeItemMode = true
    newbag:Update()
    newbag.leaveSlaveEquipChangeItemMode = nil
  end,
  ENTER_SECURITY_LOCK_ITEM_MODE = function()
    newbag:Update()
  end,
  LEAVE_SECURITY_LOCK_ITEM_MODE = function()
    newbag.leaveSecurityLockItemMode = true
    newbag:Update()
    newbag.leaveSecurityLockItemMode = nil
  end,
  ENTER_SECURITY_UNLOCK_ITEM_MODE = function()
    newbag:Update()
  end,
  LEAVE_SECURITY_UNLOCK_ITEM_MODE = function()
    newbag.leaveSecurityUnlockItemMode = true
    newbag:Update()
    newbag.leaveSecurityUnlockItemMode = nil
  end,
  UI_PERMISSION_UPDATE = function()
    newbag:UpdatePermission()
  end
}
newbag:SetHandler("OnEvent", function(this, event, ...)
  bagEvents[event](...)
end)
RegistUIEvent(newbag, bagEvents)
function BankItemToEmptyBagSlot(slot)
  if newbag:IsVisible() then
    X2Bank:MoveToEmptyBagSlot(slot)
    return true
  end
  return false
end
function CofferItemToEmptyBagSlot(slot)
  if newbag:IsVisible() then
    X2Coffer:MoveToEmptyBagSlot(slot)
    return true
  end
  return false
end
function UpdateSlaveEquipChangeItemColor(realSlot)
  if newbag.leaveSlaveEquipChangeItemMode ~= nil then
    enable = true
  elseif X2Item:IsInSlaveEquipChangeMode() then
    enable = X2Item:IsSlaveEquipChangable(realSlot.realSlotIdx)
  else
    return false
  end
  realSlot:Enable(enable)
  return false
end
function UpdateSecurityLockItemColor(realSlot)
  if newbag.leaveSecurityLockItemMode ~= nil then
    enable = true
  elseif X2Item:IsInSecurityLockMode() then
    enable = X2Item:IsSecurityLockable(realSlot.realSlotIdx)
  else
    return false
  end
  realSlot:Enable(enable)
  return false
end
function UpdateSecurityUnlockItemColor(realSlot)
  if newbag.leaveSecurityUnlockItemMode ~= nil then
    enable = true
  elseif X2Item:IsInSecurityUnlockMode() then
    enable = X2Item:IsSecurityUnlockable(realSlot.realSlotIdx)
  else
    return false
  end
  realSlot:Enable(enable)
  return false
end
function InitLockToBagSlot()
  for slotNumber = 1, X2Bag:GetBagNumSlots(1) + 1 do
    X2Bag:UnlockSlot(slotNumber)
  end
end
