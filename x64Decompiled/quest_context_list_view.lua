local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateQuestList(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  function window:MakeOriginWindowPos()
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(680, 515)
    window:AddAnchor("CENTER", parent, 0, 0)
  end
  window:MakeOriginWindowPos()
  window:SetTitle(locale.questContext.list)
  window:SetSounds("quest_context_list")
  AddUISaveHandlerByKey("questList", window)
  local tab = window:CreateChildWidget("tab", "tab", 0, true)
  tab:SetWidth(260)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMLEFT", window, sideMargin, -sideMargin)
  tab:SetCorner("TOPLEFT")
  for i = 1, #locale.questContext.tabText do
    tab:AddSimpleTab(locale.questContext.tabText[i])
  end
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable)
  tab:SetGap(-2)
  DrawTabSkin(tab, tab.window[1], tab.selectedButton[1])
  CreateProgressTabWindow(tab.window[1])
  CreateMainQuestTabWindow(tab.window[2])
  local icon = window:CreateDrawable(TEXTURE_PATH.HUD, "everyday_n_small", "overlay")
  icon:AddAnchor("TOPRIGHT", tab.selectedButton[2], 0, 0)
  icon:SetVisible(false)
  window.alarmIcon = icon
  maintabshow = tab.window[2]
  function maintabshow:OnShow()
    if window.alarmIcon:IsVisible() then
      window.alarmIcon:Show(false)
    end
    if main_menu_bar.alarmIcon:IsVisible() then
      main_menu_bar.alarmIcon:Show(false)
    end
  end
  maintabshow:SetHandler("OnShow", maintabshow.OnShow)
  return window
end
questContext.contextListBack = CreateQuestList("questContext.contextListBack", "UIParent")
