function AddMessageToQuestNotifyMessage(msg)
  quest_notifyWindow:AddMessage(msg)
  quest_notifyWindow:Raise()
end
function AddMessageToNotifyMessage(msg)
  notifyWindow:AddMessage(msg)
  notifyWindow:Raise()
end
function AddMessageToRaidCommandWindow(msg)
  raidCommandMsgWindow:Show(true)
  raidCommandMsgWindow.showingTime = 0
  raidCommandMsgWindow:SetHandler("OnUpdate", raidCommandMsgWindow.OnUpdate)
  raidCommandMsgWindow:SetTextAutoWidth(500, msg, 5)
  raidCommandMsgWindow:SetHeight(raidCommandMsgWindow:GetTextHeight())
  local height = raidCommandMsgWindow:GetTextHeight()
  if height <= 50 then
    height = height * 3
  else
    height = height * 2.5
  end
  raidCommandMsgWindow.bg:SetHeight(height)
  raidCommandMsgWindow.bg:RemoveAllAnchors()
  raidCommandMsgWindow.bg:AddAnchor("LEFT", raidCommandMsgWindow, -45, 0)
  raidCommandMsgWindow.bg:AddAnchor("RIGHT", raidCommandMsgWindow, 45, 0)
end
function AddMessageToNoticeWindow(msg, visibleTime, needCountdown)
  noticeWindow:AddMessageToQueue(msg, visibleTime, needCountdown)
end
function AddMessageToHonorPointWarWindow(msg, subMsg)
  honorPointWarWnd:Show(true)
  honorPointWarWnd.showingTime = 0
  honorPointWarWnd:SetHandler("OnUpdate", honorPointWarWnd.OnUpdate)
  honorPointWarWnd:SetText(msg)
  honorPointWarWnd.subTextBox:SetText(subMsg)
  honorPointWarWnd.bg:SetVisible(true)
  honorPointWarWnd.bg:RemoveAllAnchors()
  local width = honorPointWarWnd:GetLongestLineWidth()
  if subMsg == "" then
    honorPointWarWnd.bg:SetHeight(60)
    honorPointWarWnd.bg:SetWidth(width + 100)
    honorPointWarWnd.bg:AddAnchor("CENTER", honorPointWarWnd, 0, 0)
  else
    honorPointWarWnd.bg:SetHeight(90)
    honorPointWarWnd.bg:SetWidth(width + 150)
    honorPointWarWnd.bg:AddAnchor("CENTER", honorPointWarWnd, 0, 11)
  end
  honorPointWarWnd:Raise()
end
function AddMessageToSysMsgWindow(msg)
  systemAlertWindow:AddMessageRefresh(msg)
  systemAlertWindow:Raise()
end
function AddSiegeScheduleMsg(zoneGroupType, periodName, zoneGroupName, defenseName, offenseName, onEvent, isMyInfo, action)
  return siegeSystemAlarmWindow:UpdateSiegeSchedule(zoneGroupType, periodName, zoneGroupName, defenseName, offenseName, onEvent, isMyInfo, action)
end
function AddSiegeReinforcementsArrivedMsg(name)
  return siegeSystemAlarmWindow:ReinforcementsArrived(name)
end
function AddSiegeAlertGuardTowerMsg(status)
  return siegeSystemAlarmWindow:AlertGuardTower(status)
end
function AddSiegeAlertEngravingMsg(status, name, factionName)
  return siegeSystemAlarmWindow:AlertEngraving(status, name, factionName)
end
function AddSiegeDeclareTerritoryMsg(msg)
  return siegeSystemAlarmWindow:DeclareTerritory(msg)
end
centerMessageEventListener = UIParent:CreateWidget("emptywidget", "centerMessageEventListener", systemLayerParent)
centerMessageEventListener:Show(false)
local curStateZoneId
local centerMessageEvents = {
  ENTERED_SUBZONE = function(zoneName)
    ShowZoneEnterMessage(zoneName)
  end,
  SYSMSG = function(msg)
    AddMessageToSysMsgWindow(msg)
  end,
  TIME_MESSAGE = function(key, timeTable)
    timeString = locale.time.GetRemainDateToDateFormat(timeTable)
    AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, key, timeString))
  end,
  INVALID_NAME_POLICY = function(namePolicyType)
    local namePolicyInfo = X2Util:GetNamePolicyInfo(namePolicyType)
    local msg = F_TEXT.GetLimitInfoText(namePolicyInfo)
    AddMessageToSysMsgWindow(msg)
  end,
  SKILL_MSG = function(resultCode, param, skillType)
    AddMessageToSysMsgWindow(formatSkillMessage(resultCode, param, skillType))
  end,
  SKILL_DEBUG_MSG = function(resultCode, param, skillType)
    ChatLog(string.format("SKILL_DEBUG_MSG - resultCode:%s, param:%s, skillType:%s", tostring(resultCode), tostring(param), tostring(skillType)))
  end,
  QUEST_MSG = function(arg1, arg2)
    local textOut
    if arg2 ~= nil then
      textOut = locale.chatSystem.GetQuest(arg2)
    else
      textOut = arg1
    end
    AddMessageToSysMsgWindow(textOut)
  end,
  FORCE_ATTACK_CHANGED = function(id, isNewState)
    if not W_UNIT.IsMyUnitId(id) then
      return
    end
    if isNewState == true then
      AddMessageToSysMsgWindow(locale.chat.FORCE_ATTACK_ON)
    else
      AddMessageToSysMsgWindow(locale.chat.FORCE_ATTACK_OFF)
    end
    systemAlertWindow:Raise()
  end,
  TRADE_MADE = function()
    AddMessageToNotifyMessage(locale.trade.tradeAccomplishd)
  end,
  TRADE_CANCELED = function()
    AddMessageToNotifyMessage(locale.trade.canceled)
  end,
  TRADE_OTHER_LOCKED = function()
    AddMessageToNotifyMessage(locale.trade.otherLockedMsg)
  end,
  TRADE_OTHER_OK = function()
    AddMessageToNotifyMessage(locale.trade.tradeOtherOk)
  end,
  TRADE_UNLOCKED = function()
    AddMessageToNotifyMessage(locale.trade.unlockedMsg)
  end,
  GRADE_ENCHANT_RESULT = function(resultCode, itemLink, oldGrade, newGrade, breakRewardItemType, breakRewardItemCount, breakRewardByMail)
    ShowGradeEnchantAlarmMessage(resultCode, itemLink, oldGrade, newGrade, breakRewardItemType, breakRewardItemCount, breakRewardByMail)
  end,
  ITEM_CHANGE_MAPPING_RESULT = function(result, oldGrade, oldGearScore, itemLink, bonusRate)
    ShowAwakenAlarmMessage(result, oldGrade, oldGearScore, itemLink, bonusRate)
  end,
  UNIT_KILL_STREAK = function(killStreakInfo)
    if killStreakInfo.gameType ~= 1 then
      X2BattleField:EndKillStreakSound()
      return
    end
    if killStreakInfo.killerKillStreak == 1 and killStreakInfo.param1 ~= 1 then
      X2BattleField:EndKillStreakSound()
      return
    end
    local imgEventInfo = MakeImgEventInfo("UNIT_KILL_STREAK", ShowKillEffect, {
      killStreakInfo.killerKillStreak,
      killStreakInfo.killerName,
      killStreakInfo.victimName,
      killStreakInfo.param2
    })
    AddImgEventQueue(imgEventInfo)
  end,
  ITEM_SOCKETING_RESULT = function(resultCode, itemLink, socketItemType, install)
    if not install then
      return
    end
    local resultInfo = {enchantType = "socket"}
    ShowEtcEnchantAlarmMessage(resultCode, socketItemType, resultInfo)
  end,
  ITEM_SOCKET_UPGRADE = function(socketItemType)
    local resultInfo = {
      enchantType = "socket_upgrade"
    }
    ShowEtcEnchantAlarmMessage(1, socketItemType, resultInfo)
  end,
  ITEM_ENCHANT_MAGICAL_RESULT = function(resultCode, itemLink, gemItemType)
    if not resultCode then
      return
    end
    local resultInfo = {enchantType = "gem"}
    ShowEtcEnchantAlarmMessage(resultCode, gemItemType, resultInfo)
  end,
  ITEM_REFURBISHMENT_RESULT = function(result, itemLink, beforeScale, afterScale)
    ShowScaleAlarmMessage(result, itemLink, beforeScale, afterScale)
  end,
  ITEM_SMELTING_RESULT = function(resultCode, itemLink, smeltingItemType)
    if not resultCode then
      return
    end
    local resultInfo = {enchantType = "smelting", linkText = itemLink}
    ShowEtcEnchantAlarmMessage(resultCode, smeltingItemType, resultInfo)
  end,
  ABILITY_CHANGED = function(new, old)
    local isSwap = old and true or false
    local imgEventInfo = MakeImgEventInfo("ABILITY_CHANGED", ShowLearnAbilityEffect, {isSwap})
    AddImgEventQueue(imgEventInfo)
  end,
  LEVEL_CHANGED = function(_, stringId)
    if not W_UNIT.IsMyUnitId(stringId) then
      return
    end
    local myLevel = X2Unit:UnitLevel("player")
    local msg_Info = {
      msg = locale.levelChanged.GetLevelText(myLevel),
      type = "levelup"
    }
    local imgEventInfo = MakeImgEventInfo("LEVEL_CHANGED", ShowEffectMsgMessage, {msg_Info})
    AddImgEventQueue(imgEventInfo)
  end,
  HEIR_LEVEL_UP = function(myUnit)
    if false == myUnit then
      return
    end
    local myLevel = X2Unit:UnitLevel("player")
    local msg_Info = {
      msg = string.format("%s", X2Locale:LocalizeUiText(COMMON_TEXT, "heir_levelup", tostring(X2Unit:UnitHeirLevel("player")))),
      type = "heir_levelup"
    }
    local imgEventInfo = MakeImgEventInfo("LEVEL_CHANGED", ShowEffectMsgMessage, {msg_Info})
    AddImgEventQueue(imgEventInfo)
  end,
  SHOW_ADDED_ITEM = function(item, count, taskType)
    if taskType == ITEM_TASK_MAIL then
      return
    end
    local imgEventInfo = MakeImgEventInfo("SHOW_ADDED_ITEM", ShowAddedItemMsg, {item, count})
    AddImgEventQueue(imgEventInfo)
  end,
  COMPLETE_ACHIEVEMENT = function(achievementType)
    local featureSet = X2Player:GetFeatureSet()
    if not featureSet.achievement and not featureSet.todayAssignment then
      return
    end
    local info = X2Achievement:GetAchievementInfo(achievementType)
    if info == nil then
      return false
    end
    local messageInfo = MakeMessageInfo(info)
    AddAchievementMsgInfo(messageInfo)
    local imgEventInfo = MakeImgEventInfo("COMPLETE_ACHIEVEMENT", AddAchievementCompleteMsg, {messageInfo})
    AddImgEventQueue(imgEventInfo)
  end,
  UPDATE_TODAY_ASSIGNMENT = function(todayInfo)
    local featureSet = X2Player:GetFeatureSet()
    if not featureSet.todayAssignment or todayInfo == nil then
      return
    end
    if todayInfo.status ~= A_TODAY_STATUS.DONE or todayInfo.init == true then
      return
    end
    local messageInfo = MakeTodayAssignmetnMessageInfo(todayInfo)
    AddAchievementMsgInfo(messageInfo)
    local imgEventInfo = MakeImgEventInfo("UPDATE_TODAY_ASSIGNMENT", AddAchievementCompleteMsg, {messageInfo})
    AddImgEventQueue(imgEventInfo)
  end,
  EQUIP_SLOT_REINFORCE_MSG_LEVEL_EFFECT = function(equipSlot, level)
    local iconPath = TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_LEVEL_EFFECT_TEXT
    local iconKey = "slot_enchant_special_text"
    local titlePath = TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_LEVEL_EFFECT_ICON
    local titleKey = "slot_enchant_special"
    local text = GetUIText("equip_slot_reinforce_system_msg_change_level_effect", GetSlotText(equipSlot), tostring(level))
    local imgEventInfo = MakeImgEventInfo("EQUIP_SLOT_REINFORCE_LEVEL_EFFECT", ShowEquipSlotReinforceMsg, {
      text,
      iconPath,
      iconKey,
      titlePath,
      titleKey
    })
    AddImgEventQueue(imgEventInfo)
  end,
  EQUIP_SLOT_REINFORCE_MSG_LEVEL_UP = function(equipSlot, level)
    local iconPath = TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SLOT_LEVEL_UP_TEXT
    local iconKey = "slot_enchant_levelup_text"
    local titlePath = TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SLOT_LEVEL_UP_ICON
    local titleKey = "slot_enchant_levelup"
    local text = GetUIText("equip_slot_reinforce_system_msg_level_up", GetSlotText(equipSlot), tostring(level))
    local imgEventInfo = MakeImgEventInfo("EQUIP_SLOT_REINFORCE_SLOT_LEVEL_UP", ShowEquipSlotReinforceMsg, {
      text,
      iconPath,
      iconKey,
      titlePath,
      titleKey
    })
    AddImgEventQueue(imgEventInfo)
  end,
  EQUIP_SLOT_REINFORCE_MSG_SET_EFFECT = function(equipSlotAttribute, level)
    local iconPath = TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SET_EFFECT_TEXT
    local iconKey = "slot_enchant_set_text"
    local titlePath = TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SET_EFFECT_ICON
    local titleKey = "slot_enchant_set"
    local text = GetUIText("equip_slot_reinforce_system_msg_set_effect", GetAttibuteText(equipSlotAttribute), tostring(level))
    local imgEventInfo = MakeImgEventInfo("EQUIP_SLOT_REINFORCE_SET_EFFECT", ShowEquipSlotReinforceMsg, {
      text,
      iconPath,
      iconKey,
      titlePath,
      titleKey
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HPW_ZONE_STATE_WAR_END = function(zoneId, points)
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo == nil then
      return
    end
    local color = GetMsgZoneStateFontColor(zoneInfo)
    color = GetHexColorForString(Dec2Hex(color))
    local msg = string.format("%s%s", color, locale.honorPointWar.endWar(zoneInfo.zoneName))
    local subMsg = ""
    if points ~= 0 then
      local sign = points > 0 and "+" or ""
      local signColor = points >= 0 and FONT_COLOR_HEX.BLUE or FONT_COLOR_HEX.RED
      local strPoint = string.format("%s%s%d", signColor, sign, points)
      subMsg = locale.common.accumulate(zoneInfo.zoneName, GetUIText(COMMON_TEXT, "honor_point"), strPoint)
    end
    AddMessageToHonorPointWarWindow(msg, subMsg)
  end,
  HPW_ZONE_STATE_CHANGE = function(zoneId)
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo == nil or zoneInfo.isInstanceZone then
      return
    end
    if zoneInfo.isCurrentZone then
      ShowZoneStateAlarmWindow(zoneInfo)
      curStateZoneId = zoneId
    end
  end,
  ENTER_ANOTHER_ZONEGROUP = function(zoneId)
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo == nil or zoneInfo.isInstanceZone then
      return
    end
    if zoneInfo.isCurrentZone then
      ShowZoneStateAlarmWindow(zoneInfo)
      curStateZoneId = zoneId
    end
  end,
  LEFT_LOADING = function()
    local zoneId = X2Unit:GetCurrentZoneGroup()
    if zoneId ~= 0 and zoneId ~= curStateZoneId then
      local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
      if zoneInfo == nil or zoneInfo.isInstanceZone then
        return
      end
      if zoneInfo.isCurrentZone then
        ShowZoneStateAlarmWindow(zoneInfo)
        curStateZoneId = zoneId
      end
    end
  end,
  COMPLETE_CRAFT_ORDER = function(info)
    local imgEventInfo = MakeImgEventInfo("COMPLETE_CRAFT_ORDER", ShowCraftOrderMsg, {info})
    AddImgEventQueue(imgEventInfo)
  end,
  GRADE_ENCHANT_BROADCAST = function(characterName, resultCode, itemLink, oldGrade, newGrade)
    local imgEventInfo = MakeImgEventInfo("GRADE_ENCHANT_BROADCAST", ShowGradeEnchantBroadcastAlarmMessage, {
      characterName,
      resultCode,
      itemLink,
      oldGrade,
      newGrade
    })
    AddImgEventQueue(imgEventInfo)
  end,
  SCALE_ENCHANT_BROADCAST = function(characterName, resultCode, itemLink, oldScale, newScale)
    local imgEventInfo = MakeImgEventInfo("SCALE_ENCHANT_BROADCAST", ShowScaleEnchantBroadcastAlarmMessage, {
      characterName,
      resultCode,
      itemLink,
      oldScale,
      newScale
    })
    AddImgEventQueue(imgEventInfo)
  end,
  TOWER_DEF_MSG = function(towerDefInfo)
    if string.len(towerDefInfo.msg) == 0 then
      return
    end
    local myZoneGroup = X2Unit:GetCurrentZoneGroup()
    local zoneGroup = towerDefInfo.zoneGroup
    local text = string.format("%s%s", towerDefInfo.color, towerDefInfo.msg)
    local title = string.format("%s%s", towerDefInfo.color, towerDefInfo.titleMsg)
    local step = towerDefInfo.step
    local iconName = string.format("%s_%s", towerDefInfo.iconKey, towerDefInfo.step)
    if myZoneGroup ~= zoneGroup and zoneGroup == 78 and step ~= "start" then
      return
    end
    local imgEventInfo = MakeImgEventInfo("TOWER_DEFENSE_MSG", ShowCustomIconMeesage, {
      text,
      title,
      TEXTURE_PATH.TOWER_DEFENSE_ICON,
      iconName
    })
    AddImgEventQueue(imgEventInfo)
  end,
  ZONEGROUP_STATE_WINNER = function(zoneGroup, winnerName)
    if string.len(winnerName) == 0 then
      return
    end
    local title = string.format("|cFF97D5F9[%s]", winnerName)
    local text = string.format("|cFF97D5F9%s", GetCommonText("conquest_end_msg"))
    local iconName = "occupation_end"
    local imgEventInfo = MakeImgEventInfo("ZONEGROUP_STATE_WINNER", ShowCustomIconMeesage, {
      text,
      title,
      TEXTURE_PATH.TOWER_DEFENSE_ICON,
      iconName
    })
    AddImgEventQueue(imgEventInfo)
  end,
  EVENT_SCHEDULE_START = function(msg)
    if msg == nil or msg == "" then
      return
    end
    local imgEventInfo = MakeImgEventInfo("EVENT_SCHEDULE_START", ShowDayEventAlarm, {msg})
    AddImgEventQueue(imgEventInfo)
  end,
  EVENT_SCHEDULE_STOP = function(msg)
    if msg == nil or msg == "" then
      return
    end
    local imgEventInfo = MakeImgEventInfo("EVENT_SCHEDULE_STOP", ShowDayEventAlarm, {msg})
    AddImgEventQueue(imgEventInfo)
  end,
  RANK_ALARM_MSG = function(rankType, msg)
    if rankType ~= 3 and rankType ~= 4 then
      return
    end
    local imgEventInfo = MakeImgEventInfo("RANK_ALARM_MSG", ShowRankingAlarmMessage, {msg})
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_SEASON_OFF = function()
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_season_off_announce_title")
    local desc = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_season_off_announce_desc")
    local imgEventInfo = MakeImgEventInfo("HERO_SEASON_OFF", ShowHeroMessage, {
      "HERO_SEASON_OFF",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_CANDIDATES_ANNOUNCED = function()
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidates_announce_title")
    local desc = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidates_announce_desc")
    local imgEventInfo = MakeImgEventInfo("HERO_CANDIDATES_ANNOUNCED", ShowHeroMessage, {
      "HERO_CANDIDATES_ANNOUNCED",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_CANDIDATE_NOTI = function()
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidate_noti_title")
    local desc = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_candidate_noti_desc")
    local imgEventInfo = MakeImgEventInfo("HERO_CANDIDATE_NOTI", ShowHeroMessage, {
      "HERO_CANDIDATE_NOTI",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_ELECTION_RESULT = function()
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_announce_title")
    local desc = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_announce_desc")
    local imgEventInfo = MakeImgEventInfo("HERO_ELECTION_RESULT", ShowHeroMessage, {
      "HERO_ELECTION_RESULT",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_NOTI = function()
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_noti_title")
    local factionName = X2Hero:GetClientFactionName()
    local desc = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_noti_desc", factionName)
    local imgEventInfo = MakeImgEventInfo("HERO_NOTI", ShowHeroMessage, {
      "HERO_NOTI",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_ELECTION_DAY_ALERT = function(title, desc)
    local imgEventInfo = MakeImgEventInfo("HERO_ELECTION_DAY_ALERT", ShowHeroMessage, {
      "HERO_ELECTION_DAY_ALERT",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  HERO_ELECTION_VOTED = function()
    local msg = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_vote_noti")
    AddMessageToSysMsgWindow(msg)
  end,
  REPUTATION_GIVEN = function()
    local msg = X2Locale:LocalizeUiText(COMMON_TEXT, "reputation_noti")
    AddMessageToSysMsgWindow(msg)
  end,
  WORLD_MESSAGE = function(msg, iconKey, sextants, info)
    keyWord = "@coordinates"
    found = string.find(msg, keyWord)
    if found ~= nil then
      local long = sextants.longitude
      local deg_long = sextants.deg_long
      local min_long = sextants.min_long
      local sec_long = sextants.sec_long
      local lat = sextants.latitude
      local deg_lat = sextants.deg_lat
      local min_lat = sextants.min_lat
      local sec_lat = sextants.sec_lat
      sextStr = locale.chatSystem.ShowSextantPos(long, deg_long, min_long, sec_long, lat, deg_lat, min_lat, sec_lat)
      msg = string.gsub(msg, keyWord, sextStr)
    end
    keyWord = "@faction"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.factionName)
    end
    keyWord = "@motherfaction"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.motherFactionName)
    end
    keyWord = "@name"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.name)
    end
    keyWord = "@trgfaction"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.trgFactionName)
    end
    keyWord = "@trgmotherfaction"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.trgMotherFactionName)
    end
    keyWord = "@trgname"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.trgName)
    end
    keyWord = "@zonegroupname"
    found = string.find(msg, keyWord)
    if found ~= nil then
      msg = string.gsub(msg, keyWord, info.zoneGroupName)
    end
    if iconKey ~= nil and string.len(iconKey) ~= 0 then
      if string.len(msg) == 0 then
        return
      end
      local title = ""
      local imgEventInfo = MakeImgEventInfo("TOWER_DEFENSE_MSG", ShowCustomIconMeesage, {
        msg,
        title,
        TEXTURE_PATH.TOWER_DEFENSE_ICON,
        iconKey
      })
      AddImgEventQueue(imgEventInfo)
    else
      AddMessageToSysMsgWindow(msg)
    end
  end,
  CHAT_MESSAGE = function(channel, unit, relation, name, message, speakerInChatBound, specifyName, factionName, trialPosition, worldName)
    if channel ~= CHAT_RAID_COMMAND then
      return
    end
    local copyOrignalName = name
    name = string.format("|k%s,%d;", name, relation)
    local message = "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raidCommand", name) .. "] " .. message
    AddMessageToRaidCommandWindow(message)
  end,
  HOUSE_CANCEL_SELL_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_cancel_sell_success", houseName)
    AddMessageToNotifyMessage(str)
  end,
  HOUSE_CANCEL_SELL_FAIL = function()
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_cancel_sell_fail")
    AddMessageToNotifyMessage(str)
  end,
  HOUSE_SET_SELL_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_set_sell_success", houseName)
    AddMessageToNotifyMessage(str)
  end,
  HOUSE_SET_SELL_FAIL = function()
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_set_sell_fail")
    AddMessageToNotifyMessage(str)
  end,
  HOUSE_BUY_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_buy_success", houseName)
    AddMessageToNotifyMessage(str)
  end,
  HOUSE_BUY_FAIL = function()
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_buy_fail")
    AddMessageToNotifyMessage(str)
  end,
  HOUSE_SALE_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_sale_success", houseName)
    AddMessageToNotifyMessage(str)
  end,
  ACTABILITY_EXPERT_EXPANDED = function()
    local str = X2Locale:LocalizeUiText(COMMON_TEXT, "actability_expert_expanded")
    AddMessageToNotifyMessage(str)
  end,
  ABILITY_SET_CHANGED = function(responseType)
    if X2Player:GetFeatureSet().useSavedAbilities == false then
      return
    end
    if responseType <= 0 then
      AddMessageToNotifyMessage(GetCommonText("lack_of_saved_job_slot"))
      return
    end
    local messageKeys = {
      "saved_job",
      "changed_job",
      "deleted_job"
    }
    AddMessageToNotifyMessage(GetCommonText(messageKeys[responseType]))
  end,
  ABILITY_SET_USABLE_SLOT_COUNT_CHANGED = function(responseType)
    if X2Player:GetFeatureSet().useSavedAbilities == false then
      return
    end
    AddMessageToNotifyMessage(GetCommonText("added_job_slot"))
  end,
  SECOND_PASSWORD_CHECK_OVER_FAILED = function()
    local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
    local msg = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "account_lock", tostring(maxFailCnt))
    AddMessageToSysMsgWindow(msg)
  end,
  SECOND_PASSWORD_CHECK_COMPLETED = function(success)
    if success then
      return
    end
    local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
    local msg
    if maxFailCnt > 0 then
      msg = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_fail_with_retry", tostring(curFailCnt), tostring(maxFailCnt))
    else
      msg = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_fail")
    end
    AddMessageToSysMsgWindow(msg)
  end,
  SECOND_PASSWORD_CLEAR_COMPLETED = function(success)
    if success then
      return
    end
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_fail"))
  end,
  CRAFT_FAILED = function(itemLinkText)
    local failedText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "failed_craft_alert", itemLinkText)
    AddMessageToSysMsgWindow(failedText)
  end,
  UCC_IMPRINT_SUCCEEDED = function()
    AddMessageToNotifyMessage(X2Locale:LocalizeUiText(UCC_TEXT, "imprint_successed"))
  end,
  BUILD_AREA_MSG = function(factionName)
    local tout = ""
    if factionName ~= nil then
      tout = string.format("%s %s", factionName, X2Locale:LocalizeUiText(HOUSING_TEXT, "buildAreaMsg"))
    else
      tout = X2Locale:LocalizeUiText(HOUSING_TEXT, "buildAreaMsg")
    end
    AddMessageToNotifyMessage(tout)
  end,
  SELL_SPECIALTY = function(text)
    AddMessageToNotifyMessage(text)
  end,
  NOTICE_MESSAGE = function(noticeType, color, visibleTime, message, name)
    if noticeType == 1 then
      return
    end
    local gmName = ""
    if name ~= "" then
      gmName = name .. ": "
    end
    if noticeType == 2 then
      AddMessageToNoticeWindow("|c" .. color .. gmName .. message, visibleTime)
    elseif noticeType == 3 then
      AddMessageToNoticeWindow("|c" .. color .. gmName .. message, visibleTime)
    end
  end,
  NOTIFY_AUTH_NOTICE_MESSAGE = function(message, visibleTime, needCountdown)
    AddMessageToNoticeWindow(message, visibleTime * 1000, needCountdown)
  end,
  DOODAD_PHASE_MSG = function(text)
    AddMessageToQuestNotifyMessage(text)
  end,
  CHAT_MSG_ALARM = function(text)
    AddMessageToQuestNotifyMessage(text)
  end,
  EXPEDITION_LEVEL_UP = function(level)
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_levelup_noti")
    local desc = X2Locale:LocalizeUiText(COMMON_TEXT, "level")
    if level ~= nil then
      desc = tostring(level) .. desc
    else
      desc = tostring(3) .. desc
    end
    local imgEventInfo = MakeImgEventInfo("EXPEDITION_LEVEL_UP", ShowExpeditionLevelUpMessage, {
      "EXPEDITION_LEVEL_UP",
      title,
      desc
    })
    AddImgEventQueue(imgEventInfo)
  end,
  FAMILY_LEVEL_UP = function(levelName)
    local imgEventInfo = MakeImgEventInfo("FAMILY_LEVEL_UP", ShowFamilyLevelUpMessage, {levelName})
    AddImgEventQueue(imgEventInfo)
  end,
  EXPEDITION_APPLICANT_ACCEPT = function(expeditionName)
    local imgEventInfo = MakeImgEventInfo("EXPEDITION_APPLICANT_ACCEPT", ShowExpeditionAcceptMessage, {expeditionName})
    AddImgEventQueue(imgEventInfo)
  end,
  EXPEDITION_APPLICANT_REJECT = function(expeditionName)
    local imgEventInfo = MakeImgEventInfo("EXPEDITION_APPLICANT_REJECT", ShowExpeditionRejectMessage, {expeditionName})
    AddImgEventQueue(imgEventInfo)
  end,
  DOODAD_PHASE_UI_MSG = function(phaseMsgInfo)
    if string.len(phaseMsgInfo.msg) == 0 then
      return
    end
    local text = string.format("%s%s", phaseMsgInfo.color, phaseMsgInfo.msg)
    local title = string.format("%s%s", phaseMsgInfo.titleColor, phaseMsgInfo.titleMsg)
    local iconName = phaseMsgInfo.iconKey
    local imgEventInfo = MakeImgEventInfo("DOODAD_PHASE_UI_MSG", ShowCustomIconMeesage, {
      text,
      title,
      TEXTURE_PATH.TOWER_DEFENSE_ICON,
      iconName
    })
    AddImgEventQueue(imgEventInfo)
  end,
  NUONS_ARROW_UI_MSG = function(nuonsMsgInfo)
    local text = GetUIText(COMMON_TEXT, "nuons_arrow_center_message_body", nuonsMsgInfo.shooter, nuonsMsgInfo.zoneGroupName, nuonsMsgInfo.phase)
    local title = GetUIText(COMMON_TEXT, "nuons_arrow_center_message_title")
    local iconName = "resident_attack"
    local imgEventInfo = MakeImgEventInfo("NUONS_ARROW_UI_MSG", ShowCustomIconMeesage, {
      text,
      title,
      TEXTURE_PATH.TOWER_DEFENSE_ICON,
      iconName
    })
    AddImgEventQueue(imgEventInfo)
  end,
  LOOT_PACK_ITEM_BROADCAST = function(characterName, useItemLink, resultItemLink)
    local imgEventInfo = MakeImgEventInfo("LOOT_PACK_ITEM_BROADCAST", ShowLootPackItemBroadcastAlarmMessage, {
      characterName,
      useItemLink,
      resultItemLink
    })
    AddImgEventQueue(imgEventInfo)
  end,
  BAG_EXPANDED = function()
    AddMessageToNotifyMessage(GetUIText(COMMON_TEXT, "bag_expanded", tostring(X2Bag:Capacity())))
  end,
  BANK_EXPANDED = function()
    AddMessageToNotifyMessage(GetUIText(COMMON_TEXT, "bank_expanded", tostring(X2Bank:Capacity())))
  end,
  INSTANCE_ENTERABLE_MSG = function(info)
    local imgEventInfo = MakeImgEventInfo("INSTANCE_ENTERABLE_MSG", ShowCustomIconMeesage, {
      info.content,
      info.title,
      TEXTURE_PATH.TOWER_DEFENSE_ICON,
      info.iconKey
    })
    AddImgEventQueue(imgEventInfo)
  end,
  INSTANT_GAME_START_POINT_RETURN_MSG = function(remainSec)
    local msg = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "start_point_return_time", tostring(remainSec))
    AddMessageToNotifyMessage(msg)
  end,
  INSTANT_GAME_BATTLE_SHIP_SELECTED_MSG = function(shipName)
    local msg = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "battle_ship_selected_msg", shipName)
    AddMessageToNotifyMessage(msg)
  end,
  BLESS_UTHSTIN_MESSAGE = function(messageType)
    local messageKeys = {
      "bless_uthstin_message_expand_page_done",
      "bless_uthstin_message_init_done",
      "bless_uthstin_message_copy_done",
      "bless_uthstin_message_extend_max_stats_done",
      "bless_uthstin_message_activate_page_done"
    }
    AddMessageToNotifyMessage(GetCommonText(messageKeys[messageType]))
  end,
  OPTIMIZATION_BUTTON_MESSAGE = function(messageType)
    local messageKeys = {
      "system_msg_optimization_on",
      "system_msg_optimization_off"
    }
    if messageType > 0 and messageType <= #messageKeys then
      AddMessageToNotifyMessage(GetCommonText(messageKeys[messageType]))
    end
  end,
  INDUN_ROUND_START = function(round, isBossRound)
    if round <= 0 then
      return
    end
    ForceHideIndunRoundEndMessage()
    ShowIndunRoundStartMessage(round, isBossRound)
  end,
  INDUN_ROUND_END = function(success, round, isBossRound, lastRound)
    if round <= 0 then
      return
    end
    ForceHideIndunRoundStartMessage()
    ShowIndunRoundEndMessage(success, round, isBossRound, lastRound)
  end,
  FACTION_RELATION_CHANGED = function(isHostile, f1Name, f2Name)
    local imgEventInfo = MakeImgEventInfo("FACTION_RELATION_CHANGED", ShowFactionRelationChangeMessage, {
      isHostile,
      f1Name,
      f2Name
    })
    AddImgEventQueue(imgEventInfo)
  end
}
centerMessageEventListener:SetHandler("OnEvent", function(this, event, ...)
  centerMessageEvents[event](...)
end)
RegistUIEvent(centerMessageEventListener, centerMessageEvents)
function systemLayerParent:OnScale()
  raidCommandMsgWindow:RemoveAllAnchors()
  raidCommandMsgWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(285))
  honorPointWarWnd:RemoveAllAnchors()
  honorPointWarWnd:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(80))
  effectMsgWindow:RemoveAllAnchors()
  effectMsgWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(35))
  addedItemWindow:RemoveAllAnchors()
  addedItemWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(80))
  systemAlertWindow:RemoveAllAnchors()
  systemAlertWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(180))
  systemAlertWindow:SetHeight(GetMessageWidgetHeight(systemAlertWindow))
  noticeWindow:RemoveAllAnchors()
  noticeWindow:AddAnchor("TOP", "UIParent", "TOP", 0, F_LAYOUT.CalcDontApplyUIScale(235))
  noticeWindow:SetHeight(GetMessageWidgetHeight(noticeWindow))
  quest_notifyWindow:RemoveAllAnchors()
  quest_notifyWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(250))
  quest_notifyWindow:SetHeight(GetMessageWidgetHeight(quest_notifyWindow))
  siegeSystemAlarmWindow:RemoveAllAnchors()
  siegeSystemAlarmWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(60))
  notifyWindow:RemoveAllAnchors()
  notifyWindow:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(170))
  notifyWindow:SetHeight(GetMessageWidgetHeight(notifyWindow))
  subZoneMsgWindow:RemoveAllAnchors()
  subZoneMsgWindow:AddAnchor("BOTTOM", "UIParent", "BOTTOM", 0, F_LAYOUT.CalcDontApplyUIScale(-200))
  lootPackItemBroadcastAlarm:RemoveAllAnchors()
  lootPackItemBroadcastAlarm:AddAnchor("TOP", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(60))
end
systemLayerParent:SetHandler("OnScale", systemLayerParent.OnScale)
