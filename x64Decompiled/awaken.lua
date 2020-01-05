function CreateAwakenWindow(tabWindow)
  SetViewOfAwakenWindow(tabWindow)
  SetTargetItemClickFunc(tabWindow.slotTargetItem)
  SetEnchantItemClickFunc(tabWindow.slotEnchantItem)
  local buttonInfo = {
    leftButtonStr = WINDOW_ENCHANT.AWAKEN_TAB.BOTTOM_BUTTON_STR.LEFT,
    rightButtonStr = WINDOW_ENCHANT.AWAKEN_TAB.BOTTOM_BUTTON_STR.RIGHT,
    leftButtonLeftClickFunc = function()
      LockUnvisibleTab()
      local index = tabWindow.radioButtons:GetChecked()
      if index == nil or index == 0 then
        X2ItemEnchant:Execute(0)
      else
        local itemInfo = tabWindow.awakenItemSlots[index]:GetInfo()
        X2ItemEnchant:Execute(itemInfo.itemChangeMappingType)
      end
    end,
    rightButtonLeftClickFunc = function()
      if X2ItemEnchant:IsWorkingEnchant() then
        X2ItemEnchant:StopEnchanting()
      else
        X2ItemEnchant:LeaveItemEnchantMode()
      end
    end
  }
  CreateWindowDefaultTextButtonSet(tabWindow, buttonInfo)
  local lastCandidateIndex
  function tabWindow.slotTargetItem:Update()
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    UpdateSlot(self, itemInfo)
    if itemInfo == nil then
      lastCandidateIndex = nil
      return false
    end
    return true
  end
  function tabWindow.slotEnchantItem:Update()
    local enchantItemInfo = X2ItemEnchant:GetEnchantItemInfo()
    UpdateSlot(self, enchantItemInfo)
    if enchantItemInfo == nil then
      self.scrollCountLabel:Show(false)
      lastCandidateIndex = nil
      return false
    end
    self:SetStack(enchantItemInfo.total)
    self.scrollCountLabel:SetText(string.format("(%d/%d)", enchantItemInfo.total, enchantItemInfo.awakenConsumeCount))
    self.scrollCountLabel:Show(true)
    return true
  end
  local function AwakenListUpdate(resultInfo, isLock)
    local awakenCount = 0
    if resultInfo then
      awakenCount = #resultInfo.awakenList
    end
    local awakenSlotCount = #tabWindow.awakenItemSlots
    for i = 1, #tabWindow.awakenItemSlots do
      local itemSlot = tabWindow.awakenItemSlots[i]
      if i <= awakenCount then
        local awakenItem = resultInfo.awakenList[i]
        UpdateSlot(itemSlot, awakenItem)
        local offsetX = -awakenCount / 2 + (i - 0.5)
        offsetX = offsetX * (itemSlot:GetWidth() + 20)
        itemSlot:RemoveAllAnchors()
        itemSlot:AddAnchor("TOP", tabWindow.awakenList, offsetX, 16)
        itemSlot:Show(true)
      else
        itemSlot:Show(false)
      end
    end
    if awakenCount == 0 then
      tabWindow.radioButtons:Show(false)
      return
    end
    for i = 1, #tabWindow.radioButtons:GetData() do
      if i <= awakenCount then
        tabWindow.radioButtons:ShowIndex(i, true)
      else
        tabWindow.radioButtons:ShowIndex(i, false)
      end
    end
    tabWindow.radioButtons:Show(true)
    tabWindow.radioButtons:Enable(resultInfo.selectable)
    if resultInfo.selectable and not isLock and (lastCandidateIndex == nil or lastCandidateIndex < 1 or awakenCount < lastCandidateIndex) then
      tabWindow.radioButtons:Check(1, true)
    end
  end
  local function AwakenSuccessInfoUpdate(resultInfo)
    if resultInfo == nil then
      tabWindow.successWidget.text:Show(false)
      tabWindow.successBonusWidget.text:Show(false)
      tabWindow.disableResult:Show(false)
      return
    end
    local successRate = resultInfo.successRate
    local bonusRate = resultInfo.bonusRate or 0
    local disableRate = resultInfo.disableRate
    tabWindow.successWidget.text:Show(true)
    tabWindow.successWidget.text:SetText(string.format("%d %%", successRate / 100))
    tabWindow.successBonusWidget.text:Show(true)
    tabWindow.successBonusWidget.text:SetText(string.format("+%d%%", bonusRate / 100))
    tabWindow.disableResult:Show(true)
    tabWindow.disableResult:SetDisableResult(disableRate)
  end
  local function AwakenInitDetailInfoUpdate(resultInfo)
    local scrollDesc = tabWindow.scrollDesc
    local scrollWnd = tabWindow.scrollWnd
    if resultInfo == nil then
      scrollWnd:Show(false)
      return
    end
    scrollWnd:Show(true)
    local selectable = resultInfo.selectable
    scrollDesc.warningText:Show(selectable == false)
    scrollDesc.rows.score:Show(selectable)
    scrollDesc.rows.grade:Show(selectable)
    local scaleInfo = resultInfo.scaleInfo
    local rowSorts = {}
    if selectable then
      rowSorts[1] = "score"
      rowSorts[2] = "grade"
      if scaleInfo ~= nil then
        rowSorts[3] = "scaled"
        rowSorts[4] = "attr"
      else
        rowSorts[3] = "attr"
      end
    else
      rowSorts[1] = "attr"
      if scaleInfo ~= nil then
        rowSorts[2] = "scaled"
      end
      scrollDesc.rows.attr:SetText(GetCommonText("awaken_attribute_info_nonselective"))
      scrollDesc.rows.attr:Show(true)
    end
    if scaleInfo ~= nil then
      if scaleInfo.cur == "none" then
        scaleInfo.cur = "+0"
      end
      if scaleInfo.min == "none" then
        scaleInfo.min = "+0"
      end
      if scaleInfo.max == "none" then
        scaleInfo.max = "+0"
      end
      local strScale
      if scaleInfo.min ~= scaleInfo.max then
        strScale = string.format("%s \226\150\182 %s ~ %s", scaleInfo.cur, scaleInfo.max, scaleInfo.min)
      else
        strScale = string.format("%s \226\150\182 %s", scaleInfo.cur, scaleInfo.min)
      end
      scrollDesc.rows.scaled:SetText(strScale)
      scrollDesc.rows.scaled:Show(true)
    else
      scrollDesc.rows.scaled:Show(false)
    end
    local anchorObj = scrollDesc
    for i = 1, #rowSorts do
      scrollDesc.rows[rowSorts[i]]:RemoveAllAnchors()
      if anchorObj == scrollDesc then
        scrollDesc.rows[rowSorts[i]]:AddAnchor("TOPLEFT", anchorObj, 0, 17)
      else
        scrollDesc.rows[rowSorts[i]]:AddAnchor("TOPLEFT", anchorObj, "BOTTOMLEFT", 0, 17)
      end
      anchorObj = scrollDesc.rows[rowSorts[i]]
    end
    scrollWnd:GetResizeExtent(selectable)
  end
  function tabWindow.radioButtons:OnRadioChanged(index, data)
    local GetItemGrade = function(grade, color)
      local resultText = ""
      resultText = "|c" .. color .. grade
      return resultText
    end
    local scrollDesc = tabWindow.scrollDesc
    local targetItem = X2ItemEnchant:GetTargetItemInfo()
    local awakenItem = tabWindow.awakenItemSlots[index]:GetInfo()
    if targetItem == nil or awakenItem == nil then
      return
    end
    lastCandidateIndex = index
    if targetItem.gearScore ~= nil and awakenItem.gearScore ~= nil then
      scrollDesc.rows.score:SetText(string.format("%d \226\150\182 %d", targetItem.gearScore.total, awakenItem.gearScore.total))
    else
      scrollDesc.rows.score:SetText(string.format(GetCommonText("no_infomation")))
    end
    local curGrade = GetItemGrade(targetItem.grade, targetItem.gradeColor)
    local newGrade = GetItemGrade(awakenItem.grade, awakenItem.gradeColor)
    scrollDesc.rows.grade:SetText(string.format("%s|r \226\150\182 %s", curGrade, newGrade))
    local inheritAttrResults = awakenItem.inheritAttrResults
    if inheritAttrResults == nil then
      scrollDesc.rows.attr:Show(false)
      return
    end
    local attrString = ""
    for i = 1, #inheritAttrResults do
      local inheritAttr = inheritAttrResults[i]
      local attributeType = inheritAttr.unitAttribute
      local attributeStr = locale.attribute(attributeType)
      local valueCur = inheritAttr.unitModifierCur
      local valueCurStr = GetModifierCalcValue(attributeType, valueCur)
      local valueStr
      if inheritAttr.inheritState == IAAIS_INHERIT then
        local valueMin = inheritAttr.unitModifierMin
        local valueMax = inheritAttr.unitModifierMax
        local valueMinStr = GetModifierCalcValue(attributeType, valueMin)
        local valueMaxStr = GetModifierCalcValue(attributeType, valueMax)
        local modifierStr
        if valueMin == valueMax then
          modifierStr = valueMinStr
        else
          modifierStr = string.format(GetCommonText("awaken_attribute_info_value"), valueMinStr, valueMaxStr)
        end
        valueStr = string.format("%s\n", X2Locale:LocalizeUiText(COMMON_TEXT, "awaken_attribute_info", attributeStr, valueCurStr, modifierStr))
      elseif inheritAttr.inheritState == IAAIS_RANDOM then
        valueStr = string.format("%s\n", X2Locale:LocalizeUiText(COMMON_TEXT, "awaken_attribute_info", attributeStr, valueCurStr, GetCommonText("awaken_attribute_info_random")))
      else
        valueStr = string.format("%s\n", X2Locale:LocalizeUiText(COMMON_TEXT, "awaken_attribute_info", attributeStr, valueCurStr, GetCommonText("awaken_attribute_info_delete")))
      end
      attrString = attrString .. valueStr
    end
    scrollDesc.rows.attr:SetText(attrString)
    scrollDesc.rows.attr:Show(true)
  end
  tabWindow.radioButtons:SetHandler("OnRadioChanged", tabWindow.radioButtons.OnRadioChanged)
  local function AwakenWarningUpdate(isShow)
    tabWindow.warningInfo:Show(isShow)
    if isShow then
      tabWindow.warningInfo:SetText(GetCommonText("awaken_warning"))
    end
  end
  function tabWindow:SlotAllUpdate(isExcutable, isLock)
    local targetInfoExist = self.slotTargetItem:Update()
    local enchantInfoExist = self.slotEnchantItem:Update()
    local resultInfo = X2ItemEnchant:GetAwakenResultInfo()
    AwakenListUpdate(resultInfo, isLock)
    AwakenSuccessInfoUpdate(resultInfo)
    AwakenInitDetailInfoUpdate(resultInfo)
    AwakenWarningUpdate(enchantInfoExist)
    tabWindow.leftButton:Enable(isExcutable)
    self.slotTargetItem:Enable(not isLock)
    self.slotEnchantItem:Enable(not isLock)
    if isLock then
      self.slotTargetItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      self.slotEnchantItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    else
      self.slotTargetItem:SetOverlay(self.slotTargetItem:GetInfo())
      self.slotEnchantItem:SetOverlay(self.slotEnchantItem:GetInfo())
    end
  end
end
