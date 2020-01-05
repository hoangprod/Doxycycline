function SetViewOfAuctionWindow(id, parent)
  local w = CreateWindow(id, parent, "auction")
  w:Show(false)
  w:Clickable(true)
  w:SetExtent(auctionLocale.width.window, 714)
  w:AddAnchor("CENTER", "UIParent", 0, 0)
  w:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "auction"))
  local tab = w:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", w, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  tab:AddAnchor("BOTTOMRIGHT", w, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  tab:SetCorner("TOPLEFT")
  tab:AddSimpleTab(locale.auction.bid)
  tab:AddSimpleTab(locale.auction.putup)
  tab:AddSimpleTab(locale.auction.bidHistory)
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
  CreateAuctionBidFrame(tab.window[1])
  CreateAuctionPutupFrame(tab.window[2])
  CreateAuctionBidHistoryFrame(tab.window[3])
  return w
end
