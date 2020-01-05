function ShowFamilyMemberTab(TabWnd)
  SetViewOfFamilyMember(TabWnd)
  function TabWnd:Refresh()
    local list = self.memberList
    list:DeleteAllDatas()
    for i = 1, FAMILY_MEMBER_PER_COUNT do
      do
        local item = list.listCtrl.items[i]
        function item:OnClick(arg)
          if arg == "RightButton" then
            local data = list:GetDataByViewIndex(i, 1)
            ActivateFamilyMemberPopupMenu(TabWnd, self, data.charId, data.name, data.title, data.online)
          end
        end
        item:SetHandler("OnClick", item.OnClick)
        function item.lockButton:OnClick(arg)
          X2Family:OpenIncreaseMember()
        end
        item.lockButton:SetHandler("OnClick", item.lockButton.OnClick)
      end
    end
    local memberList = X2Family:GetMemberList(self.viewOffMember:GetChecked())
    local totalPage = math.floor(maxIncMemberCount / FAMILY_MEMBER_PER_COUNT) + 1
    local insertCount = totalPage * FAMILY_MEMBER_PER_COUNT
    for i = 1, insertCount do
      local member = memberList[i]
      if member == nil then
        member = {}
        member.empty = true
      else
        member.empty = false
      end
      member.lock = false
      if memberCount < maxIncMemberCount and member.empty and i <= maxIncMemberCount and i > maxMemberCount and i > memberCount then
        member.lock = true
      end
      member.line = false
      if member.empty == false or i <= maxIncMemberCount then
        member.line = true
      end
      list:InsertData(i, 1, member)
      list:InsertData(i, 2, member)
      list:InsertData(i, 3, member)
      list:InsertData(i, 4, member)
    end
    list.pageControl:SetPageByItemCount(maxIncMemberCount, FAMILY_MEMBER_PER_COUNT)
    list.pageControl:MoveFirstPage()
    local onlineMembers, totalMembers = X2Family:GetMemberCount()
    self.memberCountTextbox:SetText(string.format("%s : %s%d|r/%s", GetCommonText("family_online_member_count"), FONT_COLOR_HEX.BLUE, onlineMembers, totalMembers))
  end
  function TabWnd:OnShow()
    self.viewOffMember:SetChecked(false, false)
    self.inputName:SetText("")
    self:Refresh()
  end
  TabWnd:SetHandler("OnShow", TabWnd.OnShow)
  function viewOffMemberChagned()
    TabWnd:Refresh()
  end
  TabWnd.viewOffMember:SetHandler("OnCheckChanged", viewOffMemberChagned)
  local inputName = TabWnd.inputName
  function inputName:OnTextChanged()
    self:CheckNamePolicy(VNT_CHAR)
    local name = self:GetText()
    if string.len(name) >= 1 then
      TabWnd.joinButton:Enable(true)
    else
      TabWnd.joinButton:Enable(false)
    end
  end
  inputName:SetHandler("OnTextChanged", inputName.OnTextChanged)
  function joinButton()
    if TabWnd.inputName:GetText() == "" then
      return
    end
    X2Family:OpenJoin(TabWnd.inputName:GetText())
    TabWnd.inputName:SetText("")
  end
  TabWnd.joinButton:SetHandler("OnClick", joinButton)
  function leaveButton()
    X2Family:OpenLeave()
  end
  TabWnd.leaveButton:SetHandler("OnClick", leaveButton)
  function refreshButton()
    TabWnd:Refresh()
  end
  TabWnd.refreshButton:SetHandler("OnClick", refreshButton)
end
