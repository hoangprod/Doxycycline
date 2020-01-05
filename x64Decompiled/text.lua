local GetFeatureSet = function(featureSet)
  if X2Player:GetFeatureSet() == nil then
    return false
  end
  return X2Player:GetFeatureSet()[featureSet]
end
local FIXED_KEY_BINDING = function(action)
  return action
end
local GetMouseSensitivityValue = function()
  local valueTable = {}
  local minV, maxV = X2Option:GetMinxMaxOfMouseSensitivity()
  minV = minV or 0
  maxV = maxV or 20
  valueTable = {
    "0",
    tostring(math.floor(maxV - minV))
  }
  return valueTable
end
local GetBackCarryingOrderKeys = function()
  local strTable = {
    glider = GetUIText(OPTION_TEXT, "option_item_back_carrying_order_glider"),
    weapon = GetUIText(OPTION_TEXT, "option_item_back_carrying_order_weapon"),
    shield = GetUIText(OPTION_TEXT, "option_item_back_carrying_order_shield"),
    cape = GetUIText(OPTION_TEXT, "option_item_back_carrying_order_cape")
  }
  local itemKeys = X2Player:GetBackCarryingOrderKeys()
  local itemNames = {}
  for k = 1, #itemKeys do
    itemNames[k] = strTable[itemKeys[k]]
  end
  return itemNames
end
local GetOrderString = function(order)
  return X2Locale:LocalizeUiText(OPTION_TEXT, "option_item_back_carrying_order_index", tostring(order))
end
local stepTexts = {
  TYPE_1 = {
    GetUIText(OPTION_TEXT, "graphic_quality_low"),
    GetUIText(OPTION_TEXT, "graphic_quality_normal"),
    GetUIText(OPTION_TEXT, "graphic_quality_high"),
    GetUIText(OPTION_TEXT, "graphic_quality_very_high")
  },
  TYPE_2 = {
    GetUIText(OPTION_TEXT, "option_distance_near"),
    GetUIText(OPTION_TEXT, "graphic_quality_normal"),
    GetUIText(OPTION_TEXT, "option_distance_far"),
    GetUIText(OPTION_TEXT, "option_distance_very_far")
  },
  TYPE_3 = {"0", "10"}
}
optionTexts = {
  graphic = {
    resolution = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_resolution"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_resolution_tooltip"),
      controlStr = nil
    },
    screenMode = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_mode"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_mode_tooltip"),
      controlStr = optionLocale.screenMode.controlStr
    },
    sycVertical = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_syn_vertical"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_syn_vertical_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    renderThread = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_render_thread"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_render_thread_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    directX = {
      titleStr = string.format("%s*", GetUIText(OPTION_TEXT, "option_item_directx")),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_directx_tooltip"),
      controlStr = {
        layout = {autoWidth = false},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_directx9")
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_directx11")
          }
        }
      }
    },
    pixelSync = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_pixelsync"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_pixelsync_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    gamma = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_gamma"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_gamma_tooltip"),
      controlStr = {"-50", "50"}
    },
    maxfps = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_maxfps"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_maxfps_tooltip"),
      controlStr = {"30", "150"}
    },
    cameraMode = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_camera_fov_set"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_camera_fov_set_tooltip"),
      controlStr = {
        layout = {},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_camera_fov_set_action_mode"),
            value = 1
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_camera_fov_set_classic_mode"),
            value = 2
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_camera_fov_set_wide_mode"),
            value = 3
          }
        }
      }
    },
    uiScale = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_ui_resolution"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ui_resolution_tooltip"),
      controlStr = {
        "80%",
        "90%",
        "100%",
        "110%",
        "120%"
      }
    },
    uiRelocate = {
      titleStr = GetUIText(COMMON_TEXT, "ui_relocate_title"),
      tooltipStr = "",
      controlStr = GetUIText(COMMON_TEXT, "ui_relocate_button"),
      contentStr = {
        GetUIText(COMMON_TEXT, "ui_relocate_content1"),
        GetUIText(COMMON_TEXT, "ui_relocate_content2")
      }
    }
  },
  graphicAdvanced = {
    allQuality = {
      titleStr = string.format("%s*", GetUIText(OPTION_TEXT, "option_subtitle_all_quality")),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "master_quality_tooltip"),
      controlStr = {
        GetUIText(OPTION_TEXT, "graphic_quality_low"),
        GetUIText(OPTION_TEXT, "graphic_quality_normal"),
        GetUIText(OPTION_TEXT, "graphic_quality_middle"),
        GetUIText(OPTION_TEXT, "graphic_quality_high"),
        GetUIText(OPTION_TEXT, "graphic_quality_very_high"),
        GetUIText(OPTION_TEXT, "graphic_quality_by_user")
      }
    },
    subtitleTexture = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_texture"),
      tooltipStr = "",
      controlStr = nil
    },
    sceneryQuality = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_scenery_quatity"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "tex_bg_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    characterQuality = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_character_quatity"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "tex_char_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    subtitleDetail = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_detail"),
      tooltipStr = "",
      controlStr = nil
    },
    cameraDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_camera_distance"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_view_dst_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    terrainDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_terrain_distance"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_terrain_view_dst_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    terrainLOD = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_terrain_lod"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_terrain_lod_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    objectDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_object_distance"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_object_view_dst_ratio_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    grassDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_grass_distance"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_vegetation_view_dst_ratio_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    characterLOD = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_character_lod"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_char_lod_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    animationLOD = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_animation_lod"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "detail_animation_lod_tooltip"),
      controlStr = stepTexts.TYPE_2
    },
    subtitleShadow = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_shadow"),
      tooltipStr = "",
      controlStr = nil
    },
    activeShadow = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_active_shadow"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shadow_enable_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    shadowDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_shadow_distance"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shadow_lod_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    characterShadow = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_character"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shadow_char_lod_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    scenearyShadow = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_scenery"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shadow_bg_lod_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    subtitleShader = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_shader"),
      tooltipStr = "",
      controlStr = nil
    },
    shaderQuailty = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_shader_quality"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shader_quality_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    volumeMatrix = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_volume_matrix"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shader_volumetric_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    cloud = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_cloud"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shader_clouds_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    weather = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_weather"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "shader_weather_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    subtitleEffect = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_effect"),
      tooltipStr = "",
      controlStr = nil
    },
    enhancedEffect = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_enhanced_effect"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_enhanced_effect_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    gemEffect = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_gem_effect"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_gem_effect_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    weaponEffect = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_weapon_effect"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_weapon_effect_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    effectQuailty = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_effect_quality"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "effect_quality_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    subtitleWater = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_water"),
      tooltipStr = "",
      controlStr = nil
    },
    waterQuality = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_water_quality"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "water_quality_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    waterReflect = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_water_reflect"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "water_reflection_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    subtitlePostprocess = {
      titleStr = GetUIText(OPTION_TEXT, "option_subtitle_postprocess"),
      tooltipStr = "",
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    hdr = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_hdr"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "post_hdr_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    dof = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_dof"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "post_dof_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_window_full_screen")
    },
    antiAliasing = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_ani_aliasing"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "post_anti_tooltip"),
      controlStr = nil
    }
  },
  sound = {
    quality = {
      titleStr = GetUIText(OPTION_TEXT, "option_sound_quality"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_quality_tooltip"),
      controlStr = stepTexts.TYPE_1
    },
    masterVolume = {
      titleStr = GetUIText(OPTION_TEXT, "option_sound_master"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_master_tooltip"),
      controlStr = stepTexts.TYPE_3
    },
    bgmVolume = {
      titleStr = GetUIText(OPTION_TEXT, "option_sound_bgm"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_bgm_tooltip"),
      controlStr = stepTexts.TYPE_3
    },
    useCombatSound = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_use_combat_sound_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_sound_use_combat_sound")
    },
    sfxVolume = {
      titleStr = GetUIText(OPTION_TEXT, "option_sound_sfx"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_sfx_tooltip"),
      controlStr = stepTexts.TYPE_3
    },
    cinemaVolume = {
      titleStr = GetUIText(OPTION_TEXT, "option_sound_cinema"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_cinema_tooltip"),
      controlStr = stepTexts.TYPE_3
    },
    userMusicVolume = {
      titleStr = GetUIText(OPTION_TEXT, "option_sound_user_music"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_user_music_volume_control"),
      controlStr = stepTexts.TYPE_3
    },
    useUserMusicOthers = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_sound_user_music_enable_others"),
      controlStr = GetUIText(OPTION_TEXT, "option_sound_user_music_enable_others")
    }
  },
  nameTagInfo = {
    subtitleNameTag = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_subtitle_nameTag"),
      tooltipStr = "",
      controlStr = nil
    },
    subtitleNameTagMode = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_subtitle_nameTag_mode"),
      tooltipStr = "",
      controlStr = nil
    },
    subtitleNameTagDetail = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_subtitle_nameTag_detail"),
      tooltipStr = "",
      controlStr = nil
    },
    showAppellation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_appellation_nametag_tootip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_appellation_nametag")
    },
    showFaction = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_faction_nametag_tootip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_faction_nametag")
    },
    showHp = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_hp_nametag_tootip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_hp_nametag")
    },
    visibleMyName = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_my_name_nametag_tootip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_my_name_nametag")
    },
    visibleParty = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_party_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_party_nametag")
    },
    visiblePartySelection = {
      titleStr = nil,
      tooltipStr = nil,
      controlStr = {
        layout = {},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_party_member_nametag")
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_raid_member_nametag")
          }
        }
      }
    },
    visibleExpeditionMember = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_expedtion_member_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_expedtion_member_nametag")
    },
    visibleFriendlyPlayer = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_friendly_player_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_friendly_player_nametag")
    },
    visibleHostilePlayer = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_hostile_player_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_hostile_player_nametag")
    },
    visibleMyMate = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_my_mate_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_my_mate_nametag")
    },
    visibleFriendlyMate = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_friendly_mate_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_friendly_mate_nametag")
    },
    visibleHostileMate = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_hostile_mate_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_hostile_mate_nametag")
    },
    visibleNpc = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_npc_nametag_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_npc_nametag")
    },
    selectionFactionInfo = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_subtitle_faction_nametag"),
      tooltipStr = nil,
      controlStr = nil
    },
    factionSelection = {
      titleStr = nil,
      tooltipStr = nil,
      controlStr = {
        layout = {},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_expedition_nametag"),
            tooltip = GetUIText(TOOLTIP_TEXT, "nametag_faciton_radio_expediton_tooltip"),
            value = NAME_TAG_FACTION_EXPEDITION
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_faction_nametag"),
            tooltip = GetUIText(TOOLTIP_TEXT, "nametag_faciton_radio_faction_tooltip"),
            value = NAME_TAG_FACTION_FACTION
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_family_nametag"),
            tooltip = GetUIText(TOOLTIP_TEXT, "nametag_faciton_radio_family_tooltip"),
            value = NAME_TAG_FACTION_FAMILY
          }
        }
      }
    },
    visibleType = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_subtitle_mode_nametag"),
      tooltipStr = nil,
      controlStr = nil
    },
    nameTagMode = {
      titleStr = nil,
      tooltipStr = nil,
      controlStr = {
        layout = {},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_nametag_mode_default"),
            tooltip = GetUIText(TOOLTIP_TEXT, "option_item_nametag_mode_default_tooltip"),
            value = NAME_TAG_MODE_DEFAULT
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_nametag_mode_battle"),
            tooltip = GetUIText(TOOLTIP_TEXT, "option_item_nametag_mode_battle_tooltip"),
            value = NAME_TAG_MODE_BATTLE
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_nametag_mode_life"),
            tooltip = GetUIText(TOOLTIP_TEXT, "option_item_nametag_mode_life_tooltip"),
            value = NAME_TAG_MODE_LIFE
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_nametag_mode_box"),
            tooltip = GetUIText(TOOLTIP_TEXT, "option_item_nametag_mode_box_tooltip"),
            value = NAME_TAG_MODE_BOX
          }
        }
      }
    }
  },
  gameInfo = {
    visibleHealthText = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_health_text_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_health_text")
    },
    visibleManaPointText = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_mana_point_text_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_mana_point_text")
    },
    visibleBuffDuration = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_buff_duration_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_buff_duration")
    },
    visibleTargetCastingBar = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_target_casting_bar_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_target_casting_bar")
    },
    visibleTargetTargetCastingBar = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_target_target_casting_bar_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_target_target_casting_bar")
    },
    visibleMyEquipInfo = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_my_equip_info"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_my_equip_info_tooltip"),
      controlStr = {
        layout = {autoWidth = false},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_open_my_equip_info"),
            value = 1
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_close_my_equip_info"),
            value = 2
          }
        }
      }
    },
    visibleTooltipSynergyInfo = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_synergy_info_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_synergy_info")
    },
    visibleTooltipSkillDatailDamage = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_detail_damage_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_detail_damage")
    },
    visibleMakerInfo = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_maker_info_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_maker_info")
    },
    SetFixedTooltipPosition = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_set_fixed_tooltip_position"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_set_fixed_tooltip_position"),
      controlStr = {
        layout = {autoWidth = false},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "option_item_position_cursor"),
            value = 1
          },
          {
            text = GetUIText(OPTION_TEXT, "option_item_position_screen_right_bottom"),
            value = 2
          }
        }
      }
    },
    visibleEmptyBagSlotCount = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_empty_bag_slot_count_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_empty_bag_slot_count")
    },
    visibleChatBubble = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_bubble_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_bubble")
    },
    hideTutorial = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_hide_tutorial_tooltip"),
      controlStr = GetUIText(TUTORIAL_TEXT, "hide_tutorial")
    },
    visibleFps = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_fps_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_fps")
    },
    enableSkillAlert = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "skill_alert_tooltip_text"),
      controlStr = GetUIText(OPTION_TEXT, "skill_alert_text")
    },
    skillAlert = {
      titleStr = nil,
      tooltipStr = "",
      controlStr = GetUIText(OPTION_TEXT, "skill_alert_option_btn_text")
    },
    skillAlertPosition = {
      titleStr = GetUIText(OPTION_TEXT, "skill_alert_option_position_text"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "skill_alert_option_position_tool_tip_text"),
      controlStr = {
        layout = {autoWidth = false},
        data = {
          {
            text = GetUIText(OPTION_TEXT, "skill_alert_option_position_basic_text"),
            value = SKILL_ALERT_POS_BASIC
          },
          {
            text = GetUIText(OPTION_TEXT, "skill_alert_option_position_1_text"),
            value = SKILL_ALERT_POS_FIRST
          },
          {
            text = GetUIText(OPTION_TEXT, "skill_alert_option_position_2_text"),
            value = SKILL_ALERT_POS_SECOND
          },
          {
            text = GetUIText(OPTION_TEXT, "skill_alert_option_position_off_text"),
            value = SKILL_ALERT_POS_OFF
          }
        }
      }
    },
    visibleHelmet = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_helmet_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_helmet")
    },
    visibleMyCosplay = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_my_cosplay_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_my_cosplay")
    },
    visibleBackpackWithCosplay = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_backpack_with_cosplay"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_backpack_with_cosplay")
    },
    combatMsgDisplayShipCollision = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_hp_display_ship_collision_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_hp_display_ship_collision")
    },
    firstOrderBackCarrying = {
      titleStr = GetOrderString(1),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_back_carrying_order_tooltip"),
      controlStr = GetBackCarryingOrderKeys()
    },
    secondOrderBackCarrying = {
      titleStr = GetOrderString(2),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_back_carrying_order_tooltip"),
      controlStr = GetBackCarryingOrderKeys()
    },
    thirdOrderBackCarrying = {
      titleStr = GetOrderString(3),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_back_carrying_order_tooltip"),
      controlStr = GetBackCarryingOrderKeys()
    },
    thirdOrderBackCarrying = {
      titleStr = GetOrderString(3),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_back_carrying_order_tooltip"),
      controlStr = GetBackCarryingOrderKeys()
    },
    fourthOrderBackCarrying = {
      titleStr = GetOrderString(4),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_back_carrying_order_tooltip"),
      controlStr = GetBackCarryingOrderKeys()
    },
    visibleMyBackHoldable = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_my_back_holdable_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_my_back_holdable")
    },
    combatMsgLevel = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_hp_display_step"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_hp_display_step_tooltip"),
      controlStr = {
        GetUIText(OPTION_TEXT, "option_combat_msg_self"),
        GetUIText(OPTION_TEXT, "option_combat_msg_party"),
        GetUIText(OPTION_TEXT, "option_combat_msg_raid"),
        GetUIText(OPTION_TEXT, "optino_combat_msg_expedition"),
        GetUIText(OPTION_TEXT, "option_combat_msg_all")
      }
    },
    combatMsgDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_hp_display_distance"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_hp_display_distance_tooltip"),
      controlStr = {
        X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", "0"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", "100")
      }
    },
    mapQuestDistance = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_map_quest_distance_display"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_map_quest_distance_display_tooltip"),
      controlStr = {
        X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", "100"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", "200"),
        X2Locale:LocalizeUiText(COMMON_TEXT, "meter_initial", "300"),
        GetUIText(COMMON_TEXT, "unlimited")
      }
    }
  },
  gameFunction = {
    clickToMove = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_automove_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_automove")
    },
    fireSkillOnDown = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_fire_skill_on_down_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_fire_skill_on_down")
    },
    AutoEnemyTarget = {
      titleStr = nil,
      tooltipStr = GetUIText(COMMON_TEXT, "option_item_auto_enemy_target_tooltip"),
      controlStr = GetUIText(COMMON_TEXT, "option_item_auto_enemy_target")
    },
    smartGroundTargeting = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_smart_ground_targeting_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_smart_ground_targeting")
    },
    useCelerity = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_celerity"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_celerity")
    },
    useGliderWithDoubleJump = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_double_jump_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_double_jump")
    },
    useDoodadSmartPositioning = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_doodad_smart_positioning_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_doodad_smart_positioning")
    },
    useDecorationSmartPositioning = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_decoration_smart_positioning_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_decoration_smart_positioning")
    },
    useCameraShake = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_use_camera_shake_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_use_camera_shake")
    },
    showPlayerFrameLifeAlertEffect = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_visible_playerframe_life_alert_effect_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_playerframe_life_alert_effect")
    },
    useQuestDirectingCloseUpCamera = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_use_quest_directing_close_up_camera_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_use_quest_directing_close_up_camera")
    },
    showGuideDecal = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_quest_direction_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_quest_direction")
    },
    showLootWindow = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_loot_window_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_show_loot_window")
    },
    useOnlyMyPortal = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_use_only_my_portal_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_use_only_my_portal")
    },
    customCloneMode = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_custom_clone_mode_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_custom_clone_mode")
    },
    customMaxCloneModel = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_custom_max_clone_model"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_custom_max_clone_model_tooltip"),
      controlStr = {
        "50",
        "80",
        "100",
        "150",
        "200"
      }
    },
    subTitleInviteReject = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_invite_reject_title"),
      tooltipStr = nil,
      controlStr = nil
    },
    ignorePartyInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_party_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_party_invite")
    },
    ignoreRaidInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_raid_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_raid_invite")
    },
    ignoreRaidJoint = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_raid_joint_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_raid_joint")
    },
    ignoreSquadInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_squad_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_squad_invite")
    },
    ignoreExpeditionInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_expedition_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_expedition_invite")
    },
    ignoreFamilyInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_family_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_family_invite")
    },
    ignoreJuryInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_jury_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_jury_invite")
    },
    ignoreTradeInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_trade_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_trade_invite")
    },
    ignoreDuelInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_duel_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_duel_invite")
    },
    ignoreFactionInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_faction_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_faction_invite")
    },
    ignoreWhisperInvitation = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_whisper_invite_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_whisper_invite")
    },
    ignoreChatFilter = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ignore_chat_filter_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_ignore_chat_filter")
    },
    subTitleMouseInputOption = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_mouse_input_sub_title"),
      tooltipStr = nil,
      controlStr = nil
    },
    mouseSensitivity = {
      titleStr = GetUIText(OPTION_TEXT, "option_item_mouse_sensitivity"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_mouse_sensitive_tooltip"),
      controlStr = GetMouseSensitivityValue()
    },
    mouseInvertXAxis = {
      titleStr = nil,
      tooltipStr = GetUIText(OPTION_TEXT, "option_item_mouse_invert_x_axis_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_mouse_invert_x_axis")
    },
    mouseInvertYAxis = {
      titleStr = nil,
      tooltipStr = GetUIText(OPTION_TEXT, "option_item_mouse_invert_y_axis_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_mouse_invert_y_axis")
    },
    hideOptimizationButton = {
      titleStr = nil,
      tooltipStr = GetUIText(OPTION_TEXT, "option_item_hide_optimization_button_tooltip"),
      controlStr = GetUIText(OPTION_TEXT, "option_item_hide_optimization_button")
    }
  },
  actionBar = {
    useDefaultAB = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "actionbar_option_item_tooltip1"),
      controlStr = GetUIText(OPTION_TEXT, "option_interface_action_bar_expand_1")
    },
    useExpandedFirstAB = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "actionbar_option_item_tooltip2"),
      controlStr = GetUIText(OPTION_TEXT, "option_interface_action_bar_expand_2")
    },
    useExpandedSecondAB = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "actionbar_option_item_tooltip3"),
      controlStr = GetUIText(OPTION_TEXT, "option_interface_action_bar_expand_3")
    },
    useExpandedThirdAB = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "actionbar_option_item_tooltip4"),
      controlStr = GetUIText(OPTION_TEXT, "option_interface_action_bar_expand_4")
    },
    useExpandedFourthAB = {
      titleStr = nil,
      tooltipStr = GetUIText(TOOLTIP_TEXT, "actionbar_option_item_tooltip5"),
      controlStr = GetUIText(OPTION_TEXT, "option_interface_action_bar_expand_5")
    },
    visibleSkillDuration = {
      titleStr = nil,
      tooltipStr = GetCommonText("actionbar_option_item_tooltip_visible_skill_duration"),
      controlStr = GetUIText(OPTION_TEXT, "option_visible_skill_duration")
    }
  },
  keybinding_char_ctrl = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_moveforward"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_moveforward_tooltip"),
      controlStr = nil,
      actionName = "moveforward"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_moveback"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_moveback_tooltip"),
      controlStr = nil,
      actionName = "moveback"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_moveleft"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_moveleft_tooltip"),
      controlStr = nil,
      actionName = "moveleft"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_moveright"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_moveright_tooltip"),
      controlStr = nil,
      actionName = "moveright"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_turnleft"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_turnleft_tooltip"),
      controlStr = nil,
      actionName = "turnleft"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_turnright"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_turnright_tooltip"),
      controlStr = nil,
      actionName = "turnright"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_jump"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_jump_tooltip"),
      controlStr = nil,
      actionName = "jump"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_autorun"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_autorun_tooltip"),
      controlStr = nil,
      actionName = "autorun"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_down"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_down_tooltip"),
      controlStr = nil,
      actionName = "down"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_walk"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_walk_tooltip"),
      controlStr = nil,
      actionName = "toggle_walk"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_activate_weapon"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_activate_weapon_tooltip"),
      controlStr = nil,
      actionName = "activate_weapon"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_swap_preliminary_equipment"),
      tooltipStr = nil,
      controlStr = nil,
      insertable = GetFeatureSet("preliminaryEquipment"),
      actionName = "swap_preliminary_equipment"
    }
  },
  keybinding_mount_ctrl_1 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_info"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_info_tooltip"),
      controlStr = nil,
      actionName = "PetCommandButton1"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_riding"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_riding_tooltip"),
      controlStr = nil,
      actionName = "PetCommandButton2"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_passenger"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_passenger_tooltip"),
      controlStr = nil,
      actionName = "PetCommandButton3"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_release"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_release_tooltip"),
      controlStr = nil,
      actionName = "PetCommandButton4"
    }
  },
  keybinding_mount_ctrl_2 = {
    {
      titleStr = GetUIText(PET_TEXT, "state_aggressive"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance1_tooltip"),
      controlStr = nil,
      actionName = "PetStanceButton1"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_protective"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance2_tooltip"),
      controlStr = nil,
      actionName = "PetStanceButton2"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_passive"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance3_tooltip"),
      controlStr = nil,
      actionName = "PetStanceButton3"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_stand"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance4_tooltip"),
      controlStr = nil,
      actionName = "PetStanceButton4"
    }
  },
  keybinding_mount_ctrl_3 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill1_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill2_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill3_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill4_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill5"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill5_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    }
  },
  keybinding_pet_ride_ctrl_1 = {
    {
      titleStr = GetUIText(COMMON_TEXT, "ride_pet_long"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subBigTitle"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_info"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_info_tooltip"),
      controlStr = nil,
      actionName = "Pet1CommandButton1"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_riding"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_riding_tooltip"),
      controlStr = nil,
      actionName = "Pet1CommandButton2"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_passenger"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_passenger_tooltip"),
      controlStr = nil,
      actionName = "Pet1CommandButton3"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_release"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_release_tooltip"),
      controlStr = nil,
      actionName = "Pet1CommandButton4"
    }
  },
  keybinding_pet_ride_ctrl_2 = {
    {
      titleStr = GetUIText(PET_TEXT, "state_passive"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance3_tooltip"),
      controlStr = nil,
      actionName = "Pet1StanceButton3"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_stand"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance4_tooltip"),
      controlStr = nil,
      actionName = "Pet1StanceButton4"
    }
  },
  keybinding_pet_ride_ctrl_3 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill1_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill2_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill3_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill4_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill5"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill5_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill6"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill6_tooltip"),
      controlStr = nil,
      actionName = "ride_pet_action_bar_button"
    }
  },
  keybinding_pet_battle_ctrl_1 = {
    {
      titleStr = GetUIText(COMMON_TEXT, "battle_pet_long"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subBigTitle"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_info"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_info_tooltip"),
      controlStr = nil,
      actionName = "Pet2CommandButton1"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_release"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_release_tooltip"),
      controlStr = nil,
      actionName = "Pet2CommandButton4"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_pet_attack"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_pet_attack_tooltip"),
      controlStr = nil,
      actionName = "Pet2CommandButton5"
    }
  },
  keybinding_pet_battle_ctrl_2 = {
    {
      titleStr = GetUIText(PET_TEXT, "state_aggressive"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance1_tooltip"),
      controlStr = nil,
      actionName = "Pet2StanceButton1"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_protective"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance2_tooltip"),
      controlStr = nil,
      actionName = "Pet2StanceButton2"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_passive"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance3_tooltip"),
      controlStr = nil,
      actionName = "Pet2StanceButton3"
    },
    {
      titleStr = GetUIText(PET_TEXT, "state_stand"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_stance4_tooltip"),
      controlStr = nil,
      actionName = "Pet2StanceButton4"
    }
  },
  keybinding_pet_battle_ctrl_3 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill1_tooltip"),
      controlStr = nil,
      actionName = "battle_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill2_tooltip"),
      controlStr = nil,
      actionName = "battle_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill3_tooltip"),
      controlStr = nil,
      actionName = "battle_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill4_tooltip"),
      controlStr = nil,
      actionName = "battle_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill5"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill5_tooltip"),
      controlStr = nil,
      actionName = "battle_pet_action_bar_button"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_vehicle_skill6"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_vehicle_skill6_tooltip"),
      controlStr = nil,
      actionName = "battle_pet_action_bar_button"
    }
  },
  keybinding_game_ctrl_1 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_do_interaction_1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_do_interaction_1_tooltip"),
      controlStr = nil,
      actionName = "do_interaction_1"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_do_interaction_2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_do_interaction_2_tooltip"),
      controlStr = nil,
      actionName = "do_interaction_2"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_do_interaction_3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_do_interaction_3_tooltip"),
      controlStr = nil,
      actionName = "do_interaction_3"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_do_interaction_4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_do_interaction_4_tooltip"),
      controlStr = nil,
      actionName = "do_interaction_4"
    }
  },
  keybinding_game_ctrl_2 = {
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(1)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_1_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(2)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_2_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(3)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_3_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(4)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_4_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(5)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_5_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(6)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_6_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(7)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_7_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(8)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_8_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(9)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_9_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "option_item_mode_skill", tostring(10)),
      tooltipStr = string.format([[
%s

%s]], GetUIText(TOOLTIP_TEXT, "option_item_mode_skill_10_tooltip"), GetUIText(TOOLTIP_TEXT, "override_keybinding_tip")),
      controlStr = nil,
      actionName = "mode_action_bar_button"
    }
  },
  subTitles = {
    selectTarget = {
      titleStr = GetUIText(OPTION_TEXT, "select_target"),
      tooltipStr = nil,
      controlStr = nil
    },
    questInteraction = {
      titleStr = GetUIText(OPTION_TEXT, "quest_directing_interaction"),
      tooltipStr = nil,
      controlStr = nil
    },
    chatting = {
      titleStr = GetUIText(OPTION_TEXT, "chatting"),
      tooltipStr = nil,
      controlStr = nil
    },
    screenShot = {
      titleStr = GetUIText(OPTION_TEXT, "screen_shot"),
      tooltipStr = nil,
      controlStr = nil
    },
    overHeadMarker = {
      titleStr = GetUIText(UNIT_FRAME_TEXT, "over_head_marker"),
      tooltipStr = nil,
      controlStr = nil
    }
  },
  keybinding_game_ctrl_3 = {
    {
      titleStr = GetUIText(OPTION_TEXT, "select_target"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subNormalTitle"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_self_target"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_self_target_tooltip"),
      controlStr = nil,
      actionName = "round_target"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_team_target_1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_team_target_1_tooltip"),
      controlStr = nil,
      actionName = "team_target"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_team_target_2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_team_target_2_tooltip"),
      controlStr = nil,
      actionName = "team_target"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_team_target_3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_team_target_3_tooltip"),
      controlStr = nil,
      actionName = "team_target"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_team_target_4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_team_target_4_tooltip"),
      controlStr = nil,
      actionName = "team_target"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_cycle_hostile_forward"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_cycle_hostile_forward_tooltip"),
      controlStr = nil,
      actionName = "cycle_hostile_forward"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_cycle_hostile_backward"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_cycle_hostile_backward_tooltip"),
      controlStr = nil,
      actionName = "cycle_hostile_backward"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_cycle_friendly_forward"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_cycle_friendly_forward_tooltip"),
      controlStr = nil,
      actionName = "cycle_friendly_forward"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_cycle_friendly_backward"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_cycle_friendly_backward_tooltip"),
      controlStr = nil,
      actionName = "cycle_friendly_backward"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_set_watch_target"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_set_watch_target_tooltip"),
      controlStr = nil,
      actionName = "set_watch_target"
    }
  },
  keybinding_game_ctrl_4 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_open_target_equipment"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_open_target_equipment_tooltip"),
      controlStr = nil,
      insertable = GetFeatureSet("targetEquipmentWnd"),
      actionName = "open_target_equipment"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_force_attack"),
      tooltipStr = locale.forceAttack.toolTip(GetFeatureSet("protectPvp")),
      controlStr = nil,
      insertable = optionLocale.useForceAttackKey,
      actionName = "toggle_force_attack"
    }
  },
  keybinding_camera_ctrl = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_front_camera"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_front_camera_tooltip"),
      controlStr = nil,
      actionName = "front_camera"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_left_camera"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_left_camera_tooltip"),
      controlStr = nil,
      actionName = "right_camera"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_right_camera"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_right_camera_tooltip"),
      controlStr = nil,
      actionName = "left_camera"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_back_camera"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_back_camera_tooltip"),
      controlStr = nil,
      actionName = "back_camera"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_cycle_camera_counter_clockwise"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_cycle_camera_counter_clockwise_tooltip"),
      controlStr = nil,
      actionName = "cycle_camera_counter_clockwise"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_cycle_camera_clockwise"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_cycle_camera_clockwise_tooltip"),
      controlStr = nil,
      actionName = "cycle_camera_clockwise"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_camera_zoom_in"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_camera_zoom_in_tooltip"),
      controlStr = nil,
      actionName = "zoom_in"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_camera_zoom_out"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_camera_zoom_out_tooltip"),
      controlStr = nil,
      actionName = "zoom_out"
    }
  },
  keybinding_interface_1 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_character"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_character_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_character"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_bag"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_bag_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_bag"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_quest"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_quest_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_quest"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_spellbook"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_spellbook_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_spellbook"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_maximap"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_maximap_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_worldmap"
    }
  },
  keybinding_interface_2 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_craft_book"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_craft_book_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_craft_book"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_common_farm_info"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_common_farm_info_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_common_farm_info"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_specialty_info"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_specialty_info_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_specialty_info"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_ranking"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_ranking_tooltip"),
      controlStr = nil,
      insertable = GetFeatureSet("ranking"),
      actionName = "toggle_ranking"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_achievement"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_achievement_tooltip"),
      controlStr = nil,
      insertable = GetFeatureSet("achievement"),
      actionName = "toggle_achievement"
    }
  },
  keybinding_interface_3 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_expedition_management"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_expedition_management_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_expedition_management"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_raid_team_manager"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_raid_team_manager_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_raid_team_manager"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_community"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_community_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_friend"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_nation_management"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_nation_management_tooltip"),
      controlStr = nil,
      insertable = X2Nation:IsIndependenceFeature() or false,
      actionName = "toggle_nation_management"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_family_management"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_family_management_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_family_management"
    },
    {
      titleStr = GetUIText(COMMON_TEXT, "builtin_toggle_hero"),
      tooltipStr = GetUIText(COMMON_TEXT, "builtin_toggle_hero_tooltip"),
      controlStr = nil,
      insertable = GetFeatureSet("hero"),
      actionName = "toggle_hero"
    }
  },
  keybinding_interface_4 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_ingameshop"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_ingameshop_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_ingameshop"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_commercial_mail"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_commercial_mail_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = FIXED_KEY_BINDING("SHIFT-B")
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_auction"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_auction_tooltip"),
      controlStr = nil,
      insertable = GetFeatureSet("hudAuctionButton"),
      actionName = "toggle_auction"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_battle_field"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_battle_field_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "toggle_battle_field"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_mail"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_mail_tooltip"),
      controlStr = nil,
      insertable = GetFeatureSet("hudMailBoxButton"),
      actionName = "toggle_mail"
    }
  },
  keybinding_interface_5 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_web_messenger"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_web_messenger_tooltip"),
      controlStr = nil,
      insertable = baselibLocale.useWebMessenger,
      actionName = "toggle_web_messenger"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_web_play_diary"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_web_play_diary_tooltip"),
      controlStr = nil,
      insertable = baselibLocale.useWebDiary,
      actionName = "toggle_web_play_diary"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_web_browser"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_web_browser_tooltip"),
      controlStr = nil,
      insertable = baselibLocale.useWebQuickDiary,
      actionName = "toggle_web_play_diary_instant"
    }
  },
  keybinding_interface_6 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_wiki"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_wiki_tooltip"),
      controlStr = nil,
      insertable = baselibLocale.useWebWiki,
      actionName = "toggle_web_wiki"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_open_chat"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_open_chat_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "open_chat"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_open_config"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_open_config_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "open_config"
    }
  },
  keybinding_shortcut_1 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_action_bar_page_prev"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_action_bar_page_prev_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "action_bar_page_prev"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_action_bar_page_next"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_action_bar_page_next_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "action_bar_page_next"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "action_bar_page_1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "action_bar_page_1_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "action_bar_page"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "action_bar_page_2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "action_bar_page_2_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "action_bar_page"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "action_bar_page_3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "action_bar_page_3_tooltip"),
      controlStr = nil,
      insertable = true,
      actionName = "action_bar_page"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "action_bar_page_4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "action_bar_page_4_tooltip"),
      controlStr = nil,
      insertable = not GetFeatureSet("useSavedAbilities"),
      actionName = "action_bar_page"
    }
  },
  keybinding_shortcut_2 = {
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "1"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "1"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "2"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "2"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "3"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "3"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "4"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "4"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "5"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "5"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "6"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "6"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "7"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "7"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "8"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "8"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "9"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "9"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "10"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "10"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "11"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "11"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_1", "12"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_1_tooltip", "12"),
      controlStr = nil,
      actionName = "action_bar_button"
    }
  },
  keybinding_shortcut_3 = {
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "1"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "1"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "2"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "2"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "3"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "3"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "4"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "4"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "5"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "5"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "6"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "6"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "7"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "7"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "8"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "8"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "9"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "9"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "10"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "10"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "11"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "11"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_2", "12"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_2_tooltip", "12"),
      controlStr = nil,
      actionName = "action_bar_button"
    }
  },
  keybinding_shortcut_4 = {
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "1"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "1"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "2"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "2"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "3"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "3"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "4"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "4"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "5"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "5"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "6"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "6"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "7"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "7"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "8"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "8"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "9"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "9"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "10"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "10"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "11"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "11"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_3", "12"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_3_tooltip", "12"),
      controlStr = nil,
      actionName = "action_bar_button"
    }
  },
  keybinding_shortcut_5 = {
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "1"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "1"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "2"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "2"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "3"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "3"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "4"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "4"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "5"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "5"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "6"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "6"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "7"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "7"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "8"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "8"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "9"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "9"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "10"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "10"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "11"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "11"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_4", "12"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_4_tooltip", "12"),
      controlStr = nil,
      actionName = "action_bar_button"
    }
  },
  keybinding_shortcut_6 = {
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "1"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "1"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "2"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "2"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "3"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "3"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "4"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "4"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "5"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "5"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "6"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "6"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "7"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "7"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "8"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "8"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "9"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "9"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "10"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "10"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "11"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "11"),
      controlStr = nil,
      actionName = "action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_action_bar_5", "12"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_action_bar_5_tooltip", "12"),
      controlStr = nil,
      actionName = "action_bar_button"
    }
  },
  keybinding_shortcut_7 = {
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "1"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "1"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "2"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "2"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "3"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "3"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "4"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "4"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "5"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "5"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "6"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "6"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "7"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "7"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "8"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "8"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "9"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "9"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    },
    {
      titleStr = X2Locale:LocalizeUiText(OPTION_TEXT, "option_short_cut_battle_field_action_bar", "10"),
      tooltipStr = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_short_cut_battle_field_action_bar_tooltip", "10"),
      controlStr = nil,
      actionName = "instant_kill_streak_action_bar_button"
    }
  },
  keybinding_additional_1 = {
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_nametag"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_nametag_tooltip"),
      controlStr = nil,
      actionName = "toggle_nametag"
    },
    {
      titleStr = GetUIText(OPTION_TEXT, "option_item_show_quest_direction"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_show_quest_direction_tooltip"),
      controlStr = nil,
      actionName = "toggle_show_guide_decal"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_toggle_raid_frame"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_toggle_raid_frame_tooltip"),
      controlStr = nil,
      actionName = "toggle_raid_frame"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtinchange_roadmap_size"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtinchange_roadmap_size_tooltip"),
      controlStr = nil,
      actionName = "change_roadmap_size"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "option_addtion_road_map_tooltip"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_addtion_road_map_tooltip_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("SHIFT-OVER")
    },
    {
      titleStr = GetUIText(OPTION_TEXT, "option_item_ping"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_item_ping_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("SHIFT-LCLICK")
    }
  },
  keybinding_additional_2 = {
    {
      titleStr = GetUIText(OPTION_TEXT, "quest_directing_interaction"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subNormalTitle"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "quest_interaction_prev"),
      tooltipStr = string.format([[
%s

%s]], X2Locale:LocalizeUiText(TOOLTIP_TEXT, "quest_interaction_prev_tooptip"), X2Locale:LocalizeUiText(COMMON_TEXT, "quest_override_keybinding_tip")),
      controlStr = nil,
      actionName = "quest_directing_interaction"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "quest_interaction_next"),
      tooltipStr = string.format([[
%s

%s]], X2Locale:LocalizeUiText(TOOLTIP_TEXT, "quest_interaction_next_tooptip"), X2Locale:LocalizeUiText(COMMON_TEXT, "quest_override_keybinding_tip")),
      controlStr = nil,
      actionName = "quest_directing_interaction"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "quest_interaction_accept"),
      tooltipStr = string.format([[
%s

%s]], X2Locale:LocalizeUiText(TOOLTIP_TEXT, "quest_interaction_accept_tooptip"), X2Locale:LocalizeUiText(COMMON_TEXT, "quest_override_keybinding_tip")),
      controlStr = nil,
      actionName = "quest_directing_interaction"
    }
  },
  keybinding_additional_3 = {
    {
      titleStr = GetUIText(OPTION_TEXT, "chatting"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subNormalTitle"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "option_addtion_chat_mode_up"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_addtion_chat_mode_up_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("ALT-LEFT")
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "option_addtion_chat_mode_down"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_addtion_chat_mode_down_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("ALT-RIGHT")
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "option_addtion_prev_chat_content_up"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_addtion_prev_chat_content_up_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("ALT-UP")
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "option_addtion_prev_chat_content_down"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_addtion_prev_chat_content_down_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("ALT-DOWN")
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_reply_last_whispered"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_reply_last_whispered_tooltip"),
      controlStr = nil,
      actionName = "reply_last_whispered"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_reply_last_whisper"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_reply_last_whisper_tooltip"),
      controlStr = nil,
      actionName = "reply_last_whisper"
    }
  },
  keybinding_additional_4 = {
    {
      titleStr = GetUIText(OPTION_TEXT, "screen_shot"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subNormalTitle"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "builtin_screenshotmode"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_screenshotmode_tooltip"),
      controlStr = nil,
      actionName = "screenshotmode"
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "screen_shot_camera"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "screen_shot_camera_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("CTRL-F12")
    },
    {
      titleStr = GetUIText(KEY_BINDING_TEXT, "option_addtion_screen_shot"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "option_addtion_screen_shot_tooltip"),
      controlStr = nil,
      actionName = FIXED_KEY_BINDING("f9")
    }
  },
  keybinding_additional_5 = {
    {
      titleStr = GetUIText(UNIT_FRAME_TEXT, "over_head_marker"),
      tooltipStr = nil,
      controlStr = nil,
      actionName = nil,
      controlType = "subNormalTitle"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "1"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "2"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "3"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "4"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "5"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "6"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "7"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "8"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "9"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "\226\153\165"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "\226\152\133"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    },
    {
      titleStr = string.format("%s%s", GetUIText(UNIT_FRAME_TEXT, "over_head_marker"), "X"),
      tooltipStr = GetUIText(TOOLTIP_TEXT, "builtin_overHeadMarker_tooltip"),
      controlStr = nil,
      actionName = "over_head_marker"
    }
  }
}
