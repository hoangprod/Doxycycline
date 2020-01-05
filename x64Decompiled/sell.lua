function CreateStoreSellFrame(window, cmdWindow)
  SetViewOfStoreSellFrame(window)
  local sellList = window.sellList
  function window:Init(show)
    local maxItem = STORE_MAX_DEFAULT_ITEM_COLUMN * STORE_MAX_SELL_ROW
    for i = 1, #sellList do
      local item = sellList[i]
      if item ~= nil and item.slotNumber ~= nil then
        X2Bag:UnlockSlot(item.slotNumber)
      end
      item:Init(nil)
      item.slotNumber = nil
      item:Show(show or true)
    end
  end
  function window:HasItem(slotNumber)
    for i = 1, #sellList do
      local item = sellList[i]
      if item.slotNumber == slotNumber then
        return true
      end
    end
    return false
  end
  function window:IsSellable(slotNumber)
    local itemInfo = X2Bag:GetBagItemInfo(1, slotNumber, IIK_SELL + IIK_STACK)
    local sellable = itemInfo.sellable
    if sellable ~= nil and sellable ~= true then
      return true
    end
    return false
  end
  function window:DeleteItem(index, slotNumber)
    sellList[index]:Init()
    sellList[index].slotNumber = nil
    X2Bag:UnlockSlot(slotNumber)
    cmdWindow:TotalMoney()
  end
  function window:AppendItem(slotNumber)
    local sellIndex = GetSellEmptySlotNumber(window.sellList)
    if sellIndex == "full" then
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.store.sellNoSlot)
      return
    end
    local itemInfo = X2Bag:GetBagItemInfo(1, slotNumber)
    local item = sellList[sellIndex]
    if not cmdWindow:CheckBundlePriceOverLimit(itemInfo.refund, itemInfo.stack or 1, GetCommonText("store_sell_money_limit")) then
      return
    end
    itemInfo.cost = F_CALC.MulNum(itemInfo.refund, itemInfo.stack or 1)
    item:Update(itemInfo)
    item.slotNumber = slotNumber
    function item:OnEnter()
      if item.slotNumber ~= nil then
        item:SetTooltip(itemInfo)
      end
    end
    item:SetHandler("OnEnter", item.OnEnter)
    function item:OnLeave()
      HideTooltip()
    end
    item:SetHandler("OnLeave", item.OnLeave)
    local button, icon = item:GetButton()
    function button:OnClick(arg)
      HideTooltip()
      X2Store:ClearCursorOnStoreClose()
      window:DeleteItem(sellIndex, slotNumber)
    end
    button:SetHandler("OnClick", button.OnClick)
    function icon:OnClick(arg)
      button:OnClick(arg)
    end
    icon:SetHandler("OnClick", icon.OnClick)
    cmdWindow:TotalMoney()
    X2Bag:LockSlot(slotNumber)
  end
end
