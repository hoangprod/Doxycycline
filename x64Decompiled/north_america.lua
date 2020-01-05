if X2Util:GetGameProvider() == TRION then
  UIParent:SetUseInsertComma(false)
  localeView.localGmCommand = 2
  localeView.systemConfig = {
    buttonOffsetX = {
      -107,
      8,
      107
    }
  }
  localeView.questContextList.systemChatBubbleDecoFormat = "%s"
  localeView.worldMap = {
    focusAndPingButton = {width = 200, offsetX = 10}
  }
  localeView.customizing.plasticWindow.width = 515
  localeView.customizing.detailController.nameLabel = {
    extent = {170, 25},
    autoWordWrap = true,
    lineSpace = -2
  }
  localeView.customizing.detailController.slider = {
    width = 160,
    anchor = {0, 0}
  }
  localeView.customizing.detailController.valueLabel = {
    anchor = {0, 0},
    fontSize = FONT_SIZE.LARGE
  }
  localeView.abilityButton = {
    fontInset = {
      7,
      0,
      0,
      25
    },
    fontSize = FONT_SIZE.MIDDLE,
    extent = {170, 150},
    CreateFunc = function(parentWnd, idx)
      local ability_button = parentWnd:CreateChildWidget("button", "ability_button", idx, true)
      ability_button:AddAnchor("TOPLEFT", parentWnd, (idx - 1) * 163 - 15, 0)
      ApplyButtonSkin(ability_button, BUTTON_CONTENTS.MY_ABILITY)
      local ability_level = ability_button:CreateChildWidget("label", "ability_level", 0, true)
      ability_level:AddAnchor("BOTTOM", ability_button, 3, -70)
      ability_level.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.MIDDLE)
      local SetButtonText = ability_button.SetText
      function ability_button:SetText(text)
        local l, r = string.find(text, "%(%d+%)")
        SetButtonText(self, string.sub(text, 1, l - 1))
        ability_level:SetText(string.sub(text, l, r))
      end
      function ability_button:OnEnter()
        if ability_level.pushed then
          return
        end
        local color = GetMyAbilityButtonFontColor()
        local h = color.highlight
        ApplyTextColor(ability_level, h)
      end
      ability_button:SetHandler("OnEnter", ability_button.OnEnter)
      function ability_button:OnLeave()
        if ability_level.pushed then
          return
        end
        local color = GetMyAbilityButtonFontColor()
        local n = color.normal
        ApplyTextColor(ability_level, n)
      end
      ability_button:SetHandler("OnLeave", ability_button.OnLeave)
      ability_button.OnLeave()
    end,
    ResetFunc = function(ability_button)
      local color = GetMyAbilityButtonFontColor()
      local n = color.normal
      ApplyTextColor(ability_button.ability_level, n)
      ability_button.ability_level.pushed = false
    end,
    SetPushedFunc = function(ability_button)
      local color = GetMyAbilityButtonFontColor()
      local p = color.pushed
      ApplyTextColor(ability_button.ability_level, p)
      ability_button.ability_level.pushed = true
    end
  }
end
