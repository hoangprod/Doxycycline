local roundFrame = GetIndicators().instanceRoundFrame
local timeString = roundFrame.timeString
local timeIcon = roundFrame.timeIcon
local roundNumber = roundFrame.roundNumber
local roundString = roundFrame.roundString
local fixedRoundWidth = 178
local elaspedTime = 0
local function InactiveTime()
  timeString:Show(false)
  timeIcon:SetVisible(false)
  elaspedTime = 0
  roundFrame:ReleaseHandler("OnUpdate", roundFrame.OnUpdate)
end
local function SetLeftTime()
  local leftTime = X2Indun:GetRoundLeftTime()
  if leftTime == nil then
    InactiveTime()
    return
  end
  if not timeString:IsVisible() then
    timeString:Show(true)
    timeIcon:SetVisible(true)
  end
  local calcTime = leftTime / 1000
  local minute, second = GetMinuteSecondeFromSec(calcTime)
  timeString:SetText(string.format("%02d : %02d", minute, second))
  local color = calcTime <= 10 and FONT_COLOR.RED or FONT_COLOR.MEDIUM_YELLOW
  ApplyTextColor(timeString, color)
  if calcTime <= 0 then
    roundFrame:ReleaseHandler("OnUpdate", roundFrame.OnUpdate)
  end
end
function roundFrame:OnUpdate(dt)
  elaspedTime = elaspedTime + dt
  if elaspedTime > 1000 then
    elaspedTime = 0
    SetLeftTime()
    return
  end
end
local function UpdateRound()
  local info = X2Indun:GetRoundInfo()
  if info == nil then
    return
  end
  if roundFrame.totalRound == nil then
    UIParent:LogAlways(string.format("[Round UI] Can't find totalRound while update round"))
    return
  end
  local TEXTURE_INFO = info.bossRound and ROUND_INFO_TEXTURE_INFO.BOSS or ROUND_INFO_TEXTURE_INFO.NORMAL
  roundFrame.bg:SetTexture(TEXTURE_INFO.PATH)
  roundFrame.bg:SetTextureInfo(TEXTURE_INFO.KEY)
  roundNumber:SetText(string.format("%d / %d", info.currentRound, roundFrame.totalRound))
  local calcWidth = roundNumber:GetWidth() + roundString:GetWidth() + 6
  if calcWidth > fixedRoundWidth then
    roundFrame:SetWidth(calcWidth + 30)
  else
    roundFrame:SetWidth(fixedRoundWidth)
  end
  local timeLimitRound = X2Indun:GetTimeLimitRound()
  if timeLimitRound ~= true then
    InactiveTime()
    return
  end
  SetLeftTime()
  roundFrame:SetHandler("OnUpdate", roundFrame.OnUpdate)
end
local function SetTotalRound()
  local totalRound = X2Indun:GetTotalRound()
  if totalRound == nil then
    return
  end
  roundFrame.totalRound = totalRound
end
function Init()
  roundFrame:Show(X2Indun:GetRoundIndunActivation())
  SetTotalRound()
  UpdateRound()
end
local events = {
  INDUN_INITAL_ROUND_INFO = function()
    Init()
  end,
  INDUN_UPDATE_ROUND_INFO = function()
    UpdateRound()
  end,
  LEFT_LOADING = function()
    Init()
  end,
  INDUN_ROUND_END = function()
    roundFrame:ReleaseHandler("OnUpdate", roundFrame.OnUpdate)
  end
}
roundFrame:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(roundFrame, events)
function roundFrame:OnToggle()
  RunIndicatorStackRule()
end
roundFrame:SetHandler("OnShow", roundFrame.OnToggle)
roundFrame:SetHandler("OnHide", roundFrame.OnToggle)
Init()
