function CreateAttrListWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(430, 500)
  window:SetTitle(GetUIText(COMMON_TEXT, "enabled_item_evolving_attrs"))
  local commonWidth = window:GetWidth() - MARGIN.WINDOW_SIDE * 2.5
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:SetExtent(commonWidth, FONT_SIZE.LARGE)
  title:SetText(GetUIText(COMMON_TEXT, "item_evolving_result_attrs"))
  title:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  local grade = window:CreateChildWidget("textbox", "grade", 0, true)
  grade:SetExtent(commonWidth, FONT_SIZE.LARGE)
  grade:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE)
  grade.style:SetFontSize(FONT_SIZE.LARGE)
  local line = CreateLine(grade, "TYPE1")
  line:AddAnchor("TOPLEFT", grade, "BOTTOMLEFT", 0, 8)
  line:AddAnchor("TOPRIGHT", grade, "BOTTOMRIGHT", 0, 8)
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", window)
  scrollListCtrl:SetExtent(commonWidth, 250)
  scrollListCtrl:AddAnchor("TOPLEFT", grade, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 1.8)
  scrollListCtrl:HideColumnButtons()
  scrollListCtrl.scroll:RemoveAllAnchors()
  scrollListCtrl.scroll:AddAnchor("TOPRIGHT", scrollListCtrl, 0, 5)
  scrollListCtrl.scroll:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 0, 0)
  window.scrollListCtrl = scrollListCtrl
  local GROUP_TYPE = {
    GROUP_INFO = 1,
    GROUP_NOT_HAS = 2,
    GROUP_HAS = 3
  }
  local bgColor = {
    {
      ConvertColor(81),
      ConvertColor(215),
      ConvertColor(132),
      0.2
    },
    {
      ConvertColor(81),
      ConvertColor(151),
      ConvertColor(215),
      0.2
    },
    {
      ConvertColor(215),
      ConvertColor(81),
      ConvertColor(211),
      0.2
    },
    {
      ConvertColor(215),
      ConvertColor(140),
      ConvertColor(81),
      0.2
    },
    {
      ConvertColor(215),
      ConvertColor(81),
      ConvertColor(117),
      0.2
    }
  }
  local textColor = {
    "|cFF51D784",
    "|cFF5197D7",
    "|cFFD751D3",
    "|cFFD78C51",
    "|cFFD75175"
  }
  local function DataFuncFirstCol(subItem, data, setValue)
    if setValue then
      subItem:Show(true)
      subItem.bg:Show(true)
      subItem.dingbat:Show(true)
      if data.type == GROUP_TYPE.GROUP_INFO then
        ApplyTextureColor(subItem.bg, bgColor[data.group])
        subItem:SetText(data.name)
        subItem.dingbat:Show(false)
      elseif data.type == GROUP_TYPE.GROUP_NOT_HAS then
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
        subItem:SetText(locale.attribute(data.name))
        ApplyTextureColor(subItem.bg, bgColor[data.group])
      elseif data.type == GROUP_TYPE.GROUP_HAS then
        ApplyTextColor(subItem, FONT_COLOR.EVOLVING_GRAY)
        subItem:SetText(locale.attribute(data.name))
        subItem.bg:Show(false)
      else
        subItem:Show(false)
        subItem.dingbat:Show(false)
      end
    else
      subItem:Show(false)
      subItem.dingbat:Show(false)
    end
  end
  local LayoutFuncFirstCol = function(widget, rowIndex, colIndex, subItem)
    subItem.bg = CreateContentBackground(subItem, "TYPE11", "brown")
    subItem.bg:SetWidth(widget.listCtrl:GetWidth())
    subItem.bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    subItem.bg:AddAnchor("BOTTOM", subItem, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem:SetInset(MARGIN.WINDOW_SIDE, 0, 0, 0)
    subItem.dingbat = W_ICON.DrawRoundDingbat(subItem)
    subItem.dingbat:RemoveAllAnchors()
    subItem.dingbat:AddAnchor("LEFT", subItem, 5, 0)
  end
  local function DataFuncSecondCol(subItem, data, setValue)
    if setValue then
      local str = ""
      if data.type ~= GROUP_TYPE.GROUP_INFO then
        str = string.format("%s~%s", GetModifierCalcValue(data.name, data.min), GetModifierCalcValue(data.name, data.max))
      end
      subItem:SetText(str)
      local color = FONT_COLOR.GREEN
      if data.type == GROUP_TYPE.GROUP_HAS then
        color = FONT_COLOR.EVOLVING_GRAY
      end
      ApplyTextColor(subItem, color)
    else
      subItem:Show(false)
    end
  end
  local LayoutFuncSecondCol = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_RIGHT)
  end
  scrollListCtrl:InsertColumn("", scrollListCtrl.listCtrl:GetWidth() * 0.75, LCCIT_TEXTBOX, DataFuncFirstCol, nil, nil, LayoutFuncFirstCol)
  scrollListCtrl:InsertColumn("", scrollListCtrl.listCtrl:GetWidth() * 0.25, LCCIT_STRING, DataFuncSecondCol, nil, nil, LayoutFuncSecondCol)
  scrollListCtrl:InsertRows(7, false)
  for i = 1, scrollListCtrl:GetRowCount() do
    ListCtrlItemGuideLine(scrollListCtrl.listCtrl.items, scrollListCtrl:GetRowCount())
  end
  local bg = CreateContentBackground(window, "TYPE2", "brown", "artwork")
  bg:AddAnchor("TOPLEFT", grade, -MARGIN.WINDOW_SIDE / 2, -MARGIN.WINDOW_SIDE / 1.5)
  bg:AddAnchor("BOTTOMRIGHT", scrollListCtrl, MARGIN.WINDOW_SIDE / 2, MARGIN.WINDOW_SIDE / 1.5)
  local tip = window:CreateChildWidget("textbox", "tip", 0, false)
  tip:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  tip:SetText(GetUIText(COMMON_TEXT, "attr_change_tip"))
  tip:AddAnchor("TOPLEFT", scrollListCtrl, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE * 1.3)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  tip:SetHeight(tip:GetTextHeight())
  local function GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, tip)
    return height + MARGIN.WINDOW_SIDE
  end
  function window:UpdateAttrList(isEvolvingMode, selAttrIndex)
    local scrollListCtrl = self.scrollListCtrl
    scrollListCtrl:DeleteAllDatas()
    local gradeStr = GetTargetItemGradeStr(isEvolvingMode)
    if gradeStr == nil then
      return
    end
    self.grade:SetText(gradeStr)
    self.grade:SetHeight(self.grade:GetTextHeight())
    local info = X2ItemEnchant:GetEvolvingRndAttrsInfo(selAttrIndex)
    if info == nil then
      return
    end
    local rowCount = scrollListCtrl:GetRowCount()
    for i = 1, rowCount do
      if scrollListCtrl.listCtrl.items[i].line ~= nil then
        scrollListCtrl.listCtrl.items[i].line:SetVisible(false)
        scrollListCtrl.listCtrl.items[i].line:SetColor(1, 1, 1, 0.5)
      end
    end
    local count = 0
    for groupNum, groupSet in pairs(info) do
      local firstCol = {
        name = string.format("%s%s %s%s", textColor[groupSet.name], X2Locale:LocalizeUiText(COMMON_TEXT, "item_rnd_attr_group_title", tostring(groupSet.name)), FONT_COLOR_HEX.GRAY, X2Locale:LocalizeUiText(COMMON_TEXT, "item_rnd_attr_group_rand", tostring(groupSet.max), tostring(groupSet.min))),
        group = groupSet.name,
        type = GROUP_TYPE.GROUP_INFO
      }
      local secondCol = {
        name = groupSet.name,
        min = math.abs(groupSet.min),
        max = math.abs(groupSet.max),
        type = GROUP_TYPE.GROUP_INFO
      }
      count = count + 1
      self.scrollListCtrl:InsertData(count, 1, firstCol)
      self.scrollListCtrl:InsertData(count, 2, secondCol)
      for notHasNum, notHas in pairs(groupSet.notHasMod) do
        local firstNotHasCol = {
          name = notHas.name,
          group = groupSet.name,
          type = GROUP_TYPE.GROUP_NOT_HAS
        }
        local secondNotHasCol = {
          name = notHas.name,
          min = math.abs(notHas.min),
          max = math.abs(notHas.max),
          type = GROUP_TYPE.GROUP_NOT_HAS
        }
        count = count + 1
        self.scrollListCtrl:InsertData(count, 1, firstNotHasCol)
        self.scrollListCtrl:InsertData(count, 2, secondNotHasCol)
      end
      for hasNum, has in pairs(groupSet.hasMod) do
        local firstHasCol = {
          name = has.name,
          group = groupSet.name,
          type = GROUP_TYPE.GROUP_HAS
        }
        local secondHasCol = {
          name = has.name,
          min = math.abs(has.min),
          max = math.abs(has.max),
          type = GROUP_TYPE.GROUP_HAS
        }
        count = count + 1
        self.scrollListCtrl:InsertData(count, 1, firstHasCol)
        self.scrollListCtrl:InsertData(count, 2, secondHasCol)
      end
    end
    local visibleCount = rowCount <= count and rowCount or count
    for i = 1, visibleCount - 1 do
      if scrollListCtrl.listCtrl.items[i].line ~= nil then
        scrollListCtrl.listCtrl.items[i].line:SetVisible(true)
      end
    end
  end
  window:SetHeight(GetContentHeight())
  return window
end
