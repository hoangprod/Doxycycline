SQUAD_PER_COUNT = 10
function SetViewOfSquad(id, parent)
  local wnd = CreateWindow(id, parent)
  wnd:SetExtent(680, 474)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetCommonText("squad_info_title"))
  wnd:Show(true)
  local subTitleBox = wnd:CreateChildWidget("emptywidget", "subTitleBox", 0, true)
  subTitleBox:SetExtent(wnd:GetWidth() - 40, 39)
  subTitleBox:AddAnchor("TOP", wnd, 0, 50)
  local subTitle = subTitleBox:CreateChildWidget("label", "subTitle", 0, true)
  SetFontStyle(subTitle, 0, FONT_SIZE.XXLARGE, FONT_COLOR.MIDDLE_TITLE, FONT_PATH.LEEYAGI)
  subTitle:AddAnchor("LEFT", subTitleBox, "LEFT", 0, 0)
  subTitle:AddAnchor("RIGHT", subTitleBox, "RIGHT", 0, 0)
  subTitle:SetText("Field Name")
  subTitle.style:SetAlign(ALIGN_CENTER)
  local subTitleBg = subTitleBox:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  subTitleBg:SetTextureColor("bg_01")
  subTitleBg:AddAnchor("TOPLEFT", subTitleBox, 0, 0)
  subTitleBg:AddAnchor("BOTTOMRIGHT", subTitleBox, 0, 0)
  local list = CreatePageListCtrl(wnd, "list", 0)
  list:Show(true)
  list:SetExtent(641, 275)
  list:AddAnchor("TOP", subTitleBox, "BOTTOM", 0, 40)
  list.pageControl:Show(false)
  wnd.list = list
  local SetNameFunc = function(subItem, data, setValue)
    if setValue then
      if data.leader then
        subItem.leaderMark:SetMarkTexture("leader")
        subItem.leaderMark:AddAnchor("LEFT", subItem.readyImg, "RIGHT", 3, 0)
        subItem.name:AddAnchor("LEFT", subItem.leaderMark, "RIGHT", 3, -1)
      else
        subItem.leaderMark:RemoveAllAnchors()
        subItem.leaderMark:SetMarkTexture("")
        subItem.name:RemoveAllAnchors()
        subItem.name:AddAnchor("LEFT", subItem.readyImg, "RIGHT", 3, 0)
      end
      subItem.name:SetText(data.name)
      subItem.readyImg:Show(data.ready)
      subItem.waitingImg:Show(not data.ready)
      subItem.charId = data.charId
      if data.offline then
        ApplyTextColor(subItem.name, FONT_COLOR.GRAY)
      else
        local info = W_MODULE:GetRoleInfoByRole(data.role)
        ApplyTextColor(subItem.name, info.fontColor)
      end
    else
      subItem.name:SetText("")
    end
  end
  local SetLevelFunc = function(subItem, data, setValue)
    if setValue then
      if data.offline then
        subItem:SetText(GetLevelToString(data.level, FONT_COLOR_HEX.GRAY))
      else
        subItem:SetText(GetLevelToString(data.level))
      end
    else
      subItem:SetText("")
    end
  end
  local SetJobNameFunc = function(subItem, data, setValue)
    if setValue then
      if data.offline then
        ApplyTextColor(subItem, FONT_COLOR.GRAY)
      else
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
      subItem:SetText(string.format("%s", F_UNIT.GetCombinedAbilityName(data.abilities[1], data.abilities[2], data.abilities[3])))
    else
      subItem:SetText("")
    end
  end
  local SetServerNameFunc = function(subItem, data, setValue)
    if setValue then
      if data.offline then
        ApplyTextColor(subItem, FONT_COLOR.GRAY)
      else
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
      subItem:SetText(data.serverName)
    else
      subItem:SetText("")
    end
  end
  local SetRoleFunc = function(subItem, data, setValue)
    if setValue then
      subItem.roleLabel:Show(true)
      subItem.roleLabel:SetRole(data.role)
      subItem.roleSelectButton:Show(data.isMe)
      subItem.isMe = data.isMe
      subItem.charId = data.charId
      subItem.worldId = data.worldId
    else
      subItem.roleLabel:Show(false)
    end
  end
  local LayoutNameFunc = function(list, rowIndex, colIndex, subItem)
    ApplyTextColor(list.listCtrl.column[colIndex], FONT_COLOR.DEFAULT)
    local leaderMark = W_ICON.CreateLeaderMark("leaderMark", subItem)
    leaderMark:AddAnchor("LEFT", subItem, "RIGHT", 0, 0)
    leaderMark:SetMarkTexture("leader")
    subItem.leaderMark = leaderMark
    local name = subItem:CreateChildWidget("characternamelabel", "nameLabel", 0, true)
    name.style:SetFontSize(FONT_SIZE.MIDDLE)
    name.style:SetAlign(ALIGN_LEFT)
    name:AddAnchor("LEFT", leaderMark, "RIGHT", 0, 0)
    ApplyTextColor(name, FONT_COLOR.DEFAULT)
    subItem.name = name
    local readyImg = subItem:CreateDrawable(TEXTURE_PATH.HUD, "ready_check", "background")
    readyImg:AddAnchor("TOPLEFT", subItem, "TOPLEFT", 0, 5)
    subItem.readyImg = readyImg
    local waitingImg = subItem:CreateDrawable(TEXTURE_PATH.ICON_WAITING, "icon_waiting", "background")
    waitingImg:AddAnchor("TOPLEFT", subItem, "TOPLEFT", 0, 10)
    subItem.waitingImg = waitingImg
  end
  local LayoutLevelFunc = function(list, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem:SetInset(2, 2, 2, 2)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutJobNameFunc = function(list, rowIndex, colIndex, subItem)
    subItem:SetInset(2, 2, 2, 2)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutServerNameFunc = function(list, rowIndex, colIndex, subItem)
    subItem:SetInset(2, 2, 2, 2)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local LayoutRoleFunc = function(list, rowIndex, colIndex, subItem)
    local roleLabel = CreateRoleLabel("roleLabel", subItem)
    roleLabel:AddAnchor("CENTER", subItem, -5, 0)
    local roleSelectButton = subItem:CreateChildWidget("button", "roleSelectButton", 0, true)
    ApplyButtonSkin(roleSelectButton, BUTTON_CONTENTS.SQUAD_ROLE_SELECT)
    roleSelectButton:AddAnchor("RIGHT", subItem, 0, 0)
    local squadRoleFrame = CreateRoleFrame("squadRoleFrame", roleSelectButton)
    squadRoleFrame:AddAnchor("TOPLEFT", roleSelectButton, "TOPRIGHT", 0, 0)
    subItem.squadRoleFrame = squadRoleFrame
    function squadRoleFrame:GetMyRole()
      local data = X2Squad:GetMyRoleInfo()
      return data.role
    end
    function squadRoleFrame:SetMyRole(role)
      X2Squad:SetMyRole(role)
    end
    function roleSelectButton:OnClick()
      squadRoleFrame:Show(not squadRoleFrame:IsVisible())
    end
    roleSelectButton:SetHandler("OnClick", roleSelectButton.OnClick)
    local line = CreateLine(subItem:GetParent(), "TYPE1")
    line:AddAnchor("TOPLEFT", subItem:GetParent(), "BOTTOMLEFT", 0, 0)
    line:AddAnchor("TOPRIGHT", subItem:GetParent(), "BOTTOMRIGHT", 0, 0)
    subItem:GetParent().line = line
  end
  list:InsertColumn(GetCommonText("name"), 226, LCCIT_WINDOW, SetNameFunc, nil, nil, LayoutNameFunc)
  list:InsertColumn(GetCommonText("level"), 58, LCCIT_TEXTBOX, SetLevelFunc, nil, nil, LayoutLevelFunc)
  list:InsertColumn(GetUIText(COMMUNITY_TEXT, "job"), 149, LCCIT_TEXTBOX, SetJobNameFunc, nil, nil, LayoutJobNameFunc)
  list:InsertColumn(GetCommonText("squad_info_list_server_name"), 96, LCCIT_STRING, SetServerNameFunc, nil, nil, LayoutServerNameFunc)
  list:InsertColumn(GetUIText(COMMUNITY_TEXT, "role"), 112, LCCIT_WINDOW, SetRoleFunc, nil, nil, LayoutRoleFunc)
  list:InsertRows(SQUAD_PER_COUNT, false)
  list.listCtrl:DisuseSorting()
  DrawListCtrlUnderLine(list)
  for i = 1, #list.listCtrl.column do
    SettingListColumn(list.listCtrl, list.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(list.listCtrl.column[i], #list.listCtrl.column, i)
    SetButtonFontColor(list.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  local openTypeLabel = wnd:CreateChildWidget("label", "openTypeLabel", 0, true)
  openTypeLabel:AddAnchor("BOTTOMLEFT", list, "TOPLEFT", 10, -10)
  openTypeLabel:SetAutoResize(true)
  openTypeLabel:SetHeight(FONT_SIZE.MIDDLE)
  openTypeLabel.style:SetAlign(ALIGN_LEFT)
  openTypeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(openTypeLabel, FONT_COLOR.DEFAULT)
  openTypeLabel:SetText(GetCommonText("squad_open_type"))
  local radioData = {
    {
      text = GetCommonText("squad_open_type_public"),
      value = 0
    },
    {
      text = GetCommonText("squad_open_type_private"),
      value = 1
    }
  }
  local openTypeRadioBoxes = CreateRadioGroup("openTypeRadioBoxes", wnd, "horizen")
  openTypeRadioBoxes:AddAnchor("LEFT", openTypeLabel, "RIGHT", 8, 0)
  openTypeRadioBoxes:SetData(radioData)
  openTypeRadioBoxes:Check(1)
  wnd.openTypeRadioBoxes = openTypeRadioBoxes
  function openTypeRadioBoxes:OnRadioChanged(index, dataValue)
    X2Squad:ChangeOpenType(dataValue)
  end
  openTypeRadioBoxes:SetHandler("OnRadioChanged", openTypeRadioBoxes.OnRadioChanged)
  local openTypeBg = CreateContentBackground(wnd, "TYPE2", "brown")
  openTypeBg:AddAnchor("TOPLEFT", openTypeLabel, -10, -10)
  openTypeBg:AddAnchor("BOTTOMRIGHT", openTypeRadioBoxes, 10, 10)
  local refreshButton = wnd:CreateChildWidget("button", "refreshButton", 0, true)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  refreshButton:AddAnchor("BOTTOMRIGHT", list, "TOPRIGHT", 0, -3)
  local squadCount = wnd:CreateChildWidget("textbox", "squadCount", 0, true)
  squadCount.style:SetAlign(ALIGN_CENTER)
  squadCount.style:SetFontSize(FONT_SIZE.LARGE)
  squadCount:SetAutoResize(true)
  squadCount:SetExtent(wnd:GetWidth(), 28)
  ApplyTextColor(squadCount, FONT_COLOR.DEFAULT)
  squadCount:AddAnchor("RIGHT", refreshButton, "LEFT", 0, 0)
  local squadCountBg = CreateContentBackground(wnd, "TYPE2", "brown")
  squadCountBg:SetExtent(wnd:GetWidth(), 28)
  squadCountBg:AddAnchor("LEFT", squadCount, "LEFT", -5, 0)
  squadCountBg:AddAnchor("RIGHT", refreshButton, "RIGHT", 2, 0)
  local leaveSquadButton = wnd:CreateChildWidget("button", "leaveSquadButton", 0, true)
  leaveSquadButton:SetText(GetCommonText("squad_info_leave_squad"))
  ApplyButtonSkin(leaveSquadButton, BUTTON_BASIC.DEFAULT)
  leaveSquadButton:AddAnchor("BOTTOMLEFT", wnd, "BOTTOMLEFT", 20, -20)
  local disbandSquadButton = wnd:CreateChildWidget("button", "disbandSquadButton", 0, true)
  disbandSquadButton:SetText(GetCommonText("squad_info_disband_squad"))
  ApplyButtonSkin(disbandSquadButton, BUTTON_BASIC.DEFAULT)
  disbandSquadButton:AddAnchor("LEFT", leaveSquadButton, "RIGHT", 3, 0)
  local eventButton = wnd:CreateChildWidget("button", "eventButton", 0, true)
  eventButton:SetText(GetCommonText("squad_info_ready"))
  ApplyButtonSkin(eventButton, BUTTON_BASIC.DEFAULT)
  eventButton:AddAnchor("BOTTOMRIGHT", wnd, "BOTTOMRIGHT", -20, -20)
  wnd:Show(false)
  return wnd
end
