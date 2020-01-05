local CreateAutoRegisteredEffect = function(slot)
  local flicker = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "overlay")
  flicker:SetInternalDrawType("ninepart")
  flicker:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  flicker:SetCoords(301, 124, 10, 10)
  flicker:SetInset(4, 4, 4, 4)
  flicker:AddAnchor("CENTER", slot, 0, 0)
  flicker:SetVisible(false)
  flicker:SetInterval(0.3)
  flicker:SetRepeatCount(2)
  flicker:SetEffectPriority(1, "alpha", 0.15, 0.15)
  flicker:SetEffectInitialColor(1, 1, 1, 1, 0)
  flicker:SetEffectFinalColor(1, 1, 1, 1, 0.5)
  flicker:SetEffectPriority(2, "alpha", 0.15, 0.15)
  flicker:SetEffectInitialColor(2, 1, 1, 1, 0.5)
  flicker:SetEffectFinalColor(2, 1, 1, 1, 0)
  flicker:SetEffectInterval(2, 0.3)
  slot.flicker = flicker
  local coords = {
    GetTextureInfo(TEXTURE_PATH.HUD, "yellow_frame"):GetCoords()
  }
  local inset = GetTextureInfo(TEXTURE_PATH.HUD, "yellow_frame"):GetInset()
  local lineEffect1 = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "overlay")
  lineEffect1:SetVisible(false)
  lineEffect1:SetInternalDrawType("ninepart")
  lineEffect1:SetCoords(coords[1], coords[2], coords[3], coords[4])
  lineEffect1:SetInset(inset[1], inset[2], inset[3], inset[4])
  lineEffect1:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  lineEffect1:AddAnchor("CENTER", slot, 0, 0)
  lineEffect1:SetInterval(0.2)
  lineEffect1:SetRepeatCount(1)
  lineEffect1:SetEffectPriority(1, "scalex", 0.3, 0.3)
  lineEffect1:SetEffectScale(1, 0.6, 1.2, 0.6, 1.2)
  lineEffect1:SetEffectInitialColor(1, 1, 1, 1, 0.7)
  lineEffect1:SetEffectFinalColor(1, 1, 1, 1, 0)
  lineEffect1:SetEffectInterval(1, 0.3)
  lineEffect1:SetEffectPriority(2, "scalex", 0.3, 0.3)
  lineEffect1:SetEffectScale(2, 0.6, 1.2, 0.6, 1.2)
  lineEffect1:SetEffectInitialColor(2, 1, 1, 1, 0.7)
  lineEffect1:SetEffectFinalColor(2, 1, 1, 1, 0)
  local lineEffect2 = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "overlay")
  lineEffect2:SetVisible(false)
  lineEffect2:SetInternalDrawType("ninepart")
  lineEffect2:SetCoords(coords[1], coords[2], coords[3], coords[4])
  lineEffect2:SetInset(inset[1], inset[2], inset[3], inset[4])
  lineEffect2:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  lineEffect2:AddAnchor("CENTER", slot, 0, 0)
  lineEffect2:SetInterval(0.4)
  lineEffect2:SetRepeatCount(1)
  lineEffect2:SetEffectPriority(1, "scalex", 0.3, 0.3)
  lineEffect2:SetEffectScale(1, 0.6, 1.2, 0.6, 1.2)
  lineEffect2:SetEffectInitialColor(1, 1, 1, 1, 0.7)
  lineEffect2:SetEffectFinalColor(1, 1, 1, 1, 0)
  lineEffect2:SetEffectInterval(1, 0.3)
  lineEffect2:SetEffectPriority(2, "scalex", 0.3, 0.3)
  lineEffect2:SetEffectScale(2, 0.6, 1.2, 0.6, 1.2)
  lineEffect2:SetEffectInitialColor(2, 1, 1, 1, 0.7)
  lineEffect2:SetEffectFinalColor(2, 1, 1, 1, 0)
  local arrow = DrawArrowMoveAnim(slot, "v")
  arrow:AddAnchor("BOTTOM", slot, "TOP", 0, -30)
  function slot:StartEffect()
    arrow:Animation(true, false)
    lineEffect1:SetStartEffect(true)
    lineEffect2:SetStartEffect(true)
    flicker:SetStartEffect(true)
  end
  function slot:CancelEffect()
    arrow:Animation(false, false)
    lineEffect1:SetStartEffect(false)
    lineEffect2:SetStartEffect(false)
    flicker:SetStartEffect(false)
  end
end
function ActionBar_GetIndex(actionBar)
  for i = 1, #actionBar_renewal do
    if actionBar_renewal[i] == actionBar then
      return i
    end
  end
end
function ActionBar_SettingTooltip(actionBar)
  for i = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
    do
      local slot = actionBar.slot[i]
      if slot ~= nil then
        function slot:OnEnter()
          local tip = slot:GetTooltip(ISLOT_ACTION, slot.index)
          SetTooltipDelayTime(1000)
          ShowTooltip(tip, self, 1, tip.equiped, ONLY_BASE)
        end
        slot:SetHandler("OnEnter", slot.OnEnter)
        function slot:OnLeave()
          HideTooltip()
        end
        slot:SetHandler("OnLeave", slot.OnLeave)
      end
    end
  end
end
function ActionBar_SettingToRotate(actionBar)
  if actionBar.direction == nil or actionBar.direction == "horz" then
    ActionBar_SetLayoutOfVertical(actionBar, true)
  else
    ActionBar_SetLayoutOfHorizon(actionBar, true)
  end
end
local ProcAnimEffect = function()
  for i = 1, #actionBar_renewal do
    do
      local applyAnimActionBar = actionBar_renewal[i]
      if applyAnimActionBar.buttonStartIndex > 36 then
        return
      end
      local startAnimCondition = false
      local endAnimCondition = true
      local animIconSize = ICON_SIZE.DEFAULT
      local alpha = 1
      if applyAnimActionBar.OnUpdate == nil then
        function applyAnimActionBar:OnUpdate(dt)
          if not startAnimCondition then
            animIconSize = animIconSize - 5
            alpha = alpha - 0.4
          end
          if not endAnimCondition then
            animIconSize = animIconSize + 5
            alpha = alpha + 0.4
          end
          if animIconSize < 0 then
            startAnimCondition = true
            endAnimCondition = false
            if self.pageChangedIndex then
              X2Action:SetActionBarPage(self.pageChangedIndex)
            end
          end
          for i = self.buttonStartIndex, self.buttonEndIndex do
            local slot = self.slot[i]
            slot:ResetAllAnimEffect()
            slot.icon:RemoveAllAnchors()
            slot.icon:AddAnchor("CENTER", slot, 0, 0)
            slot.icon:SetHeight(animIconSize)
            slot.gradeIcon:SetHeight(animIconSize)
            slot.stateImage:SetHeight(animIconSize)
            slot.keybindingLabel:SetAlpha(alpha)
            slot.stackLabel:SetAlpha(alpha)
          end
          if self.pageControl then
            self.pageControl:Enable(false)
          end
          if animIconSize == ICON_SIZE.DEFAULT then
            startAnimCondition = false
            endAnimCondition = true
            animIconSize = ICON_SIZE.DEFAULT
            if self.pageControl then
              self.pageControl:Enable(true)
            end
            self:ReleaseHandler("OnUpdate")
          end
        end
      end
      applyAnimActionBar:SetHandler("OnUpdate", applyAnimActionBar.OnUpdate)
    end
  end
end
local isLock
local function IsActionBarLocked()
  if isLock == nil then
    isLock = GetOptionItemValue(OPTION_ITEM_ACTION_BAR_LOCK)
  end
  return isLock
end
local function ActionBarLock(lock)
  SetOptionItemValue(OPTION_ITEM_ACTION_BAR_LOCK, lock)
  isLock = lock
end
function ActionBar_RegisterEventerHandler(actionBar)
  actionBar:EnableDrag(true)
  function actionBar:OnDragStart(arg)
    if IsActionBarLocked() == ACTIONBAR_STATE.LOCK then
      return
    end
    HideTooltip()
    self:StartMoving()
    self.moving = true
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    F_ACTIONBAR.ReleaseDocking(self)
    F_ACTIONBAR.ShowAnchorTargetWithoutDocked()
  end
  actionBar:SetHandler("OnDragStart", actionBar.OnDragStart)
  function actionBar:OnDragStop()
    if self.moving == true then
      self:StopMovingOrSizing()
      self.moving = false
      F_ACTIONBAR.HideAllAnchorTarget()
      F_ACTIONBAR.TryDocking(self)
      X2Cursor:ClearCursor()
    end
  end
  actionBar:SetHandler("OnDragStop", actionBar.OnDragStop)
  function actionBar:OnScale()
    self:ValidOutOfScreen()
  end
  actionBar:SetHandler("OnScale", actionBar.OnScale)
  function actionBar:OnEnter()
    if X2:IsInClientDrivenZone() == true then
      return
    end
    actionBar.onEnter = true
    if self.lockButton ~= nil and self.isvisibleBg == false and not actionBar_renewal[1].temporarilyUnlock then
      self:OnEnterEffectSetting()
      self.lockButton:Show(true, 800)
    end
    if self.rotateButton ~= nil and IsActionBarLocked() == ACTIONBAR_STATE.UNLOCK and self.isvisibleBg == false then
      self:OnEnterEffectSetting()
      self.rotateButton:Show(true, 800)
    end
    if self.pageControl ~= nil and not actionBar_renewal[1].temporarilyUnlock then
      self.pageControl.prevPageButton:Show(true, 800)
      self.pageControl.nextPageButton:Show(true, 800)
    end
  end
  actionBar:SetHandler("OnEnter", actionBar.OnEnter)
  function actionBar:OnLeave()
    if X2:IsInClientDrivenZone() == true then
      return
    end
    actionBar.onEnter = false
    if self.lockButton ~= nil and self.isvisibleBg and not actionBar_renewal[1].temporarilyUnlock then
      self:OnLeaveEffectSetting()
      self.lockButton:Show(false, 300)
    end
    if self.rotateButton ~= nil then
      if IsActionBarLocked() == ACTIONBAR_STATE.UNLOCK then
        if not actionBar_renewal[1].temporarilyUnlock then
          self:OnLeaveEffectSetting()
          self.rotateButton:Show(false, 300)
        end
      else
        return
      end
    end
    if self.pageControl ~= nil and not actionBar_renewal[1].temporarilyUnlock then
      self.pageControl.prevPageButton:Show(false, 300)
      self.pageControl.nextPageButton:Show(false, 300)
    end
  end
  actionBar:SetHandler("OnLeave", actionBar.OnLeave)
  if actionBar.rotateButton ~= nil then
    function actionBar.rotateButton:OnClick()
      local widget = self:GetParent()
      ActionBar_SettingToRotate(widget)
    end
    actionBar.rotateButton:SetHandler("OnClick", actionBar.rotateButton.OnClick)
  end
  if actionBar.lockButton ~= nil then
    function actionBar.lockButton:OnClick()
      if IsActionBarLocked() == ACTIONBAR_STATE.UNLOCK then
        ActionBarLock(ACTIONBAR_STATE.LOCK)
        actionBar.lockState = ACTIONBAR_STATE.LOCK
        ChangeButtonSkin(self, BUTTON_HUD.ACTIONBAR_LOCK)
      else
        ActionBarLock(ACTIONBAR_STATE.UNLOCK)
        actionBar.lockState = ACTIONBAR_STATE.UNLOCK
        ChangeButtonSkin(self, BUTTON_HUD.ACTIONBAR_UNLOCK)
      end
    end
    actionBar.lockButton:SetHandler("OnClick", actionBar.lockButton.OnClick)
  end
  if actionBar.pageControl then
    function actionBar.pageControl:OnPageChanged(pageIndex, countPerPage)
      actionBar.pageChangedIndex = pageIndex
      ProcAnimEffect()
    end
  end
end
local actionBarValues = {}
local function SaveActionBarValues()
  X2:SetCharacterUiData("actionBarValues", actionBarValues)
end
function ActionBar_InitValues(clear)
  if clear then
    actionBarValues = {}
  else
    actionBarValues = X2:GetCharacterUiData("actionBarValues")
  end
  if actionBarValues == nil then
    actionBarValues = {}
  end
  if actionBarValues.axis == nil then
    actionBarValues.axis = {}
  end
  if actionBarValues.dockingTargets == nil or Global_IsMatchedResolution() == false then
    actionBarValues.dockingTargets = {}
    actionBarValues.dockingTargets[2] = 3
    actionBarValues.dockingTargets[3] = 4
    actionBarValues.dockingTargets[4] = 1
    actionBarValues.dockingTargets[5] = 2
  end
  if clear then
    SaveActionBarValues()
  end
end
ActionBar_InitValues(false)
function ActionBar_SetState(index)
  local acWnd = actionBar_renewal[index]
  if actionBarValues.axis[index] == "vert" then
    ActionBar_SetLayoutOfVertical(acWnd, false)
  else
    ActionBar_SetLayoutOfHorizon(acWnd, false)
  end
  local targetIndex = actionBarValues.dockingTargets[index]
  if targetIndex ~= nil then
    local target = actionBar_dockingWindow[targetIndex]
    F_ACTIONBAR.ReleaseDocking(acWnd)
  end
end
function ActionBar_SetDockingTarget(actionBarIndex, dockingTargetIndex)
  actionBarValues.dockingTargets[actionBarIndex] = dockingTargetIndex
  SaveActionBarValues()
end
local ActionBar_AddUISaveHandler = function(actionBar, id)
  function actionBar:ProcCorrectOffset(info)
    local bound = info.bound
    local screenRes = info.screenResolution
    if screenRes.scale == nil or screenRes.scale == 0 then
      screenRes.scale = 1
    end
    local effectiveWidth = bound.width * screenRes.scale
    local effectiveHeight = bound.height * screenRes.scale
    local leftRatio = bound.x / screenRes.x
    local rightRatio = 0 <= (screenRes.x - bound.x - effectiveWidth) / screenRes.x and (screenRes.x - bound.x - effectiveWidth) / screenRes.x or 0
    local anchorX = leftRatio < rightRatio and "LEFT" or "RIGHT"
    local topRatio = bound.y / screenRes.y
    local bottomRatio = 0 <= (screenRes.y - bound.y - effectiveHeight) / screenRes.y and (screenRes.y - bound.y - effectiveHeight) / screenRes.y or 0
    local anchorY = topRatio < bottomRatio and "TOP" or "BOTTOM"
    local newScreenRes = {}
    newScreenRes.x = UIParent:GetScreenWidth()
    newScreenRes.y = UIParent:GetScreenHeight()
    self:RemoveAllAnchors()
    if anchorX == "LEFT" then
      if anchorY == "TOP" then
        self:AddAnchor("TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(newScreenRes.x * leftRatio), F_LAYOUT.CalcDontApplyUIScale(newScreenRes.y * topRatio))
      else
        self:AddAnchor("BOTTOMLEFT", F_LAYOUT.CalcDontApplyUIScale(newScreenRes.x * leftRatio), -F_LAYOUT.CalcDontApplyUIScale(newScreenRes.y * bottomRatio))
      end
    elseif anchorY == "TOP" then
      self:AddAnchor("TOPRIGHT", -F_LAYOUT.CalcDontApplyUIScale(newScreenRes.x * rightRatio), F_LAYOUT.CalcDontApplyUIScale(newScreenRes.y * topRatio))
    else
      self:AddAnchor("BOTTOMRIGHT", -F_LAYOUT.CalcDontApplyUIScale(newScreenRes.x * rightRatio), -F_LAYOUT.CalcDontApplyUIScale(newScreenRes.y * bottomRatio))
    end
  end
  AddUISaveHandlerByKey(string.format("actionBar_renewal%d", id), actionBar, true)
end
function SetActoinBarAxis(index, axis)
  actionBarValues.axis[index] = axis
  SaveActionBarValues()
end
for i = 2, #actionBar_renewal do
  ActionBar_SetState(i)
end
for i = 1, #actionBar_renewal do
  ActionBar_RegisterEventerHandler(actionBar_renewal[i])
  ActionBar_SettingHotkey(actionBar_renewal[i])
  ActionBar_SettingTooltip(actionBar_renewal[i])
  ActionBar_AddUISaveHandler(actionBar_renewal[i], i)
  actionBar_renewal[i]:ApplyLastWindowOffset()
  actionBar_renewal[i]:ValidOutOfScreen()
end
local UpdateAllActionBarVisible = function()
  local show = X2Unit:GetShortcutSkillCount() == 0
  local isBattleShipMode = X2BattleField:GetGameMode() == 3
  for i = 1, #actionBar_renewal do
    if show and not isBattleShipMode then
      CheckActionBarVisibleStateByOption()
    else
      actionBar_renewal[i]:Show(false)
    end
    ActionBar_SlotEnable(actionBar_renewal[i], not isBattleShipMode)
  end
end
local actionBar_eventWindow = UIParent:CreateWidget("emptywidget", "actionBar_eventWindow", "UIParent")
actionBar_eventWindow:Show(true)
local events = {
  ENTERED_WORLD = function()
    actionBar_renewal[1].lockState = IsActionBarLocked()
    if IsActionBarLocked() == ACTIONBAR_STATE.UNLOCK then
      ChangeButtonSkin(actionBar_renewal[1].lockButton, BUTTON_HUD.ACTIONBAR_UNLOCK)
    else
      ChangeButtonSkin(actionBar_renewal[1].lockButton, BUTTON_HUD.ACTIONBAR_LOCK)
    end
    if X2:IsInClientDrivenZone() == true then
      actionBar_renewal[1].lockButton:Show(false)
      actionBar_renewal[1].pageControl:Show(false)
    end
    UpdateAllActionBarVisible()
  end,
  UPDATE_BINDINGS = function()
    for i = 1, #actionBar_renewal do
      ActionBar_SettingHotkey(actionBar_renewal[i])
    end
    UpdateAllActionBarVisible()
  end,
  UPDATE_BINDINGS_DEMOMODE = function()
    for i = 1, #actionBar_renewal do
      ActionBar_SettingHotkey_DemoMode(actionBar_renewal[i])
    end
  end,
  ACTION_BAR_PAGE_CHANGED = function(page)
    if actionBar_renewal[1].pageControl ~= nil and actionBar_renewal[1].pageChangedIndex ~= page then
      actionBar_renewal[1].pageControl:SetCurrentPage(page, true)
    end
    local actionBar = actionBar_renewal[1]
    for j = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
      local slot = actionBar.slot[j]
      if slot.flicker ~= nil then
        slot:CancelEffect()
      end
    end
  end,
  ACTION_BAR_AUTO_REGISTERED = function(slotIndex)
    for i = 1, AUTO_REGISTER_ACTIONBAR_NUM do
      local actionBar = actionBar_renewal[i]
      for j = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
        local slot = actionBar.slot[j]
        if slotIndex == slot.slotIdx then
          if slot.flicker == nil then
            CreateAutoRegisteredEffect(slot)
          end
          slot:StartEffect()
          return
        end
      end
    end
  end,
  UPDATE_SHORTCUT_SKILLS = function()
    UpdateAllActionBarVisible()
  end,
  LEFT_LOADING = function()
    UpdateAllActionBarVisible()
  end,
  INSTANT_GAME_END = function()
    UpdateAllActionBarVisible()
  end,
  INSTANT_GAME_RETIRE = function()
    UpdateAllActionBarVisible()
  end,
  ENTERED_INSTANT_GAME_ZONE = function()
    UpdateAllActionBarVisible()
  end
}
actionBar_eventWindow:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(actionBar_eventWindow, events)
CheckActionBarVisibleStateByOption()
