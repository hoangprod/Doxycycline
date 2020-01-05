AIBehaviour = {
  AVAILABLE = {
    spawning = "scripts/AI/Behaviors/x2/common/spawning.lua",
    dummy = "scripts/AI/Behaviors/x2/common/dummy.lua",
    idle = "scripts/AI/Behaviors/x2/common/idle.lua",
    hold_position = "scripts/AI/Behaviors/x2/common/hold_position.lua",
    roaming = "scripts/AI/Behaviors/x2/common/roaming.lua",
    do_nothing = "scripts/AI/Behaviors/x2/common/do_nothing.lua",
    talk = "scripts/AI/Behaviors/x2/common/talk.lua",
    alert = "scripts/AI/Behaviors/x2/common/alert.lua",
    attack = "scripts/AI/Behaviors/x2/common/attack.lua",
    binded_attack = "scripts/AI/Behaviors/x2/common/binded_attack.lua",
    follow_path = "scripts/AI/Behaviors/x2/common/follow_path.lua",
    follow_unit = "scripts/AI/Behaviors/x2/common/follow_unit.lua",
    bind_unit = "scripts/AI/Behaviors/x2/common/bind_unit.lua",
    return_state = "scripts/AI/Behaviors/x2/common/return_state.lua",
    run_command_set = "scripts/AI/Behaviors/x2/common/run_command_set.lua",
    dead = "scripts/AI/Behaviors/x2/common/dead.lua",
    despawning = "scripts/AI/Behaviors/x2/common/despawning.lua",
    flytrap_alert = "scripts/AI/Behaviors/x2/flytrap/flytrap_alert.lua",
    flytrap_attack = "scripts/AI/Behaviors/x2/flytrap/flytrap_attack.lua",
    big_monster_attack = "scripts/AI/Behaviors/x2/big_monster/big_monster_attack.lua",
    archer_attack = "scripts/AI/Behaviors/x2/archer/archer_attack.lua",
    wild_boar_attack = "scripts/AI/Behaviors/x2/wild_boar/wild_boar_attack.lua",
    almighty_attack = "scripts/AI/Behaviors/x2/common/almighty_attack.lua"
  },
  INTERNAL = {
    player_idle = "Scripts/AI/Behaviors/x2/player/player_idle.lua"
  }
}
AI.LogEvent("LOADED AI BEHAVIOURS")
Script.ReloadScript("Scripts/AI/Behaviors/DEFAULT.lua")
function AIBehaviour:LoadAll()
  for name, filename in pairs(self.AVAILABLE) do
    Script.ReloadScript(filename)
  end
  for name, filename in pairs(self.INTERNAL) do
    Script.ReloadScript(filename)
  end
end
