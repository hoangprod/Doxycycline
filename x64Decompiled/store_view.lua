function SetViewOfStoreFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent, "store")
  window:AddAnchor("LEFT", "UIParent", 10, 0)
  window:SetExtent(510, 605)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "store"))
  window:SetSounds("store")
  local cmdWindow = CreateCMDWindow(window:GetId() .. ".cmdWindow", window)
  window.cmdWindow = cmdWindow
  local tab = window:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", cmdWindow, "TOPRIGHT", 0, -sideMargin / 2)
  tab:SetCorner("TOPLEFT")
  tab:AddSimpleTab(locale.store.buyAll)
  tab:AddSimpleTab(locale.store.sellAll)
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
  CreateStoreBuyFrame(tab.window[1], cmdWindow)
  CreateStoreSellFrame(tab.window[2], cmdWindow)
  local rebuyWindow = CreateRebuyWindow(window:GetId() .. ".rebuyWindow", window)
  window.rebuyWindow = rebuyWindow
  local rebuyButton = window:CreateChildWidget("button", "rebuyButton", 0, true)
  rebuyButton:SetText(locale.store.reBuyList)
  rebuyButton:AddAnchor("BOTTOMRIGHT", tab, "TOPRIGHT", 5, 30)
  ApplyButtonSkin(rebuyButton, BUTTON_CONTENTS.STORE_PAGE_NEXT)
  return window
end
