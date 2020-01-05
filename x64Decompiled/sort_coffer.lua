local cofferInven
local cofferAdepter = {}
function cofferAdepter:HandleClick(virtualSlotIdx)
  X2Coffer:HandleClick(virtualSlotIdx)
end
function cofferAdepter:HandleUse(virtualSlotIdx)
  X2Coffer:HandleUse(virtualSlotIdx)
end
function cofferAdepter:GetBagItemInfo(realSlotIdx, needInfo)
  if needInfo ~= nil then
    return X2Coffer:GetBagItemInfo(realSlotIdx, needInfo)
  end
  return X2Coffer:GetBagItemInfo(realSlotIdx)
end
function cofferAdepter:GetBagCooldown(realSlotIdx)
  return X2Bag:GetBagCooldown(realSlotIdx)
end
function cofferAdepter:ItemIdentifier(realSlotIdx)
  return X2Coffer:ItemIdentifier(realSlotIdx)
end
function cofferAdepter:IsLocked(realSlotIdx)
  return X2Coffer:IsLocked(realSlotIdx)
end
function cofferAdepter:IsConfirmedSlot(virtualSlotIdx)
  return X2Coffer:IsConfirmedSlot(virtualSlotIdx)
end
function cofferAdepter:IsInvalidSlot(virtualSlotIdx)
  return X2Coffer:IsInvalidSlot(virtualSlotIdx)
end
function cofferAdepter:SlotByIdx(virtualSlotIdx)
  return X2Coffer:SlotByIdx(virtualSlotIdx)
end
function cofferAdepter:CreateTab(iconIdx, tabDescText, itemGroupTypes)
  return X2Coffer:CreateTab(iconIdx, tabDescText, itemGroupTypes)
end
function cofferAdepter:EditTab(tabIdx, iconIdx, tabDescText, itemGroupTypes)
  return X2Coffer:EditTab(tabIdx, iconIdx, tabDescText, itemGroupTypes)
end
function cofferAdepter:SwitchTab(tabIdx)
  X2Coffer:SwitchTab(tabIdx)
end
function cofferAdepter:RemoveCurrentTab()
  X2Coffer:RemoveTab(X2Coffer:CurrentTabIdx())
end
function cofferAdepter:RemoveTab(tabIdx)
  X2Coffer:RemoveTab(tabIdx)
end
function cofferAdepter:Sort()
  X2Coffer:Sort()
end
function cofferAdepter:Slots()
  return X2Coffer:Slots()
end
function cofferAdepter:TabAddible()
  return X2Coffer:TabAddible()
end
function cofferAdepter:TabCount()
  return X2Coffer:TabCount()
end
function cofferAdepter:ItemDurability(realSlotIdx)
  local checkRepairable = false
  return X2Coffer:ItemDurability(realSlotIdx, checkRepairable)
end
function cofferAdepter:ItemRequireLevel(realSlotIdx)
  return X2Coffer:ItemRequireLevel(realSlotIdx)
end
function cofferAdepter:Confirm()
end
function cofferAdepter:OnHideProc()
  X2Coffer:CofferWindowClosed()
end
function cofferAdepter:OnEndFadeOutProc()
  cofferInven = nil
end
function cofferAdepter:TabInfo(tabIdx)
  local descText, iconIdx, filterGroups = X2Coffer:TabInfo(tabIdx)
  return descText, iconIdx, filterGroups
end
function cofferAdepter:TabInfos()
  local descTexts, icons = X2Coffer:TabInfos()
  return descTexts, icons
end
function cofferAdepter:CurrentTabIdx()
  return X2Coffer:CurrentTabIdx()
end
function cofferAdepter:ItemStackStr(realSlotIdx)
  local itemType, _ = X2Coffer:ItemIdentifier(realSlotIdx)
  if itemType == nil then
    return ""
  end
  if X2Item:IsStackable(itemType) == false then
    return ""
  end
  local count = X2Coffer:ItemStack(realSlotIdx)
  if count == nil or count <= 1 then
    return ""
  end
  return tostring(count)
end
function cofferAdepter:Capacity()
  return X2Coffer:Capacity()
end
function cofferAdepter:IsExpandable()
  return false
end
function cofferAdepter:ExpandBtnVisible()
  return false
end
function cofferAdepter:SetItemSlotForCooldown(btn, slot)
  btn:SetCofferItemSlot(slot)
end
function cofferAdepter:CanSaveMoney()
  return false
end
function cofferAdepter:ManualSort()
  X2Coffer:ManualSort()
end
function cofferAdepter:CanManualSort()
  return true
end
local cofferViewAdepter = {}
function cofferViewAdepter:GetTitleText()
  local text
  if X2Coffer:IsPrivateCoffer() then
    text = X2Coffer:GetHouseCofferName()
  else
    text = GetUIText(WINDOW_TITLE_TEXT, "coffer")
  end
  return text
end
function cofferViewAdepter:GetExpandButtonText()
  return locale.inven.expandCoffer
end
function cofferViewAdepter:CreateItemAndCapacityCounterLabel(id, parent)
  local widget = W_CTRL.CreateLabel(id, parent)
  widget:SetAutoResize(true)
  widget.style:SetAlign(ALIGN_RIGHT)
  widget.style:SetFontSize(FONT_SIZE.SMALL)
  local function cofferUpdateEvent(...)
    local itemCount = X2Coffer:CountItems()
    local capacity = X2Coffer:Capacity()
    widget:SetText(string.format("%d/%d", itemCount, capacity))
  end
  widget:SetHandler("OnEvent", function(this, event, ...)
    cofferUpdateEvent(...)
  end)
  widget:RegisterEvent("COFFER_UPDATE")
  cofferUpdateEvent()
  return widget
end
function cofferViewAdepter:CreateMoneyLabel(id, parent)
  return CreateEmptyWindow(id, parent)
end
function cofferViewAdepter:GetCurrency()
  return CURRENCY_GOLD
end
function cofferViewAdepter:CreateAAPointLabel(id, parent)
  return CreateEmptyWindow(id, parent)
end
function cofferViewAdepter:CreateStoreButton(parent)
  return nil
end
function cofferViewAdepter:CreateLootGachaButton(parent)
  return nil
end
function cofferViewAdepter:CreateLockButton(parent)
  return nil
end
function cofferViewAdepter:CreateItemGuideButton(parent)
  return nil
end
function cofferViewAdepter:CreateTipIcon(parent)
  return nil
end
function cofferViewAdepter:CreateEnchantButton(parent)
  return nil
end
function cofferViewAdepter:CreateRepairButton(parent)
  return nil
end
function cofferViewAdepter:CreateLookConvertButton(parent)
  return nil
end
local cofferInjector = {}
function cofferInjector:PreClickSlot(realSlot)
  if X2Input:IsShiftKeyDown() and X2Chat:IsActivatedChatInput() then
    local linkText = X2Coffer:GetLinkText(realSlot)
    if AddLinkItem(linkText) == true then
      return true
    end
  end
  return false
end
function cofferInjector:PreUseSlot(realSlot)
  if CofferItemToEmptyBagSlot(realSlot) then
    return true
  end
  return false
end
function cofferInjector:Show()
  ADDON:ShowContent(UIC_BAG, true)
end
local bagEvents = {
  COFFER_UPDATE = function(bagId, slotId)
    if cofferInven == nil then
      return
    end
    cofferInven:UpdateExtent()
    cofferInven:Update()
  end,
  COFFER_TAB_SORTED = function()
    if cofferInven == nil then
      return
    end
    cofferInven:Update()
  end,
  COFFER_TAB_SWITCHED = function()
    if cofferInven == nil then
      return
    end
    cofferInven:Update()
    cofferInven.tab:Update()
    cofferInven.tab:SetCurrentTab()
  end,
  COFFER_TAB_CREATED = function()
    if cofferInven == nil then
      return
    end
    cofferInven:Update()
    cofferInven.tab:Update()
    cofferInven.tab:SetCurrentTab()
  end,
  COFFER_TAB_REMOVED = function()
    if cofferInven == nil then
      return
    end
    cofferInven.tab:Update()
  end,
  ENTERED_WORLD = function()
    if cofferInven == nil then
      return
    end
    cofferInven:Update()
  end,
  INVEN_SLOT_SPLIT = function(invenType, slot)
    if cofferInven == nil then
      return
    end
    if invenType == "coffer" then
      local maxValue = X2Coffer:ItemStack(slot) - 1
      if maxValue < 0 then
        maxValue = 0
      end
      cofferInven.spinner:SetMinMaxValues(0, maxValue)
      cofferInven.spinner.oldSlot = slot
      cofferInven.spinner:Show(true)
    end
  end,
  COFFER_INTERACTION_END = function()
    if cofferInven ~= nil and cofferInven:IsVisible() then
      ToggleCofferInventory(false)
    end
  end,
  LEFT_LOADING = function()
    if cofferInven ~= nil and cofferInven:IsVisible() then
      ToggleCofferInventory(false)
    end
  end
}
function ToggleCofferInventory(isShow)
  if isShow == nil then
    show = cofferInven == nil and true or not cofferInven:IsVisible()
  end
  if isShow == true and cofferInven == nil then
    cofferInven = CreateInventory("cofferInven", "UIParent", cofferAdepter, cofferViewAdepter, cofferInjector, "coffer")
    cofferInven:AddAnchor("CENTER", "UIParent", 0, 0)
    cofferInven:SetSounds("coffer")
    cofferInven:EnableHidingIsRemove(true)
    cofferInven:SetCloseOnEscape(true, true)
    cofferInven.spinner = CreateSplitItemWindow("spinner", cofferInven)
    cofferInven.spinner:Show(false)
    cofferInven.spinner:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
    function cofferInven.spinner:Click()
      local amount = tonumber(self:GetText())
      X2Coffer:PickupCofferItemPartial(self.oldSlot, amount)
    end
    cofferInven:SetHandler("OnEvent", function(this, event, ...)
      bagEvents[event](...)
    end)
    RegistUIEvent(cofferInven, bagEvents)
  end
  if cofferInven ~= nil then
    cofferInven:Show(isShow)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_COFFER, ToggleCofferInventory)
local RetryPendedSubbagOpen = function()
  X2Coffer:RetryPendedOpen()
end
UIParent:SetEventHandler("COFFER_INTERACTION_END", RetryPendedSubbagOpen)
function BagItemToEmptyCofferSlot(slot)
  if cofferInven ~= nil and cofferInven:IsVisible() then
    X2Bag:MoveToEmptyCofferSlot(slot)
    return true
  end
  return false
end
