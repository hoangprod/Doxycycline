local zoneNameInformer = GetIndicators().zoneNameInformer
local zoneStateInformer = GetIndicators().zoneStateInformer
local warStateWnd = zoneStateInformer.warStateWindow
local warStateGageBar = warStateWnd.stateGageBar
local honorPointWarRemainTime = warStateWnd.honorPointWarRemainTime
local honorPointWarTitle = warStateWnd.honorPointWarTitle
local sextantWindow = GetIndicators().sextantWindow
local function ResizeHonorPointWindow()
  honorPointWarTitle:RemoveAllAnchors()
  local targetWidget = warStateGageBar:IsVisible() and warStateGageBar or honorPointWarRemainTime:IsVisible() and honorPointWarRemainTime or warStateWnd
  local middleOffset = 0
  local rightOffset = 0
  local targetAnchor = ""
  if targetWidget == warStateGageBar then
    rightOffset = 6
    middleOffset = 9
    targetAnchor = "LEFT"
  elseif targetWidget == honorPointWarRemainTime then
    rightOffset = 4
    middleOffset = 13
    targetAnchor = "LEFT"
  else
    middleOffset = 4
    targetAnchor = "RIGHT"
  end
  honorPointWarTitle:AddAnchor("RIGHT", targetWidget, targetAnchor, -middleOffset, 0)
  local leftOffset = 24
  if targetWidget == warStateWnd then
    local fixedWidth = honorPointWarTitle:GetWidth() + leftOffset + middleOffset
    warStateWnd:SetWidth(fixedWidth)
  else
    local fixedWidth = honorPointWarTitle:GetWidth() + targetWidget:GetWidth() + leftOffset + middleOffset + rightOffset
    warStateWnd:SetWidth(fixedWidth)
  end
end
local function HideHudZoneInfo()
  warStateWnd:Show(false)
end
local function UpdateHudZoneInfo(zoneInfo)
  warStateWnd.zoneInfo = zoneInfo
  warStateWnd.strRemainTime = ""
  warStateWnd.remainTime = 0
  local fontColor = GetHudZoneStateFontColor(zoneInfo)
  if fontColor ~= nil then
    ApplyTextColor(honorPointWarTitle, fontColor)
    ApplyTextColor(honorPointWarRemainTime, fontColor)
  end
  warStateWnd.bg:SetTextureColor(GetZoneStateTextureColorKey(zoneInfo))
  if zoneInfo == nil then
    return
  elseif zoneInfo.isInstanceZone then
    HideHudZoneInfo()
    return
  elseif zoneInfo.isFestivalZone then
    warStateWnd:Show(true)
    warStateGageBar:Show(false)
    honorPointWarRemainTime:Show(false)
    honorPointWarTitle:SetText(GetCommonText("festival_zone"))
  elseif zoneInfo.isConflictZone then
    warStateWnd:Show(true)
    local isDangerState = zoneInfo.conflictState < HPWS_BATTLE
    if isDangerState then
      warStateGageBar:Show(true)
      for i = 1, 5 do
        warStateGageBar.gage[i]:SetVisible(i <= zoneInfo.conflictState + 1)
      end
    else
      warStateGageBar:Show(false)
    end
    if zoneInfo.remainTime > 0 then
      honorPointWarRemainTime:SetText(GetRemainTimeString(zoneInfo.remainTime * 1000))
      warStateWnd.remainTime = zoneInfo.remainTime * 1000
      honorPointWarRemainTime:Show(true)
    else
      honorPointWarRemainTime:Show(false)
    end
    honorPointWarTitle:SetText(locale.honorPointWar.getZoneStateHud(zoneInfo.conflictState))
  elseif zoneInfo.isSiegeZone then
    warStateWnd:Show(true)
    warStateGageBar:Show(false)
    honorPointWarRemainTime:Show(false)
    honorPointWarTitle:SetText(GetCommonText("conflict_zone"))
  else
    warStateWnd:Show(true)
    warStateGageBar:Show(false)
    honorPointWarRemainTime:Show(false)
    local titleText = ""
    if zoneInfo.isNuiaProtectedZone then
      titleText = GetCommonText("nuia_protection_zone")
    elseif zoneInfo.isHariharaProtectedZone then
      titleText = GetCommonText("harihara_protection_zone")
    elseif zoneInfo.isPeaceZone then
      titleText = GetCommonText("non_pvp_zone")
    else
      titleText = GetCommonText("conflict_zone")
    end
    honorPointWarTitle:SetText(titleText)
  end
  ResizeHonorPointWindow()
end
function warStateWnd:OnToggle()
  RunIndicatorStackRule()
end
warStateWnd:SetHandler("OnShow", warStateWnd.OnToggle)
warStateWnd:SetHandler("OnHide", warStateWnd.OnToggle)
local function UpdateHonorPointWarRemainTime(dt)
  if warStateWnd.zoneInfo.conflictState < HPWS_BATTLE then
    return
  end
  if warStateWnd.remainTime > 0 then
    local strTime = GetRemainTimeString(warStateWnd.remainTime)
    warStateWnd.remainTime = warStateWnd.remainTime - dt
    if warStateWnd.strRemainTime == strTime then
      return
    end
    warStateWnd.strRemainTime = strTime
    honorPointWarRemainTime:SetText(warStateWnd.strRemainTime)
  else
    warStateWnd.strRemainTime = ""
    honorPointWarRemainTime:SetText(warStateWnd.strRemainTime)
  end
end
function zoneStateInformer:OnUpdate(dt)
  local zoneText = X2World:GetZoneText()
  local subzone = X2World:GetSubZoneText()
  if zoneText == nil then
    zoneText = locale.clock.unknown_region
  end
  if warStateWnd:IsVisible() then
    if subzone ~= nil then
      zoneNameInformer:SetText(subzone)
    elseif warStateWnd.zoneInfo.zoneName == nil then
      zoneNameInformer:SetText(zoneText)
    else
      zoneNameInformer:SetText(warStateWnd.zoneInfo.zoneName)
    end
  else
    local str = ""
    if subzone == nil then
      str = zoneText
    else
      str = subzone
    end
    if X2:GetInstanceIndex() ~= nil then
      str = string.format("%s -%d", str, X2:GetInstanceIndex())
    end
    zoneNameInformer:SetText(str)
  end
  if warStateWnd:IsVisible() then
    UpdateHonorPointWarRemainTime(dt)
  end
end
zoneStateInformer:SetHandler("OnUpdate", zoneStateInformer.OnUpdate)
function warStateWnd:OnEnter()
  local zoneInfo = warStateWnd.zoneInfo
  local color = GetTooltipZoneStateFontColor(zoneInfo)
  local tooltipTitle, tooltipMsg
  if zoneInfo.isFestivalZone then
    tooltipTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "festival_period", zoneInfo.festivalName)
    tooltipMsg = GetCommonText("festival_zone_map_desc")
  elseif zoneInfo.isConflictZone then
    tooltipMsg = locale.honorPointWar.stateTooltip
    if zoneInfo.conflictState < HPWS_BATTLE then
      local strState = locale.honorPointWar.getZoneState(zoneInfo.conflictState)
      tooltipTitle = locale.honorPointWar.stateDangerousTooltipTitle(strState)
    else
      tooltipTitle = locale.honorPointWar.getZoneStateTooltipTitle(zoneInfo.conflictState)
    end
    if zoneInfo.conflictState == HPWS_PEACE then
      tooltipMsg = locale.honorPointWar.statePeaceTooltip
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
%s%s]], GetHexColorForString(Dec2Hex(color)), tooltipTitle, FONT_COLOR_HEX.SOFT_BROWN, tooltipMsg)
  SetTooltip(tooltip, self, false)
end
warStateWnd:SetHandler("OnEnter", warStateWnd.OnEnter)
function warStateWnd:OnLeave()
  HideTooltip()
end
warStateWnd:SetHandler("OnLeave", warStateWnd.OnLeave)
local function InitHudZoneInfo()
  local zoneInfo = X2Map:GetZoneStateInfoByZoneId(0)
  if zoneInfo == nil then
    HideHudZoneInfo()
  elseif not zoneInfo.isCurrentZone then
    return
  end
  UpdateHudZoneInfo(zoneInfo)
end
local zoneStateInformerEvents = {
  HPW_ZONE_STATE_CHANGE = function(zoneId)
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo == nil then
      HideHudZoneInfo()
    elseif not zoneInfo.isCurrentZone then
      return
    end
    UpdateHudZoneInfo(zoneInfo)
  end,
  ENTER_ANOTHER_ZONEGROUP = function(zoneId)
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo == nil then
      HideHudZoneInfo()
    elseif not zoneInfo.isCurrentZone then
      return
    end
    UpdateHudZoneInfo(zoneInfo)
  end,
  LEFT_LOADING = function()
    InitHudZoneInfo()
  end
}
zoneStateInformer:SetHandler("OnEvent", function(this, event, ...)
  zoneStateInformerEvents[event](...)
end)
RegistUIEvent(zoneStateInformer, zoneStateInformerEvents)
InitHudZoneInfo()
