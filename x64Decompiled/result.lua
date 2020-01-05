function CreateResultFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = SetViewOfResultFrame(id, parent)
  frame.openType = nil
  function frame:SetWindowDrawableVisible(detail)
    if self.window.colorTexture ~= nil then
      self.window.colorTexture:SetVisible(detail)
    end
    if self.window.upperTexture ~= nil then
      self.window.upperTexture:SetVisible(detail)
    end
    if self.window.lowerTexture_left ~= nil then
      self.window.lowerTexture_left:SetVisible(detail)
    end
    if self.window.lowerTexture_right ~= nil then
      self.window.lowerTexture_right:SetVisible(detail)
    end
    if self.window.bg ~= nil then
      self.window.bg:SetVisible(not detail)
    end
  end
  local MakeResultMessage = function(openType, reason)
    if openType == BUY_RESULT_OPEN_TYPE_CART then
      if reason == CFR_FULL then
        return locale.inGameShop.putToCartFullError
      elseif reason == CFR_NORMAL then
        return locale.inGameShop.putToCartNormalError
      end
    elseif reason == BFR_NONE then
      if openType == BUY_RESULT_OPEN_TYPE_PRESENT then
        return locale.inGameShop.noticePresentGood
      else
        return locale.inGameShop.noticeBuyGood
      end
    elseif reason == BFR_CASH then
      return locale.inGameShop.cashError
    elseif reason == BFR_AA_POINT then
      if X2Player:GetExchangeRatio() > 0 then
        return GetUIText(ERROR_MSG, "INGAME_SHOP_NOT_ENOUGH_AA_POINT")
      end
      return GetUIText(ERROR_MSG, "NOT_ENOUGH_AA_POINT")
    elseif reason == BFR_FRIEND_NAME then
      return locale.inGameShop.friendNameError
    elseif reason == BFR_SOLO_OUT then
      return locale.inGameShop.soldOutError
    elseif reason == BFR_EXPIRED_DATE then
      return locale.inGameShop.expiredDateError2
    elseif reason == BFR_COUNT_PER_ACCOUNT then
      return locale.inGameShop.countPerAccoutError
    elseif reason == BFR_NORMAL then
      return locale.inGameShop.normalError
    elseif reason == BFR_SAME_ACCOUNT then
      return locale.inGameShop.sameAccountError
    elseif reason == BFR_LIMITED_TOTAL_PRICE then
      return locale.inGameShop.limitedTotalPriceError
    elseif reason == BFR_BM_MILEAGE then
      return locale.inGameShop.bmMileageError
    elseif reason == BFR_GOLD then
      return locale.inGameShop.goldError
    elseif reason == BFR_INVALID_ACCOUNT then
      return locale.inGameShop.invalidAccountError
    elseif reason == BFR_DELETED_CHARACTER then
      return locale.inGameShop.deletedCharacterError
    elseif reason == BFR_TRANSFER_CHARACTER then
      return locale.inGameShop.transferCharacterError
    elseif reason == BFR_CANNOT_USE_AACOIN_FOR_GIFT then
      return locale.inGameShop.useAACoinForGiftError
    else
      return ""
    end
  end
  function frame:ShowBuyResultInfo()
    local buyResultInfos = X2InGameShop:GetBuyResult()
    local present = buyResultInfos.present
    local reason = buyResultInfos.reason
    if reason == BFR_SECOND_PASSWORD then
      return false
    end
    local windowTitle = ""
    local usedMoneyTitle = ""
    local moneyAfterTitle = ""
    if present then
      self.openType = BUY_RESULT_OPEN_TYPE_PRESENT
      windowTitle = GetUIText(INGAMESHOP_TEXT, "resultPresent")
      usedMoneyTitle = GetUIText(INGAMESHOP_TEXT, "totalPresentMoney")
      moneyAfterTitle = GetUIText(INGAMESHOP_TEXT, "totalMoneyAfterPresent")
    else
      self.openType = BUY_RESULT_OPEN_TYPE_BUY
      windowTitle = GetUIText(INGAMESHOP_TEXT, "resultBuy")
      usedMoneyTitle = GetUIText(INGAMESHOP_TEXT, "totalBuyMoney")
      moneyAfterTitle = GetUIText(INGAMESHOP_TEXT, "totalMoneyAfterBuy")
    end
    local showDetailResult = true
    local useCancelButton = false
    if reason == BFR_CASH or reason == BFR_AA_POINT or reason == BFR_FRIEND_NAME or reason == BFR_BM_MILEAGE or reason == BFR_GOLD then
      showDetailResult = false
      if reason == BFR_CASH then
        useCancelButton = true
      elseif reason == BFR_AA_POINT then
        useCancelButton = X2Player:GetExchangeRatio() > 0
      end
    end
    local totalHeight = titleMargin
    local width = 0
    local bottomOffset = 0
    self.window.message:RemoveAllAnchors()
    self.window.resultListCtrl:DeleteAllDatas()
    self.window.resultListCtrl:Show(showDetailResult)
    self.window.moneyView:Show(showDetailResult)
    if showDetailResult then
      do
        local results = buyResultInfos.results
        local payItems = {}
        local function GetPayItemsIdx(itemType)
          for i = 1, #payItems do
            if payItems[i].type == itemType then
              return i
            end
          end
          return #payItems + 1
        end
        local secondPriceType = self.window.moneyView.secondPriceType
        for i = 1, #results do
          local buyResult = results[i]
          local firstColumnData = {}
          firstColumnData.itemType = buyResult.itemType
          firstColumnData.selectType = buyResult.selectType
          firstColumnData.name = buyResult.name
          firstColumnData.count = buyResult.count
          firstColumnData.time = buyResult.time
          if buyResult.priceType == PRICE_TYPE_ITEM then
            local idx = GetPayItemsIdx(buyResult.payItemType)
            if payItems[idx] == nil then
              payItems[idx] = {}
              payItems[idx].type = buyResult.payItemType
              payItems[idx].count = buyResult.price
            else
              payItems[idx].count = payItems[idx].count + buyResult.price
            end
          end
          if secondPriceType == PRICE_TYPE_AA_BONUS_CASH then
            if buyResult.priceType == PRICE_TYPE_AA_POINT or buyResult.priceType == PRICE_TYPE_BM_MILEAGE then
              secondPriceType = buyResult.priceType
            elseif buyResult.priceType == PRICE_TYPE_AA_CASH_AND_BONUS_CASH then
              secondPriceType = PRICE_TYPE_AA_BONUS_CASH
            end
          end
          if buyResult.priceType == PRICE_TYPE_GOLD then
            secondPriceType = buyResult.priceType
          end
          self.window.resultListCtrl:InsertData(i, 1, firstColumnData, false)
          self.window.resultListCtrl:InsertData(i, 2, reason, false)
        end
        self.window.message:AddAnchor("TOPLEFT", self.window.moneyView, "BOTTOMLEFT", 0, 0)
        self.window.message:AddAnchor("TOPRIGHT", self.window.moneyView, "BOTTOMRIGHT", 0, 0)
        if #payItems ~= 0 then
          self.window.moneyView:UpdateAfterByPayItem(usedMoneyTitle, moneyAfterTitle, payItems)
        elseif secondPriceType == PRICE_TYPE_GOLD then
          self.window.moneyView:UpdateAfterByPayGold(usedMoneyTitle, moneyAfterTitle, buyResultInfos.totalGold, buyResultInfos.afterGold)
        else
          self.window.moneyView:UpdateAfter(usedMoneyTitle, buyResultInfos.totalCash, buyResultInfos.totalAAPoint, buyResultInfos.totalBmMileage, buyResultInfos.totalAaCoin, moneyAfterTitle, buyResultInfos.afterCash, buyResultInfos.afterAAPoint, buyResultInfos.afterBmMileage, buyResultInfos.afterAaCoin, secondPriceType)
        end
        width = BUY_RESULT_WIDGET_WIDTH
        bottomOffset = -sideMargin
        totalHeight = totalHeight + BUY_RESULT_LIST_HEIGHT + self.window.moneyView:GetHeight() + sideMargin
      end
    else
      self.window.message:AddAnchor("TOPLEFT", self.window, "TOPLEFT", sideMargin, titleMargin)
      self.window.message:AddAnchor("TOPRIGHT", self.window, "TOPRIGHT", -sideMargin, -titleMargin)
      width = BUY_RESULT_WIDGET_WIDTH_SMALL
      bottomOffset = BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM
      totalHeight = totalHeight + sideMargin
    end
    self.window.message:SetText(MakeResultMessage(self.openType, reason))
    totalHeight = totalHeight + self.window.message:GetTextHeight()
    self.window.leftButton:RemoveAllAnchors()
    self.window.leftButton.actionReason = reason
    if useCancelButton == false then
      self.window.leftButton:AddAnchor("BOTTOM", self.window, "BOTTOM", 0, bottomOffset)
    else
      self.window.rightButton:RemoveAllAnchors()
      local offset = BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN
      if showDetailResult == true then
        self.window.leftButton:AddAnchor("BOTTOM", self.window, -offset, bottomOffset)
        self.window.rightButton:AddAnchor("BOTTOM", self.window, "BOTTOM", offset, bottomOffset)
      else
        self.window.leftButton:AddAnchor("BOTTOM", self.window, "BOTTOM", -offset, bottomOffset)
        self.window.rightButton:AddAnchor("BOTTOM", self.window, "BOTTOM", offset, bottomOffset)
      end
    end
    self.window.rightButton:Show(useCancelButton)
    totalHeight = totalHeight + self.window.leftButton:GetHeight() + -bottomOffset
    self.window:SetExtent(width, totalHeight)
    self.window:SetTitle(windowTitle)
    SettingWindowSkin(self.window)
    self:SetWindowDrawableVisible(showDetailResult)
    self:Show(true)
    self:Raise()
    return true
  end
  function frame:ShowCartResultInfo(reason)
    self.openType = BUY_RESULT_OPEN_TYPE_CART
    self.window.resultListCtrl:DeleteAllDatas()
    self.window.resultListCtrl:Show(false)
    self.window.moneyView:Show(false)
    self.window:SetWidth(BUY_RESULT_WIDGET_WIDTH_SMALL)
    local totalHeight = titleMargin
    self.window.message:RemoveAllAnchors()
    self.window.message:AddAnchor("TOPLEFT", self.window, sideMargin, titleMargin)
    self.window.message:AddAnchor("TOPRIGHT", self.window, -sideMargin, titleMargin)
    self.window.message:SetText(MakeResultMessage(self.openType, reason))
    totalHeight = totalHeight + self.window.message:GetHeight() + sideMargin / 1.5
    self.window.leftButton:RemoveAllAnchors()
    self.window.leftButton.actionReason = reason
    if reason ~= CFR_FULL then
      self.window.leftButton:AddAnchor("BOTTOM", self.window, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    else
      self.window.leftButton:AddAnchor("BOTTOM", self.window, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
      self.window.rightButton:RemoveAllAnchors()
      self.window.rightButton:AddAnchor("BOTTOM", self.window, BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    end
    self.window.rightButton:Show(reason == CFR_FULL)
    totalHeight = totalHeight + self.window.leftButton:GetHeight() + -BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM
    self.window.rightButton:Show(reason == CFR_FULL)
    self.window:SetExtent(BUY_RESULT_WIDGET_WIDTH_SMALL, totalHeight)
    self.window:SetTitle(locale.inGameShop.resultPutToCart)
    SettingWindowSkin(self.window)
    self:SetWindowDrawableVisible(false)
    self:Show(true)
    self:Raise()
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
  function frame.window.leftButton:OnClick()
    if frame.openType == BUY_RESULT_OPEN_TYPE_CART then
      if self.actionReason == CFR_FULL then
        inGameShopFrame.cartFrame:ApplyCartInfos(CRAT_OPEN_TYPE_BUY)
      end
    elseif self.actionReason == BFR_CASH then
      RequestCashCharge(inGameShopFrame)
    elseif self.actionReason == BFR_AA_POINT and frame.window.rightButton:IsVisible() then
      inGameShopFrame.aapointBuyFrame.ShowAAPointBuyFrame(inGameShopFrame)
    end
    frame:Show(false)
  end
  frame.window.leftButton:SetHandler("OnClick", frame.window.leftButton.OnClick)
  local function RightButtonClickFunc()
    frame:Show(false)
  end
  frame.window.rightButton:SetHandler("OnClick", RightButtonClickFunc)
  frame:Show(false)
  return frame
end
