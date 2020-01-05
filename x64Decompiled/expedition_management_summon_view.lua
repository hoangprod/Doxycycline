function SetViewOfExpeditionSummon(id, parent)
  local wnd = CreateWindow(id, parent)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, 360)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetCommonText("expedition_summon"))
  local width = wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local question = wnd:CreateChildWidget("textbox", "question", 0, true)
  question:SetExtent(width, FONT_SIZE.LARGE)
  question:SetAutoResize(true)
  question.style:SetFontSize(FONT_SIZE.LARGE)
  question:SetText(GetCommonText("expedition_summon_question"))
  question:AddAnchor("TOP", wnd, 0, MARGIN.WINDOW_TITLE)
  ApplyTextColor(question, FONT_COLOR.TITLE)
  local notice = wnd:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetExtent(width, wnd:GetHeight())
  notice:SetAutoResize(true)
  notice:SetText(GetCommonText("expedition_summon_notice"))
  notice:AddAnchor("TOP", question, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  ApplyTextColor(notice, FONT_COLOR.MEDIUM_BROWN)
  midWnd = CreateEmptyWindow("midWnd", wnd)
  midWnd:SetExtent(width, 140)
  midWnd:AddAnchor("TOP", notice, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  local bg = CreateContentBackground(midWnd, "TYPE7", "brown")
  bg:AddAnchor("TOPLEFT", midWnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", midWnd, 0, 0)
  local tryCount = wnd:CreateChildWidget("textbox", "tryCount", 0, true)
  tryCount:SetExtent(width, wnd:GetHeight())
  tryCount:SetAutoResize(true)
  tryCount.style:SetFontSize(FONT_SIZE.XLARGE)
  tryCount:AddAnchor("TOP", bg, "TOP", 0, 25)
  ApplyTextColor(tryCount, FONT_COLOR.TITLE)
  wnd.itemIcon = CreateItemIconButton("itemIcon", wnd)
  wnd.itemIcon:AddAnchor("TOP", tryCount, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  CreateWindowDefaultTextButtonSet(wnd)
  local _, height = F_LAYOUT.GetExtentWidgets(wnd.titleBar, midWnd)
  height = height + wnd.leftButton:GetHeight() + -BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM
  wnd:SetHeight(height)
  return wnd
end
function SetViewOfExpeditionSummonSuggest(id, parent)
  local wnd = CreateWindow(id, parent)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, 390)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetCommonText("expedition_summon"))
  local width = wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local question = wnd:CreateChildWidget("textbox", "question", 0, true)
  question:SetExtent(width, FONT_SIZE.LARGE)
  question:SetHeight(FONT_SIZE.LARGE)
  question:SetAutoResize(true)
  question.style:SetFontSize(FONT_SIZE.LARGE)
  question:SetText(GetCommonText("expedition_summon_move"))
  question:AddAnchor("TOP", wnd, 0, MARGIN.WINDOW_TITLE)
  ApplyTextColor(question, FONT_COLOR.TITLE)
  local notice = wnd:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetExtent(width, FONT_SIZE.MIDDLE)
  notice:SetAutoResize(true)
  notice:SetText(GetCommonText("expedition_summon_notice"))
  notice:AddAnchor("TOP", question, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  ApplyTextColor(notice, FONT_COLOR.MEDIUM_BROWN)
  midWnd = CreateEmptyWindow("mid", wnd)
  midWnd:SetExtent(width, 125)
  midWnd:AddAnchor("TOP", notice, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  local bg = CreateContentBackground(midWnd, "TYPE7", "brown")
  bg:AddAnchor("TOPLEFT", midWnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", midWnd, 0, 0)
  local midWidth = width - MARGIN.WINDOW_SIDE
  local summoner = wnd:CreateChildWidget("textbox", "summoner", 0, true)
  summoner:SetExtent(midWidth, FONT_SIZE.XLARGE)
  summoner:SetAutoResize(true)
  summoner.style:SetFontSize(FONT_SIZE.LARGE)
  summoner.style:SetAlign(ALIGN_LEFT)
  summoner:AddAnchor("TOPLEFT", midWnd, 10, MARGIN.WINDOW_SIDE)
  ApplyTextColor(summoner, FONT_COLOR.TITLE)
  local location = wnd:CreateChildWidget("label", "location", 0, true)
  location:SetExtent(30, FONT_SIZE.LARGE)
  location:SetAutoResize(true)
  location.style:SetFontSize(FONT_SIZE.LARGE)
  location.style:SetAlign(ALIGN_LEFT)
  location:SetText(string.format("%s: ", GetCommonText("location")))
  location:AddAnchor("TOPLEFT", summoner, "BOTTOMLEFT", 0, 7)
  ApplyTextColor(location, FONT_COLOR.TITLE)
  local locationLabel = wnd:CreateChildWidget("label", "locationLabel", 0, true)
  locationLabel:SetExtent(midWidth - location:GetWidth(), FONT_SIZE.LARGE)
  locationLabel.style:SetFontSize(FONT_SIZE.LARGE)
  locationLabel.style:SetAlign(ALIGN_LEFT)
  locationLabel.style:SetEllipsis(true)
  locationLabel:AddAnchor("LEFT", location, "RIGHT", 2, 0)
  ApplyTextColor(locationLabel, FONT_COLOR.BLUE)
  local mapBtn = wnd:CreateChildWidget("button", "mapBtn", 0, true)
  mapBtn:AddAnchor("BOTTOM", midWnd, 0, -MARGIN.WINDOW_SIDE)
  mapBtn:SetText(GetCommonText("look_map"))
  ApplyButtonSkin(mapBtn, BUTTON_BASIC.DEFAULT)
  local remainTime = wnd:CreateChildWidget("textbox", "remainTime", 0, true)
  remainTime:SetExtent(width, FONT_SIZE.MIDDLE)
  remainTime:AddAnchor("TOP", mapBtn, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  ApplyTextColor(remainTime, FONT_COLOR.BLUE)
  local checkBtn = CreateCheckButton("checkBtn", wnd, GetCommonText("expedition_summon_not_open"))
  ApplyTextColor(checkBtn.textButton, FONT_COLOR.TITLE)
  checkBtn:AddAnchor("BOTTOM", wnd, -(checkBtn.textButton:GetWidth() / 2), BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  wnd.checkBtn = checkBtn
  local infos = {
    buttonBottomInset = -(checkBtn:GetWidth() + MARGIN.WINDOW_SIDE * 1.7)
  }
  CreateWindowDefaultTextButtonSet(wnd, infos)
  local _, height = F_LAYOUT.GetExtentWidgets(wnd.titleBar, remainTime)
  height = height + wnd.leftButton:GetHeight() + checkBtn:GetHeight() + -BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM + MARGIN.WINDOW_SIDE * 1.3
  wnd:SetHeight(height)
  return wnd
end
