MAIN_MENU_IDX = {
  CHARACTER = 1,
  BAG = 2,
  QUEST = 3,
  ASSIGNMENT = 4,
  SKILL = 5,
  MAP = 6,
  PRODUCTION = 7,
  COMMUNITY = 8,
  RANKING = 9,
  HOME = 10,
  SYSTEM = 11,
  PLAY_DIARY = 12,
  CRAFT_DIC = 13,
  MY_FARM_INFO = 14,
  EXPEDITION = 15,
  RAID_MANAGER = 16,
  FRIEND = 17,
  NATION = 18,
  WEB_MESSENGER = 19,
  WEB_WIKI = 20,
  WEB_HELP = 21,
  ADDON = 22,
  SECOND_PASSWORD = 23,
  OPTION = 24,
  SELECT_CHARACTER = 25,
  EXIT_GAME = 26,
  SPECIALTY_INFO = 27,
  TGOS = 28,
  HERO = 29,
  UI_AVI = 30,
  FAMILY = 31,
  RAID_RECRUIT = 32
}
local featureSet = X2Player:GetFeatureSet()
MAIN_MENU_INFO = {
  [MAIN_MENU_IDX.CHARACTER] = {
    enable = true,
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "character"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_CHARACTER_INFO,
    hotkey = "toggle_character",
    content = UIC_CHARACTER_INFO,
    badgeCreatable = true,
    badgeVisible = X2Equipment:DameagedItemCount(false) ~= 0,
    badgePoint = X2Equipment:DameagedItemCount(false),
    badgeColor = "red",
    updateFunc = function(widget)
      if widget.badge == nil then
        return
      end
      local count = X2Equipment:DameagedItemCount(false)
      widget.badge:Show(count ~= 0)
      widget.badge:SetText(tostring(count))
    end,
    updateEvents = {
      "UNIT_EQUIPMENT_CHANGED"
    }
  },
  [MAIN_MENU_IDX.BAG] = {
    enable = UIParent:GetPermission(UIC_BAG),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bag"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_BAG,
    hotkey = "toggle_bag",
    content = UIC_BAG,
    badgeCreatable = true,
    badgeVisible = 10 >= X2Bag:CountEmptyBagSlots() and GetOptionItemValue("ShowEmptyBagSlotCounter") == 1,
    badgePoint = X2Bag:CountEmptyBagSlots(),
    badgeColor = "red",
    updateFunc = function(widget)
      if widget.badge == nil then
        return
      end
      if GetOptionItemValue("ShowEmptyBagSlotCounter") == 0 then
        widget.badge:Show(false)
        return
      end
      local count = X2Bag:CountEmptyBagSlots()
      widget.badge:Show(count <= 10)
      widget.badge:SetText(tostring(count))
    end,
    updateEvents = {
      "BAG_UPDATE",
      "BAG_EXPANDED"
    },
    permission = function()
      return UIParent:GetPermission(UIC_BAG)
    end
  },
  [MAIN_MENU_IDX.QUEST] = {
    enable = UIParent:GetPermission(UIC_QUEST_LIST),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "quest_list"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_QUEST_LIST,
    hotkey = "toggle_quest",
    content = UIC_QUEST_LIST,
    badgePoint = nil,
    badgeColor = nil,
    permission = function()
      return UIParent:GetPermission(UIC_QUEST_LIST)
    end
  },
  [MAIN_MENU_IDX.ASSIGNMENT] = {
    enable = UIParent:GetPermission(UIC_ACHIEVEMENT),
    show = featureSet.achievement or featureSet.todayAssignment,
    text = GetCommonText("assignment_system"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_ACHIEVEMENT,
    hotkey = "toggle_achievement",
    content = UIC_ACHIEVEMENT,
    badgePoint = nil,
    badgeColor = nil,
    permission = function()
      return UIParent:GetPermission(UIC_ACHIEVEMENT)
    end
  },
  [MAIN_MENU_IDX.SKILL] = {
    enable = UIParent:GetPermission(UIC_SKILL),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "skill"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_SKILL,
    hotkey = "toggle_spellbook",
    content = UIC_SKILL,
    badgeCreatable = true,
    badgeVisible = function()
      local total, used = X2Ability:GetSkillPoint()
      local count = total - used
      return count > 0
    end,
    badgePoint = function()
      local total, used = X2Ability:GetSkillPoint()
      return total - used
    end,
    badgeColor = "blue",
    effectDrawableCoords = {
      959,
      33,
      32,
      32
    },
    updateFunc = function(widget)
      if widget.badge == nil then
        return
      end
      local total, used = X2Ability:GetSkillPoint()
      local count = total - used
      widget.badge:Show(count > 0)
      widget.badge:SetText(tostring(count))
      widget.effectDrawable:SetStartEffect(count > 0)
    end,
    updateEvents = {
      "SKILL_LEARNED",
      "SKILL_CHANGED",
      "ABILITY_CHANGED",
      "LEVEL_CHANGED",
      "SKILLS_RESET",
      "ABILITY_SET_CHANGED"
    },
    permission = function()
      return UIParent:GetPermission(UIC_SKILL)
    end
  },
  [MAIN_MENU_IDX.MAP] = {
    enable = true,
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "map"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_MAP,
    hotkey = "toggle_worldmap",
    content = UIC_WORLDMAP,
    badgePoint = nil,
    badgeColor = nil
  },
  [MAIN_MENU_IDX.PRODUCTION] = {
    enable = UIParent:GetPermission(UIC_CRAFT_BOOK) and UIParent:GetPermission(UIC_MY_FARM_INFO) and UIParent:GetPermission(UIC_SPECIALTY_INFO),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "living"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_PRODUCTION,
    hotkey = "",
    badgePoint = nil,
    badgeColor = nil,
    permission = function()
      return UIParent:GetPermission(UIC_CRAFT_BOOK) and UIParent:GetPermission(UIC_MY_FARM_INFO) and UIParent:GetPermission(UIC_SPECIALTY_INFO)
    end
  },
  [MAIN_MENU_IDX.COMMUNITY] = {
    enable = UIParent:GetPermission(UIC_FRIEND) and UIParent:GetPermission(UIC_HERO_RANK_WND) or UIParent:GetPermission(UIC_RAID_TEAM_MANAGER),
    show = true,
    text = X2Locale:LocalizeUiText(TEMP_TEXT, "text5"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_COMMUNITY,
    hotkey = "",
    badgePoint = nil,
    badgeColor = nil,
    permission = function()
      return UIParent:GetPermission(UIC_FRIEND) and UIParent:GetPermission(UIC_HERO_RANK_WND) or UIParent:GetPermission(UIC_RAID_TEAM_MANAGER)
    end
  },
  [MAIN_MENU_IDX.RANKING] = {
    enable = UIParent:GetPermission(UIC_RANK),
    show = featureSet.ranking,
    text = X2Locale:LocalizeUiText(RANKING_TEXT, "ranking"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_RANKING,
    hotkey = "toggle_ranking",
    content = UIC_RANK,
    badgePoint = nil,
    badgeColor = nil,
    permission = function()
      return UIParent:GetPermission(UIC_RANK)
    end
  },
  [MAIN_MENU_IDX.HOME] = {
    enable = UIParent:GetPermission(UIC_WEB_MESSENGER) or UIParent:GetPermission(UIC_WEB_PLAY_DIARY),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "home"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_ADDITONAL,
    hotkey = "",
    badgeCreatable = baselibLocale.useWebMessenger,
    badgeVisible = false,
    badgePoint = 0,
    badgeColor = "blue",
    effectDrawableCoords = {
      958,
      132,
      32,
      32
    },
    updateFunc = function(widget, event, count)
      if widget.badge == nil then
        return
      end
      if count ~= nil then
        widget.badge:Show(count > 0)
        widget.effectDrawable:SetStartEffect(count > 0)
        widget.badge:SetText(tostring(count))
      end
    end,
    updateEvents = {
      "SET_WEB_MESSENGE_COUNT"
    },
    permission = function()
      return UIParent:GetPermission(UIC_WEB_MESSENGER) or UIParent:GetPermission(UIC_WEB_PLAY_DIARY)
    end
  },
  [MAIN_MENU_IDX.SYSTEM] = {
    enable = true,
    show = true,
    text = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "config_menu"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_SYSTEM,
    hotkey = "open_config",
    badgeCreatable = baselibLocale.useWebInquire,
    badgeVisible = false,
    badgePoint = 0,
    badgeColor = "blue",
    updateFunc = function(widget, event, msgType, _, countStr)
      if widget.badge == nil then
        return
      end
      if msgType ~= 1 then
        return
      end
      if countStr ~= nil then
        local count = tonumber(countStr) or 0
        widget.badge:Show(count > 0)
        widget.badge:SetText(tostring(countStr))
      end
    end,
    updateEvents = {
      "SET_UI_MESSAGE"
    }
  },
  [MAIN_MENU_IDX.PLAY_DIARY] = {
    enable = baselibLocale.useWebDiary and UIParent:GetPermission(UIC_WEB_PLAY_DIARY),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "play_journal"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_ADDITONAL,
    hotkey = "toggle_web_play_diary",
    content = UIC_WEB_PLAY_DIARY,
    permission = function()
      return baselibLocale.useWebDiary and UIParent:GetPermission(UIC_WEB_PLAY_DIARY)
    end
  },
  [MAIN_MENU_IDX.CRAFT_DIC] = {
    enable = UIParent:GetPermission(UIC_CRAFT_BOOK),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "craft_dic"),
    buttonStyle = nil,
    hotkey = "toggle_craft_book",
    content = UIC_CRAFT_BOOK,
    permission = function()
      return UIParent:GetPermission(UIC_CRAFT_BOOK)
    end
  },
  [MAIN_MENU_IDX.MY_FARM_INFO] = {
    enable = UIParent:GetPermission(UIC_MY_FARM_INFO),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "farm"),
    buttonStyle = nil,
    hotkey = "toggle_common_farm_info",
    content = UIC_MY_FARM_INFO,
    permission = function()
      return UIParent:GetPermission(UIC_MY_FARM_INFO)
    end
  },
  [MAIN_MENU_IDX.RAID_MANAGER] = {
    enable = UIParent:GetPermission(UIC_RAID_TEAM_MANAGER),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "raid"),
    buttonStyle = nil,
    hotkey = "toggle_raid_team_manager",
    content = UIC_RAID_TEAM_MANAGER,
    permission = function()
      return UIParent:GetPermission(UIC_RAID_TEAM_MANAGER)
    end
  },
  [MAIN_MENU_IDX.RAID_RECRUIT] = {
    enable = UIParent:GetPermission(UIC_RAID_RECRUIT),
    show = true,
    text = X2Locale:LocalizeUiText(COMMON_TEXT, "raid_recruit_and_search"),
    buttonStyle = nil,
    hotkey = "",
    content = UIC_RAID_RECRUIT,
    permission = function()
      return UIParent:GetPermission(UIC_RAID_RECRUIT)
    end
  },
  [MAIN_MENU_IDX.FRIEND] = {
    enable = UIParent:GetPermission(UIC_FRIEND),
    show = true,
    text = GetCommonText("community"),
    buttonStyle = nil,
    hotkey = "toggle_friend",
    content = UIC_FRIEND,
    permission = function()
      return UIParent:GetPermission(UIC_FRIEND)
    end
  },
  [MAIN_MENU_IDX.WEB_MESSENGER] = {
    enable = UIParent:GetPermission(UIC_WEB_MESSENGER),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "message"),
    buttonStyle = nil,
    hotkey = "toggle_web_messenger",
    content = UIC_WEB_MESSENGER,
    permission = function()
      return UIParent:GetPermission(UIC_WEB_MESSENGER)
    end
  },
  [MAIN_MENU_IDX.WEB_WIKI] = {
    enable = baselibLocale.useWebWiki and UIParent:GetPermission(UIC_WEB_WIKI),
    show = true,
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "archewiki"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_ADDITONAL,
    hotkey = "toggle_web_wiki",
    content = UIC_WEB_WIKI,
    permission = function()
      return UIParent:GetPermission(UIC_WEB_WIKI)
    end
  },
  [MAIN_MENU_IDX.WEB_HELP] = {
    enable = UIParent:GetPermission(UIC_WEB_HELP),
    show = true,
    text = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "one_to_one_Inquire"),
    buttonStyle = nil,
    hotkey = "",
    content = UIC_WEB_HELP,
    permission = function()
      return UIParent:GetPermission(UIC_WEB_HELP)
    end
  },
  [MAIN_MENU_IDX.ADDON] = {
    enable = ADDON:GetAddonInfos() ~= nil and 0 < #ADDON:GetAddonInfos() and UIParent:GetPermission(UIC_ADDON),
    show = ADDON:GetFeatureset(),
    text = X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "uiaddon"),
    buttonStyle = nil,
    hotkey = "",
    permission = function()
      return ADDON:GetAddonInfos() ~= nil and #ADDON:GetAddonInfos() > 0 and UIParent:GetPermission(UIC_ADDON)
    end
  },
  [MAIN_MENU_IDX.SECOND_PASSWORD] = {
    enable = UIParent:GetPermission(UIC_SECOND_PASSWORD),
    show = featureSet.secondpass or featureSet.ingameshopSecondpass,
    text = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "second_password"),
    buttonStyle = nil,
    hotkey = "",
    content = UIC_SECOND_PASSWORD,
    permission = function()
      return UIParent:GetPermission(UIC_SECOND_PASSWORD)
    end
  },
  [MAIN_MENU_IDX.OPTION] = {
    enable = true,
    show = true,
    text = X2Locale:LocalizeUiText(OPTION_TEXT, "option"),
    buttonStyle = nil,
    hotkey = "",
    toggleFunc = function()
      ToggleOptionFrame()
    end
  },
  [MAIN_MENU_IDX.SELECT_CHARACTER] = {
    enable = UIParent:GetPermission(UIC_SELECT_CHARACTER),
    show = true,
    text = X2Locale:LocalizeUiText(OPTION_TEXT, "select_character"),
    buttonStyle = nil,
    hotkey = "",
    toggleFunc = function()
      X2World:LeaveWorld(EXIT_TO_CHARACTER_LIST)
    end,
    permission = function()
      return UIParent:GetPermission(UIC_SELECT_CHARACTER)
    end
  },
  [MAIN_MENU_IDX.EXIT_GAME] = {
    enable = UIParent:GetPermission(UIC_EXIT_GAME),
    show = true,
    text = X2Locale:LocalizeUiText(OPTION_TEXT, "menu_exit"),
    buttonStyle = nil,
    hotkey = "",
    toggleFunc = function()
      X2World:LeaveWorld(EXIT_CLIENT)
    end,
    permission = function()
      return UIParent:GetPermission(UIC_EXIT_GAME)
    end
  },
  [MAIN_MENU_IDX.SPECIALTY_INFO] = {
    enable = UIParent:GetPermission(UIC_SPECIALTY_INFO),
    show = true,
    text = GetCommonText("specialty_info_title"),
    buttonStyle = nil,
    hotkey = "toggle_specialty_info",
    content = UIC_SPECIALTY_INFO,
    permission = function()
      return UIParent:GetPermission(UIC_SPECIALTY_INFO)
    end
  },
  [MAIN_MENU_IDX.TGOS] = {
    enable = X2Util:GetGameProvider() == TENCENT,
    show = true,
    text = GetCommonText("tgos"),
    buttonStyle = BUTTON_HUD.MAIN_MENU_ADDITONAL,
    hotkey = "",
    content = nil,
    createBgEffectDrawables = function(parent)
      local lightCoordsInfo = GetTextureInfo(TEXTURE_PATH.TGOS_ANI, "light")
      effectDrawableSettings = {
        {
          TEXTURE_PATH.TGOS_ANI,
          lightCoordsInfo,
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0
              },
              {
                1,
                1,
                1,
                0.3
              }
            },
            nil,
            {-15, -15}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.3
              },
              {
                1,
                1,
                1,
                0.13
              }
            },
            {
              {1, 0.85},
              {1, 1}
            },
            {-15, 0}
          },
          {
            {
              "alpha",
              0.5,
              0
            },
            {
              {
                1,
                1,
                1,
                0.13
              },
              {
                1,
                1,
                1,
                0.3
              }
            },
            {
              {0.85, 1},
              {1, 1}
            },
            {0, 15}
          },
          {
            {
              "rotate",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.3
              },
              {
                1,
                1,
                1,
                0.3
              }
            },
            nil,
            {15, -15}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.3
              },
              {
                1,
                1,
                1,
                0.13
              }
            },
            {
              {1, 0.93},
              {1, 1.1}
            },
            {-15, 0}
          },
          {
            {
              "alpha",
              0.2,
              0
            },
            {
              {
                1,
                1,
                1,
                0.13
              },
              {
                1,
                1,
                1,
                0.3
              }
            },
            {
              {0.93, 1.1},
              {1, 1.1}
            },
            {0, -15}
          },
          {
            {
              "alpha",
              0.5,
              0
            },
            {
              {
                1,
                1,
                1,
                0.3
              },
              {
                1,
                1,
                1,
                0.13
              }
            },
            {
              {1.1, 0.93},
              {1.1, 1.1}
            },
            {-15, 0}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.13
              },
              {
                1,
                1,
                1,
                0.3
              }
            },
            {
              {0.93, 1},
              {1.1, 1}
            },
            {0, 15}
          },
          {
            {
              "rotate",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.3
              },
              {
                1,
                1,
                1,
                0.3
              }
            },
            nil,
            {15, -15}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.3
              },
              {
                1,
                1,
                1,
                0
              }
            },
            nil,
            {-15, -15}
          }
        },
        {
          TEXTURE_PATH.TGOS_ANI,
          lightCoordsInfo,
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0
              },
              {
                1,
                1,
                1,
                0.4
              }
            },
            {
              {1, 1.1},
              {1, 1.1}
            },
            {15, 15}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.4
              },
              {
                1,
                1,
                1,
                0.53
              }
            },
            {
              {1.1, 1},
              {1.1, 1.1}
            },
            {15, 0}
          },
          {
            {
              "alpha",
              0.5,
              0
            },
            {
              {
                1,
                1,
                1,
                0.53
              },
              {
                1,
                1,
                1,
                0.4
              }
            },
            {
              {1, 1.1},
              {1.1, 1.1}
            },
            {0, -15}
          },
          {
            {
              "rotate",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.4
              },
              {
                1,
                1,
                1,
                0.4
              }
            },
            {
              {1.1, 1.1},
              {1.1, 1.1}
            },
            {-15, 15}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.4
              },
              {
                1,
                1,
                1,
                0.53
              }
            },
            {
              {1.1, 1},
              {1.1, 1.1}
            },
            {15, 0}
          },
          {
            {
              "alpha",
              0.2,
              0
            },
            {
              {
                1,
                1,
                1,
                0.53
              },
              {
                1,
                1,
                1,
                0.4
              }
            },
            {
              {1, 1.1},
              {1.1, 1.1}
            },
            {0, 15}
          },
          {
            {
              "alpha",
              0.5,
              0
            },
            {
              {
                1,
                1,
                1,
                0.4
              },
              {
                1,
                1,
                1,
                0.53
              }
            },
            {
              {1.1, 1},
              {1.1, 1}
            },
            {15, 0}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.53
              },
              {
                1,
                1,
                1,
                0.4
              }
            },
            {
              {1, 1.1},
              {1, 1.1}
            },
            {0, -15}
          },
          {
            {
              "rotate",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.4
              },
              {
                1,
                1,
                1,
                0.4
              }
            },
            {
              {1.1, 1.1},
              {1.1, 1.1}
            },
            {-15, 15}
          },
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0.4
              },
              {
                1,
                1,
                1,
                0
              }
            },
            {
              {1.1, 1.1},
              {1.1, 1.1}
            },
            {15, 15}
          }
        },
        {
          TEXTURE_PATH.TGOS_ANI,
          GetTextureInfo(TEXTURE_PATH.TGOS_ANI, "circle"),
          {
            {
              "alpha",
              0.4,
              0
            },
            {
              {
                1,
                1,
                1,
                0
              },
              {
                1,
                1,
                1,
                1
              }
            },
            nil,
            nil
          },
          {
            {
              "alpha",
              3.6,
              0
            },
            {
              {
                1,
                1,
                1,
                1
              },
              {
                1,
                1,
                1,
                0
              }
            },
            nil,
            nil
          }
        }
      }
      parent.bgEffectDrawables = {}
      for i = 1, #effectDrawableSettings do
        local setting = effectDrawableSettings[i]
        local effectDrawable = parent:CreateEffectDrawable(setting[1], "background")
        effectDrawable:SetVisible(false)
        effectDrawable:SetCoords(setting[2]:GetCoords())
        effectDrawable:SetExtent(setting[2]:GetExtent())
        effectDrawable:AddAnchor("CENTER", parent, 0, 0)
        effectDrawable:SetRepeatCount(30)
        local phaseIndex = 1
        for pi = 3, #setting do
          local phaseSetting = setting[pi]
          effectDrawable:SetEffectPriority(phaseIndex, phaseSetting[1][1], phaseSetting[1][2], phaseSetting[1][3])
          if phaseSetting[2] ~= nil then
            local initial, final = phaseSetting[2][1], phaseSetting[2][2]
            effectDrawable:SetEffectInitialColor(phaseIndex, initial[1], initial[2], initial[3], initial[4])
            effectDrawable:SetEffectFinalColor(phaseIndex, final[1], final[2], final[3], final[4])
          end
          if phaseSetting[3] ~= nil then
            local xScale, yScale = phaseSetting[3][1], phaseSetting[3][2]
            effectDrawable:SetEffectScale(phaseIndex, xScale[1], xScale[2], yScale[1], yScale[2])
          end
          if phaseSetting[4] ~= nil then
            effectDrawable:SetEffectRotate(phaseIndex, phaseSetting[4][1], phaseSetting[4][2])
          end
          phaseIndex = phaseIndex + 1
        end
        table.insert(parent.bgEffectDrawables, effectDrawable)
      end
      CreateTGOSToolTip(parent)
    end,
    updateFunc = function(widget, event, param1)
      if X2Unit:UnitLevel("player") >= 20 then
        return
      end
      local startAnimation = false
      if event == "ENTERED_WORLD" then
        startAnimation = param1 and X2Quest:IsCompletedStaringQuest()
      elseif event == "STARTING_QUEST_COMPLETED" then
        startAnimation = true
      end
      if startAnimation then
        widget.nowTime = 0
        widget.updateStep = 0
        widget.ignoreOnEnter = true
        local OnUpdate = function(self, dt)
          self.nowTime = self.nowTime + dt
          if self.updateStep == 0 then
            if self.nowTime >= 1000 then
              self.updateStep = 1
            end
          elseif self.updateStep == 1 then
            ShowTGOSToolTip(GetCommonText("tgos"))
            for i = 1, #self.bgEffectDrawables do
              self.bgEffectDrawables[i]:SetStartEffect(true)
            end
            self.updateStep = 2
            self.nowTime = 0
          elseif self.updateStep == 2 and self.bgEffectDrawables ~= nil and self.bgEffectDrawables[1]:IsRunning() == false then
            HideTGOSToolTip(function()
              self:ReleaseHandler("OnUpdate")
              self.ignoreOnEnter = false
            end)
            self.updateStep = 3
          end
        end
        widget:SetHandler("OnUpdate", OnUpdate)
      end
    end,
    updateEvents = {
      "ENTERED_WORLD",
      "STARTING_QUEST_COMPLETED"
    },
    toggleFunc = function(widget)
      for i = 1, #widget.bgEffectDrawables do
        widget.bgEffectDrawables[i]:SetStartEffect(false)
      end
      HideTGOSToolTip(function()
        widget:ReleaseHandler("OnUpdate")
        widget.ignoreOnEnter = false
      end)
      ADDON:ToggleContent(UIC_TGOS)
    end
  },
  [MAIN_MENU_IDX.HERO] = {
    enable = UIParent:GetPermission(UIC_HERO_RANK_WND),
    show = featureSet.hero,
    text = GetCommonText("hero"),
    buttonStyle = nil,
    hotkey = "toggle_hero",
    content = UIC_HERO_RANK_WND,
    permission = function()
      return UIParent:GetPermission(UIC_HERO_RANK_WND)
    end
  },
  [MAIN_MENU_IDX.UI_AVI] = {
    enable = true,
    show = featureSet.uiAvi,
    text = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "ui_avi"),
    buttonStyle = nil,
    hotkey = "",
    content = UIC_UI_AVI
  }
}
MENU_TABLE = {
  MAIN_MENU_IDX.CHARACTER,
  MAIN_MENU_IDX.BAG,
  MAIN_MENU_IDX.QUEST,
  MAIN_MENU_IDX.ASSIGNMENT,
  MAIN_MENU_IDX.SKILL,
  MAIN_MENU_IDX.MAP,
  {
    MAIN_MENU_IDX.PRODUCTION,
    MAIN_MENU_IDX.CRAFT_DIC,
    MAIN_MENU_IDX.MY_FARM_INFO,
    MAIN_MENU_IDX.SPECIALTY_INFO
  },
  {
    MAIN_MENU_IDX.COMMUNITY,
    MAIN_MENU_IDX.FRIEND,
    MAIN_MENU_IDX.RAID_MANAGER,
    MAIN_MENU_IDX.HERO
  },
  MAIN_MENU_IDX.RANKING,
  {
    MAIN_MENU_IDX.HOME,
    MAIN_MENU_IDX.WEB_MESSENGER,
    MAIN_MENU_IDX.PLAY_DIARY
  },
  {
    MAIN_MENU_IDX.SYSTEM,
    MAIN_MENU_IDX.UI_AVI,
    MAIN_MENU_IDX.WEB_WIKI,
    MAIN_MENU_IDX.WEB_HELP,
    MAIN_MENU_IDX.ADDON,
    MAIN_MENU_IDX.SECOND_PASSWORD,
    MAIN_MENU_IDX.OPTION,
    MAIN_MENU_IDX.SELECT_CHARACTER,
    MAIN_MENU_IDX.EXIT_GAME
  }
}
