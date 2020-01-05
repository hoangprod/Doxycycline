housing = {}
housing.eventListener = UIParent:CreateWidget("emptywidget", "housing.eventListener", "UIParent")
housing.eventListener:Show(false)
housing.materialWindow = nil
housing.maintainWindow = nil
housing.buildWindow = nil
housing.rebuilingWnd = nil
housing.uccRegisterWindow = nil
HOUSING_UCC_TAB = {APPLY_UCC = 1, REVERT_UCC = 2}
HOUSING_UCC_POSITION = {
  [HOUSING_UCC_POS_WALL] = {
    text = GetUIText(HOUSING_TEXT, "housing_ucc_wall")
  },
  [HOUSING_UCC_POS_FLOOR] = {
    text = GetUIText(HOUSING_TEXT, "housing_ucc_floor")
  },
  [HOUSING_UCC_POS_TOP] = {
    text = GetUIText(HOUSING_TEXT, "housing_ucc_top")
  },
  [HOUSING_UCC_POS_WALL_OUTDOOR] = {
    text = GetUIText(HOUSING_TEXT, "housing_ucc_outdoor")
  },
  [HOUSING_UCC_POS_ROOF] = {
    text = GetUIText(HOUSING_TEXT, "housing_ucc_roof")
  }
}
local housingInteractionEvents = {
  HOUSE_INTERACTION_START = function(structureType, viewType)
    if structureType == "housing" then
      if X2House:IsHouseUnderConstruction() then
        ShowMaterialWindow(true)
        if X2House:IsCastle() == true then
          UpdateHousingMaterialInfo()
        end
      else
        ShowHousingMainTainWindow(true)
        if housing.uccRegisterWindow ~= nil and housing.uccRegisterWindow:IsVisible() then
          ShowUccRegisterWindow()
        end
        if not X2House:IsMyHouse() then
          UpdateHouseDefaultInfo()
        else
          UpdateMyHouseDefaultInfo()
        end
        UpdateMaintainWindowHeight()
        if X2House:IsCastle() then
          viewType = "castle"
        end
        UpdateDecoImage(viewType)
      end
    else
      ShowMaterialWindow(true)
      UpdateShipyardMaterialInfo()
    end
  end,
  HOUSE_INTERACTION_END = function()
    ShowHousingMainTainWindow(false)
    ShowMaterialWindow(false)
    if housing.uccRegisterWindow ~= nil and housing.uccRegisterWindow:IsVisible() then
      ShowUccRegisterWindow()
    end
  end,
  HOUSE_TAX_INFO = function(dominionTaxRate, hostileTaxRate, taxString, dueTime, prepayTime, weeksWithoutPay, weeksPrepay, isAlreadyPaid, isHeavyTaxHouse, depositString, taxItemType)
    if X2House:IsHouseUnderConstruction() == false then
      if housing.maintainWindow ~= nil then
        if X2House:IsMyHouse() then
          UpdateMyHouseTaxInfo(dominionTaxRate, hostileTaxRate, taxString, dueTime, prepayTime, weeksWithoutPay, weeksPrepay, isAlreadyPaid, isHeavyTaxHouse, depositString, taxItemType)
        else
          UpdateHouseTaxInfo(dominionTaxRate, hostileTaxRate, dueTime, weeksWithoutPay)
        end
        UpdateMaintainWindowHeight()
      end
    elseif housing.materialWindow ~= nil then
      UpdateHousingMaterialInfo(taxString, dueTime, weeksWithoutPay, isAlreadyPaid, depositString, taxItemType)
    end
  end,
  UNIT_NAME_CHANGED = function()
    if housing.maintainWindow then
      if housing.maintainWindow.setUpperStr ~= nil then
        housing.maintainWindow:setUpperStr()
      end
      X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.housing.msg_house_change_name)
    end
  end,
  HOUSE_STEP_INFO_UPDATED = function(structureType)
    if housing.materialWindow ~= nil then
      housing.materialWindow:UpdateStepInfo(structureType)
    end
  end,
  BUILDER_END = function()
    ShowBuildWindow()
  end,
  HOUSE_BUILD_INFO = function(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType, completion)
    ShowBuildWindow(hType, bTax, hTax, heavyTaxHouseCount, normalTaxHouseCount, isHeavyTaxHouse, hostileTaxRate, depositString, taxItemType, completion)
  end,
  CHANGE_ACTABILITY_DECO_NUM = function()
    if housing.maintainWindow == nil then
      return
    end
    if housing.maintainWindow.decoActabilitywindow == nil then
      return
    end
    if not housing.maintainWindow.decoActabilitywindow:IsVisible() then
      return
    end
    housing.maintainWindow.decoActabilitywindow:FillList()
  end,
  HOUSE_DECO_UPDATED = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    UpdateFurnitureCount()
  end,
  HOUSE_PERMISSION_UPDATED = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    if X2House:IsMyHouse() then
      return
    end
    UpdateHouseDefaultInfo()
  end,
  HOUSE_SET_SELL_SUCCESS = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    if housing.maintainWindow.sellRegisterWindow == nil then
      return
    end
    if not housing.maintainWindow.sellRegisterWindow:IsVisible() then
      return
    end
    housing.maintainWindow.sellRegisterWindow:Show(false)
  end,
  HOUSE_CANCEL_SELL_SUCCESS = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    if housing.maintainWindow.sellRegisterWindow == nil then
      return
    end
    if not housing.maintainWindow.sellRegisterWindow:IsVisible() then
      return
    end
    housing.maintainWindow.sellRegisterWindow:Show(false)
  end,
  HOUSE_SET_SELL_FAIL = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    if housing.maintainWindow.sellRegisterWindow == nil then
      return
    end
    if not housing.maintainWindow.sellRegisterWindow:IsVisible() then
      return
    end
    if housing.maintainWindow.sellRegisterWindow.nameEditbox:IsEnabled() then
      housing.maintainWindow.sellRegisterWindow.nameEditbox:SetText("")
    end
  end,
  HOUSE_BUY_SUCCESS = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    UpdateMyHouseDefaultInfo()
  end,
  HOUSE_SALE_SUCCESS = function(houseName)
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    if housing.maintainWindow.sellRegisterWindow == nil then
      return
    end
    if not housing.maintainWindow.sellRegisterWindow:IsVisible() then
      return
    end
    housing.maintainWindow.sellRegisterWindow:Show(false)
  end,
  HOUSE_INFO_UPDATED = function()
    if housing.maintainWindow == nil then
      return
    end
    if not housing.maintainWindow:IsVisible() then
      return
    end
    UpdateSellInfo()
    UpdateRebuildInfo()
  end,
  DOMINION_SIEGE_PERIOD_CHANGED = function()
    if not X2House:IsMyHouse() or not X2House:IsCastle() then
      return
    end
    if housing.materialWindow and housing.materialWindow:IsVisible() then
      UpdateHousingMaterialInfo()
    end
    if housing.maintainWindow and housing.maintainWindow:IsVisible() then
      UpdateMyHouseDefaultInfo()
    end
  end,
  HOUSE_ROTATE_CONFIRM = function()
    local info, count, total = X2House:GetRequireItemInfoForRotate()
    if info == nil then
      return
    end
    local function DialogHandler(wnd)
      wnd:SetTitle(GetUIText(HOUSING_TEXT, "housing_rotate_title"))
      wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "housing_rotation_content"))
      local data = {
        itemInfo = info,
        stack = {count, total}
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
      function wnd:OkProc()
        X2House:RotateHouse()
        self:Show(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "")
  end
}
housing.eventListener:SetHandler("OnEvent", function(this, event, ...)
  housingInteractionEvents[event](...)
end)
RegistUIEvent(housing.eventListener, housingInteractionEvents)
