UIParent:LogAlways("loading ui load...")
if X2Player:GetFeatureSet().loadingTipOfDay then
  locale.loading.MakeTipsOfDay()
end
local gage = loading.mainWindow.gaugeWindow.loadingGauge
local loadingWindowEvents = {
  ENTERED_LOADING = function(worldImagePath)
    loading.mainWindow:Show(true)
    gage:SetValue(0)
    SetViewOfLoadingBg(worldImagePath)
    if X2Player:GetFeatureSet().loadingTipOfDay then
      local tip = loading.mainWindow.tip
      local randomIdx = math.floor(math.random(1, #locale.loading.tipsOfDay + 1))
      tip:SetText(locale.loading.tipsOfDay[randomIdx])
      tip:SetHeight(tip:GetTextHeight())
    end
  end,
  STILL_LOADING = function(loadingProgress)
    gage:SetMinMaxValues(0, 10000)
    if loadingProgress > 100 then
      loadingProgress = 0
    end
    gage:SetValue(loadingProgress * 100)
    loading.mainWindow.percent:SetText(string.format("%.0f%%", loadingProgress))
  end,
  LEFT_LOADING = function()
    loading.mainWindow:Show(false)
    loading.mainWindow.percent:SetText("0%%")
  end
}
gage:SetHandler("OnEvent", function(this, event, ...)
  loadingWindowEvents[event](...)
end)
gage:RegisterEvent("ENTERED_LOADING")
gage:RegisterEvent("STILL_LOADING")
gage:RegisterEvent("LEFT_LOADING")
gage:Show(true)
function loading.mainWindow:OnScale()
  self:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  self:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  if loading.bg ~= nil then
    ResizeLoadingBg(loading.bg)
  end
end
loading.mainWindow:SetHandler("OnScale", loading.mainWindow.OnScale)
UIParent:LogAlways("loading ui load end")
