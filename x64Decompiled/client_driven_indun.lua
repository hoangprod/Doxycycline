local soundId = 0
local nowSceneId = 0
local oldNowCount = 0
clientDrivenEventListener = UIParent:CreateWidget("emptywidget", "clientDrivenEventListener", "UIParent")
clientDrivenEventListener:Show(false)
local UpdateContentImg = function(sceneId, childSceneId, widget)
  local strKey = string.format("%d_%d", sceneId, childSceneId)
  for i = 1, #widget.imgFrame do
    local imgFrame = widget.imgFrame[i]
    local imgInfo = CLIENT_DRIVEN_WIDGET.CONTENTS_IMG[strKey]
    imgFrame:Show(false)
    if imgFrame.img then
      imgFrame.img:Show(false)
    end
    if imgInfo and imgInfo[i] then
      if imgFrame.img == nil then
        imgFrame.img = widget:CreateDrawable(imgInfo[i].path, imgInfo[i].key, "overlay")
      else
        imgFrame.img:SetTexture(imgInfo[i].path)
      end
      imgFrame.img:SetTextureInfo(imgInfo[i].key)
      imgFrame.img:AddAnchor("TOPLEFT", imgFrame, (i - 1) * imgFrame.img:GetWidth(), 20)
      imgFrame.img:SetColor(1, 1, 1, 0.8)
      imgFrame:RemoveAllAnchors()
      local w, h = imgFrame.img:GetExtent()
      imgFrame:SetExtent(w, h)
      imgFrame:AddAnchor("TOPLEFT", widget, 20, 0)
      imgFrame:Show(true)
      imgFrame.img:Show(true)
    end
  end
end
local UpdateMsgText = function(widget, msg)
  widget.msg:SetText(GetCommonText(msg))
  widget:Show(string.len(msg) > 0)
  if widget.imgFrame == nil then
    return
  end
  widget.msg:RemoveAllAnchors()
  if widget.imgFrame[1]:IsVisible() then
    widget.msg:AddAnchor("TOPLEFT", widget.imgFrame[1], "BOTTOMLEFT", 10, 30)
  else
    widget.msg:AddAnchor("LEFT", widget, "LEFT", 10, -10)
  end
end
local UpdateBgExtent = function(widget)
  widget.bg:RemoveAllAnchors()
  widget.bg:AddAnchor("TOPLEFT", widget, "TOPLEFT", -20, 0)
  widget.bg:AddAnchor("BOTTOMRIGHT", widget.msg, 50, 50)
end
local function UpdateCDGuideMsg(sceneId, childSceneId, title, contents)
  UpdateMsgText(clientDrivenTitle, title)
  UpdateContentImg(sceneId, childSceneId, clientDrivenContents)
  UpdateMsgText(clientDrivenContents, contents)
  UpdateBgExtent(clientDrivenContents)
end
local function UpdateCDQuestObjectiveMsg(qType)
  local msg = ""
  if X2Quest:GetFirstObjectiveCount(qType) > 0 then
    local objectives = GetQuestObjectives(1, qType)
    if objectives then
      msg = objectives[1]
    end
  end
  if msg == nil then
    msg = ""
  end
  clientDrivenTitle.objectiveMsg:SetText(msg)
  local objectiveInfo = X2Quest:GetQuestJournalObjectiveTextByType(qType, 1)
  if objectiveInfo == nil then
    return
  end
  local nowCount = objectiveInfo.done
  local maxCount = objectiveInfo.max
  if nowCount == nil or maxCount == nil or nowCount == 0 or maxCount == 0 then
    return
  end
  if oldNowCount == nowCount then
    return
  end
  oldNowCount = nowCount
  clientDrivenTitle.objectiveImg:UpdateImg(nowSceneId, nowCount, maxCount)
end
function CreateClientDrivenIndunWidget()
  local titleWidget, contentsWidget, exitBtn = SetViewOfClientDrivenWidget()
  return titleWidget, contentsWidget, exitBtn
end
clientDrivenTitle, clientDrivenContents, clientDrivenExitBtn = CreateClientDrivenIndunWidget()
ADDON:RegisterContentWidget(UIC_CLIENT_DIRVEN_TITLE, clientDrivenTitle)
ADDON:RegisterContentWidget(UIC_CLIENT_DIRVEN_CONTENTS, clientDrivenContents)
ADDON:RegisterContentWidget(UIC_CLIENT_DRIVEN_EXIT_BTN, clientDrivenExitBtn)
local clientDrivenEvents = {
  UPDATE_CLIENT_DRIVEN_INFO = function(sceneInfo)
    nowSceneId = sceneInfo.sceneId
    UpdateCDGuideMsg(nowSceneId, sceneInfo.childeSceneId + 1, sceneInfo.title, sceneInfo.contents)
    UpdateCDQuestObjectiveMsg(sceneInfo.qType)
    F_SOUND:StopSound(soundId)
    soundId = F_SOUND.PlayUISound(sceneInfo.soundKey, false)
  end,
  QUEST_CONTEXT_UPDATED = function(qType, status)
    if X2:IsInClientDrivenZone() == true then
      UpdateCDQuestObjectiveMsg(qType)
    end
  end
}
clientDrivenEventListener:SetHandler("OnEvent", function(this, event, ...)
  clientDrivenEvents[event](...)
end)
RegistUIEvent(clientDrivenEventListener, clientDrivenEvents)
