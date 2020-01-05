local MINIMUM_BUBBLE_WIDTH = 57
local DEFAULT_BUBBLE_WIDTH = 225
local nameTagHeight = 24
function CreateChatBubbleFrame()
  local frame = CreateEmptyWindow("chatBubbleFrame", "UIParent")
  frame:Show(true)
  frame:SetExtent(0, 0)
  frame:AddAnchor("CENTER", "UIParent", 0, 0)
  frame:Clickable(false)
  frame:SetUILayer("game")
  frame.bubbles = {}
  function frame:IsExistSpeakerId(speakerId)
    return self.bubbles[speakerId] ~= nil
  end
  function frame:EraseBubble(speakerId)
    if self:IsExistSpeakerId(speakerId) then
      self.bubbles[speakerId] = nil
      return true
    end
    return false
  end
  function frame:AddBubble(speakerId, isUnit, chatType, showTime)
    if self:IsExistSpeakerId(speakerId) and self.bubbles[speakerId].isUnit == isUnit then
      self.bubbles[speakerId].curTime = 0
      self.bubbles[speakerId].showTime = showTime or 5000
      self.bubbles[speakerId].chatType = chatType or CHAT_SAY
      self.bubbles[speakerId]:SetWidth(DEFAULT_BUBBLE_WIDTH)
      return self.bubbles[speakerId]
    end
    local textbox = frame:CreateChildWidget("textbox", "bubbleTextbox", 0, true)
    textbox:Clickable(false)
    self.bubbles[speakerId] = textbox
    textbox.speakerId = speakerId
    textbox:Show(true)
    textbox.curTime = 0
    textbox.showTime = showTime or 5000
    textbox.chatType = chatType or CHAT_SAY
    textbox.isUnit = isUnit
    if textbox.isUnit then
      textbox.speakerInfo = X2Unit:GetUnitInfoById(speakerId)
    else
      textbox.speakerInfo = X2Unit:GetDoodadInfoById(speakerId)
    end
    textbox:EnableHidingIsRemove(true)
    textbox:SetWidth(DEFAULT_BUBBLE_WIDTH)
    textbox.style:SetAlign(ALIGN_TOP_LEFT)
    textbox.style:SetSnap(true)
    textbox.style:SetShadow(false)
    textbox.style:SetColor(1, 1, 1, 1)
    textbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    local nameTag = W_CTRL.CreateLabel(textbox:GetId() .. ".nameTag", textbox)
    nameTag:Clickable(false)
    nameTag:SetHeight(nameTagHeight)
    nameTag:SetLimitWidth(DEFAULT_BUBBLE_WIDTH)
    nameTag:AddAnchor("BOTTOMLEFT", textbox, "TOPLEFT", 0, 0)
    nameTag:AddAnchor("BOTTOMRIGHT", textbox, "TOPRIGHT", 0, 0)
    nameTag.style:SetAlign(ALIGN_TOP_LEFT)
    nameTag.style:SetShadow(false)
    textbox.nameTag = nameTag
    local tail = textbox:CreateDrawable(TEXTURE_PATH.HUD, "chat_bubble_tail_normal", "overlay")
    tail:SetTextureColor("default")
    textbox.tail = tail
    local bg = textbox:CreateDrawable(TEXTURE_PATH.HUD, "chat_bubble_bg", "background")
    bg:AddAnchor("BOTTOMRIGHT", textbox, 17, 19)
    textbox.bg = bg
    function textbox:SetTailType(tailType)
      if tailType == CBK_NORMAL then
        self.tail:SetExtent(GetTextureInfo(TEXTURE_PATH.HUD, "chat_bubble_tail_normal"):GetExtent())
        self.tail:SetCoords(GetTextureInfo(TEXTURE_PATH.HUD, "chat_bubble_tail_normal"):GetCoords())
        self.tail:AddAnchor("TOP", self.bg, "BOTTOM", 18, -10)
      elseif tailType == CBK_THINK then
        self.tail:SetExtent(GetTextureInfo(TEXTURE_PATH.HUD, "chat_bubble_tail_think"):GetExtent())
        self.tail:SetCoords(GetTextureInfo(TEXTURE_PATH.HUD, "chat_bubble_tail_think"):GetCoords())
        self.tail:AddAnchor("TOP", self.bg, "BOTTOM", 12, -9)
      elseif tailType == CBK_SYSTEM then
        tail:SetExtent(62, 42)
        self.tail:SetCoords(795, 0, 62, 44)
        self.tail:AddAnchor("TOP", self.bg, "BOTTOM", 12, -9)
      end
    end
    textbox:SetTailType(CBK_NORMAL)
    function textbox:AdjustBubbleLayout()
      if self.speakerInfo == nil then
        return
      end
      local myId = X2Unit:GetUnitId("player")
      if myId == self.speakerId then
        self.nameTag:Show(false)
        self.bg:AddAnchor("TOPLEFT", self, -17, -19)
      else
        self.nameTag:Show(true)
        self.bg:AddAnchor("TOPLEFT", self.nameTag, -17, -19)
      end
      local faction = self.speakerInfo.faction
      local tailType = self.speakerInfo.type
      if faction == "hostile" then
        self.nameTag.style:SetColor(0.83, 0.18, 0.18, 1)
      elseif tailType == "character" then
        self.nameTag.style:SetColor(0.67, 0.44, 0, 1)
      elseif tailType == "npc" then
        self.nameTag.style:SetColor(0.23, 0.6, 0.89, 1)
      end
      if self.chatType == CHAT_SAY then
        self.style:SetColor(0.29, 0.2, 0.05, 1)
        if faction == "hostile" then
          self.style:SetColor(0.43, 0.07, 0.03, 1)
        elseif tailType == "character" then
          self.style:SetColor(0.29, 0.2, 0.05, 1)
        elseif tailType == "npc" then
          self.style:SetColor(0.17, 0.2, 0.45, 1)
        end
      elseif self.chatType == CHAT_WHISPER or self.chatType == CHAT_PARTY then
        self.style:SetColor(0, 0, 0, 1)
      else
        self.style:SetColor(0, 0, 0, 1)
      end
      local name = self.nameTag:GetText()
      local nameWidth = self.nameTag.style:GetTextWidth(name)
      local textWidth = self:GetLongestLineWidth()
      local lineCount = self:GetLineCount()
      if lineCount == 1 then
        local width = math.max(nameWidth, textWidth + 10)
        width = math.max(width, MINIMUM_BUBBLE_WIDTH)
        self.nameTag:SetWidth(width)
        self:SetWidth(width)
      end
      local left, top, right, bottom = self:GetInset()
      local height = self:GetTextHeight()
      if height < 15 then
        height = 15
      end
      self:SetHeight(height)
    end
    function textbox:SetChatMsg(name, text, specifyName)
      if name ~= nil then
        self.nameTag:SetText(name)
      end
      if specifyName then
        self:SetText(text, specifyName)
      else
        self:SetText(text)
      end
      self:AdjustBubbleLayout()
    end
    function textbox:OnHide()
      frame:EraseBubble(self.speakerId)
    end
    textbox:SetHandler("OnHide", textbox.OnHide)
    function textbox:OnUpdate(dt)
      local sx, sy, sz
      if self.isUnit then
        sx, sy, sz = X2Unit:GetUnitScreenNameTagOffset(self.speakerId)
      else
        sx, sy, sz = X2Unit:GetDoodadScreenPosition(self.speakerId)
      end
      if sx == nil or sy == nil or sz == nil then
        self:Show(false)
        return
      end
      local bubbleWidth, bubbleHeight = self:GetEffectiveExtent()
      if sx > -bubbleWidth / 2 and sx < UIParent:GetScreenWidth() + bubbleWidth / 2 and sy > bubbleHeight and sy < UIParent:GetScreenHeight() then
        if sz ~= nil and sz > 0 then
          if not self:IsVisible() then
            self:Show(true)
          end
          self:AddAnchor("BOTTOM", "UIParent", "TOPLEFT", math.floor(sx), math.floor(sy) - self.tail:GetHeight())
        else
          self:Show(false)
          return
        end
      else
        self:Show(false)
        return
      end
      if self.curTime < self.showTime then
        self:SetAlpha(1)
      elseif self.curTime < self.showTime + 1000 then
        self:SetAlpha(1 - (self.curTime - self.showTime) / 1000)
      else
        self:Show(false)
        return
      end
      self.curTime = self.curTime + dt
    end
    textbox:SetHandler("OnUpdate", textbox.OnUpdate)
    return textbox
  end
  return frame
end
chatBubbleFrame = CreateChatBubbleFrame()
local OnChatMessage = function(chatType, speakerId, relation, speakerName, message, speakerInChatBound, specifyName, factionName, trialPosition, worldName)
  local show = GetOptionItemValue("ShowChatBubble") == 1
  if show == false then
    return
  end
  if speakerId == 0 then
    return
  end
  if speakerInChatBound == false then
    return
  end
  if chatType == CHAT_SAY or chatType == CHAT_PARTY or chatType == CHAT_RAID or chatType == CHAT_EXPEDITION then
    bubble = chatBubbleFrame:AddBubble(speakerId, true, chatType, 5000)
    bubble:SetChatMsg(speakerName, message, specifyName)
  end
end
local OnChatMsgQuest = function(message, speakerName, speakerId, self, tailType, showTime, fadeTime, currentBubbleType, qtype, forceFinished)
  if X2Quest:IsQuestDirectingMode() == true then
    return
  end
  local show = GetOptionItemValue("ShowChatBubble") == 1
  if show == false then
    return
  end
  if forceFinished then
    return
  end
  local convertMessage = X2Util:ApplyUIMacroString(message, speakerName)
  bubble = chatBubbleFrame:AddBubble(speakerId, true, CHAT_QUEST, showTime or 5000)
  bubble:SetChatMsg(speakerName, convertMessage)
  bubble:SetTailType(tailType)
end
local OnChatMsgDoodad = function(message, speakerName, speakerId, self, tailType, showTime, fadeTime, hasNext, qtype, forceFinished)
  if X2Quest:IsQuestDirectingMode() == true then
    return
  end
  local show = GetOptionItemValue("ShowChatBubble") == 1
  if show == false then
    return
  end
  if forceFinished then
    return
  end
  local convertMessage = X2Util:ApplyUIMacroString(message, speakerName)
  bubble = chatBubbleFrame:AddBubble(speakerId, false, CHAT_QUEST, showTime or 5000)
  bubble:SetChatMsg(speakerName, convertMessage)
  bubble:SetTailType(tailType)
end
local chatBubbleEvents = {
  CHAT_MESSAGE = OnChatMessage,
  CHAT_MSG_QUEST = OnChatMsgQuest,
  CHAT_MSG_DOODAD = OnChatMsgDoodad,
  CHAT_EMOTION = function(message)
    X2Chat:DispatchChatMessage(CMF_EMOTIOIN_EXPRESS, message)
  end
}
chatBubbleFrame:SetHandler("OnEvent", function(this, event, ...)
  chatBubbleEvents[event](...)
end)
chatBubbleFrame:RegisterEvent("CHAT_MESSAGE")
chatBubbleFrame:RegisterEvent("CHAT_MSG_QUEST")
chatBubbleFrame:RegisterEvent("CHAT_MSG_DOODAD")
chatBubbleFrame:RegisterEvent("CHAT_EMOTION")
