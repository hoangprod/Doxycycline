local sideMargin, titleMargin, bottomMargin = GetWindowMargin("popup")
local startOffsetX = sideMargin
local WIDTH = 390
local function CreateTaxInfoPart(widget)
  local taxInfo = widget:CreateChildWidget("emptyWidget", "taxInfo", 0, true)
  taxInfo:AddAnchor("TOP", widget, 0, titleMargin)
  taxInfo:SetWidth(WIDTH)
  taxInfo:Show(true)
  local buildInfo = taxInfo:CreateChildWidget("textbox", "buildInfo", 0, true)
  buildInfo:Show(true)
  buildInfo:SetExtent(WIDTH, FONT_SIZE.MIDDLE)
  buildInfo:AddAnchor("TOP", taxInfo, 0, 0)
  buildInfo.style:SetSnap(true)
  buildInfo.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(buildInfo, FONT_COLOR.DEFAULT)
  local basicTax = taxInfo:CreateChildWidget("textbox", "basicTax", 0, true)
  basicTax:Show(true)
  basicTax:SetExtent(WIDTH, 20)
  basicTax:AddAnchor("TOP", buildInfo, "BOTTOM", 0, 15)
  basicTax.style:SetSnap(true)
  basicTax:SetInset(10, 0, 10, 0)
  basicTax.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(basicTax, FONT_COLOR.DEFAULT)
  local guideIcon = CreateTaxInfoGuideIcon(basicTax)
  guideIcon:AddAnchor("TOPRIGHT", basicTax, -5, -3)
  basicTax.guideIcon = guideIcon
  local heavyTaxDesc = taxInfo:CreateChildWidget("textbox", "heavyTaxDesc", 0, true)
  heavyTaxDesc:Show(true)
  heavyTaxDesc:SetExtent(WIDTH - 15, 31)
  heavyTaxDesc:AddAnchor("TOPLEFT", basicTax, "BOTTOMLEFT", 0, 10)
  heavyTaxDesc:SetInset(10, 0, 0, 0)
  heavyTaxDesc.style:SetSnap(true)
  heavyTaxDesc.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(heavyTaxDesc, FONT_COLOR.DEFAULT)
  local bg = CreateContentBackground(basicTax, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", basicTax, -5, -sideMargin / 1.5)
  bg:AddAnchor("BOTTOMRIGHT", heavyTaxDesc, 20, sideMargin / 1.5)
  basicTax.bg = bg
  function GetHouseName(hType)
    return X2House:GetHousingModelName(hType)
  end
  function taxInfo:SetInfo(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType)
    local houseName = GetHouseName(hType)
    buildInfo:SetText(string.format("%s[%s]|r %s", FONT_COLOR_HEX.BLUE, houseName, locale.housing.buildWindow.buildInfo))
    local taxStr = ""
    if depositString ~= nil and taxItemType ~= nil then
      basicTax.guideIcon:FillInfo(taxItemType, X2House:CountTaxItemForTax(depositString))
    end
    if depositString ~= nil then
      taxStr = string.format("%s: %s%s|r", GetCommonText("deposit"), FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(depositString))
      taxStr = string.format([[
%s
%s: %s%s|r]], taxStr, GetUIText(COMMON_TEXT, "base_tax"), FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(bTax))
    else
      taxStr = string.format("%s: %s%s|r", GetUIText(COMMON_TEXT, "base_tax"), FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(bTax))
    end
    if isHeavyTaxHouse then
      taxStr = string.format([[
%s
%s: %d]], taxStr, GetUIText(COMMON_TEXT, "housing_possession_count"), heavyTaxHouseCount)
    end
    if hostileTaxRate > 0 then
      taxStr = string.format([[
%s
%s: %d%%]], taxStr, GetCommonText("housing_hostile_faction_tax"), hostileTaxRate)
    end
    basicTax:SetText(taxStr)
    basicTax:SetHeight(basicTax:GetTextHeight())
    local str
    if isHeavyTaxHouse then
      str = string.format("%s: %s%s|r", locale.housing.buildWindow.heavyTax, FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(hTax))
      str = string.format([[
%s
%s%s]], str, FONT_COLOR_HEX.GRAY, locale.housing.buildWindow.heavyTaxDesc)
    else
      str = locale.housing.buildWindow.heavyTaxExemption(FONT_COLOR_HEX.BLUE, FONT_COLOR_HEX.GRAY)
    end
    heavyTaxDesc:SetText(str)
    heavyTaxDesc:SetHeight(heavyTaxDesc:GetTextHeight())
    local height = self.buildInfo:GetHeight() + self.basicTax:GetHeight() + self.heavyTaxDesc:GetHeight()
    self:SetHeight(height + sideMargin * 2)
  end
end
local function CreateMaterialPart(widget)
  local materialWidget = widget:CreateChildWidget("emptyWidget", "materialWidget", 0, true)
  materialWidget:AddAnchor("TOPLEFT", widget.taxInfo, "BOTTOMLEFT", 0, sideMargin / 2)
  materialWidget:SetWidth(WIDTH)
  materialWidget:Show(true)
  local materialLabel = materialWidget:CreateChildWidget("label", "materialLabel", 0, true)
  materialLabel:Show(true)
  materialLabel:SetExtent(WIDTH, 20)
  materialLabel:AddAnchor("TOPLEFT", materialWidget, 0, 0)
  materialLabel.style:SetSnap(true)
  materialLabel.style:SetAlign(ALIGN_LEFT)
  materialLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(materialLabel, FONT_COLOR.DEFAULT)
  materialLabel:SetText(locale.housing.buildWindow.materialLabel)
  local materialIconWnd = materialWidget:CreateChildWidget("emptyWidget", "materialIconWnd", 0, true)
  materialIconWnd:SetExtent(POPUP_WINDOW_WIDTH - 2 * sideMargin, 150)
  materialIconWnd:AddAnchor("TOP", materialWidget, 0, sideMargin * 1.6)
  local bg = CreateContentBackground(materialIconWnd, "TYPE2", "brown")
  bg:SetWidth(400)
  bg:AddAnchor("TOP", materialIconWnd, 0, -sideMargin / 1.5)
  bg:AddAnchor("BOTTOM", materialIconWnd, 0, 5)
  materialIconWnd.bg = bg
  function materialWidget:SetInfo(hType, completion)
    local stepArrowTextureWidth = 21
    local stepArrowTextureInset = 3
    local stepLabelHeight = 15
    local constructionStep = X2House:GetHousingModelConstructionInfo(hType)
    if #constructionStep == 0 or completion then
      self:Show(false)
      return
    end
    materialWidget.materialIcon = {}
    for i = 1, #constructionStep do
      local itemInfo = constructionStep[i]
      local materialIcon = CreateItemIconButton(self:GetId() .. ".materialIcon." .. itemInfo.step, materialIconWnd)
      materialWidget.materialIcon[itemInfo.step] = materialIcon
      local index = math.floor((i - 1) % 4)
      local col = index * ICON_SIZE.DEFAULT + index * stepArrowTextureWidth * 1.5
      local row = math.floor((i - 1) / 4) * (ICON_SIZE.DEFAULT + 20)
      materialIcon:AddAnchor("TOPLEFT", materialIconWnd, col, row)
      if itemInfo.isLaborPower == true then
        SetLaborItemIcon(materialIcon)
        SetLaborItemTooltip(materialIcon)
      else
        materialIcon:SetItemInfo(itemInfo)
        materialIcon:SetStack(itemInfo.consumeItemStack)
      end
      local stepLabel = W_CTRL.CreateLabel(self:GetId() .. ".stepLabel", materialIcon)
      stepLabel:SetExtent(20, stepLabelHeight)
      stepLabel:SetAutoResize(true)
      stepLabel:AddAnchor("TOP", materialIcon, "BOTTOM", 0, 2)
      stepLabel.style:SetFontSize(FONT_SIZE.SMALL)
      stepLabel:SetText(tostring(itemInfo.needActions))
      materialIcon.stepLabel = stepLabel
      if i < #constructionStep then
        local stepArrow = materialIcon:CreateDrawable(TEXTURE_PATH.HUD, "tooltip_arrow", "background")
        stepArrow:AddAnchor("LEFT", materialIcon, "RIGHT", stepArrowTextureInset, 2)
      end
    end
    local function GetIconFrameWidth(constructionStep)
      local iconCnt
      if constructionStep >= 4 then
        iconCnt = 4
      else
        iconCnt = constructionStep
      end
      local arrowCnt = 0
      if constructionStep > 4 then
        arrowCnt = 4
      else
        arrowCnt = constructionStep - 1
      end
      return ICON_SIZE.DEFAULT * iconCnt + stepArrowTextureWidth * 1.4 * arrowCnt
    end
    local GetRowCount = function(constructionStep)
      if constructionStep % 4 == 0 then
        return constructionStep / 4
      else
        return math.floor(constructionStep / 4 + 1)
      end
    end
    local function GetIconFrameHeight()
      return GetRowCount(#constructionStep) * ICON_SIZE.DEFAULT + GetRowCount(#constructionStep) * stepLabelHeight + 5
    end
    materialIconWnd:SetExtent(GetIconFrameWidth(#constructionStep), GetIconFrameHeight())
    local _, mOffsetY = materialWidget:GetOffset()
    local _, iOffsetY = materialIconWnd:GetOffset()
    local _, iExtentY = materialIconWnd:GetExtent()
    materialWidget:SetHeight(iOffsetY + iExtentY - mOffsetY)
  end
end
local function CreateTaxPaymentPart(widget)
  local taxPaymentDesc = widget:CreateChildWidget("textbox", "taxPaymentDesc", 0, true)
  taxPaymentDesc:Show(true)
  taxPaymentDesc:SetWidth(WIDTH)
  taxPaymentDesc:AddAnchor("TOP", widget.materialWidget, "BOTTOM", 0, sideMargin / 1.1)
  taxPaymentDesc.style:SetSnap(true)
  taxPaymentDesc.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(taxPaymentDesc, FONT_COLOR.DEFAULT)
  taxPaymentDesc:SetText(locale.housing.buildWindow.taxPaymentDesc)
  taxPaymentDesc:SetHeight(taxPaymentDesc:GetTextHeight())
  function taxPaymentDesc:ReAnchor(window)
    self:RemoveAllAnchors()
    if window.materialWidget:IsVisible() then
      self:AddAnchor("TOP", window.materialWidget, "BOTTOM", 0, sideMargin / 1.2)
    elseif window.taxInfo:IsVisible() then
      self:AddAnchor("TOP", window.taxInfo, "BOTTOM", 0, sideMargin / 2)
    else
      self:AddAnchor("TOP", materialWidget, "BOTTOM", 0, sideMargin / 1.1)
    end
  end
end
local function CreateTaxItemPart(widget)
  local taxItem = CreateItemIconButton(widget:GetId() .. ".taxItem", widget)
  taxItem:Show(false)
  taxItem:AddAnchor("TOP", widget.taxPaymentDesc, "BOTTOM", 0, sideMargin / 2)
  widget.taxItem = taxItem
  function widget:FillTaxItem(itemType, hTax)
    if itemType == nil then
      self.taxItem:Show(false)
      return
    end
    local itemInfo = X2Item:GetItemInfoByType(itemType)
    self.taxItem:Show(true)
    self.taxItem:SetItemInfo(itemInfo)
    local curCnt = X2House:CountTaxItemInBag()
    local needCnt = X2House:CountTaxItemForTax(tostring(hTax))
    self.taxItem:SetStack(curCnt, needCnt)
    if tonumber(curCnt) >= tonumber(needCnt) then
      self.leftButton:Enable(true)
    else
      self.leftButton:Enable(false)
    end
  end
end
function CreateHousingBuildWindow(windowId, parent)
  local window = CreateWindow(windowId, parent)
  window:SetCloseOnEscape(true)
  window:EnableHidingIsRemove(true)
  window:SetTitle(locale.housing.buildWindow.title)
  window:SetExtent(430, 400)
  window:AddAnchor("CENTER", parent, 0, 0)
  CreateTaxInfoPart(window)
  CreateMaterialPart(window)
  CreateTaxPaymentPart(window)
  CreateTaxItemPart(window)
  local infos = {
    leftButtonStr = GetUIText(COMMON_TEXT, "building"),
    rightButtonStr = GetUIText(HOUSING_TEXT, "build_cancelButton")
  }
  CreateWindowDefaultTextButtonSet(window, infos)
  local function LeftButtonLeftClickFunc()
    window.buildOk = true
    window:Show(false)
  end
  ButtonOnClickHandler(window.leftButton, LeftButtonLeftClickFunc)
  local function RightButtonLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(window.rightButton, RightButtonLeftClickFunc)
  function window:SetInfo(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType, completion)
    window.taxInfo:SetInfo(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType)
    window.materialWidget:SetInfo(hType, completion)
    window.taxPaymentDesc:ReAnchor(self)
    window:FillTaxItem(taxItemType, hTax)
  end
  window.buildOk = false
  function window:SetWndHeight()
    local height = titleMargin + sideMargin
    local SetHeight = function(height, widget, addHeight)
      if not widget:IsVisible() then
        return height
      end
      if addHeight == nil then
        addHeight = 0
      end
      height = height + widget:GetHeight() + addHeight
      return height
    end
    height = SetHeight(height, self.taxInfo, sideMargin / 2)
    height = SetHeight(height, self.materialWidget, sideMargin)
    height = SetHeight(height, self.taxPaymentDesc, sideMargin / 2)
    height = SetHeight(height, self.taxItem, sideMargin / 2)
    height = SetHeight(height, self.leftButton)
    self:SetHeight(height)
  end
  return window
end
