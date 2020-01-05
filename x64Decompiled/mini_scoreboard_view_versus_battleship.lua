local SetScoreIconPos = function(parent, icon, score, totalScore)
  local scoreRate = 0
  if totalScore > 0 then
    scoreRate = score / totalScore * 100
  end
  local pos = scoreRate * 5.7 + 46
  icon:RemoveAllAnchors()
  icon:AddAnchor("BOTTOMRIGHT", parent, "BOTTOMLEFT", pos, -14)
  icon.score = score
end
local function CreateScoreIcon(parent, iconIndex)
  local iconWidget = parent:CreateChildWidget("emptyWidget", "iconWidget" .. iconIndex, 0, true)
  iconWidget:SetExtent(52, 62)
  SetScoreIconPos(parent, iconWidget, 0, 0)
  iconWidget:Show(false)
  local iconImage = iconWidget:CreateImageDrawable(TEXTURE_PATH.BATTLEFIELD_SEA_WAR_HUD, "background")
  iconImage:AddAnchor("BOTTOM", iconWidget, "BOTTOM", 0, 0)
  local iconTeamEffectImage = iconWidget:CreateImageDrawable(TEXTURE_PATH.BATTLEFIELD_SEA_WAR_HUD, "overlay")
  iconTeamEffectImage:AddAnchor("BOTTOM", iconImage, "BOTTOM", 0, -23)
  local function OnEnter()
    local strScore = locale.battlefield.tooltip.battle_ship_score(iconWidget.score)
    SetVerticalTooltip(strScore, iconWidget)
  end
  iconWidget:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  iconWidget:SetHandler("OnLeave", OnLeave)
  local function OnUpdate()
    if iconWidget:IsMouseOver() then
      OnEnter()
    end
  end
  iconWidget:SetHandler("OnUpdate", OnUpdate)
  function iconWidget:UpdateCorpsScore(scoreInfo, totalScore)
    if scoreInfo == nil then
      iconWidget:Show(false)
      return
    end
    local myTeam = scoreInfo.myTeam
    local score = scoreInfo.score
    local priority = scoreInfo.priority
    local faction = scoreInfo.faction
    local teamName = GetBattleShipFactionStr(faction)
    iconImage:SetTextureInfo(string.format("team_%s", teamName))
    iconTeamEffectImage:SetTextureInfo("my_team_effect", teamName)
    iconTeamEffectImage:Show(myTeam)
    SetScoreIconPos(parent, iconWidget, score, totalScore)
    iconWidget:SetDrawPriority(priority)
    iconWidget:Show(true)
  end
  return iconWidget
end
local CreateHudScoreImage = function(parent)
  local scoreBackground = parent:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SEA_WAR_HUD, "gauge_bg", "background")
  scoreBackground:AddAnchor("TOP", parent, "TOP", 0, 0)
end
local CreateHudTime = function(parent)
  local timeWidget = parent:CreateChildWidget("emptyWidget", "timeWidget", 0, true)
  timeWidget:SetExtent(227, 31)
  timeWidget:AddAnchor("TOP", parent, "TOP", 0, 0)
  local timeBg = timeWidget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SEA_WAR_HUD, "time_bg_title", "background")
  timeBg:AddAnchor("TOPLEFT", timeWidget, "TOPLEFT", 0, 0)
  timeBg:AddAnchor("BOTTOMRIGHT", timeWidget, "BOTTOMRIGHT", 0, 0)
  local timeOffsetX = 0
  local timeText = timeWidget:CreateChildWidget("textbox", "timeText", 0, true)
  timeText.style:SetFontSize(FONT_SIZE.XXLARGE)
  timeText.style:SetAlign(ALIGN_LEFT)
  timeText:SetAutoResize(true)
  timeText:SetAutoWordwrap(false)
  ApplyTextColor(timeText, FONT_COLOR.MEDIUM_YELLOW)
  timeText:SetText("00:00")
  timeOffsetX = timeOffsetX + timeText:GetLongestLineWidth() + 5
  local timeIcon = timeWidget:CreateDrawable(TEXTURE_PATH.HUD, "clock", "background")
  timeOffsetX = timeOffsetX + timeIcon:GetWidth() + 5
  timeIcon:AddAnchor("LEFT", timeWidget, "CENTER", -timeOffsetX / 2, 0)
  timeText:AddAnchor("LEFT", timeIcon, "RIGHT", 5, 0)
  local countWidget = parent:CreateChildWidget("emptyWidget", "countWidget", 0, true)
  countWidget:SetExtent(227, 38)
  countWidget:AddAnchor("BOTTOM", parent, "BOTTOM", 0, 0)
  local countBg = countWidget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SEA_WAR_HUD, "time_bg_point", "background")
  countBg:AddAnchor("TOPLEFT", countWidget, "TOPLEFT", 0, 0)
  countBg:AddAnchor("BOTTOMRIGHT", countWidget, "BOTTOMRIGHT", 0, 0)
  local countOffsetX = 0
  local countText = countWidget:CreateChildWidget("textbox", "countText", 0, true)
  countText.style:SetFontSize(FONT_SIZE.MIDDLE)
  countText.style:SetAlign(ALIGN_LEFT)
  countText:SetAutoResize(true)
  countText:SetAutoWordwrap(false)
  ApplyTextColor(countText, FONT_COLOR.WHITE)
  countText:SetText(locale.battlefield.scoreSlaveCount(999))
  countOffsetX = countOffsetX + countText:GetLongestLineWidth() + 5
  local countIcon = countWidget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SEA_WAR_HUD, "point", "background")
  countOffsetX = countOffsetX + countIcon:GetWidth() + 5
  countIcon:AddAnchor("LEFT", countWidget, "CENTER", -countOffsetX / 2, 0)
  countText:AddAnchor("LEFT", countIcon, "RIGHT", 5, 0)
  function parent:UpdateTime(remainTime)
    local minute, second = GetMinuteSecondeFromSec(remainTime)
    local timeStr = string.format("%02d:%02d", minute, second)
    timeText:SetText(timeStr)
  end
  function parent:UpdateSlaveCount(count)
    countText:SetText(locale.battlefield.scoreSlaveCount(count))
  end
end
local function CreateMiniScoreboard(id, parent)
  local window = UIParent:CreateWidget("window", id .. "_scoreBoard", parent)
  window:SetExtent(619, 32)
  window:AddAnchor("BOTTOM", parent, "BOTTOM", 0, -17)
  CreateHudScoreImage(window)
  local timeHudWindow = window:CreateChildWidget("emptyWidget", "timeHudWindow", 0, true)
  timeHudWindow:SetExtent(227, 69)
  timeHudWindow:AddAnchor("TOPRIGHT", parent, "TOPRIGHT", -265, 0)
  CreateHudTime(timeHudWindow)
  local dragWindow = timeHudWindow:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", timeHudWindow, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", timeHudWindow, 0, 0)
  dragWindow:EnableDrag(true)
  local function OnDragStart(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    timeHudWindow:StartMoving()
    self.moving = true
  end
  dragWindow:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop(self)
    if self.moving == true then
      timeHudWindow:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  dragWindow:SetHandler("OnDragStop", OnDragStop)
  window.corpsIcons = {}
  for i = 1, BATTLE_SHIP_FACTION_COUNT do
    window.corpsIcons[i] = CreateScoreIcon(window, i)
  end
  function window:HideMiniScoreboard()
    self:ReleaseHandler("OnUpdate")
    self:Show(false)
  end
  local OnHideMiniScoreboard = function()
    battlefield.miniScoreboard = nil
  end
  window:SetHandler("OnHide", OnHideMiniScoreboard)
  function window:UpdateCorpsScore(scoreInfo, totalScore)
    for i = 1, BATTLE_SHIP_FACTION_COUNT do
      window.corpsIcons[i]:UpdateCorpsScore(scoreInfo[i], totalScore)
    end
  end
  local function OnUpdateTime(self, dt)
    if timeHudWindow.remainTime <= 0 then
      return
    end
    if oldTime ~= timeHudWindow.remainTime then
      oldTime = timeHudWindow.remainTime
      timeHudWindow:UpdateTime(oldTime)
    end
  end
  function window:FillInstantTimeInfo()
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "STARTED" then
      window:HideMiniScoreboard()
      return
    end
    timeHudWindow.remainTime = tonumber(timeInfo.remainTime)
    if timeHudWindow:HasHandler("OnUpdate") == false then
      timeHudWindow:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  local events = {
    INSTANT_GAME_END = function()
      window:HideMiniScoreboard()
    end,
    INSTANT_GAME_RETIRE = function()
      window:HideMiniScoreboard()
    end,
    UPDATE_INSTANT_GAME_SCORES = function()
      local info = X2BattleField:GetProgressScoreInfo()
      window:UpdateCorpsScore(info.scoreInfos, info.totalScore)
      timeHudWindow:UpdateSlaveCount(info.scoreSlaveCount)
    end,
    UPDATE_INSTANT_GAME_TIME = function()
      window:FillInstantTimeInfo()
    end,
    INSTANT_GAME_SCORE_SLAVE_COUNT = function(slaveCount)
      timeHudWindow:UpdateSlaveCount(slaveCount)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function ShowMiniScoreboard_VersusBattleShip(isShow)
  if battlefield.miniScoreboard == nil then
    battlefield.miniScoreboard = CreateMiniScoreboard("battlefield.miniScoreboard_VersersBattleShip", "UIParent")
    battlefield.miniScoreboard:EnableHidingIsRemove(true)
  end
  battlefield.miniScoreboard:Show(isShow)
  if isShow then
    local info = X2BattleField:GetProgressScoreInfo()
    battlefield.miniScoreboard:UpdateCorpsScore(info.scoreInfos, info.totalScore)
    battlefield.miniScoreboard:FillInstantTimeInfo()
  end
end
