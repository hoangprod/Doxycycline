local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function ShowRelationAccept(name, factionName)
  local function DialogNoticeHandler(wnd, infoTable)
    wnd:SetTitle(GetCommonText("faction_dialog_title"))
    wnd:UpdateDialogModule("textbox", GetCommonText("faction_dialog_body2", name, factionName))
  end
  X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
end
function ShowRelationDeny(name)
  local function DialogNoticeHandler(wnd, infoTable)
    wnd:SetTitle(GetCommonText("faction_dialog_title"))
    wnd:UpdateDialogModule("textbox", GetCommonText("faction_dialog_body3", name))
  end
  X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
end
function ShowRelationResponse(name, factionName)
  local function DialogDefaultHandler(wnd, infoTable)
    wnd:SetWidth(430)
    wnd.textbox:SetWidth(430 - sideMargin * 2)
    wnd:SetTitle(GetCommonText("faction_dialog_title"))
    wnd:UpdateDialogModule("textbox", GetCommonText("faction_dialog_body4", name))
    local data = {
      header = string.format([[
%s
%s]], GetCommonText("faction_dialog_title_target"), GetCommonText("faction_dialog_title_time")),
      content = string.format([[
%s
%s]], factionName, GetCommonText("faction_dialog_content_time"))
    }
    wnd.showTime = 60000
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VERTICAL_HEADER_TABLE, "table", data)
    local textData = {
      type = "period",
      text = GetCommonText("remain_time", FormatTime(wnd.showTime, false))
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "time", textData)
    function OnUpdate(self, dt)
      wnd.showTime = wnd.showTime - dt
      if wnd.showTime < 0 then
        wnd.showTime = 0
        wnd:Show(false)
      end
      wnd:UpdateDialogModule("time", GetCommonText("faction_dialog_remain_time", FormatTime(wnd.showTime, false)))
    end
    wnd:SetHandler("OnUpdate", OnUpdate)
    function wnd:OkProc()
      X2Nation:ResponseDiplomacy(true)
    end
    function wnd:CancelProc()
      X2Nation:ResponseDiplomacy(false)
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogDefaultHandler, "")
end
function ShowRelationRequest(name, charId, factionName, factionId)
  local function DialogDefaultHandler(wnd, infoTable)
    wnd:SetWidth(430)
    wnd.textbox:SetWidth(430 - sideMargin * 2)
    wnd:SetTitle(GetCommonText("faction_dialog_title"))
    wnd:UpdateDialogModule("textbox", GetCommonText("faction_dialog_body1", name))
    local data = {
      header = string.format([[
%s
%s]], GetCommonText("faction_dialog_title_target"), GetCommonText("faction_dialog_title_time")),
      content = string.format([[
%s
%s]], factionName, GetCommonText("faction_dialog_content_time"))
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VERTICAL_HEADER_TABLE, "table", data)
    function wnd:OkProc()
      X2Nation:RequestDiplomacy(charId, factionId)
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogDefaultHandler, "")
end
UIParent:SetEventHandler("FACTION_RELATION_ACCEPTED", ShowRelationAccept)
UIParent:SetEventHandler("FACTION_RELATION_DENIED", ShowRelationDeny)
UIParent:SetEventHandler("FACTION_RELATION_REQUESTED", ShowRelationResponse)
function CreateRelationHistoryWindow(id)
  local window = CreateWindow(id, "UIParent")
  window:SetExtent(680, 730)
  window:SetTitle(GetCommonText("faction_relation_history_title"))
  local historyWidget = CreatePageListCtrl(window, id, 0)
  historyWidget:Show(true)
  historyWidget:SetExtent(640, 618)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format("%s\r\n%s", X2Faction:GetFactionName(data.f1, true), X2Faction:GetFactionName(data.f2, true)))
    else
      subItem:SetText("")
    end
  end
  local PeriodDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format("%s ~ %s", locale.time.GetDateToSimpleDateFormat(data.update), locale.time.GetDateToSimpleDateFormat(data.change)))
    else
      subItem:SetText("")
    end
  end
  local HeroDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format("%s\r\n%s", data.name1, data.name2))
    else
      subItem:SetText("")
    end
  end
  local NamePeriodLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local HeroLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem:SetInset(15, 0, 0, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  historyWidget:InsertColumn(GetCommonText("faction_relation_history_factions"), 155, LCCIT_TEXTBOX, NameDataSetFunc, nil, nil, NamePeriodLayoutSetFunc)
  historyWidget:InsertColumn(GetCommonText("faction_relation_history_period"), 210, LCCIT_STRING, PeriodDataSetFunc, nil, NamePeriodLayoutSetFunc)
  historyWidget:InsertColumn(GetCommonText("faction_relation_history_heroes"), 275, LCCIT_TEXTBOX, HeroDataSetFunc, nil, nil, HeroLayoutSetFunc)
  historyWidget:InsertRows(10, false)
  DrawListCtrlUnderLine(historyWidget.listCtrl)
  local SettingListColumn = function(listCtrl, column)
    listCtrl:SetColumnHeight(LIST_COLUMN_HEIGHT)
    column.style:SetShadow(false)
    column.style:SetFontSize(FONT_SIZE.LARGE)
    SetButtonFontColor(column, GetTitleButtonFontColor())
  end
  for i = 1, #historyWidget.listCtrl.column do
    SettingListColumn(historyWidget.listCtrl, historyWidget.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(historyWidget.listCtrl.column[i], #historyWidget.listCtrl.column, i)
  end
  ListCtrlItemGuideLine(historyWidget.listCtrl.items, 11)
  function historyWidget:OnPageChangedProc(pageIndex)
    local viewCount = self:GetVisibleItemCountCurrentPage()
    for i = 1, self:GetRowCount() do
      local item = historyWidget.listCtrl.items[i]
      item.line:SetVisible(false)
    end
    for i = 1, viewCount do
      local item = historyWidget.listCtrl.items[i]
      item.line:SetVisible(true)
    end
  end
  function window:FillResult(result)
    historyWidget:DeleteAllDatas()
    historyWidget:UpdatePage(#result, 10)
    for i = 1, #result do
      historyWidget:InsertData(i, 1, result[i])
      historyWidget:InsertData(i, 2, result[i])
      historyWidget:InsertData(i, 3, result[i])
    end
    for i = 1, #historyWidget.listCtrl.items do
      local item = historyWidget.listCtrl.items[i]
      item.line:SetVisible(true)
    end
    window:Show(true)
  end
  historyWidget:AddAnchor("TOP", window, 0, 50)
  window.history = historyWidget
  historyWidget.pageControl:RemoveAllAnchors()
  historyWidget.pageControl:AddAnchor("TOP", historyWidget, "BOTTOM", 0, 12)
  window:Show(true)
  return window
end
function CreateRelationRequestWindow(id)
  local window = CreateWindow(id, "UIParent")
  window:SetExtent(800, 411)
  window:SetTitle(GetCommonText("faction_relation_request_title"))
  local body = window:CreateChildWidget("textbox", "body", 0, true)
  body:SetExtent(670, FONT_SIZE.MIDDLE)
  body:AddAnchor("TOP", window, 0, 50)
  body:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  body:SetAutoResize(true)
  body.style:SetFontSize(FONT_SIZE.MIDDLE)
  body.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(body, FONT_COLOR.DEFAULT)
  body:SetText(GetCommonText("faction_relation_request_body"))
  body:Show(true)
  local leftData = CreateWithPreset(WINDOW_MODULE_PRESET.TITLE_BOX.TYPE1, {
    title = GetCommonText("faction_relation_request_factions"),
    fix_width = 270,
    align = ALIGN_LEFT,
    body_inset = {
      3,
      0,
      5,
      0
    }
  })
  local leftInfoWnd = W_MODULE:Create("leftInfoWnd", window, WINDOW_MODULE_TYPE.TITLE_BOX, leftData)
  leftInfoWnd:AddAnchor("TOPLEFT", body, "BOTTOMLEFT", -45, 10)
  local factions = leftInfoWnd:CreateChildWidget("emptywidget", "factions", 0, true)
  local content = W_CTRL.CreateList("content", factions)
  content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
  content.itemStyle:SetAlign(ALIGN_LEFT)
  content.itemStyleSub:SetFontSize(FONT_SIZE.MIDDLE)
  content:SetHeight(FONT_SIZE.MIDDLE)
  content:ShowTooltip(false)
  content:SetTreeTypeIndent(true, 20, 10)
  content:SetSubTextOffset(20, 0, false)
  content:AddAnchor("TOPLEFT", factions, 0, 0)
  content:AddAnchor("BOTTOMRIGHT", factions, 0, 0)
  content:SetStyle("use_texture")
  factions:SetExtent(260, 221)
  leftInfoWnd:AddBody(factions)
  local rightData = CreateWithPreset(WINDOW_MODULE_PRESET.TITLE_BOX.TYPE1, {
    title = GetCommonText("faction_relation_request_heros"),
    fix_width = 485,
    body_inset = {
      0,
      0,
      0,
      5
    }
  })
  local rightInfoWnd = W_MODULE:Create("rightInfoWnd", window, WINDOW_MODULE_TYPE.TITLE_BOX, rightData)
  rightInfoWnd:AddAnchor("TOPRIGHT", body, "BOTTOMRIGHT", 45, 10)
  local heroes = W_CTRL.CreateListCtrl("heroes", rightInfoWnd)
  heroes:RemoveAllAnchors()
  heroes:SetExtent(485, 216)
  heroes:InsertColumn(95, LCCIT_WINDOW)
  heroes.column[1]:SetText(GetCommonText("faction_relation_request_degree"))
  heroes:InsertColumn(275, LCCIT_CHARACTER_NAME)
  heroes.column[2]:SetText(GetCommonText("faction_relation_request_name"))
  heroes:InsertColumn(115, LCCIT_STRING)
  heroes.column[3]:SetText(GetCommonText("faction_relation_request_deny_count"))
  heroes:InsertRows(6, false)
  heroes:DisuseSorting()
  DrawListCtrlUnderLine(heroes)
  heroes:UseOverClickTexture()
  for i = 1, #heroes.column do
    SettingListColumn(heroes, heroes.column[i])
    heroes.column[i].style:SetFontSize(FONT_SIZE.MIDDLE)
    DrawListCtrlColumnSperatorLine(heroes.column[i], #heroes.column, i)
  end
  for i = 1, #heroes.items do
    local degree = heroes.items[i].subItems[1]:CreateDrawable(TEXTURE_PATH.SIEGE_RAID, "icon_commander", "background")
    degree:AddAnchor("CENTER", heroes.items[i].subItems[1], 0, 0)
    degree:SetVisible(false)
    heroes.items[i].subItems[1].degree = degree
    heroes.items[i].subItems[2]:SetLimitWidth(true)
    heroes.items[i].subItems[2]:SetInset(5, 0, 0, 0)
    heroes.items[i].subItems[2].style:SetAlign(ALIGN_LEFT)
    heroes.items[i].subItems[2].style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(heroes.items[i].subItems[2], FONT_COLOR.DEFAULT)
    heroes.items[i].subItems[2]:SetText("")
    heroes.items[i].subItems[3]:SetLimitWidth(true)
    heroes.items[i].subItems[3].style:SetAlign(ALIGN_CENTER)
    heroes.items[i].subItems[3].style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(heroes.items[i].subItems[3], FONT_COLOR.DEFAULT)
    heroes.items[i].subItems[3]:SetText("")
  end
  rightInfoWnd:AddBody(heroes, false)
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("TOPRIGHT", window, -sideMargin - 5, 3)
  local function OnEnterGuide()
    SetTooltip(GetCommonText("faction_relation_request_tooltip"), guide)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local OnLeaveGuide = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeaveGuide)
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(GetUIText(NATION_TEXT, "friendly_setting"))
  okButton:AddAnchor("TOPRIGHT", window, "BOTTOMRIGHT", -sideMargin, bottomMargin + 11)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:Enable(false)
  local function ButtonClickFunc()
    local fname = X2Faction:GetFactionName(okButton.factionId, true)
    ShowRelationRequest(okButton.charName, okButton.charId, fname, okButton.factionId)
    window:Show(false)
  end
  ButtonOnClickHandler(okButton, ButtonClickFunc)
  local bottomComment = window:CreateChildWidget("label", "bottomComment", 0, true)
  bottomComment:SetExtent(392, FONT_SIZE.SMALL)
  bottomComment:AddAnchor("BOTTOMRIGHT", okButton, "BOTTOMLEFT", -10, -3)
  bottomComment.style:SetFontSize(FONT_SIZE.SMALL)
  bottomComment.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(bottomComment, FONT_COLOR.RED)
  bottomComment:SetText(GetCommonText("faction_relation_request_apply_explain"))
  local bottomCount = window:CreateChildWidget("label", "bottomCount", 0, true)
  bottomCount:SetExtent(392, FONT_SIZE.MIDDLE)
  bottomCount:AddAnchor("BOTTOMRIGHT", bottomComment, "TOPRIGHT", 0, -5)
  bottomCount.style:SetFontSize(FONT_SIZE.MIDDLE)
  bottomCount.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(bottomCount, FONT_COLOR.DEFAULT)
  bottomCount:SetText(GetCommonText("faction_relation_request_apply_count"))
  window:Show(true)
  local function OnHide()
    rightInfoWnd:DeleteAllDatas()
  end
  window:SetHandler("OnHide", OnHide)
  function factions:OnSelChanged()
    local value = self:GetSelectedValue()
    heroes:FillData(value)
    if value == nil or value == 0 then
      factions:ClearAllSelected()
    end
    okButton.factionId = value
    okButton:Enable(false)
  end
  function heroes:FillEmpty(i)
    for j = i, MAX_HERO do
      heroes.items[j].subItems[1].degree:Show(false)
      heroes.items[j].subItems[2]:SetText("")
      heroes.items[j].subItems[3]:SetText("")
    end
  end
  function heroes:FillData(value)
    rightInfoWnd:DeleteAllDatas()
    if value == nil or value == 0 then
      heroes:FillEmpty(1)
      return
    end
    local heroList = X2Hero:GetHeroList(value)
    if heroList == nil or #heroList == 0 then
      heroes:FillEmpty(1)
      return
    end
    local grades = {
      "level_01",
      "level_02",
      "level_02",
      "level_03",
      "level_03",
      "level_03"
    }
    local i = 1
    for k, v in pairs(heroList) do
      if v.name ~= nil then
        local curCnt, maxCnt = X2Nation:GetRelationCount(v.charId)
        local cntStr = string.format("%d / %d", curCnt, maxCnt)
        local data = {}
        data.charId = v.charId
        data.curCnt = curCnt
        data.maxCnt = maxCnt
        rightInfoWnd:InsertData(i, 1, data)
        rightInfoWnd:InsertData(i, 2, v.name)
        rightInfoWnd:InsertData(i, 3, cntStr)
        local fontColor = FONT_COLOR.DEFAULT
        local gradeCoord = grades[k]
        if curCnt == maxCnt then
          fontColor = FONT_COLOR.GRAY
          gradeCoord = grades[k] .. "_gray"
        end
        ApplyTextColor(heroes.items[i].subItems[2], fontColor)
        ApplyTextColor(heroes.items[i].subItems[3], fontColor)
        heroes.items[i].subItems[1].degree:Show(true)
        heroes.items[i].subItems[1].degree:SetTextureInfo(gradeCoord)
        i = i + 1
      end
    end
    heroes:FillEmpty(i)
  end
  function rightInfoWnd:SelChangedProc(viewIndex, dataIndex, dataKey, doubleClick)
    local data = rightInfoWnd:GetData(dataKey, 1)
    if data.curCnt < data.maxCnt and data.charId > 0 then
      okButton.charId = data.charId
      okButton.charName = heroes.items[dataIndex].subItems[2]:GetText()
      okButton:Enable(true)
    else
      okButton:Enable(false)
    end
  end
  function window:FillData(checkData)
    if checkData and not X2Nation:CanGetRelationCount() then
      return
    end
    content:ClearItem()
    local relationList = X2Nation:GetRelationList(X2Faction:GetMyTopLevelFaction())
    if relationList ~= nil then
      local infos = {}
      for i = 1, #relationList do
        infos[i] = {}
        infos[i].text = relationList[i].name
        infos[i].value = relationList[i].factionId
        if relationList[i].relation == UR_HOSTILE and relationList[i].target then
          infos[i].defaultColor = FONT_COLOR.DEFAULT
          infos[i].selectColor = FONT_COLOR.BLUE
          infos[i].overColor = FONT_COLOR.BLUE
        else
          infos[i].value = 0
          infos[i].defaultColor = FONT_COLOR.GRAY
          infos[i].selectColor = FONT_COLOR.GRAY
          infos[i].overColor = FONT_COLOR.GRAY
        end
        infos[i].useColor = true
      end
      content:SetItemTrees(infos)
    end
    local myCnt, myMax = X2Nation:GetRelationCount(0)
    bottomCount:SetText(GetCommonText("faction_relation_request_apply_count", myCnt, myMax))
    heroes:FillData()
  end
  function window:OnShow()
    window:FillData(true)
    okButton:Enable(false)
  end
  window:FillData(true)
  window:SetHandler("OnShow", window.OnShow)
  return window
end
