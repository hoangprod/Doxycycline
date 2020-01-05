local playerBreathBar = W_BAR.CreateCastingBar("playerBreathBar", "UIParent", "player")
playerBreathBar.text:SetCastingText(locale.castingBar.breath)
function playerBreathBar:OnUpdate()
  local totalTime, leftTime = X2Player:GetBreathTime()
  if totalTime ~= 0 then
    playerBreathBar.statusBar:SetMinMaxValues(0, totalTime)
    playerBreathBar.statusBar:SetValue(leftTime)
  end
end
local breathBarEvents = {
  DIVE_START = function()
    playerBreathBar.ShowAll()
  end,
  DIVE_END = function()
    playerBreathBar.HideAll()
  end,
  LEFT_LOADING = function()
    local totalTime, leftTime = X2Player:GetBreathTime()
    playerBreathBar.HideAll()
    if totalTime ~= 0 then
      playerBreathBar.ShowAll()
    end
  end
}
playerBreathBar:SetHandler("OnEvent", function(this, event, ...)
  breathBarEvents[event](...)
end)
playerBreathBar:RegisterEvent("DIVE_START")
playerBreathBar:RegisterEvent("DIVE_END")
playerBreathBar:RegisterEvent("LEFT_LOADING")
playerBreathBar:SetHandler("OnUpdate", playerBreathBar.OnUpdate)
playerBreathBar:AddAnchor("BOTTOM", "UIParent", 0, -185)
local totalTime, leftTime = X2Player:GetBreathTime()
playerBreathBar:Show(false)
if totalTime ~= 0 then
  playerBreathBar.ShowAll()
end
