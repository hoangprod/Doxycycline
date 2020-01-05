local CreateWarStateWindow = function(window)
  local warStateWnd = window:CreateChildWidget("emptywidget", "warStateWindow", 0, true)
  warStateWnd:Show(false)
  warStateWnd:SetExtent(182, 27)
  local bg = warStateWnd:CreateDrawable(TEXTURE_PATH.HUD, "zone_condition_bg", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", warStateWnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", warStateWnd, 0, 0)
  warStateWnd.bg = bg
  local GAGE_BAR_WIDTH = 65
  local GAGE_BAR_HEIGHT = 6
  local GAGE_STEP_WIDTH = 13
  local stateGageBar = warStateWnd:CreateChildWidget("emptywidget", "stateGageBar", 0, true)
  stateGageBar:SetExtent(GAGE_BAR_WIDTH, GAGE_BAR_HEIGHT)
  stateGageBar:AddAnchor("RIGHT", warStateWnd, "RIGHT", -6, 0)
  stateGageBar:Show(false)
  local bgGage = stateGageBar:CreateDrawable(TEXTURE_PATH.HUD, "zone_danger_step_bg", "background")
  bgGage:SetExtent(GAGE_BAR_WIDTH, GAGE_BAR_HEIGHT)
  bgGage:AddAnchor("LEFT", stateGageBar, 0, 0)
  bgGage:SetVisible(true)
  stateGageBar.gage = {}
  for i = 1, 5 do
    local startPosX = (i - 1) * GAGE_STEP_WIDTH
    stateGageBar.gage[i] = stateGageBar:CreateDrawable(TEXTURE_PATH.HUD, "zone_danger_step_full", "background")
    stateGageBar.gage[i]:SetTextureColor("red")
    stateGageBar.gage[i]:SetExtent(GAGE_STEP_WIDTH, GAGE_BAR_HEIGHT)
    stateGageBar.gage[i]:AddAnchor("LEFT", stateGageBar, startPosX, 0)
    stateGageBar.gage[i]:SetVisible(false)
  end
  local width, height = warStateWnd:GetExtent()
  local titleWidth = width - GAGE_BAR_WIDTH
  local honorPointWarRemainTime = warStateWnd:CreateChildWidget("label", "honorPointWarRemainTime", 0, true)
  honorPointWarRemainTime:Show(true)
  honorPointWarRemainTime:SetExtent(GAGE_BAR_WIDTH, FONT_SIZE.MIDDLE)
  honorPointWarRemainTime:SetAutoResize(true)
  honorPointWarRemainTime:AddAnchor("RIGHT", warStateWnd, -4, 0)
  honorPointWarRemainTime:SetInset(0, 0, 2, 0)
  honorPointWarRemainTime.style:SetFontSize(FONT_SIZE.MIDDLE)
  honorPointWarRemainTime.style:SetAlign(ALIGN_RIGHT)
  honorPointWarRemainTime.style:SetShadow(true)
  local honorPointWarTitle = warStateWnd:CreateChildWidget("label", "honorPointWarTitle", 0, true)
  honorPointWarTitle:Show(true)
  honorPointWarTitle:SetExtent(titleWidth, FONT_SIZE.LARGE)
  honorPointWarTitle:SetAutoResize(true)
  honorPointWarTitle:AddAnchor("LEFT", warStateWnd, 5, 0)
  honorPointWarTitle:SetInset(0, 0, 0, 0)
  honorPointWarTitle.style:SetAlign(ALIGN_CENTER)
  honorPointWarTitle.style:SetShadow(true)
  honorPointWarTitle.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
  return warStateWnd
end
function CreateZoneNameInformer(parent)
  local locationNameLabel = parent:CreateChildWidget("label", "locationNameLabel", 0, true)
  locationNameLabel:Show(true)
  locationNameLabel:SetAutoResize(true)
  locationNameLabel:SetHeight(FONT_SIZE.LARGE + 2)
  locationNameLabel.style:SetAlign(ALIGN_RIGHT)
  locationNameLabel.style:SetShadow(true)
  locationNameLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
  locationNameLabel.style:SetColor(0.99, 1, 0.62, 1)
  locationNameLabel.attachedWidget = nil
  function locationNameLabel:Attach(widget)
    self.attachedWidget = widget
    self:RemoveAllAnchors()
    self:AddAnchor("RIGHT", widget, "LEFT", -5, 0)
    RunIndicatorStackRule()
  end
  function locationNameLabel:Detach()
    self.attachedWidget = nil
    RunIndicatorStackRule()
  end
  return locationNameLabel
end
function CreateZoneStateInformer(parent)
  local zoneStateInformer = parent:CreateChildWidget("emptywidget", "zoneStateInformer", 0, false)
  local warStateWidget = CreateWarStateWindow(zoneStateInformer)
  warStateWidget:AddAnchor("TOPRIGHT", zoneStateInformer, 0, 0)
  return zoneStateInformer
end
