local gmCommandMenu = {
  gmSetHealth = {"\236\178\180\235\160\165", "Set Health"},
  gmSetMana = {"\235\167\136\235\130\152", "Set Mana"},
  gmSetAttribute = {
    "\236\134\141\236\132\177",
    "Set Attribute"
  },
  gmClearAttribute = {
    "\236\134\141\236\132\177 \236\180\136\234\184\176\237\153\148",
    "Clear Attribute"
  },
  gmResetSkillCooldown = {
    "\236\138\164\237\130\172\236\191\168\235\139\164\236\154\180\236\180\136\234\184\176\237\153\148",
    "Reset Skill Cooldown"
  },
  gmChangeFaction = {
    "\237\140\169\236\133\152\235\179\128\234\178\189",
    "Change Faction"
  },
  gmSpawnNpc = {"NPC\236\134\140\237\153\152", "Spawn Npc"},
  gmSpawnSlave = {
    "Slave\236\134\140\237\153\152",
    "Spawn Slave"
  },
  gmSpawnMate = {"Mate\236\134\140\237\153\152", "Spawn Mate"},
  gmSpawnDoodad = {
    "Doodad\236\134\140\237\153\152",
    "Spawn Doodad"
  },
  gmSpawnGimmick = {
    "Gimmick\236\134\140\237\153\152",
    "Spawn Gimmick"
  },
  gmDumpChar = {
    "\236\186\144\235\166\173\237\132\176\236\160\149\235\179\180",
    "Character Info View"
  },
  gmDumpCharBag = {
    "\234\176\128\235\176\169\235\179\180\234\184\176",
    "Character Bag View"
  },
  gmDumpCharEquipment = {
    "\236\158\165\235\185\132\235\179\180\234\184\176",
    "Character Equipment View"
  },
  gmDumpCharParty = {
    "\237\140\140\237\139\176\235\179\180\234\184\176",
    "Character Party View"
  },
  gmDumpGameRule = {
    "\234\178\140\236\158\132\235\163\176\235\141\164\237\148\132",
    "Dump Game Rule"
  },
  gmGoTo = {
    "\236\176\190\236\149\132\234\176\128\234\184\176",
    "Go To"
  },
  gmChangeMode = {
    "\235\170\168\235\147\156\235\176\148\234\190\184\234\184\176",
    "Change Mode"
  },
  gmAddLaborPower = {
    "\235\133\184\235\143\153\235\160\165\235\141\148\237\149\152\234\184\176",
    "Add Labor Power"
  },
  gmAddExp = {
    "\234\178\189\237\151\152\236\185\152\235\141\148\237\149\152\234\184\176",
    "Add Exp"
  },
  gmSetExpFactor = {
    "\234\178\189\237\151\152\236\185\152\237\154\141\235\147\157\235\159\137\236\161\176\236\160\136",
    "Set Exp Factor"
  },
  gmAddMoney = {
    "\235\143\136\235\141\148\237\149\152\234\184\176",
    "Add Money"
  },
  gmChangeNpcFriendship = {
    "NPC\236\154\176\237\152\184\235\143\132\235\179\128\234\178\189",
    "Change Npc Friendship"
  },
  gmReturn = {"\234\183\128\237\153\152", "Return"},
  gmGiveNewItem = {
    "\236\149\132\236\157\180\237\133\156\236\131\157\236\132\177",
    "Give New Item"
  },
  gmSetEmptyBag = {
    "\234\176\128\235\176\169\235\185\132\236\154\176\234\184\176",
    "Set Empty Bag"
  },
  gmPlaySequence = {
    "\236\187\183\236\148\172\236\158\172\236\131\157",
    "Play Sequence"
  },
  gmSetHousePermission = {
    "House\234\182\140\237\149\156\236\132\164\236\160\149",
    "Set House Permission"
  },
  gmUseSkill = {
    "\236\138\164\237\130\172\236\130\172\236\154\169",
    "Use Skill"
  },
  gmSetBuff = {
    "\235\178\132\237\148\132\236\132\164\236\160\149",
    "Set Buff"
  },
  gmClearBuff = {
    "\237\138\185\236\160\149\235\178\132\237\148\132\236\160\156\234\177\176",
    "Clear Buff"
  },
  gmClearBuffs = {
    "\236\160\132\236\178\180\235\178\132\237\148\132\236\160\156\234\177\176",
    "Clear Buffs"
  },
  gmSetInvisible = {"\237\136\172\235\170\133", "Invisible"},
  gmSummon = {"\236\134\140\237\153\152", "Summon"},
  gmNotice = {"\234\179\181\236\167\128", "Notice"},
  gmKick = {
    "\234\176\149\236\160\156\236\182\148\235\176\169",
    "Kick"
  },
  gmRecoverHouses = {
    "House\235\147\164\235\179\181\234\181\172",
    "RecoverHouses"
  },
  gmResetHouses = {
    "House\235\147\164\236\180\136\234\184\176\237\153\148",
    "ResetHouses"
  },
  gmCheckZone = {
    "\237\152\132\236\156\132\236\185\152Zone\236\158\136\235\138\148\236\167\128\237\153\149\236\157\184",
    "Check Zone"
  },
  gmSetCongestion = {
    "\236\162\133\236\161\177\235\179\132\236\139\156\236\158\145\236\160\144\237\152\188\236\158\161\235\143\132\236\132\164\236\160\149",
    "Set Congestion"
  },
  gmDumpIndun = {
    "\237\152\132\236\158\172\236\157\184\235\141\152\235\141\164\237\148\132",
    "Dump Indun"
  },
  gmDebugLooting = {
    "\235\163\168\237\140\133\236\160\149\235\179\180\235\179\180\234\184\176",
    "Debug Looting"
  },
  gmResurrect = {"\235\182\128\237\153\156", "Resurrect"},
  gmSetCrimeValue = {
    "\235\178\148\236\163\132\236\136\152\236\185\152\236\132\164\236\160\149",
    "Set Crime Value"
  },
  gmRemoveAllItems = {
    "\235\170\168\235\147\160\236\149\132\236\157\180\237\133\156\236\130\173\236\160\156",
    "Remove All Items"
  },
  gmEndInstantGameJoined = {
    "\237\152\132\236\158\172\236\134\141\237\149\156\236\157\184\235\141\152\234\178\140\236\158\132\236\162\133\235\163\140",
    "End Instant Game Joined"
  },
  gmEndInstantGame = {
    "\236\157\184\235\141\152\234\178\140\236\158\132\236\162\133\235\163\140",
    "End Instant Game"
  },
  gmDeleteDominion = {
    "\236\152\129\236\167\128\236\130\173\236\160\156",
    "Delete Dominion"
  },
  gmScheduleSiege = {
    "\234\179\181\236\132\177\236\157\188\236\160\149",
    "Schedule Siege"
  },
  gmTowerDefList = {
    "\237\131\128\236\155\140\235\176\169\236\150\180\235\170\169\235\161\157",
    "Tower Def List"
  },
  gmTowerDefReload = {
    "\237\131\128\236\155\140\235\176\169\236\150\180\235\166\172\235\161\156\235\147\156",
    "Tower Def Reload"
  },
  gmTowerDefStart = {
    "\237\131\128\236\155\140\235\176\169\236\150\180\236\139\156\236\158\145",
    "Tower Def Start"
  },
  gmTowerDefStop = {
    "\237\131\128\236\155\140\235\176\169\236\150\180\236\164\145\236\167\128",
    "Tower Def Stop"
  },
  gmAddActionPoint = {
    "\236\136\153\235\160\168\236\161\176\236\160\136",
    "Add Action Point"
  },
  gmSetDoodadGrowth = {
    "\235\145\144\235\139\164\235\147\156\236\132\177\236\158\165",
    "Set Doodad Growth"
  },
  gmWorldGoTo = {
    "\236\162\140\237\145\156\236\157\180\235\143\153",
    "World Go To"
  },
  gmFreeze = {"\236\150\188\236\157\140", "Freeze"},
  gmUnFreeze = {"\235\133\185\236\157\140", "UnFreeze"},
  gmResendHouseTaxMail = {
    "\236\132\184\234\184\136\234\179\160\236\167\128\236\132\156\236\158\172\235\176\156\236\134\161",
    "Resend House Tax Mail"
  },
  gmDelayTaxDueDate = {
    "\236\132\184\234\184\136\235\130\169\235\182\128\236\178\152\235\166\172",
    "Delay TaxDue Date"
  },
  gmRecoverDoodad = {
    "\235\145\144\235\139\164\235\147\156 \237\154\140\236\136\152",
    "Recover Doodad"
  },
  gmDemolishHouse = {
    "\237\149\152\236\154\176\236\167\149 \234\176\149\236\160\156 \236\178\160\234\177\176",
    "Demolish House"
  },
  gmMoveCharRezPoint = {
    "\235\182\128\237\153\156\236\167\128\236\160\144 \236\157\180\235\143\153",
    "Move Character Rez Point"
  },
  gmDumpCharBank = {
    "\236\176\189\234\179\160\235\179\180\234\184\176",
    "Character Bank View"
  },
  gmDumpCharQuests = {
    "\237\128\152\236\138\164\237\138\184\235\170\169\235\161\157",
    "Character Quests"
  },
  gmBlockChat = {
    "\236\177\132\237\140\133\234\184\136\236\167\128",
    "Block Chat"
  },
  gmRemoveSlave = {
    "\236\138\172\235\160\136\236\157\180\235\184\140\236\134\140\237\153\152\237\149\180\236\160\156",
    "Remove Slave"
  },
  gmReturnNpc = {
    "NPC \234\176\149\236\160\156 \237\154\140\234\183\128",
    "Return Npc"
  },
  gmCheckBotPlayer = {
    "BOT \237\153\149\236\157\184",
    "Check Bot Player"
  },
  gmSetInvincible = {"\235\172\180\236\160\129", "Invincible"},
  gmBlockWhisper = {
    "\234\183\147\236\134\141\235\167\144\236\176\168\235\139\168",
    "Block Whisper"
  },
  gmAlmighty = {
    "\236\152\172\235\167\136\236\157\180\237\139\176",
    "Almighty"
  },
  gmSetUnInvisible = {
    "\235\182\136\237\136\172\235\170\133",
    "UnInvisible"
  },
  gmSetUnInvincible = {
    "\236\156\160\236\160\129",
    "UnInvincible"
  },
  gmAllowWhisper = {
    "\234\183\147\236\134\141\235\167\144\236\136\152\236\139\160",
    "Allow Whisper"
  },
  gmUnAlmighty = {
    "\236\149\136\236\152\172\235\167\136\236\157\180\237\139\176",
    "UnAlmighty"
  },
  gmUpdateLeadershipPoint = {
    "\237\134\181\236\134\148\235\160\165(\235\136\132\236\160\129)",
    "Update LeadershipPoint"
  },
  gmUpdateHeroScore = {
    "\237\134\181\236\134\148\235\160\165(\234\184\176\234\176\132)",
    "Update HeroScore"
  },
  gmDumpInstantGame = {
    "\236\160\132\236\158\165\236\154\148\236\149\189\236\160\149\235\179\180",
    "Dump Instant Game"
  },
  gmInfoInstantApplier = {
    "\236\160\132\236\158\165\236\139\160\236\178\173\236\160\149\235\179\180",
    "Info Instant Applier"
  },
  gmInfoInstantField = {
    "\236\160\132\236\158\165\236\132\156\235\178\132\236\160\149\235\179\180",
    "Info Instant Field"
  },
  gmSetInstantExclusive = {
    "\236\160\132\236\158\165\235\143\133\236\160\144\236\132\164\236\160\149",
    "Set Instant Exclusive"
  },
  gmSetBattleRecordRating = {
    "ELO RATING \236\132\164\236\160\149",
    "Set Battle Record Rating"
  },
  gmSetInstantGmEventMode = {
    "\236\157\180\235\178\164\237\138\184\236\160\132\236\158\165 \236\132\164\236\160\149",
    "Set Instant Gm Event Mode"
  },
  gmDumpInstantGameGmEvent = {
    "\236\157\180\235\178\164\237\138\184\236\160\132\236\158\165 \236\160\149\235\179\180",
    "Dump Instant Game Gm Event"
  },
  gmApplyInstantGameGmEvent = {
    "\236\157\180\235\178\164\237\138\184\236\160\132\236\158\165 \236\158\133\236\158\165",
    "Set Instant Game Gm Event"
  },
  gmSetTradeStatus = {
    "\235\172\180\236\151\173 \237\140\144\235\167\164 \236\132\164\236\160\149",
    "Set Trade Status"
  },
  gmShowTradeStatus = {
    "\235\172\180\236\151\173 \237\140\144\235\167\164 \236\132\164\236\160\149 \237\153\149\236\157\184",
    "Show Trade Status"
  },
  gmOneAndOneChat = {
    "\236\157\188\235\140\128\236\157\188 \236\177\132\237\140\133",
    "One And One Chat"
  }
}
local gmUiTexts = {
  create = {"\236\131\157\236\132\177", "Create"}
}
gmFuncs = {
  {
    name = gmCommandMenu.gmSetHealth[localeView.localGmCommand],
    func = "SetHealth(%s, %d)",
    args = {
      {target = "target"},
      {health = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetMana[localeView.localGmCommand],
    func = "SetMana(%s, %d)",
    args = {
      {target = "target"},
      {mana = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetAttribute[localeView.localGmCommand],
    func = "SetAttribute(%s, %s, %d)",
    args = {
      {target = "target"},
      {attr = ""},
      {val = 0}
    }
  },
  {
    name = gmCommandMenu.gmClearAttribute[localeView.localGmCommand],
    func = "ClearAttribute(%s, %s)",
    args = {
      {target = "target"},
      {attr = ""}
    }
  },
  {
    name = gmCommandMenu.gmResetSkillCooldown[localeView.localGmCommand],
    func = "ResetSkillCooldown(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmChangeFaction[localeView.localGmCommand],
    func = "ChangeFaction(%s, %d)",
    args = {
      {target = "target"},
      {factionId = 0}
    }
  },
  {
    name = gmCommandMenu.gmSpawnNpc[localeView.localGmCommand],
    func = "SpawnNpc(%s, %d)",
    args = {
      {target = "player"},
      {npcType = 0}
    }
  },
  {
    name = gmCommandMenu.gmSpawnSlave[localeView.localGmCommand],
    func = "SpawnSlave(%s, %d)",
    args = {
      {target = "player"},
      {slaveType = 0}
    }
  },
  {
    name = gmCommandMenu.gmSpawnMate[localeView.localGmCommand],
    func = "SpawnMate(%s, %d)",
    args = {
      {target = "player"},
      {npcType = 0}
    }
  },
  {
    name = gmCommandMenu.gmSpawnDoodad[localeView.localGmCommand],
    func = "SpawnDoodad(%s, %d)",
    args = {
      {target = "player"},
      {doodadType = 0}
    }
  },
  {
    name = gmCommandMenu.gmSpawnGimmick[localeView.localGmCommand],
    func = "SpawnGimmick(%s, %d, %f)",
    args = {
      {target = "player"},
      {gimmickType = 0},
      {speedX = 1}
    }
  },
  {
    name = gmCommandMenu.gmDumpChar[localeView.localGmCommand],
    func = "DumpChar(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmDumpCharBag[localeView.localGmCommand],
    func = "DumpCharBag(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmDumpCharEquipment[localeView.localGmCommand],
    func = "DumpCharEquipment(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmDumpCharParty[localeView.localGmCommand],
    func = "DumpCharParty(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmDumpGameRule[localeView.localGmCommand],
    func = "DumpGameRule(%d)",
    args = {
      {instantId = 0}
    }
  },
  {
    name = gmCommandMenu.gmGoTo[localeView.localGmCommand],
    func = "GoTo(%s, %s)",
    args = {
      {target = "player"},
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmChangeMode[localeView.localGmCommand],
    func = "ChangeMode(%s, %s, %d)",
    args = {
      {target = "player"},
      {gmMode = ""},
      {val = 0}
    }
  },
  {
    name = gmCommandMenu.gmAddLaborPower[localeView.localGmCommand],
    func = "AddLaborPower(%s, %d)",
    args = {
      {target = "target"},
      {laborPower = 0}
    }
  },
  {
    name = gmCommandMenu.gmAddExp[localeView.localGmCommand],
    func = "AddExp(%s, %d)",
    args = {
      {target = "target"},
      {exp = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetExpFactor[localeView.localGmCommand],
    func = "SetExpFactor(%s, %d)",
    args = {
      {target = "target"},
      {factor = 0}
    }
  },
  {
    name = gmCommandMenu.gmAddMoney[localeView.localGmCommand],
    func = "AddMoney(%s, %d)",
    args = {
      {target = "target"},
      {money = 0}
    }
  },
  {
    name = gmCommandMenu.gmChangeNpcFriendship[localeView.localGmCommand],
    func = "ChangeNpcFriendship(%s, %d, %d)",
    args = {
      {target = "target"},
      {npcType = 0},
      {friendship = 0}
    }
  },
  {
    name = gmCommandMenu.gmReturn[localeView.localGmCommand],
    func = "Return(%s, %d)",
    args = {
      {target = "player"},
      {returnPointType = 0}
    }
  },
  {
    name = gmCommandMenu.gmGiveNewItem[localeView.localGmCommand],
    func = "GiveNewItem(%s, %d, %d)",
    args = {
      {target = "player"},
      {itemType = 0},
      {count = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetEmptyBag[localeView.localGmCommand],
    func = "SetEmptyBag(%s)",
    args = {
      {target = "player"}
    }
  },
  {
    name = gmCommandMenu.gmPlaySequence[localeView.localGmCommand],
    func = "PlaySequence(%s, %s, %d)",
    args = {
      {target = "player"},
      {seqName = ""},
      {flag = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetHousePermission[localeView.localGmCommand],
    func = "SetHousePermission(%s, %d, %d)",
    args = {
      {target = "target"},
      {houseType = 0},
      {permission = 0}
    }
  },
  {
    name = gmCommandMenu.gmUseSkill[localeView.localGmCommand],
    func = "UseSkill(%s, %d)",
    args = {
      {target = "target"},
      {skillType = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetBuff[localeView.localGmCommand],
    func = "SetBuff(%s, %d)",
    args = {
      {target = "target"},
      {buffType = 0}
    }
  },
  {
    name = gmCommandMenu.gmClearBuff[localeView.localGmCommand],
    func = "ClearBuff(%s, %d)",
    args = {
      {target = "target"},
      {buffType = 0}
    }
  },
  {
    name = gmCommandMenu.gmClearBuffs[localeView.localGmCommand],
    func = "ClearBuffs(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmSetInvisible[localeView.localGmCommand],
    func = "SetInvisible(%s, %s)",
    args = {
      {target = "player"},
      {invisible = true}
    }
  },
  {
    name = gmCommandMenu.gmSummon[localeView.localGmCommand],
    func = "Summon(%s, %s)",
    args = {
      {target = "player"},
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmNotice[localeView.localGmCommand],
    func = "Notice(%s)",
    args = {
      {notice = ""}
    }
  },
  {
    name = gmCommandMenu.gmKick[localeView.localGmCommand],
    func = "Kick(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmRecoverHouses[localeView.localGmCommand],
    func = "RecoverHouses()",
    args = {}
  },
  {
    name = gmCommandMenu.gmResetHouses[localeView.localGmCommand],
    func = "ResetHouses()",
    args = {}
  },
  {
    name = gmCommandMenu.gmCheckZone[localeView.localGmCommand],
    func = "CheckZone()",
    args = {}
  },
  {
    name = gmCommandMenu.gmSetCongestion[localeView.localGmCommand],
    func = "SetCongestion(%s, %s)",
    args = {
      {race = "nuian"},
      {dgree = ""}
    }
  },
  {
    name = gmCommandMenu.gmDumpIndun[localeView.localGmCommand],
    func = "DumpIndun()",
    args = {}
  },
  {
    name = gmCommandMenu.gmDebugLooting[localeView.localGmCommand],
    func = "DebugLooting(%d)",
    args = {
      {characterId = 0}
    }
  },
  {
    name = gmCommandMenu.gmResurrect[localeView.localGmCommand],
    func = "Resurrect(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmSetCrimeValue[localeView.localGmCommand],
    func = "SetCrimeValue(%s, %d)",
    args = {
      {target = "target"},
      {crimeValue = 0}
    }
  },
  {
    name = gmCommandMenu.gmRemoveAllItems[localeView.localGmCommand],
    func = "RemoveAllItems(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmEndInstantGameJoined[localeView.localGmCommand],
    func = "EndInstantGameJoined()",
    args = {}
  },
  {
    name = gmCommandMenu.gmEndInstantGame[localeView.localGmCommand],
    func = "EndInstantGame(%d)",
    args = {
      {instantId = 0}
    }
  },
  {
    name = gmCommandMenu.gmDeleteDominion[localeView.localGmCommand],
    func = "DeleteDominion(%s, %d)",
    args = {
      {target = ""},
      {zoneGroupId = 0}
    }
  },
  {
    name = gmCommandMenu.gmScheduleSiege[localeView.localGmCommand],
    func = "ScheduleSiege(%d,%d,%d,%d,%d,%d)",
    args = {
      {zoneGroupId = 0},
      {declare_min = 1},
      {warmup_min = 1},
      {siege_min = 1},
      {peace_min = 1},
      {pay_min = 1}
    }
  },
  {
    name = gmCommandMenu.gmTowerDefList[localeView.localGmCommand],
    func = "TowerDefList()",
    args = {}
  },
  {
    name = gmCommandMenu.gmTowerDefReload[localeView.localGmCommand],
    func = "TowerDefReload()",
    args = {}
  },
  {
    name = gmCommandMenu.gmTowerDefStart[localeView.localGmCommand],
    func = "TowerDefStart(%d, %d)",
    args = {
      {towerDefId = 0},
      {zoneGroupType = 0}
    }
  },
  {
    name = gmCommandMenu.gmTowerDefStop[localeView.localGmCommand],
    func = "TowerDefStop(%d, %d)",
    args = {
      {towerDefId = 0},
      {zoneGroupType = 0}
    }
  },
  {
    name = gmCommandMenu.gmAddActionPoint[localeView.localGmCommand],
    func = "AddActionPoint(%d, %d)",
    args = {
      {actionPoint = 0},
      {value = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetDoodadGrowth[localeView.localGmCommand],
    func = "SetDoodadGrowth(%d, %d)",
    args = {
      {doodadId = 0},
      {time = 0}
    }
  },
  {
    name = gmCommandMenu.gmWorldGoTo[localeView.localGmCommand],
    func = "WorldGoTo(%d, %d, %d)",
    args = {
      {x = 0},
      {y = 0},
      {z = 0}
    }
  },
  {
    name = gmCommandMenu.gmFreeze[localeView.localGmCommand],
    func = "Freeze(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmUnFreeze[localeView.localGmCommand],
    func = "UnFreeze(%s)",
    args = {
      {name = ""}
    }
  },
  {
    name = gmCommandMenu.gmResendHouseTaxMail[localeView.localGmCommand],
    func = "ResendHouseTaxMail(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmDelayTaxDueDate[localeView.localGmCommand],
    func = "DelayTaxDueDate(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmRecoverDoodad[localeView.localGmCommand],
    func = "RecoverDoodad(%d)",
    args = {
      {doodadId = 0}
    }
  },
  {
    name = gmCommandMenu.gmDemolishHouse[localeView.localGmCommand],
    func = "DemolishHouse(%s)",
    args = {
      {target = "target"}
    }
  },
  {
    name = gmCommandMenu.gmUpdateLeadershipPoint[localeView.localGmCommand],
    func = "UpdateLeadership(%d)",
    args = {
      {offset = "offset"}
    }
  },
  {
    name = gmCommandMenu.gmUpdateHeroScore[localeView.localGmCommand],
    func = "UpdateHeroScore(%d)",
    args = {
      {offset = "offset"}
    }
  },
  {
    name = gmCommandMenu.gmDumpInstantGame[localeView.localGmCommand],
    func = "DumpInstantGame(0)",
    args = {}
  },
  {
    name = gmCommandMenu.gmInfoInstantApplier[localeView.localGmCommand],
    func = "InfoInstantApplier(%d)",
    args = {
      {battleFieldType = 0}
    }
  },
  {
    name = gmCommandMenu.gmInfoInstantField[localeView.localGmCommand],
    func = "InfoInstantField(%d,%d)",
    args = {
      {zoneId = 0},
      {instanceId = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetInstantExclusive[localeView.localGmCommand],
    func = "SetInstantExclusive(%d,%d)",
    args = {
      {instanceId = 0},
      {battleFieldType = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetBattleRecordRating[localeView.localGmCommand],
    func = "SetBattleRecordRating(%s,%d,%d)",
    args = {
      {target = "target"},
      {battleFieldType = 0},
      {eloRating = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetInstantGmEventMode[localeView.localGmCommand],
    func = "SetInstantGmEventMode(%s)",
    args = {
      {mode = false}
    }
  },
  {
    name = gmCommandMenu.gmDumpInstantGameGmEvent[localeView.localGmCommand],
    func = "DumpInstantGame(1)",
    args = {}
  },
  {
    name = gmCommandMenu.gmApplyInstantGameGmEvent[localeView.localGmCommand],
    func = "ApplyInstantGameGmEvent(%s,%d,%d)",
    args = {
      {name = ""},
      {battleFieldType = 0},
      {corps = 0}
    }
  },
  {
    name = gmCommandMenu.gmSetTradeStatus[localeView.localGmCommand],
    func = "SetTradeStatus(%s)",
    args = {
      {status = true}
    }
  },
  {
    name = gmCommandMenu.gmShowTradeStatus[localeView.localGmCommand],
    func = "ShowTradeStatus()",
    args = {}
  }
}
gmManagementLayout = {
  {
    name = gmCommandMenu.gmGoTo[localeView.localGmCommand],
    pos = {
      0,
      55,
      112,
      40
    },
    func = "GoTo('player', '%s')"
  },
  {
    name = gmCommandMenu.gmSummon[localeView.localGmCommand],
    pos = {
      120,
      55,
      112,
      40
    },
    func = "Summon('player', '%s')"
  },
  {
    name = gmCommandMenu.gmKick[localeView.localGmCommand],
    pos = {
      240,
      55,
      112,
      40
    },
    func = "Kick('%s')"
  },
  {
    name = gmCommandMenu.gmMoveCharRezPoint[localeView.localGmCommand],
    pos = {
      360,
      55,
      112,
      40
    },
    func = "MoveCharRezPoint('%s')"
  },
  {
    name = gmCommandMenu.gmDumpCharBag[localeView.localGmCommand],
    pos = {
      0,
      100,
      112,
      40
    },
    func = "DumpCharBag('%s')"
  },
  {
    name = gmCommandMenu.gmDumpCharBank[localeView.localGmCommand],
    pos = {
      120,
      100,
      112,
      40
    },
    func = "DumpCharBank('%s')"
  },
  {
    name = gmCommandMenu.gmDumpChar[localeView.localGmCommand],
    pos = {
      240,
      100,
      112,
      40
    },
    func = "DumpChar('%s')"
  },
  {
    name = gmCommandMenu.gmDumpCharQuests[localeView.localGmCommand],
    pos = {
      360,
      100,
      112,
      40
    },
    func = "DumpCharQuests('%s')"
  },
  {
    name = gmCommandMenu.gmDumpCharParty[localeView.localGmCommand],
    pos = {
      0,
      145,
      112,
      40
    },
    func = "DumpCharParty('%s')"
  },
  {
    name = gmCommandMenu.gmBlockChat[localeView.localGmCommand],
    pos = {
      120,
      145,
      112,
      40
    }
  },
  {
    name = gmCommandMenu.gmDumpCharEquipment[localeView.localGmCommand],
    pos = {
      240,
      145,
      112,
      40
    },
    func = "DumpCharEquipment('%s')"
  },
  {
    name = gmCommandMenu.gmRemoveSlave[localeView.localGmCommand],
    pos = {
      360,
      145,
      112,
      40
    },
    func = "RemoveSlave('target')"
  },
  {
    name = gmCommandMenu.gmReturnNpc[localeView.localGmCommand],
    pos = {
      0,
      190,
      112,
      40
    },
    func = "ReturnNpc('target')"
  },
  {
    name = gmCommandMenu.gmCheckBotPlayer[localeView.localGmCommand],
    pos = {
      120,
      190,
      112,
      40
    },
    func = "CheckBotPlayer('%s')"
  },
  {
    name = gmCommandMenu.gmOneAndOneChat[localeView.localGmCommand],
    pos = {
      240,
      190,
      112,
      40
    },
    func = "GmOneAndOneChat('%s')"
  }
}
gmMenuLayout = {
  {
    name = gmCommandMenu.gmSetInvisible[localeView.localGmCommand],
    pos = {
      0,
      10,
      112,
      40
    },
    func = "SetInvisible('player', true)"
  },
  {
    name = gmCommandMenu.gmSetInvincible[localeView.localGmCommand],
    pos = {
      120,
      10,
      112,
      40
    },
    func = "ChangeMode('player', 'invincible', 1)"
  },
  {
    name = gmCommandMenu.gmBlockWhisper[localeView.localGmCommand],
    pos = {
      240,
      10,
      112,
      40
    }
  },
  {
    name = gmCommandMenu.gmAlmighty[localeView.localGmCommand],
    pos = {
      360,
      10,
      112,
      40
    },
    func = "ChangeMode('player', 'almighty', 1)",
    func2 = "ChangeMode('player', 'zone_permission', 1)"
  },
  {
    name = gmCommandMenu.gmSetUnInvisible[localeView.localGmCommand],
    pos = {
      0,
      55,
      112,
      40
    },
    func = "SetInvisible('player', false)"
  },
  {
    name = gmCommandMenu.gmSetUnInvincible[localeView.localGmCommand],
    pos = {
      120,
      55,
      112,
      40
    },
    func = "ChangeMode('player', 'invincible', 0)"
  },
  {
    name = gmCommandMenu.gmAllowWhisper[localeView.localGmCommand],
    pos = {
      240,
      55,
      112,
      40
    }
  },
  {
    name = gmCommandMenu.gmUnAlmighty[localeView.localGmCommand],
    pos = {
      360,
      55,
      112,
      40
    },
    func = "ChangeMode('player', 'almighty', 0)",
    func2 = "ChangeMode('player', 'zone_permission', 0)"
  }
}
local cursorType = {
  DIAGONAL1 = "ui/cursor/diagonal_cursor_1.dds",
  DIAGONAL2 = "ui/cursor/diagonal_cursor_2.dds",
  VERTICAL = "ui/cursor/vertical_cursor.dds",
  HORIZONTAL = "ui/cursor/horizen_cursor.dds"
}
local getTableSize = function(t)
  local size = 0
  for _, _ in pairs(t) do
    size = size + 1
  end
  return size
end
local GetItemAt = function(t, index)
  for idx, v in ipairs(t) do
    if idx == index then
      return next(v)
    end
  end
  return 0, 0
end
local SetItemAt = function(cmdIdx, argIdx, val)
  for idx, v in ipairs(gmFuncs[cmdIdx].args) do
    if idx == argIdx then
      local k, _ = next(v)
      gmFuncs[cmdIdx].args[idx][k] = val
    end
  end
end
local FindGmFuncIndex = function(name)
  for idx, v in ipairs(gmFuncs) do
    if v.name == name then
      return idx
    end
  end
  return -1
end
local PairsByKeys = function(t, f)
  local a = {}
  for n in pairs(t) do
    table.insert(a, n)
  end
  if f then
    table.sort(a, function(a, b)
      return f(t, a, b)
    end)
  else
    table.sort(a)
  end
  local i = 0
  local function iter()
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end
local function RunAllTree(subTable)
  for k, v in PairsByKeys(subTable) do
    if type(v) == "string" then
      Console:ExecuteString(v)
    elseif type(v) == "function" then
      v()
    elseif type(v) == "table" then
      RunAllTree(v)
    end
  end
end
local function Parse_CmdSubTree(name, subTable, parent)
  local childrenWindow = CreateEmptyWindow(name .. "Window", parent)
  local childrenCount = #subTable
  childrenWindow:SetExtent(200, childrenCount * 26)
  childrenWindow:Show(false)
  childrenWindow.subWindows = {}
  local idx = 0
  for k, v in PairsByKeys(subTable) do
    do
      local newLeafButton = CreateEmptyButton(name .. idx + 1, childrenWindow)
      newLeafButton.style:SetAlign(ALIGN_RIGHT)
      newLeafButton:AddAnchor("TOP", childrenWindow, 0, (idx - 1) * 25 + 40)
      ApplyButtonSkin(newLeafButton, BUTTON_BASIC.DEFAULT)
      newLeafButton:SetExtent(200, 30)
      newLeafButton:SetInset(0, 0, 20, 0)
      newLeafButton:RegisterForClicks("RightButton")
      if type(v) == "string" or type(v) == "function" then
        if type(k) == "number" then
          newLeafButton:SetText(v)
        else
          newLeafButton:SetText(k)
        end
        function newLeafButton:OnClick(arg)
          if arg == "LeftButton" then
            if type(v) == "string" then
              Console:ExecuteString(v)
            elseif type(v) == "function" then
              v()
            end
          end
        end
        newLeafButton:SetHandler("OnClick", newLeafButton.OnClick)
      elseif type(v) == "table" then
        do
          local subChildWindow = Parse_CmdSubTree(name .. idx + 1, v, parent)
          newLeafButton:SetText(k .. " >")
          subChildWindow:AddAnchor("TOPLEFT", newLeafButton, "TOPRIGHT", -10, -15)
          childrenWindow.subWindows[k] = subChildWindow
          childrenWindow.v = v
          function newLeafButton:OnClick(arg)
            if arg == "LeftButton" then
              self.OnEnter()
            elseif arg == "RightButton" then
              RunAllTree(v)
            end
          end
          newLeafButton:SetHandler("OnClick", newLeafButton.OnClick)
          function newLeafButton:OnEnter(arg)
            local setVisibleValue = not subChildWindow:IsVisible()
            HidePopUpWindow(childrenWindow)
            subChildWindow:Show(setVisibleValue)
            subChildWindow:Raise()
          end
          newLeafButton:SetHandler("OnEnter", newLeafButton.OnEnter)
        end
      end
      idx = idx + 1
    end
  end
  return childrenWindow
end
local function CreateGmMessageBox()
  local msgBox = {}
  local window = CreateWindow("gmMsgBox.window", "UIParent")
  window:Show(false)
  window:SetExtent(POPUP_WINDOW_WIDTH, 120)
  window:AddAnchor("TOP", "UIParent", 0, 200)
  window:SetUILayer("dialog")
  msgBox.window = window
  local label = window:CreateChildWidget("label", "label", 0, true)
  label:Show(true)
  label:AddAnchor("TOPLEFT", window, 0, 55)
  label:SetExtent(100, 32)
  label.style:SetAlign(ALIGN_RIGHT)
  label.style:SetSnap(true)
  label.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(label, FONT_COLOR.DEFAULT)
  msgBox.label = label
  local editbox = W_CTRL.CreateEdit("editbox", window)
  editbox:SetExtent(200, 32)
  editbox:AddAnchor("LEFT", label, "RIGHT", 5, 0)
  editbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  msgBox.editbox = editbox
  msgBox.args = {}
  function editbox:OnEnterPressed()
    local gmFunc = gmFuncs[msgBox.cmdIndex]
    local _, v = GetItemAt(gmFunc.args, msgBox.argIndex)
    local item = editbox:GetText()
    local itemVal = item
    if type(v) == "string" then
      item = "\"" .. item .. "\""
    elseif type(v) == "number" then
      item = tonumber(item)
      itemVal = item
    elseif type(v) == "boolean" then
      if item == "true" or item == "t" then
        item = "true"
        itemVal = true
      else
        item = "false"
        itemVal = false
      end
    end
    SetItemAt(msgBox.cmdIndex, msgBox.argIndex, itemVal)
    table.insert(msgBox.args, item)
    msgBox.argIndex = msgBox.argIndex + 1
    msgBox:AskArgument()
  end
  function editbox:OnEscapePressed()
    window:Show(false)
  end
  editbox:SetHandler("OnEnterPressed", editbox.OnEnterPressed)
  editbox:SetHandler("OnEscapePressed", editbox.OnEscapePressed)
  window:Show(false)
  function msgBox:StartGmCommand(cmdIndex)
    msgBox.argIndex = 1
    msgBox.cmdIndex = cmdIndex
    msgBox:AskArgument()
    msgBox.args = {}
  end
  function msgBox:AskArgument()
    local gmFunc = gmFuncs[msgBox.cmdIndex]
    local count = getTableSize(gmFunc.args)
    if count < msgBox.argIndex then
      local cmdText = "X2Gm:" .. string.format(gmFunc.func, msgBox.args[1], msgBox.args[2], msgBox.args[3], msgBox.args[4], msgBox.args[5], msgBox.args[6])
      gmCommandEdit:AddHistoryLine(cmdText)
      loadstring(cmdText)()
      gmConsole:ScrollToBottom()
      window:Show(false)
      table.remove(msgBox.args)
      return
    end
    window.titleBar:SetTitleText(gmFunc.name)
    local k, v = GetItemAt(gmFunc.args, msgBox.argIndex)
    label:SetText(tostring(k) .. ":")
    editbox:SetText(tostring(v))
    window:Show(true)
  end
  return msgBox
end
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
gmMsgBox = CreateGmMessageBox()
local function StartGmCommand(name)
  local k = FindGmFuncIndex(name)
  gmMsgBox:StartGmCommand(k)
end
gmWindow = CreateWindow("gmWindow", "UIParent")
gmWindow:SetExtent(510, 530)
gmWindow:AddAnchor("TOP", "UIParent", "TOP", 0, 0)
gmWindow:SetCloseOnEscape(true)
local tab = gmWindow:CreateChildWidget("tab", "tab", 0, true)
tab:AddAnchor("TOPLEFT", gmWindow, sideMargin, titleMargin)
tab:AddAnchor("BOTTOMRIGHT", gmWindow, -sideMargin, -sideMargin)
tab:SetCorner("TOPLEFT")
local tabTexts = {
  "Manage",
  "Macro",
  "Menu",
  "All",
  "Chat"
}
for i = 1, #tabTexts do
  tab:AddSimpleTab(tabTexts[i])
end
for i = 1, #tab.window do
  ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
  ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
end
tab:SetGap(1)
DrawTabSkin(tab, tab.window[1], tab.selectedButton[1])
local searchEdit = W_CTRL.CreateEdit("searchEdit", gmWindow.tab.window[1])
searchEdit:SetExtent(200, 32)
searchEdit:AddAnchor("TOP", gmWindow.tab.window[1], 0, 10)
searchEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
for k, v in PairsByKeys(gmManagementLayout) do
  do
    local button = gmWindow.tab.window[1]:CreateChildWidget("button", "gmManageButton", k, true)
    ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
    button:SetExtent(v.pos[3], v.pos[4])
    button.style:SetAlign(ALIGN_CENTER)
    button:AddAnchor("TOPLEFT", gmWindow.tab.window[1], v.pos[1], v.pos[2])
    button:SetText(v.name)
    function button:OnClick(arg)
      if arg == "LeftButton" and v.func ~= nil then
        local cmdText = string.format(v.func, searchEdit:GetText() or "")
        cmdText = "X2Gm:" .. cmdText
        loadstring(cmdText)()
      end
    end
    button:SetHandler("OnClick", button.OnClick)
  end
end
gmConsole = UIParent:CreateWidget("message", "gmConsole", gmWindow)
gmConsole:SetMaxLines(100)
gmConsole.style:SetAlign(ALIGN_LEFT)
gmConsole.style:SetSnap(true)
gmConsole.style:SetShadow(true)
gmConsole.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
gmConsole:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
gmConsole:SetTimeVisible(3000)
gmConsole:Show(true)
gmConsole:SetResizingBorderSize(10, 10, 10, 10)
gmConsole:SetMinResizingExtent(150, 50)
gmConsole:SetMaxResizingExtent(700, 600)
gmConsole:SetExtent(510, 300)
gmConsole:AddAnchor("BOTTOMLEFT", "UIParent", 5, -250)
gmConsole:UseResizing(true)
local consoleBg = gmConsole:CreateColorDrawable(0, 0, 0, 0.5, "background")
consoleBg:SetVisible(true)
consoleBg:AddAnchor("TOPLEFT", gmConsole, 0, 0)
consoleBg:AddAnchor("BOTTOMRIGHT", gmConsole, 0, 0)
gmCommandEdit = W_CTRL.CreateEdit("gmCommandEdit", gmConsole)
gmCommandEdit:SetInset(5, 9, 25, 8)
gmCommandEdit:SetExtent(400, 22)
gmCommandEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
gmCommandEdit:AddAnchor("TOPLEFT", gmConsole, "BOTTOMLEFT", 0, 1)
gmCommandEdit:AddAnchor("TOPRIGHT", gmConsole, "BOTTOMRIGHT", 0, 1)
gmCommandEdit:ClearTextOnEnter(true)
gmCommandEdit:SetHistoryLines(50)
gmCommandEdit.bg:SetColor(1, 1, 1, 0.8)
local button = CreateEmptyButton("consoleButton", gmCommandEdit)
ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
button:SetExtent(100, 30)
button.style:SetAlign(ALIGN_CENTER)
button:SetInset(12, 5, 5, 7)
button:AddAnchor("LEFT", gmCommandEdit, "RIGHT", 2, 0)
button:SetText("Console")
local isConsole = true
function button:OnClick(arg)
  if arg == "LeftButton" then
    isConsole = not isConsole
    if isConsole then
      self:SetText("Console")
    else
      self:SetText("GM")
    end
  end
end
button:SetHandler("OnClick", button.OnClick)
button = CreateEmptyButton("showConsoleButton", gmConsole)
ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
button:SetExtent(100, 30)
button.style:SetAlign(ALIGN_CENTER)
button:SetInset(12, 5, 5, 7)
button:AddAnchor("BOTTOMLEFT", gmConsole, "BOTTOMRIGHT", 2, 0)
button:SetText("Show Console")
local showConsole = false
function button:OnClick(arg)
  if arg == "LeftButton" then
    if showConsole then
      self:SetText("Show Console")
    else
      self:SetText("Hide Console")
    end
    showConsole = not showConsole
  end
end
button:SetHandler("OnClick", button.OnClick)
local ToggleGmConsole = function()
  local isShow = not gmWindow:IsVisible()
  gmWindow:Show(isShow)
  if isShow then
    gmCommandEdit:SetFocus()
  end
end
function gmWindow:OnEvent(event, logType, log)
  if event == "WRITE_GM_CONSOLE" then
    local msg
    if logType == "warning" then
      msg = "|cFFFFFF00" .. log
    elseif logType == "error" then
      msg = "|cFFFC291F" .. log
    else
      msg = log
    end
    msg = string.format("[%s] %s", os.date("%m/%d/%y %H:%M:%S"), msg)
    gmConsole:AddMessage(msg)
    gmConsole:ScrollToBottom()
  elseif event == "TOGGLE_GM_CONSOLE" then
    ToggleGmConsole()
    gmCommandEdit:ClearFocus()
  elseif event == "CONSOLE_WRITE" and showConsole then
    logType = string.gsub(logType, "$6", "|cFFFFFF00")
    logType = string.gsub(logType, "$8", "|cFFFFC80E")
    logType = string.gsub(logType, "$4", "|cFFFF0000")
    gmConsole:AddMessage(logType)
  end
end
gmWindow:SetHandler("OnEvent", gmWindow.OnEvent)
gmWindow:RegisterEvent("WRITE_GM_CONSOLE")
gmWindow:RegisterEvent("TOGGLE_GM_CONSOLE")
gmWindow:RegisterEvent("CONSOLE_WRITE")
local OnWheelUp = function()
  gmConsole:ScrollUp()
end
gmConsole:SetHandler("OnWheelUp", OnWheelUp)
local OnWheelDown = function()
  gmConsole:ScrollDown()
end
gmConsole:SetHandler("OnWheelDown", OnWheelDown)
local function OnEnterPressed()
  local cmdText = gmCommandEdit:GetText()
  gmCommandEdit:AddHistoryLine(cmdText)
  if cmdText == "ui_reload" then
    gmConsole:AddMessage(FONT_COLOR_HEX.RED .. "Cannot ui_reload on GmWindow!")
    return
  end
  if isConsole then
    X2Gm:ExecuteConsoleCommand(cmdText)
  else
    loadstring(cmdText)()
  end
  gmConsole:ScrollToBottom()
end
gmCommandEdit:SetHandler("OnEnterPressed", OnEnterPressed)
local OnEscapePressed = function()
  gmCommandEdit:ClearFocus()
end
gmCommandEdit:SetHandler("OnEscapePressed", OnEscapePressed)
gmCommandEdit.lastInputTxt = ""
gmCommandEdit.lastInputIdx = 0
local cmdList = X2Gm:ConsoleCommandList()
local function OnKeyDown(self, arg)
  if arg == "pageup" then
    gmConsole:ScrollUp()
  end
  if arg == "pagedown" then
    gmConsole:ScrollDown()
  end
  if isConsole then
    local inputTxt = gmCommandEdit:GetText() or ""
    if string.len(inputTxt) < 1 or arg ~= "tab" then
      gmCommandEdit.lastInputTxt = ""
      gmCommandEdit.lastInputIdx = 0
      return
    end
    if gmCommandEdit.lastInputTxt == "" or string.find(inputTxt, gmCommandEdit.lastInputTxt) ~= 1 then
      gmCommandEdit.lastInputTxt = inputTxt
      gmCommandEdit.lastInputIdx = 0
    end
    gmCommandEdit.lastInputIdx = gmCommandEdit.lastInputIdx + 1
    local completedList = {}
    for _, v in ipairs(cmdList) do
      local found = string.find(v, gmCommandEdit.lastInputTxt)
      if found == 1 then
        table.insert(completedList, v)
      end
    end
    local titleWord = FONT_COLOR_HEX.MUSTARD_YELLOW .. gmCommandEdit.lastInputTxt .. FONT_COLOR_HEX.GREEN
    if table.getn(completedList) == 0 then
      gmConsole:AddMessage(FONT_COLOR_HEX.RED .. "No " .. titleWord .. " Auto Completions!")
      return
    end
    local Replace = function(text, target, word)
      local start, term = string.find(text, target)
      if start == nil then
        return text
      end
      local count = string.len(text)
      return string.sub(text, 1, start - 1) .. word .. string.sub(text, term + 1, count)
    end
    if gmCommandEdit.lastInputIdx > table.getn(completedList) then
      gmCommandEdit.lastInputIdx = gmCommandEdit.lastInputIdx - table.getn(completedList)
    end
    local index = 0
    local firstIndex = 1
    if gmCommandEdit.lastInputIdx > 10 then
      firstIndex = gmCommandEdit.lastInputIdx - 9
    end
    for _, v in ipairs(completedList) do
      index = index + 1
      if index == 1 and firstIndex ~= index then
        gmConsole:AddMessage(".. " .. FONT_COLOR_HEX.GREEN .. "another " .. tostring(table.getn(completedList) - 10) .. " commands founded")
      end
      if firstIndex <= index then
        local color = FONT_COLOR_HEX.GREEN
        if index == gmCommandEdit.lastInputIdx then
          color = FONT_COLOR_HEX.MUSTARD_YELLOW
        end
        gmConsole:AddMessage(color .. "- " .. Replace(v, gmCommandEdit.lastInputTxt, titleWord))
        if index > firstIndex + 9 then
          gmConsole:AddMessage(".. " .. FONT_COLOR_HEX.GREEN .. "another " .. tostring(table.getn(completedList) - 10) .. " commands founded")
          break
        end
      end
    end
    gmCommandEdit:SetText(completedList[gmCommandEdit.lastInputIdx])
  end
end
gmCommandEdit:SetHandler("OnKeyDown", OnKeyDown)
local treeTable = X2Gm:LoadBookmarks()
local macroRootButton = Parse_CmdSubTree("bookmarkTreeButton", treeTable, gmWindow.tab.window[2])
macroRootButton:AddAnchor("TOPLEFT", gmWindow.tab.window[2], 0, 0)
macroRootButton:Show(true)
local gmItemEdit = W_CTRL.CreateEdit("gmItemEdit", gmWindow.tab.window[2])
gmItemEdit:AddAnchor("TOPLEFT", gmWindow.tab.window[2], "TOPLEFT", 10, 15)
gmItemEdit:SetExtent(260, 32)
gmItemEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
gmItemEdit:SetHistoryLines(50)
gmItemEdit.waitTime = -1
function DebugTooltipInfo(tipInfo)
  if gmWindow:IsVisible() == false or gmWindow.tab.window[2]:IsVisible() == false then
    return
  end
  if tipInfo ~= nil and tipInfo.itemType ~= nil then
    gmItemEdit:SetText(string.format("%06.0f", tipInfo.itemType))
  end
end
local gmItemCountEdit = W_CTRL.CreateEdit("gmItemCountEdit", gmWindow.tab.window[2])
gmItemCountEdit:SetExtent(80, 32)
gmItemCountEdit:AddAnchor("TOPLEFT", gmItemEdit, "TOPRIGHT", 10, 0)
gmItemCountEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
gmItemCountEdit:SetText("1")
local MAX_ITEM_RESULT = 340
local gmItemResultCombo = W_CTRL.CreateComboBox("gmItemResultCombo", gmWindow.tab.window[2])
gmItemResultCombo.style:SetAlign(ALIGN_LEFT)
gmItemResultCombo.style:SetSnap(true)
gmItemResultCombo:AddAnchor("TOPLEFT", gmItemEdit, "BOTTOMLEFT", 0, 6)
gmItemResultCombo:SetWidth(MAX_ITEM_RESULT)
local gmItemCountLabel = gmWindow.tab.window[2]:CreateChildWidget("label", "gmItemCountLabel", 0, true)
gmItemCountLabel:SetAutoResize(true)
gmItemCountLabel:AddAnchor("LEFT", gmItemResultCombo, "RIGHT", 10, 0)
gmItemCountLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
gmItemCountLabel:SetText("")
ApplyTextColor(gmItemCountLabel, FONT_COLOR.GRAY)
local gmItemResultMessage = gmWindow.tab.window[2]:CreateChildWidget("message", "gmItemResultMessage", 0, true)
gmItemResultMessage.style:SetSnap(true)
gmItemResultMessage.style:SetAlign(ALIGN_LEFT)
gmItemResultMessage:ChangeTextStyle()
gmItemResultMessage:SetMaxLines(MAX_ITEM_RESULT)
gmItemResultMessage:AddAnchor("TOPLEFT", gmItemResultCombo, "BOTTOMLEFT", 0, 2)
gmItemResultMessage:SetExtent(MAX_ITEM_RESULT, 200)
gmItemResultMessage:Clickable(true)
local CreateScrollBar = function(id, parent)
  local scroll = W_CTRL.CreateScroll(id, parent)
  function scroll:SetScroll(totalLines, currentLine, pagePerMaxLines)
    local visible = pagePerMaxLines < totalLines and true or false
    self:Show(visible)
    if visible then
      local maxValue = totalLines - pagePerMaxLines
      self.vs:SetMinMaxValues(0, maxValue)
      self.vs:SetPageStep(pagePerMaxLines)
      self.vs:SetValue(currentLine, false)
      self.vs:SetValueStep(1)
      self:SetButtonMoveStep(self.vs:GetValueStep())
      self:SetWheelMoveStep(self.vs:GetValueStep())
    else
      self.vs:SetMinMaxValues(0, 0)
      self.vs:SetValueStep(0)
      self.vs:SetPageStep(0)
    end
  end
  local function OnSliderChanged(self, arg)
    parent:SetScrollPos(scroll.vs:GetValue())
  end
  scroll.vs:SetHandler("OnSliderChanged", OnSliderChanged)
  scroll.vs:SetHandler("OnMouseUp", OnSliderChanged)
  scroll.vs:SetHandler("OnMouseMove", OnSliderChanged)
  return scroll
end
local scrollBar = CreateScrollBar(gmItemResultMessage:GetId() .. ".scrollBar", gmItemResultMessage)
gmItemResultMessage.scrollBar = scrollBar
scrollBar:AddAnchor("TOPRIGHT", gmItemResultMessage, 0, 0)
scrollBar:AddAnchor("BOTTOMRIGHT", gmItemResultMessage, 0, 0)
local resultBg = gmItemResultMessage:CreateColorDrawable(0, 0, 0, 0.5, "background")
resultBg:SetVisible(true)
resultBg:AddAnchor("TOPLEFT", gmItemResultMessage, 0, 0)
resultBg:AddAnchor("BOTTOMRIGHT", gmItemResultMessage, 0, 0)
gmItemResultMessage:Show(false)
local allItems = X2Item:GetAllItems()
local gmItemCreateButton = gmWindow.tab.window[2]:CreateChildWidget("button", "gmItemCreateButton", 0, true)
ApplyButtonSkin(gmItemCreateButton, BUTTON_BASIC.DEFAULT)
gmItemCreateButton:SetExtent(80, 30)
gmItemCreateButton.style:SetAlign(ALIGN_CENTER)
gmItemCreateButton:AddAnchor("TOPLEFT", gmItemCountEdit, "TOPRIGHT", 10, 0)
gmItemCreateButton:SetText(gmUiTexts.create[localeView.localGmCommand])
gmItemCreateButton:Enable(false)
gmItemEdit.last = ""
function gmItemEdit:OnTextChanged()
  if gmItemEdit.last == gmItemEdit:GetText() then
    return
  end
  gmItemEdit.last = gmItemEdit:GetText()
  gmItemEdit.waitTime = 0
  gmItemCreateButton:Enable(false)
  gmItemResultMessage:Clear()
  gmItemResultCombo:Clear()
  gmItemCountLabel:SetText("")
end
gmItemEdit:SetHandler("OnTextChanged", gmItemEdit.OnTextChanged)
function gmItemEdit:OnUpdate(dt)
  if self.waitTime < 0 then
    return
  end
  self.waitTime = self.waitTime + dt
  local REFRESH_COOL_DOWN = 1000
  if REFRESH_COOL_DOWN < self.waitTime then
    local listDatas = {}
    local text = gmItemEdit:GetText()
    gmItemResultMessage:Clear()
    gmItemResultCombo:Clear()
    gmItemResultCombo:SetVisibleItemCount(10)
    if string.len(text) > 2 then
      local i = 1
      for name, itemType in PairsByKeys(allItems, function(t, a, b)
        return tonumber(t[b]) < tonumber(t[a]) and true or false
      end) do
        if (string.find(string.format("%06.0f", itemType), text) ~= nil or string.find(name, text) ~= nil) and i <= MAX_ITEM_RESULT then
          local itemDisp = string.format("%.0f: %s", itemType, name)
          local data = {text = itemDisp, value = itemType}
          table.insert(listDatas, data)
          gmItemResultMessage:AddMessage(itemDisp)
          i = i + 1
        end
      end
    end
    if #listDatas > 0 then
      gmItemResultMessage:Show(true)
      gmItemResultMessage:SetScrollPos(0)
      gmItemResultCombo:AppendItems(listDatas)
      gmItemCreateButton:Enable(true)
      scrollBar:SetScroll(gmItemResultMessage:GetMessageLines(), 0, gmItemResultMessage:GetPagePerMaxLines())
      gmItemCountLabel:SetText(tostring(#listDatas) .. (#listDatas >= MAX_ITEM_RESULT and "+ items founded" or " items founded"))
    else
      gmItemCountLabel:SetText("item not found")
      gmItemResultMessage:Show(false)
    end
    self.waitTime = -1
  end
end
gmItemEdit:SetHandler("OnUpdate", gmItemEdit.OnUpdate)
function gmItemCreateButton:OnClick(arg)
  local info = gmItemResultCombo:GetSelectedInfo()
  if info == nil then
    return
  end
  local itemType = info.value
  local count = tonumber(gmItemCountEdit:GetText()) or 0
  if itemType ~= nil then
    X2Gm:GiveNewItem("player", itemType, count)
  end
end
gmItemCreateButton:SetHandler("OnClick", gmItemCreateButton.OnClick)
for k, v in PairsByKeys(gmMenuLayout) do
  do
    local button = gmWindow.tab.window[3]:CreateChildWidget("button", "gmMenuButton", k, true)
    ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
    button:SetExtent(v.pos[3], v.pos[4])
    button.style:SetAlign(ALIGN_CENTER)
    button:AddAnchor("TOPLEFT", gmWindow.tab.window[3], v.pos[1], v.pos[2])
    button:SetText(v.name)
    function button:OnClick(arg)
      if arg == "LeftButton" then
        if v.func ~= nil then
          local cmdText = "X2Gm:" .. v.func
          loadstring(cmdText)()
        end
        if v.func2 ~= nil then
          local cmdText = "X2Gm:" .. v.func2
          loadstring(cmdText)()
        end
      end
    end
    button:SetHandler("OnClick", button.OnClick)
  end
end
local xLen = 0
local yLen = 10
for k, v in PairsByKeys(gmFuncs) do
  do
    local button = gmWindow.tab.window[4]:CreateChildWidget("button", "gmFuncsButton", k, true)
    ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
    local tLen = string.len(v.name) * 6
    button:SetExtent(tLen, 28)
    button.style:SetAlign(ALIGN_CENTER)
    button:AddAnchor("TOPLEFT", gmWindow.tab.window[4], xLen, yLen)
    button:SetText(v.name)
    xLen = xLen + tLen
    if xLen > gmWindow.tab.window[4]:GetWidth() then
      xLen = 0
      yLen = yLen + 28
    end
    function button:OnClick(arg)
      if arg == "LeftButton" then
        gmMsgBox:StartGmCommand(k)
      end
    end
    button:SetHandler("OnClick", button.OnClick)
  end
end
local CreateGmBag = function(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:SetExtent(1000, 550)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetSounds("dialog_common")
  window:SetCloseOnEscape(true)
  SetttingUIAnimation(window)
  local titleBar = CreateTitleBar(id .. ".titleBar", window)
  titleBar:SetTitleText("")
  ApplyTitleFontColor(titleBar, FONT_COLOR.DEFAULT)
  ApplyButtonSkin(titleBar.closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  titleBar.closeButton:RemoveAllAnchors()
  titleBar.closeButton:AddAnchor("TOPRIGHT", titleBar, -26, 5)
  window.titleBar = titleBar
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "setting_popup_window", "background")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  function window:SetTitle(title)
    self.titleBar:SetTitleText(title)
  end
  return window
end
local widget = CreateGmBag("gmBag", "UIParent")
widget:AddAnchor("CENTER", "UIParent", 0, 0)
local btns = {}
local itemTypeLabel = W_CTRL.CreateLabel("gmBagitemTypeLabel", widget)
itemTypeLabel:SetExtent(100, 13)
itemTypeLabel:AddAnchor("TOPLEFT", widget, 50, 50)
itemTypeLabel:SetText("")
itemTypeLabel.style:SetAlign(ALIGN_LEFT)
itemTypeLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
for x = 0, 149 do
  local button = CreateItemIconButton("item" .. "[" .. x .. "]", widget)
  button:Show(false)
  local offsetX = x % 10 * (ICON_SIZE.DEFAULT + 3) + 30 + math.floor(x / 100) * 490
  local offsetY = math.floor(x / 10) % 10 * (ICON_SIZE.DEFAULT + 3) + 70
  button:AddAnchor("TOPLEFT", widget, offsetX, offsetY)
  function button:procOnEnter()
    itemTypeLabel:SetText(string.format("ItemType: %d / ItemId: %s", self.itemType, self.itemId))
  end
  local slotIndexLabel = W_CTRL.CreateLabel("gmBagSlotIndexLabel" .. tostring(x), button)
  slotIndexLabel:SetExtent(0, 13)
  slotIndexLabel:AddAnchor("CENTER", button, 0, 0)
  slotIndexLabel:SetText("")
  slotIndexLabel.style:SetAlign(ALIGN_CENTER)
  slotIndexLabel.style:SetFont("actionBar", 13)
  slotIndexLabel.style:SetShadow(true)
  ApplyTextColor(slotIndexLabel, FONT_COLOR.RED)
  button.slotIndex = slotIndexLabel
  btns[x] = button
end
local itemCount = 0
function widget:OnEvent(event, cmd, arg1, arg2, arg3, arg4)
  if event == "GM_SEARCHED_BAG_INFO" then
    if cmd == "clear" then
      for x = 0, 149 do
        btns[x]:Init()
        btns[x]:Show(false)
        btns[x].slotIndex:SetText("")
      end
      itemCount = 0
    elseif cmd == "add" then
      local addCmdInfo = arg1
      local slotIdx = addCmdInfo.slotIdx
      local itemInfo = X2Item:GetItemInfoByType(addCmdInfo.itemType)
      if itemInfo ~= nil and itemInfo.path ~= nil then
        itemInfo.itemGrade = addCmdInfo.itemGrade
        btns[slotIdx]:SetItemInfo(itemInfo)
        btns[slotIdx]:SetStack(addCmdInfo.stackSize)
        btns[slotIdx]:Show(true)
        btns[slotIdx].itemType = addCmdInfo.itemType
        btns[slotIdx].itemId = addCmdInfo.itemId
        btns[slotIdx].slotIndex:SetText(tostring(slotIdx))
      end
      widget:Show(true)
    elseif cmd == "type" then
      widget:SetTitle(arg2 .. "' " .. arg1)
    end
  elseif event == "GM_SEARCH_CHARACTER" then
    gmWindow:Show(true)
    gmWindow.tab.SelectTab(1)
    searchEdit:SetText(cmd)
  end
end
widget:SetHandler("OnEvent", widget.OnEvent)
widget:RegisterEvent("GM_SEARCHED_BAG_INFO")
widget:RegisterEvent("GM_SEARCH_CHARACTER")
local chatWindow = gmWindow.tab.window[5]
local types = {
  "chat",
  "center",
  "all"
}
local typeDatas = {}
for i = 1, #types do
  local data = {
    text = types[i],
    value = i
  }
  table.insert(typeDatas, data)
end
local typeComboBox = W_CTRL.CreateComboBox("typeCombobox", chatWindow)
typeComboBox:AppendItems(typeDatas)
typeComboBox:SetWidth(122)
typeComboBox:AddAnchor("TOPLEFT", chatWindow, "TOPLEFT", 0, 15)
local colors = {
  "red",
  "original_dark_orange",
  "yellow_ocher",
  "bright_green",
  "bright_blue"
}
local colorDatas = {}
for i = 1, #colors do
  local data = {
    text = colors[i],
    value = i
  }
  table.insert(colorDatas, data)
end
local colorComboBox = W_CTRL.CreateComboBox("colorComboBox", chatWindow)
colorComboBox:AppendItems(colorDatas)
colorComboBox:SetWidth(200)
colorComboBox:AddAnchor("LEFT", typeComboBox, "RIGHT", 15, 0)
local noticeEdit = W_CTRL.CreateEdit("noticeEdit", chatWindow)
noticeEdit:AddAnchor("TOPLEFT", typeComboBox, "BOTTOMLEFT", 0, 20)
noticeEdit:SetExtent(450, 32)
noticeEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
noticeEdit:SetHistoryLines(50)
function noticeEdit:OnEnterPressed()
  local info = colorComboBox:GetSelectedInfo()
  if info == nil then
    return
  end
  local color = F_COLOR.GetColor(info.text, true)
  X2Gm:NoticeEx(noticeEdit:GetText(), color, typeComboBox:GetSelectedIndex())
  noticeEdit:SetText("")
end
noticeEdit:SetHandler("OnEnterPressed", noticeEdit.OnEnterPressed)
