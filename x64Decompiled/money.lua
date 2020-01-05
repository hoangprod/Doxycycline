W_MONEY = {}
local CreateMoneyEdit = function(id, parent)
  local edit = W_CTRL.CreateEdit(id, parent)
  edit:SetInset(5, 7, 20, 7)
  edit.style:SetAlign(ALIGN_RIGHT)
  edit.style:SetSnap(true)
  edit:SetText("0")
  edit:SetDigit(true)
  edit.minValue = 0
  edit.maxValue = MAX_SILVER
  edit.lastChar = "0"
  edit.lastMsg = "0"
  function edit:OnTextChanged()
    local text = self:GetText()
    local char = string.sub(text, string.len(text), string.len(text))
    local number = tonumber(text)
    if number ~= nil then
      if number > edit.maxValue then
        edit.value = edit.maxValue
      elseif number < edit.minValue then
        edit.value = edit.minValue
      else
        edit.value = number
      end
      edit:SetText(tostring(edit.value))
    else
      edit:SetText(edit.lastMsg)
    end
    edit.lastMsg = self:GetText()
  end
  function edit:OnEnterPressed()
    self:ClearFocus()
  end
  function edit:SetMinMaxValues(_min, _max)
    if _min == nil or _max == nil then
      return
    end
    if _min < _max then
      self.minValue = _min
      self.maxValue = _max
    end
  end
  edit:SetHandler("OnTextChanged", edit.OnTextChanged)
  edit:SetHandler("OnEnterPressed", edit.OnEnterPressed)
  return edit
end
local function SetViewOfMoneyEditsWindow(id, parent, titleText, isAAPoint)
  local currencyIndex = isAAPoint and 2 or 1
  local GOLD = 1
  local SILVER = 2
  local COPPER = 3
  local iconNames = {
    {
      "gold",
      "aapointGold"
    },
    {
      "silver",
      "aapointSilver"
    },
    {
      "copper",
      "aapointCopper"
    }
  }
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(175, DEFAULT_SIZE.EDIT_HEIGHT)
  window:Show(true)
  local goldEdit = CreateMoneyEdit(id .. ".goldEdit", window)
  goldEdit:SetExtent(75, DEFAULT_SIZE.EDIT_HEIGHT)
  goldEdit:SetMaxTextLength(6)
  window.goldEdit = goldEdit
  local goldIcon = W_ICON.DrawMoneyIcon(goldEdit, iconNames[GOLD][currencyIndex])
  goldIcon:AddAnchor("RIGHT", goldEdit, -3, 0)
  goldEdit.goldIcon = goldIcon
  local silverEdit = CreateMoneyEdit(id .. ".silveredit", window)
  silverEdit:SetExtent(42, DEFAULT_SIZE.EDIT_HEIGHT)
  silverEdit:SetMaxTextLength(2)
  window.silverEdit = silverEdit
  local silverIcon = W_ICON.DrawMoneyIcon(silverEdit, iconNames[SILVER][currencyIndex])
  silverIcon:AddAnchor("RIGHT", silverEdit, -3, 0)
  silverEdit.silverIcon = silverIcon
  local copperEdit = CreateMoneyEdit(id .. ".copperedit", window)
  copperEdit:SetExtent(42, DEFAULT_SIZE.EDIT_HEIGHT)
  copperEdit:SetMaxTextLength(2)
  window.copperEdit = copperEdit
  local copperIcon = W_ICON.DrawMoneyIcon(copperEdit, iconNames[COPPER][currencyIndex])
  copperIcon:AddAnchor("RIGHT", copperEdit, -3, 0)
  copperEdit.copperIcon = copperIcon
  if titleText ~= nil then
    local title = window:CreateChildWidget("label", "title", 0, true)
    title.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(title, FONT_COLOR.TITLE)
    title:SetText(titleText)
    title:SetExtent(65, 13)
    title:AddAnchor("RIGHT", window, "LEFT", 0, 0)
    title:SetLimitWidth(false)
  end
  function window:AnchorStyling(style)
    if style == "twoLine" then
      goldEdit:RemoveAllAnchors()
      goldEdit:AddAnchor("TOPLEFT", window, 0, 0)
      silverEdit:RemoveAllAnchors()
      silverEdit:AddAnchor("TOPLEFT", goldEdit, "BOTTOMLEFT", 0, 2)
      copperEdit:RemoveAllAnchors()
      copperEdit:AddAnchor("TOPRIGHT", goldEdit, "BOTTOMRIGHT", 0, 2)
      self:SetHeight(52)
    else
      goldEdit:RemoveAllAnchors()
      goldEdit:AddAnchor("TOPLEFT", window, 0, 0)
      silverEdit:RemoveAllAnchors()
      silverEdit:AddAnchor("LEFT", goldEdit, "RIGHT", 4, 0)
      copperEdit:RemoveAllAnchors()
      copperEdit:AddAnchor("LEFT", silverEdit, "RIGHT", 4, 0)
      self:SetHeight(22)
    end
  end
  window:AnchorStyling()
  function window:SetExtentByMultiplier(widthMultiplier, heightMultiplier)
    local tempWidth, tempHeight = self:GetExtent()
    self:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
    tempWidth, tempHeight = self.goldEdit:GetExtent()
    self.goldEdit:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
    tempWidth, tempHeight = self.goldEdit.goldIcon:GetExtent()
    self.goldEdit.goldIcon:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
    tempWidth, tempHeight = self.silverEdit:GetExtent()
    self.silverEdit:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
    tempWidth, tempHeight = self.silverEdit.silverIcon:GetExtent()
    self.silverEdit.silverIcon:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
    tempWidth, tempHeight = self.copperEdit:GetExtent()
    self.copperEdit:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
    tempWidth, tempHeight = self.copperEdit.copperIcon:GetExtent()
    self.copperEdit.copperIcon:SetExtent(tempWidth * widthMultiplier, tempHeight * heightMultiplier)
  end
  function window:SetMoneyFontSize(size)
    self.goldEdit.style:SetFontSize(size)
    self.silverEdit.style:SetFontSize(size)
    self.copperEdit.style:SetFontSize(size)
  end
  return window
end
function W_MONEY.CreateMoneyEditsWindow(id, parent, titleText)
  local window = SetViewOfMoneyEditsWindow(id, parent, titleText, false)
  local MONEY_LIMIT = "2000000000"
  window.money_limit = MONEY_LIMIT
  function window:SetAmountStr(moneyStr)
    if moneyStr == nil then
      moneyStr = "0"
    end
    if type(moneyStr) == "number" then
      moneyStr = string.format("%i", moneyStr)
    end
    local money = tonumber(moneyStr)
    if money ~= nil and (money < 0 or 0 < X2Util:CompareMoneyString(moneyStr, MONEY_LIMIT)) then
      moneyStr = MONEY_LIMIT
    end
    local gold, silver, copper = GoldSilverCopperStringFromMoneyStr(moneyStr)
    window.goldEdit:SetText(gold)
    window.silverEdit:SetText(silver)
    window.copperEdit:SetText(copper)
    window.moneyStr = moneyStr
  end
  function window:GetAmountStr()
    local gold = window.goldEdit:GetText()
    local silver = window.silverEdit:GetText()
    local copper = window.copperEdit:GetText()
    window.moneyStr = X2Util:MakeMoneyString(gold, silver, copper)
    return window.moneyStr
  end
  function window:GetSystemCurrencyAmountLimit()
    return MONEY_LIMIT
  end
  function window:SetCurrencyAmountLimit(limit)
    limit = tostring(limit)
    if X2Util:CompareMoneyString(limit, MONEY_LIMIT) > 0 then
      limit = MONEY_LIMIT
    end
    self.money_limit = limit
  end
  function window:OnTextChanged()
    local moneyStr = window:GetAmountStr()
    if X2Util:CompareMoneyString(moneyStr, window.money_limit) > 0 then
      window:SetAmountStr(window.money_limit)
    end
    if window.MoneyEditProc ~= nil then
      window:MoneyEditProc()
    end
  end
  window.goldEdit:SetHandler("OnTextChanged", window.OnTextChanged)
  window.silverEdit:SetHandler("OnTextChanged", window.OnTextChanged)
  window.copperEdit:SetHandler("OnTextChanged", window.OnTextChanged)
  return window
end
function W_MONEY.CreateAAPointEditsWindow(id, parent, titleText)
  local window = SetViewOfMoneyEditsWindow(id, parent, titleText, true)
  local AA_POINT_LIMIT = "2000000000"
  window.aaPoint_limit = AA_POINT_LIMIT
  function window:SetAmountStr(aaPointStr)
    if aaPointStr == nil then
      aaPointStr = "0"
    end
    if type(aaPointStr) == "number" then
      aaPointStr = string.format("%i", aaPointStr)
    end
    local gold, silver, copper = GetAAPointByUnitFromAAPointStr(aaPointStr)
    window.goldEdit:SetText(gold)
    window.silverEdit:SetText(silver)
    window.copperEdit:SetText(copper)
    window.aaPointStr = aaPointStr
  end
  function window:GetAmountStr()
    local gold = window.goldEdit:GetText()
    local silver = window.silverEdit:GetText()
    local copper = window.copperEdit:GetText()
    window.aaPointStr = X2Util:MakeAAPointString(gold, silver, copper)
    return window.aaPointStr
  end
  function window:GetSystemCurrencyAmountLimit()
    return AA_POINT_LIMIT
  end
  function window:SetCurrencyAmountLimit(limit)
    limit = tostring(limit)
    if X2Util:CompareMoneyString(limit, AA_POINT_LIMIT) > 0 then
      limit = AA_POINT_LIMIT
    end
    self.aaPoint_limit = limit
  end
  function window:OnTextChanged()
    local aaPointStr = window:GetAmountStr()
    if X2Util:CompareAAPointString(aaPointStr, window.aaPoint_limit) > 0 then
      window:SetAmountStr(window.aaPoint_limit)
    end
    if window.MoneyEditProc ~= nil then
      window:MoneyEditProc()
    end
  end
  window.goldEdit:SetHandler("OnTextChanged", window.OnTextChanged)
  window.silverEdit:SetHandler("OnTextChanged", window.OnTextChanged)
  window.copperEdit:SetHandler("OnTextChanged", window.OnTextChanged)
  return window
end
local SetViewOfTwoLineMoneyWindow = function(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(108, 45)
  local goldLabel = window:CreateChildWidget("label", "goldLabel", 0, true)
  goldLabel:SetExtent(108, 20)
  goldLabel:AddAnchor("TOPLEFT", window, 0, 0)
  goldLabel:SetNumberOnly(true)
  goldLabel:SetInset(0, 0, 31, 0)
  ApplyTextColor(goldLabel, FONT_COLOR.BLACK)
  goldLabel.style:SetAlign(ALIGN_RIGHT)
  local bg = goldLabel:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", goldLabel, 0, -2)
  bg:AddAnchor("BOTTOMRIGHT", goldLabel, 0, 2)
  local goldIcon = W_ICON.DrawMoneyIcon(goldLabel, "gold")
  goldIcon:AddAnchor("RIGHT", goldLabel, -13, 0)
  window.goldIcon = goldIcon
  local silverLabel = window:CreateChildWidget("label", "silverLabel", 0, true)
  silverLabel:SetExtent(54, 20)
  silverLabel:AddAnchor("TOPLEFT", goldLabel, "BOTTOMLEFT", 0, 5)
  silverLabel:SetNumberOnly(true)
  silverLabel:SetInset(0, 0, 31, 0)
  ApplyTextColor(silverLabel, FONT_COLOR.BLACK)
  silverLabel.style:SetAlign(ALIGN_RIGHT)
  local bg = goldLabel:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", silverLabel, 0, -2)
  bg:AddAnchor("BOTTOMRIGHT", silverLabel, 1, 2)
  local silverIcon = W_ICON.DrawMoneyIcon(silverLabel, "silver")
  silverIcon:AddAnchor("RIGHT", silverLabel, -13, 0)
  window.silverIcon = silverIcon
  local copperLabel = window:CreateChildWidget("label", "copperLabel", 0, true)
  copperLabel:SetExtent(54, 20)
  copperLabel:AddAnchor("TOPRIGHT", goldLabel, "BOTTOMRIGHT", 0, 5)
  copperLabel:SetNumberOnly(true)
  copperLabel:SetInset(0, 0, 31, 0)
  ApplyTextColor(copperLabel, FONT_COLOR.BLACK)
  copperLabel.style:SetAlign(ALIGN_RIGHT)
  local bg = goldLabel:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", copperLabel, -1, -2)
  bg:AddAnchor("BOTTOMRIGHT", copperLabel, 0, 2)
  local copperIcon = W_ICON.DrawMoneyIcon(copperLabel, "copper")
  copperIcon:AddAnchor("RIGHT", copperLabel, -13, 0)
  window.copperIcon = copperIcon
  return window
end
function W_MONEY.CreateTwoLineMoneyWindow(id, parent)
  local window = SetViewOfTwoLineMoneyWindow(id, parent)
  local alpha = 0.2
  function window:Update(money)
    if type(money) == "number" then
      money = X2Util:NumberToString(money)
    end
    local gold, silver, copper = GoldSilverCopperStringFromMoneyStr(money)
    gold = F_MONEY:RemoveHeadZero(gold)
    silver = F_MONEY:RemoveHeadZero(silver)
    copper = F_MONEY:RemoveHeadZero(copper)
    if gold ~= "0" then
      self.goldLabel:SetText(gold)
      self.goldLabel:SetAlpha(1)
      self.goldIcon:SetColor(1, 1, 1, 1)
    else
      self.goldLabel:SetText("")
      self.goldLabel:SetAlpha(alpha)
      self.goldIcon:SetColor(1, 1, 1, alpha)
    end
    if silver ~= "0" then
      self.silverLabel:SetText(silver)
      self.silverLabel:SetAlpha(1)
      self.silverIcon:SetColor(1, 1, 1, 1)
    else
      self.silverLabel:SetText("")
      self.silverLabel:SetAlpha(alpha)
      self.silverIcon:SetColor(1, 1, 1, alpha)
    end
    if copper ~= "0" then
      self.copperLabel:SetText(copper)
      self.copperLabel:SetAlpha(1)
      self.copperIcon:SetColor(1, 1, 1, 1)
    else
      self.copperLabel:SetText("")
      self.copperLabel:SetAlpha(alpha)
      self.copperIcon:SetColor(1, 1, 1, alpha)
    end
  end
  return window
end
local SetViewOfTwoLineAAPointWindow = function(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(108, 45)
  local goldLabel = window:CreateChildWidget("label", "goldLabel", 0, true)
  goldLabel:SetExtent(108, 20)
  goldLabel:AddAnchor("TOPLEFT", window, 0, 0)
  goldLabel:SetNumberOnly(true)
  goldLabel:SetInset(0, 0, 31, 0)
  ApplyTextColor(goldLabel, FONT_COLOR.BLACK)
  goldLabel.style:SetAlign(ALIGN_RIGHT)
  local bg = goldLabel:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", goldLabel, 0, -2)
  bg:AddAnchor("BOTTOMRIGHT", goldLabel, 0, 2)
  local goldIcon = W_ICON.DrawMoneyIcon(goldLabel, "aapointGold")
  goldIcon:AddAnchor("RIGHT", goldLabel, -13, 0)
  window.goldIcon = goldIcon
  local silverLabel = window:CreateChildWidget("label", "silverLabel", 0, true)
  silverLabel:SetExtent(54, 20)
  silverLabel:AddAnchor("TOPLEFT", goldLabel, "BOTTOMLEFT", 0, 5)
  silverLabel:SetNumberOnly(true)
  silverLabel:SetInset(0, 0, 31, 0)
  ApplyTextColor(silverLabel, FONT_COLOR.BLACK)
  silverLabel.style:SetAlign(ALIGN_RIGHT)
  local bg = goldLabel:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", silverLabel, 0, -2)
  bg:AddAnchor("BOTTOMRIGHT", silverLabel, 1, 2)
  local silverIcon = W_ICON.DrawMoneyIcon(silverLabel, "aapointSilver")
  silverIcon:AddAnchor("RIGHT", silverLabel, -13, 0)
  window.silverIcon = silverIcon
  local copperLabel = window:CreateChildWidget("label", "copperLabel", 0, true)
  copperLabel:SetExtent(54, 20)
  copperLabel:AddAnchor("TOPRIGHT", goldLabel, "BOTTOMRIGHT", 0, 5)
  copperLabel:SetNumberOnly(true)
  copperLabel:SetInset(0, 0, 31, 0)
  ApplyTextColor(copperLabel, FONT_COLOR.BLACK)
  copperLabel.style:SetAlign(ALIGN_RIGHT)
  local bg = goldLabel:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("TOPLEFT", copperLabel, -1, -2)
  bg:AddAnchor("BOTTOMRIGHT", copperLabel, 0, 2)
  local copperIcon = W_ICON.DrawMoneyIcon(copperLabel, "aapointCopper")
  copperIcon:AddAnchor("RIGHT", copperLabel, -13, 0)
  window.copperIcon = copperIcon
  return window
end
function W_MONEY.CreateTwoLineAAPointWindow(id, parent)
  local window = SetViewOfTwoLineAAPointWindow(id, parent)
  local alpha = 0.2
  function window:Update(aaPoint)
    if type(aaPoint) == "number" then
      aaPoint = X2Util:NumberToString(aaPoint)
    end
    local gold, silver, copper = GoldSilverCopperStringFromMoneyStr(aaPoint)
    gold = F_MONEY:RemoveHeadZero(gold)
    silver = F_MONEY:RemoveHeadZero(silver)
    copper = F_MONEY:RemoveHeadZero(copper)
    if gold ~= "0" then
      self.goldLabel:SetText(gold)
      self.goldLabel:SetAlpha(1)
      self.goldIcon:SetColor(1, 1, 1, 1)
    else
      self.goldLabel:SetText("")
      self.goldLabel:SetAlpha(alpha)
      self.goldIcon:SetColor(1, 1, 1, alpha)
    end
    if silver ~= "0" then
      self.silverLabel:SetText(silver)
      self.silverLabel:SetAlpha(1)
      self.silverIcon:SetColor(1, 1, 1, 1)
    else
      self.silverLabel:SetText("")
      self.silverLabel:SetAlpha(alpha)
      self.silverIcon:SetColor(1, 1, 1, alpha)
    end
    if copper ~= "0" then
      self.copperLabel:SetText(copper)
      self.copperLabel:SetAlpha(1)
      self.copperIcon:SetColor(1, 1, 1, 1)
    else
      self.copperLabel:SetText("")
      self.copperLabel:SetAlpha(alpha)
      self.copperIcon:SetColor(1, 1, 1, alpha)
    end
  end
  return window
end
function W_MONEY.CreateDefaultMoneyWindow(id, parent, width, height)
  local widget = UIParent:CreateWidget("textbox", id, parent)
  widget:Show(true)
  widget:SetExtent(width, height)
  widget:SetAutoWordwrap(false)
  widget.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(widget, FONT_COLOR.BLUE)
  function widget:Update(amount)
    self.amount = tostring(amount)
    local currency = self.currency or CURRENCY_GOLD
    widget:SetText(string.format(F_MONEY.currency.pipeString[currency], self.amount))
  end
  widget:Update(0)
  return widget
end
local SetViewOfTitleMoneyWindow = function(id, parent, titleText, direction, newLayout)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:SetText(GetUIText(REPAIR_TEXT, "myMoney"))
  title:SetHeight(FONT_SIZE.MIDDLE)
  title.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  local money = window:CreateChildWidget("textbox", "money", 0, true)
  money:Show(true)
  money:SetHeight(30)
  money:SetAutoWordwrap(false)
  money.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(money, FONT_COLOR.TITLE)
  local bg
  if newLayout == "new_layout" then
    bg = CreateContentBackground(window, "TYPE2", "brown")
  elseif newLayout == "item_enchant" then
    bg = money:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    bg:SetTextureColor("bg_01")
    bg:SetHeight(19)
  else
    bg = money:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  end
  window.bg = bg
  function window:NotUseTitle()
    self.bg:RemoveAllAnchors()
    self.bg:AddAnchor("LEFT", window, -5, 0)
    self.bg:AddAnchor("BOTTOMRIGHT", window, 20, 0)
  end
  function window:SetDirection(direction)
    if direction == nil then
      direction = "horizon"
    end
    self.direction = direction
    if newLayout == "new_layout" then
      self.bg:RemoveAllAnchors()
      self.bg:AddAnchor("TOPLEFT", window, 0, 0)
      self.bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
      self.title:RemoveAllAnchors()
      self.title:AddAnchor("LEFT", window, 10, 0)
      self.money:RemoveAllAnchors()
      self.money:AddAnchor("LEFT", self.title, "RIGHT", 0)
      self.money:AddAnchor("RIGHT", self, -10, 0)
      self:SetExtent(237, 30)
      return
    elseif newLayout == "item_enchant" then
      self.title:RemoveAllAnchors()
      self.money:RemoveAllAnchors()
      self.title:AddAnchor("LEFT", window, 0, 0)
      self.bg:AddAnchor("LEFT", title, "RIGHT", 5, 0)
      self.bg:SetExtent(165, 19)
      self.money:AddAnchor("RIGHT", bg, -9, 0)
      self.money:SetExtent(147, FONT_SIZE.MIDDLE)
      return
    end
    if direction == "horizon" then
      self.money:RemoveAllAnchors()
      self.money:AddAnchor("RIGHT", self, 0, 0)
      self.title:RemoveAllAnchors()
      self.title:AddAnchor("LEFT", window, 0, 0)
      self.bg:AddAnchor("LEFT", title, 25, -5)
      self.bg:AddAnchor("BOTTOMRIGHT", money, 20, 0)
      self:SetExtent(215, 30)
    elseif direction == "vertical" then
      self.money:RemoveAllAnchors()
      self.money:AddAnchor("TOPLEFT", self.title, "BOTTOMLEFT", 0, 2)
      self.money:AddAnchor("BOTTOMRIGHT", self, 0, 0)
      self.title:RemoveAllAnchors()
      self.title:AddAnchor("TOPLEFT", window, 0, 0)
      self:SetExtent(160, 45)
      self.bg:AddAnchor("TOPLEFT", money, -5, 0)
      self.bg:AddAnchor("BOTTOMRIGHT", money, 20, 0)
    end
  end
  window:SetDirection(direction)
  function window:SetTitle(titleText)
    if titleText == "" then
      self.title:Show(false)
      return
    end
    if titleText == nil then
      titleText = GetUIText(REPAIR_TEXT, "myMoney")
    end
    self.title:Show(true)
    self.title:SetText(titleText)
    self.titleText = titleText
    if newLayout == "item_enchant" then
      self.title:SetAutoResize(true)
      self:SetExtent(title:GetWidth() + bg:GetWidth() + 5, 19)
      return
    end
    if self.direction == "horizon" then
      self.title.style:SetEllipsis(false)
      self.title:SetWidth(self.title.style:GetTextWidth(titleText))
    elseif self.direction == "vertical" then
      self.title.style:SetEllipsis(true)
      local titleWidth = self.title.style:GetTextWidth(titleText) + 5
      if titleWidth > self:GetWidth() then
        titleWidth = self:GetWidth()
      end
      self.title:SetWidth(titleWidth)
    end
  end
  window:SetTitle(titleText)
  return window
end
function W_MONEY.CreateTitleMoneyWindow(id, parent, titleText, direction, layoutType)
  local widget = SetViewOfTitleMoneyWindow(id, parent, titleText, direction, layoutType)
  function widget:Update(money)
    if self.itemPointIcon ~= nil then
      self.itemPointIcon:Show(false)
    end
    if money == "" then
      widget.money:SetText("")
      return
    elseif money == -1 then
      widget.money:SetText(locale.money.sold_out)
      return
    end
    local moneyStr = ""
    if type(money) == "number" then
      moneyStr = string.format("|m%i;", money)
    else
      moneyStr = string.format("|m%s;", money)
    end
    self.money:SetText(moneyStr)
    if self.direction == "horizon" then
      self.money:SetWidth(500)
      self.money:SetWidth(self.money:GetLongestLineWidth() + 17)
    end
  end
  function widget:UpdateHonorPoint(honorPoint)
    local honorPoint = string.format("|h%s;", honorPoint)
    widget.money:SetText(honorPoint)
    if self.itemPointIcon ~= nil then
      self.itemPointIcon:Show(false)
    end
    if self.direction == "horizon" then
      self.money:SetWidth(500)
      self.money:SetWidth(self.money:GetLongestLineWidth() + 17)
    end
  end
  function widget:UpdateLivingPoint(livingPoint)
    local livingPoint = string.format("|l%s;", livingPoint)
    widget.money:SetText(livingPoint)
    if self.itemPointIcon ~= nil then
      self.itemPointIcon:Show(false)
    end
    if self.direction == "horizon" then
      self.money:SetWidth(500)
      self.money:SetWidth(self.money:GetLongestLineWidth() + 17)
    end
  end
  function widget:UpdateContributionPoint(contPoint)
    local contPoint = string.format("|w%s", contPoint)
    widget.money:SetText(contPoint)
    if self.itemPointIcon ~= nil then
      self.itemPointIcon:Show(false)
    end
    if self.direction == "horizon" then
      self.money:SetWidth(500)
      self.money:SetWidth(self.money:GetLongestLineWidth() + 17)
    end
  end
  function widget:UpdateItemPoint(point, iconPath, iconKey)
    local dispPoint = tostring(point)
    widget.money:SetText(dispPoint)
    if self.itemPointIcon ~= nil then
      self.itemPointIcon:Show(false)
    end
    if self.direction == "horizon" then
      self.money:SetWidth(500)
      self.money:SetWidth(self.money:GetLongestLineWidth() + 17)
    end
    if iconPath == nil or iconPath == "" or iconKey == nil or iconKey == "" then
      self:SetDirection(self.direction)
      return
    end
    if self.itemPointIcon == nil then
      local icon = self:CreateDrawable(iconPath, iconKey, "background")
      self.itemPointIcon = icon
    end
    self.itemPointIcon:SetTexture(iconPath)
    self.itemPointIcon:SetTextureInfo(iconKey)
    self.itemPointIcon:Show(true)
    self.money:RemoveAllAnchors()
    if self.direction == "horizon" then
      self.money:AddAnchor("RIGHT", self, -3 - self.itemPointIcon:GetWidth(), 0)
    else
      self.money:AddAnchor("TOPLEFT", self.title, "BOTTOMLEFT", 0, 2)
      self.money:AddAnchor("BOTTOMRIGHT", self, -3 - self.itemPointIcon:GetWidth(), 0)
    end
    self.itemPointIcon:AddAnchor("LEFT", self.money, "RIGHT", 3, 0)
  end
  function widget:UpdateAAPoint(aaPoint)
    if aaPoint == "" then
      self.money:SetText("")
      return
    elseif aaPoint == -1 then
      self.money:SetText(locale.money.sold_out)
      return
    end
    local aaPointStr = string.format(F_MONEY.currency.pipeString[CURRENCY_AA_POINT], tostring(aaPoint))
    self.money:SetText(aaPointStr)
    if self.direction == "horizon" or newLayout then
      self.money:SetWidth(500)
      self.money:SetWidth(self.money:GetLongestLineWidth())
    end
  end
  return widget
end
function W_MONEY.CreateMyMoneyWindow(id, parent)
  local widget = W_MONEY.CreateTitleMoneyWindow(id, parent, nil, "vertical", "new_layout")
  widget:Show(true)
  local function moneyEvent(...)
    widget:Update(X2Util:GetMyMoneyString(), false, true)
  end
  widget:SetHandler("OnEvent", function(this, event, ...)
    moneyEvent(...)
  end)
  widget:RegisterEvent("PLAYER_MONEY")
  widget:RegisterEvent("ENTERED_WORLD")
  widget:RegisterEvent("LEFT_LOADING")
  moneyEvent()
  return widget
end
local aapointBuyFrame
AA_POINT_BUY_MONEY_GROUP_HEIGHT = 100
AA_POINT_BUY_MONEY_DISPLAY_WIDTH = 145
AA_POINT_BUY_MONEY_DISPLAY_HEIGHT = 20
local SetViewOfAAPointBuyFrame = function(id, parent)
  local frameWindow = CreateEmptyWindow(id, parent)
  frameWindow:SetCloseOnEscape(true)
  frameWindow:AddAnchor("TOPLEFT", parent, 0, 0)
  frameWindow:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local bg1 = frameWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "aa_point_bg", "background")
  bg1:AddAnchor("TOPLEFT", frameWindow, -1, 1)
  bg1:AddAnchor("BOTTOMRIGHT", frameWindow, -1, -1)
  local window = CreateWindow(id .. ".window", frameWindow)
  window:AddAnchor("CENTER", frameWindow, 0, 0)
  window:SetExtent(430, 330)
  window:SetTitle(locale.inGameShop.chargeAAPoint)
  frameWindow.window = window
  window:Show(false)
  local noticePrice = window:CreateChildWidget("textbox", "noticePrice", 0, true)
  noticePrice:AddAnchor("TOPLEFT", window, 30, window.titleBar:GetHeight())
  noticePrice:AddAnchor("TOPRIGHT", window, -30, window.titleBar:GetHeight())
  noticePrice:SetHeight(FONT_SIZE.LARGE * 3)
  noticePrice:SetAutoWordwrap(false)
  noticePrice.style:SetFontSize(componentsLocale.noticePriceFontSize)
  ApplyTextColor(noticePrice, FONT_COLOR.MIDDLE_TITLE)
  local groupBg = CreateContentBackground(noticePrice, "TYPE2", "brown")
  groupBg:AddAnchor("TOPLEFT", noticePrice, 0, 0)
  groupBg:AddAnchor("BOTTOMRIGHT", noticePrice, 0, 0)
  local cashIcon = noticePrice:CreateDrawable(TEXTURE_PATH.INGAME_SHOP, "icon_cash", "background")
  cashIcon:AddAnchor("TOPLEFT", noticePrice, "BOTTOMLEFT", 40, 10)
  local arrowIcon = noticePrice:CreateDrawable(BUTTON_TEXTURE_PATH.PAGE, "page_btn_big_150_ov", "background")
  arrowIcon:AddAnchor("LEFT", cashIcon, "RIGHT", 40, 0)
  local aapointIcon = noticePrice:CreateDrawable(TEXTURE_PATH.INGAME_SHOP, "icon_aa_point", "background")
  aapointIcon:AddAnchor("TOPRIGHT", noticePrice, "BOTTOMRIGHT", -40, 10)
  local moneyGroup = window:CreateChildWidget("emptywidget", "moneyGroup", 0, true)
  moneyGroup:AddAnchor("TOPLEFT", window, "LEFT", 30, 15)
  moneyGroup:AddAnchor("TOPRIGHT", window, "RIGHT", -30, 15)
  moneyGroup:SetHeight(AA_POINT_BUY_MONEY_GROUP_HEIGHT)
  local moneyGroupWidth = moneyGroup:GetWidth()
  local cashToAAPointTitle = moneyGroup:CreateChildWidget("label", "cashToAAPointTitle", 0, true)
  cashToAAPointTitle:AddAnchor("TOPLEFT", moneyGroup, 0, 0)
  cashToAAPointTitle:AddAnchor("TOPRIGHT", moneyGroup, 0, 0)
  cashToAAPointTitle:SetHeight(FONT_SIZE.MIDDLE)
  cashToAAPointTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(cashToAAPointTitle, FONT_COLOR.MIDDLE_TITLE)
  cashToAAPointTitle.style:SetAlign(ALIGN_LEFT)
  cashToAAPointTitle:SetText(locale.inGameShop.cashToAAPoint)
  local forCashIcon = moneyGroup:CreateChildWidget("textbox", "forCashIcon", 0, true)
  forCashIcon:SetExtent(FONT_SIZE.MIDDLE * 2, AA_POINT_BUY_MONEY_DISPLAY_HEIGHT)
  forCashIcon.style:SetFontSize(FONT_SIZE.MIDDLE)
  forCashIcon.style:SetAlign(ALIGN_RIGHT)
  forCashIcon:SetAutoWordwrap(false)
  forCashIcon:SetText(F_MONEY:SettingPriceText("0", PRICE_TYPE_AA_CASH, "|c00FFFFFF"))
  local inputCashToAAPoint = W_CTRL.CreateEdit("inputCashToAAPoint", moneyGroup)
  inputCashToAAPoint:AddAnchor("TOPLEFT", cashToAAPointTitle, "BOTTOMLEFT", 0, 5)
  inputCashToAAPoint:SetExtent(AA_POINT_BUY_MONEY_DISPLAY_WIDTH, DEFAULT_SIZE.EDIT_HEIGHT)
  forCashIcon:AddAnchor("LEFT", inputCashToAAPoint, "RIGHT", -forCashIcon:GetWidth() / 2, 0)
  inputCashToAAPoint:SetMaxTextLength(17)
  inputCashToAAPoint:SetDigit(true)
  ApplyTextColor(inputCashToAAPoint, GetPriceColor(PRICE_TYPE_AA_CASH))
  inputCashToAAPoint.style:SetAlign(ALIGN_RIGHT)
  local inputCashToAAPointBg = moneyGroup:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "artwork")
  inputCashToAAPointBg:AddAnchor("TOPLEFT", inputCashToAAPoint, 0, 0)
  inputCashToAAPointBg:AddAnchor("BOTTOMRIGHT", forCashIcon, 5, 0)
  local wantedAAPoint = moneyGroup:CreateChildWidget("textbox", "wantedAAPoint", 0, true)
  wantedAAPoint:AddAnchor("TOPRIGHT", cashToAAPointTitle, "BOTTOMRIGHT", 0, 5)
  wantedAAPoint:SetExtent(AA_POINT_BUY_MONEY_DISPLAY_WIDTH, AA_POINT_BUY_MONEY_DISPLAY_HEIGHT)
  wantedAAPoint.style:SetFontSize(FONT_SIZE.LARGE)
  wantedAAPoint.style:SetAlign(ALIGN_RIGHT)
  wantedAAPoint:SetAutoWordwrap(false)
  wantedAAPoint:SetText(F_MONEY:SettingPriceText("0", PRICE_TYPE_AA_POINT))
  local wantAAPointBg = wantedAAPoint:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  wantAAPointBg:AddAnchor("RIGHT", wantedAAPoint, FONT_SIZE.LARGE * 2, 0)
  local afterMyCashTitle = moneyGroup:CreateChildWidget("label", "myCashTitle", 0, true)
  afterMyCashTitle:AddAnchor("TOPLEFT", moneyGroup, "LEFT", 0, 0)
  afterMyCashTitle:AddAnchor("TOPRIGHT", moneyGroup, "RIGHT", 0, 0)
  afterMyCashTitle:SetHeight(FONT_SIZE.MIDDLE)
  afterMyCashTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(afterMyCashTitle, FONT_COLOR.MIDDLE_TITLE)
  afterMyCashTitle.style:SetAlign(ALIGN_LEFT)
  afterMyCashTitle:SetText(locale.inGameShop.afterMyCashTitle)
  local afterMyCash = moneyGroup:CreateChildWidget("textbox", "afterMyCash", 0, true)
  afterMyCash:AddAnchor("TOPLEFT", afterMyCashTitle, "BOTTOMLEFT", forCashIcon:GetWidth() / 2, 10)
  afterMyCash:SetExtent(AA_POINT_BUY_MONEY_DISPLAY_WIDTH, AA_POINT_BUY_MONEY_DISPLAY_HEIGHT)
  afterMyCash.style:SetFontSize(FONT_SIZE.MIDDLE)
  afterMyCash.style:SetAlign(ALIGN_RIGHT)
  afterMyCash:SetAutoWordwrap(false)
  afterMyCash:SetText(F_MONEY:SettingPriceText("0", PRICE_TYPE_AA_CASH, FONT_COLOR_HEX.MIDDLE_TITLE))
  local afterMyCashBg = afterMyCash:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  afterMyCashBg:AddAnchor("RIGHT", afterMyCash, FONT_SIZE.MIDDLE * 2, 0)
  local finalAAPoint = moneyGroup:CreateChildWidget("textbox", "finalAAPoint", 0, true)
  finalAAPoint:AddAnchor("TOPRIGHT", afterMyCashTitle, "BOTTOMRIGHT", 0, 10)
  finalAAPoint:SetExtent(AA_POINT_BUY_MONEY_DISPLAY_WIDTH, AA_POINT_BUY_MONEY_DISPLAY_HEIGHT)
  finalAAPoint.style:SetFontSize(FONT_SIZE.LARGE)
  finalAAPoint.style:SetAlign(ALIGN_RIGHT)
  finalAAPoint:SetAutoWordwrap(false)
  finalAAPoint:SetText(F_MONEY:SettingPriceText("0", PRICE_TYPE_AA_POINT, FONT_COLOR_HEX.MIDDLE_TITLE))
  local finalAAPointBg = finalAAPoint:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  finalAAPointBg:AddAnchor("RIGHT", finalAAPoint, FONT_SIZE.LARGE * 2, 0)
  local btnOk = window:CreateChildWidget("button", "btnOk", 0, true)
  btnOk:SetText(locale.inGameShop.buy)
  btnOk:AddAnchor("BOTTOM", window, 0, -10)
  ApplyButtonSkin(btnOk, BUTTON_BASIC.DEFAULT)
  return frameWindow
end
function W_MONEY.CreateAAPointBuyFrame(id, parent)
  local frame = SetViewOfAAPointBuyFrame(id, parent)
  frame.cashUnit = "1"
  frame.aapointUnit = "1"
  function frame.window.btnOk:OnClick()
    local function DialogHandler(wnd)
      wnd:SetTitle(locale.inGameShop.chargeAAPoint)
      wnd:SetContent(locale.inGameShop.askBuyAAPoint)
      function wnd:OkProc()
        X2Player:RequestBuyAAPoint(frame.window.moneyGroup.inputCashToAAPoint:GetText())
        frame:Show(false)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "")
  end
  frame.window.btnOk:SetHandler("OnClick", frame.window.btnOk.OnClick)
  function frame.window.moneyGroup.inputCashToAAPoint:OnTextChanged()
    local value = self:GetText()
    local exchangedData = X2Player:ExchangeCashToAAPoint(value)
    self:SetText(exchangedData.validatedCash)
    frame.window.moneyGroup.wantedAAPoint:SetText(F_MONEY:SettingPriceText(exchangedData.exchangedAAPoint, PRICE_TYPE_AA_POINT))
    frame.window.moneyGroup.afterMyCash:SetText(F_MONEY:SettingPriceText(exchangedData.remainCash, PRICE_TYPE_AA_CASH))
    frame.window.moneyGroup.finalAAPoint:SetText(F_MONEY:SettingPriceText(exchangedData.finalAAPoint, PRICE_TYPE_AA_POINT))
  end
  frame.window.moneyGroup.inputCashToAAPoint:SetHandler("OnTextChanged", frame.window.moneyGroup.inputCashToAAPoint.OnTextChanged)
  function frame:Update(initialize)
    self.aapointUnit = tostring(X2Player:GetExchangeRatio())
    local cashText = F_MONEY:SettingPriceText(self.cashUnit, PRICE_TYPE_AA_CASH)
    local aapointText = F_MONEY:SettingPriceText(self.aapointUnit, PRICE_TYPE_AA_POINT)
    self.window.noticePrice:SetText(locale.inGameShop.GetChangeRatioText(cashText, aapointText))
    if initialize == true then
      self.window.moneyGroup.inputCashToAAPoint:SetText(self.cashUnit)
    end
  end
  function frame:ShowProc()
    self.window:Show(true)
    if parent.waiting ~= nil and parent.waiting:IsVisible() == true then
      parent.waiting:Raise()
    end
    self:Update(true)
  end
  function frame:OnHide()
    self.window:Show(false)
    if frame.target ~= nil then
      frame.target:EnablePick(true)
    end
    self.window.moneyGroup.inputCashToAAPoint:SetText("0")
  end
  frame:SetHandler("OnHide", frame.OnHide)
  function frame.window:OnClose()
    frame:Show(false)
  end
  function frame.ShowAAPointBuyFrame(target)
    frame:AddAnchor("TOPLEFT", target, 0, 0)
    frame:AddAnchor("BOTTOMRIGHT", target, 0, 0)
    frame:Show(true)
    frame.window:AddAnchor("CENTER", frame, 0, 0)
    frame.target = target
    target:EnablePick(false)
  end
  frame:Show(false)
  return frame
end
function GetAAPointBuyFrame()
  if aapointBuyFrame == nil then
    aapointBuyFrame = W_MONEY.CreateAAPointBuyFrame("aapointAABuyFrame", "UIParent")
  end
  return aapointBuyFrame
end
function GetPointStr(pointType, pointAmount)
  if type(pointAmount) == "number" then
    pointAmount = tostring(pointAmount)
  end
  local pointTable = {
    livingPoint = function(pointAmount)
      return string.format("|l%s;", pointAmount)
    end,
    exp = function(pointAmount)
      return string.format("|,%s;", pointAmount)
    end,
    aaPoint = function(pointAmount)
      return string.format("|p%s;", pointAmount)
    end,
    money = function(pointAmount)
      return string.format("|m%s;", pointAmount)
    end,
    honorPoint = function(pointAmount)
      return string.format("|h%s;", pointAmount)
    end,
    dishonorPoint = function(pointAmount)
      return string.format("%s", pointAmount)
    end,
    contributionPoint = function(pointAmount)
      return string.format("|w%s;", pointAmount)
    end,
    leadershipPoint = function(pointAmount)
      return string.format("%s", pointAmount)
    end
  }
  if pointTable[pointType] == nil then
    return pointAmount
  else
    return pointTable[pointType](pointAmount)
  end
end
function GetPointTitleStr(pointType)
  local strTable = {
    livingPoint = GetUIText(MONEY_TEXT, "living_point"),
    exp = GetUIText(COMMON_TEXT, "exp"),
    aaPoint = GetUIText(QUEST_TEXT, "rewardAAPoint"),
    honorPoint = GetUIText(COMMON_TEXT, "honor_point"),
    dishonorPoint = GetUIText(MONEY_TEXT, "dishonor_name"),
    contributionPoint = GetUIText(MONEY_TEXT, "contribution_point"),
    leadershipPoint = GetUIText(COMMON_TEXT, "leadership_point")
  }
  if strTable[pointType] == nil then
    return pointType
  else
    return strTable[pointType]
  end
end
function CreatePointFrame(id, parent)
  local pointFrame = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = pointFrame:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
  bg:AddAnchor("LEFT", pointFrame, 0, 0)
  bg:AddAnchor("RIGHT", pointFrame, 0, 0)
  pointFrame:SetHeight(bg:GetHeight())
  local title = pointFrame:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:AddAnchor("LEFT", pointFrame, 0, 0)
  ApplyTextColor(title, FONT_COLOR.DEFAULT)
  local point = pointFrame:CreateChildWidget("textbox", "point", 0, true)
  point:SetExtent(100, FONT_SIZE.MIDDLE)
  point:SetAutoWordwrap(false)
  point:AddAnchor("RIGHT", pointFrame, 0, 0)
  point.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(point, FONT_COLOR.DEFAULT)
  function pointFrame:SetPoint(pointType, curPoint, needPoint)
    title:SetText(GetPointTitleStr(pointType))
    point:SetText(GetPointStr(pointType, curPoint))
    point:SetWidth(point:GetLongestLineWidth() + 15)
    if tonumber(needPoint) < tonumber(curPoint) then
      ApplyTextColor(point, FONT_COLOR.RED)
    else
      ApplyTextColor(point, FONT_COLOR.DEFAULT)
    end
    self:SetWidth(point:GetLongestLineWidth() + title:GetWidth() + MARGIN.WINDOW_SIDE * 2)
  end
  return pointFrame
end
