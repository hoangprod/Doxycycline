local CUR_SELECTED = 1
local BOUNTY_RECORDS = {}
local BOUNTY_TOTAL = 0
local function CreateBountyBulletinWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:SetCloseOnEscape(false)
  wnd:SetExtent(800, 440)
  wnd:Show(false)
  wnd:AddAnchor("TOP", "UIParent", 0, 160)
  wnd:SetTitle(locale.trial.bountyBulletin)
  local leftFrame = CreateRecordsLeftFrame("leftFrame", wnd)
  leftFrame:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
  leftFrame.totalReportCount:Show(false)
  leftFrame.takeCount:RemoveAllAnchors()
  leftFrame.takeCount:AddAnchor("TOPLEFT", leftFrame.crimePoint, 0, sideMargin * 1.2)
  wnd.leftFrame = leftFrame
  function wnd:FillLeftFrame(index, bountyRecords)
    if CUR_SELECTED < 0 then
      return
    end
    local data = bountyRecords[CUR_SELECTED]
    if data == nil then
      return
    end
    local leftFrame = self.leftFrame
    local identikitPicture = self.leftFrame.identikitPicture
    identikitPicture.name:SetText(data[2])
    identikitPicture.race:SetText(data[8])
    identikitPicture.faction:SetText(data[9])
    leftFrame.crimePoint:FillItem(locale.trial.crimePointStr, tostring(data[6]))
    leftFrame.takeCount:FillItem(locale.trial.arrestHistory, locale.trial.trialChoice(tostring(data[12]), tostring(data[11])))
    leftFrame.rulingHistory:FillItem(locale.trial.rulingHistory, locale.trial.rulingChoice(tostring(data[14]), data[13]))
    leftFrame.totalImprisonmentTime:FillItem(locale.trial.jailTotal, locale.trial.jailMinutes(tostring(data[15] / 60)))
  end
  local bountyButton = wnd:CreateChildWidget("button", "bountyButton", 0, true)
  bountyButton:SetText(locale.trial.bountyTitle)
  ApplyButtonSkin(bountyButton, BUTTON_BASIC.DEFAULT)
  bountyButton:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin, -sideMargin)
  local LeftButtonClickFunc = function()
    if curSelected > 0 then
      local name = bountyRecords[curSelected][2]
      X2Trial:RequestSetBountyMoney(name)
    end
  end
  ButtonOnClickHandler(bountyButton, LeftButtonClickFunc)
  local DataSetCommonFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local LayoutFuncLimitLabelColumn = function(frame, rowIndex, colIndex, subItem)
    subItem:SetInset(5, 0, 5, 0)
    subItem:SetLimitWidth(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local pageListCtrl = CreatePageListCtrl(wnd, "listCtrl", 0)
  pageListCtrl:SetExtent(550, 325)
  pageListCtrl:AddAnchor("TOPLEFT", leftFrame, "TOPRIGHT", sideMargin / 2, 0)
  pageListCtrl:SetUseDoubleClick(true)
  pageListCtrl.pageControl:RemoveAllAnchors()
  pageListCtrl.pageControl:AddAnchor("TOP", pageListCtrl, "BOTTOM", 0, sideMargin / 2)
  wnd.pageListCtrl = pageListCtrl
  pageListCtrl:InsertColumn(locale.trial.crimePointStr, 60, LCCIT_STRING)
  pageListCtrl:InsertColumn(locale.trial.bountyWanted, 125, LCCIT_STRING, DataSetCommonFunc, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertColumn(locale.trial.bountyLevel, 50, LCCIT_STRING, DataSetCommonFunc, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertColumn(locale.trial.bountyLocation, 125, LCCIT_STRING, DataSetCommonFunc, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertColumn(locale.trial.bountyMoney, 190, LCCIT_STRING, DataSetCommonFunc, nil, nil, LayoutFuncLimitLabelColumn)
  pageListCtrl:InsertRows(USER_TRIAL.MAX_ITEM_COUNT, false)
  pageListCtrl.listCtrl:DisuseSorting()
  DrawListCtrlUnderLine(pageListCtrl)
  pageListCtrl.listCtrl:UseOverClickTexture()
  for i = 1, #pageListCtrl.listCtrl.column do
    DrawListCtrlColumnSperatorLine(pageListCtrl.listCtrl.column[i], #pageListCtrl.listCtrl.column, i)
  end
  function wnd:FillData(pageIndex)
    pageListCtrl:DeleteAllDatas()
    pageListCtrl.listCtrl:ClearSelection()
    if pageIndex == nil then
      pageIndex = 1
    end
    for i = 1, #BOUNTY_RECORDS do
      listCtrl:InsertData(i, 1, tostring(bountyRecords[index][6]))
      listCtrl:InsertData(i, 2, tostring(bountyRecords[index][2]))
      listCtrl:InsertData(i, 3, tostring(bountyRecords[index][3]))
      listCtrl:InsertData(i, 4, tostring(bountyRecords[index][7]))
      listCtrl:InsertData(i, 5, tostring(bountyRecords[index][5]))
    end
  end
  function pageListCtrl:OnPageChangedProc(curPageIdx)
    wnd:FillData(curPageIdx)
  end
  function pageListCtrl:SelChangedProc(viewIndex, dataIndex, dataKey, doubleClick)
    if viewIndex == 0 or dataKey == nil then
      return
    end
    wnd:FillLeftFrame(dataIndex, BOUNTY_RECORDS)
  end
  local function OnHide()
    userTrial.bountyBulletWnd = nil
    CUR_SELECTED = 1
    BOUNTY_RECORDS = {}
    BOUNTY_TOTAL = 0
  end
  wnd:SetHandler("OnHide", OnHide)
  local events = {
    SET_BOUNTY_DONE = function(targetId, targetName, curBountyMoney, showCenter)
      for i = 1, BOUNTY_TOTAL do
        if BOUNTY_RECORDS[i][1] == targetId then
          BOUNTY_RECORDS[i][5] = curBountyMoney
          wnd:FillData(pageListCtrl.pageControl:GetCurrentPageIndex())
        end
      end
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
  return wnd
end
function ShowBountyBulletWindow(doodadId)
  BOUNTY_RECORDS, BOUNTY_TOTAL = X2Trial:GetBountyData()
  if BOUNTY_TOTAL == -1 then
    return
  end
  if CUR_SELECTED > BOUNTY_TOTAL then
    CUR_SELECTED = BOUNTY_TOTAL
  end
  if userTrial.bountyBulletWnd == nil then
    userTrial.bountyBulletWnd = CreateBountyBulletinWindow("userTrial.bountyBulletWnd", "UIParent")
  end
  userTrial.bountyBulletWnd:FillLeftFrame(CUR_SELECTED, BOUNTY_RECORDS)
  if CUR_SELECTED < 1 then
    CUR_SELECTED = 1
  end
  userTrial.bountyBulletWnd.pageListCtrl:UpdatePage(BOUNTY_TOTAL, USER_TRIAL.MAX_ITEM_COUNT)
  userTrial.bountyBulletWnd:FillData(1)
  userTrial.bountyBulletWnd:Show(true)
end
UIParent:SetEventHandler("TOGGLE_BOUNTY_BULLETIN", ShowBountyBulletWindow)
