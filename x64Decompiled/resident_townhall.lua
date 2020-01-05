residentTownhall = {}
residentTownhall = CreateWindow("residentTownhall", "UIParent")
residentTownhall:Show(false)
residentTownhall:AddAnchor("CENTER", "UIParent", 0, 0)
residentTownhall:SetExtent(800, 470)
residentTownhall:SetTitle(GetUIText(COMMON_TEXT, "resident_townhall_title"))
residentTownhall:ApplyUIScale(false)
function residentTownhall:CreateWebBrowser(id, wnd)
  local webBrowser = UIParent:CreateWidget("webbrowser", id, wnd)
  webBrowser:AddAnchor("TOP", wnd, 0, 5)
  webBrowser:SetExtent(792, 385)
  webBrowser:SetEscEvent(true)
  wnd.webBrowser = webBrowser
end
function residentTownhall:CreateTab(id, parent)
  local tab = W_BTN.CreateTab("tab", parent)
  tab:AddAnchor("TOPLEFT", parent, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  tab:AddAnchor("BOTTOMRIGHT", parent, -MARGIN.WINDOW_SIDE, 0)
  tab:SetCorner("TOPLEFT")
  local tabTexts = {}
  for i = 1, #RESIDENT_TAB_VIEW do
    table.insert(tabTexts, RESIDENT_TAB_VIEW[i].text)
  end
  tab:AddTabs(tabTexts)
  parent.tab = tab
end
residentTownhall.currMemberIndex = -1
residentTownhall:CreateTab("residentTownhall", residentTownhall)
CreateResidentMemberList("residentTownhall.memberList", residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.MEMBERS)])
if RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN) ~= nil then
  residentTownhall:CreateWebBrowser("residentTownhall.webbrowser", residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN)])
end
CreateResidentInfomation("residentTownhall.infomation", residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.INFORMATION)])
CreateResidentTrades("residentTownhall.trades", residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.TRADES)])
residentTownhall:SetCloseOnEscape(true)
function ToggleResidentTownhallUI(show)
  for i = 1, #residentTownhall.tab.window do
    local enable = RESIDENT_TAB_VIEW[i].enable or false
    residentTownhall.tab.unselectedButton[i]:Enable(enable)
  end
  if show == nil then
    show = not residentTownhall:IsVisible()
  end
  residentTownhall:Show(show)
  if show == true then
    local idx = residentTownhall.tab:GetSelectedTab()
    while not RESIDENT_TAB_VIEW[idx].enable do
      idx = idx + 1 > #residentTownhall.tab.window and 1 or idx + 1
    end
    residentTownhall:ChangeTab(idx)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_RESIDENT_TOWNHALL, ToggleResidentTownhallUI)
function residentTownhall:ChangeTab(idx)
  local tab = self.tab
  if idx == RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN) then
    if X2:IsWebEnable() and localeView.useWebContent then
      tab.window[idx].webBrowser:Show(true)
      tab.window[idx].webBrowser:RequestResidentBBS(X2Unit:GetCurrentZoneGroup())
    end
  elseif idx == RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.TRADES) then
    X2Resident:RequestHousingTradeList(X2Unit:GetCurrentZoneGroup(), HOUSING_LIST_FILTER_ALL, "")
  elseif tab.window[idx].RefreshTab ~= nil then
    tab.window[idx].RefreshTab()
  end
  for i = 1, #residentTownhall.tab.window do
    if i ~= idx and tab.window[i].HideWindow ~= nil then
      tab.window[i].HideWindow()
    end
  end
end
function residentTownhall:OnHide()
  local tab = self.tab
  if X2:IsWebEnable() and localeView.useWebContent and RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN) ~= nil then
    tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN)].webBrowser:Show(false)
  end
  for i = 1, #residentTownhall.tab.window do
    if tab.window[i].HideWindow ~= nil then
      tab.window[i].HideWindow()
    end
  end
end
residentTownhall:SetHandler("OnHide", residentTownhall.OnHide)
function residentTownhall:SetTabHandler()
  local tab = self.tab
  function tab:OnTabChangedProc(selected)
    residentTownhall:ChangeTab(selected)
  end
  local SetWebBrowserHandler = function(webBrowser)
    webBrowser:SetHandler("OnEnter", function()
      webBrowser:SetFocus()
    end)
    webBrowser:SetHandler("OnLeave", function()
      webBrowser:ClearFocus()
    end)
    local events = {
      WEB_BROWSER_ESC_EVENT = function(browser)
        if browser == webBrowser then
          ToggleResidentTownhallUI(false)
        end
      end
    }
    webBrowser:SetHandler("OnEvent", function(this, event, ...)
      events[event](...)
    end)
    webBrowser:RegisterEvent("WEB_BROWSER_ESC_EVENT")
  end
  if RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN) ~= nil then
    SetWebBrowserHandler(tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.BULLETIN)].webBrowser)
  end
end
residentTownhall:SetTabHandler()
local events = {
  RESIDENT_TOWNHALL = function(info)
    if residentTownhall:IsVisible() == false then
      return
    end
    local infomationTab = residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.INFORMATION)]
    infomationTab:OnFillData(info)
  end,
  RESIDENT_MEMBER_LIST = function(total, start, refresh, members)
    if residentTownhall:IsVisible() == false then
      return
    end
    local memberListTab = residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.MEMBERS)]
    memberListTab:OnFillData(total, start, refresh, members)
  end,
  INTERACTION_END = function()
    ToggleResidentTownhallUI(false)
  end,
  RESIDENT_HOUSING_TRADE_LIST = function(infos, rownum, filter, searchword, refresh)
    if residentTownhall:IsVisible() == false then
      return
    end
    local tradeListTab = residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.TRADES)]
    tradeListTab:OnFillData(infos, rownum, filter, searchword, refresh)
  end
}
residentTownhall:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(residentTownhall, events)
