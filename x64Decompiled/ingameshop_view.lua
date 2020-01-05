GOODS_ROW_COUNT = 4
GOODS_COL_COUNT = 2
GOODS_LAYOUT_SMALL = 8
GOODS_LAYOUT_BIG = 4
EACH_GOODS_WIDTH = 245
EACH_GOODS_HEIGHT = 85
EACH_GOODS_MIN_OFFSET = 5
TWOHAND_WEAPON_ANIMATION_NAME = "twohand_ba_combat_idle"
ONEHAND_WEAPON_ANIMATION_NAME = "onehand_ba_combat_idle"
RELAX_ANIMATION_NAME = "fist_ba_relaxed_rand_idle"
function SetViewOfGoods(parent)
  local totalIndex = 1
  for j = 1, GOODS_ROW_COUNT do
    for i = 1, GOODS_COL_COUNT do
      local emptyWindow = parent:CreateChildWidget("emptywidget", "goods", totalIndex, true)
      if totalIndex % 2 == 1 and j ~= GOODS_ROW_COUNT then
        MakeUnderline(emptyWindow)
        emptyWindow.underLineL:SetWidth(EACH_GOODS_WIDTH)
        emptyWindow.underLineR:SetWidth(EACH_GOODS_WIDTH)
      end
      if totalIndex == 1 then
        emptyWindow.centerLine = emptyWindow:CreateDrawable(TEXTURE_PATH.INGAME_SHOP, "goods_view_center_line", "artwork")
        emptyWindow.centerLine:AddAnchor("TOPRIGHT", emptyWindow, "TOPRIGHT", 2, 0)
        emptyWindow.centerLine:SetExtent(4, EACH_GOODS_HEIGHT * 4)
        emptyWindow.crossLine = emptyWindow:CreateDrawable(TEXTURE_PATH.TAB_LIST, "list_column_line_2", "artwork")
        emptyWindow.crossLine:AddAnchor("BOTTOMRIGHT", emptyWindow, "BOTTOMRIGHT", 23, 21)
        emptyWindow.crossLine:SetTextureColor("goods_view")
        emptyWindow.crossLine:SetExtent(25, 51)
      end
      local slot = CreateItemIconButton("slot", emptyWindow)
      slot:AddAnchor("TOPLEFT", emptyWindow, "TOPLEFT", EACH_GOODS_MIN_OFFSET, EACH_GOODS_MIN_OFFSET * 2)
      slot:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
      emptyWindow.slot = slot
      local remainWidth = EACH_GOODS_WIDTH - EACH_GOODS_MIN_OFFSET - ICON_SIZE.XLARGE
      emptyWindow.eventTypeIcon = emptyWindow:CreateDrawable(TEXTURE_PATH.INGAME_SHOP, "icon_bonus", "overlay")
      emptyWindow.eventTypeIcon:AddAnchor("TOPLEFT", slot, 0, 0)
      local goodsName = emptyWindow:CreateChildWidget("label", "goodsName", 0, true)
      goodsName:AddAnchor("TOPLEFT", slot, "TOPRIGHT", EACH_GOODS_MIN_OFFSET, 0)
      remainWidth = remainWidth - EACH_GOODS_MIN_OFFSET * 2
      goodsName:SetWidth(remainWidth)
      goodsName:SetHeight(FONT_SIZE.LARGE)
      goodsName.style:SetFontSize(FONT_SIZE.LARGE)
      goodsName.style:SetAlign(ALIGN_LEFT)
      goodsName.style:SetEllipsis(true)
      local disPrice = emptyWindow:CreateChildWidget("textbox", "disPrice", 0, true)
      disPrice:AddAnchor("TOPLEFT", goodsName, "BOTTOMLEFT", 0, EACH_GOODS_MIN_OFFSET * 2)
      disPrice:SetHeight(FONT_SIZE.MIDDLE)
      disPrice.style:SetFontSize(FONT_SIZE.MIDDLE)
      disPrice.style:SetAlign(ALIGN_TOP_LEFT)
      local price = emptyWindow:CreateChildWidget("textbox", "price", 0, true)
      price:AddAnchor("TOPRIGHT", goodsName, "BOTTOMRIGHT", 0, EACH_GOODS_MIN_OFFSET * 2)
      price:SetHeight(FONT_SIZE.MIDDLE)
      price.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(price, FONT_COLOR.DEFAULT)
      price.style:SetAlign(ALIGN_TOP_LEFT)
      local remain = emptyWindow:CreateChildWidget("label", "remain", 0, true)
      remain:AddAnchor("TOPLEFT", disPrice, "BOTTOMLEFT", 0, EACH_GOODS_MIN_OFFSET)
      remain:AddAnchor("TOPRIGHT", disPrice, "BOTTOMRIGHT", 0, EACH_GOODS_MIN_OFFSET)
      remain:SetHeight(FONT_SIZE.MIDDLE)
      remain.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(remain, FONT_COLOR.DEFAULT)
      remain.style:SetAlign(ALIGN_LEFT)
      local dateGroup = emptyWindow:CreateChildWidget("emptywidget", "dateGroup", 0, true)
      dateGroup:AddAnchor("TOPLEFT", emptyWindow, "LEFT", 2, -EACH_GOODS_MIN_OFFSET)
      dateGroup:AddAnchor("TOPRIGHT", emptyWindow, "RIGHT", -EACH_GOODS_MIN_OFFSET, -EACH_GOODS_MIN_OFFSET)
      dateGroup:SetHeight(FONT_SIZE.MIDDLE * 2 + EACH_GOODS_MIN_OFFSET * 5)
      MakeGroupBackgroundDrawable(dateGroup)
      local startDate = dateGroup:CreateChildWidget("label", "startDate", 0, true)
      startDate:AddAnchor("TOPLEFT", dateGroup, EACH_GOODS_MIN_OFFSET * 2, EACH_GOODS_MIN_OFFSET * 2)
      startDate:AddAnchor("TOPRIGHT", dateGroup, -EACH_GOODS_MIN_OFFSET, EACH_GOODS_MIN_OFFSET * 2)
      startDate:SetHeight(FONT_SIZE.MIDDLE)
      startDate.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(startDate, FONT_COLOR.DEFAULT)
      startDate.style:SetAlign(ALIGN_LEFT)
      local endDate = dateGroup:CreateChildWidget("label", "endDate", 0, true)
      endDate:AddAnchor("TOPLEFT", startDate, "BOTTOMLEFT", 0, EACH_GOODS_MIN_OFFSET)
      endDate:AddAnchor("TOPRIGHT", startDate, "BOTTOMRIGHT", 0, EACH_GOODS_MIN_OFFSET)
      endDate:SetHeight(FONT_SIZE.MIDDLE)
      endDate.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(endDate, FONT_COLOR.RED)
      endDate.style:SetAlign(ALIGN_LEFT)
      local buyButton = emptyWindow:CreateChildWidget("button", "buyButton", 0, true)
      ApplyButtonSkin(buyButton, BUTTON_CONTENTS.INGAMESHOP_BUY)
      buyButton:AddAnchor("BOTTOMLEFT", emptyWindow, 0, 0)
      local presentButton = emptyWindow:CreateChildWidget("button", "presentButton", 0, true)
      presentButton:AddAnchor("LEFT", buyButton, "RIGHT", EACH_GOODS_MIN_OFFSET, 0)
      ApplyButtonSkin(presentButton, BUTTON_CONTENTS.INGAMESHOP_PRESENT)
      local putToCartButton = emptyWindow:CreateChildWidget("button", "putToCartButton", 0, true)
      putToCartButton:AddAnchor("LEFT", presentButton, "RIGHT", EACH_GOODS_MIN_OFFSET, 0)
      ApplyButtonSkin(putToCartButton, BUTTON_CONTENTS.INGAMESHOP_CART)
      local stopSale = emptyWindow:CreateChildWidget("emptywidget", "stopSale", 0, true)
      stopSale:AddAnchor("TOPLEFT", emptyWindow, "TOPLEFT", 0, 0)
      stopSale:AddAnchor("BOTTOMRIGHT", emptyWindow, "BOTTOMRIGHT", 0, 0)
      local bg = CreateContentBackground(stopSale, "TYPE2", "brown_5")
      bg:AddAnchor("TOPLEFT", stopSale, 0, 0)
      bg:AddAnchor("BOTTOMRIGHT", stopSale, 0, -2)
      stopSale.bg = bg
      stopSale:Show(false)
      local msg = stopSale:CreateTextDrawable(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE, "overlay")
      msg:AddAnchor("LEFT", stopSale, "LEFT", 0, 0)
      msg:AddAnchor("RIGHT", stopSale, "RIGHT", 0, 0)
      msg:SetHeight(FONT_SIZE.XLARGE)
      msg.style:SetAlign(ALIGN_CENTER)
      msg.style:SetShadow(true)
      ApplyTextColor(msg, FONT_COLOR.WHITE)
      stopSale.msg = msg
      emptyWindow:Show(false)
      totalIndex = totalIndex + 1
    end
  end
end
INGAME_SHOP_FRAME_MAIN_MENU_TAB_WIDTH = 490
INGAME_SHOP_FRAME_MAIN_MENU_TAB_HEIGHT = 435
INGAME_SHOP_FRAME_AD_WIDTH = 257
INGAME_SHOP_FRAME_AD_HEIGHT = 53
INGAME_SHOP_FRAME_CASH_INFO_HEIGHT = 30
INGAME_SHOP_FRAME_CART_INFO_HEIGHT = 65
CART_PREVIEW_COUNT = 10
SUBMENU_GROUP_BG_HEIGHT_ONE_LINE = 45
SUBMENU_GROUP_BG_HEIGHT_TWO_LINE = 65
function SetViewOfInGameShopFrame(id, parent)
  local window = CreateWindow(id, parent, "ingameshop")
  window:SetCloseOnEscape(true, true)
  local height = 620
  local offsetHeight = 35
  if X2InGameShop:GetSecondPriceType() == PRICE_TYPE_AA_BONUS_CASH then
    offsetHeight = 65
  end
  window:SetExtent(800, height + offsetHeight)
  window:SetSounds("store")
  window.titleBar.closeButton:RemoveAllAnchors()
  window.titleBar.closeButton:AddAnchor("TOPRIGHT", window.titleBar, 0, -1)
  window.colorTexture = window:CreateDrawable(TEXTURE_PATH.INGAME_SHOP, "ingame_shop_color_bg", "background")
  window.colorTexture:SetTextureColor("default")
  window.colorTexture:AddAnchor("TOPLEFT", window, -12, -12)
  window.colorTexture:AddAnchor("BOTTOMRIGHT", window, 12, 12)
  window:SetTitle(locale.inGameShop.inGameShop)
  window.skipSettingWindowSkin = true
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local commercialMailBtn = window:CreateChildWidget("button", "commercialMailBtn", 0, true)
  commercialMailBtn:AddAnchor("RIGHT", window.titleBar.closeButton, "LEFT", 20, 6)
  ApplyButtonSkin(commercialMailBtn, BUTTON_CONTENTS.INGAMESHOP_COMMERCIAL_MAIL)
  local unreadCommercialMailCounter = commercialMailBtn:CreateChildWidget("label", "unreadCommercialMailCounter", 0, true)
  unreadCommercialMailCounter:AddAnchor("TOPRIGHT", commercialMailBtn, "TOPLEFT", 19, 1)
  unreadCommercialMailCounter:SetExtent(FONT_SIZE.SMALL * 2, FONT_SIZE.SMALL)
  unreadCommercialMailCounter.style:SetFontSize(FONT_SIZE.SMALL)
  unreadCommercialMailCounter.style:SetAlign(ALIGN_CENTER)
  unreadCommercialMailCounter:SetText("0")
  local counterBg = unreadCommercialMailCounter:CreateDrawable(TEXTURE_PATH.INGAME_SHOP, "unread_commercial_main_counter_bg", "background")
  counterBg:AddAnchor("CENTER", unreadCommercialMailCounter, "CENTER", 1, 2)
  local modelView = CreateModelview("modelView", window)
  modelView.rotateRight:AddAnchor("LEFT", modelView, 5, 32)
  modelView.rotateLeft:AddAnchor("RIGHT", modelView, -5, 32)
  local reset = modelView:CreateChildWidget("button", "reset", 0, true)
  reset:AddAnchor("BOTTOMRIGHT", modelView, -8, 0)
  ApplyButtonSkin(reset, BUTTON_BASIC.RESET)
  local beautyshop = modelView:CreateChildWidget("button", "beautyshop", 0, true)
  beautyshop:SetText(locale.inGameShop.enterBeautyShopBtn)
  ApplyButtonSkin(beautyshop, BUTTON_BASIC.TOGGLE_BEAUTYSHOP)
  local genderTransfer = modelView:CreateChildWidget("button", "genderTransfer", 0, true)
  genderTransfer:SetText(locale.inGameShop.genderTransferBtn)
  ApplyButtonSkin(genderTransfer, BUTTON_BASIC.TOGGLE_GENDER_TRANSFER)
  local buttonTable = {beautyshop, genderTransfer}
  AdjustBtnLongestTextWidth(buttonTable)
  modelView:AddAnchor("BOTTOMLEFT", window, "BOTTOMLEFT", MARGIN.WINDOW_SIDE * 0.3, -(titleMargin + MARGIN.WINDOW_SIDE / 2))
  beautyshop:AddAnchor("BOTTOMRIGHT", modelView, "TOP", 0, -MARGIN.WINDOW_SIDE / 2)
  genderTransfer:AddAnchor("BOTTOMLEFT", modelView, "TOP", 0, -MARGIN.WINDOW_SIDE / 2)
  local moneyView = CreateInGameShopMoneyView(window, MONEY_VIEW_CURRENT)
  local moneyViewHeight = 34
  local offsetYFromChargeAAPoint = -10
  local offsetXFromChargeAAPoint = 0
  if X2InGameShop:GetSecondPriceType() == PRICE_TYPE_AA_POINT or X2InGameShop:GetSecondPriceType() == PRICE_TYPE_AA_BONUS_CASH then
    local chargeAAPoint = window:CreateChildWidget("button", "chargeAAPoint", 0, true)
    chargeAAPoint:AddAnchor("BOTTOMRIGHT", window, -sideMargin, -MARGIN.WINDOW_SIDE)
    chargeAAPoint:SetText(locale.inGameShop.chargeAAPoint)
    ApplyButtonSkin(chargeAAPoint, BUTTON_BASIC.DEFAULT)
    chargeAAPoint:SetHeight(moneyViewHeight)
    chargeAAPoint:Enable(false)
    offsetXFromChargeAAPoint = chargeAAPoint:GetWidth()
  end
  local chargeCash = window:CreateChildWidget("button", "chargeCash", 0, true)
  chargeCash:AddAnchor("BOTTOMRIGHT", window, -(sideMargin + offsetXFromChargeAAPoint), -MARGIN.WINDOW_SIDE)
  chargeCash:SetText(GetUIText(INGAMESHOP_TEXT, "chargeCash"))
  ApplyButtonSkin(chargeCash, BUTTON_BASIC.DEFAULT)
  chargeCash:SetHeight(moneyViewHeight)
  local target = chargeCash
  if window.chargeAAPoint ~= nil then
    local buttonTable = {
      window.chargeAAPoint,
      chargeCash
    }
    AdjustBtnLongestTextWidth(buttonTable)
    target = window.chargeAAPoint
  end
  moneyView:AddAnchor("BOTTOMRIGHT", target, "TOPRIGHT", 3, -5)
  local mainMenuTab = W_BTN.CreateTab("mainMenuTab", window, "ingameshop")
  mainMenuTab:RemoveAllAnchors()
  mainMenuTab:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  mainMenuTab:SetExtent(INGAME_SHOP_FRAME_MAIN_MENU_TAB_WIDTH, INGAME_SHOP_FRAME_MAIN_MENU_TAB_HEIGHT)
  local tabTexts = {}
  for i = 1, 6 do
    table.insert(tabTexts, "")
  end
  mainMenuTab:AddTabs(tabTexts)
  local offsetY = mainMenuTab.selectedButton[1]:GetHeight() + 5
  local subMenuBg = CreateContentBackground(mainMenuTab, "TYPE2", "blue")
  subMenuBg:SetHeight(SUBMENU_GROUP_BG_HEIGHT_ONE_LINE)
  subMenuBg:AddAnchor("TOPLEFT", mainMenuTab, -10, offsetY)
  subMenuBg:AddAnchor("TOPRIGHT", mainMenuTab, 10, offsetY)
  mainMenuTab.subMenuBg = subMenuBg
  local selectedBg = CreateContentBackground(mainMenuTab, "TYPE2", "blue_2")
  selectedBg:SetHeight(38)
  mainMenuTab.selectedBg = selectedBg
  local subMenuButtons = {}
  local widthSum = 0
  for i = 1, 7 do
    local subMenuButton = mainMenuTab:CreateChildWidget("button", "subMenuButtons", i, true)
    subMenuButton:SetText("")
    subMenuButton:AddAnchor("TOPLEFT", mainMenuTab, "TOPLEFT", widthSum, offsetY)
    widthSum = widthSum + subMenuButton:GetWidth()
    subMenuButton:SetAutoResize(true)
    subMenuButton:SetHeight(FONT_SIZE.MIDDLE)
    local seperateLabel = subMenuButton:CreateChildWidget("label", "seperateLabel", 0, true)
    seperateLabel:SetText("|")
    seperateLabel:SetWidth(20)
    seperateLabel.style:SetAlign(ALIGN_CENTER)
    seperateLabel:AddAnchor("TOPLEFT", subMenuButton, "TOPRIGHT", 0, 1)
    seperateLabel:AddAnchor("BOTTOMLEFT", subMenuButton, "BOTTOMRIGHT", 0, 0)
    local color = {
      ConvertColor(114),
      ConvertColor(141),
      ConvertColor(162),
      1
    }
    ApplyTextColor(seperateLabel, color)
    subMenuButtons[i] = subMenuButton
  end
  window.subMenuButtons = subMenuButtons
  offsetY = offsetY + 62
  local goodsGroup = mainMenuTab:CreateChildWidget("emptywidget", "goodsGroup", 0, true)
  goodsGroup:AddAnchor("TOPLEFT", mainMenuTab, "TOPLEFT", 0, offsetY)
  goodsGroup:AddAnchor("BOTTOMRIGHT", mainMenuTab, "BOTTOMRIGHT", 0, 0)
  SetViewOfGoods(goodsGroup)
  window.goodsGroup = goodsGroup
  local page = W_CTRL.CreatePageControl(mainMenuTab:GetId() .. ".page", mainMenuTab, "ingameshop")
  page:AddAnchor("TOP", mainMenuTab, "BOTTOM", 0, 0)
  window.page = page
  local cartInfoSection = window:CreateChildWidget("emptywidget", "cartInfoSection", 0, true)
  cartInfoSection:AddAnchor("TOPLEFT", mainMenuTab, "BOTTOMLEFT", -11, 10)
  cartInfoSection:AddAnchor("TOPRIGHT", mainMenuTab, "BOTTOMRIGHT", 0, 10)
  cartInfoSection:SetHeight(INGAME_SHOP_FRAME_CART_INFO_HEIGHT)
  local presentCart = cartInfoSection:CreateChildWidget("button", "presentCart", 0, true)
  presentCart:AddAnchor("BOTTOMRIGHT", cartInfoSection, "BOTTOMRIGHT", 0, 1)
  ApplyButtonSkin(presentCart, BUTTON_CONTENTS.INGAMESHOP_PRESENT)
  local buyCart = cartInfoSection:CreateChildWidget("button", "buyCart", 0, true)
  buyCart:AddAnchor("BOTTOMRIGHT", presentCart, "TOPRIGHT", 0, -3)
  ApplyButtonSkin(buyCart, BUTTON_CONTENTS.INGAMESHOP_BUY)
  local cartPreview = W_CTRL.CreatePageControl("cartPreview", cartInfoSection, "ingameshop_cart")
  cartPreview:AddAnchor("TOPLEFT", cartInfoSection, 0, FONT_SIZE.LARGE)
  cartPreview:AddAnchor("BOTTOMLEFT", cartInfoSection, "BOTTOMLEFT", 0, 0)
  cartPreview:ShowPageButtons(false)
  cartInfoSection.cartPreview = cartPreview
  cartPreview.slots = {}
  local offsetX = cartPreview.prevPageButton:GetWidth()
  local slotGap = 3
  for i = 1, CART_PREVIEW_COUNT do
    local slot = CreateSlotItemButton(string.format("slots[%d]", i), cartPreview)
    slot:AddAnchor("LEFT", cartPreview, offsetX, 2)
    slot:SetItem(715, 0)
    slot:RegisterForClicks("RightButton")
    slot:RegisterForClicks("LeftButton", false)
    cartPreview.slots[i] = slot
    local slotBackground = cartPreview:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
    slotBackground:AddAnchor("TOPLEFT", slot, 0, 0)
    slotBackground:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
    slotBackground:SetColor(1, 1, 1, 0.3)
    slot.bg = slotBackground
    offsetX = offsetX + ICON_SIZE.DEFAULT + slotGap
  end
  cartPreview:SetWidth(CART_PREVIEW_COUNT * ICON_SIZE.DEFAULT + (CART_PREVIEW_COUNT - 1) * slotGap + cartPreview.prevPageButton:GetWidth() * 2)
  local title = cartInfoSection:CreateChildWidget("textbox", "title", 0, true)
  title:AddAnchor("TOPLEFT", cartInfoSection, cartPreview.prevPageButton:GetWidth(), 0)
  title:SetExtent(cartInfoSection:GetWidth() - cartPreview.prevPageButton:GetWidth(), FONT_SIZE.LARGE)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  title.style:SetAlign(ALIGN_LEFT)
  cartInfoSection:Lower()
  return window
end
function SetViewOfWaiting(id, parent)
  local waiting = parent:CreateChildWidget("emptywidget", id, 0, true)
  waiting:AddAnchor("TOPLEFT", parent, 0, 0)
  waiting:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local waiting_bg = waiting:CreateDrawable(TEXTURE_PATH.DEFAULT, "aa_point_bg", "background")
  waiting_bg:SetTextureColor("default")
  waiting_bg:AddAnchor("TOPLEFT", waiting, -1, 1)
  waiting_bg:AddAnchor("BOTTOMRIGHT", waiting, -1, -1)
  local waiting_effect = waiting:CreateEffectDrawable("ui/tutorials/loading.dds", "overlay")
  waiting_effect:SetExtent(32, 32)
  waiting_effect:SetCoords(100, 1, 32, 32)
  waiting_effect:AddAnchor("CENTER", waiting, 0, 0)
  waiting_effect:SetRepeatCount(0)
  waiting_effect:SetEffectPriority(1, "rotate", 1.5, 1.5)
  waiting_effect:SetEffectRotate(1, 0, 360)
  waiting.waiting_effect = waiting_effect
  waiting:Show(false)
  return waiting
end
