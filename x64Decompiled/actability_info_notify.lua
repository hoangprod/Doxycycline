local actabilityInfoNotifier
local IS_LANGUAGE = false
local function CreateActabilityInfoNotifyWnd(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:AddAnchor("RIGHT", parent, -300, 0)
  window:SetExtent(POPUP_WINDOW_WIDTH, 240)
  window:SetTitle(X2Locale:LocalizeUiText(SKILL_TEXT, "actability_notify_title"))
  local icon_bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
  icon_bg:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local icon = window:CreateIconImageDrawable("Textures/Defaults/White.dds", "artwork")
  icon:SetColor(1, 1, 1, 1)
  icon:SetCoords(0, 0, 128, 128)
  icon:SetExtent(40, 40)
  icon:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  icon:ClearAllTextures()
  window.icon = icon
  icon_bg:AddAnchor("CENTER", icon, 0, 0)
  local actabilityValue = window:CreateChildWidget("textbox", "actabilityValue", 0, true)
  actabilityValue:SetExtent(265, FONT_SIZE.LARGE)
  actabilityValue:AddAnchor("BOTTOMLEFT", icon, "BOTTOMRIGHT", 5, -1)
  actabilityValue.style:SetFontSize(FONT_SIZE.LARGE)
  actabilityValue.style:SetAlign(ALIGN_LEFT)
  local gradeIcon = CreateActabilityGradeIconWidget("gradeIcon", window, FONT_SIZE.LARGE)
  gradeIcon:AddAnchor("BOTTOMLEFT", actabilityValue, "TOPLEFT", 1, -1)
  window.gradeIcon = gradeIcon
  local upgradeInfo = window:CreateChildWidget("textbox", "upgradeInfo", 0, true)
  upgradeInfo:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH)
  upgradeInfo.style:SetFontSize(FONT_SIZE.LARGE)
  upgradeInfo:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  ApplyTextColor(upgradeInfo, FONT_COLOR.DEFAULT)
  upgradeInfo:AddAnchor("TOP", window, 0, 115)
  local gradeInfoDesc = window:CreateChildWidget("textbox", "gradeInfoDesc", 0, true)
  gradeInfoDesc:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH)
  gradeInfoDesc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  ApplyTextColor(gradeInfoDesc, FONT_COLOR.DEFAULT)
  gradeInfoDesc:AddAnchor("TOPLEFT", upgradeInfo, "BOTTOMLEFT", 0, sideMargin * 1.2)
  local tip = window:CreateChildWidget("label", "tip", 0, true)
  tip:SetAutoResize(true)
  tip:SetHeight(FONT_SIZE.MIDDLE)
  tip:AddAnchor("TOP", gradeInfoDesc, "BOTTOM", 0, sideMargin / 1.5)
  tip:SetText(X2Locale:LocalizeUiText(SKILL_TEXT, "must_condition_for_upgrade"))
  ApplyTextColor(tip, FONT_COLOR.RED)
  local bg = CreateContentBackground(upgradeInfo, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", upgradeInfo, -5, -15)
  bg:AddAnchor("BOTTOMRIGHT", upgradeInfo, 5, 15)
  local openSkillWndBtn = window:CreateChildWidget("button", "openSkillWndBtn", 0, true)
  openSkillWndBtn:SetText(locale.skill.openSkillWindow)
  openSkillWndBtn:AddAnchor("BOTTOMLEFT", window, sideMargin, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(openSkillWndBtn, BUTTON_BASIC.DEFAULT)
  local function OpenSkillWndBtnLeftClickFunc()
    window:Show(false)
    datas = {
      selectIdx = SKILL_WND_TAB.ACTABILIBY.index
    }
    ADDON:ShowContent(UIC_SKILL, true, datas)
  end
  ButtonOnClickHandler(openSkillWndBtn, OpenSkillWndBtnLeftClickFunc)
  local okBtn = window:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:SetText(locale.common.ok)
  okBtn:AddAnchor("BOTTOMRIGHT", window, -sideMargin, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  local function OkBtnLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(okBtn, OkBtnLeftClickFunc)
  local buttonTable = {openSkillWndBtn, okBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  function window:FillActabilityInfo(info, maxAbilityPoint, iconPath, isLanguage)
    local gradeInfo = X2Ability:GetGradeInfo(info.grade)
    local upgradeable = X2Ability:CanUpgradeExpert(info.type)
    local hexColor = GetHexColorForString(gradeInfo.colorString)
    self.icon:AddTexture(iconPath)
    self.gradeIcon:SetGradeInfo(info.grade, info.name, gradeInfo.colorString)
    local defaultStr = string.format("|,%d;/|,%d;", info.point, maxAbilityPoint)
    local color = Hex2Dec(gradeInfo.colorString)
    ApplyTextColor(self.actabilityValue, color)
    self.actabilityValue:SetText(defaultStr)
    if isLanguage then
      local upgradeStr = locale.skill.actability.unable_upgrade_actability_max_grade(hexColor, info.point)
      self.upgradeInfo:SetText(upgradeStr)
      self.tip:Show(false)
      self.gradeInfoDesc:Show(false)
    else
      if upgradeable then
        local upgradeStr = locale.skill.actability.able_upgrade_actability(hexColor, info.point)
        self.upgradeInfo:SetText(upgradeStr)
      elseif info.grade == X2Ability:GetMaxGrade() then
        local upgradeStr = locale.skill.actability.unable_upgrade_actability_max_grade(hexColor, info.point)
        self.upgradeInfo:SetText(upgradeStr)
      else
        local upgradeStr = locale.skill.actability.unable_upgrade_actability(hexColor, info.point)
        self.upgradeInfo:SetText(upgradeStr)
      end
      self.tip:Show(upgradeable)
      local prevGradeInfo = X2Ability:GetGradeInfo(info.grade - 1)
      if info.grade - 1 < 0 then
        prevGradeInfo = {}
        prevGradeInfo.advantage = 0
        prevGradeInfo.castAdvantage = 0
        prevGradeInfo.expMul = 0
      end
      local function GetValue(value1, value2)
        return GetUIText(COMMON_TEXT, "percent_to_percent", FONT_COLOR_HEX.DEFAULT, tostring(value1), hexColor, tostring(value2))
      end
      local str = string.format([[
%s %s
%s %s
%s %s]], GetUIText(COMMON_TEXT, "livelihood_exp_increase"), GetValue(prevGradeInfo.expMul, gradeInfo.expMul), GetUIText(COMMON_TEXT, "use_labor_power_decrease"), GetValue(prevGradeInfo.advantage, gradeInfo.advantage), GetUIText(COMMON_TEXT, "casting_time_decrease"), GetValue(prevGradeInfo.castAdvantage, gradeInfo.castAdvantage))
      self.gradeInfoDesc:SetText(str)
      self.gradeInfoDesc:Show(true)
    end
    self.upgradeInfo:SetHeight(self.upgradeInfo:GetTextHeight())
    self.gradeInfoDesc:SetHeight(self.gradeInfoDesc:GetTextHeight())
    local GetHeight = function(widget)
      if widget:IsVisible() then
        return widget:GetHeight()
      else
        return 0
      end
    end
    local function SetHeight(isLanguage)
      local height = titleMargin + icon:GetHeight() + bg:GetHeight() + openSkillWndBtn:GetHeight() + GetHeight(gradeInfoDesc) + GetHeight(tip)
      if isLanguage then
        height = height + sideMargin * 2
      else
        height = height + sideMargin * 3.5
      end
      window:SetHeight(height)
    end
    SetHeight(isLanguage)
  end
  local function OnHide()
    actabilityInfoNotifier = nil
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
local function ShowActabilityInfoNotifyWnd()
  if actabilityInfoNotifier == nil then
    actabilityInfoNotifier = CreateActabilityInfoNotifyWnd("actabilityInfoNotifier", "UIParent")
    actabilityInfoNotifier:EnableHidingIsRemove(true)
    ADDON:RegisterContentWidget(UIC_NOTIFY_ACTABILITY, actabilityInfoNotifier)
  end
  actabilityInfoNotifier:Show(true)
end
local function ActabilityExpertChanged(actabilityId)
  local info = X2Ability:GetMyActabilityInfo(actabilityId)
  local maxAbilityPoint = X2Ability:GetMaxActabilityPoint(info.type)
  if info.point ~= maxAbilityPoint then
    return
  end
  local info2 = X2Craft:GetActabilityGroupInfoByGroupType(actabilityId)
  ShowActabilityInfoNotifyWnd()
  IS_LANGUAGE = X2Ability:IsLanguageActability(actabilityId)
  actabilityInfoNotifier:FillActabilityInfo(info, maxAbilityPoint, info2.icon_path, X2Ability:IsLanguageActability(actabilityId))
end
UIParent:SetEventHandler("ACTABILITY_EXPERT_CHANGED", ActabilityExpertChanged)
