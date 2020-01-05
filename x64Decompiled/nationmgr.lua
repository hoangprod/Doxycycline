local nationMgrView
local HideAllNationWnd = function()
  ShowBelongExpeditionList(false)
  if friendlyReqWnd then
    friendlyReqWnd:Show(false)
  end
  if hostileReqWnd then
    hostileReqWnd:Show(false)
  end
  if dominionGuideWnd then
    dominionGuideWnd:Show(false)
  end
  if relationHistory then
    relationHistory:Show(false)
  end
  if relationRequest then
    relationRequest:Show(false)
  end
end
function CreateNationFrame(id, parent)
  local frame = SetViewOfnationMgrView(id, parent)
  local prevTab
  function frame.tab:OnTabChangedProc(selected)
    if prevTab ~= nil and frame.tab.window[prevTab].Close ~= nil then
      frame.tab.window[prevTab]:Close()
    end
    frame.tab.window[selected]:Init()
    HideAllNationWnd()
    prevTab = selected
  end
  function parent:OnHide()
    HideAllNationWnd()
    prevTab = nil
    local siegeRaidTeamWnd = frame.tab.window[NATION_TAB.SIEGE_RAID_TEAM]
    if siegeRaidTeamWnd ~= nil then
      siegeRaidTeamWnd:OnHide()
    end
    local siegeInfoWnd = frame.tab.window[NATION_TAB.SIEGE_INFO]
    if siegeInfoWnd ~= nil then
      siegeInfoWnd:OnHide()
    end
  end
  parent:SetHandler("OnHide", parent.OnHide)
  function parent:OnShow()
    local myName = X2Unit:UnitName("player")
    local isExistSiegeRaidTeam = X2Team:IsExistSiegeRaidTeam()
    self.tab.selectedButton[NATION_TAB.SIEGE_RAID_TEAM]:Enable(isExistSiegeRaidTeam)
    self.tab.unselectedButton[NATION_TAB.SIEGE_RAID_TEAM]:Enable(isExistSiegeRaidTeam)
    self.tab.selectedButton[NATION_TAB.SIEGE_INFO]:Enable(true)
    self.tab.unselectedButton[NATION_TAB.SIEGE_INFO]:Enable(true)
    self.tab:SelectTab(NATION_TAB.RELATION)
  end
  parent:SetHandler("OnShow", parent.OnShow)
  function ShowSiegeScheduleTab()
    if frame:IsVisible() then
      ADDON:ShowContent(UIC_NATION, false)
    else
      ADDON:ShowContent(UIC_NATION, true)
      frame.tab:SelectTab(NATION_TAB.SIEGE_INFO)
    end
  end
  local events = {
    NATION_INDEPENDENCE = function(ownerName, nationName)
      if not parent:IsVisible() then
        return
      end
      parent:OnShow()
    end,
    NATION_KICK = function()
      if not parent:IsVisible() then
        return
      end
      parent:OnShow()
    end,
    NATION_INVITE = function()
      if not parent:IsVisible() then
        return
      end
      parent:OnShow()
    end,
    NATION_OWNER_CHANGE = function()
      if not parent:IsVisible() then
        return
      end
      parent:OnShow()
    end,
    RAID_RECRUIT_LIST = function(data)
      if frame ~= nil and frame.tab ~= nil then
        local isExistSiegeRaidTeam = X2Team:IsExistSiegeRaidTeam()
        frame.tab.selectedButton[NATION_TAB.SIEGE_RAID_TEAM]:Enable(isExistSiegeRaidTeam)
        frame.tab.unselectedButton[NATION_TAB.SIEGE_RAID_TEAM]:Enable(isExistSiegeRaidTeam)
      end
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
function ToggleNationMgrView(force)
  ToggleCommunityWindow(force, COMMUNITY.NATION)
end
ADDON:RegisterContentTriggerFunc(UIC_NATION, ToggleNationMgrView)
