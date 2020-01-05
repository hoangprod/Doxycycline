RaidApplicantAccept = nil
function ShowRaidApplicantAccept(info)
  local wnd = RaidApplicantAccept
  if RaidApplicantAccept == nil then
    wnd = SetViewOfRaidApplicantAccept()
    RaidApplicantAccept = wnd
  end
  wnd:Show(true)
  if RaidRecruit.waitApplicantAccept == false then
    RaidRecruit:EventButtonToggle(false)
  end
  RaidRecruit.waitApplicantAccept = true
  local showTime = 60000
  local alreadyRequest = false
  function wnd:OnHide()
    if false == alreadyRequest then
      X2Team:RaidApplicantAcceptReply(info.ownerId, false)
    end
    RaidRecruit.waitApplicantAccept = false
    RaidRecruit:EventButtonToggle(true)
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  function SetInfo(info)
    if info.isSiegeRaidTeam then
      wnd:SetTitle(GetCommonText("siege_raid_join"))
      wnd.recruitTypeLabal:SetText(GetCommonText("siege_raid_join_question"))
      wnd.subTypeTextbox:SetText(GetCommonText("siege_raid_type"))
    else
      wnd:SetTitle(GetCommonText("raid_join"))
      wnd.recruitTypeLabal:SetText(GetCommonText("raid_join_question"))
      wnd.subTypeTextbox:SetText(GetCommonText("raid_type"))
    end
    wnd.subType:SetText(info.subTypeName)
    wnd.requireLevel:SetText(GetLevelToString(info.subTypeLevel, nil, nil, true))
    wnd.departureTime:SetText(locale.time.GetDateToDateFormat(info, FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE):match("^%s*(.-)%s*$"))
    wnd.ownerLevel:SetText(GetLevelToString(info.ownerLevel, nil, nil, true))
    wnd.ownerName:SetText(info.ownerName)
  end
  function OnUpdate(self, dt)
    showTime = showTime - dt
    if showTime < 0 then
      showTime = 0
      wnd:Show(false)
    end
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
  function OkButtonClick()
    alreadyRequest = true
    X2Team:RaidApplicantAcceptReply(info.ownerId, true)
    wnd:Show(false)
  end
  wnd.okButton:SetHandler("OnClick", OkButtonClick)
  function CancelButtonClick()
    wnd:Show(false)
  end
  wnd.cancelButton:SetHandler("OnClick", CancelButtonClick)
  local events = {
    LEFT_LOADING = function()
      wnd:Show(false)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  SetInfo(info)
end
