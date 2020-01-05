function CreateCartFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = SetViewOfCartFrame(id, parent)
  frame.openType = nil
  local function SetRefundMessage(existAACashGoods)
    local refundMessage = frame.window.refundMessage
    local buyInterface = frame.window.buyInterface
    local friend = frame.window.friend
    local visible = true
    if not baselibLocale.visibleRefundInfo then
      visible = false
    end
    if not baselibLocale.visibleAddedRefundInfo and frame.openType ~= CRAT_OPEN_TYPE_PRESENT then
      visible = false
    end
    if not existAACashGoods then
      visible = false
    end
    local str
    if frame.openType == CRAT_OPEN_TYPE_PRESENT then
      str = GetUIText(INGAMESHOP_TEXT, "presentIsNotRefund")
    else
      str = GetUIText(COMMON_TEXT, "ingameshop_aacash_goods_refund_rule")
    end
    refundMessage:Show(visible)
    if visible then
      refundMessage:SetText(str)
      refundMessage:SetHeight(refundMessage:GetTextHeight())
      refundMessage:RemoveAllAnchors()
    end
    frame.window.buyInterface:RemoveAllAnchors()
    local endWidget
    endWidget = CheckEndWidget(endWidget, frame.window.goodListCtrl)
    if friend:IsVisible() then
      refundMessage:AddAnchor("TOP", friend, "BOTTOM", 0, sideMargin / 2)
      local targetWidget = CheckEndWidget(friend, refundMessage)
      local offset = sideMargin / 2
      if targetWidget == friend then
        offset = sideMargin / 3
      end
      buyInterface:AddAnchor("TOPLEFT", targetWidget, "BOTTOMLEFT", 0, offset)
      endWidget = CheckEndWidget(endWidget, refundMessage)
      endWidget = CheckEndWidget(endWidget, buyInterface)
    else
      buyInterface:AddAnchor("TOPLEFT", frame.window.goodListCtrl, "BOTTOMLEFT", 0, sideMargin / 2)
      refundMessage:AddAnchor("TOP", frame.window.buyInterface, "BOTTOM", 0, sideMargin / 2)
      endWidget = CheckEndWidget(endWidget, buyInterface)
      endWidget = CheckEndWidget(endWidget, refundMessage)
    end
    local _, height = F_LAYOUT.GetExtentWidgets(frame.window.titleBar, endWidget)
    return height + sideMargin
  end
  function frame:ApplyCartInfos(openType)
    if openType == nil then
      openType = self.openType
    end
    if openType == nil then
      self:Show(false)
      return
    end
    local goodListCtrl = self.window.goodListCtrl
    local friend = self.window.friend
    self.openType = openType
    goodListCtrl:DeleteAllDatas()
    local present = false
    if self.openType == CRAT_OPEN_TYPE_PRESENT then
      present = true
    end
    local cartInfos = X2InGameShop:GetCartInfos(present)
    local existAACashGoods = false
    local infos = cartInfos.infos
    for i = 1, #infos do
      local goodsInfo = infos[i]
      local firstColumnData = {}
      firstColumnData.itemType = goodsInfo.itemType
      firstColumnData.name = goodsInfo.name
      firstColumnData.selectType = goodsInfo.selectType
      firstColumnData.count = goodsInfo.count
      firstColumnData.time = goodsInfo.time
      firstColumnData.cmdUi = goodsInfo.cmdUi
      goodListCtrl:InsertData(goodsInfo.index, 1, firstColumnData, false)
      local secondColumnData = {}
      secondColumnData.price = goodsInfo.price
      secondColumnData.priceType = goodsInfo.priceType
      secondColumnData.payItemType = goodsInfo.payItemType
      if goodsInfo.disPrice ~= nil then
        secondColumnData.price = goodsInfo.disPrice
      end
      goodListCtrl:InsertData(goodsInfo.index, 2, secondColumnData, false)
      goodListCtrl:InsertData(goodsInfo.index, 3, goodsInfo.index, false)
      if goodsInfo.priceType == PRICE_TYPE_AA_CASH then
        existAACashGoods = true
      end
    end
    self.window.buyInterface.moneyView:UpdateAfter(locale.inGameShop.totalBuyMoney, cartInfos.totalCash, cartInfos.totalAAPoint, cartInfos.totalBmMileage, cartInfos.totalAaBonusCash, locale.inGameShop.totalMoneyAfterBuy, cartInfos.afterCash, cartInfos.afterAAPoint, cartInfos.afterBmMileage, cartInfos.afterAaBonusCash)
    if #infos == 0 or cartInfos.possibleBuy == false then
      self.window.buyInterface.buyButton:Enable(false)
    else
      self.window.buyInterface.buyButton:Enable(true)
    end
    if present then
      local membersTable = X2Friend:GetFriendList(true)
      local datas = {}
      for i = 1, #membersTable do
        local data = {
          text = membersTable[i][1],
          value = i
        }
        table.insert(datas, data)
      end
      friend.comboBox:AppendItems(datas, false)
      self.window.buyInterface.buyButton:SetText(locale.inGameShop.present)
      friend:Show(true)
    else
      self.window.buyInterface.buyButton:SetText(locale.inGameShop.buy)
      friend:Show(false)
    end
    local height = SetRefundMessage(existAACashGoods)
    ApplyButtonSkin(self.window.buyInterface.buyButton, BUTTON_BASIC.DEFAULT)
    self.window:SetHeight(height)
    self:Show(true)
  end
  function frame:ShowProc()
    self.window:Show(true)
    if parent.waiting ~= nil and parent.waiting:IsVisible() == true then
      parent.waiting:Raise()
    end
  end
  function frame:OnHide()
    self.openType = nil
    self.window:Show(false)
  end
  frame:SetHandler("OnHide", frame.OnHide)
  function frame.window:OnClose()
    frame:Show(false)
  end
  function frame.window.buyInterface.buyButton:OnClick()
    if frame.openType == CRAT_OPEN_TYPE_PRESENT then
      if frame.window.friend.inputFriend:GetText() ~= "" then
        X2InGameShop:RequestBuy(BM_CART_ALL, frame.window.friend.inputFriend:GetText())
      else
        systemAlertWindow:AddMessage("|cFFFF6600" .. locale.inGameShop.needFriendName)
      end
    else
      X2InGameShop:RequestBuy(BM_CART_ALL, "")
    end
  end
  frame.window.buyInterface.buyButton:SetHandler("OnClick", frame.window.buyInterface.buyButton.OnClick)
  function frame.window.friend.comboBox:SelectedProc()
    local text = ""
    local info = self:GetSelectedInfo()
    if info ~= nil then
      text = info.text
    end
    frame.window.friend.inputFriend:SetText(text)
  end
  frame:Show(false)
  return frame
end
