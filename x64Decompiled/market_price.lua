local CreateMarketPriceWindow = function(id, parent)
  local GetMoneyString = function(money)
    if type(money) == "number" then
      money = X2Util:NumberToString(money)
    end
    return string.format(F_MONEY.currency.pipeString[F_MONEY.currency.auctionBid], money)
  end
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local MAX_COUNT = {PRICE = 6, TRADING_VOLUME = 4}
  local function CreateChart(id, parent)
    local widget = parent:CreateChildWidget("emptywidget", id, 0, false)
    local gridCount = 0
    widget.grid = {}
    function widget:InsertGrid(col, row)
      if gridCount ~= 0 then
        return
      end
      local wndWidth, wndHeight = self:GetExtent()
      if wndWidth <= 0 or wndHeight <= 0 then
        return
      end
      widget.row = row
      widget.col = col
      local gridWidth = wndWidth / col
      local gridHeight = wndHeight / row
      for i = 1, row do
        widget.grid[i] = {}
        for j = 1, col do
          do
            local grid = widget:CreateChildWidget("emptywidget", string.format("grid[%d][%d]", i, j), 0, false)
            grid:Show(true)
            grid:SetExtent(gridWidth, gridHeight)
            grid:AddAnchor("TOPLEFT", self, gridWidth * (j - 1), gridHeight * (i - 1))
            local function OnEnter()
              if widget.colOverImg ~= nil and widget.colOverImg[j] ~= nil then
                widget.colOverImg[j]:SetVisible(true)
              end
              if widget.ProcOnEnterVerticalGrid ~= nil then
                widget:ProcOnEnterVerticalGrid(j)
              end
            end
            grid:SetHandler("OnEnter", OnEnter)
            local function OnLeave()
              if widget.colOverImg ~= nil and widget.colOverImg[j] ~= nil then
                widget.colOverImg[j]:SetVisible(false)
              end
              if widget.ProcOnLeaveVerticalGrid ~= nil then
                widget:ProcOnLeaveVerticalGrid(j)
              end
            end
            grid:SetHandler("OnLeave", OnLeave)
            widget.grid[i][j] = grid
          end
        end
      end
      widget.colOverImg = {}
      for i = 1, col do
        local colOverImg = widget:CreateColorDrawable(ConvertColor(239), ConvertColor(229), ConvertColor(194), 1, "artwork")
        colOverImg:SetVisible(false)
        colOverImg:AddAnchor("TOPLEFT", widget.grid[1][i], 0, 0)
        colOverImg:AddAnchor("BOTTOMRIGHT", widget.grid[row][i], 0, 0)
        widget.colOverImg[i] = colOverImg
      end
      function widget:GetColOverImgs(idx)
        return widget.colColorImg
      end
      widget.line = {}
      widget.line.row = {}
      widget.line.col = {}
      for k = 1, row + 1 do
        local rLine = widget:CreateColorDrawable(ConvertColor(188), ConvertColor(171), ConvertColor(138), 1, "artwork")
        rLine:SetExtent(wndWidth, 1)
        rLine:AddAnchor("TOPLEFT", self, 0, gridHeight * (k - 1))
        widget.line.row[k] = rLine
        for l = 1, col + 1 do
          local cLine = widget:CreateColorDrawable(ConvertColor(188), ConvertColor(171), ConvertColor(138), 1, "artwork")
          cLine:SetExtent(1, wndHeight)
          cLine:AddAnchor("TOPLEFT", self, gridWidth * (l - 1), 0)
          widget.line.col[k] = cLine
        end
      end
    end
    widget.colColorImg = {}
    function widget:FillColorInColumn(colIdx, color)
      local img = self.colColorImg[colIdx]
      if img == nil then
        img = self:CreateColorDrawable(color[1], color[2], color[3], color[4], "background")
        img:AddAnchor("TOPLEFT", self.grid[1][colIdx], 1, 0)
        img:AddAnchor("BOTTOMRIGHT", self.grid[self.row][colIdx], 0, 0)
        self.colColorImg[colIdx] = img
      end
      ApplyTextureColor(img, color)
    end
    function widget:InsertValueItem(itemType, viewType, width, height)
      if viewType == nil then
        viewType = "vertical"
      end
      if itemType == nil then
        itemType = "label"
      end
      if height == nil then
        height = FONT_SIZE.MIDDLE
      end
      if viewType == "vertical" then
        self.verticalValue = {}
        local count = self.row + 1
        for i = 1, count do
          local item = self:CreateChildWidget(itemType, "verticalValue", i, true)
          item:SetExtent(width, height)
          if i == 1 then
            item:AddAnchor("TOPLEFT", self.line.row[i], "TOPRIGHT", sideMargin / 2, -1)
          elseif i == count then
            item:AddAnchor("BOTTOMLEFT", self.line.row[i], "BOTTOMRIGHT", sideMargin / 2, 1)
          else
            local inset = i <= count / 2 and 1 or -1
            item:AddAnchor("LEFT", self.line.row[i], "RIGHT", sideMargin / 2, inset)
          end
        end
      elseif viewType == "horizontal" then
        self.horizontalValue = {}
        for i = 1, self.col do
          local item = self:CreateChildWidget(itemType, "horizontalValue", i, true)
          item:SetExtent(width, height)
          item:AddAnchor("TOP", self.grid[self.row][i], "BOTTOM", 0, 5)
        end
      end
    end
    function widget:GetValueItems(viewType)
      if viewType == "vertical" then
        return self.verticalValue
      elseif viewType == "horizontal" then
        return self.horizontalValue
      end
    end
    function widget:GetGrid(col, row)
      return self.grid[row][col]
    end
    function widget:GetGridExtent()
      if #widget.grid == 0 then
        return 0, 0
      end
      return widget.grid[1][1]:GetExtent()
    end
    function widget:LayoutValueItem(viewType, layoutFunc)
      if viewType == "vertical" then
        for i = 1, #self.verticalValue do
          layoutFunc(self.verticalValue[i])
        end
      elseif viewType == "horizontal" then
        for i = 1, #self.horizontalValue do
          layoutFunc(self.horizontalValue[i])
        end
      end
    end
    return widget
  end
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:ApplyUIScale(false)
  window:SetExtent(680, 605)
  window:SetTitle(GetUIText(COMMON_TEXT, "market_price"))
  local contentWidth = window:GetWidth() - sideMargin * 2
  local itemName = window:CreateChildWidget("label", "itemName", 0, true)
  itemName:SetExtent(contentWidth, FONT_SIZE.LARGE)
  itemName:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  itemName.style:SetAlign(ALIGN_LEFT)
  local bgWidth = window:GetWidth() - sideMargin * 1.5
  local averageBg = CreateContentBackground(window, "TYPE2", "brown", "artwork")
  averageBg:SetExtent(bgWidth, 325)
  averageBg:AddAnchor("TOPLEFT", itemName, "BOTTOMLEFT", -5, sideMargin / 3)
  local marketPriceValue = {}
  local chartValue = {
    dailyAverage = {},
    weeklyAverage = {},
    volumes = {},
    minPrice = {},
    maxPrice = {}
  }
  local MAX_COUNT = {
    COLUMN = 14,
    AVERAGE_ROW = 5,
    VOLUME_ROW = 3
  }
  local chartWidth = 476
  local averageChart = CreateChart("averageChart", window)
  averageChart:SetExtent(chartWidth, 250)
  averageChart:AddAnchor("TOPLEFT", averageBg, sideMargin, sideMargin * 1.7)
  averageChart:InsertGrid(MAX_COUNT.COLUMN, MAX_COUNT.AVERAGE_ROW)
  averageChart:InsertValueItem("textbox", "vertical", 130, FONT_SIZE.MIDDLE)
  averageChart:FillColorInColumn(MAX_COUNT.COLUMN, {
    ConvertColor(221),
    ConvertColor(228),
    ConvertColor(216),
    1
  })
  local LayoutFunc = function(widget)
    widget.style:SetAlign(ALIGN_RIGHT)
    ApplyTextColor(widget, FONT_COLOR.DEFAULT)
  end
  averageChart:LayoutValueItem("vertical", LayoutFunc)
  local COLOR = {
    DAILY = {
      ConvertColor(41),
      ConvertColor(190),
      ConvertColor(150),
      1
    },
    WEEKLY = {
      ConvertColor(226),
      ConvertColor(130),
      ConvertColor(27),
      1
    },
    VOLUME = {
      ConvertColor(105),
      ConvertColor(110),
      ConvertColor(165),
      1
    }
  }
  local THICKNESS = {
    DAILY = 3,
    WEEKLY = 4,
    VOLUME = 19
  }
  local weeklyLine = averageChart:CreateChildWidget("line", "weeklyLine", 0, true)
  weeklyLine:SetLineColor(COLOR.WEEKLY[1], COLOR.WEEKLY[2], COLOR.WEEKLY[3], COLOR.WEEKLY[4])
  weeklyLine:SetLineThickness(THICKNESS.WEEKLY)
  weeklyLine:AddAnchor("TOPLEFT", averageChart, 0, 0)
  weeklyLine:AddAnchor("BOTTOMRIGHT", averageChart, 0, 0)
  local dailyLine = averageChart:CreateChildWidget("line", "dailyLine", 0, true)
  dailyLine:SetLineColor(COLOR.DAILY[1], COLOR.DAILY[2], COLOR.DAILY[3], COLOR.DAILY[4])
  dailyLine:SetLineThickness(THICKNESS.DAILY)
  dailyLine:AddAnchor("TOPLEFT", averageChart, 0, 0)
  dailyLine:AddAnchor("BOTTOMRIGHT", averageChart, 0, 0)
  local periods = X2Auction:GetMarkerPricePeriod()
  local viewPeriods = {}
  for i = #periods, 1, -1 do
    if i == #periods or i == 8 or i == 1 then
      table.insert(viewPeriods, periods[i])
    end
  end
  local anchorTarget = {
    averageChart:GetGrid(1, 1),
    averageChart:GetGrid(MAX_COUNT.COLUMN / 2, 1),
    averageChart:GetGrid(MAX_COUNT.COLUMN, 1)
  }
  for i = 1, #viewPeriods do
    local day = averageChart:CreateChildWidget("label", "day", i, true)
    day:SetAutoResize(true)
    day:SetHeight(FONT_SIZE.MIDDLE)
    day:AddAnchor("BOTTOM", anchorTarget[i], "TOP", 0, -5)
    local str = string.format("%d.%d", viewPeriods[i].month, viewPeriods[i].day)
    day:SetText(str)
    if i == #viewPeriods then
      ApplyTextColor(day, FONT_COLOR.BLUE)
    else
      ApplyTextColor(day, FONT_COLOR.DEFAULT)
    end
  end
  local volumeBg = CreateContentBackground(window, "TYPE10", "brown", "artwork")
  volumeBg:SetExtent(bgWidth, 150)
  volumeBg:AddAnchor("TOPLEFT", averageBg, "BOTTOMLEFT", 0, sideMargin / 2.5)
  local volumeChart = CreateChart("volumeChart", window)
  volumeChart:SetExtent(chartWidth, 90)
  volumeChart:AddAnchor("TOPLEFT", volumeBg, sideMargin, sideMargin)
  volumeChart:InsertGrid(MAX_COUNT.COLUMN, MAX_COUNT.VOLUME_ROW)
  volumeChart:InsertValueItem("label", "vertical", 130, FONT_SIZE.MIDDLE)
  local gridWidth, _ = volumeChart:GetGridExtent()
  volumeChart:InsertValueItem("label", "horizontal", gridWidth, FONT_SIZE.MIDDLE)
  volumeChart:FillColorInColumn(MAX_COUNT.COLUMN, {
    ConvertColor(221),
    ConvertColor(228),
    ConvertColor(216),
    1
  })
  local VerticalLayoutFunc = function(widget)
    widget.style:SetAlign(ALIGN_RIGHT)
    widget:SetNumberOnly(true)
    ApplyTextColor(widget, FONT_COLOR.DEFAULT)
  end
  volumeChart:LayoutValueItem("vertical", VerticalLayoutFunc)
  local HorizontalLayoutFunc = function(widget)
    widget.style:SetAlign(ALIGN_CENTER)
    widget:Show(false)
    widget:SetNumberOnly(true)
    ApplyTextColor(widget, FONT_COLOR.DEFAULT)
  end
  volumeChart:LayoutValueItem("horizontal", HorizontalLayoutFunc)
  function volumeChart:ProcOnEnterVerticalGrid(verticalIdx)
    if chartValue == nil or chartValue.volumes == nil or chartValue.volumes[verticalIdx] == nil then
      return
    end
    local items = self:GetValueItems("horizontal")
    local item = items[verticalIdx]
    if item == nil then
      return
    end
    item:Show(true)
    item:SetText(tostring(chartValue.volumes[verticalIdx]))
    local overImg = averageChart.colOverImg[verticalIdx]
    if overImg ~= nil and not overImg:IsVisible() then
      overImg:SetVisible(true)
      averageChart:ProcOnEnterVerticalGrid(verticalIdx)
    end
  end
  function volumeChart:ProcOnLeaveVerticalGrid(verticalIdx)
    local items = self:GetValueItems("horizontal")
    local item = items[verticalIdx]
    if item == nil then
      return
    end
    item:Show(false)
    local overImg = averageChart.colOverImg[verticalIdx]
    if overImg ~= nil and overImg:IsVisible() then
      overImg:SetVisible(false)
      averageChart:ProcOnLeaveVerticalGrid(verticalIdx)
    end
  end
  function averageChart:ProcOnEnterVerticalGrid(verticalIdx)
    if chartValue == nil then
      return
    end
    local str = ""
    local period = periods[#periods - verticalIdx + 1]
    if period ~= nil then
      str = string.format("%d. %d. %d", period.year, period.month, period.day)
    end
    local weeklyAverage = chartValue.weeklyAverage[verticalIdx]
    if weeklyAverage ~= nil then
      str = F_TEXT.SetEnterString(str, F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "weekly_trading_average_price"), GetMoneyString(weeklyAverage)))
    end
    local dailyAverage = chartValue.dailyAverage[verticalIdx]
    if dailyAverage ~= nil then
      str = F_TEXT.SetEnterString(str, F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "daily_trading_average_price"), GetMoneyString(dailyAverage)))
    end
    local maxPrice = chartValue.maxPrice[verticalIdx]
    if maxPrice ~= nil then
      str = F_TEXT.SetEnterString(str, F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "daily_trading_max_price"), GetMoneyString(maxPrice)), 2)
    end
    local minPrice = chartValue.minPrice[verticalIdx]
    if minPrice ~= nil then
      str = F_TEXT.SetEnterString(str, F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "daily_trading_min_price"), GetMoneyString(minPrice)))
    end
    SetTargetAnchorTooltip(str, "TOPLEFT", volumeChart:GetGrid(verticalIdx, MAX_COUNT.VOLUME_ROW), "BOTTOMLEFT", 0, 25)
    local overImg = volumeChart.colOverImg[verticalIdx]
    if overImg ~= nil and not overImg:IsVisible() then
      overImg:SetVisible(true)
      volumeChart:ProcOnEnterVerticalGrid(verticalIdx)
    end
  end
  function averageChart:ProcOnLeaveVerticalGrid(verticalIdx)
    local overImg = volumeChart.colOverImg[verticalIdx]
    HideTooltip()
    if overImg ~= nil and overImg:IsVisible() then
      overImg:SetVisible(false)
      volumeChart:ProcOnLeaveVerticalGrid(verticalIdx)
    end
  end
  local volumeLine = volumeChart:CreateChildWidget("line", "volumeLine", 0, true)
  volumeLine:SetLineColor(COLOR.VOLUME[1], COLOR.VOLUME[2], COLOR.VOLUME[3], COLOR.VOLUME[4])
  volumeLine:SetLineThickness(THICKNESS.VOLUME)
  volumeLine:AddAnchor("TOPLEFT", volumeChart, 0, 0)
  volumeLine:AddAnchor("BOTTOMRIGHT", volumeChart, 0, 0)
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
  okButton:AddAnchor("BOTTOMRIGHT", window, -sideMargin, -sideMargin)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local tip = window:CreateChildWidget("label", "tip", 0, false)
  tip:SetExtent(window:GetWidth() - MARGIN.WINDOW_SIDE * 2.5 - okButton:GetWidth(), FONT_SIZE.MIDDLE)
  tip:SetText(GetUIText(COMMON_TEXT, "market_price_update_tip"))
  tip:AddAnchor("BOTTOMLEFT", window, MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  tip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  local function OkButtonLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  local function CreateExample(id, text, color, thickness)
    local example = window:CreateChildWidget("emptywidget", id, 0, false)
    local drawable = example:CreateColorDrawable(1, 1, 1, 1, "background")
    drawable:SetExtent(FONT_SIZE.MIDDLE, thickness)
    drawable:AddAnchor("LEFT", example, 0, 0)
    ApplyTextureColor(drawable, color)
    local label = example:CreateChildWidget("label", "label", 0, false)
    label:SetAutoResize(true)
    label:SetHeight(FONT_SIZE.MIDDLE)
    label:AddAnchor("LEFT", drawable, "RIGHT", 5, 0)
    label:SetText(text)
    ApplyTextColor(label, FONT_COLOR.DEFAULT)
    example:SetExtent(drawable:GetWidth() + label:GetWidth() + 5, FONT_SIZE.MIDDLE)
    return example
  end
  local exampleTable = {
    {
      id = "weeklyAveragePrice",
      text = GetUIText(COMMON_TEXT, "weekly_trading_average_price"),
      color = COLOR.WEEKLY,
      thickness = 3,
      target = averageChart,
      inset = sideMargin / 2
    },
    {
      id = "dailyAveragePrice",
      text = GetUIText(COMMON_TEXT, "daily_trading_average_price"),
      color = COLOR.DAILY,
      thickness = 3,
      inset = 0
    },
    {
      id = "trading_volume",
      text = GetUIText(COMMON_TEXT, "trading_volume"),
      color = COLOR.VOLUME,
      thickness = FONT_SIZE.MIDDLE,
      target = volumeChart,
      inset = sideMargin * 1.3
    }
  }
  local examples = {}
  for i = 1, #exampleTable do
    local info = exampleTable[i]
    local example = CreateExample(info.id, info.text, info.color, info.thickness)
    examples[i] = example
    if info.target ~= nil then
      example:AddAnchor("TOPLEFT", info.target, "BOTTOMLEFT", 0, info.inset)
    else
      example:AddAnchor("BOTTOMLEFT", examples[i - 1], "BOTTOMRIGHT", sideMargin / 2, info.inset)
    end
  end
  local GetMaxValue = function(values)
    local maxValue = 0
    for i = 1, #values do
      if maxValue < tonumber(values[i]) then
        maxValue = tonumber(values[i])
      end
    end
    return maxValue
  end
  local GetPositionX = function(idx, gridWidth, inset)
    return gridWidth * idx + inset
  end
  local GetPositionY = function(value, maxValue, chartHeight)
    if maxValue <= 0 then
      return 0
    end
    return value / maxValue * chartHeight
  end
  local function ConvertValueToPoint(values, maxValue, gridWidth, inset, chartHeight)
    local points = {}
    for i = 1, #values - 1 do
      points[i] = {}
      points[i].beginX = GetPositionX(i - 1, gridWidth, inset)
      points[i].beginY = GetPositionY(tonumber(values[i]), maxValue, chartHeight)
      points[i].endX = GetPositionX(i, gridWidth, inset)
      points[i].endY = GetPositionY(tonumber(values[i + 1]), maxValue, chartHeight)
    end
    return points
  end
  local function ConvertValueToStickPoint(values, gridWidth, inset, chartHeight)
    local maxValue = GetMaxValue(values)
    local points = {}
    for i = 1, #values do
      points[i] = {}
      points[i].beginX = GetPositionX(i - 1, gridWidth, inset)
      points[i].beginY = 0
      points[i].endX = GetPositionX(i - 1, gridWidth, inset)
      points[i].endY = GetPositionY(tonumber(values[i]), maxValue, chartHeight)
    end
    return points
  end
  local function FillChart()
    local prices = X2Auction:GetAsrGoldLabels()
    local averageValueItems = averageChart:GetValueItems("vertical")
    for i = 1, #averageValueItems do
      if prices[i] ~= nil then
        averageValueItems[i]:SetText(GetMoneyString(prices[i]))
      end
    end
    local volumes = X2Auction:GetAsrVolLabels()
    local volumeValueItems = volumeChart:GetValueItems("vertical")
    local width = 0
    local needAmendment = tonumber(volumes[1]) < 3
    if needAmendment then
      for i = 2, #volumes - 1 do
        volumes[i] = ""
      end
    end
    for i = 1, #volumeValueItems do
      if volumes[i] ~= nil then
        local str = volumes[i] ~= "" and string.format("%d", volumes[i]) or volumes[i]
        volumeValueItems[i]:SetText(str)
        local itemWidth = volumeValueItems[i].style:GetTextWidth(str)
        if width < itemWidth then
          width = itemWidth
        end
      end
    end
    for i = 1, #volumeValueItems do
      volumeValueItems[i]:SetWidth(width)
    end
    averageChart.dailyLine:ClearPoints()
    averageChart.weeklyLine:ClearPoints()
    volumeChart.volumeLine:ClearPoints()
    if marketPriceValue == nil then
      return
    end
    for i = 1, #marketPriceValue do
      chartValue.dailyAverage[i] = marketPriceValue[i].dailyAvg
      chartValue.weeklyAverage[i] = marketPriceValue[i].weeklyAvg
      chartValue.volumes[i] = marketPriceValue[i].volume
      chartValue.minPrice[i] = marketPriceValue[i].minPrice
      chartValue.maxPrice[i] = marketPriceValue[i].maxPrice
    end
    local gridWidth, _ = averageChart:GetGridExtent()
    local centerInset = gridWidth / 2 + 1
    local dailyMaxValue = GetMaxValue(chartValue.dailyAverage)
    local weeklyMaxValue = GetMaxValue(chartValue.weeklyAverage)
    local priceMaxValue = math.max(dailyMaxValue, weeklyMaxValue)
    averageChart.dailyLine:SetPoints(ConvertValueToPoint(chartValue.dailyAverage, priceMaxValue, gridWidth, centerInset, averageChart:GetHeight()))
    averageChart.weeklyLine:SetPoints(ConvertValueToPoint(chartValue.weeklyAverage, priceMaxValue, gridWidth, centerInset, averageChart:GetHeight()))
    local gridWidth, _ = volumeChart:GetGridExtent()
    local centerInset = gridWidth / 2 + 1
    volumeChart.volumeLine:SetPoints(ConvertValueToStickPoint(chartValue.volumes, gridWidth, centerInset, volumeChart:GetHeight()))
  end
  local events = {
    DIAGONAL_LINE = function()
      window:Show(true)
    end,
    DIAGONAL_ASR = function(itemName, itemGrade, values)
      marketPriceValue = values
      periods = X2Auction:GetMarkerPricePeriod()
      local viewPeriods = {}
      for i = #periods, 1, -1 do
        if i == #periods or i == 8 or i == 1 then
          table.insert(viewPeriods, periods[i])
        end
      end
      for i = 1, #viewPeriods do
        local day = averageChart.day[i]
        local str = string.format("%d.%d", viewPeriods[i].month, viewPeriods[i].day)
        day:SetText(str)
      end
      if not window:IsVisible() then
        window:Show(true)
      end
      if itemGrade == -1 then
        UIParent:Warning("marker price answer, item grade is unusual")
        return
      end
      local color = X2Item:GradeColor(itemGrade)
      local gradeName = X2Item:GradeName(itemGrade)
      color = Hex2Dec(color)
      window.itemName:SetText(string.format("<%s> %s", gradeName, itemName))
      ApplyTextColor(window.itemName, color)
      FillChart()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local marketPriceWnd
function ShowMarketPriceWindow(itemType, itemGrade)
  if X2Player:GetFeatureSet().marketPrice ~= true then
    return
  end
  if not UIParent:GetPermission(UIC_MARKET_PRICE) then
    return
  end
  if marketPriceWnd == nil then
    marketPriceWnd = CreateMarketPriceWindow("marketPriceWnd", "UIParent")
    marketPriceWnd:AddAnchor("CENTER", "UIParent", 0, 0)
    ADDON:RegisterContentWidget(UIC_MARKET_PRICE, marketPriceWnd)
  end
  X2Auction:AskMarketPrice(itemType, itemGrade)
end
