local TRADE_LIST_ROW_COUNT = 10
function SetViewOfResidentTrades(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local initButton = parent:CreateChildWidget("button", "initButton", 0, true)
  initButton:Enable(true)
  initButton:SetText(GetUIText(AUCTION_TEXT, "search_condition_init"))
  initButton:AddAnchor("TOPLEFT", parent, "TOPLEFT", 11, 12)
  ApplyButtonSkin(initButton, BUTTON_BASIC.DEFAULT)
  parent.initButton = initButton
  local comboBox = W_CTRL.CreateComboBox("comboBox", parent)
  comboBox:SetWidth(180)
  comboBox:AddAnchor("LEFT", initButton, "RIGHT", 15, 0)
  local datas = {}
  local str = {
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_ALL].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_SELLER_NAME].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_HOUSE_NAME].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_WORKTABLE].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_FARM].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_UNDERWATER_STRUCTURE].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_SMALL].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_MEDIUM].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_LARGE].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_FLOATING].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_MANSION].text,
    RESIDENT_TRADE_FIND_FILTER[HOUSING_LIST_FILTER_PUBLIC].text
  }
  for i = 1, #str do
    local data = {
      text = str[i],
      value = i
    }
    table.insert(datas, data)
  end
  comboBox:AppendItems(datas)
  parent.comboBox = comboBox
  local searchWord = W_CTRL.CreateEdit("searchWord", parent)
  searchWord:SetExtent(330, DEFAULT_SIZE.EDIT_HEIGHT)
  searchWord:AddAnchor("LEFT", comboBox, "RIGHT", 10, 0)
  parent.searchWord = searchWord
  local searchButton = parent:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:Enable(true)
  searchButton:SetText(GetCommonText("search"))
  searchButton:AddAnchor("LEFT", searchWord, "RIGHT", 15, 0)
  searchButton:SetWidth(90)
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  parent.searchButton = searchButton
  local frame = CreatePageListCtrl(parent, "frame", 0)
  frame:Show(true)
  frame:AddAnchor("TOPLEFT", initButton, -10, initButton:GetHeight() + sideMargin / 2)
  frame:AddAnchor("BOTTOMRIGHT", parent, 0, bottomMargin)
  frame.showMap = {}
  local refreshButton = parent:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:AddAnchor("BOTTOMLEFT", parent, 0, -sideMargin)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  parent.refreshButton.timeout = X2Resident:GetHousingTradeRefreshTime() * 1000
  local emptylabel = parent:CreateChildWidget("label", "emptylabel", 0, true)
  emptylabel:AddAnchor("TOPLEFT", frame, 0, frame:GetHeight() / 2)
  emptylabel:SetExtent(frame:GetWidth(), FONT_SIZE.LARGE)
  emptylabel.style:SetAlign(ALIGN_CENTER)
  emptylabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(emptylabel, FONT_COLOR.DEFAULT)
  emptylabel:SetText(GetUIText(HOUSING_TEXT, "tradelist_empty"))
  emptylabel:Show(true)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.sellername)
    else
      subItem:SetText("")
    end
  end
  local KindDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.kind)
    else
      subItem:SetText("")
    end
  end
  local DivisionDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.division)
    else
      subItem:SetText("")
    end
  end
  local FamilyNumDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data.decoextendnum > 0 then
        subItem:SetText(tostring(data.decolimitnum) .. "+" .. tostring(data.decoextendnum))
      else
        subItem:SetText(tostring(data.decolimitnum))
      end
    else
      subItem:SetText("")
    end
  end
  local PriceDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.price:Update(data.price)
      subItem.price:Show(true)
    else
      subItem.price:Show(false)
    end
  end
  local LocationDataSetFunc = function(subItem, data, setValue)
    if setValue then
      function subItem.showMap:ShowPortal()
        worldmap:ToggleMapWithPortal(data.zoneId, data.posx, data.posy, data.posz)
      end
      subItem.showMap:SetHandler("OnClick", subItem.showMap.ShowPortal)
      subItem.showMap:Show(true)
    else
      subItem.showMap:Show(false)
    end
  end
  local NameLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetEllipsis(true)
    local OnEnter = function(self)
      SetTooltip(self:GetText(), self)
    end
    subItem:SetHandler("OnEnter", OnEnter)
  end
  local KindLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetEllipsis(true)
    local OnEnter = function(self)
      SetTooltip(self:GetText(), self)
    end
    subItem:SetHandler("OnEnter", OnEnter)
  end
  local DivisionLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetEllipsis(true)
    local OnEnter = function(self)
      SetTooltip(self:GetText(), self)
    end
    subItem:SetHandler("OnEnter", OnEnter)
  end
  local PriceLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local currentPrice = W_MONEY.CreateDefaultMoneyWindow(subItem:GetId() .. ".Price", subItem, 150, 23)
    currentPrice:AddAnchor("RIGHT", subItem, "RIGHT", -5, 0)
    currentPrice.currency = F_MONEY.currency.houseSale
    subItem.price = currentPrice
    currentPrice:Show(false)
  end
  local LocationLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local showMap = subItem:CreateChildWidget("button", "okButton", 0, true)
    showMap:AddAnchor("CENTER", subItem, 0, 0)
    ApplyButtonSkin(showMap, BUTTON_CONTENTS.MAP_OPEN)
    subItem.showMap = showMap
    showMap:Show(false)
  end
  local PriceAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + RESIDENT_TRADE_IDX.PRICE].price
    local valueB = b[ROWDATA_COLUMN_OFFSET + RESIDENT_TRADE_IDX.PRICE].price
    return tonumber(valueA) < tonumber(valueB) and true or false
  end
  local PriceDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + RESIDENT_TRADE_IDX.PRICE].price
    local valueB = b[ROWDATA_COLUMN_OFFSET + RESIDENT_TRADE_IDX.PRICE].price
    return tonumber(valueA) > tonumber(valueB) and true or false
  end
  frame:InsertColumn(RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.NAME].text, RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.NAME].width, LCCIT_STRING, NameDataSetFunc, nil, nil, NameLayoutFunc)
  frame:InsertColumn(RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.KIND].text, RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.KIND].width, LCCIT_STRING, KindDataSetFunc, nil, nil, KindLayoutFunc)
  frame:InsertColumn(RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.DIVISION].text, RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.DIVISION].width, LCCIT_STRING, DivisionDataSetFunc, nil, nil, DivisionLayoutFunc)
  frame:InsertColumn(RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.FAMILYNUM].text, RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.FAMILYNUM].width, LCCIT_STRING, FamilyNumDataSetFunc, nil, nil, nil)
  frame:InsertColumn(RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.PRICE].text, RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.PRICE].width, LCCIT_WINDOW, PriceDataSetFunc, PriceAscendingSortFunc, PriceDescendingSortFunc, PriceLayoutFunc)
  frame:InsertColumn(RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.LOCATION].text, RESIDENT_TRADE_INFO[RESIDENT_TRADE_IDX.LOCATION].width, LCCIT_BUTTON, LocationDataSetFunc, nil, nil, LocationLayoutFunc)
  frame:InsertRows(TRADE_LIST_ROW_COUNT, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    if i == #frame.listCtrl.column then
      frame.listCtrl.column[i]:Enable(false)
    end
  end
  return frame
end
function CreateResidentTrades(id, parent)
  local frame = SetViewOfResidentTrades(id, parent)
  local pageControl = frame.pageControl
  function parent:OnFillData(infos, rowNum, filter, searchword, refresh)
    frame:DeleteAllDatas()
    parent.comboBox:Select(filter)
    parent.searchWord:SetText(searchword)
    if refresh > 0 then
      parent.refreshButton.timeout = refresh
    end
    if #infos == 0 then
      parent.emptylabel:Show(true)
    else
      parent.emptylabel:Show(false)
    end
    for i = 1, #infos do
      local info = infos[i]
      for j = 1, #RESIDENT_TRADE_INFO do
        frame:InsertData(i, j, info)
      end
    end
    pageControl:SetPageByItemCount(rowNum, TRADE_LIST_ROW_COUNT)
    pageControl:MoveFirstPage()
    column = frame.listCtrl.column[RESIDENT_TRADE_IDX.PRICE]
    column.curSortFunc = column.sortFunc1
    column:OnClick()
    function parent.refreshButton:OnClick()
      parent.refreshButton:SetHandler("OnUpdate", parent.refreshButton.OnUpdateReq)
      X2Resident:RequestHousingTradeList(X2Unit:GetCurrentZoneGroup(), parent.comboBox:GetSelectedIndex(), parent.searchWord:GetText())
    end
    parent.refreshButton:SetHandler("OnClick", parent.refreshButton.OnClick)
    function parent.refreshButton:OnUpdateReq(dt)
      self.timeout = self.timeout - dt
      local remainTime = math.floor(self.timeout / 1000)
      if remainTime <= 0 then
        self:Enable(true)
        self:ReleaseHandler("OnUpdate")
        self:ReleaseHandler("OnEnter")
      else
        self:Enable(false)
        function self:GetPeriod(seconds)
          if seconds == nil then
            return ""
          end
          local MIN = 60
          dateFormat = {}
          dateFormat.year = 0
          dateFormat.month = 0
          dateFormat.day = 0
          dateFormat.hour = 0
          dateFormat.minute = math.floor(seconds / MIN)
          if 0 < dateFormat.minute then
            seconds = seconds - dateFormat.minute * MIN or seconds
          end
          dateFormat.second = seconds
          local remainTimeString = locale.time.GetRemainDateToDateFormat(dateFormat, DEFAULT_FORMAT_FILTER + FORMAT_FILTER.SECOND)
          return remainTimeString
        end
        function self:OnEnter(arg)
          SetTooltip(GetUIText(COMMON_TEXT, "not_yet_report_spammer", self:GetPeriod(remainTime)), self)
        end
        self:SetHandler("OnEnter", self.OnEnter)
      end
    end
    parent.refreshButton:SetHandler("OnUpdate", parent.refreshButton.OnUpdateReq)
    function parent.refreshButton:OnLeave(arg)
      HideTooltip()
    end
    parent.refreshButton:SetHandler("OnLeave", parent.refreshButton.OnLeave)
  end
  function parent.searchButton:OnClick()
    X2Resident:FilterHousingTradeList(parent.comboBox:GetSelectedIndex(), parent.searchWord:GetText())
  end
  parent.searchButton:SetHandler("OnClick", parent.searchButton.OnClick)
  function parent.initButton:OnClick()
    parent.comboBox:Select(HOUSING_LIST_FILTER_ALL)
    parent.searchWord:SetText("")
    X2Resident:FilterHousingTradeList(parent.comboBox:GetSelectedIndex(), parent.searchWord:GetText())
  end
  parent.initButton:SetHandler("OnClick", parent.initButton.OnClick)
  function parent.searchWord:OnEnterPressed()
    X2Resident:FilterHousingTradeList(parent.comboBox:GetSelectedIndex(), parent.searchWord:GetText())
  end
  parent.searchWord:SetHandler("OnEnterPressed", parent.searchWord.OnEnterPressed)
end
