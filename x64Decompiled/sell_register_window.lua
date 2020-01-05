local SetViewOfSellRegisterWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:EnableHidingIsRemove(true)
  window:SetExtent(POPUP_WINDOW_WIDTH, 415)
  window:AddAnchor("TOPRIGHT", parent, POPUP_WINDOW_WIDTH, -4)
  window:SetTitle(locale.housing.sell.set)
  local function CreateContentFrame(id, titleStr, height)
    local frame = window:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(317, height)
    local title = frame:CreateChildWidget("label", "title", 0, true)
    title:SetText(titleStr)
    title:SetExtent(120, FONT_SIZE.LARGE)
    title:AddAnchor("TOPLEFT", frame, 5, 5)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    title.style:SetAlign(ALIGN_LEFT)
  end
  CreateContentFrame("moneySetFrame", locale.housing.sell.titlePriceSet, 50)
  window.moneySetFrame:AddAnchor("TOP", window, 0, titleMargin)
  local moneyEditsWindow
  if F_MONEY.currency.houseSale == CURRENCY_AA_POINT then
    moneyEditsWindow = W_MONEY.CreateAAPointEditsWindow(window:GetId() .. ".moneyEditsWindow", window)
  else
    moneyEditsWindow = W_MONEY.CreateMoneyEditsWindow(window:GetId() .. ".moneyEditsWindow", window)
  end
  moneyEditsWindow:AddAnchor("BOTTOMLEFT", window.moneySetFrame, 5, -3)
  moneyEditsWindow.goldEdit:SetWidth(170)
  moneyEditsWindow.silverEdit:SetWidth(65)
  moneyEditsWindow.copperEdit:SetWidth(65)
  window.moneyEditsWindow = moneyEditsWindow
  CreateContentFrame("itemSetFrame", locale.housing.sell.titleNeedItemSet, 80)
  window.itemSetFrame:AddAnchor("TOP", window.moneySetFrame, "BOTTOM", 0, sideMargin)
  local tip = window:CreateChildWidget("label", "tip", 0, false)
  tip:SetAutoResize(true)
  tip:SetHeight(FONT_SIZE.SMALL)
  tip:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "house_sell_guide"))
  tip:AddAnchor("BOTTOMLEFT", window.itemSetFrame.title, "BOTTOMRIGHT", 1, 0)
  tip.style:SetFontSize(FONT_SIZE.SMALL)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  local bg = CreateContentBackground(window.itemSetFrame, "TYPE2", "brown")
  bg:AddAnchor("BOTTOMRIGHT", window.itemSetFrame, 5, 5)
  bg:AddAnchor("TOPLEFT", window.itemSetFrame, -5, -5)
  local sellNeedItem = CreateItemIconButton(window:GetId() .. ".itemButton", window)
  sellNeedItem:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
  sellNeedItem:AddAnchor("BOTTOMLEFT", window.itemSetFrame, 5, -5)
  window.sellNeedItem = sellNeedItem
  local itemName = window:CreateChildWidget("label", "itemName", 0, true)
  itemName:SetAutoResize(true)
  itemName:SetHeight(FONT_SIZE.MIDDLE)
  itemName:AddAnchor("LEFT", sellNeedItem, "RIGHT", 5, -7)
  ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
  local itemState = window:CreateChildWidget("textbox", "itemState", 0, true)
  itemState:SetExtent(250, FONT_SIZE.MIDDLE)
  itemState:SetText("0/0")
  itemState:AddAnchor("TOPLEFT", itemName, "BOTTOMLEFT", 1, 2)
  itemState.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(itemState, FONT_COLOR.DEFAULT)
  local chkregistration = CreateCheckButton("chk", window, GetUIText(HOUSING_TEXT, "setreghouse"))
  chkregistration:AddAnchor("BOTTOMLEFT", window.itemSetFrame, 0, sideMargin + 10)
  chkregistration.textButton.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.MIDDLE)
  chkregistration.textButton:SetAutoResize(true)
  chkregistration:SetChecked(true)
  window.chkregistration = chkregistration
  function chkregistration:CheckBtnCheckChagnedProc(checked)
    if checked then
    else
    end
  end
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("BOTTOMRIGHT", window.itemSetFrame, 0, 30)
  local function OnEnterGuide()
    SetTooltip(GetUIText(HOUSING_TEXT, "guidereghouse"), guide)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local OnLeaveGuide = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeaveGuide)
  CreateContentFrame("targetSetFrame", locale.housing.sell.titleTargetSet, 80)
  window.targetSetFrame:AddAnchor("TOPLEFT", window.chkregistration, "BOTTOM", -10, 0)
  local checkButtonTexts = {
    {
      text = X2Locale:LocalizeUiText(INVEN_TEXT, "allTab"),
      value = 1
    },
    {
      text = X2Locale:LocalizeUiText(HOUSING_TEXT, "target_designate"),
      value = 2
    }
  }
  local checkBoxes = CreateRadioGroup(window:GetId() .. ".checkBoxes", window.targetSetFrame, "horizen")
  checkBoxes:SetWidth(window.targetSetFrame:GetWidth())
  checkBoxes:AddAnchor("TOPLEFT", window.targetSetFrame, 5, 30)
  checkBoxes:SetData(checkButtonTexts)
  window.checkBoxes = checkBoxes
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local nameEditbox = W_CTRL.CreateEdit("nameEditbox", window)
  nameEditbox:AddAnchor("BOTTOMLEFT", window.targetSetFrame, 5, 0)
  nameEditbox:SetExtent(308, DEFAULT_SIZE.EDIT_HEIGHT)
  nameEditbox:SetMaxTextLength(namePolicyInfo.max)
  nameEditbox:CreateGuideText(locale.housing.sell.editGuide, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local warningTexts = window:CreateChildWidget("textbox", "warningTexts", 0, false)
  warningTexts:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  warningTexts:SetText(locale.housing.sell.warning_belong_furniture)
  warningTexts:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 20)
  warningTexts:SetHeight(warningTexts:GetTextHeight())
  warningTexts:AddAnchor("TOPLEFT", nameEditbox, "BOTTOMLEFT", 0, sideMargin / 1.9)
  ApplyTextColor(warningTexts, FONT_COLOR.RED)
  local registerButton = window:CreateChildWidget("button", "registerButton", 0, true)
  registerButton:SetText(locale.housing.sell.register)
  registerButton:AddAnchor("BOTTOMLEFT", window, window:GetWidth() / 2 - 84, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(registerButton, BUTTON_BASIC.DEFAULT)
  local registerCancelButton = window:CreateChildWidget("button", "registerCancelButton", 0, true)
  registerCancelButton:SetText(locale.housing.sell.cancel)
  registerCancelButton:AddAnchor("BOTTOMLEFT", registerButton, "BOTTOMRIGHT", 0, 0)
  ApplyButtonSkin(registerCancelButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {registerButton, registerCancelButton}
  AdjustBtnLongestTextWidth(buttonTable)
  function window:SetWindowHeight()
    local height = titleMargin + window.moneySetFrame:GetHeight() + window.itemSetFrame:GetHeight() + window.targetSetFrame:GetHeight() + warningTexts:GetHeight() + registerCancelButton:GetHeight() + chkregistration:GetHeight()
    height = height + sideMargin * 4
    self:SetHeight(height)
  end
  window:SetWindowHeight()
  return window
end
function CreateSellRegisterWindow(id, parent)
  local window = SetViewOfSellRegisterWindow(id, parent)
  window.sellAbleCondition = false
  local moneyEditsWindow = window.moneyEditsWindow
  local nameEditbox = window.nameEditbox
  local checkBoxes = window.checkBoxes
  local checkIndex = 1
  local function CheckSellAble()
    local sellInfos = X2House:GetHouseSaleInfo()
    if sellInfos.onSale then
      return false
    end
    local gold = moneyEditsWindow.goldEdit:GetText()
    local silver = moneyEditsWindow.silverEdit:GetText()
    local copper = moneyEditsWindow.copperEdit:GetText()
    local needItemInfos = X2House:GetHouseSaleItemInfo(gold, silver, copper)
    if needItemInfos.hasCount < needItemInfos.needCount then
      return false
    end
    if gold == "0" and silver == "0" and copper == "0" or gold == "" and silver == "" and copper == "" then
      return false
    end
    if checkBoxes:GetChecked() == 1 then
      return true
    end
    if checkBoxes:GetChecked() == 2 and nameEditbox:GetText() == "" then
      return false
    end
    return X2Util:IsValidName(nameEditbox:GetText(), VNT_CHAR)
  end
  local function OnRadioChanged(self, index)
    if index == 1 then
      nameEditbox:Enable(false)
      nameEditbox:SetAlpha(0.3)
    elseif index == 2 then
      nameEditbox:Enable(true)
      nameEditbox:SetAlpha(1)
    end
    window.registerButton:Enable(CheckSellAble())
    window.chkregistration:Enable(index == 1 and CheckSellAble())
  end
  checkBoxes:SetHandler("OnRadioChanged", OnRadioChanged)
  checkBoxes:Check(1, true)
  local function SetNeedItemState(gold, silver, copper)
    local needItemInfos = X2House:GetHouseSaleItemInfo(gold, silver, copper)
    local str = ""
    if needItemInfos.hasCount < needItemInfos.needCount then
      str = string.format("%s|,%d;|r/|,%d;", FONT_COLOR_HEX.RED, needItemInfos.hasCount, needItemInfos.needCount)
    elseif needItemInfos.hasCount > needItemInfos.needCount then
      str = string.format("%s|,%d;|r/|,%d;", FONT_COLOR_HEX.BLUE, needItemInfos.hasCount, needItemInfos.needCount)
    else
      str = string.format("|,%d;/|,%d;", needItemInfos.hasCount, needItemInfos.needCount)
    end
    window.itemState:SetText(str)
  end
  function window:ShowProc()
    local needItemInfos = X2House:GetHouseSaleItemInfo("0", "0", "0")
    local itemInfo = X2Item:GetItemInfoByType(needItemInfos.itemType)
    window.sellNeedItem:SetItemInfo(itemInfo)
    window.itemName:SetText(itemInfo.name)
    window.registerButton:Enable(false)
    window.chkregistration:Enable(false)
    window.itemState:SetText("0/0")
    local sellInfos = X2House:GetHouseSaleInfo()
    if not sellInfos.onSale then
      moneyEditsWindow:SetAmountStr("0")
      window.registerCancelButton:Enable(false)
      SetNeedItemState("0", "0", "0")
      return
    end
    SetNeedItemState(sellInfos.gold, sellInfos.silver, sellInfos.copper)
    moneyEditsWindow:SetAmountStr(sellInfos.price)
    if sellInfos.targetName == nil then
      checkBoxes:Check(1)
    else
      checkBoxes:Check(2)
      nameEditbox:SetText(sellInfos.targetName)
    end
    window.chkregistration:SetChecked(sellInfos.ispublic)
  end
  function moneyEditsWindow:MoneyEditProc()
    local gold = self.goldEdit:GetText()
    local silver = self.silverEdit:GetText()
    local copper = self.copperEdit:GetText()
    SetNeedItemState(gold, silver, copper)
    window.registerButton:Enable(CheckSellAble())
    window.chkregistration:Enable(checkBoxes:GetChecked() == 1 and CheckSellAble())
  end
  function nameEditbox:TextChangedFunc()
    nameEditbox:CheckNamePolicy(VNT_CHAR)
    window.registerButton:Enable(CheckSellAble())
    window.chkregistration:Enable(checkBoxes:GetChecked() == 1 and CheckSellAble())
  end
  local function LeftButtonClickFuncRegisterCancelButton()
    local DialogHandler = function(wnd)
      wnd:SetTitle(GetUIText(HOUSING_TEXT, "sell_cancel"))
      wnd:SetContent(GetUIText(HOUSING_TEXT, "sellconfirm"))
      function wnd:OkProc()
        X2House:CancelHouseForSale()
        wnd:Show(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetParent():GetId())
  end
  ButtonOnClickHandler(window.registerCancelButton, LeftButtonClickFuncRegisterCancelButton)
  local function LeftButtonClickFuncRegisterButton()
    local gold = moneyEditsWindow.goldEdit:GetText()
    local silver = moneyEditsWindow.silverEdit:GetText()
    local copper = moneyEditsWindow.copperEdit:GetText()
    local name = ""
    if checkBoxes:GetChecked() == 2 then
      name = nameEditbox:GetText()
    end
    X2House:SetHouseForSale(gold, silver, copper, name, checkBoxes:GetChecked() == 1 and window.chkregistration:GetChecked())
  end
  ButtonOnClickHandler(window.registerButton, LeftButtonClickFuncRegisterButton)
  return window
end
