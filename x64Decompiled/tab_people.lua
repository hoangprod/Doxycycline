PEOPLE_INFO_LIST = {
  NAME = "name",
  LEVEL = "level",
  EXPEDITION_NAME = "expeditionName",
  ONLINE = "online",
  HEIR_LEVEL = "heir_level",
  VIEW_COUNT = 3
}
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local ITEM_COUNT_PER_PAGE = 15
local function CreatePeopleList(id, parent)
  local frame = W_CTRL.CreatePageScrollListCtrl(id, parent)
  frame:Show(true)
  frame:AddAnchor("TOPLEFT", parent, 0, sideMargin / 2)
  frame:AddAnchor("BOTTOMRIGHT", parent, 0, bottomMargin * 1.5)
  frame:SetAlpha(1)
  local LevelLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:Raise()
    subItem:Show(true)
    subItem:SetAutoResize(true)
    subItem:AddAnchor("CENTER", subItem, 0, 0)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local heirIcon = subItem:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor_small", "artwork")
    heirIcon:AddAnchor("RIGHT", subItem, "LEFT", -4, 0)
    subItem.heirIcon = heirIcon
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    subItem:SetText(tostring(data[PEOPLE_INFO_LIST.NAME]))
    ChangeSubItemTextColorForOnline(subItem, data[PEOPLE_INFO_LIST.ONLINE])
  end
  local LevelDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local lv = data[PEOPLE_INFO_LIST.LEVEL]
      if data[PEOPLE_INFO_LIST.HEIR_LEVEL] > 0 then
        lv = data[PEOPLE_INFO_LIST.HEIR_LEVEL]
        subItem.heirIcon:Show(true)
      else
        subItem.heirIcon:Show(false)
      end
      if data[PEOPLE_INFO_LIST.ONLINE] then
        subItem.heirIcon:SetTextureInfo("successor_small")
      else
        subItem.heirIcon:SetTextureInfo("successor_small_gray")
      end
      subItem:SetText(tostring(lv))
      ChangeSubItemTextColorForOnline(subItem, data[PEOPLE_INFO_LIST.ONLINE])
    end
  end
  local ExpeditionDataSetFunc = function(subItem, data, setValue)
    subItem:SetText(tostring(data[PEOPLE_INFO_LIST.EXPEDITION_NAME]))
    ChangeSubItemTextColorForOnline(subItem, data[PEOPLE_INFO_LIST.ONLINE])
  end
  frame:InsertColumn(locale.faction.name, 315, LCCIT_STRING, NameDataSetFunc, nil, nil)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "level"), 168, LCCIT_STRING, LevelDataSetFunc, nil, nil, LevelLayoutFunc)
  frame:InsertColumn(GetUIText(COMMON_TEXT, "expedition"), 350, LCCIT_STRING, ExpeditionDataSetFunc, nil, nil)
  frame:InsertRows(ITEM_COUNT_PER_PAGE, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  frame.listCtrl:UseOverClickTexture()
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
  end
  frame.listCtrl:DisuseSorting()
  return frame
end
local function SetViewOfPeopleTabOfNationMgr(window)
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("BOTTOMLEFT", window, 0, -4)
  window.guide = guide
  local OnEnter = function(self)
    SetTargetAnchorTooltip(locale.nationMgr.regist_condition_tip(X2Nation:NationImmigrateLevelMin()), "BOTTOMLEFT", self, "BOTTOMRIGHT", 0, 0)
  end
  guide:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeave)
  local conditionLabel = window:CreateChildWidget("label", "conditionLabel", 0, false)
  conditionLabel:SetAutoResize(true)
  conditionLabel:SetHeight(FONT_SIZE.MIDDLE)
  conditionLabel:AddAnchor("LEFT", guide, "RIGHT", 0, 0)
  ApplyTextColor(conditionLabel, FONT_COLOR.DEFAULT)
  local nameEdit = W_CTRL.CreateEdit("nameEdit", window)
  nameEdit:SetExtent(230, DEFAULT_SIZE.EDIT_HEIGHT)
  nameEdit:AddAnchor("LEFT", conditionLabel, "RIGHT", 4, 0)
  nameEdit:CreateGuideText(locale.common.input_name_guide, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local registBtn = window:CreateChildWidget("button", "registBtn", 0, true)
  registBtn:Enable(false)
  registBtn:SetText(locale.nationMgr.peopleInvite)
  ApplyButtonSkin(registBtn, BUTTON_BASIC.DEFAULT)
  registBtn:AddAnchor("LEFT", nameEdit, "RIGHT", 5, 0)
  local exileBtn = window:CreateChildWidget("button", "exileBtn", 0, true)
  exileBtn:Enable(false)
  exileBtn:SetText(locale.nationMgr.peopleKick)
  ApplyButtonSkin(exileBtn, BUTTON_BASIC.DEFAULT)
  exileBtn:AddAnchor("LEFT", registBtn, "RIGHT", 0, 0)
  local buttonTable = {registBtn, exileBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  local delegationBtn = window:CreateChildWidget("button", "delegationBtn", 0, true)
  delegationBtn:SetText(GetUIText(NATION_TEXT, "delegation_owner"))
  ApplyButtonSkin(delegationBtn, BUTTON_BASIC.DEFAULT)
  delegationBtn:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local withdrawBtn = window:CreateChildWidget("button", "withdrawBtn", 0, true)
  withdrawBtn:SetText(locale.nationMgr.withdrawNation)
  ApplyButtonSkin(withdrawBtn, BUTTON_BASIC.DEFAULT)
  withdrawBtn:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local expeditionImmigration = X2Player:GetFeatureSet().expeditionImmigration
  local immigrationBtn = window:CreateChildWidget("button", "immigrationBtn", 0, true)
  immigrationBtn:SetText(GetCommonText("immigration_expediton_management"))
  immigrationBtn:Enable(expeditionImmigration)
  immigrationBtn:Show(expeditionImmigration)
  ApplyButtonSkin(immigrationBtn, BUTTON_BASIC.DEFAULT)
  local rightBtn = delegationBtn:GetWidth() > withdrawBtn:GetWidth() and delegationBtn or withdrawBtn
  immigrationBtn:AddAnchor("RIGHT", rightBtn, "LEFT", 0, 0)
  local leftGroupLastBtn = exileBtn
  local rightGroupFirstBtn = immigrationBtn
  local posLeftX, _ = leftGroupLastBtn:GetOffset()
  local posRightX, _ = rightGroupFirstBtn:GetOffset()
  local diff = posLeftX + leftGroupLastBtn:GetWidth() - posRightX
  if diff > 0 then
    nameEdit:SetExtent(nameEdit:GetWidth() - diff, DEFAULT_SIZE.EDIT_HEIGHT)
  end
  function nameEdit:TextChangedFunc()
    self:CheckNamePolicy(VNT_CHAR)
    local text = self:GetText()
    local enable = string.len(text) >= 1
    registBtn:Enable(enable)
    exileBtn:Enable(enable)
  end
  local function RegistBtnLeftClickFunc()
    X2Nation:InviteToFaction(nameEdit:GetText())
    nameEdit:SetText("")
  end
  ButtonOnClickHandler(registBtn, RegistBtnLeftClickFunc)
  local OnEnter = function(self)
    SetTooltip(locale.nationMgr.peopleManageInviteToolTip, self)
  end
  registBtn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  registBtn:SetHandler("OnLeave", OnLeave)
  local function ExileBtnLeftClickFunc()
    X2Nation:KickToFaction(nameEdit:GetText())
    nameEdit:SetText("")
  end
  ButtonOnClickHandler(exileBtn, ExileBtnLeftClickFunc)
  local OnEnter = function(self)
    SetTooltip(locale.nationMgr.peopleManageKickToolTip, self)
  end
  exileBtn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  exileBtn:SetHandler("OnLeave", OnLeave)
  local function immigrationBtnLeftClickFunc()
    ShowExpeditionImmigration(window)
  end
  ButtonOnClickHandler(immigrationBtn, immigrationBtnLeftClickFunc)
  function delegationBtn:OnClick()
    ShowNationDelegate()
  end
  delegationBtn:SetHandler("OnClick", delegationBtn.OnClick)
  function withdrawBtn:OnClick()
    local factionId = X2Faction:GetMyTopLevelFaction()
    X2Nation:WithdrawToNation(factionId)
  end
  withdrawBtn:SetHandler("OnClick", withdrawBtn.OnClick)
  local peopleList = CreatePeopleList("peopleList", window)
  peopleList:AddAnchor("TOPLEFT", window, 0, 0)
  local memberCount = window:CreateChildWidget("textbox", "memberCount", 0, true)
  memberCount:AddAnchor("BOTTOMRIGHT", delegationBtn, "TOPRIGHT", 0, -5)
  memberCount:SetExtent(300, 20)
  memberCount.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(memberCount, FONT_COLOR.DEFAULT)
  local viewOffMember = CreateCheckButton("viewOffMember", window, GetUIText(NATION_TEXT, "view_offline_member"), TEXTURE_PATH.CHECK_EYE_SHAPE)
  viewOffMember:SetButtonStyle("eyeShape")
  viewOffMember:AddAnchor("BOTTOMLEFT", guide, "TOPLEFT", viewOffMember.textButton:GetWidth() + 3, -5)
  window.viewOffMember = viewOffMember
  function viewOffMember:CheckBtnCheckChagnedProc()
    window.peopleList.pageControl:MoveFirstPage()
  end
  viewOffMember:SetHandler("OnCheckChanged", viewOffMember.CheckBtnCheckChagnedProc)
  local refreshButton = window:CreateChildWidget("button", "refreshButton", 0, true)
  refreshButton:AddAnchor("TOPRIGHT", window, 3, 13)
  refreshButton:Show(true)
  refreshButton:SetExtent(28, 28)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  function refreshButton:OnUpdate(dt)
    local refreshButton = window.refreshButton
    local viewOffMember = window.viewOffMember
    local pageControl = window.peopleList.pageControl
    refreshButton.time = refreshButton.time + dt
    pageControl:Enable(false)
    local REFRESH_COOL_DOWN = 1000
    if REFRESH_COOL_DOWN < refreshButton.time and not refreshButton.waiting then
      refreshButton:Enable(true)
      pageControl:Enable(true)
      viewOffMember:SetEnableCheckButton(true)
      refreshButton:ReleaseHandler("OnUpdate")
    end
    local MAX_TIME_OUT = 20000
    if MAX_TIME_OUT < refreshButton.time then
      refreshButton:Enable(true)
      pageControl:Enable(true)
      viewOffMember:SetEnableCheckButton(true)
      refreshButton:ReleaseHandler("OnUpdate")
    end
  end
  local function RefreshBtnLeftClickFunc()
    window:FillListData()
  end
  ButtonOnClickHandler(refreshButton, RefreshBtnLeftClickFunc)
end
function CreatePeopleTabOfNationMgr(window)
  SetViewOfPeopleTabOfNationMgr(window)
  function window:FillListData(initPage)
    local refreshButton = window.refreshButton
    local viewOffMember = window.viewOffMember
    local pageControl = window.peopleList.pageControl
    local peopleList = window.peopleList
    local memberCount = window.memberCount
    refreshButton.time = 0
    refreshButton.waiting = true
    refreshButton:Enable(false)
    viewOffMember:Enable(false)
    pageControl:Enable(false)
    refreshButton:SetHandler("OnUpdate", refreshButton.OnUpdate)
    local pageControl = window.peopleList.pageControl
    local curPage = window.peopleList:GetCurrentPageIndex()
    if initPage == 1 then
      curPage = 1
    end
    local memberInfos, totalMembersCount, MEMBERS_PER_PAGE
    local allMember = viewOffMember:GetChecked()
    if allMember == true then
      memberInfos, totalMembersCount, MEMBERS_PER_PAGE = X2Nation:GetNationAllMemberList(curPage)
    else
      memberInfos, totalMembersCount, MEMBERS_PER_PAGE = X2Nation:GetNationOnlineMemberList(curPage)
    end
    if memberInfos == nil then
      refreshButton.waiting = false
      return
    end
    peopleList:DeleteAllDatas()
    for i = 1, #memberInfos do
      local info = memberInfos[i]
      for j = 1, PEOPLE_INFO_LIST.VIEW_COUNT do
        peopleList:InsertData(info[PEOPLE_INFO_LIST.NAME], j, info)
      end
    end
    peopleList:Enable(true)
    peopleList:SetPageByItemCount(totalMembersCount, MEMBERS_PER_PAGE)
    for i = 1, math.min(#memberInfos, ITEM_COUNT_PER_PAGE) do
      do
        local item = window.peopleList.listCtrl.items[i]
        if item then
          function item:OnClick(arg)
            if arg == "RightButton" then
              local data = peopleList:GetDataByViewIndex(i, PEOPLE_INFO_LIST.VIEW_COUNT)
              if data then
                ActivateNationMemberPopupMenu(self, data[PEOPLE_INFO_LIST.NAME], data[PEOPLE_INFO_LIST.ONLINE])
              end
            end
          end
          item:SetHandler("OnClick", item.OnClick)
        end
      end
    end
    local onlineMemberCount, maxMemberCount = X2Nation:GetNationOnlineAndAllMemberCount()
    memberCount:SetText(string.format("%s %s%d/%d", GetCommonText("nation_people_online_count"), FONT_COLOR_HEX.BLUE, onlineMemberCount, maxMemberCount))
    refreshButton.waiting = false
  end
  function window.peopleList:OnPageChangedProc()
    window:FillListData()
  end
  function window:Init()
    self.nameEdit:SetText("")
    self.registBtn:Enable(false)
    self.exileBtn:Enable(false)
    window.viewOffMember:SetChecked(false, false)
    window:FillListData(1)
    local factionId = X2Faction:GetMyTopLevelFaction()
    local myName = X2Unit:UnitName("player")
    local isKing = X2Nation:IsNationOwner(factionId, myName)
    self.nameEdit:Show(isKing)
    self.registBtn:Show(isKing)
    self.exileBtn:Show(isKing)
    window.delegationBtn:Show(isKing)
    window.withdrawBtn:Show(not isKing)
    local rightBtn = isKing and window.delegationBtn or window.withdrawBtn
    window.immigrationBtn:RemoveAllAnchors()
    window.immigrationBtn:AddAnchor("RIGHT", rightBtn, "LEFT", 0, 0)
  end
  function window:OnHide()
    if window.immigrationWnd ~= nil then
      window.immigrationWnd:Show(false)
    end
  end
  window:SetHandler("OnHide", window.OnHide)
  local events = {
    NATION_MEMBER_REFRESH = function()
      window:FillListData()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
