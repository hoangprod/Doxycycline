local SetViewOfMiniScoreboardOld = function(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  function window:MakeOriginWindowPos(reset)
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(290, 85)
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
  local totalScore = window:CreateChildWidget("label", "totalScore", 0, true)
  totalScore:SetWidth(window:GetWidth() - MARGIN.WINDOW_SIDE)
  totalScore:SetHeight(FONT_SIZE.SMALL)
  totalScore.style:SetAlign(ALIGN_LEFT)
  totalScore.style:SetFontSize(FONT_SIZE.SMALL)
  totalScore.style:SetShadow(true)
  totalScore:AddAnchor("TOPLEFT", window, 10, 10)
  ApplyTextColor(totalScore, FONT_COLOR.WHITE)
  local upline = CreateLine(totalScore, "TYPE1")
  upline:SetColor(1, 1, 1, 1)
  upline:AddAnchor("TOPLEFT", totalScore, "BOTTOMLEFT", 0, 4)
  upline:AddAnchor("TOPRIGHT", totalScore, "BOTTOMRIGHT", 0, 4)
  local scoreWH = {90, 19}
  local charScore = window:CreateChildWidget("label", "charScore", 0, true)
  charScore:SetWidth(scoreWH[1])
  charScore:SetHeight(scoreWH[2])
  charScore.style:SetAlign(ALIGN_CENTER)
  charScore.style:SetFontSize(FONT_SIZE.SMALL)
  charScore.style:SetShadow(true)
  charScore:AddAnchor("TOPLEFT", upline, "BOTTOMLEFT", 0, 0)
  ApplyTextColor(charScore, FONT_COLOR.SOFT_YELLOW)
  local npcScore = window:CreateChildWidget("label", "npcScore", 0, true)
  npcScore:SetWidth(scoreWH[1])
  npcScore:SetHeight(scoreWH[2])
  npcScore.style:SetAlign(ALIGN_CENTER)
  npcScore.style:SetFontSize(FONT_SIZE.SMALL)
  npcScore.style:SetShadow(true)
  npcScore:AddAnchor("TOPLEFT", charScore, "TOPRIGHT", 0, 0)
  ApplyTextColor(npcScore, FONT_COLOR.SOFT_YELLOW)
  local slaveScore = window:CreateChildWidget("label", "slaveScore", 0, true)
  slaveScore:SetWidth(scoreWH[1])
  slaveScore:SetHeight(scoreWH[2])
  slaveScore.style:SetAlign(ALIGN_CENTER)
  slaveScore.style:SetFontSize(FONT_SIZE.SMALL)
  slaveScore.style:SetShadow(true)
  slaveScore:AddAnchor("TOPLEFT", npcScore, "TOPRIGHT", 0, 0)
  ApplyTextColor(slaveScore, FONT_COLOR.SOFT_YELLOW)
  local downline = CreateLine(totalScore, "TYPE1")
  downline:SetColor(1, 1, 1, 1)
  downline:AddAnchor("TOPLEFT", totalScore, "BOTTOMLEFT", 0, 4 + scoreWH[2] + 3)
  downline:AddAnchor("TOPRIGHT", totalScore, "BOTTOMRIGHT", 0, 4 + scoreWH[2] + 3)
  local timeFrame = CreateTimeFrame(window, "miniScoreboard")
  timeFrame:AddAnchor("BOTTOM", window, -10, -7)
  timeFrame.time = 0
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
  local wndOneSideMargin = MARGIN.WINDOW_SIDE / 2
  local rankListBtn = window:CreateChildWidget("button", "rankListBtn", 0, true)
  rankListBtn:Enable(true)
  rankListBtn:SetExtent(20, 20)
  rankListBtn:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", -(2 + wndOneSideMargin), -wndOneSideMargin)
  ApplyButtonSkin(rankListBtn, BUTTON_CONTENTS.SEARCH)
  ButtonOnClickHandler(rankListBtn, ToggleCharRankListFunc)
  return window
end
local function CreateMiniScoreboardOld(id, parent)
  local window = SetViewOfMiniScoreboardOld(id, parent)
  local widget = window.winCondition[5]
  local function OnEnter()
    local str
    if window.victoryRankScope == nil then
      str = locale.battlefield.winConditionTip.timeoverScopeRank(0)
    else
      str = locale.battlefield.winConditionTip.timeoverScopeRank(window.victoryRankScope)
    end
    SetTargetAnchorTooltip(str, "TOPLEFT", widget, "BOTTOMLEFT", 3, 3)
  end
  widget:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeave)
  local dragWindow = window.dragWindow
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
    self.totalScore:SetText("")
    self.charScore:SetText("")
    self.npcScore:SetText("")
    self.slaveScore:SetText("")
    self.timeFrame.time = 0
    self.timeFrame:UpdateTime(0)
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
    if window:HasHandler("OnUpdate") == false then
      window:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  function window:FillInstantScoreInfo()
    local info = X2BattleField:GetProgressScoreInfo()
    self.totalScore:SetText(locale.battlefield.scoreRankInfo(info.myTotalScore, info.myRank))
    self.charScore:SetText(string.format("%s %d", locale.battlefield.scoreboard.participant, info.myCharScore))
    self.npcScore:SetText(string.format("%s %d", locale.battlefield.scoreboard.elimination, info.myNpcScore))
    self.slaveScore:SetText(string.format("%s %d", locale.battlefield.scoreboard.destruction, info.mySlaveScore))
  end
  function window:FillInstantGameInfo()
    self:FillInstantScoreInfo()
    local info = X2BattleField:GetProgressEntireInfo()
    self.victoryDefault = info.victoryDefault
    self.victoryRankScope = info.victoryRankScope
    self.victoryScore = info.victoryScore
    self.victoryKillCount = info.victoryKillCount
    self.victoryRoundWinCount = info.victoryRoundWinCount
    for i = 1, BATTLEFIELD_MAX_WIN_CONDITION_COUNT do
      window.winCondition[i]:Show(false)
    end
    window.winCondition[5]:Show(true)
    window.winCondition[5]:AddAnchor("BOTTOMLEFT", window, 10, -10)
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
      window:FillInstantScoreInfo()
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
function ShowMiniScoreboard_FreeForAllOld(isShow)
  if battlefield.miniScoreboard == nil then
    if isShow then
      battlefield.miniScoreboard = CreateMiniScoreboardOld("battlefield.miniScoreboard_FreeForAll", "UIParent")
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
local SetViewOfMiniScoreboard = function(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  function window:MakeOriginWindowPos(reset)
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(290, 85)
    if reset then
      window:AddAnchor("TOPRIGHT", parent, F_LAYOUT.CalcDontApplyUIScale(-280), 0)
    else
      window:AddAnchor("TOPRIGHT", parent, -280, 0)
    end
  end
  window:MakeOriginWindowPos()
  local sectionInfos = X2BattleField:GetMiniScoreBoardSectionInfos()
  local width = 230
  local height = 0
  local anchorTarget = window
  for i = 1, #sectionInfos do
    local section = W_CTRL.CreatePropertyViewer(sectionInfos[i], window, 230)
    if i == 1 then
      section:AddAnchor("TOPLEFT", anchorTarget, "TOPLEFT", 0, 0)
    else
      section:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, 0)
    end
    section:SetTitle(GetUIText(locale.battlefield.miniScoreBoard[sectionInfos[i]].category, locale.battlefield.miniScoreBoard[sectionInfos[i]].key))
    height = height + section:GetHeight()
    anchorTarget = section
  end
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureColor("alpha60")
  bg:AddAnchor("TOPLEFT", window, "TOPLEFT", 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", 0, 5)
  window:SetExtent(width, height)
  local dragWindow = window:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", window, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  dragWindow:EnableDrag(true)
  return window
end
local function CreateMiniScoreboard(id, parent)
  local window = SetViewOfMiniScoreboard(id, parent)
  local dragWindow = window.dragWindow
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
  end
  local RemainSoldierSetFunc = function(propertyWidget, value)
    propertyWidget.value:SetText(string.format("%d/%d", value.remain, value.count))
  end
  function window:FillVictoryConditions()
    if window.victoryConditions == nil then
      return
    end
    local conditions = X2BattleField:GetProgressVictoryConditionInfo()
    if window.victoryConditions:GetPropertyCount() == 0 and conditions.remainSoldiers ~= nil then
      window.victoryConditions:PushProperty("remainSoldiers", GetCommonText("remain_player"))
    end
    if conditions.remainSoldiers ~= nil then
      window.victoryConditions:SetPropertyValue("remainSoldiers", conditions.remainSoldiers, RemainSoldierSetFunc)
    end
  end
  local SafeAreaCurrentPhaseSetFunc = function(propertyWidget, value)
    propertyWidget.value:SetText(string.format("%d/%d", value.currentPhase, value.count))
  end
  local RemainTimeSetFunc = function(propertyWidget, value)
    local minute, second = GetMinuteSecondeFromSec(value)
    propertyWidget.value:SetText(string.format("%02d:%02d", minute, second))
  end
  local BattleFieldRemainTimeLayoutFunc = function(propertyWidget, name)
    ApplyTextColor(propertyWidget.value, FONT_COLOR.SOFT_YELLOW)
  end
  function window:FillProgressInfos()
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "STARTED" then
      window:HideMiniScoreboard()
      return
    end
    if window.progressInfos:GetPropertyCount() == 0 then
      if timeInfo.safeAreaRemainTime ~= nil then
        window.progressInfos:PushProperty("safeAreaPhaseInfos", GetUIText(BATTLE_FIELD_TEXT, "safe_area_phase"))
        window.progressInfos:PushProperty("safeAreaRemainTime", GetUIText(BATTLE_FIELD_TEXT, "safe_area_remain_time"))
      end
      window.progressInfos:PushProperty("remainTime", GetUIText(BATTLE_FIELD_TEXT, "finish_remain_time"), BattleFieldRemainTimeLayoutFunc, true)
    end
    if timeInfo.safeAreaRemainTime ~= nil then
      window.progressInfos:SetPropertyValue("safeAreaPhaseInfos", timeInfo.safeAreaPhaseInfos, SafeAreaCurrentPhaseSetFunc)
      window.progressInfos:SetPropertyValue("safeAreaRemainTime", timeInfo.safeAreaRemainTime, RemainTimeSetFunc)
    end
    window.progressInfos:SetPropertyValue("remainTime", timeInfo.remainTime, RemainTimeSetFunc)
  end
  local UpdateRetireTime = function(self, dt)
    self.runtimeRetireTime = self.runtimeRetireTime + dt
    local minute, second = GetMinuteSecondeFromSec(math.floor(self.runtimeRetireTime / 1000))
    self.value:SetText(string.format("%02d:%02d", minute, second))
  end
  local function RetireTimeSetFunc(propertyWidget, value)
    if propertyWidget.retireTime ~= value then
      propertyWidget.retireTime = value
      propertyWidget.runtimeRetireTime = value * 1000
    end
    if propertyWidget:HasHandler("OnUpdate") == false then
      propertyWidget:SetHandler("OnUpdate", UpdateRetireTime)
    end
  end
  local scoreColumnSettings = {
    score = {
      name = locale.battlefield.scoreboard.score,
      valueSetFunc = nil
    },
    characterKill = {
      name = locale.battlefield.scoreboard.kill,
      valueSetFunc = nil
    },
    npcKill = {
      name = locale.battlefield.scoreboard.elimination,
      valueSetFunc = nil
    },
    slaveKill = {
      name = locale.battlefield.scoreboard.destruction,
      valueSetFunc = nil
    },
    housingKill = {name = "housing", valueSetFunc = nil},
    transferKill = {name = "transfer", valueSetFunc = nil},
    mateKill = {name = "mate", valueSetFunc = nil},
    shipyardKill = {name = "shipyard", valueSetFunc = nil},
    death = {
      name = locale.battlefield.scoreboard.death,
      valueSetFunc = nil
    },
    retireTime = {
      name = GetUIText(INSTANT_GAME_TEXT, "retire_play_time"),
      valueSetFunc = RetireTimeSetFunc
    },
    rating = {
      name = GetUIText(BATTLE_FIELD_TEXT, "rating"),
      valueSetFunc = nil
    }
  }
  function window:FillMyRecords()
    if window.myRecords == nil then
      return
    end
    local info = X2BattleField:GetProgressScoreInfo()
    local scoreColumnInfo = X2BattleField:GetScoreColumnInfo()
    if window.myRecords:GetPropertyCount() == 0 then
      for idx = 1, #scoreColumnInfo do
        local settingData = scoreColumnSettings[scoreColumnInfo[idx]]
        window.myRecords:PushProperty(scoreColumnInfo[idx], settingData.name)
      end
    end
    for idx = 1, #scoreColumnInfo do
      local settingData = scoreColumnSettings[scoreColumnInfo[idx]]
      window.myRecords:SetPropertyValue(scoreColumnInfo[idx], info[scoreColumnInfo[idx]], settingData.valueSetFunc)
    end
  end
  function window:UpdateHeight()
    local height = 0
    if self.victoryConditions ~= nil then
      height = height + self.victoryConditions:GetHeight()
    end
    if self.progressInfos ~= nil then
      height = height + self.progressInfos:GetHeight()
    end
    if self.myRecords ~= nil then
      height = height + self.myRecords:GetHeight()
    end
    window:SetHeight(height)
  end
  function window:HideMiniScoreboard()
    self:ReleaseHandler("OnUpdate")
    self:Show(false)
  end
  local OnEndFadeOut = function()
    battlefield.miniScoreboard = nil
  end
  window:SetHandler("OnEndFadeOut", OnEndFadeOut)
  local events = {
    INSTANT_GAME_END = function()
      window:HideMiniScoreboard()
    end,
    INSTANT_GAME_RETIRE = function()
      window:HideMiniScoreboard()
    end,
    UPDATE_INSTANT_GAME_SCORES = function()
      window:FillMyRecords()
      window:FillVictoryConditions()
    end,
    UPDATE_INSTANT_GAME_TIME = function()
      window:FillProgressInfos()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function ShowMiniScoreboard_FreeForAll(isShow)
  if battlefield.miniScoreboard == nil then
    if isShow then
      battlefield.miniScoreboard = CreateMiniScoreboard("battlefield.miniScoreboard_FreeForAll", "UIParent")
      battlefield.miniScoreboard:Show(true)
      battlefield.miniScoreboard:EnableHidingIsRemove(true)
      AddUISaveHandlerByKey("battlefield_miniScoreboard", battlefield.miniScoreboard)
      battlefield.miniScoreboard:ApplyLastWindowOffset()
      battlefield.miniScoreboard:ResetInstantGame()
      battlefield.miniScoreboard:FillVictoryConditions()
      battlefield.miniScoreboard:FillProgressInfos()
      battlefield.miniScoreboard:FillMyRecords()
      battlefield.miniScoreboard:UpdateHeight()
    else
      return
    end
  elseif isShow then
    battlefield.miniScoreboard:Show(true)
    battlefield.miniScoreboard:ResetInstantGame()
    battlefield.miniScoreboard:FillVictoryConditions()
    battlefield.miniScoreboard:FillProgressInfos()
    battlefield.miniScoreboard:FillMyRecords()
    battlefield.miniScoreboard:UpdateHeight()
  else
    battlefield.miniScoreboard:HideMiniScoreboard()
  end
end
