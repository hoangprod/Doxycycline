function SetArchePassListEventFunction(parent)
  local selectedPassType
  local GetArchePassCategoryInfos = function()
    local infos = X2ArchePass:GetCategories()
    local categoryInfos = {}
    for depth1, info in ipairs(infos) do
      local categoryInfo = {}
      categoryInfo.text = info.name
      categoryInfo.value = info.categoryType
      if info.subCategories ~= nil then
        categoryInfo.child = {}
        for depth2, subInfo in ipairs(info.subCategories) do
          categoryInfo.child[depth2] = {}
          categoryInfo.child[depth2].text = subInfo.name
          categoryInfo.child[depth2].value = subInfo.subCategoryType
          categoryInfo.child[depth2].iconPath = "ui/eventcenter/archepass_icon.dds"
          local status = X2ArchePass:GetStatus(subInfo.subCategoryType)
          if status == APS_OWNED then
            categoryInfo.child[depth2].infoKey = "icon_yellow"
          elseif status == APS_PROGRESS then
            categoryInfo.child[depth2].infoKey = "icon_orange"
          elseif status == APS_COMPLETED then
            categoryInfo.child[depth2].infoKey = "icon_green"
          end
        end
        categoryInfo.opened = true
      end
      table.insert(categoryInfos, categoryInfo)
    end
    return categoryInfos
  end
  local CheckBuyPass = function(passType)
    if passType == nil then
      return false
    end
    local status = X2ArchePass:GetStatus(passType)
    local isFull = X2ArchePass:IsFull()
    return isFull == false and (status == APS_INVALID or status == APS_DROPPED)
  end
  local function CategoriesUpdate(updatePassType)
    if updatePassType ~= nil then
      local infos = parent.scrollListBox.content:GetViewItemsInfo()
      for i = 1, #infos do
        local value = infos[i].value
        local text = infos[i].text
        local childCount = infos[i].childCount
        local data = {
          indexing = infos[i].indexing,
          subtext = ""
        }
        if updatePassType == value and childCount == 0 then
          data.iconPath = "ui/eventcenter/archepass_icon.dds"
          local status = X2ArchePass:GetStatus(updatePassType)
          if status == APS_OWNED then
            data.infoKey = "icon_yellow"
            data.visibleIcon = true
          elseif status == APS_PROGRESS then
            data.infoKey = "icon_orange"
            data.visibleIcon = true
          elseif status == APS_COMPLETED then
            data.infoKey = "icon_green"
            data.visibleIcon = true
          else
            data.visibleIcon = false
          end
        end
        parent.scrollListBox.content:UpdateItem(data)
      end
    end
    if selectedPassType ~= nil then
      local status = X2ArchePass:GetStatus(selectedPassType)
      local isFull = X2ArchePass:IsFull()
      parent.startButton:Enable(status == APS_OWNED or CheckBuyPass(selectedPassType))
    else
      parent.startButton:Enable(false)
    end
  end
  function parent:InitPassInfo()
    parent.passNameLabel:SetText("")
    parent.passPeriodLabel:SetText("")
    parent.passCostLabel:SetText("")
    parent.passDescriptionLabel:SetText("")
    parent.startButton:Enable(false)
    parent.passItemIcon:Show(false)
    parent.lastRewardButton:Show(false)
    parent.lastPremiumRewardButton:Show(false)
    parent.premiumListEffectBg:Show(false)
    parent.passRewardListWnd:DeleteAllDatas()
  end
  function parent:UpdatePassInfo(passName, passType)
    local archePassInfo = X2ArchePass:GetArchePassInfo(passType)
    if archePassInfo == nil then
      parent:InitPassInfo()
    else
      parent.passNameLabel:SetText(archePassInfo.name)
      parent.passPeriodLabel:SetText(string.format("%s %02d:%02d", baselibLocale:GetDefaultDateString(archePassInfo.edYear, archePassInfo.edMonty, archePassInfo.edDay), archePassInfo.edHour, archePassInfo.edMin))
      parent.passCostLabel:SetText(F_MONEY:GetCostStringByCurrency(archePassInfo.currencyType, archePassInfo.currencyValue))
      parent.passDescriptionLabel:SetText(archePassInfo.description)
      local function OnEnter(self)
        if self.style:GetTextWidth(archePassInfo.description) < self:GetWidth() then
          return
        end
        SetTooltip(archePassInfo.description, self)
      end
      parent.passDescriptionLabel:SetHandler("OnEnter", OnEnter)
      local status = X2ArchePass:GetStatus(passType)
      parent.startButton:Enable(status == APS_OWNED or CheckBuyPass(passType))
      if archePassInfo.iconPath ~= nil then
        parent.passItemIcon:Show(true)
        local path = archePassInfo.iconPath
        path = string.gsub(path, "Game\\", "")
        parent.passItemIcon:SetTexture(path)
      end
    end
  end
  function parent:UpdateRewards(passName, passType)
    local archePassRewards = X2ArchePass:GetArchePassRewards(passType)
    if archePassRewards == nil then
    else
      parent.lastRewardButton:Show(true)
      parent.lastPremiumRewardButton:Show(true)
      parent.premiumListEffectBg:Show(true)
      parent.passRewardListWnd:DeleteAllDatas()
      local infoNum = #archePassRewards
      local columnCount = #parent.passRewardListWnd.listCtrl.column
      for i = 1, infoNum - 1 do
        local info = archePassRewards[i]
        for j = 1, columnCount do
          parent.passRewardListWnd:InsertData(i, j, info)
        end
      end
      if archePassRewards[#archePassRewards] ~= nil then
        parent.lastRewardButton:SetItemInfo(archePassRewards[#archePassRewards].rewardItemInfo)
        parent.lastRewardButton:SetStack(archePassRewards[#archePassRewards].rewardItemCount)
        parent.lastPremiumRewardButton:SetItemInfo(archePassRewards[#archePassRewards].premiumRewardItemInfo)
        parent.lastPremiumRewardButton:SetStack(archePassRewards[#archePassRewards].premiumRewardItemCount)
      end
    end
  end
  function parent:UpdateArchePassList()
    parent.scrollListBox:SetItemTrees(GetArchePassCategoryInfos())
    parent:InitPassInfo()
    selectedPassType = nil
  end
  function parent:Update()
  end
  function parent:ShowProc()
    self:UpdateArchePassList()
  end
  function parent.scrollListBox:OnSelChanged()
    local text = self.content:GetSelectedText()
    local value = self.content:GetSelectedValue()
    selectedPassType = value
    parent:UpdatePassInfo(text, value)
    parent:UpdateRewards(text, value)
  end
  local function StartButtonOnClick()
    local archePassInfo = X2ArchePass:GetArchePassInfo(selectedPassType)
    if X2ArchePass:GetStatus(selectedPassType) == APS_OWNED then
      local function DialogHandler(wnd)
        wnd:SetTitle(GetCommonText("arche_pass_start"))
        if archePassInfo ~= nil and archePassInfo.name ~= nil then
          local content = GetCommonText("arche_pass_start_confirm", archePassInfo.name)
          wnd:UpdateDialogModule("textbox", content)
        end
        function wnd:OkProc()
          if selectedPassType ~= nil then
            X2ArchePass:StartPass(selectedPassType)
          end
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
    elseif CheckBuyPass(selectedPassType) then
      local function DialogHandler(wnd)
        wnd:SetTitle(GetCommonText("arche_pass_registry"))
        if archePassInfo ~= nil then
          if archePassInfo.name ~= nil then
            local content = GetCommonText("arche_pass_registry_confirm", archePassInfo.name)
            wnd:UpdateDialogModule("textbox", content)
          end
          if archePassInfo.currencyValue ~= nil then
            local costData = {
              type = "cost",
              value = archePassInfo.currencyValue,
              currency = archePassInfo.currencyType
            }
            wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
          end
          local textData = {
            type = "warning",
            text = GetCommonText("arche_pass_registry_warning")
          }
          wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
        end
        function wnd:OkProc()
          if selectedPassType ~= nil then
            X2ArchePass:BuyPass(selectedPassType)
          end
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
    end
  end
  ButtonOnClickHandler(parent.startButton, StartButtonOnClick)
  local Events = {
    ARCHE_PASS_STARTED = function(passType)
      CategoriesUpdate(passType)
    end,
    ARCHE_PASS_BUY = function(passType)
      CategoriesUpdate(passType)
    end,
    ARCHE_PASS_OWNED = function(passType)
      CategoriesUpdate(passType)
    end,
    ARCHE_PASS_EXPIRED = function(passType)
      CategoriesUpdate(passType)
    end,
    ARCHE_PASS_DROPPED = function(passType)
      CategoriesUpdate(passType)
    end,
    ARCHE_PASS_COMPLETED = function(passType)
      CategoriesUpdate(passType)
    end,
    ARCHE_PASS_RESETED = function(passType)
      CategoriesUpdate(passType)
    end
  }
  parent:SetHandler("OnEvent", function(this, event, ...)
    Events[event](...)
  end)
  RegistUIEvent(parent, Events)
end
