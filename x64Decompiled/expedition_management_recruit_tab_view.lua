BUTTON_TYPE = {
  APPLY = 1,
  APPLY_CANCEL = 2,
  RECRUITMENT_CANCEL = 3
}
function SetViewOfRecruit(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local initButton = parent:CreateChildWidget("button", "initButton", 0, true)
  initButton:Enable(true)
  initButton:SetText(GetCommonText("init"))
  initButton:AddAnchor("TOPLEFT", parent, "TOPLEFT", 0, 7)
  ApplyButtonSkin(initButton, BUTTON_BASIC.DEFAULT)
  local interestButton = parent:CreateChildWidget("button", "interestButton", 0, true)
  interestButton:Enable(true)
  interestButton:AddAnchor("LEFT", initButton, "RIGHT", 12, 0)
  ApplyButtonSkin(interestButton, BUTTON_CONTENTS.APPELLATION_OPTION)
  parent.interestIcon = {}
  local offset_x = 10
  local lastIcon = interestButton
  local IR = GetInterestList()
  for i = 1, #IR do
    do
      local icon = parent:CreateChildWidget("emptywidget", "icon", i, true)
      local iconTexture = icon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT, "icon_" .. IR[i], "background")
      local coord = {
        GetTextureInfo(TEXTURE_PATH.EXPEDITION_RECRUIT, "icon_" .. IR[i]):GetCoords()
      }
      iconTexture:AddAnchor("TOPLEFT", icon, 0, 0)
      iconTexture:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
      icon:SetExtent(coord[3], coord[4])
      icon:Show(true)
      icon:AddAnchor("LEFT", lastIcon, "RIGHT", offset_x, 0)
      function icon:OnEnter()
        SetTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_interest_" .. IR[i]), self)
      end
      icon:SetHandler("OnEnter", icon.OnEnter)
      function icon:OnLeave()
        HideTooltip()
      end
      icon:SetHandler("OnLeave", icon.OnLeave)
      parent.interestIcon[i] = icon
      lastIcon = icon
      offset_x = 0
    end
  end
  local interestBg = CreateContentBackground(parent, "TYPE2", "orange")
  interestBg:AddAnchor("TOPLEFT", interestButton, "TOPLEFT", -14, -9)
  interestBg:AddAnchor("BOTTOMRIGHT", lastIcon, "BOTTOMRIGHT", 14, 9)
  parent.interestBg = interestBg
  local levelLabal = parent:CreateChildWidget("label", "levelLabal", 0, true)
  levelLabal:SetText(GetCommonText("level"))
  levelLabal:SetHeight(FONT_SIZE.MIDDLE)
  levelLabal:SetAutoResize(true)
  levelLabal.style:SetAlign(ALIGN_RIGHT)
  levelLabal:AddAnchor("LEFT", interestButton, "RIGHT", 160, 0)
  ApplyTextColor(levelLabal, FONT_COLOR.DEFAULT)
  local minLevelEdit = W_CTRL.CreateEdit("minLevelEdit", parent)
  minLevelEdit:AddAnchor("LEFT", levelLabal, "RIGHT", 4, 0)
  minLevelEdit:SetExtent(41, DEFAULT_SIZE.EDIT_HEIGHT)
  minLevelEdit:SetDigit(true)
  minLevelEdit:SetMaxTextLength(2)
  minLevelEdit:SetInitVal(MIN_MAX_LEVEL_INIT_VAL)
  minLevelEdit:SetText(tostring(1))
  local tildeLabel = parent:CreateChildWidget("label", "tildeLabel", 0, true)
  tildeLabel:SetExtent(15, 15)
  tildeLabel:SetText("~")
  tildeLabel:AddAnchor("LEFT", minLevelEdit, "RIGHT", 2, 0)
  ApplyTextColor(tildeLabel, FONT_COLOR.TITLE)
  local maxLevelEdit = W_CTRL.CreateEdit("maxLevelEdit", parent)
  maxLevelEdit:SetExtent(41, DEFAULT_SIZE.EDIT_HEIGHT)
  maxLevelEdit:SetDigit(true)
  maxLevelEdit:SetMaxTextLength(2)
  maxLevelEdit:SetInitVal(MIN_MAX_LEVEL_INIT_VAL)
  maxLevelEdit:SetText(tostring(X2Faction:GetExpeditionMaxLevel()))
  maxLevelEdit:AddAnchor("LEFT", tildeLabel, "RIGHT", 3, 0)
  local expeditionName = W_CTRL.CreateEdit("expeditionName", parent)
  expeditionName:SetExtent(198, DEFAULT_SIZE.EDIT_HEIGHT)
  expeditionName:AddAnchor("LEFT", maxLevelEdit, "RIGHT", 10, 0)
  local searchButton = parent:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:SetText(GetCommonText("search"))
  searchButton:AddAnchor("LEFT", expeditionName, "RIGHT", 4, 0)
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  local datas = {}
  for i = 1, #expeditionLocale.texts.recruitComboBox do
    local data = {
      text = expeditionLocale.texts.recruitComboBox[i],
      value = i
    }
    table.insert(datas, data)
  end
  local comboBox = W_CTRL.CreateComboBox("comboBox", parent)
  comboBox:SetWidth(122)
  comboBox:AppendItems(datas)
  comboBox:AddAnchor("LEFT", searchButton, "RIGHT", 10, 0)
  local recruitmentList = W_CTRL.CreatePageScrollListCtrl("listCtrl", parent)
  recruitmentList.scroll:RemoveAllAnchors()
  recruitmentList.scroll:AddAnchor("TOPRIGHT", recruitmentList, 0, 0)
  recruitmentList.scroll:AddAnchor("BOTTOMRIGHT", recruitmentList, 0, 0)
  recruitmentList.listCtrl:SetColumnHeight(0)
  recruitmentList:SetExtent(parent:GetWidth(), 470)
  recruitmentList:AddAnchor("TOPLEFT", initButton, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 2)
  recruitmentList:Show(true)
  parent.recruitmentList = recruitmentList
  local SetDataFunc = function(subItem, data, setValue)
    for i = 1, #subItem.interestIcon do
      subItem.interestIcon[i]:Show(false)
    end
    subItem.blueTimeIcon:Show(false)
    subItem.redTimeIcon:Show(false)
    if setValue then
      do
        local lastIcon
        local IR = GetInterestList()
        for i = 1, #IR do
          local icon = subItem.interestIcon[i]
          if data.interests[i] == 1 then
            icon:Show(true)
            icon:RemoveAllAnchors()
            if lastIcon == nil then
              icon:AddAnchor("TOPLEFT", subItem.level, "BOTTOMLEFT", 0, 3)
            else
              icon:AddAnchor("LEFT", lastIcon, "RIGHT", 0, 0)
            end
            lastIcon = icon
          end
        end
        subItem.buttonType = BUTTON_TYPE.APPLY
        subItem.expeditionId = data.expeditionId
        subItem.level:SetText(tostring(data.expedition_level))
        subItem.expeditionName:SetText(data.expedition_name)
        ApplyTextColor(subItem.expeditionName, FONT_COLOR.DEFAULT)
        subItem.ownerName:SetText(data.owner_name)
        subItem.introduce:SetText(data.introduce)
        subItem.memberCount:SetText(tostring(data.memberCount))
        subItem.eventButton:Show(true)
        subItem.eventButton:Enable(true)
        subItem.eventButton:SetText(GetCommonText("apply"))
        subItem.bg:SetTextureColor("brown")
        local function OnEnter(self)
          SetTooltip(data.introduce, self)
        end
        subItem.introduce:SetHandler("OnEnter", OnEnter)
        local timeIcon = subItem.blueTimeIcon
        if data.remainTime < 21600 then
          timeIcon = subItem.redTimeIcon
        end
        timeIcon:Show(true)
        function timeIcon:OnEnter()
          SetTooltip(string.format(GetCommonText("recruitment_remain_time"), FormatTime(data.remainTime * 1000, false)), timeIcon)
        end
        timeIcon:SetHandler("OnEnter", timeIcon.OnEnter)
        subItem.standbyIcon:Show(false)
        subItem.impossibleIcon:Show(false)
        if data.apply == true then
          subItem.buttonType = BUTTON_TYPE.APPLY_CANCEL
          subItem.eventButton:SetText(GetCommonText("apply_cancel"))
          subItem.standbyIcon:Show(true)
          ApplyTextColor(subItem.expeditionName, FONT_COLOR.BLUE)
          subItem.bg:SetTextureColor("blue_3")
          ApplyButtonSkin(subItem.eventButton, BUTTON_BASIC.DEFAULT)
        elseif data.pull == true then
          subItem.eventButton:Enable(false)
          subItem.impossibleIcon:Show(true)
        end
        if X2Faction:GetMyExpeditionId() == 0 then
          return
        end
        if X2Unit:UnitName("player") == data.owner_name then
          subItem.buttonType = BUTTON_TYPE.RECRUITMENT_CANCEL
          subItem.eventButton:SetText(GetCommonText("delete"))
          ApplyTextColor(subItem.expeditionName, FONT_COLOR.BLUE)
          subItem.bg:SetTextureColor("blue_3")
        else
          subItem.eventButton:Enable(false)
        end
      end
    else
      subItem.level:SetText("")
      subItem.expeditionName:SetText("")
      subItem.introduce:SetText("")
      subItem.eventButton:Show(false)
    end
  end
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local bg = CreateContentBackground(subItem, "TYPE2", "brown")
    bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", subItem, 5, 5)
    subItem.bg = bg
    local image = subItem:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT, "picture", "background")
    image:AddAnchor("LEFT", subItem, "LEFT", 5, 5)
    local level = subItem:CreateChildWidget("label", "level", 0, true)
    level:SetText("0")
    level:SetHeight(FONT_SIZE.XXLARGE)
    level:SetAutoResize(true)
    level.style:SetAlign(ALIGN_LEFT)
    level.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
    level:AddAnchor("TOPLEFT", subItem, 95, 10)
    ApplyTextColor(level, FONT_COLOR.DEFAULT)
    local expeditionName = subItem:CreateChildWidget("label", "expeditionName", 0, true)
    expeditionName:SetExtent(300, FONT_SIZE.LARGE)
    expeditionName:SetHeight(FONT_SIZE.LARGE)
    expeditionName:SetAutoResize(true)
    expeditionName.style:SetAlign(ALIGN_LEFT)
    expeditionName.style:SetFontSize(FONT_SIZE.LARGE)
    expeditionName:AddAnchor("LEFT", level, "RIGHT", 4, 0)
    ApplyTextColor(expeditionName, FONT_COLOR.DEFAULT)
    local blueTimeIcon = subItem:CreateChildWidget("emptywidget", "blueTimeIcon", 0, true)
    blueTimeIcon:AddAnchor("TOP", expeditionName, "TOP", 0, 0)
    blueTimeIcon:AddAnchor("RIGHT", subItem, "RIGHT", -30, -5)
    local iconTexture = blueTimeIcon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT, "clock_blue", "background")
    iconTexture:AddAnchor("CENTER", blueTimeIcon, 0, 0)
    blueTimeIcon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
    blueTimeIcon:Show(false)
    local redTimeIcon = subItem:CreateChildWidget("emptywidget", "redTimeIcon", 0, true)
    redTimeIcon:AddAnchor("CENTER", blueTimeIcon, 0, 0)
    local iconTexture = redTimeIcon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT, "clock_red", "background")
    iconTexture:AddAnchor("CENTER", redTimeIcon, 0, 0)
    redTimeIcon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
    redTimeIcon:Show(false)
    local ownerName = subItem:CreateChildWidget("label", "ownerName", 0, true)
    ownerName:SetHeight(FONT_SIZE.MIDDLE)
    ownerName:SetAutoResize(true)
    ownerName.style:SetAlign(ALIGN_LEFT)
    ownerName:AddAnchor("RIGHT", blueTimeIcon, "LEFT", -5, 0)
    ApplyTextColor(ownerName, FONT_COLOR.DEFAULT)
    local ownerNameText = subItem:CreateChildWidget("label", "ownerNameText", 0, true)
    ownerNameText:SetExtent(300, FONT_SIZE.MIDDLE)
    ownerNameText:SetText(string.format("%s: ", GetCommonText("owner")))
    ownerNameText:SetHeight(FONT_SIZE.MIDDLE)
    ownerNameText.style:SetAlign(ALIGN_RIGHT)
    ownerNameText:AddAnchor("RIGHT", ownerName, "LEFT", 0, 0)
    ApplyTextColor(ownerNameText, FONT_COLOR.DEFAULT)
    local memberCount = subItem:CreateChildWidget("label", "memberCount", 0, true)
    memberCount:SetText("0")
    memberCount:SetHeight(FONT_SIZE.MIDDLE)
    memberCount:SetAutoResize(true)
    memberCount.style:SetAlign(ALIGN_LEFT)
    memberCount:AddAnchor("TOPRIGHT", blueTimeIcon, "BOTTOMRIGHT", -5, 7)
    ApplyTextColor(memberCount, FONT_COLOR.BLUE)
    local memberCountText = subItem:CreateChildWidget("label", "memberCountText", 0, true)
    memberCountText:SetText(string.format("%s: ", GetCommonText("number_of_people")))
    memberCountText:SetHeight(FONT_SIZE.MIDDLE)
    memberCountText:SetAutoResize(true)
    memberCountText.style:SetAlign(ALIGN_LEFT)
    memberCountText:AddAnchor("RIGHT", memberCount, "LEFT", 0, 0)
    ApplyTextColor(memberCountText, FONT_COLOR.DEFAULT)
    subItem.interestIcon = {}
    local anchor
    local IR = GetInterestList()
    for i = 1, #IR do
      do
        local icon = subItem:CreateChildWidget("emptywidget", "icon", i, true)
        local iconTexture = icon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT, "icon_" .. IR[i], "background")
        iconTexture:AddAnchor("CENTER", icon, 0, 0)
        icon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
        icon:Show(true)
        if anchor == nil then
          icon:AddAnchor("TOPLEFT", level, "BOTTOMLEFT", 0, 3)
        else
          icon:AddAnchor("LEFT", anchor, "RIGHT", 0, 0)
        end
        function icon:OnEnter()
          SetTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_interest_" .. IR[i]), self)
        end
        icon:SetHandler("OnEnter", icon.OnEnter)
        subItem.interestIcon[i] = icon
        anchor = icon
      end
    end
    local introduce = subItem:CreateChildWidget("label", "introduce", 0, true)
    introduce:SetExtent(493, FONT_SIZE.MIDDLE)
    introduce:AddAnchor("BOTTOMLEFT", subItem, 95, -10)
    introduce.style:SetAlign(ALIGN_LEFT)
    introduce.style:SetEllipsis(true)
    ApplyTextColor(introduce, FONT_COLOR.DEFAULT)
    local eventButton = subItem:CreateChildWidget("button", "eventButton", 0, true)
    eventButton:Show(false)
    eventButton:Enable(true)
    eventButton:AddAnchor("BOTTOMRIGHT", subItem, "BOTTOMRIGHT", -24, 0)
    eventButton:SetText(GetCommonText("apply"))
    ApplyButtonSkin(eventButton, BUTTON_BASIC.DEFAULT)
    local standbyIcon = subItem:CreateChildWidget("emptywidget", "standbyIcon", 0, true)
    standbyIcon:AddAnchor("RIGHT", eventButton, "LEFT", 0, 0)
    local iconTexture = standbyIcon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT_ICON, "icon_standby", "background")
    iconTexture:AddAnchor("CENTER", standbyIcon, 0, 0)
    standbyIcon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
    standbyIcon:Show(true)
    function standbyIcon:OnEnter()
      SetTooltip(GetCommonText("applicant_stanby"), self)
    end
    standbyIcon:SetHandler("OnEnter", standbyIcon.OnEnter)
    local impossibleIcon = subItem:CreateChildWidget("emptywidget", "impossibleIcon", 0, true)
    impossibleIcon:AddAnchor("CENTER", standbyIcon, 0, 0)
    local iconTexture = impossibleIcon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT_ICON, "icon_impossible", "background")
    iconTexture:AddAnchor("CENTER", impossibleIcon, 0, 0)
    impossibleIcon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
    impossibleIcon:Show(true)
    function impossibleIcon:OnEnter()
      SetTooltip(GetCommonText("applicant_impossible"), self)
    end
    impossibleIcon:SetHandler("OnEnter", impossibleIcon.OnEnter)
    function eventButton:OnClick(arg)
      ShowEventButtonWnd(subItem)
    end
    eventButton:SetHandler("OnClick", eventButton.OnClick)
    local line = CreateLine(subItem, "TYPE1")
    line:SetHeight(2)
    line:AddAnchor("LEFT", subItem, "LEFT", 80, 16)
    line:AddAnchor("RIGHT", subItem, "RIGHT", 0, 0)
  end
  recruitmentList:InsertColumn("", recruitmentList:GetWidth(), LCCIT_WINDOW, SetDataFunc, nil, nil, LayoutFunc)
  recruitmentList:InsertRows(5, false)
  recruitmentList:DeleteAllDatas()
  local check = CreateCheckButton("checkbox", parent, "")
  check:AddAnchor("BOTTOMLEFT", parent, 0, -5)
  parent.check = check
  local rejoinWaiting = parent:CreateChildWidget("label", "rejoinWaiting", 0, true)
  rejoinWaiting:SetAutoResize(true)
  rejoinWaiting:AddAnchor("TOPLEFT", check, "BOTTOMLEFT", 0, 10)
  ApplyTextColor(rejoinWaiting, FONT_COLOR.RED)
  function rejoinWaiting:OnUpdate(dt)
    local remain = X2Player:GetInstantTime(INSTANT_TIME_EXPEDITION_REJOIN)
    if remain == 0 then
      self:SetText("")
    else
      self:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_rejoin_waiting", tostring(MakeTimeString(remain))))
    end
  end
  rejoinWaiting:SetHandler("OnUpdate", rejoinWaiting.OnUpdate)
  local applicantManagementButton = parent:CreateChildWidget("button", "applicantManagementButton", 0, true)
  applicantManagementButton:AddAnchor("BOTTOMRIGHT", parent, 0, -5)
  applicantManagementButton:SetText(GetCommonText("expedition_applicant_managemanet"))
  ApplyButtonSkin(applicantManagementButton, BUTTON_BASIC.DEFAULT)
  local recruitmentButton = parent:CreateChildWidget("button", "recruitmentButton", 0, true)
  recruitmentButton:SetText(GetCommonText("expedition_recruitment"))
  recruitmentButton:AddAnchor("RIGHT", applicantManagementButton, "LEFT", -4, 0)
  ApplyButtonSkin(recruitmentButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {applicantManagementButton, recruitmentButton}
  AdjustBtnLongestTextWidth(buttonTable)
  return parent
end
