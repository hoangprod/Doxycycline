function CreateWorldQueueWindow(id, worldList)
  local window = CreateWindow(id, "UIParent")
  window:Show(false)
  window:SetExtent(POPUP_WINDOW_WIDTH, 185)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetUILayer("dialog")
  window:SetTitle(GetUIText(SERVER_TEXT, "titleWaitingToEnter"))
  window.titleBar.closeButton:Show(false)
  window.titleBar:Clickable(false)
  window:SetWindowModal(true)
  local commonWidth = window:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local upperText = window:CreateChildWidget("label", "upperText", 0, true)
  upperText:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  upperText:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  ApplyTextColor(upperText, FONT_COLOR.DEFAULT)
  local waitingOrder = window:CreateChildWidget("label", "waitingOrder", 0, true)
  waitingOrder:SetExtent(commonWidth, FONT_SIZE.LARGE)
  waitingOrder:AddAnchor("TOP", upperText, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
  waitingOrder.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(waitingOrder, FONT_COLOR.RED)
  local waitingTime = window:CreateChildWidget("label", "waitingTime", 0, true)
  waitingTime:SetExtent(commonWidth, FONT_SIZE.LARGE)
  waitingTime:AddAnchor("TOP", waitingOrder, "BOTTOM", 0, 5)
  waitingTime.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(waitingTime, FONT_COLOR.RED)
  local infos = {
    leftButtonStr = GetUIText(SERVER_TEXT, "cancelWait"),
    rightButtonStr = GetUIText(KEY_BINDING_TEXT, "config_game_exit"),
    leftButtonLeftClickFunc = function()
      X2LoginCharacter:CancelWorldQueue()
      worldList:RefreshServerList()
      window:Show(false)
    end,
    rightButtonLeftClickFunc = function()
      X2World:LeaveGame()
    end
  }
  CreateWindowDefaultTextButtonSet(window, infos)
  function window:SetInfo(serverName)
    local expected = X2LoginCharacter:GetWorldQueueExpectedTime()
    local timeString = ""
    if expected < 0 then
      timeString = GetUIText(SERVER_TEXT, "timeCalculating")
    elseif expected < 60 then
      timeString = GetUIText(SERVER_TEXT, "timeBelowOneMinute")
    elseif expected < 3600 then
      timeString = GetUIText(SERVER_TEXT, "paramTimeAboutMinutes", tostring(math.ceil(expected / 60)))
    else
      timeString = GetUIText(SERVER_TEXT, "timeAboveOneHour")
    end
    upperText:SetText(GetUIText(SERVER_TEXT, "GetGuideText", tostring(serverName)))
    waitingOrder:SetText(string.format("%s: %d", GetUIText(COMMON_TEXT, "waiting_order"), X2LoginCharacter:GetWorldQueuePosition()))
    waitingTime:SetText(GetUIText(SERVER_TEXT, "expectedWaitingTime", timeString))
  end
  return window
end
