tutorialToggleIcons = {
  ["2594_2_1"] = {
    toggle = "toggle_bag",
    text = locale.inven.bagTitle
  },
  ["2595_1_1"] = {
    toggle = "toggle_bag",
    text = locale.inven.bagTitle
  },
  ["2598_1_1"] = {
    toggle = "toggle_spellbook",
    text = locale.skill.titleText
  },
  ["2600_1_1"] = {
    toggle = "toggle_spellbook",
    text = locale.skill.titleText
  },
  ["2605_1_1"] = {
    toggle = "toggle_quest",
    text = locale.questContext.list
  },
  ["2606_1_1"] = {
    toggle = "toggle_spellbook",
    text = locale.skill.titleText
  },
  ["2609_1_1"] = {
    toggle = "toggle_bag",
    text = locale.inven.bagTitle
  },
  ["2621_1_1"] = {
    toggle = "toggle_worldmap",
    text = locale.map.title
  },
  ["2622_1_1"] = {
    toggle = "toggle_bag",
    text = locale.inven.bagTitle
  },
  ["2623_1_1"] = {
    toggle = "toggle_worldmap",
    text = locale.map.title
  },
  ["2629_1_1"] = {
    toggle = "toggle_bag",
    text = locale.inven.bagTitle
  },
  ["2631_1_1"] = {
    toggle = "toggle_option",
    text = locale.menu.option
  },
  ["2644_1_1"] = {
    toggle = "toggle_bag",
    text = locale.inven.bagTitle
  }
}
function GetTutorialAnchorInfos(key)
  local playerFrame = ADDON:GetContent(UIC_PLAYER_UNITFRAME)
  local clockBar = GetIndicators().clockBar
  local tutorialAnchorInfos = {
    ["2586"] = {
      "TOPRIGHT",
      GetNotifierWnd(),
      "TOPLEFT",
      30,
      15
    },
    ["2590"] = {
      "BOTTOM",
      actionBar_renewal[2],
      "TOPRIGHT",
      0,
      20
    },
    ["2595"] = {
      "BOTTOM",
      GetMainMenuBarButton(MAIN_MENU_IDX.BAG),
      "TOPLEFT",
      0,
      0
    },
    ["2597"] = {
      "BOTTOMLEFT",
      main_menu_bar.laborpower_bar_set.laborPowerText,
      "TOPLEFT",
      -15,
      5
    },
    ["2598"] = {
      "BOTTOM",
      GetMainMenuBarButton(MAIN_MENU_IDX.SKILL),
      "TOPLEFT",
      -35,
      0
    },
    ["2601"] = {
      "BOTTOM",
      actionBar_renewal[2],
      "TOPRIGHT",
      0,
      20
    },
    ["2602"] = {
      "TOPRIGHT",
      GetNotifierWnd(),
      "TOPLEFT",
      30,
      15
    },
    ["2603"] = {
      "BOTTOM",
      actionBar_renewal[2],
      "TOPRIGHT",
      0,
      20
    },
    ["2604"] = {
      "BOTTOM",
      actionBar_renewal[2],
      "TOPRIGHT",
      0,
      20
    },
    ["2605"] = {
      "BOTTOM",
      GetMainMenuBarButton(MAIN_MENU_IDX.QUEST),
      "TOPLEFT",
      -10,
      0
    },
    ["2621"] = {
      "TOPLEFT",
      playerFrame.eventWindow,
      "TOPRIGHT",
      0,
      0
    },
    ["2622"] = {
      "BOTTOM",
      GetMainMenuBarButton(MAIN_MENU_IDX.BAG),
      "TOPLEFT",
      0,
      0
    },
    ["2624"] = {
      "BOTTOM",
      GetMainMenuBarButton(MAIN_MENU_IDX.CHARACTER),
      "TOPLEFT",
      0,
      0
    },
    ["2626"] = {
      "TOPLEFT",
      chatTabWindow[1],
      "BOTTOMRIGHT",
      0,
      -50
    },
    ["2627"] = {
      "TOPRIGHT",
      clockBar,
      "BOTTOMRIGHT",
      0,
      200
    },
    ["2631"] = {
      "BOTTOM",
      actionBar_renewal[2],
      "TOPRIGHT",
      0,
      20
    },
    ["2632"] = {
      "TOPRIGHT",
      GetNotifierWnd(),
      "TOPLEFT",
      30,
      15
    },
    ["2633"] = {
      "BOTTOMLEFT",
      main_menu_bar.laborpower_bar_set.laborPowerText,
      "TOPLEFT",
      -15,
      5
    }
  }
  return tutorialAnchorInfos[key]
end
function MakeTutorialKey(key, page, index)
  if not key or not page or not index then
    UIParent:LogAlways(string.format("[ERROR] GetTutorialIconInfo()... invalid arg.. key[%s], page[%s], index[%s]", tostring(key), tostring(page), tostring(index)))
    return nil
  end
  return string.format("%d_%d_%d", key, page, index)
end
