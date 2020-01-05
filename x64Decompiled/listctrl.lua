LIST_COLUMN_HEIGHT = 35
ROWDATA_COLUMN_OFFSET = 1
function DrawListCtrlColumnSperatorLine(widget, totalCount, count, colorWhite)
  local inset = 3
  if colorWhite == nil then
    colorWhite = false
  end
  local divideLine
  if count < totalCount then
    divideLine = widget:CreateDrawable(TEXTURE_PATH.TAB_LIST, "list_column_line_df", "overlay")
    if count % 3 == 1 then
      divideLine:SetExtent(24, 55)
      divideLine:SetTextureInfo("list_column_line_1")
      divideLine:AddAnchor("BOTTOMLEFT", widget, "BOTTOMRIGHT", 0, 33)
    elseif count % 3 == 2 then
      divideLine:SetExtent(25, 51)
      divideLine:SetTextureInfo("list_column_line_2")
      divideLine:AddAnchor("BOTTOMLEFT", widget, "BOTTOMRIGHT", 0, 22)
    else
      divideLine:SetExtent(25, 15)
      divideLine:AddAnchor("BOTTOMLEFT", widget, "BOTTOMRIGHT", 0, 0)
    end
    if not colorWhite then
      divideLine:SetTextureColor("default")
    end
  end
  return divideLine
end
function SettingListColumn(listCtrl, column, height)
  if height == nil then
    height = LIST_COLUMN_HEIGHT
  end
  listCtrl:SetColumnHeight(height)
  ApplyButtonSkin(column, BUTTON_BASIC.LISTCTRL_COLUMN)
  column.style:SetShadow(false)
  column.style:SetFontSize(FONT_SIZE.LARGE)
  SetButtonFontColor(column, GetButtonDefaultFontColor())
end
function DrawListCtrlUnderLine(listCtrl, offsetY, colorWhite, offsetX)
  if colorWhite == nil then
    colorWhite = false
  end
  local width = listCtrl:GetWidth()
  if offsetX == nil then
    offsetX = 0
  end
  local underLine_1 = listCtrl:CreateDrawable(TEXTURE_PATH.TAB_LIST, "underline_1", "artwork")
  underLine_1:SetExtent(width / 2, 3)
  local underLine_2 = listCtrl:CreateDrawable(TEXTURE_PATH.TAB_LIST, "underline_2", "artwork")
  underLine_2:SetExtent(width / 2, 3)
  if not colorWhite then
    underLine_1:SetTextureColor("default")
    underLine_2:SetTextureColor("default")
  end
  if offsetY == nil then
    underLine_1:AddAnchor("TOPLEFT", listCtrl, offsetX, LIST_COLUMN_HEIGHT - 2)
    underLine_2:AddAnchor("TOPRIGHT", listCtrl, -offsetX, LIST_COLUMN_HEIGHT - 2)
  else
    underLine_1:AddAnchor("TOPLEFT", listCtrl, offsetX, offsetY)
    underLine_2:AddAnchor("TOPRIGHT", listCtrl, -offsetX, offsetY)
  end
end
function DefaultListItemSetting(item)
  if item.SetInset == nil or item.style == nil then
    return
  end
  item.style:SetSnap(true)
  item.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(item, FONT_COLOR.DEFAULT)
end
function DrawItemUnderLine(item, layer)
  local line = CreateLine(item, "TYPE1", layer)
  line:AddAnchor("TOPLEFT", item, "BOTTOMLEFT", -30, -1)
  line:AddAnchor("TOPRIGHT", item, "BOTTOMRIGHT", 30, -1)
  return line
end
function ListCtrlItemGuideLine(items, maxCount, insetInfo)
  local leftInset = 0
  local rightInset = 0
  local yInset = 2
  if insetInfo ~= nil then
    if insetInfo.leftInset ~= nil then
      leftInset = insetInfo.leftInset
    end
    if insetInfo.rightInset ~= nil then
      rightInset = insetInfo.rightInset
    end
    if insetInfo.yInset ~= nil then
      yInset = insetInfo.yInset
    end
  end
  for i = 1, maxCount do
    if i ~= maxCount then
      local line = CreateLine(items[i], "TYPE1")
      line:SetVisible(false)
      line:SetColor(1, 1, 1, 0.5)
      line:AddAnchor("BOTTOMLEFT", items[i], leftInset, yInset)
      line:AddAnchor("BOTTOMRIGHT", items[i], rightInset, yInset)
      items[i].line = line
    end
  end
end
function W_CTRL.CreateListCtrl(id, parent)
  local listCtrl = parent:CreateChildWidgetByType(UOT_LIST_CTRL, id, 0, true)
  listCtrl:AddAnchor("TOPLEFT", parent, 0, 0)
  listCtrl:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  parent.listCtrl = listCtrl
  parent.dataCount = 0
  parent.datas = {}
  listCtrl.selectedDataIndex = 0
  listCtrl.selectedDataKey = nil
  function parent:InsertColumn(columnName, width, itemType, layoutFunc, dataSetFunc)
    self.listCtrl:InsertColumn(width, itemType)
    local columnIndex = #self.listCtrl.column
    local column = self.listCtrl.column[columnIndex]
    column.layoutFunc = layoutFunc
    column.dataSetFunc = dataSetFunc
    column:SetText(columnName)
    SettingListColumn(listCtrl, column)
  end
  function parent:InsertRows(count, useEventWindow)
    self.listCtrl:InsertRows(count, useEventWindow)
    local rowCount = #self.listCtrl.items
    for i = 1, rowCount do
      for j = 1, #self.listCtrl.column do
        local column = self.listCtrl.column[j]
        if column.layoutFunc ~= nil then
          column.layoutFunc(self, i, j, self.listCtrl.items[i].subItems[j])
        else
          DefaultListItemSetting(self.listCtrl.items[i].subItems[j])
        end
      end
    end
    if self.SetMinMaxValues then
      self:SetMinMaxValues(0, self.dataCount - rowCount)
    end
  end
  local function UpdateItem(rowIdx, colIdx)
    local row = parent.listCtrl.items[rowIdx]
    if row == nil then
      return
    end
    local col = parent.listCtrl.column[colIdx]
    if col == nil then
      return
    end
    local data = parent:GetData(rowIdx, colIdx)
    local subItem = row.subItems[colIdx]
    if col.dataSetFunc ~= nil then
      col.dataSetFunc(subItem, data, true)
    else
      subItem:SetText(data)
    end
  end
  function parent:GetDataByViewIndex(row, col)
    return parent:GetData(row, col)
  end
  function parent:GetDataByDataIndex(row, col)
    local rowData = self.datas[row]
    return rowData[col + ROWDATA_COLUMN_OFFSET]
  end
  function parent:DeleteData(key)
    for i = 1, #self.datas do
      local rowData = self.datas[i]
      if rowData[ROWDATA_COLUMN_OFFSET] == key then
        self.listCtrl:DeleteData(i)
        return
      end
    end
  end
  function parent:UpdateView()
    if self.listCtrl.items == nil then
      return
    end
    local rowCount = #self.listCtrl.items
    local colCount = #self.listCtrl.column
    local rowIndex = 1
    for i = 1, #self.datas do
      local rowData = self.datas[i]
      if i <= rowCount then
        local row = self.listCtrl.items[rowIndex]
        if rowData ~= nil and row ~= nil then
          for j = 1, colCount do
            local subItem = row.subItems[j]
            local curCol = self.listCtrl.column[j]
            if rowData[j + ROWDATA_COLUMN_OFFSET] ~= nil and subItem ~= nil then
              if curCol.dataSetFunc ~= nil then
                curCol.dataSetFunc(subItem, rowData[j + ROWDATA_COLUMN_OFFSET], true)
              else
                subItem:SetText(tostring(rowData[j + ROWDATA_COLUMN_OFFSET]))
              end
            end
          end
        end
        rowIndex = rowIndex + 1
      end
    end
    for i = rowIndex, rowCount do
      local row = self.listCtrl.items[i]
      if row ~= nil then
        for j = 1, colCount do
          local subItem = row.subItems[j]
          local curCol = self.listCtrl.column[j]
          if subItem ~= nil then
            if curCol.dataSetFunc ~= nil then
              curCol.dataSetFunc(subItem, "", false)
            else
              subItem:SetText("")
            end
          end
        end
      end
    end
  end
  function parent:InsertData(key, columnIndex, data, enableFirstSorting, updateNow)
    if enableFirstSorting == nil then
      enableFirstSorting = false
    end
    if updateNow == nil then
      updateNow = true
    end
    local rowData
    local findedDataIndex = 0
    for i = 1, #self.datas do
      rowData = self.datas[i]
      if rowData[ROWDATA_COLUMN_OFFSET] == key then
        findedDataIndex = i
        break
      end
    end
    if findedDataIndex == 0 then
      rowData = {}
      rowData[ROWDATA_COLUMN_OFFSET] = key
      self.datas[#self.datas + 1] = rowData
      findedDataIndex = #self.datas
      self.dataCount = self.dataCount + 1
    end
    if self.dataCount <= #self.listCtrl.items then
      self.listCtrl:InsertData(self.dataCount, 1, "")
    end
    rowData[columnIndex + ROWDATA_COLUMN_OFFSET] = data
    if self.SetMinMaxValues then
      local rowCount = #self.listCtrl.items
      self:SetMinMaxValues(0, self.dataCount - rowCount)
    end
    if enableFirstSorting then
      self:FirstSorting()
    elseif self.listCtrl.AscendingSortMark then
      self.listCtrl.AscendingSortMark:SetVisible(false)
      self.listCtrl.DescendingSortMark:SetVisible(false)
    end
    if updateNow then
      self:UpdateView()
    end
  end
  function parent:UpdateData(key, columnIndex, newData)
    local foundRow = 0
    for i = 1, #self.datas do
      local data = self.datas[i]
      local itemKey = data[ROWDATA_COLUMN_OFFSET]
      if itemKey == key then
        data[ROWDATA_COLUMN_OFFSET + columnIndex] = newData
        foundRow = i
        break
      end
    end
    if foundRow == 0 then
      return
    end
    UpdateItem(foundRow, columnIndex)
  end
  function parent:GetDataByKey(key, col)
    for i = 1, #self.datas do
      local data = self.datas[i]
      local itemKey = data[ROWDATA_COLUMN_OFFSET]
      if itemKey == key then
        return data[ROWDATA_COLUMN_OFFSET + col]
      end
    end
  end
  function parent:GetData(row, col)
    local rowData = self.datas[row]
    if rowData == nil then
      return
    end
    return rowData[col + ROWDATA_COLUMN_OFFSET]
  end
  function parent:GetKey(row, col)
    local rowData = self.datas[row]
    if rowData == nil then
      return
    end
    return rowData[col]
  end
  function parent:DeleteAllDatas()
    self.datas = {}
    self.dataCount = 0
    self.listCtrl:DeleteAllDatas()
    if self.SetMinMaxValues then
      self:SetMinMaxValues(0, 0)
    end
    self:UpdateView()
  end
  function parent:GetRowCount()
    if self.listCtrl.items == nil then
      return 0
    end
    return #self.listCtrl.items
  end
  function parent:GetListCtrlItems()
    return self.listCtrl.items
  end
  function parent:GetDataCount()
    return self.dataCount
  end
  function parent:GetTopDataIndex()
    return self.topDataIndex
  end
  function parent:SetTopDataIndex(index)
    self.topDataIndex = index
  end
  function parent:GetColumns()
    return parent.listCtrl.column
  end
  function parent:GetListCtrlItem(rowIndex)
    if self.listCtrl.items == nil then
      return
    end
    if rowIndex > #self.listCtrl.items then
      return
    end
    return self.listCtrl.items[rowIndex]
  end
  function parent:GetListCtrlSubItem(rowIndex, colIndex)
    if self.listCtrl.items == nil then
      return
    end
    if rowIndex > #self.listCtrl.items then
      return
    end
    if colIndex > #self.listCtrl.items[rowIndex].subItems then
      return
    end
    return self.listCtrl.items[rowIndex].subItems[colIndex]
  end
  function parent:GetDatas()
    return self.datas
  end
  function listCtrl:UseSortMark()
    local ascendingSortMark = self:CreateDrawable(TEXTURE_PATH.TAB_LIST, "list_sort_mark_asc", "overlay")
    ascendingSortMark:SetVisible(false)
    ascendingSortMark:SetExtent(23, 23)
    self.AscendingSortMark = ascendingSortMark
    local descendingSortMark = self:CreateDrawable(TEXTURE_PATH.TAB_LIST, "list_sort_mark_des", "overlay")
    descendingSortMark:SetVisible(false)
    descendingSortMark:SetExtent(23, 23)
    self.DescendingSortMark = descendingSortMark
  end
  function listCtrl:ChangeSortMartTexture()
    self.AscendingSortMark:SetCoords(172, 65, 10, 7)
    self.AscendingSortMark:SetExtent(10, 7)
    self.AscendingSortMark:SetVisible(false)
    self.DescendingSortMark:SetCoords(172, 72, 10, -7)
    self.DescendingSortMark:SetExtent(10, 7)
    self.DescendingSortMark:SetVisible(false)
  end
  function listCtrl:DisuseSorting()
    for i = 1, #self.column do
      self.column[i]:Enable(false)
    end
    if self.AscendingSortMark then
      self.AscendingSortMark:SetVisible(false)
      self.DescendingSortMark:SetVisible(false)
    end
  end
  function parent:ChangeFirstSorting(index, firstSortFunc_useAscending)
    self.lastClickColumn = self.listCtrl.column[index]
    if firstSortFunc_useAscending then
      self.lastSortFunc = self.lastClickColumn.sortFunc1
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc2
    else
      self.lastSortFunc = self.lastClickColumn.sortFunc2
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc1
    end
  end
  function parent:SetUseDoubleClick(use)
    self.useDoubleClick = use
    self.listCtrl:SetUseDoubleClick(use)
  end
  function parent:HideColumnButtons()
    self.listCtrl:SetColumnHeight(0)
  end
  function parent:ClearSelection()
    self.listCtrl:ClearSelection()
  end
  function parent:CreateSelectedImage()
    self.selectedImage = self.listCtrl:CreateSelectedImage()
  end
  function listCtrl:OnSelChanged(selectedIndex, doubleClick)
    local rowData = parent.datas[selectedIndex]
    if rowData == nil then
      return
    end
    self.selectedDataIndex = selectedIndex
    if rowData ~= nil then
      self.selectedDataKey = rowData[ROWDATA_COLUMN_OFFSET]
    end
    if parent.SelChangedProc ~= nil then
      parent:SelChangedProc(self.selectedDataIndex, self.selectedDataIndex, self.selectedDataKey, doubleClick)
    end
  end
  listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
  function listCtrl:DrawListLine(lineType, needUpper, needLower)
    local leftInset = 0
    local rightInset = 0
    local yInset = 2
    if insetInfo ~= nil then
      if insetInfo.leftInset ~= nil then
        leftInset = insetInfo.leftInset
      end
      if insetInfo.rightInset ~= nil then
        rightInset = insetInfo.rightInset
      end
      if insetInfo.yInset ~= nil then
        yInset = insetInfo.yInset
      end
    end
    if lineType == nil then
      lineType = "TYPE1"
    end
    local maxCount = needLower and #self.items or #self.items - 1
    for i = 1, maxCount do
      local item = self.items[i]
      local line = CreateLine(item, lineType)
      line:AddAnchor("BOTTOMLEFT", item, leftInset, yInset)
      line:AddAnchor("BOTTOMRIGHT", item, rightInset, yInset)
      item.line = line
    end
    if needUpper then
      local item = self.items[1]
      local line = CreateLine(item, lineType)
      line:AddAnchor("BOTTOMLEFT", item, "TOPLEFT", leftInset, -yInset)
      line:AddAnchor("BOTTOMRIGHT", item, "TOPRIGHT", rightInset, -yInset)
    end
  end
  function listCtrl:UseOverClickTexture(style)
    if style == nil or style == "" then
      self.overedImage = listCtrl:CreateOveredImage()
      self.overedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
      self.overedImage:SetCoords(0, 65, 134, 11)
      self.overedImage:SetInset(66, 5, 67, 5)
      self.overedImage:SetColor(ConvertColor(150), ConvertColor(197), ConvertColor(220), 0.4)
      self.selectedImage = listCtrl:CreateSelectedImage()
      self.selectedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
      self.selectedImage:SetCoords(0, 65, 134, 11)
      self.selectedImage:SetInset(66, 5, 67, 5)
      self.selectedImage:SetColor(ConvertColor(150), ConvertColor(197), ConvertColor(220), 0.6)
    elseif style == "red" then
      self.overedImage = listCtrl:CreateOveredImage()
      self.overedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
      self.overedImage:SetCoords(0, 65, 134, 11)
      self.overedImage:SetInset(66, 5, 67, 5)
      self.overedImage:SetColor(ConvertColor(220), ConvertColor(150), ConvertColor(150), 0.4)
      self.selectedImage = listCtrl:CreateSelectedImage()
      self.selectedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
      self.selectedImage:SetCoords(0, 65, 134, 11)
      self.selectedImage:SetInset(66, 5, 67, 5)
      self.selectedImage:SetColor(ConvertColor(220), ConvertColor(150), ConvertColor(150), 0.6)
    elseif style == "achievement" then
      self.overedImage = listCtrl:CreateOveredImage()
      self.overedImage:SetTexture(TEXTURE_PATH.ACHIEVEMENT)
      self.overedImage:SetTextureInfo("slot_ov")
      self.selectedImage = listCtrl:CreateSelectedImage()
      self.selectedImage:SetTexture(TEXTURE_PATH.ACHIEVEMENT)
      self.selectedImage:SetTextureInfo("slot_ov")
    elseif style == "server_select" then
      self.overedImage = listCtrl:CreateOveredImage()
      self.overedImage:SetTexture(TEXTURE_PATH.DEFAULT_NEW)
      self.overedImage:SetTextureInfo("common_ov", "default")
      self.selectedImage = listCtrl:CreateSelectedImage()
      self.selectedImage:SetTexture(TEXTURE_PATH.DEFAULT_NEW)
      self.selectedImage:SetTextureInfo("bg", "common_selected")
    end
  end
  return listCtrl
end
