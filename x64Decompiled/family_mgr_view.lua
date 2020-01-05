FAMILY_TAB = {
  INFO = 1,
  HAPPY_LIFE = 2,
  MEMBER = 3,
  INTRODUCE = 4
}
function SetViewOfFamilyFrame(id, parent)
  local tab = W_BTN.CreateTab("tab", parent)
  tab:AddAnchor("TOPLEFT", parent, 0, 0)
  tab:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local tabTexts = {
    GetCommonText("family_info"),
    GetCommonText("family_happy_life"),
    GetCommonText("family_member"),
    GetCommonText("family_introduce")
  }
  tab:AddTabs(tabTexts)
  ShowFamilyInfoTab(tab.window[FAMILY_TAB.INFO])
  ShowFamilyHappyLifeTab(tab.window[FAMILY_TAB.HAPPY_LIFE])
  ShowFamilyMemberTab(tab.window[FAMILY_TAB.MEMBER])
  ShowFamilyIntroduceTab(tab.window[FAMILY_TAB.INTRODUCE])
  return parent
end
