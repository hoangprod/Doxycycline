local CreateIconSection = function(parent)
  local itemButton = CreateItemIconButton(parent:GetId() .. ".itemButton", parent)
  itemButton:AddAnchor("BOTTOMLEFT", parent, 5, 0)
  itemButton:Raise()
  itemButton.itemType = 0
  parent.itemButton = itemButton
  local width, height = parent:GetExtent()
  local itemNameLabel = parent:CreateChildWidget("label", "itemNameLabel", 0, true)
  itemNameLabel:AddAnchor("LEFT", itemButton, "RIGHT", 6, 0)
  itemNameLabel:SetExtent(width - 55, 44)
  itemNameLabel:SetLimitWidth(true)
  itemNameLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(itemNameLabel, FONT_COLOR.DEFAULT)
end
function SetViewOfMyFarmInfo()
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local w = CreateWindow("myFarminfo")
  w:SetExtent(commonFarmLocale.myFarm.windowWidth, 650)
  w:SetTitle(locale.commonFarm.title)
  w:SetSounds("my_farm_info")
  local farmGroups = X2:GetFarmGroups()
  local tabName = {}
  local farmTypes = {}
  for i = 1, #farmGroups do
    table.insert(tabName, farmGroups[i].name)
    farmTypes[i] = farmGroups[i].type
  end
  w.farmTypes = farmTypes
  local tab = w:CreateChildWidget("tab", "tab", 0, true)
  tab:AddAnchor("TOPLEFT", w, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", w, -sideMargin, -sideMargin)
  tab:SetCorner("TOPLEFT")
  for i = 1, #tabName do
    tab:AddSimpleTab(tabName[i])
  end
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable)
  tab:SetGap(-2)
  DrawTabSkin(tab, tab.window[1], tab.selectedButton[1])
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", tab)
  listCtrl:Show(true)
  listCtrl:AddAnchor("TOPLEFT", tab, 0, 35)
  listCtrl:AddAnchor("BOTTOMRIGHT", tab, 0, 0)
  listCtrl:InsertColumn(commonFarmLocale.myFarm.colWidth[1], LCCIT_WINDOW)
  listCtrl.column[1]:SetText(locale.commonFarm.item)
  listCtrl:InsertColumn(commonFarmLocale.myFarm.colWidth[2], LCCIT_STRING)
  listCtrl.column[2]:SetText(locale.commonFarm.time)
  listCtrl:InsertColumn(commonFarmLocale.myFarm.colWidth[3], LCCIT_STRING)
  listCtrl.column[3]:SetText(locale.commonFarm.area)
  listCtrl:InsertColumn(commonFarmLocale.myFarm.colWidth[4], LCCIT_BUTTON)
  listCtrl.column[4]:SetText(locale.commonFarm.map)
  listCtrl:InsertRows(10, false)
  DrawListCtrlUnderLine(listCtrl)
  for i = 1, #listCtrl.column do
    SettingListColumn(listCtrl, listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(listCtrl.column[i], #listCtrl.column, i)
  end
  for i = 1, #listCtrl.items do
    local bg = CreateContentBackground(listCtrl.items[i], "TYPE8", "black")
    bg:SetVisible(false)
    bg:AddAnchor("TOPLEFT", listCtrl.items[i], -sideMargin * 1.5, -3)
    bg:AddAnchor("BOTTOMRIGHT", listCtrl.items[i], sideMargin / 2, 3)
    listCtrl.items[i].bg = bg
    for j = 1, #listCtrl.column do
      local subItem = listCtrl.items[i].subItems[j]
      if j == 1 then
        CreateIconSection(subItem)
      elseif j == 2 then
        local textBox = subItem:CreateChildWidget("textbox", "textBox", 0, true)
        textBox:AddAnchor("TOPLEFT", subItem, 2, 0)
        textBox:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
        textBox:Show(true)
        textBox:SetInset(0, 5, 0, 0)
        ApplyTextColor(textBox, FONT_COLOR.DEFAULT)
      elseif j == 3 then
        commonFarmLocale:SetMyFarmLocationColumn(subItem)
      elseif j == 4 then
        do
          local mapBtn = subItem:CreateChildWidget("button", "mapBtn", 0, true)
          mapBtn:Show(false)
          mapBtn:Enable(true)
          mapBtn:AddAnchor("CENTER", subItem, 0, 0)
          ApplyButtonSkin(mapBtn, BUTTON_CONTENTS.MAP_OPEN)
          function mapBtn:SetDoodadInfo(farmGroup, farmType, x, y)
            mapBtn.farmGroup = farmGroup
            mapBtn.farmType = farmType
            mapBtn.x = x
            mapBtn.y = y
          end
          function mapBtn:OnClick()
            worldmap:ToggleMapWithCommonFarm(self.farmGroup, self.farmType, self.x, self.y)
          end
          mapBtn:SetHandler("OnClick", mapBtn.OnClick)
        end
      end
    end
  end
  local commonFarmStatus = w:CreateChildWidget("label", "commonFarmStatus", 0, true)
  commonFarmStatus:Show(true)
  commonFarmStatus:SetHeight(15)
  commonFarmStatus:SetAutoResize(true)
  commonFarmStatus:AddAnchor("TOPRIGHT", tab, 0, 10)
  ApplyTextColor(commonFarmStatus, FONT_COLOR.BLUE)
  return w
end
