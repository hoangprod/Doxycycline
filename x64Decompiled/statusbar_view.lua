function SetViewOfExpBar(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  window:Show(true)
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "default_guage", "background")
  bg:SetTextureColor("exp_bar_bg")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local statusBar = window:CreateChildWidget("statusbar", "statusBar", 0, true)
  statusBar:AddAnchor("TOPLEFT", window, 0, 0)
  statusBar:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  statusBar:SetBarTexture(TEXTURE_PATH.HUD, "artwork")
  statusBar:SetBarTextureCoords(0, 215, 506, 4)
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:SetBarColor(ConvertColor(238), ConvertColor(148), ConvertColor(42), 1)
  statusBar:SetMinMaxValues(0, 1000)
  statusBar:SetValue(1000)
  statusBar:Show(true)
  function window:ChangeStatusBarDefaultColor()
    self.statusBar:SetBarColor(ConvertColor(238), ConvertColor(148), ConvertColor(42), 1)
  end
  function window:ChangeStatusBarColor(color)
    if color ~= nil then
      self.statusBar:SetBarColor(ConvertColor(color[1]), ConvertColor(color[2]), ConvertColor(color[3]), 1)
    end
  end
  return window
end
function SetViewOfLaborPowerBar(id, parent)
  local window = UIParent:CreateWidget("emptywidget", id, parent)
  window:Show(true)
  window:SetExtent(400, 5)
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "default_guage", "background")
  bg:SetTextureColor("labor_power_bar_bg")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.bg = bg
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".widget", window)
  statusBar:AddAnchor("TOPLEFT", window, 0, 0)
  statusBar:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local tInfo = GetTextureInfo(TEXTURE_PATH.HUD, "default_guage")
  local color = tInfo:GetColors().labor_power_bar
  statusBar:SetBarTexture(TEXTURE_PATH.HUD, "artwork")
  statusBar:SetBarTextureCoords(tInfo:GetCoords())
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:SetBarColor(color[1], color[2], color[3], color[4])
  statusBar:SetMinMaxValues(0, 1000)
  statusBar:SetValue(1000)
  statusBar:Show(true)
  window.statusBar = statusBar
  return window
end
function SetViewOfHpBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, "siege_gauge_bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local hp = UIParent:CreateWidget("statusbar", id .. ".hp", window)
  hp:AddAnchor("TOPLEFT", window, 3, 1)
  hp:AddAnchor("BOTTOMRIGHT", window, -3, -3)
  hp:SetBarTexture(TEXTURE_PATH.SIEGE_HP_BAR, "artwork")
  local coords = {
    GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetCoords()
  }
  hp:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
  hp:SetOrientation("HORIZONTAL")
  local colors = GetTextureInfo(TEXTURE_PATH.SIEGE_HP_BAR, "siege_gauge"):GetColors().siege_red
  hp:SetBarColor(colors[1], colors[2], colors[3], colors[4])
  window.hp = hp
  return window
end
function SetViewOfSkillBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(0, 11)
  window:Show(true)
  local bg = window:CreateDrawable(TEXTURE_PATH.SKILL, "skill_bar_bg", "background")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.bg = bg
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".status", window)
  statusBar:Show(true)
  statusBar:AddAnchor("TOPLEFT", window, 2, 1)
  statusBar:AddAnchor("BOTTOMRIGHT", window, -2, -2)
  statusBar:SetBarTexture(TEXTURE_PATH.SKILL, "background")
  statusBar:SetBarTextureCoords(0, 163, 143, 8)
  statusBar:SetBarColor(ConvertColor(212), ConvertColor(181), ConvertColor(106), 1)
  statusBar:SetOrientation("HORIZONTAL")
  window.statusBar = statusBar
  function window:ChangeStatusBarTextureOfActabilityGrade(colorString)
    if colorString ~= nil then
      local colors = Hex2Dec(colorString)
      self.statusBar:SetBarColor(colors[1], colors[2], colors[3], colors[4])
    end
  end
  function window:ChangeStatusBarBG(coords)
    if coords ~= nil then
      self.bg:SetCoords(coords[1], coords[2], coords[3], coords[4])
    end
  end
  function window:ChangeStatusBarDefaultColor()
    self.statusBar:SetBarColor(ConvertColor(212), ConvertColor(181), ConvertColor(106), 1)
  end
  function window:ChangeStatusBarColor(color)
    if color ~= nil then
      self.statusBar:SetBarColor(ConvertColor(color[1]), ConvertColor(color[2]), ConvertColor(color[3]), 1)
    end
  end
  return window
end
function SetViewOfHeirExpBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(0, 11)
  window:Show(true)
  local bg = window:CreateDrawable(TEXTURE_PATH.SKILL, "skill_bar_bg", "background")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.bg = bg
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".status", window)
  statusBar:Show(true)
  statusBar:AddAnchor("TOPLEFT", window, 2, 1)
  statusBar:AddAnchor("BOTTOMRIGHT", window, -2, -2)
  statusBar:SetBarTexture(TEXTURE_PATH.HEIR_SKILL, "background")
  statusBar:SetBarTextureCoords(GetTextureInfo(TEXTURE_PATH.HEIR_SKILL, "gauge_bar"):GetCoords())
  statusBar:SetBarColor(ConvertColor(212), ConvertColor(181), ConvertColor(106), 1)
  statusBar:SetOrientation("HORIZONTAL")
  window.statusBar = statusBar
  function window:ChangeStatusBarTextureOfActabilityGrade(colorString)
    if colorString ~= nil then
      local colors = Hex2Dec(colorString)
      self.statusBar:SetBarColor(colors[1], colors[2], colors[3], colors[4])
    end
  end
  function window:ChangeStatusBarBG(coords)
    if coords ~= nil then
      self.bg:SetCoords(coords[1], coords[2], coords[3], coords[4])
    end
  end
  function window:ChangeStatusBarDefaultColor()
    self.statusBar:SetBarColor(ConvertColor(212), ConvertColor(181), ConvertColor(106), 1)
  end
  function window:ChangeStatusBarColor(color)
    if color ~= nil then
      self.statusBar:SetBarColor(ConvertColor(color[1]), ConvertColor(color[2]), ConvertColor(color[3]), 1)
    end
  end
  return window
end
function SetViewOfStatusBarOfUnitFrame(id, parent, barType, textureKey)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  if barType == "hp" then
    window.statusBarAfterImage = UIParent:CreateWidget("statusbar", id .. ".statusBarAfterImage", window)
    window.statusBarAfterImage:AddAnchor("TOPLEFT", window, 2, 2)
    window.statusBarAfterImage:AddAnchor("BOTTOMRIGHT", window, -2, -2)
    window.statusBarAfterImage:SetBarTexture(TEXTURE_PATH.HUD, "background")
    window.statusBarAfterImage:SetBarTextureCoords(0, 120, 300, 19)
    window.statusBarAfterImage:SetOrientation("HORIZONTAL")
    window.statusBarAfterImage:Show(true)
  end
  local bg = window:CreateDrawable(TEXTURE_PATH.HUD, textureKey, "artwork")
  bg:AddAnchor("TOPLEFT", window, "TOPLEFT", 0, 0)
  window.bg = bg
  window:SetExtent(bg:GetWidth(), bg:GetHeight())
  window.statusBar = UIParent:CreateWidget("statusbar", id .. ".statusBar", window)
  window.statusBar:AddAnchor("TOPLEFT", bg, 2, 2)
  window.statusBar:AddAnchor("BOTTOMRIGHT", bg, -2, -2)
  window.statusBar:SetBarTexture(TEXTURE_PATH.HUD, "background")
  window.statusBar:SetOrientation("HORIZONTAL")
  window.statusBar:Show(true)
  function window:ChangeBgStyle(textureKey)
    self.bg:SetTextureInfo(textureKey)
    self:SetExtent(self.bg:GetWidth(), self.bg:GetHeight())
  end
  function window:ApplyBarTexture(textureInfo)
    if self.statusBar == nil then
      return
    end
    local coords = textureInfo.coords
    self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
    self.textureInfo = textureInfo
    if self.statusBarAfterImage ~= nil then
      local color = textureInfo.afterImage_color_down
      self.statusBarAfterImage:SetBarColor(color[1], color[2], color[3], color[4])
    end
  end
  function window:ChangeAfterImageColor(isDown)
    if self.statusBar == nil then
      return
    end
    if self.statusBarAfterImage == nil then
      return
    end
    if self.textureInfo == nil then
      return
    end
    if isDown then
      local color = self.textureInfo.afterImage_color_down
      self.statusBarAfterImage:SetBarColor(color[1], color[2], color[3], color[4])
    else
      local color = self.textureInfo.afterImage_color_up
      self.statusBarAfterImage:SetBarColor(color[1], color[2], color[3], color[4])
    end
  end
  return window
end
function SetViewOfStatusBarOfRaidFrame(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".statusBar", window)
  statusBar:AddAnchor("TOPLEFT", window, 0, 0)
  statusBar:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  statusBar:SetBarTexture(TEXTURE_PATH.RAID, "background")
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:Show(true)
  window.statusBar = statusBar
  function window:ApplyBarTexture(textureInfo)
    if self.statusBar == nil then
      return
    end
    local coords = textureInfo.coords
    self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
  end
  return window
end
function SetViewOfStatusBar(id, parent, style)
  local window = parent:CreateChildWidget("emptywidget", id, 0, false)
  window:Show(true)
  local statusBar = window:CreateChildWidget("statusbar", "statusBar", 0, true)
  statusBar:AddAnchor("TOPLEFT", window, 0, 0)
  statusBar:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  statusBar:SetOrientation("HORIZONTAL")
  function window:SetStyle(style)
    if style == nil or style == "" then
      return
    end
    if style == "item_smelting_prob_yellow" then
      if self.bg == nil then
        local bg = window:CreateDrawable(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_bg", "background")
        bg:AddAnchor("CENTER", window, 0, 0)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.SMELTING_ENCHANT, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_yellow"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetExtent(GetTextureInfo(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_yellow"):GetExtent())
    elseif style == "item_smelting_prob_blue" then
      if self.bg == nil then
        local bg = window:CreateDrawable(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_bg", "background")
        bg:AddAnchor("CENTER", window, 0, 0)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.SMELTING_ENCHANT, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_blue"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetExtent(GetTextureInfo(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_blue"):GetExtent())
    elseif style == "item_smelting_prob_red" then
      if self.bg == nil then
        local bg = window:CreateDrawable(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_bg", "background")
        bg:AddAnchor("CENTER", window, 0, 0)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.SMELTING_ENCHANT, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_red"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetExtent(GetTextureInfo(TEXTURE_PATH.SMELTING_ENCHANT, "gauge_red"):GetExtent())
    elseif style == "item_evolving_target" then
      self.statusBar:SetBarTexture(TEXTURE_PATH.COMMON_GAUGE, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self.statusBar:SetHeight(coords[4])
      self:SetHeight(coords[4] + 2)
    elseif style == "item_evolving_material" then
      if self.bg == nil then
        local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_bg", "background")
        bg:AddAnchor("TOPLEFT", window, -1, -1)
        bg:AddAnchor("BOTTOMRIGHT", window, 1, 1)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.COMMON_GAUGE, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetHeight(coords[4] + 2)
    elseif style == "craft" then
      if self.bg == nil then
        local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_bg", "background")
        bg:AddAnchor("TOPLEFT", window, -1, -1)
        bg:AddAnchor("BOTTOMRIGHT", window, 1, 1)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.COMMON_GAUGE, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetHeight(coords[4] + 2)
    elseif style == "equip_slot_reinforce" then
      if self.bg == nil then
        local bg = window:CreateImageDrawable(TEXTURE_PATH.EQUIP_SLOT_REINFORCE, "background")
        bg:SetTextureInfo("gauge_bg")
        bg:AddAnchor("TOPLEFT", window, -1, -1)
        bg:AddAnchor("BOTTOMRIGHT", window, 1, 1)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.EQUIP_SLOT_REINFORCE, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.EQUIP_SLOT_REINFORCE, "gauge"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetHeight(coords[4] + 2)
    elseif style == "reinforceAddExpGuage" then
      if self.bg == nil then
        local bg = window:CreateDrawable(TEXTURE_PATH.COSPLAY_ENCHANT, "gage_bg", "background")
        bg:AddAnchor("TOPLEFT", window, -1, -1)
        bg:AddAnchor("BOTTOMRIGHT", window, 1, 1)
        self.bg = bg
      end
      self.statusBar:SetBarTexture(TEXTURE_PATH.COSPLAY_ENCHANT, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.COSPLAY_ENCHANT, "gage"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetHeight(coords[4] + 2)
    elseif style == "reinforceExpGuage" then
      self.statusBar:SetBarTexture(TEXTURE_PATH.COSPLAY_ENCHANT, "artwork")
      local coords = {
        GetTextureInfo(TEXTURE_PATH.COSPLAY_ENCHANT, "gage"):GetCoords()
      }
      self.statusBar:SetBarTextureCoords(coords[1], coords[2], coords[3], coords[4])
      self:SetHeight(coords[4] + 2)
    end
  end
  window:SetStyle(style)
  return window
end
function SetViewOfAppellationBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_bg", "background")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".status", window)
  statusBar:Show(true)
  statusBar:AddAnchor("TOPLEFT", window, 2, 1)
  statusBar:AddAnchor("BOTTOMRIGHT", window, -2, -2)
  local info = GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage")
  local colors = info:GetColors().grade_title
  statusBar:SetBarTexture(TEXTURE_PATH.COMMON_GAUGE, "background")
  statusBar:SetBarTextureCoords(info:GetCoords())
  statusBar:SetBarColor(colors[1], colors[2], colors[3], colors[4])
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:SetMinMaxValues(0, 100)
  window.statusBar = statusBar
  local shadowDeco = statusBar:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_shadow", "artwork")
  statusBar:AddAnchorChildToBar(shadowDeco, "TOPLEFT", "TOPRIGHT", 0, -1)
  window.shadowDeco = shadowDeco
  return window
end
function SetViewOfCustomHpBar(id, parent, custom)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  local bg = window:CreateDrawable(custom.path, custom.textureKey, "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.bg = bg
  local hp = UIParent:CreateWidget("statusbar", id .. ".hp", window)
  hp:AddAnchor("TOPLEFT", window, 1, 1)
  hp:AddAnchor("BOTTOMRIGHT", window, -2, -1)
  hp:SetBarTexture(custom.path, "artwork")
  hp:SetBarTextureCoords(custom.coords[1], custom.coords[2], custom.coords[3], custom.coords[4])
  hp:SetOrientation("HORIZONTAL")
  hp:SetBarColor(1, 1, 1, 1)
  window.hp = hp
  function window:ChangeStatusBarColor(colors)
    self.hp:SetBarColor(colors[1], colors[2], colors[3], colors[4])
  end
  function window:ChangeStatusBarBgColor(colors)
    self.bg:SetColor(colors[1], colors[2], colors[3], colors[4])
  end
  return window
end
function SetViewOfArchePassBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_bg", "background")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".status", window)
  statusBar:Show(true)
  statusBar:AddAnchor("TOPLEFT", window, 2, 1)
  statusBar:AddAnchor("BOTTOMRIGHT", window, -2, -1)
  local info = GetTextureInfo("ui/eventcenter/archepass_gauge.dds", "gauge_blue")
  statusBar:SetBarTexture("ui/eventcenter/archepass_gauge.dds", "background")
  statusBar:SetBarTextureCoords(info:GetCoords())
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:SetMinMaxValues(0, 100)
  window.statusBar = statusBar
  local shadowDeco = statusBar:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_shadow", "artwork")
  statusBar:AddAnchorChildToBar(shadowDeco, "TOPLEFT", "TOPRIGHT", 0, -1)
  window.shadowDeco = shadowDeco
  return window
end
