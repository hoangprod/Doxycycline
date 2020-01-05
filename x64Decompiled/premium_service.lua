local premiumServiceFrame
function CreatePremiumServiceFrame(id, parent)
  local wnd = SetViewOfPremiumServiceFrame(id, parent)
  return wnd
end
function CreateGradeUpDownFrame(id, parent)
  local gradeWnd = SetViewOfGradeUpDownFrame(id, parent)
  return gradeWnd
end
function IsActivatedPremiumService()
  return premiumServiceFrame ~= nil and premiumServiceFrame:IsVisible()
end
function TogglePremiumService()
  local show = not premiumServiceFrame:IsVisible()
  if show then
    local screenState = X2Player:GetUIScreenState()
    if screenState ~= SCREEN_CHARACTER_SELECT and screenState ~= SCREEN_WORLD then
      return false
    end
    X2Player:RequestRefreshCash()
    PremiumResultWaitPage(true)
    if X2PremiumService:RequestPremiumServiceList() == false then
      PremiumResultWaitPage(false)
      InsertPremiumServiceData(premiumServiceFrame.tab.service)
      if premiumServiceLocale.firstPremiumServiceBuy and X2PremiumService:GetPremiumBuyCount() == 0 then
        CallFirstPremiumBuyBonusDialog()
      end
    end
    UpdateExchangeRatio(premiumServiceFrame.tab.service)
    premiumServiceFrame:SetHeight(premiumServiceFrame:GetContentHeight() + 10 + premiumServiceLocale.progressBarOffsetY)
  end
  premiumServiceFrame:Show(show)
  X2PremiumService:SetVisiblePremiumService(show)
end
function PremiumResultWaitPage(isShow)
  if isShow == false then
    if not X2PremiumService:IsPremiumSeviceListRequested() then
      premiumServiceFrame:WaitPage(isShow)
      premiumServiceFrame:SetCloseOnEscape(true)
    end
  else
    premiumServiceFrame:WaitPage(isShow)
    premiumServiceFrame:SetCloseOnEscape(false)
  end
end
local SetViewOfPremiumServiceButton = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local premiumButton = parent:CreateChildWidget("button", id, 0, true)
  premiumButton:AddAnchor("TOP", parent, 0, sideMargin / 2 + 90)
  ApplyButtonSkin(premiumButton, BUTTON_STYLE.PREMIUM_BUY_IN_CHAR_SEL_PAGE)
  return premiumButton
end
function CreateSelectCharPremiumServiceButton(id, parent)
  local button = SetViewOfPremiumServiceButton(id, parent)
  local LeftButtonCLickFunc = function()
    TogglePremiumService()
  end
  ButtonOnClickHandler(button, LeftButtonCLickFunc)
  local OnScale = function(self)
    self:RemoveAllAnchors()
    self:AddAnchor("BOTTOMRIGHT", "UIParent", BUTTON_OFFSET.PREMIUM_SERVICE.X, BUTTON_OFFSET.PREMIUM_SERVICE.Y)
  end
  button:SetHandler("OnScale", OnScale)
  return button
end
function CreatePremiumService(parent)
  premiumServiceToggleButton = CreateSelectCharPremiumServiceButton("premiumServiceToggleButton", parent)
  premiumServiceToggleButton:Show(true)
  return premiumServiceToggleButton
end
premiumServiceFrame = CreatePremiumServiceFrame("premiumServiceFrame", "UIParent")
premiumServiceFrame:Show(false)
ADDON:RegisterContentWidget(UIC_PREMIUM, premiumServiceFrame)
premiumServiceFrame.tab.service = premiumServiceFrame.tab.window[1]
gradeUpDownFrame = CreateGradeUpDownFrame("gradeUpDownFrame", "UIParent")
gradeUpDownFrame:Show(false)
premiumServiceFrame.aapointBuyFrame = GetAAPointBuyFrame()
local premiumServiceEvents = {
  PREMIUM_POINT_CHANGE = function()
    if premiumServiceFrame.progressbar ~= nil then
      SetProgressValue(X2PremiumService:GetPremiumPoint())
    end
  end,
  PREMIUM_GRADE_CHANGE = function(prevPremiumGrade, presentPremiumGrade)
    if premiumServiceFrame.progressbar ~= nil then
      ViewUpDownGrade(prevPremiumGrade, presentPremiumGrade)
      gradeUpDownFrame:Show(true)
    end
    if premiumServiceToggleButton ~= nil then
      premiumServiceToggleButton:PremiumGradeChageToggle()
    end
  end,
  UPDATE_INGAME_SHOP = function(arg1, arg2, arg3, arg4)
    if arg1 == "money" then
      UpdateBuyMoneyView(premiumServiceFrame.tab.service)
    elseif arg1 == "checkTime" then
      X2PremiumService:ClearPremiumServiceList()
      InsertPremiumServiceData(premiumServiceFrame.tab.service)
    elseif arg1 == "exchange_ratio" then
      UpdateExchangeRatio(premiumServiceFrame.tab.service)
    end
  end,
  PLAYER_AA_POINT = function(change, changeStr, itemTaskType, tradeOtherName)
    UpdateBuyMoneyView(premiumServiceFrame.tab.service)
  end,
  CHANGE_PAY_INFO = function()
    if premiumServiceFrame.endtimelabel ~= nil then
      premiumServiceFrame.endtimelabel:OnUpdate()
    end
    if premiumServiceToggleButton ~= nil then
      premiumServiceToggleButton:PremiumGradeChageToggle()
    end
  end,
  VIEW_CASH_BUY_WINDOW = function(sellType)
    if sellType == 0 then
      RequestCashCharge(premiumServiceFrame)
    elseif premiumServiceFrame.aapointBuyFrame ~= nil then
      premiumServiceFrame.aapointBuyFrame.ShowAAPointBuyFrame(premiumServiceFrame)
    end
  end,
  PREMIUM_SERVICE_LIST_UPDATED = function()
    PremiumResultWaitPage(false)
    InsertPremiumServiceData(premiumServiceFrame.tab.service)
    UpdateBuyMoneyView(premiumServiceFrame.tab.service)
  end,
  PREMIUM_FIRST_BUY_BONUS = function()
    if premiumServiceLocale.firstPremiumServiceBuy and X2PremiumService:GetPremiumBuyCount() == 0 then
      CallFirstPremiumBuyBonusDialog()
    end
  end,
  PREMIUM_SERVICE_BUY_RESULT = function(err)
    ShowPremiumServiceBuyResult(err)
  end
}
premiumServiceFrame:SetHandler("OnEvent", function(this, event, ...)
  premiumServiceEvents[event](...)
end)
RegistUIEvent(premiumServiceFrame, premiumServiceEvents)
