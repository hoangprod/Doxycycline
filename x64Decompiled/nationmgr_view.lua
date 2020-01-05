local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local nationTab = {}
nationTab[NATION_TAB.RELATION] = locale.nationMgr.nationRelation
nationTab[NATION_TAB.DOMINION] = locale.nationMgr.dominion
nationTab[NATION_TAB.SIEGE_INFO] = locale.dominion.siege_info
nationTab[NATION_TAB.SIEGE_RAID_TEAM] = locale.nationMgr.siegeRaidTeam
function SetViewOfnationMgrView(id, parent)
  local tab = W_BTN.CreateTab("tab", parent)
  tab:AddAnchor("TOPLEFT", parent, 0, 0)
  tab:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  tab:AddTabs(nationTab)
  CreateRelationTabOfNationMgr(tab.window[NATION_TAB.RELATION])
  CreateDominionTabOfNationMgr(tab.window[NATION_TAB.DOMINION])
  CreateSiegeInfoMgr(tab.window[NATION_TAB.SIEGE_INFO])
  CreateSiegeRaidTeamTabOfNationMgr(tab.window[NATION_TAB.SIEGE_RAID_TEAM])
  return parent
end
