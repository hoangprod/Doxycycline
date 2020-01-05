CONFIRM_TYPE_BUY = 1
CONFIRM_TYPE_GO_CART = 2
CONFIRM_TYPE_PRESENT = 3
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateConfirmFrame(id, parent)
  local frame = SetViewOfConfirmFrame(id, parent)
  frame.confirmType = nil
  frame.locked = false
  function frame:Lock(lock)
    self.locked = lock
    if self:IsVisible() then
      self:UpdateButtons()
    end
  end
  function frame:OnHide()
    self.selectedgoodsInfo = nil
    self.confirmType = nil
  end
  frame:SetHandler("OnHide", frame.OnHide)
  function frame.titleGroup.slot:OnEnter()
    local tip = self:GetTooltip()
    ShowTooltip(tip, self, 1, false, ONLY_BASE)
  end
  frame.titleGroup.slot:SetHandler("OnEnter", frame.titleGroup.slot.OnEnter)
  function frame.titleGroup.slot:OnLeave()
    HideTooltip()
  end
  frame.titleGroup.slot:SetHandler("OnLeave", frame.titleGroup.slot.OnLeave)
  function frame.titleGroup:SetInfo()
    local itemType = 0
    local goodsName = frame.selectedgoodsInfo.name
    local priceText = ""
    local priceColor = {
      0,
      0,
      0,
      1
    }
    local disPriceText = ""
    if frame.selectedgoodsInfo.package ~= nil then
      itemType = frame.selectedgoodsInfo.package.itemType
      priceText = SettingGoodPriceText(frame.selectedgoodsInfo.package.price, frame.selectedgoodsInfo.package.priceType, nil, frame.selectedgoodsInfo.package.payItemType)
      priceColor = GetPriceColor(frame.selectedgoodsInfo.package.priceType)
      if frame.selectedgoodsInfo.package.disPrice ~= nil then
        disPriceText = SettingGoodPriceText(frame.selectedgoodsInfo.package.disPrice, frame.selectedgoodsInfo.package.priceType, nil, frame.selectedgoodsInfo.package.payItemType)
      end
    else
      local selectedInfo = frame.selectedgoodsInfo.details[frame.selectedgoodsInfo.selectedDetailIndex]
      itemType = selectedInfo.itemType
      if selectedInfo.selectType == "name" then
        goodsName = selectedInfo[selectedInfo.selectType]
        local itemInfo = X2Item:GetItemInfoByType(selectedInfo.itemType, NORMAL_ITEM_GRADE, IIK_IMPL)
        inGameShopFrame:EquipItem(selectedInfo.itemType, itemInfo.item_impl)
      end
      priceText = SettingGoodPriceText(selectedInfo.price, selectedInfo.priceType, nil, selectedInfo.payItemType)
      priceColor = GetPriceColor(selectedInfo.priceType)
      if selectedInfo.disPrice ~= nil then
        disPriceText = SettingGoodPriceText(selectedInfo.disPrice, selectedInfo.priceType, nil, selectedInfo.payItemType)
      end
    end
    local gradeInfo = X2Item:GetItemInfoByType(itemType, 0, IIK_GRADE)
    if gradeInfo.fixedGrade ~= nil then
      self.slot:SetItem(itemType, gradeInfo.fixedGrade)
    else
      self.slot:SetItem(itemType, 0)
    end
    self.goodsName:SetText(goodsName)
    local targetWidth = self.goodsName:GetWidth()
    self.disPrice:SetWidth(targetWidth)
    self.disPrice:SetText(disPriceText)
    local realWidth = targetWidth
    if disPriceText ~= "" then
      realWidth = realWidth - self.disPrice:GetLongestLineWidth() - 45
      self.price:SetStrikeThrough(true)
      self.price:SetLineColor(priceColor[1], priceColor[2], priceColor[3], priceColor[4])
    else
      self.price:SetStrikeThrough(false)
    end
    self.price:SetWidth(realWidth)
    self.price:SetText(priceText)
  end
  function frame.eventGroup.slot:OnEnter()
    local tip = self:GetTooltip()
    ShowTooltip(tip, self, 1, false, ONLY_BASE)
  end
  frame.eventGroup.slot:SetHandler("OnEnter", frame.eventGroup.slot.OnEnter)
  function frame.eventGroup.slot:OnLeave()
    HideTooltip()
  end
  frame.eventGroup.slot:SetHandler("OnLeave", frame.eventGroup.slot.OnLeave)
  function frame.eventGroup:Update()
    local selectedDetailIndex = frame.selectedgoodsInfo.selectedDetailIndex
    local eventDateText = ""
    local bonusInfoText = ""
    local buyRestrictText = ""
    for i = 1, EVENT_INFO_MAX_COUNT do
      self.eventInfo[i]:SetText("")
    end
    if frame.selectedgoodsInfo.limited ~= nil and frame.selectedgoodsInfo.limited.endDate ~= nil then
      eventDateText = locale.inGameShop.eventDateTitle .. locale.time.GetDateToDateFormat(frame.selectedgoodsInfo.limited.endDate)
    elseif frame.selectedgoodsInfo.details[selectedDetailIndex].eventDate ~= nil then
      eventDateText = locale.inGameShop.eventDateTitle .. locale.time.GetDateToDateFormat(frame.selectedgoodsInfo.details[selectedDetailIndex].eventDate)
    end
    local bonusAAPoint, bonusItemInfo
    if frame.selectedgoodsInfo.package ~= nil then
      bonusAAPoint = frame.selectedgoodsInfo.package.bonusAAPoint
      bonusItemInfo = frame.selectedgoodsInfo.package.bonusItemInfo
    else
      bonusAAPoint = frame.selectedgoodsInfo.details[selectedDetailIndex].bonusAAPoint
      bonusItemInfo = frame.selectedgoodsInfo.details[selectedDetailIndex].bonusItemInfo
    end
    self.slot:Show(false)
    if bonusAAPoint ~= nil then
      if tonumber(bonusAAPoint) > 0 then
        bonusInfoText = locale.inGameShop.bonusAAPointTitle .. F_MONEY:SettingPriceText(bonusAAPoint, PRICE_TYPE_AA_POINT)
      end
      if X2InGameShop:GetSecondPriceType() ~= PRICE_TYPE_AA_POINT then
        bonusInfoText = ""
      end
    elseif bonusItemInfo ~= nil and 0 < bonusItemInfo.stack then
      local gradeInfo = X2Item:GetItemInfoByType(bonusItemInfo.itemType, 0, IIK_GRADE)
      if gradeInfo.fixedGrade ~= nil then
        self.slot:SetItem(bonusItemInfo.itemType, gradeInfo.fixedGrade)
      else
        self.slot:SetItem(bonusItemInfo.itemType, 0)
      end
      self.slot:SetStack(bonusItemInfo.stack)
      bonusInfoText = locale.inGameShop.bonusItemTitle
      self.slot:Show(true)
    end
    if frame.selectedgoodsInfo.limitType == "account" then
      buyRestrictText = locale.inGameShop.GetBuyPerAccount(frame.selectedgoodsInfo.buyCount)
    elseif frame.selectedgoodsInfo.limitType == "character" then
      buyRestrictText = locale.inGameShop.GetBuyPerCharacter(frame.selectedgoodsInfo.buyCount)
    elseif frame.selectedgoodsInfo.limitType == "day" then
      buyRestrictText = locale.inGameShop.GetBuyPerDay(frame.selectedgoodsInfo.buyCount)
    end
    local height = 0
    local index = 0
    if eventDateText ~= "" then
      index = index + 1
      self.eventInfo[index].style:SetAlign(ALIGN_LEFT)
      self.eventInfo[index]:SetText(eventDateText)
      self.eventInfo[index]:SetHeight(self.eventInfoDefaultHeight)
      height = height + self.eventInfoDefaultHeight
    end
    if bonusInfoText ~= "" then
      index = index + 1
      local offsetX = self.eventInfo[index].style:GetTextWidth(bonusInfoText)
      if self.slot:IsVisible() then
        self.eventInfo[index].style:SetAlign(ALIGN_TOP_LEFT)
        self.slot:RemoveAllAnchors()
        self.slot:AddAnchor("TOPLEFT", self.eventInfo[index], "TOPLEFT", offsetX, 0)
        self.eventInfo[index]:SetHeight(self.slot:GetHeight())
        height = height + self.slot:GetHeight()
      else
        self.eventInfo[index].style:SetAlign(ALIGN_LEFT)
        self.eventInfo[index]:SetHeight(self.eventInfoDefaultHeight)
        height = height + self.eventInfoDefaultHeight
      end
      self.eventInfo[index]:SetText(bonusInfoText)
    end
    if buyRestrictText ~= "" then
      index = index + 1
      self.eventInfo[index].style:SetAlign(ALIGN_LEFT)
      self.eventInfo[index]:SetText(buyRestrictText)
      self.eventInfo[index]:SetHeight(self.eventInfoDefaultHeight)
      height = height + self.eventInfoDefaultHeight
    end
    local height = height + BUY_CONFIRM_OFFSET * (4 + index - 1)
    if index == 0 then
      height = 0
      self.bg:SetVisible(false)
    else
      self.bg:SetVisible(true)
    end
    self:SetHeight(height)
  end
  for i = 1, PACKAGET_MAX_COUNT do
    local packageLine = frame.packageGroup.packageLines[i]
    function packageLine.slot:OnEnter()
      local tip = self:GetTooltip()
      ShowTooltip(tip, self, 1, false, ONLY_BASE)
    end
    packageLine.slot:SetHandler("OnEnter", packageLine.slot.OnEnter)
    function packageLine.slot:OnLeave()
      HideTooltip()
    end
    packageLine.slot:SetHandler("OnLeave", packageLine.slot.OnLeave)
  end
  function frame.packageGroup:SetInfo()
    if frame.selectedgoodsInfo.package ~= nil then
      frame.eventGroup:Update()
      local details = frame.selectedgoodsInfo.details
      local count = #details
      local packageContentHeight = 0
      for i = 1, PACKAGET_MAX_COUNT do
        local detailInfo = details[i]
        if i <= count then
          local gradeInfo = X2Item:GetItemInfoByType(detailInfo.itemType, 0, IIK_GRADE)
          if gradeInfo.fixedGrade ~= nil then
            self.packageLines[i].slot:SetItem(detailInfo.itemType, gradeInfo.fixedGrade)
          else
            self.packageLines[i].slot:SetItem(detailInfo.itemType, 0)
          end
          self.packageLines[i].slot:SetPackInfo(self.packageLines[i].slot:GetTooltip())
          self.packageLines[i].itemName:SetText(detailInfo.name)
          if detailInfo.selectType == "count" then
            self.packageLines[i].infoBySelectType:SetText(locale.common.GetAmount(detailInfo.count))
          elseif detailInfo.selectType == "time" then
            self.packageLines[i].infoBySelectType:SetText(GetPeriod(detailInfo.time))
          end
          local width = self.packageLines[i]:GetWidth() - self.packageLines[i].infoBySelectType:GetWidth() - self.packageLines[i].slot:GetWidth() - BUY_CONFIRM_OFFSET * 5
          self.packageLines[i].itemName:SetWidth(width)
          self.packageLines[i]:Show(true)
          SetUpperLineVisible(self.packageLines[i], true)
          packageContentHeight = packageContentHeight + PACKAGET_EACH_LINE_HEIGHT
        else
          self.packageLines[i]:Show(false)
          SetUpperLineVisible(self.packageLines[i], false)
        end
      end
      self:Show(true)
      self.scrollWindow:ResetScroll(packageContentHeight)
      frame:UpdateButtons()
    else
      self:Show(false)
    end
  end
  local detail = frame.detailGroup.details
  local function OnRadioChanged(self, index)
    if X2InGameShop:CheckSelectedGoodsDetail(index) == true then
      frame.selectedgoodsInfo.selectedDetailIndex = index
    end
    frame.titleGroup:SetInfo()
    frame.eventGroup:Update()
    frame:UpdateHeight()
  end
  detail:SetHandler("OnRadioChanged", OnRadioChanged)
  function frame.detailGroup:SetInfo()
    if frame.selectedgoodsInfo.package == nil then
      local checkedIndex = frame.selectedgoodsInfo.selectedDetailIndex
      local detailInfos = frame.selectedgoodsInfo.details
      local count = math.min(#detailInfos, GOOD_DETAIL_MAX_COUNT)
      local groupShow = false
      local radioData = {}
      for i = 1, GOOD_DETAIL_MAX_COUNT do
        local radioItem = {}
        local radioButtonText = ""
        local priceText = ""
        local eventType = "none"
        local show = false
        local detailInfo = detailInfos[i]
        if detailInfo ~= nil then
          eventType = detailInfo.eventType
          if detailInfo.selectType == "count" then
            radioButtonText = locale.common.GetAmount(detailInfo.count)
          elseif detailInfo.selectType == "time" then
            if detailInfo.time ~= nil then
              radioButtonText = GetPeriod(detailInfo.time)
            end
          elseif detailInfo.selectType == "name" then
            radioButtonText = detailInfo.name
          end
          if detailInfo.disPrice ~= nil then
            priceText = SettingGoodPriceText(detailInfo.disPrice, detailInfo.priceType, nil, detailInfo.payItemType)
          else
            priceText = SettingGoodPriceText(detailInfo.price, detailInfo.priceType, nil, detailInfo.payItemType)
          end
          radioItem.text = radioButtonText
          local drawableInfo = GetIngameshopEventTypeKey(eventType)
          if drawableInfo ~= nil then
            radioItem.image = {}
            radioItem.image.path = drawableInfo.path
            radioItem.image.key = drawableInfo.key
            radioItem.image.anchor = "right"
          end
          table.insert(radioData, radioItem)
          show = true
          groupShow = true
        end
        self.listCtrl.items[i].subItems[2]:SetText(priceText)
        SetUpperLineVisible(self.listCtrl.items[i], show)
      end
      self.details:SetData(radioData)
      self.details:Enable(groupShow)
      self.details:Check(checkedIndex, groupShow)
      self:Show(groupShow)
      self:Raise()
      frame:UpdateButtons()
    else
      self:Show(false)
    end
  end
  local function SetRefundMessage()
    if not baselibLocale.visibleRefundInfo then
      frame.refundMessage:Show(false)
      return
    end
    if frame.confirmType == CONFIRM_TYPE_GO_CART then
      frame.refundMessage:Show(false)
      return
    end
    if not baselibLocale.visibleAddedRefundInfo then
      if frame.confirmType ~= CONFIRM_TYPE_PRESENT then
        frame.refundMessage:Show(false)
        return
      end
      frame.refundMessage:SetText(GetUIText(INGAMESHOP_TEXT, "presentIsNotRefund"))
      frame.refundMessage:SetHeight(frame.refundMessage:GetTextHeight())
      frame.refundMessage:AddAnchor("TOP", frame.friendGroup, "BOTTOM", 0, sideMargin / 2)
      frame.refundMessage:Show(true)
    end
    local existAACashGoods = false
    if frame.selectedgoodsInfo.package == nil then
      local checkedIndex = frame.selectedgoodsInfo.selectedDetailIndex
      local detailInfos = frame.selectedgoodsInfo.details
      for i = 1, GOOD_DETAIL_MAX_COUNT do
        local detailInfo = detailInfos[i]
        if detailInfo ~= nil and detailInfo.priceType == PRICE_TYPE_AA_CASH then
          existAACashGoods = true
        end
      end
    else
      local selectedInfo = frame.selectedgoodsInfo.details[frame.selectedgoodsInfo.selectedDetailIndex]
      if selectedInfo.priceType == PRICE_TYPE_AA_CASH then
        existAACashGoods = true
      end
    end
    if not existAACashGoods then
      frame.refundMessage:Show(false)
      return
    end
    local str
    if frame.confirmType == CONFIRM_TYPE_PRESENT then
      str = GetUIText(INGAMESHOP_TEXT, "presentIsNotRefund")
    else
      str = GetUIText(COMMON_TEXT, "ingameshop_aacash_goods_refund_rule")
    end
    local function GetTarget()
      if frame.friendGroup:IsVisible() then
        return frame.friendGroup
      end
      if frame.detailGroup:IsVisible() then
        return frame.detailGroup
      end
      if frame.packageGroup:IsVisible() then
        return frame.packageGroup
      end
      if frame.titleGroup:IsVisible() then
        return frame.titleGroup
      end
    end
    frame.refundMessage:SetText(str)
    frame.refundMessage:SetHeight(frame.refundMessage:GetTextHeight())
    frame.refundMessage:RemoveAllAnchors()
    frame.refundMessage:AddAnchor("TOP", GetTarget(), "BOTTOM", 0, sideMargin / 2)
    frame.refundMessage:Show(true)
  end
  function frame.friendGroup.comboBox:SelectedProc()
    local text = ""
    local info = self:GetSelectedInfo()
    if info ~= nil then
      text = info.text
    end
    frame.friendGroup.inputFriend:SetText(text)
  end
  function frame.friendGroup:Update()
    if frame.confirmType == CONFIRM_TYPE_PRESENT then
      self:RemoveAllAnchors()
      if frame.selectedgoodsInfo.package ~= nil then
        self:AddAnchor("TOP", frame.packageGroup, "BOTTOM", 0, 0)
      else
        self:AddAnchor("TOP", frame.detailGroup, "BOTTOM", 0, 0)
      end
      self:SetWidth(frame.eventGroup:GetWidth())
      self.inputFriend:SetText("")
      local membersTable = X2Friend:GetFriendList(true)
      local datas = {}
      for i = 1, #membersTable do
        local data = {
          text = membersTable[i][1],
          value = i
        }
        table.insert(datas, data)
      end
      self.comboBox:AppendItems(datas, false)
      self.comboBox:SetText(locale.inGameShop.friend)
      self:Show(true)
    else
      self:Show(false)
    end
  end
  function frame:UpdateButtons()
    local cmdUi = self.selectedgoodsInfo.cmdUi
    if self.selectedgoodsInfo.limited ~= nil and self.selectedgoodsInfo.limited.stopSaleReason ~= STOP_SALE_NONE then
      cmdUi = nil
    end
    self.btnOk:Enable(false)
    if self.locked == true then
      return
    end
    if self.confirmType == CONFIRM_TYPE_BUY then
      self.btnOk:Enable(true)
    elseif self.confirmType == CONFIRM_TYPE_GO_CART then
      if cmdUi == CU_ALL or cmdUi == CU_BUY_CART then
        self.btnOk:Enable(true)
      end
    elseif self.confirmType == CONFIRM_TYPE_PRESENT and (cmdUi == CU_ALL or cmdUi == CU_BUY_PRESENT) then
      self.btnOk:Enable(true)
    end
  end
  function frame.btnOk:OnClick()
    if frame.confirmType == CONFIRM_TYPE_BUY then
      X2InGameShop:RequestBuy(BM_SELECTED, "")
    elseif frame.confirmType == CONFIRM_TYPE_GO_CART then
      local result = X2InGameShop:PutSelectedGoodsInCart()
      inGameShopFrame:UpdateCartPreview()
      if result ~= CFR_NONE then
        inGameShopFrame.resultFrame:ShowCartResultInfo(result)
      end
      frame:Show(false)
    elseif frame.confirmType == CONFIRM_TYPE_PRESENT then
      if frame.friendGroup.inputFriend:GetText() ~= "" then
        X2InGameShop:RequestBuy(BM_SELECTED, frame.friendGroup.inputFriend:GetText())
        frame.friendGroup.inputFriend:ClearFocus()
      else
        systemAlertWindow:AddMessage("|cFFFF6600" .. locale.inGameShop.needFriendName)
        return
      end
    end
  end
  frame.btnOk:SetHandler("OnClick", frame.btnOk.OnClick)
  function frame.btnCancel:OnClick()
    frame:Show(false)
  end
  frame.btnCancel:SetHandler("OnClick", frame.btnCancel.OnClick)
  function frame:SetLayout(confirmType, selectedgoodsInfo)
    if confirmType == nil then
      confirmType = self.confirmType
    end
    if confirmType == nil then
      self:Show(false)
      return
    end
    self.confirmType = confirmType
    self.selectedgoodsInfo = selectedgoodsInfo
    self.titleGroup:SetInfo()
    self.packageGroup:SetInfo()
    self.detailGroup:SetInfo()
    self.friendGroup:Update()
    SetRefundMessage()
    if confirmType == CONFIRM_TYPE_BUY then
      self.btnOk:SetText(locale.inGameShop.buy)
      self:SetTitle(locale.inGameShop.buy)
    elseif confirmType == CONFIRM_TYPE_GO_CART then
      self.btnOk:SetText(locale.inGameShop.putToCart)
      self:SetTitle(locale.inGameShop.putToCart)
    elseif confirmType == CONFIRM_TYPE_PRESENT then
      self.btnOk:SetText(locale.inGameShop.present)
      self:SetTitle(locale.inGameShop.present)
    end
    ApplyButtonSkin(self.btnOk, BUTTON_BASIC.DEFAULT)
    local buttonTable = {
      self.btnOk,
      self.btnCancel
    }
    AdjustBtnLongestTextWidth(buttonTable)
    self:UpdateHeight()
    self:Show(true)
  end
  function frame:UpdateHeight()
    local inset = 0
    local endWidget
    endWidget = CheckEndWidget(endWidget, self.packageGroup)
    endWidget = CheckEndWidget(endWidget, self.detailGroup)
    endWidget = CheckEndWidget(endWidget, self.friendGroup)
    endWidget = CheckEndWidget(endWidget, self.refundMessage)
    local _, height = F_LAYOUT.GetExtentWidgets(self.titleBar, endWidget)
    height = height + frame.btnCancel:GetHeight() + sideMargin * 1.5
    self:SetHeight(height)
  end
  frame:Show(false)
  return frame
end
