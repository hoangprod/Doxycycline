local BUTTON_OFFSET = {
  PREMIUM_SERVICE = {X = -10, Y = -50},
  INGAMESHOP = {X = -10, Y = -50},
  EVENT_CENTER = {X = -80, Y = -50},
  COMMERCIAL_MAIL = {X = -150, Y = -50},
  OPTIMIZATION_BUTTON = {X = -13, Y = -130}
}
local baseWnd = UIParent:CreateWidget("window", "baseWnd", "UIParent")
baseWnd:AddAnchor("TOPLEFT", "UIParent", 0, 145)
baseWnd:Show(true)
baseWnd:SetUILayer("game")
local function SetViewOfPremiumServiceToggleButton(id, parent)
  local toggleButton = UIParent:CreateWidget("button", id, parent)
  toggleButton:AddAnchor("BOTTOMRIGHT", "UIParent", BUTTON_OFFSET.PREMIUM_SERVICE.X, BUTTON_OFFSET.PREMIUM_SERVICE.Y)
  ApplyButtonSkin(toggleButton, BUTTON_HUD.TOGGLE_NO_PREMIUM_SERVICE)
  function toggleButton:PremiumGradeChageToggle()
    local isPremiumService = X2PremiumService:IsPremiumService()
    if isPremiumService == false then
      ChangeButtonSkin(self, BUTTON_HUD.TOGGLE_NO_PREMIUM_SERVICE)
    else
      ChangeButtonSkin(self, BUTTON_HUD.TOGGLE_PREMIUM_SERVICE)
    end
  end
  toggleButton:PremiumGradeChageToggle()
  return toggleButton
end
function SetHandlerCommercialMailBadge(widget)
  local mailCount = 0
  function widget:OnCommercialMailInboxUpdated()
    local count = X2GoodsMail:GetCountUnreadMail()
    if count > mailCount then
      F_SOUND.PlayUISound("event_commercial_mail_alarm")
    end
    mailCount = count
    if count == 0 then
      count = ""
      widget:Show(false)
    else
      count = tostring(count)
      widget:Show(true)
    end
    self:SetText(tostring(count))
  end
  widget:SetHandler("OnEvent", function(this, event, ...)
    this:OnCommercialMailInboxUpdated()
  end)
  widget:RegisterEvent("GOODS_MAIL_INBOX_UPDATE")
  widget:OnCommercialMailInboxUpdated()
end
function CreatePremiumServiceToggleButton(id, parent)
  local button = SetViewOfPremiumServiceToggleButton(id, parent)
  local LeftButtonCLickFunc = function()
    TogglePremiumService()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local OnEnter = function(self)
    local premiumSeviceToolTip = X2PremiumService:GetPremiumSeviceToolTipInfo()
    local grade = X2PremiumService:GetPremiumGradeKind()
    local endTime = X2PremiumService:GetPremiumSeviceEndTime()
    local ispremiumService = X2PremiumService:IsPremiumService()
    if grade == PG_PREMIUM_0 or ispremiumService == false then
      SetVerticalTooltip(mainMenuBarLocale:GetArcheLifeBtnTip(), self)
    elseif premiumSeviceToolTip == nil then
      HideTooltip()
    elseif endTime == nil then
      SetPremiumServiceToolTip(grade, "", premiumSeviceToolTip.tooltip, self)
    else
      SetPremiumServiceToolTip(grade, premiumServiceLocale.GetDateToPremiumServiceFormat(endTime.payEnd), premiumSeviceToolTip.tooltip, self)
    end
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  local function OnScale(self)
    self:RemoveAllAnchors()
    self:AddAnchor("BOTTOMRIGHT", "UIParent", BUTTON_OFFSET.PREMIUM_SERVICE.X, BUTTON_OFFSET.PREMIUM_SERVICE.Y)
  end
  button:SetHandler("OnScale", OnScale)
  return button
end
local featureSet = X2Player:GetFeatureSet()
local screenState = X2Player:GetUIScreenState()
if featureSet.premium and screenState ~= SCREEN_CHARACTER_SELECT and hudLocale ~= nil and hudLocale.visiblePremiumBtn then
  premiumServiceToggleButton = CreatePremiumServiceToggleButton("premiumServiceToggleButton", baseWnd)
  premiumServiceToggleButton:Show(true)
end
if featureSet.premium and hudLocale.visiblePremiumBtn then
  BUTTON_OFFSET.INGAMESHOP.X = BUTTON_OFFSET.INGAMESHOP.X - 70
end
local function SetViewOfInGameShopToggleButton(id, parent)
  local toggleButton = UIParent:CreateWidget("button", id, parent)
  ApplyButtonSkin(toggleButton, BUTTON_HUD.TOGGLE_INGAMESHOP)
  toggleButton:AddAnchor("BOTTOMRIGHT", "UIParent", BUTTON_OFFSET.INGAMESHOP.X, BUTTON_OFFSET.INGAMESHOP.Y)
  return toggleButton
end
local function CreateInGameShopToggleButton(id, parent)
  local btn = SetViewOfInGameShopToggleButton(id, parent)
  local LeftButtonCLickFunc = function()
    ToggleInGameShop()
  end
  ButtonOnClickHandler(btn, LeftButtonCLickFunc)
  local OnEnter = function(self)
    local bindKeyText = string.upper(X2Hotkey:GetBinding("toggle_ingameshop", 1))
    SetVerticalTooltip(locale.tooltip.inGameShopToggleButton(bindKeyText), self)
  end
  btn:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  btn:SetHandler("OnLeave", OnLeave)
  local function OnScale(self)
    self:RemoveAllAnchors()
    self:AddAnchor("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", BUTTON_OFFSET.INGAMESHOP.X, BUTTON_OFFSET.INGAMESHOP.Y)
  end
  btn:SetHandler("OnScale", OnScale)
  return btn
end
local ingameshopToggleButton
if featureSet.ingamecashshop then
  ingameshopToggleButton = CreateInGameShopToggleButton("ingameshopToggleButton", baseWnd)
  ingameshopToggleButton:Show(true)
end
if featureSet.premium and hudLocale.visiblePremiumBtn then
  BUTTON_OFFSET.EVENT_CENTER.X = BUTTON_OFFSET.EVENT_CENTER.X - 70
end
local function CreateEventCenterToggleButton(id, parent)
  local btn = UIParent:CreateWidget("button", id, parent)
  ApplyButtonSkin(btn, BUTTON_HUD.TOGGLE_EVENT_CENTER)
  btn:AddAnchor("BOTTOMRIGHT", "UIParent", BUTTON_OFFSET.EVENT_CENTER.X, BUTTON_OFFSET.EVENT_CENTER.Y)
  local alarmIcon = btn:CreateDrawable(TEXTURE_PATH.HUD, "everyday_n", "overlay")
  alarmIcon:AddAnchor("TOPLEFT", btn, 5, 6)
  alarmIcon:SetVisible(false)
  local function LeftButtonCLickFunc()
    if featureSet.archePass then
      ToggleArchePassWithQuest()
    else
      ToggleEventCenter()
    end
  end
  ButtonOnClickHandler(btn, LeftButtonCLickFunc)
  local function OnScale(self)
    self:RemoveAllAnchors()
    self:AddAnchor("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", BUTTON_OFFSET.EVENT_CENTER.X, BUTTON_OFFSET.EVENT_CENTER.Y)
  end
  btn:SetHandler("OnScale", OnScale)
  function btn:UpdateAlramIcon()
    local visible = AttendanceActived() or TodayAssignmentActived() or ShowEventInfoNewIcon() or ArchePassActived()
    alarmIcon:SetVisible(visible)
  end
  btn:UpdateAlramIcon()
  local events = {
    ACCOUNT_ATTENDANCE_LOADED = function()
      btn:UpdateAlramIcon()
    end,
    ACCOUNT_ATTENDANCE_ADDED = function()
      btn:UpdateAlramIcon()
    end,
    QUEST_CONTEXT_UPDATED = function(qType, status)
      if X2Quest:IsTodayQuest(qType) and status == "updated" then
        btn:UpdateAlramIcon()
      end
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      btn:UpdateAlramIcon()
    end,
    UPDATE_TODAY_ASSIGNMENT = function()
      btn:UpdateAlramIcon()
    end,
    START_TODAY_ASSIGNMENT = function()
      btn:UpdateAlramIcon()
    end,
    GAME_EVENT_INFO_LIST_UPDATED = function()
      btn:UpdateAlramIcon()
    end
  }
  btn:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(btn, events)
  return btn
end
local eventCenterToggleButton = CreateEventCenterToggleButton("eventCenterToggleButton", baseWnd)
eventCenterToggleButton:Show(true)
function UpdateEventCenterToggleButton()
  eventCenterToggleButton:UpdateAlramIcon()
end
local function CreateConvenienceBtn(id, parent)
  local button = UIParent:CreateWidget("button", id, parent)
  button:Show(true)
  ApplyButtonSkin(button, BUTTON_HUD.TOGGLE_CONVENIENCE)
  local badge = button:CreateChildWidget("label", "badge", 0, true)
  badge:AddAnchor("TOPRIGHT", button, 0, 5)
  badge:SetExtent(29, 28)
  badge:SetInset(0, 0, 1, 4)
  badge.style:SetShadow(true)
  badge.style:SetFontSize(FONT_SIZE.SMALL)
  local bg = badge:CreateDrawable(TEXTURE_PATH.HUD, "sendbox_balloon", "background")
  bg:AddAnchor("TOPLEFT", badge, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", badge, 0, 0)
  SetHandlerCommercialMailBadge(badge)
  function badge:OnShow()
    if #button.toggleChildWidgets > 0 and button.toggleChildWidgets[1]:IsVisible() then
      self:Show(false)
    end
  end
  badge:SetHandler("OnShow", badge.OnShow)
  local function AnchorButton()
    if ingameshopToggleButton ~= nil then
      if eventCenterToggleButton ~= nil then
        button:AddAnchor("BOTTOMRIGHT", eventCenterToggleButton, "BOTTOMLEFT", -2, 0)
      else
        button:AddAnchor("BOTTOMRIGHT", ingameshopToggleButton, "BOTTOMLEFT", -2, 0)
      end
    else
      button:AddAnchor("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", BUTTON_OFFSET.INGAMESHOP.X, BUTTON_OFFSET.INGAMESHOP.Y)
    end
  end
  AnchorButton()
  local function LeftButtonCLickFunc()
    button:ToggleChildWidgets()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local function OnScale(self)
    self:RemoveAllAnchors()
    AnchorButton()
  end
  button:SetHandler("OnScale", OnScale)
  button.toggleChildWidgets = {}
  function button:PushToggleChildWidget(widget)
    distance = -57
    ANCHOR_DATAS = {
      {
        x = math.cos(math.rad(-10)) * distance,
        y = math.sin(math.rad(-10)) * distance
      },
      {
        x = math.cos(math.rad(20)) * distance,
        y = math.sin(math.rad(20)) * distance
      },
      {
        x = math.cos(math.rad(50)) * distance,
        y = math.sin(math.rad(50)) * distance
      },
      {
        x = math.cos(math.rad(80)) * distance,
        y = math.sin(math.rad(80)) * distance
      },
      {
        x = math.cos(math.rad(110)) * distance,
        y = math.sin(math.rad(110)) * distance
      }
    }
    index = #self.toggleChildWidgets + 1
    if index > #ANCHOR_DATAS then
      return
    end
    self.toggleChildWidgets[index] = widget
    widget:AddAnchor("CENTER", self, "CENTER", ANCHOR_DATAS[index].x, ANCHOR_DATAS[index].y)
  end
  function button:ToggleChildWidgets()
    local hideBadge
    for i = 1, #self.toggleChildWidgets do
      self.toggleChildWidgets[i]:Show(not self.toggleChildWidgets[i]:IsVisible())
      hideBadge = self.toggleChildWidgets[i]:IsVisible()
    end
    if badge:GetText() == "" then
      hideBadge = true
    end
    badge:Show(not hideBadge)
  end
  return button
end
local convenienceBtn = CreateConvenienceBtn("convenienceBtn", baseWnd)
local CreateAuctionToggleBtn = function(id, parent)
  local button = parent:CreateChildWidget("button", id, 0, true)
  button:Show(false)
  ApplyButtonSkin(button, BUTTON_HUD.TOGGLE_AUCTION)
  local function LeftButtonCLickFunc()
    parent:ToggleChildWidgets()
    X2Auction:ToggleAuction()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local function OnShow()
    local hasAuthority = X2Auction:HasHudAuctionAuthority()
    button:Enable(hasAuthority)
  end
  button:SetHandler("OnShow", OnShow)
  local function OnEnter(self)
    local str
    if button:IsEnabled() then
      local bindKeyText = string.upper(X2Hotkey:GetBinding("toggle_auction", 1))
      if bindKeyText == nil or bindKeyText == "" then
        str = GetUIText(WINDOW_TITLE_TEXT, "auction")
      else
        str = string.format("%s %s(%s)", GetUIText(WINDOW_TITLE_TEXT, "auction"), FONT_COLOR_HEX.DEFAULT, bindKeyText)
      end
    else
      str = GetUIText(ERROR_MSG, "AUC_INVALID_HUD_AUTHORITY")
    end
    if str ~= nil then
      SetVerticalTooltip(str, self)
    end
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  parent:PushToggleChildWidget(button)
  return button
end
if featureSet.hudAuctionButton then
  local auctionToggleBtn = CreateAuctionToggleBtn("auctionToggleBtn", convenienceBtn)
end
local CreateRequestBattleFieldToggleBtn = function(id, parent)
  local button = UIParent:CreateWidget("button", id, parent)
  ApplyButtonSkin(button, BUTTON_HUD.TOGGLE_MAIN_HUD_REQUEST_BATTLE_FIELD)
  function button:CheckEnabled()
    button:Enable(X2Player:IsInSeamlessZone())
  end
  button:SetHandler("OnShow", button.CheckEnabled)
  local LeftButtonCLickFunc = function()
    X2BattleField:ToggleBattleField()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local OnEnter = function(self)
    local str = ""
    if self:IsEnabled() == false then
      str = GetUIText(COMMON_TEXT, "instant_game_hud_button_disable_tooltip")
    else
      local bindKeyText = string.upper(X2Hotkey:GetBinding("toggle_battle_field", 1))
      if bindKeyText == nil or bindKeyText == "" then
        str = GetUIText(MSG_BOX_TITLE_TEXT, "instant_game_bad_level")
      else
        str = string.format("%s %s(%s)", GetUIText(MSG_BOX_TITLE_TEXT, "instant_game_bad_level"), FONT_COLOR_HEX.DEFAULT, bindKeyText)
      end
    end
    SetVerticalTooltip(str, self)
  end
  button:SetHandler("OnEnter", OnEnter)
  return button
end
local CreateMailBoxToggleBtn = function(id, parent)
  local button = parent:CreateChildWidget("button", id, 0, true)
  button:Show(false)
  ApplyButtonSkin(button, BUTTON_HUD.TOGGLE_MAIL)
  local function LeftButtonCLickFunc()
    parent:ToggleChildWidgets()
    X2Mail:ToggleMailBox()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local OnEnter = function(self)
    local bindKeyText = string.upper(X2Hotkey:GetBinding("toggle_mail", 1))
    local str = ""
    if bindKeyText == nil or bindKeyText == "" then
      str = GetUIText(WINDOW_TITLE_TEXT, "mail")
    else
      str = string.format("%s %s(%s)", GetUIText(WINDOW_TITLE_TEXT, "mail"), FONT_COLOR_HEX.DEFAULT, bindKeyText)
    end
    SetVerticalTooltip(str, self)
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  parent:PushToggleChildWidget(button)
  return button
end
if featureSet.hudMailBoxButton then
  local mailBoxToggleBtn = CreateMailBoxToggleBtn("mailBoxToggleBtn", convenienceBtn)
end
local CreateCommercialMailBtn = function(id, parent)
  local button = parent:CreateChildWidget("button", id, 0, true)
  button:Show(false)
  ApplyButtonSkin(button, BUTTON_HUD.TOGGLE_COMMERCIAL_MAIL)
  local badge = button:CreateChildWidget("label", "badge", 0, true)
  badge:AddAnchor("TOPRIGHT", button, 7, -2)
  badge:SetExtent(29, 28)
  badge:SetInset(0, 0, 0, 3)
  badge.style:SetShadow(true)
  badge.style:SetFontSize(FONT_SIZE.SMALL)
  local bg = badge:CreateDrawable(TEXTURE_PATH.HUD, "sendbox_balloon", "background")
  bg:AddAnchor("TOPLEFT", badge, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", badge, 0, 0)
  SetHandlerCommercialMailBadge(badge)
  local function LeftButtonCLickFunc()
    parent:ToggleChildWidgets()
    ToggleComercialMailBox()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  ButtonOnClickHandler(badge, LeftButtonCLickFunc)
  local OnEnter = function(self)
    local bindKeyText = string.upper(X2Hotkey:GetBinding("toggle_commercial_mail", 1))
    local str = ""
    if bindKeyText == nil or bindKeyText == "" then
      str = GetUIText(MSG_BOX_TITLE_TEXT, "instant_game_bad_level")
    else
      str = string.format("%s %s(%s)", GetUIText(INFOBAR_MENU_TEXT, "commercial_mail"), FONT_COLOR_HEX.DEFAULT, bindKeyText)
    end
    SetVerticalTooltip(str, self)
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  parent:PushToggleChildWidget(button)
  return button
end
local commercialMailBtn = CreateCommercialMailBtn("commercialMailBtn", convenienceBtn)
local CreateRaidRecruitBtn = function(id, parent)
  local button = parent:CreateChildWidget("button", id, 0, true)
  button:Show(false)
  ApplyButtonSkin(button, BUTTON_HUD.TOGGLE_RAID)
  function button:CheckEnabled()
    button:Enable(not X2BattleField:IsInInstantGame())
  end
  button:SetHandler("OnShow", button.CheckEnabled)
  local function LeftButtonCLickFunc()
    parent:ToggleChildWidgets()
    ToggleRaidRecruit(not RaidRecruit:IsVisible())
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local OnEnter = function(self)
    local str = ""
    if not X2BattleField:IsInInstantGame() then
      str = GetUIText(COMMON_TEXT, "raid_recruit_and_search")
    else
      str = GetUIText(COMMON_TEXT, "instant_game_hud_button_disable_tooltip")
    end
    SetVerticalTooltip(str, self)
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  parent:PushToggleChildWidget(button)
  return button
end
local raidRecruitBtn = CreateRaidRecruitBtn("raidRecruitBtn", convenienceBtn)
UIParent:SetEventHandler("LEFT_LOADING", raidRecruitBtn.CheckEnabled)
local function SetViewOfOptimizationToggleButton(id, parent)
  local toggleButton = UIParent:CreateWidget("button", id, parent)
  toggleButton:AddAnchor("BOTTOMRIGHT", "UIParent", BUTTON_OFFSET.OPTIMIZATION_BUTTON.X, BUTTON_OFFSET.OPTIMIZATION_BUTTON.Y)
  ApplyButtonSkin(toggleButton, BUTTON_HUD.TOGGLE_OPTIMIZATION_OFF)
  function toggleButton:Update()
    if X2Option:GetOptionItemValue(OPTION_ITEM_OPTIMIZATION_ENABLE) == 0 then
      ChangeButtonSkin(self, BUTTON_HUD.TOGGLE_OPTIMIZATION_OFF)
    else
      ChangeButtonSkin(self, BUTTON_HUD.TOGGLE_OPTIMIZATION_ON)
    end
  end
  function toggleButton:OptimizationEnableToggle()
    self:OptimizationEnable(X2Option:GetOptionItemValue(OPTION_ITEM_OPTIMIZATION_ENABLE) == 0)
    self:Update()
  end
  function toggleButton:OptimizationEnable(enable)
    X2Option:OptimizationEnable(enable)
    self:Update()
  end
  toggleButton:Update()
  return toggleButton
end
local ShowMsgboxToggleOptimization = function(button)
  local stampKey = ""
  local windowTitle = ""
  local windowContentText = ""
  if X2Option:GetOptionItemValue(OPTION_ITEM_OPTIMIZATION_ENABLE) == 0 then
    stampKey = "enable_optimization"
    windowTitle = "optimization_button_on"
    windowContentText = "optimization_enable_text"
  else
    stampKey = "disable_optimization"
    windowTitle = "optimization_button_off"
    windowContentText = "optimization_disable_text"
  end
  local savedStamp = UI:GetUIStamp(stampKey)
  if savedStamp ~= nil and savedStamp == "ignore" then
    button:OptimizationEnableToggle()
    return
  end
  local function DialogHandler(wnd)
    ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_IGNORE_CHECKBOX)
    local title = GetUIText(WINDOW_TITLE_TEXT, windowTitle)
    local content = GetUIText(COMMON_TEXT, windowContentText)
    wnd:SetContentEx(title, content)
    function wnd:OkProc()
      local checked = self.checkButton:GetChecked()
      if checked then
        UI:SetUIStamp(stampKey, "ignore")
      else
        UI:SetUIStamp(stampKey, "show")
      end
      button:OptimizationEnableToggle()
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogHandler, "")
end
function CreateOptimizationToggleButton(id, parent)
  local button = SetViewOfOptimizationToggleButton(id, parent)
  local function LeftButtonCLickFunc()
    ShowMsgboxToggleOptimization(button)
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local function OnEnter(self)
    local text = GetCommonText("optimization_button_tooltip")
    SetTooltip(text, button)
  end
  button:SetHandler("OnEnter", OnEnter)
  local function RefreshOptimizationEnable()
    if X2Option:GetOptionItemValue(OPTION_ITEM_OPTIMIZATION_ENABLE) ~= 0 then
      button:OptimizationEnable(true)
    end
  end
  RefreshOptimizationEnable()
  local events = {
    UPDATE_HIDE_OPTIMIZATION_BUTTON = function()
      button:Show(X2Option:GetOptionItemValue(OPTION_ITEM_HIDE_OPTIMIZATION_BUTTON) == 0)
      button:Update()
    end,
    LEFT_LOADING = function()
      RefreshOptimizationEnable()
    end
  }
  button:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(button, events)
  return button
end
optimizationToggleButton = CreateOptimizationToggleButton("optimizationToggleButton", baseWnd)
optimizationToggleButton:Show(X2Option:GetOptionItemValue(OPTION_ITEM_HIDE_OPTIMIZATION_BUTTON) == 0)
local requestMainHudBattleFieldToggleBtn = CreateRequestBattleFieldToggleBtn("requestMainHudBattleFieldToggleBtn", baseWnd)
requestMainHudBattleFieldToggleBtn:AddAnchor("RIGHT", optimizationToggleButton, "LEFT", 0, 0)
requestMainHudBattleFieldToggleBtn.CheckEnabled()
UIParent:SetEventHandler("LEFT_LOADING", requestMainHudBattleFieldToggleBtn.CheckEnabled)
local function UpdatePermission()
  if premiumServiceToggleButton then
    premiumServiceToggleButton:Show(UIParent:GetPermission(UIC_PREMIUM))
  end
  if convenienceBtn then
    local permission = true
    if convenienceBtn.auctionToggleBtn and permission then
      permission = UIParent:GetPermission(UIC_AUCTION)
    end
    permission = permission and UIParent:GetPermission(UIC_COMMERCIAL_MAIL)
    if convenienceBtn.mailBoxToggleBtn ~= nil and permission then
      permission = UIParent:GetPermission(UIC_MAIL)
    end
    convenienceBtn:Show(permission)
  end
  if requestMainHudBattleFieldToggleBtn then
    requestMainHudBattleFieldToggleBtn:Show(UIParent:GetPermission(UIC_REQUEST_BATTLEFILED))
  end
  if eventCenterToggleButton then
    eventCenterToggleButton:Show(UIParent:GetPermission(UIC_EVENT_CENTER))
  end
  if ingameshopToggleButton then
    ingameshopToggleButton:Show(UIParent:GetPermission(UIC_INGAME_SHOP))
  end
end
UpdatePermission()
UIParent:SetEventHandler("UI_PERMISSION_UPDATE", UpdatePermission)
