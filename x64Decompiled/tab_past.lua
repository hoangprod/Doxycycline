local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateCutSceneJournal(parent)
  local cutSceneJournal = parent:CreateChildWidget("emptywidget", "cutSceneJournal", 0, true)
  cutSceneJournal:SetExtent(380, 415)
  cutSceneJournal:AddAnchor("TOPLEFT", parent, "TOPRIGHT", 5, 0)
  local title = cutSceneJournal:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.XLARGE)
  title.style:SetFontSize(FONT_SIZE.XLARGE)
  title:AddAnchor("TOP", cutSceneJournal, 0, sideMargin)
  ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
  local bg = CreateContentBackground(title, "TYPE8", "brown_2")
  bg:SetVisible(false)
  bg:SetHeight(64)
  bg:AddAnchor("CENTER", title, 3, 0)
  title.bg = bg
  local replayButton = cutSceneJournal:CreateChildWidget("button", "replayButton", 0, true)
  replayButton:Show(false)
  replayButton:SetText(locale.questContext.replay)
  replayButton:AddAnchor("CENTER", cutSceneJournal, -5, 0)
  ApplyButtonSkin(replayButton, BUTTON_CONTENTS.CUTSCENE_REPLAY)
  return cutSceneJournal
end
local function SetViewOfPastTabWindow(tabWindow)
  local sliderList = W_CTRL.CreateScrollListBox("sliderList", tabWindow, tabWindow)
  sliderList:AddAnchor("TOPLEFT", tabWindow, 0, sideMargin / 1.5)
  sliderList:AddAnchor("BOTTOMRIGHT", tabWindow, 0, -sideMargin)
  sliderList.bg:RemoveAllAnchors()
  sliderList.bg:AddAnchor("TOPLEFT", tabWindow, -sideMargin, -sideMargin)
  sliderList.bg:AddAnchor("BOTTOMRIGHT", tabWindow, sideMargin, sideMargin + sideMargin)
  CreateCutSceneJournal(tabWindow)
end
function CreatePastTabWindow(tabWindow)
  SetViewOfPastTabWindow(tabWindow)
  function tabWindow.sliderList:OnSelChanged()
    local selIndex = self.content:GetSelectedIndex()
    local questName = self.content:GetSelectedText()
    tabWindow.cutSceneJournal.title:SetText(questName)
    tabWindow.cutSceneJournal.title.bg:SetVisible(true)
    local titleWidth = tabWindow.cutSceneJournal.title:GetWidth()
    if titleWidth <= 200 then
      tabWindow.cutSceneJournal.title.bg:SetWidth(260)
    else
      tabWindow.cutSceneJournal.title.bg:SetWidth(titleWidth + titleWidth / 3)
    end
    tabWindow.cutSceneJournal.replayButton:Show(true)
  end
  local replayButton = tabWindow.cutSceneJournal.replayButton
  function replayButton:OnClick()
    local selIndex = tabWindow.sliderList.content:GetSelectedIndex() + 1
    X2Player:PlayCinema(tabWindow.cutSceneJournal.cinemaList[selIndex])
  end
  replayButton:SetHandler("OnClick", replayButton.OnClick)
  tabWindow.cutSceneJournal.cinemaList = {}
  function tabWindow.sliderList:FillList()
    self.content:ClearItem()
    local pastQuestList = X2Quest:GetMainQuestCutSceneReplayList()
    if pastQuestList == nil then
      self:SetMinMaxValues(0, 0)
      return
    end
    for i = 1, #pastQuestList do
      local str = string.format("%d. %s", i, pastQuestList[i].name)
      self:AppendItem(str, i)
      tabWindow.cutSceneJournal.cinemaList[i] = pastQuestList[i].cinema
    end
  end
  tabWindow.sliderList:FillList()
end
