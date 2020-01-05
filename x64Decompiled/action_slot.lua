local NotifyEmptyActionBarSlotCount = function()
  local onlyShowBaseActionBar = true
  local emptySlotCnt = 0
  if actionBar_renewal ~= nil then
    for i = 1, #actionBar_renewal do
      if actionBar_renewal[i]:IsVisible() then
        if i > 3 then
          break
        else
          for var in pairs(actionBar_renewal[i].slot) do
            if actionBar_renewal[i].slot[var]:GetBindedType() == "none" then
              emptySlotCnt = emptySlotCnt + 1
            end
          end
        end
      end
    end
  end
  X2Action:BaseActionBarEmptySlotCount(emptySlotCnt)
end
local CancelAutoRegisteredEffect = function()
  if actionBar_renewal == nil then
    return
  end
  for i = 1, AUTO_REGISTER_ACTIONBAR_NUM do
    local actionBar = actionBar_renewal[i]
    if actionBar ~= nil then
      for j = actionBar.buttonStartIndex, actionBar.buttonEndIndex do
        local slot = actionBar.slot[j]
        if slot.flicker ~= nil and not slot.binded then
          slot:CancelEffect()
        end
      end
    end
  end
end
function CreateActionSlot(parent, ownId, slotType, slotIdx, slotSize)
  if slotSize == nil then
    slotSize = ICON_SIZE.DEFAULT
  end
  local slot = parent:CreateChildWidget("slot", ownId, slotIdx, true)
  slot:SetExtent(slotSize, slotSize)
  slot:EnableDrag(true)
  slot.cooltime_style:SetShadow(true)
  slot.slotIdx = slotIdx
  slot.slotType = slotType
  function slot:OnClick(arg)
    HideTooltip()
  end
  slot:SetHandler("OnClick", slot.OnClick)
  local normalImage = slot:CreateStateDrawable(UI_BUTTON_NORMAL, UOT_NINE_PART_DRAWABLE, TEXTURE_PATH.HUD, "background")
  normalImage:SetTextureInfo("action_slot_default_bg")
  normalImage:SetTextureColor("default")
  normalImage:SetExtent(slotSize, slotSize)
  normalImage:AddAnchor("CENTER", slot, 0, 0)
  slot.normalImage = normalImage
  local reqPointText = slot:CreateTextDrawable(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE, "artwork")
  reqPointText:SetAlign(ALIGN_CENTER)
  reqPointText:SetColor(1, 1, 1, 1)
  reqPointText:SetExtent(15, 22)
  reqPointText:AddAnchor("CENTER", slot, 0, 0)
  reqPointText:SetVisible(false)
  slot.reqPointText = reqPointText
  local stateImage = slot:CreateColorDrawable(0, 0, 0, 0, "artwork")
  stateImage:AddAnchor("TOPLEFT", slot, 0, 0)
  stateImage:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  stateImage:SetColor(1, 1, 1, 0)
  slot.stateImage = stateImage
  local overImage = slot:CreateStateDrawable(UI_BUTTON_HIGHLIGHTED, UOT_NINE_PART_DRAWABLE, TEXTURE_PATH.HUD, "overlay")
  overImage:SetCoords(743, 35, 13, 16)
  overImage:SetInset(6, 7, 6, 8)
  overImage:AddAnchor("TOPLEFT", slot, 1, 1)
  overImage:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  local levelText = slot:CreateTextDrawable(FONT_PATH.DEFAULT, FONT_SIZE.SMALL, "overlay")
  levelText:AddAnchor("BOTTOMLEFT", slot, 0, 0)
  levelText:SetExtent(15, 20)
  levelText:SetVisible(false)
  levelText:SetAlign(ALIGN_CENTER)
  slot.levelText = levelText
  local bg = slot:CreateDrawable(TEXTURE_PATH.SKILL, "action_slot_bg", "artwork")
  bg:AddAnchor("BOTTOMLEFT", levelText, 0, 0)
  bg:SetVisible(false)
  levelText.bg = bg
  W_ICON.CreateDestroyIcon(slot, "artwork")
  W_ICON.CreateDisableEnchantItemIcon(slot, "artwork")
  W_ICON.CreateDyeingIcon(slot, "artwork")
  W_ICON.CreateLookIcon(slot, "artwork")
  W_ICON.CreateOpenPaperItemIcon(slot, "artwork")
  local limitLevel = slot:CreateChildWidget("textbox", "limitLevel", 0, true)
  limitLevel:AddAnchor("TOPLEFT", slot, 0, 0)
  limitLevel:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  limitLevel.style:SetAlign(ALIGN_CENTER)
  limitLevel.style:SetFontSize(FONT_SIZE.LARGE)
  limitLevel:SetAutoResize(false)
  ApplyTextColor(limitLevel, FONT_COLOR.ROSE_PINK)
  limitLevel:Show(false)
  slot.limitLevel = limitLevel
  W_ICON.CreateLifeTimeIcon(slot, "artwork")
  W_ICON.CreatePackIcon(slot, "artwork")
  W_ICON.CreateChainIcon(slot, "artwork")
  local stackLabel = slot:CreateChildWidget("label", "stackLabel", 0, true)
  stackLabel:SetExtent(10, 10)
  stackLabel:AddAnchor("BOTTOMRIGHT", slot, -4, -4)
  stackLabel.style:SetAlign(ALIGN_RIGHT)
  stackLabel.style:SetShadow(true)
  local keybindingLabel = slot:CreateChildWidget("label", "keybindingLabel", 0, true)
  keybindingLabel:Clickable(false)
  keybindingLabel:SetExtent(slotSize - 5, 13)
  keybindingLabel:SetLimitWidth(true)
  keybindingLabel:AddAnchor("TOPLEFT", slot, 2, 1)
  keybindingLabel.style:SetAlign(ALIGN_LEFT)
  keybindingLabel.style:SetFontSize(FONT_SIZE.SMALL)
  keybindingLabel.style:SetShadow(true)
  keybindingLabel.style:SetColor(0.9, 0.9, 0.9, 1)
  local skillPointIcon = slot:CreateDrawable(TEXTURE_PATH.SKILL, "star", "artwork")
  skillPointIcon:AddAnchor("BOTTOM", slot, 0, -2)
  slot.skillPointIcon = skillPointIcon
  local chargeCooldownIcon = slot:CreateDrawable(TEXTURE_PATH.HUD, "overlap_bg", "artwork")
  chargeCooldownIcon:AddAnchor("BOTTOMRIGHT", slot, 0, 0)
  slot.chargeCooldownIcon = chargeCooldownIcon
  local chargeCooldownCount = slot:CreateChildWidget("label", "chargeCooldownCount", 0, true)
  chargeCooldownCount:SetExtent(10, 10)
  chargeCooldownCount:AddAnchor("BOTTOMRIGHT", slot, -3, -3)
  chargeCooldownCount.style:SetFontSize(FONT_SIZE.SMALL)
  chargeCooldownCount.style:SetAlign(ALIGN_CENTER)
  chargeCooldownCount.style:SetShadow(true)
  ApplyTextColor(chargeCooldownCount, FONT_COLOR.MELON)
  local auto_attack_effect_bg = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  auto_attack_effect_bg:SetVisible(false)
  auto_attack_effect_bg:SetInternalDrawType("ninepart")
  local tInfo = GetTextureInfo(TEXTURE_PATH.HUD, "action_slot_auto_attack_bg")
  local coords = {
    tInfo:GetCoords()
  }
  local inset = tInfo:GetInset()
  auto_attack_effect_bg:SetCoords(coords[1], coords[2], coords[3], coords[4])
  auto_attack_effect_bg:SetInset(inset[1], inset[2], inset[3], inset[4])
  auto_attack_effect_bg:SetExtent(slotSize - 1, slotSize - 1)
  auto_attack_effect_bg:AddAnchor("CENTER", slot, 0, 0)
  slot.auto_attack_effect_bg = auto_attack_effect_bg
  auto_attack_effect_bg:SetRepeatCount(0)
  local attack_effect_time = 0.5
  auto_attack_effect_bg:SetEffectPriority(1, "alpha", attack_effect_time, attack_effect_time)
  auto_attack_effect_bg:SetEffectInitialColor(1, 1, 1, 1, 0)
  auto_attack_effect_bg:SetEffectFinalColor(1, 1, 1, 1, 0.6)
  auto_attack_effect_bg:SetEffectPriority(2, "alpha", attack_effect_time, attack_effect_time)
  auto_attack_effect_bg:SetEffectInitialColor(2, 1, 1, 1, 0.6)
  auto_attack_effect_bg:SetEffectFinalColor(2, 1, 1, 1, 0.2)
  local auto_attack_effect_arrow = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  auto_attack_effect_arrow:SetVisible(false)
  auto_attack_effect_arrow:SetCoords(655, 130, 30, 14)
  auto_attack_effect_arrow:SetExtent(30, 14)
  auto_attack_effect_arrow:AddAnchor("CENTER", slot, 0, 0)
  slot.auto_attack_effect_arrow = auto_attack_effect_arrow
  auto_attack_effect_arrow:SetRepeatCount(0)
  auto_attack_effect_arrow:SetEffectPriority(1, "alpha", 0.4, 0.4)
  auto_attack_effect_arrow:SetEffectInitialColor(1, 1, 1, 1, 1)
  auto_attack_effect_arrow:SetEffectFinalColor(1, 1, 1, 1, 1)
  auto_attack_effect_arrow:SetMoveEffectType(1, "circle", 0.53333336, 1.1428572, 1.5, 0)
  auto_attack_effect_arrow:SetMoveEffectCircle(1, 0, 360)
  function slot:Anim_auto_attack_effect(isStart)
    self.auto_attack_effect_bg:SetStartEffect(isStart or false)
    self.auto_attack_effect_arrow:SetStartEffect(isStart or false)
  end
  local combo_action_for_me = slot:CreateDrawable(TEXTURE_PATH.HUD, "actionbar_effect", "artwork")
  combo_action_for_me:SetTextureColor("linkage_self")
  combo_action_for_me:SetVisible(false)
  combo_action_for_me:AddAnchor("TOPLEFT", slot, 1, 1)
  combo_action_for_me:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  slot.combo_action_for_me = combo_action_for_me
  local combo_action_for_me_effect = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  combo_action_for_me_effect:SetVisible(false)
  combo_action_for_me_effect:SetInternalDrawType("ninepart")
  combo_action_for_me:SetTextureInfo("actionbar_effect", "linkage_self")
  combo_action_for_me_effect:AddAnchor("TOPLEFT", slot, 1, 1)
  combo_action_for_me_effect:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  slot.combo_action_for_me_effect = combo_action_for_me_effect
  combo_action_for_me_effect:SetRepeatCount(0)
  combo_action_for_me_effect:SetEffectPriority(1, "alpha", 0.5, 0.4)
  combo_action_for_me_effect:SetEffectInitialColor(1, 1, 1, 1, 0.4)
  combo_action_for_me_effect:SetEffectFinalColor(1, 1, 1, 1, 1)
  combo_action_for_me_effect:SetEffectScale(1, 0.3, 1, 0.3, 1)
  combo_action_for_me_effect:SetEffectPriority(2, "alpha", 0.3, 0.2)
  combo_action_for_me_effect:SetEffectInitialColor(2, 1, 1, 1, 0.9)
  combo_action_for_me_effect:SetEffectFinalColor(2, 1, 1, 1, 0)
  combo_action_for_me_effect:SetEffectScale(2, 1, 1, 1, 1)
  combo_action_for_me_effect:SetEffectInterval(2, 0.8)
  function slot:Anim_combo_aciton_for_me_effect(isStart)
    self.combo_action_for_me:SetVisible(isStart)
    self.combo_action_for_me_effect:SetStartEffect(isStart)
  end
  local combo_action_for_target = slot:CreateDrawable(TEXTURE_PATH.HUD, "actionbar_effect", "artwork")
  combo_action_for_target:SetTextureColor("linkage_target")
  combo_action_for_target:SetVisible(false)
  combo_action_for_target:AddAnchor("TOPLEFT", slot, 1, 1)
  combo_action_for_target:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  slot.combo_action_for_target = combo_action_for_target
  local combo_action_for_target_effect = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  combo_action_for_target_effect:SetVisible(false)
  combo_action_for_target_effect:SetTextureInfo("actionbar_effect", "linkage_target")
  combo_action_for_target_effect:AddAnchor("TOPLEFT", slot, 1, 1)
  combo_action_for_target_effect:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  slot.combo_action_for_target_effect = combo_action_for_target_effect
  combo_action_for_target_effect:SetRepeatCount(0)
  combo_action_for_target_effect:SetEffectPriority(1, "alpha", 0.5, 0.4)
  combo_action_for_target_effect:SetEffectInitialColor(1, 1, 1, 1, 0.4)
  combo_action_for_target_effect:SetEffectFinalColor(1, 1, 1, 1, 1)
  combo_action_for_target_effect:SetEffectScale(1, 0.3, 1, 0.3, 1)
  combo_action_for_target_effect:SetEffectPriority(2, "alpha", 0.3, 0.2)
  combo_action_for_target_effect:SetEffectInitialColor(2, 1, 1, 1, 0.9)
  combo_action_for_target_effect:SetEffectFinalColor(2, 1, 1, 1, 0)
  combo_action_for_target_effect:SetEffectScale(2, 1, 1, 1, 1)
  combo_action_for_target_effect:SetEffectInterval(2, 0.8)
  function slot:Anim_combo_aciton_for_target_effect(isStart)
    self.combo_action_for_target:SetVisible(isStart)
    self.combo_action_for_target_effect:SetStartEffect(isStart)
  end
  local toggleSkillEffectBg = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  toggleSkillEffectBg:SetVisible(false)
  toggleSkillEffectBg:SetTextureInfo("actionbar_effect", "toggle")
  toggleSkillEffectBg:AddAnchor("TOPLEFT", slot, 1, 1)
  toggleSkillEffectBg:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  slot.toggleSkillEffectBg = toggleSkillEffectBg
  toggleSkillEffectBg:SetRepeatCount(0)
  toggleSkillEffectBg:SetEffectPriority(1, "alpha", 0.7, 0.6)
  toggleSkillEffectBg:SetEffectInitialColor(1, 1, 1, 1, 0)
  toggleSkillEffectBg:SetEffectFinalColor(1, 1, 1, 1, 1)
  toggleSkillEffectBg:SetEffectPriority(2, "alpha", 0.5, 0.4)
  toggleSkillEffectBg:SetEffectInitialColor(2, 1, 1, 1, 1)
  toggleSkillEffectBg:SetEffectFinalColor(2, 1, 1, 1, 0)
  local toggleSkillEffectLine = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  toggleSkillEffectLine:SetCoords(795, 47, 18, 4)
  toggleSkillEffectLine:SetExtent(18, 4)
  toggleSkillEffectLine:AddAnchor("TOPLEFT", slot, 0, 1)
  toggleSkillEffectLine:SetRepeatCount(0)
  local animTime = 0.3
  toggleSkillEffectLine:SetMoveEffectType(1, "top", 0, 0, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(1, 0.5, 1.5)
  toggleSkillEffectLine:SetEffectPriority(1, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(1, 1, 1, 1, 0)
  toggleSkillEffectLine:SetEffectFinalColor(1, 1, 1, 1, 1)
  toggleSkillEffectLine:SetMoveEffectType(2, "top", 0, 0, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(2, 1.5, 1.8)
  toggleSkillEffectLine:SetEffectPriority(2, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(2, 1, 1, 1, 1)
  toggleSkillEffectLine:SetEffectFinalColor(2, 1, 1, 1, 0)
  toggleSkillEffectLine:SetMoveEffectType(3, "right", 1.7, 0, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(3, 1, 3.5)
  toggleSkillEffectLine:SetEffectPriority(3, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(3, 1, 1, 1, 0)
  toggleSkillEffectLine:SetEffectFinalColor(3, 1, 1, 1, 1)
  toggleSkillEffectLine:SetMoveEffectType(4, "right", 1.7, 0, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(4, 3.5, 7.5)
  toggleSkillEffectLine:SetEffectPriority(4, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(4, 1, 1, 1, 1)
  toggleSkillEffectLine:SetEffectFinalColor(4, 1, 1, 1, 0)
  toggleSkillEffectLine:SetMoveEffectType(5, "bottom", 0, 9, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(5, 2, 1.5)
  toggleSkillEffectLine:SetEffectPriority(5, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(5, 1, 1, 1, 0)
  toggleSkillEffectLine:SetEffectFinalColor(5, 1, 1, 1, 1)
  toggleSkillEffectLine:SetMoveEffectType(6, "bottom", 0, 9, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(6, 1.5, 0.3)
  toggleSkillEffectLine:SetEffectPriority(6, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(6, 1, 1, 1, 1)
  toggleSkillEffectLine:SetEffectFinalColor(6, 1, 1, 1, 0)
  toggleSkillEffectLine:SetMoveEffectType(7, "left", 0.3, 0.2, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(7, 7.5, 3.5)
  toggleSkillEffectLine:SetEffectPriority(7, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(7, 1, 1, 1, 0)
  toggleSkillEffectLine:SetEffectFinalColor(7, 1, 1, 1, 1)
  toggleSkillEffectLine:SetMoveEffectType(8, "left", 0.3, 0.2, animTime, animTime)
  toggleSkillEffectLine:SetMoveEffectEdge(8, 3.5, 1.7)
  toggleSkillEffectLine:SetEffectPriority(8, "alpha", animTime, animTime)
  toggleSkillEffectLine:SetEffectInitialColor(8, 1, 1, 1, 1)
  toggleSkillEffectLine:SetEffectFinalColor(8, 1, 1, 1, 0)
  slot.toggleSkillEffectLine = toggleSkillEffectLine
  function slot:AnimToggleSkill(isStart)
    self.toggleSkillEffectBg:SetStartEffect(isStart)
    self.toggleSkillEffectLine:SetStartEffect(isStart)
  end
  local skillAlertShowUpEffectBg = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  skillAlertShowUpEffectBg:SetVisible(false)
  skillAlertShowUpEffectBg:SetInternalDrawType("ninepart")
  skillAlertShowUpEffectBg:SetTextureInfo("actionbar_lighting")
  skillAlertShowUpEffectBg:AddAnchor("TOPLEFT", slot, 1, 1)
  skillAlertShowUpEffectBg:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  skillAlertShowUpEffectBg:SetRepeatCount(1)
  skillAlertShowUpEffectBg:SetEffectPriority(1, "alpha", 0.2, 0)
  skillAlertShowUpEffectBg:SetEffectInitialColor(1, 1, 1, 1, 1)
  skillAlertShowUpEffectBg:SetEffectFinalColor(1, 1, 1, 1, 0)
  slot.skillAlertShowUpEffectBg = skillAlertShowUpEffectBg
  local skillAlertEffectBg = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  skillAlertEffectBg:SetVisible(false)
  skillAlertEffectBg:SetInternalDrawType("ninepart")
  skillAlertEffectBg:SetTextureInfo("actionbar_effect", "alarm")
  skillAlertEffectBg:AddAnchor("TOPLEFT", slot, 1, 1)
  skillAlertEffectBg:AddAnchor("BOTTOMRIGHT", slot, -1, -1)
  skillAlertEffectBg:SetRepeatCount(0)
  skillAlertEffectBg:SetEffectPriority(1, "alpha", 0.7, 0.6)
  skillAlertEffectBg:SetEffectInitialColor(1, 1, 1, 1, 0)
  skillAlertEffectBg:SetEffectFinalColor(1, 1, 1, 1, 1)
  skillAlertEffectBg:SetEffectPriority(2, "alpha", 0.5, 0.4)
  skillAlertEffectBg:SetEffectInitialColor(2, 1, 1, 1, 1)
  skillAlertEffectBg:SetEffectFinalColor(2, 1, 1, 1, 0)
  slot.skillAlertEffectBg = skillAlertEffectBg
  local skillAlertEffectLine = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  skillAlertEffectLine:SetTextureInfo("actionbar_arrow")
  skillAlertEffectLine:AddAnchor("TOPLEFT", slot, 0, 1)
  skillAlertEffectLine:SetRepeatCount(0)
  local animTime = 0.3
  skillAlertEffectLine:SetMoveEffectType(1, "top", 0, 0, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(1, 0, 0.7)
  skillAlertEffectLine:SetEffectPriority(1, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(1, 1, 1, 1, 0)
  skillAlertEffectLine:SetEffectFinalColor(1, 1, 1, 1, 1)
  skillAlertEffectLine:SetMoveEffectType(2, "top", 0, 0, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(2, 0.7, 1.4)
  skillAlertEffectLine:SetEffectPriority(2, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(2, 1, 1, 1, 1)
  skillAlertEffectLine:SetEffectFinalColor(2, 1, 1, 1, 0)
  skillAlertEffectLine:SetMoveEffectType(3, "right", 1.1, 0, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(3, 0, 1.5)
  skillAlertEffectLine:SetEffectPriority(3, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(3, 1, 1, 1, 0)
  skillAlertEffectLine:SetEffectFinalColor(3, 1, 1, 1, 1)
  skillAlertEffectLine:SetMoveEffectType(4, "right", 1.1, 0, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(4, 1.5, 3)
  skillAlertEffectLine:SetEffectPriority(4, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(4, 1, 1, 1, 1)
  skillAlertEffectLine:SetEffectFinalColor(4, 1, 1, 1, 0)
  skillAlertEffectLine:SetMoveEffectType(5, "bottom", 0, 3.5, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(5, 1.5, 0.8)
  skillAlertEffectLine:SetEffectPriority(5, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(5, 1, 1, 1, 0)
  skillAlertEffectLine:SetEffectFinalColor(5, 1, 1, 1, 1)
  skillAlertEffectLine:SetMoveEffectType(6, "bottom", 0, 3.5, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(6, 0.8, 0.2)
  skillAlertEffectLine:SetEffectPriority(6, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(6, 1, 1, 1, 1)
  skillAlertEffectLine:SetEffectFinalColor(6, 1, 1, 1, 0)
  skillAlertEffectLine:SetMoveEffectType(7, "left", 0.3, 0, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(7, 3.5, 1.7)
  skillAlertEffectLine:SetEffectPriority(7, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(7, 1, 1, 1, 0)
  skillAlertEffectLine:SetEffectFinalColor(7, 1, 1, 1, 1)
  skillAlertEffectLine:SetMoveEffectType(8, "left", 0.3, 0, animTime, animTime)
  skillAlertEffectLine:SetMoveEffectEdge(8, 1.7, 0.7)
  skillAlertEffectLine:SetEffectPriority(8, "alpha", animTime, animTime)
  skillAlertEffectLine:SetEffectInitialColor(8, 1, 1, 1, 1)
  skillAlertEffectLine:SetEffectFinalColor(8, 1, 1, 1, 0)
  slot.skillAlertEffectLine = skillAlertEffectLine
  local skillAlertEffectLine2 = slot:CreateEffectDrawable(TEXTURE_PATH.HUD, "artwork")
  skillAlertEffectLine2:SetTextureInfo("actionbar_arrow")
  skillAlertEffectLine2:AddAnchor("TOPLEFT", slot, 0, 1)
  skillAlertEffectLine2:SetRepeatCount(0)
  local animTime = 0.3
  skillAlertEffectLine2:SetMoveEffectType(1, "bottom", 0, 3.5, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(1, 1.5, 0.8)
  skillAlertEffectLine2:SetEffectPriority(1, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(1, 1, 1, 1, 0)
  skillAlertEffectLine2:SetEffectFinalColor(1, 1, 1, 1, 1)
  skillAlertEffectLine2:SetMoveEffectType(2, "bottom", 0, 3.5, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(2, 0.8, 0.2)
  skillAlertEffectLine2:SetEffectPriority(2, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(2, 1, 1, 1, 1)
  skillAlertEffectLine2:SetEffectFinalColor(2, 1, 1, 1, 0)
  skillAlertEffectLine2:SetMoveEffectType(3, "left", 0.3, 0, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(3, 3.5, 1.7)
  skillAlertEffectLine2:SetEffectPriority(3, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(3, 1, 1, 1, 0)
  skillAlertEffectLine2:SetEffectFinalColor(3, 1, 1, 1, 1)
  skillAlertEffectLine2:SetMoveEffectType(4, "left", 0.3, 0, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(4, 1.7, 0.7)
  skillAlertEffectLine2:SetEffectPriority(4, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(4, 1, 1, 1, 1)
  skillAlertEffectLine2:SetEffectFinalColor(4, 1, 1, 1, 0)
  skillAlertEffectLine2:SetMoveEffectType(5, "top", 0, 0, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(5, 0, 0.7)
  skillAlertEffectLine2:SetEffectPriority(5, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(5, 1, 1, 1, 0)
  skillAlertEffectLine2:SetEffectFinalColor(5, 1, 1, 1, 1)
  skillAlertEffectLine2:SetMoveEffectType(6, "top", 0, 0, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(6, 0.7, 1.4)
  skillAlertEffectLine2:SetEffectPriority(6, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(6, 1, 1, 1, 1)
  skillAlertEffectLine2:SetEffectFinalColor(6, 1, 1, 1, 0)
  skillAlertEffectLine2:SetMoveEffectType(7, "right", 1.1, 0, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(7, 0, 1.5)
  skillAlertEffectLine2:SetEffectPriority(7, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(7, 1, 1, 1, 0)
  skillAlertEffectLine2:SetEffectFinalColor(7, 1, 1, 1, 1)
  skillAlertEffectLine2:SetMoveEffectType(8, "right", 1.1, 0, animTime, animTime)
  skillAlertEffectLine2:SetMoveEffectEdge(8, 1.5, 3)
  skillAlertEffectLine2:SetEffectPriority(8, "alpha", animTime, animTime)
  skillAlertEffectLine2:SetEffectInitialColor(8, 1, 1, 1, 1)
  skillAlertEffectLine2:SetEffectFinalColor(8, 1, 1, 1, 0)
  slot.skillAlertEffectLine2 = skillAlertEffectLine2
  function slot:AnimSkillAlert(isStart)
    self.skillAlertEffectBg:SetStartEffect(isStart)
    self.skillAlertShowUpEffectBg:SetStartEffect(isStart)
    self.skillAlertEffectLine:SetStartEffect(isStart)
    self.skillAlertEffectLine2:SetStartEffect(isStart)
  end
  if baselibLocale.itemSideEffect == true then
    slot.itemSideEffect = W_ICON.DrawItemSideEffectBackground(slot)
  end
  function slot:ResetAllAnimEffect()
    self:Anim_combo_aciton_for_target_effect(false)
    self:Anim_combo_aciton_for_me_effect(false)
    if baselibLocale.itemSideEffect == true then
      self:Anim_Item_Side_effect(false)
    end
    if self.toggle == false then
      self:AnimToggleSkill(false)
    end
    if self.skillAlert == false then
      self:AnimSkillAlert(false)
    end
    if self.auto_attack == false then
      self:Anim_auto_attack_effect(false)
    end
  end
  local SetAutoAttackAnim = function(slot)
    if not slot.isProgrssAutoAttackAnim and slot.auto_attack then
      slot:Anim_auto_attack_effect(slot.auto_attack)
      slot.isProgrssAutoAttackAnim = slot.auto_attack
    elseif slot.isProgrssAutoAttackAnim and not slot.auto_attack then
      slot:Anim_auto_attack_effect(slot.auto_attack)
      slot.isProgrssAutoAttackAnim = slot.auto_attack
    end
  end
  function slot:CheckStateImage()
    local bindedType = self:GetBindedType()
    self.limitLevel:Show(false)
    self.reqPointText:SetVisible(false)
    self.levelText:SetVisible(false)
    self.levelText.bg:SetVisible(false)
    self.normalImage:SetColor(1, 1, 1, 1)
    if bindedType == "none" then
      self.stateImage:SetColor(1, 1, 1, 0)
      self:ResetAllAnimEffect()
      self.normalImage:SetColor(1, 1, 1, 0.2)
    elseif bindedType == "pet_skill" then
      if self.canUse == true then
        self.stateImage:SetColor(1, 1, 1, 0)
      else
        if not self.learned then
          self.stateImage:SetColor(ConvertColor(144), ConvertColor(18), ConvertColor(5), 0.6)
        else
          self.stateImage:SetColor(0, 0, 0, 0.75)
        end
        self:ResetAllAnimEffect()
      end
      SetAutoAttackAnim(slot)
    elseif bindedType == "item" then
      self:SetDyeingInfo(nil)
      self:SetLookIcon(nil)
      self:SetLifeTimeIcon(nil)
      self:SetPaperInfo(nil)
      self:SetDestroyInfo(nil)
      self:SetPackInfo(nil)
      self:SetPaperInfo(nil)
      self:SetDisableEnchantInfo(nil)
      self:SetChainInfo(nil)
      local extraInfo = self:GetExtraInfo()
      if extraInfo then
        self:SetDirectDyeingInfo(extraInfo)
        self:SetLookIcon(extraInfo)
        self:SetLifeTimeIcon(extraInfo)
        self:SetPackInfo(extraInfo)
        self:SetDestroyInfo(extraInfo)
        self:SetPaperInfo(extraInfo)
        self:SetDisableEnchantInfo(extraInfo)
        self:SetChainInfo(extraInfo)
        if baselibLocale.itemSideEffect == true and extraInfo.sideEffect == true then
          self:Anim_Item_Side_effect(true)
        end
      end
      if self.canUse == true then
        self.stateImage:SetColor(1, 1, 1, 0)
        SetAutoAttackAnim(self)
      else
        self.stateImage:SetColor(0, 0, 0, 0.75)
        self:ResetAllAnimEffect()
      end
      if not self.canUseLevel then
        self.stateImage:SetColor(0, 0, 0, 0.75)
      end
      if self.levelRequirement ~= nil and self.levelRequirement ~= 0 and not self.canUseLevel then
        self.limitLevel:Show(true)
        self.limitLevel:SetText(GetLevelToString(self.levelRequirement))
      end
    elseif bindedType == "skill" then
      self.skillPointIcon:SetVisible(false)
      self:SetLookIcon(nil)
      local extraInfo = self:GetExtraInfo()
      if extraInfo then
        if extraInfo.skillPoints == 2 then
          self.skillPointIcon:SetVisible(true)
          self.skillPointIcon:SetTExtureInfo("star2")
        elseif extraInfo.skillPoints == 3 then
          self.skillPointIcon:SetVisible(true)
          self.skillPointIcon:SetTExtureInfo("star3")
        end
        self:SetLookIcon(extraInfo)
      end
      if self.canUse == true or self.onlyView ~= nil and self.onlyView then
        self.stateImage:SetColor(1, 1, 1, 0)
        self:AnimToggleSkill(self.toggle)
        self:AnimSkillAlert(self.skillAlert)
        if self.visibleType ~= nil and self.visibleType >= SAT_NONACTIVE then
          self:Anim_combo_aciton_for_me_effect(false)
          self:Anim_combo_aciton_for_target_effect(false)
          self.stateImage:SetColor(0, 0, 0, 0.75)
        elseif self.combo ~= nil and self.combo ~= "normal" then
          if self.combo == "source_buff" or self.combo == "source_skill_modifier" then
            self:Anim_combo_aciton_for_me_effect(true)
            self:Anim_combo_aciton_for_target_effect(false)
          else
            self:Anim_combo_aciton_for_me_effect(false)
            self:Anim_combo_aciton_for_target_effect(true)
          end
        else
          self:Anim_combo_aciton_for_me_effect(false)
          self:Anim_combo_aciton_for_target_effect(false)
        end
        SetAutoAttackAnim(self)
      else
        if not self.learned then
          if self.visibleType ~= nil and self.visibleType >= SAT_NONACTIVE then
            self:Anim_combo_aciton_for_me_effect(false)
            self:Anim_combo_aciton_for_target_effect(false)
            self.stateImage:SetColor(0, 0, 0, 0.75)
          else
            if self.canLearn then
              self.stateImage:SetColor(ConvertColor(8), ConvertColor(198), ConvertColor(160), 0.4)
            else
              self.stateImage:SetColor(ConvertColor(144), ConvertColor(18), ConvertColor(5), 0.6)
            end
            if self.reqPoints ~= nil and 0 < self.reqPoints then
              self.reqPointText:SetVisible(true)
              self.reqPointText:SetText(tostring(self.reqPoints))
            end
          end
        elseif self.useView then
          self.stateImage:SetColor(1, 1, 1, 0)
        else
          self.stateImage:SetColor(0, 0, 0, 0.75)
        end
        self:ResetAllAnimEffect()
      end
      if self.showSavedSkills then
        self.stateImage:SetColor(1, 1, 1, 0)
        self.reqPointText:SetVisible(false)
      end
      if self.skillLevel ~= nil and 1 < self.skillLevel then
        self.levelText:SetText(tostring(self.skillLevel))
        self.levelText:SetVisible(true)
        self.levelText.bg:SetVisible(true)
      end
    elseif bindedType == "slave_skill" then
      if self.canUse then
        self.stateImage:SetColor(1, 1, 1, 0)
      else
        self.stateImage:SetColor(0, 0, 0, 0.75)
      end
      self:AnimToggleSkill(self.toggle)
      self:AnimSkillAlert(self.skillAlert)
    elseif bindedType == "function" then
      self.stateImage:SetColor(1, 1, 1, 0)
    elseif bindedType == "buff" then
      if self.learned or self.onlyView ~= nil and self.onlyView then
        self.stateImage:SetColor(1, 1, 1, 0)
      else
        if self.canLearn then
          self.stateImage:SetColor(ConvertColor(8), ConvertColor(198), ConvertColor(160), 0.4)
        else
          self.stateImage:SetColor(ConvertColor(137), ConvertColor(0), ConvertColor(0), 0.6)
        end
        if 0 < self.reqPoints then
          self.reqPointText:SetVisible(true)
          self.reqPointText:SetText(tostring(self.reqPoints))
        end
      end
      if self.showSavedSkills then
        self.stateImage:SetColor(1, 1, 1, 0)
        self.reqPointText:SetVisible(false)
      end
    end
    if bindedType == "none" then
      ApplyTextColor(self.keybindingLabel, FONT_COLOR.RED)
    elseif bindedType == "function" then
      ApplyTextColor(self.keybindingLabel, FONT_COLOR.WHITE)
    elseif self.canUse and self.hotkey_activated then
      ApplyTextColor(self.keybindingLabel, FONT_COLOR.WHITE)
    else
      ApplyTextColor(self.keybindingLabel, FONT_COLOR.RED)
    end
  end
  function slot:OnContentUpdated(arg1, arg2, arg3)
    if arg1 == "global_cooldown_start" or arg1 == "skill_cooldown_start" then
      self.cooldown = true
      self.cooldownDuration = arg2
    elseif arg1 == "global_cooldown_done" or arg1 == "skill_cooldown_done" then
      self.cooldown = false
      self.cooldownDuration = 0
    elseif arg1 == "stack_count_changed" then
      self.stackCount = arg2
      if self.stackCount > 1 then
        self.stackLabel:SetText(tostring(self.stackCount))
      else
        self.stackLabel:SetText("")
      end
    elseif arg1 == "charge_cooldown_count_changed" then
      if arg2 >= 1 then
        self.chargeCooldownIcon:SetVisible(true)
        self.chargeCooldownCount:SetText(tostring(arg2))
      else
        self.chargeCooldownIcon:SetVisible(false)
        self.chargeCooldownCount:SetText("")
      end
    elseif arg1 == "action_binded" then
      self.binded = arg2
      self.cooldown = false
      self.canUse = false
      self.canUseLevel = true
      self.toggle = false
      self.combo = nil
      self.stackCount = 0
      self.cooldownDuration = 0
      self.learned = false
      self.auto_attack = false
      self.hotkey_overrided = true
      self.isProgrssAutoAttackAnim = false
      self.canLearn = false
      self.reqPoints = 0
      self.skillLevel = 0
      self.visibleType = 0
      self.skillAlert = false
      self:Anim_auto_attack_effect(false)
      self:Anim_combo_aciton_for_me_effect(false)
      self:Anim_combo_aciton_for_target_effect(false)
      self:SetDyeingInfo(nil)
      self.skillPointIcon:SetVisible(false)
      self:SetLookIcon(nil)
      self:SetLifeTimeIcon(nil)
      self:SetPaperInfo(nil)
      self:SetDestroyInfo(nil)
      self:SetPackInfo(nil)
      self:SetDisableEnchantInfo(nil)
      self:SetChainInfo(nil)
      self.stackLabel:SetText("")
      self.chargeCooldownIcon:SetVisible(false)
      self.chargeCooldownCount:SetText("")
      if self.binded == true then
        NotifyEmptyActionBarSlotCount()
      else
        CancelAutoRegisteredEffect()
      end
    elseif arg1 == "can_use" then
      self.canUse = arg2
    elseif arg1 == "skill_toggled" then
      self.toggle = arg2
    elseif arg1 == "skill_alert" then
      self.skillAlert = arg2
    elseif arg1 == "can_use_level" then
      self.canUseLevel = arg2
      self.levelRequirement = arg3
    elseif arg1 == "combo_action" then
      self.combo = arg2
    elseif arg1 == "auto_attack" then
      self.auto_attack = arg2
    elseif arg1 == "buff_skill" then
    elseif arg1 == "learned" then
      self.learned = arg2
    elseif arg1 == "hotkey_activated" then
      self.hotkey_activated = arg2
    elseif arg1 == "canLearn" then
      self.canLearn = arg2
    elseif arg1 == "reqPoints" then
      self.reqPoints = arg2
    elseif arg1 == "skillLevel" then
      self.skillLevel = arg2
    elseif arg1 == "visibleType" then
      self.visibleType = arg2
    end
    self:CheckStateImage()
  end
  slot:SetHandler("OnContentUpdated", slot.OnContentUpdated)
  function slot:Reset()
    self.cooldown = false
    self.canUse = false
    self.combo = nil
    self.cooldownDuration = 0
    self.toggle = false
    self.learned = false
    self.auto_attack = false
    self.isProgrssAutoAttackAnim = false
    self.canLearn = false
    self.reqPoints = 0
    self.skillLevel = 0
    self.skillAlert = false
    self:Anim_auto_attack_effect(false)
    self:Anim_combo_aciton_for_me_effect(false)
    self:Anim_combo_aciton_for_target_effect(false)
    self:AnimSkillAlert(false)
    self.skillPointIcon:SetVisible(false)
    self:SetLookIcon(nil)
    self:SetDestroyInfo(nil)
    self:SetPackInfo(nil)
    self:SetPaperInfo(nil)
    self:SetLifeTimeIcon(nil)
    self:SetDisableEnchantInfo(nil)
    self.chargeCooldownIcon:SetVisible(false)
    self.reqPointText:SetText("")
    self:SetChainInfo(nil)
    self:ResetState()
  end
  function slot:ResetSlot()
    self.stateImage:SetColor(1, 1, 1, 0)
    self:Reset()
    self:ReleaseSlot()
  end
  if slotType ~= ISLOT_CONSTANT then
    slot:EstablishSlot(slotType, slotIdx)
  end
  local ActionSlotEvents = {
    LEFT_LOADING = function()
      slot:Reset()
    end
  }
  slot:SetHandler("OnEvent", function(this, event, ...)
    ActionSlotEvents[event](...)
  end)
  slot:RegisterEvent("LEFT_LOADING")
  return slot
end
