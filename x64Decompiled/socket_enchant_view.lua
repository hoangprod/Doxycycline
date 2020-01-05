local CreateSocketingSpinner = function(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local extent
  local spinner = W_ETC.CreateSpinner("spinner", wnd)
  spinner:AddAnchor("LEFT", wnd, 0, 0)
  wnd.spinner = spinner
  local maxBtn = wnd:CreateChildWidget("button", "maxBtn", 0, true)
  maxBtn:SetText(GetCommonText("socket_enchant_max_count"))
  ApplyButtonSkin(maxBtn, BUTTON_BASIC.DEFAULT)
  maxBtn:AddAnchor("LEFT", spinner, "RIGHT", 0, 0)
  local maxValue = 0
  function wnd:SetValue(value)
    spinner.text:SetText(tostring(value))
  end
  function wnd:SetMinMaxValues(min, max)
    spinner:SetMinMaxValues(min, max)
    maxValue = max
  end
  function wnd:SetState(enable)
    spinner:SetEnable(enable)
    maxBtn:Enable(enable)
  end
  function wnd:GetCurValue()
    return spinner:GetCurValue()
  end
  function maxBtn:OnClick()
    wnd:SetValue(maxValue)
  end
  maxBtn:SetHandler("OnClick", maxBtn.OnClick)
  return wnd
end
function SetViewOfSocketEnchantWindow(tabWindow)
  local coords, inset, extent, anchor, color, text, height, fontPath, fontSize, fontColor, width, lineSpace
  CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "socket"))
  local commonWidth = tabWindow:GetWidth()
  local tabTexts = {
    GetCommonText("install_enchant_socket"),
    X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "remove")
  }
  if X2Player:GetFeatureSet().socketExtract then
    table.insert(tabTexts, GetCommonText("extract"))
  end
  if X2Player:GetFeatureSet().socketChange then
    table.insert(tabTexts, GetCommonText("socket_change"))
  end
  local tabSubMenu = CreateTabSubMenu("tabSubMenu", tabWindow, tabTexts)
  tabSubMenu:AddAnchor("TOPLEFT", tabWindow, 0, 27)
  tabSubMenu:SetExtent(commonWidth, 43)
  tabWindow.tabSubMenu = tabSubMenu
  local deco = tabWindow:CreateDrawable(TEXTURE_PATH.COMMON_ENCHANT, "effect", "background")
  deco:AddAnchor("TOP", tabSubMenu, "BOTTOM", 0, 10)
  local slotTargetItem = CreateTargetSlot(tabWindow, GetUIText(COMMON_TEXT, "socket_enchant_equipment"))
  slotTargetItem:AddAnchor("RIGHT", deco, "LEFT", 47, 10)
  tabWindow.slotTargetItem = slotTargetItem
  local slotEnchantItem = CreateItemEnchantDefaultSlot("slotEnchantItem", tabWindow, GetCommonText("grade_enchant_magic_scroll"), FONT_COLOR.PURPLE)
  slotEnchantItem:AddAnchor("LEFT", deco, "RIGHT", -47, 10)
  tabWindow.slotEnchantItem = slotEnchantItem
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.COMMON_ENCHANT, "socket_purple", "background")
  bg:AddAnchor("CENTER", slotEnchantItem, -9, -5)
  slotEnchantItem.bg = bg
  anchor = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.CUR_SOCKET_INFO.ANCHOR
  fontColor = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.CUR_SOCKET_INFO.FONT_COLOR
  local curEnchantInfoFrame = CreateCurEnchantInfoFrame("curEnchantInfoFrame", tabWindow)
  curEnchantInfoFrame:AddAnchor("TOP", tabWindow, anchor[1], anchor[2])
  curEnchantInfoFrame.bg:SetTextureColor("purple")
  tabWindow.curEnchantInfoFrame = curEnchantInfoFrame
  local socketListFrame = CreateEnchantListFrame("socketListFrame", tabWindow)
  socketListFrame:AddAnchor("TOPLEFT", tabWindow, 0, 245)
  tabWindow.socketListFrame = socketListFrame
  socketListFrame.item = {}
  local offsetY = 10
  for i = 1, MAX_ITEM_SOCKETS do
    local id = string.format("%s[%d]", socketListFrame:GetId() .. ".item", i)
    local item = CreateEnchantInfoFrame(id, socketListFrame)
    item:Show(false)
    item:AddAnchor("TOPLEFT", socketListFrame, 13, offsetY)
    offsetY = offsetY + 33
    socketListFrame.item[i] = item
  end
  fontColor = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.WARNING_TEXT.FONT_COLOR
  local extractWarningText = tabWindow:CreateChildWidget("textbox", "extractWarningText", 0, true)
  extractWarningText:SetWidth(commonWidth)
  ApplyTextColor(extractWarningText, FONT_COLOR.BLUE)
  extractWarningText:SetText(GetCommonText("not_extractable_warning"))
  extractWarningText:SetHeight(extractWarningText:GetTextHeight())
  extractWarningText:AddAnchor("TOP", socketListFrame, "BOTTOM", 0, 20)
  local money = W_MODULE:Create("money", tabWindow, WINDOW_MODULE_TYPE.VALUE_BOX)
  money:AddAnchor("TOP", socketListFrame, "BOTTOM", 0, 0)
  local laborPower = W_MODULE:Create("laborPower", tabWindow, WINDOW_MODULE_TYPE.VALUE_BOX)
  local warningText = tabWindow:CreateChildWidget("textbox", "warningText", 0, true)
  warningText:SetWidth(commonWidth)
  warningText.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(warningText, fontColor)
  warningText:AddAnchor("TOP", socketListFrame, "BOTTOM", 0, 0)
  extent = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.SPINNER_WND.EXTENT
  anchor = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.SPINNER_WND.ANCHOR
  local spinnerWnd = CreateSocketingSpinner("spinnerWnd", tabWindow)
  spinnerWnd:SetExtent(extent[1], extent[2])
  spinnerWnd:AddAnchor("BOTTOMLEFT", tabWindow, anchor[1], anchor[2])
  tabWindow.spinnerWnd = spinnerWnd
  local socketUpgradeFrame = tabWindow:CreateChildWidget("emptywidget", "socketUpgradeFrame", 0, true)
  socketUpgradeFrame:SetExtent(470, 350)
  socketUpgradeFrame:AddAnchor("TOPLEFT", tabWindow, 0, 195)
  tabWindow.socketUpgradeFrame = socketUpgradeFrame
  local subg = socketUpgradeFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  subg:SetTextureColor("bg_01")
  subg:SetExtent(470, 350)
  subg:AddAnchor("TOPLEFT", socketUpgradeFrame, 0, 0)
  subg = socketUpgradeFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  subg:SetTextureColor("bg_01")
  subg:SetExtent(470, 35)
  subg:AddAnchor("TOPLEFT", socketUpgradeFrame, 0, 0)
  subg = socketUpgradeFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "list_effect_select", "background")
  subg:SetTextureColor("sky_blue_30")
  subg:SetExtent(113, 315)
  subg:AddAnchor("TOPRIGHT", socketUpgradeFrame, 0, 35)
  DrawListCtrlUnderLine(socketUpgradeFrame)
  DrawListCtrlUnderLine(socketUpgradeFrame, socketUpgradeFrame:GetHeight())
  local CreateSocketUpgradeListFrame = function(parent, index)
    local widget = parent:CreateChildWidget("emptywidget", "infoTitleWidget_" .. index, 0, true)
    widget:SetExtent(470, 35)
    local widgetCheckBox = widget:CreateChildWidget("emptywidget", "widgetCheckBox_" .. index, 0, true)
    widgetCheckBox:SetExtent(40, 35)
    widgetCheckBox:AddAnchor("LEFT", widget, 0, 0)
    local checkBox = CreateCheckButton("checkBox" .. index, widgetCheckBox)
    checkBox:AddAnchor("TOPLEFT", widgetCheckBox, 11, 9)
    checkBox.index = index
    widget.checkBox = checkBox
    local widgetInfo = widget:CreateChildWidget("emptywidget", "widgetInfo_" .. index, 0, true)
    widgetInfo:SetExtent(317, 35)
    widgetInfo:AddAnchor("LEFT", widgetCheckBox, "RIGHT", 0, 0)
    widget.widgetInfo = widgetInfo
    if index == 0 then
      local widgetResult = widget:CreateChildWidget("emptywidget", "widgetResult_" .. index, 0, true)
      widgetResult:SetExtent(113, 35)
      widgetResult:AddAnchor("LEFT", widgetInfo, "RIGHT", 0, 0)
      widget.widgetResult = widgetResult
    else
      widgetInfo:SetExtent(430, 35)
    end
    if parent.items == nil then
      parent.items = {}
      widget:AddAnchor("TOPLEFT", parent, 0, 0)
    else
      widget:AddAnchor("TOPLEFT", parent.items[index - 1], "BOTTOMLEFT", 0, 0)
      widget:Show(false)
    end
    parent.items[index] = widget
  end
  local CreateSocketUpgradeListTitle = function(parent)
    local title = parent.widgetInfo:CreateChildWidget("textbox", "title", 0, true)
    title:SetExtent(295, FONT_SIZE.LARGE)
    title.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    title.style:SetAlign(ALIGN_CENTER)
    title:SetText(GetCommonText("socket_change_list"))
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    title:AddAnchor("LEFT", parent.widgetInfo, 11, 0)
    local result = parent.widgetResult:CreateChildWidget("textbox", "result", 0, true)
    result:SetAutoResize(true)
    result:SetExtent(80, FONT_SIZE.LARGE)
    result.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    result.style:SetAlign(ALIGN_CENTER)
    result:SetText(GetCommonText("socket_change_result"))
    ApplyTextColor(result, FONT_COLOR.MIDDLE_TITLE)
    local guide = W_ICON.CreateGuideIconWidget(result)
    guide:AddAnchor("LEFT", result, "RIGHT", 5, 0)
    local function OnEnterGuide()
      SetTargetAnchorTooltip(GetCommonText("socket_change_tooltip"), "BOTTOMLEFT", guide, "TOPRIGHT", -20, -10)
    end
    guide:SetHandler("OnEnter", OnEnterGuide)
    local OnleaveGuide = function()
      HideTooltip()
    end
    guide:SetHandler("OnLeave", OnleaveGuide)
    local lineWidth = result:GetLongestLineWidth() + 5
    if lineWidth < 80 then
      result:SetWidth(lineWidth)
    end
    local offset = parent.widgetResult:GetWidth() - (lineWidth + guide:GetWidth() + 5)
    result:AddAnchor("LEFT", parent.widgetResult, offset / 2, 0)
    local lables = {
      parent.widgetInfo,
      parent.widgetResult
    }
    for i = 1, #lables do
      DrawListCtrlColumnSperatorLine(lables[i], #lables, i)
    end
  end
  local CreateSocketUpgradeListSlot = function(parent, index)
    local itemSlot = CreateSocketUpgradeSlot(parent.widgetInfo, index)
    itemSlot:AddAnchor("LEFT", parent.widgetInfo, 11, 0)
    local disableImage = parent:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    disableImage:SetTextureColor("gray_20")
    disableImage:SetExtent(470, 35)
    disableImage:AddAnchor("TOPLEFT", parent, 0, 0)
    parent.disableImage = disableImage
    function parent:SetInfo(type, modifierStr, changeInfo)
      local itemInfo
      if type ~= nil then
        itemInfo = X2Item:GetItemInfoByType(type)
      end
      self.widgetInfo.itemType = type
      self.widgetInfo.itemIcon:Show(true)
      self.widgetInfo.itemIcon:SetItemInfo(itemInfo)
      self.widgetInfo.itemName:SetText(modifierStr)
      local isEnable = changeInfo ~= nil and changeInfo.state ~= ISUS_MAX_UPGRADE and changeInfo.state ~= ISUS_MISS_MATCH
      self.widgetInfo.itemResultIcon:Enable(true)
      self.widgetInfo.itemResultIcon:Show(true)
      self.widgetInfo.resultCheck:Show(false)
      self.widgetInfo.resultMiss:Show(false)
      self.widgetInfo.itemIcon:Enable(isEnable)
      self.disableImage:Show(not isEnable)
      self.checkBox:Enable(isEnable)
      self.state = 0
      if changeInfo ~= nil then
        self.state = changeInfo.state
      end
      if changeInfo == nil then
        self.widgetInfo.itemResultIcon:Show(false)
        self.widgetInfo.itemIcon:Enable(true)
        self.disableImage:Show(false)
      elseif changeInfo.state == ISUS_UPGRADE then
        self.widgetInfo.itemResultIcon:SetItemInfo(X2Item:GetItemInfoByType(changeInfo.targetType))
      elseif changeInfo.state == ISUS_MAX_UPGRADE then
        self.widgetInfo.itemResultIcon:Show(false)
        self.widgetInfo.resultCheck:Show(true)
      elseif changeInfo.state == ISUS_MISS_MATCH then
        self.widgetInfo.itemResultIcon:Show(false)
        self.widgetInfo.resultMiss:Show(true)
      end
    end
    function parent:SetUpgradeSlotEnable(flag)
      if self.state ~= ISUS_UPGRADE or self.checkBox:GetChecked() then
        return
      end
      self.checkBox:Enable(flag)
      self.disableImage:Show(not flag)
      self.widgetInfo.itemIcon:Enable(flag)
      self.widgetInfo.itemResultIcon:Enable(flag)
      if flag then
        self.widgetInfo.resultArrow:SetTextureColor("default_brown")
      else
        self.widgetInfo.resultArrow:SetTextureColor("gray")
      end
    end
  end
  for i = 0, MAX_ITEM_SOCKETS do
    CreateSocketUpgradeListFrame(socketUpgradeFrame, i)
    if i == 0 then
      CreateSocketUpgradeListTitle(socketUpgradeFrame.items[i])
    else
      CreateSocketUpgradeListSlot(socketUpgradeFrame.items[i], i)
    end
  end
  function tabWindow:SetWarningText(text, tabIndex)
    local OFFSET = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.WARNING_TEXT.OFFSET[tabIndex]
    warningText:RemoveAllAnchors()
    if tabIndex == WINDOW_ENCHANT.SOCKET_SUB_TAB_INDEX.UPGRADE then
      warningText:AddAnchor("TOP", socketUpgradeFrame, "BOTTOM", OFFSET.ANCHOR[1], OFFSET.ANCHOR[2])
    else
      warningText:AddAnchor("TOP", socketListFrame, "BOTTOM", OFFSET.ANCHOR[1], OFFSET.ANCHOR[2])
    end
    warningText:SetExtent(OFFSET.EXTENT[1], OFFSET.EXTENT[2])
    warningText:SetText(text)
  end
  function tabWindow:ResetSubTabLayout(subTabIndex)
    deco:RemoveAllAnchors()
    if subTabIndex == WINDOW_ENCHANT.SOCKET_SUB_TAB_INDEX.UPGRADE then
      deco:AddAnchor("TOP", tabSubMenu, "BOTTOM", 0, 1)
      socketListFrame:Show(false)
      socketUpgradeFrame:Show(true)
    else
      deco:AddAnchor("TOP", tabSubMenu, "BOTTOM", 0, 10)
      socketListFrame:Show(true)
      socketUpgradeFrame:Show(false)
    end
  end
end
