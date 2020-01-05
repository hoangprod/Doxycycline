W_UNIT = {}
function W_UNIT.CreateLevelLabel(id, parent, useLevelTexture)
  parent = parent or "UIParent"
  local frame = parent:CreateChildWidget("emptywidget", "frame", 0, false)
  frame:SetHeight(FONT_SIZE.XLARGE)
  frame.useLevelTexture = useLevelTexture
  local path = "ui/common/character_label.dds"
  local levelTexture = frame:CreateDrawable(path, "level", "background")
  levelTexture:AddAnchor("TOPLEFT", frame, 0, 0)
  frame.levelTexture = levelTexture
  local label = frame:CreateChildWidget("label", "label", 0, true)
  label:SetAutoResize(true)
  label:AddAnchor("RIGHT", frame, 0, 0)
  label.style:SetAlign(ALIGN_RIGHT)
  label.style:SetShadow(true)
  label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  local heirIcon = frame:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor", "background")
  heirIcon:AddAnchor("CENTER", levelTexture, 0, -3)
  frame.heirIcon = heirIcon
  local heirTexture = frame:CreateDrawable(path, "successor", "background")
  heirTexture:AddAnchor("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 3)
  frame.heirTexture = heirTexture
  function frame:SettingUseForInfoWindow()
    self:SetHeight(37)
    self.label:SetHeight(37)
    self.label.style:SetFont("characterInfo", 37)
  end
  function frame:ChangedLevel(level, heirLevel)
    local width
    self.label:SetText(tostring(level))
    if heirLevel > 0 then
      self.label:SetText(tostring(heirLevel))
    end
    if self.useLevelTexture then
      self.levelTexture:SetVisible(heirLevel == 0)
      self.heirIcon:SetVisible(heirLevel > 0)
      self.heirTexture:SetVisible(heirLevel > 0)
      if heirLevel > 0 then
        ApplyTextColor(self.label, F_COLOR.GetColor("successor_deep"))
      else
        ApplyTextColor(self.label, F_COLOR.GetColor("level_character"))
      end
      width = self.label:GetWidth() + self.levelTexture:GetWidth() + 3
    else
      self.levelTexture:SetVisible(false)
      self.heirIcon:SetVisible(false)
      self.heirTexture:SetVisible(false)
      if heirLevel > 0 then
        ApplyTextColor(self.label, F_COLOR.GetColor("successor"))
      else
        ApplyTextColor(self.label, FONT_COLOR.EXP_ORANGE)
      end
      width = self.label:GetWidth()
    end
    self:SetWidth(width)
  end
  return frame
end
function W_UNIT.IsMyUnitId(stringId)
  return X2Unit:GetUnitId("player") == stringId
end
