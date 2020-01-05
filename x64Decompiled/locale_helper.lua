local IStr = function(arg)
  return string.format("%i", arg)
end
local FStr = function(arg)
  return string.format("%.1f", arg)
end
local CommaStr = function(arg)
  if type(arg) == "number" then
    return string.format("|,%i;", arg)
  elseif type(arg) == "string" then
    return string.format("|,%s;", arg)
  end
end
if locale == nil then
  locale = {}
end
local t = function(category, key)
  return X2Locale:LocalizeUiText(category, key)
end
if locale.unknown == nil then
  locale.unknown = t(MONEY_TEXT, "unknown")
end
local function tMoney(key)
  return t(MONEY_TEXT, key)
end
local function tLogin(key)
  return t(LOGIN_TEXT, key)
end
local function tLoginDelete(key)
  return t(LOGIN_DELETE_TEXT, key)
end
locale.money = {
  money = tMoney("money"),
  Get_copper = function(a)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "copper", a)
  end,
  Get_silver = function(a)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "silver", a)
  end,
  Get_gold = function(a)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "gold", CommaStr(a))
  end,
  Get_honor = function(a)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "honor", a)
  end,
  current = tMoney("current"),
  copper = X2Locale:LocalizeUiText(MONEY_TEXT, "copper_name"),
  silver = X2Locale:LocalizeUiText(MONEY_TEXT, "silver_name"),
  gold = X2Locale:LocalizeUiText(MONEY_TEXT, "gold_name"),
  honor = X2Locale:LocalizeUiText(COMMON_TEXT, "honor_point"),
  dishonor = X2Locale:LocalizeUiText(MONEY_TEXT, "dishonor_name"),
  living_point = X2Locale:LocalizeUiText(MONEY_TEXT, "living_point"),
  gain_leadership_point = X2Locale:LocalizeUiText(MONEY_TEXT, "gain_leadership_point"),
  contribution_point = X2Locale:LocalizeUiText(MONEY_TEXT, "contribution_point"),
  GetPaidHouseTax = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "paid_house_tax", g)
  end,
  GetGainMoney = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "gain_money", g)
  end,
  GetLostMoney = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "lost_money", g)
  end,
  GetTradeGainMoney = function(t, g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "trade_gain_money", t, g)
  end,
  GetTradeLostMoney = function(t, g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "trade_lost_money", t, g)
  end,
  GetCurrentMoney = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "current_money", g)
  end,
  noMoney = X2Locale:LocalizeUiText(MONEY_TEXT, "no_money"),
  GetPaidHouseTaxByAAPoint = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "paid_house_tax_by_aa_point", g)
  end,
  GetGainAAPoint = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "gain_aa_point", g)
  end,
  GetLostAAPoint = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "lost_aa_point", g)
  end,
  GetTradeGainAAPoint = function(t, g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "trade_gain_aa_point", t, g)
  end,
  GetTradeLostAAPoint = function(t, g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "trade_lost_aa_point", t, g)
  end,
  GetCurrentAAPoint = function(g)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "current_aa_point", g)
  end,
  GetGainHonor = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "gain_point", locale.money.honor, CommaStr(h))
  end,
  GetLostHonor = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "lost_point", locale.money.honor, CommaStr(h))
  end,
  GetLostHonorInWarState = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "lost_honor_in_war_state", CommaStr(h))
  end,
  GetCurrentHonor = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "current_point", locale.money.honor, CommaStr(h))
  end,
  GetGainLivingPoint = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "gain_point", locale.money.living_point, CommaStr(h))
  end,
  GetLostLivingPoint = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "lost_point", locale.money.living_point, CommaStr(h))
  end,
  GetCurrentLivingPoint = function(h)
    return X2Locale:LocalizeUiText(MONEY_TEXT, "current_point", locale.money.living_point, CommaStr(h))
  end,
  sold_out = X2Locale:LocalizeUiText(MONEY_TEXT, "sold_out"),
  no_have_money = X2Locale:LocalizeUiText(MONEY_TEXT, "no_have_money"),
  askChargeAAPoint = X2Locale:LocalizeUiText(MONEY_TEXT, "ask_charge_aa_point"),
  autoUseAAPoint = X2Locale:LocalizeUiText(MONEY_TEXT, "auto_use_aa_point")
}
locale.escape = {
  title = X2Locale:LocalizeUiText(COMMON_TEXT, "escape_title"),
  content = function(a)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "escape_content", tostring(a))
  end
}
locale.questContext = {
  tabText = {
    X2Locale:LocalizeUiText(QUEST_TEXT, "tabText_progress"),
    X2Locale:LocalizeUiText(QUEST_TEXT, "tabText_mainQuest")
  },
  replay = X2Locale:LocalizeUiText(QUEST_TEXT, "replay"),
  questComplete = X2Locale:LocalizeUiText(QUEST_INTERACTION_TEXT, "complete_quest"),
  list = X2Locale:LocalizeUiText(QUEST_TEXT, "widget_title"),
  ok = X2Locale:LocalizeUiText(QUEST_TEXT, "ok"),
  no = X2Locale:LocalizeUiText(QUEST_TEXT, "no"),
  Get_gainExp = function(a)
    return X2Locale:LocalizeUiText(QUEST_TEXT, "gain_exp", a)
  end,
  completeMessage = X2Locale:LocalizeUiText(QUEST_TEXT, "complete_msg"),
  letItDoneMessage = X2Locale:LocalizeUiText(QUEST_TEXT, "letitdone_msg"),
  overDoneMessage = X2Locale:LocalizeUiText(QUEST_TEXT, "overdone_msg"),
  complete = X2Locale:LocalizeUiText(QUEST_TEXT, "complete"),
  cancel = X2Locale:LocalizeUiText(QUEST_TEXT, "cancel"),
  letItDone = X2Locale:LocalizeUiText(QUEST_TEXT, "letitdone"),
  overDone = X2Locale:LocalizeUiText(QUEST_TEXT, "overdone"),
  compensation = X2Locale:LocalizeUiText(QUEST_TEXT, "compensation"),
  selectiveCompensation = X2Locale:LocalizeUiText(QUEST_TEXT, "selective_compensation"),
  selectItem = X2Locale:LocalizeUiText(QUEST_TEXT, "select_item"),
  rewardAnd = X2Locale:LocalizeUiText(QUEST_TEXT, "reward_and"),
  rewardMoney = X2Locale:LocalizeUiText(QUEST_TEXT, "reward_money"),
  livingPoint = X2Locale:LocalizeUiText(QUEST_TEXT, "reward_living_point"),
  rewardDisHonor = X2Locale:LocalizeUiText(QUEST_TEXT, "reward_dishonor"),
  questCount = X2Locale:LocalizeUiText(QUEST_TEXT, "quest_count"),
  taskQuest = X2Locale:LocalizeUiText(QUEST_TEXT, "task_quest"),
  takeReward = X2Locale:LocalizeUiText(QUEST_TEXT, "take_reward"),
  hiddenQuest = X2Locale:LocalizeUiText(QUEST_TEXT, "hidden_quest"),
  rewardSelect = X2Locale:LocalizeUiText(QUEST_TEXT, "rewardSelect"),
  rewardTake = X2Locale:LocalizeUiText(QUEST_TEXT, "rewardTake"),
  rewardAAPoint = X2Locale:LocalizeUiText(QUEST_TEXT, "rewardAAPoint"),
  abandonQuest = X2Locale:LocalizeUiText(QUEST_TEXT, "abandonQuest"),
  descAbandonQuest = X2Locale:LocalizeUiText(QUEST_TEXT, "descAbandonQuest"),
  mySelf = X2Locale:LocalizeUiText(QUEST_TEXT, "my_self"),
  invalid_reward = X2Locale:LocalizeUiText(QUEST_TEXT, "invalid_reward"),
  Get_category = function(a)
    return X2Locale:LocalizeUiText(QUEST_TEXT, "category", IStr(a))
  end,
  errors = {
    X2Locale:LocalizeUiText(QUEST_ERROR, "already_have"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_quest"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "player_not_found"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_character"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "cant_supply_quest_item"),
    function(questDetail)
      local questDetailStr = X2Locale:LocalizeUiText(COMMON_TEXT, string.format("quest_detail_%s", questDetail))
      if questDetailStr == nil then
        return "invalid quest"
      end
      return X2Locale:LocalizeUiText(QUEST_ERROR, "maybe_quest_list_full", questDetailStr, questDetailStr)
    end,
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_npc_or_quest"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_request_for_npc"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "unit_requirement_check"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_reward_selection"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "cant_supply_rewards"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_quest_status"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "remove_quest_item_fail"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_quest_objective"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_quest_objective_index"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "wrong_answer_for_player_choice"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "precedent_objective_is_not_completed"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_npc"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "invalid_doodad"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "too_far_away_to_interact_with"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "update_failed"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "not_progressing"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "bag_full"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "item_required"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "level_not_match"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "gained_item_is_not_match"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "already_completed"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "backpack_occupied"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "cant_supply_money"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "cant_accept_by_fatigue"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "daily_limit"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "no_mate_item_in_the_bag"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "need_to_mate_summon"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "not_enough_mate_level"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "mate_equipments_are_not_empty"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "player_trade"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "not_running_game_schedule_quest"),
    X2Locale:LocalizeUiText(QUEST_ERROR, "cannot_while_teleport")
  },
  letItDoneChats = {
    {
      "self",
      X2Locale:LocalizeUiText(QUEST_TEXT, "letitdone_chat_1")
    },
    {
      "target",
      X2Locale:LocalizeUiText(QUEST_TEXT, "letitdone_chat_2")
    }
  },
  restartChats = {
    {
      "self",
      X2Locale:LocalizeUiText(QUEST_TEXT, "restart_chat_1")
    }
  },
  openMap = X2Locale:LocalizeUiText(QUEST_TEXT, "open_map"),
  questJournal = X2Locale:LocalizeUiText(QUEST_TEXT, "quest_journal"),
  restart = X2Locale:LocalizeUiText(QUEST_TEXT, "restart"),
  shareQuest = X2Locale:LocalizeUiText(QUEST_TEXT, "share"),
  giveup = X2Locale:LocalizeUiText(QUEST_TEXT, "giveup"),
  quest = X2Locale:LocalizeUiText(QUEST_TEXT, "quest"),
  next = X2Locale:LocalizeUiText(QUEST_TEXT, "quest_talk_next"),
  prev = X2Locale:LocalizeUiText(COMMON_TEXT, "prev"),
  talk = X2Locale:LocalizeUiText(NPC_INTERACTION_TEXT, "talk"),
  reward = X2Locale:LocalizeUiText(QUEST_TEXT, "quest_reward"),
  complete_reward = X2Locale:LocalizeUiText(QUEST_TEXT, "complete_reward"),
  selectiveObj = X2Locale:LocalizeUiText(QUEST_TEXT, "only_one_object_message"),
  aggroObj = X2Locale:LocalizeUiText(QUEST_TEXT, "aggro_obj_desc"),
  groupObj = X2Locale:LocalizeUiText(QUEST_TEXT, "group_obj_desc"),
  scoreCount = X2Locale:LocalizeUiText(QUEST_TEXT, "scoreCount"),
  doing = X2Locale:LocalizeUiText(QUEST_TEXT, "doing")
}
locale.login = {
  login = tLogin("login"),
  id = tLogin("id"),
  password = tLogin("password"),
  connectExit = tLogin("connectExit"),
  loginTip = tLogin("loginTip"),
  staff = tLogin("developer"),
  returnBtn = tLogin("back_to_login"),
  btn_otp = tLogin("btn_otp"),
  title_otp = tLogin("title_otp"),
  error_title_otp = tLogin("error_title_otp"),
  GetErrorContentOtp = function(failCount, maxTry)
    return X2Locale:LocalizeUiText(LOGIN_TEXT, "error_content_otp", tostring(maxTry), tostring(failCount), tostring(maxTry))
  end,
  btn_pc_cert = tLogin("btn_pc_cert"),
  title_pc_cert = tLogin("title_pc_cert"),
  error_title_pc_cert = tLogin("error_title_pc_cert"),
  error_title_secure_card = tLogin("error_title_secure_card"),
  GetErrorContentPcCert = function(failCount, maxTry)
    return X2Locale:LocalizeUiText(LOGIN_TEXT, "error_content_pc_cert", tostring(maxTry), tostring(failCount), tostring(maxTry))
  end,
  GetErrorContentSecureCard = function(colorHex)
    return X2Locale:LocalizeUiText(LOGIN_TEXT, "error_content_secure_card", colorHex)
  end,
  GetContentArsWithTimeOut = function(remainTime)
    return X2Locale:LocalizeUiText(LOGIN_TEXT, "content_ars_with_timeout", tostring(remainTime))
  end,
  GetContentArs = function()
    return X2Locale:LocalizeUiText(LOGIN_TEXT, "content_ars")
  end,
  logining = tLogin("logining"),
  certing = tLogin("certing"),
  connecting = tLogin("connecting"),
  remainTime = function(str)
    return X2Locale:LocalizeUiText(LOGIN_TEXT, "remain_time", str)
  end,
  join = X2Locale:LocalizeUiText(LOGIN_TEXT, "join"),
  findId = X2Locale:LocalizeUiText(LOGIN_TEXT, "find_id"),
  findPassword = X2Locale:LocalizeUiText(LOGIN_TEXT, "find_password")
}
locale.login.delete = {
  title = X2Locale:LocalizeUiText(LOGIN_DELETE_TEXT, "title"),
  label = X2Locale:LocalizeUiText(LOGIN_DELETE_TEXT, "label", "|cFFC13D36")
}
locale.server = {
  enter = X2Locale:LocalizeUiText(SERVER_TEXT, "enter"),
  name = X2Locale:LocalizeUiText(SERVER_TEXT, "name"),
  nameIndependent = X2Locale:LocalizeUiText(SERVER_TEXT, "name_independent"),
  character = X2Locale:LocalizeUiText(OPTION_TEXT, "option_item_character"),
  state = X2Locale:LocalizeUiText(SERVER_TEXT, "state"),
  popLow = X2Locale:LocalizeUiText(SERVER_TEXT, "popLow"),
  popMiddle = X2Locale:LocalizeUiText(SERVER_TEXT, "popMiddle"),
  popHigh = X2Locale:LocalizeUiText(SERVER_TEXT, "popHigh"),
  cantUse = X2Locale:LocalizeUiText(SERVER_TEXT, "cantUse"),
  checking = X2Locale:LocalizeUiText(SERVER_TEXT, "checking"),
  paramOrder = function(a)
    return X2Locale:LocalizeUiText(SERVER_TEXT, "paramOrder", tostring(a))
  end,
  paramCountOfPersons = function(a)
    return X2Locale:LocalizeUiText(SERVER_TEXT, "paramCountOfPersons", tostring(a))
  end,
  totalWaitingPersons = X2Locale:LocalizeUiText(SERVER_TEXT, "totalWaitingPersons"),
  timeAboveOneHour = X2Locale:LocalizeUiText(SERVER_TEXT, "timeAboveOneHour"),
  GetGuideText = function(a)
    return X2Locale:LocalizeUiText(SERVER_TEXT, "GetGuideText", tostring(a))
  end,
  max_character_count_change = function(maxPerWorld, maxPerAccount)
    return X2Locale:LocalizeUiText(SERVER_TEXT, "max_character_count_change", tostring(maxPerWorld), tostring(maxPerAccount))
  end,
  max_character_count_warning = function(maxPerWorld, maxPerAccount, maxExpandable)
    if maxExpandable > 0 then
      return X2Locale:LocalizeUiText(SERVER_TEXT, "max_character_count_warning2", tostring(maxPerAccount), tostring(maxPerWorld), tostring(maxPerAccount + maxExpandable))
    elseif maxPerWorld == maxPerAccount then
      return X2Locale:LocalizeUiText(SERVER_TEXT, "max_character_count_warning3", tostring(maxPerWorld))
    else
      return X2Locale:LocalizeUiText(SERVER_TEXT, "max_character_count_warning", tostring(maxPerWorld), tostring(maxPerAccount))
    end
  end,
  pre_select_character_warning = X2Locale:LocalizeUiText(SERVER_TEXT, "pre_select_character_warning"),
  nuian_start_region = X2Locale:LocalizeUiText(SERVER_TEXT, "nuian_start_region"),
  elf_start_region = X2Locale:LocalizeUiText(SERVER_TEXT, "elf_start_region"),
  ferre_start_region = X2Locale:LocalizeUiText(SERVER_TEXT, "ferre_start_region"),
  hariharan_start_region = X2Locale:LocalizeUiText(SERVER_TEXT, "hariharan_start_region"),
  race_congestion_low = X2Locale:LocalizeUiText(SERVER_TEXT, "race_congestion_low"),
  race_congestion_middle = X2Locale:LocalizeUiText(SERVER_TEXT, "race_congestion_middle"),
  race_congestion_high = X2Locale:LocalizeUiText(SERVER_TEXT, "race_congestion_high"),
  refresh = X2Locale:LocalizeUiText(SERVER_TEXT, "refresh"),
  refresh_diable = X2Locale:LocalizeUiText(SERVER_TEXT, "refresh_diable"),
  pre_select_cant_create = X2Locale:LocalizeUiText(SERVER_TEXT, "pre_select_cant_create"),
  serverIntegrationWarning = X2Locale:LocalizeUiText(COMMON_TEXT, "serverIntegrationWarning"),
  serverIntegrationNotice = X2Locale:LocalizeUiText(COMMON_TEXT, "serverIntegrationNotice"),
  integration = X2Locale:LocalizeUiText(COMMON_TEXT, "integration"),
  newWorld = X2Locale:LocalizeUiText(COMMON_TEXT, "newWorld"),
  integrationWarning = X2Locale:LocalizeUiText(COMMON_TEXT, "serverIntegrationWarning2"),
  integrationWorldList = {
    X2Locale:LocalizeUiText(COMMON_TEXT, "integrationWorldList1"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "integrationWorldList2")
  },
  integratedWorld = {
    X2Locale:LocalizeUiText(COMMON_TEXT, "integratedWorld1"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "integratedWorld2")
  },
  newWorldNotice = X2Locale:LocalizeUiText(COMMON_TEXT, "newWorldNotice")
}
locale.characterSelect = {
  cancelCreate = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "cancelCreate"),
  characterSelect = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "characterSelect"),
  gameStart = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "gameStart"),
  select = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "select"),
  delete = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "delete"),
  createCharacter = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "createCharacter"),
  availableMoney = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "availableMoney"),
  position = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "position"),
  faction = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "faction"),
  chargeLaborPower = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "charge_labor_power"),
  invalidIndex = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "invalide_faction_index"),
  unknownFactionInfo = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "unknown_faction"),
  cancelDelete = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "cancel_delete"),
  create = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "create"),
  laborPowerTip = function(a)
    return X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "labor_power_tip", a, a)
  end,
  obt_warning = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "obt_warning"),
  max_character_count_warning = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "max_character_count_warning"),
  max_character_count_warning2 = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "max_character_count_warning2"),
  character_count_not_match = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "character_count_not_match"),
  unable_labor_power_tip = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "unable_labor_power_tip"),
  waiting_entrance_text = function(length)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "waiting_entrance_text", tostring(length))
  end,
  waiting_remainTime_text = function(remain)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "waiting_remainTime_text", tostring(remain))
  end,
  waiting_remainTime_calculating_text = X2Locale:LocalizeUiText(COMMON_TEXT, "waiting_remainTime_calculating_text"),
  character_name_force_changed = X2Locale:LocalizeUiText(COMMON_TEXT, "character_name_force_changed"),
  renameCharacter = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "renameCharacter"),
    desc = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "renameCharacter")
  },
  renameConfirm = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "renameConfirm"),
    desc = function(color)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "renameConfirm", tostring(color))
    end
  }
}
locale.loginCrowded = {
  GetUnableRaceTooltipText = function(raceName)
    return X2Locale:LocalizeUiText(LOGIN_CROWDED_TEXT, "fail_race", raceName)
  end,
  tip = {
    X2Locale:LocalizeUiText(LOGIN_CROWDED_TEXT, "smooth"),
    X2Locale:LocalizeUiText(LOGIN_CROWDED_TEXT, "crowed"),
    X2Locale:LocalizeUiText(LOGIN_CROWDED_TEXT, "race_balance_unable"),
    X2Locale:LocalizeUiText(LOGIN_CROWDED_TEXT, "race_balance_unable")
  }
}
locale.tutorial = {
  title = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "title"),
  looting = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "looting"),
  mount = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "mount"),
  dead = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "dead"),
  acceptFirstQuest = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "accept_first_quest"),
  acceptFirstItemQuest = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "accept_first_item_quest"),
  skill_train = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "skill_train"),
  event_return_point = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "event_return_point"),
  hideTutorial = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "hide_tutorial"),
  hideTutorialTitle = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "hideTutorialTitle"),
  hideTutorialMsg = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "hide_tutorial_msg"),
  uiAvi = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "ui_avi"),
  GetReturnPointMsg = function(a)
    return X2Locale:LocalizeUiText(TUTORIAL_TEXT, "return_point_msg", a)
  end,
  updateBag = {
    gain_item = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "bag_gain_item"),
    summonMate = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "bag_summon_mate"),
    weaponOrArmor = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "bag_weapon_or_armor")
  },
  openBag = {
    summonMate = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "open_bag_summon_mate"),
    weaponOrArmor = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "open_bag_weapon_or_armor")
  }
}
locale.trade = {
  myStuff = X2Locale:LocalizeUiText(TRADE_TEXT, "my_stuff"),
  money = X2Locale:LocalizeUiText(TRADE_TEXT, "money"),
  cancel = X2Locale:LocalizeUiText(TRADE_TEXT, "cancel"),
  ok = X2Locale:LocalizeUiText(TRADE_TEXT, "ok"),
  lock = X2Locale:LocalizeUiText(TRADE_TEXT, "lock"),
  unlock = X2Locale:LocalizeUiText(TRADE_TEXT, "unlock"),
  canceled = X2Locale:LocalizeUiText(TRADE_TEXT, "canceled"),
  registedItem = X2Locale:LocalizeUiText(TRADE_TEXT, "registed_item"),
  tradeOk = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_ok"),
  tradeOtherLocked = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_other_locked"),
  tradeOtherLockCanceled = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_other_lock_canceled"),
  tradeOtherOk = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_other_ok"),
  tradeAccomplishd = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_accomplishd"),
  lockedMsg = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_confirm"),
  otherLockedMsg = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_other_confirm"),
  unlockedMsg = X2Locale:LocalizeUiText(TRADE_TEXT, "trade_cancel_confirm")
}
locale.keyBinding = {
  add_time_of_combatState = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "add_time_of_combatState"),
  add_time_of_summon = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "add_time_of_summon"),
  gameExit = {
    paramExitMsg = function(a)
      return X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "game_exit_msg", a)
    end,
    paramNoneActionExitMsg = function()
      return X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "none_action_exit")
    end,
    paramSelectCharacterMsg = function(a)
      return X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "exit_select_character", a)
    end,
    paramSelectWorldMsg = function(a)
      return X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "exit_select_world", a)
    end,
    processing = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "processing"),
    cancel = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "game_cancel"),
    ok = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "game_ok")
  },
  config = {
    menu = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "config_menu"),
    gameExit = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "config_game_exit")
  },
  cancelBinding = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "cancel_binding"),
  saveBinding = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "save_binding"),
  initBinding = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "init_binding"),
  bindableMessage = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bindable_message"),
  enterMessage = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "enter_Message"),
  builtin = {
    moveforward = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_moveforward"),
    moveback = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_moveback"),
    moveleft = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_moveleft"),
    moveright = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_moveright"),
    turnleft = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_turnleft"),
    turnright = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_turnright"),
    autorun = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_autorun"),
    jump = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_jump"),
    down = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_down"),
    toggle_walk = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_walk"),
    zooming = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_zooming"),
    open_chat = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_open_chat"),
    open_config = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_open_config"),
    toggle_bag = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_bag"),
    toggle_spellbook = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_spellbook"),
    toggle_character = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_character"),
    toggle_quest = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_quest"),
    toggle_craft_book = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_craft_book"),
    toggle_craft_research = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_craft_research"),
    toggle_common_farm_info = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_common_farm_info"),
    cycle_hostile_forward = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_cycle_hostile_forward"),
    cycle_hostile_backward = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_cycle_hostile_backward"),
    cycle_friendly_forward = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_cycle_friendly_forward"),
    cycle_friendly_backward = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_cycle_friendly_backward"),
    screenshotmode = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_screenshotmode"),
    toggle_nametag = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_nametag"),
    toggle_worldmap = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_maximap"),
    toggle_community = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_community"),
    toggle_ability = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_ability"),
    toggle_force_attack = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_force_attack"),
    toggle_web_browser = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_web_browser"),
    toggle_web_messenger = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_web_messenger"),
    toggle_web_play_diary = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_web_play_diary"),
    toggle_web_play_diary_instant = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_web_play_diary_instant"),
    toggle_achievement = X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "builtin_toggle_achievement")
  }
}
locale.screenShotMode = {
  title = X2Locale:LocalizeUiText(COMMON_TEXT, "screen_shot_mode_title"),
  mouse_wheel = X2Locale:LocalizeUiText(COMMON_TEXT, "mouse_wheel"),
  screenShotModeToggle = {
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "screen_shot_camera")
  },
  item_1 = {
    X2Locale:LocalizeUiText(COMMON_TEXT, "camera_move_rotate"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "camera_angle")
  },
  dofToggle = {
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "dof_toggle")
  },
  item_2 = {
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "dof_auto_focus"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "dof_add_dist"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "dof_sub_dist"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "dof_add_range"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "dof_sub_range")
  },
  bokehToggle = {
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_toggle")
  },
  item_3 = {
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_big"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_small"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_add_intensity"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_sub_intensity")
  },
  item_4 = {
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_circle"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_hexagon"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_heart"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "bokeh_star")
  },
  dofTip = X2Locale:LocalizeUiText(COMMON_TEXT, "dof_tip"),
  bokehTip = X2Locale:LocalizeUiText(COMMON_TEXT, "bokeh_tip")
}
locale.comercialMail = {
  tabGoods = X2Locale:LocalizeUiText(MAIL_TEXT, "tab_goods"),
  goodsCategory = X2Locale:LocalizeUiText(MAIL_TEXT, "goods_category"),
  goodsTitle = X2Locale:LocalizeUiText(MAIL_TEXT, "goods_title"),
  goodsRemain = X2Locale:LocalizeUiText(MAIL_TEXT, "goods_remain"),
  btnGoodsReceive = X2Locale:LocalizeUiText(MAIL_TEXT, "goods_receive"),
  notRefundableGoods = X2Locale:LocalizeUiText(MAIL_TEXT, "not_refundable_goods"),
  notRefundable = X2Locale:LocalizeUiText(MAIL_TEXT, "not_refundable"),
  refundExpiration = X2Locale:LocalizeUiText(MAIL_TEXT, "refund_expiration"),
  GetUnconfirmedGoodsText = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "unconfirmed_goods_mail", IStr(a), IStr(b))
  end,
  GetRefundLimitDH = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "refund_limit_dh", IStr(a), IStr(b))
  end,
  GetRefundLimitHM = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "refund_limit_hm", IStr(a), IStr(b))
  end,
  GetRefundLimitM = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "refund_limit_m", IStr(a))
  end,
  refundLimitLessM = X2Locale:LocalizeUiText(MAIL_TEXT, "refund_limit_less_m"),
  GetLimitDH = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "limit_dh", IStr(a), IStr(b))
  end,
  GetLimitHM = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "limit_hm", IStr(a), IStr(b))
  end,
  GetLimitM = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "limit_m", IStr(a))
  end,
  limitLessM = X2Locale:LocalizeUiText(MAIL_TEXT, "limit_less_m"),
  tabMia = X2Locale:LocalizeUiText(MAIL_TEXT, "tab_mia"),
  miaTitle = X2Locale:LocalizeUiText(MAIL_TEXT, "mia_title"),
  miaSender = X2Locale:LocalizeUiText(MAIL_TEXT, "mia_sender"),
  miaReceiver = X2Locale:LocalizeUiText(MAIL_TEXT, "mia_receiver"),
  btnSendToMia = X2Locale:LocalizeUiText(MAIL_TEXT, "send_to_mia"),
  btnDelete = X2Locale:LocalizeUiText(MAIL_TEXT, "mia_delete"),
  btnSend = X2Locale:LocalizeUiText(MAIL_TEXT, "mia_send"),
  GetUnconfirmedMiaMailText = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "unconfirmed_mia_mail", IStr(a), IStr(b))
  end,
  receiveMsgTitle = X2Locale:LocalizeUiText(MAIL_TEXT, "goods_receive_msg_title"),
  receiveMsgBtn = X2Locale:LocalizeUiText(MAIL_TEXT, "goods_receive_msg_title"),
  GetReceiveMsgContent = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "goods_receive_msg_content", a)
  end,
  GetReceiveFreeItemMsgContent = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "GetReceiveFreeItemMsgContent", a)
  end,
  GetNotAbleConcurrentlyActivateText = function(a, b)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "not_able_concurrently_activate", a, b)
  end,
  guide = X2Locale:LocalizeUiText(MAIL_TEXT, "comercial_mail_guide"),
  getingMail = X2Locale:LocalizeUiText(MAIL_TEXT, "geting_mail")
}
locale.mail = {
  receivedMail = X2Locale:LocalizeUiText(MAIL_TEXT, "received_mail"),
  sentMail = X2Locale:LocalizeUiText(MAIL_TEXT, "sent_mail"),
  writeMail = X2Locale:LocalizeUiText(MAIL_TEXT, "write_mail"),
  deleteMail = X2Locale:LocalizeUiText(MAIL_TEXT, "delete_mail"),
  replyMail = X2Locale:LocalizeUiText(MAIL_TEXT, "reply_mail"),
  payTax = X2Locale:LocalizeUiText(MAIL_TEXT, "pay_tax"),
  receiptTax = X2Locale:LocalizeUiText(MAIL_TEXT, "receipt_tax"),
  readMail = X2Locale:LocalizeUiText(MAIL_TEXT, "read_mail"),
  readSentMail = X2Locale:LocalizeUiText(MAIL_TEXT, "read_sent_mail"),
  sender = X2Locale:LocalizeUiText(MAIL_TEXT, "sender"),
  receiver = X2Locale:LocalizeUiText(MAIL_TEXT, "receiver"),
  title = X2Locale:LocalizeUiText(MAIL_TEXT, "title"),
  attachRecv = X2Locale:LocalizeUiText(MAIL_TEXT, "attach_recv"),
  moneyRece = X2Locale:LocalizeUiText(MAIL_TEXT, "money_rece"),
  returnMail = X2Locale:LocalizeUiText(MAIL_TEXT, "return_mail"),
  return_title = X2Locale:LocalizeUiText(MAIL_TEXT, "return_title"),
  return_content = X2Locale:LocalizeUiText(MAIL_TEXT, "return_content"),
  delete = X2Locale:LocalizeUiText(MAIL_TEXT, "delete"),
  normalMail = X2Locale:LocalizeUiText(MAIL_TEXT, "normal_mail"),
  expressMail = X2Locale:LocalizeUiText(MAIL_TEXT, "express_mail"),
  send = X2Locale:LocalizeUiText(MAIL_TEXT, "send"),
  attachment = X2Locale:LocalizeUiText(MAIL_TEXT, "attachment"),
  unreadMailCount = X2Locale:LocalizeUiText(MAIL_TEXT, "unread_mail_count"),
  reply = X2Locale:LocalizeUiText(MAIL_TEXT, "reply"),
  GetUnreadMail = function(count)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "unread_mail", tostring(count))
  end,
  text = X2Locale:LocalizeUiText(MAIL_TEXT, "text"),
  silver = X2Locale:LocalizeUiText(MAIL_TEXT, "silver"),
  copper = X2Locale:LocalizeUiText(MAIL_TEXT, "copper"),
  write = X2Locale:LocalizeUiText(MAIL_TEXT, "write"),
  haveAttachItem = X2Locale:LocalizeUiText(MAIL_TEXT, "have_attach_item"),
  receive = X2Locale:LocalizeUiText(MAIL_TEXT, "receive"),
  payChargeMoney = X2Locale:LocalizeUiText(MAIL_TEXT, "pay_charge_money"),
  autoReceiver = X2Locale:LocalizeUiText(MAIL_TEXT, "auto_receiver"),
  deletedCharacter = X2Locale:LocalizeUiText(MAIL_TEXT, "deleted_character"),
  generalDelivery = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "general_delivery", a)
  end,
  expressDelivery = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "express_delivery", a)
  end,
  bagFull = X2Locale:LocalizeUiText(MAIL_TEXT, "bag_full"),
  guide = X2Locale:LocalizeUiText(MAIL_TEXT, "mail_guide"),
  bidMoney = X2Locale:LocalizeUiText(MAIL_TEXT, "bid_money"),
  deposit = X2Locale:LocalizeUiText(MAIL_TEXT, "deposit"),
  charge = X2Locale:LocalizeUiText(MAIL_TEXT, "charge"),
  profit = X2Locale:LocalizeUiText(MAIL_TEXT, "profit"),
  notExistReadMail = X2Locale:LocalizeUiText(MAIL_TEXT, "not_exist_read_mail"),
  allReadMailIncludeAttach = X2Locale:LocalizeUiText(MAIL_TEXT, "all_read_mail_include_attach"),
  alarmAllReadMailDelected = X2Locale:LocalizeUiText(MAIL_TEXT, "alarm_all_read_mail_delected"),
  readMailDelete = X2Locale:LocalizeUiText(MAIL_TEXT, "read_mail_delete"),
  readMailDeleteTip = X2Locale:LocalizeUiText(MAIL_TEXT, "read_mail_delete_tip"),
  allMailDelete = X2Locale:LocalizeUiText(MAIL_TEXT, "read_all_mail_delete"),
  allMailDeleteTip = X2Locale:LocalizeUiText(MAIL_TEXT, "read_all_mail_delete_tip"),
  commercial_read_mail_title = X2Locale:LocalizeUiText(MAIL_TEXT, "commercial_read_mail_title"),
  auctionSaleBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "auction_sale_breakdown"),
  auctionSaleFailBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "auction_sale_fail_breakdown"),
  auctionBuyBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "auction_buy_breakdown"),
  auctionBidCancelBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "auction_bid_cancel_breakdown"),
  auctionBidFailBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "auction_bid_fail_breakdown"),
  sellBackpackBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack_breakdown"),
  applyPriceMoney = X2Locale:LocalizeUiText(MAIL_TEXT, "apply_price_money"),
  bargainingMoney = X2Locale:LocalizeUiText(MAIL_TEXT, "bargaining_money"),
  interest = X2Locale:LocalizeUiText(MAIL_TEXT, "interest"),
  totalSellBackpackMoney = X2Locale:LocalizeUiText(MAIL_TEXT, "total_sell_backpack_money"),
  sellBackpackTip = X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack_tip"),
  titleCancelSellBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "title_cancel_sell_breakdown"),
  titleSellBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "title_sell_breakdown"),
  titleBuyBreakdown = X2Locale:LocalizeUiText(MAIL_TEXT, "title_buy_breakdown"),
  housePrice = X2Locale:LocalizeUiText(MAIL_TEXT, "house_price"),
  houseSellCancel = {
    title = function(zoneId, houseName)
      local info = {
        title = X2Locale:LocalizeUiText(MAIL_TEXT, "title_house_sell_cancel"),
        sender = X2Locale:LocalizeUiText(MAIL_TEXT, "house_tax_sender", X2Dominion:GetZoneGroupName(zoneId))
      }
      return info
    end,
    body = function(houseName, itemType, count)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "body_house_sell_cancel", tostring(houseName))
    end
  },
  houseSold = {
    title = function(buyerName, houseName)
      local info = {
        title = X2Locale:LocalizeUiText(MAIL_TEXT, "title_house_sold"),
        sender = buyerName
      }
      return info
    end,
    body = function(buyerName, houseName, price)
      local strTable = {
        buyerName = buyerName,
        houseName = houseName,
        price = price
      }
      return strTable
    end
  },
  houseBought = {
    title = function(zoneId, houseName)
      local info = {
        title = X2Locale:LocalizeUiText(MAIL_TEXT, "title_house_bought"),
        sender = X2Locale:LocalizeUiText(MAIL_TEXT, "house_tax_sender", X2Dominion:GetZoneGroupName(zoneId))
      }
      return info
    end,
    body = function(sellerName, houseName, price)
      local strTable = {
        sellerName = sellerName,
        houseName = houseName,
        price = price
      }
      return strTable
    end
  },
  houseTax = {
    sender = function(zoneName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "house_tax_sender", zoneName)
    end,
    title = function(zoneName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "house_tax_title", zoneName)
    end,
    defaultWaring = X2Locale:LocalizeUiText(MAIL_TEXT, "house_tax_default_waring"),
    body = function(name, p1, p2, due, basicTax, dominionTaxRate, heavyTaxHouseCount, weeks, charge, isHeavyTaxHouse, normalTaxHouseCount, hostileTaxRate)
      local bodyInfo = {}
      bodyInfo.name = name
      bodyInfo.tax_period_start = p1
      bodyInfo.tax_period_end = p2
      bodyInfo.pay_period = due
      bodyInfo.basic_tax = basicTax
      bodyInfo.dominion_tax_rate = dominionTaxRate
      bodyInfo.heavyTaxHouseCount = heavyTaxHouseCount
      bodyInfo.unpaid_count = weeks
      bodyInfo.total_tax = charge
      bodyInfo.isHeavyTaxHouse = isHeavyTaxHouse
      bodyInfo.normalTaxHouseCount = normalTaxHouseCount
      bodyInfo.hostile_tax_rate = hostileTaxRate
      return bodyInfo
    end
  },
  houseRebuild = {
    sender = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "archeage"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "rebuilding_mail_title"),
    body = function(deposit, existingHousingName, rebuilngHousingName)
      local bodyInfo = {}
      bodyInfo.deposit = deposit
      bodyInfo.existingHousingName = existingHousingName
      bodyInfo.rebuilngHousingName = rebuilngHousingName
      return bodyInfo
    end
  },
  taxInKindReceipt = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_sender"),
    title = function(zoneName, isNation)
      if isNation == true then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "tax_in_kind_balance_nation_receipt_title", zoneName)
      else
        return X2Locale:LocalizeUiText(COMMON_TEXT, "tax_in_kind_balance_receipt_title", zoneName)
      end
    end,
    body = function(zoneName, isNation)
      if isNation == true then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "tax_in_kind_balance_nation_receipt_body", zoneName)
      else
        return X2Locale:LocalizeUiText(COMMON_TEXT, "tax_in_kind_balance_receipt_body", zoneName)
      end
    end
  },
  balanceReceiptBody = {
    period = function(zoneName, startPeriod, endPeriod)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_body_period", zoneName, startPeriod, endPeriod)
    end,
    total = X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_body_total"),
    alreadyReceipt = X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_body_already_receipt")
  },
  taxRateChange = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_sender"),
    titleName = X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_title_name"),
    taxtations = X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_taxtations"),
    title = function(zoneName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_title", zoneName)
    end,
    body = function(oldTaxRate, newTaxRate)
      local bodyInfo = {}
      bodyInfo.old_tax_rate = oldTaxRate
      bodyInfo.new_tax_rate = newTaxRate
      return bodyInfo
    end
  },
  taxRateChangeBody = {
    content = function(zoneName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_body_content", zoneName)
    end
  },
  auctionOffCancel = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "auction_cancel_title", a, tostring(b))
    end,
    body = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "auction_cancel_body", a, tostring(b))
    end
  },
  auctionOffSuccess = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "auction_success_title", a, tostring(b))
    end,
    body = function(a, b, c, d, e, f, g, h, i, j)
      local offSuccessInfo = {
        itemName = a,
        count = X2Locale:LocalizeUiText(COMMON_TEXT, "amount", tostring(b)),
        money = c,
        bidMoney = d,
        charge = e,
        deposit = f,
        advantage = g,
        chargePers = h,
        duration = i,
        serviceKind = j
      }
      return offSuccessInfo
    end
  },
  auctionOffFail = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "auction_fail_title", a, tostring(b))
    end,
    body = function(a, b)
      local offFailInfo = {
        bodyTitle = X2Locale:LocalizeUiText(MAIL_TEXT, "auction_fail_body", a, tostring(b))
      }
      return offFailInfo
    end
  },
  auctionBidWin = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "bid_win_title", a, tostring(b))
    end,
    body = function(a, b, c)
      local offBidWinInfo = {
        bodyTitle = X2Locale:LocalizeUiText(MAIL_TEXT, "bid_win_body", a, tostring(b)),
        money = c
      }
      return offBidWinInfo
    end
  },
  auctionBidFail = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "bid_fail_title", a)
    end,
    body = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "bid_fail_body", a)
    end
  },
  auctionDepositRatioDiff = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    body = function(itemType, itemCount, goldStr, silverStr, copperStr)
      local name = X2Item:Name(itemType) or "Unknown Item"
      return X2Locale:LocalizeUiText(MAIL_TEXT, "auction_deposit_ratio_diff_body", name, tostring(itemCount), goldStr, silverStr, copperStr)
    end
  },
  auctionDepositLimitDiff = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    body = function(itemType, itemCount, goldStr, silverStr, copperStr)
      local name = X2Item:Name(itemType) or "Unknown Item"
      return X2Locale:LocalizeUiText(MAIL_TEXT, "auction_deposit_limit_diff_body", name, tostring(itemCount), goldStr, silverStr, copperStr)
    end
  },
  craftOrderCancel = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_manager"),
    title = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_cancel_title")
    end,
    body = function(craftType)
      local pInfo = X2Craft:GetCraftProductInfo(craftType)[1]
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_cancel_body", pInfo.item_name)
    end
  },
  craftOrderExpired = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_manager"),
    title = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_cancel_title")
    end,
    body = function(craftType)
      local pInfo = X2Craft:GetCraftProductInfo(craftType)[1]
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_expired_body", pInfo.item_name)
    end
  },
  craftOrderModified = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_manager"),
    title = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_cancel_title")
    end,
    body = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_modified_body")
    end
  },
  craftOrderHandle = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_manager"),
    title = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_complete_title")
    end,
    body = function(craftType)
      local pInfo = X2Craft:GetCraftProductInfo(craftType)[1]
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_complete_body", pInfo.item_name)
    end
  },
  craftOrderFee = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_manager"),
    title = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_process_title")
    end,
    body = function(craftType)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "craft_order_process_body")
    end
  },
  questReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "quest_reward"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "quest_title", a)
    end,
    body = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "quest_body", a)
    end
  },
  sellBackpack = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack"),
    title = function(a)
      if a == nil then
        return X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack_title")
      elseif a == 0 then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "mail_sell_backpack_title_crafter")
      elseif a == 1 then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "mail_sell_backpack_title_seller")
      elseif a == 2 then
        return X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack_title")
      elseif a == 3 then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "sell_tradegood_title")
      end
    end,
    body = function(a, b, c, d, e, extraRatio, actualGain, receiverCase, coinType, crafterCoinCount, sellerCoinCount, revenueSanction, extraRatioKind, tradegood, interest, freshness, specialtyMerchantRatio)
      if e == nil then
        e = 0
      end
      if c == nil then
        d = b
        b = 0
        c = 0
      end
      if sellerCoinCount == nil then
        sellerCoinCount = crafterCoinCount
        crafterCoinCount = coinType
        coinType = receiverCase
        receiverCase = actualGain
        actualGain = extraRatio
        extraRatio = 0
      end
      if extraRatioKind == nil then
        extraRatioKind = extraRatio > 0 and 1 or 0
      end
      if tradegood == nil then
        tradegood = 0
      end
      if interest == nil then
        interest = 5
      end
      if freshness == nil then
        freshness = 0
      end
      if specialtyMerchantRatio == nil then
        specialtyMerchantRatio = 0
      end
      local strTable = {
        itemName = X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack_item_name", a),
        ratio = b,
        earlyMoney = string.format("|m%d;", c),
        totalMoney = string.format("|m%d;", d),
        bargain = e,
        bargainingMoney = string.format("|m%d;", e),
        actualGain = string.format("|m%d", actualGain),
        receiverCase = receiverCase,
        coinType = coinType,
        crafterCoinCount = crafterCoinCount,
        sellerCoinCount = sellerCoinCount,
        extraRatio = extraRatio,
        revenueSanction = revenueSanction,
        extraRatioKind = extraRatioKind,
        tradegood = tradegood,
        interest = interest,
        freshness = freshness,
        specialtyMerchantRatio = specialtyMerchantRatio
      }
      return strTable
    end
  },
  houseDemolish = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_body")
  },
  houseDemolishIntegration = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_body")
  },
  houseDemolishReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "house_demolish_body")
  },
  restoreItem = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "restore_item"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "restore_item_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "restore_item_body")
  },
  craftTerminate = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_terminate_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_terminate_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "craft_terminate_body")
  },
  chargePay = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "restore_item"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "charge_pay_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "charge_pay_body")
  },
  shipyardExpire = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "shipyard_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "shipyard_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "shipyard_body")
  },
  juryReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "jury_reward_sender"),
    title = function(a)
      local num = tonumber(a)
      if num == 10 or num == 100 then
        return X2Locale:LocalizeUiText(MAIL_TEXT, "jury_title", a)
      else
        return X2Locale:LocalizeUiText(MAIL_TEXT, "jury_title2")
      end
    end,
    body = function(a)
      local num = tonumber(a)
      if num == 10 or num == 100 then
        return X2Locale:LocalizeUiText(MAIL_TEXT, "jury_body", a)
      else
        return X2Locale:LocalizeUiText(MAIL_TEXT, "jury_body2")
      end
    end
  },
  arrestorReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "jury_reward_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "arrestor_reward_title"),
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "arrestor_reward_body")
  },
  reporterReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "jury_reward_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "bot_report_reward_title"),
    body = function(botName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "bot_report_reward_body", botName)
    end
  },
  questMail = {
    sender = "__QUEST__",
    title = function(a)
      return a
    end,
    body = function(a)
      return a
    end
  },
  inGameShop = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "ingameshop_sender"),
    title = function(a)
      return a
    end,
    body = function(present, who, itemName, priceType)
      local infos = {}
      infos.priceType = priceType
      if present then
        infos.content = X2Locale:LocalizeUiText(MAIL_TEXT, "ingameshop_body_present", who, itemName)
      else
        infos.content = X2Locale:LocalizeUiText(MAIL_TEXT, "ingameshop_body_buy")
      end
      return infos
    end,
    fromInGameShop = true
  },
  scheduleItem = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "schedule_item"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "schedule_item_title", a)
    end,
    body = function(a, b)
      if b ~= nil then
        if b == SIMT_SCHEDULE_ITEM_NORMAL_MAIL then
          return X2Locale:LocalizeUiText(MAIL_TEXT, "schedule_item_body", a)
        else
          return a
        end
      else
        return X2Locale:LocalizeUiText(MAIL_TEXT, "schedule_item_body", a)
      end
    end
  },
  achievement = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "achievement_item"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "achievement_item_title", a)
    end,
    body = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "achievement_item_body", a, b)
    end
  },
  todayAssignment = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "achievement_item"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "today_assignment_item_title", a)
    end,
    body = function(a, b)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "today_assignment_item_body", a, b)
    end
  },
  siegeAuctionStart = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_start_title", a)
    end,
    body = function(time)
      return time
    end
  },
  siegeAuctionWin = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_win_title", a)
    end,
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_win_body")
  },
  siegeAuctionLose = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "auctioneer"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_lose_title", a)
    end,
    body = X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_lose_body")
  },
  rankReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "rank_reward"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "rank_reward_title", a)
    end,
    body = function(a, b, c)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "rank_reward_body", a, b, c)
    end
  },
  rankingReward = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "rank_reward"),
    title = function(a)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "rank_reward_title", X2Locale:LocalizeUiText(COMMON_TEXT, a))
    end,
    body = function(a, b, c, d, e)
      local tabName = X2Locale:LocalizeUiText(COMMON_TEXT, a)
      local rankingName = X2Locale:LocalizeUiText(COMMON_TEXT, b)
      local grade = X2Locale:LocalizeUiText(ITEM_GRADE, c)
      local divisionGroup = d
      if divisionGroup == "global" then
        divisionGroup = X2Locale:LocalizeUiText(COMMON_TEXT, "ranking_division_global")
      else
        divisionGroup = X2World:GetCurrentWorldName()
      end
      local rank = e
      return X2Locale:LocalizeUiText(COMMON_TEXT, "ranking_reward_body", tabName, rankingName, grade, divisionGroup, rank)
    end
  },
  mobilizationOrderItem = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "mobilization_order_item"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "mobilization_order_title"),
    body = X2Locale:LocalizeUiText(COMMON_TEXT, "mobilization_order_body")
  },
  siegeGameRewardWinItem = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_game_reward_win_item"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_game_reward_win_title"),
    body = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_game_reward_win_body")
  },
  siegeGameRewardLoseItem = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_game_reward_lose_item"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_game_reward_lose_title"),
    body = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_game_reward_lose_body")
  },
  nationalTaxRate = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_sender"),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "nation_tax_rate_change_title"),
    titleName = X2Locale:LocalizeUiText(MAIL_TEXT, "nation_tax_rate_change_title_name"),
    body = function(factionId, zoneGroupType, newTaxRate, oldTaxRate, day)
      local bodyInfo = {}
      bodyInfo.factionId = factionId
      bodyInfo.zoneGroupType = zoneGroupType
      bodyInfo.newTaxRate = newTaxRate
      bodyInfo.oldTaxRate = oldTaxRate
      bodyInfo.day = day
      return bodyInfo
    end
  },
  nationTaxRateChangeBody = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "nation_tax_rate_change_body", tostring(a))
  end,
  nationTaxRateChangeBodyDay = function(a)
    return X2Locale:LocalizeUiText(MAIL_TEXT, "nation_tax_rate_change_body_day", tostring(a))
  end,
  nationalTax = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "tax_rate_change_sender"),
    title = function(zoneName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "nation_tax_rate_receipt_title", zoneName)
    end,
    titleName = X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_title_name"),
    body = function(lastPaidTime, curPaidTime, money, aaPoint)
      local bodyInfo = {}
      bodyInfo.lastPaidTime = lastPaidTime
      bodyInfo.curPaidTime = curPaidTime
      bodyInfo.money = money
      bodyInfo.aaPoint = aaPoint
      return bodyInfo
    end
  },
  nationTaxRateReceiptBody = {
    period = function(a, b, c, d, e)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_body_period", tostring(a), b, c, d, tostring(e))
    end
  },
  heroCandidateAlarm = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_election_manager"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_election_candidate_mail_title"),
    body = function(msg, periodStart, periodEnd)
      local bodyInfo = {}
      bodyInfo.msg = tostring(msg)
      bodyInfo.periodStart = periodStart
      bodyInfo.periodEnd = periodEnd
      return bodyInfo
    end
  },
  heroElectionItem = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_election_manager"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_election_win_mail_title"),
    body = function(msg, periodStart, periodEnd)
      local bodyInfo = {}
      bodyInfo.msg = tostring(msg)
      bodyInfo.periodStart = periodStart
      bodyInfo.periodEnd = periodEnd
      return bodyInfo
    end
  },
  heroBonusItem = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_election_manager"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_bonus_mail_title"),
    body = function(msg, periodStart, periodEnd)
      local bodyInfo = {}
      bodyInfo.msg = tostring(msg)
      bodyInfo.periodStart = periodStart
      bodyInfo.periodEnd = periodEnd
      return bodyInfo
    end
  },
  accountAttendance = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "archeage"),
    title = function(a, b)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "account_attendance_reward_mail_title", a, b)
    end,
    body = function(a)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "account_attendance_reward_mail_body", a)
    end
  },
  itemGradeEnchantFailBreakReward = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "archeage"),
    title = function(brokenItemTypeStr)
      local name = X2Item:Name(tonumber(brokenItemTypeStr)) or "Unknown Item"
      return X2Locale:LocalizeUiText(COMMON_TEXT, "item_grade_enchant_fail_break_reward_mail_title", name)
    end,
    body = function(brokenItemTypeStr, rewardItemTypeStr, rewardItemGradeStr, rewardItemCountStr)
      local brokenItemName = X2Item:Name(tonumber(brokenItemTypeStr)) or "Unknown Item"
      local rewardItemName = X2Item:Name(tonumber(rewardItemTypeStr)) or "Unknown Item"
      return X2Locale:LocalizeUiText(COMMON_TEXT, "item_grade_enchant_fail_break_reward_mail_body", brokenItemName, rewardItemName, rewardItemCountStr)
    end
  },
  itemSmeltingResultItemMail = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "archeage"),
    title = function(resultItemType)
      local name = X2Item:Name(tonumber(resultItemType)) or "Unknown Item"
      return X2Locale:LocalizeUiText(COMMON_TEXT, "item_smelting_result_item_mail_title", name)
    end,
    body = function(targetItemTypeStr, resultItemTypeStr, resultItemGradeStr, resultItemCountStr)
      local targetItemName = X2Item:Name(tonumber(targetItemTypeStr)) or "Unknown Item"
      local resultItemName = X2Item:Name(tonumber(resultItemTypeStr)) or "Unknown Item"
      return X2Locale:LocalizeUiText(COMMON_TEXT, "item_smelting_result_item_mail_body", targetItemName, resultItemName, resultItemCountStr)
    end
  },
  expeditionWar = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "archeage"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "refund_war_deposit_title"),
    body = X2Locale:LocalizeUiText(COMMON_TEXT, "refund_war_deposit")
  },
  expeditionImmigrationReject = {
    title = function(titleText)
      return titleText
    end,
    sender = function(senderText)
      return senderText
    end,
    body = function(nationName)
      local bodyInfo = {}
      bodyInfo.nationName = nationName
      return bodyInfo
    end
  },
  residentBalance = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "resident_balance_sender"),
    title = function(zoneName)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "resident_balance_receipt_title", zoneName)
    end,
    body = function(zoneGroup, totalServicePoint, myServicePoint, totalCharge, chargeRate, myDividend)
      local bodyInfo = {}
      bodyInfo.zoneGroupType = zoneGroup
      bodyInfo.totalServicePoint = totalServicePoint
      bodyInfo.myServicePoint = myServicePoint
      bodyInfo.totalCharge = totalCharge
      bodyInfo.chargeRate = chargeRate
      bodyInfo.myDividend = myDividend
      return bodyInfo
    end
  },
  balanceReceipt = {
    sender = X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_sender"),
    title = function(zoneName)
      return X2Locale:LocalizeUiText(MAIL_TEXT, "balance_receipt_title", zoneName)
    end
  },
  battleFieldReward = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "battle_field_sender"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "battle_field_title"),
    body = function(battleFieldName, state, rank)
      local stateStr = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, state)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "battle_field_body", battleFieldName, stateStr, rank)
    end
  },
  bestRatingReward = {
    sender = X2Locale:LocalizeUiText(COMMON_TEXT, "best_rating_reward_mail_sender"),
    title = X2Locale:LocalizeUiText(COMMON_TEXT, "best_rating_reward_mail_title"),
    body = function(battleFieldName, oldRating, newRating)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "best_rating_reward_mail_body", battleFieldName, oldRating, newRating)
    end
  },
  dyeingReward = {
    sender = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "archeage"),
    title = function()
      return X2Locale:LocalizeUiText(COMMON_TEXT, "dyeing_reward_title")
    end,
    body = function(itemType)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "dyeing_reward_content", X2Item:Name(itemType))
    end
  },
  dyeingAddedReward = {
    sender = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "archeage"),
    title = function(titleStr)
      return titleStr
    end,
    body = function(itemType)
      return X2Locale:LocalizeUiText(COMMON_TEXT, "dyeing_reward_content", X2Item:Name(itemType))
    end
  },
  indunRoundReward = {
    sender = function(instanceId, mailKind)
      local instanceType = tonumber(instanceId)
      local mailType = tonumber(mailKind)
      local info = X2BattleField:GetInstanceRewardMailInfo(instanceType, mailType)
      if info ~= nil and info.mailSender ~= nil and info.mailSender ~= "" then
        return info.mailSender
      end
      return X2Locale:LocalizeUiText(COMMON_TEXT, "indun_round_reward_mail_sender")
    end,
    title = function(instanceId, mailKind)
      local instanceType = tonumber(instanceId)
      local mailType = tonumber(mailKind)
      local info = X2BattleField:GetInstanceRewardMailInfo(instanceType, mailType)
      if info ~= nil and info.mailTitle ~= nil and info.mailTitle ~= "" then
        return info.mailTitle
      end
      return X2Locale:LocalizeUiText(COMMON_TEXT, "indun_round_reward_mail_title")
    end,
    body = function(instanceId, mailKind)
      local instanceType = tonumber(instanceId)
      local mailType = tonumber(mailKind)
      local info = X2BattleField:GetInstanceRewardMailInfo(instanceType, mailType)
      if info ~= nil and info.mailBody ~= nil and info.mailBody ~= "" then
        return info.mailBody
      end
      return X2Locale:LocalizeUiText(COMMON_TEXT, "indun_round_reward_mail_content")
    end
  },
  factionKickInactive = {
    sender = X2Util:ApplyUIMacroString(X2Locale:LocalizeUiText(MAIL_TEXT, "faction_kick_inactive_sender")),
    title = X2Locale:LocalizeUiText(MAIL_TEXT, "faction_kick_inactive_title"),
    body = X2Util:ApplyUIMacroString(X2Locale:LocalizeUiText(MAIL_TEXT, "faction_kick_inactive_body", tostring(X2Faction:GetFactionKickInactiveDay())))
  }
}
locale.mail.balanceReceipt.body = locale.mail.residentBalance.body
function GetMailText(sender, text)
  if string.byte(sender, 1) ~= 46 then
    if text == "sender" then
      return sender
    else
      return text
    end
  end
  local code = "return locale.mail" .. sender .. "." .. text
  local f = loadstring(code)
  if f == nil then
    if sender == ".questMail" and string.find(text, "\r\n") then
      text = string.gsub(text, "body%(%'", "")
      text = string.gsub(text, "%'%)", "")
    elseif sender == ".scheduleItem" and (string.find(text, "\r") or string.find(text, "\n")) then
      text = string.gsub(text, "\r", "")
      text = string.gsub(text, "\n", "\\n")
      f = loadstring("return locale.mail" .. sender .. "." .. text)
    end
    if f == nil then
      return text
    end
  end
  local found
  pcall(function()
    found = f()
  end)
  if found == nil then
    return text
  end
  if type(found) == "function" then
    found = found()
  end
  return found
end
locale.raid = {
  option = X2Locale:LocalizeUiText(RAID_TEXT, "option"),
  title = X2Locale:LocalizeUiText(RAID_TEXT, "raid_title"),
  changeToRaid = X2Locale:LocalizeUiText(RAID_TEXT, "convert_raid"),
  rangeInvite = X2Locale:LocalizeUiText(RAID_TEXT, "area_invite"),
  dismissRaid = X2Locale:LocalizeUiText(RAID_TEXT, "dismiss_raid"),
  leaveRaid = X2Locale:LocalizeUiText(RAID_TEXT, "leave_raid"),
  party = X2Locale:LocalizeUiText(RAID_TEXT, "party"),
  leaderTip = X2Locale:LocalizeUiText(RAID_TEXT, "raid_owner"),
  subleaderTip = X2Locale:LocalizeUiText(RAID_TEXT, "raid_officer"),
  lootingTip = X2Locale:LocalizeUiText(RAID_TEXT, "looting_manager"),
  dismissed = X2Locale:LocalizeUiText(RAID_TEXT, "dismiss_raid_message"),
  setMode = X2Locale:LocalizeUiText(RAID_TEXT, "set_raid_viewmode"),
  normalMode = X2Locale:LocalizeUiText(RAID_TEXT, "show_bigger"),
  simpleMode = X2Locale:LocalizeUiText(RAID_TEXT, "show_smaller"),
  setArray = X2Locale:LocalizeUiText(RAID_TEXT, "set_raid_ui_show"),
  horizontal = X2Locale:LocalizeUiText(RAID_TEXT, "show_horizontal"),
  vertical = X2Locale:LocalizeUiText(RAID_TEXT, "show_vertical"),
  partyVisibleToRaid = X2Locale:LocalizeUiText(RAID_TEXT, "show_party_info"),
  invisibleRaidFrame = X2Locale:LocalizeUiText(RAID_TEXT, "show_raid_info"),
  setInvitation = X2Locale:LocalizeUiText(RAID_TEXT, "set_invite"),
  refuseInvitation = X2Locale:LocalizeUiText(RAID_TEXT, "reject_area_invite"),
  setMyRole = X2Locale:LocalizeUiText(RAID_TEXT, "set_my_role")
}
locale.siegeRaid = {
  registerDlgTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_dlg_title"),
  registerDlgDesc = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_dlg_desc"),
  notVolunteerPeriod = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_volunteer_not_period"),
  unregisterDlgTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_unregister_dlg_title"),
  registerWindowTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_window_title"),
  dominionsTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_dominions_title"),
  registersTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_registers_title"),
  registersEmptyDesc = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_registers_empty_desc"),
  prepareSiegeZone = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_prepare_siege_zone"),
  reserveState = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_reserve_state"),
  scheduleText = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_schedule_text"),
  scheduleTooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_schedule_tooltip"),
  registerBtn = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_btn"),
  unregisterBtn = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_unregister_btn"),
  registerReserve = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_reserve"),
  heroGrade = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_hero_grade"),
  suggestionsDesc = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_suggestions_desc"),
  appointWindowTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_appoint_window_title"),
  teamSuggestionsTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_suggestions_title"),
  title = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team"),
  owner = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_owner"),
  officer = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_officer"),
  appointOfficer = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_officer_appoint"),
  leaveTeam = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_leave"),
  leaveTeamError = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_leave_error"),
  kickedMsg = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_kicked"),
  inviteRejectMsg = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_invite_reject"),
  supportSiegeRaidTeamReadySiege = X2Locale:LocalizeUiText(COMMON_TEXT, "support_siege_raid_team_ready_siege"),
  alreadyCreateSiegeRaidTeamReadySiege = X2Locale:LocalizeUiText(COMMON_TEXT, "alreay_create_siege_raid_team_ready_siege")
}
locale.team = {
  leaveTeamError = X2Locale:LocalizeUiText(TEAM_TEXT, "leave_team_error"),
  dismiss = function()
    if X2Team:IsRaidTeam() == true then
      if X2Team:IsJointTeam() == true then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "raid_joint_dismiss_btn")
      else
        return locale.raid.dismissRaid
      end
    else
      return X2Locale:LocalizeUiText(TEAM_TEXT, "dimiss_party")
    end
  end,
  leave = function()
    if X2Team:IsRaidTeam() == true then
      if X2Team:IsSiegeRaidTeam() == true then
        return locale.siegeRaid.leaveTeam
      else
        return locale.raid.leaveRaid
      end
    else
      return X2Locale:LocalizeUiText(TEAM_TEXT, "leave_party")
    end
  end,
  leaderTip = function()
    if X2Team:IsRaidTeam() == true then
      return locale.raid.leaderTip
    else
      return X2Locale:LocalizeUiText(TEAM_TEXT, "team_owner")
    end
  end,
  subleaderTip = locale.raid.subleaderTip,
  lootingTip = X2Locale:LocalizeUiText(TEAM_TEXT, "looting_manager"),
  setOfficer = X2Locale:LocalizeUiText(TEAM_TEXT, "set_raid_officer"),
  setlootingOfficer = X2Locale:LocalizeUiText(TEAM_TEXT, "set_looting_manager"),
  createPartyMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "create_party_message"),
  createRaidMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "create_raid_message"),
  joinPartyMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "join_party_message"),
  joinRaidMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "join_raid_message"),
  rejectPartyInviteMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "reject_party_invite_message"),
  rejectRaidInviteMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "reject_raid_invite_message"),
  kickPartyMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "kick_party_message"),
  kickRaidMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "kick_raid_message"),
  dismissPartyMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "dismiss_party_message"),
  leavePartyMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "leave_party_message"),
  leaveRaidMessage = X2Locale:LocalizeUiText(TEAM_TEXT, "leave_raid_message")
}
locale.team.msgFunc = {}
function locale.team.msgFunc.joined_by_self(isParty, jointOrder, a, roleType)
  if isParty == true then
    if a == myName then
      return locale.team.createPartyMessage
    end
    return X2Locale:LocalizeUiText(TEAM_TEXT, "whose_join_party", a)
  else
    if a == myName then
      if roleType ~= nil and roleType == "siege_raid" then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "create_siege_raid_message")
      else
        return locale.team.createRaidMessage
      end
    end
    if roleType ~= nil and roleType == "siege_raid" then
      return X2Locale:LocalizeUiText(COMMON_TEXT, "whose_join_siege_raid", a)
    else
      return X2Locale:LocalizeUiText(TEAM_TEXT, "whose_join_raid", a)
    end
  end
end
function locale.team.msgFunc.joined(isParty, jointOrder, a, roleType)
  local myTeamOrder = X2Team:GetMyTeamJointOrder()
  if myTeamOrder ~= jointOrder then
    return nil
  end
  if isParty then
    if a == nil then
      return locale.team.joinPartyMessage
    end
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_join_party", a)
  else
    if a == nil then
      if roleType ~= nil and roleType == "siege_raid" then
        return X2Locale:LocalizeUiText(COMMON_TEXT, "join_siege_raid_message")
      else
        return locale.team.joinRaidMessage
      end
    end
    if roleType ~= nil and roleType == "siege_raid" then
      return X2Locale:LocalizeUiText(COMMON_TEXT, "who_join_siege_raid", a)
    else
      return X2Locale:LocalizeUiText(TEAM_TEXT, "who_join_raid", a)
    end
  end
end
function locale.team.msgFunc.kicked_by_self(isParty, jointOrder, a, roleType)
  if isParty then
    return locale.team.kickPartyMessage
  elseif roleType ~= nil and roleType == "siege_raid" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "kick_siege_raid_message")
  else
    return locale.team.kickRaidMessage
  end
end
function locale.team.msgFunc.kicked(isParty, jointOrder, a, roleType)
  local myTeamOrder = X2Team:GetMyTeamJointOrder()
  if myTeamOrder ~= jointOrder then
    return nil
  end
  if isParty then
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_kick_party", a)
  elseif roleType ~= nil and roleType == "siege_raid" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "who_kick_siege_raid", a)
  else
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_kick_raid", a)
  end
end
function locale.team.msgFunc.dismissed(isParty, jointOrder, a, roleType)
  if isParty then
    return locale.team.dismissPartyMessage
  elseif roleType ~= nil and roleType == "siege_raid" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "dismiss_siege_raid_message")
  else
    return locale.raid.dismissed
  end
end
function locale.team.msgFunc.invitation_rejected_by_self(isParty, jointOrder, a, roleType)
  if isParty then
    return locale.team.rejectPartyInviteMessage
  elseif roleType ~= nil and roleType == "siege_raid" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "reject_siege_raid_invite_message", a)
  else
    return locale.team.rejectRaidInviteMessage
  end
end
function locale.team.msgFunc.invitation_rejected(isParty, jointOrder, a, roleType)
  local myTeamOrder = X2Team:GetMyTeamJointOrder()
  if myTeamOrder ~= jointOrder then
    return nil
  end
  if isParty then
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_reject_party", a)
  elseif roleType ~= nil and roleType == "siege_raid" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "who_reject_siege_raid", a)
  else
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_reject_raid", a)
  end
end
function locale.team.msgFunc.leaved_by_self(isParty, jointOrder)
  if isParty then
    return locale.team.leavePartyMessage
  else
    return locale.team.leaveRaidMessage
  end
end
function locale.team.msgFunc.leaved(isParty, jointOrder, a)
  local myTeamOrder = X2Team:GetMyTeamJointOrder()
  if myTeamOrder ~= jointOrder then
    return nil
  end
  if isParty then
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_leave_party", a)
  else
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_leave_raid", a)
  end
end
function locale.team.msgFunc.owner_changed(isParty, jointOrder, a)
  if isParty then
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_party_owner", a)
  elseif X2Team:IsJointTeam() then
    if X2Team:IsJointLeader() == (jointOrder == X2Team:GetMyTeamJointOrder()) then
      return GetCommonText("raid_joint_be_owner", a)
    else
      return GetCommonText("raid_joint_be_officer", a)
    end
  else
    return X2Locale:LocalizeUiText(TEAM_TEXT, "who_raid_owner", a)
  end
end
function locale.team.msgFunc.officer_changed(isParty, jointOrder, a, roleType)
  if roleType ~= nil and roleType == "siege_raid" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "appoint_siege_raid_officer", a)
  end
end
locale.banPlayer = {
  banNoitfyMessage = X2Locale:LocalizeUiText(COMMON_TEXT, "ban_player_notify"),
  banNoitfyMessage = X2Locale:LocalizeUiText(COMMON_TEXT, "ban_already_trying"),
  banNoitfyMessage = X2Locale:LocalizeUiText(COMMON_TEXT, "ban_not_yet_cooltime")
}
locale.banPlayer.msgFunc = {}
function locale.banPlayer.msgFunc.success(a)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "ban_player_success", a)
end
function locale.banPlayer.msgFunc.fail(a)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "ban_player_failed", a)
end
locale.role = {
  tanker = X2Locale:LocalizeUiText(RAID_TEXT, "raid_role_tanker"),
  healer = X2Locale:LocalizeUiText(RAID_TEXT, "raid_role_healer"),
  dealer = X2Locale:LocalizeUiText(RAID_TEXT, "raid_role_dealer"),
  norole = X2Locale:LocalizeUiText(RAID_TEXT, "raid_role_none")
}
locale.squad = {
  invite = X2Locale:LocalizeUiText(COMMON_TEXT, "squad_invite"),
  expel = X2Locale:LocalizeUiText(COMMON_TEXT, "squad_expel"),
  delegate = X2Locale:LocalizeUiText(COMMON_TEXT, "squad_delegate"),
  leave = X2Locale:LocalizeUiText(COMMON_TEXT, "squad_leave")
}
locale.slave = {
  title = X2Locale:LocalizeUiText(SLAVE_TEXT, "slave_info_title"),
  kind = X2Locale:LocalizeUiText(SLAVE_TEXT, "slave_kind"),
  class = X2Locale:LocalizeUiText(SLAVE_TEXT, "slave_class"),
  move_speed = X2Locale:LocalizeUiText(SLAVE_TEXT, "slave_move_speed"),
  turn_speed = X2Locale:LocalizeUiText(SLAVE_TEXT, "slave_turn_speed"),
  titleGear = X2Locale:LocalizeUiText(SLAVE_TEXT, "title_gear"),
  titleBrake = X2Locale:LocalizeUiText(SLAVE_TEXT, "title_brake"),
  titleTractionCtrl = X2Locale:LocalizeUiText(SLAVE_TEXT, "title_traction_ctrl"),
  on = X2Locale:LocalizeUiText(SLAVE_TEXT, "on"),
  off = X2Locale:LocalizeUiText(SLAVE_TEXT, "off"),
  gearValue = {
    X2Locale:LocalizeUiText(SLAVE_TEXT, "backward_movement"),
    X2Locale:LocalizeUiText(SLAVE_TEXT, "neutral_movement")
  },
  gearGrade = {
    X2Locale:LocalizeUiText(SLAVE_TEXT, "gear_1"),
    X2Locale:LocalizeUiText(SLAVE_TEXT, "gear_2"),
    X2Locale:LocalizeUiText(SLAVE_TEXT, "gear_3")
  }
}
locale.pet = {
  toggle = {
    follow = X2Locale:LocalizeUiText(PET_TEXT, "toggle_follow"),
    stop = X2Locale:LocalizeUiText(PET_TEXT, "toggle_stop"),
    getOn = X2Locale:LocalizeUiText(PET_TEXT, "toggle_get_on"),
    getOff = X2Locale:LocalizeUiText(PET_TEXT, "toggle_get_off")
  },
  command = {
    follow = X2Locale:LocalizeUiText(PET_TEXT, "command_follow"),
    stop = X2Locale:LocalizeUiText(PET_TEXT, "command_stop"),
    mount = X2Locale:LocalizeUiText(PET_TEXT, "command_mount"),
    unmount = X2Locale:LocalizeUiText(PET_TEXT, "command_unmount"),
    openEquip = X2Locale:LocalizeUiText(PET_TEXT, "command_open_equip"),
    closeEquip = X2Locale:LocalizeUiText(PET_TEXT, "command_close_equip"),
    openBag = X2Locale:LocalizeUiText(PET_TEXT, "command_open_bag"),
    closeBag = X2Locale:LocalizeUiText(PET_TEXT, "command_close_bag"),
    passengerGetOff = X2Locale:LocalizeUiText(PET_TEXT, "command_passenger_get_off"),
    cya = X2Locale:LocalizeUiText(PET_TEXT, "command_cya"),
    attack = X2Locale:LocalizeUiText(COMMON_TEXT, "command_attack"),
    guides = {
      follow = X2Locale:LocalizeUiText(PET_TEXT, "command_guides_follow"),
      mount = X2Locale:LocalizeUiText(PET_TEXT, "command_guides_mount"),
      openEquip = X2Locale:LocalizeUiText(PET_TEXT, "command_guides_open_equip"),
      openBag = X2Locale:LocalizeUiText(PET_TEXT, "command_guides_open_bag"),
      passengerGetOff = X2Locale:LocalizeUiText(PET_TEXT, "command_guides_passenger_get_off"),
      cya = X2Locale:LocalizeUiText(PET_TEXT, "command_guides_cya"),
      attack = X2Locale:LocalizeUiText(COMMON_TEXT, "command_guides_attack")
    }
  },
  helmet = X2Locale:LocalizeUiText(PET_TEXT, "helmet"),
  armor = X2Locale:LocalizeUiText(PET_TEXT, "armor"),
  saddle = X2Locale:LocalizeUiText(PET_TEXT, "saddle"),
  shoes = X2Locale:LocalizeUiText(PET_TEXT, "shoes"),
  info = {
    title = X2Locale:LocalizeUiText(PET_TEXT, "equip_title")
  },
  bag = X2Locale:LocalizeUiText(PET_TEXT, "bag"),
  petBagGuide = X2Locale:LocalizeUiText(PET_TEXT, "pet_bag_guide"),
  okButton = X2Locale:LocalizeUiText(PET_TEXT, "ok_button"),
  state = {
    guides = {
      aggressive = X2Locale:LocalizeUiText(PET_TEXT, "state_aggressive"),
      protective = X2Locale:LocalizeUiText(PET_TEXT, "state_protective"),
      passive = X2Locale:LocalizeUiText(PET_TEXT, "state_passive"),
      stand = X2Locale:LocalizeUiText(PET_TEXT, "state_stand")
    }
  },
  action = {
    cannotSetAutoUse1 = "|cFFFF0000" .. X2Locale:LocalizeUiText(PET_TEXT, "autoskill_message1"),
    cannotSetAutoUse2 = "|cFFFF0000" .. X2Locale:LocalizeUiText(PET_TEXT, "autoskill_message2")
  },
  unsummon_mate_equip = X2Locale:LocalizeUiText(PET_TEXT, "unsummon_mate_equip"),
  item_not_equip_for_pet = X2Locale:LocalizeUiText(PET_TEXT, "item_not_equip_for_pet"),
  unsummon_slave_equip = X2Locale:LocalizeUiText(SLAVE_TEXT, "unsummon_slave_equip"),
  item_not_equip_for_slave = X2Locale:LocalizeUiText(SLAVE_TEXT, "item_not_equip_for_slave"),
  GetLevelText = function(a)
    return X2Locale:LocalizeUiText(PET_TEXT, "level", IStr(a))
  end
}
locale.abilityChanger = {
  GetExchangeText = function(sourceAbilityName, targetAbilityName)
    return X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "exchange", sourceAbilityName, targetAbilityName)
  end,
  GetNeedMoneyText = function(s, p)
    return X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "need_money", tostring(s), tostring(p))
  end,
  title = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "title"),
  abilityList = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "ability_list"),
  myAbilityList = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "my_ability_list"),
  changeAbility = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "change_ability"),
  change = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "change"),
  cancel = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "cancel"),
  selectAbility = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "select_ability"),
  cantExchangeAbility = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "cant_exchange_ability"),
  lackCost = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "lack_cost"),
  sameSelectAbility = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "same_select_ability"),
  reqActivationAbility = X2Locale:LocalizeUiText(ABILITY_CHANGER_TEXT, "req_activation_ability")
}
locale.priest = {
  title = X2Locale:LocalizeUiText(PRIEST_TEXT, "title"),
  donate = X2Locale:LocalizeUiText(PRIEST_TEXT, "donate"),
  noRecoverableExp = X2Locale:LocalizeUiText(PRIEST_TEXT, "no_recoverable_exp"),
  needLaborPower = function(a)
    return string.format("%s %s", locale.attribute("labor_power"), CommaStr(a))
  end
}
locale.unitFrame = {
  combatTip = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "combat_tip"),
  pvpTip = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "pvp_tip"),
  partyLeaderTip = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "party_leader_tip"),
  eliteNpc = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "elite_npc"),
  transfer = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "transfer"),
  mate = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "mate"),
  housing = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "housing"),
  potal = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "potal"),
  slave = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "slave"),
  stack = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "stack"),
  noneOwner = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "none_owner"),
  offline = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "offline"),
  overHeadMarker = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "over_head_marker"),
  removeAll = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "remove_all"),
  pvp_honor_point = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "pvp_honor_point"),
  pvp_kill_point = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "pvp_kill_point"),
  expedition = X2Locale:LocalizeUiText(COMMON_TEXT, "expedition")
}
locale.duel = {
  challenge = X2Locale:LocalizeUiText(DUEL_TEXT, "challenge_duel"),
  mbox_msg = X2Locale:LocalizeUiText(DUEL_TEXT, "challenge_mbox_msg"),
  text = X2Locale:LocalizeUiText(DUEL_TEXT, "duel"),
  ask_duel_msg = function(challengerName)
    return X2Locale:LocalizeUiText(DUEL_TEXT, "challenge_mbox_msg", challengerName)
  end,
  result_draw = X2Locale:LocalizeUiText(DUEL_TEXT, "result_draw"),
  result_winner = X2Locale:LocalizeUiText(DUEL_TEXT, "result_winner"),
  result_loser = X2Locale:LocalizeUiText(DUEL_TEXT, "result_loser"),
  result_remained = X2Locale:LocalizeUiText(DUEL_TEXT, "result_remained"),
  result_runaway = X2Locale:LocalizeUiText(DUEL_TEXT, "result_runaway")
}
locale.menu = {}
locale.menu.option = X2Locale:LocalizeUiText(OPTION_TEXT, "menu_option")
locale.menu.hotkey = X2Locale:LocalizeUiText(OPTION_TEXT, "menu_hotkey")
locale.menu.selectCharacter = X2Locale:LocalizeUiText(OPTION_TEXT, "select_character")
locale.menu.selectWorld = X2Locale:LocalizeUiText(OPTION_TEXT, "select_world")
locale.menu.exit = X2Locale:LocalizeUiText(OPTION_TEXT, "menu_exit")
locale.menu.set_option = X2Locale:LocalizeUiText(OPTION_TEXT, "set_option")
locale.menu.apply = X2Locale:LocalizeUiText(OPTION_TEXT, "apply")
locale.menu.default = X2Locale:LocalizeUiText(OPTION_TEXT, "default")
locale.menu.option = X2Locale:LocalizeUiText(OPTION_TEXT, "option")
locale.menu.optionwindow = {
  resetUI = X2Locale:LocalizeUiText(OPTION_TEXT, "option_window_reset_ui"),
  resetKeyBinding = X2Locale:LocalizeUiText(OPTION_TEXT, "option_window_reset_key_binding"),
  releaseKeyBinding = X2Locale:LocalizeUiText(OPTION_TEXT, "option_window_release_key_binding"),
  reset_button_tooltip = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_window_reset_button_tooltip"),
  key_reset_button_tooltip = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_window_key_reset_button_tooltip"),
  key_release_button_tooltip = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_window_key_release_button_tooltip"),
  ok_button_tooltip = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "option_window_ok_button_tooltip"),
  restartTip = X2Locale:LocalizeUiText(OPTION_TEXT, "restart_tip")
}
locale.optionWindow = {}
locale.optionWindow.screen = {
  title = X2Locale:LocalizeUiText(OPTION_TEXT, "group_title_screen"),
  menuText = {
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_item_screen"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_item_screen_quality")
  }
}
locale.optionWindow.sound = {
  title = X2Locale:LocalizeUiText(OPTION_TEXT, "option_sound_title"),
  setDefault = X2Locale:LocalizeUiText(OPTION_TEXT, "option_set_default")
}
locale.optionWindow.interface = {
  title = X2Locale:LocalizeUiText(OPTION_TEXT, "group_title_game"),
  SetDegree = function(value)
    return X2Locale:LocalizeUiText(OPTION_TEXT, "degree", tostring(value))
  end,
  menuText = {
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_interface_nametag"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_interface_game_info"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_interface_function"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_interface_ui_short_cut")
  }
}
locale.optionWindow.key = {
  title = X2Locale:LocalizeUiText(OPTION_TEXT, "menu_hotkey"),
  menuText = {
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_char_ctrl"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_vehicle_ctrl"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_game_control"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_cam_ctrl"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_ui_call"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_short_cut"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option_hotkey_menu_addtion")
  }
}
locale.auction = {
  guideText = X2Locale:LocalizeUiText(AUCTION_TEXT, "input_item_name"),
  deposit = X2Locale:LocalizeUiText(AUCTION_TEXT, "auction_guaranty"),
  myselfBid = X2Locale:LocalizeUiText(AUCTION_TEXT, "myself_bid"),
  otherPeopleBid = X2Locale:LocalizeUiText(AUCTION_TEXT, "other_people_bid"),
  myPutupGoods = X2Locale:LocalizeUiText(AUCTION_TEXT, "my_putup_goods"),
  bidState = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_state"),
  myBiddingPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "my_bidding_price"),
  currentBidPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "current_bid_price"),
  putUp = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_putup"),
  storePrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "store_price"),
  lowestPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "lowest_price"),
  startPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "start_price"),
  directPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "direct_price"),
  directPriceTooltip = X2Locale:LocalizeUiText(AUCTION_TEXT, "direct_price_tooltip"),
  bidPriceTooltip = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_price_tooltip"),
  lowDirectPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "lowDirectPrice"),
  eachPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "eachPrice"),
  bundlePrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "bundlePrice"),
  lowestEachPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "lowestEachPrice"),
  putupPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "putupPrice"),
  amount = X2Locale:LocalizeUiText(AUCTION_TEXT, "amount"),
  searching = X2Locale:LocalizeUiText(AUCTION_TEXT, "searching"),
  no_lowest_price = X2Locale:LocalizeUiText(AUCTION_TEXT, "no_lowest_price"),
  biddingTime = X2Locale:LocalizeUiText(AUCTION_TEXT, "bidding_time"),
  myPutupCount = X2Locale:LocalizeUiText(AUCTION_TEXT, "my_putup_count"),
  bidSuccesfullyCommission = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_succesfully_commission"),
  bid = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid"),
  bid_money = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_money"),
  putup = X2Locale:LocalizeUiText(AUCTION_TEXT, "putup"),
  bidHistory = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_history"),
  notBid = X2Locale:LocalizeUiText(AUCTION_TEXT, "not_bid"),
  bidding = X2Locale:LocalizeUiText(AUCTION_TEXT, "bidding"),
  search = X2Locale:LocalizeUiText(AUCTION_TEXT, "search"),
  name = X2Locale:LocalizeUiText(AUCTION_TEXT, "name"),
  type = X2Locale:LocalizeUiText(AUCTION_TEXT, "type"),
  count = X2Locale:LocalizeUiText(AUCTION_TEXT, "count"),
  seller = X2Locale:LocalizeUiText(AUCTION_TEXT, "seller"),
  leftTime = X2Locale:LocalizeUiText(AUCTION_TEXT, "left_time"),
  bidPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_price"),
  selfBidPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "self_bid_price"),
  directBid = X2Locale:LocalizeUiText(AUCTION_TEXT, "direct_bid"),
  directForbidden = X2Locale:LocalizeUiText(AUCTION_TEXT, "direct_forbidden"),
  under_time = X2Locale:LocalizeUiText(AUCTION_TEXT, "under_time"),
  visibleBidding = X2Locale:LocalizeUiText(AUCTION_TEXT, "visible_bidding"),
  putupItem = X2Locale:LocalizeUiText(AUCTION_TEXT, "putup_item"),
  itemCondition = X2Locale:LocalizeUiText(AUCTION_TEXT, "item_condition"),
  cancelBid = X2Locale:LocalizeUiText(AUCTION_TEXT, "cancel_bid"),
  searchConditionInit = X2Locale:LocalizeUiText(AUCTION_TEXT, "search_condition_init"),
  levelRange = X2Locale:LocalizeUiText(AUCTION_TEXT, "level_range"),
  itemGrade = X2Locale:LocalizeUiText(AUCTION_TEXT, "item_grade"),
  matchWord = X2Locale:LocalizeUiText(AUCTION_TEXT, "match_word"),
  level = X2Locale:LocalizeUiText(AUCTION_TEXT, "level"),
  refreshTooltip = X2Locale:LocalizeUiText(AUCTION_TEXT, "refresh_tooltip"),
  askDirectMsg = function(itemName, stackCountStr)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "ask_direct_message", itemName, stackCountStr)
  end,
  putupMsg = function(a)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "putup_message", a)
  end,
  cancelMsg = function(a)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "cancel_message", a)
  end,
  biddedMsg = function(a, b)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "bidded_message", a, b)
  end,
  boughtMsg = function(a, b)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "bought_message", a, b)
  end,
  biddenMsg = function(a, b)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "bidden_message", a, b)
  end,
  boughtBySomeoneMsg = function(a, b)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "bought_by_someone_message", a, b)
  end,
  levelTooLowMsg = function(a, b)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, a, b)
  end,
  first_search_guide = X2Locale:LocalizeUiText(AUCTION_TEXT, "first_search_guide"),
  none_search_result = X2Locale:LocalizeUiText(AUCTION_TEXT, "none_search_result"),
  bidPartition = X2Locale:LocalizeUiText(AUCTION_TEXT, "bid_partition"),
  sellPartition = X2Locale:LocalizeUiText(AUCTION_TEXT, "sell_partition"),
  sellMinStackCount = X2Locale:LocalizeUiText(AUCTION_TEXT, "sell_min_stack_count"),
  bidMinStack = X2Locale:LocalizeUiText(AUCTION_TEXT, "auction_bid_min_stack"),
  bidMaxStack = X2Locale:LocalizeUiText(AUCTION_TEXT, "auction_bid_max_stack"),
  buy = X2Locale:LocalizeUiText(AUCTION_TEXT, "buy"),
  heirLevelSearchTooltip = X2Locale:LocalizeUiText(AUCTION_TEXT, "heir_level_search_tooltip"),
  minStackCount = function(countStr)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "min_stack_bid_count", countStr)
  end,
  minStackPrice = X2Locale:LocalizeUiText(AUCTION_TEXT, "min_stack_price"),
  depositTooltipTitle = X2Locale:LocalizeUiText(AUCTION_TEXT, "deposit_tooltip_title"),
  depositTooltipRateByTime = function(putupTime, depositRatio)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "deposit_tooltip_rate_by_time", putupTime, depositRatio)
  end,
  depositTooltipMaxPrice = function(maxDepositRatio)
    local moneyStr = string.format("|m%s;", maxDepositRatio)
    if F_MONEY.currency.auctionFee == CURRENCY_AA_POINT then
      moneyStr = string.format("|p%s;", maxDepositRatio)
    end
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "deposit_tooltip_max_price", moneyStr)
  end,
  depositTooltipInfo = function(depositRateStr, maxDepositStr)
    local text = X2Locale:LocalizeUiText(AUCTION_TEXT, "deposit_tooltip_info")
    for i = 1, #depositRateStr do
      text = text .. "\n" .. depositRateStr[i]
    end
    text = text .. "\n" .. maxDepositStr
    return text
  end,
  chargeTooltipTitle = function(text)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_title", text)
  end,
  chargeTooltipInfo = X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_info"),
  chargeTooltipTitleExplan = function(text)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_title_explan", text)
  end,
  chargeTooltipTitleNormal = X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_title_normal"),
  chargeTooltipTitleItemCharge = function(text)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_title_item_charge", text)
  end,
  chargeTooltipTitlePcbang = function(text)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_title_pcbang", text)
  end,
  chargeTooltipTitlePeriodBuff = function(text)
    return X2Locale:LocalizeUiText(AUCTION_TEXT, "charge_tooltip_title_period_buff", text)
  end
}
locale.messageBoxBtnText = {
  ok = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "ok"),
  cancel = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "cancel"),
  ucc = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "warn_ucc_upload"),
  thief = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "warn_thief_action"),
  payTax = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "pay_tax"),
  apply = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "apply"),
  remove = X2Locale:LocalizeUiText(MSG_BOX_BTN_TEXT, "remove")
}
local MakeAmountText = function(amount)
  if tonumber(amount) > 1 then
    return locale.common.GetAmount(tonumber(amount)) .. " "
  else
    return ""
  end
end
locale.messageBox = {
  default = {
    title = "unknown",
    body = nil,
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_disconnected = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_disconnected"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_disconnected"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_failed_to_connect_to_server = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_failed_to_connect_to_server"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_failed_to_connect_to_server"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_disconnect_from_auth = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_disconnect_from_auth"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_disconnect_from_auth"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_duplicate = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_duplicate"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_duplicate"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_forbidden = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_forbidden"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_forbidden"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_pending = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_pending"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_pending"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_continent_block = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_continent_block"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_continent_block"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_length = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_length"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_length"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_number = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_number"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_number"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_special = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_special"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_special"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_format = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_format"),
    body = function(namePolicyInfo)
      return F_TEXT.GetLimitInfoText(namePolicyInfo)
    end,
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_forbid_char_creation = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_format"),
    body = X2Locale:LocalizeUiText(LOGIN_CROWDED_TEXT, "no_create_race"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_rename_char_format = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_rename_char"),
    body = function(namePolicyInfo)
      return F_TEXT.GetLimitInfoText(namePolicyInfo)
    end,
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_rename_char_forbidden = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_rename_char"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_forbidden"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_rename_char_duplicate = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_rename_char"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_rename_char_duplicate"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_initial_ability = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_initial_ability"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_initial_ability"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_char_name_mismatch = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_char_name_mismatch"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_char_name_mismatch"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_character_expedition_owner = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "EXPEDITION_OWNER_CANNOT_DELETE"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_character_faction_owner = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "FACTION_OWNER_CANNOT_DELETE"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  cannot_delete_char_while_on_play = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_DELETE_CHAR_WHILE_ON_PLAY"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  cannot_delete_char_while_penalty = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_DELETE_CHAR_WHILE_PENALTY"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  cannot_delete_char_while_bot_suspected = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_DELETE_CHAR_WHILE_BOT_SUSPECTED"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  cannot_delete_has_comercial_mail_item = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CANNOT_DELETE_HAS_COMERCIAL_MAIL_ITEM"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_already_requested_character_delete = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_already_requested_character_delete"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_already_requested_character_delete"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_already_requested_character_transfer = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CH_TRANSFER_CANNOT_DELETE_CHARACTER"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_character_delete_failed = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_character_delete_failed"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_cancel_character_delete_failed = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_cancel_character_delete_failed"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_cancel_character_delete_failed"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_character_expedition = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CHARACTER_DELETE_EXPEDITION_JOINED"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_character_faction = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_delete_failed"),
    body = X2Locale:LocalizeUiText(ERROR_MSG, "CHARACTER_DELETE_NATION_JOINED"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_character_connection_restrict = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_character_connection_restrict"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_character_connection_restrict"),
    needsParams = false,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_to_connect_world = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_to_connect_world"),
    body = function(color)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "error_to_connect_world", color)
    end
  },
  option = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "option"),
    body = function(a, b)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "option", a, b)
    end,
    needsParams = true,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  pet = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "pet"),
    body = function(a)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "pet", a)
    end,
    needsParams = true,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  waiting_instance = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "waiting_instance"),
    body = function(a)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "waiting_instance", a)
    end,
    needsParams = true,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  instant_game_bad_level = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "instant_game_bad_level"),
    body = function(battle_ground, level_min)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "instant_game_bad_level", battle_ground, tostring(level_min))
    end,
    needsParams = true,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  error_message = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_message"),
    body = function(msgKey, ...)
      return X2Locale:LocalizeUiText(ERROR_MSG, msgKey, ...)
    end,
    needsParams = true,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  ask_leave_intro_world = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_leave_intro_world"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_leave_intro_world"),
    needsParams = false,
    buttons = {
      locale.messageBoxBtnText.ok,
      locale.messageBoxBtnText.cancel
    }
  },
  duel_result = {
    title = locale.duel.text,
    body = function(resultTxt)
      if resultTxt == "result_draw" then
        return locale.duel.result_draw
      elseif resultTxt == "result_winner" then
        return locale.duel.result_winner
      elseif resultTxt == "result_loser" then
        return locale.duel.result_loser
      elseif resultTxt == "result_remained" then
        return locale.duel.result_remained
      elseif resultTxt == "result_runaway" then
        return locale.duel.result_runaway
      else
        return "error"
      end
    end,
    needsParams = true,
    buttons = {
      nil,
      locale.messageBoxBtnText.ok
    }
  },
  enchantItem = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_enchant_item"),
    GetBodyText = function(scroll, color)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_enchant_item", scroll, color)
    end
  },
  payTax = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "pay_tax"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "pay_tax"),
    buttons = {
      locale.messageBoxBtnText.payTax,
      locale.messageBoxBtnText.cancel
    }
  },
  lookConverter = {
    title = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "detailsTitle"),
    body = function(color)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "lookConverter_body", color)
    end
  },
  lookExtract = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "lookRevert_title"),
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "lookRevert_body")
  },
  secondPasswordConfirmFail = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "confirmation_fail"),
    body = function(a, b, c)
      if c > 0 then
        return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "confirmation_fail_with_retry", tostring(a), tostring(b), tostring(c))
      else
        return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "confirmation_fail")
      end
    end
  },
  secondPasswordCheckOverFailed = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "second_password_check_over_failed")
  },
  second_password_account_locked = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "second_password_account_locked")
  },
  itemSocketInstall = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "socket_install_title"),
    body = function(scroll, color)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "socket_install_body", tostring(scroll), tostring(color))
    end,
    desc = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "socket_install_desc")
  },
  itemSocketUninstall = {
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "socket_uninstall_title"),
    body = function(scroll, color)
      return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "socket_uninstall_body", tostring(scroll), tostring(color))
    end,
    desc = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "socket_uninstall_desc")
  }
}
locale.util = {
  GetChangeExpString = function(gain, expValue)
    if not gain then
      return X2Locale:LocalizeUiText(UTIL_TEXT, "lost_exp_str", tostring(expValue))
    else
      return X2Locale:LocalizeUiText(UTIL_TEXT, "add_exp_str", tostring(expValue))
    end
  end,
  GetChangeAbilityExpString = function(expValue)
    return X2Locale:LocalizeUiText(UTIL_TEXT, "add_ability_exp_str", CommaStr(expValue))
  end,
  GetAddPetExpString = function(expValue)
    return X2Locale:LocalizeUiText(UTIL_TEXT, "add_pet_exp_str", CommaStr(expValue))
  end,
  GetRecoveredExpString = function(expValue)
    return X2Locale:LocalizeUiText(UTIL_TEXT, "recovered_exp_str", CommaStr(expValue))
  end,
  speed_unit = X2Locale:LocalizeUiText(UTIL_TEXT, "speed_unit"),
  rotation_unit = X2Locale:LocalizeUiText(UTIL_TEXT, "rotation_unit")
}
locale.slashCommands = {
  GetMemberInvitationMsg = function(invitee)
    return X2Locale:LocalizeUiText(SLASH_COMMAND_TEXT, "get_member_invitation_msg", invitee)
  end,
  partyLeft = X2Locale:LocalizeUiText(SLASH_COMMAND_TEXT, "party_left"),
  GetMemberKickMsg = function(kickedPlayer)
    return X2Locale:LocalizeUiText(SLASH_COMMAND_TEXT, "get_member_kick_msg", kickedPlayer)
  end
}
locale.tooltip = {
  none = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "none"),
  wearLevel = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "wear_level"),
  attackPower = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_power"),
  attackSpeed = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_speed"),
  attackSecond = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_second"),
  useSkill = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "use_skill"),
  noDescription = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "no_description"),
  equiped = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equiped"),
  magicAttackPower = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "magic_attackpower"),
  healPower = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "heal_power"),
  magicResistance = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "magic_resistance"),
  defencePower = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "defence_power"),
  durability = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "durability"),
  enchantDurability = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "enchant_durability"),
  index = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "index"),
  second = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "second"),
  minute = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "minute"),
  hour = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "hour"),
  day = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "day"),
  now = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "now"),
  rangeSelf = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "range_self"),
  doTime = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "do_time"),
  waitTime = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "wait_time"),
  gem = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "gem"),
  noGem = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "no_gem"),
  crafting_amount = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "crafting_amount"),
  crafting_lp = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "crafting_lp"),
  crafting_pay = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "crafting_pay"),
  crafting_reposit = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "crafting_reposit"),
  crafting_done = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "crafting_done"),
  stack = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "stack"),
  leftTime = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "left_time"),
  inc = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "inc"),
  dec = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "dec"),
  addEffect = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "add_effect"),
  sellYes = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "sell_yes"),
  sellNo = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "sell_no"),
  hp = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "hp"),
  mp = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "mp"),
  soul_bound = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "soul_bound"),
  soulbound_pickup = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "soulbound_pickup"),
  soulbound_equip = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "soulbound_equip"),
  soulbound_unpack = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "soulbound_unpack"),
  cost = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "cost"),
  use_effect = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "use_effect"),
  proc = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "proc"),
  equip_effect = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "equip_effect"),
  player = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "player"),
  portal = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "portal"),
  set = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "set"),
  set_effect = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "set_effect"),
  owner = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "owner"),
  nobody = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "nobody"),
  magicItem = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "magicItem"),
  crafter = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "crafter"),
  craftedWorld = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "craftedWorld"),
  level_requirement = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "level_req"),
  pet_level_requirement = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "pet_level_requirement"),
  level_limit = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "level_limit"),
  pet_level_limit = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "pet_level_limit"),
  item_flag_cannot_equip = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "item_flag_cannot_equip"),
  GetFirstLvRequirements = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "first_level_requirements", a, IStr(b))
  end,
  GetNextLvRequirements = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "next_level_requirements", a, IStr(b))
  end,
  GetLearnPtRequirements = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "learn_point_requirements", a, IStr(b))
  end,
  GetHeirLearnPtRequirements = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "learn_heir_level_requirements", IStr(a))
  end,
  GetCastTime = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "cast_time", FStr(a))
  end,
  GetCooldown = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "cooldown", a)
  end,
  GetRange = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "range", IStr(a), IStr(b))
  end,
  GetSkillLevel = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "skill_level", IStr(a))
  end,
  GetFirstLearnLevel = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "first_learn_level", a, IStr(b))
  end,
  GetNextLearnLevel = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "next_learn_level", a, IStr(b))
  end,
  GetPetSkillLearnLevel = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "pet_skill_learn_level", IStr(a))
  end,
  GetTargetAreaRadius = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "target_area_radius", IStr(a))
  end,
  GetItemExpireRemainTime = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "item_expire_remain_time", a)
  end,
  GetItemLifespanTime = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "item_lifespan_time", a)
  end,
  itemTimeExpired = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "item_time_expired"),
  unbind = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "unbind"),
  showSlaveInfo = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "showSlaveInfo"),
  reqEnchantCondition = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "reqEnchantCondition"),
  reqEnchantSlot = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "reqEnchantSlot", a)
  end,
  reqEnchantItem = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "reqEnchantItem", a)
  end,
  reqEnchantLevelOver = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "reqEnchantLevelOver", a)
  end,
  reqEnchantGradeOver = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "reqEnchantGradeOver", a)
  end,
  rechargeItem = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "rechargeItem"),
  chargeTimeRemained = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "chargeTimeRemained", a)
  end,
  chargeLifetime = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "chargeLifetime", a)
  end,
  expireChargeLifetime = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "expireChargeLifetime"),
  length = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "length", a)
  end,
  weight = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "weight", a)
  end,
  catchedDate = function(a)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "catchedDate", a)
  end,
  actabilityRequirement = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "actabilityRequirement"),
  sellPrice = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "sellPrice"),
  freeLooting = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "freeLooting"),
  autoUseAAPoint = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "auto_use_aa_point"),
  inGameShopToggleButton = function(bindKeyText)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "ingameshop_toggle_button", bindKeyText)
  end,
  enchantable = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "enchantable"),
  lookItem = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "lookItem"),
  socketInfo = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "socketInfo"),
  progressCount = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "progressCount"),
  movePosition = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "movePosition"),
  movePositionInfo = function(a, b)
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "movePositionInfo", a, b)
  end,
  leadership = X2Locale:LocalizeUiText(COMMON_TEXT, "leadership_point"),
  default = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "default")
}
locale.fixedTooltip = {
  buildPercent = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "build_percent")
}
locale.tooltip.attack = {
  X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_type_piercing"),
  X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_type_cut"),
  X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_type_blow")
}
locale.tooltip.attackStrength = {
  X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_strength_strong"),
  X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_strength_normal"),
  X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_strength_weak")
}
locale.instant_game = {
  ready = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "ready"),
  start = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "start"),
  win = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "win"),
  lose = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "lose"),
  draw = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "draw"),
  kill = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "kill"),
  death = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "death"),
  score = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "score"),
  totalScore = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "total_score"),
  saveScore = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "save_score"),
  straightScore = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "straight_score"),
  victory = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "victory"),
  bravery = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "bravery"),
  destroyer = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "cure"),
  immortality = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "immortality"),
  battleWinning = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "battle_winning"),
  battleLosing = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "battle_losing"),
  battleClose = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "battle_close"),
  persons = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "persons"),
  GetRemainTime = function(timeMs)
    local totalSec = math.floor(timeMs / 1000)
    local sec = math.mod(totalSec, 60)
    local totalMinute = math.floor(totalSec / 60)
    local minute = math.mod(totalMinute, 60)
    local totalHour = math.floor(totalMinute / 60)
    return string.format("%02d : %02d", minute, sec)
  end
}
locale.battle = {
  warningDesc = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "warning_desc"),
  startDese = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "start_dese")
}
FORMAT_FILTER = {
  YEAR = 64,
  MONTH = 32,
  DAY = 16,
  HOUR = 8,
  MINUTE = 4,
  SECOND = 2
}
DEFAULT_FORMAT_FILTER = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
locale.time = {
  GetDate = function(year, month, day, hour, minute, second, filter)
    return baselibLocale.GetDate(year, month, day, hour, minute, second, filter)
  end,
  IsEmptyDateFormat = function(df)
    if df.year == 0 and df.month == 0 and df.day == 0 and df.hour == 0 and df.minute == 0 and df.second == 0 then
      return true
    end
    return false
  end,
  GetDateToDateFormat = function(df, filter)
    local func = locale.time.GetDate
    return func(df.year, df.month, df.day, df.hour, df.minute, df.second, filter)
  end,
  GetDateToSimpleDateFormat = function(df)
    local func = baselibLocale.GetSimpleDate
    return func(df.year, df.month, df.day, df.hour, df.minute, df.second)
  end,
  GetRemainDate = function(year, month, day, hour, minute, second, filter)
    filter = filter or DEFAULT_FORMAT_FILTER
    local function Get(value, msg, key)
      if value <= 0 then
        return ""
      end
      if X2Helper:BitwiseAnd(filter, key) == 0 then
        return ""
      end
      return X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, msg, tostring(value))
    end
    if year == 0 and month == 0 and day == 0 and hour == 0 and minute == 0 and X2Helper:BitwiseAnd(filter, FORMAT_FILTER.SECOND) == 0 then
      return X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "less_one_minute")
    end
    local str = string.format("%s%s%s", Get(year, "year", FORMAT_FILTER.YEAR), Get(month, "month", FORMAT_FILTER.MONTH), Get(day, "day", FORMAT_FILTER.DAY))
    local hourStr = Get(hour, "hour", FORMAT_FILTER.HOUR)
    if 0 < string.len(hourStr) then
      str = string.format("%s%s%s", str, 0 < string.len(str) and " " or "", hourStr)
    end
    local minuteStr = Get(minute, "minute", FORMAT_FILTER.MINUTE)
    if 0 < string.len(minuteStr) then
      str = string.format("%s%s%s", str, 0 < string.len(str) and " " or "", minuteStr)
    end
    local secondStr = Get(second, "second", FORMAT_FILTER.SECOND)
    if 0 < string.len(secondStr) then
      str = string.format("%s%s%s", str, 0 < string.len(str) and " " or "", secondStr)
    end
    return str
  end,
  GetRemainDateToDateFormat = function(df, filter)
    local func = locale.time.GetRemainDate
    return func(df.year, df.month, df.day, df.hour, df.minute, df.second, filter)
  end,
  GetPeriodToDateFormat = function(startDate, endDate, endFilter)
    local start = locale.time.GetDateToDateFormat(startDate)
    local endstr
    if endFilter ~= nil then
      endstr = locale.time.GetDateToDateFormat(endDate, endFilter)
    else
      endstr = locale.time.GetDateToDateFormat(endDate)
    end
    return string.format("%s~ %s", start, endstr)
  end,
  GetPeriodToMinutesSecondFormat = function(df, filter)
    local minuteString = X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "minute", tostring(df.minute))
    local secondString = X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "second", tostring(df.second))
    return string.format("%s %s", minuteString, secondString)
  end,
  day = function(day)
    return X2Locale:LocalizeUiText(DATE_TIME_TEXT, "day", day)
  end,
  days = function(days)
    return X2Locale:LocalizeUiText(DATE_TIME_TEXT, "days", days)
  end
}
locale.dominion = {
  siege_period_auction = X2Locale:LocalizeUiText(DOMINION, "siege_period_peace_title"),
  siege_period_declare = X2Locale:LocalizeUiText(DOMINION, "siege_period_declare_title"),
  siege_period_ready_to_siege = X2Locale:LocalizeUiText(DOMINION, "siege_period_warmup_title"),
  siege_period_warmup = X2Locale:LocalizeUiText(DOMINION, "siege_period_warmup_title"),
  siege_period_siege = X2Locale:LocalizeUiText(DOMINION, "siege_period_siege_title"),
  siege_period_peace = X2Locale:LocalizeUiText(DOMINION, "siege_period_peace_title"),
  limit_time_siege_period = X2Locale:LocalizeUiText(DOMINION, "limit_time_siege_period"),
  defense = X2Locale:LocalizeUiText(DOMINION, "defense"),
  left_period = X2Locale:LocalizeUiText(DOMINION, "left_period"),
  siege_warfare = X2Locale:LocalizeUiText(DOMINION, "siege_warfare"),
  reinforce_remain_time = X2Locale:LocalizeUiText(DOMINION, "reinforce_remain_time"),
  spaceVs = X2Locale:LocalizeUiText(DOMINION, "space_vs"),
  unknown = X2Locale:LocalizeUiText(DOMINION, "unknown"),
  mercenary = X2Locale:LocalizeUiText(DOMINION, "mercenary"),
  castleOwner = X2Locale:LocalizeUiText(DOMINION, "castle_owner"),
  requestExpedition = X2Locale:LocalizeUiText(DOMINION, "request_expedition"),
  siege_war_info = X2Locale:LocalizeUiText(DOMINION, "siege_war_info"),
  siege_info = X2Locale:LocalizeUiText(DOMINION, "siege_info"),
  siege_period = X2Locale:LocalizeUiText(DOMINION, "siege_period"),
  notExistSiegeInfo = X2Locale:LocalizeUiText(DOMINION, "not_exist_siege_info"),
  GetReinforcementsArrived = function(name)
    return X2Locale:LocalizeUiText(DOMINION, "reinforcements_arrived", name)
  end,
  GetGuardTowerStatusMsg = function(status)
    return X2Locale:LocalizeUiText(DOMINION, status)
  end,
  GetEngravingStatusMsg = function(status, name, factionName)
    return X2Locale:LocalizeUiText(DOMINION, status, factionName, tostring(name))
  end,
  engravingSucceed = function(name, zoneGroupName)
    if name == nil or name == "" then
      return X2Locale:LocalizeUiText(DOMINION, "siege_alert_engraving_succeeded_none_target")
    else
      return X2Locale:LocalizeUiText(DOMINION, "siege_alert_engraving_succeeded", zoneGroupName, tostring(name))
    end
  end,
  GetDeclareActionStatusMsg = function(action, offenseName, zoneGroupName)
    local key = string.format("action_%s", action)
    return X2Locale:LocalizeUiText(DOMINION, key, offenseName, zoneGroupName)
  end,
  GetMsg = function(msg, zoneGroupName, expeditionName)
    return X2Locale:LocalizeUiText(DOMINION, msg, zoneGroupName, expeditionName)
  end,
  GetSiegeMsg = function(msg, zoneGroupName, remainTime)
    if remainTime == nil then
      return X2Locale:LocalizeUiText(DOMINION, msg, zoneGroupName)
    else
      return X2Locale:LocalizeUiText(DOMINION, msg, zoneGroupName, remainTime)
    end
  end,
  GetSiegeMsgInProgress = function(periodName, zoneGroupName)
    local key = string.format("%s_in_progress", periodName)
    return X2Locale:LocalizeUiText(DOMINION, key, zoneGroupName)
  end,
  GetSiegeIconTooltip = function(zoneGroupName, defenseName, remainTime)
    return string.format([[
%s / %s
%s]], zoneGroupName, defenseName, remainTime)
  end,
  GetSiegeMsgForAlarm = function(periodName, zoneGroupName, onEvent)
    local key
    if onEvent == true then
      key = string.format("%s_start", periodName)
    else
      key = string.format("%s_in_progress_for_alarm", periodName)
    end
    return X2Locale:LocalizeUiText(DOMINION, key, zoneGroupName)
  end,
  GetSiegeWin = function(winner)
    return X2Locale:LocalizeUiText(DOMINION, "siege_win", winner)
  end,
  GetSiegeLose = function(loser)
    return X2Locale:LocalizeUiText(DOMINION, "siege_lose", loser)
  end
}
locale.kindName = {
  human = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "human"),
  devil = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "devil"),
  beast = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "beast"),
  spirit = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "spirit"),
  dragon = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "dragon"),
  undead = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "undead"),
  horse = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "horse"),
  fantastic = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "fantastic"),
  machine = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "machine"),
  ship = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "ship"),
  carriage = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "carriage"),
  siege_weapon = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "siege_weapon"),
  unknown = X2Locale:LocalizeUiText(UNIT_KIND_TEXT, "unknown")
}
locale.gradeName = {
  normal = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "normal"),
  elite = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "elite"),
  boss_a = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "boss_a"),
  boss_b = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "boss_b"),
  boss_c = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "boss_c"),
  weak = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "weak"),
  strong = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "strong"),
  boss_s = X2Locale:LocalizeUiText(UNIT_GRADE_TEXT, "boss_s")
}
locale.character = {}
locale.character.subtitleInfoTooltip = {
  melee_dmg = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_INFO_TOOLTIP_TEXT, "melee_dmg"),
  ranged_dmg = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_INFO_TOOLTIP_TEXT, "ranged_dmg")
}
locale.main_menu_bar = {
  right_menu_text = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "character"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bag"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "quest_list"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "skill"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "map"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "living"),
    X2Locale:LocalizeUiText(TEMP_TEXT, "text5"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "achievement"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "home"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "help"),
    X2Locale:LocalizeUiText(KEY_BINDING_TEXT, "config_menu")
  },
  uiaddon = X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "uiaddon"),
  labor_power_person_person_tip = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "labor_power_person_person_tip"),
  labor_power_personTime_person_tip = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "labor_power_persontime_person_tip"),
  labor_power_trial_person_tip = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "labor_power_trial_person_tip"),
  labor_power_siege_event_tip = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "labor_power_siege_event_tip"),
  labor_power_premium_service_tip = function(a, b)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "labor_power_premium_service_tip", CommaStr(a), CommaStr(b))
  end,
  bmmileage_pcbang_tip = function(a, b, c)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_pcbang_tip", tostring(a), tostring(b), tostring(c))
  end,
  bmmileage_archelife_tip = function(a, b, c)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_archelife_tip", tostring(a), tostring(b), tostring(c))
  end,
  bmmileage_free_target_tip = function(a, b, c, d)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_free_target_tip", tostring(a), tostring(b), tostring(c), tostring(d))
  end,
  bmmileage_free_nontarget_tip = function(a, b, c, d)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_free_nontarget_tip", tostring(a), tostring(b), tostring(c), tostring(d))
  end,
  bmmileage_free_nontarget_end_tip = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_free_nontarget_end_tip"),
  bmmileage_tip = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_tip"),
  home_subMenu = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "message"),
    X2Locale:LocalizeUiText(COMMUNITY_TEXT, "play_journal")
  },
  living_subMenu = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "craft_dic"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "farm"),
    X2Locale:LocalizeUiText(RANKING_TEXT, "ranking"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "specialty_info_title")
  },
  community_subMenu = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "expedition"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "raid"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "community"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "nation")
  },
  help_subMenu = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "archewiki"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "one_to_one_Inquire")
  },
  cofing_subMenu = {
    X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "second_password"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "option"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "select_character"),
    X2Locale:LocalizeUiText(OPTION_TEXT, "menu_exit")
  }
}
locale.infobar = {
  leftMenu = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "character"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "skill"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "quest_list"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bag"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "craft_dic"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "map"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "farm")
  },
  rightMenu = {
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "expedition"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "raid"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "community"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "doc"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "message"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "archewiki"),
    X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "system")
  },
  inquireNotify = X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "inquire_notify"),
  disableRaid = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "raid_menu_tip")
}
function locale.attribute(attribute)
  if IsAttackSpeedAttributes(attribute) then
    return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "attack_speed")
  elseif attribute == "exp" then
    return X2Locale:LocalizeUiText(COMMON_TEXT, "exp")
  end
  return X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, attribute) or ""
end
locale.bmmileage = {
  bmmileage_archelife = X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "bmmileage_archelife"),
  bmmileage_free = X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "bmmileage_free"),
  bmmileage_pcbang = X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "bmmileage_pcbang"),
  bmmileage = X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "bmmileage")
}
locale.list = {}
locale.list.noInfomation = X2Locale:LocalizeUiText(COMMON_TEXT, "no_infomation")
locale.ratingNotice = X2Locale:LocalizeUiText(COMMON_TEXT, "rating_notice")
function locale.playTimeNotice(playTime)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "play_time_notice", tostring(playTime))
end
locale.character_mainWindowTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "character_main_widget_title")
locale.raceText = {
  X2Locale:LocalizeUiText(RACE_TEXT, "nuian"),
  "\237\142\152\236\150\180\235\166\172",
  X2Locale:LocalizeUiText(RACE_TEXT, "dwarf"),
  X2Locale:LocalizeUiText(RACE_TEXT, "elf"),
  X2Locale:LocalizeUiText(RACE_TEXT, "hariharan"),
  X2Locale:LocalizeUiText(RACE_TEXT, "ferre"),
  "\235\166\172\237\132\180\235\147\156",
  X2Locale:LocalizeUiText(RACE_TEXT, "warborn")
}
locale.gender = {}
locale.gender.male = X2Locale:LocalizeUiText(GENDER_TEXT, "male")
locale.gender.female = X2Locale:LocalizeUiText(GENDER_TEXT, "female")
locale.common = {}
locale.common.warning = X2Locale:LocalizeUiText(COMMON_TEXT, "warning")
locale.common.ok = X2Locale:LocalizeUiText(COMMON_TEXT, "ok")
locale.common.decision = X2Locale:LocalizeUiText(COMMON_TEXT, "decision")
locale.common.cancel = X2Locale:LocalizeUiText(COMMON_TEXT, "cancel")
locale.common.change = X2Locale:LocalizeUiText(COMMON_TEXT, "change")
locale.common.crime = X2Locale:LocalizeUiText(COMMON_TEXT, "crime")
locale.common.dead = X2Locale:LocalizeUiText(COMMON_TEXT, "dead")
locale.common.level = X2Locale:LocalizeUiText(COMMON_TEXT, "level")
locale.common.tender = X2Locale:LocalizeUiText(COMMON_TEXT, "tender")
locale.common.buyNow = X2Locale:LocalizeUiText(COMMON_TEXT, "but_now")
locale.common.no_information_too_far = X2Locale:LocalizeUiText(COMMON_TEXT, "no_information_too_far")
locale.common.split_item = X2Locale:LocalizeUiText(COMMON_TEXT, "split_item")
function locale.common.GetAmount(ammount)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "amount", tostring(ammount))
end
function locale.common.GetPeopleCount(count)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "people_count", tostring(count))
end
locale.common.changeName = X2Locale:LocalizeUiText(COMMON_TEXT, "common_change_name")
function locale.common.accumulate(area, kind, point)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "x_sum_y_points", area, kind, tostring(point))
end
locale.common.input_name_guide = X2Locale:LocalizeUiText(COMMON_TEXT, "input_name_guide")
locale.common.reload = X2Locale:LocalizeUiText(COMMON_TEXT, "reload")
locale.common.option = X2Locale:LocalizeUiText(COMMON_TEXT, "option")
locale.common.period = X2Locale:LocalizeUiText(COMMON_TEXT, "period")
locale.common.name = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "name")
function locale.common.from_to(from, to)
  return X2Locale:LocalizeUiText(COMMON_TEXT, "from_to", tostring(from), tostring(to))
end
locale.mileage = {
  gived_max_warning = X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_free_nontarget_end_tip"),
  none_give_term = function(a, b)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_none_give_term", tostring(a), tostring(b))
  end,
  none_give_term_give_max = function(a, b, c, d)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_none_give_term_give_max", tostring(a), tostring(b), tostring(c), tostring(d))
  end,
  have_give_term_give_max = function(a, b, c, d)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_have_give_term_give_max", tostring(a), tostring(b), tostring(c), tostring(d))
  end,
  gived_max = function(a, b, c, d)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_gived_max", tostring(a), tostring(b), tostring(c), tostring(d))
  end,
  none_give_max = function(a, b, c)
    return X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bmmileage_none_give_max", tostring(a), tostring(b), tostring(c))
  end
}
function locale.common.abilityNameWithStr(abilName)
  if abilName == nil or abilName == "invalid ability" then
    return nil
  end
  return X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, abilName)
end
function locale.common.abilityNameWithId(abilId)
  return locale.common.abilityNameWithStr(X2Ability:GetAbilityStr(abilId))
end
locale.common.equipSlotType = {}
locale.common.equipSlotType.offhand = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "offhand")
locale.common.equipSlotType["1handed"] = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "1handed")
locale.common.equipSlotType["2handed"] = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "2handed")
locale.common.equipSlotType.instrument = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "instrument")
locale.common.equipSlotType.ranged = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "ranged")
locale.common.equipSlotType.mainhand = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "mainhand")
locale.common.equipSlotType.head = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "head")
locale.common.equipSlotType.neck = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "neck")
locale.common.equipSlotType.chest = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "chest")
locale.common.equipSlotType.waist = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "waist")
locale.common.equipSlotType.legs = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "legs")
locale.common.equipSlotType.hands = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "hands")
locale.common.equipSlotType.feet = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "feet")
locale.common.equipSlotType.arms = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "arms")
locale.common.equipSlotType.back = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "back")
locale.common.equipSlotType.ear = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "ear")
locale.common.equipSlotType.finger = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "finger")
locale.common.equipSlotType.underweartop = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "underweartop")
locale.common.equipSlotType.underwearbottom = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "underwearbottom")
locale.common.equipSlotType.shield = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "shield")
locale.common.equipSlotType.backpack = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "backpack")
locale.common.equipSlotType.cosplay = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "cosplay")
locale.common.equipSlotType.underpants = X2Locale:LocalizeUiText(EQUIP_SLOT_TYPE_TEXT, "underpants")
locale.common.equipSlotType.allEquip = X2Locale:LocalizeUiText(COMMON_TEXT, "allEquip")
locale.common.heirSkills = {
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_fire"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_life"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_earthquake"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_rock"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_wave"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_fog"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_squall"),
  X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_lightning")
}
locale.characterCreate = {
  confirmCreateTitle = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "confirmCreateTitle"),
  confirmEditTitle = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "confirmEditTitle"),
  resetItem = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "resetItem"),
  selectFreeAbility = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectFreeAbility"),
  selectRecommendJob = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectRecommendJob"),
  selectRandomAbility = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectRandomAbility"),
  selectFreeAbilityDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectFreeAbilityDesc"),
  selectRecommendJobDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectRecommendJobDesc"),
  selectRandomAbilityDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectRandomAbilityDesc"),
  crowded = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "crowded"),
  normal = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "normal"),
  disable = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "disable"),
  control = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "control"),
  toSelectCharacter = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toSelectCharacter"),
  toSelectRaceGender = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toSelectRaceGender"),
  selectRaceGender = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectRaceGender"),
  toCustomizeLook = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toCustomizeLook"),
  toCustomizeLookPrev = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toCustomizeLookPrev"),
  customizeLook = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customizeLook"),
  toSelectAbility = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toSelectAbility"),
  selectAbility = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectAbility"),
  toCompleteCreation = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toCompleteCreation"),
  createCharacterTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "createCharacterTip"),
  createCharacterdDisabledTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "createCharacterdDisabledTip"),
  toSelectCharacterTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toSelectCharacterTip"),
  selectRaceGenderTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectRaceGenderTip"),
  disableSelectCharacter = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "disableSelectCharacter"),
  toCustomizeLookTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toCustomizeLookTip"),
  toSelectAbilityTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toSelectAbilityTip"),
  toCompleteCreationTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toCompleteCreationTip"),
  toCompleteCreationDisableTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "toCompleteCreationDisableTip"),
  warriorClassDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "warriorClassDesc"),
  priestClassDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "priestClassDesc"),
  wizardClassDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "wizardClassDesc"),
  rangerClassDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "rangerClassDesc"),
  characterName = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "characterName"),
  createConfirm = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "createConfirm"),
  editConfirm = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "editConfirm"),
  makeName = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "makeName"),
  selectThreeAbilities = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "selectThreeAbilities"),
  descTemporarilySave = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "descTemporarilySave"),
  mouseGuideDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "mouseGuideDesc"),
  physical_name = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "physical_name"),
  magical_name = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "magical_name"),
  protect_name = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "protect_name"),
  debuff_name = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "debuff_name"),
  enchant_name = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "enchant_name"),
  physicalAttack = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "physicalAttack"),
  magicalAttack = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "magicalAttack"),
  enchant = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "enchant"),
  debuff = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "debuff"),
  protect = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "protect"),
  fix_tip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "fix_tip"),
  getTendencyInfo = function(str)
    return X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, str)
  end,
  abilityStageDesc = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "abilityStageDesc"),
  faceTextList1 = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "faceTextList1"),
  faceTextList2 = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "faceTextList2"),
  faceTextList3 = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "faceTextList3"),
  customTypeface = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypeface"),
  customTypeskin = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypeskin"),
  customTypehair = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypehair"),
  customTypehairColor = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypehairColor"),
  customTypetattoo = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypetattoo"),
  customTypemakeup = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypemakeup"),
  customTypescar = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypescar"),
  customTypescale = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypescale"),
  customTypepos = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "customTypepos"),
  raceTitleDesc = {
    X2Locale:LocalizeUiText(RACE_TITLE_DESCRIPTION_TEXT, "nuian"),
    "",
    X2Locale:LocalizeUiText(RACE_TITLE_DESCRIPTION_TEXT, "nuian"),
    X2Locale:LocalizeUiText(RACE_TITLE_DESCRIPTION_TEXT, "elf"),
    X2Locale:LocalizeUiText(RACE_TITLE_DESCRIPTION_TEXT, "hariharan"),
    X2Locale:LocalizeUiText(RACE_TITLE_DESCRIPTION_TEXT, "ferre"),
    "",
    X2Locale:LocalizeUiText(RACE_TITLE_DESCRIPTION_TEXT, "nuian")
  },
  raceDetailDesc = {
    X2Locale:LocalizeUiText(RACE_DETAIL_DESCRIPTION_TEXT, "nuian"),
    "",
    X2Locale:LocalizeUiText(RACE_DETAIL_DESCRIPTION_TEXT, "nuian"),
    X2Locale:LocalizeUiText(RACE_DETAIL_DESCRIPTION_TEXT, "elf"),
    X2Locale:LocalizeUiText(RACE_DETAIL_DESCRIPTION_TEXT, "hariharan"),
    X2Locale:LocalizeUiText(RACE_DETAIL_DESCRIPTION_TEXT, "ferre"),
    "",
    X2Locale:LocalizeUiText(RACE_DETAIL_DESCRIPTION_TEXT, "nuian")
  },
  abilityDescWithStr = function(abilName)
    if abilName == nil or abilName == "invalid ability" then
      return nil
    end
    return X2Locale:LocalizeUiText(ABILITY_CATEGORY_DESCRIPTION_TEXT, abilName)
  end,
  abilityDescWithId = function(abilId)
    return locale.characterCreate.abilityDescWithStr(X2Ability:GetAbilityStr(abilId))
  end,
  biginner = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "biginner"),
  preference = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preference"),
  registerDay = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "registerDay"),
  customPartList = {
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_all"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_eye"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_nose"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_mouth"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_shape"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_detail")
  },
  customPresetType = {
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_face"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_eye"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_nose"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_mouth"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_shape"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "preset_detail")
  },
  adornStyleList = {
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "style_head"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "horn"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "style_eye"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "pupil"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "style_deco"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "style_skin"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "style_tattoo"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "body_shape")
  },
  unlikePreset = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "unlikePreset"),
  sortItem = {
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "sortByPreference"),
    X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "sortByRegisterday")
  },
  appearanceMix = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "appearanceMix"),
  temporarilySave = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "temporarilySave"),
  mix = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "mixButton"),
  ok = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "okButton"),
  titleText = function(a)
    return X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "titleText", tostring(a))
  end,
  detailTitleText = function(a)
    return X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "detailTitleText", tostring(a))
  end,
  choiceMixPart = function(a)
    return X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "choiceMixPart", tostring(a))
  end,
  sliderTitle = {
    heavy = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "slider_title_heavy"),
    strength = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "slider_title_heavy")
  },
  fix = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "fixbutton"),
  smileTip = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "smile_tip"),
  emptyData = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "emptyData"),
  samePreset = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "samePreset"),
  race_congestion_warning = X2Locale:LocalizeUiText(CHARACTER_CREATE_TEXT, "high_race_congestion_warning")
}
locale.beautyshop = {
  exitTitle = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "exitTitle"),
  exitBody = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "exitBody"),
  resetTitle = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "resetTitle"),
  resetBody = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "resetBody"),
  noChange = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "noChange"),
  detailsTitle = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "detailsTitle"),
  cosmeticSwitch = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "cosmeticSwitch"),
  plasticSwitch = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "plasticSwitch"),
  continue = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "continue"),
  confirm = X2Locale:LocalizeUiText(BEAUTYSHOP_TEXT, "confirm")
}
locale.learning = {
  title = X2Locale:LocalizeUiText(LEARNING_TEXT, "title"),
  titlepoint = X2Locale:LocalizeUiText(LEARNING_TEXT, "title_point"),
  myMoney = X2Locale:LocalizeUiText(LEARNING_TEXT, "my_money"),
  GetCost = function(a, b)
    return X2Locale:LocalizeUiText(LEARNING_TEXT, "cost", a, tostring(b))
  end,
  point = X2Locale:LocalizeUiText(LEARNING_TEXT, "point"),
  GetNewSkillPoint = function(a)
    return X2Locale:LocalizeUiText(LEARNING_TEXT, "new_skill_point", tostring(a))
  end,
  button = {
    learning = X2Locale:LocalizeUiText(LEARNING_TEXT, "learning_btn"),
    upgrad = X2Locale:LocalizeUiText(LEARNING_TEXT, "upgrad_btn")
  },
  heirPoint = X2Locale:LocalizeUiText(LEARNING_TEXT, "heir_point")
}
locale.party = {}
locale.party.leaved = nil
locale.party.leaderPopupLeaders = {
  X2Locale:LocalizeUiText(PARTY_TEXT, "leader_popup_leader_drop"),
  X2Locale:LocalizeUiText(PARTY_TEXT, "leader_popup_leader_loot_rule")
}
locale.party.leaderPopupMembers = {
  X2Locale:LocalizeUiText(PARTY_TEXT, "leader_popup_member_kick_out"),
  X2Locale:LocalizeUiText(PARTY_TEXT, "leader_popup_member_delegate")
}
locale.party.memberPopups = {
  X2Locale:LocalizeUiText(PARTY_TEXT, "member_popup_drop")
}
locale.party.lootRule = {}
locale.party.lootRule.popups = {
  X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_popup_free"),
  X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_popup_sequence"),
  X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_popup_in_charge")
}
locale.party.lootRule.dropdownBase = X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_select_in_charge")
locale.menuTip = {
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "menu"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "system"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "message"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "play_journal"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "map"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "craft_dic"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "bag"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "quest_list"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "diary"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "skill"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "character"),
  X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "expedition")
}
locale.lootMethodFunc = {}
locale.lootMethodFunc.msgFunc = {}
function locale.lootMethodFunc.msgFunc.free()
  return X2Locale:LocalizeUiText(LOOT_METHOD_TEXT, "free")
end
function locale.lootMethodFunc.msgFunc.sequence()
  return X2Locale:LocalizeUiText(LOOT_METHOD_TEXT, "sequence")
end
function locale.lootMethodFunc.msgFunc.inCharge(a)
  return X2Locale:LocalizeUiText(LOOT_METHOD_TEXT, "in_charge", a)
end
locale.lootPopupText = {
  diceDistribute = X2Locale:LocalizeUiText(LOOT_TEXT, "popup_dice_distribute"),
  bindOnPickup = X2Locale:LocalizeUiText(LOOT_TEXT, "popup_bop"),
  notUseDiceRule = X2Locale:LocalizeUiText(LOOT_TEXT, "popup_not_use_dice_rule"),
  notUseBindOnPickup = X2Locale:LocalizeUiText(LOOT_TEXT, "popup_not_use_bop"),
  useBindOnPickup_Dice = X2Locale:LocalizeUiText(LOOT_TEXT, "popup_use_bop_dice"),
  GetMoreThenGrade = function(a)
    return X2Locale:LocalizeUiText(LOOT_TEXT, "more_then", a)
  end,
  GetDoubleTitle = function(a, b)
    return X2Locale:LocalizeUiText(LOOT_TEXT, "popup_double_title", a, b)
  end
}
locale.diceBidRule = {}
locale.diceBidRule.popups = {
  X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_default"),
  X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_auto_accept"),
  X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_auto_giveup")
}
locale.diceBidRule.popupTitle = X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule")
locale.diceBidRule.checkBoxTooltip = X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_auto_checkBoxTooltip")
locale.appellation = {
  title = X2Locale:LocalizeUiText(COMMON_TEXT, "appellation_title"),
  unable = X2Locale:LocalizeUiText(COMMON_TEXT, "appellation_unable"),
  have_not_appellation = X2Locale:LocalizeUiText(COMMON_TEXT, "appellation_have_not_appellation")
}
locale.chatChannel = {
  party = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "party"),
  say = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "say"),
  raid = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "raid"),
  yell = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "yell"),
  whisper = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "whisper"),
  expedition = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "expedition"),
  trial = X2Locale:LocalizeUiText(CHAT_LIST_TEXT, "trial"),
  race = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_alliance"),
  faction = X2Locale:LocalizeUiText(NATION_TEXT, "nation"),
  chat_zone = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_zone"),
  chat_trade = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_trade"),
  chat_find_party = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_find_party"),
  chat_notice = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_notice"),
  GetParty = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_party", a)
  end,
  GetRaid = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raid", a)
  end,
  GetRaidCommand = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raidCommand", a)
  end,
  GetTrialCommand = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_trialCommand", a)
  end,
  GetFaction = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_faction", a)
  end,
  GetEnterChannel = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "enter_channel", IStr(a), b)
  end,
  GetLeaveChannel = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "leave_channel", IStr(a), b)
  end,
  GetWhispered = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_whispered", a)
  end,
  GetWhisper = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_whisper", a)
  end,
  GetExpedition = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_expedition", a)
  end,
  GetFamily = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_family", a)
  end,
  GetTrial = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_trial", a)
  end,
  GetRace = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_race", a)
  end,
  GetPartyOwner = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_party_owner", a)
  end,
  GetRaidOwner = function(a)
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raid_owner", a)
  end,
  parse_chat_whisper_1 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_whisper_1"),
  parse_chat_whisper_2 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_whisper_2"),
  parse_chat_party_1 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_party_1"),
  parse_chat_party_2 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_party_2"),
  parse_chat_say_1 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_say_1"),
  parse_chat_say_2 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_say_2"),
  parse_chat_raid_1 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_raid_1"),
  parse_chat_raid_2 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_raid_2"),
  parse_chat_yell_1 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_yell_1"),
  parse_chat_yell_2 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_yell_2"),
  parse_chat_yell_3 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_yell_3"),
  parse_chat_yell_4 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_yell_4"),
  parse_chat_guild_1 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_guild_1"),
  parse_chat_guild_2 = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "parse_chat_guild_2")
}
locale.chatSystem = {
  run = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "run"),
  walk = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "walk"),
  msg_mail_sent = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_mail_sent"),
  msg_mail_recieved = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_mail_recieved"),
  msg_craft_success = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_craft_success"),
  msg_craft_fail = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_craft_fail"),
  msg_learn_craft = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_learn_craft"),
  msg_following_begin = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_following_begin"),
  msg_following_end = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_following_end"),
  msg_summon_change_name = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_summon_change_name"),
  GetItemExpired = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_expired", a)
  end,
  GetRecieved = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_recieved", a)
  end,
  GetRecieved_a = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_recieved_a", a, CommaStr(b))
  end,
  GetUse = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use", a)
  end,
  GetUse_a = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use_a", a, CommaStr(b))
  end,
  GetRemoved = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_removed", a)
  end,
  GetRemoved_a = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_removed_a", a, CommaStr(b))
  end,
  GetConversion = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_conversion", a)
  end,
  GetFactionIncrease = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_faction_increase", a, b)
  end,
  GetFactionDecrease = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_faction_decrease", a, b)
  end,
  GetLearnSkill = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_learn_skill", a)
  end,
  GetMmateLearnSkill = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_mate_learn_skill", a, b)
  end,
  GetChangeSkill = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_change_skill", a, b, IStr(c))
  end,
  GetSwapAbility = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_swap_ability", a, b)
  end,
  GetResetSkills = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_reset_skills", a)
  end,
  GetGainPremiumLaberPower = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_gain_premium_labor_power", CommaStr(a), CommaStr(b))
  end,
  GetGainLaberPower = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_gain_laber_power", CommaStr(a), CommaStr(b))
  end,
  GetUseLaberPower = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use_laber_power", CommaStr(a), CommaStr(b))
  end,
  GetExpertPoint = function(a, b, c)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "actability_value_changed", a, CommaStr(b), CommaStr(c))
  end,
  GetQuest = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_quest", a)
  end,
  GetItemAcquisitionSingle = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_acquisition_single", a, b)
  end,
  GetItemAcquisitionMultiple = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_acquisition_multiple", a, b, CommaStr(c))
  end,
  GetLootDiceRoll = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_dice_roll", a, b, IStr(c))
  end,
  GetLootDiceGiveUp = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_dice_give_up", a, b)
  end,
  GetLootingRuleMethodChanged = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_rule_changed", a)
  end,
  GetLootingRuleMasterChanged = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_master_changed", a)
  end,
  GetLootingRuleGradeChanged = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_grade_changed", a)
  end,
  msgLootingRuleGradeReleased = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_grade_released"),
  GetTradeRecieved = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_recieved", a, b)
  end,
  GetTradeRecieved_a = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_recieved_a", a, b, CommaStr(c))
  end,
  GetTradeRemoved = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_removed", a, b)
  end,
  GetTradeRemoved_a = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_removed_a", a, b, CommaStr(c))
  end,
  GetItemBuffRecharged = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_recharged", a)
  end,
  GetQuestEventMonster = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "quest_event_monster", a, IStr(b), IStr(c))
  end,
  GetQuestEventItem = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "quest_event_item", a, IStr(b), IStr(c))
  end,
  GetUsingItem = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "using_item", a, IStr(b), IStr(c))
  end,
  GetQuestEventTalk = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "quest_event_talk", a)
  end,
  GetEnterArea = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "enter_area", a)
  end,
  GetLeaveArea = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "leave_area", a)
  end,
  GetIncreaseDishonorPoint = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "increase_dishonor_point", CommaStr(a), CommaStr(b))
  end,
  GetDecreaseDishonorPoint = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "decrease_dishonor_point", CommaStr(a), CommaStr(b))
  end,
  get_quest_start_item = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "get_quest_start_item"),
  get_use_item_in_active_quest = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "get_use_item_in_active_quest"),
  get_quest_item = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "get_quest_item"),
  get_item = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "get_item"),
  GetFailedCraft = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "failed_craft_message", a)
  end,
  GetFailedCraftForAlert = function(a)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "failed_craft_alert", a)
  end,
  GetGainBmMileage = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_gain_bmmileage", CommaStr(a), CommaStr(b))
  end,
  GetUseBmMileage = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use_bmmileage", CommaStr(a), CommaStr(b))
  end,
  SaveScreenShot = function(path)
    return X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "save_screenshot", path)
  end,
  ShowSextantPos = function(long, deg_long, min_long, sec_long, lat, deg_lat, min_lat, sec_lat)
    return string.format("%s%s %s\194\176|r%s' %s\", %s%s %s\194\176|r%s' %s\"", F_COLOR.GetColor("original_dark_orange", true), tostring(long), tostring(deg_long), tostring(min_long), tostring(sec_long), F_COLOR.GetColor("original_dark_orange", true), tostring(lat), tostring(deg_lat), tostring(min_lat), tostring(sec_lat))
  end
}
locale.chatCombatLog = {
  combat = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "combat"),
  config = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "config"),
  check_all = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "check_all"),
  hit = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "hit"),
  critical = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "critical"),
  miss = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "miss"),
  dodge = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "dodge"),
  block = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "block"),
  parry = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "parry"),
  immune = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "immune"),
  resist = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "resist"),
  piercing = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "piercing"),
  slashing = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "slashing"),
  blunting = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "blunting"),
  drowning = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "drowning"),
  falling = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "falling"),
  collision = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision"),
  collision_front = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_front"),
  collision_side = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_side"),
  collision_rear = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_rear"),
  collision_bottom = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "collision_bottom"),
  health = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "health"),
  mana = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "mana"),
  unknown = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "unknown"),
  GetMeleeLogFormat = function(a, b, c, d, e)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "melee_log_format", a, b, c, d, e)
  end,
  GetReduced = function(a)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "reduced", IStr(a))
  end,
  GetWeaponUsageDamage = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "weaponUsageDamage", a, IStr(b))
  end,
  GetMeleeMissed = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "melee_missed", a, b)
  end,
  GetSpellLogFormat = function(a, b, c, d, e, f)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_log_format", a, b, c, d, e, f)
  end,
  GetSpellMissed = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_missed", a, b, c)
  end,
  GetSpellHealed = function(a, b, c, d)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_healed", a, b, c, d)
  end,
  GetSpellEnergize = function(a, b, c, d)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_energize", a, b, c, d)
  end,
  GetSpellCastStart = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_cast_start", a, b)
  end,
  GetSpellCastSuccess = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_cast_success", a, b)
  end,
  GetSpellCastFailed = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_cast_failed", a, b)
  end,
  GetSpellAuraAppliedBuff = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_applied_buff", a, b)
  end,
  GetSpellAuraAppliedDebuff = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_applied_debuff", a, b)
  end,
  GetSpellAuraRemovedBuff = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_removed_buff", a, b)
  end,
  GetSpellAuraRemovedDebuff = function(a, b)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_removed_debuff", a, b)
  end,
  GetEnvironmentalDamage = function(a, b, c)
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "environmental_damage", a, b, c)
  end
}
locale.chat = {
  FORCE_ATTACK_ON = X2Locale:LocalizeUiText(CHAT_FORCE_ATTACK_TEXT, "force_attack_on"),
  FORCE_ATTACK_OFF = X2Locale:LocalizeUiText(CHAT_FORCE_ATTACK_TEXT, "force_attack_off"),
  create = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "create"),
  change = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "change"),
  createTab = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "create_tab"),
  tabnNameChange = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "tab_name_change"),
  eraseTabContent = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "erase_tab_content"),
  removeTab = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "remove_tab"),
  lockTab = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "lock_tab"),
  unlockTab = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "unlock_tab"),
  inputTabName = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "input_tab_name"),
  guideText = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "guide_text")
}
locale.chatFiltering = {
  reset = X2Locale:LocalizeUiText(CHAT_FILTERING, "reset"),
  chatReset = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_reset"),
  title = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_title"),
  menuName = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_conversation"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_notice"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_config")
  },
  normal_group1 = {
    [CMF_SAY] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_common"),
    [CMF_ZONE] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_shout"),
    [CMF_WHISPER] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_whisper"),
    [CMF_TRADE] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_trade"),
    [CMF_PARTY] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_party"),
    [CMF_FIND_PARTY] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_search_party"),
    [CMF_RAID] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_raid"),
    [CMF_NOTICE] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_notice"),
    [CMF_EXPEDITION] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_expedition"),
    [CMF_SYSTEM] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_system"),
    [CMF_FAMILY] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_family"),
    [CMF_TRIAL] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_trial"),
    [CMF_FACTION] = X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TEXT, "faction"),
    [CMF_RACE] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_alliance"),
    [CMF_SQUAD] = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_squad")
  },
  normal_group2 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group2_quest")
  },
  alarm_group1 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group1_my_info"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group1_skill_info")
  },
  alarm_group2 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group2_relationship_info"),
    subMenu = {
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group2_submenu1"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group2_submenu2"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group2_submenu3")
    }
  },
  alarm_group3 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group3_item_info"),
    subMenu = {
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group3_submenu1"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group3_submenu2")
    }
  },
  alarm_group4 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group4_get_consume_info"),
    subMenu = {
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group4_submenu1"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group4_submenu2"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group4_submenu3"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group4_submenu4")
    }
  },
  alarm_group5 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group5_team_info"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group5_camp_info"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group5_trade_info"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group5_expression_info")
  },
  alarm_group6 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group6_etc"),
    subMenu = {
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group6_submenu1"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group6_submenu3"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_alarm_group6_submenu4")
    }
  },
  combat_group1 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group1_submenu1")
  },
  combat_group2 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group2_submenu2")
  },
  combat_group3 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group3_default_attack"),
    subMenu = {
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group3_submenu1"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group3_submenu2")
    }
  },
  combat_group4 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group4_skill"),
    subMenu = {
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group4_submenu1"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group4_submenu2"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group4_submenu3"),
      X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group4_submenu4")
    }
  },
  combat_group5 = {
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group5_buff"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group5_around_damage"),
    X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_combat_group5_death")
  },
  enemy_combat = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_enemy_combat"),
  friend_combat = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_friend_combat"),
  setFontSize = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_set_font_size"),
  setBGAlpha = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_set_bg_alpha"),
  overAlpha = X2Locale:LocalizeUiText(CHAT_FILTERING, "overAlpha"),
  percent = {"0", "100"},
  setBGColor = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_set_bg_color"),
  setAlphaMode = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_set_alpah_mode"),
  mouseOverActive = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_mouse_over_active"),
  alwaysActive = X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_always_active")
}
locale.graveyard = {
  title = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "title"),
  dead_msg = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "dead"),
  revive = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "revive"),
  revive_battle_field = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "revive_battle_field"),
  revive_siege = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "revive_siege"),
  revive_indun = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "revive_indun"),
  graceRevive = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "grace_revive"),
  dead_wnd_msg = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "dead_wnd_msg"),
  dead_battle_field_wnd_msg = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "dead_battle_field_wnd_msg"),
  dead_siege_wnd_msg = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "dead_siege_wnd_msg"),
  dead_indun_wnd_msg = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "dead_indun_wnd_msg"),
  GetResurrectionWaitingMsg = function(a)
    return X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "resurrection_waiting_msg", a)
  end,
  GetLostExp = function(a)
    return X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "lost_exp", tostring(a))
  end,
  GetDurabilityLossRatio = function(a)
    return X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "durability_loss_ratio", tostring(a))
  end,
  notDecreaseExp = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "not_decrease_exp"),
  GetDeathMessage = function(name)
    if name == X2Unit:UnitName("player") then
      return locale.graveyard.dead_msg
    end
    return X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "death_message", name)
  end,
  expRecoverGuide = X2Locale:LocalizeUiText(GRAVE_YARD_TEXT, "exp_recover_guide")
}
locale.levelChanged = {
  GetLevelText = function(a)
    return X2Locale:LocalizeUiText(LEVEL_CHANGED_TEXT, "level", IStr(a))
  end,
  point = X2Locale:LocalizeUiText(LEVEL_CHANGED_TEXT, "point")
}
locale.ucc = {
  title = X2Locale:LocalizeUiText(UCC_TEXT, "title"),
  patternTitle = X2Locale:LocalizeUiText(UCC_TEXT, "pattern_title"),
  sampleTitle = X2Locale:LocalizeUiText(UCC_TEXT, "sample_title"),
  pattern = X2Locale:LocalizeUiText(UCC_TEXT, "pattern"),
  sample = X2Locale:LocalizeUiText(UCC_TEXT, "sample"),
  colorPick = X2Locale:LocalizeUiText(UCC_TEXT, "color_pick"),
  helperTip = X2Locale:LocalizeUiText(UCC_TEXT, "helper_tip"),
  size = X2Locale:LocalizeUiText(UCC_TEXT, "size"),
  fileName = X2Locale:LocalizeUiText(UCC_TEXT, "filename"),
  path = X2Locale:LocalizeUiText(UCC_TEXT, "path"),
  imprintSuccessed = X2Locale:LocalizeUiText(UCC_TEXT, "imprint_successed"),
  needSelect = X2Locale:LocalizeUiText(UCC_TEXT, "need_select"),
  dont_use = function(a)
    return X2Locale:LocalizeUiText(UCC_TEXT, "dont_use", a)
  end,
  create_subscription_warning = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "confirm_ucc_upload_body")
}
locale.actLevel = {
  level = {
    0,
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80,
    90,
    99,
    100
  },
  title = {
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s",
    "%s"
  }
}
locale.sticked = {
  bagTitle = X2Locale:LocalizeUiText(STICKED_TEXT, "bigTitle")
}
locale.inven = {
  bagTitle = X2Locale:LocalizeUiText(INVEN_TEXT, "bagTitle"),
  itemGroupTabMarkerTitle = X2Locale:LocalizeUiText(INVEN_TEXT, "itemGroupTabMarkerTitle"),
  itemGroupTabEditTitle = X2Locale:LocalizeUiText(INVEN_TEXT, "itemGroupTabEditTitle"),
  itemGroupSelectorTitle = X2Locale:LocalizeUiText(INVEN_TEXT, "itemGroupSelectorTitle"),
  iconSelectorTitle = X2Locale:LocalizeUiText(INVEN_TEXT, "iconSelectorTitle"),
  groupDescInputTitle = X2Locale:LocalizeUiText(INVEN_TEXT, "groupDescInputTitle"),
  deleteTabDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "deleteTabDesc"),
  addTabDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "addTabDesc"),
  disableAddTabDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "disableAddTabDesc"),
  allTab = X2Locale:LocalizeUiText(INVEN_TEXT, "allTab"),
  expandTooltipMsg = X2Locale:LocalizeUiText(INVEN_TEXT, "expandTooltipMsg"),
  expandBag = X2Locale:LocalizeUiText(INVEN_TEXT, "expandSlot"),
  expandCoffer = X2Locale:LocalizeUiText(INVEN_TEXT, "expandCoffer"),
  addGroup = X2Locale:LocalizeUiText(INVEN_TEXT, "addGroup"),
  editGroup = X2Locale:LocalizeUiText(INVEN_TEXT, "editGroup"),
  removeGroup = X2Locale:LocalizeUiText(INVEN_TEXT, "removeGroup"),
  sort = X2Locale:LocalizeUiText(INVEN_TEXT, "sort"),
  paying_drawing = X2Locale:LocalizeUiText(INVEN_TEXT, "paying_drawing"),
  inputAmount = X2Locale:LocalizeUiText(INVEN_TEXT, "inputAmount"),
  deposit = X2Locale:LocalizeUiText(INVEN_TEXT, "deposit"),
  withdraw = X2Locale:LocalizeUiText(INVEN_TEXT, "withdraw"),
  createWarning = X2Locale:LocalizeUiText(INVEN_TEXT, "createWarning"),
  unlockItem = X2Locale:LocalizeUiText(INVEN_TEXT, "unlock_item"),
  lockEquip = X2Locale:LocalizeUiText(INVEN_TEXT, "lock_equip"),
  unlockEquip = X2Locale:LocalizeUiText(INVEN_TEXT, "unlock_equip"),
  lockItemDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "lock_item_desc"),
  lockEquipDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "lock_equip_desc"),
  unlockItemDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "unlock_item_desc"),
  unlockEquipDesc = X2Locale:LocalizeUiText(INVEN_TEXT, "unlock_equip_desc")
}
locale.clock = {
  am = X2Locale:LocalizeUiText(MAP_TEXT, "am"),
  pm = X2Locale:LocalizeUiText(MAP_TEXT, "pm"),
  currentTime = X2Locale:LocalizeUiText(MAP_TEXT, "clock"),
  protectRegion = X2Locale:LocalizeUiText(MAP_TEXT, "protect_region"),
  neutralityRegion = X2Locale:LocalizeUiText(MAP_TEXT, "neutrality_region"),
  unknown_region = X2Locale:LocalizeUiText(MAP_TEXT, "unknown_region"),
  roadmapSize = X2Locale:LocalizeUiText(MAP_TEXT, "roadmap_size"),
  roadmapOption = X2Locale:LocalizeUiText(MAP_TEXT, "roadmap_option"),
  visibleRodemap = X2Locale:LocalizeUiText(MAP_TEXT, "visible_rodemap"),
  visibleRoadmapIcon = X2Locale:LocalizeUiText(MAP_TEXT, "visible_roadmap_icon"),
  roadmapSize_tooltip = X2Locale:LocalizeUiText(MAP_TEXT, "roadmap_size_tooltip"),
  road_map_size = {
    X2Locale:LocalizeUiText(MAP_TEXT, "road_map_size_small"),
    X2Locale:LocalizeUiText(MAP_TEXT, "road_map_size_middle"),
    X2Locale:LocalizeUiText(MAP_TEXT, "road_map_size_big")
  }
}
locale.commonFarm = {
  title = X2Locale:LocalizeUiText(FARM_TEXT, "title"),
  item = X2Locale:LocalizeUiText(FARM_TEXT, "item"),
  time = X2Locale:LocalizeUiText(FARM_TEXT, "time"),
  area = X2Locale:LocalizeUiText(FARM_TEXT, "area"),
  map = X2Locale:LocalizeUiText(FARM_TEXT, "map"),
  growUp = X2Locale:LocalizeUiText(FARM_TEXT, "grow_up"),
  endanger = X2Locale:LocalizeUiText(FARM_TEXT, "endanger"),
  protectWaring = function(a)
    return X2Locale:LocalizeUiText(FARM_TEXT, "protect_waring", tostring(a))
  end,
  ableCount = function(a)
    return X2Locale:LocalizeUiText(FARM_TEXT, "able_count", tostring(a))
  end
}
locale.map = {
  title = X2Locale:LocalizeUiText(MAP_TEXT, "title"),
  checkQuset = X2Locale:LocalizeUiText(MAP_TEXT, "checkQuset"),
  visibleNpc = X2Locale:LocalizeUiText(MAP_TEXT, "visibleNpc"),
  guide = X2Locale:LocalizeUiText(MAP_TEXT, "guide"),
  w_gweonid_forest = X2Locale:LocalizeUiText(MAP_TEXT, "w_gweonid_forest"),
  w_garangdol_plains = X2Locale:LocalizeUiText(MAP_TEXT, "w_garangdol_plains"),
  w_marianople = X2Locale:LocalizeUiText(MAP_TEXT, "w_marianople"),
  cbsuh_nonpc = X2Locale:LocalizeUiText(MAP_TEXT, "cbsuh_nonpc"),
  peace_tax_tip = X2Locale:LocalizeUiText(MAP_TEXT, "peace_tax_tip"),
  allIcon = X2Locale:LocalizeUiText(MAP_TEXT, "allIcon"),
  NpcAllIcon = {
    X2Locale:LocalizeUiText(MAP_TEXT, "NpcAllIcon")
  },
  DoodadAllIcon = {
    X2Locale:LocalizeUiText(MAP_TEXT, "DoodadAllIcon")
  },
  filterBtn = X2Locale:LocalizeUiText(MAP_TEXT, "filterBtnTooltip"),
  pingBtn = X2Locale:LocalizeUiText(MAP_TEXT, "pingBtnTooltip", tostring("|cFF7bf545")),
  expandBtn = X2Locale:LocalizeUiText(MAP_TEXT, "expandBtnTooltip", tostring("|cFF7bf545")),
  lookMyPosition = X2Locale:LocalizeUiText(MAP_TEXT, "lookMyPosition"),
  pingPosition = X2Locale:LocalizeUiText(MAP_TEXT, "pingPosition"),
  changeMapScale = X2Locale:LocalizeUiText(MAP_TEXT, "changeMapScale"),
  showIcon = X2Locale:LocalizeUiText(MAP_TEXT, "showIcon"),
  pingMenu = {
    X2Locale:LocalizeUiText(MAP_TEXT, "delete")
  },
  slaveKind = function(str)
    return X2Locale:LocalizeUiText(SLAVE_KIND, str)
  end,
  shipyard = X2Locale:LocalizeUiText(HOUSING_TEXT, "material_shipyard"),
  telescopeOwner = function(str)
    return X2Locale:LocalizeUiText(MAP_TEXT, "telescopeOwner", tostring(str))
  end,
  telescopeExpedition = function(str)
    return X2Locale:LocalizeUiText(MAP_TEXT, "telescopeExpedition", tostring(str))
  end,
  telescopeBuff = X2Locale:LocalizeUiText(MAP_TEXT, "telescopeBuff", tostring(X2Locale:LocalizeUiText(MAP_TEXT, "protectedBuff"))),
  makeLongitudeStr = function(info, color1, color2)
    local str = string.format("%s%s%d\194\176%s%d' %d\"", color1, info.longitude, info.deg_long, color2, info.min_long, info.sec_long)
    return str
  end,
  makeLatitudeStr = function(info, color1, color2)
    local str = string.format("%s%s%d\194\176%s%d' %d\"", color1, info.latitude, info.deg_lat, color2, info.min_lat, info.sec_lat)
    return str
  end
}
locale.skill = {
  titleText = X2Locale:LocalizeUiText(SKILL_TEXT, "titleText"),
  skillInfoTitle = X2Locale:LocalizeUiText(SKILL_TEXT, "skill_info_title"),
  skill_notify_title = X2Locale:LocalizeUiText(SKILL_TEXT, "skill_notify_title"),
  openSkillWindow = X2Locale:LocalizeUiText(SKILL_TEXT, "open_skill_ui"),
  chooseAbility = X2Locale:LocalizeUiText(SKILL_TEXT, "chooseAbility"),
  attackSkill = X2Locale:LocalizeUiText(SKILL_TEXT, "category_attack"),
  generalSkill = X2Locale:LocalizeUiText(SKILL_TEXT, "category_general"),
  jobRaceSkill = X2Locale:LocalizeUiText(SKILL_TEXT, "category_job_race"),
  continue = X2Locale:LocalizeUiText(SKILL_TEXT, "category_buff"),
  abilityButtonText = X2Locale:LocalizeUiText(SKILL_TEXT, "abilityButtonText"),
  generalButtonText = X2Locale:LocalizeUiText(SKILL_TEXT, "generalButtonText"),
  actabilityButtonText = X2Locale:LocalizeUiText(SKILL_TEXT, "actabilityButtonText"),
  resetButoonExplain = X2Locale:LocalizeUiText(SKILL_TEXT, "resetButoonExplain"),
  GetJobText = function(job)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "job_display", tostring(job))
  end,
  GetAskSelectAbilityText = function(abilityName)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "ask_select_ability", tostring(abilityName), FONT_COLOR_HEX.DEFAULT)
  end,
  GetSkillPointText = function(point)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "useable_skill_point", FONT_COLOR_HEX.BLUE, tostring(point))
  end,
  GetSkillChangedText = function(a)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "skill_changed", tostring(a))
  end,
  GetAbilityRequirementText = function(level)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "ability_requirement", tostring(level))
  end,
  GetNewSkillPointText = function(point)
    return X2Locale:LocalizeUiText(SKILL_TEXT, "new_skill_point", tostring(point))
  end,
  newAbilityActivation = X2Locale:LocalizeUiText(SKILL_TEXT, "new_ability_activation"),
  newAbilityActivatable = X2Locale:LocalizeUiText(SKILL_TEXT, "new_ability_activatable"),
  actability = {
    ableExpertMaxCount = X2Locale:LocalizeUiText(SKILL_TEXT, "ableExpertMaxCount"),
    sampleTip = function(name, count, isMaster)
      if isMaster then
        return X2Locale:LocalizeUiText(SKILL_TEXT, "sample_tip_master", name, tostring(count))
      else
        return X2Locale:LocalizeUiText(SKILL_TEXT, "sample_tip_under_master", name, tostring(count))
      end
    end,
    unable_upgrade_actability_max_grade = function(a, b)
      return X2Locale:LocalizeUiText(SKILL_TEXT, "unable_upgrade_actability_max_grade", a, CommaStr(b))
    end,
    able_upgrade_actability = function(a, b)
      return X2Locale:LocalizeUiText(SKILL_TEXT, "able_upgrade_actability", a, CommaStr(b))
    end,
    unable_upgrade_actability = function(a, b)
      return X2Locale:LocalizeUiText(SKILL_TEXT, "unable_upgrade_actability", a, CommaStr(b))
    end
  }
}
locale.castingBar = {
  success = X2Locale:LocalizeUiText(CASTING_BAR_TEXT, "success"),
  stop = X2Locale:LocalizeUiText(CASTING_BAR_TEXT, "stop"),
  breath = X2Locale:LocalizeUiText(CASTING_BAR_TEXT, "breath")
}
locale.store = {
  item = X2Locale:LocalizeUiText(STORE_TEXT, "item"),
  defence = X2Locale:LocalizeUiText(STORE_TEXT, "defence"),
  availableMoney = X2Locale:LocalizeUiText(STORE_TEXT, "availableMoney"),
  sellTotalMoney = X2Locale:LocalizeUiText(STORE_TEXT, "sellTotalMoney"),
  buyTotalMoney = X2Locale:LocalizeUiText(STORE_TEXT, "buyTotalMoney"),
  shoppingBasket = X2Locale:LocalizeUiText(STORE_TEXT, "shoppingBasket"),
  clearShoppingBasket = X2Locale:LocalizeUiText(STORE_TEXT, "clearShoppingBasket"),
  buy = X2Locale:LocalizeUiText(STORE_TEXT, "buy"),
  buyAll = X2Locale:LocalizeUiText(STORE_TEXT, "buyAll"),
  sell = X2Locale:LocalizeUiText(STORE_TEXT, "sell"),
  sellAll = X2Locale:LocalizeUiText(STORE_TEXT, "sellAll"),
  reBuyList = X2Locale:LocalizeUiText(STORE_TEXT, "reBuyList"),
  preview = X2Locale:LocalizeUiText(STORE_TEXT, "preview"),
  wearItem = X2Locale:LocalizeUiText(STORE_TEXT, "wearItem"),
  noSlot = X2Locale:LocalizeUiText(STORE_TEXT, "noSlot"),
  registedItem = X2Locale:LocalizeUiText(STORE_TEXT, "registedItem"),
  cantSell = X2Locale:LocalizeUiText(STORE_TEXT, "cantSell"),
  cartNoSlot = X2Locale:LocalizeUiText(STORE_TEXT, "cartNoSlot"),
  sellNoSlot = X2Locale:LocalizeUiText(STORE_TEXT, "sellNoSlot"),
  noBuyList = X2Locale:LocalizeUiText(STORE_TEXT, "noBuyList"),
  sellmsg = X2Locale:LocalizeUiText(STORE_TEXT, "sellmsg"),
  sellmsg_stack = function(a, b)
    return string.format("%s %sx%s", X2Locale:LocalizeUiText(STORE_TEXT, "sellmsg"), a, CommaStr(b))
  end,
  buymsg = X2Locale:LocalizeUiText(STORE_TEXT, "buymsg"),
  disableSell = X2Locale:LocalizeUiText(STORE_TEXT, "disableSell"),
  disableSellInLivingStore = X2Locale:LocalizeUiText(STORE_TEXT, "disableSellInLivingStore"),
  spendCoinMsg = X2Locale:LocalizeUiText(STORE_TEXT, "spend_coin_msg"),
  emptyCartListMsg = X2Locale:LocalizeUiText(ERROR_MSG, "CART_EMPTY"),
  emptySellListMsg = X2Locale:LocalizeUiText(ERROR_MSG, "SELL_CART_EMPTY"),
  buy_left_money = X2Locale:LocalizeUiText(STORE_TEXT, "buy_left_money"),
  sell_left_money = X2Locale:LocalizeUiText(STORE_TEXT, "sell_left_money"),
  drain_tip = X2Locale:LocalizeUiText(STORE_TEXT, "drain_tip")
}
locale.store_specialty = {
  title = X2Locale:LocalizeUiText(STORE_TEXT, "title"),
  delphinad_title = X2Locale:LocalizeUiText(STORE_TEXT, "delphinad_title"),
  bodyText = X2Locale:LocalizeUiText(STORE_TEXT, "bodyText"),
  bodyTextFull = X2Locale:LocalizeUiText(STORE_TEXT, "bodyText_full"),
  delphinad_bodyText = X2Locale:LocalizeUiText(STORE_TEXT, "delphinad_bodyText"),
  prices = X2Locale:LocalizeUiText(STORE_TEXT, "prices"),
  noGoods = X2Locale:LocalizeUiText(ERROR_MSG, "STORE_BACKPACK_NOGOODS")
}
locale.npcCommon = {
  welcome = X2Locale:LocalizeUiText(NPC_COMMON_TEXT, "welcome"),
  follow_me = X2Locale:LocalizeUiText(NPC_COMMON_TEXT, "follow_me"),
  hold_here = X2Locale:LocalizeUiText(NPC_COMMON_TEXT, "hold_here"),
  attack = X2Locale:LocalizeUiText(NPC_COMMON_TEXT, "attack"),
  relic = X2Locale:LocalizeUiText(NPC_COMMON_TEXT, "relic"),
  Communicate = X2Locale:LocalizeUiText(NPC_COMMON_TEXT, "Communicate")
}
locale.npcEmploymentInteraction = {
  ability = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "ability"),
  period = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "period"),
  work_slot = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "work_slot"),
  level = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "level"),
  salary = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "salary"),
  cost = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "cost"),
  task_allocation = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "task_allocation"),
  teaching = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "teaching"),
  change_dress = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "change_dress"),
  rejoice = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "rejoice"),
  manage = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "manage"),
  employment_npc = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "employment_npc"),
  work = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "work"),
  employment = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "employment"),
  slot = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "slot"),
  employ = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "employ"),
  tast_list = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "tast_list"),
  follow_me = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "follow_me"),
  stop = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "stop"),
  dismiss = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "dismiss"),
  learning = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "learning"),
  loyalty = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "loyalty"),
  friendship = X2Locale:LocalizeUiText(NPC_EMPLOYMENT_INTERACTION_TEXT, "friendship")
}
locale.npcQuestInteraction = {
  GetRewardMoneyExp = function(a, b)
    return X2Locale:LocalizeUiText(NPC_QUEST_INTERACTION_TEXT, "reward_money_exp", IStr(a), IStr(b))
  end,
  GetRewardMoney = function(a)
    return X2Locale:LocalizeUiText(NPC_QUEST_INTERACTION_TEXT, "reward_money", IStr(a))
  end,
  GetRewardExp = function(a)
    return X2Locale:LocalizeUiText(NPC_QUEST_INTERACTION_TEXT, "reward_exp", IStr(a))
  end,
  GetAdditionalReward = function(a)
    return X2Locale:LocalizeUiText(NPC_QUEST_INTERACTION_TEXT, "additional_reward", a)
  end
}
locale.portal = {
  title = X2Locale:LocalizeUiText(PORTAL_TEXT, "portal_list"),
  write_portal = X2Locale:LocalizeUiText(PORTAL_TEXT, "write_portal"),
  addPortal = X2Locale:LocalizeUiText(PORTAL_TEXT, "add_portal"),
  returnPlace = X2Locale:LocalizeUiText(PORTAL_TEXT, "return_place"),
  cantRemovePlace = X2Locale:LocalizeUiText(PORTAL_TEXT, "cant_remove_place"),
  invalidZoneMsg = X2Locale:LocalizeUiText(PORTAL_TEXT, "invalidZoneMsg"),
  memo = X2Locale:LocalizeUiText(PORTAL_TEXT, "title"),
  save = X2Locale:LocalizeUiText(PORTAL_TEXT, "save"),
  itemDescUnused = X2Locale:LocalizeUiText(PORTAL_TEXT, "itemDescUnused"),
  itemDescUsed = X2Locale:LocalizeUiText(PORTAL_TEXT, "itemDescUsed"),
  titleNaviDoodad = X2Locale:LocalizeUiText(PORTAL_TEXT, "titleNaviDoodad"),
  naming = X2Locale:LocalizeUiText(PORTAL_TEXT, "naming"),
  delete_portal = X2Locale:LocalizeUiText(PORTAL_TEXT, "delete_portal"),
  location_name = X2Locale:LocalizeUiText(PORTAL_TEXT, "register_name"),
  zone_name = X2Locale:LocalizeUiText(PORTAL_TEXT, "zone_name"),
  world_name = X2Locale:LocalizeUiText(PORTAL_TEXT, "world_name"),
  map_location = X2Locale:LocalizeUiText(PORTAL_TEXT, "map_location"),
  showMap = X2Locale:LocalizeUiText(PORTAL_TEXT, "show_map"),
  ask_delete = function(a)
    return X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_delete_portal", a)
  end,
  menu = {
    X2Locale:LocalizeUiText(PORTAL_TEXT, "menu1"),
    X2Locale:LocalizeUiText(PORTAL_TEXT, "menu2"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "portal_favorite"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun")
  },
  indun_name = X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_name"),
  enter_condition = X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_entrance_condition"),
  player_count = X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_player_count"),
  daily_use = X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_daily_use"),
  location = X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_location")
}
locale.stabler = {
  title = X2Locale:LocalizeUiText(STABLER_TEXT, "title"),
  needPet = X2Locale:LocalizeUiText(STABLER_TEXT, "needPet"),
  cost = X2Locale:LocalizeUiText(STABLER_TEXT, "cost")
}
locale.skillTrainer = {
  title = X2Locale:LocalizeUiText(SKILL_TRAINER_TEXT, "title"),
  underConstruct = X2Locale:LocalizeUiText(SKILL_TRAINER_TEXT, "underConstruct"),
  iWillComeBack = X2Locale:LocalizeUiText(SKILL_TRAINER_TEXT, "iWillComeBack")
}
locale.housing = {
  materialWindow = {
    subTitle = X2Locale:LocalizeUiText(HOUSING_TEXT, "material_subtitle"),
    step = X2Locale:LocalizeUiText(HOUSING_TEXT, "material_step"),
    tax = X2Locale:LocalizeUiText(HOUSING_TEXT, "material_tax"),
    shipyard = X2Locale:LocalizeUiText(HOUSING_TEXT, "material_shipyard")
  },
  furnitureCount = X2Locale:LocalizeUiText(HOUSING_TEXT, "furniture_count"),
  typeFurnitureCount = X2Locale:LocalizeUiText(HOUSING_TEXT, "type_furniture_count"),
  noneFurniture = X2Locale:LocalizeUiText(HOUSING_TEXT, "none_furniture"),
  payState = {
    unpaid = X2Locale:LocalizeUiText(HOUSING_TEXT, "pay_state_unpaid"),
    full = X2Locale:LocalizeUiText(HOUSING_TEXT, "pay_state_full"),
    overdue = X2Locale:LocalizeUiText(HOUSING_TEXT, "pay_state_overdue")
  },
  checkPayment = X2Locale:LocalizeUiText(HOUSING_TEXT, "check_payment"),
  untilTerm = X2Locale:LocalizeUiText(HOUSING_TEXT, "until_term"),
  furnitureLock = X2Locale:LocalizeUiText(HOUSING_TEXT, "furniture_lock"),
  constructionWindow = {
    title = X2Locale:LocalizeUiText(HOUSING_TEXT, "workTitle"),
    progressStep = X2Locale:LocalizeUiText(HOUSING_TEXT, "progress_step"),
    GetLeftText = function(leftStep)
      local text = X2Locale:LocalizeUiText(HOUSING_TEXT, "left_step", tostring(leftStep))
      return X2Util:ConvertFormatString(text)
    end
  },
  buildWindow = {
    title = X2Locale:LocalizeUiText(HOUSING_TEXT, "build_title"),
    buildInfo = X2Locale:LocalizeUiText(HOUSING_TEXT, "build_buildInfo"),
    heavyTax = X2Locale:LocalizeUiText(HOUSING_TEXT, "build_heavyTax"),
    heavyTaxExemption = function(colorA, colorB)
      return X2Locale:LocalizeUiText(HOUSING_TEXT, "build_heavy_tax_exemption", colorA, colorB)
    end,
    heavyTaxDesc = X2Locale:LocalizeUiText(HOUSING_TEXT, "build_heavyTaxDesc"),
    materialLabel = X2Locale:LocalizeUiText(HOUSING_TEXT, "build_materialLabel"),
    taxPaymentDesc = X2Locale:LocalizeUiText(HOUSING_TEXT, "build_taxPaymentDesc")
  },
  faction = X2Locale:LocalizeUiText(HOUSING_TEXT, "faction"),
  taxRate = X2Locale:LocalizeUiText(HOUSING_TEXT, "tax_rate"),
  paymentTax = X2Locale:LocalizeUiText(HOUSING_TEXT, "payment_tax"),
  dueDateForPayment = X2Locale:LocalizeUiText(HOUSING_TEXT, "due_date"),
  demolishDate = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_date"),
  left = X2Locale:LocalizeUiText(HOUSING_TEXT, "left"),
  tax_warning = X2Locale:LocalizeUiText(HOUSING_TEXT, "tax_warning"),
  taxExemptionWarning = X2Locale:LocalizeUiText(HOUSING_TEXT, "tax_exemption_warning"),
  demolishWarning = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_warning"),
  choicePermission = X2Locale:LocalizeUiText(HOUSING_TEXT, "choice_permission"),
  usePermission = X2Locale:LocalizeUiText(HOUSING_TEXT, "use_permission"),
  consumeLabor = function(a)
    return X2Locale:LocalizeUiText(HOUSING_TEXT, "consume_labor", IStr(a))
  end,
  incompleted_warning = X2Locale:LocalizeUiText(HOUSING_TEXT, "incompleted_warning"),
  maintainWindow = {
    changeName = X2Locale:LocalizeUiText(COMMON_TEXT, "housing_change_name"),
    cancelChangeName = X2Locale:LocalizeUiText(HOUSING_TEXT, "cancel_change_name"),
    acatbilityUp = X2Locale:LocalizeUiText(HOUSING_TEXT, "acatbility_up"),
    acatbilityUpInfo = X2Locale:LocalizeUiText(HOUSING_TEXT, "acatbility_up_info"),
    acatbilityUpMsg = X2Locale:LocalizeUiText(HOUSING_TEXT, "acatbility_up_msg"),
    heavyTaxExemption = X2Locale:LocalizeUiText(HOUSING_TEXT, "maintain_heavy_tax_exemption")
  },
  permissions = {
    {
      text = X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_0"),
      value = HOUSE_ALLOW_OWNER,
      tooltip = X2Locale:LocalizeUiText(HOUSING_TEXT, "closed_condition_tip")
    },
    {
      text = X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_3"),
      value = HOUSE_ALLOW_FAMILY
    },
    {
      text = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "expedition"),
      value = HOUSE_ALLOW_EXPEDITION
    },
    {
      text = X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_2"),
      value = HOUSE_ALLOW_ALL
    }
  },
  demolish = {
    title = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_title"),
    content = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_content"),
    ok = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_ok")
  },
  sell = {
    register = X2Locale:LocalizeUiText(HOUSING_TEXT, "sell_register"),
    set = X2Locale:LocalizeUiText(HOUSING_TEXT, "sell_set"),
    cancel = X2Locale:LocalizeUiText(HOUSING_TEXT, "sell_cancel"),
    price = X2Locale:LocalizeUiText(HOUSING_TEXT, "sell_price"),
    titlePriceSet = X2Locale:LocalizeUiText(HOUSING_TEXT, "title_sell_price_set"),
    titleNeedItemSet = X2Locale:LocalizeUiText(HOUSING_TEXT, "title_sell_need_item_set"),
    titleTargetSet = X2Locale:LocalizeUiText(HOUSING_TEXT, "title_sell_target_set"),
    editGuide = X2Locale:LocalizeUiText(HOUSING_TEXT, "title_sell_target_set"),
    everyoneSell = X2Locale:LocalizeUiText(HOUSING_TEXT, "everyone_sell"),
    targetSell = function(a)
      return X2Locale:LocalizeUiText(HOUSING_TEXT, "target_sell", a)
    end,
    warning_belong_furniture = X2Locale:LocalizeUiText(HOUSING_TEXT, "warning_belong_furniture")
  },
  informationWindow = {
    owner = X2Locale:LocalizeUiText(HOUSING_TEXT, "owner"),
    invicibleDuration = X2Locale:LocalizeUiText(HOUSING_TEXT, "invicibleDuration"),
    demolishDuration = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolishDuration"),
    demolishDurationTooltip = X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_duration_tooltip")
  },
  inSiegeWarning = X2Locale:LocalizeUiText(HOUSING_TEXT, "in_siege_warning"),
  alwaysPublicTip = X2Locale:LocalizeUiText(HOUSING_TEXT, "always_public_tip"),
  title = X2Locale:LocalizeUiText(HOUSING_TEXT, "title"),
  infoTitle = X2Locale:LocalizeUiText(HOUSING_TEXT, "infoTitle"),
  permissionTitle = X2Locale:LocalizeUiText(HOUSING_TEXT, "permissionTitle"),
  moneyTitle = X2Locale:LocalizeUiText(HOUSING_TEXT, "moneyTitle"),
  upgrade = X2Locale:LocalizeUiText(HOUSING_TEXT, "upgrade"),
  destroy = X2Locale:LocalizeUiText(HOUSING_TEXT, "destroy"),
  pay = X2Locale:LocalizeUiText(HOUSING_TEXT, "pay"),
  balance = X2Locale:LocalizeUiText(HOUSING_TEXT, "balance"),
  doYouWantUpgrade = X2Locale:LocalizeUiText(HOUSING_TEXT, "doYouWantUpgrade"),
  doYouWantDestroy = X2Locale:LocalizeUiText(HOUSING_TEXT, "doYouWantDestroy"),
  howMuch = X2Locale:LocalizeUiText(HOUSING_TEXT, "howMuch"),
  houseMoney = X2Locale:LocalizeUiText(HOUSING_TEXT, "houseMoney"),
  houseMoney2 = X2Locale:LocalizeUiText(HOUSING_TEXT, "houseMoney2"),
  housePermissionTitle = X2Locale:LocalizeUiText(HOUSING_TEXT, "housePermissionTitle"),
  buildAreaMsg = X2Locale:LocalizeUiText(HOUSING_TEXT, "buildAreaMsg"),
  invalidPrice = X2Locale:LocalizeUiText(HOUSING_TEXT, "invalidPrice"),
  msg_house_change_name = X2Locale:LocalizeUiText(HOUSING_TEXT, "msg_house_change_name")
}
locale.housing.housePermissions = {
  X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_0"),
  X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_1"),
  X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_2"),
  X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_3")
}
locale.territory = {
  title = X2Locale:LocalizeUiText(TERRITORY_TEXT, "title"),
  info = X2Locale:LocalizeUiText(TERRITORY_TEXT, "info"),
  ownership = X2Locale:LocalizeUiText(TERRITORY_TEXT, "owner_ship"),
  lord = X2Locale:LocalizeUiText(TERRITORY_TEXT, "lord"),
  governPeriod = X2Locale:LocalizeUiText(TERRITORY_TEXT, "govern_period"),
  peaceMoney = X2Locale:LocalizeUiText(TERRITORY_TEXT, "peace_money"),
  setTaxRate = X2Locale:LocalizeUiText(TERRITORY_TEXT, "set_tax_rate"),
  taxRate = X2Locale:LocalizeUiText(TERRITORY_TEXT, "tax_rate"),
  taxtations = X2Locale:LocalizeUiText(TERRITORY_TEXT, "taxtations"),
  taxItemTip = function(color, itemName)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "guide_icon_tooltip_tax_item", color, itemName)
  end,
  wndTitle = X2Locale:LocalizeUiText(TERRITORY_TEXT, "window_title"),
  tabTerritory = X2Locale:LocalizeUiText(TERRITORY_TEXT, "tab_territory"),
  tabCastle = X2Locale:LocalizeUiText(TERRITORY_TEXT, "tab_castle"),
  castleGate = X2Locale:LocalizeUiText(TERRITORY_TEXT, "castle_gate"),
  castleWall = X2Locale:LocalizeUiText(TERRITORY_TEXT, "castle_wall"),
  castleTower = X2Locale:LocalizeUiText(TERRITORY_TEXT, "castle_tower"),
  maxCastleLimit = X2Locale:LocalizeUiText(TERRITORY_TEXT, "max_castle_limit")
}
locale.craft = {
  highRankItem = X2Locale:LocalizeUiText(CRAFT_TEXT, "high_rank_item"),
  craftItem = X2Locale:LocalizeUiText(CRAFT_TEXT, "craft_item"),
  requireLaborPower = X2Locale:LocalizeUiText(CRAFT_TEXT, "require_labor_power"),
  requireMastery = X2Locale:LocalizeUiText(CRAFT_TEXT, "require_mastery"),
  showAll = X2Locale:LocalizeUiText(CRAFT_TEXT, "show_all"),
  cancel = X2Locale:LocalizeUiText(QUEST_INTERACTION_TEXT, "craft_cancel"),
  craftBook = X2Locale:LocalizeUiText(CRAFT_TEXT, "craftBook"),
  allMake = X2Locale:LocalizeUiText(CRAFT_TEXT, "allMake"),
  craftInfo = X2Locale:LocalizeUiText(CRAFT_TEXT, "craftInfo"),
  maximum = X2Locale:LocalizeUiText(CRAFT_TEXT, "maximum"),
  itemSearchLabel = X2Locale:LocalizeUiText(CRAFT_TEXT, "itemSearchLabel"),
  itemList = X2Locale:LocalizeUiText(CRAFT_TEXT, "itemList"),
  defaultLaborPowerUsed = X2Locale:LocalizeUiText(CRAFT_TEXT, "defaultLaborPowerUsed"),
  craftSuccessRate = X2Locale:LocalizeUiText(CRAFT_TEXT, "craftSuccessRate"),
  recommendLevel = X2Locale:LocalizeUiText(CRAFT_TEXT, "recommendLevel")
}
locale.skillTrainingMsg = {
  not_enough_money = X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "skillTrainingMsg_0"),
  not_enough_sp = X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "skillTrainingMsg_1"),
  use_1_sp = X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "skillTrainingMsg_2"),
  skill_init_msg_1 = X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "skill_init_msg_1"),
  skill_init_msg_3 = X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "skill_init_msg_3"),
  skill_init_msg_4 = function(point)
    return X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "skill_init_msg_4", tostring(point))
  end,
  consume_heir_points = function(point)
    return X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "consume_heir_points", tostring(point))
  end,
  heir_skill_training_msg = X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "heir_skill_training_msg")
}
locale.combat = {
  critical = X2Locale:LocalizeUiText(COMBAT_TEXT, "critical"),
  miss = X2Locale:LocalizeUiText(COMBAT_TEXT, "miss"),
  dodge = X2Locale:LocalizeUiText(COMBAT_TEXT, "dodge"),
  block = X2Locale:LocalizeUiText(COMBAT_TEXT, "block"),
  parry = X2Locale:LocalizeUiText(COMBAT_TEXT, "parry"),
  immune = X2Locale:LocalizeUiText(COMBAT_TEXT, "immune"),
  resist = X2Locale:LocalizeUiText(COMBAT_TEXT, "resist"),
  spell_aura_removed = X2Locale:LocalizeUiText(COMBAT_TEXT, "spell_aura_removed"),
  combat_text_synergy = X2Locale:LocalizeUiText(COMBAT_TEXT, "combat_text_synergy"),
  combat_text_synergy_damage = X2Locale:LocalizeUiText(COMBAT_TEXT, "combat_text_synergy_damage"),
  player_enter_combat = X2Locale:LocalizeUiText(COMBAT_TEXT, "player_enter_combat"),
  player_leave_combat = X2Locale:LocalizeUiText(COMBAT_TEXT, "player_leave_combat")
}
locale.physicalEnchant = {
  great_fail = X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_break"),
  fail = X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_fail"),
  success = X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_success"),
  great_success = X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_great_success"),
  broadcast_success_alarm = function(a, b, c)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_success_alarm", a, b, c)
  end,
  broadcast_great_success_alarm = function(a, b, c)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_great_success_alarm", a, b, c)
  end,
  broadcast_scale_success_alarm = function(a, b, c)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_enchant_scale_success", a, b, c)
  end,
  broadcast_scale_great_success_alarm = function(a, b, c)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_enchant_scale_great_success", a, b, c)
  end,
  broadcast_evolving_alarm = function(a, b, c, d, e)
    return string.format("%s.", X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_evolving_alarm", a, b, c, d, e))
  end,
  success_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "success_msg"),
  success_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "success_answer"),
  failed_no_dmg_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "failed_no_dmg_msg"),
  failed_no_dmg_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "failed_no_dmg_answer"),
  failed_dmg_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "failed_dmg_msg"),
  failed_dmg_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "failed_dmg_answer"),
  failed_destroy_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "failed_destroy_msg"),
  failed_destroy_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "failed_destroy_answer"),
  invalid_item_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "invalid_item_msg"),
  invalid_item_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "invalid_item_answer"),
  lack_ability_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_ability_msg"),
  lack_ability_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_ability_answer"),
  lack_friendship_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_friendship_msg"),
  lack_friendship_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_friendship_answer"),
  Get_lack_money_msg = function(a)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_money_msg", a)
  end,
  lack_money_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_money_answer"),
  Get_lack_archium_msg = function(a)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_archium_msg", a)
  end,
  lack_archium_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_archium_answer"),
  Get_lack_cost_msg = function(a, b)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_cost_msg", a, b)
  end,
  lack_cost_answer = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "lack_cost_answer"),
  Get_enchant_msg = function(a, b, c)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "enchant_msg", a, b, c)
  end,
  enchant_answer_1 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "enchant_answer_1"),
  enchant_answer_2 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "enchant_answer_2"),
  enchant_answer_3 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "enchant_answer_3"),
  enchant_answer_4 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "enchant_answer_4"),
  desc_msg_1 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_msg_1"),
  Get_desc_msg_2 = function(a, b)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_msg_2", a, b)
  end,
  Get_desc_msg_3 = function(a)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_msg_3", a)
  end,
  Get_desc_msg_4 = function(a)
    return X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_msg_4", a)
  end,
  desc_msg_5 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_msg_5"),
  desc_answer_1 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_answer_1"),
  desc_answer_2 = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "desc_answer_2"),
  armor_weapon = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "armor_weapon"),
  armor = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "armor"),
  weapon = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "weapon"),
  ask_enchant_msg = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "ask_enchant_msg")
}
locale.faction = {
  infomation = X2Locale:LocalizeUiText(FACTION_TEXT, "infomation"),
  name = X2Locale:LocalizeUiText(FACTION_TEXT, "name"),
  master = X2Locale:LocalizeUiText(FACTION_TEXT, "master"),
  my_influence = X2Locale:LocalizeUiText(FACTION_TEXT, "my_influence"),
  detail = X2Locale:LocalizeUiText(FACTION_TEXT, "detail"),
  show_detail = X2Locale:LocalizeUiText(FACTION_TEXT, "show_detail"),
  friendship = X2Locale:LocalizeUiText(FACTION_TEXT, "friendship"),
  my_post = X2Locale:LocalizeUiText(FACTION_TEXT, "my_post"),
  personnel = X2Locale:LocalizeUiText(FACTION_TEXT, "personnel"),
  level = X2Locale:LocalizeUiText(FACTION_TEXT, "level"),
  area = X2Locale:LocalizeUiText(FACTION_TEXT, "area"),
  viscount = X2Locale:LocalizeUiText(FACTION_TEXT, "viscount"),
  relation_proposed_war = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_proposed_war", proposer, subject)
  end,
  relation_proposed_peace = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_proposed_peace", proposer, subject)
  end,
  relation_accepted_war = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_accepted_war", proposer, subject)
  end,
  relation_accepted_peace = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_accepted_peace", proposer, subject)
  end,
  relation_declined_war = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_declined_war", proposer, subject)
  end,
  relation_declined_peace = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_declined_peace", proposer, subject)
  end,
  relation_cancelled_war = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_cancelled_war", proposer, subject)
  end,
  relation_cancelled_peace = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_cancelled_peace", proposer, subject)
  end,
  relation_expired_war = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_expired_war", proposer, subject)
  end,
  relation_expired_peace = function(proposer, subject)
    return X2Locale:LocalizeUiText(FACTION_TEXT, "relation_expired_peace", proposer, subject)
  end,
  GetAmount = function(a)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "amount", IStr(a))
  end
}
locale.community = {
  race = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "race"),
  friend = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "friend"),
  family = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "family"),
  town = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "town"),
  relationship = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "relationship"),
  expedition = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "expedition"),
  faction = X2Locale:LocalizeUiText(COMMON_TEXT, "faction"),
  nation = X2Locale:LocalizeUiText(NATION_TEXT, "nation"),
  id = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "id"),
  position = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "position"),
  job = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "job"),
  guild_name = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "guild_name"),
  family_name = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "family_name"),
  post = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "post"),
  invite = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "invite"),
  delete = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "delete"),
  couple_invite = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "couple_invite"),
  child_invite = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "child_invite"),
  leave = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "leave"),
  kick = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "kick"),
  dismission = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "dismission"),
  independence = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "independence"),
  divorce = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "divorce"),
  delegate = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "delegate"),
  upgrade = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "upgrade"),
  degrade = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "degrade"),
  grade_owner = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "grade_owner"),
  grade_officer = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "grade_officer"),
  grade_assistant = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "grade_assistant"),
  grade_normal = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "grade_normal"),
  family_noname = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "family_noname"),
  unblock = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "unblock")
}
locale.relationship = {
  tabText = {
    X2Locale:LocalizeUiText(COMMUNITY_TEXT, "tab_first_text"),
    X2Locale:LocalizeUiText(COMMUNITY_TEXT, "tab_second_text")
  },
  onlineMember = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "online_member"),
  GetOnlineAcquaintanceText = function(a)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "online_acquaintance", a)
  end
}
locale.family = {
  no_family = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "no_family"),
  invite_syntax = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "invite_syntax"),
  title_syntax = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "title_syntax"),
  member_added = function(owner, member, role)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_added", owner, member, role)
  end,
  member_left = function(member)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_left", member)
  end,
  member_kicked = function(member)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_kicked", member)
  end,
  member_desc = function(owner, member, role)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_desc", owner, member, role)
  end,
  owner_desc = function(owner)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "owner_desc", owner)
  end,
  owner_changed = function(owner)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "owner_changed", owner)
  end,
  name = X2Locale:LocalizeUiText(FACTION_TEXT, "name"),
  title = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "title"),
  role = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "role"),
  add_family = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "add_family_member"),
  family_leader = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "family_leader"),
  owner_title = function(owner, title)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "owner_title", owner, title)
  end,
  input_title_guide = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "please_input_title"),
  kick_member = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "kick_family_member"),
  change_owner = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "change_family_leader"),
  removed = X2Locale:LocalizeUiText(ERROR_MSG, "FAMILY_REMOVED"),
  inputTitle = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "input_title"),
  tooltip_text = function(owner, title)
    return X2Locale:LocalizeUiText(COMMUNITY_TEXT, "community_desc", owner, title)
  end,
  onlineMember = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "online_family"),
  changeTitle = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "change_title"),
  inputGuide = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "input_guide"),
  leave_family = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "leave_family")
}
locale.friend = {
  title = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "title"),
  addFriend = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "add_friend"),
  showOffMember = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "show_off_member"),
  playJournal = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "play_journal"),
  deleteFriend = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "delete_friend")
}
locale.block = {
  add = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "add_ignore"),
  block = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "block")
}
locale.expedition = {
  title = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "title"),
  notice = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "notice"),
  notificationTitle = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "notificationTitle"),
  notification = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "notification"),
  ok = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "ok"),
  cancel = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "cancel"),
  outlaw_title = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "outlaw_title"),
  confirm = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "confirm"),
  creationFailTitle = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "creation_fail_title"),
  creationFailMsg = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "creation_fail_msg"),
  managementTitle = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "management_title"),
  onlineMember = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "online_member"),
  partyPlay = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "party_play"),
  kick = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "kick"),
  viewOffMember = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "view_off_member"),
  role = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "role"),
  position = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "position"),
  memo = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "memo"),
  inviteRaid = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_raidteam_invite"),
  inviteParty = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_party_invite"),
  invite = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_expedition_invite"),
  changeName = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "change_name"),
  changeComplete = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "change_complete"),
  changeRole = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "change_role"),
  delegate = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "delegate"),
  sendMessage = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "send_message"),
  dominionDeclare = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "dominion_declare"),
  inviteMember = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "invite_member"),
  expel = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "expel"),
  promote = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "promote"),
  joinSiege = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "join_siege"),
  siegeMaster = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "siegeMaster"),
  dismiss = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "dismiss"),
  chat = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "chat"),
  managerChat = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "manager_chat"),
  leave = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_leave_expedition"),
  delegateTitle = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "delegate_title"),
  delegateMsg = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "delegate_msg"),
  createGuide = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "create_guide"),
  inputNameGuide = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "input_name_guide"),
  notInExpedition = X2Locale:LocalizeUiText(ERROR_MSG, "CHAT_NOT_IN_EXPEDITION"),
  apply = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "policy_apply"),
  before_year = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "before_year"),
  before_month = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "before_month"),
  before_day = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "before_day"),
  before_hour = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "before_hour"),
  before_min = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "before_min"),
  less_min = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "less_min"),
  role_name = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "role_name_0"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "role_name_1"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "role_name_2"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "role_name_3"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "role_name_255")
  },
  nuia_alliance_name = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_1"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_2"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_3"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_4"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_5"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_6"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_7")
  },
  nuia_alliance_desc = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_1_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_2_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_3_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_4_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_5_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_6_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "nuia_sponsor_7_desc")
  },
  harihara_alliance_name = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_1"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_2"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_3"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_4"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_5"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_6")
  },
  harihara_alliance_desc = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_1_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_2_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_3_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_4_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_5_desc"),
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "harihara_sponsor_6_desc")
  },
  outlaw_name = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "outlaw_name1")
  },
  outlaw_desc = {
    X2Locale:LocalizeUiText(EXPEDITION_TEXT, "outlaw_desc1")
  },
  siege = {
    title = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "siege_title")
  },
  siegeAuction = X2Locale:LocalizeUiText(EXPEDITION_TEXT, "siege_title")
}
locale.grammar = {
  textAnd = X2Locale:LocalizeUiText(UTIL_TEXT, "grammar_text_and")
}
locale.continent = {
  west = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "west"),
  east = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "east"),
  origin = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "origin")
}
locale.changeName = {
  mate_title = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "change_name_title", X2Locale:LocalizeUiText(AUCTION_TEXT, "item_group_vehicle")),
  slave_title = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "change_name_title", X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "slave")),
  name_guide_default = X2Locale:LocalizeUiText(COMMON_TEXT, "name_guide_default"),
  name_guide_expedition = X2Locale:LocalizeUiText(COMMON_TEXT, "name_guide_expedition"),
  name_guide_family_appellation = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "name_guide_family_appellation"),
  change_content_guide = X2Locale:LocalizeUiText(UNIT_FRAME_TEXT, "change_name_label"),
  create_content_guide = X2Locale:LocalizeUiText(COMMON_TEXT, "create_content_guide"),
  name_guide_chat_tab = X2Locale:LocalizeUiText(CHAT_CREATE_TAB_TEXT, "name_guide_chat_tab"),
  name_guide_portal = X2Locale:LocalizeUiText(PORTAL_TEXT, "name_guide_portal"),
  register_content_guide = X2Locale:LocalizeUiText(PORTAL_TEXT, "guide_text"),
  korean = X2Locale:LocalizeUiText(COMMON_TEXT, "korean"),
  english = X2Locale:LocalizeUiText(COMMON_TEXT, "english"),
  limit_alphabet = function(a, b)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "limit_alphabet", a, b)
  end,
  limit_multi_lang_alphabet = function(a, b, c, d, e, f)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "limit_multi_lang_alphabet", a, b, c, d, e, f)
  end,
  allow_mixcase = X2Locale:LocalizeUiText(COMMON_TEXT, "allow_mixcase"),
  allow_space = X2Locale:LocalizeUiText(COMMON_TEXT, "allow_space"),
  allow_space_limit = function(a)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "allow_space_limit", a)
  end,
  allow_special_character = X2Locale:LocalizeUiText(COMMON_TEXT, "allow_special_character")
}
locale.temp = {
  text1 = X2Locale:LocalizeUiText(TEMP_TEXT, "text1"),
  text2 = X2Locale:LocalizeUiText(TEMP_TEXT, "text2"),
  text3 = X2Locale:LocalizeUiText(TEMP_TEXT, "text3"),
  text4 = X2Locale:LocalizeUiText(TEMP_TEXT, "text4"),
  text5 = X2Locale:LocalizeUiText(TEMP_TEXT, "text5"),
  text6 = X2Locale:LocalizeUiText(TEMP_TEXT, "text6")
}
locale.web = {
  cast_title = X2Locale:LocalizeUiText(WEB_TEXT, "cast_title"),
  cast_transfer_doing = X2Locale:LocalizeUiText(WEB_TEXT, "cast_transfer_doing"),
  cast_transfer_succeeded = X2Locale:LocalizeUiText(WEB_TEXT, "cast_transfer_succeeded"),
  cast_transfer_failed = X2Locale:LocalizeUiText(WEB_TEXT, "cast_transfer_failed"),
  diary_transfer_doing = X2Locale:LocalizeUiText(WEB_TEXT, "diary_transfer_doing"),
  diary_transfer_succeeded = X2Locale:LocalizeUiText(WEB_TEXT, "diary_transfer_succeeded"),
  diary_transfer_failed = X2Locale:LocalizeUiText(WEB_TEXT, "diary_transfer_failed")
}
locale.icon_shape_button_tooltip = {
  portal_delete = X2Locale:LocalizeUiText(PORTAL_TEXT, "portal_delete"),
  portal_rename = X2Locale:LocalizeUiText(PORTAL_TEXT, "portal_rename"),
  portal_spawn = X2Locale:LocalizeUiText(PORTAL_TEXT, "spawn_Portal"),
  inviteRaid = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_raidteam_invite"),
  raid_option = X2Locale:LocalizeUiText(RAID_TEXT, "raid_option"),
  changeToRaid = X2Locale:LocalizeUiText(RAID_TEXT, "convert_raid"),
  range_invite = X2Locale:LocalizeUiText(RAID_TEXT, "area_invite")
}
locale.trial = {
  wait_jury_tip = function(a)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "wait_jury_tip", tostring(a))
  end,
  count = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_count"),
  crimeRecordTitle = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_title"),
  crimeRecordOk = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_ok"),
  crimeRecordTotal = function(total)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_total", tostring(total))
  end,
  crimeRecordId = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_id"),
  crimeRecordType = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_type"),
  crimeRecordVictim = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_victim"),
  crimeRecordMemo = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_memo"),
  crimeRecordReportedBy = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_reported_by"),
  crimeRecordBelongTo = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_belong_to"),
  crimeReportByDoodad = function(doodad)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_reported_by_doodad", doodad)
  end,
  crimeReportLocation = function(location)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_report_location", location)
  end,
  crimeReportTime = function(report_time)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_report_time", report_time)
  end,
  crimeReport = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_report"),
  botSuspectReport = function(target)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "bot_suspect_report", target)
  end,
  crimeRecordGuideText = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_record_guide_text"),
  crimeTypeAssault = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_type_assault"),
  crimeTypeMurder = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_type_murder"),
  crimeTypeTheft = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_type_theft"),
  crimeTypeEtc = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_type_etc"),
  waitTrialTitle = X2Locale:LocalizeUiText(TRIAL_TEXT, "wait_trial_title"),
  waitJury = function(waitTime, count, total)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "wait_jury", FONT_COLOR_HEX.RED, tostring(waitTime), FONT_COLOR_HEX.BLACK, tostring(count), tostring(total))
  end,
  waitTrial = function(waitTime, order)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "wait_trial", FONT_COLOR_HEX.RED, tostring(waitTime), FONT_COLOR_HEX.BLACK, tostring(order))
  end,
  waitCancelTrial = X2Locale:LocalizeUiText(TRIAL_TEXT, "wait_cancel_trial"),
  verdictTitle = X2Locale:LocalizeUiText(TRIAL_TEXT, "verdict_title"),
  verdictChoose = X2Locale:LocalizeUiText(TRIAL_TEXT, "verdict_choose"),
  verdictNotGuilty = X2Locale:LocalizeUiText(TRIAL_TEXT, "verdict_not_guilty"),
  verdictGuilty = function(minutes)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "verdict_guilty", tostring(minutes))
  end,
  verdictWarning = X2Locale:LocalizeUiText(TRIAL_TEXT, "verdict_warning"),
  verdictConfirm = X2Locale:LocalizeUiText(TRIAL_TEXT, "verdict_confirm"),
  theft_tip = function(skill_name, name)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "theft_tip", tostring(skill_name), tostring(name))
  end,
  rulingTitle = X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_title"),
  rulingSummary = function(murder, assault, theft, etc)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_summary", tostring(murder), tostring(assault), tostring(theft), tostring(etc))
  end,
  rulingInProgress = X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_in_progress"),
  rulingResult = X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_result"),
  rulingStatus = function(count, total)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_status", tostring(count), tostring(total))
  end,
  rulingResultGuilty = function(minutes)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_result_guilty", tostring(minutes))
  end,
  rulingResultNotGuilty = X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_result_not_guilty"),
  audienceJoined = function(name)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "audience_joined", name)
  end,
  audienceLeft = function(name)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "audience_left", name)
  end,
  crimePointStr = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_point_str"),
  arrestHistory = X2Locale:LocalizeUiText(TRIAL_TEXT, "arrest_history"),
  trialChoice = function(acceptTrial, acceptGuilty)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "trial_choice", acceptTrial, acceptGuilty)
  end,
  rulingHistory = X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_history"),
  rulingChoice = function(guilty, notGuilty)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "ruling_choice", guilty, notGuilty)
  end,
  jailTotal = X2Locale:LocalizeUiText(TRIAL_TEXT, "jail_total"),
  jailMinutes = function(minutes)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "jail_minutes", minutes)
  end,
  totalRecords = X2Locale:LocalizeUiText(TRIAL_TEXT, "total_records"),
  stateMessage = {
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_1"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_2"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_3"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_4"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_5"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_6"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_7"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_8"),
    X2Locale:LocalizeUiText(TRIAL_TEXT, "state_message_9")
  },
  remainTime = function(str)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "remain_time", str)
  end,
  remainCount = function(num1, num2)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "remain_count", num1, num2)
  end,
  input_report = X2Locale:LocalizeUiText(TRIAL_TEXT, "input_report"),
  canceled = X2Locale:LocalizeUiText(TRIAL_TEXT, "canceled"),
  bountyTitle = X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_title"),
  bountyText = function(target)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_text", target)
  end,
  bountyDone = function(target, gold, silver, copper)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_done", target, gold, silver, copper)
  end,
  bountyPaid = function(hunter, arrested, gold, silver, copper)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_paid", hunter, arrested, gold, silver, copper)
  end,
  bountyBulletin = X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_bulletin"),
  bountyWanted = X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_wanted"),
  bountyLevel = X2Locale:LocalizeUiText(TRIAL_TEXT, "level"),
  bountyLocation = X2Locale:LocalizeUiText(TRIAL_TEXT, "known_location"),
  bountyMoney = X2Locale:LocalizeUiText(TRIAL_TEXT, "bounty_money"),
  balanceText = X2Locale:LocalizeUiText(TRIAL_TEXT, "my_money_balance"),
  botSuspectReported = function(source, target)
    return X2Locale:LocalizeUiText(TRIAL_TEXT, "bot_reported", source, target)
  end,
  reportTitle = X2Locale:LocalizeUiText(TRIAL_TEXT, "report_title"),
  reportTime = X2Locale:LocalizeUiText(TRIAL_TEXT, "report_time")
}
locale.honorPointWar = {
  changeState = function(name, state)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "change_state", name, state)
  end,
  endWar = function(name)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "end_war", name)
  end,
  leaveWarArea = function(state)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "leave_war_area", state)
  end,
  enterWarArea = function(state)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "enter_war_area", state)
  end,
  getHonorPoint = function(point)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "get_honor_point", point)
  end,
  loseHonorPoint = function(point)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "lose_honor_point", point)
  end,
  stateDangerousStep = function(step)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step", tostring(step))
  end,
  stateDangerousTooltipTitle = function(state)
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_tooltip_title", state)
  end,
  appliedDebuff = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "applied_debuff"),
  removedDebuff = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "removed_debuff"),
  stateDangerousHud = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_hud"),
  stateConflictHud = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_conflict_hud"),
  stateWarHud = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_war_hud"),
  statePeaceHud = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_peace_hud"),
  stateConflict = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_conflict"),
  stateWar = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_war"),
  statePeace = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_peace"),
  stateConflictTooltipTitle = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_conflict_tooltip_title"),
  stateWarTooltipTitle = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_war_tooltip_title"),
  statePeaceTooltipTitle = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_peace_tooltip_title"),
  stateTooltip = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_tooltip"),
  statePeaceTooltip = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_peace_tooltip"),
  stateDangerousStep1 = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step1"),
  stateDangerousStep2 = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step2"),
  stateDangerousStep3 = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step3"),
  stateDangerousStep4 = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step4"),
  stateDangerousStep5 = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step5"),
  getZoneState = function(state)
    if state < HPWS_BATTLE then
      local step = state + 1
      local title = locale.honorPointWar["stateDangerousStep" .. step]
      return string.format("%s(%s)", title, locale.honorPointWar.stateDangerousStep(step))
    elseif state == HPWS_BATTLE then
      return locale.honorPointWar.stateConflict
    elseif state == HPWS_WAR then
      return locale.honorPointWar.stateWar
    elseif state == HPWS_PEACE then
      return locale.honorPointWar.statePeace
    end
  end,
  getZoneStateHud = function(state)
    if state < HPWS_BATTLE then
      local step = state + 1
      local name = locale.honorPointWar.stateDangerousHud
      local desc = locale.honorPointWar["stateDangerousStep" .. step]
      return string.format("%s:%s", name, desc)
    elseif state == HPWS_BATTLE then
      return locale.honorPointWar.stateConflictHud
    elseif state == HPWS_WAR then
      return locale.honorPointWar.stateWarHud
    elseif state == HPWS_PEACE then
      return locale.honorPointWar.statePeaceHud
    end
  end,
  getZoneStateTooltipTitle = function(state)
    if state < HPWS_BATTLE then
      local strState = locale.honorPointWar.getZoneState(state)
      return locale.honorPointWar.stateDangerousTooltipTitle(strState)
    elseif state == HPWS_BATTLE then
      return locale.honorPointWar.stateConflictTooltipTitle
    elseif state == HPWS_WAR then
      return locale.honorPointWar.stateWarTooltipTitle
    elseif state == HPWS_PEACE then
      return locale.honorPointWar.statePeaceTooltipTitle
    end
  end
}
locale.inGameShop = {
  buy = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "buy"),
  present = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "present"),
  putToCart = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "putToCart"),
  needFriendName = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "needFriendName"),
  price = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "price"),
  remain = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "remain"),
  startDate = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "startDate"),
  endDate = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "endDate"),
  inGameShop = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "inGameShop"),
  chargeAAPoint = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "chargeAAPoint"),
  unknownName = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "unknownName"),
  GetRequiredQuest = function(questName)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "getRequiredQuest", questName)
  end,
  GetRequiredLevel = function(level)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "getRequiredLevel", tostring(level))
  end,
  cart = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "cart"),
  deleteTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "deleteTitle"),
  priceTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "priceTitle"),
  nameTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "nameTitle"),
  delete = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "delete"),
  friend = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "friend"),
  cantPresent = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "cantPresent"),
  selectType = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "selectType"),
  cancel = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "cancel"),
  package = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "package"),
  resultTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "resultTitle"),
  successPresent = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "successPresent"),
  failPresent = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "failPresent"),
  successBuy = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "successBuy"),
  failBuy = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "failBuy"),
  resultPutToCart = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "resultPutToCart"),
  putToCartFullError = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "putToCartFullError"),
  putToCartNormalError = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "putToCartNormalError"),
  cashError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_NOT_ENOUGH_AA_CASH"),
  friendNameError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_FIND_CHARACTER_NAME_FAIL"),
  soldOutError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_SOLD_OUT"),
  expiredDateError = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "expiredDateError"),
  expiredDateError2 = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_EXPIRED_SELL_BY_DATE"),
  normalError = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "normalError"),
  countPerAccoutError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_BUY_NO_DUPLICATE_ITEM"),
  sameAccountError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_FIND_CHARACTER_SAME_ACCOUNT"),
  limitedTotalPriceError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_LIMITED_BUY_FOR_TOTAL_PRICE"),
  bmMileageError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_NOT_ENOUGH_BM_MILEAGE"),
  invalidAccountError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_BUY_FAIL_INVALID_ACCOUNT"),
  deletedCharacterError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_CHRACTER_DELETE_REQUESTED"),
  transferCharacterError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_CHRACTER_TRANSFER_REQUESTED"),
  useAACoinForGiftError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_CANNOT_USE_AACOIN_FOR_GIFT"),
  goldError = X2Locale:LocalizeUiText(ERROR_MSG, "INGAME_SHOP_NOT_ENOUGH_GOLD"),
  noticePresentGood = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "noticePresentGood"),
  noticeBuyGood = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "noticeBuyGood"),
  eventDateTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "eventDateTitle"),
  bonusAAPointTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "bonusAAPointTitle"),
  bonusItemTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "bonusItemTitle"),
  alwaysBuy = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "alwaysBuy"),
  GetBuyPerAccount = function(a)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "buyPerAccount", tostring(a))
  end,
  GetBuyPerCharacter = function(a)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "buyPerCharacter", tostring(a))
  end,
  GetBuyPerDay = function(a)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "buyPerDay", tostring(a))
  end,
  bonusNotice = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "bonusNotice"),
  myCash = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "myCash"),
  myAAPoint = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "myAAPoint"),
  totalBuyMoney = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "totalBuyMoney"),
  totalMoneyAfterBuy = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "totalMoneyAfterBuy"),
  GetMainMenuName = function(index)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "main_menu_" .. tostring(index))
  end,
  GetSubMenuName = function(mainIndex, subIndex)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "sub_menu_" .. tostring(mainIndex) .. "_" .. tostring(subIndex))
  end,
  cashToAAPoint = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "cashToAAPoint"),
  afterMyCashTitle = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "afterMyCashTitle"),
  GetChangeRatioText = function(cashText, pointText)
    return X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "getChangeRatioText", cashText, pointText)
  end,
  nowCheckTime = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "nowCheckTime"),
  nowCheckTimeTitle = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_message"),
  ingameshop_name = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "ingameshop_name"),
  askBuyAAPoint = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "askBuyAAPoint"),
  enterBeautyShop = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "enterBeautyShop"),
  genderTransfer = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "genderTransfer"),
  enterBeautyShopBtn = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "enterBeautyShopBtn"),
  genderTransferBtn = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "genderTransferBtn"),
  buyButtonTooltip = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "buyButtonTooltip"),
  presentButtonTooltip = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "presentButtonTooltip"),
  cartButtonTooltip = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "cartButtonTooltip"),
  commercialMailButtonTooltip = X2Locale:LocalizeUiText(INGAMESHOP_TEXT, "commercialMailButtonTooltip")
}
locale.battlefield = {
  title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "instant_game_bad_level"),
  immediatelyExit = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "immediately_exit"),
  requestEntrance = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "request_entrance"),
  cancelEntrance = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "cancel_entrance"),
  waiting = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "waiting"),
  currentPeople = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "current_people"),
  trainingCampBattlefield = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "training_camp_battlefield"),
  onTheSeaBattlefield = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "on_the_sea_battlefield"),
  myRequest = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "my_request"),
  gmEvent = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "gm_event_game"),
  readyTime = function(mm, ss)
    return string.format(X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "ready_time"), mm, ss)
  end,
  playTime = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "play_time"),
  playTimeDetail = function(a, b)
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "play_time_detail", tostring(a), tostring(b))
  end,
  roundInfo = function(a, b)
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "round_info", tostring(a), tostring(b))
  end,
  scoreRankInfo = function(a, b)
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "score_rank_info", tostring(a), tostring(b))
  end,
  shop = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "battle_field_shop"),
  scoreSlaveCount = function(a)
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "score_slave_count", tostring(a))
  end,
  tooltip = {
    battle_ship_score = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "battle_ship_tooltip_score", tostring(a))
    end
  },
  winCondition = {
    title = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "win_codition_title"),
    scoreAttainment = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "codition_score_attainment", tostring(a))
    end,
    killCountAttainment = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "condition_score_attainment", tostring(a))
    end,
    roundWinCountAttainment = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "condition_round_win_count_attainment", tostring(a))
    end,
    targetDestruction = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "condition_target_destruction"),
    timeoverScopeRank = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "condition_timeover_score_rank", tostring(a))
    end,
    scoreSuperiority = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "condition_score_superiority"),
    tip = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "condition_tip")
  },
  winConditionTip = {
    victoryScore = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "mini_scoreboard_win_codition_tip_4", tostring(a))
    end,
    victoryKillCount = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "mini_scoreboard_win_codition_tip_1", tostring(a))
    end,
    victoryRoundWinCount = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "mini_scoreboard_win_codition_tip_5", tostring(a))
    end,
    victoryTarget = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "mini_scoreboard_win_codition_tip_2"),
    timeover = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "mini_scoreboard_win_codition_tip_3"),
    timeoverScopeRank = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "mini_scoreboard_win_condition_tip_6", tostring(a))
    end
  },
  alarmEndReason = {
    timeover = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "end_time_over"),
    killCount = function(a, b)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "end_kill_enemy", tostring(a), tostring(b))
    end,
    roundWinCount = function(a, b)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "end_round_win_count", tostring(a), tostring(b))
    end,
    killCorpsHead = function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "end_destroy_target", tostring(a))
    end
  },
  scoreboardEndReason = {
    X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "scoreboard_end_reason_time_over"),
    function(a, b)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "scoreboard_end_reason_kill_enemy", tostring(a), tostring(b))
    end,
    function(a)
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "scoreboard_end_reason_destroy_target", tostring(a))
    end
  },
  scoreboard = {
    kill = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "kill"),
    death = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "death"),
    assist = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "assist"),
    score = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "score"),
    totalScore = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "total_score"),
    reward = X2Locale:LocalizeUiText(COMMON_TEXT, "battle_field_scoreboard_reward"),
    destruction = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "destruction"),
    elimination = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "elimination"),
    participant = X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, "participant"),
    battle_ship_result = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "battle_ship_result")
  },
  GetKillMsg = function(a, b, c, d, e)
    if a == c then
      key = "kill_same_team_msg"
    elseif b == X2Unit:UnitName("player") then
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "killed_by_me_msg", d, e)
    else
      key = "kill_msg"
    end
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, key, a, b, c, d, e)
  end,
  entrancePossibleLevel = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "entrance_possible_level"),
  randomOrganizeTeam = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "random_organize_team"),
  trainingCampDesc = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "training_camp_desc"),
  miniScoreBoard = {
    victoryConditions = {
      category = DOMINION,
      key = "siege_win_rule_guide_title"
    },
    progressInfos = {
      category = COMMON_TEXT,
      key = "progress_info"
    },
    myRecords = {category = COMMON_TEXT, key = "my_record"}
  }
}
locale.composition = {
  noteKorean = {
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_c_2"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_d_2"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_e_2"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_f_2"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_g_2"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_a_2"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_b_2")
  },
  noteEnglish = {
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_c_1"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_d_1"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_e_1"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_f_1"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_g_1"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_a_1"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllable_names_b_1")
  },
  title = {
    syllableNames = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "title_syllableNames"),
    noteLength = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "title_note_length"),
    restLength = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "title_rest_length"),
    etc = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "title_etc"),
    example = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "title_example")
  },
  inputGuide = {
    syllableNames = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "input_guide_syllable_names"),
    noteLength = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "input_guide_note_length"),
    restLength = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "input_guide_rest_length")
  },
  notes = {
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "whole_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "half_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "quarter_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "eighth_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sixteenth_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "thirty_second_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sixty_fourth_note"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "dotted_note")
  },
  values = {
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "one"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "two"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "four"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "eight"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sixteen"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "thirty_two"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sixty_four"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "dot")
  },
  rests = {
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "whole_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "half_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "quarter_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "eighth_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sixteenth_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "thirty_second_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sixty_fourth_rest"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "dotted_rest")
  },
  etcs = {
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "octave"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "volume"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "sound_length"),
    X2Locale:LocalizeUiText(COMPOSITION_TEXT, "tempo")
  },
  etcDesc = {
    {
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc1_1"),
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc1_2")
    },
    {
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc2_1"),
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc2_2")
    },
    {
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc3_1"),
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc3_2")
    },
    {
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc4_1"),
      X2Locale:LocalizeUiText(COMPOSITION_TEXT, "etc_desc4_2")
    }
  },
  syllableNames = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "syllableNames"),
  method = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "method"),
  score = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "score"),
  actability = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "actability"),
  musicSample = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "music_sample"),
  saveMusic = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "save_music"),
  actability_tip = X2Locale:LocalizeUiText(COMPOSITION_TEXT, "actability_tip")
}
locale.customSaveLoad = {
  customSave = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_save"),
  customSaveContent = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_save_content"),
  customSaveMsg = function(a)
    return X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_save_msg", a)
  end,
  customLoad = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_load"),
  customLoadOk = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_load_ok"),
  customLoadOkMsg = function(a)
    return X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_load_ok_msg", a)
  end,
  customLoadOkContent = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_load_ok_content"),
  customOverWrite = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_over_write"),
  customOverWriteContent = function(a)
    return X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_over_write_content", a)
  end,
  customDelete = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_delete"),
  customDeleteContent = function(a)
    return X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_delete_content", a)
  end,
  customDeleteMsg = function(a)
    return X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_delete_msg", a)
  end,
  customSelectMsg = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_select_msg"),
  customNoNameMsg = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_no_name_msg"),
  customNoPath = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_no_path"),
  customNoFile = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_no_file"),
  customSameFile = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_same_file"),
  customInvalidData = X2Locale:LocalizeUiText(CUSTOMIZING_TEXT, "custom_invalid_data")
}
locale.chatOptionFontSizeText = {
  bigSmall = X2Locale:LocalizeUiText(OPTION_TEXT, "font_size_big_small"),
  small = X2Locale:LocalizeUiText(OPTION_TEXT, "font_size_small"),
  middle = X2Locale:LocalizeUiText(OPTION_TEXT, "font_size_middle"),
  large = X2Locale:LocalizeUiText(OPTION_TEXT, "font_size_large"),
  bigLarge = X2Locale:LocalizeUiText(OPTION_TEXT, "font_size_big_large")
}
locale.nationMgr = {
  nation = X2Locale:LocalizeUiText(NATION_TEXT, "nation"),
  dominion = X2Locale:LocalizeUiText(NATION_TEXT, "dominion"),
  belognExpedition = X2Locale:LocalizeUiText(NATION_TEXT, "belogn_expedition"),
  nationRelation = X2Locale:LocalizeUiText(NATION_TEXT, "nation_relation"),
  siegeRaidTeam = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team"),
  peopleManage = X2Locale:LocalizeUiText(NATION_TEXT, "people_manage"),
  changeName = X2Locale:LocalizeUiText(NATION_TEXT, "change_name"),
  king = X2Locale:LocalizeUiText(NATION_TEXT, "king"),
  lord = X2Locale:LocalizeUiText(NATION_TEXT, "lord"),
  dominionCnt = X2Locale:LocalizeUiText(NATION_TEXT, "dominion_count"),
  peopleCnt = X2Locale:LocalizeUiText(NATION_TEXT, "people_count"),
  peopleUnit = X2Locale:LocalizeUiText(NATION_TEXT, "people_unit"),
  independenceDay = X2Locale:LocalizeUiText(NATION_TEXT, "independence_day"),
  withdrawNation = X2Locale:LocalizeUiText(NATION_TEXT, "withdraw_nation"),
  dominionList = X2Locale:LocalizeUiText(NATION_TEXT, "dominion_list"),
  expeditionCnt = X2Locale:LocalizeUiText(NATION_TEXT, "expedition_count"),
  capital = X2Locale:LocalizeUiText(NATION_TEXT, "capital"),
  nativeDominion = X2Locale:LocalizeUiText(NATION_TEXT, "native_dominion"),
  selectedDominion = X2Locale:LocalizeUiText(NATION_TEXT, "selected_dominion"),
  friendlyNation = X2Locale:LocalizeUiText(NATION_TEXT, "friendly_nation"),
  hostileNation = X2Locale:LocalizeUiText(NATION_TEXT, "hostile_nation"),
  warNation = X2Locale:LocalizeUiText(NATION_TEXT, "war_nation"),
  noOwner = X2Locale:LocalizeUiText(NATION_TEXT, "no_owner"),
  equal_tax_rate_warning = X2Locale:LocalizeUiText(NATION_TEXT, "equal_tax_rate_warning"),
  own = X2Locale:LocalizeUiText(NATION_TEXT, "own"),
  reignPeriod = X2Locale:LocalizeUiText(NATION_TEXT, "reign_period"),
  now = X2Locale:LocalizeUiText(NATION_TEXT, "now"),
  extraTax = X2Locale:LocalizeUiText(NATION_TEXT, "extra_tax"),
  nationTax = X2Locale:LocalizeUiText(NATION_TEXT, "nation_tax"),
  lordGain = X2Locale:LocalizeUiText(NATION_TEXT, "lord_gain"),
  kingGain = X2Locale:LocalizeUiText(NATION_TEXT, "king_gain"),
  applicantManagement = X2Locale:LocalizeUiText(NATION_TEXT, "applicant_management"),
  awaiter = X2Locale:LocalizeUiText(NATION_TEXT, "awaiter"),
  populationLimit = X2Locale:LocalizeUiText(NATION_TEXT, "population_limit"),
  limitRestriction = X2Locale:LocalizeUiText(NATION_TEXT, "limit_restriction"),
  requestBlock = X2Locale:LocalizeUiText(NATION_TEXT, "request_block_list"),
  peopleInvite = X2Locale:LocalizeUiText(NATION_TEXT, "people_invite"),
  peopleKick = X2Locale:LocalizeUiText(NATION_TEXT, "people_kick"),
  joinApproval = X2Locale:LocalizeUiText(NATION_TEXT, "join_approval"),
  joinRejected = X2Locale:LocalizeUiText(NATION_TEXT, "join_rejected"),
  peopleInvite = X2Locale:LocalizeUiText(NATION_TEXT, "people_invite"),
  supportPeople = X2Locale:LocalizeUiText(NATION_TEXT, "support_people"),
  hostileNation = X2Locale:LocalizeUiText(NATION_TEXT, "hostile_nation"),
  friendlyNation = X2Locale:LocalizeUiText(NATION_TEXT, "friendly_nation"),
  belongExpeditionInfo = X2Locale:LocalizeUiText(NATION_TEXT, "belong_expedition_info"),
  expedition = X2Locale:LocalizeUiText(NATION_TEXT, "expedition"),
  populationLimitWarning = X2Locale:LocalizeUiText(NATION_TEXT, "population_limit_warning"),
  noDominionWarning = X2Locale:LocalizeUiText(NATION_TEXT, "no_dominion_warning"),
  noDominion = X2Locale:LocalizeUiText(NATION_TEXT, "no_dominion"),
  noDominionList = X2Locale:LocalizeUiText(NATION_TEXT, "no_dominion_list"),
  peopleInviteDlg = function(a, b)
    return X2Locale:LocalizeUiText(NATION_TEXT, "people_invite_dlg", tostring(a), tostring(b))
  end,
  withdrawNationDlg = function(a)
    return X2Locale:LocalizeUiText(NATION_TEXT, "withdraw_nation_dlg", tostring(a), tostring(X2Nation:GetFactionInviteRescrictionTime()))
  end,
  expedition = X2Locale:LocalizeUiText(NATION_TEXT, "expedition"),
  dominionToolTip = X2Locale:LocalizeUiText(NATION_TEXT, "dominion_tooltip"),
  peopleManageInviteToolTip = X2Locale:LocalizeUiText(NATION_TEXT, "peoplemanage_invite_tooltip"),
  peopleManageKickToolTip = X2Locale:LocalizeUiText(NATION_TEXT, "peoplemanage_kick_tooltip"),
  nationIndependenceMsg = function(a, b)
    return X2Locale:LocalizeUiText(NATION_TEXT, "nation_Independence_Msg", tostring(a), tostring(b))
  end,
  regist_condition = X2Locale:LocalizeUiText(NATION_TEXT, "regist_condition"),
  regist_condition_tip = function(a)
    return X2Locale:LocalizeUiText(NATION_TEXT, "regist_condition_tip", tostring(a), tostring(X2Nation:GetFactionInviteRescrictionTime()))
  end,
  join_condition_tip = function(a)
    return X2Locale:LocalizeUiText(NATION_TEXT, "join_condition_tip", tostring(a))
  end,
  nationTaxRate = function(a, b, c)
    return X2Locale:LocalizeUiText(NATION_TEXT, "nation_taxrate", tostring(a), tostring(b), tostring(c))
  end,
  nation_authority = X2Locale:LocalizeUiText(NATION_TEXT, "nation_authority"),
  remain_period = X2Locale:LocalizeUiText(NATION_TEXT, "remain_period"),
  siegeRaidCommander = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_commander"),
  siegeRaidTeamMemberCount = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_member"),
  siegeRaidSponser = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_sponsor"),
  siegeRaidZone = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_zone"),
  siegeRaidState = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_state"),
  siegeRaidSchedule = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_period"),
  siegeRaidHeroList = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_hero_list"),
  siegeRaidTeamMemberList = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_member_list"),
  siegeRaidTeamApplicant = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_apply")
}
locale.secondPassword = {
  secondPassword = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "second_password"),
  createTitle = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "create_title"),
  modifyTitle = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "modify_title"),
  clearTitle = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_title"),
  content = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "content"),
  passwordTip = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "password_tip"),
  passwordGuide = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "password_guide"),
  passwordConfirm = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "password_confirm"),
  securityTip = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "security_tip"),
  verificationTitle = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "verification_title"),
  verificationContent = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "verification_content"),
  reinputCount = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "reinput_count"),
  clearContent = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_content"),
  usable = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "usable"),
  unusable = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "unusable"),
  accordance = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "accordance"),
  discordance = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "discordance"),
  setting_success = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "setting_success"),
  setting_fail = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "setting_fail"),
  change_success = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "change_success"),
  change_fail = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "change_fail"),
  change_same_fail = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "change_same_fail"),
  clear_success = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_success"),
  clear_fail = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_fail"),
  confirmation_success = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_success"),
  confirmation_fail = function(a, b)
    if b > 0 then
      return X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_fail_with_retry", tostring(a), tostring(b))
    else
      return X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_fail")
    end
  end,
  account_lock = function(a)
    return X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "account_lock", tostring(a))
  end,
  lock_state_played = function(a)
    return X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "lock_state_played", tostring(a))
  end,
  setting_content = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "setting_content"),
  passwordWebLift = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "password_web_lift"),
  curPassword = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "cur_password"),
  newPassword = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "new_password"),
  newPasswordConfirm = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "new_password_confirm"),
  passwordShort = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "password_short"),
  recommendSecondPasswordTitle = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "recommendSecondPasswordTitle"),
  reservedSecondPasswordClear = function(remainDate)
    return X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "reserved_second_password_clear", remainDate)
  end
}
locale.lookConverter = {
  material = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "material"),
  convertFee = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "convertFee"),
  baseItem = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "baseItem"),
  lookItem = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "lookItem"),
  newItem = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "newItem"),
  convert = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "convert"),
  cancel = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "cancel"),
  baseItemTooltip = function(color)
    return X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "baseItemTooltip", color)
  end,
  lookItemTooltip = function(color)
    return X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "lookItemTooltip", color)
  end,
  extractBaseItemTooltip = function(color)
    return X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "extractBaseItemTooltip", color)
  end,
  extractLookItemTooltip = function(color)
    return X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "extractLookItemTooltip", color)
  end,
  successNotice = function(str)
    return X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "successNotice", str)
  end,
  warning = X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "look_convert_warning")
}
locale.ranking = {
  title = X2Locale:LocalizeUiText(RANKING_TEXT, "ranking"),
  reward = X2Locale:LocalizeUiText(RANKING_TEXT, "reward"),
  rank = X2Locale:LocalizeUiText(RANKING_TEXT, "rank"),
  placing = X2Locale:LocalizeUiText(RANKING_TEXT, "placing"),
  recordTime = X2Locale:LocalizeUiText(RANKING_TEXT, "record_time"),
  standard = X2Locale:LocalizeUiText(RANKING_TEXT, "standard"),
  updateTip = function(a)
    return X2Locale:LocalizeUiText(RANKING_TEXT, "update_tip", tostring(a))
  end,
  rewardProvisionDay = function(a)
    return X2Locale:LocalizeUiText(RANKING_TEXT, "reward_provision_day", tostring(a))
  end,
  battlefieldScoreTipTitle = X2Locale:LocalizeUiText(RANKING_TEXT, "battlefield_score_tip_title"),
  battlefieldScoreTipBody = X2Locale:LocalizeUiText(RANKING_TEXT, "battlefield_score_tip_body")
}
locale.premium = {
  grade = function(gradeText)
    return X2Locale:LocalizeUiText(PREMIUM_TEXT, "grade", gradeText)
  end,
  premium_not_enough_cash = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_not_enough_cash"),
  premium_not_enough_cash_explan = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_not_enough_cash_explan"),
  premium_not_enough_point = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_not_enough_point"),
  premium_not_enough_point_explan = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_not_enough_point_explan"),
  premium_buy = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_buy"),
  premium_buy_explan = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_buy_explan"),
  premium_name = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_name"),
  benefit = X2Locale:LocalizeUiText(PREMIUM_TEXT, "benefit"),
  premium_apply_effect = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_apply_effect"),
  add_point = X2Locale:LocalizeUiText(PREMIUM_TEXT, "add_point"),
  premium_benefit_add_explan = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_benefit_add_explan"),
  minus_point = X2Locale:LocalizeUiText(PREMIUM_TEXT, "minus_point"),
  premium_benefit_minus_explan = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_benefit_minus_explan"),
  my_premium_point = X2Locale:LocalizeUiText(PREMIUM_TEXT, "my_premium_point"),
  premium_service = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_service"),
  point_rule = X2Locale:LocalizeUiText(PREMIUM_TEXT, "point_rule"),
  premium_grade = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_grade"),
  upgrade_premium = X2Locale:LocalizeUiText(PREMIUM_TEXT, "upgrade_premium"),
  downgrade_premium = X2Locale:LocalizeUiText(PREMIUM_TEXT, "downgrade_premium"),
  point_buy = X2Locale:LocalizeUiText(PREMIUM_TEXT, "point_buy"),
  cash_buy = X2Locale:LocalizeUiText(PREMIUM_TEXT, "cash_buy"),
  premium_kind = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_kind"),
  premium_price = X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_price"),
  use_premium_service = X2Locale:LocalizeUiText(PREMIUM_TEXT, "use_premium_service"),
  auction_post_autority = X2Locale:LocalizeUiText(PREMIUM_TEXT, "auction_post_autority"),
  only_premium_quest = X2Locale:LocalizeUiText(PREMIUM_TEXT, "only_premium_quest"),
  online_labor_power_recover = X2Locale:LocalizeUiText(PREMIUM_TEXT, "online_labor_power_recover"),
  offline_labor_power_recover = X2Locale:LocalizeUiText(PREMIUM_TEXT, "offline_labor_power_recover"),
  add_max_labor_power = X2Locale:LocalizeUiText(PREMIUM_TEXT, "add_max_labor_power"),
  premium_grade_num = function(point)
    return X2Locale:LocalizeUiText(PREMIUM_TEXT, "premium_grade_num", point)
  end,
  error_msg_success = X2Locale:LocalizeUiText(ERROR_MSG, "PREMIUM_SERVICE_BUY_SUCCESS"),
  error_msg_fail = X2Locale:LocalizeUiText(ERROR_MSG, "PREMIUM_SERVICE_BUY_FAIL"),
  error_msg_cash = X2Locale:LocalizeUiText(ERROR_MSG, "PREMIUM_SERVICE_NOT_ENOUGH_AA_CASH"),
  bonus = X2Locale:LocalizeUiText(PREMIUM_TEXT, "bonus"),
  give_bmmileage = X2Locale:LocalizeUiText(PREMIUM_TEXT, "give_bmmileage"),
  real_money = function(money)
    return X2Locale:LocalizeUiText(PREMIUM_TEXT, "real_money", money)
  end,
  honor_point_gain_war = {
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade1"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade2"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade3"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade4"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade5"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade6"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade7"),
    X2Locale:LocalizeUiText(PREMIUM_TEXT, "honor_point_gain_war_grade8")
  },
  goods = X2Locale:LocalizeUiText(PREMIUM_TEXT, "goods")
}
locale.sensitiveOperation = {
  remain_time = function(remainTime)
    return X2Locale:LocalizeUiText(PROTECT_SENSITIVE_OPERATION_TEXT, "remain_time", remainTime)
  end,
  title = X2Locale:LocalizeUiText(PROTECT_SENSITIVE_OPERATION_TEXT, "title"),
  content = X2Locale:LocalizeUiText(PROTECT_SENSITIVE_OPERATION_TEXT, "content"),
  successContent = X2Locale:LocalizeUiText(PROTECT_SENSITIVE_OPERATION_TEXT, "sensitive_operation_verify_success")
}
locale.moneyTooltip = {
  aapoint = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "aapoint_tooltip"),
  money = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "money_tooltip")
}
locale.systemHotKeyErrorMessage = X2Locale:LocalizeUiText(ERROR_MSG, "CAN_NOT_USE_SYSTEM_HOT_KEY")
locale.reportBadUser = {
  title = X2Locale:LocalizeUiText(COMMON_TEXT, "report_bad_user"),
  target = X2Locale:LocalizeUiText(COMMON_TEXT, "report_target"),
  reportReason = X2Locale:LocalizeUiText(COMMON_TEXT, "report_reason"),
  reportTime = X2Locale:LocalizeUiText(COMMON_TEXT, "report_time"),
  reportTypeBot = X2Locale:LocalizeUiText(COMMON_TEXT, "report_type_bot"),
  reportTypeMail = X2Locale:LocalizeUiText(COMMON_TEXT, "report_type_bad_mail"),
  reportTypeChat = X2Locale:LocalizeUiText(COMMON_TEXT, "report_type_bad_chat"),
  reportTypeEtc = X2Locale:LocalizeUiText(TRIAL_TEXT, "crime_type_etc"),
  reportTypeAbusing = X2Locale:LocalizeUiText(COMMON_TEXT, "report_type_abusing"),
  reportTypeBadCharacterName = X2Locale:LocalizeUiText(COMMON_TEXT, "report_type_bad_character_name"),
  reportTypeExpeditionName = X2Locale:LocalizeUiText(COMMON_TEXT, "report_type_bad_expedition_name"),
  reportRecords = X2Locale:LocalizeUiText(COMMON_TEXT, "report_records"),
  writeReport = X2Locale:LocalizeUiText(COMMON_TEXT, "write_report_reason"),
  askReport = X2Locale:LocalizeUiText(COMMON_TEXT, "ask_report_bad_user"),
  resetCount = function(a)
    return X2Locale:LocalizeUiText(COMMON_TEXT, "reset_report_count", a)
  end
}
locale.forceAttack = {
  toolTip = function(protectPvp)
    if protectPvp then
      return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "builtin_toggle_force_attack_by_protect_pvp_tooltip", tostring(X2Player:GetProtectPvpLevel() + 1))
    else
      return X2Locale:LocalizeUiText(TOOLTIP_TEXT, "builtin_toggle_force_attack_tooltip")
    end
  end
}
function locale.GetAllAchievementKindString()
  return baselibLocale.achievementKindString
end
function locale.GetAchievementKindString(kind)
  return baselibLocale.achievementKindString[kind] == nil and X2Locale:LocalizeUiText(MAP_TEXT, "unknown") or baselibLocale.achievementKindString[kind]
end
