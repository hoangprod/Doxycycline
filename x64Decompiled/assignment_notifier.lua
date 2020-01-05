function CreateAssignmentNotifierWnd(id, parent)
  local wnd = SetViewOfAssignmentNotifierWnd(id, parent)
  function wnd:ResetScrollInfo()
    local scrollValue = wnd.scroll.vs:GetValue()
    wnd:SetValue(0)
    wnd:ResetScroll(0)
    local height = 10
    if wnd.todayQuestWnd ~= nil then
      height = height + wnd.todayQuestWnd:GetHeight()
    end
    if wnd.todayExpeditionQuestWnd ~= nil then
      height = height + wnd.todayExpeditionQuestWnd:GetHeight()
    end
    if wnd.todayFamilyQuestWnd ~= nil then
      height = height + wnd.todayFamilyQuestWnd:GetHeight()
    end
    if wnd.heroQuestWnd ~= nil then
      height = height + wnd.heroQuestWnd:GetHeight()
    end
    if wnd.racialAchievementWnd ~= nil then
      height = height + wnd.racialAchievementWnd:GetHeight()
    end
    if wnd.normalAchievementWnd ~= nil then
      height = height + wnd.normalAchievementWnd:GetHeight()
    end
    if wnd.collectionAchievementWnd ~= nil then
      height = height + wnd.collectionAchievementWnd:GetHeight()
    end
    wnd.height = height
    wnd:ResetScroll(height)
    if height > wnd:GetHeight() then
      wnd:SetValue(math.min(math.max(scrollValue, 0), height - wnd:GetHeight()))
    end
    local lockScroll = false
    if height ~= nil and GetNotifierOpenState() then
      if height < wnd:GetHeight() then
        height = 0
        lockScroll = true
      end
      wnd:ResetScroll(height)
      wnd:Lock(lockScroll)
    end
  end
  function wnd:MakeList()
    if wnd.todayArchePassQuestWnd ~= nil then
      wnd.todayArchePassQuestWnd:MakeList()
      wnd:AnchorLast(wnd.todayArchePassQuestWnd)
    end
    if wnd.todayQuestWnd ~= nil then
      wnd.todayQuestWnd:MakeList()
      wnd:AnchorLast(wnd.todayQuestWnd)
    end
    if wnd.todayExpeditionQuestWnd ~= nil then
      if X2Faction:GetMyExpeditionId() ~= 0 then
        wnd.todayExpeditionQuestWnd:MakeList()
        wnd.todayExpeditionQuestWnd:Show(true)
        wnd:AnchorLast(wnd.todayExpeditionQuestWnd)
      else
        wnd.todayExpeditionQuestWnd:Show(false)
      end
    end
    if wnd.todayFamilyQuestWnd ~= nil then
      if X2Family:IsFamily() == true then
        wnd.todayFamilyQuestWnd:MakeList()
        wnd.todayFamilyQuestWnd:Show(true)
        wnd:AnchorLast(wnd.todayFamilyQuestWnd)
      else
        wnd.todayFamilyQuestWnd:Show(false)
      end
    end
    if wnd.heroQuestWnd ~= nil then
      if X2Hero:IsHero() == true then
        wnd.heroQuestWnd:MakeList()
        wnd.heroQuestWnd:Show(true)
        wnd:AnchorLast(wnd.heroQuestWnd)
      else
        wnd.heroQuestWnd:Show(false)
      end
    end
    if wnd.racialAchievementWnd ~= nil then
      wnd.racialAchievementWnd:MakeList()
      wnd:AnchorLast(wnd.racialAchievementWnd)
    end
    if wnd.normalAchievementWnd ~= nil then
      wnd.normalAchievementWnd:MakeList()
      wnd:AnchorLast(wnd.normalAchievementWnd)
    end
    if wnd.collectionAchievementWnd ~= nil then
      wnd.collectionAchievementWnd:MakeList()
      wnd:AnchorLast(wnd.collectionAchievementWnd)
    end
    wnd:ResetScrollInfo()
  end
  local assignmentEvents = {
    ACHIEVEMENT_UPDATE = function()
      wnd:MakeList()
    end,
    UPDATE_TODAY_ASSIGNMENT = function()
      wnd:MakeList()
    end,
    START_TODAY_ASSIGNMENT = function(stepName)
      wnd:MakeList()
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    assignmentEvents[event](...)
  end)
  RegistUIEvent(wnd, assignmentEvents)
  if wnd.todayQuestWnd ~= nil then
    function todayQuestToggled(isOpen)
      SetTodayQuestOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.todayQuestWnd:SetToggleCallback(todayQuestToggled)
  end
  if wnd.todayArchePassQuestWnd ~= nil then
    function todayArchePassQuestToggled(isOpen)
      SetTodayArchePassQuestOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.todayArchePassQuestWnd:SetToggleCallback(todayArchePassQuestToggled)
  end
  if wnd.todayExpeditionQuestWnd ~= nil then
    function todayExpeditionQuestToggled(isOpen)
      SetTodayExpeditionQuestOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.todayExpeditionQuestWnd:SetToggleCallback(todayExpeditionQuestToggled)
  end
  if wnd.todayFamilyQuestWnd ~= nil then
    function todayFamilyQuestToggled(isOpen)
      SetTodayFamilyQuestOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.todayFamilyQuestWnd:SetToggleCallback(todayFamilyQuestToggled)
  end
  if wnd.heroQuestWnd ~= nil then
    function heroQuestToggled(isOpen)
      SetHeroQuestOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.heroQuestWnd:SetToggleCallback(heroQuestToggled)
  end
  if wnd.racialAchievementWnd ~= nil then
    function racialAchievementToggled(isOpen)
      SetRacialAchievementOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.racialAchievementWnd:SetToggleCallback(racialAchievementToggled)
  end
  if wnd.normalAchievementWnd ~= nil then
    function normalAchievementToggled(isOpen)
      SetGeneralAchievementOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.normalAchievementWnd:SetToggleCallback(normalAchievementToggled)
  end
  if wnd.collectionAchievementWnd ~= nil then
    function collectionAchievementToggled(isOpen)
      SetcollectionAchievementOpenState(isOpen)
      wnd.ResetScrollInfo()
    end
    wnd.collectionAchievementWnd:SetToggleCallback(collectionAchievementToggled)
  end
  return wnd
end
