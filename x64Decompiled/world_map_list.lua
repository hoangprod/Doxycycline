local FILE_PATH = "Game/ui/map/image_map.tga"
worldmap:InitMapData(WORLDMAP_VISIBLE_WIDTH, WORLDMAP_VISIBLE_HEIGHT, FILE_PATH, BUTTON_TEXTURE_PATH.MAP)
local textureAlpha = 0.4
local textureInfo = F_TEXTURE.GetTextureInfo(BUTTON_TEXTURE_PATH.MAP, "area_bg")
local colors = textureInfo.colors
local stateColor = colors.danger_red_65
worldmap:SetTroubleZoneColor(HPWS_TROUBLE_0, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
worldmap:SetTroubleZoneColor(HPWS_TROUBLE_1, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
worldmap:SetTroubleZoneColor(HPWS_TROUBLE_2, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
worldmap:SetTroubleZoneColor(HPWS_TROUBLE_3, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
worldmap:SetTroubleZoneColor(HPWS_TROUBLE_4, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
worldmap:SetTroubleZoneColor(HPWS_BATTLE, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
stateColor = colors.war_red_65
worldmap:SetTroubleZoneColor(HPWS_WAR, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
stateColor = colors.peace_blue_65
worldmap:SetTroubleZoneColor(HPWS_PEACE, stateColor[1], stateColor[2], stateColor[3], textureAlpha)
stateColor = colors.festival_green_65
worldmap:SetFestivalZoneColor(stateColor[1], stateColor[2], stateColor[3], textureAlpha)
function ApplyZoneStateIcon(icon, zoneInfo)
  if zoneInfo.isFestivalZone then
    icon:SetCoords(128, 551, 25, 21)
    icon:SetVisible(true)
  elseif zoneInfo.isConflictZone then
    if zoneInfo.conflictState < HPWS_BATTLE then
      icon:SetVisible(false)
    elseif zoneInfo.conflictState == HPWS_BATTLE then
      icon:SetCoords(151, 573, 22, 22)
      icon:SetVisible(true)
    elseif zoneInfo.conflictState == HPWS_WAR then
      icon:SetCoords(128, 573, 22, 22)
      icon:SetVisible(true)
    elseif zoneInfo.conflictState == HPWS_PEACE then
      icon:SetCoords(174, 573, 22, 22)
      icon:SetVisible(true)
    end
  elseif zoneInfo.isSiegeZone then
    icon:SetVisible(false)
  elseif zoneInfo.isPeaceZone then
    icon:SetCoords(174, 573, 22, 22)
    icon:SetVisible(true)
  else
    icon:SetVisible(false)
  end
end
function UpdateZoneStateIcon(zoneId)
  local stateIcon = worldmap:GetIconDrawable(WMS_ZONE, zoneId)
  if stateIcon ~= nil then
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo.isFestivalZone or zoneInfo.isConflictZone then
      ApplyZoneStateIcon(stateIcon, zoneInfo)
    else
      stateIcon:SetVisible(false)
    end
  end
end
