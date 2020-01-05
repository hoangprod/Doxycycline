local TEAM_WIDGET = {
  ally = {
    TITLE = nil,
    ITEM_FRAME = nil,
    ITEMS = {}
  },
  enemy = {
    TITLE = nil,
    ITEM_FRAME = nil,
    ITEMS = {}
  }
}
local FRAME_BG_COLOR = {
  default = {
    1,
    1,
    1,
    0.7
  },
  ally = {
    ConvertColor(0),
    ConvertColor(117),
    ConvertColor(57),
    1
  },
  enemy = {
    ConvertColor(153),
    ConvertColor(35),
    ConvertColor(35),
    1
  }
}
local DummyBoardItemInfo = function()
  local itemInfo = {}
  itemInfo.ally = {
    teamName = "\236\157\180\236\167\128\236\157\152 \236\182\148\236\162\133\236\158\144",
    teamItems = {
      [1] = {
        name = "\236\157\180\236\167\1281",
        charHp = 100,
        shipHp = 100,
        shipType = 1,
        myItem = false,
        detected = false
      },
      [2] = {
        name = "\236\157\180\236\167\1282",
        charHp = 0,
        shipHp = 100,
        shipType = 2,
        myItem = true,
        detected = false
      },
      [3] = {
        name = "\236\157\180\236\167\1283",
        charHp = 100,
        shipHp = 100,
        shipType = 3,
        myItem = false,
        detected = false
      },
      [4] = {
        name = "\236\157\180\236\167\1284",
        charHp = 100,
        shipHp = 100,
        shipType = 4,
        myItem = false,
        detected = false
      }
    }
  }
  itemInfo.enemy = {
    teamName = "\235\139\164\237\155\132\237\131\128\236\157\152 \236\182\148\236\162\133\236\158\144",
    teamItems = {
      [1] = {
        name = "\235\139\164\237\155\132\237\131\128",
        charHp = 50,
        shipHp = 50,
        shipType = 2,
        myItem = false,
        detected = true
      },
      [2] = {
        name = "\235\139\164\237\155\132\237\131\128",
        charHp = 50,
        shipHp = 50,
        shipType = 2,
        myItem = false,
        detected = false
      },
      [3] = {
        name = "\235\139\164\237\155\132\237\131\128",
        charHp = 50,
        shipHp = 50,
        shipType = 2,
        myItem = false,
        detected = true
      },
      [4] = {
        name = "\235\139\164\237\155\132\237\131\128",
        charHp = 10,
        shipHp = 50,
        shipType = 2,
        myItem = false,
        detected = true
      }
    }
  }
  return itemInfo
end
local CreateBoardItemFrame = function(parent, barTexture, offSetY)
  local CreateBoardHpBar = function(parent, barTexture, isChar)
    local hpBar = SetViewOfStatusBarOfUnitFrame("hpBar", parent)
    hpBar:ApplyBarTexture(barTexture)
    hpBar.statusBar:SetMinMaxValues(0, 100)
    hpBar.statusBar:SetValue(100)
    local bg = hpBar:CreateDrawable(TEXTURE_PATH.HUD, "ship_status_board_hp_bg", "artwork")
    bg:SetTextureColor("hp_bg")
    bg:AddAnchor("TOPLEFT", hpBar, -1, -2)
    bg:AddAnchor("BOTTOMRIGHT", hpBar, 3, 2)
    if isChar then
      hpBar:AddAnchor("LEFT", parent, "LEFT", 2, 0)
      hpBar:SetExtent(220, 19)
      local charText = hpBar:CreateChildWidget("label", "charText", 0, true)
      charText:SetAutoResize(true)
      charText.style:SetAlign(ALIGN_LEFT)
      charText.style:SetFontSize(FONT_SIZE.SMALL)
      charText:SetText("\236\157\180\235\166\132")
      charText:AddAnchor("LEFT", hpBar, 5, 0)
      hpBar.charText = charText
    else
      hpBar:AddAnchor("RIGHT", parent, "RIGHT", 0, 0)
      hpBar:SetExtent(182, 19)
      local icon = hpBar:CreateChildWidget("emptywidget", "icon", 0, true)
      icon:AddAnchor("CENTER", hpBar, 0, 0)
      icon:SetExtent(19, 19)
      local iconImg = icon:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_STATUS_BOARD_SHIP, "speedboat", "overlay")
      iconImg:AddAnchor("TOPLEFT", icon, 0, 0)
      iconImg:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
      icon.Img = iconImg
      local OnEnter = function(obj)
        SetTooltip(obj.toolTipText, obj)
      end
      local OnLeave = function()
        HideTooltip()
      end
      hpBar.icon = icon
      hpBar.icon:SetHandler("OnEnter", OnEnter)
      hpBar.icon:SetHandler("OnLeave", OnLeave)
    end
    function hpBar:SetName(name)
      hpBar.charText:SetText(name)
    end
    function hpBar:SetHpValue(value)
      hpBar.statusBar:SetValue(value)
      if hpBar.charText == nil then
        return
      end
      if value ~= 0 then
        ApplyTextColor(hpBar.charText, FONT_COLOR.WHITE)
      else
        ApplyTextColor(hpBar.charText, F_COLOR.GetColor("original_light_gray", false))
      end
    end
    function hpBar:SetShipType(shipType)
      local tooltipInfo = X2BattleField:GetShipInfo(shipType, true)
      if tooltipInfo ~= nil then
        hpBar.icon.Img:SetTextureInfo(tooltipInfo.icon)
        hpBar.icon.toolTipText = tooltipInfo.name
      end
    end
    return hpBar
  end
  local frame = parent:CreateChildWidget("emptywidget", "frame", 0, true)
  frame:SetExtent(420, 30)
  frame:AddAnchor("TOPLEFT", parent, "BOTTOMLEFT", 0, offSetY)
  frame.charHpBar = CreateBoardHpBar(frame, barTexture, true)
  frame.shipHpBar = CreateBoardHpBar(frame, barTexture, false)
  function frame:SetCharName(name)
    frame.charHpBar:SetName(name)
  end
  function frame:SetCharHpValue(value)
    frame.charHpBar:SetHpValue(value)
  end
  function frame:SetShipHpValue(value)
    frame.shipHpBar:SetHpValue(value)
  end
  function frame:SetShipType(shipType)
    frame.shipHpBar:SetShipType(shipType)
  end
  return frame
end
local UpdateBoardItem = function(item, itemInfo)
  item:SetCharName(itemInfo.name)
  item:SetCharHpValue(itemInfo.charHp)
  item:SetShipHpValue(itemInfo.shipHp)
  item:SetShipType(itemInfo.shipType)
  if item.detected ~= nil then
    item.detected:Show(itemInfo.detected)
  end
  if itemInfo.myItem then
    battlefield.shipstatusboard.myItem:Show(true)
    battlefield.shipstatusboard.myItem:RemoveAllAnchors()
    battlefield.shipstatusboard.myItem:AddAnchor("TOPLEFT", item, -11, 0)
    battlefield.shipstatusboard.myItem:AddAnchor("BOTTOMRIGHT", item, 11, 0)
  end
end
local function UpdateTeamStatusBoard(teamType, statusBoardInfo)
  if statusBoardInfo == nil then
    return
  end
  local boardInfo = statusBoardInfo[teamType]
  local teamBoard = TEAM_WIDGET[teamType]
  local barColor = STATUSBAR_STYLE.S_HP_FRIENDLY
  if teamType == "enemy" then
    barColor = STATUSBAR_STYLE.S_HP_HOSTILE
  end
  local infoCount = #boardInfo.teamItems
  local widgetCount = #teamBoard.ITEMS
  for i = infoCount + 1, widgetCount do
    teamBoard.ITEMS[i]:Show(false)
  end
  teamBoard.TITLE:SetText(boardInfo.teamName)
  for i = 1, infoCount do
    if teamBoard.ITEMS[i] == nil then
      teamBoard.ITEMS[i] = CreateBoardItemFrame(teamBoard.ITEM_FRAME, barColor, #teamBoard.ITEMS * 30)
      if teamType == "enemy" then
        local detected = teamBoard.ITEMS[i]:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_STATUS_BOARD_SHIP, "me_bg", "background")
        detected:SetTextureColor("default")
        detected:SetColor(1, 0.2, 0.2, 0.5)
        detected:AddAnchor("TOPLEFT", teamBoard.ITEMS[i], -11, 0)
        detected:AddAnchor("BOTTOMRIGHT", teamBoard.ITEMS[i], 11, 0)
        detected:Show(false)
        teamBoard.ITEMS[i].detected = detected
      end
    end
    UpdateBoardItem(teamBoard.ITEMS[i], boardInfo.teamItems[i])
  end
end
local CreateTeamStatusBoardItemFrame = function(parent, teamType)
  local CreateTitleLine = function(parent, widgets)
    for i = 1, #widgets do
      DrawListCtrlColumnSperatorLine(widgets[i], #widgets, i, true)
    end
    DrawListCtrlUnderLine(parent, widgets[1]:GetHeight() - 2, true)
  end
  local itemFrame = parent:CreateChildWidget("emptywidget", "itemFrame", 0, true)
  itemFrame:SetExtent(442, parent:GetHeight())
  if teamType == "ally" then
    itemFrame:AddAnchor("TOPLEFT", parent, 0, 0)
  else
    itemFrame:AddAnchor("TOPRIGHT", parent, 0, 0)
  end
  local nameFrame = itemFrame:CreateChildWidget("emptywidget", "nameFrame", 0, true)
  nameFrame:SetExtent(230, 42)
  nameFrame:AddAnchor("TOPLEFT", itemFrame, 11, 0)
  local name = nameFrame:CreateChildWidget("label", "name", 0, true)
  name:SetAutoResize(true)
  name.style:SetAlign(ALIGN_CENTER)
  name.style:SetFontSize(FONT_SIZE.LARGE)
  name:SetText("\236\157\180\235\166\132")
  name:AddAnchor("CENTER", nameFrame, 0, 0)
  local shipFrame = itemFrame:CreateChildWidget("emptywidget", "shipFrame", 0, true)
  shipFrame:SetExtent(190, 42)
  shipFrame:AddAnchor("LEFT", nameFrame, "RIGHT", 0, 0)
  local ship = shipFrame:CreateChildWidget("label", "ship", 0, true)
  ship:SetAutoResize(true)
  ship.style:SetAlign(ALIGN_CENTER)
  ship.style:SetFontSize(FONT_SIZE.LARGE)
  ship:SetText("\236\132\160\235\176\149")
  ship:AddAnchor("CENTER", shipFrame, 0, 0)
  local titleFrames = {nameFrame, shipFrame}
  CreateTitleLine(itemFrame, titleFrames)
  return nameFrame
end
local function CreateTeamStatusBoardFrame(parent, teamType)
  local frame = parent:CreateChildWidget("emptywidget", "frame", 0, true)
  local titleBg = CreateContentBackground(frame, "TYPE7", "black")
  titleBg:SetExtent(205, 39)
  local title = parent:CreateChildWidget("label", "title", 0, true)
  title:SetExtent(410, FONT_SIZE.LARGE)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  local decoFrame = parent:CreateChildWidget("emptywidget", "frameItem", 0, true)
  decoFrame:SetExtent(465, 348)
  local bgColor = FRAME_BG_COLOR[teamType]
  local bg = decoFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg", "background")
  if teamType == "ally" then
    ApplyTextColor(title, F_COLOR.GetColor("light_green"))
    title:AddAnchor("TOPLEFT", titleBg, 10, 10)
    title.style:SetAlign(ALIGN_LEFT)
    bg:SetCoords(0, 100, 355, 245)
    frame:AddAnchor("TOPLEFT", parent.titleBar, "BOTTOMLEFT", 20, 0)
    titleBg:AddAnchor("TOPLEFT", frame, 6, 0)
    decoFrame:AddAnchor("TOPLEFT", titleBg, "BOTTOMLEFT", 0, 0)
  else
    ApplyTextColor(title, F_COLOR.GetColor("red"))
    title:AddAnchor("TOPRIGHT", titleBg, -10, 10)
    title.style:SetAlign(ALIGN_RIGHT)
    bg:SetCoords(355, 100, -355, 245)
    titleBg:SetCoords(256, 0, -256, 57)
    frame:AddAnchor("TOPRIGHT", parent.titleBar, "BOTTOMRIGHT", -20, 0)
    titleBg:AddAnchor("TOPRIGHT", frame, -6, 0)
    decoFrame:AddAnchor("TOPRIGHT", titleBg, "BOTTOMRIGHT", 0, 0)
  end
  bg:SetColor(bgColor[1], bgColor[2], bgColor[3], bgColor[4])
  bg:AddAnchor("TOPLEFT", decoFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", decoFrame, 0, 0)
  TEAM_WIDGET[teamType].TITLE = title
  TEAM_WIDGET[teamType].ITEM_FRAME = CreateTeamStatusBoardItemFrame(decoFrame, teamType)
end
local function CraeteShipStatusBoard(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:SetExtent(929, 460)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetSounds("dialog_common")
  window:SetCloseOnEscape(true)
  SetttingUIAnimation(window)
  local titleBar = CreateTitleBar(id .. ".titleBar", window)
  titleBar:SetTitleText("\237\149\180\236\131\129 \236\160\132\236\158\165 \237\152\132\237\153\169")
  ApplyTitleFontColor(titleBar, FONT_COLOR.SOFT_YELLOW)
  ApplyButtonSkin(titleBar.closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  titleBar.closeButton:RemoveAllAnchors()
  titleBar.closeButton:AddAnchor("TOPRIGHT", titleBar, -26, 5)
  window.titleBar = titleBar
  local bg = window:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg", "background")
  local frameColor = FRAME_BG_COLOR.default
  bg:SetColor(frameColor[1], frameColor[2], frameColor[3], frameColor[4])
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  CreateTeamStatusBoardFrame(window, "ally")
  CreateTeamStatusBoardFrame(window, "enemy")
  local myItem = TEAM_WIDGET.ally.ITEM_FRAME:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_STATUS_BOARD_SHIP, "me_bg", "background")
  myItem:SetTextureColor("default")
  myItem:Show(false)
  window.myItem = myItem
  local OnShow = function()
    if battlefield.miniScoreboard == nil then
      return
    end
    battlefield.miniScoreboard.scoreBtn:OnButtonImage(true)
  end
  local OnHide = function()
    if battlefield.miniScoreboard == nil then
      return
    end
    battlefield.miniScoreboard.scoreBtn:OnButtonImage(false)
  end
  window:SetHandler("OnShow", OnShow)
  window:SetHandler("OnHide", OnHide)
  return window
end
local windowEvents = {
  INSTANT_GAME_END = function(obj)
    obj:EnableHidingIsRemove(true)
    obj:Show(false)
    battlefield.shipstatusboard = nil
  end,
  INSTANT_GAME_RETIRE = function(obj)
    obj:EnableHidingIsRemove(true)
    obj:Show(false)
    battlefield.shipstatusboard = nil
  end
}
local function ShipStatusBoard(toggle, statusBoardInfo)
  if battlefield.shipstatusboard == nil then
    battlefield.shipstatusboard = CraeteShipStatusBoard("shipStatusBoard", "UIParent")
    battlefield.shipstatusboard:SetHandler("OnEvent", function(this, event, ...)
      windowEvents[event](this, ...)
    end)
    RegistUIEvent(battlefield.shipstatusboard, windowEvents)
    UpdateTeamStatusBoard("ally", statusBoardInfo)
    UpdateTeamStatusBoard("enemy", statusBoardInfo)
  end
  if toggle then
    battlefield.shipstatusboard:Show(not battlefield.shipstatusboard:IsVisible())
  end
  if battlefield.shipstatusboard:IsVisible() then
    UpdateTeamStatusBoard("ally", statusBoardInfo)
    UpdateTeamStatusBoard("enemy", statusBoardInfo)
  end
end
UIParent:SetEventHandler("UPDATE_INSTANT_GAME_SHIP_STATUS_BOARD", ShipStatusBoard)
