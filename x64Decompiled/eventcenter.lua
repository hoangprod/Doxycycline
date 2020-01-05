local EVENT_CENTER_WINDOW_WIDTH = 900
local EVENT_CENTER_WINDOW_HEIGHT = 595
local sideMargin, titleMargin, _ = GetWindowMargin()
local bottomMargin = -30
local featureSet = X2Player:GetFeatureSet()
local eventCenterTabInfo = {
  {
    validationCheckFunc = function()
      return featureSet.accountAttendance
    end,
    title = GetCommonText("attendance"),
    subWindowConstructor = function(parent)
      CreateAttendanceWnd(parent)
    end
  },
  {
    validationCheckFunc = function()
      return featureSet.todayAssignment and featureSet.eventCenterTodayAssignment
    end,
    title = GetCommonText("today_assignment"),
    subWindowConstructor = function(parent)
      CreateATodayWnd(parent)
    end
  },
  {
    validationCheckFunc = function()
      return featureSet.archePass
    end,
    title = GetCommonText("arche_pass"),
    subWindowConstructor = function(parent)
      CreateArchePassWnd(parent)
    end
  },
  {
    validationCheckFunc = function()
      return true
    end,
    title = GetCommonText("event_info"),
    subWindowConstructor = function(parent)
      CreateEventInfoWnd(parent)
    end
  },
  {
    validationCheckFunc = function()
      return featureSet.eventCenterContentSchedule
    end,
    title = GetCommonText("event_center_content_schedule"),
    subWindowConstructor = function(parent)
      CreateScheduleWindow(parent)
    end
  }
}
function CreateEventCenterWnd(id, parent, tabInfo)
  local wnd = CreateWindow(id, parent, "", tabInfo)
  wnd:SetTitle(GetCommonText("event_center"))
  wnd:SetExtent(EVENT_CENTER_WINDOW_WIDTH, EVENT_CENTER_WINDOW_HEIGHT)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:Show(false)
  wnd:SetSounds("achievement")
  local tab = wnd.tab
  local maxWidth = tab:GetTabButtonMaxWidth()
  for i = 1, #wnd.tab.window do
    if wnd.tab.window[i].isAttendanceWnd or wnd.tab.window[i].isTodayAssignmentWnd or wnd.tab.window[i].isEventInfoWnd or wnd.tab.window[i].isArchePassWnd then
      local icon = wnd.tab:CreateDrawable(TEXTURE_PATH.HUD, "everyday_n_small", "overlay")
      icon:AddAnchor("TOPLEFT", tab, (i - 1) * maxWidth, -3)
      icon:SetVisible(false)
      wnd.tab.window[i].alarmIcon = icon
    end
  end
  X2EventCenter:RequestGameEventInfo()
  function tab:OnTabChangedProc(idx)
    if wnd.tab.window[idx].isTodayAssignmentWnd or wnd.tab.window[idx].isArchePassWnd then
      wnd.tab.window[idx]:Update()
    elseif wnd.tab.window[idx].isEventInfoWnd then
      if X2EventCenter:GetGameEventInfoCount() > 0 then
        UI:SetCharacterTodayPlayedTimeStamp()
        local icon = wnd.tab.window[idx].alarmIcon
        if icon ~= nil then
          icon:SetVisible(false)
        end
      end
      if UpdateEventCenterToggleButton ~= nil then
        UpdateEventCenterToggleButton()
      end
    end
  end
  function wnd:ToggleTodayAssignment(qType)
    for i = 1, #wnd.tab.window do
      if wnd.tab.window[i].isTodayAssignmentWnd then
        wnd.tab:SelectTab(i)
        wnd.tab.window[i]:ToggleWithQuest(qType)
      end
    end
  end
  function wnd:ToggleArchePass(qType)
    for i = 1, #wnd.tab.window do
      if wnd.tab.window[i].isArchePassWnd then
        wnd.tab:SelectTab(i)
        wnd.tab.window[i]:ToggleWithQuest(qType)
      end
    end
  end
  function wnd:SetAlarmIcons()
    if not self:IsVisible() then
      return
    end
    for i = 1, #wnd.tab.window do
      local icon = wnd.tab.window[i].alarmIcon
      if icon ~= nil then
        if wnd.tab.window[i].isAttendanceWnd then
          icon:SetVisible(AttendanceActived())
        end
        if wnd.tab.window[i].isTodayAssignmentWnd then
          icon:SetVisible(TodayAssignmentActived())
        end
        if wnd.tab.window[i].isArchePassWnd then
          icon:SetVisible(ArchePassActived())
        end
        if wnd.tab.window[i].isEventInfoWnd then
          if ShowEventInfoNewIcon() then
            icon:SetVisible(true)
          else
            icon:SetVisible(false)
          end
        end
      end
    end
  end
  local eventCenterEvents = {
    ACCOUNT_ATTENDANCE_LOADED = function()
      wnd:SetAlarmIcons()
    end,
    ACCOUNT_ATTENDANCE_ADDED = function()
      wnd:SetAlarmIcons()
    end,
    QUEST_CONTEXT_UPDATED = function(qType, status)
      if X2Quest:IsTodayQuest(qType) and status == "updated" then
        wnd:SetAlarmIcons()
      end
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      wnd:SetAlarmIcons()
    end,
    UPDATE_TODAY_ASSIGNMENT = function()
      wnd:SetAlarmIcons()
    end,
    START_TODAY_ASSIGNMENT = function()
      wnd:SetAlarmIcons()
    end,
    GAME_EVENT_INFO_LIST_UPDATED = function()
      wnd:SetAlarmIcons()
    end,
    ADDED_ITEM = function()
      wnd:SetAlarmIcons()
    end,
    REMOVED_ITEM = function()
      wnd:SetAlarmIcons()
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    eventCenterEvents[event](...)
  end)
  RegistUIEvent(wnd, eventCenterEvents)
  return wnd
end
local eventCenterWnd
function ToggleEventCenter(show)
  if eventCenterWnd == nil then
    eventCenterWnd = CreateEventCenterWnd("eventCenterWnd", "UIParent", eventCenterTabInfo)
  end
  local isShow = show
  if isShow == nil then
    isShow = not eventCenterWnd:IsVisible()
  end
  eventCenterWnd:Show(isShow)
  eventCenterWnd:SetAlarmIcons()
end
ADDON:RegisterContentTriggerFunc(UIC_EVENT_CENTER, ToggleEventCenter)
function ToggleAssignmentWithQuest(qType)
  if not featureSet.todayAssignment then
    return
  end
  local qInfo = X2Quest:GetTodayQuestInfo(qType)
  if qInfo == nil then
    return
  end
  ToggleEventCenter(true)
  eventCenterWnd:ToggleTodayAssignment(qType)
end
function ToggleArchePassWithQuest(qType)
  if not featureSet.archePass then
    return
  end
  ToggleEventCenter(true)
  if qType == nil then
    return
  end
  local qInfo = X2Quest:GetTodayQuestInfo(qType)
  if qInfo == nil then
    return
  end
  eventCenterWnd:ToggleArchePass(qType)
end
function CheckPopupEventCenterOnceADay()
  local timeStampKey = "popup_event_center_once_a_day"
  local stamp = UI:GetCurrentTimeStamp()
  local savedStamp = UI:GetAccountUITimeStamp(timeStampKey)
  local permission = UIParent:GetPermission(UIC_EVENT_CENTER)
  if permission and stamp ~= savedStamp and featureSet.accountAttendance then
    ToggleEventCenter(true)
    UI:SetAccountUITimeStamp(timeStampKey)
  end
end
function RaiseEventCenter()
  if eventCenterWnd == nil then
    return
  end
  if not eventCenterWnd:IsVisible() then
    return
  end
  eventCenterWnd:Raise()
end
if eventcenterLocale.attendancePopup then
  CheckPopupEventCenterOnceADay()
end
