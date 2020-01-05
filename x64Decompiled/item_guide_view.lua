local MAX_COUNT = {
  LIST_ROW = 7,
  PAGE_ITEM = 7,
  ITEM_LIST = 15
}
local tabInfo = {
  icon = {
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_hammer"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_map"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_indeon"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_raid"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_box"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_shop"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_event"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_cash"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_house"
    },
    {
      drawableType = "drawable",
      path = TEXTURE_PATH.ITEM_GUIDE,
      coordsKey = "tab_socket_change"
    }
  },
  str = {
    GetUIText(AUCTION_TEXT, "item_group_craft"),
    GetUIText(COMMON_TEXT, "item_group_craft_2"),
    GetUIText(COMMON_TEXT, "portal_indun"),
    GetUIText(COMMON_TEXT, "equip_item_guide_loot_main_category_boss"),
    GetUIText(COMMON_TEXT, "equip_item_guide_loot_main_category_etc"),
    GetUIText(COMMON_TEXT, "item_guide_loot_main_category_shop"),
    GetUIText(COMMON_TEXT, "event"),
    GetUIText(INGAMESHOP_TEXT, "inGameShop"),
    GetUIText(COMMON_TEXT, "rebuild_housing"),
    GetUIText(COMMON_TEXT, "socket_change")
  },
  bgColor = {
    "craft",
    "other_craft",
    "indun",
    "boss",
    "etc",
    "shop",
    "event",
    "ingame_shop",
    "rebuild_housing",
    "socket_change"
  }
}
local lootCategoriesUIOrder = {
  IGLMC_CRAFT,
  IGLMC_OTHER_CRAFT,
  IGLMC_INDUN,
  IGLMC_BOSS,
  IGLMC_ETC,
  IGLMC_SHOP,
  IGLMC_EVENT,
  IGLMC_INGAME_SHOP,
  IGLMC_REBUILDING,
  IGLMC_SOCKET_CHANGE
}
local function GetUIOrderByLootCategory(lootCategory)
  for i = 1, #lootCategoriesUIOrder do
    if lootCategoriesUIOrder[i] == lootCategory then
      return i
    end
  end
  return 1
end
function GetLootCategoriesByTabIndex(tabIndex)
  if tabIndex == 1 then
    return 1
  end
  return lootCategoriesUIOrder[tabIndex - 1] + 1
end
function GetLootCategoryStr(index)
  if tabInfo.str[index] == nil then
    return "invalid"
  end
  return tabInfo.str[index]
end
local CreateCategoryWnd = function(id, parent, height)
  local listWnd = W_CTRL.CreateScrollListBox(id, parent, parent, "TYPE2")
  listWnd:SetExtent(190, height)
  listWnd.content:TurnoffOverParent()
  listWnd.content:SetTreeTypeIndent(true, 20, 20)
  listWnd.content:SetHeight(FONT_SIZE.MIDDLE)
  listWnd.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
  listWnd.content:UseChildStyle(true)
  listWnd.content.childStyle:SetEllipsis(true)
  listWnd.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
  listWnd.content.childStyle:SetColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], FONT_COLOR.DEFAULT[4])
  local line = listWnd.content:CreateSeparatorImageDrawable(TEXTURE_PATH.DEFAULT, "background")
  line:SetTextureInfo("line_02", "default")
  line:SetExtent(170, 3)
  listWnd:SetTreeImage()
  return listWnd
end
local CreateOrderWidget = function(id, parent)
  local label = parent:CreateChildWidget("label", id, 0, true)
  label:SetExtent(FONT_SIZE.SMALL, FONT_SIZE.SMALL)
  label.style:SetAlign(ALIGN_CENTER)
  label.style:SetFontSize(FONT_SIZE.SMALL)
  label.style:SetShadow(true)
  ApplyTextColor(label, FONT_COLOR.WHITE)
  local bg = label:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "count_bg", "background")
  bg:AddAnchor("TOPRIGHT", label, 2, -1)
  function label:SetOrder(order, mainCategory, subCategory)
    self:SetText(tostring(order))
    if mainCategory == 1 then
      if subCategory == 1 then
        bg:SetColor(ConvertColor(107), ConvertColor(192), ConvertColor(117), 1)
      elseif subCategory == 2 then
        bg:SetColor(ConvertColor(35), ConvertColor(174), ConvertColor(185), 1)
      elseif subCategory == 3 then
        bg:SetColor(ConvertColor(56), ConvertColor(131), ConvertColor(215), 1)
      end
    elseif mainCategory == 2 then
      if subCategory == 2 then
        bg:SetColor(ConvertColor(255), ConvertColor(144), ConvertColor(46), 1)
      elseif subCategory == 3 then
        bg:SetColor(ConvertColor(215), ConvertColor(78), ConvertColor(168), 1)
      elseif subCategory == 4 then
        bg:SetColor(ConvertColor(129), ConvertColor(88), ConvertColor(223), 1)
      end
    end
  end
  return label
end
local function CreateReferenceWnd(id, parent)
  local referenceWnd = parent:CreateChildWidget("emptywidget", "referenceWnd", 0, true)
  referenceWnd:SetExtent(440, 45)
  local bg = CreateContentBackground(referenceWnd, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", referenceWnd, -5, 0)
  bg:AddAnchor("BOTTOMRIGHT", referenceWnd, 0, 0)
  local equipIcon = referenceWnd:CreateChildWidget("emptywidget", "equipIcon", 0, false)
  equipIcon:AddAnchor("LEFT", referenceWnd, MARGIN.WINDOW_SIDE / 1.5, 0)
  local equipIconTexture = referenceWnd:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "icon_equip_sm", "background")
  equipIconTexture:AddAnchor("CENTER", equipIcon, 0, 0)
  equipIcon:SetExtent(equipIconTexture:GetExtent())
  local equipLabel = referenceWnd:CreateChildWidget("label", "equipLabel", 0, false)
  equipLabel:SetExtent(50, FONT_SIZE.MIDDLE)
  equipLabel:SetAutoResize(true)
  equipLabel:SetInset(equipIcon:GetWidth() + 2, 0, 0, 0)
  equipLabel:AddAnchor("LEFT", equipIcon, 0, 0)
  ApplyTextColor(equipLabel, FONT_COLOR.DEFAULT)
  equipLabel:SetText(string.format(": %s", GetUIText(COMMON_TEXT, "equip_item_guide_equipped_gear_score")))
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "equip_item_guide_equipped_icon_tooltip"), self)
  end
  equipLabel:SetHandler("OnEnter", OnEnter)
  local orderWidget = CreateOrderWidget("order", referenceWnd)
  orderWidget:AddAnchor("LEFT", equipLabel, "RIGHT", MARGIN.WINDOW_SIDE / 2, -1)
  orderWidget:SetOrder("1", 1, 1)
  local orderLabel = referenceWnd:CreateChildWidget("label", "orderLabel", 0, false)
  orderLabel:SetExtent(50, FONT_SIZE.MIDDLE)
  orderLabel:SetAutoResize(true)
  orderLabel:SetInset(orderWidget:GetWidth() + 5, 0, 0, 0)
  orderLabel:AddAnchor("LEFT", orderWidget, 0, 1)
  orderLabel:SetText(string.format("~ : %s", GetUIText(COMMON_TEXT, "craft_info")))
  ApplyTextColor(orderLabel, FONT_COLOR.DEFAULT)
  referenceWnd.orderTooltip = nil
  local function CreateOrderTooltip(id, parent)
    local tooltip = parent:CreateChildWidget("emptywidget", id, 0, false)
    tooltip:SetExtent(500, 500)
    CreateTooltipDrawable(tooltip)
    local rightOffset = 15
    local upperStr = string.format([[
%s
%s]], GetUIText(COMMON_TEXT, "craft_info"), GetUIText(COMMON_TEXT, "craft_step_desc"))
    local upperSection = tooltip:CreateChildWidget("textbox", "upperSection", 0, false)
    local width = DEFAULT_SIZE.TOOLTIP_MAX_WIDTH
    local longestWidth = upperSection.style:GetTextWidth(upperStr) + 5
    if width > longestWidth then
      width = longestWidth
    end
    upperSection:SetExtent(width, 300)
    upperSection:AddAnchor("TOPLEFT", tooltip, rightOffset, rightOffset)
    upperSection.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(upperSection, FONT_COLOR.SOFT_BROWN)
    upperSection:SetAutoResize(true)
    upperSection:SetText(upperStr)
    local function CreateOrderExample(id, parent, str)
      local orderWidget = CreateOrderWidget(id, parent)
      local descLabel = orderWidget:CreateChildWidget("label", "descLabel", 0, true)
      descLabel:SetExtent(50, FONT_SIZE.MIDDLE)
      descLabel:AddAnchor("LEFT", orderWidget, "RIGHT", MARGIN.WINDOW_SIDE / 2, 1)
      descLabel:SetAutoResize(true)
      descLabel:SetText(str)
      ApplyTextColor(descLabel, FONT_COLOR.SOFT_BROWN)
      return orderWidget
    end
    local strs = {
      GetUIText(COMMON_TEXT, "equip_item_guide_craft_normal"),
      GetUIText(COMMON_TEXT, "equip_item_guide_craft_obsidian1"),
      GetUIText(COMMON_TEXT, "equip_item_guide_craft_obsidian1"),
      GetUIText(COMMON_TEXT, "equip_item_guide_other_craft_honor"),
      GetUIText(COMMON_TEXT, "equip_item_guide_other_craft_warrior"),
      GetUIText(COMMON_TEXT, "equip_item_guide_other_craft_warrior")
    }
    local categories = {
      {1, 1},
      {1, 2},
      {1, 3},
      {2, 2},
      {2, 3},
      {2, 4}
    }
    local offset = MARGIN.WINDOW_SIDE / 1.5
    for i = 1, #strs do
      local example = CreateOrderExample(string.format("example[%d]", i), tooltip, strs[i])
      example:AddAnchor("TOPLEFT", upperSection, "BOTTOMLEFT", 0, offset)
      example:SetOrder("", categories[i][1], categories[i][2])
      offset = offset + example.descLabel:GetHeight()
      if i ~= #strs then
        offset = offset + 7
      end
    end
    tooltip:SetExtent(width + rightOffset * 2, offset + upperSection:GetHeight() + rightOffset * 2)
    return tooltip
  end
  local function OnEnter(self)
    if referenceWnd.orderTooltip == nil then
      referenceWnd.orderTooltip = CreateOrderTooltip("orderTooltip", referenceWnd)
      referenceWnd.orderTooltip:Raise()
    end
    SetDefaultTooltipAnchor(self, referenceWnd.orderTooltip)
    referenceWnd.orderTooltip:Show(true)
  end
  orderLabel:SetHandler("OnEnter", OnEnter)
  local function OnLeave()
    referenceWnd.orderTooltip:Show(false)
    referenceWnd.orderTooltip = nil
  end
  orderLabel:SetHandler("OnLeave", OnLeave)
  local width, _ = F_LAYOUT.GetExtentWidgets(equipLabel, orderLabel)
  referenceWnd:SetWidth(width + MARGIN.WINDOW_SIDE * 1.7)
  function referenceWnd:ShowOrderInfo(show)
    orderWidget:Show(show)
    orderLabel:Show(show)
  end
  return referenceWnd
end
local function CreateDescWnd(id, parent, height)
  local tab = W_BTN.CreateImageTab(id, parent)
  tab:SetExtent(450, height)
  local tabInfos = {
    {
      defaultTab = true,
      tabName = locale.inven.allTab
    }
  }
  for i = 1, #lootCategoriesUIOrder do
    local info = {}
    info.tooltip = GetLootCategoryStr(lootCategoriesUIOrder[i])
    info.buttonStyle = tabInfo.icon[lootCategoriesUIOrder[i]]
    table.insert(tabInfos, info)
  end
  tab:AddTabs(tabInfos)
  local AmendIndex = function(index)
    return index + 1
  end
  function tab:SetTabVisible(index)
    local info = ITEM_GUIDE.GetLootCategoryInfo(index)
    if info == nil then
      return
    end
    local maxCount = tab:GetTabCount()
    for i = 2, maxCount + 1 do
      tab:HideTab(AmendIndex(i))
    end
    for i, v in ipairs(info) do
      tab:ShowTab(AmendIndex(GetUIOrderByLootCategory(v)))
    end
    local count = tab:GetActivateTabCount()
    for i = 1, #tab.divisionLine do
      if i < count + 1 then
        tab.divisionLine[i]:SetVisible(true)
      else
        tab.divisionLine[i]:SetVisible(false)
      end
    end
  end
  local list = W_CTRL.CreateScrollListCtrl("list", tab)
  list:SetExtent(tab:GetWidth(), 560)
  list:AddAnchor("TOPLEFT", tab, 0, BUTTON_SIZE.IMAGE_TAB.HEIGHT + 2)
  list:HideColumnButtons()
  list.scroll:RemoveAllAnchors()
  list.scroll:AddAnchor("TOPRIGHT", list, 0, 0)
  list.scroll:AddAnchor("BOTTOMRIGHT", list, 0, 0)
  local gradeBg = list:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "dot", "background")
  gradeBg:AddAnchor("TOPRIGHT", list.listCtrl, 0, -2)
  gradeBg:AddAnchor("BOTTOMRIGHT", list.listCtrl, 0, 0)
  list.gradeBg = gradeBg
  function list:SetGradeBg(isAscendingSort)
    if not gradeBg:IsVisible() then
      return
    end
    if isAscendingSort then
      gradeBg:SetTextureInfo("dot")
    else
      gradeBg:SetTextureInfo("dot_reverse")
    end
  end
  local texts = {
    GetUIText(COMMON_TEXT, "ascending_order"),
    GetUIText(COMMON_TEXT, "descending_order")
  }
  local datas = {}
  for i = 1, #texts do
    local data = {
      text = texts[i],
      value = i
    }
    table.insert(datas, data)
  end
  local sortCombobox = W_CTRL.CreateComboBox("sortCombobox", tab)
  sortCombobox:SetWidth(85)
  sortCombobox:AddAnchor("BOTTOMRIGHT", list, "TOPRIGHT", 0, -7)
  sortCombobox:AppendItems(datas)
  local function CreateElement(id, parent, index)
    local button = CreateSlotShapeButton(id, parent, index)
    button:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
    button:ApplySlotSkin(SLOT_STYLE.BAG_DEFAUL)
    local bg = button:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "text_bg", "background")
    bg:AddAnchor("TOP", button, "BOTTOM", 0, 0)
    button.nameBg = bg
    local deco = button:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "icon_cover", "artwork")
    deco:AddAnchor("TOPLEFT", button, 0, 0)
    deco:AddAnchor("BOTTOMRIGHT", button, 0, 0)
    local nameLabel = button:CreateChildWidget("label", "nameLabel", 0, true)
    nameLabel:SetExtent(button:GetWidth() - 3, FONT_SIZE.SMALL)
    nameLabel:AddAnchor("CENTER", bg, 0, -3)
    nameLabel.style:SetAlign(ALIGN_CENTER)
    nameLabel.style:SetEllipsis(true)
    nameLabel.style:SetFontSize(FONT_SIZE.SMALL)
    ApplyTextColor(nameLabel, FONT_COLOR.WHITE)
    local orderWidget = CreateOrderWidget("order", button)
    orderWidget:AddAnchor("TOPRIGHT", button, -2, 1)
    function button:SetInfo(info)
      self.info = info
      if info.iconPath then
        self:SetIconPath(info.iconPath)
      else
        self:SetIconPath(INVALID_ICON_PATH)
      end
      nameLabel:SetText(info.name)
      local mainCategory = info.lootMainCategory
      local subCategory = info.lootSubCategory
      bg:SetTextureColor(tabInfo.bgColor[mainCategory])
      local order = info.showOrder
      if (mainCategory == 1 or mainCategory == 2) and order ~= 0 then
        orderWidget:Show(true)
        orderWidget:SetOrder(order, mainCategory, subCategory)
      else
        orderWidget:Show(false)
      end
      local selGrade = GetItemGuideSelectedGrade()
      if selGrade ~= 0 then
        self:SetGrade(selGrade)
      else
        self:SetGrade(nil)
      end
      if info.enable then
        self:OverlayInvisible()
      else
        self:SetOverlayColor("black")
      end
    end
    function button:OnClickProc(arg)
      if arg ~= "LeftButton" then
        return
      end
      if FillDescWndElementClickProc == nil then
        return
      end
      FillDescWndElementClickProc(self.info)
      list:SetSelectedImg(self.info.itemGuideType, parent:GetCurrentPageIndex(), index, self)
    end
    local function OnEnter(self)
      SetTooltip(button.info.name, self)
    end
    nameLabel:SetHandler("OnEnter", OnEnter)
    return button
  end
  local function CreatePage(id, parent)
    local pageCtrl = W_CTRL.CreatePageControl(id, parent, "itemGuide")
    pageCtrl.items = {}
    for i = 1, MAX_COUNT.PAGE_ITEM do
      local button = CreateElement("items", pageCtrl, i)
      button:AddAnchor("LEFT", pageCtrl, (i - 1) * (ICON_SIZE.LARGE + 2) + 5, -(button.nameBg:GetHeight() / 2) + 2)
    end
    function pageCtrl:ProcOnPageChanged(pageIndex, countPerPage)
      self:FillPage(pageIndex, countPerPage)
      local visible = #self.data > MAX_COUNT.PAGE_ITEM
      self.prevPageButton:Show(visible)
      self.nextPageButton:Show(visible)
      local prevPage = self:GetPageData()
      if prevPage ~= nil and prevPage ~= pageIndex then
        self:SetPageData(pageIndex)
        list:UpdatePageSelctedImg(self)
      end
    end
    function pageCtrl:SetData(data)
      self.data = data
    end
    function pageCtrl:GetData()
      return self.data
    end
    function pageCtrl:GetDataViewIndex(index)
      local calcIndex = (self:GetCurrentPageIndex() - 1) * self:GetCountPerPage() + index
      return self.data[calcIndex]
    end
    function pageCtrl:FillPage(pageIndex, countPerPage)
      for i = 1, #self.items do
        self.items[i]:Show(false)
      end
      local startIdx = (pageIndex - 1) * countPerPage + 1
      local iconIdx = 1
      for j = startIdx, #self.data do
        local item = self.items[iconIdx]
        local info = self.data[j]
        if item ~= nil and info ~= nil then
          item:Show(true)
          item:SetInfo(info)
        else
          return
        end
        iconIdx = iconIdx + 1
      end
    end
    return pageCtrl
  end
  local function DataSetFunc(subItem, data, setValue)
    if setValue then
      subItem.pageCtrl:Show(true)
      subItem.pageCtrl:SetPageByItemCount(#data, MAX_COUNT.PAGE_ITEM)
      subItem.pageCtrl:SetData(data)
      local pageIndex = subItem.pageCtrl:GetPageData()
      if pageIndex == nil then
        subItem.pageCtrl:SetPageData(1)
      end
      subItem.pageCtrl:SetCurrentPage(subItem.pageCtrl:GetPageData(), true)
      if data.gearScore then
        subItem.gearScore:SetText(string.format("%d", data.gearScore))
      else
        subItem.gearScore:SetText("")
      end
    else
      subItem.pageCtrl:Show(false)
    end
  end
  local function LayoutFunc(widget, rowIndex, colIndex, subItem)
    local offset = gradeBg:GetWidth()
    local pageCtrl = CreatePage("pageCtrl", subItem)
    pageCtrl:AddAnchor("TOPLEFT", subItem, 0, 0)
    pageCtrl:AddAnchor("BOTTOMRIGHT", subItem, -(15 + offset), 0)
    subItem.pageCtrl = pageCtrl
    function pageCtrl:SetPageData(page)
      local data = widget:GetDataByViewIndex(rowIndex, colIndex)
      if data == nil then
        return
      end
      data.page = page
    end
    function pageCtrl:GetPageData()
      local data = widget:GetDataByViewIndex(rowIndex, colIndex)
      if data == nil then
        return
      end
      return data.page
    end
    local gearScore = subItem:CreateChildWidget("label", "gearScore", 0, true)
    gearScore:SetExtent(offset, FONT_SIZE.MIDDLE)
    local inset = subItem:GetHeight() * rowIndex - subItem:GetHeight() / 2 - 5
    gearScore:AddAnchor("TOP", gradeBg, 0, inset)
    ApplyTextColor(gearScore, FONT_COLOR.GRAY)
  end
  list:InsertColumn("", list.listCtrl:GetWidth(), LCCIT_WINDOW, DataSetFunc, nil, nil, LayoutFunc)
  list:InsertRows(MAX_COUNT.LIST_ROW, false)
  list:DeleteAllDatas()
  for i = 1, list:GetRowCount() do
    local bg = list:CreateNinePartDrawable(TEXTURE_PATH.ITEM_GUIDE, "background")
    bg:SetTextureInfo("list_bg")
    bg:AddAnchor("TOPLEFT", list.listCtrl.items[i], -5, 0)
    bg:AddAnchor("BOTTOMRIGHT", list.listCtrl.items[i], 0, 0)
    if i % 2 ~= 0 then
      bg:SetColor(ConvertColor(237), ConvertColor(230), ConvertColor(212), 1)
    else
      bg:SetColor(ConvertColor(224), ConvertColor(213), ConvertColor(193), 1)
    end
  end
  local selectedImg = list:CreateNinePartDrawable(TEXTURE_PATH.ITEM_GUIDE, "overlay")
  selectedImg:SetVisible(false)
  selectedImg:SetTextureInfo("btn_selected")
  list.selectedImgInfo = nil
  function list:VisibleSelectedImg()
    return selectedImg:IsVisible()
  end
  function list:AnchorSelectedImg(target)
    selectedImg:RemoveAllAnchors()
    if target == nil then
      return
    end
    selectedImg:AddAnchor("TOPLEFT", target, -7, -7)
    selectedImg:AddAnchor("BOTTOMRIGHT", target.nameLabel, 7, 10)
  end
  function list:GetSelctedImgInfo()
    return self.selectedImgInfo
  end
  function list:ResetSelectedImg()
    selectedImg:SetVisible(false)
    self.selectedImgInfo = nil
  end
  function list:SetSelectedImg(itemGuideType, pageIndex, viewIndex, target)
    selectedImg:SetVisible(false)
    if target == nil then
      return
    end
    selectedImg:SetVisible(true)
    self:AnchorSelectedImg(target)
    local selectedImgInfo = {
      itemGuideType = itemGuideType,
      pageIndex = pageIndex,
      viewIndex = viewIndex,
      target = target
    }
    list.selectedImgInfo = selectedImgInfo
  end
  function list:UpdatePageSelctedImg(pageCtrl)
    local selectedImgInfo = self.selectedImgInfo
    if selectedImgInfo == nil then
      return
    end
    if selectedImgInfo.target == nil then
      return
    end
    selectedImg:SetVisible(false)
    selectedImg:RemoveAllAnchors()
    local datas = pageCtrl:GetData()
    for i = 1, #datas do
      local data = datas[i]
      if data ~= nil and selectedImgInfo.itemGuideType == data.itemGuideType and datas.page == selectedImgInfo.pageIndex then
        selectedImg:Show(true)
        self:AnchorSelectedImg(pageCtrl.items[selectedImgInfo.viewIndex])
      end
    end
  end
  function list:UpdateScrollSelctedImg()
    local selectedImgInfo = self.selectedImgInfo
    if selectedImgInfo == nil then
      return
    end
    if selectedImgInfo.target == nil then
      return
    end
    selectedImg:SetVisible(false)
    selectedImg:RemoveAllAnchors()
    for i = 1, list:GetRowCount() do
      local datas = list:GetDataByViewIndex(i, 1)
      if datas ~= nil then
        for j = 1, #datas do
          local data = datas[j]
          if data ~= nil and selectedImgInfo.itemGuideType == data.itemGuideType then
            local subItem = list:GetListCtrlSubItem(i, 1)
            if subItem ~= nil and datas.page == selectedImgInfo.pageIndex then
              selectedImg:Show(true)
              self:AnchorSelectedImg(subItem.pageCtrl.items[selectedImgInfo.viewIndex])
            end
          end
        end
      end
    end
  end
  local equippedIcon = tab:CreateChildWidget("emptywidget", "equippedIcon", 0, true)
  equippedIcon:Show(false)
  local bg = equippedIcon:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "equip_bar", "background")
  bg:AddAnchor("CENTER", equippedIcon, 0, 0)
  equippedIcon:SetExtent(bg:GetExtent())
  function equippedIcon:SetEnableEquipIcon(able)
    if able then
      bg:SetTextureInfo("equip_bar")
    else
      bg:SetTextureInfo("equip_dim")
    end
  end
  local arrow = equippedIcon:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "equip_arrow", "background")
  arrow:SetVisible(false)
  arrow:AddAnchor("TOP", bg, "BOTTOM", 0, 0)
  equippedIcon.arrow = arrow
  local arrow2 = equippedIcon:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "equip_arrow", "background")
  arrow:SetVisible(false)
  arrow:AddAnchor("TOP", bg, "BOTTOM", 0, 0)
  equippedIcon.arrow2 = arrow2
  function equippedIcon:Init()
    self:RemoveAllAnchors()
    self:Show(false)
    self.arrow:RemoveAllAnchors()
    self.arrow:SetVisible(false)
    self.arrow2:RemoveAllAnchors()
    self.arrow2:SetVisible(false)
  end
  function equippedIcon:SetArrow(isUpper, double)
    self.arrow:SetVisible(true)
    self.arrow2:SetVisible(double)
    if isUpper then
      self.arrow:SetTextureInfo("equip_arrow_reverse")
      self.arrow2:SetTextureInfo("equip_arrow_reverse")
      if double then
        self.arrow2:AddAnchor("BOTTOM", self.arrow, "TOP", 0, 7)
      end
      self.arrow:AddAnchor("BOTTOM", self, "TOP", 0, 3)
    else
      self.arrow:SetTextureInfo("equip_arrow")
      self.arrow2:SetTextureInfo("equip_arrow")
      if double then
        self.arrow2:AddAnchor("TOP", self.arrow, "BOTTOM", 0, -7)
      end
      self.arrow:AddAnchor("TOP", self, "BOTTOM", 0, -3)
    end
    if double then
      return self.arrow:GetHeight() * 2 - 7
    else
      return self.arrow:GetHeight()
    end
  end
  return tab
end
local function CreateItemListWnd(id, parent, commonHeight)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetExtent(215, commonHeight)
  local offset = 12
  local contentWidth = wnd:GetWidth() - (MARGIN.WINDOW_SIDE + 3)
  local resetBtn = wnd:CreateChildWidget("button", "resetBtn", 0, true)
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.RESET)
  resetBtn:Enable(false)
  local slotTypeLabel = wnd:CreateChildWidget("label", "slotTypeLabel", 0, true)
  slotTypeLabel:AddAnchor("TOPLEFT", wnd, offset, offset)
  slotTypeLabel:SetExtent(contentWidth - resetBtn:GetWidth(), FONT_SIZE.MIDDLE)
  slotTypeLabel.style:SetEllipsis(true)
  slotTypeLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(slotTypeLabel, FONT_COLOR.MIDDLE_TITLE)
  local lootCategoryLabel = wnd:CreateChildWidget("label", "lootCategoryLabel", 0, true)
  lootCategoryLabel:AddAnchor("TOPLEFT", slotTypeLabel, "BOTTOMLEFT", 0, 5)
  lootCategoryLabel:SetExtent(contentWidth - resetBtn:GetWidth(), FONT_SIZE.MIDDLE)
  lootCategoryLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  lootCategoryLabel.style:SetEllipsis(true)
  lootCategoryLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(lootCategoryLabel, FONT_COLOR.BROWN)
  local itemGuideNameLabel = wnd:CreateChildWidget("label", "itemGuideNameLabel", 0, true)
  itemGuideNameLabel:AddAnchor("TOPLEFT", lootCategoryLabel, "BOTTOMLEFT", FONT_SIZE.MIDDLE, 5)
  itemGuideNameLabel:SetExtent(lootCategoryLabel:GetWidth() - FONT_SIZE.MIDDLE, FONT_SIZE.MIDDLE)
  itemGuideNameLabel.style:SetEllipsis(true)
  itemGuideNameLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  itemGuideNameLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(itemGuideNameLabel, FONT_COLOR.BROWN)
  local changeIcon = wnd:CreateChildWidget("emptywidget", "changeIcon", 0, true)
  changeIcon:Show(false)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "housing_change_icon_tooltip"), self)
  end
  changeIcon:SetHandler("OnEnter", OnEnter)
  local drawable = changeIcon:CreateDrawable(TEXTURE_PATH.ITEM_GUIDE, "icon_house", "background")
  drawable:AddAnchor("CENTER", changeIcon, 0, 0)
  changeIcon:SetExtent(drawable:GetExtent())
  changeIcon:AddAnchor("BOTTOMRIGHT", resetBtn, "TOPRIGHT", 3, -2)
  local _, yOffset = F_LAYOUT.GetExtentWidgets(slotTypeLabel, itemGuideNameLabel)
  local itemList = W_CTRL.CreateScrollListCtrl("itemList", wnd)
  itemList:AddAnchor("TOPLEFT", slotTypeLabel, "BOTTOMLEFT", 0, yOffset - 6)
  itemList:SetExtent(contentWidth, 540)
  itemList.scroll:RemoveAllAnchors()
  itemList.scroll:AddAnchor("TOPRIGHT", itemList, 0, 0)
  itemList.scroll:AddAnchor("BOTTOMRIGHT", itemList, 0, 0)
  itemList.listCtrl:SetColumnHeight(0)
  itemList.listCtrl:UseOverClickTexture()
  resetBtn:AddAnchor("BOTTOMRIGHT", itemList, "TOPRIGHT", 3, -5)
  local bg = CreateContentBackground(wnd, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", slotTypeLabel, -offset, -offset)
  bg:AddAnchor("RIGHT", wnd, 0, 0)
  bg:AddAnchor("BOTTOM", itemList, 0, MARGIN.WINDOW_SIDE / 2)
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      local itemInfo = X2Item:GetItemInfoByType(data.itemType, data.itemGrade)
      subItem.itemButton:SetItemInfo(itemInfo)
      subItem.itemButton:Show(true)
      local itemNameStr = X2Util:UTF8StringLimit(itemInfo.name, 26, "..")
      ApplyTextColor(subItem.itemName, Hex2Dec(itemInfo.gradeColor))
      subItem.itemName:SetText(itemNameStr)
      subItem.itemName:Show(true)
    else
      subItem.itemName:Show(false)
      subItem.itemButton:Show(false)
    end
  end
  local LayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local itemButton = CreateItemIconButton("itemButton", subItem)
    itemButton:AddAnchor("LEFT", subItem, 1, 0)
    itemButton:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    local itemName = subItem:CreateChildWidget("textbox", "itemName", 0, true)
    itemName:AddAnchor("TOPLEFT", subItem, itemButton:GetWidth() + 5, 0)
    itemName:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
    itemName:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    itemName.style:SetAlign(ALIGN_LEFT)
    itemName.style:SetEllipsis(true)
    itemName.style:SetFontSize(FONT_SIZE.MIDDLE)
  end
  itemList:InsertColumn("", itemList.listCtrl:GetWidth(), LCCIT_WINDOW, DataSetFunc, nil, nil, LayoutSetFunc)
  itemList:InsertRows(MAX_COUNT.ITEM_LIST, false)
  itemList:DeleteAllDatas()
  local emptyLabel = wnd:CreateChildWidget("textbox", "emptyLabel", 0, true)
  emptyLabel:Show(false)
  emptyLabel:SetExtent(165, FONT_SIZE.LARGE)
  ApplyTextColor(emptyLabel, FONT_COLOR.MEDIUM_BROWN)
  emptyLabel:SetText(GetUIText(COMMON_TEXT, "equip_item_guide_list_empty"))
  emptyLabel:SetAutoResize(true)
  emptyLabel:AddAnchor("CENTER", itemList.listCtrl, 2, 0)
  function wnd:SetEmptyList(empty)
    self.emptyLabel:Show(empty)
  end
  local wayToLootWnd = wnd:CreateChildWidget("emptywidget", "wayToLootWnd", 0, true)
  wayToLootWnd:SetExtent(wnd:GetWidth(), 50)
  wayToLootWnd:AddAnchor("BOTTOMLEFT", wnd, 0, 0)
  local bg = CreateContentBackground(wayToLootWnd, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", wayToLootWnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wayToLootWnd, 0, 0)
  local width = 125
  local label = wayToLootWnd:CreateChildWidget("label", "label", 0, true)
  label:Show(false)
  label:AddAnchor("TOPLEFT", wayToLootWnd, offset, 11)
  label:SetText(GetUIText(COMMON_TEXT, "way_to_loot"))
  label.style:SetEllipsis(true)
  label:SetExtent(width, FONT_SIZE.MIDDLE)
  label.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(label, FONT_COLOR.MIDDLE_TITLE)
  local wayLabel = wayToLootWnd:CreateChildWidget("label", "wayLabel", 0, true)
  wayLabel:AddAnchor("BOTTOMLEFT", wayToLootWnd, offset, -12)
  wayLabel.style:SetEllipsis(true)
  wayLabel:SetExtent(width, FONT_SIZE.MIDDLE)
  wayLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(wayLabel, FONT_COLOR.DEFAULT)
  local OnEnter = function(self)
    if self.tooltip == nil then
      return
    end
    if self.style:GetTextWidth(self.tooltip) < self:GetWidth() then
      return
    end
    SetTooltip(self.tooltip, self)
  end
  wayLabel:SetHandler("OnEnter", OnEnter)
  local button = wayToLootWnd:CreateChildWidget("button", "button", 0, true)
  button:Show(false)
  button:AddAnchor("RIGHT", wayToLootWnd, -offset, 0)
  ApplyButtonSkin(button, BUTTON_BASIC.EQUIP_ITEM_GUIDE_CRAFT)
  function wayToLootWnd:Init()
    label:Show(false)
    wayLabel:Show(false)
    button:Show(false)
  end
  return wnd
end
function SetViewOfItemGuideWnd(id, parent)
  local wnd = CreateWindow(id, parent, "item_guide")
  wnd:SetTitle(GetUIText(COMMON_TEXT, "equip_item_guide"))
  wnd:SetExtent(900, 790)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  local tab = W_BTN.CreateTab("tab", wnd)
  tab:SetExtent(wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2, wnd:GetHeight() - MARGIN.WINDOW_TITLE - MARGIN.WINDOW_SIDE)
  tab:AddAnchor("TOPLEFT", wnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  tab:AddTabs(ITEM_GUIDE.GetImplTabTexts())
  wnd.tab = tab
  local offset = MARGIN.WINDOW_TITLE + tab.selectedButton[1]:GetHeight() + MARGIN.WINDOW_SIDE
  local commonHeight = wnd:GetHeight() - offset - MARGIN.WINDOW_SIDE
  local categoryWnd = CreateCategoryWnd("categoryWnd", wnd, commonHeight)
  categoryWnd:AddAnchor("TOPLEFT", wnd, 15, offset)
  local gradeLabel = wnd:CreateChildWidget("label", "gradeLabel", 0, false)
  gradeLabel:SetExtent(130, FONT_SIZE.MIDDLE)
  gradeLabel:SetText(GetUIText(COMMON_TEXT, "item_grade"))
  gradeLabel:AddAnchor("TOPLEFT", categoryWnd, "TOPRIGHT", MARGIN.WINDOW_SIDE / 1.5, 0)
  ApplyTextColor(gradeLabel, FONT_COLOR.DEFAULT)
  local gradeCombobox = W_ETC.CreateGradeCombobox("gradeCombobox", wnd)
  gradeCombobox:SetWidth(320)
  gradeCombobox:AddAnchor("LEFT", gradeLabel, "RIGHT", 0, 0)
  gradeCombobox:Select(1)
  local descWnd = CreateDescWnd("descWnd", wnd, commonHeight - 30)
  descWnd:AddAnchor("TOPLEFT", gradeLabel, "BOTTOMLEFT", 0, 15)
  local itemWnd = CreateItemListWnd("itemListWnd", wnd, commonHeight)
  itemWnd:AddAnchor("TOPLEFT", gradeCombobox, "TOPRIGHT", 5, -2)
  wnd.itemWnd = itemWnd
  local referenceWnd = CreateReferenceWnd("referenceWnd", wnd)
  referenceWnd:AddAnchor("BOTTOMLEFT", descWnd, 0, 0)
  return wnd
end
