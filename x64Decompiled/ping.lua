function RemovePing(target, arg)
  worldmap:RemovePing(arg)
end
function RemovePingAll()
  worldmap:RemovePingAll()
end
function SetPingBtn(pingType, press)
  if pingPushed[pingType] == press then
    return
  end
  if pingType == PING_TYPE_LINE and press then
    worldmap:RemovePing(PING_TYPE_LINE)
  end
  pingPushed[pingType] = press
  SetBGPushed(mapFrame.PingBtn[pingType], press)
  SetBGPushed(roadmapPingButton.wnd.btn[pingType], press)
  worldmap:SetPingBtn(press, pingType)
  roadmap:SetPingBtn(press, pingType)
end
function ResetPingBtn()
  if worldmap:IsVisible() or roadmapPingButton.wnd:IsVisible() then
    return
  end
  for i = PING_TYPE_PING, PING_TYPE_ERASER do
    SetPingBtn(i, false)
  end
end
function EnablePingBtn()
  ResetPingBtn()
  local isPartyTeam = X2Team:IsPartyTeam()
  local isRaidTeam = X2Team:IsRaidTeam()
  enable = true
  if isPartyTeam or isRaidTeam then
    if not X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) then
      enable = false
    elseif X2Team:IsJointTeam() and not X2Team:IsJointLeader() then
      enable = false
    end
  end
  for i = PING_TYPE_PING, PING_TYPE_ERASER do
    mapFrame.PingBtn[i]:Enable(enable)
    roadmapPingButton.wnd.btn[i]:Enable(enable)
  end
  if X2Team:IsHeadMarker(X2Team:GetTeamPlayerIndex()) then
    mapFrame.PingBtn[PING_TYPE_PING]:Enable(true)
    roadmapPingButton.wnd.btn[PING_TYPE_PING]:Enable(true)
  end
end
function DrawBtnClick(pingType, press)
  for i = PING_TYPE_PING, PING_TYPE_ERASER do
    if i ~= pingType then
      SetPingBtn(i, false)
    end
  end
  if press == nil then
    SetPingBtn(pingType, not pingPushed[pingType])
  else
    SetPingBtn(pingType, press)
  end
end
function mapFrame.pingBtn:OnClick()
  if M_EXPAND_CLICKED then
    SetExpansion(false, true)
  end
  DrawBtnClick(PING_TYPE_PING)
end
mapFrame.pingBtn:SetHandler("OnClick", mapFrame.pingBtn.OnClick)
local pingEvents = {
  SET_PING_MODE = function(arg)
    DrawBtnClick(PING_TYPE_PING, arg)
  end,
  SET_EFFECT_ICON_VISIBLE = function(isShow, arg)
    if arg == nil or arg.effect == nil then
      return
    end
    arg.effect:SetStartEffect(isShow)
  end,
  REMOVE_PING = function()
    RemovePingAll()
  end
}
mapFrame.pingBtn:SetHandler("OnEvent", function(this, event, ...)
  pingEvents[event](...)
end)
RegistUIEvent(mapFrame.pingBtn, pingEvents)
function PopPingMenu(stickTo, pingType)
  local isPartyTeam = X2Team:IsPartyTeam()
  local isRaidTeam = X2Team:IsRaidTeam()
  if (isPartyTeam or isRaidTeam) and not X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) then
    if not X2Team:IsHeadMarker(X2Team:GetTeamPlayerIndex()) then
      return
    end
    if pingType ~= PING_TYPE_PING then
      return
    end
  end
  local popupInfo = GetDefaultPopupInfoTable()
  popupInfo:AddInfo(locale.map.pingMenu[1], RemovePing, pingType)
  ShowPopUpMenu("popupMenu", stickTo, popupInfo)
end
function mapFrame.enemyBtn:OnClick()
  DrawBtnClick(PING_TYPE_ENEMY)
end
mapFrame.enemyBtn:SetHandler("OnClick", mapFrame.enemyBtn.OnClick)
function mapFrame.attackBtn:OnClick()
  DrawBtnClick(PING_TYPE_ATTACK)
end
mapFrame.attackBtn:SetHandler("OnClick", mapFrame.attackBtn.OnClick)
function mapFrame.lineBtn:OnClick()
  DrawBtnClick(PING_TYPE_LINE)
end
mapFrame.lineBtn:SetHandler("OnClick", mapFrame.lineBtn.OnClick)
function mapFrame.eraserBtn:OnClick()
  RemovePingAll()
end
mapFrame.eraserBtn:SetHandler("OnClick", mapFrame.eraserBtn.OnClick)
function InitMapPingWidget()
  local ClickFunc = function(map, arg, frame, pingType)
    if arg == "RightButton" then
      PopPingMenu(frame, pingType)
    elseif arg == "LeftButton" then
      map:OnLeftClick()
    end
  end
  local wPing = CreatePingFrame("wPing", worldmap, PING_TYPE_PING)
  mapFrame.wPing = wPing
  function wPing:OnClick(arg)
    ClickFunc(worldmap, arg, self, PING_TYPE_PING)
  end
  wPing:SetHandler("OnClick", wPing.OnClick)
  local wEnemy = CreatePingFrame("wEnemy", worldmap, PING_TYPE_ENEMY)
  mapFrame.wEnemy = wEnemy
  function wEnemy:OnClick(arg)
    ClickFunc(worldmap, arg, self, PING_TYPE_ENEMY)
  end
  wEnemy:SetHandler("OnClick", wEnemy.OnClick)
  local wAttack = CreatePingFrame("wAttack", worldmap, PING_TYPE_ATTACK)
  mapFrame.wAttack = wAttack
  function wAttack:OnClick(arg)
    ClickFunc(worldmap, arg, self, PING_TYPE_ATTACK)
  end
  wAttack:SetHandler("OnClick", wAttack.OnClick)
  local wLine = CreatePingFrame("wLine", worldmap, PING_TYPE_LINE)
  mapFrame.wLine = wLine
  function wLine:OnClick(arg)
    ClickFunc(worldmap, arg, self, PING_TYPE_LINE)
  end
  wLine:SetHandler("OnClick", wLine.OnClick)
  local rPing = CreatePingFrame("rPing", roadmap, PING_TYPE_PING)
  mapFrame.rPing = rPing
  function rPing:OnClick(arg)
    ClickFunc(roadmap, arg, self, PING_TYPE_PING)
  end
  rPing:SetHandler("OnClick", rPing.OnClick)
  local rEnemy = CreatePingFrame("rEnemy", roadmap, PING_TYPE_ENEMY)
  mapFrame.rEnemy = rEnemy
  function rEnemy:OnClick(arg)
    ClickFunc(roadmap, arg, self, PING_TYPE_ENEMY)
  end
  rEnemy:SetHandler("OnClick", rEnemy.OnClick)
  local rAttack = CreatePingFrame("rAttack", roadmap, PING_TYPE_ATTACK)
  mapFrame.rAttack = rAttack
  function rAttack:OnClick(arg)
    ClickFunc(roadmap, arg, self, PING_TYPE_ATTACK)
  end
  rAttack:SetHandler("OnClick", rAttack.OnClick)
  local rLine = CreatePingFrame("rLine", roadmap, PING_TYPE_LINE)
  mapFrame.rLine = rLine
  function rLine:OnClick(arg)
    ClickFunc(roadmap, arg, self, PING_TYPE_LINE)
  end
  rLine:SetHandler("OnClick", rLine.OnClick)
end
InitMapPingWidget()
