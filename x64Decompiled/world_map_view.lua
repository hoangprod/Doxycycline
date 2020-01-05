mapFrame = CreateEmptyWindow("mapFrame", "UIParent")
mapFrame:SetExtent(1170, 643)
mapFrame:AddAnchor("CENTER", "UIParent", 0, 0)
mapFrame:Show(false)
mapFrame:SetSounds("world_map")
mapFrame:SetCloseOnEscape(true)
mapFrame:EnableUIAnimation()
local bg = mapFrame:CreateDrawable("ui/map/frame_map.dds", "world_map_bg", "background")
bg:AddAnchor("TOPLEFT", mapFrame, 0, 0)
bg:AddAnchor("BOTTOMRIGHT", mapFrame, 0, 0)
bg:SetSnap(false)
local titleBar = CreateTitleBar(mapFrame:GetId() .. ".titleBar", mapFrame)
titleBar:SetTitleText(locale.map.title)
titleBar:SetTitleInset(0, 2, 0, 0)
titleBar.titleStyle:SetColor(0.23, 0.12, 0, 1)
titleBar.titleStyle:SetShadow(false)
titleBar.titleStyle:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
titleBar.closeButton:AddAnchor("TOPRIGHT", mapFrame, 0, 5)
local guide = W_ICON.CreateGuideIconWidget(mapFrame)
guide:AddAnchor("BOTTOMLEFT", mapFrame, 20, -15)
mapFrame.guide = guide
local OnEnter = function(self)
  SetTooltip(locale.map.guide, self)
end
guide:SetHandler("OnEnter", OnEnter)
local OnLeave = function()
  HideTooltip()
end
guide:SetHandler("OnLeave", OnLeave)
local guideLabel = mapFrame:CreateChildWidget("label", "guideLabel", 0, true)
guideLabel:SetAutoResize(true)
guideLabel:SetHeight(FONT_SIZE.MIDDLE)
guideLabel:AddAnchor("LEFT", guide, "RIGHT", 0, 0)
guideLabel:SetText(GetCommonText("how_to_use_map"))
ApplyTextColor(guideLabel, FONT_COLOR.DEFAULT)
local CreateSextantsWnd = function(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetExtent(420, 22)
  local cursorImg = wnd:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "cursor_coordinate", "background")
  cursorImg:AddAnchor("LEFT", wnd, 0, 0)
  local cursorWnd = wnd:CreateChildWidget("emptywidget", "cursorWnd", 0, true)
  cursorWnd:AddAnchor("TOPLEFT", cursorImg, 0, 0)
  cursorWnd:AddAnchor("BOTTOMRIGHT", cursorImg, 0, 0)
  local cursorLabel1 = wnd:CreateChildWidget("textbox", "cursorLabel", 1, true)
  cursorLabel1:SetExtent(90, FONT_SIZE.MIDDLE)
  cursorLabel1:AddAnchor("LEFT", cursorImg, "RIGHT", 5, 0)
  cursorLabel1.style:SetAlign(ALIGN_LEFT)
  local cursorLabel2 = wnd:CreateChildWidget("textbox", "cursorLabel", 2, true)
  cursorLabel2:SetExtent(90, FONT_SIZE.MIDDLE)
  cursorLabel2:AddAnchor("LEFT", cursorLabel1, "RIGHT", 0, 0)
  cursorLabel2.style:SetAlign(ALIGN_LEFT)
  local cursorUnknown = wnd:CreateChildWidget("label", "cursorUnknown", 0, true)
  cursorUnknown:AddAnchor("LEFT", cursorImg, "RIGHT", 5, 0)
  cursorUnknown.style:SetAlign(ALIGN_LEFT)
  cursorUnknown:SetHeight(FONT_SIZE.MIDDLE)
  cursorUnknown:SetAutoResize(true)
  ApplyTextColor(cursorUnknown, FONT_COLOR.DEFAULT)
  cursorUnknown:SetText(GetCommonText("invalid_sextant"))
  local playerImg = wnd:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "my_coordinate", "background")
  playerImg:AddAnchor("LEFT", cursorLabel2, "RIGHT", 5, 0)
  local playerWnd = wnd:CreateChildWidget("emptywidget", "playerWnd", 0, true)
  playerWnd:AddAnchor("TOPLEFT", playerImg, 0, 0)
  playerWnd:AddAnchor("BOTTOMRIGHT", playerImg, 0, 0)
  local playerLabel1 = wnd:CreateChildWidget("textbox", "playerLabel", 1, true)
  playerLabel1:SetExtent(90, FONT_SIZE.MIDDLE)
  playerLabel1:AddAnchor("LEFT", playerImg, "RIGHT", 5, 0)
  playerLabel1.style:SetAlign(ALIGN_LEFT)
  local playerLabel2 = wnd:CreateChildWidget("textbox", "playerLabel", 2, true)
  playerLabel2:SetExtent(90, FONT_SIZE.MIDDLE)
  playerLabel2:AddAnchor("LEFT", playerLabel1, "RIGHT", 0, 0)
  playerLabel2.style:SetAlign(ALIGN_LEFT)
  local playerUnknown = wnd:CreateChildWidget("label", "playerUnknown", 0, true)
  playerUnknown:AddAnchor("LEFT", playerImg, "RIGHT", 5, 0)
  playerUnknown.style:SetAlign(ALIGN_LEFT)
  playerUnknown:SetHeight(FONT_SIZE.MIDDLE)
  playerUnknown:SetAutoResize(true)
  ApplyTextColor(playerUnknown, FONT_COLOR.DEFAULT)
  playerUnknown:SetText(GetCommonText("invalid_sextant_zone"))
  function wnd:Update()
    if worldmap == nil then
      return
    end
    if not mapFrame:IsVisible() then
      return
    end
    local color1 = {
      ConvertColor(111),
      ConvertColor(93),
      ConvertColor(52),
      1
    }
    local color2 = {
      ConvertColor(169),
      ConvertColor(132),
      ConvertColor(44),
      1
    }
    local colorStr1 = GetHexColorForString(Dec2Hex(color1))
    local colorStr2 = GetHexColorForString(Dec2Hex(color2))
    local sextantInfo = worldmap:GetPlayerSextants()
    if sextantInfo == nil then
      playerUnknown:Show(true)
      playerLabel1:Show(false)
      playerLabel2:Show(false)
    else
      local longStr = locale.map.makeLongitudeStr(sextantInfo, colorStr1, colorStr2)
      local latStr = locale.map.makeLatitudeStr(sextantInfo, colorStr1, colorStr2)
      playerLabel1:SetText(longStr)
      playerLabel2:SetText(latStr)
      playerLabel1:Show(true)
      playerLabel2:Show(true)
      playerUnknown:Show(false)
    end
    local cursorSextant = worldmap:GetCursorSextants()
    if cursorSextant == nil then
      cursorUnknown:Show(true)
      cursorLabel1:Show(false)
      cursorLabel2:Show(false)
    else
      local longStr = locale.map.makeLongitudeStr(cursorSextant, colorStr1, colorStr2)
      local latStr = locale.map.makeLatitudeStr(cursorSextant, colorStr1, colorStr2)
      cursorLabel1:SetText(longStr)
      cursorLabel2:SetText(latStr)
      cursorLabel1:Show(true)
      cursorLabel2:Show(true)
      cursorUnknown:Show(false)
    end
  end
  function cursorWnd:OnEnter()
    SetTargetAnchorTooltip(GetCommonText("tooltip_cursor_sextant"), "TOP", self, "BOTTOM", 0, 0)
  end
  cursorWnd:SetHandler("OnEnter", cursorWnd.OnEnter)
  function playerWnd:OnEnter()
    SetTargetAnchorTooltip(GetCommonText("tooltip_my_sextant"), "TOP", self, "BOTTOM", 0, 0)
  end
  playerWnd:SetHandler("OnEnter", playerWnd.OnEnter)
  function HideSextentTooltip()
    HideTooltip()
  end
  playerWnd:SetHandler("OnLeave", HideSextentTooltip)
  cursorWnd:SetHandler("OnLeave", HideSextentTooltip)
  return wnd
end
if baselibLocale.openedSextant == true then
  local sextantsWnd = CreateSextantsWnd("sextantsWnd", mapFrame)
  sextantsWnd:AddAnchor("TOPLEFT", mapFrame, "BOTTOM", -170, -35)
  mapFrame.sextantsWnd = sextantsWnd
end
mapWindow = mapFrame:CreateChildWidget("emptywidget", "mapWindow", 0, true)
mapWindow:SetExtent(WORLDMAP_VISIBLE_WIDTH, WORLDMAP_VISIBLE_HEIGHT)
mapWindow:AddAnchor("TOPLEFT", mapFrame, "TOPLEFT", 25, 43)
mapWindow:EnableScroll(true)
mapWindow:Show(true)
worldmap = mapWindow:CreateChildWidget("worldmap", "worldmap", 0, true)
worldmap:Show(false)
worldmap:EnableDrag(true)
worldmap:SetExtent(WORLDMAP_VISIBLE_WIDTH, WORLDMAP_VISIBLE_HEIGHT)
worldmap:AddAnchor("TOPLEFT", mapWindow, "TOPLEFT", 0, 0)
local playerDrawable = worldmap:CreateDrawable("ui/map/icon/player_cursor.dds", "player_cursor", "overlay")
playerDrawable:SetColor(1, 1, 1, 1)
worldmap:SetPlayerDrawable(playerDrawable)
mapFrame.player = playerDrawable
mapFrame.player.effect = CreateEffect(worldmap, playerDrawable)
mapFrame.player.effect:SetRepeatCount(4)
local portalDrawable = worldmap:CreateEffectDrawable(TEXTURE_PATH.MAP_ICON, "overlay")
portalDrawable:SetExtent(M_ICON_EXTENT, M_ICON_EXTENT)
portalDrawable:SetTextureInfo(X2Map:GetMapIconCoord(MST_PORTAL))
portalDrawable:SetEffectPriority(1, "alpha", 0.5, 0.4)
portalDrawable:SetMoveRepeatCount(0)
portalDrawable:SetMoveEffectType(1, "right", 0, 0, 0.4, 0.4)
portalDrawable:SetMoveEffectEdge(1, 0.3, 0.5)
portalDrawable:SetMoveEffectType(2, "right", 0, 0, 0.4, 0.4)
portalDrawable:SetMoveEffectEdge(2, 0.5, 0.3)
portalDrawable:SetMoveRotate(false)
portalDrawable:SetVisible(false)
worldmap:SetPortalDrawable(portalDrawable)
mapFrame.portal = portalDrawable
mapFrame.portal.effect = CreateEffect(worldmap, portalDrawable, "portal")
mapFrame.portal.effect:SetRepeatCount(0)
mapFrame.portal.effect:SetVisible(false)
local commonFarmDrawable = worldmap:CreateEffectDrawable(TEXTURE_PATH.MAP_ICON, "overlay")
commonFarmDrawable:SetExtent(M_ICON_EXTENT, M_ICON_EXTENT)
commonFarmDrawable:SetTextureInfo(X2Map:GetMapIconCoord(MST_COMMON_FARM))
commonFarmDrawable:SetVisible(false)
commonFarmDrawable:SetEffectPriority(1, "alpha", 0.5, 0.4)
commonFarmDrawable:SetMoveRepeatCount(0)
commonFarmDrawable:SetMoveEffectType(1, "right", 0, 0, 0.4, 0.4)
commonFarmDrawable:SetMoveEffectEdge(1, 0.3, 0.5)
commonFarmDrawable:SetMoveEffectType(2, "right", 0, 0, 0.4, 0.4)
commonFarmDrawable:SetMoveEffectEdge(2, 0.5, 0.3)
commonFarmDrawable:SetMoveRotate(false)
worldmap:SetCommonFarmDrawable(commonFarmDrawable)
mapFrame.commonFarm = commonFarmDrawable
mapFrame.PingBtn = {}
mapFrame.PingBtn[PING_TYPE_PING] = mapFrame:CreateChildWidget("button", "pingBtn", 0, true)
local pingBtn = mapFrame.PingBtn[PING_TYPE_PING]
ApplyButtonSkin(pingBtn, BUTTON_CONTENTS.MAP_PING_BTN)
pingBtn:AddAnchor("TOPLEFT", mapWindow, "BOTTOMRIGHT", 15, -100)
local OnEnter = function(self)
  local msg = string.format([[
%s
%s]], locale.map.pingPosition, locale.map.pingBtn)
  SetTooltip(msg, self)
end
pingBtn:SetHandler("OnEnter", OnEnter)
mapFrame.PingBtn[PING_TYPE_ENEMY] = mapFrame:CreateChildWidget("button", "enemyBtn", 0, true)
local enemyBtn = mapFrame.PingBtn[PING_TYPE_ENEMY]
ApplyButtonSkin(enemyBtn, BUTTON_CONTENTS.MAP_ENEMY_BTN)
enemyBtn:AddAnchor("TOPLEFT", pingBtn, "TOPRIGHT", 2, 0)
local OnEnter = function(self)
  local msg = string.format("%s", GetCommonText("ping_enemy"))
  SetTooltip(msg, self)
end
enemyBtn:SetHandler("OnEnter", OnEnter)
mapFrame.PingBtn[PING_TYPE_ATTACK] = mapFrame:CreateChildWidget("button", "attackBtn", 0, true)
local attackBtn = mapFrame.PingBtn[PING_TYPE_ATTACK]
ApplyButtonSkin(attackBtn, BUTTON_CONTENTS.MAP_ATTACK_BTN)
attackBtn:AddAnchor("TOPLEFT", enemyBtn, "TOPRIGHT", 2, 0)
local OnEnter = function(self)
  local msg = string.format("%s", GetCommonText("ping_attack"))
  SetTooltip(msg, self)
end
attackBtn:SetHandler("OnEnter", OnEnter)
mapFrame.PingBtn[PING_TYPE_LINE] = mapFrame:CreateChildWidget("button", "lineBtn", 0, true)
local lineBtn = mapFrame.PingBtn[PING_TYPE_LINE]
ApplyButtonSkin(lineBtn, BUTTON_CONTENTS.MAP_LINE_BTN)
lineBtn:AddAnchor("TOPLEFT", attackBtn, "TOPRIGHT", 8, 0)
local OnEnter = function(self)
  local msg = string.format("%s", GetCommonText("ping_line"))
  SetTooltip(msg, self)
end
lineBtn:SetHandler("OnEnter", OnEnter)
mapFrame.PingBtn[PING_TYPE_ERASER] = mapFrame:CreateChildWidget("button", "eraserBtn", 0, true)
local eraserBtn = mapFrame.PingBtn[PING_TYPE_ERASER]
ApplyButtonSkin(eraserBtn, BUTTON_CONTENTS.MAP_ERASER_BTN)
eraserBtn:AddAnchor("TOPLEFT", lineBtn, "TOPRIGHT", 8, 0)
local OnEnter = function(self)
  local msg = string.format("%s", GetCommonText("ping_del"))
  SetTooltip(msg, self)
end
eraserBtn:SetHandler("OnEnter", OnEnter)
local focusBtn = mapFrame:CreateChildWidget("button", "focusBtn", 0, true)
ApplyButtonSkin(focusBtn, BUTTON_CONTENTS.MAP_MY_POS_BTN)
focusBtn:AddAnchor("TOPLEFT", pingBtn, "BOTTOMLEFT", 0, 20)
local OnEnter = function(self)
  local msg = string.format("%s", locale.map.lookMyPosition)
  SetTooltip(msg, self)
end
focusBtn:SetHandler("OnEnter", OnEnter)
local routeBtn = mapFrame:CreateChildWidget("button", "routeBtn", 0, true)
ApplyButtonSkin(routeBtn, BUTTON_CONTENTS.MAP_ROUTE_BTN)
routeBtn:AddAnchor("LEFT", focusBtn, "RIGHT", 5, 0)
local OnEnter = function(self)
  local msg = string.format([[
%s
%s]], GetCommonText("map_route_btn"), GetCommonText("map_route_btn_desc"))
  SetTooltip(msg, self)
end
routeBtn:SetHandler("OnEnter", OnEnter)
local changeMapScaleLabel = mapFrame:CreateChildWidget("label", "changeMapScaleLabel", 0, true)
changeMapScaleLabel:SetText(locale.map.changeMapScale)
changeMapScaleLabel:SetExtent(80, FONT_SIZE.LARGE)
changeMapScaleLabel:AddAnchor("TOPLEFT", focusBtn, "BOTTOMLEFT", 10, 10)
changeMapScaleLabel.style:SetFontSize(FONT_SIZE.LARGE)
ApplyTextColor(changeMapScaleLabel, FONT_COLOR.TITLE)
mapFrame.expandBtn = {}
for i = 1, 3 do
  do
    local expandBtn = mapFrame:CreateChildWidget("button", "expandBtn", i, true)
    ApplyButtonSkin(expandBtn, BUTTON_CONTENTS.MAP_SCALE[i])
    expandBtn:SetExtent(15, 15)
    if i == 1 then
      expandBtn:AddAnchor("LEFT", changeMapScaleLabel, "RIGHT", MARGIN.WINDOW_SIDE / 2, 0)
    else
      expandBtn:AddAnchor("LEFT", mapFrame.expandBtn[i - 1], "RIGHT", 5, 0)
    end
    function expandBtn:OnClick()
      SetExpandLevel(i, worldmap.isSameZone)
    end
    expandBtn:SetHandler("OnClick", expandBtn.OnClick)
    mapFrame.expandBtn[i] = expandBtn
  end
end
worldmap:SetTooltipColor(M_QUEST_OBJECTIVE_TOOLTIP_COLOR, M_NPC_NICKNAME_TOOLTIP_COLOR)
PEACE_TAX_TEXT_ANCHOR_X = 28
PEACE_TAX_TEXT_BG_ANCHOR_X = 13
function CreateBottomInfoFrame(parent)
  local bottomInfoFrame = parent:CreateChildWidget("emptywidget", "bottomInfoFrame", 0, true)
  bottomInfoFrame:SetExtent(200, 100)
  bottomInfoFrame:AddAnchor("BOTTOMLEFT", parent, "BOTTOMLEFT", 18, -54)
  bottomInfoFrame:Clickable(false)
  local bg = bottomInfoFrame:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "area_bg", "background")
  bg:SetTextureColor("default")
  bg:SetExtent(500, 200)
  bg:AddAnchor("BOTTOMLEFT", bottomInfoFrame, 0, 17)
  bg:SetVisible(true)
  bottomInfoFrame.bg = bg
  local conflictParent = bottomInfoFrame:CreateChildWidget("emptywidget", "conflictParent", 0, true)
  conflictParent:SetExtent(180, 35)
  conflictParent:Clickable(false)
  local title = conflictParent:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.XLARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", conflictParent, 0, 0)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  local stateMark = title:CreateDrawable("ui/map/frame_map.dds", "state_mark", "background")
  stateMark:SetColor(1, 1, 1, 1)
  stateMark:AddAnchor("TOPLEFT", title, "TOPRIGHT", 0, -2)
  stateMark:SetVisible(true)
  conflictParent.stateMark = stateMark
  local remainTime = conflictParent:CreateChildWidget("label", "remainTime", 0, true)
  remainTime:SetHeight(FONT_SIZE.MIDDLE)
  remainTime:SetAutoResize(true)
  remainTime:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 2, 4)
  remainTime.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(remainTime, FONT_COLOR.SOFT_BROWN)
  local lockRemainTime = conflictParent:CreateChildWidget("label", "lockRemainTime", 0, true)
  lockRemainTime:SetHeight(FONT_SIZE.MIDDLE)
  lockRemainTime:SetAutoResize(true)
  lockRemainTime:AddAnchor("BOTTOMLEFT", title, "TOPLEFT", 2, -4)
  lockRemainTime.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(lockRemainTime, FONT_COLOR.SOFT_BROWN)
  local lockTitle = conflictParent:CreateChildWidget("label", "lockTitle", 0, true)
  lockTitle:SetHeight(FONT_SIZE.MIDDLE)
  lockTitle:SetAutoResize(true)
  lockTitle:AddAnchor("BOTTOMLEFT", lockRemainTime, "TOPLEFT", 0, -4)
  lockTitle.style:SetAlign(ALIGN_LEFT)
  lockTitle:SetText(GetCommonText("zone_conflict_locked"))
  ApplyTextColor(lockTitle, FONT_COLOR.SOFT_BROWN)
  local GAGE_BAR_WIDTH = 157
  local gageBar = conflictParent:CreateChildWidget("emptywidget", "gageBar", 0, true)
  gageBar:SetExtent(GAGE_BAR_WIDTH, 25)
  gageBar:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 1, -1)
  gageBar:Show(false)
  local GAGE_STEP_WIDTH = 29
  local GAGE_STEP_HEIGHT = 6
  local gageBg = gageBar:CreateDrawable(TEXTURE_PATH.HUD, "zone_danger_step_bg", "background")
  gageBg:SetExtent(GAGE_STEP_WIDTH * 5, GAGE_STEP_HEIGHT)
  gageBg:AddAnchor("LEFT", gageBar, 0, 0)
  gageBg:SetVisible(true)
  gageBar.on = {}
  for i = 1, 5 do
    local startPosX = (i - 1) * GAGE_STEP_WIDTH
    local on = gageBar:CreateDrawable(TEXTURE_PATH.HUD, "zone_danger_step_full", "background")
    on:SetTextureColor("red")
    on:SetExtent(GAGE_STEP_WIDTH, 6)
    on:AddAnchor("LEFT", gageBar, startPosX, 0)
    on:SetVisible(false)
    gageBar.on[i] = on
  end
  local localParent = bottomInfoFrame:CreateChildWidget("emptywidget", "localParent", 0, true)
  localParent:SetExtent(180, 35)
  localParent:Clickable(false)
  local localBg = bottomInfoFrame:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "resident_bg", "background")
  localBg:SetTextureColor("local")
  localBg:AddAnchor("BOTTOMRIGHT", localParent, 2, 15)
  bottomInfoFrame.localBg = localBg
  local title = localParent:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.XLARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPRIGHT", localParent, -2, 0)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  local stateIcon = localParent:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "icon_resident", "artwork")
  stateIcon:AddAnchor("RIGHT", title, "LEFT", 0, 2)
  stateIcon:SetSnap(false)
  local LOCAL_GAGE_BAR_WIDTH = 157
  local gageBar = localParent:CreateChildWidget("emptywidget", "gageBar", 0, true)
  gageBar:SetExtent(GAGE_BAR_WIDTH, 25)
  gageBar:AddAnchor("TOPRIGHT", title, "BOTTOMRIGHT", 0, -1)
  gageBar:Show(false)
  local LOCAL_GAGE_STEP_WIDTH = 49
  local LOCAL_GAGE_STEP_HEIGHT = 6
  local gageBg = gageBar:CreateDrawable(TEXTURE_PATH.HUD, "zone_danger_step_bg", "background")
  gageBg:SetExtent(LOCAL_GAGE_STEP_WIDTH * 3, LOCAL_GAGE_STEP_HEIGHT)
  gageBg:AddAnchor("RIGHT", gageBar, 0, 0)
  gageBg:SetVisible(true)
  gageBar.on = {}
  for i = 1, 3 do
    local startPosX = (i - 1) * LOCAL_GAGE_STEP_WIDTH
    local on = gageBar:CreateDrawable(TEXTURE_PATH.HUD, "zone_danger_step_full", "background")
    on:SetTextureColor("green")
    on:SetExtent(LOCAL_GAGE_STEP_WIDTH, LOCAL_GAGE_STEP_HEIGHT)
    on:AddAnchor("RIGHT", gageBar, -startPosX, 0)
    on:SetVisible(false)
    gageBar.on[i] = on
  end
  local peacetax = bottomInfoFrame:CreateChildWidget("label", "peacetax", 0, true)
  peacetax:AddAnchor("BOTTOMLEFT", bottomInfoFrame, 15, 5)
  peacetax:SetExtent(180, FONT_SIZE.MIDDLE)
  peacetax:SetAutoResize(true)
  ApplyTextColor(peacetax, FONT_COLOR.WHITE)
  peacetax.style:SetAlign(ALIGN_LEFT)
  peacetax.bg = peacetax:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "money_bg", "background")
  peacetax.bg:AddAnchor("LEFT", peacetax, -PEACE_TAX_TEXT_BG_ANCHOR_X, 0)
  peacetax.bg:Show(false)
  local anchorTarget = peacetax
  local isConvertTaxItemToAAPoint = X2House:IsConvertTaxItemToAAPoint()
  if F_MONEY.currency.houseTax ~= CURRENCY_GOLD or isConvertTaxItemToAAPoint ~= false then
    local peaceTaxAAPoint = peacetax:CreateChildWidget("textbox", "peaceTaxAAPoint", 0, true)
    peaceTaxAAPoint:AddAnchor("LEFT", anchorTarget, "RIGHT", PEACE_TAX_TEXT_ANCHOR_X, 0)
    peaceTaxAAPoint:SetExtent(180, FONT_SIZE.MIDDLE)
    ApplyTextColor(peaceTaxAAPoint, FONT_COLOR.WHITE)
    peaceTaxAAPoint.style:SetAlign(ALIGN_LEFT)
    anchorTarget = peaceTaxAAPoint
  end
  local peaceTaxMoney = peacetax:CreateChildWidget("textbox", "peaceTaxMoney", 0, true)
  peaceTaxMoney:AddAnchor("LEFT", anchorTarget, "RIGHT", PEACE_TAX_TEXT_ANCHOR_X, 0)
  peaceTaxMoney:SetExtent(180, FONT_SIZE.MIDDLE)
  ApplyTextColor(peaceTaxMoney, FONT_COLOR.WHITE)
  peaceTaxMoney.style:SetAlign(ALIGN_LEFT)
  local taxRate = bottomInfoFrame:CreateChildWidget("label", "taxRate", 0, true)
  taxRate:AddAnchor("BOTTOMLEFT", peacetax, "TOPLEFT", 0, -5)
  taxRate:SetExtent(180, FONT_SIZE.MIDDLE)
  taxRate:SetAutoResize(true)
  ApplyTextColor(taxRate, FONT_COLOR.WHITE)
  taxRate.style:SetAlign(ALIGN_LEFT)
  taxRate:SetText(locale.territory.taxRate)
  local rate = taxRate:CreateChildWidget("textbox", "rate", 0, true)
  rate:AddAnchor("BOTTOMLEFT", peaceTaxMoney, "TOPLEFT", 0, -5)
  rate:SetExtent(180, FONT_SIZE.MIDDLE)
  ApplyTextColor(rate, FONT_COLOR.WHITE)
  rate.style:SetAlign(ALIGN_LEFT)
end
function CreateClimateFrmae(parent)
  local climateFrame = parent:CreateChildWidget("emptywidget", "climateFrame", 0, true)
  climateFrame:SetHeight(49)
  local posX = parent:GetWidth() - WORLDMAP_VISIBLE_WIDTH - 25
  climateFrame:AddAnchor("BOTTOMRIGHT", parent, "BOTTOMRIGHT", -posX, -45)
  local bg = climateFrame:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "icon_bg", "background")
  bg:AddAnchor("TOPLEFT", climateFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", climateFrame, 0, 0)
  climateFrame.tip = ""
  local function OnEnter()
    if climateFrame.tip == "" then
      return
    end
    SetHorizonTooltip(climateFrame.tip, climateFrame)
  end
  climateFrame:SetHandler("OnEnter", OnEnter)
  climateFrame.icon = {}
  for i = 1, 4 do
    local icon = climateFrame:CreateDrawable(BUTTON_TEXTURE_PATH.MAP, "temperate", "overlay")
    icon:SetVisible(false)
    climateFrame.icon[i] = icon
  end
  parent.climateFrame = climateFrame
end
CreateBottomInfoFrame(mapFrame)
CreateClimateFrmae(mapFrame)
