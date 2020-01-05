local wnd
function ShowExpeditionImmigration(peopleWnd)
  if wnd == nil then
    wnd = SetViewOfExpeditionImmigration("ExpeditionImmigration", peopleWnd)
    wnd:Show(false)
    function wnd:OnShow()
      self.applicantCount:SetText(string.format("%s%d/%d", GetCommonText("immigration_expediton"), 0, 100))
      self.applicantList:DeleteAllDatas()
      enable = X2Nation:IsNationOwner(X2Faction:GetMyTopLevelFaction(), X2Unit:UnitName("player"))
      self.acceptButton:Enable(enable)
      self.rejectButton:Enable(enable)
      X2Nation:SendExpeditionImmigrationList()
    end
    wnd:SetHandler("OnShow", wnd.OnShow)
    function GetCheckExpeditionId()
      local applicantList = wnd.applicantList
      local index = applicantList.pageControl:GetCurrentPageIndex() - 1
      local subItem = applicantList.listCtrl.items[index].subItems[1]
      return subItem.expeditionId
    end
    function wnd.acceptButton:OnClick()
      local expeditionId = GetCheckExpeditionId()
      if expeditionId == nil then
        return
      end
      X2Nation:SendExpeditionImmigrationAccept(expeditionId)
    end
    wnd.acceptButton:SetHandler("OnClick", wnd.acceptButton.OnClick)
    function wnd.rejectButton:OnClick()
      local expeditionId = GetCheckExpeditionId()
      if expeditionId == nil then
        return
      end
      X2Nation:SendExpeditionImmigrationReject(expeditionId)
    end
    wnd.rejectButton:SetHandler("OnClick", wnd.rejectButton.OnClick)
    do
      local events = {
        EXPEDITION_IMMIGRATION_LIST = function(infos)
          local applicantList = wnd.applicantList
          applicantList:DeleteAllDatas()
          applicantList.pageControl:SetCurrentPage(1)
          index = 1
          for i = 1, #infos do
            local info = infos[i]
            index = index + 1
            if index > EXPEDITION_IMMIGRATION_PER_COUNT then
              index = 1
            end
            applicantList:InsertData(i, 1, info)
            applicantList:InsertData(i, 2, tostring(info.level))
            applicantList:InsertData(i, 3, tostring(info.memberCount))
            applicantList:InsertData(i, 4, tostring(info.gearPointAverage))
          end
          local str = string.format("%s %s%d/%d", GetCommonText("immigration_expediton"), FONT_COLOR_HEX.BLUE, #infos, X2Nation:GetMaxExpeditionImmigration())
          wnd.applicantCount:SetText(str)
          wnd.applicantCount:SetWidth(wnd.applicantCount:GetLongestLineWidth() + 10)
          applicantList.pageControl:SetPageByItemCount(#infos, EXPEDITION_IMMIGRATION_PER_COUNT)
        end,
        EXPEDITION_MANAGEMENT_APPLICANT_ACCEPT = function(charId)
          X2Faction:RequestExpeditionApplicantsGet()
        end,
        EXPEDITION_MANAGEMENT_APPLICANT_REJECT = function(charId)
          X2Faction:RequestExpeditionApplicantsGet()
        end
      }
      wnd:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(wnd, events)
    end
  end
  wnd:Show(true)
  return wnd
end
