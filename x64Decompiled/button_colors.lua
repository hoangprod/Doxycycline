function GetButtonDefaultFontColor()
  local color = {}
  color.normal = {
    ConvertColor(104),
    ConvertColor(68),
    ConvertColor(18),
    1
  }
  color.highlight = {
    ConvertColor(154),
    ConvertColor(96),
    ConvertColor(16),
    1
  }
  color.pushed = {
    ConvertColor(104),
    ConvertColor(68),
    ConvertColor(18),
    1
  }
  color.disabled = {
    ConvertColor(92),
    ConvertColor(92),
    ConvertColor(92),
    1
  }
  return color
end
function GetButtonDefaultFontColor_V2()
  local color = {}
  color.normal = FONT_COLOR.MIDDLE_TITLE
  color.highlight = FONT_COLOR.MIDDLE_TITLE
  color.pushed = FONT_COLOR.MIDDLE_TITLE
  color.disabled = FONT_COLOR.MIDDLE_TITLE
  return color
end
function GetTitleButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.MIDDLE_TITLE
  color.highlight = FONT_COLOR.MIDDLE_TITLE
  color.pushed = FONT_COLOR.MIDDLE_TITLE
  color.disabled = {
    0.3,
    0.3,
    0.3,
    0.3
  }
  return color
end
function GetBlueButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(67),
    ConvertColor(81),
    ConvertColor(98),
    1
  }
  color.highlight = {
    ConvertColor(59),
    ConvertColor(114),
    ConvertColor(135),
    1
  }
  color.pushed = {
    ConvertColor(67),
    ConvertColor(81),
    ConvertColor(98),
    1
  }
  color.disabled = {
    ConvertColor(92),
    ConvertColor(92),
    ConvertColor(92),
    1
  }
  return color
end
function GetWhiteButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(178),
    ConvertColor(178),
    ConvertColor(178),
    1
  }
  color.highlight = FONT_COLOR.WHITE
  color.pushed = {
    ConvertColor(150),
    ConvertColor(150),
    ConvertColor(150),
    1
  }
  color.disabled = {
    ConvertColor(178),
    ConvertColor(178),
    ConvertColor(178),
    0.3
  }
  return color
end
function GetOptionListButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.DEFAULT
  color.highlight = FONT_COLOR.BLUE
  color.pushed = FONT_COLOR.BLUE
  color.disabled = {
    0.3,
    0.3,
    0.3,
    1
  }
  return color
end
function GetOptionListKeyButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.WHITE
  color.highlight = {
    ConvertColor(125),
    ConvertColor(76),
    ConvertColor(7),
    1
  }
  color.pushed = FONT_COLOR.WHITE
  color.disabled = {
    0.3,
    0.3,
    0.3,
    1
  }
  return color
end
function GetOptionListOverrideKeyButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.WHITE
  color.highlight = FONT_COLOR.BLUE
  color.pushed = FONT_COLOR.BLUE
  color.disabled = {
    0.3,
    0.3,
    0.3,
    1
  }
  return color
end
function GetAbilityButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(170),
    ConvertColor(101),
    ConvertColor(49),
    1
  }
  color.highlight = {
    ConvertColor(55),
    ConvertColor(111),
    ConvertColor(143),
    1
  }
  color.pushed = {
    ConvertColor(55),
    ConvertColor(111),
    ConvertColor(143),
    1
  }
  color.disabled = {
    0.3,
    0.3,
    0.3,
    1
  }
  return color
end
function GetMyAbilityButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(107),
    ConvertColor(43),
    ConvertColor(112),
    1
  }
  color.highlight = {
    ConvertColor(134),
    ConvertColor(73),
    ConvertColor(139),
    1
  }
  color.pushed = FONT_COLOR.WHITE
  color.disabled = {
    0.42,
    0.42,
    0.42,
    1
  }
  return color
end
function GetSoftCheckButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.CHECK_BUTTON_LIGHT
  color.highlight = FONT_COLOR.CHECK_BUTTON_LIGHT
  color.pushed = FONT_COLOR.CHECK_BUTTON_LIGHT
  color.disabled = {
    0.42,
    0.42,
    0.42,
    1
  }
  return color
end
function GetDefaultCheckButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.DEFAULT
  color.highlight = FONT_COLOR.DEFAULT
  color.pushed = FONT_COLOR.DEFAULT
  color.disabled = {
    0.42,
    0.42,
    0.42,
    1
  }
  return color
end
function GetBlackCheckButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(42),
    ConvertColor(42),
    ConvertColor(42),
    1
  }
  color.highlight = {
    ConvertColor(42),
    ConvertColor(42),
    ConvertColor(42),
    1
  }
  color.pushed = {
    ConvertColor(42),
    ConvertColor(42),
    ConvertColor(42),
    1
  }
  color.disabled = {
    ConvertColor(42),
    ConvertColor(42),
    ConvertColor(42),
    0.5
  }
  return color
end
function GetWhiteCheckButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.WHITE
  color.highlight = FONT_COLOR.WHITE
  color.pushed = FONT_COLOR.WHITE
  color.disabled = {
    ConvertColor(152),
    ConvertColor(152),
    ConvertColor(152),
    1
  }
  return color
end
function GetLoginStageAbilityFightButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(241),
    ConvertColor(167),
    ConvertColor(118),
    0.5
  }
  color.highlight = {
    ConvertColor(241),
    ConvertColor(167),
    ConvertColor(118),
    0.8
  }
  color.pushed = {
    ConvertColor(241),
    ConvertColor(167),
    ConvertColor(118),
    1
  }
  color.disabled = {
    0.24,
    0.24,
    0.24,
    1
  }
  return color
end
function GetLoginStageAbilityMagicButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(224),
    ConvertColor(149),
    ConvertColor(243),
    0.5
  }
  color.highlight = {
    ConvertColor(224),
    ConvertColor(149),
    ConvertColor(243),
    0.8
  }
  color.pushed = {
    ConvertColor(224),
    ConvertColor(149),
    ConvertColor(243),
    1
  }
  color.disabled = {
    0.24,
    0.24,
    0.24,
    1
  }
  return color
end
function GetLoginStageAbilityWildButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(170),
    ConvertColor(231),
    ConvertColor(136),
    0.5
  }
  color.highlight = {
    ConvertColor(170),
    ConvertColor(231),
    ConvertColor(136),
    0.8
  }
  color.pushed = {
    ConvertColor(170),
    ConvertColor(231),
    ConvertColor(136),
    1
  }
  color.disabled = {
    0.24,
    0.24,
    0.24,
    1
  }
  return color
end
function GetLoginStageAbilityLoveButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(241),
    ConvertColor(219),
    ConvertColor(118),
    0.5
  }
  color.highlight = {
    ConvertColor(241),
    ConvertColor(219),
    ConvertColor(118),
    0.8
  }
  color.pushed = {
    ConvertColor(241),
    ConvertColor(219),
    ConvertColor(118),
    1
  }
  color.disabled = {
    0.24,
    0.24,
    0.24,
    1
  }
  return color
end
function GetLoginStageAbilityDeathButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(240),
    ConvertColor(133),
    ConvertColor(133),
    0.5
  }
  color.highlight = {
    ConvertColor(240),
    ConvertColor(133),
    ConvertColor(133),
    0.8
  }
  color.pushed = {
    ConvertColor(240),
    ConvertColor(133),
    ConvertColor(133),
    1
  }
  color.disabled = {
    0.24,
    0.24,
    0.24,
    1
  }
  return color
end
function GetLoginStageAbilityVocationButtonFontColor()
  local color = {}
  color.normal = {
    ConvertColor(170),
    ConvertColor(227),
    ConvertColor(239),
    0.5
  }
  color.highlight = {
    ConvertColor(170),
    ConvertColor(227),
    ConvertColor(239),
    0.8
  }
  color.pushed = {
    ConvertColor(170),
    ConvertColor(227),
    ConvertColor(239),
    1
  }
  color.disabled = {
    0.24,
    0.24,
    0.24,
    1
  }
  return color
end
function GetLoginStageDefaultFontColor()
  local color = {}
  color.normal = FONT_COLOR.WHITE
  color.highlight = {
    ConvertColor(254),
    ConvertColor(232),
    ConvertColor(179),
    1
  }
  color.pushed = {
    ConvertColor(177),
    ConvertColor(156),
    ConvertColor(108),
    1
  }
  color.disabled = {
    0.3,
    0.3,
    0.3,
    1
  }
  return color
end
function GetLoginStageCharListFontColor()
  local color = {}
  color.normal = {
    0.28,
    0.28,
    0.28,
    1
  }
  color.highlight = {
    0.9,
    0.9,
    0.9,
    1
  }
  color.pushed = {
    0.28,
    0.28,
    0.28,
    1
  }
  color.disabled = {
    ConvertColor(195),
    ConvertColor(195),
    ConvertColor(195),
    1
  }
  return color
end
function GetLoginStageDeleteCharListFontColor()
  local color = {}
  color.normal = {
    ConvertColor(144),
    ConvertColor(77),
    ConvertColor(77),
    1
  }
  color.highlight = {
    ConvertColor(144),
    ConvertColor(77),
    ConvertColor(77),
    1
  }
  color.pushed = {
    ConvertColor(144),
    ConvertColor(77),
    ConvertColor(77),
    1
  }
  color.disabled = {
    ConvertColor(195),
    ConvertColor(195),
    ConvertColor(195),
    1
  }
  return color
end
function GetVerdictSelectedButtonFontColor()
  local color = {}
  color.normal = {
    r = 1,
    g = 0,
    b = 0,
    a = 1
  }
  color.highlight = {
    r = 1,
    g = 0,
    b = 0,
    a = 1
  }
  color.pushed = {
    r = 1,
    g = 0,
    b = 0,
    a = 1
  }
  color.disabled = {
    r = 0.3,
    g = 0.3,
    b = 0.3,
    a = 1
  }
  return color
end
function GetRoadMapSizeButtonFontColor()
  local color = {}
  color.normal = F_COLOR.GetColor("zone_peace_blue")
  color.highlight = F_COLOR.GetColor("white")
  color.pushed = F_COLOR.GetColor("light_blue")
  color.disabled = {
    ConvertColor(111),
    ConvertColor(111),
    ConvertColor(111),
    1
  }
  return color
end
function GetQuestDirectingButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.WHITE
  color.highlight = {
    ConvertColor(148),
    ConvertColor(207),
    ConvertColor(246),
    1
  }
  color.pushed = {
    ConvertColor(104),
    ConvertColor(137),
    ConvertColor(159),
    1
  }
  color.disabled = {
    ConvertColor(80),
    ConvertColor(80),
    ConvertColor(80),
    1
  }
  return color
end
function GetIngameShopSelectedSubMenuButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.MIDDLE_TITLE
  color.highlight = FONT_COLOR.DEFAULT
  color.pushed = FONT_COLOR.MIDDLE_TITLE
  color.disabled = {
    FONT_COLOR.MIDDLE_TITLE[1],
    FONT_COLOR.MIDDLE_TITLE[2],
    FONT_COLOR.MIDDLE_TITLE[3],
    0.2
  }
  return color
end
function GetIngameShopUnselectedSubMenuButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.MEDIUM_BROWN
  color.highlight = FONT_COLOR.REWARD
  color.pushed = FONT_COLOR.MEDIUM_BROWN
  color.disabled = {
    FONT_COLOR.MEDIUM_BROWN[1],
    FONT_COLOR.MEDIUM_BROWN[2],
    FONT_COLOR.MEDIUM_BROWN[3],
    0.2
  }
  return color
end
function GetCommunityButtonFontColor()
  local color = {}
  color.normal = FONT_COLOR.DEFAULT
  color.highlight = FONT_COLOR.DEFAULT
  color.pushed = FONT_COLOR.SOFT_YELLOW
  color.disabled = FONT_COLOR.DARK_GRAY
  return color
end
