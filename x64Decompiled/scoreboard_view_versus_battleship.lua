local MEMBER_MAX = 5
local CreateTeamItemLine = function(teamIndex, parent)
  local line = parent:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "line", "background")
  line:SetTextureColor("default")
  line:AddAnchor("BOTTOM", parent, "TOP", 0, -2)
  local colorLine = parent:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "line", "background")
  colorLine:SetTextureColor("default")
  colorLine:AddAnchor("BOTTOM", parent, "TOP", 0, -1)
  parent.colorLine = colorLine
  function colorLine:SetLineColor(teamName)
    colorLine:SetTextureInfo("line", teamName)
  end
end
local function CreateRewardFrame(teamIndex, parent)
  local rewardFrame = parent:CreateChildWidget("emptywidget", "rewardFrame" .. teamIndex, 0, true)
  rewardFrame:SetExtent(220, 32)
  CreateTeamItemLine(teamIndex, rewardFrame)
  local coinLabel = rewardFrame:CreateChildWidget("label", "coinLabel", 0, true)
  coinLabel:SetExtent(90, FONT_SIZE.MIDDLE)
  coinLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  coinLabel.style:SetAlign(ALIGN_LEFT)
  coinLabel:SetText(locale.battlefield.scoreboard.reward)
  coinLabel:AddAnchor("TOPLEFT", rewardFrame, 10, 9)
  ApplyTextColor(coinLabel, FONT_COLOR.ORANGE)
  local coinCountLabel = rewardFrame:CreateChildWidget("textbox", "coinLabel", 0, true)
  coinCountLabel:SetExtent(82, FONT_SIZE.LARGE)
  coinCountLabel.style:SetFontSize(FONT_SIZE.LARGE)
  coinCountLabel.style:SetAlign(ALIGN_RIGHT)
  coinCountLabel:SetText("0")
  coinCountLabel:AddAnchor("TOPLEFT", coinLabel, "TOPRIGHT", 2, -1)
  ApplyTextColor(coinCountLabel, FONT_COLOR.ORANGE)
  local coinIcon = rewardFrame:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "icon_battlefield", "background")
  coinIcon:AddAnchor("LEFT", coinCountLabel, "RIGHT", 6, 0)
  function rewardFrame:UpdateResult(resultInfo, teamName)
    if resultInfo == nil then
      coinCountLabel:SetText("0")
      return
    end
    local rewardAmount = tostring(resultInfo.coinRewardAmount or 0)
    local bonusAmount = resultInfo.coinRewardBonusAmount or 0
    if bonusAmount > 0 then
      rewardAmount = string.format("%d %s(+%d)|r", tostring(resultInfo.coinRewardAmount or 0), FONT_COLOR_HEX.GREEN, bonusAmount)
    end
    coinCountLabel:SetText(rewardAmount)
    rewardFrame.colorLine:SetLineColor(teamName)
  end
  return rewardFrame
end
local function CreateMemberFrame(teamIndex, index, parent)
  local memberFrame = parent:CreateChildWidget("emptywidget", string.format("memberFrame_%d_%d", teamIndex, index), 0, true)
  memberFrame:SetExtent(220, 38)
  CreateTeamItemLine(teamIndex, memberFrame)
  local nameText = memberFrame:CreateChildWidget("label", "nameText", 0, true)
  nameText:SetExtent(200, FONT_SIZE.MIDDLE)
  nameText.style:SetFontSize(FONT_SIZE.MIDDLE)
  nameText.style:SetAlign(ALIGN_LEFT)
  nameText:AddAnchor("TOPLEFT", memberFrame, 10, 3)
  ApplyTextColor(nameText, FONT_COLOR.WHITE)
  local ratingText = memberFrame:CreateChildWidget("textbox", "nameText", 0, true)
  ratingText:SetExtent(200, FONT_SIZE.MIDDLE)
  ratingText.style:SetFontSize(FONT_SIZE.MIDDLE)
  ratingText.style:SetAlign(ALIGN_RIGHT)
  ratingText:AddAnchor("TOPLEFT", nameText, "BOTTOMLEFT", 0, 2)
  function memberFrame:UpdateResult(resultInfo, teamName)
    memberFrame.colorLine:SetLineColor(teamName)
    if resultInfo == nil then
      nameText:SetText("")
      ratingText:SetText("")
      return
    end
    nameText:SetText(resultInfo.name)
    local totalRating = resultInfo.totalRating
    local deltaRating = resultInfo.deltaRating
    if deltaRating < 0 then
      ratingText:SetText(string.format("%d %s(%d)|r", totalRating, FONT_COLOR_HEX.ROSE_PINK, deltaRating))
    else
      ratingText:SetText(string.format("%d %s(+%d)|r", totalRating, FONT_COLOR_HEX.GREEN, deltaRating))
    end
  end
  return memberFrame
end
local function CreateTeamFrame(index, parent)
  local teamFrame = parent:CreateChildWidget("emptywidget", "teamFrame" .. index, 0, true)
  teamFrame:SetExtent(220, 415)
  local bg = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "team_bg", "background")
  bg:AddAnchor("TOPLEFT", teamFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", teamFrame, 0, 0)
  local teambg = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "team_bg", "background")
  teambg:AddAnchor("TOPLEFT", teamFrame, 0, 0)
  teambg:AddAnchor("BOTTOMRIGHT", teamFrame, 0, 0)
  local frameLineTop = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "team_bg_line", "background")
  frameLineTop:AddAnchor("TOPLEFT", teamFrame, 0, 0)
  local frameLineBottom = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "team_bg_line", "background")
  frameLineBottom:AddAnchor("BOTTOMLEFT", teamFrame, 0, 0)
  local nameBg = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "name_bg", "background")
  nameBg:SetExtent(212, 38)
  nameBg:AddAnchor("TOPLEFT", teamFrame, 7, 1)
  local teamText = teamFrame:CreateChildWidget("label", "teamText", 0, true)
  teamText:SetExtent(200, FONT_SIZE.LARGE)
  teamText.style:SetFontSize(FONT_SIZE.LARGE)
  teamText.style:SetAlign(ALIGN_CENTER)
  teamText.style:SetShadow(true)
  teamText:AddAnchor("TOPLEFT", nameBg, 0, 11)
  local teamIcon = teamFrame:CreateDrawable("ui/battlefield/team_morpheus.dds", "mark", "background")
  teamIcon:AddAnchor("TOP", teamFrame, "TOP", 0, 39)
  local memberOffsetY = 183
  teamFrame.memberFrame = {}
  for i = 1, MEMBER_MAX do
    teamFrame.memberFrame[i] = CreateMemberFrame(index, i, teamFrame)
    teamFrame.memberFrame[i]:AddAnchor("TOPLEFT", teamFrame, "TOPLEFT", 0, memberOffsetY)
    memberOffsetY = memberOffsetY + 40
    if i == MEMBER_MAX then
      teamFrame.rewardFrame = CreateRewardFrame(index, teamFrame)
      teamFrame.rewardFrame:AddAnchor("TOPLEFT", teamFrame, "TOPLEFT", 0, memberOffsetY)
    end
  end
  local myTeamImageFrame = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "my_team", "overlay")
  myTeamImageFrame:AddAnchor("TOPLEFT", teamFrame, 0, 0)
  myTeamImageFrame:AddAnchor("BOTTOMRIGHT", teamFrame, 0, 0)
  local rankIcon = teamFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_RESULT, "icon_rank_1", "overlay")
  rankIcon:AddAnchor("BOTTOM", teamFrame, "TOP", 0, 11)
  function teamFrame:UpdateResult(resultInfo)
    if resultInfo == nil then
      teamIcon:Show(false)
      teamText:SetText("")
      rankIcon:Show(false)
      myTeamImageFrame:Show(false)
      return
    end
    local faction = resultInfo.faction
    local teamName = GetBattleShipFactionStr(faction)
    teamIcon:SetTexture(string.format("ui/battlefield/team_%s.dds", teamName))
    teamIcon:SetTextureInfo("mark")
    teamText:SetText(resultInfo.teamName)
    ApplyTextColor(teamText, BATTLE_SHIP_FACTION[faction].TEAM_FONT_COLOR)
    rankIcon:SetTextureInfo(string.format("icon_rank_%d", resultInfo.rank))
    myTeamImageFrame:Show(resultInfo.myTeam)
    local frameLineKey = "team_bg_line"
    frameLineTop:SetTextureInfo(frameLineKey, teamName)
    frameLineBottom:SetTextureInfo(frameLineKey, teamName)
    teambg:SetTextureInfo("team_bg_color", teamName)
    for i = 1, MEMBER_MAX do
      teamFrame.memberFrame[i]:UpdateResult(resultInfo.members[i], teamName)
    end
    teamFrame.rewardFrame:UpdateResult(resultInfo, teamName)
  end
  return teamFrame
end
local function CreateScoreBoard(id, parent)
  local window = UIParent:CreateWidget("emptywidget", id, parent)
  window:SetExtent(929, 550)
  window:AddAnchor("CENTER", parent, 0, 0)
  local bgMargin = 20
  local bg = window:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg", "background")
  bg:AddAnchor("TOPLEFT", window, -bgMargin, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, bgMargin, 0)
  local bgLine = window:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg_line", "background")
  bgLine:AddAnchor("TOPLEFT", window, 0, 42)
  bgLine:AddAnchor("TOPRIGHT", window, 0, 42)
  local titleText = window:CreateChildWidget("label", "titleText", 0, true)
  titleText:SetAutoResize(true)
  titleText:SetHeight(FONT_SIZE.XLARGE)
  titleText.style:SetFontSize(FONT_SIZE.XLARGE)
  titleText.style:SetShadow(true)
  titleText:SetText(locale.battlefield.scoreboard.battle_ship_result)
  titleText:AddAnchor("TOP", window, "TOP", 0, 14)
  ApplyTextColor(titleText, FONT_COLOR.SOFT_YELLOW)
  local teamOffSetX = 19
  window.teamFrame = {}
  for i = 1, BATTLE_SHIP_FACTION_COUNT do
    window.teamFrame[i] = CreateTeamFrame(i, window)
    window.teamFrame[i]:AddAnchor("TOPLEFT", window, teamOffSetX, 92)
    teamOffSetX = window.teamFrame[i]:GetWidth() + teamOffSetX + 3
  end
  local timeFrame = CreateTimeFrame(window, "scoreboard")
  timeFrame:AddAnchor("BOTTOM", window, -40, -10)
  timeFrame.time = 0
  local askLeaveBtn = window:CreateChildWidget("button", "askLeaveBtn", 0, true)
  askLeaveBtn:SetText(locale.battlefield.immediatelyExit)
  ApplyButtonSkin(askLeaveBtn, BUTTON_BASIC.DEFAULT)
  askLeaveBtn:AddAnchor("LEFT", timeFrame.nowTime, "RIGHT", 40, 0)
  local askLeaveBtnLeftClickFunc = function()
    X2BattleField:AskLeaveInstantGame()
  end
  ButtonOnClickHandler(askLeaveBtn, askLeaveBtnLeftClickFunc)
  local function OnUpdateTime(self, dt)
    if window.remainTime < 0 then
      return
    end
    if window.oldTime ~= window.remainTime then
      window.oldTime = window.remainTime
      window.timeFrame:UpdateTime(window.remainTime)
    end
  end
  function window:FillInstantTimeInfo()
    local TestTimeInfo = function()
      timeInfo = {
        startTime = 0,
        endTime = 10000,
        nowTime = 0
      }
      return timeInfo
    end
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "ENDED" then
      window:HideScoreboard()
      return
    end
    window.remainTime = tonumber(timeInfo.remainTime)
    if window:HasHandler("OnUpdate") == false then
      window:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  function window:HideScoreboard()
    window:ReleaseHandler("OnUpdate")
    window:Show(false)
  end
  local OnHideScoreboard = function()
    battlefield.scoreboard = nil
  end
  window:SetHandler("OnHide", OnHideScoreboard)
  function window:FillResultData()
    local resultData = X2BattleField:GetMembersDetailInfo()
    if resultData == nil then
      window:HideScoreboard()
      return
    end
    for i = 1, BATTLE_SHIP_FACTION_COUNT do
      window.teamFrame[i]:UpdateResult(resultData[i])
    end
  end
  local events = {
    LEAVED_INSTANT_GAME_ZONE = function()
      window:HideScoreboard()
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
function ShowScoreboard_VersusBattleShip(isShow, playSound)
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil or timeInfo.state ~= "ENDED" then
    return
  end
  if isShow and battlefield.scoreboard == nil then
    battlefield.scoreboard = CreateScoreBoard("battlefield.scoreboard", "UIParent")
    battlefield.scoreboard:EnableHidingIsRemove(true)
    battlefield.scoreboard:FillInstantTimeInfo()
    battlefield.scoreboard:FillResultData()
  end
  if isShow then
    battlefield.scoreboard:Show(true)
    if playSound then
      BattleFieldResultSound()
    end
  else
    battlefield.scoreboard:HideScoreboard()
  end
end
