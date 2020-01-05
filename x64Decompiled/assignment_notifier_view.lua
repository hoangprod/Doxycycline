local CreateTitleWnd = function(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetHeight(32)
  local line = wnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_02", "background")
  line:SetTextureColor("black")
  line:SetExtent(180, 3)
  line:AddAnchor("TOPLEFT", wnd, 0, 0)
  line:AddAnchor("TOPRIGHT", wnd, 0, 0)
  local toggle = wnd:CreateChildWidget("button", "toggle", 0, true)
  toggle:AddAnchor("TOPRIGHT", line, "BOTTOMRIGHT", 0, 0)
  ApplyButtonSkin(toggle, BUTTON_HUD.QUEST_CLOSE)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(toggle:GetHeight())
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetSnap(true)
  title.style:SetShadow(true)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 20, 0)
  ApplyTextColor(title, FONT_COLOR.LABORPOWER_YELLOW)
  function wnd:SetLineVisible(visible)
    line:SetVisible(visible)
    line:SetHeight(visible and 3 or 0)
  end
  return wnd
end
local CreateAssignmentDescWnd = function(id, parent, index)
  local wnd = parent:CreateChildWidget("emptywidget", id, index, true)
  local achievementGrade = W_ICON.CreateAchievementGradeIcon(wnd)
  achievementGrade:AddAnchor("TOPLEFT", wnd, 0, 0)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.LARGE)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetSnap(true)
  title.style:SetShadow(true)
  title.style:SetEllipsis(true)
  title:AddAnchor("LEFT", achievementGrade, "RIGHT", 2, 0)
  title:AddAnchor("RIGHT", wnd, 0, 0)
  ApplyTextColor(title, FONT_COLOR.WHITE)
  local todayAssignmentGrade = W_ICON.CreateQuestGradeMarker(wnd)
  todayAssignmentGrade:AddAnchor("LEFT", title, "RIGHT", 2, -2)
  wnd.todayAssignmentGrade = todayAssignmentGrade
  local offset = 4
  local objective = wnd:CreateChildWidget("textbox", "objective", 0, true)
  objective:AddAnchor("TOPLEFT", achievementGrade, "BOTTOMLEFT", 0, offset)
  objective:AddAnchor("TOPRIGHT", title, "BOTTOMRIGHT", -10, offset)
  objective:SetInset(10, 0, 0, 0)
  objective:SetAutoResize(true)
  objective.style:SetSnap(true)
  objective.style:SetShadow(true)
  objective.style:SetAlign(ALIGN_TOP_LEFT)
  ApplyTextColor(objective, FONT_COLOR.WHITE)
  local prefix = wnd:CreateChildWidget("textbox", "prefix", 0, true)
  prefix:SetWidth(5)
  prefix:SetAutoResize(true)
  prefix.style:SetSnap(true)
  prefix.style:SetShadow(true)
  prefix:AddAnchor("TOPLEFT", objective, 2, 0)
  ApplyTextColor(prefix, FONT_COLOR.WHITE)
  local navigation = CreateNotifierNavigation("navigation", wnd)
  navigation:AddAnchor("RIGHT", wnd, "TOPLEFT", -10, 10)
  function wnd:SetNavigation(qType)
    SetNotifierNavigationEventHandler(navigation, qType)
  end
  function wnd:ClearNavigation()
    navigation.bg:SetVisible(true)
    navigation.dingbat:SetTexture(TEXTURE_PATH.QUEST_NOTIFIER)
    navigation.dingbat:SetTextureInfo("nothing")
  end
  function wnd:SetString(titleStr, objStr)
    title:SetText(titleStr)
    objective:SetText(objStr)
    local height = achievementGrade:GetHeight() + objective:GetTextHeight() + offset
    if height < 40 then
      height = 40
    end
    wnd:SetHeight(height)
    wnd:Show(true)
  end
  function wnd:SetPrefix(prefixStr)
    prefix:SetText(prefixStr)
  end
  function wnd:Clear()
    wnd:SetHeight(0)
    wnd:Show(false)
  end
  return wnd
end
local function CreateBodyWnd(id, parent, cnt)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local line = wnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_02", "background")
  line:SetTextureColor("black")
  line:SetExtent(180, 3)
  line:AddAnchor("TOPLEFT", wnd, 0, 0)
  line:AddAnchor("TOPRIGHT", wnd, 0, 0)
  wnd.line = line
  local achievements = {}
  local offsetY = 10
  function wnd:AdjustAchievement(cnt)
    local offsetX = 50
    local target = self.line
    for i = 1, cnt do
      if achievements[i] == nil then
        achievements[i] = CreateAssignmentDescWnd("achievements", wnd, i)
        achievements[i]:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", offsetX, offsetY)
        achievements[i]:AddAnchor("TOPRIGHT", target, "BOTTOMRIGHT", 0, offsetY)
      end
      target = achievements[i]
      offsetX = 0
    end
    self.maxCnt = cnt
  end
  wnd:AdjustAchievement(cnt)
  local emptyLabel = wnd:CreateChildWidget("textbox", "emptyLabel", 0, true)
  emptyLabel:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 0, 5)
  emptyLabel:AddAnchor("BOTTOMRIGHT", line, "BOTTOMRIGHT", 0, 35)
  emptyLabel:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  ApplyTextColor(emptyLabel, F_COLOR.GetColor("original_light_gray", false))
  emptyLabel:Show(false)
  function wnd:SetAchievementList(aList)
    for i = 1, #achievements do
      if i <= #aList then
        local info = X2Achievement:GetAchievementInfo(aList[i])
        local titleStr = info.name
        local objStr = info.summary
        if 1 < info.completeNum then
          local curValue = info.current ~= nil and info.current or 0
          objStr = string.format("%s %d/%d", objStr, curValue, info.completeNum)
        end
        local subKeyList = X2Achievement:GetAchievementSubList(info.type, AF_ALL)
        if subKeyList ~= nil then
          for i = 1, #subKeyList do
            local subKey = subKeyList[i]
            local info = X2Achievement:GetAchievementInfo(subKey)
            local completeStr = ""
            if info.complete then
              completeStr = string.format("[%s] ", GetCommonText("complete"))
            end
            objStr = objStr .. string.format("\r\n - %s%s", completeStr, info.summary)
          end
        end
        achievements[i]:SetString(titleStr, objStr)
        achievements[i]:SetPrefix("\194\183")
        achievements[i]:SetAchievementGrade(info.grade + 1)
        function Toggle()
          ToggleAssignmentWithAcheivement(aList[i])
        end
        achievements[i]:SetHandler("OnClick", Toggle)
      else
        achievements[i]:Clear()
        achievements[i]:ReleaseHandler("OnClick")
      end
    end
    emptyLabel:SetText(GetCommonText("assignment_can_traced"))
    emptyLabel:Show(#aList == 0)
    wnd:ApplyHeight()
  end
  function wnd:SetTodayQuestList(qList, todayType)
    local allDone = true
    local allReady = true
    local lastAchievement
    local isListed = false
    local maxCnt = X2Achievement:GetTodayAssignmentCount(todayType)
    if maxCnt > self.maxCnt then
      self:AdjustAchievement(maxCnt)
    end
    local function AnchorLast(achieve)
      achieve:RemoveAllAnchors()
      if lastAchievement ~= nil then
        achieve:AddAnchor("TOPLEFT", lastAchievement, "BOTTOMLEFT", 0, 10)
        achieve:AddAnchor("TOPRIGHT", lastAchievement, "BOTTOMRIGHT", 0, 10)
      else
        achieve:AddAnchor("TOPLEFT", self.line, "BOTTOMLEFT", 50, 10)
        achieve:AddAnchor("TOPRIGHT", self.line, "BOTTOMRIGHT", 0, 10)
      end
      lastAchievement = achieve
    end
    for i = 1, #achievements do
      if i <= #qList and qList[i] ~= 0 then
        do
          local qType = qList[i]
          local qInfo = X2Quest:GetTodayQuestInfo(qType)
          if qInfo == nil then
            achievements[i]:Clear()
          else
            local prefixStr = ""
            local titleStr = qInfo.title
            local objStr = ""
            AnchorLast(achievements[i])
            if X2Quest:IsSelectiveQuest(qType) then
              prefixStr = string.format("-\n")
              objStr = string.format("%s\n", locale.questContext.selectiveObj)
            elseif X2Quest:IsScoreQuest(qType) then
              local subTitleStr = X2Quest:GetQuestJournalProgTitleByType(qType)
              objStr = string.format("%s (%d/%d)\n", locale.questContext.scoreCount, qInfo.curValue, qInfo.maxValue)
              if subTitleStr == nil then
                prefixStr = string.format("-\n")
              else
                prefixStr = string.format([[
-
-
]])
                objStr = string.format([[
%s
%s]], subTitleStr, objStr)
              end
            end
            local count = X2Quest:GetObjectiveComponentCount(qType)
            for j = 1, count do
              local enterStr = ""
              if j ~= 1 then
                enterStr = "\n"
              end
              local str = X2Quest:GetObjective(qType, j) or ""
              if str ~= nil and str ~= "" then
                objStr = string.format("%s%s%s", objStr, enterStr, str)
                prefixStr = string.format("%s%s%s", prefixStr, enterStr, "\194\183")
                achievements[i].objective:SetText(str)
              end
            end
            achievements[i].todayAssignmentGrade:SetQuestGrade(qInfo.grade)
            achievements[i]:SetString(titleStr, objStr)
            achievements[i]:SetPrefix(prefixStr)
            achievements[i]:SetNavigation(qType)
            if achievements[i].todayAssignmentGrade:IsVisible() then
              achievements[i].title:RemoveAllAnchors()
              achievements[i].title:AddAnchor("TOPLEFT", achievements[i], 0, 0)
              achievements[i].title:AddAnchor("RIGHT", achievements[i], -achievements[i].todayAssignmentGrade:GetWidth(), 0)
              local offset = achievements[i].title.style:GetTextWidth(achievements[i].title:GetText())
              achievements[i].todayAssignmentGrade:RemoveAllAnchors()
              achievements[i].todayAssignmentGrade:AddAnchor("LEFT", achievements[i].title, offset + 2, -2)
            end
            function Toggle()
              if X2Achievement:IsTodayAssignmentQuest(TADT_EXPEDITION, qType) == true then
                ToggleExpeditionAssignmentWithQuest(qType)
              elseif X2Achievement:IsTodayAssignmentQuest(TADT_FAMILY, qType) == true then
                ToggleFamilyAssignmentWithQuest(qType)
              elseif X2Achievement:IsTodayAssignmentQuest(TADT_HERO, qType) == true then
                ToggleHeroWithQuest(qType)
              elseif X2Achievement:IsTodayAssignmentQuest(TADT_ARCHE_PASS, qType) == true then
                ToggleArchePassWithQuest(qType)
              else
                ToggleAssignmentWithQuest(qType)
              end
            end
            achievements[i]:SetHandler("OnClick", Toggle)
          end
        end
      else
        achievements[i]:Clear()
        achievements[i]:ReleaseHandler("OnClick")
      end
    end
    local aCount = X2Achievement:GetTodayAssignmentCount(todayType)
    for i = 1, aCount do
      local aInfo = X2Achievement:GetTodayAssignmentInfo(todayType, i)
      if aInfo.status ~= 3 then
        allDone = false
      end
      if aInfo.status == 2 then
        allReady = false
      end
    end
    if allDone then
      emptyLabel:SetText(GetCommonText("today_quest_finished"))
    elseif allReady then
      if todayType == TADT_EXPEDITION then
        emptyLabel:SetText(GetCommonText("expedition_today_quest_can_taken"))
      elseif todayType == TADT_FAMILY then
        emptyLabel:SetText(GetCommonText("family_today_quest_can_taken"))
      else
        emptyLabel:SetText(GetCommonText("today_quest_can_taken"))
      end
    else
      emptyLabel:SetText(GetCommonText("today_quest_can_traced"))
    end
    emptyLabel:Show(lastAchievement == nil)
    wnd:ApplyHeight()
  end
  function wnd:ApplyHeight()
    local height = line:GetHeight() + offsetY
    for i = 1, #achievements do
      if achievements[i]:IsVisible() then
        height = height + achievements[i]:GetHeight() + offsetY
      end
    end
    if emptyLabel:IsVisible() then
      height = height + emptyLabel:GetHeight()
    end
    wnd:SetHeight(height)
  end
  return wnd
end
local function CreateTodayQuestWnd(id, parent, todayType, titleStr)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local titleWnd = CreateTitleWnd("titleWnd", wnd)
  titleWnd:AddAnchor("TOPLEFT", wnd, 0, 0)
  titleWnd:AddAnchor("TOPRIGHT", wnd, 0, 0)
  titleWnd.title:SetText(titleStr)
  local maxCnt = X2Achievement:GetTodayAssignmentCount(todayType)
  local bodyWnd = CreateBodyWnd("bodyWnd", wnd, maxCnt)
  bodyWnd:AddAnchor("TOPLEFT", titleWnd, "BOTTOMLEFT", 0, 0)
  bodyWnd:AddAnchor("TOPRIGHT", titleWnd, "BOTTOMRIGHT", 0, 0)
  function wnd:SetToggleCallback(func)
    wnd.toggleCallbackFunc = func
  end
  function wnd:MakeList()
    local qList = GetTodayQuestList()
    local sortList = {}
    for i = 1, #qList do
      if X2Achievement:IsTodayAssignmentQuest(todayType, qList[i]) then
        table.insert(sortList, qList[i])
      end
    end
    bodyWnd:SetTodayQuestList(sortList, todayType)
    wnd:ApplyHeight()
  end
  function wnd:SetOpenState(open)
    titleWnd.toggle.isOpen = open
    if open then
      ApplyButtonSkin(titleWnd.toggle, BUTTON_HUD.QUEST_CLOSE)
    else
      ApplyButtonSkin(titleWnd.toggle, BUTTON_HUD.QUEST_OPEN)
    end
    bodyWnd:Show(open)
    wnd:ApplyHeight()
    if wnd.toggleCallbackFunc ~= nil then
      wnd.toggleCallbackFunc(open)
    end
  end
  function titleWnd.toggle:OnClick()
    wnd:SetOpenState(not titleWnd.toggle.isOpen)
  end
  titleWnd.toggle:SetHandler("OnClick", titleWnd.toggle.OnClick)
  function wnd:ApplyHeight()
    local height = titleWnd:GetHeight()
    if bodyWnd:IsVisible() then
      height = height + bodyWnd:GetHeight()
    end
    wnd:SetHeight(height)
  end
  return wnd
end
local function CreateAchievementWnd(id, parent, kind, titleStr)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local titleWnd = CreateTitleWnd("titleWnd", wnd)
  titleWnd:AddAnchor("TOPLEFT", wnd, 0, 0)
  titleWnd:AddAnchor("TOPRIGHT", wnd, 0, 0)
  titleWnd.title:SetText(titleStr)
  local bodyWnd = CreateBodyWnd("bodyWnd", wnd, MAX_TRACING_ACHIEVEMENT)
  bodyWnd:AddAnchor("TOPLEFT", titleWnd, "BOTTOMLEFT", 0, 0)
  bodyWnd:AddAnchor("TOPRIGHT", titleWnd, "BOTTOMRIGHT", 0, 0)
  function wnd:SetToggleCallback(func)
    wnd.toggleCallbackFunc = func
  end
  function wnd:MakeList()
    local aList = X2Achievement:GetAchievementTracingList(kind)
    bodyWnd:SetAchievementList(aList)
    wnd:ApplyHeight()
  end
  function wnd:SetOpenState(open)
    titleWnd.toggle.isOpen = open
    if open then
      ApplyButtonSkin(titleWnd.toggle, BUTTON_HUD.QUEST_CLOSE)
    else
      ApplyButtonSkin(titleWnd.toggle, BUTTON_HUD.QUEST_OPEN)
    end
    bodyWnd:Show(open)
    wnd:ApplyHeight()
    if wnd.toggleCallbackFunc ~= nil then
      wnd.toggleCallbackFunc(open)
    end
  end
  function titleWnd.toggle:OnClick()
    wnd:SetOpenState(not titleWnd.toggle.isOpen)
  end
  titleWnd.toggle:SetHandler("OnClick", titleWnd.toggle.OnClick)
  function wnd:ApplyHeight()
    local height = titleWnd:GetHeight()
    if bodyWnd:IsVisible() then
      height = height + bodyWnd:GetHeight()
    end
    wnd:SetHeight(height)
  end
  return wnd
end
function SetViewOfAssignmentNotifierWnd(id, parent)
  local wnd = CreateScrollWindow(parent, id, 0)
  wnd:SetValue(0)
  wnd:ResetScroll(0)
  local todayQuestWnd, racialAchievementWnd, normalAchievementWnd, collectionAchievementWnd
  wnd.lastWnd = nil
  wnd.firstWnd = nil
  function wnd:AnchorLast(subwnd)
    if self.firstWnd == subwnd then
      self.lastWnd = subwnd
      return
    end
    subwnd:RemoveAllAnchors()
    if self.lastWnd == nil then
      self.firstWnd = subwnd
      self.scroll.vs:SetValue(0, true)
      subwnd:AddAnchor("TOPLEFT", self.content, 0, 10)
      subwnd:AddAnchor("TOPRIGHT", self.content, 0, 0)
      subwnd.titleWnd:SetLineVisible(false)
    else
      subwnd:AddAnchor("TOPLEFT", self.lastWnd, "BOTTOMLEFT", 0, 0)
      subwnd:AddAnchor("TOPRIGHT", self.lastWnd, "BOTTOMRIGHT", 0, 0)
      subwnd.titleWnd:SetLineVisible(true)
    end
    self.lastWnd = subwnd
  end
  if X2Player:GetFeatureSet().archePass then
    todayArchePassQuestWnd = CreateTodayQuestWnd("todayArchePassQuestWnd", wnd.content, TADT_ARCHE_PASS, GetCommonText("arche_pass"))
    wnd:AnchorLast(todayArchePassQuestWnd)
    wnd.todayArchePassQuestWnd = todayArchePassQuestWnd
    todayArchePassQuestWnd:SetOpenState(GetTodayArchePassQuestOpenState())
    todayArchePassQuestWnd:ApplyHeight()
  end
  if X2Player:GetFeatureSet().todayAssignment then
    todayQuestWnd = CreateTodayQuestWnd("todayQuestWnd", wnd.content, TADT_TODAY, GetCommonText("today_assignment"))
    wnd:AnchorLast(todayQuestWnd)
    wnd.todayQuestWnd = todayQuestWnd
    todayQuestWnd:SetOpenState(GetTodayQuestOpenState())
    todayQuestWnd:ApplyHeight()
  end
  if X2Player:GetFeatureSet().expeditionLevel then
    todayExpeditionQuestWnd = CreateTodayQuestWnd("todayExpeditionQuestWnd", wnd.content, TADT_EXPEDITION, GetCommonText("expedition_today_quest"))
    wnd:AnchorLast(todayExpeditionQuestWnd)
    wnd.todayExpeditionQuestWnd = todayExpeditionQuestWnd
    todayExpeditionQuestWnd:SetOpenState(GetTodayExpeditionQuestOpenState())
    todayExpeditionQuestWnd:ApplyHeight()
  end
  todayFamilyQuestWnd = CreateTodayQuestWnd("todayFamilyQuestWnd", wnd.content, TADT_FAMILY, GetCommonText("family_happy_life"))
  wnd:AnchorLast(todayFamilyQuestWnd)
  wnd.todayFamilyQuestWnd = todayFamilyQuestWnd
  todayFamilyQuestWnd:SetOpenState(GetTodayFamilyQuestOpenState())
  todayFamilyQuestWnd:ApplyHeight()
  heroQuestWnd = CreateTodayQuestWnd("heroQuestWnd", wnd.content, TADT_HERO, GetCommonText("hero_quest"))
  wnd:AnchorLast(heroQuestWnd)
  wnd.heroQuestWnd = heroQuestWnd
  heroQuestWnd:SetOpenState(GetHeroQuestOpenState())
  heroQuestWnd:ApplyHeight()
  if X2Player:GetFeatureSet().achievement then
    racialAchievementWnd = CreateAchievementWnd("racialAchievementWnd", wnd.content, EAK_RACIAL_MISSION, GetCommonText("racial_assignment"))
    wnd:AnchorLast(racialAchievementWnd)
    racialAchievementWnd:SetOpenState(GetRacialAchievementOpenState())
    racialAchievementWnd:ApplyHeight()
    wnd.racialAchievementWnd = racialAchievementWnd
    normalAchievementWnd = CreateAchievementWnd("normalAchievementWnd", wnd.content, EAK_ACHIEVEMENT, GetCommonText("achievement"))
    wnd:AnchorLast(normalAchievementWnd)
    normalAchievementWnd:SetOpenState(GetGeneralAchievementOpenState())
    normalAchievementWnd:ApplyHeight()
    wnd.normalAchievementWnd = normalAchievementWnd
    if locale.GetAllAchievementKindString()[EAK_COLLECTION] ~= nil then
      collectionAchievementWnd = CreateAchievementWnd("collectionAchievementWnd", wnd.content, EAK_COLLECTION, GetUIText(COMMON_TEXT, "collect"))
      wnd:AnchorLast(collectionAchievementWnd)
      collectionAchievementWnd:SetOpenState(GetCollectionAchievementOpenState())
      collectionAchievementWnd:ApplyHeight()
      wnd.collectionAchievementWnd = collectionAchievementWnd
    end
  end
  return wnd
end
