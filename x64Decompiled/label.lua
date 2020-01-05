function W_CTRL.CreateLabel(id, parent)
  parent = parent or "UIParent"
  local label = UIParent:CreateWidget("label", id, parent)
  label.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  label.style:SetAlign(ALIGN_LEFT)
  label.style:SetSnap(true)
  ApplyTextColor(label, FONT_COLOR.DEFAULT)
  return label
end
