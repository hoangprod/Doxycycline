MAX_SCROLLBAL_VIEW_COUNT = 10
function GetPageIdx(pageCurrentIdx, pagePerCount, idx)
  return (pageCurrentIdx - 1) * pagePerCount + idx
end
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local ReasontextTable = {
  locale.reportBadUser.reportTypeBot,
  locale.reportBadUser.reportTypeMail,
  locale.reportBadUser.reportTypeChat,
  locale.reportBadUser.reportTypeEtc,
  locale.reportBadUser.reportTypeAbusing,
  locale.reportBadUser.reportTypeBadCharacterName,
  locale.reportBadUser.reportTypeExpeditionName
}
local function SetViewOfBadUserList(window)
  local pageListCtrl = W_CTRL.CreatePageScrollListCtrl("pageListCtrl", window)
  pageListCtrl:Show(true)
  pageListCtrl:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  pageListCtrl:AddAnchor("BOTTOMRIGHT", window, -sideMargin, bottomMargin + bottomMargin / 2)
  pageListCtrl:SetUseDoubleClick(false)
  window.pageListCtrl = pageListCtrl
  local DataSuspectedSetColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(X2Util:UTF8StringLimit(data, userReportBadUser.BadUserRecords.suspectedstringLimit, "..."))
    else
      subItem:SetText("")
    end
  end
  local DataReportTypeSetColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(X2Util:UTF8StringLimit(data, userReportBadUser.BadUserRecords.reporttypestringLimit, "..."))
    else
      subItem:SetText("")
    end
  end
  local DataRerpotTimeSetColumn = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local LayoutFuncReporterLabelColumn = function(pageListCtrl, rowIndex, colIndex, subItem)
    subItem:SetInset(16, 0, 16, 0)
    subItem:SetLimitWidth(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local line = DrawItemUnderLine(subItem)
    line:RemoveAllAnchors()
    line:SetVisible(true)
    line:AddAnchor("TOPLEFT", subItem, "BOTTOMLEFT", 0, 0)
    line:AddAnchor("TOPRIGHT", subItem:GetParent(), "BOTTOMRIGHT", 0, 0)
  end
  local LayoutFuncLimitLabelColumn = function(pageListCtrl, rowIndex, colIndex, subItem)
    subItem:SetInset(5, 0, 5, 0)
    subItem:SetLimitWidth(true)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local colWidth = userReportBadUser.BadUserRecords.columnWidth
  pageListCtrl:InsertColumn(locale.reportBadUser.target, colWidth[1], LCCIT_STRING, DataSuspectedSetColumn, nil, nil, LayoutFuncReporterLabelColumn)
  pageListCtrl:InsertColumn(locale.reportBadUser.reportReason, colWidth[2], LCCIT_STRING, DataReportTypeSetColumn, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertColumn(locale.reportBadUser.reportTime, colWidth[3], LCCIT_STRING, DataRerpotTimeSetColumn, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertRows(MAX_SCROLLBAL_VIEW_COUNT, false)
  pageListCtrl.listCtrl:DisuseSorting()
  DrawListCtrlUnderLine(pageListCtrl.listCtrl)
  pageListCtrl.listCtrl:UseOverClickTexture()
  for i = 1, #pageListCtrl.listCtrl.column do
    SettingListColumn(pageListCtrl.listCtrl, pageListCtrl.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(pageListCtrl.listCtrl.column[i], #pageListCtrl.listCtrl.column, i)
    pageListCtrl.listCtrl.column[i].style:SetAlign(ALIGN_CENTER)
  end
  return pageListCtrl
end
local function CreateBadUserListFrame(window)
  local pageListCtrl = SetViewOfBadUserList(window)
  local records_ok_btn = window:CreateChildWidget("button", "records_ok_btn", 0, true)
  records_ok_btn:AddAnchor("TOP", pageListCtrl.pageControl, "BOTTOM", 0, 7)
  records_ok_btn:SetText(GetUIText(COMMON_TEXT, "ok"))
  ApplyButtonSkin(records_ok_btn, BUTTON_BASIC.DEFAULT)
  records_ok_btn:Show(true)
  local function RecordsOKButtonClickFunc(self)
    window:Show(false)
  end
  ButtonOnClickHandler(records_ok_btn, RecordsOKButtonClickFunc)
  function window:FillData()
    window:WaitPage(true)
    pageListCtrl:DeleteAllDatas()
    pageListCtrl.listCtrl:ClearSelection()
    local function FillListData(pageIndex)
      if pageIndex == nil then
        pageIndex = 1
      end
      local badUserRecords = X2Trial:GetBadUserRecordsByPage(pageIndex)
      if badUserRecords == nil then
        window:WaitPage(false)
        return
      end
      for i = 1, #badUserRecords do
        pageListCtrl:InsertData(i, 1, badUserRecords[i][1])
        pageListCtrl:InsertData(i, 2, ReasontextTable[badUserRecords[i][2]])
        pageListCtrl:InsertData(i, 3, badUserRecords[i][3])
      end
      window:WaitPage(false)
    end
    local pageCurrentIndex = pageListCtrl:GetCurrentPageIndex()
    local totalCount = X2Trial:GetReciveBadUserListCount()
    if totalCount == 0 then
      window:WaitPage(false)
      return
    end
    local listIndex
    for i = 1, MAX_BAD_USER_RECORD_PER_PAGE_COUNT do
      listIndex = GetPageIdx(pageCurrentIndex, MAX_BAD_USER_RECORD_PER_PAGE_COUNT, i)
      if totalCount < listIndex then
        listIndex = listIndex - 1
        break
      end
      local listRecords = X2Trial:GetClientBadUserList(listIndex)
      if listRecords == false then
        break
      end
    end
    local listLastIndex = GetPageIdx(pageCurrentIndex, MAX_BAD_USER_RECORD_PER_PAGE_COUNT, MAX_BAD_USER_RECORD_PER_PAGE_COUNT)
    if totalCount < listLastIndex then
      listLastIndex = totalCount
    end
    if totalCount < listIndex or listIndex <= 0 then
      pageListCtrl:SetPageByItemCount(totalCount, MAX_BAD_USER_RECORD_PER_PAGE_COUNT)
      window:WaitPage(false)
      return
    end
    local fillData = X2Trial:GetClientBadUserList(listIndex)
    if fillData == true then
      FillListData(pageCurrentIndex)
    else
      X2Trial:RequestBadUserList(listIndex, listLastIndex)
    end
    if totalCount > MAX_BAD_USER_RECORDS_LIST_COUNT then
      totalCount = MAX_BAD_USER_RECORDS_LIST_COUNT
    end
    pageListCtrl:SetPageByItemCount(totalCount, MAX_BAD_USER_RECORD_PER_PAGE_COUNT)
  end
  function window:ShowList(show)
    window:Show(show)
  end
  function pageListCtrl:OnPageChangedProc(curPageIdx)
    if curPageIdx > MAX_BAD_USER_RECORDS_PAGE_COUNT then
      return
    end
    window:FillData()
  end
end
function CreateBadUserFrame(id, parent)
  local window = CreateWindow(id, parent)
  window:AddAnchor("RIGHT", "UIParent", 0, 0)
  window:SetExtent(600, 417)
  window:SetTitle(locale.reportBadUser.title)
  local modalLoadingWindow = CreateLoadingTextureSet(window)
  modalLoadingWindow:AddAnchor("TOPLEFT", window, 2, titleMargin)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", window, -3, bottomMargin + 65)
  CreateBadUserListFrame(window)
  return window
end
reportBaduserFrame = CreateBadUserFrame("reportBaduserFrame", "UIParent")
function ShowReportBadUser(show)
  show = not reportBaduserFrame:IsVisible()
  if show then
    reportBaduserFrame:FillData()
  end
  reportBaduserFrame:ShowList(show)
end
function reportBaduserFrame:OnEvent(event, ...)
  if reportBaduserFrame:IsVisible() == true then
    reportBaduserFrame:FillData()
  end
end
reportBaduserFrame:SetHandler("OnEvent", reportBaduserFrame.OnEvent)
reportBaduserFrame:RegisterEvent("BAD_USER_LIST_UPDATE")
