local factionText = {
  X2Unit:GetTopLevelFactionNameById(NUIA_FACTION_ID),
  X2Unit:GetTopLevelFactionNameById(HARIHARA_FACTION_ID),
  X2Unit:GetTopLevelFactionNameById(OUTLAW_FACTION_ID)
}
local GetCompetitionLablePos = function(factionId)
  if factionId == NUIA_FACTION_ID then
    return 1
  elseif factionId == HARIHARA_FACTION_ID then
    return 2
  elseif factionId == OUTLAW_FACTION_ID then
    return 3
  end
  return 0
end
local MakeNameAndPointLabel = function(parent, anchor, id, extraWidth, offsetX, offsetY)
  local pointlabel = parent:CreateChildWidget("label", "pointLabel" .. id, 0, true)
  pointlabel:SetExtent(extraWidth, FONT_SIZE.MIDDLE)
  pointlabel:SetAutoResize(true)
  pointlabel:SetNumberOnly(true)
  pointlabel.style:SetAlign(ALIGN_RIGHT)
  pointlabel.style:SetShadow(true)
  pointlabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  pointlabel:AddAnchor("TOPRIGHT", anchor, "BOTTOMRIGHT", offsetX, offsetY)
  ApplyTextColor(pointlabel, FONT_COLOR.WHITE)
  pointlabel:SetText("0")
  local factionLabel = frame:CreateChildWidget("label", "factionLabel" .. id, 0, true)
  factionLabel:SetExtent(212 - extraWidth, FONT_SIZE.MIDDLE)
  factionLabel.style:SetAlign(ALIGN_LEFT)
  factionLabel.style:SetShadow(true)
  factionLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  factionLabel:AddAnchor("TOPLEFT", anchor, "BOTTOMLEFT", offsetX, offsetY)
  ApplyTextColor(factionLabel, FONT_COLOR.WHITE)
  return pointlabel, factionLabel
end
function CreateFactionCompetitionStateBoardWindow(id, parent)
  local competitionInfo = {
    name = nil,
    factionLabel = nil,
    pointLabel = nil
  }
  local pointLabelWidth = 0
  local extentWidth = 0
  frame = CreateEmptyWindow(id, parent)
  frame:Show(false)
  function frame:MakeOriginWindowPos(reset)
    if frame == nil then
      return
    end
    frame:RemoveAllAnchors()
    frame:SetExtent(250, 145 + extentWidth)
    if reset then
      frame:AddAnchor("TOPRIGHT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(-300), 0)
    else
      frame:AddAnchor("TOPRIGHT", "UIParent", -300, 0)
    end
  end
  frame:MakeOriginWindowPos()
  frame.zoneGroup = 0
  local bg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureInfo("team_bg", "alpha60")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local timerBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  timerBg:SetTextureInfo("team_bg", "status_alpha_35")
  timerBg:SetExtent(250, 35)
  timerBg:AddAnchor("TOPLEFT", frame, "TOPLEFT", 0, 0)
  local ruleBg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  ruleBg:SetTextureInfo("team_bg", "status_alpha_35")
  ruleBg:SetExtent(250, 35)
  ruleBg:AddAnchor("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
  local remainTime = frame:CreateChildWidget("label", "remainTime", 0, true)
  remainTime:SetExtent(220, FONT_SIZE.XLARGE)
  remainTime.style:SetFontSize(FONT_SIZE.XLARGE)
  remainTime.style:SetShadow(true)
  remainTime:AddAnchor("TOPLEFT", frame, 15, 7)
  ApplyTextColor(remainTime, FONT_COLOR.BATTLEFIELD_TIME)
  remainTime:SetText(GetCommonText("faction_competition_wait_state"))
  pointLabelWidth = 10
  competitionInfo.name = {}
  competitionInfo.factionLabel = {}
  competitionInfo.pointLabel = {}
  for id = 1, 3 do
    competitionInfo.name[id] = factionText[id]
    competitionInfo.pointLabel[id], competitionInfo.factionLabel[id] = MakeNameAndPointLabel(frame, remainTime, id, pointLabelWidth, 0, 14 + 25 * (id - 1))
  end
  local noticeLabel = frame:CreateChildWidget("textbox", "noticeLabel", 0, true)
  noticeLabel:SetExtent(195, 14)
  noticeLabel:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  noticeLabel:SetAutoResize(true)
  noticeLabel:SetAutoWordwrap(true)
  noticeLabel.style:SetAlign(ALIGN_LEFT)
  noticeLabel.style:SetShadow(true)
  noticeLabel.style:SetFontSize(14)
  noticeLabel:AddAnchor("TOPLEFT", frame, 15, 120)
  ApplyTextColor(noticeLabel, FONT_COLOR.SOFT_YELLOW)
  noticeLabel:SetText("")
  local dragWindow = frame:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", frame, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  dragWindow:EnableDrag(true)
  local infoTooltip = W_ICON.CreateGuideIconWidget(frame)
  infoTooltip:AddAnchor("TOPRIGHT", frame, -12, 117)
  infoTooltip.toolTipStr = ""
  local OnTooltipEnter = function(self)
    SetTooltip(self.toolTipStr, self)
  end
  infoTooltip:SetHandler("OnEnter", OnTooltipEnter)
  local OnDragStart = function(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    HideTooltip()
    frame:StartMoving()
    self.moving = true
  end
  dragWindow:SetHandler("OnDragStart", OnDragStart)
  local OnDragStop = function(self)
    if self.moving == true then
      frame:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  dragWindow:SetHandler("OnDragStop", OnDragStop)
  local function UpdateFactionLabelWidth()
    for i = 1, 3 do
      F_TEXT.ApplyEllipsisText(competitionInfo.factionLabel[i], 212 - pointLabelWidth)
      competitionInfo.factionLabel[i]:SetText(competitionInfo.name[i])
    end
  end
  local function UpdatePointAndLabelWidth(factionId, point)
    if factionId == nil then
      return 0
    end
    local pointStr = "0"
    if point ~= nil then
      pointStr = tostring(point)
    end
    local width = 0
    local pos = GetCompetitionLablePos(factionId)
    if pos > 0 then
      competitionInfo.pointLabel[pos]:SetText(pointStr)
      width = competitionInfo.pointLabel[pos]:GetWidth()
    end
    if width > pointLabelWidth then
      pointLabelWidth = width
      return 1
    else
      return 0
    end
  end
  local function InitLabelColor(factionId)
    for i = 1, 3 do
      ApplyTextColor(competitionInfo.factionLabel[i], FONT_COLOR.WHITE)
      ApplyTextColor(competitionInfo.pointLabel[i], FONT_COLOR.WHITE)
    end
    if factionId ~= nil then
      local myFactionbg = frame:CreateDrawable(TEXTURE_PATH.HUD, "my_influence_bg", "background")
      myFactionbg:SetTextureInfo("my_influence_bg", "default")
      myFactionbg:SetExtent(249, 25)
      local pos = GetCompetitionLablePos(factionId)
      if pos > 0 then
        ApplyTextColor(competitionInfo.factionLabel[pos], F_COLOR.GetColor("emerald_green"))
        ApplyTextColor(competitionInfo.pointLabel[pos], F_COLOR.GetColor("emerald_green"))
        myFactionbg:AddAnchor("TOPLEFT", competitionInfo.factionLabel[pos], -15, -(FONT_SIZE.MIDDLE / 2))
      end
    end
    pointLabelWidth = 10
    UpdateFactionLabelWidth()
  end
  function UpdateRemainTime(nowTime)
    if frame.zoneGroup == nil or frame.zoneGroup == 0 then
      return
    end
    if nowTime <= 0 then
      nowTime = 0
    end
    local hour, minute, second = GetHourMinuteSecondeFromSec(nowTime)
    local timeStr = string.format("%02d : %02d : %02d", hour, minute, second)
    remainTime:SetText(timeStr)
  end
  local oldTime = 0
  local timeCheck = 0
  function frame:OnUpdateTime(dt)
    timeCheck = timeCheck + dt
    if timeCheck < 500 then
      return
    end
    timeCheck = dt
    local remainTime = X2Map:GetZoneFactionCompetitionRemainTime(frame.zoneGroup)
    if remainTime == nil then
      return
    end
    if remainTime <= 0 then
      UpdateRemainTime(0)
      frame:ReleaseHandler("OnUpdate")
    end
    if oldTime ~= remainTime then
      oldTime = remainTime
      UpdateRemainTime(remainTime)
    end
  end
  function UpdatePoint(info)
    if info == nil then
      return
    end
    local rtn = 0
    for i = 1, #info do
      rtn = rtn + UpdatePointAndLabelWidth(info[i].factionId, info[i].point)
    end
    if rtn > 0 then
      UpdateFactionLabelWidth()
    end
  end
  function InitComeptitionInfo(info)
    frame.zoneGroup = 0
    infoTooltip.toolTipStr = ""
    noticeLabel:SetText("")
    if info == nil then
      return
    end
    if info.zoneGroup ~= nil then
      frame.zoneGroup = info.zoneGroup
    end
    noticeLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "faction_competition_win_condition", CommaStr(info.reqPoint)))
    if noticeLabel:GetLineCount() >= 2 then
      extentWidth = noticeLabel:GetHeight() - TEXTBOX_LINE_SPACE.LARGE
      ruleBg:RemoveAllAnchors()
      ruleBg:AddAnchor("TOPLEFT", frame, "BOTTOMLEFT", 0, -(35 + extentWidth))
      ruleBg:AddAnchor("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
    end
    infoTooltip.toolTipStr = X2Locale:LocalizeUiText(COMMON_TEXT, "faction_competition_tooltip", info.zoneGroupName, CommaStr(info.pcKillPt), CommaStr(info.npcKillPt), CommaStr(info.questPt))
    if info.remainTime == nil or 0 >= info.remainTime or frame.zoneGroup == 0 then
      remainTime:SetText(GetCommonText("faction_competition_wait_state"))
    else
      UpdateRemainTime(info.remainTime)
    end
    InitLabelColor(X2Unit:GetTopLevelFactionId("player"))
    if info.pointList ~= nil then
      UpdatePoint(info.pointList)
    end
  end
  function SetResultInfo(info)
    if info == nil then
      return
    end
    remainTime:SetText(GetCommonText("faction_competition_wait_state"))
    if info.pointList ~= nil then
      UpdatePoint(info.pointList)
    end
  end
  return frame
end
