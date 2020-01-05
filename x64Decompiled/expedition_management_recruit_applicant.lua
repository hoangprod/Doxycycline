local applicantWnd
function ShowApplicantManagemanet(id, parent)
  if applicantWnd == nil then
    applicantWnd = SetViewOfApplicantManagemanet(id, parent)
    applicantWnd:Show(false)
    function applicantWnd:OnShow()
      self.applicantList:DeleteAllDatas()
      self.acceptButton:Enable(false)
      self.rejectButton:Enable(false)
      self.checkAll:SetChecked(false)
      if X2Unit:UnitName("player") == X2Faction:GetMyExpeditionOwnerName() then
        self.acceptButton:Enable(true)
        self.rejectButton:Enable(true)
      end
      X2Faction:RequestExpeditionApplicantsGet()
    end
    applicantWnd:SetHandler("OnShow", applicantWnd.OnShow)
    function applicantWnd.checkAll:CheckBtnCheckChagnedProc()
      local applicantList = applicantWnd.applicantList
      for i = 1, #applicantList.listCtrl.items do
        local subItem = applicantList.listCtrl.items[i].subItems[1]
        subItem.check:SetChecked(self:GetChecked())
      end
    end
    function GetCheckCharIds()
      local applicantList = applicantWnd.applicantList
      local index = (applicantList.pageControl:GetCurrentPageIndex() - 1) * applicantList.pageControl.countPerPage
      local count = 0
      local charIds = {}
      for i = index + 1, #applicantList.listCtrl.items do
        local subItem = applicantList.listCtrl.items[i].subItems[1]
        if subItem.check:GetChecked() then
          count = count + 1
          charIds[count] = subItem.charId
        end
      end
      return charIds
    end
    function applicantWnd.acceptButton:OnClick()
      local charIds = GetCheckCharIds()
      X2Faction:RequestExpeditionApplicantAccept(#charIds, charIds)
    end
    applicantWnd.acceptButton:SetHandler("OnClick", applicantWnd.acceptButton.OnClick)
    function applicantWnd.rejectButton:OnClick()
      local charIds = GetCheckCharIds()
      X2Faction:RequestExpeditionApplicantReject(#charIds, charIds)
    end
    applicantWnd.rejectButton:SetHandler("OnClick", applicantWnd.rejectButton.OnClick)
    do
      local events = {
        EXPEDITION_MANAGEMENT_APPLICANTS = function(infos)
          local applicantList = applicantWnd.applicantList
          applicantList:DeleteAllDatas()
          for i = 1, #infos do
            local info = infos[i]
            applicantList:InsertData(info.charId, 1, info)
            applicantList:InsertData(info.charId, 2, info)
            applicantList:InsertData(info.charId, 3, info.memo)
            applicantList:InsertData(info.charId, 4, string.format("%d.%d.%d", info.year, info.month, info.day))
          end
          local str = string.format("%s : %s%d/%d", GetCommonText("applicant"), FONT_COLOR_HEX.BLUE, #infos, 50)
          applicantWnd.applicantCount:SetText(str)
          applicantWnd.applicantCount:SetWidth(applicantWnd.applicantCount:GetLongestLineWidth() + 10)
          local online, total = X2Faction:GetExpeditionMemberCount()
          local levelInfo = X2Faction:GetExpeditionLevelInfo(X2Faction:GetMyExpeditionLevel())
          local maxMemberCount = levelInfo[3]
          str = string.format("%s : %s%d/%d", GetCommonText("current_member"), FONT_COLOR_HEX.BLUE, total, maxMemberCount)
          applicantWnd.memberCount:SetText(str)
          applicantWnd.memberCount:SetWidth(applicantWnd.memberCount:GetLongestLineWidth() + 10)
          applicantList.pageControl:SetPageByItemCount(#infos, APPLICANT_PER_COUNT)
        end,
        EXPEDITION_MANAGEMENT_APPLICANT_ACCEPT = function(charId)
          X2Faction:RequestExpeditionApplicantsGet()
        end,
        EXPEDITION_MANAGEMENT_APPLICANT_REJECT = function(charId)
          X2Faction:RequestExpeditionApplicantsGet()
        end
      }
      applicantWnd:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(applicantWnd, events)
    end
  end
  applicantWnd:Show(true)
  return applicantWnd
end
