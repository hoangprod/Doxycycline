siegeScheduleIcons = CreateEmptyWindow("siegeSchedule", "UIParent")
siegeScheduleIcons:Show(false)
siegeScheduleIcons:AddAnchor("TOPRIGHT", "UIParent", -8, 150)
siegeScheduleIcons:SetExtent(225, 180)
siegeScheduleIcons.BUTTONHEIGHT = 60
siegeScheduleIcons.TOTAL_SCHEDULE = 10
local scrollWindow = CreateScrollWindow(siegeScheduleIcons, "scrollWindow", 0)
scrollWindow:AddAnchor("TOPLEFT", siegeScheduleIcons, 0, 0)
scrollWindow:AddAnchor("BOTTOMRIGHT", siegeScheduleIcons, 0, 0)
scrollWindow:Lock(true)
siegeScheduleIcons.scrollWindow = scrollWindow
local CreateIcon = function(id, parent, index)
  local CreateIconAlarm = function(id, parent, index)
    local button = CreateEmptyButton(id .. index, parent)
    button:AddAnchor("TOPRIGHT", parent, 0, siegeScheduleIcons.BUTTONHEIGHT * index)
    button:Raise()
    ApplyButtonSkin(button, BUTTON_CONTENTS.SIEGE_PERIOD_DECLARE)
    local hpBar = W_BAR.CreateHpBar(id .. ".hpBar" .. index, button)
    hpBar:SetExtent(160, 16)
    hpBar:ReleaseHandler("OnLeave")
    hpBar:ReleaseHandler("OnEnter")
    hpBar:AddAnchor("BOTTOMRIGHT", button, "BOTTOMLEFT", 18, -3)
    button.hpBar = hpBar
    local hpText = W_CTRL.CreateLabel(id .. "hpText" .. index, hpBar)
    hpText:AddAnchor("TOPLEFT", hpBar, 0, 0)
    hpText:AddAnchor("BOTTOMRIGHT", hpBar, 0, -1)
    hpText.style:SetFontSize(FONT_SIZE.SMALL)
    hpText.style:SetAlign(ALIGN_CENTER)
    hpText.style:SetColor(1, 1, 1, 1)
    button.hpText = hpText
    local label = W_CTRL.CreateLabel(id .. ".label" .. index, button)
    label:SetAutoResize(true)
    label:SetExtent(0, 20)
    label.style:SetShadow(true)
    label.style:SetAlign(ALIGN_RIGHT)
    label:AddAnchor("BOTTOMRIGHT", hpBar, "TOPRIGHT", -22, -2)
    button.label = label
    local bg = label:CreateDrawable(TEXTURE_PATH.HUD, "alarm_bg", "background")
    bg:AddAnchor("TOPLEFT", label, -25, 0)
    bg:AddAnchor("BOTTOMRIGHT", label, 35, 2)
    bg:SetTextureColor("default")
    button.label.bg = bg
    local memberCount = button:CreateChildWidget("textbox", "memberCount", 0, true)
    memberCount:Show(true)
    memberCount:SetHeight(13)
    memberCount:AddAnchor("BOTTOMRIGHT", label, "TOPRIGHT", 0, -2)
    memberCount.style:SetAlign(ALIGN_RIGHT)
    memberCount.style:SetFontSize(FONT_SIZE.MIDDLE)
    memberCount.style:SetColor(1, 1, 1, 1)
    function button:ShowButton(show)
      self.tooltipText = ""
      self:Show(show)
    end
    function button:ShowLabel(show, remainDateString)
      self.label:SetText(remainDateString or "")
      self.label:Show(show)
      self.label.bg:SetVisible(show)
    end
    function button:ShowHpBar(show)
      self.hpBar:SetMinMaxValues(0, 0)
      self.hpBar:SetValue(0)
      self.hpText:SetText("")
      self.hpBar:Show(show)
      self.hpText:Show(show)
    end
    function button:SetHp(curHealth, maxHealth)
      self.hpBar:SetMinMaxValues(0, maxHealth)
      self.hpBar:SetValue(curHealth)
      local percent = maxHealth > 0 and math.floor(curHealth * 100 / maxHealth) or 0
      local text = string.format("%d/%d(%d%%)", curHealth, maxHealth, percent)
      self.hpText:SetText(text)
    end
    button:ShowButton(false)
    button:ShowHpBar(false)
    return button
  end
  local icon = {}
  icon.alarm = CreateIconAlarm(id, parent, index)
  return icon
end
siegeScheduleIcons.icons = {}
for k = 1, siegeScheduleIcons.TOTAL_SCHEDULE do
  siegeScheduleIcons.icons[k] = CreateIcon("siegeSchedule.icon", siegeScheduleIcons.scrollWindow.content, k)
end
