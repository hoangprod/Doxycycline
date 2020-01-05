local SUB_WINDOW_GAP = 28
local WINDOW_INSET = {
  left = 0,
  top = 30,
  right = 0,
  bottom = 0
}
local MAX_PASSIVE_SKILL = 8
local SECTION_WIDTH = 195
local SECTION_HEIGHT = 400
local SECTION_OFFSET_X = {
  0,
  0,
  0
}
local SKILL_SLOT_OFFSET_X = 48
local SKILL_WINDOW_HEIGHT_OFFSET = 0
local SKILL_POINT_OFFSET = 10
local function AdjustSectionWidgetExtent()
  if IsTransformablePlayer() then
    SECTION_WIDTH = 215
    SKILL_SLOT_OFFSET_X = 56
    SECTION_OFFSET_X = {
      10,
      0,
      -10
    }
  end
end
local ABILITY_VIEW_KIND = {
  {ACTIVE_SKILL_1, PASSIVE_SKILL_1},
  {ACTIVE_SKILL_2, PASSIVE_SKILL_2},
  {ACTIVE_SKILL_3, PASSIVE_SKILL_3}
}
local ABILITY_REQUIRED_LEVEL = {
  ABILITY_ACTIVATION_LEVEL_1,
  ABILITY_ACTIVATION_LEVEL_2,
  ABILITY_ACTIVATION_LEVEL_3
}
local function CreateLearnLevelRequirementWidget(id, parent, index)
  local widget = CreateEmptyWindow(id, parent)
  widget:SetExtent(SECTION_WIDTH, SECTION_HEIGHT)
  widget:AddAnchor("TOP", parent, SECTION_OFFSET_X[index], 0)
  widget:SetTitleInset(0, 0, 0, 80)
  widget:SetTitleText(locale.skill.newAbilityActivation)
  widget.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  ApplyTitleFontColor(widget, FONT_COLOR.DEFAULT)
  widget:Show(false)
  local requirement = widget:CreateChildWidget("textbox", "requirement", 0, true)
  requirement:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  ApplyTextColor(requirement, FONT_COLOR.DEFAULT)
  F_LAYOUT.AttachAnchor(requirement, widget, 0, -30)
  local level = ABILITY_REQUIRED_LEVEL[index]
  local str = locale.skill.GetAbilityRequirementText(level)
  requirement:SetText(str)
  requirement:Show(true)
  return widget
end
local function CreateAbilitySelectWidget(id, parent, index)
  local widget = CreateEmptyWindow(id, parent)
  widget:SetExtent(SECTION_WIDTH, SECTION_HEIGHT)
  widget:AddAnchor("TOP", parent, SECTION_OFFSET_X[index], 0)
  widget:SetTitleText(locale.skill.chooseAbility)
  widget:SetTitleInset(0, 23, 0, 0)
  widget.titleStyle:SetAlign(ALIGN_TOP)
  widget.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTitleFontColor(widget, FONT_COLOR.TITLE)
  widget:Show(false)
  local bg = CreateContentBackground(widget, "TYPE3", "gray")
  bg:AddAnchor("TOPLEFT", widget, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  bg:AddAnchor("BOTTOMRIGHT", widget, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_SIDE * 2)
  widget.btn = {}
  for i = 1, MAX_ABILITY_TYPE do
    do
      local btn = widget:CreateChildWidget("button", "abilityBtns", i, true)
      ApplyButtonSkin(btn, BUTTON_CONTENTS.ALL_ABILITY)
      function btn:OnClick()
        X2Ability:SetAbilityToView(index, btn.ability)
        parent:Update()
        parent:UpdateJobName()
      end
      btn:SetHandler("OnClick", btn.OnClick)
      local OnEnter = function(self)
        SetTooltip(GetAbilityTooltip(self.ability), self)
      end
      btn:SetHandler("OnEnter", OnEnter)
      local OnLeave = function(self)
        HideTooltip()
      end
      btn:SetHandler("OnLeave", OnLeave)
      function btn:SetAbility(ability)
        self.ability = ability
        btn:SetText(GetAbilityName(ability))
      end
      function btn:SetLayout(recommend)
        if recommend then
          ChangeButtonSkin(self, BUTTON_CONTENTS.SKILL_ABILITY)
        else
          ChangeButtonSkin(self, BUTTON_CONTENTS.ALL_ABILITY)
          if skillLocale.abilityBtnWidth ~= nil then
            local buttonTable = widget.btn
            AdjustBtnLongestTextWidth(buttonTable, skillLocale.abilityBtnWidth)
          end
        end
      end
      widget.btn[i] = btn
    end
  end
  widget.ability = {}
  widget.recommends = {}
  function widget:Reset()
    for i = 1, MAX_ABILITY_TYPE do
      self.btn[i]:Show(false)
    end
    self.abilities = {}
    self.recommends = {}
  end
  function widget:Update()
    self:Reset()
    local abilities, recommendAbilities = GetSelectableAbilities()
    local btnIdx = 1
    if recommendAbilities then
      for i = 1, #recommendAbilities do
        self:SetRecommendAbilityBtn(self.btn[btnIdx], recommendAbilities[i])
        btnIdx = btnIdx + 1
      end
    end
    for i = 1, #abilities do
      self:SetAbilityBtn(self.btn[btnIdx], abilities[i])
      btnIdx = btnIdx + 1
    end
    self:SetButtonLayouts()
  end
  function widget:SetRecommendAbilityBtn(btn, ability)
    table.insert(self.recommends, btn)
    btn:SetAbility(ability)
    btn:SetLayout(true)
  end
  function widget:SetAbilityBtn(btn, ability)
    table.insert(self.abilities, btn)
    btn:SetAbility(ability)
    btn:SetLayout(false)
  end
  function widget:SetButtonLayouts()
    skillLocale.SetAbilitySelectLayoutFunc(self)
  end
  return widget
end
local CreateConfirmWnd = function(id, parent, index)
  local widget = parent:CreateChildWidget("emptyWidget", id, 0, true)
  widget:Show(false)
  local confirmLabel = widget:CreateChildWidget("textbox", "confirmLabel", 0, true)
  confirmLabel:AddAnchor("TOP", widget, 0, 7)
  confirmLabel:SetExtent(194, FONT_SIZE.MIDDLE)
  confirmLabel:Show(true)
  ApplyTextColor(confirmLabel, FONT_COLOR.SKYBLUE)
  local info = {
    leftButtonStr = GetCommonText("ok"),
    rightButtonStr = GetCommonText("cancel"),
    buttonBottomInset = 0
  }
  CreateWindowDefaultTextButtonSet(widget, info)
  return widget
end
local function CreateSkillSlot(widget, count, kind, yOffset)
  widget.skillBtns = {}
  local xOffset = 0
  for i = 1, count do
    local button = CreateActionSlot(widget, "active_skill", ISLOT_ABILITY_VIEW, kind + i)
    button:Show(false)
    button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    button:AddAnchor("TOPLEFT", widget, xOffset, yOffset)
    function button:OnEnter()
      local info = self:GetTooltip()
      if info ~= nil then
        ShowTooltip(info, self)
      end
    end
    button:SetHandler("OnEnter", button.OnEnter)
    function button:OnLeave()
      HideTooltip()
    end
    button:SetHandler("OnLeave", button.OnLeave)
    widget.skillBtns[i] = button
    xOffset = xOffset + SKILL_SLOT_OFFSET_X
    if i % 4 == 0 then
      xOffset = 0
      yOffset = yOffset + 48
    end
  end
  widget:SetHeight(yOffset)
end
local function CreateActiveSkillList(id, parent, index)
  local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
  widget:Show(false)
  local combatLabel = widget:CreateChildWidget("label", "combatLabel", 0, true)
  combatLabel:SetText(locale.skill.abilityButtonText)
  combatLabel:SetAutoResize(true)
  combatLabel:SetHeight(FONT_SIZE.LARGE)
  combatLabel:AddAnchor("TOPLEFT", widget, 0, 0)
  combatLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(combatLabel, FONT_COLOR.BROWN)
  local skillBackground = CreateContentBackground(widget, "TYPE10", "brown_3")
  skillBackground:AddAnchor("TOPLEFT", widget, -8, 12)
  skillBackground:AddAnchor("BOTTOMRIGHT", widget, 2, 5)
  local kind = ABILITY_VIEW_KIND[index][1]
  CreateSkillSlot(widget, MAX_ACTIVE_SKILL, kind, MARGIN.WINDOW_SIDE)
  local skillWnd = widget:GetParent():GetParent():GetParent()
  function widget:Update()
    local count = X2Ability:GetAbilitySlotCount(kind)
    for i = 1, MAX_ACTIVE_SKILL do
      local button = widget.skillBtns[i]
      if i <= count then
        button:EstablishSlot(ISLOT_ABILITY_VIEW, kind + i)
        button.useView = true
        button.showSavedSkills = false
        local skillType = button:GetSkillType()
        if skillType and skillWnd.savedSkills then
          local skillLevel = skillWnd.savedSkills[tostring(skillType)]
          if skillLevel then
            button.showSavedSkills = true
            button.skillLevel = skillLevel
          end
        end
        button:CheckStateImage()
        button:Show(true)
      else
        button:Show(false)
      end
    end
  end
  function widget:SetPreviewMode(arg)
    for i = 1, MAX_ACTIVE_SKILL do
      local button = widget.skillBtns[i]
      button.onlyView = arg
    end
  end
  return widget
end
local function CreatePassiveSkillList(id, parent, index)
  local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
  widget:Show(false)
  local buffLabel = widget:CreateChildWidget("label", "buffLabel", 0, true)
  buffLabel:SetText(locale.skill.continue)
  buffLabel:SetAutoResize(true)
  buffLabel:SetHeight(FONT_SIZE.LARGE)
  buffLabel:AddAnchor("TOPLEFT", widget, 0, 0)
  buffLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(buffLabel, FONT_COLOR.BROWN)
  local skillBackground = CreateContentBackground(widget, "TYPE10", "blue_2")
  skillBackground:AddAnchor("TOPLEFT", widget, -8, 12)
  skillBackground:AddAnchor("BOTTOMRIGHT", widget, 2, 5)
  local kind = ABILITY_VIEW_KIND[index][2]
  widget.lines = {}
  for i = 1, MAX_PASSIVE_SKILL / 4 do
    local line = CreateLine(widget, "TYPE2", "background")
    widget.lines[i] = line
  end
  CreateSkillSlot(widget, MAX_PASSIVE_SKILL, kind, MARGIN.WINDOW_SIDE)
  local skillWnd = widget:GetParent():GetParent():GetParent()
  function widget:Update()
    local count = X2Ability:GetAbilitySlotCount(kind)
    local last = widget.skillBtns[1]
    for i = 1, MAX_PASSIVE_SKILL do
      local button = widget.skillBtns[i]
      if i <= count then
        button:EstablishSlot(ISLOT_ABILITY_VIEW, kind + i)
        button.showSavedSkills = false
        button:Show(true)
        last = button
        local passiveBuffType = button:GetPassiveBuffType()
        if passiveBuffType and skillWnd.savedPassiveBuffs then
          local hasPassiveBuff = skillWnd.savedPassiveBuffs[tostring(passiveBuffType)]
          if hasPassiveBuff then
            button.showSavedSkills = true
          end
        end
      else
        button:Show(false)
      end
    end
    local startIndex = 1
    local divideIndex = 4
    for i = 1, #self.lines do
      local startTarget = self.skillBtns[startIndex]
      if startIndex ~= nil then
        local endTarget
        for j = startIndex + 1, divideIndex do
          local nextTarget = self.skillBtns[j]
          if nextTarget ~= nil and nextTarget:IsVisible() then
            endTarget = nextTarget
          end
        end
        if endTarget ~= nil then
          self.lines[i]:AddAnchor("LEFT", startTarget, 0, 0)
          self.lines[i]:AddAnchor("RIGHT", endTarget, 0, 0)
          self.lines[i]:SetCoords(0, 0, self.lines[i]:GetWidth(), 5)
        end
      end
      startIndex = startIndex + i * divideIndex
      divideIndex = startIndex - 1 + divideIndex
    end
  end
  function widget:SetPreviewMode(arg)
    for i = 1, MAX_PASSIVE_SKILL do
      local button = widget.skillBtns[i]
      button.onlyView = arg
    end
  end
  return widget
end
local function SetViewOfSkillWindow(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetExtent(150, 30 + SKILL_WINDOW_HEIGHT_OFFSET)
  local label = window:CreateChildWidget("label", "label", 0, true)
  label:Show(true)
  label:SetExtent(0, 15)
  label:AddAnchor("TOPLEFT", window, 0, 0)
  label:SetText(tostring("none"))
  label:SetAutoResize(true)
  label.style:SetAlign(ALIGN_LEFT)
  label.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(label, FONT_COLOR.DEFAULT)
  local point = window:CreateChildWidget("label", "point", 0, true)
  point:Show(true)
  point:SetExtent(0, 13)
  point:AddAnchor("TOPRIGHT", window, -2, 3)
  point:SetAutoResize(true)
  point.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(point, FONT_COLOR.DEFAULT)
  window.statusBar = W_BAR.CreateSkillBar(id .. ".statusBar", window)
  window.statusBar:AddAnchor("TOPLEFT", window, 0, 20)
  window.statusBar:AddAnchor("TOPRIGHT", window, 0, 20)
  return window
end
local function CreateSkillWindow(id, parent)
  local window = SetViewOfSkillWindow(id, parent)
  window.statusBar:SetMinMaxValues(0, 100)
  function window:Update(level, nameIndex, percent, curPoint, maxPoint)
    window.label:SetText(tostring(level) .. " " .. locale.common.abilityNameWithId(nameIndex))
    window.statusBar:SetValue(percent)
    window.point:SetText(string.format("%s/%s", tostring(curPoint), tostring(maxPoint)))
  end
  return window
end
local function CreateAbilityViewWidget(id, parent, index)
  local viewWidget = CreateEmptyWindow(id, parent)
  viewWidget:SetExtent(SECTION_WIDTH, SECTION_HEIGHT)
  viewWidget:AddAnchor("TOP", parent, SECTION_OFFSET_X[index], 0)
  viewWidget:SetTitleInset(0, 23, 0, 0)
  viewWidget.titleStyle:SetAlign(ALIGN_TOP)
  viewWidget.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTitleFontColor(viewWidget, FONT_COLOR.TITLE)
  viewWidget:Show(false)
  local abilityBar = CreateSkillWindow("abilityBar", viewWidget)
  abilityBar:Show(false)
  abilityBar:AddAnchor("TOPLEFT", viewWidget, 0, 0)
  abilityBar:AddAnchor("TOPRIGHT", viewWidget, 0, 0)
  viewWidget.abilityBar = abilityBar
  local confirmWnd = CreateConfirmWnd("confirmWnd", viewWidget, index)
  confirmWnd:AddAnchor("TOPLEFT", viewWidget, "BOTTOMLEFT", 0, -16)
  confirmWnd:AddAnchor("BOTTOMRIGHT", viewWidget, "BOTTOMRIGHT", 0, 49)
  viewWidget.confirmWnd = confirmWnd
  local activeSkillWnd = CreateActiveSkillList("activeSkillWnd", viewWidget, index)
  activeSkillWnd:AddAnchor("TOPLEFT", abilityBar, "BOTTOMLEFT", 0, 16)
  activeSkillWnd:AddAnchor("TOPRIGHT", abilityBar, "BOTTOMRIGHT", 0, 16)
  viewWidget.activeSkillWnd = activeSkillWnd
  local passiveSkillWnd = CreatePassiveSkillList("passiveSkillWnd", viewWidget, index)
  passiveSkillWnd:AddAnchor("TOPLEFT", activeSkillWnd, "BOTTOMLEFT", 0, 43)
  passiveSkillWnd:AddAnchor("TOPRIGHT", activeSkillWnd, "BOTTOMRIGHT", 0, 43)
  viewWidget.passiveSkillWnd = passiveSkillWnd
  local resetBtn = viewWidget:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:Show(false)
  resetBtn:AddAnchor("TOP", passiveSkillWnd, "BOTTOM", 0, 41)
  resetBtn:SetText(GetCommonText("init"))
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.DEFAULT)
  viewWidget.resetBtn = resetBtn
  local onlyView = false
  function viewWidget:SetPreviewMode(arg)
    self.abilityBar:Show(not arg)
    self.resetBtn:Show(not arg)
    self:SetTitleText(arg and locale.skill.chooseAbility or "")
    self.confirmWnd:Show(arg)
    self.activeSkillWnd:SetPreviewMode(arg)
    self.passiveSkillWnd:SetPreviewMode(arg)
    onlyView = arg
  end
  function viewWidget:Update(saveIndex)
    local ability = X2Ability:GetAbilityFromView(index)
    if onlyView then
      local askText = locale.skill.GetAskSelectAbilityText(GetAbilityName(ability))
      self.confirmWnd.confirmLabel:SetText(askText)
    else
      self:UpdateAbilityExp(saveIndex)
    end
    self.activeSkillWnd:Update()
    self.activeSkillWnd:Show(true)
    self.passiveSkillWnd:Update()
    self.passiveSkillWnd:Show(true)
    if saveIndex then
      resetBtn:Enable(false)
    else
      resetBtn:Enable(true)
    end
  end
  local function LeftButtonLeftClickFunc()
    local ability = X2Ability:GetAbilityFromView(index)
    X2Ability:LearnAbility(ability)
  end
  confirmWnd.leftButton:SetHandler("OnClick", LeftButtonLeftClickFunc)
  local function RightButtonLeftClickFunc()
    X2Ability:SetAbilityToView(index, ABILITY_MAX)
    parent:Update()
    parent:UpdateJobName()
  end
  confirmWnd.rightButton:SetHandler("OnClick", RightButtonLeftClickFunc)
  function resetBtn:OnClick(arg)
    if arg == "LeftButton" then
      X2Ability:AskResetSkills(index)
    end
  end
  resetBtn:SetHandler("OnClick", resetBtn.OnClick)
  function abilityBar.statusBar:OnEnter()
    local ability = X2Ability:GetAbilityFromView(index)
    local strName = GetAbilityName(ability)
    local _, percent, cumulatedExp, nextLevelTotalExp = GetAbilityLevelExpPersent(ability)
    local str = string.format("%s : %s / %s (%d%%)", strName, cumulatedExp, nextLevelTotalExp, percent)
    SetTooltip(str, self)
  end
  abilityBar.statusBar:SetHandler("OnEnter", abilityBar.statusBar.OnEnter)
  function abilityBar.statusBar:OnLeave()
    HideTooltip()
  end
  abilityBar.statusBar:SetHandler("OnLeave", abilityBar.statusBar.OnLeave)
  function viewWidget:UpdateAbilityExp(saveIndex)
    local ability = X2Ability:GetAbilityFromView(index)
    if ability ~= nil then
      if saveIndex == nil then
        saveIndex = -1
      end
      local level, percent, _, _ = GetAbilityLevelExpPersent(ability)
      local maxPoint, curPoint = X2Ability:GetSkillPoint(ability, saveIndex)
      self.abilityBar:Update(level, ability, percent, curPoint, maxPoint)
    end
  end
  return viewWidget
end
local function CreateCombatSkillList(id, parent, index)
  local wnd = CreateEmptyWindow(id .. tostring(index), parent)
  wnd.learnLevelReq = CreateLearnLevelRequirementWidget(id .. ".learnLevel", wnd, index)
  wnd.abilitySelect = CreateAbilitySelectWidget(id .. ".abilitySelect", wnd, index)
  wnd.abilityView = CreateAbilityViewWidget(id .. ".abilityView", wnd, index)
  function wnd:HideAll()
    wnd.learnLevelReq:Show(false)
    wnd.abilitySelect:Show(false)
    wnd.abilityView:Show(false)
  end
  function wnd:UpdateJobName()
    if parent.UpdateJobName then
      parent:UpdateJobName()
    end
  end
  function wnd:Update()
    self:HideAll()
    local ability = X2Ability:GetAbilityFromView(index)
    if ability == nil then
      if X2Unit:UnitLevel("player") >= ABILITY_REQUIRED_LEVEL[index] then
        if index ~= 1 and X2Ability:GetAbilityFromView(index - 1) ~= nil then
          wnd.abilitySelect:Update()
          wnd.abilitySelect:Show(true)
        else
          wnd.learnLevelReq:Show(true)
        end
      else
        wnd.learnLevelReq:Show(true)
      end
    else
      wnd.abilityView:SetPreviewMode(not X2Ability:IsActiveAbility(ability))
      wnd.abilityView:Update()
      wnd.abilityView:Show(true)
    end
  end
  function wnd:UpdateSavedSkillSetPreview(saveIndex)
    self:HideAll()
    wnd.abilityView:SetPreviewMode(false)
    wnd.abilityView:Update(saveIndex)
    wnd.abilityView:Show(true)
  end
  function wnd:UpdateAbilityExp()
    wnd.abilityView:UpdateAbilityExp()
  end
  return wnd
end
function CreateCombatSkillWindow(id, parent)
  local wnd = CreateEmptyWindow(id, parent)
  parent.content = wnd
  wnd.children = {}
  if X2Player:GetFeatureSet().uiAvi and skillLocale.useUiAvi then
    local uiAviBtn = wnd:CreateChildWidget("button", "uiAviBtn", 0, true)
    uiAviBtn:SetText(X2Locale:LocalizeUiText(TUTORIAL_TEXT, "ui_avi"))
    uiAviBtn:AddAnchor("TOPRIGHT", wnd, 0, -60)
    ApplyButtonSkinTable(uiAviBtn, BUTTON_CONTENTS.CUTSCENE_PLAY)
    uiAviBtn:Show(true)
    function uiAviBtn:OnClick()
      ADDON:ToggleContent(UIC_UI_AVI)
    end
    uiAviBtn:SetHandler("OnClick", uiAviBtn.OnClick)
  end
  local skillPoint = wnd:CreateChildWidget("textbox", "skillPoint", 0, true)
  skillPoint:Show(true)
  skillPoint:AddAnchor("TOPLEFT", wnd, 0, MARGIN.WINDOW_SIDE / 1.5 + SKILL_POINT_OFFSET)
  skillPoint:SetExtent(100, FONT_SIZE.LARGE)
  skillPoint.style:SetAlign(ALIGN_LEFT)
  skillPoint.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(skillPoint, FONT_COLOR.TITLE)
  local icon = skillPoint:CreateDrawable(TEXTURE_PATH.SKILL, "star", "background")
  icon:SetExtent(13, 13)
  icon:AddAnchor("LEFT", skillPoint, "RIGHT", -4, 0)
  local jobName = wnd:CreateChildWidget("label", "jobName", 0, true)
  jobName:Show(true)
  jobName:SetAutoResize(true)
  jobName:AddAnchor("TOPLEFT", skillPoint, "BOTTOMLEFT", 0, 9)
  jobName:SetHeight(15)
  jobName.style:SetAlign(ALIGN_RIGHT)
  jobName.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(jobName, FONT_COLOR.TITLE)
  for index = 1, MAX_ABILITY_COUNT do
    local content = CreateCombatSkillList(id .. ".ability", wnd, index)
    content:Show(true)
    table.insert(wnd.children, content)
  end
  local synergyButton = wnd:CreateChildWidget("button", "synergyButton", 0, true)
  ApplyButtonSkin(synergyButton, BUTTON_BASIC.DEFAULT)
  synergyButton:SetText(GetCommonText("synergy_window_title"))
  synergyButton:SetAutoResize(true)
  synergyButton:SetExtent(math.max(synergyButton:GetWidth(), 114), 34)
  synergyButton:AddAnchor("TOPRIGHT", wnd, 0, 8 + SKILL_POINT_OFFSET)
  local OnClickSynergy = function()
    CreateSynergySkillWindow("synergy", "UIParent")
  end
  synergyButton:SetHandler("OnClick", OnClickSynergy)
  CreateSaveAbilitiesWidget(wnd)
  function wnd:Update()
    local x = WINDOW_INSET.left
    local bottomPannelHeight = wnd.bottomPannel and wnd.bottomPannel:GetHeight() or 0
    local width = (wnd:GetWidth() - (MAX_ABILITY_COUNT - 1) * SUB_WINDOW_GAP) / MAX_ABILITY_COUNT
    local height = wnd:GetHeight() - (WINDOW_INSET.top + WINDOW_INSET.bottom + bottomPannelHeight)
    for i = 1, MAX_ABILITY_COUNT do
      wnd.children[i]:AddAnchor("TOPLEFT", jobName, "BOTTOMLEFT", x, 21)
      wnd.children[i]:SetExtent(width, height)
      x = x + width + SUB_WINDOW_GAP
      wnd.children[i]:Update()
    end
    self:UpdateJobName()
    self:UpdateSkillPoint()
  end
  function wnd:UpdateJobName()
    local ab1 = X2Ability:GetAbilityFromView(1)
    local ab2 = X2Ability:GetAbilityFromView(2)
    local ab3 = X2Ability:GetAbilityFromView(3)
    local name = F_UNIT.GetPlayerJobName(ab1, ab2, ab3)
    self.jobName:SetText(locale.skill.GetJobText(name))
    self.jobName:Show(true)
  end
  function wnd:UpdateSkillPoint(selectIndex)
    local total = 0
    local used = 0
    if selectIndex then
      total, used = X2Ability:GetSkillPointInSavedSkillSet(selectIndex)
    else
      total, used = X2Ability:GetSkillPoint()
    end
    local count = total - used
    self.skillPoint:SetWidth(500)
    self.skillPoint:SetText(locale.skill.GetSkillPointText(count))
    self.skillPoint:SetWidth(self.skillPoint:GetLongestLineWidth() + 5)
  end
  function wnd:UpdateAbilityExp()
    for i = 1, MAX_ABILITY_COUNT do
      wnd.children[i]:UpdateAbilityExp()
    end
  end
  wnd.abilityEvent = {
    ABILITY_CHANGED = function()
      wnd:Update()
      if X2Player:GetFeatureSet().useSavedAbilities == false then
        return
      end
      wnd:UpdateJobComboList()
    end,
    SKILL_LEARNED = function()
      wnd:Update()
      if X2Player:GetFeatureSet().useSavedAbilities == false then
        return
      end
      wnd:UpdateJobComboList()
    end,
    SKILL_UPGRADED = function()
      wnd:Update()
    end,
    SKILLS_RESET = function()
      wnd:Update()
      if X2Player:GetFeatureSet().useSavedAbilities == false then
        return
      end
      wnd:UpdateJobComboList()
    end,
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      wnd:Update()
    end,
    EXP_CHANGED = function(stringId)
      wnd:UpdateAbilityExp()
    end,
    ABILITY_EXP_CHANGED = function(stringId)
      wnd:UpdateAbilityExp()
    end,
    PLAYER_ABILITY_LEVEL_CHANGED = function()
      wnd:Update()
    end,
    ENTERED_WORLD = function()
      wnd:Update()
    end,
    ABILITY_SET_CHANGED = function()
      if X2Player:GetFeatureSet().useSavedAbilities == false then
        return
      end
      wnd:UpdateJobComboList()
    end,
    ABILITY_SET_USABLE_SLOT_COUNT_CHANGED = function()
      if X2Player:GetFeatureSet().useSavedAbilities == false then
        return
      end
      wnd:UpdateJobComboList()
    end,
    SPELLCAST_START = function(spellName, castingTime, caster, castingUseable)
      if wnd.UpdateControlsEnable then
        wnd:UpdateControlsEnable(caster, false)
      end
    end,
    SPELLCAST_STOP = function(caster)
      if wnd.UpdateControlsEnable then
        wnd:UpdateControlsEnable(caster, true)
      end
    end,
    SPELLCAST_SUCCEEDED = function(caster)
      if wnd.UpdateControlsEnable then
        wnd:UpdateControlsEnable(caster, true)
      end
    end,
    UI_PERMISSION_UPDATE = function()
      wnd:UpdateByInstantGame()
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    wnd.abilityEvent[event](...)
  end)
  RegistUIEvent(wnd, wnd.abilityEvent)
  return wnd
end
