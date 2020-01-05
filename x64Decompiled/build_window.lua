function ShowBuildWindow(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType, completion)
  if housing.buildWindow == nil then
    if hType == nil then
      return
    end
    housing.buildWindow = CreateHousingBuildWindow("housing.buildWindow", "UIParent")
    housing.buildWindow:Show(true)
    housing.buildWindow:SetInfo(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType, completion)
    housing.buildWindow:SetWndHeight()
    function housing.buildWindow:OnHide()
      if housing.buildWindow.buildOk then
        X2House:NextStepFromBuildCheck()
      else
        X2House:PrevStepFromBuildCheck()
      end
      housing.buildWindow = nil
    end
    housing.buildWindow:SetHandler("OnHide", housing.buildWindow.OnHide)
  else
    housing.buildWindow:Show(false)
  end
end
