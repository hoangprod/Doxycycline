local progressTab = questContext.contextListBack.tab.window[1]
local mainQuestTab = questContext.contextListBack.tab.window[2]
local bMakedMainQuest = false
local objectiveEmptyWidgetConfig = {}
objectiveEmptyWidgetConfig.width = 225
objectiveEmptyWidgetConfig.checkBoxInset = {
  20,
  5,
  0,
  0
}
objectiveEmptyWidgetConfig.lastRowHeight = 8
local bAllCompleted = false
function IsAllCompleted()
  return bAllCompleted
end
function SetAllCompleted(completed)
  bAllCompleted = completed
end
local buttonPool = {}
local buttonPoolCount = 0
local mainButtonPool = {}
local mainButtonPoolCount = 0
local function GetCheckButtonFromPool(parent)
  if buttonPool[parent] == nil then
    buttonPool[parent] = {}
  end
  local buttons = buttonPool[parent]
  local buttonCount = table.getn(buttons)
  local btn
  for i = 1, buttonCount do
    local existBtn = buttons[i]
    if existBtn.isUsed == false then
      btn = existBtn
      btn:SetChecked(false)
      btn.isUsed = true
      break
    end
  end
  if btn == nil then
    buttonPoolCount = buttonPoolCount + 1
    local id = string.format("ButtonPoolItem.%d", buttonPoolCount)
    btn = CreateCheckButton(id, parent)
    btn.isUsed = true
    local OnEnter = function(self)
      if self:IsEnabled() then
        return
      end
      SetTooltip(GetUIText(COMMON_TEXT, "race_quest_register_condition"), self)
    end
    btn:SetHandler("OnEnter", OnEnter)
    table.insert(buttons, btn)
  end
  return btn
end
local function GetMainCheckButtonFromPool(parent, qtype)
  if mainButtonPool[parent] == nil then
    mainButtonPool[parent] = {}
  end
  local buttons = mainButtonPool[parent]
  local buttonCount = table.getn(buttons)
  local btn
  for i = 1, buttonCount do
    local existBtn = buttons[i]
    if qtype ~= nil then
      if existBtn.questType == qtype then
        btn = existBtn
        btn.isUsed = true
        break
      end
    elseif existBtn.isUsed == false then
      btn = existBtn
      btn:SetChecked(false)
      btn.isUsed = true
      break
    end
  end
  if btn == nil then
    mainButtonPoolCount = mainButtonPoolCount + 1
    local id = string.format("mainButtonPoolItem.%d", mainButtonPoolCount)
    btn = CreateCheckButton(id, parent)
    btn.isUsed = true
    local OnEnter = function(self)
      if self:IsEnabled() then
        return
      end
      SetTooltip(GetUIText(COMMON_TEXT, "race_quest_register_condition"), self)
    end
    btn:SetHandler("OnEnter", OnEnter)
    table.insert(buttons, btn)
  end
  return btn
end
local function ResetButtonPool()
  for _, buttons in pairs(buttonPool) do
    for _, btn in pairs(buttons) do
      btn:Show(false)
      btn:RemoveAllAnchors()
      btn.questType = nil
      btn.isUsed = false
    end
  end
end
local function ResetMainButtonPool()
  for _, buttons in pairs(mainButtonPool) do
    for _, btn in pairs(buttons) do
      btn:Show(false)
      btn:RemoveAllAnchors()
      btn.questType = nil
      btn.isUsed = false
    end
  end
end
local SetViewOfMultilineEditbox = function(id, parent)
  local widget = UIParent:CreateWidget("textbox", id, parent)
  widget:SetExtent(170, 60)
  widget:SetInset(0, 0, 0, 0)
  widget:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  widget.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  widget.style:SetAlign(ALIGN_TOP_LEFT)
  widget.style:SetSnap(true)
  return widget
end
local SetFolderControlHandler = function(widget, folder)
  widget.folder = folder
  function widget:OnClick()
    if self.folder == nil then
      return
    end
    self.folder:ToggleState()
  end
  widget:SetHandler("OnClick", widget.OnClick)
end
local function SetViewOfFolder(id, parent)
  local fld = UIParent:CreateWidget("folder", id, parent)
  fld:SetAnimateStep(1.3)
  local closeBtn = CreateEmptyButton(id .. ".closeBtn", fld)
  closeBtn:Show(true)
  closeBtn:AddAnchor("TOPLEFT", fld, 0, 7)
  ApplyButtonSkin(closeBtn, BUTTON_BASIC.FOLDER_CLOSE)
  local openBtn = CreateEmptyButton(id .. ".openBtn", fld)
  openBtn:Show(true)
  openBtn:AddAnchor("TOPLEFT", fld, 0, 5)
  ApplyButtonSkin(openBtn, BUTTON_BASIC.FOLDER_OPEN)
  SetFolderControlHandler(closeBtn, fld)
  SetFolderControlHandler(openBtn, fld)
  fld:SetOpenStateButton(closeBtn)
  fld:SetCloseStateButton(openBtn)
  fld.btnClose = closeBtn
  fld.btnOpen = openBtn
  fld.titleBtn = CreateEmptyButton(id .. ".titleBtn", fld)
  fld.titleBtn:Show(true)
  fld.titleBtn.style:SetEllipsis(true)
  fld.titleBtn.style:SetAlign(ALIGN_LEFT)
  fld.titleBtn.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  SetButtonFontColor(fld.titleBtn, GetTitleButtonFontColor())
  local OnEnter = function(self)
    local text = self.tooltip
    if text == "" then
      text = self:GetText()
    end
    if text == "" then
      return
    end
    SetTooltip(text, self)
  end
  fld.titleBtn:SetHandler("OnEnter", OnEnter)
  fld:SetTitleButtonWidget(fld.titleBtn)
  SetFolderControlHandler(fld.titleBtn, fld)
  fld:SetInset(23, 3, 0, 2)
  fld.style:SetSnap(true)
  fld.style:SetAlign(ALIGN_LEFT)
  return fld
end
local labelPool = {}
local labelPoolCount = 0
local mainLabelPool = {}
local mainLabelPoolCount = 0
local function GetLabelFromPool(parent)
  if labelPool[parent] == nil then
    labelPool[parent] = {}
  end
  local labels = labelPool[parent]
  local labelCount = table.getn(labels)
  local lab
  for i = 1, labelCount do
    local existLab = labels[i]
    if existLab.isUsed == false then
      lab = existLab
      lab.isUsed = true
      break
    end
  end
  if lab == nil then
    labelPoolCount = labelPoolCount + 1
    local id = string.format("LabelPoolItem.%d", labelPoolCount)
    lab = SetViewOfMultilineEditbox(id, parent)
    lab.isUsed = true
    lab.questDetailIcon = lab:CreateImageDrawable(TEXTURE_PATH.QUEST_LIST, "overlay")
    lab.questDetailIcon:AddAnchor("TOPLEFT", lab, "TOPRIGHT", 0, -2)
    lab.questDetailIcon:SetVisible(false)
    lab.currentDrawable = lab:CreateDrawable(TEXTURE_PATH.DEFAULT, "label_bg", "background")
    lab.currentDrawable:SetTextureColor("light_blue")
    lab.currentDrawable:AddAnchor("TOPLEFT", lab, "TOPLEFT", 0, -6)
    lab.currentDrawable:AddAnchor("BOTTOMRIGHT", lab, "BOTTOMRIGHT", 30, 8)
    lab.currentDrawable:SetVisible(false)
    lab.selectedDrawable = lab:CreateDrawable(TEXTURE_PATH.DEFAULT, "label_bg", "background")
    lab.selectedDrawable:SetTextureColor("light_blue")
    lab.selectedDrawable:AddAnchor("TOPLEFT", lab, "TOPLEFT", 0, -6)
    lab.selectedDrawable:AddAnchor("BOTTOMRIGHT", lab, "BOTTOMRIGHT", 30, 8)
    lab.selectedDrawable:SetVisible(false)
    table.insert(labels, lab)
  end
  return lab
end
local function GetMainLabelFromPool(parent, qtype)
  if mainLabelPool[parent] == nil then
    mainLabelPool[parent] = {}
  end
  local labels = mainLabelPool[parent]
  local labelCount = table.getn(labels)
  local lab
  for i = 1, labelCount do
    local existLab = labels[i]
    if qtype ~= nil then
      if existLab.questType == qtype then
        lab = existLab
        lab.isUsed = true
        break
      end
    elseif existLab.isUsed == false then
      lab = existLab
      lab.isUsed = true
      break
    end
  end
  if lab == nil then
    labelPoolCount = labelPoolCount + 1
    local id = string.format("MainLabelPoolItem.%d", labelPoolCount)
    lab = SetViewOfMultilineEditbox(id, parent)
    lab.isUsed = true
    lab.questDetailIcon = lab:CreateImageDrawable(TEXTURE_PATH.QUEST_LIST, "overlay")
    lab.questDetailIcon:AddAnchor("TOPLEFT", lab, "TOPRIGHT", 0, -2)
    lab.questDetailIcon:SetVisible(false)
    lab.currentDrawable = lab:CreateDrawable(TEXTURE_PATH.DEFAULT, "label_bg", "background")
    lab.currentDrawable:SetTextureColor("light_blue")
    lab.currentDrawable:AddAnchor("TOPLEFT", lab, "TOPLEFT", 0, -6)
    lab.currentDrawable:AddAnchor("BOTTOMRIGHT", lab, "BOTTOMRIGHT", 30, 8)
    lab.currentDrawable:SetVisible(false)
    lab.selectedDrawable = lab:CreateDrawable(TEXTURE_PATH.DEFAULT, "label_bg", "background")
    lab.selectedDrawable:SetTextureColor("light_blue")
    lab.selectedDrawable:AddAnchor("TOPLEFT", lab, "TOPLEFT", 0, -6)
    lab.selectedDrawable:AddAnchor("BOTTOMRIGHT", lab, "BOTTOMRIGHT", 30, 8)
    lab.selectedDrawable:SetVisible(false)
    table.insert(labels, lab)
  end
  return lab
end
local function ResetLabelPool()
  for _, labels in pairs(labelPool) do
    for _, lab in pairs(labels) do
      lab:Show(false)
      lab:RemoveAllAnchors()
      lab.questDetailIcon:SetVisible(false)
      lab.currentDrawable:SetVisible(false)
      lab.selectedDrawable:SetVisible(false)
      lab.isUsed = false
    end
  end
end
local function ResetMainLabelPool()
  for _, labels in pairs(mainLabelPool) do
    for _, lab in pairs(labels) do
      lab:Show(false)
      lab:RemoveAllAnchors()
      lab.questDetailIcon:SetVisible(false)
      lab.currentDrawable:SetVisible(false)
      lab.selectedDrawable:SetVisible(false)
      lab.isUsed = false
      lab.questType = nil
    end
  end
end
local folderPool = {}
local folderPoolCount = 0
local mainFolderPool = {}
local mainFolderPoolCount = 0
local function GetFolderFromPool(parent)
  if folderPool[parent] == nil then
    folderPool[parent] = {}
  end
  local folders = folderPool[parent]
  local folderCount = table.getn(folders)
  local fld
  for _, existFld in pairs(folders) do
    if existFld.isUsed == false then
      fld = existFld
      fld.isUsed = true
      break
    end
  end
  if fld == nil then
    folderPoolCount = folderPoolCount + 1
    local id = string.format("folderPoolItem.%d", folderPoolCount)
    fld = SetViewOfFolder(id, parent)
    fld.isUsed = true
    table.insert(folders, fld)
  end
  return fld
end
local function GetMainFolderFromPool(parent, chapterIdx)
  if mainFolderPool[parent] == nil then
    mainFolderPool[parent] = {}
  end
  local folders = mainFolderPool[parent]
  local folderCount = table.getn(folders)
  local fld
  for _, existFld in pairs(folders) do
    if chapterIdx ~= nil then
      if existFld.chapterIdx == chapterIdx then
        fld = existFld
        fld.isUsed = true
        break
      end
    elseif existFld.isUsed == false then
      fld = existFld
      fld.isUsed = true
      break
    end
  end
  if fld == nil then
    mainFolderPoolCount = mainFolderPoolCount + 1
    local id = string.format("mainFolderPoolItem.%d", mainFolderPoolCount)
    fld = SetViewOfFolder(id, parent)
    fld.isUsed = true
    table.insert(folders, fld)
  end
  return fld
end
local function ResetFolderPool()
  for _, folder in pairs(folderPool) do
    for _, fld in pairs(folder) do
      if fld.isUsed ~= nil and fld.isUsed == false then
        fld:CloseFolder()
      else
        fld.isUsed = false
      end
      local titleHeight = FOLER_ITEM_LIST_HEIGHT
      fld:RemoveAllAnchors()
      fld:SetTitleHeight(titleHeight)
      fld:SetExtendLength(0)
      fld:Show(false)
    end
  end
end
local function ResetMainFolderPool()
  for _, folder in pairs(mainFolderPool) do
    for _, fld in pairs(folder) do
      if fld.isUsed ~= nil and fld.isUsed == false then
        fld:CloseFolder()
      else
        fld.isUsed = false
      end
      local titleHeight = FOLER_ITEM_LIST_HEIGHT
      fld:RemoveAllAnchors()
      fld:SetTitleHeight(titleHeight)
      fld:SetExtendLength(0)
      fld:Show(false)
      fld.chapterIdx = nil
    end
  end
end
local emptyWidgetPool = {}
local emptyWidgetPoolCount = 0
local mainEmptyWidgetPool = {}
local mainEmptyWidgetPoolCount = 0
local function GetEmptyWidgetFromPool(parent)
  if emptyWidgetPool[parent] == nil then
    emptyWidgetPool[parent] = {}
  end
  local emptyWidgets = emptyWidgetPool[parent]
  local emptyWidgetCount = table.getn(emptyWidgets)
  local emptyWidget
  for i = 1, emptyWidgetCount do
    local existEmptyWidget = emptyWidgets[i]
    if existEmptyWidget.isUsed == false then
      emptyWidget = existEmptyWidget
      emptyWidget.isUsed = true
      break
    end
  end
  if emptyWidget == nil then
    local id = string.format("emptyWidgetPoolItem.%d", emptyWidgetCount + 1)
    parent = parent or "UIParent"
    emptyWidget = UIParent:CreateWidget("emptywidget", id, parent)
    emptyWidget.isUsed = true
    table.insert(emptyWidgets, emptyWidget)
  end
  return emptyWidget
end
local function GetMainEmptyWidgetFromPool(parent)
  if mainEmptyWidgetPool[parent] == nil then
    mainEmptyWidgetPool[parent] = {}
  end
  local emptyWidgets = mainEmptyWidgetPool[parent]
  local emptyWidgetCount = table.getn(emptyWidgets)
  local emptyWidget
  for i = 1, emptyWidgetCount do
    local existEmptyWidget = emptyWidgets[i]
    if existEmptyWidget.isUsed == false then
      emptyWidget = existEmptyWidget
      emptyWidget.isUsed = true
      break
    end
  end
  if emptyWidget == nil then
    local id = string.format("mainEmptyWidgetPoolItem.%d", emptyWidgetCount + 1)
    parent = parent or "UIParent"
    emptyWidget = UIParent:CreateWidget("emptywidget", id, parent)
    emptyWidget.isUsed = true
    table.insert(emptyWidgets, emptyWidget)
  end
  return emptyWidget
end
local function ResetEmptyWidgetPool()
  for _, emptyWidgets in pairs(emptyWidgetPool) do
    for _, emptyWidget in pairs(emptyWidgets) do
      emptyWidget:Show(false)
      emptyWidget.questIndex = nil
      emptyWidget.questType = nil
      emptyWidget.title = nil
      emptyWidget.checkBox = nil
      emptyWidget.index = nil
      emptyWidget.folderWidget = nil
      emptyWidget:ReleaseHandler("OnClick")
      emptyWidget:ReleaseHandler("OnEnter")
      emptyWidget:ReleaseHandler("OnLeave")
      emptyWidget:RemoveAllAnchors()
      emptyWidget.isUsed = false
    end
  end
end
local function ResetMainEmptyWidgetPool()
  for _, emptyWidgets in pairs(mainEmptyWidgetPool) do
    for _, emptyWidget in pairs(emptyWidgets) do
      emptyWidget:Show(false)
      emptyWidget.questIndex = nil
      emptyWidget.questType = nil
      emptyWidget.title = nil
      emptyWidget.checkBox = nil
      emptyWidget.index = nil
      emptyWidget.folderWidget = nil
      emptyWidget:ReleaseHandler("OnClick")
      emptyWidget:ReleaseHandler("OnEnter")
      emptyWidget:ReleaseHandler("OnLeave")
      emptyWidget:RemoveAllAnchors()
      emptyWidget.isUsed = false
    end
  end
end
local questFolders = {}
local mainQuestFolders = {}
function GetQuestFolderByName(name)
  local questFolder = mainQuestFolders[name]
  if questFolder == nil then
    questFolder = questFolders[name]
  end
  return questFolder
end
function GetQuestFolderByChapterIdx(chapterIdx)
  local questFolder = mainQuestFolders[chapterIdx]
  return questFolder
end
local function SetQuestFolderByName(name, folder, bMainQuest)
  if bMainQuest == true then
    mainQuestFolders[name] = folder
  else
    questFolders[name] = folder
  end
end
local function SetQuestFolderByChapter(folder, bMainQuest)
  if bMainQuest == true then
    mainQuestFolders[folder.chapterIdx] = folder
  end
end
local questCheckBox = {}
local function GetQuestCheckBoxByType(qtype)
  return questCheckBox[qtype]
end
local function SetQuestCheckBoxByType(qtype, checkBox)
  questCheckBox[qtype] = checkBox
end
local function ResetQuestCheckBoxByType()
  questCheckBox = {}
end
local questContextStateValues, questContextUiCount
local function InitEmptyQuestListData()
  if questContextStateValues == nil then
    questContextStateValues = {}
  end
  if questContextStateValues.folderStates == nil then
    questContextStateValues.folderStates = {}
  end
  if questContextStateValues.lastDetailQuestType == nil then
    questContextStateValues.lastDetailQuestType = {}
  end
  if questContextStateValues.checkBoxStates == nil then
    questContextStateValues.checkBoxStates = {}
    local count = X2Quest:GetActiveQuestListCount()
    for i = 1, count do
      local qtype = X2Quest:GetActiveQuestType(i)
      if AddableQuest(qtype) then
        questContextStateValues.checkBoxStates[qtype] = true
      end
    end
  end
end
InitEmptyQuestListData()
local function SaveQuestContextValues()
  X2:SetQuestContextStateValuesUiData(questContextStateValues)
end
local function UpdateActiveQuestCountText(widget)
  local questCount = widget.questCount
  local str
  local consolAttr = Console:GetAttribute("ui_draw_quest_type")
  if consolAttr ~= nil and tonumber(consolAttr) == 1 then
    str = string.format("%s %s%s/%s", locale.questContext.questCount, FONT_COLOR_HEX.BLUE, tostring(questContextCheckedUiCount), tostring(questContextUiCount))
  else
    str = string.format("%s %s%s", locale.questContext.questCount, FONT_COLOR_HEX.BLUE, tostring(questContextUiCount))
  end
  questCount:SetWidth(500)
  questCount:SetText(str)
  questCount:SetWidth(questCount:GetLongestLineWidth() + 5)
  local countInfo = X2Quest:GetMaxLimitCountInfo()
  local titleStr = GetUIText(COMMON_TEXT, "quest_max_limit_count")
  local bodyStr = ""
  for i = 1, #countInfo do
    local detailInfo = countInfo[i]
    local countStr = string.format("%s%d|r/%d", FONT_COLOR_HEX.SKYBLUE, detailInfo.curCount, detailInfo.maxCount)
    if detailInfo.curCount == detailInfo.maxCount then
      countStr = string.format("%s%d/%d|r", FONT_COLOR_HEX.RED, detailInfo.curCount, detailInfo.maxCount)
    end
    local nameStr = GetUIText(COMMON_TEXT, string.format("quest_detail_%s", detailInfo.name_key))
    if bodyStr == "" then
      bodyStr = string.format("%s %s", nameStr, countStr)
    else
      bodyStr = string.format([[
%s
%s %s]], bodyStr, nameStr, countStr)
    end
  end
  widget.guide.tip:SetTooltip(titleStr, bodyStr)
  local function OnEnter()
    SetDefaultTooltipAnchor(widget.guide, widget.guide.tip)
    widget.guide.tip:Show(true)
  end
  widget.guide:SetHandler("OnEnter", OnEnter)
  local function OnLeave()
    widget.guide.tip:Show(false)
  end
  widget.guide:SetHandler("OnLeave", OnLeave)
end
function InitQuestListData(bEnterWorld)
  if bEnterWorld == nil then
    bEnterWorld = false
  end
  questContextStateValues = X2:GetQuestContextStateValuesUiData()
  InitEmptyQuestListData()
  local tempQuestList = {}
  for questType, state in pairs(questContextStateValues.checkBoxStates) do
    if IsExistQuestTypeInJournal(questType) and AddableQuest(questType) then
      tempQuestList[questType] = state
    else
      if X2Quest:IsMainQuest(questType) then
        tempQuestList[questType] = false
      end
      missMatch = true
    end
  end
  if missMatch then
    questContextStateValues.checkBoxStates = nil
    questContextStateValues.checkBoxStates = tempQuestList
    SaveQuestContextValues()
  end
  questContextUiCount = 0
  questContextCheckedUiCount = 0
  local count = X2Quest:GetActiveQuestListCount()
  for i = 1, count do
    local qtype = X2Quest:GetActiveQuestType(i)
    if AddableQuest(qtype) then
      if X2Quest:IsMainQuest(qtype) ~= true then
        questContextStateValues.checkBoxStates[qtype] = HasNotifierQuestList(qtype)
      elseif bEnterWorld == true and X2Quest:GetActiveQuestListStatusByType(qtype) ~= 0 and X2Quest:IsCompleted(qtype) == false then
        local decalIndex = GetNotifierEmptyDecal(qtype)
        if decalIndex ~= nil then
          X2Decal:SetQuestGuidDecalByIndex(decalIndex, qtype, true)
          X2Map:UpdateNotifyQuestInfo(decalIndex, qtype, true)
          X2Decal:SetQuestGuidDecalByIndex(decalIndex, qtype, false)
          X2Map:RemoveNotifyQuestInfo(qtype)
        end
      end
      if X2Quest:IsMainQuest(qtype) == true then
        if X2Quest:IsCompleted(qtype) ~= true and X2Quest:GetActiveQuestListStatusByType(qtype) ~= 0 then
          questContextUiCount = questContextUiCount + 1
          if questContextStateValues.checkBoxStates[qtype] then
            questContextCheckedUiCount = questContextCheckedUiCount + 1
          end
        end
      else
        questContextUiCount = questContextUiCount + 1
        if questContextStateValues.checkBoxStates[qtype] then
          questContextCheckedUiCount = questContextCheckedUiCount + 1
        end
      end
    end
  end
  local consolAttr = Console:GetAttribute("ui_draw_quest_type")
  if consolAttr ~= nil and tonumber(consolAttr) == 1 then
    UpdateActiveQuestCountText(progressTab)
    UpdateActiveQuestCountText(mainQuestTab)
  end
end
function UpdateQuestListData(qtype, status)
  if qtype == nil then
    return
  end
  if AddableQuest(qtype) then
    if X2Quest:IsMainQuest(qtype) ~= true then
      questContextStateValues.checkBoxStates[qtype] = HasNotifierQuestList(qtype)
    end
    if status == "started" then
      questContextUiCount = questContextUiCount + 1
    elseif status == "dropped" or status == "completed" then
      questContextUiCount = questContextUiCount - 1
      if questContextUiCount < 0 then
        questContextUiCount = 0
      end
    end
  end
  local consolAttr = Console:GetAttribute("ui_draw_quest_type")
  if consolAttr ~= nil and tonumber(consolAttr) == 1 then
    UpdateActiveQuestCountText(progressTab)
    UpdateActiveQuestCountText(mainQuestTab)
  end
end
function SetQuestFolderState(type, state)
  if questContextStateValues.folderStates[type] ~= nil then
    questContextStateValues.folderStates[type] = state
    SaveQuestContextValues()
  end
end
local function SetQuestListCheckBoxState(qtype, state)
  local oldState = questContextStateValues.checkBoxStates[qtype]
  questContextStateValues.checkBoxStates[qtype] = state
  if (oldState == nil or oldState == false) and state == true then
    questContextCheckedUiCount = questContextCheckedUiCount + 1
  end
  if (state == nil or state == false) and oldState == true then
    questContextCheckedUiCount = questContextCheckedUiCount - 1
  end
  local consolAttr = Console:GetAttribute("ui_draw_quest_type")
  if consolAttr ~= nil and tonumber(consolAttr) == 1 then
    UpdateActiveQuestCountText(progressTab)
    UpdateActiveQuestCountText(mainQuestTab)
  end
  SaveQuestContextValues()
end
function RemoveQuestListCheckBoxState(qtype)
  local oldState = questContextStateValues.checkBoxStates[qtype]
  if questContextStateValues.checkBoxStates[qtype] ~= nil then
    questContextStateValues.checkBoxStates[qtype] = nil
    if oldState == true then
      questContextCheckedUiCount = questContextCheckedUiCount - 1
    end
    local consolAttr = Console:GetAttribute("ui_draw_quest_type")
    if consolAttr ~= nil and tonumber(consolAttr) == 1 then
      UpdateActiveQuestCountText(progressTab)
      UpdateActiveQuestCountText(mainQuestTab)
    end
    SaveQuestContextValues()
  end
end
function ResetQuestCheckBoxWithoutMainQuest()
  for questTypeKey, checked in pairs(questContextStateValues.checkBoxStates) do
    if checked ~= nil and X2Quest:IsMainQuest(questTypeKey) == false then
      SetQuestCheckBoxByType(questTypeKey, nil)
    end
  end
end
function ExistActiveMainQuest()
  local otherMainQuest = {}
  local isExistActiveMainQuest = false
  local qcount = X2Quest:GetMainQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetMainQuestType(i)
    local checked = questContextStateValues.checkBoxStates[qtype]
    if checked ~= nil and checked == true then
      isExistActiveMainQuest = true
      break
    end
    table.insert(otherMainQuest, qtype)
  end
  return isExistActiveMainQuest, otherMainQuest
end
function ActiveOtherMainQuest(ignoreQtype)
  local isExistActiveMainQuest, otherMainQuest = ExistActiveMainQuest()
  if isExistActiveMainQuest == false then
    for i = 1, #otherMainQuest do
      local qtype = otherMainQuest[i]
      if ignoreQtype ~= qtype then
        local status = X2Quest:GetActiveQuestListStatusByType(qtype)
        local completed = X2Quest:IsCompleted(qtype)
        if status ~= 0 and completed == false then
          SetQuestListCheckBoxState(qtype, true)
          break
        end
      end
    end
  end
end
function ProgressMainQuestsFolderOpen()
  local qcount = X2Quest:GetMainQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetMainQuestType(i)
    if AddableQuest(qtype) then
      local completed = X2Quest:IsCompleted(qtype)
      local status = X2Quest:GetActiveQuestListStatusByType(qtype)
      if status ~= 0 and completed == false then
        SelectQuestList(qtype)
      end
    end
  end
end
local function SetLastDetailQuestType(qtype, tabindex)
  questContextStateValues.lastDetailQuestType[tabindex] = qtype
  SaveQuestContextValues()
end
function GetFolderListTotalHeight(bMainQuest)
  local totalHeight = 0
  local folders
  if bMainQuest == false then
    folders = questFolders
  else
    folders = mainQuestFolders
  end
  for _, folder in pairs(folders) do
    if folder ~= nil then
      totalHeight = totalHeight + folder:GetHeight()
    end
  end
  return totalHeight
end
function UpdateMainQuestsInQuestList(taregetQtype, status)
  local checkedQuestType = 0
  if taregetQtype ~= nil then
    checkedQuestType = taregetQtype
  end
  local mainQuest = {}
  local qcount = X2Quest:GetMainQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetMainQuestType(i)
    local checked = questContextStateValues.checkBoxStates[qtype]
    if checkedQuestType == 0 and checked then
      checkedQuestType = qtype
    end
    table.insert(mainQuest, qtype)
  end
  local enable = checkedQuestType == 0 and true or false
  if status == "completed" and GetNotifierQuestListCount() < notifierLimit then
    enable = true
  end
  local lastCompletedQuestType
  local lastQuestChatperIndex = 0
  local lastQuestIndex = 0
  local bProgress = false
  local lastProgressQuestType
  local lastProgressChapterIndex = 0
  local lastProgressIndex = 0
  SetAllCompleted(true)
  for i = 1, #mainQuest do
    local qtype = mainQuest[i]
    local checkBox = GetQuestCheckBoxByType(qtype)
    local chapterIndex = X2Quest:GetQuestContextQuestChapterIdxByType(qtype)
    local questIndex = X2Quest:GetQuestContextQuestIdxByType(qtype)
    local completed = X2Quest:IsCompleted(qtype)
    local status = X2Quest:GetActiveQuestListStatusByType(qtype)
    if IsAllCompleted() == true and completed == false then
      SetAllCompleted(false)
    end
    if bProgress == false and lastCompletedQuestType == nil and chapterIndex == 1 and questIndex == 1 then
      lastCompletedQuestType = qtype
      lastQuestChatperIndex = chapterIndex
      lastQuestIndex = questIndex
    end
    if bProgress == false and completed == true then
      if lastCompletedQuestType == nil then
        lastCompletedQuestType = qtype
        lastQuestChatperIndex = chapterIndex
        lastQuestIndex = questIndex
      elseif chapterIndex > lastQuestChatperIndex then
        lastCompletedQuestType = qtype
        lastQuestChatperIndex = chapterIndex
        lastQuestIndex = questIndex
      elseif lastQuestChatperIndex == chapterIndex and questIndex > lastQuestIndex then
        lastCompletedQuestType = qtype
        lastQuestChatperIndex = chapterIndex
        lastQuestIndex = questIndex
      end
    end
    if checkBox ~= nil then
      if checkedQuestType == 0 and status ~= 0 and completed == false then
        if lastProgressQuestType == nil then
          lastProgressChapterIndex = chapterIndex
          lastProgressIndex = questIndex
          lastProgressQuestType = qtype
        elseif chapterIndex < lastProgressChapterIndex then
          lastProgressChapterIndex = chapterIndex
          lastProgressIndex = questIndex
          lastProgressQuestType = qtype
        elseif lastProgressChapterIndex == chapterIndex and questIndex < lastProgressIndex then
          lastProgressChapterIndex = chapterIndex
          lastProgressIndex = questIndex
          lastProgressQuestType = qtype
        end
      end
      if checkedQuestType == qtype then
        if status ~= 0 and completed == false then
          if checkBox:GetChecked() == false then
            checkBox:SetChecked(true)
          end
          checkBox:SetEnableCheckButton(true)
          SetQuestListCheckBoxState(qtype, true)
          SelectQuestList(qtype)
          bProgress = true
          lastCompletedQuestType = qtype
        else
          checkBox:SetChecked(false)
          checkBox:SetEnableCheckButton(false)
          SetQuestListCheckBoxState(qtype, false)
        end
      else
        if checkBox:GetChecked() == true then
          checkBox:SetChecked(false)
        end
        checkBox:SetEnableCheckButton(true)
        SetQuestListCheckBoxState(qtype, false)
      end
    end
  end
  if lastCompletedQuestType ~= nil and questContextStateValues.lastDetailQuestType[2] == nil and IsAllCompleted() ~= true then
    if bProgress == false and lastProgressQuestType ~= nil then
      lastCompletedQuestType = lastProgressQuestType
    end
    SelectQuestList(lastCompletedQuestType)
    SetLastDetailQuestType(lastCompletedQuestType, 2)
  end
end
function UpdateQuestListCheckboxState()
  for qtype, checked in pairs(questContextStateValues.checkBoxStates) do
    local checkBox = GetQuestCheckBoxByType(qtype)
    if checkBox ~= nil then
      if X2Quest:IsMainQuest(qtype) ~= true then
        checkBox:SetChecked(checked, false)
        if checked == true then
          SelectQuestList(qtype)
        end
      else
        local completed = X2Quest:IsCompleted(qtype)
        local status = X2Quest:GetActiveQuestListStatusByType(qtype)
        if status ~= 0 and completed == false then
          checkBox:SetChecked(checked)
        else
          checkBox:SetChecked(checked, false)
        end
      end
    end
  end
end
function SetQuestListState(bEnterWorld, bMainQuestUpdateSkip)
  questContext.contextListBack:ApplyLastWindowOffset()
  questContext.contextListBack:ApplyLastWindowExtent()
  local function GetQuestCategoryTitleText(categoryType)
    local progressWidget = progressTab.scrollWnd.emptyWidget
    local mainQuestWidget = mainQuestTab.scrollWnd.emptyWidget
    local progressFolders = folderPool[progressWidget]
    local mainQuestFolders = folderPool[mainQuestWidget]
    local titleText
    if progressFolders ~= nil then
      for _, folder in pairs(progressFolders) do
        if folder.categoryType == categoryType then
          titleText = folder:GetTitleText()
          break
        end
      end
    end
    if titleText == nil and mainQuestFolders ~= nil then
      for _, folder in pairs(mainQuestFolders) do
        if folder.categoryType == categoryType then
          titleText = folder:GetTitleText()
          break
        end
      end
    end
    return titleText
  end
  for type, state in pairs(questContextStateValues.folderStates) do
    local key = GetQuestCategoryTitleText(type)
    local folder = GetQuestFolderByName(key)
    if folder == nil or state == "open" then
    else
      folder:CloseFolder()
    end
  end
  progressTab.scrollWnd.emptyWidget:SetHeight(GetFolderListTotalHeight(false))
  mainQuestTab.scrollWnd.emptyWidget:SetHeight(GetFolderListTotalHeight(true))
  UpdateQuestListCheckboxState()
  if bEnterWorld == true or bMainQuestUpdateSkip == false then
    UpdateMainQuestsInQuestList()
  end
  UpdateNotifierQuestDecal()
  FillDetailInfos(questContextStateValues.lastDetailQuestType[1], progressTab)
  FillDetailInfos(questContextStateValues.lastDetailQuestType[2], mainQuestTab)
  ResetEmptyWidgetListScroll(progressTab.scrollWnd, progressTab.scrollWnd.emptyWidget)
  ResetEmptyWidgetListScroll(mainQuestTab.scrollWnd, mainQuestTab.scrollWnd.emptyWidget)
end
function UpdateMainQuestListState(qtype, bEnterWorld, bMainQuestUpdateSkip)
  if qtype == nil or bEnterWorld == nil or bMainQuestUpdateSkip == nil then
    return
  end
  if X2Quest:IsMainQuest(qtype) then
    SetQuestListState(bEnterWorld, bMainQuestUpdateSkip)
  end
end
function UpdateCurrentQuestNotifier()
  for qtype, checked in pairs(questContextStateValues.checkBoxStates) do
    if checked then
      local result = AddQuestToNotifier(qtype)
      if not result then
        RemoveQuestListCheckBoxState(qtype)
      end
    else
      RemoveQuestFromNotifier(qtype, false)
    end
  end
end
local function ExistMainQuest()
  local qcount = X2Quest:GetMainQuestListCount()
  for i = 1, qcount do
    local qtype = X2Quest:GetMainQuestType(i)
    local checked = questContextStateValues.checkBoxStates[qtype]
    if checked ~= nil then
      return true
    end
  end
  return false
end
function UpdateQuestList(qtype, status)
  if qtype == nil or status == nil then
    return
  end
  if not AddableQuest(qtype) then
    return
  end
  local notifiable = false
  if X2Quest:IsTodayQuest(qtype) then
    notifiable = GetTodayQuestListCount() < todayNotifierLimit
  else
    notifiable = GetNotifierQuestListCount() < notifierLimit
  end
  local checkBox = GetQuestCheckBoxByType(qtype)
  if checkBox ~= nil and status == "started" then
    if notifiable or X2Quest:IsMainQuest(qtype) and ExistActiveMainQuest() then
      checkBox:SetChecked(true)
      checkBox:SetEnableCheckButton(true)
      SetQuestListCheckBoxState(qtype, true)
    end
    if X2Quest:IsMainQuest(qtype) and ExistMainQuest() then
      UpdateMainQuestsInQuestList(qtype)
    end
    local objEmptyWidget = checkBox:GetParent()
    if objEmptyWidget == nil then
      return
    end
    local childEmptyWidget = objEmptyWidget:GetParent()
    if childEmptyWidget == nil then
      return
    end
    local folder = childEmptyWidget:GetParent()
    if folder == nil then
      return
    end
    folder:OpenFolder()
  end
end
local function UpdateLastDetailQuest(bEnterWorld)
  for tabindex = 1, 2 do
    local qtype = questContextStateValues.lastDetailQuestType[tabindex]
    if qtype ~= nil and not AddableQuest(qtype) then
      qtype = nil
      SetLastDetailQuestType(qtype, tabindex)
    end
    if tabindex == 2 and bEnterWorld and (qtype == nil or not IsExistQuestTypeInJournal(qtype)) then
      local qcount = X2Quest:GetMainQuestListCount()
      for i = 1, qcount do
        local qtype = X2Quest:GetMainQuestType(i)
        if AddableQuest(qtype) and X2Quest:GetActiveQuestListStatusByType(qtype) ~= 0 and X2Quest:IsCompleted(qtype) ~= true then
          local isChecked = GetQuestListCheckValue(qtype)
          if isChecked ~= nil and isChecked == true then
            SetLastDetailQuestType(qtype, tabindex)
          end
          break
        end
      end
    end
  end
end
local function SetCheckBoxHandler(checkBox, qtype)
  checkBox.questType = qtype
  function checkBox:CheckBtnCheckChagnedProc(checked)
    local questType = self.questType
    if questType == nil then
      return
    end
    if checked == true and CheckNotifierLimit() == false then
      self:SetChecked(false, false)
      return
    end
    SetQuestListCheckBoxState(questType, checked)
    SyncNotifierQuestList()
    if X2Quest:IsMainQuest(questType) and checked then
      UpdateMainQuestsInQuestList(questType)
    else
      UpdateMainQuestsInQuestList()
    end
    if checked then
      AddQuestToNotifier(questType)
    else
      RemoveQuestFromNotifier(questType, false)
    end
  end
end
local function SetCheckBox(widget, bMainQuest)
  if bMainQuest == false then
    widget.checkBox = GetCheckButtonFromPool(widget)
  else
    widget.checkBox = GetMainCheckButtonFromPool(widget, widget.questType)
  end
  local questType = widget.questType
  local inset = objectiveEmptyWidgetConfig.checkBoxInset
  widget.checkBox:AddAnchor("TOPLEFT", widget, "TOPLEFT", inset[1], inset[2])
  if X2Quest:IsMainQuest(questType) == true then
    if X2Quest:GetActiveQuestListStatusByType(widget.questType) ~= 0 and X2Quest:IsCompleted(widget.questType) == false then
      widget.checkBox:Show(true)
    else
      widget.checkBox:Show(false)
    end
  else
    widget.checkBox:Show(true)
  end
  SetQuestCheckBoxByType(questType, widget.checkBox)
  SetCheckBoxHandler(widget.checkBox, questType)
end
local function MakeTitle(parent, questItem, bMainQuest)
  local listTitle = questItem.listTitle
  if listTitle == false then
    if X2Quest:IsMainQuest(questItem.questType) == true then
      listTitle = string.format("%d. %s", questItem.orgQuestIndex, X2Quest:GetQuestContextMainTitle(questItem.questType))
    else
      listTitle = "unknown"
    end
  end
  local label
  if bMainQuest == false then
    label = GetLabelFromPool(parent)
  else
    label = GetMainLabelFromPool(parent, questItem.questType)
  end
  label.questType = questItem.questType
  label.questDetailIcon:SetVisible(true)
  label.questDetailIcon:SetTextureInfo(X2Quest:GetQuestDetail(questItem.questType))
  if questItem.isMainQuest == true then
    if questItem.isCompleted == true then
      if questItem.isCinema == true then
        label.questDetailIcon:SetTextureInfo("play")
      else
        label.questDetailIcon:SetVisible(false)
      end
    elseif questItem.status == 0 then
      label.questDetailIcon:SetVisible(false)
    end
  end
  if label.questDetailIcon:GetWidth() == 0 or label.questDetailIcon:GetHeight() == 0 then
    label.questDetailIcon:SetVisible(false)
  end
  label:SetText(listTitle)
  local height = label:GetTextHeight()
  label:SetHeight(height)
  label:Show(true)
  return label, height
end
local function UnselectObjectiveEmptyWidget(objectiveEmptyWidget, isMainQuest)
  if isMainQuest == false then
    for _, emptyWidgets in pairs(emptyWidgetPool) do
      for _, emptyWidget in pairs(emptyWidgets) do
        if emptyWidget ~= objectiveEmptyWidget and emptyWidget.isUsed and emptyWidget.title ~= nil and emptyWidget.title.selectedDrawable ~= nil then
          emptyWidget.title.selectedDrawable:SetVisible(false)
        end
      end
    end
  else
    for _, emptyWidgets in pairs(mainEmptyWidgetPool) do
      for _, emptyWidget in pairs(emptyWidgets) do
        if emptyWidget ~= objectiveEmptyWidget and emptyWidget.isUsed and emptyWidget.title ~= nil and emptyWidget.title.selectedDrawable ~= nil then
          emptyWidget.title.selectedDrawable:SetVisible(false)
        end
      end
    end
  end
end
local SelectObjectiveEmptyWidget = function(objectiveEmptyWidget)
  if objectiveEmptyWidget.title ~= nil and objectiveEmptyWidget.title.selectedDrawable ~= nil then
    objectiveEmptyWidget.title.selectedDrawable:SetVisible(true)
  end
end
local MouseEnterObjectiveEmptyWidget = function(objectiveEmptyWidget)
  if objectiveEmptyWidget.title ~= nil and objectiveEmptyWidget.title.currentDrawable ~= nil then
    objectiveEmptyWidget.title.currentDrawable:SetVisible(true)
  end
end
local MouseLeaveObjectiveEmptyWidget = function(objectiveEmptyWidget)
  if objectiveEmptyWidget.title ~= nil and objectiveEmptyWidget.title.currentDrawable ~= nil then
    objectiveEmptyWidget.title.currentDrawable:SetVisible(false)
  end
end
local function MakeQuestObjectiveEmptyWidget(parent, questItem, withoutLastRow, bMainQuest)
  local emptyWidget
  if bMainQuest == false then
    emptyWidget = GetEmptyWidgetFromPool(parent)
  else
    emptyWidget = GetMainEmptyWidgetFromPool(parent)
  end
  emptyWidget:SetWidth(objectiveEmptyWidgetConfig.width)
  emptyWidget.questIndex = questItem.questIndex
  emptyWidget.questType = questItem.questType
  emptyWidget.isMainQuest = bMainQuest
  local item = questItem
  local title, titleHeight = MakeTitle(emptyWidget, item, bMainQuest)
  emptyWidget.title = SetLevelColor(title, item)
  SetCheckBox(emptyWidget, bMainQuest)
  emptyWidget.title:AddAnchor("TOPLEFT", emptyWidget.checkBox, "TOPRIGHT", -1, 2)
  local function SetEmptyWidgetEventHandler(widget)
    function widget:OnClick(arg)
      if self.questIndex ~= nil then
        FillDetailInfos(self.questType)
        SelectObjectiveEmptyWidget(widget)
        UnselectObjectiveEmptyWidget(widget, self.isMainQuest)
      end
    end
    widget:ReleaseHandler("OnClick")
    widget:SetHandler("OnClick", widget.OnClick)
    function widget:OnEnter(arg)
      if self.questIndex ~= nil then
        MouseEnterObjectiveEmptyWidget(widget)
      end
    end
    widget:ReleaseHandler("OnEnter")
    widget:SetHandler("OnEnter", widget.OnEnter)
    function widget:OnLeave(arg)
      if self.questIndex ~= nil then
        MouseLeaveObjectiveEmptyWidget(widget)
      end
    end
    widget:ReleaseHandler("OnLeave")
    widget:SetHandler("OnLeave", widget.OnLeave)
  end
  SetEmptyWidgetEventHandler(emptyWidget)
  local lastRowHeight = objectiveEmptyWidgetConfig.lastRowHeight
  local height = titleHeight + lastRowHeight
  emptyWidget:SetHeight(height)
  if GetQuestListCheckValue(questItem.questType) == nil then
    SetQuestListCheckBoxState(questItem.questType, true)
  end
  emptyWidget:Show(true)
  return emptyWidget, height
end
local function MakeQuestChildEmptyWidget(parent, category, bMainQuest)
  local emptyWidget
  if bMainQuest == false then
    emptyWidget = GetEmptyWidgetFromPool(parent)
  else
    emptyWidget = GetMainEmptyWidgetFromPool(parent)
  end
  local row = 1
  local questCount = table.getn(category)
  local objectiveEmptyWidget
  local height = 0
  local anchorTarget = emptyWidget
  for i = 1, questCount do
    if i == questCount then
      objectiveEmptyWidget, childHeight = MakeQuestObjectiveEmptyWidget(emptyWidget, category[i], true, bMainQuest)
    else
      objectiveEmptyWidget, childHeight = MakeQuestObjectiveEmptyWidget(emptyWidget, category[i], false, bMainQuest)
    end
    objectiveEmptyWidget.index = i
    objectiveEmptyWidget.folderWidget = parent
    if i == 1 then
      objectiveEmptyWidget:AddAnchor("TOPLEFT", anchorTarget, "TOPLEFT", 0, 0)
    else
      objectiveEmptyWidget:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, 0)
    end
    anchorTarget = objectiveEmptyWidget
    height = height + childHeight
    for tabindex = 1, 2 do
      if category[i].questType == questContextStateValues.lastDetailQuestType[tabindex] then
        SelectObjectiveEmptyWidget(objectiveEmptyWidget)
      end
    end
  end
  emptyWidget:SetHeight(height)
  emptyWidget:Show(true)
  return emptyWidget, height
end
local function MakeQuestFolder(parent, category, bMainQuest)
  local folder
  if bMainQuest == false then
    folder = GetFolderFromPool(parent)
  else
    folder = GetMainFolderFromPool(parent)
  end
  local categoryText
  if category[1] == nil then
    categoryText = "MainQuest"
    folder.titleBtn.tooltip = ""
  else
    categoryText = category[1].category
    folder.titleBtn.tooltip = category[1].tooltip
  end
  folder.categoryType = category[1].categoryType
  folder.chapterIdx = category[1].chapterIdx
  if bMainQuest ~= true then
    SetQuestFolderByName(categoryText, folder, bMainQuest)
  else
    SetQuestFolderByChapter(folder, bMainQuest)
  end
  folder:SetTitleText(categoryText)
  folder.titleBtn:SetText(categoryText)
  local emptyWidget, height = MakeQuestChildEmptyWidget(folder, category, bMainQuest)
  local folderTitleHeight = FOLER_ITEM_LIST_HEIGHT
  folder.childEmptyWidget = emptyWidget
  folder:SetTitleHeight(folderTitleHeight)
  folder:SetChildWidget(emptyWidget)
  folder:SetExtendLength(height)
  folder:UseAnimation(false)
  folder:FixedCloseFolder()
  folder:Show(true)
  return folder, folderTitleHeight, state
end
local function UpdateMainQuestFolder(parent, category, chapterIdx)
  local folder
  folder = GetMainFolderFromPool(parent, chapterIdx)
  local categoryText
  if category[1] == nil then
    categoryText = "MainQuest"
    folder.titleBtn.tooltip = ""
  else
    categoryText = category[1].category
    folder.titleBtn.tooltip = category[1].tooltip
  end
  if bMainQuest ~= true then
    SetQuestFolderByName(categoryText, folder, bMainQuest)
  else
    SetQuestFolderByChapter(folder, bMainQuest)
  end
  folder:SetTitleText(categoryText)
  folder.titleBtn:SetText(categoryText)
end
local function MakeQuestContextList(widget, questItems, bMainQuest, status)
  local questCount = questItems.count
  widget:Show(true)
  if questCount == 0 then
    return
  end
  local index = 1
  local categoryGroup = questItems.categoryGroup
  local anchorTarget = widget
  for _, category in pairs(categoryGroup) do
    local folder, titleHeight, state = MakeQuestFolder(widget, category, bMainQuest)
    if anchorTarget == widget then
      folder:AddAnchor("TOPLEFT", anchorTarget, "TOPLEFT", 0, 0)
      folder:AddAnchor("TOPRIGHT", anchorTarget, "TOPRIGHT", 0, 0)
    else
      folder:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, 0)
      folder:AddAnchor("TOPRIGHT", anchorTarget, "BOTTOMRIGHT", 0, 0)
    end
    anchorTarget = folder
  end
end
local function UpdateCommonQuestContextList(widget, questItem)
  for _, emptyWidgets in pairs(emptyWidgetPool) do
    for _, emptyWidget in pairs(emptyWidgets) do
      if emptyWidget.questType == questItem.questType and emptyWidget.title ~= nil then
        emptyWidget.title:SetText(questItem.listTitle)
        local titleHeight = emptyWidget.title:GetTextHeight()
        emptyWidget.title:SetHeight(titleHeight)
        emptyWidget.title = SetLevelColor(emptyWidget.title, questItem)
        local lastRowHeight = objectiveEmptyWidgetConfig.lastRowHeight
        local height = titleHeight + lastRowHeight
        folderWidget = emptyWidget.folderWidget
        folderHeight = folderWidget:GetExtendLength() + (height - emptyWidget:GetHeight())
        folderWidget:SetExtendLength(folderHeight)
        emptyWidget:SetHeight(height)
        return
      end
    end
  end
end
local function UpdateQuestContextList(widget, questItem, bMainQuest, status)
  if bMainQuest == true then
    local mergedQuests = GetLastMergedQuests()
    if mergedQuests == nil or mergedQuests.categoryGroup == nil then
      return nil
    end
    for _, category in pairs(mergedQuests.categoryGroup) do
      for _, quest in pairs(category) do
        if quest.questType == questItem.questType then
          UpdateMainQuestFolder(widget, category, questItem.chapterIdx)
        end
      end
    end
  else
    UpdateCommonQuestContextList(widget, questItem)
    return
  end
  for _, emptyWidgets in pairs(mainEmptyWidgetPool) do
    for _, emptyWidget in pairs(emptyWidgets) do
      if emptyWidget.questType == questItem.questType then
        local title, titleHeight = MakeTitle(emptyWidget, questItem, bMainQuest)
        emptyWidget.title = SetLevelColor(title, questItem)
        SetCheckBox(emptyWidget, bMainQuest)
        local lastRowHeight = objectiveEmptyWidgetConfig.lastRowHeight
        local height = titleHeight + lastRowHeight
        folderWidget = emptyWidget.folderWidget
        folderHeight = folderWidget:GetExtendLength() + (height - emptyWidget:GetHeight())
        folderWidget:SetExtendLength(folderHeight)
        emptyWidget:SetHeight(height)
      end
    end
  end
end
function MakeQuestList(bEnterWorld, qtype, status)
  local isMainQuest = false
  if qtype ~= nil then
    isMainQuest = X2Quest:IsMainQuest(qtype)
  end
  if bEnterWorld == true then
    if ResetButtonPool ~= nil then
      ResetButtonPool()
    end
    if ResetFolderPool ~= nil then
      ResetFolderPool()
    end
    if ResetLabelPool ~= nil then
      ResetLabelPool()
    end
    if ResetEmptyWidgetPool ~= nil then
      ResetEmptyWidgetPool()
    end
    if ResetMainButtonPool ~= nil then
      ResetMainButtonPool()
    end
    if ResetMainFolderPool ~= nil then
      ResetMainFolderPool()
    end
    if ResetMainLabelPool ~= nil then
      ResetMainLabelPool()
    end
    if ResetMainEmptyWidgetPool ~= nil then
      ResetMainEmptyWidgetPool()
    end
  elseif isMainQuest == false and status ~= "updated" then
    if ResetButtonPool ~= nil then
      ResetButtonPool()
    end
    if ResetFolderPool ~= nil then
      ResetFolderPool()
    end
    if ResetLabelPool ~= nil then
      ResetLabelPool()
    end
    if ResetEmptyWidgetPool ~= nil then
      ResetEmptyWidgetPool()
    end
  end
  if bEnterWorld == false then
    if isMainQuest == true then
      if status == "dropped" or status == "completed" then
        RemoveQuestListCheckBoxState(qtype)
      end
    else
      ResetQuestCheckBoxWithoutMainQuest()
    end
  else
    ResetQuestCheckBoxByType()
  end
  UpdateLastDetailQuest(bEnterWorld)
  if bEnterWorld == true then
    local emptyWidget = progressTab.scrollWnd.emptyWidget
    local questItems = GetMergedQuests(false)
    MakeQuestContextList(emptyWidget, questItems, false, status)
    UpdateActiveQuestCountText(progressTab)
    emptyWidget = mainQuestTab.scrollWnd.emptyWidget
    questItems = GetMergedQuests(true)
    MakeQuestContextList(emptyWidget, questItems, true, status)
    bMakedMainQuest = true
    UpdateActiveQuestCountText(mainQuestTab)
  elseif isMainQuest == false then
    if status == "updated" then
      local emptyWidget = progressTab.scrollWnd.emptyWidget
      local questItem = GetMergedQuest(false, qtype)
      if questItem ~= nil then
        UpdateQuestContextList(emptyWidget, questItem, false, status)
        UpdateActiveQuestCountText(progressTab)
        UpdateActiveQuestCountText(mainQuestTab)
      end
    else
      local emptyWidget = progressTab.scrollWnd.emptyWidget
      local questItems = GetMergedQuests(false)
      MakeQuestContextList(emptyWidget, questItems, false, status)
      UpdateQuestListCheckboxState()
      UpdateActiveQuestCountText(progressTab)
      UpdateActiveQuestCountText(mainQuestTab)
    end
  else
    local emptyWidget = mainQuestTab.scrollWnd.emptyWidget
    local questItem = GetMergedQuest(true, qtype)
    if questItem ~= nil then
      UpdateQuestContextList(emptyWidget, questItem, true, status)
      UpdateActiveQuestCountText(mainQuestTab)
      UpdateActiveQuestCountText(progressTab)
    end
    bMakedMainQuest = true
  end
end
function ClearDetailInfosCompareQuestType(qtype)
  if X2Quest:IsMainQuest(qtype) then
    if mainQuestTab.journal:GetCurQuestType() == qtype then
      mainQuestTab.journal:SetCurQuestType(nil)
    end
  elseif progressTab.journal:GetCurQuestType() == qtype then
    progressTab.journal:SetCurQuestType(nil)
  end
end
function FillDetailInfos(questType, tabWind)
  if questType == nil then
    if tabWind ~= nil then
      tabWind.journal:Init()
      tabWind.journal.mapViewBtn:Show(false)
      tabWind.journal.questDropBtn:Show(false)
      tabWind.journal:FillJournal("questList", questType)
    else
      progressTab.journal:Init()
      mainQuestTab.journal:Init()
      progressTab.journal.mapViewBtn:Show(false)
      progressTab.journal.questDropBtn:Show(false)
      mainQuestTab.journal.mapViewBtn:Show(false)
      mainQuestTab.journal.questDropBtn:Show(false)
      progressTab.journal:FillJournal("questList", questType)
      mainQuestTab.journal:FillJournal("questList", questType)
    end
    return
  end
  local QuestTab
  if X2Quest:IsMainQuest(questType) then
    QuestTab = mainQuestTab
  else
    QuestTab = progressTab
  end
  local function JournalButtonVisible(isShow)
    QuestTab.journal.mapViewBtn:Show(isShow)
    QuestTab.journal.questDropBtn:Show(isShow)
  end
  QuestTab.journal:Init()
  JournalButtonVisible(false)
  local notActive = IndexFromQuestType(questType) == 0
  if notActive and X2Quest:IsMainQuest(questType) == false then
    return
  end
  QuestTab.journal:FillJournal("questList", questType)
  SelectQuestList(questType)
  if X2Quest:IsMainQuest(questType) == true and X2Quest:IsCompleted(questType) == true then
    JournalButtonVisible(false)
    QuestTab.journal.replayButton:Show(true)
    if X2Quest:IsExistCinema(questType) == true then
      QuestTab.journal.replayButton:Enable(true)
    else
      QuestTab.journal.replayButton:Enable(false)
    end
  else
    JournalButtonVisible(true)
    if QuestTab.journal.replayButton ~= nil then
      QuestTab.journal.replayButton:Show(false)
    end
  end
  local tabindex
  if X2Quest:IsMainQuest(questType) == false then
    tabindex = 1
  else
    tabindex = 2
  end
  SetLastDetailQuestType(questType, tabindex)
end
function RefreshDetailWindow(tabWind)
  FillDetailInfos(tabWind.journal:GetCurQuestType(), tabWind)
end
function SelectQuestList(qType)
  if qType == nil then
    return
  end
  local list, folders
  local bMainQuest = X2Quest:IsMainQuest(qType)
  if bMainQuest == false then
    list = progressTab.scrollWnd.emptyWidget
    folders = folderPool[list]
  else
    list = mainQuestTab.scrollWnd.emptyWidget
    folders = mainFolderPool[list]
  end
  local found
  if folders ~= nil then
    for _, folder in pairs(folders) do
      local emptyWidgets
      if bMainQuest == false then
        emptyWidgets = emptyWidgetPool[folder]
      else
        emptyWidgets = mainEmptyWidgetPool[folder]
      end
      for _, emptyWidget in pairs(emptyWidgets) do
        local childEmptyWidgets
        if bMainQuest == false then
          childEmptyWidgets = emptyWidgetPool[emptyWidget]
        else
          childEmptyWidgets = mainEmptyWidgetPool[emptyWidget]
        end
        for _, childEmptyWidget in pairs(childEmptyWidgets) do
          if childEmptyWidget.isUsed and childEmptyWidget.questType == qType then
            if "open" ~= folder:GetState() and "opening" ~= folder:GetState() then
              folder:ToggleState()
            end
            found = childEmptyWidget
          end
        end
      end
    end
  end
  if found ~= nil then
    UnselectObjectiveEmptyWidget(found)
  end
end
function questContext.contextListBack.tab:OnTabChanged(selected)
  ReAnhorTabLine(self, selected)
end
questContext.contextListBack.tab:SetHandler("OnTabChanged", questContext.contextListBack.tab.OnTabChanged)
function GetQuestListCheckValue(questType)
  return questContextStateValues.checkBoxStates[questType]
end
local function OnHide()
  UpdateQuestFullAnim(false)
  progressTab.guide.arrow:Animation(false, false)
end
questContext.contextListBack:SetHandler("OnHide", OnHide)
function questContext.contextListBack:ShowProc()
  if not questContext.contextListBack.isFullAnimReady then
    return
  end
  local arrow = progressTab.guide.arrow
  arrow:Animation(true, false)
end
function UpdateQuestFullAnim(bool)
  questContext.contextListBack.isFullAnimReady = bool
end
