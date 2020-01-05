function ShowRaidApplicantList(parent)
  local wnd = SetViewOfRaidApplicantList(parent)
  function wnd:UpdateCheckButton()
    local enableButton = false
    for i = 1, #wnd.list.listCtrl.items do
      local subItem = wnd.list.listCtrl.items[i].subItems[1]
      if subItem.check:IsVisible() and subItem.check:GetChecked() then
        enableButton = true
      end
    end
    wnd.rejectButton:Enable(enableButton)
    wnd.acceptButton:Enable(enableButton)
  end
  function wnd:ShowProc()
    X2Team:RaidApplicantList()
    self.list:DeleteAllDatas()
    self.joinRadioBoxes:Enable(false)
    self.checkAll:SetChecked(false)
    self.rejectButton:Enable(false)
    self.acceptButton:Enable(false)
  end
  function wnd.checkAll:CheckBtnCheckChagnedProc()
    for i = 1, #wnd.list.listCtrl.items do
      local subItem = wnd.list.listCtrl.items[i].subItems[1]
      subItem.check:SetChecked(self:GetChecked())
    end
  end
  function GetCheckCharIds()
    local index = (wnd.list.pageControl:GetCurrentPageIndex() - 1) * wnd.list.pageControl.countPerPage
    local count = 0
    local charIds = {}
    for i = index + 1, #wnd.list.listCtrl.items do
      local subItem = wnd.list.listCtrl.items[i].subItems[1]
      if subItem.check:GetChecked() then
        count = count + 1
        charIds[count] = subItem.charId
      end
    end
    return charIds
  end
  function wnd.joinRadioBoxes:OnRadioChanged(index, dataValue)
    if X2Team:IsSiegeRaidTeam() then
      return
    end
    X2Team:RaidRecruitOption(index == 1)
  end
  wnd.joinRadioBoxes:SetHandler("OnRadioChanged", wnd.joinRadioBoxes.OnRadioChanged)
  function wnd.refreshButton:OnClick()
    X2Team:RaidApplicantList()
  end
  wnd.refreshButton:SetHandler("OnClick", wnd.refreshButton.OnClick)
  function wnd.acceptButton:OnClick()
    local charIds = GetCheckCharIds()
    X2Team:RaidApplicantAccept(#charIds, charIds)
  end
  wnd.acceptButton:SetHandler("OnClick", wnd.acceptButton.OnClick)
  function wnd.rejectButton:OnClick()
    local charIds = GetCheckCharIds()
    X2Team:RaidApplicantReject(#charIds, charIds)
  end
  wnd.rejectButton:SetHandler("OnClick", wnd.rejectButton.OnClick)
  local events = {
    RAID_APPLICANT_LIST = function(total, data)
      wnd.joinRadioBoxes:Check(1, false)
      if data.autoJoin == false then
        wnd.joinRadioBoxes:Check(2, false)
      end
      if X2Team:IsSiegeRaidTeam() then
        wnd.joinRadioBoxes:Check(2, false)
        wnd.joinRadioBoxes:Enable(false)
      elseif X2Team:IsRaidTeam() == true then
        local IsTeamOwner = X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex())
        local IsTeamOfficer = X2Team:IsMyTeamOwner(X2Team:GetTeamPlayerIndex())
        if IsTeamOwner == false and IsTeamOfficer == false then
          wnd.joinRadioBoxes:Enable(false)
          data.memberCount = 1
        else
          wnd.joinRadioBoxes:Enable(#data == 0)
        end
      else
        wnd.joinRadioBoxes:Enable(#data == 0)
        data.memberCount = 1
      end
      wnd.applicantCount:SetText(string.format("%s:%s %d / %d", GetCommonText("raid_volume_recruitment"), FONT_COLOR_HEX.BLUE, data.memberCount, data.headcount))
      wnd.list:DeleteAllDatas()
      for i = 1, #data do
        local info = data[i]
        wnd.list:InsertData(i, 1, info)
        wnd.list:InsertData(i, 2, info)
        wnd.list:InsertData(i, 3, info)
        wnd.list:InsertData(i, 4, info)
      end
      wnd.list.pageControl:SetPageByItemCount(total, RAID_APPLICANT_PER_COUNT)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
