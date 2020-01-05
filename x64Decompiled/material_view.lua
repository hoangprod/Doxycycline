local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local startOffsetX = sideMargin
local TEXTBOX_WIDTH = 390
function CreateInfoPart(widget)
  local housingInfo = widget:CreateChildWidget("textbox", "housingInfo", 0, true)
  housingInfo:Show(true)
  housingInfo:SetExtent(TEXTBOX_WIDTH, 20)
  housingInfo:AddAnchor("TOPLEFT", widget, sideMargin, titleMargin)
  housingInfo:SetInset(10, 0, 10, 0)
  housingInfo.style:SetSnap(true)
  housingInfo.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(housingInfo, FONT_COLOR.DEFAULT)
  local bg = CreateContentBackground(housingInfo, "TYPE2", "brown")
  housingInfo.bg = bg
  local line = CreateLine(housingInfo, "TYPE1")
  line:SetVisible(false)
  line:SetExtent(TEXTBOX_WIDTH, 3)
  line:SetColor(1, 1, 1, 0.4)
  line:AddAnchor("CENTER", housingInfo, 0, -8)
  housingInfo.line = line
  local guideIcon = CreateTaxInfoGuideIcon(housingInfo)
  guideIcon:AddAnchor("TOPRIGHT", line, -7, 10)
  housingInfo.guideIcon = guideIcon
  local shipyardProtectionInfo = widget:CreateChildWidget("textbox", "shipyardProtectionInfo", 0, true)
  shipyardProtectionInfo:Show(false)
  shipyardProtectionInfo:SetExtent(TEXTBOX_WIDTH, 20)
  shipyardProtectionInfo:AddAnchor("TOP", housingInfo, "BOTTOM", 0, 5)
  shipyardProtectionInfo:SetInset(10, 0, 10, 0)
  shipyardProtectionInfo.style:SetSnap(true)
  shipyardProtectionInfo.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(shipyardProtectionInfo, FONT_COLOR.DEFAULT)
  local warningInfo = widget:CreateChildWidget("textbox", "warningInfo", 0, true)
  warningInfo:Show(false)
  warningInfo:AddAnchor("TOPLEFT", housingInfo, "BOTTOMLEFT", 0, sideMargin)
  warningInfo.style:SetSnap(true)
  warningInfo.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(warningInfo, FONT_COLOR.RED)
  warningInfo:SetExtent(TEXTBOX_WIDTH, 30)
  function widget:ShowWarningText()
    warningInfo:Show(true)
    return warningInfo
  end
  function widget:HideWarningText()
    warningInfo:Show(false)
  end
  function widget:SetInfoText(infoStr)
    housingInfo:SetText(infoStr)
    housingInfo:SetHeight(housingInfo:GetTextHeight())
    housingInfo.bg:AddAnchor("TOPLEFT", housingInfo, -5, -sideMargin / 1.5)
    housingInfo.bg:AddAnchor("BOTTOMRIGHT", housingInfo, 5, sideMargin / 1.5)
  end
  function widget:SetWarningInfoText(infoStr)
    warningInfo:SetText(infoStr)
    warningInfo:SetHeight(warningInfo:GetTextHeight())
  end
  function widget:ShowProtectionPeriod(infoStr)
    shipyardProtectionInfo:Show(true)
    shipyardProtectionInfo:SetText(infoStr)
    local textHeight = shipyardProtectionInfo:GetTextHeight()
    shipyardProtectionInfo:SetHeight(textHeight)
    housingInfo.bg:AddAnchor("TOPLEFT", housingInfo, -5, -sideMargin / 1.5)
    housingInfo.bg:AddAnchor("BOTTOMRIGHT", shipyardProtectionInfo, 5, sideMargin / 1.5)
    return shipyardProtectionInfo
  end
end
function CreateMaterialPart(widget)
  local progressStepLabel = widget:CreateChildWidget("textbox", "progressStepLabel", 0, true)
  progressStepLabel:SetExtent(widget:GetWidth() - sideMargin * 2, FONT_SIZE.LARGE)
  progressStepLabel:AddAnchor("TOPLEFT", widget, sideMargin, 100)
  progressStepLabel.style:SetAlign(ALIGN_LEFT)
  progressStepLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(progressStepLabel, FONT_COLOR.DEFAULT)
  function widget:UpdateProgressStepText(presentStep, AllStep, leftStep)
    local text = string.format("%s %s%d|r/%d", locale.housing.constructionWindow.progressStep, FONT_COLOR_HEX.BLUE, presentStep, AllStep)
    progressStepLabel:SetText(text)
  end
  function widget:UpdateProgressStep(frontWidget, presentStep, AllStep, leftStep)
    progressStepLabel:RemoveAllAnchors()
    progressStepLabel:AddAnchor("TOPLEFT", frontWidget, "BOTTOMLEFT", 0, sideMargin)
    self:UpdateProgressStepText(presentStep, AllStep, leftStep)
    return progressStepLabel
  end
end
function CreateDescConsumeLaborPowerLabel(widget)
  local descConsumeLabel = widget:CreateChildWidget("textbox", "descConsumeLabel", 0, true)
  descConsumeLabel:Show(true)
  descConsumeLabel:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  descConsumeLabel.style:SetSnap(true)
  descConsumeLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(descConsumeLabel, FONT_COLOR.BLUE)
end
function CreateBottomButtonSet(widget)
  local demolishImgButton = widget:CreateChildWidget("button", "demolishImgButton", 0, true)
  demolishImgButton:Show(false)
  demolishImgButton:AddAnchor("BOTTOMLEFT", widget, sideMargin, -sideMargin)
  ApplyButtonSkin(demolishImgButton, BUTTON_BASIC.HOUSING_DEMOLISH)
  local okButton = widget:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.pet.okButton)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", widget, 0, -sideMargin)
  function widget:UpdateOkButtonPosition()
    if X2House:IsMyHouse() then
      okButton:RemoveAllAnchors()
      okButton:AddAnchor("BOTTOMRIGHT", widget, -sideMargin, -sideMargin)
    else
      okButton:RemoveAllAnchors()
      okButton:AddAnchor("BOTTOM", widget, 0, -sideMargin)
    end
  end
end
function CreateHousingMaterialWindow(windowId, parent)
  local window = CreateWindow(windowId, parent)
  window:SetCloseOnEscape(true)
  window:EnableHidingIsRemove(true)
  window:SetExtent(430, 100)
  window:AddAnchor("TOP", parent, 0, 100)
  CreateInfoPart(window)
  CreateMaterialPart(window)
  CreateDescConsumeLaborPowerLabel(window)
  CreateBottomButtonSet(window)
  function window:CreateMaterialIconPart(constructionStep)
    local stepLabelHeight = 15
    local stepArrowTextureWidth = 21
    local stepArrowTextureInset = 3
    local lastIconLabel
    local SetLaborItemIcon = function(materialIcon)
      F_SLOT.SetItemIcons(materialIcon, "Game\\ui\\icon\\labor.dds")
    end
    local SetLaborItemTooltip = function(materialIcon)
      function materialIcon:OnEnter()
        SetTooltip(locale.attribute("labor_power"), materialIcon)
      end
      function materialIcon:OnLeave()
        HideTooltip()
      end
      materialIcon:SetHandler("OnEnter", materialIcon.OnEnter)
      materialIcon:SetHandler("OnLeave", materialIcon.OnLeave)
    end
    local function GetIconFrameWidth(constructionStep)
      if constructionStep >= 4 then
        constructionStep = 4
      end
      if constructionStep == 1 then
        return ICON_SIZE.DEFAULT
      end
      return ICON_SIZE.DEFAULT * constructionStep + stepArrowTextureWidth * 1.4 * constructionStep
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
    if self.iconFrame ~= nil then
      return window.lastIconLabel
    end
    local iconFrame = self:CreateChildWidget("window", "iconFrame", 0, true)
    iconFrame:Show(true)
    iconFrame:SetExtent(GetIconFrameWidth(#constructionStep), GetIconFrameHeight())
    iconFrame:AddAnchor("TOP", self.progressStepLabel, "BOTTOM", 0, sideMargin / 1.2)
    local bg = CreateContentBackground(iconFrame, "TYPE2", "brown")
    bg:SetWidth(400)
    bg:AddAnchor("TOP", iconFrame, 0, -sideMargin / 1.5)
    bg:AddAnchor("BOTTOM", iconFrame, 0, 5)
    iconFrame.bg = bg
    window.materialIcon = {}
    for i = 1, #constructionStep do
      local itemInfo = constructionStep[i]
      local materialIcon = CreateItemIconButton(self:GetId() .. ".materialIcon." .. itemInfo.step, window)
      window.materialIcon[itemInfo.step] = materialIcon
      local index = math.floor((i - 1) % 4)
      local col = index * ICON_SIZE.DEFAULT + index * stepArrowTextureWidth * 1.5
      local row = math.floor((i - 1) / 4) * (ICON_SIZE.DEFAULT + 20)
      materialIcon:AddAnchor("TOPLEFT", iconFrame, col, row)
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
      materialIcon.stepLabel = stepLabel
      if i < #constructionStep then
        local stepArrow = materialIcon:CreateDrawable(TEXTURE_PATH.HUD, "tooltip_arrow", "background")
        stepArrow:AddAnchor("LEFT", materialIcon, "RIGHT", stepArrowTextureInset, 2)
      end
      lastIconLabel = materialIcon
    end
    function window:UpdateIconStepLabel(nowActions, constructionStep)
      for i = 1, #constructionStep do
        local itemInfo = constructionStep[i]
        local stepLabel = window.materialIcon[itemInfo.step].stepLabel
        local firstNum = nowActions
        local secondNum = itemInfo.needActions
        if firstNum > secondNum then
          firstNum = secondNum
        end
        stepLabel:SetText(firstNum .. "/" .. secondNum)
        nowActions = nowActions - secondNum
        if nowActions < 0 then
          nowActions = 0
        end
      end
    end
    window.lastIconLabel = lastIconLabel
    return lastIconLabel
  end
  function window:UpdateWindowExtent(lastIconLabel)
    if lastIconLabel == nil then
      return
    end
    local function GetInfoHeight()
      if window.housingInfo:IsVisible() then
        if window.shipyardProtectionInfo:IsVisible() then
          return window.housingInfo.bg:GetHeight() + window.shipyardProtectionInfo:GetTextHeight() + sideMargin
        else
          return window.housingInfo.bg:GetHeight() + sideMargin * 1.7
        end
      end
    end
    local height = GetInfoHeight() + self.progressStepLabel:GetHeight() + self.descConsumeLabel:GetHeight() + self.okButton:GetHeight()
    if self.warningInfo:IsVisible() then
      height = height + self.warningInfo:GetHeight() + sideMargin
    end
    height = height + titleMargin + self.iconFrame.bg:GetHeight()
    self:SetExtent(430, height)
    self:UpdateOkButtonPosition()
    self:Show(true)
  end
  function window:UpdateDescConsumeLaborPowerLabel(isHousing)
    local text = locale.housing.consumeLabor(25)
    if isHousing then
      self.descConsumeLabel:SetExtent(TEXTBOX_WIDTH, 35)
      self.descConsumeLabel:AddAnchor("BOTTOM", self, 0, -65)
      text = string.format([[
%s
%s]], text, locale.housing.incompleted_warning)
    else
      self.descConsumeLabel:AddAnchor("BOTTOM", self, 0, -65)
      self.descConsumeLabel:SetExtent(TEXTBOX_WIDTH, 20)
    end
    self.descConsumeLabel:SetText(text)
  end
  return window
end
