local itemGuideWnd
local CreateItemGuideWnd = function(id, parent)
  local wnd = SetViewOfItemGuideWnd(id, parent)
  local tab = wnd.tab
  local categoryWnd = wnd.categoryWnd
  local descWnd = wnd.descWnd
  local itemWnd = wnd.itemWnd
  local equippedIcon = descWnd.equippedIcon
  local gradeCombobox = wnd.gradeCombobox
  local resetBtn = itemWnd.resetBtn
  local sortCombobox = descWnd.sortCombobox
  local referenceWnd = wnd.referenceWnd
  local selElementInfo, equippedItems
  local matchSlots = {
    {
      EST_MAINHAND,
      EST_OFFHAND,
      EST_1HANDED
    },
    {EST_2HANDED},
    {EST_RANGED},
    {EST_SHIELD},
    {EST_INSTRUMENT},
    {EST_HEAD},
    {EST_CHEST},
    {EST_WAIST},
    {EST_ARMS},
    {EST_HANDS},
    {EST_LEGS},
    {EST_FEET},
    {EST_BACK},
    {EST_EAR},
    {EST_NECK},
    {EST_FINGER}
  }
  local function MacthEquipItem(slotTypeNum)
    local _, bCategory = ITEM_GUIDE.GetCategory(tab:GetSelectedTab(), categoryWnd:GetSelectedValue())
    for i, v in pairs(matchSlots[bCategory]) do
      if v == slotTypeNum then
        return true
      end
    end
    return false
  end
  local function UpateEquippedItems()
    equippedItems = {}
    for i = 1, #PLAYER_EQUIP_SLOTS do
      equippedItems[PLAYER_EQUIP_SLOTS[i]] = X2Equipment:GetEquippedItemTooltipText("player", PLAYER_EQUIP_SLOTS[i])
    end
  end
  local function FillDescWnd(infos)
    itemWnd.itemList:Init()
    descWnd.list:DeleteAllDatas()
    if infos == nil or #infos == 0 then
      return
    end
    for i = 1, #infos do
      descWnd.list:InsertData(i, 1, infos[i])
    end
  end
  function GetItemGuideSelectedGrade()
    local grade = gradeCombobox:GetSelectedIndex()
    if grade == 1 then
      grade = 0
    end
    return grade
  end
  local SORT = {ASCENDING = 1, DESCENDING = 2}
  local function GetAscendingSort()
    return sortCombobox:GetSelectedIndex() == SORT.ASCENDING
  end
  local function UpdateDescWnd()
    selElementInfo = nil
    local aCategory, bCategory = ITEM_GUIDE.GetCategory(tab:GetSelectedTab(), categoryWnd:GetSelectedValue())
    local info = X2ItemGuide:GetCategoryInfos(aCategory, bCategory, GetLootCategoriesByTabIndex(descWnd:GetSelectedTab()), GetItemGuideSelectedGrade(), GetAscendingSort())
    FillDescWnd(info)
    equippedIcon:Update()
  end
  function descWnd.list:OnSliderChangedProc()
    equippedIcon:Update()
    if selElementInfo ~= nil then
      descWnd.list:UpdateScrollSelctedImg()
    end
  end
  local function SelcteClear()
    descWnd.list:ResetSelectedImg()
    resetBtn:Enable(false)
  end
  function categoryWnd:OnSelChanged()
    UpdateDescWnd()
    SelcteClear()
  end
  function descWnd:OnTabChangedProc(selIdx)
    UpdateDescWnd()
    if referenceWnd:IsVisible() then
      referenceWnd:ShowOrderInfo(selIdx < 4)
    end
    SelcteClear()
  end
  function gradeCombobox:SelectedProc()
    local tempSelElementInfo = selElementInfo
    local topDataIndex = descWnd.list:GetTopDataIndex()
    UpdateDescWnd()
    if tempSelElementInfo ~= nil then
      descWnd.list:SetTopDataIndex(topDataIndex)
      descWnd.list:UpdateView()
      descWnd.list.scroll.vs:SetValue(topDataIndex - 1, false)
      FillDescWndElementClickProc(tempSelElementInfo)
      descWnd.list:UpdateScrollSelctedImg()
      equippedIcon:Update()
    end
  end
  local function ResetBtnLeftClickFunc(self)
    descWnd.list:SetTopDataIndex(1)
    descWnd.list:UpdateView()
    descWnd.list.scroll.vs:SetValue(0, false)
    itemWnd.itemList:Init()
    SelcteClear()
  end
  ButtonOnClickHandler(resetBtn, ResetBtnLeftClickFunc)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "equip_item_guide_reset"), self)
  end
  resetBtn:SetHandler("OnEnter", OnEnter)
  function sortCombobox:SelectedProc()
    UpdateDescWnd()
    SelcteClear()
    descWnd.list:SetGradeBg(GetAscendingSort())
  end
  function FillDescWndElementClickProc(elementInfo)
    selElementInfo = elementInfo
    local aCategory, bCategory = ITEM_GUIDE.GetCategory(tab:GetSelectedTab(), categoryWnd:GetSelectedValue())
    local items = X2ItemGuide:GetSpecifiedItems(aCategory, bCategory, selElementInfo.itemGuideType, GetItemGuideSelectedGrade())
    itemWnd:FillItemWnd(categoryWnd:GetSelectedText(), selElementInfo.lootMainCategory, selElementInfo.name, items)
  end
  local OnEnter = function(self)
    if self.tooltip == nil then
      return
    end
    SetTooltip(self.tooltip, self)
  end
  equippedIcon:SetHandler("OnEnter", OnEnter)
  function equippedIcon:DisableByCannotCompared(targetStr)
    equippedIcon:SetEnableEquipIcon(false)
    equippedIcon:AddAnchor("TOPRIGHT", descWnd.list, -36, 0)
    targetStr = SetEnterString(targetStr, GetUIText(COMMON_TEXT, "item_can_not_be_compared_grade_not_exist"))
    return targetStr
  end
  function equippedIcon:Update()
    equippedIcon:Init()
    if not ITEM_GUIDE.IsItemImpl(tab:GetSelectedTab()) then
      return
    end
    local dataCount = descWnd.list:GetDataCount()
    if dataCount <= 0 then
      return
    end
    if equippedItems == nil then
      UpateEquippedItems()
    end
    local found = false
    for k = 1, table.maxn(equippedItems) do
      if equippedItems[k] ~= nil and equippedItems[k].slotTypeNum ~= nil then
        local selSlotTypeNum = equippedItems[k].slotTypeNum
        if MacthEquipItem(selSlotTypeNum) then
          curScore = equippedItems[k].gearScore.bare
          equippedIcon.tooltip = string.format([[
%s: |c%s%s (%s)|r
%s: %s]], GetUIText(COMMON_TEXT, "equip_item_guide_equipped"), equippedItems[k].gradeColor, equippedItems[k].name, equippedItems[k].grade, GetUIText(COMMON_TEXT, "equip_item_guide_equipped_gear_score"), curScore)
          found = true
          break
        end
      end
    end
    if not found then
      return
    end
    equippedIcon:Show(true)
    local firstData, latterData, firstViewData, latterViewData
    local rowCount = descWnd.list:GetRowCount()
    local ValidData = function(data)
      return data ~= nil and data.gearScore ~= nil
    end
    for i = 1, dataCount do
      local curData = descWnd.list:GetDataByDataIndex(i, 1)
      if not ValidData(firstData) and ValidData(curData) then
        firstData = curData
      end
      local topDataIndex = descWnd.list:GetTopDataIndex()
      if i >= topDataIndex and i < topDataIndex + rowCount then
        if not ValidData(firstViewData) and ValidData(curData) then
          firstViewData = curData
        end
        if ValidData(curData) then
          latterViewData = curData
        end
      end
      if ValidData(curData) then
        latterData = curData
      end
    end
    if not ValidData(firstData) and not ValidData(latterData) then
      equippedIcon.tooltip = self:DisableByCannotCompared(equippedIcon.tooltip)
      return
    end
    equippedIcon:SetEnableEquipIcon(true)
    local xOffset = -36
    local yOffset = 4
    local isAscendingSort = GetAscendingSort()
    local firstGearScore = tonumber(firstData.gearScore) or 0
    local latterGearScore = tonumber(latterData.gearScore) or 0
    local firstViewGearScore = firstViewData and tonumber(firstViewData.gearScore) or 0
    local latterViewGearScore = latterViewData and tonumber(latterViewData.gearScore) or 0
    local function ValidMinMax(isFirstData)
      local firstScore = firstViewGearScore > 0 and firstViewGearScore or firstGearScore
      local latterScore = latterViewGearScore > 0 and latterViewGearScore or latterGearScore
      if isAscendingSort then
        return isFirstData and firstScore > curScore or latterScore < curScore
      else
        return isFirstData and latterScore < curScore or firstScore > curScore
      end
    end
    local function DoubleArrow(isFirstData)
      local firstScore = firstViewGearScore > 0 and firstViewGearScore or firstGearScore
      local latterScore = latterViewGearScore > 0 and latterViewGearScore or latterGearScore
      local topDataIndex = descWnd.list:GetTopDataIndex()
      if isAscendingSort then
        if isFirstData then
          return firstScore > curScore and topDataIndex <= 1
        else
          return latterScore < curScore and topDataIndex > dataCount - rowCount
        end
      elseif isFirstData then
        return firstScore < curScore and topDataIndex <= 1
      else
        return latterScore > curScore and topDataIndex > dataCount - rowCount
      end
    end
    if ValidData(latterData) and ValidMinMax(false) then
      local arrowOffset = equippedIcon:SetArrow(false, DoubleArrow(false))
      equippedIcon:AddAnchor("BOTTOMRIGHT", descWnd.list, xOffset, -(arrowOffset - yOffset))
      return
    elseif ValidData(firstData) and ValidMinMax(true) then
      local arrowOffset = equippedIcon:SetArrow(true, DoubleArrow(true))
      equippedIcon:AddAnchor("TOPRIGHT", descWnd.list, xOffset, arrowOffset - yOffset)
      return
    end
    for i = 1, rowCount do
      local curSubItem = descWnd.list:GetListCtrlSubItem(i, 1)
      local curData = descWnd.list:GetDataByViewIndex(i, 1)
      local score = tonumber(curData.gearScore)
      if score ~= nil then
        local xOffset = 25
        if curScore == score then
          equippedIcon:AddAnchor("RIGHT", curSubItem.gearScore, "LEFT", xOffset, 0)
          return
        elseif isAscendingSort and score > curScore or not isAscendingSort and score < curScore then
          local startWidget, endWidget
          local prevIndex = 1
          local prevSubItem = descWnd.list:GetListCtrlSubItem(i - prevIndex, 1)
          local prevData = descWnd.list:GetDataByViewIndex(i - prevIndex, 1)
          while prevData == nil or prevData.gearScore == nil do
            prevIndex = prevIndex + 1
            if i - prevIndex <= 0 then
              return
            end
            prevData = descWnd.list:GetDataByViewIndex(i - prevIndex, 1)
            prevSubItem = descWnd.list:GetListCtrlSubItem(i - prevIndex, 1)
          end
          startWidget = prevSubItem.gearScore
          endWidget = curSubItem.gearScore
          local sx, sy = startWidget:GetOffset()
          local ex, ey = endWidget:GetOffset()
          offset = (score - curScore) / (score - prevData.gearScore) * (ey - sy)
          equippedIcon:AddAnchor("RIGHT", endWidget, "LEFT", xOffset, -offset)
          return
        end
      end
    end
  end
  function itemWnd:FillItemWnd(slotTypeStr, lootMainCategory, itemGuideName, items)
    self.slotTypeLabel:Show(true)
    self.slotTypeLabel:SetText(slotTypeStr)
    self.lootCategoryLabel:Show(true)
    self.lootCategoryLabel:SetText(string.format("\226\148\148 %s", GetLootCategoryStr(lootMainCategory)))
    self.itemGuideNameLabel:Show(true)
    self.itemGuideNameLabel:SetText(string.format("\226\148\148 %s", itemGuideName))
    self.itemList:DeleteAllDatas()
    resetBtn:Enable(true)
    self:SetEmptyList(#items == 0)
    for i = 1, #items do
      self.itemList:InsertData(i, 1, items[i])
    end
  end
  local function ButtonLeftClickFunc(self)
    local selDataIdx = itemWnd.itemList:GetSelectedDataIndex()
    if selDataIdx == 0 then
      return
    end
    local data = itemWnd.itemList:GetSelectedData(1)
    if self.viewType == "smelting" then
      EnterEnchantItemMode("smelting")
    elseif self.viewType == "craft" then
      ExternalCraftSearch(data.itemType)
    elseif self.viewType == "map" then
      local portalInfo = self.portalInfo
      worldmap:ToggleMapWithPortal(portalInfo.portal_zone_id, portalInfo.x, portalInfo.y, portalInfo.z)
    end
  end
  ButtonOnClickHandler(itemWnd.wayToLootWnd.button, ButtonLeftClickFunc)
  local wayToLootWnd = itemWnd.wayToLootWnd
  local function FillWayToLootInfo(info, data)
    local label = wayToLootWnd.label
    local wayLabel = wayToLootWnd.wayLabel
    local button = wayToLootWnd.button
    label:Show(true)
    wayLabel:Show(true)
    button:Enable(true)
    wayLabel:SetWidth(125)
    if X2Craft:GetCraftTypeByItemType(data.itemType) ~= nil then
      button:Show(true)
      ChangeButtonSkin(button, BUTTON_BASIC.EQUIP_ITEM_GUIDE_CRAFT)
      wayLabel:SetText(GetUIText(AUCTION_TEXT, "item_category_recipe"))
      button.viewType = "craft"
    elseif info.zoneId ~= 0 then
      button:Show(true)
      ChangeButtonSkin(button, BUTTON_BASIC.EQUIP_ITEM_GUIDE_MAP)
      wayLabel:SetText(GetUIText(COMMON_TEXT, "portal_indun"))
      if selElementInfo == nil then
        button:Enable(false)
        return
      end
      local portalInfo = X2ItemGuide:GetIndunPortalInfo(selElementInfo.zoneId)
      if portalInfo == nil then
        button:Enable(false)
        return
      else
        button.portalInfo = portalInfo
      end
      button.viewType = "map"
    else
      button:Show(false)
      wayLabel:SetWidth(190)
      wayLabel:SetText(info.wayToLoot)
      wayLabel.tooltip = info.wayToLoot
    end
  end
  function itemWnd.itemList:Init()
    self:DeleteAllDatas()
    itemWnd.slotTypeLabel:Show(false)
    itemWnd.lootCategoryLabel:Show(false)
    itemWnd.itemGuideNameLabel:Show(false)
    itemWnd.emptyLabel:Show(false)
    wayToLootWnd:Init()
  end
  function itemWnd.itemList:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    wayToLootWnd:Init()
    if selDataIdx == 0 then
      return
    end
    local data = itemWnd.itemList:GetDataByViewIndex(selDataViewIdx, 1)
    FillWayToLootInfo(selElementInfo, data)
  end
  function tab:OnTabChangedProc(selected)
    categoryWnd:SetItemTrees(ITEM_GUIDE.GetCategories(selected))
    descWnd:SelectTab(1)
    descWnd:SetTabVisible(selected)
    gradeCombobox:Select(1)
    UpdateDescWnd()
    referenceWnd:Show(selected == 1)
  end
  tab:OnTabChangedProc(1)
  local events = {
    UNIT_EQUIPMENT_CHANGED = function()
      UpateEquippedItems()
      equippedIcon:Update()
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
function ToggleItemGuide(show)
  if not X2Player:GetFeatureSet().itemGuide then
    return
  end
  if itemGuideWnd == nil then
    itemGuideWnd = CreateItemGuideWnd("itemGuideWnd", "UIParent")
  end
  local isShow = show
  if isShow == nil then
    isShow = not itemGuideWnd:IsVisible()
  end
  itemGuideWnd:Show(isShow)
end
ADDON:RegisterContentTriggerFunc(UIC_ITEM_GUIDE, ToggleItemGuide)
