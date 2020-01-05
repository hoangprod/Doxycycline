local IS_NO_NPC_TARGET = false
local function SetMiniScoreboardVersusFactionType()
  local info = X2BattleField:GetProgressEntireInfo()
  if info == nil then
    return
  end
  IS_NO_NPC_TARGET = info.victoryTarget == 0
end
local CreateIcon = function(id, parent, key)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  window:SetExtent(230, 57)
  local cunstomInfo = {
    path = TEXTURE_PATH.SIEGE_HP_BAR,
    textureKey = "siege_gauge",
    coords = {
      GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetCoords()
    }
  }
  local hpBar = W_BAR.CreateCustomHpBar(id .. ".hpBar", window, cunstomInfo)
  hpBar:SetExtent(155, 18)
  hpBar:ReleaseHandler("OnLeave")
  hpBar:ReleaseHandler("OnEnter")
  hpBar:AddAnchor("BOTTOMLEFT", window, "BOTTOMLEFT", 15, -4)
  window.hpBar = hpBar
  local hpText = window:CreateChildWidget("label", "hpText", 0, true)
  hpText:AddAnchor("TOPLEFT", hpBar, 0, 0)
  hpText:AddAnchor("BOTTOMRIGHT", hpBar, 0, -1)
  hpText.style:SetFontSize(FONT_SIZE.SMALL)
  hpText.style:SetAlign(ALIGN_CENTER)
  hpText.style:SetColor(1, 1, 1, 1)
  hpText.style:SetShadow(true)
  window.hpText = hpText
  local label = window:CreateChildWidget("label", "label", 0, true)
  label:SetExtent(141, 20)
  label.style:SetShadow(true)
  label.style:SetAlign(ALIGN_RIGHT)
  label:AddAnchor("BOTTOMLEFT", hpText, "TOPLEFT", 0, -3)
  window.label = label
  local bgLabel = window:CreateChildWidget("label", "bgLabel", 0, true)
  bgLabel:SetExtent(57, 57)
  bgLabel:AddAnchor("TOPRIGHT", window, -15, 5)
  local bg = bgLabel:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_STATUS, key, "background")
  bg:AddAnchor("TOPLEFT", bgLabel, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", bgLabel, 0, 0)
  window.bg = bg
  window.update = false
  function window:ShowLabel(show, name, colors)
    self.label:SetText(name or "")
    self.label:Show(show)
    if colors ~= nil then
      ApplyTextColor(self.label, colors)
    end
  end
  function window:SetLabelColor(colors)
    ApplyTextColor(self.label, colors)
  end
  function window:ShowHpBar(show)
    self.hpBar:SetMinMaxValues(0, 0)
    self.hpBar:SetValue(0)
    self.hpText:SetText("")
    self.hpBar:Show(show)
    self.hpText:Show(show)
  end
  function window:SetHp(curHealth, maxHealth)
    self.hpBar:SetMinMaxValues(0, maxHealth)
    self.hpBar:SetValue(curHealth)
    local percent = maxHealth > 0 and math.floor(curHealth * 100 / maxHealth) or 0
    local text = string.format("%d/%d(%d%%)", curHealth, maxHealth, percent)
    self.hpText:SetText(text)
  end
  function window:SetData(curHealth, maxHealth, labelColorsKey, coordsKey)
    if curHealth == nil then
      self:SetHp(0, 0)
      self.hpText:SetText(locale.dominion.unknown)
      self.hpText.style:SetColor(1, 1, 1, 0.5)
      self:SetLabelColor(FONT_COLOR.GRAY)
      local coords = {
        GetTextureInfo(TEXTURE_PATH.BATTLEFIELD_STATUS, "hallows_disable"):GetCoords()
      }
      self.bg:SetCoords(coords[1], coords[2], coords[3], coords[4])
      local colors = GetTextureInfo(TEXTURE_PATH.HUD, "siege_gauge_bg"):GetColors().dark_gray
      self.hpBar:ChangeStatusBarBgColor(colors)
      self.update = false
    else
      self:SetHp(curHealth, maxHealth)
      self.hpText.style:SetColor(1, 1, 1, 1)
      if not self.update then
        self.update = true
        self:SetLabelColor(F_COLOR.GetColor(labelColorsKey, false))
        local coords = {
          GetTextureInfo(TEXTURE_PATH.BATTLEFIELD_STATUS, coordsKey):GetCoords()
        }
        self.bg:SetCoords(coords[1], coords[2], coords[3], coords[4])
        local colors = GetTextureInfo(TEXTURE_PATH.HUD, "siege_gauge_bg"):GetColors().default
        self.hpBar:ChangeStatusBarBgColor(colors)
      end
    end
  end
  window:ShowHpBar(false)
  return window
end
local function SetViewOfMiniScoreboard(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  function window:MakeOriginWindowPos(reset)
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(230, 385)
    if reset then
      window:AddAnchor("TOPRIGHT", parent, F_LAYOUT.CalcDontApplyUIScale(-280), 0)
    else
      window:AddAnchor("TOPRIGHT", parent, -280, 0)
    end
  end
  window:MakeOriginWindowPos()
  local SetViewMyScoreboard = function(id, parent)
    local window = parent:CreateChildWidget("emptywidget", "window", 0, true)
    window:SetExtent(230, 90)
    local teambg = window:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
    teambg:SetTextureColor("status_alpha_35")
    teambg:AddAnchor("TOPLEFT", window, 0, 0)
    teambg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    local myScoreTitle = window:CreateChildWidget("label", "myScoreTitle", 0, true)
    myScoreTitle:SetExtent(230, FONT_SIZE.LARGE)
    myScoreTitle:AddAnchor("TOP", window, 0, 5)
    myScoreTitle.style:SetFontSize(FONT_SIZE.LARGE)
    myScoreTitle.style:SetAlign(ALIGN_CENTER)
    myScoreTitle.style:SetShadow(true)
    ApplyTextColor(myScoreTitle, FONT_COLOR.SOFT_YELLOW)
    myScoreTitle:SetText(GetCommonText("my_record"))
    local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
    bg:SetTextureColor("status_alpha_35")
    bg:AddAnchor("TOPLEFT", window, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", myScoreTitle, 0, 7)
    local myScorekillLabel = window:CreateChildWidget("label", "myScorekillLabel", 0, true)
    myScorekillLabel:SetHeight(FONT_SIZE.MIDDLE)
    myScorekillLabel:SetAutoResize(true)
    myScorekillLabel:AddAnchor("TOPLEFT", myScoreTitle, "BOTTOMLEFT", 15, 11)
    myScorekillLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    myScorekillLabel.style:SetAlign(ALIGN_LEFT)
    myScorekillLabel.style:SetShadow(true)
    ApplyTextColor(myScorekillLabel, FONT_COLOR.WHITE)
    myScorekillLabel:SetText(GetCommonText("kill_count"))
    local myScoreAssistLabel = window:CreateChildWidget("label", "myScoreAssistLabel", 0, true)
    myScoreAssistLabel:SetHeight(FONT_SIZE.MIDDLE)
    myScoreAssistLabel:SetAutoResize(true)
    myScoreAssistLabel:AddAnchor("TOPLEFT", myScorekillLabel, "BOTTOMLEFT", 0, 5)
    myScoreAssistLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    myScoreAssistLabel.style:SetAlign(ALIGN_LEFT)
    myScoreAssistLabel.style:SetShadow(true)
    ApplyTextColor(myScoreAssistLabel, FONT_COLOR.WHITE)
    myScoreAssistLabel:SetText(GetCommonText("assist_count"))
    local myScoreLabel = window:CreateChildWidget("label", "myScoreLabel", 0, true)
    myScoreLabel:SetHeight(FONT_SIZE.MIDDLE)
    myScoreLabel:SetAutoResize(true)
    myScoreLabel:AddAnchor("TOPLEFT", myScoreAssistLabel, "BOTTOMLEFT", 0, 5)
    myScoreLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    myScoreLabel.style:SetAlign(ALIGN_LEFT)
    myScoreLabel.style:SetShadow(true)
    ApplyTextColor(myScoreLabel, FONT_COLOR.WHITE)
    myScoreLabel:SetText(GetCommonText("progress_score"))
    local myScorekills = window:CreateChildWidget("label", "myScorekills", 0, true)
    myScorekills:SetHeight(FONT_SIZE.MIDDLE)
    myScorekills:SetAutoResize(true)
    myScorekills:AddAnchor("TOPRIGHT", myScoreTitle, "BOTTOMRIGHT", -15, 11)
    myScorekills.style:SetFontSize(FONT_SIZE.MIDDLE)
    myScorekills.style:SetAlign(ALIGN_RIGHT)
    myScorekills.style:SetShadow(true)
    ApplyTextColor(myScorekills, FONT_COLOR.WHITE)
    local myScoreAssists = window:CreateChildWidget("label", "myScoreAssists", 0, true)
    myScoreAssists:SetHeight(FONT_SIZE.MIDDLE)
    myScoreAssists:SetAutoResize(true)
    myScoreAssists:AddAnchor("TOPRIGHT", myScorekills, "BOTTOMRIGHT", 0, 5)
    myScoreAssists.style:SetFontSize(FONT_SIZE.MIDDLE)
    myScoreAssists.style:SetAlign(ALIGN_RIGHT)
    myScoreAssists.style:SetShadow(true)
    ApplyTextColor(myScoreAssists, FONT_COLOR.WHITE)
    local myScores = window:CreateChildWidget("label", "myScores", 0, true)
    myScores:SetHeight(FONT_SIZE.MIDDLE)
    myScores:SetAutoResize(true)
    myScores:AddAnchor("TOPRIGHT", myScoreAssists, "BOTTOMRIGHT", 0, 5)
    myScores.style:SetFontSize(FONT_SIZE.MIDDLE)
    myScores.style:SetAlign(ALIGN_RIGHT)
    myScores.style:SetShadow(true)
    ApplyTextColor(myScores, FONT_COLOR.WHITE)
    return window
  end
  local function SetViewVictoryConditionboard(id, parent)
    local window = parent:CreateChildWidget("emptywidget", id, 0, true)
    local teambg = window:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
    teambg:SetTextureColor("status_alpha_35")
    teambg:AddAnchor("TOPLEFT", window, 0, 0)
    teambg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    local victoryConditionTitle = window:CreateChildWidget("label", "victoryConditionTitle", 0, true)
    victoryConditionTitle:SetExtent(230, FONT_SIZE.LARGE)
    victoryConditionTitle:AddAnchor("TOP", window, 0, 5)
    victoryConditionTitle.style:SetFontSize(FONT_SIZE.LARGE)
    victoryConditionTitle.style:SetAlign(ALIGN_CENTER)
    victoryConditionTitle.style:SetShadow(true)
    ApplyTextColor(victoryConditionTitle, FONT_COLOR.SOFT_YELLOW)
    victoryConditionTitle:SetText(GetCommonText("victory_condition_title"))
    local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
    bg:SetTextureColor("status_alpha_35")
    bg:AddAnchor("TOPLEFT", window, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", victoryConditionTitle, 0, 7)
    local targetAnchor = victoryConditionTitle
    local extentHeight = 120
    if not IS_NO_NPC_TARGET then
      local icon = CreateIcon("icon", window, "hallows_nuia")
      icon:AddAnchor("TOPRIGHT", victoryConditionTitle, "BOTTOMRIGHT", 0, 10)
      icon.hpBar:ChangeStatusBarColor(GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetColors().nuia_blue)
      window.icon = icon
      local icon2 = CreateIcon("icon2", window, "hallows_hariharan")
      icon2:AddAnchor("TOPRIGHT", icon, "BOTTOMRIGHT", 0, 13)
      icon2.hpBar:ChangeStatusBarColor(GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetColors().hariharan_green)
      window.icon2 = icon2
      local lineLabel = window:CreateChildWidget("label", "lineLabel", 0, true)
      lineLabel:SetExtent(230, 3)
      lineLabel:AddAnchor("TOPRIGHT", icon2, "BOTTOMRIGHT", 0, 16)
      local line = window:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_STATUS, "line", "background")
      line:AddAnchor("TOPLEFT", lineLabel, 0, 0)
      line:AddAnchor("BOTTOMRIGHT", lineLabel, 0, 0)
      targetAnchor = line
      extentHeight = 275
    end
    window:SetExtent(230, extentHeight)
    local nameTeamLabel_1 = window:CreateChildWidget("label", "nameTeamLabel_1", 0, true)
    nameTeamLabel_1:SetAutoResize(true)
    nameTeamLabel_1:SetHeight(FONT_SIZE.MIDDLE)
    nameTeamLabel_1:AddAnchor("TOPLEFT", targetAnchor, "BOTTOMLEFT", 15, 9)
    nameTeamLabel_1.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameTeamLabel_1.style:SetAlign(ALIGN_LEFT)
    nameTeamLabel_1.style:SetShadow(true)
    ApplyTextColor(nameTeamLabel_1, F_COLOR.GetColor("soda_blue", false))
    local nameTeamLabel_2 = window:CreateChildWidget("label", "nameTeamLabel_2", 0, true)
    nameTeamLabel_2:SetAutoResize(true)
    nameTeamLabel_2:SetHeight(FONT_SIZE.MIDDLE)
    nameTeamLabel_2:AddAnchor("TOPLEFT", nameTeamLabel_1, "BOTTOMLEFT", 0, 5)
    nameTeamLabel_2.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameTeamLabel_2.style:SetAlign(ALIGN_LEFT)
    nameTeamLabel_2.style:SetShadow(true)
    ApplyTextColor(nameTeamLabel_2, F_COLOR.GetColor("soft_green", false))
    local nameTeamLabel_3 = window:CreateChildWidget("label", "nameTeamLabel_3", 0, true)
    nameTeamLabel_3:SetAutoResize(true)
    nameTeamLabel_3:SetHeight(FONT_SIZE.MIDDLE)
    nameTeamLabel_3:AddAnchor("TOPLEFT", nameTeamLabel_2, "BOTTOMLEFT", 0, 5)
    nameTeamLabel_3.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameTeamLabel_3.style:SetAlign(ALIGN_RIGHT)
    nameTeamLabel_3.style:SetShadow(true)
    ApplyTextColor(nameTeamLabel_3, F_COLOR.GetColor("exp_orange", false))
    local nameTeam_1 = window:CreateChildWidget("label", "nameTeam_1", 0, true)
    nameTeam_1:SetAutoResize(true)
    nameTeam_1:SetHeight(FONT_SIZE.MIDDLE)
    nameTeam_1:AddAnchor("TOPRIGHT", targetAnchor, "BOTTOMRIGHT", -15, 9)
    nameTeam_1.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameTeam_1.style:SetAlign(ALIGN_RIGHT)
    nameTeam_1.style:SetShadow(true)
    ApplyTextColor(nameTeam_1, F_COLOR.GetColor("soda_blue", false))
    local nameTeam_2 = window:CreateChildWidget("label", "nameTeam_2", 0, true)
    nameTeam_2:SetAutoResize(true)
    nameTeam_2:SetHeight(FONT_SIZE.MIDDLE)
    nameTeam_2:AddAnchor("TOPRIGHT", nameTeam_1, "BOTTOMRIGHT", 0, 5)
    nameTeam_2.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameTeam_2.style:SetAlign(ALIGN_RIGHT)
    nameTeam_2.style:SetShadow(true)
    ApplyTextColor(nameTeam_2, F_COLOR.GetColor("soft_green", false))
    local nameTeam_3 = window:CreateChildWidget("label", "nameTeam_3", 0, true)
    nameTeam_3:SetAutoResize(true)
    nameTeam_3:SetHeight(FONT_SIZE.MIDDLE)
    nameTeam_3:AddAnchor("TOPRIGHT", nameTeam_2, "BOTTOMRIGHT", 0, 5)
    nameTeam_3.style:SetFontSize(FONT_SIZE.MIDDLE)
    nameTeam_3.style:SetAlign(ALIGN_RIGHT)
    nameTeam_3.style:SetShadow(true)
    ApplyTextColor(nameTeam_3, F_COLOR.GetColor("exp_orange", false))
    local endLineLabel = window:CreateChildWidget("label", "endLineLabel", 0, true)
    endLineLabel:SetExtent(230, 3)
    endLineLabel:AddAnchor("TOPRIGHT", nameTeam_3, "BOTTOMRIGHT", 15, 10)
    local endLine = window:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_STATUS, "line", "background")
    endLine:AddAnchor("TOPLEFT", endLineLabel, 0, 0)
    endLine:AddAnchor("BOTTOMRIGHT", endLineLabel, 0, 0)
    local timeFrame = CreateTimeFrame(window, "miniScoreboard")
    timeFrame:AddAnchor("BOTTOMRIGHT", window, -15, -6)
    timeFrame.time = 0
    for i = 1, BATTLEFIELD_MAX_WIN_CONDITION_COUNT do
      local winCondition = window:CreateChildWidget("emptywidget", "winCondition", i, true)
      winCondition:Show(false)
      local bg = CreateWinConditionIcon(winCondition, BATTLEFIELD_MAX_WIN_CONDITIONS_TYPE[i])
      bg:AddAnchor("CENTER", winCondition, 0, 0)
      winCondition:SetExtent(16, 16)
    end
    return window
  end
  window.myScoreboard = SetViewMyScoreboard(id, window)
  window.myScoreboard:AddAnchor("TOPLEFT", window, 0, 0)
  window.victoryConditionboard = SetViewVictoryConditionboard(id, window)
  window.victoryConditionboard:AddAnchor("TOPLEFT", window.myScoreboard, "BOTTOMLEFT", 0, 0)
  local dragWindow = window:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", window, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", window.victoryConditionboard, 0, 0)
  dragWindow:EnableDrag(true)
  return window
end
local function CreateMiniScoreboard(id, parent)
  SetMiniScoreboardVersusFactionType()
  local window = SetViewOfMiniScoreboard(id, parent)
  local dragWindow = window.dragWindow
  for i = 1, BATTLEFIELD_MAX_WIN_CONDITION_COUNT do
    do
      local widget = window.victoryConditionboard.winCondition[i]
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
      window.victoryConditionboard.winCondition[i]:Show(false)
    end
    local target
    if score ~= nil and score > 0 then
      window.victoryConditionboard.winCondition[1]:Show(true)
      if target == nil then
        window.victoryConditionboard.winCondition[1]:AddAnchor("BOTTOMLEFT", window.victoryConditionboard, 15, -10)
      end
      target = window.victoryConditionboard.winCondition[1]
    end
    if killCount ~= nil and killCount > 0 then
      window.victoryConditionboard.winCondition[2]:Show(true)
      if target == nil then
        window.victoryConditionboard.winCondition[2]:AddAnchor("BOTTOMLEFT", window.victoryConditionboard, 15, -10)
      else
        window.victoryConditionboard.winCondition[2]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.victoryConditionboard.winCondition[2]
    end
    if roundWinCount ~= nil and roundWinCount > 0 then
      window.victoryConditionboard.winCondition[3]:Show(true)
      if target == nil then
        window.victoryConditionboard.winCondition[3]:AddAnchor("BOTTOMLEFT", window.victoryConditionboard, 15, -10)
      else
        window.winCondition[3]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.victoryConditionboard.winCondition[3]
    end
    if destruction then
      window.victoryConditionboard.winCondition[4]:Show(true)
      if target == nil then
        window.victoryConditionboard.winCondition[4]:AddAnchor("BOTTOMLEFT", window.victoryConditionboard, 10, -10)
      else
        window.victoryConditionboard.winCondition[4]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.victoryConditionboard.winCondition[4]
    end
    if timeOut then
      window.victoryConditionboard.winCondition[5]:Show(true)
      if target == nil then
        window.victoryConditionboard.winCondition[5]:AddAnchor("BOTTOMLEFT", window.victoryConditionboard, 10, -10)
      else
        window.victoryConditionboard.winCondition[5]:AddAnchor("LEFT", target, "RIGHT", 2, 0)
      end
      target = window.victoryConditionboard.winCondition[5]
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
    self.myScoreboard.myScorekills:SetText("")
    self.myScoreboard.myScoreAssists:SetText("")
    self.myScoreboard.myScores:SetText("")
    self.victoryConditionboard.nameTeam_1:SetText("")
    self.victoryConditionboard.nameTeam_2:SetText("")
    self.victoryConditionboard.nameTeam_3:SetText("")
    self.victoryConditionboard.timeFrame.time = 0
    self.victoryConditionboard.timeFrame:UpdateTime(0)
    if not IS_NO_NPC_TARGET then
      self.victoryConditionboard.icon:ShowHpBar(false)
      self.victoryConditionboard.icon2:ShowHpBar(false)
      self.victoryConditionboard.icon:ShowLabel(false)
      self.victoryConditionboard.icon2:ShowLabel(false)
    end
  end
  local oldTime = 0
  local function OnUpdateTime(self, dt)
    if window.victoryConditionboard.remainTime < 0 then
      return
    end
    if oldTime ~= window.victoryConditionboard.remainTime then
      oldTime = window.victoryConditionboard.remainTime
      window.victoryConditionboard.timeFrame:UpdateTime(oldTime)
    end
  end
  function window:FillInstantTimeInfo()
    local info = X2BattleField:GetProgressTimeInfo()
    if info == nil or info.state ~= "STARTED" then
      window:HideMiniScoreboard()
      return
    end
    window.victoryConditionboard.remainTime = tonumber(info.remainTime)
    if window:HasHandler("OnUpdate") == false then
      window:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  function window:FillInstantScoreInfo(scoreInfo)
    self.myScoreboard.myScorekills:SetText(string.format("%s", tostring(scoreInfo.myCharKill)))
    self.myScoreboard.myScoreAssists:SetText(string.format("%s", tostring(scoreInfo.myCharAssist)))
    self.myScoreboard.myScores:SetText(string.format("%s", tostring(scoreInfo.myScore)))
    self.victoryConditionboard.nameTeam_1:SetText(string.format("%s", tostring(scoreInfo.killScore1)))
    self.victoryConditionboard.nameTeam_2:SetText(string.format("%s", tostring(scoreInfo.killScore2)))
    self.victoryConditionboard.nameTeam_3:SetText(string.format("%s", tostring(scoreInfo.killScore3)))
  end
  function window:FillInstantGameInfo()
    local info = X2BattleField:GetProgressEntireInfo()
    if info == nil then
      return
    end
    self:FillInstantScoreInfo(info)
    self.victoryDefault = info.victoryDefault
    self.victoryScore = info.victoryScore
    self.victoryKillCount = info.victoryKillCount
    self.victoryRoundWinCount = info.victoryRoundWinCount
    local isDesturtion = info.victoryTarget ~= 0
    self:SetWinCondition(self.victoryScore, self.victoryKillCount, self.victoryRoundWinCount, isDesturtion, true)
    if info.corpsName1 ~= "" and info.corpsFaction1 ~= nil then
      self.victoryConditionboard.nameTeamLabel_1:SetText(string.format("%s", info.corpsName1))
      ApplyTextColor(self.victoryConditionboard.nameTeamLabel_1, EMBLEMINFO[info.corpsFaction1].color)
      ApplyTextColor(self.victoryConditionboard.nameTeam_1, EMBLEMINFO[info.corpsFaction1].color)
      self.victoryConditionboard.nameTeam_1:Show(true)
    else
      self.victoryConditionboard.nameTeamLabel_1:SetText("")
      self.victoryConditionboard.nameTeam_1:Show(false)
    end
    if info.corpsName2 ~= "" and info.corpsFaction2 ~= nil then
      self.victoryConditionboard.nameTeamLabel_2:SetText(string.format("%s", info.corpsName2))
      ApplyTextColor(self.victoryConditionboard.nameTeamLabel_2, EMBLEMINFO[info.corpsFaction2].color)
      ApplyTextColor(self.victoryConditionboard.nameTeam_2, EMBLEMINFO[info.corpsFaction2].color)
      self.victoryConditionboard.nameTeam_2:Show(true)
    else
      self.victoryConditionboard.nameTeamLabel_2:SetText("")
      self.victoryConditionboard.nameTeam_2:Show(false)
    end
    if info.corpsName3 ~= "" and info.corpsFaction3 ~= nil then
      self.victoryConditionboard.nameTeamLabel_3:SetText(string.format("%s", info.corpsName3))
      ApplyTextColor(self.victoryConditionboard.nameTeamLabel_3, EMBLEMINFO[info.corpsFaction3].color)
      ApplyTextColor(self.victoryConditionboard.nameTeam_3, EMBLEMINFO[info.corpsFaction3].color)
      self.victoryConditionboard.nameTeam_3:Show(true)
    else
      self.victoryConditionboard.nameTeamLabel_3:SetText("")
      self.victoryConditionboard.nameTeam_3:Show(false)
    end
    if not IS_NO_NPC_TARGET then
      self.victoryConditionboard.icon:ShowHpBar(true)
      self.victoryConditionboard.icon2:ShowHpBar(true)
      self.victoryConditionboard.icon:ShowLabel(true, info.targetNpc1Name, F_COLOR.GetColor("soda_blue", false))
      self.victoryConditionboard.icon2:ShowLabel(true, info.targetNpc2Name, F_COLOR.GetColor("soft_green", false))
      self.victoryConditionboard.icon:SetData()
      self.victoryConditionboard.icon2:SetData()
    end
  end
  function window:FillInstantGameTargetNpcHp(unitId, curHp, maxHp)
    local info = X2BattleField:GetTargetNpcInfo()
    if info == nil or info.targetNpc1Id == nil or info.targetNpc2Id == nil then
      return
    end
    if not IS_NO_NPC_TARGET then
      if unitId == info.targetNpc1Id then
        self.victoryConditionboard.icon:SetData(curHp, maxHp, "soda_blue", "hallows_nuia")
      elseif unitId == info.targetNpc2Id then
        self.victoryConditionboard.icon2:SetData(curHp, maxHp, "soft_green", "hallows_hariharan")
      end
    end
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
      local scoreInfo = X2BattleField:GetProgressScoreInfo()
      window:FillInstantScoreInfo(scoreInfo)
    end,
    UPDATE_INSTANT_GAME_TIME = function()
      window:FillInstantTimeInfo()
    end,
    TARGET_NPC_HEALTH_CHANGED_FOR_VERSUS_FACTION = function(target, curHp, maxHp)
      window:FillInstantGameTargetNpcHp(target, curHp, maxHp)
    end,
    UNIT_ENTERED_SIGHT = function(unitId, unitType, curHp, maxHp)
      if unitType ~= "npc" then
        return
      end
      window:FillInstantGameTargetNpcHp(unitId, curHp, maxHp)
    end,
    UNIT_LEAVED_SIGHT = function(unitId, unitType)
      if unitType ~= "npc" then
        return
      end
      window:FillInstantGameTargetNpcHp(unitId)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function ShowMiniScoreboard_VersusFaction(isShow)
  if battlefield.miniScoreboard == nil then
    if isShow then
      battlefield.miniScoreboard = CreateMiniScoreboard("battlefield.miniScoreboard_VersusFaction", "UIParent")
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
