local TAB_INDEX = {
  SHIP = 1,
  EQUIP = 2,
  CREW = 3
}
function CreateBattleFieldEquipmentTab(window)
  local tabTexts = {
    GetCommonText("battle_field_equipment_btn_ships"),
    GetCommonText("battle_field_equipment_btn_equips")
  }
  if ENABLE_CREW_PAGE then
    table.insert(tabTexts, GetCommonText("battle_field_equipment_btn_crews"))
  end
  local tabSubMenu = CreateTabSubMenu("tabSubMenu", window, tabTexts)
  tabSubMenu:AddAnchor("TOP", window, 0, 6)
  tabSubMenu:SetExtent(738, 44)
  window.tabSubMenu = tabSubMenu
  function window:CreateItemIconSelectImage(button)
    if button.selectImg == nil then
      button.selectImg = button:CreatetDrawable(TEXTURE_PATH.ITEM_GUIDE, "btn_selected", "overlay")
      button.selectImg:AddAnchor("CENTER", button, 0, 0)
      button.selectImg:SetExtent(button:GetWidth() + 10, button:GetHeight() + 10)
      button.selectImg:Show(false)
    end
  end
  function window:CreateItemIconUseImage(button)
    if button.useImg == nil then
      button.useImg = button:CreateImageDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_LIST, "overlay")
      button.useImg:SetTextureInfo("slot_check")
      button.useImg:AddAnchor("CENTER", button, 0, 0)
      button.useImg:Show(false)
    end
  end
  local sectionFrame = window:CreateChildWidget("emptywidget", "sectionFrame", 0, true)
  sectionFrame:Show(true)
  sectionFrame:AddAnchor("TOP", tabSubMenu, "BOTTOM", 0, 6)
  sectionFrame:AddAnchor("LEFT", window, 0, 0)
  sectionFrame:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.assigned = {}
  window.remained = {}
  function window:GetItemRemain(equipType, grade)
    for i = 1, #self.remained do
      if self.remained[i].equipType == equipType and self.remained[i].grade == grade then
        return self.remained[i].count
      end
    end
    return 0
  end
  function window:ModifyItemRemain(equipType, grade, count)
    for i = 1, #self.remained do
      if self.remained[i].equipType == equipType and self.remained[i].grade == grade then
        self.remained[i].count = self.remained[i].count + count
        return
      end
    end
    local newAssigned = {}
    newAssigned.equipType = equipType
    newAssigned.grade = grade
    newAssigned.count = count
    table.insert(self.remained, newAssigned)
  end
  function window:GetItemUse(slotType)
    for i = 1, #self.assigned do
      if self.assigned[i].slotType == slotType then
        return i
      end
    end
    return nil
  end
  function window:NewItemUse(slotType, equipType, grade)
    local newAssigned = {}
    newAssigned.slotType = slotType
    newAssigned.equipType = equipType
    newAssigned.grade = grade
    table.insert(self.assigned, newAssigned)
    return newAssigned
  end
  function window:SetItemUse(equipType, grade)
    local i = self:GetItemUse(self.selectedSlotType)
    if i ~= nil then
      local existed = self.assigned[i]
      existed.equipType = equipType
      existed.grade = grade
      return
    end
    local shipType = self.shipList[self.selectedShip].type
    local current = X2BattleField:GetShipEquipSlotInfo(shipType, self.selectedSlotType, 0, 0, false)
    if current.equipType ~= nil and current.equipType == equipType and current.itemInfo.itemGrade == grade then
      return
    end
    self:NewItemUse(self.selectedSlotType, equipType, grade)
    table.insert(self.assigned, newAssigned)
  end
  function window:UnsetItemUse(slotType)
    local i = self:GetItemUse(slotType)
    if i ~= nil then
      if self.assigned[i].defaultSetted ~= nil then
        self.assigned[i].equipType = 0
        self.assigned[i].grade = 0
        return
      else
        table.remove(self.assigned, i)
      end
    end
    local shipType = self.shipList[self.selectedShip].type
    local default = X2BattleField:GetShipEquipSlotInfo(shipType, slotType, 0, 0, true)
    local current = X2BattleField:GetShipEquipSlotInfo(shipType, slotType, 0, 0, false)
    if default.itemInfo.itemType ~= current.itemInfo.itemType or default.itemInfo.itemGrade ~= current.itemInfo.itemGrade then
      local newAssign = self:NewItemUse(slotType, 0, 0)
      newAssign.defaultSetted = true
      if current.equipType ~= nil then
        self:ModifyItemRemain(current.equipType, current.itemInfo.itemGrade, 1)
      end
    end
  end
  function window:ClearItemUse()
    while true do
      while true do
        table.remove(self.assigned, #self.assigned)
        if #self.assigned == 0 then
          break
        end
      end
    end
    while true do
      table.remove(self.remained, #self.remained)
      if #self.remained == 0 then
        break
      end
    end
  end
  function window:GetUsedItemCount(equipType, grade)
    local count = 0
    for i = 1, #self.assigned do
      if self.assigned[i].equipType == equipType and self.assigned[i].grade == grade then
        count = count + 1
      end
    end
    return count - self:GetItemRemain(equipType, grade)
  end
  window.selectedSlotType = -1
  function window:SelectSlotType(slotType)
    if slotType == nil then
      slotType = self.selectedSlotType
    else
      self.selectedSlotType = slotType
    end
    local list = X2BattleField:GetShipEquipSlotEquipable(self.shipList[self.selectedShip].type, slotType)
    self.equipInven:ClearAllInventory()
    local height = 0
    for i = 1, #list do
      local have = 0
      for j = 1, #list[i].itemInfo do
        if list[i].itemInfo[j].count ~= nil and 0 < list[i].itemInfo[j].count then
          have = have + list[i].itemInfo[j].count
        end
      end
      if list[i].enable == true or have > 0 then
        height = height + self.equipInven:InitInventory(list[i])
      end
    end
    window.equipInvenScroll.contentHeight = height
    window.equipInvenScroll:ResetScroll(height)
    if self.UpdateItemSlots ~= nil then
      self:UpdateItemSlots()
    end
  end
  function window:SlaveEquipOnClick(arg, slotType)
    if self.shipList == nil or self.selectedShip == nil then
      return
    end
    if self.equipInven == nil or not self.equipInven:IsVisible() then
      return
    end
    if arg == "LeftButton" then
      if self.selectedSlotType == slotType then
        self.selectedSlotType = -1
        self.equipInven:ClearAllInventory()
        if self.UpdateItemSlots ~= nil then
          self:UpdateItemSlots()
        end
        return
      end
      self:SelectSlotType(slotType)
    elseif arg == "RightButton" then
      self.selectedSlotType = -1
      self.equipInven:ClearAllInventory()
      if self.UnsetItemUse ~= nil then
        self:UnsetItemUse(slotType)
      end
      if self.UpdateItemSlots ~= nil then
        self:UpdateItemSlots(true)
      end
    end
  end
  function window:GetSlaveEquipSlotInfo(slotType)
    if self.shipList == nil or self.selectedShip == nil then
      return nil
    end
    local shipType = self.shipList[self.selectedShip].type
    local i = self:GetItemUse(slotType)
    if i ~= nil then
      local assigned = window.assigned[i]
      if assigned.equipType == 0 then
        return X2BattleField:GetShipEquipSlotInfo(shipType, slotType, 0, 0, true)
      else
        return X2BattleField:GetShipEquipSlotInfo(shipType, slotType, assigned.equipType, assigned.grade, false)
      end
    else
      return X2BattleField:GetShipEquipSlotInfo(shipType, slotType, 0, 0, false)
    end
  end
  function window:SlaveEquipUpdate(equipSlot)
    if self.selectedSlotType ~= nil and equipSlot.slotType == self.selectedSlotType then
      if equipSlot.selectImg == nil then
        self:CreateItemIconSelectImage(equipSlot)
      end
      equipSlot.selectImg:Show(true)
    elseif equipSlot.selectImg ~= nil then
      equipSlot.selectImg:Show(false)
    end
    if self:GetItemUse(equipSlot.slotType) ~= nil then
      if equipSlot.useImg == nil then
        self:CreateItemIconUseImage(equipSlot)
      end
      equipSlot.useImg:Show(true)
    elseif equipSlot.useImg ~= nil then
      equipSlot.useImg:Show(false)
    end
  end
  local equipPanel = CreateSlaveEquipmentPanel(window)
  equipPanel:AddAnchor("TOPLEFT", sectionFrame, 0, 0)
  function window:UpdateItemSlots(refresh)
    if refresh == nil then
      refresh = false
    end
    for i = 1, #equipPanel.slots do
      if equipPanel.slots[i].Update ~= nil then
        equipPanel.slots[i]:Update(refresh)
      end
    end
    for i = 1, #window.inventories do
      if window.inventories[i]:IsVisible() then
        for j = 1, #window.inventories[i].items do
          window.inventories[i].items[j]:Update()
        end
      end
    end
  end
  local equipButtons = window:CreateChildWidget("emptywidget", "equipButtons", 0, true)
  equipButtons:Show(false)
  equipButtons:AddAnchor("BOTTOMRIGHT", sectionFrame, 0, 0)
  equipButtons:AddAnchor("BOTTOMLEFT", sectionFrame, -4, 0)
  equipButtons:SetExtent(734, 34)
  local okButton = equipButtons:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(X2Locale:LocalizeUiText(OPTION_TEXT, "apply"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOMRIGHT", equipButtons, 0, 0)
  function okButton:OnClick()
    local shipType = window.shipList[window.selectedShip].type
    if #window.assigned == 0 then
      return
    end
    window.okButton:Enable(false)
    window.clearButton:Enable(false)
    for i = 1, #window.assigned do
      X2BattleField:SetShipEquipSlot(shipType, window.assigned[i].slotType, window.assigned[i].equipType, window.assigned[i].grade)
    end
    X2BattleField:SetShipEquipSlotDone()
  end
  ButtonOnClickHandler(okButton, okButton.OnClick)
  window.okButton = okButton
  local clearButton = equipButtons:CreateChildWidget("button", "clearButton", 0, true)
  clearButton:SetText(GetCommonText("init"))
  ApplyButtonSkin(clearButton, BUTTON_BASIC.DEFAULT)
  clearButton:AddAnchor("BOTTOMLEFT", equipButtons, 0, 0)
  function clearButton:OnClick()
    local shipType = window.shipList[window.selectedShip].type
    window.okButton:Enable(false)
    window.clearButton:Enable(false)
    X2BattleField:ClearShipEquipSlotAll(shipType)
  end
  ButtonOnClickHandler(clearButton, clearButton.OnClick)
  window.clearButton = clearButton
  local equipGuide = window:CreateChildWidget("emptywidget", "equipGuide", 0, true)
  equipGuide:Show(false)
  equipGuide:AddAnchor("TOPRIGHT", sectionFrame, 0, 0)
  equipGuide:SetExtent(441, 100)
  local equipGuideBg = CreateContentBackground(equipGuide, "TYPE2", "brown", "background")
  equipGuideBg:SetExtent(equipGuide:GetWidth(), equipGuide:GetHeight())
  equipGuideBg:AddAnchor("CENTER", equipGuide, 0, 0)
  local equipShipName = equipGuide:CreateChildWidget("label", "equipShipName", 0, true)
  equipShipName:SetExtent(247, FONT_SIZE.LARGE)
  equipShipName.style:SetAlign(ALIGN_LEFT)
  equipShipName.style:SetFontSize(FONT_SIZE.LARGE)
  equipShipName:AddAnchor("TOPLEFT", equipGuide, 18, 15)
  ApplyTextColor(equipShipName, FONT_COLOR.TITLE)
  local equipShipLine = CreateLine(equipGuide, "TYPE1")
  equipShipLine:AddAnchor("TOPLEFT", equipShipName, "BOTTOMLEFT", 0, 11)
  equipShipLine:AddAnchor("RIGHT", equipGuide, 0, 0)
  local equipShipDesc = equipGuide:CreateChildWidget("textbox", "equipShipDesc", 0, true)
  equipShipDesc:SetExtent(247, FONT_SIZE.MIDDLE)
  equipShipDesc:AddAnchor("TOPLEFT", equipShipLine, "BOTTOMLEFT", 0, 11)
  equipShipDesc:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  equipShipDesc:SetAutoResize(true)
  equipShipDesc:SetAutoWordwrap(true)
  equipShipDesc.style:SetAlign(ALIGN_LEFT)
  equipShipDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(equipShipDesc, FONT_COLOR.DEFAULT)
  local equipInven = window:CreateChildWidget("emptywidget", "equipInven", 0, true)
  equipInven:Show(false)
  equipInven:AddAnchor("TOPRIGHT", equipGuide, "BOTTOMRIGHT", 0, 8)
  equipInven:SetExtent(441, 420)
  window.equipInven = equipInven
  local equipInvenScroll = CreateScrollWindow(equipInven, equipInven:GetId() .. ".shipScroll", 0)
  equipInvenScroll:AddAnchor("TOPLEFT", equipInven, 0, 0)
  equipInvenScroll:AddAnchor("BOTTOMRIGHT", equipInven, -4, 0)
  equipInvenScroll.contentHeight = 0
  equipInvenScroll:ResetScroll(0)
  window.equipInvenScroll = equipInvenScroll
  window.inventories = {}
  equipInven.invenCount = 0
  function equipInven:ClearAllInventory()
    equipInven.invenCount = 0
    for i = 1, #window.inventories do
      window.inventories[i].Clear()
    end
  end
  function equipInven:CreateInventory(parent)
    local oneitems = {}
    for i = 1, 12 do
      local oneitem = CreateItemIconButton(string.format("inven[%d]", i), parent)
      oneitem:RegisterForClicks("RightButton")
      oneitem.grade = i
      if i == 1 then
        oneitem:AddAnchor("TOPLEFT", parent, 110, 0)
      elseif i == 7 then
        oneitem:AddAnchor("TOPLEFT", oneitems[1], "BOTTOMLEFT", 0, 5)
      else
        oneitem:AddAnchor("TOPLEFT", oneitems[i - 1], "TOPRIGHT", 6, 0)
      end
      function oneitem:OnClick(arg)
        if window.SetItemUse ~= nil then
          window:SetItemUse(parent.equipType, self.grade)
        end
        if window.UpdateItemSlots ~= nil then
          window:UpdateItemSlots(true)
        end
      end
      oneitem:SetHandler("OnClick", oneitem.OnClick)
      function oneitem:ResetCount(count)
        if count == nil or count <= 0 then
          self:SetStack(0)
          self.overlay:SetColor(0, 0, 0, 0.5)
          self:Enable(false)
        else
          self:SetStack(count)
          self.overlay:SetColor(0, 0, 0, 0)
          self:Enable(true)
        end
      end
      function oneitem:Update()
        local used = window:GetUsedItemCount(parent.equipType, self.grade)
        self:ResetCount(self.initedCount - used)
      end
      oneitems[i] = oneitem
    end
    return oneitems
  end
  function equipInven:InitInventory(list)
    local height = 89
    if window.inventories[equipInven.invenCount + 1] == nil then
      do
        local inven = equipInvenScroll.content:CreateChildWidget("emptywidget", "inventories" .. tostring(equipInven.invenCount + 1), 0, true)
        inven:SetExtent(392, 89)
        inven.head = inven:CreateChildWidget("textbox", "name", 0, true)
        inven.head:SetExtent(83, FONT_SIZE.MIDDLE)
        inven.head.style:SetAlign(ALIGN_CENTER)
        inven.head.style:SetFontSize(FONT_SIZE.MIDDLE)
        inven.head:SetAutoResize(true)
        inven.head:SetAutoWordwrap(true)
        inven.head:AddAnchor("LEFT", inven, 10, 0)
        ApplyTextColor(inven.head, FONT_COLOR.DEFAULT)
        inven.headBg = CreateContentBackground(inven, "TYPE3", "brown", "background")
        inven.headBg:AddAnchor("TOPLEFT", inven, 0, 18)
        inven.headBg:AddAnchor("BOTTOMRIGHT", inven, "BOTTOMLEFT", 103, 0)
        inven.items = self:CreateInventory(inven)
        function inven:Clear()
          inven:RemoveAllAnchors()
          inven:Show(false)
        end
        if equipInven.invenCount > 0 then
          inven.line = CreateLine(inven, "TYPE1")
          inven.line:AddAnchor("BOTTOMLEFT", inven, "TOPLEFT", 0, -8)
          inven.line:SetWidth(401)
        end
        window.inventories[equipInven.invenCount + 1] = inven
      end
    end
    window.inventories[equipInven.invenCount + 1].equipType = list.type
    window.inventories[equipInven.invenCount + 1].head:SetText(list.name)
    window.inventories[equipInven.invenCount + 1]:Show(true)
    for i = 1, 12 do
      local item = window.inventories[equipInven.invenCount + 1].items[i]
      item:SetItemInfo(list.itemInfo[i])
      if list.itemInfo[i].count == nil then
        item.initedCount = 0
      else
        item.initedCount = list.itemInfo[i].count
      end
      item:ResetCount(item.initedCount)
    end
    if equipInven.invenCount == 0 then
      window.inventories[equipInven.invenCount + 1]:AddAnchor("TOPRIGHT", equipInvenScroll.content, -9, 10)
      height = height + 10
    else
      window.inventories[equipInven.invenCount + 1]:AddAnchor("TOP", window.inventories[equipInven.invenCount], "BOTTOM", 0, 18)
      height = height + 18
    end
    equipInven.invenCount = equipInven.invenCount + 1
    return height
  end
  local shipSelecter = window:CreateChildWidget("emptywidget", "shipSelecter", 0, true)
  shipSelecter:Show(false)
  shipSelecter:AddAnchor("TOPRIGHT", sectionFrame, 0, 0)
  shipSelecter:SetExtent(447, 263)
  local shipSelecterBg = CreateContentBackground(shipSelecter, "TYPE2", "brown", "background")
  shipSelecterBg:SetExtent(shipSelecter:GetWidth(), shipSelecter:GetHeight())
  shipSelecterBg:AddAnchor("CENTER", shipSelecter, 0, 0)
  window.shipList = X2BattleField:GetShipListInfo()
  local shipImage = shipSelecter:CreateImageDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_LIST, "background")
  shipImage:SetExtent(149, 186)
  shipImage:AddAnchor("TOPLEFT", shipSelecter, 15, 15)
  local shipName = shipSelecter:CreateChildWidget("label", "shipName", 0, true)
  shipName:SetExtent(247, FONT_SIZE.MIDDLE)
  shipName.style:SetAlign(ALIGN_LEFT)
  shipName.style:SetFontSize(FONT_SIZE.MIDDLE)
  shipName:AddAnchor("TOPLEFT", shipImage, "TOPRIGHT", 9, 4)
  ApplyTextColor(shipName, FONT_COLOR.HIGH_TITLE)
  local shipLine = CreateLine(shipSelecter, "TYPE1")
  shipLine:AddAnchor("TOPLEFT", shipName, "BOTTOMLEFT", 0, 5)
  shipLine:AddAnchor("RIGHT", shipSelecter, 0, 0)
  local shipScroll = CreateScrollWindow(shipSelecter, shipSelecter:GetId() .. ".shipScroll", 0)
  shipScroll:AddAnchor("TOPRIGHT", shipLine, -5, 11)
  shipScroll:AddAnchor("BOTTOMLEFT", shipImage, "BOTTOMRIGHT", 9, 0)
  local shipDesc = shipScroll.content:CreateChildWidget("textbox", "shipDesc", 0, true)
  shipDesc:SetExtent(shipScroll.content:GetWidth(), FONT_SIZE.MIDDLE)
  shipDesc:AddAnchor("TOPLEFT", shipScroll.content, 0, 0)
  shipDesc:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  shipDesc:SetAutoResize(true)
  shipDesc:SetAutoWordwrap(true)
  shipDesc.style:SetAlign(ALIGN_LEFT)
  shipDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(shipDesc, FONT_COLOR.DEFAULT)
  local shipPager = W_CTRL.CreatePageControl("shipSelecter.pageControl", shipSelecter, "battleShip")
  shipPager:AddAnchor("BOTTOM", shipSelecter, 0, -14)
  function shipPager:ProcOnPageChanged(pageIndex, countPerPage)
    window.selectedSlotType = -1
    window:ClearItemUse()
    window.equipInven:ClearAllInventory()
    window:UpdateItemSlots()
    window.selectedShip = pageIndex
    shipImage:SetTextureInfo(window.shipList[pageIndex].shipImg)
    shipImage:Show(true)
    local shipInfo = X2BattleField:GetShipInfo(window.shipList[pageIndex].type, false)
    if shipInfo ~= nil then
      if shipName then
        shipName:SetText(shipInfo.name)
        shipName:Show(true)
      end
      if shipDesc then
        shipDesc:SetText(shipInfo.desc)
        shipDesc:Show(true)
        if shipScroll then
          shipScroll.contentHeight = shipDesc:GetHeight()
          shipScroll:ResetScroll(shipDesc:GetHeight())
        end
      end
      if equipShipName then
        equipShipName:SetText(shipInfo.name)
        equipShipName:Show(true)
      end
      if equipShipDesc then
        equipShipDesc:SetText(GetCommonText("battle_field_equipment_equip_guide", shipInfo.name))
        equipShipDesc:Show(true)
      end
      window:InitEquipment(shipInfo.customizingType)
    else
      if shipName then
        shipName:Show(false)
      end
      if shipDesc then
        shipDesc:Show(false)
      end
      if shipScroll then
        shipScroll.contentHeight = 0
        shipScroll:ResetScroll(0)
      end
      if equipShipName then
        equipShipName:Show(false)
      end
      if equipShipDesc then
        equipShipDesc:Show(false)
      end
      window:InitEquipment(4)
    end
    if equipInvenScroll then
      equipInvenScroll.contentHeight = 0
      equipInvenScroll:ResetScroll(0)
    end
  end
  shipPager:SetPageCount(#window.shipList, 1, true)
  shipPager:SetCurrentPage(1, true)
  shipPager:ProcOnPageChanged(1)
  local shipGuide = window:CreateChildWidget("emptywidget", "shipGuide", 0, true)
  shipGuide:Show(false)
  shipGuide:AddAnchor("TOPRIGHT", shipSelecter, "BOTTOMRIGHT", 0, 14)
  shipGuide:SetExtent(447, 251)
  local shipGuideBg = CreateContentBackground(shipGuide, "TYPE2", "brown", "background")
  shipGuideBg:SetExtent(shipGuide:GetWidth(), shipGuide:GetHeight())
  shipGuideBg:AddAnchor("CENTER", shipGuide, 0, 0)
  local prevContent
  for i = 1, 9 do
    if X2Locale:HasLocalizeUiText(COMMON_TEXT, "battle_field_equipment_ship_guide_" .. tostring(i)) then
      local text = X2Locale:LocalizeUiText(COMMON_TEXT, "battle_field_equipment_ship_guide_" .. tostring(i))
      local shipGuideContentPrefix = shipGuide:CreateImageDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_LIST, "background")
      shipGuideContentPrefix:SetTextureInfo("guide_point")
      if prevContent ~= nil then
        shipGuideContentPrefix:AddAnchor("TOPRIGHT", prevContent, "BOTTOMLEFT", -11, 15)
      else
        shipGuideContentPrefix:AddAnchor("TOPLEFT", shipGuide, 20, 55)
      end
      local shipGuideContent = shipGuide:CreateChildWidget("textbox", "shipGuideContent" .. tostring(i), 0, true)
      shipGuideContent.style:SetAlign(ALIGN_LEFT)
      shipGuideContent.style:SetFontSize(FONT_SIZE.MIDDLE)
      shipGuideContent:SetExtent(383, FONT_SIZE.MIDDLE)
      shipGuideContent:AddAnchor("TOPLEFT", shipGuideContentPrefix, "TOPRIGHT", 11, 0)
      shipGuideContent:SetAutoResize(true)
      shipGuideContent:SetAutoWordwrap(true)
      shipGuideContent:SetText(text)
      ApplyTextColor(shipGuideContent, FONT_COLOR.DEFAULT)
      prevContent = shipGuideContent
    end
  end
  function window:Refresh()
    okButton:Enable(true)
    clearButton:Enable(true)
    shipPager:ProcOnPageChanged(self.selectedShip)
  end
  function tabSubMenu:OnClickProc(index)
    if index == TAB_INDEX.SHIP then
      shipSelecter:Show(true)
      shipGuide:Show(true)
      equipGuide:Show(false)
      equipInven:Show(false)
      equipButtons:Show(false)
    elseif index == TAB_INDEX.EQUIP then
      shipSelecter:Show(false)
      shipGuide:Show(false)
      equipGuide:Show(true)
      equipInven:Show(true)
      equipButtons:Show(true)
    elseif index == TAB_INDEX.CREW then
      shipSelecter:Show(false)
      shipGuide:Show(false)
      equipGuide:Show(false)
      equipInven:Show(false)
      equipButtons:Show(true)
    end
    shipPager:ProcOnPageChanged(window.selectedShip)
    tabSubMenu.index = index
  end
  tabSubMenu.subMenuButtons[1]:OnClick()
end
