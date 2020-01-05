main_menu_bar = CreateMainMenuBar("main_menu_bar", "UIParent")
local life_alert_effect = main_menu_bar:CreateEffectDrawable(TEXTURE_PATH.LIFE_ALERT, "overlay")
life_alert_effect:SetCoords(0, 0, 1024, 512)
life_alert_effect:SetExtent(1024, 512)
life_alert_effect:AddAnchor("TOPLEFT", "UIParent", 0, 0)
life_alert_effect:SetRepeatCount(0)
life_alert_effect:SetEffectPriority(1, "alpha", 0.6, 0.5)
life_alert_effect:SetEffectInitialColor(1, 1, 1, 1, 1)
life_alert_effect:SetEffectFinalColor(1, 1, 1, 1, 0)
life_alert_effect:SetEffectPriority(2, "alpha", 0.6, 0.5)
life_alert_effect:SetEffectInitialColor(2, 1, 1, 1, 0)
life_alert_effect:SetEffectFinalColor(2, 1, 1, 1, 1)
main_menu_bar.life_alert_effect = life_alert_effect
local life_alert_effect_2 = main_menu_bar:CreateEffectDrawable(TEXTURE_PATH.LIFE_ALERT, "overlay")
life_alert_effect_2:SetCoords(1024, 512, -1024, -512)
life_alert_effect_2:SetExtent(1024, 512)
life_alert_effect_2:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
life_alert_effect_2:SetRepeatCount(0)
life_alert_effect_2:SetEffectPriority(1, "alpha", 0.6, 0.5)
life_alert_effect_2:SetEffectInitialColor(1, 1, 1, 1, 1)
life_alert_effect_2:SetEffectFinalColor(1, 1, 1, 1, 0)
life_alert_effect_2:SetEffectPriority(2, "alpha", 0.6, 0.5)
life_alert_effect_2:SetEffectInitialColor(2, 1, 1, 1, 0)
life_alert_effect_2:SetEffectFinalColor(2, 1, 1, 1, 1)
main_menu_bar.life_alert_effect_2 = life_alert_effect_2
function LifeAlertEffect(curHp, maxHp)
  if main_menu_bar == nil then
    return
  end
  if curHp ~= 0 and curHp < maxHp * 0.3 then
    if main_menu_bar.life_alert_effect:IsVisible() == false then
      main_menu_bar.life_alert_effect:SetStartEffect(true)
      main_menu_bar.life_alert_effect_2:SetStartEffect(true)
    end
  elseif curHp == 0 then
    main_menu_bar.life_alert_effect:SetVisible(true)
    main_menu_bar.life_alert_effect_2:SetVisible(true)
  else
    main_menu_bar.life_alert_effect:SetStartEffect(false)
    main_menu_bar.life_alert_effect_2:SetStartEffect(false)
  end
end
function main_menu_bar:OnScale()
  self:SetExtent(F_LAYOUT.CalcDontApplyUIScale(UIParent:GetScreenWidth()), 6)
  self.exp_bar_set:SetExtent(F_LAYOUT.CalcDontApplyUIScale(UIParent:GetScreenWidth()), 5)
  self.exp_bar_set.exp_bar:SetExtent(F_LAYOUT.CalcDontApplyUIScale(UIParent:GetScreenWidth()), 5)
  self.exp_bar_bg:SetExtent(F_LAYOUT.CalcDontApplyUIScale(UIParent:GetScreenWidth()), 8)
  life_alert_effect:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  life_alert_effect_2:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
end
main_menu_bar:SetHandler("OnScale", main_menu_bar.OnScale)
function GetMainMenuBarButton(typeIdx)
  local buttonIdx = 0
  for i = 1, #MENU_TABLE do
    if type(MENU_TABLE[i]) == "table" then
      for j = 1, #MENU_TABLE[i] do
        if MENU_TABLE[i][j] == typeIdx then
          buttonIdx = i
          break
        end
      end
    elseif MENU_TABLE[i] == typeIdx then
      buttonIdx = i
      break
    end
  end
  if buttonIdx == 0 then
    return
  end
  return main_menu_bar.right_menu.button[buttonIdx]
end
