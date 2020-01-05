function CreatePartyMemberFrame(id, parent)
  local w = CreateUnitFrame(id, parent, UNIT_FRAME_TYPE.PARTY)
  local UpdateOffline = function(wnd, isOffline)
    if isOffline == true then
      ApplyTextColor(wnd.level.label, FONT_COLOR.GRAY)
      ApplyTextColor(wnd.name, FONT_COLOR.GRAY)
      ApplyTextColor(wnd.hpBar.hpLabel, FONT_COLOR.GRAY)
      wnd.hpBar.hpLabel:SetText(locale.unitFrame.offline)
      wnd.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_OFFLINE)
      wnd.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP_OFFLINE)
      wnd.buffWindow:Show(false)
      wnd.debuffWindow:Show(false)
    else
      wnd:UpdateLevel()
      ApplyTextColor(wnd.name, FONT_COLOR.WHITE)
      ApplyTextColor(wnd.hpBar.hpLabel, FONT_COLOR.WHITE)
      wnd.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_PARTY)
      wnd.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP_PARTY)
      wnd.buffWindow:Show(true)
      wnd.debuffWindow:Show(true)
    end
    wnd.offlineLabel:Show(isOffline)
    wnd.hpBar.hpLabel:Show(not isOffline and GetOptionItemValue("ShowHeatlthNumber") == 1)
  end
  function w:Set(index, target)
    self.target = target
    self.unitId = X2Unit:GetUnitId(target)
    self.index = index
    self.unableGageAni = true
    self:SetTarget(target)
    local isOffline = X2Unit:UnitIsOffline(target) or false
    UpdateOffline(self, isOffline)
    self:SetHandler("OnUpdate", self.OnUpdate)
    self:Show(true)
  end
  function w:Release()
    self.target = ""
    self.unitId = ""
    self.index = 0
    self:ReleaseHandler("OnUpdate")
    self:Show(false)
  end
  function w:SetOffline()
    UpdateOffline(self, true)
  end
  function w:ApplyFrameStyle()
    self.buffWindow:AddAnchor("TOPLEFT", self.mpBar, "BOTTOMLEFT", 2, 4)
    self.buffWindow:SetLayout(6, 26)
    self.debuffWindow:SetLayout(6, 26)
    if self.offlineLabel == nil then
      local offlineLabel = self:CreateChildWidget("label", "offlineLabel", 0, true)
    end
    self.offlineLabel:Show(false)
    self.offlineLabel:SetHeight(FONT_SIZE.SMALL)
    self.offlineLabel:SetAutoResize(true)
    self.offlineLabel:SetText(locale.unitFrame.offline)
    self.offlineLabel:AddAnchor("BOTTOMRIGHT", self.hpBar, -1, -1)
    self.offlineLabel.style:SetAlign(ALIGN_RIGHT)
    self.offlineLabel.style:SetFontSize(FONT_SIZE.SMALL)
    ApplyTextColor(self.offlineLabel, FONT_COLOR.DARK_GRAY)
  end
  local accumTime = 0
  local INTERVAL = 100
  function w:Update(dt)
    accumTime = accumTime + dt
    if accumTime < INTERVAL then
      return false
    end
    accumTime = 0
    if X2Unit:UnitIsOffline(self.target) then
      self:SetAlpha(1)
      return
    end
    local info = X2Unit:UnitDistance(self.target)
    if info == nil then
      return
    end
    if info.distance >= UNIT_VISIBLE_MAX_DISTANCE then
      self:SetAlpha(0.5)
    else
      self:SetAlpha(1)
    end
    return true
  end
  function w:Click(arg)
    if arg == "RightButton" then
      local data = {
        jointOrder = 0,
        memberIndex = self.index
      }
      ActivatePopupMenu(w, "team", data)
    end
  end
  w:ApplyFrameStyle()
  return w
end
