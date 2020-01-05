function CreateStoreBuyFrame(window, cmdWindow)
  SetViewOfStoreBuyFrame(window)
  local buyList = window.buyList
  local pageControl = window.pageControl
  local cartList = window.cartList
  local spinner = window.spinner
  window.cartBag = {}
  local function GetCartEmptySlotNumber()
    for i = 1, #window.cartBag do
      local bag = window.cartBag[i]
      if bag[1] == nil then
        return i
      end
    end
    return "full"
  end
  local function UseSpinner(itemInfo, maxStack)
    spinner:Show(true)
    spinner:SetMinMaxValues(1, maxStack)
    spinner.itemInfo = itemInfo
  end
  local ChangedCartItemInfo = function(bag, item, count)
    item:SetStack(tostring(count))
    bag[2] = count
  end
  function cartList:Init()
    local maxItem = STORE_MAX_CART_COL * STORE_MAX_CART_ROW
    for i = 1, maxItem do
      local item = cartList[i]
      item.itemIndex = nil
      item:Init()
      window.cartBag[i] = {}
    end
  end
  function cartList:AppendStackItem(itemInfo, selectedCount)
    local maxStack = itemInfo.maxStack
    local cartListCount = STORE_MAX_CART_COL * STORE_MAX_CART_ROW
    selectedCount = tonumber(selectedCount)
    if GetCartEmptySlotCount(window.cartBag) == cartListCount then
      if not cmdWindow:CheckBundlePriceOverLimit(itemInfo, selectedCount, GetCommonText("store_buy_money_limit")) then
        return
      end
      cartList:AppendItem(itemInfo, selectedCount)
      return
    end
    for i = 1, #window.cartBag do
      local bag = window.cartBag[i]
      if bag[1] ~= nil then
        local item = cartList[i]
        local curCount = bag[2]
        local bagIndex = bag[1].goodIndex
        local itemIndex = itemInfo.goodIndex
        if bagIndex == itemIndex and maxStack > curCount then
          local add = 0
          local total = curCount + selectedCount
          if maxStack < total then
            add = total - maxStack
          end
          if add > 0 then
            if not cmdWindow:CheckBundlePriceOverLimit(itemInfo, maxStack, GetCommonText("store_buy_money_limit")) then
              return
            end
            ChangedCartItemInfo(bag, item, maxStack)
            cartList:AppendItem(itemInfo, add)
          else
            if not cmdWindow:CheckBundlePriceOverLimit(itemInfo, total, GetCommonText("store_buy_money_limit")) then
              return
            end
            ChangedCartItemInfo(bag, item, total)
          end
          cmdWindow:TotalMoney()
          return
        end
      end
    end
    cartList:AppendItem(itemInfo, selectedCount)
  end
  function cartList:AppendItem(itemInfo, stackCount)
    local cartIndex = GetCartEmptySlotNumber()
    if cartIndex == "full" then
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.store.cartNoSlot)
      AddMessageToSysMsgWindow(locale.store.cartNoSlot)
      return
    end
    if itemInfo == nil then
      return
    end
    if STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT then
      local reqExpedLevel = X2Item:GetExpeditionLevelRequirement(itemInfo.itemType) or 0
      if reqExpedLevel ~= 0 then
        local myExpedLevel = X2Faction:GetMyExpeditionLevel() or 1
        if reqExpedLevel > myExpedLevel then
          local error_msg = X2Locale:LocalizeUiText(ERROR_MSG, "NOT_ENOUGH_EXPEDITION_LEVEL")
          AddMessageToSysMsgWindow(error_msg)
          return
        end
      end
    end
    local item = cartList[cartIndex]
    item:SetItemInfo(itemInfo)
    item:SetStack(tostring(stackCount))
    function item:OnClick(arg)
      HideTooltip()
      X2Store:ClearCursorOnStoreClose()
      self:Init()
      window.cartBag[cartIndex] = {}
      cmdWindow:TotalMoney()
    end
    item:SetHandler("OnClick", item.OnClick)
    window.cartBag[cartIndex] = {itemInfo, stackCount}
    cmdWindow:TotalMoney()
  end
  function window:ClearItem(index)
    local itemWindow = buyList[index]
    itemWindow:Init()
  end
  function window:Init(show)
    local maxItem = STORE_MAX_DEFAULT_ITEM_COLUMN * STORE_MAX_BUY_ROW
    for i = 1, maxItem do
      local item = buyList[i]
      item:Init()
      item:Show(show)
    end
  end
  function window:AppendItem(index, itemInfo, itemIndex)
    local item = buyList[index]
    item:Show(true)
    item:Update(itemInfo)
    item:SetTooltip(itemInfo)
    local button, icon = item:GetButton()
    function button:OnClick(arg)
      if icon.info == nil then
        return
      end
      if itemInfo ~= nil and itemInfo.isStackable then
        if arg == "LeftButton" and X2Input:IsShiftKeyDown() then
          UseSpinner(itemInfo, itemInfo.maxStack)
        else
          cartList:AppendStackItem(itemInfo, 1)
        end
        return
      end
      cartList:AppendItem(itemInfo, 1)
    end
    button:SetHandler("OnClick", button.OnClick)
    function icon:OnClickProc(arg)
      button:OnClick(arg)
    end
  end
  function window:Update(pageIndex)
    local items = X2Store:GetStoreNpcItemList()
    if items == nil then
      return
    end
    local maxItem = STORE_MAX_DEFAULT_ITEM_COLUMN * STORE_MAX_BUY_ROW
    local curItemIndex = (pageIndex or 0) * maxItem
    local itemIndex = 1 + curItemIndex
    for i = 1, maxItem do
      local item = items[itemIndex]
      self:ClearItem(i)
      self:AppendItem(i, item, itemIndex)
      itemIndex = itemIndex + 1
    end
  end
  function window:PageInit()
    local itemCount = X2Store:GetStoreNpcItemList(true)
    local maxItem = STORE_MAX_DEFAULT_ITEM_COLUMN * STORE_MAX_BUY_ROW
    pageControl:SetCurrentPage(1, false)
    pageControl:SetPageByItemCount(itemCount, maxItem)
    pageControl:Refresh()
  end
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    if self.maxPage == pageIndex then
      window:Init(true)
    end
    window:Update(pageIndex - 1)
  end
  function spinner:Click()
    local count = spinner:GetText()
    cartList:AppendStackItem(spinner.itemInfo, count)
  end
end
