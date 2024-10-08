local PLAYER_NAME_WIDTH = 105
local CreateAlarmUnreadMail = function(id, parent)
  local width = 27
  local height = 21
  local alarmWidget = UIParent:CreateWidget("emptywidget", id, parent)
  alarmWidget:Show(false)
  alarmWidget:SetExtent(width, height)
  local bg = alarmWidget:CreateDrawable(TEXTURE_PATH.HUD, "mail", "background")
  bg:AddAnchor("TOPLEFT", alarmWidget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", alarmWidget, 0, 0)
  bg:SetVisible(true)
  local effect_texture = alarmWidget:CreateEffectDrawable(TEXTURE_PATH.HUD, "background")
  effect_texture:SetVisible(false)
  effect_texture:SetCoords(705, 159, width, height)
  effect_texture:AddAnchor("TOPLEFT", alarmWidget, 0, 0)
  effect_texture:AddAnchor("BOTTOMRIGHT", alarmWidget, 0, 0)
  effect_texture:SetRepeatCount(5)
  effect_texture:SetEffectPriority(1, "alpha", 0.6, 0.5)
  effect_texture:SetEffectInitialColor(1, 1, 1, 1, 0)
  effect_texture:SetEffectFinalColor(1, 1, 1, 1, 1)
  effect_texture:SetEffectPriority(2, "alpha", 0.6, 0.5)
  effect_texture:SetEffectInitialColor(2, 1, 1, 1, 1)
  effect_texture:SetEffectFinalColor(2, 1, 1, 1, 0)
  alarmWidget.effect_texture = effect_texture
  function alarmWidget:OnEnter()
    local count = X2Mail:GetCountUnreadMail()
    SetTooltip(locale.mail.GetUnreadMail(count), self)
  end
  alarmWidget:SetHandler("OnEnter", alarmWidget.OnEnter)
  function alarmWidget:OnLeave()
    HideTooltip()
  end
  alarmWidget:SetHandler("OnLeave", alarmWidget.OnLeave)
  parent.unreadMailcount = 0
  return alarmWidget
end
local CreateSecondPasswordButton = function(id, parent)
  local button = UIParent:CreateWidget("button", id, parent)
  ApplyButtonSkin(button, BUTTON_HUD.SECONDPASSWORD_LOCK)
  function button:SetState()
    if X2Security:IsSecondPasswordCreated() then
      ChangeButtonSkin(self, BUTTON_HUD.SECONDPASSWORD_LOCK)
    else
      ChangeButtonSkin(self, BUTTON_HUD.SECONDPASSWORD_UNLOCK)
    end
  end
  local ButtonOnLeftClickFunc = function()
    ToggleSecondPasswordWnd()
  end
  ButtonOnClickHandler(button, ButtonOnLeftClickFunc)
  local OnEnter = function(self)
    remainDate = X2Security:GetSecondPasswordClearReserveTime()
    if remainDate == nil then
      SetTooltip(locale.secondPassword.secondPassword, self)
    else
      local msg = locale.time.GetRemainDateToDateFormat(remainDate)
      SetTooltip(locale.secondPassword.reservedSecondPasswordClear(msg), self)
    end
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  button:SetState()
  return button
end
function CreatePlayerFrame(id, parent)
  local w = CreateUnitFrame(id, parent, UNIT_FRAME_TYPE.PLAYER)
  local effect_texture = w:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  effect_texture:SetInternalDrawType("ninepart")
  effect_texture:SetCoords(unpack(UIParent:GetTextureData(TEXTURE_PATH.HUD, "buff_back").coords))
  effect_texture:SetInset(unpack(UIParent:GetTextureData(TEXTURE_PATH.HUD, "buff_back").inset))
  effect_texture:AddAnchor("TOPLEFT", w.hpBar, 0, 0)
  effect_texture:AddAnchor("BOTTOMRIGHT", w.hpBar, 0, 0)
  effect_texture:SetRepeatCount(0)
  effect_texture:SetEffectPriority(1, "alpha", 0.7, 0.5)
  effect_texture:SetEffectInitialColor(1, 1, 1, 1, 0)
  effect_texture:SetEffectFinalColor(1, 1, 1, 1, 0.4)
  effect_texture:SetEffectPriority(2, "alpha", 0.7, 0.5)
  effect_texture:SetEffectInitialColor(2, 1, 1, 1, 0.4)
  effect_texture:SetEffectFinalColor(2, 1, 1, 1, 0)
  w.effect_texture = effect_texture
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.secondpass or featureSet.ingameshopSecondpass then
    do
      local secondPasswordButton = CreateSecondPasswordButton("secondPasswordButton", w)
      local function UpdatePermission()
        secondPasswordButton:Enable(UIParent:GetPermission(UIC_SECOND_PASSWORD))
      end
      UIParent:SetEventHandler("UI_PERMISSION_UPDATE", UpdatePermission)
      w.secondPasswordButton = secondPasswordButton
      w:AddDynamicNameTable(UNIT_FRAME_WIDGET.PASSWORD, w.secondPasswordButton, 0)
      UpdatePermission()
    end
  end
  local alarmUnreadMail = CreateAlarmUnreadMail(w:GetId() .. "alarmUnreadMail", w)
  w.alarmUnreadMail = alarmUnreadMail
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.MAIL, w.alarmUnreadMail, 0)
  local reporterIcon = w:CreateDrawable(TEXTURE_PATH.REPORTER, "icon_unitframe_reporter", "background")
  reporterIcon:SetVisible(false)
  reporterIcon:SetExtent(17, 16)
  reporterIcon:AddAnchor("BOTTOMRIGHT", w.hpBar, "TOPRIGHT", 0, -4)
  w.reporterIcon = reporterIcon
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.REPORTER, w.reporterIcon, 2)
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.LEADER_MARK, w.leaderMark, 0)
  w:AddDynamicNameTable(UNIT_FRAME_WIDGET.MARKER, w.marker, 2)
  function w:Click(arg)
    if arg == "RightButton" then
      ActivatePopupMenu(w, "player")
    end
  end
  if w.buffWindow ~= nil then
    local buffWnd = w.buffWindow
    for i = 1, #buffWnd.button do
      do
        local button = buffWnd.button[i]
        function button:OnClickProc(arg)
          if arg == "RightButton" then
            X2Ability:CancelPlayerBuff(i)
          end
        end
      end
    end
  end
  function w:ShowReportIcon()
    self.reporterIcon:SetVisible(X2Unit:IsReporter("player"))
  end
  function w:ApplyFrameStyle()
    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.L_HP_FRIENDLY)
    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.L_MP)
    self.name:SetAutoResize(true)
    self.name:SetLimitWidth(false)
    self.buffWindow:AddAnchor("TOPLEFT", self.mpBar, "BOTTOMLEFT", 2, 4)
    self.buffWindow:SetLayout(10, 30)
    self.debuffWindow:SetLayout(10, 30)
  end
  function w:UpdateIconsAnchors()
    if self.alarmUnreadMail == nil then
      return
    end
    local v = {}
    if self.secondPasswordButton and self.secondPasswordButton:IsVisible() then
      table.insert(v, {
        widget = self.secondPasswordButton,
        offsetX = 0,
        offsetY = -1
      })
    end
    if self.alarmUnreadMail:IsVisible() then
      table.insert(v, {
        widget = self.alarmUnreadMail,
        offsetX = 2,
        offsetY = 2
      })
    end
    if self.reporterIcon:IsVisible() then
      table.insert(v, {
        widget = self.reporterIcon,
        offsetX = 0,
        offsetY = 1
      })
    end
    local gapWidth = 0
    for i = 1, #v do
      local target = v[i]
      target.widget:RemoveAllAnchors()
      target.widget:AddAnchor("RIGHT", self.hpBar, "RIGHT", -gapWidth + target.offsetX, -self.hpBar:GetHeight() + target.offsetY)
      gapWidth = gapWidth + target.widget:GetWidth()
    end
  end
  w:ApplyFrameStyle()
  w:SetTarget("player")
  w.unableGageAni = true
  return w
end
local playerFrame = CreatePlayerFrame("playerFrame", playerUnitFrame)
function playerFrame:MakeOriginWindowPos()
  if playerFrame == nil then
    return
  end
  playerFrame:RemoveAllAnchors()
  playerFrame:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(5), F_LAYOUT.CalcDontApplyUIScale(10))
end
playerFrame:MakeOriginWindowPos()
playerFrame:Show(true)
ADDON:RegisterContentWidget(UIC_PLAYER_UNITFRAME, playerFrame)
function PlayerFrameLifeAlertEffect(curHp, maxHp)
  if playerFrame == nil then
    return
  end
  if playerFrame.use_effect_texture == false then
    playerFrame.effect_texture:SetStartEffect(false)
    return
  end
  if curHp ~= 0 and curHp < maxHp * 0.3 then
    if playerFrame.effect_texture:IsVisible() == false then
      playerFrame.effect_texture:SetStartEffect(true)
      playerFrame.effect_texture:SetStartEffect(true)
    end
  elseif curHp == 0 then
    playerFrame.effect_texture:SetStartEffect(false)
    playerFrame.effect_texture:SetStartEffect(false)
  else
    playerFrame.effect_texture:SetStartEffect(false)
    playerFrame.effect_texture:SetStartEffect(false)
  end
end
function PlayerLifeAlertEffectVisibleHandler(visible)
  if playerFrame == nil then
    return
  end
  playerFrame.use_effect_texture = visible
end
local OLD_MAIL_COUNT, FIRST_MAIL_COUNT
local UpdateAlarmUnreadMail = function(widget, time)
  local count = X2Mail:GetCountUnreadMail()
  if count < 0 then
    widget:Show(false)
    return
  end
  widget:Show(true)
  widget.effect_texture:SetStartEffect(true)
  F_SOUND.PlayUISound("event_mail_alarm")
end
AddUISaveHandlerByKey("playerFrame", playerFrame)
playerFrame:ApplyLastWindowOffset()
local function UpdateMailAlert_notCreateUI()
  local oldCount = playerFrame.unreadMailcount
  local count = X2Mail:GetCountUnreadMail()
  if oldCount < count then
    UpdateAlarmUnreadMail(playerFrame.alarmUnreadMail)
  elseif oldCount > count then
    if count <= 0 then
      playerFrame.alarmUnreadMail:Show(false)
    else
      playerFrame.alarmUnreadMail.effect_texture:SetStartEffect(false)
    end
  end
  playerFrame:UpdateIconsAnchors()
  playerFrame.unreadMailcount = count
end
function playerFrame:ReFontsizeName()
  local nameWidth = self.name.style:GetTextWidth(self.name:GetText())
  if nameWidth > PLAYER_NAME_WIDTH then
    self.name.style:SetFontSize(FONT_SIZE.SMALL)
  else
    self.name.style:SetFontSize(FONT_SIZE.MIDDLE)
  end
end
local playerFrameEvents = {
  MAIL_INBOX_UPDATE = function(this)
    UpdateMailAlert_notCreateUI()
    this:UpdateNameWidth()
  end,
  ENTERED_WORLD = function(this, firstEnteredWorld)
    this.unableGageAni = true
    local count = X2Mail:GetCountUnreadMail()
    if count > 0 then
      this.alarmUnreadMail:Show(true)
      this.alarmUnreadMail.effect_texture:SetStartEffect(false)
    else
      this.alarmUnreadMail:Show(false)
    end
    this.unreadMailcount = count
    this:ShowReportIcon()
    this:UpdateIconsAnchors()
    this:ReFontsizeName()
    this:UpdateAll()
  end,
  LEFT_LOADING = function(this)
    UpdateMailAlert_notCreateUI()
    this:UpdateCombatIcon()
    this:UpdateLevel()
    this:UpdatePVPIcon()
  end,
  SECOND_PASSWORD_CREATION_COMPLETED = function(this)
    this.secondPasswordButton:SetState()
  end,
  SECOND_PASSWORD_CLEAR_COMPLETED = function(this)
    this.secondPasswordButton:SetState()
  end,
  SECOND_PASSWORD_CHECK_OVER_FAILED = function(this)
    this.secondPasswordButton:SetState()
  end,
  SHOW_HIDDEN_BUFF = function(this)
    this:ShowHiddenBuffWindow()
  end
}
playerFrame:AddOnEvents(playerFrameEvents)
