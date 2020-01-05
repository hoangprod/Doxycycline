function CreateCharacterSelectQueueWindow(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetExtent(1000, 100)
  wnd:AddAnchor("CENTER", parent, 0, 0)
  wnd:Clickable(false)
  local userTypeText = wnd:CreateChildWidget("textbox", "userTypeText", 0, true)
  userTypeText:SetExtent(500, FONT_SIZE.XXLARGE)
  userTypeText:AddAnchor("TOP", wnd, 0, MARGIN.WINDOW_SIDE)
  userTypeText.style:SetAlign(ALIGN_CENTER)
  userTypeText.style:SetSnap(true)
  userTypeText.style:SetShadow(true)
  userTypeText.style:SetFontSize(FONT_SIZE.XXLARGE)
  ApplyTextColor(userTypeText, F_COLOR.GetColor("white"))
  local normalLengthText = wnd:CreateChildWidget("textbox", "normalLengthText", 0, true)
  normalLengthText:SetExtent(500, FONT_SIZE.XLARGE)
  normalLengthText:AddAnchor("TOP", userTypeText, "BOTTOM", 0, 10)
  normalLengthText.style:SetAlign(ALIGN_CENTER)
  normalLengthText.style:SetSnap(true)
  normalLengthText.style:SetShadow(true)
  normalLengthText.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(normalLengthText, F_COLOR.GetColor("white"))
  local premiumLengthText = wnd:CreateChildWidget("textbox", "premiumLengthText", 0, true)
  premiumLengthText:SetExtent(500, FONT_SIZE.XLARGE)
  premiumLengthText:AddAnchor("TOP", normalLengthText, "BOTTOM", 0, 5)
  premiumLengthText.style:SetAlign(ALIGN_CENTER)
  premiumLengthText.style:SetSnap(true)
  premiumLengthText.style:SetShadow(true)
  premiumLengthText.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(premiumLengthText, F_COLOR.GetColor("white"))
  local waitingRemain = wnd:CreateChildWidget("textbox", "waitingRemain", 0, true)
  waitingRemain:SetExtent(500, FONT_SIZE.XLARGE)
  waitingRemain:AddAnchor("TOP", premiumLengthText, "BOTTOM", 0, 5)
  waitingRemain.style:SetAlign(ALIGN_CENTER)
  waitingRemain.style:SetSnap(true)
  waitingRemain.style:SetShadow(true)
  waitingRemain.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(waitingRemain, F_COLOR.GetColor("white"))
  local noticeBox = wnd:CreateChildWidget("textbox", "noticeBox", 0, true)
  noticeBox:SetExtent(500, FONT_SIZE.LARGE)
  noticeBox:SetAutoResize(true)
  noticeBox:AddAnchor("TOP", waitingRemain, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  noticeBox.style:SetAlign(ALIGN_LEFT)
  noticeBox.style:SetSnap(true)
  noticeBox.style:SetShadow(true)
  noticeBox.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(noticeBox, F_COLOR.GetColor("sky"))
  function wnd:UpdateWaitingInfo()
    local isPremiumUser = X2LoginCharacter:IsInPremiumQueue()
    local normalLength = X2LoginCharacter:GetWorldNormalQueueLength()
    local premiumLength = X2LoginCharacter:GetWorldPremiumQueueLength()
    local remainLength = X2LoginCharacter:GetWorldQueuePosition()
    local remainTime = X2LoginCharacter:GetWorldQueueExpectedTime()
    local premiumUserType = GetCommonText("premiumUserType")
    local normalUserType = GetCommonText("normalUserType")
    local color = F_COLOR.GetColor("orange", true)
    userTypeText:SetText(GetCommonText("userTypeText", isPremiumUser and premiumUserType or normalUserType, string.format("%s%s|r", color, tostring(remainLength))))
    normalLengthText:SetText(GetCommonText("waitingUserCount", normalUserType, string.format("%s|,%d;|r", color, normalLength)))
    premiumLengthText:SetText(GetCommonText("waitingUserCount", premiumUserType, string.format("%s|,%d;|r", color, premiumLength)))
    local timeStr
    if remainTime > 0 then
      local time = math.floor(remainTime / 60)
      local minute = time % 60
      time = math.floor(time / 60)
      local hour = time % 24
      time = math.floor(time / 24)
      local day = time
      local filter = FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR + FORMAT_FILTER.MINUTE
      local tStr = locale.time.GetRemainDate(0, 0, day, hour, minute, 0, filter)
      timeStr = GetCommonText("waiting_remainTime_text", string.format("%s%s|r", F_COLOR.GetColor("original_dark_orange", true), tStr))
    else
      timeStr = GetCommonText("waiting_remainTime_calculating_text")
    end
    waitingRemain:SetText(timeStr)
    local noticeStr = GetCommonText("world_waiting_queue_notice")
    local noticeNum = 1
    local usePremium = X2LoginCharacter:UsePremiumEntrance()
    if usePremium then
      userTypeText:Show(true)
      normalLengthText:Show(true)
      premiumLengthText:Show(true)
      waitingRemain:Show(true)
      waitingRemain:AddAnchor("TOP", premiumLengthText, "BOTTOM", 0, 5)
      noticeStr = string.format([[
%s
%d.%s]], noticeStr, noticeNum, GetCommonText("world_waiting_queue_notice_1"))
      noticeNum = noticeNum + 1
    else
      userTypeText:Show(true)
      normalLengthText:Show(false)
      premiumLengthText:Show(false)
      waitingRemain:Show(true)
      waitingRemain:AddAnchor("TOP", userTypeText, "BOTTOM", 0, 10)
    end
    noticeStr = string.format([[
%s
%d.%s]], noticeStr, noticeNum, GetCommonText("world_waiting_queue_notice_2"))
    noticeBox:SetText(noticeStr)
    local _, height = F_LAYOUT.GetExtentWidgets(userTypeText, noticeBox)
    wnd:SetHeight(height + MARGIN.WINDOW_SIDE * 2)
  end
  return wnd
end
