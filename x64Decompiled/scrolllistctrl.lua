SCROLLLIST_COMMON_COL = {NAME = 1, LV = 2}
function W_CTRL.CreateScrollListCtrl(id, parent, index)
  if index == nil then
    index = 0
  end
  local frame = parent:CreateChildWidget("emptywidget", id, index, true)
  frame:Show(true)
  frame.useDoubleClick = false
  frame.topDataIndex = 1
  frame.selectedDataIndex = 0
  frame.selectedDataKey = nil
  frame.dataCount = 0
  frame.datas = {}
  frame.lastClickColumn = nil
  frame.lastSortFunc = nil
  frame.callbackColumnClicked = nil
  frame.useSort = true
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", frame)
  listCtrl:EnableScroll(true)
  listCtrl:Show(true)
  listCtrl:UseSortMark()
  frame.listCtrl = listCtrl
  local scroll = W_CTRL.CreateScroll("scroll", frame)
  scroll:AddAnchor("TOPRIGHT", frame, 0, 40)
  scroll:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  frame.scroll = scroll
  listCtrl:RemoveAllAnchors()
  listCtrl:AddAnchor("TOPLEFT", frame, 0, 0)
  listCtrl:AddAnchor("BOTTOM", frame, 0, 0)
  listCtrl:AddAnchor("RIGHT", scroll, "LEFT", -3, 0)
  frame.mark_yOffset = 2
  function frame:SetSortMarkOffsetY(val)
    if val == nil then
      val = -3
    end
    self.mark_yOffset = val
  end
  function frame:GetSelectedRowViewIndex(selectedDataIndex)
    local rowCount = #self.listCtrl.items
    local selectedIndex = 0
    if selectedDataIndex >= self.topDataIndex and selectedDataIndex < self.topDataIndex + rowCount then
      selectedIndex = selectedDataIndex - self.topDataIndex + 1
    end
    return selectedIndex
  end
  function listCtrl:OnSelChanged(selectedIndex, doubleClick)
    frame.selectedDataIndex = 0
    frame.selectedDataKey = nil
    local temp = frame.topDataIndex + selectedIndex - 1
    if temp > frame.dataCount then
      self:Select(-1, false)
      return
    end
    local rowData = frame.datas[temp]
    frame.selectedDataIndex = temp
    if rowData ~= nil then
      frame.selectedDataKey = rowData[ROWDATA_COLUMN_OFFSET]
    end
    if frame.SelChangedProc ~= nil then
      frame:SelChangedProc(frame:GetSelectedRowViewIndex(frame.selectedDataIndex), frame.selectedDataIndex, frame.selectedDataKey, doubleClick)
    end
  end
  listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
  local function OnSliderChanged(self, _value)
    frame.topDataIndex = math.floor(_value) + 1
    local selectedIndex = frame:GetSelectedRowViewIndex(frame.selectedDataIndex)
    if selectedIndex ~= frame.listCtrl:GetSelectedIdx() then
      frame.listCtrl:Select(selectedIndex - 1, false)
    end
    if frame.OnSliderChangedProc ~= nil then
      frame:OnSliderChangedProc()
    end
    frame:UpdateView()
  end
  scroll.vs:SetHandler("OnSliderChanged", OnSliderChanged)
  function frame:InsertColumn(columnName, width, itemType, dataSetFunc, sortFunc1, sortFunc2, layoutFunc)
    self.listCtrl:InsertColumn(width, itemType)
    local columnIndex = #self.listCtrl.column
    local column = self.listCtrl.column[columnIndex]
    column.index = columnIndex
    column.dataSetFunc = dataSetFunc
    column.sortFunc1 = sortFunc1 or function()
    end
    column.sortFunc2 = sortFunc2 or function()
    end
    column.curSortFunc = sortFunc1 or function()
    end
    column.layoutFunc = layoutFunc
    column:SetText(columnName)
    column.sortMark_xOffset = column.style:GetTextWidth(columnName) + 10
    if self.lastClickColumn == nil and sortFunc1 ~= nil and sortFunc2 ~= nil then
      self.lastClickColumn = self.listCtrl.column[1]
      self.lastSortFunc = self.lastClickColumn.sortFunc1
      self.listCtrl.AscendingSortMark:SetVisible(true)
      self.listCtrl.DescendingSortMark:SetVisible(false)
      self.listCtrl.AscendingSortMark:RemoveAllAnchors()
      self.listCtrl.AscendingSortMark:AddAnchor("LEFT", self.lastClickColumn, "CENTER", self.lastClickColumn.sortMark_xOffset / 2, frame.mark_yOffset)
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc2
    end
    function column:OnClick()
      local isViewUpdateRequired = false
      if frame.useSort == false then
        return
      end
      if self.curSortFunc ~= nil then
        table.sort(frame.datas, self.curSortFunc)
        isViewUpdateRequired = true
        frame.lastClickColumn = self
        frame.lastSortFunc = self.curSortFunc
        if self.curSortFunc == self.sortFunc1 and self.sortFunc2 ~= nil then
          self.curSortFunc = self.sortFunc2
          frame.listCtrl.AscendingSortMark:SetVisible(true)
          frame.listCtrl.DescendingSortMark:SetVisible(false)
          frame.listCtrl.AscendingSortMark:RemoveAllAnchors()
          frame.listCtrl.AscendingSortMark:AddAnchor("LEFT", frame.listCtrl.column[columnIndex], "CENTER", self.sortMark_xOffset / 2, frame.mark_yOffset)
        elseif self.curSortFunc == self.sortFunc2 and self.sortFunc1 ~= nil then
          self.curSortFunc = self.sortFunc1
          frame.listCtrl.AscendingSortMark:SetVisible(false)
          frame.listCtrl.DescendingSortMark:SetVisible(true)
          frame.listCtrl.DescendingSortMark:RemoveAllAnchors()
          frame.listCtrl.DescendingSortMark:AddAnchor("LEFT", frame.listCtrl.column[columnIndex], "CENTER", self.sortMark_xOffset / 2, frame.mark_yOffset)
        end
        if frame.selectedDataKey ~= nil then
          for i = 1, #frame.datas do
            local rowData = frame.datas[i]
            if rowData[ROWDATA_COLUMN_OFFSET] == frame.selectedDataKey then
              frame.selectedDataIndex = i
              frame:ScrollToDataIndex(frame.selectedDataKey, 1)
              break
            end
          end
        end
      end
      if isViewUpdateRequired == false then
        return
      end
      frame:UpdateView()
    end
    column:SetHandler("OnClick", column.OnClick)
  end
  function frame:ScrollToDataIndex(dataKey, viewIndex)
    for i = 1, #frame.datas do
      local rowData = frame.datas[i]
      if rowData[ROWDATA_COLUMN_OFFSET] == dataKey then
        local dataIndex = i - viewIndex + 1
        local _min, _max = scroll.vs:GetMinMaxValues()
        local scrollValue
        if _min > dataIndex - 1 then
          scrollValue = _min
        elseif _max < dataIndex - 1 then
          scrollValue = _max
        else
          scrollValue = dataIndex - 1
        end
        self.scroll.vs:SetValue(scrollValue, true)
        return
      end
    end
  end
  function frame:SetColumnHeight(height)
    self.listCtrl:SetColumnHeight(height)
    scroll:AddAnchor("TOPRIGHT", frame, 0, height)
  end
  function frame:UpdateView()
    local rowCount = #self.listCtrl.items
    local colCount = #self.listCtrl.column
    local rowIndex = 1
    for i = 1, #self.datas do
      local rowData = self.datas[i]
      if i >= self.topDataIndex and i < self.topDataIndex + rowCount then
        local row = self.listCtrl.items[rowIndex]
        if rowData ~= nil and row ~= nil then
          for j = 1, colCount do
            local subItem = row.subItems[j]
            local curCol = self.listCtrl.column[j]
            if rowData[j + ROWDATA_COLUMN_OFFSET] ~= nil and subItem ~= nil and curCol.dataSetFunc ~= nil then
              curCol.dataSetFunc(subItem, rowData[j + ROWDATA_COLUMN_OFFSET], true)
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
          if subItem ~= nil and curCol.dataSetFunc ~= nil then
            curCol.dataSetFunc(subItem, "", false)
          end
        end
      end
    end
  end
  function frame:FirstSorting()
    if self.lastSortFunc == self.lastClickColumn.sortFunc1 then
      self.listCtrl.AscendingSortMark:SetVisible(true)
      self.listCtrl.DescendingSortMark:SetVisible(false)
      self.listCtrl.AscendingSortMark:RemoveAllAnchors()
      self.listCtrl.AscendingSortMark:AddAnchor("CENTER", self.lastClickColumn, self.lastClickColumn.sortMark_xOffset, frame.mark_yOffset)
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc2
    elseif self.lastSortFunc == self.lastClickColumn.sortFunc2 then
      self.listCtrl.AscendingSortMark:SetVisible(false)
      self.listCtrl.DescendingSortMark:SetVisible(true)
      self.listCtrl.DescendingSortMark:RemoveAllAnchors()
      self.listCtrl.DescendingSortMark:AddAnchor("CENTER", self.lastClickColumn, self.lastClickColumn.sortMark_xOffset, frame.mark_yOffset)
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc1
    end
    table.sort(self.datas, self.lastSortFunc)
    if frame.selectedDataKey ~= nil then
      for i = 1, #frame.datas do
        local rowData = frame.datas[i]
        if rowData[ROWDATA_COLUMN_OFFSET] == frame.selectedDataKey then
          frame.selectedDataIndex = i
          frame:ScrollToDataIndex(frame.selectedDataKey, 1)
          break
        end
      end
    end
  end
  function frame:InsertRowData(key, columnCount, data)
    local rowData = {}
    for i = 1, columnCount do
      rowData[ROWDATA_COLUMN_OFFSET] = key
      rowData[i + ROWDATA_COLUMN_OFFSET] = data
    end
    self.datas[#self.datas + 1] = rowData
    self.dataCount = self.dataCount + 1
    if self.dataCount <= #self.listCtrl.items then
      self.listCtrl:InsertData(self.dataCount, 1, "")
    end
    local rowCount = #self.listCtrl.items
    self:SetMinMaxValues(0, self.dataCount - rowCount)
  end
  function frame:GetDataByViewIndex(row, col)
    local rowData = self.datas[row + self.topDataIndex - 1]
    if rowData == nil then
      return
    end
    return rowData[col + ROWDATA_COLUMN_OFFSET]
  end
  function frame:DeleteDataByIndex(index)
    if self.datas[index] == nil then
      return
    end
    if index == self.selectedDataIndex then
      self.selectedDataIndex = 0
      self.selectedDataKey = nil
    elseif index < self.selectedDataIndex then
      self.selectedDataIndex = self.selectedDataIndex - 1
    end
    table.remove(self.datas, index)
    self.dataCount = self.dataCount - 1
    if self.dataCount < #self.listCtrl.items then
      self.listCtrl:DeleteData(self.dataCount + 1)
    end
    local selectedIndex = frame:GetSelectedRowViewIndex(self.selectedDataIndex)
    if selectedIndex ~= self.listCtrl:GetSelectedIdx() then
      self.listCtrl:Select(selectedIndex - 1, false)
    end
    local rowCount = #self.listCtrl.items
    self:SetMinMaxValues(0, self.dataCount - rowCount)
    self:UpdateView()
  end
  function frame:GetSelectedDataIndex()
    return self.selectedDataIndex
  end
  function frame:GetSelectedDataKey()
    return self.selectedDataKey
  end
  function frame:SelectByDataKey(dataKey)
    for i = 1, #self.datas do
      if dataKey == self.datas[i][1] then
        local selectedIndex = frame:GetSelectedRowViewIndex(i)
        if selectedIndex ~= self.listCtrl:GetSelectedIdx() then
          self.listCtrl:Select(selectedIndex - 1)
        else
          self.selectedDataIndex = i
          self.selectedDataKey = dataKey
          if self.SelChangedProc ~= nil then
            self:SelChangedProc(self:GetSelectedRowViewIndex(self.selectedDataIndex), self.selectedDataIndex, self.selectedDataKey, false)
          end
        end
      end
    end
  end
  function frame:GetSelectedData(col)
    if self.selectedDataIndex > 0 and col > 0 and #self.listCtrl.column >= 1 then
      return self.datas[self.selectedDataIndex][col + ROWDATA_COLUMN_OFFSET]
    end
    return nil
  end
  function frame:Enable(isEnable)
    frame.scroll:Enable(isEnable)
    frame.listCtrl:Enable(isEnable)
  end
  function frame:EnbaleSort(isEnable)
    frame.useSort = isEnable
  end
  return frame
end
function ChangeSubItemTextColorForOnline(subItem, isOnline)
  if isOnline then
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  else
    ApplyTextColor(subItem, FONT_COLOR.GRAY)
  end
end
function LevelAscendingSortFunc(a, b)
  return a[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.LV] < b[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.LV] and true or false
end
function LevelDescendingSortFunc(a, b)
  return a[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.LV] > b[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.LV] and true or false
end
function NameAscendingSortFunc(a, b)
  return a[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.NAME] < b[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.NAME] and true or false
end
function NameDescendingSortFunc(a, b)
  return a[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.NAME] > b[ROWDATA_COLUMN_OFFSET + 1][SCROLLLIST_COMMON_COL.NAME] and true or false
end
