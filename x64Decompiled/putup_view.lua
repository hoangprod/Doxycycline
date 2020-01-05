local PostTypeWndExtent = {width = 190, height = 110}
local PutupItemFrameExtent = {width = 200, height = 524}
local CreatePostTypeBidFrame = function(parent, postTypeFrame, target)
  local startBundlePriceLabel = postTypeFrame:CreateChildWidget("label", "startBundlePriceLabel", 0, true)
  startBundlePriceLabel:SetExtent(190, FONT_SIZE.MIDDLE)
  startBundlePriceLabel:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", 0, 11)
  startBundlePriceLabel:SetText(locale.auction.bundlePrice)
  startBundlePriceLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(startBundlePriceLabel, FONT_COLOR.BROWN)
  local startPriceEditsWindow
  if F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
    startPriceEditsWindow = W_MONEY.CreateAAPointEditsWindow(parent:GetId() .. ".startPriceEditsWindow", postTypeFrame)
  else
    startPriceEditsWindow = W_MONEY.CreateMoneyEditsWindow(parent:GetId() .. ".startPriceEditsWindow", postTypeFrame)
  end
  startPriceEditsWindow:AddAnchor("TOPLEFT", startBundlePriceLabel, "BOTTOMLEFT", 0, 4)
  startPriceEditsWindow:SetWidth(190)
  startPriceEditsWindow.goldEdit:SetWidth(90)
  startPriceEditsWindow.silverEdit:SetWidth(45)
  startPriceEditsWindow.copperEdit:SetWidth(45)
  parent.startPriceEditsWindow = startPriceEditsWindow
end
local CreatePostTypePartitionFrame = function(parent, postTypeFrame, target)
  local minStackLabel = postTypeFrame:CreateChildWidget("label", "minStackLabel", 0, true)
  minStackLabel:SetExtent(190, FONT_SIZE.MIDDLE)
  minStackLabel:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", 0, 11)
  minStackLabel:SetText(locale.auction.sellMinStackCount)
  minStackLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(minStackLabel, FONT_COLOR.BROWN)
  local spinner = W_ETC.CreateSpinner(postTypeFrame:GetId() .. ".spinner", postTypeFrame)
  spinner:SetWidth(190)
  spinner:AddAnchor("TOPLEFT", minStackLabel, "BOTTOMLEFT", -2, 3)
  spinner:SetMinMaxValues(1, 1000)
  spinner:SetValue(1)
  spinner:UseRotateCount()
  parent.spinner = spinner
  parent.minStackCountButtons = {}
  for i = 1, #PartitionStack do
    local minStackButton = postTypeFrame:CreateChildWidget("button", "minStackButton" .. i, 0, true)
    minStackButton:Show(true)
    ApplyButtonSkin(minStackButton, BUTTON_BASIC.AUCTION_POST_MIN_STACK)
    minStackButton:SetText(tostring(PartitionStack[i]))
    minStackButton:AddAnchor("TOPLEFT", spinner, "BOTTOMLEFT", (i - 1) * 45 + (i - 1) * 3, 3)
    parent.minStackCountButtons[i] = minStackButton
  end
end
local function CreatePostTypeFrame(parent, postTypeWindow)
  local postTypeLabel = postTypeWindow:CreateChildWidget("label", "postTypeLabel", 0, true)
  postTypeLabel:SetExtent(190, 15)
  postTypeLabel:AddAnchor("TOPLEFT", postTypeWindow, 0, 0)
  postTypeLabel:SetText(locale.auction.startPrice)
  postTypeLabel.style:SetAlign(ALIGN_LEFT)
  postTypeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(postTypeLabel, FONT_COLOR.TITLE)
  parent.postTypeLabel = postTypeLabel
  local postTypeLabelBg = CreateContentBackground(postTypeWindow, "TYPE11", "auction_title")
  postTypeLabelBg:AddAnchor("TOPLEFT", postTypeLabel, -5, -4)
  postTypeLabelBg:AddAnchor("BOTTOMRIGHT", postTypeLabel, 0, 4)
  local postTypeButton = postTypeWindow:CreateChildWidget("button", "postTypeButton", 0, true)
  postTypeButton:Show(X2Player:GetFeatureSet().auctionPartialBuy)
  ApplyButtonSkin(postTypeButton, BUTTON_BASIC.AUCTION_POST_BID)
  postTypeButton:AddAnchor("RIGHT", postTypeLabelBg, "RIGHT", 0, 0)
  parent.postTypeButton = postTypeButton
  postTypeFrame = {}
  postTypeFrame[1] = postTypeWindow:CreateChildWidget("emptywidget", "bidTypeFrame", 0, true)
  postTypeFrame[1]:Show(true)
  postTypeFrame[1]:SetExtent(PostTypeWndExtent.width, PostTypeWndExtent.height - 20)
  postTypeFrame[1]:AddAnchor("TOP", postTypeWindow, "TOP", 0, 20)
  CreatePostTypeBidFrame(parent, postTypeFrame[1], postTypeLabel)
  postTypeFrame[2] = postTypeWindow:CreateChildWidget("emptywidget", "partitionTypeFrame", 0, true)
  postTypeFrame[2]:Show(false)
  postTypeFrame[2]:SetExtent(PostTypeWndExtent.width, PostTypeWndExtent.height - 20)
  postTypeFrame[2]:AddAnchor("TOP", postTypeWindow, "TOP", 0, 20)
  CreatePostTypePartitionFrame(parent, postTypeFrame[2], postTypeLabel)
  parent.postTypeFrame = postTypeFrame
end
local function SetViewOfPutupFrame(window)
  local frame = window:CreateChildWidget("emptywidget", "putupItemFrame", 0, true)
  frame:Show(true)
  local bg = CreateContentBackground(frame, "TYPE3", "brown")
  bg:AddAnchor("TOPLEFT", frame, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  bg:AddAnchor("BOTTOMRIGHT", frame, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_SIDE)
  local itemButton = CreateItemIconButton(frame:GetId() .. ".itemButton", frame)
  itemButton:Show(true)
  itemButton:AddAnchor("TOP", frame, 0, MARGIN.WINDOW_SIDE / 2)
  itemButton:SetSounds("")
  itemButton:RegisterForClicks("RightButton")
  frame.itemButton = itemButton
  local itemNameLabel = frame:CreateChildWidget("label", "itemNameLabel", 0, true)
  itemNameLabel:Show(true)
  itemNameLabel.style:SetEllipsis(true)
  itemNameLabel:SetExtent(190, FONT_SIZE.LARGE)
  itemNameLabel:AddAnchor("TOP", itemButton, "BOTTOM", 0, 5)
  itemNameLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(itemNameLabel, FONT_COLOR.TITLE)
  local inputWindow = frame:CreateChildWidget("emptywidget", "inputWindow", 0, true)
  inputWindow:Show(true)
  inputWindow:SetExtent(190, 170)
  inputWindow:AddAnchor("TOP", itemNameLabel, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  local directPriceLabel = inputWindow:CreateChildWidget("label", "directPriceLabel", 0, true)
  directPriceLabel:SetExtent(190, 15)
  directPriceLabel:AddAnchor("TOP", inputWindow, 0, 0)
  directPriceLabel:SetText(locale.auction.directPrice)
  directPriceLabel.style:SetAlign(ALIGN_LEFT)
  directPriceLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(directPriceLabel, FONT_COLOR.TITLE)
  local directPriceLabelBg = CreateContentBackground(frame, "TYPE11", "auction_title")
  directPriceLabelBg:AddAnchor("TOPLEFT", directPriceLabel, -5, -4)
  directPriceLabelBg:AddAnchor("BOTTOMRIGHT", directPriceLabel, 0, 4)
  local lowestPriceLabel = inputWindow:CreateChildWidget("label", "lowestPriceLabel", 0, true)
  lowestPriceLabel:SetExtent(190, FONT_SIZE.MIDDLE)
  lowestPriceLabel:AddAnchor("TOPLEFT", directPriceLabel, "BOTTOMLEFT", 0, 11)
  lowestPriceLabel:SetText(locale.auction.lowestEachPrice)
  lowestPriceLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(lowestPriceLabel, FONT_COLOR.BROWN)
  local lowestPrice = W_MONEY.CreateDefaultMoneyWindow(inputWindow:GetId() .. ".lowestPrice", inputWindow, 180, 30)
  lowestPrice.currency = F_MONEY.currency.auctionBid
  ApplyTextColor(lowestPrice, FONT_COLOR.TITLE)
  lowestPrice:Show(true)
  lowestPrice:AddAnchor("TOPLEFT", lowestPriceLabel, "BOTTOMLEFT", 0, 0)
  frame.lowestPrice = lowestPrice
  local lowestPriceBg = lowestPrice:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  lowestPriceBg:SetTextureColor("default")
  lowestPriceBg:AddAnchor("TOPLEFT", lowestPrice, -5, 0)
  lowestPriceBg:AddAnchor("BOTTOMRIGHT", lowestPrice, 20, 0)
  local directEachPriceLabel = inputWindow:CreateChildWidget("label", "directEachPriceLabel", 0, true)
  directEachPriceLabel:SetExtent(190, 15)
  directEachPriceLabel:AddAnchor("TOPLEFT", lowestPrice, "BOTTOMLEFT", 0, 5)
  directEachPriceLabel:SetText(locale.auction.eachPrice)
  directEachPriceLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(directEachPriceLabel, FONT_COLOR.BROWN)
  local directPriceEditsWindow
  if F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
    directPriceEditsWindow = W_MONEY.CreateAAPointEditsWindow(frame:GetId() .. ".directPriceEditsWindow", frame)
  else
    directPriceEditsWindow = W_MONEY.CreateMoneyEditsWindow(frame:GetId() .. ".directPriceEditsWindow", frame)
  end
  directPriceEditsWindow:AddAnchor("TOPLEFT", directEachPriceLabel, "BOTTOMLEFT", 0, 3)
  directPriceEditsWindow:SetWidth(190)
  directPriceEditsWindow.goldEdit:SetWidth(90)
  directPriceEditsWindow.silverEdit:SetWidth(45)
  directPriceEditsWindow.copperEdit:SetWidth(45)
  frame.directPriceEditsWindow = directPriceEditsWindow
  local directBundlePriceLabel = auctionLocale:CreateDirectBundlePriceLabel("directBundlePriceLabel", inputWindow, directPriceEditsWindow)
  local directBundleAmountLabel = inputWindow:CreateChildWidget("textbox", "directBundleAmountLabel", 0, true)
  directBundleAmountLabel:SetExtent(70, FONT_SIZE.MIDDLE)
  ApplyTextColor(directBundleAmountLabel, FONT_COLOR.BROWN)
  directBundleAmountLabel.style:SetAlign(ALIGN_RIGHT)
  auctionLocale:SetLayoutDirectBundleAmountLabel(directBundleAmountLabel, directBundlePriceLabel)
  frame.directBundleAmountLabel = directBundleAmountLabel
  function directBundleAmountLabel:Update(amount)
    self:SetWidth(500)
    self:SetText(string.format("%s %s%s", locale.auction.amount, FONT_COLOR_HEX.BLUE, tostring(amount)))
    self:SetWidth(self:GetLongestLineWidth() + 5)
  end
  local directBundlePrice = W_MONEY.CreateDefaultMoneyWindow(inputWindow:GetId() .. ".directBundlePrice", inputWindow, 180, 30)
  directBundlePrice:Show(true)
  directBundlePrice:SetWidth(190)
  directBundlePrice.currency = F_MONEY.currency.auctionBid
  ApplyTextColor(directBundlePrice, FONT_COLOR.TITLE)
  auctionLocale:AnchorDirectBundlePrice(directBundlePrice, directBundleAmountLabel)
  frame.directBundlePrice = directBundlePrice
  local directBundlePriceBg = directBundlePrice:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  directBundlePriceBg:SetTextureColor("bundle_price")
  directBundlePriceBg:AddAnchor("TOPLEFT", directBundlePrice, -5, 0)
  directBundlePriceBg:AddAnchor("BOTTOMRIGHT", directBundlePrice, 20, 0)
  local postTypeWindow = frame:CreateChildWidget("emptywidget", "postTypeWindow", 0, true)
  postTypeWindow:SetExtent(PostTypeWndExtent.width, PostTypeWndExtent.height)
  CreatePostTypeFrame(frame, postTypeWindow)
  postTypeWindow:AddAnchor("TOP", inputWindow, "BOTTOM", 0, auctionLocale.postTypeWindowAnchorY)
  local biddingTimeLabel = inputWindow:CreateChildWidget("label", "biddingTimeLabel", 0, true)
  biddingTimeLabel:SetExtent(190, 50)
  biddingTimeLabel:AddAnchor("TOP", postTypeWindow, "BOTTOM", 0, 8)
  biddingTimeLabel:SetText(locale.auction.biddingTime)
  biddingTimeLabel.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(biddingTimeLabel, FONT_COLOR.TITLE)
  local times = {
    6,
    12,
    24,
    48
  }
  local timeTexts = {}
  for i = 1, 4 do
    local item = {
      text = string.format("%d %s", times[i], locale.tooltip.hour),
      value = i
    }
    table.insert(timeTexts, item)
  end
  frame.timeTexts = timeTexts
  local timeCheckBoxes = CreateRadioGroup(frame:GetId() .. ".timeCheckBoxes", biddingTimeLabel, "grid")
  timeCheckBoxes:AddAnchor("TOPLEFT", biddingTimeLabel, 5, 20)
  timeCheckBoxes:AddAnchor("RIGHT", biddingTimeLabel, -5, 0)
  timeCheckBoxes:SetData(timeTexts)
  frame.timeCheckBoxes = timeCheckBoxes
  local deposit = frame:CreateChildWidget("textbox", "depositLabel", 0, true)
  deposit:Show(true)
  deposit:SetExtent(170, FONT_SIZE.MIDDLE)
  deposit.style:SetAlign(ALIGN_LEFT)
  deposit:SetText(locale.auction.deposit)
  ApplyTextColor(deposit, FONT_COLOR.TITLE)
  frame.deposit = deposit
  local depositGuide = W_ICON.CreateGuideIconWidget(deposit)
  depositGuide:AddAnchor("TOPLEFT", biddingTimeLabel, "BOTTOMLEFT", 0, 7)
  frame.depositGuide = depositGuide
  deposit:AddAnchor("LEFT", depositGuide, "RIGHT", 3, 0)
  local depositMoney = frame:CreateChildWidget("textbox", "depositMoneyLabel", 0, true)
  depositMoney:Show(true)
  depositMoney:AddAnchor("TOPLEFT", deposit, "BOTTOMLEFT", 0, 2)
  depositMoney:SetExtent(170, FONT_SIZE.MIDDLE)
  depositMoney.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(depositMoney, FONT_COLOR.TITLE)
  frame.depositMoney = depositMoney
  local chargeText = frame:CreateChildWidget("label", "chargeText", 0, true)
  chargeText:Show(true)
  chargeText:SetExtent(100, FONT_SIZE.MIDDLE)
  chargeText.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(chargeText, FONT_COLOR.TITLE)
  chargeText:SetAutoResize(true)
  chargeText:SetText(GetUIText(COMMON_TEXT, "auction_charge_percent"))
  frame.chargeText = chargeText
  local chargeGuide = W_ICON.CreateGuideIconWidget(chargeText)
  chargeGuide:AddAnchor("TOPLEFT", depositGuide, "BOTTOMLEFT", 0, 20)
  frame.chargeGuide = chargeGuide
  chargeText:AddAnchor("LEFT", chargeGuide, "RIGHT", 3, 0)
  local chargePrice = frame:CreateChildWidget("textbox", "chargePrice", 0, true)
  chargePrice:Show(true)
  chargePrice:AddAnchor("LEFT", chargeText, "RIGHT", 3, 0)
  chargePrice:SetExtent(40, FONT_SIZE.MIDDLE)
  chargePrice.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(chargePrice, FONT_COLOR.TITLE)
  frame.chargePrice = chargePrice
  local chargeDisPrice = frame:CreateChildWidget("textbox", "chargeDisPrice", 0, true)
  chargeDisPrice:Show(true)
  chargeDisPrice:AddAnchor("LEFT", chargePrice, "RIGHT", 3, 0)
  chargeDisPrice:SetExtent(40, FONT_SIZE.MIDDLE)
  chargeDisPrice.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(chargeDisPrice, FONT_COLOR.GREEN)
  frame.chargeDisPrice = chargeDisPrice
  local putupButton = frame:CreateChildWidget("button", "putupButton", 0, true)
  putupButton:Show(true)
  putupButton:Enable(false)
  putupButton:SetText(locale.auction.putupItem)
  ApplyButtonSkin(putupButton, BUTTON_BASIC.DEFAULT)
  putupButton:SetSounds("auction_put_up")
  local marketPriceBtn = CreateMarketPriceBtn("marketPriceBtn", frame)
  frame.marketPriceBtn = marketPriceBtn
  local putupButtonAnchorX = PutupItemFrameExtent.width / 2 - putupButton:GetWidth() / 2 - 5
  if marketPriceBtn == nil then
    putupButton:AddAnchor("TOPLEFT", chargeGuide, "BOTTOMLEFT", putupButtonAnchorX, auctionLocale.putupButtonAnchorY)
  else
    putupButton:AddAnchor("TOPLEFT", chargeGuide, "BOTTOMLEFT", putupButtonAnchorX + marketPriceBtn:GetWidth() / 2, auctionLocale.putupButtonAnchorY)
    marketPriceBtn:AddAnchor("RIGHT", putupButton, "LEFT", -5, 0)
  end
  return frame
end
local CreateItemListFrame = function(window)
  local listInfos = {
    width = auctionLocale.width.putupListCtrl,
    height = 475,
    anchorWidget = window.putupItemFrame,
    columns = {
      {
        name = locale.auction.name,
        width = auctionLocale.width.putupNameCol,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemName,
        sortKinds = {
          columnSortKind[5]
        },
        limitLen = auctionLocale.nameColLimitLen.putupTab
      },
      {
        name = locale.auction.level,
        width = auctionLocale.width.putupItemlevelCol,
        itemType = LCCIT_STRING,
        itemPropFunc = CreateItemLevel,
        sortKinds = {
          columnSortKind[6]
        }
      },
      {
        name = locale.auction.leftTime,
        width = auctionLocale.width.putupTimeCol,
        itemType = LCCIT_STRING,
        itemPropFunc = CreateItemLeftTime,
        sortKinds = {
          columnSortKind[7]
        }
      },
      {
        name = locale.auction.itemCondition,
        width = auctionLocale.width.putupStateCol,
        itemType = LCCIT_STRING,
        itemPropFunc = CreateMyItemBiddingState
      },
      {
        name = locale.auction.bidPrice,
        width = auctionLocale.width.putupBidPrice,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemBiddingPrice,
        sortKinds = {
          columnSortKind[8]
        }
      }
    }
  }
  CreateAuctionItemList(window, listInfos)
  window.listCtrl.column[3]:Enable(false)
end
local CreateBottomFrame = function(window)
  local availableMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".availableMoney", window, nil, "vertical")
  availableMoney:Show(true)
  availableMoney:AddAnchor("BOTTOMLEFT", window, 0, 0)
  window.availableMoney = availableMoney
  local availableAAPoint = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".availableAAPoint", window, GetUIText(MONEY_TEXT, "aa_point"), "vertical")
  if F_MONEY.currency.auctionFee ~= CURRENCY_GOLD or F_MONEY.currency.auctionBid ~= CURRENCY_GOLD then
    availableAAPoint:Show(true)
  else
    availableAAPoint:Show(false)
  end
  availableAAPoint:AddAnchor("LEFT", availableMoney, "RIGHT", 20, 0)
  window.availableAAPoint = availableAAPoint
  if baselibLocale.showMoneyTooltip then
    local OnEnter = function(self)
      SetTooltip(locale.moneyTooltip.money, self)
    end
    availableMoney:SetHandler("OnEnter", OnEnter)
    local OnEnter = function(self)
      SetTooltip(locale.moneyTooltip.aapoint, self)
    end
    availableAAPoint:SetHandler("OnEnter", OnEnter)
  end
  local rightMarketPriceBtn = CreateMarketPriceBtn("rightMarketPriceBtn", window)
  window.rightMarketPriceBtn = rightMarketPriceBtn
  local cancelBidButton = window:CreateChildWidget("button", "cancelBidButton", 0, true)
  cancelBidButton:Show(true)
  cancelBidButton:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  cancelBidButton:SetText(locale.auction.cancelBid)
  ApplyButtonSkin(cancelBidButton, BUTTON_BASIC.DEFAULT)
  if rightMarketPriceBtn == nil then
    cancelBidButton:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  else
    rightMarketPriceBtn:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    cancelBidButton:AddAnchor("BOTTOMRIGHT", rightMarketPriceBtn, "BOTTOMLEFT", -5, 0)
  end
end
function SetViewOfAuctionPutupFrame(window)
  local putupFrame = SetViewOfPutupFrame(window)
  putupFrame:SetExtent(PutupItemFrameExtent.width, PutupItemFrameExtent.height)
  putupFrame:AddAnchor("TOPLEFT", window, 0, MARGIN.WINDOW_SIDE)
  CreateItemListFrame(window)
  CreateBottomFrame(window)
end
