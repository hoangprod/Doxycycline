function CreateEmptyWindow(id, parent, useTitleBar)
  FONT_PATH = {
    DEFAULT = "ui/font/yd_ygo540.ttf",
    SNAIL = "ui/font/SD_LeeyagiL.ttf"
  }
  FONT_SIZE = {
    SMALL = 11,
    MIDDLE = 13,
    LARGE = 15,
    XLARGE = 18,
    XXLARGE = 22
  }
  parent = parent or "UIParent"
  local window = UIParent:CreateWidget("window", id, parent)
  window.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  window.titleStyle:SetAlign(ALIGN_CENTER)
  window.titleStyle:SetColor(1, 1, 1, 1)
  window.titleStyle:SetSnap(true)
  function window:EnableUIAnimation()
    SetttingUIAnimation(self)
    self:ReleaseHandler("OnShow")
    function self:OnShow()
      self:SetStartAnimation(true, true)
      if self.ShowProc ~= nil then
        self:ShowProc()
      end
    end
    self:SetHandler("OnShow", self.OnShow)
  end
  function window:OnShow()
    if self.ShowProc ~= nil then
      self:ShowProc()
    end
  end
  window:SetHandler("OnShow", window.OnShow)
  return window
end
function ConvertColor(value)
  local color = value / 255
  return color
end
function ApplyTextColor(widget, color)
  widget.style:SetColor(color[1], color[2], color[3], color[4])
end
LOADING_UI_COLOR = {
  CONTENT = {
    ConvertColor(255),
    ConvertColor(223),
    ConvertColor(182),
    1
  },
  TIP = {
    ConvertColor(205),
    ConvertColor(154),
    ConvertColor(97),
    1
  },
  PERCENT = {
    ConvertColor(179),
    ConvertColor(103),
    ConvertColor(19),
    1
  }
}
loading = {}
local BG_WIDTH = 1920
local BG_HEIGHT = 1200
local PATH = "ui/gauge.dds"
loading.mainWindow = CreateEmptyWindow("loading.mainWindow", "UIParent")
loading.mainWindow:Show(false)
loading.mainWindow:AddAnchor("TOPLEFT", "UIParent", 0, 0)
loading.mainWindow:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
loading.mainWindow:SetUILayer("system")
function CalcDontApplyUIScale(value)
  return value / UIParent:GetUIScale()
end
function ResizeLoadingBg(bg)
  local SCREEN_WIDTH = UIParent:GetScreenWidth()
  local SCREEN_HEIGHT = UIParent:GetScreenHeight()
  if BG_WIDTH / BG_HEIGHT < SCREEN_WIDTH / SCREEN_HEIGHT then
    local new_height = math.floor(BG_HEIGHT * SCREEN_WIDTH / BG_WIDTH)
    if SCREEN_HEIGHT > new_height then
      new_height = SCREEN_HEIGHT
    end
    bg:SetExtent(CalcDontApplyUIScale(SCREEN_WIDTH), CalcDontApplyUIScale(new_height))
  else
    local new_width = math.floor(BG_WIDTH * SCREEN_HEIGHT / BG_HEIGHT)
    if SCREEN_WIDTH > new_width then
      new_width = SCREEN_WIDTH
    end
    bg:SetExtent(CalcDontApplyUIScale(new_width), CalcDontApplyUIScale(SCREEN_HEIGHT))
  end
  bg:AddAnchor("CENTER", "UIParent", 0, 0)
end
function SetViewOfLoadingBg(worldImagePath)
  if loading.bg == nil then
    loading.bg = loading.mainWindow:CreateImageDrawable(worldImagePath, "background")
    loading.bg:SetCoords(0, 0, BG_WIDTH, BG_HEIGHT)
    ResizeLoadingBg(loading.bg)
  else
    loading.bg:SetTexture(worldImagePath)
    ResizeLoadingBg(loading.bg)
  end
end
local bg = loading.mainWindow:CreateDrawable(PATH, "black_bg", "artwork")
bg:AddAnchor("TOPLEFT", loading.mainWindow, "BOTTOMLEFT", 0, -100)
bg:AddAnchor("BOTTOMRIGHT", loading.mainWindow, 0, 0)
local title = loading.mainWindow:CreateChildWidget("label", "title", 0, true)
title:SetAutoResize(true)
title:SetHeight(FONT_SIZE.XLARGE)
title:SetText(locale.loading.notice)
title:AddAnchor("BOTTOM", loading.mainWindow, 0, -90)
title.style:SetFont(FONT_PATH.SNAIL, FONT_SIZE.XLARGE)
title.style:SetAlign(ALIGN_CENTER)
ApplyTextColor(title, LOADING_UI_COLOR.CONTENT)
local gaugeWindow = loading.mainWindow:CreateChildWidget("emptywidget", "gaugeWindow", 0, true)
gaugeWindow:Show(true)
gaugeWindow:SetExtent(798, 22)
gaugeWindow:AddAnchor("TOP", title, "BOTTOM", 0, 5)
local bg = gaugeWindow:CreateDrawable(PATH, "gauge_bg", "artwork")
bg:AddAnchor("TOPLEFT", gaugeWindow, 0, 0)
bg:AddAnchor("BOTTOMRIGHT", gaugeWindow, 0, 0)
local loadingGauge = UIParent:CreateWidget("statusbar", gaugeWindow:GetId() .. ".loadingGauge", gaugeWindow)
loadingGauge:SetHeight(6)
loadingGauge:AddAnchor("LEFT", gaugeWindow, 6, 0)
loadingGauge:AddAnchor("RIGHT", gaugeWindow, -6, 0)
gaugeWindow.loadingGauge = loadingGauge
local gageDeco = loadingGauge:CreateDrawable(PATH, "gauge_top", "overlay")
gageDeco:AddAnchor("CENTER", gaugeWindow, 0, 0)
local info = UIParent:GetTextureData(PATH, "gauge_orange")
loadingGauge:SetBarTexture(PATH, "overlay")
loadingGauge:SetBarTextureCoords(info.coords[1], info.coords[2], info.coords[3], info.coords[4])
loadingGauge:SetOrientation("HORIZONTAL")
loadingGauge:SetBarColor(1, 1, 1, 1)
loadingGauge:SetMinMaxValues(0, 100)
loadingGauge:SetValue(0)
local percent = loading.mainWindow:CreateChildWidget("label", "percent", 0, true)
percent:SetExtent(0, FONT_SIZE.XLARGE)
percent:SetAutoResize(true)
percent:AddAnchor("LEFT", gaugeWindow, "RIGHT", 3, -1)
percent.style:SetFontSize(FONT_SIZE.XLARGE)
percent.style:SetAlign(ALIGN_LEFT)
ApplyTextColor(percent, LOADING_UI_COLOR.PERCENT)
if X2Player:GetFeatureSet().loadingTipOfDay then
  local tip = loading.mainWindow:CreateChildWidget("textbox", "tip", 0, true)
  tip:Show(true)
  tip:SetLineSpace(3)
  tip:AddAnchor("TOP", gaugeWindow, "BOTTOM", 0, 2)
  tip:AddAnchor("LEFT", loading.mainWindow, 0, 0)
  tip:AddAnchor("RIGHT", loading.mainWindow, 0, 0)
  tip.style:SetSnap(true)
  tip.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(tip, LOADING_UI_COLOR.TIP)
end
