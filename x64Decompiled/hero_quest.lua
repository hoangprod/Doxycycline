local LEFT_WINDOW_WIDTH = 215
local RIGHT_WINDOW_WIDTH = 539
local WINDOW_HEIGHT = 565
local BONUS_WINDOW_WIDTH = 600
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateHeroBonusDescWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local windowHeight = 367
  local myBonusInfo = X2Hero:GetMyHeroBonusInfo()
  if myBonusInfo == nil then
    return nil
  end
  local window = CreateWindow(id, parent)
  window:SetExtent(BONUS_WINDOW_WIDTH, windowHeight)
  window:SetTitle(GetUIText(COMMON_TEXT, "hero_bonus_desc"))
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("TOPLEFT", window, 539, 8)
  local function OnEnterGuide()
    SetTooltip(GetCommonText("hero_bonus_tooltip"), guide)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local contentWidth = window:GetWidth() - sideMargin * 2
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", window)
  scrollListCtrl:SetExtent(contentWidth, 317)
  scrollListCtrl:AddAnchor("TOP", window, 0, 50)
  window.scrollListCtrl = scrollListCtrl
  local function GradeLayoutSetFunc(widget, rowIndex, colIndex, subItem)
    local bg = CreateContentBackground(subItem, "TYPE11", "brown")
    bg:SetWidth(contentWidth)
    bg:AddAnchor("TOPLEFT", subItem, 0, 0)
    bg:AddAnchor("BOTTOM", subItem, 0, 0)
    subItem.bg = bg
    local itemIcon = CreateSlotItemButton(subItem:GetId() .. ".itemIcon", subItem)
    itemIcon:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    itemIcon:RemoveAllAnchors()
    subItem.itemIcon = itemIcon
    local icon = subItem:CreateDrawable(TEXTURE_PATH.RANKING_GRADE, "normal", "overlay")
    icon:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 1)
    subItem.icon = icon
    itemIcon:AddAnchor("CENTER", subItem, 0, -(itemIcon:GetHeight() + icon:GetHeight()) / 2)
  end
  local GradeDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.bg:SetVisible(false)
      subItem.icon:SetVisible(false)
      if data == nil then
        return
      end
      SetRankingGradeDataFunc(subItem.bg, subItem.icon, data.grade)
      subItem.itemIcon:Show(false)
      if data.itemInfo ~= nil then
        subItem.itemIcon:Show(true)
        subItem.itemIcon:SetItem(data.itemInfo.type, data.itemInfo.grade, data.itemInfo.count)
      end
    else
      subItem.bg:SetVisible(false)
      subItem.icon:SetVisible(false)
      subItem.itemIcon:Show(false)
    end
  end
  local ConditionLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem:SetAutoResize(true)
    subItem:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    subItem:SetInset(5, 0, 5, 0)
    subItem.style:SetFontSize(FONT_SIZE.SMALL)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local ConditionDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local condition = GetUIText(COMMON_TEXT, "hero_bonus_leadership_condition", tostring(data.leadershipPoint))
      condition = condition .. "\n" .. GetUIText(COMMON_TEXT, "hero_bonus_mobilization_order_condition", tostring(data.mobilizationOrderCount))
      subItem:SetText(condition)
    else
      subItem:SetText("")
    end
  end
  local QuestConditionLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem:SetAutoResize(true)
    subItem:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    subItem:SetInset(5, 14, 5, 14)
    subItem.style:SetFontSize(FONT_SIZE.SMALL)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local QuestConditionDataSetFunc = function(subItem, data, setValue)
    if setValue and data.todayQuests then
      local condition = ""
      for i = 1, #data.todayQuests do
        if condition ~= "" then
          condition = condition .. "\n"
        end
        condition = condition .. string.format("%s %s(%d/%d)|r", data.todayQuests[i].name, FONT_COLOR_HEX.BLUE, data.todayQuests[i].curValue, data.todayQuests[i].targetCount)
      end
      subItem:SetText(condition)
    else
      subItem:SetText("")
    end
  end
  scrollListCtrl:InsertColumn(GetUIText(COMMON_TEXT, "hero_bonus_reward"), 94, LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  scrollListCtrl:InsertColumn(GetUIText(COMMON_TEXT, "hero_bonus_quest_conditon"), 242, LCCIT_TEXTBOX, QuestConditionDataSetFunc, nil, nil, QuestConditionLayoutSetFunc)
  scrollListCtrl:InsertColumn(GetUIText(COMMON_TEXT, "hero_bonus_conditon"), 202, LCCIT_TEXTBOX, ConditionDataSetFunc, nil, nil, ConditionLayoutSetFunc)
  scrollListCtrl:InsertRows(3, false)
  DrawListCtrlUnderLine(scrollListCtrl, nil, false)
  for i = 1, #scrollListCtrl.listCtrl.column do
    SettingListColumn(scrollListCtrl.listCtrl, scrollListCtrl.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(scrollListCtrl.listCtrl.column[i], #scrollListCtrl.listCtrl.column, i, f)
    scrollListCtrl.listCtrl.column[i]:Enable(false)
    SetButtonFontColor(scrollListCtrl.listCtrl.column[i], GetButtonDefaultFontColor_V2())
  end
  ListCtrlItemGuideLine(scrollListCtrl.listCtrl.items, scrollListCtrl:GetRowCount() + 1)
  for i = 1, #scrollListCtrl.listCtrl.items do
    local item = scrollListCtrl.listCtrl.items[i]
    item.line:SetVisible(true)
  end
  local heroBonus = X2Hero:GetHeroBonus()
  for i = 1, #heroBonus do
    local bonusGradeInfo = {
      grade = i,
      itemInfo = heroBonus[i].item
    }
    scrollListCtrl:InsertData(i, 1, bonusGradeInfo)
    local questConditionInfo = {
      todayQuests = heroBonus[i].todayQuests
    }
    scrollListCtrl:InsertData(i, 2, questConditionInfo)
    local conditionInfo = {
      leadershipPoint = heroBonus[i].leadershipPoint,
      mobilizationOrderCount = heroBonus[i].mobilizationOrderCount
    }
    scrollListCtrl:InsertData(i, 3, conditionInfo)
  end
  local myBonusInfoTitle = window:CreateChildWidget("textbox", "myBonusInfoTitle", 0, true)
  myBonusInfoTitle:SetExtent(220, 40)
  myBonusInfoTitle.style:SetAlign(ALIGN_CENTER)
  myBonusInfoTitle:SetAutoResize(true)
  myBonusInfoTitle:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  myBonusInfoTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(myBonusInfoTitle, FONT_COLOR.DEFAULT)
  myBonusInfoTitle:SetText(string.format([[
%s
%s]], GetUIText(COMMON_TEXT, "hero_bonus_cur_leadership_point"), GetUIText(COMMON_TEXT, "hero_bonus_cur_mobilization_order_count")))
  local myBonusInfoBox = window:CreateChildWidget("textbox", "myBonusInfoBox", 0, true)
  myBonusInfoBox:SetExtent(320, 40)
  myBonusInfoBox.style:SetAlign(ALIGN_LEFT)
  myBonusInfoBox:SetAutoResize(true)
  myBonusInfoBox:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  myBonusInfoBox.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(myBonusInfoBox, FONT_COLOR.BLUE)
  myBonusInfoBox:SetText(string.format([[
|sd%s;
%s]], myBonusInfo.leadershipPoint, myBonusInfo.mobilizationOrderCount))
  local myBonusLeftBg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "artwork")
  myBonusLeftBg:SetTextureColor("money")
  myBonusLeftBg:AddAnchor("TOPLEFT", scrollListCtrl, "BOTTOMLEFT", 0, 9)
  myBonusLeftBg:SetExtent(220, 30 + myBonusInfoTitle:GetHeight())
  myBonusInfoTitle:AddAnchor("TOP", myBonusLeftBg, 0, 15)
  local myBonusRightBg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "artwork")
  myBonusRightBg:SetTextureColor("alpha20")
  myBonusRightBg:AddAnchor("TOPRIGHT", scrollListCtrl, "BOTTOMRIGHT", 0, 9)
  myBonusRightBg:SetExtent(560, 30 + myBonusInfoTitle:GetHeight())
  myBonusInfoBox:AddAnchor("TOPLEFT", myBonusRightBg, 230, 15)
  local heroBonusExplain = window:CreateChildWidget("textbox", "heroBonusExplain", 0, true)
  heroBonusExplain:SetExtent(560, 40)
  heroBonusExplain.style:SetAlign(ALIGN_CENTER)
  heroBonusExplain:SetAutoResize(true)
  heroBonusExplain:AddAnchor("TOPLEFT", myBonusLeftBg, "BOTTOMLEFT", 0, 15)
  ApplyTextColor(heroBonusExplain, FONT_COLOR.BLUE)
  heroBonusExplain:SetText(GetCommonText("hero_bonus_explain"))
  local OnEnter = function(self)
    SetTooltip(string.format("%s", GetUIText(COMMON_TEXT, "hero_bonus_cur_leadership_point_tip")), self, false)
  end
  myBonusInfoBox:SetHandler("OnEnter", OnEnter)
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("TOP", heroBonusExplain, "BOTTOM", 0, 15)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  windowHeight = windowHeight + 9 + myBonusRightBg:GetHeight() + 15 + heroBonusExplain:GetHeight() + 15 + okButton:GetHeight() + 20
  window:SetHeight(windowHeight)
  return window
end
local TracingBtnEntered = function(checkBtn)
  SetTooltip(GetCommonText("trace_today_quest_tooltip"), checkBtn)
end
local TracingBtnChecked = function(checkBtn, index)
  local checked = checkBtn:GetChecked()
  local info = X2Achievement:GetTodayAssignmentInfo(TADT_HERO, index)
  if info.questType ~= nil and info.questType ~= 0 then
    if checked then
      AddQuestToNotifier(info.questType)
    else
      RemoveQuestFromNotifier(info.questType)
    end
  end
end
local function TodayAssignmentDataSetFunc(subItem, index, setValue)
  local function CheckFunc(checkBtn)
    TracingBtnChecked(checkBtn, index)
  end
  function subItem:handleClick()
    return subItem.checkBtn:IsMouseOver()
  end
  if setValue then
    subItem:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_LIST, TADT_HERO, index, CheckFunc, TracingBtnEntered)
  else
    subItem:SetTodayAssignment()
  end
end
local function CreateTodayAssignmentListWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local MAX_ASSIGNMENT_LIST = 20
  local subjectList = CreateASubjectListWnd("subjectList", wnd)
  subjectList:SetExtent(RIGHT_WINDOW_WIDTH, WINDOW_HEIGHT)
  subjectList:AddAnchor("TOP", wnd, 0, 0)
  subjectList:SetListStyle(8, MAX_ASSIGNMENT_LIST, TodayAssignmentDataSetFunc)
  subjectList:SetWndStyle(false, GetCommonText("no_achievement"))
  function wnd:SetListSelectFuc(func)
    subjectList:SetListSelectFuc(func)
  end
  function wnd:Init()
    local cnt = X2Achievement:GetTodayAssignmentCount(TADT_HERO)
    local info = {}
    for index = 1, cnt do
      info[index] = index
    end
    subjectList:SetInfo(info)
    wnd.info = info
  end
  function wnd:Update()
    wnd:Init()
    subjectList:Update()
  end
  return wnd
end
local function CreateDescWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local prevPageBtn = wnd:CreateChildWidget("button", "prevPageBtn", 0, true)
  prevPageBtn:AddAnchor("TOPLEFT", wnd, 0, 0)
  prevPageBtn:SetText(GetCommonText("prev_page"))
  ApplyButtonSkin(prevPageBtn, BUTTON_CONTENTS.PREV_PAGE)
  local subjectWnd = wnd:CreateChildWidget("emptywidget", "subjectWnd", 0, true)
  CreateASubjectWnd(subjectWnd)
  subjectWnd:AddAnchor("TOPLEFT", prevPageBtn, "BOTTOMLEFT", 0, 5)
  subjectWnd:AddAnchor("BOTTOMRIGHT", wnd, "TOPRIGHT", 0, 105)
  local categoryLabel = wnd:CreateChildWidget("label", "categoryLabel", 0, true)
  categoryLabel:SetHeight(FONT_SIZE.MIDDLE)
  categoryLabel:SetAutoResize(true)
  categoryLabel.style:SetAlign(ALIGN_RIGHT)
  categoryLabel:AddAnchor("BOTTOMRIGHT", subjectWnd, "TOPRIGHT", -5, -10)
  ApplyTextColor(categoryLabel, FONT_COLOR.DEFAULT)
  local descWnd = CreateAAchievementDescWnd("descWnd", wnd)
  descWnd:AddAnchor("TOPLEFT", subjectWnd, "BOTTOMLEFT", 0, 5)
  descWnd:AddAnchor("BOTTOMRIGHT", wnd, "BOTTOMRIGHT", 0, -40)
  local prevBtn = wnd:CreateChildWidget("button", "prevBtn", 0, true)
  prevBtn:AddAnchor("RIGHT", wnd, "BOTTOM", -5, -20)
  ApplyButtonSkin(prevBtn, BUTTON_BASIC.PAGE_PREV)
  local nextBtn = wnd:CreateChildWidget("button", "nextBtn", 0, true)
  nextBtn:AddAnchor("LEFT", wnd, "BOTTOM", 5, -20)
  ApplyButtonSkin(nextBtn, BUTTON_BASIC.PAGE_NEXT)
  function wnd:SetInfo(index, aList, prevPage)
    local info = X2Achievement:GetTodayAssignmentInfo(TADT_HERO, index)
    if info == nil then
      return
    elseif info.status == A_TODAY_STATUS.LOCKED then
      if wnd.lastQuest ~= nil then
        prevPageBtn:OnClick()
        return
      end
      if info.satisfy then
        CallUnlockTodayQuestDialog(GetUIText(COMMON_TEXT, "hero_quest"), TADT_HERO, info)
      end
      return
    elseif info.status == A_TODAY_STATUS.READY then
      if wnd.lastQuest ~= nil then
        prevPageBtn:OnClick()
        return
      end
      X2Achievement:HandleClickTodayAssignment(TADT_HERO, info.realStep)
      return
    end
    wnd.viewInfo = {
      index = index,
      aList = aList,
      prevPage = prevPage
    }
    categoryLabel:SetText(info.title)
    local function CheckFunc(checkBtn)
      TracingBtnChecked(checkBtn, index)
    end
    subjectWnd:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_DESC, TADT_HERO, index, CheckFunc, TracingBtnEntered)
    descWnd:SetTodayAssignmentInfo(info.questType)
    wnd.lastQuest = info.questType
    local function RefreshMoveBtn()
      local cIndex = 1
      while aList[cIndex] ~= index do
        cIndex = cIndex + 1
      end
      prevBtn:Enable(false)
      for i = cIndex - 1, 1, -1 do
        local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_HERO, aList[i])
        if sInfo ~= nil and sInfo.status >= A_TODAY_STATUS.PROGRESS then
          prevBtn.index = aList[i]
          prevBtn:Enable(true)
          break
        end
      end
      nextBtn:Enable(false)
      for i = cIndex + 1, #aList do
        local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_HERO, aList[i])
        if sInfo ~= nil and sInfo.status >= A_TODAY_STATUS.PROGRESS then
          nextBtn.index = aList[i]
          nextBtn:Enable(true)
          break
        end
      end
    end
    RefreshMoveBtn()
    if prevPage ~= wnd then
      prevPage:Show(false)
      wnd:Show(true)
    end
  end
  function prevPageBtn:OnClick()
    wnd.lastQuest = nil
    wnd.viewInfo.prevPage:Update()
    wnd.viewInfo.prevPage:Show(true)
    wnd:Show(false)
    wnd.viewInfo = nil
  end
  prevPageBtn:SetHandler("OnClick", prevPageBtn.OnClick)
  function prevBtn:OnClick()
    wnd:SetInfo(prevBtn.index, wnd.viewInfo.aList, wnd.viewInfo.prevPage)
  end
  prevBtn:SetHandler("OnClick", prevBtn.OnClick)
  function nextBtn:OnClick()
    wnd:SetInfo(nextBtn.index, wnd.viewInfo.aList, wnd.viewInfo.prevPage)
  end
  nextBtn:SetHandler("OnClick", nextBtn.OnClick)
  function wnd:Update()
    if wnd.viewInfo ~= nil then
      wnd:SetInfo(wnd.viewInfo.index, wnd.viewInfo.aList, wnd.viewInfo.prevPage)
    end
  end
  function wnd:OnHide()
    wnd.viewInfo = nil
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  return wnd
end
function CreateHeroQuestTab(parent)
  local heroBonusDesc = parent:CreateChildWidget("button", "heroBonusDesc", 0, true)
  heroBonusDesc:AddAnchor("TOPRIGHT", parent, 0, 9)
  heroBonusDesc:SetText(GetUIText(COMMON_TEXT, "hero_bonus_desc"))
  ApplyButtonSkin(heroBonusDesc, BUTTON_BASIC.DEFAULT)
  heroBonusDesc:SetExtent(96, 34)
  local heroBonusDescWnd
  if not X2Player:GetFeatureSet().heroBonus then
    heroBonusDesc:Show(false)
  end
  local function HeroBonusDescFunc()
    if heroBonusDescWnd == nil then
      heroBonusDescWnd = CreateHeroBonusDescWindow("heroBonusDescWnd", "UIParent")
      if heroBonusDescWnd == nil then
        return
      end
      heroBonusDescWnd:Show(true)
      heroBonusDescWnd:EnableHidingIsRemove(true)
      heroBonusDescWnd:AddAnchor("CENTER", "UIParent", 0, 0)
      parent.heroBonusDescWnd = heroBonusDescWnd
      local function OnHide()
        heroBonusDescWnd = nil
        parent.heroBonusDescWnd = nil
      end
      heroBonusDescWnd:SetHandler("OnHide", OnHide)
    else
      heroBonusDescWnd:Show(not heroBonusDescWnd:IsVisible())
    end
  end
  ButtonOnClickHandler(heroBonusDesc, HeroBonusDescFunc)
  local period = W_ETC.CreatePeriodWidget("period", parent, "RIGHT")
  period:UseStatusIcon(false)
  period:AddAnchor("TOPRIGHT", heroBonusDesc, "BOTTOMRIGHT", 7, 9)
  parent.period = period
  local assignDesc = CreateTodayAssignDescWnd("assignDesc", parent, W_TODAY_ASSIGN_DESC.TYPE.HERO)
  assignDesc:AddAnchor("TOPLEFT", parent, 0, 78)
  local listWnd = CreateTodayAssignmentListWnd("listWnd", parent)
  listWnd:AddAnchor("TOPLEFT", assignDesc, "TOPRIGHT", sideMargin, 0)
  listWnd:AddAnchor("BOTTOMRIGHT", parent, 0, -sideMargin / 2)
  listWnd:Init()
  local descWnd = CreateDescWnd("descWnd", parent)
  descWnd:AddAnchor("TOPLEFT", assignDesc, "TOPRIGHT", sideMargin, 0)
  descWnd:AddAnchor("BOTTOMRIGHT", parent, 0, -sideMargin / 2)
  descWnd:Show(false)
  local function ToggleDetailWnd(index, aList)
    descWnd:SetInfo(index, aList, listWnd)
  end
  listWnd:SetListSelectFuc(ToggleDetailWnd)
  function parent:ToggleWithQuest(qType)
    local cnt = X2Achievement:GetTodayAssignmentCount(TADT_HERO)
    local info = {}
    for index = 1, cnt do
      info[index] = index
    end
    for index = 1, #info do
      local tInfo = X2Achievement:GetTodayAssignmentInfo(TADT_HERO, info[index])
      if tInfo ~= nil and tInfo.questType == qType then
        ToggleDetailWnd(index, info)
      end
    end
  end
  function parent:Update(force)
    if force == true or parent:IsVisible() == true then
      listWnd:Update()
      descWnd:Update()
      local periodInfo = X2Hero:GetActivedHeroPeriod(HERO_PERIOD_SCHEDULE)
      if periodInfo ~= nil then
        local periodStr = locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter))
        local str = string.format("%s: %s", GetUIText(COMMON_TEXT, "activity_period"), periodStr)
        parent.period:SetPeriod(str, true)
      end
    end
  end
  function parent:RefreshTab()
    parent:Update(true)
  end
  local todayAssignmentEvents = {
    UPDATE_TODAY_ASSIGNMENT = function()
      parent:Update(false)
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      parent:Update(false)
    end,
    QUEST_CONTEXT_UPDATED = function(qType, status)
      if X2Achievement:IsTodayAssignmentQuest(TADT_HERO, qType) == true and status == "updated" then
        parent:Update(false)
      end
    end,
    ADDED_ITEM = function()
      parent:Update(false)
    end,
    REMOVED_ITEM = function()
      parent:Update(false)
    end
  }
  parent:SetHandler("OnEvent", function(this, event, ...)
    todayAssignmentEvents[event](...)
  end)
  RegistUIEvent(parent, todayAssignmentEvents)
end
