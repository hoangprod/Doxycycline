local BUFF_ANIMATION_TIME = 0.1
local BLINK_START_TIME = 30000
local BLINK_HALF_CYCLE = 800
local SetViewOfBuffWindow = function(id, parent, maxCount, normalColor)
  local w = CreateEmptyWindow(id, parent)
  w.buffCountOnSingleLine = 12
  w.iconSize = 28
  w.iconXGap = 3
  w.iconYGap = 3
  w.button = {}
  for i = 1, maxCount do
    local button = CreateItemIconButton(id .. ".button[" .. i .. "]", w)
    button:Show(false)
    button.anim = false
    button:RegisterForClicks("RightButton")
    F_SLOT.ApplySlotSkin(button, button.back, SLOT_STYLE.BUFF)
    button.leftTimeText = W_CTRL.CreateLabel(id .. ".button[" .. i .. "].leftTimeText", button)
    button.leftTimeText:Clickable(false)
    button.leftTimeText:SetAutoResize(true)
    button.leftTimeText:SetHeight(FONT_SIZE.SMALL)
    button.leftTimeText:AddAnchor("CENTER", button, -2, 0)
    button.leftTimeText.style:SetAlign(ALIGN_CENTER)
    button.leftTimeText.style:SetColor(1, 1, 1, 1)
    button.leftTimeText.style:SetOutline(true)
    button.leftTimeText.style:SetFontSize(FONT_SIZE.SMALL)
    local buffStack = button:CreateChildWidget("label", "buffStack", 0, true)
    buffStack:SetAutoResize(true)
    buffStack:SetHeight(FONT_SIZE.SMALL)
    buffStack.style:SetAlign(ALIGN_CENTER)
    buffStack.style:SetShadow(true)
    buffStack.style:SetFontSize(FONT_SIZE.SMALL)
    local buff_deco = button:CreateDrawable(TEXTURE_PATH.HUD, "buff_deco", "overlay")
    if normalColor then
      button.back:SetTextureInfo("buff_back", "buff")
      buff_deco:SetTextureInfo("buff_deco", "default")
      buff_deco:AddAnchor("BOTTOM", button, 0, 0)
      ApplyTextColor(buffStack, FONT_COLOR.DETAIL_DEMAGE)
      buffStack:AddAnchor("TOPLEFT", button, 2, 1)
    else
      button.back:SetTextureInfo("buff_back", "debuff")
      buff_deco:SetTextureInfo("debuff_deco", "default")
      buff_deco:AddAnchor("TOP", button, 0, 0)
      ApplyTextColor(buffStack, FONT_COLOR.ROSE_PINK)
      buffStack:AddAnchor("BOTTOMLEFT", button, 2, -2)
    end
    w.button[i] = button
  end
  function w:SetVisibleBuffCount(count)
    w.visibleBuffCount = count
  end
  w:SetVisibleBuffCount(maxCount)
  function w:SetLayout(buffCountOnSingleLine, size, xGap, yGap)
    if self.buffCountOnSingleLine == buffCountOnSingleLine and self.iconSize == size and xGap ~= nil and self.iconXGap == xGap and yGap ~= nil and self.iconYGap == yGap then
      return
    end
    self.buffCountOnSingleLine = buffCountOnSingleLine
    self.iconSize = size
    if xGap ~= nil then
      self.iconXGap = xGap
    end
    if yGap ~= nil then
      self.iconYGap = yGap
    end
    for i = 1, #w.button do
      self.button[i]:SetStartAnimation(false, false)
      self.button[i]:SetExtent(size, size)
      self.button[i]:RemoveAllAnchors()
      local row = math.floor((i - 1) / self.buffCountOnSingleLine)
      local column = math.mod(i - 1, self.buffCountOnSingleLine)
      if self.sortVertical == true then
        row, column = column, row
      end
      self.button[i]:AddAnchor("TOPLEFT", self, column * (size + self.iconXGap), row * (size + self.iconYGap))
    end
  end
  return w
end
local FormatRemainTime = function(timeValue, timeUnit)
  local timeStr = ""
  local key = ""
  if not (timeValue >= 0) or not timeValue then
    timeValue = 0
  end
  local multiply = 1000
  if timeUnit ~= nil and timeUnit == "sec" then
    multiply = 1
  end
  if timeValue >= multiply * 86400 then
    timeStr = tostring(math.floor(timeValue / (multiply * 86400)))
    key = "day_initial"
  elseif timeValue >= multiply * 3600 then
    timeStr = tostring(math.floor(timeValue / (multiply * 3600)))
    key = "hour_initial"
  elseif timeValue >= multiply * 60 then
    timeStr = tostring(math.floor(timeValue / (multiply * 60)))
    key = "minute_initial"
  elseif timeValue >= 0 then
    timeStr = tostring(math.floor(timeValue / multiply))
    key = "second_initial"
  end
  return X2Locale:LocalizeUiText(TIME, key, timeStr)
end
local UpdateExtent = function(wnd, count)
  local row = math.floor((count - 1) / wnd.buffCountOnSingleLine)
  local column = math.mod(count - 1, wnd.buffCountOnSingleLine)
  if wnd.sortVertical == true then
    row, column = column, row
  end
  if count < wnd.buffCountOnSingleLine then
    wnd:SetExtent((wnd.iconSize + wnd.iconXGap) * (column + 1), (wnd.iconSize + wnd.iconYGap) * (row + 1))
  else
    wnd:SetExtent((wnd.iconSize + wnd.iconXGap) * wnd.buffCountOnSingleLine, (wnd.iconSize + wnd.iconYGap) * (row + 1))
  end
end
local functionTable = {
  buff = {
    tooltip = X2Unit.UnitBuffTooltip,
    count = X2Unit.UnitBuffCount,
    info = X2Unit.UnitBuff
  },
  debuff = {
    tooltip = X2Unit.UnitDeBuffTooltip,
    count = X2Unit.UnitDeBuffCount,
    info = X2Unit.UnitDeBuff
  },
  hidden = {
    tooltip = X2Unit.UnitHiddenBuffTooltip,
    count = X2Unit.UnitHiddenBuffCount,
    info = X2Unit.UnitHiddenBuff
  },
  raid = {
    tooltip = X2Unit.UnitRemovableDebuffTooltip,
    count = X2Unit.UnitRemovableDebuffCount,
    info = X2Unit.UnitRemovableDebuff
  }
}
function W_UNIT.CreateBuffWindow(id, parent, maxCount, buffKind)
  local w = SetViewOfBuffWindow(id, parent, maxCount, buffKind == "buff")
  w.count = -1
  w.buffTypeMap = {}
  w.getBuff = functionTable[buffKind]
  if w.getBuff == nil then
    UIParent:Warning(string.format("[LOG] can't find [%s] info", buffKind))
    return
  end
  for i = 1, #w.button do
    do
      local button = w.button[i]
      function button:OnEnter()
        local buffInfo
        buffInfo = w.getBuff:tooltip(self.target, self.index)
        if buffInfo ~= nil then
          ShowTooltip(buffInfo, self)
        end
      end
      button:SetHandler("OnEnter", button.OnEnter)
      function button:OnLeave()
        HideTooltip()
      end
      button:SetHandler("OnLeave", button.OnLeave)
      button.blinkTime = 0
      function button:OnUpdate(dt)
        self.blinkTime = self.blinkTime + dt
        if self.blinkTime > BLINK_HALF_CYCLE * 2 then
          self.blinkTime = 0
        end
        local alpha = self.blinkTime % BLINK_HALF_CYCLE / BLINK_HALF_CYCLE
        if self.blinkTime < BLINK_HALF_CYCLE then
          button:SetAlpha(1 - alpha)
        else
          button:SetAlpha(alpha)
        end
      end
    end
  end
  function w:ShowLifeTime(show)
    for i = 1, #self.button do
      self.button[i].leftTimeText:Show(show)
    end
  end
  function w:BuffUpdate(target)
    local count
    count = w.getBuff:count(target) or 0
    local buffTypeMap = {}
    for i = 1, #self.button do
      local button = self.button[i]
      if i <= count and i <= self.visibleBuffCount then
        local buffInfo = w.getBuff:info(target, i)
        if buffInfo ~= nil then
          button.index = i
          button.target = target
          if button.t == nil or button.t and button.t.buff_id ~= buffInfo.buff_id then
            F_SLOT.SetIconBackGround(button, buffInfo.path)
          end
          if buffInfo.timeLeft ~= nil then
            if button:HasHandler("OnUpdate") == false and buffInfo.timeLeft <= BLINK_START_TIME then
              button:SetHandler("OnUpdate", button.OnUpdate)
            elseif button:HasHandler("OnUpdate") == true and buffInfo.timeLeft > BLINK_START_TIME then
              button:SetAlpha(1)
              button:ReleaseHandler("OnUpdate")
            end
          else
            button:SetAlpha(1)
            button:ReleaseHandler("OnUpdate")
          end
          button.t = buffInfo
          local leftTime = buffInfo.timeLeft
          if leftTime ~= nil then
            button.leftTimeText:SetText(FormatRemainTime(leftTime, buffInfo.timeUnit))
          else
            button.leftTimeText:SetText("")
          end
          if target ~= "targettarget" then
            if buffInfo == nil or buffInfo.stack == nil or 1 >= buffInfo.stack then
              button.buffStack:SetText("")
            else
              button.buffStack:SetText(string.format("x%d", buffInfo.stack))
            end
          end
          local buffType = buffInfo.buff_id
          buffTypeMap[buffType] = i
          if self.buffTypeMap[buffType] ~= nil then
            local targetButton = self.button[self.buffTypeMap[buffType]]
            if targetButton ~= button and targetButton:IsNowAnimation() then
              button:InheritAnimationData(targetButton)
            end
          else
            button:SetAlphaAnimation(0.5, 1, BUFF_ANIMATION_TIME, 0)
            button:SetScaleAnimation(1.5, 1, BUFF_ANIMATION_TIME, 0, "CENTER")
            button:SetStartAnimation(true, true)
          end
        end
        button:Show(true)
      else
        button.index = nil
        button.target = nil
        button.t = nil
        button:SetAlpha(1)
        button:Show(false)
        button:ReleaseHandler("OnUpdate")
      end
    end
    self.buffTypeMap = buffTypeMap
    if self.count ~= count then
      self.count = count
      UpdateExtent(self, count)
    end
  end
  return w
end
