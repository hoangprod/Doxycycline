local combatMessageList = {
  MELEE_DAMAGE = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "melee_damage"),
  MELEE_MISSED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "melee_missed"),
  SPELL_DAMAGE = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_damage"),
  SPELL_MISSED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_missed"),
  SPELL_HEALED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_healed"),
  SPELL_ENERGIZE = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_energize"),
  SPELL_DRAIN = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_drain"),
  SPELL_LEECH = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_leech"),
  SPELL_CAST_START = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_cast_start"),
  SPELL_CAST_SUCCESS = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_cast_success"),
  SPELL_CAST_FAILED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_cast_failed"),
  SPELL_AURA_APPLIED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_aura_applied"),
  SPELL_AURA_REMOVED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "spell_aura_removed"),
  ENVIRONMENTAL_DAMAGE = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "environmental_damage"),
  ENVIRONMENTAL_HEALED = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "environmental_healed"),
  ENVIRONMENTAL_ENERGIZE = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "environmental_energize"),
  ENVIRONMENTAL_DRAIN = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "environmental_drain"),
  ENVIRONMENTAL_LEECH = X2Locale:LocalizeUiText(COMBAT_MESSAGE_TEXT, "environmental_leech")
}
local MakeTimeString = function(time)
  local SECOND = 1
  local MINUTE = SECOND * 60
  local HOUR = MINUTE * 60
  local DAY = HOUR * 24
  local MONTH = DAY * 30
  local YEAR = MONTH * 12
  local dateFormat = {}
  dateFormat.hour = math.floor(time / HOUR)
  if dateFormat.hour > 0 then
    time = time - dateFormat.hour * HOUR or time
  end
  dateFormat.minute = math.floor(time / MINUTE)
  if 0 < dateFormat.minute then
    time = time - dateFormat.minute * MINUTE or time
  end
  dateFormat.second = time
  local timeStr = ""
  if 24 < dateFormat.hour then
    local day = math.floor(dateFormat.hour / 24)
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "day", tostring(day))
    dateFormat.hour = dateFormat.hour % 24
  end
  if dateFormat.hour > 0 then
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "hour", tostring(dateFormat.hour))
  end
  if 0 < dateFormat.minute then
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "minute", tostring(dateFormat.minute))
  end
  if 0 < dateFormat.second then
    timeStr = timeStr .. X2Locale:LocalizeUiText(PERIOD_TIME_TEXT, "second", tostring(dateFormat.second))
  end
  return timeStr
end
local GetCommonText = function(key, a, b, c)
  if a and b and c then
    return X2Locale:LocalizeUiText(COMMON_TEXT, key, tostring(a), tostring(b), tostring(c))
  end
  if a and b then
    return X2Locale:LocalizeUiText(COMMON_TEXT, key, tostring(a), tostring(b))
  end
  if a then
    return X2Locale:LocalizeUiText(COMMON_TEXT, key, tostring(a))
  end
  return X2Locale:LocalizeUiText(COMMON_TEXT, key)
end
local ShowSextantPos = function(long, deg_long, min_long, sec_long, lat, deg_lat, min_lat, sec_lat)
  return string.format("%s%s %s\194\176|r%s' %s\", %s%s %s\194\176|r%s' %s\"", F_COLOR.GetColor("original_dark_orange", true), tostring(long), tostring(deg_long), tostring(min_long), tostring(sec_long), F_COLOR.GetColor("original_dark_orange", true), tostring(lat), tostring(deg_lat), tostring(min_lat), tostring(sec_lat))
end
local GetZoneState = function(state)
  if state < HPWS_BATTLE then
    local step = state + 1
    local title = X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step" .. step)
    return string.format("%s(%s)", title, X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_dangerous_step", tostring(step)))
  elseif state == HPWS_BATTLE then
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_conflict")
  elseif state == HPWS_WAR then
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_war")
  elseif state == HPWS_PEACE then
    return X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "state_peace")
  end
end
local GetKillMsg = function(msgInfo)
  local ruleMode = msgInfo.ruleMode
  local killerCorps = msgInfo.killerCorps
  local killer = msgInfo.killer
  local victimCorps = msgInfo.victimCorps
  local victim = msgInfo.victim
  local killStreak = tostring(msgInfo.killerKillstreak)
  if killer == "" or victim == "" then
    return
  end
  if killer == victim then
    return
  end
  if ruleMode == 2 then
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "kill_simple_msg", killer, victim, killStreak)
  end
  if killerCorps == victimCorps then
    key = "kill_same_team_msg"
  elseif killer == X2Unit:UnitName("player") then
    return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "killed_by_me_msg", victim, killStreak)
  else
    key = "kill_msg"
  end
  return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, key, killerCorps, killer, victimCorps, victim, killStreak)
end
local GetRemainDate = function(year, month, day, hour, minute, second, filter)
  filter = filter or DEFAULT_FORMAT_FILTER
  local function Get(value, msg, key)
    if value <= 0 then
      filter = math.floor(filter % key)
      return ""
    end
    local x = math.floor(filter / key)
    if x ~= 1 then
      return ""
    end
    filter = filter - key
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
end
local CreateEmptyWindow = function(id, parent, useTitleBar)
  parent = parent or "UIParent"
  local window = UIParent:CreateWidget("window", id, parent)
  function window:EnableUIAnimation()
    SetttingUIAnimation(self)
    self:ReleaseHandler("OnShow")
    function self:OnShow()
      self:SetStartAnimation(true, true)
      if self.ShowProc ~= nil then
        self:ShowProc()
      end
    end
    self:SetHandler("OnShow", self.OnShow)
  end
  function window:OnMouseDown()
    return true
  end
  window:SetHandler("OnMouseDown", window.OnMouseDown)
  function window:OnMouseUp()
  end
  window:SetHandler("OnMouseUp", window.OnMouseUp)
  function window:OnShow()
    if self.ShowProc ~= nil then
      self:ShowProc()
    end
  end
  window:SetHandler("OnShow", window.OnShow)
  return window
end
local GetFullChannelName = function(channel, name)
  if channel == CHAT_ZONE then
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_zone") .. ". " .. name
  elseif channel == CHAT_TRADE then
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_trade") .. ". " .. name
  elseif channel == CHAT_FIND_PARTY then
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_find_party") .. ". " .. name
  elseif channel == CHAT_RACE then
    return X2Locale:LocalizeUiText(CHAT_FILTERING, "chat_normal_group1_alliance") .. ". " .. name
  elseif channel == CHAT_FACTION then
    return X2Locale:LocalizeUiText(CHARACTER_SUBTITLE_TEXT, "faction") .. ". " .. name
  elseif channel == CHAT_TRIAL then
    return X2Locale:LocalizeUiText(CHAT_LIST_TEXT, "trial") .. ". " .. name
  else
    return name
  end
end
local GetShortChannelName = function(channel)
  if channel == CHAT_ZONE then
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_zone")
  elseif channel == CHAT_TRADE then
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_trade")
  elseif channel == CHAT_FIND_PARTY then
    return X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_find_party")
  else
    return X2Chat:GetChatChannelName(channel) or "BAD CHANNEL"
  end
end
local function ShowChannelEnterMsg(channel, name)
  local message = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "enter_channel", IStr(channel), GetFullChannelName(channel, name))
  X2Chat:DispatchChatMessage(CMF_CHANNEL_INFO, message)
end
local MoneyChangedEventChatMsg = function(change, changeStr, taskType, tradeOtherName)
  if change == 0 then
    return
  end
  local isPositiveNumber = true
  if change < 0 then
    isPositiveNumber = false
    changeStr = RemoveNonDigit(changeStr)
  end
  local myMoneyStr = X2Util:GetMyMoneyString()
  local currentMoneyStr = MakeMoneyText(myMoneyStr)
  local hasMoney = myMoneyStr ~= "0"
  local textOut = ""
  local finalCurrentMoneyStr = ""
  if myMoneyStr == "0" then
    finalCurrentMoneyStr = currentMoneyStr
  else
    finalCurrentMoneyStr = X2Locale:LocalizeUiText(MONEY_TEXT, "current_money", currentMoneyStr)
  end
  if taskType == nil or taskType == ITEM_TASK_INVALID then
    if isPositiveNumber then
      textOut = X2Locale:LocalizeUiText(MONEY_TEXT, "gain_money", MakeMoneyText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")"
    elseif not hasMoney then
      textOut = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_money", MakeMoneyText(changeStr)) .. "(" .. X2Locale:LocalizeUiText(MONEY_TEXT, "no_money") .. ")"
    else
      textOut = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_money", MakeMoneyText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")"
    end
  elseif taskType == ITEM_TASK_HOUSE_CREATION then
    textOut = X2Locale:LocalizeUiText(MONEY_TEXT, "paid_house_tax", MakeMoneyText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")"
  elseif taskType == ITEM_TASK_TRADE then
    if isPositiveNumber then
      textOut = X2Locale:LocalizeUiText(MONEY_TEXT, "trade_gain_money", tradeOtherName, MakeMoneyText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")"
    else
      textOut = X2Locale:LocalizeUiText(MONEY_TEXT, "trade_lost_money", tradeOtherName, MakeMoneyText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")"
    end
  end
  X2Chat:DispatchChatMessage(CMF_SELF_MONEY_CHANGED, textOut)
end
local HonorPointChangedEventChatMsg = function(amount, amountStr, isCombatInHonorPointWar)
  if amount == 0 then
    return
  end
  local honor_name = X2Locale:LocalizeUiText(COMMON_TEXT, "honor_point")
  local msg = ""
  local finalCurrentHonorStr = string.format("(%s)", X2Locale:LocalizeUiText(MONEY_TEXT, "current_point", honor_name, CommaStr(X2Player:GetGamePoints().honorPointStr)))
  if amount > 0 then
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "gain_point", honor_name, CommaStr(amountStr))
  elseif isCombatInHonorPointWar then
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_honor_in_war_state", CommaStr(amountStr))
  else
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_point", honor_name, CommaStr(amountStr))
  end
  local textOut = string.format("%s %s", msg, finalCurrentHonorStr)
  X2Chat:DispatchChatMessage(CMF_SELF_HONOR_POINT_CHANGED, textOut)
end
local LivingPointChangedEventChatMsg = function(amount, amountStr)
  if amount == 0 then
    return
  end
  local living_point = X2Locale:LocalizeUiText(MONEY_TEXT, "living_point")
  local msg = ""
  local finalCurrentLivingPointStr = string.format("(%s)", X2Locale:LocalizeUiText(MONEY_TEXT, "current_point", living_point, CommaStr(X2Player:GetGamePoints().livingPointStr)))
  if amount > 0 then
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "gain_point", living_point, CommaStr(amountStr))
  else
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_point", living_point, CommaStr(amountStr))
  end
  local textOut = string.format("%s %s", msg, finalCurrentLivingPointStr)
  X2Chat:DispatchChatMessage(CMF_SELF_LIVING_POINT_CHANGED, textOut)
end
local ContributionPointChangedEventChatMsg = function(amount, amountStr)
  if amount == 0 then
    return
  end
  local contribution_point = X2Locale:LocalizeUiText(MONEY_TEXT, "contribution_point")
  local msg = ""
  local finalCurrentContributionPointStr = string.format("(%s)", X2Locale:LocalizeUiText(MONEY_TEXT, "current_point", contribution_point, CommaStr(X2Player:GetGamePoints().contributionPointStr)))
  if amount > 0 then
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "gain_point", contribution_point, CommaStr(amountStr))
  else
    msg = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_point", contribution_point, CommaStr(amountStr))
  end
  local textOut = string.format("%s %s", msg, finalCurrentContributionPointStr)
  X2Chat:DispatchChatMessage(CMF_SELF_CONTRIBUTION_POINT_CHANGED, textOut)
end
local LeadershipPointChangedEventChatMsg = function(amount, amountStr)
  if amount == 0 then
    return
  end
  local textOut = string.format("%s", X2Locale:LocalizeUiText(MONEY_TEXT, "gain_leadership_point", CommaStr(amountStr)))
  X2Chat:DispatchChatMessage(CMF_SELF_LEADERSHIP_POINT_CHANGED, textOut)
end
local ExpeditionExpChangedEventChatMsg = function(amount, amountStr)
  if amount == 0 then
    return
  end
  local textOut = X2Locale:LocalizeUiText(UTIL_TEXT, "add_expedition_exp_str", CommaStr(amountStr))
  X2Chat:DispatchChatMessage(CMF_EXPEDITION, textOut)
end
local FamilyExpChangedEventChatMsg = function(amount)
  local textOut = ""
  if amount > 0 then
    textOut = X2Locale:LocalizeUiText(COMMON_TEXT, "add_family_exp", tostring(amount))
  elseif amount < 0 then
    textOut = X2Locale:LocalizeUiText(COMMON_TEXT, "minus_family_exp", tostring(-amount))
  else
    return
  end
  X2Chat:DispatchChatMessage(CMF_FAMILY, textOut)
end
local HeroRankingSeasonUpdated = function()
  local textOut = string.format("%s", X2Locale:LocalizeUiText(HERO_TEXT, "season_off_chat_msg"))
  X2Chat:DispatchChatMessage(CMF_HERO_SEASON_UPDATED, textOut)
end
local AAPointChangedEventChatMsg = function(change, changeStr, taskType, tradeOtherName)
  if change == 0 then
    return
  end
  local isPositiveNumber = true
  if change < 0 then
    isPositiveNumber = false
    changeStr = RemoveNonDigit(changeStr)
  end
  local myAAPointStr = X2Util:GetMyAAPointString()
  local currentAAPointStr = MakeAAPointText(myAAPointStr)
  local hasAAPoint = myAAPointStr ~= "0"
  local textOut = {}
  local finalCurrentMoneyStr = ""
  if myAAPointStr == "0" then
    finalCurrentMoneyStr = currentAAPointStr
  else
    finalCurrentMoneyStr = X2Locale:LocalizeUiText(MONEY_TEXT, "current_aa_point", currentAAPointStr)
  end
  if taskType == nil or taskType == ITEM_TASK_INVALID then
    if isPositiveNumber then
      table.insert(textOut, X2Locale:LocalizeUiText(MONEY_TEXT, "gain_aa_point", MakeAAPointText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")")
    elseif not hasAAPoint then
      table.insert(textOut, X2Locale:LocalizeUiText(MONEY_TEXT, "lost_aa_point", MakeAAPointText(changeStr)) .. "(" .. X2Locale:LocalizeUiText(MONEY_TEXT, "no_money") .. ")")
    else
      table.insert(textOut, X2Locale:LocalizeUiText(MONEY_TEXT, "lost_aa_point", MakeAAPointText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")")
    end
  elseif taskType == ITEM_TASK_HOUSE_CREATION then
    table.insert(X2Locale:LocalizeUiText(MONEY_TEXT, "paid_house_tax_by_aa_point", MakeAAPointText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")")
  elseif taskType == ITEM_TASK_TRADE then
    if isPositiveNumber then
      table.insert(textOut, X2Locale:LocalizeUiText(MONEY_TEXT, "trade_gain_aa_point", tradeOtherName, MakeAAPointText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")")
    else
      local fee = X2Trade:GetLastAAPointExchangeFee()
      if fee == "0" then
        table.insert(textOut, X2Locale:LocalizeUiText(MONEY_TEXT, "trade_lost_aa_point", tradeOtherName, MakeAAPointText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")")
      else
        local textOut2 = X2Locale:LocalizeUiText(MONEY_TEXT, "lost_aa_point", MakeAAPointText(fee)) .. "(" .. finalCurrentMoneyStr .. ")"
        changeStr = X2Util:StrNumericSub(changeStr, fee)
        myAAPointStr = X2Util:StrNumericAdd(myAAPointStr, fee)
        currentAAPointStr = MakeAAPointText(myAAPointStr)
        finalCurrentMoneyStr = X2Locale:LocalizeUiText(MONEY_TEXT, "current_aa_point", currentAAPointStr)
        table.insert(textOut, X2Locale:LocalizeUiText(MONEY_TEXT, "trade_lost_aa_point", tradeOtherName, MakeAAPointText(changeStr)) .. "(" .. finalCurrentMoneyStr .. ")")
        table.insert(textOut, textOut2)
      end
    end
  end
  for i = 1, #textOut do
    X2Chat:DispatchChatMessage(CMF_SELF_MONEY_CHANGED, textOut[i])
  end
end
local GradeEnchantResultEventChatMsg = function(resultCode, itemLink)
  local strTable = {
    X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_break"),
    X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_downgrade"),
    X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_fail"),
    X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_fail"),
    X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_success"),
    X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_great_success")
  }
  local str = ""
  if resultCode ~= IGER_BREAK then
    str = string.format("%s: %s|r", strTable[resultCode + 1], itemLink)
  else
    str = strTable[resultCode + 1]
  end
  X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, str)
end
local ItemSocketingResultEventChatMsg = function(resultCode, itemLink, install)
  if not install then
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "socketing_reset"))
    return
  end
  local str = ""
  local sound
  if resultCode == 1 then
    str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "socketing_success")
    sound = "event_item_socketing_result_success"
  else
    str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "socketing_fail")
    sound = "event_item_socketing_result_fail"
  end
  local msg = string.format("%s: %s|r", str, itemLink)
  X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, msg)
  if sound ~= nil then
    X2Sound:PlayUISound(sound, true)
  end
end
local ItemSocketUpgradeEventChatMsg = function(socketItemType)
  local itemLink = X2Item:GetItemLinkedTextByItemType(socketItemType)
  if itemLink == nil then
    return
  end
  local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "item_socket_upgrade_success")
  local msg = string.format("%s: %s|r", str, itemLink)
  X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, msg)
  X2Sound:PlayUISound("event_item_socketing_result_success", true)
end
local function ItemSmeltingResultEventChatMsg(resultCode, itemLink)
  local str = ""
  if resultCode == 1 then
    str = GetCommonText("item_smelting_chat_msg_success")
  elseif resultCode == 2 then
    str = GetCommonText("item_smelting_chat_msg_great_success")
  else
    str = GetCommonText("item_smelting_chat_msg_fail")
  end
  local msg = string.format("%s: %s|r", str, itemLink)
  X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, msg)
end
local GradeEnchantBroadcastResultEventChatMsg = function(characterName, resultCode, itemLink, oldGrade, newGrade)
  if characterName == X2Unit:UnitName("player") then
    return
  end
  local newGradeColor = string.format("|c%s", X2Item:GradeColor(newGrade))
  local oldGradeName = string.format("|c%s%s|r", X2Item:GradeColor(oldGrade), X2Item:GradeName(oldGrade))
  local newGradeName = string.format("%s", X2Item:GradeName(newGrade))
  local text = ""
  if resultCode == IEBCT_ENCHANT_SUCCESS then
    text = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_success_alarm_chat", FONT_COLOR_HEX.SOFT_YELLOW, characterName, oldGradeName, newGradeColor, newGradeName, FONT_COLOR_HEX.SKYBLUE)
  elseif resultCode == IEBCT_ENCHANT_GREATE_SUCCESS then
    text = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_great_success_alarm_chat", FONT_COLOR_HEX.SOFT_YELLOW, characterName, oldGradeName, newGradeColor, newGradeName, FONT_COLOR_HEX.SKYBLUE)
  elseif resultCode == IEBCT_EVOVING then
    text = X2Locale:LocalizeUiText(PHYSICAL_ENCHANT_TEXT, "broadcast_evolving_alarm", FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE, newGradeColor, newGradeName)
  end
  local msg = string.format("%s: %s", text, itemLink)
  X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, msg)
end
local MakeAttachedName = function(name, trialPostion, factionName)
  local finalName = name
  if trialPostion ~= nil and trialPostion ~= "" then
    finalName = finalName .. "(" .. trialPostion .. ")"
  end
  if factionName ~= nil and factionName ~= "" then
    finalName = finalName .. ":" .. factionName
  end
  return finalName
end
local LootPackItemBroadcastResultEventChatMsg = function(characterName, useItemLink, resultItemLink)
  if characterName == X2Unit:UnitName("player") then
    return
  end
  local text = ""
  text = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_acquisition_single", characterName, resultItemLink)
  X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, text)
end
local GetHeirSkillSymbolName = function(pos)
  local symbolName = {
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_fire"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_life"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_earthquake"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_rock"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_wave"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_fog"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_squall"),
    X2Locale:LocalizeUiText(COMMON_TEXT, "heir_skill_lightning")
  }
  return symbolName[pos]
end
local GetCombatAbilityName = function(ability)
  local name = {
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "fight"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "illusion"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "adamant"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "will"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "death"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "wild"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "magic"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "vocation"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "romance"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "love"),
    X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, "hatred")
  }
  return name[ability]
end
local chatEventListenerEvents = {
  LOOT_DICE = function(charName, itemLinkText, diceValue)
    local msgTxt = ""
    if diceValue < 0 then
      msgTxt = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_dice_give_up", charName, itemLinkText)
    else
      msgTxt = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_dice_roll", charName, itemLinkText, IStr(diceValue))
    end
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, msgTxt)
  end,
  LOOTING_RULE_METHOD_CHANGED = function(lootMethod)
    methodName = ""
    if lootMethod == TEAM_LOOT_FREE_FOR_ALL then
      methodName = X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_popup_free")
    elseif lootMethod == TEAM_LOOT_ROUND_ROBIN then
      methodName = X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_popup_sequence")
    else
      methodName = X2Locale:LocalizeUiText(PARTY_TEXT, "loot_rule_popup_in_charge")
    end
    X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_rule_changed", methodName))
  end,
  LOOTING_RULE_MASTER_CHANGED = function(charName)
    X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_master_changed", charName))
  end,
  LOOTING_RULE_GRADE_CHANGED = function(grade)
    gradeName = "Unknown"
    if grade == NORMAL_ITEM_GRADE then
      X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_grade_released"))
      return
    end
    gradeName = X2Item:GradeName(grade)
    X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_grade_changed", gradeName))
  end,
  APPELLATION_GAINED = function(str)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(QUEST_TEXT, "gain_appellation", str))
  end,
  LOOTING_RULE_BOP_CHANGED = function(rollForBop)
    msgTxt = ""
    if rollForBop == 0 then
      msgTxt = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_roll_for_bop_false")
    else
      msgTxt = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "loot_roll_for_bop_true")
    end
    X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED, msgTxt)
  end,
  TOGGLE_WALK = function(speed)
    if speed == 1 then
      X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "run"))
    else
      X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "walk"))
    end
  end,
  TOGGLE_FOLLOW = function(on)
    if on == true then
      X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_following_begin"))
    else
      X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_following_end"))
    end
  end,
  CHAT_JOINED_CHANNEL = ShowChannelEnterMsg,
  CHAT_LEAVED_CHANNEL = function(channel, name)
    local message = X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "leave_channel", IStr(channel), GetFullChannelName(channel, name))
    X2Chat:DispatchChatMessage(CMF_CHANNEL_INFO, message)
  end,
  CHAT_MESSAGE = function(channel, unit, relation, name, message, speakerInChatBound, specifyName, factionName, trialPosition, worldName)
    local copyOrignalName = name
    name = string.format("|k%s,%d;", name, relation)
    if channel == CHAT_WHISPERED then
      X2Chat:DispatchChatMessage(CMF_WHISPER, X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_whispered", name) .. "|o;" .. message, copyOrignalName)
    elseif channel == CHAT_WHISPER then
      X2Chat:DispatchChatMessage(CMF_WHISPER, X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_whisper", name) .. "|o;" .. message, copyOrignalName)
    elseif channel == CHAT_DAILY_MSG then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, message)
    elseif channel == CHAT_NOTICE then
      X2Chat:DispatchChatMessage(CMF_NOTICE, message)
    elseif channel == CHAT_SAY then
      local unitInfo = X2Unit:GetUnitInfoById(unit)
      if unitInfo ~= nil and unitInfo.faction == "hostile" then
        if specifyName ~= nil and specifyName ~= "" then
          X2Chat:DispatchChatMessage(CMF_SAY, "|cFFE81212" .. "[" .. name .. "] : " .. "|o;" .. message, specifyName)
        else
          X2Chat:DispatchChatMessage(CMF_SAY, "|cFFE81212" .. "[" .. name .. "] : " .. "|o;" .. message)
        end
        return
      end
      if specifyName ~= nil and specifyName ~= "" then
        X2Chat:DispatchChatMessage(CMF_SAY, "[" .. name .. "]: " .. "|o;" .. message, specifyName)
      else
        X2Chat:DispatchChatMessage(CMF_SAY, "[" .. name .. "]: " .. "|o;" .. message)
      end
    elseif channel == CHAT_PARTY then
      local teamIndex, memberId = X2Team:GetMemberIndexByName(copyOrignalName, false)
      if X2Team:IsTeamOwner(teamIndex, memberId) == true then
        X2Chat:DispatchChatMessage(CMF_PARTY, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_party_owner", name) .. "]: " .. "|o;" .. message)
      else
        X2Chat:DispatchChatMessage(CMF_PARTY, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_party", name) .. "]: " .. "|o;" .. message)
      end
    elseif channel == CHAT_RAID then
      local teamIndex, memberId = X2Team:GetMemberIndexByName(copyOrignalName, false)
      if X2Team:IsTeamOwner(teamIndex, memberId) == true then
        if X2Team:IsJointTeam() then
          local myJointOrder = X2Team:GetMyTeamJointOrder()
          if X2Team:IsJointLeader() == (myJointOrder == teamIndex) then
            X2Chat:DispatchChatMessage(CMF_RAID, "[" .. GetCommonText("raid_joint_owner") .. ":" .. name .. "]: " .. "|o;" .. message)
          else
            X2Chat:DispatchChatMessage(CMF_RAID, "[" .. GetCommonText("raid_joint_officer") .. ":" .. name .. "]: " .. "|o;" .. message)
          end
        else
          X2Chat:DispatchChatMessage(CMF_RAID, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raid_owner", name) .. "]: " .. "|o;" .. message)
        end
      else
        X2Chat:DispatchChatMessage(CMF_RAID, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raid", name) .. "]: " .. "|o;" .. message)
      end
    elseif channel == CHAT_RAID_COMMAND then
      local message = "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_raidCommand", name) .. "] " .. message
      X2Chat:DispatchChatMessage(CMF_RAID_COMMAND, message)
    elseif channel == CHAT_SQUAD then
      nameWithWorld = name .. "@" .. worldName
      X2Chat:DispatchChatMessage(CMF_SQUAD, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_squad", nameWithWorld) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_EXPEDITION then
      X2Chat:DispatchChatMessage(CMF_EXPEDITION, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_expedition", name) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_FAMILY then
      X2Chat:DispatchChatMessage(CMF_FAMILY, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_family", name) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_FACTION then
      X2Chat:DispatchChatMessage(CMF_FACTION, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_faction", MakeAttachedName(name, trialPosition, factionName)) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_ZONE then
      X2Chat:DispatchChatMessage(CMF_ZONE, "[" .. channel .. "." .. GetShortChannelName(channel) .. "][" .. name .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_TRADE then
      X2Chat:DispatchChatMessage(CMF_TRADE, "[" .. channel .. "." .. GetShortChannelName(channel) .. "][" .. MakeAttachedName(name, trialPosition, factionName) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_FIND_PARTY then
      X2Chat:DispatchChatMessage(CMF_FIND_PARTY, "[" .. channel .. "." .. GetShortChannelName(channel) .. "][" .. MakeAttachedName(name, trialPosition, factionName) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_TRIAL then
      X2Chat:DispatchChatMessage(CMF_TRIAL, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_trial", MakeAttachedName(name, trialPosition, factionName)) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_RACE then
      X2Chat:DispatchChatMessage(CMF_RACE, "[" .. X2Locale:LocalizeUiText(CHAT_CHANNEL_TEXT, "chat_race", MakeAttachedName(name, trialPosition, factionName)) .. "]: " .. "|o;" .. message)
    elseif channel == CHAT_USER then
    elseif channel == CHAT_SYSTEM then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, message)
    else
      UIParent:LogAlways("Unknown chat channel: " .. channel)
    end
  end,
  NOTICE_MESSAGE = function(noticeType, color, visibleTime, message, name)
    if noticeType ~= 1 then
      return
    end
    local gmName = ""
    if name ~= nil and name ~= "" then
      gmName = name .. ": "
    end
    X2Chat:DispatchChatMessage(CMF_NOTICE, "|c" .. color .. gmName .. message)
  end,
  CHAT_FAILED = function(message, channelName)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, "|cFFFF0000" .. message)
  end,
  REQUIRE_ITEM_TO_CHAT = function(channel)
    local info = X2Chat:GetChatChannelInfo(channel)
    if info ~= nil and info.amount > 0 then
      local msgStr
      if info.spendMoney then
        msgStr = MakeMoneyText(tostring(info.amount))
      else
        msgStr = X2Item:GetItemLinkedTextByItemType(info.itemType)
        if msgStr ~= nil and info.amount > 1 then
          msgStr = string.format("%sX%d ", msgStr, info.amount)
        end
      end
      X2Chat:DispatchChatMessage(CMF_SYSTEM, GetCommonText("notify_require_for_chat", info.name, msgStr))
    end
  end,
  REQUIRE_DELAY_TO_CHAT = function(channel, delay, remain)
    local info = X2Chat:GetChatChannelInfo(channel)
    if info ~= nil then
      local delayStr = MakeTimeString(delay)
      local remainStr = MakeTimeString(remain)
      X2Chat:DispatchChatMessage(CMF_SYSTEM, GetCommonText("notify_chat_delay_remain_time", info.name, delayStr, remainStr))
    end
  end,
  CHAT_MSG_QUEST = function(message, author, authorId, tailType, showTime, fadeTime, currentBubbleType, qtype, forceFinished)
    local covertMessage = X2Util:ApplyUIMacroString(message)
    if tailType == CBK_SYSTEM then
      X2Chat:DispatchChatMessage(CMF_MSG_QUEST, covertMessage)
    else
      X2Chat:DispatchChatMessage(CMF_MSG_QUEST, "[" .. author .. "] : " .. covertMessage)
    end
  end,
  CHAT_MSG_DOODAD = function(message, author, speakerId, tailType, showTime, fadeTime, hasNext, qtype, forceFinished)
    local convertMessage = X2Util:ApplyUIMacroString(message)
    X2Chat:DispatchChatMessage(CMF_MSG_QUEST, "[" .. author .. "] : " .. convertMessage)
  end,
  EXPIRED_ITEM = function(itemLinkText)
    local msg = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_expired", itemLinkText)
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, msg)
  end,
  ADDED_ITEM = function(itemLinkText, itemCount, itemTaskType, tradeOtherName)
    local nameText = ""
    if itemCount == 1 then
      if itemTaskType == ITEM_TASK_TRADE then
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_recieved", tradeOtherName, itemLinkText)
      else
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_recieved", itemLinkText)
      end
      X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, nameText)
    elseif itemCount > 1 then
      if itemTaskType == ITEM_TASK_TRADE then
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_recieved_a", tradeOtherName, itemLinkText, CommaStr(itemCount))
      else
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_recieved_a", itemLinkText, CommaStr(itemCount))
      end
      X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, nameText)
    end
  end,
  REMOVED_ITEM = function(itemLinkText, itemCount, removeState, itemTaskType, tradeOtherName)
    local num = math.abs(itemCount)
    local nameText = ""
    if removeState == "consume" then
      if num == 1 then
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use", itemLinkText)
      elseif num > 1 then
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use_a", itemLinkText, CommaStr(num))
      end
    elseif removeState == "conversion" then
      nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_conversion", itemLinkText)
    elseif num == 1 then
      if itemTaskType == ITEM_TASK_TRADE then
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_removed", tradeOtherName, itemLinkText)
      else
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_removed", itemLinkText)
      end
    elseif num > 1 then
      if itemTaskType == ITEM_TASK_TRADE then
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_trade_removed_a", tradeOtherName, itemLinkText, CommaStr(num))
      else
        nameText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_removed_a", itemLinkText, CommaStr(num))
      end
    end
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, nameText)
  end,
  CRAFT_FAILED = function(itemLinkText)
    local failedText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "failed_craft_message", itemLinkText)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, failedText)
  end,
  GLIDER_MOVED_INTO_BAG = function()
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_glider_moved_into_bag"))
  end,
  ITEM_ACQUISITION_BY_LOOT = function(charName, itemLinkText, itemCount)
    local msgText = ""
    if itemCount == 1 then
      msgText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_acquisition_single", charName, itemLinkText)
    else
      msgText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_acquisition_multiple", charName, itemLinkText, CommaStr(itemCount))
    end
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_TEAM, msgText)
  end,
  MONEY_ACQUISITION_BY_LOOT = function(charName, moneyStr)
    local moneyText = MakeMoneyText(moneyStr)
    local msgText = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_item_acquisition_single", charName, moneyText)
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_TEAM, msgText)
  end,
  SKILL_LEARNED = function(text)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_learn_skill", text .. "|r|cFFFFFF00")
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  MATE_SKILL_LEARNED = function(_, text)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_mate_learn_skill", "|cFF00FF00" .. text .. "|r|cFFFFFF00")
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  SKILL_CHANGED = function(text, level, ability)
    local abilityName = X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, ability)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_change_skill", abilityName, text .. "|r|cFFFFFF00", IStr(level))
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  SKILLS_RESET = function(ability)
    local abilityName = X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, ability)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_reset_skills", abilityName)
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  ABILITY_CHANGED = function(newAbility, oldAbility)
    if newAbility == nil or oldAbility == nil then
      return
    end
    local oldName = X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, oldAbility)
    local newName = X2Locale:LocalizeUiText(ABILITY_CATEGORY_TEXT, newAbility)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_swap_ability", oldName, newName)
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  PREMIUM_LABORPOWER_CHANGED = function(onlineDiff, offlineDiff)
    message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_gain_premium_labor_power", CommaStr(onlineDiff), CommaStr(offlineDiff))
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, message)
  end,
  LABORPOWER_CHANGED = function(diff, laborPower)
    local v = diff
    local message = ""
    if diff == 0 then
      return
    end
    if diff > 0 then
      message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_gain_laber_power", CommaStr(v), CommaStr(laborPower))
    else
      v = -diff
      message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_use_laber_power", CommaStr(v), CommaStr(laborPower))
    end
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, message)
  end,
  ACTABILITY_EXPERT_CHANGED = function(actabilityId, name, diff, final)
    local message = X2Locale:LocalizeUiText(SKILL_TEXT, "actability_value_changed", name, CommaStr(diff), CommaStr(final))
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, message)
  end,
  ACTABILITY_EXPERT_GRADE_CHANGED = function(actabilityId, isUpgrade, name, gradeName)
    local message = ""
    if isUpgrade == true then
      message = X2Locale:LocalizeUiText(SKILL_TEXT, "actability_expert_grade_up", name, gradeName)
    else
      message = X2Locale:LocalizeUiText(SKILL_TEXT, "actability_expert_grade_down", name, gradeName)
    end
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, message)
  end,
  DOODAD_PHASE_MSG = function(text)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, text)
  end,
  HOUSE_FARM_MSG = function(name, total, harvestable)
    local message = string.format("[%s] %d/%d", name, harvestable, total)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, message)
  end,
  UCC_IMPRINT_SUCCEEDED = function()
    X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(UCC_TEXT, "imprint_successed"))
  end,
  BUILD_AREA_MSG = function(factionName)
    local tout = ""
    if factionName ~= nil then
      tout = string.format("%s %s", factionName, X2Locale:LocalizeUiText(HOUSING_TEXT, "buildAreaMsg"))
    else
      tout = X2Locale:LocalizeUiText(HOUSING_TEXT, "buildAreaMsg")
    end
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, tout)
  end,
  PLAYER_MONEY = function(change, changeStr, itemTaskType, tradeOtherName)
    MoneyChangedEventChatMsg(change, changeStr, itemTaskType, tradeOtherName)
  end,
  PLAYER_HONOR_POINT = function(amount, amountStr, isCombatInHonorPointWar)
    HonorPointChangedEventChatMsg(amount, amountStr, isCombatInHonorPointWar)
  end,
  PLAYER_LIVING_POINT = function(amount, amountStr)
    LivingPointChangedEventChatMsg(amount, amountStr)
  end,
  PLAYER_CONTRIBUTION_POINT = function(amount, amountStr)
    ContributionPointChangedEventChatMsg(amount, amountStr)
  end,
  PLAYER_LEADERSHIP_POINT = function(amount, amountStr)
    LeadershipPointChangedEventChatMsg(amount, amountStr)
  end,
  PLAYER_AA_POINT = function(change, changeStr, itemTaskType, tradeOtherName)
    AAPointChangedEventChatMsg(change, changeStr, itemTaskType, tradeOtherName)
  end,
  GRADE_ENCHANT_RESULT = function(resultCode, itemLink, oldGrade, newGrade)
    GradeEnchantResultEventChatMsg(resultCode, itemLink)
  end,
  ITEM_SOCKETING_RESULT = function(resultCode, itemLink, socketItemType, install)
    ItemSocketingResultEventChatMsg(resultCode, itemLink, install)
  end,
  ITEM_SOCKET_UPGRADE = function(socketItemType)
    ItemSocketUpgradeEventChatMsg(socketItemType)
  end,
  ITEM_ENCHANT_MAGICAL_RESULT = function(resultCode, itemLink, gemItemType)
    if not resultCode then
      return
    end
    local msg = string.format("%s: %s|r", GetCommonText("chat_msg_gem_success"), itemLink)
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, msg)
  end,
  ITEM_SMELTING_RESULT = function(resultCode, itemLink, smeltingItemType)
    if not resultCode then
      return
    end
    ItemSmeltingResultEventChatMsg(resultCode, itemLink)
  end,
  GRADE_ENCHANT_BROADCAST = function(characterName, resultCode, itemLink, oldGrade, newGrade)
    GradeEnchantBroadcastResultEventChatMsg(characterName, resultCode, itemLink, oldGrade, newGrade)
  end,
  NOTIFY_WEB_TRANSFER_STATE = function(arg)
    local message = X2Locale:LocalizeUiText(WEB_TEXT, arg)
    if message == nil then
      return
    end
    X2Chat:DispatchChatMessage(CMF_WEB_CAST_INFO, message)
  end,
  DOMINION = function(action, zoneGroupName, expeditionName)
    local message = X2Locale:LocalizeUiText(DOMINION, action, zoneGroupName, expeditionName)
    X2Chat:DispatchChatMessage(CMF_DOMINION_AND_SIEGE_INFO, message)
  end,
  COMMUNITY_ERROR = function(msg)
    X2Chat:DispatchChatMessage(CMF_COMMUNITY, msg)
  end,
  BLOCKED_USER_LIST = function(msg)
    X2Chat:DispatchChatMessage(CMF_BLOCK_INFO, msg)
  end,
  FRIENDLIST = function(msg)
    X2Chat:DispatchChatMessage(CMF_FRIEND_INFO, msg)
  end,
  FAMILY_ERROR = function(msg)
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, msg)
  end,
  FAMILY_MEMBER_ADDED = function(owner, member, title)
    local message = ""
    if title == "" then
      message = X2Locale:LocalizeUiText(COMMON_TEXT, "member_added_2", member)
    else
      message = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_added", owner, member, title)
    end
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, message)
  end,
  FAMILY_MEMBER_LEFT = function(member)
    local message = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_left", member)
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, message)
  end,
  FAMILY_MEMBER_KICKED = function(member)
    local message = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_kicked", member)
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, message)
  end,
  FAMILY_MEMBER = function(owner, member, role, title)
    local message = ""
    if role == 1 then
      message = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "owner_desc", owner)
    else
      message = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "member_desc", owner, member, title)
    end
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, message)
  end,
  FAMILY_OWNER_CHANGED = function(owner)
    local message = X2Locale:LocalizeUiText(COMMUNITY_TEXT, "owner_changed", owner)
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, message)
  end,
  FAMILY_REMOVED = function()
    local message = X2Locale:LocalizeUiText(ERROR_MSG, "FAMILY_REMOVED")
    X2Chat:DispatchChatMessage(CMF_FAMILY_INFO, message)
  end,
  EXPEDITION_EXP = function(amount, amountStr)
    ExpeditionExpChangedEventChatMsg(amount, amountStr)
  end,
  FAMILY_EXP_ADD = function(amount)
    FamilyExpChangedEventChatMsg(amount)
  end,
  FAMILY_NAME_CHANGED = function(name, changeName)
    local textOut = X2Locale:LocalizeUiText(COMMON_TEXT, "family_name_change_notify", name, changeName)
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, textOut)
  end,
  RESIDENT_SERVICE_POINT_CHANGED = function(zoneGroupName, amount, total)
    local textOut = X2Locale:LocalizeUiText(COMMON_TEXT, "add_resident_service_point", zoneGroupName, CommaStr(tostring(amount)), zoneGroupName, CommaStr(tostring(total)))
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, textOut)
  end,
  CHAT_DICE_VALUE = function(msg)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, msg)
  end,
  CRIME_REPORTED = function(diffPoint, diffRecord, diffScore)
    if diffRecord == 0 then
      return
    end
    local info = X2Player:GetCrimeInfo()
    local dishonorPoint = info.crimeRecord
    local message = ""
    if diffRecord > 0 then
      message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "increase_dishonor_point", CommaStr(diffRecord), CommaStr(dishonorPoint))
    else
      message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "decrease_dishonor_point", CommaStr(math.abs(diffRecord)), CommaStr(dishonorPoint))
    end
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, message)
  end,
  TOWER_DEF_MSG = function(towerDefInfo)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, towerDefInfo.msg)
  end,
  SAVE_SCREEN_SHOT = function(path)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "save_screenshot", path))
  end,
  TRIAL_MESSAGE = function(text)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, text)
  end,
  AUCTION_BIDDEN = function(itemName, moneyStr)
    local money = MakeMoneyText(moneyStr)
    local msg = X2Locale:LocalizeUiText(AUCTION_TEXT, "bidden_message", itemName, money)
    X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
  end,
  AUCTION_BOUGHT_BY_SOMEONE = function(itemName, moneyStr)
    local money = MakeMoneyText(moneyStr)
    local msg = X2Locale:LocalizeUiText(AUCTION_TEXT, "bought_by_someone_message", itemName, money)
    X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
  end,
  SELL_SPECIALTY = function(text)
    X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, text)
  end,
  SHOW_SEXTANT_POS = function(argTable)
    local long = argTable.longitude
    local deg_long = argTable.deg_long
    local min_long = argTable.min_long
    local sec_long = argTable.sec_long
    local lat = argTable.latitude
    local deg_lat = argTable.deg_lat
    local min_lat = argTable.min_lat
    local sec_lat = argTable.sec_lat
    X2Chat:DispatchChatMessage(CMF_SYSTEM, ShowSextantPos(long, deg_long, min_long, sec_long, lat, deg_lat, min_lat, sec_lat))
  end,
  EXP_CHANGED = function(stringId, expNum, expStr)
    local markedExp = X2Util:MakeMarkedCiphersStr(expStr, baselibLocale.MarkedCiphersValue)
    if X2Unit:GetUnitId("player") == stringId then
      if expNum >= 0 then
        X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(UTIL_TEXT, "add_exp_str", tostring(markedExp)))
      else
        X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(UTIL_TEXT, "lost_exp_str", tostring(markedExp)))
      end
      return
    end
    if X2Mate:IsMyPet(stringId) then
      X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(UTIL_TEXT, "add_pet_exp_str", CommaStr(expStr)))
      return
    end
  end,
  ABILITY_EXP_CHANGED = function(expStr)
    local markedExp = X2Util:MakeMarkedCiphersStr(expStr, baselibLocale.MarkedCiphersValue)
    X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, X2Locale:LocalizeUiText(UTIL_TEXT, "add_ability_exp_str", CommaStr(markedExp)))
  end,
  ACQUAINTANCE_LOGIN = function(charName)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, X2Locale:LocalizeUiText(COMMUNITY_TEXT, "online_acquaintance", charName))
  end,
  HPW_ZONE_STATE_CHANGE = function(zoneId)
    local zoneInfo = X2Map:GetZoneStateInfoByZoneId(zoneId)
    if zoneInfo == nil then
      return
    elseif zoneInfo.conflictState == HPWS_PEACE then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "end_war", zoneInfo.zoneName))
      return
    else
      local strState = GetZoneState(zoneInfo.conflictState)
      local color = ""
      if zoneInfo.conflictState == HPWS_BATTLE then
        color = GetHexColorForString(Dec2Hex(FONT_COLOR.TOOLTIP_ZONE_COLOR_STATE_MIDDLE))
      elseif zoneInfo.conflictState == HPWS_WAR then
        color = GetHexColorForString(Dec2Hex(FONT_COLOR.TOOLTIP_ZONE_COLOR_STATE_HIGH))
      end
      X2Chat:DispatchChatMessage(CMF_SYSTEM, color .. X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "change_state", zoneInfo.zoneName, strState))
    end
  end,
  SHOW_ACCUMULATE_HONOR_POINT_DURING_HPW = function(zoneName, accumulatePoint, state)
    local sign = accumulatePoint > 0 and "+" or ""
    local color = accumulatePoint >= 0 and FONT_COLOR_HEX.BLUE or FONT_COLOR_HEX.RED
    local strPoint = string.format("%s%s%d", color, sign, accumulatePoint)
    local msg = X2Locale:LocalizeUiText(COMMON_TEXT, "x_sum_y_points", zoneName, X2Locale:LocalizeUiText(COMMON_TEXT, "honor_point"), strPoint)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, msg)
  end,
  ITEM_EQUIP_RESULT = function(ItemEquipResult)
    if ItemEquipResult == ITEM_MATE_UNSUMMON then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(PET_TEXT, "unsummon_mate_equip"))
    elseif ItemEquipResult == ITEM_MATE_NOT_EQUIP then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(PET_TEXT, "item_not_equip_for_pet"))
    elseif ItemEquipResult == ITEM_SLAVE_UNSUMMON then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(PET_TEXT, "unsummon_mate_equip"))
    elseif ItemEquipResult == ITEM_SLAVE_NOT_EQUIP then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(PET_TEXT, "item_not_equip_for_pet"))
    end
  end,
  INSTANT_GAME_KILL = function(msgInfo)
    local str = GetKillMsg(msgInfo)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  INSTANT_GAME_UNEARNED_WIN_REMAIN_TIME = function(remainTime)
    local str = X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "unearned_win_remain_time", tostring(remainTime))
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  CHAT_MSG_ALARM = function(text)
    X2Chat:DispatchChatMessage(CMF_ETC_GROUP, text)
  end,
  HOUSE_CANCEL_SELL_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_cancel_sell_success", houseName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  HOUSE_CANCEL_SELL_FAIL = function()
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_cancel_sell_fail")
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  HOUSE_SET_SELL_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_set_sell_success", houseName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  HOUSE_SET_SELL_FAIL = function()
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_set_sell_fail")
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  HOUSE_BUY_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_buy_success", houseName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  HOUSE_BUY_FAIL = function()
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_buy_fail")
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  HOUSE_SALE_SUCCESS = function(houseName)
    local str = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "house_sale_success", houseName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  BOT_SUSPECT_REPORTED = function(sourceName, targetName)
    local text = X2Locale:LocalizeUiText(TRIAL_TEXT, "bot_reported", sourceName, targetName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, text)
  end,
  NATION_INDEPENDENCE = function(ownerName, nationName)
    if ownerName == nil or nationName == nil then
      return
    end
    X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(NATION_TEXT, "nation_Independence_Msg", tostring(ownerName), tostring(nationName)))
  end,
  NATION_TAXRATE = function(zoneGroupName, prevTax, tax)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(NATION_TEXT, "nation_taxrate", tostring(zoneGroupName), tostring(prevTax), tostring(tax)))
  end,
  SECOND_PASSWORD_CREATION_COMPLETED = function(success)
    if success then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "setting_success"))
    else
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "setting_fail"))
    end
  end,
  SECOND_PASSWORD_CHANGE_COMPLETED = function(result)
    local Result = {
      R_SUCCESSED = 1,
      R_FAILED = 2,
      R_OLD_PASSWORD_FAILED = 3,
      R_NEW_PASSWORD_FAILED = 4,
      R_PASSWORD_SAME_FAILED = 5
    }
    if result == Result.R_SUCCESSED then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "change_success"))
    else
      if result == Result.R_PASSWORD_SAME_FAILED then
        X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "change_same_fail"))
      end
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "change_fail"))
    end
  end,
  SECOND_PASSWORD_CLEAR_COMPLETED = function(success)
    if success then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_success"))
    else
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "clear_fail"))
    end
  end,
  SECOND_PASSWORD_CHECK_COMPLETED = function(success)
    if success then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_success"))
    else
      local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
      local msg
      if maxFailCnt > 0 then
        msg = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_fail_with_retry", tostring(curFailCnt), tostring(maxFailCnt))
      else
        msg = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "confirmation_fail")
      end
      X2Chat:DispatchChatMessage(CMF_SYSTEM, msg)
    end
  end,
  SECOND_PASSWORD_CHECK_OVER_FAILED = function()
    local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
    local msg = X2Locale:LocalizeUiText(SECOND_PASSWORD_TEXT, "account_lock", tostring(maxFailCnt))
    X2Chat:DispatchChatMessage(CMF_SYSTEM, msg)
  end,
  SECOND_PASSWORD_ACCOUNT_LOCKED = function()
    AlertMsgToSecondPasswordUnlockRemainTime()
  end,
  ITEM_LOOK_CONVERTED = function(itemLinkText)
    X2Chat:DispatchChatMessage(CMF_ADDED_ITEM_SELF, X2Locale:LocalizeUiText(ITEM_LOOK_CONVERT_TEXT, "successNotice", itemLinkText))
  end,
  AUDIENCE_JOINED = function(audienceName)
    local msg = X2Locale:LocalizeUiText(TRIAL_TEXT, "audience_joined", audienceName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, msg)
  end,
  AUDIENCE_LEFT = function(audienceName)
    local msg = X2Locale:LocalizeUiText(TRIAL_TEXT, "audience_left", audienceName)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, msg)
  end,
  ACTABILITY_EXPERT_EXPANDED = function()
    local str = X2Locale:LocalizeUiText(COMMON_TEXT, "actability_expert_expanded")
    X2Chat:DispatchChatMessage(CMF_SYSTEM, str)
  end,
  INVALID_NAME_POLICY = function(namePolicyType)
    local namePolicyInfo = X2Util:GetNamePolicyInfo(namePolicyType)
    local msg = F_TEXT.GetLimitInfoText(namePolicyInfo)
    X2Chat:DispatchChatMessage(CMF_COMMUNITY, msg)
  end,
  HERO_SEASON_UPDATED = function()
    HeroRankingSeasonUpdated()
  end,
  LOOT_PACK_ITEM_BROADCAST = function(characterName, useItemLink, resultItemLink)
    LootPackItemBroadcastResultEventChatMsg(characterName, useItemLink, resultItemLink)
  end,
  DICE_BID_RULE_CHANGED = function(diceBidRule)
    ruleName = ""
    if diceBidRule == DRK_DEFAULT then
      ruleName = X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_default")
    elseif diceBidRule == DRK_AUTO_ACCEPT then
      ruleName = X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_auto_accept")
    else
      ruleName = X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_auto_giveup")
    end
    X2Chat:DispatchChatMessage(CMF_LOOT_METHOD_CHANGED, X2Locale:LocalizeUiText(LOOT_TEXT, "bid_rule_changed", ruleName))
  end,
  BADWORD_USER_REPORED_RESPONE_MSG = function(success)
    local text = X2Locale:LocalizeUiText(TRIAL_TEXT, "report_badword_user_success")
    if success == false then
      text = X2Locale:LocalizeUiText(TRIAL_TEXT, "report_badword_user_fail")
    end
    X2Chat:DispatchChatMessage(CMF_SYSTEM, text)
  end,
  HEIR_SKILL_LEARN = function(text, pos)
    local str = GetHeirSkillSymbolName(pos)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_learn_heir_skill", str, text .. "|r|cFFFFFF00")
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  HEIR_SKILL_RESET = function(isAll, text, info)
    local message
    if isAll then
      message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_reset_all_heir_skill")
      if info ~= nil and info > 0 then
        local str = GetCombatAbilityName(info)
        message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_reset_ability_heir_skill", str)
      end
    elseif info ~= nil and info > 0 then
      local str = GetHeirSkillSymbolName(info)
      message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, "msg_reset_heir_skill", str, text .. "|r|cFFFFFF00")
    end
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  HEIR_SKILL_ACTIVE_TYPE_MSG = function(activeType, ability, text, pos)
    local messageKey = {
      "heir_skill_slot_active",
      "heir_skill_slot_nonactive",
      "heir_skill_slot_hide"
    }
    local abilityStr = GetCombatAbilityName(ability)
    local posStr = GetHeirSkillSymbolName(pos)
    local message = X2Locale:LocalizeUiText(CHAT_SYSTEM_TEXT, messageKey[activeType], abilityStr .. "|r|cFFFFFF00", text, posStr)
    X2Chat:DispatchChatMessage(CMF_SELF_SKILL_INFO, message)
  end,
  NAME_TAG_MODE_CHANGED_MSG = function(changedNameTagMode)
    local messageKey = {
      "option_item_nametag_mode_default",
      "option_item_nametag_mode_battle",
      "option_item_nametag_mode_life",
      "option_item_nametag_mode_box"
    }
    local nameTagMode = X2Locale:LocalizeUiText(OPTION_TEXT, messageKey[changedNameTagMode])
    local message = X2Locale:LocalizeUiText(COMMON_TEXT, "name_tag_mode_changed", nameTagMode)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, message)
  end,
  FACTION_RELATION_WILL_CHANGE = function(f1Name, f2Name)
    local message = X2Locale:LocalizeUiText(COMMON_TEXT, "faction_relation_will_change", f1Name, f2Name)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, message)
  end
}
local chatEventListener = CreateEmptyWindow("chatEventListener", "UIParent")
chatEventListener:Show(false)
chatEventListener:SetHandler("OnEvent", function(this, event, ...)
  chatEventListenerEvents[event](...)
end)
local RegistUIEvent = function(window, eventTable)
  for key, _ in pairs(eventTable) do
    window:RegisterEvent(key)
  end
end
RegistUIEvent(chatEventListener, chatEventListenerEvents)
local hitTypeToStr = function(hitType)
  if hitType == "HIT" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "hit")
  elseif hitType == "CRITICAL" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "critical")
  end
end
local powerTypeToStr = function(powerType)
  if powerType == "HEALTH" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "health")
  elseif powerType == "MANA" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "mana")
  end
end
local missTypeToStr = function(missType, amount)
  if missType == "MISS" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "miss")
  elseif missType == "DODGE" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "dodge")
  elseif missType == "BLOCK" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "block", amount)
  elseif missType == "PARRY" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "parry", amount)
  elseif missType == "IMMUNE" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "immune")
  elseif missType == "RESIST" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "resist")
  end
end
local weaponUsageToStr = function(weaponUsage)
  if weaponUsage == "piercing" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "piercing")
  elseif weaponUsage == "slashing" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "slashing")
  elseif weaponUsage == "blunting" then
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "blunting")
  else
    return X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "unknown")
  end
end
local function formatCombatMessage(targetUnitId, combatEvent, source, target, ...)
  if source == nil or source == "" then
    source = GetCommonText("unknown_name")
  end
  local result = ParseCombatMessage(combatEvent, unpack(arg))
  if combatEvent == "MELEE_DAMAGE" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "melee_log_format", source, target, "|cffff0000" .. result.damage, "|cffff0000" .. powerTypeToStr(result.powerType), "|cffff0000" .. hitTypeToStr(result.hitType))
    if result.reduced ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "reduced", IStr(result.reduced))
    end
    if result.weaponUsageDamage ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "weaponUsageDamage", weaponUsageToStr(result.weaponUsage), IStr(result.weaponUsageDamage))
    end
    return msg, CMF_COMBAT_MELEE_DAMAGE
  elseif combatEvent == "MELEE_MISSED" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "melee_missed", source, target, missTypeToStr(result.missType, "|cffff0000" .. result.damage))
    if result.reduced ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "reduced", IStr(result.reduced))
    end
    if result.weaponUsageDamage ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "weaponUsageDamage", weaponUsageToStr(result.weaponUsage), IStr(result.weaponUsageDamage))
    end
    return msg, CMF_COMBAT_MELEE_MISSED
  elseif combatEvent == "SPELL_DAMAGE" or combatEvent == "SPELL_DOT_DAMAGE" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_log_format", source, target, "|cff25fcff" .. result.spellName, "|cffff0000" .. result.damage, "|cffff0000" .. powerTypeToStr(result.powerType), "|cffff0000" .. hitTypeToStr(result.hitType))
    if result.reduced ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "reduced", IStr(result.reduced))
    end
    if result.weaponUsageDamage ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "weaponUsageDamage", weaponUsageToStr(result.weaponUsage), IStr(result.weaponUsageDamage))
    end
    return msg, CMF_COMBAT_SPELL_DAMAGE
  elseif combatEvent == "SPELL_MISSED" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_missed", source, target, "|cff25fcff" .. result.spellName, missTypeToStr(result.missType, "|cffff0000" .. result.damage))
    if result.reduced ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "reduced", IStr(result.reduced))
    end
    if result.weaponUsageDamage ~= 0 then
      msg = msg .. X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "weaponUsageDamage", weaponUsageToStr(result.weaponUsage), IStr(result.weaponUsageDamage))
    end
    return msg, CMF_COMBAT_SPELL_MISSED
  elseif combatEvent == "SPELL_HEALED" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_healed", source, target, "|cff25fcff" .. result.spellName, "|cff00ff00" .. result.heal)
    return msg, CMF_COMBAT_SPELL_HEALED
  elseif combatEvent == "SPELL_ENERGIZE" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_energize", source, target, "|cff25fcff" .. result.spellName, "|cff00ff00" .. result.amount)
    return msg, CMF_COMBAT_SPELL_ENERGIZE
  elseif combatEvent == "SPELL_CAST_START" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_cast_start", source, "|cff25fcff" .. result.spellName)
    return msg, CMF_COMBAT_SPELL_CAST
  elseif combatEvent == "SPELL_CAST_SUCCESS" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_cast_success", source, "|cff25fcff" .. result.spellName)
    return msg, CMF_COMBAT_SPELL_CAST
  elseif combatEvent == "SPELL_CAST_FAILED" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_cast_failed", source, "|cff25fcff" .. result.spellName)
    return msg, CMF_COMBAT_SPELL_CAST
  elseif combatEvent == "SPELL_AURA_APPLIED" then
    local msg = ""
    if result.auraType == "BUFF" then
      msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_applied_buff", target, "|cff25fcff" .. result.spellName)
    else
      msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_applied_debuff", target, "|cff25fcff" .. result.spellName)
      local buffId = tonumber(result.spellId)
      if HONORABLE_WAR_CASUALTY_BUFF_TYPE == buffId then
        AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "applied_debuff"))
        X2Chat:DispatchChatMessage(CMF_SYSTEM, FONT_COLOR_HEX.RED .. X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "applied_debuff"))
      end
    end
    return msg, CMF_COMBAT_SPELL_AURA
  elseif combatEvent == "SPELL_AURA_REMOVED" then
    local msg = ""
    if result.auraType == "BUFF" then
      msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_removed_buff", target, "|cff25fcff" .. result.spellName)
    else
      msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "spell_aura_removed_debuff", target, "|cff25fcff" .. result.spellName)
      local buffId = tonumber(result.spellId)
      if HONORABLE_WAR_CASUALTY_BUFF_TYPE == buffId then
        AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "removed_debuff"))
        X2Chat:DispatchChatMessage(CMF_SYSTEM, FONT_COLOR_HEX.RED .. X2Locale:LocalizeUiText(HONOR_POINT_WAR_TEXT, "removed_debuff"))
      end
    end
    return msg, CMF_COMBAT_SPELL_AURA
  elseif combatEvent == "ENVIRONMENTAL_DAMAGE" then
    local msg = X2Locale:LocalizeUiText(CHAT_COMBAT_LOG_TEXT, "environmental_damage", target, "|cff25fcff" .. result.damage, "|cffff0000" .. envSourceToStr(result.source))
    return msg, CMF_COMBAT_ENVIRONMENTAL_DMANAGE
  else
    eventStr = combatMessageList[combatEvent] or combatEvent
    msg = string.format("[%s][%s][%s]", eventStr, source, target)
    for i, v in ipairs(arg) do
      if v ~= nil then
        msg = msg .. "[" .. v .. "]"
      end
    end
    return msg
  end
  return ""
end
local ParseSrcDstFilter = function(targetUnitId, combatEvent, source, target, ...)
  local playerName = X2Unit:UnitName("player")
  local targetFilter
  if source == playerName or target == playerName then
    targetFilter = CMF_COMBAT_SRC_GROUP
  else
    targetFilter = CMF_COMBAT_DST_GROUP
  end
  return targetFilter
end
local combatEventListener = CreateEmptyWindow("combatEventListener", "UIParent")
combatEventListener:Show(false)
function combatEventListener:OnEvent(event, ...)
  if event == "COMBAT_MSG" or event == "COMBAT_TEXT_COLLISION" then
    local targetFilter = ParseSrcDstFilter(unpack(arg))
    local time = string.format("[%s] ", os.date("%m/%d/%y %H:%M:%S"))
    local msg, filter = formatCombatMessage(unpack(arg))
    X2Chat:DispatchCombatChatMessage(targetFilter, filter, time .. msg)
  end
end
combatEventListener:SetHandler("OnEvent", combatEventListener.OnEvent)
combatEventListener:RegisterEvent("COMBAT_MSG")
combatEventListener:RegisterEvent("COMBAT_TEXT_COLLISION")
