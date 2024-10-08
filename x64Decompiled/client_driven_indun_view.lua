local elapseTime = 0
local aniStep = {
  false,
  false,
  false
}
local UpdateImgCoordAndExtent = function(objectiveImg, sceneId, nowCnt, maxCnt)
  local msgImgCoords = {
    [1100] = UIParent:GetTextureData(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "Fire").coords,
    [1700] = UIParent:GetTextureData(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "Attack").coords,
    [1900] = UIParent:GetTextureData(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "Dispose").coords
  }
  local msgCoord = msgImgCoords[sceneId]
  if msgCoord == nil then
    UIParent:Warning(string.format("[ERROR] Can't find msg coord info~!.. [%s]", tostring(sceneId)))
    return
  end
  local countImgCoords = {
    ["0"] = {
      GetTextureInfo(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_00"):GetCoords()
    },
    ["1"] = {
      GetTextureInfo(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_01"):GetCoords()
    },
    ["2"] = {
      GetTextureInfo(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_02"):GetCoords()
    },
    ["3"] = {
      GetTextureInfo(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_03"):GetCoords()
    },
    ["/"] = {
      GetTextureInfo(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_slash"):GetCoords()
    }
  }
  UIParent:LogAlways(string.format("nowCnt: %s, maxCnt: %s", tostring(nowCnt), tostring(maxCnt)))
  local nowCntCoord = countImgCoords[tostring(nowCnt)]
  if nowCntCoord == nil then
    UIParent:Warning(string.format("[ERROR] Can't find now count coord info~!"))
    return
  end
  local maxCntCoord = countImgCoords[tostring(maxCnt)]
  if maxCntCoord == nil then
    UIParent:Warning(string.format("[ERROR] Can't find max count coord info~!"))
    return
  end
  objectiveImg.msg:RemoveAllAnchors()
  objectiveImg.nowCnt:RemoveAllAnchors()
  objectiveImg.slash:RemoveAllAnchors()
  objectiveImg.maxCnt:RemoveAllAnchors()
  objectiveImg:RemoveAllAnchors()
  local totalWidth = 0
  objectiveImg.msg:SetCoords(msgCoord[1], msgCoord[2], msgCoord[3], msgCoord[4])
  objectiveImg.msg:SetExtent(msgCoord[3], msgCoord[4])
  totalWidth = objectiveImg.msg:GetWidth()
  objectiveImg.nowCnt:SetCoords(nowCntCoord[1], nowCntCoord[2], nowCntCoord[3], nowCntCoord[4])
  objectiveImg.nowCnt:SetExtent(nowCntCoord[3], nowCntCoord[4])
  totalWidth = totalWidth + objectiveImg.nowCnt:GetWidth()
  objectiveImg.maxCnt:SetCoords(maxCntCoord[1], maxCntCoord[2], maxCntCoord[3], maxCntCoord[4])
  objectiveImg.maxCnt:SetExtent(maxCntCoord[3], maxCntCoord[4])
  totalWidth = totalWidth + objectiveImg.maxCnt:GetWidth()
  objectiveImg.msg:AddAnchor("TOPLEFT", objectiveImg, "TOPLEFT", 0, 0)
  objectiveImg.nowCnt:AddAnchor("LEFT", objectiveImg.msg, "RIGHT", 5, 0)
  totalWidth = totalWidth + 5
  objectiveImg.slash:AddAnchor("LEFT", objectiveImg.nowCnt, "RIGHT", 0, 0)
  objectiveImg.maxCnt:AddAnchor("LEFT", objectiveImg.slash, "RIGHT", 0, 0)
  objectiveImg:SetWidth(totalWidth)
  objectiveImg:AddAnchor("TOP", objectiveImg:GetParent(), "BOTTOM", 0, 50)
  objectiveImg:Show(true)
end
local CreateObjectiveMsg = function(parent)
  local objectiveImg = parent:CreateChildWidget("emptywidget", "objectiveImg", 0, true)
  objectiveImg:SetExtent(400, 50)
  objectiveImg:AddAnchor("TOP", parent, "BOTTOM", 0, 100)
  objectiveImg:Show(false)
  local msg = objectiveImg:CreateDrawable(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "msg", "overlay")
  msg:AddAnchor("TOPLEFT", objectiveImg, "TOPLEFT", 0, 0)
  msg:SetColor(1, 1, 1, 1)
  objectiveImg.msg = msg
  local nowCnt = objectiveImg:CreateDrawable(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_00", "overlay")
  nowCnt:AddAnchor("LEFT", objectiveImg, "RIGHT", 10, 0)
  nowCnt:SetColor(1, 1, 1, 1)
  objectiveImg.nowCnt = nowCnt
  local slash = objectiveImg:CreateDrawable(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_slash", "overlay")
  slash:AddAnchor("LEFT", nowCnt, "RIGHT", 10, 0)
  slash:SetColor(1, 1, 1, 1)
  objectiveImg.slash = slash
  local maxCnt = objectiveImg:CreateDrawable(TEXTURE_PATH.CLIENT_DRIVEN_CNT_MSG, "count_00", "overlay")
  maxCnt:AddAnchor("LEFT", slash, "RIGHT", 10, 0)
  maxCnt:SetColor(1, 1, 1, 1)
  objectiveImg.maxCnt = maxCnt
  return objectiveImg
end
local function SetViewOfTitleWidget()
  local titleWidget = UIParent:CreateWidget("emptywidget", "clientDrivenTitle", "UIParent")
  titleWidget:Show(false)
  titleWidget:AddAnchor("TOP", "UIParent", 0, 50)
  titleWidget:SetExtent(782, 150)
  titleWidget:Clickable(true)
  local bg = titleWidget:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "bg", "background")
  bg:AddAnchor("TOPLEFT", titleWidget, 0, 35)
  bg:SetColor(1, 1, 1, 1)
  titleWidget.bg = bg
  local bgDeco = titleWidget:CreateDrawable(TEXTURE_PATH.CLIENT_DRIVEN_GUIDE, "deco", "background")
  bgDeco:AddAnchor("TOP", titleWidget, "TOP", 0, 0)
  bgDeco:SetColor(1, 1, 1, 1)
  titleWidget.bgDeco = bgDeco
  local msg = titleWidget:CreateChildWidget("textbox", "title", 0, true)
  msg:SetExtent(CLIENT_DRIVEN_WIDGET.TITLE_TEXT_BOX.EXTENT[1], CLIENT_DRIVEN_WIDGET.TITLE_TEXT_BOX.EXTENT[2])
  msg:AddAnchor("TOP", bg, "TOP", 0, 20)
  msg:SetAutoResize(true)
  msg:SetAutoWordwrap(true)
  msg.style:SetSnap(true)
  msg.style:SetAlign(ALIGN_CENTER)
  msg.style:SetFontSize(FONT_SIZE.XXLARGE)
  msg.style:SetShadow(true)
  ApplyTextColor(msg, FONT_COLOR.SOFT_BROWN)
  titleWidget.msg = msg
  local objectiveMsg = msg:CreateChildWidget("textbox", "objectiveMsg", 0, true)
  objectiveMsg:SetExtent(CLIENT_DRIVEN_WIDGET.TITLE_TEXT_BOX.EXTENT[1], CLIENT_DRIVEN_WIDGET.TITLE_TEXT_BOX.EXTENT[2])
  objectiveMsg:AddAnchor("TOP", msg, "BOTTOM", 0, 10)
  objectiveMsg:SetAutoResize(true)
  objectiveMsg:SetAutoWordwrap(true)
  objectiveMsg.style:SetSnap(true)
  objectiveMsg.style:SetAlign(ALIGN_CENTER)
  objectiveMsg.style:SetFontSize(FONT_SIZE.XLARGE)
  objectiveMsg.style:SetShadow(true)
  ApplyTextColor(objectiveMsg, FONT_COLOR.YELLOW_OCHER)
  titleWidget.objectiveMsg = objectiveMsg
  local objectiveImg = CreateObjectiveMsg(titleWidget)
  function titleWidget:OnUpdate(dt)
    if elapseTime == 0 then
      objectiveImg:SetAlphaAnimation(0, 1, 0.2, 0)
      objectiveImg:SetScaleAnimation(3, 1, 0.2, 0, "CENTER")
      objectiveImg:SetStartAnimation(true, true)
      aniStep[1] = true
    end
    elapseTime = elapseTime + dt
    if elapseTime >= 200 and aniStep[2] == false then
      objectiveImg:SetScaleAnimation(1, 1.5, 0.1, 0, "CENTER")
      objectiveImg:SetStartAnimation(false, true)
      aniStep[2] = true
    end
    if elapseTime >= 300 and aniStep[3] == false then
      objectiveImg:SetScaleAnimation(1.5, 1, 0.2, 0, "CENTER")
      objectiveImg:SetStartAnimation(false, true)
      aniStep[3] = true
    end
    if elapseTime >= 2200 then
      local posX, posY = objectiveImg:GetOffset()
      local offsetY = dt / 400 * 10
      objectiveImg:MoveTo(posX, posY - offsetY)
      local totalDistance = (elapseTime - 2200) / 400 * 10
      if totalDistance >= 10 then
        objectiveImg:Show(false)
        titleWidget:ReleaseHandler("OnUpdate")
      end
    end
  end
  function objectiveImg:UpdateImg(sceneId, nowCnt, maxCnt)
    elapseTime = 0
    for i = 1, #aniStep do
      aniStep[i] = false
    end
    UpdateImgCoordAndExtent(self, sceneId, nowCnt, maxCnt)
    titleWidget:SetHandler("OnUpdate", titleWidget.OnUpdate)
  end
  titleWidget.objectiveImg = objectiveImg
  return titleWidget
end
local SetViewOfContentsWidget = function()
  local contentsWidget = UIParent:CreateWidget("emptywidget", "clientDrivenContents", "UIParent")
  contentsWidget:Show(false)
  contentsWidget:AddAnchor("RIGHT", "UIParent", -50, 100)
  contentsWidget:SetExtent(400, 100)
  contentsWidget:Clickable(true)
  local bg = contentsWidget:CreateDrawable(TEXTURE_PATH.TUTORIAL, "bg", "background")
  bg:AddAnchor("TOPLEFT", contentsWidget, -10, 0)
  bg:AddAnchor("BOTTOMRIGHT", contentsWidget, 50, 0)
  bg:SetColor(0, 0, 0, 0.8)
  contentsWidget.bg = bg
  contentsWidget.imgFrame = {}
  local imgFrame1 = contentsWidget:CreateChildWidget("emptywidget", "imgFrame1", 0, true)
  imgFrame1:Show(false)
  contentsWidget.imgFrame[1] = imgFrame1
  local imgFrame2 = contentsWidget:CreateChildWidget("emptywidget", "imgFrame2", 0, true)
  imgFrame2:Show(false)
  contentsWidget.imgFrame[2] = imgFrame2
  local msg = contentsWidget:CreateChildWidget("textbox", "title", 0, true)
  msg:SetExtent(CLIENT_DRIVEN_WIDGET.CONTENTS_TEXT_BOX.EXTENT[1], CLIENT_DRIVEN_WIDGET.CONTENTS_TEXT_BOX.EXTENT[2])
  msg:AddAnchor("LEFT", contentsWidget, "LEFT", 0, 0)
  msg:SetAutoResize(true)
  msg:SetAutoWordwrap(true)
  msg.style:SetSnap(true)
  msg.style:SetAlign(ALIGN_TOP_LEFT)
  msg.style:SetFontSize(FONT_SIZE.LARGE)
  msg.style:SetShadow(true)
  ApplyTextColor(msg, FONT_COLOR.WHITE)
  contentsWidget.msg = msg
  return contentsWidget
end
local SetViewOfClientDrivenExitBtn = function()
  local exitBtn = UIParent:CreateWidget("button", "clientDrivenExit", "UIParent")
  ApplyButtonSkin(exitBtn, BUTTON_HUD.CLIENT_DRIVEN_OUT)
  local LeftClickFunc = function()
    X2:RequestEndClientDrivenIndun()
  end
  ButtonOnClickHandler(exitBtn, LeftClickFunc)
  local OnEnter = function(self)
    SetTargetAnchorTooltip(GetCommonText("tooltip_menu_option_exit_client_driven"), "TOPRIGHT", self, "TOPLEFT", 0, 0)
  end
  exitBtn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  exitBtn:SetHandler("OnLeave", OnLeave)
  exitBtn:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", -10, 10)
  exitBtn:Show(false)
  local function OnShow()
    if X2:IsInClientDrivenZone() == false then
      exitBtn:Show(false)
    end
  end
  exitBtn:SetHandler("OnShow", OnShow)
  return exitBtn
end
function SetViewOfClientDrivenWidget()
  local title = SetViewOfTitleWidget()
  local contents = SetViewOfContentsWidget()
  local exitbtn = SetViewOfClientDrivenExitBtn()
  return title, contents, exitbtn
end
