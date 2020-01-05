EXPEDITION_IMMIGRATION_PER_COUNT = 10
function SetViewOfExpeditionImmigration(id, peopleWnd)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, "UIParent")
  wnd:SetExtent(680, 500)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetCommonText("immigration_expediton_management"))
  wnd:Show(true)
  peopleWnd.immigrationWnd = wnd
  local bg = CreateContentBackground(wnd, "TYPE5", "brown")
  bg:SetExtent(430, 43)
  bg:AddAnchor("TOPLEFT", wnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  bg:AddAnchor("TOPRIGHT", wnd, -MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  local applicantCount = wnd:CreateChildWidget("textbox", "applicantCount", 0, true)
  applicantCount:SetExtent(500, FONT_SIZE.LARGE)
  applicantCount:SetHeight(FONT_SIZE.LARGE)
  applicantCount:AddAnchor("RIGHT", bg, -MARGIN.WINDOW_SIDE, 0)
  applicantCount.style:SetAlign(ALIGN_RIGHT)
  applicantCount.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(applicantCount, FONT_COLOR.DEFAULT)
  local applicantList = CreatePageListCtrl(wnd, "applicantList", 0)
  applicantList:Show(true)
  applicantList:SetExtent(wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2, 340)
  applicantList:AddAnchor("TOPLEFT", wnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE + bg:GetHeight())
  wnd.applicantList = applicantList
  local SetTextFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local SetDataFunc = function(subItem, info, setValue)
    if setValue then
      subItem.expeditionId = info.expeditionId
      subItem:SetText(info.name)
    else
      subItem:SetText("")
    end
  end
  local LayoutFunc = function(applicantList, rowIndex, colIndex, subItem)
    ApplyTextColor(applicantList.listCtrl.column[colIndex], FONT_COLOR.DEFAULT)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(40, 0, 0, 0)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  applicantList:InsertColumn(GetUIText(NATION_TEXT, "expedition"), 250, LCCIT_STRING, SetDataFunc, nil, nil, LayoutFunc)
  applicantList:InsertColumn(GetCommonText("level"), 100, LCCIT_STRING, SetTextFunc, nil, nil, nil)
  applicantList:InsertColumn(GetCommonText("number_of_people2"), 150, LCCIT_STRING, SetTextFunc, nil, nil, memoLayoutFunc)
  applicantList:InsertColumn(GetCommonText("gear_score_average"), 140, LCCIT_STRING, SetTextFunc, nil, nil, nil)
  applicantList:InsertRows(10, false)
  DrawListCtrlUnderLine(applicantList)
  for i = 1, #applicantList.listCtrl.column do
    SettingListColumn(applicantList.listCtrl, applicantList.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(applicantList.listCtrl.column[i], #applicantList.listCtrl.column, i)
    applicantList.listCtrl.column[i]:Enable(false)
  end
  local rejectButton = wnd:CreateChildWidget("button", "rejectButton", 0, true)
  rejectButton:SetText(expeditionLocale.texts.reject)
  rejectButton:AddAnchor("BOTTOMRIGHT", wnd, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  ApplyButtonSkin(rejectButton, BUTTON_BASIC.DEFAULT)
  local acceptButton = wnd:CreateChildWidget("button", "acceptButton", 0, true)
  acceptButton:SetText(expeditionLocale.texts.accept)
  acceptButton:AddAnchor("RIGHT", rejectButton, "LEFT", 0, 0)
  ApplyButtonSkin(acceptButton, BUTTON_BASIC.DEFAULT)
  return wnd
end
