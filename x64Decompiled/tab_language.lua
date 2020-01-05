local ITEM_WIDTH = 200
local function AdjustItemWidgetExtent()
  if IsTransformablePlayer() then
    ITEM_WIDTH = 240
  end
end
local function CreataeLanguageItemWindow(parent, itemInfo)
  local itemWindow = CreateEmptyWindow(parent:GetId() .. ".itemWindow", parent)
  itemWindow:Show(true)
  itemWindow:SetExtent(ITEM_WIDTH, 40)
  itemWindow:SetTitleInset(45, 0, 0, 0)
  itemWindow.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  itemWindow:SetTitleText(itemInfo.name)
  ApplyTitleFontColor(itemWindow, FONT_COLOR.DEFAULT)
  itemWindow.itemInfo = itemInfo
  local actabilityPoint = itemWindow:CreateChildWidget("label", "actabilityPoint", 0, true)
  actabilityPoint:SetNumberOnly(true)
  actabilityPoint:SetText(string.format("%d", itemInfo.point + itemInfo.modifyPoint))
  actabilityPoint:AddAnchor("TOPLEFT", itemWindow, 45, 21)
  actabilityPoint.style:SetAlign(ALIGN_LEFT)
  if itemInfo.modifyPoint == 0 then
    ApplyTextColor(actabilityPoint, FONT_COLOR.DEFAULT)
  else
    ApplyTextColor(actabilityPoint, FONT_COLOR.GREEN)
  end
  local bg = itemWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "artwork")
  bg:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local itemIcon = itemWindow:CreateIconImageDrawable("Textures/Defaults/White.dds", "artwork")
  itemIcon:SetColor(1, 1, 1, 1)
  itemIcon:SetCoords(0, 0, 128, 128)
  itemIcon:SetExtent(40, 40)
  itemIcon:AddAnchor("LEFT", itemWindow, 0, 0)
  itemIcon:ClearAllTextures()
  itemWindow.itemIcon = itemIcon
  bg:AddAnchor("CENTER", itemIcon, 0, 0)
  local gauge = W_BAR.CreateSkillBar(itemWindow:GetId() .. ".gauge", itemWindow)
  gauge:SetWidth(itemWindow:GetWidth() - ICON_SIZE.DEFAULT)
  gauge:AddAnchor("BOTTOMLEFT", itemIcon, "BOTTOMRIGHT", 2, 0)
  itemWindow.minAbilityPoint = 0
  itemWindow.maxAbilityPoint = X2Ability:GetMaxActabilityPoint(itemInfo.type)
  gauge:SetMinMaxValues(itemWindow.minAbilityPoint, itemWindow.maxAbilityPoint)
  gauge:SetValue(itemInfo.point)
  itemWindow.gauge = gauge
  function itemWindow:OnEnter()
    local info = self.itemInfo
    local percent = info.point / itemWindow.maxAbilityPoint * 100
    local str = ""
    if info.modifyPoint == 0 then
      str = string.format([[
%s [%d%%]
|,%d;/|,%d;]], info.name, percent, info.point, itemWindow.maxAbilityPoint)
    else
      str = string.format([[
%s [%d%%]|r
|,%d;%s+|,%d;|r / |,%d;]], info.name, percent, info.point, FONT_COLOR_HEX.SINERGY, info.modifyPoint, itemWindow.maxAbilityPoint)
    end
    SetTooltip(str, self)
  end
  itemWindow:SetHandler("OnEnter", itemWindow.OnEnter)
  function itemWindow:OnLeave()
    HideTooltip()
  end
  itemWindow:SetHandler("OnLeave", itemWindow.OnLeave)
  function itemWindow:Update(info)
    self.itemInfo = info
    gauge:SetValue(info.point)
    self.actabilityPoint:SetText(string.format("%d", self.itemInfo.point + self.itemInfo.modifyPoint))
    if self.itemInfo.modifyPoint == 0 then
      ApplyTextColor(self.actabilityPoint, FONT_COLOR.DEFAULT)
    else
      ApplyTextColor(self.actabilityPoint, FONT_COLOR.GREEN)
    end
  end
  return itemWindow
end
function CreateLanguagePage(parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local emptyWidget = parent:CreateChildWidget("emptywidget", "language_emptyWidget", 0, true)
  emptyWidget:Show(true)
  emptyWidget:AddAnchor("TOPLEFT", parent, 0, sideMargin / 1.5)
  emptyWidget:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local actabilityInfos = X2Ability:GetAllMyActabilityInfos()
  local x = 0
  local y = 5
  local count = 1
  emptyWidget.actabilityItem = {}
  for i = 1, #actabilityInfos do
    local actAbilityType = actabilityInfos[i].type
    if X2Ability:IsLanguageActability(actAbilityType) then
      local info = X2Craft:GetActabilityGroupInfoByGroupType(actAbilityType)
      local item = CreataeLanguageItemWindow(emptyWidget, actabilityInfos[i])
      item:AddAnchor("TOPLEFT", emptyWidget, x, y)
      if info.skill_page_visible == true then
        item.itemIcon:AddTexture(info.icon_path)
      end
      x = x + item:GetWidth() + 20
      if count % 3 == 0 then
        x = 0
        y = y + 55
      end
      emptyWidget.actabilityItem[count] = item
      count = count + 1
    end
  end
  function emptyWidget:Update(actabilityId)
    for i = 1, #self.actabilityItem do
      local item = self.actabilityItem[i]
      if item.itemInfo.type == actabilityId then
        local info = X2Ability:GetMyActabilityInfo(actabilityId)
        item:Update(info)
        return
      end
    end
  end
  function emptyWidget:UpdateAll()
    local infos = X2Ability:GetAllMyActabilityInfos()
    local itemCount = #self.actabilityItem
    local count = 0
    for i = 1, #infos do
      if X2Ability:IsLanguageActability(infos[i].type) then
        count = count + 1
        if itemCount >= count then
          local item = self.actabilityItem[count]
          item:Update(infos[i])
        end
      end
    end
  end
  local events = {
    ACTABILITY_EXPERT_CHANGED = function(actabilityId)
      emptyWidget:Update(actabilityId)
    end,
    ACTABILITY_MODIFIER_UPDATE = function()
      emptyWidget:UpdateAll()
    end,
    UNIT_EQUIPMENT_CHANGED = function()
      emptyWidget:UpdateAll()
    end,
    ACTABILITY_REFRESH_ALL = function()
      local infos = X2Ability:GetAllMyActabilityInfos()
      local itemCount = #emptyWidget.actabilityItem
      local count = 0
      for i = 1, #infos do
        if X2Ability:IsLanguageActability(infos[i].type) then
          count = count + 1
          if itemCount >= count then
            local item = emptyWidget.actabilityItem[count]
            item.minAbilityPoint = X2Ability:GetMinActabilityPoint(actabilityInfos[i].type)
            item.maxAbilityPoint = X2Ability:GetMaxActabilityPoint(actabilityInfos[i].type)
            item:Update(infos[i])
          end
        end
      end
    end
  }
  emptyWidget:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(emptyWidget, events)
end
