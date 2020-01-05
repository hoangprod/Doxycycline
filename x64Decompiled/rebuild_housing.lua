local MAX_MATERIAL = 6
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function SetViewOfRebuildHousingWnd(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(housingLocale.rebuildWnd.width, 595)
  window:AddAnchor("RIGHT", "UIParent", -sideMargin, 0)
  window:SetTitle(GetUIText(COMMON_TEXT, "rebuild_housing"))
  window:EnableHidingIsRemove(true)
  local width = window:GetWidth() - sideMargin * 2
  local height = window:GetHeight() - titleMargin - sideMargin
  local rightContentWidth = width * housingLocale.rebuildWnd.rightSectionWidthPercent
  local rightSection = window:CreateChildWidget("emptywidget", "rightSection", 0, true)
  rightSection:Show(true)
  rightSection:SetExtent(rightContentWidth, height)
  rightSection:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  local infoSection = rightSection:CreateChildWidget("emptywidget", "infoSection", 0, true)
  infoSection:SetExtent(rightSection:GetWidth(), 78)
  infoSection:AddAnchor("TOPRIGHT", rightSection, 0, 0)
  local bg = CreateContentBackground(infoSection, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", infoSection, -5, 0)
  bg:AddAnchor("BOTTOMRIGHT", infoSection, 5, 0)
  local changePointIcon = infoSection:CreateChildWidget("emptywidget", "changePointIcon", 0, true)
  changePointIcon:Show(false)
  changePointIcon:AddAnchor("RIGHT", bg, -10, 0)
  local icon = changePointIcon:CreateDrawable(TEXTURE_PATH.HOUSING_REBUILDING, "upgrade_guide", "background")
  icon:AddAnchor("CENTER", changePointIcon, 0, 0)
  changePointIcon:SetExtent(icon:GetExtent())
  local OnEnter = function(self)
    if self.tooltip == nil or self.tooltip == "" then
      return
    end
    SetTooltip(self.tooltip, self)
  end
  changePointIcon:SetHandler("OnEnter", OnEnter)
  local housingItemIcon = CreateItemIconButton("housingItemIcon", infoSection)
  housingItemIcon:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  housingItemIcon:AddAnchor("LEFT", infoSection, sideMargin / 1.5, 0)
  infoSection.housingItemIcon = housingItemIcon
  local name = infoSection:CreateChildWidget("label", "name", 0, true)
  name:SetExtent(infoSection:GetWidth() - housingItemIcon:GetWidth() - sideMargin * 1.2, FONT_SIZE.LARGE)
  name:AddAnchor("TOPLEFT", housingItemIcon, "TOPRIGHT", 5, 0)
  name.style:SetFontSize(FONT_SIZE.LARGE)
  name.style:SetAlign(ALIGN_LEFT)
  name.style:SetEllipsis(true)
  ApplyTextColor(name, FONT_COLOR.MIDDLE_TITLE)
  local OnEnter = function(self)
    if self:GetWidth() > self.style:GetTextWidth(self:GetText()) then
      return
    end
    SetTooltip(self:GetText(), self)
  end
  name:SetHandler("OnEnter", OnEnter)
  local requireLaborPower = infoSection:CreateChildWidget("label", "requireLaborPower", 0, true)
  requireLaborPower:SetExtent(name:GetWidth(), FONT_SIZE.MIDDLE)
  requireLaborPower:AddAnchor("TOPLEFT", name, "BOTTOMLEFT", 0, 5)
  requireLaborPower.style:SetAlign(ALIGN_LEFT)
  requireLaborPower.style:SetEllipsis(true)
  local requireActability = infoSection:CreateChildWidget("label", "requireActability", 0, true)
  requireActability:SetExtent(name:GetWidth(), FONT_SIZE.MIDDLE)
  requireActability:AddAnchor("TOPLEFT", requireLaborPower, "BOTTOMLEFT", 0, 2)
  requireActability.style:SetAlign(ALIGN_LEFT)
  requireActability.style:SetEllipsis(true)
  function infoSection:Init()
    housingItemIcon:Init()
    name:Show(false)
    changePointIcon:Show(false)
    requireLaborPower:Show(false)
    requireActability:Show(false)
  end
  function infoSection:SetContentWidth(visibleChangPointIcon)
    local width = 0
    if visibleChangPointIcon then
      width = infoSection:GetWidth() - housingItemIcon:GetWidth() - changePointIcon:GetWidth() - sideMargin * 1.5
    else
      width = infoSection:GetWidth() - housingItemIcon:GetWidth() - sideMargin * 1.5
    end
    name:SetWidth(width)
    requireLaborPower:SetWidth(width)
    requireActability:SetWidth(width)
  end
  local materialSection = rightSection:CreateChildWidget("emptywidget", "materialSection", 0, true)
  materialSection:SetExtent(rightSection:GetWidth(), 75)
  materialSection:AddAnchor("TOPLEFT", infoSection, "BOTTOMLEFT", 0, sideMargin / 2)
  local bg = CreateContentBackground(materialSection, "TYPE8", "brown")
  bg:AddAnchor("TOPLEFT", materialSection, -sideMargin, sideMargin)
  bg:AddAnchor("BOTTOMRIGHT", materialSection, sideMargin, sideMargin / 2)
  local title = materialSection:CreateChildWidget("label", "title", 0, false)
  title:SetExtent(materialSection:GetWidth(), FONT_SIZE.LARGE)
  title:SetText(GetUIText(COMMON_TEXT, "material_item"))
  title:AddAnchor("TOPLEFT", materialSection, 0, 0)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  local inset = math.ceil(materialSection:GetWidth() / MAX_MATERIAL) + 2.5
  materialSection.item = {}
  for i = 1, MAX_MATERIAL do
    local item = CreateItemIconButton(string.format("item.%d", i), materialSection)
    item:AddAnchor("BOTTOMLEFT", materialSection, (i - 1) * inset, 0)
    item:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
    materialSection.item[i] = item
  end
  function materialSection:Init()
    for i = 1, #self.item do
      self.item[i]:Init()
    end
  end
  local taxSection = rightSection:CreateChildWidget("emptywidget", "taxSection", 0, true)
  taxSection:SetExtent(rightContentWidth, 125)
  taxSection:AddAnchor("TOPLEFT", materialSection, "BOTTOMLEFT", 0, sideMargin)
  local title = taxSection:CreateChildWidget("label", "title", 0, false)
  title:SetExtent(rightContentWidth, FONT_SIZE.LARGE)
  title:AddAnchor("TOPLEFT", taxSection, 0, 0)
  title:SetText(GetUIText(COMMON_TEXT, "tax_change_info"))
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  local content = taxSection:CreateChildWidget("textbox", "content", 0, false)
  content:SetExtent(rightContentWidth, 95)
  content:SetInset(10, 10, 10, 10)
  content:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, sideMargin / 1.5)
  content.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local bg = CreateContentBackground(content, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", content, -5, -sideMargin / 2)
  bg:AddAnchor("BOTTOMRIGHT", content, 5, sideMargin / 2)
  function taxSection:SetInfo(curHousingInfo, targetHousingInfo)
    if curHousingInfo == nil or targetHousingInfo == nil then
      return
    end
    local str = ""
    local addedStr = ""
    local SetDiffText = function(titleStr, value1, value2)
      if value1 == nil then
        value1 = 0
      end
      if value2 == nil then
        value2 = 0
      end
      local str = ""
      if value1 ~= value2 then
        str = string.format("%s: %s", titleStr, GetUIText(COMMON_TEXT, "change_value", string.format("%s%s", F_MONEY:GetTaxString(value1, true), FONT_COLOR_HEX.BLUE), string.format("%s|r", F_MONEY:GetTaxString(value2, true))))
      else
        str = string.format("%s: %s", titleStr, F_MONEY:GetTaxString(value2, true))
      end
      return str
    end
    addedStr = SetDiffText(GetUIText(COMMON_TEXT, "deposit"), curHousingInfo.deposit, targetHousingInfo.deposit)
    str = F_TEXT.SetEnterString(str, addedStr)
    addedStr = SetDiffText(GetUIText(COMMON_TEXT, "base_tax"), curHousingInfo.base_tax, targetHousingInfo.base_tax)
    str = F_TEXT.SetEnterString(str, addedStr)
    addedStr = string.format("%s: %d", GetUIText(COMMON_TEXT, "housing_possession_count"), curHousingInfo.count)
    str = F_TEXT.SetEnterString(str, addedStr)
    addedStr = SetDiffText(GetUIText(HOUSING_TEXT, "build_heavyTax"), curHousingInfo.total_tax, targetHousingInfo.total_tax)
    str = F_TEXT.SetEnterString(str, addedStr)
    content:SetText(str)
    content:Show(true)
  end
  function taxSection:Init()
    content:Show(false)
  end
  local buildingStepSection = rightSection:CreateChildWidget("emptywidget", "buildingStepSection", 0, true)
  buildingStepSection:SetExtent(rightContentWidth, 100)
  buildingStepSection:AddAnchor("TOPLEFT", taxSection, "BOTTOMLEFT", 0, sideMargin / 1.5)
  local title = buildingStepSection:CreateChildWidget("label", "title", 0, false)
  title:SetText(GetUIText(HOUSING_TEXT, "build_materialLabel"))
  title:SetExtent(rightContentWidth, FONT_SIZE.LARGE)
  title:AddAnchor("TOPLEFT", buildingStepSection, 0, 0)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  local bg = CreateContentBackground(buildingStepSection, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", -5, 3)
  bg:AddAnchor("BOTTOMRIGHT", buildingStepSection, 5, 0)
  local stepMaterial = CreateBuildingMaterialPart(buildingStepSection)
  stepMaterial:AddAnchor("TOP", bg, 0, sideMargin / 1.5)
  buildingStepSection.stepMaterial = stepMaterial
  local message = rightSection:CreateChildWidget("textbox", "message", 0, false)
  message:SetWidth(rightContentWidth)
  message:SetText(GetUIText(COMMON_TEXT, "rebuiling_start_message"))
  message:AddAnchor("TOP", bg, "BOTTOM", 0, sideMargin / 2)
  message:SetHeight(message:GetTextHeight())
  ApplyTextColor(message, FONT_COLOR.BLUE)
  local taxIcon = CreateItemIconButton("taxIcon", rightSection)
  taxIcon:AddAnchor("TOP", message, "BOTTOM", 0, sideMargin / 1.5)
  rightSection.taxIcon = taxIcon
  local info = {
    leftButtonStr = GetUIText(COMMON_TEXT, "building"),
    buttonBottomInset = 0,
    rightButtonLeftClickFunc = function()
      window:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(window, info, rightSection)
  window.leftButton:Enable(false)
  local leftSection = window:CreateChildWidget("emptywidget", "leftSection", 0, false)
  leftSection:Show(true)
  leftSection:SetExtent(width - rightContentWidth - sideMargin / 1.5, height)
  leftSection:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  local bg = CreateContentBackground(leftSection, "TYPE3", "brown")
  bg:AddAnchor("TOPLEFT", leftSection, -sideMargin, -sideMargin)
  bg:AddAnchor("BOTTOMRIGHT", leftSection, sideMargin, sideMargin)
  local previewBtn = window:CreateChildWidget("button", "previewBtn", 0, true)
  previewBtn:Enable(false)
  previewBtn:SetText(GetUIText(STORE_TEXT, "preview"))
  ApplyButtonSkin(previewBtn, BUTTON_CONTENTS.HOUSING_PREVIEW)
  previewBtn:AddAnchor("TOPLEFT", leftSection, 0, 0)
  local resetBtn = window:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:Enable(false)
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.RESET)
  resetBtn:AddAnchor("LEFT", previewBtn, "RIGHT", -5, -2)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "cancel_preview"), self)
  end
  resetBtn:SetHandler("OnEnter", OnEnter)
  local itemList = W_CTRL.CreateScrollListBox("itemList", window, window)
  itemList:AddAnchor("TOPLEFT", previewBtn, "BOTTOMLEFT", 0, 5)
  itemList.bg:SetVisible(false)
  itemList.content.itemStyle:SetFontSize(FONT_SIZE.MIDDLE)
  itemList.content:ShowTooltip(true)
  CreateLoadingTextureSet(window)
  window.modalLoadingWindow:AddAnchor("TOPLEFT", window, 2, titleMargin)
  window.modalLoadingWindow:AddAnchor("BOTTOMRIGHT", window, -3, 0)
  local _, rHeight = F_LAYOUT.GetExtentWidgets(rightSection.infoSection, rightSection.taxIcon)
  rHeight = rHeight + window.leftButton:GetHeight() + sideMargin / 1.5
  rightSection:SetHeight(rHeight)
  leftSection:SetHeight(rHeight)
  itemList:SetExtent(leftSection:GetWidth(), leftSection:GetHeight() - previewBtn:GetHeight() - 5)
  window:SetHeight(rHeight + sideMargin + titleMargin)
  return window
end
function CreateRebuildHousingWnd(id, parent)
  local window = SetViewOfRebuildHousingWnd(id, parent)
  local rightSection = window.rightSection
  local infoSection = rightSection.infoSection
  local materialSection = rightSection.materialSection
  local taxSection = rightSection.taxSection
  local stepMaterial = rightSection.buildingStepSection.stepMaterial
  local taxIcon = rightSection.taxIcon
  local rebuildHousingItemInfo, rebuildHousingType, previewHousingType, curHousingInfo
  function window:HideProc()
    X2House:CancelRebuild()
    previewHousingType = nil
  end
  ButtonOnClickHandler(window.resetBtn, window.HideProc)
  local function InitTaxIcon()
    if rightSection.taxIcon == nil then
      return
    end
    rightSection.taxIcon:Init()
  end
  local function InitRightSection()
    infoSection:Init()
    materialSection:Init()
    rebuildHousingItemInfo = nil
    rebuildHousingType = nil
    taxSection:Init()
    InitTaxIcon()
    window.previewBtn:Enable(false)
    window.leftButton:Enable(false)
    window.rightButton:Enable(true)
  end
  local function TryPreview()
    if previewHousingType == nil or previewHousingType ~= rebuildHousingType then
      X2House:RequestLookAheadMode()
      X2House:LookAheadRebuildHouse(rebuildHousingType)
      previewHousingType = rebuildHousingType
    end
  end
  local function PreivewBtnLeftClickFunc()
    local value = window.itemList:GetSelectedValue()
    if value == 0 then
      return
    end
    TryPreview()
  end
  ButtonOnClickHandler(window.previewBtn, PreivewBtnLeftClickFunc)
  function stepMaterial:UpdateLabel(info)
    local icon = self.icons[info.step]
    if icon ~= nil then
      icon:SetStack(info.consumeItemStack)
      icon.label:SetText(tostring(info.needActions))
    end
  end
  function window:SetHousingList()
    self.itemList:ClearItem()
    local info = X2House:GetHousingRebuildingPackInfo()
    if info == nil then
      return
    end
    for i = 1, #info do
      self.itemList:AppendItem(info[i].name, info[i].type)
    end
  end
  function window:ShowProc()
    if X2House:IsCastle() then
      self:WaitPage(false)
    else
      self:WaitPage(true)
    end
    self:SetHousingList()
  end
  local function FillRightSection(rebuildingType)
    InitRightSection()
    local baseInfo = X2House:GetHousingRebuildingBaseInfo(rebuildingType)
    if baseInfo == nil then
      return
    end
    if baseInfo.change_point_desc ~= nil and baseInfo.change_point_desc ~= "" then
      infoSection.changePointIcon:Show(true)
      infoSection.changePointIcon.tooltip = string.format([[
%s%s
%s%s]], FONT_COLOR_HEX.SOFT_YELLOW, GetUIText(COMMON_TEXT, "housing_rebuilding_after_change_point"), FONT_COLOR_HEX.SOFT_BROWN, baseInfo.change_point_desc)
    end
    infoSection:SetContentWidth(infoSection.changePointIcon:IsVisible())
    rebuildHousingItemInfo = X2Item:GetItemInfoByType(baseInfo.housing_item_type)
    if rebuildHousingItemInfo then
      infoSection.housingItemIcon:SetItemInfo(rebuildHousingItemInfo)
      infoSection.name:Show(true)
      infoSection.name:SetText(rebuildHousingItemInfo.name or "nil")
    end
    local materialInfo = X2House:GetHousingRebuildingMaterialInfo(rebuildingType)
    for i = 1, #materialInfo do
      local info = materialInfo[i]
      local itemInfo = X2Item:GetItemInfoByType(info.item_type)
      materialSection.item[i]:SetItemInfo(itemInfo)
      materialSection.item[i]:SetStack(info.count, info.amount)
    end
    rebuildHousingType = baseInfo.rebuilding_housing_type
    local targetHousingInfo = X2House:GetHousingRebuildingTaxInfo(rebuildingType)
    taxSection:SetInfo(curHousingInfo, targetHousingInfo)
    local constructionStep = X2House:GetHousingModelConstructionInfo(rebuildHousingType)
    stepMaterial:SetInfo(constructionStep)
    if taxIcon ~= nil then
      local curCount = X2House:CountTaxItemInBag()
      local targetCount = targetHousingInfo.total_tax
      local itemInfo = X2House:GetTaxItem()
      if targetCount > 0 then
        taxIcon:SetItemInfo(itemInfo)
        taxIcon:SetStack(curCount, targetCount)
      end
    end
    window.leftButton:Enable(X2House:CanRebuild(rebuildHousingType))
  end
  function window.itemList:OnSelChanged()
    local index = self:GetSelectedIndex()
    if index < 0 then
      return
    end
    local value = self:GetSelectedValue()
    if value == 0 then
      return
    end
    FillRightSection(value)
    window.previewBtn:Enable(true)
    window.resetBtn:Enable(true)
  end
  local function LeftButtonLeftClickFunc()
    local function DialogHandler(wnd, infoTable)
      local arrow = W_ICON.CreateArrowIcon(wnd)
      wnd:SetWidth(510)
      local contentWidth = 510 - sideMargin * 2
      local function CreateSection(color)
        local section = wnd:CreateChildWidget("emptywidget", "section", 0, false)
        section:SetExtent(220, 160)
        local bg = CreateContentBackground(wnd, "TYPE10", color, "artwork")
        bg:AddAnchor("TOPLEFT", section, 0, 0)
        bg:AddAnchor("BOTTOMRIGHT", section, 0, 0)
        section.bg = bg
        local itemIcon = CreateItemIconButton("itemIcon", section)
        section.itemIcon = itemIcon
        local name = itemIcon:CreateChildWidget("textbox", "name", 0, true)
        name:SetExtent(section:GetWidth() - sideMargin, FONT_SIZE.LARGE)
        name:SetAutoResize(true)
        name:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 5)
        name.style:SetFontSize(FONT_SIZE.LARGE)
        ApplyTextColor(name, FONT_COLOR.DEFAULT)
        function section:SetInfo(info)
          if info == nil then
            return
          end
          name:SetText(info.name)
          itemIcon:SetItemInfo(info)
        end
        return section
      end
      local AmendItemIconAnchor = function(leftSection, rightSection)
        local height = math.max(leftSection.itemIcon.name:GetHeight(), rightSection.itemIcon.name:GetHeight())
        leftSection.itemIcon:RemoveAllAnchors()
        rightSection.itemIcon:RemoveAllAnchors()
        leftSection.itemIcon:AddAnchor("CENTER", leftSection, 0, -height / 2)
        rightSection.itemIcon:AddAnchor("CENTER", rightSection, 0, -height / 2)
      end
      local leftSection = CreateSection("brown")
      leftSection:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
      local curHousingItemType = X2House:GetCurrentHousingItemType()
      leftSection:SetInfo(X2Item:GetItemInfoByType(curHousingItemType))
      arrow:AddAnchor("LEFT", leftSection, "RIGHT", -2, 0)
      arrow:SetTextureColor("blue")
      local rightSection = CreateSection("blue")
      rightSection:AddAnchor("TOPRIGHT", wnd, -sideMargin, titleMargin)
      rightSection:SetInfo(rebuildHousingItemInfo)
      AmendItemIconAnchor(leftSection, rightSection)
      wnd.textbox:RemoveAllAnchors()
      wnd.textbox:AddAnchor("TOPLEFT", leftSection, "BOTTOMLEFT", 0, sideMargin)
      wnd.textbox:SetWidth(contentWidth)
      wnd:SetTitle(GetUIText(COMMON_TEXT, "check_rebuilding_housing"))
      wnd:SetContent(GetUIText(COMMON_TEXT, "check_rebuilding_housing_body"), false)
      local checkLabel = wnd:CreateChildWidget("label", "checkLabel", 0, false)
      checkLabel:SetExtent(contentWidth, FONT_SIZE.LARGE)
      checkLabel:SetText(GetUIText(COMMON_TEXT, "confirm_building_start"))
      checkLabel.style:SetFontSize(FONT_SIZE.LARGE)
      checkLabel:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, sideMargin / 1.5)
      ApplyTextColor(checkLabel, FONT_COLOR.MIDDLE_TITLE)
      wnd:RegistBottomWidget(checkLabel)
      wnd:RemoveAllAnchors()
      wnd:AddAnchor("RIGHT", "UIParent", -sideMargin, 0)
      TryPreview()
      function wnd:OkProc()
        if rebuildHousingType == nil then
          return
        end
        X2House:StartRebuild(rebuildHousingType)
        window:Show(false)
      end
      function wnd:CancelProc()
        window:HideProc()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
  end
  window.leftButton:SetHandler("OnClick", LeftButtonLeftClickFunc)
  local events = {
    HOUSE_REBUILD_TAX_INFO = function()
      window:WaitPage(false)
      curHousingInfo = X2House:GetCurrentHousingTaxInfo()
    end,
    ENTERED_WORLD = function()
      window:Show(false)
    end,
    HOUSE_INTERACTION_START = function()
      window:Show(false)
    end,
    HOUSE_INTERACTION_END = function()
      window:Show(false)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
