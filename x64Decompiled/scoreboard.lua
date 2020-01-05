function ShowScoreboard(isShow, playSound)
  local mode = X2BattleField:GetGameMode()
  if mode == 1 then
    ShowScoreboard_Versus(isShow, playSound)
  elseif mode == 2 then
    ShowScoreboard_FreeForAll(isShow, playSound)
  elseif mode == 3 then
    ShowScoreboard_VersusBattleShip(isShow, playSound)
  elseif mode == 4 then
    ShowScoreboard_VersusFacion(isShow, playSound)
  end
end
local EnteredWorld = function()
  ShowScoreboard(true, false)
end
UIParent:SetEventHandler("ENTERED_WORLD", EnteredWorld)
