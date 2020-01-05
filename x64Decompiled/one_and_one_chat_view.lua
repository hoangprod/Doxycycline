local CreateScrollBar = function(id, parent)
  local scroll = W_CTRL.CreateScroll(id, parent)
  function scroll:SetScroll(totalLines, currentLine, pagePerMaxLines)
    local visible = pagePerMaxLines < totalLines and true or false
    self:Show(visible)
    if visible then
      local maxValue = totalLines - pagePerMaxLines
      self.vs:SetMinMaxValues(0, maxValue)
      self.vs:SetPageStep(pagePerMaxLines)
      self.vs:SetValue(currentLine, false)
      self.vs:SetValueStep(1)
      self:SetButtonMoveStep(self.vs:GetValueStep())
      self:SetWheelMoveStep(self.vs:GetValueStep())
    else
      self.vs:SetMinMaxValues(0, 0)
      self.vs:SetValueStep(0)
      self.vs:SetPageStep(0)
    end
  end
  local function OnSliderChanged(self, arg)
    parent:SetScrollPos(scroll.vs:GetValue())
  end
  scroll.vs:SetHandler("OnSliderChanged", OnSliderChanged)
  scroll.vs:SetHandler("OnMouseUp", OnSliderChanged)
  scroll.vs:SetHandler("OnMouseMove", OnSliderChanged)
  return scroll
end
function SetViewOfOneAndOneChatWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetTitle("ONE AND ONE CHAT")
  window:SetExtent(510, 500)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:Show(true)
  window:SetCloseOnEscape(false)
  local editbox = W_CTRL.CreateEdit("editbox", window)
  editbox:SetExtent(window:GetWidth(), DEFAULT_SIZE.CHAT_EDIT_HEIGHT)
  editbox:AddAnchor("BOTTOMLEFT", window, 5, -5)
  editbox:AddAnchor("BOTTOMRIGHT", window, -5, -5)
  editbox.style:SetAlign(ALIGN_LEFT)
  editbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  editbox:SetHistoryLines(50)
  window.editbox = editbox
  local content = window:CreateChildWidget("message", "content", 0, true)
  content:AddAnchor("TOP", window.titleBar, "BOTTOM", 0, 5)
  content:AddAnchor("BOTTOM", editbox, "TOP", 0, -5)
  content:AddAnchor("LEFT", window, 5, 0)
  content:AddAnchor("RIGHT", window, -5, 0)
  content:ChangeTextStyle()
  content:SetMaxLines(300)
  content:SetTimeVisible(3000)
  content.style:SetAlign(ALIGN_LEFT)
  content.style:SetSnap(true)
  content:EnableItemLink(true)
  AddItemLinkHandlerToMessageWidget(content)
  window.content = content
  local scrollBar = CreateScrollBar(content:GetId() .. ".scrollBar", content)
  scrollBar:AddAnchor("TOPRIGHT", content, 0, 0)
  scrollBar:AddAnchor("BOTTOMRIGHT", content, 0, 0)
  window.scrollBar = scrollBar
  scrollBar:SetScroll(content:GetMessageLines(), 0, content:GetPagePerMaxLines())
  return window
end
