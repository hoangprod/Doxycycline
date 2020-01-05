MAIL_WITHRECEIVER = true
MAIL_DOODADID = 0
function AddMailItem(bagId, slotNumber)
  if mailFrame == nil or GetWriteMailWindow():IsVisible() == false then
    return false
  end
  local emptyIndex = X2Mail:GetMailEmptyItemIndex()
  if emptyIndex ~= nil then
    if X2Mail:PlaceMailItemFromBag(emptyIndex, bagId, slotNumber) then
      F_SOUND.PlayUISound("event_trade_item_putup", true)
    end
  else
    local error_msg = X2Locale:LocalizeUiText(ERROR_MSG, "MAIL_NO_MORE_ATTACHMENT")
    AddMessageToSysMsgWindow(error_msg)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, error_msg)
  end
  return true
end
function CreateWriteMailWindow(id, parent)
  local window = SetViewOfWriteMailWindow(id, parent)
  local moneyEditsWindow = window.defaultFrame.moneyEditsWindow
  local currencyExchangeFeeWindow = window.defaultFrame.currencyExchangeFeeWindow
  local content = window.content
  local sendButton = window.sendButton
  function window:FillReplyInfos(info)
    self.roleEdit:SetText(info.sender)
    self.titleEdit:SetText(info.title)
  end
  function window:ItemsClear()
    for i = 1, #self.defaultFrame.itemSlots do
      self.defaultFrame.itemSlots[i]:Init()
    end
  end
  function window:Clear()
    self.roleEdit:SetText("")
    self.titleEdit:SetText("")
    content:SetText("")
    moneyEditsWindow.goldEdit:SetText("")
    moneyEditsWindow.silverEdit:SetText("")
    moneyEditsWindow.copperEdit:SetText("")
    self:ItemsClear()
    for i = 1, #self.defaultFrame.itemSlots do
      X2Mail:ClearMailItem(i)
    end
    self:UpdateMailCost()
    self.radioGroup:Check(1)
  end
  for i = 1, MAX_ATTACHMENT_COUNT do
    do
      local button = window.defaultFrame.itemSlots[i]
      function button:OnClickProc(arg)
        if arg == "LeftButton" then
          if X2Mail:PlaceMailItem(i) then
            F_SOUND.PlayUISound("event_trade_item_putup", true)
          end
        elseif X2Mail:ClearMailItem(i) then
          F_SOUND.PlayUISound("event_trade_item_recv", true)
        end
      end
      function button:OnDragReceive()
        if X2Mail:PlaceMailItem(i) then
          F_SOUND.PlayUISound("event_trade_item_putup", true)
        end
      end
      button:SetHandler("OnDragReceive", button.OnDragReceive)
    end
  end
  function sendButton:OnClick(arg)
    if arg == "LeftButton" then
      local mailInfo = {}
      mailInfo.receiver = window.roleEdit:GetText()
      mailInfo.title = window.titleEdit:GetText()
      mailInfo.text = content:GetText()
      mailInfo.gold = moneyEditsWindow.goldEdit:GetText()
      mailInfo.silver = moneyEditsWindow.silverEdit:GetText()
      mailInfo.copper = moneyEditsWindow.copperEdit:GetText()
      mailInfo.doodadId = string.format("%d", MAIL_DOODADID)
      mailInfo.type = window.radioGroup:GetCheckedData()
      if MAIL_WITHRECEIVER == true then
        mailInfo.withReceiver = string.format("%d", 1)
      else
        mailInfo.withReceiver = string.format("%d", 0)
      end
      X2Mail:SendMail(mailInfo)
      F_SOUND.PlayUISound("event_mail_send", true)
      window:ItemsClear()
      window:Clear()
    end
  end
  sendButton:SetHandler("OnClick", sendButton.OnClick)
  function window:UpdateMailCost()
    local moneyAttached = false
    if moneyEditsWindow:GetAmountStr() ~= "0" then
      moneyAttached = true
    end
    if currencyExchangeFeeWindow ~= nil then
      if X2Mail:GetCurrencyForAttachment() == CURRENCY_AA_POINT then
        currencyExchangeFeeWindow:UpdateAAPoint(X2Util:CalcCurrencyExchangeFee(moneyEditsWindow:GetAmountStr()))
      else
        currencyExchangeFeeWindow:Update(X2Util:CalcCurrencyExchangeFee(moneyEditsWindow:GetAmountStr()))
      end
    end
    local expressCostStr = F_MONEY:GetCostStringByCurrency(X2Mail:GetCurrencyForFee(), X2Mail:GetExpressMailCost(moneyAttached))
    local normalCostStr = F_MONEY:GetCostStringByCurrency(X2Mail:GetCurrencyForFee(), X2Mail:GetNormalMailCost(moneyAttached))
    local radioData = {
      {
        text = string.format("%s %s", locale.mail.expressMail, expressCostStr),
        tooltip = locale.mail.expressDelivery(MakeMoneyText(tostring(X2Mail:GetExpressMailAttachmentCost()))),
        value = MAIL_EXPRESS
      },
      {
        text = string.format("%s %s", locale.mail.normalMail, normalCostStr),
        tooltip = locale.mail.generalDelivery(MakeMoneyText(tostring(X2Mail:GetNormalMailAttachmentCost()))),
        value = MAIL_NORMAL
      }
    }
    local checkedIdx = self.radioGroup:GetChecked()
    self.radioGroup:SetData(radioData)
    self.radioGroup:Check(checkedIdx)
  end
  function window:ShowProc()
    self:Clear()
    X2Input:SetInputLanguage("Native")
    GetReadMailWindow():Show(false)
    ADDON:ShowContent(UIC_BAG, true)
    X2Mail:SetWriting(true)
    self.roleEdit:SetFocus()
  end
  function window:OnHide()
    X2Input:SetInputLanguage("English")
    InitLockToBagSlot()
    X2Mail:SetWriting(false)
  end
  window:SetHandler("OnHide", window.OnHide)
  function window:OnEndFadeIn()
    self:UpdateMailCost()
  end
  window:SetHandler("OnEndFadeIn", window.OnEndFadeIn)
  function moneyEditsWindow:MoneyEditProc()
    window:UpdateMailCost()
  end
  local mailItemEvents = {
    MAIL_WRITE_ITEM_UPDATE = function(index)
      if window:IsVisible() == false then
        return
      end
      if index < 1 or index > MAX_ATTACHMENT_COUNT then
        LuaAssert(string.format("MAIL_WRITE_ITEM_UPDATE - invalid index : %d", index))
        return
      end
      local itemSlot = window.defaultFrame.itemSlots[index]
      local mailItem = X2Mail:GetMailItem(index)
      if mailItem ~= nil then
        itemSlot:SetItemInfo(mailItem)
        itemSlot:SetStack(tostring(GetItemStackCount(mailItem)))
      else
        itemSlot:Init()
      end
      window:UpdateMailCost()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    mailItemEvents[event](...)
  end)
  window:RegisterEvent("MAIL_WRITE_ITEM_UPDATE")
  return window
end
