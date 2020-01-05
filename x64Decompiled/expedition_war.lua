local EXPEDITION_WAR_ICON_TEXTURE = {
  start = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_START_ICON,
    name = "battle_icon"
  },
  ongoing = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_START_ICON,
    name = "battle_icon"
  },
  win = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_WIN_ICON,
    name = "bugle"
  },
  lost = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_LOST_ICON,
    name = "lose"
  },
  tied = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_START_ICON,
    name = "tied"
  },
  result = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_WIN_ICON,
    name = "bugle"
  }
}
local EXPEDITION_WAR_TEXT_TEXTURE = {
  start = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_START_TEXT,
    name = "battle_start"
  },
  ongoing = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_ON_GOING_TEXT,
    name = "battle_ing"
  },
  win = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_WIN_TEXT,
    name = "battle_win_text"
  },
  lost = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_LOST_TEXT,
    name = "battle_lose_text"
  },
  tied = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_DRAW_TEXT,
    name = "draw"
  },
  result = {
    texture = TEXTURE_PATH.EXPEDITION_WAR_RESULT_TEXT,
    name = "battle_result_text"
  }
}
local function CreateExpeditionWarConditionMessageWindow(id, parent)
  local wnd = CreateCenterMessageFrame(id, parent, "TYPE1")
  wnd:SetExtent(946, 190)
  wnd.bg:SetExtent(782, 128)
  wnd.iconBg:RemoveAllAnchors()
  wnd.iconBg:AddAnchor("TOP", wnd, 0, 10)
  wnd.icon:SetTexture(EXPEDITION_WAR_ICON_TEXTURE.start.texture)
  wnd.icon:SetTextureInfo(EXPEDITION_WAR_ICON_TEXTURE.start.name)
  wnd.icon:SetVisible(true)
  local textIcon = wnd:CreateDrawable(EXPEDITION_WAR_TEXT_TEXTURE.start.texture, EXPEDITION_WAR_TEXT_TEXTURE.start.name, "artwork")
  textIcon:AddAnchor("TOP", wnd.iconBg, "BOTTOM", 0, -10)
  textIcon:SetVisible(true)
  textIcon:SetExtent(946, 52)
  wnd.textIcon = textIcon
  wnd.body:RemoveAllAnchors()
  wnd.body:SetExtent(946, FONT_SIZE.XLARGE)
  wnd.body:AddAnchor("TOP", textIcon, "BOTTOM", 0, 0)
  wnd.body.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(wnd.body, FONT_COLOR.WHITE)
  local vsText = wnd:CreateChildWidget("textbox", "vsText", 0, true)
  vsText:SetExtent(946, FONT_SIZE.XLARGE)
  vsText:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  vsText.style:SetFontSize(FONT_SIZE.LARGE)
  vsText.style:SetShadow(true)
  vsText.style:SetAlign(ALIGN_CENTER)
  vsText:Clickable(false)
  ApplyTextColor(vsText, FONT_COLOR.WHITE)
  vsText:SetText("vs")
  vsText:SetHeight(vsText:GetTextHeight())
  local declarerText = wnd:CreateChildWidget("textbox", "declarerText", 0, true)
  declarerText:SetExtent(946, FONT_SIZE.XLARGE)
  declarerText:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  declarerText.style:SetFontSize(FONT_SIZE.LARGE)
  declarerText.style:SetShadow(true)
  declarerText.style:SetAlign(ALIGN_RIGHT)
  declarerText:Clickable(false)
  ApplyTextColor(wnd.declarerText, FONT_COLOR.EXPEDITION_WAR_DECLARER)
  local defendantText = wnd:CreateChildWidget("textbox", "defendantText", 0, true)
  defendantText:SetExtent(946, FONT_SIZE.XLARGE)
  defendantText:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  defendantText.style:SetFontSize(FONT_SIZE.LARGE)
  defendantText.style:SetShadow(true)
  defendantText.style:SetAlign(ALIGN_LEFT)
  defendantText:Clickable(false)
  ApplyTextColor(wnd.defendantText, FONT_COLOR.EXPEDITION_WAR_DEFENDANT)
  local declarerIcon = wnd:CreateDrawable(TEXTURE_PATH.EXPEDITION_WAR_RESULT_ICON, "win", "artwork")
  declarerIcon:SetVisible(true)
  wnd.declarerIcon = declarerIcon
  local defendantIcon = wnd:CreateDrawable(TEXTURE_PATH.EXPEDITION_WAR_RESULT_ICON, "win", "artwork")
  defendantIcon:SetVisible(true)
  wnd.defendantIcon = defendantIcon
  function wnd:OnUpdate(dt)
    if self.delay < 3000 then
      self.delay = self.delay + dt
      return
    end
    self.delay = 0
    self:Show(false, 300)
    self:ReleaseHandler("OnUpdate")
  end
  function wnd:OnEndFadeOut()
    StartNextImgEvent()
  end
  local function SetAnchor(result, declarer, winner)
    vsText:RemoveAllAnchors()
    declarerText:RemoveAllAnchors()
    defendantText:RemoveAllAnchors()
    declarerIcon:RemoveAllAnchors()
    defendantIcon:RemoveAllAnchors()
    if result then
      if declarer == winner then
        declarerIcon:SetTextureInfo("win")
        defendantIcon:SetTextureInfo("lose")
      else
        declarerIcon:SetTextureInfo("lose")
        defendantIcon:SetTextureInfo("win")
      end
      vsText:AddAnchor("TOP", textIcon, "BOTTOM", 0, 0)
      declarerIcon:SetVisible(true)
      defendantIcon:SetVisible(true)
      declarerIcon:AddAnchor("RIGHT", vsText, "CENTER", -7, 0)
      defendantIcon:AddAnchor("LEFT", vsText, "CENTER", 7, 0)
      declarerText:AddAnchor("RIGHT", declarerIcon, "LEFT", 0, 0)
      defendantText:AddAnchor("LEFT", defendantIcon, "RIGHT", 0, 0)
    else
      vsText:AddAnchor("TOP", wnd.body, "BOTTOM", 0, 5)
      declarerText:AddAnchor("RIGHT", vsText, "CENTER", -15, 0)
      defendantText:AddAnchor("LEFT", vsText, "CENTER", 15, 0)
      declarerIcon:SetVisible(false)
      defendantIcon:SetVisible(false)
    end
  end
  local SetInfoEachState = {
    start = function()
      wnd.body:SetText(GetCommonText("expedition_war_start"))
      SetAnchor(false)
    end,
    ongoing = function()
      wnd.body:SetText(GetCommonText("expedition_war_ongoing"))
      SetAnchor(false)
    end,
    win = function(declarer, defendant, winner)
      wnd.body:SetText("")
      SetAnchor(true, declarer, winner)
    end,
    lost = function(declarer, defendant, winner)
      wnd.body:SetText("")
      SetAnchor(true, declarer, winner)
    end,
    tied = function()
      wnd.body:SetText(GetCommonText("expedition_war_tied"))
      SetAnchor(false)
    end,
    result = function(declarer, defendant, winner)
      wnd.body:SetText("")
      SetAnchor(true, declarer, winner)
    end
  }
  function wnd:SetInfo(state, declarer, defendant, winner)
    self.delay = 0
    wnd.icon:SetTexture(EXPEDITION_WAR_ICON_TEXTURE[state].texture)
    wnd.icon:SetTextureInfo(EXPEDITION_WAR_ICON_TEXTURE[state].name)
    wnd.textIcon:SetTexture(EXPEDITION_WAR_TEXT_TEXTURE[state].texture)
    wnd.textIcon:SetTextureInfo(EXPEDITION_WAR_TEXT_TEXTURE[state].name)
    wnd.declarerText:SetText(declarer)
    wnd.defendantText:SetText(defendant)
    SetInfoEachState[state](declarer, defendant, winner)
    wnd.body:SetHeight(wnd.body:GetTextHeight())
    wnd:Show(true)
    wnd:SetHandler("OnUpdate", wnd.OnUpdate)
    if not wnd:HasHandler("OnEndFadeOut") then
      wnd:SetHandler("OnEndFadeOut", wnd.OnEndFadeOut)
    end
  end
  return wnd
end
local conditionMsgWnd = CreateExpeditionWarConditionMessageWindow("expeditionWarConditionMsgWnd", "UIParent")
conditionMsgWnd:Show(false)
function ExpeditionWarConditionWindowSetInfo(state, declarer, defendant, winner)
  conditionMsgWnd:SetInfo(state, declarer, defendant, winner)
  return true
end
local events = {
  EXPEDITION_WAR_STATE = function(_, state, declarer, defendant, winner)
    local imgEventInfo = MakeImgEventInfo("EXPEDITION_WAR_STATE", ExpeditionWarConditionWindowSetInfo, {
      state,
      declarer,
      defendant,
      winner
    })
    AddImgEventQueue(imgEventInfo)
  end
}
conditionMsgWnd:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(conditionMsgWnd, events)
local scoreDataCache = {}
function CreateExpeditionWarScoreboard(id, parent)
  local frame = SetViewOfExpeditionWarScoreBoard(id, parent)
  local oldTime = 0
  local OnUpdateTime = function(self, dt)
    self.remainTime = self.remainTime - dt
    if self.remainTime <= 0 then
      self.timeFrame.leaveTitle:SetText(X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "battle_close"))
      self.tooltipButton:Show(false)
      self.timeFrame:UpdateTime(0)
      if self:HasHandler("OnUpdate") == true then
        self:ReleaseHandler("OnUpdate")
      end
    else
      self.timeFrame:UpdateTime(self.remainTime / 1000)
    end
  end
  local function FillRemainTime()
    frame.remainTime = X2Faction:GetRemainTimeExpeditionWar() * 1000
    if frame:HasHandler("OnUpdate") == false then
      frame:SetHandler("OnUpdate", OnUpdateTime)
    end
    if frame.remainTime == 0 then
      frame.timeFrame.leaveTitle:SetText(X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "battle_close"))
      frame.tooltipButton:Show(false)
      frame.timeFrame:UpdateTime(0)
      if frame:HasHandler("OnUpdate") == true then
        frame:ReleaseHandler("OnUpdate")
      end
    else
      frame.timeFrame.leaveTitle:SetText(X2Locale:LocalizeUiText(TOOLTIP_TEXT, "left_time"))
      frame.tooltipButton:Show(true)
      if frame:HasHandler("OnUpdate") == false then
        frame:SetHandler("OnUpdate", OnUpdateTime)
      end
    end
  end
  local function ResetResult()
    frame.gaugeFrame.leftTeamName:SetText("")
    frame.gaugeFrame.rightTeamName:SetText("")
    frame.gaugeFrame.leftScore:SetText("0")
    frame.gaugeFrame.rightScore:SetText("0")
    frame.scoreboardOur:DeleteAllDatas()
    frame.scoreboardEnemy:DeleteAllDatas()
  end
  local function FillScoreInfo(sb, data, idx)
    if data == nil then
      return
    end
    local name = data.name
    local ability0 = data.ability0
    local ability1 = data.ability1
    local ability2 = data.ability2
    if string.len(data.name) <= 0 then
      if scoreDataCache[data.id] ~= nil then
        name = scoreDataCache[data.id].name
        ability0 = scoreDataCache[data.id].ability0
        ability1 = scoreDataCache[data.id].ability1
        ability2 = scoreDataCache[data.id].ability2
      end
    else
      scoreDataCache[data.id] = {}
      scoreDataCache[data.id].name = name
      scoreDataCache[data.id].ability0 = ability0
      scoreDataCache[data.id].ability1 = ability1
      scoreDataCache[data.id].ability2 = ability2
    end
    if string.len(name) <= 0 then
      name = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "offline")
    end
    sb:InsertData(idx, 1, name)
    sb:InsertData(idx, 2, F_UNIT.GetCombinedAbilityName(ability0, ability1, ability2))
    sb:InsertData(idx, 3, tostring(data.kills))
  end
  function frame:FillResult()
    ResetResult()
    local ourTotalKill, ourKillScore, enemyTotalKill, enemyKillScore = X2Faction:GetExpeditionWarKillScore()
    if ourKillScore ~= nil then
      for i = 1, #ourKillScore do
        FillScoreInfo(frame.scoreboardOur, ourKillScore[i], i)
      end
    end
    if enemyKillScore ~= nil then
      for i = 1, #enemyKillScore do
        FillScoreInfo(frame.scoreboardEnemy, enemyKillScore[i], i)
      end
    end
    frame.gaugeFrame.leftTeamName:SetText(X2Faction:GetFactionName(X2Faction:GetMyExpeditionId(), false) or "")
    frame.gaugeFrame.rightTeamName:SetText(X2Faction:GetFactionName(X2Faction:GetEnemyExpedition(), false) or "")
    frame.gaugeFrame.leftScore:SetText(tostring(ourTotalKill))
    frame.gaugeFrame.rightScore:SetText(tostring(enemyTotalKill))
    frame.gaugeFrame.gauge:UpdateScore(enemyTotalKill, ourTotalKill)
    FillRemainTime()
  end
  function frame:HideScoreboard()
    self:ReleaseHandler("OnUpdate")
    self:Show(false)
  end
  local function OnHideScoreboard()
    conditionMsgWnd.scoreboard = nil
  end
  frame:SetHandler("OnHide", OnHideScoreboard)
  return frame
end
function ShowExpeditionWarKillScoreBoard(toggle)
  if toggle then
    if conditionMsgWnd.scoreboard == nil then
      conditionMsgWnd.scoreboard = CreateExpeditionWarScoreboard("conditionMsgWnd.scoreboard", "UIParent")
      conditionMsgWnd.scoreboard:EnableHidingIsRemove(true)
      conditionMsgWnd.scoreboard:Show(true)
      conditionMsgWnd.scoreboard:FillResult()
    else
      conditionMsgWnd.scoreboard:Show(false)
    end
  elseif conditionMsgWnd.scoreboard ~= nil then
    conditionMsgWnd.scoreboard:Show(true)
    conditionMsgWnd.scoreboard:FillResult()
  end
end
local ExpeditionWarKillScoreEvent = function(toggle)
  ShowExpeditionWarKillScoreBoard(toggle)
end
local FormatRemainTime = function(msec)
  local timeStr = ""
  local key = ""
  if not (msec >= 0) or not msec then
    msec = 0
  end
  if msec >= 86400000 then
    timeStr = tostring(math.floor(msec / 86400000))
    key = "day"
  elseif msec >= 3600000 then
    timeStr = tostring(math.ceil(msec / 3600000))
    key = "hour"
  elseif msec >= 60000 then
    timeStr = tostring(math.ceil(msec / 60000))
    key = "minute"
  elseif msec >= 0 then
    timeStr = tostring(math.ceil(msec / 1000))
    key = "second"
  end
  return X2Locale:LocalizeUiText(TIME, key, timeStr)
end
local function ExpeditionWarDeclarationFailedEvent(errorMsg, param)
  local timeStr = FormatRemainTime(param * 1000)
  AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, string.upper(errorMsg), timeStr))
end
UIParent:SetEventHandler("EXPEDITION_WAR_KILL_SCORE", ExpeditionWarKillScoreEvent)
UIParent:SetEventHandler("EXPEDITION_WAR_DECLARATION_FAILED", ExpeditionWarDeclarationFailedEvent)
