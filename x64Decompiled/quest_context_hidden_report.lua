local CreateHiddenQuestReport = function(id, parent)
  local widget = CreateSmallJournalFrame(id, parent, "hidden")
  widget.button:SetText(locale.questContext.takeReward)
  ApplyButtonSkin(widget.button, BUTTON_BASIC.DEFAULT)
  widget.close:SetText(GetUIText(NPC_INTERACTION_TEXT, "close"))
  ApplyButtonSkin(widget.close, BUTTON_BASIC.DEFAULT)
  widget.giveup:SetText(locale.questContext.giveup)
  ApplyButtonSkin(widget.giveup, BUTTON_BASIC.DEFAULT)
  local function ButtonLeftClickFunc()
    local selectIdx = widget:GetSelectiveItemIndex()
    if selectIdx == nil then
      selectIdx = 0
    end
    local questType = widget:GetCurQuestType()
    if questType == nil then
      return
    end
    local selectiveRewardCount = X2Quest:GetQuestContextRewardSelectiveItemAllCount(questType)
    if selectiveRewardCount > 0 and (selectIdx < 1 or selectIdx == nil) then
      local message = locale.questContext.errors[10]
      if message == nil then
        message = locale.questContext.invalid_reward
      end
      AddMessageToSysMsgWindow(message)
      return
    end
    X2Quest:TryCompleteQuestContext(0, questType, "", "", selectIdx)
  end
  ButtonOnClickHandler(widget.button, ButtonLeftClickFunc)
  local CloseLeftClickFunc = function()
    HideHiddenQuestReport()
  end
  ButtonOnClickHandler(widget.close, CloseLeftClickFunc)
  local function GiveUpLeftClickFunc()
    local questType = widget:GetCurQuestType()
    local idx = IndexFromQuestType(questType)
    X2Quest:QuestContextDrop(idx)
    RemoveQuestListCheckBoxState(questType)
    widget:SetCurQuestType(nil)
    HideHiddenQuestReport()
  end
  ButtonOnClickHandler(widget.giveup, GiveUpLeftClickFunc)
  function widget:JournalProc(useAppellationRoute)
    local questType = widget:GetCurQuestType()
    if questType == nil then
      return
    end
    if useAppellationRoute == true then
      widget.button:Show(false)
      widget.giveup:Show(false)
      widget.close:Show(true)
      widget.close:RemoveAllAnchors()
      widget.close:AddAnchor("BOTTOM", widget, 0, -GetWindowMargin())
      widget.useAppellationRoute = true
      return
    else
      widget.close:Show(false)
      widget.button:Show(true)
      widget.giveup:Show(true)
      widget.button:RemoveAllAnchors()
      widget.giveup:RemoveAllAnchors()
      widget.button:AddAnchor("BOTTOM", widget, -widget.button:GetWidth() / 2 - 2, -GetWindowMargin())
      widget.giveup:AddAnchor("BOTTOM", widget, widget.giveup:GetWidth() / 2 + 2, -GetWindowMargin())
      widget.useAppellationRoute = false
    end
    local selectiveRewardCount = X2Quest:GetQuestContextRewardSelectiveItemAllCount(questType)
    if selectiveRewardCount ~= nil and selectiveRewardCount > 0 then
      self.button:SetText(locale.questContext.rewardSelect)
    else
      self.button:SetText(locale.questContext.rewardTake)
    end
  end
  function widget:GetRelateButton()
    return widget.button
  end
  return widget
end
local hiddenQuestReport = CreateHiddenQuestReport("hiddenQuestReport", "UIParent")
local hiddenQuestReportEvent = {
  QUEST_HIDDEN_READY = function(qtype)
    ShowHiddenQuestReport(qtype)
  end,
  QUEST_HIDDEN_COMPLETE = function(qtype)
    if qtype == hiddenQuestReport:GetCurQuestType() then
      hiddenQuestReport:SetCurQuestType(nil)
    end
    HideHiddenQuestReport()
  end,
  QUEST_ERROR_INFO = function(errNum, questType)
    if errNum == 1 then
      return
    end
    if hiddenQuestReport:GetCurQuestType() == questType then
      HideHiddenQuestReport()
      AddMessageToSysMsgWindow(locale.questContext.errors[errNum])
    end
  end,
  UI_PERMISSION_UPDATE = function()
    local questType = hiddenQuestReport:GetCurQuestType()
    if questType ~= nil then
      ShowHiddenQuestReport(questType)
    end
  end
}
hiddenQuestReport:SetHandler("OnEvent", function(this, event, ...)
  hiddenQuestReportEvent[event](...)
end)
hiddenQuestReport:RegisterEvent("QUEST_HIDDEN_READY")
hiddenQuestReport:RegisterEvent("QUEST_HIDDEN_COMPLETE")
hiddenQuestReport:RegisterEvent("QUEST_ERROR_INFO")
hiddenQuestReport:RegisterEvent("UI_PERMISSION_UPDATE")
function ShowHiddenQuestReport(questType, useAppellationRoute)
  if UIParent:GetPermission(UIC_HIDDEN_QUEST) == false then
    HideHiddenQuestReport()
    return
  end
  if hiddenQuestReport:IsVisible() then
    hiddenQuestReport:Show(false)
  end
  hiddenQuestReport:FillJournal("hidden", questType, useAppellationRoute)
  MoveWindowTo(hiddenQuestReport, GetNotifierWnd())
  hiddenQuestReport:Show(true)
  hiddenQuestReport:Raise()
end
function HideHiddenQuestReport()
  hiddenQuestReport:Show(false)
end
