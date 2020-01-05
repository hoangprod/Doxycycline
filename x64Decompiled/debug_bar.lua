if X2Debug:GetDevMode() then
  consoleCommandTree = {
    name = "root",
    children = {
      {
        name = "Music",
        children = {
          solzreed = "play_music w_solzreed",
          two_crowns = "play_music w_two_crowns",
          Stop = "stop_music"
        }
      },
      {
        name = "housing",
        children = {
          {
            name = "house",
            children = {
              rebuild = "hs_rebuild",
              house_design_1 = "hs_use_house_item 1",
              house_design_2 = "hs_use_house_item 2",
              hs_house_a = "hs_use_house_item 31",
              hs_house_a_brown = "hs_use_house_item 32",
              hs_house_b = "hs_use_house_item 33",
              hs_house_b_brown = "hs_use_house_item 34",
              hs_house_c = "hs_use_house_item 35",
              hs_sawmill_a = "hs_use_house_item 36",
              hs_stable_a = "hs_use_house_item 37",
              hs_stonemasonshop_a = "hs_use_house_item 38",
              hs_barrackhouse_a = "hs_use_house_item 39",
              hs_farmhouse1 = "hs_use_house_item 40",
              hs_house_a_block = "hs_use_house_item 41",
              hs_house_b_block = "hs_use_house_item 42",
              hs_house_c_block = "hs_use_house_item 43",
              housing_farmhouse_a = "hs_use_house_item 44",
              mass_test_s = "hs_use_house_item 49",
              mass_test_m_a = "hs_use_house_item 47",
              mass_test_m_b = "hs_use_house_item 48",
              mass_test_l = "hs_use_house_item 46",
              a_60_house = "hs_use_house_item 68",
              a_60_house_noani = "hs_use_house_item 69",
              a_60_house_hideani = "hs_use_house_item 70",
              wienhouse_tri120h = "hs_use_house_item 71",
              wienhouse_tri60 = "hs_use_house_item 76",
              wienhouse_weird60 = "hs_use_house_item 77",
              wienhouse_weird120h = "hs_use_house_item 74",
              wienhouse_tri120 = "hs_use_house_item 78",
              wienhouse_tri120h_aimpoint = "hs_use_house_item 85"
            }
          },
          {
            name = "tower",
            children = {
              rebuild = "hs_rebuild",
              tower1 = "hs_use_house_item 4",
              tower2 = "hs_use_house_item 5",
              tower3 = "hs_use_house_item 6",
              tower4 = "hs_use_house_item 7",
              tower5 = "hs_use_house_item 8",
              wall_gap = "hs_use_house_item 25",
              tower_hi1 = "hs_use_house_item 66",
              tower_hi2 = "hs_use_house_item 67"
            }
          },
          {
            name = "wall",
            children = {
              rebuild = "hs_rebuild",
              wall = "hs_use_house_item 9",
              wall_hi = "hs_use_house_item 50",
              gate = "hs_use_house_item 28"
            }
          },
          {
            name = "stair",
            children = {
              rebuild = "hs_rebuild",
              stair = "hs_use_house_item 26",
              stair_m = "hs_use_house_item 27"
            }
          },
          {
            name = "keep",
            children = {
              rebuild = "hs_rebuild",
              stronghold = "hs_use_house_item 30"
            }
          },
          {
            name = "decoration",
            children = {
              "hs_decorate 1",
              "hs_decorate 2",
              "hs_decorate 3",
              "hs_decorate 4",
              "hs_decorate 5",
              "hs_decorate 6",
              "hs_decorate 7",
              "hs_decorate 8",
              "hs_decorate 9",
              "hs_decorate 10",
              "hs_decorate 11",
              "hs_decorate 12",
              "hs_decorate 13",
              "hs_decorate 14",
              "hs_decorate 15",
              "hs_decorate 16",
              "hs_decorate 17",
              "hs_decorate 18",
              "hs_decorate 19",
              "hs_decorate 20",
              "hs_decorate 21",
              "hs_decorate 22",
              "hs_decorate 23",
              "hs_decorate 24",
              "hs_decorate 25",
              "hs_decorate 26",
              "hs_decorate 27",
              "hs_decorate 28",
              "hs_decorate 29"
            }
          }
        }
      },
      {
        name = "Physics",
        children = {
          "hs_throwrock",
          "cp_world_raycasting_frontal_cone",
          "cp_world_water_level_casting"
        }
      },
      {
        name = "Mount",
        children = {
          mount_mate = "#X2Mate:MountMate()",
          unmount_mate = "#X2Mate:UnMountMate()"
        }
      },
      {
        name = "Camera",
        children = {
          shake_camera = "#TestShakeCamera()"
        }
      },
      {
        name = "Animation",
        children = {
          {
            name = "Animation Graph",
            children = {
              {
                name = "co",
                children = {
                  {
                    name = "attack[17]",
                    children = {
                      fist_co_attack_r = "player_animation_input fist_co_attack_r",
                      onehand_co_attack_r_slash = "player_animation_input onehand_co_attack_r_slash",
                      onehand_co_attack_r_slash_2 = "player_animation_input onehand_co_attack_r_slash_2",
                      onehand_co_attack_r_pierce = "player_animation_input onehand_co_attack_r_pierce",
                      onehand_co_attack_r_pierce_2 = "player_animation_input onehand_co_attack_r_pierce_2",
                      onehand_co_attack_r_blunt = "player_animation_input onehand_co_attack_r_blunt",
                      onehand_co_attack_r_blunt_2 = "player_animation_input onehand_co_attack_r_blunt_2",
                      onehand_co_attack_l_slash = "player_animation_input onehand_co_attack_l_slash",
                      onehand_co_attack_l_slash_2 = "player_animation_input onehand_co_attack_l_slash_2",
                      onehand_co_attack_l_pierce = "player_animation_input onehand_co_attack_l_pierce",
                      onehand_co_attack_l_pierce_2 = "player_animation_input onehand_co_attack_l_pierce_2",
                      onehand_co_attack_l_blunt = "player_animation_input onehand_co_attack_l_blunt",
                      onehand_co_attack_l_blunt_2 = "player_animation_input onehand_co_attack_l_blunt_2",
                      twohand_co_attack = "player_animation_input twohand_co_attack",
                      twohand_co_attack_2 = "player_animation_input twohand_co_attack_2",
                      staff_co_attack = "player_animation_input staff_co_attack",
                      staff_co_attack_2 = "player_animation_input staff_co_attack_2",
                      bow_co_attack = "player_animation_input bow_co_attack",
                      idle = "player_animation_input Action idle"
                    }
                  },
                  {
                    name = "skill-all, etc[22]",
                    children = {
                      all_co_sk_shout = "player_animation_input all_co_sk_shout",
                      all_co_sk_leapattack = "player_animation_input all_co_sk_leapattack",
                      all_co_sk_lowkick = "player_animation_input all_co_sk_lowkick",
                      fist_co_sk_fistattack = "player_animation_input fist_co_sk_fistattack",
                      all_co_sk_whirlewind = "player_animation_input all_co_sk_whirlewind",
                      bow_co_sk_cast = "player_animation_input Action bow_co_sk_cast",
                      bow_co_sk_launch = "player_animation_input bow_co_sk_launch",
                      bow_co_sk_launch_2 = "player_animation_input bow_co_sk_launch_2",
                      bow_co_sk_cast_3 = "player_animation_input Action bow_co_sk_cast_3",
                      bow_co_sk_launch_3 = "player_animation_input bow_co_sk_launch_3",
                      bow_co_sk_cast_4 = "player_animation_input Action bow_co_sk_cast_4",
                      bow_co_sk_launch_4 = "player_animation_input bow_co_sk_launch_4",
                      bow_co_sk_high_cast = "player_animation_input Action bow_co_sk_high_cast",
                      bow_co_sk_high_launch = "player_animation_input bow_co_sk_high_launch",
                      music_co_sk_lute_cast = "player_animation_input Action music_co_sk_lute_cast",
                      music_co_sk_pipe_cast = "player_animation_input Action music_co_sk_pipe_cast",
                      music_co_sk_drum_cast = "player_animation_input Action music_co_sk_drum_cast",
                      music_co_sk_lute_launch = "player_animation_input music_co_sk_lute_launch",
                      music_co_sk_pipe_launch = "player_animation_input music_co_sk_pipe_launch",
                      music_co_sk_drum_launch = "player_animation_input music_co_sk_drum_launch",
                      idle = "player_animation_input Action idle"
                    }
                  },
                  {
                    name = "skill-onehand[22]",
                    children = {
                      onehand_co_sk_weapon_pierce = "player_animation_input onehand_co_sk_weapon_pierce",
                      onehand_co_sk_weapon_pierce_2 = "player_animation_input onehand_co_sk_weapon_pierce_2",
                      onehand_co_sk_weapon_blunt = "player_animation_input onehand_co_sk_weapon_blunt",
                      onehand_co_sk_weapon_blunt_2 = "player_animation_input onehand_co_sk_weapon_blunt_2",
                      onehand_co_sk_weapon_blunt_3 = "player_animation_input onehand_co_sk_weapon_blunt_3",
                      onehand_co_sk_weapon_slash = "player_animation_input onehand_co_sk_weapon_slash",
                      onehand_co_sk_weapon_slash_2 = "player_animation_input onehand_co_sk_weapon_slash_2",
                      onehand_co_sk_shieldpush = "player_animation_input onehand_co_sk_shieldpush",
                      onehand_co_sk_throw = "player_animation_input onehand_co_sk_throw",
                      onehand_co_sk_cast = "player_animation_input Action onehand_co_sk_cast",
                      onehand_co_sk_windslash = "player_animation_input onehand_co_sk_windslash",
                      onehand_co_sk_shieldwield = "player_animation_input onehand_co_sk_shieldwield",
                      idle = "player_animation_input Action idle"
                    }
                  },
                  {
                    name = "skill-twohand[22]",
                    children = {
                      twohand_co_sk_weapon_pierce = "player_animation_input twohand_co_sk_weapon_pierce",
                      twohand_co_sk_weapon_pierce_2 = "player_animation_input twohand_co_sk_weapon_pierce_2",
                      twohand_co_sk_weapon_blunt = "player_animation_input twohand_co_sk_weapon_blunt",
                      twohand_co_sk_weapon_blunt_2 = "player_animation_input twohand_co_sk_weapon_blunt_2",
                      twohand_co_sk_weapon_blunt_3 = "player_animation_input twohand_co_sk_weapon_blunt_3",
                      twohand_co_sk_weapon_slash = "player_animation_input twohand_co_sk_weapon_slash",
                      twohand_co_sk_weapon_slash_2 = "player_animation_input twohand_co_sk_weapon_slash_2",
                      twohand_co_sk_windslash = "player_animation_input twohand_co_sk_windslash",
                      idle = "player_animation_input Action idle"
                    }
                  },
                  {
                    name = "spell[6]",
                    children = {
                      all_co_sk_spell_launch_d = "player_animation_input all_co_sk_spell_launch_d",
                      all_co_sk_spell_launch_nd = "player_animation_input all_co_sk_spell_launch_nd",
                      all_co_sk_spell_launch_meteor = "player_animation_input all_co_sk_spell_launch_meteor",
                      all_co_sk_spell_launch_spread = "player_animation_input all_co_sk_spell_launch_spread",
                      all_co_sk_spell_launch_field = "player_animation_input all_co_sk_spell_launch_field",
                      all_co_sk_spell_cast_d = "player_animation_input Action all_co_sk_spell_cast_d",
                      all_co_sk_spell_cast_nd = "player_animation_input Action all_co_sk_spell_cast_nd",
                      all_co_sk_spell_cast_meteor = "player_animation_input Action all_co_sk_spell_cast_meteor",
                      all_co_sk_spell_channel_d = "player_animation_input Action all_co_sk_spell_channel_d",
                      all_co_sk_spell_channel_nd = "player_animation_input Action all_co_sk_spell_channel_nd",
                      all_co_sk_spell_channel_sorb = "player_animation_input Action all_co_sk_spell_channel_sorb",
                      all_co_sk_spell_channel_tug = "player_animation_input Action all_co_sk_spell_channel_tug",
                      all_co_sk_spell_channel_field = "player_animation_input Action all_co_sk_spell_channel_field",
                      all_co_sk_buff_launch_mana = "player_animation_input all_co_sk_buff_launch_mana",
                      all_co_sk_buff_launch_mental = "player_animation_input all_co_sk_buff_launch_mental",
                      all_co_sk_buff_launch_defense = "player_animation_input all_co_sk_buff_launch_defense",
                      all_co_sk_buff_launch_force = "player_animation_input all_co_sk_buff_launch_force",
                      all_co_sk_buff_launch_special = "player_animation_input all_co_sk_buff_launch_special",
                      all_co_sk_buff_cast_mana = "player_animation_input Action all_co_sk_buff_cast_mana",
                      all_co_sk_buff_cast_mental = "player_animation_input Action all_co_sk_buff_cast_mental",
                      all_co_sk_buff_cast_defense = "player_animation_input Action all_co_sk_buff_cast_defense",
                      all_co_sk_buff_channel_force = "player_animation_input Action all_co_sk_buff_channel_force",
                      all_co_sk_buff_channel_special = "player_animation_input Action all_co_sk_buff_channel_special",
                      idle = "player_animation_input Action idle"
                    }
                  }
                }
              },
              {
                name = "re",
                children = {
                  onehand_re_combat_parry = "player_animation_input onehand_re_combat_parry",
                  twohand_re_combat_parry = "player_animation_input twohand_re_combat_parry",
                  onehand_re_combat_shieldblock = "player_animation_input onehand_re_combat_shieldblock",
                  all_re_combat_dodge = "player_animation_input all_re_combat_dodge",
                  all_re_combat_hit = "player_animation_input all_re_combat_hit",
                  all_re_combat_critical = "player_animation_input all_re_combat_critical",
                  all_re_combat_stun = "player_animation_input Action all_re_combat_stun",
                  all_re_combat_struggle = "player_animation_input Action all_re_combat_struggle",
                  idle = "player_animation_input Action idle"
                }
              },
              {
                name = "expression",
                children = {
                  happy = "player_animation_input fist_em_happy",
                  cry = "player_animation_input fist_em_cry",
                  amaze = "player_animation_input fist_em_amaze",
                  lonely = "player_animation_input fist_em_lonely",
                  bored = "player_animation_input fist_em_bored",
                  bow = "player_animation_input fist_em_bow",
                  question = "player_animation_input fist_em_question",
                  angry = "player_animation_input fist_em_angry",
                  beg = "player_animation_input fist_em_beg",
                  clap = "player_animation_input fist_em_clap",
                  greet = "player_animation_input fist_em_greet",
                  bye = "player_animation_input fist_em_bye",
                  laugh = "player_animation_input fist_em_laugh",
                  fear = "player_animation_input fist_em_fear",
                  no = "player_animation_input fist_em_no",
                  point = "player_animation_input fist_em_point",
                  loud = "player_animation_input fist_em_loud",
                  fight = "player_animation_input fist_em_fight",
                  shy = "player_animation_input fist_em_shy",
                  eat = "player_animation_input fist_em_eat",
                  yawn = "player_animation_input fist_em_yawn",
                  sweat = "player_animation_input fist_em_sweat",
                  cough = "player_animation_input fist_em_cough",
                  idle = "player_animation_input Action idle"
                }
              },
              {
                name = "special",
                children = {
                  idle = "player_animation_input Action idle",
                  talk = "player_animation_input fist_ac_talk_01",
                  talk_2 = "player_animation_input fist_ac_talk_02",
                  drink = "player_animation_input fist_ac_drink",
                  operate = "player_animation_input Action fist_ac_operate",
                  operate_end = "player_animation_input fist_ac_operate_end",
                  pickup = "player_animation_input Action fist_ac_pickup",
                  pickup_end = "player_animation_input fist_ac_pickup_end",
                  dig_start = "player_animation_input Action fist_ac_dig",
                  dig_end = "player_animation_input fist_ac_dig_end",
                  sit_down_start_01 = "player_animation_input Action fist_ac_sit_down_01",
                  sit_up = "player_animation_input Action idle",
                  cook_start_01 = "player_animation_input Action fist_ac_cook_01",
                  cook_end_01 = "player_animation_input fist_ac_cook_end_01",
                  smith_start_01 = "player_animation_input Action fist_ac_smith_01",
                  smith_end_01 = "player_animation_input fist_ac_smith_end_01",
                  fist_ac_sewing = "player_animation_input Action fist_ac_sewing",
                  fist_ac_felly_loop = "player_animation_input Action fist_ac_felly",
                  fist_ac_hammer_loop = "player_animation_input Action fist_ac_hammer",
                  fist_ac_sawing_loop = "player_animation_input Action fist_ac_sawing",
                  fist_ac_blow_loop = "player_animation_input Action fist_ac_blow",
                  fist_ac_making_loop = "player_animation_input Action fist_ac_making"
                }
              }
            }
          },
          {
            name = "Physic simulation",
            children = {
              knockdown = "ragdoll_test 0",
              knockback = "ragdoll_test 1",
              hit = "ragdoll_test 2",
              dead = "ragdoll_test 3",
              alive = "ragdoll_test 4",
              spectator = "ragdoll_test 5",
              frozen = "ragdoll_test 6",
              ragdoll = "ragdoll_test 7"
            }
          }
        }
      },
      {
        name = "ActionBar",
        children = {
          ability_learn_skill_all = "ability_learn_skill all",
          fill_actionbar_mage_type = "#FillActionBarMageType()",
          fill_actionbar_warrior_type = "#FillActionBarWarriorType()",
          fill_actionbar_ranger_type = "#FillActionBarRangerType()",
          fill_actionbar_priest_type = "#FillActionBarPriestType()"
        }
      },
      {
        name = "PetBar",
        children = {
          skill_1 = "#X2Mount:StartMountSkill(1)",
          skill_2 = "#X2Mount:StartMountSkill(2)",
          skill_3 = "#X2Mount:StartMountSkill(3)",
          skill_4 = "#X2Mount:StartMountSkill(4)",
          skill_5 = "#X2Mount:StartMountSkill(5)",
          skill_6 = "#X2Mount:StartMountSkill(6)",
          skill_7 = "#X2Mount:StartMountSkill(7)",
          skill_8 = "#X2Mount:StartMountSkill(8)",
          skill_9 = "#X2Mount:StartMountSkill(9)",
          skill_10 = "#X2Mount:StartMountSkill(10)",
          cheat_npc = "gm spawn_npc 127",
          cheat_max_health = "gm_target attr max_health 40000",
          cheat_health = "gm_target health 40000",
          cheat_dontmove = "gm_target attr move_speed_mul -300"
        }
      },
      {
        name = "Milestone",
        children = {
          {
            name = "WhiteForest",
            children = {
              veldura = "goto 1546 616 166",
              hotel_veldura = "goto 1499 764 156",
              guardian_village = "goto 2602 1161 219",
              ferry = "goto 2110 549 180"
            }
          },
          {
            name = "Solzreed",
            children = {
              solzreed = "goto 3057 871 156",
              harbor = "goto 2919 598 107",
              store = "goto 3002 829 150",
              enemy = "goto 3026 403 120"
            }
          },
          {
            name = "Gweonid",
            children = {
              forest = "goto 2691 2528 286",
              startPos = "goto 1176 1770 380"
            }
          }
        }
      },
      {
        name = "World Location",
        children = {
          save_location_0 = "world_save_location 0",
          save_location_1 = "world_save_location 1",
          save_location_2 = "world_save_location 2",
          save_location_3 = "world_save_location 3",
          save_location_4 = "world_save_location 4",
          save_location_5 = "world_save_location 5",
          save_location_6 = "world_save_location 6",
          save_location_7 = "world_save_location 7",
          save_location_8 = "world_save_location 8",
          save_location_9 = "world_save_location 9",
          goto_location_0 = "world_goto_location 0",
          goto_location_1 = "world_goto_location 1",
          goto_location_2 = "world_goto_location 2",
          goto_location_3 = "world_goto_location 3",
          goto_location_4 = "world_goto_location 4",
          goto_location_5 = "world_goto_location 5",
          goto_location_6 = "world_goto_location 6",
          goto_location_7 = "world_goto_location 7",
          goto_location_8 = "world_goto_location 8",
          goto_location_9 = "world_goto_location 9"
        }
      },
      {
        name = "Bot",
        children = {Bot_Controll_Window = ToggleAutomaticDrivingSystemWnd}
      },
      {
        name = "AI test",
        children = {
          Prepare_AI_Test = "#PrepareAITest()",
          End_AI_Test = "#EndAITest()"
        }
      }
    }
  }
  do
    local adsWnd = CreateWindow("automaticDrivingSystemWnd", "UIParent")
    adsWnd:SetExtent(510, 400)
    adsWnd:AddAnchor("TOPLEFT", "UIParent", 300, 300)
    adsWnd:Clickable(true)
    adsWnd:Show(false)
    adsWnd.startLocLabel = W_CTRL.CreateLabel("ads.startLocLabel", adsWnd)
    adsWnd.startLocLabel:SetExtent(80, 40)
    adsWnd.startLocLabel.style:SetAlign(ALIGN_RIGHT)
    adsWnd.startLocLabel:SetText("Start")
    adsWnd.startLocLabel:AddAnchor("TOPLEFT", adsWnd, 40, 50)
    adsWnd.startLocEdit = W_CTRL.CreateEdit("ads.startLocEdit", adsWnd)
    adsWnd.startLocEdit:SetExtent(50, 40)
    adsWnd.startLocEdit:AddAnchor("LEFT", adsWnd.startLocLabel, "RIGHT", 10, 0)
    adsWnd.startLocEdit:SetDigit(true)
    adsWnd.startLocEdit:SetDigitMax(9)
    adsWnd.startLocEdit:SetText("0")
    adsWnd.endLocLabel = W_CTRL.CreateLabel("ads.endLocLabel", adsWnd)
    adsWnd.endLocLabel:SetExtent(50, 40)
    adsWnd.endLocLabel.style:SetAlign(ALIGN_RIGHT)
    adsWnd.endLocLabel:SetText("End")
    adsWnd.endLocLabel:AddAnchor("LEFT", adsWnd.startLocEdit, "RIGHT", 20, 0)
    adsWnd.endLocEdit = W_CTRL.CreateEdit("ads.endLocEdit", adsWnd)
    adsWnd.endLocEdit:SetExtent(50, 40)
    adsWnd.endLocEdit:AddAnchor("LEFT", adsWnd.endLocLabel, "RIGHT", 10, 0)
    adsWnd.endLocEdit:SetDigit(true)
    adsWnd.endLocEdit:SetDigitMax(9)
    adsWnd.endLocEdit:SetText("9")
    adsWnd.currLocLbl = W_CTRL.CreateLabel("ads.currLocLbl", adsWnd)
    adsWnd.currLocLbl:SetExtent(50, 50)
    adsWnd.currLocLbl:AddAnchor("LEFT", adsWnd.endLocEdit, "RIGHT", 50, 0)
    adsWnd.speedLbl = W_CTRL.CreateLabel("ads.speedLbl", adsWnd)
    adsWnd.speedLbl:SetExtent(80, 50)
    adsWnd.speedLbl.style:SetAlign(ALIGN_RIGHT)
    adsWnd.speedLbl:AddAnchor("TOPLEFT", adsWnd.startLocLabel, "BOTTOMLEFT", 0, 10)
    adsWnd.speedLbl:SetText(string.format("Speed(%s)", locale.util.speed_unit))
    adsWnd.speedEdit = W_CTRL.CreateEdit("ads.speedEdit", adsWnd)
    adsWnd.speedEdit:SetExtent(50, 40)
    adsWnd.speedEdit:AddAnchor("LEFT", adsWnd.speedLbl, "RIGHT", 10, 0)
    adsWnd.speedEdit:SetDigit(true)
    adsWnd.speedEdit:SetText("10")
    adsWnd.rotationLbl = W_CTRL.CreateLabel("ads.rotationLbl", adsWnd)
    adsWnd.rotationLbl:SetExtent(100, 50)
    adsWnd.rotationLbl.style:SetAlign(ALIGN_RIGHT)
    adsWnd.rotationLbl:AddAnchor("LEFT", adsWnd.speedEdit, "RIGHT", 20, 0)
    adsWnd.rotationLbl:SetText("Rotation(deg/s)")
    adsWnd.rotationEdit = W_CTRL.CreateEdit("ads.rotationEdit", adsWnd)
    adsWnd.rotationEdit:SetExtent(50, 40)
    adsWnd.rotationEdit:AddAnchor("LEFT", adsWnd.rotationLbl, "RIGHT", 10, 0)
    adsWnd.rotationEdit:SetDigit(true)
    adsWnd.rotationEdit:SetText("10")
    adsWnd.loopLbl = W_CTRL.CreateLabel("ads.loopLbl", adsWnd)
    adsWnd.loopLbl:SetExtent(80, 50)
    adsWnd.loopLbl.style:SetAlign(ALIGN_RIGHT)
    adsWnd.loopLbl:AddAnchor("TOPLEFT", adsWnd.speedLbl, "BOTTOMLEFT", 0, 10)
    adsWnd.loopLbl:SetText("Loop")
    adsWnd.loopEdit = W_CTRL.CreateEdit("ads.loopEdit", adsWnd)
    adsWnd.loopEdit:SetExtent(50, 40)
    adsWnd.loopEdit:AddAnchor("LEFT", adsWnd.loopLbl, "RIGHT", 10, 0)
    adsWnd.loopEdit:SetDigit(true)
    adsWnd.loopEdit:SetText("10")
    adsWnd.currLoopLbl = W_CTRL.CreateLabel("ads.currLoopLbl", adsWnd)
    adsWnd.currLoopLbl:SetExtent(50, 50)
    adsWnd.currLoopLbl:AddAnchor("LEFT", adsWnd.loopEdit, "RIGHT", 50, 0)
    adsWnd.OnLbl = W_CTRL.CreateLabel("ads.OnLbl", adsWnd)
    adsWnd.OnLbl:SetExtent(50, 50)
    adsWnd.OnLbl.style:SetAlign(ALIGN_RIGHT)
    adsWnd.OnLbl:AddAnchor("BOTTOM", adsWnd, "BOTTOM", 0, -50)
    adsWnd.OnLbl:SetText("")
    local onBtn = adsWnd:CreateChildWidget("button", "onBtn", 0, true)
    onBtn:SetText("Toggle")
    ApplyButtonSkin(onBtn, BUTTON_BASIC.DEFAULT)
    onBtn:AddAnchor("LEFT", adsWnd.OnLbl, "RIGHT", 10, 0)
    function adsWnd:UpdateADS()
      local On = X2Bot:IsActive()
      if On then
        adsWnd.OnLbl:SetText("On")
      else
        adsWnd.OnLbl:SetText("Off")
      end
      local curr = X2Bot:GetLocationFollowerCurrent()
      local currLoop = X2Bot:GetLocationFollowerCurrentLoop()
      adsWnd.currLocLbl:SetText(string.format("Curr : %d", curr))
      adsWnd.currLoopLbl:SetText(string.format("Curr : %d", currLoop))
    end
    local function ToggleADS()
      local On = not X2Bot:IsActive()
      X2Bot:Activate(On)
      if On then
        local startLoc = tonumber(adsWnd.startLocEdit:GetText())
        local endLoc = tonumber(adsWnd.endLocEdit:GetText())
        local speed = tonumber(adsWnd.speedEdit:GetText())
        local rotation = tonumber(adsWnd.rotationEdit:GetText())
        local loop = tonumber(adsWnd.loopEdit:GetText())
        X2Bot:SetControllerType(BCT_LOCATION_FOLLOWER)
        X2Bot:SetLocationFollowerParam(startLoc, endLoc, loop, speed, rotation)
      end
    end
    adsWnd:SetHandler("OnUpdate", adsWnd.UpdateADS)
    adsWnd.onBtn:SetHandler("OnClick", ToggleADS)
    function ToggleAutomaticDrivingSystemWnd()
      adsWnd:Show(not adsWnd:IsVisible())
    end
    function PrepareAITest()
      Console:ExecuteString("gm mode invincible 0")
      Console:ExecuteString("gm invisible 0")
      Console:ExecuteString("ai_DebugDraw 71")
      Console:ExecuteString("ai_drawRefPoints all")
      Console:ExecuteString("ai_drawPath all")
      CmdButton1:OnClick("LeftButton")
    end
    function EndAITest()
      Console:ExecuteString("ai_DebugDraw 0")
      CmdButton1:OnClick("LeftButton")
    end
    local debugBar = CreateEmptyWindow("debugBar", "UIParent")
    debugBar:SetExtent(100, 100)
    debugBar:AddAnchor("BOTTOMRIGHT", -60, -100)
    function getTableSize(t)
      local size = 0
      for _, _ in pairs(t) do
        size = size + 1
      end
      return size
    end
    function LogArgs(...)
      for i = 1, select("#", ...) do
        local arg = select(i, ...)
        UIParent:LogAlways(arg)
      end
    end
    function HidePopUpWindow(popUpWindow)
      for k, v in pairs(popUpWindow.subWindows) do
        v:Show(false)
        HidePopUpWindow(v)
      end
    end
    local PairsByKeys = function(t, f)
      local a = {}
      for n in pairs(t) do
        table.insert(a, n)
      end
      table.sort(a, f)
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
    function Parse_CmdSubTree(name, subTable)
      local childrenWindow = CreateEmptyWindow(name .. "Window", "UIParent")
      local childrenCount = getTableSize(subTable.children)
      childrenWindow:SetExtent(200, childrenCount * 26)
      childrenWindow:Show(false)
      childrenWindow.subWindows = {}
      local idx = 0
      for k, v in PairsByKeys(subTable.children) do
        if type(v) == "string" or type(v) == "function" then
          local newLeafButton = CreateEmptyButton(name .. idx + 1, childrenWindow)
          newLeafButton:SetExtent(200, 30)
          newLeafButton.style:SetAlign(ALIGN_LEFT)
          newLeafButton:SetInset(12, 5, 5, 7)
          newLeafButton:AddAnchor("BOTTOM", childrenWindow, "BOTTOM", 0, -25 * idx)
          ApplyButtonSkin(newLeafButton, BUTTON_BASIC.DEFAULT)
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
            local subChildWindow = Parse_CmdSubTree(name .. idx + 1, v)
            local newLeafButton = CreateEmptyButton(name .. idx + 1, childrenWindow)
            ApplyButtonSkin(newLeafButton, BUTTON_BASIC.DEFAULT)
            newLeafButton:SetExtent(200, 30)
            newLeafButton.style:SetAlign(ALIGN_LEFT)
            newLeafButton:AddAnchor("BOTTOM", childrenWindow, "BOTTOM", 0, -25 * idx)
            newLeafButton:SetText("< " .. v.name)
            newLeafButton:SetInset(12, 5, 5, 7)
            subChildWindow:AddAnchor("BOTTOMRIGHT", newLeafButton, "BOTTOMLEFT", 0, 0)
            childrenWindow.subWindows[k] = subChildWindow
            function newLeafButton:OnClick(arg)
              if arg == "LeftButton" then
                local setVisibleValue = not subChildWindow:IsVisible()
                HidePopUpWindow(childrenWindow)
                subChildWindow:Show(setVisibleValue)
              end
            end
            newLeafButton:SetHandler("OnClick", newLeafButton.OnClick)
          end
        end
        idx = idx + 1
      end
      return childrenWindow
    end
    local CmdButton1 = CreateEmptyButton("CmdButton1", debugBar)
    ApplyButtonSkin(CmdButton1, BUTTON_BASIC.DEFAULT)
    CmdButton1:SetExtent(100, 33)
    CmdButton1:AddAnchor("TOP", debugBar, 0, 0)
    CmdButton1:SetText(consoleCommandTree.name)
    local cmdButton1Window = Parse_CmdSubTree("CmdButton1", consoleCommandTree)
    cmdButton1Window:AddAnchor("BOTTOMRIGHT", CmdButton1, "BOTTOMLEFT", 0, 0)
    function CmdButton1:OnClick(arg)
      if arg == "LeftButton" then
        local setVisibleValue = not cmdButton1Window:IsVisible()
        HidePopUpWindow(cmdButton1Window)
        cmdButton1Window:Show(setVisibleValue)
      end
    end
    CmdButton1:SetHandler("OnClick", CmdButton1.OnClick)
    local CmdButton2 = CreateEmptyButton("CmdButton2", debugBar)
    ApplyButtonSkin(CmdButton2, BUTTON_BASIC.DEFAULT)
    CmdButton2:SetExtent(100, 33)
    CmdButton2:AddAnchor("TOP", debugBar, 0, 33)
    CmdButton2:SetText("Hit")
    function CmdButton2:OnClick(arg)
      if arg == "LeftButton" then
        X2Unit:ImpulseUnit("target", 33)
      end
    end
    CmdButton2:SetHandler("OnClick", CmdButton2.OnClick)
    X2Hotkey:SetTemporaryBindingButton("CmdButton2", "CTRL-F10")
    local CmdButton3 = CreateEmptyButton("CmdButton3", debugBar)
    ApplyButtonSkin(CmdButton3, BUTTON_BASIC.DEFAULT)
    CmdButton3:SetExtent(100, 33)
    CmdButton3:AddAnchor("TOP", debugBar, 0, 66)
    CmdButton3:SetText("Go")
    function CmdButton3:OnClick(arg)
      if arg == "LeftButton" then
        X2Unit:MoveUnit("player")
      end
    end
    CmdButton3:SetHandler("OnClick", CmdButton3.OnClick)
    X2Hotkey:SetTemporaryBindingButton("CmdButton3", "CTRL-F5")
    if Script.LoadScript("SCRIPTS/x2ui/hud/debug_bar_local.lua") then
      do
        local CmdButton4 = CreateEmptyButton("CmdButton4", debugBar)
        ApplyButtonSkin(CmdButton4, BUTTON_BASIC.DEFAULT)
        CmdButton4:SetExtent(100, 33)
        CmdButton4:AddAnchor("TOP", debugBar, 0, 99)
        CmdButton4:SetText(localConsoleCommandTree.name)
        local cmdButton4Window = Parse_CmdSubTree("CmdButton4", localConsoleCommandTree)
        cmdButton4Window:AddAnchor("BOTTOMRIGHT", CmdButton4, "BOTTOMLEFT", 0, 0)
        function CmdButton4:OnClick(arg)
          if arg == "LeftButton" then
            local setVisibleValue = not cmdButton4Window:IsVisible()
            HidePopUpWindow(cmdButton4Window)
            cmdButton4Window:Show(setVisibleValue)
          end
        end
        CmdButton4:SetHandler("OnClick", CmdButton4.OnClick)
      end
    end
    debugBar:Show(true)
    function DD()
      if debugBar:IsVisible() then
        debugBar:Show(false)
      else
        debugBar:Show(true)
      end
    end
    function Loveev()
      local abilityCount = X2Ability:NumActiveAbility()
      local ability = X2Ability:GetActiveAbility()
      local actionIdx = 1
      for i = 1, abilityCount do
        local skillCount = X2Ability:GetNumSkillsByAbility(ability[i].type + 1)
        for j = 1, skillCount do
          local skillInfo = X2Ability:GetSpellBookSkillByAbility(ability[i].type + 1, j)
          if skillInfo ~= nil and skillInfo.skillId ~= nil then
            X2Action:SetActionSpell(actionIdx, skillInfo.skillId)
            actionIdx = actionIdx + 1
          end
        end
      end
      X2Debug:ReloadScreen()
    end
    function Loveev2(ability)
      local actionIdx = 1
      for i = 1, #AbilityType do
        if AbilityType[i] == ability then
          local skillCount = X2Ability:GetNumSkillsByAbility(i)
          for j = 1, skillCount do
            local skillInfo = X2Ability:GetSpellBookSkillByAbility(i, j)
            if skillInfo ~= nil and skillInfo.skillId ~= nil then
              X2Action:SetActionSpell(actionIdx, skillInfo.skillId)
              actionIdx = actionIdx + 1
            end
          end
        end
      end
      X2Debug:ReloadScreen()
    end
    function ClearLoveev()
      for i = 1, 20 do
        X2Action:ClearAction(i)
      end
      X2Debug:ReloadScreen()
    end
    function FillActionBarMageType()
      X2Action:SetActionSpell(1, 10159)
      X2Action:SetActionSpell(2, 10128)
      X2Action:SetActionSpell(3, 10167)
      X2Action:SetActionSpell(4, 10161)
      X2Action:SetActionSpell(5, 10169)
      X2Action:SetActionSpell(6, 10180)
      X2Action:SetActionSpell(7, 10447)
      X2Action:SetActionSpell(8, 10451)
      X2Action:SetActionSpell(9, 10434)
      X2Action:SetActionSpell(10, 10106)
      X2Action:SetActionSpell(11, 10137)
      X2Action:SetActionSpell(12, 10117)
      X2Action:SetActionSpell(13, 10118)
      X2Action:SetActionSpell(14, 10154)
      X2Action:SetActionSpell(15, 10119)
      X2Action:SetActionSpell(16, 10152)
      X2Action:SetActionSpell(17, 10151)
      X2Action:SetActionSpell(18, 10153)
      X2Action:SetActionSpell(19, 10156)
      X2Action:SetActionSpell(20, 10160)
    end
    function FillActionBarWarriorType()
      X2Action:SetActionSpell(1, 10394)
      X2Action:SetActionSpell(2, 10399)
      X2Action:SetActionSpell(3, 10389)
      X2Action:SetActionSpell(4, 10396)
      X2Action:SetActionSpell(5, 10395)
      X2Action:SetActionSpell(6, 10443)
      X2Action:SetActionSpell(7, 10370)
      X2Action:SetActionSpell(8, 10400)
      X2Action:SetActionSpell(9, 10388)
      X2Action:SetActionSpell(10, 10372)
      X2Action:SetActionSpell(11, 10441)
      X2Action:SetActionSpell(12, 10378)
      X2Action:SetActionSpell(13, 10390)
      X2Action:SetActionSpell(14, 10193)
      X2Action:SetActionSpell(15, 10189)
      X2Action:SetActionSpell(16, 10401)
      X2Action:SetActionSpell(17, 10384)
      X2Action:SetActionSpell(18, 10377)
      X2Action:SetActionSpell(19, 10376)
      X2Action:SetActionSpell(20, 10191)
    end
    function FillActionBarRangerType()
    end
    function FillActionBarPriestType()
    end
    local tsi = {
      ax = 5,
      ay = 5,
      az = 0,
      sx = 10,
      sy = 10,
      sz = 10,
      d = 1.5,
      f = 0.1,
      r = 2
    }
    function TestShakeCamera()
      X2Camera:ShakeCamera(tsi)
    end
    function ShowPetExp(mateType)
      local percentexp, currentExp, prevLevelTotalExp, forLevelupExp = X2Mate:GetPetExpToNextLevel(mateType)
      local currentLevelExp = currentExp - prevLevelTotalExp
    end
    function AttachEffectDrawableTimeEditor(effectDrawables)
      if effectDrawables == nil or type(effectDrawables) ~= "table" or #effectDrawables == 0 then
        UIParent:LogAlways("effectDrawables must be table!!")
        return
      end
      for i = 1, #effectDrawables do
        if effectDrawables[i].GetEffectPhaseCount == nil then
          UIParent:LogAlways(i .. "th effectDrawable is not EffectDrawable!!")
          return
        end
      end
      local width = 800
      local height = 620
      local scrollDummy = 10
      local timeDivider = 100
      local propertyDisplayFormat = "%s : %s"
      local propertyEditorFormat = " / " .. timeDivider .. " => %s"
      local effectDrawableController = CreateWindow("effectDrawableController", "UIParent")
      effectDrawableController:EnableHidingIsRemove(true)
      effectDrawableController:SetExtent(width, height)
      effectDrawableController:AddAnchor("CENTER", "UIParent", 0, 0)
      effectDrawableController.effectDrawables = effectDrawables
      local function CreatePhaseDetailView(parent, properties, propertyKey, anchorTarget)
        parent:CreateChildWidget("label", propertyKey, 0, true)
        local propertWidget = parent[propertyKey]
        propertWidget:SetExtent(width / 4, FONT_SIZE.MIDDLE)
        propertWidget:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, 3)
        propertWidget:SetInset(5, 0, 0, 0)
        propertWidget.style:SetColor(0, 0, 0, 1)
        propertWidget.style:SetAlign(ALIGN_LEFT)
        propertWidget:SetText(string.format(propertyDisplayFormat, propertyKey, tostring(properties[propertyKey])))
        local input = W_CTRL.CreateEdit("input", propertWidget)
        input:SetDigit(true)
        input:AddAnchor("LEFT", propertWidget, "RIGHT", 0, 0)
        input:SetExtent(width / 8, FONT_SIZE.MIDDLE)
        input.style:SetColor(0, 0, 0, 1)
        input:SetText(tostring(properties[propertyKey] * timeDivider))
        propertWidget:CreateChildWidget("label", "inputResult", 0, true)
        propertWidget.inputResult:SetExtent(width / 8, FONT_SIZE.MIDDLE)
        propertWidget.inputResult:AddAnchor("LEFT", input, "RIGHT", 0, 0)
        propertWidget.inputResult.style:SetColor(0, 0, 0, 1)
        propertWidget.inputResult.style:SetAlign(ALIGN_LEFT)
        propertWidget.inputResult:SetText(string.format(propertyEditorFormat, tostring(properties[propertyKey])))
        local input = propertWidget.input
        function input:OnTextChanged()
          local newValue = tonumber(self:GetText()) / timeDivider
          propertWidget.inputResult:SetText(string.format(propertyEditorFormat, tostring(newValue)))
        end
        input:SetHandler("OnTextChanged", input.OnTextChanged)
        local bg = propertWidget.input:CreateColorDrawable(0.7, 0.7, 0.7, 1, "background")
        bg:AddAnchor("TOPLEFT", propertWidget.input, "TOPLEFT", 0, 0)
        bg:AddAnchor("BOTTOMRIGHT", propertWidget.inputResult, "BOTTOMRIGHT", 0, 0)
        parent.totalHeight = parent.totalHeight + FONT_SIZE.MIDDLE + 3
      end
      local function CreatePhaseView(parent, id, phaseTitle, index, properties, anchorTarget)
        local phase = parent:CreateChildWidget("emptywidget", id, index, true)
        phase:SetWidth(width / 2)
        phase.anchorYOffset = 0
        if index == 1 then
          phase:AddAnchor("TOPLEFT", anchorTarget, "TOPLEFT", 0, phase.anchorYOffset)
        else
          phase.anchorYOffset = 10
          phase:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, phase.anchorYOffset)
        end
        phase:CreateChildWidget("label", "phaseIndex", 0, true)
        phase.phaseIndex:SetExtent(width / 2, FONT_SIZE.MIDDLE)
        phase.phaseIndex:AddAnchor("TOPLEFT", phase, "TOPLEFT", 0, 0)
        phase.phaseIndex:SetInset(5, 0, 0, 0)
        phase.phaseIndex.style:SetColor(0, 0, 0, 1)
        phase.phaseIndex.style:SetAlign(ALIGN_LEFT)
        phase.phaseIndex:SetText("--- " .. phaseTitle .. " " .. index .. " ---")
        phase.totalHeight = FONT_SIZE.MIDDLE
        local detailAnchorTarget = phase.phaseIndex
        for k, v in pairs(properties) do
          CreatePhaseDetailView(phase, properties, k, detailAnchorTarget)
          detailAnchorTarget = phase[k]
        end
        phase:SetHeight(phase.totalHeight)
        return phase
      end
      local drawableTab = effectDrawableController:CreateChildWidget("tab", "drawableTab", 0, true)
      drawableTab:AddAnchor("TOPLEFT", effectDrawableController, "TOPLEFT", 0, effectDrawableController.titleBar:GetHeight())
      drawableTab:AddAnchor("TOPRIGHT", effectDrawableController, "TOPRIGHT", 0, 0)
      drawableTab:SetCorner("TOPLEFT")
      for i = 1, #effectDrawables do
        drawableTab:AddSimpleTab(tostring(i))
      end
      for i = 1, #drawableTab.window do
        ApplyButtonSkin(drawableTab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
        ApplyButtonSkin(drawableTab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
      end
      drawableTab:SetGap(0)
      for di = 1, #effectDrawables do
        local effectPhaseGroup = CreateScrollWindow(drawableTab.window[di], "effectPhaseGroup", 0)
        effectPhaseGroup:SetExtent(width / 2, 540)
        effectPhaseGroup:AddAnchor("TOPLEFT", drawableTab.window[di], "TOPLEFT", 0, 0)
        local effectPhaseCount = effectDrawables[di]:GetEffectPhaseCount()
        local anchorTarget = effectPhaseGroup.content
        local totalHeightForScroll = scrollDummy
        for i = 1, effectPhaseCount do
          local properties = effectDrawables[di]:GetEffectPhaseProperties(i)
          local phase = CreatePhaseView(effectPhaseGroup.content, "effectPhase", "EffectPhase", i, properties, anchorTarget)
          anchorTarget = phase
          totalHeightForScroll = totalHeightForScroll + phase.totalHeight + phase.anchorYOffset
        end
        effectPhaseGroup:ResetScroll(totalHeightForScroll)
        local moveEffectPhaseGroup = CreateScrollWindow(drawableTab.window[di], "moveEffectPhaseGroup", 0)
        moveEffectPhaseGroup:SetExtent(width / 2, 540)
        moveEffectPhaseGroup:AddAnchor("TOPRIGHT", drawableTab.window[di], "TOPRIGHT", 0, 0)
        local moveEffectPhaseCount = effectDrawables[di]:GetMoveEffectPhaseCount()
        anchorTarget = moveEffectPhaseGroup.content
        totalHeightForScroll = scrollDummy
        for i = 1, moveEffectPhaseCount do
          local properties = effectDrawables[di]:GetMoveEffectPhaseProperties(i)
          local phase = CreatePhaseView(moveEffectPhaseGroup.content, "moveEffectPhase", "MoveEffectPhase", i, properties, anchorTarget)
          anchorTarget = phase
          totalHeightForScroll = totalHeightForScroll + phase.totalHeight + phase.anchorYOffset
        end
        moveEffectPhaseGroup:ResetScroll(totalHeightForScroll)
      end
      local applyButton = effectDrawableController:CreateChildWidget("button", "applyButton", 0, true)
      ApplyButtonSkin(applyButton, BUTTON_BASIC.DEFAULT)
      applyButton:SetExtent(50, 30)
      applyButton.style:SetAlign(ALIGN_CENTER)
      applyButton:AddAnchor("TOPLEFT", effectDrawableController, "TOPLEFT", 10, 10)
      applyButton:SetText("Apply")
      local checkbox = CreateCheckButton(effectDrawableController:GetId() .. ".checkbox", effectDrawableController, "restart with relative effect drawables")
      checkbox:SetChecked(false)
      checkbox:AddAnchor("LEFT", applyButton, "RIGHT", 10, 0)
      function applyButton:OnClick()
        local selectedTabIndex = effectDrawableController.drawableTab:GetSelectedTab()
        for di = 1, #effectDrawables do
          effectDrawables[di]:SetStartEffect(false)
          local currentTab = effectDrawableController.drawableTab.window[di]
          local effectPhaseCount = effectDrawables[di]:GetEffectPhaseCount()
          for i = 1, effectPhaseCount do
            local phase = currentTab.effectPhaseGroup.content.effectPhase[i]
            local properties = effectDrawables[di]:GetEffectPhaseProperties(i)
            local needUpdate = false
            local newData = {}
            for k, v in pairs(properties) do
              local newValue = tonumber(phase[k].input:GetText()) / timeDivider
              if v ~= newValue then
                needUpdate = true
                newData[k] = newValue
              else
                newData[k] = v
              end
            end
            if needUpdate then
              if effectDrawables[di]:SetEffectPhaseProperties(i, newData) == false then
                AddMessageToNotifyMessage("Failed to apply EffectPhase " .. i .. " properties!")
              else
                for k, v in pairs(newData) do
                  phase[k]:SetText(string.format(propertyDisplayFormat, k, tostring(newData[k])))
                end
              end
            end
          end
          local moveEffectPhaseCount = effectDrawables[di]:GetMoveEffectPhaseCount()
          for i = 1, moveEffectPhaseCount do
            local phase = currentTab.effectPhaseGroup.content.moveEffectPhase[i]
            local properties = effectDrawables[di]:GetMoveEffectPhaseProperties(i)
            local needUpdate = false
            local newData = {}
            for k, v in pairs(properties) do
              local newValue = tonumber(phase[k].input:GetText()) / timeDivider
              if v ~= newValue then
                needUpdate = true
                newData[k] = newValue
              else
                newData[k] = v
              end
            end
            if needUpdate then
              if effectDrawables[di]:SetMoveEffectPhaseProperties(i, newData) == false then
                AddMessageToNotifyMessage("Failed to apply MoveEffectPhase " .. i .. " properties!")
              else
                for k, v in pairs(newData) do
                  phase[k]:SetText(string.format(propertyDisplayFormat, k, tostring(newData[k])))
                end
              end
            end
          end
          if checkbox:GetChecked() then
            effectDrawables[di]:SetStartEffect(true)
          elseif selectedTabIndex == di then
            effectDrawables[di]:SetStartEffect(true)
          end
        end
      end
      applyButton:SetHandler("OnClick", applyButton.OnClick)
      function effectDrawableController:OnHide()
        effectDrawableController = nil
      end
      effectDrawableController:SetHandler("OnHide", effectDrawableController.OnHide)
      effectDrawableController:Show(true)
    end
    debugBar:Show(false)
  end
end
