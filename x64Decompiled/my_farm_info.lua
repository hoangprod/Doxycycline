local MakeLeftTimeString = function(leftGrowthTime, leftProtectTime, growUp)
  local leftGrowthTimeStr = ""
  if leftGrowthTime > 0 and not growUp then
    leftGrowthTimeStr = MakeTimeString(leftGrowthTime)
  else
    leftGrowthTimeStr = FONT_COLOR_HEX.BLUE .. locale.commonFarm.growUp
  end
  if leftProtectTime > 0 then
    leftProtectTimeStr = MakeTimeString(leftProtectTime)
  else
    leftProtectTimeStr = FONT_COLOR_HEX.RED .. locale.commonFarm.endanger
  end
  return leftGrowthTimeStr .. " / " .. leftProtectTimeStr
end
function CreateMyFarmInfo()
  local w = SetViewOfMyFarmInfo()
  w.infos = {}
  function w:UpdateBaseInfo()
    local farmGroups = X2:GetFarmGroups()
    for i = 1, #farmGroups do
      local farmType = farmGroups[i].type
      self.infos[farmType] = X2:GetRuntimeCommonFarmDoodadsInfo(farmType)
    end
  end
  function w:CleanUpList()
    local listCtrl = self.tab.listCtrl
    for i = 1, #listCtrl.items do
      listCtrl:ClearSelection()
      local itemIcon = listCtrl.items[i].subItems[1].itemButton
      local itemName = listCtrl.items[i].subItems[1].itemNameLabel
      local leftTime = listCtrl.items[i].subItems[2].textBox
      local location = listCtrl.items[i].subItems[3]
      local mapBtn = listCtrl.items[i].subItems[4].mapBtn
      local bg = listCtrl.items[i].bg
      itemIcon:Init()
      itemIcon:Show(false)
      itemName:SetText("")
      leftTime:SetText("")
      commonFarmLocale:ResetLocationColumn(location)
      mapBtn:Show(false)
      bg:SetVisible(false)
    end
  end
  function w:RefreshCommonFarmList(farmType)
    self:UpdateBaseInfo()
    local infos = self.infos[farmType]
    if infos == nil then
      self:CleanUpList()
      return
    end
    local listCtrl = self.tab.listCtrl
    for i = 1, #listCtrl.items do
      listCtrl:ClearSelection()
      local itemIcon = listCtrl.items[i].subItems[1].itemButton
      local itemName = listCtrl.items[i].subItems[1].itemNameLabel
      local leftTime = listCtrl.items[i].subItems[2].textBox
      local location = listCtrl.items[i].subItems[3]
      local mapBtn = listCtrl.items[i].subItems[4].mapBtn
      local bg = listCtrl.items[i].bg
      bg:SetVisible(false)
      if infos[i] == nil then
        itemIcon:Init()
        itemIcon:Show(false)
        itemName:SetText("")
        leftTime:SetText("")
        commonFarmLocale:ResetLocationColumn(location)
        mapBtn:Show(false)
        itemIcon.itemType = 0
      else
        do
          local info = infos[i]
          itemIcon:SetItemIcon(info.itemType, 1)
          itemIcon:Show(true)
          itemName:SetText(info.name)
          leftTime:SetText(MakeLeftTimeString(info.leftGrowthTime, info.leftProtectTime, info.growUp))
          commonFarmLocale:FillLocationColumn(location, info.location)
          if itemIcon.itemType ~= info.itemType then
            local function OnEnter(self)
              SetTooltip(info.name, self)
            end
            itemIcon:SetHandler("OnEnter", OnEnter)
            itemIcon.itemType = info.itemType
          end
          if 0 >= info.leftGrowthTime or info.growUp then
            bg:SetTextureColor("blue")
            bg:SetVisible(true)
          end
          if 0 >= info.leftProtectTime then
            bg:SetTextureColor("red")
            bg:SetVisible(true)
          end
          mapBtn:Show(true)
          mapBtn:SetDoodadInfo(farmType, info.farmType, info.vPosX, info.vPosY)
        end
      end
    end
  end
  function w:RefreshCommonFarmStatus()
    local selected = self.tab:GetSelectedTab()
    local farmType = self.farmTypes[selected]
    local name, limit, _ = X2:GetFarmGorupInfo(farmType)
    local count = X2:GetRuntimeCommonFarmDoodadCount(farmType)
    local perFarmStatus = string.format("%d/%d", count, limit)
    self.commonFarmStatus:SetText(perFarmStatus)
  end
  function w.tab:OnTabChanged(selected)
    w:RefreshCommonFarmStatus()
    ReAnhorTabLine(self, selected)
  end
  w.tab:SetHandler("OnTabChanged", w.tab.OnTabChanged)
  function w:ShowProc()
    X2:RequestRuntimeCommonFarmDoodadInfo()
  end
  function w:OnUpdate(dt)
    local selected = self.tab:GetSelectedTab()
    local farmType = self.farmTypes[selected]
    self:RefreshCommonFarmList(farmType)
  end
  w:SetHandler("OnUpdate", w.OnUpdate)
  return w
end
local myFarmInfoWindow = CreateMyFarmInfo()
myFarmInfoWindow:AddAnchor("CENTER", "UIParent", 0, 0)
myFarmInfoWindow:SetCloseOnEscape(true)
myFarmInfoWindow:Show(false)
function ToggleCommonFarm(isShow)
  if isShow == nil then
    isShow = not myFarmInfoWindow:IsVisible()
  end
  myFarmInfoWindow:Show(isShow)
end
ADDON:RegisterContentTriggerFunc(UIC_MY_FARM_INFO, ToggleCommonFarm)
local farmEvents = {
  COMMON_FARM_UPDATED = function()
    myFarmInfoWindow:RefreshCommonFarmStatus()
    myFarmInfoWindow:Show(true)
  end
}
myFarmInfoWindow:SetHandler("OnEvent", function(this, event, ...)
  farmEvents[event](...)
end)
RegistUIEvent(myFarmInfoWindow, farmEvents)
