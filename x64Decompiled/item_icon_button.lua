local SetViewOfItemIconButton = function(id, parent, buttonType)
  local button
  if buttonType == "inventory" then
    button = UIParent:CreateWidget("cooldowninventorybutton", id, parent)
  elseif buttonType == "constant" then
    button = UIParent:CreateWidget("cooldownconstantbutton", id, parent)
  else
    button = parent:CreateChildWidget("button", id, 0, true)
  end
  button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local back = button:CreateNinePartDrawable(TEXTURE_PATH.HUD, "background")
  F_SLOT.ApplySlotSkin(button, back, SLOT_STYLE.BAG_DEFAULT)
  button.back = back
  W_ICON.CreateDestroyIcon(button)
  W_ICON.CreateOverlayStateImg(button)
  W_ICON.CreateDyeingIcon(button)
  W_ICON.CreateLimitLevel(button)
  W_ICON.CreateLookIcon(button)
  W_ICON.CreateOpenPaperItemIcon(button)
  W_ICON.CreateLifeTimeIcon(button)
  W_ICON.CreatePackIcon(button)
  W_ICON.CreateDisableEnchantItemIcon(button)
  W_ICON.CreateLockIcon(button)
  W_ICON.CreateStack(button)
  W_ICON.CreateChainIcon(button)
  return button
end
function CreateItemIconButton(id, parent, buttonType)
  local button = SetViewOfItemIconButton(id, parent, buttonType)
  function button:GetInfo()
    return self.info
  end
  function button:SetItemIcon(itemType, itemGrade, iconInfo)
    if itemType ~= nil and itemGrade ~= nil then
      local icons
      if iconInfo then
        icons = iconInfo
      else
        icons = X2Item:GetItemIconSet(itemType, itemGrade)
      end
      local sideEffect = X2Item:GetItemSideEffect(itemType)
      if icons ~= nil then
        F_SLOT.SetItemIcons(self, icons.itemIcon, icons.overIcon, icons.frameIcon, sideEffect)
        return
      end
    end
    F_SLOT.SetItemIcons(self)
  end
  function button:SetItemInfo(itemInfo)
    self.info = itemInfo
    if itemInfo == nil then
      self:Init()
      return
    end
    local type = itemInfo.itemType
    if itemInfo.lookType ~= nil and itemInfo.lookType ~= 0 then
      type = itemInfo.lookType
    end
    self:SetItemIcon(type, itemInfo.itemGrade, itemInfo.iconInfo)
    if math.floor(self:GetWidth()) <= ICON_SIZE.BUFF then
      return
    end
    self:SetDyeingInfo(itemInfo)
    self:SetLockInfo(itemInfo)
    self:SetPackInfo(itemInfo)
    self:SetDestroyInfo(itemInfo)
    self:SetLookIcon(itemInfo)
    self:SetLifeTimeIcon(itemInfo)
    self:SetPaperInfo(itemInfo)
    self:SetOverlay(itemInfo)
    self:SetDisableEnchantInfo(itemInfo)
    self:SetTooltip(itemInfo)
    self:SetChainInfo(itemInfo)
  end
  function button:SetTooltip(info)
    self.info = info
  end
  local OnEnter = function(self)
    if self.procOnEnter ~= nil then
      self:procOnEnter()
    end
    ShowTooltip(self.info, self)
  end
  button:SetHandler("OnEnter", OnEnter)
  local OnClick = function(self, arg)
    HideTooltip()
    if self.OnClickProc ~= nil then
      self:OnClickProc(arg)
    end
  end
  button:SetHandler("OnClick", OnClick)
  function button:ReregisterClickHandler()
    self:SetHandler("OnClick", OnClick)
  end
  local OnLeave = function()
    HideTooltip()
    HideTextTooltip()
  end
  button:SetHandler("OnLeave", OnLeave)
  function button:Init()
    self:SetTooltip(nil)
    self:SetItemIcon(nil)
    self:SetPackInfo(nil)
    self:SetDestroyInfo(nil)
    self:SetOverlay(nil)
    self:SetPaperInfo(nil)
    self:SetLifeTimeIcon(nil)
    self:ResetStack()
    self:SetDyeingInfo(nil)
    self:SetLookIcon(nil)
    self:SetLifeTimeIcon(nil)
    self:SetPaperInfo(nil)
    self:SetDisableEnchantInfo(nil)
    self:SetChainInfo(nil)
    if HideTooltip ~= nil then
      HideTooltip()
    end
  end
  button:Init()
  return button
end
