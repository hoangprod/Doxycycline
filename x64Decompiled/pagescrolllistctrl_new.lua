function W_CTRL.CreatePageScrollListCtrlNew(id, parent)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame.perPageItemCount = 0
  frame.pageIndex = 1
  local pageControl = W_CTRL.CreatePageControl(frame:GetId() .. ".pageControl", frame)
  pageControl:Show(true)
  pageControl:AddAnchor("TOP", frame.listCtrl, "BOTTOM", 0, 7)
  frame.pageControl = pageControl
  function frame:DeleteAllDatas()
    self.datas = {}
    self.dataCount = 0
    self.listCtrl:DeleteAllDatas()
    self:SetMinMaxValues(0, 0)
    pageControl:SetCurrentPage(1, false)
    self.topDataIndex = 1
    self:UpdateView()
  end
  function frame:GetSelectedRowViewIndex(selectedDataIndex)
    local rowCount = #self.listCtrl.items
    local currentPage = frame:GetCurrentPageIndex()
    local perCount = frame.pageControl:GetCountPerPage()
    return selectedDataIndex - (currentPage - 1) * perCount - self.topDataIndex + 1
  end
  function frame.listCtrl:OnSelChanged(selectedIndex, doubleClick)
    if selectedIndex == 0 then
      return
    end
    frame.selectedDataIndex = 0
    frame.selectedDataKey = nil
    local currentPage = frame:GetCurrentPageIndex()
    local perCount = frame.pageControl:GetCountPerPage()
    local temp = (currentPage - 1) * perCount + frame.topDataIndex + selectedIndex - 1
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
  frame.listCtrl:SetHandler("OnSelChanged", frame.listCtrl.OnSelChanged)
  function frame:SetPageByItemCount(maxCount, perPageItemCount)
    self.pageControl:SetPageByItemCount(maxCount, perPageItemCount)
    self.perPageItemCount = perPageItemCount
  end
  function frame:GetDataMaxCount()
    return #self.datas
  end
  function frame:GetDataByDataIndex(index, col)
    local rowData = self.datas[index]
    if rowData == nil then
      return
    end
    return rowData[col + ROWDATA_COLUMN_OFFSET]
  end
  function frame:UpdateView()
    if self.listCtrl.items == nil or self.listCtrl.column == nil then
      return
    end
    local rowCount = #self.listCtrl.items
    local colCount = #self.listCtrl.column
    local currentPage = frame:GetCurrentPageIndex()
    local perCount = frame.pageControl:GetCountPerPage()
    local startDataIndex = (currentPage - 1) * perCount + self.topDataIndex
    for i = 1, rowCount do
      local rowData = self.datas[startDataIndex]
      local row = self.listCtrl.items[i]
      if rowData ~= nil then
        for j = 1, colCount do
          local subItem = row.subItems[j]
          local curCol = self.listCtrl.column[j]
          if rowData[j + ROWDATA_COLUMN_OFFSET] ~= nil and subItem ~= nil and curCol.dataSetFunc ~= nil then
            curCol.dataSetFunc(subItem, rowData[j + ROWDATA_COLUMN_OFFSET], true)
          end
        end
      else
        for j = 1, colCount do
          local subItem = row.subItems[j]
          local curCol = self.listCtrl.column[j]
          if subItem ~= nil and curCol.dataSetFunc ~= nil then
            curCol.dataSetFunc(subItem, "", false)
          end
        end
      end
      startDataIndex = startDataIndex + 1
    end
    local pagePerRow = perCount
    local total = #self.datas
    if pagePerRow > total then
      pagePerRow = total
    elseif total < currentPage * perCount then
      pagePerRow = total - (currentPage - 1) * perCount
    end
    frame:SetMinMaxValues(0, pagePerRow - rowCount)
  end
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    frame.topDataIndex = 1
    frame:SetValue(0)
    frame:UpdateView()
  end
  function frame:GetCurrentPageIndex()
    return self.pageControl:GetCurrentPageIndex()
  end
  function frame:GetDataIndexByData(col, checkFunc)
    if col <= 0 then
      return
    end
    if checkFunc == nil or type(checkFunc) ~= "function" then
      return
    end
    for i = 1, #frame.datas do
      local rowData = frame.datas[i]
      if checkFunc(rowData[col + ROWDATA_COLUMN_OFFSET]) then
        return i
      end
    end
  end
  function frame:MoveViewByDataIndex(dataIndex)
    if dataIndex <= 0 then
      return
    end
    local perCount = frame.pageControl:GetCountPerPage()
    local page = math.floor((dataIndex - 1) / perCount) + 1
    frame.pageControl:SetCurrentPage(page)
    local scrollIndex = dataIndex - (page - 1) * perCount
    self:ScrollToDataIndex(scrollIndex, 1)
  end
  function frame:GetVisibleDatas(columnIndex)
    local currentPage = frame:GetCurrentPageIndex()
    local perCount = frame.pageControl:GetCountPerPage()
    local rowCount = #self.listCtrl.items
    local curretTopIndex = (currentPage - 1) * perCount + self.topDataIndex
    local maxCount = #frame.datas
    if curretTopIndex <= 0 and curretTopIndex > maxCount then
      return
    end
    local visibleDatas = {}
    local index = curretTopIndex
    for i = 1, rowCount do
      if frame.datas[index] ~= nil then
        local info = {}
        info.data = frame:GetData(index, columnIndex)
        info.index = index
        info.key = frame.datas[index][ROWDATA_COLUMN_OFFSET]
        table.insert(visibleDatas, info)
      end
      index = index + 1
    end
    return visibleDatas
  end
  function frame:UpdateData(key, columnIndex, newData)
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
    foundRow = self:GetSelectedRowViewIndex(foundRow)
    local row = self.listCtrl.items[foundRow]
    if row == nil then
      return
    end
    local col = self.listCtrl.column[columnIndex]
    if col == nil then
      return
    end
    local subItem = row.subItems[columnIndex]
    if col.dataSetFunc ~= nil then
      col.dataSetFunc(subItem, newData, true)
    end
  end
  return frame
end
