local SQUAD_LIST_EVENT_BUTTON_TYPE = {APPLY = 1, CANCEL_RECRUIT = 2}
local function SetViewOfSquadList(id, parent, width, height, titleHeight)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(width, height - titleHeight)
  local bgImg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgImg:SetTextureColor("bg_01")
  bgImg:AddAnchor("TOPLEFT", frame, 0, -titleHeight)
  bgImg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local backButton = frame:CreateChildWidget("button", "backButton", 0, true)
  backButton:Enable(true)
  backButton:AddAnchor("TOPLEFT", frame, 10, 5)
  backButton:SetText(GetCommonText("squad_recruit_and_search_exit"))
  ApplyButtonSkin(backButton, BUTTON_CONTENTS.PREV_PAGE)
  local refreshButton = frame:CreateChildWidget("button", "refreshButton", 0, true)
  ApplyButtonSkin(refreshButton, BUTTON_BASIC.RESET)
  refreshButton:AddAnchor("TOPRIGHT", frame, -16, 3)
  local squadList = CreatePageListCtrl(frame, "squadList", 0)
  squadList:SetExtent(frame:GetWidth() - 20, frame:GetHeight() - 90)
  squadList:AddAnchor("TOPLEFT", backButton, "BOTTOMLEFT", 0, 4)
  squadList:HideColumnButtons()
  local function SetFunc(subItem, info, setValue)
    subItem:Show(setValue)
    if setValue then
      subItem.info = info
      subItem.bg:SetTextureInfo("type02_new", "team_blue")
      local topStr = string.format("%s / @%s", GetLevelToString(info.ownerLevel, nil, nil, true), info.worldName)
      subItem.topText:SetText(topStr)
      subItem.charName:SetText(info.ownerName)
      if info.openType ~= 0 or not GetCommonText("squad_open_type_public") then
      end
      subItem.openType:SetText((GetCommonText("squad_open_type_private")))
      subItem.headCountText:SetText(string.format("%d / %d", info.curMemberCount, info.maxMemberCount))
      subItem.explanationText:SetText(info.explanationText)
      subItem.eventButton:Enable(info.buttonEnable)
      subItem.statusIcon:SetVisible(false)
      if info.isMySquad then
        subItem.statusIcon:SetVisible(true)
        subItem.statusIcon:SetTexture(TEXTURE_PATH.BATTLEFIELD_SUPPORTING_ICON)
        subItem.statusIcon:SetTextureInfo("supporting")
      elseif not info.isMySquad and not info.buttonEnable then
        subItem.statusIcon:SetVisible(true)
        subItem.statusIcon:SetTexture(TEXTURE_PATH.COMMON_RECRUIT_IMPOSSIBLE_ICON)
        subItem.statusIcon:SetTextureInfo("impossible_icon")
      end
      if info.isMySquad then
        subItem.bg:SetTextureInfo("type02_new", "team_green")
        local OnClick = function(self, arg)
          if arg ~= "LeftButton" then
            return
          end
          if not X2Input:IsShiftKeyDown() then
            return
          end
          if not X2Chat:IsActivatedChatInput() then
            return
          end
          local squadRecruitLinkText = X2Squad:GetLinkText()
          X2Chat:AddSquadRecruitLinkToActiveChatInput(squadRecruitLinkText)
        end
        subItem:SetHandler("OnClick", OnClick)
      else
        if info.openType == 0 then
          subItem.bg:SetTextureInfo("type02_new", "team_blue")
        else
          subItem.bg:SetTextureInfo("type02_new", "team_purple")
        end
        subItem:ReleaseHandler("OnClick")
      end
      if info.buttonType == SQUAD_LIST_EVENT_BUTTON_TYPE.APPLY then
        subItem.eventButton.buttonType = SQUAD_LIST_EVENT_BUTTON_TYPE.APPLY
        subItem.eventButton:SetText(GetCommonText("apply"))
      elseif info.buttonType == SQUAD_LIST_EVENT_BUTTON_TYPE.CANCEL_RECRUIT then
        subItem.eventButton.buttonType = SQUAD_LIST_EVENT_BUTTON_TYPE.CANCEL_RECRUIT
        subItem.eventButton:SetText(GetCommonText("delete"))
        subItem.eventButton:Enable(true)
      end
    end
  end
  local function LayoutFunc(frame, rowIndex, colIndex, subItem)
    local bg = CreateContentBackground(subItem, "TYPE2", "blue")
    bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
    subItem.bg = bg
    local recruiterLabel = subItem:CreateChildWidget("label", "recruiterLabel", 0, false)
    recruiterLabel:SetAutoResize(true)
    recruiterLabel:SetHeight(FONT_SIZE.MIDDLE)
    recruiterLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(recruiterLabel, FONT_COLOR.DEFAULT)
    recruiterLabel:SetText(GetCommonText("raid_recruiter"))
    local explanationLabel = subItem:CreateChildWidget("label", "explanationLabel", 0, false)
    explanationLabel:SetAutoResize(true)
    explanationLabel:SetHeight(FONT_SIZE.MIDDLE)
    explanationLabel.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(explanationLabel, FONT_COLOR.DEFAULT)
    explanationLabel:SetText(GetCommonText("squad_explanation"))
    local explanationWidth = explanationLabel:GetWidth()
    local recruiterWidth = recruiterLabel:GetWidth()
    local longestWidth = (explanationWidth > recruiterWidth and explanationWidth or recruiterWidth) + 20
    local recruiterBg = CreateContentBackground(subItem, "TYPE2", "white_3")
    recruiterBg:AddAnchor("TOPLEFT", bg, 5, 5)
    recruiterBg:SetExtent(longestWidth, 30)
    recruiterLabel:AddAnchor("CENTER", recruiterBg, 0, 0)
    local openType = subItem:CreateChildWidget("label", "openType", 0, true)
    openType:SetAutoResize(true)
    openType:SetHeight(FONT_SIZE.MIDDLE)
    openType:AddAnchor("TOPRIGHT", subItem, -10, 12)
    ApplyTextColor(openType, FONT_COLOR.DEFAULT)
    openType:SetText(GetCommonText("squad_open_type_public"))
    local openTypeGuide = W_ICON.CreateGuideIconWidget(openType)
    openTypeGuide:AddAnchor("RIGHT", openType, "LEFT", -1, 1)
    local OnEnter = function(self)
      SetTooltip(GetCommonText("squad_open_guide_tooltip"), self)
    end
    openTypeGuide:SetHandler("OnEnter", OnEnter)
    local headCountText = subItem:CreateChildWidget("label", "headCountText", 0, true)
    headCountText:SetHeight(FONT_SIZE.MIDDLE)
    headCountText:SetAutoResize(true)
    headCountText:AddAnchor("TOPRIGHT", openType, "BOTTOMRIGHT", 0, 10)
    ApplyTextColor(headCountText, FONT_COLOR.BLUE)
    headCountText:SetText("")
    local headCountIcon = subItem:CreateDrawable(TEXTURE_PATH.PEOPLE, "people", "overlay")
    headCountIcon:AddAnchor("RIGHT", headCountText, "LEFT", -4, 0)
    local topText = subItem:CreateChildWidget("textBox", "topText", 0, true)
    topText:SetHeight(FONT_SIZE.MIDDLE)
    topText.style:SetAlign(ALIGN_TOP_LEFT)
    topText:AddAnchor("TOPLEFT", recruiterBg, "TOPRIGHT", 7, 7)
    topText:AddAnchor("TOPRIGHT", openTypeGuide, "TOPLEFT", -5, 0)
    ApplyTextColor(topText, FONT_COLOR.BLUE)
    topText:SetAutoResize(true)
    local charName = subItem:CreateChildWidget("characternamelabel", "charName", 0, true)
    charName:SetExtent(topText:GetWidth(), FONT_SIZE.MIDDLE)
    charName.style:SetFontSize(FONT_SIZE.MIDDLE)
    charName.style:SetAlign(ALIGN_TOP_LEFT)
    charName:AddAnchor("TOPLEFT", topText, "BOTTOMLEFT", 0, 5)
    ApplyTextColor(charName, FONT_COLOR.BLUE)
    local line = CreateLine(subItem, "TYPE1")
    line:SetHeight(2)
    line:AddAnchor("LEFT", subItem, "LEFT", 0, -10)
    line:AddAnchor("RIGHT", subItem, "RIGHT", 0, -10)
    local eventButton = subItem:CreateChildWidget("button", "eventButton", 0, true)
    eventButton:AddAnchor("TOPRIGHT", line, "TOPRIGHT", -8, 17)
    eventButton:SetText(GetCommonText("apply"))
    ApplyButtonSkin(eventButton, BUTTON_BASIC.DEFAULT)
    local function OnClickEvenButton(self)
      if self.buttonType == SQUAD_LIST_EVENT_BUTTON_TYPE.APPLY then
        X2Squad:JoinSquad(subItem.info.squadId, subItem.info.fieldType, subItem.info.zoneGroupType)
      elseif self.buttonType == SQUAD_LIST_EVENT_BUTTON_TYPE.CANCEL_RECRUIT then
        X2Squad:DisbandSquadInRecruitList()
      end
    end
    eventButton:SetHandler("OnClick", OnClickEvenButton)
    local statusIcon = subItem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SUPPORTING_ICON, "supporting", "overlay")
    statusIcon:AddAnchor("RIGHT", eventButton, "LEFT", -3, 0)
    subItem.statusIcon = statusIcon
    local explanationBg = CreateContentBackground(subItem, "TYPE2", "white_3")
    explanationBg:AddAnchor("TOPLEFT", line, 5, 5)
    explanationBg:SetExtent(longestWidth, 30)
    explanationLabel:AddAnchor("CENTER", explanationBg, 0, 0)
    local explanationText = subItem:CreateChildWidget("textBox", "explanationText", 0, true)
    explanationText:SetHeight(FONT_SIZE.MIDDLE)
    explanationText.style:SetAlign(ALIGN_TOP_LEFT)
    explanationText:AddAnchor("TOPLEFT", explanationBg, "TOPRIGHT", 9, 8)
    explanationText:AddAnchor("TOPRIGHT", statusIcon, "TOPLEFT", -5, 0)
    ApplyTextColor(explanationText, FONT_COLOR.BLUE)
  end
  squadList:InsertColumn("", squadList:GetWidth(), LCCIT_WINDOW, SetFunc, nil, nil, LayoutFunc)
  squadList:InsertRows(MAX_SQUAD_SELECT_COUNT_PER_PAGE, false)
  squadList.listCtrl:DisuseSorting()
  squadList:DeleteAllDatas()
  frame.squadList = squadList
  local inviteGuide = W_ICON.CreateGuideIconWidget(frame)
  inviteGuide:AddAnchor("TOPLEFT", frame, "BOTTOMLEFT", 0, 16)
  local inviteGuideLabel = frame:CreateChildWidget("label", "inviteGuideLabel", 0, true)
  inviteGuideLabel:SetAutoResize(true)
  inviteGuideLabel:SetHeight(FONT_SIZE.MIDDLE)
  inviteGuideLabel:AddAnchor("LEFT", inviteGuide, "RIGHT", 5, 0)
  ApplyTextColor(inviteGuideLabel, FONT_COLOR.DEFAULT)
  inviteGuideLabel:SetText(GetCommonText("how_to_invite"))
  local OnEnterInviteGuide = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "squad_invite_guide"), self)
  end
  inviteGuide:SetHandler("OnEnter", OnEnterInviteGuide)
  local recruitButton = frame:CreateChildWidget("button", "recruitButton", 0, true)
  recruitButton:SetText(GetCommonText("raid_recruit"))
  recruitButton:AddAnchor("TOPRIGHT", frame, "BOTTOMRIGHT", -1, 9)
  ApplyButtonSkin(recruitButton, BUTTON_BASIC.DEFAULT)
  return frame
end
function CreateSquadList(id, parent, width, height, titleHeight)
  local frame = SetViewOfSquadList(id, parent, width, height, titleHeight)
  local squadList = frame.squadList
  local recruitButton = frame.recruitButton
  local currentInstance
  function frame:SetCurrentInstance(type)
    currentInstance = type
  end
  local function OnClickRecruitButton()
    if X2Squad:IsInstanceQueuedOrJoined() or X2Team:IsSiegeRaidTeam() then
      return
    end
    if currentInstance == nil then
      return
    end
    ShowSquadRecruit(frame, currentInstance)
  end
  ButtonOnClickHandler(recruitButton, OnClickRecruitButton)
  local function RefreshSquadList()
    if currentInstance == nil then
      return
    end
    X2Squad:GetSquadList(currentInstance, frame.squadList.pageControl:GetCurrentPageIndex() - 1)
  end
  ButtonOnClickHandler(frame.refreshButton, RefreshSquadList)
  function frame.squadList:OnPageChangedProc(pageIndex)
    if currentInstance == nil then
      return
    end
    X2Squad:GetSquadList(currentInstance, pageIndex - 1)
  end
  function frame:UpdateSquadList(data)
    squadList:DeleteAllDatas()
    if currentInstance == nil then
      return
    end
    for i = 1, #data do
      local info = data[i]
      squadList:InsertData(i, 1, info)
    end
    squadList.pageControl:SetPageByItemCount(data.maxCount, MAX_SQUAD_SELECT_COUNT_PER_PAGE)
    squadList.pageControl:SetCurrentPage(data.curPage + 1, false)
    recruitButton:Enable(not X2Squad:HasMySquad() and not X2Team:IsSiegeRaidTeam())
  end
  local events = {
    SELECT_SQUAD_LIST = function(data)
      if not frame:IsVisible() then
        return
      end
      frame:UpdateSquadList(data)
    end,
    REFRESH_SQUAD_LIST = function()
      RefreshSquadList()
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(frame, events)
  return frame
end
