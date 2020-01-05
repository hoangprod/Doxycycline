local TracingBtnEntered = function(checkBtn)
  SetTooltip(GetCommonText("trace_today_quest_tooltip"), checkBtn)
end
local TracingBtnChecked = function(checkBtn, index)
  local checked = checkBtn:GetChecked()
  local info = X2Achievement:GetTodayAssignmentInfo(TADT_TODAY, index)
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
    subItem:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_LIST, TADT_TODAY, index, CheckFunc, TracingBtnEntered)
  else
    subItem:SetTodayAssignment()
  end
end
local function CreateTodayAssignmentListWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local MAX_ASSIGNMENT_LIST = 50
  local subjectList = CreateASubjectListWnd("subjectList", wnd)
  subjectList:SetExtent(554, 420)
  subjectList:AddAnchor("BOTTOM", wnd, 0, -8)
  subjectList:SetListStyle(6, MAX_ASSIGNMENT_LIST, TodayAssignmentDataSetFunc)
  subjectList:SetWndStyle(false, GetCommonText("no_achievement"))
  local bookImg = wnd:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_TODAY, "book", "background")
  bookImg:AddAnchor("TOPLEFT", wnd, 0, 20)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.LARGE)
  title:SetAutoResize(true)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title:AddAnchor("LEFT", bookImg, bookImg:GetWidth(), 0)
  ApplyTextColor(title, FONT_COLOR.BROWN)
  local changeObjectButton = wnd:CreateChildWidget("button", "changeObjectButton", 0, true)
  changeObjectButton:SetText(GetCommonText("today_assignment_reset_title"))
  ApplyButtonSkin(changeObjectButton, BUTTON_BASIC.DEFAULT)
  changeObjectButton:AddAnchor("TOPRIGHT", wnd, -26, -8)
  function changeObjectButton:OnClick(arg)
    if arg == "LeftButton" then
      if parent.changeObjectWnd:IsVisible() == false then
        parent.changeObjectWnd:Show(true)
      else
        parent.changeObjectWnd:Show(false)
      end
    end
  end
  changeObjectButton:SetHandler("OnClick", changeObjectButton.OnClick)
  local labelChangeCount = wnd:CreateChildWidget("label", "labelChangeCount", 0, true)
  labelChangeCount:SetHeight(FONT_SIZE.MIDDLE)
  labelChangeCount:SetAutoResize(true)
  labelChangeCount.style:SetAlign(ALIGN_RIGHT)
  labelChangeCount.style:SetFontSize(FONT_SIZE.MIDDLE)
  labelChangeCount:AddAnchor("TOPRIGHT", wnd, -29, changeObjectButton:GetHeight() - 3)
  labelChangeCount:SetText("")
  ApplyTextColor(labelChangeCount, FONT_COLOR.BROWN)
  local guide = W_ICON.CreateGuideIconWidget(wnd)
  guide:AddAnchor("LEFT", labelChangeCount, -guide:GetWidth() - 6, 0)
  local function OnEnterGuide()
    SetTooltip(GetUIText(TOOLTIP_TEXT, "today_assignment_reset_guide"), guide)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local OnLeaveGuide = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeaveGuide)
  local function OnEnterChangeButton()
    if changeObjectButton:IsEnabled() == false then
      SetTooltip(GetUIText(TOOLTIP_TEXT, "today_assignment_reset_limit"), changeObjectButton)
    end
  end
  changeObjectButton:SetHandler("OnEnter", OnEnterChangeButton)
  local OnLeaveChangeButton = function()
    HideTooltip()
  end
  changeObjectButton:SetHandler("OnLeave", OnLeaveChangeButton)
  function wnd:SetListSelectFuc(func)
    subjectList:SetListSelectFuc(func)
  end
  local function UpdateTitle()
    local done, total = X2Achievement:GetTodayAssignmentStatus()
    title:SetText(GetCommonText("complete_today_quest", tostring(done), tostring(total)))
  end
  function wnd:Init()
    local cnt = X2Achievement:GetTodayAssignmentCount(TADT_TODAY)
    local info = {}
    for index = 1, cnt do
      info[index] = index
    end
    subjectList:SetInfo(info)
    wnd.info = info
    UpdateTitle()
    local resetCount, maxCount = X2Achievement:GetTodayAssignmentResetCount(TADT_TODAY)
    if resetCount ~= nil and maxCount ~= nil then
      labelChangeCount:SetText(GetCommonText("today_assignment_reset_count", tostring(resetCount), tostring(maxCount)))
      changeObjectButton:Enable(resetCount < maxCount)
    end
  end
  function wnd:Update()
    UpdateTitle()
    subjectList:Update()
    local resetCount, maxCount = X2Achievement:GetTodayAssignmentResetCount(TADT_TODAY)
    if resetCount ~= nil and maxCount ~= nil then
      labelChangeCount:SetText(GetCommonText("today_assignment_reset_count", tostring(resetCount), tostring(maxCount)))
      changeObjectButton:Enable(resetCount < maxCount)
      if parent.changeObjectWnd ~= nil then
        parent.changeObjectWnd.applyBtn:Enable(resetCount < maxCount)
      end
    end
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
  descWnd:AddAnchor("BOTTOMRIGHT", wnd, "BOTTOMRIGHT", 0, -20)
  local prevBtn = wnd:CreateChildWidget("button", "prevBtn", 0, true)
  prevBtn:AddAnchor("RIGHT", wnd, "BOTTOM", -5, 0)
  ApplyButtonSkin(prevBtn, BUTTON_BASIC.PAGE_PREV)
  local nextBtn = wnd:CreateChildWidget("button", "nextBtn", 0, true)
  nextBtn:AddAnchor("LEFT", wnd, "BOTTOM", 5, 0)
  ApplyButtonSkin(nextBtn, BUTTON_BASIC.PAGE_NEXT)
  function wnd:SetInfo(index, aList, prevPage)
    local info = X2Achievement:GetTodayAssignmentInfo(TADT_TODAY, index)
    if info == nil then
      return
    elseif info.status == A_TODAY_STATUS.LOCKED then
      if wnd.lastQuest ~= nil then
        prevPageBtn:OnClick()
        return
      end
      if info.satisfy then
        CallUnlockTodayQuestDialog(GetUIText(COMMON_TEXT, "today_assignment"), TADT_TODAY, info)
      end
      return
    elseif info.status == A_TODAY_STATUS.READY then
      if wnd.lastQuest ~= nil then
        prevPageBtn:OnClick()
        return
      end
      X2Achievement:HandleClickTodayAssignment(TADT_TODAY, info.realStep)
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
    subjectWnd:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_DESC, TADT_TODAY, index, CheckFunc, TracingBtnEntered)
    descWnd:SetTodayAssignmentInfo(info.questType)
    wnd.lastQuest = info.questType
    local function RefreshMoveBtn()
      local cIndex = 1
      while aList[cIndex] ~= index do
        cIndex = cIndex + 1
      end
      prevBtn:Enable(false)
      for i = cIndex - 1, 1, -1 do
        local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_TODAY, aList[i])
        if sInfo ~= nil and sInfo.status >= A_TODAY_STATUS.PROGRESS then
          prevBtn.index = aList[i]
          prevBtn:Enable(true)
          break
        end
      end
      nextBtn:Enable(false)
      for i = cIndex + 1, #aList do
        local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_TODAY, aList[i])
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
local CreateChangeObjectWnd = function(id, parent)
  local changeObjectWnd = CreateWindow(id, "UIParent")
  changeObjectWnd:SetWindowModal(true)
  changeObjectWnd:SetExtent(510, 530)
  changeObjectWnd:AddAnchor("CENTER", "UIParent", 0, 0)
  changeObjectWnd:SetTitle(GetCommonText("today_assignment_reset_title"))
  changeObjectWnd:Show(false)
  changeObjectWnd.selectRealStep = 0
  local label = changeObjectWnd:CreateChildWidget("textbox", "label", 0, true)
  label:AddAnchor("TOP", changeObjectWnd.titleBar, "BOTTOM", 0, 5)
  label:SetExtent(470, FONT_SIZE.LARGE)
  label.style:SetFontSize(FONT_SIZE.LARGE)
  label:SetText(GetCommonText("today_assignment_reset_label"))
  ApplyTextColor(label, FONT_COLOR.DEFAULT)
  label.style:SetAlign(ALIGN_CENTER)
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", changeObjectWnd)
  scrollListCtrl.scroll:RemoveAllAnchors()
  scrollListCtrl.scroll:AddAnchor("TOPRIGHT", scrollListCtrl, 0, 0)
  scrollListCtrl.scroll:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 0, 0)
  scrollListCtrl.listCtrl:SetColumnHeight(0)
  scrollListCtrl:SetExtent(470, 386)
  scrollListCtrl:AddAnchor("TOPLEFT", label, 0, label:GetHeight() + 13)
  changeObjectWnd.scrollListCtrl = scrollListCtrl
  local scrollListCtrlBg = CreateContentBackground(scrollListCtrl, "TYPE2", "brown_2")
  scrollListCtrlBg:AddAnchor("TOPLEFT", scrollListCtrl, -5, -5)
  scrollListCtrlBg:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 5, 5)
  local calcelBtn = changeObjectWnd:CreateChildWidget("button", "calcelBtn", 0, true)
  ApplyButtonSkin(calcelBtn, BUTTON_BASIC.DEFAULT)
  calcelBtn:AddAnchor("BOTTOM", changeObjectWnd, calcelBtn:GetWidth() / 2 + 2, -MARGIN.WINDOW_SIDE)
  calcelBtn:SetText(GetCommonText("cancel"))
  changeObjectWnd.calcelBtn = calcelBtn
  local applyBtn = changeObjectWnd:CreateChildWidget("button", "applyBtn", 0, true)
  ApplyButtonSkin(applyBtn, BUTTON_BASIC.DEFAULT)
  applyBtn:AddAnchor("TOPLEFT", calcelBtn, -(calcelBtn:GetWidth() + 5), 0)
  applyBtn:SetText(GetCommonText("today_assignment_reset_apply"))
  changeObjectWnd.applyBtn = applyBtn
  function calcelBtn:OnClick(arg)
    if arg == "LeftButton" then
      changeObjectWnd:Show(false)
    end
  end
  calcelBtn:SetHandler("OnClick", calcelBtn.OnClick)
  function applyBtn:OnClick(arg)
    if arg == "LeftButton" then
      local result = X2Achievement:ResetTodayAssignment(TADT_TODAY, changeObjectWnd.selectRealStep)
      changeObjectWnd:Show(false)
    end
  end
  applyBtn:SetHandler("OnClick", applyBtn.OnClick)
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local radiobtn = UIParent:CreateWidget("button", "radiobtn", subItem)
    radiobtn:AddAnchor("LEFT", subItem, 8, 0)
    radiobtn:SetExtent(21, 21)
    subItem.radiobtn = radiobtn
    local radiobtnImg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "radio_button_df", "overlay")
    radiobtnImg:AddAnchor("TOPLEFT", radiobtn, 3, 3)
    subItem.radiobtnImg = radiobtnImg
    local iconBg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "artwork")
    iconBg:SetExtent(54, 54)
    iconBg:AddAnchor("LEFT", radiobtn, radiobtn:GetWidth() + 8, 1)
    subItem.iconBg = iconBg
    local icon = subItem:CreateImageDrawable(INVALID_ICON_PATH, "artwork")
    icon:AddAnchor("TOPLEFT", iconBg, 2, 2)
    icon:AddAnchor("BOTTOMRIGHT", iconBg, -2, -2)
    subItem.icon = icon
    local title = subItem:CreateChildWidget("label", "title", 0, true)
    title:SetExtent(340, FONT_SIZE.MIDDLE)
    title.style:SetFontSize(FONT_SIZE.MIDDLE)
    title.style:SetAlign(ALIGN_LEFT)
    title.style:SetEllipsis(true)
    title:AddAnchor("LEFT", iconBg, iconBg:GetWidth() + 7, -10)
    ApplyTextColor(title, FONT_COLOR.HIGH_TITLE)
    subItem.title = title
    local titleLabel = subItem:CreateChildWidget("label", "titleLabel", 0, true)
    titleLabel:SetExtent(340, FONT_SIZE.MIDDLE)
    titleLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    titleLabel.style:SetAlign(ALIGN_LEFT)
    titleLabel.style:SetEllipsis(true)
    titleLabel:AddAnchor("LEFT", iconBg, iconBg:GetWidth() + 7, 10)
    ApplyTextColor(titleLabel, FONT_COLOR.DEFAULT)
    subItem.titleLabel = titleLabel
    if rowIndex ~= 1 then
      local line = CreateLine(subItem, "TYPE1")
      line:AddAnchor("TOPLEFT", subItem, 0, 0)
      line:AddAnchor("TOPRIGHT", subItem, 0, 0)
      subItem.line = line
    end
  end
  local function SetDataFunc(subItem, data, setValue)
    if setValue then
      subItem.icon:SetTexture(data.iconPath)
      subItem.icon:SetCoords(0, 0, 48, 48)
      subItem.icon:SetVisible(true)
      subItem.iconBg:SetVisible(true)
      subItem.title:SetText(data.title)
      if data.realStep == changeObjectWnd.selectRealStep then
        subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
      else
        subItem.radiobtnImg:SetTextureInfo("radio_button_df")
      end
      function subItem:OnClick(arg)
        if arg == "LeftButton" then
          changeObjectWnd:ResetRadioBtns()
          subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
          changeObjectWnd.applyBtn:Enable(true)
          changeObjectWnd.selectRealStep = data.realStep
        end
      end
      subItem:SetHandler("OnClick", subItem.OnClick)
      function subItem.radiobtn:OnClick(arg)
        if arg == "LeftButton" then
          changeObjectWnd:ResetRadioBtns()
          subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
          changeObjectWnd.applyBtn:Enable(true)
          changeObjectWnd.selectRealStep = data.realStep
        end
      end
      subItem.radiobtn:SetHandler("OnClick", subItem.radiobtn.OnClick)
      local qInfo = MakeTodayQuestInfo(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_LIST, data.questType)
      subItem.titleLabel:SetText(qInfo.titleStr)
      if subItem.line ~= nil then
        subItem.line:Show(true)
      end
    else
      subItem.icon:Show(false)
      subItem.iconBg:Show(false)
      subItem.title:SetText("")
      subItem.titleLabel:SetText("")
      if subItem.line ~= nil then
        subItem.line:Show(false)
      end
    end
  end
  scrollListCtrl:InsertColumn("", 448, LCCIT_WINDOW, SetDataFunc, nil, nil, LayoutFunc)
  scrollListCtrl:InsertRows(6, false)
  function changeObjectWnd:ShowProc()
    changeObjectWnd.selectRealStep = 0
    scrollListCtrl:DeleteAllDatas()
    self:ResetRadioBtns()
    self.applyBtn:Enable(false)
    local maxCnt = X2Achievement:GetTodayAssignmentCount(TADT_TODAY)
    local curCnt = 1
    for i = 1, maxCnt do
      local info = X2Achievement:GetTodayAssignmentInfo(TADT_TODAY, i)
      if info.status == A_TODAY_STATUS.PROGRESS then
        scrollListCtrl:InsertData(curCnt, 1, info)
        curCnt = curCnt + 1
      end
    end
  end
  function changeObjectWnd:ResetRadioBtns()
    for i = 1, #changeObjectWnd.scrollListCtrl.listCtrl.items do
      subItem = changeObjectWnd.scrollListCtrl.listCtrl.items[i].subItems[1]
      subItem.radiobtnImg:SetTextureInfo("radio_button_df")
    end
  end
  return changeObjectWnd
end
function CreateATodayWnd(parent)
  parent.isTodayAssignmentWnd = true
  local assignDesc = CreateTodayAssignDescWnd("assignDesc", parent, W_TODAY_ASSIGN_DESC.TYPE.TODAY)
  assignDesc:SetWidth(286)
  assignDesc:AddAnchor("TOPLEFT", parent, 0, 16)
  assignDesc:AddAnchor("BOTTOMLEFT", parent, 0, 0)
  local rewardWnd = CreateEventCenterAdditionalRewardWnd("rewardWnd", assignDesc, 3)
  rewardWnd:AddAnchor("BOTTOM", assignDesc, 0, -11)
  local rewardTitle = rewardWnd:CreateChildWidget("label", "rewardTitle", 0, true)
  rewardTitle:SetAutoResize(true)
  rewardTitle:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(rewardTitle, FONT_COLOR.DEFAULT)
  rewardTitle:SetText(GetCommonText("today_assignment_goal_title"))
  rewardTitle:AddAnchor("BOTTOMLEFT", rewardWnd, "TOPLEFT", 5, -8)
  local listWnd = CreateTodayAssignmentListWnd("listWnd", parent)
  listWnd:AddAnchor("TOPLEFT", assignDesc, "TOPRIGHT", 20, 0)
  listWnd:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  listWnd:Init()
  local descWnd = CreateDescWnd("descWnd", parent)
  descWnd:AddAnchor("TOPLEFT", assignDesc, "TOPRIGHT", 20, 0)
  descWnd:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  descWnd:Show(false)
  local changeObjectWnd = CreateChangeObjectWnd("changeObjectWnd", parent)
  parent.changeObjectWnd = changeObjectWnd
  local function ToggleDetailWnd(index, aList)
    descWnd:SetInfo(index, aList, listWnd)
  end
  listWnd:SetListSelectFuc(ToggleDetailWnd)
  function assignDesc:Update()
    local goalInfo = X2Achievement:GetTodayAssignmentGoal()
    if goalInfo == nil or #goalInfo == 0 then
      rewardWnd:Show(false)
      return
    end
    local rewardInfo = {}
    for i = 1, #goalInfo do
      rewardInfo[i] = X2Item:GetItemInfoByType(goalInfo[i].itemType)
      rewardInfo[i].dayCount = goalInfo[i].goal
      rewardInfo[i].itemCount = goalInfo[i].itemCount
    end
    rewardWnd:SetRewardInfos(rewardInfo)
    local done, total = X2Achievement:GetTodayAssignmentStatus()
    rewardWnd:CheckTodayAssignmentRewardState(done, total)
    rewardWnd:Show(true)
  end
  assignDesc:Update()
  function parent:ToggleWithQuest(qType)
    local cnt = X2Achievement:GetTodayAssignmentCount(TADT_TODAY)
    local info = {}
    for index = 1, cnt do
      info[index] = index
    end
    for index = 1, #info do
      local tInfo = X2Achievement:GetTodayAssignmentInfo(TADT_TODAY, info[index])
      if tInfo ~= nil and tInfo.questType == qType then
        ToggleDetailWnd(index, info)
      end
    end
  end
  function parent:Update()
    if parent:IsVisible() then
      assignDesc:Update()
      listWnd:Update()
      descWnd:Update()
    end
  end
  function parent:OnTabChangedProc()
    parent:Update()
  end
  local todayAssignmentEvents = {
    UPDATE_TODAY_ASSIGNMENT = function()
      parent:Update()
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      parent:Update()
    end,
    QUEST_CONTEXT_UPDATED = function(qType, status)
      if X2Quest:IsTodayQuest(qType) == true and status == "updated" then
        parent:Update()
      end
    end,
    ADDED_ITEM = function()
      parent:Update()
    end,
    REMOVED_ITEM = function()
      parent:Update()
    end,
    UPDATE_TODAY_ASSIGNMENT_RESET_COUNT = function(count)
      listWnd:Update()
    end
  }
  parent:SetHandler("OnEvent", function(this, event, ...)
    todayAssignmentEvents[event](...)
  end)
  RegistUIEvent(parent, todayAssignmentEvents)
end
