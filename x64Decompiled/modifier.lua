local MODIFIER_INFO = {
  [EYE_MODIFIER_TYPE] = {
    category = PRESET_EYE,
    list = {
      {
        "eye_Size",
        "eye_WidthLength",
        "eye_Length",
        "eye_Rotate"
      },
      {
        "eye_Zposition",
        "eye_Xposition",
        "eye_Yposition"
      },
      {
        "eye_SloeDown",
        "eye_Tail",
        "eye_LacrimalRotate",
        "eye_LacrimalCaruncle"
      },
      {
        "eye_Shape",
        "eye_EyelineZcenter",
        "eye_EyelineZinner",
        "eye_EyelineLowZcenter",
        "eye_LowShapeShallow"
      },
      {
        "eye_DoubleEyelidAngle",
        "eye_DoubleEyelidThickness",
        "eye_DoubleEyelidShape",
        "eye_DoubleEyelidYthicknes"
      },
      {
        "eye_LowerEyelid",
        "eye_EyeCoverVolume",
        "eye_Close",
        "eye_CloseR",
        "eye_CloseL",
        "eye_Smile",
        "eye_ShadowAdjust"
      },
      {
        "eye_IrisSize",
        "eye_PupilSize",
        "eye_PupilRotate",
        "eye_RotateUp",
        "eye_IrisRotateInOut",
        "eye_IrisRotateUpDown"
      },
      {
        "eye_BrowridgeDown",
        "eye_BrowRotate",
        "eye_BrowShape",
        "eye_SupraorbitalRidge"
      },
      {
        "eye_BrowXposition",
        "eye_BrowZposition",
        "eye_BrowThickness"
      },
      {
        "eye_Innerbrow",
        "eye_InnerbrowY",
        "eye_InnerbrowSpread",
        "eye_BridgeLength"
      },
      {
        "eye_InnerbrowLength",
        "eye_InnerbrowRotate",
        "eye_BrowLength",
        "eye_Forehead"
      }
    }
  },
  [NOSE_MODIFIER_TYPE] = {
    category = PRESET_NOSE,
    list = {
      {
        "nose_YShape",
        "nose_Size",
        "nose_Width",
        "nose_Length",
        "nose_Height",
        "nose_AllElevation"
      },
      {
        "nose_SeptonasalTractus",
        "nose_SeptumZposition",
        "nose_SeptonasalAxialPosition",
        "nose_AlarNasi"
      },
      {
        "nose_AlarVolume",
        "nose_AlarReduction",
        "nose_AlarHeight",
        "nose_AlarDepth",
        "nose_AlarZposition"
      },
      {
        "nose_SeptonasalVolume",
        "nose_SeptonasalVolumeTy2",
        "nose_Nostril",
        "nose_TipWidth",
        "nose_dw_SeptumVol"
      },
      {
        "nose_TipRotate",
        "nose_NasalBoneElevation",
        "nose_NasalBoneVolume"
      },
      {
        "nose_NasalUpperSideY",
        "nose_dw_NasalZposition",
        "nose_NasalBoneWidth",
        "nose_NasalUpperZ",
        "nose_End"
      }
    }
  },
  [MOUTH_MODIFIER_TYPE] = {
    category = PRESET_MOUTH,
    list = {
      {
        "mouth_Size",
        "mouth_Length"
      },
      {
        "mouth_Zposition",
        "mouth_Yposition",
        "mouth_Tail",
        "mouth_LiptailUpR",
        "mouth_LiptailUpL"
      },
      {
        "mouth_LipFoward",
        "mouth_UnderbiteOverbite"
      },
      {
        "mouth_LipClosedShape",
        "mouth_LipSideY",
        "mouth_Deform",
        "mouth_Shape"
      },
      {
        "mouth_UpperLipVolume",
        "mouth_LowerLipVolume",
        "mouth_LipDeform"
      },
      {
        "mouth_LipUpperWidth",
        "mouth_LipUpperShapeFlow",
        "mouth_UpperLipThickness",
        "mouth_LipUpperVol"
      },
      {
        "mouth_LipLowerShapeFlow",
        "mouth_LipLowerWidth",
        "mouth_LowerLipThickness",
        "mouth_LipLowerVol"
      },
      {
        "mouth_LipShapeLowY",
        "mouth_UpperLipOpen",
        "mouth_LowerLipOpen",
        "mouth_LipOpen",
        "mouth_LipShapeUpperWidth"
      },
      {
        "mouth_Open",
        "mouth_MouthOpen",
        "mouth_Rotate",
        "mouth_ToothWidth",
        "mouth_ToothZposition",
        "mouth_TeethZposition",
        "mouth_ToothSize",
        "mouth_ToothYposition"
      }
    }
  },
  [SHAPE_MODIFIER_TYPE] = {
    category = PRESET_SHAPE,
    list = {
      {
        "FS_Type",
        "FS_FaceSize",
        "FS_Size",
        "FS_AllLength",
        "FS_ZSize",
        "FS_Width",
        "FS_AllWidth",
        "FS_XSize"
      },
      {
        "FS_Beard1",
        "FS_Beard2",
        "FS_Beard3"
      },
      {
        "FS_JawHigh",
        "FS_SideWidth",
        "FS_Zposition"
      },
      {
        "FS_ForeheadWidth",
        "FS_FaceZ",
        "FS_Front"
      },
      {
        "FS_JawSize",
        "FS_JawShape",
        "FS_JawWidth",
        "FS_JawShapeZ",
        "FS_JawZposition",
        "FS_JawLength"
      },
      {
        "FS_JawShapeFlow",
        "FS_ChinZposition",
        "FS_JawZposition2"
      },
      {
        "FS_ChinVolume",
        "FS_ChinRotate",
        "FS_ChinYposition",
        "FS_SubmaxillaYposition"
      },
      {
        "FS_ChinWidth",
        "FS_NeckMeat",
        "FS_JawNeckVol"
      },
      {
        "FS_CheekboneVolume",
        "FS_CheekboneZ",
        "FS_ForeheadVolume",
        "FS_dw_CheekMeat\194\160",
        "FS_CheekMeat"
      },
      {
        "FS_dwEarSize",
        "FS_EarSize",
        "elf_ElfEar",
        "FS_EarDeform",
        "FS_EarRotate",
        "FS_EarRotateX",
        "elf_EarRotate"
      }
    }
  }
}
local GetModifierName = function(morphStr)
  return GetUIText(CUSTOMIZING_TEXT, morphStr)
end
function GetModifierList(cType)
  if MODIFIER_INFO[cType] == nil then
    return
  end
  local list = {}
  local infoList = MODIFIER_INFO[cType].list
  for i = 1, #infoList do
    for j = 1, #infoList[i] do
      list[#list + 1] = {
        morphStr = infoList[i][j]
      }
    end
  end
  local category = MODIFIER_INFO[cType].category
  local maxTargets = X2Customizer:GetNumFaceTargets(category)
  for i = 1, maxTargets do
    local targetIndex = X2Customizer:GetFaceTargetIndex(category, i - 1)
    local morphStr = X2Customizer:GetFaceTargetName(targetIndex)
    local found = false
    for j = 1, #list do
      if morphStr == list[j].morphStr then
        list[j].index = targetIndex
        list[j].name = GetModifierName(morphStr)
        list[j].minValue = X2Customizer:GetFaceTargetMinValue(targetIndex)
        list[j].maxValue = X2Customizer:GetFaceTargetMaxValue(targetIndex)
        found = true
        break
      end
    end
    if not found then
      list[#list + 1] = {
        morphStr = morphStr,
        index = targetIndex,
        name = GetModifierName(morphStr),
        minValue = X2Customizer:GetFaceTargetMinValue(targetIndex),
        maxValue = X2Customizer:GetFaceTargetMaxValue(targetIndex)
      }
    end
  end
  return list
end
