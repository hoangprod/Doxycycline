function SetViewOfStoreBuyFrame(window)
  local cartWindow = window:CreateChildWidget("emptywidget", "cartWindow", 0, true)
  cartWindow:Show(true)
  cartWindow:SetHeight(45)
  cartWindow:AddAnchor("BOTTOMLEFT", window, 0, -5)
  cartWindow:AddAnchor("BOTTOMRIGHT", window, 0, -5)
  window.cartWindow = cartWindow
  local pageControl = W_CTRL.CreatePageControl(window:GetId() .. ".pageControl", window)
  pageControl:Show(true)
  pageControl:AddAnchor("BOTTOM", cartWindow, "TOP", 0, -17)
  window.pageControl = pageControl
  local buyList = SetViewOfStoreItemSetSlot(window, STORE_MAX_DEFAULT_ITEM_COLUMN, STORE_MAX_BUY_ROW)
  window.buyList = buyList
  local cartList = SetViewOfStoreItemSlot(cartWindow, STORE_MAX_CART_COL, STORE_MAX_CART_ROW, 0, 0, 47.3)
  window.cartList = cartList
  local spinner = CreateSplitItemWindow(window:GetId() .. ".buySpinner", window)
  spinner:Show(false)
  spinner:AddAnchor("CENTER", window, 0, 0)
  window.spinner = spinner
end
