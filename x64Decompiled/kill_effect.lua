local killEffect, killEffectSound, specialKillCount, straightKillSoundId
local function CreateKillEffect(id, parent)
  local widget = UIParent:CreateWidget("window", id, parent)
  widget:SetExtent(243, 189)
  widget:AddAnchor("TOP", parent, 0, 60)
  widget:EnableHidingIsRemove(true)
  widget:SetUILayer("system")
  widget:Clickable(false)
  local bottomBg = widget:CreateDrawable(TEXTURE_PATH.KILL_EFFECT_BG, "bg", "background")
  bottomBg:AddAnchor("CENTER", widget, 0, MARGIN.WINDOW_SIDE * 1.5)
  local circleBooldstain = widget:CreateEffectDrawable(TEXTURE_PATH.KILL_EFFECT_FIFTH_BELOW_DECO, "background")
  circleBooldstain:Show(false)
  circleBooldstain:SetCoords(120, 0, 103, 102)
  circleBooldstain:SetExtent(160, 159)
  circleBooldstain:AddAnchor("CENTER", bottomBg, 0, -MARGIN.WINDOW_SIDE * 1.5)
  circleBooldstain:SetRepeatCount(1)
  local verticalBooldstain = widget:CreateEffectDrawable(TEXTURE_PATH.KILL_EFFECT_FIFTH_BELOW_DECO, "background")
  verticalBooldstain:Show(false)
  verticalBooldstain:SetCoords(0, 0, 120, 119)
  verticalBooldstain:SetExtent(134, 133)
  verticalBooldstain:AddAnchor("CENTER", bottomBg, 0, -MARGIN.WINDOW_SIDE * 1.5)
  verticalBooldstain:SetRepeatCount(1)
  local circleFifthKill = widget:CreateEffectDrawable(TEXTURE_PATH.KILL_EFFECT_FIFTH_KILL, "background")
  circleFifthKill:Show(false)
  circleFifthKill:SetCoords(120, 0, 83, 89)
  circleFifthKill:SetExtent(103, 109)
  circleFifthKill:AddAnchor("CENTER", bottomBg, 0, -MARGIN.WINDOW_SIDE * 1.5)
  circleFifthKill:SetRepeatCount(1)
  circleFifthKill:SetMoveRepeatCount(1)
  local warOfGodBg = widget:CreateDrawable(TEXTURE_PATH.KILL_EFFECT_WAR_OF_GOD, "bg", "background")
  warOfGodBg:Show(false)
  warOfGodBg:AddAnchor("CENTER", widget, -MARGIN.WINDOW_SIDE / 2, MARGIN.WINDOW_SIDE)
  local helmet = widget:CreateDrawable(TEXTURE_PATH.KILL_EFFECT_WAR_OF_GOD, "helmet", "artwork")
  helmet:AddAnchor("CENTER", widget, 0, 5)
  local warOfGodLaurel_O = widget:CreateDrawable(TEXTURE_PATH.KILL_EFFECT_WAR_OF_GOD, "deco", "artwork")
  warOfGodLaurel_O:Show(false)
  warOfGodLaurel_O:AddAnchor("BOTTOM", helmet, -MARGIN.WINDOW_SIDE / 2, MARGIN.WINDOW_SIDE / 2)
  local warOfGodLaurel_W = widget:CreateEffectDrawable(TEXTURE_PATH.KILL_EFFECT_WAR_OF_GOD, "artwork")
  warOfGodLaurel_W:Show(false)
  warOfGodLaurel_W:SetCoords(296, 0, 134, 100)
  warOfGodLaurel_W:SetExtent(134, 100)
  warOfGodLaurel_W:AddAnchor("BOTTOM", helmet, -MARGIN.WINDOW_SIDE / 2, MARGIN.WINDOW_SIDE / 2)
  warOfGodLaurel_W:SetRepeatCount(1)
  local textImage = widget:CreateDrawable(TEXTURE_PATH.KILL_EFFECT_FIRST_KILL, "first", "overlay")
  textImage:AddAnchor("BOTTOM", widget, 0, 0)
  widget.textImage = textImage
  local textbox = widget:CreateChildWidget("textbox", "textbox", 0, true)
  textbox:SetExtent(200, FONT_SIZE.LARGE)
  textbox:AddAnchor("TOP", textImage, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 4)
  textbox.style:SetAlign(ALIGN_CENTER)
  textbox.style:SetFontSize(FONT_SIZE.LARGE)
  textbox.style:SetShadow(true)
  widget.killCount = nil
  widget.animState = nil
  local function ResetAllTexture()
    warOfGodBg:Show(false)
    warOfGodLaurel_O:Show(false)
    warOfGodLaurel_W:Show(false)
    verticalBooldstain:Show(false)
    circleBooldstain:Show(false)
    circleFifthKill:Show(false)
    helmet:RemoveAllAnchors()
  end
  local GetTexts = function(count, killerName, victimName, threeKillCount)
    if threeKillCount ~= nil and threeKillCount ~= 0 then
      if threeKillCount % 3 == 1 then
        return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "kill_alarm_text_1", killerName)
      elseif threeKillCount % 3 == 2 then
        return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "kill_alarm_text_2", killerName)
      elseif threeKillCount % 3 == 0 then
        return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "kill_alarm_text_3", killerName)
      end
    else
      return X2Locale:LocalizeUiText(BATTLE_FIELD_TEXT, "kill_alarm_text_4", killerName, victimName)
    end
  end
  function widget:SetKillCountText(count, killerName, victimName, threeKillCount)
    self.textbox:SetTextAutoWidth(1000, GetTexts(count, killerName, victimName, threeKillCount), 10)
    specialKillCount = threeKillCount
  end
  function widget:SetKillCountTexture(count)
    local textureCoords = centerMessageLocale.killEffect.killEffectCoords
    local texturePath = {
      TEXTURE_PATH.KILL_EFFECT_FIRST_KILL,
      TEXTURE_PATH.KILL_EFFECT_FROM_SECOND_TO_FOURTH_KILL,
      TEXTURE_PATH.KILL_EFFECT_FROM_SECOND_TO_FOURTH_KILL,
      TEXTURE_PATH.KILL_EFFECT_FROM_SECOND_TO_FOURTH_KILL,
      TEXTURE_PATH.KILL_EFFECT_FIFTH_KILL,
      TEXTURE_PATH.KILL_EFFECT_WAR_OF_GOD
    }
    local coords = textureCoords[count]
    local path = texturePath[count]
    if count > 6 then
      coords = textureCoords[6]
      if count == 10 and centerMessageLocale.killEffect.killEffectCoords[10] ~= nil then
        coords = centerMessageLocale.killEffect.killEffectCoords[10]
      elseif count == 15 and centerMessageLocale.killEffect.killEffectCoords[15] ~= nil then
        coords = centerMessageLocale.killEffect.killEffectCoords[15]
      end
      path = texturePath[6]
    end
    self.textImage:SetTexture(path)
    self.textImage:SetCoords(coords[1], coords[2], coords[3], coords[4])
    self.textImage:SetExtent(coords[3], coords[4])
    self:SetAlphaAnimation(0, 1, 0.3, 0.2)
    self:SetStartAnimation(true, false)
    self.textbox:SetAlphaAnimation(0, 1, 0.5, 0.4)
    self.textbox:SetStartAnimation(true, false)
    self.killCount = count
    ResetAllTexture()
    helmet:SetTexture(path)
    if count >= 6 then
      warOfGodBg:Show(true)
      warOfGodLaurel_O:Show(true)
      helmet:SetCoords(154, 0, 142, 136)
      helmet:SetExtent(142, 136)
      helmet:AddAnchor("CENTER", self, 0, -MARGIN.WINDOW_SIDE / 2)
    else
      helmet:RemoveAllAnchors()
      if count == 1 then
        helmet:SetCoords(0, 0, 100, 108)
        helmet:SetExtent(104, 112)
        helmet:AddAnchor("CENTER", self, 0, 5)
      elseif count == 2 then
        helmet:SetCoords(0, 0, 148, 84)
        helmet:SetExtent(148, 84)
        helmet:AddAnchor("CENTER", self, 0, 5)
      elseif count == 3 then
        helmet:SetCoords(0, 0, 221, 84)
        helmet:SetExtent(221, 84)
        helmet:AddAnchor("CENTER", self, 0, 5)
      elseif count == 4 then
        helmet:SetCoords(0, 0, 297, 84)
        helmet:SetExtent(297, 84)
        helmet:AddAnchor("CENTER", self, 0, 5)
      elseif count == 5 then
        helmet:SetCoords(0, 0, 120, 121)
        helmet:SetExtent(134, 136)
        helmet:AddAnchor("CENTER", self, 0, -MARGIN.WINDOW_SIDE / 2)
      end
    end
  end
  function widget:SetKillCountSound(count)
    local soundTable = {
      "battlefield_kill_first",
      "battlefield_kill_second",
      "battlefield_kill_third",
      "battlefield_kill_fourth",
      "battlefield_kill_fifth",
      "battlefield_kill_more_than_sixth"
    }
    if count > 6 then
      count = 6
    end
    straightKillSoundId = F_SOUND.PlayUISound(soundTable[count], false)
  end
  local function SetKillCountVisibleEffect(count)
    if count >= 6 then
      warOfGodLaurel_W:SetVisible(true)
      warOfGodLaurel_W:SetEffectPriority(1, "alpha", 0.2, 0.1)
      warOfGodLaurel_W:SetEffectInitialColor(1, 1, 1, 1, 0)
      warOfGodLaurel_W:SetEffectFinalColor(1, 1, 1, 1, 1)
      warOfGodLaurel_W:SetEffectPriority(2, "alpha", 0.2, 0.1)
      warOfGodLaurel_W:SetEffectInitialColor(2, 1, 1, 1, 1)
      warOfGodLaurel_W:SetEffectFinalColor(2, 1, 1, 1, 0)
      warOfGodLaurel_W:SetStartEffect(true)
    else
      verticalBooldstain:SetVisible(true)
      verticalBooldstain:SetEffectPriority(1, "alpha", 0.1, 0.05)
      verticalBooldstain:SetEffectInitialColor(1, ConvertColor(224), 0, 0, 0)
      verticalBooldstain:SetEffectFinalColor(1, ConvertColor(224), 0, 0, 1)
      circleBooldstain:SetVisible(true)
      circleBooldstain:SetEffectPriority(1, "alpha", 0.1, 0.05)
      circleBooldstain:SetEffectInitialColor(1, ConvertColor(89), ConvertColor(26), ConvertColor(26), 0)
      circleBooldstain:SetEffectFinalColor(1, ConvertColor(89), ConvertColor(26), ConvertColor(26), 1)
      verticalBooldstain:SetStartEffect(true)
      circleBooldstain:SetStartEffect(true)
      if count == 1 then
        local coords = centerMessageLocale.killEffect.firstKilBloodlHelmetCoords
        helmet:SetCoords(coords[1], coords[2], coords[3], coords[4])
        helmet:SetTexture(TEXTURE_PATH.KILL_EFFECT_FIRST_KILL)
        helmet:SetExtent(104, 112)
      elseif count == 5 then
        circleFifthKill:SetVisible(true)
        circleFifthKill:SetMoveEffectType(1, "circle", 0, 0, 0.3, 0.2)
        circleFifthKill:SetMoveEffectCircle(1, 0, -40)
        circleFifthKill:SetEffectPriority(1, "colorr", 0.3, 0.2)
        circleFifthKill:SetEffectInitialColor(1, 1, 1, 1, 1)
        circleFifthKill:SetEffectFinalColor(1, ConvertColor(182), 0, 0, 1)
        circleFifthKill:SetStartEffect(true)
        verticalBooldstain:SetInterval(0.1)
        circleBooldstain:SetInterval(0.1)
      end
    end
  end
  local function SetKillCountUnvisibleEffect(count)
    if count < 6 then
      verticalBooldstain:SetVisible(false)
      circleBooldstain:SetVisible(false)
      if count == 5 then
        circleFifthKill:SetVisible(false)
      end
    else
      warOfGodBg:SetVisible(false)
    end
  end
  local isPlay = false
  local visibleTime
  local function OnAlphaAnimeEnd(self)
    if self.killCount == nil then
      return
    end
    SetKillCountVisibleEffect(self.killCount)
    if self.animState == "end_anim_end" then
      self:Show(false)
      self.animState = nil
      self.killCount = nil
    end
    visibleTime = 0
  end
  widget:SetHandler("OnAlphaAnimeEnd", OnAlphaAnimeEnd)
  local function FadeAwayEffectWidget(self, dt)
    if visibleTime == nil then
      return
    end
    if visibleTime ~= nil then
      visibleTime = visibleTime + dt
    end
    if self.animState == nil and visibleTime >= 800 then
      SetKillCountUnvisibleEffect(self.killCount)
      self.animState = "end_anim_end"
      self:SetAlphaAnimation(1, 0, 0.5, 0.4)
      self:SetStartAnimation(true, false)
      visibleTime = nil
    end
  end
  widget:SetHandler("OnUpdate", FadeAwayEffectWidget)
  local function OnHide()
    widget:ReleaseHandler("OnUpdate")
  end
  widget:SetHandler("OnHide", OnHide)
  local function OnEndFadeOut()
    killEffect = nil
    StartNextImgEvent()
  end
  widget:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return widget
end
local specialKillSoundId
local function CreateKillSoundWidget(id, parent)
  local widget = UIParent:CreateWidget("window", id, parent)
  widget:SetExtent(1, 1)
  widget:AddAnchor("TOP", "UIParent", 0, -1)
  widget:EnableHidingIsRemove(true)
  widget:SetUILayer("game")
  local PlayThreeKillCountSound = function(threeKillCount)
    local sound
    if threeKillCount % 3 == 1 then
      sound = "battlefield_kill_eyes_on_fire"
    elseif threeKillCount % 3 == 2 then
      sound = "battlefield_kill_amazing_spirit"
    elseif threeKillCount % 3 == 0 then
      sound = "battlefield_kill_destruction_god"
    end
    if sound == nil then
      return
    end
    return F_SOUND.PlayUISound(sound, false)
  end
  local specialKillSoundPlayed = false
  local function OnUpdate(self, dt)
    if straightKillSoundId == nil then
      return
    end
    if specialKillCount == nil or specialKillCount == 0 then
      self:Show(false)
      return
    end
    if specialKillSoundPlayed and not X2Sound:IsPlaying(specialKillSoundId) then
      self:Show(false)
      return
    end
    local isPlaying = X2Sound:IsPlaying(straightKillSoundId)
    if not specialKillSoundPlayed and not isPlaying then
      specialKillSoundPlayed = true
      specialKillSoundId = PlayThreeKillCountSound(specialKillCount)
    end
  end
  widget:SetHandler("OnUpdate", OnUpdate)
  local function OnHide()
    X2BattleField:EndKillStreakSound()
    killEffectSound = nil
    straightKillSoundId = nil
    widget:ReleaseHandler("OnUpdate")
  end
  widget:SetHandler("OnHide", OnHide)
  return widget
end
function ShowKillEffectSound()
  if killEffectSound == nil then
    killEffectSound = CreateKillSoundWidget("killEffectSound", "UIParent")
  end
  killEffectSound:Show(true)
end
function ShowKillEffect(killStreak, killerName, victimName, threeKillCount)
  if killStreak <= 0 or killStreak == nil then
    UIParent:LogAlways(string.format("invalid count, KName : %s", killerName or "nil"))
    return false
  end
  if killEffect == nil then
    killEffect = CreateKillEffect("killEffect", "UIParent")
  end
  killEffect:Show(true)
  ShowKillEffectSound()
  killEffect:SetKillCountTexture(killStreak)
  killEffect:SetKillCountSound(killStreak)
  killEffect:SetKillCountText(killStreak, killerName, victimName, threeKillCount)
  return true
end
