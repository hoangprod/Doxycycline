local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateBackpackStoreWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, 245)
  window:SetTitle(GetUIText(STORE_TEXT, "backpack_store_title"))
  local bodyText = UIParent:CreateWidget("textbox", id .. ".bodyText", window)
  bodyText:Show(true)
  local widthWindow = window:GetWidth()
  bodyText:SetWidth(widthWindow - sideMargin * 2)
  bodyText:AddAnchor("TOP", window, 0, titleMargin)
  bodyText:SetText(GetUIText(STORE_TEXT, "backpack_store_body"))
  bodyText.style:SetSnap(true)
  bodyText.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(bodyText, FONT_COLOR.DEFAULT)
  bodyText:SetHeight(bodyText:GetTextHeight())
  window.bodyText = bodyText
  local heightWindow = bodyText:GetHeight() + titleMargin
  local itemIcon = CreateItemIconButton(id .. "itemIcon", window)
  itemIcon:AddAnchor("TOP", bodyText, "BOTTOM", 0, sideMargin / 2)
  window.itemIcon = itemIcon
  heightWindow = heightWindow + itemIcon:GetHeight() + sideMargin / 2
  local itemPrice = window:CreateChildWidget("textbox", "itemPrice", 0, true)
  itemPrice:Show(true)
  itemPrice:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 5)
  ApplyTextColor(itemPrice, FONT_COLOR.TITLE)
  itemPrice.style:SetAlign(ALIGN_CENTER)
  window.itemPrice = itemPrice
  local bg = itemPrice:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:SetExtent(150, 29)
  bg:AddAnchor("CENTER", itemPrice, 0, 7)
  itemPrice:SetExtent(widthWindow - sideMargin * 2, 29)
  heightWindow = heightWindow + 5 + itemPrice:GetHeight() + 27
  local info = {
    leftButtonStr = GetUIText(STORE_TEXT, "sell"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(window, info)
  heightWindow = heightWindow + window.leftButton:GetHeight() + MARGIN.WINDOW_SIDE
  window:SetExtent(POPUP_WINDOW_WIDTH, heightWindow)
  return window
end
