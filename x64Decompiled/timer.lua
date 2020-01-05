local TIMER_BUTTON_SIZE = 61
local function CreateAnimationTexture(button)
  local aniTexture = button:CreateImageDrawable(TEXTURE_PATH.TIMER, "background")
  aniTexture:SetExtent(TIMER_BUTTON_SIZE, TIMER_BUTTON_SIZE)
  aniTexture:AddAnchor("TOPLEFT", button, 0, 0)
  button.aniTexture = aniTexture
  local labelIcon = button:CreateImageDrawable(TEXTURE_PATH.TIMER, "overlay")
  labelIcon:AddAnchor("BOTTOMRIGHT", aniTexture, -5, -5)
  labelIcon:SetVisible(false)
  button.labelIcon = labelIcon
  local boxAnim = {}
  for j = 1, 8 do
    boxAnim[j] = {}
  end
  local animTime = 100
  boxAnim[1].x = 0
  boxAnim[1].y = 0
  boxAnim[1].w = TIMER_BUTTON_SIZE
  boxAnim[1].h = TIMER_BUTTON_SIZE
  boxAnim[1].time = animTime
  boxAnim[1].scale = 1
  boxAnim[2].x = 61
  boxAnim[2].y = 0
  boxAnim[2].w = TIMER_BUTTON_SIZE
  boxAnim[2].h = TIMER_BUTTON_SIZE
  boxAnim[2].time = animTime
  boxAnim[2].scale = 1
  boxAnim[3].x = 122
  boxAnim[3].y = 0
  boxAnim[3].w = TIMER_BUTTON_SIZE
  boxAnim[3].h = TIMER_BUTTON_SIZE
  boxAnim[3].time = animTime
  boxAnim[3].scale = 1
  boxAnim[4].x = 183
  boxAnim[4].y = 0
  boxAnim[4].w = TIMER_BUTTON_SIZE
  boxAnim[4].h = TIMER_BUTTON_SIZE
  boxAnim[4].time = animTime
  boxAnim[4].scale = 1
  boxAnim[5].x = 0
  boxAnim[5].y = 61
  boxAnim[5].w = TIMER_BUTTON_SIZE
  boxAnim[5].h = TIMER_BUTTON_SIZE
  boxAnim[5].time = animTime
  boxAnim[5].scale = 1
  boxAnim[6].x = 61
  boxAnim[6].y = 61
  boxAnim[6].w = TIMER_BUTTON_SIZE
  boxAnim[6].h = TIMER_BUTTON_SIZE
  boxAnim[6].time = animTime
  boxAnim[6].scale = 1
  boxAnim[7].x = 122
  boxAnim[7].y = 61
  boxAnim[7].w = TIMER_BUTTON_SIZE
  boxAnim[7].h = TIMER_BUTTON_SIZE
  boxAnim[7].time = animTime
  boxAnim[7].scale = 1
  boxAnim[8].x = 0
  boxAnim[8].y = 0
  boxAnim[8].w = TIMER_BUTTON_SIZE
  boxAnim[8].h = TIMER_BUTTON_SIZE
  boxAnim[8].time = 500
  boxAnim[8].scale = 1
  aniTexture:SetAnimFrameInfo(boxAnim)
end
local function CreateScheduleItemTimer(id, index, parent)
  local widget = parent:CreateChildWidget("emptywidget", id, index, true)
  widget:SetExtent(TIMER_BUTTON_SIZE, 80)
  local button = widget:CreateChildWidget("button", "button", 0, true)
  button:AddAnchor("TOP", widget, 0, 0)
  ApplyButtonSkin(button, BUTTON_HUD.TIMER)
  local bg = widget:CreateImageDrawable(TEXTURE_PATH.TIMER, "background")
  bg:AddAnchor("TOPLEFT", button, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", button, 0, 0)
  widget.bg = bg
  local timeLabel = widget:CreateChildWidget("label", "timeLabel", 0, true)
  timeLabel:SetAutoResize(true)
  timeLabel:SetHeight(FONT_SIZE.MIDDLE)
  timeLabel:AddAnchor("TOP", button, "BOTTOM", -2, 0)
  timeLabel.style:SetShadow(true)
  local timeBg = timeLabel:CreateImageDrawable(TEXTURE_PATH.TIMER, "background")
  timeBg:SetCoords(183, 122, 56, 17)
  timeBg:SetExtent(56, 17)
  timeBg:AddAnchor("CENTER", timeLabel, 0, 0)
  CreateAnimationTexture(button)
  local GetKindTip = function(info)
    local str = ""
    local itemName = string.format("%s%s|r", F_COLOR.GetColor("original_dark_orange", true), X2Item:Name(info.itemType))
    local remain = math.max(info.giveTerm - info.time, 0)
    local remainingTime = string.format("%s%s|r", F_COLOR.GetColor("original_dark_orange", true), GetUIText(SERVER_TEXT, "paramTimeAboutMinutes", tostring(remain)))
    if info.giveTerm == 0 then
      if info.give == info.giveMax then
        str = locale.mileage.none_give_term_give_max(itemName, string.format("|,%d;", info.giveMax), FONT_COLOR_HEX.RED, locale.mileage.gived_max_warning)
      else
        str = locale.mileage.none_give_term(itemName, string.format("|,%d;", info.giveMax))
      end
    else
      local termTime = string.format("%s%s|r", F_COLOR.GetColor("original_dark_orange", true), GetUIText(SERVER_TEXT, "paramTimeAboutMinutes", tostring(info.giveTerm)))
      if info.give >= info.giveMax then
        str = locale.mileage.gived_max(itemName, termTime, FONT_COLOR_HEX.RED, locale.mileage.gived_max_warning)
      else
        str = X2Locale:LocalizeUiText(COMMON_TEXT, "scheduleitem_none_give_max", itemName, termTime, tostring(info.giveMax - info.give))
      end
    end
    return str
  end
  function widget:FillData(scheduleType)
    local info = X2Player:GetScheduleItemInfo(scheduleType)
    if info == nil then
      self:Clear()
      return
    end
    button.scheduleType = scheduleType
    bg:SetVisible(true)
    local iconInfo = info.iconInfo
    if string.len(iconInfo.iconPath) > 0 then
      bg:SetTexture(iconInfo.iconPath)
      button.labelIcon:SetTexture(iconInfo.iconPath)
      if iconInfo.labelKeyString ~= nil and iconInfo.labelKeyString ~= "" then
        button.labelIcon:SetTextureInfo(iconInfo.labelKeyString)
        button.labelIcon:SetVisible(true)
      else
        button.labelIcon:SetVisible(false)
      end
    else
      bg:SetColor(1, 1, 1, 1)
      button.labelIcon:SetVisible(false)
    end
    button.tooltip = nil
    if not info.validKind and info.showWherever or not info.onAir and info.showWhenever then
      if iconInfo.disableKeyString ~= nil and iconInfo.disableKeyString ~= "" then
        bg:SetTextureInfo(iconInfo.disableKeyString)
      end
      button:Enable(false)
      timeLabel:Show(false)
      button.aniTexture:SetVisible(false)
      button.aniTexture:Animation(false, false)
      if not info.onAir and info.showWhenever then
        button.tooltip = info.wheneverTooltip
      elseif not info.validKind and info.showWherever then
        button.tooltip = info.whereverTooltip
      end
    else
      local timeValue = -1
      if info.time ~= nil then
        timeValue = info.giveTerm - info.time
        button.tooltip = string.format([[
%s
%s]], info.tooltip, GetKindTip(info))
      else
        button.tooltip = info.tooltip
      end
      if info.give ~= nil and info.giveMax <= info.give then
        if iconInfo.disableKeyString ~= nil and iconInfo.disableKeyString ~= "" then
          bg:SetTextureInfo(iconInfo.disableKeyString)
        end
        button:Enable(false)
        button.aniTexture:SetVisible(false)
        button.aniTexture:Animation(false, false)
        timeLabel:Show(false)
      elseif timeValue > 0 then
        if iconInfo.enableKeyString ~= nil and iconInfo.enableKeyString ~= "" then
          bg:SetTextureInfo(iconInfo.enableKeyString)
        end
        button:Enable(false)
        button.aniTexture:SetVisible(false)
        button.aniTexture:Animation(false, false)
        timeLabel:SetText(X2Locale:LocalizeUiText(TIME, "minute", tostring(timeValue)))
        timeLabel:Show(true)
      else
        bg:SetVisible(false)
        button:Enable(true)
        button.aniTexture:SetVisible(true)
        button.aniTexture:Animation(true, true)
        timeLabel:Show(false)
      end
    end
    widget:Show(true)
  end
  function widget:Clear()
    button.aniTexture:SetVisible(false)
    button.labelIcon:SetVisible(false)
    button.aniTexture:Animation(false, false)
    button.scheduleType = nil
    widget:Show(false)
  end
  function button:OnClick()
    if button.scheduleType ~= nil then
      X2Player:TakeScheduleItem(button.scheduleType)
    end
  end
  button:SetHandler("OnClick", button.OnClick)
  function button:OnEnter()
    if self.tooltip ~= nil and string.len(self.tooltip) > 0 then
      SetTargetAnchorTooltip(self.tooltip, "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
    end
  end
  button:SetHandler("OnEnter", button.OnEnter)
  function timeLabel:OnEnter()
    local str = X2Locale:LocalizeUiText(COMMON_TEXT, "schedule_item_time_tooltip")
    SetTooltip(str, self)
  end
  timeLabel:SetHandler("OnEnter", timeLabel.OnEnter)
  function OnLeave()
    HideTooltip()
  end
  timeLabel:SetHandler("OnLeave", OnLeave)
  button:SetHandler("OnLeave", OnLeave)
  return widget
end
function CreateTimerEventWnd(id, parent)
  local wnd = UIParent:CreateWidget("window", id, parent)
  wnd:SetWidth(0)
  wnd.scheduleItems = {}
  wnd:SetUILayer("game")
  function wnd:FillData()
    local scheduleList = X2Player:GetScheduleItemList(true)
    local maxCount = math.max(#wnd.scheduleItems, #scheduleList)
    for i = 1, maxCount do
      if i > #wnd.scheduleItems then
        wnd.scheduleItems[i] = CreateScheduleItemTimer("scheduleItems", i, wnd)
        if i == 1 then
          wnd.scheduleItems[i]:AddAnchor("LEFT", wnd, 0, 0)
        else
          wnd.scheduleItems[i]:AddAnchor("LEFT", wnd.scheduleItems[i - 1], "RIGHT", 0, 0)
        end
      end
      if i > #scheduleList then
        wnd.scheduleItems[i]:Clear()
      else
        wnd.scheduleItems[i]:FillData(scheduleList[i])
      end
    end
    wnd:SetWidth(TIMER_BUTTON_SIZE * #scheduleList)
  end
  return wnd
end
local function CreateReturnUserRewardBtn(id, parent)
  local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
  widget:SetExtent(TIMER_BUTTON_SIZE, 80)
  local button = widget:CreateChildWidget("button", "button", 0, true)
  button:AddAnchor("TOP", widget, 0, 0)
  ApplyButtonSkin(button, BUTTON_HUD.TIMER)
  local itemName = string.format("%s%s|r", F_COLOR.GetColor("original_dark_orange", true), X2Item:Name(X2Player:GetReturnAccountItemType()))
  button.tooltip = X2Locale:LocalizeUiText(COMMON_TEXT, "return_user_reward_tooltip", itemName)
  local bg = widget:CreateImageDrawable(TEXTURE_PATH.TIMER, "background")
  bg:AddAnchor("TOPLEFT", button, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", button, 0, 0)
  bg:SetTextureInfo("icon_default")
  widget.bg = bg
  bg:SetVisible(false)
  CreateAnimationTexture(button)
  button.aniTexture:SetVisible(true)
  button.aniTexture:Animation(true, true)
  function button:OnClick()
    X2Player:TakeReturnAccountItem()
  end
  button:SetHandler("OnClick", button.OnClick)
  function button:OnEnter()
    SetTargetAnchorTooltip(self.tooltip, "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
  end
  button:SetHandler("OnEnter", button.OnEnter)
  function OnLeave()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  return widget
end
function CreateReturnUserRewardWnd(id, parent)
  local wnd = UIParent:CreateWidget("window", id, parent)
  wnd:SetWidth(TIMER_BUTTON_SIZE)
  wnd:SetUILayer("game")
  wnd.returnUserRewardItem = nil
  function wnd:UpdateAnchor(timerEventWnd)
    wnd:RemoveAllAnchors()
    wnd:AddAnchor("LEFT", timerEventWnd, "RIGHT", 0, 0)
  end
  function wnd:FillData()
    wnd.returnUserRewardItem = CreateReturnUserRewardBtn("returnUserRewardItem", wnd)
    wnd.returnUserRewardItem:AddAnchor("LEFT", wnd, 0, 0)
  end
  function wnd:UpdateStatus(status)
    wnd.returnUserRewardItem:Show(status)
  end
  return wnd
end
