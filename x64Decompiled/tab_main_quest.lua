local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateJournal(parent)
  local journal = CreateQuestJournal("journal", parent, "questList")
  journal:SetExtent(380, 450)
  journal:SetContentsWidth()
  local mapViewBtn = journal:CreateChildWidget("button", "mapViewBtn", 0, true)
  mapViewBtn:AddAnchor("BOTTOMRIGHT", journal, "BOTTOM", 0, -sideMargin)
  mapViewBtn:SetText(locale.questContext.openMap)
  ApplyButtonSkin(mapViewBtn, BUTTON_BASIC.DEFAULT)
  local function MapViewBtnLeftClickFunc()
    local questType = journal:GetCurQuestType()
    if questType == nil then
      return
    end
    ToggleMapWithQuest(questType)
  end
  ButtonOnClickHandler(mapViewBtn, MapViewBtnLeftClickFunc)
  local questDropBtn = journal:CreateChildWidget("button", "questDropBtn", 0, true)
  questDropBtn:AddAnchor("BOTTOMLEFT", journal, "BOTTOM", 0, -sideMargin)
  questDropBtn:SetText(locale.questContext.giveup)
  ApplyButtonSkin(questDropBtn, BUTTON_BASIC.DEFAULT)
  local replayButton = journal:CreateChildWidget("button", "replayButton", 0, true)
  replayButton:Show(false)
  replayButton:SetText(locale.questContext.replay)
  replayButton:AddAnchor("BOTTOM", journal, "BOTTOM", 0, -sideMargin)
  ApplyButtonSkin(replayButton, BUTTON_BASIC.DEFAULT)
  function replayButton:OnClick()
    X2Player:PlayCinemaByQuestType(journal:GetCurQuestType())
  end
  replayButton:SetHandler("OnClick", replayButton.OnClick)
  local function MapViewBtnLeftClickFunc()
    local questType = journal:GetCurQuestType()
    if questType == nil then
      return
    end
    ToggleMapWithQuest(questType)
  end
  ButtonOnClickHandler(mapViewBtn, MapViewBtnLeftClickFunc)
  local buttonTable = {mapViewBtn, questDropBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  local function QuestDropBtnLeftClickFunc()
    local questType = journal:GetCurQuestType()
    if questType == nil then
      return
    end
    local idx = IndexFromQuestType(questType)
    local questLevel = X2Quest:GetActiveQuestLevel(idx)
    local function DialogHandler(wnd)
      local content = string.format([[
%s[%s]
|r%s]], FONT_COLOR_HEX.TITLE, X2Quest:GetQuestJournalTitle(idx), locale.questContext.descAbandonQuest)
      wnd:SetTitle(locale.questContext.abandonQuest)
      wnd:SetContent(content)
      function wnd:OkProc()
        X2Quest:QuestContextDrop(idx)
        RemoveQuestListCheckBoxState(questType)
        ActiveOtherMainQuest(questType)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
  end
  ButtonOnClickHandler(questDropBtn, QuestDropBtnLeftClickFunc)
  function journal:JournalProc()
    local questType = self:GetCurQuestType()
    if questType == nil then
      self.mapViewBtn:Enable(false)
      self.questDropBtn:Enable(false)
      return
    end
    self.mapViewBtn:Enable(X2Decal:CanMakeDirectionGuide(questType))
    if X2Quest:IsCompleted(questType) == true or X2Quest:GetActiveQuestListStatusByType(questType) == 0 then
      self.mapViewBtn:Enable(false)
      self.questDropBtn:Enable(false)
    else
      self.questDropBtn:Enable(true)
    end
  end
  return journal
end
function SetViewOfMainQuestTabWindow(tabWindow)
  local bg = CreateContentBackground(tabWindow, "TYPE3", "brown")
  bg:AddAnchor("TOPLEFT", tabWindow, -sideMargin, -sideMargin)
  bg:AddAnchor("BOTTOMRIGHT", tabWindow, sideMargin, sideMargin + sideMargin)
  local scrollWnd = CreateScrollWindow(tabWindow, "scrollWnd", 0)
  scrollWnd:Show(true)
  scrollWnd:AddAnchor("TOPLEFT", tabWindow, 0, sideMargin / 2)
  scrollWnd:AddAnchor("BOTTOMRIGHT", tabWindow, 0, -sideMargin + -5)
  tabWindow.scrollWnd = scrollWnd
  local emptyWidget = UIParent:CreateWidget("emptywidget", scrollWnd:GetId() .. ".emptywidget", scrollWnd.content)
  emptyWidget:Show(false)
  emptyWidget:SetExtent(scrollWnd.content:GetWidth(), scrollWnd.content:GetHeight())
  emptyWidget:AddAnchor("TOPLEFT", scrollWnd.content, 0, 0)
  scrollWnd.emptyWidget = emptyWidget
  local guide = W_ICON.CreateGuideIconWidget(tabWindow)
  guide:AddAnchor("BOTTOMLEFT", tabWindow, 0, 0)
  tabWindow.guide = guide
  local function CreateGuideTip(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, false)
    frame:Show(false)
    CreateTooltipDrawable(frame)
    local title = frame:CreateChildWidget("label", "title", 0, true)
    title:SetAutoResize(true)
    title:AddAnchor("TOPLEFT", frame, sideMargin, sideMargin)
    title:SetHeight(FONT_SIZE.MIDDLE)
    ApplyTextColor(title, FONT_COLOR.SOFT_BROWN)
    local questDetailIcon = {}
    questDetailIcon[1] = frame:CreateDrawable(TEXTURE_PATH.QUEST_LIST, "main", "artwork")
    questDetailIcon[1]:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, questLocale.guideTipIcon.coords[1])
    questDetailIcon[2] = frame:CreateDrawable(TEXTURE_PATH.QUEST_LIST, "daily", "artwork")
    questDetailIcon[2]:AddAnchor("TOPLEFT", questDetailIcon[1], "BOTTOMLEFT", 0, questLocale.guideTipIcon.coords[2])
    questDetailIcon[3] = frame:CreateDrawable(TEXTURE_PATH.QUEST_LIST, "daily_hunt", "artwork")
    questDetailIcon[3]:AddAnchor("TOPLEFT", questDetailIcon[2], "BOTTOMLEFT", 0, questLocale.guideTipIcon.coords[3])
    questDetailIcon[4] = frame:CreateDrawable(TEXTURE_PATH.QUEST_LIST, "group", "artwork")
    questDetailIcon[4]:AddAnchor("TOPLEFT", questDetailIcon[3], "BOTTOMLEFT", 0, questLocale.guideTipIcon.coords[4])
    questDetailIcon[5] = frame:CreateDrawable(TEXTURE_PATH.QUEST_LIST, "livelihood", "artwork")
    questDetailIcon[5]:AddAnchor("TOPLEFT", questDetailIcon[4], "BOTTOMLEFT", 0, questLocale.guideTipIcon.coords[5])
    local body = frame:CreateChildWidget("textbox", "body", 0, true)
    body:SetWidth(1000)
    body:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 23, questLocale.guideTipHeight)
    body:SetLineSpace(TEXTBOX_LINE_SPACE.QUESTGUIDE)
    body.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(body, FONT_COLOR.SOFT_BROWN)
    function frame:SetTooltip(titleStr, bodyStr)
      self.title:SetText(titleStr)
      self.body:SetWidth(1000)
      self.body:SetText(bodyStr)
      self.body:SetExtent(self.body:GetLongestLineWidth() + 5, body:GetTextHeight())
      local width = self.body:GetLongestLineWidth() + 3 + questDetailIcon[1]:GetWidth()
      if width < self.title:GetWidth() then
        width = self.title:GetWidth()
      end
      width = width + sideMargin * 2
      local height = title:GetHeight() + body:GetTextHeight() + 8 + sideMargin * 2
      self:SetExtent(width, height)
    end
    return frame
  end
  local tip = CreateGuideTip("tip", guide)
  guide.tip = tip
  local arrow = DrawArrowMoveAnim(guide)
  arrow:AddAnchor("RIGHT", guide, "LEFT", -30, 0)
  guide.arrow = arrow
  local questCount = tabWindow:CreateChildWidget("textbox", "questCount", 0, true)
  questCount:Show(true)
  questCount:SetHeight(FONT_SIZE.MIDDLE)
  questCount:AddAnchor("LEFT", guide, "RIGHT", 3, 0)
  questCount.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(questCount, FONT_COLOR.TITLE)
  local bg = CreateContentBackground(questCount, "TYPE6", "brown")
  bg:SetExtent(120, 32)
  bg:AddAnchor("LEFT", questCount, -8, 0)
  local journal = CreateJournal(tabWindow)
  journal:AddAnchor("TOPLEFT", tabWindow, "TOPRIGHT", sideMargin / 2, -(sideMargin * 1.5))
  tabWindow.journal = journal
end
function CreateMainQuestTabWindow(tabWindow)
  SetViewOfMainQuestTabWindow(tabWindow)
end
