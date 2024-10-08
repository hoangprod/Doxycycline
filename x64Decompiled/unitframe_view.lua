local MAX_BUFF_COUNT = 32
local MAX_DEBUFF_COUNT = 24
local CreatePvpIconWidget = function(widget)
  local pvpIcon = widget:CreateChildWidget("emptywidget", "pvpIcon", 0, true)
  pvpIcon:Raise()
  local iconTexture = pvpIcon:CreateDrawable(TEXTURE_PATH.HUD, "pvp", "background")
  iconTexture:AddAnchor("CENTER", pvpIcon, 0, 0)
  pvpIcon:SetExtent(iconTexture:GetExtent())
  local OnEnter = function(self)
    SetTooltip(locale.unitFrame.pvpTip, self, true, true)
  end
  pvpIcon:SetHandler("OnEnter", OnEnter)
  return pvpIcon
end
function SetViewOfUnitFrame(id, parent, frameType)
  local w
  if parent == "UIParent" then
    w = CreateEmptyWindow(id, parent)
  else
    w = parent:CreateChildWidget("window", id, 0, true)
  end
  w:SetUILayer("game")
  local dynamicNameTable = {}
  w.dynamicNameTable = dynamicNameTable
  function w:FindDynamicNameTable(key)
    for k, v in pairs(self.dynamicNameTable) do
      if k == key then
        return v
      end
    end
    return nil
  end
  function w:AddDynamicNameTable(key, widget, offset)
    if self:FindDynamicNameTable(key) then
      return
    end
    dynamicNameTable[key] = {widget = widget, offset = offset}
  end
  function w:UpdateNameWidth()
    local textWidth = self.name.style:GetTextWidth(self.name:GetText()) + 2
    local spaceWidth = self:GetWidth()
    if frameType == UNIT_FRAME_TYPE.TARGET then
    end
    for k, v in pairs(self.dynamicNameTable) do
      widget = v.widget
      if widget:IsVisible() then
        spaceWidth = spaceWidth - widget:GetWidth() - v.offset
        if frameType == UNIT_FRAME_TYPE.TARGET then
        end
      end
    end
    if textWidth < spaceWidth then
      self.name:SetAutoResize(true)
      self.name:SetLimitWidth(false)
    else
      self.name:SetAutoResize(false)
      self.name:SetLimitWidth(true)
      self.name:SetWidth(spaceWidth)
    end
  end
  local level = W_UNIT.CreateLevelLabel(id .. ".level ", w)
  level:Show(true)
  level:AddAnchor("TOPLEFT", w, 0, 3)
  w.level = level
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.LEVEL, w.level, 5)
  local name = w:CreateChildWidget("label", "name", 0, true)
  name:SetExtent(90, FONT_SIZE.MIDDLE)
  name:AddAnchor("BOTTOMLEFT", level, "BOTTOMRIGHT", 3, 4)
  name:SetAutoResize(false)
  name:SetLimitWidth(true)
  name.style:SetAlign(ALIGN_LEFT)
  name.style:SetShadow(true)
  ApplyTextColor(name, FONT_COLOR.WHITE)
  local hpKey = "ship_status_board_hp_bg"
  local mpKey = "ship_status_board_hp_bg"
  local key = UNIT_FRAME_TEXTURE_KEY[frameType]
  if key ~= nil then
    hpKey = string.format("%s_hp_bg", key)
    mpKey = string.format("%s_mp_bg", key)
  end
  local gapHeight = level:GetHeight() + 5
  local hpBar = W_BAR.CreateStatusBarOfUnitFrame(id .. ".hpBar", w, "hp", hpKey)
  hpBar:AddAnchor("TOPLEFT", w, "TOPLEFT", 0, gapHeight)
  w.hpBar = hpBar
  local hpLabel = hpBar:CreateChildWidget("label", "hpLabel", 0, true)
  hpLabel:Show(false)
  hpLabel:AddAnchor("RIGHT", hpBar, -5, 0)
  hpLabel:SetAutoResize(true)
  hpLabel:SetHeight(FONT_SIZE.SMALL)
  hpLabel.style:SetAlign(ALIGN_RIGHT)
  hpLabel.style:SetFontSize(FONT_SIZE.SMALL)
  local mpBar = W_BAR.CreateStatusBarOfUnitFrame(id .. ".mpBar", w, "mp", mpKey)
  mpBar:AddAnchor("TOPLEFT", hpBar, "BOTTOMLEFT", 0, -2)
  w.mpBar = mpBar
  local mpLabel = mpBar:CreateChildWidget("label", "mpLabel", 0, true)
  mpLabel:Show(false)
  mpLabel:AddAnchor("RIGHT", mpBar, -5, 0)
  mpLabel:SetAutoResize(true)
  mpLabel:SetHeight(FONT_SIZE.SMALL)
  mpLabel.style:SetAlign(ALIGN_RIGHT)
  mpLabel.style:SetFontSize(FONT_SIZE.SMALL)
  local combatIcon = w:CreateDrawable(TEXTURE_PATH.HUD, "combat_bg", "background")
  combatIcon:SetVisible(false)
  combatIcon:AddAnchor("TOPLEFT", hpBar, -UNIT_FRAME_COMBAT_ICON_OFFSET, -UNIT_FRAME_COMBAT_ICON_OFFSET)
  combatIcon:AddAnchor("BOTTOMRIGHT", mpBar, UNIT_FRAME_COMBAT_ICON_OFFSET, UNIT_FRAME_COMBAT_ICON_OFFSET)
  w.combatIcon = combatIcon
  local buffWindow = W_UNIT.CreateBuffWindow(id .. ".buffWindow", w, MAX_BUFF_COUNT, "buff")
  buffWindow:Show(true)
  w.buffWindow = buffWindow
  local debuffWindow = W_UNIT.CreateBuffWindow(id .. ".debuffWindow", w, MAX_DEBUFF_COUNT, "debuff")
  debuffWindow:Show(true)
  debuffWindow:AddAnchor("TOPLEFT", w.buffWindow, "BOTTOMLEFT", 0, 0)
  w.debuffWindow = debuffWindow
  function w:ShowHiddenBuffWindow()
    if w.hiddenWindow == nil and X2Debug:GetDevMode() then
      local hiddenWindow = W_UNIT.CreateBuffWindow("hiddenWindow", w, 10, "hidden")
      hiddenWindow:Show(false)
      hiddenWindow:AddAnchor("TOPLEFT", w.debuffWindow, "BOTTOMLEFT", 0, 0)
      hiddenWindow:SetLayout(5, 24)
      w.hiddenWindow = hiddenWindow
    end
    if w.hiddenWindow then
      w.hiddenWindow:Show(not w.hiddenWindow:IsVisible())
    end
  end
  local eventWindow = CreateEmptyWindow(id .. ".eventWindow", w)
  eventWindow:AddAnchor("TOPLEFT", w, 0, 0)
  eventWindow:AddAnchor("BOTTOMRIGHT", w, 0, 0)
  eventWindow:Show(true)
  eventWindow:EnableDrag(true)
  w.eventWindow = eventWindow
  local leaderMark = W_ICON.CreateLeaderMark(id .. ".leaderMark", w)
  leaderMark:Show(false)
  leaderMark:AddAnchor("LEFT", name, "RIGHT", 3, 1)
  w.leaderMark = leaderMark
  local lootIcon = W_ICON.CreateLootIconWidget(w)
  lootIcon:Show(false)
  lootIcon:AddAnchor("LEFT", hpBar, "RIGHT", 3, 0)
  local pvpIcon = CreatePvpIconWidget(w)
  pvpIcon:Show(false)
  pvpIcon:AddAnchor("TOP", lootIcon, "BOTTOM", 0, 3)
  local marker = W_MARKER.CreateMarker(w)
  marker:SetVisible(false)
  marker:SetExtent(24, 24)
  w.marker = marker
  local heirIconInfo = {
    path = TEXTURE_PATH.MONEY_WINDOW,
    key = "successor",
    anchorOffset = {0, 0}
  }
  local dynamicNameOffset = 2
  local widgetKey = UNIT_FRAME_WIDGET.HEIR_WING
  local levelAnchorWidthOffset = 20
  if frameType == UNIT_FRAME_TYPE.PLAYER or frameType == UNIT_FRAME_TYPE.TARGET then
    heirIconInfo.path = TEXTURE_PATH.HUD
    heirIconInfo.key = "successor_frame"
    heirIconInfo.anchorOffset = {0, 37}
    widgetKey = UNIT_FRAME_WIDGET.HEIR_FRAME
    dynamicNameOffset = -36
    levelAnchorWidthOffset = 31
  end
  local heirIcon = eventWindow:CreateDrawable(heirIconInfo.path, heirIconInfo.key, "background")
  heirIcon:AddAnchor("BOTTOMLEFT", hpBar, "TOPLEFT", heirIconInfo.anchorOffset[1], heirIconInfo.anchorOffset[2])
  heirIcon:SetVisible(false)
  w.heirIcon = heirIcon
  w:AddDynamicNameTable(widgetKey, w.heirIcon, dynamicNameOffset)
  function w:ShowHeirIcon(heirLevel)
    local v = false
    local offsetX = 0
    if heirLevel ~= nil and heirLevel ~= 0 then
      v = true
      offsetX = levelAnchorWidthOffset
    end
    heirIcon:SetVisible(v)
    level:RemoveAllAnchors()
    level:AddAnchor("TOPLEFT", w, offsetX, 3)
  end
  function w:UpdateExtent()
    local width = w.hpBar:GetWidth()
    local height = w.hpBar:GetHeight() + 22
    if w.mpBar:IsVisible() then
      height = height + w.mpBar:GetHeight()
    end
    w:SetExtent(width, height)
  end
  w:UpdateExtent()
  return w
end
