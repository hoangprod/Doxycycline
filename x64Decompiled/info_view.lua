local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local MAX_GROWABLE_LIST = 60
MAX_INFO_TAB = 9
MAX_INFO_CONTENT = 6
function SetViewOfCommonFarmInfoWindow()
  local w = CreateWindow("farm_info")
  w:SetExtent(commonFarmLocale.infoWindowWidth, 591)
  w:SetSounds("common_farm_info")
  local line_first, line_second = CreateLine(w, "TYPE2", "overlay")
  line_first:SetWidth(commonFarmLocale.infoWindowWidth / 2)
  line_first:AddAnchor("TOPLEFT", w, 0, titleMargin)
  line_second:SetWidth(commonFarmLocale.infoWindowWidth / 2)
  line_second:AddAnchor("TOPRIGHT", w, 0, titleMargin)
  local growableCount = w:CreateChildWidget("label", "growableCount", 0, true)
  growableCount:AddAnchor("TOPRIGHT", w, -sideMargin, titleMargin + 12)
  growableCount:SetHeight(FONT_SIZE.LARGE)
  growableCount:SetAutoResize(true)
  ApplyTextColor(growableCount, FONT_COLOR.BLUE)
  local growableTitle = w:CreateChildWidget("label", "growableTitle", 0, true)
  growableTitle:AddAnchor("TOPLEFT", w, sideMargin, titleMargin + 12)
  growableTitle:SetHeight(FONT_SIZE.LARGE)
  growableTitle:SetAutoResize(true)
  growableTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(growableTitle, FONT_COLOR.TITLE)
  local xOffset = -5
  local yOffset = 10
  local contentWidth = (w:GetWidth() - sideMargin * 2) / 3
  for i = 1, MAX_INFO_TAB do
    local content = w:CreateChildWidget("textbox", "content", i, true)
    content:Show(true)
    content:SetExtent(contentWidth, 135)
    content:SetInset(12, 13, 12, 10)
    content:AddAnchor("TOPLEFT", growableTitle, "BOTTOMLEFT", xOffset, yOffset)
    content.style:SetAlign(ALIGN_TOP_LEFT)
    content.style:SetFontSize(commonFarmLocale.contentFontSize)
    ApplyTextColor(content, FONT_COLOR.DEFAULT)
    local bg = CreateContentBackground(content, "TYPE1", "brown")
    bg:AddAnchor("TOPLEFT", content, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", content, 0, 0)
    xOffset = xOffset + contentWidth + 5
    if i % 3 == 0 then
      xOffset = -5
      yOffset = yOffset + 135
    end
  end
  for i = 1, MAX_GROWABLE_LIST do
    w:CreateChildWidget("label", "growableLists", i, true)
    w:Show(false)
  end
  local okBtn = w:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:SetText(locale.common.ok)
  okBtn:AddAnchor("BOTTOM", w, 0, -sideMargin)
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  local protectTime = w:CreateChildWidget("label", "protectTime", 0, true)
  protectTime:SetHeight(FONT_SIZE.MIDDLE)
  protectTime:SetAutoResize(true)
  protectTime:AddAnchor("BOTTOM", okBtn, "TOP", 0, -sideMargin / 1.5)
  ApplyTextColor(protectTime, FONT_COLOR.GRAY)
  return w
end
