local sideMargin, titleMargin, bottomMargin = GetWindowMargin("popup")
local CreateTerritoryWindow = function(id, parent)
  local frame = SetViewOfTerritoryWindow(id, parent)
  local OnTabChanged = function(self, selected)
    ReAnhorTabLine(self, selected)
  end
  frame.tab:SetHandler("OnTabChanged", OnTabChanged)
  return frame
end
territoryFrame = CreateTerritoryWindow("territoryFrame", "UIParent")
territoryFrame:SetCloseOnEscape(true)
local guardTowerPage
local function UpdateGuardTowerPageInfo()
  if territoryFrame:IsVisible() then
    guardTowerPage:UpdateGuardTowerStepInfos()
  end
end
function ToggleTerritoryFrame(show, infos)
  if not show then
    territoryFrame:Show(false)
    return
  end
  territoryFrame.zoneGroup = infos.zone_group
  local guardTowerPage = territoryFrame.tab.window[1]
  guardTowerPage:UpdateGuardTowerStepInfos()
  territoryFrame:Show(true)
end
ADDON:RegisterContentTriggerFunc(UIC_DOMINION, ToggleTerritoryFrame)
local territoryEvents = {
  HOUSE_UNIT_CREATED = function()
    UpdateGuardTowerPageInfo()
  end,
  HOUSE_UNIT_REMOVED = function()
    UpdateGuardTowerPageInfo()
  end
}
territoryFrame:SetHandler("OnEvent", function(this, event, ...)
  territoryEvents[event](...)
end)
RegistUIEvent(territoryFrame, territoryEvents)
