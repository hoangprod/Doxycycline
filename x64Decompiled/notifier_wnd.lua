local notifierWnd = CreatNotifierWindow()
function GetNotifierWnd()
  return notifierWnd
end
function notifierWnd:SetAlphaBlending(alpha)
  if self.questBtn ~= nil then
    self.questBtn:SetAlpha(alpha and 0.45 or 1)
  end
  if self.assignmentBtn ~= nil then
    self.assignmentBtn:SetAlpha(alpha and 0.45 or 1)
  end
  local bgAlpha = UIParent:GetTextureData(TEXTURE_PATH.HUD, "bg_quest").colors
  if alpha then
    self.bg:SetColor(unpack(bgAlpha.default))
  else
    self.bg:SetColor(unpack(bgAlpha.over))
  end
  notifierWnd:ReleaseHandler("OnUpdate")
end
function notifierWnd:OnUpdate(dt)
  notifierWnd.delay = notifierWnd.delay + dt
  if notifierWnd.delay < 300 then
    return
  end
  notifierWnd:SetAlphaBlending(false)
end
function notifierWnd:OnEnter()
  notifierWnd.delay = 0
  notifierWnd:SetHandler("OnUpdate", notifierWnd.OnUpdate)
end
notifierWnd:SetHandler("OnEnter", notifierWnd.OnEnter)
function notifierWnd:OnLeave()
  notifierWnd:SetAlphaBlending(true)
end
notifierWnd:SetHandler("OnLeave", notifierWnd.OnLeave)
function notifierWnd:OnScale()
  if self:CheckOutOfScreen() then
    self:RemoveAllAnchors()
    local x, y = self:CorrectOffsetByScreen()
    self:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(x), F_LAYOUT.CalcDontApplyUIScale(y))
  end
end
notifierWnd:SetHandler("OnScale", notifierWnd.OnScale)
function ShowQuestNotifierWnd()
  if not UIParent:GetPermission(UIC_QUEST_NOTIFIER) then
    notifierWnd:Show(false)
    return
  end
  notifierWnd:Show(true)
end
local notifierEvent = {
  INSTANT_GAME_START = function()
    ShowQuestNotifierWnd()
  end,
  LEAVED_INSTANT_GAME_ZONE = function()
    ShowQuestNotifierWnd()
  end,
  ENTERED_WORLD = function()
    FirstTimeInitQuestNotifierData()
    if X2BattleField:IsInInstantGame() then
      ShowQuestNotifierWnd()
    else
      notifierWnd:Refresh()
      ShowQuestNotifierWnd()
    end
  end,
  UI_PERMISSION_UPDATE = function()
    notifierWnd:SelectTab(1)
    notifierWnd:Refresh()
  end,
  LEFT_LOADING = function()
    UpdateAllNotifierDecal()
    notifierWnd:Refresh()
  end,
  DOMINION = function(action)
    if action == "owner_changed" then
      notifierWnd:Refresh()
    end
  end,
  LEVEL_CHANGED = function(_, stringId)
    if not W_UNIT.IsMyUnitId(stringId) then
      return
    end
    notifierWnd:Refresh()
  end,
  QUEST_NOTIFIER_START = function()
    InitQuestNotifierData()
    notifierWnd:Refresh()
  end,
  UI_RELOADED = function()
    InitQuestNotifierData()
    notifierWnd:Refresh()
  end
}
notifierWnd:SetHandler("OnEvent", function(this, event, ...)
  notifierEvent[event](...)
end)
RegistUIEvent(notifierWnd, notifierEvent)
function notifierWnd:SelectTab(index)
  notifierWnd.index = index
  if self.questBtn ~= nil then
    self.questBtn:Enable(index == 2)
  end
  if self.assignmentBtn ~= nil then
    self.assignmentBtn:Enable(index == 1)
  end
  if self.questNotifier ~= nil then
    self.questNotifier:Show(index == 1)
  end
  if self.assignmentNotifier ~= nil then
    self.assignmentNotifier:Show(index == 2)
  end
end
function notifierWnd:SetOpenStatus(open)
  if open == nil then
    open = GetNotifierOpenState()
  end
  if open then
    notifierWnd:SetHeight(GetNofifierHeight())
  else
    notifierWnd:SetHeight(30)
  end
  notifierWnd:UseResizing(open)
  SetNotifierOpenState(open)
  if open then
    notifierWnd:Clickable(true, false)
    ChangeButtonSkin(notifierWnd.toggleBtn, BUTTON_HUD.QUEST_CLOSE)
  else
    notifierWnd:Clickable(false, false)
    ChangeButtonSkin(notifierWnd.toggleBtn, BUTTON_HUD.QUEST_OPEN)
  end
  if notifierWnd.questBtn ~= nil then
    notifierWnd.questBtn:Show(open)
  end
  if notifierWnd.assignmentBtn ~= nil then
    notifierWnd.assignmentBtn:Show(open and UIParent:GetPermission(UIC_ACHIEVEMENT))
  end
  if notifierWnd.questNotifier ~= nil then
    notifierWnd.questNotifier:Show(open and notifierWnd.index == 1)
  end
  if notifierWnd.assignmentNotifier ~= nil then
    notifierWnd.assignmentNotifier:Show(open and notifierWnd.index == 2)
  end
  notifierWnd.bg:SetVisible(open)
  notifierWnd.moveWnd:Show(open)
end
function notifierWnd:ProcMovedSize()
  SetNofifierHeight(notifierWnd:GetHeight())
end
function notifierWnd:ProcChangedAnchor()
  if notifierWnd.questNotifier ~= nil then
    notifierWnd.questNotifier:ResetScrollInfo()
  end
  if notifierWnd.assignmentNotifier ~= nil then
    notifierWnd.assignmentNotifier:ResetScrollInfo()
  end
end
function notifierWnd:ProcBoundChanged()
end
function notifierWnd.toggleBtn:OnClick()
  notifierWnd:SetOpenStatus(not GetNotifierOpenState())
  notifierWnd:Refresh(false)
end
notifierWnd.toggleBtn:SetHandler("OnClick", notifierWnd.toggleBtn.OnClick)
local function OnDragStart()
  if X2Input:IsShiftKeyDown() then
    notifierWnd:StartMoving()
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
  end
end
notifierWnd.moveWnd:SetHandler("OnDragStart", OnDragStart)
local function OnDragStop()
  notifierWnd:StopMovingOrSizing()
  X2Cursor:ClearCursor()
end
notifierWnd.moveWnd:SetHandler("OnDragStop", OnDragStop)
if notifierWnd.questBtn ~= nil then
  function notifierWnd.questBtn:OnClick()
    notifierWnd:SelectTab(1)
  end
  notifierWnd.questBtn:SetHandler("OnClick", notifierWnd.questBtn.OnClick)
  function notifierWnd.questBtn:OnEnter()
    local text = GetUIText(QUEST_TEXT, "quest")
    local consolAttr = Console:GetAttribute("ui_draw_quest_type")
    if consolAttr ~= nil and tonumber(consolAttr) == 1 then
      text = text .. " : " .. tostring(GetNotifierQuestListCount())
    end
    SetVerticalTooltip(text, self)
  end
  notifierWnd.questBtn:SetHandler("OnEnter", notifierWnd.questBtn.OnEnter)
  function notifierWnd.questBtn:OnLeave()
    HideTooltip()
  end
  notifierWnd.questBtn:SetHandler("OnLeave", notifierWnd.questBtn.OnLeave)
end
if notifierWnd.assignmentBtn ~= nil then
  function notifierWnd.assignmentBtn:OnClick()
    notifierWnd:SelectTab(2)
  end
  notifierWnd.assignmentBtn:SetHandler("OnClick", notifierWnd.assignmentBtn.OnClick)
  function notifierWnd.assignmentBtn:OnEnter()
    SetVerticalTooltip(GetUIText(COMMON_TEXT, "assignment_system"), self)
  end
  notifierWnd.assignmentBtn:SetHandler("OnEnter", notifierWnd.assignmentBtn.OnEnter)
  function notifierWnd.assignmentBtn:OnLeave()
    HideTooltip()
  end
  notifierWnd.assignmentBtn:SetHandler("OnLeave", notifierWnd.assignmentBtn.OnLeave)
end
function notifierWnd:Refresh(init, qtype)
  if notifierWnd.questNotifier ~= nil then
    SyncNotifierQuestList()
    local makeAll = true
    if init == false and qtype ~= nil then
      local status = X2Quest:GetActiveQuestListStatusByType(qtype)
      if status == 1 then
        makeAll = false
      end
    end
    if makeAll == true then
      notifierWnd.questNotifier:MakeQuestNotifyList(nil, init)
    else
      notifierWnd.questNotifier:UpdateQuestNotifyList(qtype)
    end
  end
  if notifierWnd.assignmentNotifier ~= nil then
    notifierWnd.assignmentNotifier:MakeList()
  end
  local _, nOffsetY = notifierWnd:GetOffset()
  local nExtentX, nExtentY = notifierWnd:GetExtent()
  local _, mOffsetY = notifierWnd.questNotifier.mainQuestWnd:GetOffset()
  local _, mExtentY = notifierWnd.questNotifier.mainQuestWnd:GetExtent()
  local contentLimitHeight = 90
  local headerHeight = mOffsetY - nOffsetY
  local openHeight = GetNofifierHeight()
  if openHeight < headerHeight + mExtentY + contentLimitHeight then
    SetNofifierHeight(headerHeight + mExtentY + contentLimitHeight)
  end
  notifierWnd:SetMinResizingExtent(nExtentX, headerHeight + mExtentY + contentLimitHeight)
  notifierWnd:SetOpenStatus()
end
function notifierWnd:Init()
  notifierWnd:Refresh(true)
  notifierWnd:SelectTab(1)
  notifierWnd:SetAlphaBlending(true)
end
notifierWnd:Init()
AddUISaveHandlerByKey("questNotifier", notifierWnd)
notifierWnd:ApplyLastWindowOffset()
