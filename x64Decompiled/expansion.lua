DEFAULT_EXPANSION_LEVEL = nil
ZONE_EXPANSION_LEVEL = 1
local expandLevel = 0
local anchorX, anchorY
local EXPAND_RATIO = {
  1,
  1.5,
  2
}
local function SetExpandMapAnchor(x, y)
  local frameWidth, frameHeight = mapWindow:GetExtent()
  local mapWidth, mapHeight = worldmap:GetExtent()
  x = math.min(math.max(x, 0), mapWidth - frameWidth)
  y = math.min(math.max(y, 0), mapHeight - frameHeight)
  mapWindow:ChangeChildAnchorByScrollValue("horz", x)
  mapWindow:ChangeChildAnchorByScrollValue("vert", y)
  anchorX = x
  anchorY = y
end
function SetPlayerToCenter()
  local frameWidth, frameHeight = mapWindow:GetExtent()
  local mapWidth, mapHeight = worldmap:GetExtent()
  local pX, pY = worldmap:GetPlayerViewPos()
  if pX < 0 or mapWidth < pX or pY < 0 or mapHeight < pY then
    pX = (mapWidth - frameWidth) / 2
    pY = (mapHeight - frameHeight) / 2
  else
    if pX < frameWidth / 2 then
      pX = 0
    elseif pX > mapWidth - frameWidth / 2 then
      pX = mapWidth - frameWidth
    else
      pX = pX - frameWidth / 2
    end
    if pY < frameHeight / 2 then
      pY = 0
    elseif pY > mapHeight - frameHeight / 2 then
      pY = mapHeight - frameHeight
    else
      pY = pY - frameHeight / 2
    end
  end
  SetExpandMapAnchor(pX, pY)
end
local ChangeExpaneBtnsStyle = function(selected)
  for i = 1, #mapFrame.expandBtn do
    local button = mapFrame.expandBtn[i]
    if i == selected then
      ChangeButtonSkin(button, BUTTON_CONTENTS.MAP_SCALE_SELECTED[i])
    else
      ChangeButtonSkin(button, BUTTON_CONTENTS.MAP_SCALE[i])
    end
  end
end
function SetExpandLevel(value, setDefault)
  if value == nil then
    value = ZONE_EXPANSION_LEVEL
  end
  if value ~= expandLevel then
    expandLevel = value
    ChangeExpaneBtnsStyle(expandLevel)
    worldmap:SetExtent(WORLDMAP_VISIBLE_WIDTH * EXPAND_RATIO[expandLevel], WORLDMAP_VISIBLE_HEIGHT * EXPAND_RATIO[expandLevel])
    worldmap:SetExpandRatio(EXPAND_RATIO[expandLevel])
    SetPlayerToCenter()
  end
  if setDefault ~= nil and setDefault == true then
    DEFAULT_EXPANSION_LEVEL = value
    X2:SetWorldmapDefaultExpansionLevel(value)
  end
end
function GetExpandLevel()
  return expandLevel
end
local onMove = false
local lastX, lastY
local function StartMoving()
  onMove = true
  X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 14, 14)
  lastX, lastY = X2Input:GetMousePos()
  mapWindow:SetHandler("OnUpdate", mapWindow.OnUpdate)
end
local function StopMoving()
  X2Cursor:ClearCursor()
  onMove = false
  mapWindow:ReleaseHandler("OnUpdate")
end
function mapWindow:OnUpdate()
  local curX, curY = X2Input:GetMousePos()
  anchorX = anchorX + lastX - curX
  anchorY = anchorY + lastY - curY
  SetExpandMapAnchor(anchorX, anchorY)
  lastX = curX
  lastY = curY
end
local function OnDragStart()
  if expandLevel ~= 1 and not WORLDMAP_PING_CLICKED then
    StartMoving()
  end
  return true
end
mapWindow.worldmap:SetHandler("OnDragStart", OnDragStart)
local function OnDragStop()
  if expandLevel ~= 1 and not WORLDMAP_PING_CLICKED then
    StopMoving()
  end
  return true
end
mapWindow.worldmap:SetHandler("OnDragStop", OnDragStop)
function mapWindow:OnLeave()
  if onMove then
    StopMoving()
  end
end
mapWindow:SetHandler("OnLeave", mapWindow.OnLeave)
