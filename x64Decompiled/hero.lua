local featureSet = X2Player:GetFeatureSet()
local SetViewOfHeroWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(800, 765)
  window:SetTitle(GetUIText(COMMON_TEXT, "hero"))
  local tabStrs = {
    GetUIText(COMMON_TEXT, "hero_current_status"),
    GetUIText(COMMON_TEXT, "candidate_rank"),
    GetUIText(COMMON_TEXT, "hero_mission_status"),
    GetUIText(COMMON_TEXT, "hero_quest")
  }
  local tab = W_BTN.CreateTab("tab", window)
  tab:AddTabs(tabStrs)
  CreateHeroCurrentStatus(tab.window[1])
  CreateHeroRankTab(tab.window[2])
  CreateHeroMissionTab(tab.window[3])
  CreateHeroQuestTab(tab.window[4])
  local serverName = window:CreateChildWidget("label", "serverName", 0, true)
  serverName:SetAutoResize(true)
  serverName:SetHeight(FONT_SIZE.LARGE)
  serverName:AddAnchor("TOPRIGHT", tab, -13, 8)
  ApplyTextColor(serverName, FONT_COLOR.WHITE)
  local serverBg = window:CreateDrawable("ui/hero/server.dds", "icon_server", "artwork")
  serverBg:AddAnchor("RIGHT", serverName, 12, 0)
  serverBg:AddAnchor("LEFT", serverName, -12, 0)
  local serverTitle = window:CreateChildWidget("label", "serverTitle", 0, true)
  serverTitle:SetAutoResize(true)
  serverTitle:SetHeight(FONT_SIZE.LARGE)
  serverTitle:AddAnchor("RIGHT", serverBg, "LEFT", -2, 0)
  serverTitle:SetText(GetCommonText("squad_info_list_server_name"))
  ApplyTextColor(serverTitle, FONT_COLOR.ROLE_NONE)
  return window
end
function CreateHeroRankWindow(id, parent)
  local frame = SetViewOfHeroWindow(id, parent)
  local serverName = X2World:GetCurrentWorldName()
  if serverName ~= nil then
    frame.serverName:SetText(serverName)
  end
  local heroTab = frame.tab.window[1]
  local rankTab = frame.tab.window[2]
  local missionTab = frame.tab.window[3]
  local questTab = frame.tab.window[4]
  local function OnHide()
    if heroTab.heroElectionRuleWnd ~= nil then
      heroTab.heroElectionRuleWnd:Show(false)
    end
    if questTab.heroBonusDescWnd ~= nil then
      questTab.heroBonusDescWnd:Show(false)
    end
  end
  frame:SetHandler("OnHide", OnHide)
  local events = {
    HERO_RANK_DATA_RETRIEVED = function(factionID)
      frame:RefreshTabEnable()
      rankTab:RankDataRetrieved(factionID)
    end,
    HERO_SEASON_UPDATED = function()
      frame:RefreshTabEnable()
      rankTab:SeasonUpdated()
      missionTab:FillPeriod()
    end,
    UPDATE_TODAY_ASSIGNMENT = function()
      frame:RefreshTabEnable()
    end,
    HERO_ALL_SCORE_UPDATED = function(factionID)
      missionTab:ScoreUpdated(factionID)
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  function frame:RefreshTabWindow()
    frame:RefreshTabEnable()
    heroTab.factionCombobox:RefreshFactionId(X2Hero:GetHeroFactions())
    rankTab.factionCombobox:RefreshFactionId(X2Hero:GetRankFactions())
    missionTab.factionCombobox:RefreshFactionId(X2Hero:GetHeroFactions())
    missionTab:FillPeriod()
    questTab:RefreshTab()
  end
  function frame:RefreshTabEnable()
    frame.tab.unselectedButton[4]:Enable(X2Hero:IsHero())
    if not X2Hero:IsHero() and frame.tab:GetSelectedTab() == 4 then
      frame.tab:SelectTab(1)
    end
    local factions = X2Hero:GetHeroFactions()
    frame.tab.unselectedButton[3]:Enable(#factions > 0)
    if #factions == 0 and frame.tab:GetSelectedTab() == 3 then
      frame.tab:SelectTab(1)
    end
  end
  return frame
end
local heroWindow
local featureSet = X2Player:GetFeatureSet()
if featureSet.hero then
  heroWindow = CreateHeroRankWindow("heroWindow", "UIParent")
  heroWindow:Show(false)
  heroWindow:AddAnchor("CENTER", "UIParent", 0, 0)
end
function ToggleHeroRankWindow(show)
  if heroWindow == nil then
    return
  end
  if show == nil then
    show = not heroWindow:IsVisible()
  end
  if show then
    local factionID = X2Hero:GetClientFactionID()
    X2Hero:RequestRankData(factionID)
    heroWindow:RefreshTabWindow()
  end
  heroWindow:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_HERO_RANK_WND, ToggleHeroRankWindow)
function ToggleHeroWithQuest(qType)
  local featureSet = X2Player:GetFeatureSet()
  if not featureSet.hero then
    return
  end
  local qInfo = X2Quest:GetTodayQuestInfo(qType)
  if qInfo == nil then
    return
  end
  ToggleHeroRankWindow(true)
  heroWindow.tab:SelectTab(4)
  heroWindow.tab.window[4]:ToggleWithQuest(qType)
end
