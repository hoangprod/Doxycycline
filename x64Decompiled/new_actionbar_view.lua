ACTIONBAR_STATE = {UNLOCK = 0, LOCK = 1}
local MAIN_ACTION_SLOT_MAX_COUNT = 12
local SUB_ACTION_SLOT_MAX_COUNT = 48
local SUB_ACTION_BAR_COUNT = 8
local BUTTON_INSET = ICON_SIZE.DEFAULT - 1
local ACTION_BAR_LONG_LENGTH = 277
local ACTION_BAR_SHORT_LENGTH = 51
function ActionBar_SettingHotkey(actionBar)
  for i = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
    local slot = actionBar.slot[i]
    local hotKey = slot:GetHotKey(ISLOT_ACTION, slot.index)
    slot.keybindingLabel:SetText(F_TEXT.ConvertAbbreviatedBindingText(hotKey or ""))
  end
end
function ActionBar_SettingHotkey_DemoMode(actionBar)
  for i = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
    local slot = actionBar.slot[i]
    slot:EstablishSlot(ISLOT_ACTION, i)
    local hotKey = slot:GetHotKey(ISLOT_ACTION, slot.index)
    slot.keybindingLabel:SetText(F_TEXT.ConvertAbbreviatedBindingText(hotKey or ""))
  end
end
function ActionBar_SlotEnable(actionBar, enable)
  for i = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
    local slot = actionBar.slot[i]
    slot:Enable(enable)
  end
end
function CreateActionBarRenewal_main(id)
  local width = ICON_SIZE.DEFAULT * MAIN_ACTION_SLOT_MAX_COUNT + 50
  local frame = CreateEmptyWindow(id, "UIParent")
  frame:Show(true)
  function frame:MakeOriginWindowPos()
    if frame == nil then
      return
    end
    frame:RemoveAllAnchors()
    frame:SetExtent(width, 50)
    frame:AddAnchor("BOTTOM", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(-6))
  end
  frame:MakeOriginWindowPos()
  frame:Clickable(true)
  frame:EnableDrag(true)
  frame:SetUILayer("game")
  frame.temporarilyUnlock = false
  frame.lockState = false
  DrawEffectActionBarBackground(frame)
  local lockButton = frame:CreateChildWidget("button", "lockButton", 0, true)
  lockButton:Show(false)
  lockButton:AddAnchor("LEFT", frame, 4, 0)
  ApplyButtonSkin(lockButton, BUTTON_HUD.ACTIONBAR_UNLOCK)
  local pageControl = W_CTRL.CreatePageControl(frame:GetId() .. ".pageControl", frame, "actionBar")
  pageControl:AddAnchor("LEFT", lockButton, "RIGHT", -1, 0)
  pageControl:SetTitleStyle("", "actionBar")
  pageControl:UseActionBarPageRotate()
  pageControl:SetPageByItemCount(36, 12)
  pageControl.prevPageButton:Show(false)
  pageControl.nextPageButton:Show(false)
  frame.pageControl = pageControl
  frame.buttonStartIndex = 1
  frame.buttonEndIndex = MAIN_ACTION_SLOT_MAX_COUNT
  local pageNum = X2Action:GetActionBarPage()
  frame.pageControl:SetCurrentPage(pageNum, true)
  frame.pageChangedIndex = pageNum
  frame.iconHeight = ICON_SIZE.DEFAULT
  frame.slot = {}
  for i = 1, MAIN_ACTION_SLOT_MAX_COUNT do
    if i < 7 then
      xOffset = 43 + (i - 1) * BUTTON_INSET
    else
      xOffset = 43 + (i - 1) * BUTTON_INSET + 10
    end
    local slot = CreateActionSlot(frame, "slot", ISLOT_ACTION, i)
    slot:AddAnchor("LEFT", frame, xOffset, 1)
    slot.index = i
  end
  function frame:ValidOutOfScreen()
    if self:CheckOutOfScreen() then
      F_ACTIONBAR.TryDocking(self)
    end
  end
  return frame
end
local left_xOffset = 122
local right_xOffset = 159
local side_left_xOffset = 398
local side_right_xOffset = 438
local first_yOffset = 50
local second_yOffset = 95
local SUB_ANCHORS = {
  {
    x = -left_xOffset,
    y = -first_yOffset
  },
  {
    x = right_xOffset,
    y = -first_yOffset
  },
  {
    x = -left_xOffset,
    y = -second_yOffset
  },
  {
    x = right_xOffset,
    y = -second_yOffset
  },
  {
    x = -side_left_xOffset,
    y = -second_yOffset
  },
  {
    x = side_right_xOffset,
    y = -second_yOffset
  },
  {
    x = -side_left_xOffset,
    y = -first_yOffset
  },
  {
    x = side_right_xOffset,
    y = -first_yOffset
  }
}
function CreateActionBarRenewal_sub(id, maxActionSlot, actionBarCount, barNum, buttonStartIndex)
  local frame = CreateEmptyWindow(id, "UIParent")
  frame:Show(true)
  function frame:MakeOriginWindowPos()
    frame:RemoveAllAnchors()
    frame:SetExtent(345, 50)
    frame:AddAnchor("BOTTOM", F_LAYOUT.CalcDontApplyUIScale(SUB_ANCHORS[barNum].x), F_LAYOUT.CalcDontApplyUIScale(SUB_ANCHORS[barNum].y))
    if ActionBar_SetState ~= nil then
      ActionBar_SetState(barNum + 1)
    end
    if self.ValidOutOfScreen ~= nil then
      self:ValidOutOfScreen()
    end
  end
  frame:MakeOriginWindowPos()
  frame:Clickable(true)
  frame:EnableDrag(true)
  frame:SetUILayer("game")
  if barNum % 2 == 0 then
    frame.button_direction = "right"
  else
    frame.button_direction = "left"
  end
  DrawEffectActionBarBackground(frame)
  function frame:ValidOutOfScreen()
    if self:CheckOutOfScreen() then
      F_ACTIONBAR.TryDocking(self)
    end
  end
  if buttonStartIndex ~= nil then
    frame.buttonStartIndex = buttonStartIndex + 1
    frame.buttonEndIndex = buttonStartIndex + maxActionSlot / actionBarCount
  end
  local rotateButton = frame:CreateChildWidget("button", "rotateButton", 0, true)
  rotateButton:Show(false)
  ApplyButtonSkin(rotateButton, BUTTON_HUD.ACTIONBAR_ROTATE)
  local startIndex = frame.buttonStartIndex
  local endIndex = frame.buttonEndIndex
  frame.slot = {}
  for i = startIndex, endIndex do
    local xOffset = (i - startIndex) * BUTTON_INSET + 35
    local slot = CreateActionSlot(frame, "slot", ISLOT_ACTION, i)
    slot:AddAnchor("TOPLEFT", frame, xOffset, 2)
    slot.index = i
  end
  return frame
end
actionBar_renewal = {}
local main_actionBar = CreateActionBarRenewal_main("main_actionBar", "UIParent")
table.insert(actionBar_renewal, main_actionBar)
ADDON:RegisterContentWidget(UIC_MAIN_ACTION_BAR, main_actionBar)
for i = 1, SUB_ACTION_BAR_COUNT do
  local id = string.format("sub_actionBar[%d]", i)
  local sub_actionBar = CreateActionBarRenewal_sub(id, SUB_ACTION_SLOT_MAX_COUNT, SUB_ACTION_BAR_COUNT, i, 12 + (i - 1) * 6)
  table.insert(actionBar_renewal, sub_actionBar)
end
function ActionBar_SetLayoutOfVertical(actionBar, isClick)
  actionBar.direction = "vert"
  actionBar.bg:RemoveAllAnchors()
  actionBar.bg:SetCoords(573, 215, 51, 218)
  actionBar.bg:AddAnchor("TOPLEFT", actionBar, 0, 0)
  actionBar.bg:AddAnchor("BOTTOMRIGHT", actionBar, 0, 0)
  actionBar.rotateButton:RemoveAllAnchors()
  actionBar.rotateButton:AddAnchor("TOP", actionBar, -2, 4)
  local startIndex = actionBar.buttonStartIndex
  local endIndex = actionBar.buttonEndIndex
  if isClick and actionBar.button_direction == "right" then
    local x, y = actionBar:GetOffset()
    x = x + (ACTION_BAR_LONG_LENGTH - ACTION_BAR_SHORT_LENGTH)
    actionBar:RemoveAllAnchors()
    actionBar:AddAnchor("TOPLEFT", "UIParent", x, y)
  end
  actionBar:SetExtent(ACTION_BAR_SHORT_LENGTH, ACTION_BAR_LONG_LENGTH)
  for i = startIndex, endIndex do
    local yOffset = (i - startIndex) * BUTTON_INSET + 26
    local slot = actionBar.slot[i]
    if slot ~= nil then
      slot:AddAnchor("TOPLEFT", actionBar, 4, yOffset)
    end
  end
  local index = ActionBar_GetIndex(actionBar)
  if index ~= nil and withOutSave ~= true then
    SetActoinBarAxis(index, "vert")
  end
end
function ActionBar_SetLayoutOfHorizon(actionBar, isClick)
  actionBar.direction = "horz"
  actionBar:SetExtent(ACTION_BAR_LONG_LENGTH, ACTION_BAR_SHORT_LENGTH)
  local startIndex = actionBar.buttonStartIndex
  local endIndex = actionBar.buttonEndIndex
  actionBar.bg:RemoveAllAnchors()
  actionBar.bg:SetCoords(452, 0, 277, 51)
  actionBar.bg:AddAnchor("TOPLEFT", actionBar, 0, 0)
  actionBar.bg:AddAnchor("BOTTOMRIGHT", actionBar, 0, 0)
  if actionBar.button_direction == nil or actionBar.button_direction == "left" then
    actionBar.rotateButton:RemoveAllAnchors()
    actionBar.rotateButton:AddAnchor("LEFT", actionBar, 1, 0)
    for i = startIndex, endIndex do
      local xOffset = (i - startIndex) * BUTTON_INSET + 26
      local slot = actionBar.slot[i]
      if slot ~= nil then
        slot:AddAnchor("TOPLEFT", actionBar, xOffset, 5)
      end
    end
    if isClick then
      local x, y = actionBar:GetOffset()
      actionBar:RemoveAllAnchors()
      actionBar:AddAnchor("TOPLEFT", "UIParent", x, y)
    end
  else
    actionBar.rotateButton:RemoveAllAnchors()
    actionBar.rotateButton:AddAnchor("RIGHT", actionBar, -4, 0)
    for i = startIndex, endIndex do
      local xOffset = (i - startIndex) * BUTTON_INSET + 1
      local slot = actionBar.slot[i]
      if slot ~= nil then
        slot:AddAnchor("TOPLEFT", actionBar, xOffset, 5)
      end
    end
    if isClick then
      local x, y = actionBar:GetOffset()
      x = x - (ACTION_BAR_LONG_LENGTH - ACTION_BAR_SHORT_LENGTH)
      actionBar:RemoveAllAnchors()
      actionBar:AddAnchor("TOPLEFT", "UIParent", x, y)
    end
  end
  local index = ActionBar_GetIndex(actionBar)
  if index ~= nil and withOutSave ~= true then
    SetActoinBarAxis(index, "horz")
  end
end
function SkillSlotMoveTest()
  main_actionBar:ReleaseHandler("OnUpdate")
  local slotAnimationStartTime = {}
  for i = 1, MAIN_ACTION_SLOT_MAX_COUNT do
    slotAnimationStartTime[i] = {
      800 * (i - 1),
      false
    }
    main_actionBar.slot[i]:SetMoveAnimation("top", 10 + i * 3, 0.4, 2)
  end
  local maxTime = 0
  local curTime = 0
  for i = 1, #slotAnimationStartTime do
    local item = slotAnimationStartTime[i]
    if maxTime < item[1] then
      maxTime = item[1] or maxTime
    end
  end
  local function StartAnimation(self, dt)
    curTime = curTime + dt
    for i = 1, MAIN_ACTION_SLOT_MAX_COUNT do
      if slotAnimationStartTime[i][2] == false and slotAnimationStartTime[i][1] <= curTime then
        self.slot[i]:TriggerMoveAnimation(true)
        slotAnimationStartTime[i][2] = true
      end
    end
    if curTime > maxTime then
      self:ReleaseHandler("OnUpdate")
    end
  end
  main_actionBar:SetHandler("OnUpdate", StartAnimation)
end
