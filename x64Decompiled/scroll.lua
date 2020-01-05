function W_CTRL.CreateScroll(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetWidth(19)
  local bg = frame:CreateDrawable(TEXTURE_PATH.SCROLL, "scroll_frame_bg", "background")
  frame.bg = bg
  frame.bgColor = GetTextureInfo(TEXTURE_PATH.SCROLL, "scroll_frame_bg"):GetColors().default
  ApplyTextureColor(bg, frame.bgColor)
  local upButton = frame:CreateChildWidget("button", "upButton", 0, true)
  upButton:AddAnchor("TOPRIGHT", frame, 0, 0)
  ApplyButtonSkin(upButton, BUTTON_BASIC.SLIDER_UP)
  local downButton = frame:CreateChildWidget("button", "downButton", 0, true)
  downButton:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  ApplyButtonSkin(downButton, BUTTON_BASIC.SLIDER_DOWN)
  local vs = frame:CreateChildWidgetByType(UOT_SLIDER, "vs", 0, true)
  vs:AddAnchor("TOPLEFT", upButton, "BOTTOMLEFT", 1, 0)
  vs:AddAnchor("BOTTOMRIGHT", downButton, "TOPRIGHT", 0, 0)
  bg:AddAnchor("TOPLEFT", vs, 2, -9)
  bg:AddAnchor("BOTTOMRIGHT", vs, -3, 9)
  local thumb = vs:CreateChildWidget("button", "thumb", 0, true)
  thumb:EnableDrag(true)
  ApplyButtonSkin(thumb, BUTTON_BASIC.SLIDER_VERTICAL_THUMB)
  vs:SetThumbButtonWidget(thumb)
  vs:SetMinThumbLength(50)
  local wheelMoveStep = 1
  local buttonMoveStep = 1
  function frame:SetWheelMoveStep(val)
    wheelMoveStep = val
  end
  function frame:SetButtonMoveStep(val)
    buttonMoveStep = val
  end
  function frame:SetBgColor(colorTable)
    self.bgColor = colorTable
    self.bg:SetColor(self.bgColor[1], self.bgColor[2], self.bgColor[3], self.bgColor[4])
  end
  function frame:SetEnable(enable)
    upButton:Enable(enable)
    downButton:Enable(enable)
    thumb:Enable(enable)
    if enable then
      self.bg:SetColor(self.bgColor[1], self.bgColor[2], self.bgColor[3], self.bgColor[4])
    else
      self.bg:SetColor(0.5, 0.5, 0.5, 0.5)
    end
  end
  frame.alwaysScrollShow = false
  function frame:AlwaysScrollShow()
    frame.alwaysScrollShow = true
  end
  function upButton:OnClick()
    vs:Up(buttonMoveStep)
  end
  upButton:SetHandler("OnClick", upButton.OnClick)
  function downButton:OnClick()
    vs:Down(buttonMoveStep)
  end
  downButton:SetHandler("OnClick", downButton.OnClick)
  parent.lock = false
  function parent:OnWheelUp()
    if not vs.thumb:IsEnabled() then
      return
    end
    if self.lock == true then
      return
    end
    vs:Up(wheelMoveStep)
  end
  parent:SetHandler("OnWheelUp", parent.OnWheelUp)
  function parent:OnWheelDown()
    if not vs.thumb:IsEnabled() then
      return
    end
    if self.lock == true then
      return
    end
    vs:Down(wheelMoveStep)
  end
  parent:SetHandler("OnWheelDown", parent.OnWheelDown)
  function parent:SetValueStep(v)
    vs:SetValueStep(v)
  end
  function parent:SetValue(val)
    if parent.content then
      parent.content:ChangeChildAnchorByScrollValue("vert", val)
    end
    vs:SetValue(val, false)
  end
  function parent:Lock(enable)
    self.lock = enable
    local visible = not enable
    local _, maxValue = vs:GetMinMaxValues()
    if maxValue == 0 and visible then
      frame:Show(false)
      return
    end
    frame:Show(visible)
    if self.SetEnable then
      self:SetEnable(visible)
    end
  end
  function parent:SetMinMaxValues(min, max)
    if min < 0 then
      min = 0
    end
    if max < 0 then
      max = 0
    end
    vs:SetMinMaxValues(min, max)
    if self.lock then
      frame:Show(false)
      return
    end
    if frame.alwaysScrollShow then
      frame:Show(true)
    end
    if self.SetEnable then
      self:SetEnable(max > 0)
    else
      frame:SetEnable(max > 0)
    end
    thumb:Show(max > 0)
  end
  function parent:ResetScroll(contentHeight)
    if contentHeight == nil then
      contentHeight = 0
    end
    local height = self:GetHeight()
    local scrollRange = math.floor(contentHeight - height)
    if scrollRange < 0 then
      scrollRange = 0
    end
    self:SetMinMaxValues(0, scrollRange)
    return scrollRange
  end
  function parent:SetMiniThumbSkin(length)
    if length < 20 then
      length = 20
    end
    ApplyButtonSkin(thumb, BUTTON_BASIC.SLIDER_VERTICAL_MINI_THUMB)
    vs:SetMinThumbLength(length)
  end
  return frame
end
