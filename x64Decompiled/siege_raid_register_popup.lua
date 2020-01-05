local SiegeRaidRegisterWnd
function UpdateRegisterList(wnd, zoneGroup)
  if wnd == nil or zoneGroup == nil then
    if wnd ~= nil then
      wnd.refreshBtn:Enable(true)
      wnd.dominionList.content:EnableSelectParent(true)
    end
    return
  end
  local isRegist = false
  local myId = X2Unit:GetUnitId("player")
  local infoList = X2Team:RequestSiegeRaidRegisterInfo(zoneGroup)
  if infoList ~= nil then
    for i = 1, #infoList do
      if infoList[i].charId == myId then
        isRegist = true
      end
    end
  end
  wnd.registerBtn:SetVisible(not isRegist)
  wnd.registerBtn:Enable(not isRegist)
  wnd.unregisterBtn:SetVisible(isRegist)
  wnd.unregisterBtn:Enable(isRegist)
end
function UpdateSelectSiegeRaidZoneRegisterInfo(wnd, selectZoneType)
  if IsSelectedZone(selectZoneType) then
    return
  end
  SetSelectZoneType(selectZoneType)
  if selectZoneType == nil or selectZoneType == 0 then
    HideRegistListWnd(wnd)
    AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "siege_raid_invalid_zone"))
    return
  end
  UpdateRegisterListItems(wnd, selectZoneType)
end
function ShowSiegeRaidRegisterWnd(parent)
  local wnd = SetViewOfSiegeRaidRegisterWnd(parent)
  local function InitWnd(zoneType)
    UpdateDominionListItems(wnd, zoneType)
  end
  local function NoticeErrorMsg(errMsg)
    local function DialogErrorHandler(popWnd)
      popWnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_message"))
      popWnd:SetContent(X2Locale:LocalizeUiText(ERROR_MSG, errMsg))
    end
    X2DialogManager:RequestNoticeDialog(DialogErrorHandler, wnd:GetId())
  end
  local function CheckRegisterState(state)
    if state == nil then
      return
    end
    local result = RequestRegisterState(state)
    if result ~= nil and result == true then
      wnd.registerBtn:Enable(false)
      wnd.unregisterBtn:Enable(false)
    end
  end
  local function WarningUnregister()
    local function DialogHandler(popWnd)
      function popWnd:OkProc()
        popWnd:Show(false)
        CheckRegisterState(false)
      end
      popWnd:SetTitle(locale.siegeRaid.unregisterDlgTitle)
      local factionId = X2Dominion:GetOwnerFaction(GetSelectZoneType())
      local myFactionId = X2Faction:GetMyTopLevelFaction()
      if factionId == myFactionId then
        popWnd:SetContent(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_unregister_dlg_desc", GetCommonText("siege_raid_defender_commander")))
      else
        popWnd:SetContent(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_unregister_dlg_desc", GetCommonText("siege_raid_attacker_commander")))
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, wnd:GetId())
  end
  function NoticeRegisterSuccess()
    local DialogNoticeHandler = function(popWnd)
      popWnd:SetTitle(locale.siegeRaid.registerDlgTitle)
      popWnd:SetContent(locale.siegeRaid.registerDlgDesc)
    end
    X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, wnd:GetId())
  end
  function wnd:ShowProc()
    SetSelectZoneType(0)
    wnd.dominionInfoWnd.dominionList:ClearAllSelected()
    InitWnd(GetSelectZoneType())
    X2Team:RequestSiegeRaidRegisterList()
  end
  function wnd:OnUpdate()
    if wnd.remainTimeMsg and wnd.remainTimeMsg:IsVisible() then
      UpdateRemaindTimer(wnd)
    end
  end
  function wnd.dominionInfoWnd.dominionList:OnSelChanged()
    local value = self:GetSelectedValue()
    if value ~= nil and value > 0 then
      UpdateSelectSiegeRaidZoneRegisterInfo(wnd, value)
    else
      local preSel = GetSelectZoneType()
      if preSel > 0 then
        wnd.dominionInfoWnd.dominionList.content:SelectWithValue(preSel, false)
      else
        SetSelectZoneType(0)
        HideRegistListWnd(wnd)
        wnd.dominionInfoWnd.dominionList:ClearAllSelected()
      end
    end
  end
  local function OnRegisterClick()
    CheckRegisterState(true)
  end
  wnd.registerBtn:SetHandler("OnClick", OnRegisterClick)
  local function OnUnregisterClick()
    WarningUnregister()
  end
  wnd.unregisterBtn:SetHandler("OnClick", OnUnregisterClick)
  local events = {
    INTERACTION_END = function()
      wnd:Show(false)
    end,
    SIEGE_RAID_REGISTER_LIST = function(zoneGroupType, bRegistState, bListUpdate)
      if bListUpdate then
        UpdateDominionListItems(wnd, GetSelectZoneType())
      else
        if zoneGroupType == nil then
          SiegeRaidRegisterWnd:Show(false)
        end
        if zoneGroupType ~= nil and bRegistState ~= nil and zoneGroupType ~= 0 and bRegistState == true then
          NoticeRegisterSuccess()
        end
        if GetSelectZoneType() == zoneGroupType then
          UpdateDominionListItems(wnd, zoneGroupType)
        end
      end
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
function ToggleSiegeRaidRegisterWnd()
  if SiegeRaidRegisterWnd == nil then
    SiegeRaidRegisterWnd = ShowSiegeRaidRegisterWnd("UIParent")
  end
  SiegeRaidRegisterWnd:Show(not SiegeRaidRegisterWnd:IsVisible())
end
ADDON:RegisterContentTriggerFunc(UIC_SIEGE_RAID_REGISTER_WND, ToggleSiegeRaidRegisterWnd)
