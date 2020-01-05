local familyWnd, reservedOpenTabIdx
function CreateFamilyFrame(id, parent)
  familyWnd = SetViewOfFamilyFrame(id, parent)
  familyWnd:Show(false)
  local function TabButtonRefresh(idx)
    local isFamily = X2Family:IsFamily()
    for i = 1, FAMILY_TAB.MEMBER do
      familyWnd.tab.selectedButton[i]:Enable(isFamily)
      familyWnd.tab.unselectedButton[i]:Enable(isFamily)
    end
    local tabIndex = reservedOpenTabIdx and reservedOpenTabIdx or familyWnd.tab:GetSelectedTab()
    if isFamily then
      familyWnd.tab:SelectTab(familyWnd.tab:GetSelectedTab())
    else
      familyWnd.tab:SelectTab(FAMILY_TAB.INTRODUCE)
    end
  end
  local function Refresh()
    TabButtonRefresh()
    local tabWnds = familyWnd.tab.window
    tabWnds[FAMILY_TAB.INFO]:Refresh()
    tabWnds[FAMILY_TAB.MEMBER]:Refresh()
  end
  function parent:OnShow()
    TabButtonRefresh(idx)
    reservedOpenTabIdx = nil
  end
  parent:SetHandler("OnShow", parent.OnShow)
  function parent:OnHide()
    local tabWnds = familyWnd.tab.window
    tabWnds[FAMILY_TAB.INFO]:OnHide()
  end
  parent:SetHandler("OnHide", parent.OnHide)
  function familyWnd.tab:OnTabChangedProc(selected)
    if selected == FAMILY_TAB.HAPPY_LIFE then
      X2Family:UpdateTodayAssignment()
    end
  end
  local events = {
    FAMILY_INFO_REFRESH = function()
      Refresh()
      X2Family:UpdateTodayAssignment()
    end
  }
  familyWnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(familyWnd, events)
end
function ToggleFamilyWindow(show)
  ToggleCommunityWindow(show, COMMUNITY.FAMILY)
end
ADDON:RegisterContentTriggerFunc(UIC_FAMILY_WND, ToggleFamilyWindow)
function ToggleFamilyAssignmentWithQuest(qType)
  reservedOpenTabIdx = FAMILY_TAB.HAPPY_LIFE
  ToggleFamilyWindow(true)
  familyWnd.tab:SelectTab(FAMILY_TAB.HAPPY_LIFE)
  familyWnd.tab.window[FAMILY_TAB.HAPPY_LIFE]:ToggleWithQuest(qType)
end
