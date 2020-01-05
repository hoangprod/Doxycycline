local slotsByIndex = {}
local slotTooltipInfos = {}
local function SetSlotType(slotIdx, slot)
  slotsByIndex[slotIdx] = slot
end
function targetEquippedItem:Init()
  for i = 1, #PLAYER_EQUIP_SLOTS do
    local equipslot = targetEquippedItem.slot[i]
    local slotIdx = PLAYER_EQUIP_SLOTS[i]
    SetSlotType(slotIdx, equipslot)
    slotTooltipInfos[i] = nil
  end
  for i = 1, #PLAYER_EQUIP_SLOTS do
    do
      local button = targetEquippedItem.slot[i]
      local function OnEnter()
        local slotIdx = PLAYER_EQUIP_SLOTS[i]
        local tooltip = slotTooltipInfos[i]
        if tooltip ~= nil then
          if tooltip.itemType == 0 then
            local text = SlotFromEmptyTipText(slotIdx)
            SetTooltip(text, button)
          else
            ShowTooltip(tooltip, button, 1, false)
          end
        end
      end
      button:SetHandler("OnEnter", OnEnter)
      local OnHide = function()
        HideTooltip()
      end
      button:SetHandler("OnLeave", OnHide)
    end
  end
  local OnHide = function(self)
    self.modelView:StopAnimation()
    self.modelView:ClearModel()
  end
  self:SetHandler("OnHide", OnHide)
end
function targetEquippedItem:Update()
  local index = 1
  local indexY = 1
  local target = X2Unit:GetTargetUnitString()
  local ownerStringId = X2Unit:GetUnitId(target)
  for i = 1, #PLAYER_EQUIP_SLOTS do
    local slotIdx = PLAYER_EQUIP_SLOTS[i]
    local tooltip = X2Equipment:GetEquippedItemTooltipText(target, slotIdx)
    tooltip.iconInfo = X2Item:GetItemIconSet(tooltip.lookType, tooltip.itemGrade, ownerStringId)
    slotTooltipInfos[i] = tooltip
    if tooltip then
      local cooldownBtn = targetEquippedItem.slot[i]
      cooldownBtn:SetItemInfo(tooltip)
      cooldownBtn.back:SetColor(1, 1, 1, 1)
      cooldownBtn.id = tooltip.skillType
      local skillType = tooltip.skillType or 0
      cooldownBtn:SetSkill(skillType)
      SetTooltipDelayTime(0)
    end
    targetEquippedItem.targetName:SetText(X2Unit:UnitName(target))
    targetEquippedItem.gearScore:SetText(string.format("%s: %s", GetUIText(COMMON_TEXT, "gear_score"), X2Unit:UnitGearScore(target)))
  end
end
function targetEquippedItem:InitModelView()
  local target = X2Unit:GetTargetUnitString()
  self.modelView:Init(target, true)
  self.modelView:SetIngameShopMode(true)
  local adjust = GetAdjustCamera(X2Unit:UnitRace(target), X2Unit:UnitGender(target))
  if adjust ~= nil then
    self.modelView:AdjustCameraPos(adjust.center, adjust.zoom, adjust.height)
  end
  self.modelView:PlayAnimation(RELAX_ANIMATION_NAME, true)
end
function targetEquippedItem:ShowProc()
  targetEquippedItem:Init()
  targetEquippedItem:Update()
  targetEquippedItem:InitModelView()
end
if X2Player:GetFeatureSet().targetEquipmentWnd then
  function ShowTargetEquipment()
    local target = X2Unit:GetTargetUnitString()
    if targetEquippedItem:IsVisible() then
      targetEquippedItem:Show(false)
      return
    end
    if X2Unit:IsMe("target") == true then
      return
    end
    local isShowable = X2Unit:ShowableEquipInfo(target)
    local unitType = F_UNIT.GetUnitType(target)
    if isShowable and unitType == "character" then
      targetEquippedItem:Show(true)
    end
  end
  ADDON:RegisterContentTriggerFunc(UIC_TARGET_EQUIPMENT, ShowTargetEquipment)
end
