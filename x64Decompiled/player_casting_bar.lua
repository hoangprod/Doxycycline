local playerCastingBar = W_BAR.CreateCastingBar("playerCastingBar", "UIParent", "player")
playerCastingBar:RegisterEvent("SPELLCAST_START")
playerCastingBar:RegisterEvent("SPELLCAST_STOP")
playerCastingBar:RegisterEvent("SPELLCAST_SUCCEEDED")
local events = {
  UNIT_DEAD = function(stringId, _, _)
    if not W_UNIT.IsMyUnitId(stringId) then
      return
    end
    playerCastingBar.HideAll()
    playerCastingBar.spellName = nil
  end
}
playerCastingBar:SetEventProc(events)
playerCastingBar:RegisterEvent("UNIT_DEAD")
playerCastingBar:AddAnchor("BOTTOM", "UIParent", 0, -150)
playerCastingBar:Show(false)
