function CreateAccountInfoWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local premiumGrade = wnd:CreateChildWidget("label", "premiumGrade", 0, true)
  premiumGrade:SetHeight(FONT_SIZE.XLARGE)
  premiumGrade:SetAutoResize(true)
  premiumGrade:AddAnchor("TOP", wnd, 0, 20)
  ApplyTextColor(premiumGrade, FONT_COLOR.SOFT_YELLOW)
  premiumGrade.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  premiumGrade.style:SetAlign(ALIGN_CENTER)
  local bg = wnd:CreateDrawable(SELECT_TEXTURE, "grade_bg", "background")
  bg:AddAnchor("CENTER", wnd, 0, 0)
  local bmMileage = wnd:CreateChildWidget("textbox", "bmMileage", 0, true)
  bmMileage:SetHeight(FONT_SIZE.LARGE)
  bmMileage:AddAnchor("BOTTOMRIGHT", wnd, -20, -20)
  ApplyTextColor(bmMileage, FONT_COLOR.SOFT_YELLOW)
  bmMileage.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  bmMileage.style:SetAlign(ALIGN_LEFT)
  local laborpower = wnd:CreateChildWidget("textbox", "laborpower", 0, true)
  laborpower:SetHeight(FONT_SIZE.LARGE)
  laborpower:AddAnchor("BOTTOMLEFT", wnd, 20, -20)
  ApplyTextColor(laborpower, FONT_COLOR.SOFT_YELLOW)
  laborpower.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  laborpower.style:SetAlign(ALIGN_LEFT)
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.buyPremiuminSelChar then
    local buyPremiumServiceBtn = wnd:CreateChildWidget("button", "buyPremiumServiceBtn", 0, true)
    buyPremiumServiceBtn:AddAnchor("TOP", wnd, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
    ApplyButtonSkin(buyPremiumServiceBtn, BUTTON_STYLE.PREMIUM_BUY_IN_CHAR_SEL_PAGE)
    local LeftButtonClickFunc = function()
      TogglePremiumService()
    end
    ButtonOnClickHandler(buyPremiumServiceBtn, LeftButtonClickFunc)
  end
  function wnd:Update()
    local grade = 0
    local lp = 0
    local maxLp = 0
    local mileage = 0
    local isPremiumService = X2PremiumService:IsPremiumService()
    local charCount = X2LoginCharacter:GetNumLoginCharacters()
    if charCount ~= 0 then
      grade = X2LoginCharacter:GetLoginCharacterPremiumGrade(1)
      lp = X2LoginCharacter:GetLoginCharacterLaborPower(1)
      maxLp = X2LoginCharacter:GetLoginCharacterMaxLaborPower(1)
      mileage = X2LoginCharacter:GetLoginCharacterBmPoint(1)
    end
    if X2World:IsB2PService() == true or grade == PG_PREMIUM_0 or isPremiumService == false then
      premiumGrade:SetText("")
      premiumGrade:Show(false)
    else
      if baselibLocale.premiumService.usePremiumGrade then
        premiumGrade:SetText(locale.premium.premium_grade_num(tostring(grade - 1)))
      else
        premiumGrade:SetText(GetUIText(PREMIUM_TEXT, "premium_service"))
      end
      premiumGrade:Show(true)
    end
    if X2Player:GetFeatureSet().bm_mileage then
      bmMileage:Show(true)
      bmMileage:SetWidth(500)
      bmMileage:SetText(string.format("%s: |bm%s;", locale.bmmileage.bmmileage, tostring(mileage)))
      bmMileage:SetWidth(bmMileage:GetLongestLineWidth() + 20)
    else
      bmMileage:Show(false)
      bmMileage:SetWidth(0)
    end
    local laborText
    local maxLocalLp = X2Player:GetMaxLocalLaborPower()
    if maxLocalLp > 0 then
      local localLp = X2LoginCharacter:GetLoginCharacterLocalLaborPower(1) or 0
      laborText = string.format("%s: |,%d; (|,%d; + %s|,%d;|r)", locale.attribute("labor_power"), lp + localLp, lp, F_COLOR.GetColor("light_green", true), localLp)
    else
      laborText = string.format("%s: %d/%d", locale.attribute("labor_power"), lp, maxLp)
    end
    laborpower:SetWidth(500)
    laborpower:SetText(laborText)
    laborpower:SetWidth(laborpower:GetLongestLineWidth() + 20)
    local width = math.max(premiumGrade:GetWidth(), bmMileage:GetWidth() + laborpower:GetWidth()) + 40
    local height = (premiumGrade:IsVisible() and premiumGrade:GetHeight() + 10 or 0) + laborpower:GetHeight() + 40
    wnd:SetExtent(width, height)
  end
  local function LaborpowerLabelOnEnter(self)
    local str = locale.characterSelect.laborPowerTip(F_COLOR.GetColor("original_dark_orange", true))
    SetLoingStageTargetAnchorTooltip(str, "TOP", wnd, "BOTTOM", 0, 0)
  end
  wnd:SetHandler("OnEnter", LaborpowerLabelOnEnter)
  return wnd
end
