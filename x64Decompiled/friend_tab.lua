local friendPerPage = X2Friend:GetFriendsPerPage()
local LIST_CURRENT_INDEX = -1
function CreateFriendTabWindow(window)
  SetViewOfFriendTabWindow(window)
  local MAX_COUNT = 10
  local allSelectCheck = window.allSelectCheck
  local frame = window.frame
  local listCtrl = window.frame.listCtrl
  local showOffMember = window.showOffMember
  local inputName = window.inputName
  local addFriendButton = window.addFriendButton
  local invitePartyButton = window.invitePartyButton
  function inputName:OnTextChanged()
    self:CheckNamePolicy(VNT_CHAR)
    local name = self:GetText()
    if string.len(name) >= 1 then
      addFriendButton:Enable(true)
    else
      addFriendButton:Enable(false)
    end
  end
  inputName:SetHandler("OnTextChanged", inputName.OnTextChanged)
  function addFriendButton:OnClick()
    local name = inputName:GetText()
    if name == "" then
      X2Chat:DispatchChatMessage(CMF_FRIEND_INFO, "no add friend pc name")
    else
      X2Friend:AddFriend(name)
      inputName:SetText("")
    end
  end
  addFriendButton:SetHandler("OnClick", addFriendButton.OnClick)
  function invitePartyButton:OnClick(arg)
    if arg == "LeftButton" then
      for i = 1, #frame.datas do
        local data = frame:GetDataByViewIndex(i, 1)
        if data[FRIEND_COL.ONLINE] and data[FRIEND_COL.CHK] then
          X2Team:InviteToTeam(data[FRIEND_COL.NAME], true)
        end
      end
    end
  end
  invitePartyButton:SetHandler("OnClick", invitePartyButton.OnClick)
  local function RefreshButtonLeftClickFunc()
    window:RequestFriendList()
  end
  ButtonOnClickHandler(window.refreshButton, RefreshButtonLeftClickFunc)
  function window:OnShow()
    inputName:SetText("")
    addFriendButton:Enable(false)
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:GetSelctedCheckBoxs()
    for i = 1, #frame.datas do
      local data = frame:GetDataByViewIndex(i, 1)
      if data[FRIEND_COL.ONLINE] and data[FRIEND_COL.CHK] then
        return true
      end
    end
    return false
  end
  function allSelectCheck:SetCheckedAll(check)
    for i = 1, #frame.datas do
      local data = frame:GetDataByViewIndex(i, 1)
      if data[FRIEND_COL.ONLINE] then
        data[FRIEND_COL.CHK] = check
      end
    end
    for i = 1, MAX_COUNT do
      local selectCheck = listCtrl.items[i].subItems[1].selectCheck
      if selectCheck:IsVisible() and selectCheck:IsEnabled() then
        selectCheck:SetChecked(check)
      end
    end
  end
  function allSelectCheck:CheckBtnCheckChagnedProc()
    self:SetCheckedAll(self:GetChecked())
  end
  function window.refreshButton:OnUpdate(dt)
    self.time = self.time + dt
    frame.pageControl:Enable(false)
    local REFRESH_COOL_DOWN = 1000
    if REFRESH_COOL_DOWN < self.time and not self.waiting then
      self:Enable(true)
      frame.pageControl:Enable(true)
      window.showOffMember:SetEnableCheckButton(true)
      self:ReleaseHandler("OnUpdate")
    end
    local MAX_TIME_OUT = 20000
    if MAX_TIME_OUT < self.time then
      self:Enable(true)
      frame.pageControl:Enable(true)
      window.showOffMember:SetEnableCheckButton(true)
      self:ReleaseHandler("OnUpdate")
    end
  end
  window.requestedStartIndex = 0
  window.listRefresh = false
  function window:RequestFriendList(startIndex, forceRefresh)
    local btn = self.refreshButton
    forceRefresh = forceRefresh or false
    if forceRefresh == false and btn:IsEnabled() == false then
      return
    end
    btn.time = 0
    btn.waiting = true
    btn:Enable(false)
    self.showOffMember:SetEnableCheckButton(false)
    frame.pageControl:Enable(false)
    self:WaitPage(true)
    btn:SetHandler("OnUpdate", self.refreshButton.OnUpdate)
    local pageIndex = self.frame.pageControl:GetCurrentPageIndex()
    startIndex = startIndex or LIST_CURRENT_INDEX
    if startIndex == LIST_CURRENT_INDEX then
      startIndex = (pageIndex - 1) * friendPerPage + 1
    end
    if self.requestedStartIndex == startIndex then
      self.listRefresh = true
    else
      self.listRefresh = false
    end
    friendPerPage = X2Friend:GetFriendsPerPage()
    self.requestedStartIndex = startIndex
    X2Friend:RequestFriendList(self.showOffMember:GetChecked(), startIndex)
  end
  function frame:OnPageChangedProc(pageIndex)
    window:RequestFriendList(LIST_CURRENT_INDEX)
  end
  function window:FillMemberData(totalCount, startIndex, memberInfos)
    local value = frame.scroll.vs:GetValue()
    local oldDatas
    if self.listRefresh == true then
      oldDatas = {}
      for k = 1, frame:GetDataCount() do
        local columnData = frame:GetDataByDataIndex(k, 1)
        local oldData = {}
        oldData[FRIEND_COL.NAME] = columnData[FRIEND_COL.NAME]
        oldData[FRIEND_COL.CHK] = columnData[FRIEND_COL.CHK]
        oldDatas[#oldDatas + 1] = oldData
      end
      for x = 1, #oldDatas do
        for y = 1, #memberInfos do
          if oldDatas[x][FRIEND_COL.NAME] == memberInfos[y][FRIEND_COL.NAME] and memberInfos[y][FRIEND_COL.ONLINE] then
            memberInfos[y][FRIEND_COL.CHK] = oldDatas[x][FRIEND_COL.CHK]
          end
        end
      end
    end
    frame:DeleteAllDatas()
    local onlineMembers, totalMembers = X2Friend:GetFriendCount()
    local str = string.format("%s %s%d/%d", locale.relationship.onlineMember, FONT_COLOR_HEX.BLUE, onlineMembers, totalMembers)
    window.numOfonlineMember:SetText(str)
    frame:SetPageByItemCount(totalCount, friendPerPage)
    local curPage = math.floor((startIndex - 1) / friendPerPage) + 1
    frame.pageControl:SetCurrentPage(curPage, false)
    for i = 1, #memberInfos do
      local info = memberInfos[i]
      info[FRIEND_COL.CHK] = info[FRIEND_COL.CHK] or false
      frame:InsertData(info[FRIEND_COL.NAME], 1, info)
      frame:InsertData(info[FRIEND_COL.NAME], 2, info)
      frame:InsertData(info[FRIEND_COL.NAME], 3, info)
      frame:InsertData(info[FRIEND_COL.NAME], 4, info)
    end
    if window.listRefresh == true then
      local _, maxValue = frame.scroll.vs:GetMinMaxValues()
      if not (value < maxValue) or not value then
        value = maxValue
      end
      frame.scroll.vs:SetValue(value, true)
    end
    self.refreshButton.waiting = false
    self:WaitPage(false)
  end
  for i = 1, MAX_COUNT do
    do
      local item = listCtrl.items[i]
      function item:OnClick(arg)
        if arg == "RightButton" then
          local data = frame:GetDataByViewIndex(i, 1)
          ActivateFriendMemberPopupMenu(self, data[FRIEND_COL.NAME], data[FRIEND_COL.PARTY], data[FRIEND_COL.ONLINE])
        end
      end
      item:SetHandler("OnClick", item.OnClick)
    end
  end
  function showOffMember:CheckBtnCheckChagnedProc(checked)
    window:RequestFriendList(1)
  end
  function window:ShowFreindTab()
    self.allSelectCheck:SetChecked(false)
    self:RequestFriendList(1)
  end
  local friendEvents = {
    FRIENDLIST_UPDATE = function(updateType, dataField)
      if updateType == "insert" or updateType == "delete" then
        window:RequestFriendList(LIST_CURRENT_INDEX)
      end
    end,
    FRIENDLIST_INFO = function(totalCount, startIndex, memberInfos)
      window:FillMemberData(totalCount, startIndex + 1, memberInfos)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    friendEvents[event](...)
  end)
  RegistUIEvent(window, friendEvents)
end
