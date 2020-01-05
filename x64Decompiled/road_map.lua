function roadmap:OnEnter()
  roadmap:ResetCursor(false)
end
roadmap:SetHandler("OnEnter", roadmap.OnEnter)
function roadmap:OnLeave()
  roadmap:ResetCursor(true)
end
roadmap:SetHandler("OnLeave", roadmap.OnLeave)
function roadmap:Resize(size)
  if size == nil then
    return
  end
  local rate = 0
  if size == 1 then
    rate = 0.5
  elseif size == 2 then
    rate = 0.7
  elseif size == 3 then
    rate = 1
  else
    return
  end
  roadmapWindow:SetExtent(926 * rate, 556 * rate)
  self:SetMapSize(rate * 100)
end
local tooltipController = roadmap:GetTooltipController()
tooltipController:SetHandler("OnLeave", HideMapTooltip)
tooltipController:SetHandler("OnHide", HideMapTooltip)
local roadMapEvents = {
  SHOW_ROADMAP_TOOLTIP = function(tooltipInfo, tooltipCount)
    ShowMapTooltip(tooltipInfo, tooltipCount, tooltipController, M_TOOLTIP_OFFSET_X, M_TOOLTIP_OFFSET_Y, M_TOOLTIP_OFFSET_REVERSE_X, M_TOOLTIP_OFFSET_REVERSE_Y)
  end,
  HIDE_ROADMAP_TOOLTIP = function(text)
    HideMapTooltip()
  end,
  UPDATE_ZONE_INFO = function()
    roadmap:UpdateZoneInfo()
  end,
  UPDATE_NPC_INFO = function()
    roadmap:UpdateNpcInfo()
  end,
  UPDATE_DOODAD_INFO = function()
    roadmap:UpdateDoodadInfo()
  end,
  UPDATE_GIVEN_QUEST_STATIC_INFO = function()
    roadmap:UpdateGivenQuestStaticInfo()
  end,
  UPDATE_HOUSING_INFO = function()
    roadmap:UpdateHousingInfo()
  end,
  UPDATE_SHIP_TELESCOPE_INFO = function()
    roadmap:UpdateShipTelescopeInfo()
  end,
  UPDATE_TRANSFER_TELESCOPE_INFO = function()
    roadmap:UpdateTransferTelescopeInfo()
  end,
  UPDATE_BOSS_TELESCOPE_INFO = function()
    roadmap:UpdateBossTelescopeInfo()
  end,
  UPDATE_CARRYING_BACKPACK_SLAVE_INFO = function()
    roadmap:UpdateCarryingBackpackSlaveInfo()
  end,
  UPDATE_FISH_SCHOOL_INFO = function()
    roadmap:UpdateFishSchoolInfo()
  end,
  UPDATE_CORPSE_INFO = function()
    roadmap:UpdateCorpseInfo()
  end,
  UPDATE_MY_SLAVE_POS_INFO = function()
    roadmap:UpdateMySlaveInfo()
  end,
  CLEAR_NPC_INFO = function()
    roadmap:ClearNpcInfo()
  end,
  CLEAR_DOODAD_INFO = function()
    roadmap:ClearDoodadInfo()
  end,
  CLEAR_GIVEN_QUEST_STATIC_INFO = function()
    roadmap:ClearGivenQuestStaticInfo()
  end,
  CLEAR_HOUSING_INFO = function()
    roadmap:ClearHousingInfo()
  end,
  CLEAR_SHIP_TELESCOPE_INFO = function()
    roadmap:ClearShipTelescopeInfo()
  end,
  CLEAR_TRANSFER_TELESCOPE_INFO = function()
    roadmap:ClearTransferTelescopeInfo()
  end,
  CLEAR_BOSS_TELESCOPE_INFO = function()
    roadmap:ClearBossTelescopeInfo()
  end,
  CLEAR_CARRYING_BACKPACK_SLAVE_INFO = function()
    roadmap:ClearCarryingBackpackSlaveInfo()
  end,
  CLEAR_FISH_SCHOOL_INFO = function()
    roadmap:ClearFishSchoolInfo()
  end,
  CLEAR_CORPSE_INFO = function()
    roadmap:ClearCorpseInfo()
  end,
  CLEAR_MY_SLAVE_POS_INFO = function()
    roadmap:ClearMySlaveInfo()
  end,
  UPDATE_PING_INFO = function()
    roadmap:UpdatePingInfo()
    EnablePingBtn()
  end,
  ADD_GIVEN_QUEST_INFO = function(arg1, arg2)
    roadmap:AddGivenQuestInfo(arg1, arg2)
  end,
  REMOVE_GIVEN_QUEST_INFO = function(arg1, arg2)
    roadmap:RemoveGivenQuestInfo(arg1, arg2)
  end,
  UPDATE_COMPLETED_QUEST_INFO = function()
    roadmap:UpdateCompletedQuestInfo()
  end,
  CLEAR_COMPLETED_QUEST_INFO = function()
    roadmap:ClearCompletedQuestInfo()
  end,
  ADD_NOTIFY_QUEST_INFO = function(arg)
    roadmap:AddNotifyQuestInfo(arg)
  end,
  REMOVE_NOTIFY_QUEST_INFO = function(arg)
    roadmap:RemoveNotifyQuestInfo(arg)
  end,
  CLEAR_NOTIFY_QUEST_INFO = function()
    roadmap:ClearNotifyQuestInfo()
  end,
  UPDATE_DOMINION_INFO = function()
    roadmap:UpdateDominionInfo()
  end,
  UI_RELOADED = function()
    roadmap:ReloadAllInfo()
  end,
  LEFT_LOADING = function()
    roadmap:ReloadAllInfo()
  end,
  ENTERED_WORLD = function()
    roadmap:ReloadAllInfo()
  end,
  ENTERED_LOADING = function()
    roadmap:ClearAllInfo()
  end,
  UPDATE_ROADMAP_ANCHOR = function(file, key)
    UpdateRoadmapAnchor(file, key)
  end,
  SET_ROADMAP_PICKABLE = function(pick)
    roadmapWindow:EnablePick(pick)
    roadmapWindow.background:SetVisible(pick)
  end,
  UPDATE_TELESCOPE_AREA = function()
    roadmap:UpdateTelescopeArea()
  end,
  UPDATE_TRANSFER_TELESCOPE_AREA = function()
    roadmap:UpdateTransferTelescopeArea()
  end,
  UPDATE_BOSS_TELESCOPE_AREA = function()
    roadmap:UpdateBossTelescopeArea()
  end,
  UPDATE_FISH_SCHOOL_AREA = function()
    roadmap:UpdateFishSchoolArea()
  end,
  REMOVE_SHIP_TELESCOPE_INFO = function(arg)
    roadmap:RemoveShipTelescopeInfo(arg)
  end,
  REMOVE_TRANSFER_TELESCOPE_INFO = function(arg)
    roadmap:RemoveTransferTelescopeInfo(arg)
  end,
  REMOVE_BOSS_TELESCOPE_INFO = function(arg)
    roadmap:RemoveBossTelescopeInfo(arg)
  end,
  REMOVE_CARRYING_BACKPACK_SLAVE_INFO = function(arg)
    roadmap:RemoveCarryingBackpackSlaveInfo(arg)
  end,
  REMOVE_FISH_SCHOOL_INFO = function(arg)
    roadmap:RemoveFishSchoolInfo(arg)
  end,
  EXPLORED_REGION_UPDATED = function()
    roadmap:ExploredRegionUpdated()
  end,
  ZONEGROUP_STATE_START = function()
    roadmap:UpdateZoneGroupStateInfo()
  end,
  ZONEGROUP_STATE_END = function()
    roadmap:UpdateZoneGroupStateInfo()
  end,
  ZONEGROUP_STATE_BRIEFING = function()
    roadmap:UpdateZoneGroupStateInfo()
  end,
  UPDATE_MONITOR_NPC = function()
    roadmap:UpdateMonitorNpcInfo()
  end,
  NATION_KICK = function()
    roadmap:UpdateCurZoneGroupNpcInfo()
  end,
  NATION_INVITE = function()
    roadmap:UpdateCurZoneGroupNpcInfo()
  end,
  INSTANT_GAME_END = function()
    roadmap:UpdateTerritoryInfo()
  end,
  INSTANT_GAME_RETIRE = function()
    roadmap:UpdateTerritoryInfo()
  end,
  UPDATE_INSTANT_GAME_SCORES = function()
    roadmap:UpdateTerritoryInfo()
  end
}
roadmap:SetHandler("OnEvent", function(this, event, ...)
  roadMapEvents[event](...)
end)
RegistUIEvent(roadmap, roadMapEvents)
