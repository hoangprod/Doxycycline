local HIGH_RANK_ACHIEVEMENT = 1
local LOW_RANK_ACHIEVEMENT = 2
local TODAY_ASSIGNMENT_TAB = 4
local EXPEDITION_QUEST_TAB = 5
local FAMILY_QUEST_TAB = 6
local HERO_QUEST_TAB = 7
local DELAY = 3000
local FADE_DELAY = 500
local CreateHighRankWindow = function(id, parent)
  local wnd = CreateCenterMessageFrame(id, parent, "TYPE1")
  wnd:SetExtent(946, 190)
  wnd.bg:SetExtent(782, 128)
  wnd.iconBg:RemoveAllAnchors()
  wnd.iconBg:AddAnchor("TOP", wnd, 0, 10)
  local deco = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_ALARM, "icon_bg", "background")
  deco:AddAnchor("BOTTOM", wnd.iconBg, 0, 1)
  wnd.icon:SetCoords(0, 0, 48, 48)
  wnd.icon:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
  wnd.icon:RemoveAllAnchors()
  wnd.icon:AddAnchor("CENTER", wnd.iconBg, -2, 0)
  local rankDeco = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_RANK, "default", "overlay")
  rankDeco:AddAnchor("TOPLEFT", wnd.icon, 0, 0)
  rankDeco:AddAnchor("BOTTOMRIGHT", wnd.icon, 0, 0)
  wnd:ReleaseHandler("OnUpdate")
  local overDeco = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_ALARM, "icon_cover", "overlay")
  overDeco:AddAnchor("BOTTOM", wnd.iconBg, 0, -4)
  local textImg = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_TEXT_1, "achievement_text01", "overlay")
  textImg:AddAnchor("TOP", wnd.iconBg, "BOTTOM", 0, -11)
  local name = wnd:CreateChildWidget("label", "name", 0, true)
  name:SetHeight(FONT_SIZE.XLARGE)
  name.style:SetShadow(true)
  name.style:SetFontSize(FONT_SIZE.XLARGE)
  name:AddAnchor("TOP", textImg, "BOTTOM", 0, 3)
  ApplyTextColor(name, FONT_COLOR.SKYBLUE)
  name:SetAutoResize(true)
  name:Show(false)
  local gradeIcon = W_ICON.CreateAchievementGradeIcon(wnd)
  gradeIcon:AddAnchor("RIGHT", name, "LEFT", -2, 0)
  wnd.body:AddAnchor("TOP", name, "BOTTOM", 0, 5)
  function wnd:SetAchievement(mInfo)
    self.icon:SetTexture(mInfo.iconPath)
    self.icon:SetVisible(true)
    if mInfo.kind == EAK_RACIAL_MISSION then
      textImg:SetTexture(TEXTURE_PATH.ACHIEVEMENT_TEXT_3)
      textImg:SetTextureInfo("achievement_text03")
    else
      textImg:SetTexture(TEXTURE_PATH.ACHIEVEMENT_TEXT_1)
      textImg:SetTextureInfo("achievement_text01")
    end
    self.name:SetText(mInfo.name)
    self.name:Show(true)
    self.body:SetTextAutoWidth(1000, mInfo.summary, 10)
    self.body:SetHeight(self.body:GetTextHeight())
    self:SetAchievementGrade(mInfo.grade)
    self.body:Show(true)
    if gradeIcon:IsVisible() then
      self.name:RemoveAllAnchors()
      self.name:AddAnchor("TOP", textImg, "BOTTOM", gradeIcon:GetWidth() / 2, 3)
      self.body:RemoveAllAnchors()
      self.body:AddAnchor("TOP", name, "BOTTOM", -gradeIcon:GetWidth() / 2, 5)
    else
      self.name:RemoveAllAnchors()
      self.name:AddAnchor("TOP", textImg, "BOTTOM", 0, 3)
      self.body:RemoveAllAnchors()
      self.body:AddAnchor("TOP", name, "BOTTOM", 0, 5)
    end
    self.bg:SetVisible(true)
  end
  return wnd
end
local function CreateLowRankWindow(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:Show(false)
  wnd:SetWidth(400)
  wnd.bg = CreateContentBackground(wnd, "TYPE5", "black")
  wnd.bg:AddAnchor("TOPLEFT", wnd, -30, 40)
  wnd.bg:AddAnchor("BOTTOMRIGHT", wnd, 30, 0)
  wnd.bg:SetVisible(false)
  local titleImg = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_TEXT_2, "achievement_text02", "background")
  titleImg:AddAnchor("TOP", wnd, 0, 0)
  titleImg:SetVisible(false)
  local leftDeco = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_ALARM, "left_deco", "background")
  leftDeco:AddAnchor("RIGHT", titleImg, "LEFT", 0, 0)
  local rightDeco = wnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_ALARM, "right_deco", "background")
  rightDeco:AddAnchor("LEFT", titleImg, "RIGHT", 0, 0)
  local tabName = wnd:CreateChildWidget("label", "tabName", 0, true)
  tabName:SetHeight(FONT_SIZE.XLARGE)
  tabName.style:SetShadow(true)
  tabName.style:SetFontSize(FONT_SIZE.XLARGE)
  tabName:AddAnchor("TOP", wnd, 0, 57)
  ApplyTextColor(tabName, FONT_COLOR.LABORPOWER_YELLOW)
  tabName:SetAutoResize(true)
  wnd.achievements = {}
  local offsetY = 85
  for i = 1, 3 do
    local achievementWnd = wnd:CreateChildWidget("emptywidget", "achievements", i, true)
    achievementWnd:SetExtent(400, 50)
    achievementWnd:AddAnchor("TOPLEFT", wnd, 0, offsetY + (i - 1) * 60)
    achievementWnd:Show(false)
    local icon = achievementWnd:CreateImageDrawable(TEXTURE_PATH.DEFAULT, "background")
    icon:SetCoords(0, 0, 48, 48)
    icon:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
    icon:AddAnchor("LEFT", achievementWnd, 35, 0)
    icon:SetVisible(false)
    achievementWnd.icon = icon
    local rankDeco = achievementWnd:CreateDrawable(TEXTURE_PATH.ACHIEVEMENT_RANK, "default", "artwork")
    rankDeco:AddAnchor("TOPLEFT", icon, 0, 0)
    rankDeco:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
    local gradeIcon = W_ICON.CreateAchievementGradeIcon(achievementWnd)
    gradeIcon:AddAnchor("TOPLEFT", icon, "TOPRIGHT", 5, 8)
    local name = achievementWnd:CreateChildWidget("label", "name", 0, true)
    name:SetAutoResize(true)
    name:SetHeight(FONT_SIZE.XLARGE)
    name.style:SetFontSize(FONT_SIZE.XLARGE)
    name.style:SetShadow(true)
    name:AddAnchor("LEFT", gradeIcon, "RIGHT", 2, 0)
    ApplyTextColor(name, FONT_COLOR.SKYBLUE)
    name:Show(false)
    local summary = achievementWnd:CreateChildWidget("label", "summary", 0, true)
    summary:SetAutoResize(true)
    summary:SetHeight(FONT_SIZE.LARGE)
    summary.style:SetFontSize(FONT_SIZE.LARGE)
    summary.style:SetShadow(true)
    summary:AddAnchor("TOPLEFT", gradeIcon, "BOTTOMLEFT", 2, 5)
    ApplyTextColor(summary, FONT_COLOR.WHITE)
    summary:Show(false)
    wnd.achievements[i] = achievementWnd
  end
  local additional = wnd:CreateChildWidget("label", "additional", 0, true)
  additional:AddAnchor("TOP", wnd.achievements[3], "BOTTOM", 0, 10)
  additional:SetHeight(FONT_SIZE.LARGE)
  additional.style:SetShadow(true)
  additional.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(additional, FONT_COLOR.WHITE)
  additional:SetAutoResize(true)
  additional:Show(false)
  function wnd:SetAchievement(mInfos, isInit)
    wnd.bg:SetVisible(true)
    titleImg:SetVisible(true)
    local lastWidget
    if isInit then
      if mInfos[1] ~= nil then
        if mInfos[1].kind == EAK_RACIAL_MISSION or mInfos[1].kind == EAK_ACHIEVEMENT or mInfos[1].kind == EAK_COLLECTION then
          titleImg:SetTexture(TEXTURE_PATH.ACHIEVEMENT_TEXT_2)
          titleImg:SetTextureInfo("achievement_text02")
          tabName:SetText(string.format("[%s]", locale.GetAchievementKindString(mInfos[1].kind)))
        elseif mInfos[1].kind == TODAY_ASSIGNMENT_TAB then
          titleImg:SetTexture(TEXTURE_PATH.ACHIEVEMENT_TEXT_2)
          titleImg:SetTextureInfo("achievement_text02")
          tabName:SetText(string.format("[%s]", GetCommonText("today_assignment")))
        elseif mInfos[1].kind == EXPEDITION_QUEST_TAB then
          titleImg:SetTexture(TEXTURE_PATH.MISSION_TEXT)
          titleImg:SetTextureInfo("mission_text")
          tabName:SetText(string.format("[%s]", GetCommonText("expedition_today_quest")))
        elseif mInfos[1].kind == FAMILY_QUEST_TAB then
          titleImg:SetTexture(TEXTURE_PATH.MISSION_TEXT)
          titleImg:SetTextureInfo("mission_text")
          tabName:SetText(string.format("[%s]", GetCommonText("family_happy_life")))
        elseif mInfos[1].kind == HERO_QUEST_TAB then
          titleImg:SetTexture(TEXTURE_PATH.MISSION_TEXT)
          titleImg:SetTextureInfo("mission_text")
          tabName:SetText(string.format("[%s]", GetCommonText("hero_quest")))
        end
      end
      for i = 1, #wnd.achievements do
        if i > #mInfos then
          wnd.achievements[i]:Show(false)
        else
          wnd.achievements[i].icon:SetTexture(mInfos[i].iconPath)
          wnd.achievements[i].icon:SetVisible(true)
          wnd.achievements[i].name:SetText(mInfos[i].name)
          wnd.achievements[i].name:Show(true)
          wnd.achievements[i].summary:SetText(mInfos[i].summary)
          wnd.achievements[i].summary:Show(true)
          wnd.achievements[i]:SetAchievementGrade(mInfos[i].grade)
          wnd.achievements[i]:Show(true)
          lastWidget = wnd.achievements[i]
        end
      end
      if #wnd.achievements < #mInfos then
        additional:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "achievement_complete_additional", tostring(#mInfos - #wnd.achievements)))
        additional:Show(true)
        lastWidget = additional
      else
        additional:Show(false)
      end
    else
      for i = 1, math.min(#mInfos, #wnd.achievements) do
        if not wnd.achievements[i]:IsVisible() and mInfos[i].isNew then
          wnd.achievements[i].icon:SetTexture(mInfos[i].iconPath)
          wnd.achievements[i].icon:SetVisible(true)
          wnd.achievements[i].name:SetText(mInfos[i].name)
          wnd.achievements[i].name:Show(true)
          wnd.achievements[i].summary:SetText(mInfos[i].summary)
          wnd.achievements[i].summary:Show(true)
          wnd.achievements[i]:SetAchievementGrade(mInfos[i].grade)
          wnd.achievements[i]:Show(true, 500)
          lastWidget = wnd.achievements[i]
        end
      end
      if #wnd.achievements < #mInfos then
        additional:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "achievement_complete_additional", tostring(#mInfos - #wnd.achievements)))
        additional:Show(true, 500)
        lastWidget = additional
      end
    end
    if lastWidget == nil then
      return
    end
    local _, wY = wnd:GetOffset()
    local _, sY = lastWidget:GetOffset()
    local sH = lastWidget:GetHeight()
    wnd:SetHeight(sY + sH - wY + 17)
  end
  return wnd
end
local achievementComplete
local messageQueue = {}
local currentIndex = 1
function AddAchievementMsgInfo(mInfo)
  local index = currentIndex
  if mInfo.rank == HIGH_RANK_ACHIEVEMENT then
    index = #messageQueue + 1
  else
    while index <= #messageQueue + 1 do
      local message = messageQueue[index]
      if message == nil then
        break
      end
      if message.rank == LOW_RANK_ACHIEVEMENT and message.kind == mInfo.kind then
        break
      end
      index = index + 1
    end
  end
  if messageQueue[index] == nil then
    messageQueue[index] = {}
    messageQueue[index].rank = mInfo.rank
    messageQueue[index].kind = mInfo.kind
    messageQueue[index].mInfo = {}
    messageQueue[index].mInfo[1] = mInfo
    messageQueue[index].delay = DELAY
  else
    local cnt = #messageQueue[index].mInfo + 1
    messageQueue[index].mInfo[cnt] = mInfo
    messageQueue[index].delay = DELAY
  end
end
local function CreateAchievementCompleteMessage(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:Show(true)
  frame:SetExtent(0, 0)
  frame:AddAnchor("TOP", parent, 0, 60)
  frame:EnablePick(false)
  local lowRankWnd = CreateLowRankWindow("lowRankWnd", frame)
  lowRankWnd:AddAnchor("CENTER", frame, 0, 0)
  lowRankWnd:Show(false)
  local highRankWnd = CreateHighRankWindow("highRankWnd", frame)
  highRankWnd:AddAnchor("CENTER", frame, 0, 0)
  highRankWnd:Show(false)
  local curRankInfo
  local function GetLastMessageQueue()
    if #messageQueue < 1 then
      return
    end
    if table.getn(messageQueue[#messageQueue].mInfo) == 1 then
      return messageQueue[#messageQueue].mInfo[1]
    else
      return messageQueue[#messageQueue].mInfo[#messageQueue[#messageQueue].mInfo]
    end
  end
  local function FadeOutMessage()
    if messageQueue[currentIndex].rank == LOW_RANK_ACHIEVEMENT then
      lowRankWnd:Show(false, FADE_DELAY)
    else
      highRankWnd:Show(false, FADE_DELAY)
    end
  end
  local function FadeInMessage()
    if messageQueue[currentIndex].rank == LOW_RANK_ACHIEVEMENT then
      lowRankWnd:SetAchievement(messageQueue[currentIndex].mInfo, true)
      lowRankWnd:Show(true, FADE_DELAY)
      F_SOUND.PlayUISound("low_rank_achievement", true)
      curRankInfo = messageQueue[currentIndex].mInfo[#messageQueue[currentIndex].mInfo]
      frame:SetExtent(lowRankWnd:GetWidth(), lowRankWnd:GetHeight())
    else
      highRankWnd:SetAchievement(messageQueue[currentIndex].mInfo[1])
      highRankWnd:Show(true, FADE_DELAY)
      F_SOUND.PlayUISound("high_rank_achievement", true)
      frame:SetExtent(highRankWnd:GetWidth(), highRankWnd:GetHeight())
      curRankInfo = messageQueue[currentIndex].mInfo[1]
    end
    if not frame:HasHandler("OnUpdate") then
      frame:SetHandler("OnUpdate", frame.OnUpdate)
    end
  end
  function frame:SetAchievement()
    frame:Show(true)
    if frame:HasHandler("OnUpdate") then
      return
    end
    FadeInMessage()
  end
  local function OnEndFadeOut(self)
    if curRankInfo ~= GetLastMessageQueue() then
      currentIndex = currentIndex + 1
    else
      frame:ReleaseHandler("OnUpdate")
      frame:Show(false)
      messageQueue = {}
      currentIndex = 1
    end
    if GetLastMessageQueue() == nil then
      StartNextImgEvent()
      return
    end
    FadeInMessage()
  end
  highRankWnd:SetHandler("OnEndFadeOut", OnEndFadeOut)
  lowRankWnd:SetHandler("OnEndFadeOut", OnEndFadeOut)
  function frame:OnUpdate(dt)
    if messageQueue[currentIndex].rank == LOW_RANK_ACHIEVEMENT then
      for i = 1, #messageQueue[currentIndex].mInfo do
        if messageQueue[currentIndex].mInfo[i].isNew then
          lowRankWnd:SetAchievement(messageQueue[currentIndex].mInfo, false)
          curRankInfo = messageQueue[currentIndex].mInfo[#messageQueue[currentIndex].mInfo]
          messageQueue[currentIndex].mInfo[i].isNew = false
          frame:SetHeight(lowRankWnd:GetHeight())
        end
      end
    end
    if messageQueue[currentIndex].delay > 0 then
      messageQueue[currentIndex].delay = messageQueue[currentIndex].delay - dt
      return
    else
      FadeOutMessage()
    end
  end
  return frame
end
function MakeMessageInfo(aInfo)
  local messageInfo = {}
  messageInfo.name = aInfo.name
  messageInfo.summary = aInfo.summary
  messageInfo.iconPath = aInfo.iconPath
  messageInfo.rank = aInfo.highRank and HIGH_RANK_ACHIEVEMENT or LOW_RANK_ACHIEVEMENT
  messageInfo.kind = aInfo.achievementKind
  messageInfo.grade = aInfo.grade + 1
  messageInfo.isNew = true
  return messageInfo
end
function MakeTodayAssignmetnMessageInfo(tInfo)
  local messageInfo = {}
  messageInfo.name = tInfo.title
  messageInfo.summary = tInfo.desc
  messageInfo.iconPath = tInfo.iconPath
  messageInfo.rank = LOW_RANK_ACHIEVEMENT
  if tInfo.sort == TADT_EXPEDITION then
    messageInfo.kind = EXPEDITION_QUEST_TAB
  elseif tInfo.sort == TADT_FAMILY then
    messageInfo.kind = FAMILY_QUEST_TAB
  elseif tInfo.sort == TADT_HERO then
    messageInfo.kind = HERO_QUEST_TAB
  else
    messageInfo.kind = TODAY_ASSIGNMENT_TAB
  end
  messageInfo.grade = 1
  messageInfo.isNew = true
  return messageInfo
end
local achievementComplete = CreateAchievementCompleteMessage("achievementComplete", "UIParent")
function AddAchievementCompleteMsg(messageInfo)
  if #messageQueue <= 0 then
    return false
  end
  achievementComplete:SetAchievement()
  achievementComplete:Raise()
  return true
end
