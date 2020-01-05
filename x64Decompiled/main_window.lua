local tabOrder = {
  "COMBAT_SKILL",
  "HEIR",
  "SPECIAL_ABIL",
  "NORMAL_SKILL",
  "EMOTION",
  "ACTABILIBY"
}
SKILL_WND_TAB = {
  COMBAT_SKILL = {
    index = 0,
    title = GetUIText(SKILL_TEXT, "tab_combat"),
    show = true
  },
  HEIR = {
    index = 0,
    title = GetCommonText("heir"),
    show = X2Player:IsEnabledHeirLevel()
  },
  SPECIAL_ABIL = {
    index = 0,
    title = GetCommonText("special_abil"),
    show = IsTransformablePlayer()
  },
  NORMAL_SKILL = {
    index = 0,
    title = GetUIText(SKILL_TEXT, "tab_general"),
    show = true
  },
  EMOTION = {
    index = 0,
    title = GetUIText(SKILL_TEXT, "tab_emotion"),
    show = true
  },
  ACTABILIBY = {
    index = 0,
    title = GetUIText(SKILL_TEXT, "tab_actability"),
    show = true,
    enable = function()
      return UIParent:GetPermission(UIC_ACTABILIBY)
    end
  }
}
local function MakeTableIndexes()
  local index = 1
  for _, key in ipairs(tabOrder) do
    if SKILL_WND_TAB[key].show == true then
      SKILL_WND_TAB[key].index = index
      index = index + 1
    end
  end
end
local ApplyWindowExtent = function(wnd)
  local offSet = 20
  local width = 680
  local height = 680
  if X2Player:GetFeatureSet().useSavedAbilities then
    height = height + offSet
  end
  wnd:SetExtent(width, height)
end
local function CreateSkillWnd(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  MakeTableIndexes()
  local wnd = CreateWindow(id, parent)
  wnd:SetTitle(locale.skill.titleText)
  wnd:SetSounds("skill_book")
  ApplyWindowExtent(wnd)
  local tab = wnd:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin, -sideMargin)
  tab:SetCorner("TOPLEFT")
  for _, key in ipairs(tabOrder) do
    if SKILL_WND_TAB[key].show == true then
      tab:AddSimpleTab(SKILL_WND_TAB[key].title)
    end
  end
  local combatSkillWnd = CreateCombatSkillWindow("combatTab", tab.window[SKILL_WND_TAB.COMBAT_SKILL.index])
  F_LAYOUT.AttachAnchor(combatSkillWnd, tab.window[SKILL_WND_TAB.COMBAT_SKILL.index])
  combatSkillWnd:Show(true)
  if X2Player:IsEnabledHeirLevel() then
    local heirTab = CreataeHeirWindow("HeirTab", tab.window[SKILL_WND_TAB.HEIR.index], tab)
    heirTab:Show(true)
    F_LAYOUT.AttachAnchor(heirTab, tab.window[SKILL_WND_TAB.HEIR.index])
  end
  local specialTab
  if IsTransformablePlayer() then
    specialTab = CreataeSpecialWindow("specialAbilityTab", tab.window[SKILL_WND_TAB.SPECIAL_ABIL.index])
    specialTab:Show(true)
    F_LAYOUT.AttachAnchor(specialTab, tab.window[SKILL_WND_TAB.SPECIAL_ABIL.index], 16, 19, -9)
  end
  local content = CreateGeneralSkillWindow("generalTab", tab.window[SKILL_WND_TAB.NORMAL_SKILL.index])
  content:Show(true)
  F_LAYOUT.AttachAnchor(content, tab.window[SKILL_WND_TAB.NORMAL_SKILL.index])
  local content = CreateEmotionExpressSkillWindow("emotionTab", tab.window[SKILL_WND_TAB.EMOTION.index])
  content:Show(true)
  F_LAYOUT.AttachAnchor(content, tab.window[SKILL_WND_TAB.EMOTION.index], 0, sideMargin / 1.5, 0, 0)
  local actabilityTab = CreateActabilityPage(tab.window[SKILL_WND_TAB.ACTABILIBY.index])
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable)
  tab:SetGap(-2)
  DrawTabSkin(tab, tab.window[SKILL_WND_TAB.COMBAT_SKILL.index], tab.selectedButton[1])
  function tab:OnTabChanged(selected)
    ReAnhorTabLine(self, selected)
    tab.window[SKILL_WND_TAB.ACTABILIBY.index]:HideGradeInfo()
  end
  tab:SetHandler("OnTabChanged", tab.OnTabChanged)
  local function UpdatePermission()
    local tabIndex = 0
    local selectTab = tab:GetSelectedTab()
    for _, key in ipairs(tabOrder) do
      local tabButton = tab.unselectedButton[SKILL_WND_TAB[key].index]
      if tabButton ~= nil then
        tabIndex = tabIndex + 1
        if SKILL_WND_TAB[key].enable ~= nil then
          local enable = SKILL_WND_TAB[key].enable()
          tabButton:Enable(enable)
          if tabIndex == selectTab and enable == false then
            tab:SelectTab(1)
          end
        end
      end
    end
    if not SKILL_WND_TAB.ACTABILIBY.enable() then
      tab.window[SKILL_WND_TAB.ACTABILIBY.index]:HideGradeInfo()
    end
  end
  UIParent:SetEventHandler("UI_PERMISSION_UPDATE", UpdatePermission)
  function wnd:ShowProc()
    X2Ability:ResetAbilityView()
    actabilityTab:UpdateActabilityPoint()
    UpdatePermission()
    if specialTab then
      specialTab:Update()
    end
    if X2Player:GetFeatureSet().useSavedAbilities then
      combatSkillWnd:UpdateJobComboList()
    end
  end
  function wnd:OnHide()
    if tab.window[SKILL_WND_TAB.ACTABILIBY.index]:IsVisible() then
      X2DialogManager:DeleteByOwnerWindow(tab.window[SKILL_WND_TAB.ACTABILIBY.index]:GetId())
    end
    tab.window[SKILL_WND_TAB.ACTABILIBY.index]:HideGradeInfo()
    X2DialogManager:Delete(DLG_TASK_RESET_SKILLS)
    X2DialogManager:Delete(DLG_TASK_LEARN_SKILL)
    X2DialogManager:Delete(DLG_TASK_LEARN_BUFF)
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  return wnd
end
local skillWnd = CreateSkillWnd("skillWnd", "UIParent")
skillWnd:AddAnchor("CENTER", "UIParent", 0, 0)
skillWnd:Show(false)
skillWnd:SetCloseOnEscape(true)
local function ProcCombatSkillTabButton()
  local combatSkillTabBtn = skillWnd.tab.unselectedButton[SKILL_WND_TAB.COMBAT_SKILL.index]
  local heirSkillTabBtn = skillWnd.tab.unselectedButton[SKILL_WND_TAB.HEIR.index]
  combatSkillTabBtn:ReleaseHandler("OnEnter")
  function combatSkillTabBtn:OnEnter()
    SetTooltip(GetCommonText("tooltip_combat_skill_tab"), self)
  end
  local restrictCombatSkillTab = X2Unit:GetShortcutSkillCount() > 0
  if restrictCombatSkillTab then
    if IsTransformablePlayer() then
      skillWnd.tab:SelectTab(SKILL_WND_TAB.SPECIAL_ABIL.index)
    else
      skillWnd.tab:SelectTab(SKILL_WND_TAB.NORMAL_SKILL.index)
    end
    combatSkillTabBtn:SetHandler("OnEnter", combatSkillTabBtn.OnEnter)
  end
  combatSkillTabBtn:Enable(not restrictCombatSkillTab)
  if heirSkillTabBtn then
    heirSkillTabBtn:Enable(not restrictCombatSkillTab)
  end
end
local function ToggleSkill(isShow, datas)
  if isShow == nil then
    isShow = not skillWnd:IsVisible()
  end
  if X2Demo:GetDemoOptionCount() < 1 then
    skillWnd:Show(isShow)
    ToggleSkillNotifyer(not isShow)
    if datas ~= nil and datas.selectIdx ~= nil and #skillWnd.tab.window >= datas.selectIdx and 1 <= datas.selectIdx then
      skillWnd.tab:SelectTab(datas.selectIdx)
    end
  end
  ProcCombatSkillTabButton()
end
ADDON:RegisterContentTriggerFunc(UIC_SKILL, ToggleSkill)
