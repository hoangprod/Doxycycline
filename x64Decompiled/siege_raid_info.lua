local selectZoneType = 0
local UpdateHeroGradeIcon = function(wnd, ranking)
  if wnd ~= nil then
    local gradeKey
    if ranking == 1 then
      gradeKey = "level_01"
    elseif ranking == 2 or ranking == 3 then
      gradeKey = "level_02"
    elseif ranking >= 4 and ranking <= 6 then
      gradeKey = "level_03"
    end
    if gradeKey ~= nil then
      wnd.gradeBg:SetVisible(true)
      wnd.gradeBg:SetTextureInfo(gradeKey)
    end
  end
end
local ToggleRegisterShowState = function(wnd, activeRegisterBtn)
  wnd.registerBtn:Show(activeRegisterBtn)
  wnd.registerBtn:Enable(activeRegisterBtn)
  wnd.unregisterBtn:Show(not activeRegisterBtn)
  wnd.unregisterBtn:Enable(not activeRegisterBtn)
end
function SetSelectZoneType(zoneType)
  selectZoneType = zoneType
end
function GetSelectZoneType()
  return selectZoneType
end
function IsSelectedZone(zoneType)
  if selectZoneType == zoneType then
    return true
  end
  return false
end
function FindMyRegistSiegeZone()
  selectZoneType = X2Team:FindMyRegisterSiegeZoneGroupType()
end
function RequestRegisterState(state)
  if selectZoneType ~= nil and state ~= nil and selectZoneType > 0 then
    return X2Team:RequestSiegeRaidMasterRegisterState(selectZoneType, state)
  end
  AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "siege_raid_invalid_zone"))
  return false
end
function UpdateRemaindTimer(wnd)
  if wnd.remainTimeMsg == nil then
    return
  end
  local remainDate = X2Dominion:GetCurPeriodRemainDate(selectZoneType)
  if remainDate == nil then
    wnd.remainTimeMsg:Show(false)
    wnd:ReleaseHandler("OnUpdate")
  else
    local filter = FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
    local tStr = locale.time.GetRemainDate(0, 0, 0, remainDate.hour, remainDate.minute, 0, filter)
    wnd.remainTimeMsg:SetText(GetCommonText("siege_raid_register_remain_time", tStr))
  end
end
function UpdateDominionListItems(wnd, zoneType)
  if wnd == nil then
    return
  end
  local defaultSelZone = 0
  local myRegist = false
  local listWnd = wnd.dominionInfoWnd.dominionList
  local dataList = X2Team:GetSiegeRaidZoneList()
  if dataList == nil then
    listWnd:ClearItem()
  else
    local infos = {}
    for i = 1, #dataList do
      infos[i] = {}
      infos[i].text = dataList[i].text
      infos[i].value = dataList[i].value
      if 0 < infos[i].value then
        infos[i].defaultColor = FONT_COLOR.DEFAULT
        infos[i].selectColor = FONT_COLOR.BLUE
        infos[i].overColor = FONT_COLOR.BLUE
        if defaultSelZone <= 0 then
          defaultSelZone = infos[i].value
        end
      else
        infos[i].defaultColor = FONT_COLOR.GRAY
        infos[i].selectColor = FONT_COLOR.GRAY
        infos[i].overColor = FONT_COLOR.GRAY
      end
      infos[i].useColor = true
      if dataList[i].myRegist then
        infos[i].iconPath = TEXTURE_PATH.SIEGE_RAID
        infos[i].infoKey = "icon_me"
        myRegist = true
        defaultSelZone = infos[i].value
      end
    end
    listWnd:SetItemTrees(infos)
  end
  if zoneType ~= nil and zoneType > 0 then
    defaultSelZone = zoneType
  end
  if defaultSelZone > 0 then
    UpdateRegisterListItems(wnd, defaultSelZone)
    SetSelectZoneType(defaultSelZone)
    wnd.dominionInfoWnd.dominionList.content:SelectWithValue(defaultSelZone, false)
  else
    HideRegistListWnd(wnd)
  end
end
function UpdateRegisterListItems(wnd, selectZoneType)
  if selectZoneType == nil then
    selectZoneType = 0
  end
  if selectZoneType == 0 then
    HideRegistListWnd(wnd)
    return
  end
  if wnd == nil or wnd.registerInfoWnd == nil or wnd.registerInfoWnd.registerlistCtrl == nil then
    return
  end
  local listWnd = wnd.registerInfoWnd.registerlistCtrl
  wnd.subTitle:Show(true)
  wnd.subTitle:SetText(locale.siegeRaid.notVolunteerPeriod)
  local myName = X2Unit:UnitName("player")
  local myRegisterState = false
  local updateCnt = 0
  local userInfos = X2Team:RequestSiegeRaidRegisterInfo(selectZoneType)
  if userInfos ~= nil then
    updateCnt = #userInfos
  end
  if updateCnt > #listWnd.items then
    updateCnt = #listWnd.items
  end
  local commanderName = ""
  local factionId = X2Dominion:GetOwnerFaction(selectZoneType)
  local myFactionId = X2Faction:GetMyTopLevelFaction()
  if factionId == myFactionId then
    wnd.subTitle:SetText(GetCommonText("siege_raid_register_window_desc", X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_defender_commander")))
  else
    wnd.subTitle:SetText(GetCommonText("siege_raid_register_window_desc_atk", X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_attacker_commander")))
  end
  wnd.remainTimeMsg:Show(true)
  wnd:SetHandler("OnUpdate", wnd.OnUpdate)
  UpdateRemaindTimer(wnd)
  local period = X2Dominion:GetCurSiegePeriodName(selectZoneType)
  if period == "siege_period_ready_to_siege" then
    listWnd:Show(false)
    wnd.registerInfoWnd.emptyRegisterList:Show(true)
    local isCreateTeam = X2Team:IsCreateAlreadySiegeRaidTeam()
    wnd.registerBtn:Show(true)
    if isCreateTeam then
      wnd.registerInfoWnd.emptyRegisterList:SetText(locale.siegeRaid.alreadyCreateSiegeRaidTeamReadySiege)
      wnd.registerBtn:Enable(false)
    else
      wnd.registerInfoWnd.emptyRegisterList:SetText(locale.siegeRaid.supportSiegeRaidTeamReadySiege)
      wnd.registerBtn:Enable(true)
    end
    if X2Hero:IsHero() == false or X2Dominion:CanUpdateSiegeSchedule() == false then
      wnd.registerBtn:Enable(false)
    end
    wnd.unregisterBtn:Enable(false)
    wnd.unregisterBtn:Show(false)
    return
  end
  if updateCnt <= 0 then
    listWnd:Show(false)
    wnd.registerInfoWnd.emptyRegisterList:Show(true)
    wnd.registerInfoWnd.emptyRegisterList:SetText(locale.siegeRaid.registersEmptyDesc)
  else
    listWnd:Show(true)
    wnd.registerInfoWnd.emptyRegisterList:Show(false)
    for i = 1, #listWnd.items do
      if updateCnt >= i then
        if userInfos[i].commander then
          listWnd.items[i].subItems[1].commanderBg:SetVisible(userInfos[i].commander)
          listWnd.items[i].subItems[1]:SetText("")
        else
          listWnd.items[i].subItems[1].commanderBg:SetVisible(false)
          listWnd.items[i].subItems[1]:SetText(locale.siegeRaid.registerReserve)
        end
        UpdateHeroGradeIcon(listWnd.items[i].subItems[2], userInfos[i].ranking)
        listWnd.items[i].subItems[3]:SetText(userInfos[i].name)
        if userInfos[i].name ~= nil and myName ~= nil and userInfos[i].name == myName then
          myRegisterState = true
        end
      else
        listWnd.items[i].subItems[1]:SetText("")
        listWnd.items[i].subItems[1].commanderBg:SetVisible(false)
        listWnd.items[i].subItems[2].gradeBg:SetVisible(false)
        listWnd.items[i].subItems[3]:SetText("")
      end
    end
  end
  if X2Hero:IsHero() then
    ToggleRegisterShowState(wnd, not myRegisterState)
  else
    wnd.registerBtn:Enable(false)
    wnd.registerBtn:Show(true)
    wnd.unregisterBtn:Enable(false)
    wnd.unregisterBtn:Show(false)
  end
end
function HideRegistListWnd(wnd)
  if wnd == nil then
    return
  end
  wnd.registerBtn:Enable(false)
  wnd.registerBtn:Show(true)
  wnd.unregisterBtn:Enable(false)
  wnd.unregisterBtn:Show(false)
  wnd.subTitle:Show(false)
  wnd.remainTimeMsg:Show(false)
  wnd.registerInfoWnd.registerlistCtrl:Show(false)
  wnd.registerInfoWnd.emptyRegisterList:Show(false)
  wnd:ReleaseHandler("OnUpdate")
end
