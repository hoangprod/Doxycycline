local titleMargin, sideMargin, bottomMargin = GetWindowMargin()
local vignettingWidget = CreateEmptyWindow("vignettingWidget", "UIParent")
vignettingWidget:SetUILayer("game")
vignettingWidget:Show(false)
local customizingMenu = CreateCustomizingMenuWnd("customizingMenu", "UIParent")
customizingMenu:AddAnchor("LEFT", "UIParent", 0, 0)
customizingMenu:Show(false)
local customizingContent = CreateCustomizingContentWnd("customizingContent", "UIParent")
customizingContent:AddAnchor("RIGHT", "UIParent", -10, 0)
customizingContent:Show(false)
customizingMenu:SetContentWnd(customizingContent)
customizingContent:SetMenuWnd(customizingMenu)
local bgLeft = vignettingWidget:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "bg_left", "background")
bgLeft:AddAnchor("TOPLEFT", "UIParent", 0, 0)
bgLeft:AddAnchor("BOTTOMLEFT", "UIParent", 0, 0)
vignettingWidget.bgLeft = bgLeft
local bgRight = vignettingWidget:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "bg_right", "background")
bgRight:AddAnchor("TOPRIGHT", "UIParent", 0, 0)
bgRight:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
vignettingWidget.bgRight = bgRight
function vignettingWidget.OnScale()
  vignettingWidget.bgLeft:RemoveAllAnchors()
  vignettingWidget.bgRight:RemoveAllAnchors()
  vignettingWidget.bgLeft:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  vignettingWidget.bgLeft:AddAnchor("BOTTOMLEFT", "UIParent", 0, 0)
  vignettingWidget.bgRight:AddAnchor("TOPRIGHT", "UIParent", 0, 0)
  vignettingWidget.bgRight:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
end
vignettingWidget:SetHandler("OnScale", vignettingWidget.OnScale)
function UpdateCreateCustomizingUI(show)
  customizingMenu:Show(show, 500)
  customizingContent:Show(show, 500)
  vignettingWidget:Show(show, 500)
  if show then
    local customizingUnit, race, gender = X2LoginCharacter:GetCustomizingUnit()
    if customizingUnit ~= nil then
      customizingMenu:ApplyRaceGender(race, gender)
      customizingContent:ApplyRaceGender(race, gender)
      customizingContent:RemoveAllAnchors()
      customizingContent:AddAnchor("RIGHT", "UIParent", -10, 0)
    end
    customizingMenu:SelectCustomizingType(RECOMMAND_MENU_TYPE)
    if CUSTOMIZING_FUNCTIONAL_INFO[DRESS_PRESET_TYPE] ~= nil then
      local count = CUSTOMIZING_FUNCTIONAL_INFO[DRESS_PRESET_TYPE].getCountFunc()
      if count > 0 then
        CUSTOMIZING_FUNCTIONAL_INFO[DRESS_PRESET_TYPE].setFunc(1)
      end
    end
  else
    customizingMenu:CleanUp()
  end
end
function RefreshCustomizingContentUI()
  customizingContent:RefreshUI()
end
