LISTFRAME = {
  ConvertNumber = function(formatStr, value)
    local convTable = {}
    convTable.value = value
    convTable.outValue = string.format(formatStr, value)
    return convTable
  end,
  ConvertNumberUiText = function(category, key, value)
    local convTable = {}
    convTable.value = value
    convTable.outValue = X2Locale:LocalizeUiText(category, key, tostring(value))
    return convTable
  end,
  NORMAL = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        subItem:SetText(data)
      else
        subItem:SetText("")
      end
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i]
      local bData = b[ROWDATA_COLUMN_OFFSET + i]
      return aData < bData and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i]
      local bData = b[ROWDATA_COLUMN_OFFSET + i]
      return aData > bData and true or false
    end
  },
  NORMAL_FORMATTED_NUMBER = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        subItem:SetText(data.outValue)
      else
        subItem:SetText("")
      end
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].value
      local bData = b[ROWDATA_COLUMN_OFFSET + i].value
      return tonumber(aData) < tonumber(bData) and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].value
      local bData = b[ROWDATA_COLUMN_OFFSET + i].value
      return tonumber(aData) > tonumber(bData) and true or false
    end
  },
  ITEM = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        subItem.itemButton:Show(true)
        subItem.itemButton:Init()
        subItem.itemButton:SetItemInfo(data)
        subItem:SetText(tostring(data.name))
        if data.event == true then
          subItem.eventTypeIcon:Show(true)
        else
          subItem.eventTypeIcon:Show(false)
        end
      else
        subItem.itemButton:Show(false)
        subItem:SetText("")
        subItem.eventTypeIcon:Show(false)
      end
    end,
    LayoutFunc = function(widget, rowIndex, colIndex, subItem)
      local before_width = 5
      local after_width = 8
      if widget.before_width ~= nil then
        before_width = widget.before_width
      end
      if widget.after_width ~= nil then
        after_width = widget.after_width
      end
      local itemButton = CreateItemIconButton(subItem:GetId() .. ".itemButton", subItem)
      itemButton:SetExtent(ICON_SIZE.AUCTION, ICON_SIZE.AUCTION)
      itemButton:AddAnchor("LEFT", subItem, before_width, 0)
      itemButton:Raise()
      subItem.itemButton = itemButton
      subItem:SetInset(itemButton:GetWidth() + before_width + 5, 0, after_width, 0)
      subItem:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
      subItem.style:SetAlign(ALIGN_LEFT)
      subItem.style:SetEllipsis(true)
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      subItem.eventTypeIcon = subItem:CreateDrawable(TEXTURE_PATH.EVENT_ICON, "icon_event", "overlay")
      subItem.eventTypeIcon:AddAnchor("TOPLEFT", itemButton, 0, 0)
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].name
      local bData = b[ROWDATA_COLUMN_OFFSET + i].name
      return aData < bData and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].name
      local bData = b[ROWDATA_COLUMN_OFFSET + i].name
      return aData > bData and true or false
    end
  },
  SUPPLY = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        local path = data.iconPath
        if string.sub(data.iconPath, 1, 6) == "\\Game\\" then
          path = string.sub(data.iconPath, 7, -1)
        end
        subItem.icon:SetTexture(path)
        subItem.icon:SetTextureInfo(data.iconCoord)
        subItem.icon:Show(true)
        subItem:SetText(tostring(data.label))
        subItem:SetInset(subItem.icon:GetWidth() / 2 + 7, 0, 0, 0)
        subItem.icon:RemoveAllAnchors()
        subItem.icon:AddAnchor("CENTER", subItem, -(subItem.style:GetTextWidth(tostring(data.label)) / 2 + 7), 0)
      else
        subItem.icon:Show(false)
        subItem:SetText("")
      end
    end,
    LayoutFunc = function(widget, rowIndex, colIndex, subItem)
      subItem:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
      subItem.style:SetAlign(ALIGN_CENTER)
      subItem.style:SetEllipsis(true)
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      subItem.icon = subItem:CreateImageDrawable(INVALID_ICON_PATH, "overlay")
      subItem.icon:AddAnchor("RIGHT", subItem, "LEFT", 7, 0)
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].count
      local bData = b[ROWDATA_COLUMN_OFFSET + i].count
      return aData < bData and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].count
      local bData = b[ROWDATA_COLUMN_OFFSET + i].count
      return aData > bData and true or false
    end
  },
  ICON = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        subItem.icon:Show(true)
        subItem.icon:SetIconPath("ui/icon/" .. data.icon)
        subItem.icon:SetGrade(0)
        subItem.icon:OverlayInvisible()
        subItem.icon:Enable(false)
        local function OnEnter(self)
          if data.tooltip ~= "" then
            SetTooltip(data.tooltip, self)
          end
        end
        subItem.icon:SetHandler("OnEnter", OnEnter)
        subItem:SetText(tostring(data.name))
      else
        subItem.icon:Show(false)
        subItem.icon:ReleaseHandler("OnEnter")
        subItem:SetText("")
      end
    end,
    LayoutFunc = function(widget, rowIndex, colIndex, subItem)
      local widget = CreateSlotShapeButton("icon", subItem)
      widget:SetExtent(ICON_SIZE.AUCTION, ICON_SIZE.AUCTION)
      widget:AddAnchor("LEFT", subItem, 9, 0)
      subItem.icon = widget
      subItem:SetInset(widget:GetWidth() + 15, 0, 0, 0)
      subItem:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
      subItem.style:SetAlign(ALIGN_LEFT)
      subItem.style:SetEllipsis(true)
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      subItem.name = name
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].name
      local bData = b[ROWDATA_COLUMN_OFFSET + i].name
      return aData < bData and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].name
      local bData = b[ROWDATA_COLUMN_OFFSET + i].name
      return aData > bData and true or false
    end
  },
  MONEY = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        local text = string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(data.refund))
        local textNoEvent = string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(data.noEventRefund))
        subItem.money:Show(true)
        subItem.money:SetText(text)
        subItem.moneyDash:SetText(textNoEvent)
        if tonumber(data.noEventRefund) > 0 then
          subItem.money:RemoveAllAnchors()
          subItem.moneyDash:RemoveAllAnchors()
          subItem.moneyDash:Show(true)
          subItem.money:AddAnchor("RIGHT", subItem, -subItem.before_width, 9)
          subItem.moneyDash:AddAnchor("RIGHT", subItem, -subItem.before_width, -9)
        else
          subItem.money:RemoveAllAnchors()
          subItem.moneyDash:Show(false)
          subItem.money:AddAnchor("RIGHT", subItem, -subItem.before_width, 0)
        end
        if data.tooltip ~= nil then
          local function OnEnter(self)
            if data.tooltip ~= "" then
              SetTooltip(data.tooltip, self)
            end
          end
          subItem:SetHandler("OnEnter", OnEnter)
          local OnLeave = function(self)
            HideTooltip()
          end
          subItem:SetHandler("OnLeave", OnLeave)
        else
          subItem:ReleaseHandler("OnLeave")
          subItem:ReleaseHandler("OnEnter")
        end
      else
        subItem.money:Show(false)
        subItem.moneyDash:Show(false)
      end
    end,
    LayoutFunc = function(widget, rowIndex, colIndex, subItem)
      local before_width = 5
      if widget.before_width ~= nil then
        before_width = widget.before_width
      end
      local width, height = subItem:GetExtent()
      local money = subItem:CreateChildWidget("textbox", "money", 0, true)
      money:SetExtent(width - before_width, height / 2)
      money:AddAnchor("RIGHT", subItem, -before_width, 0)
      money.style:SetAlign(ALIGN_RIGHT)
      ApplyTextColor(money, FONT_COLOR.DEFAULT)
      subItem.money = money
      local moneyDash = subItem:CreateChildWidget("textbox", "moneyDash", 0, true)
      moneyDash:SetExtent(width - before_width, height / 2)
      moneyDash:AddAnchor("RIGHT", subItem, -before_width, 0)
      moneyDash.style:SetAlign(ALIGN_RIGHT)
      moneyDash:SetStrikeThrough(true)
      moneyDash:SetLineColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], FONT_COLOR.DEFAULT[4])
      ApplyTextColor(moneyDash, FONT_COLOR.DEFAULT)
      subItem.moneyDash = moneyDash
      subItem.before_width = before_width
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].refund
      local bData = b[ROWDATA_COLUMN_OFFSET + i].refund
      local comp = F_CALC.CompNum(aData, bData)
      return comp < 0 and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].refund
      local bData = b[ROWDATA_COLUMN_OFFSET + i].refund
      local comp = F_CALC.CompNum(aData, bData)
      return comp > 0 and true or false
    end
  },
  MONEY_WITH_BUY_ICON = {
    DataFunc = function(subItem, data, setValue)
      if setValue then
        local text = string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(data.refund))
        local textNoEvent = string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(data.noEventRefund))
        subItem.buyButton:Show(true)
        if data.amount < 0 then
          subItem.buyButton:Enable(false)
        else
          subItem.buyButton:Enable(true)
          function subItem.buyButton:OnClick()
            SetBuyTradegoodConfirmInfo(data.itemType, data.refund)
          end
          subItem.buyButton:SetHandler("OnClick", subItem.buyButton.OnClick)
        end
        subItem.money:Show(true)
        subItem.money:SetText(text)
        subItem.moneyDash:SetText(textNoEvent)
        if 0 < tonumber(data.noEventRefund) then
          subItem.money:RemoveAllAnchors()
          subItem.moneyDash:RemoveAllAnchors()
          subItem.moneyDash:Show(true)
          local _, height = subItem.money:GetExtent()
          subItem.money:AddAnchor("RIGHT", subItem.buyButton, "LEFT", -3, 9)
          subItem.moneyDash:AddAnchor("RIGHT", subItem.buyButton, "LEFT", -3, -9)
        else
          subItem.money:RemoveAllAnchors()
          subItem.moneyDash:Show(false)
          subItem.money:AddAnchor("RIGHT", subItem.buyButton, "LEFT", -3, 0)
        end
        if data.tooltip ~= nil then
          local function OnEnter(self)
            if data.tooltip ~= "" then
              SetTooltip(data.tooltip, self)
            end
          end
          subItem:SetHandler("OnEnter", OnEnter)
          local OnLeave = function(self)
            HideTooltip()
          end
          subItem:SetHandler("OnLeave", OnLeave)
        else
          subItem:ReleaseHandler("OnLeave")
          subItem:ReleaseHandler("OnEnter")
        end
      else
        subItem.buyButton:Show(false)
        subItem.money:Show(false)
        subItem.moneyDash:Show(false)
      end
    end,
    LayoutFunc = function(widget, rowIndex, colIndex, subItem)
      local buyButton = subItem:CreateChildWidget("button", "buyButton", 0, true)
      ApplyButtonSkin(buyButton, BUTTON_BASIC.SPECIALTY_BUY)
      buyButton:AddAnchor("RIGHT", subItem, -7, 0)
      buyButton:Raise()
      subItem.buyButton = buyButton
      local _, height = subItem:GetExtent()
      local money = subItem:CreateChildWidget("textbox", "money", 0, true)
      money:SetExtent(132, height / 2)
      money:AddAnchor("RIGHT", buyButton, "LEFT", -3, 0)
      money.style:SetAlign(ALIGN_RIGHT)
      ApplyTextColor(money, FONT_COLOR.DEFAULT)
      subItem.money = money
      local moneyDash = subItem:CreateChildWidget("textbox", "moneyDash", 0, true)
      moneyDash:SetExtent(132, height / 2)
      moneyDash:AddAnchor("RIGHT", buyButton, "LEFT", -3, 0)
      moneyDash.style:SetAlign(ALIGN_RIGHT)
      moneyDash:SetStrikeThrough(true)
      moneyDash:SetLineColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], FONT_COLOR.DEFAULT[4])
      ApplyTextColor(moneyDash, FONT_COLOR.DEFAULT)
      moneyDash:Show(false)
      subItem.moneyDash = moneyDash
    end,
    AscSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].refund
      local bData = b[ROWDATA_COLUMN_OFFSET + i].refund
      local comp = F_CALC.CompNum(aData, bData)
      return comp < 0 and true or false
    end,
    DescSortFunc = function(i, a, b)
      local aData = a[ROWDATA_COLUMN_OFFSET + i].refund
      local bData = b[ROWDATA_COLUMN_OFFSET + i].refund
      local comp = F_CALC.CompNum(aData, bData)
      return comp > 0 and true or false
    end
  }
}
function CreateListFrame(id, parent, listInfos)
  if listInfos.page == nil then
    listInfos.page = true
  end
  local widget
  if listInfos.page == true then
    widget = CreatePageListCtrl(parent, id, 0)
  else
    widget = parent:CreateChildWidget("emptywidget", id, 0, true)
    W_CTRL.CreateListCtrl("listCtrl", widget)
  end
  widget:Show(true)
  widget:SetExtent(listInfos.width, listInfos.height)
  local columnHeight = LIST_COLUMN_HEIGHT
  if listInfos.columnHeight ~= nil then
    columnHeight = listInfos.columnHeight
  end
  if widget.listCtrl.AscendingSortMark ~= nil then
    widget.listCtrl.AscendingSortMark:SetColor(1, 1, 1, 0.5)
  end
  if widget.listCtrl.DescendingSortMark ~= nil then
    widget.listCtrl.DescendingSortMark:SetColor(1, 1, 1, 0.5)
  end
  widget.listCtrl:SetColumnHeight(columnHeight)
  for i = 1, #listInfos.columns do
    do
      local col = listInfos.columns[i]
      widget.before_width = col.before_width
      widget.after_width = col.after_width
      if listInfos.page == true then
        if col.useSort == nil or col.useSort == false then
          widget:InsertColumn(col.name, col.width, col.colType, col.func.DataFunc, nil, nil, col.func.LayoutFunc)
        else
          local function AscSortFunc(a, b)
            return col.func.AscSortFunc(i, a, b)
          end
          local function DescSortFunc(a, b)
            return col.func.DescSortFunc(i, a, b)
          end
          widget:InsertColumn(col.name, col.width, col.colType, col.func.DataFunc, AscSortFunc, DescSortFunc, col.func.LayoutFunc, col.useSort)
        end
      else
        widget:InsertColumn(col.name, col.width, col.colType, col.func.LayoutFunc, col.func.DataFunc)
      end
    end
  end
  widget:InsertRows(listInfos.rows, false)
  for i = 1, #widget.listCtrl.column do
    local col = listInfos.columns[i]
    SettingListColumn(widget.listCtrl, widget.listCtrl.column[i], columnHeight)
    DrawListCtrlColumnSperatorLine(widget.listCtrl.column[i], #widget.listCtrl.column, i)
    if col.useSort == nil or col.useSort == false then
      widget.listCtrl.column[i]:Enable(false)
    end
  end
  DrawListCtrlUnderLine(widget.listCtrl, columnHeight - 2)
  ListCtrlItemGuideLine(widget.listCtrl.items, listInfos.rows)
  if listInfos.page == true then
    function widget:OnPageChangedProc(pageIndex)
      local viewCount = self:GetVisibleItemCountCurrentPage()
      for i = 1, viewCount do
        local item = widget.listCtrl.items[i]
        if item.line ~= nil then
          item.line:SetVisible(true)
        end
      end
      for i = viewCount + 1, self:GetRowCount() do
        local item = widget.listCtrl.items[i]
        if item.line ~= nil then
          item.line:SetVisible(false)
        end
      end
    end
  end
  return widget
end
