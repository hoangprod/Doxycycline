local CreateSmeltingSpinner = function(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local extent
  local spinner = W_ETC.CreateSpinner("spinner", wnd)
  spinner:AddAnchor("LEFT", wnd, 0, 0)
  wnd.spinner = spinner
  local maxBtn = wnd:CreateChildWidget("button", "maxBtn", 0, true)
  maxBtn:SetText(GetCommonText("smelting_target_item_max_count"))
  ApplyButtonSkin(maxBtn, BUTTON_BASIC.DEFAULT)
  maxBtn:AddAnchor("LEFT", spinner, "RIGHT", 0, 0)
  local maxValue = 0
  function wnd:SetValue(value)
    spinner.text:SetText(tostring(value))
  end
  function wnd:SetMinMaxValues(min, max)
    spinner:SetMinMaxValues(min, max)
    maxValue = max
  end
  function wnd:SetState(enable)
    spinner:SetEnable(enable)
    maxBtn:Enable(enable)
  end
  function wnd:GetCurValue()
    return spinner:GetCurValue()
  end
  function maxBtn:OnClick()
    wnd:SetValue(maxValue)
  end
  maxBtn:SetHandler("OnClick", maxBtn.OnClick)
  return wnd
end
function CreateResultProb(id, parent, style)
  local result = parent:CreateChildWidget("emptywidget", id, 0, false)
  local labelWidth = parent:GetWidth() / 3
  result:SetExtent(labelWidth, 180)
  local label = parent:CreateChildWidget("label", id .. "_label", 0, true)
  label:SetExtent(labelWidth, LIST_COLUMN_HEIGHT)
  label.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(label, FONT_COLOR.DEFAULT)
  label:AddAnchor("TOPLEFT", result, 0, 0)
  result.label = label
  local item = CreateItemIconButton(id .. "_item", result)
  item:SetExtent(50, 50)
  item:AddAnchor("TOP", label, "BOTTOM", 0, 20)
  result.item = item
  local slotBg = result:CreateDrawable(TEXTURE_PATH.SMELTING_ENCHANT, "slot", "background")
  slotBg:SetExtent(100, 100)
  slotBg:AddAnchor("TOP", item, "TOP", 0, -26)
  result.slotBg = slotBg
  local statusBar = W_BAR.CreateStatusBar("statusBar", result, style)
  statusBar:AddAnchor("BOTTOM", slotBg, 0, 10)
  statusBar:SetMinMaxValues(0, 10)
  result.statusBar = statusBar
  return result
end
function CreateSmeltingResultFrame(id, parent)
  local resultWindow = parent:CreateChildWidget("emptywidget", id, 0, false)
  resultWindow:SetExtent(parent:GetWidth(), 180)
  local bg = CreateContentBackground(resultWindow, "TYPE10", "brown")
  bg:AddAnchor("TOPLEFT", resultWindow, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", resultWindow, 0, 0)
  local labelWidth = parent:GetWidth() / 3
  local resultGreatSuccess = CreateResultProb("resultGreatSuccess", resultWindow, "item_smelting_prob_yellow")
  resultGreatSuccess:AddAnchor("TOPLEFT", bg, 0, 5)
  resultGreatSuccess.label:SetText(GetCommonText("smelting_prob3"))
  resultWindow.resultGreatSuccess = resultGreatSuccess
  local resultSuccess = CreateResultProb("resultSuccess", resultWindow, "item_smelting_prob_blue")
  resultSuccess:AddAnchor("LEFT", resultGreatSuccess, "RIGHT", 0, 0)
  resultSuccess.label:SetText(GetCommonText("smelting_prob2"))
  resultWindow.resultSuccess = resultSuccess
  local resultFail = CreateResultProb("resultFail", resultWindow, "item_smelting_prob_red")
  resultFail:AddAnchor("LEFT", resultSuccess, "RIGHT", 0, 0)
  resultFail.label:SetText(GetCommonText("smelting_prob1"))
  resultWindow.resultFail = resultFail
  resultWindow.resultArray = {}
  resultWindow.resultArray[1] = resultWindow.resultFail
  resultWindow.resultArray[2] = resultWindow.resultSuccess
  resultWindow.resultArray[3] = resultWindow.resultGreatSuccess
  local line = CreateLine(resultWindow, "TYPE1")
  line:AddAnchor("TOPLEFT", resultWindow, 0, 39)
  line:SetExtent(400, 3)
  line:SetColor(1, 1, 1, 0.5)
  local labels = {
    resultGreatSuccess.label,
    resultSuccess.label,
    resultFail.label
  }
  for i = 1, 3 do
    local line = DrawListCtrlColumnSperatorLine(labels[i], #labels, i)
    if line ~= nil then
      line:SetColor(ConvertColor(114), ConvertColor(94), ConvertColor(50), 0.5)
    end
  end
  return resultWindow
end
function SetViewOfSmeltWindow(tabWindow)
  CreateEnchantTabTitle(tabWindow, GetUIText(COMMON_TEXT, "smelting"))
  local commonWidth = tabWindow:GetWidth()
  local deco = tabWindow:CreateDrawable(TEXTURE_PATH.SMELTING_ENCHANT, "effect", "background")
  deco:AddAnchor("TOP", tabWindow, 0, 40)
  local slotTargetItem = CreateTargetSlot(tabWindow, GetCommonText("smelting_target_item"), TEXTURE_PATH.COMMON_ENCHANT, "socket_purple")
  slotTargetItem:AddAnchor("RIGHT", deco, "LEFT", 47, 10)
  ApplyTextColor(slotTargetItem.label, FONT_COLOR.PURPLE)
  local slotEnchantItem = CreateItemEnchantDefaultSlot("slotEnchantItem", tabWindow, GetCommonText("smelting_enchant_item"), FONT_COLOR.BLUE)
  slotEnchantItem:AddAnchor("LEFT", deco, "RIGHT", -47, 10)
  tabWindow.slotEnchantItem = slotEnchantItem
  local bg = tabWindow:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT, "slot_blue", "background")
  bg:AddAnchor("CENTER", slotEnchantItem, 0, -10)
  slotEnchantItem.bg = bg
  local spinnerWnd = CreateSmeltingSpinner("spinnerWnd", tabWindow)
  spinnerWnd:AddAnchor("LEFT", slotTargetItem, "BOTTOMLEFT", -1, 45)
  tabWindow.spinnerWnd = spinnerWnd
  tabWindow.spinnerWnd:SetMinMaxValues(1, 1)
  tabWindow.spinnerWnd:SetValue(1)
  local srcItemSetsFrame = tabWindow:CreateChildWidget("emptywidget", "srcItemSetsFrame", 0, true)
  srcItemSetsFrame:Show(true)
  srcItemSetsFrame:AddAnchor("TOPLEFT", tabWindow, 8, 200)
  local srcItemsTitle = srcItemSetsFrame:CreateChildWidget("label", "srcItemsTitle", 0, false)
  srcItemsTitle:SetAutoResize(true)
  srcItemsTitle:SetHeight(FONT_SIZE.LARGE)
  srcItemsTitle.style:SetFontSize(FONT_SIZE.LARGE)
  srcItemsTitle:SetText(GetUIText(COMMON_TEXT, "material_item"))
  srcItemsTitle:AddAnchor("TOPLEFT", srcItemSetsFrame, 0, 0)
  ApplyTextColor(srcItemsTitle, FONT_COLOR.MIDDLE_TITLE)
  srcItemSetsFrame.items = {}
  local x = 0
  local y = 20
  for i = 1, SOURCE_ITEM_SLOT_MAX do
    local item = CreateItemIconButton("item" .. i, srcItemSetsFrame)
    item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    item:AddAnchor("TOPLEFT", srcItemSetsFrame, x, y)
    x = x + 46
    srcItemSetsFrame.items[i] = item
  end
  local resultFrame = CreateSmeltingResultFrame("resultFrame", tabWindow)
  resultFrame:AddAnchor("TOPLEFT", srcItemSetsFrame, -9, 80)
  tabWindow.resultFrame = resultFrame
  local smeltingTip = tabWindow:CreateChildWidget("textbox", "smeltingTip", 0, true)
  smeltingTip:AddAnchor("BOTTOM", resultFrame, 0, 55)
  smeltingTip:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  ApplyTextColor(smeltingTip, FONT_COLOR.GRAY)
  smeltingTip:SetText(GetCommonText("item_smelting_tip"))
  smeltingTip:Show(false)
  tabWindow.smeltingTip = smeltingTip
  local laborPower = W_CTRL.CreateLabel("laborPower", tabWindow)
  laborPower:AddAnchor("TOP", resultFrame, "BOTTOM", 0, 5)
  laborPower:SetAutoResize(true)
  laborPower:SetHeight(FONT_SIZE.MIDDLE)
  tabWindow.laborPower = laborPower
  local actability = W_CTRL.CreateLabel("actability", tabWindow)
  actability:AddAnchor("TOP", laborPower, "BOTTOM", 0, 10)
  actability:SetAutoResize(true)
  actability:SetHeight(FONT_SIZE.MIDDLE)
  tabWindow.actability = actability
  local money = W_MONEY.CreateTitleMoneyWindow("money", tabWindow, GetUIText(STABLER_TEXT, "cost"), "horizon")
  money:AddAnchor("TOP", actability, "BOTTOM", 0, 5)
  tabWindow.money = money
  local guide = W_ICON.CreateGuideIconWidget(money)
  guide:AddAnchor("LEFT", money, "RIGHT", 5, 0)
  local function OnEnterGuide()
    SetTargetAnchorTooltip(GetCommonText("smelting_money_cost_tooltip"), "BOTTOMLEFT", guide, "TOPRIGHT", -20, -10)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local info = {
    leftButtonStr = GetCommonText("smelting_button"),
    leftButtonLeftClickFunc = function()
      LockUnvisibleTab()
      count = tabWindow.spinnerWnd:GetCurValue()
      X2ItemEnchant:Execute(count)
    end,
    rightButtonLeftClickFunc = function()
      if X2ItemEnchant:IsWorkingEnchant() then
        X2ItemEnchant:StopEnchanting()
      else
        X2ItemEnchant:LeaveItemEnchantMode()
      end
    end
  }
  CreateWindowDefaultTextButtonSet(tabWindow, info)
  tabWindow.leftButton:Enable(false)
end
