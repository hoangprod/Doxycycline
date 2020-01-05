local ShowMiniScoreboard = function(isShow)
  local mode = X2BattleField:GetGameMode()
  if mode == 1 then
    ShowMiniScoreboard_Versus(isShow)
  elseif mode == 2 then
    local victoryConditions = X2BattleField:GetProgressVictoryConditionInfo()
    if victoryConditions.remainSoldiers == nil then
      ShowMiniScoreboard_FreeForAllOld(isShow)
    else
      ShowMiniScoreboard_FreeForAll(isShow)
    end
  elseif mode == 3 then
    ShowMiniScoreboard_VersusBattleShip(isShow)
  elseif mode == 4 then
    ShowMiniScoreboard_VersusFaction(isShow)
  end
end
local function InstantGameStart()
  ShowMiniScoreboard(true)
end
UIParent:SetEventHandler("INSTANT_GAME_START", InstantGameStart)
local function EnteredWorld()
  local timeInfo = X2BattleField:GetProgressTimeInfo()
  if timeInfo == nil or timeInfo.state ~= "STARTED" then
    ShowMiniScoreboard(false)
    return
  end
  ShowMiniScoreboard(true)
end
UIParent:SetEventHandler("ENTERED_WORLD", EnteredWorld)
