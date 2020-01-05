local info = {mainTabIdx = nil, subTabIdx = nil}
local SelectMainTab = function(mainTabIdx, subTabIdx)
  X2InGameShop:SelectMainTab(mainTabIdx, subTabIdx)
end
function SetGoodsFunc(goodsGroup)
  function goodsGroup:Show(visible)
    for j = 1, GOODS_ROW_COUNT do
      for i = 1, GOODS_COL_COUNT do
        local each = self.goods[(j - 1) * GOODS_COL_COUNT + i]
        each:Show(visible)
      end
    end
  end
  function goodsGroup:SetLayout(layoutType)
    local each
    local offsetX = 0
    local offsetY = 0
    local width = EACH_GOODS_WIDTH
    local height = EACH_GOODS_HEIGHT
    self.layoutType = layoutType
    local totalIndex = 1
    if GOODS_LAYOUT_SMALL == layoutType then
      for j = 1, GOODS_ROW_COUNT do
        for i = 1, GOODS_COL_COUNT do
          each = self.goods[(j - 1) * GOODS_COL_COUNT + i]
          if totalIndex == 1 then
            each.centerLine:SetVisible(false)
            each.crossLine:SetVisible(false)
          end
          if totalIndex % 2 == 1 and j == GOODS_ROW_COUNT / 2 then
            each.underLineL:SetVisible(true)
            each.underLineR:SetVisible(true)
          end
          each.dateGroup:Show(false)
          each:RemoveAllAnchors()
          each:SetExtent(width, height)
          each:AddAnchor("TOPLEFT", self, "TOPLEFT", offsetX, offsetY)
          ApplyTextColor(each.goodsName, FONT_COLOR.DEFAULT)
          each.disPrice:RemoveAllAnchors()
          each.disPrice:AddAnchor("TOPLEFT", each.goodsName, "BOTTOMLEFT", 0, EACH_GOODS_MIN_OFFSET)
          each.price:RemoveAllAnchors()
          each.price:AddAnchor("TOPRIGHT", each.goodsName, "BOTTOMRIGHT", 0, EACH_GOODS_MIN_OFFSET)
          local x1, y1 = each.goodsName:GetOffset()
          local x2, y2 = each:GetOffset()
          each.buyButton:RemoveAllAnchors()
          each.buyButton:AddAnchor("BOTTOMLEFT", each, "BOTTOMLEFT", x1 - x2, -EACH_GOODS_MIN_OFFSET * 2)
          offsetX = offsetX + width
          totalIndex = totalIndex + 1
        end
        offsetY = offsetY + height
        offsetX = 0
      end
    elseif GOODS_LAYOUT_BIG == layoutType then
      height = height * 2
      local totalIndex = 1
      for j = 1, GOODS_ROW_COUNT / 2 do
        for i = 1, GOODS_COL_COUNT do
          each = self.goods[(j - 1) * GOODS_COL_COUNT + i]
          if totalIndex == 1 then
            each.centerLine:SetVisible(true)
            each.crossLine:SetVisible(true)
          end
          if totalIndex % 2 == 1 and j == GOODS_ROW_COUNT / 2 then
            each.underLineL:SetVisible(false)
            each.underLineR:SetVisible(false)
          end
          each.dateGroup:Show(true)
          each:RemoveAllAnchors()
          each:SetExtent(width, height)
          each:AddAnchor("TOPLEFT", self, "TOPLEFT", offsetX, offsetY)
          ApplyTextColor(each.goodsName, FONT_COLOR.BLUE)
          each.disPrice:RemoveAllAnchors()
          each.disPrice:AddAnchor("TOPLEFT", each.goodsName, "BOTTOMLEFT", 0, EACH_GOODS_MIN_OFFSET * 2)
          each.price:RemoveAllAnchors()
          each.price:AddAnchor("TOPRIGHT", each.goodsName, "BOTTOMRIGHT", 0, EACH_GOODS_MIN_OFFSET * 2)
          each.buyButton:RemoveAllAnchors()
          each.buyButton:AddAnchor("BOTTOM", each, "BOTTOM", 0, -EACH_GOODS_MIN_OFFSET * 2)
          offsetX = offsetX + width
          totalIndex = totalIndex + 1
        end
        offsetY = offsetY + height
        offsetX = 0
      end
    end
  end
  for j = 1, GOODS_ROW_COUNT do
    for i = 1, GOODS_COL_COUNT do
      do
        local each = goodsGroup.goods[(j - 1) * GOODS_COL_COUNT + i]
        function each:StopSale(stopReason)
          if stopReason == STOP_SALE_BY_COUNT then
            self.stopSale.msg:SetText(locale.inGameShop.soldOutError)
            self.stopSale:Show(true)
            self.stopSale:Raise()
          elseif stopReason == STOP_SALE_BY_ENDDATE then
            self.stopSale.msg:SetText(locale.inGameShop.expiredDateError)
            self.stopSale:Show(true)
            self.stopSale:Raise()
          else
            self.stopSale:Show(false)
          end
        end
        function each:UpdateButtons(cmdUi, showBuy, showPresent, showCart)
          self.buyButton:Show(showBuy)
          self.presentButton:Show(showPresent)
          self.putToCartButton:Show(showCart)
          self.buyButton:Enable(false)
          self.presentButton:Enable(false)
          self.putToCartButton:Enable(false)
          if cmdUi == CU_ALL then
            self.buyButton:Enable(true)
            self.presentButton:Enable(true)
            self.putToCartButton:Enable(true)
          elseif cmdUi == CU_BUY_PRESENT then
            self.buyButton:Enable(true)
            self.presentButton:Enable(true)
          elseif cmdUi == CU_BUY_CART then
            self.buyButton:Enable(true)
            self.putToCartButton:Enable(true)
          elseif cmdUi == CU_BUY then
            self.buyButton:Enable(true)
          end
        end
        function each:SetInfo(goodsInfo, index, page)
          local show = false
          local itemType = 715
          local eventType = "none"
          local goodsName = locale.inGameShop.unknownName
          local disPriceText = ""
          local priceText = ""
          local remainCountText = ""
          local startDateText = ""
          local endDateText = ""
          local cmdUi
          local showBuyButton = true
          local showPresentButton = true
          local showCartButton = true
          local stopSaleReason = STOP_SALE_NONE
          local priceColor = {
            0,
            0,
            0,
            1
          }
          local count = 0
          if goodsInfo ~= nil then
            if goodsInfo.isKnown == true then
              itemType = goodsInfo.itemType
              eventType = goodsInfo.eventType
              goodsName = goodsInfo.name
              local pricePreStr = ""
              if goodsGroup.layoutType == GOODS_LAYOUT_BIG then
                pricePreStr = FONT_COLOR_HEX.DEFAULT .. locale.inGameShop.price
              end
              if goodsInfo.disPrice ~= nil then
                priceText = SettingGoodPriceText(goodsInfo.price, goodsInfo.priceType, nil, goodsInfo.payItemType)
              else
                priceText = pricePreStr .. SettingGoodPriceText(goodsInfo.price, goodsInfo.priceType, nil, goodsInfo.payItemType)
              end
              priceColor = GetPriceColor(goodsInfo.priceType)
              if goodsInfo.disPrice ~= nil then
                disPriceText = pricePreStr .. SettingGoodPriceText(goodsInfo.disPrice, goodsInfo.priceType, nil, goodsInfo.payItemType)
              end
              if goodsInfo.selectType == "count" then
                count = goodsInfo[goodsInfo.selectType]
              end
              cmdUi = goodsInfo.cmdUi
              if goodsInfo.limited ~= nil then
                if 0 <= goodsInfo.limited.remainCount then
                  remainCountText = locale.inGameShop.remain .. locale.common.GetAmount(goodsInfo.limited.remainCount)
                end
                if goodsInfo.limited.startDate ~= nil then
                  startDateText = locale.inGameShop.startDate .. locale.time.GetDateToSimpleDateFormat(goodsInfo.limited.startDate)
                end
                if goodsInfo.limited.endDate ~= nil then
                  endDateText = locale.inGameShop.endDate .. locale.time.GetDateToSimpleDateFormat(goodsInfo.limited.endDate)
                end
                showPresentButton = false
                showCartButton = false
                stopSaleReason = goodsInfo.limited.stopSaleReason
                if stopSaleReason ~= STOP_SALE_NONE then
                  cmdUi = nil
                  if stopSaleReason ~= STOP_SALE_BY_STARTDATE then
                    index, page = nil, nil
                  end
                end
              end
            else
              index, page = nil, nil
              local buyType = goodsInfo.buyType
              if buyType == "quest" then
                priceText = locale.inGameShop.GetRequiredQuest(X2Quest:GetQuestContextMainTitle(goodsInfo[buyType]))
              elseif buyType == "level" then
                priceText = locale.inGameShop.GetRequiredLevel(goodsInfo[buyType])
              end
              showBuyButton = false
              showPresentButton = false
              showCartButton = false
            end
            show = true
          end
          self.index = index
          self.page = page
          local itemInfo = X2Item:GetItemInfoByType(itemType)
          self.slot:SetItemInfo(itemInfo)
          local drawableInfo = GetIngameshopEventTypeKey(eventType)
          if drawableInfo ~= nil then
            self.eventTypeIcon:SetTexture(drawableInfo.path)
            self.eventTypeIcon:SetTextureInfo(drawableInfo.key)
            if ingameshopLocale.eventIconFixedExtent then
              self.eventTypeIcon:SetExtent(GetEventTypeIconExtent(self.eventTypeIcon:GetExtent()))
            end
            self.eventTypeIcon:SetVisible(true)
          else
            self.eventTypeIcon:SetVisible(false)
          end
          self.eventType = eventType
          self.slot:SetStack(count)
          self.goodsName:SetText(goodsName)
          local targetWidth = self.goodsName:GetWidth()
          self.disPrice:SetWidth(targetWidth)
          self.disPrice:SetText(disPriceText)
          local realWidth = targetWidth
          if disPriceText ~= "" then
            realWidth = realWidth - self.disPrice:GetLongestLineWidth() - 25
            self.price:SetStrikeThrough(true)
            self.price:SetLineColor(priceColor[1], priceColor[2], priceColor[3], priceColor[4])
          else
            self.price:SetStrikeThrough(false)
          end
          self.price:SetWidth(realWidth)
          self.price:SetText(priceText)
          self.remain:SetText(remainCountText)
          self.dateGroup.startDate:SetText(startDateText)
          self.dateGroup.endDate:SetText(endDateText)
          self:UpdateButtons(cmdUi, showBuyButton, showPresentButton, showCartButton)
          self:StopSale(stopSaleReason)
          self:Show(show)
        end
        function each.slot:OnClickProc()
          if each.index ~= nil then
            local info = self.info
            if info.isPetOnly == false then
              inGameShopFrame:EquipItem(info.itemType, info.item_impl)
            end
          end
        end
        function each.buyButton:OnEnter()
          if each.buyButton:IsEnabled() then
            SetTargetAnchorTooltip(locale.inGameShop.buyButtonTooltip, "TOP", self, "BOTTOM")
          else
            SetTargetAnchorTooltip(GetUIText(ERROR_MSG, "INGAME_SHOP_EXPIRED_SELL_BY_DATE"), "TOP", self, "BOTTOM")
          end
        end
        each.buyButton:SetHandler("OnEnter", each.buyButton.OnEnter)
        function each.buyButton:OnLeave()
          HideTooltip()
        end
        each.buyButton:SetHandler("OnLeave", each.buyButton.OnLeave)
        function each.buyButton:OnClick()
          if each.index ~= nil then
            X2InGameShop:SelectGoods(each.page, each.index)
            inGameShopFrame:UpdateSelectedGoods(CONFIRM_TYPE_BUY)
          end
        end
        each.buyButton:SetHandler("OnClick", each.buyButton.OnClick)
        function each.presentButton:OnEnter()
          SetTargetAnchorTooltip(locale.inGameShop.presentButtonTooltip, "TOP", self, "BOTTOM")
        end
        each.presentButton:SetHandler("OnEnter", each.presentButton.OnEnter)
        function each.presentButton:OnLeave()
          HideTooltip()
        end
        each.presentButton:SetHandler("OnLeave", each.presentButton.OnLeave)
        function each.presentButton:OnClick()
          if each.index ~= nil then
            X2InGameShop:SelectGoods(each.page, each.index)
            inGameShopFrame:UpdateSelectedGoods(CONFIRM_TYPE_PRESENT)
          end
        end
        each.presentButton:SetHandler("OnClick", each.presentButton.OnClick)
        function each.putToCartButton:OnEnter()
          SetTargetAnchorTooltip(locale.inGameShop.cartButtonTooltip, "TOP", self, "BOTTOM")
        end
        each.putToCartButton:SetHandler("OnEnter", each.putToCartButton.OnEnter)
        function each.putToCartButton:OnLeave()
          HideTooltip()
        end
        each.putToCartButton:SetHandler("OnLeave", each.putToCartButton.OnLeave)
        function each.putToCartButton:OnClick()
          if each.index ~= nil then
            X2InGameShop:SelectGoods(each.page, each.index)
            inGameShopFrame:UpdateSelectedGoods(CONFIRM_TYPE_GO_CART)
          end
        end
        each.putToCartButton:SetHandler("OnClick", each.putToCartButton.OnClick)
      end
    end
  end
end
function SetCartInfoSectionFunc(cartInfoSection)
  for i = 1, CART_PREVIEW_COUNT do
    local slot = cartInfoSection.cartPreview.slots[i]
    function slot:OnEnter()
      local tip = self:GetTooltip()
      ShowTooltip(tip, self, 1, false, ONLY_BASE)
    end
    slot:SetHandler("OnEnter", slot.OnEnter)
    function slot:OnLeave()
      HideTooltip()
    end
    slot:SetHandler("OnLeave", slot.OnLeave)
    function slot:OnClick(arg)
      if arg == "RightButton" then
        HideTooltip()
        if self.cartIndex ~= nil then
          X2InGameShop:DeleteGoodsInCart(self.cartIndex)
          inGameShopFrame:UpdateCartPreview()
        end
      end
    end
    slot:SetHandler("OnClick", slot.OnClick)
  end
  function cartInfoSection.cartPreview:OnPageChanged(pageIndex, countPerPage)
    for i = 1, CART_PREVIEW_COUNT do
      local slot = self.slots[i]
      slot.cartIndex = nil
      slot:Show(false)
    end
    local startIndex = (pageIndex - 1) * countPerPage + 1
    local cartInfos = X2InGameShop:GetCartInfos(false)
    local slotIndex = 1
    local infos = cartInfos.infos
    for i = 1, #infos do
      if i >= startIndex and slotIndex <= CART_PREVIEW_COUNT then
        local slot = self.slots[slotIndex]
        local count = self.slots[slotIndex].count
        local goodsInfo = infos[i]
        slot.cartIndex = infos[i].index
        local gradeInfo = X2Item:GetItemInfoByType(goodsInfo.itemType, 0, IIK_GRADE)
        if gradeInfo.fixedGrade ~= nil then
          slot:SetItem(goodsInfo.itemType, gradeInfo.fixedGrade)
        else
          slot:SetItem(goodsInfo.itemType, 0)
        end
        slot:Show(true)
        slotIndex = slotIndex + 1
        if goodsInfo.selectType == "count" then
          slot:SetStack(goodsInfo.count)
        else
          slot:SetStack("")
        end
      end
    end
  end
  function cartInfoSection.buyCart:OnEnter()
    SetTargetAnchorTooltip(locale.inGameShop.buyButtonTooltip, "TOP", self, "BOTTOM")
  end
  cartInfoSection.buyCart:SetHandler("OnEnter", cartInfoSection.buyCart.OnEnter)
  function cartInfoSection.buyCart:OnLeave()
    HideTooltip()
  end
  cartInfoSection.buyCart:SetHandler("OnLeave", cartInfoSection.buyCart.OnLeave)
  function cartInfoSection.buyCart:OnClick()
    inGameShopFrame.cartFrame:ApplyCartInfos(CRAT_OPEN_TYPE_BUY)
  end
  cartInfoSection.buyCart:SetHandler("OnClick", cartInfoSection.buyCart.OnClick)
  function cartInfoSection.presentCart:OnEnter()
    SetTargetAnchorTooltip(locale.inGameShop.presentButtonTooltip, "TOP", self, "BOTTOM")
  end
  cartInfoSection.presentCart:SetHandler("OnEnter", cartInfoSection.presentCart.OnEnter)
  function cartInfoSection.presentCart:OnLeave()
    HideTooltip()
  end
  cartInfoSection.presentCart:SetHandler("OnLeave", cartInfoSection.presentCart.OnLeave)
  function cartInfoSection.presentCart:OnClick()
    inGameShopFrame.cartFrame:ApplyCartInfos(CRAT_OPEN_TYPE_PRESENT)
  end
  cartInfoSection.presentCart:SetHandler("OnClick", cartInfoSection.presentCart.OnClick)
end
function SetCashInfoFunc(frame)
  function frame.chargeCash:OnClick()
    RequestCashCharge(frame)
  end
  frame.chargeCash:SetHandler("OnClick", frame.chargeCash.OnClick)
  if frame.chargeAAPoint ~= nil then
    function frame.chargeAAPoint:OnClick()
      inGameShopFrame.aapointBuyFrame.ShowAAPointBuyFrame(inGameShopFrame)
    end
    frame.chargeAAPoint:SetHandler("OnClick", frame.chargeAAPoint.OnClick)
  end
end
function SetModelViewFunc(modelView)
  if modelView.reset ~= nil then
    function modelView.reset:OnClick()
      modelView:StopAnimation()
      modelView:ResetEquips()
      modelView:PlayAnimation(RELAX_ANIMATION_NAME, true)
    end
    modelView.reset:SetHandler("OnClick", modelView.reset.OnClick)
  end
  local featureSet = X2Player:GetFeatureSet()
  if modelView.beautyshop ~= nil then
    modelView.beautyshop:Show(featureSet.beautyshopBypass)
    function modelView.beautyshop:OnEnter()
      HideTooltip()
      SetTooltip(self.tooltip, self)
    end
    modelView.beautyshop:SetHandler("OnEnter", modelView.beautyshop.OnEnter)
    function modelView.beautyshop:OnLeave()
      HideTooltip()
    end
    modelView.beautyshop:SetHandler("OnLeave", modelView.beautyshop.OnLeave)
    function modelView.beautyshop:OnClick()
      X2InGameShop:EnterBeautyShop()
    end
    modelView.beautyshop:SetHandler("OnClick", modelView.beautyshop.OnClick)
  end
  if modelView.genderTransfer ~= nil then
    modelView.genderTransfer:Show(featureSet.beautyshopBypass)
    function modelView.genderTransfer:OnEnter()
      HideTooltip()
      SetTooltip(self.tooltip, self)
    end
    modelView.genderTransfer:SetHandler("OnEnter", modelView.genderTransfer.OnEnter)
    function modelView.genderTransfer:OnLeave()
      HideTooltip()
    end
    modelView.genderTransfer:SetHandler("OnLeave", modelView.genderTransfer.OnLeave)
    function modelView.genderTransfer:OnClick()
      X2InGameShop:GenderTransfer()
    end
    modelView.genderTransfer:SetHandler("OnClick", modelView.genderTransfer.OnClick)
  end
end
function CreateInGameShopFrame(id, parent)
  local frame = SetViewOfInGameShopFrame(id, parent)
  for i = 1, #frame.subMenuButtons do
    local subMenuButton = frame.subMenuButtons[i]
    function subMenuButton:UpdateSelectedView()
      SetButtonFontColor(self, GetWhiteCheckButtonFontColor())
      self.style:SetShadow(true)
      local unselectedColor = {
        normal = {
          ConvertColor(44),
          ConvertColor(100),
          ConvertColor(136),
          1
        },
        highlight = {
          ConvertColor(130),
          ConvertColor(190),
          ConvertColor(228),
          1
        },
        pushed = {
          ConvertColor(44),
          ConvertColor(100),
          ConvertColor(136),
          1
        },
        disabled = {
          ConvertColor(152),
          ConvertColor(152),
          ConvertColor(152),
          1
        }
      }
      for j = 1, #frame.subMenuButtons do
        if self ~= frame.subMenuButtons[j] then
          SetButtonFontColor(frame.subMenuButtons[j], unselectedColor)
          frame.subMenuButtons[j].style:SetShadow(false)
        end
      end
      frame.mainMenuTab.selectedBg:RemoveAllAnchors()
      frame.mainMenuTab.selectedBg:AddAnchor("TOPLEFT", self, -10, -4)
      frame.mainMenuTab.selectedBg:AddAnchor("BOTTOMRIGHT", self, 10, 4)
    end
    function subMenuButton:OnClick()
      if self.tabIndex ~= nil then
        info.subTabIdx = self.tabIndex
        X2InGameShop:SelectSubTab(self.tabIndex)
        self:UpdateSelectedView()
      end
    end
    subMenuButton:SetHandler("OnClick", subMenuButton.OnClick)
  end
  SetModelViewFunc(frame.modelView)
  SetGoodsFunc(frame.goodsGroup)
  frame.goodsGroup:SetLayout(GOODS_LAYOUT_SMALL)
  SetCartInfoSectionFunc(frame.cartInfoSection)
  SetCashInfoFunc(frame)
  function frame:InitSubMenuButtons()
    if self.mainMenuTab.selectedButton[self.mainMenuTab:GetSelectedTab()] == nil then
      return
    end
    local selectedMainTabIndex = self.mainMenuTab.selectedButton[self.mainMenuTab:GetSelectedTab()].tabIndex
    if selectedMainTabIndex == nil then
      return
    end
    local tabs = X2InGameShop:GetSubTabs()
    if tabs ~= nil then
      ingameshopLocale.ApplyCustomTabSetting(tabs, selectedMainTabIndex)
      local validSubIdx = false
      for i = 1, #tabs do
        if info.subTabIdx == tabs[i] then
          validSubIdx = true
          break
        end
      end
      if not validSubIdx then
        info.subTabIdx = tabs[1]
      end
      local count = #tabs
      local widthSum = 5
      local height = FONT_SIZE.MIDDLE + 14
      local offsetY = self.mainMenuTab.selectedButton[1]:GetHeight() + 13
      local offsetX = self.subMenuButtons[1].seperateLabel:GetWidth()
      local limitWidth = self.mainMenuTab.window[1]:GetWidth()
      local isOneLine = true
      for i = 1, #self.subMenuButtons do
        local subMenuButton = self.subMenuButtons[i]
        if i <= count then
          subMenuButton:SetText(locale.inGameShop.GetSubMenuName(selectedMainTabIndex, tabs[i]))
          subMenuButton.tabIndex = tabs[i]
          subMenuButton:RemoveAllAnchors()
          if limitWidth < widthSum + subMenuButton:GetWidth() then
            widthSum = 5
            offsetY = offsetY + height
            isOneLine = false
            self.subMenuButtons[i - 1].seperateLabel:Show(false)
          end
          subMenuButton:AddAnchor("TOPLEFT", self.mainMenuTab, "TOPLEFT", widthSum, offsetY)
          subMenuButton:SetHeight(height)
          widthSum = widthSum + subMenuButton:GetWidth() + offsetX
          if i == count then
            subMenuButton.seperateLabel:Show(false)
          else
            subMenuButton.seperateLabel:Show(true)
          end
          if info.subTabIdx == tabs[i] then
            subMenuButton:UpdateSelectedView()
          end
          subMenuButton:Show(true)
        else
          subMenuButton:Show(false)
        end
      end
      if isOneLine then
        self.mainMenuTab.subMenuBg:SetHeight(SUBMENU_GROUP_BG_HEIGHT_ONE_LINE)
      else
        self.mainMenuTab.subMenuBg:SetHeight(SUBMENU_GROUP_BG_HEIGHT_TWO_LINE)
      end
      self.goodsGroup:Show(false)
    end
  end
  function frame:InitMainMenuTab()
    self.mainMenuTab:ReleaseHandler("OnTabChanged")
    local tabs = X2InGameShop:GetMainTabs()
    if tabs ~= nil then
      self.mainMenuTab:SetActivateTabCount(#tabs)
      self.mainMenuTab:SelectTab(1)
      local usingTabCount = math.min(#tabs, #self.mainMenuTab.window)
      for i = 1, #self.mainMenuTab.window do
        if i <= usingTabCount then
          local menuName = locale.inGameShop.GetMainMenuName(tabs[i])
          self.mainMenuTab.selectedButton[i]:SetText(menuName)
          self.mainMenuTab.unselectedButton[i]:SetText(menuName)
          self.mainMenuTab.selectedButton[i].tabIndex = tabs[i]
          if info.mainTabIdx == tabs[i] then
            self.mainMenuTab:SelectTab(i)
          end
        else
          self.mainMenuTab.selectedButton[i]:SetText("")
          self.mainMenuTab.unselectedButton[i]:SetText("")
          self.mainMenuTab.selectedButton[i].tabIndex = nil
        end
      end
      function self.mainMenuTab:OnTabChanged(tabIndex)
        ReAnhorTabLine(self, tabIndex)
        if self.selectedButton[tabIndex].tabIndex ~= nil then
          info.mainTabIdx = self.selectedButton[tabIndex].tabIndex
          info.subTabIdx = ingameshopLocale.GetInitialSubTabIndex(info.mainTabIdx)
          SelectMainTab(info.mainTabIdx, info.subTabIdx)
        end
      end
      self.mainMenuTab:SetHandler("OnTabChanged", self.mainMenuTab.OnTabChanged)
      self:InitSubMenuButtons()
      self.mainMenuTab:Show(true)
    else
      self.mainMenuTab:Show(false)
    end
  end
  function frame:UpdateGoods(page, countPerPage, totalPage)
    self.goodsGroup:SetLayout(countPerPage)
    local totalIndex = 1
    for j = 1, GOODS_ROW_COUNT do
      for i = 1, GOODS_COL_COUNT do
        local goodsInfo = X2InGameShop:GetGoods(page, totalIndex)
        local each = self.goodsGroup.goods[(j - 1) * GOODS_COL_COUNT + i]
        each:SetInfo(goodsInfo, totalIndex, page)
        totalIndex = totalIndex + 1
      end
    end
    self.page:SetCurrentPage(page, false)
    self.page:SetPageCount(totalPage, countPerPage)
    self.page:Enable(true)
  end
  function frame:UpdateSelectedGoods(confirmType)
    local isPresent = confirmType == CONFIRM_TYPE_PRESENT
    local selectedgoodsInfo = X2InGameShop:GetSelectedGoods(isPresent)
    self.confirmFrame:SetLayout(confirmType, selectedgoodsInfo)
    self.confirmFrame:Raise()
  end
  function frame:UpdateCartPreview()
    local cartInfos = X2InGameShop:GetCartInfos(false)
    local count = #cartInfos.infos
    local totalPage = count / CART_PREVIEW_COUNT
    if totalPage > math.floor(totalPage) then
      totalPage = math.floor(totalPage + 1)
    end
    local color = count == MAX_INGAME_SHOP_UPDATE and FONT_COLOR_HEX.RED or FONT_COLOR_HEX.BLUE
    local titleStr = string.format("%s %s%d|r/%d", GetUIText(INGAMESHOP_TEXT, "cart"), color, count, MAX_INGAME_SHOP_UPDATE)
    self.cartInfoSection.title:SetText(titleStr)
    self.cartInfoSection.cartPreview:SetPageCount(totalPage, CART_PREVIEW_COUNT)
    self.cartInfoSection.cartPreview:Refresh()
    self.cartInfoSection.cartPreview:Enable(true)
  end
  function frame:UpdateMoneyView()
    local cashText = X2Player:GetMyCash()
    local aapointText = X2Util:GetMyAAPointString()
    local bmMileageText = X2Player:GetBmPoint()
    local aaCoinText = X2Player:GetAaCoin()
    self.moneyView:UpdateCurrent(cashText, aapointText, bmMileageText, aaCoinText)
  end
  function frame:UpdateExchangeRatio()
    if self.chargeAAPoint ~= nil then
      self.chargeAAPoint:Enable(X2Player:GetExchangeRatio() > 0)
    end
  end
  function frame:EquipItem(itemType, itemImplement)
    if itemImplement == "weapon" then
      self.modelView.equippedWeapon = true
    end
    self.modelView:StopAnimation()
    self.modelView:EquipItem(itemType)
    if self.modelView.equippedWeapon == true then
      self.modelView:PlayAnimation(ONEHAND_WEAPON_ANIMATION_NAME, true)
    else
      self.modelView:PlayAnimation(RELAX_ANIMATION_NAME, true)
    end
  end
  function frame:Waiting(use)
    if self.waiting == nil then
      return
    end
    self:SetCloseOnEscape(not use, not use)
    self.confirmFrame:Lock(use)
    self.waiting:Show(use)
    self.waiting.waiting_effect:SetStartEffect(use)
    if use == true then
      self.confirmFrame:Raise()
    end
  end
  local OnHide = function(self)
    self.modelView:StopAnimation()
    self.modelView:ClearModel()
    if self.cartFrame ~= nil then
      self.cartFrame:Show(false)
    end
    if self.confirmFrame ~= nil then
      self.confirmFrame:Show(false)
    end
    if self.buyResultFrame ~= nil then
      self.buyResultFrame:Show(false)
    end
  end
  frame:SetHandler("OnHide", OnHide)
  function frame:InitModelView()
    self.modelView.equippedWeapon = false
    self.modelView:Init("player", true)
    self.modelView:SetIngameShopMode(true)
    local adjust = GetAdjustCamera(X2Unit:UnitRace("player"), X2Unit:UnitGender("player"))
    if adjust ~= nil then
      self.modelView:AdjustCameraPos(adjust.center, adjust.zoom, adjust.height)
    end
    self.modelView:PlayAnimation(RELAX_ANIMATION_NAME, true)
  end
  function frame:ResetModelView()
    self.modelView:ClearModel()
    self:InitModelView()
    X2InGameShop:SelectPage(frame.page.currentPage)
  end
  function frame:UpdateBeautyShopStatus()
    local status = X2Customizer:CanEnterBeautyShop()
    if status == BSS_GENDER_TRANSFERED then
      self.modelView.beautyshop:Enable(false)
      self.modelView.genderTransfer:Enable(false)
      self.modelView.beautyshop.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "already_gender_transfered")
      self.modelView.genderTransfer.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "already_gender_transfered")
    elseif status == BSS_INVALID_PLACE then
      self.modelView.beautyshop:Enable(false)
      self.modelView.genderTransfer:Enable(true)
      self.modelView.beautyshop.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "can_not_enter_beautyshop")
      self.modelView.genderTransfer.tooltip = locale.inGameShop.genderTransfer
    elseif status == BSS_POSSIBLE then
      self.modelView.beautyshop:Enable(true)
      self.modelView.genderTransfer:Enable(true)
      self.modelView.beautyshop.tooltip = locale.inGameShop.enterBeautyShop
      self.modelView.genderTransfer.tooltip = locale.inGameShop.genderTransfer
    else
      self.modelView.beautyshop:Enable(false)
      self.modelView.genderTransfer:Enable(false)
      self.modelView.beautyshop.tooltip = nil
      self.modelView.genderTransfer.tooltip = nil
    end
  end
  if ingameshopLocale.eventIconFixedExtent then
    local function OnScale()
      for j = 1, GOODS_ROW_COUNT do
        for i = 1, GOODS_COL_COUNT do
          local each = frame.goodsGroup.goods[(j - 1) * GOODS_COL_COUNT + i]
          if each.eventType ~= nil and each.eventType ~= "none" then
            local drawableInfo = GetIngameshopEventTypeKey(each.eventType)
            if drawableInfo ~= nil then
              local extent = UIParent:GetTextureData(drawableInfo.path, drawableInfo.key).extent
              each.eventTypeIcon:SetExtent(GetEventTypeIconExtent(extent[1], extent[2]))
            end
          end
        end
      end
    end
    frame:SetHandler("OnScale", OnScale)
  end
  function frame:ShowProc()
    self:UpdateMoneyView()
    self:UpdateExchangeRatio()
    self:InitModelView()
    self:UpdateBeautyShopStatus()
  end
  function frame.page:OnPageChanged(pageIndex, countPerPage)
    X2InGameShop:SelectPage(pageIndex)
  end
  function frame.commercialMailBtn:OnEnter()
    SetTargetAnchorTooltip(locale.inGameShop.commercialMailButtonTooltip, "TOP", self, "BOTTOM")
  end
  frame.commercialMailBtn:SetHandler("OnEnter", frame.commercialMailBtn.OnEnter)
  function frame.commercialMailBtn:OnLeave()
    HideTooltip()
  end
  frame.commercialMailBtn:SetHandler("OnLeave", frame.commercialMailBtn.OnLeave)
  function frame.commercialMailBtn:OnClick()
    ToggleComercialMailBox()
  end
  frame.commercialMailBtn:SetHandler("OnClick", frame.commercialMailBtn.OnClick)
  SetHandlerCommercialMailBadge(frame.commercialMailBtn.unreadCommercialMailCounter)
  frame:Show(false)
  return frame
end
function CreateWaiting(id, parent)
  local widget = SetViewOfWaiting(id, parent)
  function widget:OnShow()
    self:Raise()
  end
  widget:SetHandler("OnShow", widget.OnShow)
  widget:Show(false)
  return widget
end
inGameShopFrame = CreateInGameShopFrame("inGameShopFrame", "UIParent")
inGameShopFrame:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
inGameShopFrame.cartFrame = CreateCartFrame("inGameShopFrame.cartFrame", inGameShopFrame)
inGameShopFrame.aapointBuyFrame = GetAAPointBuyFrame()
inGameShopFrame.confirmFrame = CreateConfirmFrame("inGameShopFrame.confirmFrame", inGameShopFrame)
inGameShopFrame.resultFrame = CreateResultFrame("inGameShopFrame.buyResult", inGameShopFrame)
inGameShopFrame.waiting = CreateWaiting("waiting", inGameShopFrame)
local cashStoreEvents = {
  UPDATE_INGAME_SHOP = function(arg1, arg2, arg3, arg4)
    if arg1 == "maintab" then
      if info.mainTabIdx == nil then
        info.mainTabIdx = X2InGameShop:GetFirstMainTabIndex()
        info.subTabIdx = ingameshopLocale.GetInitialSubTabIndex(info.mainTabIdx)
      end
      inGameShopFrame:InitMainMenuTab()
    elseif arg1 == "subtab" then
      inGameShopFrame:InitSubMenuButtons()
    elseif arg1 == "goods" then
      inGameShopFrame:UpdateGoods(arg2, arg3, arg4)
      X2Security:RecommendUsingSecondPassword()
    elseif arg1 == "restrict" then
      if inGameShopFrame:IsVisible() == false then
        return
      end
      inGameShopFrame:UpdateGoods(arg2, arg3, arg4)
      inGameShopFrame:UpdateSelectedGoods()
    elseif arg1 == "cart" then
      inGameShopFrame.cartFrame:ApplyCartInfos()
      inGameShopFrame:UpdateCartPreview()
    elseif arg1 == "checkTime" then
      if inGameShopFrame:IsVisible() == false then
        return
      end
      local DecorateNotifyFunc = function(wnd, infoTable)
        function wnd:OkProc()
          inGameShopFrame:Show(false)
          wnd:Show(false)
        end
        wnd:SetTitle(locale.inGameShop.nowCheckTimeTitle)
        wnd:SetContent(locale.inGameShop.nowCheckTime, true)
      end
      X2DialogManager:RequestNoticeDialog(DecorateNotifyFunc, "")
    elseif arg1 == "exchange_ratio" then
      inGameShopFrame:UpdateExchangeRatio()
    end
  end,
  INGAME_SHOP_BUY_RESULT = function()
    if inGameShopFrame.resultFrame:ShowBuyResultInfo() then
      inGameShopFrame.cartFrame:Show(false)
      inGameShopFrame.confirmFrame:Show(false)
    end
  end,
  WAIT_REPLY_FROM_SERVER = function(arg)
    if inGameShopFrame:IsVisible() == false then
      return
    end
    inGameShopFrame:Waiting(arg)
  end,
  RESET_INGAME_SHOP_MODELVIEW = function()
    if inGameShopFrame:IsVisible() then
      inGameShopFrame:ResetModelView()
    end
  end,
  GENDER_TRANSFERED = function()
    local ResultGenderTransfer = function(wnd, infoTable)
      function wnd:OkProc()
        wnd:Show(false)
      end
      wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "genderTransfer_title"))
      local str = X2Locale:LocalizeUiText(COMMON_TEXT, "reconnect_to_transfer_gender")
      wnd:SetContent(str, true)
    end
    if inGameShopFrame:IsVisible() then
      inGameShopFrame:UpdateBeautyShopStatus()
      X2DialogManager:RequestNoticeDialog(ResultGenderTransfer, inGameShopFrame:GetId())
    else
      X2DialogManager:RequestNoticeDialog(ResultGenderTransfer, "")
    end
  end,
  UPDATE_INGAME_BEAUTYSHOP_STATUS = function()
    if inGameShopFrame:IsVisible() then
      inGameShopFrame:UpdateBeautyShopStatus()
    end
  end,
  LEAVED_INSTANT_GAME_ZONE = function()
    if inGameShopFrame:IsVisible() then
      inGameShopFrame:UpdateBeautyShopStatus()
    end
  end,
  ENTERED_INSTANT_GAME_ZONE = function()
    if inGameShopFrame:IsVisible() then
      inGameShopFrame:UpdateBeautyShopStatus()
    end
  end,
  INGAME_SHOP_INITIALIZED = function()
    if inGameShopFrame:IsVisible() then
      SelectMainTab(info.mainTabIdx, info.subTabIdx)
    end
  end
}
inGameShopFrame:SetHandler("OnEvent", function(this, event, ...)
  cashStoreEvents[event](...)
end)
RegistUIEvent(inGameShopFrame, cashStoreEvents)
function ToggleInGameShop(show, mainTabIdx, subTabIdx)
  if show == nil then
    show = not inGameShopFrame:IsVisible()
  end
  if show == true then
    X2Player:RequestRefreshCash()
    local tabs = X2InGameShop:GetMainTabs()
    if tabs ~= nil and mainTabIdx == nil then
      mainTabIdx = X2InGameShop:GetFirstMainTabIndex()
      subTabIdx = ingameshopLocale.GetInitialSubTabIndex(subTabIdx)
    end
    info.mainTabIdx = mainTabIdx
    info.subTabIdx = subTabIdx
    inGameShopFrame:InitMainMenuTab()
    if tabs == nil then
      SelectMainTab(0, 0)
    else
      SelectMainTab(mainTabIdx, subTabIdx)
    end
    inGameShopFrame:UpdateCartPreview()
  end
  inGameShopFrame:Show(show)
  X2InGameShop:CheckWaitingServer()
end
ADDON:RegisterContentTriggerFunc(UIC_INGAME_SHOP, ToggleInGameShop)
