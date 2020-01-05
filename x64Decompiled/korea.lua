if localeView == nil then
  localeView = {}
end
localeView.useWebContent = true
localeView.localGmCommand = 1
localeView.groupMaker = {yOffsetValue = 20, xOffsetAgmenter = 110}
localeView.actionBarOption = {
  ShowActionBar_1 = 1,
  ShowActionBar_2 = 1,
  ShowActionBar_3 = 0,
  ShowActionBar_4 = 0,
  ShowActionBar_5 = 0
}
localeView.worldMap = {
  focusAndPingButton = {width = 100, offsetX = 100}
}
localeView.actionPointUpgrateButton = -25
localeView.actionPointDownGradeButton = -5
localeView.fpsInfoAnchor = {-238, 6}
localeView.questContextList = {systemChatBubbleDecoFormat = "[%s]"}
localeView.customizing = {
  plasticWindow = {width = 495},
  detailController = {
    nameLabel = {
      extent = {90, 25},
      autoWordWrap = false,
      lineSpace = 0
    },
    slider = {
      width = 220,
      anchor = {10, 0}
    },
    valueLabel = {
      anchor = {5, 0},
      fontSize = FONT_SIZE.LARGE
    }
  }
}
localeView.abilityButton = {
  fontInset = {
    7,
    0,
    0,
    5
  },
  fontSize = FONT_SIZE.XLARGE,
  extent = {145, 134},
  CreateFunc = function(parentWnd, idx)
    local ability_button = parentWnd:CreateChildWidget("button", "ability_button", idx, true)
    ability_button:AddAnchor("LEFT", parentWnd, (idx - 1) * 163, 0)
    ApplyButtonSkin(ability_button, BUTTON_CONTENTS.MY_ABILITY)
  end,
  ResetFunc = function()
  end,
  SetPushedFunc = function()
  end
}
