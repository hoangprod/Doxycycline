APPLICANT_PER_COUNT = 20
function SetViewOfApplicantManagemanet(id, recruitWnd)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local applicantWnd = CreateWindow(id, "UIParent")
  applicantWnd:SetExtent(680, 700)
  applicantWnd:AddAnchor("CENTER", "UIParent", 0, 0)
  applicantWnd:SetTitle(GetCommonText("expedition_applicant_managemanet"))
  applicantWnd:Show(true)
  recruitWnd.applicantManagemanetWnd = applicantWnd
  local bg = CreateContentBackground(applicantWnd, "TYPE5", "brown")
  bg:SetExtent(430, 43)
  bg:AddAnchor("TOPLEFT", applicantWnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  bg:AddAnchor("TOPRIGHT", applicantWnd, -MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  local applicantCount = applicantWnd:CreateChildWidget("textbox", "applicantCount", 0, true)
  applicantCount:SetExtent(500, FONT_SIZE.LARGE)
  applicantCount:SetHeight(FONT_SIZE.LARGE)
  applicantCount:AddAnchor("RIGHT", bg, -MARGIN.WINDOW_SIDE, 0)
  applicantCount.style:SetAlign(ALIGN_RIGHT)
  applicantCount.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(applicantCount, FONT_COLOR.DEFAULT)
  local memberCount = applicantWnd:CreateChildWidget("textbox", "memberCount", 0, true)
  memberCount:SetExtent(500, FONT_SIZE.LARGE)
  memberCount:SetHeight(FONT_SIZE.LARGE)
  memberCount:AddAnchor("RIGHT", applicantCount, "LEFT", -MARGIN.WINDOW_SIDE / 2, 0)
  memberCount.style:SetAlign(ALIGN_RIGHT)
  memberCount.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(memberCount, FONT_COLOR.DEFAULT)
  local applicantList = CreatePageListCtrl(applicantWnd, "applicantList", 0)
  applicantList:Show(true)
  applicantList:SetExtent(applicantWnd:GetWidth() - MARGIN.WINDOW_SIDE * 2, 545)
  applicantList:AddAnchor("TOPLEFT", applicantWnd, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE + bg:GetHeight())
  applicantWnd.applicantList = applicantList
  local checkAll = CreateCheckButton("checkboxAll", applicantWnd, "")
  local SetTextFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local LevelDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local lv = data.level
      if data.heirLevel > 0 then
        lv = data.heirLevel
        subItem.heirIcon:Show(true)
      else
        subItem.heirIcon:Show(false)
      end
      subItem:SetText(tostring(lv))
    end
  end
  local SetMemoFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
      local function OnEnter(self)
        SetTooltip(data, self, true)
      end
      subItem:SetHandler("OnEnter", OnEnter)
    else
      subItem:SetText("")
    end
  end
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem.charId = data.charId
      subItem:SetText(data.name)
      subItem.check:Show(true)
    else
      subItem:SetText("")
      subItem.check:Show(false)
      subItem.check:SetChecked(false)
    end
  end
  local function LayoutFunc(applicantList, rowIndex, colIndex, subItem)
    local check = CreateCheckButton("checkbox", subItem, "")
    check:AddAnchor("LEFT", subItem, 0, 0)
    check:Show(false)
    subItem.check = check
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(check:GetWidth(), 0, 0, 0)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    function check:OnCheckChanged()
      if self:GetChecked() then
        return
      end
      checkAll:SetChecked(false)
    end
    check:SetHandler("OnCheckChanged", check.OnCheckChanged)
  end
  local LevelLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:Raise()
    subItem:SetAutoResize(true)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local heirIcon = subItem:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor_small", "artwork")
    heirIcon:AddAnchor("RIGHT", subItem, "LEFT", -4, 0)
    subItem.heirIcon = heirIcon
  end
  local memoLayoutFunc = function(applicantList, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem.style:SetEllipsis(true)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem:SetInset(10, 0, 10, 0)
    subItem:Raise()
  end
  applicantList:InsertColumn(GetCommonText("name"), 252, LCCIT_STRING, SetDataFunc, nil, nil, LayoutFunc)
  applicantList:InsertColumn(GetCommonText("expedition_applicant_level"), 77, LCCIT_STRING, LevelDataSetFunc, nil, nil, LevelLayoutFunc)
  applicantList:InsertColumn(GetCommonText("memo"), 211, LCCIT_STRING, SetMemoFunc, nil, nil, memoLayoutFunc)
  applicantList:InsertColumn(GetCommonText("register_day"), 100, LCCIT_STRING, SetTextFunc, nil, nil, nil)
  applicantList:InsertRows(APPLICANT_PER_COUNT, false)
  DrawListCtrlUnderLine(applicantList)
  for i = 1, #applicantList.listCtrl.column do
    SettingListColumn(applicantList.listCtrl, applicantList.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(applicantList.listCtrl.column[i], #applicantList.listCtrl.column, i)
  end
  checkAll:AddAnchor("LEFT", applicantList.listCtrl.column[1], 0, -1)
  checkAll:Show(true)
  applicantWnd.checkAll = checkAll
  local rejectButton = applicantWnd:CreateChildWidget("button", "rejectButton", 0, true)
  rejectButton:SetText(expeditionLocale.texts.reject)
  rejectButton:AddAnchor("BOTTOMRIGHT", applicantWnd, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  ApplyButtonSkin(rejectButton, BUTTON_BASIC.DEFAULT)
  local acceptButton = applicantWnd:CreateChildWidget("button", "acceptButton", 0, true)
  acceptButton:SetText(expeditionLocale.texts.accept)
  acceptButton:AddAnchor("RIGHT", rejectButton, "LEFT", 0, 0)
  ApplyButtonSkin(acceptButton, BUTTON_BASIC.DEFAULT)
  return applicantWnd
end
