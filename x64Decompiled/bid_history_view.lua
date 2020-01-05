local CreateItemListFrame = function(window)
  local listInfos = {
    width = auctionLocale.width.bidHistoryListCtrl,
    height = 475,
    anchorWidget = nil,
    columns = {
      {
        name = locale.auction.name,
        width = auctionLocale.width.bidHistoryNameCol,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemName,
        limitLen = auctionLocale.nameColLimitLen.bidHistoryTab
      },
      {
        name = locale.auction.leftTime,
        width = auctionLocale.commonWidth.timeCol,
        itemType = LCCIT_STRING,
        itemPropFunc = CreateItemLeftTime
      },
      {
        name = locale.auction.bidState,
        width = auctionLocale.width.bidHistoryStateCol,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemBiddingState
      },
      {
        name = locale.auction.myBiddingPrice,
        width = auctionLocale.width.bidHistoryMyBiddingPrice,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateMyBiddingPrice
      },
      {
        name = locale.auction.currentBidPrice,
        width = auctionLocale.width.bidHistoryBidPrice,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemBiddingPrice
      }
    }
  }
  CreateAuctionItemList(window, listInfos)
end
local CreateBottomFrame = function(window)
  local availableMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".availableMoney", window, nil, "vertical")
  availableMoney:Show(true)
  availableMoney:AddAnchor("BOTTOMLEFT", window, 0, 0)
  window.availableMoney = availableMoney
  local availableAAPoint = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".availableAAPoint", window, GetUIText(MONEY_TEXT, "aa_point"), "vertical")
  if F_MONEY.currency.auctionFee == CURRENCY_AA_POINT or F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
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
  local marketPriceBtn = CreateMarketPriceBtn("marketPriceBtn", window)
  window.marketPriceBtn = marketPriceBtn
  local directButton = window:CreateChildWidget("button", "directButton", 0, true)
  directButton:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  directButton:SetText(locale.auction.buy)
  ApplyButtonSkin(directButton, BUTTON_BASIC.DEFAULT)
  if marketPriceBtn == nil then
    directButton:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  else
    marketPriceBtn:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    directButton:AddAnchor("BOTTOMRIGHT", marketPriceBtn, "BOTTOMLEFT", -5, 0)
  end
  local bidButton = window:CreateChildWidget("button", "bidButton", 0, true)
  bidButton:AddAnchor("TOPRIGHT", directButton, "TOPLEFT", 0, 0)
  bidButton:SetText(locale.auction.bid_money)
  ApplyButtonSkin(bidButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {directButton, bidButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local moneyEditsWindow
  if F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
    moneyEditsWindow = W_MONEY.CreateAAPointEditsWindow(window:GetId() .. ".moneyEditsWindow", window)
  else
    moneyEditsWindow = W_MONEY.CreateMoneyEditsWindow(window:GetId() .. ".moneyEditsWindow", window)
  end
  moneyEditsWindow:AddAnchor("BOTTOMRIGHT", bidButton, "BOTTOMLEFT", 0, -5)
  window.moneyEditsWindow = moneyEditsWindow
end
function SetViewOfAuctionBidHistoryFrame(window)
  CreateItemListFrame(window)
  CreateBottomFrame(window)
end
