function CreateEnchantGradeWindow(tabWindow)
  SetViewOfGradeEnchantWindow(tabWindow)
  SetGuideTooltipIncludeItemGrade(tabWindow.guide, X2Locale:LocalizeUiText(COMMON_TEXT, "grade_enchant_guide_tooltip", F_COLOR.GetColor("original_dark_orange", true), FONT_COLOR_HEX.SOFT_YELLOW, FONT_COLOR_HEX.SOFT_YELLOW))
  local info = {
    leftButtonStr = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.BOTTOM_BUTTON_STR.LEFT,
    rightButtonStr = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.BOTTOM_BUTTON_STR.RIGHT,
    leftButtonLeftClickFunc = function()
      LockUnvisibleTab()
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
  tabWindow.leftButton:Enable(false)
  function tabWindow.slotTargetItem:Update()
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    UpdateSlot(self, itemInfo, true)
    tabWindow.slotSupportItem:Enable(itemInfo ~= nil)
    if itemInfo ~= nil then
      tabWindow.money:Show(itemInfo.grade_enchant_cost ~= "0")
      local data = {
        type = "cost",
        currency = itemInfo.grade_enchant_currency,
        value = itemInfo.grade_enchant_cost
      }
      tabWindow.money:SetData(data)
      if X2Item:IsLimitGrade(itemInfo.itemType, itemInfo.itemGrade) then
        tabWindow.slotEnchantItem:ApplyAlpha(0.5)
      else
        tabWindow.slotEnchantItem:ApplyAlpha(1)
      end
      tabWindow.slotSupportItem:ApplyAlpha(1)
      return X2Item:IsLimitGrade(itemInfo.itemType, itemInfo.itemGrade)
    else
      tabWindow.slotEnchantItem:ApplyAlpha(1)
      tabWindow.slotSupportItem:ApplyAlpha(0.5)
      return false
    end
  end
  SetTargetItemClickFunc(tabWindow.slotTargetItem)
  function tabWindow.slotEnchantItem:Update()
    local itemInfo = X2ItemEnchant:GetEnchantItemInfo()
    UpdateSlot(self, itemInfo)
    if itemInfo ~= nil then
      self:SetStack(itemInfo.total)
      tabWindow.slotSupportItem:ApplyAlpha(1)
    else
      tabWindow.slotSupportItem:ApplyAlpha(0.5)
    end
  end
  SetEnchantItemClickFunc(tabWindow.slotEnchantItem)
  function tabWindow.slotSupportItem:Update()
    local itemInfo = X2ItemEnchant:GetSupportItemInfo()
    UpdateSlot(self, itemInfo)
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
  local SlotEnchantItemLeftClickFunc = function(self)
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2ItemEnchant:SetSupportItemSlotFromPick()
    end
  end
  local SlotEnchantItemRightClickFunc = function(self)
    X2ItemEnchant:ClearSupportItemSlot()
  end
  ButtonOnClickHandler(tabWindow.slotSupportItem, SlotEnchantItemLeftClickFunc, SlotEnchantItemRightClickFunc)
  function tabWindow:SlotAllUpdate(isExcutable, isLock)
    self.money:Show(false)
    local targetIsMaxGrade = self.slotTargetItem:Update()
    self.slotEnchantItem:Update()
    self.slotSupportItem:Update()
    local SetRatio = function(isPossible, idx, resultTexture, isPositiveEffect)
      local ENUM = {
        RESULT_O = 1,
        RESULT_X = 2,
        RESULT_UPGRADE = 3,
        RESULT_UPGRADE_2 = 4,
        RESULT_UPGRADE_3 = 5,
        RESULT_DOWNGRADE = 6,
        RESULT_DOWNGRADE_2 = 7,
        RESULT_DOWNGRADE_3 = 8
      }
      local function GetIdx(isPossible, idx)
        if idx ~= nil then
          return idx
        end
        if isPossible then
          return ENUM.RESULT_O
        else
          return ENUM.RESULT_X
        end
      end
      local iconIdx = GetIdx(isPossible, idx)
      local color
      if iconIdx == ENUM.RESULT_O or iconIdx == ENUM.RESULT_UPGRADE or iconIdx == ENUM.RESULT_UPGRADE_2 or iconIdx == ENUM.RESULT_UPGRADE_3 then
        color = isPositiveEffect and FONT_COLOR.BLUE or FONT_COLOR.RED
      else
        color = isPositiveEffect and FONT_COLOR.RED or FONT_COLOR.BLUE
      end
      local coordsTable = {
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_O,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_X,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_UPGRADE,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_UPGRADE_2,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_UPGRADE_3,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_DOWNGRADE,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_DOWNGRADE_2,
        WINDOW_ENCHANT.GRADE_ENCHANT_TAB.RESULT_DOWNGRADE_3
      }
      local coords = coordsTable[iconIdx].COORDS
      local extent = coordsTable[iconIdx].EXTENT
      resultTexture:SetCoords(coords[1], coords[2], coords[3], coords[4])
      resultTexture:SetExtent(extent[1], extent[2])
      ApplyTextureColor(resultTexture, color)
    end
    local ratioInfo = X2ItemEnchant:GetRatioInfos()
    if ratioInfo ~= nil then
      self.successPossibility:SetText(string.format("%.1f%s", ratioInfo.successRatio, "%"))
      self.successGradeCur:SetGrade(ratioInfo.currentGrade)
      self.successGradeNew:SetGrade(ratioInfo.successGrade)
      self.successArrow:Show(true)
      if ratioInfo.greatSuccessGrade ~= nil then
        self.greatSuccessGradeCur:SetGrade(ratioInfo.currentGrade)
        self.greatSuccessGradeNew:SetGrade(ratioInfo.greatSuccessGrade)
        self.greatSuccessArrow:Show(true)
      else
        self.greatSuccessGradeCur:Show(false)
        self.greatSuccessGradeNew:Show(false)
        self.greatSuccessArrow:Show(false)
      end
      SetRatio(ratioInfo.success, ratioInfo.success_icon_idx, self.successPossibilityResult, true)
      local color = WINDOW_ENCHANT.GRADE_ENCHANT_TAB.SUCCESS_POSSIBILITY.COLOR
      ApplyTextColor(self.successLabel, color)
      self.destroyLabel:Show(true)
      self.destroyResult:SetVisible(true)
      SetRatio(ratioInfo["break"], ratioInfo.break_icon_idx, self.destroyResult, false)
      self.downGradeLabel:Show(true)
      self.downGradeResult:SetVisible(true)
      SetRatio(ratioInfo.downgrade, ratioInfo.downgrade_icon_idx, self.downGradeResult, false)
      self.disableLabel:Show(inventoryLocale.gradeEnchantDisableProbDisplay)
      self.disableResult:SetVisible(inventoryLocale.gradeEnchantDisableProbDisplay)
      SetRatio(ratioInfo.disable, ratioInfo.disable_icon_idx, self.disableResult, false)
      self.warningText:Show(true)
      self.successPossibility:Show(inventoryLocale.enchantRealProbDisplay)
      self.successPossibilityResult:Show(not inventoryLocale.enchantRealProbDisplay)
    else
      self.destroyLabel:Show(false)
      self.downGradeLabel:Show(false)
      self.disableLabel:Show(false)
      self.destroyResult:SetVisible(false)
      self.downGradeResult:SetVisible(false)
      self.disableResult:SetVisible(false)
      self.successPossibility:Show(false)
      self.successPossibilityResult:Show(false)
      self.successGradeCur:Show(false)
      self.successGradeNew:Show(false)
      self.successArrow:Show(false)
      self.greatSuccessGradeCur:Show(false)
      self.greatSuccessGradeNew:Show(false)
      self.greatSuccessArrow:Show(false)
      self.warningText:Show(false)
    end
    if targetIsMaxGrade then
      self.warningText:Show(true)
      self:SetWarningText(GetCommonText("grade_enchant_max_grade_warning"))
    else
      self:SetWarningText(GetCommonText("grade_enchant_warning"))
    end
    self.leftButton:Enable(isExcutable)
    self.slotTargetItem:Enable(not isLock)
    self.slotEnchantItem:Enable(not isLock)
    self.slotSupportItem:Enable(not isLock)
    if isLock then
      self.slotTargetItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      self.slotEnchantItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      self.slotSupportItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    else
      self.slotTargetItem:SetOverlay(self.slotTargetItem:GetInfo())
      self.slotEnchantItem:SetOverlay(self.slotEnchantItem:GetInfo())
      self.slotSupportItem:SetOverlay(self.slotSupportItem:GetInfo())
    end
  end
end
