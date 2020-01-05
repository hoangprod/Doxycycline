trade = {}
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local SetViewOfTradeItemSlot = function(parent, x, y, gapX, gapY, isMine)
  parent.item = {}
  for k = 1, x do
    for j = 1, y do
      local index = y * k - y + j
      parent.item[index] = CreateItemIconButton("$parent" .. ".item[" .. index .. "]", parent)
      parent.item[index]:AddAnchor("TOPLEFT", parent, (j - 1) * gapX, (k - 1) * gapY)
      parent.item[index]:Show(true)
      if isMine then
        F_SLOT.ApplySlotSkin(parent.item[index], parent.item[index].back, SLOT_STYLE.BAG_DEFAULT)
      end
    end
  end
end
local function CreateTradePanel(parentWnd, id, isMine)
  local tradeModule = W_MODULE:Create(id, parentWnd, WINDOW_MODULE_TYPE.TITLE_BOX)
  tradeModule:SetData({
    align = ALIGN_CENTER,
    fixed_with = 390,
    title_ellipsis = true,
    title = ""
  })
  function tradeModule:SetName(name)
    self:SetData({title = name})
  end
  local tradeBox = tradeModule:CreateChildWidget("emptywidget", "tradeBox", 0, false)
  tradeBox:SetExtent(350, 123)
  tradeModule:AddBody(tradeBox, false)
  local tradeFixer = tradeBox:CreateDrawable(TEXTURE_PATH.HUD, "actionbar_effect", "overlay")
  tradeFixer:SetTextureColor("trade_green")
  tradeFixer:SetExtent(256, 136)
  tradeFixer:AddAnchor("LEFT", tradeBox, -7, 0)
  local tradeSlot = tradeBox:CreateChildWidget("emptywidget", "tradeSlot", 0, false)
  tradeSlot:SetExtent(242, 90)
  tradeSlot:AddAnchor("TOPLEFT", tradeBox, 0, 0)
  SetViewOfTradeItemSlot(tradeSlot, 2, 5, 50, 48)
  tradeModule.tradeSlot = tradeSlot
  if isMine then
    do
      local moneyEditor
      if X2Trade:GetCurrencyForUserTrade() == CURRENCY_AA_POINT then
        moneyEditor = W_MONEY.CreateAAPointEditsWindow("moneyEditor", tradeBox)
      else
        moneyEditor = W_MONEY.CreateMoneyEditsWindow("moneyEditor", tradeBox)
      end
      moneyEditor:AddAnchor("TOPLEFT", tradeSlot, "BOTTOMLEFT", 0, 7)
      moneyEditor:SetExtent(244, 26)
      moneyEditor.goldEdit:SetWidth(132)
      moneyEditor.silverEdit:SetWidth(52)
      moneyEditor.copperEdit:SetWidth(52)
      tradeModule.moneyEditor = moneyEditor
      local tradeDecision = tradeBox:CreateChildWidget("button", "tradeDecision", 0, false)
      ApplyButtonSkin(tradeDecision, BUTTON_CONTENTS.TRADE_CHECK_YELLOW)
      tradeDecision:AddAnchor("RIGHT", tradeBox, -6, 0)
      tradeModule.tradeDecision = tradeDecision
      function tradeModule:SetChecked(isChecked)
        if isChecked == true then
          ApplyButtonSkin(tradeDecision, BUTTON_CONTENTS.TRADE_CHECK_GREEN)
        else
          ApplyButtonSkin(tradeDecision, BUTTON_CONTENTS.TRADE_CHECK_YELLOW)
        end
        tradeFixer:Show(isChecked)
      end
      tradeModule:SetName(locale.trade.myStuff)
    end
  else
    do
      local moneyModule = W_MODULE:Create("moneyModule", tradeBox, WINDOW_MODULE_TYPE.VALUE_BOX)
      moneyModule:SetExtent(242, 24)
      moneyModule:AddAnchor("TOPLEFT", tradeSlot, "BOTTOMLEFT", 0, 7)
      tradeModule.moneyModule = moneyModule
      local moneyModuleSetting = {
        showTitle = false,
        currency = X2Trade:GetCurrencyForUserTrade() == CURRENCY_AA_POINT and CURRENCY_AA_POINT or CURRENCY_GOLD,
        type = "cost",
        valueAlign = ALIGN_RIGHT,
        value = 0
      }
      function moneyModule:SetMoney(money)
        moneyModuleSetting.value = money
        self:SetData(moneyModuleSetting)
      end
      moneyModule:SetMoney(0)
      local tradeDecision = tradeBox:CreateDrawable(TEXTURE_PATH.TRADE_YELLOW, "trade_yellow", "artwork")
      tradeDecision:AddAnchor("RIGHT", tradeBox, -13, 0)
      tradeModule.tradeDecision = tradeDecision
      function tradeModule:SetChecked(isChecked)
        if isChecked == true then
          tradeDecision:SetTexture(TEXTURE_PATH.TRADE_GREEN)
          tradeDecision:SetTextureInfo("trade_green")
        else
          tradeDecision:SetTexture(TEXTURE_PATH.TRADE_YELLOW)
          tradeDecision:SetTextureInfo("trade_yellow")
        end
        tradeFixer:Show(isChecked)
      end
    end
  end
  tradeModule:SetChecked(false)
  return tradeModule
end
local function CreateTradeWindow()
  local window = CreateWindow("tradeWnd", "UIParent", "trade")
  window:SetExtent(430, 507)
  window:AddAnchor("LEFT", "UIParent", 5, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "trade"))
  window:SetSounds("trade")
  window:Show(false)
  local targetPanel = CreateTradePanel(window, "targetPanel", false)
  targetPanel:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  window.targetPanel = targetPanel
  local myPanel = CreateTradePanel(window, "myPanel", true)
  myPanel:AddAnchor("TOP", targetPanel, "BOTTOM", 0, 30)
  window.myPanel = myPanel
  local arrow1 = window:CreateDrawable(TEXTURE_PATH.STEP_ARROW, "step_arrow", "artwork")
  local arrow2 = window:CreateDrawable(TEXTURE_PATH.STEP_ARROW, "step_arrow_reversal", "artwork")
  arrow1:SetTextureColor("default")
  arrow2:SetTextureColor("default")
  arrow1:AddAnchor("TOPRIGHT", targetPanel, "BOTTOM", -2, 9)
  arrow2:AddAnchor("TOPLEFT", targetPanel, "BOTTOM", 2, 9)
  local currencyExchangeFee = X2Util:GetCurrencyExchangeFee()
  if currencyExchangeFee > 0 then
    do
      local exchangeFeeModule = W_MODULE:Create("exchangeFeeModule", myPanel, WINDOW_MODULE_TYPE.VALUE_BOX)
      exchangeFeeModule:SetExtent(myPanel:GetWidth(), 24)
      exchangeFeeModule:AddAnchor("TOP", myPanel, "BOTTOM", 0, 0)
      window.exchangeFeeModule = exchangeFeeModule
      local feeModuleSetting = {
        showTitle = true,
        currency = X2Trade:GetCurrencyForUserTrade() == CURRENCY_AA_POINT and CURRENCY_AA_POINT or CURRENCY_GOLD,
        type = "exchange_fee",
        valueAlign = ALIGN_RIGHT,
        guideTooltip = GetUIText(COMMON_TEXT, "currency_exchange_fee_tooltip", tostring(currencyExchangeFee)),
        value = 0
      }
      function exchangeFeeModule:SetMoney(money)
        feeModuleSetting.value = money
        self:SetData(feeModuleSetting)
      end
      exchangeFeeModule:SetMoney(0)
      window:SetHeight(533)
    end
  end
  local tradeBtn = window:CreateChildWidget("button", "tradeBtn", 0, true)
  tradeBtn:Enable(false)
  tradeBtn:SetText(locale.chatChannel.chat_trade)
  tradeBtn:AddAnchor("BOTTOM", window, 0, -sideMargin)
  ApplyButtonSkin(tradeBtn, BUTTON_BASIC.DEFAULT)
  return window
end
trade.window = CreateTradeWindow()
trade.window:Show(false)
