function SetViewOfGemEnchantWindow(tabWindow)
  local coords, inset, extent, anchor, color, text, height, fontPath, fontSize, fontColor, width, tooltip
  local commonWidth = tabWindow:GetWidth()
  CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "gem_enchant"))
  local deco = tabWindow:CreateDrawable(TEXTURE_PATH.GEM_ENCHANT, "effect", "background")
  deco:AddAnchor("TOP", tabWindow, 0, 40)
  local slotTargetItem = CreateTargetSlot(tabWindow, GetUIText(COMMON_TEXT, "gem_enchant_equipment"))
  slotTargetItem:AddAnchor("RIGHT", deco, "LEFT", 47, 10)
  local slotEnchantItem = CreateItemEnchantDefaultSlot("slotEnchantItem", tabWindow, GetCommonText("gem_enchant_item"), FONT_COLOR.GRAY_PINK)
  slotEnchantItem:AddAnchor("LEFT", deco, "RIGHT", -47, 10)
  slotEnchantItem.tooltip = GetUIText(COMMON_TEXT, "enchant_gem_item_tooltip", FONT_COLOR_HEX.SOFT_YELLOW)
  tabWindow.slotEnchantItem = slotEnchantItem
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GEM_ENCHANT, "socket_pink", "background")
  bg:AddAnchor("CENTER", slotEnchantItem, -9, -5)
  slotEnchantItem.bg = bg
  anchor = WINDOW_ENCHANT.GEM_ENCHANT_TAB.CUR_ENCHAT_INFO.ANCHOR
  fontColor = WINDOW_ENCHANT.GEM_ENCHANT_TAB.CUR_ENCHAT_INFO.FONT_COLOR
  local curEnchantInfoFrame = CreateCurEnchantInfoFrame("curEnchantInfoFrame", tabWindow)
  curEnchantInfoFrame:AddAnchor("TOP", tabWindow, anchor[1], anchor[2])
  curEnchantInfoFrame.bg:SetTextureColor("pink")
  tabWindow.curEnchantInfoFrame = curEnchantInfoFrame
  local enchantListFrame = CreateEnchantListFrame("enchantListFrame", tabWindow)
  enchantListFrame:AddAnchor("TOPLEFT", curEnchantInfoFrame, "BOTTOMLEFT", 0, 0)
  tabWindow.enchantListFrame = enchantListFrame
  enchantListFrame.item = {}
  local offsetX = 15
  local offsetY = 15
  for i = 1, 1 do
    local item = enchantListFrame:CreateChildWidget("textbox", "item", i, true)
    item:Show(false)
    item:AddAnchor("TOPLEFT", enchantListFrame, offsetX, offsetY)
    item:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    item.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(item, FONT_COLOR.DEFAULT)
    if i % 2 == 0 then
      offsetX = 15
      offsetY = offsetY + 40
    else
      offsetX = 200
    end
  end
  fontColor = WINDOW_ENCHANT.GEM_ENCHANT_TAB.WARNING_TEXT.FONT_COLOR
  anchor = WINDOW_ENCHANT.GEM_ENCHANT_TAB.WARNING_TEXT.ANCHOR
  local warningText = tabWindow:CreateChildWidget("textbox", "warningText", 0, true)
  warningText:SetWidth(commonWidth)
  ApplyTextColor(warningText, fontColor)
  warningText:AddAnchor("BOTTOM", tabWindow, anchor[1], anchor[2])
  function tabWindow:SetWarningText(text)
    warningText:SetText(text)
    warningText:SetHeight(warningText:GetTextHeight())
  end
end
