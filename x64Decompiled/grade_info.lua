function CreateActabilityGradeInfoWnd(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(skillLocale.actabilityGradeInfoWnd.width, 545)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetUIText(COMMON_TEXT, "grade_info"))
  window:EnableHidingIsRemove(true)
  local contentWidth = window:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", window)
  listCtrl:RemoveAllAnchors()
  listCtrl:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  listCtrl:SetExtent(contentWidth, 410)
  local color = ACTABILITY_EXPERT.COMMON_COLOR
  local function GetCountStringByGrade(grade)
    local gradeInfo = X2Ability:GetGradeInfo(grade)
    local curGradeCount = X2Ability:GetActabilityCountByGrade(grade, 0)
    if gradeInfo.intensifiedExpertCount == nil then
      return string.format("%d %s(%d)|r", curGradeCount, color, X2Ability:GetRemainCountToNextGrade(grade - 1, 0, false))
    else
      return string.format("%d", curGradeCount)
    end
  end
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local gradeIcon = CreateActabilityGradeIconWidget("gradeIcon", subItem)
    gradeIcon:AddAnchor("LEFT", subItem, MARGIN.WINDOW_SIDE / 1.5, 0)
    subItem.gradeIcon = gradeIcon
    local count = subItem:CreateChildWidget("textbox", "count", 0, true)
    count:SetExtent(45, FONT_SIZE.MIDDLE)
    count:AddAnchor("RIGHT", subItem, skillLocale.actabilityGradeInfoWnd.countOffset, 0)
    count.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(count, FONT_COLOR.DEFAULT)
  end
  local function DataSetFunc(subItem, data, setValue)
    if setValue then
      subItem.gradeIcon:SetGradeInfo(data.grade, data.name, data.colorString)
      subItem.count:SetText(GetCountStringByGrade(data.grade))
    else
      subItem.gradeIcon:SetGradeInfo()
      subItem.count:SetText("")
    end
  end
  local columnWidth = skillLocale.actabilityGradeInfoWnd.columnWidth
  window:InsertColumn(GetUIText(COMMON_TEXT, "grade_per_count"), columnWidth[1], LCCIT_WINDOW, LayoutFunc, DataSetFunc)
  window:InsertColumn(GetUIText(COMMON_TEXT, "livelihood_exp_increase"), columnWidth[2], LCCIT_STRING)
  window:InsertColumn(GetUIText(COMMON_TEXT, "use_labor_power_decrease"), columnWidth[3], LCCIT_STRING)
  window:InsertColumn(GetUIText(COMMON_TEXT, "casting_time_decrease"), columnWidth[4], LCCIT_STRING)
  window:InsertRows(11, false)
  DrawListCtrlUnderLine(listCtrl, nil, false)
  for i = 1, #listCtrl.column do
    SettingListColumn(listCtrl, listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(listCtrl.column[i], #listCtrl.column, i)
    listCtrl.column[i].style:SetFontSize(skillLocale.actabilityGradeInfoWnd.columnFontSize)
  end
  ListCtrlItemGuideLine(listCtrl.items, window:GetRowCount() + 1)
  for i = 1, #listCtrl.items do
    local item = listCtrl.items[i]
    item.line:SetVisible(true)
  end
  local bg = CreateContentBackground(listCtrl, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", listCtrl.column[1], "BOTTOMLEFT", 0, -5)
  bg:AddAnchor("BOTTOMRIGHT", listCtrl, 0, 5)
  for i = ACTABILITY_EXPERT.GRADE.PROBATION, X2Ability:GetMaxGrade() do
    local gradeInfo = X2Ability:GetGradeInfo(i)
    local firstInfo = {
      grade = gradeInfo.grade,
      name = gradeInfo.name,
      colorString = gradeInfo.colorString,
      intensified = gradeInfo.intensifiedExpertCount ~= nil
    }
    window:InsertData(i, 1, firstInfo)
    window:InsertData(i, 2, string.format("%d%%", gradeInfo.expMul))
    window:InsertData(i, 3, string.format("%d%%", gradeInfo.advantage))
    window:InsertData(i, 4, string.format("%d%%", gradeInfo.castAdvantage))
  end
  local offset = MARGIN.WINDOW_SIDE / 2
  local desc = window:CreateChildWidget("textbox", "desc", 0, false)
  ApplyTextColor(desc, FONT_COLOR.DEFAULT)
  desc:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
  desc:AddAnchor("TOPLEFT", listCtrl, "BOTTOMLEFT", offset, offset)
  desc:SetText(GetUIText(COMMON_TEXT, "actability_guide_desc", color))
  desc:SetWidth(desc:GetLongestLineWidth() + 10)
  desc.style:SetAlign(ALIGN_LEFT)
  local intensifiedCount = CreateActabilityExpertCountLabel("defaultCount", window, "intensified")
  intensifiedCount:AddAnchor("TOPLEFT", desc, "BOTTOMLEFT", 0, 7)
  intensifiedCount:Update()
  local tip = window:CreateChildWidget("label", "tip", 0, false)
  tip:SetExtent(contentWidth, FONT_SIZE.LARGE)
  tip.style:SetFontSize(FONT_SIZE.LARGE)
  tip:AddAnchor("TOPLEFT", intensifiedCount, "BOTTOMLEFT", 0, 7)
  tip:SetText(GetUIText(ABILITY_CATEGORY_DESCRIPTION_TEXT, "actability_expert_grade_effect_rule"))
  tip.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(tip, FONT_COLOR.BLUE)
  local defaultCount = CreateActabilityExpertCountLabel("defaultCount", window)
  defaultCount:SetHeight(FONT_SIZE.LARGE)
  defaultCount.style:SetFontSize(FONT_SIZE.LARGE)
  defaultCount:AddAnchor("TOPRIGHT", listCtrl, "BOTTOMRIGHT", -offset, offset)
  defaultCount:SetAutoResize(true)
  defaultCount:Update()
  function window:Update()
    defaultCount:Update()
    intensifiedCount:Update()
    for i = ACTABILITY_EXPERT.GRADE.PROBATION, X2Ability:GetMaxGrade() do
      local curGradeCount = X2Ability:GetActabilityCountByGrade(i, 0)
      local subItem = self.listCtrl.items[i].subItems[1]
      subItem.count:SetText(GetCountStringByGrade(i))
    end
  end
  local events = {
    ACTABILITY_EXPERT_GRADE_CHANGED = function()
      window:Update()
    end,
    ACTABILITY_REFRESH_ALL = function()
      window:Update()
    end,
    ACTABILITY_EXPERT_EXPANDED = function()
      window:Update()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
