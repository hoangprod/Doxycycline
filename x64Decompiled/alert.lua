local alert = {
  heroElection = nil,
  expeditionWar = nil,
  raidRecruit = nil,
  siege = nil,
  battleField = nil,
  zonePermission = nil
}
local alertManager = GetIndicators().alertManager
alertManager.alertWidgets = alert
local function CheckAlertAnchor()
  local offsetX = -5
  local offsetY = 0
  if alert.heroElection ~= nil then
    alert.heroElection:RemoveAllAnchors()
    alert.heroElection:AddAnchor("TOPRIGHT", alertManager, offsetX, offsetY)
    offsetX = -(alert.heroElection:GetWidth() + 5)
    offsetY = offsetY + 10
  end
  if alert.expeditionWar ~= nil then
    alert.expeditionWar:RemoveAllAnchors()
    alert.expeditionWar:AddAnchor("TOPRIGHT", alertManager, offsetX, offsetY)
    offsetX = offsetX - (alert.expeditionWar:GetWidth() + 5)
  end
  if alert.raidRecruit ~= nil then
    alert.raidRecruit:RemoveAllAnchors()
    alert.raidRecruit:AddAnchor("TOPRIGHT", alertManager, offsetX, offsetY)
    offsetX = offsetX - (alert.raidRecruit:GetWidth() + 5)
  end
  if alert.siege ~= nil then
    alert.siege:RemoveAllAnchors()
    alert.siege:AddAnchor("TOPRIGHT", alertManager, offsetX, offsetY)
    offsetX = offsetX - (alert.siege:GetWidth() + 5)
  end
  if alert.battleField ~= nil then
    alert.battleField:RemoveAllAnchors()
    alert.battleField:AddAnchor("TOPRIGHT", alertManager, offsetX, offsetY)
    offsetX = offsetX - (alert.battleField:GetWidth() + 5)
  end
  if alert.zonePermission ~= nil then
    alert.zonePermission:RemoveAllAnchors()
    alert.zonePermission:AddAnchor("TOPRIGHT", alertManager, offsetX, offsetY)
    offsetX = offsetX - (alert.zonePermission:GetWidth() + 5)
  end
  alertManager:AdjustHeight()
  RunIndicatorStackRule()
end
local function CreateBattleFieldEntranceAlarm(id, parent)
  local widget = UIParent:CreateWidget("button", id, parent)
  widget:EnableHidingIsRemove(true)
  ApplyButtonSkin(widget, BUTTON_CONTENTS.BATTLEFIELD_ALARM)
  local peopleCount = widget:CreateChildWidget("label", "peopleCount", 0, true)
  peopleCount:Show(false)
  peopleCount:SetAutoResize(true)
  peopleCount:SetHeight(FONT_SIZE.MIDDLE)
  peopleCount:SetText(GetUIText(COMMON_TEXT, "waiting"))
  peopleCount:AddAnchor("BOTTOM", widget, 0, 12)
  peopleCount.style:SetShadow(true)
  ApplyTextColor(peopleCount, FONT_COLOR.SOFT_YELLOW)
  local WidgetLeftClickFunc = function()
    X2BattleField:ToggleBattleField()
  end
  ButtonOnClickHandler(widget, WidgetLeftClickFunc)
  local function OnHideWidget()
    alert.battleField = nil
    CheckAlertAnchor()
  end
  widget:SetHandler("OnHide", OnHideWidget)
  function widget:FillParticipationInfo()
    peopleCount:Show(true)
  end
  local events = {
    UPDATE_INSTANT_GAME_STATE = function()
      widget:FillParticipationInfo()
    end,
    ENTERED_INSTANT_GAME_ZONE = function()
      widget:Show(false)
      if alert.raidRecruit ~= nil and X2BattleField:IsInInstantGame() then
        ShowRaidRecruitAlarm(false)
      end
    end
  }
  widget:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(widget, events)
  return widget
end
function ShowBattleFieldEntranceAlarm(isShow)
  if isShow and alert.battleField == nil then
    alert.battleField = CreateBattleFieldEntranceAlarm("battleField", alertManager)
    alert.battleField:FillParticipationInfo()
  end
  if alert.battleField ~= nil then
    alert.battleField:Show(isShow)
    if isShow then
      CheckAlertAnchor()
    end
  end
end
local function CreateRaidRecruitAlarm(id, parent)
  local widget = UIParent:CreateWidget("button", id, parent)
  widget:EnableHidingIsRemove(true)
  ApplyButtonSkin(widget, BUTTON_CONTENTS.RAID_RECRUIT_ALARM)
  widget.str = ""
  local WidgetLeftClickFunc = function()
    ToggleRaidRecruit(not RaidRecruit:IsVisible())
  end
  ButtonOnClickHandler(widget, WidgetLeftClickFunc)
  local function OnHideWidget()
    alert.raidRecruit = nil
    CheckAlertAnchor()
  end
  widget:SetHandler("OnHide", OnHideWidget)
  local function OnEnterWidget()
    SetTargetAnchorTooltip(widget.str, "TOPRIGHT", widget, "BOTTOMLEFT", 5, -15)
  end
  widget:SetHandler("OnEnter", OnEnterWidget)
  local OnLeaveWidget = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeaveWidget)
  local events = {
    RAID_RECRUIT_HUD = function(infos)
      local isAppend = false
      for i = 1, #infos do
        local info = infos[i]
        local strTime = locale.time.GetDateToDateFormat(info, FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE):match("^%s*(.-)%s*$")
        local strRecruitTitle = string.format("%s%s%s", FONT_COLOR_HEX.SOFT_YELLOW, GetCommonText("raid_recruit_tooltip"), FONT_COLOR_HEX.SOFT_BROWN)
        local strApplicantTitle = string.format("%s%s%s", FONT_COLOR_HEX.SOFT_YELLOW, GetCommonText("raid_applicant_tooltip"), FONT_COLOR_HEX.SOFT_BROWN)
        if info.isRecruiter == true then
          widget.str = string.format([[
%s
- [%s] %s %s]], strRecruitTitle, info.subTypeName, strTime, GetCommonText("raid_recruit_start_tooltip"))
          if #infos == 1 then
            widget.str = string.format([[
%s

%s
- %s]], widget.str, strApplicantTitle, GetUIText(TOOLTIP_TEXT, "nobody"))
          end
        elseif i == 1 then
          widget.str = string.format([[
%s
- %s]], strRecruitTitle, GetUIText(TOOLTIP_TEXT, "nobody"))
          widget.str = string.format([[
%s

%s
- [%s] %s]], widget.str, strApplicantTitle, info.subTypeName, strTime)
          isAppend = true
        elseif isAppend == false then
          widget.str = string.format([[
%s

%s
- [%s] %s]], widget.str, strApplicantTitle, info.subTypeName, strTime)
          isAppend = true
        else
          widget.str = string.format([[
%s
- [%s] %s]], widget.str, info.subTypeName, strTime)
        end
      end
    end
  }
  widget:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(widget, events)
  return widget
end
function ShowRaidRecruitAlarm(isShow)
  if isShow then
    if alert.raidRecruit == nil then
      alert.raidRecruit = CreateRaidRecruitAlarm("raidRecruit", alertManager)
    end
    alert.raidRecruit:Show(true)
    CheckAlertAnchor()
  elseif alert.raidRecruit ~= nil then
    alert.raidRecruit:Show(false)
  end
end
local function CreateSiegeAlarm(id, parent)
  local widget = UIParent:CreateWidget("button", id, parent)
  widget:EnableHidingIsRemove(true)
  ApplyButtonSkin(widget, BUTTON_CONTENTS.READY_TO_SIEGE_ALARM)
  local label = widget:CreateChildWidget("label", "periodLabel", 0, true)
  label:Show(true)
  label:SetAutoResize(true)
  label:SetHeight(FONT_SIZE.MIDDLE)
  label:AddAnchor("BOTTOM", widget, 0, 12)
  label.style:SetShadow(true)
  ApplyTextColor(label, FONT_COLOR.SOFT_YELLOW)
  widget.label = label
  widget.str = ""
  local WidgetLeftClickFunc = function()
    ShowSiegeScheduleTab()
  end
  ButtonOnClickHandler(widget, WidgetLeftClickFunc)
  local function OnHideWidget()
    alert.siege = nil
    CheckAlertAnchor()
  end
  widget:SetHandler("OnHide", OnHideWidget)
  local function OnEnterWidget()
    SetTargetAnchorTooltip(widget.str, "TOPRIGHT", widget, "BOTTOMLEFT", 5, -15)
  end
  widget:SetHandler("OnEnter", OnEnterWidget)
  local OnLeaveWidget = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeaveWidget)
  function widget:ChangeSiegeAlarmInfo(period)
    if period == "siege_period_ready_to_siege" then
      ApplyButtonSkin(widget, BUTTON_CONTENTS.READY_TO_SIEGE_ALARM)
      local text = GetUIText(TOOLTIP_TEXT, "ready_to_siege_alarm_tooltip")
      widget.str = text
      widget.label:SetText(text)
    elseif period == "siege_period_siege" then
      ApplyButtonSkin(widget, BUTTON_CONTENTS.SIEGE_WAR_ALARM)
      local text = GetUIText(TOOLTIP_TEXT, "siege_war_alarm_tooltip")
      widget.str = text
      widget.label:SetText(text)
    end
  end
  return widget
end
function ShowSiegeAlarm(isShow, period)
  if isShow then
    if alert.siege == nil then
      alert.siege = CreateSiegeAlarm("siegeAlert", alertManager)
    end
    alert.siege:ChangeSiegeAlarmInfo(period)
    alert.siege:Show(true)
    CheckAlertAnchor()
  elseif alert.siege ~= nil then
    alert.siege:Show(false)
  end
end
local function CreateZonePermissionAlert(id, parent)
  local widget = UIParent:CreateWidget("button", id, parent)
  widget:EnableHidingIsRemove(true)
  ApplyButtonSkin(widget, BUTTON_CONTENTS.ZONE_PERMISSION_WAIT)
  widget.peopleCount = widget:CreateChildWidget("label", "peopleCount", 0, true)
  local peopleCount = widget.peopleCount
  peopleCount:SetAutoResize(true)
  peopleCount:SetHeight(FONT_SIZE.MIDDLE)
  peopleCount:SetText(GetUIText(SERVER_TEXT, "paramCountOfPersons", "0"))
  peopleCount:AddAnchor("BOTTOM", widget, 0, 12)
  peopleCount.style:SetShadow(true)
  ApplyTextColor(peopleCount, FONT_COLOR.SOFT_YELLOW)
  local WidgetLeftClickFunc = function()
    X2Player:OpenZonePermissionWaitWindow()
  end
  ButtonOnClickHandler(widget, WidgetLeftClickFunc)
  local function OnHideWidget()
    alert.zonePermission = nil
    CheckAlertAnchor()
  end
  widget:SetHandler("OnHide", OnHideWidget)
  local function OnEnterWidget()
    local condition = X2Player:GetZonePermissionCondition()
    str = string.format("%s%s|r %s", FONT_COLOR_HEX.SKYBLUE, condition.waitName, GetUIText(COMMON_TEXT, "zp_waiting"))
    SetTargetAnchorTooltip(str, "TOPRIGHT", widget, "BOTTOMRIGHT", 0, 12)
  end
  widget:SetHandler("OnEnter", OnEnterWidget)
  local OnLeaveWidget = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeaveWidget)
  local delay = 500
  local function OnUpdate(self, dt)
    delay = delay + dt
    if delay > 500 then
      local condition = X2Player:GetZonePermissionCondition()
      if condition.permission == 0 then
        alert.zonePermission:Show(false)
      end
      delay = 0
    end
  end
  widget:SetHandler("OnUpdate", OnUpdate)
  return widget
end
local function ShowZonePermissionAlert()
  if alert.zonePermission == nil then
    alert.zonePermission = CreateZonePermissionAlert("zonePermission", alertManager)
  end
  if alert.zonePermission ~= nil then
    alert.zonePermission:Show(true)
    CheckAlertAnchor()
  end
end
local function UpdateZonePermission()
  local condition = X2Player:GetZonePermissionCondition()
  if (condition.permission == 1 or condition.permission == 4) and condition.inZone == false then
    ShowZonePermissionAlert()
    if condition.permission == 1 then
      alert.zonePermission.peopleCount:SetText(GetUIText(SERVER_TEXT, "paramCountOfPersons", tostring(condition.waitNum)))
    else
      alert.zonePermission.peopleCount:SetText(GetCommonText("reserve"))
    end
  elseif alert.zonePermission ~= nil then
    alert.zonePermission:Show(false)
  end
end
UIParent:SetEventHandler("UPDATE_ZONE_PERMISSION", UpdateZonePermission)
UIParent:SetEventHandler("LEFT_LOADING", UpdateZonePermission)
local function CreateHeroElectionAlert(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:Show(false)
  frame:EnableHidingIsRemove(true)
  local texture = frame:CreateDrawable(TEXTURE_PATH.HERO_ELECTION_ALERT, "icon_vote02", "background")
  texture:AddAnchor("CENTER", frame, 0, 0)
  local label = frame:CreateChildWidget("label", "label", 0, false)
  label:SetAutoResize(true)
  label:SetHeight(FONT_SIZE.MIDDLE)
  label:AddAnchor("BOTTOM", frame, 0, 11)
  label:SetText(GetUIText(COMMON_TEXT, "in_progress_election"))
  label.style:SetFontSize(FONT_SIZE.MIDDLE)
  label.style:SetShadow(true)
  ApplyTextColor(label, FONT_COLOR.SOFT_YELLOW)
  frame:SetExtent(texture:GetExtent())
  function frame:FillTooltip()
    local condition = X2Hero:GetVoterCondition()
    if condition == nil then
      if frame.tooltip ~= nil then
        frame.tooltip:Show(false)
        frame:ReleaseHandler("OnEnter")
      end
      return
    end
    local factionId = X2Hero:GetClientFactionID()
    local isMoribundNation = X2Nation:IsMoribundNation(factionId)
    if not isMoribundNation and X2Hero:IsVoter() then
      do
        local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
        local tooltip = UIParent:CreateWidget("gametooltip", "tooltip", "UIParent")
        tooltip:SetExtent(100, 50)
        tooltip.style:SetAlign(ALIGN_LEFT)
        DefaultTooltipSetting(tooltip)
        CreateTooltipDrawable(tooltip)
        frame.tooltip = tooltip
        local texture = tooltip:CreateDrawable(TEXTURE_PATH.HERO_ELECTION_ALERT, "icon_vote01", "artwork")
        texture:AddAnchor("TOPLEFT", tooltip, 8, 8)
        local function OnEnter(self)
          tooltip:ClearLines()
          tooltip:AddLine(GetUIText(COMMON_TEXT, "choiced_hero_election"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, texture:GetWidth() + 2)
          tooltip:AddLine(GetUIText(COMMON_TEXT, "hero_election_alert_common_tooltip", tostring(condition.level), tostring(condition.leadership_point)), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          SetDefaultTooltipAnchor(frame, tooltip)
          tooltip:Show(true)
        end
        self:SetHandler("OnEnter", OnEnter)
        local function OnLeave()
          tooltip:Show(false)
        end
        self:SetHandler("OnLeave", OnLeave)
      end
    else
      local function OnEnter(self)
        local info = X2Player:GetGamePoints()
        local point = info.periodLeadershipPointStr
        if point == nil then
          return
        end
        local str = ""
        if isMoribundNation then
          str = string.format([[
%s%s|r
%s]], FONT_COLOR_HEX.SOFT_YELLOW, GetUIText(COMMON_TEXT, "hero_not_enable_vote_by_in_moribund_nation"), GetUIText(COMMON_TEXT, "hero_election_alert_common_tooltip", tostring(condition.level), tostring(condition.leadership_point)))
        elseif X2Hero:IsAlreadyVoted() then
          str = string.format([[
%s%s|r
%s]], FONT_COLOR_HEX.SOFT_YELLOW, GetUIText(COMMON_TEXT, "hero_already_vote_noti"), GetUIText(COMMON_TEXT, "hero_election_alert_common_tooltip", tostring(condition.level), tostring(condition.leadership_point)))
        else
          str = string.format([[
%s
%s]], GetUIText(COMMON_TEXT, "not_choiced_hero_election", tostring(X2Unit:UnitLevel("player")), tostring(point)), GetUIText(COMMON_TEXT, "hero_election_alert_common_tooltip", tostring(condition.level), tostring(condition.leadership_point)))
        end
        SetTooltip(str, self)
      end
      self:SetHandler("OnEnter", OnEnter)
    end
  end
  local function OnHide()
    if alert.heroElection.tooltip ~= nil then
      alert.heroElection.tooltip = nil
    end
    alert.heroElection = nil
    CheckAlertAnchor()
  end
  frame:SetHandler("OnHide", OnHide)
  local events = {
    HERO_ELECTION_VOTED = function()
      frame:FillTooltip()
    end,
    UPDATE_HERO_ELECTION_CONDITION = function()
      frame:FillTooltip()
    end,
    END_HERO_ELECTION_PERIOD = function()
      frame:Show(false)
    end,
    NATION_INVITE = function()
      frame:FillTooltip()
    end,
    NATION_KICK = function()
      frame:FillTooltip()
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
local function ShowHeroElectionAlert()
  if alert.heroElection == nil then
    alert.heroElection = CreateHeroElectionAlert("heroElection", alertManager)
    alert.heroElection:FillTooltip()
  end
  if alert.heroElection ~= nil then
    alert.heroElection:Show(UIParent:GetPermission(UIC_HERO_ELECTION))
    CheckAlertAnchor()
  end
end
UIParent:SetEventHandler("START_HERO_ELECTION_PERIOD", ShowHeroElectionAlert)
local function UpdatePermission()
  if not UIParent:GetPermission(UIC_HERO_ELECTION) or not X2Hero:IsElectionPeriod() then
    if alert.heroElection ~= nil then
      alert.heroElection:Show(false)
    end
    return
  end
  ShowHeroElectionAlert()
end
UIParent:SetEventHandler("UI_PERMISSION_UPDATE", UpdatePermission)
local FormatRemainTime = function(msec)
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
  elseif msec >= 0 then
    timeStr = tostring(math.ceil(msec / 1000))
    key = "second"
  end
  return X2Locale:LocalizeUiText(TIME, key, timeStr)
end
local function CreateExpeditionWarAlarm(id, parent)
  local widget = UIParent:CreateWidget("button", id, parent)
  local light2 = widget:CreateEffectDrawable(TEXTURE_PATH.EXPEDITION_WAR_ALARM, "background")
  light2:SetCoords(0, 0, 175, 156)
  light2:SetExtent(175, 156)
  light2:AddAnchor("CENTER", widget, 0, 0)
  light2:SetEffectPriority(1, "alpha", 0.5, 0.5)
  light2:SetEffectInitialColor(1, 1, 1, 1, 0.4)
  light2:SetEffectFinalColor(1, 1, 1, 1, 0.53)
  light2:SetEffectRotate(1, 15, 0)
  light2:SetEffectScale(1, 1.1, 0.97, 1.1, 1.1)
  light2:SetEffectPriority(2, "alpha", 0.5, 0.5)
  light2:SetEffectInitialColor(2, 1, 1, 1, 0.53)
  light2:SetEffectFinalColor(2, 1, 1, 1, 0.4)
  light2:SetEffectRotate(2, 0, -15)
  light2:SetEffectScale(2, 1.1, 1.1, 1.1, 1.1)
  light2:SetEffectPriority(3, "alpha", 0.4, 0.4)
  light2:SetEffectInitialColor(3, 1, 1, 1, 0.4)
  light2:SetEffectFinalColor(3, 1, 1, 1, 0.4)
  light2:SetEffectRotate(3, -15, 15)
  light2:SetEffectScale(3, 1.1, 1.1, 1.1, 1.1)
  light2:SetEffectPriority(4, "alpha", 0.4, 0.4)
  light2:SetEffectInitialColor(4, 1, 1, 1, 0.4)
  light2:SetEffectFinalColor(4, 1, 1, 1, 0.53)
  light2:SetEffectRotate(4, 15, 0)
  light2:SetEffectScale(4, 1.1, 0.97, 1.1, 1.1)
  light2:SetEffectPriority(5, "alpha", 0.3, 0.3)
  light2:SetEffectInitialColor(5, 1, 1, 1, 0.53)
  light2:SetEffectFinalColor(5, 1, 1, 1, 0)
  light2:SetEffectRotate(5, 0, 0)
  light2:SetEffectScale(5, 0.97, 0.97, 1.1, 1.1)
  light2:SetRepeatCount(1)
  local light1 = widget:CreateEffectDrawable(TEXTURE_PATH.EXPEDITION_WAR_ALARM, "background")
  light1:SetCoords(0, 0, 175, 156)
  light1:SetExtent(175, 156)
  light1:AddAnchor("CENTER", widget, 0, 0)
  light1:SetEffectPriority(1, "alpha", 0.5, 0.5)
  light1:SetEffectInitialColor(1, 1, 1, 1, 0.3)
  light1:SetEffectFinalColor(1, 1, 1, 1, 0.13)
  light1:SetEffectRotate(1, 15, 0)
  light1:SetEffectScale(1, 1, 1, 1, 0.84)
  light1:SetEffectPriority(2, "alpha", 0.5, 0.5)
  light1:SetEffectInitialColor(2, 1, 1, 1, 0.13)
  light1:SetEffectFinalColor(2, 1, 1, 1, 0.3)
  light1:SetEffectRotate(2, 0, 15)
  light1:SetEffectScale(2, 1, 0.84, 1, 1)
  light1:SetEffectPriority(3, "alpha", 0.4, 0.4)
  light1:SetEffectInitialColor(3, 1, 1, 1, 0.3)
  light1:SetEffectFinalColor(3, 1, 1, 1, 0.3)
  light1:SetEffectRotate(3, 15, -15)
  light1:SetEffectScale(3, 1, 1, 1, 1)
  light1:SetEffectPriority(4, "alpha", 0.4, 0.4)
  light1:SetEffectInitialColor(4, 1, 1, 1, 0.3)
  light1:SetEffectFinalColor(4, 1, 1, 1, 0.13)
  light1:SetEffectRotate(4, -15, 0)
  light1:SetEffectScale(4, 1, 1, 0.84, 1)
  light1:SetEffectPriority(5, "alpha", 0.3, 0.3)
  light1:SetEffectInitialColor(5, 1, 1, 1, 0.13)
  light1:SetEffectFinalColor(5, 1, 1, 1, 0)
  light1:SetEffectRotate(5, 0, 0)
  light1:SetEffectScale(5, 0.84, 1, 0.84, 1)
  light1:SetRepeatCount(1)
  local whiteDrawable = widget:CreateEffectDrawable(TEXTURE_PATH.EXPEDITION_WAR_ALARM, "overlay")
  whiteDrawable:SetCoords(0, 156, 45, 45)
  whiteDrawable:SetExtent(45, 45)
  whiteDrawable:AddAnchor("CENTER", widget, 0, 0)
  whiteDrawable:SetEffectPriority(1, "alpha", 0.3, 0.3)
  whiteDrawable:SetEffectInitialColor(1, 1, 1, 1, 0)
  whiteDrawable:SetEffectFinalColor(1, 1, 1, 1, 1)
  whiteDrawable:SetEffectPriority(2, "alpha", 0.4, 0.4)
  whiteDrawable:SetEffectInitialColor(2, 1, 1, 1, 1)
  whiteDrawable:SetEffectFinalColor(2, 1, 1, 1, 0)
  whiteDrawable:SetRepeatCount(1)
  light2:SetVisible(false)
  light1:SetVisible(false)
  whiteDrawable:SetVisible(false)
  widget:EnableHidingIsRemove(true)
  ApplyButtonSkin(widget, BUTTON_CONTENTS.EXPEDITION_WAR_ALARM)
  local remainTime = widget:CreateChildWidget("label", "remainTime", 0, false)
  remainTime:SetAutoResize(true)
  remainTime:SetHeight(FONT_SIZE.MIDDLE)
  remainTime:AddAnchor("BOTTOM", widget, 0, 12)
  remainTime:SetText("")
  remainTime.style:SetShadow(true)
  ApplyTextColor(remainTime, FONT_COLOR.SOFT_YELLOW)
  widget:SetAlphaAnimation(0, 1, 0.3, 0.3)
  widget.remainTime = 0
  local WidgetLeftClickFunc = function()
    X2Faction:RequestExpeditionWarKillScore()
  end
  ButtonOnClickHandler(widget, WidgetLeftClickFunc)
  local function OnHideWidget()
    alert.expeditionWar = nil
    CheckAlertAnchor()
  end
  widget:SetHandler("OnHide", OnHideWidget)
  local function OnEnterWidget()
    str = GetCommonText("in_expedition_war")
    SetTargetAnchorTooltip(str, "TOPRIGHT", widget, "BOTTOMLEFT", 5, -15)
  end
  widget:SetHandler("OnEnter", OnEnterWidget)
  local OnLeaveWidget = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeaveWidget)
  function widget:StartEffect(isShow)
    if isShow then
      light2:SetVisible(true)
      light1:SetVisible(true)
      whiteDrawable:SetVisible(true)
      light2:SetStartEffect(true)
      light1:SetStartEffect(true)
      whiteDrawable:SetStartEffect(true)
      widget:SetStartAnimation(true, false)
    end
  end
  function widget:OnUpdateTime(dt)
    widget.remainTime = widget.remainTime - dt
    if widget.remainTime <= 0 then
      widget:SetRemainTime(0)
    end
    remainTime:SetText(FormatRemainTime(widget.remainTime))
  end
  function widget:SetRemainTime(rt)
    widget.remainTime = rt
    if widget.remainTime == 0 then
      if widget:HasHandler("OnUpdate") == true then
        widget:ReleaseHandler("OnUpdate")
      end
      remainTime:SetText(hudLocale.alterTexts.battleClose)
      widget:SetWaitTime(180000)
      return
    else
      if widget:HasHandler("OnUpdate") == true then
        widget:ReleaseHandler("OnUpdate")
      end
      widget:SetHandler("OnUpdate", widget.OnUpdateTime)
    end
    remainTime:SetText(FormatRemainTime(widget.remainTime))
  end
  function widget:OnUpdateWaitTime(dt)
    widget.waitTime = widget.waitTime - dt
    if widget.waitTime <= 0 then
      widget:SetWaitTime(0)
    end
  end
  function widget:SetWaitTime(rt)
    widget.waitTime = rt
    if widget.waitTime == 0 then
      if widget:HasHandler("OnUpdate") == true then
        widget:ReleaseHandler("OnUpdate")
      end
      CheckAlertAnchor()
      widget:Show(false)
    else
      if widget:HasHandler("OnUpdate") == true then
        widget:ReleaseHandler("OnUpdate")
      end
      widget:SetHandler("OnUpdate", widget.OnUpdateWaitTime)
    end
  end
  return widget
end
local function ShowExpeditionWarAlarm(isShow)
  if isShow and alert.expeditionWar == nil then
    alert.expeditionWar = CreateExpeditionWarAlarm("expeditionWar", alertManager)
  end
  if alert.expeditionWar ~= nil then
    alert.expeditionWar:Show(isShow)
  end
  if alert.expeditionWar ~= nil and isShow then
    alert.expeditionWar:StartEffect(isShow)
  end
  CheckAlertAnchor()
end
local function SetRemainTimeExpeditionWarAlarm(remainTime)
  if alert.expeditionWar == nil then
    return
  end
  if remainTime <= 0 then
    return
  end
  alert.expeditionWar:SetRemainTime(remainTime)
end
local function ExpeditionWarStateEvents(related, state)
  if related == false then
    return
  end
  if state == "start" or state == "ongoing" then
    ShowExpeditionWarAlarm(true)
    SetRemainTimeExpeditionWarAlarm(X2Faction:GetRemainTimeExpeditionWar() * 1000)
  else
    alert.expeditionWar:SetRemainTime(0)
  end
end
local function ExpeditionWarKillScoreEvent()
  SetRemainTimeExpeditionWarAlarm(X2Faction:GetRemainTimeExpeditionWar() * 1000)
end
UIParent:SetEventHandler("EXPEDITION_WAR_STATE", ExpeditionWarStateEvents)
UIParent:SetEventHandler("EXPEDITION_WAR_KILL_SCORE", ExpeditionWarKillScoreEvent)
local function LeftLoading()
  if not X2BattleField:IsInInstantGame() and X2BattleField:IsApplyInstance() then
    ShowBattleFieldEntranceAlarm(true)
  end
  if X2Hero:IsElectionPeriod() then
    ShowHeroElectionAlert()
  end
  UpdateZonePermission()
  X2Team:GetRaidRecruitHud()
end
UIParent:SetEventHandler("ENTERED_WORLD", LeftLoading)
UIParent:SetEventHandler("LEFT_LOADING", LeftLoading)
