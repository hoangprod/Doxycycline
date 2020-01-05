local SetViewOfMiniScoreboard = function(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  function window:MakeOriginWindowPos(reset)
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(270, 85)
    if reset then
      window:AddAnchor("TOPRIGHT", parent, F_LAYOUT.CalcDontApplyUIScale(-280), 0)
    else
      window:AddAnchor("TOPRIGHT", parent, -280, 0)
    end
  end
  window:MakeOriginWindowPos()
  local bg = CreateContentBackground(window, "TYPE2", "black")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local roundState = window:CreateChildWidget("label", "roundState", 0, true)
  roundState:SetAutoResize(true)
  roundState:SetHeight(FONT_SIZE.MIDDLE)
  roundState:AddAnchor("TOP", window, 0, MARGIN.WINDOW_SIDE / 1.5)
  roundState.style:SetFontSize(FONT_SIZE.MIDDLE)
  roundState.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(roundState, FONT_COLOR.WHITE)
  local nameTeam_1 = window:CreateChildWidget("label", "nameTeam_1", 0, true)
  nameTeam_1:SetAutoResize(true)
  nameTeam_1:SetHeight(FONT_SIZE.SMALL)
  nameTeam_1:AddAnchor("TOPRIGHT", window, -(MARGIN.WINDOW_SIDE / 1.5), MARGIN.WINDOW_SIDE / 1.5)
  nameTeam_1.style:SetFontSize(FONT_SIZE.SMALL)
  nameTeam_1.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(nameTeam_1, FONT_COLOR.BATTLEFIELD_RED)
  local nameTeam_2 = window:CreateChildWidget("label", "nameTeam_2", 0, true)
  nameTeam_2:SetAutoResize(true)
  nameTeam_2:SetHeight(FONT_SIZE.SMALL)
  nameTeam_2:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE / 1.5, MARGIN.WINDOW_SIDE / 1.5)
  nameTeam_2.style:SetFontSize(FONT_SIZE.SMALL)
  nameTeam_2.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(nameTeam_2, FONT_COLOR.BATTLEFIELD_BLUE)
  local gauge = W_BAR.CreateDoubleGauge(window:GetId() .. ".gauge", window)
  gauge:SetExtent(245, 9)
  gauge:AddAnchor("TOPLEFT", nameTeam_2, "BOTTOMLEFT", 0, 5)
  gauge:SetLayout("small")
  window.gauge = gauge
  local deco = gauge:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "mini_score_board_deco", "overlay")
  deco:AddAnchor("TOPLEFT", gauge, -1, -1)
  deco:AddAnchor("BOTTOMRIGHT", gauge, 1, 2)
  local scoreTeam_1 = window:CreateChildWidget("label", "scoreTeam_1", 0, true)
  scoreTeam_1:SetAutoResize(true)
  scoreTeam_1:SetHeight(FONT_SIZE.SMALL)
  scoreTeam_1:AddAnchor("TOPRIGHT", gauge, "BOTTOMRIGHT", 0, MARGIN.WINDOW_SIDE / 4.5)
  scoreTeam_1.style:SetFontSize(FONT_SIZE.SMALL)
  scoreTeam_1.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(scoreTeam_1, FONT_COLOR.BATTLEFIELD_RED)
  local scoreTeam_2 = window:CreateChildWidget("label", "scoreTeam_2", 0, true)
  scoreTeam_2:SetAutoResize(true)
  scoreTeam_2:SetHeight(FONT_SIZE.SMALL)
  scoreTeam_2:AddAnchor("TOPLEFT", gauge, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 4.5)
  scoreTeam_2.style:SetFontSize(FONT_SIZE.SMALL)
  scoreTeam_2.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(scoreTeam_2, FONT_COLOR.BATTLEFIELD_BLUE)
  local timeFrame = CreateTimeFrame(window, "miniScoreboard")
  timeFrame:AddAnchor("BOTTOM", window, 0, -7)
  timeFrame.time = 0
  window.myTeam = BATTLEFIELD_TEAM.NONE
  local dragWindow = window:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", window, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  dragWindow:EnableDrag(true)
  for i = 1, BATTLEFIELD_MAX_WIN_CONDITION_COUNT do
    local winCondition = window:CreateChildWidget("emptywidget", "winCondition", i, true)
    winCondition:Show(false)
    local bg = CreateWinConditionIcon(winCondition, BATTLEFIELD_MAX_WIN_CONDITIONS_TYPE[i])
    bg:AddAnchor("CENTER", winCondition, 0, 0)
    winCondition:SetExtent(16, 16)
  end
  return window
end
local function CreateMiniScoreboard(id, parent)
  local window = SetViewOfMiniScoreboard(id, parent)
  local dragWindow = window.dragWindow
  for i = 1, BATTLEFIELD_MAX_WIN_CONDITION_COUNT do
    do
      local widget = window.winCondition[i]
      local function OnEnter()
        local str
        if i == 1 then
          if window.victoryScore ~= nil then
            str = locale.battlefield.winConditionTip.victoryScore(window.victoryScore)
          end
        elseif i == 2 then
          if window.victoryKillCount ~= nil then
            str = locale.battlefield.winConditionTip.victoryKillCount(window.victoryKillCount)
          end
        elseif i == 3 then
          if window.victoryRoundWinCount ~= nil then
            str = locale.battlefield.winConditionTip.victoryRoundWinCount(window.victoryRoundWinCount)
          end
        elseif i == 4 then
          str = locale.battlefield.winConditionTip.victoryTarget
        else
          str = locale.battlefield.winConditionTip.timeover
        end
        SetTargetAnchorTooltip(str, "TOPLEFT", widget, "BOTTOMLEFT", 3, 3)
      end
      widget:SetHandler("OnEnter", OnEnter)
      local OnLeave = function()
        HideTooltip()
      end
      widget:SetHandler("OnLeave", OnLeave)
    end
  end
  function window:SetWinCondition(score, killCount, roundWinCount, destruction, timeOut)
    for i = 1, BATTLEFIELD_MAX_WIN_CONDITION_COUNT do
      window.winCondition[i]:Show(false)
    end
    local target
    if score ~= nil and score > 0 then
      window.winCondition[1]:Show(true)
      if target == nil then
        window.winCondition[1]:AddAnchor("BOTTOMLEFT", window, 10, -10)
      end
      target = window.winCondition[1]
    end
    if killCount ~= nil and killCount > 0 then
      window.winCondition[2]:Show(true)
      if target == nil then
        window.winCondition[2]:AddAnchor("BOTTOMLEFT", window, 10, -10)
      else
        window.winCondition[2]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.winCondition[2]
    end
    if roundWinCount ~= nil and roundWinCount > 0 then
      window.winCondition[3]:Show(true)
      if target == nil then
        window.winCondition[3]:AddAnchor("BOTTOMLEFT", window, 10, -10)
      else
        window.winCondition[3]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.winCondition[3]
    end
    if destruction then
      window.winCondition[4]:Show(true)
      if target == nil then
        window.winCondition[4]:AddAnchor("BOTTOMLEFT", window, 10, -10)
      else
        window.winCondition[4]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.winCondition[4]
    end
    if timeOut then
      window.winCondition[5]:Show(true)
      if target == nil then
        window.winCondition[5]:AddAnchor("BOTTOMLEFT", window, 10, -10)
      else
        window.winCondition[5]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.winCondition[5]
    end
  end
  local function OnDragStart(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    window:StartMoving()
    self.moving = true
  end
  dragWindow:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop(self)
    if self.moving == true then
      window:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  dragWindow:SetHandler("OnDragStop", OnDragStop)
  function window:ResetInstantGame()
    self.roundState:SetText("")
    self.nameTeam_1:SetText("")
    self.nameTeam_2:SetText("")
    self.scoreTeam_1:SetText("0")
    self.scoreTeam_2:SetText("0")
    self.timeFrame.time = 0
    self.timeFrame:UpdateTime(0)
    self.myTeam = BATTLEFIELD_TEAM.NONE
  end
  local oldTime = 0
  local function OnUpdateTime(self, dt)
    if window.remainTime < 0 then
      return
    end
    if oldTime ~= window.remainTime then
      oldTime = window.remainTime
      window.timeFrame:UpdateTime(oldTime)
    end
  end
  function window:FillInstantTimeInfo()
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "STARTED" then
      window:HideMiniScoreboard()
      return
    end
    window.remainTime = tonumber(timeInfo.remainTime)
    window.curPlayRound = tonumber(timeInfo.curPlayRoundCount)
    window.maxPlayRound = tonumber(timeInfo.playRoundCount)
    if window.maxPlayRound > 1 then
      self.roundState:SetText(locale.battlefield.roundInfo(window.curPlayRound, window.maxPlayRound))
    end
    if window:HasHandler("OnUpdate") == false then
      window:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  function window:FillInstantScoreInfo(scoreTeam_1, scoreTeam_2)
    self.scoreTeam_1:SetText(tostring(scoreTeam_1))
    self.scoreTeam_2:SetText(tostring(scoreTeam_2))
  end
  function window:FillInstantGameInfo()
    local info = X2BattleField:GetProgressEntireInfo()
    if info == nil then
      return
    end
    if X2Unit:GetFactionName("player") == info.corpsName1 then
      self.myTeam = BATTLEFIELD_TEAM.FIRST
    elseif X2Unit:GetFactionName("player") == info.corpsName2 then
      self.myTeam = BATTLEFIELD_TEAM.SECOND
    end
    self.nameTeam_1:SetText(info.corpsName1)
    self.nameTeam_2:SetText(info.corpsName2)
    self.victoryDefault = info.victoryDefault
    self.victoryScore = info.victoryScore
    self.victoryKillCount = info.victoryKillCount
    self.victoryRoundWinCount = info.victoryRoundWinCount
    local isDesturtion = info.victoryTarget ~= 0
    if info.victoryDefault == 2 then
      self:FillInstantScoreInfo(info.roundWinCount1, info.roundWinCount2)
      self.gauge:UpdateScore(info.roundWinCount1, info.roundWinCount2)
    else
      self:FillInstantScoreInfo(info.killScore1, info.killScore2)
      self.gauge:UpdateScore(info.killScore1, info.killScore2)
    end
    self:SetWinCondition(self.victoryScore, self.victoryKillCount, self.victoryRoundWinCount, isDesturtion, true)
  end
  function window:HideMiniScoreboard()
    self:ReleaseHandler("OnUpdate")
    self:Show(false)
  end
  local OnHideMiniScoreboard = function()
    battlefield.miniScoreboard = nil
  end
  window:SetHandler("OnHide", OnHideMiniScoreboard)
  local events = {
    INSTANT_GAME_END = function()
      window:HideMiniScoreboard()
    end,
    INSTANT_GAME_RETIRE = function()
      window:HideMiniScoreboard()
    end,
    UPDATE_INSTANT_GAME_SCORES = function()
      local victoryInfo = X2BattleField:GetProgressVictoryConditionInfo()
      local scoreInfo = X2BattleField:GetProgressScoreInfo()
      if victoryInfo.victoryDefault == 2 then
        window.gauge:UpdateScore(scoreInfo.roundWinCount1, scoreInfo.roundWinCount2)
        window:FillInstantScoreInfo(scoreInfo.roundWinCount1, scoreInfo.roundWinCount2)
      else
        window.gauge:UpdateScore(scoreInfo.killScore1, scoreInfo.killScore2)
        window:FillInstantScoreInfo(scoreInfo.killScore1, scoreInfo.killScore2)
      end
    end,
    UPDATE_INSTANT_GAME_TIME = function()
      window:FillInstantTimeInfo()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function ShowMiniScoreboard_Versus(isShow)
  if battlefield.miniScoreboard == nil then
    if isShow then
      battlefield.miniScoreboard = CreateMiniScoreboard("battlefield.miniScoreboard_Versus", "UIParent")
      battlefield.miniScoreboard:Show(true)
      battlefield.miniScoreboard:EnableHidingIsRemove(true)
      AddUISaveHandlerByKey("battlefield_miniScoreboard", battlefield.miniScoreboard)
      battlefield.miniScoreboard:ApplyLastWindowOffset()
      battlefield.miniScoreboard:ResetInstantGame()
      battlefield.miniScoreboard:FillInstantGameInfo()
      battlefield.miniScoreboard:FillInstantTimeInfo()
    else
      return
    end
  elseif isShow then
    battlefield.miniScoreboard:Show(true)
    battlefield.miniScoreboard:ResetInstantGame()
    battlefield.miniScoreboard:FillInstantGameInfo()
    battlefield.miniScoreboard:FillInstantTimeInfo()
  else
    battlefield.miniScoreboard:HideMiniScoreboard()
  end
end
