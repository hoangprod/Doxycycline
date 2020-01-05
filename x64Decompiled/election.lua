local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local SetViewOfHeroElectionWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetTitle(GetUIText(COMMON_TEXT, "hero_vote"))
  window:SetExtent(800, 745)
  window:EnableHidingIsRemove(true)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  local contentWidth = window:GetWidth() - sideMargin * 2
  local serverName = window:CreateChildWidget("label", "serverName", 0, true)
  serverName:SetExtent(contentWidth, FONT_SIZE.LARGE)
  serverName:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  serverName.style:SetAlign(ALIGN_LEFT)
  serverName:SetInset(10, 0, 0, 0)
  ApplyTextColor(serverName, FONT_COLOR.DEFAULT)
  local upperSection = window:CreateChildWidget("emptywidget", "upperSection", 0, true)
  upperSection:SetExtent(contentWidth, 50)
  upperSection:AddAnchor("TOPLEFT", serverName, "BOTTOMLEFT", 0, sideMargin / 4)
  local bg = CreateContentBackground(upperSection, "TYPE5", "brown")
  bg:AddAnchor("TOPLEFT", upperSection, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", upperSection, 0, 0)
  local factionName = upperSection:CreateChildWidget("label", "factionName", 0, true)
  factionName:SetAutoResize(true)
  factionName:SetHeight(FONT_SIZE.LARGE)
  factionName:AddAnchor("LEFT", upperSection, sideMargin / 2, 0)
  factionName.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(factionName, FONT_COLOR.BLUE)
  local iconKeys = {inProgress = "inprog", ended = "standby"}
  local period = W_ETC.CreatePeriodWidget("period", upperSection, "RIGHT", iconKeys)
  period:AddAnchor("RIGHT", upperSection, -sideMargin / 2, 0)
  upperSection.period = period
  local REPUTATION_STATUS_ICONS = {
    nil,
    "icon_notgood",
    "icon_normal",
    "icon_good"
  }
  local REPUTATION_GRADE = {
    NO_INFO = 0,
    BAD = 1,
    NORMAL = 2,
    GOOD = 3
  }
  local function HeroReputationDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem.icon:SetVisible(false)
      if data.isAbstention then
        return
      end
      if data.value == nil then
        return
      end
      if data.value == REPUTATION_GRADE.NO_INFO then
        return
      end
      local key = REPUTATION_STATUS_ICONS[data.value + 1]
      if key == nil then
        return
      end
      subItem.icon:SetVisible(true)
      subItem.icon:SetTextureInfo(key)
    else
      subItem.icon:SetVisible(false)
    end
  end
  local HeroReputationLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local icon = subItem:CreateDrawable(TEXTURE_PATH.REPUTATION_STATUS, "icon_notgood", "overlay")
    icon:AddAnchor("CENTER", subItem, 0, 1)
    subItem.icon = icon
  end
  local listCtrlInfo = {
    width = contentWidth,
    height = 515,
    isHeroRank = false,
    columns = {
      {
        name = GetUIText(RANKING_TEXT, "placing"),
        width = 60,
        itemType = LCCIT_STRING,
        dataSetFunc = HeroCommonDataSetFunc,
        layoutSetFunc = nil,
        tooltip = nil
      },
      {
        name = GetUIText(COMMON_TEXT, "name"),
        width = 220,
        itemType = LCCIT_CHARACTER_NAME,
        dataSetFunc = HeroNameDataSetFunc,
        layoutSetFunc = nil,
        tooltip = nil
      },
      {
        name = GetUIText(COMMON_TEXT, "leadership_point"),
        width = 155,
        itemType = LCCIT_STRING,
        dataSetFunc = HeroLeadershipPointDataSetFunc,
        layoutSetFunc = HeroLeadrshipPointLayoutSetFunc,
        tooltip = string.format("%s/%s", GetUIText(COMMON_TEXT, "hero_rank_period_of_leadership_point"), GetUIText(COMMON_TEXT, "accumulated_leadership_point"))
      },
      {
        name = GetUIText(COMMON_TEXT, "reputation"),
        width = 80,
        itemType = LCCIT_STRING,
        dataSetFunc = HeroReputationDataSetFunc,
        layoutSetFunc = HeroReputationLayoutSetFunc,
        tooltip = nil
      },
      {
        name = GetUIText(COMMON_TEXT, "expedition"),
        width = 220,
        itemType = LCCIT_STRING,
        dataSetFunc = HeroExpeditionDataSetFunc,
        layoutSetFunc = HeroExpeditionLayoutSetFunc,
        tooltip = nil
      }
    }
  }
  local scrollListCtrl = CreateHeroList(window, listCtrlInfo)
  scrollListCtrl:AddAnchor("TOPLEFT", upperSection, "BOTTOMLEFT", 0, sideMargin / 2)
  window.scrollListCtrl = scrollListCtrl
  local bg = CreateContentBackground(scrollListCtrl, "TYPE11", "brown_3")
  bg:AddAnchor("TOPLEFT", scrollListCtrl.listCtrl.column[1], "BOTTOMLEFT", 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", scrollListCtrl.listCtrl, 0, 0)
  for itemIdx = 1, #scrollListCtrl.listCtrl.items do
    if itemIdx ~= #scrollListCtrl.listCtrl.items then
      local line = DrawItemUnderLine(scrollListCtrl.listCtrl.items[itemIdx], "overlay")
      line:SetVisible(false)
      line:SetColor(1, 1, 1, 0.5)
      scrollListCtrl.listCtrl.items[itemIdx].line = line
    end
  end
  local message = window:CreateChildWidget("textbox", "message", 0, true)
  message:SetExtent(contentWidth, FONT_SIZE.LARGE)
  message:AddAnchor("TOP", scrollListCtrl, "BOTTOM", 0, sideMargin / 1.4)
  message.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(message, FONT_COLOR.BLUE)
  local info = {
    leftButtonStr = GetUIText(COMMON_TEXT, "abstention"),
    buttonBottomInset = -sideMargin,
    rightButtonLeftClickFunc = function()
      window:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(window, info)
  window.leftButton:Enable(false)
  return window
end
local function CreateHeroElectionWindow(id, parent)
  local window = SetViewOfHeroElectionWindow(id, parent)
  local COL = {
    RANK = 1,
    NAME = 2,
    LEADERSHIP_POINT = 3,
    REPUTATION = 4,
    EXPEDITION = 5
  }
  local upperSection = window.upperSection
  local startFilter = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
  local endFilter = FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
  local function FillUpperSection()
    window.serverName:SetText(X2World:GetCurrentWorldName())
    upperSection.factionName:SetText(X2Unit:GetTopLevelFactionName("player"))
    local periodInfo = X2Hero:GetElectionPeriod()
    if periodInfo == nil then
      return
    end
    local str = string.format("%s: %s", GetUIText(COMMON_TEXT, "election_period"), locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter)))
    upperSection.period:SetPeriod(str, X2Hero:IsElectionPeriod(), false)
  end
  local function FillLowerSection()
    local factionName = X2Unit:GetTopLevelFactionName("player")
    local LeftButtonClickFunc
    if X2Hero:IsElectionPeriod() then
      do
        local periodInfo = X2Hero:GetActivedHeroPeriod(HERO_VOTING_SCHEDULE)
        if periodInfo ~= nil then
          local periodStr = locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter))
          local str = GetUIText(COMMON_TEXT, "hero_election_rule", periodStr)
          window.message:SetText(str)
          window.message:SetHeight(window.message:GetTextHeight())
        end
        window.leftButton:SetText(GetUIText(COMMON_TEXT, "election"))
        window.leftButton:Enable(false)
        local selectedIdx = 0
        local selectedRank = 0
        function LeftButtonClickFunc()
          local function DialogHandler(wnd)
            local selectedName = window.scrollListCtrl.listCtrl.items[selectedIdx].subItems[2]:GetText()
            if selectedName == nil or selectedRank == 0 or selectedName == "" then
              return
            end
            wnd:SetTitle(GetUIText(COMMON_TEXT, "hero_vote"))
            wnd:SetContent(GetUIText(COMMON_TEXT, "hero_vote_dialog_content", string.format("%s%s%s", FONT_COLOR_HEX.BLUE, selectedName, FONT_COLOR_HEX.DEFAULT)))
            local tip = wnd:CreateChildWidget("label", "tip", 0, false)
            tip:SetExtent(window:GetWidth() - sideMargin * 2, FONT_SIZE.MIDDLE)
            tip:SetText(GetUIText(COMMON_TEXT, "hero_vote_able_once"))
            tip:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, sideMargin / 1.5)
            ApplyTextColor(tip, FONT_COLOR.DEFAULT)
            wnd:RegistBottomWidget(tip)
            function wnd:OkProc()
              X2Hero:RequestElection(selectedRank)
            end
          end
          X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
        end
        function window.scrollListCtrl:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
          window.leftButton:Enable(false)
          local isVoter = X2Hero:IsVoter()
          if not isVoter then
            return
          end
          if selDataIdx <= 0 or selDataIdx > self:GetDataCount() then
            return
          end
          local nameColDatas = window.scrollListCtrl:GetSelectedData(COL.NAME)
          if nameColDatas == nil or nameColDatas.value == "" or nameColDatas.value == "abstainer_player" then
            return
          end
          local rankColDatas = window.scrollListCtrl:GetSelectedData(COL.RANK)
          if rankColDatas == nil or rankColDatas.value == nil then
            return
          end
          selectedIdx = selDataViewIdx
          selectedRank = rankColDatas.value
          window.leftButton:Enable(true)
        end
      end
    else
      local periodInfo = X2Hero:GetAbstainPeriod()
      if periodInfo ~= nil then
        local periodStr = locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter))
        local str = string.format("%s: %s", GetUIText(COMMON_TEXT, "here_abstain_period"), periodStr)
        window.message:SetText(str)
        window.message:SetHeight(window.message:GetTextHeight())
      end
      window.leftButton:SetText(GetUIText(COMMON_TEXT, "abstention"))
      window.leftButton:Enable(X2Hero:IsCandidate())
      function LeftButtonClickFunc()
        local function DialogHandler(wnd)
          wnd:SetTitle(GetUIText(COMMON_TEXT, "candidate_abstention"))
          wnd:SetContent(GetUIText(COMMON_TEXT, "here_abstain_dialog_content", string.format("%s%s%s\r", FONT_COLOR_HEX.BLUE, factionName, FONT_COLOR_HEX.DEFAULT)))
          function wnd:OkProc()
            X2Hero:RequestAbstain()
          end
        end
        X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
      end
    end
    window.message:SetHeight(window.message:GetTextHeight())
    if LeftButtonClickFunc ~= nil then
      window.leftButton:SetHandler("OnClick", LeftButtonClickFunc)
    end
  end
  function window:FillInfo()
    FillUpperSection()
    FillLowerSection()
    local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, window.message)
    height = height + window.leftButton:GetHeight() + sideMargin * 1.7
    window:SetHeight(height)
  end
  return window
end
local heroElectionWnd
local function ShowHeroElectionWnd(arg)
  if not X2Player:GetFeatureSet().hero then
    return
  end
  if heroElectionWnd == nil then
    heroElectionWnd = CreateHeroElectionWindow("heroElectionWnd", "UIParent")
    local function OnHide()
      heroElectionWnd = nil
    end
    heroElectionWnd:SetHandler("OnHide", OnHide)
  end
  if arg == nil then
    if not heroElectionWnd:IsVisible() then
      heroElectionWnd:RefreshHerolistInfo(X2Hero:GetCandidateList())
      heroElectionWnd:FillInfo()
      if X2Hero:IsAlreadyVoted() then
        local msg = X2Locale:LocalizeUiText(COMMON_TEXT, "hero_already_vote_noti")
        AddMessageToSysMsgWindow(msg)
      end
    end
    heroElectionWnd:Show(not heroElectionWnd:IsVisible())
  else
    heroElectionWnd:Show(arg)
  end
end
UIParent:SetEventHandler("HERO_ELECTION", ShowHeroElectionWnd)
local function EndInteraction()
  ShowHeroElectionWnd(false)
end
UIParent:SetEventHandler("INTERACTION_END", EndInteraction)
