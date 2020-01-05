local shortcut = {hero = nil, zonePermission = nil}
local function CheckShortcutAnchor()
  local offsetX = 0
  local offsetY = UIParent:GetScreenHeight() / 2 - 105
  if shortcut.hero ~= nil then
    if shortcut.hero.timer:IsVisible() then
      offsetX = -245
    else
      offsetX = -6
    end
    shortcut.hero:RemoveAllAnchors()
    shortcut.hero:AddAnchor("BOTTOMRIGHT", "UIParent", "TOPRIGHT", offsetX, offsetY)
    offsetY = offsetY + -(shortcut.hero:GetHeight() + 10)
  end
end
local function CreateHeroShortcut(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:SetExtent(60, 65)
  local ButtonFontColor = function()
    local color = {}
    color.normal = FONT_COLOR.LABORPOWER_YELLOW
    color.highlight = FONT_COLOR.YELLOW_OCHER
    color.pushed = FONT_COLOR.YELLOW_OCHER
    color.disabled = FONT_COLOR.GRAY
    return color
  end
  local shortcutButton = frame:CreateChildWidget("button", "shortcutButton", 0, true)
  shortcutButton:Show(false)
  shortcutButton:SetExtent(100, 30)
  shortcutButton:SetInset(62, 0, 0, 0)
  shortcutButton:SetText(GetUIText(COMMON_TEXT, "show_hero_window"))
  shortcutButton.style:SetAlign(ALIGN_LEFT)
  shortcutButton.style:SetFontSize(FONT_SIZE.LARGE)
  SetButtonFontColor(shortcutButton, ButtonFontColor())
  local function LeftClickFunc()
    ADDON:ShowContent(UIC_HERO_RANK_WND, true)
    frame:Show(false)
  end
  ButtonOnClickHandler(shortcutButton, LeftClickFunc)
  local textBg = shortcutButton:CreateDrawable(TEXTURE_PATH.HERO_SHORTCUT, "bg_text", "background")
  textBg:AddAnchor("LEFT", shortcutButton, -20, 0)
  shortcutButton:SetExtent(textBg:GetExtent())
  local coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "light"):GetCoords()
  }
  local shortcutLight = shortcutButton:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  shortcutLight:SetCoords(coords[1], coords[2], coords[3], coords[4])
  shortcutLight:SetExtent(coords[3], coords[4])
  shortcutLight:SetVisible(false)
  shortcutLight:SetRepeatCount(1)
  shortcutLight:SetEffectPriority(1, "alpha", 0.7, 0.7)
  shortcutLight:SetEffectInitialColor(1, 1, 1, 1, 0)
  shortcutLight:SetEffectFinalColor(1, 1, 1, 1, 0.39)
  shortcutLight:SetEffectScale(1, 1, 1, 1, 1)
  shortcutLight:SetEffectPriority(2, "alpha", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(2, 1, 1, 1, 0.39)
  shortcutLight:SetEffectFinalColor(2, 1, 1, 1, 0.3)
  shortcutLight:SetEffectRotate(2, 0, -15)
  shortcutLight:SetEffectScale(2, 1, 1, 1, 1)
  shortcutLight:SetEffectPriority(3, "alpha", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(3, 1, 1, 1, 0.3)
  shortcutLight:SetEffectFinalColor(3, 1, 1, 1, 0.13)
  shortcutLight:SetEffectRotate(3, -15, 0)
  shortcutLight:SetEffectScale(3, 1, 1, 0.84, 1)
  shortcutLight:SetEffectPriority(4, "alpha", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(4, 1, 1, 1, 0.13)
  shortcutLight:SetEffectFinalColor(4, 1, 1, 1, 0.3)
  shortcutLight:SetEffectRotate(4, 0, 15)
  shortcutLight:SetEffectScale(4, 0.84, 1, 1, 1)
  shortcutLight:SetEffectPriority(5, "rotate", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(5, 1, 1, 1, 0.3)
  shortcutLight:SetEffectFinalColor(5, 1, 1, 1, 0.3)
  shortcutLight:SetEffectRotate(5, 15, -15)
  shortcutLight:SetEffectScale(5, 1, 1, 1, 1)
  shortcutLight:SetEffectPriority(6, "alpha", 0.5, 0.5)
  shortcutLight:SetEffectInitialColor(6, 1, 1, 1, 0.3)
  shortcutLight:SetEffectFinalColor(6, 1, 1, 1, 0.13)
  shortcutLight:SetEffectRotate(6, -15, 0)
  shortcutLight:SetEffectScale(6, 1, 1, 0.84, 1)
  shortcutLight:SetEffectPriority(7, "alpha", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(7, 1, 1, 1, 0.13)
  shortcutLight:SetEffectFinalColor(7, 1, 1, 1, 0.3)
  shortcutLight:SetEffectRotate(7, 0, -15)
  shortcutLight:SetEffectScale(7, 0.84, 1, 1, 1)
  shortcutLight:SetEffectPriority(8, "alpha", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(8, 1, 1, 1, 0.3)
  shortcutLight:SetEffectFinalColor(8, 1, 1, 1, 0.13)
  shortcutLight:SetEffectRotate(8, -15, 0)
  shortcutLight:SetEffectScale(8, 1, 1, 0.84, 1)
  shortcutLight:SetEffectPriority(9, "alpha", 0.5, 0.5)
  shortcutLight:SetEffectInitialColor(9, 1, 1, 1, 0.13)
  shortcutLight:SetEffectFinalColor(9, 1, 1, 1, 0.3)
  shortcutLight:SetEffectRotate(9, 0, -15)
  shortcutLight:SetEffectScale(9, 0.84, 1, 1, 1)
  shortcutLight:SetEffectPriority(10, "alpha", 0.5, 0.5)
  shortcutLight:SetEffectInitialColor(10, 1, 1, 1, 0.3)
  shortcutLight:SetEffectFinalColor(10, 1, 1, 1, 0.13)
  shortcutLight:SetEffectRotate(10, -15, 0)
  shortcutLight:SetEffectScale(10, 1, 1, 0.84, 1)
  shortcutLight:SetEffectPriority(11, "alpha", 0.4, 0.4)
  shortcutLight:SetEffectInitialColor(11, 1, 1, 1, 0.13)
  shortcutLight:SetEffectFinalColor(11, 1, 1, 1, 0)
  shortcutLight:SetEffectRotate(11, 0, 0)
  shortcutLight:SetEffectScale(11, 0.84, 1, 0.84, 1)
  coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "light"):GetCoords()
  }
  local shortcutLight2 = shortcutButton:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  shortcutLight2:SetCoords(coords[1], coords[2], coords[3], coords[4])
  shortcutLight2:SetExtent(coords[3], coords[4])
  shortcutLight2:SetVisible(false)
  shortcutLight2:SetRepeatCount(1)
  shortcutLight2:SetEffectPriority(1, "alpha", 1.1, 1.1)
  shortcutLight2:SetEffectInitialColor(1, 1, 1, 1, 0)
  shortcutLight2:SetEffectFinalColor(1, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectRotate(1, 0, 15)
  shortcutLight2:SetEffectScale(1, 0.95, 0.95, 1.1, 1.1)
  shortcutLight2:SetEffectPriority(2, "alpha", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(2, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectFinalColor(2, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectRotate(2, 15, 0)
  shortcutLight2:SetEffectScale(2, 1.1, 1.1, 0.97, 1.1)
  shortcutLight2:SetEffectPriority(3, "alpha", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(3, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectFinalColor(3, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectRotate(3, 0, -15)
  shortcutLight2:SetEffectScale(3, 0.97, 1.1, 1.1, 1.1)
  shortcutLight2:SetEffectPriority(4, "rotate", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(4, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectFinalColor(4, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectRotate(4, -15, 15)
  shortcutLight2:SetEffectScale(4, 0.97, 1.1, 1.1, 1.1)
  shortcutLight2:SetEffectPriority(5, "alpha", 0.5, 0.5)
  shortcutLight2:SetEffectInitialColor(5, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectFinalColor(5, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectRotate(5, 15, 0)
  shortcutLight2:SetEffectScale(5, 1.1, 1.1, 0.97, 1.1)
  shortcutLight2:SetEffectPriority(6, "alpha", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(6, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectFinalColor(6, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectRotate(6, 0, 15)
  shortcutLight2:SetEffectScale(6, 0.97, 1.1, 1, 1)
  shortcutLight2:SetEffectPriority(7, "alpha", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(7, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectFinalColor(7, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectRotate(7, 15, 0)
  shortcutLight2:SetEffectScale(7, 1, 1, 0.97, 1.1)
  shortcutLight2:SetEffectPriority(8, "alpha", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(8, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectFinalColor(8, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectRotate(8, 0, 15)
  shortcutLight2:SetEffectScale(8, 0.97, 1.1, 1.1, 1.1)
  shortcutLight2:SetEffectPriority(9, "alpha", 0.5, 0.5)
  shortcutLight2:SetEffectInitialColor(9, 1, 1, 1, 0.4)
  shortcutLight2:SetEffectFinalColor(9, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectRotate(9, 15, 0)
  shortcutLight2:SetEffectScale(9, 1.1, 1.1, 0.97, 1.1)
  shortcutLight2:SetEffectPriority(10, "alpha", 0.4, 0.4)
  shortcutLight2:SetEffectInitialColor(10, 1, 1, 1, 0.53)
  shortcutLight2:SetEffectFinalColor(10, 1, 1, 1, 0)
  shortcutLight2:SetEffectRotate(10, 0, 0)
  shortcutLight2:SetEffectScale(10, 0.97, 1.1, 0.97, 1.1)
  coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "shield_light"):GetCoords()
  }
  local shortcutShield = shortcutButton:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  shortcutShield:SetCoords(coords[1], coords[2], coords[3], coords[4])
  shortcutShield:SetExtent(coords[3], coords[4])
  shortcutShield:SetVisible(false)
  shortcutShield:SetRepeatCount(1)
  shortcutShield:SetEffectPriority(1, "alpha", 0.7, 0.7)
  shortcutShield:SetEffectInitialColor(1, 1, 1, 1, 0)
  shortcutShield:SetEffectFinalColor(1, 1, 1, 1, 0.5)
  shortcutShield:SetEffectScale(1, 1, 1, 1.2, 1.2)
  shortcutShield:SetEffectPriority(2, "alpha", 0.6, 0.6)
  shortcutShield:SetEffectInitialColor(2, 1, 1, 1, 0.5)
  shortcutShield:SetEffectFinalColor(2, 1, 1, 1, 0)
  shortcutShield:SetEffectScale(2, 1.2, 1.2, 1, 1)
  function shortcutButton:StartEffect()
    shortcutLight:SetVisible(true)
    shortcutLight2:SetVisible(true)
    shortcutShield:SetVisible(true)
    shortcutLight:SetStartEffect(true)
    shortcutLight2:SetStartEffect(true)
    shortcutShield:SetStartEffect(true)
  end
  local timer = frame:CreateChildWidget("emptywidget", "timer", 0, true)
  timer:Show(true)
  timer:AddAnchor("TOPLEFT", frame, 0, 0)
  timer:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local function OnEnter(self)
    if shortcutButton:IsVisible() then
      return
    end
    SetTooltip(GetUIText(COMMON_TEXT, "aggregate_hero_election_result"), self)
  end
  timer:SetHandler("OnEnter", OnEnter)
  local coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "light"):GetCoords()
  }
  local light = timer:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  light:SetCoords(coords[1], coords[2], coords[3], coords[4])
  light:SetExtent(coords[3], coords[4])
  light:SetVisible(false)
  light:SetRepeatCount(1)
  light:SetEffectPriority(1, "alpha", 0.4, 0.4)
  light:SetEffectInitialColor(1, 1, 1, 1, 0.3)
  light:SetEffectFinalColor(1, 1, 1, 1, 0.1)
  light:SetEffectRotate(1, 15, 0)
  light:SetEffectScale(1, 1, 0.84, 1, 1)
  light:SetEffectPriority(2, "alpha", 0.4, 0.4)
  light:SetEffectInitialColor(2, 1, 1, 1, 0.13)
  light:SetEffectFinalColor(2, 1, 1, 1, 0.3)
  light:SetEffectRotate(2, 0, 15)
  light:SetEffectScale(2, 0.84, 1, 1, 1)
  light:SetEffectPriority(3, "alpha", 0.5, 0.5)
  light:SetEffectInitialColor(3, 1, 1, 1, 0.3)
  light:SetEffectFinalColor(3, 1, 1, 1, 0.3)
  light:SetEffectRotate(3, 15, -15)
  light:SetEffectScale(3, 1, 1, 1, 1)
  light:SetEffectPriority(4, "alpha", 0.4, 0.4)
  light:SetEffectInitialColor(4, 1, 1, 1, 0.3)
  light:SetEffectFinalColor(4, 1, 1, 1, 0)
  light:SetEffectRotate(4, -15, 0)
  light:SetEffectScale(4, 1, 1, 0.84, 1)
  coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "light"):GetCoords()
  }
  local light2 = timer:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  light2:SetCoords(coords[1], coords[2], coords[3], coords[4])
  light2:SetExtent(coords[3], coords[4])
  light2:SetVisible(false)
  light2:SetRepeatCount(1)
  light2:SetEffectPriority(1, "alpha", 0.4, 0.4)
  light2:SetEffectInitialColor(1, 1, 1, 1, 0.4)
  light2:SetEffectFinalColor(1, 1, 1, 1, 0.5)
  light2:SetEffectRotate(1, 15, 0)
  light2:SetEffectScale(1, 1.1, 1.1, 0.97, 1.1)
  light2:SetEffectPriority(2, "alpha", 0.4, 0.4)
  light2:SetEffectInitialColor(2, 1, 1, 1, 0.53)
  light2:SetEffectFinalColor(2, 1, 1, 1, 0.4)
  light2:SetEffectRotate(2, 0, -15)
  light2:SetEffectScale(2, 0.97, 1.1, 1.1, 1.1)
  light2:SetEffectPriority(3, "alpha", 0.5, 0.5)
  light2:SetEffectInitialColor(3, 1, 1, 1, 0.4)
  light2:SetEffectFinalColor(3, 1, 1, 1, 0.4)
  light2:SetEffectRotate(3, -15, 15)
  light2:SetEffectScale(1, 1.1, 1.1, 1.1, 1.1)
  light2:SetEffectPriority(4, "alpha", 0.4, 0.4)
  light2:SetEffectInitialColor(4, 1, 1, 1, 0.53)
  light2:SetEffectFinalColor(4, 1, 1, 1, 0)
  light2:SetEffectRotate(4, 15, 0)
  light2:SetEffectScale(1, 0.97, 1.1, 0.97, 1.1)
  coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "shield_light"):GetCoords()
  }
  local shieldLight = timer:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  shieldLight:SetCoords(coords[1], coords[2], coords[3], coords[4])
  shieldLight:SetExtent(coords[3], coords[4])
  shieldLight:SetVisible(false)
  shieldLight:SetRepeatCount(1)
  shieldLight:SetEffectPriority(1, "alpha", 0.4, 0.4)
  shieldLight:SetEffectInitialColor(1, 1, 1, 1, 0)
  shieldLight:SetEffectFinalColor(1, 1, 1, 1, 1)
  shieldLight:SetEffectPriority(2, "alpha", 0.4, 0.4)
  shieldLight:SetEffectInitialColor(2, 1, 1, 1, 1)
  shieldLight:SetEffectFinalColor(2, 1, 1, 1, 0)
  coords = {
    GetTextureInfo(TEXTURE_PATH.HERO_SHORTCUT, "shield_light"):GetCoords()
  }
  local shieldLight2 = timer:CreateEffectDrawable(TEXTURE_PATH.HERO_SHORTCUT, "background")
  shieldLight2:SetCoords(coords[1], coords[2], coords[3], coords[4])
  shieldLight2:SetExtent(coords[3], coords[4])
  shieldLight2:SetVisible(false)
  shieldLight2:SetRepeatCount(1)
  shieldLight2:SetEffectPriority(1, "alpha", 0.6, 0.6)
  shieldLight2:SetEffectInitialColor(1, 1, 1, 1, 0)
  shieldLight2:SetEffectFinalColor(1, 1, 1, 1, 0.46)
  shieldLight2:SetEffectScale(1, 1, 1, 1.3, 1.3)
  shieldLight2:SetEffectPriority(2, "alpha", 0.5, 0.5)
  shieldLight2:SetEffectInitialColor(2, 1, 1, 1, 0.46)
  shieldLight2:SetEffectFinalColor(2, 1, 1, 1, 0)
  shieldLight2:SetEffectScale(2, 1.3, 1.3, 1.5, 1.5)
  function timer:StartEffect()
    light:SetVisible(true)
    light2:SetVisible(true)
    shieldLight:SetVisible(true)
    shieldLight2:SetVisible(true)
    light:SetStartEffect(true)
    light2:SetStartEffect(true)
    shieldLight:SetStartEffect(true)
    shieldLight2:SetStartEffect(true)
  end
  local bg = timer:CreateDrawable(TEXTURE_PATH.HERO_SHORTCUT, "shield", "background")
  bg:AddAnchor("CENTER", timer, 0, 0)
  light:AddAnchor("CENTER", bg, 0, 0)
  light2:AddAnchor("CENTER", bg, 0, 0)
  shieldLight:AddAnchor("CENTER", bg, 1, 0)
  shieldLight2:AddAnchor("CENTER", bg, 1, 0)
  local timeStrInset = -7
  local timeBg = timer:CreateDrawable(TEXTURE_PATH.HERO_SHORTCUT, "bg_timer", "background")
  timeBg:AddAnchor("BOTTOM", bg, 0, timeStrInset)
  timer.timeBg = timeBg
  local timeStr = timer:CreateChildWidget("label", "timeStr", 0, true)
  timeStr:SetAutoResize(true)
  timeStr:SetHeight(FONT_SIZE.MIDDLE)
  timeStr:AddAnchor("CENTER", timeBg, 2, 1)
  timeStr.style:SetShadow(true)
  local shortcutInset = -50
  shortcutButton:AddAnchor("LEFT", bg, "RIGHT", shortcutInset, 5)
  shortcutLight:AddAnchor("CENTER", bg, 0, 0)
  shortcutLight2:AddAnchor("CENTER", bg, 0, 0)
  shortcutShield:AddAnchor("CENTER", bg, 1, 0)
  function frame:ShowTimer()
    if self:IsVisible() then
      return
    end
    self:Show(true)
    self.timer:Show(true)
  end
  local prevTime = 0
  function frame:StartTimerAnim(remainTime, firstSignal)
    self.timer.timeStr:SetText(GetUIText(TIME, "minute", tostring(remainTime)))
    if not firstSignal and prevTime == 0 then
      prevTime = remainTime
      return
    end
    if not firstSignal and prevTime == remainTime then
      return
    end
    self.shortcutButton:Show(false)
    self.timer.timeStr:Show(true)
    timeBg:SetVisible(true)
    self.timer:StartEffect()
    local count = 0
    local curAlpha = 1
    local fadeValue = -0.05
    local function OnUpdate(self)
      if curAlpha <= 0 then
        count = count + 1
        fadeValue = 0.05
      elseif curAlpha >= 1 then
        count = count + 1
        fadeValue = -0.05
      end
      curAlpha = curAlpha + fadeValue
      self:SetAlpha(curAlpha)
      if count > 5 then
        self:ReleaseHandler("OnUpdate")
        self:SetAlpha(1)
        return
      end
    end
    self.timer.timeStr:SetHandler("OnUpdate", OnUpdate)
    prevTime = remainTime
  end
  function frame:ShowShortcut()
    self:Show(true)
    self.timer.timeStr:Show(false, 400)
    timeBg:SetVisible(false, 400)
    self.shortcutButton:Show(true, 300)
    self.shortcutButton:StartEffect()
  end
  local function OnEndFadeOut()
    shortcut.hero = nil
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
local function ShowHeroTimer(remainTime, isStartTime)
  if shortcut.hero == nil then
    shortcut.hero = CreateHeroShortcut("shortcut.hero", "UIParent")
    shortcut.hero:EnableHidingIsRemove(true)
    CheckShortcutAnchor()
  end
  shortcut.hero:ShowTimer()
  shortcut.hero:StartTimerAnim(remainTime + 1, isStartTime)
end
UIParent:SetEventHandler("HERO_ANNOUNCE_REMAIN_TIME", ShowHeroTimer)
local function ShowHeroShortcut()
  if shortcut.hero == nil then
    shortcut.hero = CreateHeroShortcut("shortcut.hero", "UIParent")
    shortcut.hero:EnableHidingIsRemove(true)
  end
  shortcut.hero:ShowShortcut()
  CheckShortcutAnchor()
end
UIParent:SetEventHandler("HERO_ELECTION_RESULT", ShowHeroShortcut)
UIParent:SetEventHandler("HERO_NOTI", ShowHeroShortcut)
local function CreateZonePermissionShortcut(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:SetExtent(60, 65)
  local textBg = frame:CreateDrawable(TEXTURE_PATH.ZONE_PERMISSION_OUT, "bg_btn", "background")
  textBg:AddAnchor("CENTER", frame, 12, 0)
  local shortcutButton = frame:CreateChildWidget("button", "shortcutButton", 0, true)
  shortcutButton:Show(true)
  shortcutButton:AddAnchor("LEFT", frame, 0, 0)
  ApplyButtonSkin(shortcutButton, BUTTON_CONTENTS.ZONE_PERMISSION_OUT)
  local LeftClickFunc = function()
    X2Player:OpenZonePermissionOutWindow()
  end
  ButtonOnClickHandler(shortcutButton, LeftClickFunc)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:SetText(GetUIText(COMMON_TEXT, "zp_out_time"))
  title:AddAnchor("LEFT", shortcutButton, "RIGHT", 3, -title:GetHeight() / 2 - 4)
  title.style:SetFontSize(FONT_SIZE.MIDDLE)
  title.style:SetShadow(true)
  ApplyTextColor(title, FONT_COLOR.WHITE)
  local timer = frame:CreateChildWidget("label", "timer", 0, true)
  timer:SetAutoResize(true)
  timer:SetHeight(FONT_SIZE.LARGE)
  timer:SetText("0")
  timer:AddAnchor("LEFT", shortcutButton, "RIGHT", 3, timer:GetHeight() / 2 - 1)
  timer.style:SetShadow(true)
  timer.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(timer, FONT_COLOR.SOFT_YELLOW)
  local widthA = F_LAYOUT.GetExtentWidgets(shortcutButton, title)
  frame:SetWidth(widthA)
  local noti = GetNotifierWnd()
  if noti ~= nil then
    frame:AddAnchor("TOPRIGHT", noti, "TOPLEFT", -55, 20)
  else
    frame:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", -400, UIParent:GetScreenHeight() / 2 - 82)
  end
  local delay = 500
  local function OnUpdate(self, dt)
    delay = delay + dt
    if delay > 500 then
      local condition = X2Player:GetZonePermissionCondition()
      timer:SetText(tostring(condition.waitTime) .. GetUIText(CHARACTER_SUBTITLE_INFO_TOOLTIP_TEXT, "sec"))
      if condition.permission == 0 then
        shortcut.zonePermission:Show(false)
      end
      delay = 0
    end
  end
  frame:SetHandler("OnUpdate", OnUpdate)
  return frame
end
local function UpdateZonePermission()
  if shortcut.zonePermission == nil then
    shortcut.zonePermission = CreateZonePermissionShortcut("shortcut.zonePermission", "UIParent")
  end
  local condition = X2Player:GetZonePermissionCondition()
  if (condition.permission == 1 or condition.permission == 4) and condition.waitTime > 0 and condition.inZone == true then
    shortcut.zonePermission:Show(true)
  elseif shortcut.zonePermission ~= nil then
    shortcut.zonePermission:Show(false)
  end
end
UIParent:SetEventHandler("UPDATE_ZONE_PERMISSION", UpdateZonePermission)
UIParent:SetEventHandler("LEFT_LOADING", UpdateZonePermission)
local function OnEnteredWorld()
  local remainTime = X2Hero:GetRemainTimeToAnnounceHero()
  if remainTime > -1 then
    ShowHeroTimer(remainTime, false)
  end
  UpdateZonePermission()
end
UIParent:SetEventHandler("ENTERED_WORLD", OnEnteredWorld)
