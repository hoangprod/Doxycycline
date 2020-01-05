F_MONEY = {}
F_MONEY.currency = {
  houseTax = X2House:GetCurrencyForTax(),
  auctionBid = X2Auction:GetCurrencyForBid(),
  auctionFee = X2Auction:GetCurrencyForFee(),
  houseSale = X2House:GetCurrencyForHouseSale(),
  abilityChange = X2Ability:GetCurrencyForAbilityChange(),
  skillsReset = X2Ability:GetCurrencyForSkillsReset(),
  siegeAuctionBid = X2Faction:GetSiegeAuctionBidCurrency(),
  heirSkillsReset = X2HeirSkill:GetCurrencyForHeirSkillsReset(),
  abilitySetChange = X2Ability:GetCurrencyForAbilitySetChange()
}
F_MONEY.currency.pipeString = {}
F_MONEY.currency.pipeString[CURRENCY_GOLD] = "|m%s;"
F_MONEY.currency.pipeString[CURRENCY_GOLD_WITH_AA_POINT] = "|m%s;"
F_MONEY.currency.pipeString[CURRENCY_AA_POINT] = "|p%s;"
local currencyPipeString = {
  [CURRENCY_GOLD] = "|m%s;",
  [CURRENCY_GOLD_WITH_AA_POINT] = "|m%s;",
  [CURRENCY_AA_POINT] = "|p%s;",
  [CURRENCY_HONOR_POINT] = "|h%s;",
  [CURRENCY_LIVING_POINT] = "|l%s;",
  [CURRENCY_CONTRIBUTION_POINT] = "|w%s;"
}
function F_MONEY:GetCostStringByCurrency(currency, value)
  if type(value) == "number" then
    value = string.format("%.f", value)
  end
  return string.format(currencyPipeString[currency], value)
end
function F_MONEY:GetTaxString(taxStr, isRebuild)
  if isRebuild == nil then
    isRebuild = false
  end
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.taxItem then
    local count = taxStr
    if isRebuild == false then
      count = tostring(X2House:CountTaxItemForTax(taxStr))
    end
    return string.format("|x%s;", count)
  else
    return string.format(F_MONEY.currency.pipeString[F_MONEY.currency.houseTax], taxStr)
  end
end
local ByteToNumber = function(ch)
  return ch - 48
end
function F_MONEY:RemoveHeadZero(strNum)
  local limit = string.len(strNum)
  local byte, char
  local startIndex = 1
  local strFinalNum = ""
  for i = 1, limit do
    byte = string.byte(strNum, i)
    if ByteToNumber(byte) ~= 0 then
      startIndex = i
      break
    end
  end
  for i = startIndex, limit do
    byte = string.byte(strNum, i)
    strFinalNum = strFinalNum .. string.char(byte)
  end
  return strFinalNum
end
function F_MONEY:GetPriceTextColor(priceType, itemType)
  if priceType == PRICE_TYPE_AA_CASH then
    return componentsLocale.inGameShop.aa_cash_color_hex
  elseif priceType == PRICE_TYPE_AA_POINT then
    return FONT_COLOR_HEX.DEFAULT
  elseif priceType == PRICE_TYPE_BM_MILEAGE then
    return FONT_COLOR_HEX.DEEP_ORANGE
  elseif priceType == PRICE_TYPE_GOLD then
    return FONT_COLOR_HEX.DEFAULT
  elseif priceType == PRICE_TYPE_ITEM then
    if itemType == ISMI_DELPI then
      return FONT_COLOR_HEX.MONEY_ITEM_DELPI
    elseif itemType == ISMI_STAR then
      return FONT_COLOR_HEX.MONEY_ITEM_STAR
    elseif itemType == ISMI_KEY then
      return FONT_COLOR_HEX.MONEY_ITEM_KEY
    elseif itemType == ISMI_NETCAFE then
      return FONT_COLOR_HEX.MONEY_ITEM_NETCAFE
    elseif itemType == ISMI_LORDCOIN then
      return FONT_COLOR_HEX.DEEP_ORANGE
    end
  elseif priceType == PRICE_TYPE_AA_BONUS_CASH then
    return FONT_COLOR_HEX.ROSE_PINK
  elseif priceType == PRICE_TYPE_AA_CASH_AND_BONUS_CASH then
    return componentsLocale.inGameShop.aa_cash_color_hex
  end
  return FONT_COLOR_HEX.BLUE
end
local GetPriceText = function(priceType, itemType, amount)
  if type(amount) == "number" then
    amount = tostring(amount)
  end
  if priceType == PRICE_TYPE_AA_CASH then
    return string.format("|j%s;", amount)
  elseif priceType == PRICE_TYPE_AA_POINT then
    return string.format("|p%s;", amount)
  elseif priceType == PRICE_TYPE_BM_MILEAGE then
    return string.format("|bm%s;", amount)
  elseif priceType == PRICE_TYPE_GOLD then
    return string.format("|m%s;", amount)
  elseif priceType == PRICE_TYPE_ITEM then
    if itemType == ISMI_DELPI then
      return string.format("|se%s;", amount)
    elseif itemType == ISMI_STAR then
      return string.format("|ss%s;", amount)
    elseif itemType == ISMI_KEY then
      return string.format("|sy%s;", amount)
    elseif itemType == ISMI_NETCAFE then
      return string.format("|sf%s;", amount)
    elseif itemType == ISMI_LORDCOIN then
      return string.format("|sl%s;", amount)
    elseif itemType == ISMI_ARCHE_PASS_COIN then
      return string.format("|sa%s;", amount)
    else
      return string.format("%s;", amount)
    end
  elseif priceType == PRICE_TYPE_AA_BONUS_CASH then
    return string.format("|zi%s;", amount)
  elseif priceType == PRICE_TYPE_AA_CASH_AND_BONUS_CASH then
    return string.format("|zl%s;", amount)
  else
    return string.format("|m%s;", amount)
  end
end
function F_MONEY:SettingPriceText(priceText, priceType, color, itemType)
  local strColor
  if color ~= nil then
    strColor = color
  else
    strColor = F_MONEY:GetPriceTextColor(priceType, itemType)
  end
  return string.format("%s%s", strColor, GetPriceText(priceType, itemType, priceText))
end
function F_MONEY:IsPrintableCostFormat(itemType)
  return itemType == ISMI_DELPI or itemType == ISMI_STAR or itemType == ISMI_KEY or itemType == ISMI_NETCAFE or itemType == ISMI_LORDCOIN or itemType == ISMI_ARCHE_PASS_COIN
end
