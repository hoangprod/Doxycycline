PET_CMD_EQUIP = 1
PET_CMD_MOUNT = 2
PET_CMD_PASSENGER_GET_OFF = 3
PET_CMD_CYA = 4
PET_CMD_ATTACK = 5
PET_CMD_LAST = PET_CMD_ATTACK
if X2Player:GetFeatureSet().mateTypeSummon then
  MAX_PET_ACTION_SLOT = 6
else
  MAX_PET_ACTION_SLOT = 5
end
local inset = 10
local petInfo = {}
local petInfoModifierStat = {}
petCmdStr = {}
petCmdStr[PET_CMD_EQUIP] = locale.pet.command.openEquip
petCmdStr[PET_CMD_MOUNT] = locale.pet.command.mount
petCmdStr[PET_CMD_PASSENGER_GET_OFF] = locale.pet.command.passengerGetOff
petCmdStr[PET_CMD_CYA] = locale.pet.command.cya
petCmdStr[PET_CMD_ATTACK] = locale.pet.command.attack
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
PET_STATE_AGGRESSIVE = 1
PET_STATE_PROTECTIVE = 2
PET_STATE_PASSIVE = 3
PET_STATE_STAND = 4
function CreateStateBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(23, 90.2)
  window:AddAnchor("LEFT", parent, "LEFT", 9, 0)
  local bg = window:CreateDrawable(TEXTURE_PATH.PET, "icon_bg_combat", "background")
  if parent.mateType == MATE_TYPE_BATTLE and X2Player:GetFeatureSet().mateTypeSummon then
    bg:SetTextureInfo("icon_bg_combat")
  else
    bg:SetTextureInfo("icon_bg")
  end
  bg:AddAnchor("TOPRIGHT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.buttons = {}
  local order = 1
  for i = 1, PET_STATE_STAND do
    local button = window:CreateChildWidget("button", "buttons", i, true)
    ApplyButtonSkin(button, BUTTON_CONTENTS.PET_STATE[i])
    button:AddAnchor("TOPLEFT", window, 1, (order - 1) * 22)
    if X2Player:GetFeatureSet().mateTypeSummon then
      if parent.mateType == MATE_TYPE_BATTLE then
        order = order + 1
      elseif i ~= PET_STATE_AGGRESSIVE and i ~= PET_STATE_PROTECTIVE then
        order = order + 1
      else
        button:Show(false)
      end
      _G["Pet" .. tostring(parent.mateType) .. "StanceButton" .. tostring(i)] = button
    else
      order = order + 1
      _G["PetStanceButton" .. tostring(i)] = button
    end
  end
  parent.stateBar = window
end
function CreateActionBar(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  window:AddAnchor("BOTTOMLEFT", parent, 34, -6)
  window:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  window:SetHeight(45)
  parent.action = {}
  parent.action.buttons = {}
  for i = 1, MAX_PET_ACTION_SLOT do
    local button = CreateActionSlot(window, "pet_action_slot", MateTypeToActionISlot(parent.mateType), i)
    button:Show(true)
    button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    button:AddAnchor("TOPLEFT", window, (i - 1) * (ICON_SIZE.DEFAULT - 1), 0)
    button:EnableDrag(true)
    if i > MAX_PET_ACTION_SLOT then
      local xOffset = (i - 6) * 46 + 9
      button:AddAnchor("TOPLEFT", window, xOffset, 97)
    end
    parent.action.buttons[i] = button
    if X2Player:GetFeatureSet().mateTypeSummon then
      _G["Pet" .. tostring(parent.mateType) .. "ActionButton" .. tostring(i)] = button
    else
      _G["PetActionButton" .. tostring(i)] = button
    end
  end
  parent.actionBar = window
end
local commandIconpath = {
  [MATE_TYPE_RIDE] = {
    [PET_CMD_EQUIP] = "ui/icon/pet_command/pet_equip.dds",
    [PET_CMD_MOUNT] = "ui/icon/pet_command/pet_mount.dds",
    [PET_CMD_PASSENGER_GET_OFF] = "ui/icon/pet_command/pet_passenger_get_off.dds",
    [PET_CMD_CYA] = "ui/icon/pet_command/pet_cya.dds",
    [PET_CMD_ATTACK] = "ui/icon/pet_command/pet_follow_stop.dds"
  },
  [MATE_TYPE_BATTLE] = {
    [PET_CMD_EQUIP] = "ui/icon/pet_command/pet_battle_equip.dds",
    [PET_CMD_MOUNT] = "ui/icon/pet_command/pet_mount.dds",
    [PET_CMD_PASSENGER_GET_OFF] = "ui/icon/pet_command/pet_passenger_get_off.dds",
    [PET_CMD_CYA] = "ui/icon/pet_command/pet_battle_cya.dds",
    [PET_CMD_ATTACK] = "ui/icon/pet_command/pet_battle_attack.dds"
  }
}
function CreateCommandBar(id, parent)
  local window = CreateEmptyWindow("petBar" .. tostring(parent.mateType) .. ".equip", parent)
  window:Show(false)
  window:AddAnchor("TOPLEFT", parent, 34, 6)
  window:AddAnchor("TOPRIGHT", parent, 0, 0)
  window:SetHeight(45)
  parent.command = {}
  parent.command.buttons = {}
  for k = PET_CMD_EQUIP, PET_CMD_LAST do
    local button = CreateSlotShapeButton("$parentCommandButton" .. k, parent)
    button.using = true
    button:SetIconPath(commandIconpath[parent.mateType][k])
    button:AddAnchor("BOTTOMLEFT", window, (k - 1) * (ICON_SIZE.DEFAULT - 1) + 9, 0)
    local keybinding = button:CreateChildWidget("label", "keybinding", 0, true)
    keybinding:SetHeight(FONT_SIZE.SMALL)
    keybinding:AddAnchor("TOPLEFT", button, 2, 2)
    keybinding.style:SetAlign(ALIGN_LEFT)
    keybinding.style:SetShadow(true)
    keybinding.style:SetFontSize(FONT_SIZE.SMALL)
    button.bindText = keybinding
    parent.command.buttons[k] = button
    if X2Player:GetFeatureSet().mateTypeSummon then
      _G["Pet" .. tostring(parent.mateType) .. "CommandButton" .. tostring(k)] = button
    else
      _G["PetCommandButton" .. tostring(k)] = button
    end
  end
  parent.expBar = W_BAR.CreateExpBar("petBar" .. tostring(parent.mateType) .. ".expBar", parent)
  parent.expBar:SetExtent(0, 5)
  parent.expBar:Show(false)
  parent.expBar:AddAnchor("TOPLEFT", window, 13, 10)
  parent.expBar:AddAnchor("TOPRIGHT", window, -13, 10)
  parent.cmdBg = window
end
local equipSlotImage = {
  "pet_equip_slot_img_01",
  "pet_equip_slot_img_02",
  "pet_equip_slot_img_03",
  "pet_equip_slot_img_04",
  "pet_equip_slot_img_05"
}
function CreatePetEquipButton(id, parent, slot)
  local button = CreateItemIconButton(id, parent)
  button.bg = button:CreateDrawable(TEXTURE_PATH.DEFAULT, "pet_equip_slot_img_01", "background")
  button.bg:SetTextureInfo(equipSlotImage[slot])
  button.bg:AddAnchor("TOPLEFT", button, 0, 0)
  button.bg:AddAnchor("BOTTOMRIGHT", button, 0, 0)
  function button:SetTooltip(info)
    button.info = info
  end
  button:SetHandler("OnClick", function()
    TooltipRaise()
  end)
  return button
end
local CreateExpBar = function(id, parent, barWidth)
  local expBar = W_BAR.CreateStatusBar("petExpBarGauge", parent)
  expBar:SetBarTextureCoords(TEXTURE_PATH.COMMON_GAUGE, "gage_small", TEXTURE_PATH.DEFAULT, "gage_bg", TEXTURE_PATH.DEFAULT, "gage_shadow")
  expBar:SetExtent(barWidth, 9)
  expBar:SetBarColor(GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage_small"):GetColors().orange)
  expBar:SetMinMaxValues(0, 1000)
  expBar:SetValue(0)
  expBar:Show(true)
  parent.expBar = expBar
  function expBar:SetExpGauge(ratio)
    local maxValue, _ = self.statusBar:GetMinMaxValues()
    self:SetValue(ratio * maxValue)
  end
  return expBar
end
local attrList = {
  {
    key = "health",
    affect = {"max_health"}
  },
  {
    key = "mana",
    affect = {"max_mana", "int"}
  },
  {
    key = "exp",
    affect = {}
  },
  {
    key = "melee_dps_inc",
    affect = {
      "melee_dps",
      "melee_attack_speed_mul"
    }
  },
  {
    key = "ranged_dps_inc",
    affect = {
      "ranged_dps",
      "ranged_attack_speed_mul"
    }
  },
  {
    key = "spell_dps_inc",
    affect = {"spell_dps"}
  },
  {
    key = "heal_dps_inc",
    affect = {"heal_dps"}
  },
  {
    key = "str",
    affect = {"str"}
  },
  {
    key = "spi",
    affect = {"spi"}
  },
  {
    key = "int",
    affect = {"int"}
  },
  {
    key = "sta",
    affect = {"sta"}
  },
  {
    key = "dex",
    affect = {"dex"}
  },
  {
    key = "armor",
    affect = {"armor"}
  },
  {
    key = "magic_resist",
    affect = {
      "magic_resist"
    }
  },
  {
    key = "health_regen",
    affect = {
      "health_regen",
      "spi",
      "persistent_health_regen"
    }
  },
  {
    key = "mana_regen",
    affect = {
      "mana_regen",
      "spi",
      "persistent_mana_regen"
    }
  },
  {
    key = "move_speed_mul",
    affect = {"move_speed"}
  },
  {
    key = "mate_equip",
    affect = {}
  }
}
local function CreatePetAttributeLabel(parent, mateType, attr, labelWidth, isExp)
  local attrGetFunc = {
    exp = function()
      if GetPetExpString(mateType) ~= nil then
        local expString = GetPetExpString(mateType)
        return expString
      end
      return 0
    end,
    health = function()
      return X2Unit:UnitHealth(F_UNIT.GetPetTargetName(mateType)) .. " / " .. X2Unit:UnitMaxHealth(F_UNIT.GetPetTargetName(mateType))
    end,
    mana = function()
      return X2Unit:UnitMana(F_UNIT.GetPetTargetName(mateType)) .. " / " .. X2Unit:UnitMaxMana(F_UNIT.GetPetTargetName(mateType))
    end,
    armor = function()
      return string.format("%d (%.2f%%)", petInfo[mateType].armor, petInfo[mateType].armor_percentage)
    end,
    magic_resist = function()
      return string.format("%d (%.2f%%)", petInfo[mateType].magic_resist, petInfo[mateType].magic_resist_percentage)
    end,
    melee_dps_inc = function()
      return string.format("%.2f", petInfo[mateType].melee_dps)
    end,
    ranged_dps_inc = function()
      return string.format("%.2f", petInfo[mateType].ranged_dps)
    end,
    spell_dps_inc = function()
      return string.format("%.2f", petInfo[mateType].spell_dps)
    end,
    heal_dps_inc = function()
      return string.format("%.2f", petInfo[mateType].heal_dps)
    end,
    str = function()
      return string.format("%d", petInfo[mateType].str)
    end,
    spi = function()
      return string.format("%d", petInfo[mateType].spi)
    end,
    int = function()
      return string.format("%d", petInfo[mateType].int)
    end,
    sta = function()
      return string.format("%d", petInfo[mateType].sta)
    end,
    dex = function()
      return string.format("%d", petInfo[mateType].dex)
    end,
    health_regen = function()
      return petInfo[mateType].health_regen
    end,
    mana_regen = function()
      return petInfo[mateType].mana_regen
    end,
    move_speed_mul = function(attr)
      local maxSpeed = X2Mate:GetSpeedInfo(mateType)
      if maxSpeed == nil then
        maxSpeed = 0
      end
      return string.format("%.1f %s", maxSpeed, locale.util.speed_unit)
    end,
    mate_equip = function()
      return ""
    end
  }
  local label = parent:CreateChildWidget("label", attr.key, 0, true)
  label:SetExtent(labelWidth, 15)
  if attr.key ~= "mate_equip" then
    label:SetText(locale.attribute(attr.key))
  else
    label:SetText(X2Locale:LocalizeUiText(SLAVE_KIND, "slave_equipment"))
    parent.mate_equip_label = label
  end
  label.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(label, FONT_COLOR.TITLE)
  local value
  if isExp then
    value = label:CreateChildWidget("textbox", "value", 0, true)
    value:SetExtent(parent:GetWidth() - label:GetWidth(), FONT_SIZE.MIDDLE)
    value.style:SetAlign(ALIGN_LEFT)
    local expBarWidth = parent:GetWidth() - label:GetWidth()
    local expBar = CreateExpBar("expBar", label, expBarWidth)
    expBar:AddAnchor("TOPLEFT", label, "BOTTOMRIGHT", 0, petLocale.offset.expBarY)
  else
    value = label:CreateChildWidget("label", "value", 0, true)
    value:SetHeight(FONT_SIZE.MIDDLE)
    value:SetAutoResize(true)
  end
  value:AddAnchor("LEFT", label, "RIGHT", 0, 0)
  ApplyTextColor(value, FONT_COLOR.DEFAULT)
  function label:SetAttrValue()
    label.value:SetText(tostring(attrGetFunc[attr.key](attr.key) or ""))
    if isExp then
      local percentExp, _, _, _ = X2Mate:GetPetExpToNextLevel(mateType)
      label.expBar:SetExpGauge(percentExp / 100)
    end
  end
  function label:GetModifiersValue()
    local sum = 0
    for i = 1, #attr.affect do
      sum = sum + petInfoModifierStat[mateType][attr.affect[i]]
    end
    return sum
  end
  return label
end
local function CreateUnitAttributeWindow(id, parent)
  local window = CreateEmptyWindow(id, parent)
  if X2Player:GetFeatureSet().mateTypeSummon then
    window:SetExtent(parent:GetWidth(), 544)
  else
    window:SetExtent(parent:GetWidth() - MARGIN.WINDOW_SIDE * 2, 544)
  end
  local level = W_UNIT.CreateLevelLabel(window:GetId() .. ".level", window, true)
  level:Show(true)
  level:SetHeight(37)
  level:AddAnchor("TOPLEFT", window, 0, 0)
  level:SettingUseForInfoWindow()
  window.level = level
  local name = window:CreateChildWidget("label", "name", 0, true)
  name:SetAutoResize(true)
  name:SetHeight(13)
  name:AddAnchor("BOTTOMLEFT", level, "BOTTOMRIGHT", 10, 0)
  ApplyTextColor(name, FONT_COLOR.DEFAULT)
  if X2Player:GetFeatureSet().mateTypeSummon then
    local typeName = window:CreateChildWidget("label", "typeName", 0, true)
    typeName:SetAutoResize(true)
    typeName:SetHeight(13)
    typeName:AddAnchor("TOPLEFT", level, "TOPRIGHT", 10, 3)
    ApplyTextColor(typeName, FONT_COLOR.BLUE)
  end
  local bg = CreateContentBackground(window, "TYPE8", "brown_2")
  bg:AddAnchor("TOPLEFT", window, -sideMargin, -sideMargin)
  bg:AddAnchor("RIGHT", window, sideMargin, 0)
  bg:AddAnchor("BOTTOM", name, 0, sideMargin / 2)
  window.bg = bg
  window.labels = {}
  local function ReAnchorDivideLine(line, parent, target, count)
    line:RemoveAllAnchors()
    line:SetColor(1, 1, 1, 0.5)
    line:AddAnchor("LEFT", target, 0, 0)
    if count == 3 then
      line:AddAnchor("RIGHT", target, 0, 0)
      line:AddAnchor("BOTTOM", parent, 0, sideMargin / 1.4 + 13)
    else
      line:AddAnchor("RIGHT", target, 0, 0)
      line:AddAnchor("BOTTOM", parent, 0, sideMargin / 1.4)
    end
  end
  function window:InitInfoView()
    local yOffset = 56
    local customLabel = {
      str = {
        xOffset = 0,
        yUpdate = 0,
        smallAttrLabel = true
      },
      spi = {
        xOffset = petLocale.offset.secondColumn,
        yUpdate = 20,
        smallAttrLabel = true
      },
      int = {
        xOffset = 0,
        yUpdate = 0,
        smallAttrLabel = true
      },
      sta = {
        xOffset = petLocale.offset.secondColumn,
        yUpdate = 20,
        smallAttrLabel = true
      },
      dex = {
        xOffset = 0,
        yUpdate = 20,
        smallAttrLabel = true
      },
      move_speed_mul = {
        xOffset = 0,
        yUpdate = 38,
        smallAttrLabel = false
      }
    }
    for i, attr in pairs(attrList) do
      local isExp = false
      if i == 3 then
        isExp = true
      end
      if window.labels[i] ~= nil then
        if window.labels[i].Show then
          window.labels[i]:EnableHidingIsRemove(true)
          window.labels[i]:Show(false)
        end
        window.labels[i] = nil
      end
      local labelWidth = petLocale.width.attributeLabel
      if customLabel[attr.key] and customLabel[attr.key].smallAttrLabel == true then
        labelWidth = petLocale.width.smallAttrLabel
      end
      window.labels[i] = CreatePetAttributeLabel(window, parent.mateType, attr, labelWidth, isExp)
      if customLabel[attr.key] == nil then
        window.labels[i]:AddAnchor("TOPLEFT", window, 0, yOffset)
        yOffset = yOffset + 20
      else
        window.labels[i]:AddAnchor("TOPLEFT", window, customLabel[attr.key].xOffset, yOffset)
        yOffset = yOffset + customLabel[attr.key].yUpdate
      end
      if i == 3 or i == 7 or i == 12 or i == 14 or i == 16 or i == 17 then
        if i == 3 then
          yOffset = yOffset + 13
        end
        yOffset = yOffset + sideMargin
        DrawTargetLine(window.labels[i])
        ReAnchorDivideLine(window.labels[i].line, window.labels[i], window, i)
      end
    end
  end
  window:InitInfoView()
  function window:UpdateInfoView()
    local cur = X2Unit:UnitLevel(F_UNIT.GetPetTargetName(parent.mateType)) or 0
    local heirLevel = X2Unit:UnitHeirLevel(F_UNIT.GetPetTargetName(parent.mateType)) or 0
    window.level:ChangedLevel(cur, heirLevel)
    cur = X2Unit:UnitName(F_UNIT.GetPetTargetName(parent.mateType)) or ""
    window.name:SetText(cur)
    if X2Player:GetFeatureSet().mateTypeSummon then
      if parent.mateType == MATE_TYPE_RIDE then
        window.typeName:SetText(GetUIText(COMMON_TEXT, "ride_pet_long"))
      elseif parent.mateType == MATE_TYPE_BATTLE then
        window.typeName:SetText(GetUIText(COMMON_TEXT, "battle_pet_long"))
      end
    end
    petInfo[parent.mateType] = X2Unit:UnitInfo(F_UNIT.GetPetTargetName(parent.mateType))
    petInfoModifierStat[parent.mateType] = X2Unit:UnitModifierInfo(F_UNIT.GetPetTargetName(parent.mateType))
    for i = 1, #window.labels do
      ApplyTextColor(window.labels[i].value, GetPetModifierColor(window.labels[i]:GetModifiersValue()))
      window.labels[i]:SetAttrValue()
    end
  end
  function window:OnUpdate()
    if self:IsVisible() then
      window.labels[1]:SetAttrValue()
      window.labels[2]:SetAttrValue()
      window.labels[11]:SetAttrValue()
    end
  end
  window:SetHandler("OnUpdate", window.OnUpdate)
  window:Show(true)
  return window
end
equipSlots = {
  {1, "Head"},
  {3, "Chest"},
  {4, "Waist"},
  {7, "Feet"}
}
function CreatePetInfoTab(id, window)
  local attributes = CreateUnitAttributeWindow(window:GetId() .. ".attributeWindow", window)
  if X2Player:GetFeatureSet().mateTypeSummon then
    attributes:AddAnchor("TOPLEFT", window, 0, 20)
  else
    attributes:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  end
  window.attributes = attributes
  window.buttons = {}
  for i, slot in pairs(equipSlots) do
    local slotNo = slot[1]
    local slotName = slot[2]
    local button = CreateItemIconButton(window:GetId() .. "." .. slotName, window)
    button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    button:RegisterForClicks("RightButton")
    F_SLOT.ApplySlotSkin(button, button.back, SLOT_STYLE.PET_ITEM[i])
    window.buttons[slotNo] = button
  end
end
function CreatePetInfoWindow(id)
  local TAB_MENU_TEXT = {
    GetUIText(COMMON_TEXT, "ride_pet_short"),
    GetUIText(COMMON_TEXT, "battle_pet_short")
  }
  local window = CreateWindow(id, "UIParent")
  window:SetTitle(locale.pet.info.title)
  function window:MakeOriginWindowPos()
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    if X2Player:GetFeatureSet().mateTypeSummon then
      window:SetExtent(petLocale.width.window, 654)
    else
      window:SetExtent(petLocale.width.window, 609)
    end
    window:AddAnchor("CENTER", "UIParent", 0, 0)
  end
  window:MakeOriginWindowPos()
  window:SetSounds("pet_info")
  if X2Player:GetFeatureSet().mateTypeSummon then
    local tab = W_BTN.CreateTab("tab", window)
    tab:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
    tab:AddAnchor("BOTTOMRIGHT", window, -MARGIN.WINDOW_SIDE, 0)
    tab:SetCorner("TOPLEFT")
    tab:AddTabs(TAB_MENU_TEXT)
    tab.window[MATE_TYPE_RIDE].mateType = MATE_TYPE_RIDE
    tab.window[MATE_TYPE_BATTLE].mateType = MATE_TYPE_BATTLE
    window.tab = tab
    CreatePetInfoTab("petTabRide", tab.window[MATE_TYPE_RIDE])
    CreatePetInfoTab("petTabBattle", tab.window[MATE_TYPE_BATTLE])
    function window:ChangeTab(idx)
      if not self.tab.unselectedButton[idx]:IsEnabled() then
        self.tab.unselectedButton[idx]:Enable(true)
      end
      UpdatePetEquipSlot(idx)
      UpdatePetBarCommandText(idx)
      if self.tab.window[idx].ShowProc then
        self.tab.window[idx]:ShowProc()
      end
      self.tab.window[idx].attributes:UpdateInfoView()
    end
    function window:ChangeEnabledTab()
      for i = 1, #TAB_MENU_TEXT do
        if self.tab.unselectedButton[i]:IsEnabled() then
          self:ChangeTab(i)
          return true
        end
      end
      return false
    end
    function window.tab:OnTabChangedProc(selected)
      window:ChangeTab(selected)
    end
    for i = 1, #TAB_MENU_TEXT do
      local selectedButton = tab.selectedButton[i]
      local unselectedButton = tab.unselectedButton[i]
      selectedButton.idx = i
      unselectedButton.idx = i
      unselectedButton:Enable(false)
    end
    AddUISaveHandlerByKey("petInfoWindow", window)
    window:ApplyLastWindowOffset()
  else
    CreatePetInfoTab("petInfo", window)
    function window:ChangeParent(parent)
      window.mateType = parent.mateType
      window.attributes:InitInfoView()
      window:RemoveAllAnchors()
      window:AddAnchor("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -50)
    end
  end
  return window
end
function GetPetModifierColor(value)
  if value > -0.009 and value < 0.001 then
    value = 0
  end
  if value > 0 then
    return FONT_COLOR.GREEN
  elseif value < 0 then
    return FONT_COLOR.RED
  end
  return FONT_COLOR.DEFAULT
end
