local EXPEDITION_INTEREST_ITEM_MARGIN = 4
local EXPEDITION_BUFF_WIDTH = 430
local EXPEDITION_BUFF_HEIGHT = 500
local EXPEDITION_BUFF_ITEM_WIDTH = 369
local EXPEDITION_BUFF_ITEM_HEIGHT = 62
local EXPEDITION_BUFF_ITEM_TOTAL_HEIGHT = 322
local EXPEDITION_BUFF_ITEM_COUNT = 5
local EXPEDITION_GUIDE_WIDTH = 430
local EXPEDITION_GUIDE_HEIGHT = 548
local EXPEDITION_GUIDE_MAX = 5
local EXPEDITION_LEVELUP_WIDTH = 352
function SetViewOfExpeditionInfomationBuff(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local max_width = EXPEDITION_BUFF_WIDTH - sideMargin * 2
  local expedMgrWnd = parent:GetParent():GetParent()
  local window = CreateWindow(id .. ".buffWindow", expedMgrWnd)
  window:SetExtent(EXPEDITION_BUFF_WIDTH, EXPEDITION_BUFF_HEIGHT)
  window:SetTitle(GetCommonText("expedition_buff_title"))
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, 0, -20)
  window.okButton = okButton
  local ment = window:CreateChildWidget("textbox", "ment", 0, true)
  ment:SetAutoResize(true)
  ment:AddAnchor("BOTTOM", okButton, "TOP", 0, -20)
  ment:AddAnchor("LEFT", window, sideMargin + 20, 0)
  ment:AddAnchor("RIGHT", window, -sideMargin - 20, 0)
  ment.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(ment, FONT_COLOR.GRAY)
  ment:SetText(GetCommonText("expedition_buff_notice"))
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("TOPLEFT", ment, "TOPRIGHT", 0, 0)
  local GuideOnEnter = function(self)
    SetTooltip(GetCommonText("expedition_buff_in_game_content"), self)
  end
  guide:SetHandler("OnEnter", GuideOnEnter)
  local GuideOnLeave = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", GuideOnLeave)
  local buffList = W_CTRL.CreateScrollListCtrl("listCtrl", window)
  buffList.scroll:RemoveAllAnchors()
  buffList.scroll:AddAnchor("TOPRIGHT", buffList, 0, 0)
  buffList.scroll:AddAnchor("BOTTOMRIGHT", buffList, 0, 0)
  buffList.listCtrl:SetColumnHeight(0)
  buffList:SetExtent(EXPEDITION_BUFF_ITEM_WIDTH + 20, EXPEDITION_BUFF_ITEM_TOTAL_HEIGHT)
  buffList:AddAnchor("TOP", window, 0, 50)
  buffList:Show(true)
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      local levelStr = GetCommonText("expedition") .. " " .. GetCommonText("level") .. " : " .. tostring(data[7])
      local buffInfo = X2Ability:GetBuffTooltip(data[6][1], 1)
      subItem.levelIconTexture:SetTextureInfo(string.format("level_%02d", data[7]))
      subItem.levelIcon:Show(true)
      subItem.levelText:SetText(levelStr)
      subItem.levelText:Show(true)
      subItem.buff:Show(true)
      subItem.buff:SetTooltip(buffInfo)
      F_SLOT.SetIconBackGround(subItem.buff, buffInfo.path)
      if subItem.line ~= nil then
        subItem.line:Show(true)
      end
    else
      subItem.levelIcon:Show(false)
      subItem.levelText:Show(false)
      subItem.buff:Show(false)
      if subItem.line ~= nil then
        subItem.line:Show(false)
      end
    end
  end
  local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local levelIcon = subItem:CreateChildWidget("emptywidget", "levelIcon", 0, true)
    levelIcon:AddAnchor("TOPLEFT", subItem, 2, 2)
    levelIcon:AddAnchor("BOTTOM", subItem, 0, 0)
    local iconTexture = levelIcon:CreateDrawable(TEXTURE_PATH.EXPEDITION_GRADE, "level_01", "background")
    iconTexture:AddAnchor("CENTER", levelIcon, 0, 0)
    levelIcon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
    levelIcon:Show(false)
    subItem.levelIconTexture = iconTexture
    subItem.levelIcon = levelIcon
    local levelText = subItem:CreateChildWidget("label", "levelText", 0, true)
    levelText:SetHeight(FONT_SIZE.LARGE)
    levelText:SetAutoResize(true)
    levelText.style:SetAlign(ALIGN_LEFT)
    levelText.style:SetFontSize(FONT_SIZE.LARGE)
    levelText:AddAnchor("LEFT", levelIcon, "RIGHT", 5, 0)
    levelText:AddAnchor("TOP", subItem, 0, 24)
    levelText:SetText(GetCommonText("expedition") .. " " .. GetCommonText("level"))
    ApplyTextColor(levelText, FONT_COLOR.DEFAULT)
    levelText:Show(false)
    subItem.levelText = levelText
    local buff = CreateItemIconButton("buff", subItem)
    buff:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    buff:AddAnchor("TOPRIGHT", subItem, -19, 17)
    buff:AddAnchor("BOTTOM", subItem, 0, -17)
    buff:Show(false)
    F_SLOT.ApplySlotSkin(buff, buff.back, SLOT_STYLE.BUFF)
    subItem.buff = buff
    local buffDeco = buff:CreateDrawable(TEXTURE_PATH.HUD, "buff_deco", "overlay")
    buffDeco:SetTextureColor("buff")
    buffDeco:AddAnchor("BOTTOM", buff, 0, 0)
    if rowIndex ~= 1 then
      local line = CreateLine(subItem, "TYPE1")
      line:AddAnchor("TOPLEFT", subItem, 0, 0)
      line:AddAnchor("TOPRIGHT", subItem, 0, 0)
      subItem.line = line
    end
  end
  buffList:InsertColumn("", EXPEDITION_BUFF_ITEM_WIDTH, LCCIT_WINDOW, SetDataFunc, nil, nil, LayoutFunc)
  buffList:InsertRows(EXPEDITION_BUFF_ITEM_COUNT, false)
  local level_max = X2Faction:GetExpeditionMaxLevel()
  for i = 1, level_max do
    local info = X2Faction:GetExpeditionLevelInfo(i)
    local buff = info[6]
    if buff ~= nil and #buff > 0 then
      info[7] = i
      buffList:InsertData(i, 1, info)
    end
  end
  return window
end
function SetViewOfExpeditionInfomationGuide(id, parent)
  EXPEDITION_WINDOW = {
    {
      title = "expedition_guide_title_1",
      content = "expedition_guide_content_1"
    },
    {
      line = true,
      title = "expedition_guide_title_2",
      content = "expedition_guide_content_2",
      subcontent = "expedition_guide_content_2a"
    },
    {
      title = "expedition_guide_title_3",
      content = "expedition_guide_content_3"
    },
    {
      title = "expedition_guide_title_4",
      content = "expedition_guide_content_4"
    },
    {
      title = "expedition_guide_title_5",
      content = "expedition_guide_content_5"
    }
  }
  return CreateInfomationGuideWindow(id, parent, "expedition_guide_title", EXPEDITION_WINDOW)
end
function SetViewOfExpeditionInfomationLevelUp(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local max_width = EXPEDITION_LEVELUP_WIDTH - sideMargin * 2
  local expedMgrWnd = parent:GetParent():GetParent()
  local window = CreateWindow(id .. ".levelUpWindow", expedMgrWnd)
  window:SetWidth(EXPEDITION_LEVELUP_WIDTH)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_levelup_title"))
  local ment1 = window:CreateChildWidget("label", "ment1", 0, true)
  ment1:SetAutoResize(true)
  ment1:SetHeight(FONT_SIZE.LARGE)
  ment1.style:SetFontSize(FONT_SIZE.LARGE)
  ment1:AddAnchor("TOP", window, 0, 50)
  ment1.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(ment1, FONT_COLOR.DEFAULT)
  ment1:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_levelup_question"))
  windowHeight = 50 + ment1:GetHeight()
  local midWin = window:CreateChildWidget("emptywidget", "midWin", 0, true)
  midWin:SetWidth(316)
  midWin:AddAnchor("TOP", ment1, "BOTTOM", 0, 15)
  local midBg = CreateContentBackground(midWin, "TYPE2", "orange")
  midBg:AddAnchor("TOPLEFT", midWin, 0, 0)
  midBg:AddAnchor("BOTTOMRIGHT", midWin, 0, 0)
  windowHeight = windowHeight + 15
  local ment2 = midWin:CreateChildWidget("label", "ment2", 0, true)
  ment2:SetAutoResize(true)
  ment2:SetHeight(FONT_SIZE.MIDDLE)
  ment2.style:SetFontSize(FONT_SIZE.MIDDLE)
  ment2:AddAnchor("TOP", midWin, 0, 10)
  ment2.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(ment2, FONT_COLOR.DEFAULT)
  ment2:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_levelup_info_title"))
  midHeight = 10 + ment2:GetHeight()
  local ment3 = midWin:CreateChildWidget("textbox", "ment3", 0, true)
  ment3:SetAutoResize(true)
  ment3:SetHeight(FONT_SIZE.MIDDLE)
  ment3:SetWidth(316)
  ment3.style:SetFontSize(FONT_SIZE.MIDDLE)
  ment3:AddAnchor("TOP", ment2, "BOTTOM", 0, 13)
  ment3.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(ment3, FONT_COLOR.DEFAULT)
  ment3:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_levelup_info"))
  midHeight = midHeight + 13 + ment3:GetHeight() + 10
  local buffArrow = W_ICON.CreateArrowIcon(midWin)
  local heightDiff = 0
  midWin.buffHeight = buffArrow:GetHeight()
  if midWin.buffHeight < ICON_SIZE.APPELLAITON then
    heightDiff = ICON_SIZE.APPELLAITON - midWin.buffHeight
    midWin.buffHeight = ICON_SIZE.APPELLAITON
  end
  buffArrow:AddAnchor("TOP", ment3, "BOTTOM", -3, 13 + heightDiff / 2)
  buffArrow:Show(false)
  window.buffArrow = buffArrow
  midWin.buffHeight = midWin.buffHeight + 13
  local prevBuff = CreateItemIconButton(window:GetId() .. ".prevBuff", window)
  prevBuff:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
  prevBuff:AddAnchor("RIGHT", buffArrow, "LEFT", 0, 0)
  prevBuff:Show(false)
  F_SLOT.ApplySlotSkin(prevBuff, prevBuff.back, SLOT_STYLE.BUFF)
  window.prevBuff = prevBuff
  local prevBuffDeco = prevBuff:CreateDrawable(TEXTURE_PATH.HUD, "buff_deco", "overlay")
  prevBuffDeco:SetTextureColor("buff")
  prevBuffDeco:AddAnchor("BOTTOM", prevBuff, 0, 0)
  local nextBuff = CreateItemIconButton(window:GetId() .. ".nextBuff", window)
  nextBuff:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
  nextBuff:AddAnchor("LEFT", buffArrow, "RIGHT", 6, 0)
  nextBuff:Show(false)
  F_SLOT.ApplySlotSkin(nextBuff, nextBuff.back, SLOT_STYLE.BUFF)
  window.nextBuff = nextBuff
  local nextBuffDeco = nextBuff:CreateDrawable(TEXTURE_PATH.HUD, "buff_deco", "overlay")
  nextBuffDeco:SetTextureColor("buff")
  nextBuffDeco:AddAnchor("BOTTOM", nextBuff, 0, 0)
  midWin.midHeight = midHeight
  midWin:SetHeight(midHeight)
  local levelUpItem = CreateItemIconButton(window:GetId() .. ".levelUpItem", window)
  levelUpItem:AddAnchor("TOP", midWin, "BOTTOM", 0, 15)
  levelUpItem:Show(false)
  local info = {
    fontSize = FONT_SIZE.MIDDLE,
    anchorPoint = "BOTTOM",
    x = 0,
    y = -9
  }
  levelUpItem:LayoutStack(info)
  window.levelUpItem = levelUpItem
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, -(okButton:GetWidth() / 2 + 2), -20)
  window.okButton = okButton
  local cancelButton = window:CreateChildWidget("button", "cancelButton", 0, false)
  cancelButton:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOM", window, cancelButton:GetWidth() / 2 + 2, -20)
  window.cancelButton = cancelButton
  windowHeight = windowHeight + 15 + 20 + okButton:GetHeight() + midHeight
  window.windowHeight = windowHeight
  window:SetHeight(windowHeight)
  return window
end
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreateExpeditionWarHistoryListCtrl = function(id, parent)
  local widget = CreatePageListCtrl(parent, id, 0)
  widget:Show(true)
  widget:SetExtent(388, 400)
  widget.listCtrl.AscendingSortMark:SetColor(1, 1, 1, 0.5)
  widget.listCtrl.DescendingSortMark:SetColor(1, 1, 1, 0.5)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local ResultDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data == "win" then
        ApplyTextColor(subItem, FONT_COLOR.BLUE)
      elseif data == "lose" then
        ApplyTextColor(subItem, FONT_COLOR.RED)
      else
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
      subItem:SetText(X2Locale:LocalizeUiText(INSTANT_GAME_TEXT, data))
    else
      subItem:SetText("")
    end
  end
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local NameLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem:SetInset(16, 0, 16, 0)
    subItem.style:SetEllipsis(true)
  end
  local LayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  widget:InsertColumn(X2Locale:LocalizeUiText(NATION_TEXT, "expedition"), 231, LCCIT_STRING, NameDataSetFunc, nil, nil, NameLayoutSetFunc)
  widget:InsertColumn(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_war_result"), 76, LCCIT_STRING, ResultDataSetFunc, nil, LayoutSetFunc)
  widget:InsertColumn(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_war_start_date"), 81, LCCIT_STRING, DataSetFunc, nil, nil, LayoutSetFunc)
  widget:InsertRows(14, false)
  DrawListCtrlUnderLine(widget.listCtrl)
  local SettingListColumn = function(listCtrl, column)
    listCtrl:SetColumnHeight(LIST_COLUMN_HEIGHT)
    column.style:SetShadow(false)
    column.style:SetFontSize(FONT_SIZE.LARGE)
    SetButtonFontColor(column, GetTitleButtonFontColor())
  end
  for i = 1, #widget.listCtrl.column do
    SettingListColumn(widget.listCtrl, widget.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(widget.listCtrl.column[i], #widget.listCtrl.column, i)
  end
  return widget
end
function CreateExpeditionWarHistory(id, parent)
  local window = CreateWindow(id .. ".expeditionWarHistory", parent)
  window:SetExtent(430, 556)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "expedition_war_history"))
  window:AddAnchor("CENTER", parent, 0, 0)
  local history = CreateExpeditionWarHistoryListCtrl("expeditionWarHistoryListCtrl", window)
  history:AddAnchor("TOP", window, 0, 50)
  window.history = history
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, 0, -20)
  window.okButton = okButton
  ListCtrlItemGuideLine(history.listCtrl.items, 15)
  function history:OnPageChangedProc(pageIndex)
    local viewCount = self:GetVisibleItemCountCurrentPage()
    for i = 1, self:GetRowCount() do
      local item = history.listCtrl.items[i]
      item.line:SetVisible(false)
    end
    for i = 1, viewCount do
      local item = history.listCtrl.items[i]
      item.line:SetVisible(true)
    end
  end
  function window:FillResult(result)
    history:DeleteAllDatas()
    history:UpdatePage(#result, 14)
    for i = 1, #result do
      history:InsertData(i, 1, result[i].name)
      history:InsertData(i, 2, result[i].result)
      if result[i].today then
        history:InsertData(i, 3, string.format("%d:%d", result[i].hour, result[i].min))
      else
        history:InsertData(i, 3, string.format("%d. %d. %d", result[i].year, result[i].month, result[i].day))
      end
    end
    for i = 1, #history.listCtrl.items do
      local item = history.listCtrl.items[i]
      item.line:SetVisible(true)
    end
    window:Show(true)
  end
  function window:OnHide()
    window:Show(false)
  end
  return window
end
