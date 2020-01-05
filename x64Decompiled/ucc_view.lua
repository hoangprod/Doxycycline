local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local colors = {
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
ucc = nil
if uccLocale.useCategory == true then
  local categoryInfo = X2Ucc:GetUccCategoryInfo()
  if categoryInfo == nil then
    uccLocale.useCategory = false
  end
end
function DrawDefaultSlotBackground(widget)
  local slotBackground = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
  slotBackground:SetExtent(42, 42)
  widget.slotBackground = slotBackground
end
function GetUccUIText(originStr)
  return string.format([[
%s
%s%s]], originStr, FONT_COLOR_HEX.RED, GetUIText(COMMON_TEXT, "ucc_exception"))
end
function SetViewOfUCCWindow()
  ucc = {}
  ucc.window = CreateWindow("ucc.window", "UIParent")
  ucc.window:Show(false)
  ucc.window:AddAnchor("CENTER", "UIParent", 50, 50)
  ucc.window:SetTitle(locale.ucc.title)
  ucc.window:SetSounds("ucc")
  if uccLocale.useCategory then
    ucc.window:SetExtent(680, 665)
  else
    ucc.window:SetExtent(430, 615)
  end
  local parent = ucc.window
  ucc.previewWindow = CreateEmptyWindow("ucc.previewWindow", parent)
  ucc.previewWindow:Show(true)
  ucc.previewWindow:SetExtent(397, 293)
  if uccLocale.useCategory then
    ucc.previewWindow:AddAnchor("TOPRIGHT", parent, -18, titleMargin)
  else
    ucc.previewWindow:AddAnchor("TOP", parent, 1, titleMargin)
  end
  local previewWindow = ucc.previewWindow
  local bg = CreateContentBackground(ucc.previewWindow, "TYPE13")
  bg:AddAnchor("TOPLEFT", previewWindow, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", previewWindow, 0, 0)
  ucc.preview = CreateEmptyWindow("ucc.preview", previewWindow)
  ucc.preview:Show(true)
  ucc.preview:SetExtent(256, 256)
  ucc.preview:AddAnchor("CENTER", previewWindow, 0, 0)
  local horz_top_line = previewWindow:CreateDrawable(TEXTURE_PATH.UCC, "horizontal_line", "background")
  horz_top_line:AddAnchor("BOTTOM", ucc.preview, "TOP", 0, 0)
  local horz_bottom_line = previewWindow:CreateDrawable(TEXTURE_PATH.UCC, "horizontal_line", "background")
  horz_bottom_line:AddAnchor("TOP", ucc.preview, "BOTTOM", 10, 0)
  local vert_left_line = previewWindow:CreateDrawable(TEXTURE_PATH.UCC, "vertial_line", "background")
  vert_left_line:AddAnchor("RIGHT", ucc.preview, "LEFT", 0, -1)
  local vert_right_line = previewWindow:CreateDrawable(TEXTURE_PATH.UCC, "vertial_line", "background")
  vert_right_line:AddAnchor("TOPLEFT", ucc.preview, "TOPRIGHT", 0, 1)
  ucc.previewBg = ucc.preview:CreateThreeColorDrawable(1024, 1024, "background")
  ucc.previewBg:AddAnchor("TOPLEFT", ucc.preview, 0, 0)
  ucc.previewBg:AddAnchor("BOTTOMRIGHT", ucc.preview, 0, 0)
  ucc.previewBg:SetCoords(0, 0, 1024, 1024)
  ucc.previewBg:SetVisible(false)
  local bgWid, bgHgt = ucc.previewBg:GetExtent()
  ucc.previewBg:SetExtent(bgWid, bgHgt)
  ucc.previewFg = ucc.preview:CreateImageDrawable("Textures/Defaults/White.dds", "overlay")
  ucc.previewFg:SetExtent(bgWid * 0.5, bgHgt * 0.5)
  ucc.previewFg:AddAnchor("CENTER", ucc.preview, 0, 0)
  ucc.previewFg:SetVisible(false)
  ucc.previewFg:SetSRGB(true)
  ucc.sampleColor = {}
  for i = 1, 3 do
    ucc.sampleColor[i] = CreateEmptyButton("ucc.sampleColor" .. i, previewWindow)
    ucc.sampleColor[i]:Show(true)
    ucc.sampleColor[i]:SetExtent(32, 32)
    ucc.sampleColor[i]:AddAnchor("BOTTOMRIGHT", previewWindow, -(sideMargin * 1.5), 32 * (i - 4) + 15)
    ucc.sampleColor[i].bg = ucc.sampleColor[i]:CreateDrawable(TEXTURE_PATH.UCC, "icon_color", "background")
    ucc.sampleColor[i].bg:AddAnchor("TOPLEFT", ucc.sampleColor[i], 0, 0)
    ucc.sampleColor[i].bg:AddAnchor("BOTTOMRIGHT", ucc.sampleColor[i], 0, 0)
  end
  ucc.palletWindow = CreateEmptyWindow("ucc.palletWindow", parent)
  ucc.palletWindow:Show(false)
  ucc.palletWindow:SetExtent(288, 110)
  ucc.palletWindow:AddAnchor("LEFT", parent, "RIGHT", 0, -(sideMargin * 1.5))
  CreateTooltipDrawable(ucc.palletWindow)
  local closeBtn = ucc.palletWindow:CreateChildWidget("button", "closeBtn", 0, true)
  ApplyButtonSkin(closeBtn, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  closeBtn:AddAnchor("TOPRIGHT", ucc.palletWindow, -3, 3)
  ucc.pallet = CreateEmptyWindow("ucc.pallet", ucc.palletWindow)
  ucc.pallet:Show(true)
  ucc.pallet:SetExtent(256, 96)
  ucc.pallet:AddAnchor("TOPLEFT", ucc.palletWindow, 7, 7)
  ucc.pallet.colors = CreatePalletColors("ucc.color", ucc.pallet, colors, 16)
  ucc.bottomWindow = CreateEmptyWindow("ucc.bottomWindow", parent)
  ucc.bottomWindow:Show(true)
  if uccLocale.useCategory then
    ucc.bottomWindow:SetExtent(390, 245)
  else
    ucc.bottomWindow:SetExtent(390, 175)
  end
  ucc.bottomWindow:AddAnchor("TOP", previewWindow, "BOTTOM", 0, sideMargin / 2)
  local bottomWindow = ucc.bottomWindow
  ucc.patternWindow = W_CTRL.CreatePageControl("ucc.patternWindow", bottomWindow, "ucc_pattern")
  ucc.patternWindow:Show(true)
  ucc.patternWindow:RemoveAllAnchors()
  ucc.patternWindow:SetHeight(73)
  ucc.patternWindow:AddAnchor("TOPLEFT", bottomWindow, 0, 0)
  ucc.patternWindow:AddAnchor("TOPRIGHT", bottomWindow, 0, 0)
  ucc.patternWindow:SetTitleStyle(locale.ucc.patternTitle, "ucc")
  ucc.patternWindow.pagePerPatterns = 6
  local Setting_restBtn_tooltip = function(widget, target_text)
    function widget:OnEnter()
      SetTargetAnchorTooltip(locale.ucc.dont_use(target_text), "BOTTOMRIGHT", self, "TOPLEFT", 0, 2)
    end
    widget:SetHandler("OnEnter", widget.OnEnter)
    function widget:OnLeave()
      HideTooltip()
    end
    widget:SetHandler("OnLeave", widget.OnLeave)
  end
  local resetBtn = ucc.patternWindow:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:Show(true)
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.REMOVE)
  resetBtn:AddAnchor("TOPRIGHT", ucc.patternWindow, 0, -5)
  Setting_restBtn_tooltip(resetBtn, locale.ucc.pattern)
  local tencentUcc = baselibLocale.tencentUcc
  ucc.sampleWindow = W_CTRL.CreatePageControl("ucc.sampleWindow", bottomWindow, tencentUcc and "ucc_pattern" or "ucc_sample")
  ucc.sampleWindow:Show(true)
  ucc.sampleWindow:RemoveAllAnchors()
  ucc.sampleWindow:SetHeight(73)
  ucc.sampleWindow:AddAnchor("TOPLEFT", ucc.patternWindow, "BOTTOMLEFT", tencentUcc and 0 or 60, 15)
  ucc.sampleWindow:AddAnchor("TOPRIGHT", ucc.patternWindow, "BOTTOMRIGHT", 0, 15)
  ucc.sampleWindow:SetTitleStyle(locale.ucc.sampleTitle, "ucc")
  ucc.sampleWindow.pagePerSamples = tencentUcc and 6 or 5
  local resetBtn = ucc.sampleWindow:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:Show(true)
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.REMOVE)
  resetBtn:AddAnchor("TOPRIGHT", ucc.sampleWindow, 0, -5)
  Setting_restBtn_tooltip(resetBtn, locale.ucc.sample)
  ucc.userSample = CreateEmptyWindow("ucc.userSample", ucc.sampleWindow)
  ucc.userSample:Show(not tencentUcc)
  ucc.userSample:SetExtent(50, 50)
  ucc.userSample:AddAnchor("BOTTOMRIGHT", ucc.sampleWindow, "BOTTOMLEFT", -7, 2)
  local user_upload_icon = ucc.userSample:CreateDrawable(TEXTURE_PATH.UCC, "icon_user_upload", "artwork")
  user_upload_icon:AddAnchor("CENTER", ucc.userSample, 0, 0)
  ucc.userSample.texture = user_upload_icon
  DrawDefaultSlotBackground(ucc.userSample)
  ucc.userSample.slotBackground:SetExtent(50, 50)
  ucc.userSample.slotBackground:AddAnchor("CENTER", ucc.userSample, 0, 0)
  local info = {
    leftButtonStr = GetUIText(UCC_TEXT, "ok"),
    rightButtonStr = GetUIText(PORTAL_TEXT, "cancel"),
    buttonBottomInset = BUTTON_BASIC.DEFAULT.height + 10
  }
  CreateWindowDefaultTextButtonSet(parent, info, bottomWindow)
  if uccLocale.useCategory then
    ucc.categoryDesc = bottomWindow:CreateChildWidget("textbox", "categoryDesc", 0, true)
    ucc.categoryDesc.style:SetFontSize(FONT_SIZE.SMALL)
    ucc.categoryDesc:SetWidth(390)
    ucc.categoryDesc:SetHeight(FONT_SIZE.SMALL * 2 + 3)
    ucc.categoryDesc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    ucc.categoryDesc:AddAnchor("TOPRIGHT", ucc.sampleWindow, "BOTTOMRIGHT", 0, 14)
    ApplyTextColor(ucc.categoryDesc, FONT_COLOR.DEFAULT)
    ucc.categoryDesc:Show(true)
    ucc.category = W_CTRL.CreateScrollListBox("ucc.category", parent, parent)
    ucc.category:SetWidth(230)
    ucc.category:AddAnchor("TOPLEFT", parent, sideMargin, 38)
    ucc.category:AddAnchor("BOTTOMLEFT", parent, sideMargin, -20)
    ucc.category.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
    ucc.category.content:SetHeight(FONT_SIZE.MIDDLE)
    ucc.category.content.itemStyle:SetAlign(ALIGN_LEFT)
    ucc.category.content:SetTreeTypeIndent(true, 20, 20)
    ucc.category.content:UseChildStyle(true)
    ucc.category.content.childStyle:SetFontSize(FONT_SIZE.MIDDLE)
    ucc.category.content.childStyle:SetColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], FONT_COLOR.DEFAULT[4])
    ucc.category.content:EnableSelectParent(false)
    ucc.category:SetTreeImage()
    local line = ucc.category.content:CreateSeparatorImageDrawable(TEXTURE_PATH.DEFAULT, "background")
    line:SetTextureInfo("line_02", "default")
    line:SetExtent(170, 3)
  end
  local subscription_warning = bottomWindow:CreateChildWidget("textbox", "subscription_warning", 0, true)
  subscription_warning.style:SetFontSize(FONT_SIZE.SMALL)
  subscription_warning:SetWidth(390)
  subscription_warning:SetHeight(FONT_SIZE.SMALL)
  if tencentUcc then
    subscription_warning:SetText(GetUccUIText(GetUIText(UCC_TEXT, "tencent_subscription_warning")))
  else
    subscription_warning:SetText(GetUccUIText(GetUIText(UCC_TEXT, "subscription_warning")))
  end
  subscription_warning:SetHeight(subscription_warning:GetTextHeight())
  if uccLocale.useCategory then
    subscription_warning:AddAnchor("TOP", ucc.categoryDesc, "BOTTOM", 0, 14)
  else
    subscription_warning:AddAnchor("TOPRIGHT", ucc.sampleWindow, "BOTTOMRIGHT", 0, 14)
    ucc.bottomWindow:SetHeight(ucc.bottomWindow:GetHeight() + subscription_warning:GetHeight())
    local _, height = F_LAYOUT.GetExtentWidgets(ucc.window.titleBar, bottomWindow)
    ucc.window:SetHeight(height + ucc.window.leftButton:GetHeight() + MARGIN.WINDOW_SIDE * 1.5)
  end
  ApplyTextColor(subscription_warning, FONT_COLOR.DEFAULT)
end
