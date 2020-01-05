MAX_HOUSE_ACTABILITY_COUNT = 20
local SetViewOfDecoActabilitywindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:EnableHidingIsRemove(true)
  window:AddAnchor("TOPRIGHT", parent, POPUP_WINDOW_WIDTH, -4)
  window:SetExtent(POPUP_WINDOW_WIDTH, 360)
  window:SetTitle(locale.housing.maintainWindow.acatbilityUpInfo)
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", window)
  scrollListCtrl:SetExtent(300, 240)
  scrollListCtrl:AddAnchor("TOP", window, 0, titleMargin)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.name)
    else
      subItem:SetText("")
    end
  end
  local NameLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(10, 0, 0, 0)
    subItem.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local ValueDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:Show(true)
      subItem:SetText(data)
    else
      subItem:Show(false)
    end
  end
  local ValueLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(subItem, FONT_COLOR.GREEN)
  end
  scrollListCtrl:SetColumnHeight(0)
  housingLocale:DecoWndInsertColumn(scrollListCtrl, NameDataSetFunc, NameLayoutFunc, ValueDataSetFunc, ValueLayoutFunc)
  scrollListCtrl:InsertRows(MAX_HOUSE_ACTABILITY_COUNT / 2, false)
  local bg = CreateContentBackground(scrollListCtrl, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", scrollListCtrl, -5, -sideMargin / 1.5)
  bg:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 5, sideMargin / 1.5)
  local decoActabilitylabel = window:CreateChildWidget("label", "decoActabilitylabel", 0, true)
  decoActabilitylabel:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  decoActabilitylabel:AddAnchor("BOTTOM", window, 0, bottomMargin / 1.9)
  decoActabilitylabel:SetText(locale.housing.maintainWindow.acatbilityUpMsg)
  ApplyTextColor(decoActabilitylabel, FONT_COLOR.GRAY)
  return window
end
function CreateDecoActabilitywindow(id, parent)
  local window = SetViewOfDecoActabilitywindow(id, parent)
  local scrollListCtrl = window.scrollListCtrl
  local GetItemDetailText = function(info)
    return string.format("%s %s+|,%d;|r", info.name, FONT_COLOR_HEX.SINERGY, info.decoPoint)
  end
  local titleTable = {
    locale.attribute("actability_archemy"),
    locale.attribute("actability_architecture"),
    locale.attribute("actability_cook"),
    locale.attribute("actability_handicraft"),
    locale.attribute("actability_livestock"),
    locale.attribute("actability_farm"),
    locale.attribute("actability_fish"),
    locale.attribute("actability_lumber"),
    locale.attribute("actability_collection"),
    locale.attribute("actability_machinery"),
    locale.attribute("actability_metal"),
    locale.attribute("actability_print"),
    locale.attribute("actability_mine"),
    locale.attribute("actability_stonemason"),
    locale.attribute("actability_sewing"),
    locale.attribute("actability_skin"),
    locale.attribute("actability_weapon"),
    locale.attribute("actability_carpentry"),
    locale.attribute("actability_theft"),
    locale.attribute("actability_business")
  }
  local function GetSubItemTip(index)
    local titleStr
    local str = ""
    if X2House:IsMyHouse() then
      local titleInfo = X2House:GetDecoActabilityPoint(index)
      local info, info2 = X2House:GetDecoActabilityByType(index)
      titleStr = string.format("%s %s |,%d;(+|,%d;)|r", titleTable[info.type], FONT_COLOR_HEX.SINERGY, info.totalPoint, info.totalDecoPoint)
      for i = 1, #info2 do
        if i == #info2 then
          str = string.format("%s %s", str, GetItemDetailText(info2[i]))
        else
          str = string.format("%s %s\n", str, GetItemDetailText(info2[i]))
        end
      end
    else
      local info, info2 = X2House:GetDecoActabilityByType(index)
      for i = 1, #info2 do
        if i == #info2 then
          str = string.format("%s %s", str, GetItemDetailText(info2[i]))
        else
          str = string.format("%s %s\n", str, GetItemDetailText(info2[i]))
        end
      end
    end
    return titleStr, str
  end
  for i = 1, #scrollListCtrl.listCtrl.items do
    for j = 1, #scrollListCtrl.listCtrl.column do
      do
        local subItem = scrollListCtrl.listCtrl.items[i].subItems[j]
        local function OnEnterItem()
          local idx = j % 2 == 0 and j - 1 or j
          local data = scrollListCtrl:GetDataByViewIndex(i, idx)
          if data == nil then
            HideTextTooltip()
            return
          end
          local titleStr, str = GetSubItemTip(data.idx)
          if j == 1 or j == 2 then
            target = scrollListCtrl.listCtrl.items[i].subItems[2]
          elseif j == 3 or j == 4 then
            target = scrollListCtrl.listCtrl.items[i].subItems[4]
          end
          ShowTextTooltip(target, titleStr, str)
        end
        subItem:SetHandler("OnEnter", OnEnterItem)
        local OnLeaveItem = function()
          HideTextTooltip()
        end
        subItem:SetHandler("OnLeave", OnLeaveItem)
      end
    end
  end
  function window:FillList()
    self.scrollListCtrl:DeleteAllDatas()
    local count = X2House:GetActabilityDecoCount()
    if count == nil or count == 0 then
      return
    end
    housingLocale:DecoWndFillList(self.scrollListCtrl, count)
  end
  return window
end
