function W_CTRL.CreatePageScrollListCtrl(id, parent)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame.perPageItemCount = 0
  frame.pageIndex = 1
  local pageControl = W_CTRL.CreatePageControl(frame:GetId() .. ".pageControl", frame)
  pageControl:Show(true)
  pageControl:AddAnchor("TOP", frame.listCtrl, "BOTTOM", 0, 7)
  frame.pageControl = pageControl
  function frame:Init()
    frame:SetMinMaxValues(0, #self.datas - #frame.listCtrl.items)
  end
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
    if #self.datas ~= self.perPageItemCount then
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
  end
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    frame.pageIndex = pageIndex
    if frame.OnPageChangedProc ~= nil then
      frame:OnPageChangedProc(pageIndex)
    end
    frame:Init()
    frame:UpdateView()
  end
  function frame:GetCurrentPageIndex()
    return self.pageControl:GetCurrentPageIndex()
  end
  return frame
end
