function ModifierSetFunc(index, value)
  local unit = GetBeautyshopModelUnit()
  unit:ModifyFaceParamValue(index, value)
end
function ModifierGetFunc(index)
  local unit = GetBeautyshopModelUnit()
  return unit:GetFaceTargetCurValue(index)
end
function GetModiferUnitRace()
  local unit = GetBeautyshopModelUnit()
  return unit:GetRace()
end
function GetModiferUnitGender()
  local unit = GetBeautyshopModelUnit()
  return unit:GetGender()
end
CUSTOMIZING_FUNCTIONAL_INFO = {
  [HAIR_STYLE_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingHair(index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomHair()
    end,
    getCountFunc = X2Customizer.GetNumCustomHair,
    getInfoFunc = X2Customizer.GetCustomHairItem
  },
  [HAIR_COLOR_SELECT_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      local info = {index = index}
      unit:SetCustomizingHairDefaultColor(info)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local info = unit:GetCustomHairColor()
      if type(info) == "table" then
        return nil
      end
      return info
    end,
    getCountFunc = function()
      local unit = GetBeautyshopModelUnit()
      unit:InitCustomizerControl()
      return X2Customizer.GetNumCustomHairColor()
    end,
    getInfoFunc = function(_, index)
      return string.format("ui/login_stage/customizing/hair_color/hair_color_%02d.dds", index)
    end
  },
  [HAIR_COLOR_PALLET_TYPE] = {
    setFunc = function(r, g, b)
      local unit = GetBeautyshopModelUnit()
      local info = {
        defaultR = r,
        defaultG = g,
        defaultB = b
      }
      unit:SetCustomizingHairDefaultColor(info)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local info = unit:GetCustomHairColor()
      if type(info) == "table" then
        return info.defaultR, info.defaultG, info.defaultB
      end
      return nil
    end
  },
  [TWOTONE_COLOR_TYPE] = {
    setFunc = function(r, g, b, first, second)
      local unit = GetBeautyshopModelUnit()
      local info = {
        twoToneR = r,
        twoToneG = g,
        twoToneB = b,
        firstWidth = first / 100,
        secondWidth = second / 100
      }
      unit:SetCustomizingHairTwoToneColor(info)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local info = unit:GetCustomHairColor()
      if type(info) == "table" then
        if info.firstWidth == nil or info.secondWidth == nil then
          return nil
        end
        return info.twoToneR, info.twoToneG, info.twoToneB, math.floor(info.firstWidth * 100), math.floor(info.secondWidth * 100)
      end
      return nil
    end
  },
  [HORN_STYLE_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingHorn(index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomHorn()
    end,
    getCountFunc = X2Customizer.GetNumCustomHorn,
    getInfoFunc = X2Customizer.GetCustomHornItem
  },
  [HORN_COLOR_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingHornColor(index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomHornColor()
    end,
    getCountFunc = function()
      local unit = GetBeautyshopModelUnit()
      unit:InitCustomizerControl()
      return X2Customizer.GetNumCustomHornColor()
    end,
    getInfoFunc = function(_, index)
      local unit = GetBeautyshopModelUnit()
      unit:InitCustomizerControl()
      return X2Customizer:GetCustomHornColorItem(index)
    end
  },
  [WRINKLE_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingFaceNormal(index, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local index, weight = unit:GetCustomFaceNormal()
      if weight ~= nil then
        weight = math.floor(weight * 100)
      end
      return index, weight
    end,
    getCountFunc = X2Customizer.GetNumCustomizingFaceNormal,
    getInfoFunc = X2Customizer.GetCustomFaceNormalItem
  },
  [SKIN_COLOR_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingSkinColor(index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomSkinColor()
    end,
    getCountFunc = X2Customizer.GetNumCustomSkinColor,
    getInfoFunc = X2Customizer.GetCustomSkinColorItem
  },
  [EYEBROW_STYLE_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingEyebrow(index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomEyebrow()
    end,
    getCountFunc = X2Customizer.GetNumCustomizingEyebrow,
    getInfoFunc = X2Customizer.GetCustomEyebrowItem
  },
  [EYEBROW_COLOR_TYPE] = {
    setFunc = function(r, g, b)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingEyebrowColor(r, g, b)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomEyebrowColor()
    end
  },
  [PUPIL_CONDITION_TYPE] = {
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local wnd = GetCustomizingContent(PUPIL_CONDITION_TYPE)
      local idx = unit:GetCustomPupil(wnd.value)
      local r, g, b = unit:GetCustomPupilColor(wnd.value)
      return idx, r, g, b
    end,
    getInfoFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomizingOddEyeUsable()
    end
  },
  [PUPIL_STYLE_TYPE] = {
    setFunc = function(index, range)
      local unit = GetBeautyshopModelUnit()
      local parent = GetCustomizingContent(PUPIL_CONDITION_TYPE)
      unit:SetCustomizingPupil(index, parent.value)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local parent = GetCustomizingContent(PUPIL_CONDITION_TYPE)
      return unit:GetCustomPupil(parent.value)
    end,
    getCountFunc = X2Customizer.GetNumCustomizingPupil,
    getInfoFunc = X2Customizer.GetCustomPupilItem
  },
  [PUPIL_COLOR_TYPE] = {
    setFunc = function(r, g, b)
      local unit = GetBeautyshopModelUnit()
      local parent = GetCustomizingContent(PUPIL_CONDITION_TYPE)
      unit:SetCustomizingPupilColor(r, g, b, parent.value)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local parent = GetCustomizingContent(PUPIL_CONDITION_TYPE)
      return unit:GetCustomPupilColor(parent.value)
    end
  },
  [EYEMAKEUP_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingMakeUp(index, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local index, weight = unit:GetCustomMakeUp()
      if weight ~= nil then
        weight = math.floor(weight * 100)
      end
      return index, weight
    end,
    getCountFunc = X2Customizer.GetNumCustomizingMakeUp,
    getInfoFunc = X2Customizer.GetCustomMakeUpItem
  },
  [CHEEK_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingDeco(index, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local index, weight = unit:GetCustomDeco()
      if weight ~= nil then
        weight = math.floor(weight * 100)
      end
      return index, weight
    end,
    getCountFunc = X2Customizer.GetNumCustomizingDeco,
    getInfoFunc = X2Customizer.GetCustomDecoItem
  },
  [FACE_MAKEUP_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingDeco(index, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local index, weight = unit:GetCustomDeco()
      if weight ~= nil then
        weight = math.floor(weight * 100)
      end
      return index, weight
    end,
    getCountFunc = X2Customizer.GetNumCustomizingDeco,
    getInfoFunc = X2Customizer.GetCustomDecoItem
  },
  [LIPS_COLOR_TYPE] = {
    setFunc = function(r, g, b)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingLipColor(r, g, b)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomLipColor()
    end
  },
  [TATTO_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingTattoo(index, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local index, weight = unit:GetCustomTattoo()
      if weight ~= nil then
        weight = math.floor(weight * 100)
      end
      return index, weight
    end,
    getCountFunc = X2Customizer.GetNumCustomizingTattoo,
    getInfoFunc = X2Customizer.GetCustomTattooItem
  },
  [SCAR_STYLE_TYPE] = {
    setFunc = function(index, weight, x, y, scale, rotate)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingScar(index, x, y * 4, scale * 0.017 + 0.3, rotate * 3.6 - 180, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local scarIdx = unit:GetCustomScar()
      if scarIdx ~= nil then
        local info = unit:GetScarStatus()
        return scarIdx, info.weight * 100, info.x, info.y / 4, math.floor((info.scale - 0.3) / 0.017), math.floor((info.rotate + 180) / 3.6)
      end
      return nil
    end,
    getCountFunc = X2Customizer.GetNumCustomizingScar,
    getInfoFunc = X2Customizer.GetCustomScarItem
  },
  [BEARD_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      if weight == nil then
        weight = 1 or weight
      end
      unit:SetCustomizingDeco(index, weight)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomDeco()
    end,
    getCountFunc = X2Customizer.GetNumCustomizingDeco,
    getInfoFunc = X2Customizer.GetCustomDecoItem
  },
  [BEARD_COLOR_TYPE] = {
    setFunc = function(r, g, b)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingDecoColor(r, g, b)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomizingDecoColor()
    end
  },
  [MUSCLE_STYLE_TYPE] = {
    setFunc = function(index, weight)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingBodyNormal(index, weight / 100)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      local index, weight = unit:GetCustomBodyNormal()
      if weight ~= nil then
        weight = math.floor(weight * 100)
      end
      return index, weight
    end,
    getCountFunc = X2Customizer.GetNumCustomizingBodyNormal,
    getInfoFunc = X2Customizer.GetCustomBodyNormalItem
  },
  [TOTAL_PRESET_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:ApplyPresetParam(PRESET_TOTAL, index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetSelectedPresetIndex(PRESET_TOTAL)
    end,
    getCountFunc = function()
      return X2Customizer:GetPresetCount(PRESET_TOTAL)
    end,
    getInfoFunc = X2Customizer.GetTotalPresetItem
  },
  [EYE_PRESET_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:ApplyPresetParam(PRESET_EYE, index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetSelectedPresetIndex(PRESET_EYE)
    end,
    getCountFunc = function()
      local cnt = X2Customizer:GetPresetCount(PRESET_EYE)
      return X2Customizer:GetPresetCount(PRESET_EYE)
    end,
    getInfoFunc = X2Customizer.GetFacePresetEyeItem
  },
  [NOSE_PRESET_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:ApplyPresetParam(PRESET_NOSE, index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetSelectedPresetIndex(PRESET_NOSE)
    end,
    getCountFunc = function()
      return X2Customizer:GetPresetCount(PRESET_NOSE)
    end,
    getInfoFunc = X2Customizer.GetFacePresetNoseItem
  },
  [MOUTH_PRESET_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:ApplyPresetParam(PRESET_MOUTH, index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetSelectedPresetIndex(PRESET_MOUTH)
    end,
    getCountFunc = function()
      return X2Customizer:GetPresetCount(PRESET_MOUTH)
    end,
    getInfoFunc = X2Customizer.GetFacePresetLipItem,
    checkFunc = function(set)
      local unit = GetBeautyshopModelUnit()
      unit:SetSmile(set)
    end
  },
  [SHAPE_PRESET_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:ApplyPresetParam(PRESET_SHAPE, index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetSelectedPresetIndex(PRESET_SHAPE)
    end,
    getCountFunc = function()
      return X2Customizer:GetPresetCount(PRESET_SHAPE)
    end,
    getInfoFunc = X2Customizer.GetFacePresetShapeItem
  },
  [DRESS_PRESET_TYPE] = {
    setFunc = function(index)
      local unit = GetBeautyshopModelUnit()
      unit:SetCustomizingPreviewCloth(index)
    end,
    getFunc = function()
      local unit = GetBeautyshopModelUnit()
      return unit:GetCustomPreviewCloth()
    end,
    getCountFunc = X2Customizer.GetNumCustomizingPreviewCloth,
    getInfoFunc = X2Customizer.GetCustomPreviewClothItem
  }
}
