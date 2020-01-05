local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreateUpperFrame = function(id, parent)
  local frame = SetViewOfUpperFrame(id, parent)
  frame:AddAnchor("TOPLEFT", parent, 0, 10)
  local OnEnter = function(self)
    if self.tip == nil or self.tip == "" then
      return
    end
    SetHorizonTooltip(self.tip, self, 5)
  end
  frame.myCurRecord:SetHandler("OnEnter", OnEnter)
  local OnClick = function()
    onlyPlayerRecordUpdate = true
    X2Rank:RequestPlayerRecords(selectedRankTabIdx)
  end
  frame.refreshButton:SetHandler("OnClick", OnClick)
  function frame:Lock()
    self.refreshButton:Enable(false)
  end
  function frame:Unlock()
    self.refreshButton:Enable(true)
  end
  function frame:FillPeriod(periodStr, inProgress)
    self.period:SetPeriod(periodStr, inProgress, true)
  end
  function frame:FillRewardInfo(rewardInfo, periodInfo)
    if rewardInfo == nil then
      self.rewardButton:Enable(false)
      return
    end
    self.rewardButton:Enable(true)
  end
  return frame
end
local CreateLegacyRankingListCtrl = function(id, parent, height)
  local frame = W_CTRL.CreateScrollListCtrl(id, parent)
  frame:Show(true)
  frame:SetExtent(760, height)
  local GradeDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.bg:SetVisible(false)
      if data.value == nil then
        return
      end
      SetRankingGradeDataFunc(subItem.bg, subItem.icon, data.value)
      subItem.icon:SetVisible(data.isStartIndex)
    else
      subItem.bg:SetVisible(false)
      if subItem.icon ~= nil then
        subItem.icon:SetVisible(false)
      end
    end
  end
  local GradeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    CommonGradeLayoutFunc(widget.listCtrl, subItem)
    local icon = subItem:CreateImageDrawable(TEXTURE_PATH.RANKING_GRADE, "overlay")
    icon:AddAnchor("CENTER", subItem, 2, 0)
    subItem.icon = icon
  end
  local CommonDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.value))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.name))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local ValueDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local str = ""
      if data.v1 ~= nil and data.v2 ~= nil then
        if data.rankKind == RANKING.TAB_FISH_LENGTH or data.rankKind == RANKING.TAB_FISH_WEIGHT then
          str = string.format("%.2f", data.v1 / 1000)
        elseif data.rankKind == RANKING.TAB_GOODS_VALUE then
          str = string.format("%s", data.v1)
        else
          str = string.format("%s / %s", data.v1, data.v2)
        end
      else
        str = string.format("%s", data.v1 or data.v2)
      end
      subItem:SetText(str)
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local ServerNameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.worldName))
      ChangeColorForPlayer(subItem, data.name, data.worldName)
    else
      subItem:SetText("")
    end
  end
  local RecordDataSetFunc = function(subItem, data, setValue)
    if setValue then
      ChangeColorForPlayer(subItem, data.name, data.worldName)
      if data.month == nil and data.day == nil and data.hour == nil and data.minute == nil and data.second == nil then
        subItem:SetText("-")
        return
      end
      local str = rankingLocale.timeFilter.record(data)
      subItem:SetText(str)
    else
      subItem:SetText("")
    end
  end
  local columnWidth = rankingLocale.columnWidth
  frame:InsertColumn(locale.ranking.rank, columnWidth[1], LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  frame:InsertColumn(locale.ranking.placing, columnWidth[2], LCCIT_STRING, CommonDataSetFunc, nil, nil, nil)
  frame:InsertColumn(locale.common.name, columnWidth[3], LCCIT_CHARACTER_NAME, NameDataSetFunc, nil, nil, nil)
  frame:InsertColumn(locale.tooltip.hour, columnWidth[4], LCCIT_STRING, ValueDataSetFunc, nil, nil, nil)
  frame:InsertColumn(locale.server.name, columnWidth[5], LCCIT_STRING, ServerNameDataSetFunc, nil, nil, nil, nil)
  frame:InsertColumn(locale.ranking.recordTime, columnWidth[6], LCCIT_STRING, RecordDataSetFunc, nil, nil, nil)
  frame:InsertRows(20, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  local valueColumn = frame.listCtrl.column[4]
  local OnEnter = function(self)
    if self.tip == nil or self.tip == "" then
      return
    end
    SetTooltip(self.tip, self)
  end
  valueColumn:SetHandler("OnEnter", OnEnter)
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    frame.listCtrl.column[i]:Enable(false)
    SetButtonFontColor(frame.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  local insetInfo = {leftInset = 70, rightInset = 10}
  for i = 1, frame:GetRowCount() do
    ListCtrlItemGuideLine(frame.listCtrl.items, frame:GetRowCount(), insetInfo)
  end
  local GetGradeInfo = function(rankInfo, maxPeopleCount)
    local nonePeopleGrade
    for i = #rankInfo, 1, -1 do
      if maxPeopleCount >= rankInfo[i].from and maxPeopleCount <= rankInfo[i].to then
        nonePeopleGrade = i + 1
        break
      end
    end
    if nonePeopleGrade == nil then
      nonePeopleGrade = 1
    end
    return #rankInfo, nonePeopleGrade
  end
  local scopeIndex = 0
  local function GetScopeValue(scopeInfo, index)
    if #scopeInfo == 0 then
      return "-"
    end
    index = index + 1
    scopeIndex = index
    if index > #scopeInfo then
      return "-"
    else
      return string.format("%d \226\150\188", scopeInfo[index].v1)
    end
  end
  function frame:FillSnapshot(snapshotInfo, snapshotScopeInfo)
    self:DeleteAllDatas()
    scopeIndex = 0
    local rankInfo = snapshotScopeInfo.rankScopes
    local scopeInfo = snapshotScopeInfo.snapshotScopes
    local rankKind = X2Rank:GetRankKind(selectedRankTabIdx)
    for i = 1, self:GetRowCount() do
      if self.listCtrl.items[i].line ~= nil then
        self.listCtrl.items[i].line:SetVisible(false)
      end
    end
    local visibleCnt = #snapshotInfo >= self:GetRowCount() and self:GetRowCount() or #snapshotInfo
    for i = 1, visibleCnt do
      if self.listCtrl.items[i].line ~= nil then
        self.listCtrl.items[i].line:SetVisible(true)
      end
    end
    local index
    for i = 1, #snapshotInfo do
      if snapshotInfo[i] ~= nil then
        local gradeInfo = {
          value = GetPlayerGrade(rankInfo, i),
          isStartIndex = GetGradeStartIndex(rankInfo, i),
          name = snapshotInfo[i].name,
          worldName = snapshotInfo[i].worldName
        }
        self:InsertData(i, 1, gradeInfo)
        local rankInfo = {
          value = i,
          name = snapshotInfo[i].name,
          worldName = snapshotInfo[i].worldName
        }
        self:InsertData(i, 2, rankInfo)
        local nameInfo = {
          name = snapshotInfo[i].name,
          worldName = snapshotInfo[i].worldName
        }
        self:InsertData(i, 3, nameInfo)
        local valueInfo = {
          v1 = snapshotInfo[i].v1,
          v2 = snapshotInfo[i].v2,
          rankKind = rankKind,
          name = snapshotInfo[i].name,
          worldName = snapshotInfo[i].worldName
        }
        self:InsertData(i, 4, valueInfo)
        local worldInfo = {
          name = snapshotInfo[i].name,
          worldName = snapshotInfo[i].worldName
        }
        self:InsertData(i, 5, worldInfo)
        local recordTimeInfo = {
          year = snapshotInfo[i].year,
          month = snapshotInfo[i].month,
          day = snapshotInfo[i].day,
          hour = snapshotInfo[i].hour,
          minute = snapshotInfo[i].minute,
          second = snapshotInfo[i].second,
          name = snapshotInfo[i].name,
          worldName = snapshotInfo[i].worldName
        }
        self:InsertData(i, 6, recordTimeInfo)
      end
      index = i
    end
    local gradeCount, noneRankGrade = GetGradeInfo(rankInfo, #snapshotInfo)
    if gradeCount ~= noneRankGrade then
      if index == nil then
        index = 0
      end
      local grade = noneRankGrade
      local startIndex = index + 1
      for i = startIndex, startIndex + (gradeCount - noneRankGrade) do
        local gradeInfo = {value = grade, isStartIndex = true}
        self:InsertData(i, 1, gradeInfo)
        local rankInfo = {value = "-"}
        self:InsertData(i, 2, rankInfo)
        local nameInfo = {name = "-", worldName = nil}
        self:InsertData(i, 3, nameInfo)
        local valueInfo = {
          v1 = GetScopeValue(scopeInfo, scopeIndex),
          v2 = nil
        }
        self:InsertData(i, 4, valueInfo)
        local worldInfo = {worldName = "-"}
        self:InsertData(i, 5, worldInfo)
        local recordTimeInfo = {
          year = nil,
          month = nil,
          day = nil,
          hour = nil,
          minute = nil,
          second = nil
        }
        self:InsertData(i, 6, recordTimeInfo)
        grade = grade + 1
      end
    end
  end
  return frame
end
function CreateCommonRankingWidget(id, parent, rewardWindow)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  widget.upperFrame = CreateUpperFrame("upperFrame", widget)
  widget.code = id
  local activeRankList
  activeRankList = CreateLegacyRankingListCtrl("scrollList", widget, 516)
  activeRankList:AddAnchor("TOPLEFT", widget.upperFrame, "BOTTOMLEFT", 0, 5)
  activeRankList:Show(true)
  local updateTime = widget:CreateChildWidget("label", "updateTime", 0, true)
  updateTime:SetAutoResize(true)
  updateTime:SetHeight(FONT_SIZE.MIDDLE)
  updateTime:AddAnchor("TOPLEFT", activeRankList, "BOTTOMLEFT", 0, sideMargin / 2)
  ApplyTextColor(updateTime, FONT_COLOR.DEFAULT)
  local tip = widget:CreateChildWidget("textbox", "tip", 0, true)
  tip:Show(false)
  tip:SetExtent(760, FONT_SIZE.MIDDLE)
  tip:AddAnchor("TOPLEFT", updateTime, "BOTTOMLEFT", 0, 3)
  tip:SetText(GetUIText(COMMON_TEXT, "ranking_tip"))
  tip:SetHeight(tip:GetTextHeight())
  tip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(tip, FONT_COLOR.GRAY)
  function widget:HideRewardWindow()
    if rewardWindow ~= nil then
      rewardWindow:Show(false)
    end
  end
  function widget:Activate(selectedIdx)
    X2Rank:RequestPlayerRecords(selectedIdx)
    parent:WaitPage(true)
  end
  function widget:RefreshRankTypeUI(str, valueColumnTooltip, processExplain, guideDesc)
    activeRankList.listCtrl.column[4]:SetText(str)
    activeRankList.listCtrl.column[4].tip = valueColumnTooltip
    widget.upperFrame.myCurRecord.tip = string.format("%s", processExplain)
    tip:SetText(GetUIText(COMMON_TEXT, guideDesc))
  end
  function widget:Lock()
    widget.upperFrame:Lock()
  end
  function widget:Unlock()
    widget.upperFrame:Unlock()
  end
  function widget:FillSnapshot(snapShotInfo, snapshotScopeInfo)
    activeRankList:FillSnapshot(snapShotInfo, snapshotScopeInfo)
  end
  function widget:FillRewardInfo(rewardInfo, periodInfo)
    widget.upperFrame:FillRewardInfo(rewardInfo, periodInfo)
    rewardWindow:FillRewardInfo(rewardInfo, periodInfo)
  end
  local function RewardButtonLeftClickFunc(self)
    if rewardWindow == nil then
      return
    end
    rewardWindow:RemoveAllAnchors()
    rewardWindow:AddAnchor("TOPRIGHT", self, "BOTTOMRIGHT", 0, sideMargin / 2)
    rewardWindow:Raise()
    rewardWindow:Show(not rewardWindow:IsVisible())
  end
  ButtonOnClickHandler(widget.upperFrame.rewardButton, RewardButtonLeftClickFunc)
  function widget:GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(widget.upperFrame, activeRankList)
    return height + sideMargin / 1.7
  end
  return widget
end
