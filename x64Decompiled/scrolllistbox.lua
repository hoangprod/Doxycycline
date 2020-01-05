function W_CTRL.CreateScrollListBox(id, parent, wnd, bgType)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:Show(true)
  if bgType == nil then
    bgType = "TYPE3"
  end
  local bg = CreateContentBackground(frame, bgType, "brown")
  frame.bg = bg
  if bgType == "TYPE3" then
    bg:AddAnchor("TOPLEFT", frame, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
    bg:AddAnchor("BOTTOMRIGHT", frame, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_SIDE * 2)
  else
    bg:AddAnchor("TOPLEFT", frame, -2, -MARGIN.WINDOW_SIDE / 2)
    bg:AddAnchor("BOTTOMRIGHT", frame, 7, MARGIN.WINDOW_SIDE / 2)
  end
  local content = W_CTRL.CreateList("content", frame)
  content:SetStyle("use_texture")
  content:EnableScroll(true)
  content.itemStyle:SetEllipsis(true)
  local scroll = W_CTRL.CreateScroll("scroll", frame)
  scroll:AddAnchor("TOPRIGHT", frame, 0, 0)
  scroll:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  scroll:SetWheelMoveStep(3)
  frame.scroll = scroll
  content:AddAnchor("TOPLEFT", frame, 0, 0)
  content:AddAnchor("BOTTOM", frame, 0, 0)
  content:AddAnchor("RIGHT", scroll, "LEFT", 0, 0)
  function scroll.vs:OnSliderChanged(_value)
    content:SetTop(_value)
    if frame.ProcSliderChanged ~= nil then
      frame:ProcSliderChanged()
    end
    HideTooltip()
  end
  scroll.vs:SetHandler("OnSliderChanged", scroll.vs.OnSliderChanged)
  frame:ResetScroll()
  function frame:SetTreeImage()
    local opened = self.content:CreateOpenedImageDrawable("ui/button/grid.dds")
    opened:SetTextureInfo("opened_df")
    local closed = self.content:CreateClosedImageDrawable("ui/button/grid.dds")
    closed:SetTextureInfo("closed_df")
  end
  function wnd:OnScale()
    frame:SetMinMaxValues(0, frame.content:GetMaxTop())
  end
  wnd:SetHandler("OnScale", wnd.OnScale)
  return frame
end
