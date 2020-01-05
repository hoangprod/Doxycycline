function SetViewOfRefurbishmentWindow(tabWindow)
  CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "item_scale"))
  local extent, anchor
  local magicSquare = tabWindow:CreateChildWidget("emptywidget", "magicSquare", 0, true)
  magicSquare:AddAnchor("TOP", tabWindow, 0, 0)
  magicSquare:SetExtent(470, 300)
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "line_triangle", "background")
  bg:AddAnchor("TOPLEFT", magicSquare, "TOPLEFT", 160, 115)
  local ratioFrame = tabWindow:CreateChildWidget("emptywidget", "ratioFrame", 0, true)
  ratioFrame:SetExtent(163, 52)
  ratioFrame:AddAnchor("TOPLEFT", tabWindow, 153, 136)
  tabWindow.ratioFrame = ratioFrame
  local ratioBg = ratioFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  ratioBg:SetTextureColor("team_blue")
  ratioBg:AddAnchor("TOPLEFT", ratioFrame)
  ratioBg:AddAnchor("BOTTOMRIGHT", ratioFrame)
  local ratioTitle = ratioFrame:CreateChildWidget("textbox", "ratioTitle", 0, true)
  ratioTitle:SetExtent(75, FONT_SIZE.LARGE)
  ratioTitle:SetText(GetCommonText("success_rate"))
  ratioTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ratioTitle.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(ratioTitle, FONT_COLOR.BLUE)
  ratioTitle:AddAnchor("LEFT", ratioFrame, 12, 0)
  local ratioValue = ratioFrame:CreateChildWidget("textbox", "ratioValue", 0, true)
  ratioValue:SetExtent(75, FONT_SIZE.XLARGE)
  ratioValue.style:SetFontSize(FONT_SIZE.XLARGE)
  ratioValue.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(ratioValue, FONT_COLOR.BLUE)
  ratioValue:AddAnchor("RIGHT", ratioFrame, -12, 0)
  ratioFrame.ratioValue = ratioValue
  local realRatioGmOnly = ratioFrame:CreateChildWidget("textbox", "realRatioGmOnly", 0, true)
  realRatioGmOnly:SetExtent(100, 100)
  realRatioGmOnly:SetAutoResize(true)
  realRatioGmOnly.style:SetFontSize(FONT_SIZE.SMALL)
  realRatioGmOnly.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(realRatioGmOnly, FONT_COLOR.BLUE)
  realRatioGmOnly:AddAnchor("TOPRIGHT", tabWindow, 0, 0)
  tabWindow.realRatioGmOnly = realRatioGmOnly
  anchor = FORM_ENCHANT_WINDOW.GUIDE_ICON_ANCHOR
  local guide = W_ICON.CreateGuideIconWidget(tabWindow)
  guide:AddAnchor("TOPRIGHT", tabWindow, anchor[1], anchor[2])
  tabWindow.guide = guide
  local slotTargetItem = CreateTargetSlot(magicSquare, GetUIText(COMMON_TEXT, "grade_enchant_item"))
  slotTargetItem:AddAnchor("TOP", magicSquare, 2, 45)
  tabWindow.slotTargetItem = slotTargetItem
  local slotEnchantItem = CreateItemEnchantDefaultSlot("slotEnchantItem", magicSquare, GetCommonText("tetrahedron"), FONT_COLOR.PURPLE)
  slotEnchantItem:AddAnchor("BOTTOMLEFT", magicSquare, "BOTTOMLEFT", 103, -40)
  tabWindow.slotEnchantItem = slotEnchantItem
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "enchant_slot_bg", "background")
  bg:AddAnchor("CENTER", slotEnchantItem, -1, -12)
  slotEnchantItem.bg = bg
  local slotSupportItem = CreateItemEnchantDefaultSlot("slotSupportItem", magicSquare, GetCommonText("grade_enchant_support_item"), FONT_COLOR.ROLE_NONE)
  slotSupportItem:AddAnchor("BOTTOMRIGHT", magicSquare, "BOTTOMRIGHT", -103, -40)
  slotSupportItem:RegisterForClicks("RightButton")
  slotSupportItem.tooltip = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM.TOOLTIP
  tabWindow.slotSupportItem = slotSupportItem
  function slotSupportItem:ApplyAlpha(value)
    self:SetAlpha(value)
    self.bg:SetColor(1, 1, 1, value)
  end
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "support_slot_bg", "background")
  bg:AddAnchor("CENTER", slotSupportItem, -1, -11)
  slotSupportItem.bg = bg
  local CreateSuccessFrame = function(parent, name, titleText, arrowType)
    local successFrame = parent:CreateChildWidget("emptywidget", name, 0, true)
    successFrame:SetExtent(237, 80)
    successFrame:AddAnchor("TOPLEFT", parent, "BOTTOMLEFT", 0, 0)
    local bg = CreateContentBackground(successFrame, "TYPE10", "blue")
    bg:AddAnchor("TOPLEFT", successFrame, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", successFrame, 0, 0)
    local title = successFrame:CreateChildWidget("label", name .. "Title", 0, true)
    title:AddAnchor("TOPLEFT", bg, 13, 11)
    title:SetExtent(210, 13)
    title:SetText(titleText)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(title, FONT_COLOR.DEFAULT)
    local line = CreateLine(title, "TYPE7")
    line:SetExtent(220, 3)
    line:AddAnchor("TOPLEFT", bg, 8, 29)
    local icon = successFrame:CreateDrawable(TEXTURE_PATH.ICON_PERFORMANCE, "performance", "background")
    icon:AddAnchor("LEFT", successFrame, "LEFT", 15, 12)
    successFrame.icon = icon
    local before = successFrame:CreateChildWidget("textbox", name .. "Before", 0, true)
    before:SetExtent(36, FONT_SIZE.LARGE)
    before.style:SetFontSize(FONT_SIZE.LARGE)
    before.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(before, FONT_COLOR.DEFAULT)
    before:AddAnchor("LEFT", icon, "RIGHT", 22, 0)
    successFrame.before = before
    local anchor = {
      single_arrow = {14, 0},
      double_arrow = {3, 0}
    }
    local arrow = successFrame:CreateDrawable(TEXTURE_PATH.HUD, arrowType, "background")
    arrow:SetTextureColor("default_brown")
    arrow:AddAnchor("LEFT", before, "RIGHT", anchor[arrowType][1], anchor[arrowType][2])
    successFrame.arrow = arrow
    anchor = {
      single_arrow = {15, 0},
      double_arrow = {0, 0}
    }
    local after = successFrame:CreateChildWidget("textbox", name .. "After", 0, true)
    after:SetExtent(36, FONT_SIZE.LARGE)
    after.style:SetFontSize(FONT_SIZE.LARGE)
    after.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(after, FONT_COLOR.DEFAULT)
    after:AddAnchor("LEFT", arrow, "RIGHT", anchor[arrowType][1], anchor[arrowType][2])
    successFrame.after = after
    function successFrame:SetEnchantInfo(enchantInfo, afterScale)
      local visible = enchantInfo ~= nil
      if enchantInfo ~= nil then
        local before = enchantInfo.beforeScale
        if before == "none" then
          before = "+0"
        end
        local after = enchantInfo[afterScale]
        if after ~= nil then
          self.before:SetText(before)
          self.after:SetText(after)
        else
          visible = false
        end
      end
      self.before:Show(visible)
      self.after:Show(visible)
      self.icon:Show(visible)
      self.arrow:Show(visible)
    end
    return successFrame
  end
  local successFrame = CreateSuccessFrame(magicSquare, "successFrame", GetCommonText("enchant_scale_success_title"), "single_arrow")
  tabWindow.successFrame = successFrame
  local successGreatFrame = CreateSuccessFrame(successFrame, "successGreatFrame", GetCommonText("enchant_scale_great_success_title"), "double_arrow")
  tabWindow.successGreatFrame = successGreatFrame
  local failFrame = magicSquare:CreateChildWidget("emptywidget", "failFrame", 0, true)
  failFrame:SetExtent(234, 160)
  failFrame:AddAnchor("TOPRIGHT", magicSquare, "BOTTOMRIGHT", 0, 0)
  tabWindow.failFrame = failFrame
  local failBg = CreateContentBackground(tabWindow, "TYPE10", "red")
  failBg:AddAnchor("TOPLEFT", failFrame, 0, 0)
  failBg:AddAnchor("BOTTOMRIGHT", failFrame, 0, 0)
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.COLOR
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.TEXT
  local failLabel = tabWindow:CreateChildWidget("label", "failLabel", 0, true)
  failLabel:AddAnchor("TOPLEFT", failBg, anchor[1], anchor[2])
  failLabel:SetExtent(extent[1], extent[2])
  failLabel:SetText(text)
  failLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(failLabel, color)
  local failLine = CreateLine(failLabel, "TYPE7")
  failLine:SetExtent(220, 3)
  failLine:AddAnchor("TOPLEFT", failBg, 8, 30)
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DESTROY_TEXT.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DESTROY_TEXT.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DESTROY_TEXT.COLOR
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DESTROY_TEXT.TEXT
  local destroyLabel = tabWindow:CreateChildWidget("label", "destroyLabel", 0, true)
  destroyLabel:AddAnchor("TOPLEFT", failLine, "BOTTOMLEFT", anchor[1], anchor[2])
  destroyLabel:SetExtent(extent[1], extent[2])
  destroyLabel:SetText(text)
  destroyLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  destroyLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(destroyLabel, color)
  tabWindow.destroyLabel = destroyLabel
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DOWNGRADE_TEXT.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DOWNGRADE_TEXT.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DOWNGRADE_TEXT.COLOR
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DOWNGRADE_TEXT.TEXT
  local downGradeLabel = tabWindow:CreateChildWidget("label", "downGradeLabel", 0, true)
  downGradeLabel:AddAnchor("TOPLEFT", destroyLabel, "BOTTOMLEFT", anchor[1], anchor[2])
  downGradeLabel:SetExtent(extent[1], extent[2])
  downGradeLabel:SetText(text)
  downGradeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  downGradeLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(downGradeLabel, color)
  tabWindow.downGradeLabel = downGradeLabel
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DISABLE_TEXT.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DISABLE_TEXT.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DISABLE_TEXT.COLOR
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.DISABLE_TEXT.TEXT
  local disableLabel = tabWindow:CreateChildWidget("label", "disableLabel", 0, true)
  disableLabel:AddAnchor("TOPLEFT", downGradeLabel, "BOTTOMLEFT", anchor[1], anchor[2])
  disableLabel:SetExtent(extent[1], extent[2])
  disableLabel:SetText(text)
  disableLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  disableLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(disableLabel, color)
  tabWindow.disableLabel = disableLabel
  local key = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_O.KEY
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_O.EXTENT
  color = FONT_COLOR.BLUE
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_POSSIBILITY.ICON_ANCHOR
  local result = destroyLabel:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, key, "background")
  result:AddAnchor("LEFT", destroyLabel, "RIGHT", anchor[1], anchor[2])
  result:SetExtent(extent[1], extent[2])
  ApplyTextureColor(result, color)
  destroyLabel.result = result
  result = downGradeLabel:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, key, "background")
  result:AddAnchor("LEFT", downGradeLabel, "RIGHT", anchor[1], anchor[2])
  result:SetExtent(extent[1], extent[2])
  ApplyTextureColor(result, color)
  downGradeLabel.result = result
  result = disableLabel:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, key, "background")
  result:AddAnchor("LEFT", disableLabel, "RIGHT", anchor[1], anchor[2])
  result:SetExtent(extent[1], extent[2])
  ApplyTextureColor(result, color)
  disableLabel.result = result
  local modifierFrame = tabWindow:CreateChildWidget("emptywidget", "modifierFrame", 0, true)
  modifierFrame:SetExtent(470, 76)
  modifierFrame:AddAnchor("TOPLEFT", successGreatFrame, "BOTTOMLEFT", 0, -4)
  local modifierBg = modifierFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  modifierBg:SetTextureColor("default")
  modifierBg:AddAnchor("TOPLEFT", modifierFrame, 0, 0)
  modifierBg:AddAnchor("BOTTOMRIGHT", modifierFrame, 0, 0)
  local modifierTitleBg = modifierFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  modifierTitleBg:SetTextureColor("default")
  modifierTitleBg:SetExtent(200, 76)
  modifierTitleBg:AddAnchor("TOPLEFT", modifierFrame, 0, 0)
  local scrollWnd = CreateScrollWindow(modifierFrame, "scroll", 0)
  scrollWnd:AddAnchor("TOPLEFT", modifierFrame, 0, 5)
  scrollWnd:AddAnchor("BOTTOMRIGHT", modifierFrame, 0, -5)
  scrollWnd.contentHeight = 165
  scrollWnd:ResetScroll(scrollWnd.contentHeight)
  scrollWnd:SetMiniThumbSkin(30)
  tabWindow.scrollWnd = scrollWnd
  local scrollDesc = scrollWnd.content:CreateChildWidget("emptywidget", "scrollDesc", 0, true)
  local sizeX, _ = scrollWnd.content:GetExtent()
  scrollDesc:SetExtent(sizeX, scrollWnd.contentHeight)
  scrollDesc:AddAnchor("TOPLEFT", scrollWnd.content, 0, 0)
  tabWindow.scrollDesc = scrollDesc
  local CreateModifierInfos = function(parent)
    parent.modifiers = {}
    local anchorTarget = parent
    for i = 1, 5 do
      local infoFrame = parent:CreateChildWidget("emptywidget", "infoFrame" .. i, 0, true)
      infoFrame:SetExtent(parent:GetWidth(), FONT_SIZE.LARGE)
      if anchorTarget == parent then
        infoFrame:AddAnchor("TOPLEFT", anchorTarget, 0, 10)
      else
        infoFrame:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, 15)
      end
      anchorTarget = infoFrame
      local title = infoFrame:CreateChildWidget("textbox", "title" .. i, 0, true)
      title:SetExtent(175, FONT_SIZE.LARGE)
      title:AddAnchor("LEFT", infoFrame, 13, 0)
      title.style:SetFontSize(FONT_SIZE.LARGE)
      title.style:SetAlign(ALIGN_CENTER)
      ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
      infoFrame.title = title
      local beforeValue = infoFrame:CreateChildWidget("textbox", "beforeValue" .. i, 0, true)
      beforeValue:SetExtent(60, FONT_SIZE.LARGE)
      beforeValue:AddAnchor("LEFT", title, "RIGHT", 45, 0)
      beforeValue.style:SetFontSize(FONT_SIZE.LARGE)
      beforeValue.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(beforeValue, FONT_COLOR.DEFAULT)
      infoFrame.beforeValue = beforeValue
      local arrow = infoFrame:CreateChildWidget("textbox", "arrow" .. i, 0, true)
      arrow:SetExtent(12, FONT_SIZE.LARGE)
      arrow:AddAnchor("LEFT", beforeValue, "RIGHT", 16, 0)
      arrow.style:SetFontSize(FONT_SIZE.LARGE)
      arrow.style:SetAlign(ALIGN_CENTER)
      ApplyTextColor(arrow, FONT_COLOR.SEA_BLUE)
      arrow:SetText("\226\150\182")
      infoFrame.arrow = arrow
      local afterValue = infoFrame:CreateChildWidget("textbox", "afterValue" .. i, 0, true)
      afterValue:SetExtent(114, FONT_SIZE.LARGE)
      afterValue:AddAnchor("LEFT", arrow, "RIGHT", 15, 0)
      afterValue.style:SetFontSize(FONT_SIZE.LARGE)
      afterValue.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(afterValue, FONT_COLOR.SEA_BLUE)
      infoFrame.afterValue = afterValue
      function infoFrame:SetModifier(title, before, after)
        self.title:SetText(title)
        self.beforeValue:SetText(before)
        self.afterValue:SetText(after)
      end
      parent.modifiers[i] = infoFrame
    end
  end
  CreateModifierInfos(scrollDesc)
  local money = W_MODULE:Create("money", tabWindow, WINDOW_MODULE_TYPE.VALUE_BOX)
  money:AddAnchor("TOP", modifierFrame, "BOTTOM", 0, 7)
  local warningText = tabWindow:CreateChildWidget("textbox", "warningText", 0, true)
  warningText:SetExtent(391, 50)
  warningText:SetAutoWordwrap(true)
  warningText:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  warningText.style:SetAlign(ALIGN_CENTER)
  warningText:AddAnchor("TOP", money, "BOTTOM", 0, 10)
  tabWindow.warningText = warningText
  ApplyTextColor(warningText, FONT_COLOR.RED)
end
