BUY_FRIEND_HEIGHT = 50
EVENT_INFO_MAX_COUNT = 3
PACKAGET_MAX_COUNT = 10
PACKAGET_EACH_LINE_HEIGHT = 50
GOOD_DETAIL_MAX_COUNT = 4
BUY_CONFIRM_OFFSET = 5
function SetViewOfConfirmFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetCloseOnEscape(true)
  window:SetExtent(430, 500)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(locale.inGameShop.buy)
  local contentWidth = window:GetWidth() - sideMargin * 2
  local titleGroup = window:CreateChildWidget("emptywidget", "titleGroup", 0, true)
  titleGroup:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  titleGroup:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  local slotBg = CreateContentBackground(titleGroup, "TYPE4", "brown")
  slotBg:SetExtent(72, 72)
  slotBg:AddAnchor("LEFT", titleGroup, 0, 0)
  local slot = CreateSlotItemButton("slot", titleGroup)
  slot:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  slot:AddAnchor("CENTER", slotBg, -1, -3)
  titleGroup.slot = slot
  local goodsName = titleGroup:CreateChildWidget("label", "goodsName", 0, true)
  goodsName:SetExtent(contentWidth - slotBg:GetWidth() - 5, FONT_SIZE.LARGE)
  goodsName:AddAnchor("TOPLEFT", slot, "TOPRIGHT", sideMargin / 2, BUY_CONFIRM_OFFSET)
  goodsName.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(goodsName, FONT_COLOR.MIDDLE_TITLE)
  goodsName.style:SetAlign(ALIGN_LEFT)
  goodsName.style:SetEllipsis(true)
  local price = titleGroup:CreateChildWidget("textbox", "price", 0, true)
  price:AddAnchor("TOPRIGHT", goodsName, "BOTTOMRIGHT", 0, BUY_CONFIRM_OFFSET)
  price:SetHeight(FONT_SIZE.MIDDLE)
  price.style:SetFontSize(FONT_SIZE.LARGE)
  price.style:SetAlign(ALIGN_LEFT)
  local disPrice = titleGroup:CreateChildWidget("textbox", "disPrice", 0, true)
  disPrice:AddAnchor("TOPLEFT", goodsName, "BOTTOMLEFT", 0, BUY_CONFIRM_OFFSET)
  disPrice:SetHeight(FONT_SIZE.LARGE)
  disPrice.style:SetFontSize(FONT_SIZE.LARGE)
  disPrice.style:SetAlign(ALIGN_LEFT)
  titleGroup:SetHeight(slotBg:GetHeight())
  local eventGroup = window:CreateChildWidget("emptywidget", "eventGroup", 0, true)
  eventGroup:AddAnchor("TOPLEFT", titleGroup, "BOTTOMLEFT", 0, 0)
  eventGroup:AddAnchor("TOPRIGHT", titleGroup, "BOTTOMRIGHT", 0, 0)
  eventGroup.bg = MakeGroupBackgroundDrawable(eventGroup)
  eventGroup.eventInfoDefaultHeight = FONT_SIZE.MIDDLE
  local eventInfoAnchorTarget = eventGroup
  for i = 1, EVENT_INFO_MAX_COUNT do
    local eventInfo = eventGroup:CreateChildWidget("textbox", "eventInfo", i, true)
    if i == 1 then
      eventInfo:AddAnchor("TOPLEFT", eventInfoAnchorTarget, "TOPLEFT", BUY_CONFIRM_OFFSET * 4, BUY_CONFIRM_OFFSET * 2)
      eventInfo:AddAnchor("TOPRIGHT", eventInfoAnchorTarget, "TOPRIGHT", -BUY_CONFIRM_OFFSET * 2, BUY_CONFIRM_OFFSET * 2)
    else
      eventInfo:AddAnchor("TOPLEFT", eventInfoAnchorTarget, "BOTTOMLEFT", 0, BUY_CONFIRM_OFFSET)
      eventInfo:AddAnchor("TOPRIGHT", eventInfoAnchorTarget, "BOTTOMRIGHT", 0, BUY_CONFIRM_OFFSET)
    end
    eventInfo:SetHeight(eventGroup.eventInfoDefaultHeight)
    eventInfo.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(eventInfo, FONT_COLOR.DEFAULT)
    eventInfoAnchorTarget = eventInfo
  end
  local slot = CreateSlotItemButton("slot", eventGroup)
  slot:Show(false)
  slot:AddAnchor("TOPLEFT", eventGroup, 0, 0)
  eventGroup.slot = slot
  local packageGroup = window:CreateChildWidget("emptywidget", "packageGroup", 0, true)
  packageGroup:AddAnchor("TOPLEFT", eventGroup, "BOTTOMLEFT", 0, 0)
  packageGroup:AddAnchor("TOPRIGHT", eventGroup, "BOTTOMRIGHT", 0, 0)
  local packageGroupHeight = 0
  local packageTitle = packageGroup:CreateChildWidget("label", "packageTitle", 0, true)
  packageTitle:AddAnchor("TOPLEFT", packageGroup, BUY_CONFIRM_OFFSET, BUY_CONFIRM_OFFSET)
  packageTitle:AddAnchor("TOPRIGHT", packageGroup, -BUY_CONFIRM_OFFSET, BUY_CONFIRM_OFFSET)
  packageTitle:SetHeight(FONT_SIZE.LARGE + BUY_CONFIRM_OFFSET * 4)
  packageTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(packageTitle, FONT_COLOR.MIDDLE_TITLE)
  packageTitle.style:SetAlign(ALIGN_LEFT)
  packageTitle:SetText(locale.inGameShop.package)
  packageGroupHeight = packageGroupHeight + packageTitle:GetHeight() + BUY_CONFIRM_OFFSET * 2
  MakeUnderline(packageTitle)
  packageTitle.underLineL:SetWidth(packageGroup:GetWidth() / 2)
  packageTitle.underLineR:SetWidth(packageGroup:GetWidth() / 2)
  local scrollWindow = CreateScrollWindow(packageGroup, "scrollWindow", 0)
  scrollWindow:AddAnchor("TOPLEFT", packageTitle, "BOTTOMLEFT", 0, BUY_CONFIRM_OFFSET)
  scrollWindow:AddAnchor("TOPRIGHT", packageTitle, "BOTTOMRIGHT", 0, BUY_CONFIRM_OFFSET)
  packageGroup.scrollWindow = scrollWindow
  packageGroupHeight = packageGroupHeight + BUY_CONFIRM_OFFSET
  local packageContentHeight = 0
  offsetY = 0
  local packageLines = {}
  for i = 1, PACKAGET_MAX_COUNT do
    packageLines[i] = scrollWindow.content:CreateChildWidget("emptywidget", "packageLine" .. i, 0, true)
    packageLines[i]:AddAnchor("TOPLEFT", scrollWindow.content, "TOPLEFT", 0, offsetY)
    packageLines[i]:AddAnchor("TOPRIGHT", scrollWindow.content, "TOPRIGHT", 0, offsetY)
    packageLines[i]:SetHeight(PACKAGET_EACH_LINE_HEIGHT)
    if i ~= 1 then
      MakeUpperline(packageLines[i])
      packageLines[i].upperLineL:SetWidth(packageLines[i]:GetWidth() / 2)
      packageLines[i].upperLineR:SetWidth(packageLines[i]:GetWidth() / 2)
    end
    local slot = CreateSlotItemButton("slot", packageLines[i])
    slot:AddAnchor("LEFT", packageLines[i], BUY_CONFIRM_OFFSET * 2, 0)
    packageLines[i].slot = slot
    local itemName = packageLines[i]:CreateChildWidget("label", "itemName", 0, true)
    itemName:AddAnchor("LEFT", slot, "RIGHT", BUY_CONFIRM_OFFSET, 0)
    itemName:SetExtent(100, FONT_SIZE.LARGE)
    itemName.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
    itemName.style:SetAlign(ALIGN_LEFT)
    itemName.style:SetEllipsis(true)
    local infoBySelectType = packageLines[i]:CreateChildWidget("label", "infoBySelectType", 0, true)
    infoBySelectType:AddAnchor("RIGHT", packageLines[i], -BUY_CONFIRM_OFFSET * 2, 0)
    infoBySelectType:SetAutoResize(true)
    infoBySelectType:SetHeight(FONT_SIZE.LARGE)
    infoBySelectType.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(infoBySelectType, FONT_COLOR.DEFAULT)
    infoBySelectType.style:SetAlign(ALIGN_RIGHT)
    offsetY = offsetY + PACKAGET_EACH_LINE_HEIGHT
    packageContentHeight = packageContentHeight + PACKAGET_EACH_LINE_HEIGHT
  end
  scrollWindow:SetHeight(PACKAGET_EACH_LINE_HEIGHT * 4)
  scrollWindow:ResetScroll(packageContentHeight)
  packageGroupHeight = packageGroupHeight + PACKAGET_EACH_LINE_HEIGHT * 4
  packageGroup.packageLines = packageLines
  packageGroup:SetHeight(packageGroupHeight)
  local detailGroup = window:CreateChildWidget("emptywidget", "detailGroup", 0, true)
  detailGroup:AddAnchor("TOPLEFT", eventGroup, "BOTTOMLEFT", 0, 0)
  detailGroup:AddAnchor("TOPRIGHT", eventGroup, "BOTTOMRIGHT", 0, 0)
  local detailGroupWidth = detailGroup:GetWidth()
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", detailGroup)
  listCtrl:Show(true)
  listCtrl:AddAnchor("TOPLEFT", detailGroup, 0, 0)
  listCtrl:AddAnchor("BOTTOMRIGHT", detailGroup, 0, 0)
  listCtrl:InsertColumn(detailGroupWidth / 2, LCCIT_WINDOW)
  listCtrl.column[1]:SetText(locale.inGameShop.selectType)
  SettingListColumn(listCtrl, listCtrl.column[1])
  DrawListCtrlColumnSperatorLine(listCtrl.column[1], 2, 1)
  listCtrl:InsertColumn(detailGroupWidth / 2, LCCIT_TEXTBOX)
  listCtrl.column[2]:SetText(locale.inGameShop.priceTitle)
  SettingListColumn(listCtrl, listCtrl.column[2])
  DrawListCtrlColumnSperatorLine(listCtrl.column[2], 2, 2)
  local detailTotalHeight = listCtrl.column[1]:GetHeight()
  detailTotalHeight = detailTotalHeight + (FONT_SIZE.LARGE + BUY_CONFIRM_OFFSET * 2) * GOOD_DETAIL_MAX_COUNT
  detailGroup:SetHeight(detailTotalHeight)
  listCtrl:InsertRows(GOOD_DETAIL_MAX_COUNT, false)
  DrawListCtrlUnderLine(listCtrl)
  local firstOffset = {x = 0, y = 0}
  local details = CreateRadioGroup("details", detailGroup, "vertical")
  details:SetAutoWidth(true)
  details:SetGapHeight(BUY_CONFIRM_OFFSET * 2)
  details:AddAnchor("TOPLEFT", listCtrl.items[1].subItems[1], "TOPLEFT", BUY_CONFIRM_OFFSET * 4, BUY_CONFIRM_OFFSET)
  for i = 1, GOOD_DETAIL_MAX_COUNT do
    if i ~= 1 then
      MakeUpperline(listCtrl.items[i])
      listCtrl.items[i].upperLineL:SetWidth(detailGroupWidth / 2)
      listCtrl.items[i].upperLineR:SetWidth(detailGroupWidth / 2)
    end
    listCtrl.items[i].subItems[2].style:SetFontSize(FONT_SIZE.LARGE)
    listCtrl.items[i].subItems[2].style:SetAlign(ALIGN_RIGHT)
    listCtrl.items[i].subItems[2]:SetInset(0, 0, BUY_CONFIRM_OFFSET * 6, 0)
  end
  detailGroup.details = details
  local friendGroup = window:CreateChildWidget("emptywidget", "friendGroup", 0, true)
  friendGroup:AddAnchor("TOP", detailGroup, "BOTTOM", 0, 0)
  friendGroup:SetExtent(eventGroup:GetWidth(), BUY_FRIEND_HEIGHT)
  MakeGroupBackgroundDrawable(friendGroup)
  W_CTRL.CreateComboBox("comboBox", friendGroup)
  friendGroup.comboBox:SetVisibleItemCount(5)
  friendGroup.comboBox:SetWidth(150)
  friendGroup.comboBox:AddAnchor("LEFT", friendGroup, BUY_CONFIRM_OFFSET * 2, 0)
  friendGroup.comboBox:SetGuideText(locale.inGameShop.friend, true)
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local inputFriend = W_CTRL.CreateEdit("inputFriend", friendGroup)
  inputFriend:SetExtent(200, DEFAULT_SIZE.EDIT_HEIGHT)
  inputFriend:AddAnchor("LEFT", friendGroup.comboBox, "RIGHT", BUY_CONFIRM_OFFSET * 2, 0)
  inputFriend:SetMaxTextLength(namePolicyInfo.max)
  local refundMessage = window:CreateChildWidget("textbox", "refundMessage", 0, true)
  refundMessage:SetWidth(eventGroup:GetWidth())
  ApplyTextColor(refundMessage, FONT_COLOR.RED)
  local btnOk = window:CreateChildWidget("button", "btnOk", 0, true)
  btnOk:AddAnchor("BOTTOM", window, "BOTTOM", -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, -sideMargin)
  local btnCancel = window:CreateChildWidget("button", "btnCancel", 0, true)
  btnCancel:SetText(locale.inGameShop.cancel)
  btnCancel:AddAnchor("BOTTOM", window, "BOTTOM", BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, -sideMargin)
  ApplyButtonSkin(btnCancel, BUTTON_BASIC.DEFAULT)
  return window
end
