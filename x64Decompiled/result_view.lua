BUY_RESULT_WIDGET_WIDTH = 430
BUY_RESULT_WIDGET_WIDTH_SMALL = 310
BUY_RESULT_WIDGET_HEIGHT = 500
BUY_RESULT_LIST_HEIGHT = 305
BUY_RESULT_OPEN_TYPE_BUY = 1
BUY_RESULT_OPEN_TYPE_PRESENT = 2
BUY_RESULT_OPEN_TYPE_CART = 3
BUY_RESULT_BUTTON_OFFSET = 80
function SetViewOfResultFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frameWindow = CreateEmptyWindow(id, parent)
  frameWindow:SetCloseOnEscape(true)
  frameWindow:AddAnchor("TOPLEFT", parent, 0, 0)
  frameWindow:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local bg = frameWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "aa_point_bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", frameWindow, -1, 1)
  bg:AddAnchor("BOTTOMRIGHT", frameWindow, -1, -1)
  local window = CreateWindow(id .. ".window", frameWindow)
  window:SetExtent(BUY_RESULT_WIDGET_WIDTH, BUY_RESULT_WIDGET_HEIGHT)
  window:AddAnchor("CENTER", frameWindow, 0, 0)
  frameWindow.window = window
  local resultListCtrl = W_CTRL.CreateScrollListCtrl("resultListCtrl", window)
  resultListCtrl:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  resultListCtrl:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  resultListCtrl:SetHeight(BUY_RESULT_LIST_HEIGHT)
  local resultListCtrlWidth = resultListCtrl:GetWidth()
  local SetLayoutForEachField = function(frame, rowIndex, colIndex, subItem)
    if colIndex == 1 then
      local width = subItem:GetWidth()
      local cartSlot = CreateSlotItemButton("cartSlot", subItem)
      cartSlot:AddAnchor("LEFT", subItem, "LEFT", 0, 0)
      width = width - cartSlot:GetWidth()
      subItem.cartSlot = cartSlot
      subItem:CreateChildWidget("label", "goodsName", 0, true)
      subItem.goodsName:AddAnchor("BOTTOMLEFT", subItem.cartSlot, "RIGHT", 5, -5)
      subItem.goodsName:SetExtent(width - 10, FONT_SIZE.MIDDLE)
      subItem.goodsName.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(subItem.goodsName, FONT_COLOR.MIDDLE_TITLE)
      subItem.goodsName.style:SetAlign(ALIGN_LEFT)
      subItem.goodsName.style:SetEllipsis(true)
      subItem:CreateChildWidget("label", "time", 0, true)
      subItem.time:AddAnchor("TOPLEFT", subItem.cartSlot, "RIGHT", 5, 0)
      subItem.time:SetExtent(width - 10, FONT_SIZE.MIDDLE)
      subItem.time.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(subItem.time, FONT_COLOR.DEFAULT)
      subItem.time.style:SetAlign(ALIGN_LEFT)
    elseif colIndex == 2 then
      subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
      subItem.style:SetAlign(ALIGN_TOP)
      subItem:SetInset(0, 8, 0, 0)
    end
  end
  local SetgoodsName = function(subItem, data, setValue)
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
    else
      subItem.cartSlot:Show(false)
      subItem.goodsName:SetText("")
      subItem.cartSlot:SetStack("")
      subItem.time:SetText("")
    end
    local item = subItem:GetParent()
    SetUpperLineVisible(item, setValue)
  end
  local function SetResult(subItem, data, setValue)
    if data == BFR_NONE then
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
      if frameWindow.openType == BUY_RESULT_OPEN_TYPE_PRESENT then
        subItem:SetText(locale.inGameShop.successPresent)
      else
        subItem:SetText(locale.inGameShop.successBuy)
      end
    else
      ApplyTextColor(subItem, FONT_COLOR.RED)
      if frameWindow.openType == BUY_RESULT_OPEN_TYPE_PRESENT then
        subItem:SetText(locale.inGameShop.failPresent)
      else
        subItem:SetText(locale.inGameShop.failBuy)
      end
    end
  end
  resultListCtrl:InsertColumn(locale.inGameShop.nameTitle, 275, LCCIT_WINDOW, SetgoodsName, nil, nil, SetLayoutForEachField)
  resultListCtrl:InsertColumn(locale.inGameShop.resultTitle, 95, LCCIT_TEXTBOX, SetResult, nil, nil, SetLayoutForEachField)
  resultListCtrl.listCtrl.column[1].curSortFunc = nil
  resultListCtrl.listCtrl.column[2].curSortFunc = nil
  resultListCtrl:InsertRows(5, false)
  DrawListCtrlUnderLine(resultListCtrl.listCtrl)
  for i = 2, resultListCtrl:GetRowCount() do
    local item = resultListCtrl.listCtrl.items[i]
    MakeUpperline(item)
    item.upperLineL:SetWidth(resultListCtrlWidth / 2)
    item.upperLineR:SetWidth(resultListCtrlWidth / 2)
  end
  for i = 1, #resultListCtrl.listCtrl.column do
    SettingListColumn(resultListCtrl.listCtrl, resultListCtrl.listCtrl.column[i])
    resultListCtrl.listCtrl.column[i].style:SetAlign(ALIGN_CENTER)
    DrawListCtrlColumnSperatorLine(resultListCtrl.listCtrl.column[i], #resultListCtrl.listCtrl.column, i)
  end
  resultListCtrl.listCtrl:ChangeSortMartTexture()
  resultListCtrl:SetSortMarkOffsetY()
  local moneyView = CreateInGameShopMoneyView(window, MONEY_VIEW_AFTER)
  MakeGroupBackgroundDrawable(moneyView)
  moneyView:AddAnchor("TOP", resultListCtrl, "BOTTOM", 0, sideMargin / 2)
  local message = window:CreateChildWidget("textbox", "message", 0, true)
  message:SetAutoResize(true)
  message.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(message, FONT_COLOR.DEFAULT)
  local infos = {
    leftButtonStr = GetCommonText("ok"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(window, infos)
  return frameWindow
end
