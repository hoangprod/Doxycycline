local MAX_SLOT_VIEW_COUNT = 10
local MAX_SCROLL_SLOT_VIEW_COUNT = 20
local function SetViewOfGachaWindow(id, parent)
  local window = CreateWindow(id, parent, "loot_gacha")
  window:SetExtent(430, 350 + 40 * MAX_SLOT_VIEW_COUNT)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "loot_gacha"))
  local deco = window:CreateDrawable(TEXTURE_PATH.LOOT_GACHA, "line_effect", "artwork")
  deco:AddAnchor("TOP", window.titleBar, "BOTTOM", 32, MARGIN.WINDOW_SIDE / 1.5)
  local slotSourceItem = CreateItemIconButton("slotSourceItem", window)
  slotSourceItem:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
  slotSourceItem:AddAnchor("CENTER", deco, "LEFT", 5, 0)
  slotSourceItem.back:SetVisible(false)
  slotSourceItem:RegisterForClicks("RightButton")
  window.slotSourceItem = slotSourceItem
  local bg = window:CreateDrawable(TEXTURE_PATH.LOOT_GACHA, "iconframe_brown", "artwork")
  bg:AddAnchor("CENTER", slotSourceItem, -9, -5)
  local nameWidth = 190
  local sourceName = window:CreateChildWidget("textbox", "sourceName", 0, false)
  sourceName:SetExtent(nameWidth, FONT_SIZE.LARGE)
  sourceName:SetAutoResize(true)
  sourceName.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
  sourceName:SetText(GetUIText(COMMON_TEXT, "box_item"))
  sourceName:AddAnchor("TOP", slotSourceItem, "BOTTOM", 0, 7)
  ApplyTextColor(sourceName, FONT_COLOR.HIGH_TITLE)
  local slotConsumeItem = CreateItemIconButton("slotConsumeItem", window)
  slotConsumeItem:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
  slotConsumeItem:AddAnchor("LEFT", deco, "RIGHT", -95, 0)
  slotConsumeItem.back:SetVisible(false)
  slotConsumeItem:RegisterForClicks("RightButton")
  window.slotConsumeItem = slotConsumeItem
  local bg = window:CreateDrawable(TEXTURE_PATH.LOOT_GACHA, "iconframe_blue", "artwork")
  bg:AddAnchor("CENTER", slotConsumeItem, -9, -5)
  local consumeName = window:CreateChildWidget("textbox", "consumeName", 0, false)
  consumeName:SetExtent(nameWidth, FONT_SIZE.LARGE)
  consumeName:SetAutoResize(true)
  consumeName.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
  consumeName:SetText(GetUIText(AUCTION_TEXT, "item_category_key"))
  consumeName:AddAnchor("TOP", slotConsumeItem, "BOTTOM", 0, 7)
  ApplyTextColor(consumeName, {
    ConvertColor(35),
    ConvertColor(62),
    ConvertColor(105),
    1
  })
  local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, consumeName)
  local bg = CreateContentBackground(window, "TYPE10", "brown", "artwork")
  bg:SetExtent(406, 40 * MAX_SLOT_VIEW_COUNT + 60)
  bg:AddAnchor("TOP", window, 0, height + 20)
  local lootItemLabel = window:CreateChildWidget("label", "lootItemLabel", 0, false)
  lootItemLabel:SetExtent(20, 30)
  lootItemLabel:SetAutoResize(true)
  lootItemLabel:SetText(GetUIText(COMMON_TEXT, "loot_item"))
  lootItemLabel:AddAnchor("TOP", bg, 0, 5)
  lootItemLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(lootItemLabel, FONT_COLOR.MIDDLE_TITLE)
  local line = CreateLine(lootItemLabel, "TYPE1")
  line:SetWidth(bg:GetWidth())
  line:AddAnchor("TOP", lootItemLabel, "BOTTOM", 0, 0)
  local resultList = CreateScrollWindow(window, "resultList", 0)
  resultList:SetExtent(380, 40 * MAX_SLOT_VIEW_COUNT)
  resultList:AddAnchor("TOP", lootItemLabel, "BOTTOM", 0, 10)
  resultList:SetMinMaxValues(0, 40 * math.max(MAX_SCROLL_SLOT_VIEW_COUNT - MAX_SLOT_VIEW_COUNT, 0))
  resultList:Lock(true)
  resultList:ResetScroll(0)
  window.resultList = resultList
  local CreateResultItem = function(itemList, idx)
    local item = itemList:CreateChildWidget("emptywidget", "item", idx, true)
    item:SetExtent(itemList:GetWidth(), 40)
    item.idx = idx
    local itemIcon = CreateItemIconButton("itemIcon", item)
    itemIcon:AddAnchor("TOPLEFT", item, 0, 0)
    itemIcon:SetExtent(ICON_SIZE.AUCTION, ICON_SIZE.AUCTION)
    item.itemIcon = itemIcon
    local textbox = item:CreateChildWidget("textbox", "textbox", 0, true)
    textbox:AddAnchor("TOPLEFT", itemIcon, "TOPRIGHT", 5, 0)
    textbox:AddAnchor("BOTTOMRIGHT", item, 0, -5)
    textbox.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(textbox, FONT_COLOR.DEFAULT)
    function item:InsertData(data)
      self.textbox:Show(true)
      self.itemIcon:SetItemInfo(data)
      self.itemIcon:SetStack(data.stackSize)
      ApplyTextColor(self.textbox, Hex2Dec(data.gradeColor))
      self.textbox:SetText(data.name)
    end
    return item
  end
  for i = 1, MAX_SCROLL_SLOT_VIEW_COUNT do
    local item = CreateResultItem(resultList.content, i)
    if i == 1 then
      item:AddAnchor("TOPLEFT", resultList.content, 0, 0)
    else
      item:AddAnchor("TOPLEFT", resultList.content.item[i - 1], "BOTTOMLEFT", 0, 0)
    end
  end
  local counting = W_CTRL.CreateLabel("counting", window)
  counting:AddAnchor("TOP", resultList, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  counting:SetExtent(window:GetWidth() - MARGIN.WINDOW_SIDE * 2, 15)
  counting.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(counting, FONT_COLOR.BLUE)
  counting.count = 0
  counting:SetText(GetCommonText("opened_gacha_count", tostring(counting.count)))
  window.counting = counting
  local tip = window:CreateChildWidget("textbox", "tip", 0, false)
  tip:AddAnchor("TOP", counting, "BOTTOM", 0, 12)
  tip:SetExtent(window:GetWidth() - MARGIN.WINDOW_SIDE * 2, 30)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  tip:SetText(GetUIText(COMMON_TEXT, "loot_gacha_tip"))
  tip:SetHeight(tip:GetTextHeight())
  local cancelButton = window:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("TOPRIGHT", tip, "BOTTOMRIGHT", 0, MARGIN.WINDOW_SIDE / 1.5)
  local spinner = W_ETC.CreateSpinner("spinner", window)
  spinner:AddAnchor("TOPLEFT", tip, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 1.5)
  window.spinner = spinner
  local openButton = window:CreateChildWidget("button", "openButton", 0, true)
  openButton:Enable(false)
  openButton:SetText(GetUIText(COMMON_TEXT, "open"))
  ApplyButtonSkin(openButton, BUTTON_BASIC.DEFAULT)
  openButton:AddAnchor("RIGHT", cancelButton, "LEFT", -4, 0)
  local maxSpinButton = window:CreateChildWidget("button", "maxSpinButton", 0, true)
  maxSpinButton:Enable(false)
  maxSpinButton:SetText(GetUIText(CRAFT_TEXT, "maximum"))
  ApplyButtonSkin(maxSpinButton, BUTTON_BASIC.DEFAULT)
  maxSpinButton:AddAnchor("LEFT", spinner, "RIGHT", 4, 0)
  local buttonTable = {openButton, maxSpinButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, window.openButton)
  window:SetHeight(height + MARGIN.WINDOW_SIDE)
  return window
end
local function CreateLootGachaWindow(id, parent)
  local window = SetViewOfGachaWindow(id, parent)
  local resultList = window.resultList
  local resultBody = window.resultList.content
  function resultList:ResetData()
    window.counting.count = 0
    window.counting:SetText(GetCommonText("opened_gacha_count", tostring(window.counting.count)))
    resultList:ResetScroll(0)
    resultList:Lock(true)
    for i = 1, #resultBody.item do
      local item = resultBody.item[i]
      item.itemIcon:SetItemInfo(nil)
      item.textbox:Show(false)
    end
  end
  function resultList:GetEmptyItem()
    for i = 1, #resultBody.item do
      local item = resultBody.item[i]
      local itemInfo = item.itemIcon:GetInfo()
      if itemInfo == nil then
        return item
      end
    end
    for i = 2, #resultBody.item do
      local item = resultBody.item[i]
      local itemInfo = item.itemIcon:GetInfo()
      item = resultBody.item[i - 1]
      item:InsertData(itemInfo)
    end
    return resultBody.item[#resultBody.item]
  end
  function resultList:InsertData(data)
    local item = self:GetEmptyItem()
    item:InsertData(data)
    if item.idx > MAX_SLOT_VIEW_COUNT then
      resultList:ResetScroll(40 * item.idx)
      resultList:Lock(false)
      resultList:SetValue(40 * (item.idx - MAX_SLOT_VIEW_COUNT))
    end
  end
  local function Execute(count)
    resultList:ResetData()
    X2ItemGacha:Execute(count)
  end
  local function OpenButtonLeftClickFunc()
    Execute(window.spinner:GetCurValue())
  end
  ButtonOnClickHandler(window.openButton, OpenButtonLeftClickFunc)
  local function OpenButtonLeftClickFunc()
    if not X2ItemGacha:EnableMaxSpin() then
      return
    end
    window.spinner:SetValue(X2ItemGacha:GetMaxLootCount())
  end
  ButtonOnClickHandler(window.maxSpinButton, OpenButtonLeftClickFunc)
  local CancelButtonLeftClickFunc = function()
    if X2ItemGacha:IsWorkingLoot() then
      X2ItemGacha:StopLooting()
    else
      X2ItemGacha:LeaveLootGachaMode()
    end
  end
  ButtonOnClickHandler(window.cancelButton, CancelButtonLeftClickFunc)
  local SlotSourceItemLeftClickFunc = function(self)
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2ItemGacha:SetSourceItemSlotFromPick()
    end
  end
  local SlotSourceItemRightClickFunc = function(self)
    X2ItemGacha:ClearSourceItemSlot()
  end
  ButtonOnClickHandler(window.slotSourceItem, SlotSourceItemLeftClickFunc, SlotSourceItemRightClickFunc)
  local SlotConsumeItemLeftClickFunc = function(self)
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2ItemGacha:SetConsumeItemSlotFromPick()
    end
  end
  local SlotConsumeItemRightClickFunc = function(self)
    X2ItemGacha:ClearConsumeItemSlot()
  end
  ButtonOnClickHandler(window.slotConsumeItem, SlotConsumeItemLeftClickFunc, SlotConsumeItemRightClickFunc)
  function window.slotSourceItem:Update()
    local itemInfo = X2ItemGacha:GetSourceItemInfo()
    UpdateSlot(self, itemInfo)
    if itemInfo ~= nil then
      self:SetStack(itemInfo.total)
    end
    return itemInfo ~= nil
  end
  function window.slotConsumeItem:Update()
    local itemInfo = X2ItemGacha:GetConsumeItemInfo()
    UpdateSlot(self, itemInfo)
    if itemInfo ~= nil then
      self:SetStack(itemInfo.total)
    end
    return itemInfo ~= nil
  end
  local function SlotAllUpdate(isExcutable, isLock)
    window.openButton:Enable(isExcutable)
    window.spinner:SetEnable(isExcutable)
    local existSourceItem = window.slotSourceItem:Update()
    local existConsumeItem = window.slotConsumeItem:Update()
    window.spinner:SetMinMaxValues(1, math.max(X2ItemGacha:GetMaxLootCount(), 1))
    if not existSourceItem and not existConsumeItem then
      resultList:ResetData()
    end
    window.slotSourceItem:Enable(not isLock)
    window.slotConsumeItem:Enable(not isLock)
    if X2ItemGacha:IsWorkingLoot() then
      local count = math.max(X2ItemGacha:GetLeftBatchCount(), 1)
      window.spinner:SetValue(count)
    elseif not existSourceItem or not existConsumeItem then
      window.spinner:SetValue(1)
    end
    window.maxSpinButton:Enable(X2ItemGacha:EnableMaxSpin() and isExcutable)
  end
  local function IsExistLootPackList(itemType, advanced)
    for i = 1, #window.resultList.item do
      local item = window.resultList.item[i]
      local info = item.itemIcon:GetInfo()
      if info ~= nil and info.itemType == itemType and info.advanced == advanced then
        return true, i
      end
    end
    return false
  end
  local lootLogs = {}
  local function UpdateLootResultByLog(logs, results)
    window.counting.count = window.counting.count + 1
    window.counting:SetText(GetCommonText("opened_gacha_count", tostring(window.counting.count)))
    for i = 1, #logs do
      local item = logs[i]
      for j = 1, #results do
        local result = results[j]
        local resultItemInfo = X2Item:InfoFromLink(result.linkText)
        if item.itemType ~= MONEY_ITEM_TYPE and item.itemType ~= BM_MILEAGE_USABLE_ONE_ITEM_TYPE and item.itemType == resultItemInfo.itemType and item.itemGrade == resultItemInfo.itemGrade then
          resultItemInfo.stackSize = item.stackSize
          window.resultList:InsertData(resultItemInfo)
          break
        end
      end
    end
  end
  local function UpdateLootPackResult(lootPackResults)
    if #lootLogs == 0 and #results == 0 then
      return
    end
    local results = {}
    for i = 1, #lootPackResults do
      local result = lootPackResults[i]
      results[#results + 1] = result
    end
    UpdateLootResultByLog(lootLogs, results)
  end
  local OnHide = function()
    X2ItemGacha:LeaveLootGachaMode()
  end
  window:SetHandler("OnHide", OnHide)
  function window:ShowProc()
    SlotAllUpdate(false)
    window.resultList:ResetData()
    X2ItemGacha:EnterLootGachaMode()
  end
  local events = {
    UPDATE_GACHA_LOOT_MODE = function(isExcutable, isLock)
      SlotAllUpdate(isExcutable, isLock)
    end,
    LEAVE_GACHA_LOOT_MODE = function()
      window:Show(false)
    end,
    GACHA_LOOT_PACK_RESULT = function(results)
      UpdateLootPackResult(results)
    end,
    GACHA_LOOT_PACK_LOG = function(logs)
      lootLogs = logs
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local lootGachaWnd = CreateLootGachaWindow("lootGachaWnd", "UIParent")
ADDON:RegisterContentWidget(UIC_LOOT_GACHA, lootGachaWnd)
function ToggleLootGachaWindow()
  if not X2Player:GetFeatureSet().lootGacha then
    return
  end
  lootGachaWnd:Show(not lootGachaWnd:IsVisible())
end
