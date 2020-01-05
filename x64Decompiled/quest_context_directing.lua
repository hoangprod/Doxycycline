local fastQuestChatBubble = X2Player:GetFeatureSet().fastQuestChatBubble
local BUBBLE_INVAILD_TYPE_FOR_BACKWARD = 0
local QUEST_DEFAULT_REWARD_COUNT = 4
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local windowWidth = UIParent:GetScreenWidth()
local windowHeight = UIParent:GetScreenHeight()
local FADE_TIME = 370
local DIRECTING_TYPE = {
  NONE = 1,
  START = 2,
  PROGRESS_TALK = 3,
  COMPLETE = 4
}
local NEXT_TALK_TYPE = {
  NONE = 0,
  HAS_NEXT = 1,
  COMPLETE = 2
}
local REWARD_TYPE = {DEFAULT = 1, SELECTIVE = 2}
local RESOLUTION_RATIO = {
  w = windowWidth / 1680,
  h = windowHeight / 1050
}
local directingFadeTime = 0
local GetActionsKeyBinding = function(widget, action, message)
  local strAction = "quest_directing_interaction"
  local keyIndex = {
    d = 1,
    f = 2,
    g = 3
  }
  local function GetKeyIndex(strKey)
    local index = keyIndex[strKey]
    if index == nil then
      index = 0
    end
    return index
  end
  local str = ""
  if action == "next" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("f")) or ""
    str = string.format("%s(%s)", locale.questContext.next, string.upper(bindingText))
  elseif action == "prev" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("d")) or ""
    str = string.format("%s(%s)", locale.questContext.prev, string.upper(bindingText))
  elseif action == "confirm" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("f")) or ""
    local bindingText2 = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("g")) or ""
    str = string.format("%s(%s/%s)", locale.questContext.ok, string.upper(bindingText), string.upper(bindingText2))
  elseif action == "talk" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("f")) or ""
    str = string.format("%s(%s)", locale.questContext.talk, string.upper(bindingText))
  elseif action == "force_skip" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("g")) or ""
    str = string.format("%s(%s)", X2Locale:LocalizeUiText(QUEST_TEXT, "skip"), string.upper(bindingText))
  elseif action == "force_ok" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("g")) or ""
    str = string.format("%s(%s)", X2Locale:LocalizeUiText(QUEST_TEXT, "force_ok"), string.upper(bindingText))
  elseif action == "force_complete" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("g")) or ""
    str = string.format("%s(%s)", X2Locale:LocalizeUiText(QUEST_TEXT, "force_complete"), string.upper(bindingText))
  elseif action == "etc" then
    local bindingText = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("f")) or ""
    local bindingText2 = X2Hotkey:GetOptionBinding(strAction, 1, false, GetKeyIndex("g")) or ""
    str = string.format("%s(%s/%s)", message, string.upper(bindingText), string.upper(bindingText2))
  end
  widget:SetText(str)
end
local CreateScrollBar = function(id, parent)
  local scroll = W_CTRL.CreateScroll(id, parent)
  function scroll:SetScroll(totalLines, currentLine, pagePerMaxLines)
    local visible = pagePerMaxLines < totalLines and true or false
    self:Show(visible)
    if visible then
      local maxValue = totalLines - pagePerMaxLines
      self.vs:SetMinMaxValues(0, maxValue)
      self.vs:SetPageStep(pagePerMaxLines)
      self.vs:SetValue(currentLine, false)
      self.vs:SetValueStep(1)
      self:SetButtonMoveStep(self.vs:GetValueStep())
      self:SetWheelMoveStep(self.vs:GetValueStep())
    else
      self.vs:SetMinMaxValues(0, 0)
      self.vs:SetValueStep(0)
      self.vs:SetPageStep(0)
    end
  end
  return scroll
end
local CreateRewardLabelWidget = function(id, parent, type, isAutoSize, color)
  local widget = parent:CreateChildWidget(type, id, 0, true)
  if isAutoSize == true then
    widget:SetAutoResize(true)
  end
  widget.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(widget, color)
  return widget
end
local SetLabelWidgetLayOut = function(my, width, fontHeight, tartget, myAnchor, targetAnchor, offsetX, offsetY, isShow)
  my:RemoveAllAnchors()
  if width ~= nil then
    my:SetExtent(width, fontHeight)
  else
    my:SetHeight(fontHeight)
  end
  my.style:SetFontSize(fontHeight)
  if targetAnchor == nil then
    my:AddAnchor(myAnchor, tartget, offsetX, offsetY)
  else
    my:AddAnchor(myAnchor, tartget, targetAnchor, offsetX, offsetY)
  end
  my:Show(isShow)
end
local function CreateRewardFrame(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  local baseRewardLabel = CreateRewardLabelWidget("baseRewardLabel", frame, "label", false, FONT_COLOR.WHITE)
  frame.rewardLabels = {}
  for i = 1, 4 do
    frame.rewardLabels[i] = CreateQuestRewardLabelWidget("rewardTextBox_" .. i, frame, false, false, FONT_COLOR.SOFT_YELLOW)
  end
  local selectRewardLabel = CreateRewardLabelWidget("selectRewardLabel", frame, "label", false, FONT_COLOR.WHITE)
  local selectNoticeLabel = CreateRewardLabelWidget("selectNoticeLabel", frame, "label", false, FONT_COLOR.WHITE)
  local rewardItemFrame = CreateRewardItemSlotFrame("rewardItemFrame", frame, false)
  frame.rewardItemFrame = rewardItemFrame
  local rewardSelectItemFrame = CreateSelectiveRewardItemSlotFrame("rewardSelectItemFrame", frame)
  frame.rewardSelectItemFrame = rewardSelectItemFrame
  frame.rewardType = REWARD_TYPE.DEFAULT
  frame.isExistReward = false
  function frame:ResetWidgetInfo()
    local hFont = F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 212) / 212
    local height15 = math.floor(FONT_SIZE.LARGE * hFont + 0.5)
    local width253 = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 253))
    for i = 1, 4 do
      self.rewardLabels[i]:ClearValue()
      self.rewardLabels[i]:SetExtent(width253, height15)
    end
    self.selectRewardLabel:Show(false)
    self.selectNoticeLabel:Show(false)
    self.rewardItemFrame:Show(false)
    self.rewardSelectItemFrame:Show(false)
  end
  function frame:SetLayOut()
    local fontHeight = F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 212) / 212
    local labelWidth = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 407))
    local labelFont22 = math.floor(FONT_SIZE.XXLARGE * fontHeight + 0.5)
    local labelFont15 = math.floor(FONT_SIZE.LARGE * fontHeight + 0.5)
    local emptyHeight18 = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 18))
    local emptyHeight25 = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 25))
    local emptyWidth5 = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 5))
    local emptyWidth253 = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 253))
    SetLabelWidgetLayOut(self.baseRewardLabel, labelWidth, labelFont22, self, "TOPLEFT", nil, 0, 0, true)
    self.baseRewardLabel:SetText(GetUIText(QUEST_TEXT, "compensation"))
    SetLabelWidgetLayOut(self.rewardLabels[1], emptyWidth253, labelFont15, self.baseRewardLabel, "TOPLEFT", "BOTTOMLEFT", 0, emptyHeight18, true)
    SetLabelWidgetLayOut(self.rewardLabels[2], emptyWidth253, labelFont15, self.baseRewardLabel, "TOPLEFT", "BOTTOMLEFT", emptyWidth253 + emptyWidth5 * 2, emptyHeight18, true)
    SetLabelWidgetLayOut(self.rewardLabels[3], emptyWidth253, labelFont15, self.rewardLabels[1], "TOPLEFT", "BOTTOMLEFT", 0, emptyHeight18, true)
    SetLabelWidgetLayOut(self.rewardLabels[4], emptyWidth253, labelFont15, self.rewardLabels[2], "TOPLEFT", "BOTTOMLEFT", 0, emptyHeight18, true)
    self.rewardItemFrame:AddAnchor("TOPLEFT", self.rewardLabels[3], "BOTTOMLEFT", 0, emptyHeight25)
    self.rewardItemFrame:SetItemSlotLayOut(emptyWidth5)
    SetLabelWidgetLayOut(self.selectRewardLabel, labelWidth, labelFont22, self, "TOPRIGHT", nil, 0, 0, true)
    SetLabelWidgetLayOut(self.selectNoticeLabel, labelWidth, labelFont15, self.selectRewardLabel, "TOPRIGHT", "BOTTOMRIGHT", 0, emptyHeight18, true)
    self.selectRewardLabel:SetText(GetUIText(QUEST_TEXT, "selective_compensation"))
    self.selectNoticeLabel:SetText(GetUIText(COMMON_TEXT, "select_quest_item"))
    self.rewardSelectItemFrame:AddAnchor("TOPLEFT", self.selectNoticeLabel, "BOTTOMLEFT", 0, emptyHeight25)
    self.rewardSelectItemFrame:SetItemSlotLayOut(emptyWidth5)
  end
  function frame:UpdateRewardInfo(qtype, directingType)
    self:ResetWidgetInfo()
    local baseRewardFrameAnchor = self.baseRewardLabel
    local viewCnt = QUEST_DEFAULT_REWARD_COUNT
    local offsetY = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 25))
    local offsetWidth = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 253))
    self.isExistReward = false
    defaultRewardInfo = GetValidDefaultRewardInfo(qtype)
    if defaultRewardInfo ~= nil then
      if viewCnt > #defaultRewardInfo then
        viewCnt = #defaultRewardInfo
      end
      if viewCnt > 0 then
        baseRewardFrameAnchor = self.rewardLabels[1]
        self.isExistReward = true
      end
      if viewCnt > 2 then
        baseRewardFrameAnchor = self.rewardLabels[3]
      end
      for i = 1, viewCnt do
        if self.rewardLabels[i] ~= nil then
          self.rewardLabels[i]:Show(true)
          self.rewardLabels[i]:UpdateValue(defaultRewardInfo[i], true)
        end
      end
    end
    if 0 < X2Quest:GetQuestContextRewardItemAllCount(qtype) then
      if baseRewardFrameAnchor ~= nil then
        self.rewardItemFrame:RemoveAllAnchors()
        self.rewardItemFrame:AddAnchor("TOPLEFT", baseRewardFrameAnchor, "BOTTOMLEFT", 0, offsetY)
        self.rewardItemFrame:Show(true)
        self.rewardItemFrame:FillItem(qtype)
      end
      self.isExistReward = true
    end
    if 0 < X2Quest:GetQuestContextRewardSelectiveItemAllCount(qtype) then
      self.isExistReward = true
      self.selectRewardLabel:Show(true)
      self.selectNoticeLabel:Show(true)
      if directingType == DIRECTING_TYPE.COMPLETE then
        self.selectNoticeLabel:SetText(GetUIText(COMMON_TEXT, "select_quest_item"))
      else
        self.selectNoticeLabel:SetText(GetUIText(QUEST_TEXT, "selective_item_notice"))
      end
      self.rewardSelectItemFrame:RemoveAllAnchors()
      self.rewardSelectItemFrame:AddAnchor("TOPLEFT", self.selectNoticeLabel, "BOTTOMLEFT", 0, offsetY)
      self.rewardSelectItemFrame:Show(true)
      self.rewardSelectItemFrame:FillSelectiveItem(qtype)
    end
  end
  function frame:ResetSelectedItem()
    if self.rewardSelectItemFrame ~= nil then
      self.rewardSelectItemFrame:ResetSelectState()
    end
  end
  function frame:SetRelationButton(button)
    self.rewardSelectItemFrame:SetRelationButton(button)
  end
  frame:ResetWidgetInfo()
  frame:Show(true)
  return frame
end
local function CreateQuestCinemaWnd()
  local w = CreateEmptyWindow("questDirecting", "UIParent")
  w:Show(false)
  w:SetExtent(windowWidth, windowHeight)
  local backgroundColor = FORM_QUEST_DIRECTING.PANEL_COLOR.ACCEPT
  local title = w:CreateChildWidget("label", "title", 0, true)
  title:Show(true)
  title:SetAutoResize(true)
  title.style:SetSnap(true)
  title.style:SetShadow(true)
  title.style:SetAlign(ALIGN_CENTER)
  w.title = title
  local closeButton = w:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:Show(true)
  closeButton:AddAnchor("TOPRIGHT", w, -5, 5)
  ApplyButtonSkin(closeButton, BUTTON_CONTENTS.CINEMA_CLOSE)
  w.closeButton = closeButton
  local underPanel = w:CreateColorDrawable(backgroundColor[1], backgroundColor[2], backgroundColor[3], backgroundColor[4], "background")
  underPanel:AddAnchor("BOTTOMLEFT", w, 0, 0)
  underPanel:AddAnchor("BOTTOMRIGHT", w, 0, 0)
  w.underPanel = underPanel
  local upperPanel = w:CreateDrawable(BUTTON_TEXTURE_PATH.CINEMA, "title_bg", "background")
  upperPanel:AddAnchor("BOTTOM", underPanel, "TOP", 0, -4)
  w.upperPanel = upperPanel
  w.upperPanel.baseWidth = 0
  local gradeMarker = W_ICON.CreateQuestGradeMarker(w)
  local dailyMarker = CreateDailyMarker(w)
  local repeatableMarker = CreateRepeatableQuestMarker(w)
  repeatableMarker:Show(false)
  local messageFrame = w:CreateChildWidget("emptywidget", "messageFrame", 0, true)
  messageFrame:AddAnchor("TOP", underPanel, 0, 0)
  local messageAuthor = w:CreateChildWidget("label", "messageAuthor", 0, true)
  messageAuthor:Show(true)
  messageAuthor.style:SetEllipsis(true)
  messageAuthor.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(messageAuthor, F_COLOR.GetColor("zone_peace_blue"))
  local messageWidget = w:CreateChildWidget("message", "messageWidget", 0, true)
  messageWidget:Show(true)
  messageWidget:SetLineSpace(questLocale.directing.message.lineSpace)
  messageWidget.style:SetSnap(true)
  messageWidget.style:SetAlign(ALIGN_TOP_LEFT)
  messageWidget:SetInset(0, 3, 0, 0)
  messageWidget:ChangeTextStyle()
  local scrollBar = CreateScrollBar(w:GetId() .. ".scrollBar", messageWidget)
  w.scrollBar = scrollBar
  local nextButton = w:CreateChildWidget("button", "nextButton", 0, true)
  nextButton:Show(true)
  nextButton:SetSounds("quest_directing_mode")
  GetActionsKeyBinding(nextButton, "next")
  nextButton.style:SetAlign(ALIGN_BOTTOM)
  ApplyButtonSkin(nextButton, BUTTON_CONTENTS.CINEMA_NEXT)
  nextButton:SetAutoResize(true)
  local prevButton = w:CreateChildWidget("button", "prevButton", 0, true)
  prevButton:Show(true)
  prevButton:SetSounds("quest_directing_mode")
  GetActionsKeyBinding(prevButton, "prev")
  prevButton.style:SetAlign(ALIGN_BOTTOM)
  ApplyButtonSkin(prevButton, BUTTON_CONTENTS.CINEMA_PREV)
  prevButton:SetAutoResize(true)
  local confirmButton = w:CreateChildWidget("button", "confirmButton", 0, true)
  confirmButton:Show(true)
  confirmButton:SetSounds("quest_directing_mode")
  GetActionsKeyBinding(confirmButton, "confirm")
  confirmButton.style:SetAlign(ALIGN_BOTTOM)
  ApplyButtonSkin(confirmButton, BUTTON_CONTENTS.CINEMA_ACCEPT)
  confirmButton:SetAutoResize(true)
  local forceSkipButton = w:CreateChildWidget("button", "forceSkipButton", 0, true)
  forceSkipButton:Show(true)
  forceSkipButton:SetSounds("quest_directing_mode")
  GetActionsKeyBinding(forceSkipButton, "force_skip")
  forceSkipButton.style:SetAlign(ALIGN_BOTTOM)
  ApplyButtonSkin(forceSkipButton, BUTTON_CONTENTS.CINEMA_ACCEPT)
  forceSkipButton:SetAutoResize(true)
  local rewardFrame = CreateRewardFrame("rewardFrame", w)
  w.rewardFrame = rewardFrame
  w.rewardFrame:SetRelationButton(confirmButton)
  function w:SetLayOut()
    local upperHeight = F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 105)
    local underHeight = F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 212)
    local dialogFontSize = math.floor(underHeight / 9)
    local messageFrameWidth = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 990))
    local messageFrameHeight = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 178))
    local messageAuthorAnchorY = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 23))
    local messgeWidgetAnchorY = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 13))
    local messageWidgetHeight = messageFrameHeight - dialogFontSize - messageAuthorAnchorY - messgeWidgetAnchorY
    self.upperPanel.baseWidth = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 285))
    self.upperPanel:SetExtent(self.upperPanel.baseWidth, F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 42))
    self.underPanel:SetHeight(underHeight)
    self.messageFrame:SetExtent(messageFrameWidth, messageFrameHeight)
    self.messageAuthor:SetExtent(messageFrameWidth, dialogFontSize)
    self.messageAuthor:AddAnchor("TOP", self.messageFrame, 0, messageAuthorAnchorY)
    self.messageAuthor.style:SetFont(FONT_PATH.DEFAULT, dialogFontSize)
    self.messageWidget:SetExtent(messageFrameWidth, messageWidgetHeight)
    self.messageWidget:AddAnchor("TOP", self.messageAuthor, "BOTTOM", 0, messgeWidgetAnchorY)
    self.messageWidget.style:SetFont(FONT_PATH.DEFAULT, dialogFontSize)
    self.scrollBar:AddAnchor("TOPLEFT", messageWidget, "TOPRIGHT", F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 16), -(dialogFontSize + messgeWidgetAnchorY))
    self.scrollBar:AddAnchor("BOTTOMLEFT", messageWidget, "BOTTOMRIGHT", 0, 0)
    local titleFontSize = math.floor(upperHeight / 4)
    self.title:SetHeight(titleFontSize)
    self.title:AddAnchor("CENTER", self.upperPanel, 0, 0)
    self.title.style:SetFont(FONT_PATH.LEEYAGI, titleFontSize)
    local buttonAnchorX = F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 68)
    local buttonAnchorY = F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 68)
    self.prevButton:AddAnchor("TOPRIGHT", self.messageFrame, "TOPLEFT", -buttonAnchorX, buttonAnchorY)
    self.nextButton:AddAnchor("TOPLEFT", self.messageFrame, "TOPRIGHT", buttonAnchorX, buttonAnchorY)
    self.confirmButton:AddAnchor("TOPLEFT", self.messageFrame, "TOPRIGHT", buttonAnchorX, buttonAnchorY)
    self.forceSkipButton:AddAnchor("TOPLEFT", self.nextButton, "TOPRIGHT", 23, 0)
    self.rewardFrame:SetExtent(messageFrameWidth, math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.h * 155)))
    self.rewardFrame:AddAnchor("TOP", self.messageFrame, 0, messageAuthorAnchorY)
    self.rewardFrame:SetLayOut()
  end
  w:SetLayOut()
  w.questType = 0
  w.doodadId = ""
  w.who = 0
  w.showRewardStep = false
  w.prevButtonState = nil
  w.directingType = DIRECTING_TYPE.NONE
  w.currentBubbleTypes = {}
  w.currentBubbleTypesForBackward = {}
  return w
end
local function UpdateRewardState(wnd, questState, qtype)
  if wnd.isExistReward == false then
    return false
  end
  if questState == DIRECTING_TYPE.PROGRESS_TALK then
    return false
  else
    if questState ~= DIRECTING_TYPE.START and X2Quest:GetQuestContextRewardSelectiveItemAllCount(qtype) > 0 then
      wnd.rewardType = REWARD_TYPE.SELECTIVE
    end
    return true
  end
end
local function FillRewards(wnd, questState, qtype)
  wnd.rewardType = REWARD_TYPE.DEFAULT
  wnd:UpdateRewardInfo(qtype, questState)
end
local function CreateFadeWnd()
  local w = CreateEmptyWindow("QuestDirectingFadeWindow", "UIParent")
  w:Show(false)
  w:SetExtent(windowWidth, windowHeight)
  local panel = w:CreateColorDrawable(0, 0, 0, 1, "overlay")
  panel:AddAnchor("TOPLEFT", w, 0, 0)
  panel:AddAnchor("BOTTOMRIGHT", w, 0, 0)
  w.panel = panel
  return w
end
local fadeWnd = CreateFadeWnd()
fadeWnd:SetUILayer("questdirecting")
ADDON:RegisterContentWidget(UIC_QUEST_CINEMA_FADE_WND, fadeWnd)
local function OnScale()
  fadeWnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  fadeWnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
end
fadeWnd:SetHandler("OnScale", OnScale)
function fadeWnd:SetFadeEndFunc(OnFadeInEndFunc, OnFadeOutEndFunc)
  local fadeTime = 0
  self:ReleaseHandler("OnUpdate")
  self:ReleaseHandler("OnVisibleChanged")
  self.fadingNow = true
  function self:OnUpdateFadeIn(dt)
    fadeTime = dt + fadeTime
    if fadeTime > directingFadeTime then
      self:Show(false, directingFadeTime)
      self:ReleaseHandler("OnUpdate")
      self:SetHandler("OnVisibleChanged", self.OnVisibleChanged)
      OnFadeInEndFunc()
    end
  end
  self:SetHandler("OnUpdate", self.OnUpdateFadeIn)
  function self:OnVisibleChanged(visible)
    if visible == false then
      self:ReleaseHandler("OnVisibleChanged")
      OnFadeOutEndFunc()
      self.fadingNow = false
    end
  end
end
local questDirecting = CreateQuestCinemaWnd()
questDirecting:SetUILayer("questdirecting")
ADDON:RegisterContentWidget(UIC_QUEST_CINEMA_WND, questDirecting)
local function CloseQuestDirectingWnd()
  local function OnFadeInEnd()
    X2Quest:LeaveQuestDirectingMode()
    systemLayerParent:SetAlphaAnimation(0, 1, directingFadeTime / 1000 or 1, 0)
    systemLayerParent:SetStartAnimation(true, false)
  end
  if directingFadeTime > 0 then
    fadeWnd:SetFadeEndFunc(OnFadeInEnd, function()
    end)
    fadeWnd:SetAlpha(1)
    fadeWnd:Show(true, directingFadeTime)
  else
    OnFadeInEnd()
  end
  questDirecting.confirmButton:Enable(false)
  questDirecting:Show(false, directingFadeTime)
  questDirecting.currentBubbleTypes = {}
  questDirecting.currentBubbleTypesForBackward = {}
end
questDirecting:SetHandler("OnCloseByEsc", function()
  X2Quest:DeclineDirectingQuest()
  CloseQuestDirectingWnd()
end)
local prevBtnState, nextBtnState, comfirmBtnState
local function OnUpdate()
  local prevButton = questDirecting.prevButton
  local nextButton = questDirecting.nextButton
  local confirmButton = questDirecting.confirmButton
  if prevButton == nil or nextButton == nil or confirmButton == nil then
    return
  end
  local needUpdate = false
  if prevBtnState ~= prevButton:IsEnabled() then
    prevBtnState = prevButton:IsEnabled()
    needUpdate = true
  end
  if nextBtnState ~= nextButton:IsEnabled() then
    nextBtnState = nextButton:IsEnabled()
    needUpdate = true
  end
  if comfirmBtnState ~= confirmButton:IsEnabled() then
    comfirmBtnState = confirmButton:IsEnabled()
    needUpdate = true
  end
  if needUpdate then
    X2:NotifyQuestDirectingModeUpdate(prevBtnState, nextBtnState or comfirmBtnState, comfirmBtnState)
  end
end
questDirecting:SetHandler("OnUpdate", OnUpdate)
local function OnScale()
  questDirecting:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  questDirecting:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  questDirecting:SetLayOut()
end
questDirecting:SetHandler("OnScale", OnScale)
local closeButton = questDirecting.closeButton
local function OnClick(_, arg)
  if arg == "LeftButton" then
    X2Quest:DeclineDirectingQuest()
    CloseQuestDirectingWnd()
  end
end
closeButton:SetHandler("OnClick", OnClick)
local function ToggleRewardFrameVisible(isShow)
  questDirecting.messageAuthor:Show(not isShow)
  questDirecting.messageWidget:Show(not isShow)
  questDirecting.rewardFrame:Show(isShow)
  questDirecting.rewardFrame:ResetSelectedItem()
  questDirecting.nextButton:Show(not isShow)
  questDirecting.nextButton:Enable(not isShow)
  questDirecting.forceSkipButton:Show(not isShow)
  questDirecting.forceSkipButton:Enable(not isShow)
  if isShow == true then
    questDirecting.prevButtonState = questDirecting.prevButton:IsEnabled()
    questDirecting.prevButton:Enable(true)
  else
    if questDirecting.prevButton:IsEnabled() == true then
      questDirecting.showRewardStep = false
    end
    if questDirecting.prevButtonState ~= nil then
      questDirecting.prevButton:Enable(questDirecting.prevButtonState)
      questDirecting.prevButtonState = nil
    end
  end
  questDirecting.confirmButton:Show(isShow)
  if questDirecting.rewardFrame.rewardType == REWARD_TYPE.SELECTIVE then
    questDirecting.confirmButton:Enable(questDirecting.rewardFrame.rewardSelectItemFrame:GetSelectedItem() ~= 0)
  else
    questDirecting.confirmButton:Enable(isShow)
  end
end
local nextButton = questDirecting.nextButton
function nextButton:OnClick(arg)
  if arg == "LeftButton" and self:IsEnabled() == true then
    if questDirecting.showRewardStep == true then
      ToggleRewardFrameVisible(true)
      return
    end
    if X2:HasNextQuestChat(questDirecting.currentBubbleTypes[#questDirecting.currentBubbleTypes]) == false and UpdateRewardState(questDirecting.rewardFrame, questDirecting.directingType, questDirecting.questType) == true then
      questDirecting.showRewardStep = true
      ToggleRewardFrameVisible(true)
      return
    end
    if #questDirecting.currentBubbleTypes > 1 then
      questDirecting.currentBubbleTypesForBackward[#questDirecting.currentBubbleTypesForBackward + 1] = questDirecting.currentBubbleTypes[2]
    else
      questDirecting.currentBubbleTypesForBackward[#questDirecting.currentBubbleTypesForBackward + 1] = BUBBLE_INVAILD_TYPE_FOR_BACKWARD
    end
    X2:FastForwardQuestChat(questDirecting.currentBubbleTypes[#questDirecting.currentBubbleTypes])
  end
end
nextButton:SetHandler("OnClick", nextButton.OnClick)
local function ReturnChatMsgFrame()
  ToggleRewardFrameVisible(false)
  local cnt = X2:FastBackwardQuestChatByForceSkip() - 1
  if cnt > 0 then
    for i = 1, cnt do
      questDirecting.currentBubbleTypesForBackward[i] = BUBBLE_INVAILD_TYPE_FOR_BACKWARD
    end
  end
end
local prevButton = questDirecting.prevButton
function prevButton:OnClick(arg)
  if arg == "LeftButton" and self:IsEnabled() == true then
    if questDirecting.prevButtonState ~= nil then
      ReturnChatMsgFrame()
      return
    end
    local bubbleType = questDirecting.currentBubbleTypesForBackward[#questDirecting.currentBubbleTypesForBackward]
    questDirecting.currentBubbleTypesForBackward[#questDirecting.currentBubbleTypesForBackward] = nil
    if bubbleType == BUBBLE_INVAILD_TYPE_FOR_BACKWARD then
      bubbleType = questDirecting.currentBubbleTypes[1]
    end
    X2:FastBackwardQuestChat(bubbleType)
  end
end
prevButton:SetHandler("OnClick", prevButton.OnClick)
local confirmButton1 = questDirecting.confirmButton
function confirmButton1:OnClick(arg)
  if arg == "LeftButton" then
    local w = questDirecting
    if w.directingType == DIRECTING_TYPE.START then
      X2Quest:AcceptDirectingQuest()
    elseif w.directingType == DIRECTING_TYPE.PROGRESS_TALK then
      X2Quest:ProgressTalkDirectingQuest()
    elseif w.directingType == DIRECTING_TYPE.COMPLETE then
      X2Quest:CompleteDirectingQuest(w.rewardFrame.rewardSelectItemFrame:GetSelectedItem())
    else
      LuaAssert("error INVALID QUEST DIRECTING TYPE")
    end
    confirmButton1:Enable(false)
  end
end
confirmButton1:SetHandler("OnClick", confirmButton1.OnClick)
local forceSkipButton = questDirecting.forceSkipButton
function forceSkipButton:OnClick(arg)
  if arg == "LeftButton" and self:IsEnabled() == true then
    local w = questDirecting
    if w.directingType == DIRECTING_TYPE.COMPLETE then
      w.showRewardStep = UpdateRewardState(w.rewardFrame, w.directingType, w.questType)
      if w.showRewardStep == true then
        ToggleRewardFrameVisible(true)
        forceSkipButton:Enable(false)
        return
      end
    end
    confirmButton1:OnClick("LeftButton")
    forceSkipButton:Enable(false)
  end
end
forceSkipButton:SetHandler("OnClick", forceSkipButton.OnClick)
function questDirecting:OnClick(arg)
  if arg == "LeftButton" then
    prevButton:OnClick("LeftButton")
  end
  if arg == "RightButton" then
    if nextButton:IsVisible() == true and nextButton:IsEnabled() == true then
      nextButton:OnClick("LeftButton")
    elseif confirmButton1:IsVisible() == true and confirmButton1:IsEnabled() == true then
      confirmButton1:OnClick("LeftButton")
    end
  end
end
questDirecting:SetHandler("OnClick", questDirecting.OnClick)
local scrollBar = questDirecting.scrollBar
function scrollBar:UpdateData()
  questDirecting.messageWidget:SetScrollPos(self.vs:GetValue())
end
local RegisterScrollBarHandler = function(scrollBar)
  local function OnSliderChanged(self, arg)
    scrollBar:UpdateData()
  end
  scrollBar.vs:SetHandler("OnSliderChanged", OnSliderChanged)
  scrollBar.vs:SetHandler("OnMouseUp", OnSliderChanged)
  scrollBar.vs:SetHandler("OnMouseMove", OnSliderChanged)
end
RegisterScrollBarHandler(scrollBar)
local function GetQuestStatusMessage(qtype, rewardType)
  local letItDone = X2Quest:IsLetItDoneQuestByType(qtype)
  local overDone = X2Quest:IsOverDoneQuestByType(qtype)
  local complete = IsCompleteQuest(qtype)
  if not letItDone and not overDone and not complete then
    return "unknown"
  end
  local message
  if letItDone then
    message = locale.questContext.letItDone
  elseif overDone then
    message = locale.questContext.overDone
  elseif rewardType == REWARD_TYPE.DEFAULT then
    message = locale.questContext.rewardTake
  elseif rewardType == REWARD_TYPE.SELECTIVE then
    message = locale.questContext.rewardSelect
  end
  return message
end
local function StartDirectingMode(who, qtype, doodadId, npcId)
  systemLayerParent:SetAlpha(0)
  questDirecting.messageWidget:Clear()
  local function OnFadeInEnd()
    local w = questDirecting
    w:Show(true, directingFadeTime)
    local title = X2Quest:GetQuestContextMainTitle(qtype)
    title = X2Util:ApplyUIMacroString(title)
    w.title:SetText(title)
    local titleColor
    if X2Quest:IsMainQuest(qtype) then
      titleColor = F_COLOR.GetColor("quest_main")
    else
      titleColor = F_COLOR.GetColor("quest_normal")
    end
    w.title.style:SetColor(titleColor[1], titleColor[2], titleColor[3], titleColor[4])
    local upperPanelTextWidth = math.floor(F_LAYOUT.CalcDontApplyUIScale(RESOLUTION_RATIO.w * 125))
    if upperPanelTextWidth < w.title:GetWidth() then
      w.upperPanel:SetWidth(w.upperPanel.baseWidth + (w.title:GetWidth() - upperPanelTextWidth))
    else
      w.upperPanel:SetWidth(w.upperPanel.baseWidth)
    end
    if w.rewardFrame ~= nil then
      FillRewards(w.rewardFrame, w.directingType, qtype)
    end
    FillQuestMarker(w, qtype, w.upperPanel)
    if w.directingType == DIRECTING_TYPE.START then
      X2Quest:TryStartQuestContext(who, qtype, 0, doodadId, npcId)
    elseif w.directingType == DIRECTING_TYPE.PROGRESS_TALK then
      ProgressTalkQuest(qtype, npcId)
    elseif w.directingType == DIRECTING_TYPE.COMPLETE then
      X2Quest:TryCompleteQuestContext(who, qtype, doodadId, npcId, 0)
    else
      LuaAssert("error INVALID QUEST DIRECTING TYPE")
    end
    if w.directingType == DIRECTING_TYPE.COMPLETE then
      local completeMessage = locale.questContext.complete
      if w.rewardFrame ~= nil and w.rewardFrame.isExistReward == true then
        completeMessage = GetQuestStatusMessage(qtype, w.rewardFrame.rewardType)
        GetActionsKeyBinding(w.forceSkipButton, "force_skip")
      else
        GetActionsKeyBinding(w.forceSkipButton, "force_complete")
      end
      GetActionsKeyBinding(w.confirmButton, "etc", completeMessage)
    else
      GetActionsKeyBinding(w.forceSkipButton, "force_ok")
    end
  end
  local function OnFadeOutEnd()
    local w = questDirecting
    if w.directingType == DIRECTING_TYPE.START or w.directingType == DIRECTING_TYPE.PROGRESS_TALK then
      w:SetCloseOnEscape(true)
      w.forceSkipButton:Enable(true)
      if w.currentBubbleTypes[1] == nil then
        w.nextButton:Enable(true)
      else
        w.prevButton:Enable(not X2:IsFirstQuestChat(w.currentBubbleTypes[1]))
        if X2:HasNextQuestChat(w.currentBubbleTypes[#w.currentBubbleTypes]) then
          w.nextButton:Enable(true)
        else
          w.confirmButton:Enable(true)
        end
      end
    elseif w.directingType == DIRECTING_TYPE.COMPLETE then
      w:SetCloseOnEscape(true)
      local selectCount = X2Quest:GetQuestContextRewardSelectiveItemAllCount(qtype)
      local enable = selectCount == 0 and true or false
      w.prevButton:Enable(not X2:IsFirstQuestChat(w.currentBubbleTypes[1]))
      if X2:HasNextQuestChat(w.currentBubbleTypes[#w.currentBubbleTypes]) then
        w.nextButton:Enable(true)
        w.forceSkipButton:Show(true)
        w.forceSkipButton:Enable(true)
      else
        w.confirmButton:Enable(enable)
        if w.prevButton:IsEnabled() == false and w.showRewardStep == true then
          w.forceSkipButton:Show(true)
          w.forceSkipButton:Enable(true)
        else
          w.forceSkipButton:Show(false)
          w.forceSkipButton:Enable(false)
        end
      end
    else
      LuaAssert("error INVALID QUEST DIRECTING TYPE")
    end
  end
  X2Quest:EnterQuestDirectingMode()
  questDirecting.nextButton:Show(false)
  questDirecting.prevButton:Show(false)
  questDirecting.confirmButton:Show(false)
  questDirecting.forceSkipButton:Show(false)
  if directingFadeTime == 0 then
    fadeWnd.panel:SetColor(1, 1, 1, 0)
  else
    fadeWnd.panel:SetColor(0, 0, 0, 1)
  end
  fadeWnd:SetFadeEndFunc(OnFadeInEnd, OnFadeOutEnd)
  fadeWnd:Show(true, directingFadeTime)
end
function EndDirectingMode()
  local w = questDirecting
  w.questType = 0
  w.doodadId = ""
  w.who = 0
  w.directingType = DIRECTING_TYPE.NONE
  w.showRewardStep = false
  w.prevButtonState = nil
  CloseQuestDirectingWnd()
end
function StartNextQuest(qtype)
  local w = questDirecting
  ToggleRewardFrameVisible(false)
  w.showRewardStep = false
  w.prevButtonState = nil
  local msg = X2Quest:GetActiveQuestContextConditionMessage()
  w.messageWidget:AddMessage(string.format("|CFFF3E332%s", msg))
  w.questType = qtype
  w.directingType = DIRECTING_TYPE.START
  w:SetCloseOnEscape(true)
  w.nextButton:Show(false)
  w.prevButton:Show(false)
  w.nextButton:Enable(false)
  w.prevButton:Enable(false)
  w.confirmButton:Show(false)
  w.confirmButton:Enable(false)
  w.forceSkipButton:Show(false)
  w.forceSkipButton:Enable(false)
  GetActionsKeyBinding(w.nextButton, "next")
  GetActionsKeyBinding(w.prevButton, "prev")
  GetActionsKeyBinding(w.confirmButton, "confirm")
  GetActionsKeyBinding(w.forceSkipButton, "force_ok")
  local title = X2Quest:GetQuestContextMainTitle(qtype)
  w.title:SetText(title)
  local titleColor
  if X2Quest:IsMainQuest(qtype) then
    titleColor = F_COLOR.GetColor("quest_main")
  else
    titleColor = F_COLOR.GetColor("quest_normal")
  end
  w.title.style:SetColor(titleColor[1], titleColor[2], titleColor[3], titleColor[4])
  if w.rewardFrame ~= nil then
    FillRewards(w.rewardFrame, w.directingType, qtype)
  end
  X2Quest:TryStartQuestContext(w.who, qtype, 0, w.doodadId, w.npcId)
  w.confirmButton:Enable(true)
end
local function GetDirectingFadeTime(qtype)
  if X2Quest:IsMainQuest(qtype) == true and X2Quest:UseQuestCamera() == true then
    return FADE_TIME
  end
  return 0
end
local function StartQuest(who, qtype, useDirectingMode, doodadId, npcId)
  if useDirectingMode == false then
    return
  end
  if fadeWnd.fadingNow == true then
    return false
  end
  doodadId = doodadId or ""
  local w = questDirecting
  w.questType = qtype
  w.doodadId = doodadId
  w.npcId = npcId
  w.who = who
  w.directingType = DIRECTING_TYPE.START
  ToggleRewardFrameVisible(false)
  w.showRewardStep = false
  w.prevButtonState = nil
  w:SetCloseOnEscape(false)
  w.nextButton:Enable(false)
  w.prevButton:Enable(false)
  w.forceSkipButton:Enable(false)
  GetActionsKeyBinding(w.nextButton, "next")
  GetActionsKeyBinding(w.prevButton, "prev")
  GetActionsKeyBinding(w.confirmButton, "confirm")
  GetActionsKeyBinding(w.forceSkipButton, "force_skip")
  directingFadeTime = GetDirectingFadeTime(qtype)
  StartDirectingMode(who, qtype, doodadId, npcId)
end
local function CompleteQuest(who, qtype, useDirectingMode, doodadId, npcId)
  if useDirectingMode == false then
    return
  end
  if fadeWnd.fadingNow == true then
    return false
  end
  doodadId = doodadId or ""
  local w = questDirecting
  w.questType = qtype
  w.doodadId = doodadId
  w.npcId = npcId
  w.who = who
  w.directingType = DIRECTING_TYPE.COMPLETE
  ToggleRewardFrameVisible(false)
  w.showRewardStep = false
  w.prevButtonState = nil
  w:SetCloseOnEscape(false)
  w.nextButton:Enable(false)
  w.prevButton:Enable(false)
  w.confirmButton:Enable(false)
  w.forceSkipButton:Enable(false)
  directingFadeTime = GetDirectingFadeTime(qtype)
  StartDirectingMode(who, qtype, doodadId, npcId)
end
local function ProgressTalkQuest(who, qtype, useDirectingMode, doodadId, npcId)
  if useDirectingMode == false then
    return
  end
  if fadeWnd.fadingNow == true then
    return false
  end
  doodadId = doodadId or ""
  local w = questDirecting
  w.questType = qtype
  w.doodadId = doodadId
  w.npcId = npcId
  w.who = who
  w.directingType = DIRECTING_TYPE.PROGRESS_TALK
  ToggleRewardFrameVisible(false)
  w.showRewardStep = false
  w.prevButtonState = nil
  w:SetCloseOnEscape(false)
  w.nextButton:Enable(false)
  w.prevButton:Enable(false)
  w.confirmButton:Enable(false)
  w.forceSkipButton:Enable(false)
  GetActionsKeyBinding(w.confirmButton, "talk")
  directingFadeTime = GetDirectingFadeTime(qtype)
  StartDirectingMode(who, qtype, doodadId, npcId)
end
local function InteractionEnd()
  if questDirecting:IsVisible() == false then
    return
  end
  CancelQuestDirectingMode()
  X2Interaction:CancelNPCInteraction()
end
local events = {
  START_QUEST_CONTEXT_NPC = function(qtype, useDirectingMode, npcId)
    StartQuest(1, qtype, useDirectingMode, "", npcId)
  end,
  COMPLETE_QUEST_CONTEXT_NPC = function(qtype, useDirectingMode, npcId)
    CompleteQuest(1, qtype, useDirectingMode, "", npcId)
  end,
  PROGRESS_TALK_QUEST_CONTEXT = function(qtype, useDirectingMode, npcId)
    ProgressTalkQuest(1, qtype, useDirectingMode, "", npcId)
  end,
  START_QUEST_CONTEXT_DOODAD = function(qtype, useDirectingMode, doodadId)
    StartQuest(2, qtype, useDirectingMode, doodadId, "")
  end,
  COMPLETE_QUEST_CONTEXT_DOODAD = function(qtype, useDirectingMode, doodadId)
    CompleteQuest(2, qtype, useDirectingMode, doodadId, "")
  end,
  CHAT_MSG_QUEST = function(message, author, authorId, self, tailType, showTime, fadeTime, currentBubbleType, qtype, forceFinished)
    local w = questDirecting
    if w:IsVisible() == false then
      return
    end
    if w.questType ~= qtype then
      return
    end
    for i = 1, #w.currentBubbleTypes do
      if w.currentBubbleTypes[i] == currentBubbleType then
        return
      end
    end
    w.currentBubbleTypes = {}
    w.showRewardStep = false
    w.prevButtonState = nil
    w.prevButton:Show(true)
    w.prevButton:Enable(not X2:IsFirstQuestChat(currentBubbleType))
    local messageAuthor = w.messageAuthor
    local messageWidget = w.messageWidget
    local playerName = X2Unit:UnitName("player")
    local color = "|CFFFFFFFF"
    if self then
      author = locale.questContext.mySelf
      color = "|CFF88D4F8"
    end
    if tailType == CBK_THINK then
      message = string.format("(%s)", message)
    elseif tailType == CBK_SYSTEM then
      message = string.format("%s", message)
      author = ""
      color = "|CFFF08BF2"
    end
    messageAuthor:SetText(author)
    messageWidget:Clear()
    messageWidget:AddMessage(string.format("%s%s", color, message))
    local pagePerMaxLines = messageWidget:GetPagePerMaxLines()
    local totalLines = messageWidget:GetMessageLines()
    w.currentBubbleTypes[#w.currentBubbleTypes + 1] = currentBubbleType
    while true do
      if fastQuestChatBubble then
        local nextMessage, nextBubbleType, isAutoFireEnd = X2:GetQuestChatBubbleNextSpeech(w.currentBubbleTypes[#w.currentBubbleTypes], true)
        if nextMessage == nil then
          break
        end
        messageAuthor:SetText(author)
        messageWidget:AddMessage(string.format("%s%s", color, nextMessage))
        totalLines = messageWidget:GetMessageLines()
        if pagePerMaxLines < totalLines then
          X2:AdjustQuestChatBubbleAutoFireEnd(w.currentBubbleTypes[#w.currentBubbleTypes])
          totalLines = messageWidget:RemoveLastMessage()
          break
        end
        w.currentBubbleTypes[#w.currentBubbleTypes + 1] = nextBubbleType
      elseif isAutoFireEnd then
        break
      end
    end
    if X2:HasNextQuestChat(w.currentBubbleTypes[#w.currentBubbleTypes]) then
      w.nextButton:Show(true)
      w.confirmButton:Show(false)
      w.forceSkipButton:Show(true)
      if fadeWnd.fadingNow == false then
        w.nextButton:Enable(true)
        w.confirmButton:Enable(false)
        w.forceSkipButton:Enable(true)
      end
    else
      w.showRewardStep = UpdateRewardState(w.rewardFrame, w.directingType, qtype)
      w.nextButton:Show(w.showRewardStep)
      w.nextButton:Enable(w.showRewardStep)
      w.confirmButton:Show(not w.showRewardStep)
      w.confirmButton:Enable(not w.showRewardStep)
      w.forceSkipButton:Show(w.showRewardStep)
      w.forceSkipButton:Enable(w.showRewardStep)
    end
    if questLocale.autoMessageScroll then
      local currentLine = messageWidget:GetCurrentScroll()
      local scrollBar = w.scrollBar
      scrollBar:SetScroll(totalLines, currentLine, pagePerMaxLines)
    else
      messageWidget:SetScrollPos(0)
      scrollBar:SetScroll(totalLines, 0, pagePerMaxLines)
    end
  end,
  QUEST_CONTEXT_UPDATED = function(qtype, condition)
    local w = questDirecting
    if w:IsVisible() == false then
      return
    end
    UIParent:LogAlways(string.format("[LOG] QUEST_CONTEXT_UPDATED WQType[%s] AQtype[%s], condition[%s]", tostring(w.questType), tostring(qtype), condition))
    if w.questType ~= qtype then
      return
    end
    if condition == "started" and w.directingType == DIRECTING_TYPE.START then
      EndDirectingMode()
    elseif condition == "updated" and w.directingType == DIRECTING_TYPE.PROGRESS_TALK then
      EndDirectingMode()
    elseif condition == "completed" and w.directingType == DIRECTING_TYPE.COMPLETE then
      local acceptable, nextQuestType = X2Quest:IsNextQuestAcceptableForDirecting(w.questType)
      UIParent:LogAlways(string.format("[LOG] QUEST_CONTEXT_UPDATED acceptable[%s] NQType[%d]", tostring(acceptable), nextQuestType))
      if acceptable == true then
        StartNextQuest(nextQuestType)
      else
        EndDirectingMode()
      end
    else
      return
    end
  end,
  QUEST_QUICK_CLOSE_EVENT = function(qtype)
    local w = questDirecting
    if w:IsVisible() == false then
      return
    end
    if w.questType ~= qtype then
      return
    end
    directingFadeTime = 0
    EndDirectingMode()
  end,
  QUEST_ERROR_INFO = function(errNum, qtype)
    if questDirecting:IsVisible() == false then
      return
    end
    if questDirecting.questType ~= qtype then
      return
    end
    EndDirectingMode()
  end,
  LEFT_LOADING = function()
    InteractionEnd()
  end,
  NPC_INTERACTION_END = function()
    InteractionEnd()
  end,
  INTERACTION_END = function()
    InteractionEnd()
  end,
  QUEST_DIRECTING_MODE_END = function()
    if questDirecting:IsVisible() == false then
      return
    end
    CancelQuestDirectingMode()
  end,
  QUEST_DIRECTING_MODE_HOT_KEY = function(arg)
    if fadeWnd.fadingNow == true then
      return
    end
    local nextButton = questDirecting.nextButton
    local prevButton = questDirecting.prevButton
    local confirmButton = questDirecting.confirmButton
    local forceSkipButton = questDirecting.forceSkipButton
    if arg == 1 then
      prevButton:OnClick("LeftButton")
    elseif arg == 2 then
      if nextButton:IsVisible() == true and nextButton:IsEnabled() == true then
        nextButton:OnClick("LeftButton")
      elseif confirmButton:IsVisible() == true and confirmButton:IsEnabled() == true then
        confirmButton:OnClick("LeftButton")
      end
    elseif arg == 3 then
      if forceSkipButton:IsVisible() == true and forceSkipButton:IsEnabled() == true then
        if questDirecting.directingType ~= DIRECTING_TYPE.PROGRESS_TALK then
          forceSkipButton:OnClick("LeftButton")
        end
      elseif confirmButton:IsVisible() == true and confirmButton:IsEnabled() == true then
        confirmButton:OnClick("LeftButton")
      end
    end
    F_SOUND.PlayUISound("event_quest_directing_mode", true)
  end
}
questDirecting:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(questDirecting, events)
function CancelQuestDirectingMode()
  X2Quest:DeclineDirectingQuest()
  CloseQuestDirectingWnd()
end
