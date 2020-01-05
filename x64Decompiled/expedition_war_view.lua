local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
EXPEDITION_WAR_COL = {
  NAME = 1,
  JOB = 2,
  KILL = 3
}
local function CreateScoreboardScrollListCtrl(id, parent)
  local widget = W_CTRL.CreateScrollListCtrl(id, parent)
  widget:Show(true)
  widget:SetExtent(474, 408)
  widget:SetUseDoubleClick(true)
  widget.listCtrl:ChangeSortMartTexture()
  widget.listCtrl.AscendingSortMark:SetColor(1, 1, 1, 0.5)
  widget.listCtrl.DescendingSortMark:SetColor(1, 1, 1, 0.5)
  local bg = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg", "background")
  bg:SetTextureColor("bgcolor")
  bg:AddAnchor("TOPLEFT", widget, -sideMargin, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, sideMargin, titleMargin)
  local deco = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "deco", "background")
  deco:AddAnchor("TOPLEFT", widget, -sideMargin, 0)
  deco:AddAnchor("BOTTOMRIGHT", widget, sideMargin, titleMargin + sideMargin / 2)
  widget.deco = deco
  local upperDeco = widget:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "bg_line", "background")
  upperDeco:SetExtent(widget:GetWidth(), 11)
  upperDeco:AddAnchor("TOP", widget, 8, 0)
  upperDeco:SetTextureColor("default")
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
  local JobDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    end
  end
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    end
  end
  local KillDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.textbox:SetText(data.default)
    else
      subItem.textbox:SetText("")
    end
  end
  local DefaultLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
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
  local NameAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.NAME]
    local valueB = b[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.NAME]
    return valueA < valueA and true or false
  end
  local NameDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.NAME]
    local valueB = b[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.NAME]
    return valueA > valueB and true or false
  end
  local JobAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.JOB]
    local valueB = b[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.JOB]
    return valueA < valueA and true or false
  end
  local JobDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.JOB]
    local valueB = b[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.JOB]
    return valueA > valueB and true or false
  end
  local KillAscendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.KILL]
    local valueB = b[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.KILL]
    return tonumber(valueA) < tonumber(valueB) and true or false
  end
  local KillDescendingSortFunc = function(a, b)
    local valueA = a[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.KILL]
    local valueB = b[ROWDATA_COLUMN_OFFSET + EXPEDITION_WAR_COL.KILL]
    return tonumber(valueA) > tonumber(valueB) and true or false
  end
  widget:InsertColumn(locale.faction.name, 241, LCCIT_STRING, NameDataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, DefaultLayoutSetFunc)
  widget:InsertColumn(locale.community.job, 116, LCCIT_STRING, JobDataSetFunc, JobAscendingSortFunc, JobDescendingSortFunc, DefaultLayoutSetFunc)
  widget:InsertColumn(GetCommonText("expedition_war_kill_count"), 87, LCCIT_STRING, DataSetFunc, KillAscendingSortFunc, KillDescendingSortFunc, KillLayoutSetFunc)
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
  local guageFrame = W_ETC.CreateScoreBoardGuageSection(id, parent, parent:GetWidth() - MARGIN.WINDOW_SIDE)
  local title = guageFrame:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetExtent(150, FONT_SIZE.XLARGE)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  title.style:SetAlign(ALIGN_CENTER)
  title.style:SetShadow(true)
  ApplyTextColor(title, FONT_COLOR.SOFT_YELLOW)
  title:AddAnchor("TOP", guageFrame, 0, 15)
  title:SetText(GetCommonText("expedition_war_kill_score"))
  local bg = guageFrame:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "gauge_bg", "background")
  bg:AddAnchor("TOPLEFT", guageFrame, -MARGIN.WINDOW_SIDE * 1.2, 0)
  bg:AddAnchor("BOTTOMRIGHT", guageFrame, MARGIN.WINDOW_SIDE * 1.2, 13)
  guageFrame.totalKillScore:SetText(GetCommonText("expedition_war_versus"))
  guageFrame:EnableDrag(true)
  function guageFrame:OnDragStart(arg)
    self.moving = true
    parent:StartMoving()
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
  end
  guageFrame:SetHandler("OnDragStart", guageFrame.OnDragStart)
  function guageFrame:OnDragStop()
    if self.moving then
      parent:StopMovingOrSizing()
      X2Cursor:ClearCursor()
      self.moving = false
    end
  end
  guageFrame:SetHandler("OnDragStop", guageFrame.OnDragStop)
  return guageFrame
end
function SetViewOfExpeditionWarScoreBoard(id, parent)
  local frame = UIParent:CreateWidget("window", id, parent)
  frame:SetExtent(969, 490)
  frame:AddAnchor("CENTER", parent, 0, 0)
  frame:SetCloseOnEscape(true)
  local gaugeFrame = CreateGaugeFrame("gaugeFrame", frame)
  local scoreboardOur = CreateScoreboardScrollListCtrl(frame:GetId() .. ".scoreboard.our", frame)
  scoreboardOur:AddAnchor("TOPLEFT", frame.gaugeFrame, "BOTTOMLEFT", 0, 0)
  scoreboardOur.deco:SetColor(ConvertColor(35), ConvertColor(85), ConvertColor(153), 0.5)
  frame.scoreboardOur = scoreboardOur
  local scoreboardEnemy = CreateScoreboardScrollListCtrl(frame:GetId() .. ".scoreboard.enemy", frame)
  scoreboardEnemy:AddAnchor("TOPRIGHT", frame.gaugeFrame, "BOTTOMRIGHT", 0, 0)
  scoreboardEnemy.deco:SetCoords(355, 100, -355, 245)
  scoreboardEnemy.deco:SetColor(ConvertColor(153), ConvertColor(35), ConvertColor(35), 0.5)
  frame.scoreboardEnemy = scoreboardEnemy
  local timeFrame = CreateTimeFrame(frame, "expedition_war_scoreboard")
  timeFrame:AddAnchor("BOTTOM", frame, 0, 45)
  timeFrame.time = 0
  local closeButton = frame:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", frame, -3, 3)
  ApplyButtonSkin(closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  function closeButton:OnClick()
    frame:Show(false)
  end
  closeButton:SetHandler("OnClick", closeButton.OnClick)
  local tooltipButton = W_ICON.CreateGuideIconWidget(frame)
  tooltipButton:AddAnchor("LEFT", frame.timeFrame, "RIGHT", 5, 0)
  local function OnEnterWidget()
    str = GetCommonText("expedition_war_kill_score_tooltip")
    SetTargetAnchorTooltip(str, "TOPLEFT", tooltipButton, "BOTTOMRIGHT", 5, -15)
  end
  tooltipButton:SetHandler("OnEnter", OnEnterWidget)
  return frame
end
