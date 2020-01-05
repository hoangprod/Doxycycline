local systemMessageSamples = {
  UNIT_KILL_STREAK = {
    explanation = "\236\160\132\236\158\165 \236\151\176\236\134\141\237\130\172 \235\139\172\236\132\177",
    testTargets = {
      {
        1,
        "Redshore",
        "Blueshore",
        1
      },
      {
        2,
        "Redshore",
        "Blueshore",
        2
      },
      {
        3,
        "Redshore",
        "Blueshore",
        3
      },
      {
        4,
        "Redshore",
        "Blueshore",
        1
      },
      {
        5,
        "Redshore",
        "Blueshore",
        2
      },
      {
        6,
        "Redshore",
        "Blueshore",
        3
      }
    },
    SysMessageTester = function(self, idx)
      X2BattleField:EndKillStreakSound()
      local sampleData = self.testTargets[idx]
      return MakeImgEventInfo("UNIT_KILL_STREAK", ShowKillEffect, sampleData)
    end
  },
  LEVEL_CHANGED = {
    explanation = "\236\157\188\235\176\152/\234\179\132\236\138\185\236\158\144 \235\160\136\235\178\168\236\151\133",
    testTargets = {
      {
        msg = locale.levelChanged.GetLevelText(47),
        type = "levelup"
      },
      {
        msg = string.format("%s", X2Locale:LocalizeUiText(COMMON_TEXT, "heir_levelup", tostring(76))),
        type = "heir_levelup"
      }
    },
    SysMessageTester = function(self, idx)
      local sampleData = self.testTargets[idx]
      return MakeImgEventInfo("LEVEL_CHANGED", ShowEffectMsgMessage, {sampleData})
    end
  },
  DOMINION_SIEGE_PERIOD_CHANGED = {
    explanation = "\234\179\181\236\130\172\236\164\145\236\158\133\235\139\136\235\139\164"
  },
  DOMINION_SIEGE_UPDATE_TIMER = {
    explanation = "\234\179\181\236\130\172\236\164\145\236\158\133\235\139\136\235\139\164"
  },
  DOMINION_GUARD_TOWER_STATE_NOTICE = {
    explanation = "\234\179\181\236\132\177\236\160\132 \236\164\145 \236\136\152\237\152\184\237\131\145 \236\131\129\237\153\169",
    testTargets = {
      {
        "siege_alert_guard_tower_1st_attack"
      },
      {
        "siege_alert_guard_tower_below_75"
      },
      {
        "siege_alert_guard_tower_below_50"
      },
      {
        "siege_alert_guard_tower_engravable"
      },
      {
        "siege_alert_engraving_started",
        "\235\182\136\234\189\131\235\134\128\236\157\180\235\139\168",
        "\236\182\169\236\178\173\235\130\168\235\143\132\236\149\132\236\130\176\236\139\156"
      },
      {
        "siege_alert_engraving_stopped",
        "\235\182\136\234\189\131\235\134\128\236\157\180\235\139\168",
        "\236\182\169\236\178\173\235\130\168\235\143\132\236\149\132\236\130\176\236\139\156"
      }
    },
    SysMessageTester = function(self, idx)
      if idx <= 4 then
        return MakeImgEventInfo("DOMINION_GUARD_TOWER_STATE_NOTICE", AddSiegeAlertGuardTowerMsg, self.testTargets[idx])
      else
        return MakeImgEventInfo("DOMINION_GUARD_TOWER_STATE_NOTICE", AddSiegeAlertEngravingMsg, self.testTargets[idx])
      end
      return
    end
  },
  DOMINION = {
    explanation = "\236\152\129\236\167\128 \236\132\160\237\143\172",
    testTargets = {
      {
        "\235\182\136\234\189\131\235\134\128\236\157\180\235\139\168",
        "\236\182\169\236\178\173\235\130\168\235\143\132\236\149\132\236\130\176\236\139\156"
      }
    },
    SysMessageTester = function(self, idx)
      local sampleData = X2Locale:LocalizeUiText(DOMINION, "alarm_declare", self.testTargets[idx][1], self.testTargets[idx][2])
      return MakeImgEventInfo("DOMINION", AddSiegeDeclareTerritoryMsg, {sampleData})
    end
  },
  HERO_SEASON_OFF = {
    explanation = "\236\152\129\236\155\133 \237\155\132\235\179\180 \236\132\160\236\182\156\236\157\132 \236\156\132\237\149\156 \237\134\181\236\134\148\235\160\165 \236\136\152\236\167\145 \236\153\132\235\163\140",
    testTargets = {
      {
        "HERO_SEASON_OFF",
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_season_off_announce_title"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_season_off_announce_desc")
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("HERO_SEASON_OFF", ShowHeroMessage, self.testTargets[idx])
    end
  },
  HERO_CANDIDATES_ANNOUNCED = {
    explanation = "\236\152\129\236\155\133 \237\155\132\235\179\180\236\158\144 \235\176\156\237\145\156",
    testTargets = {
      {
        "HERO_CANDIDATES_ANNOUNCED",
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidates_announce_title"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidates_announce_desc")
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("HERO_CANDIDATES_ANNOUNCED", ShowHeroMessage, self.testTargets[idx])
    end
  },
  HERO_CANDIDATE_NOTI = {
    explanation = "\235\139\185\236\139\160\236\157\128 \237\155\132\235\179\180\236\158\144\234\176\128 \235\144\152\236\151\136\236\157\140",
    testTargets = {
      {
        "HERO_CANDIDATE_NOTI",
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidate_noti_title"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidate_noti_desc")
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("HERO_CANDIDATE_NOTI", ShowHeroMessage, self.testTargets[idx])
    end
  },
  HERO_ELECTION_RESULT = {
    explanation = "\236\152\129\236\155\133 \236\132\160\236\182\156 \235\176\156\237\145\156",
    testTargets = {
      {
        "HERO_ELECTION_RESULT",
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_announce_title"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_announce_desc")
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("HERO_ELECTION_RESULT", ShowHeroMessage, self.testTargets[idx])
    end
  },
  HERO_NOTI = {
    explanation = "\236\152\129\236\155\133 \236\132\160\236\182\156 \236\182\149\237\149\152 \235\169\148\236\132\184\236\167\128",
    testTargets = {
      {
        "HERO_NOTI",
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_noti_title"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "hero_noti_desc", "\236\160\132\234\181\173\237\145\184\236\138\164\235\161\156\235\139\164\237\152\145\237\154\140")
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("HERO_NOTI", ShowHeroMessage, self.testTargets[idx])
    end
  },
  HERO_ELECTION_DAY_ALERT = {
    explanation = "\237\136\172\237\145\156\237\149\152\236\132\184\236\154\148",
    testTargets = {
      {
        "HERO_ELECTION_DAY_ALERT",
        "\235\167\164\236\155\148 \236\178\171\236\167\184 \236\163\188 \234\184\136, \237\134\160\236\154\148\236\157\188\236\157\128 \236\152\129\236\155\133 \236\132\160\234\177\176\236\157\188\236\158\133\235\139\136\235\139\164.",
        "\236\134\140\236\134\141 \236\132\184\235\160\165\236\157\152 \235\179\184\235\182\128\236\151\144\236\132\156 \237\136\172\237\145\156\236\151\144 \236\176\184\236\151\172\237\149\160 \236\136\152 \236\158\136\236\138\181\235\139\136\235\139\164. \237\136\172\237\145\156 \236\161\176\234\177\180: \235\160\136\235\178\168 30 \236\157\180\236\131\129, \237\134\181\236\134\148\235\160\165 200 \236\157\180\236\131\129"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("HERO_ELECTION_DAY_ALERT", ShowHeroMessage, self.testTargets[idx])
    end
  },
  EQUIP_SLOT_REINFORCE_SLOT_LEVEL_UP = {
    explanation = "\236\138\172\235\161\175 \235\160\136\235\178\168\236\151\133, \236\164\145\234\181\173 \235\178\132\236\160\132\236\151\144\235\167\140 \237\133\141\236\138\164\236\179\144\234\176\128 \236\158\136\236\150\180\236\132\156 \236\164\145\234\181\173 \235\178\132\236\160\132\236\156\188\235\161\156 \236\188\156\236\132\184\236\154\148!!",
    testTargets = {
      {
        GetUIText("equip_slot_reinforce_system_msg_level_up", GetSlotText(16), tostring(2)),
        TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SLOT_LEVEL_UP_TEXT,
        "slot_enchant_levelup_text",
        TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SLOT_LEVEL_UP_ICON,
        "slot_enchant_levelup"
      }
    },
    SysMessageTester = function(self, idx)
      if X2Util:GetGameProvider() ~= TENCENT then
        return
      end
      return MakeImgEventInfo("EQUIP_SLOT_REINFORCE_SLOT_LEVEL_UP", ShowEquipSlotReinforceMsg, self.testTargets[idx])
    end
  },
  EQUIP_SLOT_REINFORCE_SET_EFFECT = {
    explanation = "\236\138\172\235\161\175 \237\154\168\234\179\188 \236\132\184\237\140\133, \236\164\145\234\181\173 \235\178\132\236\160\132\236\151\144\235\167\140 \237\133\141\236\138\164\236\179\144\234\176\128 \236\158\136\236\150\180\236\132\156 \236\164\145\234\181\173 \235\178\132\236\160\132\236\156\188\235\161\156 \236\188\156\236\132\184\236\154\148!!",
    testTargets = {
      {
        GetUIText("equip_slot_reinforce_system_msg_level_up", GetAttibuteText(1), tostring(3)),
        TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SET_EFFECT_TEXT,
        "slot_enchant_set_text",
        TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SET_EFFECT_ICON,
        "slot_enchant_set"
      }
    },
    SysMessageTester = function(self, idx)
      if X2Util:GetGameProvider() ~= TENCENT then
        return
      end
      return MakeImgEventInfo("EQUIP_SLOT_REINFORCE_SET_EFFECT", ShowEquipSlotReinforceMsg, self.testTargets[idx])
    end
  },
  EQUIP_SLOT_REINFORCE_LEVEL_EFFECT = {
    explanation = "\236\138\172\235\161\175 \237\138\185\235\179\132 \237\154\168\234\179\188, \236\164\145\234\181\173 \235\178\132\236\160\132\236\151\144\235\167\140 \237\133\141\236\138\164\236\179\144\234\176\128 \236\158\136\236\150\180\236\132\156 \236\164\145\234\181\173 \235\178\132\236\160\132\236\156\188\235\161\156 \236\188\156\236\132\184\236\154\148!!",
    testTargets = {
      {
        GetUIText("equip_slot_reinforce_system_msg_change_level_effect", GetSlotText(17), tostring(4)),
        TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_LEVEL_EFFECT_TEXT,
        "slot_enchant_special_text",
        TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_LEVEL_EFFECT_ICON,
        "slot_enchant_special"
      }
    },
    SysMessageTester = function(self, idx)
      if X2Util:GetGameProvider() ~= TENCENT then
        return
      end
      return MakeImgEventInfo("EQUIP_SLOT_REINFORCE_LEVEL_EFFECT", ShowEquipSlotReinforceMsg, self.testTargets[idx])
    end
  },
  ABILITY_CHANGED = {
    explanation = "\235\138\165\235\160\165\235\179\128\234\178\189, Type02\235\138\148 \235\138\165\235\160\165\236\157\180 \235\145\144 \234\176\156 \236\158\136\236\157\132\235\149\140\235\167\140 \236\160\156\235\140\128\235\161\156 \236\158\145\235\143\153",
    testTargets = {
      {true},
      {false}
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("ABILITY_CHANGED", ShowLearnAbilityEffect, self.testTargets[idx])
    end
  },
  SHOW_ADDED_ITEM = {
    explanation = "\236\149\132\236\157\180\237\133\156 \237\154\141\235\147\157",
    testTargets = {
      {
        {
          itemGrade = 10,
          itemType = 46846,
          lookType = 46846,
          slotTypeNum = 2,
          stack = 1,
          name = "KingStrongWeapon",
          item_impl = "weapon",
          gradeColor = "FFBA976D",
          itemUsage = "equip",
          slotType = "2handed"
        },
        3
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("SHOW_ADDED_ITEM", ShowAddedItemMsg, self.testTargets[idx])
    end
  },
  COMPLETE_ACHIEVEMENT = {
    explanation = "\236\151\133\236\160\129 \235\139\172\236\132\177",
    testTargets = {
      {3762}
    },
    SysMessageTester = function(self, idx)
      local info = X2Achievement:GetAchievementInfo(self.testTargets[idx][1])
      if info == nil then
        return false
      end
      local messageInfo = MakeMessageInfo(info)
      AddAchievementMsgInfo(messageInfo)
      return MakeImgEventInfo("COMPLETE_ACHIEVEMENT", AddAchievementCompleteMsg, {messageInfo})
    end
  },
  UPDATE_TODAY_ASSIGNMENT = {
    explanation = "\236\158\132\235\172\180/\236\132\177\234\179\188 \235\139\172\236\132\177",
    testTargets = {
      {
        title = "\234\176\128\236\158\165 \236\164\145\236\154\148\237\149\156 \236\158\132\235\172\180",
        desc = "\235\130\180\236\154\169\236\157\180 \235\172\180\236\151\135\236\157\184\236\167\128\235\138\148 \236\160\128\235\143\132 \236\149\140\234\179\160 \236\139\182\236\138\181\235\139\136\235\139\164",
        iconPath = "Game\\ui\\icon\\icon_item_2183.dds",
        sort = TADT_EXPEDITION
      },
      {
        title = "\234\176\128\236\158\165 \236\164\145\236\154\148\237\149\156 \236\158\132\235\172\180",
        desc = "\235\130\180\236\154\169\236\157\180 \235\172\180\236\151\135\236\157\184\236\167\128\235\138\148 \236\160\128\235\143\132 \236\149\140\234\179\160 \236\139\182\236\138\181\235\139\136\235\139\164",
        iconPath = "Game\\ui\\icon\\icon_item_2184.dds",
        sort = TADT_FAMILY
      },
      {
        title = "\234\176\128\236\158\165 \236\164\145\236\154\148\237\149\156 \236\158\132\235\172\180",
        desc = "\235\130\180\236\154\169\236\157\180 \235\172\180\236\151\135\236\157\184\236\167\128\235\138\148 \236\160\128\235\143\132 \236\149\140\234\179\160 \236\139\182\236\138\181\235\139\136\235\139\164",
        iconPath = "Game\\ui\\icon\\icon_item_2192.dds",
        sort = TADT_HERO
      },
      {
        title = "\234\176\128\236\158\165 \236\164\145\236\154\148\237\149\156 \236\158\132\235\172\180",
        desc = "\235\130\180\236\154\169\236\157\180 \235\172\180\236\151\135\236\157\184\236\167\128\235\138\148 \236\160\128\235\143\132 \236\149\140\234\179\160 \236\139\182\236\138\181\235\139\136\235\139\164",
        iconPath = "Game\\ui\\icon\\icon_item_2193.dds",
        sort = TADT_TODAY
      }
    },
    SysMessageTester = function(self, idx)
      local messageInfo = MakeTodayAssignmetnMessageInfo(self.testTargets[idx])
      AddAchievementMsgInfo(messageInfo)
      return MakeImgEventInfo("COMPLETE_ACHIEVEMENT", AddAchievementCompleteMsg, {messageInfo})
    end
  },
  COMPLETE_CRAFT_ORDER = {
    explanation = "\236\160\156\236\158\145 \236\157\152\235\162\176 \236\153\132\235\163\140",
    testTargets = {
      {
        craftType = 10599,
        craftCount = 7,
        craftGrade = 12
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("COMPLETE_CRAFT_ORDER", ShowCraftOrderMsg, {
        self.testTargets[idx]
      })
    end
  },
  TOWER_DEFENSE_MSG = {
    explanation = "\237\131\128\236\155\140 \235\176\169\236\150\180 \235\169\148\236\132\184\236\167\128, \236\155\148\235\147\156 \235\169\148\236\132\184\236\167\128 \236\157\180\237\142\153\237\138\184",
    testTargets = {
      {
        "|cFFF84F38\236\150\180\235\148\148\236\132\160\234\176\128 \237\152\132\235\158\128\237\149\156 \235\130\152\237\140\148\236\134\140\235\166\172\236\153\128 \237\149\168\234\187\152 \237\149\152\235\138\152\236\151\144 \236\156\160\235\139\136\236\189\152\236\157\180 \235\130\152\237\131\128\235\130\172\236\138\181\235\139\136\235\139\164.",
        "|cFFF84F38\237\139\136\236\157\152\236\161\176\236\167\144",
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "sign_start"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("TOWER_DEFENSE_MSG", ShowCustomIconMeesage, self.testTargets[idx])
    end
  },
  INSTANCE_ENTERABLE_MSG = {
    explanation = "\236\160\132\236\158\165/\236\157\184\235\141\152 \236\158\133\236\158\165 \235\169\148\236\132\184\236\167\128",
    testTargets = {
      {
        "|cFFED492E\236\167\128\234\184\136\235\182\128\237\132\176 3:3 \236\160\132\236\158\165, \236\167\132\234\178\128 \235\140\128\235\130\156\237\136\172\234\176\128 \237\153\156\236\132\177\237\153\148\235\144\152\236\150\180 \236\158\133\236\158\165\237\149\152\236\139\164 \236\136\152 \236\158\136\236\138\181\235\139\136\235\139\164.",
        "|cFFED492E\236\167\132\234\178\128 \235\140\128\235\130\156\237\136\172",
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "instance_training_camp_3on3"
      },
      {
        "|cFFFF3366\236\154\148\236\166\152 |cFFFF9900\237\149\171\237\149\156 |cFFCC33FF\236\149\132\236\157\180\237\133\156\236\157\180\236\163\160? |cFFCCFF99\236\160\156\236\157\180\237\129\172 |cFF0099CC\236\154\148\236\160\149\236\158\133\235\139\136\235\139\164!|r",
        " \235\133\184\235\165\180\236\152\136\237\138\184 \235\172\180\237\149\156\235\140\128\236\160\132 ",
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "win_bugle"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("INSTANCE_ENTERABLE_MSG", ShowCustomIconMeesage, self.testTargets[idx])
    end
  },
  ZONEGROUP_STATE_WINNER = {
    explanation = "\234\177\176\236\160\144 \236\160\144\235\160\185",
    testTargets = {
      {
        string.format("|cFF97D5F9%s", GetCommonText("conquest_end_msg")),
        "|cFF97D5F9[Redshore]",
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "occupation_end"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("ZONEGROUP_STATE_WINNER", ShowCustomIconMeesage, self.testTargets[idx])
    end
  },
  NUONS_ARROW_UI_MSG = {
    explanation = "\236\139\172\237\140\144\236\157\152 \237\153\148\236\130\180",
    testTargets = {
      {
        GetUIText(COMMON_TEXT, "nuons_arrow_center_message_body", "Redshore", "\236\149\132\236\130\176\236\139\156 \237\131\149\235\182\129\235\169\180", "\235\167\136\236\157\132 \237\154\140\234\180\128"),
        GetUIText(COMMON_TEXT, "nuons_arrow_center_message_title"),
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "resident_attack"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("ZONEGROUP_STATE_WINNER", ShowCustomIconMeesage, self.testTargets[idx])
    end
  },
  DOODAD_PHASE_UI_MSG = {
    explanation = "\235\145\144\235\139\164\235\147\156 \237\142\152\236\157\180\236\166\136 \235\169\148\236\132\184\236\167\128",
    testTargets = {
      {
        string.format("%s%s", "|cFFFFFFFF", "\237\149\152\235\166\172\237\149\152\235\157\188 \236\132\184\235\160\165 \235\179\184\235\182\128\236\151\144\236\132\156 \236\151\144\236\149\132\235\130\152\235\147\156 \236\150\145\236\134\144 \235\172\180\234\184\176 \237\140\144\235\167\164\235\165\188 \236\139\156\236\158\145\237\149\169\235\139\136\235\139\164."),
        string.format("%s%s", "|cFF6dc113", "\237\145\184\235\165\184 \236\134\140\234\184\136 \236\131\129\237\154\140 \236\177\132\234\182\140 \236\131\129\236\157\184"),
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "resident_step"
      },
      {
        string.format("%s%s", "|cFFFFFFFF", "\235\176\156\236\160\132 \235\140\128\234\184\176 \236\131\129\237\131\156\235\161\156 \235\133\184\237\155\132\237\153\148\234\176\128 \236\167\132\237\150\137\235\144\169\235\139\136\235\139\164. \236\163\188\235\175\188 \234\184\176\236\151\172\235\143\132\236\151\144 \235\148\176\235\157\188 \235\136\132\236\160\129 \236\136\152\236\136\152\235\163\140 \236\160\149\236\130\176 \236\154\176\237\142\184\236\157\180 \235\176\156\236\134\161\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164."),
        string.format("%s%s", "|cFF8CCDDB", "\237\149\152\236\138\172\235\157\188 \236\163\188\235\175\188 \237\154\140\234\180\128"),
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "trader_start"
      },
      {
        string.format("%s%s", "|cFFF84F38", "\235\185\155\235\130\152\235\138\148 \237\149\180\236\149\136 \236\149\132\237\130\164\236\155\128 \236\161\176\237\149\169\235\140\128\236\157\152 \235\167\136\235\160\165\236\157\180 \235\170\168\235\145\144 \236\134\140\236\139\164\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. \235\139\164\236\157\140 \236\163\188\234\184\176\236\151\144 \235\139\164\236\139\156 \237\153\156\236\132\177\237\153\148\235\144\169\235\139\136\235\139\164."),
        string.format("%s%s", "|cFF8CCDDB", "\237\140\140\235\185\132\237\138\184\235\157\188 \236\167\132\236\152\129\236\157\152 \236\149\132\237\130\164\236\155\128 \236\161\176\237\149\169\235\140\128"),
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "purify_archium"
      },
      {
        string.format("%s%s", "|cFFFFFFFF", "\235\136\132\236\157\180\236\149\132 \236\151\176\237\149\169\236\157\152 \236\157\188\235\166\172\236\152\168 \234\184\176\236\167\128\234\176\128 \234\177\180\236\132\164\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164."),
        string.format("%s%s", "|cFF8CCDDB", "\236\157\188\235\166\172\236\152\168 \234\184\176\236\167\128"),
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        "pioneer"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("DOODAD_PHASE_UI_MSG", ShowCustomIconMeesage, self.testTargets[idx])
    end
  },
  EXPEDITION_LEVEL_UP = {
    explanation = "\236\155\144\236\160\149\235\140\128 \235\160\136\235\178\168\236\151\133",
    testTargets = {
      {
        "EXPEDITION_LEVEL_UP",
        X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_levelup_noti"),
        "412" .. X2Locale:LocalizeUiText(COMMON_TEXT, "level")
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("EXPEDITION_LEVEL_UP", ShowExpeditionLevelUpMessage, self.testTargets[idx])
    end
  },
  EXPEDITION_WAR_STATE = {
    explanation = "\236\155\144\236\160\149\235\140\128 \236\160\132\237\136\172",
    testTargets = {
      {
        "start",
        "Redshore",
        "Blueshore",
        "Orangeshore"
      },
      {
        "ongoing",
        "Redshore",
        "Blueshore",
        "Orangeshore"
      },
      {
        "win",
        "Redshore",
        "Blueshore",
        "Orangeshore"
      },
      {
        "lost",
        "Redshore",
        "Blueshore",
        "Orangeshore"
      },
      {
        "tied",
        "Redshore",
        "Blueshore",
        "Orangeshore"
      },
      {
        "result",
        "Redshore",
        "Blueshore",
        "Orangeshore"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("EXPEDITION_WAR_STATE", ExpeditionWarConditionWindowSetInfo, self.testTargets[idx])
    end
  },
  EXPEDITION_APPLICANT_ACCEPT = {
    explanation = "\236\155\144\236\160\149\235\140\128 \236\167\128\236\155\144 \236\138\185\235\130\153",
    testTargets = {
      {
        "\235\132\140\235\176\155\236\149\132\236\164\140"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("EXPEDITION_APPLICANT_ACCEPT", ShowExpeditionAcceptMessage, self.testTargets[idx])
    end
  },
  EXPEDITION_APPLICANT_REJECT = {
    explanation = "\236\155\144\236\160\149\235\140\128 \236\167\128\236\155\144 \234\177\176\236\160\136",
    testTargets = {
      {
        "\235\132\140\236\149\136\235\176\155\236\157\132\235\158\152"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("EXPEDITION_APPLICANT_REJECT", ShowExpeditionRejectMessage, self.testTargets[idx])
    end
  },
  FAMILY_LEVEL_UP = {
    explanation = "\234\176\128\236\161\177 \235\147\177\234\184\137 \236\131\129\236\138\185",
    testTargets = {
      {
        "\236\152\129\236\155\144\236\157\132 \236\149\189\236\134\141\237\149\156 \234\176\128\236\161\177"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("FAMILY_LEVEL_UP", ShowFamilyLevelUpMessage, self.testTargets[idx])
    end
  },
  LOOT_PACK_ITEM_BROADCAST = {
    explanation = "\236\131\129\236\158\144\234\185\161 \235\161\156\235\152\144 \235\139\185\236\178\168",
    testTargets = {
      {
        "Redshore",
        X2Item:GetItemLinkedTextByItemType(47259),
        X2Item:GetItemLinkedTextByItemType(47260)
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("LOOT_PACK_ITEM_BROADCAST", ShowLootPackItemBroadcastAlarmMessage, self.testTargets[idx])
    end
  },
  GRADE_ENCHANT_BROADCAST = {
    explanation = "\236\149\132\236\157\180\237\133\156 \234\176\149\237\153\148/\237\149\169\236\132\177",
    testTargets = {
      {
        "Redshore",
        IEBCT_ENCHANT_SUCCESS,
        X2Item:GetItemLinkedTextByItemType(46986),
        11,
        12
      },
      {
        "Redshore",
        IEBCT_ENCHANT_GREATE_SUCCESS,
        X2Item:GetItemLinkedTextByItemType(46986),
        10,
        12
      },
      {
        "Redshore",
        IEBCT_EVOVING,
        X2Item:GetItemLinkedTextByItemType(46986),
        12,
        12
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("GRADE_ENCHANT_BROADCAST", ShowGradeEnchantBroadcastAlarmMessage, self.testTargets[idx])
    end
  },
  SCALE_ENCHANT_BROADCAST = {
    explanation = "\236\149\132\236\157\180\237\133\156 \236\158\172\236\151\176\235\167\136",
    testTargets = {
      {
        "Redshore",
        IEBCT_ENCHANT_SUCCESS,
        X2Item:GetItemLinkedTextByItemType(44469),
        "+14",
        "+15"
      },
      {
        "Redshore",
        IEBCT_ENCHANT_GREATE_SUCCESS,
        X2Item:GetItemLinkedTextByItemType(44469),
        "+15",
        "+17"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("SCALE_ENCHANT_BROADCAST", ShowScaleEnchantBroadcastAlarmMessage, self.testTargets[idx])
    end
  },
  RANK_ALARM_MSG = {
    explanation = "\235\130\154\236\139\156\235\140\128\237\154\140 \236\149\140\235\166\188",
    testTargets = {
      {
        "\236\158\160\236\139\156\237\155\132 \236\139\160\234\184\176\235\163\168 \235\130\154\236\139\156 \235\140\128\237\154\140\234\176\128 \236\139\156\236\158\145\235\144\169\235\139\136\235\139\164."
      },
      {
        "\236\139\160\234\184\176\235\163\168 \236\132\172 \235\130\154\236\139\156\235\140\128\237\154\140\234\176\128 \236\162\133\235\163\140\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164."
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("RANK_ALARM_MSG", ShowRankingAlarmMessage, self.testTargets[idx])
    end
  },
  EVENT_SCHEDULE_START = {
    explanation = "\236\157\180\235\178\164\237\138\184 \236\139\156\236\158\145",
    testTargets = {
      {
        "\236\132\177\236\158\165 \236\167\128\236\155\144 \236\132\156\235\178\132 \237\143\137\236\157\188 \237\149\171\237\131\128\236\158\132 \235\178\132\235\139\157 \236\139\156\236\158\145!, \234\178\189\237\151\152\236\185\152, \236\160\132\235\166\172\237\146\136 \237\154\141\235\147\157\235\165\160\236\157\180 1.5\235\176\176!"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("EVENT_SCHEDULE_START", ShowDayEventAlarm, self.testTargets[idx])
    end
  },
  EVENT_SCHEDULE_STOP = {
    explanation = "\236\157\180\235\178\164\237\138\184 \236\162\133\235\163\140",
    testTargets = {
      {
        "\236\152\164\235\138\152\236\157\152 \235\178\132\235\139\157 \236\157\180\235\178\164\237\138\184\234\176\128 \236\162\133\235\163\140\235\144\152\236\151\136\236\138\181\235\139\136\235\139\164. \234\176\144\236\130\172\237\149\169\235\139\136\235\139\164."
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("EVENT_SCHEDULE_STOP", ShowDayEventAlarm, self.testTargets[idx])
    end
  },
  FACTION_RELATION_CHANGED = {
    explanation = "\236\132\184\235\160\165 \237\152\145\236\160\149 \235\169\148\236\139\156\236\167\128",
    testTargets = {
      {
        true,
        "\235\136\132\236\157\180\236\149\132 \236\151\176\237\149\169",
        "\237\149\152\235\166\172\237\149\152\235\157\188 \236\151\176\237\149\169"
      },
      {
        false,
        "\235\172\180\235\178\149\236\158\144",
        "\237\149\152\235\166\172\237\149\152\235\157\188 \236\151\176\237\149\169"
      }
    },
    SysMessageTester = function(self, idx)
      return MakeImgEventInfo("FACTION_RELATION_CHANGED", ShowFactionRelationChangeMessage, self.testTargets[idx])
    end
  }
}
function GetSystemMessageSamples()
  return systemMessageSamples
end
