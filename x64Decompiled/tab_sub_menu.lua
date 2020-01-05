function CreateTabSubMenu(id, parent, tabTexts)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  local bg = CreateContentBackground(widget, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", widget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.subMenuButtons = {}
  local widthSum = 15
  for i = 1, #tabTexts do
    local text = tabTexts[i]
    local subMenuButton = widget:CreateChildWidget("button", "subMenuButtons", i, true)
    ApplyButtonSkin(subMenuButton, BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_UNSELECTED)
    subMenuButton:SetText(text)
    subMenuButton:SetHeight(20)
    subMenuButton:AddAnchor("LEFT", widget, widthSum, 0)
    subMenuButton.style:SetFontSize(FONT_SIZE.LARGE)
    subMenuButton:SetAutoResize(true)
    widthSum = widthSum + subMenuButton:GetWidth()
    if i ~= #tabTexts then
      local seperateLabel = subMenuButton:CreateChildWidget("label", "seperateLabel", i, true)
      local c = GetIngameShopSelectedSubMenuButtonFontColor().normal
      ApplyTextColor(seperateLabel, c)
      seperateLabel:AddAnchor("TOPLEFT", subMenuButton, "TOPRIGHT", 5, 0)
      seperateLabel:AddAnchor("BOTTOMLEFT", subMenuButton, "BOTTOMRIGHT", 0, 0)
      seperateLabel:SetText("|")
      seperateLabel.style:SetFontSize(FONT_SIZE.LARGE)
      seperateLabel:SetAutoResize(true)
      widthSum = widthSum + seperateLabel:GetWidth() + 10
    end
    widget.subMenuButtons[i] = subMenuButton
  end
  function widget:Select(index)
    for j = 1, #self.subMenuButtons do
      SetButtonFontColor(self.subMenuButtons[j], BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_UNSELECTED.fontColor)
    end
    SetButtonFontColor(self.subMenuButtons[index], BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_SELECTED.fontColor)
  end
  widget.selIndex = 0
  for i = 1, #widget.subMenuButtons do
    do
      local button = widget.subMenuButtons[i]
      function button:OnClick()
        widget:Select(i)
        widget.selIndex = i
        if widget.OnClickProc ~= nil then
          widget:OnClickProc(i)
        end
      end
      button:SetHandler("OnClick", button.OnClick)
    end
  end
  return widget
end
