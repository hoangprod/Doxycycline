local PRELIMINARY_SLOT_INFO = {
  [1] = {equipSlotType = ES_MAINHAND},
  [2] = {equipSlotType = ES_OFFHAND}
}
local function CreatePreliminarySlot(idx, parent)
  local slot = CreateItemIconButton(string.format("prelimSlot[%d]", idx), parent, "constant")
  slot.slotType = PRELIMINARY_SLOT_INFO[idx].equipSlotType
  F_SLOT.ApplySlotSkin(slot, slot.back, SLOT_STYLE.EQUIP_ITEM[slot.slotType])
  AddOnUpdateCooldown(slot)
  slot:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local blocked = slot:CreateDrawable(TEXTURE_PATH.ITEM_DIAGONAL_LINE, "line", "overlay")
  blocked:SetTextureColor("white")
  blocked:AddAnchor("TOPLEFT", slot, 0, 0)
  blocked:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  slot:RegisterForClicks("RightButton")
  slot:EnableDrag(true)
  slot:SetItemSlot(slot.slotType, ISLOT_PRELIMINARY_EQUIPMENT)
  function slot:SetSlotLock(lock)
    if lock == true then
      slot:Enable(false)
      blocked:SetVisible(true)
    else
      slot:Enable(true)
      blocked:SetVisible(false)
    end
  end
  slot:SetSlotLock(false)
  return slot
end
local function CreateSlotLockButton(idx, parent)
  local lockBtn = parent:CreateChildWidget("button", string.format("prelimLock[%d]", idx), 0, false)
  lockBtn.slotType = PRELIMINARY_SLOT_INFO[idx].equipSlotType
  function lockBtn:SetSlotLock(lock, disable)
    if lock then
      ApplyButtonSkin(self, BUTTON_CONTENTS.PRELIM_EQUIP_LOCK_ON)
      self.lockStatus = true
    else
      ApplyButtonSkin(self, BUTTON_CONTENTS.PRELIM_EQUIP_LOCK_OFF)
      self.lockStatus = false
    end
    self:Enable(disable ~= true)
  end
  lockBtn:SetSlotLock(false)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "prelim_swap_lock_tooltip"), self)
  end
  lockBtn:SetHandler("OnEnter", OnEnter)
  return lockBtn
end
function CreatePreliminaryEquipmentsWindow(id, parent)
  local window = CreateEmptyWindow(id, parent, "preliminary_equipment")
  window:SetExtent(107, 156)
  window:SetSounds("prelim_equipment")
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "swap_bg", "background")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local closeButton = window:CreateChildWidget("button", "closeButton", 0, false)
  closeButton:AddAnchor("TOPRIGHT", window, -3, 3)
  ApplyButtonSkin(closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  local titleLabel = window:CreateChildWidget("label", "titleLabel", 0, false)
  titleLabel:SetAutoResize(true)
  titleLabel:SetHeight(FONT_SIZE.MIDDLE)
  titleLabel:SetText(GetUIText(COMMON_TEXT, "second_weapons"))
  titleLabel:AddAnchor("TOP", window, 0, 14)
  titleLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(titleLabel, FONT_COLOR.SOFT_YELLOW)
  local itemsBox = window:CreateChildWidget("emptywidget", "itemsBox", 0, false)
  itemsBox:SetExtent(81, 103)
  itemsBox:AddAnchor("TOP", titleLabel, "BOTTOM", 0, 13)
  local boxBg = itemsBox:CreateDrawable(TEXTURE_PATH.HUD, "buff_back", "background")
  boxBg:AddAnchor("TOPLEFT", itemsBox, 0, 0)
  boxBg:AddAnchor("BOTTOMRIGHT", itemsBox, 0, 0)
  boxBg:SetTextureColor("alpha_10")
  window.prelimSlots = {}
  window.prelimLocks = {}
  for i = 1, #PRELIMINARY_SLOT_INFO do
    local slot = CreatePreliminarySlot(i, window)
    if i == 1 then
      slot:AddAnchor("BOTTOMRIGHT", itemsBox, "RIGHT", -5, -3)
    else
      slot:AddAnchor("TOP", window.prelimSlots[i - 1], "BOTTOM", 0, 6)
    end
    local slotLock = CreateSlotLockButton(i, window)
    slotLock:AddAnchor("RIGHT", slot, "LEFT", -5, 0)
    window.prelimSlots[i] = slot
    window.prelimLocks[i] = slotLock
  end
  local function OnClickCloseButton(self, arg)
    window:Show(false)
  end
  closeButton:SetHandler("OnClick", OnClickCloseButton)
  window:Show(false)
  return window
end
function CreatePreliminaryEquipmentsButton(id, parent)
  local toggleBtn = parent:CreateChildWidget("button", id, 0, false)
  ApplyButtonSkin(toggleBtn, BUTTON_CONTENTS.PRELIM_SWAP)
  toggleBtn:RegisterForClicks("RightButton")
  function toggleBtn:SetBtnStatus(on)
    if on then
      ApplyButtonSkin(self, BUTTON_CONTENTS.PRELIM_SWAP_ON)
    else
      ApplyButtonSkin(self, BUTTON_CONTENTS.PRELIM_SWAP)
    end
  end
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "prelim_swap_button_tooltip"), self)
  end
  toggleBtn:SetHandler("OnEnter", OnEnter)
  return toggleBtn
end
