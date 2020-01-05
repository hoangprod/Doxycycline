function SetArchePassEventFunction(parent)
  function parent:UpdateMyPass()
    local archePassInfo = X2ArchePass:GetMyArchePassInfo()
    if archePassInfo == nil then
      parent.myPassNameLabel:SetText("")
      parent.myPassPeriodLabel:SetText("")
      parent.myPassEmptyLabel:Show(true)
      parent.myPassRemoveButton:Enable(false)
      parent.changePremiumButton:Enable(false)
      parent.myPassPointBar:SetMinMaxValues(0, 0)
      parent.myPassPointBar:SetValue(0)
      parent.myPassPointBar.shadowDeco:SetVisible(false)
      parent.myTierLabel:SetText("")
      parent.myPassItemIcon:Show(false)
      parent.myPassRemoveButton:Show(false)
    else
      parent.myPassNameLabel:SetText(archePassInfo.name)
      parent.myPassPeriodLabel:SetText(string.format("%s %02d:%02d", baselibLocale:GetDefaultDateString(archePassInfo.edYear, archePassInfo.edMonty, archePassInfo.edDay), archePassInfo.edHour, archePassInfo.edMin))
      parent.myPassEmptyLabel:Show(false)
      parent.myTierLabel:SetText(tostring(archePassInfo.tier))
      parent.myPassRemoveButton:Enable(true)
      parent.myPassRemoveButton:Show(false)
      do
        local minPoint = tonumber(archePassInfo.minPoint)
        local maxPoint = tonumber(archePassInfo.maxPoint)
        local point = tonumber(archePassInfo.point)
        if maxPoint <= 0 then
          minPoint = 0
          maxPoint = 0
          point = 0
        end
        parent.myPassPointBar:SetMinMaxValues(minPoint, maxPoint)
        parent.myPassPointBar:SetValue(point)
        local visible = minPoint < point and maxPoint > point
        parent.myPassPointBar.shadowDeco:SetVisible(visible)
        function parent.myPassPointBar:OnEnter()
          if archePassInfo ~= nil then
            if maxPoint > 0 then
              local tooltip = CommaStr(point - minPoint) .. " / " .. CommaStr(maxPoint - minPoint)
              local max = maxPoint - minPoint
              local val = point - minPoint
              local percent = string.format(" (%.2f%%)", math.min(val / max * 100, 100))
              SetTooltip(tooltip .. percent, self)
            end
          else
            HideTooltip()
          end
        end
        parent.myPassPointBar:SetHandler("OnEnter", parent.myPassPointBar.OnEnter)
        if archePassInfo.iconPath ~= nil then
          parent.myPassItemIcon:Show(true)
          local path = archePassInfo.iconPath
          path = string.gsub(path, "Game\\", "")
          parent.myPassItemIcon:SetTexture(path)
        end
        parent.changePremiumButton:Enable(not archePassInfo.premium)
      end
    end
  end
  function parent:UpdateMyRewards()
    local archePassRewards = X2ArchePass:GetMyArchePassRewards()
    if archePassRewards == nil then
      parent.myPassRewardListWnd:Show(false)
      parent.myPassRewardWnd:Show(false)
      parent.myPassEmptyRewardBg:Show(true)
      parent.myPassEmptyRewardLabel:Show(true)
    else
      parent.myPassEmptyRewardBg:Show(false)
      parent.myPassEmptyRewardLabel:Show(false)
      parent.myPassRewardWnd:Show(true)
      parent.myPassRewardListWnd:Show(true)
      parent.myPassRewardListWnd:DeleteAllDatas()
      local infoNum = #archePassRewards
      local columnCount = #parent.myPassRewardListWnd.listCtrl.column
      for i = 1, infoNum - 1 do
        local info = archePassRewards[i]
        for j = 1, columnCount do
          parent.myPassRewardListWnd:InsertData(i, j, info)
        end
      end
      local data = archePassRewards[#archePassRewards]
      if data ~= nil then
        parent.lastRewardButton:SetItemInfo(data.rewardItemInfo)
        parent.lastRewardButton:SetStack(data.rewardItemCount)
        parent.lastPremiumRewardButton:SetItemInfo(data.premiumRewardItemInfo)
        parent.lastPremiumRewardButton:SetStack(data.premiumRewardItemCount)
        parent.lastRewardButton.tier = data.tier
        parent.lastPremiumRewardButton.tier = data.tier
        if data.tier <= data.lastRewardTier then
          parent.lastRewardButton:SetAlpha(0.6)
        else
          parent.lastRewardButton:SetAlpha(1)
          parent.lastRewardButton:Enable(data.tier == data.nextRewardTier)
        end
        if data.tier <= data.lastPrimiumRewardTier then
          parent.lastPremiumRewardButton:SetAlpha(0.6)
        else
          parent.lastPremiumRewardButton:SetAlpha(1)
          parent.lastPremiumRewardButton:Enable(data.premium and data.tier == data.nextPremiumRewardTier)
        end
        parent.lastRewardButton:Enable(data.tier == data.nextRewardTier)
        parent.lastPremiumRewardButton:Enable(data.tier == data.nextPremiumRewardTier)
      end
      if data.nextRewardTier > 0 then
        parent.myPassRewardListWnd:ScrollToDataIndex(data.nextRewardTier, 3)
      elseif data.nextPremiumRewardTier > 0 then
        parent.myPassRewardListWnd:ScrollToDataIndex(data.nextPremiumRewardTier, 3)
      else
        parent.myPassRewardListWnd:ScrollToDataIndex(data.myTier, 3)
      end
    end
  end
  function parent:UpdateMyMission()
    local curCompleteCnt, maxCompleteCnt = X2ArchePass:GetMissionCompleteCount()
    local curChangeCnt, maxChangeCnt = X2ArchePass:GetMissionChangeCount()
    self.labelCompletCount:SetText(GetCommonText("arche_pass_daily_complete_count", curCompleteCnt, maxCompleteCnt))
    self.labelChangeCount:SetText(GetCommonText("today_assignment_reset_count", curChangeCnt, maxChangeCnt))
    self.changeObjectButton:Enable(curChangeCnt < maxChangeCnt)
    self.missionListWnd:Update()
    self.missionDescWnd:Update()
  end
  function parent:Update()
    self:UpdateMyPass()
    self:UpdateMyRewards()
    self:UpdateMyMission()
  end
  local function RewardButtonOnClick()
    X2ArchePass:GetMyArchePassReward(parent.lastRewardButton.tier, false)
  end
  ButtonOnClickHandler(parent.lastRewardButton, RewardButtonOnClick)
  local function PremiumRewardButtonOnClick()
    X2ArchePass:GetMyArchePassReward(parent.lastPremiumRewardButton.tier, true)
  end
  ButtonOnClickHandler(parent.lastPremiumRewardButton, PremiumRewardButtonOnClick)
  local function RemoveButtonOnClick()
    local archePassInfo = X2ArchePass:GetMyArchePassInfo()
    local function DialogHandler(wnd)
      wnd:SetTitle(GetCommonText("arche_pass_remove"))
      if archePassInfo ~= nil and archePassInfo.name ~= nil then
        local content = GetCommonText("arche_pass_remove_confirm", archePassInfo.name)
        wnd:UpdateDialogModule("textbox", content)
      end
      local data = {
        titleInfo = {
          title = GetCommonText("arche_pass_upgrade_premium_warn_title")
        },
        text = GetCommonText("arche_pass_remove_warn_desc")
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.SCROLL_TITLE_BOX, "titleBox", data)
      function wnd:OkProc()
        X2ArchePass:RemovePass()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
  end
  ButtonOnClickHandler(parent.myPassRemoveButton, RemoveButtonOnClick)
  local function ChangePremiumButtonOnClick()
    local archePassInfo = X2ArchePass:GetMyArchePassInfo()
    if archePassInfo ~= nil then
      do
        local upgradeItemType = archePassInfo.upgradeItemType
        local hasUpgradeItemCount = archePassInfo.hasUpgradeItemCount
        if X2ArchePass:IsPremiumItemTag(upgradeItemType) and hasUpgradeItemCount < 1 then
          ToggleInGameShop(true, eventcenterLocale.archePassIngameShop.mainTabIdx, eventcenterLocale.archePassIngameShop.subTabIdx)
        else
          local function DialogHandler(wnd)
            wnd:SetTitle(GetCommonText("arche_pass_upgrade_premium_title"))
            if archePassInfo.name ~= nil then
              local content = GetCommonText("arche_pass_upgrade_premium_confirm")
              wnd:UpdateDialogModule("textbox", content)
            end
            local data = {
              titleInfo = {
                title = GetCommonText("arche_pass_upgrade_premium_warn_title")
              },
              left = {
                UpdateValueFunc = function(leftValueWidget)
                  leftValueWidget:SetText(GetCommonText("arche_pass_upgrade_premium_before"))
                end
              },
              right = {
                UpdateValueFunc = function(rightValueWidget)
                  rightValueWidget:SetText(GetCommonText("arche_pass_upgrade_premium_after"))
                  ApplyTextColor(rightValueWidget, FONT_COLOR.BLUE)
                end
              }
            }
            wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeBox", data)
            local itemData = {
              itemInfo = X2Item:GetItemInfoByType(upgradeItemType),
              stack = {hasUpgradeItemCount, 1}
            }
            wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
            function wnd:OkProc()
              X2ArchePass:UpgradePremium()
            end
          end
          X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
        end
      end
    end
  end
  ButtonOnClickHandler(parent.changePremiumButton, ChangePremiumButtonOnClick)
  local Events = {
    ARCHE_PASS_UPDATE_POINT = function(point)
      parent:UpdateMyPass()
      X2Chat:DispatchChatMessage(CMF_SYSTEM, GetUIText(CHAT_SYSTEM_TEXT, "arche_pass_point_added", tostring(point)))
    end,
    ARCHE_PASS_DROPPED = function()
      parent:Update()
    end,
    ARCHE_PASS_UPDATE_TIER = function(tier)
      parent:UpdateMyRewards()
      X2Chat:DispatchChatMessage(CMF_SYSTEM, GetUIText(CHAT_SYSTEM_TEXT, "arche_pass_tier_added", tostring(tier)))
      AddMessageToSysMsgWindow(GetUIText(CHAT_SYSTEM_TEXT, "arche_pass_tier_added", tostring(tier)))
    end,
    ARCHE_PASS_UPDATE_REWARD_ITEM = function(complete)
      parent:UpdateMyRewards()
      if complete == true then
        local DialogHandler = function(wnd)
          wnd:SetTitle(GetCommonText("arche_pass_got_normal_rewards_title"))
          local content = GetCommonText("arche_pass_got_normal_rewards_desc")
          wnd:UpdateDialogModule("textbox", content)
          local data = {
            titleInfo = {
              title = GetCommonText("squad_explanation")
            },
            text = GetCommonText("arche_pass_got_normal_rewards_desc2")
          }
          wnd:CreateDialogModule(DIALOG_MODULE_TYPE.SCROLL_TITLE_BOX, "titleBox", data)
        end
        X2DialogManager:RequestNoticeDialog(DialogHandler, parent:GetId())
      end
    end,
    ARCHE_PASS_STARTED = function()
      parent:Update()
    end,
    ARCHE_PASS_OWNED = function()
      parent:Update()
    end,
    ARCHE_PASS_BUY = function()
      parent:Update()
    end,
    ARCHE_PASS_UPGRADE_PREMIUM = function()
      parent:Update()
    end,
    ARCHE_PASS_EXPIRED = function()
      parent:Update()
    end,
    ARCHE_PASS_COMPLETED = function()
      parent:Update()
      local DialogHandler = function(wnd)
        wnd:SetTitle(GetCommonText("arche_pass_completed_title"))
        local content = GetCommonText("arche_pass_completed_desc")
        wnd:UpdateDialogModule("textbox", content)
      end
      X2DialogManager:RequestNoticeDialog(DialogHandler, parent:GetId())
    end,
    ARCHE_PASS_MISSION_COMPLETED = function()
      parent:UpdateMyMission()
    end,
    ARCHE_PASS_MISSION_CHANGED = function()
      parent:UpdateMyMission()
    end,
    ARCHE_PASS_RESETED = function()
      parent:Update()
    end,
    UPDATE_TODAY_ASSIGNMENT = function()
      parent:Update()
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      parent:Update()
    end,
    QUEST_CONTEXT_UPDATED = function(qType, status)
      if X2Achievement:IsTodayAssignmentQuest(TADT_ARCHE_PASS, qType) == true and status == "updated" then
        parent:Update()
      end
    end,
    ADDED_ITEM = function()
      parent:Update()
    end,
    REMOVED_ITEM = function()
      parent:Update()
    end
  }
  parent:SetHandler("OnEvent", function(this, event, ...)
    Events[event](...)
  end)
  RegistUIEvent(parent, Events)
end
