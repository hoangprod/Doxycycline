local SQUAD_EVENT_BUTTON_TYPE = {
  APPLY = 1,
  READY = 2,
  READY_CANCEL = 3,
  ENTER = 4
}
function ShowSquadWindow(parent)
  local wnd = SetViewOfSquad("squadWnd", parent)
  local function Update()
    wnd.list:DeleteAllDatas()
    local data = X2Squad:GetMySquadInfo()
    if data == nil then
      return
    end
    for i = 1, #data do
      do
        local info = data[i]
        wnd.list:InsertData(i, 1, info)
        wnd.list:InsertData(i, 2, info)
        wnd.list:InsertData(i, 3, info)
        wnd.list:InsertData(i, 4, info)
        wnd.list:InsertData(i, 5, info)
        local item = wnd.list.listCtrl.items[i]
        function item:OnClick(arg)
          if arg == "RightButton" then
            local data = wnd.list:GetDataByViewIndex(i, 1)
            ActivateSquadMemberPopupMenu(wnd, self, data.isMe, data.worldId, data.charId, data.name)
          end
        end
        item:SetHandler("OnClick", item.OnClick)
      end
    end
    wnd.openTypeRadioBoxes:Enable(data.isLeader)
    wnd.openTypeRadioBoxes:Check(data.openType, false)
    if data.isJoining then
      wnd.eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.ENTER
      wnd.eventButton:SetText(GetCommonText("indun_entrance"))
      wnd.eventButton:Enable(true)
    elseif data.isReady then
      wnd.eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.READY_CANCEL
      wnd.eventButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "cancel"))
      wnd.eventButton:Enable(true)
    elseif data.isLeader then
      wnd.eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.APPLY
      wnd.eventButton:SetText(GetCommonText("squad_info_apply_matching"))
      wnd.eventButton:Enable(data.isAllReady)
    else
      wnd.eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.READY
      wnd.eventButton:SetText(GetCommonText("squad_info_ready"))
      wnd.eventButton:Enable(true)
    end
    wnd.disbandSquadButton:Show(data.isLeader)
    wnd.list.pageControl:SetPageByItemCount(#data, SQUAD_PER_COUNT)
    wnd.subTitleBox.subTitle:SetText(data.fieldName)
    wnd.squadCount:SetText(string.format("%s : %s%d / %d", GetCommonText("squad_info_count"), FONT_COLOR_HEX.BLUE, data.curMemberCount, data.maxMemberCount))
    wnd.squadCount:SetExtent(wnd.squadCount:GetLongestLineWidth() + 15, 28)
  end
  function wnd:ToggleSquadWindow()
    if not X2Player:GetFeatureSet().squad or not UIParent:GetPermission(UIC_SQUAD) or not X2Squad:HasMySquad() then
      return
    end
    local isVisible = self:IsVisible()
    isVisible = not isVisible
    self:Show(isVisible)
  end
  function wnd:OnShow()
    Update()
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  local events = {
    UPDATE_SQUAD = function()
      Update()
    end,
    SHOW_SQUAD_WINDOW = function(show)
      wnd:Show(show)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  local function RefreshSquad()
    Update()
  end
  ButtonOnClickHandler(wnd.refreshButton, RefreshSquad)
  local DisbandSquad = function()
    X2Squad:DisbandSquad()
  end
  ButtonOnClickHandler(wnd.disbandSquadButton, DisbandSquad)
  local LeaveSquad = function()
    X2Squad:LeaveSquad()
  end
  ButtonOnClickHandler(wnd.leaveSquadButton, LeaveSquad)
  local function EventSquadButton()
    if wnd.eventButton.buttonType == SQUAD_EVENT_BUTTON_TYPE.APPLY then
      X2Squad:ApplySquadMatching()
    elseif wnd.eventButton.buttonType == SQUAD_EVENT_BUTTON_TYPE.READY then
      X2Squad:ReadySquad()
    elseif wnd.eventButton.buttonType == SQUAD_EVENT_BUTTON_TYPE.READY_CANCEL then
      X2Squad:ReadySquad()
    elseif wnd.eventButton.buttonType == SQUAD_EVENT_BUTTON_TYPE.ENTER then
      X2Squad:EnterSquadMatching()
    end
  end
  ButtonOnClickHandler(wnd.eventButton, EventSquadButton)
  UIParent:LogAlways("Squad Window Created!!")
  return wnd
end
squadWnd = ShowSquadWindow("UIParent")
squadWnd:SetSounds("battlefield_entrance")
ADDON:RegisterContentWidget(UIC_SQUAD, squadWnd)
