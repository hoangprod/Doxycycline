local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local DrawOptionValueTexture = function(widget)
  local bg = widget:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", widget, -3, -6)
  bg:AddAnchor("BOTTOMRIGHT", widget, 5, 6)
end
function CreateEtcPageWindow(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  window:AddAnchor("TOPLEFT", parent, 0, 0)
  window:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  window:SetTitleText(locale.chatFiltering.menuName[4])
  window.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  window.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTitleFontColor(window, FONT_COLOR.TITLE)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local setFontSizeLabel = window:CreateChildWidget("label", "setFontSizeLabel", 0, true)
  setFontSizeLabel:SetHeight(13)
  setFontSizeLabel:SetAutoResize(true)
  setFontSizeLabel:AddAnchor("TOPLEFT", window, 0, sideMargin * 1.5)
  setFontSizeLabel:SetText(locale.chatFiltering.setFontSize)
  ApplyTextColor(setFontSizeLabel, FONT_COLOR.DEFAULT)
  local fontSizeScroll = CreateSlider(id .. ".fontSizeScroll", setFontSizeLabel)
  fontSizeScroll:SetStep(1)
  fontSizeScroll:SetInitialValue(1, false)
  fontSizeScroll:UseWheel()
  if chatLocale.chatOption.fontSizeOption == true then
    fontSizeScroll:SetMinMaxValues(12, 17)
  else
    fontSizeScroll:SetMinMaxValues(1, 5)
  end
  fontSizeScroll:AddAnchor("TOPLEFT", setFontSizeLabel, "BOTTOMLEFT", 0, 5)
  fontSizeScroll:AddAnchor("RIGHT", window, 0, 0)
  window.fontSizeScroll = fontSizeScroll
  local thumbWidth = fontSizeScroll.thumb:GetWidth()
  for i = 1, #chatLocale.chatOption.fontSizeText do
    local offsetX = (fontSizeScroll:GetWidth() - thumbWidth) / (#chatLocale.chatOption.fontSizeText - 1) * (i - 1)
    local sizeLabel = window:CreateChildWidget("label", "sizeLabel", i, true)
    sizeLabel:SetExtent(17, FONT_SIZE.MIDDLE)
    sizeLabel:SetText(chatLocale.chatOption.fontSizeText[i])
    sizeLabel.style:SetAlign(ALIGN_CENTER)
    sizeLabel:AddAnchor("TOPLEFT", window.fontSizeScroll, "BOTTOMLEFT", offsetX, 2)
    ApplyTextColor(sizeLabel, FONT_COLOR.DEFAULT)
  end
  local defaultAlphaLabel = W_CTRL.CreateLabel(id .. ".defaultAlphaLabel", window)
  defaultAlphaLabel:SetHeight(FONT_SIZE.MIDDLE)
  defaultAlphaLabel:SetAutoResize(true)
  defaultAlphaLabel:AddAnchor("TOPLEFT", window.fontSizeScroll, "BOTTOMLEFT", 0, sideMargin * 1.5)
  defaultAlphaLabel:SetText(locale.chatFiltering.setBGAlpha)
  local defaultAlphaScroll = CreateSlider(id .. ".defaultAlphaScroll", setFontSizeLabel)
  defaultAlphaScroll:SetInitialValue(50, false)
  defaultAlphaScroll:SetMinMaxValues(0, 100)
  defaultAlphaScroll:UseWheel()
  defaultAlphaScroll:AddAnchor("TOPLEFT", defaultAlphaLabel, "BOTTOMLEFT", 0, 5)
  defaultAlphaScroll:AddAnchor("RIGHT", window, -(sideMargin * 2), 0)
  window.defaultAlphaScroll = defaultAlphaScroll
  local defaultAlphaPercent = window:CreateChildWidget("label", "defaultAlphaPercent", 0, true)
  defaultAlphaPercent:SetExtent(30, 20)
  defaultAlphaPercent:AddAnchor("LEFT", window.defaultAlphaScroll, "RIGHT", 7, 0)
  defaultAlphaPercent.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(defaultAlphaPercent, FONT_COLOR.BLUE)
  DrawOptionValueTexture(defaultAlphaPercent)
  local offsetY = 2
  for i = 1, #locale.chatFiltering.percent do
    local percentLabel = W_CTRL.CreateLabel(id .. ".percentLabel" .. i, window.defaultAlphaScroll)
    percentLabel:SetHeight(FONT_SIZE.MIDDLE)
    percentLabel:SetAutoResize(true)
    percentLabel:SetText(locale.chatFiltering.percent[i])
    if i == 1 then
      percentLabel:AddAnchor("TOPLEFT", window.defaultAlphaScroll, "BOTTOMLEFT", 4, offsetY)
    else
      percentLabel:AddAnchor("TOPRIGHT", window.defaultAlphaScroll, "BOTTOMRIGHT", -2, offsetY)
    end
  end
  local overAlphaLabel = W_CTRL.CreateLabel(id .. ".overAlphaLabel", window)
  overAlphaLabel:SetHeight(FONT_SIZE.MIDDLE)
  overAlphaLabel:SetAutoResize(true)
  overAlphaLabel:AddAnchor("TOPLEFT", defaultAlphaScroll, "BOTTOMLEFT", 0, sideMargin * 1.5)
  overAlphaLabel:SetText(locale.chatFiltering.overAlpha)
  local overlAlphaScroll = CreateSlider(id .. ".overlAlphaScroll", setFontSizeLabel)
  overlAlphaScroll:SetMinMaxValues(0, 100)
  overlAlphaScroll:SetInitialValue(50, false)
  overlAlphaScroll:UseWheel()
  overlAlphaScroll:AddAnchor("TOPLEFT", overAlphaLabel, "BOTTOMLEFT", 0, 5)
  overlAlphaScroll:AddAnchor("RIGHT", window, -(sideMargin * 2), 0)
  window.overlAlphaScroll = overlAlphaScroll
  local overAlphaPercent = window:CreateChildWidget("label", "overAlphaPercent", 0, true)
  overAlphaPercent:SetExtent(30, 20)
  overAlphaPercent:AddAnchor("LEFT", window.overlAlphaScroll, "RIGHT", 7, 0)
  overAlphaPercent.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(overAlphaPercent, FONT_COLOR.BLUE)
  DrawOptionValueTexture(overAlphaPercent)
  for i = 1, #locale.chatFiltering.percent do
    local percentLabel = W_CTRL.CreateLabel(id .. ".percentLabel" .. i, window.overlAlphaScroll)
    percentLabel:SetHeight(FONT_SIZE.MIDDLE)
    percentLabel:SetAutoResize(true)
    percentLabel:SetText(locale.chatFiltering.percent[i])
    if i == 1 then
      percentLabel:AddAnchor("TOPLEFT", window.overlAlphaScroll, "BOTTOMLEFT", 4, offsetY)
    else
      percentLabel:AddAnchor("TOPRIGHT", window.overlAlphaScroll, "BOTTOMRIGHT", -2, offsetY)
    end
  end
  local setBGColorLabel = window:CreateChildWidget("label", "setBGColorLabel", 0, true)
  setBGColorLabel:SetHeight(FONT_SIZE.MIDDLE)
  setBGColorLabel:SetAutoResize(true)
  setBGColorLabel:AddAnchor("TOPLEFT", overlAlphaScroll, "BOTTOMLEFT", 0, sideMargin * 1.5)
  setBGColorLabel:SetText(locale.chatFiltering.setBGColor)
  ApplyTextColor(setBGColorLabel, FONT_COLOR.DEFAULT)
  local bgColorButton = CreateColorPickButtons(id .. "bgColorButton", window)
  bgColorButton:SetExtent(23, 15)
  bgColorButton:AddAnchor("LEFT", setBGColorLabel, "RIGHT", 5, 0)
  window.bgColorButton = bgColorButton
  return window
end
