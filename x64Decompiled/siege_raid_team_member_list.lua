local SiegeRaidTeamMemberListWnd
function HideMemberListWindow()
  if SiegeRaidTeamMemberListWnd and SiegeRaidTeamMemberListWnd:IsVisible() then
    SiegeRaidTeamMemberListWnd:Show(false)
  end
end
function ShowSiegeRaidTeamMemberListWnd(parent)
  local wnd = SetViewOfTeamMemberListWnd(parent)
  local OnRefresh = function()
    X2Team:RequestSiegeRaidTeamInfo(SIEGE_RAID_TEAM_INFO_BY_FACTION)
    coolTimeGroup.SetGlobalCoolTime()
  end
  wnd.refreshButton:SetHandler("OnClick", OnRefresh)
  coolTimeGroup.RegisterCoolTimeGroupBtn(wnd.refreshButton)
  function wnd:ShowProc()
    wnd:UpdateSiegeRaidTeamMembers(GetTeamInfo())
    if GetTeamInfo() == nil then
      OnRefresh()
    end
  end
  local events = {
    SIEGE_RAID_TEAM_INFO = function(info)
      if wnd:IsVisible() then
        wnd:UpdateSiegeRaidTeamMembers(info)
      end
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
function ToggleSiegeRaidTeamMemberListWnd()
  if SiegeRaidTeamMemberListWnd == nil then
    SiegeRaidTeamMemberListWnd = ShowSiegeRaidTeamMemberListWnd("UIParent")
  end
  SiegeRaidTeamMemberListWnd:Show(not SiegeRaidTeamMemberListWnd:IsVisible())
end
ADDON:RegisterContentTriggerFunc(UIC_SIEGE_RAID_TEAM_MEMBER_LIST_WND, ToggleSiegeRaidTeamMemberListWnd)
