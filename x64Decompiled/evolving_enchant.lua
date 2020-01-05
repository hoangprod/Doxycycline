function CreateEvolvingEnchantWindow(tabWindow)
  local MAX_MATERIAL = 2
  local TAB_INDEX = {EVOLVING = 1, EVOLVING_REROLL = 2}
  SetViewOfEvolvingEnchantWindow(tabWindow)
  local selAttrIndex = 1
  local info = {
    leftButtonStr = GetUIText(COMMON_TEXT, "evolving"),
    leftButtonLeftClickFunc = function()
      LockUnvisibleTab()
      X2ItemEnchant:Execute(selAttrIndex)
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
  tabWindow.attrListWindow = nil
  local listCtrl = tabWindow.listCtrl
  local radioButtons = tabWindow.listCtrl.radioButtons
  local attrInfoStr = tabWindow.attrInfoStr
  local listButton = tabWindow.listButton
  local GetSubMenuChangedInfo = function(index)
    if index == nil or index ~= 1 and index ~= 2 then
      return
    end
    local info = {}
    if index == 1 then
      info.targetText = GetUIText(COMMON_TEXT, "growth_item")
      info.targetAnchor = {43, 43}
      info.materialAnchor = {0, 3}
      info.materialColor = {
        ConvertColor(94),
        ConvertColor(143),
        ConvertColor(98),
        1
      }
      info.leftButtonStr = GetUIText(COMMON_TEXT, "evolving")
    elseif index == 2 then
      info.targetText = GetUIText(COMMON_TEXT, "socket_enchant_equipment")
      info.targetAnchor = {47, 10}
      info.materialAnchor = {0, 5}
      info.materialColor = FONT_COLOR.PURPLE
      info.leftButtonStr = GetUIText(COMMON_TEXT, "replacement")
    end
    return info
  end
  function tabWindow.tabSubMenu:OnClickProc(index)
    local info = GetSubMenuChangedInfo(index)
    local isEvlovingMode = index == TAB_INDEX.EVOLVING
    tabWindow.slotTargetItem:RemoveAllAnchors()
    tabWindow.slotTargetItem.label:SetText(info.targetText)
    tabWindow.materialSlotLabel:RemoveAllAnchors()
    ApplyTextColor(tabWindow.materialSlotLabel, info.materialColor)
    tabWindow.materialSlots:Show(isEvlovingMode)
    tabWindow.slotEnchantItem:Show(not isEvlovingMode)
    tabWindow.slotEnchantItem.bg:SetVisible(not isEvlovingMode)
    tabWindow.reRollDeco:SetVisible(not isEvlovingMode)
    tabWindow.money:Show(isEvlovingMode)
    tabWindow.leftButton:SetText(info.leftButtonStr)
    ApplyButtonSkin(tabWindow.leftButton, BUTTON_BASIC.DEFAULT)
    tabWindow.rightButton:SetText(locale.common.cancel)
    ApplyButtonSkin(tabWindow.rightButton, BUTTON_BASIC.DEFAULT)
    if index == TAB_INDEX.EVOLVING then
      X2ItemEnchant:SwitchItemEnchantEvolvingMode()
      tabWindow.slotTargetItem:AddAnchor("TOPLEFT", tabWindow.tabSubMenu, "BOTTOMLEFT", info.targetAnchor[1], info.targetAnchor[2])
      tabWindow.materialSlotLabel:AddAnchor("TOP", tabWindow.materialBg, "BOTTOM", info.materialAnchor[1], info.materialAnchor[2])
    elseif index == TAB_INDEX.EVOLVING_REROLL then
      X2ItemEnchant:SwitchItemEnchantEvolvingReRollMode()
      tabWindow.slotTargetItem:AddAnchor("RIGHT", tabWindow.reRollDeco, "LEFT", info.targetAnchor[1], info.targetAnchor[2])
      tabWindow.materialSlotLabel:AddAnchor("TOP", tabWindow.slotEnchantItem, "BOTTOM", info.materialAnchor[1], info.materialAnchor[2])
    end
    ReanchorDefaultTextButtonSet({
      tabWindow.leftButton,
      tabWindow.rightButton
    }, tabWindow, -MARGIN.WINDOW_SIDE)
    tabWindow.index = index
  end
  local function OnEnter(self)
    if tabWindow.index == TAB_INDEX.EVOLVING then
      SetTooltip(GetUIText(COMMON_TEXT, "evolving_guide"), self)
    else
      SetTooltip(GetUIText(COMMON_TEXT, "reroll_evolving_guide"), self)
    end
  end
  tabWindow.guide:SetHandler("OnEnter", OnEnter)
  local function UpdateAttrList()
    if tabWindow.attrListWindow == nil then
      return
    end
    if not tabWindow.attrListWindow:IsVisible() then
      return
    end
    local isEvolvingMode = tabWindow.index == TAB_INDEX.EVOLVING and true or false
    tabWindow.attrListWindow:UpdateAttrList(isEvolvingMode, selAttrIndex)
  end
  local function ListButtonLeftClickFunc(button, show)
    if show == nil then
      if tabWindow.attrListWindow == nil then
        show = true
      else
        show = not tabWindow.attrListWindow:IsVisible()
      end
    end
    if show then
      if tabWindow.attrListWindow == nil then
        tabWindow.attrListWindow = CreateAttrListWindow("tabWindow.attrListWindow", "UIParent")
      end
      local function OnHide()
        tabWindow.attrListWindow = nil
      end
      tabWindow.attrListWindow:SetHandler("OnHide", OnHide)
      local target = GetEnchantWindow()
      tabWindow.attrListWindow:AddAnchor("TOPLEFT", target, "TOPRIGHT", 0, 0)
      local isEvolvingMode = tabWindow.index == TAB_INDEX.EVOLVING and true or false
      tabWindow.attrListWindow:UpdateAttrList(isEvolvingMode, selAttrIndex)
    end
    if tabWindow.attrListWindow ~= nil then
      tabWindow.attrListWindow:Show(show)
    end
  end
  ButtonOnClickHandler(listButton, ListButtonLeftClickFunc)
  local targetReqExp = 0
  local targetCurExp = 0
  local targetPercent = 0
  local targetGrade = -1
  local function UpdateTargetItemName(itemName)
    if targetGrade == nil or itemName == nil then
      tabWindow.name:Show(false)
      return
    end
    local gradeStr = GetTargetItemGradeStr(false)
    if gradeStr == nil then
      return
    end
    local str = string.format("%s %s", gradeStr, itemName)
    tabWindow.name:Show(true)
    tabWindow.name:SetText(str)
  end
  function tabWindow.slotTargetItem:Update()
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    UpdateSlot(self, itemInfo, true)
    listCtrl:DeleteAllDatas()
    tabWindow.targetCurExpGuage:SetValue(0)
    if itemInfo ~= nil then
      local evolvingInfo = itemInfo.evolvingInfo
      targetReqExp = evolvingInfo.minSectionExp
      targetCurExp = evolvingInfo.minExp
      targetGrade = itemInfo.itemGrade
      targetPercent = evolvingInfo.percent
      UpdateTargetItemName(itemInfo.name)
      tabWindow.targetCurExpGuage:SetMinMaxValues(0, evolvingInfo.minSectionExp)
      tabWindow.targetCurExpGuage:SetValue(evolvingInfo.minExp)
      local color = X2Item:GradeColor(itemInfo.itemGrade)
      color = Hex2Dec(color)
      tabWindow.targetCurExpGuage:SetBarColor(color)
      return true
    else
      local alpha = 0
      if tabWindow.index == 1 then
        alpha = 0.5
      elseif tabWindow.index == 2 then
        alpha = 1
      end
      UpdateTargetItemName()
      targetReqExp = 0
      targetCurExp = 0
      targetGrade = -1
      return false
    end
  end
  SetTargetItemClickFunc(tabWindow.slotTargetItem)
  function tabWindow.materialSlots:Update()
    local existItem = false
    for i = 1, #tabWindow.materialSlots do
      local materialSlot = tabWindow.materialSlots[i]
      local itemInfo = X2ItemEnchant:GetMaterialItemInfo(materialSlot.index - 1)
      UpdateSlot(materialSlot, itemInfo, true)
      existItem = existItem or itemInfo ~= nil
    end
    return existItem
  end
  function tabWindow.materialSlots:Enable(flag)
    local alpha = 0.5
    if flag then
      alpha = 1
    end
    tabWindow.materialBg:SetColor(1, 1, 1, alpha)
    for i = 1, #tabWindow.materialSlots do
      local materialSlot = tabWindow.materialSlots[i]
      materialSlot:Enable(flag)
      materialSlot:ApplyAlpha(alpha)
    end
  end
  function tabWindow.materialSlots:Show(flag)
    tabWindow.autoMaterial:Show(flag)
    tabWindow.materialBg:Show(flag)
    for i = 1, #tabWindow.materialSlots do
      local materialSlot = tabWindow.materialSlots[i]
      materialSlot:Show(flag)
    end
  end
  function tabWindow.materialSlots:SetOverlay(isLock)
    for i = 1, #tabWindow.materialSlots do
      local materialSlot = tabWindow.materialSlots[i]
      if isLock then
        materialSlot:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      else
        materialSlot:SetOverlay(materialSlot:GetInfo())
      end
    end
  end
  function tabWindow.materialSlots:Clear()
    X2ItemEnchant:ClearMaterialItemSlot(-1)
  end
  local OnMaterialSlotLeftClick = function(self)
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2ItemEnchant:SetMaterialItemSlotFromPick(self.index - 1)
    end
  end
  local OnMaterialSlotRightClick = function(self)
    X2ItemEnchant:ClearMaterialItemSlot(self.index - 1)
  end
  for i = 1, #tabWindow.materialSlots do
    local materialSlot = tabWindow.materialSlots[i]
    ButtonOnClickHandler(materialSlot, OnMaterialSlotLeftClick, OnMaterialSlotRightClick)
  end
  function tabWindow.slotEnchantItem:Update()
    local itemInfo = X2ItemEnchant:GetEnchantItemInfo()
    UpdateSlot(self, itemInfo, true)
    if itemInfo ~= nil then
      tabWindow.slotTargetItem:Update()
      return true
    else
      return false
    end
  end
  local OnEnchantSlotLeftClick = function(self)
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2ItemEnchant:SetEnchantItemSlotFromPick()
    end
  end
  local OnEnchantSlotRightClick = function(self)
    X2ItemEnchant:ClearEnchantItemSlot()
  end
  ButtonOnClickHandler(tabWindow.slotEnchantItem, OnEnchantSlotLeftClick, OnEnchantSlotRightClick)
  local function UpdateAttrInfoString()
    local str = ""
    if tabWindow.index == 1 then
      local addiableCount = X2ItemEnchant:GetEvolvingAddibleRndAttrCount()
      if addiableCount > 0 then
        str = F_TEXT.SetEnterString(str, GetUIText(COMMON_TEXT, "expected_add_one_attr", tostring(addiableCount)))
        attrInfoStr:Show(true)
      else
        attrInfoStr:Show(false)
      end
    elseif tabWindow.index == 2 then
      local fColdata = listCtrl:GetDataByViewIndex(selAttrIndex, 1)
      if fColdata == nil then
        return
      end
      local sColdata = listCtrl:GetDataByViewIndex(selAttrIndex, 3)
      if sColdata == nil then
        return
      end
      sColdata = GetModifierCalcValue(sColdata.name, sColdata.value)
      str = baselibLocale:ChangeSequenceOfWord("%s %s", string.format("%s %s", locale.attribute(fColdata.value), sColdata), GetUIText(COMMON_TEXT, "replacement"))
    end
    attrInfoStr:SetText(str)
    attrInfoStr:SetHeight(attrInfoStr:GetTextHeight())
  end
  function tabWindow.listCtrl.radioButtons:OnRadioChanged(index, dataValue)
    if tabWindow.index == 1 and X2ItemEnchant:GetEvolvingCanGradeupCount() <= 0 then
      return
    end
    selAttrIndex = index
    UpdateAttrInfoString()
    UpdateAttrList()
  end
  tabWindow.listCtrl.radioButtons:SetHandler("OnRadioChanged", tabWindow.listCtrl.radioButtons.OnRadioChanged)
  local function UpdateModifierListCtrl(enableLevelup)
    if enableLevelup == nil then
      enableLevelup = false
    end
    radioButtons:Show(false)
    attrInfoStr:Show(false)
    listCtrl:DeleteAllDatas()
    local maxRow = listCtrl:GetRowCount()
    for i = 1, maxRow do
      local items = listCtrl:GetListCtrlItems()
      if items[i].line ~= nil then
        items[i].line:SetVisible(false)
      end
    end
    ChangeButtonSkin(listButton, BUTTON_CONTENTS.SEARCH)
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    if itemInfo == nil then
      return false
    end
    local evolvingInfo = itemInfo.evolvingInfo
    if evolvingInfo.modifier == nil then
      return false
    end
    local evolvingDiffAttrs = X2ItemEnchant:GetEvolvingDiffAttrs()
    local canGetUnitModifierGroup = false
    local modifierDiffList = {}
    local modifierDatas = {}
    local diffDatas = {}
    if evolvingDiffAttrs ~= nil then
      if evolvingDiffAttrs.canGetUnitModifierGroup ~= nil then
        canGetUnitModifierGroup = evolvingDiffAttrs.canGetUnitModifierGroup
      end
      if evolvingDiffAttrs.modifierDiffList ~= nil then
        modifierDiffList = evolvingDiffAttrs.modifierDiffList
      end
    end
    enableLevelup = enableLevelup and canGetUnitModifierGroup
    modifierDatas = evolvingInfo.modifier
    diffDatas = modifierDiffList
    local visibleCount = maxRow <= #modifierDatas and maxRow or #modifierDatas
    for i = 1, visibleCount - 1 do
      local items = listCtrl:GetListCtrlItems()
      if items[i].line ~= nil then
        items[i].line:SetVisible(true)
      end
    end
    attrInfoStr:Show(enableLevelup)
    for i = 1, #modifierDatas do
      local item = modifierDatas[i]
      local colData = {
        enableLevelup = false,
        value = item.name,
        gsNum = item.gsNum
      }
      listCtrl:InsertData(i, 1, colData)
      if diffDatas ~= nil and #diffDatas > 0 then
        local valueStr = GetModifierCalcValue(item.name, item.value)
        listCtrl:InsertData(i, 2, valueStr)
        local diffItem = diffDatas[i]
        if diffItem ~= nil and item.name == diffItem.name then
          local colData = {
            isDiff = true,
            name = diffItem.name,
            value = math.abs(diffItem.value),
            gsNum = item.gsNum
          }
          listCtrl:InsertData(i, 3, colData)
        end
      else
        listCtrl:InsertData(i, 2, "")
        local colData = {
          isDiff = false,
          name = item.name,
          value = math.abs(item.value),
          gsNum = item.gsNum
        }
        listCtrl:InsertData(i, 3, colData)
      end
    end
    if diffDatas ~= nil and #diffDatas > 0 then
      ChangeButtonSkin(listButton, BUTTON_CONTENTS.SEARCH_GREEN)
    end
  end
  local function UpdateReRollModifierListCtrl()
    radioButtons:Show(false)
    attrInfoStr:Show(false)
    listCtrl:DeleteAllDatas()
    local maxRow = listCtrl:GetRowCount()
    for i = 1, maxRow do
      local items = listCtrl:GetListCtrlItems()
      if items[i].line ~= nil then
        items[i].line:SetVisible(false)
      end
    end
    ChangeButtonSkin(listButton, BUTTON_CONTENTS.SEARCH)
    local itemInfo = X2ItemEnchant:GetTargetItemInfo()
    if itemInfo == nil then
      selAttrIndex = 1
      return
    end
    local evolvingInfo = itemInfo.evolvingInfo
    if evolvingInfo.modifier == nil then
      return
    end
    local modifierDatas = evolvingInfo.modifier
    local diffDatas = {}
    modifierDatas = {}
    for i = 1, #evolvingInfo.modifier do
      table.insert(modifierDatas, evolvingInfo.modifier[i])
    end
    radioButtons:Check(selAttrIndex, true)
    local visibleCount = maxRow <= #modifierDatas and maxRow or #modifierDatas
    for i = 1, visibleCount - 1 do
      local items = listCtrl:GetListCtrlItems()
      if items[i].line ~= nil then
        items[i].line:SetVisible(true)
      end
    end
    attrInfoStr:Show(true)
    for i = 1, #radioButtons:GetData() do
      if i <= #modifierDatas then
        radioButtons:ShowIndex(i, true)
      else
        radioButtons:ShowIndex(i, false)
      end
    end
    radioButtons:Show(true)
    for i = 1, #modifierDatas do
      local item = modifierDatas[i]
      local colData = {
        enableLevelup = true,
        value = item.name,
        gsNum = item.gsNum
      }
      listCtrl:InsertData(i, 1, colData)
      listCtrl:InsertData(i, 2, "")
      local colData = {
        isDiff = false,
        name = item.name,
        value = math.abs(item.value),
        gsNum = item.gsNum
      }
      listCtrl:InsertData(i, 3, colData)
    end
    if diffDatas ~= nil and #diffDatas > 0 then
      ChangeButtonSkin(listButton, BUTTON_CONTENTS.SEARCH_GREEN)
    end
  end
  local function UpdateMaterialGuage(materialExist, isEvolvingMode)
    local costStr = "0"
    local currency = 0
    tabWindow.materialExpGuage:SetValue(0)
    tabWindow.nextMaterialExpGuage:SetValue(0)
    tabWindow.bonusExpGuage:SetValue(0)
    tabWindow.nextBonusExpGuage:SetValue(0)
    tabWindow.overBonusExpGuage:SetValue(0)
    tabWindow.expValue:Show(false)
    tabWindow.warningChangeCount:Show(false)
    tabWindow.changeCount:SetText("")
    tabWindow.overBonusExpGuage.tooltip = nil
    if targetGrade == -1 then
      return costStr, currency
    end
    local GetTooltipStr = function(title, curExp, reqExp, grade, percent)
      local percent = curExp == 0 and 0 or curExp / reqExp * 100
      return string.format("%s %d/%d (%s %d%%)", title, curExp, reqExp, X2Item:GradeName(grade), percent)
    end
    local tooltip = GetTooltipStr(GetUIText(COMMON_TEXT, "current_exp"), targetCurExp, targetReqExp, targetGrade, targetPercent)
    local expInfo = X2ItemEnchant:GetEvolvingExpInfo()
    if expInfo ~= nil then
      costStr = expInfo.costStr
      currency = expInfo.currency
      local color = GetTextureInfo(TEXTURE_PATH.COSPLAY_ENCHANT, "gage"):GetColors()[string.format("grade_%02d", targetGrade)]
      tabWindow.materialExpGuage:SetBarColor(color)
      local bonusMin = tabWindow.bonusExpGuage
      local bonusMax = tabWindow.nextBonusExpGuage
      if expInfo.minGrade > targetGrade then
        tabWindow.materialExpGuage:SetMinMaxValues(0, 1)
        tabWindow.materialExpGuage:SetValue(1)
        color = GetTextureInfo(TEXTURE_PATH.COSPLAY_ENCHANT, "gage"):GetColors()[string.format("grade_%02d", expInfo.minGrade)]
        tabWindow.nextMaterialExpGuage:SetBarColor(color)
        tabWindow.nextMaterialExpGuage:SetMinMaxValues(0, expInfo.minSectionExp)
        tabWindow.nextMaterialExpGuage:SetValue(expInfo.minExp)
        bonusMin = tabWindow.nextBonusExpGuage
        bonusMax = tabWindow.overBonusExpGuage
      else
        tabWindow.materialExpGuage:SetMinMaxValues(0, expInfo.minSectionExp)
        tabWindow.materialExpGuage:SetValue(expInfo.minExp)
      end
      if expInfo.maxExp ~= expInfo.minExp then
        bonusMin:SetBarTextureCoords(TEXTURE_PATH.COSPLAY_ENCHANT, "grade_bonus_1")
        if expInfo.maxGrade > expInfo.minGrade then
          bonusMin:SetMinMaxValues(0, 1)
          bonusMin:SetValue(1)
          bonusMax:SetBarTextureCoords(TEXTURE_PATH.COSPLAY_ENCHANT, "grade_bonus_2")
          bonusMax:SetMinMaxValues(0, expInfo.maxSectionExp)
          bonusMax:SetValue(expInfo.maxExp)
        else
          bonusMin:SetMinMaxValues(0, expInfo.maxSectionExp)
          bonusMin:SetValue(expInfo.maxExp)
        end
      end
      if materialExist then
        local minExp = expInfo.minExp
        if expInfo.minExp > expInfo.minSectionExp then
          minExp = expInfo.minSectionExp
        end
        tooltip = string.format([[
%s
%s]], tooltip, GetTooltipStr(GetUIText(COMMON_TEXT, "after_evolving_exp"), minExp, expInfo.minSectionExp, expInfo.minGrade))
      end
      tabWindow.warningChangeCount:Show(expInfo.overChance or false)
      local chanceStr = tostring(expInfo.curChance)
      if expInfo.addChance ~= nil and expInfo.maxChance ~= nil then
        if 0 < expInfo.addChance then
          chanceStr = string.format("%d%s+%d|r / %d", expInfo.curChance, FONT_COLOR_HEX.GREEN, expInfo.addChance, expInfo.maxChance)
        else
          chanceStr = string.format("%d / %d", expInfo.curChance, expInfo.maxChance)
        end
      end
      tabWindow.changeCount:SetText(chanceStr)
    end
    tabWindow.overBonusExpGuage.tooltip = tooltip
    if not tabWindow.overBonusExpGuage:HasHandler("OnEnter") then
      local OnEnter = function(self)
        if self.tooltip == nil or self.tooltip == "" then
          return
        end
        SetTooltip(self.tooltip, self)
      end
      tabWindow.overBonusExpGuage:SetHandler("OnEnter", OnEnter)
    end
    if not materialExist then
      return costStr, currency
    end
    local materialExp = expInfo.materialExp or 0
    local overExp = expInfo.overExp or 0
    local strMaterialExp = CommaStr(X2Util:NumberToString(materialExp))
    if overExp > 0 then
      strMaterialExp = X2Locale:LocalizeUiText(COMMON_TEXT, "material_over_exp", strMaterialExp, CommaStr(X2Util:NumberToString(overExp)))
    end
    tabWindow.expValue:SetWidth(300)
    tabWindow.expValue:SetText(strMaterialExp)
    tabWindow.expValue:Show(true)
    return costStr, currency
  end
  function tabWindow:EvolvingModeSlotAllUpdate(isExcutable, isLock)
    selAttrIndex = 0
    local targetInfoExist = self.slotTargetItem:Update()
    local materialExist = self.materialSlots:Update()
    if not targetInfoExist or not materialExist then
      self.overBonusExpGuage.tooltip = nil
    end
    listButton:Enable(targetInfoExist)
    if not targetInfoExist then
      ListButtonLeftClickFunc(listButton, false)
    end
    local canGradeupCount = X2ItemEnchant:GetEvolvingCanGradeupCount()
    costStr, currency = UpdateMaterialGuage(materialExist, true)
    UpdateModifierListCtrl(canGradeupCount > 0)
    local data = {
      type = "cost",
      currency = currency,
      value = costStr
    }
    tabWindow.money:SetData(data)
    ApplyTextColor(self.tip, FONT_COLOR.GRAY)
    self.tip:SetText(GetUIText(COMMON_TEXT, "evolving_tip"))
    local addiableCount = X2ItemEnchant:GetEvolvingAddibleRndAttrCount()
    if addiableCount > 0 then
      ChangeButtonSkin(listButton, BUTTON_CONTENTS.SEARCH_GREEN)
    end
    self.tip:SetHeight(self.tip:GetTextHeight())
    self.slotTargetItem:Enable(not isLock)
    self.materialSlots:Enable(not isLock and targetInfoExist)
    self.autoMaterial:Enable(not isLock and targetInfoExist)
    self.autoMaterial:SetMode(materialExist)
    radioButtons:Enable(not isLock)
    self.leftButton:Enable(isExcutable)
    UpdateAttrInfoString()
    UpdateAttrList()
    if isLock then
      self.slotTargetItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    else
      self.slotTargetItem:SetOverlay(self.slotTargetItem:GetInfo())
    end
    self.materialSlots:SetOverlay(isLock)
  end
  function tabWindow:EvolvingReRollModeSlotAllUpdate(isExcutable, isLock)
    local targetInfoExist = self.slotTargetItem:Update()
    self.slotEnchantItem:Update()
    self.leftButton:Enable(isExcutable)
    listButton:Enable(targetInfoExist)
    if not targetInfoExist then
      ListButtonLeftClickFunc(listButton, false)
    end
    UpdateMaterialGuage(false, false)
    UpdateReRollModifierListCtrl(true)
    self.tip:RemoveAllAnchors()
    ApplyTextColor(self.tip, FONT_COLOR.GRAY)
    self.tip:SetText(GetUIText(COMMON_TEXT, "evolving_re_roll_tip"))
    self.tip:AddAnchor("TOP", self.listCtrl, "BOTTOM", 0, MARGIN.WINDOW_SIDE * 3 + WINDOW_ENCHANT.EVOLVING_ENCHANT_TAB.MONEY_HEIGHT_REROLL)
    self.tip:SetHeight(self.tip:GetTextHeight())
    self.slotTargetItem:Enable(not isLock)
    self.slotEnchantItem:Enable(not isLock)
    radioButtons:Enable(not isLock)
    self.leftButton:Enable(isExcutable)
    UpdateAttrInfoString()
    UpdateAttrList()
    if isLock then
      self.slotTargetItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      self.slotEnchantItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    else
      self.slotTargetItem:SetOverlay(self.slotTargetItem:GetInfo())
      self.slotEnchantItem:SetOverlay(self.slotEnchantItem:GetInfo())
    end
  end
  function tabWindow:SlotAllUpdate(isExcutable, isLock)
    local targetAnchor = self.laborPower
    if tabWindow.index == 1 then
      tabWindow:EvolvingModeSlotAllUpdate(isExcutable, isLock)
    elseif tabWindow.index == 2 then
      tabWindow:EvolvingReRollModeSlotAllUpdate(isExcutable, isLock)
    end
    local data = {
      type = "labor_power",
      value = X2ItemEnchant:GetEnchantConsumeLp()
    }
    self.laborPower:SetData(data)
    local _, startY = targetAnchor:GetOffset()
    local _, endY = self.leftButton:GetOffset()
    local offsetY = (endY - (startY + targetAnchor:GetHeight())) / 2
    self.tip:RemoveAllAnchors()
    if self.attrInfoStr:IsVisible() then
      self.tip:AddAnchor("TOP", self.attrInfoStr, "BOTTOM", 0, 10)
      offsetY = offsetY - (self.tip:GetHeight() + self.attrInfoStr:GetHeight() + 10) / 2
      self.attrInfoStr:RemoveAllAnchors()
      self.attrInfoStr:AddAnchor("TOP", targetAnchor, "BOTTOM", 0, offsetY)
    else
      offsetY = offsetY - self.tip:GetHeight() / 2
      self.tip:AddAnchor("TOP", targetAnchor, "BOTTOM", 0, offsetY)
    end
  end
end
