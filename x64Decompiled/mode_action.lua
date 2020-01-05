local BACKGROUND_HORIZON_INSET = 10
local BACKGROUND_VERTICAL_INSET = 10
local ACTION_BUTTON_WIDTH = 48
local ACTION_BUTTON_GAP = -1
local OFFSET_FROM_DYNAMIC_ACTION_BAR = 5
local MODESKILL_BIND_STRING = "ModeSkillActionButton"
local ROW_MAX_MODE_ACTION = 5
local function CreateModeSkillActionBar(id, parent)
  local w = CreateEmptyWindow(id, parent)
  w:Show(false)
  local barWidth = OFFSET_FROM_DYNAMIC_ACTION_BAR * ACTION_BUTTON_WIDTH + (OFFSET_FROM_DYNAMIC_ACTION_BAR - 1) * ACTION_BUTTON_GAP
  local posX = UIParent:GetScreenWidth() / 2 + barWidth / 2
  local posY = UIParent:GetScreenHeight() / 4 * 2.75
  function w:MakeOriginWindowPos(reset)
    if w == nil then
      return
    end
    w:RemoveAllAnchors()
    w:SetExtent(100, 56)
    if w.ShowModeSkillActionBar ~= nil then
      w:ShowModeSkillActionBar()
    end
    if reset then
      w:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(posX), F_LAYOUT.CalcDontApplyUIScale(posY))
    else
      w:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", posX, posY)
    end
  end
  w:MakeOriginWindowPos()
  w:SetUILayer("game")
  DrawEffectActionBarBackground(w)
  w.buttons = {}
  for i = 1, MAX_MODE_ACTION_COUNT do
    local button = CreateActionSlot(w, "mode_action_slot", ISLOT_MODE_ACTION, i)
    button:Show(false)
    button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    button:AddAnchor("LEFT", w, (i - 1) * ICON_SIZE.DEFAULT + BACKGROUND_HORIZON_INSET, 0)
    w.buttons[i] = button
  end
  for i = 1, #w.buttons do
    local button = w.buttons[i]
    function button:OnEnter()
      local info = self:GetTooltip()
      if info ~= nil then
        if self:GetBindedType() ~= "function" then
          ShowTooltip(info, self)
        else
          SetTooltip(info.tootipText, self)
        end
      end
    end
    button:SetHandler("OnEnter", button.OnEnter)
    function button:OnLeave()
      HideTooltip()
    end
    button:SetHandler("OnLeave", button.OnLeave)
  end
  function w:UpdateBindings(index)
    local slot = self.buttons[index]
    local hotKey = slot:GetHotKey()
    slot.keybindingLabel:SetText(F_TEXT.ConvertAbbreviatedBindingText(hotKey or ""))
  end
  function w:ShowModeSkillActionBar()
    local skillCount = X2Unit:GetModeActionsCount()
    for i = 1, #w.buttons do
      local button = w.buttons[i]
      if i <= skillCount then
        button:Show(true)
        button:EstablishSlot(ISLOT_MODE_ACTION, i)
        self:UpdateBindings(i)
      else
        button:Show(false)
      end
    end
    w:Show(skillCount ~= 0)
    if skillCount == 0 then
      slaveInfoFrame:Show(false)
    end
    local colCount = math.min(skillCount, ROW_MAX_MODE_ACTION)
    local rowCount = math.floor(skillCount / ROW_MAX_MODE_ACTION) + (skillCount % ROW_MAX_MODE_ACTION > 0 and 1 or 0)
    local width = colCount * ICON_SIZE.DEFAULT + BACKGROUND_HORIZON_INSET * 2
    local height = rowCount * ICON_SIZE.DEFAULT + BACKGROUND_VERTICAL_INSET * 2
    self:SetExtent(width, height)
    local buttonIndex = 1
    for j = 1, rowCount do
      for i = 1, colCount do
        local button = w.buttons[buttonIndex]
        local btnPosX = (i - 1) * (ICON_SIZE.DEFAULT - 1) + BACKGROUND_HORIZON_INSET
        local btnPosY = (j - 1) * (ICON_SIZE.DEFAULT - 1) + BACKGROUND_VERTICAL_INSET
        button:AddAnchor("TOPLEFT", self, btnPosX, btnPosY)
        button:Show(true)
        buttonIndex = buttonIndex + 1
        if skillCount < buttonIndex then
          j = rowCount + 1
          break
        end
      end
    end
  end
  w:EnableDrag(true)
  function w:OnDragStart()
    if self.isvisibleBg then
      w:StartMoving()
      X2Cursor:ClearCursor()
      X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    end
  end
  w:SetHandler("OnDragStart", w.OnDragStart)
  function w:OnDragStop()
    if self.isvisibleBg then
      w:StopMovingOrSizing()
      X2Cursor:ClearCursor()
    end
  end
  w:SetHandler("OnDragStop", w.OnDragStop)
  function w:OnEnter()
    if not self.isvisibleBg then
      self:OnEnterEffectSetting()
    end
  end
  w:SetHandler("OnEnter", w.OnEnter)
  function w:OnLeave()
    if self.isvisibleBg then
      self:OnLeaveEffectSetting()
    end
  end
  w:SetHandler("OnLeave", w.OnLeave)
  return w
end
modeSkillActionBar = CreateModeSkillActionBar("modeSkillActionBar", "UIParent")
AddUISaveHandlerByKey("modeSkillActionBar", modeSkillActionBar)
modeSkillActionBar:ApplyLastWindowOffset()
ADDON:RegisterContentWidget(UIC_MODE_ACTIONBAR, modeSkillActionBar)
local modeSkillActionBarEvents = {
  MODE_ACTIONS_UPDATE = function()
    modeSkillActionBar:ShowModeSkillActionBar()
  end,
  ENTERED_WORLD = function()
    modeSkillActionBar:ShowModeSkillActionBar()
  end,
  LEFT_LOADING = function()
    modeSkillActionBar:ShowModeSkillActionBar()
  end,
  SHOW_SLAVE_INFO = function()
    slaveInfoFrame:UpdateSlaveDefaultInfo()
    slaveInfoFrame:Show(not slaveInfoFrame:IsVisible())
  end,
  SIEGEWEAPON_UNBOUND = function()
    if slaveInfoFrame:IsVisible() then
      slaveInfoFrame:Show(false)
    end
  end,
  UPDATE_BINDINGS = function()
    for i = 1, #modeSkillActionBar.buttons do
      modeSkillActionBar:UpdateBindings(i)
    end
  end,
  BUFF_UPDATE = function(action, target)
    if target == "slave" then
      X2Unit:RefreshModeActionBar()
    end
  end,
  DEBUFF_UPDATE = function(action, target)
    if target == "slave" then
      X2Unit:RefreshModeActionBar()
    end
  end
}
modeSkillActionBar:SetHandler("OnEvent", function(this, event, ...)
  modeSkillActionBarEvents[event](...)
end)
RegistUIEvent(modeSkillActionBar, modeSkillActionBarEvents)
