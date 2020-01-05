local SafeNumToStr = function(a)
  if type(a) == "number" then
    return X2Util:NumberToString(a)
  end
  return a
end
local function SubNum(left, right)
  left = SafeNumToStr(left)
  right = SafeNumToStr(right)
  return X2Util:StrNumericSub(left, right)
end
local repairWindow
local SetViewOfRepairWindow = function()
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow("repairWindow", "UIParent", "item_repair")
  window:RemoveAllAnchors()
  window:EnableHidingIsRemove(true)
  window:SetExtent(WINDOW_SIZE.SMALL, 400)
  window:SetTitle(GetUIText(REPAIR_TEXT, "ui_title"))
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  local function CreatePart(id, titleStr, buttonStr, imageKey)
    local contentWidth = window:GetWidth() - sideMargin * 2
    local partFrame = window:CreateChildWidget("emptywidget", id, 0, true)
    partFrame:SetWidth(contentWidth)
    local title = partFrame:CreateChildWidget("label", "title", 0, true)
    title:SetAutoResize(true)
    title:SetText(titleStr)
    title:SetHeight(FONT_SIZE.LARGE)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(title, FONT_COLOR.TITLE)
    title:AddAnchor("TOPLEFT", partFrame, 0, 0)
    local decoImg = partFrame:CreateDrawable(TEXTURE_PATH.REPAIR, imageKey, "background")
    partFrame.decoImg = decoImg
    local button = partFrame:CreateChildWidget("button", "button", 0, true)
    button:SetText(buttonStr)
    button:AddAnchor("BOTTOM", partFrame, 0, 0)
    return partFrame
  end
  local str = GetUIText(REPAIR_TEXT, "single_repair")
  local selectionRepairFrame = CreatePart("selectionRepairFrame", str, str, "part_repair")
  selectionRepairFrame:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  local desc = selectionRepairFrame:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  desc:SetWidth(repairLocale.width.partDesc)
  desc:SetText(GetUIText(REPAIR_TEXT, "part_repair_desc"))
  desc:SetHeight(desc:GetTextHeight())
  desc.style:SetAlign(ALIGN_LEFT)
  desc:AddAnchor("TOPLEFT", selectionRepairFrame.title, "BOTTOMLEFT", 0, sideMargin / 1.5)
  ApplyTextColor(desc, FONT_COLOR.DEFAULT)
  selectionRepairFrame.decoImg:AddAnchor("RIGHT", selectionRepairFrame, 0, -sideMargin / 2)
  local w, h = F_LAYOUT.GetExtentWidgets(selectionRepairFrame.title, desc)
  selectionRepairFrame:SetHeight(h + BUTTON_SIZE.DEFAULT_XXLARGE.HEIGHT + sideMargin)
  local line = CreateLine(selectionRepairFrame, "TYPE1")
  line:AddAnchor("TOPLEFT", selectionRepairFrame, "BOTTOMLEFT", 0, sideMargin / 1.5)
  line:AddAnchor("TOPRIGHT", selectionRepairFrame, "BOTTOMRIGHT", 0, sideMargin / 1.5)
  local titleStr = GetUIText(REPAIR_TEXT, "equipment_all_repair")
  local btnStr = GetUIText(REPAIR_TEXT, "equipment_repair")
  local totalRepairFrame = CreatePart("totalRepairFrame", titleStr, btnStr, "all_repair")
  totalRepairFrame:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 0, sideMargin / 1.5)
  local repairCost = W_MONEY.CreateTitleMoneyWindow("repairCost", totalRepairFrame, GetUIText(REPAIR_TEXT, "repair_cost"), "vertical")
  repairCost:SetWidth(150)
  repairCost:AddAnchor("TOPLEFT", totalRepairFrame.title, "BOTTOMLEFT", 0, sideMargin / 1.5)
  totalRepairFrame.repairCost = repairCost
  W_ICON.DrawMinusDingbat(repairCost.money)
  totalRepairFrame.decoImg:AddAnchor("TOPLEFT", repairCost, "TOPRIGHT", sideMargin / 2, sideMargin / 2)
  local leftMoney = W_MONEY.CreateTitleMoneyWindow("leftMoney", totalRepairFrame, GetUIText(REPAIR_TEXT, "left_money"), "vertical")
  leftMoney:SetWidth(150)
  leftMoney:AddAnchor("TOPLEFT", repairCost, "BOTTOMLEFT", 0, sideMargin / 2)
  totalRepairFrame.leftMoney = leftMoney
  local w, h = F_LAYOUT.GetExtentWidgets(totalRepairFrame.title, leftMoney)
  totalRepairFrame:SetHeight(h + BUTTON_SIZE.DEFAULT_XXLARGE.HEIGHT + sideMargin / 1.5)
  ApplyButtonSkin(selectionRepairFrame.button, BUTTON_BASIC.DEFAULT)
  ApplyButtonSkin(totalRepairFrame.button, BUTTON_BASIC.DEFAULT)
  local buttonTable = {
    selectionRepairFrame.button,
    totalRepairFrame.button
  }
  AdjustBtnLongestTextWidth(buttonTable)
  window:SetHeight(titleMargin + selectionRepairFrame:GetHeight() + totalRepairFrame:GetHeight() + sideMargin * 2.4)
  return window
end
local function CreateRepairWindow()
  local window = SetViewOfRepairWindow()
  function window:Update()
    self.totalRepairFrame.repairCost:Update(X2Item:RepairAllCost())
    local leftMoney = SubNum(X2Util:GetMyMoneyString(), X2Item:RepairAllCost())
    self.totalRepairFrame.leftMoney:Update(leftMoney)
  end
  function window:ShowProc()
    self:Update()
  end
  local function OnHide()
    X2Item:LeaveRepairMode()
    repairWindow = nil
  end
  window:SetHandler("OnHide", OnHide)
  local SelectionRepairBtnLeftClickFunc = function()
    if X2Item:IsInRepairMode() then
      X2Item:LeaveRepairMode()
    else
      X2Item:EnterRepairMode()
    end
  end
  ButtonOnClickHandler(window.selectionRepairFrame.button, SelectionRepairBtnLeftClickFunc)
  local AllRepairBtnLeftClickFunc = function()
    X2Item:RepairAll()
    X2Item:LeaveRepairMode()
  end
  ButtonOnClickHandler(window.totalRepairFrame.button, AllRepairBtnLeftClickFunc)
  local npcInteractionEvents = {
    BAG_UPDATE = function(widget)
      widget:Update()
    end,
    UNIT_EQUIPMENT_CHANGED = function(widget)
      widget:Update()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    npcInteractionEvents[event](this, ...)
  end)
  RegistUIEvent(window, npcInteractionEvents)
  return window
end
function ToggleRepairWindow(isShow)
  if isShow == nil then
    isShow = repairWindow == nil and true or not repairWindow:IsVisible()
  end
  if isShow and repairWindow == nil then
    repairWindow = CreateRepairWindow()
  end
  if repairWindow ~= nil then
    repairWindow:Show(isShow)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_ITEM_REPAIR, ToggleRepairWindow)
