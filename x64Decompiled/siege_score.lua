local SiegeScoreWnd
local winScore = X2Dominion:GetSiegeWinScore()
local InfoTable = {
  HeadText = "00:00:00",
  BodyTextWidth = 80,
  Body = {
    {
      titleText = X2Locale:LocalizeUiText(DOMINION, "siege_score_body_title_offense"),
      bodyText = function(a)
        return X2Locale:LocalizeUiText(DOMINION, "siege_score", tostring(a), tostring(winScore.offense))
      end,
      highLight = function()
        return X2Dominion:IsNotOutlawOffensebyMyFaction()
      end
    },
    {
      titleText = X2Locale:LocalizeUiText(DOMINION, "siege_score_body_title_outlaw"),
      bodyText = function(a)
        return X2Locale:LocalizeUiText(DOMINION, "siege_score", tostring(a), tostring(winScore.outlaw))
      end,
      highLight = function()
        return X2Dominion:IsOutlawOffensebyMyFaction()
      end
    }
  },
  TailText = X2Locale:LocalizeUiText(DOMINION, "siege_score_win_condition"),
  GuideText = X2Locale:LocalizeUiText(DOMINION, "siege_score_guide")
}
local BODY_TEXTURE_HEIGHT = 25
function CreateHead(parent, info)
  local frame = CreateEmptyWindow("head", parent)
  frame:SetExtent(250, 35)
  frame:AddAnchor("TOPLEFT", parent, 0, 0)
  local bg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureColor("status_alpha_35")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local label = frame:CreateChildWidget("label", "head_label", 0, true)
  label:SetExtent(220, FONT_SIZE.XLARGE)
  label.style:SetFontSize(FONT_SIZE.XLARGE)
  label.style:SetShadow(true)
  label:AddAnchor("TOPLEFT", frame, 15, 0)
  label:AddAnchor("BOTTOMRIGHT", frame, -15, 0)
  ApplyTextColor(label, FONT_COLOR.BATTLEFIELD_TIME)
  label:SetText(info.HeadText)
  parent.headLabel = label
  frame:Show(true)
end
function CreateBody(parent, offsetY, index, info)
  local evenNum = false
  local frame = CreateEmptyWindow("head", parent)
  frame:SetExtent(250, 25)
  frame:AddAnchor("TOPLEFT", parent, 0, offsetY)
  local highLight = info.Body[index].highLight()
  if highLight == true then
    local bg = parent:CreateDrawable(TEXTURE_PATH.HUD, "my_influence_bg", "background")
    bg:SetTextureInfo("my_influence_bg", "default")
    bg:AddAnchor("TOPLEFT", frame, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", frame, -1, 0)
  end
  local title = frame:CreateChildWidget("label", "title" .. index, 0, true)
  title:SetExtent(212 - info.BodyTextWidth, FONT_SIZE.MIDDLE)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetShadow(true)
  title.style:SetFontSize(FONT_SIZE.MIDDLE)
  title:AddAnchor("LEFT", frame, 15, 0)
  local body = frame:CreateChildWidget("label", "body" .. index, 0, true)
  body:SetExtent(info.BodyTextWidth, FONT_SIZE.MIDDLE)
  body.style:SetAlign(ALIGN_RIGHT)
  body.style:SetFontSize(FONT_SIZE.MIDDLE)
  body:AddAnchor("RIGHT", frame, -15, 0)
  if highLight == true then
    ApplyTextColor(title, F_COLOR.GetColor("emerald_green"))
    ApplyTextColor(body, F_COLOR.GetColor("emerald_green"))
  else
    ApplyTextColor(title, FONT_COLOR.WHITE)
    ApplyTextColor(body, FONT_COLOR.WHITE)
  end
  title:SetText(info.Body[index].titleText)
  body:SetText(info.Body[index].bodyText(0))
  parent.bodyLabel[index] = body
  frame:Show(true)
end
function CreateTail(parent, info)
  local frame = CreateEmptyWindow("head", parent)
  frame:SetExtent(250, 35)
  frame:AddAnchor("BOTTOMLEFT", parent, 0, 0)
  local bg = frame:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  bg:SetTextureColor("status_alpha_35")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local label = frame:CreateChildWidget("label", "tail_label", 0, true)
  label:SetExtent(195, 14)
  label.style:SetFontSize(14)
  label.style:SetAlign(ALIGN_LEFT)
  label.style:SetShadow(true)
  label:AddAnchor("LEFT", frame, 15, 0)
  ApplyTextColor(label, FONT_COLOR.BATTLEFIELD_TIME)
  label:SetText(info.TailText)
  frame.label = label
  frame:Show(true)
  return frame
end
function CreateSiegeScoreWnd()
  local wnd = CreateEmptyWindow("siege_score", "UIParent")
  local bodyCount = #InfoTable.Body
  wnd:SetExtent(250, 70 + BODY_TEXTURE_HEIGHT * bodyCount)
  wnd:AddAnchor("TOPRIGHT", "UIParent", -225, 0)
  local teambg = wnd:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  teambg:SetTextureColor("alpha60")
  teambg:AddAnchor("TOPLEFT", wnd, 0, 0)
  teambg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  CreateHead(wnd, InfoTable)
  local bodyOffsetY = 35
  wnd.bodyLabel = {}
  for i = 1, bodyCount do
    CreateBody(wnd, bodyOffsetY, i, InfoTable)
    bodyOffsetY = bodyOffsetY + BODY_TEXTURE_HEIGHT
  end
  local tailWidget = CreateTail(wnd, InfoTable)
  local dragWindow = wnd:CreateChildWidget("emptywidget", "dragWindow", 0, true)
  dragWindow:AddAnchor("TOPLEFT", wnd, 0, 0)
  dragWindow:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  dragWindow:EnableDrag(true)
  local guide = W_ICON.CreateGuideIconWidget(wnd)
  guide:AddAnchor("LEFT", tailWidget.label, "RIGHT", 5, 0)
  local function OnEnterGuide()
    SetTooltip(InfoTable.GuideText, guide)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local OnLeaveGuide = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeaveGuide)
  local function OnDragStart(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    HideTooltip()
    wnd:StartMoving()
    self.moving = true
  end
  dragWindow:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop(self)
    if self.moving == true then
      wnd:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  dragWindow:SetHandler("OnDragStop", OnDragStop)
  return wnd
end
function UpdateHeadText(remainData)
  if SiegeScoreWnd == nil then
    return
  end
  local timeStr = string.format("%02d:%02d:%02d", remainData.hour, remainData.minute, remainData.second)
  SiegeScoreWnd.headLabel:SetText(timeStr)
end
function UpdateSiegeScore(offensePoint, outlawPoint)
  if SiegeScoreWnd == nil then
    SiegeScoreWnd = CreateSiegeScoreWnd()
  end
  SiegeScoreWnd:Show(true)
  for i = 1, #InfoTable.Body do
    local score = 0
    if i == 1 then
      score = offensePoint
    elseif i == 2 then
      score = outlawPoint
    end
    SiegeScoreWnd.bodyLabel[i]:SetText(InfoTable.Body[i].bodyText(score))
  end
end
function ShowSiegeScore(visible)
  if SiegeScoreWnd == nil then
    return
  end
  SiegeScoreWnd:Show(visible)
end
function UpdateSiegeTimer()
  if SiegeScoreWnd == nil then
    SiegeScoreWnd = CreateSiegeScoreWnd()
  end
  SiegeScoreWnd:Show(false)
  local remainData = X2Dominion:GetCurPeriodRemainDateByCurrentZone()
  if remainData == nil then
    return
  end
  SiegeScoreWnd:Show(true)
  UpdateHeadText(remainData)
end
function ClearSiegeScore()
  if SiegeScoreWnd == nil then
    return
  end
  SiegeScoreWnd.headLabel:SetText(InfoTable.HeadText)
  for i = 1, #InfoTable.Body do
    SiegeScoreWnd.bodyLabel[i]:SetText(InfoTable.Body[i].bodyText(0))
  end
end
