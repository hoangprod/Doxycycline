function SetTargetCastingBarVisible(visible)
  if targetCastingBar == nil then
    return
  end
  targetCastingBar:SetVisibleCastingBar(visible)
end
function SetTargetToTargetCastingBarVisible(visible)
  if ttargetCastingBar == nil then
    return
  end
  ttargetCastingBar:SetVisibleCastingBar(visible)
end
function VisibleMyEquipInfoSetHandler(value)
  X2Player:SetOpenMyEquipInfo(value == 1)
end
function BuffDurationVisibleChangedHandler(visible)
  local playerFrame = ADDON:GetContent(UIC_PLAYER_UNITFRAME)
  if playerFrame == nil then
    return
  end
  playerFrame:SetVisibleBuffDebuffText(visible)
  SetPartyFrameVisibleBuffDebuffText(visible)
end
function EmptyBagSlotCounterVisibleChangedHandler(visible)
  if main_menu_bar == nil then
    return
  end
  local button = GetMainMenuBarButton(MAIN_MENU_IDX.BAG)
  if button == nil then
    return
  end
  if X2Bag:CountEmptyBagSlots() > 10 then
    visible = false
  end
  button.badge:Show(visible)
end
function FixedTooltipPositionSetHandler(value)
  if fixedTooltip ~= nil then
    if value == 1 then
      fixedTooltip.DoodadAnchorFunc = UpdateFixedTooltipDynamicAnchor
    else
      fixedTooltip.DoodadAnchorFunc = UpdateFixedTooltipAnchor
    end
  end
end
function UseQuestDirectingCloseUpCameraChangedHandler(enable)
  X2Quest:SetUseQuestCamera(enable)
end
function ShowFps(visible)
  if GetIndicators == nil then
    return
  end
  local fpsInfo = GetIndicators().fpsInfo
  if fpsInfo == nil then
    return
  end
  fpsInfo:Show(visible)
end
function EnableSkillAlert(enable)
  local flag = 0
  if enable then
    flag = 1
  end
  X2SkillAlert:EnableSkillAlert(flag)
end
local fireSkillOnDownFlag = false
function FireSkillOnDown(enable)
  if type(enable) == "number" then
    fireSkillOnDownFlag = enable ~= 0
  elseif type(enable) == "boolean" then
    fireSkillOnDownFlag = enable
  else
    fireSkillOnDownFlag = true
  end
end
function CanFireSkillOnDown()
  return fireSkillOnDownFlag
end
function AutoEnemyTargetChanged(isChecked)
  if isChecked then
    SetOptionItemValue(OPTION_ITEM_AUTO_ENEMY_TARGETING, 2)
  end
end
local interfaceOptions = {
  {
    id = "OptionBackCarryingOrder1st",
    default = 2,
    saveLevel = OL_CHARACTER
  },
  {
    id = "OptionBackCarryingOrder2nd",
    default = 3,
    saveLevel = OL_CHARACTER
  },
  {
    id = "OptionBackCarryingOrder3rd",
    default = 4,
    saveLevel = OL_CHARACTER
  },
  {
    id = "OptionBackCarryingOrder4th",
    default = 1,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowHeatlthNumber",
    default = 0,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowMagicPointNumber",
    default = 0,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowBuffDuration",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = BuffDurationVisibleChangedHandler
  },
  {
    id = "ShowTargetCastingBar",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = SetTargetCastingBarVisible
  },
  {
    id = "ShowTargetToTargetCastingBar",
    default = 0,
    saveLevel = OL_CHARACTER,
    funcOnChanged = SetTargetToTargetCastingBarVisible
  },
  {
    id = "VisibleMyEquipInfo",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = VisibleMyEquipInfoSetHandler
  },
  {
    id = "ShowPlayerFrameLifeAlertEffect",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = PlayerLifeAlertEffectVisibleHandler
  },
  {
    id = "UseQuestDirectingCloseUpCamera",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = UseQuestDirectingCloseUpCameraChangedHandler
  },
  {
    id = "FixedTooltipPosition",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = FixedTooltipPositionSetHandler
  },
  {
    id = "ShowEmptyBagSlotCounter",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = EmptyBagSlotCounterVisibleChangedHandler
  },
  {
    id = "ShowPlayerHelmet",
    default = 1,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowMyBackHoldable",
    default = 1,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowMyCosplay",
    default = 1,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowMyBackPackWithCosplay",
    default = 0,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ChangeMyCosplayVisual",
    default = 0,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowChatBubble",
    default = 1,
    saveLevel = OL_CHARACTER
  },
  {
    id = "ShowFps",
    default = 0,
    saveLevel = OL_CHARACTER,
    funcOnChanged = ShowFps
  },
  {
    id = "option_skill_alert_enable",
    default = 1,
    saveLevel = OL_CHARACTER,
    funcOnChanged = EnableSkillAlert
  },
  {
    id = "option_skill_alert_position",
    default = 1,
    saveLevel = OL_CHARACTER
  }
}
RegisterOptionItem(interfaceOptions)
local msgDistanceControl
function MakeCombatMsgLevelControl(frame)
  local combatMsgLevelControl = frame:InsertNewOption("sliderbar", optionTexts.gameInfo.combatMsgLevel, nil, OPTION_ITEM_COMBAT_MSG_LEVEL)
  combatMsgLevelControl:SetMinMaxValues(1, 5)
  combatMsgLevelControl:SetValueStep(1)
  combatMsgLevelControl:SetPageStep(1)
  combatMsgLevelControl:SetValue(1, false)
  function combatMsgLevelControl:Init()
    self.originalValue = GetOptionItemValue(OPTION_ITEM_COMBAT_MSG_LEVEL)
    self:SetValue(self.originalValue + 1, false)
  end
  function combatMsgLevelControl:Save()
    local value = math.floor(self:GetValue()) - 1
    SetOptionItemValue(OPTION_ITEM_COMBAT_MSG_LEVEL, value)
  end
  function combatMsgLevelControl:OnSliderChanged(value)
    if msgDistanceControl ~= nil then
      if value == 1 then
        msgDistanceControl:SetValue(100, true)
        msgDistanceControl:SetEnable(false)
      else
        local dist = GetOptionItemValue(OPTION_ITEM_COMBAT_MSG_VISIBILITY)
        msgDistanceControl:SetValue(dist, true)
        msgDistanceControl:SetEnable(true)
      end
    end
  end
  combatMsgLevelControl:SetHandler("OnSliderChanged", combatMsgLevelControl.OnSliderChanged)
end
function MakeMouseSensitivityControl(frame)
  local sensitivityControl = frame:InsertNewOption("sliderbar", optionTexts.gameFunction.mouseSensitivity, nil, OPTION_ITEM_MOUSE_SENSITIVITY, nil, true)
  local MIN, MAX = X2Option:GetMinxMaxOfMouseSensitivity()
  MIN = MIN or 0
  MAX = MAX or 20
  sensitivityControl:SetMinMaxValues(0, math.floor(MAX - MIN))
  local width = sensitivityControl:GetExtent()
  sensitivityControl:SetWidth(width - 37)
  local valLabel = W_CTRL.CreateLabel(".valLabel", sensitivityControl)
  valLabel:SetExtent(30, 20)
  valLabel:AddAnchor("LEFT", sensitivityControl, "RIGHT", 5, 0)
  valLabel.style:SetAlign(ALIGN_CENTER)
  valLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(valLabel, FONT_COLOR.BLUE)
  sensitivityControl.valLabel = valLabel
  function sensitivityControl:OnSliderChanged(arg)
    local value = self:GetValue() or 0
    valLabel:SetText(tostring(math.floor(value)))
  end
  sensitivityControl:SetHandler("OnSliderChanged", sensitivityControl.OnSliderChanged)
  function sensitivityControl:Init()
    local value = GetOptionItemValue(OPTION_ITEM_MOUSE_SENSITIVITY)
    if value ~= nil then
      value = value - MIN
      valLabel:SetText(tostring(value))
      self:SetValue(value, false)
    end
  end
  function sensitivityControl:Save()
    local value = math.floor(self:GetValue())
    value = value + MIN
    SetOptionItemValue(OPTION_ITEM_MOUSE_SENSITIVITY, value)
  end
end
function MakeCombatMsgDstControl(frame)
  local localePath = optionTexts.gameInfo
  local distance = {}
  distance[1] = localePath.combatMsgDistance.controlStr[1]
  distance[2] = localePath.combatMsgDistance.controlStr[#localePath.combatMsgDistance.controlStr]
  local combatMsgDistanceControl = frame:InsertNewOption("sliderbar", localePath.combatMsgDistance, nil, OPTION_ITEM_COMBAT_MSG_VISIBILITY, nil, true)
  combatMsgDistanceControl:SetMinMaxValues(0, 100)
  combatMsgDistanceControl:SetValue(50, false)
  local width = combatMsgDistanceControl:GetExtent()
  combatMsgDistanceControl:SetWidth(width - 37)
  local percentLabel = W_CTRL.CreateLabel(".percentLabel", combatMsgDistanceControl)
  percentLabel:SetExtent(30, 20)
  percentLabel:AddAnchor("LEFT", combatMsgDistanceControl, "RIGHT", 5, 0)
  percentLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(percentLabel, FONT_COLOR.BLUE)
  percentLabel.style:SetFontSize(FONT_SIZE.LARGE)
  combatMsgDistanceControl.percentLabel = percentLabel
  function combatMsgDistanceControl:OnSliderChanged(arg)
    local value = self:GetValue() or 0
    percentLabel:SetText(tostring(math.floor(value)))
  end
  combatMsgDistanceControl:SetHandler("OnSliderChanged", combatMsgDistanceControl.OnSliderChanged)
  function combatMsgDistanceControl:Init()
    local msgLevel = GetOptionItemValue(OPTION_ITEM_COMBAT_MSG_LEVEL)
    if msgLevel == 0 then
      self:SetValue(100, true)
      self:SetEnable(false)
    else
      self.originalValue = GetOptionItemValue(OPTION_ITEM_COMBAT_MSG_VISIBILITY)
      percentLabel:SetText(tostring(math.floor(self.originalValue)))
      self:SetValue(self.originalValue, false)
    end
  end
  msgDistanceControl = combatMsgDistanceControl
end
function MakeMapQuestDstControl(frame)
  local mapQuestDistanceControl = frame:InsertNewOption("sliderbar", optionTexts.gameInfo.mapQuestDistance, nil, OPTION_ITEM_MAP_GIVEN_QUEST_DISTANCE)
  mapQuestDistanceControl:SetMinMaxValues(1, 4)
  mapQuestDistanceControl:SetValueStep(1)
  mapQuestDistanceControl:SetPageStep(1)
  mapQuestDistanceControl:SetValue(1, false)
  function mapQuestDistanceControl:Init()
    self.originalValue = GetOptionItemValue(OPTION_ITEM_MAP_GIVEN_QUEST_DISTANCE)
    self:SetValue(self.originalValue, false)
  end
  function mapQuestDistanceControl:Save()
    local value = math.floor(self:GetValue())
    SetOptionItemValue(OPTION_ITEM_MAP_GIVEN_QUEST_DISTANCE, value)
    worldmap:ReloadAllInfo()
    roadmap:ReloadAllInfo()
  end
end
function MakeNameTagModeControl(frame)
  local indentation = 10
  local titleControl = frame:InsertNewOption("subBigTitle", optionTexts.nameTagInfo.subtitleNameTagMode)
  local nameTagModeControl = frame:InsertNewOption("radiobuttonG", optionTexts.nameTagInfo.nameTagMode, nil, OPTION_ITEM_NAME_TAG_MODE, nil, nil, indentation)
  local nameTagModeFrame = nameTagModeControl:GetParent()
  local desc = nameTagModeFrame:CreateChildWidget("label", "desc", 0, true)
  desc:SetHeight(FONT_SIZE.MIDDLE)
  desc:SetWidth(nameTagModeControl:GetWidth())
  desc.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(desc, FONT_COLOR.ORIGINAL_LIGHT_GRAY)
  desc:SetText(GetUIText(OPTION_TEXT, "option_item_subtitle_nameTag_mode_desc"))
  nameTagModeControl:AttachChildWidget(nameTagModeControl, desc, {
    "TOPLEFT",
    nameTagModeControl,
    "BOTTOMLEFT",
    0,
    17
  }, 25)
  local bg = CreateContentBackground(nameTagModeControl, "TYPE2", "default")
  bg:AddAnchor("TOPLEFT", nameTagModeControl, -10, -10)
  bg:AddAnchor("BOTTOMRIGHT", nameTagModeControl, 0, 10)
  local startCtrl = titleControl
  local lastCtrl = nameTagModeControl
  MakeBackgroundImg(startCtrl, lastCtrl)
  local function NameTagModeChanged(self, index, dataValue)
    if index == nil or index == 0 then
      return
    end
    local nameTagMode = index - 1
    local list = X2Option:GetSubOptionItemList(OPTION_ITEM_NAME_TAG_MODE, nameTagMode)
    if list == nil then
      return
    end
    frame:UpdateOptionControlList(list)
    frame:UpdateNameTagEnableStates()
  end
  nameTagModeControl:SetHandler("OnRadioChanged", NameTagModeChanged)
  return nameTagModeControl
end
function MakeNameTagShowControl(frame)
  local localePath = optionTexts.nameTagInfo
  local indentation = 10
  frame:InsertNewOption("checkbox", localePath.showAppellation, nil, OPTION_ITEM_SHOW_APPELLATION_NAME_TAG, nil, nil, indentation)
  frame:InsertNewOption("checkbox", localePath.showFaction, nil, OPTION_ITEM_SHOW_FACTION_NAME_TAG, nil, nil, indentation, OPTION_ITEM_TARGET_ANCHOR_LEFT)
  frame:InsertNewOption("checkbox", localePath.showHp, nil, OPTION_ITEM_SHOW_HP_NAME_TAG, nil, nil, indentation)
end
function MakeCustomCloneControl(parent)
  local modeChkBox = parent:InsertNewOption("checkbox", optionTexts.gameFunction.customCloneMode, nil, OPTION_ITEM_CUSTOM_CLONE_MODE)
  local modeSlider = parent:InsertNewOption("sliderbar", optionTexts.gameFunction.customMaxCloneModel, nil, OPTION_ITEM_CUSTOM_MAX_CLONE_MODEL)
  local valueStrs = optionTexts.gameFunction.customMaxCloneModel.controlStr
  modeSlider:SetMinMaxValues(1, #valueStrs)
  modeSlider:SetValueStep(1)
  modeSlider:SetPageStep(1)
  local disableBg = modeSlider:CreateDrawable(TEXTURE_PATH.SCROLL, "disable_bg", "background")
  disableBg:SetInset(0, 0, 0, 0)
  disableBg:SetHeight(6)
  disableBg:RemoveAllAnchors()
  disableBg:AddAnchor("LEFT", modeSlider, "CENTER", 0, -1)
  disableBg:AddAnchor("RIGHT", modeSlider, "RIGHT", -7, -1)
  disableBg:SetColor(0.5, 0.5, 0.5, 1)
  local customMaxCloneModel, customMaxModel
  function SetCustomCloneMode()
    local isMode = modeChkBox:GetChecked()
    if isMode then
      modeSlider:SetValue(customMaxCloneModel, false)
    else
      modeSlider:SetValue(customMaxModel, false)
    end
    local labelColor = isMode and FONT_COLOR.DEFAULT or FONT_COLOR.GRAY
    local markingColor = isMode and 1 or 0.5
    for i = 4, 5 do
      modeSlider.label[i].style:SetColor(labelColor[1], labelColor[2], labelColor[3], labelColor[4])
      modeSlider.marking[i]:SetColor(markingColor, markingColor, markingColor, markingColor)
    end
    disableBg:SetVisible(not isMode)
  end
  function modeChkBox:OnCheckChanged()
    SetCustomCloneMode()
  end
  modeChkBox:SetHandler("OnCheckChanged", modeChkBox.OnCheckChanged)
  function modeSlider:Init()
    customMaxCloneModel = GetOptionItemValue(OPTION_ITEM_CUSTOM_MAX_CLONE_MODEL)
    customMaxModel = GetOptionItemValue(OPTION_ITEM_CUSTOM_MAX_MODEL)
    SetCustomCloneMode()
  end
  function modeSlider:OnSliderChanged(arg)
    if modeChkBox:GetChecked() then
      customMaxCloneModel = arg
    else
      if arg > 3 then
        modeSlider:SetValue(3, false)
      end
      customMaxModel = math.min(arg, 3)
    end
  end
  modeSlider:SetHandler("OnSliderChanged", modeSlider.OnSliderChanged)
  function modeSlider:Save()
    SetOptionItemValue(OPTION_ITEM_CUSTOM_MAX_CLONE_MODEL, customMaxCloneModel)
    SetOptionItemValue(OPTION_ITEM_CUSTOM_MAX_MODEL, customMaxModel)
  end
  function modeSlider:Cancel()
  end
end
function CreateNameTagOptionFrame(parent, subFrameIndex)
  local indentation = 10
  local localePath = optionTexts.nameTagInfo
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  local nameTagModeControl = MakeNameTagModeControl(frame)
  frame:InsertNewOption("subBigTitle", localePath.subtitleNameTag)
  MakeNameTagShowControl(frame)
  frame:InsertNewOption("subBigTitle", localePath.subtitleNameTagDetail)
  frame:InsertNewOption("checkbox", localePath.visibleMyName, nil, OPTION_ITEM_SHOW_PLAYER_NAME_TAG, nil, nil, indentation)
  frame:InsertNewOption("checkbox", localePath.visibleNpc, nil, OPTION_ITEM_SHOW_NPC_NAME_TAG, nil, nil, indentation, OPTION_ITEM_TARGET_ANCHOR_LEFT)
  frame:InsertNewOption("checkbox", localePath.visibleParty, nil, OPTION_ITEM_SHOW_PARTY_NAME_TAG, nil, nil, indentation)
  frame:InsertNewOption("checkbox", localePath.visibleExpeditionMember, nil, OPTION_ITEM_SHOW_EXPEDITION_NAME_TAG, nil, nil, indentation, OPTION_ITEM_TARGET_ANCHOR_LEFT)
  frame:InsertNewOption("checkbox", localePath.visibleFriendlyPlayer, nil, OPTION_ITEM_SHOW_FRIENDLY_NAME_TAG, nil, nil, indentation)
  frame:InsertNewOption("checkbox", localePath.visibleHostilePlayer, nil, OPTION_ITEM_SHOW_HOSTILE_NAME_TAG, nil, nil, indentation, OPTION_ITEM_TARGET_ANCHOR_LEFT)
  frame:InsertNewOption("checkbox", localePath.visibleMyMate, nil, OPTION_ITEM_SHOW_MY_MATE_NAME_TAG, nil, nil, indentation)
  frame:InsertNewOption("checkbox", localePath.visibleFriendlyMate, nil, OPTION_ITEM_SHOW_FRIENDLY_MATE_NAME_TAG, nil, nil, indentation)
  frame:InsertNewOption("checkbox", localePath.visibleHostileMate, nil, OPTION_ITEM_SHOW_HOSTILE_MATE_NAME_TAG, nil, nil, indentation, OPTION_ITEM_TARGET_ANCHOR_LEFT)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("subBigTitle", localePath.selectionFactionInfo)
  local factionCtrl = frame:InsertNewOption("radiobuttonV", optionTexts.nameTagInfo.factionSelection, nil, OPTION_ITEM_NAME_TAG_FACTION_SELECTION, nil, nil, indentation)
  local factionCtrlFrame = factionCtrl:GetParent()
  local desc = factionCtrlFrame:CreateChildWidget("label", "desc", 0, true)
  desc:SetHeight(FONT_SIZE.MIDDLE)
  desc:SetWidth(factionCtrl:GetWidth())
  desc.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(desc, FONT_COLOR.GRAY)
  desc:SetText(GetUIText(OPTION_TEXT, "option_item_subtitle_faction_desc"))
  factionCtrl:AttachChildWidget(factionCtrl, desc, {
    "TOPLEFT",
    factionCtrl,
    "BOTTOMLEFT",
    0,
    17
  }, 25)
  function frame:UpdateNameTagEnableStates()
    local enableList = {
      OPTION_ITEM_SHOW_APPELLATION_NAME_TAG,
      OPTION_ITEM_SHOW_FACTION_NAME_TAG,
      OPTION_ITEM_SHOW_HP_NAME_TAG,
      OPTION_ITEM_NAME_TAG_FACTION_SELECTION
    }
    self:EnableOptionControlList(enableList, true)
    local isInInstance = X2BattleField:IsInInstantGame() or X2Indun:IsEntranceIndunMatch()
    if isInInstance == true then
      self:EnableOptionControlList(enableList, false)
    else
      local selectedNameTagMode = nameTagModeControl:GetChecked() - 1
      if selectedNameTagMode ~= NAME_TAG_MODE_DEFAULT then
        self:EnableOptionControlList(enableList, false)
      end
    end
  end
  function frame:InitAfter()
    self:UpdateNameTagEnableStates()
  end
  return frame
end
function CreateGameInfoOptionFrame(parent, subFrameIndex)
  local localePath = optionTexts.gameInfo
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  frame:InsertNewOption("checkbox", localePath.visibleHealthText, nil, "ShowHeatlthNumber")
  frame:InsertNewOption("checkbox", localePath.visibleManaPointText, nil, "ShowMagicPointNumber")
  frame:InsertNewOption("checkbox", localePath.visibleBuffDuration, nil, "ShowBuffDuration", BuffDurationVisibleChangedHandler)
  frame:InsertNewOption("checkbox", localePath.visibleTargetCastingBar, nil, "ShowTargetCastingBar", SetTargetCastingBarVisible)
  frame:InsertNewOption("checkbox", localePath.visibleTargetTargetCastingBar, nil, "ShowTargetToTargetCastingBar", SetTargetToTargetCastingBarVisible)
  frame:InsertNewOption("radiobuttonH", localePath.visibleMyEquipInfo, X2Player:GetFeatureSet().targetEquipmentWnd, "VisibleMyEquipInfo", VisibleMyEquipInfoSetHandler)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("checkbox", localePath.visibleTooltipSynergyInfo, nil, OPTION_ITEM_SKILL_SYNERGY_INFO_SHOW_TOOLTIP)
  frame:InsertNewOption("checkbox", localePath.visibleTooltipSkillDatailDamage, nil, OPTION_ITEM_SKILL_DETAIL_DAMAGE_SHOW_TOOLTIP)
  frame:InsertNewOption("checkbox", localePath.visibleMakerInfo, nil, OPTION_ITEM_ITEM_MAKER_INFO_SHOW_TOOLTIP)
  frame:InsertNewOption("radiobuttonH", localePath.SetFixedTooltipPosition, nil, "FixedTooltipPosition", FixedTooltipPositionSetHandler)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("checkbox", localePath.visibleEmptyBagSlotCount, nil, "ShowEmptyBagSlotCounter", EmptyBagSlotCounterVisibleChangedHandler)
  frame:InsertNewOption("checkbox", localePath.visibleChatBubble, nil, "ShowChatBubble")
  frame:InsertNewOption("checkbox", localePath.hideTutorial, nil, OPTION_ITEM_HIDE_TUTORIAL)
  frame:InsertNewOption("checkbox", localePath.visibleFps, nil, "ShowFps", ShowFps)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("checkbox", localePath.enableSkillAlert, nil, "option_skill_alert_enable", EnableSkillAlert)
  local skillAlertControl = frame:InsertNewOption("button", localePath.skillAlert)
  function skillAlertControl:OnClick()
    skillAlertControl.execute = true
    ShowSkillAlertOptionWnd(true)
  end
  skillAlertControl:SetHandler("OnClick", skillAlertControl.OnClick)
  function skillAlertControl:Init()
    skillAlertControl.execute = false
  end
  function skillAlertControl:Save()
    if skillAlertControl.execute then
    end
  end
  local skillAlertPositionControl = frame:InsertNewOption("radiobuttonH", localePath.skillAlertPosition, nil, OPTION_SKILL_ALERT_POSITION)
  local skillAlertOnRadioChangedFunc = function(self, index, dataValue)
    if dataValue == nil then
      return
    end
    ChangeSkillAlertPos(dataValue)
  end
  skillAlertPositionControl:SetHandler("OnRadioChanged", skillAlertOnRadioChangedFunc)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  MakeCombatMsgLevelControl(frame)
  frame:InsertNewOption("checkbox", localePath.combatMsgDisplayShipCollision, nil, OPTION_ITEM_COMBAT_MSG_DISPLAY_SHIP_COLLISION)
  MakeCombatMsgDstControl(frame)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  MakeMapQuestDstControl(frame)
  return frame
end
function CreateFunctionOptionFrame(parent, subFrameIndex)
  local localePath = optionTexts.gameFunction
  local frame = CreateOptionSubFrame(parent, subFrameIndex)
  frame:InsertNewOption("checkbox", localePath.clickToMove, nil, OPTION_ITEM_CLICK_TO_MOVE)
  frame:InsertNewOption("checkbox", localePath.fireSkillOnDown, nil, OPTION_ITEM_FIRE_ACTION_ON_BUTTON_DOWN)
  frame:InsertNewOption("checkbox", localePath.AutoEnemyTarget, nil, OPTION_ITEM_AUTO_ENEMY_TARGETING, AutoEnemyTargetChanged)
  frame:InsertNewOption("checkbox", localePath.smartGroundTargeting, nil, OPTION_ITEM_SMART_GROUND_TARGETING)
  frame:InsertNewOption("checkbox", localePath.useCelerity, nil, OPTION_ITEM_USE_CELERITY_WITH_DOUBLE_FORWARD)
  frame:InsertNewOption("checkbox", localePath.useGliderWithDoubleJump, nil, OPTION_ITEM_USE_GLIDE_WITH_DOUBLE_JUMP)
  frame:InsertNewOption("checkbox", localePath.useDoodadSmartPositioning, nil, OPTION_ITEM_USE_DOODAD_SMART_POSITIONING)
  frame:InsertNewOption("checkbox", localePath.useDecorationSmartPositioning, nil, OPTION_ITEM_USE_DECORATION_SMART_POSITIONING)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("checkbox", localePath.useCameraShake, nil, OPTION_ITEM_CAMERA_USE_SHAKE)
  frame:InsertNewOption("checkbox", localePath.showPlayerFrameLifeAlertEffect, nil, "ShowPlayerFrameLifeAlertEffect", PlayerLifeAlertEffectVisibleHandler)
  frame:InsertNewOption("checkbox", localePath.useQuestDirectingCloseUpCamera, nil, "UseQuestDirectingCloseUpCamera", UseQuestDirectingCloseUpCameraChangedHandler)
  frame:InsertNewOption("checkbox", localePath.showGuideDecal, nil, OPTION_ITEM_SHOW_GUIDE_DECAL)
  frame:InsertNewOption("checkbox", localePath.showLootWindow, nil, OPTION_ITEM_SHOW_LOOT_WINDOW)
  frame:InsertNewOption("checkbox", localePath.useOnlyMyPortal, nil, OPTION_ITEM_USE_ONLY_MY_PORTAL)
  frame:InsertNewOption("checkbox", localePath.hideOptimizationButton, nil, OPTION_ITEM_HIDE_OPTIMIZATION_BUTTON)
  MakeCustomCloneControl(frame)
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("subBigTitle", localePath.subTitleInviteReject)
  frame:InsertNewOption("checkbox", localePath.ignorePartyInvitation, nil, OPTION_ITEM_IGNORE_PARTY_INVITATION)
  frame:InsertNewOption("checkbox", localePath.ignoreRaidInvitation, nil, OPTION_ITEM_IGNORE_RAID_INVITATION)
  frame:InsertNewOption("checkbox", localePath.ignoreRaidJoint, nil, OPTION_ITEM_IGNORE_RAID_JOINT)
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.squad then
    frame:InsertNewOption("checkbox", localePath.ignoreSquadInvitation, nil, OPTION_ITEM_IGNORE_SQUAD_INVITATION)
  end
  frame:InsertNewOption("checkbox", localePath.ignoreExpeditionInvitation, nil, OPTION_ITEM_IGNORE_EXPEDITION_INVITATION)
  frame:InsertNewOption("checkbox", localePath.ignoreFamilyInvitation, nil, OPTION_ITEM_IGNORE_FAMILY_INVITATION)
  frame:InsertNewOption("checkbox", localePath.ignoreJuryInvitation, nil, OPTION_ITEM_IGNORE_JURY_INVITATION)
  frame:InsertNewOption("checkbox", localePath.ignoreTradeInvitation, nil, OPTION_ITEM_IGNORE_TRADE_INVITATION)
  frame:InsertNewOption("checkbox", localePath.ignoreDuelInvitation, nil, OPTION_ITEM_IGNORE_DUEL_INVITATION)
  if X2Nation:IsIndependenceFeature() then
    frame:InsertNewOption("checkbox", localePath.ignoreFactionInvitation, nil, OPTION_ITEM_IGNORE_FACTION_INVITATION)
  end
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("checkbox", localePath.ignoreWhisperInvitation, nil, OPTION_ITEM_IGNORE_WHISPER_INVITATION)
  if optionLocale.useIgnoreChatFilter then
    frame:InsertNewOption("checkbox", localePath.ignoreChatFilter, nil, OPTION_ITEM_IGNORE_CHAT_FILTER)
  end
  frame:InsertNewOption(OPTION_PARTITION_LINE)
  frame:InsertNewOption("subBigTitle", localePath.subTitleMouseInputOption)
  MakeMouseSensitivityControl(frame)
  frame:InsertNewOption("checkbox", localePath.mouseInvertXAxis, nil, OPTION_ITEM_MOUSE_INVERT_X_AXIS)
  frame:InsertNewOption("checkbox", localePath.mouseInvertYAxis, nil, OPTION_ITEM_MOUSE_INVERT_Y_AXIS)
  return frame
end
