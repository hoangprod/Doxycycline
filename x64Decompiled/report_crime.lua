local reportMode = 1
local function CreateReportCrimeWindow(id)
  local frame = CreateWindow(id, "UIParent")
  frame:Show(false)
  frame:SetCloseOnEscape(false)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:SetExtent(POPUP_WINDOW_WIDTH, 240)
  frame:SetTitle(locale.trial.crimeReport)
  frame:EnableHidingIsRemove(true)
  frame:SetUILayer("system")
  local reportDesc = frame:CreateChildWidget("textbox", "reportDesc", 0, true)
  reportDesc:SetWidth(frame:GetWidth() - MARGIN.WINDOW_SIDE * 2)
  reportDesc:AddAnchor("TOP", frame, 0, MARGIN.WINDOW_TITLE)
  reportDesc.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(reportDesc, FONT_COLOR.DEFAULT)
  local report_edit = W_CTRL.CreateMultiLineEdit("report_edit", frame)
  report_edit.bg:Show(false)
  report_edit:SetExtent(312, 53)
  report_edit:AddAnchor("TOP", reportDesc, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  report_edit:SetMaxTextLength(50)
  report_edit.style:SetColor(0, 0, 0, 1)
  report_edit:SetInset(10, 10, 20, 0)
  report_edit:CreateGuideText(locale.trial.input_report, ALIGN_TOP_LEFT, {
    12,
    12,
    0,
    0
  })
  function frame:ShowProc()
    self.report_edit:SetText("")
  end
  local input_texture = report_edit:CreateDrawable(TEXTURE_PATH.DEFAULT, "mail_write_bg", "background")
  input_texture:SetTextureColor("default")
  input_texture:AddAnchor("TOPLEFT", report_edit, 0, 0)
  local input_texture_2 = report_edit:CreateDrawable(TEXTURE_PATH.DEFAULT, "mail_write_2_bg", "background")
  input_texture_2:SetTextureColor("default")
  input_texture_2:AddAnchor("BOTTOMRIGHT", report_edit, 0, 0)
  local location = frame:CreateChildWidget("textbox", "location", 0, true)
  location:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH - 10)
  location:AddAnchor("TOPLEFT", report_edit, "BOTTOMLEFT", MARGIN.WINDOW_SIDE / 1.5, MARGIN.WINDOW_SIDE / 1.5)
  location.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(location, FONT_COLOR.TITLE)
  W_ICON.DrawRoundDingbat(location)
  local reportTime = frame:CreateChildWidget("textbox", "reportTime", 0, true)
  reportTime:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH - 10)
  reportTime:AddAnchor("TOPLEFT", location, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 3)
  reportTime.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(reportTime, FONT_COLOR.TITLE)
  W_ICON.DrawRoundDingbat(reportTime)
  local info = {
    leftButtonStr = GetUIText(TRIAL_TEXT, "report_ok"),
    leftButtonLeftClickFunc = function()
      local msg = frame.report_edit:GetText()
      if reportMode == 1 then
        X2Trial:ReportCrime(msg)
      else
        X2Trial:ReportBotSuspect(msg)
      end
      frame:Show(false)
    end,
    rightButtonStr = GetUIText(MSG_BOX_BTN_TEXT, "cancel"),
    rightButtonLeftClickFunc = function()
      frame:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(frame, info)
  local function SetFrameHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(frame.titleBar, frame.reportTime)
    height = height + frame.rightButton:GetHeight() + MARGIN.WINDOW_SIDE * 2
    frame:SetHeight(height)
  end
  function frame:FillData(isNotBotReport, name, locationName)
    if isNotBotReport then
      reportMode = 1
      local text = locale.trial.crimeReportByDoodad(name)
      self.reportDesc:SetText(text)
    else
      reportMode = 2
      local text = locale.trial.botSuspectReport(name)
      self.reportDesc:SetText(text)
    end
    self.reportDesc:SetHeight(self.reportDesc:GetTextHeight())
    local location = locale.trial.crimeReportLocation(locationName)
    self.location:SetText(location)
    self.location:SetHeight(self.location:GetTextHeight())
    local curTime = X2Time:GetLocalTime()
    local nowDate = X2Time:TimeToDate(curTime)
    local nowDateString = locale.time.GetDateToDateFormat(nowDate, DATE_FORMAT_FILTER1)
    local reportTime = locale.trial.crimeReportTime(nowDateString)
    self.reportTime:SetText(reportTime)
    self.reportTime:SetHeight(self.reportTime:GetTextHeight())
    SetFrameHeight()
  end
  local OnHide = function()
    userTrial.reportCrimeWnd = nil
  end
  frame:SetHandler("OnHide", OnHide)
  return frame
end
local function ShowReportCrimeWindow(doodadName, locationName)
  if userTrial.reportCrimeWnd == nil then
    userTrial.reportCrimeWnd = CreateReportCrimeWindow("userTrial.reportCrimeWnd")
    userTrial.reportCrimeWnd:FillData(true, doodadName, locationName)
    userTrial.reportCrimeWnd:Show(true)
  else
    userTrial.reportCrimeWnd:FillData(true, doodadName, locationName)
    userTrial.reportCrimeWnd:Show(true)
  end
end
UIParent:SetEventHandler("REPORT_CRIME", ShowReportCrimeWindow)
local function ShowReportBotSuspectWindow(targetName, locationName)
  if userTrial.reportCrimeWnd == nil then
    userTrial.reportCrimeWnd = CreateReportCrimeWindow("userTrial.reportCrimeWnd")
    userTrial.reportCrimeWnd:FillData(false, targetName, locationName)
    userTrial.reportCrimeWnd:Show(true)
  else
    userTrial.reportCrimeWnd:FillData(false, targetName, locationName)
    userTrial.reportCrimeWnd:Show(true)
  end
end
UIParent:SetEventHandler("REPORT_BOT_SUSPECT", ShowReportBotSuspectWindow)
