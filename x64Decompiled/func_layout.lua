F_LAYOUT = {}
function F_LAYOUT.GetExtentWidgets(startWidget, endWidget)
  if startWidget.GetParent == nil or endWidget.GetParent == nil then
    return nil, nil
  end
  if startWidget:GetParent() ~= endWidget:GetParent() then
    return nil, nil
  end
  local sx, sy = startWidget:GetOffset()
  local ex, ey = endWidget:GetOffset()
  local width = ex + endWidget:GetWidth() - sx
  local height = ey + endWidget:GetHeight() - sy
  return width, height
end
function F_LAYOUT.AdjustTextWidth(widgets)
  local longestWidth = 0
  for i = 1, #widgets do
    local widget = widgets[i]
    if widget.style ~= nil then
      local width = widget.style:GetTextWidth(widget:GetText())
      if longestWidth < width then
        longestWidth = width
      end
    else
      UIParent:Warning("this widget has not style")
    end
  end
  for i = 1, #widgets do
    local widget = widgets[i]
    widget:SetWidth(longestWidth)
  end
end
function F_LAYOUT.AttachAnchor(target, anchorTarget, left, top, right, bottom)
  if left == nil then
    left = 0
  end
  if top == nil then
    top = 0
  end
  if right == nil then
    right = 0
  end
  if bottom == nil then
    bottom = 0
  end
  target:RemoveAllAnchors()
  target:AddAnchor("TOPLEFT", anchorTarget, left, top)
  target:AddAnchor("BOTTOMRIGHT", anchorTarget, right, bottom)
end
function F_LAYOUT.CalcDontApplyUIScale(value, customUIScale)
  if customUIScale == nil then
    return value / UIParent:GetUIScale()
  else
    return value / customUIScale
  end
end
function F_LAYOUT.GetUIScaleValueByRealValue(realValue)
  return math.floor(realValue * 10) * 10
end
function F_LAYOUT.GetUIScaleValueByOptionWindowValue(selectedValue)
  if selectedValue == 80 then
    return 0.85
  elseif selectedValue == 90 then
    return 0.93
  end
  return selectedValue / 100
end
