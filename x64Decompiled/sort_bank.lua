local bankInven
function GetBankInventory()
  return bankInven
end
local bankAdepter = {}
function bankAdepter:HandleClick(virtualSlotIdx)
  X2Bank:HandleClick(virtualSlotIdx)
end
function bankAdepter:HandleUse(virtualSlotIdx)
  X2Bank:HandleUse(virtualSlotIdx)
end
function bankAdepter:GetBagItemInfo(realSlotIdx, needInfo)
  if needInfo ~= nil then
    return X2Bank:GetBagItemInfo(realSlotIdx, needInfo)
  end
  return X2Bank:GetBagItemInfo(realSlotIdx)
end
function bankAdepter:GetBagCooldown(realSlotIdx)
  return X2Bag:GetBagCooldown(realSlotIdx)
end
function bankAdepter:ItemIdentifier(realSlotIdx)
  return X2Bank:ItemIdentifier(realSlotIdx)
end
function bankAdepter:IsLocked(realSlotIdx)
  return X2Bank:IsLocked(realSlotIdx)
end
function bankAdepter:IsConfirmedSlot(virtualSlotIdx)
  return X2Bank:IsConfirmedSlot(virtualSlotIdx)
end
function bankAdepter:IsInvalidSlot(virtualSlotIdx)
  return X2Bank:IsInvalidSlot(virtualSlotIdx)
end
function bankAdepter:SlotByIdx(virtualSlotIdx)
  return X2Bank:SlotByIdx(virtualSlotIdx)
end
function bankAdepter:CreateTab(iconIdx, tabDescText, itemGroupTypes)
  return X2Bank:CreateTab(iconIdx, tabDescText, itemGroupTypes)
end
function bankAdepter:EditTab(tabIdx, iconIdx, tabDescText, itemGroupTypes)
  return X2Bank:EditTab(tabIdx, iconIdx, tabDescText, itemGroupTypes)
end
function bankAdepter:SwitchTab(tabIdx)
  X2Bank:SwitchTab(tabIdx)
end
function bankAdepter:RemoveCurrentTab()
  X2Bank:RemoveTab(X2Bank:CurrentTabIdx())
end
function bankAdepter:RemoveTab(tabIdx)
  X2Bank:RemoveTab(tabIdx)
end
function bankAdepter:Sort()
  X2Bank:Sort()
end
function bankAdepter:ManualSort()
  X2Bank:ManualSort()
end
function bankAdepter:Slots()
  return X2Bank:Slots()
end
function bankAdepter:TabCount()
  return X2Bank:TabCount()
end
function bankAdepter:ItemDurability(realSlotIdx)
  local checkRepairable = false
  return X2Bank:ItemDurability(realSlotIdx, checkRepairable)
end
function bankAdepter:ItemRequireLevel(realSlotIdx)
  return X2Bank:ItemRequireLevel(realSlotIdx)
end
function bankAdepter:Confirm()
end
function bankAdepter:TabInfo(tabIdx)
  local descText, iconIdx, filterGroups = X2Bank:TabInfo(tabIdx)
  return descText, iconIdx, filterGroups
end
function bankAdepter:TabInfos()
  local descTexts, icons = X2Bank:TabInfos()
  return descTexts, icons
end
function bankAdepter:CurrentTabIdx()
  return X2Bank:CurrentTabIdx()
end
function bankAdepter:ItemStackStr(realSlotIdx)
  local itemType, _ = X2Bank:ItemIdentifier(realSlotIdx)
  if itemType == nil then
    return ""
  end
  if X2Item:IsStackable(itemType) == false then
    return ""
  end
  local count = X2Bank:ItemStack(realSlotIdx)
  if count == nil or count <= 1 then
    return ""
  end
  return tostring(count)
end
function bankAdepter:Capacity()
  return X2Bank:Capacity()
end
function bankAdepter:IsExpandable()
  local count = X2Bank:Capacity()
  local maxcount = X2Bank:ExpansionMaxSlotCount()
  if count == maxcount then
    return false
  end
  return true
end
function bankAdepter:ExpandBtnVisible()
  return true
end
function bankAdepter:Expand()
  X2Bank:Expand()
end
function bankAdepter:SetItemSlotForCooldown(btn, slot)
  btn:SetBankItemSlot(slot)
end
function bankAdepter:CanSaveMoney()
  return true
end
function bankAdepter:CanManualSort()
  return true
end
function bankAdepter:OnHideProc()
  X2DialogManager:Delete(DLG_TASK_EXPAND_INVENTORY)
end
function bankAdepter:OnEndFadeOutProc()
  bankInven = nil
end
local bankViewAdepter = {}
function bankViewAdepter:GetTitleText()
  return GetUIText(WINDOW_TITLE_TEXT, "bank")
end
function bankViewAdepter:GetExpandButtonText()
  return locale.inven.expandCoffer
end
function bankViewAdepter:CreateItemAndCapacityCounterLabel(id, parent)
  local widget = W_CTRL.CreateLabel(id, parent)
  widget:SetAutoResize(true)
  widget.style:SetAlign(ALIGN_RIGHT)
  widget.style:SetFontSize(FONT_SIZE.SMALL)
  local function bankUpdateEvent(...)
    local itemCount = X2Bank:CountItems()
    local capacity = X2Bank:Capacity()
    widget:SetText(string.format("%d/%d", itemCount, capacity))
  end
  widget:SetHandler("OnEvent", function(this, event, ...)
    bankUpdateEvent(...)
  end)
  widget:RegisterEvent("BANK_UPDATE")
  widget:RegisterEvent("BANK_EXPANDED")
  bankUpdateEvent()
  return widget
end
function bankViewAdepter:CreateMoneyLabel(id, parent)
  local module = W_MODULE:Create(id, parent, WINDOW_MODULE_TYPE.VALUE_BOX)
  module:SetWidth(235)
  local function moneyEvent(...)
    local data = {
      type = "fund_in_hand",
      value = X2Util:GetMyBankMoneyString()
    }
    module:SetData(data)
  end
  module:SetHandler("OnEvent", function(this, event, ...)
    moneyEvent(event, ...)
  end)
  module:RegisterEvent("PLAYER_BANK_MONEY")
  moneyEvent()
  return module
end
function bankViewAdepter:GetCurrency()
  return X2Bank:GetCurrency()
end
function bankViewAdepter:CreateAAPointLabel(id, parent)
  local module = W_MODULE:Create(id, parent, WINDOW_MODULE_TYPE.VALUE_BOX)
  module:SetWidth(235)
  local function aaPointEvent(...)
    local data = {
      type = "cost",
      currency = CURRENCY_AA_POINT,
      value = X2Util:GetMyBankAAPointString()
    }
    module:SetData(data)
  end
  module:SetHandler("OnEvent", function(this, event, ...)
    aaPointEvent(...)
  end)
  module:RegisterEvent("PLAYER_BANK_AA_POINT")
  aaPointEvent()
  return module
end
function bankViewAdepter:CreateStoreButton(parent)
  local storeBtn = parent:CreateChildWidget("button", "storeBtn", 0, false)
  ApplyButtonSkin(storeBtn, BUTTON_CONTENTS.INVENTORY_STORE)
  local OnEnter = function(self)
    SetTooltip(locale.inven.paying_drawing, self)
  end
  storeBtn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  storeBtn:SetHandler("OnLeave", OnLeave)
  local function StoreBtnLeftClickFunc(self)
    if bankInven.storeWnd == nil then
      bankInven.storeWnd = CreateStoreWnd(bankInven)
      bankInven.storeWnd:Show(true)
      local function OnHide()
        bankInven.storeWnd = nil
      end
      bankInven.storeWnd:SetHandler("OnHide", OnHide)
    else
      bankInven.storeWnd:Show(not bankInven.storeWnd:IsVisible())
    end
  end
  ButtonOnClickHandler(storeBtn, StoreBtnLeftClickFunc)
  return storeBtn
end
function bankViewAdepter:CreateLootGachaButton(parent)
  return nil
end
function bankViewAdepter:CreateLockButton(parent)
  return nil
end
function bankViewAdepter:CreateItemGuideButton(parent)
  return nil
end
function bankViewAdepter:CreateTipIcon(parent)
  return nil
end
function bankViewAdepter:CreateEnchantButton(parent)
  return nil
end
function bankViewAdepter:CreateRepairButton(parent)
  return nil
end
function bankViewAdepter:CreateLookConvertButton(parent)
  return nil
end
local bankInjector = {}
function bankInjector:PreClickSlot(realSlot)
  if X2Input:IsShiftKeyDown() and X2Chat:IsActivatedChatInput() then
    local linkText = X2Bank:GetLinkText(realSlot)
    if AddLinkItem(linkText) == true then
      return true
    end
  end
  return false
end
function bankInjector:PreUseSlot(realSlot)
  if BankItemToEmptyBagSlot(realSlot) then
    return true
  end
  return false
end
local bagEvents = {
  BANK_UPDATE = function(bagId, slotId)
    if bankInven == nil then
      return
    end
    if bagId == -1 or slotId == -1 then
      bankInven:Update()
    end
  end,
  BANK_TAB_SORTED = function()
    if bankInven == nil then
      return
    end
    bankInven:Update()
  end,
  BANK_TAB_SWITCHED = function()
    if bankInven == nil then
      return
    end
    bankInven:Update()
    bankInven.tab:Update()
    bankInven.tab:SetCurrentTab()
  end,
  BANK_TAB_CREATED = function()
    if bankInven == nil then
      return
    end
    bankInven:Update()
    bankInven.tab:Update()
    bankInven.tab:SetCurrentTab()
  end,
  BANK_TAB_REMOVED = function()
    if bankInven == nil then
      return
    end
    bankInven.tab:Update()
  end,
  ENTERED_WORLD = function()
    if bankInven == nil then
      return
    end
    bankInven:Update()
  end,
  INVEN_SLOT_SPLIT = function(invenType, slot)
    if bankInven == nil then
      return
    end
    if invenType == "bank" then
      local maxValue = X2Bank:ItemStack(slot) - 1
      if maxValue < 0 then
        maxValue = 0
      end
      bankInven.spinner:SetMinMaxValues(0, maxValue)
      bankInven.spinner.oldSlot = slot
      bankInven.spinner:Show(true)
    end
  end,
  BANK_EXPANDED = function()
    if bankInven == nil then
      return
    end
    bankInven:Update()
    bankInven:UpdateExtent()
    if X2Bank:Capacity() ~= X2Bank:ExpansionMaxSlotCount() then
      bankInven.expandBtn:OnClick()
    end
  end,
  BANK_LOCK_UPDATE = function(slotId)
    if bankInven == nil then
      return
    end
    bankInven:UpdateAt(slotId)
  end,
  TARGET_CHANGED = function()
    if bankInven == nil then
      return
    end
    bankInven:Show(false)
  end,
  NPC_INTERACTION_END = function()
    if bankInven == nil then
      return
    end
    bankInven:Show(false)
  end
}
function ToggleBankInventory(isShow)
  if isShow == true and bankInven == nil then
    bankInven = CreateInventory("bankInven", "UIParent", bankAdepter, bankViewAdepter, bankInjector, "bank")
    bankInven:AddAnchor("CENTER", "UIParent", 0, 0)
    bankInven:SetSounds("bank")
    bankInven:SetCloseOnEscape(true, true)
    bankInven:EnableHidingIsRemove(true)
    function bankInven:Init()
      self:Update()
      self:Show(true)
    end
    bankInven.spinner = CreateSplitItemWindow("spinner", bankInven)
    bankInven.spinner:Show(false)
    bankInven.spinner:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
    function bankInven.spinner:Click()
      local amount = tonumber(self:GetText())
      X2Bank:PickupBankItemPartial(self.oldSlot, amount)
    end
    bankInven:SetHandler("OnEvent", function(this, event, ...)
      bagEvents[event](...)
    end)
    RegistUIEvent(bankInven, bagEvents)
  end
  if bankInven ~= nil then
    if isShow then
      bankInven:Update()
    end
    bankInven:Show(isShow)
  end
  return true
end
ADDON:RegisterContentTriggerFunc(UIC_BANK, ToggleBankInventory)
function BagItemToEmptyBankSlot(slot)
  if bankInven ~= nil and bankInven:IsVisible() then
    X2Bag:MoveToEmptyBankSlot(slot)
    return true
  end
  return false
end
