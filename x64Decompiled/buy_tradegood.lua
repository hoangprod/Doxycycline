BUY_WINDOW_WIDTH = 680
BUY_WINDOW_HEIGHT = 524
RECIPE_WINDOW_WIDTH = 600
RECIPE_WINDOW_HEIGHT = 467
CONFIRM_WINDOW_WIDTH = 430
CONFIRM_WINDOW_HEIGHT = 442
local CreateTradegoodBuyConfirmWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(CONFIRM_WINDOW_WIDTH, CONFIRM_WINDOW_HEIGHT)
  window:SetTitle(X2Locale:LocalizeUiText(STORE_TEXT, "buyAll"))
  local content = window:CreateChildWidget("textbox", "content", 0, true)
  content:SetWidth(371)
  content:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  content:SetAutoResize(true)
  content:SetAutoWordwrap(true)
  content.style:SetFontSize(FONT_SIZE.MIDDLE)
  content.style:SetAlign(ALIGN_CENTER)
  content:SetText(GetCommonText("buy_backpack_ask_buy_tradegoods"))
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local contentFront = window:CreateChildWidget("emptywidget", id .. ".contentFront", 0, true)
  contentFront:SetExtent(401, 265)
  contentFront:AddAnchor("TOP", content, "BOTTOM", 0, 10)
  local contentBg = contentFront:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  contentBg:SetTextureColor("default")
  contentBg:AddAnchor("TOPLEFT", contentFront, 0, 0)
  contentBg:AddAnchor("BOTTOMRIGHT", contentFront, 0, 0)
  local itemButton = CreateItemIconButton(id .. ".itemButton", contentFront)
  itemButton:AddAnchor("TOP", contentBg, 0, 15)
  itemButton:Raise()
  window.itemButton = itemButton
  local itemName = contentFront:CreateChildWidget("label", "itemName", 0, true)
  itemName:SetExtent(371, 13)
  itemName:AddAnchor("TOP", itemButton, "BOTTOM", 0, 14)
  itemName.style:SetFontSize(FONT_SIZE.MIDDLE)
  itemName.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(itemName, F_COLOR.GetColor("beige"))
  window.itemName = itemName
  local priceFront = window:CreateChildWidget("emptywidget", id .. ".priceFront", 0, true)
  priceFront:AddAnchor("TOP", itemName, "BOTTOM", 0, 15)
  priceFront:SetExtent(381, 36)
  local priceBg = priceFront:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  priceBg:SetTextureColor("alpha40")
  priceBg:AddAnchor("TOPLEFT", priceFront, 0, 0)
  priceBg:AddAnchor("BOTTOMRIGHT", priceFront, 0, 0)
  local basicPriceLabel = window:CreateChildWidget("label", id .. ".basicPriceLabel", 0, true)
  basicPriceLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  basicPriceLabel.style:SetAlign(ALIGN_LEFT)
  basicPriceLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  basicPriceLabel:AddAnchor("LEFT", priceBg, 15, 0)
  basicPriceLabel:SetText(GetCommonText("default_price"))
  ApplyTextColor(basicPriceLabel, FONT_COLOR.DEFAULT)
  local basicPrice = window:CreateChildWidget("textbox", id .. "basicPrice", 0, true)
  basicPrice:AddAnchor("RIGHT", priceBg, -10, 0)
  basicPrice.style:SetAlign(ALIGN_RIGHT)
  basicPrice.style:SetFontSize(FONT_SIZE.MIDDLE)
  basicPrice:SetExtent(160, FONT_SIZE.MIDDLE)
  ApplyTextColor(basicPrice, F_COLOR.GetColor("blue"))
  window.basicPrice = basicPrice
  local calcFront = window:CreateChildWidget("emptywidget", id .. ".calcFront", 0, true)
  calcFront:SetExtent(381, 92)
  calcFront:AddAnchor("TOP", priceBg, "BOTTOM", 0, 0)
  local calcBg = calcFront:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  calcBg:SetTextureColor("alpha40")
  calcBg:AddAnchor("TOPLEFT", calcFront, 0, 0)
  calcBg:AddAnchor("BOTTOMRIGHT", calcFront, 0, 0)
  local supplyPriceLabel = calcFront:CreateChildWidget("label", id .. ".supplyPriceLabel", 0, true)
  supplyPriceLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  supplyPriceLabel.style:SetAlign(ALIGN_LEFT)
  supplyPriceLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  supplyPriceLabel:AddAnchor("TOPLEFT", calcBg, 15, 13)
  supplyPriceLabel:SetText(GetCommonText("supply_apply"))
  ApplyTextColor(supplyPriceLabel, FONT_COLOR.DEFAULT)
  local supplyPrice = calcFront:CreateChildWidget("label", id .. ".supplyPrice", 0, true)
  supplyPrice:SetExtent(160, FONT_SIZE.MIDDLE)
  supplyPrice.style:SetAlign(ALIGN_RIGHT)
  supplyPrice.style:SetFontSize(FONT_SIZE.MIDDLE)
  supplyPrice:AddAnchor("TOPRIGHT", calcBg, -12, 13)
  ApplyTextColor(supplyPrice, F_COLOR.GetColor("blue"))
  window.supplyPrice = supplyPrice
  local supplyIcon = calcFront:CreateImageDrawable(TEXTURE_PATH.INGAME_SHOP, "overlay")
  supplyIcon:Show(false)
  window.supplyIcon = supplyIcon
  local addPriceLabel = calcFront:CreateChildWidget("label", id .. ".addPriceLabel", 0, true)
  addPriceLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  addPriceLabel.style:SetAlign(ALIGN_LEFT)
  addPriceLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  addPriceLabel:AddAnchor("TOPLEFT", supplyPriceLabel, "BOTTOMLEFT", 0, 6)
  addPriceLabel:SetText(GetCommonText("additional_calc"))
  ApplyTextColor(addPriceLabel, FONT_COLOR.DEFAULT)
  local guide = W_ICON.CreateGuideIconWidget(calcFront)
  guide:AddAnchor("LEFT", addPriceLabel, addPriceLabel.style:GetTextWidth(GetCommonText("additional_calc")) + 3, 0)
  local GuideOnLeave = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", GuideOnLeave)
  window.guide = guide
  local addPrice = calcFront:CreateChildWidget("label", id .. ".addPrice", 0, true)
  addPrice:SetExtent(160, FONT_SIZE.MIDDLE)
  addPrice.style:SetAlign(ALIGN_RIGHT)
  addPrice.style:SetFontSize(FONT_SIZE.MIDDLE)
  addPrice:AddAnchor("TOPRIGHT", supplyPrice, "BOTTOMRIGHT", 0, 6)
  ApplyTextColor(addPrice, F_COLOR.GetColor("blue"))
  window.addPrice = addPrice
  local line = CreateLine(calcFront, "TYPE1")
  line:AddAnchor("LEFT", calcBg, 5, 0)
  line:AddAnchor("RIGHT", calcBg, -5, 0)
  line:AddAnchor("TOP", addPriceLabel, "BOTTOM", 0, 7)
  local calcPriceLabel = calcFront:CreateChildWidget("label", id .. ".calcPriceLabel", 0, true)
  calcPriceLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  calcPriceLabel.style:SetAlign(ALIGN_LEFT)
  calcPriceLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  calcPriceLabel:AddAnchor("TOPLEFT", addPriceLabel, "BOTTOMLEFT", 0, 16)
  calcPriceLabel:SetText(GetCommonText("apply_total"))
  ApplyTextColor(calcPriceLabel, FONT_COLOR.DEFAULT)
  local calcPrice = calcFront:CreateChildWidget("label", id .. ".calcPrice", 0, true)
  calcPrice:SetExtent(160, FONT_SIZE.MIDDLE)
  calcPrice.style:SetAlign(ALIGN_RIGHT)
  calcPrice.style:SetFontSize(FONT_SIZE.MIDDLE)
  calcPrice:AddAnchor("TOPRIGHT", addPrice, "BOTTOMRIGHT", 0, 16)
  ApplyTextColor(calcPrice, F_COLOR.GetColor("blue"))
  window.calcPrice = calcPrice
  local finalPriceLabel = contentFront:CreateChildWidget("label", id .. ".finalPriceLabel", 0, true)
  finalPriceLabel:SetExtent(180, FONT_SIZE.LARGE)
  finalPriceLabel.style:SetAlign(ALIGN_LEFT)
  finalPriceLabel.style:SetFontSize(FONT_SIZE.LARGE)
  finalPriceLabel:AddAnchor("LEFT", contentBg, 25, 0)
  finalPriceLabel:AddAnchor("TOP", calcBg, "BOTTOM", 0, 7)
  finalPriceLabel:SetText(GetCommonText("total_price"))
  ApplyTextColor(finalPriceLabel, FONT_COLOR.DEFAULT)
  local finalPrice = window:CreateChildWidget("textbox", id .. "finalPrice", 0, true)
  finalPrice:AddAnchor("RIGHT", window, -20 - MARGIN.WINDOW_SIDE, 0)
  finalPrice:AddAnchor("TOP", calcBg, "BOTTOM", 0, 8)
  finalPrice.style:SetAlign(ALIGN_RIGHT)
  finalPrice.style:SetFontSize(FONT_SIZE.MIDDLE)
  finalPrice:SetExtent(160, FONT_SIZE.MIDDLE)
  ApplyTextColor(finalPrice, F_COLOR.GetColor("blue"))
  window.finalPrice = finalPrice
  local laborWarning = window:CreateChildWidget("textbox", "laborWarning", 0, true)
  laborWarning:SetWidth(371)
  laborWarning:AddAnchor("TOP", contentBg, "BOTTOM", 0, 13)
  laborWarning.style:SetFontSize(FONT_SIZE.MIDDLE)
  laborWarning.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(laborWarning, F_COLOR.GetColor("red"))
  window.laborWarning = laborWarning
  local info = {buttonBottomInset = -30}
  CreateWindowDefaultTextButtonSet(window, info)
  function window:SetInfo(refund)
    if self.itemType == nil then
      return
    end
    local itemInfo = X2Item:GetItemInfoByType(self.itemType)
    local skillInfo = X2Store:GetBackPackBuySkillSpent(itemInfo.backpackType)
    local contentText = X2Locale:LocalizeUiText(COMMON_TEXT, "tradegood_buy_popup", tostring(skillInfo.consumeLp))
    self.laborWarning:SetText(contentText)
    if itemInfo ~= nil then
      self.itemButton:Init()
      self.itemButton:SetItemInfo(itemInfo)
      local printName = string.format("[%s]", itemInfo.name)
      self.itemName:SetText(printName)
    end
    local confirmContent = X2Store:GetSpecialtyBuyConfirmContent(self.itemType)
    if confirmContent ~= nil then
      local basePrice = 0
      if confirmContent.basePrice ~= nil then
        basePrice = confirmContent.basePrice
      end
      self.basicPrice:SetText(string.format("|m%i;", tonumber(basePrice)))
      self.finalPrice:SetText(string.format("|m%i;", tonumber(confirmContent.finalPrice)))
      if confirmContent.supply ~= nil then
        local supplyText = string.format("%s(%d%%)", confirmContent.supply.label, confirmContent.supply.priceIndex / 10)
        self.supplyPrice:SetText(supplyText)
        local path = confirmContent.supply.iconPath
        if string.sub(confirmContent.supply.iconPath, 1, 6) == "\\Game\\" then
          path = string.sub(confirmContent.supply.iconPath, 7, -1)
        end
        self.supplyIcon:SetTexture(path)
        self.supplyIcon:SetTextureInfo(confirmContent.supply.iconCoord)
        self.supplyIcon:RemoveAllAnchors()
        self.supplyIcon:AddAnchor("RIGHT", self.supplyPrice, -self.supplyPrice.style:GetTextWidth(supplyText) - 5, 0)
        self.supplyIcon:Show(true)
      else
        self.supplyIcon:Show(false)
      end
      local ratioTotal = confirmContent.supply.priceIndex / 10
      if confirmContent.events ~= nil then
        local eventTotal = 100
        for i = 1, #confirmContent.events do
          eventTotal = eventTotal * confirmContent.events[i] / 1000
        end
        self.addPrice:SetText(string.format("%d%%", eventTotal))
        local calcTotal = eventTotal * confirmContent.supply.priceIndex / 1000
        self.calcPrice:SetText(string.format("%d%%", calcTotal))
        self.guide:ReleaseHandler("OnEnter")
        local GuideOnEnter = function(self)
          local guideText = string.format([[
%s
- %s]], GetCommonText("additional_calc_list"), GetCommonText("event"))
          SetTooltip(guideText, self)
        end
        self.guide:SetHandler("OnEnter", GuideOnEnter)
      else
        self.addPrice:SetText("-")
        self.calcPrice:SetText(string.format("%d%%", confirmContent.supply.priceIndex / 10))
        self.guide:ReleaseHandler("OnEnter")
        local GuideOnEnter = function(self)
          local guideText = string.format([[
%s
- %s]], GetCommonText("additional_calc_list"), GetCommonText("additional_calc_none"))
          SetTooltip(guideText, self)
        end
        self.guide:SetHandler("OnEnter", GuideOnEnter)
      end
    end
    local height
    height = CONFIRM_WINDOW_HEIGHT + content:GetHeight() - FONT_SIZE.MIDDLE
    window:SetHeight(height)
    window:Show(true)
  end
  local function LeftButtonClickFunc()
    X2Store:BuyBackPackGoods(window.itemType)
    window:Show(false)
    ToggleBuyTradegoodInfo(false)
  end
  ButtonOnClickHandler(window.leftButton, LeftButtonClickFunc)
  local function RightButtonClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(window.rightButton, RightButtonClickFunc)
  return window
end
local CreateTradegoodRecipeWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(RECIPE_WINDOW_WIDTH, RECIPE_WINDOW_HEIGHT)
  window:SetTitle(GetCommonText("tradegood_produce_info"))
  local categoryList = W_CTRL.CreateScrollListBox("categoryList", window, window)
  categoryList:SetExtent(201, 325)
  categoryList:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE + 15)
  categoryList.content:EnableSelectParent(false)
  categoryList.content:EnableScroll(false)
  categoryList.scroll:Show(false)
  window.categoryList = categoryList
  categoryList:SetTreeImage()
  local label = window:CreateChildWidget("label", id, 0, true)
  label:SetExtent(560, FONT_SIZE.MIDDLE)
  label.style:SetAlign(ALIGN_LEFT)
  label:AddAnchor("TOPLEFT", categoryList, "BOTTOMLEFT", 0, 50)
  label.style:SetFontSize(FONT_SIZE.MIDDLE)
  label:SetText(GetCommonText("tradegood_produce_info_content"))
  ApplyTextColor(label, F_COLOR.GetColor("off_gray"))
  function window:UpdateList(list)
    local categories = X2Store:GetBackPackGoodCategories()
    local categoryTable = {}
    for i = 1, #categories - 1 do
      categoryTable[i] = {}
      categoryTable[i].text = categories[i + 1].name
      categoryTable[i].key = categories[i + 1].key
      categoryTable[i].child = {}
      categoryTable[i].numChild = 0
    end
    for i = 1, #list do
      for j = 1, #categoryTable do
        if categoryTable[j].key == list[i].category then
          local index = #categoryTable[j].child + 1
          categoryTable[j].child[index] = {}
          local subTable = categoryTable[j].child[index]
          subTable.text = list[i].item.name
          subTable.value = i
        end
      end
    end
    categoryList:SetItemTrees(categoryTable)
    categoryList.list = list
    self:UpdateSubList({})
  end
  function categoryList:OnSelChanged()
    local index = self:GetSelectedIndex()
    if index == 0 or index == -1 then
      return
    end
    local value = self:GetSelectedValue()
    if value == 0 then
      return
    end
    window:UpdateSubList(categoryList.list[value].child)
  end
  local listInfos = {
    width = 355,
    height = 338,
    columnHeight = 30,
    rows = 7,
    columns = {
      {
        name = GetCommonText("specialty_factions"),
        width = 265,
        colType = LCCIT_TEXTBOX,
        func = LISTFRAME.ICON,
        useSort = true
      },
      {
        name = GetCommonText("need_count"),
        width = 90,
        colType = LCCIT_STRING,
        func = LISTFRAME.NORMAL_FORMATTED_NUMBER,
        useSort = true
      }
    }
  }
  local contents = CreateListFrame("contents", window, listInfos)
  window.contents:AddAnchor("TOPLEFT", categoryList, "TOPRIGHT", 4, -15)
  window.contents = contents
  function window:UpdateSubList(list)
    contents:DeleteAllDatas()
    contents:UpdatePage(#list, listInfos.rows)
    for i = 1, #list do
      contents:InsertData(i, 1, list[i])
      contents:InsertData(i, 2, LISTFRAME.ConvertNumberUiText(COMMON_TEXT, "amount", tostring(list[i].count)))
    end
    for i = 1, #contents.listCtrl.items do
      local item = contents.listCtrl.items[i]
      if item.line ~= nil then
        item.line:SetVisible(true)
      end
    end
  end
  return window
end
local function CreateBuyTradegoodWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(BUY_WINDOW_WIDTH, BUY_WINDOW_HEIGHT)
  window:SetTitle(GetCommonText("tradegood_buy_title"))
  local clearButton = window:CreateChildWidget("button", "clearButton", 0, true)
  clearButton:SetText(locale.auction.searchConditionInit)
  clearButton:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  ApplyButtonSkin(clearButton, BUTTON_BASIC.DEFAULT)
  local categoryFilter = W_CTRL.CreateComboBox("categoryFilter", window)
  categoryFilter:SetWidth(148)
  categoryFilter:SetEllipsis(true)
  categoryFilter:ShowDropdownTooltip(true)
  categoryFilter:AddAnchor("LEFT", clearButton, "RIGHT", 19, 0)
  local nameEdit = W_CTRL.CreateEdit("nameEdit", window)
  nameEdit:AddAnchor("LEFT", categoryFilter, "RIGHT", 4, 0)
  nameEdit:SetExtent(290, DEFAULT_SIZE.EDIT_HEIGHT)
  nameEdit:SetMaxTextLength(150)
  nameEdit:CreateGuideText(locale.auction.guideText, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local searchButton = window:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:SetText(GetCommonText("search"))
  searchButton:AddAnchor("LEFT", nameEdit, "RIGHT", 6, 0)
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  local categoryIdx = 0
  function categoryFilter:FillContent()
    local categories = X2Store:GetBackPackGoodCategories()
    local datas = {}
    for i = 1, #categories do
      local data = {
        value = categories[i].key
      }
      if data.value == 0 or not categories[i].name then
      end
      data.text = GetCommonText("all")
      table.insert(datas, data)
    end
    self:AppendItems(datas)
  end
  categoryFilter:FillContent()
  function categoryFilter:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    categoryIdx = info.value
  end
  function searchButton:OnClick()
    window:ButtonsEnable(false)
    X2Store:ListBackPackGoods(categoryIdx, nameEdit:GetText())
  end
  searchButton:SetHandler("OnClick", searchButton.OnClick)
  function clearButton:OnClick()
    categoryFilter:Select(1)
    nameEdit:SetText("")
    searchButton:OnClick()
  end
  clearButton:SetHandler("OnClick", clearButton.OnClick)
  local listInfos = {
    width = 640,
    height = 338,
    columnHeight = 30,
    rows = 7,
    columns = {
      {
        name = GetCommonText("name"),
        width = 260,
        colType = LCCIT_TEXTBOX,
        func = LISTFRAME.ITEM,
        useSort = true
      },
      {
        name = GetCommonText("supply_condition"),
        width = 195,
        colType = LCCIT_TEXTBOX,
        func = LISTFRAME.SUPPLY,
        useSort = true
      },
      {
        name = GetCommonText("amount_of_money"),
        width = 185,
        colType = LCCIT_WINDOW,
        func = LISTFRAME.MONEY_WITH_BUY_ICON,
        useSort = true
      }
    }
  }
  local contents = CreateListFrame("contents", window, listInfos)
  window.contents:AddAnchor("TOPLEFT", clearButton, "BOTTOMLEFT", 0, 7)
  window.contents = contents
  local refreshButton = window:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:AddAnchor("TOPRIGHT", contents.listCtrl, "BOTTOMRIGHT", -7, 7)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  function refreshButton:OnUpdate(dt)
    local timediff = X2Store:ListBackPackGoodsCooldown()
    local GetPeriod = function(seconds)
      if seconds == nil then
        return ""
      end
      local MIN = 60
      dateFormat = {}
      dateFormat.year = 0
      dateFormat.month = 0
      dateFormat.day = 0
      dateFormat.hour = 0
      dateFormat.minute = math.floor(seconds / MIN)
      if 0 < dateFormat.minute then
        seconds = seconds - dateFormat.minute * MIN or seconds
      end
      dateFormat.second = seconds
      local remainTimeString = locale.time.GetRemainDateToDateFormat(dateFormat, DEFAULT_FORMAT_FILTER + FORMAT_FILTER.SECOND)
      return remainTimeString
    end
    if timediff < 0 then
      self:Enable(true)
      self:ReleaseHandler("OnEnter")
    else
      self:Enable(false)
      local function OnEnter(self)
        SetTooltip(GetUIText(COMMON_TEXT, "not_yet_report_spammer", GetPeriod(timediff + 1)), self)
      end
      self:SetHandler("OnEnter", OnEnter)
      local OnLeave = function(self)
        HideTooltip()
      end
      self:SetHandler("OnLeave", OnLeave)
    end
  end
  refreshButton:SetHandler("OnUpdate", refreshButton.OnUpdate)
  refreshButton:SetHandler("OnClick", searchButton.OnClick)
  local money = W_MODULE:CreateFundInHand("money", window, CURRENCY_GOLD)
  money:AddAnchor("TOPLEFT", contents.listCtrl, "BOTTOMLEFT", 0, 50)
  window.money = money
  local produceInfoButton = window:CreateChildWidget("button", "produceInfoButton", 0, true)
  produceInfoButton:SetText(GetCommonText("produce_info"))
  produceInfoButton:AddAnchor("BOTTOMRIGHT", window, -MARGIN.WINDOW_SIDE - 7, -20)
  ApplyButtonSkin(produceInfoButton, BUTTON_BASIC.DEFAULT)
  function produceInfoButton:OnClick()
    window.recipeWin:UpdateSubList({})
    window.recipeWin:Show(true)
    X2Store:GetBackPackGoodRecipes()
  end
  produceInfoButton:SetHandler("OnClick", produceInfoButton.OnClick)
  function window:ButtonsEnable(enable)
    clearButton:Enable(enable)
    searchButton:Enable(enable)
    produceInfoButton:Enable(enable)
  end
  function window:UpdateList(list)
    contents:DeleteAllDatas()
    contents:UpdatePage(#list, listInfos.rows)
    for i = 1, #list do
      contents:InsertData(i, 1, list[i].item)
      list[i].supply.count = list[i].stock
      contents:InsertData(i, 2, list[i].supply)
      local buyIconData = {}
      buyIconData.refund = list[i].refund
      buyIconData.noEventRefund = list[i].noEventRefund
      buyIconData.amount = list[i].stock
      buyIconData.itemType = list[i].item.itemType
      if list[i].tooltip ~= nil then
        buyIconData.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "specialty_buy_price_change_tooltip_title", table.concat(list[i].tooltip, "\n"))
      end
      if tonumber(list[i].noEventRefund) > 0 then
        list[i].item.event = true
      end
      contents:InsertData(i, 3, buyIconData)
    end
    for i = 1, #contents.listCtrl.items do
      local item = contents.listCtrl.items[i]
      if item.line ~= nil then
        item.line:SetVisible(true)
      end
    end
    self:ButtonsEnable(true)
  end
  function window:Init()
    self:UpdateList({})
    clearButton:OnClick()
  end
  local recipeWin = CreateTradegoodRecipeWindow("recipeWin", window)
  recipeWin:AddAnchor("CENTER", window, 0, 0)
  recipeWin:Show(false)
  window.recipeWin = recipeWin
  local confirmWin = CreateTradegoodBuyConfirmWindow("buyConfirmWindow", window)
  confirmWin:AddAnchor("CENTER", window, 0, 0)
  confirmWin:Show(false)
  window.confirmWin = confirmWin
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("RIGHT", window.titleBar.closeButton, "BOTTOM", -15, -24)
  local GuideOnEnter = function(self)
    local guideTitle = GetCommonText("supply_ratio_range")
    local guideBody = ""
    local data = X2Store:GetSpecialtyBuyRatioRangeTooltip()
    for i = 1, #data do
      if tonumber(data[i].min) == tonumber(data[i].max) then
        guideBody = guideBody .. string.format("%s: %d%%\n", data[i].name, math.floor(tonumber(data[i].min) / 10))
      else
        guideBody = guideBody .. string.format("%s: %d~%d%%\n", data[i].name, math.floor(tonumber(data[i].min) / 10), math.floor(tonumber(data[i].max) / 10))
      end
    end
    SetTooltip(string.format([[
%s
%s]], guideTitle, guideBody), self)
  end
  guide:SetHandler("OnEnter", GuideOnEnter)
  local GuideOnLeave = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", GuideOnLeave)
  function window:OnHide()
    window.recipeWin:Show(false)
    window.confirmWin:Show(false)
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
local buyTradegoodWnd = CreateBuyTradegoodWindow("buyTradegoodWnd", "UIParent")
buyTradegoodWnd:AddAnchor("CENTER", "UIParent", 0, 0)
function ToggleBuyTradegoodInfo(show)
  if show == nil then
    show = not buyTradegoodWnd:IsVisible()
  end
  buyTradegoodWnd:Show(show)
  if show then
    buyTradegoodWnd:Init()
  end
end
ADDON:RegisterContentTriggerFunc(UIC_SPECIALTY_BUY, ToggleBuyTradegoodInfo)
function SetBuyTradegoodConfirmInfo(itemType, refund)
  buyTradegoodWnd.confirmWin.itemType = itemType
  buyTradegoodWnd.confirmWin:SetInfo(refund)
  buyTradegoodWnd.confirmWin:Show(true)
end
local events = {
  BUY_SPECIALTY_CONTENT_INFO = function(list)
    if buyTradegoodWnd:IsVisible() == false then
      return
    end
    buyTradegoodWnd:UpdateList(list)
  end,
  SPECIALTY_CONTENT_RECIPE_INFO = function(list)
    if buyTradegoodWnd.recipeWin:IsVisible() == false then
      return
    end
    buyTradegoodWnd.recipeWin:UpdateList(list)
  end,
  INTERACTION_END = function()
    ToggleBuyTradegoodInfo(false)
  end,
  UPDATE_SPECIALTY_RATIO = function(refund)
    if refund == nil then
      ToggleBuyTradegoodInfo(false)
    end
  end
}
buyTradegoodWnd:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(buyTradegoodWnd, events)
