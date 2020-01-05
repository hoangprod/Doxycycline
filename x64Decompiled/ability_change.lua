function CreateAbilityChangeFrame(id, parent)
  local window = SetViewOfAbilityChangeFrame(id, parent)
  local MY_ABILITY_INDEX = 0
  local CHANGE_ABILITY_INDEX = 0
  local upperWindow = window.upperWindow
  local lowerWindow = window.lowerWindow
  local selectedIcon = lowerWindow.selectedIcon
  local changeButton = window.leftButton
  local function EnableChangeButton()
    changeButton:Enable(false)
    if MY_ABILITY_INDEX ~= 0 and CHANGE_ABILITY_INDEX ~= 0 then
      changeButton:Enable(true)
    end
  end
  local function ResetMyAbilityButton()
    for i = 1, #upperWindow.ability_button do
      local button = upperWindow.ability_button[i]
      SetBGPushed(button, false, GetMyAbilityButtonFontColor())
      localeView.abilityButton.ResetFunc(button)
    end
  end
  for i = 1, #upperWindow.ability_button do
    do
      local button = upperWindow.ability_button[i]
      function button:OnClick()
        ResetMyAbilityButton()
        SetBGPushed(button, true, GetMyAbilityButtonFontColor())
        localeView.abilityButton.SetPushedFunc(button)
        MY_ABILITY_INDEX = button.index
        EnableChangeButton()
      end
      button:SetHandler("OnClick", button.OnClick)
    end
  end
  local function ResetAllAbilityButton()
    for i = 1, COMBAT_ABILITY_MAX - 1 do
      do
        local button = lowerWindow.all_ability_button[i]
        SetBGHighlighted(button, false, GetAbilityButtonFontColor())
        local function OnEnter(self)
          SetTooltip(GetAbilityTooltip(i), self)
        end
        button:SetHandler("OnEnter", OnEnter)
        local OnLeave = function(self)
          HideTooltip()
        end
        button:SetHandler("OnLeave", OnLeave)
      end
    end
  end
  for j = 1, COMBAT_ABILITY_MAX - 1 do
    do
      local button = lowerWindow.all_ability_button[j]
      function button:OnClick()
        ResetAllAbilityButton()
        selectedIcon:SetVisible(true)
        selectedIcon:RemoveAllAnchors()
        selectedIcon:AddAnchor("RIGHT", button, "LEFT", 25, 0)
        SetBGHighlighted(button, true, GetAbilityButtonFontColor())
        CHANGE_ABILITY_INDEX = j
        EnableChangeButton()
      end
      button:SetHandler("OnClick", button.OnClick)
    end
  end
  local function GetAbilityButtonText(isMyInfo, abilityType)
    if window.allAbilityInfos == nil then
      return
    end
    if isMyInfo then
      for i = 1, #window.allAbilityInfos do
        local info = window.allAbilityInfos[i]
        if info.level < ABILITY_ACTIVATION_LEVEL_3 then
          info.level = ABILITY_ACTIVATION_LEVEL_3
        end
        if abilityType == info.type then
          return string.format("%s(%d)", locale.common.abilityNameWithId(abilityType), info.level)
        end
      end
    else
      local info = window.allAbilityInfos[abilityType]
      if info.level < ABILITY_ACTIVATION_LEVEL_3 then
        info.level = ABILITY_ACTIVATION_LEVEL_3
      end
      return string.format("%s(%d)", locale.common.abilityNameWithId(abilityType), info.level)
    end
  end
  function window:Reset()
    MY_ABILITY_INDEX = 0
    CHANGE_ABILITY_INDEX = 0
    local myAbilityInfo = X2Ability:GetActiveAbility()
    for j = 1, COMBAT_ABILITY_MAX - 1 do
      lowerWindow.all_ability_button[j]:Enable(true)
      lowerWindow.all_ability_button[j]:SetText(GetAbilityButtonText(false, j))
    end
    for i = 1, MAX.MY_ABILITY_COUNT do
      if myAbilityInfo[i] ~= nil then
        local button = upperWindow.ability_button[i]
        button:SetText(GetAbilityButtonText(true, myAbilityInfo[i].type))
        button.index = myAbilityInfo[i].type
        lowerWindow.all_ability_button[myAbilityInfo[i].type]:Enable(false)
      end
    end
    ResetMyAbilityButton()
    ResetAllAbilityButton()
    selectedIcon:SetVisible(false)
    changeButton:Enable(false)
    selectedIcon:RemoveAllAnchors()
  end
  function window:ShowProc()
    local myAbilityInfo = X2Ability:GetActiveAbility()
    if #myAbilityInfo < 3 then
      self:Show(false)
      AddMessageToSysMsgWindow("|cFFFF6600" .. locale.abilityChanger.reqActivationAbility)
      return
    end
    self.allAbilityInfos = X2Ability:GetAllCombatAbility()
    self:Reset()
  end
  function changeButton:OnClick()
    local changeCost = X2Ability:CanBuyAbilityChange()
    if changeCost ~= nil then
      do
        local abilityNames = locale.common.abilityNameWithId
        local function DialogHandler(wnd)
          wnd:SetTitle(GetUIText(ABILITY_CHANGER_TEXT, "title"))
          wnd:UpdateDialogModule("textbox", GetUIText(ABILITY_CHANGER_TEXT, "exchange_desc"))
          local changeData = {
            titleInfo = {
              title = GetUIText(ABILITY_CHANGER_TEXT, "title")
            },
            left = {
              UpdateValueFunc = function(leftValueWidget)
                leftValueWidget:SetText(abilityNames(MY_ABILITY_INDEX))
              end
            },
            right = {
              UpdateValueFunc = function(rightValueWidget)
                rightValueWidget:SetText(abilityNames(CHANGE_ABILITY_INDEX))
              end
            }
          }
          wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "abilityExchange", changeData)
          local data = {
            type = "cost",
            currency = F_MONEY.currency.abilityChange,
            value = changeCost
          }
          wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
          function wnd:OkProc()
            X2Ability:SwapAbility(MY_ABILITY_INDEX, CHANGE_ABILITY_INDEX)
          end
          function wnd:GetOkSound()
            return "event_message_box_ability_change_onok"
          end
        end
        X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
      end
    else
      local DialogNoticeHandler = function(wnd)
        wnd:SetTitle(locale.abilityChanger.title)
        wnd:UpdateDialogModule("textbox", GetUIText(ABILITY_CHANGER_TEXT, "need_more_str"))
      end
      X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, window:GetId())
    end
  end
  changeButton:SetHandler("OnClick", changeButton.OnClick)
  local function CancelButtonLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(window.rightButton, CancelButtonLeftClickFunc)
  return window
end
local abilityChangeFrame = CreateAbilityChangeFrame("abilityChangeFrame", "UIParent")
abilityChangeFrame:AddAnchor("CENTER", "UIParent", 0, 0)
ADDON:RegisterContentWidget(UIC_ABILITY_CHANGE, abilityChangeFrame)
local abilityChangeEvents = {
  ABILITY_CHANGED = function()
    abilityChangeFrame:Reset()
  end,
  TARGET_CHANGED = function()
    abilityChangeFrame:Show(false)
  end,
  ENTERED_WORLD = function()
    abilityChangeFrame:Reset()
  end
}
abilityChangeFrame:SetHandler("OnEvent", function(this, event, ...)
  abilityChangeEvents[event](...)
end)
RegistUIEvent(abilityChangeFrame, abilityChangeEvents)
