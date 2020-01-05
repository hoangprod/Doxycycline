local EVOLVING_MAX_ATTR = 5
function SetViewOfEvolvingEnchantWindow(tabWindow)
  local function CreateTabSubMenu(id, parent, menuTexts, maxCount)
    local widget = UIParent:CreateWidget("emptywidget", id, parent)
    local bg = CreateContentBackground(widget, "TYPE2", "brown")
    bg:AddAnchor("TOPLEFT", widget, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
    CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "evolving"))
    widget.subMenuButtons = {}
    local widthSum = 15
    for i = 1, maxCount do
      local text = ""
      if menuTexts[i] ~= nil then
        text = menuTexts[i]
      end
      local subMenuButton = widget:CreateChildWidget("button", "subMenuButtons", i, true)
      ApplyButtonSkin(subMenuButton, BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_UNSELECTED)
      subMenuButton:SetText(text)
      subMenuButton:SetHeight(20)
      subMenuButton:AddAnchor("LEFT", widget, widthSum, 0)
      subMenuButton.style:SetFontSize(FONT_SIZE.LARGE)
      subMenuButton:SetAutoResize(true)
      widthSum = widthSum + subMenuButton:GetWidth()
      if i ~= maxCount then
        local seperateLabel = subMenuButton:CreateChildWidget("label", "seperateLabel", i, true)
        local c = GetIngameShopSelectedSubMenuButtonFontColor().normal
        ApplyTextColor(seperateLabel, c)
        seperateLabel:AddAnchor("TOPLEFT", subMenuButton, "TOPRIGHT", 5, 0)
        seperateLabel:AddAnchor("BOTTOMLEFT", subMenuButton, "BOTTOMRIGHT", 0, 0)
        seperateLabel:SetText("|")
        seperateLabel.style:SetFontSize(FONT_SIZE.LARGE)
        seperateLabel:SetAutoResize(true)
        widthSum = widthSum + seperateLabel:GetWidth() + 10
      end
      widget.subMenuButtons[i] = subMenuButton
    end
    function widget:Select(index)
      for j = 1, #self.subMenuButtons do
        SetButtonFontColor(self.subMenuButtons[j], BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_UNSELECTED.fontColor)
      end
      SetButtonFontColor(self.subMenuButtons[index], BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_SELECTED.fontColor)
    end
    widget.selIndex = 0
    for i = 1, #widget.subMenuButtons do
      do
        local button = widget.subMenuButtons[i]
        function button:OnClick()
          widget:Select(i)
          widget.selIndex = i
          if widget.OnClickProc ~= nil then
            widget:OnClickProc(i)
          end
        end
        button:SetHandler("OnClick", button.OnClick)
      end
    end
    return widget
  end
  local anchor, height
  local commonWidth = tabWindow:GetWidth()
  height = WINDOW_ENCHANT.EVOLVING_ENCHANT_TAB.SUB_MENU.HEIGHT
  anchor = WINDOW_ENCHANT.EVOLVING_ENCHANT_TAB.SUB_MENU.ANCHOR
  local subMenuTexts = WINDOW_ENCHANT.EVOLVING_ENCHANT_TAB.SUB_MENU.TEXTS
  local tabSubMenu = CreateTabSubMenu("tabSubMenu", tabWindow, subMenuTexts, #subMenuTexts)
  tabSubMenu:AddAnchor("TOPLEFT", tabWindow, anchor[1], anchor[2])
  tabSubMenu:SetExtent(commonWidth, height)
  tabWindow.tabSubMenu = tabSubMenu
  local anchor = WINDOW_ENCHANT.EVOLVING_ENCHANT_TAB.GUIDE_ICON_ANCHOR
  local guide = W_ICON.CreateGuideIconWidget(tabWindow)
  guide:AddAnchor("RIGHT", tabSubMenu, anchor[1], 0)
  tabWindow.guide = guide
  local decoY = 10
  local featureSet = X2Player:GetFeatureSet()
  if not featureSet.itemEvolvingReRoll then
    decoY = decoY - 20
    tabSubMenu:Show(false)
  end
  local reRollDeco = tabWindow:CreateDrawable(TEXTURE_PATH.COMMON_ENCHANT, "effect", "background")
  reRollDeco:AddAnchor("TOP", tabSubMenu, "BOTTOM", 0, 10)
  if not featureSet.itemEvolvingReRoll then
    reRollDeco:SetVisible(false)
  end
  tabWindow.reRollDeco = reRollDeco
  local slotTargetItem = CreateTargetSlot(tabWindow, GetUIText(COMMON_TEXT, "growth_item"))
  function slotTargetItem:ApplyAlpha(value)
    self:SetAlpha(value)
    self.bg:SetColor(1, 1, 1, value)
  end
  local materialBg = tabWindow:CreateDrawable(TEXTURE_PATH.COSPLAY_ENCHANT, "soket_green", "background")
  materialBg:AddAnchor("LEFT", slotTargetItem, "RIGHT", 40, 0)
  tabWindow.materialSlots = {}
  tabWindow.materialBg = materialBg
  local targetAnchor = materialBg
  for i = 1, MAX_ITEM_EVOLVE_MATERIAL_SLOT do
    do
      local materialSlot = CreateItemIconButton("materialSlot" .. i, tabWindow)
      materialSlot:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
      materialSlot.back:SetVisible(false)
      materialSlot:RegisterForClicks("RightButton")
      materialSlot.index = i
      tabWindow.materialSlots[i] = materialSlot
      if targetAnchor == materialBg then
        materialSlot:AddAnchor("LEFT", targetAnchor, 28, 1)
      else
        materialSlot:AddAnchor("LEFT", targetAnchor, "RIGHT", 6, 0)
      end
      targetAnchor = materialSlot
      function materialSlot:ApplyAlpha(value)
        self:SetAlpha(value)
        materialSlot:SetAlpha(value)
      end
    end
  end
  local slotEnchantItem = CreateItemIconButton("slotEnchantItem", tabWindow)
  slotEnchantItem:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
  slotEnchantItem.back:SetVisible(false)
  slotEnchantItem:RegisterForClicks("RightButton")
  slotEnchantItem:AddAnchor("LEFT", reRollDeco, "RIGHT", -47, 10)
  tabWindow.slotEnchantItem = slotEnchantItem
  local slotEnchantItemBg = tabWindow:CreateDrawable(TEXTURE_PATH.COMMON_ENCHANT, "socket_purple", "background")
  slotEnchantItemBg:AddAnchor("CENTER", slotEnchantItem, -8, -5)
  slotEnchantItem.bg = slotEnchantItemBg
  local materialSlotLabel = CreateEnchantSlotLabel(tabWindow, GetUIText(COMMON_TEXT, "material_item"))
  tabWindow.materialSlotLabel = materialSlotLabel
  local autoMaterial = tabWindow:CreateChildWidget("button", "autoMaterial", 0, true)
  autoMaterial:SetText(GetCommonText("material_auto_set"))
  ApplyButtonSkin(autoMaterial, BUTTON_BASIC.DEFAULT_SMALL)
  autoMaterial:AddAnchor("BOTTOM", materialBg, "TOP", 0, 0)
  autoMaterial.materialExist = false
  function autoMaterial:SetMode(materialExist)
    autoMaterial.materialExist = materialExist
    if materialExist then
      autoMaterial:SetText(GetCommonText("material_release"))
    else
      autoMaterial:SetText(GetCommonText("material_auto_set"))
    end
  end
  local function OnClickAutoMaterial(self)
    if self.materialExist then
      tabWindow.materialSlots:Clear()
    else
      X2Cursor:ClearCursor()
      X2ItemEnchant:SetAutoMaterials()
    end
  end
  autoMaterial:SetHandler("OnClick", OnClickAutoMaterial)
  local bg = CreateContentBackground(tabWindow, "TYPE10", "brown")
  bg:SetExtent(tabWindow:GetWidth(), 280)
  bg:AddAnchor("TOP", tabWindow, 0, 200)
  local commonWidth = bg:GetWidth() - MARGIN.WINDOW_SIDE - 10
  local name = tabWindow:CreateChildWidget("textbox", "name", 0, true)
  name:SetExtent(commonWidth, 35)
  name:AddAnchor("TOP", bg, 0, 9)
  name.style:SetFontSize(FONT_SIZE.LARGE)
  local expLabel = tabWindow:CreateChildWidget("label", "expLabel", 0, false)
  expLabel:SetExtent(commonWidth, FONT_SIZE.LARGE)
  expLabel:AddAnchor("TOPLEFT", name, "BOTTOMLEFT", 0, 4)
  expLabel.style:SetFontSize(FONT_SIZE.LARGE)
  expLabel:SetText(GetUIText(COMMON_TEXT, "exp"))
  ApplyTextColor(expLabel, FONT_COLOR.MIDDLE_TITLE)
  expLabel.style:SetAlign(ALIGN_LEFT)
  local bonusExpGuage = W_BAR.CreateStatusBar("bonusExpGuage", tabWindow, "item_evolving_material")
  bonusExpGuage:SetWidth(commonWidth)
  bonusExpGuage:AddAnchor("TOPLEFT", expLabel, "BOTTOMLEFT", 0, 4)
  tabWindow.bonusExpGuage = bonusExpGuage
  local materialExpGuage = W_BAR.CreateStatusBar("materialExpGuage", tabWindow, "item_evolving_target")
  materialExpGuage:SetWidth(commonWidth)
  materialExpGuage:AddAnchor("TOPLEFT", bonusExpGuage, 0, 0)
  tabWindow.materialExpGuage = materialExpGuage
  local targetCurExpGuage = W_BAR.CreateStatusBar("targetCurExpGuage", tabWindow, "item_evolving_target")
  targetCurExpGuage:SetWidth(commonWidth)
  targetCurExpGuage:AddAnchor("TOPLEFT", bonusExpGuage, 0, 0)
  tabWindow.targetCurExpGuage = targetCurExpGuage
  local nextBonusExpGuage = W_BAR.CreateStatusBar("nextBonusExpGuage", tabWindow, "item_evolving_target")
  nextBonusExpGuage:SetWidth(commonWidth)
  nextBonusExpGuage:AddAnchor("TOPLEFT", bonusExpGuage, 0, 0)
  tabWindow.nextBonusExpGuage = nextBonusExpGuage
  local nextMaterialExpGuage = W_BAR.CreateStatusBar("nextMaterialExpGuage", tabWindow, "item_evolving_target")
  nextMaterialExpGuage:SetWidth(commonWidth)
  nextMaterialExpGuage:AddAnchor("TOPLEFT", bonusExpGuage, 0, 0)
  tabWindow.nextMaterialExpGuage = nextMaterialExpGuage
  local overBonusExpGuage = W_BAR.CreateStatusBar("overBonusExpGuage", tabWindow, "item_evolving_target")
  overBonusExpGuage:SetWidth(commonWidth)
  overBonusExpGuage:AddAnchor("TOPLEFT", bonusExpGuage, 0, 0)
  tabWindow.overBonusExpGuage = overBonusExpGuage
  local expValue = tabWindow:CreateChildWidget("textbox", "expValue", 0, true)
  expValue:SetExtent(100, FONT_SIZE.MIDDLE)
  expValue:SetAutoResize(true)
  expValue:SetAutoWordwrap(false)
  expValue:AddAnchor("BOTTOMRIGHT", expLabel, 0, -6)
  expValue.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(expValue, FONT_COLOR.BLUE)
  local changeCountLabel = tabWindow:CreateChildWidget("label", "changeCountLabel", 0, false)
  changeCountLabel:SetExtent(commonWidth, FONT_SIZE.LARGE)
  changeCountLabel.style:SetFontSize(FONT_SIZE.LARGE)
  changeCountLabel.style:SetAlign(ALIGN_LEFT)
  changeCountLabel:SetText(GetUIText(COMMON_TEXT, "reroll_chance"))
  changeCountLabel:SetAutoResize(true)
  ApplyTextColor(changeCountLabel, FONT_COLOR.MIDDLE_TITLE)
  changeCountLabel:AddAnchor("TOPLEFT", materialExpGuage, "BOTTOMLEFT", 0, 18)
  local changeCountGuide = W_ICON.CreateGuideIconWidget(changeCountLabel)
  changeCountGuide:AddAnchor("LEFT", changeCountLabel, "RIGHT", 5, 0)
  local OnChangeCountGuideEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "reroll_chance_guide"), self)
  end
  changeCountGuide:SetHandler("OnEnter", OnChangeCountGuideEnter)
  local changeCount = tabWindow:CreateChildWidget("textbox", "changeCount", 0, true)
  changeCount:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  changeCount:AddAnchor("TOPRIGHT", materialExpGuage, "BOTTOMRIGHT", 0, 18)
  changeCount.style:SetFontSize(FONT_SIZE.LARGE)
  changeCount.style:SetAlign(ALIGN_RIGHT)
  changeCount:SetAutoResize(true)
  changeCount:SetAutoWordwrap(false)
  ApplyTextColor(changeCount, FONT_COLOR.DEFAULT)
  tabWindow.changeCount = changeCount
  local warningChangeCount = tabWindow:CreateChildWidget("emptywidget", "warningChangeCount", 0, true)
  warningChangeCount:AddAnchor("RIGHT", changeCount, "LEFT", -6, 0)
  local warningChangeCountImg = warningChangeCount:CreateDrawable(TEXTURE_PATH.COSPLAY_ENCHANT, "notice", "background")
  warningChangeCountImg:AddAnchor("CENTER", warningChangeCount, 0, 0)
  warningChangeCount:SetExtent(warningChangeCountImg:GetWidth(), warningChangeCountImg:GetHeight())
  tabWindow.warningChangeCount = warningChangeCount
  local OnWarningChangeCountEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "reroll_chance_warning"), self)
  end
  warningChangeCount:SetHandler("OnEnter", OnWarningChangeCountEnter)
  local effectLabel = tabWindow:CreateChildWidget("label", "effectLabel", 0, false)
  effectLabel:SetExtent(commonWidth, FONT_SIZE.LARGE)
  effectLabel.style:SetFontSize(FONT_SIZE.LARGE)
  effectLabel:SetText(GetUIText(COMMON_TEXT, "effect"))
  ApplyTextColor(effectLabel, FONT_COLOR.MIDDLE_TITLE)
  effectLabel:AddAnchor("TOPLEFT", changeCountLabel, "BOTTOMLEFT", 0, 9)
  effectLabel.style:SetAlign(ALIGN_LEFT)
  local listButton = tabWindow:CreateChildWidget("button", "listButton", 0, true)
  listButton:Enable(false)
  listButton:AddAnchor("BOTTOMRIGHT", effectLabel, 0, 0)
  ApplyButtonSkin(listButton, BUTTON_CONTENTS.SEARCH)
  local line = CreateLine(effectLabel, "TYPE1")
  line:AddAnchor("TOPLEFT", effectLabel, "BOTTOMLEFT", -MARGIN.WINDOW_SIDE / 2, 5)
  line:AddAnchor("TOPRIGHT", effectLabel, "BOTTOMRIGHT", MARGIN.WINDOW_SIDE / 2, 5)
  local listCtrl = tabWindow:CreateChildWidget("emptywidget", "listCtrl", 0, true)
  W_CTRL.CreateListCtrl("listCtrl", listCtrl)
  listCtrl:SetExtent(commonWidth, 121)
  listCtrl:AddAnchor("TOPLEFT", effectLabel, "BOTTOMLEFT", 0, 8)
  local valueColWidth = 65
  local nameColWidth = commonWidth - valueColWidth * 2
  local function LayoutFuncNameCol(widget, rowIndex, colIndex, subItem)
    subItem.bg = CreateContentBackground(subItem, "TYPE11", "brown")
    subItem.bg:SetWidth(listCtrl:GetWidth())
    subItem.bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    subItem.bg:AddAnchor("BOTTOM", subItem, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem:SetInset(MARGIN.WINDOW_SIDE, 0, 0, 0)
    local dingbat = W_ICON.DrawRoundDingbat(subItem)
    dingbat:RemoveAllAnchors()
    dingbat:AddAnchor("LEFT", subItem, 5, 0)
  end
  local bgColor = {
    {
      ConvertColor(81),
      ConvertColor(215),
      ConvertColor(132),
      0.2
    },
    {
      ConvertColor(81),
      ConvertColor(151),
      ConvertColor(215),
      0.2
    },
    {
      ConvertColor(215),
      ConvertColor(81),
      ConvertColor(211),
      0.2
    },
    {
      ConvertColor(215),
      ConvertColor(140),
      ConvertColor(81),
      0.2
    },
    {
      ConvertColor(215),
      ConvertColor(81),
      ConvertColor(117),
      0.2
    }
  }
  local function DataSetFuncNameCol(subItem, data, setValue)
    if setValue then
      subItem:Show(true)
      subItem.bg:Show(true)
      local valueStr = locale.attribute(data.value)
      subItem:SetText(valueStr)
      subItem.dingbat:SetVisible(not data.enableLevelup)
      if data.gsNum == nil or data.gsNum < 1 then
        subItem.bg:Show(false)
      else
        ApplyTextureColor(subItem.bg, bgColor[data.gsNum])
      end
    else
      subItem:Show(false)
      subItem.bg:Show(false)
    end
  end
  local DataSetFuncDiffValueCol = function(subItem, data, setValue)
    if setValue then
      local color = FONT_COLOR.DEFAULT
      local valueStr = GetModifierCalcValue(data.name, data.value)
      if data.isDiff then
        color = FONT_COLOR.GREEN
        valueStr = string.format("+%s", valueStr)
      end
      subItem:Show(true)
      subItem:SetText(valueStr)
      ApplyTextColor(subItem, color)
    else
      subItem:Show(false)
    end
  end
  local LayoutFuncValue = function(widget, rowIndex, colIndex, subItem)
    subItem:SetInset(0, 0, 7, 0)
    subItem.style:SetAlign(ALIGN_RIGHT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  listCtrl:InsertColumn("", nameColWidth, LCCIT_STRING, LayoutFuncNameCol, DataSetFuncNameCol)
  listCtrl:InsertColumn("", valueColWidth, LCCIT_STRING, LayoutFuncValue, nil)
  listCtrl:InsertColumn("", valueColWidth, LCCIT_STRING, LayoutFuncValue, DataSetFuncDiffValueCol)
  listCtrl:HideColumnButtons()
  listCtrl:InsertRows(EVOLVING_MAX_ATTR, false)
  for i = 1, listCtrl:GetRowCount() do
    ListCtrlItemGuideLine(listCtrl:GetListCtrlItems(), listCtrl:GetRowCount())
  end
  local radioData = {}
  for i = 1, EVOLVING_MAX_ATTR do
    local item = {text = ""}
    table.insert(radioData, item)
  end
  local radioButtons = CreateRadioGroup("radioButton", listCtrl, "vertical")
  radioButtons:SetGap(9, 9)
  radioButtons:SetData(radioData)
  radioButtons:AddAnchor("TOPLEFT", listCtrl, 1, 4)
  radioButtons:Show(false)
  listCtrl.radioButtons = radioButtons
  local money = W_MODULE:Create("money", tabWindow, WINDOW_MODULE_TYPE.VALUE_BOX)
  money:AddAnchor("TOP", bg, "BOTTOM", 0, 18)
  local laborPower = W_MODULE:Create("laborPower", tabWindow, WINDOW_MODULE_TYPE.VALUE_BOX)
  laborPower:AddAnchor("TOP", money, "BOTTOM", 0, 9)
  local attrInfoStr = tabWindow:CreateChildWidget("textbox", "attrInfoStr", 0, true)
  attrInfoStr:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  attrInfoStr:AddAnchor("TOP", money, "BOTTOM", 0, MARGIN.WINDOW_SIDE * 0.6)
  attrInfoStr.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(attrInfoStr, FONT_COLOR.BLUE)
  local tip = tabWindow:CreateChildWidget("textbox", "tip", 0, true)
  tip:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
end
