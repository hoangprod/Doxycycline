CART_GOOD_LIST_HEIGHT = 300
CART_FRIEND_HEIGHT = 50
CART_BUY_INTERFACE_HEIGHT = 60
CRAT_OPEN_TYPE_BUY = 1
CRAT_OPEN_TYPE_PRESENT = 2
CART_INNER_OFFSET = 10
function SetViewOfCartFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frameWindow = CreateEmptyWindow(id, parent)
  frameWindow:SetCloseOnEscape(true)
  frameWindow:AddAnchor("TOPLEFT", parent, 0, 0)
  frameWindow:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  frameWindow:SetSounds("world_map")
  local bg1 = frameWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "aa_point_bg", "background")
  bg1:SetTextureColor("default")
  bg1:AddAnchor("TOPLEFT", frameWindow, -1, 1)
  bg1:AddAnchor("BOTTOMRIGHT", frameWindow, -1, -1)
  local window = CreateWindow(id .. ".window", frameWindow)
  window:AddAnchor("CENTER", frameWindow, 0, 0)
  window:SetExtent(510, 500)
  window:SetTitle(locale.inGameShop.cart)
  frameWindow.window = window
  local goodListCtrl = W_CTRL.CreateScrollListCtrl("goodListCtrl", window)
  goodListCtrl:AddAnchor("TOPLEFT", window, "TOPLEFT", sideMargin, window.titleBar:GetHeight())
  goodListCtrl:AddAnchor("TOPRIGHT", window, "TOPRIGHT", -sideMargin, window.titleBar:GetHeight())
  goodListCtrl:SetHeight(CART_GOOD_LIST_HEIGHT)
  local goodListCtrlWidth = goodListCtrl:GetWidth()
  local function SetLayoutForEachField(frame, rowIndex, colIndex, subItem)
    local inset = 10
    local gap = 5
    if colIndex == 1 then
      local cartSlot = CreateSlotItemButton("cartSlot", subItem)
      cartSlot:AddAnchor("LEFT", subItem, 0, 0)
      subItem.cartSlot = cartSlot
      subItem:CreateChildWidget("label", "goodsName", 0, true)
      subItem.goodsName:AddAnchor("TOPLEFT", cartSlot, "TOPRIGHT", gap, gap)
      subItem.goodsName:AddAnchor("TOPRIGHT", subItem, -inset, 0)
      subItem.goodsName:SetHeight(FONT_SIZE.MIDDLE)
      subItem.goodsName.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(subItem.goodsName, FONT_COLOR.MIDDLE_TITLE)
      subItem.goodsName.style:SetAlign(ALIGN_LEFT)
      subItem.goodsName.style:SetEllipsis(true)
      subItem:CreateChildWidget("label", "time", 0, true)
      subItem.time:AddAnchor("TOPLEFT", subItem.goodsName, "BOTTOMLEFT", 0, gap)
      subItem.time:AddAnchor("TOPRIGHT", subItem.goodsName, "BOTTOMRIGHT", 0, gap)
      subItem.time:SetHeight(FONT_SIZE.MIDDLE)
      subItem.time.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(subItem.time, FONT_COLOR.DEFAULT)
      subItem.time.style:SetAlign(ALIGN_LEFT)
    elseif colIndex == 2 then
      subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
      subItem.style:SetAlign(ALIGN_TOP_RIGHT)
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      subItem:SetInset(0, inset, inset, 0)
    elseif colIndex == 3 then
      subItem.deleteButton = subItem:CreateChildWidget("button", "deleteButton", 0, true)
      subItem.deleteButton:SetText(locale.inGameShop.delete)
      subItem.deleteButton:AddAnchor("CENTER", subItem, "CENTER", 0, 0)
      ApplyButtonSkin(subItem.deleteButton, BUTTON_CONTENTS.INGAMESHOP_DELETE)
      subItem.deleteButton:SetWidth(60)
      function subItem.deleteButton:OnClick()
        if subItem.deleteButton.cartIndex ~= nil then
          X2InGameShop:DeleteGoodsInCart(subItem.deleteButton.cartIndex)
          frameWindow:ApplyCartInfos()
          inGameShopFrame:UpdateCartPreview()
        end
      end
      subItem.deleteButton:SetHandler("OnClick", subItem.deleteButton.OnClick)
    end
  end
  local function SetgoodsName(subItem, data, setValue)
    local item = subItem:GetParent()
    item.cantPresent:Show(false)
    if setValue == true then
      local gradeInfo = X2Item:GetItemInfoByType(data.itemType, 0, IIK_GRADE)
      if gradeInfo.fixedGrade ~= nil then
        subItem.cartSlot:SetItem(data.itemType, gradeInfo.fixedGrade)
      else
        subItem.cartSlot:SetItem(data.itemType, 0)
      end
      subItem.cartSlot:Show(true)
      subItem.goodsName:SetText(data.name or "")
      subItem.cartSlot:SetStack("")
      subItem.time:SetText("")
      if data.selectType == "count" then
        subItem.cartSlot:SetStack(data.count)
      elseif data.selectType == "time" then
        subItem.time:SetText(GetPeriod(data.time))
      end
      if frameWindow.openType == CRAT_OPEN_TYPE_PRESENT and data.cmdUi ~= CU_ALL and data.cmdUi ~= CU_BUY_PRESENT then
        item.cantPresent:Show(true)
      end
    else
      subItem.cartSlot:Show(false)
      subItem.goodsName:SetText("")
      subItem.cartSlot:SetStack("")
      subItem.time:SetText("")
    end
    SetUpperLineVisible(item, setValue)
  end
  local SetPrice = function(subItem, data, setValue)
    if setValue == true then
      subItem:SetText(SettingGoodPriceText(data.price, data.priceType, nil, data.payItemType))
    else
      subItem:SetText("")
    end
  end
  local SetEachDeleteInterface = function(subItem, data, setValue)
    subItem.deleteButton:Show(setValue)
    if setValue == true then
      subItem.deleteButton.cartIndex = data
    else
      subItem.deleteButton.cartIndex = nil
    end
  end
  goodListCtrl:InsertColumn(locale.inGameShop.nameTitle, 220, LCCIT_WINDOW, SetgoodsName, nil, nil, SetLayoutForEachField)
  goodListCtrl:InsertColumn(locale.inGameShop.priceTitle, 160, LCCIT_TEXTBOX, SetPrice, nil, nil, SetLayoutForEachField)
  goodListCtrl:InsertColumn(locale.inGameShop.deleteTitle, 70, LCCIT_WINDOW, SetEachDeleteInterface, nil, nil, SetLayoutForEachField)
  goodListCtrl.listCtrl.column[1].curSortFunc = nil
  goodListCtrl.listCtrl.column[2].curSortFunc = nil
  goodListCtrl.listCtrl.column[3].curSortFunc = nil
  goodListCtrl:InsertRows(5, false)
  DrawListCtrlUnderLine(goodListCtrl.listCtrl)
  for i = 1, #goodListCtrl.listCtrl.column do
    SettingListColumn(goodListCtrl.listCtrl, goodListCtrl.listCtrl.column[i])
    goodListCtrl.listCtrl.column[i].style:SetAlign(ALIGN_CENTER)
    DrawListCtrlColumnSperatorLine(goodListCtrl.listCtrl.column[i], #goodListCtrl.listCtrl.column, i)
  end
  for i = 1, goodListCtrl:GetRowCount() do
    local item = goodListCtrl.listCtrl.items[i]
    if i ~= 1 then
      MakeUpperline(item)
      item.upperLineL:SetWidth(goodListCtrlWidth / 2)
      item.upperLineR:SetWidth(goodListCtrlWidth / 2)
    end
    local cantPresent = item:CreateChildWidget("emptywidget", "cantPresent", 0, true)
    cantPresent:AddAnchor("TOPLEFT", item, "TOPLEFT", 0, 0)
    cantPresent:AddAnchor("BOTTOMRIGHT", item, "BOTTOMRIGHT", 0, 0)
    local bg = cantPresent:CreateDrawable(TEXTURE_PATH.TAB_LIST, "enchant_info_bg", "background")
    bg:SetTextureColor("ingameshop_cant_present")
    bg:AddAnchor("TOPLEFT", cantPresent, "TOPLEFT", 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", cantPresent, "BOTTOMRIGHT", 0, 0)
    cantPresent:CreateChildWidget("label", "msg", 0, true)
    cantPresent.msg:AddAnchor("LEFT", cantPresent, "LEFT", 0, 0)
    cantPresent.msg:AddAnchor("RIGHT", cantPresent, "RIGHT", 0, 0)
    cantPresent.msg:SetHeight(FONT_SIZE.LARGE)
    cantPresent.msg.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(cantPresent.msg, FONT_COLOR.WHITE)
    cantPresent.msg.style:SetAlign(ALIGN_CENTER)
    cantPresent.msg:SetText(locale.inGameShop.cantPresent)
    cantPresent:Show(false)
  end
  goodListCtrl.listCtrl:ChangeSortMartTexture()
  goodListCtrl:SetSortMarkOffsetY()
  local friend = window:CreateChildWidget("emptywidget", "friend", 0, true)
  friend:AddAnchor("TOPLEFT", goodListCtrl, "BOTTOMLEFT", 0, sideMargin / 3)
  friend:AddAnchor("TOPRIGHT", goodListCtrl, "BOTTOMRIGHT", 0, sideMargin / 3)
  friend:SetHeight(CART_FRIEND_HEIGHT)
  MakeGroupBackgroundDrawable(friend)
  W_CTRL.CreateComboBox("comboBox", friend)
  friend.comboBox:SetVisibleItemCount(5)
  friend.comboBox:SetWidth(150)
  friend.comboBox:AddAnchor("LEFT", friend, sideMargin / 2, 0)
  friend.comboBox:SetGuideText(locale.inGameShop.friend, true)
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local inputFriend = W_CTRL.CreateEdit("inputFriend", friend)
  inputFriend:SetExtent(200, DEFAULT_SIZE.EDIT_HEIGHT)
  inputFriend:AddAnchor("LEFT", friend.comboBox, "RIGHT", sideMargin / 4, 0)
  inputFriend:SetMaxTextLength(namePolicyInfo.max)
  local buyInterface = window:CreateChildWidget("emptywidget", "buyInterface", 0, true)
  buyInterface:SetWidth(goodListCtrl:GetWidth())
  local refundMessage = window:CreateChildWidget("textbox", "refundMessage", 0, true)
  refundMessage:SetWidth(friend:GetWidth())
  ApplyTextColor(refundMessage, FONT_COLOR.RED)
  local moneyView = CreateInGameShopMoneyView(buyInterface, MONEY_VIEW_AFTER)
  moneyView:AddAnchor("BOTTOMLEFT", buyInterface, 0, 0)
  local buyButton = buyInterface:CreateChildWidget("button", "buyButton", 0, true)
  buyButton:AddAnchor("RIGHT", buyInterface, -sideMargin / 2, 0)
  buyInterface:SetHeight(moneyView:GetHeight())
  MakeGroupBackgroundDrawable(buyInterface)
  return frameWindow
end
