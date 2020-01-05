local interactionTargetId, targetType
function CreateDynamicActionBar(id, parent)
  local w = SetViewOfDynamicActionBar(id, parent)
  function w:GetBinding(index)
    if index > #w.button then
      return
    end
    return w.button[index]
  end
  return w
end
dynamic_action_bar = CreateDynamicActionBar("dynamicActionBar", "UIParent")
ADDON:RegisterContentWidget(UIC_DYNAMIC_ACTIONBAR, dynamic_action_bar)
for i = 1, MAX_DYNAMIC_ACTION_COUNT do
  do
    local button = dynamic_action_bar:GetBinding(i)
    function button:OnUpdate(dt)
      animRate = 1
      button:AddAnchor("TOPLEFT", dynamic_action_bar, "TOPLEFT", ((i - 1) * ACTION_BUTTON_WIDTH + i * ACTION_BUTTON_GAP) * animRate, 0)
    end
    button:SetHandler("OnUpdate", button.OnUpdate)
    local OnEnter = function(self)
      if self.name ~= nil and self.name ~= "" and self.desc ~= nil and self.desc ~= "" then
        SetExpTooltip(string.format([[
%s
%s]], self.name, self.desc), self, false)
      elseif self.desc ~= nil and self.desc ~= "" then
        SetExpTooltip(string.format("%s", self.desc), self, false)
      end
    end
    button:SetHandler("OnEnter", OnEnter)
    local OnLeave = function()
      HideTooltip()
    end
    button:SetHandler("OnLeave", OnLeave)
    function button:OnClick(arg)
      HideTooltip()
      if arg ~= "LeftButton" then
        return
      end
      X2:ExecuteDynamicAction(button.index)
    end
    button:SetHandler("OnClick", button.OnClick)
  end
end
function ClearDynamicActionBar()
  local buttons = dynamic_action_bar.button
  local bindingLabels = dynamic_action_bar.keyBindingLabel
  for i = 1, #buttons do
    local button = buttons[i]
    local bindingLabel = bindingLabels[i]
    button:Show(false)
    button.index = 0
    bindingLabel:Show(false)
  end
  interactionTargetId = nil
  dynamic_action_bar:Show(false)
end
local ResetButtonAnimations = function()
  for i = 1, MAX_DYNAMIC_ACTION_COUNT do
    local button = dynamic_action_bar:GetBinding(i)
    button.showingTime = 0
  end
end
local AlignWindow = function(buttonCount)
  local barWidth = buttonCount * ACTION_BUTTON_WIDTH + (buttonCount - 1) * ACTION_BUTTON_GAP
  dynamic_action_bar:SetExtent(barWidth, ACTION_BUTTON_HEIGHT)
  local posX = (UIParent:GetScreenWidth() - barWidth * UIParent:GetUIScale()) / 2
  local posY = UIParent:GetScreenHeight() / 4 * 2.75
  dynamic_action_bar:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(posX), F_LAYOUT.CalcDontApplyUIScale(posY))
end
local passSkill = {0, 10994}
local ShoulPassShow = function(id)
  if id == 0 or id == 10994 then
    return true
  end
  return false
end
local SetButtonTextures = function(isToggled, button, item, i)
  local iconPath = X2Interaction:GetInteractionSkillIconPath(item)
  local normalPath, highlightPath, pushedPath, disablePath
  if iconPath == nil then
    normalPath = INVALID_ICON_PATH
    highlightPath = INVALID_ICON_PATH
    pushedPath = INVALID_ICON_PATH
    disablePath = INVALID_ICON_PATH
    ChatLog(string.format("!!!!!intercation skill is invalid, not found iconPath!!! order: %d!!!!!", i))
    UIParent:LogAlways(string.format("!!!!!intercation skill is invalid, not found iconPath!!! order: %d!!!!!", i))
  else
    normalPath = iconPath
    highlightPath = string.sub(iconPath, 1, string.len(iconPath) - 4)
    highlightPath = string.format("%s%s", highlightPath, "_o.dds")
    pushedPath = string.sub(iconPath, 1, string.len(iconPath) - 4)
    pushedPath = string.format("%s%s", pushedPath, "_c.dds")
    disablePath = string.sub(iconPath, 1, string.len(iconPath) - 4)
    disablePath = string.format("%s%s", disablePath, "_d.dds")
  end
  if isToggled then
    local isValid = X2Interaction:IsValidIconPath(pushedPath)
    if isValid then
      button:SetBackgroundTexture(BUTTON_STATE.NORMAL, pushedPath)
      button:SetBackgroundTexture(BUTTON_STATE.PUSHED, pushedPath)
    else
      button:SetBackgroundTexture(BUTTON_STATE.NORMAL, normalPath)
      button:SetBackgroundTexture(BUTTON_STATE.PUSHED, normalPath)
    end
    isValid = X2Interaction:IsValidIconPath(highlightPath)
    if isValid == true then
      button:SetBackgroundTexture(BUTTON_STATE.HIGHLIGHTED, pushedPath)
    else
      button:SetBackgroundTexture(BUTTON_STATE.HIGHLIGHTED, normalPath)
    end
    isValid = X2Interaction:IsValidIconPath(disablePath)
    if isValid == true then
      button:SetBackgroundTexture(BUTTON_STATE.DISABLED, disablePath)
    else
      button:SetBackgroundTexture(BUTTON_STATE.DISABLED, normalPath)
    end
    return
  else
    button:SetBackgroundTexture(BUTTON_STATE.NORMAL, normalPath)
    local isValid = X2Interaction:IsValidIconPath(highlightPath)
    if isValid == true then
      button:SetBackgroundTexture(BUTTON_STATE.HIGHLIGHTED, highlightPath)
    else
      button:SetBackgroundTexture(BUTTON_STATE.HIGHLIGHTED, normalPath)
    end
    isValid = X2Interaction:IsValidIconPath(pushedPath)
    if isValid == true then
      button:SetBackgroundTexture(BUTTON_STATE.PUSHED, pushedPath)
    else
      button:SetBackgroundTexture(BUTTON_STATE.PUSHED, normalPath)
    end
    isValid = X2Interaction:IsValidIconPath(disablePath)
    if isValid == true then
      button:SetBackgroundTexture(BUTTON_STATE.DISABLED, disablePath)
    else
      button:SetBackgroundTexture(BUTTON_STATE.DISABLED, normalPath)
    end
  end
end
function ShowDynamicActionBar()
  local count = X2:GetDynamicActionCount()
  if count == 0 then
    interactionTargetId = nil
    dynamic_action_bar:Show(false)
  end
  AlignWindow(count)
  for i = 1, MAX_DYNAMIC_ACTION_COUNT do
    local button = dynamic_action_bar:GetBinding(i)
    local bindingLabel = dynamic_action_bar.keyBindingLabel[i]
    if i <= count then
      local item = X2:GetDynamicActionSkill(i)
      if item ~= nil and ShoulPassShow(item) == false then
        button:Show(true)
        bindingLabel:Show(true)
        SetButtonTextures(X2:IsDynamicActionSkillToggled(i), button, item, i)
        local tip = X2Skill:GetSkillTooltip(item, 0, SIK_DESCRIPTION)
        button.desc = tip.description
        button.index = i
      else
        button:Show(false)
        bindingLabel:Show(false)
        button.index = 0
      end
    else
      button:Show(false)
      bindingLabel:Show(false)
      button.index = 0
    end
  end
end
function InitTip()
  for i = 1, MAX_DYNAMIC_ACTION_COUNT do
    local btn = dynamic_action_bar:GetBinding(i)
    btn.name = nil
    btn.desc = nil
  end
end
function dynamic_action_bar:OnUpdate(dt)
  local count = X2:GetDynamicActionCount()
  AlignWindow(count)
end
dynamic_action_bar:SetHandler("OnUpdate", dynamic_action_bar.OnUpdate)
function dynamic_action_bar:UpdateBindingText()
  for i = 1, MAX_DYNAMIC_ACTION_COUNT do
    local bindingText = F_TEXT.ConvertAbbreviatedBindingText(X2Hotkey:GetBinding("do_interaction_" .. i, 1) or "")
    bindingText = string.upper(bindingText)
    self.keyBindingLabel[i]:SetText(bindingText)
  end
end
local dynamicActionBarEvents = {
  DYNAMIC_ACTION_BAR_SHOW = function(dynamicActionType, targetId)
    if X2Quest:IsQuestDirectingMode() == true then
      return
    end
    ResetButtonAnimations()
    InitTip()
    interactionTargetId = targetId
    targetType = dynamicActionType
    if dynamicActionType == "npc" then
      ShowDynamicActionBar()
    elseif dynamicActionType == "doodad" then
      ShowDynamicActionBar()
    end
    dynamic_action_bar:Show(true)
  end,
  DYNAMIC_ACTION_BAR_HIDE = function()
    ClearDynamicActionBar()
  end,
  DYNAMIC_ACTION_EXECUTE = function(dynamicActionType)
    X2:ExecuteDynamicAction(1)
  end,
  UPDATE_BINDINGS = function()
    dynamic_action_bar:UpdateBindingText()
  end
}
dynamic_action_bar:SetHandler("OnEvent", function(this, event, ...)
  dynamicActionBarEvents[event](...)
end)
dynamic_action_bar:RegisterEvent("DYNAMIC_ACTION_BAR_SHOW")
dynamic_action_bar:RegisterEvent("DYNAMIC_ACTION_BAR_HIDE")
dynamic_action_bar:RegisterEvent("DYNAMIC_ACTION_EXECUTE")
dynamic_action_bar:RegisterEvent("UPDATE_BINDINGS")
