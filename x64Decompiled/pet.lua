local PET_FRAME_WIDTH = 120
function CreatePetFrame(id, parent, mateType)
  local name = string.format("%s.%s", id, mateType)
  local w = CreateUnitFrame(name, parent, UNIT_FRAME_TYPE.PET)
  w:Show(false)
  w.mateType = mateType
  local playerFrame = ADDON:GetContent(UIC_PLAYER_UNITFRAME)
  if playerFrame == nil then
    return
  end
  if X2Player:GetFeatureSet().mateTypeSummon and mateType == MATE_TYPE_BATTLE then
    local bg_left = w:CreateDrawable(TEXTURE_PATH.PET, "unitframe_left", "background")
    bg_left:AddAnchor("RIGHT", w.hpBar, "LEFT", 0, 8)
    local bg_right = w:CreateDrawable(TEXTURE_PATH.PET, "unitframe_right", "background")
    bg_right:AddAnchor("LEFT", w.hpBar, "RIGHT", 0, 8)
  end
  function w:MakeOriginWindowPos(reset)
    if w == nil then
      return
    end
    w:RemoveAllAnchors()
    local xPos = 20
    local yPos = 0
    if X2Player:GetFeatureSet().mateTypeSummon then
      xPos = 354
      yPos = 9
      if mateType == MATE_TYPE_BATTLE then
        yPos = 86 + w:GetHeight()
      end
    end
    if reset then
      xPos = F_LAYOUT.CalcDontApplyUIScale(xPos)
      yPos = F_LAYOUT.CalcDontApplyUIScale(yPos)
    end
    if X2Player:GetFeatureSet().mateTypeSummon then
      w:AddAnchor("TOPLEFT", "UIParent", xPos, yPos)
    else
      w:AddAnchor("TOPLEFT", playerFrame, "TOPRIGHT", xPos, yPos)
    end
  end
  w:MakeOriginWindowPos()
  function w:ApplyFrameStyle()
    self.hpBar:ApplyBarTexture(STATUSBAR_STYLE.S_HP_FRIENDLY)
    self.mpBar:ApplyBarTexture(STATUSBAR_STYLE.S_MP)
    self.name:SetExtent(90, FONT_SIZE.MIDDLE)
    self.buffWindow:SetLayout(5, 24)
    self.buffWindow:AddAnchor("TOPLEFT", self.mpBar, "BOTTOMLEFT", 2, 4)
    self.debuffWindow:SetLayout(5, 24)
    self.leaderMark:Show(false)
    self.lootIcon:Show(false)
    self.marker:SetExtent(24, 24)
    self.marker:AddAnchor("LEFT", self.name, "RIGHT", 0, 0)
  end
  w:ApplyFrameStyle()
  w:SetTarget(F_UNIT.GetPetTargetName(mateType))
  function w:Click(arg)
    if arg == "RightButton" then
      ActivatePopupMenu(w, F_UNIT.GetPetTargetName(mateType))
    end
  end
  function w:OnHide()
    petFrame[mateType] = nil
  end
  w:SetHandler("OnHide", w.OnHide)
  w:EnableHidingIsRemove(true)
  AddUISaveHandlerByKey("petFrame" .. tostring(mateType), w, false)
  w:ApplyLastWindowOffset()
  return w
end
petFrame = {}
local petFrameEvents = {
  DISMISS_PET = function(onePetFrame, mateType)
    if onePetFrame.mateType == mateType then
      TogglePetFrame(false, mateType)
    end
  end,
  LEVEL_CHANGED = function(onePetFrame, _, stringId)
    local mateType = X2Unit:GetUnitMateTypeById(stringId)
    if mateType == MATE_TYPE_NONE or onePetFrame.mateType ~= mateType then
      return
    end
    onePetFrame:UpdateLevel()
    onePetFrame:UpdateNameWidth()
    if X2Unit:GetUnitId(F_UNIT.GetPetTargetName(mateType)) == stringId then
      local level = X2Unit:UnitLevel(F_UNIT.GetPetTargetName(mateType))
      X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.pet.GetLevelText(level))
    end
  end,
  ENTERED_WORLD = function(onePetFrame)
    onePetFrame:UpdateCombatIcon()
    onePetFrame:UpdateMarker()
  end,
  LEFT_LOADING = function(onePetFrame)
    onePetFrame:UpdateCombatIcon()
  end
}
function TogglePetFrame(isShow, mateType)
  if isShow == true and petFrame[mateType] == nil then
    petFrame[mateType] = CreatePetFrame("petFrame", "UIParent", mateType)
    petFrame[mateType]:AddOnEvents(petFrameEvents)
  end
  if petFrame[mateType] ~= nil then
    petFrame[mateType]:Show(isShow)
  end
end
if X2Mate:IsPlayerPetExists(MATE_TYPE_RIDE) == true then
  TogglePetFrame(true, MATE_TYPE_RIDE)
end
if X2Mate:IsPlayerPetExists(MATE_TYPE_BATTLE) == true then
  TogglePetFrame(true, MATE_TYPE_BATTLE)
end
local SpawnPet = function(mateType)
  TogglePetFrame(true, mateType)
end
UIParent:SetEventHandler("SPAWN_PET", SpawnPet)
