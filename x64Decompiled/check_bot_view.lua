function SetViewOfCheckBotWindow(id, parent)
  local width = POPUP_WINDOW_WIDTH
  local height = 300
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local labelWidth = width - sideMargin * 2
  local window = CreateWindow(id, parent)
  window:SetExtent(width, height)
  window:Show(false)
  window:SetTitle(GetCommonText("check_bot_title"))
  window:SetCloseOnEscape(false)
  window.titleBar.closeButton:Show(false)
  local desc = window:CreateChildWidget("textbox", "desc", 0, true)
  desc.style:SetAlign(ALIGN_CENTER)
  desc:AddAnchor("TOPLEFT", window, sideMargin, 60)
  desc:SetExtent(labelWidth, 30)
  ApplyTextColor(desc, FONT_COLOR.DEFAULT)
  desc:SetText(GetCommonText("check_bot_desc"))
  local questionBgImg = window:CreateColorDrawable(1, 1, 1, 0.5, "background")
  questionBgImg:SetExtent(100, 35)
  questionBgImg:AddAnchor("TOP", desc, "BOTTOM", 0, 10)
  window.questionNumImg = {}
  for i = 1, 3 do
    window.questionNumImg[i] = window:CreateDrawable(TEXTURE_PATH.SECURITY, "security_0", "overlay")
    local img = window.questionNumImg[i]
    img:AddAnchor("LEFT", questionBgImg, "LEFT", (i - 1) * img:GetWidth() + 10, 0)
  end
  window.questionScratchImg = window:CreateDrawable(TEXTURE_PATH.SECURITY, "pattern_01", "overlay")
  window.questionScratchImg:AddAnchor("LEFT", questionBgImg, "LEFT", 0, 0)
  local refresh = window:CreateChildWidget("button", "refresh", 0, true)
  refresh:SetExtent(60, 20)
  ApplyButtonSkin(refresh, BUTTON_BASIC.DEFAULT)
  refresh:AddAnchor("LEFT", questionBgImg, "RIGHT", 5, 0)
  refresh:SetText(GetCommonText("refresh"))
  refresh:SetAlpha(0.5)
  local remainTime = window:CreateChildWidget("label", "remainTime", 0, true)
  remainTime.style:SetAlign(ALIGN_CENTER)
  remainTime:SetExtent(labelWidth, 20)
  ApplyTextColor(remainTime, FONT_COLOR.BLUE)
  remainTime:AddAnchor("TOP", questionBgImg, "BOTTOM", 0, 5)
  local answerCount = window:CreateChildWidget("label", "answerCount", 0, true)
  answerCount.style:SetAlign(ALIGN_CENTER)
  answerCount:SetExtent(labelWidth, 20)
  ApplyTextColor(answerCount, FONT_COLOR.RED)
  answerCount:AddAnchor("TOP", remainTime, "BOTTOM", 0, 10)
  answerCount:SetText(GetCommonText("check_bot_answer_cnt", 0))
  local restrictDesc = window:CreateChildWidget("textbox", "restrictDesc", 0, true)
  restrictDesc.style:SetAlign(ALIGN_CENTER)
  restrictDesc:SetExtent(labelWidth, 40)
  ApplyTextColor(restrictDesc, FONT_COLOR.RED)
  restrictDesc:AddAnchor("TOP", answerCount, "BOTTOM", 0, 5)
  restrictDesc:SetText(GetCommonText("check_bot_restict_desc"))
  local editAnswer = W_CTRL.CreateEdit("editAnswer", window)
  editAnswer:SetExtent(100, DEFAULT_SIZE.EDIT_HEIGHT)
  editAnswer:AddAnchor("TOP", restrictDesc, "BOTTOM", -50, 5)
  editAnswer:SetMaxTextLength(3)
  editAnswer:SetAlpha(0.5)
  local send = window:CreateChildWidget("button", "send", 0, true)
  send:SetExtent(60, 20)
  ApplyButtonSkin(send, BUTTON_BASIC.DEFAULT)
  send:AddAnchor("LEFT", editAnswer, "RIGHT", 5, 0)
  send:SetText(GetCommonText("input"))
  send:SetAlpha(0.5)
  window:AddAnchor("CENTER", parent, 0, 0)
  return window
end
