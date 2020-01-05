local CreateGradeEnchantAlarmMessage = function(id, parent)
  local path = TEXTURE_PATH.GRADE_ENCHANT_ALARM
  local frame = CreateEmptyWindow(id, parent)
  frame:AddAnchor("TOP", parent, 0, 70)
  frame:SetSounds("dialog_common")
  SetttingUIAnimation(frame)
  local squareFrame = frame:CreateChildWidget("emptywidget", "squareFrame", 0, true)
  squareFrame:AddAnchor("TOPLEFT", frame, 0, 0)
  squareFrame:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local bg = squareFrame:CreateDrawable(path, "bg_paper", "background")
  bg:AddAnchor("CENTER", squareFrame, 0, 0)
  frame:SetExtent(bg:GetWidth(), bg:GetHeight() + 10)
  local stateTexture = squareFrame:CreateDrawable(path, "failure", "background")
  stateTexture:AddAnchor("TOP", squareFrame, 0, MARGIN.WINDOW_SIDE)
  squareFrame.stateTexture = stateTexture
  local line = CreateLine(squareFrame, "TYPE1")
  line:SetExtent(300, 3)
  line:SetColor(1, 1, 1, 0.3)
  line:AddAnchor("TOP", squareFrame, 0, MARGIN.WINDOW_TITLE * 2.3)
  local leftGrade = squareFrame:CreateChildWidget("label", "leftGrade", 0, true)
  leftGrade:SetAutoResize(true)
  leftGrade:SetHeight(FONT_SIZE.MIDDLE)
  local arrow = W_ICON.CreateArrowIcon(squareFrame)
  arrow:AddAnchor("TOP", stateTexture, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 3)
  squareFrame.arrow = arrow
  leftGrade:AddAnchor("RIGHT", arrow, "LEFT", -5, 0)
  local rightGrade = squareFrame:CreateChildWidget("label", "rightGrade", 0, true)
  rightGrade:SetAutoResize(true)
  rightGrade:SetHeight(FONT_SIZE.MIDDLE)
  rightGrade:AddAnchor("LEFT", arrow, "RIGHT", 3, 0)
  local desc = squareFrame:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetExtent(frame:GetWidth() - MARGIN.WINDOW_SIDE * 4, FONT_SIZE.MIDDLE)
  desc:SetAutoResize(true)
  desc:SetHeight(FONT_SIZE.MIDDLE)
  desc:AddAnchor("BOTTOM", line, "TOP", 0, -MARGIN.WINDOW_SIDE / 3)
  local itemIcon = CreateItemIconButton(squareFrame:GetId() .. "itemIcon", squareFrame)
  itemIcon:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  itemIcon:AddAnchor("TOP", line, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  squareFrame.itemIcon = itemIcon
  local greatFailTexture = itemIcon:CreateDrawable(TEXTURE_PATH.ITEM_DIAGONAL_LINE, "line", "overlay")
  greatFailTexture:SetTextureColor("red")
  greatFailTexture:SetVisible(false)
  greatFailTexture:AddAnchor("CENTER", itemIcon, 0, 0)
  itemIcon.greatFailTexture = greatFailTexture
  local itemBgDeco = squareFrame:CreateDrawable(path, "pattern_01", "background")
  itemBgDeco:AddAnchor("CENTER", itemIcon, 0, -1)
  squareFrame.itemBgDeco = itemBgDeco
  local rewardArrow = W_ICON.CreateArrowIcon(squareFrame)
  rewardArrow:SetVisible(false)
  rewardArrow:AddAnchor("TOP", line, "BOTTOM", 0, MARGIN.WINDOW_SIDE * 2)
  squareFrame.rewardArrow = rewardArrow
  local breakRewardItemIcon = CreateItemIconButton(squareFrame:GetId() .. "breakRewardItemIcon", squareFrame)
  breakRewardItemIcon:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  breakRewardItemIcon:AddAnchor("LEFT", rewardArrow, "RIGHT", 8, 0)
  squareFrame.breakRewardItemIcon = breakRewardItemIcon
  local itemName = squareFrame:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetHeight(FONT_SIZE.LARGE)
  itemName:AddAnchor("TOP", rewardArrow, "BOTTOM", 0, MARGIN.WINDOW_SIDE * 1.5)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  local bg = CreateContentBackground(itemName, "TYPE7", "brown")
  bg:SetHeight(35)
  bg:AddAnchor("TOPLEFT", itemName, -MARGIN.WINDOW_SIDE, -5)
  bg:AddAnchor("BOTTOMRIGHT", itemName, MARGIN.WINDOW_SIDE, 5)
  itemName.bg = bg
  local okButton = squareFrame:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("TOP", itemName, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 1.2)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc()
    frame:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  local rectangleFrame = frame:CreateChildWidget("window", "rectangleFrame", 0, true)
  rectangleFrame:AddAnchor("TOPLEFT", frame, 0, 0)
  rectangleFrame:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  rectangleFrame.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  rectangleFrame.titleStyle:SetAlign(ALIGN_CENTER)
  rectangleFrame.titleStyle:SetShadow(true)
  rectangleFrame:SetTitleInset(0, 2, 0, 0)
  ApplyTitleFontColor(rectangleFrame, FONT_COLOR.RED)
  local bg = CreateContentBackground(rectangleFrame, "TYPE8", "brown")
  bg:AddAnchor("TOPLEFT", rectangleFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", rectangleFrame, 0, 0)
  local function SetGradeChange(oldGradeName, oldGradeColor, newGradeName, newGradeColor)
    frame.squareFrame.leftGrade:Show(true)
    frame.squareFrame.leftGrade:SetText(oldGradeName)
    ApplyTextColor(frame.squareFrame.leftGrade, oldGradeColor)
    frame.squareFrame.rightGrade:Show(true)
    frame.squareFrame.rightGrade:SetText(newGradeName)
    ApplyTextColor(frame.squareFrame.rightGrade, newGradeColor)
  end
  local function SetStageTexture(resultCode)
    local key
    if resultCode == IGER_BREAK then
      key = "majorfailure"
    elseif resultCode == IGER_FAIL or resultCode == IGER_DOWNGRADE or resultCode == IGER_DISABLE then
      key = "failure"
    elseif resultCode == IGER_SUCCESS then
      key = "success"
    elseif resultCode == IGER_GREAT_SUCCESS then
      key = "greatsuccess"
    elseif resultCode == IGER_RESTORE_DISABLE then
      key = "restoration"
    end
    if key == nil then
      return
    end
    frame.squareFrame.stateTexture:SetTexture(path)
    frame.squareFrame.stateTexture:SetTextureInfo(key)
  end
  local function SetArrowTextrue(isUpgrade, resultCode, newGradeColor)
    if resultCode == IGER_FAIL or resultCode == IGER_BREAK or resultCode == IGER_DISABLE then
      return
    end
    frame.squareFrame.arrow:SetVisible(true)
    ApplyTextureColor(frame.squareFrame.arrow, newGradeColor)
    if resultCode == IGER_SUCCESS then
      frame.squareFrame.arrow:SetCoords(624, 364, 28, 17)
      frame.squareFrame.arrow:SetExtent(28, 17)
    elseif resultCode == IGER_GREAT_SUCCESS then
      frame.squareFrame.arrow:SetCoords(624, 364, 54, 17)
      frame.squareFrame.arrow:SetExtent(54, 17)
    elseif resultCode == IGER_DOWNGRADE then
      frame.squareFrame.arrow:SetCoords(652, 364, -28, 17)
      frame.squareFrame.arrow:SetExtent(28, 17)
    end
  end
  function frame:SetResult(resultCode, itemLink, oldGrade, newGrade, breakRewardItemType, breakRewardItemCount, breakRewardByMail)
    local itemInfo = X2Item:InfoFromLink(itemLink)
    self.squareFrame:Show(false)
    self.rectangleFrame:Show(false)
    self:Show(true)
    self:SetStartAnimation(true, true)
    self.squareFrame:Show(true)
    self.squareFrame.arrow:SetVisible(false)
    local oldGradeColor = X2Item:GradeColor(oldGrade)
    oldGradeColor = Hex2Dec(oldGradeColor)
    local oldGradeName = X2Item:GradeName(oldGrade)
    oldGradeName = string.format("[%s]", oldGradeName)
    local newGradeColor = X2Item:GradeColor(newGrade)
    newGradeColor = Hex2Dec(newGradeColor)
    local newGradeName = X2Item:GradeName(newGrade)
    newGradeName = string.format("[%s]", newGradeName)
    local name = centerMessageLocale:GetEnchantResultItemStr(newGradeName, itemInfo.name)
    self.squareFrame.itemBgDeco:SetTexture(path)
    self.squareFrame.itemBgDeco:SetTextureInfo("pattern_01")
    self.squareFrame.itemBgDeco:SetVisible(true)
    ApplyTextColor(self.squareFrame.itemName, newGradeColor)
    self.squareFrame.itemName:SetTextAutoWidth(1000, name, 10)
    self.squareFrame.itemName:SetHeight(self.squareFrame.itemName:GetTextHeight())
    self.squareFrame.leftGrade:Show(false)
    self.squareFrame.rightGrade:Show(false)
    self.squareFrame.desc:Show(false)
    self.squareFrame.rewardArrow:SetVisible(false)
    self.squareFrame.breakRewardItemIcon:Show(false)
    self.squareFrame.itemIcon:OverlayInvisible()
    self.squareFrame.itemIcon.greatFailTexture:SetVisible(false)
    self.squareFrame.arrow:RemoveAllAnchors()
    self.squareFrame.arrow:AddAnchor("TOP", self.squareFrame.stateTexture, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 1.2)
    if resultCode == IGER_DISABLE then
      itemInfo.isEnchantDisable = true
    elseif resultCode == IGER_RESTORE_DISABLE then
      itemInfo.isEnchantDisable = false
    end
    self.squareFrame.itemIcon:SetItemInfo(itemInfo)
    self.squareFrame.itemIcon:RemoveAllAnchors()
    self.squareFrame.itemIcon:AddAnchor("TOP", line, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
    SetStageTexture(resultCode)
    if resultCode ~= IGER_SUCCESS and resultCode ~= IGER_GREAT_SUCCESS then
      self.squareFrame.itemBgDeco:SetTextureInfo("pattern_02")
      self.squareFrame.itemName.bg:SetColor(ConvertColor(234), ConvertColor(215), ConvertColor(211), 1)
      self.squareFrame.desc:Show(true)
      ApplyTextColor(self.squareFrame.desc, FONT_COLOR.RED)
      if resultCode == IGER_BREAK then
        local str = string.format("%s.", locale.physicalEnchant.great_fail)
        if breakRewardItemType ~= nil and breakRewardItemType ~= 0 and breakRewardItemCount ~= nil then
          self.squareFrame.itemBgDeco:SetVisible(false)
          self.squareFrame.rewardArrow:SetVisible(true)
          self.squareFrame.itemIcon:RemoveAllAnchors()
          self.squareFrame.itemIcon:AddAnchor("RIGHT", self.squareFrame.rewardArrow, "LEFT", -5, 0)
          self.squareFrame.breakRewardItemIcon:Show(true)
          self.squareFrame.breakRewardItemIcon:SetItemInfo(X2Item:GetItemInfoByType(breakRewardItemType))
          self.squareFrame.breakRewardItemIcon:SetStack(breakRewardItemCount)
          if breakRewardByMail then
            str = string.format([[
%s
%s]], str, X2Locale:LocalizeUiText(COMMON_TEXT, "item_grade_enchant_fail_break_reward_mail_msg"))
          end
        else
          self.squareFrame.itemBgDeco:SetVisible(true)
        end
        self.squareFrame.itemIcon:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.RED)
        self.squareFrame.itemIcon.greatFailTexture:SetVisible(true)
        self.squareFrame.desc:SetText(str)
      elseif resultCode == IGER_FAIL then
        self.squareFrame.desc:SetText(string.format("%s.", locale.physicalEnchant.fail))
      elseif resultCode == IGER_DISABLE then
        self.squareFrame.desc:SetText(string.format("%s.", X2Locale:LocalizeUiText(ITEM_GRADE, "disable_enchant")))
      elseif resultCode == IGER_DOWNGRADE then
        self.squareFrame.desc:SetText(string.format("%s.", X2Locale:LocalizeUiText(ITEM_GRADE, "enchant_downgrade")))
        self.squareFrame.itemName.bg:SetColor(1, 1, 1, 1)
        SetArrowTextrue(false, resultCode, newGradeColor)
        SetGradeChange(newGradeName, newGradeColor, oldGradeName, oldGradeColor)
        self.squareFrame.arrow:RemoveAllAnchors()
        self.squareFrame.arrow:AddAnchor("TOP", self.squareFrame.stateTexture, "BOTTOM", 0, -3)
      elseif resultCode == IGER_RESTORE_DISABLE then
        self.squareFrame.desc:SetText(X2Locale:LocalizeUiText(ITEM_GRADE, "restore_disable_enchant_msg"))
        ApplyTextColor(self.squareFrame.desc, FONT_COLOR.DEFAULT)
      end
    else
      self.squareFrame.itemName.bg:SetColor(1, 1, 1, 1)
      SetArrowTextrue(true, resultCode, newGradeColor)
      SetGradeChange(oldGradeName, oldGradeColor, newGradeName, newGradeColor)
    end
  end
  return frame
end
gradeEnchantAlarm = CreateGradeEnchantAlarmMessage("gradeEnchantAlarm", "UIParent")
function ShowGradeEnchantAlarmMessage(resultCode, itemLink, oldGrade, newGrade, breakRewardItemType, breakRewardItemCount, breakRewardByMail)
  gradeEnchantAlarm:SetResult(resultCode, itemLink, oldGrade, newGrade, breakRewardItemType, breakRewardItemCount, breakRewardByMail)
  gradeEnchantAlarm:Raise()
  gradeEnchantAlarm:RemoveAllAnchors()
  gradeEnchantAlarm:AddAnchor("TOP", "UIParent", 0, 70)
end
local CreateAwakenAlarmMessage = function(id, parent)
  local path = TEXTURE_PATH.GRADE_ENCHANT_ALARM
  local frame = CreateEmptyWindow(id, parent)
  frame:AddAnchor("TOP", parent, 0, 70)
  frame:SetSounds("dialog_common")
  frame:SetExtent(405, 375)
  SetttingUIAnimation(frame)
  local squareFrame = frame:CreateChildWidget("emptywidget", "squareFrame", 0, true)
  squareFrame:AddAnchor("TOPLEFT", frame, 0, 0)
  squareFrame:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local bg = squareFrame:CreateDrawable(path, "bg_paper", "background")
  bg:AddAnchor("TOPLEFT", squareFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", squareFrame, 0, -10)
  local stateTexture = squareFrame:CreateDrawable(path, "failure", "background")
  stateTexture:AddAnchor("TOP", squareFrame, 0, MARGIN.WINDOW_SIDE)
  squareFrame.stateTexture = stateTexture
  local line = CreateLine(squareFrame, "TYPE1")
  line:SetExtent(300, 3)
  line:SetColor(1, 1, 1, 0.3)
  line:AddAnchor("TOP", squareFrame, 0, MARGIN.WINDOW_TITLE * 2.3)
  local enchantDisableMsg = squareFrame:CreateChildWidget("label", "enchantDisableMsg", 0, true)
  enchantDisableMsg:AddAnchor("BOTTOM", line, "TOP", 0, -5)
  enchantDisableMsg:SetText(X2Locale:LocalizeUiText(ITEM_GRADE, "disable_enchant"))
  enchantDisableMsg:SetAutoResize(true)
  enchantDisableMsg:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(enchantDisableMsg, FONT_COLOR.RED)
  squareFrame.enchantDisableMsg = enchantDisableMsg
  local itemIcon = CreateItemIconButton(squareFrame:GetId() .. "itemIcon", squareFrame)
  itemIcon:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  itemIcon:AddAnchor("TOP", line, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  squareFrame.itemIcon = itemIcon
  local itemBgDeco = squareFrame:CreateDrawable(path, "pattern_01", "background")
  itemBgDeco:AddAnchor("CENTER", itemIcon, 0, -1)
  itemBgDeco:SetExtent(202, 80)
  squareFrame.itemBgDeco = itemBgDeco
  local itemName = squareFrame:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetHeight(FONT_SIZE.LARGE)
  itemName:SetWidth(300)
  itemName:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 15)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  itemName.style:SetAlign(ALIGN_CENTER)
  local bg = CreateContentBackground(itemName, "TYPE7", "brown")
  bg:SetHeight(35)
  bg:AddAnchor("TOPLEFT", itemName, -MARGIN.WINDOW_SIDE, -5)
  bg:AddAnchor("BOTTOMRIGHT", itemName, MARGIN.WINDOW_SIDE, 5)
  itemName.bg = bg
  local CreateDetailInfo = function(id, parent, titleText, infoColor)
    local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
    widget:SetExtent(245, FONT_SIZE.MIDDLE)
    local title = widget:CreateChildWidget("label", "title", 0, true)
    title:SetWidth(130)
    title:SetHeight(FONT_SIZE.MIDDLE)
    title:AddAnchor("LEFT", widget, "LEFT", 0, 0)
    title:SetText(titleText)
    title.style:SetFontSize(FONT_SIZE.MIDDLE)
    title.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(title, FONT_COLOR.DEFAULT)
    local info = widget:CreateChildWidget("textbox", "info", 0, true)
    info:SetWidth(110)
    info:SetHeight(FONT_SIZE.MIDDLE)
    info:AddAnchor("LEFT", title, "RIGHT", 0, 0)
    info.style:SetFontSize(FONT_SIZE.MIDDLE)
    info.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(info, infoColor)
    function widget:SetText(text)
      widget.info:SetText(text)
    end
    return widget
  end
  local gearScore = CreateDetailInfo("gearScore", squareFrame, GetCommonText("gear_score"), FONT_COLOR.BLUE)
  gearScore:AddAnchor("TOP", itemName, "BOTTOM", 0, 19)
  squareFrame.gearScore = gearScore
  local bonusRate = CreateDetailInfo("bonusRate", squareFrame, GetCommonText("bonus_rate"), FONT_COLOR.BLUE)
  bonusRate:AddAnchor("TOP", gearScore, "BOTTOM", 0, 7)
  squareFrame.bonusRate = bonusRate
  local okButton = squareFrame:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("TOP", bonusRate, "BOTTOM", 0, 20)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc()
    frame:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  function frame:SetResult(result, oldGrade, oldGearScore, itemLink, bonusRate)
    local GetItemGrade = function(grade, color)
      local resultText = ""
      resultText = "|c" .. color .. grade
      return resultText
    end
    self:Show(true)
    self:SetStartAnimation(true, true)
    local squareFrame = frame.squareFrame
    if result == ICMR_SUCCESS then
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.AWAKEN_SUCCESS)
      squareFrame.stateTexture:SetTextureInfo("awaken_success")
      squareFrame.itemName.bg:SetColor(ConvertColor(234), ConvertColor(215), ConvertColor(211), 1)
      squareFrame.itemBgDeco:SetTextureInfo("pattern_01")
    else
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.AWAKEN_FAIL)
      squareFrame.stateTexture:SetTextureInfo("awaken_fail")
      squareFrame.itemName.bg:SetColor(1, 1, 1, 1)
      squareFrame.itemBgDeco:SetTextureInfo("pattern_02")
    end
    squareFrame.enchantDisableMsg:Show(result == ICMR_FAIL_DISABLE_ENCHANT)
    local itemInfo = X2Item:InfoFromLink(itemLink)
    UpdateSlot(squareFrame.itemIcon, itemInfo)
    local oldGradeColor = X2Item:GradeColor(oldGrade)
    local curGrade = GetItemGrade(oldGrade, oldGradeColor)
    local newGrade = GetItemGrade(itemInfo.grade, itemInfo.gradeColor)
    local itemNameText = "|c" .. itemInfo.gradeColor .. "[" .. itemInfo.name .. "]"
    squareFrame.itemName:SetTextAutoWidth(1000, itemNameText, 10)
    squareFrame.itemName:SetHeight(squareFrame.itemName:GetTextHeight())
    squareFrame.bonusRate:SetText(string.format("+%d%%", bonusRate / 100))
    squareFrame.gearScore:SetText(string.format("%d \226\150\182 %d", oldGearScore, itemInfo.gearScore.total))
  end
  return frame
end
awakenAlarm = CreateAwakenAlarmMessage("awakenAlarmMessage", "UIParent")
function ShowAwakenAlarmMessage(result, oldGrade, oldGearScore, itemLink, bonusRate)
  awakenAlarm:SetResult(result, oldGrade, oldGearScore, itemLink, bonusRate)
  awakenAlarm:Raise()
  awakenAlarm:RemoveAllAnchors()
  awakenAlarm:AddAnchor("TOP", "UIParent", 0, 70)
end
local CreateScaleAlarmMessage = function(id, parent)
  local path = TEXTURE_PATH.GRADE_ENCHANT_ALARM
  local frame = CreateEmptyWindow(id, parent)
  frame:AddAnchor("TOP", parent, 0, 70)
  frame:SetSounds("dialog_common")
  frame:SetExtent(370, 310)
  SetttingUIAnimation(frame)
  local squareFrame = frame:CreateChildWidget("emptywidget", "squareFrame", 0, true)
  squareFrame:AddAnchor("TOPLEFT", frame, 0, 0)
  squareFrame:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local bg = squareFrame:CreateDrawable(path, "bg_paper", "background")
  bg:AddAnchor("TOPLEFT", squareFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", squareFrame, 0, -10)
  local stateTexture = squareFrame:CreateDrawable(path, "failure", "background")
  stateTexture:AddAnchor("TOP", squareFrame, 0, 10)
  squareFrame.stateTexture = stateTexture
  local scaleAwrrow = squareFrame:CreateDrawable(TEXTURE_PATH.HUD, "single_arrow", "background")
  scaleAwrrow:SetTextureColor("default_brown")
  scaleAwrrow:AddAnchor("TOP", stateTexture, "BOTTOM", 0, -6)
  scaleAwrrow:Show(false)
  squareFrame.scaleAwrrow = scaleAwrrow
  local beforeScaleText = squareFrame:CreateChildWidget("textbox", "beforeScaleText", 0, true)
  beforeScaleText:SetExtent(36, FONT_SIZE.LARGE)
  beforeScaleText:SetAutoResize(true)
  beforeScaleText:AddAnchor("TOP", stateTexture, "BOTTOM", -45, -4)
  beforeScaleText.style:SetFontSize(FONT_SIZE.LARGE)
  beforeScaleText.style:SetAlign(ALIGN_CENTER)
  beforeScaleText:Show(false)
  ApplyTextColor(beforeScaleText, FONT_COLOR.DEFAULT)
  squareFrame.beforeScaleText = beforeScaleText
  local afterScaleText = squareFrame:CreateChildWidget("textbox", "afterScaleText", 0, true)
  afterScaleText:SetExtent(36, FONT_SIZE.LARGE)
  afterScaleText:SetAutoResize(true)
  afterScaleText:AddAnchor("TOP", stateTexture, "BOTTOM", 45, -4)
  afterScaleText.style:SetFontSize(FONT_SIZE.LARGE)
  afterScaleText.style:SetAlign(ALIGN_CENTER)
  afterScaleText:Show(false)
  ApplyTextColor(afterScaleText, FONT_COLOR.DEFAULT)
  squareFrame.afterScaleText = afterScaleText
  local resultText = squareFrame:CreateChildWidget("textbox", "resultText", 0, true)
  resultText:SetExtent(285, FONT_SIZE.LARGE)
  resultText:SetAutoResize(true)
  resultText:AddAnchor("TOP", scaleAwrrow, "BOTTOM", 0, 5)
  resultText.style:SetFontSize(FONT_SIZE.LARGE)
  resultText.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(resultText, FONT_COLOR.DEFAULT)
  squareFrame.resultText = resultText
  local line = CreateLine(squareFrame, "TYPE1")
  line:SetExtent(300, 3)
  line:SetColor(1, 1, 1, 0.3)
  line:AddAnchor("TOP", resultText, "BOTTOM", 0, 6)
  local itemIcon = CreateItemIconButton(squareFrame:GetId() .. "itemIcon", squareFrame)
  itemIcon:SetExtent(ICON_SIZE.XLARGE, ICON_SIZE.XLARGE)
  itemIcon:AddAnchor("TOP", line, "BOTTOM", 0, MARGIN.WINDOW_SIDE + 10)
  squareFrame.itemIcon = itemIcon
  local itemBgDeco = squareFrame:CreateDrawable(path, "pattern_02", "background")
  itemBgDeco:AddAnchor("CENTER", itemIcon, 0, -1)
  itemBgDeco:SetExtent(202, 80)
  squareFrame.itemBgDeco = itemBgDeco
  local itemName = squareFrame:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetHeight(FONT_SIZE.LARGE)
  itemName:SetWidth(300)
  itemName:SetAutoWordwrap(true)
  itemName:SetAutoResize(true)
  itemName:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 15)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  itemName.style:SetAlign(ALIGN_CENTER)
  squareFrame.itemName = itemName
  local bg = CreateContentBackground(itemName, "TYPE7", "brown")
  bg:SetHeight(35)
  bg:AddAnchor("TOPLEFT", itemName, -MARGIN.WINDOW_SIDE, -5)
  bg:AddAnchor("BOTTOMRIGHT", itemName, MARGIN.WINDOW_SIDE, 5)
  bg:SetColor(1, 1, 1, 1)
  squareFrame.itemName.bg = bg
  local okButton = squareFrame:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("TOP", bg, "BOTTOM", 0, 10)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc()
    frame:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  function frame:SetResult(result, itemLink, beforeScale, afterScale)
    local GetItemGrade = function(grade, color)
      local resultText = ""
      resultText = "|c" .. color .. "[" .. grade .. "]"
      return resultText
    end
    local function SetScaledInfo(arrowShow, beforeScale, afterScale)
      beforeScaleText:Show(arrowShow)
      afterScaleText:Show(arrowShow)
      scaleAwrrow:Show(arrowShow)
      beforeScaleText:SetText(beforeScale)
      afterScaleText:SetText(afterScale)
    end
    self:Show(true)
    self:SetStartAnimation(true, true)
    local squareFrame = frame.squareFrame
    if result == IGER_GREAT_SUCCESS or result == IGER_SUCCESS then
      ApplyTextColor(squareFrame.resultText, FONT_COLOR.DEFAULT)
    else
      ApplyTextColor(squareFrame.resultText, FONT_COLOR.RED)
    end
    if result == IGER_GREAT_SUCCESS then
      SetScaledInfo(true, beforeScale, afterScale)
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.SCALE_GREATE)
      squareFrame.stateTexture:SetTextureInfo("grinding_great")
      squareFrame.scaleAwrrow:SetTextureInfo("double_arrow", "default_brown")
      local str = X2Locale:LocalizeUiText(COMMON_TEXT, "enchant_scale_result_success", tostring(tonumber(afterScale) - tonumber(beforeScale)))
      squareFrame.resultText:SetText(str)
    elseif result == IGER_SUCCESS then
      SetScaledInfo(true, beforeScale, afterScale)
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.SCALE_SUCCESS)
      squareFrame.stateTexture:SetTextureInfo("grinding_success")
      squareFrame.scaleAwrrow:SetTextureInfo("single_arrow", "default_brown")
      local str = X2Locale:LocalizeUiText(COMMON_TEXT, "enchant_scale_result_success", tostring(tonumber(afterScale) - tonumber(beforeScale)))
      squareFrame.resultText:SetText(str)
    elseif result == IGER_BREAK then
      SetScaledInfo(false, beforeScale, afterScale)
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.SCALE_BREAK)
      squareFrame.stateTexture:SetTextureInfo("grinding_big_failure")
      squareFrame.resultText:SetText(GetCommonText("enchant_scale_result_break"))
    elseif result == IGER_DOWNGRADE then
      SetScaledInfo(true, afterScale, beforeScale)
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.SCALE_FAIL)
      squareFrame.stateTexture:SetTextureInfo("grinding_failure")
      squareFrame.scaleAwrrow:SetTextureInfo("single_arrow", "default_brown", "REVERSE_X")
      local str = X2Locale:LocalizeUiText(COMMON_TEXT, "enchant_scale_result_down", tostring(tonumber(beforeScale) - tonumber(afterScale)))
      squareFrame.resultText:SetText(str)
    elseif result == IGER_DISABLE then
      SetScaledInfo(false, beforeScale, afterScale)
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.SCALE_FAIL)
      squareFrame.stateTexture:SetTextureInfo("grinding_failure")
      squareFrame.resultText:SetText(GetCommonText("enchant_scale_result_disable"))
    else
      SetScaledInfo(false, beforeScale, afterScale)
      squareFrame.stateTexture:SetTexture(TEXTURE_PATH.SCALE_FAIL)
      squareFrame.stateTexture:SetTextureInfo("grinding_failure")
      squareFrame.resultText:SetText(GetCommonText("enchant_scale_result_fail"))
    end
    local itemInfo = X2Item:InfoFromLink(itemLink)
    UpdateSlot(squareFrame.itemIcon, itemInfo)
    squareFrame.itemName:SetTextAutoWidth(300, string.format([[
%s
%s]], GetItemGrade(itemInfo.grade, itemInfo.gradeColor), itemInfo.name), 10)
    local _, startPos = frame:GetOffset()
    local _, endPos = okButton:GetOffset()
    endPos = endPos + okButton:GetHeight() + 45
    frame:SetExtent(frame:GetWidth(), endPos - startPos)
  end
  return frame
end
scaleAlarm = CreateScaleAlarmMessage("scaleAlarmMessage", "UIParent")
function ShowScaleAlarmMessage(result, itemLink, beforeScale, afterScale)
  if beforeScale == "none" then
    beforeScale = "+0"
  end
  scaleAlarm:SetResult(result, itemLink, beforeScale, afterScale)
  scaleAlarm:Raise()
  scaleAlarm:RemoveAllAnchors()
  scaleAlarm:AddAnchor("TOP", "UIParent", 0, 70)
end
