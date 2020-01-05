MOBILIZATION_ORDER_RESULT = {
  ACCEPT = 1,
  CANCEL = 2,
  TIME_OVER = 3
}
function SetViewOfMobilizationOrder(id, parent)
  local width = POPUP_WINDOW_WIDTH
  local height = 350
  local window = CreateWindow(id, parent)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetExtent(width, height)
  window:SetTitle(GetCommonText("mobilization_order"))
  window:Show(true)
  local heroName = window:CreateChildWidget("textbox", "heroName", 0, true)
  heroName.style:SetAlign(ALIGN_CENTER)
  heroName:AddAnchor("TOP", window, "TOP", 0, 50)
  heroName:SetExtent(window:GetWidth(), DEFAULT_SIZE.EDIT_HEIGHT)
  heroName.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(heroName, FONT_COLOR.BLUE)
  local question = window:CreateChildWidget("textbox", "question", 0, true)
  question.style:SetAlign(ALIGN_CENTER)
  question:AddAnchor("TOP", heroName, "BOTTOM", 0, 10)
  question:SetWidth(1000)
  question:SetText(GetCommonText("mobilization_order_question"))
  question:SetExtent(window:GetWidth() - MARGIN.WINDOW_SIDE * 2, question:GetTextHeight())
  ApplyTextColor(question, FONT_COLOR.DEFAULT)
  local condition = window:CreateChildWidget("textbox", "condition", 0, true)
  condition.style:SetAlign(ALIGN_CENTER)
  condition:AddAnchor("TOP", question, "BOTTOM", 0, 25)
  condition:SetExtent(window:GetWidth(), DEFAULT_SIZE.EDIT_HEIGHT)
  ApplyTextColor(condition, FONT_COLOR.DEFAULT)
  local conditionBg = CreateContentBackground(condition, "TYPE7", "brown")
  conditionBg:SetExtent(window:GetWidth() - 40, 80)
  conditionBg:AddAnchor("CENTER", condition, 0, 5)
  local remainTime = window:CreateChildWidget("textbox", "remainTime", 0, true)
  remainTime.style:SetAlign(ALIGN_CENTER)
  remainTime:AddAnchor("TOP", conditionBg, "BOTTOM", 0, 0)
  remainTime:SetExtent(window:GetWidth(), DEFAULT_SIZE.EDIT_HEIGHT)
  ApplyTextColor(remainTime, FONT_COLOR.BLUE)
  local acceptBtn = window:CreateChildWidget("button", "acceptBtn", 0, true)
  acceptBtn:AddAnchor("TOPRIGHT", remainTime, "CENTER", -5, 25)
  acceptBtn:SetText(locale.messageBoxBtnText.ok)
  ApplyButtonSkin(acceptBtn, BUTTON_BASIC.DEFAULT)
  local noBtn = window:CreateChildWidget("button", "noBtn", 0, true)
  noBtn:AddAnchor("TOPLEFT", remainTime, "CENTER", 5, 25)
  noBtn:SetText(locale.messageBoxBtnText.cancel)
  ApplyButtonSkin(noBtn, BUTTON_BASIC.DEFAULT)
  local buttonTable = {acceptBtn, noBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  local checkBtn = CreateCheckButton("checkBtn", window, "checkBtn")
  checkBtn.textButton:SetText(GetCommonText("issuance_of_mobilization_order_not_daily"))
  window.checkBtn = checkBtn
  return window
end
