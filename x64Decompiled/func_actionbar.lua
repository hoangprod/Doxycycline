F_ACTIONBAR = {}
local SCREEN_MIN_INTERSECT_AREA = 500
local SCREEN_DOCKING_BOTTOM_OFFSET = 6
actionBar_dockingWindow = {}
docking_manager = {}
docking_manager.LEFT = {}
docking_manager.TOP = {}
docking_manager.BOTTOM = {}
docking_manager.RIGHT = {}
docking_direction = {
  "TOP",
  "BOTTOM",
  "LEFT",
  "RIGHT"
}
local GetScreenSize = function()
  local lx, rx, ty, by, w, h = 0, 0, 0, 0, 0, 0
  for j, value in pairs(docking_direction) do
    for i, child in pairs(docking_manager[value]) do
      local cw, ch = child:GetEffectiveExtent()
      if child.direction == "TOP" then
        ty = ty + ch
      end
      if child.direction == "BOTTOM" then
        by = by + ch
      end
      if child.direction == "LEFT" then
        lx = lx + ch
      end
      if child.direction == "RIGHT" then
        rx = rx + ch
      end
    end
  end
  local uw = UIParent:GetScreenWidth()
  local uh = UIParent:GetScreenHeight()
  h = uh - ty - by
  w = uw - lx - rx
  return lx, ty, w, h
end
local function UpdateDockingWindow(widget, side)
  local x, y, cx, cy = GetScreenSize()
  local screenWidth = UIParent:GetScreenWidth()
  local screenHeight = UIParent:GetScreenHeight()
  local value = 15
  if side == "LEFT" then
    widget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(value), F_LAYOUT.CalcDontApplyUIScale(cy) - SCREEN_DOCKING_BOTTOM_OFFSET)
    widget.intersectWidget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(value), F_LAYOUT.CalcDontApplyUIScale(cy))
    widget:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(x), F_LAYOUT.CalcDontApplyUIScale(y))
  elseif side == "RIGHT" then
    widget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(value), F_LAYOUT.CalcDontApplyUIScale(cy) - SCREEN_DOCKING_BOTTOM_OFFSET)
    widget.intersectWidget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(value), F_LAYOUT.CalcDontApplyUIScale(cy))
    widget:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", F_LAYOUT.CalcDontApplyUIScale(cx - screenWidth), F_LAYOUT.CalcDontApplyUIScale(y))
  elseif side == "TOP" then
    widget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(cx), F_LAYOUT.CalcDontApplyUIScale(value))
    widget.intersectWidget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(cx), F_LAYOUT.CalcDontApplyUIScale(value))
    widget:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(x), F_LAYOUT.CalcDontApplyUIScale(y))
  else
    widget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(cx), F_LAYOUT.CalcDontApplyUIScale(value))
    widget.intersectWidget:SetExtent(F_LAYOUT.CalcDontApplyUIScale(cx), F_LAYOUT.CalcDontApplyUIScale(value) + SCREEN_DOCKING_BOTTOM_OFFSET)
    widget:AddAnchor("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", F_LAYOUT.CalcDontApplyUIScale(x), F_LAYOUT.CalcDontApplyUIScale(y + cy - screenHeight) - SCREEN_DOCKING_BOTTOM_OFFSET)
  end
end
local function CreateDockingScreenWindow(id, side)
  local widget = CreateEmptyWindow(id, "UIParent")
  widget:Show(false)
  widget.side = side
  widget.bg = widget:CreateDrawable(TEXTURE_PATH.HUD, "move_vertical", "background")
  widget.bg:AddAnchor("TOPLEFT", widget, 0, 0)
  widget.bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.intersectWidget = widget:CreateChildWidget("emptywidget", "intersectWidget", 0, true)
  widget.intersectWidget:AddAnchor("TOPLEFT", widget, "TOPLEFT", 0, 0)
  local textureKey = {
    TOP = "move_vertical",
    LEFT = "move_left",
    BOTTOM = "move_vertical_inv",
    RIGHT = "move_right"
  }
  if textureKey[side] ~= nil then
    widget.bg:SetTextureInfo(textureKey[side], "default")
  end
  UpdateDockingWindow(widget, side)
  return widget
end
actionBar_dockingWindow.TOP = CreateDockingScreenWindow("actionBar_dockingWindow.top", "TOP")
actionBar_dockingWindow.LEFT = CreateDockingScreenWindow("actionBar_dockingWindow.left", "LEFT")
actionBar_dockingWindow.BOTTOM = CreateDockingScreenWindow("actionBar_dockingWindow.bottom", "BOTTOM")
actionBar_dockingWindow.RIGHT = CreateDockingScreenWindow("actionBar_dockingWindow.right", "RIGHT")
local GetIntersectArea = function(widget, target)
  local x, y = widget:GetEffectiveOffset()
  local cx, cy = widget:GetEffectiveExtent()
  local srcLeft = x
  local srcRight = x + cx
  local srcTop = y
  local srcBottom = y + cy
  x, y = target:GetEffectiveOffset()
  cx, cy = target:GetEffectiveExtent()
  local dstLeft = x
  local dstRight = x + cx
  local dstTop = y
  local dstBottom = y + cy
  if srcRight <= dstLeft or srcLeft >= dstRight or srcBottom <= dstTop or srcTop >= dstBottom then
    return 0
  end
  local clippedRectLeft = math.max(srcLeft, dstLeft)
  local clippedRectTop = math.max(srcTop, dstTop)
  local clippedRectRight = math.min(srcRight, dstRight)
  local clippedRectBottom = math.min(srcBottom, dstBottom)
  local area = (clippedRectRight - clippedRectLeft) * (clippedRectBottom - clippedRectTop)
  return area
end
local IsDockingableTarget = function(target)
  if target.dockedWidget == nil then
    return true
  end
  return false
end
local function FindNearestScreenDockingTarget(widget)
  local targets = {}
  for side, target in pairs(actionBar_dockingWindow) do
    local area = GetIntersectArea(widget, target.intersectWidget)
    if area > SCREEN_MIN_INTERSECT_AREA then
      targets[#targets + 1] = target
    end
  end
  return targets
end
function F_ACTIONBAR.RelocationDockingWindow()
  UpdateDockingWindow(actionBar_dockingWindow.LEFT, "LEFT")
  UpdateDockingWindow(actionBar_dockingWindow.RIGHT, "RIGHT")
  UpdateDockingWindow(actionBar_dockingWindow.TOP, "TOP")
  UpdateDockingWindow(actionBar_dockingWindow.BOTTOM, "BOTTOM")
end
function F_ACTIONBAR.ShowAnchorTargetWithoutDocked()
  F_ACTIONBAR.RelocationDockingWindow()
  for i = 1, #actionBar_dockingWindow do
    local widget = actionBar_dockingWindow[i]
    if IsDockingableTarget(widget) then
      widget:Show(true)
    end
  end
  for _, widget in pairs(actionBar_dockingWindow) do
    widget:Show(true)
  end
end
function F_ACTIONBAR.HideAllAnchorTarget()
  for i = 1, #actionBar_dockingWindow do
    actionBar_dockingWindow[i]:Show(false)
  end
  for _, widget in pairs(actionBar_dockingWindow) do
    widget:Show(false)
  end
end
function F_ACTIONBAR.ReleaseDocking(src)
  local widget = src.dockingTarget
  src.dockingTarget = nil
  if widget ~= nil then
    widget.dockedWidget = nil
  end
  local actionBarIndex = ActionBar_GetIndex(src)
  if actionBarIndex ~= nil then
    ActionBar_SetDockingTarget(actionBarIndex, nil)
  end
end
local function DoScreenDocking(widget, target)
  local x, y = widget:GetEffectiveOffset()
  local side = target.side
  widget:RemoveAllAnchors()
  local sx, sy, scx, scy = GetScreenSize()
  if side == "LEFT" then
    widget:AddAnchor("TOPLEFT", target, "TOPLEFT", 0, F_LAYOUT.CalcDontApplyUIScale(y - sy))
  elseif side == "RIGHT" then
    widget:AddAnchor("TOPRIGHT", target, "TOPRIGHT", 0, F_LAYOUT.CalcDontApplyUIScale(y - sy))
  elseif side == "TOP" then
    widget:AddAnchor("TOPLEFT", target, "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(x - sx), 0)
  else
    widget:AddAnchor("BOTTOMLEFT", target, "BOTTOMLEFT", F_LAYOUT.CalcDontApplyUIScale(x - sx), 0)
  end
end
function F_ACTIONBAR.TryDocking(src)
  local widgets = FindNearestScreenDockingTarget(src)
  for i = 1, #widgets do
    DoScreenDocking(src, widgets[i])
  end
end
