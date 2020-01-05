local offset = {
  [ANCHOR_ORDER.CENTER] = {x = -285, y = 0},
  [ANCHOR_ORDER.TOP] = {x = -285, y = -180},
  [ANCHOR_ORDER.BOTTOM] = {x = -285, y = 180}
}
AnchorManager:Register("lootDice", offset)
local NEXT_LOOT_DICE_ITEM_DELAY_TIME = 500
function DoDiceAction(widget, key, roll)
  if widget.checkBoxState == true then
    local rule = roll == true and DRK_AUTO_ACCEPT or DRK_AUTO_GIVEUP
    X2Team:SetTeamDiceBidRule(rule)
  end
  X2Loot:DoDiceAction(key, roll)
  RequestNextDiceItem()
  function widget:OnScaleAnimeEnd()
    AnchorManager:Unregister("lootDice", self)
    self:Show(false)
  end
  widget:SetHandler("OnScaleAnimeEnd", widget.OnScaleAnimeEnd)
  widget:SetScaleAnimation(1, 0.7, 0.1, 0.1, "CENTER")
  widget:SetAlphaAnimation(1, 0, 0.1, 0.1)
  widget:SetStartAnimation(true, true)
end
function RequestNextDiceItem()
  DelayCall(NEXT_LOOT_DICE_ITEM_DELAY_TIME, function()
    X2Loot:RequestNextDiceItem()
  end)
end
function MakeDiceItemButton(button, itemInfo)
  button:SetItemInfo(itemInfo)
  function button:OnEnter()
    ShowTooltip(itemInfo, self, 1, false, BASE_NO_ANCHOR_OFFSET)
  end
  function button:OnLeave()
    HideTooltip()
  end
  button:SetHandler("OnEnter", button.OnEnter)
  button:SetHandler("OnLeave", button.OnLeave)
end
local SetViewOfLootDiceWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, parent)
  wnd:SetCloseOnEscape(false)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, 220)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetUIText(LOOT_TEXT, "loot_dice_title"))
  local lootDiceItem = CreateItemIconButton(id .. ".lootDiceItem", wnd)
  lootDiceItem.style:SetFontSize(FONT_SIZE.MIDDLE)
  lootDiceItem:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
  lootDiceItem:Show(true)
  wnd.lootDiceItem = lootDiceItem
  local lootDiceItemName = wnd:CreateChildWidget("textbox", "lootDiceItemName", 0, true)
  lootDiceItemName:SetExtent(260, ICON_SIZE.DEFAULT)
  lootDiceItemName:AddAnchor("LEFT", lootDiceItem, "RIGHT", 7, 0)
  lootDiceItemName:Show(true)
  lootDiceItemName.style:SetFontSize(FONT_SIZE.LARGE)
  lootDiceItemName.style:SetAlign(ALIGN_LEFT)
  wnd.lootDiceItemName = lootDiceItemName
  local statusBar = W_BAR.CreateSkillBar(wnd:GetId() .. ".statusBar", wnd)
  statusBar:SetExtent(POPUP_WINDOW_WIDTH - sideMargin * 2, 15)
  statusBar:AddAnchor("TOPLEFT", lootDiceItem, "BOTTOMLEFT", -1, 5)
  wnd.statusBar = statusBar
  local checkBox = CreateCheckButton(wnd:GetId() .. ".checkBox", wnd, nil)
  checkBox:AddAnchor("TOPLEFT", statusBar, "BOTTOMLEFT", 0, 20)
  checkBox:SetButtonStyle("default")
  local textbox = checkBox:CreateChildWidget("textbox", "textbox", 0, true)
  textbox:AddAnchor("LEFT", checkBox, "RIGHT", 0, 0)
  local textboxWidth = wnd:GetWidth() - checkBox:GetWidth() - 40
  textbox:SetWidth(textboxWidth)
  textbox:SetAutoResize(true)
  ApplyTextColor(textbox, FONT_COLOR.DEFAULT)
  textbox.style:SetAlign(ALIGN_LEFT)
  textbox:SetText(locale.diceBidRule.checkBoxTooltip)
  local button = textbox:CreateChildWidget("button", "button", 0, true)
  local insetLeft, insetTop, insetRight, insetBottom = textbox:GetInset()
  local textWidth = textbox:GetTextLength()
  local textHeight = textbox:GetTextHeight()
  button:AddAnchor("TOPLEFT", checkBox, "BOTTOMRIGHT", insetLeft, insetTop)
  button:SetExtent(textWidth, textHeight)
  checkBox.textButton = button
  function button:OnClick()
    if checkBox:IsEnabled() then
      checkBox:SetChecked(not checkBox:GetChecked())
    end
  end
  button:SetHandler("OnClick", button.OnClick)
  wnd.checkBox = checkBox
  wnd.checkBoxState = nil
  local infos = {
    leftButtonStr = GetUIText(LOOT_TEXT, "loot_dice_roll"),
    rightButtonStr = GetUIText(LOOT_TEXT, "loot_dice_giveup"),
    buttonBottomInset = -15
  }
  CreateWindowDefaultTextButtonSet(wnd, infos)
  return wnd
end
local function CreateLootDiceWindow(key, timeStamp, itemLink)
  local wnd = SetViewOfLootDiceWindow(string.format("LootDiceWindow(%d)", key), "UIParent")
  wnd:EnableHidingIsRemove(true)
  local itemInfo = X2Item:InfoFromLink(itemLink)
  MakeDiceItemButton(wnd.lootDiceItem, itemInfo)
  local name = string.format("|c%s%s", itemInfo.gradeColor, itemInfo.name)
  wnd.lootDiceItemName:SetText(name)
  wnd.lootDiceItemName:SetHeight(wnd.lootDiceItemName:GetTextHeight())
  local function LeftButtonLeftClickFunc()
    DoDiceAction(wnd, key, true)
  end
  ButtonOnClickHandler(wnd.leftButton, LeftButtonLeftClickFunc)
  local function RightButtonLeftClickFunc()
    DoDiceAction(wnd, key, false)
  end
  ButtonOnClickHandler(wnd.rightButton, RightButtonLeftClickFunc)
  function wnd:OnUpdate()
    local limit = 60000
    local diff = X2Time:GetUiMsec() - timeStamp
    diff = math.min(diff, limit)
    local ratio = diff / limit
    self.statusBar:SetMinMaxValues(0, 1000)
    self.statusBar:SetValue(1000 - ratio * 1000)
    if ratio >= 1 then
      DoDiceAction(self, key, false)
      self:ReleaseHandler("OnUpdate")
    end
  end
  wnd:SetHandler("OnUpdate", wnd.OnUpdate)
  function wnd:OnHide()
    AnchorManager:Unregister("lootDice", self)
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  function wnd:OnClose()
    DoDiceAction(wnd, key, false)
  end
  function wnd.checkBox:CheckBtnCheckChagnedProc()
    wnd.checkBoxState = self:GetChecked()
  end
  return wnd
end
local function LootDiceEventHandler(key, timeStamp, itemLink)
  local wnd = CreateLootDiceWindow(key, timeStamp, itemLink)
  AnchorManager:Place("lootDice", wnd)
  wnd:SetScaleAnimation(0.7, 1, 0.1, 0.1, "CENTER")
  wnd:SetAlphaAnimation(0.3, 1, 0.1, 0.1)
  wnd:SetStartAnimation(true, true)
  wnd:Show(true)
end
UIParent:SetEventHandler("TRY_LOOT_DICE", LootDiceEventHandler)
function DebugShowLootDiceWindow()
  local itemLinks = {}
  itemLinks[1] = "|i24488,4,00000000002eNm001000004000000000000009400m000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000P1LDG00000;"
  itemLinks[2] = "|i14698,3,00000000001gEG000m000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000G000000000;"
  itemLinks[3] = "|i24498,2,00000000002oNm000W00004000000000000000y00m000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000G000000000;"
  LootDiceEventHandler(0, X2Time:GetUiMsec(), itemLinks[1])
  LootDiceEventHandler(0, X2Time:GetUiMsec(), itemLinks[2])
  LootDiceEventHandler(0, X2Time:GetUiMsec(), itemLinks[3])
end
