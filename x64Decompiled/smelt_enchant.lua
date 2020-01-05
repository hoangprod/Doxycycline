SOURCE_ITEM_SLOT_MAX = 10
function CreateSmeltWindow(tabWindow)
  SetViewOfSmeltWindow(tabWindow)
  SetTargetItemClickFunc(tabWindow.slotTargetItem)
  SetEnchantItemClickFunc(tabWindow.slotEnchantItem)
  function tabWindow.slotTargetItem:Update()
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    UpdateSlot(self, itemInfo)
    if itemInfo ~= nil then
      tabWindow.spinnerWnd:SetState(true)
      local curCount = tabWindow.spinnerWnd:GetCurValue()
      srcItemInfo = X2ItemEnchant:GetSmeltingTargetRequirementsInfo(itemInfo.itemType, curCount)
      resultItemInfo = X2ItemEnchant:GetSmeltingResultsInfo(itemInfo.itemType, curCount)
      if srcItemInfo == nil or resultItemInfo == nil then
        return false
      end
      tabWindow:SourceItemSetInfoUpdate(srcItemInfo, itemInfo.itemType)
      tabWindow:ResultInfoUpdate(resultItemInfo)
      return true
    else
      tabWindow:SourceItemSetInfoUpdate(nil, nil)
      tabWindow:ResultInfoUpdate(nil)
      tabWindow.spinnerWnd:SetState(false)
      tabWindow.spinnerWnd.spinner:SetValue(1)
      return false
    end
    return true
  end
  function tabWindow.slotEnchantItem:Update()
    local enchantItemInfo = X2ItemEnchant:GetEnchantItemInfo()
    UpdateSlot(self, enchantItemInfo)
    if enchantItemInfo == nil then
      return false
    end
    local targetItemInfo = X2ItemEnchant:GetTargetItemInfo()
    if targetItemInfo ~= nil then
      local curCount = tabWindow.spinnerWnd:GetCurValue()
      enchantRequirementsInfo = X2ItemEnchant:GetSmeltingEnchantRequirementsInfo(targetItemInfo.itemType, enchantItemInfo.itemType, curCount)
      if enchantRequirementsInfo == nil then
        return false
      end
      tabWindow:RequirmentsInfoUpdate(enchantRequirementsInfo)
      return true
    else
      return false
    end
    return true
  end
  function tabWindow:SourceItemSetInfoUpdate(srcItemInfo, targetItemType)
    if srcItemInfo ~= nil then
      local targetItemCountInBag = X2Bag:CountBagItemByItemType(targetItemType)
      if targetItemCountInBag < srcItemInfo.target_item_max_count then
        tabWindow.spinnerWnd:SetMinMaxValues(1, targetItemCountInBag)
        if targetItemCountInBag < tabWindow.spinnerWnd:GetCurValue() then
          tabWindow.spinnerWnd:SetValue(targetItemCountInBag)
        end
      else
        tabWindow.spinnerWnd:SetMinMaxValues(1, srcItemInfo.target_item_max_count)
      end
      for i = 1, #srcItemInfo do
        local info = srcItemInfo[i]
        local item = tabWindow.srcItemSetsFrame.items[i]
        item:SetItemInfo(info.item_info)
        item.itemType = info.item_info.itemType
        item.mainGrade = info.item_info.grade
        item:SetStack(info.count, info.require_count)
      end
      for j = #srcItemInfo + 1, SOURCE_ITEM_SLOT_MAX do
        tabWindow.srcItemSetsFrame.items[j]:Init()
      end
    else
      for i = 1, SOURCE_ITEM_SLOT_MAX do
        tabWindow.srcItemSetsFrame.items[i]:Init()
      end
    end
  end
  function tabWindow:ResultInfoUpdate(resultItemInfo)
    if resultItemInfo ~= nil then
      for i = 1, #tabWindow.resultFrame.resultArray do
        local info = resultItemInfo[i]
        if info then
          local result = tabWindow.resultFrame.resultArray[i]
          result.item:SetItemInfo(info.item_info)
          result.itemType = info.item_info.itemType
          result.item.mainGrade = info.item_info.grade
          result.statusBar:SetValue(info.prob)
        end
      end
    else
      for i = 1, #tabWindow.resultFrame.resultArray do
        local result = tabWindow.resultFrame.resultArray[i]
        result.item:Init()
        result.statusBar:SetValue(0)
      end
      return
    end
  end
  function tabWindow:RequirmentsInfoUpdate(enchantRequirementsInfo)
    tabWindow.laborPower:SetText(string.format("%s%s", GetUIText(CRAFT_TEXT, "require_labor_power"), tostring(enchantRequirementsInfo.require_labor_power)))
    tabWindow.actability:SetText(string.format("%s%s %s/%s", GetUIText(CRAFT_TEXT, "require_mastery"), tostring(enchantRequirementsInfo.actability_name), tostring(enchantRequirementsInfo.current_actability), tostring(enchantRequirementsInfo.require_actability)))
    if enchantRequirementsInfo.currency == CURRENCY_AA_POINT then
      tabWindow.money:UpdateAAPoint(enchantRequirementsInfo.require_gold)
    else
      tabWindow.money:Update(enchantRequirementsInfo.require_gold)
    end
    if enchantRequirementsInfo.require_labor_power < enchantRequirementsInfo.original_require_labor_power then
      ApplyTextColor(tabWindow.laborPower, FONT_COLOR.GREEN)
    else
      ApplyTextColor(tabWindow.laborPower, FONT_COLOR.DEFAULT)
    end
    if enchantRequirementsInfo.current_actability < enchantRequirementsInfo.require_actability then
      ApplyTextColor(tabWindow.actability, FONT_COLOR.RED)
    else
      ApplyTextColor(tabWindow.actability, FONT_COLOR.DEFAULT)
    end
  end
  function tabWindow.spinnerWnd:OnTextChanged(self)
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    if itemInfo then
      local spinner = tabWindow.spinnerWnd.spinner
      local text = spinner.text:GetText()
      local number = tonumber(text)
      if number ~= nil then
        if number > spinner.maxValue then
          spinner.curValue = spinner.maxValue
        elseif number < tabWindow.spinnerWnd.spinner.minValue then
          spinner.curValue = spinner.minValue
        else
          spinner.curValue = number
        end
        spinner:SetValue(tabWindow.spinnerWnd.spinner.curValue)
      else
        spinner:SetValue("")
      end
      X2ItemEnchant:SetSmeltingTargetItemCount(tabWindow.spinnerWnd:GetCurValue())
      X2ItemEnchant:UpdateSmeltingEnchantMode(tabWindow.spinnerWnd:GetCurValue())
    end
  end
  function tabWindow:SlotAllUpdate(isExcutable, isLock)
    local isSmeltable = isExcutable and X2ItemEnchant:IsSmeltingSmeltable(tabWindow.spinnerWnd:GetCurValue())
    local targetInfoExist = self.slotTargetItem:Update()
    local enchantInfoExist = self.slotEnchantItem:Update()
    if not targetInfoExist then
      tabWindow.spinnerWnd.spinner:SetValue(1)
      X2ItemEnchant:SetSmeltingTargetItemCount(1)
      tabWindow.spinnerWnd:SetMinMaxValues(1, 1)
    end
    tabWindow.smeltingTip:Show(targetInfoExist and not enchantInfoExist)
    tabWindow.laborPower:Show(targetInfoExist and enchantInfoExist)
    tabWindow.actability:Show(targetInfoExist and enchantInfoExist)
    tabWindow.money:Show(targetInfoExist and enchantInfoExist)
    self.leftButton:Enable(isSmeltable)
    self.slotTargetItem:Enable(not isLock)
    self.slotEnchantItem:Enable(not isLock)
    self.spinnerWnd:SetState(not isLock)
    self.spinnerWnd.spinner:SetEnable(not isLock)
    self.srcItemSetsFrame:Enable(not isLock)
    if isLock then
      self.slotTargetItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      self.slotEnchantItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    else
      self.slotTargetItem:SetOverlay(self.slotTargetItem:GetInfo())
      self.slotEnchantItem:SetOverlay(self.slotEnchantItem:GetInfo())
    end
  end
end
