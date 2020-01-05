AICharacter = {
  INTERNAL = {
    Player = "Scripts/AI/Characters/x2/player.lua"
  },
  AVAILABLE = {
    dummy = "Scripts/AI/Characters/x2/dummy.lua",
    default = "Scripts/AI/Characters/x2/default.lua",
    roaming = "Scripts/AI/Characters/x2/roaming.lua",
    hold_position = "Scripts/AI/Characters/x2/hold_position.lua",
    tower_defense_attacker = "Scripts/AI/Characters/x2/tower_defense_attacker.lua",
    flytrap = "Scripts/AI/Characters/x2/flytrap.lua",
    almighty_npc = "Scripts/AI/Characters/x2/almighty_npc.lua",
    big_monster_hold_position = "Scripts/AI/Characters/x2/big_monster_hold_position.lua",
    big_monster_roaming = "Scripts/AI/Characters/x2/big_monster_roaming.lua",
    archer_hold_position = "Scripts/AI/Characters/x2/archer_hold_position.lua",
    archer_roaming = "Scripts/AI/Characters/x2/archer_roaming.lua",
    wild_boar_hold_position = "Scripts/AI/Characters/x2/wild_boar_hold_position.lua",
    wild_boar_roaming = "Scripts/AI/Characters/x2/wild_boar_roaming.lua",
    bind_to_unit = "Scripts/AI/Characters/x2/bind_to_unit.lua"
  }
}
AI.LogEvent("LOADED AI CHARACTERS")
Script.ReloadScript("Scripts/AI/Characters/DEFAULT.lua")
function AICharacter:LoadAll()
  for name, filename in pairs(self.AVAILABLE) do
    AI.LogEvent("Preloading character " .. name)
    Script.ReloadScript(filename)
  end
  for name, filename in pairs(self.INTERNAL) do
    AI.LogEvent("Preloading character " .. name)
    Script.ReloadScript(filename)
  end
end
