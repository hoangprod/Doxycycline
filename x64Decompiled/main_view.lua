local buttonExtent = 28
local leftMenuCount = #locale.infobar.leftMenu
local rightMenuCount = #locale.infobar.rightMenu
function CreateMainMenuBar(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  window:SetExtent(UIParent:GetScreenWidth(), 6)
  window:AddAnchor("BOTTOM", "UIParent", 0, 0)
  window:SetUILayer("game")
  local left_deco = window:CreateDrawable(TEXTURE_PATH.HUD, "main_menu_bar_left_deco", "background")
  left_deco:SetExtent(390, 38)
  left_deco:AddAnchor("BOTTOMLEFT", window, "TOPLEFT", 0, 0)
  local right_deco = window:CreateDrawable(TEXTURE_PATH.HUD, "main_menu_bar_right_deco", "background")
  right_deco:SetExtent(390, 38)
  right_deco:AddAnchor("BOTTOMRIGHT", window, "TOPRIGHT", 0, 0)
  local exp_bar_set = CreateExpBarSet(window:GetId() .. ".exp_bar_set", window)
  exp_bar_set:AddAnchor("BOTTOM", window, 0, -1)
  window.exp_bar_set = exp_bar_set
  local exp_bar_bg = window:CreateDrawable(TEXTURE_PATH.HUD, "default_guage", "background")
  exp_bar_bg:SetTextureColor("black")
  exp_bar_bg:AddAnchor("BOTTOM", window, 0, 0)
  window.exp_bar_bg = exp_bar_bg
  local laborpower_bar_set = CreateLaborPowerBarSet(window:GetId() .. ".laborpower_bar_set", window)
  laborpower_bar_set:AddAnchor("BOTTOMLEFT", exp_bar_set.exp_percent, "BOTTOMRIGHT", 5, 5)
  window.laborpower_bar_set = laborpower_bar_set
  local right_menu = CreateMainMenuBarRenewal(window:GetId() .. ".right_menu", window)
  right_menu:Show(true)
  right_menu:AddAnchor("BOTTOMRIGHT", window, -5, -10)
  window.right_menu = right_menu
  local icon = window.right_menu:CreateDrawable(TEXTURE_PATH.HUD, "everyday_n_small", "overlay")
  icon:AddAnchor("TOPLEFT", right_menu.button[MAIN_MENU_IDX.QUEST], 0, 0)
  icon:SetVisible(false)
  window.alarmIcon = icon
  local heir_icon = window.right_menu:CreateDrawable(TEXTURE_PATH.SKILL, "up_alarm", "overlay")
  heir_icon:AddAnchor("TOPLEFT", right_menu.button[MAIN_MENU_IDX.SKILL], 0, 0)
  heir_icon:SetVisible(false)
  window.heirAlarmIcon = heir_icon
  local laborpower_bar_bg = window:CreateDrawable(TEXTURE_PATH.HUD, "default_guage", "background")
  laborpower_bar_bg:SetTextureColor("black")
  laborpower_bar_bg:AddAnchor("TOPLEFT", laborpower_bar_set, 0, -1)
  laborpower_bar_bg:AddAnchor("BOTTOMRIGHT", laborpower_bar_set, 0, 1)
  return window
end
