local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreateSearchFrame = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  window:SetHeight(35)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_01")
  bg:AddAnchor("TOPLEFT", window, -5, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 5, 0)
  local refreshBtn = window:CreateChildWidget("button", "refreshBtn", 0, true)
  refreshBtn:AddAnchor("TOPRIGHT", window, "TOPRIGHT", 0, 0)
  ApplyButtonSkin(refreshBtn, BUTTON_STYLE.RESET_BIG)
  local searchBtn = window:CreateChildWidget("button", "searchBtn", 0, true)
  searchBtn:SetText(GetUIText(COMMON_TEXT, "search"))
  ApplyButtonSkin(searchBtn, BUTTON_BASIC.DEFAULT)
  searchBtn:AddAnchor("RIGHT", refreshBtn, "LEFT", -4, 0)
  local actTypeCombo = W_CTRL.CreateComboBox("actTypeCombo", window)
  actTypeCombo:SetWidth(310)
  actTypeCombo:AddAnchor("TOPLEFT", window, 10, 4)
  actTypeCombo:SetEllipsis(true)
  actTypeCombo:SetVisibleItemCount(10)
  local datas = {}
  local firstData = {
    text = GetUIText(INVEN_TEXT, "allTab"),
    value = 0,
    color = FONT_COLOR.DEFAULT,
    disableColor = FONT_COLOR.GRAY,
    useColor = true,
    enable = true
  }
  table.insert(datas, firstData)
  local actInfo = X2Craft:GetActabilityGroup()
  for i = 1, #actInfo do
    local data = {
      text = actInfo[i].name,
      value = actInfo[i].type
    }
    table.insert(datas, data)
  end
  actTypeCombo:AppendItems(datas, false)
  local actPointCombo = W_CTRL.CreateComboBox("actPointCombo", window)
  actPointCombo:SetWidth(310)
  actPointCombo:AddAnchor("LEFT", actTypeCombo, "RIGHT", 4, 0)
  actPointCombo:SetEllipsis(true)
  local originDatas = {
    GetCommonText("search_all_craft_order"),
    GetCommonText("search_possible_craft_order")
  }
  local datas = {}
  for i = 1, #originDatas do
    local data = {
      text = originDatas[i],
      value = i,
      color = FONT_COLOR.DEFAULT,
      disableColor = FONT_COLOR.GRAY,
      useColor = true,
      enable = true
    }
    table.insert(datas, data)
  end
  actPointCombo:AppendItems(datas, false)
  local actType = 0
  function actTypeCombo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    if info.value == 0 then
      actPointCombo:SetEnable(false, true)
    else
      actPointCombo:SetEnable(true, true)
    end
    actType = info.value
  end
  local possible = false
  function actPointCombo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    if info.value == 1 then
      possible = false
    else
      possible = true
    end
  end
  function window:GetOption()
    return actType, possible
  end
  function window:SetOption(actType, possible)
    if actType == 0 then
      actTypeCombo:Select(1)
      actPointCombo:Select(1)
      actPointCombo:Enable(false, true)
    else
      actTypeCombo:Select(actTypeCombo:GetIndexByValue(actType))
      actPointCombo:Select(possible and 2 or 1)
    end
  end
  function window:Init()
    window:SetOption(0)
  end
  local function SearchBtnFunc()
    parent:Search()
  end
  ButtonOnClickHandler(searchBtn, SearchBtnFunc)
  local function RefreshBtnFunc()
    parent:Refresh()
  end
  ButtonOnClickHandler(refreshBtn, RefreshBtnFunc)
  window:Init()
  return window
end
local CreateListFrame = function(id, parent)
  local InfoDataSetFunc = function(subItem, info, setValue)
    if setValue and info ~= "" then
      local item = subItem.item
      subItem.entryId = info.entryId
      local craftType = info.craftType
      local count = info.craftCount
      local grade = info.craftGrade
      local pInfo = X2Craft:GetCraftProductInfo(craftType)[1]
      local pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, grade)
      item:SetItemInfo(pItemInfo)
      item:SetStack(pInfo.amount * count)
      subItem:SetText(pInfo.item_name)
      ApplyTextColor(subItem, Hex2Dec(pItemInfo.gradeColor))
    end
  end
  local InfoLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local item = CreateItemIconButton("item", subItem)
    item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    item:AddAnchor("TOPLEFT", subItem, 0, -(ICON_SIZE.DEFAULT / 2) + 5)
    subItem.item = item
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem:SetAutoResize(true)
    subItem:SetAutoWordwrap(true)
    subItem:SetInset(ICON_SIZE.DEFAULT + 4, 0, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, F_COLOR.GetColor("default"))
  end
  local ActDataSetFunc = function(subItem, info, setValue)
    if setValue and info ~= "" then
      local craftType = info.craftType
      local baseInfo = X2Craft:GetCraftBaseInfo(craftType)
      if baseInfo.required_actability_type ~= nil then
        subItem.actType:SetText(baseInfo.required_actability_name)
        subItem.tip = string.format("|,%d;", baseInfo.required_actability_point)
        subItem.actPoint:SetText(subItem.tip)
        if baseInfo.use_only_actability then
          subItem.actPoint:Show(false)
          subItem.iconWnd:Show(true)
        else
          subItem.actPoint:Show(true)
          subItem.iconWnd:Show(false)
        end
      end
    end
  end
  local ActLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local actType = subItem:CreateChildWidget("label", "actType", 0, true)
    actType:SetHeight(FONT_SIZE.MIDDLE)
    actType:SetAutoResize(true)
    actType:AddAnchor("TOP", subItem, 0, 8)
    actType.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(actType, F_COLOR.GetColor("default"))
    actType.style:SetAlign(ALIGN_CENTER)
    local actPoint = subItem:CreateChildWidget("textbox", "actPoint", 0, true)
    actPoint:SetExtent(subItem:GetWidth(), FONT_SIZE.MIDDLE)
    actPoint:AddAnchor("TOP", actType, "BOTTOM", 0, 7)
    actPoint.style:SetFontSize(FONT_SIZE.MIDDLE)
    actPoint.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(actPoint, F_COLOR.GetColor("default"))
    local iconWnd = subItem:CreateChildWidget("emptywidget", "iconWnd", 0, true)
    iconWnd:AddAnchor("TOP", actType, "BOTTOM", 0, 3)
    local icon = iconWnd:CreateDrawable(TEXTURE_PATH.CRAFT_GRADE, "grade_11_dis", "background")
    icon:AddAnchor("TOP", iconWnd, 0, 0)
    subItem.icon = icon
    iconWnd:SetExtent(icon:GetWidth(), icon:GetHeight())
    function iconWnd:OnEnter()
      SetTooltip(subItem.tip, self)
    end
    iconWnd:SetHandler("OnEnter", iconWnd.OnEnter)
    function iconWnd:OnLeave()
      HideTooltip()
    end
    iconWnd:SetHandler("OnLeave", iconWnd.OnLeave)
  end
  local TimeDataSetFunc = function(subItem, info, setValue)
    if setValue and info ~= "" then
      local remainTime = info.remainTime
      local leftTimeStr, timeWarning = CheckLeftTime(remainTime)
      subItem.timeValue:SetText(leftTimeStr)
      if timeWarning then
        ApplyTextColor(subItem.timeValue, F_COLOR.GetColor("red"))
      else
        ApplyTextColor(subItem.timeValue, F_COLOR.GetColor("default"))
      end
      if info.mine then
        subItem.myEntry:Show(true)
        subItem.timeValue:RemoveAllAnchors()
        subItem.timeValue:AddAnchor("TOP", subItem, 0, 8)
      else
        subItem.myEntry:Show(false)
        subItem.timeValue:RemoveAllAnchors()
        subItem.timeValue:AddAnchor("CENTER", subItem, 0, 0)
      end
    end
  end
  local TimeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local timeValue = subItem:CreateChildWidget("label", "timeValue", 0, true)
    timeValue:SetHeight(FONT_SIZE.MIDDLE)
    timeValue:SetAutoResize(true)
    timeValue:AddAnchor("CENTER", subItem, 0, 0)
    timeValue.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(timeValue, F_COLOR.GetColor("default"))
    local myEntry = subItem:CreateChildWidget("label", "myEntry", 0, true)
    myEntry:SetHeight(FONT_SIZE.MIDDLE)
    myEntry:SetAutoResize(true)
    myEntry:AddAnchor("BOTTOM", subItem, 0, -10)
    myEntry.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myEntry, F_COLOR.GetColor("default"))
    myEntry:SetText(GetUIText(AUCTION_TEXT, "my_putup_goods"))
  end
  local FeeDataSetFunc = function(subItem, info, setValue)
    if setValue and info ~= "" then
      subItem:SetText(string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(info.fee)))
    end
  end
  local FeeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.BLUE)
  end
  local BtnDataSetFunc = function(subItem, info, setValue)
    if setValue and info ~= "" then
      subItem:SetExtent(subItem.textureInfo.coords[3], subItem.textureInfo.coords[4])
      if not X2Craft:InteractionWithBoard() then
        subItem:Enable(false)
        subItem.info = nil
        subItem.tip = GetCommonText("can_not_craft_order_board")
      elseif info.mine then
        subItem:Enable(false)
        subItem.info = nil
        subItem.tip = GetCommonText("can_not_craft_order_mine")
      elseif not info.enableAct then
        subItem:Enable(false)
        subItem.info = info
        subItem.tip = GetCommonText("can_not_craft_order_actability")
      else
        subItem:Enable(true)
        subItem.info = info
        subItem.tip = GetCommonText("show_craft_order")
      end
    end
  end
  local BtnLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyButtonSkin(subItem, BUTTON_ICON.SEARCH)
    subItem.textureInfo = UIParent:GetTextureData(BUTTON_ICON.SEARCH.path, "btn_search_on")
    subItem:Enable(false)
    subItem.tip = ""
    local function ProcessBtnFunc()
      ToggleProcessOrder(subItem.info, PROCESS_DEFAULT_TYPE)
    end
    ButtonOnClickHandler(subItem, ProcessBtnFunc)
    function subItem:OnEnter()
      SetTooltip(subItem.tip, self)
    end
    subItem:SetHandler("OnEnter", subItem.OnEnter)
    function subItem:OnLeave()
      HideTooltip()
    end
    subItem:SetHandler("OnLeave", subItem.OnLeave)
  end
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", window)
  listCtrl:UseSortMark()
  listCtrl:RemoveAllAnchors()
  listCtrl:AddAnchor("TOPLEFT", window, 0, 0)
  listCtrl:SetExtent(760, 444)
  window:InsertColumn(GetCommonText("craft_order_info"), 290, LCCIT_TEXTBOX, InfoLayoutSetFunc, InfoDataSetFunc)
  window:InsertColumn(GetCommonText("actability"), 160, LCCIT_WINDOW, ActLayoutSetFunc, ActDataSetFunc)
  window:InsertColumn(GetUIText(AUCTION_TEXT, "left_time"), 95, LCCIT_WINDOW, TimeLayoutSetFunc, TimeDataSetFunc)
  window:InsertColumn(GetCommonText("craft_order_fee"), 169, LCCIT_TEXTBOX, FeeLayoutSetFunc, FeeDataSetFunc)
  window:InsertColumn("", 47, LCCIT_BUTTON, BtnLayoutSetFunc, BtnDataSetFunc)
  window:InsertRows(CRAFT_ORDER_ENTRY_PER_SEARCH, false)
  window:DeleteAllDatas()
  DrawListCtrlUnderLine(listCtrl, 34)
  listCtrl:DrawListLine(nil, false, true)
  for i = 1, #listCtrl.column do
    SettingListColumn(listCtrl, listCtrl.column[i], 36)
    DrawListCtrlColumnSperatorLine(listCtrl.column[i], #listCtrl.column, i)
  end
  local columnKind = {
    nil,
    COSK_ACTABILITY_GROUP,
    nil,
    COSK_FEE
  }
  local curOrder = COSO_DESC
  local curKind = COSK_DEFAULT
  local ascMark = listCtrl.AscendingSortMark
  local descMark = listCtrl.DescendingSortMark
  for i = 1, #listCtrl.column do
    do
      local function ChangeSortOrder()
        if columnKind[i] == nil then
          return
        end
        if curKind ~= columnKind[i] then
          curKind = columnKind[i]
        elseif curOrder == COSO_ASC then
          curOrder = COSO_DESC
        else
          curOrder = COSO_ASC
        end
        parent:Search()
      end
      ButtonOnClickHandler(listCtrl.column[i], ChangeSortOrder)
    end
  end
  local pageCtrl = W_CTRL.CreatePageControl("pageCtrl", parent)
  pageCtrl:AddAnchor("TOP", listCtrl, "BOTTOM", 0, 11)
  function pageCtrl.OnPageChanged(pageIndex)
    parent:Refresh()
  end
  function window:UpdateColumnMark()
    for i = 1, #listCtrl.column do
      if columnKind[i] == curKind then
        if curOrder == COSO_ASC then
          descMark:SetVisible(false)
          ascMark:RemoveAllAnchors()
          ascMark:AddAnchor("RIGHT", listCtrl.column[i], -10, 0)
          ascMark:SetVisible(true)
        else
          ascMark:SetVisible(false)
          descMark:RemoveAllAnchors()
          descMark:AddAnchor("RIGHT", listCtrl.column[i], -10, 0)
          descMark:SetVisible(true)
        end
        return
      end
    end
  end
  function window:GetOption()
    return curKind, curOrder, pageCtrl:GetCurrentPageIndex()
  end
  function window:SetInfo(infos)
    window:DeleteAllDatas()
    for i = 1, #infos do
      window:InsertData(i, 1, infos[i])
      window:InsertData(i, 2, infos[i])
      window:InsertData(i, 3, infos[i])
      window:InsertData(i, 4, infos[i])
      window:InsertData(i, 5, infos[i])
    end
    window:UpdateColumnMark()
  end
  function window:ResetPage()
    pageCtrl:SetCurrentPage(1, false)
  end
  function window:Clear()
    window:DeleteAllDatas()
    window:ResetPage()
    curOrder = COSO_DESC
    curKind = COSK_DEFAULT
  end
  local events = {
    CRAFT_ORDER_ENTRY_SEARCHED = function(infos, totalCount, page)
      pageCtrl:SetCurrentPage(page, false)
      pageCtrl:SetPageByItemCount(totalCount, CRAFT_ORDER_ENTRY_PER_SEARCH, false)
      window:SetInfo(infos)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function CreateCraftOrderSearchTab(window)
  local searchFrame = CreateSearchFrame("searchFrame", window)
  searchFrame:AddAnchor("TOPLEFT", window, 0, 10)
  searchFrame:AddAnchor("TOPRIGHT", window, 0, 10)
  local desc = window:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetExtent(800, FONT_SIZE.SMALL)
  desc:SetAutoResize(true)
  desc:SetAutoWordwrap(true)
  desc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  desc:AddAnchor("BOTTOMLEFT", window, 0, 0)
  desc.style:SetAlign(ALIGN_LEFT)
  desc.style:SetFontSize(FONT_SIZE.SMALL)
  ApplyTextColor(desc, F_COLOR.GetColor("default"))
  desc:SetText(GetCommonText("craft_order_board_search_tip", F_COLOR.GetColor("red", true), F_COLOR.GetColor("gray", true)))
  local listFrame = CreateListFrame("listFrame", window)
  listFrame:AddAnchor("TOPLEFT", searchFrame, "BOTTOMLEFT", 0, 2)
  listFrame:AddAnchor("BOTTOMRIGHT", window, 0, -desc:GetHeight())
  local search = true
  function window:Clear()
    searchFrame:Init()
    listFrame:Clear()
    search = true
    HideProcessOrder()
  end
  function window:OnShow()
    if search then
      window:Search()
    end
    search = false
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:OnHide()
  end
  window:SetHandler("OnShow", window.OnShow)
  local actType, possible, sortKind, sortOrder, page
  function window:Search()
    listFrame:ResetPage()
    actType, possible = searchFrame:GetOption()
    sortKind, sortOrder, page = listFrame:GetOption()
    X2Craft:SearchCraftOrder(actType, sortKind, sortOrder, page, possible)
  end
  function window:Refresh()
    searchFrame:SetOption(actType, possible)
    sortKind, sortOrder, page = listFrame:GetOption()
    X2Craft:SearchCraftOrder(actType, sortKind, sortOrder, page, possible)
  end
  local events = {
    PROCESS_CRAFT_ORDER = function(result)
      if result then
        window:Refresh()
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
