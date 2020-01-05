function CreateCMDWindow(id, parent)
  local window = SetViewOfCMDWindow(id, parent)
  local submitButton = window.submitButton
  local cancelButton = window.cancelButton
  local drainButton = window.drainButton
  local function WarningEmptyCart(selectedTab)
    local buyFrame = parent.tab.window[1]
    local sellFrame = parent.tab.window[2]
    if selectedTab == 1 then
      if GetCartEmptySlotCount(buyFrame.cartBag) == 10 then
        AddMessageToSysMsgWindow(locale.store.emptyCartListMsg)
        return
      end
    elseif selectedTab == 2 and GetSellEmptySlotNumber(sellFrame.sellList) == 1 then
      AddMessageToSysMsgWindow(locale.store.emptySellListMsg)
      return
    end
  end
  function window:ShowAAPointView(show)
    if self.totalAAPoint ~= nil then
      self.totalAAPoint:Show(show)
      self.playerAAPoint:Show(show)
      if show == false then
        self.totalMoney:RemoveAllAnchors()
        self.totalMoney:AddAnchor("BOTTOMLEFT", self.totalMoneyTitle, "BOTTOMRIGHT", 5, 10)
        self.playerMoney:RemoveAllAnchors()
        self.playerMoney:AddAnchor("TOPRIGHT", self.totalMoney, "BOTTOMRIGHT", 0, -11)
      else
        self.totalMoney:RemoveAllAnchors()
        self.totalMoney:AddAnchor("BOTTOMLEFT", self.totalAAPoint, "BOTTOMRIGHT", 10, 0)
        self.totalMoney:SetTitle(GetUIText(REPAIR_TEXT, "myMoney"))
        self.playerMoney:RemoveAllAnchors()
        self.playerMoney:AddAnchor("BOTTOMLEFT", self.playerAAPoint, "BOTTOMRIGHT", 10, 0)
      end
    end
  end
  function window:Init(selected)
    if STORE_CURRENCY == CURRENCY_HONOR_POINT or STORE_CURRENCY == CURRENCY_LIVING_POINT or STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT or STORE_CURRENCY == CURRENCY_ITEM_POINT then
      self:ShowAAPointView(false)
    else
      self:ShowAAPointView(true)
    end
    if selected == 1 then
      submitButton:CHANGE_BUY_EVENT()
      self.playerMoneyTitle:SetText(locale.store.buy_left_money)
      self.totalMoneyTitle:SetText(locale.store.buyTotalMoney)
    elseif selected == 2 then
      submitButton:CHANGE_SELL_EVENT()
      self.totalMoneyTitle:SetText(locale.store.sellTotalMoney)
      self.playerMoneyTitle:SetText(locale.store.sell_left_money)
    end
    window:TotalMoney()
  end
  function window:ItemPrice(tip)
    local price = tip.cost
    if price == nil or price == 0 then
      if STORE_CURRENCY == CURRENCY_HONOR_POINT then
        price = tip.honorPrice
      elseif STORE_CURRENCY == CURRENCY_LIVING_POINT then
        price = tip.livingPointPrice
      elseif STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT then
        price = tip.contributionPointPrice
      end
    end
    return price
  end
  function window:CheckBundlePriceOverLimit(info, count, msg)
    local price
    if type(info) == "number" or type(info) == "string" then
      price = info
    else
      price = window:ItemPrice(info)
    end
    if F_CALC.MulNum(price, count) == nil then
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
      AddMessageToSysMsgWindow(msg)
      return false
    end
    return true
  end
  function window:TotalMoney()
    local total = 0
    local aaPointTotal = 0
    local buyFrame = parent.tab.window[1]
    local sellFrame = parent.tab.window[2]
    if parent.tab:GetSelectedTab() == 1 then
      for i = 1, #buyFrame.cartBag do
        local bag = buyFrame.cartBag[i]
        if bag[1] ~= nil then
          local tip = bag[1]
          local stackCount = bag[2]
          local price = window:ItemPrice(tip)
          local bundle = F_CALC.MulNum(price, stackCount)
          if bundle ~= nil then
            total = F_CALC.AddNum(total, bundle)
          end
        end
      end
      local finalRemain
      if STORE_CURRENCY == CURRENCY_HONOR_POINT then
        finalRemain = F_CALC.SubNum(X2Player:GetGamePoints().honorPointStr, total)
        self.playerMoney:UpdateHonorPoint(finalRemain)
      elseif STORE_CURRENCY == CURRENCY_LIVING_POINT then
        finalRemain = F_CALC.SubNum(X2Player:GetGamePoints().livingPointStr, total)
        self.playerMoney:UpdateLivingPoint(finalRemain)
      elseif STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT then
        finalRemain = F_CALC.SubNum(X2Player:GetGamePoints().contributionPointStr, total)
        self.playerMoney:UpdateContributionPoint(finalRemain)
      elseif STORE_CURRENCY == CURRENCY_ITEM_POINT then
        local coinCount = X2Item:Count(STORE_COIN_ITEM)
        finalRemain = F_CALC.SubNum(coinCount, total)
        self.playerMoney:UpdateItemPoint(finalRemain, STORE_COIN_ICON, STORE_COIN_ICON_KEY)
      else
        local gold, aaPoint
        if STORE_CURRENCY == CURRENCY_AA_POINT then
          aaPointTotal = total
          total = 0
          aaPoint = F_CALC.SubNum(X2Util:GetMyAAPointString(), aaPointTotal)
          gold = X2Util:GetMyMoneyString()
          finalRemain = aaPoint
        elseif STORE_CURRENCY == CURRENCY_GOLD_WITH_AA_POINT then
          gold = F_CALC.SubNum(X2Util:GetMyMoneyString(), total)
          aaPoint = X2Util:GetMyAAPointString()
          if 0 > tonumber(gold) then
            aaPointTotal = F_CALC.SubNum(0, gold)
            aaPoint = F_CALC.SubNum(aaPoint, aaPointTotal)
            gold = 0
            total = X2Util:GetMyMoneyString()
          end
          finalRemain = aaPoint
        else
          aaPointTotal = 0
          aaPoint = X2Util:GetMyAAPointString()
          gold = F_CALC.SubNum(X2Util:GetMyMoneyString(), total)
          finalRemain = gold
        end
        if self.playerAAPoint ~= nil then
          self.playerAAPoint:UpdateAAPoint(aaPoint)
        end
        self.playerMoney:Update(gold)
      end
      if 0 > tonumber(finalRemain) then
        self.submitButton:Enable(false)
      else
        self.submitButton:Enable(true)
      end
    elseif parent.tab:GetSelectedTab() == 2 then
      for i = 1, #sellFrame.sellList do
        local item = sellFrame.sellList[i]
        if item.slotNumber ~= nil then
          local info = X2Bag:GetBagItemInfo(1, item.slotNumber, IIK_SELL + IIK_STACK)
          if info ~= nil then
            local base = F_CALC.MulNum(info.stack or 1, info.refund)
            total = F_CALC.AddNum(total, base)
          else
            total = "0"
          end
        end
      end
      self.submitButton:Enable(true)
      local leftMoney = F_CALC.AddNum(X2Util:GetMyMoneyString(), total)
      self.playerMoney:Update(leftMoney)
    end
    if STORE_CURRENCY == CURRENCY_HONOR_POINT then
      self.totalMoney:UpdateHonorPoint(total)
    elseif STORE_CURRENCY == CURRENCY_LIVING_POINT then
      self.totalMoney:UpdateLivingPoint(total)
    elseif STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT then
      self.totalMoney:UpdateContributionPoint(total)
    elseif STORE_CURRENCY == CURRENCY_ITEM_POINT then
      self.totalMoney:UpdateItemPoint(total, STORE_COIN_ICON, STORE_COIN_ICON_KEY)
    else
      if self.totalAAPoint ~= nil then
        self.totalAAPoint:UpdateAAPoint(aaPointTotal)
      end
      self.totalMoney:Update(total, false)
    end
  end
  function window:PlayerMoneyUpdate()
    if STORE_CURRENCY == CURRENCY_HONOR_POINT then
      self.playerMoney:UpdateHonorPoint(X2Player:GetGamePoints().honorPointStr)
    elseif STORE_CURRENCY == CURRENCY_LIVING_POINT then
      self.playerMoney:UpdateLivingPoint(X2Player:GetGamePoints().livingPointStr)
    elseif STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT then
      self.playerMoney:UpdateContributionPoint(X2Player:GetGamePoints().contributionPointStr)
    elseif STORE_CURRENCY == CURRENCY_ITEM_POINT then
      local coinCount = X2Item:Count(STORE_COIN_ITEM)
      self.playerMoney:UpdateItemPoint(coinCount, STORE_COIN_ICON, STORE_COIN_ICON_KEY)
    else
      if self.playerAAPoint ~= nil then
        self.playerAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString())
      end
      self.playerMoney:Update(X2Util:GetMyMoneyString())
    end
  end
  function submitButton:CHANGE_BUY_EVENT()
    local buyFrame = parent.tab.window[1]
    submitButton:SetText(locale.store.buyAll)
    function self:OnClick(arg)
      if arg == "LeftButton" then
        X2Store:ClearCursorOnStoreClose()
        WarningEmptyCart(1)
        local stack = {}
        local goodIndex = {}
        local currencies = {}
        local valuedIndex = 1
        local totalCost = 0
        for i = 1, #buyFrame.cartList do
          local buyItem = buyFrame.cartBag[i]
          if buyItem[1] ~= nil then
            goodIndex[valuedIndex] = buyItem[1].goodIndex
            currencies[valuedIndex] = buyItem[1].currency
            stack[valuedIndex] = tonumber(buyItem[2])
            buyFrame.cartBag[i] = {}
            valuedIndex = valuedIndex + 1
            local price = buyItem[1].cost
            if price == nil or price == 0 then
              if STORE_CURRENCY == CURRENCY_HONOR_POINT then
                price = buyItem[1].honorPrice
              elseif STORE_CURRENCY == CURRENCY_LIVING_POINT then
                price = buyItem[1].livingPointPrice
              elseif STORE_CURRENCY == CURRENCY_CONTRIBUTION_POINT then
                price = buyItem[1].contributionPointPrice
              end
            end
            totalCost = totalCost + price * buyItem[2]
          end
        end
        X2Store:BuyStoreItemWithStack(goodIndex, stack, currencies)
        buyFrame.cartList:Init()
      end
    end
    self:SetHandler("OnClick", self.OnClick)
  end
  function submitButton:CHANGE_SELL_EVENT()
    local sellFrame = parent.tab.window[2]
    submitButton:SetText(locale.store.sellAll)
    function self:OnClick(arg)
      local items = {}
      local count = 0
      if arg == "LeftButton" then
        X2Store:ClearCursorOnStoreClose()
        for i = 1, #sellFrame.sellList do
          local item = sellFrame.sellList[i]
          if item.slotNumber ~= nil then
            count = count + 1
            items[count] = item.slotNumber
          end
        end
        X2Store:SellStoreItem(items, count, false)
        sellFrame:Init()
        InitLockToBagSlot()
      end
    end
    self:SetHandler("OnClick", self.OnClick)
  end
  function drainButton:OnClick(arg)
    if arg == "LeftButton" then
      local buyFrame = parent.tab.window[1]
      local sellFrame = parent.tab.window[2]
      X2Store:ClearCursorOnStoreClose()
      if parent.tab:GetSelectedTab() == 1 then
        WarningEmptyCart(1)
        buyFrame.cartList:Init()
      elseif parent.tab:GetSelectedTab() == 2 then
        WarningEmptyCart(2)
        sellFrame:Init()
      end
      window:TotalMoney()
    end
  end
  drainButton:SetHandler("OnClick", drainButton.OnClick)
  function drainButton:OnEnter()
    SetTooltip(locale.store.drain_tip, self)
  end
  drainButton:SetHandler("OnEnter", drainButton.OnEnter)
  function drainButton:OnLeave()
    HideTooltip()
  end
  drainButton:SetHandler("OnLeave", drainButton.OnLeave)
  return window
end
