F_SLOT = {}
function F_SLOT.ApplySlotSkin(slot, slotTexture, skinInfo)
  if slot == nil then
    return
  end
  local inset = skinInfo.inset
  if inset == nil then
    inset = {
      0,
      0,
      0,
      0
    }
  end
  local color = skinInfo.color
  if color == nil then
    color = {
      1,
      1,
      1,
      1
    }
  end
  local anchorInfo_top = skinInfo.anchorInfo_top
  local anchorInfo_bottom = skinInfo.anchorInfo_bottom
  if skinInfo.path ~= nil then
    slotTexture:SetTexture(skinInfo.path)
  end
  if skinInfo.coords then
    slotTexture:SetCoords(skinInfo.coords[1], skinInfo.coords[2], skinInfo.coords[3], skinInfo.coords[4])
  elseif skinInfo.coordsKey then
    slotTexture:SetTextureInfo(skinInfo.coordsKey)
  else
    UIParent:Warning(string.format("[Lua Error] failed apply slot skin - invalid coords info~!!"))
  end
  slotTexture:SetInset(inset[1], inset[2], inset[3], inset[4])
  slotTexture:RemoveAllAnchors()
  if skinInfo.colorKey then
    slotTexture:SetTextureColor(skinInfo.colorKey)
  end
  if skinInfo.anchorInfo_top ~= nil then
    slotTexture:AddAnchor("TOPLEFT", slot, skinInfo.anchorInfo_top.x, skinInfo.anchorInfo_top.y)
  else
    slotTexture:AddAnchor("TOPLEFT", slot, 0, 0)
  end
  if skinInfo.anchorInfo_bottom ~= nil then
    slotTexture:AddAnchor("BOTTOMRIGHT", slot, skinInfo.anchorInfo_bottom.x, skinInfo.anchorInfo_bottom.y)
  else
    slotTexture:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  end
  slotTexture:SetColor(color[1], color[2], color[3], color[4])
end
function F_SLOT.SetIconBackGround(button, iconPath, itemIconParam, sideEffect)
  if button == nil then
    return
  end
  iconPath = iconPath or EMPTY_SLOT_PATH
  button:EnableDrawables("background")
  local inset = 1
  if button.inset ~= nil then
    inset = button.inset
  end
  function button:SetMask(bg, path)
    if bg == nil then
      bg = button:GetHighlightBackground()
    end
    bg:SetMask(path)
    bg:SetMaskCoords(0, 0, 40, 40)
    bg:SetColor(1, 1, 1, 1)
    bg:SetMaskVisible(false)
    self:SetHighlightBackground(bg)
  end
  function button:SetDefaultMask(bg)
    self:SetMask(bg, "ui/common/slot_over.dds")
  end
  if button.bgs == nil then
    button.bgs = {}
  end
  for i = 1, 4 do
    if button.bgs[i] == nil then
      button.bgs[i] = button:CreateIconImageDrawable(INVALID_ICON_PATH, "background")
    end
    if button.bgs[i].ClearAllTextures ~= nil then
      button.bgs[i]:ClearAllTextures()
    end
    if button.bgs[i].AddTexture ~= nil then
      button.bgs[i]:AddTexture(iconPath)
      if itemIconParam ~= nil and itemIconParam.overIcon ~= nil then
        button.bgs[i]:AddTexture(itemIconParam.overIcon)
      end
      if itemIconParam ~= nil and itemIconParam.framePath ~= nil then
        button.bgs[i]:AddTexture(itemIconParam.framePath)
        inset = 1
      end
    end
    button.bgs[i]:RemoveAllAnchors()
    button.bgs[i]:AddAnchor("TOPLEFT", button, inset, inset)
    button.bgs[i]:AddAnchor("BOTTOMRIGHT", button, -inset, -inset)
  end
  if baselibLocale.itemSideEffect == true then
    local sideEffectVisible = false
    if iconPath ~= EMPTY_SLOT_PATH and sideEffect ~= nil and sideEffect == true then
      sideEffectVisible = true
      if button.sideEffect == nil then
        button.sideEffect = W_ICON.DrawItemSideEffectBackground(button)
      end
    end
    if button.sideEffect ~= nil then
      button:Anim_Item_Side_effect(sideEffectVisible)
    end
  end
  SetButtonBackground(button)
  if button.bgs[2].SetMask ~= nil then
    button:SetDefaultMask(button.bgs[2])
  end
  function button:UpdateCoords(x, y, w, h)
    for i = 1, 4 do
      button.bgs[i]:SetCoords(x, y, w, h)
      button.bgs[i]:AddAnchor("TOPLEFT", self, 0, 0)
      button.bgs[i]:AddAnchor("BOTTOMRIGHT", self, 0, 0)
    end
    if button.bgs[2].SetMask ~= nil then
      button:SetDefaultMask(button.bgs[2])
    end
  end
  local OnEnableChanged = function(self, enabled)
    self:SetDisableColor(enabled)
  end
  button:SetHandler("OnEnableChanged", OnEnableChanged)
  function button:SetDisableColor(disable)
    if button:IsEnabled() and disable == true then
      button:SetNormalColor(1, 1, 1, 1)
      button:SetPushedColor(1, 1, 1, 1)
      button:SetHighlightColor(1, 1, 1, 1)
      button:SetDisabledColor(1, 1, 1, 1)
    else
      button:SetNormalColor(0.5, 0.5, 0.5, 1)
      button:SetPushedColor(0.5, 0.5, 0.5, 1)
      button:SetHighlightColor(0.5, 0.5, 0.5, 1)
      button:SetDisabledColor(0.5, 0.5, 0.5, 0.8)
    end
  end
end
function F_SLOT.SetItemIcons(button, iconPath, overIcon, framePath, sideEffect)
  itemIconParam = {}
  overIcon = overIcon or INVALID_ICON_PATH
  framePath = framePath or INVALID_ICON_PATH
  if overIcon ~= INVALID_ICON_PATH then
    itemIconParam.overIcon = overIcon
  end
  if framePath ~= INVALID_ICON_PATH then
    itemIconParam.framePath = framePath
  end
  F_SLOT.SetIconBackGround(button, iconPath, itemIconParam, sideEffect)
  if iconPath == nil then
    button.back:SetColor(1, 1, 1, 0.3)
  else
    button.back:SetColor(1, 1, 1, 1)
  end
end
