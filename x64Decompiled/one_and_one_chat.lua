local colorSys = FONT_COLOR_HEX.RED
local colorGm = FONT_COLOR_HEX.BLUE
local colorDefault = FONT_COLOR_HEX.BLACK
function ReloadOneAndOneChatWindows()
  local data = X2OneAndOneChat:GetChatDataList()
  if data == nil then
    return
  end
  for i = 1, #data do
    local channelId = data[i].id
    local messages = data[i].messages
    local targetName = data[i].targetName
    newWindow = CreateOneAndOneChat(channelId, targetName)
    for i = 1, #messages do
      local message = messages[i]
      local colorType = 0
      if message.isGm then
        colorType = 1
      end
      newWindow:AddMessage(colorType, message.speakerName, message.message)
    end
    newWindow:Show(true)
  end
end
function CreateOneAndOneChat(channelId, targetName)
  local window = SetViewOfOneAndOneChatWindow("OneAndOneChat" .. channelId, "UIParent")
  local titleStr = string.format(GetUIText(COMMON_TEXT, "one_and_one_chat_title"), targetName)
  window:SetTitle(titleStr)
  window.targetName = targetName
  window.channelId = channelId
  function window:UpdateScroll()
    local totalLine = window.content:GetMessageLines()
    local currentLine = window.content:GetCurrentScroll()
    local pageMaxLine = window.content:GetPagePerMaxLines()
    window.scrollBar:SetScroll(totalLine, currentLine, pageMaxLine)
  end
  function window:AddMessage(colorType, speaker, message)
    local nameColor = colorDefault
    if colorType == -1 then
      nameColor = colorSys
    elseif colorType == 1 then
      nameColor = colorGm
    end
    local str = string.format("%s[%s]%s : %s", nameColor, speaker, colorDefault, message)
    window.content:AddMessage(str)
    window:UpdateScroll()
  end
  function window:OnClose()
    X2OneAndOneChat:OnChatClosed(channelId)
  end
  function window.editbox:OnEnterPressed()
    X2OneAndOneChat:OnChatEntered(channelId, window.editbox:GetText())
    window.editbox:SetText("")
  end
  window.editbox:SetHandler("OnEnterPressed", window.editbox.OnEnterPressed)
  local OnEnter = function(self)
    self:SetAlpha(activateAlphaValue)
  end
  window:SetHandler("OnEnter", OnEnter)
  local OnLeave = function(self)
    self:SetAlpha(inactivateAlphaValue)
  end
  window:SetHandler("OnLeave", OnLeave)
  local events = {
    ONE_AND_ONE_CHAT_END = function(channelId)
      if window.channelId ~= channelId then
        return
      end
      local msg = string.format(GetUIText(COMMON_TEXT, "one_and_one_chat_end"), window.targetName)
      window:AddMessage(-1, "SYSTEM", msg)
      window.editbox:SetReadOnly(true)
    end,
    ONE_AND_ONE_CHAT_ADD_MESSAGE = function(channelId, speakerName, message, isSpeakerGm)
      if window.channelId ~= channelId then
        return
      end
      local colorType = 0
      if isSpeakerGm then
        colorType = 1
      end
      window:AddMessage(colorType, speakerName, message)
      window:SetAlpha(activateAlphaValue)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  local msg = string.format(GetUIText(COMMON_TEXT, "one_and_one_chat_start"), targetName)
  window:AddMessage(-1, "SYSTEM", msg)
  return window
end
UIParent:SetEventHandler("ONE_AND_ONE_CHAT_START", CreateOneAndOneChat)
ReloadOneAndOneChatWindows()
