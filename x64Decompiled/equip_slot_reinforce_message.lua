local equipSlotReinforceMsg
local function CreateEquipSlotReinforceMsg(id, parent)
  local frame = CreateCenterMessageFrame(id, parent, "TYPE1")
  frame:EnableHidingIsRemove(true)
  frame.icon:RemoveAllAnchors()
  frame.icon:AddAnchor("TOP", frame.bg, "TOP", 0, 5)
  frame.iconBg:RemoveAllAnchors()
  frame.iconBg:AddAnchor("BOTTOM", frame.bg, "TOP", 0, MARGIN.WINDOW_SIDE)
  local titleIcon = frame:CreateDrawable(TEXTURE_PATH.EQUIP_SLOT_REINFORCE_MSG_SLOT_LEVEL_UP_TEXT, "slot_enchant_levelup_text", "artwork")
  titleIcon:AddAnchor("CENTER", frame.bg, "TOP", 0, -30)
  frame.titleIcon = titleIcon
  local title = frame:CreateChildWidget("textbox", "title", 0, true)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", titleIcon, "BOTTOM", 0, 20)
  title:SetExtent(frame:GetWidth(), FONT_SIZE.XLARGE)
  title.style:SetFontSize(FONT_SIZE.XLARGE)
  title.style:SetShadow(true)
  frame.body:SetWidth(1000)
  frame.body:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  frame.body:AddAnchor("TOP", title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 3)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  function frame:OnUpdate(dt)
    self.showingTime = dt + self.showingTime
    if self.showingTime > 1200 then
      self:Show(false, 200)
      self:ReleaseHandler("OnUpdate")
    end
  end
  local function OnEndFadeOut()
    equipSlotReinforceMsg = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  function frame:FillMsg(text)
    self.title:SetText(text)
  end
  return frame
end
function ShowEquipSlotReinforceMsg(text, iconPath, iconKey, titlePath, titleKey)
  if equipSlotReinforceMsg == nil then
    equipSlotReinforceMsg = CreateEquipSlotReinforceMsg("equipSlotReinforceMsg", systemLayerParent)
  end
  equipSlotReinforceMsg.icon:SetVisible(false)
  equipSlotReinforceMsg.iconBg:SetVisible(true)
  equipSlotReinforceMsg.titleIcon:SetVisible(false)
  local iconTexturePath = string.format(iconPath, iconKey)
  if X2:IsExistFileInAFS(iconTexturePath) then
    equipSlotReinforceMsg.icon:SetTexture(iconTexturePath)
    equipSlotReinforceMsg.icon:SetTextureInfo(iconKey)
    equipSlotReinforceMsg.icon:SetVisible(true)
  else
    UIParent:Warning(string.format("[Lua Error] can't find icon image.. [%s]", tostring(iconTexturePath)))
  end
  local titleTexturePath = string.format(titlePath, titleKey)
  if X2:IsExistFileInAFS(titleTexturePath) then
    equipSlotReinforceMsg.titleIcon:SetTexture(titlePath)
    equipSlotReinforceMsg.titleIcon:SetTextureInfo(titleKey)
    equipSlotReinforceMsg.titleIcon:SetVisible(true)
  else
    UIParent:Warning(string.format("[Lua Error] can't find icon image.. [%s]", tostring(titleTexturePath)))
  end
  equipSlotReinforceMsg:FillMsg(text)
  equipSlotReinforceMsg:Show(true, 300)
  equipSlotReinforceMsg.showingTime = 0
  equipSlotReinforceMsg:ReleaseHandler("OnUpdate")
  equipSlotReinforceMsg:SetHandler("OnUpdate", equipSlotReinforceMsg.OnUpdate)
  return true
end
