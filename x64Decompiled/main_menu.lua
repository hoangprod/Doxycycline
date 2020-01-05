function CreateMainMenuBarRenewal(id, parent)
  local mainMenuFrame = UIParent:CreateWidget("emptywidget", id, parent)
  mainMenuFrame:SetHeight(32)
  local function HideAllSubMenu(clickMenu)
    for i = 1, #mainMenuFrame.button do
      if mainMenuFrame.button[i] ~= clickMenu and mainMenuFrame.button[i].subMenu ~= nil then
        mainMenuFrame.button[i].subMenu:Show(false)
      end
    end
  end
  local function CreateSubMenu(parent, menuInfoTable)
    local SetViewOfSubMenu = function(parent, menuInfoTable)
      local frame = parent:CreateChildWidget("window", "subMenuFrame", 0, true)
      frame:Show(false)
      frame:AddAnchor("BOTTOMRIGHT", parent, "TOPRIGHT", -3, 0)
      frame:SetSounds("submenu")
      local bg = frame:CreateDrawable(TEXTURE_PATH.HUD, "main_menu_bar_sub_menu_bg", "background")
      bg:AddAnchor("TOPLEFT", frame, 0, 0)
      bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
      frame.bg = bg
      return frame
    end
    local function SetUIAddonSubMenu(uiAddonMenu)
      local function CreateMenu(info)
        local menu = SetViewOfSubMenu(uiAddonMenu, info)
        menu.bg:SetCoords(624, 259, 34, 36)
        menu.bg:SetInset(16, 21, 17, 14)
        menu:SetHeight(#info * 20 + 30)
        local menuWidth = 0
        local function SetButtonWidth(button, text)
          local buttonWidth = button.style:GetTextWidth(text)
          menuWidth = math.max(menuWidth, buttonWidth)
        end
        local offsetY = 20
        for i = 1, #info do
          local button = menu:CreateChildWidget("button", "button", i, true)
          button:AddAnchor("TOP", menu, -3, offsetY)
          button:SetText(info[i])
          ApplyButtonSkin(button, BUTTON_HUD.MAIN_MENU_BAR_SUB_MENU)
          button.style:SetAlign(ALIGN_LEFT)
          offsetY = offsetY + button:GetHeight() + 5
          SetButtonWidth(button, info[i])
        end
        for i = 1, #menu.button do
          menu.button[i]:SetWidth(menuWidth + 10)
        end
        menu:SetWidth(menuWidth + 35)
        return menu
      end
      local firstMenuInfos = {}
      local addonInfos = ADDON:GetAddonInfos()
      for i = 1, #addonInfos do
        if addonInfos[i].enable then
          table.insert(firstMenuInfos, addonInfos[i].name)
        end
      end
      if uiAddonMenu.firstMenu == nil then
        uiAddonMenu.firstMenu = CreateMenu(firstMenuInfos)
        uiAddonMenu.firstMenu:AddAnchor("BOTTOMRIGHT", uiAddonMenu, "BOTTOMLEFT", -10, 0)
        for i = 1, #uiAddonMenu.firstMenu.button do
          local function LeftClickFunc(self)
            uiAddonMenu.secondMenu:RemoveAllAnchors()
            uiAddonMenu.secondMenu:AddAnchor("BOTTOMRIGHT", self, "BOTTOMLEFT", -10, 0)
            uiAddonMenu.secondMenu:Show(true)
            uiAddonMenu.secondMenu.target = self
          end
          ButtonOnClickHandler(uiAddonMenu.firstMenu.button[i], LeftClickFunc)
        end
      end
      uiAddonMenu.firstMenu:Show(true)
      local secondMenuInfos = {
        locale.common.reload,
        locale.common.option
      }
      if uiAddonMenu.secondMenu == nil then
        uiAddonMenu.secondMenu = CreateMenu(secondMenuInfos)
        for i = 1, #uiAddonMenu.secondMenu.button do
          do
            local function LeftClickFunc(self)
              local targetStr = uiAddonMenu.secondMenu.target:GetText()
              if i == 1 then
                ADDON:ReloadAddon(targetStr)
              else
                ADDON:FireAddon(targetStr)
              end
              uiAddonMenu:GetParent():Show(false)
            end
            ButtonOnClickHandler(uiAddonMenu.secondMenu.button[i], LeftClickFunc)
          end
        end
      end
      function uiAddonMenu:InitSubMenus()
        if uiAddonMenu.firstMenu ~= nil then
          uiAddonMenu.firstMenu:Show(false)
        end
        if uiAddonMenu.secondMenu ~= nil then
          uiAddonMenu.secondMenu:Show(false)
        end
      end
    end
    if menuInfoTable == nil or #menuInfoTable == 0 then
      return
    end
    local frame = SetViewOfSubMenu(parent, menuInfoTable)
    frame.button = {}
    local existMenuExpedition = false
    local target = frame
    for i = 1, #menuInfoTable do
      do
        local info = MAIN_MENU_INFO[menuInfoTable[i]]
        if info.show then
          do
            local button = frame:CreateChildWidget("button", "button", #frame.button + 1, true)
            button:Enable(info.enable)
            button:SetText(info.text)
            button:AddAnchor("TOP", target, 0, 20)
            button.menuIdx = menuInfoTable[i]
            target = button
            function button:ApplyPermission()
              if info.permission then
                button:Enable(info:permission())
              end
            end
            ApplyButtonSkin(button, BUTTON_HUD.MAIN_MENU_BAR_SUB_MENU)
            local function LeftClickFunc(self)
              if info.content ~= nil then
                ADDON:ToggleContent(info.content)
                HideAllSubMenu(self)
              elseif info.toggleFunc ~= nil then
                info.toggleFunc(self)
                HideAllSubMenu(self)
              elseif self:GetText() == X2Locale:LocalizeUiText(INFOBAR_MENU_TEXT, "uiaddon") then
                SetUIAddonSubMenu(self)
                if not frame:HasHandler("OnShow") then
                  local function OnShow()
                    self:InitSubMenus()
                  end
                  frame:SetHandler("OnShow", OnShow)
                end
              end
            end
            ButtonOnClickHandler(button, LeftClickFunc)
          end
        end
        if menuInfoTable[i] == MAIN_MENU_IDX.EXPEDITION then
          existMenuExpedition = true
        end
      end
    end
    function frame:UpdateButtonBindings()
      local width = 0
      local function SetButtonWidth(button, text)
        local buttonWidth = button.style:GetTextWidth(text)
        width = math.max(width, buttonWidth)
      end
      for i = 1, #self.button do
        local button = self.button[i]
        for j = 1, #menuInfoTable do
          local info = MAIN_MENU_INFO[menuInfoTable[j]]
          if button.menuIdx == menuInfoTable[j] and info.hotkey ~= nil then
            local key = string.upper(X2Hotkey:GetBinding(info.hotkey, 1) or "")
            local button_text
            if key ~= "" then
              button_text = string.format("%s (%s)", info.text, string.upper(X2Hotkey:GetBinding(info.hotkey, 1) or ""))
            else
              button_text = string.format("%s", info.text)
            end
            button:SetText(button_text)
          end
        end
        SetButtonWidth(button, button:GetText())
      end
      for i = 1, #self.button do
        self.button[i]:SetWidth(width + 11)
      end
      self:SetWidth(width + 25)
      self:SetHeight(#self.button * 20 + 30)
    end
    frame:UpdateButtonBindings()
    local events = {
      MOUSE_DOWN = function(widgetId)
        if widgetId == frame:GetParent():GetId() then
          return
        end
        if frame:IsVisible() and widgetId ~= frame:GetId() and frame:IsDescendantWidget(widgetId) == false then
          frame:Show(false)
        end
      end
    }
    if existMenuExpedition and not X2Player:GetFeatureSet().expeditionRecruit then
      function events.UPDATE_MAIN_MENU_EXPEDITION()
        for i = 1, #frame.button do
          local button = frame.button[i]
          if button.menuIdx == MAIN_MENU_IDX.EXPEDITION then
            button:Enable(X2Faction:GetMyExpeditionId() ~= 0)
          end
        end
      end
    end
    frame:SetHandler("OnEvent", function(this, event, ...)
      events[event](...)
    end)
    RegistUIEvent(frame, events)
    return frame
  end
  local SetSubmenuAnim = function(widget)
    if widget.subMenu:IsVisible() then
      local OnScaleAnimeEnd = function(self)
        self:Show(false)
      end
      widget.subMenu:SetHandler("OnScaleAnimeEnd", OnScaleAnimeEnd)
      widget.subMenu:SetScaleAnimation(1, 0.3, 0.1, 0.1, "BOTTOMRIGHT")
      widget.subMenu:SetAlphaAnimation(1, 0, 0.1, 0.1)
      widget.subMenu:SetStartAnimation(true, true)
    else
      widget.subMenu:ReleaseHandler("OnScaleAnimeEnd")
      widget.subMenu:SetScaleAnimation(0.3, 1, 0.1, 0.1, "BOTTOMRIGHT")
      widget.subMenu:SetAlphaAnimation(0.3, 1, 0.1, 0.1)
      widget.subMenu:SetStartAnimation(true, true)
      widget.subMenu:Show(not widget.subMenu:IsVisible())
    end
  end
  local offset = 0
  mainMenuFrame.button = {}
  for i = 1, #MENU_TABLE do
    do
      local subMenu = MENU_TABLE[i]
      local info
      if type(subMenu) == "table" then
        info = MAIN_MENU_INFO[subMenu[1]]
      else
        info = MAIN_MENU_INFO[subMenu]
      end
      if info.show then
        do
          local button = mainMenuFrame:CreateChildWidget("button", "button", #mainMenuFrame.button + 1, true)
          button.ignoreOnEnter = false
          button:Enable(info.enable)
          if info.createBgEffectDrawables ~= nil then
            info.createBgEffectDrawables(button)
          end
          ApplyButtonSkin(button, info.buttonStyle)
          button:AddAnchor("LEFT", mainMenuFrame, offset, 0)
          target = button
          if info.badgeCreatable then
            local badge = button:CreateChildWidget("label", "badge", 0, true)
            badge:SetHeight(FONT_SIZE.MIDDLE)
            badge:SetAutoResize(true)
            badge.style:SetFont("actionBar", FONT_SIZE.MIDDLE)
            badge:AddAnchor("BOTTOMRIGHT", button, -2, -2)
            badge.style:SetAlign(ALIGN_CENTER)
            local point = info.badgePoint
            if type(info.badgePoint) == "function" then
              point = info.badgePoint()
            end
            local visible = info.badgeVisible
            if type(info.badgeVisible) == "function" then
              visible = info.badgeVisible()
            end
            badge:Show(visible)
            badge:SetText(tostring(point))
            local total, used = X2Ability:GetSkillPoint()
            local count = total - used
            if info.badgeColor ~= nil then
              local bg = badge:CreateDrawable(TEXTURE_PATH.HUD, "badge", "background")
              bg:SetTextureColor(info.badgeColor)
              bg:AddAnchor("TOPLEFT", badge, -3, 0)
              bg:AddAnchor("BOTTOMRIGHT", badge, 3, 0)
            end
            if info.effectDrawableCoords ~= nil then
              local effectDrawable = button:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
              effectDrawable:SetVisible(false)
              effectDrawable:SetCoords(info.effectDrawableCoords[1], info.effectDrawableCoords[2], info.effectDrawableCoords[3], info.effectDrawableCoords[4])
              effectDrawable:SetExtent(info.effectDrawableCoords[3], info.effectDrawableCoords[4])
              effectDrawable:AddAnchor("CENTER", button, 0, 0)
              effectDrawable:SetRepeatCount(5)
              effectDrawable:SetEffectPriority(1, "alpha", 0.6, 0.5)
              effectDrawable:SetEffectInitialColor(1, 1, 1, 1, 1)
              effectDrawable:SetEffectFinalColor(1, 1, 1, 1, 0)
              effectDrawable:SetEffectPriority(2, "alpha", 0.6, 0.5)
              effectDrawable:SetEffectInitialColor(2, 1, 1, 1, 0)
              effectDrawable:SetEffectFinalColor(2, 1, 1, 1, 1)
              button.effectDrawable = effectDrawable
            end
          end
          if info.updateFunc ~= nil and info.updateEvents ~= nil then
            button:SetHandler("OnEvent", function(this, event, ...)
              info.updateFunc(this, event, ...)
            end)
            for i = 1, #info.updateEvents do
              button:RegisterEvent(info.updateEvents[i])
            end
          end
          function button:ApplyPermission()
            if info.permission then
              button:Enable(info:permission())
            end
          end
          if type(subMenu) == "table" then
            local subMeuInfo = {}
            for j = 2, #subMenu do
              table.insert(subMeuInfo, subMenu[j])
            end
            local menu = CreateSubMenu(button, subMeuInfo)
            button.subMenu = menu
          end
          local function LeftClickFunc(self)
            if self.subMenu ~= nil then
              SetSubmenuAnim(self)
            elseif info.content ~= nil then
              ADDON:ToggleContent(info.content)
            elseif info.toggleFunc ~= nil then
              info.toggleFunc(self)
            end
            HideAllSubMenu(self)
          end
          ButtonOnClickHandler(button, LeftClickFunc)
          local function OnEnter(self)
            if self.ignoreOnEnter == true then
              return
            end
            local bindingText = X2Hotkey:GetBinding(info.hotkey, 1) or ""
            bindingText = string.upper(bindingText)
            local tip = info.text
            if bindingText ~= "" then
              tip = string.format("%s %s(%s)", tip, FONT_COLOR_HEX.DEFAULT, bindingText)
            else
              tip = string.format("%s %s", tip, FONT_COLOR_HEX.DEFAULT)
            end
            SetTargetAnchorTooltip(tip, "BOTTOMRIGHT", self, "TOPLEFT", 0, 0)
          end
          button:SetHandler("OnEnter", OnEnter)
          local OnLeave = function()
            HideTooltip()
          end
          button:SetHandler("OnLeave", OnLeave)
          offset = offset + 32
        end
      end
    end
  end
  mainMenuFrame:SetWidth(#mainMenuFrame.button * 32)
  local events = {
    UPDATE_BINDINGS = function()
      for i = 1, #mainMenuFrame.button do
        if mainMenuFrame.button[i].subMenu ~= nil then
          mainMenuFrame.button[i].subMenu:UpdateButtonBindings()
        end
      end
    end,
    ENTERED_LOADING = function()
      ADDON:ShowContent(UIC_CHARACTER_INFO, false)
      ADDON:ShowContent(UIC_SKILL, false)
      ADDON:ShowContent(UIC_QUEST_LIST, false)
      ADDON:ShowContent(UIC_BAG, false)
      ToggleRecipeBook(false)
      ADDON:ShowContent(UIC_WORLDMAP, false)
      ToggleCommonFarm(false)
      ToggleExpedMgmtUI(false)
      ToggleRaidManager(false)
      ToggleRelationshipUI(false)
      ToggleSystemConfigFrame(false)
      ADDON:ShowContent(UIC_MARKET_PRICE, false)
    end
  }
  mainMenuFrame:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(mainMenuFrame, events)
  local function UpdatePermission()
    for i = 1, #mainMenuFrame.button do
      local mainBtn = mainMenuFrame.button[i]
      mainBtn:ApplyPermission()
      if mainBtn.subMenuFrame ~= nil then
        for j = 1, #mainBtn.subMenuFrame.button do
          mainBtn.subMenuFrame.button[j]:ApplyPermission()
        end
      end
    end
  end
  UIParent:SetEventHandler("UI_PERMISSION_UPDATE", UpdatePermission)
  return mainMenuFrame
end
