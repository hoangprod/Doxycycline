local expedMgmt = {}
local VIEW = EXPEDITION_TAB_MENU_IDX
local reservedOpenTabIdx
function GetExpeditionTabWindow(enumVal)
  return expedMgmt.tab.window[GetExpeiditonTabIdx(enumVal)]
end
local function HideAllExpeditionWnd()
  local infoTabWnd = GetExpeditionTabWindow(VIEW.INFORMATION)
  infoTabWnd.interestWindow:Show(false)
  infoTabWnd.buffWindow:Show(false)
  infoTabWnd.guideWindow:Show(false)
  infoTabWnd.levelUpWindow:Show(false)
  infoTabWnd.historyWnd:Show(false)
  GetExpeditionTabWindow(VIEW.RECRUIT).HideWindow()
end
function CreateExpeditionFrame(id, wnd)
  CreateExpdMgmtTab(id, wnd)
  expedMgmt = wnd
  CreateInfomation("expedMgmt.infomation", wnd.tab.window[GetExpeiditonTabIdx(VIEW.INFORMATION)])
  CreateInfomationSub("expedMgmt.infomation", wnd.tab.window[GetExpeiditonTabIdx(VIEW.INFORMATION)])
  if GetExpeiditonTabIdx(VIEW.BARRACK) ~= nil then
    CreateWebBrowser("expedMgmt.webbrowser", wnd.tab.window[GetExpeiditonTabIdx(VIEW.BARRACK)])
  end
  CreateExpeditionTodayQuest("expedMgmt.todayQuest", wnd.tab.window[GetExpeiditonTabIdx(VIEW.QUEST)])
  CreateMemberList("expedMgmt.memberList", wnd.tab.window[GetExpeiditonTabIdx(VIEW.MEMBERS)])
  CreateRolePolicy("expedMgmt.rolePolicy", wnd.tab.window[GetExpeiditonTabIdx(VIEW.ROLE_POLICY)])
  CreateRecruit("expedMgmt.recruit", wnd.tab.window[GetExpeiditonTabIdx(VIEW.RECRUIT)])
  function expedMgmt:ChangeTab(idx)
    local tab = self.tab
    if idx == GetExpeiditonTabIdx(VIEW.INFORMATION) then
      tab.window[idx]:FillInfoData()
    elseif idx == GetExpeiditonTabIdx(VIEW.BARRACK) then
      if X2:IsWebEnable() and localeView.useWebContent then
        tab.window[idx].webBrowser:Show(true)
        tab.window[idx].webBrowser:RequestExpeditionBBS()
      end
    elseif tab.window[idx].RefreshTab ~= nil then
      tab.window[idx]:RefreshTab()
    end
    if idx ~= GetExpeiditonTabIdx(VIEW.MEMBERS) then
      tab.window[GetExpeiditonTabIdx(VIEW.MEMBERS)].HideWindow()
    end
    if idx == GetExpeiditonTabIdx(VIEW.RECRUIT) then
      tab.window[GetExpeiditonTabIdx(VIEW.RECRUIT)].ShowWindow()
    else
      tab.window[GetExpeiditonTabIdx(VIEW.RECRUIT)].HideWindow()
    end
    HideAllExpeditionWnd()
  end
  function expedMgmt.tab:OnTabChangedProc(selected)
    expedMgmt:ChangeTab(selected)
  end
  function wnd:OnShow()
    local hasExpedition = X2Faction:GetMyExpeditionId() ~= 0
    for i = 1, #expedMgmt.tab.window do
      expedMgmt.tab.unselectedButton[i]:Enable(hasExpedition)
    end
    local idx = GetExpeiditonTabIdx(VIEW.RECRUIT)
    if hasExpedition and X2Faction:IsExpedInfoLoaded() then
      if reservedOpenTabIdx then
        idx = reservedOpenTabIdx
      else
        idx = expedMgmt.tab:GetSelectedTab()
        while not EXPEDITION_TAB_MENU_TABLE[idx].enable do
          idx = idx + 1 > #expedMgmt.tab.window and 1 or idx + 1
        end
      end
    end
    expedMgmt:ChangeTab(idx)
    expedMgmt.tab:SelectTab(idx)
    reservedOpenTabIdx = nil
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  function wnd:OnHide()
    local tab = self.tab
    if X2:IsWebEnable() and localeView.useWebContent then
      local idx = GetExpeiditonTabIdx(VIEW.BARRACK)
      if idx ~= nil then
        tab.window[idx].webBrowser:Show(false)
      end
    end
    HideAllExpeditionWnd()
  end
  expedMgmt:SetHandler("OnHide", expedMgmt.OnHide)
  function expedMgmt:SetTabHandler()
    local tab = self.tab
    local SetWebBrowserHandler = function(webBrowser1, webBrowser2)
      local SetHandler = function(wb)
        wb:SetHandler("OnEnter", function()
          wb:SetFocus()
        end)
        wb:SetHandler("OnLeave", function()
          wb:ClearFocus()
        end)
        local events = {
          WEB_BROWSER_ESC_EVENT = function(browser)
            if browser == wb then
              ToggleExpedMgmtUI(false)
            end
          end
        }
        wb:SetHandler("OnEvent", function(this, event, ...)
          events[event](...)
        end)
        wb:RegisterEvent("WEB_BROWSER_ESC_EVENT")
      end
      if webBrowser1 ~= nil then
        SetHandler(webBrowser1)
      end
      if webBrowser2 ~= nil then
        SetHandler(webBrowser2)
      end
    end
    if GetExpeiditonTabIdx(VIEW.BARRACK) ~= nil then
      SetWebBrowserHandler(tab.window[GetExpeiditonTabIdx(VIEW.BARRACK)].webBrowser)
    end
  end
  expedMgmt:SetTabHandler()
  local events = {
    EXPEDITION_MANAGEMENT_POLICY_CHANGED = function()
      if X2Faction:GetMyExpeditionId() == 0 then
        return
      end
      local memberListTab = GetExpeditionTabWindow(VIEW.MEMBERS)
      local rolePolicyTab = GetExpeditionTabWindow(VIEW.ROLE_POLICY)
      if memberListTab:IsVisible() then
        memberListTab:OnChangePolicy()
      elseif rolePolicyTab:IsVisible() then
        rolePolicyTab:OnChangePolicy()
      end
    end,
    EXPEDITION_MANAGEMENT_UPDATED = function()
      if X2Faction:GetMyExpeditionId() == 0 then
        return
      end
      if expedMgmt:IsVisible() == false then
        return
      end
      if X2Player:GetFeatureSet().expeditionLevel == true then
        local infoTab = GetExpeditionTabWindow(VIEW.INFORMATION)
        if infoTab:IsVisible() == true then
          infoTab:FillInfoData()
          return
        end
      end
      local memberListTab = GetExpeditionTabWindow(VIEW.MEMBERS)
      if memberListTab:IsVisible() == false then
        return
      end
      memberListTab:RequestMemberInfo(nil, true)
    end,
    EXPEDITION_MANAGEMENT_MEMBERS_INFO = function(totalCount, startIndex, memberInfos)
      if X2Faction:GetMyExpeditionId() == 0 then
        return
      end
      local memberListTab = GetExpeditionTabWindow(VIEW.MEMBERS)
      memberListTab:FillMemberData(totalCount, startIndex + 1, memberInfos)
    end,
    EXPEDITION_MANAGEMENT_ROLE_CHANGED = function()
      if X2Faction:GetMyExpeditionId() == 0 then
        return
      end
      local memberListTab = expedMgmt.tab.window[VIEW.MEMBERS]
      local rolePolicyTab = expedMgmt.tab.window[VIEW.ROLE_POLICY]
      if memberListTab:IsVisible() then
        memberListTab:OnChangePolicy()
      elseif rolePolicyTab:IsVisible() then
        rolePolicyTab:OnChangePolicy()
      end
    end,
    EXPEDITION_MANAGEMENT_MEMBER_NAME_CHANGED = function()
      if X2Faction:GetMyExpeditionId() == 0 then
        return
      end
      local memberListTab = GetExpeditionTabWindow(VIEW.MEMBERS)
      if memberListTab:IsVisible() then
        memberListTab:RequestMemberInfo()
      end
    end
  }
  expedMgmt:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(expedMgmt, events)
  return wnd
end
DominionGuardTowerStateNoticeKey = {
  "siege_alert_guard_tower_1st_attack",
  "siege_alert_guard_tower_below_75",
  "siege_alert_guard_tower_below_50",
  "siege_alert_guard_tower_engravable",
  "siege_alert_engraving_started",
  "siege_alert_engraving_stopped",
  "siege_alert_engraving_succeeded"
}
function ToggleExpedMgmtUI(show)
  ToggleCommunityWindow(show, COMMUNITY.EXPEDITION)
end
ADDON:RegisterContentTriggerFunc(UIC_EXPEDITION, ToggleExpedMgmtUI)
function ShowExpedMgmtUI_SiegeScheduleTab(zoneGroupType)
  local wnd = GetExpeditionTabWindow(EXPEDITION_TAB_MENU_IDX.SIEGE)
  for k = 1, #wnd.schedules do
    if wnd.schedules[k].zoneGroupType == zoneGroupType then
      wnd.curPageIndex = k
      wnd:FillSiegeInfos(wnd.curPageIndex)
      wnd.pageControl:SetCurrentPage(wnd.curPageIndex, true)
    end
  end
  reservedOpenTabIdx = GetExpeiditonTabIdx(EXPEDITION_TAB_MENU_IDX.SIEGE)
  ToggleCommunityWindow(true, COMMUNITY.EXPEDITION)
end
function ToggleExpeditionAssignmentWithQuest(qType)
  local featureSet = X2Player:GetFeatureSet()
  if not featureSet.expeditionLevel then
    return
  end
  local qInfo = X2Quest:GetTodayQuestInfo(qType)
  if qInfo == nil then
    return
  end
  reservedOpenTabIdx = GetExpeiditonTabIdx(EXPEDITION_TAB_MENU_IDX.QUEST)
  ToggleCommunityWindow(true, COMMUNITY.EXPEDITION)
  expedMgmt:ChangeTab(EXPEDITION_TAB_MENU_IDX.QUEST)
  local questWindow = GetExpeditionTabWindow(EXPEDITION_TAB_MENU_IDX.QUEST)
  questWindow:ToggleWithQuest(qType)
end
