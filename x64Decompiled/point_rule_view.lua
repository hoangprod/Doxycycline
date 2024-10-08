function CreatePointRuleView(wnd, anchorTarget)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local okBtn = wnd:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:SetText(GetCommonText("ok"))
  okBtn:AddAnchor("BOTTOM", wnd, 0, 0)
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  local moneyImg = wnd:CreateDrawable(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "img_moneybag", "background")
  moneyImg:AddAnchor("BOTTOMRIGHT", wnd, 0, -25)
  local emptyWnd = CreateEmptyWindow("emptyWnd", wnd)
  emptyWnd:Show(true)
  emptyWnd:SetExtent(wnd:GetWidth() - sideMargin * 2, 223)
  local tab = wnd:GetParent()
  tab:AnchorContent(emptyWnd)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.PREMIUM_SERVICE_GRADE_PROGRESS_BAR, "bg", "background")
  bg:SetExtent(emptyWnd:GetWidth(), emptyWnd:GetHeight())
  bg:AddAnchor("TOPLEFT", emptyWnd, 0, 0)
  local offsetX = 30
  local upgradeLabel = emptyWnd:CreateChildWidget("label", "upgradePoint", 0, true)
  upgradeLabel:SetHeight(FONT_SIZE.XXLARGE)
  upgradeLabel:SetAutoResize(true)
  upgradeLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  upgradeLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(upgradeLabel, FONT_COLOR.MIDDLE_TITLE)
  upgradeLabel:AddAnchor("TOPLEFT", emptyWnd, offsetX, 35)
  upgradeLabel:SetText(locale.premium.add_point)
  local upgradeTextbox = emptyWnd:CreateChildWidget("textbox", "upgradeTextbox", 0, true)
  ApplyTextColor(upgradeTextbox, FONT_COLOR.DEFAULT)
  upgradeTextbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  upgradeTextbox.style:SetAlign(ALIGN_LEFT)
  upgradeTextbox:SetWidth(emptyWnd:GetWidth() - offsetX)
  upgradeTextbox:AddAnchor("TOPLEFT", upgradeLabel, "BOTTOMLEFT", 0, 40)
  upgradeTextbox:SetText(locale.premium.premium_benefit_add_explan)
  upgradeTextbox:SetHeight(upgradeTextbox:GetTextHeight())
  local upgradeTextbox2 = emptyWnd:CreateChildWidget("textbox", "upgradeTextbox2", 0, true)
  ApplyTextColor(upgradeTextbox2, FONT_COLOR.GRAY)
  upgradeTextbox2.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  upgradeTextbox2.style:SetAlign(ALIGN_LEFT)
  upgradeTextbox2:SetWidth(emptyWnd:GetWidth() - offsetX)
  upgradeTextbox2:AddAnchor("TOPLEFT", upgradeTextbox, "BOTTOMLEFT", 0, 50)
  upgradeTextbox2:SetText(locale.premium.premium_benefit_minus_explan)
  upgradeTextbox2:SetHeight(upgradeTextbox2:GetTextHeight())
  function wnd:GetContentHeight()
    return emptyWnd:GetHeight() + okBtn:GetHeight() + sideMargin
  end
end
