local JURY_OK_COUNT = 0
local function CreateCrimeRecordsWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:Show(false)
  wnd:SetCloseOnEscape(false)
  wnd:SetExtent(userTrialLocale.crimeRecords.windowWidth, 440)
  wnd:SetTitle(locale.trial.crimeRecordTitle)
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
  pageListCtrl:SetExtent(userTrialLocale.crimeRecords.listCtrlWidth, 295)
  pageListCtrl:AddAnchor("TOPLEFT", leftFrame, "TOPRIGHT", sideMargin / 2, 0)
  wnd.pageListCtrl = pageListCtrl
  local DataSetFuncReporterColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.reporterName)
    else
      subItem:SetText("")
    end
  end
  local DataSetFuncCrimeTypeColumn = function(subItem, data, setValue)
    if setValue then
      subItem.icon:Show(true)
      subItem.icon:SetTypeIcon(data.crimeType)
    else
      subItem.icon:Show(false)
    end
  end
  local DataSetFuncVictimColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.victimName)
    else
      subItem:SetText("")
    end
  end
  local DataSetFuncMemoColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local LayouFuncCrimeTypeColumn = function(frame, rowIndex, colIndex, subItem)
    local icon = CreateCrimeTypeIcon(subItem, 0)
    icon:AddAnchor("TOPLEFT", subItem, -2, 0)
    icon:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
    subItem.icon = icon
  end
  local LayoutFuncMemoColumn = function(frame, rowIndex, colIndex, subItem)
    subItem:SetInset(5, 0, 5, 0)
    subItem:SetLimitWidth(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  pageListCtrl:InsertColumn(locale.trial.crimeRecordReportedBy, userTrialLocale.crimeRecords.columnWidth[1], LCCIT_STRING, DataSetFuncReporterColumn)
  pageListCtrl:InsertColumn(locale.trial.crimeRecordType, userTrialLocale.crimeRecords.columnWidth[2], LCCIT_WINDOW, DataSetFuncCrimeTypeColumn, nil, nil, LayouFuncCrimeTypeColumn)
  pageListCtrl:InsertColumn(locale.trial.crimeRecordVictim, userTrialLocale.crimeRecords.columnWidth[3], LCCIT_STRING, DataSetFuncVictimColumn)
  pageListCtrl:InsertColumn(locale.trial.crimeRecordMemo, userTrialLocale.crimeRecords.columnWidth[4], LCCIT_STRING, DataSetFuncMemoColumn, nil, nil, LayoutFuncMemoColumn)
  pageListCtrl:InsertRows(USER_TRIAL.MAX_ITEM_COUNT, false)
  DrawListCtrlUnderLine(pageListCtrl)
  for i = 1, #pageListCtrl.listCtrl.column do
    DrawListCtrlColumnSperatorLine(pageListCtrl.listCtrl.column[i], #pageListCtrl.listCtrl.column, i)
  end
  local guide = W_ICON.CreateGuideIconWidget(wnd)
  guide:AddAnchor("LEFT", pageListCtrl.pageControl, "RIGHT", 1, 1)
  wnd.guide = guide
  local OnEnter = function(self)
    SetTooltip(locale.trial.crimeRecordGuideText, self)
  end
  wnd.guide:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  wnd.guide:SetHandler("OnLeave", OnLeave)
  local GetCrimeTypeString = function(crimeType, doodadName, theftSkillName)
    if crimeType == 2 then
      return locale.trial.crimeTypeAssault
    elseif crimeType == 3 then
      return locale.trial.crimeTypeMurder
    elseif crimeType == 4 then
      return locale.trial.theft_tip(doodadName, theftSkillName)
    else
      return locale.trial.crimeTypeEtc
    end
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
      local subItem2 = pageListCtrl.listCtrl.items[i].subItems[2].icon
      local function OnEnter(self)
        local data = pageListCtrl:GetDataByViewIndex(i, 2)
        if data == nil then
          return
        end
        local str = string.format([[
%s
%s: %s]], GetCrimeTypeString(data.crimeType, data.doodadName, data.theftSkillName), X2Locale:LocalizeUiText(TRIAL_TEXT, "record_id"), data.crimeRecordId)
        SetTargetAnchorTooltip(str, "TOPLEFT", self, "BOTTOMRIGHT", -15, -15)
      end
      subItem2:SetHandler("OnEnter", OnEnter)
      local subItem3 = pageListCtrl.listCtrl.items[i].subItems[3]
      local function OnEnter(self)
        local data = pageListCtrl:GetDataByViewIndex(i, 3)
        if data == nil then
          return
        end
        if data.victimInfo == "" then
          return
        end
        SetTargetAnchorTooltip(data.victimInfo, "TOPLEFT", self, "BOTTOMRIGHT", -15, -15)
      end
      subItem3:SetHandler("OnEnter", OnEnter)
      local subItem4 = pageListCtrl.listCtrl.items[i].subItems[4]
      local function OnEnter(self)
        local data = pageListCtrl:GetDataByViewIndex(i, 4)
        if data == nil or data == "" then
          return
        end
        SetTargetAnchorTooltip(data, "TOPLEFT", self, "BOTTOMRIGHT", -15, -15)
      end
      subItem4:SetHandler("OnEnter", OnEnter)
      local OnLeave = function()
        HideTooltip()
      end
      subItem:SetHandler("OnLeave", OnLeave)
      subItem2:SetHandler("OnLeave", OnLeave)
      subItem3:SetHandler("OnLeave", OnLeave)
      subItem4:SetHandler("OnLeave", OnLeave)
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
%s]], crimeRecords[i][9], crimeRecords[i][10])
      local firstColumnData = {
        detailReportInfo = detailReportInfo,
        reporterName = tostring(crimeRecords[i][2])
      }
      pageListCtrl:InsertData(i, 1, firstColumnData)
      local secondColumtData = {
        crimeRecordId = crimeRecords[i][1],
        crimeType = crimeRecords[i][3],
        doodadName = crimeRecords[i][8],
        theftSkillName = crimeRecords[i][7]
      }
      pageListCtrl:InsertData(i, 2, secondColumtData)
      local victimInfo = ""
      if crimeRecords[i][6] ~= nil then
        victimInfo = string.format("%s: %s", locale.trial.crimeRecordBelongTo, crimeRecords[i][6])
      end
      local thirdColumnData = {
        victimName = tostring(crimeRecords[i][4]),
        victimInfo = victimInfo
      }
      pageListCtrl:InsertData(i, 3, thirdColumnData)
      pageListCtrl:InsertData(i, 4, crimeRecords[i][5])
    end
  end
  wnd.listCtrl = listCtrl
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
    userTrial.crimeRecords = nil
    JURY_OK_COUNT = 0
  end
  wnd:SetHandler("OnHide", OnHide)
  local events = {
    TRIAL_TIMER = function(state, remainTable)
      local trialType = X2Trial:GetTrialType()
      if trialType ~= 0 then
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
      if trialType ~= 0 then
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
local function ShowCrimeRecordsWindow(trialState)
  local trialType = X2Trial:GetTrialType()
  if trialType ~= 0 then
    return
  end
  local crimeData = X2Trial:GetCrimeData()
  if crimeData.total == -1 then
    return
  end
  if userTrial.crimeRecords == nil then
    userTrial.crimeRecords = CreateCrimeRecordsWindow("crimeRecordsWndRenewal", "UIParent")
    userTrial.crimeRecords:AddAnchor("TOP", "UIParent", 0, 160)
  end
  local enable = false
  if trialState == TRIAL_TESTIMONY then
    enable = crimeData.isJury and true or false
  end
  userTrial.crimeRecords.judgmentButton:Enable(enable)
  userTrial.crimeRecords.pageListCtrl:UpdatePage(crimeData.total, USER_TRIAL.MAX_ITEM_COUNT)
  userTrial.crimeRecords:FillData(1)
  userTrial.crimeRecords:FillLeftFrame(crimeData)
  userTrial.crimeRecords:Show(true)
end
UIParent:SetEventHandler("SHOW_CRIME_RECORDS", ShowCrimeRecordsWindow)
