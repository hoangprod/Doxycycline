RAID_RECRUIT_PER_COUNT = 4
EVENT_BUTTON_TYPE = {
  APPLY = 1,
  APPLY_CANCEL = 2,
  RECRUIT_CANCEL = 3
}
function SetViewRecruitTypeIcon(parent, anchorWidget)
  parent.typeIcon = {}
  local offset_x = 10
  local lastIcon = anchorWidget
  local RECRUIT_TYPE_ICON = GetRecruitTypeIconList()
  local recruitTypeList = X2Team:GetRaidRecruitTypeList()
  for i = 1, #RECRUIT_TYPE_ICON do
    do
      local icon = parent:CreateChildWidget("emptywidget", "icon", i, true)
      local texture = icon:CreateImageDrawable(TEXTURE_PATH.RAID_RECRUIT, "background")
      local coord = {
        GetTextureInfo(TEXTURE_PATH.RAID_RECRUIT, "icon_" .. RECRUIT_TYPE_ICON[i]):GetCoords()
      }
      texture:SetCoords(coord[1], coord[2], coord[3], coord[4])
      texture:AddAnchor("TOPLEFT", icon, 0, 0)
      texture:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
      icon.tex = texture
      icon:SetExtent(coord[3], coord[4])
      icon:Show(true)
      icon:AddAnchor("LEFT", lastIcon, "RIGHT", offset_x, 0)
      function icon:OnEnter()
        SetTooltip(recruitTypeList[i].name, self)
      end
      icon:SetHandler("OnEnter", icon.OnEnter)
      lastIcon = icon
      offset_x = 0
      parent.typeIcon[i] = icon
    end
  end
  return lastIcon
end
function SetViewRaidRecruitTypeOptionWindow(id, parent)
  local window = CreateSubOptionWindow(id, parent)
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:SetExtent(30, FONT_SIZE.LARGE)
  title:SetAutoResize(true)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title:SetText(GetCommonText("raid_type_1"))
  title:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_SIDE)
  title.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(title, FONT_COLOR.SOFT_BROWN)
  local RECRUIT_TYPE_ICON = GetRecruitTypeIconList()
  local recruitTypeList = X2Team:GetRaidRecruitTypeList()
  window.interestChks = {}
  local maxWidth = title:GetWidth()
  local offsetY = 10
  for i = 1, #RECRUIT_TYPE_ICON do
    local text = recruitTypeList[i].name
    local path = TEXTURE_PATH.RAID_RECRUIT
    local key = "icon_" .. RECRUIT_TYPE_ICON[i]
    local checkbox = CreateCheckButton(string.format("checkbox[%d]", i), window, text)
    checkbox:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, offsetY)
    checkbox:SetButtonStyle("soft_brown")
    local icon = checkbox:CreateDrawable(path, key, "background")
    icon:AddAnchor("LEFT", checkbox, "RIGHT", 5, 0)
    checkbox.textButton:RemoveAllAnchors()
    checkbox.textButton:AddAnchor("LEFT", icon, "RIGHT", 5, 0)
    local width = checkbox:GetWidth() + icon:GetWidth() + checkbox.textButton:GetWidth() + 10
    maxWidth = math.max(maxWidth, width)
    offsetY = offsetY + 25
    window.interestChks[i] = checkbox
  end
  maxWidth = maxWidth + MARGIN.WINDOW_SIDE * 2.2
  local height = MARGIN.WINDOW_SIDE * 2
  local _, contentHeight = F_LAYOUT.GetExtentWidgets(title, window.interestChks[#RECRUIT_TYPE_ICON])
  if contentHeight ~= nil then
    height = height + contentHeight
  end
  window:SetExtent(maxWidth, height)
  return window
end
function SetViewOfRaidRecruit(parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow("raidRecruitMgr", parent)
  wnd:SetExtent(600, 631)
  wnd:AddAnchor("CENTER", parent, 0, 0)
  wnd:SetTitle(GetCommonText("raid_recruit_and_search"))
  wnd:SetCloseOnEscape(true)
  wnd:ApplyUIScale(false)
  wnd.waitApplicantAccept = false
  local searchButton = wnd:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:Enable(true)
  searchButton:SetText(GetCommonText("search"))
  searchButton:AddAnchor("TOPRIGHT", wnd, "TOPRIGHT", -sideMargin, -bottomMargin)
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  local initButton = wnd:CreateChildWidget("button", "initButton", 0, true)
  initButton:Enable(true)
  initButton:SetText(GetCommonText("init"))
  initButton:AddAnchor("TOPLEFT", wnd, "TOPLEFT", sideMargin, -bottomMargin)
  ApplyButtonSkin(initButton, BUTTON_BASIC.DEFAULT)
  local recruitTypeButton = wnd:CreateChildWidget("button", "recruitTypeButton", 0, true)
  recruitTypeButton:Enable(true)
  recruitTypeButton:AddAnchor("LEFT", initButton, "RIGHT", 12, 0)
  ApplyButtonSkin(recruitTypeButton, BUTTON_CONTENTS.APPELLATION_OPTION)
  local lastIcon = SetViewRecruitTypeIcon(wnd, recruitTypeButton)
  local subTypeComboBox = W_CTRL.CreateComboBox("subTypeComboBox", wnd)
  subTypeComboBox:SetWidth(wnd:GetWidth())
  subTypeComboBox:AddAnchor("LEFT", lastIcon, "RIGHT", 10, 0)
  subTypeComboBox:AddAnchor("RIGHT", searchButton, "LEFT", -5, 0)
  subTypeComboBox:SetVisibleItemCount(10)
  local recruitList = CreatePageListCtrl(wnd, "recruitList", 0)
  recruitList:Show(true)
  recruitList:SetExtent(wnd:GetWidth() - 36, wnd:GetHeight() - 220)
  recruitList:AddAnchor("CENTER", wnd, 0, 0)
  recruitList.listCtrl:SetColumnHeight(0)
  wnd.recruitList = recruitList
  local function SetFunc(subItem, info, setValue)
    subItem:Show(setValue)
    subItem.info = info
    subItem.typeIcon:Show(setValue)
    subItem.timeIcon:Show(setValue)
    subItem.eventButton:Show(setValue)
    subItem.eventButton:Enable(setValue)
    subItem.waitIcon:Show(false)
    subItem.notApplyIcon:Show(false)
    subItem.timeText:SetText("")
    subItem.subTypeText:SetText("")
    subItem.headCountText:SetText("")
    subItem.charInfoText:SetText("")
    subItem.bg:SetTextureColor("brown")
    if setValue then
      local siegeRaidRecruit = X2Team:IsSiegeRaidRecruitType(info.type, info.subType)
      local RECRUIT_TYPE_ICON = GetRecruitTypeIconList()
      subItem.boardImage:SetTextureInfo(RECRUIT_TYPE_ICON[info.type] .. "_image")
      subItem.typeIcon:SetTextureInfo("icon_" .. RECRUIT_TYPE_ICON[info.type])
      subItem.siegeRaidTypeIcon:SetVisible(siegeRaidRecruit)
      subItem.eventButton:Enable(true)
      subItem.eventButton.buttonType = EVENT_BUTTON_TYPE.APPLY
      subItem.eventButton:SetText(GetCommonText("apply"))
      if wnd.waitApplicantAccept then
        subItem.eventButton:Enable(false)
      end
      if info.myRecruit == true then
        if siegeRaidRecruit then
          subItem.eventButton:Enable(false)
        else
          subItem.eventButton.buttonType = EVENT_BUTTON_TYPE.RECRUIT_CANCEL
        end
        subItem.eventButton:SetText(GetCommonText("delete"))
        subItem.bg:SetTextureColor("green")
      elseif info.myApplicant == true then
        subItem.waitIcon:Show(true)
        subItem.eventButton.buttonType = EVENT_BUTTON_TYPE.APPLY_CANCEL
        subItem.eventButton:SetText(GetCommonText("apply_cancel"))
        subItem.bg:SetTextureColor("blue_3")
      else
        local level = X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player")
        if info.fullApplicant or info.myTeamOwner or info.memberCount >= info.headCount or info.applicantCount >= info.maxApplicantCount or level < info.limitLevel then
          subItem.notApplyIcon:Show(true)
          subItem.eventButton:Enable(false)
          subItem.bg:SetTextureColor("gray")
        end
      end
      subItem.subTypeText:SetText(info.subTypeName)
      subItem.timeText:SetText(string.format("%02d : %02d", info.hour, info.minute))
      function OnEnter(self)
        local tipInfo = {}
        tipInfo.hour = info.hour
        tipInfo.minute = info.minute
        local tooltip = locale.time.GetDateToDateFormat(info, FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE):match("^%s*(.-)%s*$")
        SetTooltip(string.format("%s: %s", GetCommonText("raid_departure_time"), tooltip), self, true)
      end
      subItem.timeText:SetHandler("OnEnter", OnEnter)
      subItem.headCountText:SetText(string.format("%d / %d", info.memberCount, info.headCount))
      subItem.levelLmit:SetText(GetLevelToString(info.limitLevel, nil, nil, true))
      subItem.charInfoText:SetText(string.format([[
%s|r
%s]], GetLevelToString(info.ownerLevel, nil, nil, true), info.ownerName))
      local function OnEnter(self)
        if "" == info.ownerExpedition then
          info.ownerExpedition = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "nobody")
        end
        local expedition = string.format("%s: %s", GetCommonText("expedition"), info.ownerExpedition)
        local job = string.format("%s: %s", X2Locale:LocalizeUiText(COMMUNITY_TEXT, "job"), F_UNIT.GetCombinedAbilityName(info.ownerAbilities[1], info.ownerAbilities[2], info.ownerAbilities[3]))
        local gearPoint = string.format("%s: %d", GetCommonText("gear_score"), info.gearPoint)
        local leadershipPoint = string.format("%s: %d", GetCommonText("leadership_point"), info.leadershipPoint)
        local tooltip = string.format([[
%s
%s
%s%s|r
%s]], expedition, job, F_COLOR.GetColor("bright_blue", true), gearPoint, leadershipPoint)
        SetTooltip(tooltip, self, true)
      end
      subItem.charInfoText:SetHandler("OnEnter", OnEnter)
      local function OnEnter(self)
        local tooltip = string.format("%s: %d/%d", GetCommonText("raid_applicant_count"), info.applicantCount, info.maxApplicantCount)
        SetTooltip(tooltip, self)
      end
      subItem.headCountText:SetHandler("OnEnter", OnEnter)
      local function OnClick(self, arg)
        if arg ~= "LeftButton" then
          return
        end
        if not info.myRecruit then
          return
        end
        if not X2Input:IsShiftKeyDown() then
          return
        end
        if not X2Chat:IsActivatedChatInput() then
          return
        end
        local raidRecruitLinkText = X2Team:GetLinkText()
        X2Chat:AddRaidRecruitLinkToActiveChatInput(raidRecruitLinkText)
      end
      subItem:SetHandler("OnClick", OnClick)
    end
  end
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local bg = CreateContentBackground(subItem, "TYPE2", "brown")
    bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", subItem, 5, 5)
    subItem.bg = bg
    local boardImage = subItem:CreateImageDrawable(TEXTURE_PATH.RAID_RECRUIT_BOARD, "background")
    boardImage:AddAnchor("TOPLEFT", subItem, "TOPLEFT", 8, 12)
    subItem.boardImage = boardImage
    local typeIcon = subItem:CreateImageDrawable(TEXTURE_PATH.RAID_RECRUIT, "overlay")
    typeIcon:AddAnchor("TOPLEFT", boardImage, 2, 2)
    subItem.typeIcon = typeIcon
    local timeIcon = subItem:CreateDrawable(TEXTURE_PATH.RAID_RECRUIT_BOARD, "clock", "overlay")
    timeIcon:AddAnchor("BOTTOMLEFT", boardImage, 4, -5)
    subItem.timeIcon = timeIcon
    local siegeRaidTypeIcon = subItem:CreateDrawable(TEXTURE_PATH.SIEGE_RAID_RECRUIT_BOARD, "war_flag", "background")
    siegeRaidTypeIcon:AddAnchor("RIGHT", bg, "RIGHT", 0, 0)
    siegeRaidTypeIcon:SetVisible(false)
    subItem.siegeRaidTypeIcon = siegeRaidTypeIcon
    local timeText = subItem:CreateChildWidget("label", "timeText", 0, true)
    timeText:SetHeight(FONT_SIZE.MIDDLE)
    timeText:SetAutoResize(true)
    timeText.style:SetAlign(ALIGN_LEFT)
    timeText:AddAnchor("TOPLEFT", timeIcon, "TOPRIGHT", 5, -5)
    timeText:AddAnchor("BOTTOMRIGHT", boardImage, "BOTTOMRIGHT", 0, 0)
    ApplyTextColor(timeText, FONT_COLOR.BLUE)
    local line = CreateLine(subItem, "TYPE1")
    line:SetHeight(2)
    line:AddAnchor("LEFT", subItem, "LEFT", 80, -5)
    line:AddAnchor("RIGHT", subItem, "RIGHT", 0, -10)
    local headCountIcon = subItem:CreateDrawable(TEXTURE_PATH.PEOPLE, "people", "overlay")
    headCountIcon:AddAnchor("RIGHT", subItem, "RIGHT", -60, -26)
    local headCountText = subItem:CreateChildWidget("label", "headCountText", 0, true)
    headCountText:SetHeight(FONT_SIZE.MIDDLE)
    headCountText:SetAutoResize(true)
    headCountText.style:SetAlign(ALIGN_LEFT)
    headCountText:AddAnchor("LEFT", headCountIcon, "RIGHT", 3, 0)
    ApplyTextColor(headCountText, FONT_COLOR.BLUE)
    local levelBg = CreateContentBackground(subItem, "TYPE2", "white_3")
    levelBg:AddAnchor("TOPLEFT", line, "TOPLEFT", 10, -34)
    levelBg:AddAnchor("BOTTOMRIGHT", line, "BOTTOMLEFT", 10 + RAID_RECRUIT_LIST_LABEL_WIDTH, -4)
    local levelLmit = subItem:CreateChildWidget("textbox", "levelLmit", 0, true)
    levelLmit:SetAutoResize(true)
    levelLmit.style:SetAlign(ALIGN_CENTER)
    levelLmit:AddAnchor("TOPLEFT", levelBg, "TOPLEFT", 0, 0)
    levelLmit:AddAnchor("BOTTOMRIGHT", levelBg, "BOTTOMRIGHT", 0, 0)
    ApplyTextColor(levelLmit, FONT_COLOR.DEFAULT)
    local subTypeText = subItem:CreateChildWidget("textbox", "subTypeText", 0, true)
    subTypeText:SetAutoResize(true)
    subTypeText.style:SetAlign(ALIGN_LEFT)
    subTypeText:AddAnchor("LEFT", levelLmit, "RIGHT", 0, 0)
    subTypeText:AddAnchor("RIGHT", headCountIcon, "LEFT", 0, 5)
    ApplyTextColor(subTypeText, FONT_COLOR.DEFAULT)
    local eventButton = subItem:CreateChildWidget("button", "eventButton", 0, true)
    eventButton:Enable(true)
    eventButton:AddAnchor("TOPRIGHT", line, "TOPRIGHT", -8, 10)
    eventButton:SetText(GetCommonText("apply"))
    ApplyButtonSkin(eventButton, BUTTON_BASIC.DEFAULT)
    function eventButton:OnClick(arg)
      EventButtonClick(subItem)
    end
    eventButton:SetHandler("OnClick", eventButton.OnClick)
    local waitIcon = subItem:CreateDrawable(TEXTURE_PATH.RAID_RECRUIT_SITUATION, "wait_icon", "overlay")
    waitIcon:AddAnchor("RIGHT", eventButton, "LEFT", -3, 0)
    subItem.waitIcon = waitIcon
    local notApplyIcon = subItem:CreateDrawable(TEXTURE_PATH.COMMON_RECRUIT_IMPOSSIBLE_ICON, "impossible_icon", "overlay")
    notApplyIcon:AddAnchor("CENTER", waitIcon, 0, 0)
    subItem.notApplyIcon = notApplyIcon
    local recruiterBg = CreateContentBackground(subItem, "TYPE2", "white_3")
    recruiterBg:AddAnchor("TOPLEFT", levelBg, "TOPLEFT", 0, 36)
    recruiterBg:AddAnchor("BOTTOMRIGHT", levelBg, "BOTTOMRIGHT", 0, 36)
    local recruiterLabel = subItem:CreateChildWidget("label", "recruiterLabel", 0, true)
    recruiterLabel:SetAutoResize(true)
    recruiterLabel:SetHeight(FONT_SIZE.MIDDLE)
    recruiterLabel.style:SetAlign(ALIGN_CENTER)
    recruiterLabel:AddAnchor("TOPLEFT", recruiterBg, "TOPLEFT", 0, 0)
    recruiterLabel:AddAnchor("BOTTOMRIGHT", recruiterBg, "BOTTOMRIGHT", 0, 0)
    ApplyTextColor(recruiterLabel, FONT_COLOR.DEFAULT)
    recruiterLabel:SetText(GetCommonText("raid_recruiter"))
    local charInfoText = subItem:CreateChildWidget("textBox", "charInfoText", 0, true)
    charInfoText:SetHeight(FONT_SIZE.MIDDLE)
    charInfoText.style:SetAlign(ALIGN_TOP_LEFT)
    charInfoText:AddAnchor("TOPLEFT", recruiterLabel, "TOPRIGHT", 0, 8)
    charInfoText:AddAnchor("BOTTOMRIGHT", waitIcon, "BOTTOMLEFT", 0, 0)
    ApplyTextColor(charInfoText, FONT_COLOR.BLUE)
  end
  recruitList:InsertColumn("", recruitList:GetWidth(), LCCIT_WINDOW, SetFunc, nil, nil, LayoutFunc)
  recruitList:InsertRows(RAID_RECRUIT_PER_COUNT, false)
  recruitList.listCtrl:DisuseSorting()
  recruitList:DeleteAllDatas()
  local refreshButton = wnd:CreateChildWidget("button", "refreshButton", 0, true)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  refreshButton:AddAnchor("RIGHT", recruitList, "RIGHT", 0, 0)
  refreshButton:AddAnchor("TOP", recruitList.pageControl, "TOP", 0, 0)
  local applicantButton = wnd:CreateChildWidget("button", "applicantButton", 0, true)
  applicantButton:SetText(GetCommonText("raid_applicant_managemanet"))
  applicantButton:AddAnchor("BOTTOMRIGHT", recruitList, 0, 90)
  ApplyButtonSkin(applicantButton, BUTTON_BASIC.DEFAULT)
  local recruitButton = wnd:CreateChildWidget("button", "recruitButton", 0, true)
  recruitButton:SetText(GetCommonText("raid_recruit"))
  recruitButton:AddAnchor("RIGHT", applicantButton, "LEFT", 0, 0)
  ApplyButtonSkin(recruitButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {applicantButton, recruitButton}
  AdjustBtnLongestTextWidth(buttonTable)
  wnd.recruitTypeOptWnd = SetViewRaidRecruitTypeOptionWindow("recruitType", wnd)
  wnd.recruitTypeOptWnd:AddAnchor("TOPLEFT", wnd.recruitTypeButton, "TOPRIGHT", 0, 10)
  wnd.recruitTypeOptWnd:Show(false)
  local tooltipIcon = W_ICON.CreateGuideIconWidget(wnd)
  tooltipIcon:AddAnchor("BOTTOMLEFT", wnd, MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE - 10)
  local tooltipText = wnd:CreateChildWidget("label", "tooltipText", 0, true)
  tooltipText:SetAutoResize(true)
  tooltipText:SetHeight(FONT_SIZE.MIDDLE)
  tooltipText.style:SetAlign(ALIGN_CENTER)
  tooltipText.style:SetFontSize(FONT_SIZE.MIDDLE)
  tooltipText:AddAnchor("LEFT", tooltipIcon, "RIGHT", 0, 0)
  tooltipText:SetText(GetCommonText("raid_recruit_auto_delete"))
  ApplyTextColor(tooltipText, FONT_COLOR.DEFAULT)
  local tooltip = wnd:CreateChildWidget("label", "tooltip", 0, true)
  tooltip:AddAnchor("TOPLEFT", tooltipIcon, "TOPLEFT", 0, 0)
  tooltip:AddAnchor("BOTTOMRIGHT", tooltipText, "BOTTOMRIGHT", 0, 0)
  local OnEnter = function(self)
    SetTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "raid_recruit_auto_delete_tooltip", F_COLOR.GetColor("original_dark_orange", true), tostring(RAID_RECRUIT_EXPIRE_DELAY_MINUTE)), self)
  end
  tooltip:SetHandler("OnEnter", OnEnter)
  return wnd
end
