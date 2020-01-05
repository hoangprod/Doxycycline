local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
SERVICE_BUY_LISTCTRL_OFFSET_X = premiumServiceLocale.premiumWndWidth - sideMargin * 2
maxColumn = 5
local maxRowCount = 4
local maxListHeight = 220
PREMIUM_GOODS_LIST_WIDTH = premiumServiceLocale.premiumServeiceWidth
PREMIUM_BONUS_LIST_WIDTH = 70
function CreateServiceBuyMoneyView(parent, premiumWnd)
  local moneyView = parent:CreateChildWidget("emptywidget", "moneyView", 0, true)
  local aaPointBuyBtn
  if X2Player:GetUIScreenState() ~= SCREEN_CHARACTER_SELECT and premiumServiceLocale.useAAPoint then
    aaPointBuyBtn = moneyView:CreateChildWidget("button", "aaPointBuyBtn", 0, true)
    aaPointBuyBtn:AddAnchor("BOTTOMRIGHT", moneyView, -5, 0)
    aaPointBuyBtn:SetText(locale.premium.point_buy)
    ApplyButtonSkin(aaPointBuyBtn, BUTTON_BASIC.DEFAULT)
    local aaPointBuyPoint = moneyView:CreateChildWidget("textbox", "aaPointBuyPoint", 0, true)
    aaPointBuyPoint:AddAnchor("RIGHT", aaPointBuyBtn, "LEFT", -10, 0)
    aaPointBuyPoint:SetExtent(200, FONT_SIZE.LARGE)
    aaPointBuyPoint.style:SetFontSize(FONT_SIZE.LARGE)
    aaPointBuyPoint.style:SetAlign(ALIGN_RIGHT)
    ApplyTextColor(aaPointBuyPoint, FONT_COLOR.DEFAULT)
    aaPointBuyPoint:SetText(F_MONEY:SettingPriceText(0, PRICE_TYPE_AA_POINT, FONT_COLOR_HEX.DEFAULT))
    function aaPointBuyPoint:SetMyAAPointMoney(aapoint)
      self:SetText(F_MONEY:SettingPriceText(aapoint, PRICE_TYPE_AA_POINT, FONT_COLOR_HEX.DEFAULT))
    end
    local aaPointBuyPointBg = aaPointBuyPoint:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
    aaPointBuyPointBg:AddAnchor("RIGHT", aaPointBuyPoint, 0, 0)
    aaPointBuyBtn:Enable(false)
    function aaPointBuyBtn:OnClick(arg)
      if premiumWnd.aapointBuyFrame ~= nil then
        premiumWnd.aapointBuyFrame.ShowAAPointBuyFrame(premiumWnd)
      end
    end
    aaPointBuyBtn:SetHandler("OnClick", aaPointBuyBtn.OnClick)
  end
  local cashBuyBtn
  if premiumServiceLocale.useCashCharge then
    cashBuyBtn = moneyView:CreateChildWidget("button", "cashBuyBtn", 0, true)
    moneyView.cashBuyBtn = cashBuyBtn
    if aaPointBuyBtn ~= nil then
      cashBuyBtn:AddAnchor("BOTTOMRIGHT", aaPointBuyBtn, 0, -37)
    else
      cashBuyBtn:AddAnchor("BOTTOMRIGHT", moneyView, 0, 0)
    end
    cashBuyBtn:SetText(locale.premium.cash_buy)
    ApplyButtonSkin(cashBuyBtn, BUTTON_BASIC.DEFAULT)
    local cashBuyPoint = moneyView:CreateChildWidget("textbox", "cashBuyPoint", 0, true)
    cashBuyPoint:AddAnchor("RIGHT", cashBuyBtn, "LEFT", -10, 0)
    cashBuyPoint:SetExtent(200, FONT_SIZE.LARGE)
    cashBuyPoint.style:SetFontSize(FONT_SIZE.LARGE)
    cashBuyPoint.style:SetAlign(ALIGN_RIGHT)
    ApplyTextColor(cashBuyPoint, FONT_COLOR.DEFAULT)
    cashBuyPoint:SetText(F_MONEY:SettingPriceText(0, PRICE_TYPE_AA_CASH, FONT_COLOR_HEX.DEFAULT))
    local cashBuyPointBg = cashBuyPoint:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
    cashBuyPointBg:AddAnchor("RIGHT", cashBuyPoint, 0, 0)
    function cashBuyPoint:SetCashMoney(cash)
      self:SetText(F_MONEY:SettingPriceText(cash, PRICE_TYPE_AA_CASH, FONT_COLOR_HEX.DEFAULT))
    end
    function cashBuyBtn:OnClick(arg)
      RequestCashCharge(premiumWnd)
    end
    cashBuyBtn:SetHandler("OnClick", cashBuyBtn.OnClick)
  end
  if aaPointBuyBtn ~= nil and cashBuyBtn ~= nil then
    local buttonTable = {aaPointBuyBtn, cashBuyBtn}
    AdjustBtnLongestTextWidth(buttonTable)
  end
  return moneyView
end
function CreateServiceBuyList(wnd, anchorTarget, premiumWnd)
  local widget = W_CTRL.CreateScrollListCtrl("PremiumList", wnd)
  widget:SetWidth(wnd:GetWidth())
  widget.listCtrl:AddAnchor("RIGHT", widget)
  local tab = wnd:GetParent()
  tab:AnchorContent(widget)
  listCtrl = widget.listCtrl
  local PremiumKindDataSetFunc = function(subItem, data, setValue)
    subItem:SetText(data)
  end
  local PremiumKindLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.DEEP_ORANGE)
  end
  widget:InsertColumn(locale.premium.premium_kind, 80, LCCIT_STRING, PremiumKindDataSetFunc, nil, nil, PremiumKindLayoutFunc)
  local PremiumGoodsDataSetFunc = function(subItem, data, setValue)
    subItem:SetText(data)
  end
  widget:InsertColumn(locale.premium.goods, PREMIUM_GOODS_LIST_WIDTH, LCCIT_STRING, PremiumGoodsDataSetFunc, nil, nil, nil)
  local PremiumBonusDataSetFunc = function(subItem, data, setValue)
    if data == nil or data == "" or data.itemType == nil then
      subItem.slot:Show(false)
      subItem.slot.itemType = nil
    else
      subItem.slot:SetItem(data.itemType, data.itemGrade, data.itemCount)
      subItem.slot:Show(true)
      subItem.slot.itemType = data.itemType
    end
  end
  local PremiumBonusLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local slot = CreateSlotItemButton("slot", subItem)
    slot:AddAnchor("CENTER", subItem, 0, 0)
    slot:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
    slot.itemType = nil
    subItem.slot = slot
    function slot:OnEnter()
      local itemType = slot.itemType
      if itemType ~= nil then
        local tip = slot:GetTooltip()
        ShowTooltip(tip, slot, 1, false, ONLY_BASE)
      end
    end
    slot:SetHandler("OnEnter", slot.OnEnter)
    function slot:OnLeave()
      local itemType = slot.itemType
      if itemType ~= nil then
        HideTooltip()
      end
    end
    slot:SetHandler("OnLeave", slot.OnLeave)
  end
  widget:InsertColumn(locale.premium.bonus, PREMIUM_BONUS_LIST_WIDTH, LCCIT_WINDOW, PremiumBonusDataSetFunc, nil, nil, PremiumBonusLayoutFunc)
  local PremiumPriceDataSetFunc = function(subItem, data, setValue)
    local priceStr = ""
    local dispriceStr = ""
    if data.priceType == PRICE_TYPE_AA_CASH then
      priceStr = "|j" .. data.price .. ";"
      dispriceStr = "|j" .. data.disprice .. ";"
    elseif data.priceType == PRICE_TYPE_AA_POINT then
      priceStr = "|p" .. data.price .. ";"
      dispriceStr = "|p" .. data.disprice .. ";"
    elseif data.priceType == PRICE_TYPE_REAL_MONEY then
      priceStr = locale.premium.real_money(string.format("|,%s;", data.price))
      dispriceStr = locale.premium.real_money(string.format("|,%s;", data.disprice))
    end
    if data.disprice ~= "" then
      subItem.price:SetStrikeThrough(true)
      subItem.price:SetLineColor(FONT_COLOR.BLUE[1], FONT_COLOR.BLUE[2], FONT_COLOR.BLUE[3], FONT_COLOR.BLUE[4])
      subItem.price:SetText(priceStr)
      subItem.price:AddAnchor("CENTER", subItem, 0, -10)
      subItem.price:Show(true)
      subItem.disPrice:SetText(dispriceStr)
      subItem.disPrice:AddAnchor("CENTER", subItem, 0, 10)
      subItem.disPrice:Show(true)
    else
      subItem.price:SetStrikeThrough(false)
      subItem.price:SetText(priceStr)
      subItem.price:AddAnchor("CENTER", subItem, 0, 0)
      subItem.price:Show(true)
      subItem.disPrice:Show(false)
    end
  end
  local PremiumPriceLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local price = subItem:CreateChildWidget("textbox", "price", 0, true)
    price:SetExtent(subItem:GetWidth() - 10, 24)
    price:AddAnchor("CENTER", subItem, 0, 0)
    ApplyTextColor(price, FONT_COLOR.BLUE)
    price.style:SetAlign(ALIGN_CENTER)
    local disPrice = subItem:CreateChildWidget("textbox", "disPrice", 0, true)
    disPrice:SetExtent(subItem:GetWidth() - 10, 24)
    disPrice:AddAnchor("CENTER", subItem, 0, 0)
    ApplyTextColor(disPrice, FONT_COLOR.BLUE)
    disPrice.style:SetAlign(ALIGN_CENTER)
  end
  local offset = SERVICE_BUY_LISTCTRL_OFFSET_X - widget:GetWidth()
  PREMIUM_GOODS_LIST_WIDTH = PREMIUM_GOODS_LIST_WIDTH - offset
  local width = SERVICE_BUY_LISTCTRL_OFFSET_X - (80 + PREMIUM_GOODS_LIST_WIDTH + offset + PREMIUM_BONUS_LIST_WIDTH + 110)
  widget:InsertColumn(locale.premium.premium_price, width, LCCIT_WINDOW, PremiumPriceDataSetFunc, nil, nil, PremiumPriceLayoutFunc)
  local PremiumBuyDataSetFunc = function(subItem, data, setValue)
    if data == nil or data == "" then
      subItem.buyBtn.index = nil
      subItem.buyBtn.itemType = nil
      subItem.buyBtn:Show(false)
    else
      subItem.buyBtn.index = data.index
      subItem.buyBtn.itemType = data.itemType
      subItem.buyBtn.name = data.name
      subItem.buyBtn:Show(true)
      subItem.buyBtn:Enable(true)
      local cnt = X2PremiumService:GetPremiumServiceBuyCount(data.index)
      if cnt == 0 then
        subItem.buyBtn:Enable(false)
      end
    end
  end
  local PremiumBuyLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local buyBtn = subItem:CreateChildWidget("button", "buyBtn", 0, true)
    buyBtn:SetText(locale.store.buyAll)
    buyBtn:AddAnchor("LEFT", subItem, 0, 0)
    ApplyButtonSkin(buyBtn, BUTTON_BASIC.DEFAULT)
    function buyBtn:OnClick()
      local index = subItem.buyBtn.index
      if index == nil then
        return
      end
      if X2PremiumService:IsPremiumNativeSite(index) then
        RequestCashUrl(subItem.buyBtn.name, index)
        return
      end
      local data = X2PremiumService:GetPremiumServiceBuyData(index)
      local uiState = X2Player:GetUIScreenState()
      if uiState == SCREEN_CHARACTER_SELECT then
        if X2LoginCharacter:GetNumLoginCharacters() == 0 then
          ShowRepresentCharacterMsg(GetUIText(COMMON_TEXT, "premium_service_buy_fail_not_have_character"), true)
        elseif X2Player:GetPremiumItemReceiveCharacterName() == nil then
          ShowRepresentCharacterMsg(GetUIText(COMMON_TEXT, "premium_service_buy_fail_not_represent_character"), true)
        elseif subItem.buyBtn.itemType ~= nil then
          ShowPremiumServiceBuyCharacterCheck(index)
        else
          ShowPremiumServiceBuy(index)
        end
      elseif subItem.buyBtn.itemType ~= nil then
        ShowPremiumServiceBuyCharacterCheck(index)
      else
        ShowPremiumServiceBuy(index)
      end
    end
    buyBtn:SetHandler("OnClick", buyBtn.OnClick)
  end
  widget:InsertColumn("", 110, LCCIT_WINDOW, PremiumBuyDataSetFunc, nil, nil, PremiumBuyLayoutFunc)
  widget:InsertRows(maxRowCount, false)
  widget:SetHeight(maxListHeight + listCtrl.column[1]:GetHeight())
  DrawPremiumBackground(widget)
  for i = 1, maxRowCount do
    local line = CreateLine(widget.listCtrl.items[i], "TYPE1", "overlay")
    line:AddAnchor("TOPLEFT", widget.listCtrl.items[i], "BOTTOMLEFT", 0, -2)
    line:AddAnchor("TOPRIGHT", widget.listCtrl.items[i], "BOTTOMRIGHT", 0, 0)
  end
  function CreateInspectionWindow(parent)
    local inspectionWindow = parent:CreateChildWidget("emptywidget", "inspectionWindow", 0, true)
    inspectionWindow:AddAnchor("TOPLEFT", parent, -5, 0)
    inspectionWindow:AddAnchor("BOTTOMRIGHT", parent, 5, 0)
    local bg = inspectionWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "modal_bg", "overlay")
    bg:SetTextureColor("default")
    bg:AddAnchor("TOPLEFT", parent, -18, 0)
    bg:AddAnchor("BOTTOMRIGHT", parent, 16, 0)
    local inspectionLabel = inspectionWindow:CreateChildWidget("label", "inspectionLabel", 0, true)
    inspectionLabel:SetHeight(30)
    inspectionLabel:SetAutoResize(true)
    inspectionLabel:AddAnchor("CENTER", bg, 0, 0)
    inspectionLabel:SetText(locale.inGameShop.nowCheckTime)
    inspectionLabel.style:SetAlign(ALIGN_CENTER)
    inspectionLabel.style:SetColor(0, 0, 0, 1)
    return inspectionWindow
  end
  local inspectionWindow = CreateInspectionWindow(wnd)
  wnd.inspectionWindow = inspectionWindow
  function inspectionWindow:ShowInspectionWindow(isShow)
    self:Show(isShow)
  end
  local moneyView = CreateServiceBuyMoneyView(wnd, premiumWnd)
  moneyView:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  wnd.moneyView = moneyView
  function wnd:GetContentHeight()
    local height = listCtrl.column[1]:GetHeight()
    for i = 1, maxRowCount do
      if listCtrl.items[i]:IsVisible() then
        height = height + listCtrl.items[i]:GetHeight()
      end
    end
    if self.moneyView.cashBuyBtn ~= nil then
      height = height + self.moneyView.cashBuyBtn:GetHeight() + sideMargin
    end
    return height
  end
end
function InsertPremiumServiceData(serviceTab)
  if serviceTab == nil then
    return
  end
  if premiumServiceLocale.serviceBuyButton == false then
    return
  end
  local premiumList = serviceTab.PremiumList
  local priceTextBox = serviceTab.priceTextBox
  local disPriceTextBox = serviceTab.disPriceTextBox
  local itemSlot = serviceTab.itemSlot
  local inspectionWindow = serviceTab.inspectionWindow
  inspectionWindow:ShowInspectionWindow(false)
  premiumList:DeleteAllDatas()
  local premiumCount = X2PremiumService:GetPremiumBuyMax()
  if premiumCount == 0 then
    inspectionWindow:ShowInspectionWindow(true)
  end
  local rowCount = math.min(maxRowCount, premiumCount)
  if premiumCount <= maxRowCount then
    premiumList.scroll:Show(false)
    if premiumCount == 0 then
      rowCount = maxRowCount
    end
  else
    premiumList.scroll:Show(true)
  end
  premiumList:SetHeight(premiumList.listCtrl.column[1]:GetHeight() + maxListHeight / rowCount * maxRowCount)
  premiumList.valueBG:RemoveAllAnchors()
  premiumList.valueBG:AddAnchor("TOPLEFT", premiumList.listCtrl, 0, 0)
  premiumList.valueBG:AddAnchor("BOTTOMRIGHT", premiumList.listCtrl.items[rowCount], 0, 5)
  local bonusWidth = 0
  local bonusText = ""
  for i = 1, premiumCount do
    local data = X2PremiumService:GetPremiumServiceBuyData(i)
    if data.itemType ~= nil then
      bonusWidth = PREMIUM_BONUS_LIST_WIDTH
      bonusText = locale.premium.bonus
      break
    end
  end
  local goodsWidth = PREMIUM_GOODS_LIST_WIDTH + PREMIUM_BONUS_LIST_WIDTH - bonusWidth
  premiumList.listCtrl.column[2]:SetWidth(goodsWidth)
  premiumList.listCtrl.column[3]:SetWidth(bonusWidth)
  premiumList.listCtrl.column[3]:SetText(bonusText)
  for i = 1, maxRowCount do
    local subItem = premiumList.listCtrl.items[i].subItems[2]
    subItem:SetWidth(goodsWidth)
    subItem = premiumList.listCtrl.items[i].subItems[3]
    subItem:SetWidth(bonusWidth)
    if premiumCount < i then
      premiumList.listCtrl.items[i]:Show(false)
    else
      premiumList.listCtrl.items[i]:Show(true)
    end
  end
  for i = 1, premiumCount do
    local data = X2PremiumService:GetPremiumServiceBuyData(i)
    local day = data.time / 24
    if day == 1 then
      premiumList:InsertData(i, 1, locale.time.day(tostring(day)))
    else
      premiumList:InsertData(i, 1, locale.time.days(tostring(day)))
    end
    premiumList:InsertData(i, 2, data.name)
    local bonusInfo = {}
    if data.itemType ~= nil then
      bonusInfo = {
        itemType = data.itemType,
        itemGrade = data.itemGrade,
        itemCount = data.itemCount
      }
    end
    premiumList:InsertData(i, 3, bonusInfo)
    local priceInfo = {
      priceType = data.priceType,
      price = data.price,
      disprice = data.disprice
    }
    premiumList:InsertData(i, 4, priceInfo)
    local buyInfo = {
      index = i,
      itemType = data.itemType,
      name = data.name
    }
    premiumList:InsertData(i, 5, buyInfo)
  end
end
function UpdateBuyMoneyView(serviceTab)
  if serviceTab == nil then
    return
  end
  if premiumServiceLocale.serviceBuyButton == false then
    return
  end
  local cash = X2Player:GetMyCash()
  local aapoint = X2Util:GetMyAAPointString()
  local cashBuyPoint = serviceTab.moneyView.cashBuyPoint
  if premiumServiceLocale.useCashCharge then
    cashBuyPoint:SetCashMoney(cash)
  end
  if serviceTab.moneyView.aaPointBuyPoint ~= nil then
    local aaPointBuyPoint = serviceTab.moneyView.aaPointBuyPoint
    if premiumServiceLocale.useAAPoint then
      aaPointBuyPoint:SetMyAAPointMoney(aapoint)
    end
  end
end
function UpdateExchangeRatio(serviceTab)
  if serviceTab == nil then
    return
  end
  if premiumServiceLocale.serviceBuyButton == false then
    return
  end
  if serviceTab.moneyView.aaPointBuyBtn ~= nil then
    serviceTab.moneyView.aaPointBuyBtn:Enable(X2Player:GetExchangeRatio() > 0)
  end
end
