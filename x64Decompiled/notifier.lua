local repairNotiferValues
local function InitRepairNotifierValues()
  repairNotiferValues = X2:GetCharacterUiData("repairNotiferValues")
  if repairNotiferValues == nil then
    repairNotiferValues = {}
  end
  if repairNotiferValues.confirm == nil then
    repairNotiferValues.confirm = false
  end
end
InitRepairNotifierValues()
local SetViewOfRepairNotifier = function(id, parent)
  local widget = CreateEmptyWindow("repairNotifier", "UIParent")
  local MAX_REPAIR_ICON_COUNT = 5
  local bg = widget:CreateDrawable(TEXTURE_PATH.HUD, "red_balloon", "background")
  bg:AddAnchor("TOPLEFT", widget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.bg = bg
  widget:SetExtent(0, 78)
  widget:Show(false)
  local damageLabel = widget:CreateChildWidget("label", "damageLabel", 0, true)
  damageLabel:SetExtent(100, 20)
  damageLabel:AddAnchor("TOPLEFT", widget, 13, 5)
  damageLabel:SetText(GetUIText(REPAIR_TEXT, "damaged"))
  damageLabel.style:SetFontSize(FONT_SIZE.SMALL)
  ApplyTextColor(damageLabel, FONT_COLOR.RED)
  widget.iconBtns = {}
  for i = 1, MAX_REPAIR_ICON_COUNT do
    local button = CreateItemIconButton("icons[" .. i .. "]", widget)
    button:Show(false)
    button:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    widget.iconBtns[i] = button
  end
  local closeButton = widget:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", widget, -5, 5)
  ApplyButtonSkin(closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  return widget
end
local function CreateRepairNotifier(id, parent)
  local widget = SetViewOfRepairNotifier(id, parent)
  local function SaveRepairNotifierValues()
    X2:SetCharacterUiData("repairNotiferValues", repairNotiferValues)
  end
  function widget:Confirm()
    self:Show(false)
    repairNotiferValues.confirm = true
    SaveRepairNotifierValues()
  end
  function widget:OnClick()
    self:Confirm()
    ADDON:ShowContent(UIC_CHARACTER_INFO, true)
  end
  widget:SetHandler("OnClick", widget.OnClick)
  function widget.closeButton:OnClick()
    widget:Confirm()
  end
  widget.closeButton:SetHandler("OnClick", widget.closeButton.OnClick)
  function widget:Clear()
    for i = 1, #self.iconBtns do
      self.iconBtns[i]:Init()
      self.iconBtns[i]:Show(false)
      self.iconBtns[i]:RemoveAllAnchors()
    end
  end
  local GetDurabilityInfo = function(slot, info)
    local info = {}
    local durability = X2Equipment:ItemDurability(slot, false)
    if durability == nil then
      info.durability = 1
      info.maxDurability = 1
    else
      info.durability = durability.current
      info.maxDurability = durability.max
    end
  end
  function widget:Update()
    local itemTypes, itemGrades, itemSlots = X2Equipment:DameagedItems(#self.iconBtns, false)
    local height = 75
    local width = 12
    local labelHeight = widget.damageLabel:GetHeight()
    if itemTypes == nil or #itemTypes == 0 then
      self:Show(false)
      return
    end
    self:Clear()
    local xOffset = 12
    for i = 1, #itemTypes do
      local itemType = itemTypes[i]
      local itemGrade = itemGrades[i]
      self.iconBtns[i]:Show(true)
      local info = X2Equipment:GetEquippedItemTooltipInfo(itemSlots[i])
      GetDurabilityInfo(itemSlots[i], info)
      self.iconBtns[i]:SetItemInfo(info)
      self.iconBtns[i]:RemoveAllAnchors()
      self.iconBtns[i]:AddAnchor("BOTTOMLEFT", self, xOffset, -19)
      xOffset = xOffset + 35
      self.iconBtns[i].equipSlot = itemSlots[i]
    end
    if #itemTypes < 3 then
      self.damageLabel:Show(false)
      width = width + xOffset
    else
      self.damageLabel:Show(true)
      width = xOffset + 7
    end
    self:SetExtent(width, height)
    self:Show(true)
  end
  local AddDameagedEquipmentTooltipFunc = function(widget)
    function widget:OnEnter()
      if widget.equipSlot == nil then
        return
      end
      local info = X2Equipment:GetEquippedItemTooltipInfo(widget.equipSlot)
      if info == nil then
        return
      end
      ShowTooltip(info, widget, 1, true)
    end
    widget:SetHandler("OnEnter", widget.OnEnter)
    function widget:OnLeave()
      HideTooltip()
    end
    widget:SetHandler("OnLeave", widget.OnLeave)
  end
  for i = 1, #widget.iconBtns do
    AddDameagedEquipmentTooltipFunc(widget.iconBtns[i])
  end
  local durabilityEvents = {
    UPDATE_DURABILITY_STATUS = function(widget, added, removed)
      if repairNotiferValues.confirm == true and removed then
        return
      end
      if added then
        repairNotiferValues.confirm = false
        SaveRepairNotifierValues()
      end
      widget:Update(added, removed)
    end,
    UNIT_EQUIPMENT_CHANGED = function(widget)
      widget:Update()
    end
  }
  widget:SetHandler("OnEvent", function(this, event, ...)
    durabilityEvents[event](this, ...)
  end)
  widget:RegisterEvent("UPDATE_DURABILITY_STATUS")
  widget:RegisterEvent("UNIT_EQUIPMENT_CHANGED")
  return widget
end
local notifier = CreateRepairNotifier("durabilityNotifier", "UIParent")
notifier:AddAnchor("BOTTOMLEFT", GetMainMenuBarButton(MAIN_MENU_IDX.CHARACTER), "TOPLEFT", 0, 2)
if repairNotiferValues.confirm == false then
  notifier:Update()
end
