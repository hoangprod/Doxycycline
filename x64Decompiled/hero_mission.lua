local SetViewOfHeroMissionTab = function(tabWindow)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local contentWidth = tabWindow:GetWidth()
  local factionCombobox = CreateHeroFactionCombobox("factionCombobox", tabWindow, X2Hero:GetRankFactions())
  factionCombobox:RemoveAllAnchors()
  factionCombobox:AddAnchor("TOPLEFT", tabWindow, 0, 15)
  local guide = W_ICON.CreateGuideIconWidget(tabWindow)
  guide:AddAnchor("TOPRIGHT", tabWindow, 0, 22)
  tabWindow.guide = guide
  local OnEnter = function(self)
    SetTargetAnchorTooltip(GetUIText(COMMON_TEXT, "hero_mission_tooltip"), "TOPRIGHT", self, "TOPLEFT", 0, 0)
  end
  guide:SetHandler("OnEnter", OnEnter)
  local period = W_ETC.CreatePeriodWidget("period", tabWindow, "RIGHT")
  period:UseStatusIcon(false)
  period:AddAnchor("TOPRIGHT", guide, "TOPLEFT", -4, 2)
  local HeroInfoLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    local gradeIcon = subItem:CreateDrawable("ui/hero/condition_icon.dds", "level_01", "artwork")
    gradeIcon:SetVisible(true)
    gradeIcon:AddAnchor("TOP", subItem, 0, 12)
    local name = subItem:CreateChildWidget("characternamelabel", "name", 0, true)
    name:SetAutoResize(false)
    name:SetExtent(230, FONT_SIZE.LARGE)
    name.style:SetAlign(ALIGN_CENTER)
    name.style:SetFontSize(FONT_SIZE.LARGE)
    name:AddAnchor("TOP", gradeIcon, "BOTTOM", 0, 6)
    ApplyTextColor(name, FONT_COLOR.MIDDLE_TITLE)
    local expedition = subItem:CreateChildWidget("textbox", "expedition", 0, true)
    expedition:SetAutoResize(true)
    expedition:SetExtent(230, FONT_SIZE.MIDDLE)
    expedition.style:SetAlign(ALIGN_CENTER)
    expedition.style:SetFontSize(FONT_SIZE.MIDDLE)
    expedition:AddAnchor("TOP", name, "BOTTOM", 0, TEXTBOX_LINE_SPACE.MIDDLE)
    ApplyTextColor(expedition, FONT_COLOR.DEFAULT)
    local line = DrawItemUnderLine(subItem, "overlay")
    line:RemoveAllAnchors()
    line:SetVisible(false)
    line:AddAnchor("TOPLEFT", subItem, "BOTTOMLEFT", -30, -2)
    line:AddAnchor("TOPRIGHT", subItem:GetParent(), "BOTTOMRIGHT", 30, -2)
    subItem.gradeIcon = gradeIcon
    subItem.name = name
    subItem.expedition = expedition
    subItem.line = line
  end
  local HeroMissionStringLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
  end
  local HeroInfoDataSetFunc = function(subItem, data, setValue)
    if setValue and data.name ~= nil then
      subItem.gradeIcon:SetTextureInfo(string.format("level_0%d", 5 - data.grade))
      subItem.gradeIcon:SetVisible(true)
      subItem.line:SetVisible(true)
      subItem.name:SetText(data.name)
      if data.expedition then
        subItem.expedition:SetText(data.expedition)
      else
        subItem.expedition:SetText("")
      end
    else
      subItem.gradeIcon:SetVisible(false)
      subItem.line:SetVisible(false)
      subItem.name:SetText("")
      subItem.expedition:SetText("")
    end
  end
  local HeroQuestStatusDataSetFunc = function(subItem, data, setValue)
    if setValue and data.quests ~= nil then
      local str = ""
      for idx = 1, #data.quests do
        if str ~= "" then
          str = str .. "\n"
        end
        str = str .. string.format("%s %s(%d/%d)|r", data.quests[idx].name, FONT_COLOR_HEX.BLUE, data.quests[idx].curValue, data.quests[idx].targetCount)
      end
      subItem:SetText(str)
    else
      subItem:SetText("")
    end
  end
  local HeroActivityDataSetFunc = function(subItem, data, setValue)
    if setValue and data.score ~= nil then
      local condition = GetUIText(COMMON_TEXT, "hero_bonus_leadership_condition", tostring(data.maxScore))
      condition = condition .. string.format([[

%s(%d/%d)|r
]], FONT_COLOR_HEX.BLUE, data.score, data.maxScore)
      condition = condition .. GetUIText(COMMON_TEXT, "hero_bonus_mobilization_order_condition", tostring(data.maxMobilizationOrderCount))
      condition = condition .. string.format([[

%s(%d/%d)|r
]], FONT_COLOR_HEX.BLUE, data.mobilizationOrderCount, data.maxMobilizationOrderCount)
      subItem:SetText(condition)
    else
      subItem:SetText("")
    end
  end
  local listCtrlInfo = {
    width = contentWidth,
    height = 555,
    isHeroRank = true,
    columns = {
      {
        name = GetUIText(COMMON_TEXT, "hero_rank"),
        width = 230,
        itemType = LCCIT_WINDOW,
        dataSetFunc = HeroInfoDataSetFunc,
        layoutSetFunc = HeroInfoLayoutFunc,
        tooltip = nil
      },
      {
        name = GetUIText(COMMON_TEXT, "hero_mission_quest_status"),
        width = 320,
        itemType = LCCIT_TEXTBOX,
        dataSetFunc = HeroQuestStatusDataSetFunc,
        layoutSetFunc = HeroMissionStringLayoutFunc,
        tooltip = nil
      },
      {
        name = GetUIText(COMMON_TEXT, "hero_mission_activity_status"),
        width = 190,
        itemType = LCCIT_TEXTBOX,
        dataSetFunc = HeroActivityDataSetFunc,
        layoutSetFunc = HeroMissionStringLayoutFunc,
        tooltip = nil
      }
    }
  }
  local scrollListCtrl = CreateHeroList(tabWindow, listCtrlInfo, 4)
  scrollListCtrl:AddAnchor("TOPLEFT", factionCombobox, "BOTTOMLEFT", 0, 15)
  tabWindow.scrollListCtrl = scrollListCtrl
  local modalLoadingWindow = CreateLoadingTextureSet(tabWindow)
  modalLoadingWindow:AddAnchor("TOPLEFT", scrollListCtrl, -sideMargin + 1, 0)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", scrollListCtrl, sideMargin + -3, 0)
end
function CreateHeroMissionTab(tabWindow)
  SetViewOfHeroMissionTab(tabWindow)
  local comboBox = tabWindow.factionCombobox
  function comboBox:SelectedProc()
    local selFactionId = self:GetSelFactionId()
    if selFactionId == nil or selFactionId == 0 then
      tabWindow:ScoreUpdated(0)
      return
    end
    tabWindow:WaitPage(true)
    X2Hero:RequestFactionScores(selFactionId)
  end
  function tabWindow:FillPeriod()
    local periodInfo = X2Hero:GetActivedHeroPeriod(HERO_PERIOD_SCHEDULE)
    if periodInfo ~= nil then
      local periodStr = locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter))
      local str = string.format("%s: %s", GetUIText(COMMON_TEXT, "activity_period"), periodStr)
      tabWindow.period:SetPeriod(str, true)
    end
  end
  function tabWindow:ScoreUpdated(factionID)
    tabWindow:WaitPage(false)
    local scrollListCtrl = tabWindow.scrollListCtrl
    scrollListCtrl:DeleteAllDatas()
    local scores = X2Hero:GetFactionScores(factionID)
    if scores == nil then
      return
    end
    table.sort(scores, function(left, right)
      return left.ranking < right.ranking
    end)
    for idx = 1, #scores do
      local info = scores[idx]
      local heroInfo = {
        name = info.name,
        ranking = info.ranking,
        expedition = info.expedition,
        grade = info.grade
      }
      scrollListCtrl:InsertData(idx, 1, heroInfo)
      local questInfo = {
        quests = info.todayQuests
      }
      scrollListCtrl:InsertData(idx, 2, questInfo)
      local activityInfo = {
        score = info.score,
        maxScore = info.maxScore,
        mobilizationOrderCount = info.mobilizationOrderCount,
        maxMobilizationOrderCount = info.maxMobilizationOrderCount
      }
      scrollListCtrl:InsertData(idx, 3, activityInfo)
    end
  end
end
