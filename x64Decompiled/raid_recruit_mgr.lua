function ShowRaidRecruit(parent)
  local wnd = SetViewOfRaidRecruit(parent)
  wnd.typeList = X2Team:GetRaidRecruitTypeList()
  local function RefreshSubTypeList()
    local checkedTypeList = {}
    for i = 1, #wnd.recruitTypeOptWnd.interestChks do
      local check = wnd.recruitTypeOptWnd.interestChks[i]
      if check:GetChecked() then
        table.insert(checkedTypeList, wnd.typeList[i].type)
      end
    end
    local subTypeList = X2Team:GetRaidRecruitSubTypeList(checkedTypeList, false)
    local datas = {}
    local firstData = {
      text = GetCommonText("all"),
      value = 0,
      color = FONT_COLOR.DEFAULT,
      disableColor = FONT_COLOR.GRAY,
      enable = true,
      useColor = true
    }
    table.insert(datas, firstData)
    for i = 1, #subTypeList do
      local data = {
        text = subTypeList[i].name,
        value = subTypeList[i].subType
      }
      table.insert(datas, data)
    end
    wnd.subTypeComboBox:AppendItems(datas)
  end
  local function RefreshTypeIcon()
    local RECRUIT_TYPE_ICON = GetRecruitTypeIconList()
    for i = 1, #wnd.recruitTypeOptWnd.interestChks do
      local check = wnd.recruitTypeOptWnd.interestChks[i]
      if check:GetChecked() then
        wnd.typeIcon[i].tex:SetTextureInfo("icon_" .. RECRUIT_TYPE_ICON[i])
      else
        wnd.typeIcon[i].tex:SetTextureInfo("icon_" .. RECRUIT_TYPE_ICON[i] .. "_dis")
      end
    end
  end
  local function UpdateFilterItems()
    RefreshSubTypeList()
    RefreshTypeIcon()
  end
  local function Init()
    for i = 1, #wnd.recruitTypeOptWnd.interestChks do
      local check = wnd.recruitTypeOptWnd.interestChks[i]
      check:SetChecked(true)
    end
    UpdateFilterItems()
    X2Team:RaidRecruitList()
    wnd.recruitButton:Enable(not X2Team:IsSiegeRaidTeam())
  end
  local function CheckBtnCheckChagnedProc(checked)
    UpdateFilterItems()
  end
  for i = 1, #wnd.recruitTypeOptWnd.interestChks do
    local check = wnd.recruitTypeOptWnd.interestChks[i]
    check.CheckBtnCheckChagnedProc = CheckBtnCheckChagnedProc
  end
  function wnd:ShowProc()
    Init()
  end
  local OnHide = function(self)
    if self.recruitTypeOptWnd then
      self.recruitTypeOptWnd:Show(false)
    end
    if self.recruitmentWnd then
      self.recruitmentWnd:Show(false)
    end
    if self.applicantListWnd then
      self.applicantListWnd:Show(false)
    end
  end
  wnd:SetHandler("OnHide", OnHide)
  local function UpdateData()
    local recruitSubType = 0
    local checkedTypeList = {}
    for i = 1, #wnd.recruitTypeOptWnd.interestChks do
      local check = wnd.recruitTypeOptWnd.interestChks[i]
      if check:GetChecked() then
        table.insert(checkedTypeList, wnd.typeList[i].type)
      end
    end
    local info = wnd.subTypeComboBox:GetSelectedInfo()
    if info ~= nil then
      recruitSubType = info.value
    end
    local data = X2Team:RaidRecruitSeachList(checkedTypeList, recruitSubType)
    local list = wnd.recruitList
    list:DeleteAllDatas()
    for i = 1, #data do
      local recruit = data[i]
      list:InsertData(i, 1, recruit)
    end
    list.pageControl:SetPageByItemCount(#data, RAID_RECRUIT_PER_COUNT)
    list.pageControl:SetCurrentPage(1)
    wnd.recruitButton:Enable(not X2Team:IsSiegeRaidTeam())
  end
  function wnd.searchButton:OnClick()
    UpdateData()
  end
  wnd.searchButton:SetHandler("OnClick", wnd.searchButton.OnClick)
  function wnd.initButton:OnClick()
    Init()
  end
  wnd.initButton:SetHandler("OnClick", wnd.initButton.OnClick)
  function wnd.recruitTypeButton:OnClick()
    wnd.recruitTypeOptWnd:Show(wnd.recruitTypeOptWnd:IsVisible() == false)
  end
  wnd.recruitTypeButton:SetHandler("OnClick", wnd.recruitTypeButton.OnClick)
  function wnd.refreshButton:OnClick()
    Init()
  end
  wnd.refreshButton:SetHandler("OnClick", wnd.refreshButton.OnClick)
  function wnd.applicantButton:OnClick()
    if wnd.applicantListWnd == nil then
      wnd.applicantListWnd = ShowRaidApplicantList(wnd)
    end
    wnd.applicantListWnd:Show(true)
  end
  wnd.applicantButton:SetHandler("OnClick", wnd.applicantButton.OnClick)
  function wnd.recruitButton:OnClick()
    wnd.recruitmentWnd = ShowRaidRecruitment(wnd)
  end
  wnd.recruitButton:SetHandler("OnClick", wnd.recruitButton.OnClick)
  function EventButtonClick(subItem)
    if subItem.eventButton.buttonType == EVENT_BUTTON_TYPE.APPLY then
      X2Team:RaidRecruitDetail(subItem.info.ownerId, subItem.info.createTime)
    elseif subItem.eventButton.buttonType == EVENT_BUTTON_TYPE.APPLY_CANCEL then
      X2Team:RaidApplicantDel(subItem.info.ownerId)
    elseif subItem.eventButton.buttonType == EVENT_BUTTON_TYPE.RECRUIT_CANCEL then
      X2Team:RaidRecruitDel()
    end
  end
  function wnd:EventButtonToggle(enable)
    for i = 1, #self.recruitList.listCtrl.items do
      local subItem = self.recruitList.listCtrl.items[i].subItems[1]
      if subItem.eventButton.buttonType == EVENT_BUTTON_TYPE.APPLY then
        subItem.eventButton:Enable(enable)
      end
    end
  end
  local events = {
    CONVERT_TO_RAID_TEAM = function()
      Init()
    end,
    TEAM_MEMBERS_CHANGED = function()
      Init()
    end,
    LEFT_LOADING = function()
      wnd:Show(false)
    end,
    RAID_RECRUIT_LIST = function(data)
      if wnd.applicantWnd ~= nil then
        wnd.applicantWnd:Show(false)
      end
      UpdateData()
      if data.recruiter == true or data.subRecruiter == true then
        wnd.recruitButton:Enable(false)
        wnd.applicantButton:Enable(true)
      else
        wnd.recruitButton:Enable(true)
        wnd.applicantButton:Enable(false)
      end
    end,
    RAID_APPLICANT_ACCEPT = function(data)
      if X2BattleField:IsInInstantGame() then
        return
      end
      ShowRaidApplicantAccept(data)
    end,
    RAID_RECRUIT_HUD = function(data)
      if #data > 0 then
        ShowRaidRecruitAlarm(true)
      else
        ShowRaidRecruitAlarm(false)
      end
    end,
    RAID_RECRUIT_DETAIL = function(data)
      if X2BattleField:IsInInstantGame() then
        return
      end
      ShowRaidApplicant(wnd, data)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
RaidRecruit = ShowRaidRecruit("UIParent")
function ToggleRaidRecruit(show)
  if show == nil then
    show = not RaidRecruit:IsVisible()
  end
  RaidRecruit:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_RAID_RECRUIT, ToggleRaidRecruit)
