function CreateClockBar(id, parent)
  local window = CreateEmptyWindow("mainClockBar", parent)
  window:Show(true)
  window:SetExtent(182, 25)
  window:AddAnchor("TOPRIGHT", parent, -1, 0)
  window:SetUILayer("game")
  local amImg = window:CreateDrawable(TEXTURE_PATH.HUD, "clock_bar_am_img", "background")
  amImg:AddAnchor("TOPLEFT", window, 0, 0)
  amImg:SetVisible(false)
  window.amImg = amImg
  local pmImg = window:CreateDrawable(TEXTURE_PATH.HUD, "clock_bar_pm_img", "background")
  pmImg:AddAnchor("TOPLEFT", window, 0, 0)
  pmImg:SetVisible(false)
  window.pmImg = pmImg
  local sun = window:CreateDrawable(TEXTURE_PATH.HUD, "clock_bar_sun", "background")
  sun:AddAnchor("BOTTOMLEFT", window, 0, 0)
  sun:SetVisible(false)
  window.sun = sun
  local moon = window:CreateDrawable(TEXTURE_PATH.HUD, "clock_bar_moon", "background")
  moon:AddAnchor("BOTTOMLEFT", window, 0, 0)
  moon:SetVisible(false)
  window.moon = moon
  return window
end
function CreateFpsAlertInfo(id, parent)
  local fpslabelAnchor = {x = 0, y = 0}
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.sensitiveOpeartion then
    fpslabelAnchor.x = fpslabelAnchor.x - 20
  end
  local emptywidget = parent:CreateChildWidget("emptywidget", id, 0, false)
  emptywidget:Show(GetOptionItemValue("ShowFps") == 1)
  emptywidget:SetExtent(45, FONT_SIZE.LARGE)
  emptywidget:AddAnchor("TOPRIGHT", "UIParent", -268 + fpslabelAnchor.x, 6 + fpslabelAnchor.y)
  local bg = emptywidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "brush", "background")
  bg:SetTextureColor("default")
  bg:SetExtent(60, 30)
  bg:SetVisible(false)
  bg:AddAnchor("CENTER", emptywidget, -2, 0)
  emptywidget.bg = bg
  local fpsLabel = emptywidget:CreateChildWidget("label", "fpsLabel", 0, true)
  fpsLabel:SetAutoResize(true)
  fpsLabel:SetText("FPS")
  fpsLabel:SetHeight(FONT_SIZE.SMALL)
  fpsLabel.style:SetFontSize(FONT_SIZE.SMALL)
  fpsLabel.style:SetShadow(true)
  fpsLabel:AddAnchor("RIGHT", emptywidget, 0, 0)
  local fpsInfoLabel = emptywidget:CreateChildWidget("label", "fpsInfoLabel", 0, true)
  fpsInfoLabel:SetAutoResize(true)
  fpsInfoLabel:SetHeight(FONT_SIZE.LARGE)
  fpsInfoLabel.style:SetFontSize(FONT_SIZE.LARGE)
  fpsInfoLabel:AddAnchor("BOTTOMRIGHT", fpsLabel, "BOTTOMLEFT", -1, 0)
  fpsInfoLabel.style:SetShadow(true)
  fpsInfoLabel:SetText(tostring(UIParent:GetFrameRate()))
  emptywidget.time = 0
  function emptywidget:OnEnter()
    self.bg:SetVisible(true)
  end
  emptywidget:SetHandler("OnEnter", emptywidget.OnEnter)
  function emptywidget:OnLeave()
    self.bg:SetVisible(false)
  end
  emptywidget:SetHandler("OnLeave", emptywidget.OnLeave)
  function emptywidget:OnUpdate(dt)
    emptywidget.time = emptywidget.time + dt
    if emptywidget.time >= 1000 then
      self.fpsInfoLabel:SetText(tostring(UIParent:GetFrameRate()))
      emptywidget.time = 0
    end
  end
  emptywidget:SetHandler("OnUpdate", emptywidget.OnUpdate)
  fpsLabel:EnableDrag(true)
  fpsInfoLabel:EnableDrag(true)
  function emptywidget:OnDragStart()
    self:StartMoving()
    self.moving = true
  end
  emptywidget:SetHandler("OnDragStart", emptywidget.OnDragStart)
  function fpsLabel:OnDragStart()
    emptywidget:OnDragStart()
  end
  fpsLabel:SetHandler("OnDragStart", fpsLabel.OnDragStart)
  function fpsInfoLabel:OnDragStart()
    emptywidget:OnDragStart()
  end
  fpsInfoLabel:SetHandler("OnDragStart", fpsInfoLabel.OnDragStart)
  function emptywidget:OnDragStop()
    self:StopMovingOrSizing()
    self.moving = false
  end
  emptywidget:SetHandler("OnDragStop", emptywidget.OnDragStop)
  function fpsLabel:OnDragStop(arg)
    emptywidget:OnDragStop(arg)
  end
  fpsLabel:SetHandler("OnDragStop", fpsLabel.OnDragStop)
  function fpsInfoLabel:OnDragStop(arg)
    emptywidget:OnDragStop(arg)
  end
  fpsInfoLabel:SetHandler("OnDragStop", fpsInfoLabel.OnDragStop)
  function emptywidget:OnScale()
    self:AddAnchor("TOPRIGHT", localeView.fpsInfoAnchor[1], localeView.fpsInfoAnchor[2])
  end
  emptywidget:SetHandler("OnScale", emptywidget.OnScale)
  return emptywidget
end
