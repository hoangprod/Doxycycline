local reportCrimeWnd
local function CreateReportBadUserWindow(id)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = CreateWindow(id, "UIParent")
  frame:Show(false)
  frame:SetCloseOnEscape(true)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:SetExtent(352, 544)
  frame:SetTitle(locale.reportBadUser.title)
  frame:EnableHidingIsRemove(true)
  local report_time = frame:CreateChildWidget("textbox", "report_time", 0, true)
  report_time:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH - 10)
  report_time:AddAnchor("TOP", frame, 5, titleMargin)
  report_time.style:SetAlign(ALIGN_LEFT)
  report_time.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(report_time, FONT_COLOR.MIDDLE_TITLE)
  W_ICON.DrawRoundDingbat(report_time)
  local location = frame:CreateChildWidget("textbox", "location", 0, true)
  location:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH - 10)
  location:AddAnchor("TOPLEFT", report_time, "BOTTOMLEFT", 0, 5)
  location.style:SetAlign(ALIGN_LEFT)
  location.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(location, FONT_COLOR.MIDDLE_TITLE)
  W_ICON.DrawRoundDingbat(location)
  location.dingbat:RemoveAllAnchors()
  location.dingbat:AddAnchor("TOPRIGHT", location, "TOPLEFT", -2, 3)
  local reportDesc = frame:CreateChildWidget("textbox", "reportDesc", 0, true)
  reportDesc:SetWidth(frame:GetWidth() - sideMargin * 2)
  reportDesc:AddAnchor("TOPLEFT", location, "BOTTOMLEFT", -10, 15)
  reportDesc.style:SetAlign(ALIGN_LEFT)
  reportDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(reportDesc, FONT_COLOR.DEFAULT)
  reportDesc:SetText(locale.reportBadUser.target)
  reportDesc:SetHeight(reportDesc:GetTextHeight())
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local report_edit = W_CTRL.CreateEdit("report_edit", frame)
  report_edit:SetExtent(312, 29)
  report_edit:AddAnchor("TOPLEFT", reportDesc, "BOTTOMLEFT", 0, 9)
  report_edit:SetMaxTextLength(namePolicyInfo.max)
  report_edit.style:SetColor(0, 0, 0, 1)
  report_edit:SetInset(8, 8, 8, 8)
  local reportDescReason = frame:CreateChildWidget("textbox", "reportDescReason", 0, true)
  reportDescReason:SetWidth(frame:GetWidth() - sideMargin * 2)
  reportDescReason:AddAnchor("TOPLEFT", report_edit, "BOTTOMLEFT", 0, 15)
  reportDescReason.style:SetAlign(ALIGN_LEFT)
  reportDescReason.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(reportDescReason, FONT_COLOR.DEFAULT)
  reportDescReason:SetText(locale.reportBadUser.reportReason)
  reportDescReason:SetHeight(reportDescReason:GetTextHeight())
  local radioData = {}
  for i = 1, 4 do
    local item = {
      text = userTrialLocale.TrailType.text[i]
    }
    table.insert(radioData, item)
  end
  local reportreasonRadio = CreateRadioGroup("reportreasonRadio", frame, "vertical")
  reportreasonRadio:SetWidth(reportDescReason:GetWidth())
  reportreasonRadio:SetData(radioData)
  reportreasonRadio:AddAnchor("TOPLEFT", reportDescReason, "BOTTOMLEFT", 0, 10)
  reportreasonRadio:Check(1)
  local radiobg = CreateContentBackground(reportreasonRadio, "TYPE2", "brown")
  radiobg:AddAnchor("TOPLEFT", reportreasonRadio, -5, -5)
  radiobg:AddAnchor("BOTTOMRIGHT", reportreasonRadio, 5, 5)
  function frame:ShowProc()
    self.report_edit_reason:SetText("")
  end
  local report_edit_reason = W_CTRL.CreateMultiLineEdit("report_edit_reason", frame)
  report_edit_reason:SetExtent(312, 120)
  report_edit_reason:AddAnchor("TOPLEFT", reportreasonRadio, "BOTTOMLEFT", 0, 12)
  report_edit_reason:SetMaxTextLength(MAX_REPORT_BAD_USER_DESCRIPTION_SIZE)
  report_edit_reason.style:SetColor(0, 0, 0, 1)
  report_edit_reason:SetInset(8, 8, 8, 8)
  report_edit_reason:CreateGuideText(locale.reportBadUser.writeReport, ALIGN_TOP_LEFT, {
    8,
    8,
    0,
    0
  })
  report_edit_reason.guideTextStyle:SetFontSize(FONT_SIZE.MIDDLE)
  report_edit_reason.guideTextStyle:SetColor(FONT_COLOR.GRAY[1], FONT_COLOR.GRAY[2], FONT_COLOR.GRAY[3], FONT_COLOR.GRAY[4])
  local reportDescLength = frame:CreateChildWidget("textbox", "reportDescLength", 0, true)
  reportDescLength:SetWidth(frame:GetWidth() - sideMargin * 2)
  reportDescLength:AddAnchor("TOPRIGHT", report_edit_reason, "BOTTOMRIGHT", 0, 10)
  reportDescLength.style:SetAlign(ALIGN_RIGHT)
  reportDescLength.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(reportDescLength, FONT_COLOR.MIDDLE_TITLE)
  local function SetEditBoxText()
    local len = report_edit_reason:GetTextLength()
    local str = string.format("%s%02d%s/%02d", FONT_COLOR_HEX.MIDDLE_TITLE, len, FONT_COLOR_HEX.MIDDLE_TITLE, MAX_REPORT_BAD_USER_DESCRIPTION_SIZE)
    reportDescLength:SetText(str)
  end
  function report_edit_reason:TextChangedFunc()
    SetEditBoxText()
  end
  SetEditBoxText()
  local reportDescAsk = frame:CreateChildWidget("textbox", "reportDescAsk", 0, true)
  reportDescAsk:SetWidth(frame:GetWidth() - sideMargin * 2)
  reportDescAsk:AddAnchor("TOP", reportDescLength, "BOTTOM", 0, 13)
  reportDescAsk.style:SetAlign(ALIGN_CENTER)
  reportDescAsk.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(reportDescAsk, FONT_COLOR.DEFAULT)
  reportDescAsk:SetText(locale.reportBadUser.askReport)
  reportDescAsk:SetHeight(reportDescAsk:GetTextHeight())
  local reportDescCount = frame:CreateChildWidget("textbox", "reportDescCount", 0, true)
  reportDescCount:SetExtent(frame:GetWidth() - sideMargin * 2, 30)
  reportDescCount:AddAnchor("TOP", reportDescAsk, "BOTTOM", 0, 14)
  reportDescCount.style:SetAlign(ALIGN_CENTER)
  reportDescCount.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(reportDescCount, FONT_COLOR.GRAY)
  reportDescCount:SetText(locale.reportBadUser.resetCount(tostring(24)))
  reportDescCount:SetHeight(reportDescCount:GetTextHeight())
  local report_View_btn = frame:CreateChildWidget("button", "report_View_btn", 0, true)
  report_View_btn:Show(true)
  report_View_btn:SetText(locale.reportBadUser.reportRecords)
  ApplyButtonSkin(report_View_btn, BUTTON_BASIC.DEFAULT)
  report_View_btn:AddAnchor("TOP", reportDescCount, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  local ReportViewButtonLeftClickFunc = function(self)
    ShowReportBadUser(true)
  end
  ButtonOnClickHandler(report_View_btn, ReportViewButtonLeftClickFunc)
  local report_ok_btn = frame:CreateChildWidget("button", "report_ok_btn", 0, true)
  report_ok_btn:AddAnchor("RIGHT", report_View_btn, "LEFT", 0, 0)
  local curReportCount = X2Trial:GetDailyReportBadUser()
  local maxReportCount = X2Trial:GetDailyReportBadUserMaxCount()
  if curReportCount >= maxReportCount then
    report_ok_btn:Enable(false)
  end
  local buttonStr = string.format("%s(%d/%d)", GetUIText(TRIAL_TEXT, "report_ok"), curReportCount, maxReportCount)
  report_ok_btn:SetText(buttonStr)
  ApplyButtonSkin(report_ok_btn, BUTTON_BASIC.DEFAULT)
  report_ok_btn:Show(true)
  local function GetSelectReportType()
    local selected = reportreasonRadio:GetChecked()
    return userTrialLocale.TrailType.key[selected]
  end
  local function ReportOKButtonLeftClickFunc(self)
    local msg = frame.report_edit_reason:GetText()
    local name = frame.report_edit:GetText()
    local selected = GetSelectReportType()
    X2Trial:ReportBadUser(name, msg, selected)
    reportBaduserFrame:ShowList(false)
    frame:Show(false)
  end
  ButtonOnClickHandler(report_ok_btn, ReportOKButtonLeftClickFunc)
  local report_Cancel_btn = frame:CreateChildWidget("button", "report_Cancel_btn", 0, true)
  report_Cancel_btn:AddAnchor("LEFT", report_View_btn, "RIGHT", 0, 0)
  report_Cancel_btn:SetText(GetCommonText("cancel"))
  ApplyButtonSkin(report_Cancel_btn, BUTTON_BASIC.DEFAULT)
  report_Cancel_btn:Show(true)
  local function ReportCancelButtonLeftClickFunc(self)
    frame:Show(false)
  end
  ButtonOnClickHandler(report_Cancel_btn, ReportCancelButtonLeftClickFunc)
  local buttonTable = {
    report_View_btn,
    report_ok_btn,
    report_Cancel_btn
  }
  AdjustBtnLongestTextWidth(buttonTable)
  local function SetFrameHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(frame.titleBar, report_View_btn)
    frame:SetHeight(height + -BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  end
  function frame:FillData(name, locationName)
    if name == nil then
      self.report_edit:SetText("")
    else
      self.report_edit:SetText(name)
    end
    local location = locale.trial.crimeReportLocation(locationName)
    self.location:SetText(location)
    self.location:SetHeight(self.location:GetTextHeight())
    local curTime = X2Time:GetLocalTime()
    local nowDate = X2Time:TimeToDate(curTime)
    local nowDateString = locale.time.GetDateToDateFormat(nowDate, DATE_FORMAT_FILTER1)
    local reportTime = locale.trial.crimeReportTime(nowDateString)
    self.report_time:SetText(reportTime)
    self.report_time:SetHeight(self.report_time:GetTextHeight())
    SetFrameHeight()
  end
  local function OnHide()
    reportCrimeWnd = nil
  end
  frame:SetHandler("OnHide", OnHide)
  return frame
end
local function ShowReportBadUserWindow(targetName, locationName)
  if reportCrimeWnd == nil then
    reportCrimeWnd = CreateReportBadUserWindow("reportBadUserWnd")
    reportCrimeWnd:FillData(targetName, locationName)
    reportCrimeWnd:Show(true)
    ADDON:RegisterContentWidget(UIC_REPORT_BAD_USER, reportCrimeWnd)
  else
    local show = not reportCrimeWnd:IsVisible()
    if show == true then
      reportCrimeWnd:FillData(targetName, locationName)
    end
    reportCrimeWnd:Show(show)
  end
end
UIParent:SetEventHandler("REPORT_BAD_USER", ShowReportBadUserWindow)
