local antiAliasingOptions = {
  GetUIText(COMMON_TEXT, "not_use"),
  "FXAA type1 (sharp)",
  "FXAA type2 (smooth)",
  "PostAA",
  "MSAA 2x",
  "MSAA 4x",
  "MSAA 8x",
  "MSAA 8x",
  "MSAA 8xQ",
  "MSAA 16x",
  "MSAA 16xQ",
  "TXAA 2x",
  "TXAA 4x"
}
local imageBasedAntialisingCount = 4
local graphicQualityControl
local MASTERQUALITY_USERSET = 6
local defaultLevel = 4
function MakeBackgroundImg(startCtrl, lastCtrl)
  local bg = CreateContentBackground(startCtrl:GetParent(), "TYPE2", "brown")
  bg:RemoveAllAnchors()
  bg:AddAnchor("TOPLEFT", startCtrl, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", lastCtrl:GetParent(), 0, 0)
  startCtrl.bg = bg
end
function SetForceChangeSlider(sliderbarControl)
  function sliderbarControl:OnForceSliderControlVal(val)
    local minVal, maxVal = self:GetMinMaxValues()
    if val < minVal then
      val = minVal
    elseif maxVal < val then
      val = maxVal
    end
    self:SetValue(val, false)
  end
end
function SetSliderChangedFunc(sliderbarControl, changedFunc)
  function sliderbarControl:OnSliderChanged(arg)
    graphicQualityControl:OnRecvChanedValByOtherControl()
    if changedFunc ~= nil then
      changedFunc(arg)
    end
  end
  sliderbarControl:SetHandler("OnSliderChanged", sliderbarControl.OnSliderChanged)
end
function MakeAdvancedOptionSliderBar(parent, textInfo, optionId, isCfgVar, changedFunc)
  local sliderbarControl = parent:InsertNewOption("sliderbar", textInfo, true, optionId)
  sliderbarControl:SetMinMaxValues(1, #textInfo.controlStr)
  sliderbarControl:SetValueStep(1)
  sliderbarControl:SetPageStep(1)
  if sliderbarControl ~= nil then
    originalVal = nil
    function sliderbarControl:Init()
      originalVal = GetOptionItemValue(optionId)
      if originalVal ~= nil then
        self:SetValue(originalVal, false)
      end
      if optionId == OPTION_ITEM_SHADOW_DIST or optionId == OPTION_ITEM_SHADOW_CHAR_LOD or optionId == OPTION_ITEM_SHADOW_BG_LOD then
        local enable = GetOptionItemValue(OPTION_ITEM_ENABLE_SHADOW)
        enable = enable ~= nil and enable ~= 0
        self:SetEnable(enable)
        for k = 1, 4 do
          self.label[k]:Enable(enable)
        end
      end
      if optionId == OPTION_ITEM_WATER_QUALITY then
        local oceanSimulate = X2Option:HasOceanSimulateOption()
        self:Enable(not oceanSimulate)
      end
    end
    if isCfgVar == true then
      function sliderbarControl:CfgSave()
        local controlVal = math.floor(self:GetValue())
        SetOptionItemValue(optionId, controlVal)
      end
      function sliderbarControl:Save()
      end
    else
      function sliderbarControl:Save()
        local controlVal = math.floor(self:GetValue())
        SetOptionItemValue(optionId, controlVal)
      end
    end
    SetForceChangeSlider(sliderbarControl)
    SetSliderChangedFunc(sliderbarControl, changedFunc)
  end
  return sliderbarControl
end
local graphicQualityOptions = {
  {
    id = "MasterGrahicQuality",
    default = defaultLevel,
    saveLevel = OL_SYSTEM
  }
}
RegisterOptionItem(graphicQualityOptions)
function CreateGraphicQualitySection(parent)
  local initQualityLevel = defaultLevel
  if initQualityLevel > 2 then
    initQualityLevel = initQualityLevel + 1
  end
  local strOptionId = "MasterGrahicQuality"
  graphicQualityControl = parent:InsertNewOption("sliderbar", optionTexts.graphicAdvanced.allQuality, nil, strOptionId)
  graphicQualityControl:SetMinMaxValues(1, #optionTexts.graphicAdvanced.allQuality.controlStr)
  graphicQualityControl:SetValueStep(1)
  graphicQualityControl:SetPageStep(1)
  graphicQualityControl:SetValue(initQualityLevel, false)
  graphicQualityControl:GetParent().optionTitle.style:SetFontSize(FONT_SIZE.LARGE)
  MakeBackgroundImg(graphicQualityControl:GetParent(), graphicQualityControl)
  graphicQualityControl:GetParent().bg:SetTextureColor("blue_3")
  function graphicQualityControl:Init()
    self.originalValue = GetOptionItemValue(strOptionId)
    self:SetValue(self.originalValue, false)
  end
  function graphicQualityControl:MasterQualitySave()
    local value = math.floor(self:GetValue())
    SetOptionItemValue(strOptionId, value)
    if self.originalValue == MASTERQUALITY_USERSET then
      return
    end
    local nextSysSpecValue = self.originalValue
    if nextSysSpecValue > 2 then
      nextSysSpecValue = nextSysSpecValue - 1
    end
    if nextSysSpecValue == 5 then
      nextSysSpecValue = 4
    end
    SetOptionItemValue(OPTION_ITEM_GRAPHIC_QUALITY, nextSysSpecValue)
  end
  function graphicQualityControl:Save()
  end
  local oldControlValue
  function graphicQualityControl:OnSliderChanged(arg)
    if oldControlValue == self:GetValue() then
      return
    end
    local controlValue = self:GetValue() or 0
    self.originalValue = controlValue
    oldControlValue = controlValue
    if controlValue < MASTERQUALITY_USERSET then
      parent:NotifyChangedGraphicQaulityToCheckBox(controlValue)
      if controlValue > 2 then
        controlValue = controlValue - 1
      end
      parent:NotifyChangeGraphicQaulityToSlider(controlValue)
      parent:NotifyChangeGraphicQaulityToAntiAliasing(self.originalValue)
    end
  end
  graphicQualityControl:SetHandler("OnSliderChanged", graphicQualityControl.OnSliderChanged)
  function graphicQualityControl:OnRecvChanedValByOtherControl()
    oldControlValue = MASTERQUALITY_USERSET
    self:SetValue(MASTERQUALITY_USERSET, false)
  end
end
function CreateTextureSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitleTexture)
  MakeAdvancedOptionSliderBar(parent, optionTexts.graphicAdvanced.sceneryQuality, OPTION_ITEM_BG_QUALITY, true)
  local last = MakeAdvancedOptionSliderBar(parent, optionTexts.graphicAdvanced.characterQuality, OPTION_ITEM_CHAR_QUALITY, true)
  MakeBackgroundImg(start, last)
end
function CreateDetailSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitleDetail)
  local sectionSliderTable = {
    {
      optionTexts.graphicAdvanced.cameraDistance,
      OPTION_ITEM_VIEW_DST
    },
    {
      optionTexts.graphicAdvanced.terrainDistance,
      OPTION_ITEM_DETAIL_TERRAIN_VIEW_DST_Z
    },
    {
      optionTexts.graphicAdvanced.terrainLOD,
      OPTION_ITEM_TERRAIN_LOD
    },
    {
      optionTexts.graphicAdvanced.objectDistance,
      OPTION_ITEM_OBJECT_VIEW_DST_RATIO
    },
    {
      optionTexts.graphicAdvanced.grassDistance,
      OPTION_ITEM_VEGETATION_VIEW_DST_RATIO
    },
    {
      optionTexts.graphicAdvanced.characterLOD,
      OPTION_ITEM_CAHR_LOD
    },
    {
      optionTexts.graphicAdvanced.animationLOD,
      OPTION_ITEM_ANIMATION_LOD
    }
  }
  local last
  for i = 1, #sectionSliderTable do
    last = MakeAdvancedOptionSliderBar(parent, sectionSliderTable[i][1], sectionSliderTable[i][2], true)
  end
  MakeBackgroundImg(start, last)
end
function CreateShadowSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitleShadow)
  parent.checkBoxContrls[OPTION_ITEM_ENABLE_SHADOW] = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.activeShadow, nil, OPTION_ITEM_ENABLE_SHADOW)
  local function OnShadowEnableClick(self, arg)
    parent:EnableShadowSliders(not self:GetChecked())
  end
  parent.checkBoxContrls[OPTION_ITEM_ENABLE_SHADOW]:SetHandler("OnClick", OnShadowEnableClick)
  local sectionSliderTable = {
    {
      optionTexts.graphicAdvanced.shadowDistance,
      OPTION_ITEM_SHADOW_DIST
    },
    {
      optionTexts.graphicAdvanced.characterShadow,
      OPTION_ITEM_SHADOW_CHAR_LOD
    },
    {
      optionTexts.graphicAdvanced.scenearyShadow,
      OPTION_ITEM_SHADOW_BG_LOD
    }
  }
  local shadowSliders = {}
  local last
  for i = 1, #sectionSliderTable do
    local slider = MakeAdvancedOptionSliderBar(parent, sectionSliderTable[i][1], sectionSliderTable[i][2], true)
    table.insert(shadowSliders, slider)
    last = slider
  end
  function parent:EnableShadowSliders(enable)
    for i = 1, #shadowSliders do
      local slider = shadowSliders[i]
      slider:SetEnable(enable)
      for k = 1, 4 do
        slider.label[k]:Enable(enable)
      end
    end
  end
  MakeBackgroundImg(start, last)
end
function CreateShaderSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitleShader)
  parent.checkBoxContrls[OPTION_ITEM_CLOUDS_EFFECT] = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.cloud, nil, OPTION_ITEM_CLOUDS_EFFECT)
  parent.checkBoxContrls[OPTION_ITEM_WEATHER_EFFECT] = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.weather, nil, OPTION_ITEM_WEATHER_EFFECT)
  local sectionSliderTable = {
    {
      optionTexts.graphicAdvanced.shaderQuailty,
      OPTION_ITEM_SHADER_QUALITY
    },
    {
      optionTexts.graphicAdvanced.volumeMatrix,
      OPTION_ITEM_VOLUMETRIC_EFFECT
    }
  }
  MakeAdvancedOptionSliderBar(parent, sectionSliderTable[1][1], sectionSliderTable[1][2], true)
  local volumetricControl = MakeAdvancedOptionSliderBar(parent, sectionSliderTable[2][1], sectionSliderTable[2][2], false)
  local last = volumetricControl
  function volumetricControl:CfgSave()
    local value = math.floor(self:GetValue())
    SetOptionItemValue(OPTION_ITEM_VOLUMETRIC_EFFECT, value)
    local useReflection = parent.checkBoxContrls[OPTION_ITEM_CLOUDS_EFFECT]:GetChecked()
    SetOptionItemValue(OPTION_ITEM_CLOUDS_EFFECT, useReflection)
    local useWeather = parent.checkBoxContrls[OPTION_ITEM_WEATHER_EFFECT]:GetChecked()
    SetOptionItemValue(OPTION_ITEM_WEATHER_EFFECT, useWeather)
  end
  function volumetricControl:Save()
  end
  MakeBackgroundImg(start, last)
end
function CreateEffectSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitleEffect)
  parent.checkBoxContrls[OPTION_ITEM_WEAPON_EFFECT] = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.weaponEffect, nil, OPTION_ITEM_WEAPON_EFFECT)
  local function OnChanged(value)
    if value < 3 then
      parent.checkBoxContrls[OPTION_ITEM_WEAPON_EFFECT]:SetChecked(false)
    elseif value > 2 then
      parent.checkBoxContrls[OPTION_ITEM_WEAPON_EFFECT]:SetChecked(true)
    end
  end
  local last = MakeAdvancedOptionSliderBar(parent, optionTexts.graphicAdvanced.effectQuailty, OPTION_ITEM_EFFECT_QUALITY, true, OnChanged)
  if not X2:IsEnteredWorld() then
    last:GetParent():RemoveAllAnchors()
    last:GetParent():AddAnchor("TOPLEFT", start, "BOTTOMLEFT", 0, 0)
  end
  MakeBackgroundImg(start, last)
end
function CreateWaterSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitleWater)
  parent.checkBoxContrls[OPTION_ITEM_WATER_REFLECTION_EFFECT] = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.waterReflect, nil, OPTION_ITEM_WATER_REFLECTION_EFFECT)
  local last = MakeAdvancedOptionSliderBar(parent, optionTexts.graphicAdvanced.waterQuality, OPTION_ITEM_WATER_QUALITY, true)
  MakeBackgroundImg(start, last)
end
function CreatePostProcessSection(parent)
  local start = parent:InsertNewOption("subBigTitle", optionTexts.graphicAdvanced.subtitlePostprocess)
  local hdrControl = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.hdr, nil, OPTION_ITEM_HDR)
  local dofControl = parent:InsertNewOption("checkbox", optionTexts.graphicAdvanced.dof, nil, OPTION_ITEM_DOF)
  local antiAliasingControl = parent:InsertNewOption("combobox", optionTexts.graphicAdvanced.antiAliasing, nil, OPTION_ITEM_ANTI_ALIASING)
  parent.checkBoxContrls[OPTION_ITEM_HDR] = hdrControl
  parent.checkBoxContrls[OPTION_ITEM_DOF] = dofControl
  parent.antiAliasingControl = antiAliasingControl
  MakeBackgroundImg(start, antiAliasingControl)
  local gropCheckBox = {dofControl}
  function EnableGropCheckBox(enable)
    for i = 1, #gropCheckBox do
      gropCheckBox[i]:Enable(enable)
    end
  end
  function hdrControl:Init()
    local val = GetOptionItemValue(OPTION_ITEM_HDR)
    if val ~= nil then
      self.originalValue = val > 0
      self:SetChecked(self.originalValue, false)
      EnableGropCheckBox(self.originalValue)
    end
  end
  function hdrControl:Save()
    local isChecked = self:GetChecked()
    if isChecked then
      SetOptionItemValue(OPTION_ITEM_HDR, 1)
    else
      SetOptionItemValue(OPTION_ITEM_HDR, 0)
    end
  end
  function hdrControl:OnUpdateEnableGroup(enable)
    EnableGropCheckBox(enable)
    antiAliasingControl:Enable(enable)
  end
  function hdrControl:CheckBtnCheckChagnedProc(checked)
    if checked then
      dofControl:SetChecked(false, false)
    else
      antiAliasingControl:Select(1)
    end
    self:OnUpdateEnableGroup(checked)
    graphicQualityControl:OnRecvChanedValByOtherControl()
  end
  function dofControl:Init()
    local val = GetOptionItemValue(OPTION_ITEM_DOF)
    local isCheck = false
    if hdrControl:GetChecked() == true then
      isCheck = val > 0
    end
    if val ~= nil then
      self.originalValue = isCheck
      self:SetChecked(self.originalValue, false)
    end
  end
  function dofControl:Save()
    local hdrChecked = hdrControl:GetChecked()
    if hdrChecked then
      local dofVal = self:GetChecked() == true and 1 or 0
      SetOptionItemValue(OPTION_ITEM_DOF, dofVal)
    else
      SetOptionItemValue(OPTION_ITEM_DOF, 0)
    end
  end
  local tableOfAAFormat = {
    {
      samples = 2,
      quality = 0,
      txaa = 0,
      configValue = 5
    },
    {
      samples = 4,
      quality = 0,
      txaa = 0,
      configValue = 6
    },
    {
      samples = 8,
      quality = 0,
      txaa = 0,
      configValue = 7
    },
    {
      samples = 4,
      quality = 8,
      txaa = 0,
      configValue = 8
    },
    {
      samples = 8,
      quality = 8,
      txaa = 0,
      configValue = 9
    },
    {
      samples = 4,
      quality = 16,
      txaa = 0,
      configValue = 10
    },
    {
      samples = 8,
      quality = 16,
      txaa = 0,
      configValue = 11
    },
    {
      samples = 2,
      quality = 0,
      txaa = 1,
      configValue = 12
    },
    {
      samples = 4,
      quality = 0,
      txaa = 1,
      configValue = 13
    }
  }
  function antiAliasingControl:Init()
    self:Clear()
    local datas = {}
    local hdrOn = GetOptionItemValue(OPTION_ITEM_HDR)
    for i = 1, imageBasedAntialisingCount do
      if hdrOn == 0 and i == imageBasedAntialisingCount then
        break
      else
        local data = {
          text = antiAliasingOptions[i],
          value = #datas + 1,
          color = FONT_COLOR.DEFAULT,
          disableColor = FONT_COLOR.GRAY,
          useColor = true,
          enable = true
        }
        table.insert(datas, data)
      end
    end
    if hdrOn == 1 then
      local AAFormats = X2Option:EnumAAFormats()
      for i = 1, #AAFormats do
        for j = 1, #tableOfAAFormat do
          if AAFormats[i].samples == tableOfAAFormat[j].samples and AAFormats[i].quality == tableOfAAFormat[j].quality and AAFormats[i].txaa == tableOfAAFormat[j].txaa then
            local data = {
              text = antiAliasingOptions[j + imageBasedAntialisingCount],
              value = tableOfAAFormat[j].configValue
            }
            table.insert(datas, data)
          end
        end
      end
    end
    self:AppendItems(datas, false)
    self:SetVisibleItemCount(MAX_COMBOBOX_LIMIT_COUNT)
    self:SetEnable(hdrOn)
    local index = self:GetIndexByValue(GetOptionItemValue(OPTION_ITEM_ANTI_ALIASING))
    self:Select(index ~= 0 and index or 1)
  end
  function antiAliasingControl:Save()
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    SetOptionItemValue(OPTION_ITEM_ANTI_ALIASING, info.value)
  end
  function antiAliasingControl:SelectedProc()
    graphicQualityControl:OnRecvChanedValByOtherControl()
  end
end
local checkBoxItems = {
  OPTION_ITEM_ENABLE_SHADOW,
  OPTION_ITEM_CLOUDS_EFFECT,
  OPTION_ITEM_WATER_REFLECTION_EFFECT,
  OPTION_ITEM_HDR,
  OPTION_ITEM_DOF,
  OPTION_ITEM_WEAPON_EFFECT,
  OPTION_ITEM_WEATHER_EFFECT
}
local QualityLevelCheckBoxSet = {
  {
    true,
    false,
    false,
    false,
    false,
    false,
    false
  },
  {
    true,
    true,
    true,
    false,
    false,
    false,
    false
  },
  {
    true,
    true,
    true,
    true,
    true,
    false,
    true
  },
  {
    true,
    true,
    true,
    true,
    true,
    true,
    true
  },
  {
    true,
    true,
    true,
    true,
    true,
    true,
    true
  }
}
function SetChangedCheckBox(checkbox)
  function checkbox:OnCheckChanged()
    graphicQualityControl:OnRecvChanedValByOtherControl()
  end
  checkbox:SetHandler("OnCheckChanged", checkbox.OnCheckChanged)
end
function CreateAdvancedScreenOptionFrame(parent, subFrameIndex)
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  defaultLevel = X2Option:GetNextSysSpecFullValue()
  frame.needRestartOption = OPTION_ITEM_NEED_RESTART
  frame.checkBoxContrls = {}
  CreateGraphicQualitySection(frame)
  CreateTextureSection(frame)
  CreateDetailSection(frame)
  CreateShadowSection(frame)
  CreateShaderSection(frame)
  CreateEffectSection(frame)
  CreateWaterSection(frame)
  CreatePostProcessSection(frame)
  function frame:GetCheckBoxChecked(itemIndex)
    return self.checkBoxContrls[itemIndex]:GetChecked()
  end
  function frame:SetCheckBox(itemIndex, checked)
    if itemIndex == OPTION_ITEM_ENABLE_SHADOW then
      frame:EnableShadowSliders(checked)
    end
    return self.checkBoxContrls[itemIndex]:SetChecked(checked, false)
  end
  function frame:NotifyChangedGraphicQaulityToCheckBox(val)
    for i = 1, #checkBoxItems do
      self:SetCheckBox(checkBoxItems[i], QualityLevelCheckBoxSet[val][i])
    end
    self.checkBoxContrls[OPTION_ITEM_HDR]:OnUpdateEnableGroup(self:GetCheckBoxChecked(OPTION_ITEM_HDR))
  end
  function frame:NotifyChangeGraphicQaulityToSlider(val)
    for i = 1, #self.content.optionFrames do
      local control = self.content.optionFrames[i].optionControl
      if control ~= nil and control.OnForceSliderControlVal ~= nil then
        control:OnForceSliderControlVal(val)
      end
    end
  end
  function frame:NotifyChangeGraphicQaulityToAntiAliasing(val)
    local antiAliasing = {
      1,
      1,
      2,
      2,
      3
    }
    if frame.antiAliasingControl ~= nil then
      frame.antiAliasingControl:Select(antiAliasing[val], false)
    end
  end
  for idx, v in pairs(frame.checkBoxContrls) do
    if idx ~= OPTION_ITEM_HDR then
      SetChangedCheckBox(frame.checkBoxContrls[idx])
    end
    if idx == OPTION_ITEM_WEAPON_EFFECT then
      frame.checkBoxContrls[idx]:GetParent():Show(X2:IsEnteredWorld())
    end
  end
  function frame:IsExistWarning()
    local needRestart = X2Option:GetModifiedRestartOption()
    if needRestart == true then
      return true
    end
    return false
  end
  function frame:ShowWarningMessage()
    local function DialogNoticeHandler(wnd)
      wnd:SetTitle(locale.common.warning)
      wnd:SetContent(GetUIText(OPTION_TEXT, "option_window_graphic_change_quality_alert"))
      function wnd:OkProc()
        return frame
      end
    end
    X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
  end
  function frame:Save()
    self:AdjustUserSetGraphicQuality()
    graphicQualityControl:MasterQualitySave()
    for i = 1, #self.content.optionFrames do
      if self.content.optionFrames[i].optionControl and self.content.optionFrames[i].optionControl.CfgSave ~= nil then
        self.content.optionFrames[i].optionControl:CfgSave()
      end
    end
    for i = 1, #self.content.optionFrames do
      if self.content.optionFrames[i].optionControl and self.content.optionFrames[i].optionControl.Save ~= nil then
        self.content.optionFrames[i].optionControl:Save()
      end
    end
  end
  function frame:AdjustUserSetGraphicQuality()
    function GetCheckBoxesQualityLevel()
      local itemIndex, sameCount
      for i = 1, #QualityLevelCheckBoxSet do
        sameCount = 0
        for k = 1, #checkBoxItems do
          itemIndex = checkBoxItems[k]
          if self:GetCheckBoxChecked(itemIndex) == QualityLevelCheckBoxSet[i][k] then
            sameCount = sameCount + 1
          else
            break
          end
        end
        if sameCount == #checkBoxItems then
          return i
        end
      end
      return nil
    end
    function GetSliderBarsQualityLevel()
      local lastValue, control
      for i = 1, #self.content.optionFrames do
        control = self.content.optionFrames[i].optionControl
        if control and control ~= graphicQualityControl and control.controlType and control.controlType == "sliderbar" then
          if lastValue == nil then
            lastValue = control:GetValue()
          end
          if control:GetValue() ~= lastValue then
            return nil
          end
        end
      end
      return lastValue
    end
    local sliderBarsLevel = GetSliderBarsQualityLevel()
    if sliderBarsLevel == nil then
      graphicQualityControl:SetValue(MASTERQUALITY_USERSET, false)
      graphicQualityControl.originalValue = MASTERQUALITY_USERSET
      return
    end
    local checkBoxesLevel = GetCheckBoxesQualityLevel()
    if checkBoxesLevel == nil then
      graphicQualityControl:SetValue(MASTERQUALITY_USERSET, false)
      graphicQualityControl.originalValue = MASTERQUALITY_USERSET
      return
    end
    if sliderBarsLevel == 1 and checkBoxesLevel == 1 then
      graphicQualityControl:SetValue(1, false)
      graphicQualityControl.originalValue = 1
    elseif sliderBarsLevel == 2 and checkBoxesLevel == 2 then
      graphicQualityControl:SetValue(2, false)
      graphicQualityControl.originalValue = 2
    elseif sliderBarsLevel == 2 and checkBoxesLevel == 3 then
      graphicQualityControl:SetValue(3, false)
      graphicQualityControl.originalValue = 3
    elseif sliderBarsLevel == 3 and checkBoxesLevel > 3 then
      graphicQualityControl:SetValue(4, false)
      graphicQualityControl.originalValue = 4
    elseif sliderBarsLevel == 4 and checkBoxesLevel > 3 then
      graphicQualityControl:SetValue(5, false)
      graphicQualityControl.originalValue = 5
    else
      graphicQualityControl:SetValue(MASTERQUALITY_USERSET, false)
      graphicQualityControl.originalValue = MASTERQUALITY_USERSET
    end
  end
  return frame
end
