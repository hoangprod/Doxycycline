function CreateRefurbishmentWindow(tabWindow)
  SetViewOfRefurbishmentWindow(tabWindow)
  local info = {
    leftButtonStr = GetUIText(COMMON_TEXT, "item_scale"),
    leftButtonLeftClickFunc = function()
      X2ItemEnchant:Execute()
    end,
    rightButtonLeftClickFunc = function()
      if X2ItemEnchant:IsWorkingEnchant() then
        X2ItemEnchant:StopEnchanting()
      else
        X2ItemEnchant:LeaveItemEnchantMode()
      end
    end
  }
  CreateWindowDefaultTextButtonSet(tabWindow, info)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "enchant_scale_guide"), self)
  end
  tabWindow.guide:SetHandler("OnEnter", OnEnter)
  function tabWindow.slotTargetItem:Update()
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    UpdateSlot(self, itemInfo, true)
    if itemInfo ~= nil then
      tabWindow.money:Show(itemInfo.enchant_cost ~= 0)
      local data = {
        type = "cost",
        currency = itemInfo.enchant_currency,
        value = itemInfo.enchant_cost
      }
      tabWindow.money:SetData(data)
    else
      tabWindow.money:Show(false)
    end
  end
  function tabWindow.slotEnchantItem:Update()
    local itemInfo = X2ItemEnchant:GetEnchantItemInfo()
    UpdateSlot(self, itemInfo, true)
    if itemInfo ~= nil then
      self:SetStack(itemInfo.total)
    end
  end
  function tabWindow.slotSupportItem:Update()
    local itemInfo = X2ItemEnchant:GetSupportItemInfo()
    UpdateSlot(self, itemInfo, true)
    if itemInfo ~= nil then
      self:SetStack(itemInfo.total)
      self.procOnEnter = nil
    else
      function self:procOnEnter()
        if self.tooltip == nil then
          return
        end
        SetTooltip(self.tooltip, self)
      end
    end
  end
  SetTargetItemClickFunc(tabWindow.slotTargetItem)
  SetEnchantItemClickFunc(tabWindow.slotEnchantItem)
  local SlotEnchantItemLeftClickFunc = function(self)
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2ItemEnchant:SetSupportItemSlotFromPick()
    end
  end
  local SlotEnchantItemRightClickFunc = function(self)
    X2ItemEnchant:ClearSupportItemSlot()
  end
  ButtonOnClickHandler(tabWindow.slotSupportItem, SlotEnchantItemLeftClickFunc, SlotEnchantItemRightClickFunc)
  local SetFailInfo = function(widget, enchantInfo, key)
    if enchantInfo == nil then
      widget:Show(false)
      return
    else
      widget:Show(true)
    end
    local coords
    if enchantInfo[key] then
      coords = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_O.COORDS
    else
      coords = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_X.COORDS
    end
    widget.result:SetCoords(coords[1], coords[2], coords[3], coords[4])
  end
  local function SetModifiers(enchantInfo)
    local modifierCount = 0
    if enchantInfo ~= nil then
      modifierCount = #enchantInfo.modifiers
    end
    for i = 1, 5 do
      local modifierFrame = tabWindow.scrollDesc.modifiers[i]
      if i > modifierCount then
        modifierFrame:Show(false)
      else
        modifierFrame:Show(true)
        local modifiers = enchantInfo.modifiers
        local title = GetUIText(TOOLTIP_TEXT, modifiers[i].title)
        local before = GetModifierCalcValue(modifiers[i].modifier, modifiers[i].curValue)
        local afterMin = GetModifierCalcValue(modifiers[i].modifier, modifiers[i].minValue)
        local afterMax = GetModifierCalcValue(modifiers[i].modifier, modifiers[i].maxValue)
        local after = afterMin
        if afterMin ~= afterMax then
          after = string.format("%s ~ %s", afterMin, afterMax)
        end
        modifierFrame:SetModifier(title, before, after)
      end
    end
    tabWindow.scrollWnd.scroll:SetEnable(modifierCount > 2)
    tabWindow.scrollWnd.scroll:Show(modifierCount > 2)
  end
  local function UpdateEnchantInfo()
    local enchantInfo = X2ItemEnchant:GetRatioInfos()
    if enchantInfo ~= nil then
      tabWindow.ratioFrame.ratioValue:SetText(string.format("%.1f%%", enchantInfo.success_ratio / 100))
      tabWindow.ratioFrame:Show(true)
    else
      tabWindow.ratioFrame:Show(false)
    end
    tabWindow.successFrame:SetEnchantInfo(enchantInfo, "afterScale")
    tabWindow.successGreatFrame:SetEnchantInfo(enchantInfo, "greatAfterScale")
    SetFailInfo(tabWindow.destroyLabel, enchantInfo, "break_ratio")
    SetFailInfo(tabWindow.downGradeLabel, enchantInfo, "down_ratio")
    SetFailInfo(tabWindow.disableLabel, enchantInfo, "disable_ratio")
    SetModifiers(enchantInfo)
    if enchantInfo ~= nil and enchantInfo.realRatio ~= nil then
      local str = string.format("Great Success - %.2f%%", enchantInfo.realRatio.grateSuccess / 100)
      str = string.format([[
%s
Success - %.2f%%]], str, enchantInfo.realRatio.success / 100)
      str = string.format([[
%s
Break - %.2f%%]], str, enchantInfo.realRatio["break"] / 100)
      str = string.format([[
%s
Disable - %.2f%%]], str, enchantInfo.realRatio.disable / 100)
      str = string.format([[
%s
Down - %.2f%%]], str, enchantInfo.realRatio.down / 100)
      str = string.format([[
%s
Fail - %.2f%%]], str, enchantInfo.realRatio.fail / 100)
      tabWindow.realRatioGmOnly:SetExtent(120, 100)
      tabWindow.realRatioGmOnly:SetText(str)
    end
  end
  function tabWindow:SlotAllUpdate(isExcutable, isLock)
    self.slotTargetItem:Update()
    self.slotEnchantItem:Update()
    self.slotSupportItem:Update()
    if isExcutable then
      self.slotSupportItem:ApplyAlpha(1)
    else
      self.slotSupportItem:ApplyAlpha(0.5)
    end
    self.slotTargetItem:Enable(not isLock)
    self.slotEnchantItem:Enable(not isLock)
    self.slotSupportItem:Enable(not isLock)
    tabWindow.leftButton:Enable(isExcutable)
    tabWindow.warningText:Show(isExcutable)
    tabWindow.warningText:SetText(GetCommonText("enchant_scale_warning"))
    UpdateEnchantInfo()
  end
end
