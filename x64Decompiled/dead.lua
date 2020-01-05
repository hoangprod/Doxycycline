AIBehaviour.dead = {
  Name = "dead",
  alertness = AIALERTNESS_IDLE,
  Constructor = function(self, entity)
    entity:ClearAICombat("dead")
    AI.BeginGoalPipe("dead_Base")
    AI.PushGoal("bodypos", 1, BODYPOS_RELAX)
    AI.PushGoal("run", 1, 0)
    AI.PushGoal("timeout", 1, 2)
    AI.PushGoal("useskill", 1, 0)
    AI.EndGoalPipe()
    entity:SelectPipe(AIGOALPIPE_DONT_RESET_AG, "dead_Base")
  end,
  OnRequestSkillInfo = function(self, entity)
    entity.unit:NpcSetSkillList(entity.AI.skills.dead)
  end,
  OnEnemySeen = function(self, entity)
  end,
  OnFriendSeen = function(self, entity)
  end,
  OnAlertTargetChanged = function(self, entity, sender, data)
  end,
  OnGroupLeaderDied = function(self, entity)
  end,
  OnGroupMemberDied = function(self, entity)
  end
}
