local GUIDE_WIDTH = 430
local GUIDE_HEIGHT = 548
function CreateInfomationGuideContext(widget, data)
  local scrollWnd = CreateScrollWindow(widget, "guideContext", 0)
  if widget:GetObjectType() == "window" then
    local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
    scrollWnd:AddAnchor("TOPLEFT", widget, sideMargin, titleMargin)
    scrollWnd:AddAnchor("BOTTOMRIGHT", widget, -sideMargin, bottomMargin)
  end
  local titleLabel = {}
  local contentLabel = {}
  local line = CreateLine(scrollWnd.content, "TYPE1")
  scrollWnd.contentHeight = 0
  function widget:FillData(data)
    for i = 1, #data do
      local title, mainContent
      if data[i].raw ~= true then
        title = GetCommonText(data[i].title)
        mainContent = ""
        if data[i].content ~= nil then
          mainContent = GetCommonText(data[i].content)
        end
      else
        title = data[i].title
        mainContent = ""
        if data[i].content ~= nil then
          mainContent = data[i].content
        end
      end
      local align = ALIGN_LEFT
      if data[i].align then
        align = data[i].align
      end
      if data[i].line == true then
        line:AddAnchor("TOPLEFT", contentLabel[1], "BOTTOMLEFT", 0, 12)
        line:AddAnchor("TOPRIGHT", contentLabel[1], "BOTTOMRIGHT", 0, 12)
        scrollWnd.contentHeight = scrollWnd.contentHeight + 12 + line:GetHeight()
      end
      titleLabel[i] = scrollWnd.content:CreateChildWidget("textbox", string.format("title%d", i), 0, true)
      titleLabel[i]:SetHeight(FONT_SIZE.LARGE)
      titleLabel[i]:SetWidth(scrollWnd.content:GetWidth())
      titleLabel[i].style:SetFontSize(FONT_SIZE.LARGE)
      titleLabel[i].style:SetAlign(align)
      scrollWnd.contentHeight = scrollWnd.contentHeight + titleLabel[i]:GetHeight()
      if i == 1 then
        titleLabel[i]:AddAnchor("TOPLEFT", scrollWnd.content, 0, 0)
      elseif data[i].line == true then
        titleLabel[i]:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 0, 12)
        scrollWnd.contentHeight = scrollWnd.contentHeight + 12
      else
        titleLabel[i]:AddAnchor("TOPLEFT", contentLabel[i - 1], "BOTTOMLEFT", 0, 23)
        scrollWnd.contentHeight = scrollWnd.contentHeight + 23
      end
      ApplyTextColor(titleLabel[i], FONT_COLOR.MIDDLE_TITLE)
      titleLabel[i]:SetText(title)
      contentLabel[i] = scrollWnd.content:CreateChildWidget("textbox", string.format("content%d", i), 0, true)
      local subContentLevel
      if data[i].subcontent ~= nil then
        local subContent
        if data[i].raw ~= true then
          subContent = GetCommonText(data[i].subcontent)
        else
          subContent = data[i].subcontent
        end
        subContentLevel = scrollWnd.content:CreateChildWidget("textbox", string.format("content%da", i), 0, true)
        subContentLevel:SetAutoResize(true)
        subContentLevel:SetHeight(FONT_SIZE.MIDDLE)
        subContentLevel:SetWidth(scrollWnd.content:GetWidth())
        subContentLevel.style:SetFontSize(FONT_SIZE.MIDDLE)
        subContentLevel.style:SetAlign(align)
        subContentLevel:AddAnchor("TOPLEFT", titleLabel[i], "BOTTOMLEFT", 0, 8)
        ApplyTextColor(subContentLevel, FONT_COLOR.DEFAULT)
        subContentLevel:SetText(mainContent)
        scrollWnd.contentHeight = scrollWnd.contentHeight + subContentLevel:GetHeight() + 5
        contentLabel[i]:AddAnchor("TOPLEFT", subContentLevel, "BOTTOMLEFT", 0, 5)
        mainContent = subContent
      else
        contentLabel[i]:AddAnchor("TOPLEFT", titleLabel[i], "BOTTOMLEFT", 0, 8)
      end
      contentLabel[i]:SetAutoResize(true)
      contentLabel[i]:SetHeight(FONT_SIZE.MIDDLE)
      contentLabel[i]:SetWidth(scrollWnd.content:GetWidth())
      contentLabel[i].style:SetFontSize(FONT_SIZE.MIDDLE)
      contentLabel[i].style:SetAlign(align)
      ApplyTextColor(contentLabel[i], FONT_COLOR.DEFAULT)
      contentLabel[i]:SetText(mainContent)
      scrollWnd.contentHeight = scrollWnd.contentHeight + contentLabel[i]:GetHeight() + 8
    end
    scrollWnd:ResetScroll(scrollWnd.contentHeight)
  end
  return scrollWnd
end
function CreateInfomationGuideWindow(id, parent, title, data, width, height)
  local window = CreateWindow(id .. ".guideWindow", parent)
  if width == nil then
    width = GUIDE_WIDTH
  end
  if height == nil then
    height = GUIDE_HEIGHT
  end
  window:SetExtent(width, height)
  if title ~= nil then
    window:SetTitle(GetCommonText(title))
  end
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, 0, -20)
  window.okButton = okButton
  CreateInfomationGuideContext(window, data)
  if data ~= nil then
    window:FillData(data)
  end
  function window.okButton:OnClick()
    window:Show(false)
  end
  window.okButton:SetHandler("OnClick", window.okButton.OnClick)
  return window
end
