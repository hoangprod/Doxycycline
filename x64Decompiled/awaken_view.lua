function SetViewOfAwakenWindow(tabWindow)
  CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "awaken"))
  local deco = tabWindow:CreateDrawable(TEXTURE_PATH.AWAKEN_ENCHANT, "effect", "background")
  deco:AddAnchor("TOP", tabWindow, 0, 40)
  local slotTargetItem = CreateTargetSlot(tabWindow, GetCommonText("socket_enchant_equipment"))
  slotTargetItem:AddAnchor("RIGHT", deco, "LEFT", 47, 10)
  tabWindow.slotTargetItem = slotTargetItem
  local slotEnchantItem = CreateItemEnchantDefaultSlot("slotEnchantItem", tabWindow, GetCommonText("awaken_scroll"), FONT_COLOR.BLUE_GREEN)
  slotEnchantItem:AddAnchor("LEFT", deco, "RIGHT", -47, 10)
  tabWindow.slotEnchantItem = slotEnchantItem
  local scrollCountLabel = slotEnchantItem:CreateChildWidget("label", "scrollCountLabel", 0, true)
  scrollCountLabel:SetAutoResize(true)
  scrollCountLabel:SetHeight(FONT_SIZE.LARGE)
  scrollCountLabel:SetText(string.format("(0/0)"))
  scrollCountLabel:AddAnchor("TOP", slotEnchantItem.slotLabel, "BOTTOM", 0, 5)
  scrollCountLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(scrollCountLabel, FONT_COLOR.BLUE_GREEN)
  slotEnchantItem.scrollCountLabel = scrollCountLabel
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.AWAKEN_ENCHANT, "socket_blue_green", "background")
  bg:AddAnchor("CENTER", slotEnchantItem, -9, -5)
  slotEnchantItem.bg = bg
  local CreateAwakenItemList = function(tabWindow)
    local awakenList = tabWindow:CreateChildWidget("emptywidget", "awakenList", 0, false)
    awakenList:SetExtent(470, 90)
    awakenList:AddAnchor("TOP", tabWindow, 0, 172)
    local awakenListBg = awakenList:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_05", "background")
    awakenListBg:SetTextureColor("sky_blue")
    awakenListBg:AddAnchor("TOPLEFT", awakenList, 0, 0)
    awakenListBg:AddAnchor("BOTTOMRIGHT", awakenList, 0, 0)
    tabWindow.awakenList = awakenList
    tabWindow.awakenItemSlots = {}
    for i = 1, 7 do
      local itemSlot = CreateItemIconButton("slot" .. i, tabWindow)
      itemSlot:AddAnchor("TOP", awakenList, 0, 16)
      itemSlot:Show(false)
      tabWindow.awakenItemSlots[i] = itemSlot
    end
    local radioData = {}
    for i = 1, #tabWindow.awakenItemSlots do
      local item = {text = ""}
      table.insert(radioData, item)
    end
    local radioButtons = CreateRadioGroup("radioButton", awakenList, "horizen")
    radioButtons:SetGapWidth(42)
    radioButtons:SetData(radioData)
    local offSetX = tabWindow.awakenItemSlots[1]:GetWidth() / 2 - radioButtons.items[1]:GetWidth() / 2 + 2
    radioButtons:AddAnchor("TOPLEFT", tabWindow.awakenItemSlots[1], "BOTTOMLEFT", offSetX, 5)
    radioButtons:Show(false)
    tabWindow.radioButtons = radioButtons
  end
  local CreateSuccessInfo = function(tabWindow)
    local CreateSuccessRatio = function(id, tabWindow, titleText)
      local widget = tabWindow:CreateChildWidget("emptywidget", id, 0, false)
      widget:SetExtent(295, 50)
      local widgetBg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
      widgetBg:SetTextureColor("blue_3")
      widgetBg:AddAnchor("TOPLEFT", widget, 0, 0)
      widgetBg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
      local title = widget:CreateChildWidget("label", "title", 0, true)
      title:SetHeight(FONT_SIZE.MIDDLE)
      title:SetWidth(195)
      title:SetText(titleText)
      title:AddAnchor("LEFT", widget, "LEFT", 17, 0)
      title.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      title.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(title, FONT_COLOR.DEFAULT)
      local successText = widget:CreateChildWidget("label", "successText", 0, true)
      successText:SetHeight(FONT_SIZE.XLARGE)
      successText:SetWidth(65)
      successText:SetText(GetCommonText("success_rate"))
      successText:AddAnchor("LEFT", title, "RIGHT", 0, 0)
      successText:SetText("100%")
      successText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
      successText.style:SetAlign(ALIGN_RIGHT)
      ApplyTextColor(successText, FONT_COLOR.SEA_BLUE)
      widget.text = successText
      return widget
    end
    local successWidget = CreateSuccessRatio("successWidget", tabWindow, GetCommonText("success_rate"))
    successWidget:AddAnchor("TOPLEFT", tabWindow.awakenList, "BOTTOMLEFT", 0, 0)
    tabWindow.successWidget = successWidget
    local successBonusWidget = CreateSuccessRatio("successBonusWidget", tabWindow, GetCommonText("bonus_rate"))
    successBonusWidget:AddAnchor("TOPLEFT", successWidget, "BOTTOMLEFT", 0, 0)
    tabWindow.successBonusWidget = successBonusWidget
    local disableWidget = tabWindow:CreateChildWidget("emptywidget", "disableWidget", 0, false)
    disableWidget:SetExtent(175, 100)
    disableWidget:AddAnchor("TOPRIGHT", tabWindow.awakenList, "BOTTOMRIGHT", 0, 0)
    local disableBg = disableWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
    disableBg:SetTextureColor("red")
    disableBg:AddAnchor("TOPLEFT", disableWidget, 0, 0)
    disableBg:AddAnchor("BOTTOMRIGHT", disableWidget, 0, 0)
    local disableTitle = disableWidget:CreateChildWidget("label", "disableTitle", 0, true)
    disableTitle:SetHeight(FONT_SIZE.MIDDLE)
    disableTitle:SetWidth(160)
    disableTitle:SetText(GetCommonText("enchant_disable_possibility"))
    disableTitle:AddAnchor("TOP", disableWidget, "TOP", 0, 19)
    disableTitle.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
    disableTitle.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(disableTitle, FONT_COLOR.DEFAULT)
    local disableLine = CreateLine(disableTitle, "TYPE7")
    disableLine:SetExtent(145, 2)
    disableLine:AddAnchor("TOP", disableTitle, "BOTTOM", 0, 12)
    local key = WINDOW_ENCHANT.AWAKEN_TAB.RESULT_O.KEY
    local extent = WINDOW_ENCHANT.AWAKEN_TAB.RESULT_O.EXTENT
    local color = FONT_COLOR.BLUE
    local disableResult = disableWidget:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, key, "background")
    disableResult:AddAnchor("TOP", disableLine, "BOTTOM", 0, 8)
    disableResult:SetExtent(extent[1], extent[2])
    ApplyTextureColor(disableResult, color)
    tabWindow.disableResult = disableResult
    function disableResult:SetDisableResult(flag)
      local key = WINDOW_ENCHANT.AWAKEN_TAB.RESULT_X.KEY
      local extent = WINDOW_ENCHANT.AWAKEN_TAB.RESULT_X.EXTENT
      if flag then
        key = WINDOW_ENCHANT.AWAKEN_TAB.RESULT_O.KEY
        extent = WINDOW_ENCHANT.AWAKEN_TAB.RESULT_O.EXTENT
      end
      disableResult:SetTextureInfo(key)
      disableResult:SetExtent(extent[1], extent[2])
    end
  end
  local CreateDetailInfo = function(tabWindow)
    local detailInfo = tabWindow:CreateChildWidget("emptywidget", "detailInfo", 0, true)
    detailInfo:SetExtent(470, 195)
    detailInfo:AddAnchor("TOPLEFT", tabWindow.successBonusWidget, "BOTTOMLEFT", 0, 0)
    local scrollWnd = CreateScrollWindow(detailInfo, "scroll", 0)
    scrollWnd:AddAnchor("TOPLEFT", detailInfo, 0, 5)
    scrollWnd:AddAnchor("BOTTOMRIGHT", detailInfo, 0, -5)
    scrollWnd.contentHeight = detailInfo:GetHeight() - 10
    scrollWnd:ResetScroll(scrollWnd.contentHeight)
    local scrollDesc = scrollWnd.content:CreateChildWidget("emptywidget", "scrollDesc", 0, true)
    local sizeX, _ = scrollWnd.content:GetExtent()
    scrollDesc:SetExtent(sizeX, scrollWnd.contentHeight)
    scrollDesc:AddAnchor("TOPLEFT", scrollWnd.content, 0, 0)
    local CreateInfoRow = function(id, parent, titleText, infoText, infoColor)
      local infoRow = parent:CreateChildWidget("emptywidget", id, 0, true)
      infoRow:SetExtent(470, FONT_SIZE.MIDDLE)
      local icon = infoRow:CreateDrawable(TEXTURE_PATH.DEFAULT, "point", "background")
      icon:AddAnchor("TOPLEFT", infoRow, 20, 1)
      local title = infoRow:CreateChildWidget("label", "title", 0, true)
      title:SetHeight(FONT_SIZE.MIDDLE)
      title:SetWidth(AWAKEN_DETAIL_TITLE_WIDTH)
      title:SetText(titleText)
      title:AddAnchor("TOPLEFT", icon, "TOPRIGHT", 13, -1)
      title.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      title.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
      local info = infoRow:CreateChildWidget("textbox", "info", 0, true)
      info:SetHeight(FONT_SIZE.MIDDLE)
      info:SetWidth(AWAKEN_DETAIL_INFO_WIDTH)
      info:SetText(infoText)
      info:AddAnchor("TOPLEFT", title, "TOPRIGHT", 11, 0)
      info.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      info.style:SetAlign(ALIGN_LEFT)
      info:SetAutoResize(true)
      ApplyTextColor(info, infoColor)
      infoRow.title = title
      infoRow.info = info
      function infoRow:SetText(text)
        info:SetText(text)
      end
      return infoRow
    end
    local detailInfoBg = tabWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
    detailInfoBg:SetTextureColor("default")
    detailInfoBg:AddAnchor("TOPLEFT", detailInfo, 0, 0)
    detailInfoBg:AddAnchor("BOTTOMRIGHT", detailInfo, 0, 0)
    local gradeRow = CreateInfoRow("gradeRow", scrollDesc, GetCommonText("grade_info"), "\236\157\188\235\176\152 \226\150\182 \234\179\160\234\184\137", FONT_COLOR.BLUE)
    gradeRow:AddAnchor("TOPLEFT", scrollDesc, 0, 17)
    local scoreRow = CreateInfoRow("scoreRow", scrollDesc, GetCommonText("gear_score"), "990 \226\150\182 999", FONT_COLOR.BLUE)
    scoreRow:AddAnchor("TOPLEFT", gradeRow, "BOTTOMLEFT", 0, 17)
    local attrRow = CreateInfoRow("attrRow", scrollDesc, GetCommonText("evolving_effect"), GetCommonText("awaken_attribute_info_nonselective"), FONT_COLOR.DEFAULT)
    attrRow:AddAnchor("TOPLEFT", scoreRow, "BOTTOMLEFT", 0, 17)
    local scaledRow = CreateInfoRow("scaledRow", scrollDesc, GetCommonText("item_scale"), "", FONT_COLOR.BLUE)
    scaledRow:AddAnchor("TOPLEFT", attrRow, "BOTTOMLEFT", 0, 17)
    local warningText = scrollDesc:CreateChildWidget("label", "warningText", 0, true)
    warningText:SetAutoResize(true)
    warningText:SetHeight(FONT_SIZE.MIDDLE)
    warningText:SetText(GetCommonText("awaken_result_warning"))
    warningText:AddAnchor("BOTTOM", scrollWnd, "BOTTOM", 0, -20)
    warningText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
    warningText.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(warningText, FONT_COLOR.RED)
    scrollDesc.warningText = warningText
    scrollDesc.rows = {}
    scrollDesc.rows.score = scoreRow
    scrollDesc.rows.attr = attrRow
    scrollDesc.rows.grade = gradeRow
    scrollDesc.rows.scaled = scaledRow
    function scrollWnd:GetResizeExtent(selectable)
      if selectable == false then
        scrollWnd.scroll:SetEnable(false)
        scrollWnd.scroll:Show(false)
        scrollWnd:SetValue(0)
        return
      end
      local _, startPos = scrollDesc:GetOffset()
      local _, endPos = attrRow.info:GetOffset()
      endPos = endPos + attrRow.info:GetHeight() + 10
      local scrollHeight = endPos - startPos
      scrollDesc:SetHeight(scrollHeight)
      scrollWnd.contentHeight = scrollHeight
      scrollWnd:ResetScroll(scrollHeight)
      scrollWnd:SetValue(0)
      local scrollEnable = scrollWnd:GetHeight() < scrollDesc:GetHeight()
      scrollWnd.scroll:SetEnable(scrollEnable)
      scrollWnd.scroll:Show(scrollEnable)
    end
    tabWindow.scrollWnd = scrollWnd
    tabWindow.scrollDesc = scrollDesc
    tabWindow.detailInfo = detailInfo
  end
  local CreteWarningInfo = function(tabWindow)
    local warningInfo = tabWindow:CreateChildWidget("textbox", "warningInfo", 0, true)
    warningInfo:SetHeight(48)
    warningInfo:SetWidth(440)
    warningInfo:SetText(GetCommonText("awaken_warning"))
    warningInfo:AddAnchor("TOP", tabWindow.detailInfo, "BOTTOM", 0, 8)
    warningInfo.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
    warningInfo.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(warningInfo, FONT_COLOR.RED)
    tabWindow.warningInfo = warningInfo
  end
  CreateAwakenItemList(tabWindow)
  CreateSuccessInfo(tabWindow)
  CreateDetailInfo(tabWindow)
  CreteWarningInfo(tabWindow)
end
