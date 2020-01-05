local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function SetViewOfCMDWindow(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  window:SetHeight(60)
  window:AddAnchor("BOTTOMLEFT", parent, sideMargin, -sideMargin)
  window:AddAnchor("BOTTOMRIGHT", parent, -sideMargin, -sideMargin)
  if X2Bag:GetCurrency() ~= CURRENCY_GOLD then
    local totalMoneyTitle = window:CreateChildWidget("label", "totalMoneyTitle", 0, true)
    totalMoneyTitle:SetAutoResize(true)
    totalMoneyTitle:SetHeight(FONT_SIZE.MIDDLE)
    ApplyTextColor(window.totalMoneyTitle, FONT_COLOR.TITLE)
    totalMoneyTitle:AddAnchor("TOPLEFT", window, 0, 15)
    local playerMoneyTitle = window:CreateChildWidget("label", "playerMoneyTitle", 0, true)
    playerMoneyTitle:SetAutoResize(true)
    playerMoneyTitle:SetHeight(FONT_SIZE.MIDDLE)
    ApplyTextColor(window.playerMoneyTitle, FONT_COLOR.TITLE)
    playerMoneyTitle:AddAnchor("TOPLEFT", window.totalMoneyTitle, "BOTTOMLEFT", 0, 17)
    local totalAAPoint = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".totalAAPoint", window, GetUIText(MONEY_TEXT, "aa_point"), "vertical")
    totalAAPoint:Show(true)
    totalAAPoint:SetWidth(150)
    totalAAPoint:AddAnchor("BOTTOMLEFT", totalMoneyTitle, "BOTTOMRIGHT", 10, 10)
    window.totalAAPoint = totalAAPoint
    local playerAAPoint = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".playerAAPoint", window, "", "vertical")
    playerAAPoint:Show(true)
    playerAAPoint:AddAnchor("RIGHT", totalAAPoint, 0, 30)
    playerAAPoint:SetWidth(150)
    window.playerAAPoint = playerAAPoint
    local totalMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".totalMoney", window, "", "vertical")
    totalMoney:Show(true)
    totalMoney:AddAnchor("BOTTOMLEFT", totalAAPoint, "BOTTOMRIGHT", 10, 0)
    totalMoney:SetWidth(150)
    window.totalMoney = totalMoney
    local playerMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".playerMoney", window, "", "vertical")
    playerMoney:Show(true)
    playerMoney:AddAnchor("BOTTOMLEFT", playerAAPoint, "BOTTOMRIGHT", 10, 0)
    playerMoney:SetWidth(150)
    window.playerMoney = playerMoney
  else
    local totalMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".totalMoney", window, locale.store.buyTotalMoney)
    totalMoney:Show(true)
    totalMoney:AddAnchor("TOPLEFT", window, 5, 0)
    window.totalMoney = totalMoney
    local playerMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".playerMoney", window, locale.store.sell_left_money)
    playerMoney:Show(true)
    playerMoney:AddAnchor("BOTTOMLEFT", window, 5, 0)
    window.playerMoney = playerMoney
    window.totalMoneyTitle = totalMoney.title
    window.playerMoneyTitle = playerMoney.title
  end
  if baselibLocale.showMoneyTooltip then
    if totalAAPoint ~= nil then
      function totalAAPoint:OnEnter()
        SetTooltip(locale.moneyTooltip.aapoint, self)
      end
      totalAAPoint:SetHandler("OnEnter", totalAAPoint.OnEnter)
      function totalAAPoint:OnLeave()
        HideTooltip()
      end
      totalAAPoint:SetHandler("OnLeave", totalAAPoint.OnLeave)
    end
    if totalMoney ~= nil then
      function totalMoney:OnEnter()
        SetTooltip(locale.moneyTooltip.money, self)
      end
      totalMoney:SetHandler("OnEnter", totalMoney.OnEnter)
      function totalMoney:OnLeave()
        HideTooltip()
      end
      totalMoney:SetHandler("OnLeave", totalMoney.OnLeave)
    end
  end
  local submitButton = window:CreateChildWidget("button", "submitButton", 0, true)
  submitButton:SetText(locale.store.buyAll)
  submitButton:AddAnchor("BOTTOMRIGHT", window, 0, 5)
  ApplyButtonSkin(submitButton, BUTTON_BASIC.DEFAULT)
  local drainButton = window:CreateChildWidget("button", "drainButton", 0, true)
  drainButton:Show(true)
  drainButton:AddAnchor("BOTTOMRIGHT", submitButton, "TOPRIGHT", 0, -3)
  ApplyButtonSkin(drainButton, BUTTON_BASIC.REMOVE)
  drainButton:SetSounds("store_drain")
  return window
end
