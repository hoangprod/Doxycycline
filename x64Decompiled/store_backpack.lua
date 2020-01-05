local backpackStore = CreateBackpackStoreWindow("backpackStore", "UIParent")
backpackStore:Show(false)
backpackStore:AddAnchor("CENTER", "UIParent", 0, 0)
local function ShowBackpackStoreWindow(show)
  if not show then
    backpackStore:Show(false)
    return
  end
  local info = X2Equipment:GetBackPackGoodsInfo("player")
  if info == nil then
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "STORE_BACKPACK_NOGOODS"))
    backpackStore:Show(false)
    return
  end
  local slotIdx = ES_BACKPACK
  local tooltip = X2Equipment:GetEquippedItemTooltipText("player", slotIdx)
  if tooltip == nil then
    return
  end
  backpackStore.itemIcon:SetItemInfo(tooltip)
  local str = string.format([[

|m%d;]], tonumber(tooltip.refund))
  backpackStore.itemPrice:SetText(str)
  backpackStore.itemPrice:SetHeight(backpackStore.itemPrice:GetTextHeight())
  backpackStore:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_TRADER, ShowBackpackStoreWindow)
local function LeftButtonLeftClickFunc()
  X2Store:SellBackPackGoods()
  backpackStore:Show(false)
end
backpackStore.leftButton:SetHandler("OnClick", LeftButtonLeftClickFunc)
backpackStore.rightButton:SetHandler("OnClick", function()
  backpackStore:Show(false)
end)
local events = {
  NPC_INTERACTION_END = function()
    backpackStore:Show(false)
  end,
  UNIT_EQUIPMENT_CHANGED = function(equipSlot)
    if backpackStore:IsVisible() == false then
      return
    end
    if equipSlot == ES_BACKPACK then
      backpackStore:Show(false)
    end
  end
}
backpackStore:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
backpackStore:RegisterEvent("NPC_INTERACTION_END")
backpackStore:RegisterEvent("UNIT_EQUIPMENT_CHANGED")
