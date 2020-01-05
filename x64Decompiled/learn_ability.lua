local abilityLearnEffect
local imgCoordInfo = {
  ability_bg = {
    502,
    242,
    224,
    74
  },
  sword = {
    0,
    0,
    507,
    122
  },
  glow = {
    0,
    122,
    462,
    122
  },
  effect_smoke = {
    0,
    234,
    502,
    221
  },
  bg = {
    507,
    0,
    512,
    242
  }
}
local function CreaetLearnAbilityEffect(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  window:SetExtent(515, 242)
  window:AddAnchor("TOP", "UIParent", 0, 60)
  window:SetUILayer("system")
  window:Clickable(false)
  window:EnableHidingIsRemove(true)
  local imgframe = window:CreateChildWidget("emptyWidget", "imgframe", 0, true)
  imgframe:SetExtent(window:GetExtent())
  imgframe:AddAnchor("TOPLEFT", window, 0, 0)
  imgframe:Clickable(false)
  local bg = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "background")
  F_TEXTURE.ApplyCoordAndAnchor(bg, imgCoordInfo.bg, imgframe, 3, 0)
  local effectSmoke = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "artwork")
  F_TEXTURE.ApplyCoordAndAnchor(effectSmoke, imgCoordInfo.effect_smoke, imgframe, 0, 3)
  local glow = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "artwork")
  F_TEXTURE.ApplyCoordAndAnchor(glow, imgCoordInfo.glow, imgframe, 15, 36)
  local sword = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "overlay")
  F_TEXTURE.ApplyCoordAndAnchor(sword, imgCoordInfo.sword, imgframe, 19, 45)
  local abilityBg = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "overlay")
  F_TEXTURE.ApplyCoordAndAnchor(abilityBg, imgCoordInfo.ability_bg, imgframe, 172, 59)
  abilityIconDrawables = {}
  abilityIconDrawableBgs = {}
  local abilityIconPosX = {
    188,
    254,
    320
  }
  function window:CreateLearnedAbilityDrawable(isSwap, abilityInfos)
    for i = 1, 3 do
      abilityIconDrawables[i] = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "overlay")
      abilityIconDrawableBgs[i] = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "overlay")
      local coordInfo
      if abilityInfos[i] == nil then
        coordInfo = {
          GetTextureInfo(TEXTURE_PATH.LEARN_ABILITY, "icon_general"):GetCoords()
        }
      else
        keyStr = string.format("icon_%s", X2Ability:GetAbilityStr(abilityInfos[i]))
        coordInfo = {
          GetTextureInfo(TEXTURE_PATH.LEARN_ABILITY, keyStr):GetCoords()
        }
      end
      F_TEXTURE.ApplyCoordAndAnchor(abilityIconDrawables[i], coordInfo, imgframe, abilityIconPosX[i], 64)
      F_TEXTURE.ApplyCoordAndAnchor(abilityIconDrawableBgs[i], {
        697,
        376,
        65,
        60
      }, imgframe, abilityIconPosX[i], 64)
    end
    self:SetAbilityText(isSwap, isHigAbility, abilityInfos)
    self:CreateAbilityIconAnimInfos(abilityIconDrawables, abilityIconDrawableBgs)
    self:SetAnimInfos()
  end
  local abilityBg = imgframe:CreateEffectDrawable(TEXTURE_PATH.LEARN_ABILITY, "overlay")
  F_TEXTURE.ApplyCoordAndAnchor(abilityBg, imgCoordInfo.ability_bg, imgframe, 172, 59)
  local textFrame = window:CreateChildWidget("emptyWidget", "textFrame", 0, true)
  textFrame:AddAnchor("BOTTOM", window, "BOTTOM", 30, -70)
  textFrame:Show(false)
  textFrame:Clickable(false)
  local titleMsg = textFrame:CreateChildWidget("label", "titleMsg", 0, true)
  titleMsg:SetExtent(100, FONT_SIZE.XLARGE)
  titleMsg:AddAnchor("TOP", textFrame, 0, 0)
  titleMsg.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(titleMsg, FONT_COLOR.SOFT_YELLOW)
  titleMsg:Clickable(false)
  local infoMsg = textFrame:CreateChildWidget("label", "infoMsg", 0, true)
  infoMsg:SetExtent(titleMsg:GetWidth(), FONT_SIZE.LARGE)
  infoMsg:AddAnchor("TOP", titleMsg, "BOTTOM", 0, 5)
  infoMsg.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(infoMsg, FONT_COLOR.SOFT_YELLOW)
  infoMsg:Clickable(false)
  local width, height = F_LAYOUT.GetExtentWidgets(titleMsg, infoMsg)
  textFrame:SetExtent(width, height)
  function window:SetAbilityText(isSwap, isHigAbility, abilityInfos)
    local title = ""
    local info = ""
    if abilityInfos[2] and abilityInfos[3] == nil then
      local abilityName = X2Ability:GetAbilityStr(abilityInfos[2])
      local temp = locale.common.abilityNameWithStr(abilityName) or abilityName
      local result = string.format("[%s]", temp)
      title = X2Locale:LocalizeUiText(COMMON_TEXT, "learned_new_ability", result)
      info = GetCommonText("learned_new_ability_info_msg")
    end
    if isSwap or isSwap == false and abilityInfos[3] then
      local jobName = F_UNIT.GetPlayerJobName(abilityInfos[1], abilityInfos[2], abilityInfos[3])
      title = string.format("[%s]", jobName)
      info = X2Locale:LocalizeUiText(COMMON_TEXT, "had_job_msg", jobName)
    end
    titleMsg:SetText(title)
    infoMsg:SetText(info)
  end
  local swordImgMoveDist = imgCoordInfo.sword[3] / 4
  local allDrawableAnimInfos = {
    {
      effectDrawable = bg,
      animData = {
        {
          startTime = 1.1,
          playTime = 1.9,
          scale = {0.12, 1},
          color = {
            {
              1,
              1,
              1,
              0.12
            },
            {
              1,
              1,
              1,
              1
            }
          }
        }
      }
    },
    {
      effectDrawable = effectSmoke,
      animData = {
        {
          startTime = 2.3,
          playTime = 0.6,
          scale = {0.8, 1},
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 3.4,
          playTime = 0.4,
          scale = {1, 1.05},
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0.5
            }
          }
        }
      }
    },
    {
      effectDrawable = glow,
      animData = {
        {
          startTime = 2.1,
          playTime = 0.9,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        }
      }
    },
    {
      effectDrawable = sword,
      animData = {
        {
          startTime = 1.2,
          playTime = 0.3,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          },
          moveX = {
            -swordImgMoveDist,
            0
          }
        },
        {
          startTime = 1.5,
          playTime = 0.2,
          moveX = {0, -5}
        },
        {
          startTime = 1.7,
          playTime = 0.2,
          moveX = {-5, 0}
        }
      }
    },
    {
      effectDrawable = abilityBg,
      animData = {
        {
          startTime = 0,
          playTime = 0.2,
          scale = {0.8, 1},
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.4,
          playTime = 0.2,
          moveX = {0, 2}
        },
        {
          startTime = 1.6,
          playTime = 0.2,
          moveX = {-2, 0}
        }
      }
    }
  }
  function window:CreateAbilityIconAnimInfos(abilityIconInfos, abilityIconInfoBgs)
    local firsetIconInfos = {
      effectDrawable = abilityIconInfos[1],
      animData = {
        {
          startTime = 0.4,
          playTime = 0.3,
          scale = {1.2, 1},
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.4,
          playTime = 0.2,
          moveX = {0, 2}
        },
        {
          startTime = 1.6,
          playTime = 0.2,
          moveX = {-2, 0}
        }
      }
    }
    table.insert(allDrawableAnimInfos, firsetIconInfos)
    local firsetIconBg = {
      effectDrawable = abilityIconInfoBgs[1],
      animData = {
        {
          startTime = 1.2,
          playTime = 0.1,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              0.5
            }
          }
        },
        {
          startTime = 1.3,
          playTime = 0.5,
          color = {
            {
              1,
              1,
              1,
              0.5
            },
            {
              1,
              1,
              1,
              0
            }
          }
        }
      }
    }
    table.insert(allDrawableAnimInfos, firsetIconBg)
    local secondIconInfos = {
      effectDrawable = abilityIconInfos[2],
      animData = {
        {
          startTime = 0.6,
          playTime = 0.3,
          scale = {1.2, 1},
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.4,
          playTime = 0.2,
          moveX = {0, 2}
        },
        {
          startTime = 1.6,
          playTime = 0.2,
          moveX = {-2, 0}
        }
      }
    }
    table.insert(allDrawableAnimInfos, secondIconInfos)
    local secondIconBg = {
      effectDrawable = abilityIconInfoBgs[2],
      animData = {
        {
          startTime = 1.2,
          playTime = 0.1,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              0.5
            }
          }
        },
        {
          startTime = 1.3,
          playTime = 0.5,
          color = {
            {
              1,
              1,
              1,
              0.5
            },
            {
              1,
              1,
              1,
              0
            }
          }
        }
      }
    }
    table.insert(allDrawableAnimInfos, secondIconBg)
    local thirdIconInfos = {
      effectDrawable = abilityIconInfos[3],
      animData = {
        {
          startTime = 0.8,
          playTime = 0.3,
          scale = {1.2, 1},
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 1.4,
          playTime = 0.2,
          moveX = {0, 2}
        },
        {
          startTime = 1.6,
          playTime = 0.2,
          moveX = {-2, 0}
        }
      }
    }
    table.insert(allDrawableAnimInfos, thirdIconInfos)
    local thirdIconBg = {
      effectDrawable = abilityIconInfoBgs[3],
      animData = {
        {
          startTime = 1.2,
          playTime = 0.1,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              0.5
            }
          }
        },
        {
          startTime = 1.3,
          playTime = 0.5,
          color = {
            {
              1,
              1,
              1,
              0.5
            },
            {
              1,
              1,
              1,
              0
            }
          }
        }
      }
    }
    table.insert(allDrawableAnimInfos, thirdIconBg)
  end
  local allWidgetAnimInfos = {
    {
      widget = textFrame,
      animData = {
        {
          startTime = 1.4,
          playTime = 0.3,
          color = {
            {
              1,
              1,
              1,
              0
            },
            {
              1,
              1,
              1,
              1
            }
          }
        },
        {
          startTime = 3.8,
          playTime = 0.8,
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        }
      }
    },
    {
      widget = imgframe,
      animData = {
        {
          startTime = 3.8,
          playTime = 0.8,
          scale = {1, 1.1},
          color = {
            {
              1,
              1,
              1,
              1
            },
            {
              1,
              1,
              1,
              0
            }
          }
        }
      }
    }
  }
  local function HideWindow()
    window:Show(false)
  end
  function window:SetAnimInfos()
    F_ANIMATION.SetEffectDrawableAnimInfos(allDrawableAnimInfos)
    F_ANIMATION.SetWidgetAnimInfos(window, allWidgetAnimInfos, 5100, HideWindow)
  end
  local function OnEndFadeOut(self)
    local procNextEvent = window.procNextEvent
    window:ReleaseHandler("OnUpdate")
    window = nil
    abilityLearnEffect = nil
    if procNextEvent == true then
      StartNextImgEvent()
    end
  end
  window:SetHandler("OnEndFadeOut", OnEndFadeOut)
  local function OnEndFadeIn()
    F_ANIMATION.StartEffectDrawableAnimation(window, allDrawableAnimInfos, allWidgetAnimInfos)
  end
  window:SetHandler("OnEndFadeIn", OnEndFadeIn)
  return window
end
function ShowLearnAbilityEffect(isSwap)
  if abilityLearnEffect ~= nil then
    abilityLearnEffect.procNextEvent = false
    abilityLearnEffect:Show(false)
  end
  abilityLearnEffect = CreaetLearnAbilityEffect("learnAbilityEffect", "UIParent")
  abilityLearnEffect.procNextEvent = true
  local ab1 = X2Ability:GetAbilityFromView(1)
  local ab2 = X2Ability:GetAbilityFromView(2)
  local ab3 = X2Ability:GetAbilityFromView(3)
  abilityLearnEffect:CreateLearnedAbilityDrawable(isSwap, {
    ab1,
    ab2,
    ab3
  })
  abilityLearnEffect:Show(true)
  return true
end
