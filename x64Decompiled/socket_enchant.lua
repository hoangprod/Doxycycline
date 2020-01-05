local PopupExtractNoticeDialog = function(id, diagInfo)
  local function DialogExtractHandler(dlg, infoTable)
    local itemIcon = CreateItemIconButton(dlg:GetId() .. ".itemIcon", dlg)
    local ICON_SIZE = 40
    if #diagInfo.removeItems > 0 then
      local iconParent
      if #diagInfo.removeItems <= 3 then
        local removeWnd = dlg:CreateChildWidget("emptywidget", "removeWnd", 0, true)
        removeWnd:SetExtent(POPUP_WINDOW_WIDTH - 40, #diagInfo.removeItems * ICON_SIZE)
        removeWnd:AddAnchor("TOP", dlg.textbox, "BOTTOM", 0, 15)
        iconParent = removeWnd
        local bg = CreateContentBackground(removeWnd, "TYPE11", "brown")
        bg:AddAnchor("TOPLEFT", removeWnd, 0, 0)
        bg:AddAnchor("BOTTOMRIGHT", removeWnd, 0, 0)
      else
        local scrollWnd = CreateScrollWindow(dlg, "scrollWnd", 0)
        scrollWnd:SetExtent(POPUP_WINDOW_WIDTH - 40, 3 * ICON_SIZE)
        scrollWnd:AddAnchor("TOP", dlg.textbox, "BOTTOM", 0, 15)
        scrollWnd:ResetScroll(#diagInfo.removeItems * ICON_SIZE)
        iconParent = scrollWnd.content
        local bg = CreateContentBackground(scrollWnd, "TYPE11", "brown")
        bg:AddAnchor("TOPLEFT", scrollWnd, 0, 0)
        bg:AddAnchor("BOTTOMRIGHT", scrollWnd, 0, 0)
      end
      for i = 1, #diagInfo.removeItems do
        local itemIcon = CreateItemIconButton(iconParent:GetId() .. ".itemIcon" .. i, iconParent)
        itemIcon:SetExtent(30, 30)
        itemIcon:AddAnchor("TOPLEFT", iconParent, 10, ICON_SIZE * (i - 1) + 5)
        local itemName = itemIcon:CreateChildWidget("textbox", "itemName", 0, true)
        itemName:SetExtent(250, FONT_SIZE.MIDDLE)
        itemName:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
        itemName:AddAnchor("LEFT", itemIcon, "RIGHT", 7, 0)
        itemName.style:SetAlign(ALIGN_TOP_LEFT)
        ApplyTextColor(itemName, FONT_COLOR.BLUE)
        local itemInfo = X2Item:GetItemInfoByType(diagInfo.removeItems[i].itemType)
        itemIcon:SetItemInfo(itemInfo)
        itemName:SetText(itemInfo.name)
      end
      local warning = dlg:CreateChildWidget("textbox", "warning", 0, true)
      warning:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH)
      warning:SetAutoResize(true)
      warning.style:SetAlign(ALIGN_CENTER)
      warning.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      warning:AddAnchor("TOP", iconParent, "BOTTOM", 0, 15)
      ApplyTextColor(warning, FONT_COLOR.RED)
      if diagInfo.isAll then
        warning:SetText(GetCommonText("extract_all_warning"))
      else
        warning:SetText(GetCommonText("extract_warning"))
      end
      itemIcon:AddAnchor("TOP", warning, "BOTTOM", 0, 10)
    else
      itemIcon:AddAnchor("TOP", dlg.textbox, "BOTTOM", 0, 10)
    end
    dlg:SetTitle(diagInfo.title)
    dlg:SetContent(diagInfo.body, false)
    itemIcon:SetItemInfo(diagInfo.itemInfo)
    itemIcon:SetStack(diagInfo.itemMaxCount, diagInfo.itemUseCount)
    dlg:RegistBottomWidget(itemIcon)
    function dlg:OkProc()
      diagInfo.ExecuteFunc(diagInfo.value, diagInfo.isAll)
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogExtractHandler, "")
end
function CreateSocketEnchantWindow(tabWindow)
  SetViewOfSocketEnchantWindow(tabWindow)
  local function LockSubMenu()
    if tabWindow.tabSubMenu.selIndex == 0 then
      return
    end
    for i = 1, #tabWindow.tabSubMenu.subMenuButtons do
      if i ~= tabWindow.tabSubMenu.selIndex then
        tabWindow.tabSubMenu.subMenuButtons[i]:Enable(false)
      end
    end
  end
  local function Execute(value, isAll)
    LockUnvisibleTab()
    LockSubMenu()
    tabWindow.socketListFrame.Clear()
    X2ItemEnchant:Execute(value, isAll)
  end
  function tabWindow:UnlockSubMenu()
    if GetEnchantWindow().tab:GetSelectedTab() ~= GetEnchantTabIndex("socket") then
      return
    end
    for i = 1, #self.tabSubMenu.subMenuButtons do
      self.tabSubMenu.subMenuButtons[i]:Enable(true)
    end
  end
  local usedSocketNum = 0
  local maxEnchantNum = 0
  local socketInfo = {}
  local selectSlotBit = 0
  local TAB_INDEX = WINDOW_ENCHANT.SOCKET_SUB_TAB_INDEX
  local info = {
    leftButtonStr = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.BOTTOM_BUTTON_STR.LEFT.SOCKETING,
    rightButtonStr = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.BOTTOM_BUTTON_STR.RIGHT,
    leftButtonLeftClickFunc = function()
      if tabWindow.index == TAB_INDEX.INSTALL then
        count = tabWindow.spinnerWnd:GetCurValue()
        Execute(count, false)
      elseif tabWindow.index == TAB_INDEX.REMOVE then
        Execute(1, false)
      elseif tabWindow.index == TAB_INDEX.EXTRACT then
        local info = socketInfo[tabWindow.socketListFrame.selectIndex]
        local index = tabWindow.socketListFrame.selectIndex - 1
        if info.extractable then
          Execute(index, false)
        else
          local diagInfo = {}
          diagInfo.isAll = false
          diagInfo.value = index
          diagInfo.title = GetCommonText("extract")
          diagInfo.body = GetCommonText("extract_msg")
          diagInfo.itemInfo = X2ItemEnchant:GetEnchantItemInfo()
          diagInfo.itemMaxCount = maxEnchantNum
          diagInfo.itemUseCount = 1
          diagInfo.ExecuteFunc = Execute
          diagInfo.removeItems = {info}
          PopupExtractNoticeDialog(tabWindow:GetId(), diagInfo)
        end
      elseif tabWindow.index == TAB_INDEX.UPGRADE then
        Execute(selectSlotBit, false)
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
  CreateWindowDefaultTextButtonSet(tabWindow, info)
  tabWindow.leftButton:Enable(false)
  tabWindow.spinnerWnd:SetState(false)
  tabWindow.spinnerWnd:SetValue(0)
  local allExtractButton = tabWindow:CreateChildWidget("button", "allExtractButton", 0, true)
  allExtractButton:SetText(GetCommonText("extract_all"))
  ApplyButtonSkin(allExtractButton, BUTTON_BASIC.DEFAULT)
  allExtractButton:AddAnchor("BOTTOM", tabWindow, 0, 0)
  allExtractButton:Show(false)
  function allExtractButton:OnClick()
    local diagInfo = {}
    diagInfo.isAll = true
    diagInfo.value = 0
    diagInfo.title = GetCommonText("extract_all")
    diagInfo.body = GetCommonText("extract_all_msg")
    diagInfo.itemInfo = X2ItemEnchant:GetEnchantItemInfo()
    diagInfo.itemMaxCount = maxEnchantNum
    diagInfo.itemUseCount = usedSocketNum
    diagInfo.ExecuteFunc = Execute
    diagInfo.removeItems = {}
    for i = 1, #socketInfo do
      local info = socketInfo[i]
      if info ~= nil and not info.extractable then
        diagInfo.removeItems[#diagInfo.removeItems + 1] = info
      end
    end
    PopupExtractNoticeDialog(tabWindow:GetId(), diagInfo)
  end
  allExtractButton:SetHandler("OnClick", allExtractButton.OnClick)
  local function GetSubMenuChangedInfo(index)
    if index == nil or index ~= TAB_INDEX.INSTALL and index ~= TAB_INDEX.REMOVE and index ~= TAB_INDEX.EXTRACT and index ~= TAB_INDEX.UPGRADE then
      return
    end
    local info = {}
    if index == TAB_INDEX.INSTALL then
      info.coords = "socket_purple"
      info.targetText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.SOCKET_ITEM.TARGET_TEXT
      info.enchantText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.SOCKET_ITEM.ENCHANT_TEXT
      info.color = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.SOCKET_ITEM.FONT_COLOR
      info.anchor = {0, 245}
      info.btnLeftStr = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.BOTTOM_BUTTON_STR.LEFT.SOCKETING
      info.enchantTip = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.SOCKET_ITEM.TOOLTIP
      info.visible = true
    elseif index == TAB_INDEX.REMOVE then
      info.coords = "socket_gray_blue"
      info.targetText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.CONVERT_ITEM.TARGET_TEXT
      info.enchantText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.CONVERT_ITEM.ENCHANT_TEXT
      info.color = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.CONVERT_ITEM.FONT_COLOR
      info.anchor = {0, 210}
      info.btnLeftStr = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.BOTTOM_BUTTON_STR.LEFT.UNSOCKET
      info.enchantTip = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.CONVERT_ITEM.TOOLTIP
      info.visible = false
    elseif index == TAB_INDEX.EXTRACT then
      info.coords = "socket_gray_blue"
      info.targetText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.EXTRACT_ITEM.TARGET_TEXT
      info.enchantText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.EXTRACT_ITEM.ENCHANT_TEXT
      info.color = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.EXTRACT_ITEM.FONT_COLOR
      info.anchor = {0, 210}
      info.btnLeftStr = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.BOTTOM_BUTTON_STR.LEFT.EXTRACT
      info.enchantTip = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.EXTRACT_ITEM.TOOLTIP
      info.visible = false
    elseif index == TAB_INDEX.UPGRADE then
      info.coords = "socket_gray_blue"
      info.targetText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.UPGRADE_ITEM.TARGET_TEXT
      info.enchantText = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.UPGRADE_ITEM.ENCHANT_TEXT
      info.color = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.UPGRADE_ITEM.FONT_COLOR
      info.anchor = {0, 201}
      info.btnLeftStr = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.BOTTOM_BUTTON_STR.LEFT.UPGRADE
      info.enchantTip = WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.UPGRADE_ITEM.TOOLTIP
      info.visible = false
    end
    return info
  end
  function tabWindow.tabSubMenu:OnClickProc(index)
    local info = GetSubMenuChangedInfo(index)
    tabWindow.slotTargetItem.label:SetText(info.targetText)
    tabWindow.slotEnchantItem.bg:SetTextureInfo(info.coords)
    tabWindow.slotEnchantItem.label:SetText(info.enchantText)
    ApplyTextColor(tabWindow.slotEnchantItem.label, info.color)
    tabWindow.slotEnchantItem.tooltip = info.enchantTip
    tabWindow.curEnchantInfoFrame:Show(info.visible)
    tabWindow.socketListFrame:RemoveAllAnchors()
    tabWindow.socketListFrame:AddAnchor("TOPLEFT", tabWindow, info.anchor[1], info.anchor[2])
    tabWindow.leftButton:SetText(info.btnLeftStr)
    tabWindow.socketListFrame:Clear()
    if index == TAB_INDEX.INSTALL then
      tabWindow.rightButton:RemoveAllAnchors()
      tabWindow.leftButton:RemoveAllAnchors()
      X2ItemEnchant:SwitchItemEnchantSocketInsertMode()
      tabWindow.spinnerWnd:SetValue(1)
      tabWindow.spinnerWnd:Show(true)
      local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
      tabWindow.rightButton:AddAnchor("BOTTOMRIGHT", tabWindow, "BOTTOMRIGHT", 0, -sideMargin)
      tabWindow.leftButton:AddAnchor("RIGHT", tabWindow.rightButton, "LEFT", 0, 0)
      allExtractButton:Show(false)
    elseif index == TAB_INDEX.REMOVE then
      X2ItemEnchant:SwitchItemEnchantSocketRemoveMode()
      tabWindow.spinnerWnd:Show(false)
      tabWindow.leftButton:RemoveAllAnchors()
      tabWindow.rightButton:RemoveAllAnchors()
      local buttonTable = {
        tabWindow.leftButton,
        tabWindow.rightButton
      }
      ReanchorDefaultTextButtonSet(buttonTable, tabWindow, -GetWindowMargin())
      allExtractButton:Show(false)
    elseif index == TAB_INDEX.EXTRACT then
      X2ItemEnchant:SwitchItemEnchantSocketExtractMode()
      tabWindow.spinnerWnd:Show(false)
      local buttonTable = {
        tabWindow.leftButton,
        allExtractButton,
        tabWindow.rightButton
      }
      local maxWidth = AdjustBtnLongestTextWidth(buttonTable)
      tabWindow.leftButton:RemoveAllAnchors()
      tabWindow.rightButton:RemoveAllAnchors()
      allExtractButton:RemoveAllAnchors()
      tabWindow.leftButton:AddAnchor("BOTTOMRIGHT", tabWindow, "BOTTOM", -maxWidth / 2, -GetWindowMargin())
      allExtractButton:AddAnchor("BOTTOM", tabWindow, 0, -GetWindowMargin())
      tabWindow.rightButton:AddAnchor("BOTTOMLEFT", tabWindow, "BOTTOM", maxWidth / 2, -GetWindowMargin())
      allExtractButton:Show(true)
    elseif index == TAB_INDEX.UPGRADE then
      X2ItemEnchant:SwitchItemEnchantSocketUpgradeMode()
      tabWindow.spinnerWnd:Show(false)
      local data = {
        type = "labor_power",
        value = 0
      }
      tabWindow.laborPower:SetData(data)
      tabWindow.laborPower:RemoveAllAnchors()
      tabWindow.laborPower:AddAnchor("TOP", tabWindow.socketUpgradeFrame, "BOTTOM", 0, 11)
      tabWindow.leftButton:RemoveAllAnchors()
      tabWindow.rightButton:RemoveAllAnchors()
      local buttonTable = {
        tabWindow.leftButton,
        tabWindow.rightButton
      }
      ReanchorDefaultTextButtonSet(buttonTable, tabWindow, -GetWindowMargin())
      allExtractButton:Show(false)
    end
    tabWindow:ResetSubTabLayout(index)
    tabWindow:SlotAllUpdate(false)
    tabWindow.index = index
  end
  local MakeModifierString = function(socketItemInfo, fontColor)
    local modifierStr = ""
    for index = 1, #socketItemInfo.modifier do
      local modifier = socketItemInfo.modifier[index]
      if modifierStr ~= "" then
        modifierStr = string.format([[
%s
%s]], modifierStr, GetAddModifierText(modifier), fontColor)
      else
        modifierStr = GetAddModifierText(modifier, fontColor)
      end
    end
    if fontColor == nil then
      fontColor = FONT_COLOR_HEX.GREEN
    end
    if socketItemInfo.skill_modifier_tooltip ~= nil and socketItemInfo.skill_modifier_tooltip ~= "" then
      if modifierStr ~= "" then
        modifierStr = string.format([[
%s
%s%s]], modifierStr, fontColor, socketItemInfo.skill_modifier_tooltip)
      else
        modifierStr = string.format("%s%s", fontColor, socketItemInfo.skill_modifier_tooltip)
      end
    end
    if socketItemInfo.buff_modifier_tooltip ~= nil and socketItemInfo.buff_modifier_tooltip ~= "" then
      if modifierStr ~= "" then
        modifierStr = string.format([[
%s
%s%s]], modifierStr, fontColor, socketItemInfo.buff_modifier_tooltip)
      else
        modifierStr = string.format("%s%s", fontColor, socketItemInfo.buff_modifier_tooltip)
      end
    end
    return modifierStr
  end
  function tabWindow.slotTargetItem:Update(isLock)
    local function UpdateSocketFrame()
      for i = 1, #tabWindow.socketListFrame.item do
        tabWindow.socketListFrame.item[i]:Show(false)
        socketInfo[i] = nil
      end
      local itemInfo = X2ItemEnchant:GetTargetItemInfo()
      UpdateSlot(self, itemInfo, true)
      if itemInfo ~= nil then
        allEquip = false
        if itemInfo.socketInfo.maxSocket ~= nil then
          local maxSocket = math.min(#tabWindow.socketListFrame.item, itemInfo.socketInfo.maxSocket)
          allEquip = true
          for i = 1, maxSocket do
            local item = tabWindow.socketListFrame.item[i]
            item:Show(true)
            local itemType = itemInfo.socketInfo.socketItem[i] or 0
            if itemType ~= 0 then
              local socketItemInfo = X2Item:GetItemInfoByType(itemType, 0, IIK_TYPE + IIK_SOCKET_MODIFIER)
              socketInfo[i] = socketItemInfo
              local modifierStr = MakeModifierString(socketItemInfo)
              if socketItemInfo.extractable ~= nil and not socketItemInfo.extractable then
                tabWindow.not_extractable = true
              end
              item:SetInfo(socketItemInfo.lookType, modifierStr)
              item:SetWidth(tabWindow.socketListFrame:GetWidth() - 26)
              usedSocketNum = usedSocketNum + 1
            else
              item:SetInfo(nil, "")
              allEquip = false
            end
          end
        end
        if not allEquip and itemInfo.item_socketing_cost ~= nil then
          tabWindow.money:Show(true)
          local data = {
            type = "cost",
            currency = itemInfo.item_socketing_currency,
            value = itemInfo.item_socketing_cost,
            guideTooltip = GetCommonText("socketing_cost_tooltip")
          }
          tabWindow.money:SetData(data)
        else
          tabWindow.money:Show(false)
        end
        tabWindow.extractWarningText:Show(tabWindow.not_extractable)
        return true, allEquip
      else
        tabWindow.socketListFrame:Clear()
        return false, false
      end
    end
    local function UpdateSocketUpgradeFrame(isLock)
      local itemInfo = X2ItemEnchant:GetTargetItemInfo()
      UpdateSlot(self, itemInfo, true)
      if isLock then
        return itemInfo ~= nil, false
      end
      selectSlotBit = 0
      tabWindow.socketUpgradeFrame.items[0].checkBox:SetChecked(false, false)
      for i = 1, #tabWindow.socketUpgradeFrame.items do
        tabWindow.socketUpgradeFrame.items[i]:Show(false)
        tabWindow.socketUpgradeFrame.items[i].checkBox:SetChecked(false, true)
      end
      if itemInfo ~= nil then
        for i = 1, itemInfo.socketInfo.maxSocket do
          local item = tabWindow.socketUpgradeFrame.items[i]
          item:Show(true)
          local itemType = itemInfo.socketInfo.socketItem[i] or 0
          local changeInfo
          if itemInfo.changeInfos ~= nil then
            changeInfo = itemInfo.changeInfos[i]
          end
          if itemType ~= 0 then
            local socketItemInfo = X2Item:GetItemInfoByType(itemType, 0, IIK_TYPE + IIK_SOCKET_MODIFIER)
            local fontColor
            if changeInfo ~= nil and (changeInfo.state == ISUS_MAX_UPGRADE or changeInfo.state == ISUS_MISS_MATCH) then
              fontColor = FONT_COLOR_HEX.GRAY
            end
            local modifierStr = MakeModifierString(socketItemInfo, fontColor)
            item:SetInfo(socketItemInfo.lookType, modifierStr, changeInfo)
          else
            item:SetInfo(nil, "", changeInfo)
          end
          item.socketItemType = itemType
        end
      end
      local result = X2ItemEnchant:SetSocketUpgradeSelect(0, false, selectSlotBit)
      local enableList = false
      if result ~= nil then
        enableList = result.enableList
      end
      tabWindow.socketUpgradeFrame:EnableList(enableList)
      return itemInfo ~= nil, false
    end
    tabWindow.not_extractable = false
    if tabWindow.index == TAB_INDEX.UPGRADE then
      return UpdateSocketUpgradeFrame(isLock)
    else
      return UpdateSocketFrame()
    end
  end
  SetTargetItemClickFunc(tabWindow.slotTargetItem)
  function tabWindow.slotEnchantItem:Update()
    local itemInfo = X2ItemEnchant:GetEnchantItemInfo()
    UpdateSlot(self, itemInfo)
    if tabWindow.index == TAB_INDEX.UPGRADE and itemInfo ~= nil then
      self:SetStack(itemInfo.total)
    else
      self:SetStack(0)
    end
    if itemInfo ~= nil then
      local modifierStr = ""
      if itemInfo.modifier ~= nil then
        for index = 1, #itemInfo.modifier do
          local modifier = itemInfo.modifier[index]
          if modifierStr ~= "" then
            modifierStr = string.format([[
%s
%s]], modifierStr, GetAddModifierText(modifier))
          else
            modifierStr = GetAddModifierText(modifier)
          end
        end
      end
      if itemInfo.skill_modifier_tooltip ~= nil and itemInfo.skill_modifier_tooltip ~= "" then
        if modifierStr ~= "" then
          modifierStr = string.format([[
%s
%s%s]], modifierStr, FONT_COLOR_HEX.GREEN, itemInfo.skill_modifier_tooltip)
        else
          modifierStr = string.format("%s%s", FONT_COLOR_HEX.GREEN, itemInfo.skill_modifier_tooltip)
        end
      end
      if itemInfo.buff_modifier_tooltip ~= nil and itemInfo.buff_modifier_tooltip ~= "" then
        if modifierStr ~= "" then
          modifierStr = string.format([[
%s
%s%s]], modifierStr, FONT_COLOR_HEX.GREEN, itemInfo.buff_modifier_tooltip)
        else
          modifierStr = string.format("%s%s", FONT_COLOR_HEX.GREEN, itemInfo.buff_modifier_tooltip)
        end
      end
      if modifierStr ~= "" then
        tabWindow.curEnchantInfoFrame.info:Show(true)
        tabWindow.curEnchantInfoFrame.info:SetInfo(itemInfo.itemType, modifierStr)
      end
      self.procOnEnter = nil
      local extraCost = X2ItemEnchant:GetSocketingExtraCost()
      if extraCost == 0 then
        extraCost = 1 or extraCost
      end
      if tabWindow.index == TAB_INDEX.INSTALL then
        maxEnchantNum = math.min(math.floor(X2Bag:CountBagItemByItemType(itemInfo.itemType) / extraCost), X2ItemEnchant:GetItemSocketMax())
      else
        maxEnchantNum = X2Bag:CountBagItemByItemType(itemInfo.itemType)
      end
      tabWindow.spinnerWnd:SetMinMaxValues(1, maxEnchantNum)
      return true
    else
      tabWindow.curEnchantInfoFrame.info:Show(false)
      tabWindow.curEnchantInfoFrame.info:SetInfo(nil, "")
      function self:procOnEnter()
        if self.tooltip == nil then
          return
        end
        SetTooltip(self.tooltip, self)
      end
      tabWindow.spinnerWnd:SetMinMaxValues(1, 1)
      tabWindow.spinnerWnd:SetValue(1)
      return false
    end
  end
  SetEnchantItemClickFunc(tabWindow.slotEnchantItem)
  local function SetWarningText(subSelIndex, isAllEquip)
    if subSelIndex == nil then
      return
    end
    if subSelIndex == TAB_INDEX.INSTALL then
      if isAllEquip then
        tabWindow:SetWarningText(GetCommonText("socket_enchant_waring_text_all_socketing"), subSelIndex)
        tabWindow.slotEnchantItem:SetAlpha(0.5)
      else
        local enchantItem = X2ItemEnchant:GetEnchantItemInfo()
        local extraCost = X2ItemEnchant:GetSocketingExtraCost()
        if extraCost ~= nil and enchantItem ~= nil then
          if extraCost > 0 then
            if enchantItem.fail_break then
              text = GetCommonText("socket_enchant_waring_text_extra_cost_socketing_fail_break", tostring(extraCost))
            else
              text = GetCommonText("socket_enchant_waring_text_extra_cost_socketing", tostring(extraCost))
            end
          elseif enchantItem.fail_break then
            text = GetCommonText("socket_enchant_waring_text_socketing_fail_break")
          else
            text = GetCommonText("socket_enchant_waring_text_socketing")
          end
        end
        tabWindow:SetWarningText(text, subSelIndex)
        tabWindow.slotEnchantItem:SetAlpha(1)
      end
      tabWindow.extractWarningText:SetAlpha(0)
    elseif subSelIndex == TAB_INDEX.REMOVE then
      tabWindow:SetWarningText(WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.WARNING_TEXT.TEXT.CONVERT, subSelIndex)
      tabWindow.slotEnchantItem:SetAlpha(1)
      tabWindow.extractWarningText:SetAlpha(0)
    elseif subSelIndex == TAB_INDEX.EXTRACT then
      tabWindow:SetWarningText(WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.WARNING_TEXT.TEXT.EXTRACT, subSelIndex)
      tabWindow.slotEnchantItem:SetAlpha(1)
      tabWindow.extractWarningText:SetAlpha(1)
    elseif subSelIndex == TAB_INDEX.UPGRADE then
      tabWindow:SetWarningText(WINDOW_ENCHANT.SOCKET_ENCHANT_TAB.WARNING_TEXT.TEXT.UPGRADE, subSelIndex)
      tabWindow.slotEnchantItem:SetAlpha(1)
      tabWindow.extractWarningText:SetAlpha(1)
    end
  end
  function tabWindow:SlotAllUpdate(isExcutable, isLock)
    usedSocketNum = 0
    maxEnchantNum = 0
    self.money:Show(false)
    self.extractWarningText:Show(false)
    local targetInfoExist, isAllEquip = self.slotTargetItem:Update(isLock)
    local enchatInfoExist = self.slotEnchantItem:Update()
    tabWindow.isExcutable = isExcutable
    if isAllEquip then
      self.warningText:Show(true)
    elseif targetInfoExist and enchatInfoExist then
      self.warningText:Show(true)
    else
      self.warningText:Show(false)
    end
    self.laborPower:Show(false)
    if tabWindow.index == TAB_INDEX.EXTRACT then
      if usedSocketNum ~= 0 and usedSocketNum <= maxEnchantNum then
        allExtractButton:Enable(isExcutable)
      else
        allExtractButton:Enable(false)
      end
      self.leftButton:Enable(isExcutable and tabWindow.socketListFrame.selectIndex ~= nil)
    elseif tabWindow.index == TAB_INDEX.UPGRADE then
      self.socketUpgradeFrame.items[0].checkBox:Enable(isExcutable and not isLock)
      self.laborPower:Show(self.warningText:IsVisible())
      self.leftButton:Enable(selectSlotBit ~= 0 and not isLock)
    else
      self.leftButton:Enable(isExcutable)
    end
    self.spinnerWnd:SetState(isExcutable)
    if X2ItemEnchant:IsWorkingEnchant() then
      self.spinnerWnd:SetValue(X2ItemEnchant:GetLeftBatchCount())
    end
    self.slotTargetItem:Enable(not isLock)
    self.slotEnchantItem:Enable(not isLock)
    SetWarningText(tabWindow.tabSubMenu.selIndex, isAllEquip)
    if isLock then
      self.slotTargetItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
      self.slotEnchantItem:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    else
      self.slotTargetItem:SetOverlay(self.slotTargetItem:GetInfo())
      self.slotEnchantItem:SetOverlay(self.slotEnchantItem:GetInfo())
    end
  end
  tabWindow.socketListFrame.selectIndex = nil
  function tabWindow.socketListFrame:Selected(index)
    if tabWindow.index ~= TAB_INDEX.EXTRACT then
      return
    end
    tabWindow.socketListFrame.selectIndex = index
    for i = 1, #tabWindow.socketListFrame.item do
      local item = tabWindow.socketListFrame.item[i]
      if i == tabWindow.socketListFrame.selectIndex then
        item:ShowBg(true, 0.6)
      else
        item:ShowBg(false)
      end
    end
    tabWindow.leftButton:Enable(tabWindow.isExcutable and tabWindow.socketListFrame.selectIndex ~= nil)
  end
  function tabWindow.socketListFrame:Clear()
    tabWindow.socketListFrame.selectIndex = nil
    for i = 1, #tabWindow.socketListFrame.item do
      local item = tabWindow.socketListFrame.item[i]
      item:ShowBg(false)
    end
  end
  function tabWindow.socketListFrame:Entered(index)
    if tabWindow.index ~= TAB_INDEX.EXTRACT then
      return
    end
    if index ~= tabWindow.socketListFrame.selectIndex then
      local item = tabWindow.socketListFrame.item[index]
      item:ShowBg(true, 0.4)
    end
  end
  function tabWindow.socketListFrame:Leaved(index)
    if tabWindow.index ~= TAB_INDEX.EXTRACT then
      return
    end
    if index ~= tabWindow.socketListFrame.selectIndex then
      local item = tabWindow.socketListFrame.item[index]
      item:ShowBg(false)
    end
  end
  for i = 1, #tabWindow.socketListFrame.item do
    do
      local item = tabWindow.socketListFrame.item[i]
      function item:OnClick()
        if item.itemType ~= nil then
          tabWindow.socketListFrame:Selected(i)
        end
      end
      item:SetHandler("OnClick", item.OnClick)
      function item:OnEnter()
        if item.itemType ~= nil then
          tabWindow.socketListFrame:Entered(i)
        end
      end
      item:SetHandler("OnEnter", item.OnEnter)
      function item:OnLeave()
        if item.itemType ~= nil then
          tabWindow.socketListFrame:Leaved(i)
        end
      end
      item:SetHandler("OnLeave", item.OnLeave)
    end
  end
  function tabWindow.socketUpgradeFrame:EnableList(enable)
    for i = 1, #tabWindow.socketUpgradeFrame.items do
      local item = tabWindow.socketUpgradeFrame.items[i]
      if item:IsVisible() and item.socketItemType ~= 0 then
        local socketItemInfo = X2Item:GetItemInfoByType(item.socketItemType, 0, IIK_TYPE + IIK_SOCKET_MODIFIER)
        local fontColor
        if not enable and item.state == ISUS_UPGRADE and not item.checkBox:GetChecked() then
          fontColor = FONT_COLOR_HEX.GRAY
        elseif item.state ~= ISUS_UPGRADE then
          fontColor = FONT_COLOR_HEX.GRAY
        end
        local modifierStr = MakeModifierString(socketItemInfo, fontColor)
        item.widgetInfo.itemName:SetText(modifierStr)
      end
      item:SetUpgradeSlotEnable(enable)
    end
  end
  for i = 0, #tabWindow.socketUpgradeFrame.items do
    local checkBox = tabWindow.socketUpgradeFrame.items[i].checkBox
    local function OnCheckChanged(obj)
      local result = X2ItemEnchant:SetSocketUpgradeSelect(obj.index, obj:GetChecked(), selectSlotBit)
      if result == nil then
        return
      end
      selectSlotBit = result.selectBitFlag
      tabWindow.socketUpgradeFrame:EnableList(result.enableList)
      local data = {
        type = "labor_power",
        value = result.consumeLp
      }
      tabWindow.laborPower:SetData(data)
      tabWindow.leftButton:Enable(selectSlotBit ~= 0)
      if not obj:GetChecked() then
        tabWindow.socketUpgradeFrame.items[0].checkBox:SetChecked(false, false)
      end
    end
    local function OnAllCheckChanged(obj)
      for i = 1, #tabWindow.socketUpgradeFrame.items do
        local item = tabWindow.socketUpgradeFrame.items[i]
        if item.state == ISUS_UPGRADE and item.checkBox:IsEnabled() and item.checkBox:GetChecked() ~= obj:GetChecked() then
          item.checkBox:SetChecked(obj:GetChecked(), true)
        end
      end
    end
    if i == 0 then
      checkBox:SetHandler("OnCheckChanged", OnAllCheckChanged)
    else
      checkBox:SetHandler("OnCheckChanged", OnCheckChanged)
    end
  end
end
