F_TEXTURE = {}
function F_TEXTURE.ApplyCoordAndAnchor(drawable, coord, target, x, y, extent)
  if drawable == nil or coord == nil then
    UIParent:Warning(string.format("[ERROR] failed apply coord"))
    return
  end
  drawable:SetCoords(coord[1], coord[2], coord[3], coord[4])
  if extent == nil then
    drawable:SetExtent(coord[3], coord[4])
  else
    drawable:SetExtent(extent[1], extent[2])
  end
  if target then
    drawable:AddAnchor("TOPLEFT", target, x, y)
  end
end
function F_TEXTURE.GetTextureInfo(path, key)
  local info = UIParent:GetTextureData(path, key)
  if info == nil then
    info = {
      coords = {
        -1,
        -1,
        -1,
        -1
      },
      extent = {-1, -1},
      inset = {
        0,
        0,
        0,
        0
      },
      colors = {},
      offset = {-1, -1}
    }
  end
  function info:ValidCoords(coords)
    local valid = false
    for i = 1, #coords do
      if coords[i] ~= -1 then
        valid = true
      end
    end
    return valid
  end
  function info:GetWidth()
    if info.extent == nil then
      return info.coords[3]
    else
      return info.extent[1]
    end
  end
  function info:GetHeight()
    if info.extent == nil then
      return info.coords[4]
    else
      return info.extent[2]
    end
  end
  function info:ValidOffset()
    for i = 1, #info.offset do
      if info.offset[i] == -1 then
        return false
      end
    end
    return true
  end
  function info:GetOffset()
    return info.offset
  end
  function info:GetExtent()
    if info.extent == nil then
      return info.coords[3], info.coords[4]
    else
      return info.extent[1], info.extent[2]
    end
  end
  function info:GetCoords()
    if not info:ValidCoords(info.coords) and X2:IsEnteredWorld() and ChatLog ~= nil then
      local str = string.format("[UI Error][Call by lua] Path: %s, Key: %s / invalid data, check coords", path, key)
      str = string.format([[
%s
coords: %d, %d, %d, %d]], str, info.coords[1], info.coords[2], info.coords[3], info.coords[4])
      ChatLog(str)
      UIParent:LogAlways(str)
    end
    return info.coords[1], info.coords[2], info.coords[3], info.coords[4]
  end
  function info:GetInset()
    return info.inset
  end
  function info:GetColors()
    return info.colors
  end
  return info
end
function GetTextureInfo(path, key)
  return F_TEXTURE.GetTextureInfo(path, key)
end
function CreateTooltipDrawable(widget)
  local bg = widget:CreateDrawable(TEXTURE_PATH.HUD, "tooltip_bg", "background")
  bg:AddAnchor("TOPLEFT", widget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.bg = bg
end
function DrawEffectActionBarBackground(actionBar)
  local bg = actionBar:CreateEffectDrawable(TEXTURE_PATH.HUD, "background")
  bg:SetVisible(false)
  bg:SetCoords(452, 0, 277, 51)
  bg:AddAnchor("TOPLEFT", actionBar, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", actionBar, 0, 0)
  bg:SetRepeatCount(1)
  actionBar.bg = bg
  actionBar.isvisibleBg = false
  function actionBar:OnEnterEffectSetting()
    self.bg:SetEffectPriority(1, "alpha", 0.5, 0.5)
    self.bg:SetEffectInitialColor(1, 1, 1, 1, 0)
    self.bg:SetEffectFinalColor(1, 1, 1, 1, 0.4)
    self.bg:SetStartEffect(true)
    self.isvisibleBg = true
  end
  function actionBar:OnLeaveEffectSetting()
    self.bg:SetEffectPriority(1, "alpha", 0.3, 0.3)
    self.bg:SetEffectInitialColor(1, 1, 1, 1, 0.4)
    self.bg:SetEffectFinalColor(1, 1, 1, 1, 0)
    self.bg:SetStartEffect(true)
    self.isvisibleBg = false
  end
end
function CreateLine(widget, styleType, layer)
  if layer == nil then
    layer = "background"
  end
  local styleTable = {
    TYPE1 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", layer)
      line:SetTextureColor("default")
      line:SetHeight(3)
      return line
    end,
    TYPE2 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.TAB_LIST, "tab_line_02_1", layer)
      line:SetHeight(5)
      local line2 = widget:CreateDrawable(TEXTURE_PATH.TAB_LIST, "tab_line_02_2", layer)
      line2:SetHeight(5)
      return line, line2
    end,
    TYPE3 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type3_line", layer)
      return line
    end,
    TYPE5 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.DEFAULT_NEW, "tab_line_reversal", layer)
      line:SetVisible(false)
      local line2 = widget:CreateDrawable(TEXTURE_PATH.DEFAULT_NEW, "tab_line", layer)
      return line, line2
    end,
    TYPE6 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.DEFAULT_NEW, "line", layer)
      line:SetHeight(1)
      return line
    end,
    TYPE7 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_02", layer)
      line:SetHeight(3)
      return line
    end,
    TYPE8 = function(widget, layer)
      local line = widget:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT, "line", layer)
      line:SetTextureColor("deepblue_alpha_15")
      line:SetHeight(2)
      return line
    end
  }
  return styleTable[styleType](widget, layer)
end
function DrawTargetLine(widget)
  local line = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line:SetTextureColor("target")
  line:SetExtent(0, 3)
  line:AddAnchor("TOPLEFT", widget, "BOTTOMLEFT", 0, 8)
  line:AddAnchor("TOPRIGHT", widget, "BOTTOMRIGHT", 0, 8)
  widget.line = line
end
function CreateContentBackground(widget, styleType, color, layer)
  if layer == nil then
    layer = "background"
  end
  local styleTable = {
    TYPE1 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_01", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE2 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE3 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_03", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE4 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_04", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE5 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_05", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE6 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_06", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE7 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.SUBZONE_SYSTEM, "type_07", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE8 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.ALARM_BG, "type_08", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE9 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_09", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE10 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_10", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE11 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE12 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type_12", layer)
      bg:SetTextureColor(color)
      return bg
    end,
    TYPE13 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.PAPER_DECO, "type_13", layer)
      return bg
    end,
    TYPE14 = function(widget, layer)
      local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type14", layer)
      bg:SetTextureColor(color)
      return bg
    end
  }
  return styleTable[styleType](widget, layer)
end
function CreateLoadingTextureSet(widget)
  local modalLoadingWindow = widget:CreateChildWidget("emptywidget", "modalLoadingWindow", 0, true)
  local bg = modalLoadingWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "modal_bg", "overlay")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", modalLoadingWindow, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", modalLoadingWindow, 0, 0)
  local effect = modalLoadingWindow:CreateEffectDrawable("ui/tutorials/loading.dds", "overlay")
  effect:SetVisible(false)
  effect:SetExtent(32, 32)
  effect:SetCoords(100, 1, 32, 32)
  effect:AddAnchor("CENTER", modalLoadingWindow, 0, 0)
  effect:SetRepeatCount(0)
  effect:SetEffectPriority(1, "rotate", 1.5, 1.5)
  effect:SetEffectRotate(1, 0, 360)
  modalLoadingWindow.effect = effect
  function widget:WaitPage(isShow)
    self.modalLoadingWindow:Show(isShow)
    self.modalLoadingWindow.effect:SetStartEffect(isShow)
    self.modalLoadingWindow:Raise()
  end
  function widget:WaitPageCont(isShow)
    local isVisible = self.modalLoadingWindow:IsVisible()
    self.modalLoadingWindow:Show(isShow)
    if isVisible ~= isShow then
      self.modalLoadingWindow.effect:SetStartEffect(isShow)
    end
    self.modalLoadingWindow:Raise()
  end
  return modalLoadingWindow
end
