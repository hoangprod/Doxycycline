W_ICON = {}
local IsBigTargetIconSize = function(iconSize, targetSize)
  iconSize = iconSize + 0.5
  return targetSize > iconSize
end
function W_ICON.CreateDestroyIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return false
    end
    if info.item_impl == nil or info.dead == nil then
      return false
    end
    if info.item_impl ~= "summon_slave" and info.item_impl ~= "slave_equipment" then
      return false
    end
    return info.dead
  end
  function widget:SetDestroyInfo(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.APPELLAITON) then
      return
    end
    if not ValidInfo(info) then
      if self.destroyIcon ~= nil then
        self.destroyIcon:SetVisible(false)
      end
      return
    end
    if self.destroyIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local destroyIcon = widget:CreateIconImageDrawable("ui/icon/item_slot/broken_slave.dds", layer)
      destroyIcon:SetVisible(false)
      destroyIcon:SetColor(1, 1, 1, 0.8)
      destroyIcon:SetCoords(0, 0, 48, 48)
      destroyIcon:SetExtent(48, 48)
      destroyIcon:AddAnchor("TOPLEFT", widget, 1, 1)
      destroyIcon:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
      widget.destroyIcon = destroyIcon
    end
    self.destroyIcon:SetVisible(true)
  end
  return destroyIcon
end
function W_ICON.CreatePackIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return false
    end
    if info.needsUnpack == nil then
      return false
    end
    return info.needsUnpack
  end
  function widget:SetPackInfo(info)
    if not ValidInfo(info) then
      if self.packIcon ~= nil then
        self.packIcon:SetVisible(false)
      end
      return
    end
    if self.packIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local packIcon = widget:CreateIconImageDrawable("ui/icon/item_slot/packing.dds", layer)
      packIcon:SetVisible(false)
      packIcon:SetCoords(0, 0, 48, 48)
      packIcon:SetExtent(48, 48)
      packIcon:AddAnchor("TOPLEFT", widget, 1, 1)
      packIcon:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
      widget.packIcon = packIcon
    end
    self.packIcon:SetVisible(true)
  end
  return packIcon
end
function W_ICON.CreateLifeTimeIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return
    end
    if info.lifeSpan == nil then
      return
    end
    return info.lifeSpan
  end
  function widget:SetLifeTimeIcon(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.lifeTimeIcon ~= nil then
        self.lifeTimeIcon:SetVisible(false)
      end
      return
    end
    if self.lifeTimeIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local lifeTimeIcon = widget:CreateDrawable(TEXTURE_PATH.HUD, "icon_clock", layer)
      lifeTimeIcon:SetVisible(false)
      lifeTimeIcon:AddAnchor("TOPLEFT", widget, 1, 2)
      widget.lifeTimeIcon = lifeTimeIcon
    end
    self.lifeTimeIcon:SetVisible(true)
  end
  return lifeTimeIcon
end
function W_ICON.CreateLookIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return
    end
    if not info.lookChanged and not info.useAsSkin then
      return false
    end
    return true
  end
  function widget:SetLookIcon(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.lookIcon ~= nil then
        self.lookIcon:SetVisible(false)
      end
      return
    end
    if self.lookIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local lookIcon = widget:CreateDrawable(TEXTURE_PATH.HUD, "material", layer)
      lookIcon:SetVisible(false)
      lookIcon:AddAnchor("BOTTOMLEFT", widget, 1, -2)
      widget.lookIcon = lookIcon
    end
    self.lookIcon:SetVisible(true)
    if info.lookChanged then
      self.lookIcon:SetTextureInfo("complete")
    end
    if info.useAsSkin then
      self.lookIcon:SetTextureInfo("material")
    end
  end
  return lookIcon
end
function W_ICON.CreateLockIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return false
    end
    if info.securityState == nil then
      return false
    end
    if info.securityState == ITEM_SECURITY_UNLOCKED then
      return false
    end
    return true
  end
  function widget:SetLockInfo(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.lockIcon ~= nil then
        self.lockIcon:SetVisible(false)
      end
      return ICON_BUTTON_OVERLAY_COLOR.NONE
    end
    if self.lockIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local lockIcon = widget:CreateDrawable(TEXTURE_PATH.HUD, "unlock_pink", layer)
      lockIcon:SetVisible(false)
      lockIcon:AddAnchor(baselibLocale.itemLock.anchor, widget, 0, 0)
      widget.lockIcon = lockIcon
    end
    self.lockIcon:SetVisible(true)
    if info.securityState == ITEM_SECURITY_LOCKED then
      self.lockIcon:SetTextureInfo(baselibLocale.itemLock.textureName.lock)
    elseif info.securityState == ITEM_SECURITY_UNLOCKING then
      self.lockIcon:SetTextureInfo(baselibLocale.itemLock.textureName.unLock)
    end
    return ICON_BUTTON_OVERLAY_COLOR.BLACK
  end
  return lockIcon
end
function W_ICON.CreateDisableEnchantItemIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return false
    end
    return info.isEnchantDisable or false
  end
  function widget:SetDisableEnchantInfo(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.disableEnchantIcon ~= nil then
        self.disableEnchantIcon:SetVisible(false)
      end
      return
    end
    if self.disableEnchantIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local disableEnchantIcon = widget:CreateIconImageDrawable(TEXTURE_PATH.ITEM_DISABLE_ENCHANT, layer)
      disableEnchantIcon:SetVisible(false)
      disableEnchantIcon:SetCoords(0, 0, 64, 64)
      disableEnchantIcon:SetExtent(widget:GetWidth(), widget:GetHeight())
      disableEnchantIcon:AddAnchor("TOPLEFT", widget, 0, 0)
      widget.disableEnchantIcon = disableEnchantIcon
    end
    self.disableEnchantIcon:SetVisible(true)
  end
  return disableEnchantIcon
end
function W_ICON.CreateDyeingIcon(widget, layer)
  local dyeingInfo
  local function ValidInfo(info)
    if info == nil then
      return false
    end
    if not info.dyeable then
      return
    end
    if info.dyeingColor == nil then
      return
    end
    dyeingInfo = {
      r = ConvertColor(info.dyeingColor.r),
      g = ConvertColor(info.dyeingColor.g),
      b = ConvertColor(info.dyeingColor.b)
    }
    return true
  end
  function widget:SetDyeingInfo(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.dyeingIcon ~= nil then
        self.dyeingIcon:SetVisible(false)
      end
      return
    end
    if self.dyeingIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local dyeingIcon = widget:CreateDrawable(TEXTURE_PATH.HUD, "dyeing", layer)
      dyeingIcon:SetVisible(false)
      dyeingIcon:SetExtent(10, 10)
      dyeingIcon:AddAnchor("TOPRIGHT", widget, -2, 2)
      widget.dyeingIcon = dyeingIcon
    end
    self.dyeingIcon:SetVisible(true)
    self.dyeingIcon:SetColor(dyeingInfo.r, dyeingInfo.g, dyeingInfo.b, 1)
  end
  function widget:SetDirectDyeingInfo(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.dyeingIcon ~= nil then
        self.dyeingIcon:SetVisible(false)
      end
      return
    end
    if self.dyeingIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local dyeingIcon = widget:CreateDrawable(TEXTURE_PATH.HUD, "dyeing", layer)
      dyeingIcon:SetVisible(false)
      dyeingIcon:SetExtent(10, 10)
      dyeingIcon:AddAnchor("TOPRIGHT", widget, -2, 2)
      widget.dyeingIcon = dyeingIcon
    end
    self.dyeingIcon:SetVisible(true)
    self.dyeingIcon:SetColor(dyeingInfo.red, dyeingInfo.green, dyeingInfo.blue, 1)
  end
  return dyeingIcon
end
function W_ICON.CreateStack(widget)
  local layoutInfo = {
    fontSize = FONT_SIZE.SMALL,
    fontColor = nil
  }
  function widget:LayoutStack(info)
    for k, v in pairs(info) do
      layoutInfo[k] = v
    end
  end
  local stackLabel
  function widget:SetStack(stackCount, requireCount, numberOnly)
    stackCount = tonumber(stackCount) or 0
    requireCount = tonumber(requireCount) or 0
    if stackCount <= 1 and requireCount == 0 then
      self:ResetStack()
      return
    end
    if stackLabel == nil then
      stackLabel = widget:CreateChildWidget("label", "stack", 0, false)
      stackLabel:Raise()
      stackLabel:SetAutoResize(true)
      stackLabel.style:SetShadow(true)
      stackLabel.style:SetFontSize(layoutInfo.fontSize)
    end
    stackLabel:RemoveAllAnchors()
    if requireCount ~= 0 then
      stackLabel:AddAnchor("BOTTOM", self, 0, -9)
      stackLabel:SetNumberOnly(false)
      stackLabel:SetText(string.format("%d/%d", stackCount, requireCount))
      if stackCount < requireCount then
        ApplyTextColor(stackLabel, FONT_COLOR.RED)
        self:SetDisableColorWrap(false)
      else
        ApplyTextColor(stackLabel, FONT_COLOR.WHITE)
        self:SetDisableColorWrap(true)
      end
    else
      stackLabel:AddAnchor("BOTTOMRIGHT", self, -4, -9)
      if tonumber(stackCount) <= 1 then
        stackLabel:SetText("")
        return
      end
      if numberOnly == nil then
        numberOnly = true
      end
      stackLabel:SetNumberOnly(numberOnly)
      stackLabel:SetText(tostring(stackCount))
    end
  end
  function widget:ResetStack()
    if stackLabel ~= nil then
      stackLabel:SetText("")
      ApplyTextColor(stackLabel, FONT_COLOR.WHITE)
      self:SetDisableColorWrap(true)
    end
  end
  function widget:SetDisableColorWrap(disable)
    if self.SetDisableColor ~= nil then
      self:SetDisableColor(disable)
    end
  end
  return stack
end
function W_ICON.CreateLimitLevel(widget)
  widget.useExpedtionLevel = false
  local FillItemLevel = function(target, requireLevel, targetLevel)
    if targetLevel < requireLevel then
      target:SetText(GetLevelToString(requireLevel, FONT_COLOR_HEX.RED))
    end
  end
  local FillExpeditionLevel = function(target, requireLevel, targetLevel)
    if targetLevel < requireLevel then
      ApplyTextColor(target, FONT_COLOR.SKYBLUE)
      target:SetText(tostring(requireLevel))
    end
  end
  function widget:UseExpeditionLevel()
    widget.useExpedtionLevel = true
  end
  function widget:ProcessRequireLevelCheck(itemType)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.APPELLAITON) then
      return
    end
    if itemType == nil or itemType == 0 then
      if self.limitLevel ~= nil then
        self.limitLevel:Show(false)
      end
      return ICON_BUTTON_OVERLAY_COLOR.NONE
    end
    local requireLevel = 0
    local targetLevel = 0
    local FillFunc
    local requireLevel = X2Item:GetExpeditionLevelRequirement(itemType) or 0
    if widget.useExpedtionLevel and requireLevel ~= 0 then
      targetLevel = X2Faction:GetMyExpeditionLevel() or 0
      FillFunc = FillExpeditionLevel
    else
      requireLevel = X2Item:GetLevelRequirement(itemType) or 0
      targetLevel = X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player")
      if targetLevel == nil then
        targetLevel = 1
      end
      FillFunc = FillItemLevel
    end
    if requirelevel == 0 then
      if self.limitLevel ~= nil then
        self.limitLevel:Show(false)
      end
      return icon_button_overlay_color.none
    end
    if self.limitLevel == nil then
      local limitLevel = widget:CreateChildWidget("textbox", "limitLevel", 0, true)
      limitLevel:AddAnchor("TOPLEFT", widget, 0, 0)
      limitLevel:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
      limitLevel.style:SetAlign(ALIGN_CENTER)
      limitLevel.style:SetFontSize(FONT_SIZE.LARGE)
      limitLevel:SetAutoResize(false)
      limitLevel:Clickable(false)
      ApplyTextColor(limitLevel, FONT_COLOR.ROSE_PINK)
      limitLevel:Show(false)
      widget.limitLevel = limitLevel
    end
    self.limitLevel:Show(requireLevel > targetLevel)
    FillFunc(self.limitLevel, requireLevel, targetLevel)
    return requireLevel > targetLevel and ICON_BUTTON_OVERLAY_COLOR.BLACK or ICON_BUTTON_OVERLAY_COLOR.NONE
  end
  function widget:AddLimitLevelWidget()
    if self.limitLevel == nil then
      local limitLevel = self:CreateChildWidget("textbox", "limitLevel", 0, true)
      limitLevel:AddAnchor("TOPLEFT", self, 0, 0)
      limitLevel:AddAnchor("BOTTOMRIGHT", self, 0, 0)
      limitLevel.style:SetAlign(ALIGN_CENTER)
      limitLevel.style:SetFontSize(FONT_SIZE.LARGE)
      limitLevel:SetAutoResize(false)
      limitLevel:Clickable(false)
      ApplyTextColor(limitLevel, FONT_COLOR.ROSE_PINK)
      limitLevel:Show(false)
      self.limitLevel = limitLevel
    end
  end
  return limitLevel
end
function W_ICON.CreateChainIcon(widget, layer)
  local ShowIcon = function(info)
    if info == nil then
      return false
    end
    if info.checkUnitReq == nil then
      return false
    end
    return not info.checkUnitReq
  end
  function widget:SetChainInfo(info)
    if not ShowIcon(info) then
      if self.chainIcon ~= nil then
        self.chainIcon:SetVisible(false)
      end
      return
    end
    if self.chainIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local chainIcon = widget:CreateIconImageDrawable("ui/icon/top_disable.dds", layer)
      chainIcon:SetVisible(false)
      chainIcon:SetCoords(0, 0, 48, 48)
      chainIcon:SetExtent(48, 48)
      chainIcon:AddAnchor("TOPLEFT", widget, 1, 1)
      chainIcon:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
      widget.chainIcon = chainIcon
    end
    self.chainIcon:SetVisible(true)
  end
  return chainIcon
end
function W_ICON.CreateOverlayStateImg(widget, layer)
  local function CreateOverlayStateImg()
    if widget.overlay == nil then
      if layer == nil then
        layer = "artwork"
      end
      local overlay = widget:CreateColorDrawable(0, 0, 0, 0, layer)
      overlay:AddAnchor("TOPLEFT", widget, 1, 1)
      overlay:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
      widget.overlay = overlay
    end
  end
  function widget:SetOverlayColor(color)
    CreateOverlayStateImg()
    if color == ICON_BUTTON_OVERLAY_COLOR.RED then
      self.overlay:SetColor(ConvertColor(137), ConvertColor(0), ConvertColor(0), 0.6)
    elseif color == ICON_BUTTON_OVERLAY_COLOR.YELLOW then
      self.overlay:SetColor(ConvertColor(198), ConvertColor(165), ConvertColor(34), 0.35)
    elseif color == ICON_BUTTON_OVERLAY_COLOR.BLACK then
      self.overlay:SetColor(0, 0, 0, 0.5)
    elseif color == ICON_BUTTON_OVERLAY_COLOR.NONE then
      self.overlay:SetColor(0, 0, 0, 0)
    end
  end
  function widget:OverlayInvisible()
    if self.overlay == nil then
      return
    end
    local colorTable = self.overlay:GetColor()
    if colorTable[4] ~= 0 then
      self.overlay:SetColor(0, 0, 0, 0)
    end
  end
  function widget:ProcessDurabilityColor(info)
    if info == nil then
      return ICON_BUTTON_OVERLAY_COLOR.NONE
    end
    local durability = info.durability
    local maxDurability = info.maxDurability
    if maxDurability == nil or maxDurability == 0 then
      return ICON_BUTTON_OVERLAY_COLOR.NONE
    end
    local percent = durability / maxDurability
    if percent > 0.25 then
      return ICON_BUTTON_OVERLAY_COLOR.NONE
    end
    if percent > 0 then
      return ICON_BUTTON_OVERLAY_COLOR.YELLOW
    end
    return ICON_BUTTON_OVERLAY_COLOR.RED
  end
  function widget:SetOverlay(info)
    self:OverlayInvisible()
    if info == nil then
      self:SetLockInfo(nil)
      self:ProcessRequireLevelCheck(nil)
      self:ProcessDurabilityColor(nil)
      return
    end
    local color = ICON_BUTTON_OVERLAY_COLOR.NONE
    local function SetColor(newColor)
      if newColor == ICON_BUTTON_OVERLAY_COLOR.NONE then
        return
      end
      color = newColor
    end
    SetColor(self:SetLockInfo(info))
    SetColor(self:ProcessRequireLevelCheck(info.itemType))
    SetColor(self:ProcessDurabilityColor(info))
    self:SetOverlayColor(color)
  end
  return overlay
end
function W_ICON.CreateOpenPaperItemIcon(widget, layer)
  local ValidInfo = function(info)
    if info == nil then
      return false
    end
    if info.item_impl ~= "open_paper" then
      return false
    end
    return true
  end
  function widget:SetPaperInfo(info)
    if IsBigTargetIconSize(self:GetWidth(), ICON_SIZE.AUCTION) then
      return
    end
    if not ValidInfo(info) then
      if self.paperIcon ~= nil then
        self.paperIcon:SetVisible(false)
      end
      return
    end
    if self.paperIcon == nil then
      if layer == nil then
        layer = "overlay"
      end
      local paperIcon = widget:CreateDrawable(TEXTURE_PATH.HUD, "readable", layer)
      paperIcon:SetVisible(false)
      paperIcon:AddAnchor("BOTTOMLEFT", widget, 2, -2)
      widget.paperIcon = paperIcon
    end
    self.paperIcon:SetVisible(true)
  end
  return paperIcon
end
function W_ICON.CreatePartyIconWidget(widget)
  local icon = widget:CreateChildWidget("emptywidget", "icon", 0, true)
  icon:SetExtent(18, 18)
  icon:Raise()
  local iconTexture = icon:CreateDrawable(TEXTURE_PATH.HUD, "party_blue", "background")
  iconTexture:AddAnchor("TOPLEFT", icon, 0, 0)
  iconTexture:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
  local OnEnter = function(self)
    SetTooltip(locale.expedition.partyPlay, self)
  end
  icon:SetHandler("OnEnter", OnEnter)
  return icon
end
function W_ICON.CreateLootIconWidget(widget)
  local lootIcon = widget:CreateChildWidget("emptywidget", "lootIcon", 0, true)
  lootIcon:SetExtent(13, 16)
  lootIcon:Raise()
  local iconTexture = lootIcon:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "pouch", "background")
  iconTexture:AddAnchor("TOPLEFT", lootIcon, 0, 0)
  iconTexture:AddAnchor("BOTTOMRIGHT", lootIcon, 0, 0)
  local OnEnter = function(self)
    SetTooltip(locale.raid.lootingTip, self)
  end
  lootIcon:SetHandler("OnEnter", OnEnter)
  return lootIcon
end
function W_ICON.CreateGuideIconWidget(widget)
  local guide = widget:CreateChildWidget("emptywidget", "guide", 0, false)
  guide:SetExtent(20, 19)
  local bg = guide:CreateDrawable(TEXTURE_PATH.HUD, "questionmark", "background")
  bg:AddAnchor("TOPLEFT", guide, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", guide, 0, 0)
  return guide
end
function W_ICON.CreateItemIconImage(id, parent)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  widget:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local back = widget:CreateNinePartDrawable(TEXTURE_PATH.HUD, "background")
  F_SLOT.ApplySlotSkin(widget, back, SLOT_STYLE.DEFAULT)
  widget.back = back
  local iconImage = widget:CreateIconImageDrawable(INVALID_ICON_PATH, "artwork")
  iconImage:AddAnchor("TOPLEFT", widget, 1, 1)
  iconImage:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
  widget.iconImage = iconImage
  local gradeImage = widget:CreateIconImageDrawable(INVALID_ICON_PATH, "overlay")
  gradeImage:AddAnchor("TOPLEFT", widget, 1, 1)
  gradeImage:AddAnchor("BOTTOMRIGHT", widget, -1, -1)
  widget.gradeImage = gradeImage
  W_ICON.CreateDestroyIcon(widget)
  W_ICON.CreateOverlayStateImg(widget)
  W_ICON.CreateDyeingIcon(widget)
  W_ICON.CreateLookIcon(widget)
  W_ICON.CreateLifeTimeIcon(widget)
  W_ICON.CreatePackIcon(widget)
  W_ICON.CreateDisableEnchantItemIcon(widget)
  W_ICON.CreateLockIcon(widget)
  W_ICON.CreateChainIcon(widget)
  if baselibLocale.itemSideEffect == true then
    widget.sideEffect = W_ICON.DrawItemSideEffectBackground(widget)
  end
  function widget:SetItemIconImage(itemInfo, grade)
    if itemInfo == nil then
      return
    end
    self:Raise()
    local itemGrade
    if grade == nil then
      itemGrade = itemInfo.itemGrade
    else
      itemGrade = grade
    end
    local iconInfo = X2Item:GetItemIconSet(itemInfo.lookType, itemGrade)
    self.iconImage:ClearAllTextures()
    self.gradeImage:ClearAllTextures()
    self.iconImage:AddTexture(iconInfo.itemIcon)
    if iconInfo.overIcon ~= nil and iconInfo.overIcon ~= INVALID_ICON_PATH then
      self.iconImage:AddTexture(iconInfo.overIcon)
    end
    if iconInfo.frameIcon ~= nil and iconInfo.frameIcon ~= INVALID_ICON_PATH then
      self.gradeImage:AddTexture(iconInfo.frameIcon)
    end
    self:SetDyeingInfo(itemInfo)
    self:SetLockInfo(itemInfo)
    self:SetPackInfo(itemInfo)
    self:SetDestroyInfo(itemInfo)
    self:SetLookIcon(itemInfo)
    self:SetLifeTimeIcon(itemInfo)
    self:SetDisableEnchantInfo(itemInfo)
    self:SetChainInfo(itemInfo)
    if baselibLocale.itemSideEffect == true then
      if itemInfo.sideEffect == true then
        self:Anim_Item_Side_effect(true)
      else
        self:Anim_Item_Side_effect(false)
      end
    end
  end
  return widget
end
function W_ICON.CreateAchievementGradeIcon(widget)
  local gradeIcon = widget:CreateImageDrawable(TEXTURE_PATH.RANKING_GRADE, "artwork")
  gradeIcon:SetVisible(false)
  gradeIcon:SetExtent(0, 19)
  function widget:SetAchievementGrade(grade)
    gradeIcon:SetVisible(false)
    gradeIcon:SetExtent(0, 19)
    if grade == nil or grade < 2 then
      return
    end
    local textureCoords = {
      {
        0,
        0,
        0,
        0
      },
      {
        0,
        0,
        0,
        0
      },
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "grand").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "rare").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "arcane").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "heroic").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "unique").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "celestial").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "divine").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "epic").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "legendary").coords,
      UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "mythic").coords
    }
    local coords = textureCoords[grade]
    gradeIcon:SetCoords(coords[1], coords[2], coords[3], coords[4])
    gradeIcon:SetExtent(coords[3], coords[4])
    gradeIcon:SetVisible(true)
  end
  return gradeIcon
end
function W_ICON.CreateGradeIcon(widget, layer)
  if layer == nil then
    layer = "background"
  end
  local gradeIcon = widget:CreateImageDrawable(TEXTURE_PATH.ITEM_GRADE, layer)
  gradeIcon:SetVisible(false)
  gradeIcon:SetExtent(0, 19)
  function gradeIcon:SetGrade(grade)
    gradeIcon:SetVisible(false)
    gradeIcon:SetExtent(0, 19)
    if grade == nil then
      return
    end
    if grade < 1 then
      grade = 1
    end
    local textureCoords = {
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "normal").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "grand").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "rare").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "arcane").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "heroic").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "unique").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "celestial").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "divine").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "epic").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "legendary").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "mythic").coords,
      UIParent:GetTextureData(TEXTURE_PATH.ITEM_GRADE, "arche").coords
    }
    local coords = textureCoords[grade]
    gradeIcon:SetCoords(coords[1], coords[2], coords[3], coords[4])
    gradeIcon:SetExtent(coords[3], coords[4])
    gradeIcon:SetVisible(true)
  end
  return gradeIcon
end
function W_ICON.CreateQuestGradeMarker(parent)
  local widget = parent:CreateChildWidget("emptywidget", "gradeMarker", 0, true)
  widget:Show(false)
  widget:SetExtent(30, 30)
  local gradeIcon = widget:CreateImageDrawable(TEXTURE_PATH.QUEST_LEVEL, "artwork")
  gradeIcon:AddAnchor("TOPLEFT", widget, 0, 0)
  gradeIcon:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.gradeIcon = gradeIcon
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "quest_grade_tip"), self)
  end
  widget:SetHandler("OnEnter", OnEnter)
  function widget:SetQuestGrade(grade)
    self:Show(false)
    self:SetExtent(30, 30)
    local textureCoords = {
      elite = UIParent:GetTextureData(TEXTURE_PATH.QUEST_LEVEL, "elite").coords,
      boss_c = UIParent:GetTextureData(TEXTURE_PATH.QUEST_LEVEL, "epic").coords,
      boss_b = UIParent:GetTextureData(TEXTURE_PATH.QUEST_LEVEL, "legendary").coords,
      boss_a = UIParent:GetTextureData(TEXTURE_PATH.QUEST_LEVEL, "mythic").coords,
      boss_s = UIParent:GetTextureData(TEXTURE_PATH.QUEST_LEVEL, "mythic").coords
    }
    local coords = textureCoords[grade]
    if coords == nil then
      return
    end
    self.gradeIcon:SetCoords(coords[1], coords[2], coords[3], coords[4])
    self:SetExtent(coords[3], coords[4])
    self:Show(true)
  end
  return widget
end
function W_ICON.DrawRoundDingbat(widget)
  local dingbat = widget:CreateDrawable(TEXTURE_PATH.DEFAULT, "round_dingbat", "background")
  dingbat:SetExtent(13, 12)
  dingbat:AddAnchor("RIGHT", widget, "LEFT", -2, 1)
  widget.dingbat = dingbat
  return dingbat
end
function W_ICON.DrawDingbat(widget, width)
  if width == nil then
    width = -3
  end
  local dingbat = widget:CreateDrawable(TEXTURE_PATH.DINGBAT, "dot", "background")
  dingbat:AddAnchor("RIGHT", widget, "LEFT", width, 0)
  widget.dingbat = dingbat
  return dingbat
end
function W_ICON.DrawMoneyIcon(parent, arg)
  local icon = parent:CreateImageDrawable(TEXTURE_PATH.MONEY_WINDOW, "background")
  icon:SetVisible(true)
  local keys = {
    gold = "money_gold",
    silver = "money_silver",
    copper = "money_copper",
    aapointGold = "aa_point_gold",
    aapointSilver = "aa_point_silver",
    aapointCopper = "aa_point_copper"
  }
  if keys[arg] ~= nil then
    icon:SetTextureInfo(keys[arg])
  end
  return icon
end
function W_ICON.DrawSkillFlameIcon(widget, layer)
  if layer == nil then
    layer = "artwork"
  end
  local flameIcon = widget:CreateDrawable(TEXTURE_PATH.SKILL, "draw_skill_flame_icon", "artwork")
  return flameIcon
end
function W_ICON.DrawItemSideEffectBackground(widget)
  if baselibLocale.itemSideEffect == false then
    return nil
  end
  local bgTime = 0.4
  local itemSideEffectBg = widget:CreateEffectDrawable(TEXTURE_PATH.ITEM_SID_EEFFECT, "artwork")
  itemSideEffectBg:SetVisible(false)
  itemSideEffectBg:SetInternalDrawType("ninepart")
  itemSideEffectBg:SetCoords(GetTextureInfo(TEXTURE_PATH.ITEM_SID_EEFFECT, "icon_frame"):GetCoords())
  local inset = GetTextureInfo(TEXTURE_PATH.ITEM_SID_EEFFECT, "icon_frame"):GetInset()
  itemSideEffectBg:SetInset(inset[1], inset[2], inset[3], inset[4])
  itemSideEffectBg:AddAnchor("TOPLEFT", widget, 0, 0)
  itemSideEffectBg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  widget.itemSideEffectBg = itemSideEffectBg
  itemSideEffectBg:SetRepeatCount(0)
  itemSideEffectBg:SetEffectPriority(1, "alpha", bgTime, bgTime)
  itemSideEffectBg:SetEffectInitialColor(1, 1, 1, 1, 0)
  itemSideEffectBg:SetEffectFinalColor(1, 1, 1, 1, 1)
  itemSideEffectBg:SetEffectPriority(2, "alpha", bgTime, bgTime)
  itemSideEffectBg:SetEffectInitialColor(2, 1, 1, 1, 1)
  itemSideEffectBg:SetEffectFinalColor(2, 1, 1, 1, 0)
  local width, height = widget:GetExtent()
  local light1 = widget:CreateEffectDrawable(TEXTURE_PATH.ITEM_SID_EEFFECT, "artwork")
  light1:SetVisible(false)
  light1:SetCoords(GetTextureInfo(TEXTURE_PATH.ITEM_SID_EEFFECT, "light"):GetCoords())
  light1:SetExtent(width, height)
  light1:AddAnchor("TOPLEFT", widget, 0, 1)
  widget.light1 = light1
  light1:SetMoveEffectType(1, "top", 0, 0.5, 0.7, 0.7)
  light1:SetMoveEffectEdge(1, 0, 1)
  light1:SetEffectPriority(1, "alpha", 0.2, 0.2)
  light1:SetEffectScale(1, 0.455, 0.56, 0.16, 0.175)
  light1:SetEffectInitialColor(1, 1, 1, 1, 0)
  light1:SetEffectFinalColor(1, 1, 1, 1, 1)
  light1:SetEffectPriority(2, "alpha", 0.2, 0.2)
  light1:SetEffectScale(2, 0.56, 0.98, 0.175, 0.175)
  light1:SetEffectInitialColor(2, 1, 1, 1, 1)
  light1:SetEffectFinalColor(2, 1, 1, 1, 1)
  light1:SetEffectPriority(3, "alpha", 0.3, 0.3)
  light1:SetEffectScale(3, 0.98, 0.42, 0.175, 0.16)
  light1:SetEffectInitialColor(3, 1, 1, 1, 1)
  light1:SetEffectFinalColor(3, 1, 1, 1, 0)
  light1:SetMoveEffectType(2, "right", 0.48, 0.5, 0.7, 0.7)
  light1:SetMoveEffectEdge(2, 0, 1)
  light1:SetEffectPriority(4, "alpha", 0.2, 0.2)
  light1:SetEffectScale(4, 0.455, 0.56, 0.16, 0.175)
  light1:SetEffectInitialColor(4, 1, 1, 1, 0)
  light1:SetEffectFinalColor(4, 1, 1, 1, 1)
  light1:SetEffectPriority(5, "alpha", 0.2, 0.2)
  light1:SetEffectScale(5, 0.56, 0.98, 0.175, 0.175)
  light1:SetEffectInitialColor(5, 1, 1, 1, 1)
  light1:SetEffectFinalColor(5, 1, 1, 1, 1)
  light1:SetEffectPriority(6, "alpha", 0.3, 0.3)
  light1:SetEffectScale(6, 0.98, 0.42, 0.175, 0.16)
  light1:SetEffectInitialColor(6, 1, 1, 1, 1)
  light1:SetEffectFinalColor(6, 1, 1, 1, 0)
  local light2 = widget:CreateEffectDrawable(TEXTURE_PATH.ITEM_SID_EEFFECT, "artwork")
  light2:SetVisible(false)
  light2:SetCoords(GetTextureInfo(TEXTURE_PATH.ITEM_SID_EEFFECT, "light"):GetCoords())
  light2:SetExtent(width, height)
  light2:AddAnchor("TOPLEFT", widget, 0, -1)
  widget.light2 = light2
  light2:SetMoveEffectType(1, "bottom", 0, 0.5, 0.7, 0.7)
  light2:SetMoveEffectEdge(1, 1, 0)
  light2:SetEffectPriority(1, "alpha", 0.2, 0.2)
  light2:SetEffectScale(1, 0.455, 0.56, 0.16, 0.175)
  light2:SetEffectInitialColor(1, 1, 1, 1, 0)
  light2:SetEffectFinalColor(1, 1, 1, 1, 1)
  light2:SetEffectPriority(2, "alpha", 0.2, 0.2)
  light2:SetEffectScale(2, 0.56, 0.98, 0.175, 0.175)
  light2:SetEffectInitialColor(2, 1, 1, 1, 1)
  light2:SetEffectFinalColor(2, 1, 1, 1, 1)
  light2:SetEffectPriority(3, "alpha", 0.3, 0.3)
  light2:SetEffectScale(3, 0.98, 0.42, 0.175, 0.16)
  light2:SetEffectInitialColor(3, 1, 1, 1, 1)
  light2:SetEffectFinalColor(3, 1, 1, 1, 0)
  light2:SetMoveEffectType(2, "left", 0.48, 0, 0.7, 0.7)
  light2:SetMoveEffectEdge(2, 1, 0)
  light2:SetEffectPriority(4, "alpha", 0.2, 0.2)
  light2:SetEffectScale(4, 0.455, 0.56, 0.16, 0.175)
  light2:SetEffectInitialColor(4, 1, 1, 1, 0)
  light2:SetEffectFinalColor(4, 1, 1, 1, 1)
  light2:SetEffectPriority(5, "alpha", 0.2, 0.2)
  light2:SetEffectScale(5, 0.56, 0.98, 0.175, 0.175)
  light2:SetEffectInitialColor(5, 1, 1, 1, 1)
  light2:SetEffectFinalColor(5, 1, 1, 1, 1)
  light2:SetEffectPriority(6, "alpha", 0.3, 0.3)
  light2:SetEffectScale(6, 0.98, 0.42, 0.175, 0.16)
  light2:SetEffectInitialColor(6, 1, 1, 1, 1)
  light2:SetEffectFinalColor(6, 1, 1, 1, 0)
  function widget:Anim_Item_Side_effect(isStart)
    if isStart == true then
      if self.itemSideEffectBg:IsVisible() == false then
        self.itemSideEffectBg:SetStartEffect(true)
        self.light1:SetStartEffect(true)
        self.light2:SetStartEffect(true)
      end
    elseif self.itemSideEffectBg:IsVisible() == true then
      self.itemSideEffectBg:SetStartEffect(false)
      self.light1:SetStartEffect(false)
      self.light2:SetStartEffect(false)
    end
  end
  return itemSideEffectBg
end
function W_ICON.CreateArrowIcon(widget, layer)
  if layer == nil then
    layer = "overlay"
  end
  local icon = widget:CreateDrawable(TEXTURE_PATH.HUD, "single_arrow", layer)
  icon:SetTextureColor("brown")
  return icon
end
function W_ICON.DrawMinusDingbat(money_window_widget)
  local minusDingbat = money_window_widget:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "minus_dingbat", "overlay")
  minusDingbat:AddAnchor("LEFT", money_window_widget, 5, -2)
  return minusDingbat
end
function W_ICON.CreateLeaderMark(id, parent)
  local leaderMark = CreateEmptyButton(id .. "leaderMark", parent)
  leaderMark:SetExtent(11, 11)
  local bg = leaderMark:CreateImageDrawable(TEXTURE_PATH.HUD, "background")
  bg:SetExtent(11, 11)
  bg:AddAnchor("CENTER", leaderMark, 0, 0)
  leaderMark.bg = bg
  function leaderMark:SetMarkTexture(style)
    leaderMark:Show(true)
    if style == "leader" then
      bg:SetTextureInfo("leader_icon")
    elseif style == "subleader" then
      bg:SetTextureInfo("sub_leader_icon")
    elseif style == "jointleader" then
      bg:SetTextureInfo("crown_gold_small")
    elseif style == "jointsubleader" then
      bg:SetTextureInfo("crown_silver_small")
    elseif style == "siegeRaidleader" then
      bg:SetTextureInfo("crown_gold_small")
    elseif style == "siegeRaidsubleader" then
      bg:SetTextureInfo("crown_silver_small")
    else
      leaderMark:Show(false)
    end
  end
  function leaderMark:SetMark(grade, showTooltip)
    if grade == nil or grade == "looting" then
      self.grade = ""
      self:Show(false)
      return
    end
    self:Show(true)
    self.grade = grade
    self:SetMarkTexture(grade)
    self.showTooltip = showTooltip
  end
  local text
  local function OnEnter(self)
    if self.showTooltip == true then
      if self.grade == "leader" then
        text = locale.team.leaderTip()
      elseif self.grade == "subleader" then
        text = locale.raid.subleaderTip
      elseif self.grade == "jointleader" then
        text = GetCommonText("raid_joint_owner")
      elseif self.grade == "jointsubleader" then
        text = GetCommonText("raid_joint_officer")
      elseif self.grade == "siegeRaidleader" then
        text = GetCommonText("siege_raid_team_owner")
      elseif self.grade == "siegeRaidsubleader" then
        text = GetCommonText("siege_raid_team_officer")
      end
      SetTooltip(text, self)
    end
  end
  leaderMark:SetHandler("OnEnter", OnEnter)
  return leaderMark
end
local GRADE_ICON_COORDS = {
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "arche").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "mythic").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "legendary").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "epic").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "divine").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "celestial").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "unique").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "heroic").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "arcane").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "rare").coords,
  UIParent:GetTextureData(TEXTURE_PATH.RANKING_GRADE, "grand").coords
}
local GRADE_BG_COLOR = {
  {
    ConvertColor(174),
    ConvertColor(152),
    ConvertColor(254),
    0.15
  },
  {
    ConvertColor(201),
    ConvertColor(11),
    ConvertColor(11),
    0.15
  },
  {
    ConvertColor(191),
    ConvertColor(121),
    ConvertColor(0),
    0.15
  },
  {
    ConvertColor(143),
    ConvertColor(165),
    ConvertColor(202),
    0.15
  },
  {
    ConvertColor(207),
    ConvertColor(125),
    ConvertColor(93),
    0.15
  },
  {
    ConvertColor(249),
    ConvertColor(82),
    ConvertColor(82),
    0.15
  },
  {
    ConvertColor(225),
    ConvertColor(120),
    ConvertColor(83),
    0.15
  },
  {
    ConvertColor(215),
    ConvertColor(139),
    ConvertColor(6),
    0.15
  },
  {
    ConvertColor(203),
    ConvertColor(114),
    ConvertColor(216),
    0.15
  },
  {
    ConvertColor(85),
    ConvertColor(143),
    ConvertColor(215),
    0.15
  },
  {
    ConvertColor(119),
    ConvertColor(176),
    ConvertColor(100),
    0.15
  }
}
function SetRankingGradeDataFunc(bg, icon, grade)
  bg:Show(true)
  local color = GRADE_BG_COLOR[grade]
  bg:SetColor(color[1], color[2], color[3], color[4])
  if icon ~= nil then
    icon:Show(true)
    local coords = GRADE_ICON_COORDS[grade]
    icon:SetCoords(coords[1], coords[2], coords[3], coords[4])
    icon:SetExtent(coords[3], coords[4])
  end
end
function W_ICON.CreateHeroGradeEmblem(parent, grade, useEffect)
  local defaultDisable = "disable_01"
  local gradeKey = {
    {
      enableKey = "levle_01_size_90",
      leftEffect = nil,
      rightEffect = nil,
      offsetX = 0,
      offsetY = 0
    },
    {
      enableKey = "level_02",
      leftEffect = nil,
      rightEffect = "hero_effect_right",
      offsetX = 66,
      offsetY = 15
    },
    {
      enableKey = "level_02",
      leftEffect = "hero_effect_left",
      rightEffect = nil,
      offsetX = 66,
      offsetY = 15
    },
    {
      enableKey = "level_03",
      leftEffect = nil,
      rightEffect = "hero_effect_right",
      offsetX = 66,
      offsetY = 12
    },
    {
      enableKey = "level_03",
      leftEffect = "hero_effect_left",
      rightEffect = "hero_effect_right",
      offsetX = 66,
      offsetY = 12
    },
    {
      enableKey = "level_03",
      leftEffect = "hero_effect_left",
      rightEffect = nil,
      offsetX = 66,
      offsetY = 12
    }
  }
  local emblem = parent:CreateChildWidget("characternamelabel", "name", 0, false)
  emblem.style:SetAlign(ALIGN_CENTER)
  emblem.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(emblem, FONT_COLOR.MIDDLE_TITLE)
  local heroMark = parent:CreateDrawable(TEXTURE_PATH.HERO_CURRENT_STATUS, defaultDisable, "background")
  heroMark:AddAnchor("BOTTOM", emblem, "TOP", 0, -5)
  emblem.grade = grade
  if useEffect and gradeKey[grade] then
    if gradeKey[grade].leftEffect then
      local leftEff = parent:CreateDrawable(TEXTURE_PATH.HERO_CONDITION_EFFECT, gradeKey[grade].leftEffect, "background")
      leftEff:AddAnchor("TOPRIGHT", heroMark, "TOPRIGHT", -gradeKey[grade].offsetX, gradeKey[grade].offsetY)
      emblem.effectLeft = leftEff
    end
    if gradeKey[grade].rightEffect then
      local rightEff = parent:CreateDrawable(TEXTURE_PATH.HERO_CONDITION_EFFECT, gradeKey[grade].rightEffect, "background")
      rightEff:AddAnchor("TOPLEFT", heroMark, "TOPLEFT", gradeKey[grade].offsetX, gradeKey[grade].offsetY)
      emblem.effectRight = rightEff
    end
  end
  function emblem:SetGradeAndNameInfo(name, grade)
    if name == nil or gradeKey[grade] == nil then
      heroMark:SetTextureInfo(defaultDisable)
      ApplyTextColor(self, FONT_COLOR.GRAY)
      self:SetText(GetUIText(COMMON_TEXT, "vacancy"))
      self:SetAlpha(0.3)
    else
      heroMark:SetTextureInfo(gradeKey[grade].enableKey)
      ApplyTextColor(self, FONT_COLOR.MIDDLE_TITLE)
      self:SetText(name)
      self:SetAlpha(1)
    end
    if self.effectLeft then
      self.effectLeft:SetVisible(false)
    end
    if self.effectRight then
      self.effectRight:SetVisible(false)
    end
  end
  function emblem:SetInfo(name)
    local effectVisible = false
    if name == nil or gradeKey[self.grade] == nil then
      heroMark:SetTextureInfo(defaultDisable)
      ApplyTextColor(self, FONT_COLOR.GRAY)
      self:SetText(GetUIText(COMMON_TEXT, "vacancy"))
      self:SetAlpha(0.3)
    else
      heroMark:SetTextureInfo(gradeKey[self.grade].enableKey)
      ApplyTextColor(self, FONT_COLOR.MIDDLE_TITLE)
      self:SetText(name)
      self:SetAlpha(1)
      effectVisible = true
    end
    if self.effectLeft then
      self.effectLeft:SetVisible(effectVisible)
    end
    if self.effectRight then
      self.effectRight:SetVisible(effectVisible)
    end
  end
  function emblem:SetAcive(active)
    self:Show(active)
    heroMark:SetVisible(active)
  end
  return emblem
end
