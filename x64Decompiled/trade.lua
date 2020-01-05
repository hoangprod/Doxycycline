local tradeWindow = trade.window
local myTradePanel = tradeWindow.myPanel
local targetTradePanel = tradeWindow.targetPanel
local ReplaceMaxValue = function(strNum, maxNumber)
  if maxNumber ~= nil and maxNumber < tonumber(strNum) then
    strNum = string.format("%d", maxNumber)
  end
  return strNum
end
local function SetTradeLockBtnEnable(enable)
  myTradePanel.tradeDecision:Enable(enable)
  if enable then
    myTradePanel.tradeDecision:SetAlpha(1)
  else
    myTradePanel.tradeDecision:SetAlpha(0.5)
    myTradePanel.tradeDecision:SetHandler("OnUpdate", myTradePanel.tradeDecision.OnUpdate)
  end
end
local delayTime = 0
local maxDelayTime = 1000
function myTradePanel.tradeDecision:OnUpdate(dt)
  delayTime = delayTime + dt
  if delayTime >= maxDelayTime then
    if X2Trade:CanLock() then
      SetTradeLockBtnEnable(true)
      self:ReleaseHandler("OnUpdate")
    end
    delayTime = 0
  end
end
local function LockMoney(lock)
  local enable = not lock
  myTradePanel.moneyEditor.goldEdit:Enable(enable)
  myTradePanel.moneyEditor.silverEdit:Enable(enable)
  myTradePanel.moneyEditor.copperEdit:Enable(enable)
end
local function CLEAR_TRADE_ITEM(my, index)
  if my == true then
    if myTradePanel.tradeSlot.item[index].inventoryIdx ~= nil then
      X2Bag:UnlockSlot(myTradePanel.tradeSlot.item[index].inventoryIdx)
    end
    myTradePanel.tradeSlot.item[index].inventoryIdx = nil
    myTradePanel.tradeSlot.item[index].tradeStack = 0
    myTradePanel.tradeSlot.item[index].tooltip = nil
    myTradePanel.tradeSlot.item[index]:Init()
    myTradePanel.tradeSlot.item[index]:SetStack("")
  else
    targetTradePanel.tradeSlot.item[index].otherIdx = nil
    targetTradePanel.tradeSlot.item[index].tradeType = nil
    targetTradePanel.tradeSlot.item[index].tradeStack = 0
    targetTradePanel.tradeSlot.item[index].tooltip = nil
    targetTradePanel.tradeSlot.item[index]:Init()
    targetTradePanel.tradeSlot.item[index]:SetStack("")
  end
end
local function CLEAR_TRADE_UI()
  for i = 1, #targetTradePanel.tradeSlot.item do
    CLEAR_TRADE_ITEM(false, i)
  end
  targetTradePanel.moneyModule:SetMoney(0)
  for i = 1, #myTradePanel.tradeSlot.item do
    CLEAR_TRADE_ITEM(true, i)
  end
  myTradePanel.moneyEditor:SetAmountStr("0")
  if tradeWindow.exchangeFeeModule ~= nil then
    tradeWindow.exchangeFeeModule:SetMoney(0)
  end
  SetTradeLockBtnEnable(true)
end
local function TradeStarted(targetName)
  CLEAR_TRADE_UI()
  targetTradePanel:SetName(targetName)
  targetTradePanel:SetChecked(false)
  myTradePanel:SetChecked(false)
  tradeWindow.tradeBtn:Enable(false)
  LockMoney(false)
  tradeWindow:Show(true)
end
local TradeCanStart = function(unitIdStr)
  X2Trade:StartTrade(unitIdStr)
end
local function TradeCanceled(showMsg)
  tradeWindow:Show(false)
  CLEAR_TRADE_UI()
  if showMsg == true then
    X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.canceled)
  end
  LockMoney(false)
end
local function CheckLockingState()
  if X2Trade:IsTradeLocked() and X2Trade:IsOtherTradeLocked() then
    tradeWindow.tradeBtn:Enable(true)
  else
    tradeWindow.tradeBtn:Enable(false)
  end
end
local function TradeLocked()
  myTradePanel:SetChecked(true)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.lockedMsg)
  LockMoney(true)
  CheckLockingState()
end
local function TradeOtherLocked()
  targetTradePanel:SetChecked(true)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.otherLockedMsg)
  CheckLockingState()
end
local function TradeUnlocked()
  myTradePanel:SetChecked(false)
  targetTradePanel:SetChecked(false)
  LockMoney(false)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.unlockedMsg)
  CheckLockingState()
  SetTradeLockBtnEnable(false)
end
local function TradeOk()
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.tradeOk)
  LockMoney(true)
end
local function TradeOtherOK()
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.tradeOtherOk)
  LockMoney(true)
end
local function TradeMade()
  tradeWindow:Show(false)
  CLEAR_TRADE_UI()
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.tradeAccomplishd)
  LockMoney(false)
end
local function ToggleTradeUi()
  local show = not tradeWindow:IsVisible()
  tradeWindow:Show(show)
end
local function TradeItemPutup(inventoryIdx, amount)
  for k = 1, #myTradePanel.tradeSlot.item do
    if myTradePanel.tradeSlot.item[k].inventoryIdx == inventoryIdx then
      X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, locale.trade.registedItem)
      return
    end
  end
  for k = 1, #myTradePanel.tradeSlot.item do
    if myTradePanel.tradeSlot.item[k].inventoryIdx == nil then
      itemInfo = X2Bag:GetBagItemInfo(1, inventoryIdx)
      if itemInfo ~= nil then
        myTradePanel.tradeSlot.item[k].inventoryIdx = inventoryIdx
        myTradePanel.tradeSlot.item[k].tooltip = itemInfo
        myTradePanel.tradeSlot.item[k]:SetItemInfo(itemInfo)
        if amount > 1 then
          myTradePanel.tradeSlot.item[k].tradeStack = amount
          myTradePanel.tradeSlot.item[k]:SetStack(tostring(amount))
        elseif amount ~= 1 then
          myTradePanel.tradeSlot.item[k].tradeStack = itemInfo.stack
          if itemInfo.stack ~= nil and 1 < itemInfo.stack then
            myTradePanel.tradeSlot.item[k]:SetStack(tostring(itemInfo.stack))
          end
        end
        X2Bag:LockSlot(inventoryIdx)
      end
      return
    end
  end
end
local function TradeOtherItemPutup(otherIdx, type, stackCount, tooltip)
  for k = 1, #targetTradePanel.tradeSlot.item do
    if targetTradePanel.tradeSlot.item[k].tradeType == nil then
      targetTradePanel.tradeSlot.item[k].otherIdx = otherIdx
      targetTradePanel.tradeSlot.item[k].tradeType = type
      targetTradePanel.tradeSlot.item[k].tradeStack = stackCount
      targetTradePanel.tradeSlot.item[k].tooltip = tooltip
      targetTradePanel.tradeSlot.item[k]:SetItemInfo(tooltip)
      if stackCount > 1 then
        targetTradePanel.tradeSlot.item[k]:SetStack(tostring(stackCount))
      end
      return
    end
  end
end
local function TradeItemTookDown(inventoryIdx)
  for k = 1, #myTradePanel.tradeSlot.item do
    if myTradePanel.tradeSlot.item[k].inventoryIdx == inventoryIdx then
      CLEAR_TRADE_ITEM(true, k)
      return
    end
  end
end
local function TradeOtherItemTookDown(otherIdx)
  for k = 1, #targetTradePanel.tradeSlot.item do
    if targetTradePanel.tradeSlot.item[k].otherIdx == otherIdx then
      CLEAR_TRADE_ITEM(false, k)
      for i = 1, #targetTradePanel.tradeSlot.item do
        local otherItemIdx = targetTradePanel.tradeSlot.item[i].otherIdx
        if otherItemIdx ~= nil and otherIdx < otherItemIdx then
          targetTradePanel.tradeSlot.item[i].otherIdx = otherItemIdx - 1
        end
      end
      return
    end
  end
end
function tradeWindow:OnHide()
  X2Trade:CancelTrade(TCR_NORMAL)
end
tradeWindow:SetHandler("OnHide", tradeWindow.OnHide)
local CreateTargetItemSlot = function(parent, x, y)
  for k = 1, x do
    for j = 1, y do
      local index = y * k - y + j
      parent.item[index].index = index
      parent.item[index]:EnableDrag(true)
      parent.item[index].otherIdx = nil
      parent.item[index].tradeType = nil
      parent.item[index].tradeStack = 0
      parent.item[index].tooltip = nil
      itemIcon = parent.item[index]
      function itemIcon:AppendItem(item)
        if item == nil then
          self.tooltip = nil
          self:Init()
        else
          self.tooltip = item
          self:SetItemInfo(item)
        end
      end
    end
  end
end
local CreateMyItemSlot = function(parent, x, y)
  for k = 1, x do
    for j = 1, y do
      local index = y * k - y + j
      parent.item[index].index = index
      parent.item[index]:EnableDrag(true)
      parent.item[index].inventoryIdx = nil
      parent.item[index].tradeStack = 0
      parent.item[index].tooltip = nil
      parent.item[index]:RegisterForClicks("RightButton")
      itemIcon = parent.item[index]
      function itemIcon:OnDragStart()
        if X2Trade:IsTradeLocked() == false then
          X2Trade:TakeDownTradeItemByInventoryIdx(self.inventoryIdx - 1)
        end
      end
      itemIcon:SetHandler("OnDragStart", itemIcon.OnDragStart)
      function itemIcon:OnDragReceive()
        if X2Trade:IsTradeLocked() == false then
          local cursorInfo = X2Cursor:GetCursorInfo()
          if cursorInfo == "Item" then
            PutupTradeItem(X2Cursor:GetCursorPickedBagItemIndex(), X2Cursor:GetCursorPickedBagItemAmount())
            X2Cursor:ClearCursor()
          end
        end
      end
      itemIcon:SetHandler("OnDragReceive", itemIcon.OnDragReceive)
      function itemIcon:OnClickProc(arg)
        if X2Trade:IsTradeLocked() == false then
          if arg == "LeftButton" then
            local cursorInfo = X2Cursor:GetCursorInfo()
            if cursorInfo == "Item" or cursorInfo == "Item_Id" then
              PutupTradeItem(X2Cursor:GetCursorPickedBagItemIndex(), X2Cursor:GetCursorPickedBagItemAmount())
              X2Cursor:ClearCursor()
            end
          elseif arg == "RightButton" and self.inventoryIdx ~= nil then
            X2Trade:TakeDownTradeItemByInventoryIdx(self.inventoryIdx - 1)
            HideTooltip()
          end
        end
      end
      function itemIcon:AppendItem(item)
        if item == nil then
          self.tooltip = nil
          self:Init()
        else
          self.tooltip = item
          self:SetItemInfo(item)
        end
      end
    end
  end
end
function myTradePanel.tradeSlot:OnDragReceive()
  if X2Trade:IsTradeLocked() == false then
    local cursorInfo = X2Cursor:GetCursorInfo()
    if cursorInfo == "Item" then
      PutupTradeItem(X2Cursor:GetCursorPickedBagItemIndex(), X2Cursor:GetCursorPickedBagItemAmount())
      X2Cursor:ClearCursor()
    end
  end
end
myTradePanel.tradeSlot:SetHandler("OnDragReceive", myTradePanel.tradeSlot.OnDragReceive)
function myTradePanel.tradeSlot:OnClick(arg)
  if X2Trade:IsTradeLocked() == false and arg == "LeftButton" then
    local cursorInfo = X2Cursor:GetCursorInfo()
    if cursorInfo == "Item" then
      PutupTradeItem(X2Cursor:GetCursorPickedBagItemIndex(), X2Cursor:GetCursorPickedBagItemAmount())
      X2Cursor:ClearCursor()
    end
  end
end
myTradePanel.tradeSlot:SetHandler("OnClick", myTradePanel.tradeSlot.OnClick)
local goldEdit = myTradePanel.moneyEditor.goldEdit
local silverEdit = myTradePanel.moneyEditor.silverEdit
local copperEdit = myTradePanel.moneyEditor.copperEdit
function OnChangedHandler()
  if tradeWindow:IsVisible() == false then
    return
  end
  local gold = goldEdit:GetText()
  local silver = silverEdit:GetText()
  local copper = copperEdit:GetText()
  PutupTradeMoney(gold, silver, copper)
  if tradeWindow.exchangeFeeModule ~= nil then
    local fee = X2Util:CalcCurrencyExchangeFee(myTradePanel.moneyEditor:GetAmountStr())
    tradeWindow.exchangeFeeModule:SetMoney(fee)
  end
end
local function SetMaxMoneyHandlerLimitMyMoney(goldWidget, silverWidget, copperWidget, goldlimit, OnChangedHander)
  local function IsOverMoney()
    local gold = goldWidget:GetText()
    local silver = silverWidget:GetText()
    local copper = copperWidget:GetText()
    local moneyStr = X2Util:MakeMoneyString(gold, silver, copper)
    if moneyStr == "invalid_money" then
      return true
    end
    if X2Util:CompareMoneyString(X2Util:GetMyMoneyString(), moneyStr) == -1 then
      return true
    end
    return false
  end
  local function SetMaxMoney()
    local moneyStr = X2Util:GetMyMoneyString()
    local limitStr = X2Util:MakeMoneyString(string.format("%i", goldlimit), "0", "0")
    local gold, silver, copper
    if X2Util:CompareMoneyString(limitStr, moneyStr) == -1 then
      gold, silver, copper = GoldSilverCopperStringFromMoneyStr(limitStr)
    else
      gold, silver, copper = GoldSilverCopperStringFromMoneyStr(moneyStr)
    end
    goldWidget:SetText(gold)
    silverWidget:SetText(silver)
    copperWidget:SetText(copper)
  end
  local function IsLimitOver()
    local limitStr = X2Util:MakeMoneyString(string.format("%i", goldlimit), "0", "0")
    local gold = goldWidget:GetText()
    local silver = silverWidget:GetText()
    local copper = copperWidget:GetText()
    local moneyStr = X2Util:MakeMoneyString(gold, silver, copper)
    if moneyStr == "invalid_money" then
      return true
    end
    if X2Util:CompareMoneyString(limitStr, moneyStr) == -1 then
      return true
    end
    return false
  end
  local function Process(widget)
    local num = widget:GetText()
    local strNum = ""
    strNum = RemoveNonDigit(num)
    strNum = ReplaceMaxValue(strNum, maxNumberByGold)
    strNum = F_MONEY:RemoveHeadZero(strNum)
    widget:SetText(strNum)
    if IsOverMoney() or IsLimitOver() then
      SetMaxMoney()
    end
    if OnChangedHander ~= nil then
      OnChangedHander()
    end
  end
  function goldWidget:OnTextChanged()
    Process(self)
  end
  goldWidget:SetHandler("OnTextChanged", goldWidget.OnTextChanged)
  function silverWidget:OnTextChanged()
    Process(self)
  end
  silverWidget:SetHandler("OnTextChanged", silverWidget.OnTextChanged)
  function copperWidget:OnTextChanged()
    Process(self)
  end
  copperWidget:SetHandler("OnTextChanged", copperWidget.OnTextChanged)
end
local function SetMaxMoneyHandlerLimitMyAAPoint(goldWidget, silverWidget, copperWidget, goldlimit, OnChangedHander)
  local function IsOverAAPoint()
    local gold = goldWidget:GetText()
    local silver = silverWidget:GetText()
    local copper = copperWidget:GetText()
    local aapointStr = X2Util:MakeAAPointString(gold, silver, copper)
    if aapointStr == "invalid_money" then
      return true
    end
    if X2Util:CompareAAPointString(X2Util:GetMyAAPointString(), aapointStr) == -1 then
      return true
    end
    return false
  end
  local function SetMaxAAPoint()
    local aapointStr = X2Util:GetMyAAPointString()
    local limitStr = X2Util:MakeAAPointString(string.format("%i", goldlimit), "0", "0")
    local gold, silver, copper
    if X2Util:CompareAAPointString(limitStr, aapointStr) == -1 then
      gold, silver, copper = GoldSilverCopperStringFromMoneyStr(limitStr)
    else
      gold, silver, copper = GoldSilverCopperStringFromMoneyStr(aapointStr)
    end
    goldWidget:SetText(gold)
    silverWidget:SetText(silver)
    copperWidget:SetText(copper)
  end
  local function IsLimitOver()
    local limitStr = X2Util:MakeAAPointString(string.format("%i", goldlimit), "0", "0")
    local gold = goldWidget:GetText()
    local silver = silverWidget:GetText()
    local copper = copperWidget:GetText()
    local aapointStr = X2Util:MakeAAPointString(gold, silver, copper)
    if aapointStr == "invalid_aapoint" then
      return true
    end
    if X2Util:CompareAAPointString(limitStr, aapointStr) == -1 then
      return true
    end
    return false
  end
  local function Process(widget)
    local num = widget:GetText()
    local strNum = ""
    strNum = RemoveNonDigit(num)
    strNum = ReplaceMaxValue(strNum, maxNumberByGold)
    strNum = F_MONEY:RemoveHeadZero(strNum)
    widget:SetText(strNum)
    if IsOverAAPoint() or IsLimitOver() then
      SetMaxAAPoint()
    end
    if OnChangedHander ~= nil then
      OnChangedHander()
    end
  end
  function goldWidget:OnTextChanged()
    Process(self)
  end
  goldWidget:SetHandler("OnTextChanged", goldWidget.OnTextChanged)
  function silverWidget:OnTextChanged()
    Process(self)
  end
  silverWidget:SetHandler("OnTextChanged", silverWidget.OnTextChanged)
  function copperWidget:OnTextChanged()
    Process(self)
  end
  copperWidget:SetHandler("OnTextChanged", copperWidget.OnTextChanged)
end
if X2Trade:GetCurrencyForUserTrade() == CURRENCY_AA_POINT then
  SetMaxMoneyHandlerLimitMyAAPoint(goldEdit, silverEdit, copperEdit, 200000, OnChangedHandler)
else
  SetMaxMoneyHandlerLimitMyMoney(goldEdit, silverEdit, copperEdit, 200000, OnChangedHandler)
end
local function LockButtonOnClick(self, arg, doubleClicked)
  SetTradeLockBtnEnable(false)
  X2Trade:LockTrade()
end
myTradePanel.tradeDecision:SetHandler("OnClick", LockButtonOnClick)
function tradeWindow.tradeBtn:OnClick()
  X2Trade:OkTrade()
end
tradeWindow.tradeBtn:SetHandler("OnClick", tradeWindow.tradeBtn.OnClick)
function tradeWindow:ShowProc()
  myTradePanel.moneyEditor:SetAmountStr("0")
  ADDON:ShowContent(UIC_BAG, true)
end
local tradeEvents = {
  TRADE_STARTED = function(targetName)
    TradeStarted(targetName)
  end,
  TRADE_CAN_START = function(unitIdStr)
    TradeCanStart(unitIdStr)
  end,
  TRADE_CANCELED = function()
    TradeCanceled(true)
  end,
  TRADE_LOCKED = function()
    TradeLocked()
    F_SOUND.PlayUISound("event_trade_lock")
  end,
  TRADE_OTHER_LOCKED = function()
    TradeOtherLocked()
    F_SOUND.PlayUISound("event_trade_lock")
  end,
  TRADE_UNLOCKED = function()
    TradeUnlocked()
    F_SOUND.PlayUISound("event_trade_unlock")
  end,
  TRADE_OK = function()
    TradeOk()
  end,
  TRADE_OTHER_OK = function()
    TradeOtherOK()
  end,
  TRADE_MADE = function()
    TradeMade()
  end,
  TRADE_UI_TOGGLE = function()
    ToggleTradeUi()
  end,
  TRADE_ITEM_PUTUP = function(inventoryIdx, amount)
    TradeItemPutup(inventoryIdx, amount)
    F_SOUND.PlayUISound("event_trade_item_putup", true)
  end,
  TRADE_OTHER_ITEM_PUTUP = function(otherIdx, type, stackCount, tooltip)
    TradeOtherItemPutup(otherIdx, type, stackCount, tooltip)
    F_SOUND.PlayUISound("event_trade_item_putup", true)
  end,
  TRADE_MONEY_PUTUP = function(money)
  end,
  TRADE_OTHER_MONEY_PUTUP = function(money)
    targetTradePanel.moneyModule:SetMoney(money)
  end,
  TRADE_ITEM_TOOKDOWN = function(inventoryIdx)
    TradeItemTookDown(inventoryIdx)
    F_SOUND.PlayUISound("event_trade_item_tookdown", true)
  end,
  TRADE_OTHER_ITEM_TOOKDOWN = function(otherIdx)
    TradeOtherItemTookDown(otherIdx)
    F_SOUND.PlayUISound("event_trade_item_tookdown", true)
  end,
  ENTERED_LOADING = function()
    TradeCanceled(false)
  end
}
tradeWindow:SetHandler("OnEvent", function(this, event, ...)
  tradeEvents[event](...)
end)
RegistUIEvent(tradeWindow, tradeEvents)
CreateMyItemSlot(myTradePanel.tradeSlot, 2, 5)
CreateTargetItemSlot(targetTradePanel.tradeSlot, 2, 5)
tradeWindow:SetCloseOnEscape(true)
