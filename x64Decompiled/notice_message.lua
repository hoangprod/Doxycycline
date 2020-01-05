local MAX_LINE = 1
local FADE_DEFAULT_TIME = 3000
function CreateNoticeWindow(id, parent)
  local msgWnd = UIParent:CreateWidget("message", id, parent)
  msgWnd.style:SetAlign(ALIGN_CENTER)
  msgWnd.style:SetSnap(true)
  msgWnd.style:SetShadow(true)
  msgWnd:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  msgWnd.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  msgWnd.style:SetColor(ConvertColor(255), ConvertColor(245), ConvertColor(93), 1)
  msgWnd:SetTimeVisible(3)
  msgWnd:SetMaxLines(MAX_LINE)
  return msgWnd
end
noticeWindow = CreateNoticeWindow("noticeWindow", systemLayerParent)
noticeWindow:SetExtent(UIParent:GetScreenWidth(), noticeWindow.style:GetLineHeight())
noticeWindow:AddAnchor("TOP", "UIParent", "TOP", 0, 235)
noticeWindowBack = noticeWindow:CreateColorDrawable(1, 1, 0, 0, "background")
noticeWindowBack:AddAnchor("TOPLEFT", noticeWindow, 0, 0)
noticeWindowBack:AddAnchor("BOTTOMRIGHT", noticeWindow, 0, 0)
noticeWindow:Show(false)
noticeWindow:Clickable(false)
noticeWindow.msgQueue = {}
function noticeWindow:AddMessageToQueue(msg, originalTime, needCountdown)
  if originalTime == nil then
    originalTime = 3000
  end
  local visibleTime = originalTime + FADE_DEFAULT_TIME
  local displayMsg = msg
  if needCountdown == true and originalTime > 0 then
    output = math.floor(originalTime / 1000 + 0.5)
    displayMsg = string.format(msg, output)
  end
  local msgInfo = {
    text = displayMsg,
    calcTime = visibleTime,
    originalTime = originalTime,
    foramt = msg,
    needCountdown = needCountdown
  }
  table.insert(self.msgQueue, msgInfo)
  if self:HasHandler("OnUpdate") == false then
    self:Show(true)
    self:SetHandler("OnUpdate", self.OnUpdate)
  end
end
function noticeWindow:GetMessageFromQueue()
  if #noticeWindow.msgQueue == 0 then
    return nil
  end
  local msgInfo = noticeWindow.msgQueue[1]
  table.remove(noticeWindow.msgQueue, 1)
  return msgInfo
end
local elapsedTime = 0
local nowOutputMsg
function noticeWindow:OnUpdate(dt)
  elapsedTime = elapsedTime + dt
  if nowOutputMsg == nil or nowOutputMsg.calcTime <= elapsedTime then
    elapsedTime = 0
    nowOutputMsg = self:GetMessageFromQueue()
    if nowOutputMsg ~= nil then
      X2Chat:DispatchChatMessage(CMF_NOTICE, nowOutputMsg.text)
      self:AddMessageEx(nowOutputMsg.text, nowOutputMsg.originalTime)
      self:Raise()
    else
      nowOutputMsg = nil
      self:Show(false)
      self:ReleaseHandler("OnUpdate")
      return
    end
  elseif nowOutputMsg.needCountdown == true and nowOutputMsg.originalTime >= elapsedTime then
    output = math.floor((nowOutputMsg.originalTime - elapsedTime) / 1000 + 0.5)
    local displayMsg = string.format(nowOutputMsg.foramt, output)
    if displayMsg ~= nowOutputMsg.text then
      X2Chat:DispatchChatMessage(CMF_NOTICE, displayMsg)
      self:AddMessageRefresh(displayMsg)
      nowOutputMsg.text = displayMsg
    end
  end
end
