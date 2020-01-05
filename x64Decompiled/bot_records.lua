local JURY_OK_COUNT = 0
local function CreateBotRecordsWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:Show(false)
  wnd:SetCloseOnEscape(false)
  wnd:SetExtent(userTrialLocale.botRecords.windowWidth, 440)
  wnd:SetTitle(locale.trial.reportTitle)
  wnd:EnableHidingIsRemove(true)
  wnd.titleBar.closeButton:Show(false)
  wnd:SetSounds("crime_records")
  local leftFrame = CreateRecordsLeftFrame("leftFrame", wnd)
  leftFrame:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
  wnd.leftFrame = leftFrame
  local judgmentButton = wnd:CreateChildWidget("button", "judgmentButton", 0, true)
  judgmentButton:SetText(locale.trial.crimeRecordOk)
  ApplyButtonSkin(judgmentButton, BUTTON_BASIC.DEFAULT)
  judgmentButton:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin, -sideMargin)
  local JudgmentButtonLeftClickFunc = function(self)
    X2Trial:ConfirmCrimeRecords()
    self:Enable(false)
  end
  ButtonOnClickHandler(judgmentButton, JudgmentButtonLeftClickFunc)
  local stepInfoFrame = CreateStepInfoFrame("stepInfoFrame", wnd)
  stepInfoFrame:AddAnchor("RIGHT", judgmentButton, "LEFT", -sideMargin / 2, 0)
  wnd.stepInfoFrame = stepInfoFrame
  local pageListCtrl = CreatePageListCtrl(wnd, "listCtrl", 0)
  pageListCtrl:SetExtent(userTrialLocale.botRecords.listCtrlWidth, 295)
  pageListCtrl:AddAnchor("TOPLEFT", leftFrame, "TOPRIGHT", sideMargin / 2, 0)
  wnd.pageListCtrl = pageListCtrl
  local DataSetFuncReporterColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.reporterName)
    else
      subItem:SetText("")
    end
  end
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local LayoutFuncLimitLabelColumn = function(frame, rowIndex, colIndex, subItem)
    subItem:SetInset(5, 0, 5, 0)
    subItem:SetLimitWidth(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  pageListCtrl:InsertColumn(locale.trial.crimeRecordReportedBy, userTrialLocale.botRecords.columnWidth[1], LCCIT_STRING, DataSetFuncReporterColumn)
  pageListCtrl:InsertColumn(locale.trial.reportTime, userTrialLocale.botRecords.columnWidth[2], LCCIT_STRING, DataSetFunc, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertColumn(locale.trial.crimeRecordMemo, userTrialLocale.botRecords.columnWidth[3], LCCIT_STRING, DataSetFunc, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertRows(USER_TRIAL.MAX_ITEM_COUNT, false)
  DrawListCtrlUnderLine(pageListCtrl)
  for i = 1, #pageListCtrl.listCtrl.column do
    DrawListCtrlColumnSperatorLine(pageListCtrl.listCtrl.column[i], #pageListCtrl.listCtrl.column, i)
  end
  for i = 1, USER_TRIAL.MAX_ITEM_COUNT do
    do
      local subItem = pageListCtrl.listCtrl.items[i].subItems[1]
      local function OnEnter(self)
        local data = pageListCtrl:GetDataByViewIndex(i, 1)
        if data == nil then
          return
        end
        SetTargetAnchorTooltip(data.detailReportInfo, "TOPLEFT", self, "BOTTOMRIGHT", -15, -15)
      end
      subItem:SetHandler("OnEnter", OnEnter)
      local subItem3 = pageListCtrl.listCtrl.items[i].subItems[3]
      local function OnEnter(self)
        local data = pageListCtrl:GetDataByViewIndex(i, 3)
        if data == nil then
          return
        end
        SetTargetAnchorTooltip(data, "TOPLEFT", self, "BOTTOMRIGHT", -15, -15)
      end
      subItem3:SetHandler("OnEnter", OnEnter)
      local OnLeave = function()
        HideTooltip()
      end
      subItem:SetHandler("OnLeave", OnLeave)
      subItem3:SetHandler("OnLeave", OnLeave)
    end
  end
  function wnd:FillData(pageIndex)
    pageListCtrl:DeleteAllDatas()
    pageListCtrl.listCtrl:ClearSelection()
    if pageIndex == nil then
      pageIndex = 1
    end
    local crimeRecords = X2Trial:GetCrimeRecordsByPage(pageIndex)
    for i = 1, #crimeRecords do
      local detailReportInfo = string.format([[
%s
%s: %s]], crimeRecords[i][9], X2Locale:LocalizeUiText(TRIAL_TEXT, "record_id"), crimeRecords[i][1])
      local firstColumnData = {
        detailReportInfo = detailReportInfo,
        reporterName = tostring(crimeRecords[i][2])
      }
      pageListCtrl:InsertData(i, 1, firstColumnData)
      pageListCtrl:InsertData(i, 2, crimeRecords[i][10])
      pageListCtrl:InsertData(i, 3, crimeRecords[i][5])
    end
  end
  function pageListCtrl:OnPageChangedProc(curPageIdx)
    wnd:FillData(curPageIdx)
  end
  function wnd:FillLeftFrame(crimeData)
    local leftFrame = self.leftFrame
    local identikitPicture = self.leftFrame.identikitPicture
    identikitPicture.name:SetText(crimeData.defendant)
    identikitPicture.race:SetText(crimeData.race)
    identikitPicture.faction:SetText(crimeData.faction)
    leftFrame.crimePoint:FillItem(locale.trial.crimePointStr, tostring(crimeData.crimePoint))
    leftFrame.totalReportCount:FillItem(locale.trial.totalRecords, tostring(crimeData.totalRecords))
    leftFrame.takeCount:FillItem(locale.trial.arrestHistory, locale.trial.trialChoice(tostring(crimeData.acceptTrial), tostring(crimeData.acceptGuilty)))
    leftFrame.rulingHistory:FillItem(locale.trial.rulingHistory, locale.trial.rulingChoice(tostring(crimeData.guilty), tostring(crimeData.notGuilty)))
    leftFrame.totalImprisonmentTime:FillItem(locale.trial.jailTotal, locale.trial.jailMinutes(tostring(crimeData.totalSeconds / 60)))
  end
  local function OnHide()
    userTrial.botRecords = nil
    JURY_OK_COUNT = 0
  end
  wnd:SetHandler("OnHide", OnHide)
  local events = {
    TRIAL_TIMER = function(state, remainTable)
      local trialType = X2Trial:GetTrialType()
      if trialType == 0 then
        return
      end
      if state == TRIAL_WAITING_JURY or state == TRIAL_TESTIMONY or state == TRIAL_FINAL_STATEMENT then
        local timeString = locale.time.GetPeriodToMinutesSecondFormat(remainTable)
        local remainString = locale.trial.remainTime(timeString)
        wnd.stepInfoFrame.remainTime:SetText(remainString)
        if JURY_OK_COUNT == 0 then
          wnd.stepInfoFrame.step:SetText(locale.trial.remainCount("0", "0"))
        end
      end
    end,
    JURY_OK_COUNT = function(count, total)
      local trialType = X2Trial:GetTrialType()
      if trialType == 0 then
        return
      end
      JURY_OK_COUNT = count
      local juryString = locale.trial.remainCount(tostring(count), tostring(total))
      wnd.stepInfoFrame.step:SetText(juryString)
    end,
    RULING_STATUS = function()
      wnd:Show(false)
    end,
    RULING_CLOSED = function()
      wnd:Show(false)
    end,
    TRIAL_CLOSED = function()
      wnd:Show(false)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
local function ShowBotRecordsWindow(trialState)
  local trialType = X2Trial:GetTrialType()
  if trialType == 0 then
    return
  end
  local crimeData = X2Trial:GetCrimeData()
  if crimeData.total == -1 then
    return
  end
  if userTrial.botRecords == nil then
    userTrial.botRecords = CreateBotRecordsWindow("userTrial.botRecords", "UIParent")
    userTrial.botRecords:AddAnchor("TOP", "UIParent", 0, 160)
  end
  local enable = false
  if trialState == TRIAL_TESTIMONY then
    enable = crimeData.isJury and true or false
  end
  userTrial.botRecords.judgmentButton:Enable(enable)
  userTrial.botRecords.pageListCtrl:UpdatePage(crimeData.total, USER_TRIAL.MAX_ITEM_COUNT)
  userTrial.botRecords:FillData(1)
  userTrial.botRecords:FillLeftFrame(crimeData)
  userTrial.botRecords:Show(true)
end
UIParent:SetEventHandler("SHOW_CRIME_RECORDS", ShowBotRecordsWindow)
