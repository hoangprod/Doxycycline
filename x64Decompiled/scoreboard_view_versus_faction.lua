BATTLEFIELD_A_COL = {
  NAME = 1,
  KILL = 2,
  DEATH = 3,
  ASSIST = 4,
  SCORE = 5,
  REWARD = 6
}
EMBLEM_FACTION_TABLE = {
  175,
  176,
  161,
  183
}
EMBLEMINFO = {
  [175] = {
    bgKey = "nuia",
    iconKey = "icon_nuia",
    color = F_COLOR.GetColor("soda_blue", false),
    copsHeadIconKey = "icon_win_blue"
  },
  [176] = {
    bgKey = "hari",
    iconKey = "icon_hari",
    color = F_COLOR.GetColor("soft_green", false),
    copsHeadIconKey = "icon_win_red"
  },
  [161] = {
    bgKey = "outlaw",
    iconKey = "icon_outlaw",
    color = F_COLOR.GetColor("exp_orange", false),
    copsHeadIconKey = ""
  },
  [183] = {
    bgKey = "nation",
    iconKey = "icon_nation",
    color = F_COLOR.GetColor("bright_purple", false),
    copsHeadIconKey = ""
  }
}
MAX_EMBLEMINFO_COUNT = 4
function GetWinFactionName(info, victoryFaction)
  if info.myVictoryState == VS_DRAW then
    return
  end
  if info.endReason == BFER_ACHIEVEMENT_KILL_COUNT then
    if info.myVictoryState == VS_WIN then
      return info.corpsName, info.myCorpsKill
    elseif info.myVictoryState == VS_LOSE then
      return victoryFaction or ""
    end
  elseif info.endReason == BFER_ACHIEVEMENT_KILL_CORPS_HEAD then
    if info.myVictoryState == VS_WIN then
      return info.corpsName
    elseif info.myVictoryState == VS_LOSE then
      return victoryFaction or ""
    end
  end
end
local CreateScoreboardScrollListCtrl = function(id, parent)
  local widget = W_CTRL.CreateScrollListCtrl(id, parent)
  widget:Show(true)
  widget:SetExtent(870, 350)
  widget.listCtrl:EnableScroll(false)
  widget.scroll:Show(false)
  widget:EnbaleSort(false)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data == X2Unit:UnitName("player") then
        ApplyTextColor(subItem, FONT_COLOR.BATTLEFIELD_YELLOW)
      else
        ApplyTextColor(subItem, FONT_COLOR.WHITE)
      end
      subItem:SetText(data)
    end
  end
  local KillsDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    end
  end
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data.myScore then
        ApplyTextColor(subItem, FONT_COLOR.BATTLEFIELD_YELLOW)
      else
        ApplyTextColor(subItem, FONT_COLOR.WHITE)
      end
      subItem:SetText(data.default)
    end
  end
  local ScoreDataSetFunc = function(subItem, data, setValue)
    if setValue == nil then
      subItem:SetText("")
      return
    end
    if data.myScore then
      ApplyTextColor(subItem, FONT_COLOR.BATTLEFIELD_YELLOW)
    else
      ApplyTextColor(subItem, FONT_COLOR.WHITE)
    end
    local str = ""
    if data.bonus == nil then
      str = tostring(data.default)
    else
      str = string.format("%d + %d", data.default, data.bonus)
    end
    subItem:SetText(str)
  end
  local NameLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.WHITE)
    subItem:SetInset(15, 0, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetShadow(true)
    local list = widget:GetListCtrlItem(rowIndex)
    local selectedBg = list:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "list_mine", "background")
    selectedBg:AddAnchor("TOPLEFT", list, -15, 0)
    selectedBg:AddAnchor("BOTTOMRIGHT", list, 0, 0)
    selectedBg:Show(false)
    list.selectedBg = selectedBg
    local teamBg = list:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "list_team", "background")
    teamBg:AddAnchor("TOPLEFT", list, -15, 0)
    teamBg:AddAnchor("BOTTOMRIGHT", list, 0, 0)
    teamBg:Show(false)
    list.teamBg = teamBg
  end
  local KillLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.PURE_RED)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetShadow(true)
  end
  local DefaultLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.WHITE)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetShadow(true)
  end
  widget:InsertColumn(locale.faction.name, 270, LCCIT_STRING, NameDataSetFunc, nil, nil, NameLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.kill, 90, LCCIT_STRING, KillsDataSetFunc, nil, nil, KillLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.death, 90, LCCIT_STRING, DataSetFunc, nil, nil, DefaultLayoutSetFunc)
  widget:InsertColumn(locale.battlefield.scoreboard.assist, 90, LCCIT_STRING, DataSetFunc, nil, nil, DefaultLayoutSetFunc)
  widget:InsertColumn(GetCommonText("honor_points"), 140, LCCIT_STRING, ScoreDataSetFunc, nil, nil, DefaultLayoutSetFunc)
  widget:InsertColumn(GetCommonText("squad_info_list_server_name"), 170, LCCIT_STRING, DataSetFunc, nil, nil, DefaultLayoutSetFunc)
  widget:InsertRows(10, false)
  local SettingListColumn = function(listCtrl, column)
    listCtrl:SetColumnHeight(44)
    column.style:SetFontSize(FONT_SIZE.MIDDLE)
    column.style:SetShadow(true)
    SetButtonFontColor(column, GetWhiteButtonFontColor())
  end
  for i = 1, #widget.listCtrl.column do
    SettingListColumn(widget.listCtrl, widget.listCtrl.column[i])
  end
  local function OnEnter()
    SetTargetAnchorTooltip(GetCommonText("honor_points_tooltip"), "BOTTOMLEFT", widget.listCtrl.column[5], "TOPLEFT", 3, 3)
  end
  widget.listCtrl.column[5]:SetHandler("OnEnter", OnEnter)
  return widget
end
local SetViewFactionResult = function(id, parent)
  local stateTextureFrame = parent:CreateChildWidget("emptywidget", "gameResult", 0, true)
  stateTextureFrame:SetExtent(298, 61)
  stateTextureFrame:AddAnchor("TOP", parent, 0, 0)
  local bg = stateTextureFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_title", "background")
  bg:AddAnchor("TOPLEFT", stateTextureFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", stateTextureFrame, 0, 0)
  local stateTexture = stateTextureFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "guage", "background")
  stateTexture:AddAnchor("TOP", stateTextureFrame, 0, 7)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(907, 130)
  frame:AddAnchor("TOP", stateTextureFrame, "BOTTOM", 0, 12)
  frame.stateTexture = stateTexture
  frame.bg = bg
  local frameBg = frame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_main", "background")
  frameBg:AddAnchor("TOPLEFT", frame, 0, 0)
  frameBg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local winConditiontText = frame:CreateChildWidget("label", "winConditiontText", 0, true)
  winConditiontText:SetAutoResize(true)
  winConditiontText:SetHeight(FONT_SIZE.LARGE)
  winConditiontText.style:SetFontSize(FONT_SIZE.LARGE)
  winConditiontText.style:SetShadow(true)
  ApplyTextColor(winConditiontText, FONT_COLOR.WHITE)
  local icon = winConditiontText:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_WIN_CONDITION, "score", "artwork")
  icon:AddAnchor("RIGHT", winConditiontText, "LEFT", -7, 1)
  winConditiontText.icon = icon
  local CreateEmblem = function(parent, index, emblemInfo)
    local factionEmblem = parent:CreateChildWidget("label", "factionEmblem" .. index, 0, true)
    factionEmblem:SetExtent(208, 72)
    local factionEmblemBg = factionEmblem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_score", "background")
    factionEmblemBg:SetTextureColor(emblemInfo.bgKey)
    factionEmblemBg:SetExtent(190, 57)
    factionEmblemBg:AddAnchor("TOPLEFT", factionEmblem, 18, 0)
    factionEmblem.factionEmblemBg = factionEmblemBg
    local factionEmblemIcon = factionEmblem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, emblemInfo.iconKey, "artwork")
    factionEmblemIcon:AddAnchor("TOPLEFT", factionEmblem, 0, -9)
    factionEmblem.factionEmblemIcon = factionEmblemIcon
    local factionVicotryBG = factionEmblem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "effect", "artwork")
    factionVicotryBG:AddAnchor("TOPLEFT", factionEmblemIcon, -44, -24)
    factionVicotryBG:Show(false)
    factionEmblem.factionVicotryBG = factionVicotryBG
    local factionName = factionEmblem:CreateChildWidget("label", "factionName", 0, true)
    factionName:SetExtent(158, FONT_SIZE.MIDDLE)
    factionName.style:SetFontSize(FONT_SIZE.MIDDLE)
    factionName.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(factionName, emblemInfo.color)
    factionName:AddAnchor("TOPLEFT", factionEmblem, "TOPLEFT", 50, 7)
    local factionCopsHeadIcon = factionEmblem:CreateImageDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "artwork")
    factionCopsHeadIcon:SetTextureInfo(emblemInfo.copsHeadIconKey)
    factionCopsHeadIcon:AddAnchor("TOPLEFT", factionName, "TOPRIGHT", -5, -7)
    factionCopsHeadIcon:Show(false)
    factionEmblem.factionCopsHeadIcon = factionCopsHeadIcon
    local factionScore = factionEmblem:CreateChildWidget("label", "factionScore", 0, true)
    factionScore:SetExtent(158, FONT_SIZE.XLARGE)
    factionScore.style:SetFontSize(FONT_SIZE.XLARGE)
    factionScore.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(factionScore, emblemInfo.color)
    factionScore:AddAnchor("TOPLEFT", factionName, "BOTTOMLEFT", 0, 10)
    function factionEmblem:SetData(name, score, emblemInfo)
      self.factionName:SetText(name)
      self.factionScore:SetText(tostring(score))
      self.factionEmblemBg:SetTextureColor(emblemInfo.bgKey)
      local coords = {
        GetTextureInfo(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, emblemInfo.iconKey):GetCoords()
      }
      self.factionEmblemIcon:SetCoords(coords[1], coords[2], coords[3], coords[4])
      ApplyTextColor(self.factionName, emblemInfo.color)
      ApplyTextColor(self.factionScore, emblemInfo.color)
    end
    function factionEmblem:ShowVictoryBG(show)
      self.factionVicotryBG:Show(show)
    end
    function factionEmblem:ShowCorpsHead(show)
      self.factionCopsHeadIcon:Show(show)
    end
    return factionEmblem
  end
  frame.emblem = {}
  for i = 1, MAX_EMBLEMINFO_COUNT do
    local faction = EMBLEM_FACTION_TABLE[i]
    frame.emblem[i] = CreateEmblem(frame, i, EMBLEMINFO[faction])
    frame.emblem[i]:Show(false)
    if i == 1 then
      frame.emblem[i]:AddAnchor("TOPLEFT", frame, "TOPLEFT", 22, 61)
    else
      local beforeFrameEmblem = frame.emblem[i - 1]
      frame.emblem[i]:AddAnchor("TOPLEFT", beforeFrameEmblem, "TOPLEFT", beforeFrameEmblem:GetWidth() + 12, 0)
    end
  end
  function frame:SetEmblemInfo(data, factionIndex)
    local faction = data.faction
    local teamName = data.teamName
    local teamScore = data.teamScore
    self.emblem[factionIndex]:SetData(teamName, teamScore, EMBLEMINFO[faction])
    self.emblem[factionIndex]:Show(true)
  end
  function frame:SetVicotryState(endReason, data, factionIndex)
    local victoryState = data.victoryState
    if victoryState ~= nil and victoryState == VS_WIN then
      self.emblem[factionIndex]:ShowVictoryBG(true)
      local showCorpsHead = endReason == BFER_ACHIEVEMENT_KILL_CORPS_HEAD and true or false
      self.emblem[factionIndex]:ShowCorpsHead(showCorpsHead)
    else
      self.emblem[factionIndex]:ShowVictoryBG(false)
      self.emblem[factionIndex]:ShowCorpsHead(false)
    end
  end
  function frame:SetGameResult(resultStr)
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
  function frame:SetWinCondition(info, victoryFaction)
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
      local winTeamName, count = GetWinFactionName(info, victoryFaction)
      self.winConditiontText:SetText(locale.battlefield.scoreboardEndReason[2](winTeamName, count))
    elseif info.endReason == BFER_ACHIEVEMENT_KILL_CORPS_HEAD then
      self.winConditiontText.icon:SetCoords(0, 0, 16, 16)
      self.winConditiontText.icon:SetExtent(16, 16)
      local winTeamName = GetWinFactionName(info, victoryFaction)
      self.winConditiontText:SetText(locale.battlefield.scoreboardEndReason[3](winTeamName))
    end
    self.winConditiontText:RemoveAllAnchors()
    self.winConditiontText:AddAnchor("TOP", self, "TOP", 5, 12)
  end
  return frame
end
local function SetViewFactionMemberInfo(id, parent, target)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(907, 460)
  frame:AddAnchor("TOP", target, "BOTTOM", 0, 17)
  local tabStr = {
    GetCommonText("all"),
    "",
    "",
    "",
    ""
  }
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local tab = frame:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", frame, sideMargin, 0)
  tab:AddAnchor("BOTTOMRIGHT", frame, -sideMargin, -75)
  tab:SetCorner("TOPLEFT")
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  local tabCount = timeInfo.teamCount + 1
  for i = 1, tabCount do
    tab:AddSimpleTab(tabStr[i])
  end
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT_BATTLEFIELD_RESULT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT_BATTLEFIELD_RESULT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable)
  tab:SetGap(3)
  local tabBg = tab:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_main", "background")
  tabBg:AddAnchor("TOPLEFT", tab, -24, 40)
  tabBg:AddAnchor("BOTTOMRIGHT", frame, 5, 0)
  local topBg = tab:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_top", "background")
  topBg:SetExtent(907, 86)
  topBg:AddAnchor("TOPLEFT", tab, -24, 40)
  local bottomBg = tab:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_bottom", "background")
  bottomBg:SetExtent(907, 86)
  bottomBg:AddAnchor("BOTTOMLEFT", tab.window[1], "BOTTOMLEFT", -24, 0)
  local scoreBoard = CreateScoreboardScrollListCtrl("scoreBoard", frame)
  scoreBoard:AddAnchor("TOPLEFT", tab.window[1], 0, 0)
  local myRecordTitle = frame:CreateChildWidget("label", "myRecordTitle", 0, true)
  myRecordTitle:SetAutoResize(true)
  myRecordTitle:SetHeight(FONT_SIZE.LARGE)
  myRecordTitle.style:SetFontSize(FONT_SIZE.LARGE)
  myRecordTitle.style:SetAlign(ALIGN_LEFT)
  myRecordTitle:SetText(GetCommonText("my_record"))
  ApplyTextColor(myRecordTitle, FONT_COLOR.SOFT_YELLOW)
  myRecordTitle:AddAnchor("TOPLEFT", tab.window[1], "BOTTOMLEFT", 0, 10)
  local myRecorLabel = frame:CreateChildWidget("label", "myRecorLabel", 0, true)
  myRecorLabel:SetExtent(871, 30)
  myRecorLabel:AddAnchor("TOPLEFT", myRecordTitle, "BOTTOMLEFT", 0, 9)
  local myName = myRecorLabel:CreateChildWidget("label", "myName", 0, true)
  myName:SetExtent(270, 31)
  myName.style:SetFontSize(FONT_SIZE.MIDDLE)
  myName.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(myName, FONT_COLOR.BATTLEFIELD_YELLOW)
  myName:AddAnchor("TOPLEFT", myRecorLabel, "TOPLEFT", 12, 0)
  local myKills = myRecorLabel:CreateChildWidget("label", "myKills", 0, true)
  myKills:SetExtent(90, 31)
  myKills.style:SetFontSize(FONT_SIZE.MIDDLE)
  myKills.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(myKills, FONT_COLOR.PURE_RED)
  myKills:AddAnchor("TOPLEFT", myName, "TOPRIGHT", 0, 0)
  local myDeaths = myRecorLabel:CreateChildWidget("label", "myDeaths", 0, true)
  myDeaths:SetExtent(90, 31)
  myDeaths.style:SetFontSize(FONT_SIZE.MIDDLE)
  myDeaths.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(myDeaths, FONT_COLOR.BATTLEFIELD_YELLOW)
  myDeaths:AddAnchor("TOPLEFT", myKills, "TOPRIGHT", 0, 0)
  local myAssists = myRecorLabel:CreateChildWidget("label", "myAssists", 0, true)
  myAssists:SetExtent(90, 31)
  myAssists.style:SetFontSize(FONT_SIZE.MIDDLE)
  myAssists.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(myAssists, FONT_COLOR.BATTLEFIELD_YELLOW)
  myAssists:AddAnchor("TOPLEFT", myDeaths, "TOPRIGHT", 0, 0)
  local myScores = myRecorLabel:CreateChildWidget("label", "myScores", 0, true)
  myScores:SetExtent(140, 31)
  myScores.style:SetFontSize(FONT_SIZE.MIDDLE)
  myScores.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(myScores, FONT_COLOR.BATTLEFIELD_YELLOW)
  myScores:AddAnchor("TOPLEFT", myAssists, "TOPRIGHT", 0, 0)
  local myServerName = myRecorLabel:CreateChildWidget("label", "myServerName", 0, true)
  myServerName:SetExtent(170, 31)
  myServerName.style:SetFontSize(FONT_SIZE.MIDDLE)
  myServerName.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(myServerName, FONT_COLOR.BATTLEFIELD_YELLOW)
  myServerName:AddAnchor("TOPLEFT", myScores, "TOPRIGHT", 0, 0)
  local myRecorLabelBg = myRecorLabel:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "list_mine", "background")
  myRecorLabelBg:AddAnchor("TOPLEFT", myRecorLabel, -15, 0)
  myRecorLabelBg:AddAnchor("BOTTOMRIGHT", myRecorLabel, -22, 0)
  myRecorLabel.myRecorLabelBg = myRecorLabelBg
  function frame:SetTabTitle(data)
    for i = 2, tabCount do
      if data[i - 1] then
        self.tab.selectedButton[i]:SetText(data[i - 1].teamName)
        self.tab.unselectedButton[i]:SetText(data[i - 1].teamName)
      else
        self.tab.selectedButton[i]:Enable(false)
        self.tab.selectedButton[i]:Show(false)
        self.tab.unselectedButton[i]:Enable(false)
        self.tab.unselectedButton[i]:Show(false)
      end
    end
  end
  function frame:SetMyScorInfo(data)
    self.myRecordTitle:Show(true)
    self.myRecorLabel.myName:SetText(data.name)
    self.myRecorLabel.myKills:SetText(tostring(data.memberNPcKills))
    self.myRecorLabel.myDeaths:SetText(tostring(data.memberNDeaths))
    self.myRecorLabel.myAssists:SetText(tostring(data.memberNPcKillAssists))
    local scoreStr = string.format("%d + %d", data.memberScores, data.memberBonusScores)
    if data.memberBonusScores == 0 then
      scoreStr = string.format("%d", data.memberScores)
    end
    self.myRecorLabel.myScores:SetText(scoreStr)
    self.myRecorLabel.myServerName:SetText(data.memberWorldName)
    self.myRecorLabel.myRecorLabelBg:Show(true)
  end
  function frame:ResetMyScoreIno()
    self.myRecordTitle:Show(false)
    self.myRecorLabel.myName:SetText("")
    self.myRecorLabel.myKills:SetText("")
    self.myRecorLabel.myDeaths:SetText("")
    self.myRecorLabel.myAssists:SetText("")
    self.myRecorLabel.myScores:SetText("")
    self.myRecorLabel.myServerName:SetText("")
    self.myRecorLabel.myRecorLabelBg:Show(false)
  end
  return frame
end
local function SetViewOfScoreboard(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  local factionResultFrame = SetViewFactionResult("factionResultFrame", frame)
  local totalHeight = frame.factionResultFrame:GetHeight() + 75
  local leaveFrameTarget = factionResultFrame
  SetViewFactionMemberInfo("factionMemberInfoFrame", frame, factionResultFrame)
  leaveFrameTarget = frame.factionMemberInfoFrame
  totalHeight = totalHeight + frame.factionMemberInfoFrame:GetHeight() + 25
  local leaveFrame = frame:CreateChildWidget("emptywidget", "leaveFrame", 0, true)
  leaveFrame:SetExtent(907, 50)
  leaveFrame:AddAnchor("TOP", leaveFrameTarget, "BOTTOM", 0, 3)
  totalHeight = totalHeight + leaveFrame:GetHeight()
  local leaveFrameBg = leaveFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT_FACTION, "bg_main", "background")
  leaveFrameBg:AddAnchor("TOPLEFT", frame.leaveFrame, 0, 0)
  leaveFrameBg:AddAnchor("BOTTOMRIGHT", frame.leaveFrame, 0, 0)
  local timeFrame = CreateTimeFrame(frame, "scoreboard")
  timeFrame:AddAnchor("CENTER", leaveFrame, 0, 0)
  timeFrame.time = 0
  local askLeaveBtn = frame:CreateChildWidget("button", "askLeaveBtn", 0, true)
  askLeaveBtn:SetText(locale.battlefield.immediatelyExit)
  ApplyButtonSkin(askLeaveBtn, BUTTON_BASIC.DEFAULT)
  askLeaveBtn:AddAnchor("LEFT", timeFrame.nowTime, "RIGHT", 10, 0)
  frame:SetExtent(907, totalHeight)
  frame:AddAnchor("CENTER", parent, 0, -50)
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
    frame.factionMemberInfoFrame.scoreBoard:DeleteAllDatas()
    for i = 1, 10 do
      frame.factionMemberInfoFrame.scoreBoard:GetListCtrlItem(i).selectedBg:Show(false)
      frame.factionMemberInfoFrame.scoreBoard:GetListCtrlItem(i).teamBg:Show(false)
    end
  end
  local function FillMemberInfo(data, memberIndex)
    if frame.factionMemberInfoFrame == nil then
      return
    end
    if data == nil then
      return
    end
    local target = frame.factionMemberInfoFrame.scoreBoard
    if target == nil then
      return
    end
    local npcDeathsTable = {
      default = tostring(data.memberNDeaths),
      myScore = data.myScore
    }
    local npcAssistsTable = {
      default = tostring(data.memberNPcKillAssists),
      myScore = data.myScore
    }
    local scoreTable = {
      default = tostring(data.memberScores),
      bonus = tostring(data.memberBonusScores),
      myScore = data.myScore
    }
    local worldNameTable = {
      default = tostring(data.memberWorldName),
      myScore = data.myScore
    }
    target:InsertData(memberIndex, 1, data.name)
    target:InsertData(memberIndex, 2, tostring(data.memberNPcKills))
    target:InsertData(memberIndex, 3, npcDeathsTable)
    target:InsertData(memberIndex, 4, npcAssistsTable)
    target:InsertData(memberIndex, 5, scoreTable)
    target:InsertData(memberIndex, 6, worldNameTable)
    if data.myScore then
      target:GetListCtrlItem(memberIndex).selectedBg:Show(true)
    elseif data.memberSquad then
      target:GetListCtrlItem(memberIndex).selectedBg:Show(false)
      target:GetListCtrlItem(memberIndex).teamBg:Show(true)
    end
  end
  local function FillFactionInfo()
    local factionInfo = X2BattleField:GetVersusFactionInfo()
    if factionInfo == nil then
      return
    end
    local scoreInfo = X2BattleField:GetProgressEntireInfo()
    if scoreInfo == nil then
      return
    end
    local victoryFaction
    for i = 1, #factionInfo do
      frame.factionResultFrame:SetEmblemInfo(factionInfo[i], i)
      frame.factionResultFrame:SetVicotryState(scoreInfo.endReason, factionInfo[i], i)
      local victoryState = factionInfo[i].victoryState
      if victoryState ~= nil and victoryState == VS_WIN then
        victoryFaction = factionInfo[i].teamName
      end
    end
    frame.factionMemberInfoFrame:SetTabTitle(factionInfo)
    local coprsVictoryState = scoreInfo.myVictoryState
    if coprsVictoryState ~= nil then
      if coprsVictoryState == VS_LOSE then
        frame.factionResultFrame:SetGameResult("defeat")
      elseif coprsVictoryState == VS_WIN then
        frame.factionResultFrame:SetGameResult("win")
      else
        frame.factionResultFrame:SetGameResult("draw")
      end
      frame.factionResultFrame:SetWinCondition(scoreInfo, victoryFaction)
    end
  end
  local function FillTeamInfo(selected)
    if selected == nil or selected == 1 then
      selected = -1
    else
      selected = selected - 2
    end
    if selected ~= -1 then
      frame.factionMemberInfoFrame:ResetMyScoreIno()
    else
      local myInfo = X2BattleField:GetVersusFactionMyInfo()
      frame.factionMemberInfoFrame:SetMyScorInfo(myInfo)
    end
    local memberInfo = X2BattleField:GetVersusFactionMemberInfo(selected)
    if memberInfo == nil then
      return
    end
    for i = 1, #memberInfo do
      FillMemberInfo(memberInfo[i], i)
    end
  end
  function frame:FillResult()
    ResetResult()
    FillFactionInfo()
    FillTeamInfo()
    FillOutWaitTimeInfo()
  end
  function frame.factionMemberInfoFrame.tab:OnTabChanged(selected)
    ResetResult()
    FillTeamInfo(selected)
  end
  frame.factionMemberInfoFrame.tab:SetHandler("OnTabChanged", frame.factionMemberInfoFrame.tab.OnTabChanged)
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
function ShowScoreboard_VersusFacion(isShow, playSound)
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
