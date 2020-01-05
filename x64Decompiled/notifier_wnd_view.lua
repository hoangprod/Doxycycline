local screenHeight = UIParent:GetScreenHeight()
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreatNotifierWindow()
  local wnd = CreateEmptyWindow("notifierWindow", "UIParent")
  function wnd:MakeOriginWindowPos()
    if wnd == nil then
      return
    end
    wnd:RemoveAllAnchors()
    wnd:SetExtent(questLocale.notifier.gridWidth + 40, questContext.notifierGrid.height)
    wnd:AddAnchor("TOPRIGHT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(3), F_LAYOUT.CalcDontApplyUIScale(screenHeight / 2 - 100))
    if SetNofifierHeight ~= nil then
      SetNofifierHeight(questContext.notifierGrid.height)
    end
    if wnd.Refresh then
      wnd:Refresh()
    end
  end
  wnd:MakeOriginWindowPos()
  wnd:SetResizingBorderSize(0, 0, 0, 10)
  wnd:SetMaxResizingExtent(questLocale.notifier.gridWidth + 50, screenHeight)
  wnd:UseResizing(true)
  wnd:Show(true)
  ADDON:RegisterContentWidget(UIC_QUEST_NOTIFIER, wnd)
  wnd.isOpen = true
  local toggleBtn = wnd:CreateChildWidget("button", "toggleBtn", 0, true)
  toggleBtn:AddAnchor("TOPRIGHT", wnd, "TOPRIGHT", 0, 0)
  toggleBtn.isOpen = true
  ApplyButtonSkin(toggleBtn, BUTTON_HUD.QUEST_CLOSE)
  local anchorTarget = wnd
  local targetAnchor = "TOPLEFT"
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.achievement or featureSet.todayAssignment then
    local questBtn = wnd:CreateChildWidget("button", "questBtn", 0, true)
    ApplyButtonSkinTable(questBtn, BUTTON_BASIC.QUEST_NOTIFIER)
    questBtn:AddAnchor("TOPLEFT", wnd, 0, 0)
    questBtn:Show(true)
    local questNotifier = CreateQuestNotifierWnd("questNotifier", wnd)
    questNotifier:AddAnchor("TOPLEFT", wnd, 0, 35)
    questNotifier:AddAnchor("BOTTOMRIGHT", wnd, 0, -10)
    questNotifier:Show(false)
    local assignmentBtn = wnd:CreateChildWidget("button", "assignmentBtn", 0, true)
    ApplyButtonSkinTable(assignmentBtn, BUTTON_BASIC.ASSIGNMENT_NOTIFIER)
    assignmentBtn:AddAnchor("TOPLEFT", questBtn, "TOPRIGHT", 0, 0)
    local assignmentNotifier = CreateAssignmentNotifierWnd("assignmentNotifier", wnd)
    assignmentNotifier:AddAnchor("TOPLEFT", wnd, 0, 35)
    assignmentNotifier:AddAnchor("BOTTOMRIGHT", wnd, 0, -10)
    assignmentNotifier:Show(false)
    anchorTarget = wnd.assignmentBtn
    targetAnchor = "TOPRIGHT"
  else
    local questNotifier = CreateQuestNotifierWnd("questNotifier", wnd)
    questNotifier:AddAnchor("TOPLEFT", wnd, sideMargin / 2, 35)
    questNotifier:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin / 2, -sideMargin / 2)
  end
  local moveWnd = wnd:CreateChildWidget("emptywidget", "moveWnd", 0, true)
  moveWnd:AddAnchor("TOPLEFT", anchorTarget, targetAnchor, 0, 0)
  moveWnd:AddAnchor("TOPRIGHT", toggleBtn, "TOPLEFT", 0, 0)
  moveWnd:SetHeight(30)
  moveWnd:EnableDrag(true)
  wnd.bg = wnd:CreateDrawable(TEXTURE_PATH.HUD, "bg_quest", "background")
  wnd.bg:SetTextureColor("grey")
  wnd.bg:AddAnchor("TOPLEFT", wnd.questNotifier, -13, -5)
  wnd.bg:AddAnchor("BOTTOMRIGHT", wnd.questNotifier, 7, 15)
  return wnd
end
