local EVENT_ALARM = {
  JOINED = 1,
  READY = 2,
  COUNTDOWN = 3,
  ROUND_RESULT = 4,
  ENDED = 5,
  RETIRED = 6
}
local GetRemainTime = function()
  return battlefield.eventAlarm.remainTime
end
local OnAlphaAnimeEnd = function(self)
  if self.animState == nil then
    return
  end
  if self.animState == "start" then
    do
      local visibleTime = 0
      local function ShowResultAlarm(self, dt)
        visibleTime = visibleTime + dt
        if visibleTime < 4000 then
          return
        end
        self:ReleaseHandler("OnUpdate")
        self:SetAlphaAnimation(1, 0, 0.5, 0.5)
        self:SetStartAnimation(true, false)
        self.animState = "end"
      end
      if self:HasHandler("OnUpdate") == false then
        self:SetHandler("OnUpdate", ShowResultAlarm)
      end
    end
  elseif self.animState == "end" then
    self.animState = nil
    self:Show(false)
    if self.animStateEndedFunc ~= nil then
      self.animStateEndedFunc()
      self.animStateEndedFunc = nil
    end
  end
end
local function CreatePeopleWaiting()
  local widget = UIParent:CreateWidget("window", "peopleWaiting", "UIParent")
  widget:SetExtent(756, 145)
  widget:AddAnchor("TOP", "UIParent", 0, 50)
  widget:SetUILayer("system")
  local bottomBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  bottomBg:SetCoords(0, 0, 782, 128)
  bottomBg:SetExtent(757, 106)
  bottomBg:AddAnchor("BOTTOM", widget, 0, 0)
  bottomBg:SetRepeatCount(1)
  local decoBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  decoBg:SetCoords(782, 0, 129, 83)
  decoBg:SetExtent(90.299995, 58.1)
  decoBg:AddAnchor("TOP", widget, 0, 0)
  decoBg:SetRepeatCount(1)
  local decoIcon = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_READY, "artwork")
  decoIcon:SetCoords(0, 0, 68, 64)
  decoIcon:SetExtent(81.600006, 76.8)
  decoIcon:AddAnchor("CENTER", decoBg, -2, -3)
  decoIcon:SetRepeatCount(1)
  local effectDrawable = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_READY, "artwork")
  effectDrawable:SetTextureInfo("standby")
  effectDrawable:AddAnchor("CENTER", bottomBg, -3, -15)
  effectDrawable:SetRepeatCount(1)
  function widget:ShowWidget()
    widget:Show(true)
    bottomBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    bottomBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    bottomBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoIcon:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectFinalColor(1, 1, 1, 1, 1)
    effectDrawable:SetEffectPriority(1, "alpha", 0.3, 0.3)
    effectDrawable:SetEffectInitialColor(1, 1, 1, 1, 1)
    effectDrawable:SetEffectFinalColor(1, 1, 1, 1, 1)
    effectDrawable:SetStartEffect(true)
    widget:SetAlphaAnimation(0, 1, 0.5, 0.5)
    widget:SetStartAnimation(true, false)
  end
  widget:SetHandler("OnAlphaAnimeEnd", OnAlphaAnimeEnd)
  widget:Show(false)
  widget:Raise()
  return widget
end
local function CreateReadyTime()
  local widget = UIParent:CreateWidget("window", "readyTime", "UIParent")
  widget:SetExtent(310, 77.5)
  widget:AddAnchor("TOP", "UIParent", 0, 185)
  widget:SetUILayer("system")
  local readyTimeBg = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_TIME, "time", "background")
  readyTimeBg:AddAnchor("TOPLEFT", widget, "TOPLEFT", 0, 0)
  readyTimeBg:AddAnchor("BOTTOMRIGHT", widget, "BOTTOMRIGHT", 0, 0)
  local readyTimeText = widget:CreateChildWidget("textbox", "readyTimeText", 0, true)
  readyTimeText:SetExtent(175, FONT_SIZE.XXLARGE)
  readyTimeText.style:SetFontSize(FONT_SIZE.XXLARGE)
  readyTimeText.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(readyTimeText, FONT_COLOR.MEDIUM_YELLOW)
  readyTimeText:AddAnchor("LEFT", widget, "LEFT", 100, 12)
  readyTimeText:SetText(locale.battlefield.readyTime(1, 0))
  local function OnUpdateTime(self, dt)
    if battlefield.eventAlarm.state ~= "READY" then
      widget:ReleaseHandler("OnUpdate")
      widget:Show(false)
      return
    end
    if widget.oldTime ~= GetRemainTime() then
      widget.oldTime = GetRemainTime()
      local minute, second = GetMinuteSecondeFromSec(GetRemainTime())
      readyTimeText:SetText(locale.battlefield.readyTime(minute, second))
    end
  end
  function widget:ShowWidget()
    battlefield.eventAlarm[EVENT_ALARM.JOINED]:SetAlphaAnimation(1, 0, 0.5, 0.5)
    battlefield.eventAlarm[EVENT_ALARM.JOINED]:SetStartAnimation(true, false)
    battlefield.eventAlarm[EVENT_ALARM.JOINED].animState = "end"
    widget.oldTime = 0
    widget:Show(true)
    if widget:HasHandler("OnUpdate") == false then
      widget:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  widget:Show(false)
  widget:Raise()
  return widget
end
local function CreateCountDown()
  local widget = UIParent:CreateWidget("window", "countDown", "UIParent")
  widget:SetExtent(113, 103)
  widget:AddAnchor("TOP", "UIParent", 0, 182)
  widget:SetUILayer("system")
  local countDownBg = widget:CreateDrawable("ui/battlefield/bg_circle.dds", "count_bg", "background")
  countDownBg:AddAnchor("TOPLEFT", widget, "TOPLEFT", 0, 0)
  countDownBg:AddAnchor("BOTTOMRIGHT", widget, "BOTTOMRIGHT", 0, 0)
  countDownBg:Show(false)
  local countDown = {}
  for i = 0, 5 do
    local texturePath = ""
    local textureInfo = ""
    if i > 0 then
      texturePath = string.format("ui/battlefield/cont_%d.dds", i)
      textureInfo = string.format("count_%d", i)
    else
      texturePath = "ui/battlefield/war_start_image.dds"
      textureInfo = "war_start_image"
    end
    countDown[i] = widget:CreateEffectDrawable(texturePath, "overlay")
    countDown[i]:SetTextureInfo(textureInfo)
    countDown[i]:SetRepeatCount(1)
    if i > 0 then
      countDown[i]:AddAnchor("TOPLEFT", widget, "TOPLEFT", 20, 0)
    else
      countDown[i]:AddAnchor("TOP", widget, "TOP", 0, 0)
    end
    countDown[i]:Show(i == 0)
  end
  local warStartImage = widget:CreateDrawable("ui/battlefield/war_start.dds", "war_start", "background")
  warStartImage:AddAnchor("TOP", widget, "TOP", 0, 56)
  warStartImage:Show(false)
  local CountDownPhaseAnim = function(self)
    self:SetEffectPriority(1, "alpha", 0.3, 0.3)
    self:SetEffectInitialColor(1, 1, 1, 1, 0)
    self:SetEffectFinalColor(1, 1, 1, 1, 1)
    self:SetEffectScale(1, 1.5, 1, 1.5, 1)
    self:SetEffectInterval(1, 0.1)
    self:SetStartEffect(true)
    self:SetVisible(true)
  end
  local HidePhaseAnim = function(self)
    self:SetEffectPriority(1, "alpha", 0.3, 0.3)
    self:SetEffectInitialColor(1, 1, 1, 1, 0)
    self:SetEffectFinalColor(1, 1, 1, 1, 1)
    self:SetEffectScale(1, 0, 1, 0, 1)
    self:SetEffectInterval(1, 0.6)
    self:SetEffectPriority(2, "alpha", 0.3, 0.3)
    self:SetEffectInitialColor(2, 1, 1, 1, 1)
    self:SetEffectFinalColor(2, 1, 1, 1, 0)
    self:SetStartEffect(true)
    self:SetVisible(true)
  end
  local function OnUpdateTime(self, dt)
    widget.remainTime = widget.remainTime - dt
    local remainTime = math.floor(widget.remainTime / 1000)
    if remainTime < 0 then
      widget:ReleaseHandler("OnUpdate")
      widget:SetAlphaAnimation(1, 0, 0.3, 0.3)
      widget:SetStartAnimation(true, false)
      widget:Show(false)
      return
    end
    if widget.oldTime ~= remainTime then
      if widget.oldShowWidget ~= nil then
        widget.oldShowWidget:Show(false)
        widget.oldShowWidget = nil
      end
      if countDown[remainTime] ~= nil then
        countDown[remainTime]:Show(true)
        widget.oldShowWidget = countDown[remainTime]
        local isCountDownPhase = remainTime > 0
        if isCountDownPhase then
          CountDownPhaseAnim(countDown[remainTime])
          F_SOUND.PlayUISound(string.format("battlefield_%d_secound", remainTime), true)
        else
          HidePhaseAnim(countDown[remainTime])
          F_SOUND.PlayUISound("battlefield_start", true)
        end
        countDownBg:Show(isCountDownPhase)
        warStartImage:Show(not isCountDownPhase)
      end
      widget.oldTime = remainTime
    end
  end
  function widget:ShowWidget()
    widget:Show(true)
    widget.oldTime = 0
    widget.remainTime = GetRemainTime() * 1000
    widget.oldShowWidget = nil
    widget:SetAlphaAnimation(0, 1, 0.3, 0.3)
    widget:SetStartAnimation(true, false)
    if widget:HasHandler("OnUpdate") == false then
      widget:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  widget:Show(false)
  widget:Raise()
  return widget
end
local function CreateRoundResult()
  local widget = UIParent:CreateWidget("window", "roundResult", "UIParent")
  widget:SetExtent(756, 145)
  widget:AddAnchor("TOP", "UIParent", 0, 50)
  widget:SetUILayer("system")
  local bottomBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  bottomBg:SetCoords(0, 0, 782, 128)
  bottomBg:SetExtent(757, 106)
  bottomBg:AddAnchor("BOTTOM", widget, 0, 0)
  bottomBg:SetRepeatCount(1)
  local decoBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  decoBg:SetCoords(782, 0, 129, 83)
  decoBg:SetExtent(90.299995, 58.1)
  decoBg:AddAnchor("TOP", widget, 0, 0)
  decoBg:SetRepeatCount(1)
  local decoIcon = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_IN_PROGRESS, "artwork")
  decoIcon:SetCoords(0, 0, 68, 64)
  decoIcon:SetExtent(81.600006, 76.8)
  decoIcon:AddAnchor("CENTER", decoBg, -2, -3)
  decoIcon:SetRepeatCount(1)
  local effectDrawable = widget:CreateEffectDrawable("ui/font/image_text.dds", "artwork")
  function effectDrawable:SetRound(round)
    local color = {
      ConvertColor(174),
      ConvertColor(67),
      ConvertColor(53)
    }
    local coords = BATTLE_FIELD_ROUND_COUNT[round]
    self:SetCoords(coords[1], coords[2], coords[3], coords[4])
    self:SetExtent(coords[3], coords[4])
    self:SetEffectPriority(1, "alpha", 0.3, 0.3)
    self:SetEffectInitialColor(1, color[1], color[2], color[3], 1)
    self:SetEffectFinalColor(1, color[1], color[2], color[3], 1)
  end
  effectDrawable:SetRound(1)
  effectDrawable:SetRepeatCount(1)
  local effectRound = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ROUND, "artwork")
  effectRound:SetTextureInfo("round")
  effectRound:SetRepeatCount(1)
  local effectRoundResult = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ROUND_DRAW, "artwork")
  function effectRoundResult:SetRoundResult(result)
    if result == VS_LOSE then
      self:SetTexture(TEXTURE_PATH.BATTLEFIELD_ROUND_LOSE)
      self:SetTextureInfo("lose")
    elseif result == VS_DRAW then
      self:SetTexture(TEXTURE_PATH.BATTLEFIELD_ROUND_DRAW)
      self:SetTextureInfo("draw")
    else
      self:SetTexture(TEXTURE_PATH.BATTLEFIELD_ROUND_WIN)
      self:SetTextureInfo("win")
    end
    self:SetEffectPriority(1, "alpha", 0.3, 0.3)
    self:SetEffectInitialColor(1, 1, 1, 1, 1)
    self:SetEffectFinalColor(1, 1, 1, 1, 1)
  end
  effectRoundResult:SetRepeatCount(1)
  effectRoundResult:SetRoundResult(1)
  widget.animState = nil
  widget.animStateEndedFunc = nil
  function widget:ShowWidget()
    widget:Show(true)
    bottomBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    bottomBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    bottomBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoIcon:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectFinalColor(1, 1, 1, 1, 1)
    effectRound:SetEffectPriority(1, "alpha", 0.3, 0.3)
    effectRound:SetEffectInitialColor(1, 1, 1, 1, 1)
    effectRound:SetEffectFinalColor(1, 1, 1, 1, 1)
    effectDrawable:SetRound(battlefield.eventAlarm.resultRound)
    effectRoundResult:SetRoundResult(battlefield.eventAlarm.resultState)
    local startPos = bottomBg:GetWidth() / 2 - (effectDrawable:GetWidth() + effectRound:GetWidth() + effectRoundResult:GetWidth()) / 2
    local countPos = 0
    local rountPos = 0
    if ROUND_RESULT_STRING_ORDER.COUNT == 1 then
      countPos = startPos
      rountPos = countPos + effectDrawable:GetWidth()
    else
      rountPos = startPos
      countPos = rountPos + effectRound:GetWidth()
    end
    effectDrawable:RemoveAllAnchors()
    effectDrawable:AddAnchor("LEFT", bottomBg, countPos, -2)
    effectDrawable:SetVisible(true)
    effectDrawable:SetStartEffect(true)
    effectRound:RemoveAllAnchors()
    effectRound:AddAnchor("LEFT", bottomBg, rountPos, 0)
    effectRound:SetVisible(true)
    effectRound:SetStartEffect(true)
    effectRoundResult:RemoveAllAnchors()
    effectRoundResult:AddAnchor("RIGHT", bottomBg, "RIGHT", -startPos, 0)
    effectRoundResult:SetVisible(true)
    effectRoundResult:SetStartEffect(true)
    widget:SetAlphaAnimation(0, 1, 0.5, 0.5)
    widget:SetStartAnimation(true, false)
    widget.animState = "start"
  end
  widget:SetHandler("OnAlphaAnimeEnd", OnAlphaAnimeEnd)
  widget:Show(false)
  widget:Raise()
  return widget
end
local function CreateGameEnded()
  local widget = UIParent:CreateWidget("window", "gameEnded", "UIParent")
  widget:SetExtent(756, 145)
  widget:AddAnchor("TOP", "UIParent", 0, 50)
  widget:SetUILayer("system")
  local bottomBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  bottomBg:SetCoords(0, 0, 782, 128)
  bottomBg:SetExtent(757, 106)
  bottomBg:AddAnchor("BOTTOM", widget, 0, 0)
  bottomBg:SetRepeatCount(1)
  local decoBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  decoBg:SetCoords(782, 0, 129, 83)
  decoBg:SetExtent(90.299995, 58.1)
  decoBg:AddAnchor("TOP", widget, 0, 0)
  decoBg:SetRepeatCount(1)
  local decoIcon = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_READY, "artwork")
  decoIcon:SetCoords(0, 0, 68, 64)
  decoIcon:SetExtent(81.600006, 76.8)
  decoIcon:AddAnchor("CENTER", decoBg, -2, -3)
  decoIcon:SetRepeatCount(1)
  local effectDrawable = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_READY, "artwork")
  effectDrawable:SetTextureInfo("ended")
  effectDrawable:AddAnchor("CENTER", bottomBg, -3, -15)
  effectDrawable:SetRepeatCount(1)
  local endReasonText = widget:CreateChildWidget("label", "endReasonText", 0, true)
  endReasonText:Show(false)
  endReasonText:SetAutoResize(true)
  endReasonText:SetHeight(FONT_SIZE.LARGE)
  endReasonText:AddAnchor("TOP", effectDrawable, "BOTTOM", 0, -5)
  endReasonText.style:SetFontSize(FONT_SIZE.LARGE)
  endReasonText.style:SetShadow(true)
  ApplyTextColor(endReasonText, FONT_COLOR.GRAY)
  widget.animState = nil
  function widget.animStateEndedFunc()
    ShowScoreboard(true, true)
  end
  function endReasonText:SetEndReason(info)
    local ruleMode = X2BattleField:GetGameMode()
    if ruleMode == nil then
      return
    end
    local victoryFaction
    if ruleMode == 4 then
      local factionInfo = X2BattleField:GetVersusFactionInfo()
      if factionInfo == nil then
        return
      end
      for i = 1, #factionInfo do
        local victoryState = factionInfo[i].victoryState
        if victoryState ~= nil and victoryState == VS_WIN then
          victoryFaction = factionInfo[i].teamName
        end
      end
    end
    local reason = info.endReason
    if reason == BFER_TIMEOVER_COMPARE_KILL_COUNT or reason == BFER_TIMEOVER_COMPARE_ROUND_WIN_COUNT or reason == BFER_TIMEOVER_COMPARE_ALIVE or reason == BFER_TIMEOVER_DRAW or reason == BFER_UNEARNED_WIN or reason == BFER_TIMEOVER_COMPARE_SCORE then
      local str = locale.battlefield.alarmEndReason.timeover
      endReasonText:SetText(str)
      X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
    elseif reason == BFER_ACHIEVEMENT_KILL_COUNT then
      local winTeamName, count = GetWinTeamName(info)
      if ruleMode == 4 then
        winTeamName, count = GetWinFactionName(info, victoryFaction)
      end
      local str = locale.battlefield.alarmEndReason.killCount(winTeamName, count)
      endReasonText:SetText(str)
    elseif reason == BFER_ACHIEVEMENT_ROUND_WIN_COUNT then
      local winTeamName, count = GetWinTeamName(info)
      local str = locale.battlefield.alarmEndReason.roundWinCount(winTeamName, count)
      endReasonText:SetText(str)
    elseif reason == BFER_ACHIEVEMENT_KILL_CORPS_HEAD then
      local winTeamName = ruleMode == 4 and GetWinFactionName(info, victoryFaction) or GetWinTeamName(info)
      local str = locale.battlefield.alarmEndReason.killCorpsHead(winTeamName)
      endReasonText:SetText(str)
    else
      endReasonText:SetText("")
    end
    endReasonText:Show(true)
  end
  function widget:ShowWidget()
    local info = X2BattleField:GetProgressEntireInfo()
    if info == nil then
      return
    end
    widget:Show(true)
    endReasonText:SetEndReason(info)
    bottomBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    bottomBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    bottomBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoIcon:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectFinalColor(1, 1, 1, 1, 1)
    effectDrawable:SetEffectPriority(1, "alpha", 0.3, 0.3)
    effectDrawable:SetEffectInitialColor(1, 1, 1, 1, 1)
    effectDrawable:SetEffectFinalColor(1, 1, 1, 1, 1)
    widget:SetAlphaAnimation(0, 1, 0.5, 0.5)
    widget:SetStartAnimation(true, false)
    widget.animState = "start"
    F_SOUND.PlayUISound("battlefield_end", true)
  end
  widget:SetHandler("OnAlphaAnimeEnd", OnAlphaAnimeEnd)
  widget:Show(false)
  widget:Raise()
  return widget
end
local function CreateGameRetired()
  local widget = UIParent:CreateWidget("window", "gameRetired", "UIParent")
  widget:SetExtent(756, 145)
  widget:AddAnchor("TOP", "UIParent", 0, 50)
  widget:SetUILayer("system")
  local bottomBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  bottomBg:SetCoords(0, 0, 782, 128)
  bottomBg:SetExtent(757, 106)
  bottomBg:AddAnchor("BOTTOM", widget, 0, 0)
  bottomBg:SetRepeatCount(1)
  local decoBg = widget:CreateEffectDrawable(TEXTURE_PATH.ALARM_DECO, "background")
  decoBg:SetCoords(782, 0, 129, 83)
  decoBg:SetExtent(90.299995, 58.1)
  decoBg:AddAnchor("TOP", widget, 0, 0)
  decoBg:SetRepeatCount(1)
  local decoIcon = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_READY, "artwork")
  decoIcon:SetCoords(0, 0, 68, 64)
  decoIcon:SetExtent(81.600006, 76.8)
  decoIcon:AddAnchor("CENTER", decoBg, -2, -3)
  decoIcon:SetRepeatCount(1)
  local effectDrawable = widget:CreateEffectDrawable(TEXTURE_PATH.BATTLEFIELD_ALARM_READY, "artwork")
  effectDrawable:SetTextureInfo("ended")
  effectDrawable:AddAnchor("CENTER", bottomBg, -3, -15)
  effectDrawable:SetRepeatCount(1)
  local alarmText = widget:CreateChildWidget("label", "alarmText", 0, true)
  alarmText:Show(false)
  alarmText:SetAutoResize(true)
  alarmText:SetHeight(FONT_SIZE.LARGE)
  alarmText:AddAnchor("TOP", effectDrawable, "BOTTOM", 0, -5)
  alarmText.style:SetFontSize(FONT_SIZE.LARGE)
  alarmText.style:SetShadow(true)
  ApplyTextColor(alarmText, FONT_COLOR.GRAY)
  widget.animState = nil
  function widget.animStateEndedFunc()
    ShowScoreboard(true, true)
  end
  function alarmText:SetAlarmText()
    self:SetText(GetUIText(GRAVE_YARD_TEXT, "dead"))
    self:Show(true)
  end
  function widget:ShowWidget()
    widget:Show(true)
    alarmText:SetAlarmText()
    bottomBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    bottomBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    bottomBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoBg:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoBg:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoBg:SetEffectFinalColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectPriority(1, "alpha", 0.1, 0.1)
    decoIcon:SetEffectInitialColor(1, 1, 1, 1, 1)
    decoIcon:SetEffectFinalColor(1, 1, 1, 1, 1)
    effectDrawable:SetEffectPriority(1, "alpha", 0.3, 0.3)
    effectDrawable:SetEffectInitialColor(1, 1, 1, 1, 1)
    effectDrawable:SetEffectFinalColor(1, 1, 1, 1, 1)
    widget:SetAlphaAnimation(0, 1, 0.5, 0.5)
    widget:SetStartAnimation(true, false)
    widget.animState = "start"
    F_SOUND.PlayUISound("battlefield_end", true)
  end
  widget:SetHandler("OnAlphaAnimeEnd", OnAlphaAnimeEnd)
  widget:Show(false)
  widget:Raise()
  return widget
end
local TestTimeInfo = function()
  timeInfo = {
    state = "RETIRED",
    remainTime = 60000,
    curPlayRoundCount = 1,
    playRoundCount = 1
  }
  return timeInfo
end
local function CreateEventAlarm()
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil then
    return
  end
  if battlefield.eventAlarm ~= nil then
    return
  end
  battlefield.eventAlarm = {}
  battlefield.eventAlarm[EVENT_ALARM.JOINED] = CreatePeopleWaiting()
  battlefield.eventAlarm[EVENT_ALARM.READY] = CreateReadyTime()
  battlefield.eventAlarm[EVENT_ALARM.COUNTDOWN] = CreateCountDown()
  battlefield.eventAlarm[EVENT_ALARM.ROUND_RESULT] = CreateRoundResult()
  battlefield.eventAlarm[EVENT_ALARM.ENDED] = CreateGameEnded()
  battlefield.eventAlarm[EVENT_ALARM.RETIRED] = CreateGameRetired()
end
local function ShowEventAlarm(eventAlram)
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil then
    return
  end
  CreateEventAlarm()
  if battlefield.eventAlarm[eventAlram] == nil then
    return
  end
  battlefield.eventAlarm.state = timeInfo.state
  battlefield.eventAlarm.remainTime = tonumber(timeInfo.remainTime)
  battlefield.eventAlarm[eventAlram]:ShowWidget()
end
local function HideEventMsg()
  if battlefield.eventAlarm == nil then
    return
  end
  local DestroyEventAlarm = function(widget)
    if widget == nil then
      return
    end
    widget:ReleaseHandler("OnUpdate")
    widget:EnableHidingIsRemove(true)
    widget:Show(false)
  end
  DestroyEventAlarm(battlefield.eventAlarm[EVENT_ALARM.JOINED])
  DestroyEventAlarm(battlefield.eventAlarm[EVENT_ALARM.READY])
  DestroyEventAlarm(battlefield.eventAlarm[EVENT_ALARM.COUNTDOWN])
  DestroyEventAlarm(battlefield.eventAlarm[EVENT_ALARM.ROUND_RESULT])
  DestroyEventAlarm(battlefield.eventAlarm[EVENT_ALARM.ENDED])
  DestroyEventAlarm(battlefield.eventAlarm[EVENT_ALARM.RETIRED])
  battlefield.eventAlarm = nil
end
local FillInstantTimeInfo = function()
  if battlefield.eventAlarm == nil then
    return
  end
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil then
    return
  end
  battlefield.eventAlarm.state = timeInfo.state
  battlefield.eventAlarm.remainTime = tonumber(timeInfo.remainTime)
end
UIParent:SetEventHandler("UPDATE_INSTANT_GAME_TIME", FillInstantTimeInfo)
local function EnteredInstantGameZone(type)
  if type ~= nil and type == 0 then
    ShowEventAlarm(EVENT_ALARM.JOINED)
  end
end
UIParent:SetEventHandler("ENTERED_INSTANT_GAME_ZONE", EnteredInstantGameZone)
local function InstantGameStateReady()
  ShowEventAlarm(EVENT_ALARM.READY)
end
UIParent:SetEventHandler("INSTANT_GAME_READY", InstantGameStateReady)
local function InstantGameStateCountDown()
  ShowEventAlarm(EVENT_ALARM.COUNTDOWN)
end
UIParent:SetEventHandler("INSTANT_GAME_WAIT", InstantGameStateCountDown)
local function InstantGameStateRoundResult(resultState, resultRound)
  battlefield.eventAlarm.resultRound = resultRound
  battlefield.eventAlarm.resultState = resultState
  ShowEventAlarm(EVENT_ALARM.ROUND_RESULT)
end
UIParent:SetEventHandler("INSTANT_GAME_ROUND_RESULT", InstantGameStateRoundResult)
local function InstantGameStateEnded()
  ShowEventAlarm(EVENT_ALARM.ENDED)
end
UIParent:SetEventHandler("INSTANT_GAME_END", InstantGameStateEnded)
local function InstantGameStateRetired()
  ShowEventAlarm(EVENT_ALARM.RETIRED)
end
UIParent:SetEventHandler("INSTANT_GAME_RETIRE", InstantGameStateRetired)
local function EnteredLoading()
  HideEventMsg()
end
UIParent:SetEventHandler("ENTERED_LOADING", EnteredLoading)
local function LeftLoading()
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil then
    return
  end
  CreateEventAlarm()
  local eventAlarm
  battlefield.eventAlarm.state = timeInfo.state
  battlefield.eventAlarm.remainTime = tonumber(timeInfo.remainTime)
  if battlefield.eventAlarm.state == "JOINED" then
    eventAlarm = EVENT_ALARM.JOINED
  elseif battlefield.eventAlarm.state == "READY" then
    eventAlarm = EVENT_ALARM.READY
  elseif battlefield.eventAlarm.state == "COUNTDOWN" then
    eventAlarm = EVENT_ALARM.COUNTDOWN
  elseif battlefield.eventAlarm.state == "ROUND_RESULT" then
    eventAlarm = EVENT_ALARM.ROUND_RESULT
  elseif battlefield.eventAlarm.state == "ENDED" then
    eventAlarm = EVENT_ALARM.ENDED
  elseif battlefield.eventAlarm.state == "RETIRED" then
    eventAlarm = EVENT_ALARM.RETIRED
  end
  ShowEventAlarm(eventAlarm)
end
UIParent:SetEventHandler("LEFT_LOADING", LeftLoading)
UIParent:SetEventHandler("ENTERED_WORLD", LeftLoading)
