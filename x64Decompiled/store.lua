storeFrame = nil
function ToggleStore(show, openType)
  if show == nil then
    show = not storeFrame:IsVisible()
  end
  if openType == nil then
    openType = 0
  end
  X2Store:SetStoreOpenType(openType)
  storeFrame:Show(show)
  storeFrame:Init()
  if show == true then
    storeFrame:Raise()
    newbag:Raise()
  end
  return true
end
ADDON:RegisterContentTriggerFunc(UIC_STORE, ToggleStore)
function DirectOpenStore(openType)
  ToggleStore(true, openType)
end
local soldItemList
function CreateStoreFrame(id, parent)
  local window = SetViewOfStoreFrame(id, parent)
  local buyFrame = window.tab.window[1]
  local sellFrame = window.tab.window[2]
  local cartList = window.tab.window[1].cartList
  local rebuyList = window.rebuyWindow
  local cmdWindow = window.cmdWindow
  local rebuyButton = window.rebuyButton
  local rebuyWindow = window.rebuyWindow
  local spinner = window.tab.window[1].spinner
  local cartBag = {}
  function window:Init()
    STORE_CURRENCY, STORE_COIN_ITEM, STORE_COIN_ICON, STORE_COIN_ICON_KEY = X2Store:GetStoreCurrency()
    if STORE_CURRENCY == CURRENCY_GOLD or STORE_CURRENCY == CURRENCY_GOLD_WITH_AA_POINT then
      window.tab:SetActivateTabCount(2)
      self.rebuyButton:Show(true)
    else
      window.tab:SetActivateTabCount(1)
      self.rebuyButton:Show(false)
    end
    cmdWindow:Init(1)
    cartList:Init()
    buyFrame:Init(true)
    buyFrame:PageInit()
    X2Store:SoldItemList()
    spinner:Show(false)
    sellFrame:Init(true)
    rebuyList:Show(false)
    window.tab:SelectTab(1)
    InitLockToBagSlot()
    if self:IsVisible() then
      ADDON:ShowContent(UIC_BAG, true)
    end
  end
  function rebuyButton:OnClick()
    rebuyWindow:Show(not rebuyWindow:IsVisible())
    if rebuyWindow:IsVisible() then
      rebuyList:Update()
    end
  end
  rebuyButton:SetHandler("OnClick", rebuyButton.OnClick)
  function window.tab:OnTabChanged(selected)
    if selected == 1 then
      X2Store:ClearCursorOnStoreClose()
      X2Store:SoldItemList()
    elseif selected == 2 then
      X2Store:ClearCursorOnStoreClose()
      ADDON:ShowContent(UIC_BAG, true)
    end
    cmdWindow:Init(selected)
    ReAnhorTabLine(window.tab, selected)
  end
  window.tab:SetHandler("OnTabChanged", window.tab.OnTabChanged)
  local OnMouseDown = function(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    X2Store:ClearCursorOnStoreClose()
    return true
  end
  window:SetHandler("OnMouseDown", OnMouseDown)
  function window:OnHide()
    InitLockToBagSlot()
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
storeFrame = CreateStoreFrame("storeFrame", "UIParent")
storeFrame:Show(false)
local storeEvent = {
  TARGET_CHANGED = function()
    storeFrame:Show(false)
    X2Store:SetStoreOpenType(0)
  end,
  NPC_INTERACTION_END = function()
    storeFrame:Show(false)
    X2Store:SetStoreOpenType(0)
  end,
  STORE_ADD_SELL_ITEM = function(slotNumber)
    local sellFrame = storeFrame.tab.window[2]
    if sellFrame:HasItem(slotNumber) then
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.store.registedItem)
      return
    end
    if sellFrame:IsSellable(slotNumber) then
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.store.cantSell)
      AddMessageToSysMsgWindow(locale.store.cantSell)
      return
    end
    sellFrame:AppendItem(slotNumber)
  end,
  PLAYER_MONEY = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  PLAYER_AA_POINT = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  PLAYER_HONOR_POINT = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  PLAYER_LIVING_POINT = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  PLAYER_CONTRIBUTION_POINT = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  ADDED_ITEM = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  REMOVED_ITEM = function()
    storeFrame.cmdWindow:PlayerMoneyUpdate()
  end,
  BAG_UPDATE = function(bagId, slotId)
    local sellFrame = storeFrame.tab.window[2]
    if bagId == -1 or slotId == -1 then
      return
    end
    for i = 1, #sellFrame.sellList do
      local item = sellFrame.sellList[i]
      if item.slotNumber == slotId then
        sellFrame:DeleteItem(i, item.slotNumber)
        return
      end
    end
  end,
  STORE_SOLD_LIST = function(soldItems)
    local rebuyList = storeFrame.rebuyWindow
    if soldItems ~= nil then
      rebuyList:Update(soldItems)
      SOLDITEMLIST = soldItems
    end
  end,
  STORE_BUY = function(itemLinkText, stackCount)
    if stackCount > 1 then
      local nameText = string.format("%s%sx|,%d;", locale.store.buymsg, itemLinkText, stackCount)
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, nameText)
    else
      local nameText = string.format("%s%s", locale.store.buymsg, itemLinkText)
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, nameText)
    end
    storeFrame.cmdWindow:TotalMoney()
  end,
  STORE_SELL = function(itemLinkText, stackCount)
    if stackCount > 1 then
      local nameText = locale.store.sellmsg_stack(itemLinkText, stackCount)
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, nameText)
    else
      local nameText = string.format("%s%s", locale.store.sellmsg, itemLinkText)
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, nameText)
    end
    storeFrame.cmdWindow.totalMoney:Update("0")
  end,
  STORE_FULL = function()
    X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.store.noSlot)
  end,
  STORE_TRADE_FAILED = function()
    storeFrame.cmdWindow:TotalMoney()
  end
}
storeFrame:SetHandler("OnEvent", function(this, event, ...)
  storeEvent[event](...)
end)
RegistUIEvent(storeFrame, storeEvent)
function AddSellItem(curBagSlotNumber)
  local sellFrame = storeFrame.tab.window[2]
  if storeFrame:IsVisible() then
    if STORE_CURRENCY ~= CURRENCY_GOLD and STORE_CURRENCY ~= CURRENCY_GOLD_WITH_AA_POINT then
      if STORE_CURRENCY == CURRENCY_HONOR_POINT then
        AddMessageToSysMsgWindow(locale.store.disableSell)
      elseif STORE_CURRENCY == CURRENCY_LIVING_POINT then
        AddMessageToSysMsgWindow(locale.store.disableSellInLivingStore)
      end
      return true
    end
    if not sellFrame:IsVisible() then
      storeFrame.tab:SelectTab(2)
      storeFrame.cmdWindow:Init(2)
    end
    X2Store:StoreAddSellItemToBagSlot(curBagSlotNumber)
    return true
  end
  return false
end
