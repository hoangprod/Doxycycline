function CreateScrollWindow(parent, ownId, index)
  local frame = parent:CreateChildWidget("emptywidget", ownId, index, true)
  frame:Show(true)
  local content = frame:CreateChildWidget("emptywidget", "content", 0, true)
  content:EnableScroll(true)
  content:Show(true)
  frame.content = content
  local scroll = W_CTRL.CreateScroll("scroll", frame)
  scroll:AddAnchor("TOPRIGHT", frame, 0, 0)
  scroll:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  scroll:SetWheelMoveStep(40)
  scroll:SetButtonMoveStep(5)
  scroll:AlwaysScrollShow()
  frame.scroll = scroll
  content:AddAnchor("TOPLEFT", frame, 0, 0)
  content:AddAnchor("BOTTOM", frame, 0, 0)
  content:AddAnchor("RIGHT", scroll, "LEFT", -5, 0)
  function scroll.vs:OnSliderChanged(_value)
    frame.content:ChangeChildAnchorByScrollValue("vert", _value)
    if frame.SliderChangedProc ~= nil then
      frame:SliderChangedProc(_value)
    end
  end
  scroll.vs:SetHandler("OnSliderChanged", scroll.vs.OnSliderChanged)
  function frame:SetEnable(enable)
    self:Enable(enable)
    scroll:SetEnable(enable)
  end
  return frame
end
