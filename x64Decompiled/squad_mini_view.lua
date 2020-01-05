local SQUAD_EVENT_BUTTON_TYPE = {
  APPLY = 1,
  READY = 2,
  READY_CANCEL = 3,
  ENTER = 4
}
local MAX_EVENT_BUTTON_SIZE = 44
local EVENT_BUTTON_INSET = 8
local SQAUD_MINI_VIEW_TEXTURE_PATH = "ui/battlefield/team_hud.dds"
local SQAUD_MINI_VIEW_IMG_INFO = {
  BTN_OPEN_BATTLEFIELD = {
    drawableType = "drawable",
    path = SQAUD_MINI_VIEW_TEXTURE_PATH,
    coordsKey = "info_btn"
  },
  BTN_READY = {
    drawableType = "threePart",
    path = SQAUD_MINI_VIEW_TEXTURE_PATH,
    coordsKey = "text_btn",
    fontColor = {
      normal = F_COLOR.GetColor("team_hud_btn_text_df"),
      highlight = F_COLOR.GetColor("team_hud_btn_text_ov"),
      pushed = F_COLOR.GetColor("team_hud_btn_text_on"),
      disabled = F_COLOR.GetColor("team_hud_btn_text_dis")
    },
    fontInset = {
      left = 8,
      right = 8,
      top = 0,
      bottom = 0
    },
    autoResize = true
  }
}
local screenHeight = UIParent:GetScreenHeight()
local hudHeight = 60
local slotHeight = 440
local squadMiniViewCtrl = {}
local function CreateMainView()
  local buttonWindow = CreateEmptyWindow("buttonWindow", "UIParent")
  buttonWindow:Show(true)
  buttonWindow:SetExtent(28, 28)
  buttonWindow:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", 0, 130)
  squadMiniViewCtrl.buttonWindow = buttonWindow
  local closeBtn = CreateEmptyButton("closeBtn", buttonWindow)
  closeBtn:Show(false)
  closeBtn:RegisterForClicks("LeftButton")
  closeBtn:EnableDrag(false)
  closeBtn:AddAnchor("TOPRIGHT", buttonWindow, "TOPRIGHT", 0, 0)
  ApplyButtonSkin(closeBtn, BUTTON_HUD.SQUAD_MINI_VIEW_CLOSE)
  squadMiniViewCtrl.closeBtn = closeBtn
  local CloseBtnLeftClickFunc = function()
    ToggleSquadView(false)
  end
  ButtonOnClickHandler(closeBtn, CloseBtnLeftClickFunc)
  local openBtn = CreateEmptyButton("openBtn", buttonWindow)
  openBtn:Show(false)
  openBtn:RegisterForClicks("LeftButton")
  openBtn:EnableDrag(false)
  openBtn:AddAnchor("TOPRIGHT", buttonWindow, "TOPRIGHT", 0, 0)
  ApplyButtonSkin(openBtn, BUTTON_HUD.SQUAD_MINI_VIEW_OPEN)
  squadMiniViewCtrl.openBtn = openBtn
  local OpenBtnLeftClickFunc = function()
    ToggleSquadView(true)
  end
  ButtonOnClickHandler(openBtn, OpenBtnLeftClickFunc)
  local squadMiniView = CreateEmptyWindow("squadMiniView", "UIParent")
  squadMiniView:SetExtent(240, 260)
  squadMiniView:AddAnchor("TOPRIGHT", buttonWindow, "BOTTOMRIGHT", 0, -4)
  function squadMiniView:OnShow()
    UpdateSquadView()
  end
  squadMiniView:SetHandler("OnShow", squadMiniView.OnShow)
  squadMiniViewCtrl.view = squadMiniView
  squadMiniViewCtrl.view.visible = true
  local squadMiniBg = squadMiniView:CreateDrawable(TEXTURE_PATH.HUD, "team_bg", "background")
  squadMiniBg:SetTextureColor("team_alpha75")
  squadMiniBg:SetExtent(240, 260)
  squadMiniBg:AddAnchor("TOPRIGHT", squadMiniView, "TOPRIGHT", 0, 0)
  local openSquadViewBtn = CreateEmptyButton("openBtn", squadMiniView)
  openSquadViewBtn:Show(true)
  openSquadViewBtn:RegisterForClicks("LeftButton")
  openSquadViewBtn:EnableDrag(false)
  openSquadViewBtn:AddAnchor("TOPLEFT", squadMiniView, "TOPLEFT", 5, 3)
  ApplyButtonSkin(openSquadViewBtn, SQAUD_MINI_VIEW_IMG_INFO.BTN_OPEN_BATTLEFIELD)
  local openSquadViewBtnLeftClickFunc = function()
    squadWnd:ToggleSquadWindow()
  end
  ButtonOnClickHandler(openSquadViewBtn, openSquadViewBtnLeftClickFunc)
  local OnEnter = function(self)
    SetTargetAnchorTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "squad_info_view"), "BOTTOMLEFT", self, "TOPLEFT", -1, -1)
  end
  openSquadViewBtn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  openSquadViewBtn:SetHandler("OnLeave", OnLeave)
  local sandglassWnd = CreateEmptyWindow("sandglassWnd", squadMiniView)
  sandglassWnd:AddAnchor("TOPRIGHT", squadMiniView, "TOPRIGHT", -9, 7)
  squadMiniViewCtrl.sandglassWnd = sandglassWnd
  local sandglassImg = sandglassWnd:CreateDrawable(SQAUD_MINI_VIEW_TEXTURE_PATH, "sandglass", "background")
  sandglassImg:AddAnchor("TOPRIGHT", sandglassWnd, "TOPRIGHT")
  sandglassWnd:SetExtent(sandglassImg:GetExtent())
  local OnEnter = function(self)
    SetTargetAnchorTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "squad_matching"), "BOTTOMRIGHT", self, "TOPRIGHT", -1, -1)
  end
  sandglassWnd:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  sandglassWnd:SetHandler("OnLeave", OnLeave)
  local titleLabel = squadMiniView:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(FONT_SIZE.LARGE)
  titleLabel.style:SetAlign(ALIGN_CENTER)
  titleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  titleLabel.style:SetEllipsis(true)
  titleLabel:AddAnchor("LEFT", openSquadViewBtn, "RIGHT", 5, 0)
  titleLabel:AddAnchor("RIGHT", sandglassWnd, "LEFT", -5, 0)
  ApplyTextColor(titleLabel, FONT_COLOR.SOFT_YELLOW)
  squadMiniViewCtrl.titleLabel = titleLabel
  local squadMemberList = W_CTRL.CreateScrollListCtrl("listCtrl", squadMiniView)
  squadMemberList.scroll:RemoveAllAnchors()
  squadMemberList.scroll:AddAnchor("TOPRIGHT", squadMemberList, 0, 0)
  squadMemberList.scroll:AddAnchor("BOTTOMRIGHT", squadMemberList, 0, 0)
  squadMemberList:SetExtent(240, 200)
  squadMemberList:AddAnchor("TOPLEFT", squadMiniView, "TOPLEFT", 0, 30)
  squadMemberList:HideColumnButtons()
  squadMemberList.scroll:Show(false)
  squadMiniViewCtrl.squadMemberList = squadMemberList
  local function LayoutFunc(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    local leaderMark = W_ICON.CreateLeaderMark("leaderMark", subItem)
    leaderMark:AddAnchor("LEFT", subItem, "LEFT", 9, 0)
    leaderMark:SetMarkTexture("leader")
    subItem.leaderMark = leaderMark
    local readyImg = frame:CreateDrawable(TEXTURE_PATH.HUD, "ready_check", "background")
    readyImg:AddAnchor("RIGHT", subItem, "RIGHT", 0, 0)
    subItem.readyImg = readyImg
    local onflineBg = frame:CreateDrawable(SQAUD_MINI_VIEW_TEXTURE_PATH, "online_bg", "background")
    onflineBg:AddAnchor("LEFT", subItem, "LEFT", 3, 0)
    subItem.onflineBg = onflineBg
    local upperLineImg = frame:CreateDrawable(SQAUD_MINI_VIEW_TEXTURE_PATH, "line", "background")
    upperLineImg:SetTextureColor("blue")
    upperLineImg:AddAnchor("TOPLEFT", subItem, "TOPLEFT")
    subItem.upperLineImg = upperLineImg
    local lowerLineImg = frame:CreateDrawable(SQAUD_MINI_VIEW_TEXTURE_PATH, "line", "background")
    lowerLineImg:SetTextureColor("black")
    lowerLineImg:AddAnchor("BOTTOMLEFT", subItem, "BOTTOMLEFT")
    subItem.lowerLineImg = lowerLineImg
  end
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.name))
      subItem.readyImg:Show(data.ready)
      if data.leader then
        subItem.leaderMark:SetMarkTexture("leader")
        subItem:SetInset(23, 3, 0, 0)
      else
        subItem.leaderMark:SetMarkTexture("")
        subItem:SetInset(10, 3, 0, 0)
      end
      if data.offline then
        subItem.onflineBg:Show(false)
      else
        subItem.onflineBg:Show(true)
      end
      local fontColor = F_COLOR.GetColor("team_hud_blue")
      if data.offline then
        fontColor = F_COLOR.GetColor("text_btn_dis")
      end
      ApplyTextColor(subItem, fontColor)
    else
      subItem:SetText("")
      subItem.leaderMark:SetMarkTexture("")
      subItem.readyImg:Show(false)
      subItem.onflineBg:Show(false)
    end
  end
  squadMemberList:InsertColumn("", 234, LCCIT_CHARACTER_NAME, SetDataFunc, nil, nil, LayoutFunc)
  squadMemberList:InsertRows(10, false)
  for i = 1, 5 do
    local data = {}
    data.name = "name_" .. i
    local leader = false
    if i == 3 then
      leader = true
    end
    data.leader = leader
    local ready = false
    if i == 4 then
      ready = true
    end
    data.ready = ready
    local online = false
    if i == 5 then
      online = true
    end
    data.online = online
    squadMemberList:InsertData(i, 1, data)
  end
  local readyBtn = CreateEmptyButton("readyBtn", squadMiniView)
  readyBtn:Show(true)
  readyBtn:RegisterForClicks("LeftButton")
  readyBtn:EnableDrag(false)
  readyBtn:AddAnchor("BOTTOMRIGHT", squadMiniView, "BOTTOMRIGHT", -6, -4)
  readyBtn:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "squad_ready"))
  ApplyButtonSkin(readyBtn, SQAUD_MINI_VIEW_IMG_INFO.BTN_READY)
  squadMiniViewCtrl.readyBtn = readyBtn
  local function ReadyBtnLeftClickFunc()
    if readyBtn.buttonType == SQUAD_EVENT_BUTTON_TYPE.APPLY then
      X2Squad:ApplySquadMatching()
    elseif readyBtn.buttonType == SQUAD_EVENT_BUTTON_TYPE.READY then
      X2Squad:ReadySquad()
    elseif readyBtn.buttonType == SQUAD_EVENT_BUTTON_TYPE.READY_CANCEL then
      X2Squad:ReadySquad()
    elseif readyBtn.buttonType == SQUAD_EVENT_BUTTON_TYPE.ENTER then
      X2Squad:EnterSquadMatching()
    end
  end
  ButtonOnClickHandler(readyBtn, ReadyBtnLeftClickFunc)
end
local EnableSquad = function()
  return X2Player:GetFeatureSet().squad and UIParent:GetPermission(UIC_SQUAD_MINIVIEW) and X2Squad:HasMySquad()
end
function ToggleSquadView(opened)
  if not EnableSquad() then
    return
  end
  squadMiniViewCtrl.view:Show(opened)
  squadMiniViewCtrl.buttonWindow:Show(true)
  squadMiniViewCtrl.closeBtn:Show(opened)
  squadMiniViewCtrl.openBtn:Show(not opened)
  squadMiniViewCtrl.view.visible = opened
  UpdateSquadView()
end
function UpdateSquadView()
  squadMiniViewCtrl.squadMemberList:DeleteAllDatas()
  if not EnableSquad() then
    return
  end
  if squadMiniViewCtrl.view:IsVisible() == false then
    return
  end
  local info = X2Squad:GetMySquadInfo()
  if info == nil then
    return
  end
  for i = 1, #info do
    squadMiniViewCtrl.squadMemberList:InsertData(i, 1, info[i])
  end
  squadMiniViewCtrl.titleLabel:SetText(info.fieldName)
  local eventButton = squadMiniViewCtrl.readyBtn
  ApplyButtonSkin(squadMiniViewCtrl.readyBtn, SQAUD_MINI_VIEW_IMG_INFO.BTN_READY)
  if info.isJoining then
    eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.ENTER
    eventButton:SetText(GetCommonText("indun_entrance"))
    eventButton:Enable(true)
  elseif info.isReady then
    eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.READY_CANCEL
    eventButton:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "cancel"))
    eventButton:Enable(true)
  elseif info.isLeader then
    eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.APPLY
    eventButton:SetText(GetCommonText("squad_info_apply_matching"))
    eventButton:Enable(info.isAllReady)
  else
    eventButton.buttonType = SQUAD_EVENT_BUTTON_TYPE.READY
    eventButton:SetText(GetCommonText("squad_info_ready"))
    eventButton:Enable(true)
  end
  squadMiniViewCtrl.sandglassWnd:Show(info.matchingApplied)
end
function CloseSquadView()
  squadMiniViewCtrl.view:Show(false)
  squadMiniViewCtrl.buttonWindow:Show(false)
  squadMiniViewCtrl.view.visible = false
end
local function UpdateMiniViewVisible()
  if not EnableSquad() then
    return
  end
  if X2Squad:HasMySquad() then
    ToggleSquadView(squadMiniViewCtrl.view.visible)
  else
    CloseSquadView()
  end
end
if X2Player:GetFeatureSet().squad then
  CreateMainView()
  squadMiniViewCtrl.view.Event = {
    SHOW_SQUAD_WINDOW = function(show)
      if show then
        ToggleSquadView(true)
      else
        CloseSquadView()
      end
    end,
    UPDATE_SQUAD = function()
      UpdateSquadView()
      UpdateMiniViewVisible()
    end,
    LEFT_LOADING = function()
      UpdateMiniViewVisible()
    end
  }
  squadMiniViewCtrl.view:SetHandler("OnEvent", function(this, event, ...)
    squadMiniViewCtrl.view.Event[event](...)
  end)
  RegistUIEvent(squadMiniViewCtrl.view, squadMiniViewCtrl.view.Event)
  ADDON:RegisterContentWidget(UIC_SQUAD_MINIVIEW, squadMiniViewCtrl.view)
  UpdateMiniViewVisible()
end
