local ignoreKeys = {
  "SHIFT-B",
  "ALT-LEFT",
  "ALT-RIGHT",
  "ALT-UP",
  "ALT-DOWN",
  "SHIFT-OVER",
  "SHIFT-LCLICK",
  "F9",
  "CTRL-F12",
  "CTRL-INSERT",
  "CTRL-DELETE",
  "CTRL-HOME",
  "CTRL-END",
  "CTRL-PAGEUP",
  "CTRL-PAGEDOWN",
  "SHIFT-UP",
  "SHIFT-DOWN"
}
if optionLocale.useSlashOpenChat then
  ignoreKeys[#ignoreKeys + 1] = "/"
end
if X2Chat:UseMegaphone() == true then
  ignoreKeys[#ignoreKeys + 1] = "CTRL-ENTER"
end
local function IsIgnoreKey(keyStr)
  for i = 1, #ignoreKeys do
    if ignoreKeys[i] == string.upper(keyStr) then
      return true
    end
  end
  return false
end
local PRIMARY_HOTKEY_MANAGER = 1
local SECOND_HOTKEY_MANAGER = 2
local SELECT_COLOR = GetOptionListKeyButtonFontColor()
local SetAdjustButtonText = function(button, text)
  local width, _ = button:GetExtent()
  local textWidth = button.style:GetTextWidth(text)
  local length = string.len(text)
  local temp = text
  while textWidth > width - 15 do
    length = length - 1
    temp = string.sub(text, 1, length) .. "..."
    textWidth = button.style:GetTextWidth(temp)
  end
  button:SetText(temp)
end
local MakeBindingKey = function(arg)
  local keyName = ""
  if X2Input:IsShiftKeyDown() then
    keyName = keyName .. "SHIFT-"
  end
  if X2Input:IsControlKeyDown() then
    keyName = keyName .. "CTRL-"
  end
  if X2Input:IsAltKeyDown() then
    keyName = keyName .. "ALT-"
  end
  return keyName .. arg
end
local function AddActionModifyEventHandlers(frame, widget)
  local function ClickDelegator(delegator, callbacker, mbt)
    if mbt == "LeftButton" then
      if frame.lastClickedWidget == callbacker then
        frame:ConfirmHotkeyModifyMode()
        return
      end
      frame:SetLastClickedWidgetHighlighted(false)
      frame:SetLastClickedWidget(callbacker)
      frame:RequestInput(callbacker)
      SetBGHighlighted(callbacker, true, SELECT_COLOR)
    else
      frame:PostEvent(mbt)
    end
  end
  widget:SetDelegator("OnClick", frame, ClickDelegator)
  function widget:OnInput(arg)
    if frame.lastClickedWidget == self then
      local keyName = MakeBindingKey(arg)
      if not IsIgnoreKey(keyName) then
        X2Hotkey:SetOptionBindingWithIndex(self.action, keyName, self.keyType, self.arg)
      else
        AddMessageToSysMsgWindow(locale.systemHotKeyErrorMessage)
      end
      frame:Init()
    end
  end
  widget:EnableFocus(true)
end
local function AddButtonModifyEventHandlers(frame, widget)
  local function ClickDelegator(delegator, callbacker, mbt)
    if mbt == "LeftButton" then
      if frame.lastClickedWidget == callbacker then
        frame:ConfirmHotkeyModifyMode()
        return
      end
      frame:SetLastClickedWidgetHighlighted(false)
      frame:SetLastClickedWidget(callbacker)
      frame:RequestInput(callbacker)
      SetBGHighlighted(callbacker, true, SELECT_COLOR)
    else
      frame:PostEvent(mbt)
    end
  end
  widget:SetDelegator("OnClick", frame, ClickDelegator)
  function widget:OnInput(arg)
    if frame.lastClickedWidget == self then
      local keyName = MakeBindingKey(arg)
      if not IsIgnoreKey(keyName) then
        X2Hotkey:SetOptionBindingButtonWithIndex(self.action, keyName, self.keyType)
      else
        AddMessageToSysMsgWindow(locale.systemHotKeyErrorMessage)
      end
      frame:Init()
    end
  end
  widget:EnableFocus(true)
end
local function SetActionBindInfo(frame, index, action, arg)
  local enable = X2Hotkey:IsValidActionName(action)
  local editPrimary = frame.content.optionFrames[index].primaryKeyEdit
  if editPrimary ~= nil then
    local bindingText = X2Hotkey:GetOptionBinding(action, PRIMARY_HOTKEY_MANAGER, true, arg)
    if enable == false then
      bindingText = action
    end
    if bindingText ~= nil then
      bindingText = F_TEXT.ConvertAbbreviatedBindingText(bindingText)
      SetAdjustButtonText(editPrimary, string.upper(bindingText))
    end
    editPrimary:Enable(enable)
    editPrimary.keyType = PRIMARY_HOTKEY_MANAGER
    editPrimary.action = action
    editPrimary.arg = arg or 0
    AddActionModifyEventHandlers(frame, editPrimary)
  end
  local editSecondarty = frame.content.optionFrames[index].secondaryKeyEdit
  if editSecondarty ~= nil then
    local bindingText = X2Hotkey:GetOptionBinding(action, SECOND_HOTKEY_MANAGER, true, arg) or ""
    if bindingText ~= nil then
      bindingText = F_TEXT.ConvertAbbreviatedBindingText(bindingText)
      SetAdjustButtonText(editSecondarty, string.upper(bindingText))
    end
    editSecondarty:Enable(enable)
    editSecondarty.keyType = SECOND_HOTKEY_MANAGER
    editSecondarty.action = action
    editSecondarty.arg = arg or 0
    AddActionModifyEventHandlers(frame, editSecondarty)
  end
  local overridable = X2Hotkey:IsOverridableAction(action)
  if overridable then
    SELECT_COLOR = GetOptionListOverrideKeyButtonFontColor()
    ChangeButtonSkin(editPrimary, BUTTON_CONTENTS.OPTION_KEY_OVERRIDABLE)
    ChangeButtonSkin(editSecondarty, BUTTON_CONTENTS.OPTION_KEY_OVERRIDABLE)
  end
end
local function SetShortCutFuntionsForKeybindingWnd(frame, info, kind)
  function frame:ShowOverrideBindingTooltip(actionName)
    if self.lastClickedWidget ~= nil then
      local msg = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "hotkey_override_tooltip")
      ShowHotKeyOverrideTooltip(msg, self.lastClickedWidget, true, true)
    end
  end
  function frame:SetLastClickedWidget(widget)
    local oldWidget = self.lastClickedWidget
    self.lastClickedWidget = widget
    if self.lastClickedWidget ~= nil then
      self.releaseHotkeyBtn:Enable(true)
      function self:OnKeyUp(arg)
        self:PostEvent(arg)
      end
      self:SetHandler("OnKeyUp", self.OnKeyUp)
      function self:WheelUpProc()
        self:PostEvent("wheelup")
      end
      self:ReleaseHandler("OnWheelUp")
      self:SetHandler("OnWheelUp", self.WheelUpProc)
      function self:WheelDownProc()
        self:PostEvent("wheeldown")
      end
      self:ReleaseHandler("OnWheelDown")
      self:SetHandler("OnWheelDown", self.WheelDownProc)
      function self:OnClick(mbt)
        self:PostEvent(mbt)
      end
      self:SetHandler("OnClick", self.OnClick)
    else
      self.releaseHotkeyBtn:Enable(false)
      self:ReleaseHandler("OnKeyUp")
      self:ReleaseHandler("OnWheelUp")
      self:SetHandler("OnWheelUp", self.OnWheelUp)
      self:ReleaseHandler("OnWheelDown")
      self:SetHandler("OnWheelDown", self.OnWheelDown)
      self:ReleaseHandler("OnClick")
    end
  end
  function frame:SetLastClickedWidgetHighlighted(enable)
    if self.lastClickedWidget ~= nil then
      SetBGHighlighted(self.lastClickedWidget, enable, SELECT_COLOR)
      if enable == false then
        frame:SetLastClickedWidget(nil)
      end
    end
  end
  function frame:OnHide()
    if HideHotKeyOverrideTooltip ~= nil then
      HideHotKeyOverrideTooltip()
    end
    frame:SetLastClickedWidgetHighlighted(false)
    self:ConfirmHotkeyModifyMode()
  end
  frame:SetHandler("OnHide", frame.OnHide)
  local bindingsEvents = {
    UPDATE_OPTION_BINDINGS = function(overrided, oldAction, newAction)
      frame:Init()
      frame:SetLastClickedWidgetHighlighted(false)
      if overrided and frame:IsVisible() then
        frame:ShowOverrideBindingTooltip(newAction)
      end
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    bindingsEvents[event](...)
  end)
  frame:RegisterEvent("UPDATE_OPTION_BINDINGS")
  function frame:EnterHotkeyModifyMode()
    X2Hotkey:EnableHotkey(false)
    self:EnableKeyboard(true)
  end
  function frame:ConfirmHotkeyModifyMode()
    self:EnableKeyboard(false)
    X2Hotkey:EnableHotkey(true)
    self:SetLastClickedWidgetHighlighted(false)
  end
  function frame:RequestInput(eventListenWidget)
    self:EnterHotkeyModifyMode()
    self.listener = eventListenWidget
  end
  function frame:PostEvent(arg)
    if arg == "LeftButton" then
      self:ConfirmHotkeyModifyMode()
      return
    end
    if self.listener ~= nil and self.listener.OnInput ~= nil then
      self.listener:OnInput(string.upper(arg))
      self.listener = nil
    end
    self:ConfirmHotkeyModifyMode()
  end
  function frame:Init()
    local IsIgnoreControl = function(controlType)
      if controlType == OPTION_PARTITION_LINE or controlType == "subNormalTitle" then
        return true
      end
      return false
    end
    self:SetLastClickedWidgetHighlighted(false)
    local actionNames = {}
    local equalCount = {}
    local existEqualNames = {}
    for i = 1, #self.content.optionFrames do
      local insertable = info[i].insertable
      if insertable == nil then
        insertable = true
      end
      if not IsIgnoreControl(self.content.optionFrames[i].controlType) and insertable and info[i].actionName ~= nil then
        local action = info[i].actionName
        if existEqualNames[action] == nil then
          existEqualNames[action] = false
        else
          existEqualNames[action] = true
        end
      end
    end
    local function CheckActionNames(actionName)
      local exist = false
      local count = 0
      for k, v in pairs(actionNames) do
        if k == actionName then
          exist = true
          count = v
        end
      end
      if exist then
        actionNames[actionName] = count + 1
      else
        actionNames[actionName] = 0
      end
      return actionNames[actionName]
    end
    for i = 1, #self.content.optionFrames do
      local insertable = info[i].insertable
      if insertable == nil then
        insertable = true
      end
      if not IsIgnoreControl(self.content.optionFrames[i].controlType) and insertable and info[i].actionName ~= nil then
        local action = info[i].actionName
        local arg = CheckActionNames(action)
        if existEqualNames[action] then
          arg = arg + 1
        end
        if kind == "action" or existEqualNames[info[i].actionName] then
          SetActionBindInfo(self, i, action, arg)
        else
          local editPrimary = self.content.optionFrames[i].primaryKeyEdit
          if editPrimary ~= nil then
            local bindingText = X2Hotkey:GetOptionBindingButton(action, PRIMARY_HOTKEY_MANAGER) or ""
            if bindingText ~= nil then
              bindingText = F_TEXT.ConvertAbbreviatedBindingText(bindingText)
              SetAdjustButtonText(editPrimary, string.upper(bindingText))
            end
            editPrimary.keyType = PRIMARY_HOTKEY_MANAGER
            editPrimary.action = action
            AddButtonModifyEventHandlers(frame, editPrimary)
            local editSecond = self.content.optionFrames[i].secondaryKeyEdit
            local bindingText = X2Hotkey:GetOptionBindingButton(action, SECOND_HOTKEY_MANAGER) or ""
            if bindingText ~= nil then
              bindingText = F_TEXT.ConvertAbbreviatedBindingText(bindingText)
              SetAdjustButtonText(editSecond, string.upper(bindingText))
            end
            editSecond.keyType = SECOND_HOTKEY_MANAGER
            editSecond.action = action
            AddButtonModifyEventHandlers(frame, editSecond)
          end
        end
      end
    end
  end
end
function RemakeMenuListWithPartition(arrMenuList)
  local remakeMenuList = {}
  local count = 1
  for i = 1, #arrMenuList do
    for k = 1, #arrMenuList[i] do
      local listItem = arrMenuList[i][k]
      if listItem.insertable ~= false then
        remakeMenuList[count] = listItem
        count = count + 1
      end
    end
    if i < #arrMenuList then
      remakeMenuList[count] = OPTION_PARTITION_LINE
      count = count + 1
    end
  end
  return remakeMenuList
end
function CreatekeyBindgingFrame(parent, subFrameIndex)
  local SUB_FRAME_INDEX = {
    CHARACTER_CONTROL_MENU = 8,
    MOUNT_CONTROL_MENU = 9,
    GAME_CONTROL_MENU = 10,
    CAMERA_CONTROL_MENU = 11,
    INTERFACE_POPUP_MENU = 12,
    SHORTCUT_MENU = 13,
    ADDITIONAL_OPTION_MENU = 14
  }
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  local keyInfos
  if subFrameIndex == SUB_FRAME_INDEX.CHARACTER_CONTROL_MENU then
    keyInfos = optionTexts.keybinding_char_ctrl
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "action")
  elseif subFrameIndex == SUB_FRAME_INDEX.MOUNT_CONTROL_MENU then
    local arrOldMenuList = {
      optionTexts.keybinding_mount_ctrl_1,
      optionTexts.keybinding_mount_ctrl_2,
      optionTexts.keybinding_mount_ctrl_3
    }
    local arrNewMenuList = {
      optionTexts.keybinding_pet_ride_ctrl_1,
      optionTexts.keybinding_pet_ride_ctrl_2,
      optionTexts.keybinding_pet_ride_ctrl_3,
      optionTexts.keybinding_pet_battle_ctrl_1,
      optionTexts.keybinding_pet_battle_ctrl_2,
      optionTexts.keybinding_pet_battle_ctrl_3
    }
    if X2Player:GetFeatureSet().mateTypeSummon then
      keyInfos = RemakeMenuListWithPartition(arrNewMenuList)
    else
      keyInfos = RemakeMenuListWithPartition(arrOldMenuList)
    end
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "button")
  elseif subFrameIndex == SUB_FRAME_INDEX.GAME_CONTROL_MENU then
    local arrMenuList = {
      optionTexts.keybinding_game_ctrl_1,
      optionTexts.keybinding_game_ctrl_2,
      optionTexts.keybinding_game_ctrl_3,
      optionTexts.keybinding_game_ctrl_4
    }
    keyInfos = RemakeMenuListWithPartition(arrMenuList)
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "action")
  elseif subFrameIndex == SUB_FRAME_INDEX.CAMERA_CONTROL_MENU then
    keyInfos = optionTexts.keybinding_camera_ctrl
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "action")
  elseif subFrameIndex == SUB_FRAME_INDEX.INTERFACE_POPUP_MENU then
    local arrMenuList = {
      optionTexts.keybinding_interface_1,
      optionTexts.keybinding_interface_2,
      optionTexts.keybinding_interface_3,
      optionTexts.keybinding_interface_4,
      optionTexts.keybinding_interface_5,
      optionTexts.keybinding_interface_6
    }
    keyInfos = RemakeMenuListWithPartition(arrMenuList)
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "action")
  elseif subFrameIndex == SUB_FRAME_INDEX.SHORTCUT_MENU then
    local arrMenuList = {
      optionTexts.keybinding_shortcut_1,
      optionTexts.keybinding_shortcut_2,
      optionTexts.keybinding_shortcut_3,
      optionTexts.keybinding_shortcut_4,
      optionTexts.keybinding_shortcut_5,
      optionTexts.keybinding_shortcut_6,
      optionTexts.keybinding_shortcut_7
    }
    keyInfos = RemakeMenuListWithPartition(arrMenuList)
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "action")
  elseif subFrameIndex == SUB_FRAME_INDEX.ADDITIONAL_OPTION_MENU then
    local arrMenuList = {
      optionTexts.keybinding_additional_1,
      optionTexts.keybinding_additional_2,
      optionTexts.keybinding_additional_3,
      optionTexts.keybinding_additional_4,
      optionTexts.keybinding_additional_5
    }
    keyInfos = RemakeMenuListWithPartition(arrMenuList)
    SetShortCutFuntionsForKeybindingWnd(frame, keyInfos, "action")
  end
  if keyInfos ~= nil then
    for i = 1, #keyInfos do
      if keyInfos[i] == OPTION_PARTITION_LINE then
        frame:InsertNewOption(OPTION_PARTITION_LINE)
      elseif keyInfos[i].controlType == "subNormalTitle" then
        frame:InsertNewOption("subNormalTitle", keyInfos[i])
      elseif keyInfos[i].controlType == "subBigTitle" then
        frame:InsertNewOption("subBigTitle", keyInfos[i])
      else
        frame:InsertNewOption("keybindingcontrol", keyInfos[i], keyInfos[i].insertable)
      end
    end
  end
  local releaseHotkeyBtn = frame:CreateChildWidget("button", "releaseHotkeyBtn", 0, true)
  releaseHotkeyBtn:Enable(false)
  releaseHotkeyBtn:AddAnchor("RIGHT", parent.parent.okBtn, "LEFT", 0, 0)
  releaseHotkeyBtn:SetText(locale.menu.optionwindow.releaseKeyBinding)
  ApplyButtonSkin(releaseHotkeyBtn, BUTTON_BASIC.DEFAULT)
  SetButtonTooltip(releaseHotkeyBtn, locale.menu.optionwindow.key_release_button_tooltip)
  function releaseHotkeyBtn:OnClick(arg)
    if arg == "LeftButton" and frame.lastClickedWidget ~= nil then
      if frame.lastClickedWidget.arg ~= nil then
        X2Hotkey:RemoveOptionBinding(frame.lastClickedWidget.action, frame.lastClickedWidget.keyType, frame.lastClickedWidget.arg)
      else
        X2Hotkey:RemoveOptionBinding(frame.lastClickedWidget.action, frame.lastClickedWidget.keyType, 0)
      end
    end
    frame:Init()
  end
  releaseHotkeyBtn:SetHandler("OnClick", releaseHotkeyBtn.OnClick)
  return frame
end
