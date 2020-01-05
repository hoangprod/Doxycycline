local assignmentWnd
local CreateAssignmentWindow = function(id, parent)
  local wnd = CreateWindow(id, parent)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "assignment_system"))
  wnd:SetExtent(assignmentLocale.windowWidth, 620)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetSounds("achievement")
  local tab = W_BTN.CreateTab("tab", wnd)
  local titleList = {}
  local achievementStringList = locale.GetAllAchievementKindString()
  local achievementSize = #achievementStringList
  for i = 1, achievementSize do
    table.insert(titleList, achievementStringList[i])
  end
  table.insert(titleList, GetCommonText("appellation_title"))
  tab:AddTabs(titleList)
  for i = 1, achievementSize do
    CreateAchievementTabPage(tab.window[i], i)
  end
  CreateAppellation(tab.window[4])
  function wnd:SelectAchievement(info)
    local kind = info.achievementKind
    tab:SelectTab(kind)
    tab.window[kind]:SelectAchievement(info)
  end
  function tab:OnTabChangedProc(selected)
    tab.window[selected]:OnTabSelected(selected)
  end
  return wnd
end
local function ToggleAssignement(isShow)
  local featureSet = X2Player:GetFeatureSet()
  if not featureSet.achievement then
    return
  end
  if assignmentWnd == nil then
    assignmentWnd = CreateAssignmentWindow("assignmentWnd", "UIParent")
  end
  if isShow == nil then
    isShow = not assignmentWnd:IsVisible()
  end
  assignmentWnd:Show(isShow)
end
ADDON:RegisterContentTriggerFunc(UIC_ACHIEVEMENT, ToggleAssignement)
function ToggleAssignmentWithAcheivement(aType)
  local aInfo = X2Achievement:GetAchievementInfo(aType)
  if aInfo == nil then
    return
  end
  ToggleAssignement(true)
  assignmentWnd:SelectAchievement(aInfo)
  assignmentWnd:Raise()
end
