function ShowMaterialWindow(show)
  if show == true and housing.materialWindow == nil then
    housing.materialWindow = CreateHousingMaterialWindow("housing.materialWindow", "UIParent")
    housing.materialWindow:Show(false)
    housing.materialWindow:SetCloseOnEscape(true)
  else
    if housing.materialWindow ~= nil then
      housing.materialWindow:Show(false)
    end
    return
  end
  function housing.materialWindow.demolishImgButton:OnClick()
    local DialogHandler = function(wnd)
      wnd:SetExtent(353, 272)
      wnd:SetTitle(locale.housing.demolish.title)
      wnd:SetContent(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_description"))
      local cautionLabel = wnd:CreateChildWidget("label", "cautionLabel", 0, false)
      cautionLabel:SetExtent(297, FONT_SIZE.LARGE)
      cautionLabel:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_caution"))
      cautionLabel.style:SetFontSize(FONT_SIZE.LARGE)
      cautionLabel:AddAnchor("TOPLEFT", wnd.textbox, "BOTTOMLEFT", 8, 29)
      ApplyTextColor(cautionLabel, FONT_COLOR.DEFAULT)
      cautionLabel.style:SetAlign(ALIGN_LEFT)
      local cautionContent = wnd:CreateChildWidget("textbox", "cautionContent", 0, false)
      cautionContent:SetExtent(297, FONT_SIZE.MIDDLE)
      cautionContent.style:SetAlign(ALIGN_LEFT)
      cautionContent.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(cautionContent, FONT_COLOR.RED)
      cautionContent:SetText(X2Locale:LocalizeUiText(HOUSING_TEXT, "demolish_caution_description"))
      cautionContent:SetHeight(cautionContent:GetTextHeight())
      cautionContent:AddAnchor("TOPLEFT", cautionLabel, "BOTTOMLEFT", 0, 8)
      local bg = CreateContentBackground(wnd, "TYPE2", "brown", "artwork")
      bg:AddAnchor("TOPLEFT", cautionLabel, -13, -14)
      bg:AddAnchor("BOTTOMRIGHT", cautionContent, 13, 14)
      wnd:RegistBottomWidget(cautionContent)
      function wnd:OkProc()
        housing.materialWindow.demolishImgButton:GetParent():Show(false)
        X2House:Demolish(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, housing.materialWindow.demolishImgButton:GetParent():GetId())
  end
  housing.materialWindow.demolishImgButton:SetHandler("OnClick", housing.materialWindow.demolishImgButton.OnClick)
  local OnEnterDemolishImgButton = function(self)
    if self:IsEnabled() then
      ShowTextTooltip(self, nil, GetUIText(HOUSING_TEXT, "destroy"))
      return
    end
    if X2House:IsCastle() then
      SetTooltip(GetUIText(ERROR_MSG, "NO_PERM"), self)
    else
      ShowTextTooltip(self, nil, GetUIText(HOUSING_TEXT, "undemolishable_house_overdue"))
    end
  end
  housing.materialWindow.demolishImgButton:SetHandler("OnEnter", OnEnterDemolishImgButton)
  function housing.materialWindow.okButton:OnClick()
    if housing.materialWindow:IsVisible() then
      housing.materialWindow:Show(false)
    end
  end
  housing.materialWindow.okButton:SetHandler("OnClick", housing.materialWindow.okButton.OnClick)
  function housing.materialWindow:OnHide()
    housing.materialWindow = nil
  end
  housing.materialWindow:SetHandler("OnHide", housing.materialWindow.OnHide)
  function housing.materialWindow:UpdateStepInfo(structureType)
    local nowActions, totalActions, remainActions, constructionStep
    if structureType == "housing" then
      nowActions, totalActions, remainActions = GetHouseProgressInfo()
      constructionStep = X2House:GetHouseConstructionStepInfo()
    else
      nowActions, totalActions, remainActions = GetShipyardProgressInfo()
      constructionStep = X2House:GetShipyardConstructionStepInfo()
    end
    housing.materialWindow:UpdateProgressStepText(nowActions, totalActions, remainActions)
    housing.materialWindow:UpdateIconStepLabel(nowActions, constructionStep)
  end
end
local GetHouseOwnerName = function()
  return string.format("%s : %s", locale.housing.informationWindow.owner, X2House:GetHouseOwnerName())
end
local GetHouseFactionName = function()
  local zoneName = X2House:GetHouseZoneName() or ""
  if string.len(zoneName) > 0 then
    return string.format([[

%s: %s]], locale.housing.faction, zoneName)
  end
  return ""
end
local GetHouseTax = function(taxString)
  if not X2House:IsCastle() and taxString ~= nil then
    return string.format([[


%s: %s%s|r]], locale.housing.paymentTax, FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(taxString))
  end
  return ""
end
local GetPaymentCheckStr = function(defaultCount, payment)
  if payment ~= nil then
    if payment then
      return string.format([[

%s: %s[%s]|r]], locale.housing.checkPayment, FONT_COLOR_HEX.BLUE, locale.housing.payState.full)
    elseif defaultCount ~= nil and defaultCount > 0 then
      return string.format([[

%s: %s[%s]|r]], locale.housing.checkPayment, FONT_COLOR_HEX.RED, locale.housing.payState.overdue)
    else
      return string.format([[

%s: %s[%s]|r]], locale.housing.checkPayment, FONT_COLOR_HEX.RED, locale.housing.payState.unpaid)
    end
  end
  return ""
end
local GetRemainTimeStr = function(remainTable, defaultCount)
  if remainTable ~= nil then
    local dueStr = locale.time.GetDateToDateFormat(remainTable)
    local dueDateForPaymentStr = ""
    if defaultCount ~= nil and defaultCount > 0 then
      dueDateForPaymentStr = string.format("%s : %s%s%s|r", locale.housing.demolishDate, FONT_COLOR_HEX.RED, dueStr, locale.housing.untilTerm)
    else
      dueDateForPaymentStr = string.format("%s : %s%s", locale.housing.dueDateForPayment, dueStr, locale.housing.untilTerm)
    end
    return string.format([[

%s]], dueDateForPaymentStr)
  end
  return ""
end
local GetHouseTaxWarning = function(defaultCount)
  if defaultCount ~= nil and defaultCount > 0 then
    return string.format("%s%s", FONT_COLOR_HEX.RED, GetUIText(HOUSING_TEXT, "warning_default"))
  end
  return ""
end
function GetHouseProgressInfo()
  local remainActions = X2House:GetHouseRemainProgress()
  local totalActions = X2House:GetHouseBaseProgress()
  local nowActions = totalActions - remainActions
  return nowActions, totalActions, remainActions
end
function UpdateHousingMaterialInfo(taxString, remainTable, defaultCount, payment, depositString, taxItemType)
  local frontWidget = housing.materialWindow.housingInfo
  housing.materialWindow:SetTitle(GetUIText(COMMON_TEXT, "building"))
  local ownerName = GetHouseOwnerName()
  local factionName = GetHouseFactionName()
  frontWidget.line:SetVisible(not X2House:IsCastle())
  frontWidget.guideIcon:Show(not X2House:IsCastle())
  if depositString ~= nil and taxItemType ~= nil then
    frontWidget.guideIcon:FillInfo(taxItemType, X2House:CountTaxItemForTax(depositString))
  end
  local taxStr = GetHouseTax(taxString)
  local paymentStr = GetPaymentCheckStr(defaultCount, payment)
  local remainTimeStr = GetRemainTimeStr(remainTable, defaultCount)
  local contents = string.format("%s%s%s%s%s", ownerName, factionName, taxStr, paymentStr, remainTimeStr)
  housing.materialWindow:SetInfoText(contents)
  local warningContents = ""
  if X2House:IsSiegePeriod() then
    frontWidget = housing.materialWindow:ShowWarningText()
    warningContents = locale.housing.inSiegeWarning
  end
  local taxWarning = GetHouseTaxWarning(defaultCount)
  if taxWarning ~= "" then
    frontWidget = housing.materialWindow:ShowWarningText()
    if warningContents ~= "" then
      warningContents = string.format([[
%s

%s]], warningContents, taxWarning)
    else
      warningContents = taxWarning
    end
  end
  housing.materialWindow:SetWarningInfoText(warningContents)
  if warningContents == "" then
    housing.materialWindow:HideWarningText()
  end
  local nowActions, totalActions, remainActions = GetHouseProgressInfo()
  local stepLabelInfo = housing.materialWindow:UpdateProgressStep(frontWidget, nowActions, totalActions, remainActions)
  local constructionStep = X2House:GetHouseConstructionStepInfo()
  local lastIcon = housing.materialWindow:CreateMaterialIconPart(constructionStep)
  housing.materialWindow:UpdateIconStepLabel(nowActions, constructionStep)
  housing.materialWindow.demolishImgButton:Show(X2House:IsMyHouse())
  if defaultCount ~= nil and defaultCount > 0 then
    housing.materialWindow.demolishImgButton:Enable(false)
  elseif X2House:IsCastle() then
    if X2House:IsSiegePeriod() or X2House:IsWarmUpPeriod() then
      housing.materialWindow.demolishImgButton:Enable(false)
    else
      housing.materialWindow.demolishImgButton:Enable(true)
    end
  end
  housing.materialWindow:UpdateDescConsumeLaborPowerLabel(true)
  housing.materialWindow:UpdateWindowExtent(lastIcon)
end
local GetShipyardOwnerName = function()
  return string.format("%s : %s", locale.housing.informationWindow.owner, X2House:GetShipyardOwnerName())
end
local GetShipyardProtectionPeriod = function()
  local msec = X2House:GetShipyardProtectionPeriod()
  if msec == 0 then
    return string.format("%s", locale.housing.informationWindow.demolishDuration)
  end
  local time = FormatTime(msec)
  return string.format("%s : %s", locale.housing.informationWindow.invicibleDuration, time)
end
function GetShipyardProgressInfo()
  local remainActions = X2House:GetShipyardRemainProgress()
  local totalActions = X2House:GetShipyardBaseProgress()
  local nowActions = totalActions - remainActions
  return nowActions, totalActions, remainActions
end
function UpdateShipyardMaterialInfo()
  local frontWidget = housing.materialWindow.housingInfo
  housing.materialWindow:SetTitle(locale.housing.materialWindow.shipyard)
  local ownerName = GetShipyardOwnerName()
  local protectionPeriod = GetShipyardProtectionPeriod()
  housing.materialWindow:SetInfoText(ownerName)
  frontWidget = housing.materialWindow:ShowProtectionPeriod(protectionPeriod)
  local nowActions, totalActions, remainActions = GetShipyardProgressInfo()
  local stepLabelInfo = housing.materialWindow:UpdateProgressStep(frontWidget, nowActions, totalActions, remainActions)
  local constructionStep = X2House:GetShipyardConstructionStepInfo()
  local lastIcon = housing.materialWindow:CreateMaterialIconPart(constructionStep)
  housing.materialWindow:UpdateDescConsumeLaborPowerLabel(false)
  housing.materialWindow:UpdateIconStepLabel(nowActions, constructionStep)
  housing.materialWindow:UpdateWindowExtent(lastIcon)
  function frontWidget:OnEnter()
    SetTooltip(locale.housing.informationWindow.demolishDurationTooltip, self)
  end
  frontWidget:SetHandler("OnEnter", frontWidget.OnEnter)
  function frontWidget:OnLeave()
    HideTooltip()
  end
  frontWidget:SetHandler("OnLeave", frontWidget.OnLeave)
end
