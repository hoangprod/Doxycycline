function SetViewOfGradeEnchantWindow(tabWindow)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local inset, extent, anchor, color, text, height, fontPath, fontSize, tooltip
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.MAGIC_SQUARE.EXTENT
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.MAGIC_SQUARE.ANCHOR
  local magicSquare = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "magic_square", "background")
  magicSquare:SetExtent(extent[1], extent[2])
  magicSquare:AddAnchor("TOP", tabWindow, anchor[1], anchor[2])
  CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "grade_enchant"))
  local slotTargetItem = CreateTargetSlot(tabWindow, GetUIText(COMMON_TEXT, "grade_enchant_item"))
  slotTargetItem:AddAnchor("TOP", magicSquare, 2, -5)
  tabWindow.slotTargetItem = slotTargetItem
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_ENCHANT_ITEM.EXTENT
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_ENCHANT_ITEM.ANCHOR
  local slotEnchantItem = CreateItemIconButton("slotEnchantItem", tabWindow)
  slotEnchantItem:SetExtent(extent[1], extent[2])
  slotEnchantItem:AddAnchor("BOTTOMLEFT", magicSquare, anchor[1], anchor[2])
  slotEnchantItem.back:SetVisible(false)
  tabWindow.slotEnchantItem = slotEnchantItem
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "enchant_slot_bg", "background")
  bg:SetExtent(105, 83)
  bg:AddAnchor("CENTER", slotEnchantItem, -1, -12)
  slotEnchantItem.bg = bg
  function slotEnchantItem:ApplyAlpha(value)
    self:SetAlpha(value)
    self.bg:SetColor(1, 1, 1, value)
  end
  local label = CreateEnchantSlotLabel(slotEnchantItem, GetUIText(COMMON_TEXT, "grade_enchant_magic_scroll"))
  ApplyTextColor(label, FONT_COLOR.PURPLE)
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM.EXTENT
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM.ANCHOR
  tooltip = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM.TOOLTIP
  local slotSupportItem = CreateItemIconButton("slotSupportItem", tabWindow)
  slotSupportItem:SetExtent(extent[1], extent[2])
  slotSupportItem:AddAnchor("BOTTOMRIGHT", magicSquare, anchor[1], anchor[2])
  slotSupportItem.back:SetVisible(false)
  slotSupportItem:RegisterForClicks("RightButton")
  slotSupportItem.tooltip = tooltip
  tabWindow.slotSupportItem = slotSupportItem
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "support_slot_bg", "background")
  bg:SetExtent(105, 83)
  bg:AddAnchor("CENTER", slotSupportItem, -1, -11)
  slotSupportItem.bg = bg
  function slotSupportItem:ApplyAlpha(value)
    self:SetAlpha(value)
    self.bg:SetColor(1, 1, 1, value)
  end
  height = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM_LABEL.HEIGHT
  fontPath = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM_LABEL.FONT_PATH
  fontSize = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM_LABEL.FONT_SIZE
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM_LABEL.TEXT
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM_LABEL.ANCHOR
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SLOT_SUPPORT_ITEM_LABEL.COLOR
  local label = CreateEnchantSlotLabel(slotSupportItem, GetUIText(COMMON_TEXT, "grade_enchant_support_item"))
  ApplyTextColor(label, FONT_COLOR.ROLE_NONE)
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_BG.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_BG.EXTENT
  local successBg = CreateContentBackground(tabWindow, "TYPE10", "blue")
  successBg:SetExtent(extent[1], extent[2])
  successBg:AddAnchor("TOPLEFT", tabWindow, anchor[1], anchor[2])
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY.COLOR
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY.TEXT
  local successLabel = tabWindow:CreateChildWidget("label", "successLabel", 0, true)
  successLabel:AddAnchor("TOPLEFT", successBg, anchor[1], anchor[2])
  successLabel:SetExtent(extent[1], extent[2])
  successLabel:SetText(text)
  successLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(successLabel, color)
  local successLine = CreateLine(successLabel, "TYPE7")
  successLine:SetExtent(220, 3)
  successLine:AddAnchor("TOPLEFT", successBg, 8, 29)
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY_RESULT.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY_RESULT.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY_RESULT.COLOR
  local successPossibility = tabWindow:CreateChildWidget("label", "successPossibility", 0, true)
  successPossibility:AddAnchor("TOP", successLine, "BOTTOM", anchor[1], anchor[2])
  successPossibility:SetExtent(extent[1], extent[2])
  successPossibility:SetText("0.0%")
  successPossibility.style:SetFontSize(FONT_SIZE.XXLARGE)
  ApplyTextColor(successPossibility, color)
  tabWindow.successPossibility = successPossibility
  local successPossibilityResult = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "result_o", "background")
  successPossibilityResult:AddAnchor("TOP", successLine, "BOTTOM", anchor[1], anchor[2])
  tabWindow.successPossibilityResult = successPossibilityResult
  local successArrow = tabWindow:CreateDrawable(TEXTURE_PATH.HUD, "single_arrow", "background")
  successArrow:SetTextureColor("default_brown")
  successArrow:AddAnchor("TOP", successPossibility, "BOTTOM", 0, 11)
  tabWindow.successArrow = successArrow
  local successGradeCur = W_ICON.CreateGradeIcon(tabWindow)
  successGradeCur:AddAnchor("RIGHT", successArrow, "LEFT", -21, 0)
  successGradeCur:SetGrade(1)
  tabWindow.successGradeCur = successGradeCur
  local successGradeNew = W_ICON.CreateGradeIcon(tabWindow)
  successGradeNew:AddAnchor("LEFT", successArrow, "RIGHT", 21, 0)
  successGradeNew:SetGrade(1)
  tabWindow.successGradeNew = successGradeNew
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.GREAT_SUCCESS_BG.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.GREAT_SUCCESS_BG.EXTENT
  local greatSuccessBg = CreateContentBackground(tabWindow, "TYPE10", "blue")
  greatSuccessBg:SetExtent(extent[1], extent[2])
  greatSuccessBg:AddAnchor("TOPLEFT", tabWindow, anchor[1], anchor[2])
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.GREAT_SUCCESS_POSSIBILITY.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.GREAT_SUCCESS_POSSIBILITY.EXTENT
  color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.GREAT_SUCCESS_POSSIBILITY.COLOR
  text = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.GREAT_SUCCESS_POSSIBILITY.TEXT
  local greatSuccessLabel = tabWindow:CreateChildWidget("label", "greatSuccessLabel", 0, true)
  greatSuccessLabel:AddAnchor("TOPLEFT", greatSuccessBg, anchor[1], anchor[2])
  greatSuccessLabel:SetExtent(extent[1], extent[2])
  greatSuccessLabel:SetText(text)
  greatSuccessLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(greatSuccessLabel, color)
  local greateSuccessLine = CreateLine(greatSuccessLabel, "TYPE7")
  greateSuccessLine:SetExtent(220, 3)
  greateSuccessLine:AddAnchor("TOPLEFT", greatSuccessBg, 8, 29)
  local greatSuccessArrow = tabWindow:CreateDrawable(TEXTURE_PATH.HUD, "double_arrow", "background")
  greatSuccessArrow:SetTextureColor("default_brown")
  greatSuccessArrow:AddAnchor("TOP", greateSuccessLine, "BOTTOM", 0, 11)
  tabWindow.greatSuccessArrow = greatSuccessArrow
  local greatSuccessGradeCur = W_ICON.CreateGradeIcon(tabWindow)
  greatSuccessGradeCur:AddAnchor("RIGHT", greatSuccessArrow, "LEFT", -8, 0)
  greatSuccessGradeCur:SetGrade(1)
  tabWindow.greatSuccessGradeCur = greatSuccessGradeCur
  local greatSuccessGradeNew = W_ICON.CreateGradeIcon(tabWindow)
  greatSuccessGradeNew:AddAnchor("LEFT", greatSuccessArrow, "RIGHT", 8, 0)
  greatSuccessGradeNew:SetGrade(1)
  tabWindow.greatSuccessGradeNew = greatSuccessGradeNew
  anchor = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_BG.ANCHOR
  extent = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.FAIL_BG.EXTENT
  local failBg = CreateContentBackground(tabWindow, "TYPE10", "red")
  failBg:SetExtent(extent[1], extent[2])
  failBg:AddAnchor("TOPLEFT", tabWindow, anchor[1], anchor[2])
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
  tabWindow.destroyResult = result
  result = downGradeLabel:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, key, "background")
  result:AddAnchor("LEFT", downGradeLabel, "RIGHT", anchor[1], anchor[2])
  result:SetExtent(extent[1], extent[2])
  ApplyTextureColor(result, color)
  tabWindow.downGradeResult = result
  result = disableLabel:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, key, "background")
  result:AddAnchor("LEFT", disableLabel, "RIGHT", anchor[1], anchor[2])
  result:SetExtent(extent[1], extent[2])
  ApplyTextureColor(result, color)
  tabWindow.disableResult = result
  local money = W_MODULE:Create("money", tabWindow, WINDOW_MODULE_TYPE.VALUE_BOX)
  money:AddAnchor("TOP", failBg, "BOTTOMLEFT", 0, 8)
  tabWindow.money = money
  local warningText = tabWindow:CreateChildWidget("textbox", "warningText", 0, true)
  warningText:SetExtent(tabWindow:GetWidth(), 50)
  warningText:AddAnchor("TOP", money, "BOTTOM", 0, 15)
  ApplyTextColor(warningText, FONT_COLOR.RED)
  anchor = FORM_ENCHANT_WINDOW.GUIDE_ICON_ANCHOR
  local guide = W_ICON.CreateGuideIconWidget(tabWindow)
  guide:AddAnchor("TOPRIGHT", tabWindow, anchor[1], anchor[2])
  tabWindow.guide = guide
  function tabWindow:SetWarningText(text)
    warningText:SetText(text)
  end
end
