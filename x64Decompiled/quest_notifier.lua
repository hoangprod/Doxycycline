local MAX_DECAL_CNT = 10
local GetCheckedQuest = function(isInit)
  local FindQuestInMergedItem = function(qtype)
    local mergedQuests = GetLastMergedQuests()
    if mergedQuests == nil or mergedQuests.categoryGroup == nil then
      return nil
    end
    for _, quests in pairs(mergedQuests.categoryGroup) do
      for _, quest in pairs(quests) do
        if quest.questType == qtype then
          return quest
        end
      end
    end
  end
  local qtypeList = GetNotifierQuestList()
  local questTable = {}
  for i = 1, #qtypeList do
    local qtype = qtypeList[i]
    if FindQuestInMergedItem(qtype) ~= nil then
      table.insert(questTable, FindQuestInMergedItem(qtype))
    else
      table.insert(questTable, GetQuestInfo(IndexFromQuestType(qtype), qtype))
    end
  end
  return questTable
end
function SetNotifierItemButtonEventHandler(widget)
  function widget:OnEnter()
    if self.itemType ~= nil then
      local info = X2Item:GetItemInfoByType(self.itemType)
      HideTooltip()
      ShowTooltip(info, self, 1, true, ONLY_BASE)
    end
  end
  widget:SetHandler("OnEnter", widget.OnEnter)
  function widget:OnLeave()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", widget.OnLeave)
  function widget:OnClick()
    if self.itemType == nil or self.itemType == 0 then
      return
    end
    if self.idType == "bagSlot" then
      X2Bag:UseItemByType(self.itemType)
    elseif self.idType == "equipSlot" then
      X2Equipment:UseEquippedItemByType(self.itemType)
    end
  end
  widget:SetHandler("OnClick", widget.OnClick)
  function widget:ReleaseEventHandler()
    widget:ReleaseHandler("OnClick")
    widget:ReleaseHandler("OnEnter")
    widget:ReleaseHandler("OnLeave")
  end
  AddOnUpdateCooldown(widget)
  function widget:UpdateUsage()
    if self.itemType == nil then
      return
    end
    local slot = X2Bag:FindFirstBagSlotItemByItemType(self.itemType)
    if slot ~= nil then
      self.idType = "bagSlot"
      self:Enable(true)
      return
    end
    local equipSlot = X2Equipment:FindEquippedItemByType(self.itemType)
    if equipSlot ~= nil then
      self.idType = "equipSlot"
      self:Enable(true)
      return
    end
    self:Enable(false)
  end
  local bagEvents = {
    BAG_UPDATE = function()
      widget:UpdateUsage()
    end,
    UNIT_EQUIPMENT_CHANGED = function(equipSlot)
      if equipSlot == -1 then
        widget:UpdateUsage()
      end
    end
  }
  widget:SetHandler("OnEvent", function(this, event, ...)
    bagEvents[event](...)
  end)
  RegistUIEvent(widget, bagEvents)
end
local SetNotifierTaskMarkEventHandler = function(widget, qType)
  local parent = widget:GetParent()
  local inset = questContext.notifierGrid.taskMarkInset
  parent:SetItemInset(1, 1, inset[1], inset[2], inset[3], inset[4])
  parent:SetItem(widget, 1, 1, true, 0, true)
  widget:Show(true)
  function widget:OnClick()
    if IsCompleteQuest(qType) then
      ShowTaskQuestReport(qType)
    else
      ShowTaskQuestJournal(qType)
    end
  end
  widget:SetHandler("OnClick", widget.OnClick)
  function widget:ReleaseEventHandler()
    widget:ReleaseHandler("OnClick")
  end
end
function SetNotifierNavigationEventHandler(widget, qType)
  widget:Show(true)
  widget.decalIndex = nil
  widget.ableDecal = false
  widget.heightState = nil
  local function ClearDingbat()
    widget.chk:SetAlpha(0)
    widget.bg:SetVisible(true)
    widget.dingbat:SetVisible(false)
    widget.decalIndex = nil
  end
  local function SetDingbat(decalIndex, questType, heightState)
    widget.ableDecal = X2Decal:CanMakeDirectionGuide(questType) or false
    widget.decalIndex = decalIndex
    widget.heightState = heightState
    widget.dingbat:SetVisible(true)
    local function SetUnableDecalDingbat()
      widget.bg:SetVisible(true)
      widget.dingbat:SetTexture(TEXTURE_PATH.QUEST_NOTIFIER)
      widget.dingbat:SetTextureInfo("nothing")
    end
    local function SetDecalHeightDingbat(height)
      if height == nil then
        widget.dingbat:SetVisible(false)
      else
        widget.dingbat:SetTexture(TEXTURE_PATH.QUEST_NOTIFIER)
        widget.dingbat:SetTextureInfo(widget.heightState)
      end
    end
    if widget.heightState ~= nil then
      SetDecalHeightDingbat(widget.heightState)
      return
    end
    if widget.decalIndex == nil or widget.decalIndex > MAX_DECAL_CNT then
      widget.bg:SetVisible(true)
      if not widget.ableDecal then
        SetUnableDecalDingbat()
      else
        widget.dingbat:SetVisible(false)
      end
      return
    end
    if widget.ableDecal then
      widget.bg:SetVisible(false)
      widget.dingbat:SetTexture(TEXTURE_PATH.MAP_ICON)
      if decalIndex <= MAX_DECAL_CNT then
        local dingbatCoords = {}
        dingbatCoords[0] = {
          480,
          72,
          24,
          24
        }
        dingbatCoords[1] = {
          288,
          24,
          24,
          24
        }
        dingbatCoords[2] = {
          312,
          24,
          24,
          24
        }
        dingbatCoords[3] = {
          336,
          24,
          24,
          24
        }
        dingbatCoords[4] = {
          360,
          24,
          24,
          24
        }
        dingbatCoords[5] = {
          384,
          24,
          24,
          24
        }
        dingbatCoords[6] = {
          408,
          24,
          24,
          24
        }
        dingbatCoords[7] = {
          432,
          24,
          24,
          24
        }
        dingbatCoords[8] = {
          456,
          24,
          24,
          24
        }
        dingbatCoords[9] = {
          480,
          24,
          24,
          24
        }
        dingbatCoords[10] = {
          360,
          96,
          24,
          24
        }
        local coords = dingbatCoords[decalIndex]
        widget.dingbat:SetTexture(TEXTURE_PATH.MAP_ICON)
        widget.dingbat:SetCoords(coords[1], coords[2], coords[3], coords[4])
        if decalIndex == 0 or decalIndex == 10 then
          widget.dingbat:SetExtent(24, 24)
        else
          widget.dingbat:SetExtent(30, 28)
        end
      end
    else
      SetUnableDecalDingbat()
    end
  end
  local function UpdateChk()
    local decalIndex = GetNotifierDecal(qType)
    if decalIndex ~= nil then
      widget.chk:Enable(true)
    elseif not X2Decal:CanMakeGuidedDecal(qType) or GetNotifierEmptyDecal(qType) == nil then
      widget.chk:Enable(false)
    else
      widget.chk:Enable(true)
    end
  end
  local decalIndex = GetNotifierDecal(qType)
  if decalIndex ~= nil then
    X2Decal:SetQuestGuidDecalByIndex(decalIndex, qType, true)
  else
    X2Decal:SetQuestGuidDecalByIndex(-1, qType, false)
  end
  UpdateChk()
  SetDingbat(decalIndex, qType)
  widget.chk:SetChecked(decalIndex ~= nil)
  local isOnEnter = false
  local function OnEnter(self)
    UpdateChk()
    isOnEnter = true
    if widget.ableDecal then
      self:SetAlpha(1)
      widget.dingbat:SetVisible(false)
    else
      self:SetAlpha(0)
      widget.dingbat:SetVisible(true)
    end
    widget.bg:SetVisible(true)
    if not widget.ableDecal then
      SetTooltip(GetUIText(QUEST_TEXT, "cannotDecal"), self)
    elseif widget.heightState ~= nil then
      if widget.heightState == "upstair" then
        SetTooltip(GetUIText(COMMON_TEXT, "quest_destination_height_up"), self)
      elseif widget.heightState == "downstair" then
        SetTooltip(GetUIText(COMMON_TEXT, "quest_destination_height_down"), self)
      elseif widget.heightState == "flag" then
        SetTooltip(GetUIText(COMMON_TEXT, "quest_destination_height_flush"), self)
      end
    elseif GetNotifierEmptyDecal(qType) == nil then
      SetTooltip(GetUIText(QUEST_TEXT, "nonDingbet"), self)
    else
      SetTooltip(GetUIText(COMMON_TEXT, "quest_able_decal"), self)
    end
  end
  widget.chk:SetHandler("OnEnter", OnEnter)
  local function OnLeave(self)
    isOnEnter = false
    self:SetAlpha(0)
    SetDingbat(widget.decalIndex, qType, widget.heightState)
    HideTooltip()
  end
  widget.chk:SetHandler("OnLeave", OnLeave)
  local function OnClick(self)
    local decalIndex = GetNotifierDecal(qType)
    if decalIndex ~= nil then
      RemoveNotifierDecal(decalIndex, qType)
      ClearDingbat()
    else
      local decalIndex = GetNotifierEmptyDecal(qType)
      if decalIndex ~= nil then
        SetNotifierDecal(decalIndex, qType)
        self:SetAlpha(0)
        SetDingbat(decalIndex, qType, widget.heightState)
      end
    end
  end
  widget.chk:SetHandler("OnClick", OnClick)
  local updateTime = 100
  local function SetNavigationInfo(dt, prevAngle, info)
    updateTime = updateTime + dt
    if updateTime < 100 then
      return
    end
    updateTime = 0
    widget.arrow:SetMoveEffectCircle(1, prevAngle, info.angle)
    widget.arrow:SetVisible(true)
    local heightState
    if info.dist > 3000 then
      widget.distance:Show(false)
      widget.farDistance:Show(true)
    elseif info.dist < 5 then
      widget.arrow:SetVisible(false)
      widget.farDistance:Show(false)
      widget.distance:Show(true)
      widget.distance:SetText(string.format("%dm", info.dist))
      if info.height > 2 then
        heightState = "upstair"
      elseif info.height < -2 then
        heightState = "downstair"
      else
        heightState = "flag"
      end
    else
      widget.farDistance:Show(false)
      widget.distance:Show(true)
      widget.distance:SetText(string.format("%dm", info.dist))
    end
    if not widget.ableDecal then
      widget.distance:Show(false)
      widget.arrow:SetVisible(false)
      widget.farDistance:Show(false)
      return
    end
    if isOnEnter then
      return
    end
    SetDingbat(widget.decalIndex, qType, heightState)
  end
  local info = X2Quest:GetQuestDirInfo(qType)
  local prevAngle = math.floor(info.angle) or 0
  widget.arrow:SetVisible(true)
  SetNavigationInfo(0, prevAngle, info)
  local function OnUpdate(self, dt)
    local info = X2Quest:GetQuestDirInfo(qType)
    if info == nil then
      return
    end
    if info.angle ~= nil then
      info.angle = math.floor(info.angle)
    end
    SetNavigationInfo(dt, prevAngle, info)
    if prevAngle ~= info.angle and self.arrow:IsVisible() then
      self.arrow:SetStartEffect(true)
    end
    prevAngle = info.angle
  end
  widget:SetHandler("OnUpdate", OnUpdate)
  function widget:ReleaseEventHandler()
    widget:ReleaseHandler("OnClick")
    widget:ReleaseHandler("OnLeave")
    widget:ReleaseHandler("OnEnter")
  end
end
local SetNotifierQuestEmptyWidgetEventHandler = function(widget, title, questIndex, qType)
  function widget:OnClick()
    if X2Quest:IsMainQuest(qType) == false then
      questContext.contextListBack.tab:SelectTab(1)
    else
      questContext.contextListBack.tab:SelectTab(2)
    end
    if X2Quest:IsTaskQuest(qType) then
      ShowTaskQuestJournal(qType)
    else
      FillDetailInfos(qType)
      SelectQuestList(qType)
      ADDON:ShowContent(UIC_QUEST_LIST, true)
    end
  end
  widget:SetHandler("OnClick", widget.OnClick)
  local function OnEnter()
    local decalIndex = GetNotifierDecal(qType)
    if decalIndex ~= nil then
      StartNotifyQuestEffect(qType, true)
    end
  end
  widget:SetHandler("OnEnter", OnEnter)
  local function OnLeave()
    local decalIndex = GetNotifierDecal(qType)
    if decalIndex ~= nil then
      StartNotifyQuestEffect(qType, false)
    end
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeave)
  local function TitleOnEnter(self)
    local GetQuestObjectiveSummary = function(qType)
      local GetQuestObjectivesNonCheckCategory = function(qType)
        local objectveItems = {}
        local count = X2Quest:GetQuestJournalObjectiveCountByType(qType)
        local index = 1
        for i = 1, count do
          local idx = IndexFromQuestType(qType)
          local object = X2Quest:GetQuestJournalObjectiveText(idx, i)
          if object ~= nil then
            local item = {}
            item.summary = object.summary
            item.status = object.status
            item.done = object.done
            item.object = object
            objectveItems[index] = item
            index = index + 1
          end
        end
        return objectveItems
      end
      local summary
      local objectives = GetQuestObjectivesNonCheckCategory(qType)
      for _, obj in pairs(objectives) do
        summary = obj.summary
        if summary ~= nil then
          break
        end
      end
      return summary
    end
    local summary = GetQuestObjectiveSummary(qType)
    summary = summary or ""
    if summary == "" then
      HideTooltip()
      return
    end
    summary = X2Util:ApplyUIMacroString(summary)
    SetHorizonTooltip(summary, self, 50)
  end
  title:SetHandler("OnEnter", TitleOnEnter)
  local TitleOnLeave = function()
    HideTooltip()
  end
  title:SetHandler("OnLeave", TitleOnLeave)
  function widget:ReleaseEventHandler()
    widget:ReleaseHandler("OnClick")
    widget:ReleaseHandler("OnLeave")
    widget:ReleaseHandler("OnEnter")
  end
end
function CreateQuestNotifierWnd(id, parent)
  local wnd = SetViewOfQuestNotifierWnd(id, parent)
  function wnd:MakeQuestNotifyList(show, inInit)
    local scrollValue = wnd.scrollWnd.scroll.vs:GetValue()
    wnd.scrollWnd:SetValue(0)
    wnd.scrollWnd:ResetScroll(0)
    wnd.mainQuestWnd:SetHeight(0)
    if show == nil then
      show = GetNotifierOpenState()
    end
    if inInit == nil then
      inInit = false
    end
    ResetAllNotifierComponentPool()
    local questList = GetCheckedQuest(inInit)
    local count = #questList
    local parent
    local maxDecalCount = 9
    local yOffset = 8
    local defaultOffsetY = yOffset
    wnd.mainQuestWnd.seperator:SetVisible(false)
    for i = 1, count do
      do
        local questInfo = questList[i]
        if questInfo ~= nil then
          do
            local grid, height
            if X2Quest:IsMainQuest(questInfo.questType) then
              parent = wnd.mainQuestWnd
              grid, height = MakeNotifierQuestObjectiveGrid(parent, questInfo)
              grid:RemoveAllAnchors()
              grid:AddAnchor("TOPLEFT", parent, 7, defaultOffsetY)
              grid:SetExtent(questLocale.notifier.gridWidth, height)
              grid:Show(show)
              parent:SetHeight(height + defaultOffsetY * 2)
              if show then
                wnd.mainQuestWnd.seperator:RemoveAllAnchors()
                wnd.mainQuestWnd.seperator:AddAnchor("TOPLEFT", wnd.mainQuestWnd, 0, 0)
                wnd.mainQuestWnd.seperator:AddAnchor("BOTTOMRIGHT", wnd.mainQuestWnd, 0, 0)
                wnd.mainQuestWnd.seperator:SetVisible(true)
              end
            else
              parent = wnd.scrollWnd.content
              grid, height = MakeNotifierQuestObjectiveGrid(parent, questInfo)
              grid:RemoveAllAnchors()
              grid:AddAnchor("TOPLEFT", parent, 7, yOffset)
              grid:SetExtent(questLocale.notifier.gridWidth, height)
              grid:Show(show)
              yOffset = yOffset + height
            end
            if X2Quest:IsTaskQuest(questInfo.questType) then
              SetNotifierTaskMarkEventHandler(grid.taskMark, questInfo.questType)
            else
              SetNotifierNavigationEventHandler(grid.navigation, questInfo.questType)
              grid:SetItemInset(1, 1, 0, -5, 0, 0)
              grid:SetItem(grid.navigation, 1, 1, true, 0, true)
            end
            SetNotifierQuestEmptyWidgetEventHandler(grid, grid.title, questInfo.questIndex, questInfo.questType)
            if grid.clockWnd == nil then
              grid.clockWnd = CreateNotifierClockWindow("questLeftTimeClock" .. i, wnd)
            end
            grid.clockWnd:RemoveAllAnchors()
            grid.clockWnd:AddAnchor("TOPRIGHT", grid, "TOPLEFT", -8, -4)
            local function SetTime(leftTime)
              if leftTime > 0 then
                grid.clockWnd:Update(leftTime, "msec")
                grid.clockWnd:Show(true)
              else
                grid.clockWnd.time:SetText("")
                grid.clockWnd:Show(false)
              end
            end
            local leftTime = X2Quest:GetQuestContextLeftTime(questInfo.questType)
            SetTime(leftTime)
            local leftTimeEvent = {
              QUEST_LEFT_TIME_UPDATED = function(self, qtype, leftTime)
                if questInfo.questType ~= qtype then
                  return
                end
                SetTime(leftTime)
              end
            }
            grid.clockWnd:SetHandler("OnEvent", function(this, event, ...)
              leftTimeEvent[event](clockWnd, ...)
            end)
            grid.clockWnd:RegisterEvent("QUEST_LEFT_TIME_UPDATED")
            function grid.clockWnd:UpdateVisible()
              local _, tOffset = grid.clockWnd:GetOffset()
              local _, tExtent = grid.clockWnd:GetExtent()
              local _, qOffset = parent:GetOffset()
              local _, qExtent = parent:GetExtent()
              local showPercent = 0.7
              if qOffset > tOffset + tExtent * (1 - showPercent) then
                grid.clockWnd:SetAlpha(0)
              elseif qOffset + qExtent < tOffset + tExtent * showPercent then
                grid.clockWnd:SetAlpha(0)
              else
                grid.clockWnd:SetAlpha(1)
              end
            end
          end
        end
      end
    end
    wnd.scrollWnd.contentHeight = yOffset
    wnd.scrollWnd:ResetScroll(yOffset)
    if scrollValue < 0 then
      scrollValue = 0
    end
    if yOffset > wnd.scrollWnd:GetHeight() then
      wnd.scrollWnd:SetValue(math.min(scrollValue, yOffset - wnd.scrollWnd:GetHeight()))
    end
    wnd.scrollWnd.SliderChangedProc = UpdateAllClockVisibleInGrid
    wnd.scrollWnd:SetHandler("OnChangedAnchor", UpdateAllClockVisibleInGrid)
    UpdateAllClockVisibleInGrid()
    wnd:ResetScrollInfo()
  end
  function wnd:UpdateQuestNotifyList(qtype)
    local questList = GetCheckedQuest(false)
    local count = #questList
    local parent, questInfo
    ResetNotifierTextBoxPoolByQuestType(qtype)
    for i = 1, count do
      if questList[i].questType == qtype then
        questInfo = questList[i]
      end
    end
    if questInfo ~= nil then
      local grid, height
      if X2Quest:IsMainQuest(questInfo.questType) then
        parent = wnd.mainQuestWnd
        UpdateNotifierQuestObjectiveGrid(parent, questInfo)
      else
        parent = wnd.scrollWnd.content
        UpdateNotifierQuestObjectiveGrid(parent, questInfo)
      end
    end
  end
  function wnd:ResetScrollInfo()
    local contentHeight = wnd.scrollWnd.contentHeight
    local lockScroll = false
    if contentHeight ~= nil and GetNotifierOpenState() then
      if contentHeight < wnd.scrollWnd:GetHeight() then
        contentHeight = 0
        lockScroll = true
      end
      wnd.scrollWnd:ResetScroll(contentHeight)
      wnd.scrollWnd:Lock(lockScroll)
    end
  end
  return wnd
end
