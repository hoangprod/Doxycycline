function CreatePageListCtrl(parent, ownId, index, pageStyle)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = parent:CreateChildWidget("emptywidget", ownId, index, true)
  frame:Show(true)
  frame.pageIndex = 1
  frame.dataCount = 0
  frame.datas = {}
  frame.lastClickColumn = nil
  frame.lastSortFunc = nil
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", frame)
  listCtrl:Show(true)
  listCtrl:AddAnchor("TOPLEFT", frame, 0, 0)
  listCtrl:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  listCtrl:SetColumnHeight(LIST_COLUMN_HEIGHT)
  listCtrl:UseSortMark()
  frame.listCtrl = listCtrl
  local pageControl = W_CTRL.CreatePageControl(frame:GetId() .. ".pageControl", frame, pageStyle)
  pageControl:Show(true)
  pageControl:AddAnchor("TOP", listCtrl, "BOTTOM", 0, 7)
  frame.pageControl = pageControl
  function frame:GetSelectedRowViewIndex(selectedDataIndex)
    local rowCount = #self.listCtrl.items
    local selectedIndex = 0
    if self.pageIndex ~= 1 then
      selectedIndex = selectedDataIndex - (self.pageIndex - 1) * rowCount
    else
      selectedIndex = selectedDataIndex
    end
    return selectedIndex
  end
  local mark_yOffset = 2
  function frame:InsertColumn(columnName, width, itemType, dataSetFunc, sortFunc1, sortFunc2, layoutFunc, useSortMark)
    self.listCtrl:InsertColumn(width, itemType)
    local columnIndex = #self.listCtrl.column
    local column = self.listCtrl.column[columnIndex]
    if useSortMark == nil then
      useSortMark = true
    end
    column.index = columnIndex
    column.dataSetFunc = dataSetFunc
    column.sortFunc1 = sortFunc1
    column.sortFunc2 = sortFunc2
    column.curSortFunc = sortFunc1
    column.layoutFunc = layoutFunc
    column.useSortMark = useSortMark
    column:SetText(columnName)
    ApplyButtonSkin(column, BUTTON_BASIC.LISTCTRL_COLUMN)
    column.sortMark_xOffset = column.style:GetTextWidth(columnName) / 2 + 8
    if self.lastClickColumn == nil then
      self.lastClickColumn = self.listCtrl.column[1]
      self.lastSortFunc = self.lastClickColumn.sortFunc1
      self.listCtrl.AscendingSortMark:SetVisible(true)
      self.listCtrl.DescendingSortMark:SetVisible(false)
      self.listCtrl.AscendingSortMark:RemoveAllAnchors()
      self.listCtrl.AscendingSortMark:AddAnchor("CENTER", self.lastClickColumn, self.lastClickColumn.sortMark_xOffset, mark_yOffset)
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc2
    end
    function column:OnClick()
      self.sortMode = "none"
      if self.curSortFunc ~= nil then
        table.sort(frame.datas, self.curSortFunc)
        frame.lastClickColumn = self
        frame.lastSortFunc = self.curSortFunc
        if self.curSortFunc == self.sortFunc1 and self.sortFunc2 ~= nil then
          self.curSortFunc = self.sortFunc2
          frame.listCtrl.AscendingSortMark:SetVisible(true)
          frame.listCtrl.DescendingSortMark:SetVisible(false)
          frame.listCtrl.AscendingSortMark:RemoveAllAnchors()
          frame.listCtrl.AscendingSortMark:AddAnchor("CENTER", frame.listCtrl.column[columnIndex], self.sortMark_xOffset, mark_yOffset)
          self.sortMode = "asc"
        elseif self.curSortFunc == column.sortFunc2 and self.sortFunc1 ~= nil then
          self.curSortFunc = self.sortFunc1
          frame.listCtrl.AscendingSortMark:SetVisible(false)
          frame.listCtrl.DescendingSortMark:SetVisible(true)
          frame.listCtrl.DescendingSortMark:RemoveAllAnchors()
          frame.listCtrl.DescendingSortMark:AddAnchor("CENTER", frame.listCtrl.column[columnIndex], self.sortMark_xOffset, mark_yOffset)
          self.sortMode = "desc"
        end
        if not self.useSortMark then
          frame.listCtrl.AscendingSortMark:SetVisible(false)
          frame.listCtrl.DescendingSortMark:SetVisible(false)
        end
      end
      frame:UpdateView()
    end
    column:SetHandler("OnClick", column.OnClick)
  end
  function frame:GetDataByViewIndex(row, col)
    local index = 0
    if #self.datas > #self.listCtrl.items then
      index = (self.pageIndex - 1) * #self.listCtrl.items
    end
    local rowData = self.datas[index + row]
    if rowData == nil then
      return
    end
    return rowData[col + ROWDATA_COLUMN_OFFSET]
  end
  function frame:UpdateData(row, col, dataIndex, data)
    local index = (self.pageIndex - 1) * #self.listCtrl.items
    local rowData = self.datas[index + row]
    rowData[col + ROWDATA_COLUMN_OFFSET][dataIndex] = data
  end
  function listCtrl:OnSelChanged(selectedIndex, doubleClick)
    frame.selectedDataIndex = 0
    frame.selectedDataKey = nil
    local temp = (frame.pageIndex - 1) * #frame.listCtrl.items + selectedIndex
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
  function frame:UpdateView()
    local rowCount = #self.listCtrl.items
    local colCount = #self.listCtrl.column
    local count, startIndex = self:GetVisibleItemCountCurrentPage()
    local rowIndex = 1
    for i = 1, count do
      local idx = startIndex + i
      local rowData = self.datas[idx]
      local row = self.listCtrl.items[rowIndex]
      if rowData ~= nil and row ~= nil then
        for j = 1, colCount do
          local subItem = row.subItems[j]
          local curCol = self.listCtrl.column[j]
          if rowData[j + ROWDATA_COLUMN_OFFSET] ~= nil and subItem ~= nil and curCol.dataSetFunc ~= nil then
            curCol.dataSetFunc(subItem, rowData[j + ROWDATA_COLUMN_OFFSET], true, curCol.sortMode)
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
            curCol.dataSetFunc(subItem, "", false, curCol.sortMode)
          end
        end
      end
    end
  end
  function frame:GetVisibleItemCountCurrentPage()
    local rowCount = #self.listCtrl.items
    local pageCount = math.floor(#self.datas / rowCount)
    local startIndex = 0
    local count = #self.datas % rowCount
    if rowCount < #self.datas then
      startIndex = (self.pageIndex - 1) * rowCount
      if pageCount >= self.pageIndex then
        count = rowCount
      end
    end
    if count == 0 then
      count = rowCount
    end
    return count, startIndex
  end
  function frame:UpdatePage(maxCount, perPageCount)
    self.pageControl:SetPageByItemCount(maxCount, perPageCount)
  end
  function frame:FirstSorting()
    if self.lastSortFunc == self.lastClickColumn.sortFunc1 then
      self.listCtrl.AscendingSortMark:SetVisible(true)
      self.listCtrl.DescendingSortMark:SetVisible(false)
      self.listCtrl.AscendingSortMark:RemoveAllAnchors()
      self.listCtrl.AscendingSortMark:AddAnchor("CENTER", self.lastClickColumn, self.lastClickColumn.sortMark_xOffset, mark_yOffset)
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc2
    elseif self.lastSortFunc == self.lastClickColumn.sortFunc2 then
      self.listCtrl.AscendingSortMark:SetVisible(false)
      self.listCtrl.DescendingSortMark:SetVisible(true)
      self.listCtrl.DescendingSortMark:RemoveAllAnchors()
      self.listCtrl.DescendingSortMark:AddAnchor("CENTER", self.lastClickColumn, self.lastClickColumn.sortMark_xOffset, mark_yOffset)
      self.lastClickColumn.curSortFunc = self.lastClickColumn.sortFunc1
    end
    if not self.lastClickColumn.useSortMark then
      self.listCtrl.AscendingSortMark:SetVisible(false)
      self.listCtrl.DescendingSortMark:SetVisible(false)
    end
    table.sort(self.datas, self.lastSortFunc)
  end
  function frame:ResetSelectColumn(column)
    self.listCtrl.AscendingSortMark:RemoveAllAnchors()
    self.listCtrl.AscendingSortMark:SetVisible(false)
    self.listCtrl.DescendingSortMark:RemoveAllAnchors()
    self.listCtrl.DescendingSortMark:SetVisible(false)
    if column == nil then
      self.lastClickColumn = nil
    else
      self.lastClickColumn = column
    end
    for i = 1, #self.listCtrl.column do
      local column = self.listCtrl.column[i]
      column.curSortFunc = column.sortFunc1
    end
  end
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    frame.pageIndex = pageIndex
    if frame.OnPageChangedProc ~= nil then
      frame:OnPageChangedProc(pageIndex)
    end
    frame:UpdateView()
  end
  return frame
end
