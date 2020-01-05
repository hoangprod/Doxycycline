local ITEM_WIDGET_WIDTH = 190
local ITEM_WIDGET_HEIGHT = 160
local function CreateItemIconWidget(id, parent, str)
  local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
  local title = widget:CreateChildWidget("label", "title", 0, true)
  title:SetText(str)
  title:AddAnchor("TOP", widget, 0, MARGIN.WINDOW_SIDE / 1.5)
  title:SetExtent(ITEM_WIDGET_WIDTH, FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  local item = CreateItemIconButton(string.format("%s.item", id), widget)
  item:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  item:AddAnchor("TOP", title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 1.3)
  item:RegisterForClicks("RightButton")
  widget.item = item
  local name = widget:CreateChildWidget("textbox", "name", 0, true)
  name:SetExtent(ITEM_WIDGET_WIDTH - MARGIN.WINDOW_SIDE, FONT_SIZE.MIDDLE)
  name.style:SetAlign(ALIGN_CENTER)
  name:AddAnchor("TOP", item, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  return widget
end
local CreateValueFrame = function(id, parent)
  local valueFrame = UIParent:CreateWidget("emptywidget", id, parent)
  valueFrame:SetHeight(FONT_SIZE.MIDDLE)
  local bg = valueFrame:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("LEFT", valueFrame, -10, 0)
  bg:AddAnchor("RIGHT", valueFrame, 20, 0)
  local title = valueFrame:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:AddAnchor("LEFT", valueFrame, 0, 0)
  ApplyTextColor(title, FONT_COLOR.DEFAULT)
  local value = valueFrame:CreateChildWidget("textbox", "value", 0, true)
  value:SetHeight(FONT_SIZE.MIDDLE)
  value:AddAnchor("RIGHT", valueFrame, 0, 0)
  value.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(value, FONT_COLOR.BLUE)
  function valueFrame:SetTitle(titleText)
    self.title:SetText(titleText)
  end
  function valueFrame:SetValue(valueType, needValue)
    local str = ""
    if valueType == "money" then
      str = string.format("|m%d;", needValue)
    end
    self.value:SetWidth(500)
    self.value:SetText(str)
    self.value:SetWidth(self.value:GetLongestLineWidth() + 10)
    local width = self.value:GetLongestLineWidth() + self.title:GetWidth() + 40
    self:SetWidth(width)
  end
  return valueFrame
end
local CreateMaterialsWidget = function(id, parent)
  local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
  local title = widget:CreateChildWidget("label", "title", 0, true)
  title:SetText(GetUIText(COMMON_TEXT, "material_item"))
  title:SetHeight(FONT_SIZE.LARGE)
  title:AddAnchor("TOPLEFT", widget, 0, 0)
  title:AddAnchor("TOPRIGHT", widget, 0, 0)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  widget.items = {}
  for i = 1, 5 do
    local item = CreateItemIconButton(string.format("%s.item%d", id, i), widget)
    item:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
    if i == 1 then
      item:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 10)
    else
      item:AddAnchor("LEFT", widget.items[i - 1], "RIGHT", 12, 0)
    end
    widget.items[i] = item
  end
  local feeFrame = W_MODULE:Create("feeFrame", widget, WINDOW_MODULE_TYPE.VALUE_BOX)
  feeFrame:Show(false)
  feeFrame:AddAnchor("BOTTOM", widget, 0, 0)
  return widget
end
function CreateChangeItemLookWnd(id, parent)
  local widget = parent:CreateChildWidget("emptywidget", "changeItemLook", 0, true)
  widget:AddAnchor("TOPLEFT", parent.tab, 0, 27)
  widget:AddAnchor("BOTTOMRIGHT", parent.tab, 0, 0)
  widget.code = id
  local height = 525
  local baseItem = CreateItemIconWidget("baseItem", widget, locale.lookConverter.baseItem)
  baseItem:SetExtent(ITEM_WIDGET_WIDTH, ITEM_WIDGET_HEIGHT)
  baseItem:AddAnchor("TOPLEFT", widget, 0, MARGIN.WINDOW_TITLE)
  local bg = CreateContentBackground(baseItem, "TYPE10", "brown")
  bg:AddAnchor("TOPLEFT", baseItem, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", baseItem, 0, 0)
  local lookItem = CreateItemIconWidget("lookItem", widget, locale.lookConverter.lookItem)
  lookItem:SetExtent(ITEM_WIDGET_WIDTH, ITEM_WIDGET_HEIGHT)
  lookItem:AddAnchor("TOPRIGHT", widget, 0, MARGIN.WINDOW_TITLE)
  local bg = CreateContentBackground(lookItem, "TYPE10", "blue")
  bg:AddAnchor("TOPLEFT", lookItem, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", lookItem, 0, 0)
  local plusDeco = widget:CreateDrawable(TEXTURE_PATH.LOOK_CHANGED, "plus_deco", "overlay")
  plusDeco:AddAnchor("LEFT", baseItem, "RIGHT", -MARGIN.WINDOW_SIDE * 1.1, -MARGIN.WINDOW_SIDE / 2)
  local newItem = CreateItemIconWidget("newItem", widget, locale.lookConverter.newItem)
  newItem:SetExtent(ITEM_WIDGET_WIDTH, ITEM_WIDGET_HEIGHT / 1.4)
  newItem:AddAnchor("TOP", widget, 0, MARGIN.WINDOW_TITLE + ITEM_WIDGET_HEIGHT)
  newItem.title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(newItem.title, FONT_COLOR.MEDIUM_BROWN)
  newItem.item:RemoveAllAnchors()
  newItem.item:AddAnchor("TOP", newItem.title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  local deco_left = newItem:CreateDrawable(TEXTURE_PATH.LOOK_CHANGED, "pattern_left", "overlay")
  deco_left:AddAnchor("RIGHT", newItem.item, "LEFT", -MARGIN.WINDOW_SIDE / 4, -MARGIN.WINDOW_SIDE / 1.5)
  local deco_right = newItem:CreateDrawable(TEXTURE_PATH.LOOK_CHANGED, "pattern_right", "overlay")
  deco_right:AddAnchor("LEFT", newItem.item, "RIGHT", MARGIN.WINDOW_SIDE / 4, -MARGIN.WINDOW_SIDE / 1.5)
  local line = CreateLine(widget, "TYPE1", "overlay")
  line:SetWidth(400)
  line:AddAnchor("TOP", newItem, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  local materials = CreateMaterialsWidget("materials", widget)
  materials:SetExtent(300, ITEM_WIDGET_HEIGHT / 1.5)
  materials:AddAnchor("TOP", newItem, "BOTTOM", 0, MARGIN.WINDOW_SIDE * 1.2)
  local infos = {
    leftButtonStr = locale.lookConverter.convert,
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(widget, infos, parent)
  widget.leftButton:Enable(false)
  local warning = widget:CreateChildWidget("textbox", "warning", 0, true)
  warning:SetWidth(widget:GetWidth() - MARGIN.WINDOW_SIDE * 2)
  warning:SetText(locale.lookConverter.warning)
  warning:SetHeight(warning:GetTextHeight())
  warning:AddAnchor("TOP", materials, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 1.5)
  warning.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(warning, FONT_COLOR.RED)
  widget:SetHeight(height + warning:GetHeight() + MARGIN.WINDOW_SIDE)
  return widget
end
function CreateExtractItemLookWnd(id, parent)
  local widget = parent:CreateChildWidget("emptywidget", "ExtractItemLook", 0, true)
  widget:AddAnchor("TOPLEFT", parent.tab, 0, 27)
  widget:AddAnchor("BOTTOMRIGHT", parent.tab, 0, 0)
  widget.code = id
  local height = 525
  local newItem = CreateItemIconWidget("newItem", widget, locale.lookConverter.newItem)
  newItem:SetExtent(ITEM_WIDGET_WIDTH, ITEM_WIDGET_HEIGHT / 1.4)
  newItem:AddAnchor("TOP", widget, 0, MARGIN.WINDOW_TITLE / 2)
  newItem.title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(newItem.title, FONT_COLOR.MEDIUM_BROWN)
  newItem.item:RemoveAllAnchors()
  newItem.item:AddAnchor("TOP", newItem.title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  local deco_left = newItem:CreateDrawable(TEXTURE_PATH.LOOK_CHANGED, "deco_left", "overlay")
  deco_left:AddAnchor("RIGHT", newItem.item, "LEFT", -MARGIN.WINDOW_SIDE / 4, MARGIN.WINDOW_SIDE / 4)
  local deco_right = newItem:CreateDrawable(TEXTURE_PATH.LOOK_CHANGED, "deco_right", "overlay")
  deco_right:AddAnchor("LEFT", newItem.item, "RIGHT", MARGIN.WINDOW_SIDE / 4, MARGIN.WINDOW_SIDE / 4)
  local baseItem = CreateItemIconWidget("baseItem", widget, locale.lookConverter.baseItem)
  baseItem:SetExtent(ITEM_WIDGET_WIDTH, ITEM_WIDGET_HEIGHT)
  baseItem:AddAnchor("TOPLEFT", widget, 0, MARGIN.WINDOW_TITLE / 2 + newItem:GetHeight() + MARGIN.WINDOW_SIDE / 2)
  local bg = CreateContentBackground(baseItem, "TYPE10", "brown")
  bg:AddAnchor("TOPLEFT", baseItem, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", baseItem, 0, 0)
  local lookItem = CreateItemIconWidget("lookItem", widget, locale.lookConverter.lookItem)
  lookItem:SetExtent(ITEM_WIDGET_WIDTH, ITEM_WIDGET_HEIGHT)
  lookItem:AddAnchor("TOPRIGHT", widget, 0, MARGIN.WINDOW_TITLE / 2 + newItem:GetHeight() + MARGIN.WINDOW_SIDE / 2)
  local bg = CreateContentBackground(lookItem, "TYPE10", "blue")
  bg:AddAnchor("TOPLEFT", lookItem, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", lookItem, 0, 0)
  local line = CreateLine(widget, "TYPE1", "overlay")
  line:SetWidth(400)
  line:AddAnchor("TOP", newItem, 0, MARGIN.WINDOW_TITLE / 2 + newItem:GetHeight() + MARGIN.WINDOW_SIDE / 2 + baseItem:GetHeight())
  local materials = CreateMaterialsWidget("materials", widget)
  materials:SetExtent(300, ITEM_WIDGET_HEIGHT / 1.5)
  materials:AddAnchor("TOP", newItem, 0, MARGIN.WINDOW_TITLE / 2 + newItem:GetHeight() + MARGIN.WINDOW_SIDE / 2 + baseItem:GetHeight() + MARGIN.WINDOW_SIDE / 1.5)
  local infos = {
    leftButtonStr = locale.lookConverter.convert,
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(widget, infos, parent)
  widget.leftButton:Enable(false)
  local warning = widget:CreateChildWidget("textbox", "warning", 0, true)
  warning:SetWidth(widget:GetWidth() - MARGIN.WINDOW_SIDE * 2)
  warning:SetText(GetCommonText("lookRevert_desc"))
  warning:SetHeight(warning:GetTextHeight())
  warning:AddAnchor("TOP", materials, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 1.5)
  warning.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(warning, FONT_COLOR.RED)
  widget:SetHeight(height + warning:GetHeight() + MARGIN.WINDOW_SIDE)
  return widget
end
local CreateItemLookContent = function(parent, tabCodes, interactionNum)
  local content
  content1 = CreateChangeItemLookWnd("TAB_INDEX_CHANGEITEMLOOK", parent)
  content2 = CreateExtractItemLookWnd("TAB_INDEX_EXTRACTITEMLOOK", parent)
  content2:Show(false)
  SetChangeItemLookEventFunction(content1, interactionNum)
  SetChangeItemLookEventFunction(content2, interactionNum)
  return content
end
local featureSet = X2Player:GetFeatureSet()
function SetViewOfChangeItemLookWindow(id, parent, interactionNum)
  local frame = CreateWindow(id, parent, "look_convert")
  frame:SetExtent(430, 650)
  frame:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "look_convert"))
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  local TAB_MENU_TEXT = {
    locale.lookConverter.convert,
    GetUIText(COMMON_TEXT, "extract")
  }
  local TAB_INDEX = {
    "TAB_INDEX_CHANGEITEMLOOK",
    "TAB_INDEX_EXTRACTITEMLOOK"
  }
  local tab = W_BTN.CreateTab("tab", frame)
  tab:AddTabs(TAB_MENU_TEXT)
  if featureSet.itemlookExtract then
    tab.unselectedButton[2]:Show(true)
  else
    tab.selectedButton[2]:Show(false)
    tab.unselectedButton[2]:Show(false)
  end
  frame.contents = CreateItemLookContent(frame, "TAB_INDEX_CHANGEITEMLOOK", interactionNum)
  function tab:OnTabChanged(selected)
    ReAnhorTabLine(tab, selected)
    if selected == 1 then
      self:GetParent().ExtractItemLook:Show(false)
      self:GetParent().ExtractItemLook:Clear()
      self:GetParent().changeItemLook:Show(true)
      self:GetParent().changeItemLook:ShowProc()
    elseif selected == 2 then
      self:GetParent().changeItemLook:Show(false)
      self:GetParent().changeItemLook:Clear()
      self:GetParent().ExtractItemLook:Show(true)
      self:GetParent().ExtractItemLook:ShowProc()
    end
  end
  tab:SetHandler("OnTabChanged", tab.OnTabChanged)
  return frame
end
