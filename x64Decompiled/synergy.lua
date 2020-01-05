local synergyWindow
local CreateSkillSlot = function(parent, widget, count, yOffset)
  local xOffset = 4
  local SKILL_SLOT_OFFSET_X = 48
  for i = 1, count do
    do
      local button = CreateActionSlot(widget, "active_skill" .. tostring(count), ISLOT_CONSTANT, 0)
      button:Show(false)
      button:AddAnchor("TOPLEFT", widget, xOffset, yOffset)
      local OnEnter = function(self)
        local info = self:GetTooltip()
        if info ~= nil then
          ShowTooltip(info, self)
        end
      end
      button:SetHandler("OnEnter", OnEnter)
      local OnLeave = function()
        HideTooltip()
      end
      button:SetHandler("OnLeave", OnLeave)
      local function LeftButtonClickFunc()
        HideTooltip()
        if parent.selectedSkill == button:GetSkillType() then
          parent.selectedSkill = 0
          parent.skillList = {}
          parent.drawType = 0
        else
          parent.selectedSkill = button:GetSkillType()
          parent.skillList = X2Ability:GetSynergySkills(parent.selectedSkill, true)
          parent.drawType = 1
        end
        parent:Update()
      end
      local function RightButtonClickFunc()
        HideTooltip()
        if parent.selectedSkill == button:GetSkillType() then
          parent.selectedSkill = 0
          parent.skillList = {}
          parent.drawType = 0
        else
          parent.selectedSkill = button:GetSkillType()
          parent.skillList = X2Ability:GetSynergySkills(parent.selectedSkill, false)
          parent.drawType = 2
        end
        parent:Update()
      end
      button:ReleaseHandler("OnClick")
      ButtonOnClickHandler(button, LeftButtonClickFunc, RightButtonClickFunc)
      local function SetOverImage(info)
        local over = widget:CreateDrawable(TEXTURE_PATH.SKILL_SYNERGY, info, "overoverlay")
        over:AddAnchor("CENTER", button, 0, -3)
        over:Show(false)
        return over
      end
      button.overGreen = SetOverImage("over_green")
      button.overBlue = SetOverImage("over_blue")
      button.overOrange = SetOverImage("over_orange")
      button.overPurple = SetOverImage("over_purple")
      button:DisableDefaultClick()
      xOffset = xOffset + SKILL_SLOT_OFFSET_X
      if i % 4 == 0 then
        xOffset = 4
        yOffset = yOffset + SKILL_SLOT_OFFSET_X
      end
      widget.skillBtns[i] = button
    end
  end
  widget:SetHeight(yOffset)
end
local function CreateSynergySkillList(id, parent, index)
  local widget = CreateEmptyWindow(id, parent)
  widget:SetWidth(195)
  local combo = W_CTRL.CreateComboBox("combo", widget)
  combo:SetWidth(188)
  combo:AddAnchor("TOP", widget, 0, 0)
  local bg = CreateContentBackground(widget, "TYPE10", "brown_3")
  bg:AddAnchor("TOPLEFT", combo, "BOTTOMLEFT", -8, 2)
  bg:AddAnchor("BOTTOMRIGHT", widget, 4, 7)
  widget.skillBtns = {}
  CreateSkillSlot(parent, widget, MAX_ACTIVE_SKILL, combo:GetHeight() + 10)
  widget.ability = X2Ability:GetAbilityFromView(index)
  function widget:Update()
    if widget.ability == nil or widget.ability == 0 then
      return
    end
    local skills = X2Ability:GetAbilityActiveSkills(widget.ability)
    for i = 1, MAX_ACTIVE_SKILL do
      do
        local button = widget.skillBtns[i]
        button.overGreen:Show(false)
        button.overBlue:Show(false)
        button.overOrange:Show(false)
        button.overPurple:Show(false)
        local overSelectTbl = {
          [1] = function()
            button.overBlue:Show(true)
          end,
          [2] = function()
            button.overOrange:Show(true)
          end,
          [3] = function()
            button.overPurple:Show(true)
          end
        }
        if i <= #skills then
          button:Show(true)
          button:EstablishSkill(skills[i])
          button.onlyView = true
          if skills[i] == parent.selectedSkill then
            button.overGreen:Show(true)
          elseif 0 < parent.drawType then
            for _, v in pairs(parent.skillList) do
              if v == skills[i] then
                overSelectTbl[parent.drawType]()
                break
              end
            end
          end
        else
          button:Show(false)
        end
      end
    end
  end
  function widget:UpdateCombobox(abilities)
    local datas = {}
    for index = 1, MAX_ABILITY_TYPE do
      local data = {
        text = locale.common.abilityNameWithId(index),
        value = index,
        enable = true
      }
      for i = 1, #abilities do
        if index == abilities[i] then
          data.enable = false
          break
        end
      end
      table.insert(datas, data)
    end
    combo:Clear()
    combo:SetVisibleItemCount(8)
    combo:AppendItems(datas, false)
    combo:Select(self.ability, false)
    self:Update()
  end
  function combo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    widget.ability = selIndex
    parent.selectedSkill = 0
    parent.skillList = {}
    parent.drawType = 0
    parent:Update()
  end
  return widget
end
local CreateSynergyBottomFrame = function(id, parent)
  local widget = CreateEmptyWindow(id, parent)
  widget:Show(true)
  local guide = W_ICON.CreateGuideIconWidget(widget)
  guide:AddAnchor("LEFT", widget, 0, 0)
  local OnEnterGuide = function(self)
    SetTooltip(GetCommonText("synergy_window_status_tooltip"), self)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local label = widget:CreateChildWidget("label", "label", 0, true)
  label:SetExtent(108, FONT_SIZE.MIDDLE)
  label:SetAutoResize(true)
  label.style:SetAlign(ALIGN_CENTER)
  label.style:SetFontSize(FONT_SIZE.MIDDLE)
  label:AddAnchor("LEFT", guide, "RIGHT", 7, 0)
  label:SetText(GetCommonText("synergy_window_status"))
  ApplyTextColor(label, FONT_COLOR.DEFAULT)
  widget.comboValue = 1
  local combo = W_CTRL.CreateComboBox("combo", widget)
  combo:AddAnchor("LEFT", label, "RIGHT", 18, 0)
  combo:SetWidth(188)
  combo:SetVisibleItemCount(8)
  function widget:Update()
    local ids, tags, enable = X2Ability:GetUnitStatusList(parent.children[1].ability, parent.children[2].ability, parent.children[3].ability)
    local datas = {}
    local first = {
      text = GetCommonText("no_choice"),
      value = ids[1],
      enable = enable[1]
    }
    table.insert(datas, first)
    for i = 2, #enable do
      local data = {
        text = tags[i],
        value = ids[i],
        enable = enable[i]
      }
      table.insert(datas, data)
    end
    combo:AppendItems(datas, false)
    combo:Select(widget.comboValue, false)
  end
  function combo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    widget.comboValue = selIndex
    parent.selectedSkill = 0
    local value = info.value
    if value > 0 then
      parent.skillList = X2Ability:GetUnitStatusSkills(value)
      parent.drawType = 3
    else
      parent.skillList = {}
      parent.drawType = 0
    end
    parent:Update()
  end
  widget:SetExtent(guide:GetWidth() + 7 + label:GetWidth() + 18 + combo:GetWidth(), 26)
  return widget
end
function CreateSynergySkillWindow(id, parent)
  if synergyWindow ~= nil then
    synergyWindow:Show(not synergyWindow:IsVisible())
    synergyWindow:Raise()
    return
  end
  local window = CreateWindow(id, parent)
  window:SetExtent(680, 396)
  window:SetTitle(GetCommonText("synergy_window_title"))
  window:RemoveAllAnchors()
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window.children = {}
  window.selectedSkill = 0
  window.skillList = {}
  window.drawType = 0
  local descText = window:CreateChildWidget("label", "descText", 0, true)
  descText:SetHeight(FONT_SIZE.LARGE)
  descText:SetAutoResize(true)
  descText.style:SetAlign(ALIGN_CENTER)
  descText.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(descText, FONT_COLOR.DEFAULT)
  descText:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  descText:SetText(GetCommonText("synergy_window_desc"))
  local iconBg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "artwork")
  iconBg:SetTextureColor("default")
  iconBg:SetExtent(638, 47)
  iconBg:AddAnchor("TOP", descText, "BOTTOM", 0, 6)
  local iconPrevText = window:CreateChildWidget("label", "iconPrevText", 0, true)
  iconPrevText:SetExtent(72, FONT_SIZE.MIDDLE)
  iconPrevText:SetAutoResize(true)
  iconPrevText.style:SetAlign(ALIGN_LEFT)
  iconPrevText.style:SetFontSize(FONT_SIZE.MIDDLE)
  iconPrevText:SetText(GetCommonText("synergy_window_icon_prev"))
  ApplyTextColor(iconPrevText, FONT_COLOR.DEFAULT)
  local iconPrevWidget = window:CreateChildWidget("emptywidget", "iconPrevWidget", 0, false)
  local iconPrev = window:CreateDrawable(TEXTURE_PATH.SKILL_SYNERGY, "mouse_blue", "artwork")
  iconPrev:AddAnchor("RIGHT", iconPrevText, "LEFT", -7, 0)
  iconPrevWidget:AddAnchor("TOPLEFT", iconPrev, 0, 0)
  iconPrevWidget:AddAnchor("BOTTOMRIGHT", iconPrev, 0, 0)
  local OnEnterIconPrev = function(self)
    SetTooltip(GetCommonText("synergy_window_icon_prev_tooltip"), self)
  end
  iconPrevWidget:SetHandler("OnEnter", OnEnterIconPrev)
  local iconNextWidget = window:CreateChildWidget("emptywidget", "iconNextWidget", 0, false)
  local iconNext = window:CreateDrawable(TEXTURE_PATH.SKILL_SYNERGY, "mouse_orange", "artwork")
  iconNext:AddAnchor("LEFT", iconPrevText, "RIGHT", 69, 0)
  iconNextWidget:AddAnchor("TOPLEFT", iconNext, 0, 0)
  iconNextWidget:AddAnchor("BOTTOMRIGHT", iconNext, 0, 0)
  local OnEnterIconNext = function(self)
    SetTooltip(GetCommonText("synergy_window_icon_next_tooltip"), self)
  end
  iconNextWidget:SetHandler("OnEnter", OnEnterIconNext)
  local iconNextText = window:CreateChildWidget("label", "iconNextText", 0, true)
  iconNextText:SetExtent(72, FONT_SIZE.MIDDLE)
  iconNextText:SetAutoResize(true)
  iconNextText.style:SetAlign(ALIGN_LEFT)
  iconNextText.style:SetFontSize(FONT_SIZE.MIDDLE)
  iconNextText:AddAnchor("LEFT", iconNext, "RIGHT", 7, 0)
  iconNextText:SetText(GetCommonText("synergy_window_icon_next"))
  ApplyTextColor(iconNextText, FONT_COLOR.DEFAULT)
  local adjust = (iconPrevText:GetWidth() - 72) / 2 - (iconNextText:GetWidth() - 72) / 2
  iconPrevText:AddAnchor("TOPRIGHT", iconBg, "TOP", -34 + adjust, 16)
  local jobName = window:CreateChildWidget("label", "jobName", 0, true)
  jobName:SetHeight(FONT_SIZE.LARGE)
  jobName:SetAutoResize(true)
  jobName.style:SetFontSize(FONT_SIZE.LARGE)
  jobName:AddAnchor("TOPLEFT", iconBg, "BOTTOMLEFT", 0, 6)
  ApplyTextColor(jobName, FONT_COLOR.TITLE)
  function window:UpdateJobName()
    local name = F_UNIT.GetCombinedAbilityName(window.children[1].ability, window.children[2].ability, window.children[3].ability)
    jobName:SetText(name)
  end
  local SUB_WINDOW_GAP = 28
  for index = 1, MAX_ABILITY_COUNT do
    local content = CreateSynergySkillList(id .. ".ability" .. index, window, index)
    local x = (content:GetWidth() + SUB_WINDOW_GAP) * (index - 1)
    content:AddAnchor("TOPLEFT", jobName, "BOTTOMLEFT", x, 5)
    content:Show(true)
    table.insert(window.children, content)
  end
  window.bottom = CreateSynergyBottomFrame(id .. ".bottom", window)
  window.bottom:AddAnchor("TOP", window.children[2], "BOTTOM", 0, 20)
  function window:Update()
    if window.drawType ~= 3 then
      window.bottom.combo:Select(1, false)
    end
    local selectedMap = {}
    for i = 1, MAX_ABILITY_TYPE do
      selectedMap[i] = 0
    end
    local abilities = {}
    for i = 1, MAX_ABILITY_COUNT do
      if window.children[i].ability ~= nil and window.children[i].ability ~= 0 then
        selectedMap[window.children[i].ability] = 1
      end
    end
    for i = 1, MAX_ABILITY_COUNT do
      if window.children[i].ability == nil or window.children[i].ability == 0 then
        for j = 1, MAX_ABILITY_TYPE do
          if selectedMap[j] == 0 then
            window.children[i].ability = j
            selectedMap[j] = 1
            break
          end
        end
      end
      abilities[i] = window.children[i].ability
    end
    for i = 1, MAX_ABILITY_COUNT do
      window.children[i]:UpdateCombobox(abilities)
    end
    self:UpdateJobName()
    self.bottom:Update()
  end
  window:Show(true)
  window:Update()
  synergyWindow = window
  local synergyWindowEvents = {
    LEFT_LOADING = function()
      if synergyWindow ~= nil then
        synergyWindow:Show(false)
      end
    end,
    ENTERED_WORLD = function()
      if synergyWindow ~= nil then
        synergyWindow:Show(false)
      end
    end,
    ENTERED_LOADING = function()
      if synergyWindow ~= nil then
        synergyWindow:Show(false)
      end
    end,
    HEIR_SKILL_UPDATE = function()
      if synergyWindow ~= nil then
        synergyWindow:Update()
      end
    end,
    UPDATE_SKILL_ACTIVE_TYPE = function()
      if synergyWindow ~= nil then
        synergyWindow:Update()
      end
    end
  }
  synergyWindow:SetHandler("OnEvent", function(this, event, ...)
    synergyWindowEvents[event](...)
  end)
  RegistUIEvent(synergyWindow, synergyWindowEvents)
end
