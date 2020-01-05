local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local AddLootingButtonHandler = function(frame, button, k)
  function button:OnClickProc(arg)
    if arg == "LeftButton" then
      X2Loot:LootItem(k + frame:GetTopDataIndex() - 1)
    end
  end
  local function OnEnterButton(self)
    local tip = X2Loot:GetLootingBagItemTooltipText(k + frame:GetTopDataIndex() - 1)
    ShowTooltip(tip, self, 1, false, 4)
    frame.OnEnterItemRowIndex = k
    frame.OnEnterWidget = button
    frame.prevItemIsMoney = false
    if tip.isMoney ~= nil or tip.isAAPoint ~= nil then
      self.prevItemIsMoney = true
      HideTooltip()
      return
    end
  end
  button:SetHandler("OnEnter", OnEnterButton)
  local function OnLeaveButton()
    HideTooltip()
    frame.OnEnterWidget = nil
    frame.OnEnterItemRowIndex = nil
    frame.prevItemIsMoney = false
  end
  button:SetHandler("OnLeave", OnLeaveButton)
  local function OnClickButtonItemName(self, arg)
    if arg == "LeftButton" then
      X2Loot:LootItem(k + frame:GetTopDataIndex() - 1)
    end
  end
  button.itemName:SetHandler("OnClick", OnClickButtonItemName)
end
local function SetViewOfLootList(id, parent)
  local lootItem = CreateItemIconButton(id .. ".lootItem", parent)
  lootItem.style:SetFontSize(FONT_SIZE.MIDDLE)
  lootItem:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local lootList = CreateEmptyButton(id .. ".lootList", lootItem)
  lootList:AddAnchor("LEFT", lootItem, "RIGHT", -8, 0)
  ApplyButtonSkin(lootList, BUTTON_CONTENTS.LOOT_ITEM_LIST)
  local itemName = UIParent:CreateWidget("textbox", id .. ".itemName", lootList)
  itemName:Show(true)
  itemName:SetExtent(0, ICON_SIZE.DEFAULT)
  itemName.style:SetAlign(ALIGN_LEFT)
  itemName:AddAnchor("LEFT", lootItem, "RIGHT", sideMargin / 2, 0)
  itemName:AddAnchor("RIGHT", parent, "RIGHT", 0, 0)
  itemName.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  itemName.style:SetSnap(true)
  ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
  lootItem.lootList = lootList
  lootItem.itemName = itemName
  return lootItem
end
function SetViewOfLootWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(WINDOW_SIZE.SMALL, 380)
  window:AddAnchor("CENTER", parent, 300, 0)
  window:SetTitle(GetUIText(LOOT_TEXT, "wnd_title"))
  window:EnableHidingIsRemove(true)
  window:SetCloseOnEscape(true)
  window:SetSounds("loot")
  window:Show(true)
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", window)
  scrollListCtrl:RemoveAllAnchors()
  scrollListCtrl:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  scrollListCtrl:AddAnchor("BOTTOMRIGHT", window, -sideMargin + 10, bottomMargin)
  scrollListCtrl:SetUseDoubleClick(true)
  scrollListCtrl.OnEnterWidget = nil
  scrollListCtrl.OnEnterItemRowIndex = nil
  scrollListCtrl.prevItemIsMoney = false
  function scrollListCtrl:OnSliderChangedProc()
    if not self.prevItemIsMoney and not tooltip.tooltipWindows[1]:IsVisible() then
      return
    end
    if self.OnEnterWidget == nil or self.OnEnterItemRowIndex == nil then
      return
    end
    local tip = X2Loot:GetLootingBagItemTooltipText(self.OnEnterItemRowIndex + scrollListCtrl:GetTopDataIndex() - 1)
    if tip.isMoney ~= nil or tip.isAAPoint ~= nil then
      self.prevItemIsMoney = true
      HideTooltip()
      return
    end
    if tip.item_impl ~= "weapon" or tip.item_impl ~= "armor" or tip.item_impl ~= "mate_armor" or tip.item_impl ~= "accessory" then
      tooltip.tooltipWindows[2]:Show(false)
      tooltip.tooltipWindows[3]:Show(false)
    end
    ShowTooltip(tip, self.OnEnterWidget, 1, false, ONLY_BASE)
  end
  local LootItemDataSetFunc = function(subItem, data, setValue)
    if setValue then
      local button = subItem.button
      if data ~= nil then
        button:Show(true)
        if data.money ~= nil then
          button.itemName:SetText(string.format("|m%d;", data.money))
        elseif data.aapoint ~= nil then
          button.itemName:SetText(string.format("|p%d;", data.aapoint))
        else
          local name = lootLocale:GetItemName(data.name)
          button.itemName:SetText(name)
        end
        if data.money ~= nil or data.aapoint ~= nil then
          button:SetStack(0)
        else
          button:SetStack(data.stackSize)
        end
        button:SetItemInfo(data)
      else
        button:Show(false)
        F_SLOT.SetIconBackGround(button, nil)
        button:SetStack(0)
      end
    else
      subItem.button:Show(false)
      subItem.button:SetStack(0)
      F_SLOT.SetIconBackGround(subItem.button, nil)
    end
  end
  local function LootItemLayoutSetFunc(frame, rowIndex, colIndex, subItem)
    local button = SetViewOfLootList(rowIndex, subItem)
    button:RemoveAllAnchors()
    button:AddAnchor("LEFT", subItem, 0, 0)
    button:EnableDrag(true)
    AddLootingButtonHandler(frame, button, rowIndex)
    subItem.button = button
  end
  scrollListCtrl:InsertColumn("", 245, LCCIT_WINDOW, LootItemDataSetFunc, nil, nil, LootItemLayoutSetFunc)
  scrollListCtrl:InsertRows(5, false)
  scrollListCtrl:SetColumnHeight(0)
  scrollListCtrl.listCtrl.AscendingSortMark:SetVisible(false)
  scrollListCtrl.listCtrl.DescendingSortMark:SetVisible(false)
  window.scrollListCtrl = scrollListCtrl
  local allLootBtn = window:CreateChildWidget("button", "allLootBtn", 0, true)
  allLootBtn:SetText(GetUIText(LOOT_TEXT, "all_loot"))
  allLootBtn:AddAnchor("BOTTOM", window, 0, -sideMargin)
  ApplyButtonSkin(allLootBtn, BUTTON_BASIC.DEFAULT)
  return window
end
