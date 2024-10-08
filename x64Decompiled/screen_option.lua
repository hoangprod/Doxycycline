local SetUIScale = function(value)
  if value ~= nil then
    UIParent:SetUIScale(tonumber(value), false)
  end
end
local GetDefaultUIScaleByResolution = function(screenWidth, screenHeight)
  if screenWidth < 1280 or screenHeight < 864 then
    return 0.85
  else
    return 1
  end
end
function SetDefaultUIScaleByResolution(screenWidth, screenHeight, immediatlyeApply)
  UIParent:SetUIScale(GetDefaultUIScaleByResolution(screenWidth, screenHeight), immediatlyeApply)
end
local function GetUIScaleDefaultValue()
  local curWidth = GetOptionItemValue(OPTION_ITEM_SCREEN_RESOLUTION_WIDTH)
  local curHeight = GetOptionItemValue(OPTION_ITEM_SCREEN_RESOLUTION_HEIGHT)
  return GetDefaultUIScaleByResolution(curWidth, curHeight)
end
local screenOptions = {
  {
    id = "ui_scale",
    default = 1,
    funcDefaultValue = GetUIScaleDefaultValue,
    saveLevel = OL_SYSTEM,
    funcOnChanged = SetUIScale
  }
}
RegisterOptionItem(screenOptions)
local MakeResolutionControl = function(frame)
  frame.resolutionOption = {}
  frame.resolutionOption[1] = OPTION_ITEM_SCREEN_RESOLUTION_WIDTH
  frame.resolutionOption[2] = OPTION_ITEM_SCREEN_RESOLUTION_HEIGHT
  local resolutionControl = frame:InsertNewOption("combobox", optionTexts.graphic.resolution)
  frame.resolutionControl = resolutionControl
  function resolutionControl:Init()
    local curWidth = GetOptionItemValue(frame.resolutionOption[1])
    local curHeight = GetOptionItemValue(frame.resolutionOption[2])
    self:Clear()
    self:SetVisibleItemCount(MAX_COMBOBOX_LIMIT_COUNT)
    local datas = {}
    local resolutionListCount = X2Option:GetResolutionCount()
    local selected = 0
    for i = 1, resolutionListCount do
      local width, height, bpp = X2Option:GetResolution(i)
      local data = {
        text = string.format("%d x %d", width, height),
        value = i
      }
      table.insert(datas, data)
      if width == curWidth and height == curHeight then
        selected = i
      end
    end
    self:AppendItems(datas, false)
    self:Select(selected)
  end
  function resolutionControl:Save()
    local resolutionIndex = self:GetSelectedIndex()
    if resolutionIndex == nil then
      return
    end
    local width, height, bpp = X2Option:GetResolution(resolutionIndex)
    local curWidth = GetOptionItemValue(frame.resolutionOption[1])
    local curHeight = GetOptionItemValue(frame.resolutionOption[2])
    if curWidth == width and curHeight == height then
      return
    end
    SetOptionItemValue(frame.resolutionOption[1], width)
    SetOptionItemValue(frame.resolutionOption[2], height)
    local selectedFullScreenWindowMode = frame.screenModeControl:GetChecked() == 3
    if selectedFullScreenWindowMode then
      width, height, bpp = X2Option:GetResolution(X2Option:GetResolutionCount())
    end
    SetDefaultUIScaleByResolution(width, height, true)
  end
end
local MakeScreenModeControl = function(frame)
  local screenModeControl = frame:InsertNewOption("radiobuttonV", optionTexts.graphic.screenMode)
  function screenModeControl:Init()
    local optionIndex = self:GetIndexByValue(GetOptionItemValue(OPTION_ITEM_FULLSCREEN))
    self:Check(optionIndex, false)
  end
  function screenModeControl:Save()
    local screenMode = self:GetCheckedData()
    SetOptionItemValue(OPTION_ITEM_FULLSCREEN, screenMode)
  end
  frame.screenModeControl = screenModeControl
end
local GammaValToControlVal = function(val)
  if val < 0.5 or val > 1.5 or val == nil then
    return nil
  end
  return (val - 0.5) * 100
end
local MakeRenderThreadControl = function(frame)
  local isSupported = UIParent:IsRenderThreadSupported()
  local checkRenderThread = frame:InsertNewOption("checkbox", optionTexts.graphic.renderThread, nil, OPTION_ITEM_RENDER_THREAD)
  checkRenderThread:Enable(isSupported)
  function checkRenderThread:Init()
    if isSupported then
      local enable = GetOptionItemValue(OPTION_ITEM_RENDER_THREAD)
      self:SetChecked(enable, false)
    else
      self:SetChecked(0, false)
    end
  end
  function checkRenderThread:Save()
    local value = self:GetChecked() and 1 or 0
    SetOptionItemValue(OPTION_ITEM_RENDER_THREAD, value)
  end
end
local MakeDirectXControl = function(frame)
  local IsDX11Supported = UIParent:IsDX11Supported()
  local directXControl = frame:InsertNewOption("radiobuttonH", optionTexts.graphic.directX)
  directXControl:Enable(IsDX11Supported)
  local function CheckRadioButton(dxMode)
    if IsDX11Supported then
      if dxMode == "DX9" then
        directXControl:Check(1, false)
      else
        directXControl:Check(2, false)
      end
    else
      directXControl:Check(1, false)
    end
  end
  function directXControl:UpdateValue(dataValue)
    if dataValue == nil then
      return
    end
    CheckRadioButton(dataValue)
  end
  function directXControl:Init()
    local dxMode = GetOptionItemValue(OPTION_ITEM_DIRECTX)
    CheckRadioButton(dxMode)
  end
  function directXControl:Save()
    local value = self:GetChecked()
    if value == 1 then
      SetOptionItemValue(OPTION_ITEM_DIRECTX, "DX9")
    else
      SetOptionItemValue(OPTION_ITEM_DIRECTX, "DX10")
    end
  end
end
local MakePixelSyncControl = function(frame)
  local pixelSyncControl = frame:InsertNewOption("checkbox", optionTexts.graphic.pixelSync, nil, OPTION_ITEM_PIXELSYNC)
  function pixelSyncControl:Init()
    local pixelSyncValue = GetOptionItemValue(OPTION_ITEM_PIXELSYNC)
    if pixelSyncValue == 6 then
      self:SetChecked(1, false)
    else
      self:SetChecked(0, false)
    end
  end
  function pixelSyncControl:Save()
    if self:GetChecked() then
      SetOptionItemValue(OPTION_ITEM_PIXELSYNC, 6)
    else
      SetOptionItemValue(OPTION_ITEM_PIXELSYNC, 0)
    end
  end
end
local ControlValToGammaVal = function(val)
  if val < 0 or val > 100 or val == nil then
    return nil
  end
  return val / 100 + 0.5
end
local function MakeGammaControl(frame)
  local gammaRangeText = {"-50", "50"}
  local gammaControl = frame:InsertNewOption("sliderbar", optionTexts.graphic.gamma, nil, OPTION_ITEM_GAMMA, nil, true)
  gammaControl:SetMinMaxValues(0, 100)
  gammaControl:SetValue(50, false)
  local width = gammaControl:GetExtent()
  gammaControl:SetWidth(width - 37)
  local gammaValLabel = W_CTRL.CreateLabel(".gammaValLabel", gammaControl)
  gammaValLabel:SetExtent(30, 20)
  gammaValLabel:AddAnchor("LEFT", gammaControl, "RIGHT", 5, 0)
  gammaValLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(gammaValLabel, FONT_COLOR.BLUE)
  gammaControl.gammaValLabel = gammaValLabel
  gammaValLabel.style:SetFontSize(FONT_SIZE.LARGE)
  function gammaControl:OnSliderChanged(arg)
    local controlValue = self:GetValue() or 0
    gammaValLabel:SetText(tostring(math.floor(controlValue - 50)))
  end
  gammaControl:SetHandler("OnSliderChanged", gammaControl.OnSliderChanged)
  function gammaControl:Init()
    local controlValue = GammaValToControlVal(GetOptionItemValue(OPTION_ITEM_GAMMA))
    controlValue = controlValue + 1.0E-4
    if controlValue ~= nil then
      gammaValLabel:SetText(tostring(math.floor(controlValue - 50)))
      self:SetValue(controlValue, false)
    end
  end
  function gammaControl:Save()
    local gammaValue = ControlValToGammaVal(math.floor(self:GetValue()))
    SetOptionItemValue(OPTION_ITEM_GAMMA, gammaValue)
  end
end
local minFpsLimit = 30
local maxFpsLimit = 150
local function LimitMaxFpsVal(val)
  if val < minFpsLimit then
    return minFpsLimit
  end
  if val > maxFpsLimit then
    return maxFpsLimit
  end
  return val
end
local function MakeMaxFpsControl(frame)
  local maxfpsControl = frame:InsertNewOption("sliderbar", optionTexts.graphic.maxfps, nil, OPTION_ITEM_MAXFPS, nil, true)
  maxfpsControl:SetMinMaxValues(minFpsLimit, maxFpsLimit)
  maxfpsControl:SetValue(120, false)
  local width = maxfpsControl:GetExtent()
  maxfpsControl:SetWidth(width - 37)
  local maxfpsValLabel = W_CTRL.CreateLabel(".maxfpsValLabel", maxfpsControl)
  maxfpsValLabel:SetExtent(30, 20)
  maxfpsValLabel:AddAnchor("LEFT", maxfpsControl, "RIGHT", 5, 0)
  maxfpsValLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(maxfpsValLabel, FONT_COLOR.BLUE)
  maxfpsValLabel.style:SetFontSize(FONT_SIZE.LARGE)
  local maxfpsChk = CreateCheckButton(".maxfpsChk", maxfpsControl, GetUIText(OPTION_TEXT, "option_window_full_screen"))
  maxfpsChk:AddAnchor("CENTER", maxfpsControl, "TOP", 0, -12)
  function maxfpsControl:OnSliderChanged(arg)
    local controlValue = self:GetValue() or 0
    maxfpsValLabel:SetText(tostring(math.floor(controlValue)))
  end
  maxfpsControl:SetHandler("OnSliderChanged", maxfpsControl.OnSliderChanged)
  function maxfpsControl:Init()
    local controlValue = LimitMaxFpsVal(GetOptionItemValue(OPTION_ITEM_MAXFPS))
    if controlValue ~= nil then
      self:SetValue(controlValue, false)
      maxfpsValLabel:SetText(tostring(math.floor(controlValue)))
    end
    maxfpsChk:SetChecked(GetOptionItemValue(OPTION_ITEM_USE_LIMIT_FPS))
  end
  function maxfpsControl:Save()
    local maxfpsValue = self:GetValue()
    SetOptionItemValue(OPTION_ITEM_MAXFPS, maxfpsValue)
    if maxfpsChk:GetChecked() == false then
      SetOptionItemValue(OPTION_ITEM_USE_LIMIT_FPS, 0)
    else
      SetOptionItemValue(OPTION_ITEM_USE_LIMIT_FPS, 1)
    end
  end
end
local MakeUiScaleControl = function(frame)
  local uiScaleControl = frame:InsertNewOption("sliderbar", optionTexts.graphic.uiScale)
  uiScaleControl:SetMinMaxValues(80, 120)
  uiScaleControl:SetValueStep(10)
  uiScaleControl:SetPageStep(10)
  uiScaleControl:SetValue(100, false)
  function uiScaleControl:Init()
    self.initValue = UIParent:GetUIScale()
    local scaleValue = F_LAYOUT.GetUIScaleValueByRealValue(self.initValue)
    self:SetValue(scaleValue, false)
    if X2:IsInClientDrivenZone() == true then
      self:Enable(false)
    end
  end
  function uiScaleControl:Save()
    local selectedValue = F_LAYOUT.GetUIScaleValueByOptionWindowValue(self:GetValue())
    if self.initValue ~= selectedValue then
      UIParent:SetUIScale(selectedValue, true)
    end
  end
  local scaleWarnMsg = uiScaleControl:GetParent():CreateChildWidget("textbox", "scaleWarnMsg", 0, true)
  scaleWarnMsg:SetHeight(50)
  scaleWarnMsg:SetWidth(uiScaleControl:GetWidth())
  scaleWarnMsg.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(scaleWarnMsg, FONT_COLOR.GRAY)
  scaleWarnMsg:SetText(GetCommonText("option_item_ui_scale_warn"))
  local anchorY = 10 + (scaleWarnMsg:GetLineCount() - 1) * (FONT_SIZE.MIDDLE / 2)
  uiScaleControl:AttachChildWidget(uiScaleControl.title, scaleWarnMsg, {
    "TOPLEFT",
    uiScaleControl,
    "BOTTOMLEFT",
    0,
    anchorY
  }, 8)
end
local MakeUiRelocateControl = function(frame)
  local uiRelocateControl = frame:InsertNewOption("textAndButton", optionTexts.graphic.uiRelocate)
  function uiRelocateControl:OnClick()
    uiRelocateControl.execute = true
    AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "ui_relocate_apply_msg"))
  end
  uiRelocateControl:SetHandler("OnClick", uiRelocateControl.OnClick)
  function uiRelocateControl:Init()
    uiRelocateControl.execute = false
  end
  function uiRelocateControl:Save()
    if uiRelocateControl.execute then
      ClearUISaveHandlers()
    end
  end
end
function CreateBasicScreenOptionFrame(parent, subFrameIndex)
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  local tooltips = {}
  local orgTooltipDataIdx = 1
  MakeResolutionControl(frame)
  MakeScreenModeControl(frame)
  frame:InsertNewOption("checkbox", optionTexts.graphic.sycVertical, nil, OPTION_ITEM_VSYNC)
  MakeRenderThreadControl(frame)
  MakeDirectXControl(frame)
  if X2Option:IsPixelSyncSupported() then
    MakePixelSyncControl(frame)
  end
  MakeGammaControl(frame)
  MakeMaxFpsControl(frame)
  if X2:IsEnteredWorld() then
    frame:InsertNewOption(OPTION_PARTITION_LINE)
    frame:InsertNewOption("radiobuttonV", optionTexts.graphic.cameraMode, nil, OPTION_ITEM_CAMERA_FOV_SET)
  end
  MakeUiScaleControl(frame)
  local featureSet = X2Player:GetFeatureSet()
  if featureSet ~= nil and featureSet.mateTypeSummon then
    MakeUiRelocateControl(frame)
  end
  function frame:SliderChangedProc()
    if frame.resolutionControl.HideDropDown ~= nil then
      frame.resolutionControl:HideDropDown()
    end
  end
  return frame
end
