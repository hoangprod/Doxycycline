function CreateMenuWnd(id, parent)
  local wnd = CreateEmptyWindow(id, parent)
  local buttonOffset = 10
  local wndHeight = 0
  local wndWidth = 0
  local tooltip = CreateInfoTooltip("tooltip", wnd, 0)
  local exitBtn = wnd:CreateChildWidget("button", "exitBtn", 0, true)
  exitBtn:AddAnchor("TOPRIGHT", wnd, 0, 0)
  ApplyButtonSkin(exitBtn, BUTTON_STYLE.LOGIN_STAGE_EXIT)
  wndHeight = math.max(wndHeight, exitBtn:GetHeight())
  wndWidth = wndWidth + exitBtn:GetWidth()
  local lastBtn = exitBtn
  function exitBtn:OnClick()
    X2World:LeaveGame()
  end
  exitBtn:SetHandler("OnClick", exitBtn.OnClick)
  function exitBtn:OnEnter()
    tooltip:ClearLines()
    tooltip:AddLine(GetUIText(LOGIN_TEXT, "connectExit"), "", 0, "left", ALIGN_LEFT, 0)
    tooltip:AddAnchor("TOPRIGHT", self, "BOTTOM", 0, 5)
    tooltip:Show(true)
  end
  exitBtn:SetHandler("OnEnter", exitBtn.OnEnter)
  function exitBtn:OnLeave()
    tooltip:Show(false)
  end
  exitBtn:SetHandler("OnLeave", exitBtn.OnLeave)
  local optionBtn = wnd:CreateChildWidget("button", "optionBtn", 0, true)
  optionBtn:AddAnchor("RIGHT", lastBtn, "LEFT", -buttonOffset, 0)
  ApplyButtonSkin(optionBtn, BUTTON_STYLE.LOGIN_STAGE_OPTION)
  wndHeight = math.max(wndHeight, optionBtn:GetHeight())
  wndWidth = wndWidth + optionBtn:GetWidth() + buttonOffset
  lastBtn = optionBtn
  function optionBtn:OnClick()
    ToggleOptionFrame()
  end
  optionBtn:SetHandler("OnClick", optionBtn.OnClick)
  function optionBtn:OnEnter()
    tooltip:ClearLines()
    tooltip:AddLine(GetUIText(OPTION_TEXT, "option"), "", 0, "left", ALIGN_LEFT, 0)
    tooltip:AddAnchor("TOPRIGHT", self, "BOTTOM", 0, 5)
    tooltip:Show(true)
  end
  optionBtn:SetHandler("OnEnter", optionBtn.OnEnter)
  function optionBtn:OnLeave()
    tooltip:Show(false)
  end
  optionBtn:SetHandler("OnLeave", optionBtn.OnLeave)
  wnd:SetExtent(wndWidth, wndHeight)
  return wnd
end
