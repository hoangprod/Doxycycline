BATTLEFIELD_A_COL = {
  NAME = 1,
  KILL = 2,
  DEATH = 3,
  ASSIST = 4,
  SCORE = 5,
  REWARD = 6
}
local CreateScoreboardScrollListCtrl = function(id, parent)
  local widget = W_CTRL.CreateScrollListCtrl(id, parent)
  widget:Show(true)
  widget:SetExtent(570, 340)
  widget:SetUseDoubleClick(true)
  widget.listCtrl:ChangeSortMartTexture()
  widget.listCtrl.AscendingSortMark:SetColor(1, 1, 1, 0.5)
  widget.listCtrl.DescendingSortMark:SetColor(1, 1, 1, 0.5)
  local bg = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg", "background")
  bg:SetTextureColor("bgcolor")
  bg:AddAnchor("TOPLEFT", widget, -MARGIN.WINDOW_SIDE, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  local deco = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "deco", "background")
  deco:AddAnchor("TOPLEFT", widget, -MARGIN.WINDOW_SIDE, 0)
  deco:AddAnchor("BOTTOMRIGHT", widget, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE + MARGIN.WINDOW_SIDE / 2)
  widget.deco = deco
  local upperDeco = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg_line", "background")
  upperDeco:SetExtent(560, 11)
  upperDeco:AddAnchor("TOP", widget, 8, 0)
  upperDeco:SetColor(1, 1, 1, 0.7)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data == X2Unit:UnitName("player") then
        ApplyTextColor(subItem, FONT_COLOR.BATTLEFIELD_YELLOW)
        subItem:GetParent().playerMarkBg:SetVisible(true)
      else
        ApplyTextColor(subItem, FONT_COLOR.WHITE)
        subItem:GetParent().playerMarkBg:SetVisible(false)
      end
      subItem:SetText(data)
    else
      subItem:GetParent().playerMarkBg:SetVisible(false)
    end
  end
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    end
  end
  local ScoreDataSetFunc = function(subItem, data, setValue)
    if setValue == nil then
      subItem:SetText("")
      return
    end
    local str = ""
    if data.bonus == nil then
      str = tostring(data.default)
    elseif data.isRating then
      if data.bonus < 0 then
        str = string.format("%d %s(%d)|r", data.default, FONT_COLOR_HEX.ROSE_PINK, data.bonus)
      else
        str = string.format("%d %s(+%d)|r", data.default, FONT_COLOR_HEX.GREEN, data.bonus)
      end
    else
      str = string.format("%d %s(+%d)|r", data.default + data.bonus, FONT_COLOR_HEX.GREEN, data.bonus)
    end
    subItem:SetText(str)
  end
  local RewardDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.rewardFrame.textbox:SetText(data)
      subItem.rewardFrame:Show(true)
      subItem.rewardFrame.textbox:Show(true)
      subItem.rewardFrame.rewardIcon:Show(true)
    else
      subItem.rewardFrame:Show(false)
    end
  end
  local NameLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.WHITE)
    subItem:SetInset(15, 0, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetShadow(true)
  end
  local KillLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.BATTLEFIELD_ORANGE)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetShadow(true)
  end
  local DefaultLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.WHITE)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetShadow(true)
  end
  local ScoreLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.WHITE)
    subItem.style:SetShadow(true)
    subItem:SetInset(10, 0, 5, 0)
  end
  local RewardLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local rewardFrame = subItem:CreateChildWidget("emptywidget", "rewardFrame", 0, true)
    rewardFrame:SetExtent(75, 19)
    rewardFrame:AddAnchor("CENTER", subItem, 0, 0)
    local rewardIcon = rewardFrame:CreateChildWidget("emptywidget", "rewardIcon", 0, true)
    rewardIcon:Show(false)
    rewardIcon:SetExtent(19, 17)
    rewardIcon:AddAnchor("RIGHT", rewardFrame, "RIGHT", 0, 0)
    local bg = rewardIcon:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "icon_battlefield", "background")
    bg:AddAnchor("TOPLEFT", rewardIcon, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", rewardIcon, 0, 0)
    local textbox = rewardFrame:CreateChildWidget("textbox", "textbox", 0, true)
    textbox:AddAnchor("LEFT", rewardFrame, "LEFT", 0, 0)
    textbox:AddAnchor("RIGHT", rewardIcon, "LEFT", -3, 0)
    textbox:SetHeight(FONT_SIZE.MIDDLE)
    textbox.style:SetAlign(ALIGN_RIGHT)
    ApplyTextColor(textbox, FONT_COLOR.WHITE)
    textbox.style:SetShadow(true)
  end
  local NameAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.NAME]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.NAME]
    return valueA < valueA and true or false
  end
  local NameDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.NAME]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.NAME]
    return valueA > valueB and true or false
  end
  local KillAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.KILL]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.KILL]
    return tonumber(valueA) < tonumber(valueB) and true or false
  end
  local KillDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.KILL]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.KILL]
    return tonumber(valueA) > tonumber(valueB) and true or false
  end
  local DeathAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.DEATH]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.DEATH]
    return tonumber(valueA) < tonumber(valueB) and true or false
  end
  local DeathDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.DEATH]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.DEATH]
    return tonumber(valueA) > tonumber(valueB) and true or false
  end
  local AssistAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.ASSIST]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.ASSIST]
    return tonumber(valueA) < tonumber(valueB) and true or false
  end
  local AssistDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.ASSIST]
    local valueB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.ASSIST]
    return tonumber(valueA) > tonumber(valueB) and true or false
  end
  local ScoreAscendingSortFunc = function(a, b)
    local scoreA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].default
    local scoreB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].default
    if a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].isRating == false then
      scoreA = scoreA + a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].bonus
      scoreB = scoreB + a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].bonus
    end
    return tonumber(scoreA) < tonumber(scoreB) and true or false
  end
  local ScoreDescendingSortFunc = function(a, b)
    local scoreA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].default
    local scoreB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].default
    if a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].isRating == false then
      scoreA = scoreA + a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].bonus
      scoreB = scoreB + a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.SCORE].bonus
    end
    return tonumber(scoreA) > tonumber(scoreB) and true or false
  end
  local RewardAscendingSortFunc = function(a, b)
    local rewardA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.REWARD]
    local rewardB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.REWARD]
    return tonumber(rewardA) < tonumber(rewardB) and true or false
  end
  local RewardDescendingSortFunc = function(a, b)
    local rewardA = a[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.REWARD]
    local rewardB = b[ROWDATA_COLUMN_OFFSET + BATTLEFIELD_A_COL.REWARD]
    return tonumber(rewardA) > tonumber(rewardB) and true or false
  end
  widget:InsertColumn(locale.faction.name, 160, LCCIT_STRING, NameDataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, NameLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.kill, 60, LCCIT_STRING, DataSetFunc, KillAscendingSortFunc, KillDescendingSortFunc, KillLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.death, 60, LCCIT_STRING, DataSetFunc, DeathAscendingSortFunc, DeathDescendingSortFunc, DefaultLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.assist, 60, LCCIT_STRING, DataSetFunc, AssistAscendingSortFunc, AssistDescendingSortFunc, DefaultLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.score, 123, LCCIT_TEXTBOX, ScoreDataSetFunc, ScoreAscendingSortFunc, ScoreDescendingSortFunc, ScoreLayoutFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.reward, 85, LCCIT_WINDOW, RewardDataSetFunc, RewardAscendingSortFunc, RewardDescendingSortFunc, RewardLayoutSetFunc)
  widget:InsertRows(10, false)
  DrawListCtrlUnderLine(widget.listCtrl, nil, true)
  local SettingListColumn = function(listCtrl, column)
    listCtrl:SetColumnHeight(LIST_COLUMN_HEIGHT)
    column.style:SetShadow(false)
    column.style:SetFontSize(FONT_SIZE.LARGE)
    SetButtonFontColor(column, GetWhiteButtonFontColor())
  end
  for i = 1, #widget.listCtrl.column do
    SettingListColumn(widget.listCtrl, widget.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(widget.listCtrl.column[i], #widget.listCtrl.column, i, true)
  end
  for i = 1, #widget.listCtrl.items do
    local item = widget.listCtrl.items[i]
    local playerMarkBg = CreateContentBackground(item, "TYPE5", "white")
    playerMarkBg:AddAnchor("TOPLEFT", item, 0, -4)
    playerMarkBg:AddAnchor("BOTTOMRIGHT", item, 0, 5)
    item.playerMarkBg = playerMarkBg
  end
  return widget
end
local CreateGaugeFrame = function(id, parent)
  local guageFrame = W_ETC.CreateScoreBoardGuageSection(id, parent)
  guageFrame.totalKillScore:SetText(locale.battlefield.scoreboard.totalScore)
  local stateTexture = guageFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "guage", "overlay")
  stateTexture:AddAnchor("BOTTOM", guageFrame.totalKillScore, 0, -MARGIN.WINDOW_SIDE * 2)
  guageFrame.stateTexture = stateTexture
  local bg = CreateContentBackground(guageFrame, "TYPE8", "black")
  bg:SetHeight(60)
  bg:AddAnchor("LEFT", stateTexture, -40, -5)
  bg:AddAnchor("RIGHT", stateTexture, 40, -5)
  guageFrame.bg = bg
  local winConditiontText = guageFrame:CreateChildWidget("label", "winConditiontText", 0, true)
  winConditiontText:SetAutoResize(true)
  winConditiontText:SetHeight(FONT_SIZE.MIDDLE)
  winConditiontText.style:SetFontSize(FONT_SIZE.MIDDLE)
  winConditiontText.style:SetShadow(true)
  ApplyTextColor(winConditiontText, FONT_COLOR.WHITE)
  local icon = winConditiontText:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_WIN_CONDITION, "score", "background")
  icon:AddAnchor("RIGHT", winConditiontText, "LEFT", -2, 1)
  winConditiontText.icon = icon
  function guageFrame:SetGameResult(resultStr)
    if resultStr == nil then
      self.stateTexture:SetVisible(false)
      return
    end
    local coords
    if resultStr == "win" then
      coords = FORM_WAITING_ALARM.GAME_RESULT_COORDS.WIN
    elseif resultStr == "defeat" then
      coords = FORM_WAITING_ALARM.GAME_RESULT_COORDS.DEFEAT
    elseif resultStr == "draw" then
      coords = FORM_WAITING_ALARM.GAME_RESULT_COORDS.DRAW
    end
    if coords == nil then
      return
    end
    self.stateTexture:SetCoords(coords[1], coords[2], coords[3], coords[4])
    self.stateTexture:SetExtent(coords[3], coords[4])
    self.stateTexture:SetVisible(true)
  end
  function guageFrame:SetWinCondition(info)
    if info == nil then
      self.winConditiontText:Show(false)
    end
    if info.endReason == BFER_TIMEOVER_COMPARE_KILL_COUNT then
      self.winConditiontText.icon:SetCoords(31, 0, 13, 13)
      self.winConditiontText.icon:SetExtent(13, 13)
      self.winConditiontText:SetText(locale.battlefield.scoreboardEndReason[1])
    elseif info.endReason == BFER_ACHIEVEMENT_KILL_COUNT then
      self.winConditiontText.icon:SetCoords(16, 0, 15, 14)
      self.winConditiontText.icon:SetExtent(15, 14)
      local winTeamName, count = GetWinTeamName(info)
      self.winConditiontText:SetText(locale.battlefield.scoreboardEndReason[2](winTeamName, count))
    elseif info.endReason == BFER_ACHIEVEMENT_KILL_CORPS_HEAD then
      self.winConditiontText.icon:SetCoords(0, 0, 16, 16)
      self.winConditiontText.icon:SetExtent(16, 16)
      local winTeamName = GetWinTeamName(info)
      self.winConditiontText:SetText(locale.battlefield.scoreboardEndReason[3](winTeamName))
    end
    local xOffset = self.winConditiontText.icon:GetWidth()
    self.winConditiontText:RemoveAllAnchors()
    self.winConditiontText:AddAnchor("TOP", self.stateTexture, "BOTTOM", 5, 2)
  end
  return guageFrame
end
local function SetViewOfScoreboard(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:SetExtent(1170, 490)
  frame:AddAnchor("CENTER", parent, 0, 0)
  local gaugeFrame = CreateGaugeFrame("gaugeFrame", frame)
  local leftScoreBoard = CreateScoreboardScrollListCtrl("leftScoreBoard", frame)
  leftScoreBoard:AddAnchor("TOPLEFT", gaugeFrame, "BOTTOMLEFT", MARGIN.WINDOW_SIDE / 2, 0)
  leftScoreBoard.deco:SetCoords(355, 100, -355, 245)
  leftScoreBoard.deco:SetColor(ConvertColor(153), ConvertColor(35), ConvertColor(35), 0.5)
  frame.leftScoreBoard = leftScoreBoard
  local rightScoreBoard = CreateScoreboardScrollListCtrl("rightScoreBoard", frame)
  rightScoreBoard:AddAnchor("TOPRIGHT", gaugeFrame, "BOTTOMRIGHT", -MARGIN.WINDOW_SIDE / 2, 0)
  rightScoreBoard.deco:SetColor(ConvertColor(35), ConvertColor(85), ConvertColor(153), 0.5)
  frame.rightScoreBoard = rightScoreBoard
  local timeFrame = CreateTimeFrame(frame, "scoreboard")
  timeFrame:AddAnchor("BOTTOM", frame, -40, -15)
  timeFrame.time = 0
  local askLeaveBtn = frame:CreateChildWidget("button", "askLeaveBtn", 0, true)
  askLeaveBtn:SetText(locale.battlefield.immediatelyExit)
  ApplyButtonSkin(askLeaveBtn, BUTTON_BASIC.DEFAULT)
  askLeaveBtn:AddAnchor("LEFT", timeFrame.nowTime, "RIGHT", 10, 1)
  return frame
end
local function CreateScoreboard(id, parent)
  local frame = SetViewOfScoreboard(id, parent)
  local askLeaveBtn = frame.askLeaveBtn
  local askLeaveBtnLeftClickFunc = function()
    X2BattleField:AskLeaveInstantGame()
  end
  ButtonOnClickHandler(askLeaveBtn, askLeaveBtnLeftClickFunc)
  frame.myTeam = BATTLEFIELD_TEAM.NONE
  local oldTime = 0
  local function OnUpdateTime(self, dt)
    if frame.remainTime <= 0 then
      return
    end
    if oldTime ~= frame.remainTime then
      oldTime = frame.remainTime
      frame.timeFrame:UpdateTime(frame.remainTime)
    end
  end
  local function FillOutWaitTimeInfo()
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "ENDED" then
      frame:HideScoreboard()
      return
    end
    frame.remainTime = tonumber(timeInfo.remainTime)
    if frame:HasHandler("OnUpdate") == false then
      frame:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  local function ResetResult()
    frame.gaugeFrame.leftTeamName:SetText("")
    frame.gaugeFrame.rightTeamName:SetText("")
    frame.gaugeFrame.leftScore:SetText("0")
    frame.gaugeFrame.rightScore:SetText("0")
    frame.leftScoreBoard:DeleteAllDatas()
    frame.rightScoreBoard:DeleteAllDatas()
  end
  local function GetTargetScoreboard(index)
    if index == BATTLEFIELD_TEAM.FIRST then
      return frame.rightScoreBoard
    elseif index == BATTLEFIELD_TEAM.SECOND then
      return frame.leftScoreBoard
    end
  end
  local function FillMemberInfo(data, teamIndex, memberIndex)
    if data == nil or teamIndex == nil then
      return
    end
    local target
    target = GetTargetScoreboard(teamIndex)
    if target == nil then
      return
    end
    local scoreTable = {
      default = data.memberScores,
      bonus = data.memberBonus,
      isRating = false
    }
    local ratingTable = {
      default = data.memberTotalRating,
      bonus = data.memberDeltaRating,
      isRating = true
    }
    target:InsertData(memberIndex, 1, data.name)
    target:InsertData(memberIndex, 2, tostring(data.memberNPcKills))
    target:InsertData(memberIndex, 3, tostring(data.memberNDeaths))
    target:InsertData(memberIndex, 4, tostring(data.memberNPcKillAssists))
    target:InsertData(memberIndex, 6, tostring(data.memberRewardAmount))
    local rewardAmount = tostring(data.memberRewardAmount or 0)
    local bonusAmount = data.memberRewardBonusAmount or 0
    if bonusAmount > 0 then
      rewardAmount = string.format("%d %s(+%d)|r", tostring(data.memberRewardAmount or 0), FONT_COLOR_HEX.GREEN, bonusAmount)
    end
    target:InsertData(memberIndex, 6, rewardAmount)
    local featureSet = X2Player:GetFeatureSet()
    if featureSet.eloRating then
      target:InsertData(memberIndex, 5, ratingTable)
    else
      target:InsertData(memberIndex, 5, scoreTable)
    end
  end
  local function FillTeamInfo(data, teamIndex)
    for i = 1, #data do
      FillMemberInfo(data[i], teamIndex, i)
    end
  end
  function frame:FillResult()
    ResetResult()
    local memberInfo = X2BattleField:GetMembersDetailInfo()
    if memberInfo == nil then
      return
    end
    for i = 1, #memberInfo do
      FillTeamInfo(memberInfo[i], i)
    end
    local info = X2BattleField:GetProgressEntireInfo()
    if info ~= nil then
      frame.gaugeFrame.rightTeamName:SetText(info.corpsName1)
      frame.gaugeFrame.leftTeamName:SetText(info.corpsName2)
      if info.victoryDefault == 2 then
        frame.gaugeFrame.rightScore:SetText(tostring(info.roundWinCount1))
        frame.gaugeFrame.leftScore:SetText(tostring(info.roundWinCount2))
        frame.gaugeFrame.gauge:UpdateScore(info.roundWinCount1, info.roundWinCount2)
      else
        frame.gaugeFrame.rightScore:SetText(tostring(info.killScore1))
        frame.gaugeFrame.leftScore:SetText(tostring(info.killScore2))
        frame.gaugeFrame.gauge:UpdateScore(info.killScore1, info.killScore2)
      end
      local coprsVictoryState = info.myVictoryState
      if coprsVictoryState == VS_LOSE then
        frame.gaugeFrame:SetGameResult("defeat")
      elseif coprsVictoryState == VS_WIN then
        frame.gaugeFrame:SetGameResult("win")
      else
        frame.gaugeFrame:SetGameResult("draw")
      end
      frame.gaugeFrame:SetWinCondition(info)
    end
    FillOutWaitTimeInfo()
  end
  function frame:HideScoreboard()
    self:ReleaseHandler("OnUpdate")
    self:Show(false)
  end
  local OnHideScoreboard = function()
    battlefield.scoreboard = nil
  end
  frame:SetHandler("OnHide", OnHideScoreboard)
  local events = {
    LEAVED_INSTANT_GAME_ZONE = function()
      ResetResult()
      frame:HideScoreboard()
    end,
    UPDATE_INSTANT_GAME_TIME = function()
      FillOutWaitTimeInfo()
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
function ShowScoreboard_Versus(isShow, playSound)
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil or timeInfo.state ~= "ENDED" then
    return
  end
  if battlefield.scoreboard == nil then
    if isShow then
      battlefield.scoreboard = CreateScoreboard("battlefield.scoreboard", "UIParent")
      battlefield.scoreboard:Show(true)
      battlefield.scoreboard:EnableHidingIsRemove(true)
      battlefield.scoreboard:FillResult()
      if playSound then
        BattleFieldResultSound()
      end
    else
      return
    end
  elseif isShow then
    battlefield.scoreboard:Show(true)
    battlefield.scoreboard:FillResult()
    if playSound then
      BattleFieldResultSound()
    end
  else
    battlefield.scoreboard:HideScoreboard()
  end
end
