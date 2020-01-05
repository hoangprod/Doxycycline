local SetViewOfUrlLinkWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(430, 248)
  window:SetTitle(GetCommonText("url_link_title"))
  window:SetCloseOnEscape(true)
  window:SetWindowModal(true)
  window:AddAnchor("CENTER", parent, 0, 0)
  local content = window:CreateChildWidget("textbox", "content", 0, true)
  content:SetAutoResize(true)
  content:SetExtent(330, 31)
  content:AddAnchor("TOP", window, 0, 50)
  content.style:SetAlign(ALIGN_CENTER)
  content.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  content:SetText(GetCommonText("url_link_content"))
  local midWin = window:CreateChildWidget("emptywidget", "midWin", 0, true)
  midWin:SetExtent(390, 96)
  midWin:AddAnchor("TOP", content, "BOTTOM", 0, 6)
  local midBg = CreateContentBackground(midWin, "TYPE2", "default")
  midBg:AddAnchor("TOPLEFT", midWin, 0, 0)
  midBg:AddAnchor("BOTTOMRIGHT", midWin, 0, 0)
  local textLabel = window:CreateChildWidget("label", "textLabel", 0, true)
  textLabel:SetExtent(136, FONT_SIZE.MIDDLE)
  textLabel:AddAnchor("TOPLEFT", midWin, 6, 22)
  textLabel.style:SetAlign(ALIGN_CENTER)
  textLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(textLabel, FONT_COLOR.DEFAULT)
  textLabel:SetText(GetCommonText("url_link_label_text"))
  local urlLabel = window:CreateChildWidget("label", "urlLabel", 0, true)
  urlLabel:SetExtent(136, FONT_SIZE.MIDDLE)
  urlLabel:AddAnchor("TOPLEFT", textLabel, "BOTTOMLEFT", 0, 24)
  urlLabel.style:SetAlign(ALIGN_CENTER)
  urlLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(urlLabel, FONT_COLOR.DEFAULT)
  urlLabel:SetText(GetCommonText("url_link_label_url"))
  local textEdit = W_CTRL.CreateEdit("textEdit", window)
  textEdit:SetExtent(230, 27)
  textEdit:AddAnchor("LEFT", textLabel, "RIGHT", 5, 0)
  textEdit.style:SetAlign(ALIGN_LEFT)
  textEdit.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(textEdit, FONT_COLOR.DEFAULT)
  textEdit:SetMaxTextLength(20)
  local urlEdit = W_CTRL.CreateEdit("urlEdit", window)
  urlEdit:SetExtent(230, 27)
  urlEdit:AddAnchor("LEFT", urlLabel, "RIGHT", 5, 0)
  urlEdit.style:SetAlign(ALIGN_LEFT)
  urlEdit.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(urlEdit, FONT_COLOR.DEFAULT)
  urlEdit:SetMaxTextLength(255)
  local infos = {
    leftButtonStr = GetCommonText("ok"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(window, infos)
  local height = 50 + content:GetHeight() + 6 + midWin:GetHeight() + 10 + window.leftButton:GetHeight() + MARGIN.WINDOW_SIDE
  window:SetHeight(height)
  function window:OnHide()
    window:Show(false)
  end
  local function LeftButtonClickFunc()
    local result = X2Chat:SetUrlTextAddr(textEdit:GetText(), urlEdit:GetText())
    if not result then
      return
    end
    X2Chat:AddUrlLinkToActiveChatInput()
    window:OnHide()
  end
  ButtonOnClickHandler(window.leftButton, LeftButtonClickFunc)
  local function RightButtonClickFunc()
    window:OnHide()
  end
  ButtonOnClickHandler(window.rightButton, RightButtonClickFunc)
  function window:FillData()
    local info = X2Chat:GetUrlTextAddr()
    textEdit:SetText(info.text)
    urlEdit:SetText(info.addr)
  end
  return window
end
local SetViewOfUrlCopyWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(352, 200)
  window:SetTitle(GetCommonText("url_copy_title"))
  window:SetCloseOnEscape(true)
  window:SetWindowModal(true)
  window:AddAnchor("CENTER", parent, 0, 0)
  local topContent = window:CreateChildWidget("textbox", "topContent", 0, true)
  topContent:SetExtent(300, FONT_SIZE.MIDDLE)
  topContent:SetAutoResize(true)
  topContent:AddAnchor("TOP", window, 0, 49)
  topContent.style:SetAlign(ALIGN_CENTER)
  topContent.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(topContent, FONT_COLOR.DEFAULT)
  topContent:SetText(GetCommonText("url_copy_content"))
  local midWin = window:CreateChildWidget("emptywidget", "midWin", 0, true)
  midWin:SetExtent(330, 53)
  midWin:AddAnchor("TOP", topContent, "BOTTOM", 0, 13)
  local midBg = CreateContentBackground(midWin, "TYPE2", "default")
  midBg:AddAnchor("TOPLEFT", midWin, 0, 0)
  midBg:AddAnchor("BOTTOMRIGHT", midWin, 0, 0)
  local urlContent = window:CreateChildWidget("textbox", "urlContent", 0, true)
  urlContent:SetExtent(275, 33)
  urlContent:SetAutoResize(true)
  urlContent:AddAnchor("TOP", midWin, 0, 10)
  urlContent.style:SetAlign(ALIGN_CENTER)
  urlContent.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(urlContent, FONT_COLOR.DEFAULT)
  local botContent = window:CreateChildWidget("textbox", "botContent", 0, true)
  botContent:SetExtent(300, FONT_SIZE.MIDDLE)
  botContent:SetAutoResize(true)
  botContent:AddAnchor("TOP", midWin, "BOTTOM", 0, 10)
  botContent.style:SetAlign(ALIGN_CENTER)
  botContent.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(botContent, FONT_COLOR.DEFAULT)
  botContent:SetText(GetCommonText("url_copy_content2"))
  local infos = {
    leftButtonStr = GetCommonText("do_copy"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(window, infos)
  function window:OnHide()
    window:Show(false)
  end
  local function LeftButtonClickFunc()
    local result = X2:SetClipboardText(window.url)
    if not result then
      return
    end
    window:OnHide()
  end
  ButtonOnClickHandler(window.leftButton, LeftButtonClickFunc)
  local function RightButtonClickFunc()
    window:OnHide()
  end
  ButtonOnClickHandler(window.rightButton, RightButtonClickFunc)
  function window:FillData(str)
    urlContent:SetText(str)
    window.url = str
    midWin:SetHeight(urlContent:GetHeight() + 20)
    local height = 49 + topContent:GetHeight() + 13 + midWin:GetHeight() + 10 + botContent:GetHeight() + 20 + window.leftButton:GetHeight() + MARGIN.WINDOW_SIDE
    window:SetHeight(height)
  end
  return window
end
local urlLinkWindow
function ShowUrlLinkWindow(id, parent)
  if urlLinkWindow == nil then
    urlLinkWindow = SetViewOfUrlLinkWindow(id, parent)
  end
  urlLinkWindow:Show(true)
  urlLinkWindow:FillData()
end
local urlCopyWindow
function ShowUrlCopyWindow(id, parent, text)
  if urlCopyWindow == nil then
    urlCopyWindow = SetViewOfUrlCopyWindow(id, parent)
  end
  urlCopyWindow:Show(true)
  urlCopyWindow:FillData(text)
end
