equip_slot_reinforce_window = {}
local MAX_SLOT_COUNT = 7
local selected_equip_slot = 0
local selected_level_effect_index = 1
local selected_material_type = 0
local selected_material_index = 0
local MAX_SET_EFFECT_STEP = 3
local MAX_LEVEL_EFFECT_COUNT = 3
local EQUIP_SLOT_REINFORCE_TEXTURE_PATH = "ui/character/slot_enchant.dds"
local EQUIP_SLOT_REINFORCE_IMG_INFO = {
  VIEW_REINFORCE = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "slot_enchant"
  },
  VIEW_NORMAL = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "slot_equipment"
  },
  VIEW_DETAIL = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "search"
  },
  BTN_REINFORCE = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "enchant"
  },
  BTN_CHANGE_CASH = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "list_cash"
  },
  BTN_LEVEL_EFFECT_CHANGE = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "btn_change"
  },
  BTN_LEVEL_EFFECT_DETAIL = {
    drawableType = "drawable",
    path = BUTTON_TEXTURE_PATH.COMMON_READING_GLASSES,
    coordsKey = "btn_view"
  },
  SLOT_BG_OFFENCE = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "slot_bg_attack",
    colorKey = "default"
  },
  SLOT_BG_DEFENCE = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "slot_bg_shield",
    colorKey = "default"
  },
  SLOT_BG_SUPPORT = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "slot_bg_support",
    colorKey = "default"
  },
  BTN_SET_OFFENCE_1 = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "set_attack_1"
  },
  BTN_SET_OFFENCE_1 = {
    drawableType = "drawable",
    path = EQUIP_SLOT_REINFORCE_TEXTURE_PATH,
    coordsKey = "set_attack_1"
  }
}
equip_slot_reinforce_window = CreateEmptyWindow("equip_slot_reinforce_window", "UIParent")
local screenHeight = UIParent:GetScreenHeight()
local hudHeight = 60
local slotHeight = 440
equip_slot_reinforce_window:AddAnchor("TOP", "UIParent", "TOP", 0, (screenHeight - slotHeight - hudHeight) * 0.5)
equip_slot_reinforce_window.leftSlots = CreateEmptyWindow("equip_slot_reinforce_window.leftSlots", equip_slot_reinforce_window)
equip_slot_reinforce_window.leftSlots:Show(true)
equip_slot_reinforce_window.leftSlots:SetExtent(ICON_SIZE.DEFAULT, 401)
equip_slot_reinforce_window.leftSlots:AddAnchor("TOPLEFT", equip_slot_reinforce_window, "TOP", -200, 0)
equip_slot_reinforce_window.rightSlots = CreateEmptyWindow("equip_slot_reinforce_window.rightSlots", equip_slot_reinforce_window)
equip_slot_reinforce_window.rightSlots:Show(true)
equip_slot_reinforce_window.rightSlots:SetExtent(ICON_SIZE.DEFAULT, 443)
equip_slot_reinforce_window.rightSlots:AddAnchor("TOPRIGHT", equip_slot_reinforce_window, "TOP", 200, 0)
equip_slot_reinforce_window.slot = {}
equip_slot_reinforce_window.setEffect = {}
local CreateDetailSetEffectWindow = function(parent, anchorPos)
  local unitModifierList = W_CTRL.CreateScrollListCtrl("listCtrl", parent)
  unitModifierList.scroll:RemoveAllAnchors()
  unitModifierList.scroll:AddAnchor("TOPRIGHT", unitModifierList, 0, 0)
  unitModifierList.scroll:AddAnchor("BOTTOMRIGHT", unitModifierList, 0, 0)
  unitModifierList:SetExtent(388, 207)
  unitModifierList:AddAnchor("TOPLEFT", anchorPos, "BOTTOMLEFT", 0, 10)
  unitModifierList:HideColumnButtons()
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetLimitWidth(true)
    subItem:SetHeight(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(15, 5, 0, 0)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data))
    else
      subItem:SetText("")
    end
  end
  unitModifierList:InsertColumn("", 388, LCCIT_STRING, SetDataFunc, nil, nil, LayoutFunc)
  unitModifierList:InsertRows(8, false)
  for i = 1, 16 do
    local data = "type" .. i
    unitModifierList:InsertData(i, 1, data)
    unitModifierList:InsertData(i, 2, data)
  end
  ListCtrlItemGuideLine(unitModifierList.listCtrl.items, unitModifierList:GetRowCount() + 1)
  for i = 1, #unitModifierList.listCtrl.items do
    local item = unitModifierList.listCtrl.items[i]
    item.line:SetVisible(true)
  end
  equip_slot_reinforce_window.detailSetEffectList = unitModifierList
end
local CreateDetailLevelEffectWindow = function(parent, anchorPos)
  COL_INDEX = {ATTRIBUTE = 1, VALUE = 2}
  local unitModifierList = W_CTRL.CreateScrollListCtrl("listCtrl", parent)
  unitModifierList.scroll:RemoveAllAnchors()
  unitModifierList.scroll:AddAnchor("TOPRIGHT", unitModifierList, 0, 0)
  unitModifierList.scroll:AddAnchor("BOTTOMRIGHT", unitModifierList, 0, 0)
  unitModifierList:SetExtent(388, 207)
  unitModifierList:AddAnchor("TOPLEFT", anchorPos, "BOTTOMLEFT", 0, 10)
  unitModifierList:HideColumnButtons()
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetLimitWidth(true)
    subItem:SetHeight(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(20, 5, 0, 0)
    if colIndex == COL_INDEX.ATTRIBUTE then
      ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      subItem.style:SetAlign(ALIGN_LEFT)
    else
      ApplyTextColor(subItem, FONT_COLOR.BLUE)
      subItem.style:SetAlign(ALIGN_CENTER)
    end
  end
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      if data.customValue == true then
        subItem:SetText(tostring(data.attributeType))
      else
        subItem:SetText(tostring(locale.attribute(data.attributeType)))
      end
    else
      subItem:SetText("")
    end
  end
  local SetDataValueFunc = function(subItem, data, setValue)
    if setValue then
      if data.customValue == true then
        subItem:SetText(tostring(data.value))
      else
        subItem:SetText(tostring(GetModifierCalcValue(data.attributeType, data.value)))
      end
    else
      subItem:SetText("")
    end
  end
  unitModifierList:InsertColumn("", 310, LCCIT_STRING, SetDataFunc, nil, nil, LayoutFunc)
  unitModifierList:InsertColumn("", 40, LCCIT_STRING, SetDataValueFunc, nil, nil, LayoutFunc)
  unitModifierList:InsertRows(8, false)
  for i = 1, 16 do
    data = {}
    data.customValue = false
    data.attributeType = "attributeType" .. i
    data.unitModifierType = i
    data.value = "value" .. i
    unitModifierList:InsertData(i, 1, data)
    unitModifierList:InsertData(i, 2, data)
  end
  ListCtrlItemGuideLine(unitModifierList.listCtrl.items, unitModifierList:GetRowCount() + 1)
  for i = 1, #unitModifierList.listCtrl.items do
    local item = unitModifierList.listCtrl.items[i]
    item.line:SetVisible(true)
  end
  equip_slot_reinforce_window.detailLevelEffectList = unitModifierList
end
local TAB_INFO = {SET_EFFECT = 1, LEVEL_EFFECT = 2}
local function CreateEquipSlotReinforcePopupWindow(parent)
  local window = CreateWindow("equip_slot_reinforce_effect_title", parent)
  window:SetExtent(430, 350)
  window:AddAnchor("TOPLEFT", parent, "TOPRIGHT", 5, 30)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_effect_title"))
  window:Show(true)
  equip_slot_reinforce_window.popup = window
  local tabNames = {
    X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_set_effect_level"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_level_effect_title")
  }
  local detailWndTab = W_BTN.CreateTab("tab", window, "equip_slot_reinforce_detail_info_tab")
  detailWndTab:AddTabs(tabNames)
  detailWndTab:AddAnchor("TOPLEFT", window, "TOPLEFT", 22, 50)
  function detailWndTab:OnTabChanged(idx)
    ReAnhorTabLine(self, idx)
    if idx == TAB_INFO.SET_EFFECT then
      UpdateEquipSlotReinforceSetEffectDetail()
    else
      UpdateEquipSlotReinforceLevelEffectDetail()
    end
  end
  detailWndTab:SetHandler("OnTabChanged", detailWndTab.OnTabChanged)
  for i = TAB_INFO.SET_EFFECT, TAB_INFO.LEVEL_EFFECT do
    local tabInfoWindow = detailWndTab.window[i]:CreateChildWidget("emptyWidget", "tabInfoWindowWindow." .. i, 0, true)
    tabInfoWindow:Show(true)
    tabInfoWindow:SetExtent(388, 245)
    tabInfoWindow:AddAnchor("CENTER", detailWndTab.window[i], "CENTER", 0, 0)
    local tabInfoWindowBg = CreateContentBackground(detailWndTab.window[i], "TYPE2", "brown_4")
    tabInfoWindowBg:SetExtent(tabInfoWindow:GetExtent())
    tabInfoWindowBg:AddAnchor("TOPLEFT", tabInfoWindow, "TOPLEFT", 0, 0)
    local levelLabel = tabInfoWindow:CreateChildWidget("textbox", "levelLabel", 0, false)
    levelLabel:SetExtent(388, 32)
    levelLabel:SetAutoResize(true)
    levelLabel.style:SetAlign(ALIGN_CENTER)
    levelLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    levelLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_detail_grade", tostring(i - 1)))
    ApplyTextColor(levelLabel, FONT_COLOR.MIDDLE_TITLE)
    levelLabel:AddAnchor("TOPLEFT", tabInfoWindow, "TOPLEFT", 0, 11)
    detailWndTab.window[i].levelLabel = levelLabel
    local detailWindowLine = CreateLine(tabInfoWindow, "TYPE2")
    detailWindowLine:SetColor(ConvertColor(239), ConvertColor(229), ConvertColor(202), 0.5)
    detailWindowLine:AddAnchor("TOPLEFT", levelLabel, "BOTTOMLEFT", -10, 4)
    detailWindowLine:AddAnchor("TOPRIGHT", levelLabel, "BOTTOMRIGHT", -10, 4)
    local viewWindow
    if i == TAB_INFO.SET_EFFECT then
      viewWindow = CreateDetailSetEffectWindow(tabInfoWindow, levelLabel)
    elseif i == TAB_INFO.LEVEL_EFFECT then
      viewWindow = CreateDetailLevelEffectWindow(tabInfoWindow, levelLabel)
    end
  end
  equip_slot_reinforce_window.detailWndTab = detailWndTab
end
function UpdateEquipSlotReinforceDetailInfo()
  UpdateEquipSlotReinforceSetEffectDetail()
  UpdateEquipSlotReinforceLevelEffectDetail()
end
function UpdateEquipSlotReinforceSetEffectDetail()
  local info = GetAppliedAllSetEffect()
  equip_slot_reinforce_window.detailWndTab.window[TAB_INFO.SET_EFFECT].levelLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_detail_grade", tostring(info.totalReinforceLevel)))
  equip_slot_reinforce_window.detailSetEffectList:DeleteAllDatas()
  for i = 1, #info do
    equip_slot_reinforce_window.detailSetEffectList:InsertData(i, 1, info[i])
  end
end
function UpdateEquipSlotReinforceLevelEffectDetail()
  local info = GetAppliedAllLevelEffect()
  equip_slot_reinforce_window.detailLevelEffectList:DeleteAllDatas()
  for i = 1, #info do
    equip_slot_reinforce_window.detailLevelEffectList:InsertData(i, 1, info[i])
    equip_slot_reinforce_window.detailLevelEffectList:InsertData(i, 2, info[i])
  end
  equip_slot_reinforce_window.detailWndTab.window[TAB_INFO.LEVEL_EFFECT].levelLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_detail_grade", tostring(info.totalReinforceLevel)))
end
local InitReinforceSlotInfo = function(equipSlot, level, exp, totalExp, attributeType)
  equip_slot_reinforce_window.reinforceLevelAndExpLabel:SetText(string.format("|v%d;", level))
  equip_slot_reinforce_window.reinforceAddExpGuage:SetMinMaxValues(0, totalExp)
  equip_slot_reinforce_window.reinforceExpGuage:SetMinMaxValues(0, totalExp)
  equip_slot_reinforce_window.reinforceExpGuage:SetValue(exp)
  equip_slot_reinforce_window.reinforceSlotIndexLabel:SetText(GetSlotText(equipSlot))
  local reinforceSlotImg = equip_slot_reinforce_window.reinforceSlotImg
  F_SLOT.ApplySlotSkin(reinforceSlotImg, reinforceSlotImg.back, SLOT_STYLE.EQUIP_ITEM[equipSlot])
  local attributeStr = GetAttibuteText(attributeType)
  equip_slot_reinforce_window.reinforceTypeLabel:SetText("[" .. attributeStr .. "]")
  ApplyTextColor(equip_slot_reinforce_window.reinforceTypeLabel, GetAttibuteTextColor(attributeType))
end
local InitReinforceEffectInfo = function(equipSlot, level)
  if EnableLevelUp(equipSlot) then
    equip_slot_reinforce_window.reinforceEffectLevelLabel:SetText(tostring(level))
    equip_slot_reinforce_window.reinforceEffectNextLevelLabel:SetText(tostring(level + 1))
  else
    equip_slot_reinforce_window.reinforceEffectLevelLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_effect_category_max_level", level))
    equip_slot_reinforce_window.reinforceEffectNextLevelLabel:SetText("")
  end
end
local function InitReinforceLevelEffectInfo(equipSlot)
  local info = GetLevelEffectChangeUIInfo(equipSlot)
  local levelEffectList = info.levelEffectList
  local levelEffectListCount = #info.levelEffectList
  local changeBtnEnable = false
  if levelEffectListCount > 0 then
    changeBtnEnable = true
  end
  equip_slot_reinforce_window.levelEffectChangeBtn:Enable(changeBtnEnable)
  for i = 1, MAX_LEVEL_EFFECT_COUNT do
    local levelEffect = levelEffectList[i]
    local triggerLevel = 0
    if levelEffect ~= nil then
      triggerLevel = levelEffect.triggerLevel
    end
    equip_slot_reinforce_window.levelEffectStepIcon[i]:SetVisible(true)
    if levelEffect ~= nil and levelEffect.attributeType ~= nil then
      local valueStr = GetModifierCalcValue(levelEffect.attributeType, levelEffect.value)
      local attributeStr = locale.attribute(levelEffect.attributeType)
      local str = attributeStr .. " +" .. valueStr
      equip_slot_reinforce_window.levelEffectStepIcon[i]:SetTextureInfo("icon_special")
      equip_slot_reinforce_window.levelEffectStepLabel[i]:SetText(str)
      ApplyTextColor(equip_slot_reinforce_window.levelEffectStepLabel[i], FONT_COLOR.DEFAULT)
    elseif i > levelEffectListCount then
      equip_slot_reinforce_window.levelEffectStepIcon[i]:SetVisible(false)
      equip_slot_reinforce_window.levelEffectStepLabel[i]:SetText("")
    else
      local str = GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_not_ready", tostring(triggerLevel))
      equip_slot_reinforce_window.levelEffectStepIcon[i]:SetTextureInfo("icon_special_bg")
      equip_slot_reinforce_window.levelEffectStepLabel[i]:SetText(str)
      ApplyTextColor(equip_slot_reinforce_window.levelEffectStepLabel[i], FONT_COLOR.DEFAULT_GRAY)
    end
  end
end
local function ClearAllMaterialItemSlot()
  for i = 1, MAX_SLOT_COUNT do
    equip_slot_reinforce_window.materialSlot[i]:SetItemInfo(nil)
    equip_slot_reinforce_window.materialSlot[i]:SetStack(0, 0)
  end
end
local function InitReinforceMaterialInfo(equipSlot, level)
  local materialInfo = GetSlotReinforceMaterialInfo(equipSlot, level)
  local filterBtn = equip_slot_reinforce_window.window.materialWindow.filterBtn
  ClearAllMaterialItemSlot()
  filterBtn:Clear()
  equip_slot_reinforce_window.reinforceAddExpGuage:SetValue(0)
  equip_slot_reinforce_window.reinforceAddExpGuage.shadowDeco:SetVisible(false)
  equip_slot_reinforce_window.reinforceEffectLabelGainExpValue:SetText("+" .. tostring(0))
  local data = {type = "cost", value = 0}
  equip_slot_reinforce_window.window.reinforceCost:SetData(data)
  if #materialInfo <= 0 then
    equip_slot_reinforce_window.window.leftButton:Enable(false)
    return
  end
  if not IsFullExp(equipSlot) then
    local datas = {}
    for i = 1, #materialInfo do
      local data = {
        text = materialInfo[i].name,
        value = i,
        color = materialInfo[i].hasCashItem and FONT_COLOR.ROSE_PINK or FONT_COLOR.DEFAULT
      }
      table.insert(datas, data)
    end
    filterBtn:AppendItems(datas, false)
    function filterBtn:SelectedProc(index)
      selected_material_index = index
      UpdateEquipSlotReinforceMaterial(equipSlot, level, index)
    end
    if selected_material_index == 0 then
      filterBtn:Select(1)
    else
      filterBtn:Select(selected_material_index)
    end
  end
  local helpMsgKey = "equip_slot_reinforce_window_help_msg"
  local leftBtnKey = "equip_slot_reinforce_window_btn_add_exp"
  if IsFullExp(equipSlot) then
    helpMsgKey = "equip_slot_reinforce_window_help_levelup_msg"
    leftBtnKey = "equip_slot_reinforce_window_btn_level_up"
  end
  equip_slot_reinforce_window.costHelpMsgLabel:SetText(GetUIText(COMMON_TEXT, helpMsgKey))
  equip_slot_reinforce_window.window.leftButton:SetText(GetUIText(COMMON_TEXT, leftBtnKey))
  equip_slot_reinforce_window.window.leftButton:Enable(true)
end
function GetExpTooltip()
  local info = GetReinforceInfo(selected_equip_slot)
  local exp = tostring(info.exp)
  local totalExp = tostring(info.totalExp)
  local str = string.format("|,%s; / |,%s; (%.2f%%)", exp, totalExp, info.exp * 100 / info.totalExp)
  return str
end
function UpdateEquipSlotReinforceMaterial(equipSlot, level, materialIndex)
  local materialTable = X2EquipSlotReinforce:GetMaterialInfo(equipSlot, level)
  if materialIndex > #materialTable then
    ClearAllMaterialItemSlot()
    return
  end
  local materialInfo = materialTable[materialIndex]
  local itemList = materialInfo.itemList
  local enoughMaterial = true
  for i = 1, MAX_SLOT_COUNT do
    if i <= #itemList then
      equip_slot_reinforce_window.materialSlot[i]:SetItemInfo(itemList[i].item)
      local curCnt = X2Bag:GetCountInBag(itemList[i].item.itemType)
      equip_slot_reinforce_window.materialSlot[i]:SetStack(curCnt, itemList[i].count)
      if enoughMaterial ~= false and curCnt < itemList[i].count then
        enoughMaterial = false
      end
    else
      equip_slot_reinforce_window.materialSlot[i]:SetItemInfo(nil)
      equip_slot_reinforce_window.materialSlot[i]:SetStack(0, 0)
    end
  end
  equip_slot_reinforce_window.window.leftButton:Enable(enoughMaterial)
  local data = {
    type = "cost",
    currency = materialInfo.currency,
    value = materialInfo.currencyValue
  }
  equip_slot_reinforce_window.window.reinforceCost:SetData(data)
  local curExp = materialTable.curExp
  local totalExp = materialTable.totalExp
  local addedExp = curExp + materialInfo.gainExp
  if totalExp < addedExp then
    addedExp = totalExp
  end
  equip_slot_reinforce_window.reinforceAddExpGuage:SetValue(addedExp)
  equip_slot_reinforce_window.reinforceEffectLabelGainExpValue:SetText("+" .. tostring(addedExp - curExp))
  if addedExp <= 0 then
    equip_slot_reinforce_window.reinforceAddExpGuage.shadowDeco:SetVisible(false)
  elseif totalExp <= addedExp then
    equip_slot_reinforce_window.reinforceAddExpGuage.shadowDeco:SetVisible(false)
  else
    equip_slot_reinforce_window.reinforceAddExpGuage.shadowDeco:SetVisible(true)
  end
  selected_material_type = materialInfo.materialType
end
local function CreateEquipSlotReinforceWindow(parent)
  local window = CreateWindow("equip_slot_reinforce_view", parent)
  window:SetExtent(430, 572)
  window:AddAnchor("TOPLEFT", parent, "TOPRIGHT", 5, 30)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_title"))
  window:Show(false)
  equip_slot_reinforce_window.window = window
  local reinforceSlotLabel = window:CreateChildWidget("label", "reinforceSlotLabel", 0, true)
  reinforceSlotLabel:AddAnchor("TOPLEFT", window, "TOPLEFT", 36, 50)
  reinforceSlotLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinforceSlotLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(reinforceSlotLabel, FONT_COLOR.DEFAULT)
  reinforceSlotLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_slot"))
  W_ICON.DrawDingbat(reinforceSlotLabel)
  local reinforceSlotImg = CreateItemIconButton("reinforceSlotImg", window, "constant")
  reinforceSlotImg:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
  reinforceSlotImg:EnableDrag(false)
  reinforceSlotImg.back:SetColor(1, 1, 1, 1)
  reinforceSlotImg:AddAnchor("TOPLEFT", reinforceSlotLabel, "BOTTOMLEFT", 0, 5)
  equip_slot_reinforce_window.reinforceSlotImg = reinforceSlotImg
  local reinforceSlotIndexLabel = window:CreateChildWidget("label", "reinforceSlotIndexLabel", 0, true)
  reinforceSlotIndexLabel:AddAnchor("TOPLEFT", reinforceSlotImg, "TOPRIGHT", 5, 5)
  reinforceSlotIndexLabel:SetHeight(FONT_SIZE.LARGE)
  reinforceSlotIndexLabel.style:SetFontSize(FONT_SIZE.LARGE)
  reinforceSlotIndexLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(reinforceSlotIndexLabel, FONT_COLOR.DEFAULT)
  reinforceSlotIndexLabel:SetText(GetSlotText(2))
  equip_slot_reinforce_window.reinforceSlotIndexLabel = reinforceSlotIndexLabel
  local reinforceTypeLabel = window:CreateChildWidget("label", "reinforceTypeLabel", 0, true)
  reinforceTypeLabel:AddAnchor("TOPRIGHT", window, "TOPRIGHT", -25, 76)
  reinforceTypeLabel:SetAutoResize(true)
  reinforceTypeLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinforceTypeLabel.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(reinforceTypeLabel, FONT_COLOR.DEFAULT)
  reinforceTypeLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_offense"))
  equip_slot_reinforce_window.reinforceTypeLabel = reinforceTypeLabel
  local reinforceLevelAndExpLabel = window:CreateChildWidget("textbox", "reinforceLevelAndExpLabel", 0, false)
  reinforceLevelAndExpLabel:SetExtent(40, FONT_SIZE.LARGE)
  reinforceLevelAndExpLabel:SetAutoResize(true)
  reinforceLevelAndExpLabel:SetHeight(15)
  reinforceLevelAndExpLabel.style:SetFontSize(FONT_SIZE.LARGE)
  reinforceLevelAndExpLabel.style:SetAlign(ALIGN_LEFT)
  reinforceLevelAndExpLabel:SetText(string.format("|v%d;", 14))
  reinforceLevelAndExpLabel:AddAnchor("BOTTOMLEFT", reinforceSlotImg, "BOTTOMRIGHT", 5, 0)
  ApplyTextColor(reinforceLevelAndExpLabel, FONT_COLOR.DEFAULT)
  equip_slot_reinforce_window.reinforceLevelAndExpLabel = reinforceLevelAndExpLabel
  local reinforceAddExpGuage = W_BAR.CreateStatusBar("reinforceAddExpGuage", window, "reinforceAddExpGuage")
  reinforceAddExpGuage:SetWidth(265)
  reinforceAddExpGuage:SetHeight(14)
  reinforceAddExpGuage:SetMinMaxValues(0, 150)
  reinforceAddExpGuage:SetValue(100)
  reinforceAddExpGuage:SetBarColor({
    ConvertColor(240),
    ConvertColor(185),
    ConvertColor(126),
    1
  })
  reinforceAddExpGuage:AddAnchor("TOPRIGHT", reinforceTypeLabel, "BOTTOMRIGHT", 0, 10)
  local shadowDeco = reinforceAddExpGuage:CreateDrawable(TEXTURE_PATH.COSPLAY_ENCHANT, "gage_shadow", "artwork")
  reinforceAddExpGuage.statusBar:AddAnchorChildToBar(shadowDeco, "TOPLEFT", "TOPRIGHT", 0, 0)
  reinforceAddExpGuage.shadowDeco = shadowDeco
  shadowDeco:SetVisible(true)
  equip_slot_reinforce_window.reinforceAddExpGuage = reinforceAddExpGuage
  local reinforceExpGuage = W_BAR.CreateStatusBar("reinforceExpGuage", window, "reinforceExpGuage")
  reinforceExpGuage:SetWidth(265)
  reinforceExpGuage:SetHeight(14)
  reinforceExpGuage:SetMinMaxValues(0, 150)
  reinforceExpGuage:SetValue(100)
  reinforceExpGuage:SetBarColor({
    ConvertColor(253),
    ConvertColor(228),
    ConvertColor(103),
    1
  })
  reinforceExpGuage:AddAnchor("TOPRIGHT", reinforceTypeLabel, "BOTTOMRIGHT", 0, 10)
  local OnEnter = function(self)
    SetTargetAnchorTooltip(GetExpTooltip(), "BOTTOMLEFT", self, "TOPLEFT", -1, -1)
  end
  reinforceExpGuage:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  reinforceExpGuage:SetHandler("OnLeave", OnLeave)
  equip_slot_reinforce_window.reinforceExpGuage = reinforceExpGuage
  local reinforceEffectLabelGainExpValue = window:CreateChildWidget("label", "reinforceEffectLabelGainExpValue", 0, true)
  reinforceEffectLabelGainExpValue:SetExtent(60, FONT_SIZE.SMALL)
  reinforceEffectLabelGainExpValue:SetAutoResize(true)
  reinforceEffectLabelGainExpValue.style:SetFontSize(FONT_SIZE.SMALL)
  reinforceEffectLabelGainExpValue:AddAnchor("TOPRIGHT", reinforceExpGuage, "BOTTOMRIGHT", 0, 3)
  reinforceEffectLabelGainExpValue:SetText("+111")
  ApplyTextColor(reinforceEffectLabelGainExpValue, FONT_COLOR.BLUE)
  equip_slot_reinforce_window.reinforceEffectLabelGainExpValue = reinforceEffectLabelGainExpValue
  local reinforceEffectLabelGainExp = window:CreateChildWidget("label", "reinforceEffectLabelGainExp", 0, true)
  reinforceEffectLabelGainExp:SetExtent(60, FONT_SIZE.SMALL)
  reinforceEffectLabelGainExp.style:SetFontSize(FONT_SIZE.SMALL)
  reinforceEffectLabelGainExp:AddAnchor("BOTTOMRIGHT", reinforceEffectLabelGainExpValue, "BOTTOMLEFT", 0, 0)
  reinforceEffectLabelGainExp:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_gain_exp"))
  ApplyTextColor(reinforceEffectLabelGainExp, FONT_COLOR.DEFAULT)
  equip_slot_reinforce_window.reinforceEffectLabelGainExp = reinforceEffectLabelGainExp
  local reinforceEffectLabel = window:CreateChildWidget("label", "reinforceEffectLabel", 0, true)
  reinforceEffectLabel:AddAnchor("TOPLEFT", reinforceSlotLabel, "TOPLEFT", 0, 81)
  reinforceEffectLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinforceEffectLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(reinforceEffectLabel, FONT_COLOR.DEFAULT)
  reinforceEffectLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_effect"))
  W_ICON.DrawDingbat(reinforceEffectLabel)
  local effectBgWindow = window:CreateChildWidget("emptyWidget", "effectBgWindow", 0, true)
  effectBgWindow:Show(true)
  effectBgWindow:SetExtent(395, 64)
  effectBgWindow:AddAnchor("TOPLEFT", reinforceEffectLabel, "BOTTOMLEFT", -19, 2)
  local effectBg = CreateContentBackground(effectBgWindow, "TYPE11", "brown_2")
  effectBg:SetExtent(395, 64)
  effectBg:AddAnchor("TOPLEFT", effectBgWindow, 0, 0)
  local reinforceEffectCategoty = effectBgWindow:CreateChildWidget("label", "reinforceEffectCategoty", 0, true)
  reinforceEffectCategoty:AddAnchor("TOPLEFT", effectBg, "TOPLEFT", 0, 10)
  reinforceEffectCategoty:SetHeight(20)
  reinforceEffectCategoty:SetWidth(198)
  reinforceEffectCategoty.style:SetFontSize(FONT_SIZE.MIDDLE)
  reinforceEffectCategoty.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(reinforceEffectCategoty, FONT_COLOR.DEFAULT)
  reinforceEffectCategoty:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_effect_category"))
  local reinforceEffectLevel = effectBgWindow:CreateChildWidget("label", "reinforceEffectLevel", 0, true)
  reinforceEffectLevel:AddAnchor("TOPLEFT", reinforceEffectCategoty, "TOPRIGHT", 0, 0)
  reinforceEffectLevel:SetHeight(20)
  reinforceEffectLevel:SetWidth(94)
  reinforceEffectLevel.style:SetAlign(ALIGN_CENTER)
  reinforceEffectLevel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(reinforceEffectLevel, FONT_COLOR.DEFAULT)
  reinforceEffectLevel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_cur_level"))
  local reinforceEffectNextLevel = effectBgWindow:CreateChildWidget("label", "reinforceEffectNextLevel", 0, true)
  reinforceEffectNextLevel:AddAnchor("TOPLEFT", reinforceEffectLevel, "TOPRIGHT", 0, 0)
  reinforceEffectNextLevel:SetHeight(20)
  reinforceEffectNextLevel:SetWidth(103)
  reinforceEffectNextLevel.style:SetFontSize(FONT_SIZE.MIDDLE)
  reinforceEffectNextLevel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(reinforceEffectNextLevel, FONT_COLOR.DEFAULT)
  reinforceEffectNextLevel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_next_level"))
  local labels = {
    reinforceEffectCategoty,
    reinforceEffectLevel,
    reinforceEffectNextLevel
  }
  for i = 1, 3 do
    local line = DrawListCtrlColumnSperatorLine(labels[i], #labels, i)
    if line ~= nil then
      line:SetColor(ConvertColor(114), ConvertColor(94), ConvertColor(50), 0.5)
    end
  end
  local reinforceEffectLine = CreateLine(effectBgWindow, "TYPE2")
  reinforceEffectLine:SetColor(ConvertColor(239), ConvertColor(229), ConvertColor(202), 0.5)
  reinforceEffectLine:AddAnchor("TOPLEFT", reinforceEffectCategoty, "BOTTOMLEFT", -15, -4)
  reinforceEffectLine:AddAnchor("TOPRIGHT", reinforceEffectNextLevel, "BOTTOMRIGHT", -15, -4)
  local reinforceEffectLable = effectBgWindow:CreateChildWidget("label", "reinforceEffectLable", 0, true)
  reinforceEffectLable:AddAnchor("TOPLEFT", reinforceEffectCategoty, "BOTTOMLEFT", 0, 0)
  reinforceEffectLable:SetHeight(37)
  reinforceEffectLable:SetWidth(198)
  reinforceEffectLable.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(reinforceEffectLable, FONT_COLOR.DEFAULT)
  reinforceEffectLable:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_effect_item_level"))
  local reinforceEffectLevelLabel = effectBgWindow:CreateChildWidget("textBox", "reinforceEffectLevelLabel", 0, true)
  reinforceEffectLevelLabel:AddAnchor("TOPLEFT", reinforceEffectLevel, "BOTTOMLEFT", 0, 0)
  reinforceEffectLevelLabel:SetHeight(37)
  reinforceEffectLevelLabel:SetWidth(94)
  reinforceEffectLevelLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(reinforceEffectLevelLabel, FONT_COLOR.DEFAULT)
  reinforceEffectLevelLabel:SetText("14")
  equip_slot_reinforce_window.reinforceEffectLevelLabel = reinforceEffectLevelLabel
  local reinforceEffectNextLevelLabel = effectBgWindow:CreateChildWidget("textBox", "reinforceEffectNextLevelLabel", 0, true)
  reinforceEffectNextLevelLabel:AddAnchor("TOPLEFT", reinforceEffectNextLevel, "BOTTOMLEFT", 0, 0)
  reinforceEffectNextLevelLabel:SetHeight(37)
  reinforceEffectNextLevelLabel:SetWidth(103)
  reinforceEffectNextLevelLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(reinforceEffectNextLevelLabel, FONT_COLOR.DEFAULT)
  reinforceEffectNextLevelLabel:SetText("15")
  equip_slot_reinforce_window.reinforceEffectNextLevelLabel = reinforceEffectNextLevelLabel
  local reinforceLevelEffectLabel = window:CreateChildWidget("label", "reinforceLevelEffectLabel", 0, true)
  reinforceLevelEffectLabel:AddAnchor("TOPLEFT", effectBgWindow, "BOTTOMLEFT", 19, 11)
  reinforceLevelEffectLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinforceLevelEffectLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(reinforceLevelEffectLabel, FONT_COLOR.DEFAULT)
  reinforceLevelEffectLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_level_effect_title"))
  W_ICON.DrawDingbat(reinforceLevelEffectLabel)
  local levelEffectBgWindow = window:CreateChildWidget("emptyWidget", "levelEffectBgWindow", 0, true)
  levelEffectBgWindow:Show(true)
  levelEffectBgWindow:SetExtent(395, 76)
  levelEffectBgWindow:AddAnchor("TOPLEFT", reinforceLevelEffectLabel, "BOTTOMLEFT", -19, 2)
  local levelEffectBg = CreateContentBackground(levelEffectBgWindow, "TYPE11", "brown_2")
  levelEffectBg:AddAnchor("TOPLEFT", reinforceLevelEffectLabel, "BOTTOMLEFT", -19, 2)
  levelEffectBg:SetExtent(395, 76)
  local levelEffectChangeBtn = CreateEmptyButton("levelEffectChangeBtn", levelEffectBgWindow)
  levelEffectChangeBtn:Show(true)
  levelEffectChangeBtn:RegisterForClicks("LeftButton")
  levelEffectChangeBtn:EnableDrag(false)
  levelEffectChangeBtn:AddAnchor("BOTTOMRIGHT", levelEffectBgWindow, "TOPRIGHT", -2, 0)
  ApplyButtonSkin(levelEffectChangeBtn, EQUIP_SLOT_REINFORCE_IMG_INFO.BTN_LEVEL_EFFECT_CHANGE)
  local LevelEffectChangeBtnLeftClickFunc = function()
    ShowLevelEffectChangeWindow()
  end
  ButtonOnClickHandler(levelEffectChangeBtn, LevelEffectChangeBtnLeftClickFunc)
  equip_slot_reinforce_window.levelEffectChangeBtn = levelEffectChangeBtn
  local levelEffectDetailBtn = CreateEmptyButton("levelEffectDetailBtn", levelEffectBgWindow)
  levelEffectDetailBtn:Show(true)
  levelEffectDetailBtn:RegisterForClicks("LeftButton")
  levelEffectDetailBtn:EnableDrag(false)
  levelEffectDetailBtn:AddAnchor("BOTTOMRIGHT", levelEffectChangeBtn, "BOTTOMLEFT", -4, 0)
  ApplyButtonSkin(levelEffectDetailBtn, EQUIP_SLOT_REINFORCE_IMG_INFO.BTN_LEVEL_EFFECT_DETAIL)
  local LevelEffectDetailBtnLeftClickFunc = function()
    ShowLevelEffectDetailWindow()
  end
  ButtonOnClickHandler(levelEffectDetailBtn, LevelEffectDetailBtnLeftClickFunc)
  equip_slot_reinforce_window.levelEffectDetailBtn = levelEffectDetailBtn
  local levelEffectStepIcon1 = levelEffectBgWindow:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  levelEffectStepIcon1:SetTextureInfo("icon_special")
  levelEffectStepIcon1:AddAnchor("TOPLEFT", levelEffectBgWindow, "TOPLEFT", 17, 9)
  local levelEffectStepLabel1 = levelEffectBgWindow:CreateChildWidget("label", "levelEffectStepLabel1", 0, true)
  levelEffectStepLabel1:SetText(GetUIText(COMMON_TEXT, "bless_uthstin_copy_popup_tab_name", tostring(1)))
  levelEffectStepLabel1:AddAnchor("TOPLEFT", levelEffectStepIcon1, "TOPRIGHT", 6, 0)
  levelEffectStepLabel1:SetExtent(320, FONT_SIZE.MIDDLE)
  levelEffectStepLabel1.style:SetAlign(ALIGN_LEFT)
  levelEffectStepLabel1.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectStepLabel1, FONT_COLOR.DEFAULT)
  local levelEffectStepIcon2 = levelEffectBgWindow:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  levelEffectStepIcon2:SetTextureInfo("icon_special")
  levelEffectStepIcon2:AddAnchor("TOPLEFT", levelEffectStepIcon1, "BOTTOMLEFT", 0, 5)
  local levelEffectStepLabel2 = levelEffectBgWindow:CreateChildWidget("label", "levelEffectStepLabel2", 0, true)
  levelEffectStepLabel2:SetText(GetUIText(COMMON_TEXT, "bless_uthstin_copy_popup_tab_name", tostring(2)))
  levelEffectStepLabel2:AddAnchor("TOPLEFT", levelEffectStepIcon2, "TOPRIGHT", 6, 0)
  levelEffectStepLabel2:SetExtent(320, FONT_SIZE.MIDDLE)
  levelEffectStepLabel2.style:SetAlign(ALIGN_LEFT)
  levelEffectStepLabel2.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectStepLabel2, FONT_COLOR.DEFAULT)
  local levelEffectStepIcon3 = levelEffectBgWindow:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  levelEffectStepIcon3:SetTextureInfo("icon_special_bg")
  levelEffectStepIcon3:AddAnchor("TOPLEFT", levelEffectStepIcon2, "BOTTOMLEFT", 0, 5)
  local levelEffectStepLabel3 = levelEffectBgWindow:CreateChildWidget("label", "levelEffectStepLabel3", 0, true)
  levelEffectStepLabel3:SetText(GetUIText(COMMON_TEXT, "bless_uthstin_copy_popup_tab_name", tostring(3)))
  levelEffectStepLabel3:AddAnchor("TOPLEFT", levelEffectStepIcon3, "TOPRIGHT", 6, 0)
  levelEffectStepLabel3:SetExtent(320, FONT_SIZE.MIDDLE)
  levelEffectStepLabel3.style:SetAlign(ALIGN_LEFT)
  levelEffectStepLabel3.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectStepLabel3, FONT_COLOR.DEFAULT)
  equip_slot_reinforce_window.levelEffectStepIcon = {}
  equip_slot_reinforce_window.levelEffectStepLabel = {}
  equip_slot_reinforce_window.levelEffectStepIcon[1] = levelEffectStepIcon1
  equip_slot_reinforce_window.levelEffectStepIcon[2] = levelEffectStepIcon2
  equip_slot_reinforce_window.levelEffectStepIcon[3] = levelEffectStepIcon3
  equip_slot_reinforce_window.levelEffectStepLabel[1] = levelEffectStepLabel1
  equip_slot_reinforce_window.levelEffectStepLabel[2] = levelEffectStepLabel2
  equip_slot_reinforce_window.levelEffectStepLabel[3] = levelEffectStepLabel3
  local reinforceMaterialLabel = window:CreateChildWidget("label", "reinforceMaterialLabel", 0, true)
  reinforceMaterialLabel:AddAnchor("TOPLEFT", levelEffectBgWindow, "BOTTOMLEFT", 19, 8)
  reinforceMaterialLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinforceMaterialLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(reinforceMaterialLabel, FONT_COLOR.DEFAULT)
  reinforceMaterialLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_resource"))
  W_ICON.DrawDingbat(reinforceMaterialLabel)
  local materialWindow = window:CreateChildWidget("emptyWidget", "materialWindow", 0, true)
  materialWindow:Show(true)
  materialWindow:SetExtent(395, 101)
  materialWindow:AddAnchor("TOPLEFT", reinforceMaterialLabel, "BOTTOMLEFT", -19, 2)
  local materialBg = CreateContentBackground(effectBgWindow, "TYPE11", "brown_2")
  materialBg:SetExtent(395, 101)
  materialBg:AddAnchor("TOPLEFT", materialWindow, 0, 0)
  local filterBtn = W_CTRL.CreateComboBox("filterBtn", materialWindow)
  filterBtn:AddAnchor("TOPLEFT", materialWindow, 14, 11)
  filterBtn:SetWidth(155)
  local changeCashBtn = CreateEmptyButton("changeCashBtn", materialWindow)
  changeCashBtn:Show(true)
  changeCashBtn:RegisterForClicks("LeftButton")
  changeCashBtn:EnableDrag(false)
  changeCashBtn:AddAnchor("TOPLEFT", filterBtn, "TOPRIGHT", 4, -3)
  ApplyButtonSkin(changeCashBtn, EQUIP_SLOT_REINFORCE_IMG_INFO.BTN_CHANGE_CASH)
  local CashShopBtnLeftClickFunc = function()
    ToggleInGameShop(true, characetInfoLocale.reinforceIngameShop.mainTabIdx, characetInfoLocale.reinforceIngameShop.subTabIdx)
  end
  ButtonOnClickHandler(changeCashBtn, CashShopBtnLeftClickFunc)
  equip_slot_reinforce_window.changeCashBtn = changeCashBtn
  equip_slot_reinforce_window.materialSlot = {}
  local materialSlotGroup = materialWindow:CreateChildWidget("emptyWidget", "materialSlotGroup", 0, true)
  materialSlotGroup:Show(true)
  materialSlotGroup:SetExtent((ICON_SIZE.LARGE + 5) * 7, ICON_SIZE.LARGE)
  materialSlotGroup:AddAnchor("TOPLEFT", filterBtn, "BOTTOMLEFT", 0, 7)
  for i = 1, MAX_SLOT_COUNT do
    local materialSlotImg = CreateItemIconButton("slotFirstMaterialItem", materialWindow)
    materialSlotImg:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
    materialSlotImg:AddAnchor("TOPLEFT", materialSlotGroup, "TOPLEFT", (ICON_SIZE.LARGE + 5) * (i - 1), 0)
    materialSlotImg.back:SetVisible(true)
    equip_slot_reinforce_window.materialSlot[i] = materialSlotImg
  end
  local reinforceCost = W_MODULE:Create("reinforceCost", window, WINDOW_MODULE_TYPE.VALUE_BOX)
  reinforceCost:AddAnchor("TOP", materialWindow, "BOTTOM", 0, 10)
  local costHelpMsgLabel = window:CreateChildWidget("textbox", "costHelpMsgLabel", 0, true)
  costHelpMsgLabel:SetExtent(430, 30)
  costHelpMsgLabel:AddAnchor("BOTTOMLEFT", window, "BOTTOMLEFT", 0, -65)
  costHelpMsgLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(costHelpMsgLabel, FONT_COLOR.DEFAULT)
  costHelpMsgLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_help_msg"))
  equip_slot_reinforce_window.costHelpMsgLabel = costHelpMsgLabel
  local buttonSetInfo = {
    leftButtonLeftClickFunc = function()
      if IsFullExp(selected_equip_slot) then
        StartReinforceLevelup(selected_equip_slot)
      else
        StartReinforceAddExp(selected_equip_slot, selected_material_type)
      end
    end,
    rightButtonLeftClickFunc = function()
      window:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(window, buttonSetInfo)
end
local CreateEquipSlotReinforceLevelEffectDetailWindow = function(parent)
  local windowWidth = 300
  local window = CreateWindow("equip_slot_reinforce_window_level_effect_info", parent)
  window:SetExtent(windowWidth, 430)
  window:AddAnchor("TOPLEFT", parent, "TOPRIGHT", 5, 30)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_level_effect_info_title"))
  window:Show(false)
  equip_slot_reinforce_window.levelEffectInfoWindow = window
  local infoLabel = window:CreateChildWidget("textbox", "info_desc", 0, false)
  infoLabel:SetExtent(264, FONT_SIZE.LARGE)
  infoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  infoLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_window_level_effect_info_desc"))
  ApplyTextColor(infoLabel, FONT_COLOR.MIDDLE_TITLE)
  infoLabel:AddAnchor("TOPLEFT", window, "TOPLEFT", 18, 50)
  local levelEffectInfoBgWindow = window:CreateChildWidget("emptyWidget", "levelEffectInfoBgWindow", 0, true)
  levelEffectInfoBgWindow:Show(true)
  levelEffectInfoBgWindow:SetExtent(264, 293)
  levelEffectInfoBgWindow:AddAnchor("TOPLEFT", infoLabel, "BOTTOMLEFT", 0, 2)
  local levelEffectInfoBg = CreateContentBackground(levelEffectInfoBgWindow, "TYPE2", "brown_4")
  levelEffectInfoBg:SetExtent(264, 300)
  levelEffectInfoBg:AddAnchor("CENTER", levelEffectInfoBgWindow, "CENTER", 0, 0)
  local levelEffectInfoList = W_CTRL.CreateScrollListCtrl("listCtrl", window)
  levelEffectInfoList.scroll:RemoveAllAnchors()
  levelEffectInfoList.scroll:AddAnchor("TOPRIGHT", levelEffectInfoList, 0, 0)
  levelEffectInfoList.scroll:AddAnchor("BOTTOMRIGHT", levelEffectInfoList, 0, 0)
  levelEffectInfoList:SetExtent(264, 293)
  levelEffectInfoList:AddAnchor("TOPLEFT", levelEffectInfoBgWindow, "TOPLEFT", 0, 5)
  levelEffectInfoList:HideColumnButtons()
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetExtent(185, 28)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      if data.attributeKey == "" then
        subItem:SetText(string.format("|V%d;", data.value))
        subItem:AddAnchor("TOPLEFT", subItem, "TOPLEFT", 0, 0)
      else
        local attributeStr = locale.attribute(data.attributeKey)
        subItem:SetText(attributeStr)
        subItem:AddAnchor("TOPLEFT", subItem, "TOPLEFT", 10, 0)
      end
    else
      subItem:SetText("")
    end
  end
  local ValueLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetExtent(44, 28)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local ValueSetDataFunc = function(subItem, data, setValue)
    if setValue then
      if data.attributeKey ~= "" then
        local valueStr = GetModifierCalcValue(data.attributeKey, data.value)
        subItem:SetText(valueStr)
      else
        subItem:SetText("")
      end
    else
      subItem:SetText("")
    end
  end
  levelEffectInfoList:InsertColumn("", 185, LCCIT_TEXTBOX, SetDataFunc, nil, nil, LayoutFunc)
  levelEffectInfoList:InsertColumn("", 44, LCCIT_STRING, ValueSetDataFunc, nil, nil, ValueLayoutFunc)
  levelEffectInfoList:InsertRows(10, true)
  for i = 1, 16 do
    local data = {}
    data.attribute = i
    data.attributeKey = ""
    data.value = tostring(i)
    levelEffectInfoList:InsertData(i, 1, data)
    levelEffectInfoList:InsertData(i, 2, data)
  end
  ListCtrlItemGuideLine(levelEffectInfoList.listCtrl.items, levelEffectInfoList:GetRowCount() + 1)
  for i = 1, #levelEffectInfoList.listCtrl.items do
    local item = levelEffectInfoList.listCtrl.items[i]
    item.line:SetVisible(true)
  end
  equip_slot_reinforce_window.levelEffectInfoList = levelEffectInfoList
  local levelEffectInfoHelpLabel = window:CreateChildWidget("textbox", "levelEffectInfoHelpLabel", 0, true)
  levelEffectInfoHelpLabel:SetExtent(264, 60)
  levelEffectInfoHelpLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(levelEffectInfoHelpLabel, FONT_COLOR.GRAY)
  levelEffectInfoHelpLabel:AddAnchor("TOPLEFT", levelEffectInfoBgWindow, "BOTTOMLEFT", 0, 6)
  levelEffectInfoHelpLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_window_level_effect_info_help_msg", tostring(0)))
  equip_slot_reinforce_window.levelEffectInfoHelpLabel = levelEffectInfoHelpLabel
end
local function CreateEquipSlotReinforceLevelEffectChangeWindow(parent)
  local windowWidth = 300
  local window = CreateWindow("equip_slot_reinforce_level_effect_change_window", parent)
  window:SetExtent(windowWidth, 370)
  window:AddAnchor("TOPLEFT", parent, "TOPRIGHT", 5, 30)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_level_effect_window_title"))
  window:Show(false)
  equip_slot_reinforce_window.levelEffectChangeWindow = window
  local materialSlotImg = CreateItemIconButton("slotFirstMaterialItem", window)
  materialSlotImg:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  materialSlotImg:AddAnchor("CENTER", window, "TOPLEFT", windowWidth / 2, 58)
  materialSlotImg.back:SetVisible(true)
  equip_slot_reinforce_window.levelEffectChangeMaterialItem = materialSlotImg
  local materialLabel = window:CreateChildWidget("label", "changeMetrial", 0, true)
  materialLabel:SetExtent(248, FONT_SIZE.LARGE)
  materialLabel:AddAnchor("CENTER", materialSlotImg, "CENTER", 0, ICON_SIZE.DEFAULT / 2 + 16)
  materialLabel.style:SetAlign(ALIGN_CENTER)
  materialLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(materialLabel, FONT_COLOR.DEFAULT)
  materialLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_level_effect_material"))
  local levelEffectBgWindow = window:CreateChildWidget("emptyWidget", "levelEffectBgWindow", 0, true)
  levelEffectBgWindow:Show(true)
  levelEffectBgWindow:SetExtent(256, 106)
  levelEffectBgWindow:AddAnchor("CENTER", materialLabel, "CENTER", 0, levelEffectBgWindow:GetHeight() / 2 + 16)
  local levelEffectBg = CreateContentBackground(levelEffectBgWindow, "TYPE2", "brown_4")
  levelEffectBg:SetExtent(256, 106)
  levelEffectBg:AddAnchor("CENTER", levelEffectBgWindow, "CENTER", 0, 0)
  local levelEffectLabel = levelEffectBgWindow:CreateChildWidget("label", "levelEffectLabel", 0, true)
  levelEffectLabel:SetExtent(200, FONT_SIZE.MIDDLE)
  levelEffectLabel:AddAnchor("TOPLEFT", levelEffectBgWindow, "TOPLEFT", 14, 10)
  levelEffectLabel.style:SetAlign(ALIGN_LEFT)
  levelEffectLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectLabel, FONT_COLOR.MIDDLE_TITLE)
  levelEffectLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_set_effect_set_title"))
  local line = CreateLine(levelEffectBgWindow, "TYPE1")
  line:AddAnchor("TOPLEFT", levelEffectLabel, "BOTTOMLEFT", -15, 5)
  line:AddAnchor("TOPRIGHT", levelEffectLabel, "BOTTOMRIGHT", -15, 5)
  local radioBoxes = CreateRadioGroup("radioBoxes", levelEffectLabel, "vertical")
  radioBoxes:AddAnchor("TOPLEFT", levelEffectLabel, "BOTTOMLEFT", 0, 10)
  radioBoxes:SetWidth(levelEffectLabel:GetWidth() - 20)
  radioBoxes:SetDisableAlphaValue(0.8)
  equip_slot_reinforce_window.levelEffectRadioGroup = radioBoxes
  radioBoxes.secondLabels = {}
  for i = 1, MAX_LEVEL_EFFECT_COUNT do
    local secondLabel = radioBoxes:CreateChildWidget("label", "levelEffectUnitModifierLabel", i, true)
    secondLabel:SetExtent(45, 11)
    secondLabel.style:SetAlign(ALIGN_RIGHT)
    secondLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(secondLabel, FONT_COLOR.DEFAULT)
    table.insert(radioBoxes.secondLabels, secondLabel)
  end
  function radioBoxes:OnRadioChanged(index, dataValue)
    local data = self:GetData()
    local attributeTypeStr = data[index].text
    local valueStr = self.secondLabels[index]:GetText()
    equip_slot_reinforce_window.levelEffectUnitModifierLabel:SetText(string.format("%s %s", attributeTypeStr, valueStr))
    selected_level_effect_index = index
  end
  radioBoxes:SetHandler("OnRadioChanged", radioBoxes.OnRadioChanged)
  local levelEffectUnitModifierLabel = levelEffectBgWindow:CreateChildWidget("label", "levelEffectUnitModifierLabel", 0, true)
  levelEffectUnitModifierLabel:SetExtent(200, FONT_SIZE.MIDDLE)
  levelEffectUnitModifierLabel:AddAnchor("CENTER", levelEffectBgWindow, "CENTER", 0, (levelEffectBgWindow:GetHeight() + levelEffectUnitModifierLabel:GetHeight()) / 2 + 10)
  levelEffectUnitModifierLabel.style:SetAlign(ALIGN_CENTER)
  levelEffectUnitModifierLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectUnitModifierLabel, F_COLOR.GetColor("bright_blue", false))
  equip_slot_reinforce_window.levelEffectUnitModifierLabel = levelEffectUnitModifierLabel
  local levelEffectItemHelpLabel = levelEffectBgWindow:CreateChildWidget("textbox", "levelEffectItemHelpLabel", 0, true)
  levelEffectItemHelpLabel:SetExtent(windowWidth, FONT_SIZE.MIDDLE * 2)
  levelEffectItemHelpLabel:AddAnchor("CENTER", levelEffectUnitModifierLabel, "CENTER", 0, (levelEffectItemHelpLabel:GetHeight() + levelEffectItemHelpLabel:GetHeight()) / 2 + 12)
  levelEffectItemHelpLabel.style:SetAlign(ALIGN_CENTER)
  levelEffectItemHelpLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectItemHelpLabel, FONT_COLOR.GRAY)
  levelEffectItemHelpLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_level_effect_change_item_help_msg"))
  equip_slot_reinforce_window.levelEffectItemHelpLabel = levelEffectItemHelpLabel
  local levelEffectCashItemHelpLabel = levelEffectBgWindow:CreateChildWidget("textbox", "levelEffectCashItemHelpLabel", 0, true)
  levelEffectCashItemHelpLabel:SetExtent(windowWidth, FONT_SIZE.MIDDLE * 2)
  levelEffectCashItemHelpLabel:AddAnchor("CENTER", levelEffectItemHelpLabel, "CENTER", 0, (levelEffectCashItemHelpLabel:GetHeight() + levelEffectItemHelpLabel:GetHeight()) / 2)
  levelEffectCashItemHelpLabel.style:SetAlign(ALIGN_CENTER)
  levelEffectCashItemHelpLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(levelEffectCashItemHelpLabel, FONT_COLOR.GRAY)
  levelEffectCashItemHelpLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "equip_slot_reinforce_level_effect_change_cash_item_help_msg"))
  equip_slot_reinforce_window.levelEffectCashItemHelpLabel = levelEffectCashItemHelpLabel
  local buttonSetInfo = {
    leftButtonLeftClickFunc = function()
      ChangeLevelEffect(selected_equip_slot, selected_level_effect_index)
    end,
    rightButtonLeftClickFunc = function()
      window:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(window, buttonSetInfo)
end
function CreateReinforceBtn(parent)
  local reinforceBtn = CreateEmptyButton("equippedItem.equipSlotReinforceBtn.reinforce", parent)
  reinforceBtn:Show(true)
  reinforceBtn:RegisterForClicks("LeftButton")
  reinforceBtn:EnableDrag(false)
  reinforceBtn:AddAnchor("TOPRIGHT", parent, "TOP", 205, -61)
  ApplyButtonSkin(reinforceBtn, EQUIP_SLOT_REINFORCE_IMG_INFO.VIEW_REINFORCE)
  parent.equipSlotReinforceBtn.reinforce = reinforceBtn
  local RefinforceBtnLeftClickFunc = function()
    ShowEquipmentMode()
  end
  ButtonOnClickHandler(reinforceBtn, RefinforceBtnLeftClickFunc)
  local equipBtn = CreateEmptyButton("equippedItem.equipSlotReinforceBtn.equip", parent)
  equipBtn:Show(false)
  equipBtn:RegisterForClicks("LeftButton")
  equipBtn:EnableDrag(false)
  ApplyButtonSkin(equipBtn, EQUIP_SLOT_REINFORCE_IMG_INFO.VIEW_NORMAL)
  equipBtn:AddAnchor("TOPRIGHT", parent, "TOP", 205, -61)
  parent.equipSlotReinforceBtn.equip = equipBtn
  local EquipBtnLeftClickFunc = function()
    ShowReinforceMode()
  end
  ButtonOnClickHandler(equipBtn, EquipBtnLeftClickFunc)
  local detailBtn = CreateEmptyButton("equippedItem.equipSlotReinforceBtn.detail", equipBtn)
  detailBtn:Show(true)
  detailBtn:RegisterForClicks("LeftButton")
  detailBtn:EnableDrag(false)
  ApplyButtonSkin(detailBtn, EQUIP_SLOT_REINFORCE_IMG_INFO.VIEW_DETAIL)
  detailBtn:AddAnchor("TOPRIGHT", equipBtn, "TOPRIGHT", 34, 26)
  parent.equipSlotReinforceBtn.detailBtn = detailBtn
  local DetailBtnLeftClickFunc = function()
    if equip_slot_reinforce_window.popup:IsVisible() then
      equip_slot_reinforce_window.popup:Show(false)
    else
      UpdateEquipSlotReinforceDetailInfo()
      equip_slot_reinforce_window.popup:Show(true)
      equip_slot_reinforce_window.popup:Raise()
    end
  end
  ButtonOnClickHandler(detailBtn, DetailBtnLeftClickFunc)
end
local function CreateReinforceSlot(i, parent, excludeReinforceSlotList)
  for index = 1, #excludeReinforceSlotList do
    if i == excludeReinforceSlotList[index] then
      return
    end
  end
  local reinforceParent = CreateEmptyWindow("slot." .. i, parent)
  reinforceParent:SetExtent(96, 45)
  reinforceParent:Show(true)
  equip_slot_reinforce_window.slot[i] = reinforceParent
  equip_slot_reinforce_window.slot[i].index = i
  local reinforceInfoBg = reinforceParent:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  local coordisKey, colorKey
  local attributeType = X2EquipSlotReinforce:GetAttributeType(i)
  if attributeType == ESRA_OFFENCE then
    coordisKey = EQUIP_SLOT_REINFORCE_IMG_INFO.SLOT_BG_OFFENCE.coordsKey
    colorKey = EQUIP_SLOT_REINFORCE_IMG_INFO.SLOT_BG_OFFENCE.colorKey
  elseif attributeType == ESRA_DEFENCE then
    coordisKey = EQUIP_SLOT_REINFORCE_IMG_INFO.SLOT_BG_DEFENCE.coordsKey
    colorKey = EQUIP_SLOT_REINFORCE_IMG_INFO.SLOT_BG_DEFENCE.colorKey
  else
    coordisKey = EQUIP_SLOT_REINFORCE_IMG_INFO.SLOT_BG_SUPPORT.coordsKey
    colorKey = EQUIP_SLOT_REINFORCE_IMG_INFO.SLOT_BG_SUPPORT.colorKey
  end
  reinforceInfoBg:SetTextureInfo(coordisKey, colorKey)
  equip_slot_reinforce_window.slot[i].view = reinforceInfoBg
  local button = CreateItemIconButton("slotBtn." .. i, parent, "constant")
  button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  button:RegisterForClicks("LeftButton")
  button:EnableDrag(false)
  F_SLOT.ApplySlotSkin(button, button.back, SLOT_STYLE.EQUIP_ITEM[i])
  equip_slot_reinforce_window.slot[i].btn = button
  local function ReinforceBtnLeftClickFunc()
    ShowReinforceWindow(i)
  end
  ButtonOnClickHandler(button, ReinforceBtnLeftClickFunc)
  local levelEffectStepIcon2 = button:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  levelEffectStepIcon2:SetTextureInfo("icon_special_bg_small")
  levelEffectStepIcon2:AddAnchor("CENTER", button, "CENTER", -1, 15)
  local levelEffectStepIcon1 = button:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  levelEffectStepIcon1:SetTextureInfo("icon_special_small")
  levelEffectStepIcon1:AddAnchor("TOPRIGHT", levelEffectStepIcon2, "TOPLEFT", -3, 0)
  local levelEffectStepIcon3 = button:CreateImageDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  levelEffectStepIcon3:SetTextureInfo("icon_special_bg_small")
  levelEffectStepIcon3:AddAnchor("TOPLEFT", levelEffectStepIcon2, "TOPRIGHT", 3, 0)
  equip_slot_reinforce_window.slot[i].levelEffectStepIcon = {}
  equip_slot_reinforce_window.slot[i].levelEffectStepIcon[1] = levelEffectStepIcon1
  equip_slot_reinforce_window.slot[i].levelEffectStepIcon[2] = levelEffectStepIcon2
  equip_slot_reinforce_window.slot[i].levelEffectStepIcon[3] = levelEffectStepIcon3
  local reinforceExp = W_BAR.CreateStatusBar("reinforceExp", reinforceParent, "equip_slot_reinforce")
  reinforceExp:SetWidth(46)
  reinforceExp:SetMinMaxValues(0, 150)
  reinforceExp:SetValue(100)
  reinforceExp:SetBarColor({
    ConvertColor(253),
    ConvertColor(228),
    ConvertColor(103),
    1
  })
  equip_slot_reinforce_window.slot[i].bonusExpGuage = reinforceExp
  local levelIcon = reinforceParent:CreateNinePartDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
  levelIcon:SetTextureInfo("icon_equip_slot_star")
  local levelLabel = reinforceParent:CreateChildWidget("textbox", "levelLabel", 0, false)
  levelLabel:SetExtent(30, FONT_SIZE.MIDDLE)
  levelLabel:SetAutoResize(true)
  levelLabel:SetHeight(15)
  levelLabel.style:SetFontSize(FONT_SIZE.LARGE)
  levelLabel:SetText(string.format("|V%d;", i))
  ApplyTextColor(levelLabel, FONT_COLOR.MEDIUM_YELLOW)
  equip_slot_reinforce_window.slot[i].levelLabel = levelLabel
  levelLabel.style:SetAlign(ALIGN_LEFT)
  if IsLeftSide(i) then
    button:AddAnchor("TOPRIGHT", reinforceParent, 0, 0)
    reinforceInfoBg:AddAnchor("TOPRIGHT", button, 2, -2)
    levelIcon:AddAnchor("TOPLEFT", reinforceInfoBg, "TOPLEFT", 11, 19)
    levelLabel:AddAnchor("LEFT", levelIcon, "RIGHT", 2, 0)
    reinforceExp:AddAnchor("TOPRIGHT", reinforceInfoBg, -45, 38)
  else
    button:AddAnchor("TOPLEFT", reinforceParent, 0, 0)
    reinforceInfoBg:AddAnchor("TOPLEFT", button, -2, -2)
    levelIcon:AddAnchor("TOPLEFT", reinforceInfoBg, "TOPLEFT", 45, 19)
    levelLabel:AddAnchor("LEFT", levelIcon, "RIGHT", 2, 0)
    reinforceExp:AddAnchor("TOPLEFT", reinforceInfoBg, 45, 38)
  end
  SetTooltipReinforceInfo(equip_slot_reinforce_window.slot[i].btn, i)
end
function SetTooltipReinforceInfo(target, equipSlot)
  local function CreateGuideToolip()
    local tooltip = CreateEmptyWindow("tooltipReinforceSlot", equip_slot_reinforce_window)
    tooltip:SetExtent(230, 145)
    tooltip:SetUILayer("tooltip")
    CreateTooltipDrawable(tooltip)
    tooltip:Show(true)
    local equipSlotLabel = tooltip:CreateChildWidget("label", "equipSlotLabel" .. equipSlot, 0, true)
    equipSlotLabel:SetExtent(tooltip:GetWidth(), 20)
    equipSlotLabel.style:SetFontSize(FONT_SIZE.LARGE)
    equipSlotLabel.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(equipSlotLabel, FONT_COLOR.DEFAULT)
    equipSlotLabel:SetText(GetSlotText(equipSlot))
    equipSlotLabel:AddAnchor("TOPLEFT", tooltip, "TOPLEFT", 15, 5)
    local attributeLabel = tooltip:CreateChildWidget("label", "equipSlotAttributeLabel" .. equipSlot, 0, true)
    attributeLabel:SetExtent(tooltip:GetWidth() / 2, 20)
    attributeLabel.style:SetFontSize(FONT_SIZE.LARGE)
    attributeLabel.style:SetAlign(ALIGN_RIGHT)
    attributeLabel:AddAnchor("TOPRIGHT", tooltip, "TOPRIGHT", -15, 5)
    local attributeType = X2EquipSlotReinforce:GetAttributeType(equipSlot)
    local attributeStr = GetAttibuteText(attributeType)
    attributeLabel:SetText(attributeStr)
    ApplyTextColor(attributeLabel, GetAttibuteTextColor(attributeType))
    local reinforceLevel = tooltip:CreateChildWidget("textbox", "reinforceLevel" .. equipSlot, 0, false)
    reinforceLevel:SetExtent(tooltip:GetWidth() / 2, 20)
    reinforceLevel.style:SetAlign(ALIGN_RIGHT)
    reinforceLevel.style:SetFontSize(FONT_SIZE.MIDDLE)
    reinforceLevel:AddAnchor("TOPRIGHT", attributeLabel, "BOTTOMRIGHT", 0, 2)
    local reinforceInfo = GetReinforceInfo(equipSlot)
    local level = reinforceInfo.level
    local exp = reinforceInfo.exp
    local totalExp = reinforceInfo.totalExp
    if totalExp < 1 then
      totalExp = 1
    end
    reinforceLevel:SetText(string.format("|v%d;", level))
    local line = CreateLine(tooltip, "TYPE1")
    line:AddAnchor("TOPLEFT", equipSlotLabel, "BOTTOMLEFT", -15, 25)
    line:AddAnchor("TOPRIGHT", equipSlotLabel, "BOTTOMRIGHT", -15, 25)
    local reinforceExpLabel = tooltip:CreateChildWidget("label", "reinforceExpLabel" .. equipSlot, 0, false)
    reinforceExpLabel:SetExtent(tooltip:GetWidth(), 20)
    reinforceExpLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    reinforceExpLabel.style:SetAlign(ALIGN_LEFT)
    reinforceExpLabel:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 15, 5)
    reinforceExpLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_exp", tostring(exp), tostring(totalExp), string.format("%.2f", exp / totalExp * 100)))
    local line2 = CreateLine(tooltip, "TYPE1")
    line2:AddAnchor("TOPLEFT", reinforceExpLabel, "BOTTOMLEFT", -15, 5)
    line2:AddAnchor("TOPRIGHT", reinforceExpLabel, "BOTTOMRIGHT", -15, 5)
    local reinforceCurEffectLabel = tooltip:CreateChildWidget("label", "reinforceCurEffectLabel" .. equipSlot, 0, false)
    reinforceCurEffectLabel:SetExtent(tooltip:GetWidth() / 2, 20)
    reinforceCurEffectLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    reinforceCurEffectLabel.style:SetAlign(ALIGN_LEFT)
    reinforceCurEffectLabel:AddAnchor("TOPLEFT", line2, "BOTTOMLEFT", 15, 5)
    reinforceCurEffectLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_cur_effect_label"))
    local reinforceInfo = GetReinforceInfo(equipSlot)
    local reinforceCurEffectValueLabel = tooltip:CreateChildWidget("textbox", "reinforceCurEffectValueLabel" .. equipSlot, 0, false)
    reinforceCurEffectValueLabel:SetExtent(tooltip:GetWidth() / 2, 20)
    reinforceCurEffectValueLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    reinforceCurEffectValueLabel.style:SetAlign(ALIGN_LEFT)
    reinforceCurEffectValueLabel:AddAnchor("TOPLEFT", reinforceCurEffectLabel, "BOTTOMLEFT", 5, 0)
    reinforceCurEffectValueLabel:SetText(string.format("|c%s%s |c%s%s", Dec2Hex(FONT_COLOR.GREEN), GetUIText(COMMON_TEXT, "equip_slot_reinforce_effect_label"), Dec2Hex(FONT_COLOR.MEDIUM_YELLOW), tostring(reinforceInfo.level)))
    local nextLevelstr = tostring(reinforceInfo.level + 1)
    if EnableLevelUp(equipSlot) == true then
      tooltip:SetExtent(230, 190)
      local reinforceNextEffectLabel = tooltip:CreateChildWidget("label", "reinforceNextEffectLabel" .. equipSlot, 0, false)
      reinforceNextEffectLabel:SetExtent(tooltip:GetWidth(), 20)
      reinforceNextEffectLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
      reinforceNextEffectLabel.style:SetAlign(ALIGN_LEFT)
      reinforceNextEffectLabel:AddAnchor("TOPLEFT", reinforceCurEffectValueLabel, "BOTTOMLEFT", -5, 5)
      reinforceNextEffectLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_next_effect_label"))
      local reinforceNextEffectValueLabel = tooltip:CreateChildWidget("textbox", "reinforceNextEffectValueLabel" .. equipSlot, 0, false)
      reinforceNextEffectValueLabel:SetExtent(tooltip:GetWidth(), 20)
      reinforceNextEffectValueLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
      reinforceNextEffectValueLabel.style:SetAlign(ALIGN_LEFT)
      reinforceNextEffectValueLabel:AddAnchor("TOPLEFT", reinforceNextEffectLabel, "BOTTOMLEFT", 5, 0)
      reinforceNextEffectValueLabel:SetText(string.format("|c%s%s |c%s%s", Dec2Hex(FONT_COLOR.GREEN), GetUIText(COMMON_TEXT, "equip_slot_reinforce_effect_label"), Dec2Hex(FONT_COLOR.MEDIUM_YELLOW), nextLevelstr))
    end
    local function OnHide()
      target.tooltip = nil
    end
    tooltip:SetHandler("OnHide", OnHide)
    return tooltip
  end
  local function OnEnter(self)
    if target.tooltip == nil then
      target.tooltip = CreateGuideToolip(self)
    end
    SetDefaultTooltipAnchor(target, target.tooltip)
  end
  target:SetHandler("OnEnter", OnEnter)
  local function OnLeave()
    target.tooltip:Show(false)
  end
  target:SetHandler("OnLeave", OnLeave)
end
local function CreateReinforceSetEffectWindow(parent, attributeType)
  equip_slot_reinforce_window.setEffect[attributeType] = {}
  local window = CreateEmptyWindow("setEffect." .. attributeType, parent)
  window:Show(true)
  equip_slot_reinforce_window.setEffect[attributeType].window = window
  local setEffectBg = window:CreateNinePartDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  setEffectBg:SetTextureInfo("set_bg_1", "default")
  equip_slot_reinforce_window.setEffect[attributeType].bgImg = setEffectBg
  window:SetExtent(setEffectBg:GetWidth(), setEffectBg:GetHeight())
  setEffectBg:AddAnchor("TOPLEFT", window, 0, 0)
  local setEffectIcon = window:CreateNinePartDrawable(EQUIP_SLOT_REINFORCE_TEXTURE_PATH, "background")
  local iconCoordiKey = "set_shield_1"
  setEffectIcon:SetTextureInfo(iconCoordiKey)
  setEffectIcon:AddAnchor("TOPLEFT", window, 0, 0)
  window:SetExtent(setEffectIcon:GetWidth(), setEffectIcon:GetHeight())
  equip_slot_reinforce_window.setEffect[attributeType].icon = setEffectIcon
  local setEffectLabel = window:CreateChildWidget("textbox", "setEffectLabel." .. attributeType, 0, false)
  setEffectLabel:SetExtent(window:GetWidth(), FONT_SIZE.SMALL)
  setEffectLabel:SetAutoResize(true)
  setEffectLabel:SetHeight(15)
  setEffectLabel.style:SetFontSize(FONT_SIZE.SMALL)
  ApplyTextColor(setEffectLabel, F_COLOR.GetColor("light_gray", false))
  setEffectLabel:AddAnchor("TOPLEFT", window, 0, 61)
  equip_slot_reinforce_window.setEffect[attributeType].label = setEffectLabel
  SetTooltipSetEffectInfo(equip_slot_reinforce_window.setEffect[attributeType].window, attributeType)
end
function SetTooltipSetEffectInfo(target, attributeType)
  local function CreateGuideToolip()
    local tooltip = CreateEmptyWindow("tooltipSetEffect", equip_slot_reinforce_window)
    tooltip:Show(true)
    tooltip:SetExtent(260, 276)
    tooltip:SetUILayer("tooltip")
    CreateTooltipDrawable(tooltip)
    local offsetHeight = 4
    local sectionWidth = tooltip:GetWidth() - 30
    local dafaultInfoSection = tooltip:CreateChildWidget("emptywidget", "dafaultInfoSection", 0, true)
    dafaultInfoSection:SetExtent(sectionWidth, 50)
    dafaultInfoSection:AddAnchor("TOPLEFT", tooltip, "TOPLEFT", 15, 15)
    local defaultInfotitle = dafaultInfoSection:CreateChildWidget("label", "title", 0, true)
    defaultInfotitle:SetHeight(FONT_SIZE.MIDDLE)
    defaultInfotitle:SetWidth(sectionWidth)
    defaultInfotitle:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_default_info_title"))
    defaultInfotitle.style:SetAlign(ALIGN_LEFT)
    defaultInfotitle:AddAnchor("TOPLEFT", dafaultInfoSection, 0, 0)
    ApplyTextColor(defaultInfotitle, FONT_COLOR.SOFT_YELLOW)
    local labelAttribute = dafaultInfoSection:CreateChildWidget("label", "title", 0, true)
    labelAttribute:SetAutoResize(true)
    labelAttribute:SetHeight(FONT_SIZE.MIDDLE)
    labelAttribute:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_default_info_attribute"))
    labelAttribute.style:SetAlign(ALIGN_LEFT)
    labelAttribute:AddAnchor("TOPLEFT", defaultInfotitle, "BOTTOMLEFT", 5, offsetHeight)
    ApplyTextColor(labelAttribute, FONT_COLOR.SOFT_BROWN)
    local labelAttributeStr = dafaultInfoSection:CreateChildWidget("label", "title", 0, true)
    labelAttribute:SetAutoResize(true)
    labelAttributeStr:SetHeight(FONT_SIZE.MIDDLE)
    labelAttributeStr:SetText(GetAttibuteText(attributeType))
    labelAttributeStr.style:SetAlign(ALIGN_RIGHT)
    labelAttributeStr:AddAnchor("TOPRIGHT", defaultInfotitle, "BOTTOMRIGHT", 0, offsetHeight)
    ApplyTextColor(labelAttributeStr, GetAttibuteTextColor(attributeType))
    local labelLevel = dafaultInfoSection:CreateChildWidget("label", "title", 0, true)
    labelAttribute:SetAutoResize(true)
    labelLevel:SetHeight(FONT_SIZE.MIDDLE)
    labelLevel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_default_info_level"))
    labelLevel.style:SetAlign(ALIGN_LEFT)
    labelLevel:AddAnchor("TOPLEFT", labelAttribute, "BOTTOMLEFT", 0, offsetHeight)
    ApplyTextColor(labelLevel, FONT_COLOR.SOFT_BROWN)
    local setLevel = GetSetEffectTopLevel(attributeType)
    local setLevelStr = GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_default_info_nothing")
    if setLevel > 0 then
      setLevelStr = tostring(setLevel)
    end
    local labelLevelStr = dafaultInfoSection:CreateChildWidget("label", "title", 0, true)
    labelAttribute:SetAutoResize(true)
    labelLevelStr:SetHeight(FONT_SIZE.MIDDLE)
    labelLevelStr:SetText(setLevelStr)
    labelLevelStr.style:SetAlign(ALIGN_RIGHT)
    labelLevelStr:AddAnchor("TOPRIGHT", labelAttributeStr, "BOTTOMRIGHT", 0, offsetHeight)
    ApplyTextColor(labelAttribute, FONT_COLOR.SOFT_BROWN)
    local line = CreateLine(tooltip, "TYPE1")
    line:AddAnchor("TOPLEFT", dafaultInfoSection, "BOTTOMLEFT", -15, 5)
    line:AddAnchor("TOPRIGHT", dafaultInfoSection, "BOTTOMRIGHT", -15, 5)
    local levelInfoSection = tooltip:CreateChildWidget("emptywidget", "levelInfoSection", 0, true)
    levelInfoSection:SetExtent(sectionWidth, 60)
    levelInfoSection:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 15, offsetHeight)
    local levelInfotitle = levelInfoSection:CreateChildWidget("label", "title", 0, true)
    levelInfotitle:SetHeight(FONT_SIZE.MIDDLE)
    levelInfotitle:SetWidth(sectionWidth)
    levelInfotitle:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_level_info_title"))
    levelInfotitle.style:SetAlign(ALIGN_LEFT)
    levelInfotitle:AddAnchor("TOPLEFT", levelInfoSection, 0, 0)
    ApplyTextColor(levelInfotitle, FONT_COLOR.SOFT_YELLOW)
    local labelCurrentLevel = levelInfoSection:CreateChildWidget("label", "title", 0, true)
    labelCurrentLevel:SetAutoResize(true)
    labelCurrentLevel:SetHeight(FONT_SIZE.MIDDLE)
    labelCurrentLevel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_level_info_current"))
    labelCurrentLevel.style:SetAlign(ALIGN_LEFT)
    labelCurrentLevel:AddAnchor("TOPLEFT", levelInfotitle, "BOTTOMLEFT", 5, offsetHeight)
    ApplyTextColor(labelCurrentLevel, FONT_COLOR.SOFT_BROWN)
    local icon = levelInfoSection:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
    icon:SetTextureInfo("icon_equip_slot_star_small")
    icon:AddAnchor("TOPLEFT", labelCurrentLevel, "TOPRIGHT", 2, 0)
    local labelCurrentLevelStr = levelInfoSection:CreateChildWidget("textbox", "title", 0, true)
    labelCurrentLevelStr:SetHeight(FONT_SIZE.MIDDLE)
    labelCurrentLevelStr:SetWidth(40)
    labelCurrentLevelStr:SetText(string.format("|v%d;", GetAttributeTotalLevel(attributeType)))
    labelCurrentLevelStr.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCurrentLevelStr.style:SetAlign(ALIGN_RIGHT)
    labelCurrentLevelStr:AddAnchor("TOPRIGHT", levelInfotitle, "BOTTOMRIGHT", 0, offsetHeight)
    ApplyTextColor(labelAttribute, FONT_COLOR.SOFT_BROWN)
    local labelNextLevel
    if HasNextSetEffect(attributeType) then
      labelNextLevel = levelInfoSection:CreateChildWidget("label", "title", 0, true)
      labelNextLevel:SetAutoResize(true)
      labelNextLevel:SetHeight(FONT_SIZE.MIDDLE)
      labelNextLevel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_level_info_next_level"))
      labelNextLevel.style:SetAlign(ALIGN_LEFT)
      labelNextLevel:AddAnchor("TOPLEFT", labelCurrentLevel, "BOTTOMLEFT", 0, offsetHeight)
      ApplyTextColor(labelNextLevel, FONT_COLOR.SOFT_BROWN)
      local icon2 = levelInfoSection:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
      icon2:SetTextureInfo("icon_equip_slot_star_small")
      icon2:AddAnchor("TOPLEFT", labelNextLevel, "TOPRIGHT", 2, 0)
      local labelNextLevelStr = levelInfoSection:CreateChildWidget("textbox", "title", 0, true)
      labelNextLevelStr:SetWidth(40)
      labelNextLevelStr:SetHeight(FONT_SIZE.MIDDLE)
      labelNextLevelStr:SetText(string.format("|v%d;", GetNextSetApplyLevel(attributeType)))
      labelNextLevelStr.style:SetFontSize(FONT_SIZE.MIDDLE)
      labelNextLevelStr.style:SetAlign(ALIGN_RIGHT)
      labelNextLevelStr:AddAnchor("TOPRIGHT", labelCurrentLevelStr, "BOTTOMRIGHT", 0, offsetHeight)
      ApplyTextColor(labelNextLevelStr, FONT_COLOR.SOFT_BROWN)
    else
      labelNextLevel = levelInfoSection:CreateChildWidget("label", "title", 0, true)
      labelNextLevel:SetAutoResize(true)
      labelNextLevel:SetHeight(FONT_SIZE.MIDDLE)
      labelNextLevel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_max_level"))
      labelNextLevel.style:SetAlign(ALIGN_LEFT)
      labelNextLevel:AddAnchor("TOPLEFT", labelCurrentLevel, "BOTTOMLEFT", 0, offsetHeight)
      ApplyTextColor(labelNextLevel, FONT_COLOR.SOFT_BROWN)
    end
    local labelLevelDesc = levelInfoSection:CreateChildWidget("textbox", "title", 0, true)
    labelLevelDesc:SetWidth(sectionWidth)
    labelLevelDesc:SetHeight(FONT_SIZE.MIDDLE)
    labelLevelDesc.style:SetFontSize(FONT_SIZE.SMALL)
    labelLevelDesc:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_level_info_desc"))
    labelLevelDesc.style:SetAlign(ALIGN_LEFT)
    labelLevelDesc:AddAnchor("TOPLEFT", labelNextLevel, "BOTTOMLEFT", -5, offsetHeight)
    ApplyTextColor(labelLevelDesc, FONT_COLOR.MEDIUM_YELLOW)
    local line2 = CreateLine(tooltip, "TYPE1")
    line2:AddAnchor("TOPLEFT", levelInfoSection, "BOTTOMLEFT", -15, 5)
    line2:AddAnchor("TOPRIGHT", levelInfoSection, "BOTTOMRIGHT", -15, 5)
    local setEffectsSection = tooltip:CreateChildWidget("emptywidget", "setEffectsSection", 0, true)
    setEffectsSection:SetExtent(sectionWidth, 140)
    setEffectsSection:AddAnchor("TOPLEFT", line2, "BOTTOMLEFT", 15, offsetHeight)
    local setEffects = GetSetEffects(attributeType)
    if setEffects ~= nil then
      local setEffectsTitle = setEffectsSection:CreateChildWidget("label", "title", 0, true)
      setEffectsTitle:SetHeight(FONT_SIZE.MIDDLE)
      setEffectsTitle:SetWidth(sectionWidth)
      setEffectsTitle:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_set_title"))
      setEffectsTitle.style:SetAlign(ALIGN_LEFT)
      setEffectsTitle:AddAnchor("TOPLEFT", setEffectsSection, 0, offsetHeight)
      ApplyTextColor(setEffectsTitle, FONT_COLOR.SOFT_YELLOW)
      local anchorHeight = offsetHeight
      for i = 0, #setEffects - 1 do
        local info = setEffects[i + 1]
        local setEffectLevelLabel = setEffectsSection:CreateChildWidget("textbox", "setEffectLevel" .. i, 0, true)
        setEffectLevelLabel:SetWidth(sectionWidth)
        setEffectLevelLabel:SetHeight(FONT_SIZE.MIDDLE)
        setEffectLevelLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
        setEffectLevelLabel.style:SetAlign(ALIGN_LEFT)
        setEffectLevelLabel:AddAnchor("TOPLEFT", setEffectsTitle, "BOTTOMLEFT", 5, anchorHeight)
        ApplyTextColor(setEffectLevelLabel, FONT_COLOR.SOFT_BROWN)
        setEffectLevelLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_set_desc", tostring(info.step), tostring(info.requiredLevel)))
        local setEffectDescLabel = setEffectsSection:CreateChildWidget("textbox", "setEffectDesc" .. i, 0, true)
        setEffectDescLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
        setEffectDescLabel:SetExtent(sectionWidth, FONT_SIZE.MIDDLE)
        local len = setEffectDescLabel.style:GetTextWidth(info.desc)
        local offset = math.floor(len / sectionWidth)
        tooltip:SetExtent(tooltip:GetWidth(), tooltip:GetHeight() + FONT_SIZE.MIDDLE * offset)
        setEffectDescLabel:SetAutoResize(true)
        setEffectDescLabel.style:SetAlign(ALIGN_LEFT)
        setEffectDescLabel:AddAnchor("TOPLEFT", setEffectLevelLabel, "BOTTOMLEFT", 0, 0)
        if info.enable == true then
          ApplyTextColor(setEffectDescLabel, FONT_COLOR.GREEN)
        else
          ApplyTextColor(setEffectDescLabel, FONT_COLOR.DEFAULT_GRAY)
        end
        setEffectDescLabel:SetText(info.desc)
        anchorHeight = anchorHeight + setEffectLevelLabel:GetHeight() + setEffectDescLabel:GetHeight() + offsetHeight
      end
    end
    local function OnHide()
      target.tooltip = nil
    end
    tooltip:SetHandler("OnHide", OnHide)
    return tooltip
  end
  local function OnEnter(self)
    if target.tooltip == nil then
      target.tooltip = CreateGuideToolip()
    end
    SetDefaultTooltipAnchor(target, target.tooltip)
  end
  target:SetHandler("OnEnter", OnEnter)
  local function OnLeave()
    target.tooltip:Show(false)
  end
  target:SetHandler("OnLeave", OnLeave)
end
function ShowReinforceMode()
  if X2Player:GetFeatureSet().equipSlotEnchantment ~= nil and X2Player:GetFeatureSet().equipSlotEnchantment == false then
    return
  end
  InitEquipSlotReinforceSetEffect()
  if SuitableLevelForEquipSlotReinforce() == true then
    equippedItem.equipSlotReinforceBtn.equip:Show(false)
    equippedItem.equipSlotReinforceBtn.reinforce:Show(true)
    equippedItem.equipSlotReinforceBtn.detailBtn:Show(false)
  else
    equippedItem.equipSlotReinforceBtn.equip:Show(false)
    equippedItem.equipSlotReinforceBtn.reinforce:Show(false)
    equippedItem.equipSlotReinforceBtn.detailBtn:Show(false)
  end
  equip_slot_reinforce_window:Show(true)
  equip_slot_reinforce_window.window:Show(false)
  equip_slot_reinforce_window.popup:Show(false)
  equippedItem.optionButton:Show(false)
  equippedItem.leftSlots:Show(false)
  equippedItem.rightSlots:Show(false)
  equip_slot_reinforce_window.levelEffectChangeWindow:Show(false)
  equip_slot_reinforce_window.levelEffectInfoWindow:Show(false)
  for i = ESRA_OFFENCE, ESRA_MAX - 1 do
    equip_slot_reinforce_window.setEffect[i].window:Show(true)
  end
end
function ShowEquipmentMode()
  if X2Player:GetFeatureSet().equipSlotEnchantment ~= nil and X2Player:GetFeatureSet().equipSlotEnchantment == false then
    return
  end
  if SuitableLevelForEquipSlotReinforce() == true then
    equippedItem.equipSlotReinforceBtn.equip:Show(true)
    equippedItem.equipSlotReinforceBtn.reinforce:Show(false)
    equippedItem.equipSlotReinforceBtn.detailBtn:Show(true)
  else
    equippedItem.equipSlotReinforceBtn.equip:Show(false)
    equippedItem.equipSlotReinforceBtn.reinforce:Show(false)
    equippedItem.equipSlotReinforceBtn.detailBtn:Show(false)
  end
  equip_slot_reinforce_window:Show(false)
  equip_slot_reinforce_window.window:Show(false)
  equip_slot_reinforce_window.popup:Show(false)
  equippedItem.optionButton:Show(true)
  equippedItem.leftSlots:Show(true)
  equippedItem.rightSlots:Show(true)
  equip_slot_reinforce_window.levelEffectChangeWindow:Show(false)
  equip_slot_reinforce_window.levelEffectInfoWindow:Show(false)
  for i = ESRA_OFFENCE, ESRA_MAX - 1 do
    equip_slot_reinforce_window.setEffect[i].window:Show(false)
  end
end
local UpdateSetEffectIconInfo = function(attributeType, index, visible)
  local coordiKey = ""
  if attributeType == ESRA_DEFENCE then
    coordiKey = "shield"
  elseif attributeType == ESRA_OFFENCE then
    coordiKey = "attack"
  else
    coordiKey = "support"
  end
  local topLevel = GetSetEffectTopLevel(attributeType)
  local convertedLevel = topLevel
  if convertedLevel <= 0 then
    convertedLevel = 1
  end
  equip_slot_reinforce_window.setEffect[attributeType].bgImg:SetTextureInfo("set_bg_" .. convertedLevel, "default")
  equip_slot_reinforce_window.setEffect[attributeType].icon:SetTextureInfo("set_" .. coordiKey .. "_" .. convertedLevel)
  local levelStr = GetUIText(COMMON_TEXT, "equip_slot_reinforce_set_effect_level")
  if topLevel >= 1 then
    levelStr = levelStr .. " " .. tostring(topLevel)
  end
  equip_slot_reinforce_window.setEffect[attributeType].label:SetText(levelStr)
end
function UpdateLevelEffectChangeWindow(equipSlot)
  local info = GetLevelEffectChangeUIInfo(equipSlot)
  local radioData = {}
  local secondTextData = {}
  local disableIndicies = {}
  local radioGroup = equip_slot_reinforce_window.levelEffectRadioGroup
  for i = 1, MAX_LEVEL_EFFECT_COUNT do
    local secondLabel = radioGroup.secondLabels[i]
    if secondLabel ~= nil then
      secondLabel:RemoveAllAnchors()
      secondLabel:SetText("")
    end
  end
  if info.levelEffectList ~= nil then
    for i = 1, #info.levelEffectList do
      local data1 = {}
      local data2 = {}
      local levelEffect = info.levelEffectList[i]
      if levelEffect ~= nil then
        if levelEffect.attributeType ~= nil then
          local attributeStr = locale.attribute(levelEffect.attributeType)
          local valueStr = GetModifierCalcValue(levelEffect.attributeType, levelEffect.value)
          data1.text = attributeStr
          data2.text = valueStr
        else
          local triggerLevel = levelEffect.triggerLevel
          local notReadyStr = GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_not_ready", tostring(triggerLevel))
          data1.text = notReadyStr
          data1.fontColor = FONT_COLOR.DEFAULT_GRAY
          data2.text = ""
          table.insert(disableIndicies, i)
        end
      end
      table.insert(radioData, data1)
      table.insert(secondTextData, data2)
    end
  end
  if #radioData > 0 then
    radioGroup:SetData(radioData)
    for i = 1, #radioData do
      local radio = radioGroup.items[i]
      local secondLabel = radioGroup.secondLabels[i]
      local secondLabelStr = secondTextData[i]
      if radio ~= nil and secondLabel ~= nil and secondLabelStr ~= nil and secondLabelStr ~= "" then
        secondLabel:AddAnchor("TOPLEFT", radio, "TOPLEFT", radioGroup:GetWidth() + 4, 0)
        secondLabel:SetText(secondLabelStr.text)
      end
      local disableIndex = disableIndicies[i]
      if disableIndex ~= nil then
        radioGroup:EnableIndex(disableIndex, false)
      end
    end
  else
    radioGroup:Clear()
  end
  local curCnt = X2Bag:GetCountInBag(info.item.itemType)
  equip_slot_reinforce_window.levelEffectChangeMaterialItem:SetItemInfo(info.item)
  equip_slot_reinforce_window.levelEffectChangeMaterialItem:SetStack(curCnt, 1)
  equip_slot_reinforce_window.levelEffectUnitModifierLabel:SetText("")
  if selected_equip_slot ~= equipSlot then
    radioGroup:Check(1)
  else
    radioGroup:Check(selected_level_effect_index)
  end
  if curCnt > 0 then
    equip_slot_reinforce_window.levelEffectChangeWindow.leftButton:Enable(true)
  else
    equip_slot_reinforce_window.levelEffectChangeWindow.leftButton:Enable(false)
  end
  local itemNameStr = string.format("%s[%s]|r", F_COLOR.GetColor("bright_blue", true), info.item.name)
  equip_slot_reinforce_window.levelEffectCashItemHelpLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_change_cash_item_help_msg", itemNameStr))
  equip_slot_reinforce_window.levelEffectItemHelpLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_level_effect_change_item_help_msg", itemNameStr))
end
function UpdateLevelEffectDetailWindow(equipSlot)
  local info = GetLevelEffectInfoByEquipSlot(equipSlot)
  equip_slot_reinforce_window.levelEffectInfoList:DeleteAllDatas()
  for i = 1, #info do
    equip_slot_reinforce_window.levelEffectInfoList:InsertData(i, 1, info[i])
    equip_slot_reinforce_window.levelEffectInfoList:InsertData(i, 2, info[i])
  end
  local itemInfo = X2Item:GetItemInfoByType(info.changeItemType)
  if itemInfo ~= nil then
    local itemNameStr = string.format("%s[%s]|r", F_COLOR.GetColor("bright_blue", true), itemInfo.name)
    equip_slot_reinforce_window.levelEffectInfoHelpLabel:SetText(GetUIText(COMMON_TEXT, "equip_slot_reinforce_window_level_effect_info_help_msg", itemNameStr))
  end
end
function ShowLevelEffectDetailWindow()
  if equip_slot_reinforce_window.levelEffectInfoWindow:IsVisible() == false then
    UpdateLevelEffectDetailWindow(selected_equip_slot)
    equip_slot_reinforce_window.levelEffectInfoWindow:Show(true)
    equip_slot_reinforce_window.levelEffectInfoWindow:Raise()
  end
end
function ShowLevelEffectChangeWindow()
  if equip_slot_reinforce_window.levelEffectChangeWindow:IsVisible() == false then
    UpdateLevelEffectChangeWindow(selected_equip_slot)
    equip_slot_reinforce_window.levelEffectChangeWindow:Show(true)
    equip_slot_reinforce_window.levelEffectChangeWindow:Raise()
  end
end
function InitEquipSlotReinforceSetEffect()
  for i = ESRA_OFFENCE, ESRA_MAX - 1 do
    UpdateSetEffectIconInfo(i)
  end
end
local InitEquipSlotReinforce = function()
  ShowEquipmentMode()
  for k, v in pairs(equip_slot_reinforce_window.slot) do
    local index = v.index
    UpdateEquipSlotReinforceSlot(index)
  end
end
function UpdateEquipSlotReinforceSlot(equipSlot)
  local info = GetReinforceInfo(equipSlot)
  local level = info.level
  local exp = info.exp
  local totalExp = info.totalExp
  equip_slot_reinforce_window.slot[equipSlot].levelLabel:SetText(string.format(level))
  equip_slot_reinforce_window.slot[equipSlot].bonusExpGuage:SetMinMaxValues(0, totalExp)
  equip_slot_reinforce_window.slot[equipSlot].bonusExpGuage:SetValue(exp)
  local maxStep = GetLevelEffectStep(equipSlot)
  for i = 1, MAX_LEVEL_EFFECT_COUNT do
    local textureKey
    if i > maxStep then
      textureKey = "icon_special_bg_small"
    else
      textureKey = "icon_special_small"
    end
    equip_slot_reinforce_window.slot[equipSlot].levelEffectStepIcon[i]:SetTextureInfo(textureKey)
  end
end
function UpdateEquipSlotReinforceWindow(equipSlot)
  if equip_slot_reinforce_window.window:IsVisible() == false then
    return
  end
  if selected_equip_slot == equipSlot then
    ShowReinforceWindow(equipSlot)
  end
end
function ShowReinforceWindow(equipSlot)
  if equip_slot_reinforce_window.window:IsVisible() == false then
    equip_slot_reinforce_window.window:Show(true)
    equip_slot_reinforce_window.window:Raise()
  end
  local reinforceInfo = GetReinforceInfo(equipSlot)
  local level = reinforceInfo.level
  local exp = reinforceInfo.exp
  local totalExp = reinforceInfo.totalExp
  local attributeType = X2EquipSlotReinforce:GetAttributeType(equipSlot)
  if selected_equip_slot ~= equipSlot then
    selected_material_index = 0
  end
  InitReinforceSlotInfo(equipSlot, level, exp, totalExp, attributeType)
  InitReinforceEffectInfo(equipSlot, level)
  InitReinforceMaterialInfo(equipSlot, level)
  InitReinforceLevelEffectInfo(equipSlot)
  if equip_slot_reinforce_window.levelEffectInfoWindow:IsVisible() == true then
    UpdateLevelEffectDetailWindow(equipSlot)
  end
  if equip_slot_reinforce_window.levelEffectChangeWindow:IsVisible() == true then
    UpdateLevelEffectChangeWindow(equipSlot)
  end
  selected_equip_slot = equipSlot
end
function ShowMsgChangeLevelEffect(levelEffectInfo)
  local function DialogHandler(wnd)
    ApplyDialogStyle(wnd, "TYPE1")
    F_SLOT.ApplySlotSkin(wnd.itemIcon, wnd.itemIcon.back, SLOT_STYLE.EQUIP_ITEM[levelEffectInfo.equipSlot])
    equipSlotStr = GetSlotText(levelEffectInfo.equipSlot)
    local preEffectStr = ""
    local curEffectStr = ""
    local preLevelEffectInfo = levelEffectInfo.preEffectInfo
    if preLevelEffectInfo ~= nil then
      local valueStr = GetModifierCalcValue(preLevelEffectInfo.attributeType, preLevelEffectInfo.value)
      local attributeStr = locale.attribute(preLevelEffectInfo.attributeType)
      preEffectStr = attributeStr .. " " .. valueStr
      preEffectStr = string.format("%s%s", F_COLOR.GetColor("bright_blue", true), preEffectStr)
    end
    local curLevelEffectInfo = levelEffectInfo.curEffectInfo
    if curLevelEffectInfo ~= nil then
      local valueStr = GetModifierCalcValue(curLevelEffectInfo.attributeType, curLevelEffectInfo.value)
      local attributeStr = locale.attribute(curLevelEffectInfo.attributeType)
      curEffectStr = attributeStr .. " " .. valueStr
      curEffectStr = string.format("%s%s", F_COLOR.GetColor("bright_blue", true), curEffectStr)
    end
    local content = GetUIText(COMMON_TEXT, "equip_slot_reinforce_msg_change_level_effect_desc", preEffectStr, curEffectStr)
    wnd.itemIcon:RemoveAllAnchors()
    wnd.itemIcon:AddAnchor("TOP", wnd, "TOP", 0, 61)
    wnd.textbox:RemoveAllAnchors()
    wnd.textbox:AddAnchor("TOP", wnd.itemIcon, "BOTTOM", 0, 7)
    wnd.itemTextbox:RemoveAllAnchors()
    wnd.itemTextbox:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 12)
    wnd.itemTextbox.bg:RemoveAllAnchors()
    wnd.itemTextbox.bg:AddAnchor("CENTER", wnd.itemTextbox, 0, 3)
    wnd:SetTitle(GetCommonText("equip_slot_reinforce_msg_change_level_effect_title"))
    wnd:SetContentEx(equipSlotStr, nil, nil, content)
    function wnd:OkProc()
      wnd:Show(false)
    end
  end
  X2DialogManager:RequestNoticeDialog(DialogHandler, equip_slot_reinforce_window:GetParent():GetId())
end
if X2Player:GetFeatureSet().equipSlotEnchantment then
  CreateReinforceBtn(equippedItem)
  CreateEquipSlotReinforcePopupWindow(equippedItem.equipSlotReinforceBtn.detailBtn)
  CreateEquipSlotReinforceWindow(equip_slot_reinforce_window)
  CreateEquipSlotReinforceLevelEffectChangeWindow(equip_slot_reinforce_window)
  CreateEquipSlotReinforceLevelEffectDetailWindow(equip_slot_reinforce_window)
  local excludeReinforceSlotList = {
    9,
    14,
    15,
    20,
    21
  }
  for i = 1, #PLAYER_EQUIP_SLOTS do
    local parent = IsLeftSide(i) and equip_slot_reinforce_window.leftSlots or equip_slot_reinforce_window.rightSlots
    CreateReinforceSlot(i, parent, excludeReinforceSlotList)
  end
  equip_slot_reinforce_window.slot[1]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 0)
  equip_slot_reinforce_window.slot[3]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 48)
  equip_slot_reinforce_window.slot[4]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 96)
  equip_slot_reinforce_window.slot[8]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 144)
  equip_slot_reinforce_window.slot[6]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 192)
  equip_slot_reinforce_window.slot[5]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 317)
  equip_slot_reinforce_window.slot[7]:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.leftSlots, 0, 365)
  equip_slot_reinforce_window.slot[2]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 0)
  equip_slot_reinforce_window.slot[10]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 48)
  equip_slot_reinforce_window.slot[11]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 96)
  equip_slot_reinforce_window.slot[12]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 144)
  equip_slot_reinforce_window.slot[13]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 192)
  equip_slot_reinforce_window.slot[16]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 250)
  equip_slot_reinforce_window.slot[17]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 298)
  equip_slot_reinforce_window.slot[18]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 346)
  equip_slot_reinforce_window.slot[19]:AddAnchor("TOPLEFT", equip_slot_reinforce_window.rightSlots, 0, 394)
  for i = ESRA_OFFENCE, ESRA_MAX - 1 do
    CreateReinforceSetEffectWindow(equip_slot_reinforce_window.rightSlots, i)
  end
  equip_slot_reinforce_window.setEffect[ESRA_DEFENCE].window:AddAnchor("TOPRIGHT", equip_slot_reinforce_window.slot[1], "TOPLEFT", 0, 0)
  equip_slot_reinforce_window.setEffect[ESRA_SUPPORT].window:AddAnchor("TOPLEFT", equip_slot_reinforce_window.slot[2], "TOPRIGHT", 0, 0)
  equip_slot_reinforce_window.setEffect[ESRA_OFFENCE].window:AddAnchor("TOPLEFT", equip_slot_reinforce_window.slot[16], "TOPRIGHT", 0, 0)
  equip_slot_reinforce_window.Event = {
    EQUIP_SLOT_REINFORCE_UPDATE = function(equipSlot)
      UpdateEquipSlotReinforceSlot(equipSlot)
      UpdateEquipSlotReinforceWindow(equipSlot)
      UpdateLevelEffectChangeWindow(equipSlot)
    end,
    EQUIP_SLOT_REINFORCE_MSG_CHAGNE_LEVEL_EFFECT = function(levelEffectInfo)
      ShowMsgChangeLevelEffect(levelEffectInfo)
    end,
    EQUIP_SLOT_REINFORCE_MSG_LEVEL_UP = function(equipSlot, level)
      selected_material_index = 0
    end,
    REMOVED_ITEM = function()
      UpdateEquipSlotReinforceWindow(selected_equip_slot)
    end
  }
  equip_slot_reinforce_window:SetHandler("OnEvent", function(this, event, ...)
    equip_slot_reinforce_window.Event[event](...)
  end)
  RegistUIEvent(equip_slot_reinforce_window, equip_slot_reinforce_window.Event)
  InitEquipSlotReinforce()
end
