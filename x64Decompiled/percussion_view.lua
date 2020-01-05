function CreatePercussionTabPage(percussionWnd)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local CONTENTS_WIDTH = 510 - sideMargin * 2
  local childs = {}
  local title = percussionWnd:CreateChildWidget("textbox", "title", 0, true)
  title:SetText(GetUIText(COMPOSITION_TEXT, "percussion_title"))
  title:SetExtent(CONTENTS_WIDTH, FONT_SIZE.LARGE)
  title:AddAnchor("TOP", percussionWnd, 0, 10)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  local exampleImg = percussionWnd:CreateDrawable(TEXTURE_PATH.COMPOSITION, "example", "background")
  exampleImg:AddAnchor("TOP", title, "BOTTOM", 0, sideMargin / 2)
  local codeInfoTable = {
    "percussion_bass_drum",
    "percussion_snare_drum",
    "percussion_high_hat",
    "percussion_tam_tam",
    "percussion_mid_tam",
    "percussion_crash_cymbal",
    "percussion_hight_tam",
    "percussion_ride_cymbal"
  }
  local codePart = percussionWnd:CreateChildWidget("emptyWidget", "codePart", 0, true)
  codePart:SetExtent(CONTENTS_WIDTH, 50)
  codePart:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, exampleImg:GetHeight() + sideMargin)
  local itemCntPerLine = 4
  local itemWidth = percussionWnd:GetWidth() / itemCntPerLine + 3
  local itemHeight = 81
  for i = 1, #codeInfoTable do
    local codeInfo = codeInfoTable[i]
    local codeItem = codePart:CreateChildWidget("emptyWidget", "codeItem", i, true)
    codeItem:SetExtent(itemWidth, itemHeight)
    local offsetX = (i - 1) % itemCntPerLine * itemWidth + -5
    local offsetY = math.floor((i - 1) / itemCntPerLine) * itemHeight
    codeItem:AddAnchor("TOPLEFT", codePart, offsetX, offsetY)
    local bg = CreateContentBackground(codeItem, "TYPE2", "brown")
    bg:AddAnchor("TOPLEFT", codeItem, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", codeItem, 0, 0)
    local codeImg = codeItem:CreateDrawable(TEXTURE_PATH.COMPOSITION, codeInfo, "background")
    codeImg:AddAnchor("TOP", codeItem, "TOP", 0, 5)
    local codeName = codeItem:CreateChildWidget("textbox", "codeName", 0, true)
    codeName:SetExtent(itemWidth, FONT_SIZE.MIDDLE)
    codeName:AddAnchor("TOP", codeImg, "BOTTOM", 0, 3)
    codeName.style:SetFontSize(FONT_SIZE.MIDDLE)
    codeName.style:SetAlign(ALIGN_CENTER)
    codeName:SetText(GetUIText(COMPOSITION_TEXT, codeInfo))
    ApplyTextColor(codeName, FONT_COLOR.DEFAULT)
    local codeDesc = codeItem:CreateChildWidget("textbox", "codeDesc", 0, true)
    codeDesc:SetExtent(itemWidth, FONT_SIZE.MIDDLE)
    codeDesc:AddAnchor("TOP", codeName, "BOTTOM", 0, 3)
    codeDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
    codeName.style:SetAlign(ALIGN_CENTER)
    local syllableKey = string.format("%s_syllable", codeInfo)
    local str = string.format("%s%s", FONT_COLOR_HEX.BLUE, GetUIText(COMPOSITION_TEXT, syllableKey))
    codeDesc:SetText(str)
    ApplyTextColor(codeDesc, FONT_COLOR.DEFAULT)
  end
  local _, height = F_LAYOUT.GetExtentWidgets(codePart.codeItem[1], codePart.codeItem[8])
  codePart:SetHeight(height)
  local infoMsg = percussionWnd:CreateChildWidget("textbox", "infoMsg", 0, true)
  infoMsg:SetExtent(CONTENTS_WIDTH - 15, FONT_SIZE.MIDDLE)
  infoMsg:AddAnchor("TOPLEFT", codePart, "BOTTOMLEFT", 15, 5)
  infoMsg.style:SetFontSize(FONT_SIZE.MIDDLE)
  infoMsg.style:SetAlign(ALIGN_LEFT)
  infoMsg:SetText(GetUIText(COMPOSITION_TEXT, "percussion_info_msg"))
  ApplyTextColor(infoMsg, FONT_COLOR.DEFAULT)
  W_ICON.DrawRoundDingbat(infoMsg)
  infoMsg.dingbat:RemoveAllAnchors()
  infoMsg.dingbat:AddAnchor("RIGHT", infoMsg, "LEFT", -1, 0)
  local exampleSection = percussionWnd:CreateChildWidget("emptyWidget", "exampleSection", 0, false)
  exampleSection:SetWidth(CONTENTS_WIDTH)
  exampleSection:AddAnchor("TOP", codePart, "BOTTOM", 0, infoMsg:GetHeight() + sideMargin)
  local example = percussionWnd:CreateChildWidget("textbox", "example", 0, true)
  example:SetText(locale.composition.title.example)
  example:SetExtent(CONTENTS_WIDTH, FONT_SIZE.LARGE)
  example:AddAnchor("TOPLEFT", exampleSection, 0, 0)
  example.style:SetAlign(ALIGN_LEFT)
  example.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(example, FONT_COLOR.MIDDLE_TITLE)
  local exampleImg = percussionWnd:CreateDrawable(TEXTURE_PATH.COMPOSITION, "percussion_example", "background")
  exampleImg:AddAnchor("TOP", example, "BOTTOM", 0, sideMargin / 2)
  exampleSection:SetHeight(example:GetHeight() + exampleImg:GetHeight() + sideMargin / 2)
  function percussionWnd:GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(title, exampleSection)
    return height
  end
end
