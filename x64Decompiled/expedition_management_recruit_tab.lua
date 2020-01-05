local RETAIN_SCROLL = false
local PREV_PAGE = 0
local PREV_SCROLL_VALUE = 0
local function SetValue(page, scrollValue)
  RETAIN_SCROLL = true
  PREV_PAGE = page
  PREV_SCROLL_VALUE = scrollValue
end
local function GetValue()
  return RETAIN_SCROLL, PREV_PAGE, PREV_SCROLL_VALUE
end
local function InitValue()
  RETAIN_SCROLL = false
  PREV_PAGE = 0
  PREV_SCROLL_VALUE = 0
end
function CreateRecruit(id, wnd)
  SetViewOfRecruit(id, wnd)
  local recruitWnd = wnd
  local function RequestExpeditionRecruitments(page, retainScroll)
    if recruitWnd.check:GetChecked() then
      X2Faction:RequestExpeditionMyRecruitmentsGet()
      return
    end
    if page == nil then
      page = recruitWnd.recruitmentList:GetCurrentPageIndex() - 1
    end
    if retainScroll then
      SetValue(recruitWnd.recruitmentList:GetCurrentPageIndex(), recruitWnd.recruitmentList:GetTopDataIndex())
    end
    local info = {}
    info[1] = page
    info[2] = tonumber(recruitWnd.minLevelEdit:GetText())
    info[3] = tonumber(recruitWnd.maxLevelEdit:GetText())
    info[4] = recruitWnd.expeditionName:GetText()
    info[5] = recruitWnd.comboBox:GetSelectedIndex()
    local interest = {}
    local IR = GetInterestList()
    for i = 1, #IR do
      if recruitWnd.InterestWnd then
        local check = recruitWnd.InterestWnd.interestChks[i]
        if check:GetChecked() then
          interest[i] = 1
        else
          interest[i] = 0
        end
      else
        interest[i] = 1
      end
    end
    info[6] = interest
    X2Faction:RequestExpeditionRecruitmentsGet(info)
  end
  function recruitWnd:ShowWindow()
    RequestExpeditionRecruitments(1)
  end
  function recruitWnd:HideWindow()
    if recruitWnd.recruitmentWnd then
      recruitWnd.recruitmentWnd:Show(false)
    end
    if recruitWnd.applicantWnd then
      recruitWnd.applicantWnd:Show(false)
    end
    if recruitWnd.applyWnd then
      recruitWnd.applyWnd:Show(false)
    end
    if recruitWnd.eventWnd then
      recruitWnd.eventWnd:Show(false)
    end
  end
  function recruitWnd:OnShow()
    self.recruitmentButton:Show(false)
    self.applicantManagementButton:Enable(false)
    self.check.textButton:SetText(GetCommonText("look_my_recruit"))
    if X2Faction:GetMyExpeditionId() == 0 then
      self.check.textButton:SetText(GetCommonText("look_my_apply"))
      RequestExpeditionRecruitments(1)
      return
    end
    if X2Faction:IsMyRoleExpeditionOwner() == true then
      self.recruitmentButton:Show(true)
      self.applicantManagementButton:Enable(true)
    else
      self.applicantManagementButton:Enable(true)
    end
  end
  recruitWnd:SetHandler("OnShow", recruitWnd.OnShow)
  function recruitWnd.check:OnCheckChanged()
    recruitWnd.searchButton:Enable(not self:GetChecked())
    RequestExpeditionRecruitments(1)
  end
  recruitWnd.check:SetHandler("OnCheckChanged", recruitWnd.check.OnCheckChanged)
  function recruitWnd.initButton:OnClick()
    recruitWnd.minLevelEdit:SetText(tostring(1))
    recruitWnd.maxLevelEdit:SetText(tostring(X2Faction:GetExpeditionMaxLevel()))
    recruitWnd.expeditionName:SetText("")
    recruitWnd.comboBox:Select(1)
    if recruitWnd.InterestWnd then
      local IR = GetInterestList()
      for i = 1, #IR do
        local check = recruitWnd.InterestWnd.interestChks[i]
        check:SetChecked(true)
      end
      recruitWnd:SetInterestOption()
    end
    RequestExpeditionRecruitments(1)
  end
  recruitWnd.initButton:SetHandler("OnClick", recruitWnd.initButton.OnClick)
  function recruitWnd.interestButton:OnClick()
    ShowInterestWnd(self)
  end
  recruitWnd.interestButton:SetHandler("OnClick", recruitWnd.interestButton.OnClick)
  function recruitWnd.expeditionName:OnKeyUp(arg)
    if recruitWnd.searchButton:IsEnabled() == false then
      return
    end
    if arg == "enter" then
      RequestExpeditionRecruitments(1)
    end
  end
  recruitWnd.expeditionName:SetHandler("OnKeyUp", recruitWnd.expeditionName.OnKeyUp)
  function recruitWnd.searchButton:OnClick()
    RequestExpeditionRecruitments(1)
  end
  recruitWnd.searchButton:SetHandler("OnClick", recruitWnd.searchButton.OnClick)
  function recruitWnd.recruitmentButton:OnClick()
    recruitWnd.recruitmentWnd = ShowRecruitment("recruitment", recruitWnd)
  end
  recruitWnd.recruitmentButton:SetHandler("OnClick", recruitWnd.recruitmentButton.OnClick)
  function recruitWnd.applicantManagementButton:OnClick()
    recruitWnd.applicantWnd = ShowApplicantManagemanet("ApplicantManagemanet", recruitWnd)
  end
  recruitWnd.applicantManagementButton:SetHandler("OnClick", recruitWnd.applicantManagementButton.OnClick)
  function recruitWnd:OnVisibleChanged(visible)
    if visible then
      RequestExpeditionRecruitments(1)
    end
  end
  recruitWnd:SetHandler("OnVisibleChanged", recruitWnd.OnVisibleChanged)
  function recruitWnd.recruitmentList.pageControl:OnPageChanged(pageIndex, countPerPage)
    RequestExpeditionRecruitments(pageIndex)
  end
  function recruitWnd:SetInterestOption()
    local lastIcon
    local IR = GetInterestList()
    for i = 1, #IR do
      local icon = self.interestIcon[i]
      icon:Show(false)
      icon:RemoveAllAnchors()
      local check = self.InterestWnd.interestChks[i]
      if check:GetChecked() == true then
        icon:Show(true)
        if lastIcon == nil then
          icon:AddAnchor("LEFT", self.interestButton, "RIGHT", 10, 0)
        else
          icon:AddAnchor("LEFT", lastIcon, "RIGHT", 0, 0)
        end
        lastIcon = icon
      end
    end
    if nil == lastIcon then
      lastIcon = recruitWnd.interestButton
    end
    recruitWnd.interestBg:RemoveAllAnchors()
    recruitWnd.interestBg:AddAnchor("TOPLEFT", recruitWnd.interestButton, "TOPLEFT", -14, -9)
    recruitWnd.interestBg:AddAnchor("BOTTOMRIGHT", lastIcon, "BOTTOMRIGHT", 14, 9)
  end
  function ShowInterestWnd(anchorWnd)
    if recruitWnd.InterestWnd == nil then
      recruitWnd.InterestWnd = CreateExpeditionInterestWnd("recruitWnd.InterestWnd", recruitWnd)
      recruitWnd.InterestWnd:Show(false)
      recruitWnd.InterestWnd:AddAnchor("TOPLEFT", anchorWnd, "TOPRIGHT", 0, 0)
      for i = 1, #recruitWnd.InterestWnd.interestChks do
        local chk = recruitWnd.InterestWnd.interestChks[i]
        chk:SetChecked(true)
      end
    end
    function recruitWnd.InterestWnd:OnHide()
      recruitWnd:SetInterestOption()
    end
    recruitWnd.InterestWnd:SetHandler("OnHide", recruitWnd.InterestWnd.OnHide)
    recruitWnd.InterestWnd:Show(not recruitWnd.InterestWnd:IsVisible())
  end
  function ShowEventButtonWnd(subItem)
    if subItem.buttonType == BUTTON_TYPE.APPLY then
      recruitWnd.applyWnd = ShowApply(recruitWnd, subItem)
      return
    end
    local function DialogHandler(wnd)
      if subItem.buttonType == BUTTON_TYPE.APPLY_CANCEL then
        wnd:SetTitle(GetCommonText("apply_cancel_title"))
        wnd:SetContent(GetCommonText("apply_cancel_question"))
        function wnd:OkProc()
          X2Faction:RequestExpeditionApplicantDel(subItem.expeditionId)
        end
      elseif subItem.buttonType == BUTTON_TYPE.RECRUITMENT_CANCEL then
        ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_SEPERATE_TEXT)
        wnd:SetTextColor(FONT_COLOR.DEFAULT, FONT_COLOR.GRAY)
        wnd:SetTextSize(FONT_SIZE.LARGE, FONT_SIZE.MIDDLE)
        wnd:SetTitle(GetCommonText("recruitment_del_title"))
        wnd:SetContent(GetCommonText("recruitment_del_question"), GetCommonText("recruitment_del_notice"))
        function wnd:OkProc()
          X2Faction:RequestExpeditionRecruitmentDel()
        end
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, subItem:GetId())
  end
  local recruitmentList = recruitWnd.recruitmentList
  local events = {
    EXPEDITION_MANAGEMENT_RECRUITMENTS = function(total, perPageItemCount, infos)
      recruitmentList:DeleteAllDatas()
      for i = 1, #infos do
        local info = infos[i]
        recruitmentList:InsertData(info.expeditionId, 1, info)
      end
      recruitmentList:SetPageByItemCount(total, perPageItemCount)
      local retainScroll, page, scrollValue = GetValue()
      if retainScroll then
        recruitmentList.pageControl:SetCurrentPage(page, false)
        recruitmentList:SetTopDataIndex(scrollValue)
      end
      InitValue()
    end,
    EXPEDITION_MANAGEMENT_RECRUITMENT_ADD = function(info)
      recruitWnd.check:SetChecked(false)
      recruitWnd.searchButton:Enable(true)
      RequestExpeditionRecruitments(1)
    end,
    EXPEDITION_MANAGEMENT_RECRUITMENT_DEL = function(expeditionId)
      recruitWnd.check:SetChecked(false)
      recruitWnd.searchButton:Enable(true)
      RequestExpeditionRecruitments()
    end,
    EXPEDITION_MANAGEMENT_APPLICANT_ADD = function(expeditionId)
      recruitWnd.check:SetChecked(false)
      recruitWnd.searchButton:Enable(true)
      RequestExpeditionRecruitments()
    end,
    EXPEDITION_MANAGEMENT_APPLICANT_DEL = function(expeditionId)
      recruitWnd.check:SetChecked(false)
      recruitWnd.searchButton:Enable(true)
      RequestExpeditionRecruitments()
    end,
    FACTION_RENAMED = function(isExpedition, oldName, newName)
      if not isExpedition then
        return
      end
      recruitWnd.check:SetChecked(false)
      recruitWnd.searchButton:Enable(true)
      RequestExpeditionRecruitments(nil, true)
    end
  }
  recruitWnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(recruitWnd, events)
end
