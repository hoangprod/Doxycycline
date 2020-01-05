local CreateRulingStatusWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:Show(false)
  wnd:SetExtent(510, 320)
  wnd:SetTitle(locale.trial.rulingTitle)
  wnd:SetSounds("ruling_status")
  local identikitPicture = CreateIdentikitPicture("CreateIdentikitPicture", wnd)
  identikitPicture:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
  wnd.identikitPicture = identikitPicture
  local crimeListWindow = wnd:CreateChildWidget("window", "crimeListWindow", 0, true)
  crimeListWindow:Show(true)
  crimeListWindow:SetExtent(260, 55)
  crimeListWindow:SetTitleText(locale.trial.crimeRecordTitle)
  crimeListWindow.titleStyle:SetFont(FONT_PATH.DEFAULT, userTrialLocale.rulingStatusWnd.fontSize.crimeListWndTitle)
  crimeListWindow.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  ApplyTitleFontColor(crimeListWindow, FONT_COLOR.DEFAULT)
  crimeListWindow:AddAnchor("TOPRIGHT", wnd, -sideMargin, titleMargin)
  crimeListWindow.icon = {}
  local xOffset = userTrialLocale.rulingStatusWnd.crimeTypeIcon.offset
  local yOffset = -3
  local crimeTypeStr = {
    locale.trial.crimeTypeEtc,
    locale.trial.crimeTypeAssault,
    locale.trial.crimeTypeMurder,
    locale.trial.crimeTypeTheft
  }
  for i = 1, USER_TRIAL.MAX_CRIME_TYPE do
    local icon = CreateCrimeTypeIcon(crimeListWindow, i)
    icon:SetTypeIcon(i)
    icon:SetInset(userTrialLocale.rulingStatusWnd.crimeTypeIcon.inset, 0, 0, 0)
    icon:SetWidth(userTrialLocale.rulingStatusWnd.crimeTypeIcon.width)
    icon:AddAnchor("TOPLEFT", crimeListWindow, xOffset, yOffset)
    icon.texture:RemoveAllAnchors()
    icon.texture:AddAnchor("LEFT", icon, 0, 0)
    icon.tooltip = crimeTypeStr[i]
    xOffset = xOffset + userTrialLocale.rulingStatusWnd.crimeTypeIcon.offset
    if i == 2 then
      xOffset = userTrialLocale.rulingStatusWnd.crimeTypeIcon.offset
      yOffset = yOffset + 30
    end
    local OnEnter = function(self)
      SetTargetAnchorTooltip(self.tooltip, "TOPLEFT", self, "BOTTOMRIGHT", -15, -15)
    end
    icon:SetHandler("OnEnter", OnEnter)
    local OnLeave = function()
      HideTooltip()
    end
    icon:SetHandler("OnLeave", OnLeave)
    crimeListWindow.icon[i] = icon
  end
  function crimeListWindow:SetCrimeCount(etc, theft, assault, murder)
    local crimeType = {
      etc,
      assault,
      murder,
      theft
    }
    for i = 1, USER_TRIAL.MAX_CRIME_TYPE do
      local str = string.format("%s%s", crimeType[i], locale.trial.count)
      crimeListWindow.icon[i]:SetText(str)
    end
  end
  local judgmentWindow = wnd:CreateChildWidget("emptywidget", "judgmentWindow", 0, true)
  judgmentWindow:SetExtent(260, 140)
  judgmentWindow:AddAnchor("TOP", crimeListWindow, "BOTTOM", 0, sideMargin / 2)
  local bg = CreateContentBackground(judgmentWindow, "TYPE10", "brown")
  bg:AddAnchor("TOPLEFT", judgmentWindow, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", judgmentWindow, 0, 0)
  local rulingStatus = wnd:CreateChildWidget("label", "rulingStatus", 0, true)
  rulingStatus:SetAutoResize(true)
  rulingStatus:SetHeight(userTrialLocale.rulingStatusWnd.fontSize.notGuilty)
  rulingStatus.style:SetFont(userTrialLocale.rulingStatusWnd.statusFontPath, userTrialLocale.rulingStatusWnd.fontSize.notGuilty)
  rulingStatus:AddAnchor("CENTER", judgmentWindow, 5, 0)
  ApplyTextColor(rulingStatus, FONT_COLOR.DEFAULT)
  local rulingStatusTitle = wnd:CreateChildWidget("label", "rulingStatusTitle", 0, true)
  rulingStatusTitle:SetAutoResize(true)
  rulingStatusTitle:SetHeight(FONT_SIZE.LARGE)
  rulingStatusTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(rulingStatusTitle, FONT_COLOR.DEFAULT)
  local minuteLabel = wnd:CreateChildWidget("label", "minuteLabel", 0, true)
  minuteLabel:Show(false)
  minuteLabel:SetAutoResize(true)
  minuteLabel:SetHeight(FONT_SIZE.LARGE)
  minuteLabel.style:SetFontSize(FONT_SIZE.LARGE)
  minuteLabel:SetText(locale.tooltip.minute)
  minuteLabel:AddAnchor("BOTTOMLEFT", rulingStatus, "BOTTOMRIGHT", -2, -2)
  ApplyTextColor(minuteLabel, FONT_COLOR.RED)
  local okButton = wnd:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(TRIAL_TEXT, "ruling_ok"))
  okButton:AddAnchor("TOP", judgmentWindow, "BOTTOM", 0, sideMargin / 2)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function LeftClickFunc()
    wnd:Show(false)
  end
  ButtonOnClickHandler(okButton, LeftClickFunc)
  function wnd:FillData(count, total, sentenceType, sentenceTime)
    local crimeData = X2Trial:GetCrimeData()
    self.identikitPicture:FillInfo(crimeData.faction, crimeData.race, crimeData.defendant)
    self.crimeListWindow:SetCrimeCount(crimeData.etc, crimeData.theft, crimeData.assault, crimeData.murder)
    if count < total then
      self.rulingStatusTitle:SetText(locale.trial.rulingInProgress)
      self.rulingStatus:SetText(locale.trial.rulingStatus(count, total))
      self.rulingStatusTitle:RemoveAllAnchors()
      self.rulingStatusTitle:AddAnchor("TOP", self.rulingStatus, "BOTTOM", 0, 0)
    else
      self.rulingStatusTitle:SetText(locale.trial.rulingResult)
      self.rulingStatusTitle:RemoveAllAnchors()
      if sentenceType == 1 then
        local anchorInfo = userTrialLocale.rulingStatusWnd.statusTitleAnchor
        self.rulingStatusTitle:AddAnchor(anchorInfo.myPoint, wnd.rulingStatus, anchorInfo.targetPoint, anchorInfo.x, anchorInfo.y)
        self.rulingStatus:SetHeight(userTrialLocale.rulingStatusWnd.fontSize.notGuilty)
        self.rulingStatus.style:SetFontSize(userTrialLocale.rulingStatusWnd.fontSize.notGuilty)
        self.rulingStatus:SetText(locale.trial.rulingResultNotGuilty)
        ApplyTextColor(self.rulingStatus, FONT_COLOR.BLUE)
        self.minuteLabel:Show(false)
      else
        self.rulingStatusTitle:AddAnchor("TOPRIGHT", self.rulingStatus, "TOPLEFT", 0, 0)
        self.rulingStatus:SetHeight(userTrialLocale.rulingStatusWnd.fontSize.guilty)
        self.rulingStatus.style:SetFontSize(userTrialLocale.rulingStatusWnd.fontSize.guilty)
        self.rulingStatus:SetText(tostring(sentenceTime / 60000))
        ApplyTextColor(self.rulingStatus, FONT_COLOR.RED)
        self.minuteLabel:Show(true)
      end
    end
  end
  local events = {
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
local function ShowRulingStatusWindow(count, total, sentenceType, sentenceTime)
  if userTrial.rulingStatusWnd == nil then
    userTrial.rulingStatusWnd = CreateRulingStatusWindow("userTrial.rulingStatusWnd", "UIParent")
    userTrial.rulingStatusWnd:AddAnchor("CENTER", "UIParent", 0, 0)
  end
  userTrial.rulingStatusWnd:FillData(count, total, sentenceType, sentenceTime)
  userTrial.rulingStatusWnd:Show(true)
end
UIParent:SetEventHandler("RULING_STATUS", ShowRulingStatusWindow)
