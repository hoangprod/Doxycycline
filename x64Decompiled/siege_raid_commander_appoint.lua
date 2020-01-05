local commanderInfo, SiegeRaidCommanderAppointWnd
local function ShowCommanderAppointWnd(parent)
  local wnd = SetViewOfCommanderAppointWnd(parent, commanderInfo)
  local function OnClick()
    wnd:Show(false)
  end
  wnd.confirmBtn:SetHandler("OnClick", OnClick)
  local function OnHide()
    SiegeRaidCommanderAppointWnd = nil
  end
  wnd:SetHandler("OnHide", OnHide)
  return wnd
end
local function ShowSiegeRaidCommanderAppointWnd(isDefender, faction)
  if SiegeRaidCommanderAppointWnd == nil then
    commanderInfo = {defender = isDefender, factionId = faction}
    SiegeRaidCommanderAppointWnd = ShowCommanderAppointWnd("UIParent")
    SiegeRaidCommanderAppointWnd:Show(true)
  else
    commanderInfo = nil
    SiegeRaidCommanderAppointWnd:Show(false)
  end
end
UIParent:SetEventHandler("SIEGE_APPOINT_RESULT", ShowSiegeRaidCommanderAppointWnd)
