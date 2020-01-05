function CreateStoreWnd(parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local storeWndHeight = 180
  local wnd = CreateWindow(parent:GetId() .. ".storeWnd", parent)
  wnd:Show(false)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, storeWndHeight)
  wnd:SetTitle(locale.inven.paying_drawing)
  wnd:EnableHidingIsRemove(true)
  wnd:SetCloseOnEscape(true)
  local descTarget
  local moneyEditsWindowOffsetX = 0
  local moneyEditsWindowOffsetY = -5
  local aaPointEditsWindow, moneyEditsWindow, titleText
  local bankCurrency = X2Bank:GetCurrency()
  if bankCurrency == CURRENCY_GOLD_WITH_AA_POINT then
    moneyEditsWindowOffsetX = 20
    moneyEditsWindowOffsetY = -20
    aaPointEditsWindow = W_MONEY.CreateAAPointEditsWindow(wnd:GetId() .. ".aaPointEditsWindow", wnd, GetUIText(MONEY_TEXT, "aa_point"))
    aaPointEditsWindow:AddAnchor("CENTER", wnd, moneyEditsWindowOffsetX, moneyEditsWindowOffsetY)
    aaPointEditsWindow:SetExtent(220, 20)
    aaPointEditsWindow.goldEdit:SetWidth(108)
    aaPointEditsWindow.silverEdit:SetWidth(52)
    aaPointEditsWindow.copperEdit:SetWidth(52)
    descTarget = aaPointEditsWindow
    storeWndHeight = storeWndHeight + aaPointEditsWindow:GetHeight() + 15
    moneyEditsWindowOffsetY = moneyEditsWindowOffsetY + aaPointEditsWindow:GetHeight() + 15
    titleText = GetUIText(REPAIR_TEXT, "myMoney")
  elseif bankCurrency == CURRENCY_AA_POINT then
    aaPointEditsWindow = W_MONEY.CreateAAPointEditsWindow(wnd:GetId() .. ".aaPointEditsWindow", wnd, "")
    aaPointEditsWindow:AddAnchor("CENTER", wnd, moneyEditsWindowOffsetX, moneyEditsWindowOffsetY)
    aaPointEditsWindow:SetExtent(220, 20)
    aaPointEditsWindow.goldEdit:SetWidth(108)
    aaPointEditsWindow.silverEdit:SetWidth(52)
    aaPointEditsWindow.copperEdit:SetWidth(52)
    descTarget = aaPointEditsWindow
  end
  if bankCurrency == CURRENCY_GOLD or bankCurrency == CURRENCY_GOLD_WITH_AA_POINT then
    moneyEditsWindow = W_MONEY.CreateMoneyEditsWindow(wnd:GetId() .. ".moneyEditsWindow", wnd, titleText)
    moneyEditsWindow:AddAnchor("CENTER", wnd, moneyEditsWindowOffsetX, moneyEditsWindowOffsetY)
    moneyEditsWindow:SetExtent(220, 20)
    moneyEditsWindow.goldEdit:SetWidth(108)
    moneyEditsWindow.silverEdit:SetWidth(52)
    moneyEditsWindow.copperEdit:SetWidth(52)
    if descTarget == nil then
      descTarget = moneyEditsWindow
    end
  end
  if baselibLocale.showMoneyTooltip then
    if aaPointEditsWindow ~= nil and aaPointEditsWindow.title ~= nil then
      function aaPointEditsWindow.title:OnEnter()
        SetTooltip(locale.moneyTooltip.aapoint, self)
      end
      aaPointEditsWindow.title:SetHandler("OnEnter", aaPointEditsWindow.title.OnEnter)
      function aaPointEditsWindow.title:OnLeave()
        HideTooltip()
      end
      aaPointEditsWindow.title:SetHandler("OnLeave", aaPointEditsWindow.title.OnLeave)
    end
    if moneyEditsWindow ~= nil and moneyEditsWindow.title ~= nil then
      function moneyEditsWindow.title:OnEnter()
        SetTooltip(locale.moneyTooltip.money, self)
      end
      moneyEditsWindow.title:SetHandler("OnEnter", moneyEditsWindow.title.OnEnter)
      function moneyEditsWindow.title:OnLeave()
        HideTooltip()
      end
      moneyEditsWindow.title:SetHandler("OnLeave", moneyEditsWindow.title.OnLeave)
    end
  end
  local desc = wnd:CreateChildWidget("label", "desc", 0, true)
  desc:SetText(locale.inven.inputAmount)
  desc:SetExtent(150, FONT_SIZE.MIDDLE)
  desc:AddAnchor("BOTTOM", descTarget, "TOP", 0, -5)
  ApplyTextColor(desc, FONT_COLOR.TITLE)
  local withdrawBtn = wnd:CreateChildWidget("button", "withdrawBtn", 0, true)
  withdrawBtn:SetText(locale.inven.withdraw)
  withdrawBtn:AddAnchor("BOTTOM", wnd, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(withdrawBtn, BUTTON_BASIC.DEFAULT)
  function withdrawBtn:OnClick(arg)
    if arg == "LeftButton" then
      local aaPoint = "0"
      if aaPointEditsWindow ~= nil then
        aaPoint = aaPointEditsWindow:GetAmountStr()
      end
      local money = "0"
      if moneyEditsWindow ~= nil then
        money = moneyEditsWindow:GetAmountStr()
      end
      X2Bank:Withdraw(money, aaPoint)
    end
  end
  withdrawBtn:SetHandler("OnClick", withdrawBtn.OnClick)
  local depositBtn = wnd:CreateChildWidget("button", "depositBtn", 0, true)
  depositBtn:SetText(locale.inven.deposit)
  depositBtn:AddAnchor("RIGHT", withdrawBtn, "LEFT", 0, 0)
  ApplyButtonSkin(depositBtn, BUTTON_BASIC.DEFAULT)
  function depositBtn:OnClick(arg)
    if arg == "LeftButton" then
      local aaPoint = "0"
      if aaPointEditsWindow ~= nil then
        aaPoint = aaPointEditsWindow:GetAmountStr()
      end
      local money = "0"
      if moneyEditsWindow ~= nil then
        money = moneyEditsWindow:GetAmountStr()
      end
      X2Bank:Deposit(money, aaPoint)
    end
  end
  depositBtn:SetHandler("OnClick", depositBtn.OnClick)
  local cancelBtn = wnd:CreateChildWidget("button", "cancelBtn", 0, true)
  cancelBtn:SetText(locale.questContext.cancel)
  cancelBtn:AddAnchor("LEFT", withdrawBtn, "RIGHT", 0, 0)
  ApplyButtonSkin(cancelBtn, BUTTON_BASIC.DEFAULT)
  function cancelBtn:OnClick(arg)
    if arg == "LeftButton" then
      wnd:Show(false)
    end
  end
  cancelBtn:SetHandler("OnClick", cancelBtn.OnClick)
  wnd:SetHeight(storeWndHeight)
  local buttonTable = {
    withdrawBtn,
    depositBtn,
    cancelBtn
  }
  AdjustBtnLongestTextWidth(buttonTable)
  return wnd
end
