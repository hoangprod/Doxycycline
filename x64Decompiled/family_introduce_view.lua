function SetViewOfFamilyIntroduce(tabWnd)
  local margin = 20
  local introuduceTextBox = tabWnd:CreateChildWidget("textBox", "introuduceTextBox", 0, false)
  introuduceTextBox:SetHeight(FONT_SIZE.MIDDLE)
  introuduceTextBox:AddAnchor("TOPLEFT", tabWnd, "TOPLEFT", margin, margin)
  introuduceTextBox:AddAnchor("BOTTOMRIGHT", tabWnd, "BOTTOMRIGHT", -margin, -margin)
  ApplyTextColor(introuduceTextBox, FONT_COLOR.DEFAULT)
  introuduceTextBox:SetText(GetCommonText("family_introduce_content"))
  introuduceTextBox:SetAutoResize(true)
end
