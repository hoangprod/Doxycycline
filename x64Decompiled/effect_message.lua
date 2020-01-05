local WND_WIDTH = 300
local WND_HEIGHT = 153
local SHOW_TIME = 800
function CreateEffectMsgWindow(id, parent)
  local msgWnd = UIParent:CreateWidget("emptywidget", id, parent)
  msgWnd:SetExtent(WND_WIDTH, WND_HEIGHT)
  msgWnd:AddAnchor("TOP", "UIParent", 0, 35)
  local OnEndFadeOut = function(self)
    StartNextImgEvent()
  end
  msgWnd:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return msgWnd
end
local delay = 1
local function Setting_levelup_effect(msgWnd, level_text)
  if msgWnd.levelup_wing_texture == nil then
    local levelup_wing_texture = msgWnd:CreateEffectDrawable(TEXTURE_PATH.LEVLE_UP, "background")
    levelup_wing_texture:SetCoords(0, 0, 123, 135)
    levelup_wing_texture:SetExtent(123, 135)
    levelup_wing_texture:AddAnchor("CENTER", msgWnd, 0, 0)
    levelup_wing_texture:SetRepeatCount(1)
    levelup_wing_texture:SetEffectPriority(1, "alpha", 0, 0)
    levelup_wing_texture:SetEffectScale(1, 1.1, 1.1, 1.1, 1.1)
    levelup_wing_texture:SetEffectInitialColor(1, 1, 1, 1, 0)
    levelup_wing_texture:SetEffectFinalColor(1, 1, 1, 1, 0)
    levelup_wing_texture:SetEffectPriority(2, "alpha", 0.9, 0.8)
    levelup_wing_texture:SetEffectInitialColor(2, 1, 1, 1, 0)
    levelup_wing_texture:SetEffectFinalColor(2, 1, 1, 1, 1)
    levelup_wing_texture:SetEffectScale(2, 1.1, 0.9, 1.1, 0.9)
    levelup_wing_texture:SetEffectInterval(2, 2.4)
    levelup_wing_texture:SetEffectPriority(3, "alpha", 1 + delay, 0.9 + delay)
    levelup_wing_texture:SetEffectScale(3, 0.9, 0.9, 0.9, 0.9)
    levelup_wing_texture:SetEffectInitialColor(3, 1, 1, 1, 1)
    levelup_wing_texture:SetEffectFinalColor(3, 1, 1, 1, 0)
    msgWnd.levelup_wing_texture = levelup_wing_texture
  end
  if msgWnd.levelup_rotate_texture == nil then
    local levelup_rotate_texture = msgWnd:CreateEffectDrawable(TEXTURE_PATH.LEVLE_UP, "background")
    levelup_rotate_texture:SetCoords(123, 0, 132, 114)
    levelup_rotate_texture:SetExtent(132, 114)
    levelup_rotate_texture:AddAnchor("CENTER", msgWnd, -3, 0)
    levelup_rotate_texture:SetRepeatCount(1)
    levelup_rotate_texture:SetInterval(1.3)
    levelup_rotate_texture:SetEffectPriority(1, "rotate", 1, 0.9)
    levelup_rotate_texture:SetEffectRotate(1, 0, 360)
    levelup_rotate_texture:SetEffectScale(1, 0.5, 1, 0.5, 1)
    levelup_rotate_texture:SetEffectInitialColor(1, 1, 1, 1, 0)
    levelup_rotate_texture:SetEffectFinalColor(1, 1, 1, 1, 1)
    levelup_rotate_texture:SetEffectPriority(2, "rotate", 0.6 + delay, 0.5 + delay)
    levelup_rotate_texture:SetEffectRotate(2, 0, 15)
    levelup_rotate_texture:SetEffectScale(2, 1, 1.3, 1, 1.3)
    levelup_rotate_texture:SetEffectInitialColor(2, 1, 1, 1, 1)
    levelup_rotate_texture:SetEffectFinalColor(2, 1, 1, 1, 0)
    msgWnd.levelup_rotate_texture = levelup_rotate_texture
  end
  if msgWnd.levelup_shield_texture == nil then
    local levelup_shield_texture = msgWnd:CreateEffectDrawable(TEXTURE_PATH.LEVLE_UP, "background")
    levelup_shield_texture:SetCoords(0, 135, 111, 105)
    levelup_shield_texture:SetExtent(111, 105)
    levelup_shield_texture:AddAnchor("CENTER", msgWnd, 0, 2)
    levelup_shield_texture:SetRepeatCount(1)
    levelup_shield_texture:SetInterval(0.5)
    local max_size = 0.9
    levelup_shield_texture:SetEffectPriority(1, "alpha", 0.8, 0.7)
    levelup_shield_texture:SetEffectScale(1, 0.7, max_size, 0.7, max_size)
    levelup_shield_texture:SetEffectInitialColor(1, 1, 1, 1, 0)
    levelup_shield_texture:SetEffectFinalColor(1, 1, 1, 1, 1)
    levelup_shield_texture:SetEffectPriority(2, "scalex", 0.4, 0.3)
    levelup_shield_texture:SetEffectScale(2, max_size, 0.8, max_size, 0.8)
    levelup_shield_texture:SetEffectInterval(2, 1.6)
    levelup_shield_texture:SetEffectPriority(3, "alpha", 1 + delay, 0.9 + delay)
    levelup_shield_texture:SetEffectScale(3, 0.8, 0.8, 0.8, 0.8)
    levelup_shield_texture:SetEffectInitialColor(3, 1, 1, 1, 1)
    levelup_shield_texture:SetEffectFinalColor(3, 1, 1, 1, 0)
    msgWnd.levelup_shield_texture = levelup_shield_texture
  end
  if msgWnd.text_bg == nil then
    local text_bg = msgWnd:CreateEffectDrawable(TEXTURE_PATH.LEVLE_UP, "background")
    text_bg:SetCoords(111, 135, 145, 31)
    text_bg:SetExtent(334, 40)
    text_bg:SetInset(69, 16, 75, 14)
    text_bg:SetInternalDrawType("ninepart")
    text_bg:SetRepeatCount(1)
    text_bg:SetInterval(0.8)
    text_bg:SetEffectPriority(1, "alpha", 0.5, 0.4)
    text_bg:SetEffectInitialColor(1, 1, 1, 1, 0)
    text_bg:SetEffectFinalColor(1, 1, 1, 1, 0.8)
    text_bg:SetEffectInterval(1, 1.9)
    text_bg:SetEffectPriority(2, "alpha", 0.7 + delay, 0.6 + delay)
    text_bg:SetEffectInitialColor(2, 1, 1, 1, 0.8)
    text_bg:SetEffectFinalColor(2, 1, 1, 1, 0)
    msgWnd.text_bg = text_bg
  end
  if msgWnd.content_frame == nil then
    local content_frame = msgWnd:CreateChildWidget("emptywidget", "content_frame", 0, true)
    content_frame:Show(false)
    content_frame:SetExtent(334, 31)
    content_frame:AddAnchor("BOTTOM", msgWnd, 0, 0)
    msgWnd.text_bg:AddAnchor("CENTER", content_frame, 0, 0)
    local text = content_frame:CreateChildWidget("label", "text", 0, true)
    text:SetAutoResize(true)
    text:SetHeight(FONT_SIZE.XXLARGE)
    text:AddAnchor("CENTER", content_frame, 0, 0)
    text.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
    ApplyTextColor(text, FONT_COLOR.LEVEL_UP_BLUE)
  end
  msgWnd.startEffect = false
  msgWnd.effectCount = 0
  msgWnd.content_frame.text:SetText(level_text)
  msgWnd.showingTime = 0
  msgWnd:SetHandler("OnUpdate", msgWnd.OnUpdate)
end
effectMsgWindow = CreateEffectMsgWindow("effectMsgWindow", systemLayerParent)
effectMsgWindow:Show(true)
effectMsgWindow:Clickable(false)
local function Setting_Heir_levelup_effect(msgWnd, level_text)
  if msgWnd.levelup_shield_texture == nil then
    local levelup_shield_texture = msgWnd:CreateEffectDrawable(TEXTURE_PATH.HEIR_LEVEL_UP, "background")
    levelup_shield_texture:SetCoords(0, 0, 231, 164)
    levelup_shield_texture:SetExtent(231, 164)
    levelup_shield_texture:AddAnchor("CENTER", msgWnd, 0, 2)
    levelup_shield_texture:SetRepeatCount(1)
    levelup_shield_texture:SetInterval(0.5)
    levelup_shield_texture:SetEffectPriority(1, "alpha", 0.8, 0.7)
    levelup_shield_texture:SetEffectInitialColor(1, 1, 1, 1, 0)
    levelup_shield_texture:SetEffectFinalColor(1, 1, 1, 1, 1)
    levelup_shield_texture:SetEffectPriority(2, "scalex", 0.4, 0.3)
    levelup_shield_texture:SetEffectInterval(2, 1.6)
    levelup_shield_texture:SetEffectPriority(3, "alpha", 1 + delay, 0.9 + delay)
    levelup_shield_texture:SetEffectInitialColor(3, 1, 1, 1, 1)
    levelup_shield_texture:SetEffectFinalColor(3, 1, 1, 1, 0)
    msgWnd.levelup_shield_texture = levelup_shield_texture
  end
  if msgWnd.text_bg == nil then
    local text_bg = msgWnd:CreateEffectDrawable(TEXTURE_PATH.LEVLE_UP, "background")
    text_bg:SetCoords(111, 135, 145, 31)
    text_bg:SetExtent(334, 40)
    text_bg:SetInset(69, 16, 75, 14)
    text_bg:SetInternalDrawType("ninepart")
    text_bg:SetRepeatCount(1)
    text_bg:SetInterval(0.8)
    text_bg:SetEffectPriority(1, "alpha", 0.5, 0.4)
    text_bg:SetEffectInitialColor(1, 1, 1, 1, 0)
    text_bg:SetEffectFinalColor(1, 1, 1, 1, 0.8)
    text_bg:SetEffectInterval(1, 1.9)
    text_bg:SetEffectPriority(2, "alpha", 0.7 + delay, 0.6 + delay)
    text_bg:SetEffectInitialColor(2, 1, 1, 1, 0.8)
    text_bg:SetEffectFinalColor(2, 1, 1, 1, 0)
    msgWnd.text_bg = text_bg
  end
  if msgWnd.content_frame == nil then
    local content_frame = msgWnd:CreateChildWidget("emptywidget", "content_frame", 0, true)
    content_frame:Show(false)
    content_frame:SetExtent(334, 31)
    content_frame:AddAnchor("BOTTOM", msgWnd, 0, 30)
    msgWnd.text_bg:AddAnchor("CENTER", content_frame, 0, 0)
    local text = content_frame:CreateChildWidget("label", "text", 0, true)
    text:SetAutoResize(true)
    text:SetHeight(FONT_SIZE.XXLARGE)
    text:AddAnchor("CENTER", content_frame, 0, 0)
    text.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
    ApplyTextColor(text, FONT_COLOR.LEVEL_UP_BLUE)
  end
  msgWnd.startEffect = false
  msgWnd.effectCount = 0
  msgWnd.content_frame.text:SetText(level_text)
  msgWnd.showingTime = 0
  msgWnd:SetHandler("OnUpdate", msgWnd.OnUpdate)
end
local heirEffectMsgWindow = CreateEffectMsgWindow("effectHeirMsgWindow", systemLayerParent)
heirEffectMsgWindow:Show(true)
heirEffectMsgWindow:Clickable(false)
function effectMsgWindow:OnUpdate(dt)
  if Movie:GetNumOfPlayingCutscenes() > 0 then
    if self.content_frame:IsVisible() then
      self.content_frame:Show(false)
    else
      self.content_frame:Show(true)
      self.content_frame:Show(false)
    end
    self.showingTime = 0
    self.startEffect = false
    return
  end
  self.showingTime = dt + self.showingTime
  if not self.startEffect then
    if self.effectCount >= 1 then
      self.effectCount = 0
      self:Show(false)
      return
    end
    self.effectCount = self.effectCount + 1
    self.levelup_wing_texture:SetStartEffect(true)
    self.levelup_shield_texture:SetStartEffect(true)
    self.levelup_rotate_texture:SetStartEffect(true)
    self.text_bg:SetStartEffect(true)
    self.startEffect = true
  end
  local t = self.showingTime / SHOW_TIME
  if t > 1 then
    self.content_frame:Show(true, 700)
  end
  if t > 3.5 then
    self.content_frame:Show(false, 700)
    self:Show(false, 700)
  end
end
function heirEffectMsgWindow:OnUpdate(dt)
  if Movie:GetNumOfPlayingCutscenes() > 0 then
    if self.content_frame:IsVisible() then
      self.content_frame:Show(false)
    else
      self.content_frame:Show(true)
      self.content_frame:Show(false)
    end
    self.showingTime = 0
    self.startEffect = false
    return
  end
  self.showingTime = dt + self.showingTime
  if not self.startEffect then
    if self.effectCount >= 1 then
      self.effectCount = 0
      self:Show(false)
      return
    end
    self.effectCount = self.effectCount + 1
    self.levelup_shield_texture:SetStartEffect(true)
    self.text_bg:SetStartEffect(true)
    self.startEffect = true
  end
  local t = self.showingTime / SHOW_TIME
  if t > 1 then
    self.content_frame:Show(true, 700)
  end
  if t > 3.5 then
    self.content_frame:Show(false, 700)
    self:Show(false, 700)
  end
end
function ShowEffectMsgMessage(msgInfo)
  if msgInfo.type == "levelup" then
    effectMsgWindow:Show(true)
    Setting_levelup_effect(effectMsgWindow, msgInfo.msg)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, msgInfo.msg)
  end
  if msgInfo.type == "heir_levelup" then
    heirEffectMsgWindow:Show(true)
    Setting_Heir_levelup_effect(heirEffectMsgWindow, msgInfo.msg)
    X2Chat:DispatchChatMessage(CMF_SYSTEM, msgInfo.msg)
  end
  return true
end
function ll()
  effectMsgWindow:Show(true)
  Setting_levelup_effect(effectMsgWindow, "level")
  X2Chat:DispatchChatMessage(CMF_SYSTEM, "level")
end
function pp()
  heirEffectMsgWindow:Show(true)
  Setting_Heir_levelup_effect(heirEffectMsgWindow, "heir")
  X2Chat:DispatchChatMessage(CMF_SYSTEM, "heir")
end
