function CreateExpdMgmtTab(id, parent)
  local tab = W_BTN.CreateTab(id .. "tab", parent)
  tab:AddAnchor("TOPLEFT", parent, 0, 0)
  tab:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local tabTexts = {}
  for i = 1, #EXPEDITION_TAB_MENU_TABLE do
    local tabMenu = EXPEDITION_TAB_MENU_TABLE[i]
    table.insert(tabTexts, tabMenu.text)
  end
  tab:AddTabs(tabTexts)
  parent.tab = tab
end
function CreateWebBrowser(id, wnd)
  local webBrowser = UIParent:CreateWidget("webbrowser", id, wnd)
  webBrowser:AddAnchor("TOP", wnd, 0, 5)
  webBrowser:SetExtent(890, 617)
  webBrowser:SetEscEvent(true)
  wnd.webBrowser = webBrowser
end
