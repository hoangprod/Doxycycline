CHARACTER_INFO_SUB_WND_TAB = {
  ATTACK = 1,
  DEFENCE = 2,
  RECOVERY = 3
}
local SetViewOfCharacterInfoSubWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetWidth(characetInfoLocale.windowWidth)
  window:SetTitle(locale.faction.detail)
  local tab = window:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", window, -sideMargin, -sideMargin)
  tab:SetCorner("CENTER")
  for i = 1, #locale.character.title do
    tab:AddSimpleTab(X2Locale:LocalizeUiText(CHARACTER_TITLE_TEXT, locale.character.title[i]))
  end
  window.SubInfoWnd = {}
  local AttackInfoSubWnd, height_attack = CreateCharacterTabInfoSubWindow(id .. ".attackinfosubTab", tab.window[CHARACTER_INFO_SUB_WND_TAB.ATTACK], CHARACTER_INFO_SUB_WND_TAB.ATTACK)
  F_LAYOUT.AttachAnchor(AttackInfoSubWnd, tab.window[CHARACTER_INFO_SUB_WND_TAB.ATTACK])
  AttackInfoSubWnd:Show(true)
  window.SubInfoWnd[CHARACTER_INFO_SUB_WND_TAB.ATTACK] = AttackInfoSubWnd
  window:SetHeight(height_attack)
  local DefenceInfoSubWnd, height_defence = CreateCharacterTabInfoSubWindow(id .. ".defenceinfosubTab", tab.window[CHARACTER_INFO_SUB_WND_TAB.DEFENCE], CHARACTER_INFO_SUB_WND_TAB.DEFENCE)
  F_LAYOUT.AttachAnchor(DefenceInfoSubWnd, tab.window[CHARACTER_INFO_SUB_WND_TAB.DEFENCE])
  DefenceInfoSubWnd:Show(true)
  window.SubInfoWnd[CHARACTER_INFO_SUB_WND_TAB.DEFENCE] = DefenceInfoSubWnd
  local RecoveryInfoSubWnd, height_recovery = CreateCharacterTabInfoSubWindow(id .. ".recoveryinfosubTab", tab.window[CHARACTER_INFO_SUB_WND_TAB.RECOVERY], CHARACTER_INFO_SUB_WND_TAB.RECOVERY)
  F_LAYOUT.AttachAnchor(RecoveryInfoSubWnd, tab.window[CHARACTER_INFO_SUB_WND_TAB.RECOVERY])
  RecoveryInfoSubWnd:Show(true)
  window.SubInfoWnd[CHARACTER_INFO_SUB_WND_TAB.RECOVERY] = RecoveryInfoSubWnd
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable, characetInfoLocale.TabWidth)
  function tab:OnTabChanged(selected)
    ReAnhorTabLine(self, selected)
  end
  tab:SetHandler("OnTabChanged", tab.OnTabChanged)
  tab:SetGap(-2)
  DrawTabSkin(tab, tab.window[CHARACTER_INFO_SUB_WND_TAB.ATTACK], tab.selectedButton[1])
  return window
end
function CreateCharacterInfoSubWindow(id, parent)
  local window = SetViewOfCharacterInfoSubWindow(id, parent)
  return window
end
