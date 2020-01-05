local RIGHT_WINDOW_WIDTH = 539
local RIGHT_WINDOW_HEIGHT = 503
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local TracingBtnEntered = function(checkBtn)
  SetTooltip(GetCommonText("trace_today_quest_tooltip"), checkBtn)
end
local TracingBtnChecked = function(checkBtn, index)
  local checked = checkBtn:GetChecked()
  local info = X2Achievement:GetTodayAssignmentInfo(TADT_EXPEDITION, index)
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
    subItem:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_LIST, TADT_EXPEDITION, index, CheckFunc, TracingBtnEntered)
  else
    subItem:SetTodayAssignment()
  end
end
local function CreateTodayAssignmentListWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local MAX_ASSIGNMENT_LIST = 20
  local subjectList = CreateASubjectListWnd("subjectList", wnd)
  subjectList:SetExtent(RIGHT_WINDOW_WIDTH, RIGHT_WINDOW_HEIGHT)
  subjectList:AddAnchor("TOP", wnd, 0, 35)
  subjectList:SetListStyle(7, MAX_ASSIGNMENT_LIST, TodayAssignmentDataSetFunc)
  subjectList:SetWndStyle(false, GetCommonText("no_achievement"))
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.LARGE)
  title:SetAutoResize(true)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title:AddAnchor("BOTTOMLEFT", subjectList, "TOPLEFT", 4, -(sideMargin * 3 / 4))
  title:SetText(GetCommonText("expedition_today_quest_desc"))
  ApplyTextColor(title, FONT_COLOR.BROWN)
  function wnd:SetListSelectFuc(func)
    subjectList:SetListSelectFuc(func)
  end
  function wnd:Init()
    local cnt = X2Achievement:GetTodayAssignmentCount(TADT_EXPEDITION)
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
    local info = X2Achievement:GetTodayAssignmentInfo(TADT_EXPEDITION, index)
    if info == nil then
      return
    elseif info.status == A_TODAY_STATUS.LOCKED then
      if wnd.lastQuest ~= nil then
        prevPageBtn:OnClick()
        return
      end
      if info.satisfy then
        CallUnlockTodayQuestDialog(GetUIText(COMMON_TEXT, "expedition_today_quest"), TADT_EXPEDITION, info)
      end
      return
    elseif info.status == A_TODAY_STATUS.READY then
      if wnd.lastQuest ~= nil then
        prevPageBtn:OnClick()
        return
      end
      X2Achievement:HandleClickTodayAssignment(TADT_EXPEDITION, info.realStep)
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
    subjectWnd:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_DESC, TADT_EXPEDITION, index, CheckFunc, TracingBtnEntered)
    descWnd:SetTodayAssignmentInfo(info.questType)
    wnd.lastQuest = info.questType
    local function RefreshMoveBtn()
      local cIndex = 1
      while aList[cIndex] ~= index do
        cIndex = cIndex + 1
      end
      prevBtn:Enable(false)
      for i = cIndex - 1, 1, -1 do
        local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_EXPEDITION, aList[i])
        if sInfo ~= nil and sInfo.status >= A_TODAY_STATUS.PROGRESS then
          prevBtn.index = aList[i]
          prevBtn:Enable(true)
          break
        end
      end
      nextBtn:Enable(false)
      for i = cIndex + 1, #aList do
        local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_EXPEDITION, aList[i])
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
function CreateExpeditionTodayQuest(id, parent)
  local assignDesc = CreateTodayAssignDescWnd("assignDesc", parent, W_TODAY_ASSIGN_DESC.TYPE.EXPEDITION)
  assignDesc:AddAnchor("TOPLEFT", parent, 0, sideMargin)
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
    local cnt = X2Achievement:GetTodayAssignmentCount(TADT_EXPEDITION)
    local info = {}
    for index = 1, cnt do
      info[index] = index
    end
    for index = 1, #info do
      local tInfo = X2Achievement:GetTodayAssignmentInfo(TADT_EXPEDITION, info[index])
      if tInfo ~= nil and tInfo.questType == qType then
        ToggleDetailWnd(index, info)
      end
    end
  end
  function parent:Update(force)
    if force == true or parent:IsVisible() == true then
      listWnd:Update()
      descWnd:Update()
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
      if X2Achievement:IsTodayAssignmentQuest(TADT_EXPEDITION, qType) == true and status == "updated" then
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
