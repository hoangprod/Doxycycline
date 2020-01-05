tutorial = {eventHandler = nil, window = nil}
tutorial.eventHandler = UIParent:CreateWidget("emptywidget", "tutorialEventListener", "UIParent")
tutorial.eventHandler:Show(false)
soundId = 0
function split(str, delimeter)
  local res = {}
  local index = 1
  local initPos = 1
  while true do
    local findPos = string.find(str, delimeter, initPos)
    if findPos == nil then
      res[index] = string.sub(str, initPos)
      return res
    end
    res[index] = string.sub(str, initPos, findPos - 1)
    initPos = findPos + string.len(delimeter)
    findPos = 0
    index = index + 1
  end
  return res
end
local events = {
  TUTORIAL_EVENT = function(id, info)
    local infoTable = {}
    infoTable.id = id
    infoTable.pageInfos = {}
    for pageIdx = 1, #info do
      infoTable.pageInfos[pageIdx] = {}
      local pageInfo = infoTable.pageInfos[pageIdx]
      if string.len(info[pageIdx][1].title) > 0 then
        pageInfo.title = X2Locale:LocalizeUiText(TUTORIAL_TEXT, info[pageIdx][1].title)
      else
        pageInfo.title = X2Locale:LocalizeUiText(TUTORIAL_TEXT, "tutorial_title_" .. id)
      end
      local explanations = split(info[pageIdx][2][1], "@")
      for explanationIdx = 1, #explanations do
        infoTable.pageInfos[pageIdx][explanationIdx] = {}
        local explanationPart = infoTable.pageInfos[pageIdx][explanationIdx]
        explanationPart.explanation = explanations[explanationIdx]
      end
    end
    ShowTutorialWindow(true, infoTable)
  end,
  TUTORIAL_HIDE_FROM_OPTION = function()
    if tutorial.window ~= nil then
      tutorial.window.hideFromOption = true
      tutorial.window:Show(false)
    end
  end
}
tutorial.eventHandler:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(tutorial.eventHandler, events)
function IsExistWaitQueue(id)
  for i = 1, #tutorial.waitQueue do
    if id == tutorial.waitQueue[i].id then
      return true
    end
  end
  return false
end
local prevSoundId = 0
function ShowTutorialWindow(show, infoTable, isFromQueue)
  if tutorial.window == nil then
    tutorial.window = SetViewofTutorialWindow("tutorial")
  end
  if tutorial.waitQueue == nil then
    tutorial.waitQueue = {}
  end
  local contentsInfo = infoTable.pageInfos[1][1]
  if not IsExistWaitQueue(infoTable.id) and contentsInfo.explanation ~= "hidden" then
    table.insert(tutorial.waitQueue, infoTable)
  end
  if contentsInfo.explanation == "hidden" then
    X2Player:OpendTutorialWindow(infoTable.id)
    soundId = 0
    return
  end
  if show == true then
    if prevSoundId ~= 0 then
      F_SOUND:StopSound(prevSoundId, true)
    end
    soundId = F_SOUND.PlayUISound(contentsInfo.explanation, true)
  end
  local tutorialWidnow = tutorial.window
  tutorialWidnow:Show(show)
  tutorialWidnow:UpdateTutorialTitle(infoTable, 1)
  tutorialWidnow:CreateContentsPart(infoTable)
  tutorialWidnow:UpdateWindowExtent()
  tutorialWidnow:UpdateWindowAnchor(infoTable.id)
  prevSoundId = soundId
  function tutorial.window:OnHide()
    local value = tutorial.window.checkHideTutorial:GetChecked()
    if value == true then
      if tutorial.waitQueue ~= nil then
        tutorial.waitQueue = nil
      end
      local DialogNoticeHandler = function(wnd)
        wnd:SetTitle(locale.tutorial.hideTutorialTitle)
        wnd:SetContent(locale.tutorial.hideTutorialMsg)
        function wnd:OkProc()
          X2Option:SetItemFloatValue(OPTION_ITEM_HIDE_TUTORIAL, 1)
        end
      end
      X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
    end
    if tutorial.window.hideFromOption == true and tutorial.waitQueue ~= nil then
      tutorial.waitQueue = nil
    end
    if soundId > 0 then
      F_SOUND:StopSound(soundId)
    end
    tutorial.window = nil
    if tutorial.waitQueue ~= nil and #tutorial.waitQueue > 0 then
      if tutorial.waitQueue[#tutorial.waitQueue].id == infoTable.id then
        table.remove(tutorial.waitQueue, #tutorial.waitQueue)
      end
      if #tutorial.waitQueue == 0 then
        return
      end
      ShowTutorialWindow(true, tutorial.waitQueue[#tutorial.waitQueue], true)
    end
  end
  tutorial.window:SetHandler("OnHide", tutorialWidnow.OnHide)
  function tutorial.window.pageControl:OnPageChanged(pageIndex, countPerPage)
    tutorialWidnow:ChangedPage(infoTable, pageIndex)
    F_SOUND:StopSound(soundId)
    soundId = F_SOUND.PlayUISound(infoTable.pageInfos[pageIndex][1].explanation, true)
  end
  X2Player:OpendTutorialWindow(infoTable.id)
end
