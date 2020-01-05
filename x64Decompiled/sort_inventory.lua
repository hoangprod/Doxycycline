local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local tabButton_width = DEFAULT_SIZE.INVENTORY_TAB_BUTTON_WIDTH
local tabButton_height = 30
local divideLine_count = 12
local CreateTabIconSelectButton = function(id, parent, imageIdx)
  local iconBtn = CreateEmptyButton(id, parent)
  iconBtn:RemoveAllAnchors()
  iconBtn.icon = iconBtn:CreateDrawable(TEXTURE_PATH.INVENTORY_DEFAULT, GetTabIconCoords(imageIdx), "background")
  iconBtn.icon:SetExtent(24, 24)
  iconBtn.icon:AddAnchor("CENTER", iconBtn, 0, 0)
  function iconBtn:SetColor(r, g, b, a)
    self.icon:SetColor(r, g, b, a)
  end
  function iconBtn:SetImageIdx(idx)
    if idx > MAX_TAB_ICON_COORDS then
      return
    end
    iconBtn.icon:SetTextureInfo(GetTabIconCoords(idx))
    iconBtn.icon:SetExtent(24, 24)
  end
  return iconBtn
end
local CreateTabIconUnselectButton = function(id, parent, imageIdx)
  local iconBtn = CreateEmptyButton(id, parent)
  iconBtn:RemoveAllAnchors()
  iconBtn.icon = iconBtn:CreateDrawable(TEXTURE_PATH.INVENTORY_DEFAULT, GetTabIconCoords(imageIdx), "background")
  iconBtn.icon:AddAnchor("CENTER", iconBtn, 0, 0)
  iconBtn.icon:SetExtent(24, 24)
  function iconBtn:SetColor(r, g, b, a)
    self.icon:SetColor(r, g, b, a)
  end
  function iconBtn:SetImageIdx(idx)
    if idx > MAX_TAB_ICON_COORDS then
      return
    end
    iconBtn.icon:SetTextureInfo(GetTabIconCoords(idx))
    iconBtn.icon:SetExtent(24, 24)
  end
  return iconBtn
end
local AddBtnStateOverlay = function(parent)
  local stateBg = parent:CreateDrawable(TEXTURE_PATH.DEFAULT, "btn_state_ov", "overlay")
  stateBg:AddAnchor("TOPLEFT", parent, 0, 0)
  stateBg:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  stateBg:SetVisible(true)
  local newIcon = parent:CreateDrawable(TEXTURE_PATH.INVENTORY_DEFAULT, "icon_new", "overlay")
  newIcon:SetVisible(false)
  newIcon:AddAnchor("TOPLEFT", parent, -2, -1)
  function parent:NormalState()
    self.stateBg:SetColor(0, 0, 0, 0)
    self.newIcon:SetVisible(false)
    self.stateBg:SetVisible(true)
    self:ProcessDurabilityColor()
    self:ProcessRequireLevelCheck(0)
  end
  function parent:UnconfirmedState()
    self.stateBg:SetVisible(false)
    self.newIcon:SetVisible(true)
  end
  function parent:InvalidState()
    self.stateBg:SetColor(1, 1, 1, 0.3)
    self.back:SetColor(0, 0, 0, 0)
    self:OverlayInvisible()
    self:ProcessRequireLevelCheck(0)
  end
  parent.stateBg = stateBg
  parent.newIcon = newIcon
end
local function CreateInvenCoolDownActionButton(id, parent, adapter, injector)
  local btn = CreateItemIconButton(id, parent, "inventory")
  AddBtnStateOverlay(btn)
  btn.virtualSlotIdx = -1
  btn.realSlotIdx = -1
  btn:EnableDrag(true)
  btn:RegisterForClicks("RightButton")
  function btn:OnClickProc(arg)
    if arg == "LeftButton" then
      if injector and injector.PreClickSlot and injector:PreClickSlot(self.realSlotIdx) then
        return
      end
      adapter:HandleClick(self.virtualSlotIdx)
      return
    end
    local itemType, _ = adapter:ItemIdentifier(self.realSlotIdx)
    if itemType == 0 then
      return
    end
    if injector and injector.PreUseSlot and injector:PreUseSlot(self.realSlotIdx) then
      return
    end
    adapter:HandleUse(self.virtualSlotIdx)
  end
  function btn:OnDragStart()
    adapter:HandleClick(self.virtualSlotIdx)
  end
  btn:SetHandler("OnDragStart", btn.OnDragStart)
  function btn:OnDragReceive()
    if X2Cursor:GetCursorInfo() ~= nil then
      adapter:HandleClick(self.virtualSlotIdx)
    end
  end
  btn:SetHandler("OnDragReceive", btn.OnDragReceive)
  function btn:OnEnter()
    if self.realSlotIdx == nil then
      return
    end
    local tipInfo = adapter:GetBagItemInfo(self.realSlotIdx)
    if tipInfo ~= nil then
      ShowTooltip(tipInfo, self, 1, false)
    end
  end
  btn:SetHandler("OnEnter", btn.OnEnter)
  function btn:OnLeave()
    HideTooltip()
  end
  btn:SetHandler("OnLeave", btn.OnLeave)
  AddOnUpdateCooldown(btn)
  function btn:SetVirtualSlotIdx(idx)
    self.virtualSlotIdx = idx
  end
  function btn:SetRealSlotIdx(slot)
    self.realSlotIdx = slot
    self.id = slot
    if slot ~= nil then
      adapter:SetItemSlotForCooldown(self, slot)
    end
  end
  function btn:UpdateInvalidItem()
    self:Enable(false)
    self:Init()
    self:InvalidState()
  end
  function btn:UpdateEmptyItem()
    self:SetStack(0)
    self:Init()
  end
  function btn:UpdateIcon()
    local tipInfo = adapter:GetBagItemInfo(self.realSlotIdx)
    if tipInfo == nil then
      tipInfo = {}
    end
    local durability = adapter:ItemDurability(self.realSlotIdx)
    if durability == nil then
      tipInfo.durability = 1
      tipInfo.maxDurability = 1
    else
      tipInfo.durability = durability.current
      tipInfo.maxDurability = durability.max
    end
    local itemType, _ = adapter:ItemIdentifier(self.realSlotIdx)
    tipInfo.itemType = itemType
    self:SetItemInfo(tipInfo)
  end
  function btn:UpdateUsable()
    self:Enable(not adapter:IsLocked(self.realSlotIdx))
  end
  function btn:UpdateConfirmed()
    local confirmed = adapter:IsConfirmedSlot(self.virtualSlotIdx)
    if confirmed == false then
      self:UnconfirmedState()
    end
  end
  function btn:UpdateStack()
    local countStr = adapter:ItemStackStr(self.realSlotIdx)
    self:SetStack(countStr)
  end
  function btn:ChangeSlotBackground(tabIdx)
    if tabIdx == 1 then
      F_SLOT.ApplySlotSkin(btn, btn.back, SLOT_STYLE.BAG_DEFAULT)
    else
      F_SLOT.ApplySlotSkin(btn, btn.back, SLOT_STYLE.BAG_NOT_ALL_TAB)
    end
  end
  function btn:CreateRealSlotLabel()
    if self.realSlotLabel ~= nil then
      return
    end
    local slotIndexLabel = W_CTRL.CreateLabel("bagRealSlotIndex" .. tostring(idx), self)
    slotIndexLabel:SetExtent(0, 13)
    slotIndexLabel:AddAnchor("CENTER", self, 0, 0)
    slotIndexLabel:SetText(tostring(self.realSlotIdx))
    slotIndexLabel.style:SetAlign(ALIGN_CENTER)
    slotIndexLabel.style:SetFont("actionBar", 13)
    slotIndexLabel.style:SetShadow(true)
    ApplyTextColor(slotIndexLabel, FONT_COLOR.RED)
    self.realSlotLabel = slotIndexLabel
  end
  function btn:ShowRealSlotIndex(flag)
    self.realSlotLabel:SetText(tostring(self.realSlotIdx - 1))
    self.realSlotLabel:Show(flag and self.realSlotIdx ~= -1)
  end
  function btn:Update()
    self:SetRealSlotIdx(nil)
    self:NormalState()
    self:ChangeSlotBackground(adapter:CurrentTabIdx())
    if adapter:IsInvalidSlot(self.virtualSlotIdx) then
      self:UpdateInvalidItem()
      return
    end
    local realSlot = adapter:SlotByIdx(self.virtualSlotIdx)
    self:SetRealSlotIdx(realSlot)
    if adapter.isRealSlotShow ~= nil then
      self:CreateRealSlotLabel()
      self:ShowRealSlotIndex(adapter.isRealSlotShow)
    end
    if realSlot == nil then
      self:UpdateEmptyItem()
      if self:IsMouseOver() then
        self:OnLeave()
        self:OnEnter()
      end
      return
    end
    self:OverlayInvisible()
    self:UpdateStack()
    self:UpdateIcon()
    self:UpdateUsable()
    self:UpdateConfirmed()
    if injector and injector.Update then
      injector:Update(self)
    end
    if self:IsMouseOver() then
      self:OnLeave()
      self:OnEnter()
    end
  end
  return btn
end
function SetViewOfItemSlots(id, parent, adapter, injector)
  local widget = CreateEmptyWindow(id, parent)
  widget:SetExtent(470, 600)
  widget:AddAnchor("LEFT", "UIParent", 0, 0)
  local btns = {}
  local xOffset = 5
  local yOffset = 5
  local idx = 1
  local xInset = 10
  local yInset = 0
  for y = 1, 15 do
    if y == 3 or y == 6 or y == 8 or y == 11 or y == 13 then
      yInset = yInset + 2
    end
    xInset = 0
    for x = 1, 10 do
      local button = CreateInvenCoolDownActionButton("item" .. "[" .. x .. "]" .. "[" .. y .. "]", widget, adapter, injector)
      button:Show(false)
      button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
      button:SetVirtualSlotIdx(idx)
      F_SLOT.ApplySlotSkin(button, button.back, SLOT_STYLE.BAG_DEFAULT)
      btns[idx] = button
      if x == 6 then
        xInset = xInset + 5
      end
      xOffset = (x - 1) * (ICON_SIZE.DEFAULT + 5) + xInset
      yOffset = (y - 1) * (ICON_SIZE.DEFAULT + 4) + yInset
      button:AddAnchor("TOPLEFT", widget, xOffset, yOffset)
      idx = idx + 1
    end
  end
  widget.btns = btns
  return widget
end
function CreateInventoryItemSlots(id, parent, adapter, injector)
  local widget = SetViewOfItemSlots(id, parent, adapter, injector)
  function widget:UpdateExtent()
    local GetHeight = function(idx)
      local count = math.floor(idx / 10)
      local offset = 0
      for i = 1, count do
        if i == 3 or i == 6 or i == 8 or i == 11 then
          offset = offset + 3
        end
      end
      local height = count * ICON_SIZE.DEFAULT + (count - 1) * 4 + offset
      return height
    end
    self:SetHeight(GetHeight(adapter:Capacity()), false)
  end
  widget.lastColCount = 0
  function widget:Update()
    local btns = self.btns
    local xOffset = 0
    local yOffset = 0
    local idx = 1
    local xInset = 10
    local yInset = 0
    local colCount = adapter:Capacity() / 10
    for y = 1, colCount do
      for x = 1, 10 do
        local button = btns[idx]
        button:Update()
        button:Show(true)
        idx = idx + 1
      end
    end
    if widget.lastColCount ~= 0 and colCount < widget.lastColCount then
      idx = colCount * 10 + 1
      for y = colCount + 1, widget.lastColCount do
        for x = 1, 10 do
          local button = btns[idx]
          button:Update()
          button:Show(false)
          idx = idx + 1
        end
      end
    end
    widget.lastColCount = colCount
  end
  function widget:UpdateAt(realSlotIdx)
    local capacity = adapter:Capacity()
    for i = 1, capacity do
      local button = self.btns[i]
      if button.realSlotIdx == realSlotIdx then
        button:Update()
        return
      end
    end
  end
  widget:Show(false)
  return widget
end
local AddTabDescTooltip = function(btn, text)
  local function OnEnter()
    SetVerticalTooltip(text, btn)
  end
  btn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  btn:SetHandler("OnLeave", OnLeave)
end
local RemoveTabDescTooltip = function(btn)
  btn:ReleaseHandler("OnEnter")
  btn:ReleaseHandler("OnLeave")
end
local function CreateCommonInvenTab(id, parent, adapter)
  local tab = parent:CreateChildWidget("tab", id, 0, true)
  tab:SetGap(0)
  tab:SetOffset(0)
  tab:SetCorner("TOPLEFT")
  local addTabButton = tab:CreateChildWidget("button", "addTabButton", 0, true)
  addTabButton:Show(true)
  ApplyButtonSkin(addTabButton, BUTTON_CONTENTS.INVENTORY_TAB_ADD)
  AddTabDescTooltip(addTabButton, locale.inven.addTabDesc)
  function addTabButton:OnClick(arg)
    if arg == "LeftButton" and adapter.CreateTab ~= nil then
      adapter:ShowTabMaker()
    end
  end
  addTabButton:SetHandler("OnClick", addTabButton.OnClick)
  local inventoryPopupProc = {}
  function inventoryPopupProc:popupProc_AddTab()
    adapter:ShowTabMaker()
  end
  function inventoryPopupProc:popupProc_EditTab(arg)
    adapter:EditTabMaker(arg)
  end
  function inventoryPopupProc:popupProc_deleteTab(arg)
    adapter:RemoveTab(arg)
    adapter:ResetMaker()
  end
  function tab:InventoryPopup(stickTo, targetWidget, i)
    local popupInfo = GetDefaultPopupInfoTable()
    local tabDescTexts, iconIdxs = adapter:TabInfos()
    local idx = adapter:CurrentTabIdx()
    if #iconIdxs < MAX_EXTEND_TAB then
      popupInfo:AddInfo(locale.inven.addGroup, inventoryPopupProc.popupProc_AddTab)
    end
    if i ~= 1 then
      popupInfo:AddInfo(locale.inven.editGroup, inventoryPopupProc.popupProc_EditTab, i)
    end
    if i ~= 1 then
      popupInfo:AddInfo(locale.inven.removeGroup, inventoryPopupProc.popupProc_deleteTab, i)
    end
    if #popupInfo.infos > 0 then
      ShowPopUpMenu("popupMenu", stickTo, popupInfo)
    end
  end
  function tab:ActiveInventoryPopupMenu(stickTo, targetWidget, i)
    tab:InventoryPopup(stickTo, targetWidget, i)
  end
  tab.tabButtonSelected = {}
  tab.tabButtonUnselected = {}
  tab.divideLine = {}
  local tabWindow = CreateEmptyWindow(tab:GetId() .. ".tabWindow", tab)
  tabWindow:SetExtent(0, 0)
  tab.tabWindow = tabWindow
  local defaultSelectBtn = tab:CreateChildWidget("button", "defaultSelectBtn", 0, true)
  defaultSelectBtn:SetExtent(tabButton_width, tabButton_height)
  SetButtonFontColor(defaultSelectBtn, GetButtonDefaultFontColor())
  defaultSelectBtn:SetInset(0, 0, 10, 0)
  local defaultUnselectBtn = tab:CreateChildWidget("button", "defaultUnselectBtn", 0, true)
  defaultUnselectBtn:SetExtent(tabButton_width, tabButton_height)
  SetButtonFontColor(defaultUnselectBtn, GetButtonDefaultFontColor())
  defaultUnselectBtn:SetInset(0, 0, 10, 0)
  function defaultUnselectBtn:OnClick(arg)
    if arg == "LeftButton" then
      adapter:SwitchTab(1)
    end
    if arg == "RightButton" then
      tab:ActiveInventoryPopupMenu(self, self, 1)
    end
  end
  defaultUnselectBtn:SetHandler("OnClick", defaultUnselectBtn.OnClick)
  function defaultSelectBtn:OnClick(arg)
    if arg == "RightButton" then
      tab:ActiveInventoryPopupMenu(self, self, 1)
    end
  end
  defaultSelectBtn:SetHandler("OnClick", defaultSelectBtn.OnClick)
  for i = 1, MAX_EXTEND_TAB do
    local tabButtonSelected = CreateEmptyButton(id .. ".tab.tabButtonSelected[" .. i .. "]", tab)
    tabButtonSelected:RegisterForClicks("RightButton")
    local tabButtonUnselected = CreateEmptyButton(id .. ".tab.tabButtonUnSelected[" .. i .. "]", tab)
    tabButtonUnselected:RegisterForClicks("RightButton")
    tab.tabButtonSelected[i] = tabButtonSelected
    tab.tabButtonUnselected[i] = tabButtonUnselected
    tabButtonSelected:Show(false)
    tabButtonSelected:SetExtent(tabButton_width, tabButton_height)
    tabButtonUnselected:Show(false)
    tabButtonUnselected:SetExtent(tabButton_width, tabButton_height)
    tabButtonSelected.idx = i
    tabButtonUnselected.idx = i
    function tabButtonUnselected:OnClick(arg)
      if arg == "LeftButton" then
        adapter:SwitchTab(self.idx + 1)
      elseif arg == "RightButton" then
        tab:ActiveInventoryPopupMenu(self, self, self.idx + 1)
      end
    end
    tabButtonUnselected:SetHandler("OnClick", tabButtonUnselected.OnClick)
    function tabButtonSelected:OnClick(arg)
      if arg == "RightButton" then
        tab:ActiveInventoryPopupMenu(self, self, self.idx + 1)
      end
    end
    tabButtonSelected:SetHandler("OnClick", tabButtonSelected.OnClick)
  end
  for i = 1, divideLine_count do
    local divideLine
    if i % 3 == 1 then
      divideLine = tab:CreateDrawable(TEXTURE_PATH.TAB_LIST, "division_line_1", "artwork")
      divideLine:AddAnchor("TOPLEFT", tabWindow, (i - 1) * tabButton_width, -24)
    elseif i % 3 == 2 then
      divideLine = tab:CreateDrawable(TEXTURE_PATH.TAB_LIST, "division_line_2", "artwork")
      divideLine:AddAnchor("TOPLEFT", tabWindow, (i - 1) * tabButton_width, -32)
    else
      divideLine = tab:CreateDrawable(TEXTURE_PATH.TAB_LIST, "division_line_3", "artwork")
      divideLine:AddAnchor("TOPLEFT", tabWindow, (i - 1) * tabButton_width, -17)
    end
    divideLine:SetTextureColor("default")
    tab.divideLine[i] = divideLine
  end
  local first_divideLine = tab:CreateDrawable(TEXTURE_PATH.TAB_LIST, "division_line_1", "artwork")
  first_divideLine:SetTextureColor("default")
  first_divideLine:SetVisible(false)
  first_divideLine:AddAnchor("TOPLEFT", tabWindow, tabButton_width, -24)
  local line_first, line_second = CreateLine(tab, "TYPE2", "overlay")
  line_first:SetVisible(false)
  tab.line_first = line_first
  line_second:SetVisible(false)
  line_second:AddAnchor("TOPLEFT", defaultSelectBtn, "BOTTOMRIGHT", 2, -5)
  line_second:AddAnchor("TOPRIGHT", tabWindow, 0, 0)
  tab.line_second = line_second
  function tab:OnTabChanged(selected)
    for i = 1, divideLine_count do
      local divideLine = self.divideLine[i]
      if i % 3 == 1 then
        divideLine:SetExtent(25, 22)
        divideLine:SetCoords(181, 9, 25, 22)
        divideLine:AddAnchor("TOPLEFT", tabWindow, (i - 1) * tabButton_width, -24)
      elseif i % 3 == 2 then
        divideLine:SetExtent(25, 30)
        divideLine:SetCoords(206, 9, 25, 30)
        divideLine:AddAnchor("TOPLEFT", tabWindow, (i - 1) * tabButton_width, -32)
      else
        divideLine:SetExtent(25, 15)
        divideLine:SetCoords(231, 9, 25, 15)
        divideLine:AddAnchor("TOPLEFT", tabWindow, (i - 1) * tabButton_width, -17)
      end
    end
    if selected == 1 then
      self.line_first:SetVisible(false)
      self.line_second:RemoveAllAnchors()
      self.line_second:AddAnchor("TOPLEFT", tab.defaultSelectBtn, "BOTTOMRIGHT", 0, -5)
      self.line_second:AddAnchor("TOPRIGHT", tab.tabWindow, 11, 0)
    else
      local divideLine = self.divideLine[selected]
      if selected % 3 == 1 then
        divideLine:SetCoords(203, 9, -22, 22)
        divideLine:AddAnchor("TOPLEFT", tabWindow, (selected - 1) * tabButton_width - 22, -24)
      elseif selected % 3 == 2 then
        divideLine:SetCoords(231, 9, -25, 30)
        divideLine:AddAnchor("TOPLEFT", self.tabWindow, (selected - 1) * tabButton_width - 25, -32)
      else
        divideLine:SetCoords(256, 9, -25, 15)
        divideLine:AddAnchor("TOPLEFT", tabWindow, (selected - 1) * tabButton_width - 25, -17)
      end
      self.line_first:SetVisible(true)
      self.line_first:RemoveAllAnchors()
      self.line_first:AddAnchor("TOPLEFT", self.tabWindow, 0, -6)
      self.line_first:AddAnchor("TOPRIGHT", self.tabButtonSelected[selected - 1], "BOTTOMLEFT", 0, 0)
      self.line_second:SetVisible(true)
      self.line_second:RemoveAllAnchors()
      self.line_second:AddAnchor("TOPLEFT", self.tabButtonSelected[selected - 1], "BOTTOMRIGHT", 2, -6)
      self.line_second:AddAnchor("TOPRIGHT", self.tabWindow, 0, 0)
    end
    local parent = self:GetParent()
    if parent.TabChangedProc ~= nil then
      parent:TabChangedProc(selected)
    end
  end
  tab:SetHandler("OnTabChanged", tab.OnTabChanged)
  function tab:Clear()
    self.defaultSelectBtn:Show(false)
    self.defaultUnselectBtn:Show(false)
    for i = 1, #self.tabButtonSelected do
      self.tabButtonSelected[i]:Show(false)
      self.tabButtonUnselected[i]:Show(false)
    end
    self:RemoveAllTabs()
    for i = 1, divideLine_count do
      self.divideLine[i]:SetVisible(false)
    end
  end
  function tab:Reset(tabDescTexts, tabButtonIdxs)
    self:Clear()
    self.defaultUnselectBtn:Show(true)
    tab:AddNewTab(locale.inven.allTab, self.defaultSelectBtn, self.defaultUnselectBtn, tabWindow)
    local lastAnchorTarget = self.defaultUnselectBtn
    local count = #tabButtonIdxs
    if count > MAX_EXTEND_TAB then
      count = MAX_EXTEND_TAB
    end
    if count == 0 then
      first_divideLine:SetVisible(true)
    else
      first_divideLine:SetVisible(false)
    end
    for i = 1, count do
      tab:AddNewTab("", self.tabButtonSelected[i], self.tabButtonUnselected[i], tabWindow)
      local iconIdx = tabButtonIdxs[i]
      ApplyButtonSkin(self.tabButtonSelected[i], BUTTON_CONTENTS.BAG_TAB_ICON[iconIdx])
      ApplyButtonSkin(self.tabButtonUnselected[i], BUTTON_CONTENTS.BAG_TAB_ICON[iconIdx])
      AddTabDescTooltip(self.tabButtonSelected[i], tabDescTexts[i])
      AddTabDescTooltip(self.tabButtonUnselected[i], tabDescTexts[i])
      self.divideLine[i + 1]:SetVisible(true)
      if i ~= MAX_EXTEND_TAB then
        self.divideLine[i + 2]:SetVisible(true)
      end
      lastAnchorTarget = sel
    end
    self.addTabButton:Show(false)
    if adapter.TabAddible ~= nil and not adapter:TabAddible() then
      return
    end
    local yOffset = -32
    local existAddTabButton = false
    if count < MAX_EXTEND_TAB then
      self.addTabButton:RemoveAllAnchors()
      self.addTabButton:AddAnchor("TOPLEFT", self.tabWindow, (count + 1) * tabButton_width, yOffset)
      self.addTabButton:Show(true)
      existAddTabButton = true
    end
  end
  function tab:Update()
    local tabDescTexts, iconIdxs = adapter:TabInfos()
    tab:Reset(tabDescTexts, iconIdxs)
    tab:SelectTab(adapter:TabCount())
  end
  function tab:SetCurrentTab()
    local tabIdx = adapter:CurrentTabIdx()
    tab:SelectTab(tabIdx)
  end
  tab:Update()
  tab:SelectTab(1)
  return tab
end
function CreateInventory(id, parent, adapter, viewadapter, injector, category)
  local window = CreateWindow(id, parent, category)
  window:SetExtent(510, 100)
  window:Show(false)
  window:SetTitle(viewadapter:GetTitleText())
  local inset = 15
  local tab = CreateCommonInvenTab("commonInvenTab", window, adapter)
  tab:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", window, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  tab:Show(true)
  window.tab = tab
  local slots = CreateInventoryItemSlots(id .. ".slots", tab, adapter, injector)
  slots:AddAnchor("TOPLEFT", tab, 0, tabButton_height + 8)
  slots:Show(true)
  window.slots = slots
  local counter = viewadapter:CreateItemAndCapacityCounterLabel(id .. ".counter", window)
  counter:AddAnchor("TOPRIGHT", window.titleBar, "BOTTOMRIGHT", -MARGIN.WINDOW_SIDE, -2)
  local money, aaPoint
  local currency = viewadapter:GetCurrency()
  if currency == CURRENCY_GOLD then
    money = viewadapter:CreateMoneyLabel(id .. ".money", window)
    money:Show(true)
  elseif currency == CURRENCY_AA_POINT then
    aaPoint = viewadapter:CreateAAPointLabel(id .. ".aaPoint", window)
    aaPoint:Show(true)
  elseif currency == CURRENCY_GOLD_WITH_AA_POINT then
    aaPoint = viewadapter:CreateAAPointLabel(id .. ".aaPoint", window)
    aaPoint:Show(true)
    money = viewadapter:CreateMoneyLabel(id .. ".money", window)
    money:Show(true)
  end
  if money ~= nil then
    money:AddAnchor("TOPRIGHT", slots, "BOTTOMRIGHT", 3, MARGIN.WINDOW_SIDE / 2)
  end
  if aaPoint ~= nil then
    aaPoint:AddAnchor("TOPLEFT", slots, "BOTTOMLEFT", -3, MARGIN.WINDOW_SIDE / 2)
  end
  if baselibLocale.showMoneyTooltip then
    if aaPoint ~= nil then
      function aaPoint:OnEnter()
        SetTooltip(locale.moneyTooltip.aapoint, self)
      end
      aaPoint:SetHandler("OnEnter", aaPoint.OnEnter)
      function aaPoint:OnLeave()
        HideTooltip()
      end
      aaPoint:SetHandler("OnLeave", aaPoint.OnLeave)
    end
    if money ~= nil then
      function money:OnEnter()
        SetTooltip(locale.moneyTooltip.money, self)
      end
      money:SetHandler("OnEnter", money.OnEnter)
      function money:OnLeave()
        HideTooltip()
      end
      money:SetHandler("OnLeave", money.OnLeave)
    end
  end
  local sortBtn = window:CreateChildWidget("button", "sortBtn", 0, true)
  sortBtn:AddAnchor("BOTTOMRIGHT", window, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  ApplyButtonSkin(sortBtn, BUTTON_CONTENTS.INVENTORY_SORT)
  local function SortButtonLeftClickFunc(self)
    adapter:ManualSort()
  end
  ButtonOnClickHandler(sortBtn, SortButtonLeftClickFunc)
  local OnEnter = function(self)
    SetVerticalTooltip(locale.inven.sort, self)
  end
  sortBtn:SetHandler("OnEnter", OnEnter)
  local expandBtn = window:CreateChildWidget("button", "expandBtn", 0, true)
  ApplyButtonSkin(expandBtn, BUTTON_CONTENTS.INVENTORY_EXPAND)
  expandBtn:AddAnchor("BOTTOMRIGHT", sortBtn, "BOTTOMLEFT", 0, 0)
  local function OnEnter(self)
    SetVerticalTooltip(viewadapter:GetExpandButtonText(), self)
  end
  expandBtn:SetHandler("OnEnter", OnEnter)
  function expandBtn:OnClick()
    adapter:Expand()
  end
  expandBtn:SetHandler("OnClick", expandBtn.OnClick)
  local anchorOffsetX = MARGIN.WINDOW_SIDE
  local featureSet = X2Player:GetFeatureSet()
  local gachaButton
  if featureSet.lootGacha then
    gachaButton = viewadapter:CreateLootGachaButton(window)
    if gachaButton ~= nil then
      gachaButton:AddAnchor("BOTTOMLEFT", window, anchorOffsetX, -MARGIN.WINDOW_SIDE)
      anchorOffsetX = anchorOffsetX + gachaButton:GetWidth() + 8
    end
  end
  local storeBtn = viewadapter:CreateStoreButton(window)
  if storeBtn ~= nil then
    storeBtn:AddAnchor("BOTTOMLEFT", window, MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  end
  local enchantBtn = viewadapter:CreateEnchantButton(window)
  if enchantBtn ~= nil then
    enchantBtn:AddAnchor("BOTTOMLEFT", window, anchorOffsetX, -MARGIN.WINDOW_SIDE)
    anchorOffsetX = anchorOffsetX + enchantBtn:GetWidth()
  end
  local lookConvertBtn
  if featureSet.itemLookConvertInBag then
    lookConvertBtn = viewadapter:CreateLookConvertButton(window)
    if lookConvertBtn ~= nil then
      lookConvertBtn:AddAnchor("BOTTOMLEFT", window, anchorOffsetX, -MARGIN.WINDOW_SIDE)
      anchorOffsetX = anchorOffsetX + lookConvertBtn:GetWidth()
    end
  end
  local repairBtn
  if featureSet.itemRepairInBag then
    repairBtn = viewadapter:CreateRepairButton(window)
    if repairBtn ~= nil then
      repairBtn:AddAnchor("BOTTOMLEFT", window, anchorOffsetX, -MARGIN.WINDOW_SIDE)
      anchorOffsetX = anchorOffsetX + repairBtn:GetWidth()
    end
  end
  local lockBtn
  if featureSet.itemSecure then
    lockBtn = viewadapter:CreateLockButton(window)
    if lockBtn ~= nil then
      lockBtn:AddAnchor("BOTTOMLEFT", window, anchorOffsetX, -MARGIN.WINDOW_SIDE)
      anchorOffsetX = anchorOffsetX + lockBtn:GetWidth()
    end
  end
  local itemGuideBtn
  if featureSet.itemGuide then
    itemGuideBtn = viewadapter:CreateItemGuideButton(window)
    if itemGuideBtn ~= nil then
      anchorOffsetX = anchorOffsetX + 8
      itemGuideBtn:AddAnchor("BOTTOMLEFT", window, anchorOffsetX, -MARGIN.WINDOW_SIDE)
    end
  end
  local tipIcon = viewadapter:CreateTipIcon(window)
  if tipIcon ~= nil then
    tipIcon:Show(true)
    tipIcon:AddAnchor("TOPRIGHT", tab, 2, 4)
  end
  local maker = CreateItemGroupTabMaker(id .. ".maker", window, adapter)
  maker:AddAnchor("CENTER", "UIParent", 0, 0)
  window.maker = maker
  function window:UpdatePermission()
    local SetEnable = function(target, enable)
      if target ~= nil then
        target:Enable(enable)
      end
    end
    SetEnable(gachaButton, UIParent:GetPermission(UIC_LOOT_GACHA))
    SetEnable(enchantBtn, UIParent:GetPermission(UIC_ENCHANT))
    SetEnable(lookConvertBtn, UIParent:GetPermission(UIC_LOOK_CONVERT))
    SetEnable(repairBtn, UIParent:GetPermission(UIC_ITEM_REPAIR))
    SetEnable(lockBtn, UIParent:GetPermission(UIC_ITEM_LOCK))
    SetEnable(expandBtn, UIParent:GetPermission(UIC_EXPAND_INVENTORY) and adapter:IsExpandable() or false)
    SetEnable(itemGuideBtn, UIParent:GetPermission(UIC_ITEM_GUIDE))
    maker:Show(false)
    if self.spinner ~= nil then
      self.spinner:Show(false)
    end
  end
  window:UpdatePermission()
  function adapter:ShowTabMaker()
    window.maker:Init()
    window.maker:Show(true)
  end
  function adapter:EditTabMaker(tabIdx)
    window.maker:Init(tabIdx)
    window.maker:Show(true)
  end
  function adapter:ResetMaker()
    if window.maker:IsVisible() then
      window.maker:Init()
    end
  end
  function window:Update()
    self.slots:Update()
    window:SetTitle(viewadapter:GetTitleText())
  end
  function window:UpdateAt(realSlotIdx)
    self.slots:UpdateAt(realSlotIdx)
  end
  function window:TabChangedProc(selected)
    self.sortBtn:Show(adapter:CanManualSort())
    if selected == 1 then
      self.sortBtn:Enable(true)
    else
      self.sortBtn:Enable(false)
    end
  end
  function window:UpdateExtent()
    self.slots:UpdateExtent()
    local _, height = F_LAYOUT.GetExtentWidgets(self.titleBar, money == nil and aaPoint or money)
    if self.sortBtn:IsVisible() then
      height = height + self.sortBtn:GetHeight() + MARGIN.WINDOW_SIDE / 2
    end
    height = height + MARGIN.WINDOW_SIDE
    self:SetExtent(510, height)
  end
  function window:ShowProc()
    if injector and injector.Show then
      self:Update()
      injector:Show()
    end
    local btnVisible = adapter:ExpandBtnVisible()
    self.expandBtn:Show(btnVisible)
  end
  local function OnHide(self)
    if injector and injector.Hide then
      injector:Hide()
    end
    if self.spinner ~= nil then
      self.spinner:Show(false)
    end
    maker:Show(false)
    adapter:Confirm()
    if adapter.OnHideProc ~= nil then
      adapter:OnHideProc()
    end
  end
  window:SetHandler("OnHide", OnHide)
  local function OnEndFadeOut(self)
    if adapter.OnEndFadeOutProc ~= nil then
      adapter:OnEndFadeOutProc()
    end
  end
  window:SetHandler("OnEndFadeOut", OnEndFadeOut)
  tab:Update()
  tab:SetCurrentTab()
  window:UpdateExtent()
  return window
end
