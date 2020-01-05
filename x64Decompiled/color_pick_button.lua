function SetViewOfColorPickButtons(id, parent)
  local button = CreateEmptyButton(id, parent)
  local colorBG = button:CreateColorDrawable(1, 1, 1, 1, "background")
  colorBG:AddAnchor("TOPLEFT", button, 1, 1)
  colorBG:AddAnchor("BOTTOMRIGHT", button, -1, -1)
  button.colorBG = colorBG
  local decoLine = button:CreateDrawable("ui/chat_option.dds", "line_color_pick", "overlay")
  decoLine:AddAnchor("TOPLEFT", button, -1, -1)
  decoLine:AddAnchor("BOTTOMRIGHT", button, 1, 1)
  return button
end
function CreateColorPickButtons(id, parent)
  local button = SetViewOfColorPickButtons(id, parent)
  return button
end
