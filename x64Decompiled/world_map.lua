function worldmap:OnEnter()
  worldmap:ResetCursor(false)
end
worldmap:SetHandler("OnEnter", worldmap.OnEnter)
function worldmap:OnLeave()
  worldmap:ResetCursor(true)
end
worldmap:SetHandler("OnLeave", worldmap.OnLeave)
function mapFrame:OnHide()
  worldmap:Show(false)
  HideMapTooltip()
  ResetPingBtn()
end
mapFrame:SetHandler("OnHide", mapFrame.OnHide)
local ToggleMap = function(isShow)
  if isShow == nil then
    isShow = not mapFrame:IsVisible()
  end
  worldmap:Show(isShow)
  mapFrame:Show(isShow)
  mapFrame.player.effect:SetStartEffect(isShow)
  mapFrame.player.effect:SetVisible(mapFrame.player:IsVisible())
  if isShow then
    SetPlayerToCenter()
    mapFrame:Raise()
  end
end
ADDON:RegisterContentTriggerFunc(UIC_WORLDMAP, ToggleMap)
mapFrame.bottomInfoFrame.delay = 0
function mapFrame:UpdateContinentConflictState()
  local zoneList = X2Map:GetZoneListByWorldId(self.bottomInfoFrame.zoneId)
  for i = 1, #zoneList do
    local zoneId = zoneList[i]
    UpdateZoneStateIcon(zoneId)
  end
end
function mapFrame:HideContinentConflictState()
  worldmap:HideAllIconDrawable()
end
function mapFrame.bottomInfoFrame:UpdateConflictZoneState()
  if self.zoneId == nil then
    return
  end
  local conflictParent = self.conflictParent
  local localParent = self.localParent
  local localBg = self.localBg
  local climateFrame = mapFrame.climateFrame
  self.delay = 0
  self.tooltipMsg = nil
  local zoneId = self.zoneId
  if self.level == WMS_CITY then
    zoneId = X2Map:GetZoneGroupOfCity(zoneId)
  end
  if zoneId == nil then
    return
  end
  local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
  self.zoneInfo = zoneInfo
  self:Show(true)
  if zoneInfo == nil or zoneInfo.isInstanceZone then
    self:Show(false)
  elseif zoneInfo.isFestivalZone then
    conflictParent:RemoveAllAnchors()
    conflictParent:AddAnchor("BOTTOMLEFT", self, 13, -15)
    conflictParent.title:SetText(GetCommonText("festival_zone"))
    ApplyZoneStateIcon(conflictParent.stateMark, zoneInfo)
    self.taxRate:Show(false)
    self.peacetax:Show(false)
    if zoneInfo.remainTime == nil then
      conflictParent.remainTime:SetText(zoneInfo.festivalName)
      conflictParent.remainTime:Show(true)
    elseif 0 < zoneInfo.remainTime then
      conflictParent.remainTime:SetText(GetRemainTimeString(zoneInfo.remainTime * 1000))
      conflictParent.remainTime:Show(true)
    else
      conflictParent.remainTime:Show(false)
    end
    conflictParent.gageBar:Show(false)
    conflictParent.lockTitle:Show(false)
    conflictParent.lockRemainTime:Show(false)
  elseif zoneInfo.isConflictZone then
    conflictParent:RemoveAllAnchors()
    conflictParent:AddAnchor("BOTTOMLEFT", self, 13, -15)
    conflictParent.title:SetText(locale.honorPointWar.getZoneStateHud(zoneInfo.conflictState))
    ApplyZoneStateIcon(conflictParent.stateMark, zoneInfo)
    self.taxRate:Show(false)
    self.peacetax:Show(false)
    local isDangerState = zoneInfo.conflictState < HPWS_BATTLE
    if not isDangerState and 0 < zoneInfo.remainTime then
      conflictParent.remainTime:SetText(GetRemainTimeString(zoneInfo.remainTime * 1000))
      conflictParent.remainTime:Show(true)
    else
      conflictParent.remainTime:Show(false)
    end
    if 0 < zoneInfo.lockTime then
      conflictParent.lockRemainTime:SetText(GetRemainTimeString(zoneInfo.lockTime * 1000))
      conflictParent.lockRemainTime:Show(true)
      conflictParent.lockTitle:Show(true)
    else
      conflictParent.lockRemainTime:Show(false)
      conflictParent.lockTitle:Show(false)
    end
    if isDangerState then
      conflictParent.gageBar:Show(true)
      for i = 1, 5 do
        conflictParent.gageBar.on[i]:SetVisible(i <= zoneInfo.conflictState + 1)
      end
    else
      conflictParent.gageBar:Show(false)
    end
  elseif zoneInfo.isSiegeZone then
    conflictParent:RemoveAllAnchors()
    conflictParent:AddAnchor("BOTTOMLEFT", self, 13, -15)
    conflictParent.title:SetText(GetCommonText("conflict_zone"))
    ApplyZoneStateIcon(conflictParent.stateMark, zoneInfo)
    local peaceTaxMoney = ""
    local peaceTaxAAPoint = ""
    local isConvertTaxItemToAAPoint = X2House:IsConvertTaxItemToAAPoint()
    if F_MONEY.currency.houseTax == CURRENCY_GOLD and isConvertTaxItemToAAPoint == false then
      peaceTaxMoney = X2Dominion:GetPeaceTaxMoney(zoneId)
    else
      peaceTaxMoney = X2Dominion:GetPeaceTaxMoney(zoneId)
      peaceTaxAAPoint = X2Dominion:GetPeaceTaxAAPoint(zoneId)
    end
    if string.len(peaceTaxMoney) == 0 and string.len(peaceTaxAAPoint) == 0 then
      self.taxRate:Show(false)
      self.peacetax:Show(false)
      conflictParent:RemoveAllAnchors()
      conflictParent:AddAnchor("BOTTOMLEFT", self, 13, 0)
    else
      self.taxRate:Show(true)
      self.taxRate.rate:SetText(string.format("%d %%", X2Dominion:GetTaxRate(zoneId)))
      self.peacetax:Show(true)
      self.peacetax:SetText(locale.territory.peaceMoney)
      local totalBgWidth = self.peacetax:GetWidth() + PEACE_TAX_TEXT_BG_ANCHOR_X * 2
      if F_MONEY.currency.houseTax ~= CURRENCY_GOLD or isConvertTaxItemToAAPoint ~= false then
        self.peacetax.peaceTaxAAPoint:SetWidth(300)
        self.peacetax.peaceTaxAAPoint:SetText(string.format("|p%d;", tonumber(peaceTaxAAPoint)))
        self.peacetax.peaceTaxAAPoint:SetWidth(self.peacetax.peaceTaxAAPoint:GetLongestLineWidth() + 5)
        totalBgWidth = totalBgWidth + PEACE_TAX_TEXT_ANCHOR_X + self.peacetax.peaceTaxAAPoint:GetWidth()
      end
      self.peacetax.peaceTaxMoney:SetWidth(300)
      self.peacetax.peaceTaxMoney:SetText(string.format("|m%d;", tonumber(peaceTaxMoney)))
      self.peacetax.peaceTaxMoney:SetWidth(self.peacetax.peaceTaxMoney:GetLongestLineWidth() + 5)
      totalBgWidth = totalBgWidth + PEACE_TAX_TEXT_ANCHOR_X + self.peacetax.peaceTaxMoney:GetWidth()
      self.peacetax.bg:SetWidth(totalBgWidth)
    end
    conflictParent.remainTime:Show(false)
    conflictParent.gageBar:Show(false)
    conflictParent.lockTitle:Show(false)
    conflictParent.lockRemainTime:Show(false)
  else
    conflictParent:RemoveAllAnchors()
    conflictParent:AddAnchor("BOTTOMLEFT", self, 13, 0)
    if zoneInfo.isNuiaProtectedZone then
      conflictParent.title:SetText(GetCommonText("nuia_protection_zone"))
    elseif zoneInfo.isHariharaProtectedZone then
      conflictParent.title:SetText(GetCommonText("harihara_protection_zone"))
    elseif zoneInfo.isPeaceZone then
      conflictParent.title:SetText(GetCommonText("non_pvp_zone"))
    else
      conflictParent.title:SetText(GetCommonText("conflict_zone"))
    end
    ApplyZoneStateIcon(conflictParent.stateMark, zoneInfo)
    self.taxRate:Show(false)
    self.peacetax:Show(false)
    conflictParent.remainTime:Show(false)
    conflictParent.gageBar:Show(false)
    conflictParent.lockTitle:Show(false)
    conflictParent.lockRemainTime:Show(false)
  end
  local posX = mapFrame:GetWidth() - WORLDMAP_VISIBLE_WIDTH - 25
  if zoneInfo.isLocalDevelopment then
    localParent:RemoveAllAnchors()
    localParent:AddAnchor("BOTTOMRIGHT", mapFrame, "BOTTOMRIGHT", -posX - 5, -54)
    climateFrame:RemoveAllAnchors()
    climateFrame:AddAnchor("BOTTOMRIGHT", localParent, "TOPRIGHT", 0, -9)
    localParent:Show(true)
    localParent.title:Show(true)
    localParent.gageBar:Show(true)
    localBg:Show(true)
    if zoneInfo.localDevelopmentName == nil then
      localParent.title:SetText(X2Locale:LocalizeUiText(DOMINION, "unknown"))
    else
      localParent.title:SetText(zoneInfo.localDevelopmentName)
    end
    for i = 1, 3 do
      localParent.gageBar.on[i]:SetVisible(i <= zoneInfo.localDevelopmentStep)
    end
    ApplyTextColor(localParent.title, FONT_COLOR.GREEN)
  else
    localParent:RemoveAllAnchors()
    climateFrame:RemoveAllAnchors()
    climateFrame:AddAnchor("BOTTOMRIGHT", mapFrame, "BOTTOMRIGHT", -posX, -45)
    localParent:Show(false)
    localParent.title:Show(false)
    localParent.gageBar:Show(false)
    localBg:Show(false)
  end
  local fontColor = GetMapZoneStateFontColor(zoneInfo)
  if fontColor ~= nil then
    ApplyTextColor(conflictParent.title, fontColor)
    ApplyTextColor(conflictParent.lockTitle, fontColor)
  end
  self.bg:SetTextureColor(GetMapZoneStateTextureColorKey(zoneInfo))
end
function mapFrame:HideClimateInfo()
  if mapFrame.climateFrame then
    mapFrame.climateFrame:Show(false)
  end
end
local GetClimateText = function(index)
  local stringTable = {
    "",
    GetCommonText("temperate_climate"),
    GetCommonText("tropical_climate"),
    GetCommonText("microthermal_climate"),
    GetCommonText("dry_climate")
  }
  return stringTable[index]
end
function mapFrame:UpdateClimateInfo()
  local climateIndex = worldmap:GetClimateInfo(self.bottomInfoFrame.zoneId)
  if climateIndex == nil or #climateIndex == 0 then
    self:HideClimateInfo()
    return
  end
  for i = 1, #self.climateFrame.icon do
    self.climateFrame.icon[i]:SetVisible(false)
  end
  self.climateFrame:Show(true)
  self.climateFrame.tip = ""
  local GetClimateCoords = function(singleClimate, index)
    local singleClimateCoords = {
      "none",
      "temperate",
      "tropical",
      "subarctic",
      "arid"
    }
    local mutipleClimateCoords = {
      "none",
      "icon_tempere",
      "icon_tropical",
      "icon_subarctique",
      "icon_arid"
    }
    if singleClimate then
      return singleClimateCoords[index]
    else
      return mutipleClimateCoords[index]
    end
  end
  local xOffset = 10
  local climateStr = ""
  for i = 1, #climateIndex do
    local coords = GetClimateCoords(#climateIndex == 1, climateIndex[i])
    if #climateIndex ~= 1 then
      if climateStr ~= "" then
        climateStr = string.format([[
%s
%s]], climateStr, GetClimateText(climateIndex[i]))
      else
        climateStr = GetClimateText(climateIndex[i])
      end
    end
    self.climateFrame.icon[i]:SetVisible(true)
    self.climateFrame.icon[i]:SetTextureInfo(coords)
    self.climateFrame.icon[i]:AddAnchor("LEFT", self.climateFrame, xOffset, 0)
    xOffset = xOffset + self.climateFrame.icon[i]:GetWidth()
  end
  if climateStr ~= "" then
    self.climateFrame.tip = string.format([[
%s
%s]], GetCommonText("multiple_climate_desc"), climateStr)
  end
  self.climateFrame:SetWidth(xOffset + 5)
end
local TaxRateOnEnter = function(self)
  SetTooltip(GetCommonText("tax_rate_tooltip"), self)
end
mapFrame.bottomInfoFrame.taxRate:SetHandler("OnEnter", TaxRateOnEnter)
local TaxRateOnLeave = function()
  HideTooltip()
end
mapFrame.bottomInfoFrame.taxRate:SetHandler("OnLeave", TaxRateOnLeave)
local PeacetaxmoneyOnEnter = function(self)
  SetTooltip(locale.map.peace_tax_tip, self)
end
mapFrame.bottomInfoFrame.peacetax:SetHandler("OnEnter", PeacetaxmoneyOnEnter)
local PeacetaxmoneyOnLeave = function()
  HideTooltip()
end
mapFrame.bottomInfoFrame.peacetax:SetHandler("OnLeave", PeacetaxmoneyOnLeave)
function mapFrame.bottomInfoFrame:HideConflictZoneState()
  self:Show(false)
end
function mapFrame.bottomInfoFrame:OnUpdate(dt)
  self.delay = self.delay + dt
  if self.delay >= 1000 then
    self:UpdateConflictZoneState()
  end
end
mapFrame.bottomInfoFrame:SetHandler("OnUpdate", mapFrame.bottomInfoFrame.OnUpdate)
if mapFrame.sextantsWnd ~= nil then
  mapFrame.sextantsWnd:SetHandler("OnUpdate", mapFrame.sextantsWnd.Update)
end
local SetMapLevelAndZoneId = function(level, id)
  if level ~= nil then
    level = level + 1
  end
  mapFrame.bottomInfoFrame.level = level or mapFrame.bottomInfoFrame.level
  mapFrame.bottomInfoFrame.zoneId = id or mapFrame.bottomInfoFrame.zoneId
end
function UpdateConflictZoneInfo()
  mapFrame.HideContinentConflictState()
  mapFrame.bottomInfoFrame.taxRate:Show(false)
  mapFrame.bottomInfoFrame.peacetax:Show(false)
  if mapFrame.bottomInfoFrame.level == WMS_WORLD then
    mapFrame.bottomInfoFrame:HideConflictZoneState()
    mapFrame:HideClimateInfo()
  elseif mapFrame.bottomInfoFrame.level == WMS_CONTINENT then
    mapFrame.bottomInfoFrame:HideConflictZoneState()
    mapFrame:UpdateContinentConflictState()
    mapFrame:HideClimateInfo()
  elseif mapFrame.bottomInfoFrame.level == WMS_ZONE then
    mapFrame.bottomInfoFrame:UpdateConflictZoneState()
    mapFrame:UpdateClimateInfo()
  elseif mapFrame.bottomInfoFrame.level == WMS_CITY then
    mapFrame.bottomInfoFrame:UpdateConflictZoneState()
    mapFrame:UpdateClimateInfo()
  end
end
local ConflictParentOnEnter = function(self)
  local tooltipTitle, tooltipMsg
  local zoneInfo = mapFrame.bottomInfoFrame.zoneInfo
  local color = GetTooltipZoneStateFontColor(zoneInfo)
  color = GetHexColorForString(Dec2Hex(color))
  if zoneInfo.isFestivalZone then
    tooltipTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "festival_period", zoneInfo.festivalName)
    tooltipMsg = GetCommonText("festival_zone_map_desc")
  elseif zoneInfo.isConflictZone then
    tooltipTitle = locale.honorPointWar.getZoneStateTooltipTitle(zoneInfo.conflictState)
    if zoneInfo.conflictState == HPWS_PEACE then
      tooltipMsg = locale.honorPointWar.statePeaceTooltip
    else
      tooltipMsg = locale.honorPointWar.stateTooltip
    end
  elseif zoneInfo.isSiegeZone then
    tooltipTitle = GetCommonText("conflict_zone_map_title")
    tooltipMsg = GetCommonText("conflict_zone_map_desc")
  elseif zoneInfo.isNuiaProtectedZone then
    tooltipTitle = GetCommonText("nuia_protection_zone")
    tooltipMsg = GetCommonText("nuia_protection_zone_map_desc")
  elseif zoneInfo.isHariharaProtectedZone then
    tooltipTitle = GetCommonText("harihara_protection_zone")
    tooltipMsg = GetCommonText("harihara_protection_zone_map_desc")
  elseif zoneInfo.isPeaceZone then
    tooltipTitle = GetCommonText("non_pvp_zone")
    tooltipMsg = GetCommonText("non_pvp_zone_map_desc")
  else
    tooltipTitle = GetCommonText("conflict_zone_map_title")
    tooltipMsg = GetCommonText("conflict_zone_map_desc")
  end
  local tooltip = string.format([[
%s%s
%s%s]], color, tooltipTitle, FONT_COLOR_HEX.SOFT_BROWN, tooltipMsg)
  SetTooltip(tooltip, self.title)
end
mapFrame.bottomInfoFrame.conflictParent:SetHandler("OnEnter", ConflictParentOnEnter)
local ConflictParentOnLeave = function()
  HideTooltip()
end
mapFrame.bottomInfoFrame.conflictParent:SetHandler("OnLeave", ConflictParentOnLeave)
local LocalParentOnEnter = function(self)
  local zoneInfo = mapFrame.bottomInfoFrame.zoneInfo
  local name
  if zoneInfo.localDevelopmentName == nil then
    name = X2Locale:LocalizeUiText(DOMINION, "unknown")
  else
    name = zoneInfo.localDevelopmentName
  end
  local tooltip = string.format([[
%s%s
%s%s]], F_COLOR.GetColor("original_dark_orange", true), GetUIText(COMMON_TEXT, "local_development_tooltip_title", name), FONT_COLOR_HEX.SOFT_BROWN, GetUIText(COMMON_TEXT, "local_development_tooltip_body"))
  SetTooltip(tooltip, self.title)
end
mapFrame.bottomInfoFrame.localParent:SetHandler("OnEnter", LocalParentOnEnter)
local LocalParentOnLeave = function()
  HideTooltip()
end
mapFrame.bottomInfoFrame.localParent:SetHandler("OnLeave", LocalParentOnLeave)
function mapFrame.focusBtn:OnClick()
  SetPlayerToCenter()
  if mapFrame.player:IsVisible() then
    mapFrame.player.effect:SetStartEffect(true)
  end
end
mapFrame.focusBtn:SetHandler("OnClick", mapFrame.focusBtn.OnClick)
local UpdateRouteImage = function()
  local isShow = X2Map:IsCheckedMapFilter(MST_TRADE_ROUTE)
  if isShow == false then
    return
  end
  local routeImg, created = worldmap:GetRouteDrawable(mapFrame.bottomInfoFrame.level, mapFrame.bottomInfoFrame.zoneId)
  if routeImg and created then
    worldmap:UpdateRouteMap(routeImg)
  end
end
function mapFrame.routeBtn:OnClick()
  local routeImg = worldmap:GetRouteDrawable(mapFrame.bottomInfoFrame.level, mapFrame.bottomInfoFrame.zoneId)
  if routeImg == nil then
    UIParent:Warning(string.format("can't find map data.. invalid values.. (%d, %d)", mapFrame.bottomInfoFrame.level, mapFrame.bottomInfoFrame.zoneId))
    return
  end
  local isShow = X2Map:IsCheckedMapFilter(MST_TRADE_ROUTE)
  SetBGPushed(mapFrame.routeBtn, not isShow)
  X2Map:SetMapFilter(MST_TRADE_ROUTE, not isShow)
  worldmap:UpdateRouteMap(routeImg)
end
mapFrame.routeBtn:SetHandler("OnClick", mapFrame.routeBtn.OnClick)
local tooltipController = worldmap:GetTooltipController()
tooltipController:SetHandler("OnLeave", HideMapTooltip)
tooltipController:SetHandler("OnHide", HideMapTooltip)
local worldMapEvents = {
  SHOW_WORLDMAP_TOOLTIP = function(tooltipInfo, tooltipCount)
    ShowMapTooltip(tooltipInfo, tooltipCount, tooltipController, M_TOOLTIP_OFFSET_X, M_TOOLTIP_OFFSET_Y, M_TOOLTIP_OFFSET_REVERSE_X, M_TOOLTIP_OFFSET_REVERSE_Y)
  end,
  HIDE_WORLDMAP_TOOLTIP = function()
    HideMapTooltip()
  end,
  SET_EFFECT_ICON_VISIBLE = function(isShow, arg1)
    if arg1 == mapFrame.player then
      mapFrame.player.effect:SetVisible(isShow)
    elseif arg1 == mapFrame.portal then
      mapFrame.portal.effect:SetVisible(isShow)
    end
  end,
  UPDATE_ZONE_INFO = function()
    worldmap:UpdateZoneInfo()
    SetPlayerToCenter()
  end,
  UPDATE_NPC_INFO = function()
    worldmap:UpdateNpcInfo()
  end,
  UPDATE_DOODAD_INFO = function()
    worldmap:UpdateDoodadInfo()
  end,
  UPDATE_GIVEN_QUEST_STATIC_INFO = function()
    worldmap:UpdateGivenQuestStaticInfo()
  end,
  UPDATE_HOUSING_INFO = function()
    worldmap:UpdateHousingInfo()
  end,
  UPDATE_SHIP_TELESCOPE_INFO = function()
    worldmap:UpdateShipTelescopeInfo()
  end,
  UPDATE_TRANSFER_TELESCOPE_INFO = function()
    worldmap:UpdateTransferTelescopeInfo()
  end,
  UPDATE_BOSS_TELESCOPE_INFO = function()
    worldmap:UpdateBossTelescopeInfo()
  end,
  UPDATE_CARRYING_BACKPACK_SLAVE_INFO = function()
    worldmap:UpdateCarryingBackpackSlaveInfo()
  end,
  UPDATE_FISH_SCHOOL_INFO = function()
    worldmap:UpdateFishSchoolInfo()
  end,
  UPDATE_CORPSE_INFO = function()
    worldmap:UpdateCorpseInfo()
  end,
  UPDATE_MY_SLAVE_POS_INFO = function()
    worldmap:UpdateMySlaveInfo()
  end,
  CLEAR_NPC_INFO = function()
    worldmap:ClearNpcInfo()
  end,
  CLEAR_DOODAD_INFO = function()
    worldmap:ClearDoodadInfo()
  end,
  CLEAR_GIVEN_QUEST_STATIC_INFO = function()
    worldmap:ClearGivenQuestStaticInfo()
  end,
  CLEAR_HOUSING_INFO = function()
    worldmap:ClearHousingInfo()
  end,
  CLEAR_SHIP_TELESCOPE_INFO = function()
    worldmap:ClearShipTelescopeInfo()
  end,
  CLEAR_TRANSFER_TELESCOPE_INFO = function()
    worldmap:ClearTransferTelescopeInfo()
  end,
  CLEAR_BOSS_TELESCOPE_INFO = function()
    worldmap:ClearBossTelescopeInfo()
  end,
  CLEAR_CARRYING_BACKPACK_SLAVE_INFO = function()
    worldmap:ClearCarryingBackpackSlaveInfo()
  end,
  CLEAR_FISH_SCHOOL_INFO = function()
    worldmap:ClearFishSchoolInfo()
  end,
  CLEAR_CORPSE_INFO = function()
    worldmap:ClearCorpseInfo()
  end,
  CLEAR_MY_SLAVE_POS_INFO = function()
    worldmap:ClearMySlaveInfo()
  end,
  UPDATE_PING_INFO = function()
    worldmap:UpdatePingInfo()
    EnablePingBtn()
  end,
  ADD_GIVEN_QUEST_INFO = function(arg1, arg2)
    worldmap:AddGivenQuestInfo(arg1, arg2)
  end,
  REMOVE_GIVEN_QUEST_INFO = function(arg1, arg2)
    worldmap:RemoveGivenQuestInfo(arg1, arg2)
  end,
  UPDATE_COMPLETED_QUEST_INFO = function()
    worldmap:UpdateCompletedQuestInfo()
  end,
  CLEAR_COMPLETED_QUEST_INFO = function()
    worldmap:ClearCompletedQuestInfo()
  end,
  ADD_NOTIFY_QUEST_INFO = function(arg)
    worldmap:AddNotifyQuestInfo(arg)
  end,
  REMOVE_NOTIFY_QUEST_INFO = function(arg)
    worldmap:RemoveNotifyQuestInfo(arg)
  end,
  CLEAR_NOTIFY_QUEST_INFO = function()
    worldmap:ClearNotifyQuestInfo()
  end,
  UPDATE_DOMINION_INFO = function()
    worldmap:UpdateDominionInfo()
  end,
  SET_DEFAULT_EXPAND_RATIO = function(isSameZone)
    worldmap.isSameZone = isSameZone
    if isSameZone then
      if DEFAULT_EXPANSION_LEVEL == nil then
        DEFAULT_EXPANSION_LEVEL = X2:GetWorldmapDefaultExpansionLevel() or 1
      end
      SetExpandLevel(DEFAULT_EXPANSION_LEVEL)
    else
      SetExpandLevel(ZONE_EXPANSION_LEVEL)
    end
  end,
  UI_RELOADED = function()
    worldmap:ReloadAllInfo()
    EnablePingBtn()
  end,
  LEFT_LOADING = function()
    worldmap:ReloadAllInfo()
    SetPlayerToCenter()
  end,
  ENTERED_WORLD = function()
    worldmap:ReloadAllInfo()
  end,
  ENTERED_LOADING = function()
    worldmap:ClearAllInfo()
  end,
  UPDATE_TELESCOPE_AREA = function()
    worldmap:UpdateTelescopeArea()
  end,
  UPDATE_TRANSFER_TELESCOPE_AREA = function()
    worldmap:UpdateTransferTelescopeArea()
  end,
  UPDATE_BOSS_TELESCOPE_AREA = function()
    worldmap:UpdateBossTelescopeArea()
  end,
  UPDATE_FISH_SCHOOL_AREA = function()
    worldmap:UpdateFishSchoolArea()
  end,
  REMOVE_SHIP_TELESCOPE_INFO = function(arg)
    worldmap:RemoveShipTelescopeInfo(arg)
  end,
  REMOVE_TRANSFER_TELESCOPE_INFO = function(arg)
    worldmap:RemoveTransferTelescopeInfo(arg)
  end,
  REMOVE_BOSS_TELESCOPE_INFO = function(arg)
    worldmap:RemoveBossTelescopeInfo(arg)
  end,
  REMOVE_CARRYING_BACKPACK_SLAVE_INFO = function(arg)
    worldmap:RemoveCarryingBackpackSlaveInfo(arg)
  end,
  REMOVE_FISH_SCHOOL_INFO = function(arg)
    worldmap:RemoveFishSchoolInfo(arg)
  end,
  UPDATE_ZONE_LEVEL_INFO = function(level, id)
    SetMapLevelAndZoneId(level, id)
    UpdateRouteImage()
    UpdateConflictZoneInfo()
  end,
  SHOW_WORLDMAP_LOCATION = function(zoneId, x, y, z)
    worldmap:ToggleMapWithLocation(zoneId, x, y, z)
  end,
  HPW_ZONE_STATE_CHANGE = function()
    worldmap:UpdateZoneStateDrawable()
    UpdateConflictZoneInfo()
  end,
  RESIDENT_ZONE_STATE_CHANGE = function()
    worldmap:UpdateZoneStateDrawable()
    UpdateConflictZoneInfo()
  end,
  EXPLORED_REGION_UPDATED = function()
    worldmap:ExploredRegionUpdated()
  end,
  UPDATE_ROUTE_MAP = function()
    worldmap:UpdateRouteMap()
  end,
  ZONEGROUP_STATE_START = function()
    worldmap:UpdateZoneGroupStateInfo()
  end,
  ZONEGROUP_STATE_END = function()
    worldmap:UpdateZoneGroupStateInfo()
  end,
  ZONEGROUP_STATE_BRIEFING = function()
    worldmap:UpdateZoneGroupStateInfo()
  end,
  UPDATE_MONITOR_NPC = function()
    worldmap:UpdateMonitorNpcInfo()
  end,
  NATION_KICK = function()
    worldmap:UpdateCurZoneGroupNpcInfo()
  end,
  NATION_INVITE = function()
    worldmap:UpdateCurZoneGroupNpcInfo()
  end,
  INSTANT_GAME_END = function()
    worldmap:UpdateTerritoryInfo()
  end,
  INSTANT_GAME_RETIRE = function()
    roadmap:UpdateTerritoryInfo()
  end,
  UPDATE_INSTANT_GAME_SCORES = function()
    worldmap:UpdateTerritoryInfo()
  end,
  MAP_EVENT_CHANGED = function()
    worldmap:UpdateEventMap()
  end
}
worldmap:SetHandler("OnEvent", function(this, event, ...)
  worldMapEvents[event](...)
end)
RegistUIEvent(worldmap, worldMapEvents)
function worldmap:ToggleMapWithLocation(zone_id, x, y, z)
  ADDON:ShowContent(UIC_WORLDMAP, true)
  worldmap:ShowPortal(zone_id, x, y, z)
  mapFrame.portal:SetStartEffect(true)
  mapFrame.portal.effect:SetStartEffect(true)
end
function worldmap:ToggleMapWithPortal(zone_id, x, y, z)
  ADDON:ShowContent(UIC_WORLDMAP, true)
  worldmap:ShowPortal(zone_id, x, y, z)
  mapFrame.portal:SetStartEffect(true)
  mapFrame.portal.effect:SetStartEffect(true)
end
function worldmap:ToggleMapWithCommonFarm(farmGroupType, farmType, x, y)
  ADDON:ShowContent(UIC_WORLDMAP, true)
  local coords = {
    GetTextureInfo(TEXTURE_PATH.MAP_ICON, X2Map:GetMapIconCoord(MST_MY_CROPS)):GetCoords()
  }
  local inset = 0
  if farmGroupType == 1 then
    inset = M_ICON_EXTENT * 2
  elseif farmGroupType == 2 then
    inset = M_ICON_EXTENT * 1
  end
  mapFrame.commonFarm:SetCoords(coords[1], coords[2] + inset, coords[3], coords[4])
  worldmap:ShowCommonFarm(farmGroupType, farmType, x, y)
  mapFrame.commonFarm:SetStartEffect(true)
end
function worldmap:OnWheelUp(arg)
  local seleted = GetExpandLevel()
  seleted = math.min(seleted + 1, #mapFrame.expandBtn)
  SetExpandLevel(seleted, worldmap.isSameZone)
end
worldmap:SetHandler("OnWheelUp", worldmap.OnWheelUp)
function worldmap:OnWheelDown(arg)
  local seleted = GetExpandLevel()
  seleted = math.max(seleted - 1, 1)
  SetExpandLevel(seleted, worldmap.isSameZone)
end
worldmap:SetHandler("OnWheelDown", worldmap.OnWheelDown)
function ToggleMapWithQuest(qType)
  local decalIndex = GetNotifierDecal(qType)
  ADDON:ShowContent(UIC_WORLDMAP, true)
  worldmap:ShowQuest(qType, decalIndex or -1, decalIndex ~= nil)
end
local tempMainQuestReadyCoord = {
  216,
  24,
  24,
  24
}
local tempNormalQuestReadyCoord = {
  216,
  72,
  24,
  24
}
local tempNotifyColor = {
  255,
  255,
  255,
  AREA_COLOR_ALPHA
}
worldmap:SetTempNotifyCoord(true, tempMainQuestReadyCoord)
worldmap:SetTempNotifyCoord(false, tempNormalQuestReadyCoord)
worldmap:SetTempNotifyColor(tempNotifyColor)
function TestZone()
  X2Map:GetZoneStateInfoByZoneId(80)
end
