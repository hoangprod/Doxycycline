local slotsByIndex = {}
local function SetSlotType(slotIdx, slot)
  slotsByIndex[slotIdx] = slot
end
local function GetSlotBySlotIdx(slotIdx)
  return slotsByIndex[slotIdx]
end
local AUXGROUP = {
  ES_EAR_2,
  ES_FINGER_2,
  ES_OFFHAND
}
local function IsAuxEquipSlot(slotNumber)
  for i = 1, #AUXGROUP do
    local auxSlot = AUXGROUP[i]
    if auxSlot == slotNumber then
      return true
    end
  end
  return false
end
local IsExistPreviousSlot = function(itemCount, index)
  if index > 0 then
    return true
  end
  return false
end
local IsExistNextSlot = function(itemCount, index)
  local value = index * 3
  if itemCount - value > 3 then
    return true
  end
  return false
end
local CorrectSoltIndex = function(bagslot, itemCount)
  if bagslot.index < 0 then
    bagslot.index = 0
  end
  local value = bagslot.index * 3
  local diff = itemCount - value
  if diff > 0 then
    return
  end
  bagslot.index = bagslot.index - (math.floor(math.abs(diff) / 3) + 1)
end
local CalcShowItemCount = function(itemCount, index)
  local value = index * 3
  local diff = itemCount - value
  if diff > 3 then
    diff = 3
  end
  return diff
end
function SlotFromEmptyTipText(slotIdx)
  local emptyTip = {
    [ES_HEAD] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_head"),
    [ES_NECK] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_neck"),
    [ES_CHEST] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_chest"),
    [ES_WAIST] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_waist"),
    [ES_LEGS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_legs"),
    [ES_HANDS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_hands"),
    [ES_FEET] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_feet"),
    [ES_ARMS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_arms"),
    [ES_BACK] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_back"),
    [ES_EAR_1] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_ear_1"),
    [ES_EAR_2] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_ear_2"),
    [ES_FINGER_1] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_finger_1"),
    [ES_FINGER_2] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_finger_2"),
    [ES_UNDERSHIRT] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_undershirt"),
    [ES_UNDERPANTS] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_underpants"),
    [ES_MAINHAND] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_mainhand"),
    [ES_OFFHAND] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_offhand"),
    [ES_RANGED] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_ranged"),
    [ES_MUSICAL] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_musical"),
    [ES_BACKPACK] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_backpack"),
    [ES_COSPLAY] = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_slot_es_cosplay")
  }
  if emptyTip[slotIdx] ~= nil then
    return emptyTip[slotIdx]
  else
    return "unknown"
  end
end
function AddEquipmentTooltipFunction(target, tip, equipped, slotIdx)
  target:SetItemInfo(tip)
  function target:OnEnter()
    HideTooltip()
    if lookType == 0 then
      local text = SlotFromEmptyTipText(slotIdx)
      SetTooltip(text, self, true, true)
    else
      ShowTooltip(tip, self, 1, equipped)
    end
  end
  function target:OnLeave()
    HideTooltip()
  end
  target:SetHandler("OnEnter", target.OnEnter)
  target:SetHandler("OnLeave", target.OnLeave)
end
local function ResetSlotRightSide(bagslot, itemCount)
  local up = bagslot.up
  local down = bagslot.down
  local width = 50
  local xSpace = 28
  local nextInset = 10
  local showCount = CalcShowItemCount(itemCount, bagslot.index)
  if itemCount > 3 then
    up:Show(true)
    up:Enable(false)
    down:Show(true)
    down:Enable(false)
  end
  if IsExistPreviousSlot(itemCount, bagslot.index) then
    up:Enable(true)
    width = width + 10
  end
  if IsExistNextSlot(itemCount, bagslot.index) then
    down:Enable(true)
    if bagslot.index < 1 then
      width = width + 10
    end
  else
  end
  width = width + showCount * 33
  for j = 1, 3 do
    local slot = bagslot.slot[j]
    slot:RemoveAllAnchors()
    local xOffset = xSpace + (j - 1) * 33
    slot:AddAnchor("LEFT", bagslot, "LEFT", xOffset, 0)
  end
  bagslot:SetWidth(width)
end
local function ResetSlotLeftSide(bagslot, itemCount)
  local up = bagslot.up
  local down = bagslot.down
  local width = 50
  local xSpace = 23
  local showCount = CalcShowItemCount(itemCount, bagslot.index)
  if itemCount > 3 then
    up:Show(true)
    up:Enable(false)
    down:Show(true)
    down:Enable(false)
  end
  if IsExistPreviousSlot(itemCount, bagslot.index) then
    up:Enable(true)
    do
      local bagslotMax = math.floor(itemCount / 3)
      if bagslotMax == bagslot.index then
        width = width + 10
      end
    end
  else
  end
  if IsExistNextSlot(itemCount, bagslot.index) then
    width = width + 10
    down:Enable(true)
  end
  width = width + showCount * 33
  for j = 1, 3 do
    local slot = bagslot.slot[j]
    slot:RemoveAllAnchors()
    local xOffset = xSpace + (j - 1) * 33
    slot:AddAnchor("RIGHT", bagslot, "RIGHT", -xOffset, 0)
  end
  bagslot:SetWidth(width)
end
for i = 1, #PLAYER_EQUIP_SLOTS do
  do
    local button = equippedItem.slot[i]
    local function OnEnter()
      local slotIdx = PLAYER_EQUIP_SLOTS[i]
      local tooltip = X2Equipment:GetEquippedItemTooltipText("player", slotIdx)
      if tooltip.itemType == 0 then
        local text = SlotFromEmptyTipText(slotIdx)
        SetTooltip(text, button)
      else
        ShowTooltip(tooltip, button, 1, true)
      end
    end
    button:SetHandler("OnEnter", OnEnter)
    local OnHide = function()
      HideTooltip()
    end
    button:SetHandler("OnLeave", OnHide)
  end
end
function equippedItem:Update()
  local index = 1
  local indexY = 1
  for i = 1, #PLAYER_EQUIP_SLOTS do
    local slotIdx = PLAYER_EQUIP_SLOTS[i]
    local tooltip = X2Equipment:GetEquippedItemTooltipText("player", slotIdx)
    local cooldownBtn = equippedItem.slot[i]
    cooldownBtn:SetItemInfo(tooltip)
    cooldownBtn.back:SetColor(1, 1, 1, 1)
    cooldownBtn.id = tooltip.skillType
    local skillType = tooltip.skillType or 0
    cooldownBtn:SetSkill(skillType)
    local items = X2Bag:FindBagItemByEquipSlot(ISLOT_EQUIPMENT, slotIdx)
    local bagButton = equippedItem.bagButton[i]
    local bagslot = equippedItem.bagslot[i]
    local up = bagslot.up
    local down = bagslot.down
    if items ~= nil and #items > 0 then
      bagButton:Show(true)
      for j = 1, 3 do
        local slot = bagslot.slot[j]
        slot:Show(false)
        slot.bagSlot = nil
        up:Show(false)
        down:Show(false)
      end
      local itemCount = #items
      CorrectSoltIndex(bagslot, itemCount)
      if IsLeftSide(i) then
        ResetSlotLeftSide(bagslot, itemCount)
      else
        ResetSlotRightSide(bagslot, itemCount)
      end
      local index = 1
      bagslot.max = itemCount / 3 - 1
      for j = bagslot.index * 3 + 1, itemCount do
        local slot = bagslot.slot[index]
        slot:Show(true)
        local item = items[j]
        slot.bagSlot = item.slot
        slot.isAux = IsAuxEquipSlot(slotIdx)
        AddEquipmentTooltipFunction(slot, item, false, slotIdx)
        if index >= 3 then
          break
        end
        index = index + 1
      end
    else
      bagButton:Show(false)
      bagslot:Show(false)
      up:Show(false)
      down:Show(false)
    end
    SetTooltipDelayTime(0)
  end
end
local FireSystemMsgCanUseBattleField = function()
  if UIParent:GetPermission(UIC_PLAYER_EQUIPMENT) == false then
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_USE_IN_BATTLE_FIELD"))
    return true
  end
  return false
end
for i = 1, #PLAYER_EQUIP_SLOTS do
  do
    local bagButton = equippedItem.bagButton[i]
    local bagslot = equippedItem.bagslot[i]
    local equipslot = equippedItem.slot[i]
    local slotIdx = PLAYER_EQUIP_SLOTS[i]
    SetSlotType(slotIdx, equipslot)
    function equipslot:OnClickProc(arg)
      if FireSystemMsgCanUseBattleField() == true then
        return
      end
      if X2Item:IsInRepairMode() then
        X2Equipment:ItemRepair(slotIdx)
        return
      end
      if arg == "LeftButton" then
        if X2Input:IsShiftKeyDown() and X2Chat:IsActivatedChatInput() then
          local tipInfo = X2Equipment:GetEquippedItemTooltipInfo(slotIdx, IIK_TYPE + IIK_GRADE)
          if AddLinkItem(tipInfo) == true then
            return true
          end
          return
        end
        X2Equipment:PickupEquippedItem(slotIdx)
      end
      if arg == "RightButton" then
        if X2Equipment:IsInventoriable(slotIdx) == true then
          X2Equipment:UnequipItem(slotIdx)
        else
          X2Equipment:UseEquippedItem(slotIdx)
        end
      end
      equippedItem:Update()
    end
    function equipslot:OnDragStart()
      if FireSystemMsgCanUseBattleField() == true then
        return
      end
      X2Equipment:PickupEquippedItem(slotIdx)
    end
    function equipslot:OnDragReceive()
      if FireSystemMsgCanUseBattleField() == true then
        return
      end
      X2Equipment:PickupEquippedItem(slotIdx)
    end
    equipslot:SetHandler("OnDragStart", equipslot.OnDragStart)
    equipslot:SetHandler("OnDragReceive", equipslot.OnDragReceive)
    function bagButton:OnClick(arg)
      if FireSystemMsgCanUseBattleField() == true then
        return
      end
      if arg == "LeftButton" then
        bagslot:Show(true)
      end
    end
    bagButton:SetHandler("OnClick", bagButton.OnClick)
    local close = bagslot.close
    local up = bagslot.up
    local down = bagslot.down
    function close:OnClick(arg)
      if arg == "LeftButton" then
        bagslot.index = 0
        bagslot:Show(false)
      end
    end
    close:SetHandler("OnClick", close.OnClick)
    function up:GetDx()
      return 1
    end
    function down:GetDx()
      return 1
    end
    function up:OnClick(arg)
      if arg == "LeftButton" then
        local dx = self:GetDx()
        bagslot.index = bagslot.index - dx
        equippedItem:Update()
      end
    end
    up:SetHandler("OnClick", up.OnClick)
    function down:OnClick(arg)
      if arg == "LeftButton" then
        local dx = self:GetDx()
        bagslot.index = bagslot.index + dx
        equippedItem:Update()
      end
    end
    down:SetHandler("OnClick", down.OnClick)
    for j = 1, 3 do
      local slot = bagslot.slot[j]
      function slot:OnClickProc(arg)
        if arg == "LeftButton" then
          bagslot:Show(false)
          X2Bag:EquipBagItem(self.bagSlot, self.isAux)
          equippedItem:Update()
        end
      end
    end
  end
end
equippedItem:Update()
local arrow = DrawArrowMoveAnim(equippedItem.optionButton)
arrow:AddAnchor("RIGHT", equippedItem.optionButton, "LEFT", -30, 0)
if UIParent:GetUIStamp("equippedItemOpenCount") == nil then
  UIParent:SetUIStamp("equippedItemOpenCount", "0")
end
function equippedItem:ShowProc()
  equippedItem.leftSlots:Show(equippedItem:IsVisible())
  equippedItem.rightSlots:Show(equippedItem:IsVisible())
  local openCount = UIParent:GetUIStamp("equippedItemOpenCount")
  if tonumber(openCount) >= 3 then
    return
  end
  UIParent:SetUIStamp("equippedItemOpenCount", tostring(openCount + 1))
  arrow:Animation(true, false)
end
function equippedItem:AninForEquipped(index)
  if not characterInfo.mainWindow:IsVisible() then
    return
  end
  if index == -1 then
    return
  end
  if X2Equipment:ItemIdentifier(index) == 0 then
    return
  end
  local slot = GetSlotBySlotIdx(index)
  slot:SetScaleAnimation(1.2, 1, 0.5, 0.3, "CENTER")
  slot:SetStartAnimation(false, true)
end
local LeftClickFuncOptionBtn = function()
  ToggleVisualOptionFrame()
end
ButtonOnClickHandler(equippedItem.optionButton, LeftClickFuncOptionBtn)
local function OnHide()
  arrow:Animation(false, false)
  local prelimWnd = equippedItem.preliminaryEquipWnd
  if prelimWnd ~= nil and prelimWnd:IsVisible() then
    prelimWnd:Show(false)
  end
end
equippedItem:SetHandler("OnHide", OnHide)
