MAX_DYNAMIC_ACTION_COUNT = 10
ACTION_BUTTON_WIDTH = 48
ACTION_BUTTON_HEIGHT = 48
ACTION_BUTTON_GAP = 2
function SetViewOfDynamicActionBar(id, parent)
  local w = CreateEmptyWindow(id, parent)
  w:Show(false)
  w:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
  w:SetUILayer("game")
  w.button = {}
  w.keyBindingLabel = {}
  for i = 1, MAX_DYNAMIC_ACTION_COUNT do
    do
      local x = 0
      x = (i - 1) * ACTION_BUTTON_WIDTH
      x = x + i * ACTION_BUTTON_GAP
      x = x + 10
      local button = w:CreateChildWidget("button", "button", i, true)
      button:SetExtent(ACTION_BUTTON_WIDTH, ACTION_BUTTON_HEIGHT)
      button:AddAnchor("TOPLEFT", w, x, 5)
      button:SetSounds("")
      local bindingText = F_TEXT.ConvertAbbreviatedBindingText(X2Hotkey:GetBinding("do_interaction_" .. i, 1) or "")
      local keyBindingLabel = W_CTRL.CreateLabel(id .. "keyBindingLabel" .. tostring(i), w)
      keyBindingLabel:SetExtent(0, 13)
      keyBindingLabel:AddAnchor("BOTTOM", button, 0, 3)
      keyBindingLabel:SetText(bindingText)
      keyBindingLabel.style:SetAlign(ALIGN_CENTER)
      keyBindingLabel.style:SetOutline(true)
      ApplyTextColor(keyBindingLabel, FONT_COLOR.EXP_ORANGE)
      w.keyBindingLabel[i] = keyBindingLabel
      button.stateBgs = {}
      for i = 1, 4 do
        local drawable = button:CreateIconImageDrawable("Textures/Defaults/White.dds", "background")
        drawable:AddAnchor("TOPLEFT", button, 0, 0)
        drawable:AddAnchor("BOTTOMRIGHT", button, 0, 0)
        drawable:SetCoords(0, 0, 48, 48)
        drawable:SetColor(1, 1, 1, 1)
        button.stateBgs[i] = drawable
      end
      function button:SetBackgroundTexture(state, path)
        local drawable = self.stateBgs[state]
        drawable:ClearAllTextures()
        drawable:AddTexture(path)
        if state == BUTTON_STATE.NORMAL then
          button:SetNormalBackground(drawable)
        elseif state == BUTTON_STATE.HIGHLIGHTED then
          button:SetHighlightBackground(drawable)
        elseif state == BUTTON_STATE.PUSHED then
          button:SetPushedBackground(drawable)
        elseif state == BUTTON_STATE.DISABLED then
          button:SetDisabledBackground(drawable)
        end
      end
    end
  end
  return w
end
