changeItemLookWindow = nil
function SetChangeItemLookEventFunction(widget, interactionNum)
  local parent = widget:GetParent()
  function widget:Update()
    self.baseItem:Update()
    self.lookItem:Update()
    self.newItem:Update()
    self.materials:Update()
  end
  function widget:Clear()
    X2ItemLookConverter:ClearConvertBaseItemSlot()
    X2ItemLookConverter:ClearConvertLookItemSlot()
    X2ItemLookConverter:ClearExtractConvertedItemSlot()
    self:Update()
  end
  function widget:ShowProc()
    if changeItemLookWindow.changeItemLook:IsVisible() then
      X2ItemLookConverter:EnterItemConvertMode(interactionNum ~= nil, false)
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      X2ItemLookConverter:EnterItemConvertMode(interactionNum ~= nil, true)
    end
    ADDON:ShowContent(UIC_BAG, true)
    self:Update()
  end
  function parent:ShowProc()
    widget:ShowProc()
  end
  function parent:OnHide()
    if changeItemLookWindow.changeItemLook:IsVisible() then
      self.changeItemLook:Clear()
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      self.ExtractItemLook:Clear()
    end
    X2ItemLookConverter:LeaveItemConvertMode()
    if interactionNum ~= nil then
      interactionWindows[interactionNum].window = nil
    end
    widget:Show(false)
    changeItemLookWindow = nil
  end
  parent:SetHandler("OnHide", parent.OnHide)
  function widget:OnHide()
    X2ItemLookConverter:LeaveItemConvertMode()
  end
  widget:SetHandler("OnHide", widget.OnHide)
  function widget:OnShow()
    if changeItemLookWindow.changeItemLook:IsVisible() then
      X2ItemLookConverter:EnterItemConvertMode(interactionNum ~= nil, false)
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      X2ItemLookConverter:EnterItemConvertMode(interactionNum ~= nil, true)
    end
  end
  widget:SetHandler("OnShow", widget.OnShow)
  local npcInteractionEvents = {
    NPC_INTERACTION_END = function(widget)
      if interactionNum ~= nil then
        parent:Show(false)
      end
    end,
    UPDATE_ITEM_LOOK_CONVERT_MODE = function()
      if changeItemLookWindow == nil then
        return false
      end
      if changeItemLookWindow:IsVisible() == false then
        return false
      end
      if changeItemLookWindow.changeItemLook:IsVisible() then
        changeItemLookWindow.changeItemLook:Update()
      elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
        changeItemLookWindow.ExtractItemLook:Update()
      end
    end,
    ITEM_LOOK_CONVERTED = function()
      widget:Clear()
    end
  }
  widget:SetHandler("OnEvent", function(this, event, ...)
    npcInteractionEvents[event](this, ...)
  end)
  RegistUIEvent(widget, npcInteractionEvents)
  function widget.baseItem:Update()
    code = self:GetParent().code
    if changeItemLookWindow.changeItemLook:IsVisible() then
      local itemInfo = X2ItemLookConverter:GetConvertBaseItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        self.name.style:SetColor(color[1], color[2], color[3], color[4])
        self.name:SetText(itemInfo.name)
        self.item:SetItemInfo(itemInfo)
        self.item.procOnEnter = nil
        self.item:SetStack(stackCount)
        self.itemType = itemInfo.itemType
      else
        self.item:Init()
        self.name:SetText("")
        self.itemType = nil
        function self.item:procOnEnter()
          local anchorInfos = {
            myAnchor = "TOPLEFT",
            targetAnchor = "BOTTOMRIGHT",
            x = 7,
            y = 7
          }
          local str = locale.lookConverter.baseItemTooltip(string.format("|c%s", Dec2Hex(FONT_COLOR.STAT_ITEM)))
          ShowTextTooltip(self, nil, str, anchorInfos)
        end
      end
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      local itemInfo = X2ItemLookConverter:GetExtractBaseItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        self.name.style:SetColor(color[1], color[2], color[3], color[4])
        self.name:SetText(itemInfo.name)
        self.item:SetItemInfo(itemInfo)
        self.item.procOnEnter = nil
        self.item:SetStack(stackCount)
        self.itemType = itemInfo.itemType
      else
        self.item:Init()
        self.name:SetText("")
        self.itemType = nil
        function self.item:procOnEnter()
          local anchorInfos = {
            myAnchor = "TOPLEFT",
            targetAnchor = "BOTTOMRIGHT",
            x = 7,
            y = 7
          }
          local str = locale.lookConverter.extractBaseItemTooltip(string.format("|c%s", Dec2Hex(FONT_COLOR.STAT_ITEM)))
          ShowTextTooltip(self, nil, str, anchorInfos)
        end
      end
    end
  end
  local function BaseItemButtonLeftClickFunc()
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 and changeItemLookWindow.changeItemLook:IsVisible() and X2ItemLookConverter:SetConvertBaseItemSlotFromPick() then
      widget:Update()
    end
  end
  local function BaseItemButtonRightClickFunc()
    if changeItemLookWindow.changeItemLook:IsVisible() then
      X2ItemLookConverter:ClearConvertBaseItemSlot()
      widget:Update()
    end
  end
  ButtonOnClickHandler(widget.baseItem.item, BaseItemButtonLeftClickFunc, BaseItemButtonRightClickFunc)
  function widget.lookItem:Update()
    code = self:GetParent().code
    if changeItemLookWindow.changeItemLook:IsVisible() then
      local itemInfo = X2ItemLookConverter:GetConvertLookItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        self.name.style:SetColor(color[1], color[2], color[3], color[4])
        self.name:SetText(itemInfo.name)
        self.item:SetItemInfo(itemInfo)
        self.item.procOnEnter = nil
        self.item:SetStack(stackCount)
        self.itemType = itemInfo.itemType
      else
        self.item:Init()
        self.name:SetText("")
        self.itemType = nil
        function self.item:procOnEnter()
          local anchorInfos = {
            myAnchor = "TOPLEFT",
            targetAnchor = "BOTTOMRIGHT",
            x = 7,
            y = 7
          }
          local str = locale.lookConverter.lookItemTooltip(string.format("|c%s", Dec2Hex(FONT_COLOR.SKIN_ITEM)))
          ShowTextTooltip(self, nil, str, anchorInfos)
        end
      end
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      local itemInfo = X2ItemLookConverter:GetExtractLookItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        self.name.style:SetColor(color[1], color[2], color[3], color[4])
        self.name:SetText(itemInfo.name)
        self.item:SetItemInfo(itemInfo)
        self.item.procOnEnter = nil
        self.item:SetStack(stackCount)
        self.itemType = itemInfo.itemType
      else
        self.item:Init()
        self.name:SetText("")
        self.itemType = nil
        function self.item:procOnEnter()
          local anchorInfos = {
            myAnchor = "TOPLEFT",
            targetAnchor = "BOTTOMRIGHT",
            x = 7,
            y = 7
          }
          local str = locale.lookConverter.extractLookItemTooltip(string.format("|c%s", Dec2Hex(FONT_COLOR.SKIN_ITEM)))
          ShowTextTooltip(self, nil, str, anchorInfos)
        end
      end
    end
  end
  local function LookItemButtonLeftClickFunc()
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 and changeItemLookWindow.changeItemLook:IsVisible() and X2ItemLookConverter:SetConvertLookItemSlotFromPick() then
      widget:Update()
    end
  end
  local function LookItemButtonRightClickFunc()
    if changeItemLookWindow.changeItemLook:IsVisible() then
      X2ItemLookConverter:ClearConvertLookItemSlot()
      widget:Update()
    end
  end
  ButtonOnClickHandler(widget.lookItem.item, LookItemButtonLeftClickFunc, LookItemButtonRightClickFunc)
  function widget.newItem:Update()
    code = self:GetParent().code
    if changeItemLookWindow.changeItemLook:IsVisible() then
      local itemInfo = X2ItemLookConverter:GetConvertResultItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        self.name.style:SetColor(color[1], color[2], color[3], color[4])
        self.name:SetText(itemInfo.name)
        self.item:SetItemInfo(itemInfo)
        self.item:SetAlpha(1)
      else
        self.item:Init()
        self.item:SetAlpha(1)
        self.name:SetText("")
      end
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      local itemInfo = X2ItemLookConverter:GetExtractConvertedItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        self.name.style:SetColor(color[1], color[2], color[3], color[4])
        self.name:SetText(itemInfo.name)
        self.item:SetItemInfo(itemInfo)
        self.item:SetAlpha(1)
      else
        self.item:Init()
        self.item:SetAlpha(1)
        self.name:SetText("")
      end
    end
  end
  local function NewItemButtonLeftClickFunc()
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 and X2ItemLookConverter:SetExtractConvertedItemSlotFromPick() then
      widget:Update()
    end
  end
  local function NewItemButtonRightClickFunc()
    X2ItemLookConverter:ClearExtractConvertedItemSlot()
    widget:Update()
  end
  ButtonOnClickHandler(widget.newItem.item, NewItemButtonLeftClickFunc, NewItemButtonRightClickFunc)
  function widget.materials:ClearAll()
    for i = 1, #self.items do
      local item = self.items[i]
      item:Init()
      item:SetAlpha(0.5)
    end
    self.feeFrame:Show(false)
  end
  function widget.materials:Update()
    if changeItemLookWindow.changeItemLook:IsVisible() then
      self:ClearAll()
      widget.leftButton:Enable(true)
      widget.leftButton.tooltip = nil
      local info = X2ItemLookConverter:GetItemLookConvertInfo()
      if info ~= nil then
        if info.money ~= "0" then
          local data = {
            type = "exchange_fee",
            value = info.money
          }
          self.feeFrame:Show(true)
          self.feeFrame:SetData(data)
        end
        if not info.enoughMoney then
          widget.leftButton:Enable(false)
          widget.leftButton.tooltip = X2Locale:LocalizeUiText(ERROR_MSG, "NOT_ENOUGH_MONEY")
        end
        for i = 1, #info.items do
          local item = self.items[i]
          local itemInfo = X2Item:GetItemInfoByType(info.items[i].itemType)
          item:SetItemInfo(itemInfo)
          item:SetAlpha(1)
          item:SetStack(info.items[i].has, info.items[i].need)
        end
        if not info.enoughItems then
          widget.leftButton:Enable(false)
          widget.leftButton.tooltip = X2Locale:LocalizeUiText(ERROR_MSG, "CRAFT_MATERIAL_REQUIRED")
        end
      else
        widget.leftButton:Enable(false)
      end
    elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
      self:ClearAll()
      widget.leftButton:Enable(true)
      widget.leftButton.tooltip = nil
      local info = X2ItemLookConverter:GetItemLookExtractInfo()
      if info ~= nil then
        if info.money ~= "0" then
          self.feeFrame:Show(true)
          self.feeFrame:SetValue("money", info.money)
        end
        if info.enoughMoney then
        else
          widget.leftButton:Enable(false)
          widget.leftButton.tooltip = X2Locale:LocalizeUiText(ERROR_MSG, "NOT_ENOUGH_MONEY")
        end
        for i = 1, #info.items do
          local item = self.items[i]
          local itemInfo = X2Item:GetItemInfoByType(info.items[i].itemType)
          item:SetItemInfo(itemInfo)
          item:SetAlpha(1)
          item:SetStack(info.items[i].has, info.items[i].need)
        end
        if not info.enoughItems then
          widget.leftButton:Enable(false)
          widget.leftButton.tooltip = X2Locale:LocalizeUiText(ERROR_MSG, "CRAFT_MATERIAL_REQUIRED")
        end
      else
        widget.leftButton:Enable(false)
      end
    end
  end
  local OnEnter = function(self)
    if self.tooltip ~= nil then
      SetTooltip(self.tooltip, self)
    end
  end
  widget.leftButton:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  widget.leftButton:SetHandler("OnLeave", OnLeave)
  local function LeftButtonLeftClickFunc()
    local DialogHandler = function(wnd)
      if changeItemLookWindow.changeItemLook:IsVisible() then
        ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_TWO_ITEM_ICON_AND_ONE_NAME)
        wnd:SetTitle(locale.messageBox.lookConverter.title)
        local content = locale.messageBox.lookConverter.body(FONT_COLOR_HEX.RED)
        local itemInfo1 = X2ItemLookConverter:GetConvertBaseItemInfo()
        local itemInfo2 = X2ItemLookConverter:GetConvertResultItemInfo()
        local itemContent = string.format("|c%s[%s]", itemInfo1.gradeColor, itemInfo1.name)
        wnd:SetContentEx(content, itemInfo1, itemInfo2, itemContent)
        function wnd:OkProc()
          X2ItemLookConverter:ConvertItemLook()
        end
      elseif changeItemLookWindow.ExtractItemLook:IsVisible() then
        ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_THREE_ITEM_ICON_AND_ONE_NAME)
        wnd:SetTitle(locale.messageBox.lookExtract.title)
        local content = locale.messageBox.lookExtract.body
        local itemInfo1 = X2ItemLookConverter:GetExtractConvertedItemInfo()
        local itemInfo2 = X2ItemLookConverter:GetExtractBaseItemInfo()
        local itemInfo3 = X2ItemLookConverter:GetExtractLookItemInfo()
        local itemContent = string.format("|c%s[%s]", itemInfo1.gradeColor, itemInfo1.name)
        wnd:SetContentEx(content, itemInfo1, itemInfo2, itemInfo3, itemContent)
        function wnd:OkProc()
          if featureSet.itemlookExtract then
            X2ItemLookConverter:ExtractItemLook()
          end
        end
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, widget:GetParent():GetId())
  end
  widget.leftButton:SetHandler("OnClick", LeftButtonLeftClickFunc)
  local function RightButtonLeftClickFunc()
    parent:Show(false)
  end
  widget.rightButton:SetHandler("OnClick", RightButtonLeftClickFunc)
end
function CreateChangeItemLookWindow(interactionNum)
  local widget = SetViewOfChangeItemLookWindow("itemLookBaseWnd", "UIParent", interactionNum)
  return widget
end
function ToggleChangeItemLookWindow(isShow, interactionNum)
  if isShow == nil then
    isShow = changeItemLookWindow == nil and true or not changeItemLookWindow:IsVisible()
  end
  if isShow and changeItemLookWindow == nil then
    changeItemLookWindow = CreateChangeItemLookWindow(interactionNum)
    changeItemLookWindow:EnableHidingIsRemove(true)
    if interactionNum ~= nil then
      interactionWindows[interactionNum].window = changeItemLookWindow
    end
  end
  if changeItemLookWindow ~= nil then
    changeItemLookWindow:Show(isShow)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_LOOK_CONVERT, ToggleChangeItemLookWindow)
