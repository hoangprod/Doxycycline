local INSET = {
  VERTICAL = 48,
  HORIZON = 63,
  BUTTON = ICON_SIZE.DEFAULT - 1
}
local EXTENT = {
  HORIZON_WIDTH = 480,
  HORIZON_HEIGHT = 50,
  VERTICAL_WIDTH = 50,
  VERTICAL_HEIGHT = 465
}
local function SetViewOfBattlefieldActionBar(id, parent)
  local BATTLEFIELD_ACTION_SLOT_MAX_COUNT = 10
  local height = ICON_SIZE.DEFAULT * BATTLEFIELD_ACTION_SLOT_MAX_COUNT + (INSET.VERTICAL - 5)
  local frame = CreateEmptyWindow(id, parent)
  frame:Show(true)
  frame:SetExtent(EXTENT.VERTICAL_WIDTH, EXTENT.VERTICAL_HEIGHT)
  frame:Clickable(true)
  frame:EnableDrag(true)
  frame:SetUILayer("game")
  DrawEffectActionBarBackground(frame)
  frame.bg:SetCoords(573, 215, 51, 218)
  frame.direction = "vert"
  local rotateButton = frame:CreateChildWidget("button", "rotateButton", 0, true)
  rotateButton:Show(true)
  rotateButton:AddAnchor("TOP", frame, -2, 4)
  ApplyButtonSkin(rotateButton, BUTTON_HUD.ACTIONBAR_ROTATE)
  local killstreakLabel = frame:CreateChildWidget("label", "killstreakLabel", 0, true)
  killstreakLabel:SetAutoResize(true)
  killstreakLabel:SetHeight(FONT_SIZE.XLARGE)
  killstreakLabel:SetText("0")
  killstreakLabel:AddAnchor("TOP", rotateButton, "BOTTOM", -6, 0)
  killstreakLabel.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(killstreakLabel, FONT_COLOR.BATTLEFIELD_RED)
  local icon = killstreakLabel:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SCOREBOARD, "kill_icon", "background")
  icon:AddAnchor("LEFT", killstreakLabel, "RIGHT", 0, 1)
  frame.buttonStartIndex = 1
  frame.buttonEndIndex = BATTLEFIELD_ACTION_SLOT_MAX_COUNT
  local startIndex = frame.buttonStartIndex
  local endIndex = frame.buttonEndIndex
  frame.slot = {}
  for i = startIndex, endIndex do
    local yOffset = (i - startIndex) * INSET.BUTTON + INSET.VERTICAL
    local slot = CreateActionSlot(frame, "slot", ISLOT_INSTANT_KILL_STREAK, i)
    slot:AddAnchor("TOPLEFT", frame, 4, yOffset)
    slot.index = i
    frame.slot[i] = slot
    function slot:OnEnter()
      local info = self:GetTooltip()
      if info ~= nil then
        if self:GetBindedType() ~= "function" then
          ShowTooltip(info, self)
        else
          SetTooltip(info.tootipText, self)
        end
      end
    end
    slot:SetHandler("OnEnter", slot.OnEnter)
    function slot:OnLeave()
      HideTooltip()
    end
    slot:SetHandler("OnLeave", slot.OnLeave)
  end
  function frame:SetSlotHotkey()
    for i = self.buttonStartIndex, self.buttonEndIndex do
      local slot = self.slot[i]
      local hotKey = slot:GetHotKey(ISLOT_INSTANT_KILL_STREAK, slot.index)
      slot.keybindingLabel:SetText(F_TEXT.ConvertAbbreviatedBindingText(hotKey or ""))
    end
  end
  function frame:SetKillStreak(count)
    self.killstreakLabel:SetText(tostring(count))
  end
  return frame
end
local actionBarValues = {}
local function InitBattlefieldActionBar()
  actionBarValues = X2:GetCharacterUiData("actionBarValues")
  if actionBarValues == nil then
    actionBarValues = {}
  end
  if actionBarValues.axis == nil or Global_IsMatchedResolution() == false then
    actionBarValues.axis = {}
    actionBarValues.axis[2] = "horz"
    actionBarValues.axis[3] = "horz"
    actionBarValues.axis[4] = "horz"
    actionBarValues.axis[5] = "horz"
    actionBarValues.axis[6] = "horz"
    actionBarValues.axis[7] = "horz"
    actionBarValues.axis.battlefield = "vert"
  end
  if actionBarValues.dockingTargets == nil or Global_IsMatchedResolution() == false then
    actionBarValues.dockingTargets = {}
    actionBarValues.dockingTargets[2] = 3
    actionBarValues.dockingTargets[3] = 4
    actionBarValues.dockingTargets[4] = 1
    actionBarValues.dockingTargets[5] = 2
  end
end
InitBattlefieldActionBar()
local function SaveBattlefieldActionBarAxis(axis)
  actionBarValues.axis.battlefield = axis
  X2:SetCharacterUiData("actionBarValues", actionBarValues)
end
function CreateBattlefieldActionBar(id, parent)
  local frame = SetViewOfBattlefieldActionBar(id, parent)
  local OnEnterFrame = function(self)
    if self.isvisibleBg then
      return
    end
    self:OnEnterEffectSetting()
  end
  frame:SetHandler("OnEnter", OnEnterFrame)
  local OnLeaveFrame = function(self)
    if not self.isvisibleBg then
      return
    end
    self:OnLeaveEffectSetting()
  end
  frame:SetHandler("OnLeave", OnLeaveFrame)
  local OnDragStartFrame = function(self)
    HideTooltip()
    self:StartMoving()
    self.moving = true
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    F_ACTIONBAR.ReleaseDocking(self)
    F_ACTIONBAR.ShowAnchorTargetWithoutDocked()
  end
  frame:SetHandler("OnDragStart", OnDragStartFrame)
  local OnDragStopFrame = function(self)
    if self.moving == true then
      self:StopMovingOrSizing()
      self.moving = false
      F_ACTIONBAR.HideAllAnchorTarget()
      F_ACTIONBAR.TryDocking(self)
      X2Cursor:ClearCursor()
    end
  end
  frame:SetHandler("OnDragStop", OnDragStopFrame)
  function frame:SetHorizonBattlefieldActionBar(isClick)
    frame.direction = "horz"
    local startIndex = frame.buttonStartIndex
    local endIndex = frame.buttonEndIndex
    frame.bg:RemoveAllAnchors()
    frame.bg:SetCoords(452, 0, 277, 51)
    frame.bg:AddAnchor("TOPLEFT", frame, 0, 0)
    frame.bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
    if isClick then
      local x, y = frame:GetOffset()
      x = x - (EXTENT.HORIZON_WIDTH - EXTENT.HORIZON_HEIGHT)
      frame:RemoveAllAnchors()
      frame:AddAnchor("TOPLEFT", "UIParent", x, y)
    end
    frame:SetExtent(EXTENT.HORIZON_WIDTH, EXTENT.HORIZON_HEIGHT)
    frame.rotateButton:RemoveAllAnchors()
    frame.rotateButton:AddAnchor("RIGHT", frame, -6, 0)
    frame.killstreakLabel:RemoveAllAnchors()
    frame.killstreakLabel:AddAnchor("LEFT", frame, 7, 0)
    for i = startIndex, endIndex do
      local xOffset = (i - startIndex) * INSET.BUTTON + 40
      local slot = frame.slot[i]
      if slot ~= nil then
        slot:AddAnchor("TOPLEFT", frame, xOffset, 5)
      end
    end
    SaveBattlefieldActionBarAxis("horz")
  end
  function frame:SetVertialBattlefieldActionBar(isClick)
    frame.direction = "vert"
    frame.bg:RemoveAllAnchors()
    frame.bg:SetCoords(573, 215, 51, 218)
    frame.bg:AddAnchor("TOPLEFT", frame, 0, 0)
    frame.bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
    frame.rotateButton:RemoveAllAnchors()
    frame.rotateButton:AddAnchor("TOP", frame, -2, 4)
    frame.killstreakLabel:RemoveAllAnchors()
    frame.killstreakLabel:AddAnchor("TOP", frame.rotateButton, "BOTTOM", -6, 0)
    local startIndex = frame.buttonStartIndex
    local endIndex = frame.buttonEndIndex
    if isClick then
      local x, y = frame:GetOffset()
      x = x + (EXTENT.HORIZON_WIDTH - EXTENT.HORIZON_HEIGHT)
      frame:RemoveAllAnchors()
      frame:AddAnchor("TOPLEFT", "UIParent", x, y)
    end
    frame:SetExtent(EXTENT.VERTICAL_WIDTH, EXTENT.VERTICAL_HEIGHT)
    for i = startIndex, endIndex do
      local yOffset = (i - startIndex) * INSET.BUTTON + INSET.VERTICAL
      local slot = frame.slot[i]
      if slot ~= nil then
        slot:AddAnchor("TOPLEFT", frame, 4, yOffset)
      end
    end
    SaveBattlefieldActionBarAxis("vert")
  end
  local function SetRotate(isClick)
    if frame.direction == "vert" then
      frame:SetHorizonBattlefieldActionBar(isClick)
    elseif frame.direction == "horz" then
      frame:SetVertialBattlefieldActionBar(isClick)
    end
  end
  local function OnClickRotateButton()
    frame.isMoved = true
    SetRotate(true)
  end
  frame.rotateButton:SetHandler("OnClick", OnClickRotateButton)
  return frame
end
function ShowBattlefieldActionBar(isShow)
  if battlefield.actionbar == nil and isShow then
    battlefield.actionbar = CreateBattlefieldActionBar("battlefield.frame", "UIParent")
    battlefield.actionbar:Show(true)
    function battlefield.actionbar:MakeOriginWindowPos()
      if battlefield == nil or battlefield.actionbar == nil then
        return
      end
      battlefield.actionbar:RemoveAllAnchors()
      battlefield.actionbar:AddAnchor("RIGHT", "UIParent", 0, 0)
    end
    battlefield.actionbar:MakeOriginWindowPos()
    battlefield.actionbar:EnableHidingIsRemove(true)
    AddUISaveHandlerByKey("battlefield_actionbar", battlefield.actionbar)
    battlefield.actionbar:ApplyLastWindowOffset()
    if actionBarValues.axis.battlefield == "horz" then
      battlefield.actionbar:SetHorizonBattlefieldActionBar(false)
    else
      battlefield.actionbar:SetVertialBattlefieldActionBar(false)
    end
    battlefield.actionbar:SetSlotHotkey()
    do
      local events = {
        INSTANT_GAME_END = function()
          ShowBattlefieldActionBar(false)
        end,
        INSTANT_GAME_RETIRE = function()
          ShowBattlefieldActionBar(false)
        end,
        ENTERED_LOADING = function()
          ShowBattlefieldActionBar(false)
        end,
        LEAVED_INSTANT_GAME_ZONE = function()
          ShowBattlefieldActionBar(false)
        end,
        UPDATE_INSTANT_GAME_KILLSTREAK_COUNT = function(count)
          battlefield.actionbar:SetKillStreak(count)
        end,
        UPDATE_BINDINGS = function()
          battlefield.actionbar:SetSlotHotkey()
        end
      }
      battlefield.actionbar:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(battlefield.actionbar, events)
      local OnHideBattlefieldActionbar = function()
        battlefield.actionbar = nil
      end
      battlefield.actionbar:SetHandler("OnHide", OnHideBattlefieldActionbar)
    end
  end
  if battlefield.actionbar ~= nil then
    battlefield.actionbar:Show(isShow)
  end
end
local EnteredInstantGamezone = function()
  local skillInfo = X2BattleField:GetMyKillstreakSkillsInfos()
  local skillCount = tonumber(skillInfo.skill_count)
  ShowBattlefieldActionBar(skillCount ~= 0)
end
UIParent:SetEventHandler("ENTERED_INSTANT_GAME_ZONE", EnteredInstantGamezone)
local EnteredWorld = function()
  if X2BattleField:IsInInstantGame() == false then
    ShowBattlefieldActionBar(false)
    return
  end
  local skillInfo = X2BattleField:GetMyKillstreakSkillsInfos()
  local skillCount = tonumber(skillInfo.skill_count)
  ShowBattlefieldActionBar(skillCount ~= 0)
  if battlefield.actionbar ~= nil then
    local scoreInfo = X2BattleField:GetProgressScoreInfo()
    local myKillStreakPoint = tonumber(scoreInfo.myKillStreakPoint or 0)
    battlefield.actionbar:SetKillStreak(myKillStreakPoint)
  end
end
UIParent:SetEventHandler("ENTERED_WORLD", EnteredWorld)
function UpdateKillstreakSkills()
  local skillInfo = X2BattleField:GetMyKillstreakSkillsInfos()
  local skillCount = tonumber(skillInfo.skill_count)
  if skillCount == 0 then
    return
  end
  for i = 1, skillCount do
    battlefield.actionbar.slot[i]:Enable(skillInfo[i].enable)
  end
end
UIParent:SetEventHandler("UPDATE_INSTANT_GAME_KILLSTREAK", UpdateKillstreakSkills)
