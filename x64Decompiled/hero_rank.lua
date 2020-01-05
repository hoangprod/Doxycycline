local SetViewOfHeroRankTab = function(tabWindow)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local contentWidth = tabWindow:GetWidth()
  local factionCombobox = CreateHeroFactionCombobox("factionCombobox", tabWindow, X2Hero:GetRankFactions())
  local period = W_ETC.CreatePeriodWidget("period", tabWindow, "RIGHT")
  period:UseStatusIcon(false)
  period:AddAnchor("TOPRIGHT", tabWindow, 0, sideMargin)
  local myCurRecord = tabWindow:CreateChildWidget("textbox", "myCurRecord", 0, true)
  myCurRecord:SetHeight(FONT_SIZE.LARGE)
  myCurRecord:AddAnchor("TOPRIGHT", period, "BOTTOMRIGHT", 0, sideMargin / 2)
  myCurRecord.style:SetFontSize(FONT_SIZE.LARGE)
  myCurRecord.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(myCurRecord, FONT_COLOR.BLUE)
  local RankLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    local bg = CreateContentBackground(subItem, "TYPE11", "brown")
    bg:SetWidth(widget.listCtrl:GetWidth())
    bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    bg:AddAnchor("BOTTOM", subItem, 0, 0)
    subItem.bg = bg
    local line = DrawItemUnderLine(subItem, "overlay")
    line:RemoveAllAnchors()
    line:SetVisible(false)
    line:AddAnchor("TOPLEFT", subItem, "BOTTOMLEFT", -30, -2)
    line:AddAnchor("TOPRIGHT", subItem:GetParent(), "BOTTOMRIGHT", 30, -2)
    subItem.line = line
  end
  local RankDataSetFunc = function(subItem, data, setValue)
    if setValue and data.value ~= nil then
      subItem.line:SetVisible(false)
      subItem.bg:SetVisible(false)
      if not data.isViewData then
        subItem:SetText(tostring(data.value))
        subItem.line:SetVisible(true)
        ChangeColorByAbstentionState(subItem, data.isAbstention)
      end
      local color
      if data.value <= MAX_HERO_COND then
        color = {
          ConvertColor(243),
          ConvertColor(232),
          ConvertColor(211),
          1
        }
      else
        color = {
          ConvertColor(231),
          ConvertColor(232),
          ConvertColor(226),
          1
        }
      end
      subItem.bg:SetVisible(true)
      subItem.bg:SetColor(color[1], color[2], color[3], color[4])
    else
      subItem:SetText("")
      subItem.line:SetVisible(false)
      subItem.bg:SetVisible(false)
    end
  end
  local listCtrlInfo = {
    width = contentWidth,
    height = 467,
    isHeroRank = true,
    columns = {
      {
        name = GetUIText(RANKING_TEXT, "placing"),
        width = 80,
        itemType = LCCIT_STRING,
        dataSetFunc = RankDataSetFunc,
        layoutSetFunc = RankLayoutFunc,
        tooltip = nil
      },
      {
        name = GetUIText(COMMON_TEXT, "name"),
        width = 250,
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
        name = GetUIText(COMMON_TEXT, "expedition"),
        width = 250,
        itemType = LCCIT_STRING,
        dataSetFunc = HeroExpeditionDataSetFunc,
        layoutSetFunc = HeroExpeditionLayoutSetFunc,
        tooltip = nil
      }
    }
  }
  local scrollListCtrl = CreateHeroList(tabWindow, listCtrlInfo)
  scrollListCtrl:AddAnchor("TOPRIGHT", myCurRecord, "BOTTOMRIGHT", 0, sideMargin / 2)
  tabWindow.scrollListCtrl = scrollListCtrl
  local message = tabWindow:CreateChildWidget("textbox", "message", 0, true)
  message:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  message:AddAnchor("TOP", scrollListCtrl, "BOTTOM", 0, sideMargin * 2.2)
  ApplyTextColor(message, FONT_COLOR.DEFAULT)
  local modalLoadingWindow = CreateLoadingTextureSet(tabWindow)
  modalLoadingWindow:AddAnchor("TOPLEFT", scrollListCtrl, -sideMargin + 1, 0)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", scrollListCtrl, sideMargin + -3, 0)
end
function CreateHeroRankTab(tabWindow)
  SetViewOfHeroRankTab(tabWindow)
  local comboBox = tabWindow.factionCombobox
  local myCurRecord = tabWindow.myCurRecord
  local OnEnter = function(self)
    local str = string.format([[
%s/%s
%s]], GetUIText(COMMON_TEXT, "hero_rank_period_of_leadership_point"), GetUIText(COMMON_TEXT, "accumulated_leadership_point"), GetUIText(COMMON_TEXT, "hero_rank_my_cur_record_tooltip"))
    SetTooltip(str, self)
  end
  myCurRecord:SetHandler("OnEnter", OnEnter)
  local function GetComboboxSelFactionId(selIdx)
    return comboBox.factionId[selIdx]
  end
  function comboBox:SelectedProc()
    local selFactionId = self:GetSelFactionId()
    if selFactionId == nil and selFactionId == 0 then
      return
    end
    tabWindow:WaitPage(true)
    X2Hero:RequestRankData(selFactionId)
  end
  local function FillUpperSection()
    local schedule = X2Hero:GetScheduleInfo()
    local scoreTable = X2Hero:GetMyScore()
    myCurRecord:SetWidth(tabWindow:GetWidth())
    myCurRecord:SetText(string.format("%s: %d/%s%d|r", GetUIText(RANKING_TEXT, "my_cur_record"), scoreTable.score, FONT_COLOR_HEX.DEFAULT, scoreTable.leadership))
    myCurRecord:SetWidth(myCurRecord:GetLongestLineWidth() + 10)
    if schedule == nil then
      return
    end
    local startFilter = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
    local endFilter = FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
    local str = string.format("%s: %s", GetUIText(HERO_TEXT, "schedule"), locale.common.from_to(locale.time.GetDateToDateFormat(schedule._start, startFilter), locale.time.GetDateToDateFormat(schedule._end, endFilter)))
    tabWindow.period:SetPeriod(str, true, false)
  end
  FillUpperSection()
  function tabWindow:RankDataRetrieved(factionID)
    tabWindow:WaitPage(false)
    FillUpperSection()
    tabWindow:RefreshHerolistInfo(X2Hero:GetRankingData(factionID))
  end
  local function FillBottomSection()
    tabWindow.message:SetText("")
    local heroPeriod = X2Hero:GetActivedHeroPeriod(LEADERSHIP_RANK_SCHEDULE)
    if heroPeriod ~= nil then
      local candidateCount = X2Hero:GetHeroCandidateCount()
      local startFilter = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR
      local endFilter = FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR
      local str = string.format("%s", locale.common.from_to(locale.time.GetDateToDateFormat(heroPeriod.periodStart, startFilter), locale.time.GetDateToDateFormat(heroPeriod.periodEnd, endFilter)))
      tabWindow.message:SetText(GetUIText(HERO_TEXT, "hero_rule_desc", tostring(candidateCount), str))
      tabWindow.message:SetHeight(tabWindow.message:GetTextHeight())
    end
  end
  FillBottomSection()
  function tabWindow:SeasonUpdated()
    FillUpperSection()
    FillBottomSection()
  end
end
