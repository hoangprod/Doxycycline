MY_ABILITY_COUNT = 3
local SetAutoHeight = function(target, startWidget, endWidget, margin)
  if margin == nil then
    margin = 0
  end
  local _, yOffset = F_LAYOUT.GetExtentWidgets(startWidget, endWidget)
  if yOffset ~= nil then
    target:SetHeight(yOffset + margin)
  end
end
local function CreateAbilityTextButtons(parent)
  local row_cnt = abilityChangeLocale.row_cnt
  local vertical_gap = abilityChangeLocale.vertical_gap
  local horizontal_gap = abilityChangeLocale.horizontal_gap
  local start_x = abilityChangeLocale.start_x
  local x = start_x
  local y = 0
  local first, last
  for j = 1, COMBAT_ABILITY_MAX - 1 do
    local all_ability_button = parent:CreateChildWidget("button", "all_ability_button", j, true)
    all_ability_button:SetText(locale.common.abilityNameWithId(j))
    ApplyButtonSkin(all_ability_button, BUTTON_CONTENTS.ALL_ABILITY)
    local buttonTable = {}
    table.insert(buttonTable, all_ability_button)
    AdjustBtnLongestTextWidth(buttonTable, abilityChangeLocale.text_width)
    if j == 1 then
      all_ability_button:AddAnchor("TOPLEFT", parent, x, y)
      first = all_ability_button
    else
      local w, h = all_ability_button:GetExtent()
      x = x + w + horizontal_gap
      if (j - 1) % row_cnt == 0 then
        x = start_x
        y = y + h + vertical_gap
      end
      all_ability_button:AddAnchor("TOPLEFT", parent, x, y)
    end
    last = all_ability_button
  end
  SetAutoHeight(parent, first, last)
end
function SetViewOfAbilityChangeFrame(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(abilityChangeLocale.abilityChangeFrame.extent.w, abilityChangeLocale.abilityChangeFrame.extent.h + 36)
  window:SetTitle(locale.abilityChanger.title)
  window:SetSounds("ability_change")
  local upperWindow = window:CreateChildWidget("emptywidget", "upperWindow", 0, true)
  upperWindow:Show(true)
  upperWindow:SetExtent(470, 140)
  upperWindow:AddAnchor("TOPLEFT", window, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  for i = 1, MAX.MY_ABILITY_COUNT do
    localeView.abilityButton.CreateFunc(upperWindow, i)
  end
  local line = CreateLine(upperWindow, "TYPE1")
  line:AddAnchor("TOPLEFT", upperWindow, "BOTTOMLEFT", 0, 11)
  line:AddAnchor("TOPRIGHT", upperWindow, "BOTTOMRIGHT", 0, 11)
  local lowerWindow = window:CreateChildWidget("emptywidget", "lowerWindow", 0, true)
  lowerWindow:Show(true)
  lowerWindow:SetExtent(470, 70)
  lowerWindow:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 0, 11)
  window.allAbilityInfos = X2Ability:GetAllCombatAbility()
  CreateAbilityTextButtons(lowerWindow)
  local selectedIcon = W_ICON.DrawSkillFlameIcon(lowerWindow, "overlay")
  selectedIcon:SetVisible(false)
  lowerWindow.selectedIcon = selectedIcon
  local info = {
    leftButtonStr = GetUIText(ABILITY_CHANGER_TEXT, "title"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(window, info)
  local margin = math.abs(BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM) + window.leftButton:GetHeight() + 20
  SetAutoHeight(window, window.titleBar, lowerWindow, margin)
  return window
end
