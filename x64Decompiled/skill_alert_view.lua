local MAX_SUB_ICON_COUNT = 5
local SUB_ICON_SIZE = 34
local BLINK_START_TIME = 30000
local BLINK_HALF_CYCLE = 800
local ICON_UPDATE_DELAY = 100
skillAlertWnd = {}
local skillAlertMainIconInfoList = {}
local skillAlertSubIconInfoList = {}
local function CreateBuffNotice()
  skillAlertWnd = CreateEmptyWindow("skill_alert", "UIParent")
  skillAlertWnd:AddAnchor("BOTTOM", "UIParent", "BOTTOM", 0, -220)
  skillAlertWnd:SetExtent(270, 47)
  skillAlertWnd:SetUILayer("game")
  skillAlertMainIcon = CreateEmptyWindow("skill_alert_main_icon", skillAlertWnd)
  skillAlertMainIcon:AddAnchor("TOP", skillAlertWnd, "TOP")
  skillAlertMainIcon:SetExtent(skillAlertWnd:GetExtent())
  skillAlertWnd.skillAlertMainIcon = skillAlertMainIcon
  skillAlertWnd:Clickable(false)
  local skillAlertBuffNotice = skillAlertMainIcon:CreateDrawable(TEXTURE_PATH.HUD, "buff_notice", "background")
  skillAlertBuffNotice:AddAnchor("TOPLEFT", skillAlertWnd, "TOPLEFT")
  skillAlertBuffNotice:SetExtent(skillAlertMainIcon:GetExtent())
  skillAlertWnd.mainIconBg = skillAlertBuffNotice
  local skillAlertRemainLabel = skillAlertMainIcon:CreateChildWidget("label", "buff_notice_remain_sec", 0, true)
  skillAlertRemainLabel:AddAnchor("TOPLEFT", skillAlertMainIcon, "TOPLEFT", 0, 12)
  skillAlertRemainLabel:SetExtent(51, 15)
  skillAlertRemainLabel.style:SetFontSize(FONT_SIZE.SMALL)
  skillAlertRemainLabel.style:SetAlign(ALIGN_CENTER)
  skillAlertRemainLabel.style:SetShadow(true)
  ApplyTextColor(skillAlertRemainLabel, FONT_COLOR.WHITE)
  skillAlertRemainLabel:SetText("")
  skillAlertWnd.skillAlertRemainLabel = skillAlertRemainLabel
  local skillAlertNameLabel = skillAlertMainIcon:CreateChildWidget("label", "buff_notice_name", 0, true)
  skillAlertNameLabel:AddAnchor("TOPLEFT", skillAlertMainIcon, "TOPLEFT", 100, 12)
  skillAlertNameLabel:SetExtent(100, 15)
  skillAlertNameLabel.style:SetFontSize(FONT_SIZE.SMALL)
  skillAlertNameLabel.style:SetAlign(ALIGN_LEFT)
  skillAlertNameLabel.style:SetShadow(true)
  ApplyTextColor(skillAlertNameLabel, FONT_COLOR.WHITE)
  skillAlertNameLabel:SetText("")
  skillAlertWnd.skillAlertNameLabel = skillAlertNameLabel
  local isMainIcon = true
  local icon = CreateSkillAlertBuffIcon("main_icon", skillAlertMainIcon, isMainIcon, 1)
  icon:AddAnchor("TOPLEFT", skillAlertMainIcon, 51, 0)
  icon:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  icon:Show(false)
  skillAlertWnd.mainIcon = icon
  isMainIcon = false
  skillAlertWnd.subIcon = {}
  for i = 1, MAX_SUB_ICON_COUNT do
    local icon = CreateSkillAlertBuffIcon("sub_icon" .. i, skillAlertWnd, isMainIcon, i)
    icon:AddAnchor("TOPLEFT", skillAlertWnd, "BOTTOMLEFT", 45 + (i - 1) * ICON_SIZE.DEFAULT, 0)
    icon:SetExtent(SUB_ICON_SIZE, SUB_ICON_SIZE)
    icon:Show(false)
    skillAlertWnd.subIcon[i] = icon
  end
  skillAlertWnd.Event = {
    SKILL_ALERT_ADD = function(statusBuffType, buffId, remainTime, name)
      SkillAlertAdd(statusBuffType, buffId, remainTime, name)
    end,
    SKILL_ALERT_REMOVE = function(statusBuffType)
      SkillAlertRemove(statusBuffType)
    end,
    ENTERED_WORLD = function()
      ChangeSkillAlertPos(X2Option:GetOptionItemValue(OPTION_SKILL_ALERT_POSITION))
    end
  }
  skillAlertWnd:SetHandler("OnEvent", function(this, event, ...)
    skillAlertWnd.Event[event](...)
  end)
  RegistUIEvent(skillAlertWnd, skillAlertWnd.Event)
  skillAlertMainIcon:Show(false)
  skillAlertWnd:Show(true)
end
local FormatRemainTime = function(timeValue, timeUnit)
  local timeStr = ""
  local key = ""
  if not (timeValue >= 0) or not timeValue then
    timeValue = 0
  end
  local multiply = 1000
  if timeUnit ~= nil and timeUnit == "sec" then
    multiply = 1
  end
  if timeValue >= multiply * 86400 then
    timeStr = tostring(math.floor(timeValue / (multiply * 86400)))
    key = "day_initial"
  elseif timeValue >= multiply * 3600 then
    timeStr = tostring(math.floor(timeValue / (multiply * 3600)))
    key = "hour_initial"
  elseif timeValue >= multiply * 60 then
    timeStr = tostring(math.floor(timeValue / (multiply * 60)))
    key = "minute_initial"
  elseif timeValue >= 0 then
    timeStr = tostring(math.floor(timeValue / multiply))
    key = "second_initial"
  end
  return X2Locale:LocalizeUiText(TIME, key, timeStr)
end
function CreateSkillAlertBuffIcon(id, parent, isMainIcon, infoIndex)
  local button = CreateActionSlot(parent, "skill_alert_" .. tostring(id), ISLOT_CONSTANT, 0)
  button.isMainIcon = isMainIcon
  button.infoIndex = infoIndex
  button:Clickable(false)
  button:DisableDefaultClick()
  button.leftTimeText = W_CTRL.CreateLabel(id .. ".leftTimeText", button)
  button.leftTimeText:Clickable(false)
  button.leftTimeText:SetAutoResize(true)
  button.leftTimeText:SetHeight(FONT_SIZE.SMALL)
  button.leftTimeText:AddAnchor("CENTER", button, -2, 0)
  button.leftTimeText.style:SetAlign(ALIGN_CENTER)
  button.leftTimeText.style:SetColor(1, 1, 1, 1)
  button.leftTimeText.style:SetOutline(true)
  local buff_deco = button:CreateDrawable(TEXTURE_PATH.HUD, "debuff_deco", "overlay")
  buff_deco:SetTextureColor("default")
  buff_deco:AddAnchor("TOP", button, 0, 0)
  button:ReleaseHandler("OnClick")
  button:ReleaseHandler("OnEnter")
  button:ReleaseHandler("OnLeave")
  button.timeCheck = 0
  function button:OnUpdate(dt)
    button.timeCheck = button.timeCheck + dt
    if button.timeCheck < ICON_UPDATE_DELAY then
      return
    end
    button.timeCheck = 0
    if button.isMainIcon == true then
      local info = skillAlertMainIconInfoList[button.infoIndex]
      if info == nil then
        skillAlertWnd.skillAlertMainIcon:Show(false)
        skillAlertWnd.skillAlertNameLabel:SetText("")
        skillAlertWnd.skillAlertRemainLabel:SetText("")
      else
        local remainTime = X2SkillAlert:GetBuffRemainTime(info.buffId)
        info.showTime = info.showTime - ICON_UPDATE_DELAY
        if 0 <= info.showTime then
          skillAlertWnd.skillAlertRemainLabel:SetText(FormatRemainTime(remainTime, "msec"))
        else
          ClearSkillAlertMainIcon(info.statusBuffType)
          skillAlertWnd.skillAlertMainIcon:Show(false)
          skillAlertWnd.skillAlertNameLabel:SetText("")
          skillAlertWnd.skillAlertRemainLabel:SetText("")
          button:ReleaseHandler("OnUpdate")
        end
      end
    else
      local info = skillAlertSubIconInfoList[button.infoIndex]
      if info == nil then
        skillAlertWnd.subIcon[button.infoIndex]:Show(false)
      else
        local remainTime = X2SkillAlert:GetBuffRemainTime(info.buffId)
        info.showTime = info.showTime - ICON_UPDATE_DELAY
        if 0 <= info.showTime then
          button.leftTimeText:SetText(FormatRemainTime(remainTime, "msec"))
        else
          ClearSkillAlertSubIcon(info.statusBuffType)
          skillAlertWnd.subIcon[button.infoIndex]:Show(false)
          button:ReleaseHandler("OnUpdate")
        end
      end
    end
  end
  button:SetHandler("OnUpdate", button.OnUpdate)
  return button
end
function UpdateSkillAlertMainIcon(statusBuffType, buffId, remainTime, name, infoIndex)
  skillAlertMainIconInfoList[infoIndex] = {}
  skillAlertMainIconInfoList[infoIndex].statusBuffType = statusBuffType
  skillAlertMainIconInfoList[infoIndex].duration = remainTime
  skillAlertMainIconInfoList[infoIndex].buffId = buffId
  skillAlertMainIconInfoList[infoIndex].showTime = 3000
  skillAlertWnd.skillAlertMainIcon:Show(true)
  skillAlertWnd.mainIcon:Show(true)
  skillAlertWnd.mainIcon:SetHandler("OnUpdate", skillAlertWnd.mainIcon.OnUpdate)
  skillAlertWnd.mainIcon:EstablishSkillAlert(statusBuffType, 0, 0)
  skillAlertWnd.skillAlertNameLabel:SetText(name)
end
function ClearSkillAlertMainIcon(statusBuffType)
  for k, v in pairs(skillAlertMainIconInfoList) do
    if v.statusBuffType == statusBuffType then
      skillAlertMainIconInfoList[k].showTime = -1
    end
  end
end
function UpdateSkillAlertSubIcon(statusBuffType, buffId, remainTime, infoIndex)
  skillAlertSubIconInfoList[infoIndex] = {}
  skillAlertSubIconInfoList[infoIndex].statusBuffType = statusBuffType
  skillAlertSubIconInfoList[infoIndex].duration = remainTime
  skillAlertSubIconInfoList[infoIndex].buffId = buffId
  skillAlertSubIconInfoList[infoIndex].showTime = remainTime
  skillAlertWnd.subIcon[infoIndex]:Show(true)
  skillAlertWnd.subIcon[infoIndex]:SetHandler("OnUpdate", skillAlertWnd.subIcon[infoIndex].OnUpdate)
  skillAlertWnd.subIcon[infoIndex]:EstablishSkillAlert(statusBuffType, remainTime, remainTime)
end
function ClearSkillAlertSubIcon(statusBuffType)
  for k, v in pairs(skillAlertSubIconInfoList) do
    if v.statusBuffType == statusBuffType then
      skillAlertSubIconInfoList[k].showTime = -1
    end
  end
end
local function RearrangeSubIconInfoList(statusBuffType)
  local tempList = {}
  local index = 1
  for k, v in pairs(skillAlertSubIconInfoList) do
    if v.statusBuffType ~= nil and v.showTime >= 0 then
      tempList[index] = v
      skillAlertWnd.subIcon[index]:EstablishSkillAlert(v.statusBuffType, v.showTime, v.duration)
      index = index + 1
    end
  end
  skillAlertSubIconInfoList = tempList
  for k, v in pairs(skillAlertSubIconInfoList) do
    if v.statusBuffType == statusBuffType then
      return k
    end
  end
  return #skillAlertSubIconInfoList + 1
end
function ChangeSkillAlertPos(posIndex)
  if skillAlertWnd == nil then
    return
  end
  if posIndex <= SKILL_ALERT_POS_INVALID or posIndex > SKILL_ALERT_POS_OFF then
    return
  end
  skillAlertWnd:Show(true)
  skillAlertWnd:RemoveAllAnchors()
  if posIndex == SKILL_ALERT_POS_BASIC then
    skillAlertWnd:AddAnchor("BOTTOM", "UIParent", "BOTTOM", 0, -220)
  elseif posIndex == SKILL_ALERT_POS_FIRST then
    skillAlertWnd:AddAnchor("TOPRIGHT", "UIParent", -29, 310)
  elseif posIndex == SKILL_ALERT_POS_SECOND then
    local screenHeight = UIParent:GetScreenHeight()
    skillAlertWnd:AddAnchor("TOPRIGHT", "UIParent", -29, F_LAYOUT.CalcDontApplyUIScale(screenHeight / 2 - 60))
  elseif posIndex == SKILL_ALERT_POS_OFF then
    skillAlertWnd:Show(false)
  end
end
function SkillAlertAdd(statusBuffType, buffId, remainTime, name)
  UpdateSkillAlertMainIcon(statusBuffType, buffId, remainTime, name, 1)
  local nextIndex = RearrangeSubIconInfoList(statusBuffType)
  if nextIndex <= MAX_SUB_ICON_COUNT then
    UpdateSkillAlertSubIcon(statusBuffType, buffId, remainTime, nextIndex)
  end
end
function SkillAlertRemove(statusBuffType)
  ClearSkillAlertMainIcon(statusBuffType)
  ClearSkillAlertSubIcon(statusBuffType)
  RearrangeSubIconInfoList()
end
CreateBuffNotice()
