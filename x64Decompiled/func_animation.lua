F_ANIMATION = {}
local GetRateFromDrawableExtentByPixel = function(isVertical, effectDrawable, pixel)
  if pixel == 0 then
    return 0
  end
  local extent = effectDrawable:GetWidth()
  if isVertical then
    extent = effectDrawable:GetHeight()
  end
  if extent == 0 then
    return 0
  end
  local rate = pixel / extent
  return rate
end
local IncreasePhase = function(phase)
  return phase + 1
end
local GetStartInterval = function(nowPhase, nowAnimInfo, lastAnimInfo)
  if nowPhase == 1 then
    return nowAnimInfo.startTime
  else
    return nowAnimInfo.startTime - (lastAnimInfo.startTime + lastAnimInfo.playTime)
  end
end
local SetWidgetAnims = function(allWidgetAnimInfos)
  if allWidgetAnimInfos == nil then
    UIParent:Warning(string.format("[Lua Error] allWidgetAnimInfos is nil"))
    return
  end
  for i = 1, #allWidgetAnimInfos do
    do
      local widget = allWidgetAnimInfos[i].widget
      local animInfos = allWidgetAnimInfos[i].animData
      for i = 1, #animInfos do
        local animInfo = animInfos[i]
        animInfo.isPlay = false
        animInfo.startTime = animInfo.startTime * 1000
      end
      function widget:SetAnimInfo(animInfo)
        if animInfo.scale then
          widget:SetScaleAnimation(animInfo.scale[1], animInfo.scale[2], animInfo.playTime, 0, "CENTER")
        end
        if animInfo.color then
          widget:SetAlphaAnimation(animInfo.color[1][4], animInfo.color[2][4], animInfo.playTime, 0)
        end
      end
    end
  end
end
function F_ANIMATION.SetWidgetAnimInfos(updateWidget, allWidgetAnimInfos, endMSec, endFunc)
  if updateWidget == nil then
    UIParent:Warning(string.format("[Lua Error] updateWidget is nil"))
    return
  end
  if allWidgetAnimInfos == nil then
    UIParent:Warning(string.format("[Lua Error] allWidgetAnimInfos is nil"))
    return
  end
  updateWidget.elapseTime = 0
  SetWidgetAnims(allWidgetAnimInfos)
  function updateWidget:OnUpdate(dt)
    self.elapseTime = self.elapseTime + dt
    for i = 1, #allWidgetAnimInfos do
      local widget = allWidgetAnimInfos[i].widget
      local animInfos = allWidgetAnimInfos[i].animData
      for k = 1, #animInfos do
        local animInfo = animInfos[k]
        if animInfo.isPlay == false and self.elapseTime >= animInfo.startTime then
          animInfo.isPlay = true
          widget:Show(true)
          widget:SetAnimInfo(animInfo)
          local isAlpha = animInfo.color and true or false
          local isScale = animInfo.scale and true or false
          widget:SetStartAnimation(isAlpha, isScale)
        end
      end
    end
    if endMSec and self.elapseTime >= endMSec and endFunc then
      endFunc()
    end
  end
end
function F_ANIMATION.SetEffectDrawableAnimInfos(allDrawableAnimInfos, accelerationTime)
  if accelerationTime == nil then
    accelerationTime = 0
  end
  for i = 1, #allDrawableAnimInfos do
    local effectDrawable = allDrawableAnimInfos[i].effectDrawable
    local animInfos = allDrawableAnimInfos[i].animData
    local moveEffectPhase = 0
    local dontMoveEffectPhase = 0
    local accumInterVal = 0
    local lastMoveAnimInfo, lastDontMoveAnimInfo
    for index = 1, #animInfos do
      local animInfo = animInfos[index]
      local isExistMoveEffect = animInfo.moveX or animInfo.moveY
      local isExistDontMoveEffect = animInfo.scale or animInfo.color
      if isExistMoveEffect ~= nil then
        moveEffectPhase = IncreasePhase(moveEffectPhase)
        local delayInterval = GetStartInterval(moveEffectPhase, animInfo, lastMoveAnimInfo)
        if delayInterval > 0 then
          if moveEffectPhase == 1 then
            effectDrawable:SetMoveInterval(delayInterval)
          else
            effectDrawable:SetMoveEffectInterval(moveEffectPhase - 1, delayInterval)
          end
        elseif delayInterval < 0 then
          UIParent:Warning(string.format("[LOG] SetEffectDrawableAnimInfos()... index[%d][M:%d] invalid start time [%.1f]", index, moveEffectPhase, delayInterval))
        end
        lastMoveAnimInfo = animInfo
        effectDrawable:SetMoveRepeatCount(1)
        if animInfo.moveX then
          local initPosX = GetRateFromDrawableExtentByPixel(false, effectDrawable, animInfo.moveX[1])
          local targetPosX = GetRateFromDrawableExtentByPixel(false, effectDrawable, animInfo.moveX[2])
          effectDrawable:SetMoveEffectType(moveEffectPhase, "top", 0, 0, animInfo.playTime, accelerationTime)
          effectDrawable:SetMoveEffectEdge(moveEffectPhase, 0.5 + initPosX, 0.5 + targetPosX)
        end
        if animInfo.moveY then
          local initPosY = GetRateFromDrawableExtentByPixel(true, effectDrawable, animInfo.moveY[1])
          local targetPosY = GetRateFromDrawableExtentByPixel(true, effectDrawable, animInfo.moveY[2])
          effectDrawable:SetMoveEffectType(moveEffectPhase, "right", 0, 0, animInfo.playTime, accelerationTime)
          effectDrawable:SetMoveEffectEdge(moveEffectPhase, initPosY, targetPosY)
        end
      end
      if isExistDontMoveEffect then
        dontMoveEffectPhase = IncreasePhase(dontMoveEffectPhase)
        local delayInterval = GetStartInterval(dontMoveEffectPhase, animInfo, lastDonMoveAnimInfo)
        if delayInterval > 0 then
          if dontMoveEffectPhase == 1 then
            effectDrawable:SetInterval(delayInterval)
          else
            effectDrawable:SetEffectInterval(dontMoveEffectPhase - 1, delayInterval)
          end
        elseif delayInterval < 0 then
          UIParent:Warning(string.format("[LOG] index[%d][D:%d] invalid start time [%.1f]", index, dontMoveEffectPhase, delayInterval))
        end
        lastDonMoveAnimInfo = animInfo
        effectDrawable:SetRepeatCount(1)
        effectDrawable:SetEffectPriority(dontMoveEffectPhase, "alpha", animInfo.playTime, accelerationTime)
        if animInfo.scale then
          effectDrawable:SetEffectScale(dontMoveEffectPhase, animInfo.scale[1], animInfo.scale[2], animInfo.scale[1], animInfo.scale[2])
        end
        if animInfo.color then
          effectDrawable:SetEffectInitialColor(dontMoveEffectPhase, animInfo.color[1][1], animInfo.color[1][2], animInfo.color[1][3], animInfo.color[1][4])
          effectDrawable:SetEffectFinalColor(dontMoveEffectPhase, animInfo.color[2][1], animInfo.color[2][2], animInfo.color[2][3], animInfo.color[2][4])
        end
      end
    end
  end
end
function F_ANIMATION.StartEffectDrawableAnimation(updateWidget, allDrawableAnimInfos, allWidgetAnimInfos)
  for i = 1, #allDrawableAnimInfos do
    allDrawableAnimInfos[i].effectDrawable:SetStartEffect(true)
  end
  if updateWidget and updateWidget.OnUpdate then
    updateWidget:ReleaseHandler("OnUpdate")
    updateWidget.elapseTime = 0
    updateWidget:SetHandler("OnUpdate", updateWidget.OnUpdate)
  end
end
function DrawArrowMoveAnim(widget, direction)
  local arArrow
  if direction == "v" then
    arArrow = widget:CreateDrawable(TEXTURE_PATH.HUD, "arrow", "overlay")
  else
    arArrow = widget:CreateDrawable(TEXTURE_PATH.QUEST_LIST, "ani_arrow", "overlay")
    arArrow:SetExtent(58, 45)
  end
  arArrow:SetVisible(false)
  local arArrowAnimInfos = {}
  local function AddMoveInfo(index, direction, value)
    if direction == "v" then
      arArrowAnimInfos[index].moveY = value
    else
      arArrowAnimInfos[index].moveX = value
    end
    return index + 1
  end
  arArrowAnimInfos[1] = {}
  arArrowAnimInfos[1].animType = DAT_MOVE
  arArrowAnimInfos[1].time = 200
  local function AddRepeatAniminfo(index, time, direction, value)
    arArrowAnimInfos[index] = {}
    arArrowAnimInfos[index].animType = DAT_MOVE
    arArrowAnimInfos[index].time = time
    local returnIdx = AddMoveInfo(index, direction, value)
    arArrowAnimInfos[returnIdx] = {}
    arArrowAnimInfos[returnIdx].animType = DAT_MOVE
    arArrowAnimInfos[returnIdx].time = time
    returnIdx = AddMoveInfo(returnIdx, direction, -value)
    return returnIdx
  end
  local returnIdx = AddRepeatAniminfo(2, 300, direction, 30)
  returnIdx = AddRepeatAniminfo(returnIdx, 300, direction, 30)
  arArrowAnimInfos[returnIdx] = {}
  arArrowAnimInfos[returnIdx].animType = DAT_MOVE
  arArrowAnimInfos[returnIdx].time = 300
  returnIdx = AddMoveInfo(returnIdx, direction, 30)
  arArrowAnimInfos[returnIdx] = {}
  arArrowAnimInfos[returnIdx].animType = DAT_MOVE + DAT_LINEAR_ALPHA
  arArrowAnimInfos[returnIdx].time = 100
  arArrowAnimInfos[returnIdx].alpha = 0
  arArrow:SetAnimFrameInfo(arArrowAnimInfos)
  return arArrow
end
