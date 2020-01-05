function W_CTRL.CreatePropertyViewer(id, parent, width)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(width, 25)
  frame:Show(true)
  frame.propertyWidgets = {}
  frame.propertyKeys = {}
  function frame:GetPropertyCount()
    return #frame.propertyWidgets
  end
  function frame:SetTitle(text, layoutFunc)
    if self.title ~= nil then
      return
    end
    local title = self:CreateChildWidget("emptywidget", "title", 0, true)
    title:SetExtent(width, 25)
    title:AddAnchor("TOPLEFT", frame, "TOPLEFT", 0, 0)
    if layoutFunc ~= nil then
      layoutFunc(title, text)
      return
    end
    local bg = title:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
    bg:SetTextureColor("alpha40")
    bg:SetExtent(width, 25)
    bg:AddAnchor("TOPLEFT", title, "TOPLEFT", 0, 0)
    local titleText = title:CreateChildWidget("label", "titleText", 0, true)
    titleText:SetExtent(width, 25)
    titleText:AddAnchor("TOPLEFT", title, "TOPLEFT", 0, 0)
    titleText.style:SetFontSize(FONT_SIZE.LARGE)
    titleText.style:SetAlign(align)
    titleText.style:SetShadow(ALIGN_CENTER)
    ApplyTextColor(titleText, FONT_COLOR.SOFT_YELLOW)
    titleText:SetText(text)
  end
  function frame:SetBackground(layoutFunc)
    if layoutFunc ~= nil then
      layoutFunc(self)
      return
    end
    local bg = self:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
    bg:SetTextureColor("alpha60")
    bg:AddAnchor("TOPLEFT", self, "TOPLEFT", 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 5)
  end
  function frame:PushProperty(key, name, layoutFunc, inheritDefault)
    if self.title == nil then
      return
    end
    local propertyWidget = self:CreateChildWidget("emptywidget", "properties", #self.propertyWidgets + 1, true)
    propertyWidget:SetExtent(width, 25)
    if #self.propertyWidgets == 0 then
      propertyWidget:AddAnchor("TOPLEFT", self.title, "BOTTOMLEFT", 0, 0)
    else
      propertyWidget:AddAnchor("TOPLEFT", self.propertyWidgets[#self.propertyWidgets], "BOTTOMLEFT", 0, 0)
    end
    self.propertyKeys[key] = #self.propertyWidgets + 1
    self.propertyWidgets[self.propertyKeys[key]] = propertyWidget
    inheritDefault = inheritDefault or false
    if layoutFunc == nil or inheritDefault then
      local nameLabel = propertyWidget:CreateChildWidget("label", "name", 0, true)
      nameLabel:SetExtent(width / 2, 25)
      nameLabel:AddAnchor("TOPLEFT", propertyWidget, "TOPLEFT", 0, 0)
      nameLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
      nameLabel.style:SetAlign(ALIGN_LEFT)
      nameLabel.style:SetShadow(true)
      nameLabel:SetInset(5, 0, 0, 0)
      ApplyTextColor(nameLabel, FONT_COLOR.WHITE)
      nameLabel:SetText(name)
      local valueLabel = propertyWidget:CreateChildWidget("textbox", "value", 0, true)
      valueLabel:SetExtent(width / 2, 25)
      valueLabel:AddAnchor("LEFT", nameLabel, "RIGHT", 0, 0)
      valueLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
      valueLabel.style:SetAlign(ALIGN_RIGHT)
      valueLabel.style:SetShadow(true)
      valueLabel:SetInset(0, 0, 5, 0)
      ApplyTextColor(valueLabel, FONT_COLOR.WHITE)
    end
    if layoutFunc ~= nil then
      layoutFunc(propertyWidget, name)
    end
    self:UpdateHeight()
  end
  function frame:SetPropertyValue(key, value, valueSetFunc)
    local propertyWidget = self.propertyWidgets[self.propertyKeys[key]]
    if valueSetFunc == nil then
      if type(value) == string then
        propertyWidget.value:SetText(value)
      else
        propertyWidget.value:SetText(tostring(value))
      end
    else
      valueSetFunc(propertyWidget, value)
    end
  end
  function frame:UpdateHeight()
    if self.title == nil then
      return
    end
    local frameHeight = self.title:GetHeight()
    for i = 1, #self.propertyWidgets do
      frameHeight = frameHeight + self.propertyWidgets[i]:GetHeight()
    end
    self:SetHeight(frameHeight)
  end
  return frame
end
