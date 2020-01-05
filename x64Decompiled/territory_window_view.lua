local sideMargin, titleMargin, bottomMargin = GetWindowMargin("popup")
function SetViewOfTerritoryWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(territoryLocale.width, 600)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetUIText(DOMINION, "dominion_def_info"))
  local tab = window:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", window, -sideMargin, -sideMargin)
  tab:SetCorner("TOPLEFT")
  local tabTitles = {
    locale.territory.tabCastle
  }
  for i = 1, #tabTitles do
    tab:AddSimpleTab(tabTitles[i])
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
  tab.tabIdx = 1
  CreateGuardTowerFrame(tab.window[1])
  return window
end
