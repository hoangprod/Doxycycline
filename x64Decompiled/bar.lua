W_BAR = {}
local SetViewOfCastingBar = function(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:SetExtent(340, 12)
  local bg = frame:CreateDrawable(TEXTURE_PATH.HUD, "casting_bar_bg", "background")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  frame.bg = bg
  local statusBar = UIParent:CreateWidget("statusbar", id .. ".statusBar", frame)
  statusBar:AddAnchor("TOPLEFT", frame, 4, 1)
  statusBar:AddAnchor("BOTTOMRIGHT", frame, -5, -2)
  statusBar:SetBarTexture(TEXTURE_PATH.HUD, "background")
  statusBar:SetBarTextureCoords(459, 179, 223, 18)
  statusBar:SetOrientation("HORIZONTAL")
  statusBar:SetBarColor(1, 1, 1, 1)
  frame.statusBar = statusBar
  local lightDeco = statusBar:CreateEffectDrawable(TEXTURE_PATH.HUD, "background")
  lightDeco:SetColor(1, 1, 1, 1)
  lightDeco:SetCoords(684, 146, 21, 25)
  lightDeco:SetExtent(21, 14)
  lightDeco:SetRepeatCount(1)
  frame.lightDeco = lightDeco
  statusBar:AddAnchorChildToBar(lightDeco, "TOPLEFT", "TOPRIGHT", -15, -2)
  frame.startAnim_condition = false
  frame.endAnim_condition = false
  function frame:StartAnmation(time)
    self.lightDeco:SetEffectPriority(1, "alpha", time, time)
    self.lightDeco:SetEffectPriority(1, "alpha", 0.7, 0.5)
    self.lightDeco:SetEffectInitialColor(1, 1, 1, 1, 0)
    self.lightDeco:SetEffectFinalColor(1, 1, 1, 1, 1)
    self.lightDeco:SetStartEffect(true)
    self.progress_startAnim = true
  end
  function frame:EndAnmation(time)
    self.lightDeco:SetEffectPriority(1, "alpha", time, time)
    self.lightDeco:SetEffectInitialColor(1, 1, 1, 1, 1)
    self.lightDeco:SetEffectFinalColor(1, 1, 1, 1, 0)
    self.lightDeco:SetStartEffect(true)
    self.progress_endAnim = true
  end
  frame.prev_curtime = nil
  local flashDeco = statusBar:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  flashDeco:SetCoords(459, 197, 223, 18)
  flashDeco:SetExtent(223, 18)
  flashDeco:SetColor(1, 1, 1, 1)
  flashDeco:SetRepeatCount(1)
  flashDeco:AddAnchor("TOPLEFT", statusBar, 0, 0)
  flashDeco:AddAnchor("BOTTOMRIGHT", statusBar, 0, 0)
  frame.flashDeco = flashDeco
  frame.flash_startAnim = false
  frame.anim_direction = nil
  function frame:flashAnmation()
    self.flashDeco:SetEffectPriority(1, "alpha", 0.5, 0.3)
    self.flashDeco:SetEffectInitialColor(1, 1, 1, 1, 0)
    self.flashDeco:SetEffectFinalColor(1, 1, 1, 1, 1)
    self.flashDeco:SetEffectPriority(2, "alpha", 0.5, 0.3)
    self.flashDeco:SetEffectInitialColor(2, 1, 1, 1, 1)
    self.flashDeco:SetEffectFinalColor(2, 1, 1, 1, 0)
    self.flashDeco:SetStartEffect(true)
    self.flash_startAnim = true
  end
  local text = frame:CreateChildWidget("textbox", "text", 0, true)
  text:Raise()
  text.style:SetShadow(true)
  text.style:SetAlign(ALIGN_CENTER)
  text.style:SetFontSize(FONT_SIZE.SMALL)
  text:AddAnchor("TOPLEFT", statusBar, "BOTTOMLEFT", 0, 5)
  text:AddAnchor("TOPRIGHT", statusBar, "BOTTOMRIGHT", 0, 5)
  function text:SetCastingText(str)
    text:SetText(str)
    text:SetHeight(text:GetTextHeight())
  end
  return frame
end
function W_BAR.CreateCastingBar(id, parent, unit)
  local frame = SetViewOfCastingBar(id, parent, unit)
  frame.unit = unit
  frame.spellName = nil
  frame.eventProc = nil
  frame.castingUseable = nil
  function frame:ShowAll()
    frame.statusBar:Show(true)
    frame.text:Show(true)
    frame:Show(true)
  end
  function frame:HideAll(force, isSucceed)
    local fadeOutTime = 200
    if force == true then
      fadeOutTime = 0
    end
    if isSucceed then
      fadeOutTime = 2000
    end
    frame.statusBar:Show(false, fadeOutTime)
    frame.text:Show(false, fadeOutTime)
    frame:Show(false, fadeOutTime)
    frame.startAnim_condition = false
    frame.endAnim_condition = false
    frame.prev_curtime = nil
  end
  function frame:OnUpdate()
    local info = X2Unit:UnitCastingInfo(self.unit)
    if info == nil or info.showTargetCastingTime == false then
      self:HideAll(true)
      return
    end
    if info.spellName ~= nil then
      frame.statusBar:SetMinMaxValues(0, info.castingTime)
      frame.statusBar:SetValue(info.currCastingTime)
      if self.prev_curtime == nil then
        self.prev_curtime = info.currCastingTime
      end
      if not self.startAnim_condition then
        if self.prev_curtime > info.currCastingTime and info.currCastingTime <= info.castingTime * 0.99 then
          self.startAnim_condition = true
          frame.anim_direction = "down"
          self:StartAnmation(info.castingTime * 0.99 / 1000)
        elseif self.prev_curtime < info.currCastingTime and info.currCastingTime >= info.castingTime * 0.01 then
          self.startAnim_condition = true
          frame.anim_direction = "up"
          self:StartAnmation((info.currCastingTime - info.castingTime * 0.01) / 1000)
        end
      end
      if self.startAnim_condition and not self.endAnim_condition then
        if self.prev_curtime > info.currCastingTime and info.currCastingTime <= info.castingTime * 0.08 then
          self.endAnim_condition = true
          self:EndAnmation(info.currCastingTime - info.castingTime * 0.08 / 1000)
        elseif self.prev_curtime < info.currCastingTime and info.currCastingTime >= info.castingTime * 0.9 then
          self.endAnim_condition = true
          self:EndAnmation((info.castingTime - info.castingTime * 0.9) / 1000)
        end
      end
    end
  end
  function frame:Refresh()
    if frame.unit == "none" then
      frame:HideAll(true)
      return
    end
    local info = X2Unit:UnitCastingInfo(self.unit)
    if info ~= nil and info.spellName ~= nil and info.showTargetCastingTime == true then
      frame.text:SetCastingText(info.spellName)
      frame:ChangeBarTexture(info.castingUseable)
      frame:ShowAll()
    else
      frame:HideAll()
    end
  end
  function frame:ChangeBarTexture(castingUseable)
    if self.castingUseable == castingUseable then
      return
    end
    if castingUseable then
      local coords = {
        {
          GetTextureInfo(TEXTURE_PATH.HUD, "charge_bar"):GetCoords()
        },
        {
          GetTextureInfo(TEXTURE_PATH.HUD, "charge_bar_light"):GetCoords()
        }
      }
      frame.statusBar:AddAnchor("TOPLEFT", frame, 6, 2)
      frame.statusBar:SetBarTextureCoords(coords[1][1], coords[1][2], coords[1][3], coords[1][4])
      frame.lightDeco:SetCoords(coords[2][1], coords[2][2], coords[2][3], coords[2][4])
    else
      frame.statusBar:AddAnchor("TOPLEFT", frame, 4, 1)
      frame.statusBar:SetBarTextureCoords(459, 179, 223, 18)
      frame.lightDeco:SetCoords(684, 146, 21, 25)
    end
    self.castingUseable = castingUseable
  end
  local castingBarEvents = {
    SPELLCAST_START = function(spellName, castingTime, caster, castingUseable)
      if caster ~= frame.unit then
        return
      end
      if frame.spellName ~= nil then
        frame.spellName = ""
      end
      frame:ChangeBarTexture(castingUseable)
      frame.spellName = spellName
      frame.text:SetCastingText(spellName)
      frame.ShowAll()
    end,
    SPELLCAST_STOP = function(caster)
      if caster ~= frame.unit then
        return
      end
      if frame.spellName == nil then
        frame.spellName = ""
      end
      frame.text:SetCastingText(frame.spellName .. " " .. locale.castingBar.stop)
      frame.HideAll()
    end,
    SPELLCAST_SUCCEEDED = function(caster)
      if caster ~= frame.unit then
        return
      end
      frame.statusBar:SetMinMaxValues(0, 1)
      frame.statusBar:SetValue(1)
      frame.spellName = nil
      if frame.anim_direction ~= "down" then
        frame:flashAnmation()
        frame:HideAll(false, true)
      else
        frame.HideAll()
      end
    end
  }
  function frame:SetEventProc(handler)
    frame.eventProc = handler
  end
  function frame:SetVisibleCastingBar(visible)
    if frame == nil then
      return
    end
    if visible then
      frame:SetHandler("OnEvent", function(this, event, ...)
        if castingBarEvents[event] ~= nil then
          castingBarEvents[event](...)
        end
        if self.eventProc ~= nil and self.eventProc[event] ~= nil then
          self.eventProc[event](...)
        end
      end)
      frame:SetHandler("OnUpdate", frame.OnUpdate)
    else
      frame:ReleaseHandler("OnEvent")
      frame:ReleaseHandler("OnUpdate")
      frame.HideAll()
    end
  end
  frame:SetVisibleCastingBar(true)
  return frame
end
function W_BAR.CreateDoubleGauge(id, parent)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_05", "background")
  widget.bg = bg
  local defaultGage = widget:CreateDrawable(TEXTURE_PATH.HUD, "default_guage", "background")
  defaultGage:SetTextureColor("default")
  defaultGage:AddAnchor("TOPLEFT", widget, 0, 0)
  defaultGage:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.defaultGage = defaultGage
  local gauge = widget:CreateChildWidget("statusBar", "gauge", 0, true)
  gauge:AddAnchor("TOPLEFT", widget, 0, 0)
  gauge:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  gauge:SetBarTexture(TEXTURE_PATH.HUD, "artwork")
  gauge:SetBarTextureCoords(0, 215, 506, 4)
  gauge:SetBarColor(ConvertColor(68), ConvertColor(181), ConvertColor(240), 1)
  gauge:SetOrientation("HORIZONTAL")
  gauge:SetMinMaxValues(0, 1000)
  gauge:SetValue(500)
  local marking = gauge:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "mark", "overlay")
  marking:AddAnchor("BOTTOM", widget, 0, 0)
  function widget:SetLayout(style)
    if style == "big" then
      self.bg:SetTexture(TEXTURE_PATH.DEFAULT)
      self.bg:SetTextureInfo("double_guage_bg_big", "black")
      self.bg:SetHeight(15)
      self.bg:AddAnchor("LEFT", self, -20, 1)
      self.bg:AddAnchor("RIGHT", self, 20, 1)
    elseif style == "small" then
      self.bg:SetTexture(TEXTURE_PATH.HUD)
      self.bg:SetTextureInfo("double_guage_bg_small", "black")
      self.bg:AddAnchor("TOPLEFT", self, -1, -1)
      self.bg:AddAnchor("BOTTOMRIGHT", self, 1, 1)
      self.gauge:SetBarTextureCoords(0, 215, 193, 4)
      self.defaultGage:SetCoords(0, 215, 193, 4)
    end
  end
  function widget:UpdateScore(scoreTeam1, scoreTeam2)
    if scoreTeam1 == 0 and scoreTeam2 == 0 or scoreTeam1 == scoreTeam2 then
      self.gauge:SetMinMaxValues(0, 2)
      self.gauge:SetValue(1)
      return
    end
    self.gauge:SetMinMaxValues(0, scoreTeam1 + scoreTeam2)
    self.gauge:SetValue(scoreTeam2)
  end
  return widget
end
