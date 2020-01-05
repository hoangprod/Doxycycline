local CreateSpecialtyInfoWindow = function(id, parent)
  local COL = {NAME = 1, RATIO = 2}
  local GetTableSort = function(targetTable)
    local Sort = function(a, b)
      return a.name < b.name and true or false
    end
    table.sort(targetTable, Sort)
    return targetTable
  end
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(FORM_SPECIALTY_WINDOW.WINDOW_WIDTH, 495)
  window:SetTitle(GetCommonText("specialty_info_title"))
  local upperBg = CreateContentBackground(window, "TYPE10", "brown", "artwork")
  upperBg:SetExtent(window:GetWidth() - sideMargin, 135)
  upperBg:AddAnchor("TOPLEFT", window, sideMargin / 2, titleMargin - 7)
  local productionArea = window:CreateChildWidget("label", "productionArea", 0, true)
  productionArea:SetHeight(FONT_SIZE.MIDDLE)
  productionArea:AddAnchor("TOPLEFT", upperBg, 15, sideMargin - 2)
  productionArea.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(productionArea, FONT_COLOR.DEFAULT)
  productionArea:SetText(GetCommonText("specialty_info_production_area"))
  local destinationArea = window:CreateChildWidget("label", "destinationArea", 0, true)
  destinationArea:SetHeight(FONT_SIZE.MIDDLE)
  destinationArea:AddAnchor("TOPLEFT", productionArea, "BOTTOMLEFT", 0, sideMargin)
  destinationArea.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(destinationArea, FONT_COLOR.DEFAULT)
  destinationArea:SetText(GetCommonText("specialty_info_destination_area"))
  local textWidgets = {productionArea, destinationArea}
  F_LAYOUT.AdjustTextWidth(textWidgets)
  local comboBoxWidth = upperBg:GetWidth() - productionArea:GetWidth() - sideMargin * 1.8
  local productionFilter = W_CTRL.CreateComboBox("productionFilter", window)
  productionFilter:SetWidth(comboBoxWidth)
  productionFilter:SetEllipsis(true)
  productionFilter:ShowDropdownTooltip(true)
  productionFilter:AddAnchor("LEFT", productionArea, "RIGHT", 7, 1)
  local destinationFilter = W_CTRL.CreateComboBox("destinationFilter", window)
  destinationFilter:SetWidth(comboBoxWidth)
  destinationFilter:SetEllipsis(true)
  destinationFilter:ShowDropdownTooltip(true)
  destinationFilter:AddAnchor("LEFT", destinationArea, "RIGHT", 7, 0)
  local searchButton = window:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:SetText(GetCommonText("search"))
  searchButton:AddAnchor("BOTTOM", upperBg, 0, -sideMargin)
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  function window:ClearCombobox(combo)
    combo:Clear()
  end
  function productionFilter:SelectedProc(index)
    local info = self:GetSelectedInfo()
    local selZoneGroup = info.value
    local destinationZones = X2Store:GetSellableZoneGroups(selZoneGroup)
    destinationZones = GetTableSort(destinationZones)
    if #destinationZones == 0 then
      window:ClearCombobox(destinationFilter)
      scrollListCtrl:DeleteAllDatas()
      return
    end
    local destinationZoneNames = {}
    for i = 1, #destinationZones do
      local data = {
        text = destinationZones[i].name,
        value = destinationZones[i].id
      }
      table.insert(destinationZoneNames, data)
    end
    destinationFilter:AppendItems(destinationZoneNames)
    destinationFilter:SetVisibleItemCount(10)
    searchButton:Enable(true)
  end
  local function SearchButtonOnUpdate(self, dt)
    if self.cooldownTime <= 0 then
      searchButton:Enable(true)
      searchButton:ReleaseHandler("OnUpdate")
      return
    end
    self.cooldownTime = self.cooldownTime - dt
  end
  local function SearchButtonLeftClickFunc(self)
    local productionSelected = productionFilter:GetSelectedInfo()
    local destinationSelected = destinationFilter:GetSelectedInfo()
    if productionSelected == nil or destinationSelected == nil then
      return
    end
    local productionSelKey = productionSelected.value
    local destinationSelKey = destinationSelected.value
    if productionSelKey == nil or destinationSelKey == nil or productionSelKey == 0 or destinationSelKey == 0 then
      return
    end
    local cooldownTime = X2Store:GetSpecialtyRatioBetween(productionSelKey, destinationSelKey)
    searchButton:Enable(false)
    self.cooldownTime = cooldownTime
    self.tip = GetCommonText("specialty_info_search_wait")
    if not self:HasHandler("OnUpdate") then
      self:SetHandler("OnUpdate", SearchButtonOnUpdate)
    end
  end
  ButtonOnClickHandler(searchButton, SearchButtonLeftClickFunc)
  local OnEnter = function(self)
    if self.tip == nil or self.tip == "" then
      return
    end
    if self:IsEnabled() then
      return
    end
    SetTooltip(self.tip, self)
  end
  searchButton:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  searchButton:SetHandler("OnLeave", OnLeave)
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", window)
  scrollListCtrl:SetExtent(window:GetWidth() - sideMargin * 2, 300)
  scrollListCtrl:AddAnchor("TOP", upperBg, "BOTTOM", 0, 0)
  local NameColumnDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data ~= nil then
        subItem.slot:Show(true)
        subItem:SetText(data.name)
        subItem.slot:SetItem(data.itemType, data.itemGrade)
      end
    else
      subItem.slot:Show(false)
      subItem:SetText("")
    end
  end
  local NameColumnLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local slot = CreateSlotItemButton("slot", subItem)
    slot:AddAnchor("LEFT", subItem, 0, 0)
    slot:Show(false)
    subItem.slot = slot
    subItem:SetInset(slot:GetWidth() + 5, 0, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local RatioColumnDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:Show(true)
      subItem:SetText(string.format("%d%%", data))
    else
      subItem:Show(false)
    end
  end
  local function NameAscendingSortFunc(a, b)
    return a[ROWDATA_COLUMN_OFFSET + COL.NAME].name < b[ROWDATA_COLUMN_OFFSET + COL.NAME].name
  end
  local function NameDescendingSortFunc(a, b)
    return a[ROWDATA_COLUMN_OFFSET + COL.NAME].name > b[ROWDATA_COLUMN_OFFSET + COL.NAME].name
  end
  local function RatioAscendingSortFunc(a, b)
    return a[ROWDATA_COLUMN_OFFSET + COL.RATIO] < b[ROWDATA_COLUMN_OFFSET + COL.RATIO]
  end
  local function RatioDescendingSortFunc(a, b)
    return a[ROWDATA_COLUMN_OFFSET + COL.RATIO] > b[ROWDATA_COLUMN_OFFSET + COL.RATIO]
  end
  local targetWidth = scrollListCtrl.listCtrl:GetWidth()
  scrollListCtrl:InsertColumn(GetCommonText("goods_name"), targetWidth * 0.75, LCCIT_STRING, NameColumnDataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, NameColumnLayoutSetFunc)
  scrollListCtrl:InsertColumn(locale.store_specialty.prices, targetWidth * 0.25, LCCIT_STRING, RatioColumnDataSetFunc, RatioAscendingSortFunc, RatioDescendingSortFunc)
  scrollListCtrl:InsertRows(5, false)
  for i = 1, #scrollListCtrl.listCtrl.column do
    SettingListColumn(scrollListCtrl.listCtrl, scrollListCtrl.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(scrollListCtrl.listCtrl.column[i], #scrollListCtrl.listCtrl.column, i)
  end
  local underLine = CreateLine(scrollListCtrl, "TYPE1")
  underLine:AddAnchor("TOPLEFT", scrollListCtrl.listCtrl, -sideMargin / 2, LIST_COLUMN_HEIGHT - 2)
  underLine:AddAnchor("TOPRIGHT", scrollListCtrl.listCtrl, sideMargin / 1.5, LIST_COLUMN_HEIGHT - 2)
  function window:ShowProc()
    productionFilter:Select(1)
    scrollListCtrl:DeleteAllDatas()
  end
  local productionZones = X2Store:GetProductionZoneGroups()
  productionZones = GetTableSort(productionZones)
  local productionZoneNames = {}
  for i = 1, #productionZones do
    local data = {
      text = productionZones[i].name,
      value = productionZones[i].id
    }
    table.insert(productionZoneNames, data)
  end
  if #productionZones == 0 then
    window:ClearCombobox(productionFilter)
    scrollListCtrl:DeleteAllDatas()
  else
    productionFilter:AppendItems(productionZoneNames)
    productionFilter:SetVisibleItemCount(10)
  end
  local function FillRatioInfo(specialtyRatioTable)
    scrollListCtrl:DeleteAllDatas()
    for i = 1, #specialtyRatioTable do
      scrollListCtrl:InsertData(i, 1, specialtyRatioTable[i].itemInfo)
      scrollListCtrl:InsertData(i, 2, specialtyRatioTable[i].ratio)
    end
  end
  local events = {
    SPECIALTY_RATIO_BETWEEN_INFO = function(specialtyRatioTable)
      FillRatioInfo(specialtyRatioTable)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local specialtyInfoWnd = CreateSpecialtyInfoWindow("specialtyInfoWnd", "UIParent")
specialtyInfoWnd:AddAnchor("CENTER", "UIParent", 0, 0)
function ToggleSpecialtyInfo(show)
  if show == nil then
    show = not specialtyInfoWnd:IsVisible()
  end
  specialtyInfoWnd:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_SPECIALTY_INFO, ToggleSpecialtyInfo)
