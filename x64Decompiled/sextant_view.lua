function CreateSextantWindow(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetHeight(FONT_SIZE.MIDDLE)
  wnd:Show(true)
  local coordinateLabel = wnd:CreateChildWidget("textbox", "coordinateLabel", 0, true)
  coordinateLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  coordinateLabel:AddAnchor("RIGHT", wnd, "RIGHT", 0, 0)
  coordinateLabel.style:SetAlign(ALIGN_RIGHT)
  coordinateLabel.style:SetShadow(true)
  coordinateLabel:SetAutoResize(true)
  coordinateLabel:SetAutoWordwrap(false)
  coordinateLabel:Show(true)
  function wnd:Update(sextantInfo)
    local color1 = {
      ConvertColor(255),
      ConvertColor(255),
      ConvertColor(52),
      1
    }
    local colorStr1 = GetHexColorForString(Dec2Hex(color1))
    local colorStr2 = FONT_COLOR_HEX.WHITE
    local longStr = locale.map.makeLongitudeStr(sextantInfo, colorStr1, colorStr2)
    local latStr = locale.map.makeLatitudeStr(sextantInfo, colorStr1, colorStr2)
    self.coordinateLabel:SetText(string.format("%s  %s", longStr, latStr))
  end
  function coordinateLabel:OnEnter()
    SetTargetAnchorTooltip(GetCommonText("tooltip_my_sextant"), "RIGHT", self, "LEFT", -2, 0)
  end
  coordinateLabel:SetHandler("OnEnter", coordinateLabel.OnEnter)
  function coordinateLabel:OnLeave()
    HideTooltip()
  end
  coordinateLabel:SetHandler("OnLeave", coordinateLabel.OnLeave)
  return wnd
end
