local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local popup_text
local function SetViewOfWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, 650)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(GetUIText(COMMON_TEXT, "selective_item"))
  local srcItemText = window:CreateChildWidget("textbox", "srcItemText", 0, true)
  srcItemText:SetExtent(window:GetWidth() - 40, FONT_SIZE.MIDDLE)
  srcItemText:SetAutoResize(true)
  srcItemText:SetAutoWordwrap(true)
  srcItemText:AddAnchor("TOP", window, "TOP", 0, 50)
  srcItemText.style:SetFontSize(FONT_SIZE.MIDDLE)
  local contentLabel = window:CreateChildWidget("textbox", "contentLabel", 0, true)
  contentLabel:SetAutoResize(true)
  contentLabel:SetAutoWordwrap(true)
  contentLabel:SetExtent(window:GetWidth() - 40, FONT_SIZE.MIDDLE)
  contentLabel:AddAnchor("TOP", srcItemText, "BOTTOM", 0, 10)
  contentLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(contentLabel, FONT_COLOR.MIDDLE_TITLE)
  local listTitleWidget = window:CreateChildWidget("emptyWidget", "listTitleWidget", 0, true)
  listTitleWidget:SetExtent(320, 34)
  listTitleWidget:AddAnchor("TOP", contentLabel, "BOTTOM", 0, 8)
  local listTitleBg = listTitleWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new_half", "background")
  listTitleBg:SetTextureColor("title_alpha30")
  listTitleBg:AddAnchor("TOPLEFT", listTitleWidget, 0, 0)
  listTitleBg:AddAnchor("BOTTOMRIGHT", listTitleWidget, 0, 0)
  local listTitleText = listTitleWidget:CreateChildWidget("label", "listTitleText", 0, true)
  listTitleText:SetExtent(312, FONT_SIZE.LARGE)
  listTitleText:SetText(GetCommonText("selective_item_list_title"))
  listTitleText:AddAnchor("TOP", listTitleWidget, "TOP", 0, 13)
  listTitleText.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(listTitleText, FONT_COLOR.MIDDLE_TITLE)
  local DataSetter = function(subItem, data, setValue)
    subItem.check:Show(setValue)
    subItem.itemWnd:Show(setValue)
    subItem.itemName:Show(setValue)
    subItem.check:SetChecked(false, false)
    if setValue then
      subItem.check:Enable(data.selectable)
      if SELECTIVE_ITEMNAME_LIMIT_LENGTH ~= nil then
        subItem.itemName:SetText(X2Util:UTF8StringLimit(data.name, SELECTIVE_ITEMNAME_LIMIT_LENGTH, ".."))
      else
        subItem.itemName:SetText(data.name)
      end
      subItem.check:SetChecked(data.selected or false, false)
      subItem.itemWnd:SetItem(data.type, data.grade, data.count)
      function subItem.check:CheckBtnCheckChagnedProc(checked)
        X2Bag:SetSelectiveItem(data.idx, checked)
        data.selected = checked
      end
    end
  end
  local LayoutSetter = function(widget, rowIndex, colIndex, subItem)
    local checkBox = CreateCheckButton(".check", subItem)
    checkBox:AddAnchor("LEFT", subItem, "LEFT", 18, 0)
    checkBox:Show(false)
    checkBox:SetChecked(false)
    subItem.check = checkBox
    local itemWnd = CreateSlotItemButton(subItem:GetId() .. ".itemWnd", subItem)
    itemWnd:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    itemWnd:AddAnchor("LEFT", checkBox, "RIGHT", 3, 0)
    itemWnd:Show(false)
    subItem.itemWnd = itemWnd
    local function OnItemClick()
      checkBox:SetChecked(not checkBox:GetChecked())
    end
    itemWnd:SetHandler("OnClick", OnItemClick)
    local itemName = subItem:CreateChildWidget("textbox", "itemName", 0, true)
    itemName:SetExtent(200, FONT_SIZE.MIDDLE)
    itemName:SetAutoResize(true)
    itemName:SetHeight(FONT_SIZE.MIDDLE)
    itemName:AddAnchor("LEFT", itemWnd, "RIGHT", 10, 0)
    ApplyTextColor(itemName, FONT_COLOR.MIDDLE_TITLE)
    itemName:Show(false)
    subItem.itemName = itemName
  end
  local listWidth = window:GetWidth() - 30
  local scrollList = W_CTRL.CreateScrollListCtrl("scrollList", window)
  scrollList:SetExtent(320, 383)
  scrollList:HideColumnButtons()
  scrollList:AddAnchor("TOP", listTitleWidget, "BOTTOM", 0, -5)
  scrollList.scroll:RemoveAllAnchors()
  scrollList.scroll:AddAnchor("TOPRIGHT", scrollList, 0, 5)
  scrollList.scroll:AddAnchor("BOTTOMRIGHT", scrollList, 0, 0)
  scrollList:InsertColumn("", listWidth, LCCIT_WINDOW, DataSetter, nil, nil, LayoutSetter)
  scrollList:InsertRows(6, false)
  scrollList:Show(true)
  local bg = scrollList:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", scrollList, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", scrollList, 0, 5)
  local itemCountText = window:CreateChildWidget("textbox", "itemCountText", 0, true)
  itemCountText:SetText(GetCommonText("selective_item_count"))
  itemCountText:SetAutoResize(false)
  itemCountText:SetAutoWordwrap(true)
  itemCountText:SetExtent(130, 34)
  itemCountText:AddAnchor("TOPLEFT", bg, "BOTTOMLEFT", 5, 11)
  itemCountText.style:SetFontSize(FONT_SIZE.MIDDLE)
  itemCountText.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(itemCountText, FONT_COLOR.MIDDLE_TITLE)
  local spinner = W_ETC.CreateSpinner(window:GetId() .. ".spinner", window)
  spinner:Show(true)
  spinner:SetExtent(83, 34)
  spinner:AddAnchor("LEFT", itemCountText, "RIGHT", 5, 0)
  local maxButton = window:CreateChildWidget("button", "maxButton", 0, true)
  maxButton:SetText(GetCommonText("selective_item_max_count"))
  ApplyButtonSkin(maxButton, BUTTON_BASIC.DEFAULT)
  maxButton:AddAnchor("LEFT", spinner, "RIGHT", 5, 0)
  local function OnMaxClick(self, arg)
    spinner:SetMax()
  end
  maxButton:SetHandler("OnClick", OnMaxClick)
  local centerX = window:GetWidth() / 2
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(GetUIText(COMMON_TEXT, "selective_item"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOMLEFT", window, "BOTTOMLEFT", centerX - okButton:GetWidth(), -20)
  okButton:Enable(false)
  function OnClick(self, arg)
    local function DialogHandler(wnd)
      wnd:SetTitle(GetUIText(COMMON_TEXT, "selective_item"))
      wnd:SetContent(GetUIText(COMMON_TEXT, popup_text))
      function wnd:OkProc()
        X2Bag:HandleSelectiveItems()
        window:Show(false)
      end
    end
    X2Bag:SetSelectiveTryCount(tonumber(spinner:GetValue()))
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
  end
  okButton:SetHandler("OnClick", OnClick)
  local cancelButton = window:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", cancelButton:GetWidth() - centerX, -20)
  function OnCancel(self, arg)
    window:Show(false)
  end
  cancelButton:SetHandler("OnClick", OnCancel)
  function window:SelectiveItemList(data)
    local SetItemName = function(name, grade, gradeColor)
      local resultText = ""
      if grade == nil then
        resultText = name
      else
        resultText = "|c" .. gradeColor .. "[" .. name .. "]"
      end
      return resultText
    end
    local srcItem = data.srcItem
    srcItemText:SetText(SetItemName(srcItem.name, srcItem.grade, srcItem.gradeColor))
    local selectionCount = data.select
    local contentStr = X2Locale:LocalizeUiText(COMMON_TEXT, "selective_item_desc", tostring(selectionCount))
    if data.is_multi then
      contentStr = string.format([[
%s
%s%s]], contentStr, FONT_COLOR_HEX.BLUE, GetCommonText("selective_item_multi_desc"))
    end
    contentLabel:SetText(contentStr)
    spinner:SetMinMaxValues(1, data.maxTryCount)
    spinner:SetValue(1)
    spinner:Enable(data.is_multi)
    maxButton:Enable(data.is_multi)
    scrollList:DeleteAllDatas()
    for i = 1, #data do
      scrollList:InsertRowData(i, 1, data[i])
    end
    scrollList:UpdateView()
    local _, startPos = window:GetOffset()
    local _, endPos = itemCountText:GetOffset()
    endPos = endPos + itemCountText:GetHeight() + cancelButton:GetHeight() + 38
    window:SetHeight(endPos - startPos)
    popup_text = data.popup_text
  end
  function window:ReadyStatusUpdated(status)
    okButton:Enable(status)
  end
  return window
end
local function CreateContentWindow(id, parent)
  local window = SetViewOfWindow(id, parent)
  local lockSlotIndex
  local events = {
    SKILL_SELECTIVE_ITEM = function(list, usingSlotIndex)
      if window ~= nil and window:IsVisible() == false then
        window:Show(true)
      end
      window:SelectiveItemList(list)
      if lockSlotIndex ~= nil then
        X2Bag:UnlockSlot(lockSlotIndex)
      end
      lockSlotIndex = usingSlotIndex
      X2Bag:LockSlot(lockSlotIndex)
    end,
    SKILL_SELECTIVE_ITEM_NOT_AVAILABLE = function()
      AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(COMMON_TEXT, "selective_item_not_available"))
    end,
    SKILL_SELECTIVE_ITEM_READY_STATUS = function(status)
      window:ReadyStatusUpdated(status.ready)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  local function OnHide()
    if lockSlotIndex ~= nil then
      X2Bag:UnlockSlot(lockSlotIndex)
      lockSlotIndex = nil
    end
  end
  window:SetHandler("OnHide", OnHide)
  window:Show(false)
  return window
end
CreateContentWindow("selectiveItemWnd", "UIParent")
