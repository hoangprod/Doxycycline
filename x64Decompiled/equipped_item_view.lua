equippedItem = CreateEmptyWindow("equippedItem", "UIParent")
equippedItem.slot = {}
equippedItem.bagslot = {}
equippedItem.bagButton = {}
equippedItem.equipSlotReinforceBtn = {}
equippedItem.preliminaryEquipWnd = nil
local screenHeight = UIParent:GetScreenHeight()
local hudHeight = 60
local slotHeight = 440
equippedItem:AddAnchor("TOP", "UIParent", "TOP", 0, (screenHeight - slotHeight - hudHeight) * 0.5)
equippedItem.leftSlots = CreateEmptyWindow("equippedItem.leftSlots", equippedItem)
equippedItem.leftSlots:SetExtent(ICON_SIZE.DEFAULT, 485)
equippedItem.leftSlots:AddAnchor("TOPLEFT", equippedItem, "TOP", -200, 0)
equippedItem.rightSlots = CreateEmptyWindow("equippedItem.rightSlots", equippedItem)
equippedItem.rightSlots:SetExtent(ICON_SIZE.DEFAULT, 485)
equippedItem.rightSlots:AddAnchor("TOPRIGHT", equippedItem, "TOP", 200, 0)
function IsCenter(i)
  return i == ES_COSPLAY
end
function IsLeftSide(i)
  local leftGroup = {
    1,
    3,
    4,
    8,
    6,
    9,
    5,
    7,
    14,
    15
  }
  for j = 1, #leftGroup do
    if leftGroup[j] == i then
      return true
    end
  end
  return false
end
for i = 1, #PLAYER_EQUIP_SLOTS do
  local parent = IsLeftSide(i) and equippedItem.leftSlots or equippedItem.rightSlots
  local button = CreateItemIconButton("equippedItem.slot." .. i, parent, "constant")
  AddOnUpdateCooldown(button, "action")
  button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  button:RegisterForClicks("RightButton")
  button:EnableDrag(true)
  local bagButton = CreateEmptyButton("equippedItem.bagButton." .. i, parent)
  bagButton:Show(true)
  ApplyButtonSkin(bagButton, BUTTON_CONTENTS.EQUIP_OPEN)
  if i == 20 then
    bagButton:Show(false)
  end
  local bagslot = CreateEmptyWindow("equippedItem.bagslot." .. i, parent)
  bagslot:SetExtent(180, ICON_SIZE.DEFAULT)
  bagslot:Show(false)
  local bg = bagslot:CreateDrawable(TEXTURE_PATH.CHARACTER_INFO, "bag_slot_bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", bagslot, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", bagslot, 0, 0)
  bagslot.bg = bg
  local up = bagslot:CreateChildWidget("button", "up", i, true)
  ApplyButtonSkin(up, BUTTON_CONTENTS.EQUIP_UP)
  local down = bagslot:CreateChildWidget("button", "down", i, true)
  ApplyButtonSkin(down, BUTTON_CONTENTS.EQUIP_DOWN)
  local close = bagslot:CreateChildWidget("button", "close", i, true)
  ApplyButtonSkin(close, BUTTON_CONTENTS.EQUIP_OPEN)
  if IsLeftSide(i) then
    ChangeButtonSkin(bagButton, BUTTON_CONTENTS.EQUIP_CLOSE)
    ChangeButtonSkin(close, BUTTON_CONTENTS.EQUIP_OPEN)
    bagButton:AddAnchor("TOPRIGHT", button, "TOPLEFT", -5, 0)
    close:AddAnchor("TOPRIGHT", button, "TOPLEFT", -5, 0)
    bagslot:AddAnchor("TOPRIGHT", button, "TOPLEFT", 0, 0)
    up:AddAnchor("LEFT", bagslot, "LEFT", 16, -8)
    down:AddAnchor("LEFT", bagslot, "LEFT", 16, 8)
    bg:SetCoords(85, 106, 84, 18)
    bg:SetInset(75, 0, 8, 0)
    bg:RemoveAllAnchors()
    bg:AddAnchor("TOPLEFT", bagslot, -20, 0)
    bg:AddAnchor("BOTTOMRIGHT", bagButton, -1, 0)
  else
    ChangeButtonSkin(bagButton, BUTTON_CONTENTS.EQUIP_OPEN)
    ChangeButtonSkin(close, BUTTON_CONTENTS.EQUIP_CLOSE)
    bagButton:AddAnchor("TOPLEFT", button, "TOPRIGHT", 5, 0)
    close:AddAnchor("TOPLEFT", button, "TOPRIGHT", 5, 0)
    bagslot:AddAnchor("TOPLEFT", button, "TOPRIGHT", 0, 0)
    up:AddAnchor("RIGHT", bagslot, "RIGHT", -14, -8)
    down:AddAnchor("RIGHT", bagslot, "RIGHT", -14, 8)
    bg:SetCoords(0, 106, 84, 18)
    bg:RemoveAllAnchors()
    bg:AddAnchor("TOPLEFT", bagButton, 1, 0)
    bg:AddAnchor("BOTTOMRIGHT", bagslot, 20, 0)
  end
  local slot = {}
  local items = X2Bag:FindBagItemByEquipSlot(ISLOT_EQUIPMENT, i)
  local itemCount = #items
  local slotIdx = PLAYER_EQUIP_SLOTS[i]
  button:SetItemSlot(slotIdx, ISLOT_EQUIPMENT)
  if IsLeftSide(i) then
    for j = 1, 3 do
      local button = CreateItemIconButton("equippedItem.bagslot.slot." .. j, bagslot)
      button:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
      button:Show(false)
      slot[j] = button
    end
  else
    for j = 1, 3 do
      local button = CreateItemIconButton("equippedItem.bagslot.slot." .. j, bagslot)
      button:Show(false)
      button:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
      slot[j] = button
    end
  end
  bagslot.up = up
  bagslot.down = down
  bagslot.close = close
  bagslot.slot = slot
  bagslot.index = 0
  bagslot.max = 0
  equippedItem.bagButton[i] = bagButton
  equippedItem.bagslot[i] = bagslot
  equippedItem.slot[i] = button
  equippedItem.slot[i].back:SetColor(1, 1, 1, 1)
  F_SLOT.ApplySlotSkin(equippedItem.slot[i], equippedItem.slot[i].back, SLOT_STYLE.EQUIP_ITEM[i])
end
equippedItem.slot[1]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 0)
equippedItem.slot[3]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 48)
equippedItem.slot[4]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 96)
equippedItem.slot[8]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 144)
equippedItem.slot[6]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 192)
equippedItem.slot[9]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 269)
equippedItem.slot[5]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 317)
equippedItem.slot[7]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 365)
equippedItem.slot[14]:Show(false)
equippedItem.slot[15]:AddAnchor("TOPLEFT", equippedItem.leftSlots, 0, 442)
equippedItem.slot[2]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 0)
equippedItem.slot[10]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 48)
equippedItem.slot[11]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 96)
equippedItem.slot[12]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 144)
equippedItem.slot[13]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 192)
equippedItem.slot[16]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 250)
equippedItem.slot[17]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 298)
equippedItem.slot[18]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 346)
equippedItem.slot[19]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 394)
equippedItem.slot[20]:AddAnchor("TOPRIGHT", equippedItem.rightSlots, 0, 442)
equippedItem.slot[21]:AddAnchor("CENTER", "UIParent", "CENTER", 0, -280)
function equippedItem:OnScale()
  equippedItem.slot[21]:RemoveAllAnchors()
  equippedItem.slot[21]:AddAnchor("CENTER", "UIParent", "CENTER", 0, F_LAYOUT.CalcDontApplyUIScale(-280))
end
equippedItem:SetHandler("OnScale", equippedItem.OnScale)
local optionButton = equippedItem:CreateChildWidget("button", "optionButton", 0, true)
optionButton:AddAnchor("TOPRIGHT", equippedItem.slot[21], "TOPLEFT", -2, -1)
ApplyButtonSkin(optionButton, BUTTON_HUD.ROAD_MAP_OPTION)
