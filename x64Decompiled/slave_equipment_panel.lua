function CreateSlaveEquipmentPanel(parent)
  local equipWnd = parent:CreateChildWidget("emptywidget", "equipWnd", 0, true)
  equipWnd:SetExtent(284, 528)
  local slaveBg = equipWnd:CreateImageDrawable(TEXTURE_PATH.DEFAULT, "background")
  slaveBg:AddAnchor("TOPLEFT", equipWnd, 0, 0)
  slaveBg:AddAnchor("BOTTOMRIGHT", equipWnd, 0, 0)
  equipWnd.bg = slaveBg
  equipWnd.slots = {}
  for i = ES_HEAD, ES_COSPLAY do
    local equipSlot = CreateItemIconButton(string.format("equip[%d]", i), equipWnd)
    equipSlot:AddAnchor("CENTER", equipWnd, 0, 0)
    equipSlot:Show(false)
    equipSlot:RegisterForClicks("RightButton")
    equipSlot:Init()
    equipWnd.slots[i] = equipSlot
  end
  function parent:InitEquipment(type)
    changable = nil
    for i = ES_HEAD, ES_COSPLAY do
      local equipSlot = equipWnd.slots[i]
      equipSlot.slotType = nil
      equipSlot:Init()
      equipSlot:RemoveAllAnchors()
      equipSlot:AddAnchor("CENTER", equipWnd, "TOP", 0, 0)
      equipSlot:Show(false)
      F_SLOT.ApplySlotSkin(equipSlot, equipSlot.back, SLOT_STYLE.BAG_DEFAULT)
      equipSlot:ReleaseHandler("OnEvent")
      equipSlot:ReleaseHandler("OnClick")
      equipSlot:ReleaseHandler("OnDragStart")
      equipSlot:ReleaseHandler("OnDragReceive")
    end
    if type == nil then
      return
    end
    local customizing_style = SLAVE_CUSTOMIZING_STYLE[type]
    if customizing_style == nil then
      return
    end
    if customizing_style.path ~= nil then
      local coords = customizing_style.coords
      slaveBg:SetTexture(customizing_style.path)
      slaveBg:SetCoords(coords[1], coords[2], coords[3], coords[4])
      slaveBg:SetVisible(true)
    else
      slaveBg:SetVisible(false)
    end
    local bgOffset = 1
    for i = 1, #customizing_style do
      do
        local styleInfo = customizing_style[i]
        local equipSlot = equipWnd.slots[i]
        equipSlot:RemoveAllAnchors()
        equipSlot:AddAnchor("CENTER", equipWnd, "TOP", styleInfo.posX + bgOffset, styleInfo.posY)
        equipSlot:OverlayInvisible()
        equipSlot.slotType = styleInfo.slotType - 1
        equipSlot.skin = styleInfo.skinInfo
        if parent.SlaveEquipOnClick ~= nil then
          function equipSlot:OnClick(arg)
            parent:SlaveEquipOnClick(arg, equipSlot.slotType)
          end
          equipSlot:SetHandler("OnClick", equipSlot.OnClick)
        end
        if parent.SlaveEquipOnDragStart ~= nil then
          equipSlot:EnableDrag(true)
          function equipSlot:OnDragStart()
            parent:SlaveEquipOnDragStart(equipSlot.slotType)
          end
          equipSlot:SetHandler("OnDragStart", equipSlot.OnDragStart)
        end
        if parent.SlaveEquipOnDragReceive ~= nil then
          function equipSlot:OnDragReceive()
            parent:SlaveEquipOnDragReceive(equipSlot.slotType)
          end
          equipSlot:SetHandler("OnDragReceive", equipSlot.OnDragReceive)
        end
        function equipSlot:Update(reload)
          if reload then
            do
              local slotInfo = parent:GetSlaveEquipSlotInfo(equipSlot.slotType)
              if slotInfo ~= nil and slotInfo.has then
                if slotInfo.itemInfo ~= nil then
                  equipSlot:SetItemInfo(slotInfo.itemInfo)
                  F_SLOT.ApplySlotSkin(equipSlot, equipSlot.back, SLOT_STYLE.BAG_DEFAULT)
                  equipSlot.procOnEnter = nil
                  HideTooltip()
                else
                  equipSlot:Init()
                  F_SLOT.ApplySlotSkin(equipSlot, equipSlot.back, equipSlot.skin)
                  function equipSlot.procOnEnter()
                    SetTargetAnchorTooltip(slotInfo.name, "TOPRIGHT", equipSlot, "BOTTOMLEFT", 10, -10)
                  end
                end
                equipSlot:Show(true)
              else
                equipSlot:Init()
                equipSlot:Show(false)
              end
            end
          end
          if parent.SlaveEquipUpdate ~= nil then
            parent:SlaveEquipUpdate(equipSlot)
          end
        end
        equipSlot:Update(true)
      end
    end
    if parent.SlaveEquipPostInit ~= nil then
      parent:SlaveEquipPostInit()
    end
  end
  equipWnd:SetExtent(284, 528)
  return equipWnd
end
