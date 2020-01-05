local BACKGROUND_HORIZON_INSET = 10
local BACKGROUND_VERTICAL_INSET = 10
local ACTION_BUTTON_WIDTH = 48
local ACTION_BUTTON_GAP = -1
local OFFSET_FROM_DYNAMIC_ACTION_BAR = 5
local ROW_MAX_MODE_ACTION = 6
local MAX_SHORTCUT_SKILL = 12
local function CreateShortcutSkillActionBar(id, parent)
  local w = CreateEmptyWindow(id, parent)
  w:Show(false)
  local barMaxWidth = ROW_MAX_MODE_ACTION * ICON_SIZE.DEFAULT + BACKGROUND_HORIZON_INSET
  local posX = UIParent:GetScreenWidth() / 2 - barMaxWidth / 2
  local posY = UIParent:GetScreenHeight() - (ICON_SIZE.DEFAULT * 2 + 25)
  function w:MakeOriginWindowPos(reset)
    if w == nil then
      return
    end
    w:RemoveAllAnchors()
    w:SetExtent(100, 56)
    if w.ShowShortcutSkillActionBar ~= nil then
      w:ShowShortcutSkillActionBar()
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
  for i = 1, MAX_SHORTCUT_SKILL do
    local button = CreateActionSlot(w, "shortcut_action_slot", ISLOT_SHORTCUT_ACTION, i)
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
        ShowTooltip(info, self)
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
  function w:ShowShortcutSkillActionBar()
    local skillCount = X2Unit:GetShortcutSkillCount()
    for i = 1, #w.buttons do
      local button = w.buttons[i]
      if i <= skillCount then
        button:Show(true)
        button:EstablishSlot(ISLOT_SHORTCUT_ACTION, i)
        self:UpdateBindings(i)
      else
        button:Show(false)
      end
    end
    w:Show(skillCount ~= 0)
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
shortcutSkillActionBar = CreateShortcutSkillActionBar("shortcutSkillActionBar", "UIParent")
AddUISaveHandlerByKey("shortcutSkillActionBar", shortcutSkillActionBar)
shortcutSkillActionBar:ApplyLastWindowOffset()
ADDON:RegisterContentWidget(UIC_SHORTCUT_ACTIONBAR, shortcutSkillActionBar)
local shortcutSkillActionBarEvents = {
  UPDATE_SHORTCUT_SKILLS = function()
    shortcutSkillActionBar:ShowShortcutSkillActionBar()
  end,
  ENTERED_WORLD = function()
    shortcutSkillActionBar:ShowShortcutSkillActionBar()
  end,
  LEFT_LOADING = function()
    shortcutSkillActionBar:ShowShortcutSkillActionBar()
  end,
  UPDATE_BINDINGS = function()
    shortcutSkillActionBar:ShowShortcutSkillActionBar()
  end
}
shortcutSkillActionBar:SetHandler("OnEvent", function(this, event, ...)
  shortcutSkillActionBarEvents[event](...)
end)
RegistUIEvent(shortcutSkillActionBar, shortcutSkillActionBarEvents)
