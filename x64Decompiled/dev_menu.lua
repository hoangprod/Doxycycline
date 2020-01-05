local CreateEquipWnd = function(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd.slots = {}
  local setBtn = wnd:CreateChildWidget("button", "setBtn", 0, true)
  setBtn:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  ApplyButtonSkin(setBtn, BUTTON_BASIC.DEFAULT)
  setBtn:SetHeight(25)
  setBtn:SetText("Cloth Pack")
  setBtn:Show(true)
  local clothpack = W_CTRL.CreateEdit("clothpack", wnd)
  clothpack:SetExtent(100, setBtn:GetHeight())
  clothpack:AddAnchor("RIGHT", setBtn, "LEFT", 0, 0)
  local slots = {
    ES_COSPLAY,
    ES_HEAD,
    ES_CHEST,
    ES_HANDS,
    ES_LEGS,
    ES_FEET
  }
  for i = 1, #slots do
    do
      local equipSlot = slots[i]
      local itemBtn = CreateItemIconButton("itemBtn" .. tostring(i), wnd)
      itemBtn:SetExtent(ICON_SIZE.BUFF, ICON_SIZE.BUFF)
      itemBtn:AddAnchor("TOPLEFT", wnd, 0, (i - 1) * (ICON_SIZE.BUFF + 2))
      wnd.slots[i] = itemBtn
      for j = 1, #PLAYER_EQUIP_SLOTS do
        if PLAYER_EQUIP_SLOTS[j] == equipSlot then
          F_SLOT.ApplySlotSkin(itemBtn, itemBtn.back, SLOT_STYLE.EQUIP_ITEM[j])
        end
      end
      local itemFilter = W_CTRL.CreateComboBox("itemFilter", itemBtn)
      itemFilter:AddAnchor("LEFT", itemBtn, "RIGHT", 3, 0)
      itemFilter:SetWidth(400 - ICON_SIZE.BUFF - 3)
      itemFilter:SetVisibleItemCount(10)
      local datas = {}
      local firstData = {
        text = "",
        value = 0,
        color = FONT_COLOR.DEFAULT,
        disableColor = FONT_COLOR.GRAY,
        useColor = true,
        enable = true
      }
      table.insert(datas, data)
      local itemList = X2LoginCharacter:GetEquipItemList(equipSlot)
      if itemList ~= nil then
        local data = {
          text = string.format("%d. %s", itemList[k].type, itemList[k].name),
          value = itemList[k].type
        }
        table.insert(datas, data)
      end
      itemFilter:AppendItems(datas, false)
      function itemFilter:SelectedProc(index)
        if index == 1 then
          X2LoginCharacter:SetEquipedItem(equipSlot, 0)
        else
          local info = self:GetSelectedInfo()
          if info ~= nil then
            X2LoginCharacter:SetEquipedItem(equipSlot, info.value)
          end
        end
      end
    end
  end
  wnd:SetExtent(400, #slots * (ICON_SIZE.BUFF + 2) + setBtn:GetHeight() + 5)
  function setBtn:OnClick()
    local clothType = clothpack:GetText()
    if tonumber(clothType) > 0 then
      X2LoginCharacter:SetClothPack(tonumber(clothType))
      wnd:Update()
    end
  end
  setBtn:SetHandler("OnClick", setBtn.OnClick)
  function wnd:Update()
    for i = 1, #slots do
      local equipSlot = slots[i]
      local slot = wnd.slots[i]
      slot:Init()
      slot:SetItemInfo(nil)
      if slot.filter.itemList ~= nil then
        local currentItem = X2LoginCharacter:GetEquipedItem(equipSlot)
        local currentIndex = 1
        for k = 1, #slot.filter.itemList do
          if slot.filter.itemList[k].type == currentItem then
            local info = X2Item:GetItemInfoByType(currentItem)
            slot:SetItemInfo(info)
            currentIndex = k + 1
            break
          end
        end
        slot.filter:Select(currentIndex)
      end
    end
  end
  return wnd
end
function CreateDevButton(id, parent)
  local btn = parent:CreateChildWidget("button", id, 0, true)
  ApplyButtonSkin(btn, BUTTON_HUD.TOGGLE_CONVENIENCE)
  local devWnd = parent:CreateChildWidget("emptywidget", "devWnd", 0, true)
  devWnd:SetExtent(400, 212)
  devWnd:AddAnchor("BOTTOMRIGHT", btn, "BOTTOMLEFT", 0, 0)
  devWnd:Show(false)
  btn.devWnd = devWnd
  local slider = CreateSlider("TODslider", devWnd)
  slider:SetExtent(300, 26)
  slider:SetMinThumbLength(12)
  slider:SetMinMaxValues(0, 1440)
  slider:AddAnchor("TOPRIGHT", devWnd, "TOPRIGHT", 0, 0)
  local timeLabel = devWnd:CreateChildWidget("label", "timeLabel", 0, true)
  timeLabel:SetHeight(FONT_SIZE.XLARGE)
  timeLabel:SetAutoResize(true)
  timeLabel:AddAnchor("RIGHT", slider, "LEFT", 0, 0)
  timeLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  local equipWnd = CreateEquipWnd("equipWnd", devWnd)
  equipWnd:AddAnchor("BOTTOM", devWnd, "BOTTOM")
  function slider:OnSliderChanged(value)
    local hour = math.floor(value / 60)
    local minute = value % 60
    X2LoginCharacter:SetLoginStageTOD(hour, minute)
    timeLabel:SetText(string.format("%02d\236\139\156 %02d\235\182\132", hour, minute))
  end
  slider:SetHandler("OnSliderChanged", slider.OnSliderChanged)
  function btn:Update()
    local hour, minute = X2LoginCharacter:GetLoginStageTOD()
    slider:SetInitialValue(hour * 60 + minute, false)
    timeLabel:SetText(string.format("%02d\236\139\156 %02d\235\182\132", hour, minute))
    equipWnd:Update()
  end
  function btn:OnClick()
    if devWnd:IsVisible() then
      devWnd:Show(false)
    else
      btn:Update()
      devWnd:Show(true)
    end
  end
  btn:SetHandler("OnClick", btn.OnClick)
  return btn
end
