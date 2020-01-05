function CreateSlotItemButton(id, parent)
  local slot = UIParent:CreateWidget("slot", id, parent)
  slot:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local normalImage = slot:CreateStateDrawable(UI_BUTTON_NORMAL, UOT_NINE_PART_DRAWABLE, TEXTURE_PATH.DEFAULT, "background")
  normalImage:SetTextureInfo("icon_button_bg")
  normalImage:AddAnchor("TOPLEFT", slot, 0, 0)
  normalImage:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  slot.normalImage = normalImage
  local overImage = slot:CreateStateDrawable(UI_BUTTON_HIGHLIGHTED, UOT_NINE_PART_DRAWABLE, TEXTURE_PATH.HUD, "overlay")
  overImage:SetTextureInfo("icon_button_ov")
  overImage:AddAnchor("TOPLEFT", slot, 1, 1)
  overImage:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  local clickImage = slot:CreateStateDrawable(UI_BUTTON_PUSHED, UOT_NINE_PART_DRAWABLE, TEXTURE_PATH.DEFAULT, "background")
  clickImage:SetTextureInfo("icon_button_bg")
  clickImage:AddAnchor("TOPLEFT", slot, 0, 0)
  clickImage:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  W_ICON.CreatePackIcon(slot, "artwork")
  W_ICON.CreateChainIcon(slot, "overlay")
  W_ICON.CreateDyeingIcon(slot, "artwork")
  local stack = slot:CreateTextDrawable(FONT_PATH.DEFAULT, FONT_SIZE.SMALL, "overlay")
  stack:AddAnchor("BOTTOMRIGHT", slot, -4, 1)
  stack:SetExtent(15, 20)
  stack:SetVisible(false)
  stack:SetAlign(ALIGN_RIGHT)
  slot.stack = stack
  function slot:SetStack(stack)
    if type(stack) == "string" then
      stack = tonumber(stack)
    end
    if stack == nil or stack <= 1 then
      slot.stack:SetVisible(false)
      return
    end
    slot.stack:SetText(tostring(stack))
    slot.stack:SetVisible(true)
  end
  function slot:SetItem(itemType, itemGrade, stack)
    if itemType == nil or itemGrade == nil then
      return
    end
    self:EstablishItem(itemType, itemGrade)
    local info = self:GetTooltip()
    self:SetPackInfo(info)
    self:SetDyeingInfo(info)
    self:SetStack(stack)
    self:SetChainInfo(info)
  end
  local OnEnter = function(self)
    local tip = self:GetTooltip()
    ShowTooltip(tip, self, 1, false, ONLY_BASE)
  end
  slot:SetHandler("OnEnter", OnEnter)
  local OnLeave = function(self)
    HideTooltip()
  end
  slot:SetHandler("OnLeave", OnLeave)
  function slot:Init()
    self.stack:SetVisible(false)
    self:SetPackInfo(nil)
    self:SetChainInfo(nil)
  end
  return slot
end
function CreateSlotShapeButton(id, parent, index)
  local widget = parent:CreateChildWidget("button", id, index or 0, true)
  ApplyButtonSkin(widget, BUTTON_BASIC.SLOT_SHAPE)
  local bg = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "background")
  bg:AddAnchor("TOPLEFT", widget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.bg = bg
  F_SLOT.ApplySlotSkin(widget, bg, SLOT_STYLE.DEFAULT)
  local icon = widget:CreateIconImageDrawable(INVALID_ICON_PATH, "artwork")
  icon:SetCoords(0, 0, 48, 48)
  icon:AddAnchor("TOPLEFT", widget, 1, 1)
  icon:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
  widget.icon = icon
  local overlay = widget:CreateColorDrawable(0, 0, 0, 0, "overlay")
  overlay:AddAnchor("TOPLEFT", widget, 1, 1)
  overlay:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
  widget.overlay = overlay
  function widget:ApplySlotSkin(skinInfo)
    F_SLOT.ApplySlotSkin(self, bg, SLOT_STYLE.BAG_DEFAULT)
  end
  function widget:SetOverlayColor(color)
    if color == "red" then
      self.overlay:SetColor(ConvertColor(144), ConvertColor(18), ConvertColor(5), 0.6)
    elseif color == "green" then
      self.overlay:SetColor(ConvertColor(8), ConvertColor(198), ConvertColor(160), 0.5)
    elseif color == "yellow" then
      self.overlay:SetColor(ConvertColor(198), ConvertColor(165), ConvertColor(34), 0.35)
    elseif color == "black" then
      self.overlay:SetColor(0, 0, 0, 0.75)
    end
  end
  function widget:OverlayInvisible()
    local colorTable = self.overlay:GetColor()
    if colorTable[4] ~= 0 then
      self.overlay:SetColor(0, 0, 0, 0)
    end
  end
  function widget:SetEnable(enable)
    self:Enable(enable)
    if not enable then
      widget:SetOverlayColor("black")
    else
      widget:OverlayInvisible()
    end
  end
  function widget:SetIconPath(path)
    self.icon:ClearAllTextures()
    if path ~= nil then
      self.icon:AddTexture(path)
    end
  end
  function widget:SetGrade(grade)
    if self.gradeIcon ~= nil then
      self.gradeIcon:SetVisible(false)
    end
    if grade == nil then
      return
    end
    local iconPath = X2Item:GetItemGradeIconPath(grade)
    if iconPath == nil then
      return
    end
    if self.gradeIcon == nil then
      local gradeIcon = self:CreateIconImageDrawable(iconPath, "artwork")
      gradeIcon:SetCoords(0, 0, 48, 48)
      gradeIcon:AddAnchor("TOPLEFT", self, 1, 1)
      gradeIcon:AddAnchor("BOTTOMRIGHT", self, -1, -1)
      self.gradeIcon = gradeIcon
    end
    self.gradeIcon:SetVisible(true)
    self.gradeIcon:ClearAllTextures()
    self.gradeIcon:AddTexture(iconPath)
  end
  local OnClick = function(self, arg)
    HideTooltip()
    if self.OnClickProc ~= nil then
      self:OnClickProc(arg)
    end
  end
  widget:SetHandler("OnClick", OnClick)
  local OnLeave = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeave)
  return widget
end
