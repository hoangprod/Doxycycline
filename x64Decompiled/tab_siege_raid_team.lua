local teamInfo, heroGrade
function GetTeamInfo()
  return teamInfo
end
local function IsSiegeRaidTeamMember(name)
  if teamInfo == nil or teamInfo.memberInfo == nil then
    return false
  end
  local cnt = #teamInfo.memberInfo
  for i = 1, cnt do
    if teamInfo.memberInfo[i].name == name then
      return true
    end
  end
  return false
end
local CreateInfoLabels = function(wnd, anchor)
  local tempWidth = 0
  local commanderLabel = W_CTRL.CreateLabel("commanderLabel", wnd)
  commanderLabel:SetAutoResize(true)
  commanderLabel:SetHeight(FONT_SIZE.LARGE)
  commanderLabel.style:SetAlign(ALIGN_LEFT)
  commanderLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(commanderLabel, FONT_COLOR.MIDDLE_TITLE)
  commanderLabel:AddAnchor("TOPLEFT", anchor, "TOPLEFT", 20, 20)
  commanderLabel:SetText(locale.nationMgr.siegeRaidCommander)
  tempWidth = commanderLabel:GetWidth()
  local teamLabel = W_CTRL.CreateLabel("teamLabel", wnd)
  teamLabel:SetAutoResize(true)
  teamLabel:SetHeight(FONT_SIZE.LARGE)
  teamLabel.style:SetAlign(ALIGN_LEFT)
  teamLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(teamLabel, FONT_COLOR.MIDDLE_TITLE)
  teamLabel:AddAnchor("TOPLEFT", commanderLabel, "BOTTOMLEFT", 0, 10)
  teamLabel:SetText(locale.nationMgr.siegeRaidTeamMemberCount)
  if tempWidth < teamLabel:GetWidth() then
    tempWidth = teamLabel:GetWidth()
  end
  local sponserLabel = W_CTRL.CreateLabel("sponserLabel", wnd)
  sponserLabel:SetAutoResize(true)
  sponserLabel:SetHeight(FONT_SIZE.LARGE)
  sponserLabel.style:SetAlign(ALIGN_LEFT)
  sponserLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(sponserLabel, FONT_COLOR.MIDDLE_TITLE)
  sponserLabel:AddAnchor("TOPLEFT", teamLabel, "BOTTOMLEFT", 0, 10)
  sponserLabel:SetText(locale.nationMgr.siegeRaidSponser)
  if tempWidth < sponserLabel:GetWidth() then
    tempWidth = sponserLabel:GetWidth()
  end
  local commanderInfoLabel = W_CTRL.CreateLabel("commanderInfoLabel", wnd)
  commanderInfoLabel:SetLimitWidth(true)
  commanderInfoLabel:SetExtent(388 - tempWidth - 15, FONT_SIZE.LARGE)
  commanderInfoLabel.style:SetAlign(ALIGN_LEFT)
  commanderInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(commanderInfoLabel, FONT_COLOR.DEFAULT)
  commanderInfoLabel:AddAnchor("LEFT", commanderLabel, "LEFT", tempWidth + 15, 0)
  commanderInfoLabel:SetText("")
  wnd.commanderInfoLabel = commanderInfoLabel
  local teamInfoLabel = W_CTRL.CreateLabel("teamInfoLabel", wnd)
  teamInfoLabel:SetLimitWidth(true)
  teamInfoLabel:SetExtent(388 - tempWidth - 15, FONT_SIZE.LARGE)
  teamInfoLabel.style:SetAlign(ALIGN_LEFT)
  teamInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(teamInfoLabel, FONT_COLOR.DEFAULT)
  teamInfoLabel:AddAnchor("LEFT", teamLabel, "LEFT", tempWidth + 15, 0)
  teamInfoLabel:SetText("")
  wnd.teamInfoLabel = teamInfoLabel
  local sponserInfoLabel = W_CTRL.CreateLabel("sponserInfoLabel", wnd)
  sponserInfoLabel:SetLimitWidth(true)
  sponserInfoLabel:SetExtent(388 - tempWidth - 15, FONT_SIZE.LARGE)
  sponserInfoLabel.style:SetAlign(ALIGN_LEFT)
  sponserInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(sponserInfoLabel, FONT_COLOR.DEFAULT)
  sponserInfoLabel:AddAnchor("LEFT", sponserLabel, "LEFT", tempWidth + 15, 0)
  sponserInfoLabel:SetText("")
  wnd.sponserInfoLabel = sponserInfoLabel
  local zoneLabel = W_CTRL.CreateLabel("zoneLabel", wnd)
  zoneLabel:SetAutoResize(true)
  zoneLabel:SetHeight(FONT_SIZE.LARGE)
  zoneLabel.style:SetAlign(ALIGN_LEFT)
  zoneLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(zoneLabel, FONT_COLOR.MIDDLE_TITLE)
  zoneLabel:AddAnchor("LEFT", commanderInfoLabel, "RIGHT", 32, 0)
  zoneLabel:SetText(locale.nationMgr.siegeRaidZone)
  tempWidth = zoneLabel:GetWidth()
  local stateLabel = W_CTRL.CreateLabel("stateLabel", wnd)
  stateLabel:SetAutoResize(true)
  stateLabel:SetHeight(FONT_SIZE.LARGE)
  stateLabel.style:SetAlign(ALIGN_LEFT)
  stateLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(stateLabel, FONT_COLOR.MIDDLE_TITLE)
  stateLabel:AddAnchor("LEFT", teamInfoLabel, "RIGHT", 32, 0)
  stateLabel:SetText(locale.nationMgr.siegeRaidState)
  if tempWidth < stateLabel:GetWidth() then
    tempWidth = stateLabel:GetWidth()
  end
  local scheduleLabel = W_CTRL.CreateLabel("scheduleLabel", wnd)
  scheduleLabel:SetAutoResize(true)
  scheduleLabel:SetHeight(FONT_SIZE.LARGE)
  scheduleLabel.style:SetAlign(ALIGN_LEFT)
  scheduleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(scheduleLabel, FONT_COLOR.MIDDLE_TITLE)
  scheduleLabel:AddAnchor("LEFT", sponserInfoLabel, "RIGHT", 32, 0)
  scheduleLabel:SetText(locale.nationMgr.siegeRaidSchedule)
  if tempWidth < scheduleLabel:GetWidth() then
    tempWidth = scheduleLabel:GetWidth()
  end
  local zoneInfoLabel = W_CTRL.CreateLabel("zoneInfoLabel", wnd)
  zoneInfoLabel:SetLimitWidth(true)
  zoneInfoLabel:SetExtent(388 - tempWidth - 15, FONT_SIZE.LARGE)
  zoneInfoLabel.style:SetAlign(ALIGN_LEFT)
  zoneInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(zoneInfoLabel, FONT_COLOR.DEFAULT)
  zoneInfoLabel:AddAnchor("LEFT", zoneLabel, "LEFT", tempWidth + 15, 0)
  zoneInfoLabel:SetText("")
  wnd.zoneInfoLabel = zoneInfoLabel
  local stateInfoLabel = W_CTRL.CreateLabel("stateInfoLabel", wnd)
  stateInfoLabel:SetLimitWidth(true)
  stateInfoLabel:SetExtent(388 - tempWidth - 15, FONT_SIZE.LARGE)
  stateInfoLabel.style:SetAlign(ALIGN_LEFT)
  stateInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(stateInfoLabel, FONT_COLOR.DEFAULT)
  stateInfoLabel:AddAnchor("LEFT", stateLabel, "LEFT", tempWidth + 15, 0)
  stateInfoLabel:SetText("")
  wnd.stateInfoLabel = stateInfoLabel
  local scheduleInfoLabel = W_CTRL.CreateLabel("scheduleInfoLabel", wnd)
  scheduleInfoLabel:SetLimitWidth(true)
  scheduleInfoLabel:SetExtent(388 - tempWidth - 15, FONT_SIZE.LARGE)
  scheduleInfoLabel.style:SetAlign(ALIGN_LEFT)
  scheduleInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(scheduleInfoLabel, FONT_COLOR.DEFAULT)
  scheduleInfoLabel:AddAnchor("LEFT", scheduleLabel, "LEFT", tempWidth + 15, 0)
  scheduleInfoLabel:SetText("")
  wnd.scheduleInfoLabel = scheduleInfoLabel
end
local CreateHeroFrame = function(wnd, id, grade)
  local heroBg = wnd:CreateChildWidget("emptywidget", id, 0, true)
  heroBg:SetExtent(220, 161)
  local fightIcon = heroBg:CreateDrawable(TEXTURE_PATH.COMMUNITY_ICON_FIGHT, "icon_fighting", "artwork")
  fightIcon:SetVisible(false)
  fightIcon:AddAnchor("BOTTOM", heroBg, "BOTTOM", 0, 0)
  heroBg.fightIcon = fightIcon
  local heroEmblem = W_ICON.CreateHeroGradeEmblem(heroBg, grade)
  heroEmblem:SetLimitWidth(true)
  heroEmblem:SetExtent(220, FONT_SIZE.LARGE)
  heroEmblem:AddAnchor("BOTTOM", fightIcon, "TOP", 0, -10)
  heroBg.heroEmblem = heroEmblem
  return heroBg
end
local function CreateHeroInfos(wnd, anchor, anchorX, anchorY)
  local heroListBg = wnd:CreateChildWidget("emptywidget", "heroListBg", 0, true)
  heroListBg:AddAnchor("TOPLEFT", anchor, "BOTTOMLEFT", anchorX, anchorY)
  heroListBg:SetExtent(680, 330)
  heroGrade = {}
  heroGrade[1] = CreateHeroFrame(wnd, "heroInfo1", 1)
  heroGrade[1]:AddAnchor("TOPLEFT", heroListBg, "TOPLEFT", 0, 0)
  heroGrade[2] = CreateHeroFrame(wnd, "heroInfo2", 2)
  heroGrade[2]:AddAnchor("LEFT", heroGrade[1], "RIGHT", 8, 0)
  heroGrade[3] = CreateHeroFrame(wnd, "heroInfo3", 3)
  heroGrade[3]:AddAnchor("LEFT", heroGrade[2], "RIGHT", 8, 0)
  heroGrade[4] = CreateHeroFrame(wnd, "heroInfo4", 4)
  heroGrade[4]:AddAnchor("TOPLEFT", heroGrade[1], "BOTTOMLEFT", 0, 10)
  heroGrade[5] = CreateHeroFrame(wnd, "heroInfo5", 5)
  heroGrade[5]:AddAnchor("LEFT", heroGrade[4], "RIGHT", 8, 0)
  heroGrade[6] = CreateHeroFrame(wnd, "heroInfo6", 6)
  heroGrade[6]:AddAnchor("LEFT", heroGrade[5], "RIGHT", 8, 0)
end
local function SetViewOfSiegeRaidTeamTabOfNationMgr(wnd)
  local siegeRaidTeamTitle = W_CTRL.CreateLabel("siegeRaidTeamTitle", wnd)
  siegeRaidTeamTitle:SetExtent(860, FONT_SIZE.XXLARGE)
  siegeRaidTeamTitle.style:SetFontSize(FONT_SIZE.XXLARGE)
  siegeRaidTeamTitle.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(siegeRaidTeamTitle, FONT_COLOR.MIDDLE_TITLE)
  siegeRaidTeamTitle:AddAnchor("TOP", wnd, "TOP", 0, 19)
  siegeRaidTeamTitle:SetText("")
  wnd.siegeRaidTeamTitle = siegeRaidTeamTitle
  local infoBg = wnd:CreateChildWidget("emptywidget", "infoBg", 0, true)
  infoBg:AddAnchor("TOP", siegeRaidTeamTitle, "BOTTOM", 0, 9)
  infoBg:SetExtent(860, 105)
  local bg = infoBg:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", infoBg, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", infoBg, 0, 0)
  local tooltipIcon = W_ICON.CreateGuideIconWidget(wnd)
  tooltipIcon:AddAnchor("TOPRIGHT", infoBg, "TOPRIGHT", -6, 6)
  local OnEnter = function(self)
    SetTargetAnchorTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_info_tip", tostring(X2Player:GetForceAttackLimitLevel())), "TOPLEFT", self, "BOTTOMRIGHT", 0, 0)
  end
  tooltipIcon:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  tooltipIcon:SetHandler("OnLeave", OnLeave)
  CreateInfoLabels(wnd, infoBg)
  local heroListLabel = W_CTRL.CreateLabel("heroListLabel", wnd)
  heroListLabel:SetExtent(778, FONT_SIZE.XLARGE)
  heroListLabel.style:SetFontSize(FONT_SIZE.XLARGE)
  heroListLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(heroListLabel, FONT_COLOR.MIDDLE_TITLE)
  heroListLabel:AddAnchor("TOPLEFT", infoBg, "BOTTOMLEFT", 41, 23)
  heroListLabel:SetText(locale.nationMgr.siegeRaidHeroList)
  CreateHeroInfos(wnd, heroListLabel, 49, 5)
  local refreshButton = wnd:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  refreshButton:AddAnchor("LEFT", heroListLabel, "RIGHT", 10, 0)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  wnd.refreshButton = refreshButton
  local memberListBtn = wnd:CreateChildWidget("button", "memberListBtn", 0, true)
  memberListBtn:Show(true)
  memberListBtn:Enable(false)
  memberListBtn:AddAnchor("BOTTOMLEFT", wnd, "BOTTOMLEFT", 0, 0)
  memberListBtn:SetText(locale.nationMgr.siegeRaidTeamMemberList)
  ApplyButtonSkin(memberListBtn, BUTTON_BASIC.DEFAULT)
  local applyeBtn = wnd:CreateChildWidget("button", "applyeBtn", 0, true)
  applyeBtn:Show(true)
  applyeBtn:Enable(false)
  applyeBtn:AddAnchor("BOTTOMRIGHT", wnd, "BOTTOMRIGHT", 0, 0)
  applyeBtn:SetText(locale.nationMgr.siegeRaidTeamApplicant)
  ApplyButtonSkin(applyeBtn, BUTTON_BASIC.DEFAULT)
end
local IsHeroExistToTeamMember = function(heroName, memberInfo)
  if heroName == nil or memeberInfo == nil then
    return false
  end
  local cnt = #memberInfo
  if cnt <= 0 then
    return false
  end
  for i = 1, cnt do
    if memberInfo[i].name ~= nil and memberInfo[i].name == heroName then
      return true
    end
  end
  return false
end
function CreateSiegeRaidTeamTabOfNationMgr(wnd)
  SetViewOfSiegeRaidTeamTabOfNationMgr(wnd)
  local function UpdateZoneInfo(zoneInfo)
    wnd.commanderInfoLabel:SetText("")
    wnd.teamInfoLabel:SetText("")
    wnd.sponserInfoLabel:SetText("")
    wnd.zoneInfoLabel:SetText("")
    wnd.stateInfoLabel:SetText("")
    wnd.scheduleInfoLabel:SetText("")
    if zoneInfo then
      if zoneInfo.commanderName then
        wnd.commanderInfoLabel:SetText(zoneInfo.commanderName)
      end
      if zoneInfo.memberCnt and zoneInfo.memberMax then
        wnd.teamInfoLabel:SetText(string.format("%d / %d", zoneInfo.memberCnt, zoneInfo.memberMax))
      end
      if zoneInfo.factionId then
        wnd.siegeRaidTeamTitle:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_of_faction", X2Nation:GetNationName(zoneInfo.factionId)))
        if zoneInfo.factionId == OUTLAW_FACTION_ID then
          wnd.sponserInfoLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "outlaw_union_king_name"))
        elseif zoneInfo.factionId == NUIA_FACTION_ID then
          wnd.sponserInfoLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "nuia_union_king_name"))
        elseif zoneInfo.factionId == HARIHARA_FACTION_ID then
          wnd.sponserInfoLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "harihara_union_king_name"))
        end
      end
      if zoneInfo.zoneName then
        wnd.zoneInfoLabel:SetText(zoneInfo.zoneName)
      end
      if zoneInfo.siegeState then
        wnd.stateInfoLabel:SetText(X2Locale:LocalizeUiText(DOMINION, zoneInfo.siegeState))
      else
        wnd.stateInfoLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "no_infomation"))
      end
      if zoneInfo.scheduleInfo then
        local startTime = string.format("%02d:%02d", zoneInfo.scheduleInfo.startHour, zoneInfo.scheduleInfo.startMin)
        local endTime = string.format("%02d:%02d", zoneInfo.scheduleInfo.endHour, zoneInfo.scheduleInfo.endMin)
        wnd.scheduleInfoLabel:SetText(string.format("%s %s ~ %s", GetCommonText(zoneInfo.scheduleInfo.weekDay), startTime, endTime))
      end
    end
  end
  local function UpdateHeroInfo(teamInfo)
    if heroGrade == nil then
      return
    end
    local gradeCnt = #heroGrade
    for i = 1, gradeCnt do
      if heroGrade[i] then
        heroGrade[i].heroEmblem:SetInfo()
      end
    end
    if gradeCnt > MAX_HERO then
      gradeCnt = MAX_HERO
    end
    if teamInfo == nil or teamInfo.zoneInfo == nil or teamInfo.zoneInfo.factionId == nil then
      return
    end
    local heroList = X2Hero:GetHeroList(teamInfo.zoneInfo.factionId)
    if heroList == nil then
      return
    else
      for i = 1, gradeCnt do
        if heroGrade[i] and heroList[i] then
          heroGrade[i].heroEmblem:SetInfo(heroList[i].name)
          heroGrade[i].fightIcon:SetVisible(IsSiegeRaidTeamMember(heroList[i].name))
        end
      end
    end
  end
  local function UpdateButtonState()
    wnd.applyeBtn:Enable(false)
    wnd.memberListBtn:Enable(false)
    if X2Team:IsSiegeRaidTeam() == false and X2Team:IsSiegeRaidTeamRecruit() then
      wnd.applyeBtn:Enable(true)
    end
    if teamInfo and teamInfo.memberInfo then
      wnd.memberListBtn:Enable(true)
    end
  end
  local function UpdateTabInfo()
    if teamInfo == nil then
      UpdateZoneInfo(nil)
      UpdateHeroInfo(nil)
    else
      UpdateZoneInfo(teamInfo.zoneInfo)
      UpdateHeroInfo(teamInfo)
    end
    UpdateButtonState()
  end
  local OnRefresh = function()
    X2Team:RequestSiegeRaidTeamInfo(SIEGE_RAID_TEAM_INFO_BY_FACTION)
    coolTimeGroup.SetGlobalCoolTime()
  end
  wnd.refreshButton:SetHandler("OnClick", OnRefresh)
  coolTimeGroup.RegisterCoolTimeGroupBtn(wnd.refreshButton)
  local OnMemeberList = function()
    ToggleSiegeRaidTeamMemberListWnd()
  end
  wnd.memberListBtn:SetHandler("OnClick", OnMemeberList)
  local OnApplication = function()
    X2Team:SiegeRaidRecruitDetail()
  end
  wnd.applyeBtn:SetHandler("OnClick", OnApplication)
  function wnd:Init()
    UpdateTabInfo()
    if teamInfo == nil then
      OnRefresh()
    end
  end
  function wnd:OnHide()
    HideMemberListWindow()
  end
  local events = {
    SIEGE_RAID_TEAM_INFO = function(info)
      teamInfo = info
      UpdateTabInfo()
    end,
    DOMINION_SIEGE_PERIOD_CHANGED = function(action, zoneGroupType, zoneGroupName, defenseName, offenseName, periodName, isMyInfo, team)
      if periodName == "siege_period_peace" then
        ADDON:ShowContent(UIC_NATION, false)
      end
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
