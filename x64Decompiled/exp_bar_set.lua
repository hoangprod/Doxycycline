local CreateDayEventAlarmButton = function(id, parent)
  local button = parent:CreateChildWidget("button", id, 0, true)
  ApplyButtonSkin(button, BUTTON_HUD.DAY_EVENT)
  local ButtonLeftClickFunc = function(self)
    ToggleDayEventAlarmWindow()
  end
  ButtonOnClickHandler(button, ButtonLeftClickFunc)
end
function SetViewOfExpBarSet(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:Show(true)
  local exp_percent = frame:CreateChildWidget("label", "exp_percent", 0, true)
  exp_percent:AddAnchor("BOTTOMLEFT", frame, "TOPLEFT", 6, -7)
  exp_percent:SetExtent(85, FONT_SIZE.XXLARGE)
  exp_percent.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  exp_percent.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(exp_percent, FONT_COLOR.EXP_ORANGE)
  local exp_bar = W_BAR.CreateExpBar(frame:GetId() .. ".exp_bar", frame)
  exp_bar:AddAnchor("TOPLEFT", frame, 0, 0)
  frame.exp_bar = exp_bar
  local recoverable_exp = exp_bar:CreateDrawable(TEXTURE_PATH.HUD, "recover_exp_bg", "background")
  recoverable_exp:SetTextureColor("default")
  recoverable_exp:SetHeight(4)
  recoverable_exp:AddAnchor("LEFT", exp_bar, 0, 0)
  recoverable_exp:SetVisible(true)
  exp_bar.recoverable_exp = recoverable_exp
  local exp_bar_left_round_deco = exp_bar:CreateDrawable(TEXTURE_PATH.HUD, "bar_left_round_deco", "overlay")
  exp_bar_left_round_deco:AddAnchor("LEFT", exp_bar, 0, 0)
  local exp_bar_right_round_deco = exp_bar:CreateDrawable(TEXTURE_PATH.HUD, "bar_right_round_deco", "overlay")
  exp_bar_right_round_deco:AddAnchor("RIGHT", exp_bar, 0, 0)
  local timerEventWnd = CreateTimerEventWnd("timerEventWnd", frame)
  timerEventWnd:Show(true)
  timerEventWnd:SetHeight(80)
  timerEventWnd:AddAnchor("BOTTOMLEFT", exp_percent, "TOPLEFT", 0, -5)
  timerEventWnd:FillData()
  frame.timerEventWnd = timerEventWnd
  local returnUserRewardWnd
  if X2Player:GetFeatureSet().returnAccount and X2Player:IsReturnAccount() then
    returnUserRewardWnd = CreateReturnUserRewardWnd("returnUserRewardWnd", frame)
    returnUserRewardWnd:Show(true)
    returnUserRewardWnd:SetHeight(80)
    returnUserRewardWnd:UpdateAnchor(timerEventWnd)
    returnUserRewardWnd:FillData()
    frame.returnUserRewardWnd = returnUserRewardWnd
  end
  return frame
end
function CreateExpBarSet(id, parent)
  local frame = SetViewOfExpBarSet(id, parent)
  function frame:SettingExpTooltip(widget)
    function widget:OnEnter()
      local expPercent, currentLevelExpStr, forLevelupExpStr = X2Player:GetExpInfo()
      local heirExpInfo = X2Player:GetHeirExpInfo()
      if X2Player:GetFeatureSet().useHeirSkill and X2Player:GetMinHeirLevel() == X2Unit:UnitLevel("player") then
        expPercent = string.sub(heirExpInfo.percent, 1, 5)
        currentLevelExpStr = heirExpInfo.exp
        forLevelupExpStr = heirExpInfo.totalExp
      end
      local tooltip = string.format("%s: |,%s; / |,%s; (%.2f%%)", GetUIText(COMMON_TEXT, "exp"), currentLevelExpStr, forLevelupExpStr, expPercent)
      SetExpTooltip(tooltip, frame.exp_bar)
    end
    widget:SetHandler("OnEnter", widget.OnEnter)
    function widget:OnLeave()
      HideTooltip()
    end
    widget:SetHandler("OnLeave", widget.OnLeave)
  end
  frame:SettingExpTooltip(frame.exp_bar)
  frame:SettingExpTooltip(frame.exp_percent)
  function frame:UpdateExpSet()
    local expPercent = X2Player:GetExpInfo()
    local exp_str
    self.exp_bar:ChangeStatusBarDefaultColor()
    local heirExpInfo = X2Player:GetHeirExpInfo()
    if X2Player:GetFeatureSet().useHeirSkill and X2Player:GetMinHeirLevel() == X2Unit:UnitLevel("player") then
      expPercent = string.sub(heirExpInfo.percent, 1, 5)
      exp_str = string.format("%.2f%%", expPercent)
      if exp_str == "100.00%" then
        exp_str = "100%"
      end
      if heirExpInfo.level > 0 then
        ApplyTextColor(self.exp_percent, F_COLOR.GetColor("successor_exp"))
        self.exp_bar:ChangeStatusBarColor({
          255,
          208,
          63
        })
      end
    else
      exp_str = string.format("%.2f%%", expPercent)
      if exp_str == "100.00%" then
        exp_str = "99.99%"
      end
    end
    self.exp_percent:SetText(exp_str)
    local recoverableExpStr, recoverableExpPercent = X2Player:GetRecoverableExp()
    local exp_barWidth = self.exp_bar:GetWidth()
    local width = (expPercent + recoverableExpPercent) * 0.01 * exp_barWidth
    self.exp_bar.recoverable_exp:SetWidth(width)
    self.exp_bar:SetMinMaxValues(0, 10000)
    self.exp_bar:SetValue(expPercent * 100)
  end
  function frame:UpdatePermission()
    frame.timerEventWnd:Show(UIParent:GetPermission(UIC_SCHEDULE_ITEM))
    if frame.returnUserRewardWnd ~= nil then
      frame.returnUserRewardWnd:Show(UIParent:GetPermission(UIC_RETURN_ACCOUNT_REWARD_WND))
    end
  end
  frame:UpdateExpSet()
  frame:UpdatePermission()
  local exp_set_event = {
    EXP_CHANGED = function(stringId, expNum, expStr)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      frame:UpdateExpSet()
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      frame:UpdateExpSet()
    end,
    HEIR_LEVEL_UP = function()
      frame:UpdateExpSet()
    end,
    RECOVERABLE_EXP = function(stringId, expNum)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      frame:UpdateExpSet()
    end,
    RECOVERED_EXP = function(stringId, expNum)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      local message = locale.util.GetRecoveredExpString(tostring(expNum))
      X2Chat:DispatchChatMessage(CMF_SELF_STATUS_INFO, message)
    end,
    LEFT_LOADING = function()
      frame.timerEventWnd:FillData()
      frame:UpdateExpSet()
    end,
    SCHEDULE_ITEM_UPDATED = function()
      frame.timerEventWnd:FillData()
      if frame.returnUserRewardWnd ~= nil then
        frame.returnUserRewardWnd:UpdateAnchor(frame.timerEventWnd)
      end
    end,
    SCHEDULE_ITEM_SENT = function()
      frame.timerEventWnd:FillData()
    end,
    UPDATE_RETURN_ACCOUNT_STATUS = function(status)
      if frame.returnUserRewardWnd ~= nil then
        frame.returnUserRewardWnd:UpdateStatus(status)
      end
    end
  }
  frame:SetHandler("OnEvent", function(this, event, ...)
    exp_set_event[event](...)
  end)
  RegistUIEvent(frame, exp_set_event)
  UIParent:SetEventHandler("UI_PERMISSION_UPDATE", frame.UpdatePermission)
  return frame
end
