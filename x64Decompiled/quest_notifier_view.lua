function CreateNotifierClockWindow(id, parent)
  local window = UIParent:CreateWidget("emptywidget", id, parent)
  local bg = window:CreateDrawable(TEXTURE_PATH.QUEST_NOTIFIER, "time_back", "background")
  window:SetHeight(bg:GetHeight())
  window.bg = bg
  local clockIcon = window:CreateDrawable(TEXTURE_PATH.HUD, "white_clock", "overlay")
  clockIcon:AddAnchor("RIGHT", window, 0, 1)
  window.clockIcon = clockIcon
  bg:AddAnchor("RIGHT", clockIcon, 20, 1)
  local time = window:CreateChildWidget("label", "time", 0, true)
  time:SetAutoResize(true)
  time:SetHeight(FONT_SIZE.XLARGE)
  time:AddAnchor("RIGHT", clockIcon, "LEFT", -3, 0)
  time.style:SetFontSize(FONT_SIZE.XLARGE)
  time.style:SetShadow(true)
  function window:Update(time, timeType)
    local hour, min, sec
    if timeType == "msec" then
      hour, min, sec = GetHourMinuteSecondeFromMsec(time)
    elseif timeType == "sec" then
      hour, min, sec = GetHourMinuteSecondeFromSec(time)
    else
      return
    end
    local timeString = ""
    if hour ~= 0 then
      timeString = timeString .. string.format("%02d", hour) .. ":"
    end
    if min ~= 0 then
      timeString = timeString .. string.format("%02d", min) .. ":"
    else
      timeString = timeString .. "00:"
    end
    if sec ~= 0 then
      timeString = timeString .. string.format("%02d", sec)
    else
      timeString = timeString .. "00"
    end
    self.time:SetText(timeString)
    self:SetWidth(self.time:GetWidth() + self.clockIcon:GetWidth() + 5)
    if self:GetWidth() < 75 then
      self.bg:SetWidth(105)
    else
      self.bg:SetWidth(130)
    end
  end
  return window
end
local SetLayoutObjective = function(textBox, questItem, itemWidth, itemHeight)
  textBox:SetInset(10, 0, 0, 0)
  local width = questLocale.notifier.objectWidth
  itemWidth = itemWidth or 0
  textBox:SetExtent(width - itemWidth, 0)
  if itemHeight == nil then
    itemHeight = 0
  end
  itemHeight = math.max(itemHeight, textBox:GetTextHeight())
  textBox:SetExtent(width - itemWidth, itemHeight)
  textBox.style:SetShadow(true)
  SetLevelColor(textBox.prefix, questItem)
  SetLevelColor(textBox, questItem)
end
local function MakeSelectiveObj(parent, questItem)
  local textBox = GetNotifierTextBoxFromPool(parent, questItem.questType)
  SetLevelColor(textBox, questItem)
  textBox.prefix:SetText("-")
  textBox:SetText(locale.questContext.selectiveObj)
  SetLayoutObjective(textBox, questItem)
  return textBox
end
local function MakeAggroObj(parent, questItem)
  local textBox = GetNotifierTextBoxFromPool(parent, questItem.questType)
  SetLevelColor(textBox, questItem)
  textBox.prefix:SetText("-")
  textBox:SetText(locale.questContext.aggroObj)
  SetLayoutObjective(textBox, questItem)
  return textBox
end
local function MakeGroupObj(parent, questItem)
  local textBox = GetNotifierTextBoxFromPool(parent, questItem.questType)
  SetLevelColor(textBox, questItem)
  textBox.prefix:SetText("-")
  textBox:SetText(locale.questContext.groupObj)
  SetLayoutObjective(textBox, questItem)
  return textBox
end
local function MakeScoreObj(parent, questItem, str)
  local textBox = GetNotifierTextBoxFromPool(parent, questItem.questType)
  SetLevelColor(textBox, questItem)
  textBox.prefix:SetText("-")
  textBox:SetText(str)
  SetLayoutObjective(textBox, questItem)
  return textBox
end
local function MakeScoreDescription(parent, questItem)
  local textBox = GetNotifierTextBoxFromPool(parent, questItem.questType)
  SetLevelColor(textBox, questItem)
  local cnt = X2Quest:GetScoreQuestCurrentScore(questItem.questType)
  local maxCnt = X2Quest:GetScoreQuestDoneScore(questItem.questType)
  textBox.prefix:SetText("-")
  textBox:SetText(string.format("%s %d/%d", locale.questContext.scoreCount, cnt, maxCnt))
  SetLayoutObjective(textBox, questItem)
  return textBox
end
local function MakeObjectives(parent, questItem)
  local objItems = questItem.objectives
  local labels = {}
  if questItem.status == 2 then
    return labels
  end
  local SetQusetItemButton = function(parent, questObj, index, isOnly)
    parent.questItemBtns = {}
    local width = 0
    local height = 0
    if questObj.status == 3 then
      local npc = X2Quest:GetQuestReportNpcTypeByQuestType(questObj.questType)
      if npc ~= nil then
        return width, height
      end
    end
    local itemTypes
    if isOnly then
      itemTypes = X2Quest:GetUseTypeQuestItems(questObj.questType, true)
      if itemTypes == nil then
        itemTypes = {}
      end
    else
      itemTypes = X2Quest:GetUseTypeQuestItemsByObjIndex(questObj.questType, index)
    end
    for i = 1, #itemTypes do
      local itype = itemTypes[i]
      if itype ~= nil then
        local itemInfo = X2Item:GetItemInfoByType(itype, 0, IIK_TYPE + IIK_GRADE)
        if itemInfo ~= nil then
          local btn = GetNotifierActionButtonFromPool(parent)
          btn:Show(true)
          btn.itemType = itype
          btn:SetExtent(ICON_SIZE.BUFF, ICON_SIZE.BUFF)
          btn:SetItemInfo(itemInfo)
          local xOffset = (#itemTypes - i) * 27
          btn:RemoveAllAnchors()
          btn:AddAnchor("TOPRIGHT", parent, "TOPLEFT", -xOffset, 0)
          SetNotifierItemButtonEventHandler(btn)
          btn:UpdateUsage()
          parent.questItemBtns[i] = btn
          local w, h = btn:GetExtent()
          height = math.max(height, h)
          width = math.max(width, xOffset + w)
        end
      end
    end
    if #itemTypes > 0 and Tutorial_ItemQuestStarted ~= nil then
      Tutorial_ItemQuestStarted(parent.questItemBtns)
    end
    return width, height
  end
  local objCnt = X2Quest:GetObjectiveComponentCount(questItem.questType)
  for i, obj in pairs(objItems) do
    if obj ~= nil and obj ~= "" then
      local label = GetNotifierTextBoxFromPool(parent, questItem.questType)
      SetLevelColor(label, questItem)
      local itemWidth, itemHeight = SetQusetItemButton(label, questItem, i, objCnt < 2)
      label.itemWidth = itemWidth
      label.prefix:SetText("\194\183")
      local str = obj
      if X2Quest:IsGroupQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
        str = string.format("[%s] %s", str, locale.questContext.questComplete)
      end
      label:SetText(str)
      SetLayoutObjective(label, questItem, itemWidth, itemHeight)
      labels[i] = label
    else
      labels[i] = nil
    end
  end
  return labels
end
local MakeTitle = function(parent, questItem, qType)
  local listTitle = questItem.listTitle
  if listTitle == false then
    listTitle = "unknown"
  end
  local label = GetNotifierLabelFromPool(parent, qType)
  label.style:SetFontSize(FONT_SIZE.LARGE)
  label:SetAutoResize(true)
  SetLevelColor(label, questItem)
  local showDailyMarker, dayInfo = X2Quest:IsDailyQuest(questItem.questType)
  local questGrade = X2Quest:GetQuestContextGrade(questItem.questType)
  local repeatable = X2Quest:IsRepeatableQuest(questItem.questType)
  local function GetMaxTitleWidth()
    local width = questLocale.notifier.titleDefaultWidth
    if showDailyMarker then
      width = width - label.dailyMarker:GetWidth()
    end
    if VisibleQuestGrade(questGrade) then
      width = width - label.gradeMarker:GetWidth()
    end
    if repeatable then
      width = width - label.repeatableMarker:GetWidth()
    end
    return width
  end
  label:SetText(listTitle)
  label.dailyMarker:SetDailyMaker(showDailyMarker, dayInfo)
  label.gradeMarker:Show(VisibleQuestGrade(questGrade))
  label.repeatableMarker:Show(repeatable)
  local target = label
  local myAnchor = "BOTTOMLEFT"
  local targetAnchor = "BOTTOMRIGHT"
  local offsetX = 2
  local offsetY = 0
  if showDailyMarker then
    label.dailyMarker:RemoveAllAnchors()
    label.dailyMarker:AddAnchor(myAnchor, target, targetAnchor, offsetX, offsetY)
    target = label.dailyMarker
    targetAnchor = "BOTTOMRIGHT"
    myAnchor = "BOTTOMLEFT"
    offsetX = 0
    offsetY = -1
  end
  if VisibleQuestGrade(questGrade) then
    label.gradeMarker:RemoveAllAnchors()
    label.gradeMarker:AddAnchor(myAnchor, target, targetAnchor, offsetX, offsetY)
    label.gradeMarker:SetQuestGrade(questGrade)
    target = label.gradeMarker
    targetAnchor = "BOTTOMRIGHT"
    myAnchor = "BOTTOMLEFT"
    offsetX = -3
    offsetY = 0
  end
  if repeatable then
    label.repeatableMarker:RemoveAllAnchors()
    label.repeatableMarker:AddAnchor(myAnchor, target, targetAnchor, offsetX, offsetY)
  end
  local width = label:GetWidth()
  if width > GetMaxTitleWidth() then
    width = GetMaxTitleWidth()
    label:SetAutoResize(false)
    label.style:SetEllipsis(true)
  end
  label:SetWidth(width)
  function label:OnClick(arg)
    if arg == "LeftButton" then
      if X2Input:IsShiftKeyDown() and X2Chat:IsActivatedChatInput() then
        local questLinkText = X2Quest:GetQuestLinkText(qType)
        X2Chat:AddQuestLinkToActiveChatInput(questLinkText)
      else
        local parent = label:GetParent()
        parent:OnClick()
      end
    end
  end
  label:SetHandler("OnClick", label.OnClick)
  function label:ReleaseEventHandler()
    label:ReleaseHandler("OnClick")
  end
  return label, width
end
local UpdateTitle = function(parent, questItem)
  local listTitle = questItem.listTitle
  if listTitle == false then
    listTitle = "unknown"
  end
  local label = GetNotifierLabelFromPool(parent, questItem.questType)
  SetLevelColor(label, questItem)
  label:SetText(listTitle)
  return label
end
function MakeNotifierQuestObjectiveGrid(parent, questItem)
  local rowHeight = 25
  local rowSpace = 5
  local grid = GetNotifierGridFromPool(parent, questItem.questType)
  grid:SetColCount(2)
  grid:SetColWidth(45, 1)
  grid.questType = questItem.questType
  local item = questItem
  local title, maxWidth = MakeTitle(grid, item, questItem.questType)
  local objectives = MakeObjectives(grid, item)
  local row = 1
  local height = 0
  local objHeight = 0
  grid.title = title
  grid:SetColWidth(maxWidth, 2)
  grid:SetItem(title, row, 2, true, 0, false)
  grid:SetRowHeight(rowHeight, row)
  row = row + 1
  if X2Quest:IsSelectiveQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
    local selectiveObj = MakeSelectiveObj(grid, questItem)
    height = selectiveObj:GetHeight() + rowSpace
    grid:SetItem(selectiveObj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  elseif questItem.isAggroComponent == true then
    local aggroObj = MakeAggroObj(grid, questItem)
    height = aggroObj:GetHeight() + rowSpace
    grid:SetItem(aggroObj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  elseif X2Quest:IsGroupQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
    local groupObj = MakeGroupObj(grid, questItem)
    height = groupObj:GetHeight() + rowSpace
    grid:SetItem(groupObj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  end
  if X2Quest:IsScoreQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
    local scoreObjStr = X2Quest:GetScoreQuestObjective(questItem.questType)
    if scoreObjStr ~= nil then
      local scoreObj = MakeScoreObj(grid, questItem, scoreObjStr)
      height = scoreObj:GetHeight() + rowSpace
      grid:SetItem(scoreObj, row, 2, true, 0, true)
      grid:SetRowHeight(height, row)
      grid:SetItemInset(row, 2, 0, 0, 0, 0)
      row = row + 1
      objHeight = objHeight + height
    end
    local scoreDesc = MakeScoreDescription(grid, questItem)
    height = scoreDesc:GetHeight() + rowSpace
    grid:SetItem(scoreDesc, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  end
  for _, obj in pairs(objectives) do
    height = math.max(obj:GetTextHeight(), obj:GetHeight()) + rowSpace
    grid:SetItem(obj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, obj.itemWidth, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  end
  local height = rowHeight + objHeight + 1
  if height < 55 then
    height = 55
  end
  return grid, height
end
function UpdateNotifierQuestObjectiveGrid(parent, questItem)
  local rowHeight = 25
  local rowSpace = 5
  local grid = GetNotifierGridFromPool(parent, questItem.questType)
  local title = UpdateTitle(grid, questItem)
  local objectives = MakeObjectives(grid, questItem)
  local row = 1
  local height = 0
  local objHeight = 0
  grid.title = title
  grid:SetItem(title, row, 2, true, 0, false)
  grid:SetRowHeight(rowHeight, row)
  row = row + 1
  if X2Quest:IsSelectiveQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
    local selectiveObj = MakeSelectiveObj(grid, questItem)
    height = selectiveObj:GetHeight() + rowSpace
    grid:SetItem(selectiveObj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  elseif questItem.isAggroComponent == true then
    local aggroObj = MakeAggroObj(grid, questItem)
    height = aggroObj:GetHeight() + rowSpace
    grid:SetItem(aggroObj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  elseif X2Quest:IsGroupQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
    local groupObj = MakeGroupObj(grid, questItem)
    height = groupObj:GetHeight() + rowSpace
    grid:SetItem(groupObj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  end
  if X2Quest:IsScoreQuest(questItem.questType) and not IsCompleteQuest(questItem.questType) then
    local scoreObjStr = X2Quest:GetScoreQuestObjective(questItem.questType)
    if scoreObjStr ~= nil then
      local scoreObj = MakeScoreObj(grid, questItem, scoreObjStr)
      height = scoreObj:GetHeight() + rowSpace
      grid:SetItem(scoreObj, row, 2, true, 0, true)
      grid:SetRowHeight(height, row)
      grid:SetItemInset(row, 2, 0, 0, 0, 0)
      row = row + 1
      objHeight = objHeight + height
    end
    local scoreDesc = MakeScoreDescription(grid, questItem)
    height = scoreDesc:GetHeight() + rowSpace
    grid:SetItem(scoreDesc, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, 0, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  end
  for _, obj in pairs(objectives) do
    height = math.max(obj:GetTextHeight(), obj:GetHeight()) + rowSpace
    grid:SetItem(obj, row, 2, true, 0, true)
    grid:SetRowHeight(height, row)
    grid:SetItemInset(row, 2, obj.itemWidth, 0, 0, 0)
    row = row + 1
    objHeight = objHeight + height
  end
  local height = rowHeight + objHeight + 1
  if height < 55 then
    height = 55
  end
end
function SetViewOfQuestNotifierWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptyWidget", id, 0, true)
  local mainQuestWnd = wnd:CreateChildWidget("emptywidget", "mainQuestWnd", 0, true)
  mainQuestWnd:AddAnchor("TOPLEFT", wnd, 0, 0)
  mainQuestWnd:AddAnchor("TOPRIGHT", wnd, 0, 0)
  mainQuestWnd:SetHeight(0)
  mainQuestWnd.seperator = mainQuestWnd:CreateDrawable(TEXTURE_PATH.QUEST_INFO, "main_puest_bg", "background")
  mainQuestWnd.seperator:SetVisible(false)
  local scrollWindow = CreateScrollWindow(wnd, "scrollWnd", 0)
  scrollWindow:RemoveAllAnchors()
  scrollWindow:AddAnchor("TOP", mainQuestWnd, "BOTTOM", 0, 0)
  scrollWindow:AddAnchor("LEFT", wnd, 0, 0)
  scrollWindow:AddAnchor("RIGHT", wnd, 0, 0)
  scrollWindow:AddAnchor("BOTTOM", wnd, 0, 0)
  scrollWindow:Show(true)
  scrollWindow:Lock(true)
  return wnd
end
