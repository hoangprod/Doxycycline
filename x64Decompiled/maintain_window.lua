local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateMaintainHousingFrame(id, parent)
  local frame = SetViewOfMaintainHousingFrame(id, parent)
  local changeNameButton = frame.changeNameButton
  local demolishImgButton = frame.demolishImgButton
  local packageDemolishImgButton = frame.packageDemolishImgButton
  local registerSellImgButton = frame.registerSellImgButton
  local registerRotateImgButton = frame.registerRotateImgButton
  local registerUccImgButton = frame.registerUccImgButton
  local rebuildButton = frame.rebuildButton
  local furnitureCheckbox = frame.furnitureCheckbox
  local warningText = frame.warningText
  local okButton = frame.okButton
  local furnitureCountGuide = frame.furnitureCount.guide
  local decoActabilityButton = frame.furnitureCount.decoActabilityButton
  local prepayButton = frame.contentTaxInfo.prepayButton
  local rebuildBtnEnable = false
  frame.decoActabilitywindow = nil
  frame.sellRegisterWindow = nil
  frame.prepayWindow = nil
  local OnEnter = function(self)
    SetTooltip(X2Locale:LocalizeUiText(HOUSING_TEXT, "furniture_lock_tip"), self)
  end
  furnitureCheckbox.textButton:SetHandler("OnEnter", OnEnter)
  local OnEnterRegisterSellImgButton = function(self)
    if self:IsEnabled() then
      SetTooltip(GetUIText(HOUSING_TEXT, "sell_set"), self)
      return
    end
    local sellInfos = X2House:GetHouseSaleInfo()
    if not sellInfos.canSell then
      SetTooltip(GetUIText(HOUSING_TEXT, "unsaleable_house"), self)
    else
      SetTooltip(GetUIText(HOUSING_TEXT, "unsaleable_house_overdue"), self)
    end
  end
  registerSellImgButton:SetHandler("OnEnter", OnEnterRegisterSellImgButton)
  local OnEnterRegisterUccImgButton = function(self)
    if self:IsEnabled() then
      SetTooltip(GetUIText(HOUSING_TEXT, "housing_ucc_tooltip"), self)
    else
      local infos = X2House:GetHousingUccInfo()
      if #infos > 0 then
        SetTooltip(GetUIText(HOUSING_TEXT, "housing_ucc_delayed_tax_tooltip"), self)
      else
        SetTooltip(GetUIText(HOUSING_TEXT, "housing_ucc_disable_tooltip"), self)
      end
    end
  end
  registerUccImgButton:SetHandler("OnEnter", OnEnterRegisterUccImgButton)
  local OnEnterRegisterRotateImgButton = function(self)
    local info, count, total = X2House:GetRequireItemInfoForRotate()
    local itemname, itemcount
    if info ~= nil then
      itemname = string.format("%s%s%s", FONT_COLOR_HEX.SOFT_YELLOW, "[" .. info.name .. "]", FONT_COLOR_HEX.SOFT_BROWN)
      if total <= count then
        itemcount = string.format("(%d/%d)", count, total)
      else
        itemcount = string.format("%s(%d/%d)%s", FONT_COLOR_HEX.ROSE_PINK, count, total, FONT_COLOR_HEX.SOFT_BROWN)
      end
    end
    if itemname ~= nil then
      if self:IsEnabled() then
        SetTooltip(string.format("%s", GetUIText(HOUSING_TEXT, "housing_can_ratete_tooltip", itemname)), self)
      else
        SetTooltip(string.format("%s", GetUIText(HOUSING_TEXT, "housing_cannot_ratete_tooltip", itemname, tostring(total), itemcount)), self)
      end
    else
      SetTooltip(GetUIText(HOUSING_TEXT, "housing_cannot_rotete_tooltip2"), self)
    end
  end
  registerRotateImgButton:SetHandler("OnEnter", OnEnterRegisterRotateImgButton)
  local OnEnterDemolishImgButton = function(self)
    if self:IsEnabled() then
      SetTooltip(GetUIText(HOUSING_TEXT, "destroy"), self)
      return
    end
    if X2House:IsCastle() then
      SetTooltip(GetUIText(ERROR_MSG, "NO_PERM"), self)
    else
      SetTooltip(GetUIText(HOUSING_TEXT, "undemolishable_house_overdue"), self)
    end
  end
  demolishImgButton:SetHandler("OnEnter", OnEnterDemolishImgButton)
  if packageDemolishImgButton ~= nil then
    local OnEnterPackageDemolishImgButton = function(self)
      if self:IsEnabled() then
        SetTooltip(GetUIText(HOUSING_TEXT, "package_demolish"), self)
        return
      end
      if X2House:CanPackageDemolish() then
        SetTooltip(GetUIText(HOUSING_TEXT, "undemolishable_house_overdue"), self)
      else
        SetTooltip(GetUIText(HOUSING_TEXT, "not_support_package_demolish"), self)
      end
    end
    packageDemolishImgButton:SetHandler("OnEnter", OnEnterPackageDemolishImgButton)
  end
  local OnEnterPrepayButton = function(self)
    if self:IsEnabled() then
      return
    end
    if self.tip == nil or self.tip == "" then
      return
    end
    SetTooltip(self.tip, self)
  end
  prepayButton:SetHandler("OnEnter", OnEnterPrepayButton)
  local function LeftClickFuncChangeNameButton()
    ShowChangeHousingName(frame)
  end
  ButtonOnClickHandler(changeNameButton, LeftClickFuncChangeNameButton)
  local LeftClickFuncRotateButton = function(self)
    local parent = self:GetParent()
    X2House:PreviewRotateHouse()
    parent:Show(false)
  end
  ButtonOnClickHandler(registerRotateImgButton, LeftClickFuncRotateButton)
  local function LeftClickFuncBuyButton()
    local DialogHandler = function(wnd, infoTable)
      local houseType = X2House:GetHouseType()
      local houseTypeName = X2House:GetHousingModelName(houseType) or ""
      local content = X2Locale:LocalizeUiText(HOUSING_TEXT, "buy_house_content", FONT_COLOR_HEX.BLUE, X2House:GetHouseOwnerName(), FONT_COLOR_HEX.BLUE, houseTypeName, FONT_COLOR_HEX.RED)
      wnd:SetTitle(X2Locale:LocalizeUiText(HOUSING_TEXT, "buy_house"))
      wnd:UpdateDialogModule("textbox", content)
      local sellInfos = X2House:GetHouseSaleInfo()
      local data = {
        type = "cost",
        currency = F_MONEY.currency.houseSale,
        value = sellInfos.price
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
      function wnd:OkProc()
        X2House:BuyHouse()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, frame:GetId())
  end
  ButtonOnClickHandler(frame.buyButton, LeftClickFuncBuyButton)
  local LeftClickFuncDemolishImgButton = function(self)
    local parent = self:GetParent()
    local function DialogHandler(wnd)
      wnd:SetExtent(353, 272)
      wnd:SetTitle(locale.housing.demolish.title)
      wnd:SetContent(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_description"))
      local cautionLabel = wnd:CreateChildWidget("label", "cautionLabel", 0, false)
      cautionLabel:SetExtent(297, FONT_SIZE.LARGE)
      cautionLabel:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_caution"))
      cautionLabel.style:SetFontSize(FONT_SIZE.LARGE)
      cautionLabel:AddAnchor("TOPLEFT", wnd.textbox, "BOTTOMLEFT", 8, 29)
      ApplyTextColor(cautionLabel, FONT_COLOR.DEFAULT)
      cautionLabel.style:SetAlign(ALIGN_LEFT)
      local cautionContent = wnd:CreateChildWidget("textbox", "cautionContent", 0, false)
      cautionContent:SetExtent(297, FONT_SIZE.MIDDLE)
      cautionContent.style:SetAlign(ALIGN_LEFT)
      cautionContent.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(cautionContent, FONT_COLOR.RED)
      cautionContent:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_caution_description"))
      cautionContent:SetHeight(cautionContent:GetTextHeight())
      cautionContent:AddAnchor("TOPLEFT", cautionLabel, "BOTTOMLEFT", 0, 8)
      local bg = CreateContentBackground(wnd, "TYPE2", "brown", "artwork")
      bg:AddAnchor("TOPLEFT", cautionLabel, -13, -14)
      bg:AddAnchor("BOTTOMRIGHT", cautionContent, 13, 14)
      wnd:RegistBottomWidget(cautionContent)
      function wnd:OkProc()
        parent:Show(false)
        X2House:Demolish(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
  end
  ButtonOnClickHandler(demolishImgButton, LeftClickFuncDemolishImgButton)
  if packageDemolishImgButton ~= nil then
    local LeftClickFuncPackageDemolishImgButton = function(self)
      local info, count, total = X2House:GetDemolishSealCount()
      if info == nil then
        return
      end
      local parent = self:GetParent()
      local function DialogHandler(wnd)
        wnd:SetExtent(353, 272)
        wnd:SetTitle(locale.housing.demolish.title)
        wnd:SetContent(X2Locale:LocalizeUiText(HOUSING_TEXT, "package_demolish_description"))
        local cautionLabel = wnd:CreateChildWidget("label", "cautionLabel", 0, false)
        cautionLabel:SetExtent(297, FONT_SIZE.LARGE)
        cautionLabel:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_caution"))
        cautionLabel.style:SetFontSize(FONT_SIZE.LARGE)
        cautionLabel:AddAnchor("TOPLEFT", wnd.textbox, "BOTTOMLEFT", 8, 29)
        ApplyTextColor(cautionLabel, FONT_COLOR.DEFAULT)
        cautionLabel.style:SetAlign(ALIGN_LEFT)
        local cautionContent = wnd:CreateChildWidget("textbox", "cautionContent", 0, false)
        cautionContent:SetExtent(297, FONT_SIZE.MIDDLE)
        cautionContent.style:SetAlign(ALIGN_LEFT)
        cautionContent.style:SetFontSize(FONT_SIZE.MIDDLE)
        ApplyTextColor(cautionContent, FONT_COLOR.RED)
        cautionContent:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_caution_description"))
        cautionContent:SetHeight(cautionContent:GetTextHeight())
        cautionContent:AddAnchor("TOPLEFT", cautionLabel, "BOTTOMLEFT", 0, 8)
        local bg = CreateContentBackground(wnd, "TYPE2", "brown", "artwork")
        bg:AddAnchor("TOPLEFT", cautionLabel, -13, -14)
        bg:AddAnchor("BOTTOMRIGHT", cautionContent, 13, 14)
        local sealIcon = CreateItemIconButton("sealIcon", wnd)
        sealIcon:AddAnchor("TOP", cautionContent, "BOTTOM", 0, 31)
        sealIcon:SetItemInfo(info)
        sealIcon:SetStack(count, total)
        local sealLabel = wnd:CreateChildWidget("textbox", "sealLabel", 0, false)
        sealLabel:SetExtent(297, FONT_SIZE.LARGE)
        sealLabel.style:SetFontSize(FONT_SIZE.LARGE)
        sealLabel:AddAnchor("TOP", sealIcon, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 1.2)
        ApplyTextColor(sealLabel, FONT_COLOR.DEFAULT)
        sealLabel.style:SetAlign(ALIGN_CENTER)
        sealLabel:SetText(info.name)
        local lineWidth = sealLabel:GetLongestLineWidth()
        local lineHeight = sealLabel:GetTextHeight()
        sealLabel:SetExtent(lineWidth + 5, lineHeight)
        local bg = CreateContentBackground(sealLabel, "TYPE7", "brown")
        bg:SetExtent(lineWidth + MARGIN.WINDOW_SIDE * 1.5, lineHeight + MARGIN.WINDOW_SIDE * 1.5)
        bg:AddAnchor("CENTER", sealLabel, 2, 2)
        wnd:RegistBottomWidget(sealLabel)
        if count < total then
          wnd.btnOk:Enable(false)
        end
        function wnd:OkProc()
          parent:Show(false)
          X2House:Demolish(true)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
    end
    ButtonOnClickHandler(packageDemolishImgButton, LeftClickFuncPackageDemolishImgButton)
  end
  local function LeftClickFuncOkButton(self)
    if frame:IsVisible() then
      frame:Show(false)
    end
  end
  ButtonOnClickHandler(okButton, LeftClickFuncOkButton)
  local function ShowDecoActabilityWindow()
    if frame.decoActabilitywindow == nil then
      frame.decoActabilitywindow = CreateDecoActabilitywindow(frame:GetId() .. ".decoActabilitywindow", frame)
      frame.decoActabilitywindow:Show(true)
    else
      frame.decoActabilitywindow:Show(false)
      return
    end
    frame.decoActabilitywindow:FillList()
    local function OnHide()
      frame.decoActabilitywindow = nil
    end
    frame.decoActabilitywindow:SetHandler("OnHide", OnHide)
  end
  ButtonOnClickHandler(decoActabilityButton, ShowDecoActabilityWindow)
  local function ShowSellRegisterWindow()
    if frame.sellRegisterWindow == nil then
      frame.sellRegisterWindow = CreateSellRegisterWindow(frame:GetId() .. ".sellRegisterWindow", frame)
      frame.sellRegisterWindow:Show(true)
      local function OnHide()
        frame.sellRegisterWindow = nil
      end
      frame.sellRegisterWindow:SetHandler("OnHide", OnHide)
    else
      frame.sellRegisterWindow:Show(false)
    end
  end
  ButtonOnClickHandler(registerSellImgButton, ShowSellRegisterWindow)
  function ShowUccRegisterWindow()
    if housing.uccRegisterWindow == nil then
      housing.uccRegisterWindow = CreateUccRegisterWindow("housing.uccRegisterWindow", "UIParent")
      housing.uccRegisterWindow:Show(true)
      if frame ~= nil and frame:IsVisible() then
        frame:Show(false)
      end
      local OnHide = function()
        housing.uccRegisterWindow:HideProc()
        housing.uccRegisterWindow = nil
      end
      housing.uccRegisterWindow:SetHandler("OnHide", OnHide)
    else
      housing.uccRegisterWindow:Show(not housing.uccRegisterWindow:IsVisible())
    end
  end
  ButtonOnClickHandler(registerUccImgButton, ShowUccRegisterWindow)
  if rebuildButton ~= nil then
    local function ShowRebuildHousingWindow()
      if housing.rebuilingWnd == nil then
        housing.rebuilingWnd = CreateRebuildHousingWnd("housing.rebuilingWnd", "UIParent")
        housing.rebuilingWnd:Show(true)
        frame:Show(false)
        X2House:RequestHousingRebuildingTaxInfo()
        local OnHide = function(self)
          if self.HideProc ~= nil then
            self:HideProc()
          end
          housing.rebuilingWnd = nil
        end
        housing.rebuilingWnd:SetHandler("OnHide", OnHide)
      else
        housing.rebuilingWnd:Show(false)
      end
    end
    ButtonOnClickHandler(rebuildButton, ShowRebuildHousingWindow)
  end
  local function ShowPrepayWindow()
    local featureSet = X2Player:GetFeatureSet()
    if not featureSet.houseTaxPrepay then
      return
    end
    local sellInfos = X2House:GetHouseSaleInfo()
    if sellInfos.onSale then
      return false
    end
    if frame.taxString == nil then
      return
    end
    local function DialogHandler(wnd, infoTable)
      wnd:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "prepay"))
      wnd:UpdateDialogModule("textbox", X2Locale:LocalizeUiText(COMMON_TEXT, "prepay_dialog_content"))
      local requireItemInfo, requireCnt = X2House:GetPrepayRequireItemInfo()
      local requireHaveCnt = X2Bag:GetCountInBag(requireItemInfo.itemType)
      if featureSet.taxItem then
        local taxItemInfo = X2House:GetTaxItem()
        local cntTable = {
          X2House:CountTaxItemInBag(),
          X2House:CountTaxItemForTax(frame.taxString)
        }
        local itemData = {itemInfo = taxItemInfo, stack = cntTable}
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
      else
        local costData = {
          type = "cost",
          value = frame.taxString
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
      end
      local prepayTimeStr = locale.time.GetDateToDateFormat(frame.prepayTime)
      local textData = {
        type = "period",
        text = GetUIText(COMMON_TEXT, "prepay_time", prepayTimeStr)
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "period", textData)
      function wnd:OkProc()
        X2House:PrepayHouseTax()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, frame:GetId())
  end
  ButtonOnClickHandler(prepayButton, ShowPrepayWindow)
  function frame:UpdateExtent_myHouse()
    local frameHeight = titleMargin + self.permissionsWindow:GetHeight() + self.contentUpper.bg:GetHeight() + okButton:GetHeight() + sideMargin
    if not X2House:IsCastle() then
      frameHeight = frameHeight + sideMargin
    else
      frameHeight = frameHeight + sideMargin / 2
    end
    if furnitureCheckbox:IsVisible() then
      frameHeight = frameHeight + furnitureCheckbox:GetHeight()
    end
    if self.warningText:IsVisible() then
      frameHeight = frameHeight + self.warningText:GetHeight() + sideMargin
    end
    self:SetExtent(housingLocale.maintainWndWidth, frameHeight)
    self:Show(true)
  end
  function frame:UpdateExtent_notMyHouse()
    local frameHeight = titleMargin + self.contentUpper.bg:GetHeight() + okButton:GetHeight() + sideMargin
    if self.warningText:IsVisible() then
      frameHeight = frameHeight + self.warningText:GetHeight() + sideMargin / 2
    end
    self:SetExtent(housingLocale.maintainWndWidth, frameHeight)
    self:Show(true)
  end
  function frame:UpdateWarningTextMyHouse(warningStr)
    if self.warningText:IsVisible() and warningStr ~= "" then
      self.warningText:SetText(warningStr)
      self.warningText:SetHeight(self.warningText:GetTextHeight())
      self.warningText:RemoveAllAnchors()
      if self.furnitureCheckbox:IsVisible() then
        self.warningText:AddAnchor("TOPLEFT", self.furnitureCheckbox, "BOTTOMLEFT", -6, sideMargin / 1.3)
      else
        self.warningText:AddAnchor("TOPLEFT", self.permissionsWindow, "BOTTOMLEFT", 0, sideMargin / 1.3)
      end
    end
  end
  function frame:UpdateWarningTextNotMyHouse(warningStr)
    if self.warningText:IsVisible() and warningStr ~= "" then
      self.warningText:SetText(warningStr)
      self.warningText:SetHeight(self.warningText:GetTextHeight())
    end
    local target = self.furnitureCount
    if self.contentTaxInfo:IsVisible() then
      target = self.contentTaxInfo
    end
    self.warningText:RemoveAllAnchors()
    self.warningText:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", 0, sideMargin)
  end
  function frame:UpdateSetSellSuccess(sellInfos)
    local warningStr = ""
    self.warningText:Show(true)
    local str = self:GetSellInfoText(sellInfos.targetName, sellInfos.price)
    warningStr = str
    self:UpdateWarningTextMyHouse(warningStr)
    self.contentTaxInfo.prepayButton:Enable(false)
    self.contentTaxInfo.prepayButton.tip = GetUIText(ERROR_MSG, "HOUSE_CANNOT_PREPAY_FOR_SALE")
  end
  function frame:UpdateCancelSellSuccess()
    self.warningText:Show(false)
    if self.isAlreadyPaid ~= nil then
      self.contentTaxInfo.prepayButton:Enable(self.isAlreadyPaid)
    else
      self.contentTaxInfo.prepayButton:Enable(false)
    end
    if self.weeksPrepay == 0 and not self.isAlreadyPaid then
      self.contentTaxInfo.prepayButton.tip = GetUIText(COMMON_TEXT, "unable_prepay_for_housing_unpaid_or_overdue")
    end
  end
  function frame:GetSellInfoText(sellTargetName, price)
    if sellTargetName == nil then
      local str = string.format([[
%s
%s%s: %s]] .. F_MONEY.currency.pipeString[F_MONEY.currency.houseSale] .. "|r", locale.housing.sell.everyoneSell, FONT_COLOR_HEX.DEFAULT, locale.housing.sell.price, FONT_COLOR_HEX.BLUE, price)
      return str
    else
      local str = string.format([[
%s
%s%s: %s]] .. F_MONEY.currency.pipeString[F_MONEY.currency.houseSale] .. "|r", locale.housing.sell.targetSell(sellTargetName), FONT_COLOR_HEX.DEFAULT, locale.housing.sell.price, FONT_COLOR_HEX.BLUE, price)
      return str
    end
  end
  local GetTypeForFurnitureText = function(info)
    if info.arrangeCount == info.maxCount then
      return string.format("%s %s%d/%d|r", info.name, FONT_COLOR_HEX.RED, info.arrangeCount, info.maxCount)
    else
      return string.format("%s %s%d|r/%d", info.name, FONT_COLOR_HEX.SKYBLUE, info.arrangeCount, info.maxCount)
    end
  end
  local function OnEnterFurnitureCountGuide()
    local info = X2House:GetDecoActabilityLimitGroup()
    if info == nil then
      ShowTextTooltip(furnitureCountGuide, nil, locale.housing.noneFurniture)
      return
    end
    local str = ""
    for i = 1, #info do
      if i == #info then
        str = string.format("%s %s", str, GetTypeForFurnitureText(info[i]))
      else
        str = string.format("%s %s\n", str, GetTypeForFurnitureText(info[i]))
      end
    end
    if str ~= "" then
      str = string.format([[
%s

%s]], str, X2Locale:LocalizeUiText(HOUSING_TEXT, "furniture_warning"))
    end
    ShowTextTooltip(furnitureCountGuide, locale.housing.typeFurnitureCount, str)
  end
  furnitureCountGuide:SetHandler("OnEnter", OnEnterFurnitureCountGuide)
  local OnLeaveFurnitureCountGuide = function()
    HideTextTooltip()
  end
  furnitureCountGuide:SetHandler("OnLeave", OnLeaveFurnitureCountGuide)
  return frame
end
function ShowHousingMainTainWindow(wantShow, isMyHouse)
  if wantShow and housing.maintainWindow == nil then
    housing.maintainWindow = CreateMaintainHousingFrame("housing.maintainWindow", "UIParent")
    housing.maintainWindow:Show(false)
    housing.maintainWindow:SetCloseOnEscape(true)
  else
    if housing.maintainWindow ~= nil then
      housing.maintainWindow:Show(false)
    end
    return
  end
  local OnHide = function(self)
    local housePermission, alwaysPublic = X2House:GetHousePermission()
    if X2House:IsMyHouse() and not alwaysPublic then
      local radioGroup = self.checkBoxes
      local permission = radioGroup:GetCheckedData()
      X2House:SetHousePermission(permission)
    end
    X2House:SetHouseAllowRecover(not self.furnitureCheckbox:GetChecked())
    HideEditDialog(housing.maintainWindow)
    housing.maintainWindow = nil
  end
  housing.maintainWindow:SetHandler("OnHide", OnHide)
end
function UpdateDecoImage(viewType)
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  if viewType ~= "house" and viewType ~= "seafarm" and viewType ~= "farm" and viewType ~= "castle" then
    window.deco_img:RemoveAllAnchors()
    window.deco_img:SetVisible(false)
    return
  end
  local paths = {
    house = "ui/housing/house.dds",
    seafarm = "ui/housing/garden.dds",
    farm = "ui/housing/garden.dds",
    castle = "ui/housing/castle.dds"
  }
  local keys = {
    house = "house",
    seafarm = "garden",
    farm = "garden",
    castle = "castle"
  }
  window.deco_img:SetVisible(true)
  window.deco_img:SetTexture(paths[viewType])
  window.deco_img:SetTextureInfo(keys[viewType])
  window.deco_img:RemoveAllAnchors()
  if window.contentUpper:GetHeight() / 2 <= window.deco_img:GetHeight() / 2 then
    window.deco_img:AddAnchor("TOPRIGHT", window.contentUpper, 0, -40)
  else
    window.deco_img:AddAnchor("RIGHT", window.contentUpper, 0, 0)
  end
end
function UpdateFurnitureCount()
  local furnitureCount = housing.maintainWindow.furnitureCount
  local decoActabilityButton = furnitureCount.decoActabilityButton
  local curCnt, maxCnt, extCnt = X2House:GetHouseDecoCount()
  if curCnt == nil or maxCnt == nil or X2House:IsCastle() then
    furnitureCount:Show(false)
    return
  end
  local count = X2House:GetActabilityDecoCount()
  if count ~= nil and count > 0 then
    decoActabilityButton:Enable(true)
  else
    if housing.maintainWindow.decoActabilitywindow ~= nil then
      housing.maintainWindow.decoActabilitywindow:Show(false)
    end
    decoActabilityButton:Enable(false)
  end
  local furnitureStr = ""
  local maxStr = tostring(maxCnt)
  if extCnt > 0 then
    maxStr = string.format("%d (%d+%d)", maxCnt, maxCnt - extCnt, extCnt)
  end
  furnitureStr = string.format("%s: %s%d|r / %s", locale.housing.furnitureCount, maxCnt <= curCnt and FONT_COLOR_HEX.RED or FONT_COLOR_HEX.BLUE, curCnt, maxStr)
  furnitureCount:Show(true)
  furnitureCount:SetText(furnitureStr)
  furnitureCount.guide:AddAnchor("LEFT", furnitureCount, furnitureCount:GetLongestLineWidth() + 15, 0)
end
function UpdateMyHouseDefaultInfo()
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  local contentUpper = window.contentUpper
  local permissionsWindow = window.permissionsWindow
  local houseType = X2House:GetHouseType()
  local houseTypeName = X2House:GetHousingModelName(houseType) or ""
  window:UpdateTitle(houseTypeName)
  window.changeNameButton:Show(true)
  window.demolishImgButton:Show(true)
  window.registerSellImgButton:Enable(false)
  window.buyButton:Show(false)
  window.okButton:Show(false)
  window.contentTaxInfo:Show(false)
  window.line:SetVisible(false)
  window.registerSellImgButton:Show(true)
  window.registerRotateImgButton:Show(true)
  window.registerRotateImgButton:Enable(X2House:IsHouseRotatable())
  window.registerUccImgButton:Show(X2Player:GetFeatureSet().housingUcc)
  window.registerUccImgButton:Enable(X2House:CanUseHousingUcc())
  if window.rebuildButton ~= nil then
    window.rebuildButton:Show(true)
    window.rebuildButton:Enable(false)
  end
  if window.packageDemolishImgButton ~= nil then
    window.registerSellImgButton:RemoveAllAnchors()
    if not X2House:IsCastle() then
      window.packageDemolishImgButton:Show(true)
      window.registerSellImgButton:AddAnchor("RIGHT", window.packageDemolishImgButton, "LEFT", 1, 0)
    else
      window.packageDemolishImgButton:Show(false)
      window.registerSellImgButton:AddAnchor("RIGHT", window.demolishImgButton, "LEFT", 1, 0)
    end
  end
  function housing.maintainWindow:setUpperStr()
    local upperStr = ""
    local ownerName = X2House:GetHouseOwnerName() or ""
    if ownerName ~= "" then
      upperStr = string.format("%s: %s", locale.tooltip.owner, ownerName)
    end
    local houseName = X2House:GetHouseName() or ""
    if houseName ~= "" then
      upperStr = string.format([[
%s
%s: %s%s|r]], upperStr, GetUIText(COMMON_TEXT, "housing_name"), FONT_COLOR_HEX.BLUE, houseName)
    end
    local factionName = X2House:GetHouseZoneName() or ""
    if factionName ~= "" then
      upperStr = string.format([[
%s
%s: %s]], upperStr, locale.housing.faction, factionName)
    end
    contentUpper:SetText(upperStr)
    contentUpper:SetHeight(contentUpper:GetTextHeight())
  end
  housing.maintainWindow:setUpperStr()
  UpdateFurnitureCount()
  local checked = X2House:GetHouseAllowRecover()
  window.furnitureCheckbox:Show(not X2House:IsCastle())
  window.furnitureCheckbox:SetChecked(not checked)
  local warningStr = ""
  window.warningText:Show(false)
  permissionsWindow:Show(true)
  permissionsWindow:RemoveAllAnchors()
  permissionsWindow:AddAnchor("TOPLEFT", window.contentUpper, "BOTTOMLEFT", 0, sideMargin)
  local housePermission, alwaysPublic = X2House:GetHousePermission()
  if housePermission == nil then
    housePermission = HOUSE_ALLOW_OWNER
  end
  local radioGroup = housing.maintainWindow.checkBoxes
  local data = radioGroup:GetData()
  if alwaysPublic then
    radioGroup:Enable(false, true)
    radioGroup:EnableIndex(4, true)
  elseif X2House:IsCastle() then
    data[3].text = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TEXT, "faction")
    radioGroup:SetData(data)
    radioGroup:Enable(false, true)
    radioGroup:EnableIndex(3, true)
    radioGroup:ShowIndex(2, false)
  else
    data[3].text = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "expedition")
    radioGroup:SetData(data)
    radioGroup:Enable(true, true)
    radioGroup:ShowIndex(2, true)
  end
  local index = radioGroup:GetIndexByValue(housePermission)
  radioGroup:Check(index)
  if window.rebuildButton ~= nil then
    local OnEnter = function(self)
      local packInfo = X2House:GetHousingRebuildingPackInfo()
      local str = GetUIText(COMMON_TEXT, "rebuilding_tip")
      if not self:IsEnabled() then
        if packInfo == nil then
          str = GetUIText(COMMON_TEXT, "impossible_to_rebuild_housing")
        else
          str = GetUIText(COMMON_TEXT, "disable_rebuilding_tip")
        end
      end
      SetTooltip(str, self)
    end
    window.rebuildButton:SetHandler("OnEnter", OnEnter)
    UpdateRebuildInfo()
  end
  if X2House:IsCastle() then
    if X2House:IsSiegePeriod() or X2House:IsWarmUpPeriod() then
      window.demolishImgButton:Enable(false)
    else
      window.demolishImgButton:Enable(true)
    end
  end
end
function UpdateMyHouseTaxInfo(taxRate, hostileTaxRate, taxString, dueTime, prepayTime, weeksWithoutPay, weeksPrepay, isAlreadyPaid, isHeavyTaxHouse, depositString, taxItemType)
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  local permissionsWindow = window.permissionsWindow
  local featureSet = X2Player:GetFeatureSet()
  window.contentTaxInfo.prepayButton:Show(featureSet.houseTaxPrepay)
  window.contentTaxInfo.prepayButton:Enable(false)
  window.contentTaxInfo.guideIcon:Show(featureSet.taxItem)
  local str = ""
  local warningStr = ""
  if taxRate ~= nil then
    str = string.format("%s: %s%%", locale.housing.taxRate, tostring(taxRate))
  end
  if hostileTaxRate ~= nil then
    str = string.format([[
%s
%s: %d%%]], str, GetCommonText("housing_hostile_faction_tax"), hostileTaxRate)
  end
  if taxString ~= nil then
    str = string.format([[
%s
%s: %s%s]], str, locale.housing.paymentTax, FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(taxString))
    if not isHeavyTaxHouse then
      str = string.format("%s %s(%s)|r", str, FONT_COLOR_HEX.BLUE, locale.housing.maintainWindow.heavyTaxExemption)
    end
    window.taxString = taxString
  end
  window.prepayTime = prepayTime
  if isAlreadyPaid ~= nil then
    if isAlreadyPaid then
      if weeksPrepay == nil or weeksPrepay < 1 then
        str = string.format([[
%s
%s: %s[%s]|r]], str, locale.housing.checkPayment, FONT_COLOR_HEX.BLUE, locale.housing.payState.full)
      else
        str = string.format([[
%s
%s: %s[%s %d/%d]|r]], str, locale.housing.checkPayment, FONT_COLOR_HEX.BLUE, GetUIText(COMMON_TEXT, "prepay_2"), weeksPrepay, PREPAY_ABLE_COUNT)
      end
      window.contentTaxInfo.prepayButton:Enable(weeksPrepay < PREPAY_ABLE_COUNT)
      window.contentTaxInfo.prepayButton.tip = X2Locale:LocalizeUiText(COMMON_TEXT, "prepay_btn_tooltip", FONT_COLOR_HEX.SOFT_YELLOW, FONT_COLOR_HEX.SOFT_YELLOW, tostring(weeksPrepay))
    else
      if weeksWithoutPay ~= nil and weeksWithoutPay == 1 then
        str = string.format([[
%s
%s: %s[%s]|r]], str, locale.housing.checkPayment, FONT_COLOR_HEX.RED, locale.housing.payState.overdue)
      else
        str = string.format([[
%s
%s: %s[%s]|r]], str, locale.housing.checkPayment, FONT_COLOR_HEX.RED, locale.housing.payState.unpaid)
      end
      window.contentTaxInfo.prepayButton.tip = GetUIText(COMMON_TEXT, "unable_prepay_for_housing_unpaid_or_overdue")
    end
    window.weeksPrepay = weeksPrepay
    window.isAlreadyPaid = isAlreadyPaid
  end
  if dueTime ~= nil then
    local dueStr = locale.time.GetDateToDateFormat(dueTime)
    local dueDateForPaymentStr = ""
    if weeksWithoutPay ~= nil and weeksWithoutPay == 1 then
      dueDateForPaymentStr = string.format("%s: %s%s%s|r", locale.housing.demolishDate, FONT_COLOR_HEX.RED, dueStr, locale.housing.untilTerm)
    else
      dueDateForPaymentStr = string.format("%s: %s%s", locale.housing.dueDateForPayment, dueStr, locale.housing.untilTerm)
    end
    str = string.format([[
%s
%s]], str, dueDateForPaymentStr)
  end
  local sellInfos = X2House:GetHouseSaleInfo()
  window.registerSellImgButton:Enable(sellInfos.canSell and weeksWithoutPay < 1)
  local _, alwaysPublic = X2House:GetHousePermission()
  if alwaysPublic then
    window.warningText:Show(true)
    warningStr = F_TEXT.SetEnterString(warningStr, locale.housing.alwaysPublicTip, 2)
  end
  if sellInfos.onSale then
    window.warningText:Show(true)
    local str = window:GetSellInfoText(sellInfos.targetName, sellInfos.price)
    warningStr = F_TEXT.SetEnterString(warningStr, str, 2)
    window.contentTaxInfo.prepayButton:Enable(false)
    window.contentTaxInfo.prepayButton.tip = GetUIText(ERROR_MSG, "HOUSE_CANNOT_PREPAY_FOR_SALE")
  end
  local isSiegePeriod = X2House:IsSiegePeriod()
  if isSiegePeriod then
    window.warningText:Show(true)
    warningStr = F_TEXT.SetEnterString(warningStr, locale.housing.inSiegeWarning, 2)
  end
  window.demolishImgButton:Enable(true)
  if window.packageDemolishImgButton ~= nil then
    window.packageDemolishImgButton:Enable(X2House:CanPackageDemolish())
  end
  if not X2House:IsCastle() and weeksWithoutPay ~= nil and weeksWithoutPay > 0 then
    window.warningText:Show(true)
    window.demolishImgButton:Enable(false)
    if window.packageDemolishImgButton ~= nil then
      window.packageDemolishImgButton:Enable(false)
    end
    warningStr = F_TEXT.SetEnterString(warningStr, GetUIText(HOUSING_TEXT, "warning_default"), 2)
  end
  window:UpdateWarningTextMyHouse(warningStr)
  if depositString ~= nil and taxItemType ~= nil then
    window.contentTaxInfo.guideIcon:FillInfo(taxItemType, X2House:CountTaxItemForTax(depositString))
  end
  window.contentTaxInfo:Show(true)
  window.contentTaxInfo:SetText(str)
  window.contentTaxInfo:SetHeight(window.contentTaxInfo:GetTextHeight())
  window.contentUpper.bg:RemoveAllAnchors()
  window.contentUpper.bg:AddAnchor("TOPLEFT", window.contentUpper, -5, -sideMargin / 1.5)
  window.contentUpper.bg:AddAnchor("BOTTOMRIGHT", window.contentTaxInfo, 5, sideMargin / 1.5)
  permissionsWindow:RemoveAllAnchors()
  permissionsWindow:AddAnchor("TOPLEFT", window.contentTaxInfo, "BOTTOMLEFT", 0, sideMargin)
  if not X2House:IsCastle() then
    window.line:SetVisible(true)
    window.line:RemoveAllAnchors()
    window.line:AddAnchor("TOP", window.furnitureCount, "BOTTOM", 0, 8)
  end
  local packInfo = X2House:GetHousingRebuildingPackInfo()
  rebuildBtnEnable = not sellInfos.onSale and not X2House:IsSiegePeriod() and not X2House:IsWarmUpPeriod() and weeksWithoutPay ~= nil and weeksWithoutPay < 1 and packInfo ~= nil
  if window.rebuildButton ~= nil then
    window.rebuildButton:Enable(rebuildBtnEnable)
  end
  if window.registerRotateImgButton ~= nil then
    window.registerRotateImgButton:Enable(X2House:IsHouseRotatable() and weeksWithoutPay ~= nil and weeksWithoutPay < 1)
  end
  if window.registerUccImgButton ~= nil then
    window.registerUccImgButton:Enable(X2House:CanUseHousingUcc() and weeksWithoutPay ~= nil and weeksWithoutPay < 1)
  end
end
function UpdateHouseDefaultInfo()
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  local contentUpper = window.contentUpper
  local permissionsWindow = window.permissionsWindow
  window.permissionsWindow:Show(false)
  window.changeNameButton:Show(false)
  window.buyButton:Show(true)
  window.demolishImgButton:Show(false)
  if window.packageDemolishImgButton ~= nil then
    window.packageDemolishImgButton:Show(false)
  end
  window.registerSellImgButton:Show(false)
  window.registerRotateImgButton:Show(false)
  window.registerUccImgButton:Show(false)
  window.warningText:Show(false)
  window.contentTaxInfo:Show(false)
  window.furnitureCheckbox:Show(false)
  window.okButton:Show(true)
  if window.rebuildButton ~= nil then
    window.rebuildButton:Show(false)
  end
  local houseType = X2House:GetHouseType()
  local houseTypeName = X2House:GetHousingModelName(houseType) or ""
  window:UpdateTitle(houseTypeName)
  local warningStr = ""
  function housing.maintainWindow:setUpperStr()
    local str = ""
    local houseOwner = X2House:GetHouseOwnerName() or ""
    if houseOwner ~= "" then
      str = string.format("%s: %s", locale.tooltip.owner, houseOwner)
    end
    local houseName = X2House:GetHouseName() or ""
    if houseName ~= "" then
      str = string.format([[
%s
%s: %s%s|r]], str, GetUIText(COMMON_TEXT, "housing_name"), FONT_COLOR_HEX.BLUE, houseName)
    end
    local houseZoneName = X2House:GetHouseZoneName() or ""
    if houseZoneName ~= "" then
      str = string.format([[
%s
%s: %s]], str, locale.housing.faction, houseZoneName)
    end
    local housePermission, _ = X2House:GetHousePermission()
    if housePermission == nil then
      housePermission = HOUSE_ALLOW_OWNER
    end
    for i, v in ipairs(locale.housing.permissions) do
      if v.value == housePermission then
        permWord = v.text
      end
    end
    if X2House:IsCastle() then
      permWord = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TEXT, "faction")
    end
    local permissionsStr = string.format("%s: %s", locale.housing.usePermission, permWord)
    str = string.format([[
%s
%s]], str, permissionsStr)
    local sellInfos = X2House:GetHouseSaleInfo()
    window.buyButton:Enable(sellInfos.canBuy)
    if sellInfos.onSale then
      window.warningText:Show(true)
      local sellStr = window:GetSellInfoText(sellInfos.targetName, sellInfos.price)
      warningStr = sellStr
    end
    contentUpper:SetText(str)
  end
  housing.maintainWindow:setUpperStr()
  UpdateFurnitureCount()
  window:UpdateWarningTextNotMyHouse(warningStr)
  contentUpper:SetHeight(contentUpper:GetTextHeight())
  local target = window.furnitureCount
  if not window.furnitureCount:IsVisible() then
    target = window.contentUpper
  end
  window.contentUpper.bg:RemoveAllAnchors()
  window.contentUpper.bg:AddAnchor("TOPLEFT", window.contentUpper, -5, -sideMargin / 1.5)
  window.contentUpper.bg:AddAnchor("BOTTOMRIGHT", target, 5, sideMargin / 1.5)
end
function UpdateHouseTaxInfo(taxRate, hostileTaxRate, dueTime, weeksWithoutPay)
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  local str = ""
  local warningStr = ""
  window.contentTaxInfo.guideIcon:Show(false)
  window.contentTaxInfo.prepayButton:Show(false)
  if taxRate ~= nil then
    str = string.format("%s: %s%%", locale.housing.taxRate, tostring(taxRate))
  end
  if hostileTaxRate ~= nil then
    str = string.format([[
%s
%s: %d%%]], str, GetCommonText("housing_hostile_faction_tax"), hostileTaxRate)
  end
  local isSiegePeriod = X2House:IsSiegePeriod()
  if isSiegePeriod then
    window.warningText:Show(true)
    warningStr = locale.housing.inSiegeWarning
  end
  if not X2House:IsCastle() then
    window.line:SetVisible(true)
    window.line:RemoveAllAnchors()
    window.line:AddAnchor("TOP", window.furnitureCount, "BOTTOM", 0, 8)
  end
  if weeksWithoutPay ~= nil then
    local dueStr = locale.time.GetDateToDateFormat(dueTime)
    local dueDateForPaymentStr = ""
    if weeksWithoutPay == 1 then
      window.warningText:Show(true)
      warningStr = F_TEXT.SetEnterString(warningStr, GetUIText(HOUSING_TEXT, "warning_default"), 2)
      dueDateForPaymentStr = string.format("%s: %s%s%s|r", locale.housing.demolishDate, FONT_COLOR_HEX.RED, dueStr, locale.housing.untilTerm)
      str = string.format([[
%s
%s]], str, dueDateForPaymentStr)
    else
      dueDateForPaymentStr = string.format("%s: %s%s", locale.housing.dueDateForPayment, dueStr, locale.housing.untilTerm)
      str = string.format([[
%s
%s]], str, dueDateForPaymentStr)
    end
  end
  window.contentTaxInfo:Show(true)
  window.contentTaxInfo:SetText(str)
  window.contentTaxInfo:SetHeight(window.contentTaxInfo:GetTextHeight())
  window:UpdateWarningTextNotMyHouse(warningStr)
  window.contentUpper.bg:RemoveAllAnchors()
  window.contentUpper.bg:AddAnchor("TOPLEFT", window.contentUpper, -5, -sideMargin / 1.5)
  window.contentUpper.bg:AddAnchor("BOTTOMRIGHT", window.contentTaxInfo, 5, sideMargin / 1.5)
end
function UpdateMaintainWindowHeight()
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  if X2House:IsMyHouse() then
    window:UpdateExtent_myHouse()
  else
    window:UpdateExtent_notMyHouse()
  end
  if window:IsVisible() then
    SettingWindowSkin(window)
  end
end
function UpdateSellInfo()
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  if X2House:IsMyHouse() then
    local sellInfos = X2House:GetHouseSaleInfo()
    if sellInfos == nil then
      return
    end
    if not sellInfos.onSale then
      window:UpdateCancelSellSuccess()
      window.registerRotateImgButton:Enable(X2House:IsHouseRotatable())
      window.registerUccImgButton:Enable(X2House:CanUseHousingUcc())
      window.rebuildButton:Enable(X2House:GetHousingRebuildingPackInfo() ~= nil)
    else
      window:UpdateSetSellSuccess(sellInfos)
      window.registerRotateImgButton:Enable(false)
      window.registerUccImgButton:Enable(false)
      window.rebuildButton:Enable(false)
    end
  else
    UpdateHouseDefaultInfo()
  end
  UpdateMaintainWindowHeight()
end
function UpdateRebuildInfo()
  local window = housing.maintainWindow
  if window == nil then
    return
  end
  if not X2House:IsMyHouse() then
    return
  end
  if window.rebuildButton == nil then
    return
  end
  if X2House:IsCastle() then
    local packInfo = X2House:GetHousingRebuildingPackInfo()
    local rebuildBtnEnable = not X2House:IsSiegePeriod() and not X2House:IsWarmUpPeriod() and packInfo ~= nil
    window.rebuildButton:Enable(rebuildBtnEnable)
  end
end
