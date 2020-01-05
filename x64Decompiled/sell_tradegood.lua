SELL_WINDOW_WIDTH = 680
SELL_WINDOW_HEIGHT = 524
local CreateSellTradegoodWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(SELL_WINDOW_WIDTH, SELL_WINDOW_HEIGHT)
  window:SetTitle(GetCommonText("good_sell_title"))
  local sellContentLabel = window:CreateChildWidget("label", "sellContentLabel", 0, true)
  sellContentLabel:SetExtent(270, FONT_SIZE.LARGE)
  sellContentLabel.style:SetAlign(ALIGN_LEFT)
  sellContentLabel:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  sellContentLabel.style:SetFontSize(FONT_SIZE.LARGE)
  sellContentLabel:SetText(GetCommonText("sell_backpack_goods"))
  ApplyTextColor(sellContentLabel, FONT_COLOR.DEFAULT)
  local sellContentBgWidget = window:CreateChildWidget("emptywidget", "sellContentBg", 0, true)
  sellContentBgWidget:SetExtent(640, 84)
  sellContentBgWidget:AddAnchor("TOPLEFT", sellContentLabel, "BOTTOMLEFT", 0, 3)
  local sellContentBg = CreateContentBackground(sellContentBgWidget, "TYPE2", "brown")
  sellContentBg:AddAnchor("TOPLEFT", sellContentBgWidget, 0, 0)
  sellContentBg:AddAnchor("BOTTOMRIGHT", sellContentBgWidget, 0, 0)
  local sellContentListInfos = {
    width = 630,
    height = 74,
    columnHeight = 30,
    rows = 1,
    page = false,
    columns = {
      {
        name = GetCommonText("name"),
        width = 265,
        colType = LCCIT_TEXTBOX,
        func = LISTFRAME.ITEM,
        before_width = 9,
        after_width = 8
      },
      {
        name = GetCommonText("stock_count"),
        width = 110,
        colType = LCCIT_STRING,
        func = LISTFRAME.NORMAL
      },
      {
        name = locale.store_specialty.prices,
        width = 95,
        colType = LCCIT_STRING,
        func = LISTFRAME.NORMAL
      },
      {
        name = GetCommonText("amount_of_money"),
        width = 160,
        colType = LCCIT_WINDOW,
        func = LISTFRAME.MONEY,
        before_width = 12
      }
    }
  }
  local sellContents = CreateListFrame("sellContents", window, sellContentListInfos)
  window.sellContents:AddAnchor("TOPLEFT", sellContentBg, 5, 0)
  window.sellContents = sellContents
  local sellContentExplain = window:CreateChildWidget("textbox", "sellContentExplain", 0, true)
  sellContentExplain:SetExtent(630, 68)
  sellContentExplain:AddAnchor("TOPLEFT", sellContentBg, "BOTTOMLEFT", 5, 4)
  sellContentExplain.style:SetFontSize(FONT_SIZE.MIDDLE)
  sellContentExplain.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(sellContentExplain, FONT_COLOR.DEFAULT)
  local midLine = CreateLine(window, "TYPE1")
  midLine:AddAnchor("TOPLEFT", sellContentExplain, "BOTTOMLEFT", 0, 40)
  midLine:AddAnchor("TOPRIGHT", sellContentExplain, "BOTTOMRIGHT", 0, 40)
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.store.sellAll)
  okButton:AddAnchor("TOPRIGHT", sellContentExplain, "BOTTOMRIGHT", 0, 0)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  function okButton:OnClick()
    window:Show(false)
    X2Store:SellBackPackGoods()
  end
  okButton:SetHandler("OnClick", okButton.OnClick)
  local stockLabel = window:CreateChildWidget("textbox", "stockLabel", 0, true)
  stockLabel:SetExtent(270, FONT_SIZE.LARGE)
  stockLabel.style:SetAlign(ALIGN_LEFT)
  stockLabel:AddAnchor("TOPLEFT", midLine, "BOTTOMLEFT", -5, 0)
  stockLabel.style:SetFontSize(FONT_SIZE.LARGE)
  stockLabel:SetText(GetCommonText("good_stock_title"))
  ApplyTextColor(stockLabel, FONT_COLOR.DEFAULT)
  local stockBgWidget = window:CreateChildWidget("emptywidget", "stockBg", 0, true)
  stockBgWidget:SetExtent(640, 178)
  stockBgWidget:AddAnchor("TOPLEFT", stockLabel, "BOTTOMLEFT", 0, 5)
  local stockBg = CreateContentBackground(stockBgWidget, "TYPE2", "brown")
  stockBg:AddAnchor("TOPLEFT", stockBgWidget, 0, 0)
  stockBg:AddAnchor("BOTTOMRIGHT", stockBgWidget, 0, 0)
  local stockEventLabel = window:CreateChildWidget("textbox", "stockEventLabel", 0, true)
  stockEventLabel:SetExtent(270, FONT_SIZE.MIDDLE)
  stockEventLabel:Show(false)
  stockEventLabel.style:SetAlign(ALIGN_RIGHT)
  stockEventLabel:AddAnchor("BOTTOM", stockBgWidget, "TOP", 0, -5)
  stockEventLabel:AddAnchor("RIGHT", window, -MARGIN.WINDOW_SIDE - 5, 0)
  stockEventLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  stockEventLabel:SetText(GetCommonText("specialty_sell_price_change_explain"))
  ApplyTextColor(stockEventLabel, FONT_COLOR.BLUE)
  local stockListInfos = {
    width = 570,
    height = 162,
    columnHeight = 30,
    rows = 3,
    columns = {
      {
        name = GetCommonText("name"),
        width = 254,
        colType = LCCIT_TEXTBOX,
        func = LISTFRAME.ITEM,
        before_width = 4,
        after_width = 5,
        useSort = true
      },
      {
        name = X2Locale:LocalizeUiText(AUCTION_TEXT, "count"),
        width = 85,
        colType = LCCIT_STRING,
        func = LISTFRAME.NORMAL_FORMATTED_NUMBER,
        useSort = true
      },
      {
        name = locale.store_specialty.prices,
        width = 85,
        colType = LCCIT_STRING,
        func = LISTFRAME.NORMAL_FORMATTED_NUMBER,
        useSort = true
      },
      {
        name = GetCommonText("amount_of_money"),
        width = 146,
        colType = LCCIT_WINDOW,
        func = LISTFRAME.MONEY,
        before_width = 3,
        useSort = true
      }
    }
  }
  local stocks = CreateListFrame("stocks", window, stockListInfos)
  window.stocks:AddAnchor("TOPLEFT", stockBg, 35, 5)
  window.stocks = stocks
  function window:UpdateList(list)
    stocks:DeleteAllDatas()
    sellContents:DeleteAllDatas()
    stocks:UpdatePage(#list - 1, stockListInfos.rows)
    local showEventLabel = false
    if #list > 0 then
      local backpackType = BPT_GOODS
      if list[1] ~= nil and list[1].item ~= nil then
        local refund = {}
        sellContents:InsertData(i, 1, list[1].item)
        sellContents:InsertData(i, 2, X2Locale:LocalizeUiText(COMMON_TEXT, "amount", tostring(list[1].count)))
        sellContents:InsertData(i, 3, string.format("%d%%", list[1].ratio))
        refund.refund = list[1].refund
        refund.noEventRefund = list[1].noEventRefund
        if list[1].tooltip ~= nil then
          showEventLabel = true
          refund.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "specialty_sell_price_change_tooltip_title", table.concat(list[1].tooltip, "\n"))
        elseif 0 < tonumber(list[1].noEventRefund) then
          list[1].item.event = true
        end
        sellContents:InsertData(i, 4, refund)
        backpackType = list[1].item.backpackType
        okButton:Enable(true)
      else
        if #list > 1 then
          backpackType = list[2].item.backpackType
        end
        okButton:Enable(false)
      end
      local labor = X2Store:GetBackPackSellLabor(backpackType)
      local guide = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_content_labor", tostring(labor))
      if backpackType == BPT_TRADEGOODS then
        window:SetTitle(GetCommonText("tradegood_sell_title"))
        stockLabel:SetText(GetCommonText("tradegood_stock_title"))
        local interest = X2Store:GetSpecialtyInterest(backpackType)
        guide = guide .. "\n" .. X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_content_tradegood", tostring(interest))
      else
        window:SetTitle(GetCommonText("good_sell_title"))
        stockLabel:SetText(GetCommonText("good_stock_title"))
        local interest = X2Store:GetSpecialtyInterest(backpackType)
        local sellerRatio = X2Store:GetSellerShareRatio()
        guide = guide .. "\n" .. X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_content_good", FONT_COLOR_HEX.BLUE, tostring(100 - sellerRatio), tostring(sellerRatio), tostring(interest))
      end
      local ratio = 0
      local extraResult = ""
      if X2Player:GetPayLocation() == "pcbang" then
        local pcBangRatio = X2Store:GetPCBangRatio()
        if ratio < pcBangRatio then
          ratio = pcBangRatio
          extraResult = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_at_pcbang", FONT_COLOR_HEX.RED, FONT_COLOR_HEX.RED, tostring(pcBangRatio))
        end
      end
      if X2Player:HasAccountBuffUsingSpecialityConfig() then
        local info = X2Store:GetAccountBuffInfoUsingSpecialityConfig()
        if ratio < info.ratio then
          ratio = info.ratio
          extraResult = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_with_account_buff", FONT_COLOR_HEX.RED, info.buffName, FONT_COLOR_HEX.RED, tostring(info.ratio))
        end
      end
      if ratio > 0 then
        guide = guide .. "\n" .. extraResult
      end
      sellContentExplain:SetText(guide)
    end
    for i = 2, #list do
      local refund = {}
      stocks:InsertData(i, 1, list[i].item, nil, false)
      stocks:InsertData(i, 2, LISTFRAME.ConvertNumberUiText(COMMON_TEXT, "amount", tostring(list[i].count)), nil, false)
      stocks:InsertData(i, 3, LISTFRAME.ConvertNumber("%d%%", list[i].ratio), nil, false)
      refund.refund = list[i].refund
      refund.noEventRefund = list[i].noEventRefund
      if list[i].tooltip ~= nil then
        showEventLabel = true
        refund.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "specialty_sell_price_change_tooltip_title", table.concat(list[i].tooltip, "\n"))
      elseif 0 < tonumber(list[i].noEventRefund) then
        list[i].item.event = true
      end
      local updateViewNow = i == #list and true or false
      stocks:InsertData(i, 4, refund, nil, updateViewNow)
    end
    stockEventLabel:Show(showEventLabel)
    for i = 1, #stocks.listCtrl.items do
      local item = stocks.listCtrl.items[i]
      if item.line ~= nil then
        item.line:SetVisible(true)
      end
    end
  end
  function window:Init()
    self:UpdateList({})
  end
  return window
end
local sellTradegoodWnd = CreateSellTradegoodWindow("sellTradegoodWnd", "UIParent")
sellTradegoodWnd:AddAnchor("CENTER", "UIParent", 0, 0)
function ToggleSellTradegoodInfo(show)
  if show == nil then
    show = not sellTradegoodWnd:IsVisible()
  end
  sellTradegoodWnd:Show(show)
  if show == true then
    sellTradegoodWnd:Init()
  end
end
ADDON:RegisterContentTriggerFunc(UIC_SPECIALTY_SELL, ToggleSellTradegoodInfo)
local events = {
  SELL_SPECIALTY_CONTENT_INFO = function(list)
    if sellTradegoodWnd:IsVisible() == false then
      return
    end
    sellTradegoodWnd:UpdateList(list)
  end,
  UPDATE_SPECIALTY_RATIO = function(refund)
    if refund == nil then
      ToggleSellTradegoodInfo(false)
    end
  end,
  INTERACTION_END = function()
    ToggleSellTradegoodInfo(false)
  end
}
sellTradegoodWnd:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(sellTradegoodWnd, events)
