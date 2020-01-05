EXPEDITION_TAB_MENU_IDX = {
  INFORMATION = 1,
  QUEST = 2,
  BARRACK = 3,
  MEMBERS = 4,
  ROLE_POLICY = 5,
  RECRUIT = 6
}
EXPEDITION_TAB_MENU_INFO = {
  [EXPEDITION_TAB_MENU_IDX.INFORMATION] = {
    enable = true,
    show = true,
    text = GetUIText(EXPEDITION_TEXT, "my_expedition")
  },
  [EXPEDITION_TAB_MENU_IDX.QUEST] = {
    enable = X2Player:GetFeatureSet().expeditionLevel,
    show = true,
    text = GetUIText(COMMON_TEXT, "today_quest")
  },
  [EXPEDITION_TAB_MENU_IDX.BARRACK] = {
    enable = true,
    show = expeditionLocale.useBarracks,
    text = GetUIText(EXPEDITION_TEXT, "board")
  },
  [EXPEDITION_TAB_MENU_IDX.MEMBERS] = {
    enable = true,
    show = true,
    text = GetUIText(EXPEDITION_TEXT, "expedition_member")
  },
  [EXPEDITION_TAB_MENU_IDX.ROLE_POLICY] = {
    enable = true,
    show = true,
    text = GetUIText(EXPEDITION_TEXT, "set_authority")
  },
  [EXPEDITION_TAB_MENU_IDX.RECRUIT] = {
    enable = X2Player:GetFeatureSet().expeditionRecruit,
    show = true,
    text = GetUIText(COMMON_TEXT, "expedition_recruit_tab")
  }
}
EXPEDITION_TAB_MENU_TABLE = {}
for i = 1, #EXPEDITION_TAB_MENU_INFO do
  local tabMenu = EXPEDITION_TAB_MENU_INFO[i]
  if tabMenu.show then
    table.insert(EXPEDITION_TAB_MENU_TABLE, tabMenu)
  end
end
function GetExpeiditonTabIdx(idx)
  local tabInfo = EXPEDITION_TAB_MENU_INFO[idx]
  if tabInfo == nil then
    return
  end
  for i = 1, #EXPEDITION_TAB_MENU_TABLE do
    local tab = EXPEDITION_TAB_MENU_TABLE[i]
    if tabInfo.text == tab.text then
      return i
    end
  end
  return
end
