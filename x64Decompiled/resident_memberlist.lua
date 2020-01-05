local MEMBERLIST_ROW_COUNT = 10
function SetViewOfResidentMemberList(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = W_CTRL.CreatePageScrollListCtrl("frame", parent)
  frame:Show(true)
  frame:AddAnchor("TOPLEFT", parent, 0, sideMargin / 2)
  frame:AddAnchor("BOTTOMRIGHT", parent, 0, bottomMargin * 1.5)
  function frame:CheckButtonEnable(isEnable)
    if parent.isResident ~= nil and not parent.isResident then
      parent.inviteRaid:Enable(false)
      local OnEnter = function(self)
        SetTooltip(GetUIText(COMMON_TEXT, "resident_invite_raid_tooltip"), self)
      end
      parent.inviteRaid:SetHandler("OnEnter", OnEnter)
      return
    end
    parent.inviteRaid:ReleaseHandler("OnEnter")
    if isEnable ~= nil then
      parent.inviteRaid:Enable(isEnable)
    else
      parent.inviteRaid:Enable(frame:GetSelctedCheckBoxs())
    end
  end
  local function NameDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem.nameLabel:SetText(data[RESIDENT_MEMBER_IDX.NAME])
      subItem.selectCheck:Show(true)
      subItem.selectCheck:Enable(data[RESIDENT_MEMBER_IDX.ONLINE])
      subItem.selectCheck:SetChecked(data[RESIDENT_MEMBER_IDX.CHK], true)
      subItem.icon:Show(data[RESIDENT_MEMBER_IDX.PARTY])
      ChangeSubItemTextColorForOnline(subItem.nameLabel, data[RESIDENT_MEMBER_IDX.ONLINE])
      if data[RESIDENT_MEMBER_IDX.NAME] == X2Unit:UnitName("player") then
        subItem.selectCheck:Enable(false)
      end
    else
      subItem.nameLabel:SetText("")
      subItem.icon:Show(false)
      subItem.selectCheck:SetChecked(false, false)
      subItem.selectCheck:Show(false)
      frame.allSelectCheck:SetChecked(false, false)
    end
  end
  local ServicePointSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format("%d", data[RESIDENT_MEMBER_IDX.SERVICE]))
      ChangeSubItemTextColorForOnline(subItem, data[RESIDENT_MEMBER_IDX.ONLINE])
    end
  end
  local LevelDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local heirColor = F_COLOR.GetColor("successor_deep", true)
      local heirColorcCode = "%s|e%d;"
      if data[RESIDENT_MEMBER_IDX.ONLINE] == false then
        heirColor = FONT_COLOR_HEX.GRAY
        heirColorcCode = "%s|E%d;"
      end
      if data[RESIDENT_MEMBER_IDX.HEIR_LEVEL] > 0 then
        subItem:SetText(string.format(heirColorcCode, heirColor, data[RESIDENT_MEMBER_IDX.HEIR_LEVEL]))
      else
        subItem:SetText(tostring(data[RESIDENT_MEMBER_IDX.LEVEL]))
      end
      ChangeSubItemTextColorForOnline(subItem, data[RESIDENT_MEMBER_IDX.ONLINE])
    end
  end
  local FamilyDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local cellValue = data[RESIDENT_MEMBER_IDX.FAMILY]
      if cellValue == nil or cellValue == "" or cellValue == 0 then
        subItem:SetText(GetUIText(COMMON_TEXT, "resident_family_not_exist"))
      else
        subItem:SetText(GetUIText(COMMON_TEXT, "resident_family_exist"))
      end
      ChangeSubItemTextColorForOnline(subItem, data[RESIDENT_MEMBER_IDX.ONLINE])
    end
  end
  local NameColumnLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
    local selectCheck = CreateCheckButton(subItem:GetId() .. ".selectCheck", subItem)
    selectCheck:Show(false)
    selectCheck:AddAnchor("LEFT", subItem, 5, -1)
    subItem.selectCheck = selectCheck
    subItem.selectCheck.rowIndex = rowIndex
    function selectCheck:CheckBtnCheckChagnedProc(checked)
      local data = frame:GetDataByViewIndex(rowIndex, colIndex)
      data[RESIDENT_MEMBER_IDX.CHK] = checked
      if not checked then
        frame.allSelectCheck:SetChecked(false, false)
      else
        frame.allSelectCheck:SetChecked(frame:IsAllChecked(), false)
      end
      if frame.CheckButtonEnable ~= nil then
        frame:CheckButtonEnable()
      end
    end
    local icon = W_ICON.CreatePartyIconWidget(subItem)
    icon:Show(false)
    icon:AddAnchor("LEFT", subItem, 20, 1)
    local nameLabel = subItem:CreateChildWidget("label", "nameLabel", 0, true)
    nameLabel:Show(true)
    nameLabel:SetExtent(180, 25)
    nameLabel:AddAnchor("LEFT", icon, "RIGHT", 3, -1)
    nameLabel.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(nameLabel, FONT_COLOR.DEFAULT)
  end
  local LevelLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  frame:InsertColumn(RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.NAME].text, RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.NAME].width, LCCIT_WINDOW, NameDataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, NameColumnLayoutSetFunc)
  frame:InsertColumn(RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.LEVEL].text, RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.LEVEL].width, LCCIT_TEXTBOX, LevelDataSetFunc, LevelAscendingSortFunc, LevelDescendingSortFunc, LevelLayoutFunc)
  frame:InsertColumn(RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.SERVICE].text, RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.SERVICE].width, LCCIT_STRING, ServicePointSetFunc)
  frame:InsertColumn(RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.FAMILY].text, RESIDENT_MEMBER_INFO[RESIDENT_MEMBER_IDX.FAMILY].width, LCCIT_STRING, FamilyDataSetFunc)
  frame:InsertRows(MEMBERLIST_ROW_COUNT, false)
  frame.listCtrl:DisuseSorting()
  DrawListCtrlUnderLine(frame.listCtrl)
  frame.listCtrl:UseOverClickTexture()
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    if i == #frame.listCtrl.column then
      frame.listCtrl.column[i]:Enable(false)
    end
  end
  local allSelectCheck = CreateCheckButton(frame:GetId() .. ".allSelectCheck", frame)
  allSelectCheck:AddAnchor("LEFT", frame.listCtrl.column[1], 5, -1)
  frame.allSelectCheck = allSelectCheck
  local inviteRaid = parent:CreateChildWidget("button", "inviteRaid", 0, true)
  inviteRaid:Enable(false)
  inviteRaid:SetText(locale.expedition.inviteRaid)
  inviteRaid:AddAnchor("BOTTOMRIGHT", parent, 0, -sideMargin + 4)
  ApplyButtonSkin(inviteRaid, BUTTON_BASIC.DEFAULT)
  local viewOffMember = CreateCheckButton(id .. ".viewOffMember", parent, GetUIText(COMMON_TEXT, "resident_townhall_members_offline"), TEXTURE_PATH.CHECK_EYE_SHAPE)
  viewOffMember:SetButtonStyle("eyeShape")
  viewOffMember:AddAnchor("BOTTOMLEFT", parent, viewOffMember.textButton:GetWidth(), -sideMargin + 4)
  parent.viewOffMember = viewOffMember
  local refreshButton = parent:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:AddAnchor("TOPRIGHT", parent, 3, 13)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  local modalWindow = parent:CreateChildWidget("emptywidget", "modalWindow", 0, true)
  modalWindow:AddAnchor("TOPLEFT", parent, 0, 0)
  modalWindow:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local bg = modalWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "modal_bg", "background")
  bg:SetTextureColor("gradient")
  bg:AddAnchor("TOPLEFT", modalWindow, -15, 3)
  bg:AddAnchor("BOTTOMRIGHT", modalWindow, 15, -3)
  local loadingEffect = modalWindow:CreateEffectDrawable("ui/tutorials/loading.dds", "background")
  loadingEffect:SetExtent(32, 32)
  loadingEffect:SetCoords(100, 1, 32, 32)
  loadingEffect:AddAnchor("CENTER", modalWindow, 0, 0)
  loadingEffect:SetRepeatCount(0)
  loadingEffect:SetEffectPriority(1, "rotate", 1.5, 1.5)
  loadingEffect:SetEffectRotate(1, 0, 360)
  parent.loadingEffect = loadingEffect
  function parent:WaitPage(isShow)
    self.modalWindow:Show(isShow)
    self.loadingEffect:SetStartEffect(isShow)
  end
  return frame
end
function CreateResidentMemberList(id, parent)
  local frame = SetViewOfResidentMemberList(id, parent)
  local allSelectCheck = frame.allSelectCheck
  local listCtrl = frame.listCtrl
  local pageControl = frame.pageControl
  function parent.refreshButton:OnLeave(arg)
    HideTooltip()
  end
  parent.refreshButton:SetHandler("OnLeave", parent.refreshButton.OnLeave)
  function frame:IsAllChecked()
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[RESIDENT_MEMBER_IDX.ONLINE] and not data[RESIDENT_MEMBER_IDX.CHK] then
        return false
      end
    end
    return true
  end
  function frame:GetSelctedCheckBoxs()
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[RESIDENT_MEMBER_IDX.ONLINE] and data[RESIDENT_MEMBER_IDX.CHK] then
        return true
      end
    end
    return false
  end
  function allSelectCheck:SetCheckedAll(check)
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[RESIDENT_MEMBER_IDX.ONLINE] and data[RESIDENT_MEMBER_IDX.NAME] ~= X2Unit:UnitName("player") then
        data[RESIDENT_MEMBER_IDX.CHK] = check
      end
    end
    for i = 1, #listCtrl.items do
      local selectCheck = listCtrl.items[i].subItems[1].selectCheck
      if selectCheck:IsVisible() and selectCheck:IsEnabled() then
        selectCheck:SetChecked(check, false)
      end
    end
  end
  function allSelectCheck:CheckBtnCheckChagnedProc()
    self:SetCheckedAll(self:GetChecked())
    parent.inviteRaid:Enable(self:GetChecked())
    if frame.CheckButtonEnable ~= nil then
      frame:CheckButtonEnable()
    end
  end
  function frame:OnPageChangedProc(pageIndex)
    parent:RequestMemberInfo(residentTownhall.currMemberIndex)
  end
  function parent.inviteRaid:OnClick(arg)
    if arg == "LeftButton" then
      for i = 1, frame:GetDataCount() do
        local data = frame:GetDataByDataIndex(i, 1)
        if data[RESIDENT_MEMBER_IDX.ONLINE] and data[RESIDENT_MEMBER_IDX.CHK] then
          X2Team:InviteToTeam(data[RESIDENT_MEMBER_IDX.NAME], false)
        end
      end
    end
  end
  parent.inviteRaid:SetHandler("OnClick", parent.inviteRaid.OnClick)
  parent.requestedStartIndex = 0
  parent.listRefresh = false
  parent.membersPerPage = MEMBERLIST_ROW_COUNT
  ListCtrlItemGuideLine(listCtrl.items, parent.membersPerPage)
  function parent:RequestMemberInfo(startIndex)
    parent.refreshButton.time = 0
    parent.refreshButton.waiting = true
    parent.refreshButton:Enable(false)
    self.viewOffMember:SetEnableCheckButton(false)
    frame.pageControl:Enable(false)
    parent:WaitPage(true)
    function parent.refreshButton:OnUpdateReq(dt)
      self.time = self.time + dt
      frame.pageControl:Enable(false)
      local REFRESH_COOL_DOWN = 1000
      if REFRESH_COOL_DOWN < self.time and not self.waiting then
        self:Enable(true)
        frame.pageControl:Enable(true)
        parent.viewOffMember:SetEnableCheckButton(true)
        self:ReleaseHandler("OnUpdate")
      end
      local MAX_TIME_OUT = 20000
      if MAX_TIME_OUT < self.time then
        self:Enable(true)
        frame.pageControl:Enable(true)
        parent.viewOffMember:SetEnableCheckButton(true)
        self:ReleaseHandler("OnUpdate")
      end
    end
    parent.refreshButton:SetHandler("OnUpdate", parent.refreshButton.OnUpdateReq)
    local offline = self.viewOffMember:GetChecked()
    startIndex = startIndex or residentTownhall.currMemberIndex
    if startIndex == residentTownhall.currMemberIndex then
      startIndex = (frame.pageIndex - 1) * parent.membersPerPage + 1
    end
    if parent.requestedStartIndex == startIndex then
      parent.listRefresh = true
    else
      parent.listRefresh = false
    end
    parent.requestedStartIndex = startIndex
    X2Resident:RefreshResidentMembers(X2Unit:GetCurrentZoneGroup(), offline, startIndex)
  end
  function parent.refreshButton:OnClick()
    parent:RequestMemberInfo(residentTownhall.currMemberIndex)
  end
  parent.refreshButton:SetHandler("OnClick", parent.refreshButton.OnClick)
  function parent:OnFillData(totalCount, startIndex, refresh, memberInfos)
    local value = frame.scroll.vs:GetValue()
    local oldDatas
    if parent.listRefresh == true then
      oldDatas = {}
      for k = 1, frame:GetDataCount() do
        local columnData = frame:GetDataByDataIndex(k, 1)
        local oldData = {}
        oldData[RESIDENT_MEMBER_IDX.NAME] = columnData[RESIDENT_MEMBER_IDX.NAME]
        oldData[RESIDENT_MEMBER_IDX.CHK] = columnData[RESIDENT_MEMBER_IDX.CHK]
        oldDatas[#oldDatas + 1] = oldData
      end
      for x = 1, #oldDatas do
        for y = 1, #memberInfos do
          if oldDatas[x][RESIDENT_MEMBER_IDX.NAME] == memberInfos[y][RESIDENT_MEMBER_IDX.NAME] and memberInfos[y][RESIDENT_MEMBER_IDX.ONLINE] then
            memberInfos[y][RESIDENT_MEMBER_IDX.CHK] = oldDatas[x][RESIDENT_MEMBER_IDX.CHK]
          end
        end
      end
    end
    frame:DeleteAllDatas()
    frame:SetPageByItemCount(totalCount, parent.membersPerPage)
    local curPage = math.floor((startIndex - 1) / parent.membersPerPage) + 1
    pageControl:SetCurrentPage(curPage, false)
    for i = 1, parent.membersPerPage - 1 do
      local item = frame.listCtrl.items[i]
      item.line:SetVisible(false)
    end
    for i = 1, #memberInfos do
      local info = memberInfos[i]
      info[RESIDENT_MEMBER_IDX.CHK] = info[RESIDENT_MEMBER_IDX.CHK] or false
      for j = 1, #RESIDENT_MEMBER_VIEW do
        frame:InsertData(info[RESIDENT_MEMBER_IDX.NAME], j, info)
      end
      local item = frame.listCtrl.items[i]
      if i ~= parent.membersPerPage then
        item.line:SetVisible(true)
      end
    end
    if parent.listRefresh == true then
      local _, maxValue = frame.scroll.vs:GetMinMaxValues()
      if not (value < maxValue) or not value then
        value = maxValue
      end
      frame.scroll.vs:SetValue(value, true)
    end
    parent:WaitPage(false)
    parent.refreshButton.waiting = false
    parent.refreshButton.time = 0
    parent.refreshButton.timeout = refresh
    frame.pageControl:Enable(true)
    parent.viewOffMember:SetEnableCheckButton(true)
    function parent.refreshButton:OnUpdateRef(dt)
      self.time = self.time + dt
      if self.time > refresh then
        self:Enable(true)
        self:ReleaseHandler("OnUpdate")
        self:ReleaseHandler("OnEnter")
      else
        do
          local remainTime = math.floor((refresh - self.time + 999) / 1000)
          if remainTime > 0 then
            function self:GetPeriod(seconds)
              if seconds == nil then
                return ""
              end
              local MIN = 60
              dateFormat = {}
              dateFormat.year = 0
              dateFormat.month = 0
              dateFormat.day = 0
              dateFormat.hour = 0
              dateFormat.minute = math.floor(seconds / MIN)
              if 0 < dateFormat.minute then
                seconds = seconds - dateFormat.minute * MIN or seconds
              end
              dateFormat.second = seconds
              local remainTimeString = locale.time.GetRemainDateToDateFormat(dateFormat, DEFAULT_FORMAT_FILTER + FORMAT_FILTER.SECOND)
              return remainTimeString
            end
            function self:OnEnter(arg)
              SetTooltip(GetUIText(COMMON_TEXT, "not_yet_report_spammer", self:GetPeriod(remainTime)), self)
            end
            self:SetHandler("OnEnter", self.OnEnter)
          end
        end
      end
    end
    parent.refreshButton:SetHandler("OnUpdate", parent.refreshButton.OnUpdateRef)
    if frame.CheckButtonEnable ~= nil then
      frame:CheckButtonEnable()
    end
  end
  function parent:SetViewOffMemberHandler()
    local viewOffMember = self.viewOffMember
    function viewOffMember:CheckBtnCheckChangedProc()
      parent:RequestMemberInfo(1)
    end
    viewOffMember:SetHandler("OnCheckChanged", viewOffMember.CheckBtnCheckChangedProc)
  end
  parent:SetViewOffMemberHandler()
  function parent:RefreshTab()
    local zoneGroup = X2Unit:GetCurrentZoneGroup()
    X2Resident:GetResidentDesc(zoneGroup)
    frame.allSelectCheck:SetChecked(false)
    parent:RequestMemberInfo(1)
  end
end
