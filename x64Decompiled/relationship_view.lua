function SetViewOfRelationshipFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local tab = W_BTN.CreateTab("tab", parent)
  tab:AddAnchor("TOPLEFT", parent, 0, 0)
  tab:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  tab:AddTabs(locale.relationship.tabText)
  tab.friendTabIdx = 1
  CreateFriendTabWindow(tab.window[1])
  tab.blockTabIdx = 2
  CreateBlockTabWindow(tab.window[2])
  return parent
end
