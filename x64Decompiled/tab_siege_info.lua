local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local MAX_SIEGE_SCHEDULE_COUNT = 4
local MAX_SIEGE_TEAM_COUNT = 3
DominionGuardTowerStateNoticeKey = {
  "siege_alert_guard_tower_1st_attack",
  "siege_alert_guard_tower_below_75",
  "siege_alert_guard_tower_below_50",
  "siege_alert_guard_tower_engravable",
  "siege_alert_engraving_started",
  "siege_alert_engraving_stopped",
  "siege_alert_engraving_succeeded"
}
local MakeTimeText = function(title, startHour, startMin, endHour, endMin, lineFeed, timeColor)
  local str
  local timeStr = string.format("%02d:%02d ~ %02d:%02d", startHour, startMin, endHour, endMin)
  if timeColor ~= nil then
    timeStr = timeColor .. timeStr
  end
  if lineFeed == true then
    str = title .. "\n" .. timeStr
  else
    str = title .. " " .. timeStr
  end
  return str
end
local function CreateSiegeScheduleInfoDetail(frame, index, anchorWidget)
  local scheduleInfo = {
    {
      path = TEXTURE_PATH.SIEGE_COMMANDER,
      textureKey = "commander",
      color = "commander_orange",
      scheduleKey = "hero_volunteer"
    },
    {
      path = TEXTURE_PATH.SIEGE_DEFENSE_ICON,
      textureKey = "defense_df",
      color = "defense_sky",
      scheduleKey = "apply_siege_raid"
    },
    {
      path = TEXTURE_PATH.SIEGE_DEFENSE_ICON,
      textureKey = "defense_df",
      color = "defense_sky",
      scheduleKey = "declare_siege"
    },
    {
      path = TEXTURE_PATH.SIEGE_ATTACK_ICON,
      textureKey = "attack_df",
      color = "attack_red",
      scheduleKey = "siege"
    }
  }
  local iconBg = CreateContentBackground(frame, "TYPE2", "default")
  iconBg:SetExtent(140, 125)
  iconBg:AddAnchor("TOPLEFT", anchorWidget, "BOTTOMLEFT", 0, (index - 1) * 125 + 10)
  local iconDeco = frame:CreateDrawable(TEXTURE_PATH.SIEGE_TAB, "siege_status_icon_color", "artwork")
  iconDeco:SetTextureColor(scheduleInfo[index].color)
  iconDeco:AddAnchor("TOP", iconBg, 0, 12)
  local icon = frame:CreateDrawable(scheduleInfo[index].path, scheduleInfo[index].textureKey, "artwork")
  icon:AddAnchor("CENTER", iconDeco, 0, 0)
  local timeLabel = frame:CreateChildWidget("textbox", "day" .. tostring(index), 0, true)
  timeLabel:SetExtent(140, FONT_SIZE.MIDDLE * 2)
  timeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  timeLabel:AddAnchor("TOP", iconDeco, "BOTTOM", 0, -3)
  timeLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(timeLabel, FONT_COLOR.DEFAULT)
  local infoBg = CreateContentBackground(frame, "TYPE2", "default")
  infoBg:SetExtent(720, 125)
  infoBg:AddAnchor("TOPLEFT", iconBg, "TOPRIGHT", 0, 0)
  local periodLabel = frame:CreateChildWidget("textbox", "period" .. tostring(index), 0, true)
  periodLabel:SetExtent(690, 14)
  periodLabel.style:SetFontSize(14)
  periodLabel:AddAnchor("TOPLEFT", infoBg, 15, 10)
  periodLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(periodLabel, FONT_COLOR.MIDDLE_TITLE)
  periodLabel:SetText(X2Locale:LocalizeUiText(DOMINION, scheduleInfo[index].scheduleKey .. "_title"))
  local detailInfoLabel = frame:CreateChildWidget("textbox", "period_info" .. tostring(index), 0, true)
  detailInfoLabel:SetExtent(690, 85)
  detailInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  detailInfoLabel:AddAnchor("TOPLEFT", periodLabel, "BOTTOMLEFT", 0, 5)
  detailInfoLabel.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(detailInfoLabel, FONT_COLOR.DEFAULT)
  detailInfoLabel:SetText(X2Locale:LocalizeUiText(DOMINION, scheduleInfo[index].scheduleKey .. "_detail"))
  if index ~= MAX_SIEGE_SCHEDULE_COUNT then
    local arrow = frame:CreateDrawable(TEXTURE_PATH.STEP_ARROW, "step_arrow", "artwork")
    arrow:SetTextureColor("default")
    arrow:AddAnchor("TOP", timeLabel, "BOTTOM", 0, 5)
  end
  local siegeTimeInfo = X2Dominion:GetSiegeTimeInfo()
  local weekKey = scheduleInfo[index].scheduleKey .. "_week"
  local hourkey = scheduleInfo[index].scheduleKey .. "_hour"
  local minKey = scheduleInfo[index].scheduleKey .. "_min"
  local nextHourkey = "siege_end_hour"
  local nextMinKey = "siege_end_min"
  if index ~= MAX_SIEGE_SCHEDULE_COUNT then
    local infoIndex = index + 1
    if index == 2 then
      infoIndex = index + 2
    end
    nextHourkey = scheduleInfo[infoIndex].scheduleKey .. "_hour"
    nextMinKey = scheduleInfo[infoIndex].scheduleKey .. "_min"
  end
  local str = MakeTimeText(X2Locale:LocalizeUiText(DOMINION, "siege_info_day", GetCommonText(siegeTimeInfo[weekKey])), siegeTimeInfo[hourkey], siegeTimeInfo[minKey], siegeTimeInfo[nextHourkey], siegeTimeInfo[nextMinKey], true)
  timeLabel:SetText(str)
end
local function CreateSiegeScheduleInfo(window, mainFrame)
  local frame = mainFrame:CreateChildWidget("emptywidget", "scheduleInfoFrame", 0, true)
  frame:AddAnchor("TOPLEFT", window, 0, 0)
  frame:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local dominionLabel = frame:CreateChildWidget("textbox", "dominion", 0, true)
  dominionLabel:SetExtent(window:GetWidth(), 43)
  dominionLabel.style:SetFontSize(FONT_SIZE.LARGE)
  dominionLabel:AddAnchor("TOPLEFT", window, 0, 10)
  dominionLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(dominionLabel, FONT_COLOR.DEFAULT)
  dominionLabel:SetAutoResize(true)
  frame.dominionLabel = dominionLabel
  for i = 1, MAX_SIEGE_SCHEDULE_COUNT do
    CreateSiegeScheduleInfoDetail(frame, i, dominionLabel)
  end
  local supportSiegeCommanderButton = frame:CreateChildWidget("button", "supportSiegeCommanderButton", 0, true)
  ApplyButtonSkin(supportSiegeCommanderButton, BUTTON_BASIC.DEFAULT)
  supportSiegeCommanderButton:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  supportSiegeCommanderButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_window_title"))
  function supportSiegeCommanderButton:OnClick()
    X2Team:ShowSiegeRaidRegisterUI()
  end
  supportSiegeCommanderButton:SetHandler("OnClick", supportSiegeCommanderButton.OnClick)
  return frame
end
local function CreateSiegeGuideWindow()
  local siegeTimeInfo = X2Dominion:GetSiegeTimeInfo()
  SIEGE_GUIDE_WINDOW = {
    {
      title = X2Locale:LocalizeUiText(DOMINION, "siege_guide_title"),
      raw = true
    },
    {
      title = MakeTimeText(X2Locale:LocalizeUiText(DOMINION, "hero_volunteer_title"), siegeTimeInfo.hero_volunteer_hour, siegeTimeInfo.hero_volunteer_min, siegeTimeInfo.apply_siege_raid_hour, siegeTimeInfo.apply_siege_raid_min, false, FONT_COLOR_HEX.BLUE),
      content = X2Locale:LocalizeUiText(DOMINION, "hero_volunteer_guide_detail"),
      raw = true
    },
    {
      title = MakeTimeText(X2Locale:LocalizeUiText(DOMINION, "apply_siege_raid_title"), siegeTimeInfo.apply_siege_raid_hour, siegeTimeInfo.apply_siege_raid_min, siegeTimeInfo.siege_end_hour, siegeTimeInfo.siege_end_min, false, FONT_COLOR_HEX.BLUE),
      content = X2Locale:LocalizeUiText(DOMINION, "apply_siege_raid_guide_detail"),
      raw = true
    },
    {
      title = MakeTimeText(X2Locale:LocalizeUiText(DOMINION, "declare_siege_title"), siegeTimeInfo.declare_siege_hour, siegeTimeInfo.declare_siege_min, siegeTimeInfo.siege_hour, siegeTimeInfo.siege_min, false, FONT_COLOR_HEX.BLUE),
      content = X2Locale:LocalizeUiText(DOMINION, "declare_siege_guide_detail"),
      raw = true
    },
    {
      title = MakeTimeText(X2Locale:LocalizeUiText(DOMINION, "siege_title"), siegeTimeInfo.siege_hour, siegeTimeInfo.siege_min, siegeTimeInfo.siege_end_hour, siegeTimeInfo.siege_end_min, false, FONT_COLOR_HEX.BLUE),
      content = X2Locale:LocalizeUiText(DOMINION, "siege_guide_detail"),
      raw = true
    },
    {
      title = X2Locale:LocalizeUiText(DOMINION, "siege_special_rule_guide_title"),
      content = X2Locale:LocalizeUiText(DOMINION, "siege_special_rule_guide_detail"),
      raw = true
    },
    {
      title = X2Locale:LocalizeUiText(DOMINION, "siege_win_rule_guide_title"),
      content = X2Locale:LocalizeUiText(DOMINION, "siege_win_rule_guide_detail"),
      raw = true
    }
  }
  return CreateInfomationGuideWindow("siege guide", "UIParent", "siege_guide", SIEGE_GUIDE_WINDOW, 680, 555)
end
local CreateRewardItemFrame = function(wnd, index, rewardItemInfo)
  local info = {
    {
      itemKey = "lose",
      titleKey = "siege_lose_reward"
    },
    {
      itemKey = "winOwner",
      titleKey = "siege_win_owner"
    },
    {
      itemKey = "winHero",
      titleKey = "siege_win_hero"
    },
    {
      itemKey = "win",
      titleKey = "siege_win_member"
    }
  }
  local data = {}
  data.title = X2Locale:LocalizeUiText(DOMINION, info[index].titleKey)
  data.fix_width = 186
  local frame = W_MODULE:Create("rewardItemFrame", wnd, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  local icon = CreateItemIconButton("icon", frame)
  icon:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  icon:AddLimitLevelWidget()
  icon:SetItemInfo(X2Item:GetItemInfoByType(rewardItemInfo[info[index].itemKey]))
  local anchorInfo = {
    {
      myAnchor = "TOP",
      targetAnchor = "BOTTOM",
      x = 0,
      y = 17
    }
  }
  frame:AddBody(icon, false, anchorInfo)
  return frame
end
local function CreateRewardItemWindow(window)
  local MAX_WINNER_REWARD_ITEM_TYPE = 3
  local anchorInfo = {
    -186,
    0,
    186
  }
  local wnd = CreateWindow("rewardItemWnd", "UIParent")
  wnd:SetExtent(600, 440)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(X2Locale:LocalizeUiText(DOMINION, "siege_reward"))
  local rewardInfoLabel = wnd:CreateChildWidget("textbox", "rewardInfoLabel", 0, true)
  rewardInfoLabel:SetExtent(520, FONT_SIZE.MIDDLE * 2)
  rewardInfoLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  rewardInfoLabel:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, 0)
  rewardInfoLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(rewardInfoLabel, FONT_COLOR.DEFAULT)
  rewardInfoLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_reward_info"))
  local rewardItemInfo = X2Dominion:GetSiegeRewardItem()
  local defaultRewardItem = CreateRewardItemFrame(wnd, 1, rewardItemInfo)
  defaultRewardItem:AddAnchor("TOP", rewardInfoLabel, "BOTTOM", 0, 17)
  local lineFrame = wnd:CreateChildWidget("emptywidget", "lineFrame", 0, true)
  lineFrame:SetExtent(540, 1)
  lineFrame:AddAnchor("TOP", defaultRewardItem, "BOTTOM", 0, 17)
  local line = lineFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "slim_line_01", "background")
  line:AddAnchor("TOPLEFT", lineFrame, 0, 0)
  line:AddAnchor("BOTTOMRIGHT", lineFrame, 0, 0)
  local winLabel = wnd:CreateChildWidget("label", "winLabel", 0, true)
  winLabel:SetExtent(350, FONT_SIZE.LARGE)
  winLabel.style:SetFontSize(FONT_SIZE.LARGE)
  winLabel:AddAnchor("CENTER", line, 0, 16)
  winLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(winLabel, FONT_COLOR.MIDDLE_TITLE)
  winLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_win_reward_item"))
  local winRewardItemFrame = {}
  for i = 1, MAX_WINNER_REWARD_ITEM_TYPE do
    winRewardItemFrame[i] = CreateRewardItemFrame(wnd, i + 1, rewardItemInfo)
    winRewardItemFrame[i]:AddAnchor("TOP", winLabel, "BOTTOM", anchorInfo[i], 14)
  end
  local okButton = wnd:CreateChildWidget("button", "okButton", 0, true)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("TOP", winRewardItemFrame[2], "BOTTOM", 0, 20)
  okButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "ok"))
  function okButton:OnClick()
    wnd:Show(false)
  end
  okButton:SetHandler("OnClick", okButton.OnClick)
  local _, height = F_LAYOUT.GetExtentWidgets(wnd.titleBar, okButton)
  wnd:SetHeight(height + okButton:GetHeight())
  return wnd
end
local function CreateSiegeProgressMapInfo(window, frame)
  CreateNationMap("nationMap", frame, true)
  frame.nationMap:AddAnchor("TOPLEFT", frame, 0, 0)
  frame.nationMap:SetExtent(253, 234)
  local defaultButtonWidth = 84
  local resizeTextBox = 0
  local guideButton = frame:CreateChildWidget("button", "guideButton", 0, true)
  ApplyButtonSkin(guideButton, BUTTON_BASIC.DEFAULT)
  guideButton:AddAnchor("TOPRIGHT", frame, 3, 23)
  guideButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_guide"))
  local rewardItemButton = frame:CreateChildWidget("button", "rewardItemButton", 0, true)
  ApplyButtonSkin(rewardItemButton, BUTTON_BASIC.DEFAULT)
  rewardItemButton:AddAnchor("TOP", guideButton, "BOTTOM", 0, 0)
  rewardItemButton:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_reward"))
  local vacancySiegeCommanderButton = frame:CreateChildWidget("button", "vacancySiegeCommanderButton", 0, true)
  ApplyButtonSkin(vacancySiegeCommanderButton, BUTTON_BASIC.DEFAULT)
  vacancySiegeCommanderButton:AddAnchor("TOP", rewardItemButton, "BOTTOM", 0, 0)
  vacancySiegeCommanderButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_register_window_title"))
  frame.vacancySiegeCommanderButton = vacancySiegeCommanderButton
  local buttonWidth = guideButton:GetWidth()
  if defaultButtonWidth < buttonWidth then
    resizeTextBox = buttonWidth - defaultButtonWidth
  end
  local siegePlaceLabel = frame:CreateChildWidget("textbox", "siegePlace", 0, true)
  siegePlaceLabel:SetExtent(470 - resizeTextBox, FONT_SIZE.XLARGE)
  siegePlaceLabel.style:SetFontSize(FONT_SIZE.XLARGE)
  siegePlaceLabel:AddAnchor("TOPLEFT", frame.nationMap, "TOPRIGHT", 25, 32)
  siegePlaceLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(siegePlaceLabel, FONT_COLOR.MIDDLE_TITLE)
  siegePlaceLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_place"))
  local siegeOwnerFactionLabel = frame:CreateChildWidget("textbox", "siegeOwnerFactionLabel", 0, true)
  siegeOwnerFactionLabel:SetExtent(470 - resizeTextBox, FONT_SIZE.LARGE)
  siegeOwnerFactionLabel.style:SetFontSize(FONT_SIZE.LARGE)
  siegeOwnerFactionLabel:AddAnchor("TOP", siegePlaceLabel, "BOTTOM", 0, 10)
  siegeOwnerFactionLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(siegeOwnerFactionLabel, FONT_COLOR.DEFAULT)
  local siegeStateLabel = frame:CreateChildWidget("textbox", "siegeState", 0, true)
  siegeStateLabel:SetExtent(582, FONT_SIZE.XLARGE)
  siegeStateLabel.style:SetFontSize(FONT_SIZE.XLARGE)
  siegeStateLabel:AddAnchor("TOPLEFT", siegeOwnerFactionLabel, "BOTTOMLEFT", 0, 43)
  siegeStateLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(siegeStateLabel, FONT_COLOR.MIDDLE_TITLE)
  siegeStateLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_state"))
  local iconDeco = frame:CreateDrawable(TEXTURE_PATH.SIEGE_TAB, "siege_status_icon_color", "artwork")
  iconDeco:SetTextureColor("defense_sky")
  iconDeco:AddAnchor("TOPLEFT", siegeStateLabel, "BOTTOMLEFT", 0, 12)
  frame.iconDeco = iconDeco
  local icon = frame:CreateDrawable(TEXTURE_PATH.SIEGE_DEFENSE_ICON, "defense_df", "artwork")
  icon:SetExtent(76, 76)
  icon:AddAnchor("CENTER", iconDeco, 0, 0)
  frame.icon = icon
  local siegeScheduleLabel = frame:CreateChildWidget("textbox", "siegeScheduleLabel", 0, true)
  siegeScheduleLabel:SetExtent(490, FONT_SIZE.LARGE)
  siegeScheduleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  siegeScheduleLabel:AddAnchor("TOPLEFT", iconDeco, "TOPRIGHT", 16, 10)
  siegeScheduleLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(siegeScheduleLabel, FONT_COLOR.MIDDLE_TITLE)
  local siegeStateDetailLabel = frame:CreateChildWidget("textbox", "siegeStateDetailLabel", 0, true)
  siegeStateDetailLabel:SetExtent(490, FONT_SIZE.LARGE)
  siegeStateDetailLabel.style:SetFontSize(FONT_SIZE.LARGE)
  siegeStateDetailLabel:AddAnchor("TOP", siegeScheduleLabel, "BOTTOM", 0, 5)
  siegeStateDetailLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(siegeStateDetailLabel, FONT_COLOR.MIDDLE_TITLE)
  local siegeTimeLabel = frame:CreateChildWidget("textbox", "siegeTimeLabel", 0, true)
  siegeTimeLabel:SetExtent(490, FONT_SIZE.LARGE)
  siegeTimeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  siegeTimeLabel:AddAnchor("TOP", siegeStateDetailLabel, "BOTTOM", 0, 5)
  siegeTimeLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(siegeTimeLabel, FONT_COLOR.MIDDLE_TITLE)
  frame.siegeGuideWnd = nil
  frame.rewardItemWnd = nil
  function guideButton:OnClick()
    if frame.siegeGuideWnd == nil then
      frame.siegeGuideWnd = CreateSiegeGuideWindow()
      frame.siegeGuideWnd:AddAnchor("CENTER", "UIParent", 0, 0)
    end
    local visible = frame.siegeGuideWnd:IsVisible()
    frame.siegeGuideWnd:Show(not visible)
  end
  guideButton:SetHandler("OnClick", guideButton.OnClick)
  function rewardItemButton:OnClick()
    if frame.rewardItemWnd == nil then
      frame.rewardItemWnd = CreateRewardItemWindow(window)
    end
    local visible = frame.rewardItemWnd:IsVisible()
    frame.rewardItemWnd:Show(not visible)
  end
  rewardItemButton:SetHandler("OnClick", rewardItemButton.OnClick)
  function vacancySiegeCommanderButton:OnClick()
    X2Team:ShowSiegeRaidRegisterUI()
  end
  vacancySiegeCommanderButton:SetHandler("OnClick", vacancySiegeCommanderButton.OnClick)
  function HideProgressInfoWnd()
    if frame.siegeGuideWnd ~= nil then
      frame.siegeGuideWnd:Show(false)
    end
    if frame.rewardItemWnd ~= nil then
      frame.rewardItemWnd:Show(false)
    end
  end
end
local CreateActiveSiegeRaidTeam = function(frame, index)
  local siegeRaidTeamInfo = {
    {
      color = "blue",
      text = X2Locale:LocalizeUiText(DOMINION, "siege_defense_team")
    },
    {
      color = "soft_red",
      text = X2Locale:LocalizeUiText(DOMINION, "siege_offense_team")
    },
    {
      color = "soft_red",
      text = X2Locale:LocalizeUiText(DOMINION, "siege_offense_team")
    }
  }
  local siegeRaidFrame = frame:CreateChildWidget("emptywidget", "siegeRaidFrame", index, true)
  siegeRaidFrame:SetExtent(280, 294)
  siegeRaidFrame:AddAnchor("TOPLEFT", frame, (index - 1) * 290, 291)
  local teamInfoBg = CreateContentBackground(siegeRaidFrame, "TYPE11", "bg_02")
  teamInfoBg:SetExtent(280, 294)
  teamInfoBg:AddAnchor("TOPLEFT", siegeRaidFrame, 0, 0)
  local teamBg = CreateContentBackground(siegeRaidFrame, "TYPE11", "gray_30")
  teamBg:SetExtent(280, 30)
  teamBg:AddAnchor("TOPLEFT", siegeRaidFrame, 0, 0)
  local siegeRaidTeamLabel = siegeRaidFrame:CreateChildWidget("label", "siegeRaidTeam", 0, true)
  siegeRaidTeamLabel.style:SetFontSize(FONT_SIZE.XLARGE)
  siegeRaidTeamLabel:AddAnchor("TOPLEFT", teamBg, 10, 6)
  siegeRaidTeamLabel:AddAnchor("BOTTOMRIGHT", teamBg, -10, -6)
  siegeRaidTeamLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(siegeRaidTeamLabel, F_COLOR.GetColor(siegeRaidTeamInfo[index].color, false))
  siegeRaidTeamLabel:SetText(siegeRaidTeamInfo[index].text)
  local factionLabel = siegeRaidFrame:CreateChildWidget("label", "faction", 0, true)
  factionLabel:SetExtent(260, 41)
  factionLabel.style:SetFontSize(FONT_SIZE.XLARGE)
  factionLabel:AddAnchor("TOP", teamInfoBg, 0, 48)
  factionLabel.style:SetAlign(ALIGN_TOP)
  ApplyTextColor(factionLabel, FONT_COLOR.DEFAULT)
  frame.factionLabel[index] = factionLabel
  local heroIcon = W_ICON.CreateHeroGradeEmblem(siegeRaidFrame, 1)
  heroIcon:AddAnchor("BOTTOM", siegeRaidFrame, "BOTTOM", 0, -95)
  frame.heroIcon[index] = heroIcon
  local teamNumLabel = siegeRaidFrame:CreateChildWidget("textbox", "teamNum", 0, true)
  teamNumLabel:SetExtent(260, FONT_SIZE.LARGE)
  teamNumLabel.style:SetFontSize(FONT_SIZE.LARGE)
  teamNumLabel:AddAnchor("TOP", heroIcon, "BOTTOM", 0, 15)
  teamNumLabel.style:SetAlign(ALIGN_TOP)
  ApplyTextColor(teamNumLabel, FONT_COLOR.DEFAULT)
  frame.teamNumLabel[index] = teamNumLabel
  local waitWarIcon = siegeRaidFrame:CreateDrawable(TEXTURE_PATH.WAIT_WAR, "waiting_war", "artwork")
  waitWarIcon:AddAnchor("TOP", teamNumLabel, "BOTTOM", 0, 21)
  waitWarIcon:SetVisible(false)
  frame.waitWarIcon[index] = waitWarIcon
  local notJoinSiegeRaidTeamInfo = siegeRaidFrame:CreateChildWidget("textbox", "notJoinSiegeRaidTeamInfo", 0, true)
  notJoinSiegeRaidTeamInfo:SetExtent(260, 75)
  notJoinSiegeRaidTeamInfo.style:SetFontSize(FONT_SIZE.LARGE)
  notJoinSiegeRaidTeamInfo:AddAnchor("TOP", factionLabel, "BOTTOM", 0, 20)
  notJoinSiegeRaidTeamInfo.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(notJoinSiegeRaidTeamInfo, FONT_COLOR.GRAY)
  notJoinSiegeRaidTeamInfo:SetText(X2Locale:LocalizeUiText(DOMINION, "not_siege_raid_team_info"))
  frame.notJoinSiegeRaidTeamInfo = notJoinSiegeRaidTeamInfo
  function siegeRaidFrame:SetActive(index, active)
    if active == true then
      ApplyTextColor(siegeRaidTeamLabel, F_COLOR.GetColor(siegeRaidTeamInfo[index].color, false))
      teamBg:SetTextureColor(siegeRaidTeamInfo[index].color)
      ApplyTextColor(factionLabel, FONT_COLOR.DEFAULT)
      teamNumLabel:SetExtent(260, FONT_SIZE.LARGE)
      ApplyTextColor(teamNumLabel, FONT_COLOR.DEFAULT)
    else
      ApplyTextColor(siegeRaidTeamLabel, F_COLOR.GetColor("gray", false))
      teamBg:SetTextureColor("gray_30")
      factionLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "not_siege_raid_team_title"))
      ApplyTextColor(factionLabel, FONT_COLOR.GRAY)
      teamNumLabel:SetExtent(260, 75)
      ApplyTextColor(teamNumLabel, FONT_COLOR.RED)
      teamNumLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "vacancy_siege_raid_team_info"))
    end
    notJoinSiegeRaidTeamInfo:Show(not active)
    heroIcon:SetAcive(active)
    waitWarIcon:SetVisible(active)
  end
  return siegeRaidFrame
end
local function CreateSiegeProgressFactionInfo(frame)
  local siegePlaceFactionLabel = frame:CreateChildWidget("textbox", "siegePlaceFaction", 0, true)
  siegePlaceFactionLabel:SetExtent(780, FONT_SIZE.XXLARGE)
  siegePlaceFactionLabel.style:SetFontSize(FONT_SIZE.XXLARGE)
  siegePlaceFactionLabel:AddAnchor("TOP", frame, 0, 253)
  siegePlaceFactionLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(siegePlaceFactionLabel, FONT_COLOR.MIDDLE_TITLE)
  siegePlaceFactionLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_place_faction"))
  local refreshButton = frame:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  refreshButton:AddAnchor("LEFT", siegePlaceFactionLabel, "RIGHT", 10, 0)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  frame.refreshButton = refreshButton
  function refreshButton.OnClick()
    X2Team:RequestAllSiegeRaidTeamInfo(SIEGE_RAID_TEAM_ALL_INFO)
  end
  refreshButton:SetHandler("OnClick", refreshButton.OnClick)
  function refreshButton.OnUpdate()
    refreshButton:Enable(X2Team:CheckCoolTimerByTimerType(SIEGE_RAID_TEAM_ALL_INFO))
  end
  refreshButton:SetHandler("OnUpdate", refreshButton.OnUpdate)
  for i = 1, MAX_SIEGE_TEAM_COUNT do
    frame.activeSiegeRaidFrame[i] = CreateActiveSiegeRaidTeam(frame, i)
  end
end
local function CreateSiegeProgressInfo(window, mainFrame)
  local frame = mainFrame:CreateChildWidget("emptywidget", "progressInfoFrame", 0, true)
  frame:AddAnchor("TOPLEFT", window, 0, 0)
  frame:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  frame.activeSiegeRaidFrame = {}
  frame.factionLabel = {}
  frame.heroIcon = {}
  frame.teamNumLabel = {}
  frame.waitWarIcon = {}
  CreateSiegeProgressMapInfo(window, frame)
  CreateSiegeProgressFactionInfo(frame)
  function frame:UpdatePeriodRemainTime(remainDate)
    if remainDate == nil then
      return
    end
    local labelColor = FONT_COLOR.DEFAULT
    if remainDate.hour == 0 and remainDate.minute < 10 then
      labelColor = FONT_COLOR.RED
    end
    ApplyTextColor(self.siegeTimeLabel, labelColor)
    local strTime = GetCommonText("remain_time", locale.time.GetRemainDateToDateFormat(remainDate))
    self.siegeTimeLabel:SetText(strTime)
  end
  function frame:SetSiegeProgressInfo(period, info)
    self.siegeOwnerFactionLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "dominion_owner_faction", info.fName, info.zgName))
    self.vacancySiegeCommanderButton:Show(X2Hero:IsHero())
    if info.period == "siege_period_ready_to_siege" then
      self.iconDeco:SetTextureColor("defense_sky")
      self.icon:SetTexture(TEXTURE_PATH.SIEGE_DEFENSE_ICON)
      self.icon:SetTextureInfo("defense_df")
      self.siegeStateDetailLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_state_ready_to_siege"))
      local timeText = string.format("%02d:%02d ~ %02d:%02d", info.ready_to_siege_hour, info.ready_to_siege_min, info.siege_hour, info.siege_min)
      self.siegeScheduleLabel:SetText(GetCommonText(info.week) .. " " .. timeText)
    else
      self.iconDeco:SetTextureColor("attack_red")
      self.icon:SetTexture(TEXTURE_PATH.SIEGE_ATTACK_ICON)
      self.icon:SetTextureInfo("attack_df")
      self.siegeStateDetailLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_state_siege"))
      local timeText = string.format("%02d:%02d ~ %02d:%02d", info.siege_hour, info.siege_min, info.siege_end_hour, info.siege_end_min)
      self.siegeScheduleLabel:SetText(GetCommonText(info.week) .. " " .. timeText)
    end
    self:UpdatePeriodRemainTime(X2Dominion:GetCurPeriodRemainDateByCurrentZone())
    self.nationMap:FillMapInfo(0, X2Dominion:GetSiegeZoneGroup())
  end
  function frame:SetSiegeTeamInfo(teamInfos)
    if teamInfos == nil then
      return
    end
    for i = 1, MAX_SIEGE_TEAM_COUNT do
      frame.activeSiegeRaidFrame[i]:SetActive(i, false)
    end
    for i = 1, #teamInfos do
      local teamInfo = teamInfos[i]
      local index = 1
      if teamInfo.defense == false then
        index = 2
        if self.factionLabel[index]:GetText() ~= X2Locale:LocalizeUiText(DOMINION, "not_siege_raid_team_title") and self.factionLabel[index]:GetText() ~= teamInfo.fName then
          index = 3
        end
      end
      self.activeSiegeRaidFrame[index]:SetActive(index, true)
      self.factionLabel[index]:SetText(teamInfo.fName)
      self.teamNumLabel[index]:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_raid_team_member_count", tostring(teamInfo.membetCount)))
      if teamInfo.period == "siege_period_siege" then
        self.waitWarIcon[index]:SetVisible(false)
      else
        self.waitWarIcon[index]:SetVisible(teamInfo.isWaitWar)
      end
      self.heroIcon[index]:SetGradeAndNameInfo(teamInfo.ownerName, teamInfo.ranking)
    end
  end
  function frame:SetWaitWar(factionName)
    for i = 1, MAX_SIEGE_TEAM_COUNT do
      if self.factionLabel[i]:GetText() == factionName then
        self.waitWarIcon[i]:SetVisible(true)
        return
      end
    end
  end
  function frame:ClearInfo()
    for i = 1, MAX_SIEGE_TEAM_COUNT do
      self.factionLabel[i]:SetText("")
      self.teamNumLabel[i]:SetText("")
      self.waitWarIcon[i]:SetVisible(false)
      self.heroIcon[i]:SetGradeAndNameInfo("", "")
    end
  end
  return frame
end
local function CreateSiegeInfo(window)
  local frame = window:CreateChildWidget("emptywidget", "infoFrame", 0, true)
  frame:SetExtent(window:GetWidth(), 598)
  frame:AddAnchor("TOPLEFT", window, 0, sideMargin)
  window.frame = frame
  local siegeScheduleFrame = CreateSiegeScheduleInfo(window, frame)
  frame.siegeScheduleFrame = siegeScheduleFrame
  local siegeProgressFrame = CreateSiegeProgressInfo(window, frame)
  frame.siegeProgressFrame = siegeProgressFrame
  function frame:RequestDominionInfo()
    X2Dominion:GetSiegeInfoDominion()
  end
  function frame:SetDominionInfo(siegeInfo)
    local dominionLabel = self.siegeScheduleFrame.dominionLabel
    if siegeInfo == "" then
      dominionLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "no_siege_dominion"))
    else
      local siegeTime = string.format("%02d:%02d", siegeInfo.hour, siegeInfo.min)
      dominionLabel:SetText(X2Locale:LocalizeUiText(DOMINION, "siege_dominion", siegeInfo.zoneGroupName, GetCommonText(siegeInfo.week), siegeTime))
    end
  end
  return frame
end
function CreateSiegeInfoMgr(window)
  local SiegeInfoFrame = CreateSiegeInfo(window)
  window.SiegeInfoFrame = SiegeInfoFrame
  function SiegeInfoFrame:Init(force)
    if window:IsVisible() == false then
      return
    end
    period = X2Dominion:GetSiegePeriodName()
    if period == "siege_period_ready_to_siege" or period == "siege_period_siege" then
      self.siegeScheduleFrame:Show(false)
      self.siegeProgressFrame:Show(true)
      self.siegeProgressFrame:SetSiegeProgressInfo(period, X2Dominion:GetSiegeProgressInfo())
      X2Team:RequestAllSiegeRaidTeamInfo(SIEGE_RAID_TEAM_ALL_INFO)
    else
      self:RequestDominionInfo()
      self.siegeScheduleFrame:Show(true)
      self.siegeProgressFrame:Show(false)
    end
  end
  function window:Init()
    window.SiegeInfoFrame:Init(true)
  end
  function window:Close()
    HideProgressInfoWnd()
  end
  function window:OnHide()
    HideProgressInfoWnd()
  end
  local events = {
    ENTERED_WORLD = function(firstEnteredWorld)
      UpdateSiegeSchedule(firstEnteredWorld)
    end,
    ALL_SIEGE_RAID_TEAM_INFOS = function(teamInfos)
      SiegeInfoFrame.siegeProgressFrame:SetSiegeTeamInfo(teamInfos)
    end,
    NEXT_SIEGE_INFO = function(siegeInfo)
      SiegeInfoFrame:SetDominionInfo(siegeInfo)
    end,
    DOMINION_SIEGE_PERIOD_CHANGED = function(info)
      local action = info.action
      local zoneGroupType = info.zoneGroupType
      local zoneGroupName = info.zoneGroupName
      local defenseName = info.defenseName
      local offenseName = info.offenseName
      local periodName = info.periodName
      local isMyInfo = info.isMyInfo
      local team = info.team
      if action == "change_state" and periodName == "siege_period_siege" then
        ClearSiegeScore()
        X2Team:ResetCoolTimerByTimerType(SIEGE_RAID_TEAM_ALL_INFO)
      end
      if action == "change_state" or periodName == "siege_period_peace" then
        SiegeInfoFrame:Init(true)
      end
      if action == "declared_siege" then
        SiegeInfoFrame.siegeProgressFrame:SetWaitWar(offenseName)
      end
      if periodName == "siege_period_peace" then
        SiegeInfoFrame.siegeProgressFrame:ClearInfo()
        ShowSiegeScore(false)
      end
      SiegePeriodChanged(action, zoneGroupType, zoneGroupName, defenseName, offenseName, periodName, isMyInfo, team)
    end,
    DOMINION_SIEGE_UPDATE_TIMER = function(secondHalf)
      if secondHalf == true then
        UpdateSiegeTimer()
      else
        SiegeInfoFrame.siegeProgressFrame:UpdatePeriodRemainTime(X2Dominion:GetCurPeriodRemainDateByCurrentZone())
        UpdateSiegeSchedule(false)
      end
    end,
    DOMINION_GUARD_TOWER_STATE_NOTICE = function(key, name, factionName)
      if key >= #DominionGuardTowerStateNoticeKey then
        return
      end
      local index = key + 1
      if index >= 1 and index <= 4 then
        AddSiegeAlertGuardTowerMsg(DominionGuardTowerStateNoticeKey[index])
        if DominionGuardTowerStateNoticeKey[index] == "siege_alert_guard_tower_engravable" then
          UpdateSiegeSchedule(false)
        end
      elseif index >= 5 and index <= 7 then
        siegeSystemAlarmWindow.engravingName = nil
        if siegeSystemAlarmWindow.periodName == "siege_period_peace" then
          siegeSystemAlarmWindow.periodName = nil
          return
        end
        if name == nil or name == "" then
          return
        end
        if index == 7 then
          siegeSystemAlarmWindow.engravingName = name
        end
        if DominionGuardTowerStateNoticeKey[index] == "siege_alert_engraving_succeeded" then
          return
        end
        local fName = factionName
        if factionName == nil then
          fName = ""
        end
        local imgEventInfo = MakeImgEventInfo("DOMINION_GUARD_TOWER_STATE_NOTICE", AddSiegeAlertEngravingMsg, {
          DominionGuardTowerStateNoticeKey[index],
          name,
          fName
        })
        AddImgEventQueue(imgEventInfo)
      end
    end,
    DOMINION = function(action, zoneGroupName, expeditionName)
      if action ~= "declared" then
        return
      end
      local str = X2Locale:LocalizeUiText(DOMINION, "alarm_declare", expeditionName, zoneGroupName)
      local imgEventInfo = MakeImgEventInfo("DOMINION", AddSiegeDeclareTerritoryMsg, {str})
      AddImgEventQueue(imgEventInfo)
    end,
    DOMINION_SIEGE_PARTICIPANT_COUNT_CHANGED = function(zoneGroupType)
      UpdateSiegeSchedule(false)
    end,
    UPDATE_SIEGE_SCORE = function(offensePoint, outlawPoint)
      UpdateSiegeScore(offensePoint, outlawPoint)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
