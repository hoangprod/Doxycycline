local FormatRemainTime = function(msec)
  if msec <= 0 then
    return ""
  end
  local timeStr = ""
  local key = ""
  if not (msec >= 0) or not msec then
    msec = 0
  end
  if msec >= 3600000 then
    timeStr = tostring(math.ceil(msec / 3600000))
    key = "hour"
  elseif msec >= 60000 then
    timeStr = tostring(math.ceil(msec / 60000))
    key = "minute"
  elseif msec > 0 then
    timeStr = tostring(math.ceil(msec / 1000))
    key = "second"
  end
  return X2Locale:LocalizeUiText(TIME, key, timeStr)
end
function CreateInfomation(id, wnd)
  SetViewOfExpeditionInfomation(id, wnd)
  local frame = wnd.frame
  local midWin = wnd.midWin
  function frame.expBar:SettingExpTooltip(widget)
    function widget:OnEnter()
      local exped = X2Faction:GetMyExpeditionInfo()
      if exped ~= nil then
        local cur = exped[4]
        local total = exped[5]
        local today = exped[7]
        local todayMax = exped[8]
        local tooltip = string.format("%s %d/%d", GetUIText(COMMON_TEXT, "current_exp"), cur, total)
        if todayMax > 0 then
          tooltip = tooltip .. "\r\n" .. string.format(GetUIText(COMMON_TEXT, "expedition_my_exp_tooltip_today"), today, todayMax)
          if today == todayMax then
            tooltip = tooltip .. "\r\n" .. FONT_COLOR_HEX.RED .. GetUIText(COMMON_TEXT, "expedition_my_exp_tooltip_warning")
          end
        end
        SetExpTooltip(tooltip, widget)
      end
    end
    widget:SetHandler("OnEnter", widget.OnEnter)
    function widget:OnLeave()
      HideTooltip()
    end
    widget:SetHandler("OnLeave", widget.OnLeave)
  end
  frame.expBar:SettingExpTooltip(frame.expBar.dailyBar)
  frame.expBar:SettingExpTooltip(frame.expBar.statusBar)
  local IR = GetInterestList()
  for i = 1, #IR do
    do
      local icon = frame.interestIcon[i]
      local function SettingInterestTooltip(widget)
        function widget:OnEnter()
          SetTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_interest_" .. IR[i]), widget)
        end
        widget:SetHandler("OnEnter", widget.OnEnter)
        function widget:OnLeave()
          HideTooltip()
        end
        widget:SetHandler("OnLeave", widget.OnLeave)
      end
      SettingInterestTooltip(icon)
    end
  end
  local tooltipOnLeave = function()
    HideTooltip()
  end
  local contributionLabelEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "expedition_my_contribution_tooltip"), self, true)
  end
  midWin.contributionLabel:SetHandler("OnEnter", contributionLabelEnter)
  midWin.contributionLabel:SetHandler("OnLeave", tooltipOnLeave)
  local memberCountLabelEnter = function(self)
    SetTargetAnchorTooltip(GetUIText(COMMON_TEXT, "expedition_my_members_tooltip"), "BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)
  end
  midWin.memberCountLabel:SetHandler("OnEnter", memberCountLabelEnter)
  midWin.memberCountLabel:SetHandler("OnLeave", tooltipOnLeave)
  local immigrationIconEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "immigration_expediton_tooltip", tostring(X2Nation:NationImmigrateLevelMin())), self)
  end
  midWin.immigrationIcon:SetHandler("OnEnter", immigrationIconEnter)
  midWin.immigrationIcon:SetHandler("OnLeave", tooltipOnLeave)
  local expedMgrWnd = wnd:GetParent():GetParent()
  local historyWnd = CreateExpeditionWarHistory("historyWnd", expedMgrWnd)
  function historyWnd.okButton:OnClick()
    historyWnd:Show(not historyWnd:IsVisible())
  end
  historyWnd.okButton:SetHandler("OnClick", historyWnd.okButton.OnClick)
  wnd.historyWnd = historyWnd
  local function SetExpeditionWarState()
    local expdWarState = X2Faction:GetExpeditionWarState()
    if expdWarState == "possible_war" then
      frame.battleCond:SetTextureInfo("combat_possible")
    elseif expdWarState == "war" then
      frame.battleCond:SetTextureInfo("combat")
    else
      frame.battleCond:SetTextureInfo("protection")
    end
  end
  frame.remainTime = 0
  local function UpdateRemainTime(time)
    frame.battleRemain:SetText(FormatRemainTime(time))
  end
  function frame.battleRemain:OnUpdateTime(dt)
    frame.remainTime = frame.remainTime - dt
    if frame.remainTime <= 0 then
      UpdateRemainTime(0)
      if self:HasHandler("OnUpdate") == true then
        self:ReleaseHandler("OnUpdate")
      end
      SetExpeditionWarState()
    else
      UpdateRemainTime(frame.remainTime)
    end
  end
  local function FillRemainTime()
    frame.remainTime = X2Faction:GetMyExpeditionProtectionTime() * 1000
    local protectButtonShow = false
    if frame.remainTime == 0 then
      UpdateRemainTime(0)
      if frame.battleRemain:HasHandler("OnUpdate") == true then
        frame.battleRemain:ReleaseHandler("OnUpdate")
      end
    else
      if frame.battleRemain:HasHandler("OnUpdate") == false then
        frame.battleRemain:SetHandler("OnUpdate", frame.battleRemain.OnUpdateTime)
      end
      if X2Faction:IsMyRoleExpeditionOwner() == true then
        protectButtonShow = true
      end
    end
    if frame.disableProtectButton:IsVisible() ~= protectButtonShow then
      frame.disableProtectButton:Show(protectButtonShow)
    end
    SetExpeditionWarState()
  end
  local function FillExpeditionRecord()
    local win, lose, draw = X2Faction:GetExpeditionRecord()
    local str = string.format("%s: %s/%s/%s", GetUIText(COMMON_TEXT, "expedition_my_battle_score"), baselibLocale:ChangeSequenceOfWord("%s %s", win, GetUIText(COMMON_TEXT, "expedition_war_result_win")), baselibLocale:ChangeSequenceOfWord("%s %s", lose, GetUIText(COMMON_TEXT, "expedition_war_result_defeat")), baselibLocale:ChangeSequenceOfWord("%s %s", draw, GetUIText(COMMON_TEXT, "expedition_war_result_draw")))
    frame.battleLabel:SetText(str)
  end
  function wnd:FillInfoData()
    if X2Faction:IsMyRoleExpeditionOwner() == true then
      frame.upgradeButton:Show(true)
      frame.upgradeButton.waiting = false
      frame.writeButton:Show(true)
      wnd.midWin.controlButton:Show(true)
    else
      frame.upgradeButton:Show(false)
      frame.writeButton:Show(false)
      wnd.midWin.controlButton:Show(false)
    end
    frame.nameLabel:SetText(X2Faction:GetFactionName(X2Faction:GetMyExpeditionId(), false))
    local level = X2Faction:GetMyExpeditionLevel()
    frame.level:SetText(GetUIText(COMMON_TEXT, "level") .. " " .. tostring(level))
    local exped = X2Faction:GetMyExpeditionInfo()
    if exped ~= nil then
      if exped[1] ~= nil then
        self.frame.interest = exped[1]
        wnd:ShowInterest()
      end
      if exped[2] ~= nil then
        wnd.motdTitle:SetText(exped[2])
      else
        wnd.motdTitle:SetText("")
      end
      if exped[3] ~= nil then
        wnd.motdContent:SetText(exped[3])
      else
        wnd.motdContent:SetText("")
      end
      local cur = exped[4]
      local total = exped[5]
      local daily = exped[6]
      if cur ~= nil and total ~= nil then
        local value = cur * 1000 / total
        if value ~= nil then
          frame.expBar.statusBar:SetValue(value or 0)
        end
        local dailyvalue = daily * 1000 / total
        if dailyvalue ~= nil then
          frame.expBar.dailyBar:SetValue(dailyvalue or 0)
        end
        if dailyvalue == value and value ~= 0 then
          local width = frame.expBar.dailyBar:GetWidth() * dailyvalue / 1000 - 10
          frame.expBar.barEnd:RemoveAllAnchors()
          frame.expBar.barEnd:AddAnchor("LEFT", frame.expBar.dailyBar, width, 0)
          frame.expBar.barEnd:Show(true)
        else
          frame.expBar.barEnd:Show(false)
        end
        if cur >= total then
          frame.upgradeButton:Enable(true)
        else
          frame.upgradeButton:Enable(false)
        end
      end
      local online, total = X2Faction:GetExpeditionMemberCount()
      local levelInfo = X2Faction:GetExpeditionLevelInfo(level)
      if levelInfo ~= nil then
        wnd.midWin.memberCountLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_members") .. ": " .. FONT_COLOR_HEX.BLUE .. tostring(total) .. "|r / " .. tostring(levelInfo[3]))
      else
        wnd.midWin.memberCountLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_members") .. ": " .. FONT_COLOR_HEX.BLUE .. tostring(total))
      end
    end
    frame.bossLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_boss") .. ": " .. X2Faction:GetMyExpeditionOwnerName())
    frame.factionLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_faction") .. ": " .. X2Faction:GetFactionName(X2Faction:GetMyTopLevelFactionFromExpedition(), false))
    local info = X2Player:GetGamePoints()
    local point = info.contributionPointStr
    if point ~= nil then
      local label = wnd.midWin.contributionLabel
      label:SetWidth(250)
      label:SetText(GetUIText(COMMON_TEXT, "expedition_my_contribution") .. ": " .. FONT_COLOR_HEX.BLUE .. string.format("|w%s", point))
      local width = label:GetLongestLineWidth() + 15
      label:SetWidth(width)
    end
    frame.immigrationImage:Show(false)
    frame.immigrationLabel:SetText("")
    local immigrationInfo = X2Nation:GetExpeditionImmigrationInfo()
    if immigrationInfo.immigration == true then
      frame.immigrationImage:Show(true)
      frame.immigrationLabel:SetText(immigrationInfo.nationName)
    end
    FillRemainTime()
    FillExpeditionRecord()
  end
  function wnd:SetViewOffInfomationHandler()
    local frame = self.frame
    function self.midWin.effectInfoButton:OnClick()
      wnd.buffWindow:Show(not wnd.buffWindow:IsVisible())
    end
    self.midWin.effectInfoButton:SetHandler("OnClick", self.midWin.effectInfoButton.OnClick)
    function self.midWin.guideButton:OnClick()
      wnd.guideWindow:Show(not wnd.guideWindow:IsVisible())
    end
    self.midWin.guideButton:SetHandler("OnClick", self.midWin.guideButton.OnClick)
    function self.midWin.shopButton:OnClick()
      DirectOpenStore(3)
    end
    self.midWin.shopButton:SetHandler("OnClick", self.midWin.shopButton.OnClick)
    function self.midWin.controlButton:OnClick()
      local interestWindow = wnd.interestWindow
      if interestWindow:IsVisible() then
        interestWindow:Show(false)
      else
        interestWindow:Show(true)
        if frame.interest ~= nil then
          interestWindow:SetInterest(frame.interest)
        end
      end
    end
    self.midWin.controlButton:SetHandler("OnClick", self.midWin.controlButton.OnClick)
    local IR = GetInterestList()
    function self:SetInterest(value)
      for i = 1, #IR do
      end
      X2Faction:SetMyExpeditionInterest(value)
    end
    function self:ShowInterest()
      local lastIcon
      for i = 1, #IR do
        local icon = frame.interestIcon[i]
        icon:Show(false)
        icon:RemoveAllAnchors()
        if frame.interest[i] == 1 then
          icon:Show(true)
          if lastIcon == nil then
            icon:AddAnchor("LEFT", frame.interestLabel, "RIGHT", 8, 0)
          else
            icon:AddAnchor("LEFT", lastIcon, "RIGHT", 0, 0)
          end
          lastIcon = icon
        end
      end
      frame.controlButton:RemoveAllAnchors()
      frame.interestBg:RemoveAllAnchors()
      frame.interestBg:AddAnchor("TOPLEFT", frame.interestLabel, "TOPRIGHT", -1, -9)
      if frame.controlButton:IsVisible() then
        frame.interestBg:Show(true)
        frame.interestBg:AddAnchor("BOTTOMRIGHT", frame.controlButton, 11, 7)
      elseif lastIcon == nil then
        frame.interestBg:Show(false)
      else
        frame.interestBg:Show(true)
        frame.interestBg:AddAnchor("BOTTOMRIGHT", frame.controlButton, "BOTTOMLEFT", -4, 7)
      end
      if lastIcon == nil then
        lastIcon = frame.interestLabel
      end
      frame.controlButton:AddAnchor("LEFT", lastIcon, "RIGHT", 12, 0)
    end
    function frame.writeButton:OnClick()
      if frame.motdTitleLabel:IsVisible() then
        frame.motdTitleLabel:Show(false)
        frame.motdContentLabel:Show(false)
        wnd.motdTitle:SetReadOnly(true)
        wnd.motdTitle:Enable(false)
        wnd.motdTitle.bg:Show(false)
        wnd.motdContent:SetReadOnly(true)
        wnd.motdContent:Enable(false)
        wnd.motdContent.bg:Show(false)
        X2Faction:SetExpeditionMotd(wnd.motdTitle:GetText(), wnd.motdContent:GetText())
        wnd.motdTitle:SetText("")
        wnd.motdContent:SetText("")
        self.time = 0
        self.waiting = true
        self:Enable(false)
        function self:OnUpdate(dt)
          self.time = self.time + dt
          local TIME_OUT = 2000
          if not self.waiting or TIME_OUT < self.time then
            self.time = 0
            self.waiting = false
            self:Enable(true)
            self:ReleaseHandler("OnUpdate")
          end
        end
        self:SetHandler("OnUpdate", self.OnUpdate)
      else
        frame.motdTitleLabel:Show(true)
        frame.motdContentLabel:Show(true)
        wnd.motdTitle:SetReadOnly(false)
        wnd.motdTitle:Enable(true)
        wnd.motdTitle.bg:Show(true)
        wnd.motdTitle:OnTextChanged()
        wnd.motdTitle:SetInset(8, 8, 16, 8)
        wnd.motdContent:SetReadOnly(false)
        wnd.motdContent:Enable(true)
        wnd.motdContent.bg:Show(true)
        wnd.motdContent:OnTextChanged()
        wnd.motdContent:SetInset(8, 8, 16, 8)
      end
    end
    frame.writeButton.waiting = false
    frame.writeButton:SetHandler("OnClick", frame.writeButton.OnClick)
    function wnd.motdTitle:OnTextChanged()
      local len = self:GetTextLength()
      local color
      if len >= self.textLength then
        color = FONT_COLOR_HEX.DEFAULT
      else
        color = FONT_COLOR_HEX.SOFT_BROWN
      end
      local str = string.format("%s%s|r/%s", color, len, self.textLength)
      frame.motdTitleLabel:SetText(str)
    end
    wnd.motdTitle:SetHandler("OnTextChanged", wnd.motdTitle.OnTextChanged)
    function wnd.motdContent:OnTextChanged()
      local len = self:GetTextLength()
      local color
      if len >= self.textLength then
        color = FONT_COLOR_HEX.DEFAULT
      else
        color = FONT_COLOR_HEX.SOFT_BROWN
      end
      local str = string.format("%s%s|r/%s", color, len, self.textLength)
      frame.motdContentLabel:SetText(str)
    end
    wnd.motdContent:SetHandler("OnTextChanged", wnd.motdContent.OnTextChanged)
    function frame.upgradeButton:OnClick()
      wnd.levelUpWindow:Show(true)
      wnd.levelUpWindow:LevelApply()
      self.time = 0
      self.waiting = true
      self:Enable(false)
      function self:OnUpdate(dt)
        self.time = self.time + dt
        local TIME_OUT = 2000
        if TIME_OUT > self.time then
          return
        end
        if self.waiting then
          self.waiting = false
          self:Enable(true)
        end
        self.time = 0
        self:ReleaseHandler("OnUpdate")
      end
      self:SetHandler("OnUpdate", self.OnUpdate)
    end
    frame.upgradeButton.waiting = false
    frame.upgradeButton:SetHandler("OnClick", frame.upgradeButton.OnClick)
    function frame.disableProtectButton:OnClick()
      ShowCancelProtectionDialog()
    end
    frame.disableProtectButton:SetHandler("OnClick", frame.disableProtectButton.OnClick)
    function frame.battleHistoryButton:OnClick()
      if not historyWnd:IsVisible() then
        X2Faction:RequestExpeditionWarHistory()
        historyWnd:Raise()
      else
        historyWnd:Show(false)
      end
    end
    frame.battleHistoryButton:SetHandler("OnClick", frame.battleHistoryButton.OnClick)
    function frame:TryRenew()
      if not self.waiting then
        X2Faction:CheckExpeditionExpNextDay()
        self.time = 0
        self.waiting = true
        self:Enable(false)
        self:SetHandler("OnUpdate", self.OnUpdate)
      end
    end
    function frame:OnUpdate(dt)
      self.time = self.time + dt
      local TIME_OUT = 5000
      if not self.waiting then
        self.time = 0
        self:ReleaseHandler("OnUpdate")
      end
      if TIME_OUT < self.time then
        self.time = 0
        self.waiting = false
        self:Enable(true)
        self:ReleaseHandler("OnUpdate")
      end
    end
    frame.waiting = false
  end
  wnd:SetViewOffInfomationHandler()
  local function OnExpeditionWarSetProtectDate()
    FillRemainTime()
  end
  UIParent:SetEventHandler("EXPEDITION_WAR_SET_PROTECT_DATE", OnExpeditionWarSetProtectDate)
  local events = {
    EXPEDITION_WAR_HISTORY = function()
      local historyData = X2Faction:GetExpeditionWarHistory()
      historyWnd:FillResult(historyData)
      historyWnd:Show(true)
    end
  }
  historyWnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(historyWnd, events)
end
