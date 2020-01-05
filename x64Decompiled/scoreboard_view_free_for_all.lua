local TestTimeInfo = function()
  timeInfo = {
    state = "RETIRED",
    remainTime = 60000,
    curPlayRoundCount = 1,
    playRoundCount = 1
  }
  return timeInfo
end
local CreateScoreboardScrollListCtrl = function(id, parent)
  local windowWidth = 1140
  local windowHeight = 340
  local widget = W_CTRL.CreateScrollListCtrl(id, parent)
  widget:Show(true)
  widget:SetExtent(windowWidth, windowHeight)
  widget:SetUseDoubleClick(true)
  local bg = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg", "background")
  bg:AddAnchor("TOPLEFT", widget, -MARGIN.WINDOW_SIDE, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  local RankDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data))
    else
      subItem:SetText("")
    end
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data.name == X2Unit:UnitName("player") then
        ApplyTextColor(subItem, FONT_COLOR.BATTLEFIELD_YELLOW)
        subItem:GetParent().playerMarkBg:SetVisible(true)
      elseif data.result == VS_WIN then
        ApplyTextColor(subItem, FONT_COLOR.SKYBLUE)
        subItem:GetParent().playerMarkBg:SetVisible(false)
      else
        ApplyTextColor(subItem, FONT_COLOR.WHITE)
        subItem:GetParent().playerMarkBg:SetVisible(false)
      end
      subItem:SetText(data.name)
    else
      subItem:GetParent().playerMarkBg:SetVisible(false)
    end
  end
  local RetireTimeSetFunc = function(subItem, data, setValue)
    if setValue then
      local minute, second = GetMinuteSecondeFromSec(data)
      subItem:SetText(string.format("%02d:%02d", minute, second))
    end
  end
  local WorldNameSetFunc = function(subItem, data, setValue)
    if setValue then
      if data ~= nil then
        subItem:SetText(data)
      else
        subItem:SetText("")
      end
    end
  end
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      if type(data) == string then
        subItem:SetText(data)
      else
        subItem:SetText(tostring(data))
      end
    end
  end
  local RatingDataSetFunc = function(subItem, data, setValue)
    if setValue == nil then
      subItem:SetText("")
      return
    end
    local str = ""
    if data.deltaRating == nil then
      str = tostring(data.totalRating)
    elseif data.deltaRating < 0 then
      str = string.format("%d %s(%d)|r", data.totalRating, FONT_COLOR_HEX.ROSE_PINK, data.deltaRating)
    else
      str = string.format("%d %s(+%d)|r", data.totalRating, FONT_COLOR_HEX.GREEN, data.deltaRating)
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
    subItem:SetInset(25, 0, 0, 0)
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
  local RatingLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.WHITE)
    subItem.style:SetShadow(true)
    subItem:SetInset(10, 0, 5, 0)
  end
  local RewardLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local rewardFrame = subItem:CreateChildWidget("emptywidget", "rewardFrame", 0, true)
    rewardFrame:SetExtent(130, 19)
    rewardFrame:AddAnchor("RIGHT", subItem, "RIGHT", -20, 0)
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
  local scoreColumnSettings = {
    score = {
      name = locale.battlefield.scoreboard.score,
      dataFunc = DataSetFunc,
      layoutFunc = DefaultLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    characterKill = {
      name = locale.battlefield.scoreboard.kill,
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    npcKill = {
      name = locale.battlefield.scoreboard.elimination,
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    slaveKill = {
      name = locale.battlefield.scoreboard.destruction,
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    housingKill = {
      name = "housing",
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    transferKill = {
      name = "transfer",
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    mateKill = {
      name = "mate",
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    shipyardKill = {
      name = "shipyard",
      dataFunc = DataSetFunc,
      layoutFunc = KillLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    death = {
      name = locale.battlefield.scoreboard.death,
      dataFunc = DataSetFunc,
      layoutFunc = DefaultLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    retireTime = {
      name = GetUIText(INSTANT_GAME_TEXT, "retire_play_time"),
      dataFunc = RetireTimeSetFunc,
      layoutFunc = DefaultLayoutSetFunc,
      width = 130,
      columnType = LCCIT_STRING
    },
    rating = {
      name = GetUIText(BATTLE_FIELD_TEXT, "rating"),
      dataFunc = RatingDataSetFunc,
      layoutFunc = RatingLayoutFunc,
      width = 130,
      columnType = LCCIT_TEXTBOX
    }
  }
  local scoreColumnInfo = X2BattleField:GetScoreColumnInfo()
  widget.scoreColumnCount = #scoreColumnInfo
  windowWidth = 20
  widget:InsertColumn(GetUIText(RANKING_TEXT, "placing"), 70, LCCIT_STRING, RankDataSetFunc, nil, nil, DefaultLayoutSetFunc)
  windowWidth = windowWidth + 70
  widget:InsertColumn(locale.faction.name, 330, LCCIT_CHARACTER_NAME, NameDataSetFunc, nil, nil, NameLayoutSetFunc)
  windowWidth = windowWidth + 330
  widget.scoreColumnKeys = {}
  for idx = 1, #scoreColumnInfo do
    local settingData = scoreColumnSettings[scoreColumnInfo[idx]]
    widget:InsertColumn(settingData.name, settingData.width, settingData.columnType, settingData.dataFunc, nil, nil, settingData.layoutFunc)
    widget.scoreColumnKeys[idx] = scoreColumnInfo[idx]
    windowWidth = windowWidth + settingData.width
  end
  widget:InsertColumn(locale.battlefield.scoreboard.reward, 130, LCCIT_WINDOW, RewardDataSetFunc, nil, nil, RewardLayoutSetFunc)
  windowWidth = windowWidth + 130
  widget:InsertColumn(GetCommonText("squad_info_list_server_name"), 177, LCCIT_STRING, WorldNameSetFunc, nil, nil, DefaultLayoutSetFunc)
  windowWidth = windowWidth + 177
  widget:InsertRows(10, false)
  widget:SetWidth(windowWidth)
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
  local guageFrame = parent:CreateChildWidget("emptywidget", id, 0, true)
  guageFrame:SetExtent(parent:GetWidth(), 100)
  guageFrame:AddAnchor("TOP", parent, 0, 0)
  local stateTexture = guageFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "guage", "overlay")
  stateTexture:AddAnchor("TOP", guageFrame, 0, 0)
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
    self.winConditiontText.icon:SetCoords(31, 0, 13, 13)
    self.winConditiontText.icon:SetExtent(13, 13)
    if info.endReason == BFER_ACHIEVEMENT_ALL_KILL_CORPS then
      self.winConditiontText:SetText(GetCommonText("achieve_all_kill_corps"))
    elseif info.state == "RETIRED" then
      self.winConditiontText:SetText(GetUIText(GRAVE_YARD_TEXT, "dead"))
    else
      self.winConditiontText:SetText(locale.battlefield.scoreboardEndReason[1])
    end
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
  local scoreBoard = CreateScoreboardScrollListCtrl("scoreBoard", frame)
  scoreBoard:AddAnchor("TOP", gaugeFrame, "BOTTOM", MARGIN.WINDOW_SIDE / 2, 0)
  frame.scoreBoard = scoreBoard
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
      frame.timeFrame:UpdateTime(oldTime)
    end
  end
  local function FillOutWaitTimeInfo()
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "ENDED" and timeInfo.state ~= "RETIRED" then
      frame:HideScoreboard()
      return
    end
    frame.remainTime = tonumber(timeInfo.remainTime)
    if frame:HasHandler("OnUpdate") == false then
      frame:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  local ResetResult = function()
  end
  local function FillMemberInfo(data, index)
    if data == nil or index == nil then
      return
    end
    local nameTable = {
      name = data.name,
      result = data.result
    }
    local columnIndex = 1
    frame.scoreBoard:InsertData(index, columnIndex, data.rank)
    columnIndex = columnIndex + 1
    frame.scoreBoard:InsertData(index, columnIndex, nameTable)
    columnIndex = columnIndex + 1
    for idx = 1, frame.scoreBoard.scoreColumnCount do
      frame.scoreBoard:InsertData(index, columnIndex, data[frame.scoreBoard.scoreColumnKeys[idx]])
      columnIndex = columnIndex + 1
    end
    local rewardAmount = tostring(data.rewardAmount or 0)
    local bonusAmount = data.rewardBonusAmount or 0
    if bonusAmount > 0 then
      rewardAmount = string.format("%d %s(+%d)|r", tostring(data.rewardAmount or 0), FONT_COLOR_HEX.GREEN, bonusAmount)
    end
    frame.scoreBoard:InsertData(index, columnIndex, rewardAmount)
    columnIndex = columnIndex + 1
    frame.scoreBoard:InsertData(index, columnIndex, data.worldName)
  end
  function frame:FillResult()
    ResetResult()
    local memberInfo = X2BattleField:GetMembersDetailInfo()
    if memberInfo == nil then
      return
    end
    for idx = 1, #memberInfo do
      FillMemberInfo(memberInfo[idx], idx)
    end
    local info = X2BattleField:GetProgressEntireInfo()
    if info ~= nil then
      local victoryState = info.myVictoryState
      if victoryState == VS_LOSE then
        frame.gaugeFrame:SetGameResult("defeat")
      elseif victoryState == VS_WIN then
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
function ShowScoreboard_FreeForAll(isShow, playSound)
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil or timeInfo.state ~= "ENDED" and timeInfo.state ~= "RETIRED" then
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
