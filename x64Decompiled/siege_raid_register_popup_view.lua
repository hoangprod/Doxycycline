local CreateEmptyWnd = function(id, parent, key, bgColor)
  local emptyWnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = emptyWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, key, "background")
  bg:SetTextureColor(bgColor)
  bg:AddAnchor("TOPLEFT", emptyWnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", emptyWnd, 0, 0)
  return emptyWnd
end
local CreateScrollListBox = function(id, parent, topWnd)
  local ctrlWnd = W_CTRL.CreateScrollListBox(id, parent, topWnd)
  ctrlWnd.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
  ctrlWnd.content.itemStyle:SetAlign(ALIGN_LEFT)
  ctrlWnd.content.itemStyleSub:SetFontSize(FONT_SIZE.MIDDLE)
  ctrlWnd.content:SetHeight(FONT_SIZE.MIDDLE)
  ctrlWnd.content:ShowTooltip(false)
  ctrlWnd.content:SetTreeTypeIndent(true, 20, 10)
  ctrlWnd.content:SetSubTextOffset(20, 0, false)
  return ctrlWnd
end
local function CreateDominionInfoWnd(parent, anchor)
  local data = CreateWithPreset(WINDOW_MODULE_PRESET.TITLE_BOX.TYPE1, {
    title = locale.siegeRaid.dominionsTitle,
    fix_width = 270,
    align = ALIGN_LEFT,
    body_inset = {
      3,
      0,
      7,
      0
    }
  })
  local infoWnd = W_MODULE:Create("dominionInfoWnd", parent, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  infoWnd:AddAnchor("TOPLEFT", anchor, "BOTTOMLEFT", -45, 10)
  local dominionList = CreateScrollListBox("dominionList", infoWnd, parent)
  dominionList:SetExtent(260, 360)
  dominionList.bg:SetVisible(false)
  infoWnd:AddBody(dominionList)
  return infoWnd
end
local CreateRegisterListItems = function(listWnd)
  if listWnd == nil then
    return
  end
  for i = 1, #listWnd.items do
    listWnd.items[i].subItems[1]:SetLimitWidth(true)
    listWnd.items[i].subItems[1].style:SetAlign(ALIGN_CENTER)
    listWnd.items[i].subItems[1].style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(listWnd.items[i].subItems[1], FONT_COLOR.DEFAULT)
    listWnd.items[i].subItems[1]:SetText("")
    local commanderBg = listWnd.items[i].subItems[1]:CreateDrawable(TEXTURE_PATH.SIEGE_RAID, "icon_commander", "background")
    commanderBg:AddAnchor("CENTER", listWnd.items[i].subItems[1], 0, 0)
    commanderBg:SetVisible(false)
    listWnd.items[i].subItems[1].commanderBg = commanderBg
    local gradeBg = listWnd.items[i].subItems[2]:CreateDrawable(TEXTURE_PATH.SIEGE_RAID, "level_03", "background")
    gradeBg:AddAnchor("CENTER", listWnd.items[i].subItems[2], 0, 0)
    gradeBg:SetVisible(false)
    listWnd.items[i].subItems[2].gradeBg = gradeBg
    listWnd.items[i].subItems[3]:SetLimitWidth(true)
    listWnd.items[i].subItems[3]:SetInset(5, 0, 0, 0)
    listWnd.items[i].subItems[3].style:SetAlign(ALIGN_LEFT)
    listWnd.items[i].subItems[3].style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(listWnd.items[i].subItems[3], FONT_COLOR.DEFAULT)
    listWnd.items[i].subItems[3]:SetText("")
  end
end
local function CreateRegisterInfoWnd(parent, anchor)
  local data = CreateWithPreset(WINDOW_MODULE_PRESET.TITLE_BOX.TYPE1, {
    title = locale.siegeRaid.registersTitle,
    fix_width = 485,
    body_inset = {
      0,
      0,
      0,
      7
    }
  })
  local infoWnd = W_MODULE:Create("registerInfoWnd", parent, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  infoWnd:AddAnchor("TOPRIGHT", anchor, "BOTTOMRIGHT", 45, 10)
  local registerlistCtrl = W_CTRL.CreateListCtrl("registerlistCtrl", infoWnd)
  registerlistCtrl:RemoveAllAnchors()
  registerlistCtrl:SetExtent(485, 216)
  registerlistCtrl:InsertColumn(113, LCCIT_STRING)
  registerlistCtrl.column[1]:SetText(locale.siegeRaid.reserveState)
  registerlistCtrl:InsertColumn(87, LCCIT_WINDOW)
  registerlistCtrl.column[2]:SetText(locale.siegeRaid.heroGrade)
  registerlistCtrl:InsertColumn(285, LCCIT_CHARACTER_NAME)
  registerlistCtrl.column[3]:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "name"))
  registerlistCtrl:InsertRows(6, false)
  registerlistCtrl:DisuseSorting()
  DrawListCtrlUnderLine(registerlistCtrl)
  registerlistCtrl:UseOverClickTexture()
  for i = 1, #registerlistCtrl.column do
    SettingListColumn(registerlistCtrl, registerlistCtrl.column[i])
    registerlistCtrl.column[i].style:SetFontSize(FONT_SIZE.MIDDLE)
    DrawListCtrlColumnSperatorLine(registerlistCtrl.column[i], #registerlistCtrl.column, i)
  end
  CreateRegisterListItems(registerlistCtrl)
  infoWnd:AddBody(registerlistCtrl, false)
  local emptyText = infoWnd:CreateChildWidget("label", "emptyRegisterList", 0, true)
  emptyText:SetExtent(485, FONT_SIZE.LARGE)
  emptyText:AddAnchor("TOP", registerlistCtrl, 0, 95)
  emptyText.style:SetFontSize(FONT_SIZE.LARGE)
  emptyText.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(emptyText, FONT_COLOR.MIDDLE_TITLE)
  emptyText:SetText(locale.siegeRaid.registersEmptyDesc)
  emptyText:Show(false)
  local underLine = CreateLine(infoWnd, "TYPE1")
  local anchorInfo = {
    {
      myAnchor = "TOPLEFT",
      targetAnchor = "BOTTOMLEFT",
      x = 0,
      y = MARGIN.WINDOW_SIDE / 2
    },
    {
      myAnchor = "TOPRIGHT",
      targetAnchor = "BOTTOMRIGHT",
      x = 0,
      y = MARGIN.WINDOW_SIDE / 2
    }
  }
  infoWnd:AddBody(underLine, false, anchorInfo)
  local infoTextScrollWnd = CreateScrollWindow(infoWnd, "infoTextScrollWnd", 0)
  infoTextScrollWnd:SetExtent(462, 121)
  local infoTextBox = infoTextScrollWnd.content:CreateChildWidget("textbox", "infoTextBox", 0, true)
  infoTextBox:SetExtent(420, FONT_SIZE.MIDDLE)
  infoTextBox:AddAnchor("TOPLEFT", infoTextScrollWnd.content, 12, 0)
  infoTextBox.style:SetFontSize(FONT_SIZE.MIDDLE)
  infoTextBox.style:SetAlign(ALIGN_LEFT)
  infoTextBox:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  infoTextBox:SetAutoResize(true)
  ApplyTextColor(infoTextBox, FONT_COLOR.DEFAULT)
  infoTextBox:SetText(locale.siegeRaid.suggestionsDesc)
  infoTextScrollWnd:ResetScroll(infoTextBox:GetHeight() + 5)
  local anchorInfo = {
    {
      myAnchor = "TOPLEFT",
      targetAnchor = "BOTTOMLEFT",
      x = 0,
      y = 8
    },
    {
      myAnchor = "TOPRIGHT",
      targetAnchor = "BOTTOMRIGHT",
      x = 0,
      y = 8
    }
  }
  infoWnd:AddBody(infoTextScrollWnd, false, anchorInfo)
  return infoWnd
end
function SetViewOfSiegeRaidRegisterWnd(parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow("siegeRaidRegisterWnd", parent)
  wnd:SetExtent(800, 540)
  wnd:AddAnchor("CENTER", parent, 0, 0)
  wnd:SetTitle(locale.siegeRaid.registerWindowTitle)
  wnd:SetCloseOnEscape(true)
  local subTitle = wnd:CreateChildWidget("textbox", "subTitle", 0, true)
  subTitle:SetExtent(670, FONT_SIZE.MIDDLE)
  subTitle:AddAnchor("TOP", wnd, 0, 50)
  subTitle:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  subTitle:SetAutoResize(true)
  subTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  subTitle.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(subTitle, FONT_COLOR.DEFAULT)
  subTitle:SetText(locale.siegeRaid.notVolunteerPeriod)
  subTitle:Show(false)
  local dominionInfoWnd = CreateDominionInfoWnd(wnd, subTitle)
  local registerInfoWnd = CreateRegisterInfoWnd(wnd, subTitle)
  local registerBtn = wnd:CreateChildWidget("button", "registerBtn", 0, true)
  registerBtn:SetText(locale.siegeRaid.registerBtn)
  registerBtn:AddAnchor("TOPRIGHT", wnd, "BOTTOMRIGHT", -sideMargin, bottomMargin + 11)
  registerBtn:Enable(false)
  registerBtn:Show(true)
  ApplyButtonSkin(registerBtn, BUTTON_BASIC.DEFAULT)
  local unregisterBtn = wnd:CreateChildWidget("button", "unregisterBtn", 0, true)
  unregisterBtn:SetText(locale.siegeRaid.unregisterBtn)
  unregisterBtn:AddAnchor("TOPRIGHT", wnd, "BOTTOMRIGHT", -sideMargin, bottomMargin + 11)
  unregisterBtn:Enable(false)
  unregisterBtn:Show(false)
  ApplyButtonSkin(unregisterBtn, BUTTON_BASIC.DEFAULT)
  local remainTimeMsg = wnd:CreateChildWidget("textbox", "remainTimeMsg", 0, true)
  remainTimeMsg:SetExtent(340, FONT_SIZE.MIDDLE)
  remainTimeMsg:AddAnchor("RIGHT", registerBtn, "LEFT", -10, 0)
  remainTimeMsg.style:SetFontSize(FONT_SIZE.MIDDLE)
  remainTimeMsg.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(remainTimeMsg, FONT_COLOR.RED)
  remainTimeMsg:Show(false)
  wnd.remainTimeMsg = remainTimeMsg
  local tooltipIcon = W_ICON.CreateGuideIconWidget(wnd)
  tooltipIcon:AddAnchor("TOPLEFT", wnd.dominionInfoWnd, "BOTTOMLEFT", 0, 11)
  local tooltipText = wnd:CreateChildWidget("label", "tooltipText", 0, true)
  tooltipText:SetAutoResize(true)
  tooltipText:SetHeight(FONT_SIZE.MIDDLE)
  tooltipText.style:SetAlign(ALIGN_LEFT)
  tooltipText.style:SetFontSize(FONT_SIZE.MIDDLE)
  tooltipText:AddAnchor("LEFT", tooltipIcon, "RIGHT", 5, 0)
  tooltipText:SetText(locale.siegeRaid.scheduleText)
  ApplyTextColor(tooltipText, FONT_COLOR.DEFAULT)
  local tooltip = wnd:CreateChildWidget("label", "tooltip", 0, true)
  tooltip:AddAnchor("TOPLEFT", tooltipIcon, "TOPLEFT", 0, 0)
  tooltip:AddAnchor("BOTTOMRIGHT", tooltipText, "BOTTOMRIGHT", 0, 0)
  local OnEnter = function(self)
    SetTooltip(locale.siegeRaid.scheduleTooltip, self)
  end
  tooltip:SetHandler("OnEnter", OnEnter)
  local _, height = F_LAYOUT.GetExtentWidgets(wnd.titleBar, registerBtn)
  wnd:SetHeight(height + subTitle:GetHeight())
  return wnd
end
