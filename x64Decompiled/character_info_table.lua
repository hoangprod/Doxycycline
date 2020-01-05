GROUP_DEFAULTINFO = 1
GROUP_COMMUNITY = 2
GROUP_GAME_POINT = 3
GROUP_CONTENTS_POINT = 4
GROUP_COMBAT_STAT = 5
GROUP_BASE_STAT = 6
GROUP_SPEED = 7
INDEX_FACTION = 1
INDEX_HONOR_POINT = 6
INDEX_LIVING_POINT = 7
INDEX_GEAR_SCORE = 11
INDEX_LEADERSHIP_POINT = 12
INDEX_ACCUMULATED_LEADERSHIP_POINT = 13
INDEX_MELEE_DPS = 14
INDEX_RANGED_DPS = 15
INDEX_BLESS_UTHSTIN = 16
locale.character.title = {
  "attak",
  "defence",
  "recovery"
}
locale.character.subtitle = {
  "subtitle_recovery",
  "subtitle_etc"
}
baseWindowSubTitle = {
  [GROUP_DEFAULTINFO] = {},
  [GROUP_COMMUNITY] = {
    {key = "faction", category = CHARACTER_SUBTITLE_TEXT},
    {
      key = "appellation",
      category = CHARACTER_SUBTITLE_TEXT,
      createFunc = CreateAppellationLabel
    },
    {key = "family", category = CHARACTER_SUBTITLE_TEXT},
    {key = "guild", category = CHARACTER_SUBTITLE_TEXT},
    {key = "raid", category = CHARACTER_SUBTITLE_TEXT}
  },
  [GROUP_GAME_POINT] = {
    {
      key = "honor_point",
      category = COMMON_TEXT,
      createFunc = CreateHonorPointLabel
    },
    {
      key = "living_point",
      category = CHARACTER_SUBTITLE_TEXT,
      createFunc = CreateLivingPointLabel
    },
    {
      key = "crime_point",
      category = CHARACTER_SUBTITLE_TEXT,
      createFunc = CreateCrimePointTextBox
    },
    {
      key = "dishonor_point",
      category = CHARACTER_SUBTITLE_TEXT,
      createFunc = CreateDishonorPointWindow
    }
  },
  [GROUP_CONTENTS_POINT] = {
    {
      key = "jury_point",
      category = CHARACTER_SUBTITLE_TEXT,
      createFunc = CreateJuryPointLabel
    },
    {
      key = "gear_score",
      category = COMMON_TEXT,
      color = FONT_COLOR.BLUE
    },
    {
      key = "leadership_point",
      category = COMMON_TEXT,
      createFunc = CreateCurrentLeadershipPointLabel
    },
    {
      key = "last_leadership_point",
      category = COMMON_TEXT,
      createFunc = CreateLastSeasonLeadershipPointLabel
    }
  },
  [GROUP_COMBAT_STAT] = {
    {
      key = "melee_dps_inc",
      color = FONT_COLOR.BLUE
    },
    {
      key = "ranged_dps_inc",
      color = FONT_COLOR.BLUE
    },
    {
      key = "spell_dps_inc",
      color = FONT_COLOR.BLUE
    },
    {
      key = "heal_dps_inc",
      color = FONT_COLOR.BLUE
    },
    {
      key = "physical_def",
      category = CHARACTER_SUBTITLE_TEXT,
      color = FONT_COLOR.BLUE
    },
    {
      key = "spell_regist",
      category = CHARACTER_SUBTITLE_TEXT,
      color = FONT_COLOR.BLUE
    }
  },
  [GROUP_BASE_STAT] = {
    {key = "str"},
    {key = "int"},
    {key = "dex"},
    {key = "spi"},
    {key = "sta"}
  },
  [GROUP_SPEED] = {
    {
      key = "move_speed_mul"
    },
    {
      key = "casting_time_mul"
    },
    {
      key = "global_cooltime_time",
      category = CHARACTER_SUBTITLE_TEXT
    }
  }
}
INDEX_ATTACK = 1
INDEX_DEFFENCE = 2
INDEX_REGEN = 3
INDEX_MELEE_ATTACK = 1
INDEX_RANGED_ATTACK = 2
INDEX_MAGIC_ATTACK = 3
INDEX_IGNORE_ATTACK = 4
INDEX_RECOVERY_ATTACK = 5
INDEX_BLOCK_DEFENCE = 1
INDEX_MELEE_DAMAGE_DEFENCE = 2
INDEX_RANGE_DAMAGE_DEFENCE = 3
INDEX_MAGIC_DAMAGE_DEFENCE = 4
INDEX_RECOVERY_REGEN = 1
INDEX_ETC_REGEN = 2
locale.character.popupSubtitle = {
  [INDEX_ATTACK] = {
    [INDEX_MELEE_ATTACK] = {
      {
        key = "melee_speed",
        category = CHARACTER_POPUP_SUBTITLE_TEXT
      },
      {
        key = "melee_anti_miss"
      },
      {
        key = "melee_critical"
      },
      {
        key = "melee_critical_bonus"
      },
      {
        key = "backattack_melee_damage_mul"
      },
      {
        key = "melee_damage_mul"
      },
      {
        key = "melee_damage_mul_anti_npc"
      }
    },
    [INDEX_RANGED_ATTACK] = {
      {
        key = "ranged_anti_miss",
        category = CHARACTER_POPUP_SUBTITLE_TEXT
      },
      {
        key = "ranged_critical"
      },
      {
        key = "ranged_critical_bonus"
      },
      {
        key = "backattack_ranged_damage_mul"
      },
      {
        key = "ranged_damage_mul"
      },
      {
        key = "ranged_damage_mul_anti_npc"
      }
    },
    [INDEX_MAGIC_ATTACK] = {
      {
        key = "spell_anti_miss",
        category = CHARACTER_POPUP_SUBTITLE_TEXT
      },
      {
        key = "spell_critical"
      },
      {
        key = "spell_critical_bonus"
      },
      {
        key = "backattack_spell_damage_mul"
      },
      {
        key = "spell_damage_mul"
      },
      {
        key = "spell_damage_mul_anti_npc"
      }
    },
    [INDEX_IGNORE_ATTACK] = {
      {key = "bulls_eye"},
      {
        key = "ignore_shield_chance"
      },
      {
        key = "ignore_shield_bonus_mul"
      },
      {
        key = "ignore_armor"
      },
      {
        key = "magic_penetration"
      }
    },
    [INDEX_RECOVERY_ATTACK] = {
      {
        key = "heal_critical"
      },
      {
        key = "heal_critical_bonus"
      },
      {key = "heal_mul"}
    }
  },
  [INDEX_DEFFENCE] = {
    [INDEX_BLOCK_DEFENCE] = {
      {
        key = "melee_parry",
        category = CHARACTER_POPUP_SUBTITLE_TEXT
      },
      {key = "block_mul"},
      {key = "dodge_mul"},
      {
        key = "flexibility"
      },
      {
        key = "battle_resist"
      },
      {
        key = "incoming_siege_damage_mul",
        category = CHARACTER_POPUP_SUBTITLE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_damage_mul_anti_npc"
      }
    },
    [INDEX_MELEE_DAMAGE_DEFENCE] = {
      {
        key = "incoming_melee_damage_mul",
        category = CHARACTER_POPUP_SUBTITLE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_melee_damage_add",
        category = ATTRIBUTE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_melee_damage_add_anti_npc",
        category = ATTRIBUTE_TEXT,
        widgetType = "textbox"
      }
    },
    [INDEX_RANGE_DAMAGE_DEFENCE] = {
      {
        key = "incoming_ranged_damage_mul",
        category = CHARACTER_POPUP_SUBTITLE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_ranged_damage_add",
        category = ATTRIBUTE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_ranged_damage_add_anti_npc",
        category = ATTRIBUTE_TEXT,
        widgetType = "textbox"
      }
    },
    [INDEX_MAGIC_DAMAGE_DEFENCE] = {
      {
        key = "incoming_spell_damage_mul",
        category = CHARACTER_POPUP_SUBTITLE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_spell_damage_add",
        category = ATTRIBUTE_TEXT,
        widgetType = "textbox"
      },
      {
        key = "incoming_spell_damage_add_anti_npc",
        category = ATTRIBUTE_TEXT,
        widgetType = "textbox"
      }
    }
  },
  [INDEX_REGEN] = {
    [INDEX_RECOVERY_REGEN] = {
      {
        key = "health_regen"
      },
      {
        key = "persistent_health_regen"
      },
      {key = "mana_regen"},
      {
        key = "persistent_mana_regen",
        category = CHARACTER_POPUP_SUBTITLE_TEXT
      }
    },
    [INDEX_ETC_REGEN] = {
      {
        key = "incoming_heal_mul"
      },
      {key = "exp_mul"},
      {
        key = "drop_rate_mul"
      },
      {
        key = "loot_gold_mul"
      },
      {
        key = "detect_stealth_range_mul"
      }
    }
  }
}
charInfoTooltip = {
  faction = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "faction"),
  appellation = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "appellation"),
  guild = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "guild"),
  family = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "family"),
  raid = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "raid"),
  honor_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "honor_point_tip"),
  living_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "living_point_tip"),
  crime_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "crime_point"),
  dishonor_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "crime_record"),
  jury_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "jury_point"),
  gear_score = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "gear_score"),
  leadership_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "leadership_point"),
  last_leadership_point = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "last_leadership_point"),
  melee_dps_inc = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "melee_dmg"),
  ranged_dps_inc = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "ranged_dmg"),
  spell_dps_inc = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "spell_dmg"),
  heal_dps_inc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_heal_dps"),
  physical_def = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "physical_def"),
  spell_regist = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "spell_regist"),
  str = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "str"),
  int = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "int"),
  dex = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "dex"),
  spi = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "spi"),
  sta = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "sta"),
  move_speed_mul = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "move_speed"),
  casting_time_mul = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "casting_time"),
  global_cooltime_time = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TOOLTIP_TEXT, "global_cool_time"),
  melee_speed = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "melee_speed"),
  melee_anti_miss = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "melee_anti_miss"),
  melee_critical = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "melee_critical"),
  melee_critical_bonus = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "melee_critical_bonus"),
  melee_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "melee_damage_mul"),
  ranged_anti_miss = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "ranged_anti_miss"),
  ranged_critical = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "ranged_critical"),
  ranged_critical_bonus = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "ranged_critical_bonus"),
  ranged_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "ranged_damage_mul"),
  bulls_eye = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_bulls_eye"),
  spell_anti_miss = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "spell_anti_miss"),
  spell_critical = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "spell_critical"),
  spell_critical_bonus = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "spell_critical_bonus"),
  spell_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "spell_damage_mul"),
  heal_critical = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_heal_critical"),
  heal_critical_bonus = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_heal_critical_bonus"),
  heal_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooltip_heal_mul"),
  melee_parry = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "melee_parry"),
  block_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_block_rate"),
  dodge_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_dodge_rate"),
  flexibility = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_flexibility"),
  battle_resist = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_battle_resist"),
  incoming_melee_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "incoming_melee_damage_mul"),
  incoming_ranged_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "incoming_ranged_damage_mul"),
  incoming_spell_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "incoming_spell_damage_mul"),
  incoming_siege_damage_mul = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "incoming_siege_damage_mul"),
  health_regen = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "health_regen"),
  persistent_health_regen = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "persistent_health_regen"),
  mana_regen = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "mana_regen"),
  persistent_mana_regen = X2Locale:LocalizeUiText(CHARACTER_POPUP_SUBTITLE_TOOLTIP_TEXT, "persistent_mana_regen"),
  ignore_shield_chance = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_ignore_shield_chance"),
  ignore_shield_bonus_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_ignore_shield_bonus"),
  melee_damage_mul_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_melee_damage_mul_anti_npc"),
  ranged_damage_mul_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_ranged_damage_mul_anti_npc"),
  spell_damage_mul_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_spell_damage_mul_anti_npc"),
  ignore_armor = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_ignore_armor"),
  magic_penetration = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_magic_penetration"),
  backattack_melee_damage_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_backattack_melee_damage_mul"),
  backattack_ranged_damage_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_backattack_ranged_damage_mul"),
  backattack_spell_damage_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_backattack_spell_damage_mul"),
  incoming_damage_mul_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_damage_mul_anti_npc"),
  incoming_melee_damage_add_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_melee_damage_add_anti_npc"),
  incoming_ranged_damage_add_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_ranged_damage_add_anti_npc"),
  incoming_spell_damage_add_anti_npc = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_spell_damage_add_anti_npc"),
  incoming_spell_damage_add = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_spell_damage_add"),
  incoming_ranged_damage_add = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_ranged_damage_add"),
  incoming_melee_damage_add = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_melee_damage_add"),
  detect_stealth_range_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_detect_stealth_range_mul"),
  incoming_heal_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_incoming_heal_mul"),
  drop_rate_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_drop_rate_mul"),
  loot_gold_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooltip_loot_gold_mul"),
  exp_mul = X2Locale:LocalizeUiText(COMMON_TEXT, "tooptip_exp_mul")
}
function GetCharInfoTooltip(attr)
  local tooltip = charInfoTooltip[attr]
  return tooltip and tooltip or ""
end
