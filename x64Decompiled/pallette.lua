W_PALLECT = {}
F_PALLECT = {}
palletWindow = nil
PALLET_DEFAULT_COLORS = {
  {
    246,
    151,
    122
  },
  {
    249,
    173,
    129
  },
  {
    253,
    197,
    137
  },
  {
    255,
    247,
    153
  },
  {
    196,
    223,
    155
  },
  {
    162,
    211,
    156
  },
  {
    130,
    202,
    156
  },
  {
    123,
    204,
    200
  },
  {
    110,
    207,
    246
  },
  {
    126,
    167,
    216
  },
  {
    132,
    147,
    202
  },
  {
    136,
    130,
    190
  },
  {
    161,
    135,
    190
  },
  {
    188,
    140,
    191
  },
  {
    244,
    154,
    194
  },
  {
    245,
    152,
    157
  },
  {
    242,
    108,
    78
  },
  {
    246,
    142,
    85
  },
  {
    251,
    175,
    92
  },
  {
    255,
    244,
    103
  },
  {
    171,
    211,
    114
  },
  {
    124,
    197,
    118
  },
  {
    59,
    184,
    1120
  },
  {
    26,
    187,
    180
  },
  {
    0,
    191,
    243
  },
  {
    67,
    140,
    202
  },
  {
    85,
    116,
    185
  },
  {
    96,
    92,
    168
  },
  {
    133,
    95,
    168
  },
  {
    167,
    99,
    168
  },
  {
    240,
    110,
    169
  },
  {
    242,
    109,
    124
  },
  {
    255,
    10,
    20
  },
  {
    255,
    96,
    21
  },
  {
    255,
    148,
    21
  },
  {
    255,
    241,
    0
  },
  {
    149,
    255,
    6
  },
  {
    0,
    238,
    33
  },
  {
    0,
    166,
    80
  },
  {
    0,
    169,
    156
  },
  {
    0,
    173,
    239
  },
  {
    0,
    114,
    188
  },
  {
    85,
    84,
    166
  },
  {
    0,
    4,
    192
  },
  {
    108,
    0,
    189
  },
  {
    185,
    0,
    179
  },
  {
    236,
    0,
    139
  },
  {
    255,
    2,
    84
  },
  {
    157,
    10,
    15
  },
  {
    160,
    65,
    13
  },
  {
    163,
    98,
    9
  },
  {
    171,
    160,
    0
  },
  {
    89,
    133,
    39
  },
  {
    26,
    122,
    48
  },
  {
    0,
    114,
    54
  },
  {
    0,
    115,
    107
  },
  {
    0,
    118,
    163
  },
  {
    0,
    75,
    128
  },
  {
    0,
    52,
    113
  },
  {
    27,
    20,
    100
  },
  {
    68,
    14,
    98
  },
  {
    99,
    4,
    96
  },
  {
    158,
    0,
    93
  },
  {
    157,
    0,
    57
  },
  {
    121,
    0,
    0
  },
  {
    123,
    46,
    0
  },
  {
    125,
    73,
    0
  },
  {
    130,
    122,
    0
  },
  {
    64,
    102,
    24
  },
  {
    0,
    94,
    32
  },
  {
    0,
    88,
    38
  },
  {
    0,
    89,
    82
  },
  {
    0,
    91,
    127
  },
  {
    0,
    54,
    99
  },
  {
    0,
    33,
    87
  },
  {
    13,
    0,
    76
  },
  {
    50,
    0,
    75
  },
  {
    75,
    0,
    73
  },
  {
    123,
    0,
    70
  },
  {
    121,
    0,
    38
  },
  {
    199,
    178,
    153
  },
  {
    152,
    134,
    117
  },
  {
    115,
    98,
    87
  },
  {
    83,
    71,
    65
  },
  {
    54,
    47,
    45
  },
  {
    197,
    156,
    109
  },
  {
    166,
    124,
    82
  },
  {
    140,
    98,
    57
  },
  {
    117,
    76,
    36
  },
  {
    96,
    57,
    19
  },
  {
    255,
    255,
    255
  },
  {
    194,
    194,
    194
  },
  {
    149,
    149,
    149
  },
  {
    70,
    70,
    70
  },
  {
    37,
    37,
    37
  },
  {
    0,
    0,
    0
  }
}
function CreatePalletColors(id, parent, colors, linePerColors)
  local item = {}
  for i = 1, #colors do
    local x = math.floor((i - 1) % linePerColors) * 16
    local y = math.floor((i - 1) / linePerColors) * 16
    item[i] = CreateEmptyButton(id .. i, parent)
    item[i]:SetExtent(16, 16)
    item[i]:AddAnchor("TOPLEFT", parent, x, y)
    local color = colors[i]
    item[i].color = item[i]:CreateColorDrawable(color[1] / 255, color[2] / 255, color[3] / 255, 1, "artwork")
    item[i].color:SetExtent(12, 12)
    item[i].color:AddAnchor("CENTER", item[i], 0, 0)
  end
  return item
end
local SetViewOfPopupPallet = function(id, parent)
  local window = CreateEmptyWindow(id .. ".palletWindow", parent)
  window:Show(false)
  window:SetExtent(290, 110)
  window.colors = {}
  CreateTooltipDrawable(window)
  local closeBtn = window:CreateChildWidget("button", "closeBtn", 0, true)
  closeBtn:AddAnchor("TOPRIGHT", window, -5, 5)
  ApplyButtonSkin(closeBtn, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  local content = CreateEmptyWindow(id .. ".pallet", window)
  content:Show(true)
  content:AddAnchor("TOPLEFT", window, 7, 7)
  content:AddAnchor("BOTTOMRIGHT", window, -17, -7)
  window.colors = CreatePalletColors(id .. ".colors", content, PALLET_DEFAULT_COLORS, 16)
  return window
end
function W_PALLECT.CreatePopupPallet(id, parent)
  local window = SetViewOfPopupPallet(id, parent)
  function window.closeBtn:OnClick(arg)
    local parent = window.closeBtn:GetParent()
    if arg == "LeftButton" then
      parent:Show(false)
    end
  end
  window.closeBtn:SetHandler("OnClick", window.closeBtn.OnClick)
  function window:SetSelectEventListenWidget(widget)
    self.selectEventListenWidget = widget
  end
  for i = 1, #window.colors do
    do
      local btn = window.colors[i]
      local color = window.colors[i].color:GetColor()
      function btn:OnClick()
        if window.selectEventListenWidget ~= nil and window.selectEventListenWidget.SelectedProcedure ~= nil then
          window.selectEventListenWidget:SelectedProcedure(color.r, color.g, color.b, color.a)
        end
        window:Show(false)
        palletWindow = nil
      end
      btn:SetHandler("OnClick", btn.OnClick)
    end
  end
  function window:OnHide()
    palletWindow = nil
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
function F_PALLECT.ShowPallet(target)
  if palletWindow == nil then
    palletWindow = W_PALLECT.CreatePopupPallet("defaultPallet[1]", "UIParent")
    palletWindow:SetUILayer("hud")
    palletWindow:SetCloseOnEscape(true)
  end
  palletWindow:RemoveAllAnchors()
  palletWindow:Show(true)
  palletWindow:AddAnchor("TOPLEFT", target, "TOPRIGHT", 2, 2)
  palletWindow.selectColor = nil
  palletWindow:SetSelectEventListenWidget(target)
  palletWindow:EnableHidingIsRemove(true)
  return palletWindow
end
function F_PALLECT.HidePallet()
  if palletWindow ~= nil then
    palletWindow:Show(false)
  end
end
function W_PALLECT.CreatePallette(id, parent, colorCodeStyle)
  local palletHeight = 95
  local frame = parent:CreateChildWidget("emptywidget", id .. "frame", 0, true)
  frame:Show(true)
  frame:SetExtent(315, palletHeight + DEFAULT_SIZE.EDIT_HEIGHT + 10)
  local pallette = parent:CreateChildWidget("paintcolorpicker", "pallette", 0, true)
  pallette:SetExtent(315, palletHeight)
  pallette:AddAnchor("TOPLEFT", frame, 0, 0)
  local spectrum = pallette:GetSpectrumWidget()
  spectrum:SetExtent(285, pallette:GetHeight())
  pallette.spectrum = spectrum
  local texturePath = LOGIN_STAGE_TEXTURE_PATH.COLOR_PALETTE
  local spectrumBg = pallette:CreateDrawable(texturePath, "color_bg", "background")
  spectrumBg:AddAnchor("TOPLEFT", spectrum, 0, 0)
  spectrumBg:AddAnchor("BOTTOMRIGHT", spectrum, 0, 0)
  pallette:SetSpectrumBg(spectrumBg)
  local COLOR_PICKER = {
    drawableType = "drawable",
    path = texturePath,
    coordsKey = "color_picker",
    useSameTexture = true
  }
  local posButton = spectrum:CreateChildWidget("button", "posButton", 0, true)
  posButton:Show(true)
  posButton:Enable(true)
  posButton:AddAnchor("CENTER", spectrum, 0, 0)
  posButton:EnableDrag(true)
  ApplyButtonSkin(posButton, COLOR_PICKER)
  local luminance = pallette:GetLuminanceWidget()
  luminance:SetExtent(20, pallette:GetHeight())
  pallette.luminance = luminance
  local luminanceBg = pallette:CreateDrawable(texturePath, "color_bg", "background")
  luminanceBg:AddAnchor("TOPLEFT", luminance, 0, 0)
  luminanceBg:AddAnchor("BOTTOMRIGHT", luminance, 0, 0)
  pallette:SetLuminanceBg(luminanceBg)
  local LUMINANCE_PICKER = {
    drawableType = "drawable",
    path = texturePath,
    coordsKey = "saturation_picker",
    useSameTexture = true,
    drawableAnchor = {
      anchor = "RIGHT",
      x = 7,
      y = 0
    },
    width = 18,
    height = 12
  }
  local slider = CreateSlider(luminance:GetId() .. ".slider", luminance)
  slider:AddAnchor("TOPLEFT", luminance, 3, -5)
  slider:AddAnchor("BOTTOMRIGHT", luminance, -3, 5)
  slider:SetMinThumbLength(12)
  slider:SetOrientation(0)
  slider:SetMinMaxValues(0, 100)
  slider:SetInitialValue(50, false)
  ApplyButtonSkin(slider.thumb, LUMINANCE_PICKER)
  slider.bg:SetVisible(false)
  pallette.luminance.slider = slider
  local function CreateColorCodeFrame(id)
    local codeFrame = frame:CreateChildWidget("emptywidget", id, 0, true)
    codeFrame:Show(true)
    codeFrame:SetExtent(pallette:GetWidth(), DEFAULT_SIZE.EDIT_HEIGHT)
    if colorCodeStyle == "loginStage" then
      local bg = codeFrame:CreateDrawable(texturePath, "rgb_bg", "background")
      bg:AddAnchor("TOPLEFT", codeFrame, -5, -2)
      bg:AddAnchor("BOTTOMRIGHT", codeFrame, 5, 2)
    end
    local fontColor = F_COLOR.GetColor("light_gray", false)
    local function CreateColorEditbox(labelId, editboxId, text)
      local label = codeFrame:CreateChildWidget("label", labelId, 0, true)
      label:SetExtent(23, FONT_SIZE.MIDDLE)
      label:SetText(text)
      label.style:SetAlign(ALIGN_LEFT)
      local editbox = W_CTRL.CreateEdit(editboxId, codeFrame)
      editbox:SetExtent(50, DEFAULT_SIZE.EDIT_HEIGHT)
      editbox:AddAnchor("LEFT", label, "RIGHT", 0, 0)
      editbox:SetDigit(true)
      editbox:SetDigitMax(255)
      local cursorColor
      if colorCodeStyle == "default" then
        ApplyTextColor(label, FONT_COLOR.DEFAULT)
        ApplyTextColor(editbox, FONT_COLOR.TITLE)
        cursorColor = EDITBOX_CURSOR.DEFAULT
      elseif colorCodeStyle == "loginStage" then
        ApplyTextColor(label, fontColor)
        ApplyTextColor(editbox, fontColor)
        editbox.bg:SetTexture(texturePath)
        editbox.bg:SetTextureInfo("input_bg")
        cursorColor = EDITBOX_CURSOR.LOGIN_STAGE
      end
      editbox:SetCursorColor(cursorColor[1], cursorColor[2], cursorColor[3], cursorColor[4])
    end
    CreateColorEditbox("rLabel", "rEditbox", GetUIText(COMMON_TEXT, "color_code_red"))
    CreateColorEditbox("gLabel", "gEditbox", GetUIText(COMMON_TEXT, "color_code_green"))
    CreateColorEditbox("bLabel", "bEditbox", GetUIText(COMMON_TEXT, "color_code_blue"))
    local inset = 48
    codeFrame.rLabel:AddAnchor("LEFT", codeFrame, 0, 0)
    codeFrame.gLabel:AddAnchor("LEFT", codeFrame.rEditbox, "RIGHT", inset, 0)
    codeFrame.bLabel:AddAnchor("LEFT", codeFrame.gEditbox, "RIGHT", inset, 0)
    local function OnTextChanged(self)
      local r = tonumber(codeFrame.rEditbox:GetText())
      local g = tonumber(codeFrame.gEditbox:GetText())
      local b = tonumber(codeFrame.bEditbox:GetText())
      frame:L_SetColor(r, g, b)
      if frame.SetColorProc ~= nil then
        frame:SetColorProc(r, g, b)
      end
    end
    codeFrame.rEditbox:SetHandler("OnTextChanged", OnTextChanged)
    codeFrame.gEditbox:SetHandler("OnTextChanged", OnTextChanged)
    codeFrame.bEditbox:SetHandler("OnTextChanged", OnTextChanged)
    return codeFrame
  end
  local colorCodeFrame = CreateColorCodeFrame("colorCode")
  colorCodeFrame:AddAnchor("BOTTOMLEFT", frame, 0, 0)
  local _r, _g, _b = 0, 0, 0
  local function SetRGB(r, g, b)
    _r = r
    _g = g
    _b = b
  end
  local function SetColorEditbox(r, g, b)
    colorCodeFrame.rEditbox:SetText(tostring(r), false)
    colorCodeFrame.gEditbox:SetText(tostring(g), false)
    colorCodeFrame.bEditbox:SetText(tostring(b), false)
  end
  function frame:L_GetRGBColor()
    return pallette:GetRGBColor()
  end
  function frame:L_UpdateRGB()
    local specturamWitdh, specturamHeight = spectrum:GetExtent()
    local _, luminanceMax = slider:GetMinMaxValues()
    local hue = posButton.x / specturamWitdh
    local sat = 1 - posButton.y / specturamHeight
    local lum = 1 - slider:GetValue() / luminanceMax
    pallette:SetHLSColor(hue, lum, sat)
    local r, g, b = pallette:GetRGBColor()
    if _r == r and _g == g and _b == b then
      return
    end
    SetRGB(r, g, b)
    if frame.SetColorProc ~= nil then
      frame:SetColorProc(r, g, b)
    end
    SetColorEditbox(r, g, b)
  end
  local function SetPos(x, y)
    posButton:AddAnchor("CENTER", spectrum, "TOPLEFT", x, y)
    posButton.x = x
    posButton.y = y
  end
  function spectrum:OnUpdate(dt)
    if self:IsEnabled() == false then
      return
    end
    local mPos = {}
    mPos.x, mPos.y = X2Input:GetMousePos()
    local sOffset = {}
    sOffset.x, sOffset.y = spectrum:GetEffectiveOffset()
    local sExtent = {}
    sExtent.x, sExtent.y = spectrum:GetEffectiveExtent()
    local x = mPos.x - sOffset.x
    local y = mPos.y - sOffset.y
    if x < 0 or x > sExtent.x or y < 0 or y > sExtent.y then
      x = math.max(0, math.min(x, sExtent.x))
      y = math.max(0, math.min(y, sExtent.y))
      spectrum:ReleaseHandler("OnUpdate")
    end
    x = F_LAYOUT.CalcDontApplyUIScale(x)
    y = F_LAYOUT.CalcDontApplyUIScale(y)
    SetPos(x, y)
    frame:L_UpdateRGB()
  end
  local function OnMouseDown(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    if spectrum:IsEnabled() then
      spectrum:SetHandler("OnUpdate", spectrum.OnUpdate)
    end
    return true
  end
  posButton:SetHandler("OnMouseDown", OnMouseDown)
  spectrum:SetHandler("OnMouseDown", OnMouseDown)
  local function OnMouseUp(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    if spectrum:IsEnabled() then
      spectrum:ReleaseHandler("OnUpdate")
    end
  end
  posButton:SetHandler("OnMouseUp", OnMouseUp)
  spectrum:SetHandler("OnMouseUp", OnMouseUp)
  local function OnSliderChanged()
    frame:L_UpdateRGB()
  end
  slider:SetHandler("OnSliderChanged", OnSliderChanged)
  function frame:L_SetColor(r, g, b)
    if r == nil or g == nil or b == nil then
      return
    end
    SetRGB(r, g, b)
    pallette:SetRGBColor(r, g, b)
    local hue, lum, sat = pallette:GetHLSColor()
    local specturamWitdh, specturamHeight = spectrum:GetExtent()
    local _, luminanceMax = slider:GetMinMaxValues()
    local x = hue * specturamWitdh
    local y = (1 - sat) * specturamHeight
    local h = (1 - lum) * luminanceMax
    SetPos(x, y)
    slider:SetValue(h, false)
  end
  function frame:L_Init(r, g, b)
    self:L_SetColor(r, g, b)
    SetColorEditbox(r, g, b)
    if frame.SetColorProc ~= nil then
      frame:SetColorProc(r, g, b)
    end
  end
  function frame:L_SetEnable(enable)
    pallette:Enable(enable)
    pallette:SetAlpha(enable and 1 or 0.5)
  end
  return frame
end
