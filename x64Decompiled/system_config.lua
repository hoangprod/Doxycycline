local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateGameExitFrame()
  local frame = CreateWindow("gameExitFrame", "UIParent")
  frame:SetExtent(POPUP_WINDOW_WIDTH, 180)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:SetUILayer("dialog")
  frame:Show(false)
  frame:SetWindowModal(true)
  frame.titleBar.closeButton:Show(false)
  local centerMsg = frame:CreateChildWidget("textbox", "centerMsg", 0, true)
  centerMsg:Show(true)
  centerMsg:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 15)
  centerMsg:AddAnchor("TOP", frame, 0, titleMargin + sideMargin / 2)
  ApplyTextColor(centerMsg, FONT_COLOR.DEFAULT)
  local cancelButton = frame:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:SetText(locale.keyBinding.gameExit.cancel)
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOM", frame, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local okButton = frame:CreateChildWidget("button", "okButton", 0, true)
  okButton:Show(false)
  okButton:SetText(locale.keyBinding.gameExit.ok)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", frame, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  frame.exitTarget = 0
  frame.time_type = nil
  function frame:InitCommon(waitTime)
    self.showTime = 0
    self.maxTime = waitTime + 1000
    self:SetHandler("OnUpdate", frame.OnUpdate)
    self:Show(true)
    self.cancelButton:Enable(true)
  end
  function frame:Get_message_type()
    if X2Player:HasSlaveUnit() then
      self.time_type = "state_summon"
      self.time_write_type = true
    elseif X2Player:PlayerInCombat() then
      self.time_type = "state_combat"
      self.time_write_type = false
    else
      self.time_type = "state_normal"
      self.time_write_type = false
    end
  end
  local strSec = X2Locale:LocalizeUiText(TOOLTIP_TEXT, "second")
  function frame:Get_select_character_message(waitTime)
    if self.time_type == "state_normal" then
      local time = string.format("%d %s", waitTime / 1000, strSec)
      return string.format("%s", locale.keyBinding.gameExit.paramSelectCharacterMsg(time))
    elseif self.time_type == "state_combat" then
      local time = string.format("%d %s", waitTime / 1000, strSec)
      return string.format([[
%s
%s]], locale.keyBinding.add_time_of_combatState, locale.keyBinding.gameExit.paramSelectCharacterMsg(time))
    elseif self.time_type == "state_summon" then
      local time = 0
      if self.time_write_type then
        time = string.format("%d %s", waitTime / 1000, locale.tooltip.minute)
      else
        time = string.format("%d %s", waitTime / 1000, strSec)
      end
      return string.format([[
%s
%s]], locale.keyBinding.add_time_of_summon, locale.keyBinding.gameExit.paramSelectCharacterMsg(time))
    end
  end
  function frame:Get_exit_message(waitTime)
    if self.time_type == "state_normal" then
      if self.exitTarget ~= EXIT_CLIENT_NONE_ACTION then
        local time = string.format("%d %s", waitTime / 1000, strSec)
        return string.format("%s", locale.keyBinding.gameExit.paramExitMsg(time))
      else
        return string.format("%s", locale.keyBinding.gameExit.paramNoneActionExitMsg())
      end
    elseif self.time_type == "state_combat" then
      local time = string.format("%d %s", waitTime / 1000, strSec)
      return string.format([[
%s
%s]], locale.keyBinding.add_time_of_combatState, locale.keyBinding.gameExit.paramExitMsg(time))
    elseif self.time_type == "state_summon" then
      local time = 0
      if self.time_write_type then
        time = string.format("%d %s", waitTime / 1000, locale.tooltip.minute)
      else
        time = string.format("%d %s", waitTime / 1000, strSec)
      end
      return string.format([[
%s
%s]], locale.keyBinding.add_time_of_summon, locale.keyBinding.gameExit.paramExitMsg(time))
    end
  end
  function frame:Get_select_server_message(waitTime)
    if self.time_type == "state_normal" then
      local time = string.format("%d %s", waitTime / 1000, strSec)
      return string.format("%s", locale.keyBinding.gameExit.paramSelectWorldMsg(time))
    elseif self.time_type == "state_combat" then
      local time = string.format("%d %s", waitTime / 1000, strSec)
      return string.format([[
%s
%s]], locale.keyBinding.add_time_of_combatState, locale.keyBinding.gameExit.paramSelectWorldMsg(time))
    elseif self.time_write_type == "state_summon" then
      local time = 0
      if self.time_write_type then
        time = string.format("%d %s", waitTime / 1000, locale.tooltip.minute)
      else
        time = string.format("%d %s", waitTime / 1000, strSec)
      end
      return string.format([[
%s
%s]], locale.keyBinding.add_time_of_summon, locale.keyBinding.gameExit.paramSelectWorldMsg(time))
    end
  end
  function frame:ResizeHeight()
    self:SetHeight(150 + self.centerMsg:GetHeight())
  end
  function frame:InitExitGame(waitTime)
    self.exitTarget = EXIT_CLIENT
    self:SetTitle(locale.keyBinding.config.gameExit)
    self:Get_message_type()
    self.centerMsg:SetText(self:Get_exit_message(waitTime))
    self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    self:ResizeHeight()
    self:InitCommon(waitTime)
  end
  function frame:InitNoneActionExitGame()
    self.exitTarget = EXIT_CLIENT_NONE_ACTION
    self:SetTitle(locale.keyBinding.config.gameExit)
    self:Get_message_type()
    self.centerMsg:SetText(self:Get_exit_message(0))
    self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    self:ResizeHeight()
    self.showTime = 0
    self.maxTime = 0
    self:Show(true)
    self.okButton:Show(true)
  end
  function frame:InitSelectCharacter(waitTime, idleKick)
    self.exitTarget = EXIT_TO_CHARACTER_LIST
    title = nil
    self:Get_message_type()
    centerMsg = nil
    if idleKick == true then
      title = locale.menu.selectWorld
      centerMsg = self:Get_select_server_message(waitTime)
    else
      title = locale.menu.selectCharacter
      centerMsg = self:Get_select_character_message(waitTime)
    end
    self:SetTitle(title)
    self.centerMsg:SetText(centerMsg)
    self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    self:ResizeHeight()
    self:InitCommon(waitTime)
  end
  function frame:InitSelectWorld(waitTime)
    self.exitTarget = EXIT_TO_WORLD_LIST
    self:SetTitle(locale.menu.selectWorld)
    self:Get_message_type()
    self.centerMsg:SetText(self:Get_select_server_message(waitTime))
    self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    self:ResizeHeight()
    self:InitCommon(waitTime)
  end
  function frame:OnUpdate(dt)
    self.showTime = self.showTime + dt
    local curTime = self.showTime / 1000
    curTime = self.maxTime - self.showTime
    self.time_write_type = false
    if self.time_type == "state_summon" and curTime > 60000 then
      curTime = curTime / 60
      self.time_write_type = true
    end
    if curTime < 0 then
      curTime = 0
    end
    if self.exitTarget == EXIT_CLIENT then
      self.centerMsg:SetText(self:Get_exit_message(curTime))
      self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    elseif self.exitTarget == EXIT_TO_CHARACTER_LIST then
      self.centerMsg:SetText(self:Get_select_character_message(curTime))
      self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    elseif self.exitTarget == EXIT_TO_WORLD_LIST then
      self.centerMsg:SetText(self:Get_select_server_message(curTime))
      self.centerMsg:SetHeight(self.centerMsg:GetTextHeight())
    end
    if curTime == 0 then
      self.cancelButton:Enable(false)
      self:ReleaseHandler("OnUpdate")
      self.centerMsg:SetText(locale.keyBinding.gameExit.processing)
    end
  end
  function frame.cancelButton:OnClick(arg)
    if arg == "LeftButton" then
      self:Enable(false)
      X2World:CancelLeaveWorld()
    end
  end
  frame.cancelButton:SetHandler("OnClick", frame.cancelButton.OnClick)
  function frame.okButton:OnClick(arg)
    if arg == "LeftButton" then
      self:Enable(false)
      X2World:LeaveGame()
    end
  end
  frame.okButton:SetHandler("OnClick", frame.okButton.OnClick)
  function frame:OnCloseByEsc()
    X2World:CancelLeaveWorld()
  end
  frame:SetHandler("OnCloseByEsc", frame.OnCloseByEsc)
  return frame
end
function CreateSystemConfigFrame()
  local GetButtonWidth = function(button, text)
    if button.style:GetTextWidth(text) > BUTTON_SIZE.ICON.WIDTH then
      return button.style:GetTextWidth(text)
    end
    return BUTTON_SIZE.ICON.WIDTH
  end
  local frame = CreateWindow("systemConfigFrame", "UIParent")
  frame:Show(false)
  frame:SetExtent(POPUP_WINDOW_WIDTH, 175)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:SetTitle(locale.keyBinding.config.menu)
  frame:SetSounds("config")
  local offsetY = titleMargin + sideMargin / 2.6
  local buttons = {}
  local exitClientDrivenButton = frame:CreateChildWidget("button", "exitClientDrivenButton", 0, true)
  exitClientDrivenButton:SetText(GetCommonText("menu_option_exit_client_driven"))
  ApplyButtonSkin(exitClientDrivenButton, BUTTON_ICON.ESC_SKIP)
  function exitClientDrivenButton:OnEnter()
    local text
    if self:IsEnabled() then
      text = GetCommonText("tooltip_menu_option_exit_client_driven")
    else
      text = GetCommonText("tooltip_menu_option_disable_exit_client_driven")
    end
    SetTargetAnchorTooltip(text, "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
  end
  exitClientDrivenButton:SetHandler("OnEnter", exitClientDrivenButton.OnEnter)
  function exitClientDrivenButton:OnLeave()
    HideTooltip()
  end
  exitClientDrivenButton:SetHandler("OnLeave", exitClientDrivenButton.OnLeave)
  function exitClientDrivenButton:OnClick(arg)
    if arg == "LeftButton" then
      frame:Show(false)
      X2:RequestEndClientDrivenIndun()
    end
  end
  exitClientDrivenButton:SetHandler("OnClick", exitClientDrivenButton.OnClick)
  frame.exitClientDrivenButton = exitClientDrivenButton
  table.insert(buttons, exitClientDrivenButton)
  local webWikiButton
  if optionLocale.useWebWiki == true then
    webWikiButton = frame:CreateChildWidget("button", "webWikiButton", 0, true)
    webWikiButton:SetText(X2Locale:LocalizeUiText(INFOBAR_MENU_TIP_TEXT, "archewiki"))
    ApplyButtonSkin(webWikiButton, BUTTON_ICON.ESC_WEB_WIKI)
    table.insert(buttons, webWikiButton)
    function webWikiButton:OnClick(arg)
      if arg == "LeftButton" then
        frame:Show(false)
        OnToggleWebWiki(true)
      end
    end
    webWikiButton:SetHandler("OnClick", webWikiButton.OnClick)
  end
  local optionButton = frame:CreateChildWidget("button", "optionButton", 0, true)
  optionButton:SetText(locale.menu.option)
  ApplyButtonSkin(optionButton, BUTTON_ICON.ESC_OPTION)
  function optionButton:OnClick(arg)
    if arg == "LeftButton" then
      frame:Show(false)
      ToggleOptionFrame(true)
    end
  end
  optionButton:SetHandler("OnClick", optionButton.OnClick)
  table.insert(buttons, optionButton)
  local selectCharacterButton = frame:CreateChildWidget("button", "selectCharacterButton", 0, true)
  selectCharacterButton:SetText(locale.menu.selectCharacter)
  ApplyButtonSkin(selectCharacterButton, BUTTON_ICON.ESC_CHARACTER_SELECT)
  function selectCharacterButton:OnClick(arg)
    if arg == "LeftButton" then
      X2World:LeaveWorld(EXIT_TO_CHARACTER_LIST)
    end
  end
  selectCharacterButton:SetHandler("OnClick", selectCharacterButton.OnClick)
  table.insert(buttons, selectCharacterButton)
  local exitGameButton = frame:CreateChildWidget("button", "exitGameButton", 0, true)
  exitGameButton:SetText(locale.keyBinding.config.gameExit)
  ApplyButtonSkin(exitGameButton, BUTTON_ICON.ESC_EXIT)
  frame.exitGameButton = exitGameButton
  function exitGameButton:OnClick(arg)
    if arg == "LeftButton" then
      X2World:LeaveWorld(EXIT_CLIENT)
    end
  end
  exitGameButton:SetHandler("OnClick", exitGameButton.OnClick)
  table.insert(buttons, exitGameButton)
  if optionLocale.useAutoResize then
    exitClientDrivenButton:SetAutoResize(true)
    if webWikiButton ~= nil then
      webWikiButton:SetAutoResize(true)
    end
    optionButton:SetAutoResize(true)
    selectCharacterButton:SetAutoResize(true)
    exitGameButton:SetAutoResize(true)
  else
    exitClientDrivenButton:SetWidth(GetButtonWidth(exitClientDrivenButton, locale.menu.option))
    exitClientDrivenButton:SetAutoResize(true)
    if webWikiButton ~= nil then
      webWikiButton:SetWidth(GetButtonWidth(webWikiButton, webWikiButton:GetText()))
    end
    optionButton:SetWidth(GetButtonWidth(optionButton, locale.menu.option))
    selectCharacterButton:SetWidth(GetButtonWidth(selectCharacterButton, locale.menu.selectCharacter))
    exitGameButton:SetWidth(GetButtonWidth(exitGameButton, locale.keyBinding.config.gameExit))
  end
  function frame:UpdateLayout()
    optionLocale:UpdateSystemConfigLayout(frame, buttons, offsetY)
  end
  return frame
end
systemConfigFrame = CreateSystemConfigFrame()
systemConfigFrame:SetCloseOnEscape(true)
ADDON:RegisterContentWidget(UIC_SYSTEM_CONFIG_FRAME, systemConfigFrame)
gameExitFrame = CreateGameExitFrame()
ADDON:RegisterContentWidget(UIC_GAME_EXIT_FRAME, gameExitFrame)
function ToggleSystemConfigFrame(show)
  if show == nil then
    show = not systemConfigFrame:IsVisible()
  end
  local isInClientDriven = X2:IsInClientDrivenZone()
  if isInClientDriven then
    systemConfigFrame.exitClientDrivenButton:Show(true)
    systemConfigFrame.exitClientDrivenButton:Enable(X2:IsEnableSkipClientDriven())
  else
    systemConfigFrame.exitClientDrivenButton:ReleaseHandler("OnEnter")
    systemConfigFrame.exitClientDrivenButton:ReleaseHandler("OnClick")
    systemConfigFrame.exitClientDrivenButton:Show(false)
  end
  systemConfigFrame.selectCharacterButton:Enable(UIParent:GetPermission(UIC_SELECT_CHARACTER))
  systemConfigFrame.exitGameButton:Enable(UIParent:GetPermission(UIC_EXIT_GAME))
  systemConfigFrame:UpdateLayout()
  systemConfigFrame:Show(show)
end
function SelectCharacter(waitTime, exitTarget, idleKick)
  systemConfigFrame:Show(false)
  if exitTarget == EXIT_CLIENT then
    gameExitFrame:InitExitGame(waitTime)
  elseif exitTarget == EXIT_CLIENT_NONE_ACTION then
    gameExitFrame:InitNoneActionExitGame()
  elseif exitTarget == EXIT_TO_CHARACTER_LIST then
    gameExitFrame:InitSelectCharacter(waitTime, idleKick)
  elseif exitTarget == EXIT_TO_WORLD_LIST then
    gameExitFrame:InitSelectWorld(waitTime)
  end
end
local systemConfigFrameEvents = {
  OPEN_CONFIG = function()
    ToggleSystemConfigFrame(true)
  end,
  LEAVING_WORLD_STARTED = SelectCharacter,
  LEAVING_WORLD_CANCELED = function()
    gameExitFrame:Show(false)
  end
}
systemConfigFrame:SetHandler("OnEvent", function(this, event, ...)
  systemConfigFrameEvents[event](...)
end)
systemConfigFrame:RegisterEvent("OPEN_CONFIG")
systemConfigFrame:RegisterEvent("LEAVING_WORLD_STARTED")
systemConfigFrame:RegisterEvent("LEAVING_WORLD_CANCELED")
