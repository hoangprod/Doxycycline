local MAX_COUNT = 18
local RP = GetRolePolicyList()
local ML = GetTabViewOrderList()
local MEMBER_LIST_CURRENT_PAGE = -1
function CreateMemberList(id, wnd)
  SetViewOfExpeditionMemberList(id, wnd)
  local frame = wnd.frame
  local allSelectCheck = frame.allSelectCheck
  local listCtrl = frame.listCtrl
  local inputName = wnd.inputName
  local inviteExped = wnd.inviteExped
  function inputName:OnTextChanged()
    self:CheckNamePolicy(VNT_CHAR)
    if string.len(self:GetText()) >= 1 then
      inviteExped:Enable(true)
    else
      inviteExped:Enable(false)
    end
  end
  inputName:SetHandler("OnTextChanged", inputName.OnTextChanged)
  function inviteExped:OnClick()
    local name = inputName:GetText()
    if name == "" then
      X2Chat:DispatchChatMessage(CMF_SYSTEM, "no invite Exped pc name")
    else
      X2Faction:InviteToExpedition(name)
      inputName:SetText("")
    end
  end
  inviteExped:SetHandler("OnClick", inviteExped.OnClick)
  function wnd:OnShow()
    inputName:SetText("")
    inviteExped:Enable(false)
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  function frame:IsAllChecked()
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[EXPEDITION_MEMBER_COL.ONLINE] and not data[EXPEDITION_MEMBER_COL.CHK] then
        return false
      end
    end
    return true
  end
  function frame:GetSelctedCheckBoxs()
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[EXPEDITION_MEMBER_COL.ONLINE] and data[EXPEDITION_MEMBER_COL.CHK] then
        return true
      end
    end
    return false
  end
  function allSelectCheck:SetCheckedAll(check)
    for i = 1, frame:GetDataCount() do
      local data = frame:GetDataByDataIndex(i, 1)
      if data[EXPEDITION_MEMBER_COL.ONLINE] and data[EXPEDITION_MEMBER_COL.NAME] ~= X2Unit:UnitName("player") then
        data[EXPEDITION_MEMBER_COL.CHK] = check
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
    wnd.inviteRaid:Enable(self:GetChecked())
    wnd.summon:Enable(self:GetChecked())
  end
  wnd.rolePolicies = {}
  local membersPerPage = X2Faction:GetExpeditionMembersPerPage()
  function frame:OnPageChangedProc(pageIndex)
    wnd:RequestMemberInfo()
  end
  function wnd.inviteRaid:OnClick(arg)
    if arg == "LeftButton" then
      local rolePolicy = GetRolePolicy("my")
      if rolePolicy[RP.INVITE_RAID] == true then
        for i = 1, frame:GetDataCount() do
          local data = frame:GetDataByDataIndex(i, 1)
          if data[EXPEDITION_MEMBER_COL.ONLINE] and data[EXPEDITION_MEMBER_COL.CHK] then
            X2Team:InviteToTeam(data[EXPEDITION_MEMBER_COL.NAME], false)
          end
        end
      else
        X2Chat:DispatchChatMessage(CMF_EXPEDITION, "do not have permission")
      end
    end
  end
  wnd.inviteRaid:SetHandler("OnClick", wnd.inviteRaid.OnClick)
  local summonWnd
  function wnd.summon:OnClick(arg)
    summonWnd = ShowExpeditionSummon(wnd)
  end
  wnd.summon:SetHandler("OnClick", wnd.summon.OnClick)
  for i = 1, MAX_COUNT do
    do
      local item = listCtrl.items[i]
      function item:OnClick(arg)
        if arg == "RightButton" then
          local data = frame:GetDataByViewIndex(i, ML.ROLE)
          if data == nil then
            return
          end
          local expellable = false
          local rolePolicy = GetRolePolicy("my")
          if data[EXPEDITION_MEMBER_COL.ROLE] == nil then
            return
          end
          if rolePolicy[RP.EXPEL] == true and rolePolicy[RP.ROLE] > data[EXPEDITION_MEMBER_COL.ROLE] then
            expellable = true
          end
          ActivateExpeditionMemberPopupMenu(self, data[EXPEDITION_MEMBER_COL.NAME], data[EXPEDITION_MEMBER_COL.PARTY], data[EXPEDITION_MEMBER_COL.ONLINE], expellable)
        end
      end
      item:SetHandler("OnClick", item.OnClick)
    end
  end
  local function GetChangeableRoles(myRole, curRole)
    local rolePolicies = GetRolePolicy("all")
    table.sort(rolePolicies, function(lhs, rhs)
      return lhs[RP.ROLE] > rhs[RP.ROLE] and true or false
    end)
    local checkedIndex = 1
    local roles = {}
    for k = 1, #rolePolicies do
      local rolePolicy = rolePolicies[k]
      if myRole > rolePolicy[RP.ROLE] then
        local role = {}
        role.name = rolePolicy[RP.NAME]
        role.role = rolePolicy[RP.ROLE]
        roles[#roles + 1] = role
        if rolePolicy[RP.ROLE] == curRole then
          checkedIndex = #roles or checkedIndex
        end
      end
    end
    return roles, checkedIndex
  end
  for i = 1, MAX_COUNT do
    do
      local item = listCtrl.items[i]
      local subItem = item.subItems[ML.ROLE]
      function subItem:OnClick(arg)
        if arg == "LeftButton" then
          local data = frame:GetDataByViewIndex(i, ML.ROLE)
          local rolePolicy = GetRolePolicy("my")
          if data[EXPEDITION_MEMBER_COL.ROLE] >= rolePolicy[RP.ROLE] then
            return
          end
          if rolePolicy[RP.PROMOTE] == false then
            return
          end
          local myName = X2Unit:UnitName("player")
          if data[EXPEDITION_MEMBER_COL.NAME] == myName then
            return
          end
          local roles, checkedIndex = GetChangeableRoles(rolePolicy[RP.ROLE], data[EXPEDITION_MEMBER_COL.ROLE])
          ActivateExpeditionRolePopupMenu(self, data[EXPEDITION_MEMBER_COL.NAME], roles, checkedIndex)
        end
      end
      subItem:SetHandler("OnClick", subItem.OnClick)
    end
  end
  for i = 1, MAX_COUNT do
    do
      local subItem = listCtrl.items[i].subItems[ML.ROLE].roleIcon
      function subItem:OnEnter(arg)
        local data = frame:GetDataByViewIndex(i, ML.ROLE)
        if data == nil then
          return
        end
        local index
        if data[EXPEDITION_MEMBER_COL.ROLE] == 255 then
          index = 5
        else
          index = data[EXPEDITION_MEMBER_COL.ROLE] + 1
        end
        SetTooltip(wnd.rolePolicies[index][RP.NAME], self)
        frame.OnEnterItemRowIndex = i
        frame.OnEnterItemColIndex = ML.ROLE
        frame.OnEnterWidget = subItem
      end
      subItem:SetHandler("OnEnter", subItem.OnEnter)
      function subItem:OnLeave(arg)
        HideTooltip()
        frame.OnEnterWidget = nil
        frame.OnEnterItemIndex = nil
        frame.OnEnterItemColIndex = nil
      end
      subItem:SetHandler("OnLeave", subItem.OnLeave)
    end
  end
  for i = 1, MAX_COUNT do
    do
      local subItem = listCtrl.items[i].subItems[ML.POS]
      function subItem:OnEnter(arg)
        local data = frame:GetDataByViewIndex(i, ML.POS)
        if data == nil then
          return
        end
        local posStr = GetConvertingPosString(data[EXPEDITION_MEMBER_COL.ONLINE], data[EXPEDITION_MEMBER_COL.POS])
        if posStr == "" then
          return
        end
        SetTooltip(posStr, self.posLabel, true)
        frame.OnEnterItemRowIndex = i
        frame.OnEnterItemColIndex = ML.POS
        frame.OnEnterWidget = subItem
      end
      subItem:SetHandler("OnEnter", subItem.OnEnter)
      function subItem:OnLeave(arg)
        HideTooltip()
        frame.OnEnterWidget = nil
        frame.OnEnterItemIndex = nil
        frame.OnEnterItemColIndex = nil
      end
      subItem:SetHandler("OnLeave", subItem.OnLeave)
    end
  end
  if expeditionLocale.jobTooltipSettingFunc ~= nil then
    expeditionLocale.jobTooltipSettingFunc(frame, ML.CLASS)
  end
  function frame:OnSliderChangedProc()
    if not tooltip.window:IsVisible() then
      return
    end
    if self.OnEnterWidget == nil or self.OnEnterItemRowIndex == nil or self.OnEnterItemColIndex == nil then
      return
    end
    if self.OnEnterItemColIndex == ML.ROLE then
      local data = self.datas[self.OnEnterItemRowIndex + frame:GetTopDataIndex() - 1]
      local roleData = data[self.OnEnterItemColIndex + ROWDATA_COLUMN_OFFSET]
      local index = 0
      if roleData[EXPEDITION_MEMBER_COL.ROLE] == 255 then
        index = 5
      else
        index = roleData[EXPEDITION_MEMBER_COL.ROLE] + 1
      end
      SetTargetAnchorTooltip(wnd.rolePolicies[index][RP.NAME], "TOPLEFT", self.OnEnterWidget, "BOTTOMRIGHT", -15, -15)
    elseif self.OnEnterItemColIndex == ML.POS then
      local data = self.datas[self.OnEnterItemRowIndex + frame:GetTopDataIndex() - 1]
      local posData = data[self.OnEnterItemColIndex + ROWDATA_COLUMN_OFFSET]
      local posStr = GetConvertingPosString(posData[EXPEDITION_MEMBER_COL.ONLINE], posData[EXPEDITION_MEMBER_COL.POS])
      SetTargetAnchorTooltip(posStr, "TOPLEFT", self.OnEnterWidget, "TOPLEFT", 15, 15)
    end
  end
  function wnd:SetInviteExpedHandler(activate)
    local inputName = self.inputName
    local inviteExped = self.inviteExped
    if activate == true then
      function inputName.TextChangedFunc()
        local enable = string.len(inputName:GetText()) >= 1
        inviteExped:Enable(enable)
      end
    else
      inputName.TextChangedFunc = nil
    end
    function inviteExped:OnClick(arg)
      if arg == "LeftButton" then
        local name = inputName:GetText()
        if name == "" then
          X2Chat:DispatchChatMessage(CMF_EXPEDITION, "no invite Exped pc name")
        else
          X2Faction:InviteToExpedition(name)
          inputName:SetText("")
        end
      end
    end
    if activate == true then
      inviteExped:SetHandler("OnClick", inviteExped.OnClick)
    else
      inviteExped:ReleaseHandler("OnClick")
    end
    inviteExped:Enable(false)
    inputName:SetText("")
  end
  wnd.requestedStartIndex = 0
  wnd.listRefresh = false
  function wnd:RequestMemberInfo(startIndex, forceRefresh)
    local btn = wnd.refreshButton
    forceRefresh = forceRefresh or false
    if forceRefresh == false and btn:IsEnabled() == false then
      return
    end
    btn.time = 0
    btn.waiting = true
    btn:Enable(false)
    self.viewOffMember:SetEnableCheckButton(false)
    frame.pageControl:Enable(false)
    wnd:WaitPage(true)
    btn:SetHandler("OnUpdate", wnd.refreshButton.OnUpdate)
    local allMember = self.viewOffMember:GetChecked()
    startIndex = startIndex or MEMBER_LIST_CURRENT_PAGE
    if startIndex == MEMBER_LIST_CURRENT_PAGE then
      startIndex = (frame.pageIndex - 1) * membersPerPage + 1
    end
    if wnd.requestedStartIndex == startIndex then
      wnd.listRefresh = true
    else
      wnd.listRefresh = false
    end
    membersPerPage = X2Faction:GetExpeditionMembersPerPage()
    wnd.requestedStartIndex = startIndex
    X2Faction:RequestExpeditionMembers(allMember, startIndex)
  end
  function wnd.refreshButton:OnUpdate(dt)
    self.time = self.time + dt
    frame.pageControl:Enable(false)
    local REFRESH_COOL_DOWN = 1000
    if REFRESH_COOL_DOWN < self.time and not self.waiting then
      self:Enable(true)
      frame.pageControl:Enable(true)
      wnd.viewOffMember:SetEnableCheckButton(true)
      self:ReleaseHandler("OnUpdate")
    end
    local MAX_TIME_OUT = 20000
    if MAX_TIME_OUT < self.time then
      self:Enable(true)
      frame.pageControl:Enable(true)
      wnd.viewOffMember:SetEnableCheckButton(true)
      self:ReleaseHandler("OnUpdate")
    end
  end
  function wnd.refreshButton:OnClick()
    wnd:RequestMemberInfo()
  end
  wnd.refreshButton:SetHandler("OnClick", wnd.refreshButton.OnClick)
  function wnd:FillMemberData(totalCount, startIndex, memberInfos)
    local value = frame.scroll.vs:GetValue()
    local oldDatas
    if wnd.listRefresh == true then
      oldDatas = {}
      for k = 1, frame:GetDataCount() do
        local columnData = frame:GetDataByDataIndex(k, 1)
        local oldData = {}
        oldData[EXPEDITION_MEMBER_COL.NAME] = columnData[EXPEDITION_MEMBER_COL.NAME]
        oldData[EXPEDITION_MEMBER_COL.CHK] = columnData[EXPEDITION_MEMBER_COL.CHK]
        oldDatas[#oldDatas + 1] = oldData
      end
      for x = 1, #oldDatas do
        for y = 1, #memberInfos do
          if oldDatas[x][EXPEDITION_MEMBER_COL.NAME] == memberInfos[y][EXPEDITION_MEMBER_COL.NAME] and memberInfos[y][EXPEDITION_MEMBER_COL.ONLINE] then
            memberInfos[y][EXPEDITION_MEMBER_COL.CHK] = oldDatas[x][EXPEDITION_MEMBER_COL.CHK]
          end
        end
      end
    end
    frame:DeleteAllDatas()
    local online, total = X2Faction:GetExpeditionMemberCount()
    local str = string.format("%s %s%d/%d", locale.expedition.onlineMember, FONT_COLOR_HEX.BLUE, online, total)
    wnd.numOfonlineMember:SetText(str)
    frame:SetPageByItemCount(totalCount, membersPerPage)
    local curPage = math.floor((startIndex - 1) / membersPerPage) + 1
    frame.pageControl:SetCurrentPage(curPage, false)
    for i = 1, #memberInfos do
      local info = memberInfos[i]
      info[EXPEDITION_MEMBER_COL.CHK] = info[EXPEDITION_MEMBER_COL.CHK] or false
      for j = 1, ML.MAX do
        frame:InsertData(info[EXPEDITION_MEMBER_COL.NAME], j, info)
      end
    end
    if wnd.listRefresh == true then
      local _, maxValue = frame.scroll.vs:GetMinMaxValues()
      if not (value < maxValue) or not value then
        value = maxValue
      end
      frame.scroll.vs:SetValue(value, true)
    end
    wnd.refreshButton.waiting = false
    wnd:WaitPage(false)
  end
  function wnd:SetViewOffMemberHandler()
    local viewOffMember = self.viewOffMember
    function viewOffMember:CheckBtnCheckChagnedProc()
      wnd:RequestMemberInfo(1)
    end
    viewOffMember:SetHandler("OnCheckChanged", viewOffMember.CheckBtnCheckChagnedProc)
  end
  wnd:SetViewOffMemberHandler()
  function wnd:RefreshTab()
    if X2Faction:IsExpedInfoLoaded() == false then
      return
    end
    self:SetInviteExpedHandler(GetRolePolicy("my")[RP.INVITE])
    frame.allSelectCheck:SetChecked(false)
    wnd.rolePolicies = GetRolePolicy("all")
    wnd:RequestMemberInfo(1)
  end
  function wnd.OnChangePolicy()
    wnd.rolePolicies = GetRolePolicy("all")
    self:SetInviteExpedHandler(GetRolePolicy("my")[RP.INVITE])
  end
  function wnd:HideWindow()
    if summonWnd == nil then
      return
    end
    summonWnd:Show(false)
  end
end
