local sideMargin, titleMargin, bottomMargin = GetWindowMargin("popup")
local ShowTaxations = function(listCtrlFrame, taxRate)
  listCtrlFrame:DeleteAllDatas()
  local taxations = X2House:GetTaxations(taxRate)
  local index = 1
  for i = 1, #taxations do
    if i % 2 ~= 0 then
      listCtrlFrame:InsertData(index, 1, taxations[i])
    else
      listCtrlFrame:InsertData(index, 2, taxations[i])
      index = index + 1
    end
  end
end
local function FillTerritoryInfo()
  local expeditionName = X2Dominion:GetOwnerFactionName(territoryFrame.zoneGroup)
  local ownerName = X2Dominion:GetOwnerPlayerName(territoryFrame.zoneGroup)
  local dateFormat = X2Dominion:GetReignStartDate(territoryFrame.zoneGroup)
  local moneyString = X2Dominion:GetPeaceTaxMoney(territoryFrame.zoneGroup)
  local aaPointString = X2Dominion:GetPeaceTaxAAPoint(territoryFrame.zoneGroup)
  local isTaxationWithoutMyExpedition = X2Dominion:IsTaxationWithoutMyExpedition(territoryFrame.zoneGroup)
  local taxRate = X2Dominion:GetTaxRate(territoryFrame.zoneGroup)
  territoryFrame.taxRate = taxRate
  local str = ""
  local ownershipStr = string.format("%s : %s", locale.territory.ownership, expeditionName)
  str = ownershipStr
  local lordStr = string.format("%s : %s", locale.territory.lord, ownerName)
  str = str .. "\n" .. lordStr
  local DATE_FORMAT_FILTER = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY
  local governPeriodStr = string.format("%s : %s~ %s", locale.territory.governPeriod, locale.time.GetDateToDateFormat(dateFormat, DATE_FORMAT_FILTER), locale.money.current)
  str = str .. "\n" .. governPeriodStr
  local nowPage = territoryFrame.tab.window[1]
  nowPage.defaultInfo:SetText(str)
  nowPage.defaultInfo:SetHeight(nowPage.defaultInfo:GetTextHeight())
  local isConvertTaxItemToAAPoint = X2House:IsConvertTaxItemToAAPoint()
  if F_MONEY.currency.houseTax == CURRENCY_GOLD and isConvertTaxItemToAAPoint == false then
    nowPage.peaceMoney:SetText(string.format(F_MONEY.currency.pipeString[F_MONEY.currency.houseTax], moneyString))
  else
    nowPage.peaceAAPoint:SetText(string.format(F_MONEY.currency.pipeString[CURRENCY_AA_POINT], aaPointString))
    nowPage.peaceMoney:SetText(string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], moneyString))
  end
  local taxRateStr = string.format("%s%%", taxRate)
  nowPage.currentTaxRate:SetText(taxRateStr)
  nowPage.taxRateSlider:SetValue(taxRate, false)
  if X2Dominion:IsDominionOwner(territoryFrame.zoneGroup) then
    nowPage.taxRateSlider:SetEnable(true)
    nowPage.leftButton:RemoveAllAnchors()
    nowPage.leftButton:AddAnchor("BOTTOM", nowPage, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, 0)
    nowPage.leftButton:SetText(locale.menu.apply)
    nowPage.leftButton:Enable(false)
    nowPage.rightButton:Show(true)
    ApplyTextColor(nowPage.minPercent, FONT_COLOR.DEFAULT)
    ApplyTextColor(nowPage.maxPercent, FONT_COLOR.DEFAULT)
    ApplyTextColor(nowPage.currentTaxRate, FONT_COLOR.BLUE)
    nowPage.currentTaxRate.bg:SetColor(ConvertColor(193), ConvertColor(205), ConvertColor(218), 0.5)
    territoryFrame:SetTitle(locale.territory.title)
    nowPage.taxRateWindow:SetTitleText(locale.territory.setTaxRate)
  else
    nowPage.taxRateSlider:SetEnable(false)
    nowPage.leftButton:RemoveAllAnchors()
    nowPage.leftButton:AddAnchor("BOTTOM", nowPage, 0, 0)
    nowPage.leftButton:SetText(locale.messageBoxBtnText.ok)
    nowPage.leftButton:Enable(true)
    nowPage.rightButton:Show(false)
    ApplyTextColor(nowPage.minPercent, FONT_COLOR.GRAY)
    ApplyTextColor(nowPage.maxPercent, FONT_COLOR.GRAY)
    ApplyTextColor(nowPage.currentTaxRate, FONT_COLOR.GRAY)
    nowPage.currentTaxRate.bg:SetColor(0.5, 0.5, 0.5, 0.5)
    territoryFrame:SetTitle(locale.territory.info)
    nowPage.taxRateWindow:SetTitleText(locale.territory.taxRate)
  end
  ShowTaxations(nowPage.taxationsFrame, taxRate)
end
function CreateTerritoryFrame(window)
  SetViewOfTerritoryFrame(window)
  local leftButton = window.leftButton
  local rightButton = window.rightButton
  local taxRateWindow = window.taxRateWindow
  local taxRateSlider = window.taxRateSlider
  local function OnClickLeftButton(self)
    if territoryFrame ~= nil then
      if territoryFrame.zoneGroup ~= nil and X2Dominion:IsDominionOwner(territoryFrame.zoneGroup) then
        local rate = taxRateSlider:GetValue("horz")
        X2Dominion:ChangeDominionTaxRate(territoryFrame.zoneGroup, rate)
      end
      territoryFrame:Show(not territoryFrame:IsVisible())
    end
  end
  ButtonOnClickHandler(leftButton, OnClickLeftButton)
  local OnEnterLeftButton = function(self)
    if self:IsEnabled() then
      return
    end
    SetTooltip(locale.nationMgr.equal_tax_rate_warning, self)
  end
  leftButton:SetHandler("OnEnter", OnEnterLeftButton)
  local OnLeaveLeftButton = function(self)
    if self:IsEnabled() then
      return
    end
    HideTooltip()
  end
  leftButton:SetHandler("OnLeave", OnLeaveLeftButton)
  local OnEnter = function(self)
    local info = X2House:GetTaxItem()
    SetTooltip(locale.territory.taxItemTip(FONT_COLOR_HEX.SOFT_YELLOW, info.name), self)
  end
  window.guideIcon:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  window.guideIcon:SetHandler("OnLeave", OnLeave)
  local function OnSliderChanged(self)
    local rate = math.floor(self:GetValue("horz"))
    self:SetValue(rate, false)
    local taxRateStr = string.format("%s%%", rate)
    window.currentTaxRate:SetText(taxRateStr)
    ShowTaxations(window.taxationsFrame, rate)
    leftButton:Enable(territoryFrame.taxRate ~= rate)
  end
  taxRateSlider:SetHandler("OnSliderChanged", OnSliderChanged)
  local OnClickRightButton = function()
    territoryFrame:Show(not territoryFrame:IsVisible())
  end
  ButtonOnClickHandler(rightButton, OnClickRightButton)
  function window:UpdateTerritoryInfo()
    FillTerritoryInfo()
  end
  return window
end
