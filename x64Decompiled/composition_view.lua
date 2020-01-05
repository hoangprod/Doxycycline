function CreateNormalTabPage(tabWindow)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local CONTENTS_WIDTH = 510 - sideMargin * 2
  local ITEM_HEIGHT = 35
  local AddDivisionLine = function(widget, offsetY)
    if offsetY == nil then
      offsetY = 0
    end
    local line = CreateLine(widget, "TYPE1")
    line:AddAnchor("BOTTOMLEFT", widget, 0, offsetY)
    line:AddAnchor("BOTTOMRIGHT", widget, 0, offsetY)
    line:SetColor(1, 1, 1, 0.5)
  end
  local function CreateContetFrameForType(id, titleStr, tipStr)
    local contentFrame = tabWindow:CreateChildWidget("emptywidget", id, 0, true)
    contentFrame:SetWidth(CONTENTS_WIDTH)
    local title = contentFrame:CreateChildWidget("textbox", "title", 0, true)
    title:SetText(titleStr)
    title:SetExtent(CONTENTS_WIDTH, FONT_SIZE.LARGE)
    title:AddAnchor("TOP", contentFrame, 0, 0)
    title.style:SetAlign(ALIGN_LEFT)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    local tip = contentFrame:CreateChildWidget("label", "tip", 0, false)
    tip:SetAutoResize(true)
    tip:SetHeight(FONT_SIZE.SMALL)
    tip:SetText(tipStr)
    tip.style:SetFontSize(FONT_SIZE.SMALL)
    tip:AddAnchor("TOPRIGHT", contentFrame, 0, 4)
    ApplyTextColor(tip, FONT_COLOR.DEFAULT)
  end
  local function CreateCommonContent(parent, labelStrs)
    local ITEM_CNT = 4
    local itemWidth = CONTENTS_WIDTH / ITEM_CNT
    local itemOffsetY = parent.title:GetHeight() + 5
    local lastCreatedWidget
    for i = 1, #labelStrs do
      local label = parent:CreateChildWidget("textbox", "label", i, false)
      local offsetX = (i - 1) % ITEM_CNT * itemWidth
      local offsetY = itemOffsetY + math.floor((i - 1) / ITEM_CNT) * ITEM_HEIGHT
      label:SetExtent(itemWidth, ITEM_HEIGHT)
      label:AddAnchor("TOPLEFT", parent, offsetX, offsetY)
      label.style:SetFontSize(FONT_SIZE.LARGE)
      lastCreatedWidget = label
      local str = string.format("%s %s%s", labelStrs[i], FONT_COLOR_HEX.BLUE, locale.composition.values[i])
      label:SetText(str)
      ApplyTextColor(label, FONT_COLOR.DEFAULT)
      local bg = CreateContentBackground(label, "TYPE2", "brown")
      bg:AddAnchor("TOPLEFT", label, 0, 0)
      bg:AddAnchor("BOTTOMRIGHT", label, 0, 0)
    end
    local _, height = F_LAYOUT.GetExtentWidgets(parent.title, lastCreatedWidget)
    parent:SetHeight(height + sideMargin / 2)
  end
  CreateContetFrameForType("noteContentFrame", locale.composition.title.syllableNames, locale.composition.inputGuide.syllableNames)
  local itemWidth = CONTENTS_WIDTH / #locale.composition.noteKorean
  local itemOffsetY = tabWindow.noteContentFrame.title:GetHeight() + 5
  for i = 1, #locale.composition.noteKorean do
    local noteLabel = tabWindow.noteContentFrame:CreateChildWidget("label", "noteLabel", i, false)
    noteLabel:SetExtent(itemWidth, ITEM_HEIGHT)
    noteLabel:AddAnchor("TOPLEFT", tabWindow.noteContentFrame, (i - 1) * itemWidth, itemOffsetY)
    noteLabel.style:SetFontSize(FONT_SIZE.LARGE)
    tabWindow.noteContentFrame.noteLabel = noteLabel
    local str = string.format("%s %s", locale.composition.noteKorean[i], locale.composition.noteEnglish[i])
    noteLabel:SetText(str)
    ApplyTextColor(noteLabel, FONT_COLOR.DEFAULT)
    local bg = CreateContentBackground(noteLabel, "TYPE2", "brown")
    bg:AddAnchor("TOPLEFT", noteLabel, 1, 0)
    bg:AddAnchor("BOTTOMRIGHT", noteLabel, -1, 0)
  end
  local _, height = F_LAYOUT.GetExtentWidgets(tabWindow.noteContentFrame.title, tabWindow.noteContentFrame.noteLabel)
  tabWindow.noteContentFrame:SetHeight(height + sideMargin / 2)
  tabWindow.noteContentFrame:AddAnchor("TOP", tabWindow, 0, sideMargin / 2)
  AddDivisionLine(tabWindow.noteContentFrame)
  local str = string.format("%s (%s%s%s|r)", locale.composition.title.noteLength, locale.composition.syllableNames, FONT_COLOR_HEX.BLUE, "n")
  CreateContetFrameForType("noteLengthContentFrame", str, locale.composition.inputGuide.noteLength)
  CreateCommonContent(tabWindow.noteLengthContentFrame, locale.composition.notes)
  tabWindow.noteLengthContentFrame:AddAnchor("TOP", tabWindow.noteContentFrame, "BOTTOM", 0, sideMargin / 2)
  AddDivisionLine(tabWindow.noteLengthContentFrame)
  local str = string.format("%s (%s%s%s|r)", locale.composition.title.restLength, "R", FONT_COLOR_HEX.BLUE, "n")
  CreateContetFrameForType("restLengthContentFrame", str, locale.composition.inputGuide.restLength)
  lastCreatedWidget = CreateCommonContent(tabWindow.restLengthContentFrame, locale.composition.rests)
  tabWindow.restLengthContentFrame:AddAnchor("TOP", tabWindow.noteLengthContentFrame, "BOTTOM", 0, sideMargin / 2)
  AddDivisionLine(tabWindow.restLengthContentFrame)
  CreateContetFrameForType("etcContentFrame", locale.composition.title.etc, "", false)
  tabWindow.etcContentFrame:AddAnchor("TOP", tabWindow.restLengthContentFrame, "BOTTOM", 0, sideMargin / 2)
  local values = {
    "O",
    "V",
    "L",
    "T"
  }
  local ITEM_CNT = 2
  local bgMargin = sideMargin / 2
  local inset = 5
  local subContentOffsetX = 3
  local itemWidth = CONTENTS_WIDTH / ITEM_CNT
  local itemOffsetY = tabWindow.etcContentFrame.title:GetHeight() + 5
  for i = 1, #locale.composition.etcs do
    local subItem = tabWindow.etcContentFrame:CreateChildWidget("emptywidget", "subItem", i, true)
    local offsetX = (i - 1) % ITEM_CNT * itemWidth
    local itemHeight = 0
    local upperSubItemIndex = math.floor((i - 1) / ITEM_CNT) + 1
    if upperSubItemIndex > 1 and tabWindow.etcContentFrame.subItem[upperSubItemIndex] then
      itemHeight = tabWindow.etcContentFrame.subItem[upperSubItemIndex]:GetHeight()
    end
    local offsetY = itemOffsetY + math.floor((i - 1) / ITEM_CNT) * itemHeight
    subItem:SetExtent(itemWidth, 50)
    subItem:AddAnchor("TOPLEFT", tabWindow.etcContentFrame, offsetX, offsetY)
    local subTitle = subItem:CreateChildWidget("textbox", "subTitle", 0, true)
    subTitle:SetExtent(itemWidth - bgMargin * 2, FONT_SIZE.LARGE)
    subTitle:AddAnchor("TOPLEFT", subItem, bgMargin, bgMargin)
    subTitle.style:SetFontSize(FONT_SIZE.LARGE)
    subTitle.style:SetAlign(ALIGN_LEFT)
    local str = string.format("%s (%s%sn|r)", locale.composition.etcs[i], values[i], FONT_COLOR_HEX.BLUE)
    subTitle:SetText(str)
    ApplyTextColor(subTitle, FONT_COLOR.DEFAULT)
    local lastContent
    local dingbatInset = 13
    for k = 1, #locale.composition.etcDesc[i] do
      local content = subItem:CreateChildWidget("textbox", "content", k, true)
      content:SetText(locale.composition.etcDesc[i][k])
      content:SetWidth(itemWidth - dingbatInset - bgMargin * 2)
      content:SetHeight(content:GetTextHeight())
      content.style:SetAlign(ALIGN_TOP_LEFT)
      ApplyTextColor(content, FONT_COLOR.DEFAULT)
      local subContetOffsetY = subTitle:GetHeight() + inset
      if k > 1 then
        subContetOffsetY = subContetOffsetY + subItem.content[k - 1]:GetTextHeight() + inset
      end
      content:AddAnchor("TOPLEFT", subTitle, dingbatInset + subContentOffsetX, subContetOffsetY)
      lastContent = content
      W_ICON.DrawRoundDingbat(content)
      content.dingbat:RemoveAllAnchors()
      content.dingbat:AddAnchor("TOPRIGHT", content, "TOPLEFT", -3, FORM_COMPOSITION_METHOD.DINGBET_OFFSET)
    end
    local _, subItemHeight = F_LAYOUT.GetExtentWidgets(subTitle, lastContent)
    local bg = CreateContentBackground(subItem, "TYPE2", "brown")
    local subItemBottomMargin = bgMargin * 2
    subItem.bg = bg
    if i % ITEM_CNT == 0 then
      local lastSubItem = tabWindow.etcContentFrame.subItem[i - 1]
      if i > 1 and subItemHeight + subItemBottomMargin > lastSubItem:GetHeight() then
        lastSubItem.bg:RemoveAllAnchors()
        lastSubItem:SetHeight(subItemHeight + subItemBottomMargin)
        lastSubItem.bg:AddAnchor("TOPLEFT", lastSubItem, 0, 0)
        lastSubItem.bg:AddAnchor("BOTTOMRIGHT", lastSubItem, 0, 0)
      else
        subItemHeight = lastSubItem:GetHeight() - subItemBottomMargin
      end
    end
    subItem:SetHeight(subItemHeight + subItemBottomMargin)
    bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
  end
  local lastSubItem = tabWindow.etcContentFrame:CreateChildWidget("emptywidget", "subItem", 5, true)
  lastSubItem:SetExtent(CONTENTS_WIDTH, 50)
  local attachSubItem = tabWindow.etcContentFrame.subItem[3]
  lastSubItem:AddAnchor("TOPLEFT", attachSubItem, "BOTTOMLEFT", 0, 0)
  local subTitle = lastSubItem:CreateChildWidget("textbox", "subTitle", 0, true)
  subTitle:SetExtent(CONTENTS_WIDTH - bgMargin * 2, FONT_SIZE.LARGE)
  subTitle:AddAnchor("TOPLEFT", lastSubItem, bgMargin, bgMargin)
  subTitle.style:SetFontSize(FONT_SIZE.LARGE)
  subTitle.style:SetAlign(ALIGN_LEFT)
  local str = string.format("%s (%s,|r)", X2Locale:LocalizeUiText(COMPOSITION_TEXT, "chord"), FONT_COLOR_HEX.BLUE)
  subTitle:SetText(str)
  ApplyTextColor(subTitle, FONT_COLOR.DEFAULT)
  local content = lastSubItem:CreateChildWidget("textbox", "content", 0, true)
  content:SetText(X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc5"))
  content:SetWidth(CONTENTS_WIDTH - 15 - bgMargin * 2)
  content:SetHeight(content:GetTextHeight())
  content.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  content:AddAnchor("TOPLEFT", subTitle, "BOTTOMLEFT", 15 + subContentOffsetX, inset)
  W_ICON.DrawRoundDingbat(content)
  content.dingbat:RemoveAllAnchors()
  content.dingbat:AddAnchor("TOPRIGHT", content, "TOPLEFT", -3, FORM_COMPOSITION_METHOD.DINGBET_OFFSET)
  local _, subItemHeight = F_LAYOUT.GetExtentWidgets(subTitle, content)
  local subItemBottomMargin = bgMargin * 2
  lastSubItem:SetHeight(subItemHeight + subItemBottomMargin)
  local bg = CreateContentBackground(lastSubItem, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", lastSubItem, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", lastSubItem, 0, 0)
  local _, etcFrameHeight = F_LAYOUT.GetExtentWidgets(tabWindow.etcContentFrame.title, tabWindow.etcContentFrame.subItem[5])
  tabWindow.etcContentFrame:SetHeight(etcFrameHeight)
  CreateContetFrameForType("exampleContentFrame", locale.composition.title.example, "", false)
  tabWindow.exampleContentFrame:AddAnchor("TOP", tabWindow.etcContentFrame, "BOTTOM", 0, sideMargin / 2)
  local exampleImg = tabWindow.exampleContentFrame:CreateDrawable(TEXTURE_PATH.COMPOSITION, "composition", "background")
  exampleImg:AddAnchor("TOPLEFT", tabWindow.exampleContentFrame, 0, sideMargin * 1.2)
  tabWindow.exampleContentFrame:SetHeight(tabWindow.exampleContentFrame.title:GetHeight() + exampleImg:GetHeight() + sideMargin / 2)
  function tabWindow:GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(tabWindow.noteContentFrame, tabWindow.exampleContentFrame)
    return height
  end
end
