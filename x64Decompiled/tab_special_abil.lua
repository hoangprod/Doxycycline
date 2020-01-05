local leftSectionSlotIndex = 1
local selectedMutaionSkill
local selectedAbility = 0
local SetSlotTooltipHandler = function(slot)
  function slot:OnEnter()
    local info = self:GetTooltip()
    if info ~= nil then
      ShowTooltip(info, self)
    end
  end
  slot:SetHandler("OnEnter", slot.OnEnter)
  function slot:OnLeave()
    HideTooltip()
  end
  slot:SetHandler("OnLeave", slot.OnLeave)
end
local function UpdateSkillSetting(wnd, selectIndex)
  if selectIndex == nil then
    selectIndex = 0
  end
  selectedMutaionSkill = X2Ability:GetMutationSkillInfo()
  if selectedMutaionSkill == nil then
    return
  end
  X2Ability:SetSelectSpecialAbility(selectedMutaionSkill.ability)
  wnd.leftSection:Update()
  wnd.rightSection:Update()
end
local function SetTransformationButtonsHandler(wnd, btn, index)
  local function LeftButtonLeftClickFunc()
    UpdateSkillSetting(wnd)
  end
  btn:SetHandler("OnClick", LeftButtonLeftClickFunc)
end
local GetDefaultDrawableButtonStyle = function(path, coordsKey)
  local drawableBasicStyle = BUTTON_BASIC.DEFAULT_DRAWABLE
  drawableBasicStyle.path = path
  drawableBasicStyle.coordsKey = coordsKey
  return drawableBasicStyle
end
local CreateTopSection = function(parent, wnd)
  local topSection = wnd:CreateChildWidget("emptywidget", "topSection", 0, true)
  topSection:SetExtent(parent:GetWidth(), 150)
  topSection:AddAnchor("TOP", wnd, "TOP", 0, 15)
  local topSectionBg = topSection:CreateDrawable(TEXTURE_PATH.SKILL, "wheel_bg", "background")
  topSectionBg:AddAnchor("TOPLEFT", topSection, 0, 0)
  return topSection
end
local function CreateLeftSection(wnd)
  local leftSection = wnd:CreateChildWidget("emptywidget", "leftSection", 0, true)
  leftSection:AddAnchor("TOPLEFT", wnd, 0, 10)
  leftSection:AddAnchor("BOTTOMRIGHT", wnd, -220, 0)
  local leftSectionBg = leftSection:CreateDrawable(TEXTURE_PATH.SPECIAL_SKILL, "background", "background")
  leftSectionBg:AddAnchor("TOPLEFT", leftSection, 0, 0)
  local abilityName = leftSection:CreateChildWidget("label", "abilityName", 0, true)
  abilityName:SetExtent(leftSection:GetWidth(), 16)
  abilityName:AddAnchor("TOP", leftSection, "TOP", 0, 80)
  abilityName.style:SetAlign(ALIGN_CENTER)
  abilityName.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  ApplyTextColor(abilityName, FONT_COLOR.TITLE)
  local selectedAbilSlotBg = leftSection:CreateDrawable(TEXTURE_PATH.SPECIAL_SKILL, "slot_gray", "background")
  selectedAbilSlotBg:AddAnchor("TOP", abilityName, "BOTTOM", 0, 5)
  local selectedAbilSlot = CreateActionSlot(leftSection, "selectedSkill", ISLOT_CONSTANT, leftSectionSlotIndex)
  selectedAbilSlot:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
  selectedAbilSlot:AddAnchor("CENTER", selectedAbilSlotBg, "CENTER", 0, 4)
  SetSlotTooltipHandler(selectedAbilSlot)
  local slotLockImg = leftSection:CreateDrawable(TEXTURE_PATH.SPECIAL_SKILL, "locked", "overlay")
  slotLockImg:AddAnchor("CENTER", selectedAbilSlot, "CENTER", 0, 0)
  local raceRscInfoList = {
    warborn = {
      imgKey = "warborn_image",
      desc = "special_abil_warborn_desc"
    },
    dwarf = {
      imgKey = "dwarf_image",
      desc = "special_abil_dwarf_desc"
    }
  }
  local raceRscInfo = raceRscInfoList[X2Unit:UnitRace("player")]
  local raceImg = leftSection:CreateDrawable(TEXTURE_PATH.SPECIAL_SKILL, raceRscInfo.imgKey, "overlay")
  raceImg:AddAnchor("TOP", selectedAbilSlotBg, "BOTTOM", 0, 50)
  local desc = leftSection:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetExtent(leftSection:GetWidth() - 18, 58)
  desc:AddAnchor("TOP", selectedAbilSlotBg, "BOTTOM", 0, 17)
  desc.style:SetAlign(ALIGN_CENTER)
  desc.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  ApplyTextColor(desc, FONT_COLOR.GRAY)
  local descBg = CreateContentBackground(leftSection, "TYPE5", "white")
  descBg:AddAnchor("TOPLEFT", desc, -8, -15)
  descBg:AddAnchor("BOTTOMRIGHT", desc, -10, 15)
  local learnBtn = leftSection:CreateChildWidget("button", "learnBtn", 0, true)
  learnBtn:AddAnchor("TOP", desc, "BOTTOM", 0, 32)
  ApplyButtonSkin(learnBtn, BUTTON_BASIC.DEFAULT)
  learnBtn:SetText(GetCommonText("learning"))
  leftSection.learnBtn = learnBtn
  local function LearnSpecialAbilityDialogHandler(dialogWnd)
    if selectedMutaionSkill == nil then
      UIParent:Warning(string.format("[Lua Error] invalid selected ability."))
      return
    end
    local itemType, haveCnt, needCnt = X2Ability:GetSpecialAbilityLearnItemInfo()
    if itemType == nil then
      return
    end
    dialogWnd:SetTitle(GetUIText(COMMON_TEXT, "special_abil_active"))
    dialogWnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "special_abil_confirm_active", locale.common.abilityNameWithStr(X2Ability:GetAbilityStr(selectedMutaionSkill.ability))))
    local data = {
      itemInfo = X2Item:GetItemInfoByType(itemType),
      stack = {haveCnt, needCnt}
    }
    dialogWnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
    function dialogWnd:OkProc()
      X2Ability:LearnSpecialAbility(selectedMutaionSkill.ability)
    end
  end
  local function UpdateDescLabelAndButton(isLearn)
    desc:RemoveAllAnchors()
    learnBtn:Show(not isLearn)
    raceImg:Show(isLearn)
    if not isLearn then
      ApplyTextColor(desc, FONT_COLOR.GRAY)
      desc:AddAnchor("TOP", selectedAbilSlotBg, "BOTTOM", 0, 17)
      desc:SetText(GetCommonText("special_abil_learn_desc"))
    else
      ApplyTextColor(desc, FONT_COLOR.DEFAULT)
      desc:AddAnchor("TOP", raceImg, "BOTTOM", 0, 44)
      desc:SetText(GetCommonText(raceRscInfo.desc))
    end
  end
  local function OnLearnSpecialAbil()
    X2DialogManager:RequestDefaultDialog(LearnSpecialAbilityDialogHandler, wnd:GetParent():GetId())
  end
  learnBtn:SetHandler("OnClick", OnLearnSpecialAbil)
  function leftSection:Update()
    local abilInfo = X2Ability:GetAbilityInfo(selectedMutaionSkill.ability)
    if abilInfo == nil then
      UIParent:Warning(string.format("[Lua Error] invalid abil info~!"))
      slotLockImg:Show(true)
      return
    end
    slotLockImg:Show(false)
    local name = string.format("%s", locale.common.abilityNameWithStr(X2Ability:GetAbilityStr(selectedMutaionSkill.ability)))
    abilityName:SetText(name)
    local isLearn = X2Ability:IsLearnedSpecialAbility(selectedMutaionSkill.ability)
    UpdateDescLabelAndButton(isLearn)
    selectedAbilSlot:EstablishSkill(selectedMutaionSkill.skill)
  end
  return leftSection
end
local function CreateRightSection(wnd)
  local rightSection = wnd:CreateChildWidget("emptywidget", "rightSection", 0, true)
  rightSection:AddAnchor("TOPLEFT", wnd.leftSection, "TOPRIGHT", 15, 0)
  rightSection:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local guide = CreateGuidePart(rightSection, "special_abil", "special_abil_tooltip_msg")
  local slotIndex = 1
  rightSection.slots = {}
  local function CreateAcionSlotGroup(key, slotGroupName, slotCount, skillEnumVal)
    local slotGroup = rightSection:CreateChildWidget("emptywidget", key, 0, true)
    slotGroup:SetExtent(rightSection:GetWidth(), 10)
    local slotBg = CreateContentBackground(slotGroup, "TYPE10", "brown_3")
    slotBg:AddAnchor("TOPLEFT", slotGroup, -8, 12)
    slotBg:AddAnchor("BOTTOMRIGHT", slotGroup, -10, 10)
    local groupName = slotGroup:CreateChildWidget("label", "groupName", 0, true)
    groupName:SetExtent(rightSection:GetWidth(), 16)
    groupName:AddAnchor("TOPLEFT", slotGroup, 0, 0)
    groupName.style:SetAlign(ALIGN_LEFT)
    groupName.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    ApplyTextColor(groupName, FONT_COLOR.TITLE)
    groupName:SetText(slotGroupName)
    local linePerCnt = 4
    for i = 1, slotCount do
      local posX = (i - 1) % linePerCnt * (ICON_SIZE.DEFAULT + 6)
      local posY = 4 + math.floor((i - 1) / linePerCnt) * (ICON_SIZE.DEFAULT + 6)
      local slot = CreateActionSlot(slotGroup, "combatSkill", ISLOT_ABILITY_VIEW, skillEnumVal + i)
      slot:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
      slot:AddAnchor("TOPLEFT", groupName, "BOTTOMLEFT", posX, posY)
      SetSlotTooltipHandler(slot)
      slot.index = skillEnumVal + i
      rightSection.slots[slotIndex] = slot
      slotIndex = slotIndex + 1
    end
    local _, height = F_LAYOUT.GetExtentWidgets(groupName, rightSection.slots[slotIndex - 1])
    slotGroup:SetHeight(height)
    return slotGroup
  end
  local activeSkillGroup = CreateAcionSlotGroup("activeSkill", GetUIText(SKILL_TEXT, "abilityButtonText"), 8, SPECIAL_ACTIVE_SKILL)
  activeSkillGroup:AddAnchor("TOP", rightSection, "TOP", 8, guide:GetHeight() + 70)
  local passiveSkillGroup = CreateAcionSlotGroup("passiveSkill", GetUIText(SKILL_TEXT, "category_buff"), 8, SPECIAL_PASSIVE_SKILL)
  passiveSkillGroup:AddAnchor("BOTTOM", rightSection, "BOTTOM", 8, -144)
  function rightSection:Update()
    for i = 1, #rightSection.slots do
      local slot = rightSection.slots[i]
      slot:EstablishSlot(ISLOT_ABILITY_VIEW, slot.index)
    end
  end
  return rightSection
end
function CreataeSpecialWindow(id, parent)
  local group = parent:CreateChildWidget("emptywidget", id, 0, true)
  group:SetExtent(parent:GetWidth() - 49, parent:GetHeight() - 39)
  group.leftSection = CreateLeftSection(group)
  group.rightSection = CreateRightSection(group)
  function group:Update()
    UpdateSkillSetting(self)
  end
  group.Event = {
    SPECIAL_ABILITY_LEARNED = function(recvAbility)
      group:Update()
      group.leftSection.learnBtn:Enable(true)
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      group:Update()
    end
  }
  group:SetHandler("OnEvent", function(this, event, ...)
    group.Event[event](...)
  end)
  RegistUIEvent(group, group.Event)
  return group
end
