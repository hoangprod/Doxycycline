function W_BAR.CreateExpBar(id, parent)
  parent = parent or "UIParent"
  local window = SetViewOfExpBar(id, parent)
  function window:SetOrientation(arg)
    self.statusBar:SetOrientation(arg)
  end
  function window:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(value)
    self.statusBar:SetValue(value)
  end
  return window
end
function W_BAR.CreateLaborPowerBar(id, parent)
  local window = SetViewOfLaborPowerBar(id, parent)
  function window:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(value)
    self.statusBar:SetValue(value)
  end
  return window
end
function W_BAR.CreateHpBar(id, parent)
  parent = parent or "UIParent"
  local window = SetViewOfHpBar(id, parent)
  function window:SetMinMaxValues(_min, _max)
    self.hp:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(arg)
    self.hp:SetValue(arg)
  end
  function window:GetValue()
    return self.hp:GetValue()
  end
  local function OnEnter(self)
    local hpValue = string.format("%d / %d", X2Unit:UnitHealth(parent.target), X2Unit:UnitMaxHealth(parent.target))
    SetTooltip(hpValue, self)
  end
  window:SetHandler("OnEnter", OnEnter)
  return window
end
function W_BAR.CreateSkillBar(id, parent)
  parent = parent or "UIParent"
  local window = SetViewOfSkillBar(id, parent)
  function window:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(arg)
    self.statusBar:SetValue(arg)
  end
  return window
end
function W_BAR.CreateHeirExpBar(parent)
  parent = parent or "UIParent"
  local window = SetViewOfHeirExpBar("heirExpBar", parent)
  function window:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(arg)
    self.statusBar:SetValue(arg)
  end
  return window
end
function W_BAR.CreateStatusBarOfUnitFrame(id, parent, barType, textureKey)
  parent = parent or "UIParent"
  local w = SetViewOfStatusBarOfUnitFrame(id, parent, barType, textureKey)
  function w:OnLeave()
    if barType ~= "level" then
      HideTooltip()
    end
  end
  w:SetHandler("OnLeave", w.OnLeave)
  function w:OnEnter()
    if parent.target == nil then
      parent.target = "player"
    end
    local value
    if barType == "hp" then
      value = string.format("%d / %d", X2Unit:UnitHealth(parent.target), X2Unit:UnitMaxHealth(parent.target))
    elseif barType == "mp" then
      value = string.format("%d / %d", X2Unit:UnitMana(parent.target), X2Unit:UnitMaxMana(parent.target))
    elseif barType == "laborPower" and self.tip ~= nil then
      SetTooltip(self.tip.levelPercent .. " %", self)
    end
    SetTooltip(value, self)
  end
  w:SetHandler("OnEnter", w.OnEnter)
  return w
end
function W_BAR.CreateStatusBarOfRaidFrame(id, parent, barType)
  parent = parent or "UIParent"
  local w = SetViewOfStatusBarOfRaidFrame(id, parent, barType)
  function w:OnLeave()
    if barType ~= "level" then
      HideTooltip()
    end
  end
  w:SetHandler("OnLeave", w.OnLeave)
  function w:OnEnter()
    if parent.target == nil then
      parent.target = "player"
    end
    local value
    if barType == "hp" then
      value = string.format("%d / %d", X2Unit:UnitHealth(parent.target), X2Unit:UnitMaxHealth(parent.target))
    elseif barType == "mp" then
      value = string.format("%d / %d", X2Unit:UnitMana(parent.target), X2Unit:UnitMaxMana(parent.target))
    elseif barType == "laborPower" and self.tip ~= nil then
      SetTooltip(self.tip.levelPercent .. " %", self)
    end
    SetTooltip(value, self, false)
  end
  w:SetHandler("OnEnter", w.OnEnter)
  return w
end
function W_BAR.CreateStatusBar(id, parent, style)
  local frame = SetViewOfStatusBar(id, parent, style)
  function frame:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function frame:SetBarColor(color)
    self.statusBar:SetBarColor(color[1], color[2], color[3], color[4])
  end
  function frame:SetBarTextureCoords(barPath, coordsKey, bgPath, bgCoordsKey, shadowPath, shadowCoordsKey)
    if self.bg == nil and bgCoordsKey ~= nil then
      local bg = self:CreateDrawable(bgPath, bgCoordsKey, "background")
      bg:AddAnchor("TOPLEFT", self, -1, -1)
      bg:AddAnchor("BOTTOMRIGHT", self, 1, 1)
      self.bg = bg
    end
    self.statusBar:SetBarTexture(barPath, "artwork")
    local coords = {
      GetTextureInfo(barPath, coordsKey):GetCoords()
    }
    self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
    self.statusBar:SetHeight(coords[4])
    self:SetHeight(coords[4] + 2)
    if self.statusBarShadow == nil and shadowCoordsKey ~= nil then
      local statusBarShadow = self:CreateDrawable(shadowPath, shadowCoordsKey, "background")
      self.statusBar:AddAnchorChildToBar(statusBarShadow, "TOPLEFT", "TOPRIGHT", 0, 0)
      self.statusBar:AddAnchorChildToBar(statusBarShadow, "BOTTOMLEFT", "BOTTOMRIGHT", 0, 0)
      statusBarShadow.ORIGIN_WIDTH = GetTextureInfo(shadowPath, shadowCoordsKey):GetWidth()
      self.statusBarShadow = statusBarShadow
    end
  end
  function frame:SetValue(value)
    self.statusBar:SetValue(value)
    if self.statusBarShadow ~= nil then
      local maxValue, minValue = self.statusBar:GetMinMaxValues()
      local leftWidth = F_CALC.Round(self:GetWidth() * (1 - self.statusBar:GetValue() / maxValue), 2)
      local curShadowWidth = F_CALC.Round(self.statusBarShadow:GetWidth(), 2)
      self.statusBarShadow:SetWidth(leftWidth > curShadowWidth and self.statusBarShadow.ORIGIN_WIDTH or leftWidth)
      self.statusBarShadow:SetVisible(value > minValue and value < maxValue)
    end
  end
  return frame
end
function W_BAR.CreateAppellationBar(id, parent)
  parent = parent or "UIParent"
  local window = SetViewOfAppellationBar(id, parent)
  function window:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(arg)
    self.statusBar:SetValue(arg)
  end
  return window
end
function W_BAR.CreateCustomHpBar(id, parent, custom)
  parent = parent or "UIParent"
  local window = SetViewOfCustomHpBar(id, parent, custom)
  function window:SetMinMaxValues(_min, _max)
    self.hp:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(arg)
    self.hp:SetValue(arg)
  end
  function window:GetValue()
    return self.hp:GetValue()
  end
  local function OnEnter(self)
    local hpValue = string.format("%d / %d", X2Unit:UnitHealth(parent.target), X2Unit:UnitMaxHealth(parent.target))
    SetTooltip(hpValue, self)
  end
  window:SetHandler("OnEnter", OnEnter)
  return window
end
function W_BAR.CreateArchePassBar(id, parent)
  parent = parent or "UIParent"
  local window = SetViewOfArchePassBar(id, parent)
  function window:SetMinMaxValues(_min, _max)
    self.statusBar:SetMinMaxValues(_min, _max)
  end
  function window:SetValue(arg)
    self.statusBar:SetValue(arg)
  end
  return window
end
