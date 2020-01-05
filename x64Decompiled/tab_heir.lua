local MAX_ORIGIN_SKILL = 8
local MAX_HEIR_SKILL = 8
local selectAbility = 0
local selectOriginSkillIndex = 0
local HEIR_SKILL_START_X_POS = 81
local HEIR_SKILL_WIDTH = 70
local HEIR_SKILL_SYMBOL_WIDTH = 40
local MAX_ABILITY_COUNT = 3
local charInfoStat
local function DescAbilSet(i)
  local descAbilSet = {
    [1] = {
      text = "anti_miss",
      value = math.abs(charInfoStat.anti_miss),
      postfix = "inc"
    },
    [2] = {
      text = "incoming_damage_mul",
      value = math.abs(charInfoStat.incoming_damage_mul),
      postfix = "dec"
    },
    [3] = {
      text = "battle_resist",
      value = math.abs(charInfoStat.battle_resist),
      postfix = "inc"
    },
    [4] = {
      text = "flexibility",
      value = math.abs(charInfoStat.flexibility),
      postfix = "inc"
    }
  }
  return descAbilSet[i]
end
local SetHeirSectionHandlers = function(frame)
  local levelUpBtn = frame.levelUpBtn
  local function OnEnterlevelUpBtn()
    local s
    if X2Ability:IsMaxCharHeirLevel() == true then
      s = X2Locale:LocalizeUiText(COMMON_TEXT, "heir_max_level_tooltip")
    else
      local info = X2Ability:HeirLevelUpItemInfo()
      if info == nil then
        return
      end
      s = X2Locale:LocalizeUiText(COMMON_TEXT, "heir_level_up_tooltip", info.name, tostring(info.count))
    end
    SetTooltip(s, levelUpBtn)
  end
  levelUpBtn:SetHandler("OnEnter", OnEnterlevelUpBtn)
  local OnLeavelevelUpBtn = function()
    HideTooltip()
  end
  levelUpBtn:SetHandler("OnLeave", OnLeavelevelUpBtn)
  local heirExpBar = frame.heirExpBar
  local function OnEnterExpBar()
    local heirExpInfo = X2Player:GetHeirExpInfo()
    if heirExpInfo == nil then
      return
    end
    local percent = string.sub(heirExpInfo.percent, 1, 5)
    local str = string.format("|,%s; / |,%s; (%.2f%%)", heirExpInfo.exp, heirExpInfo.totalExp, percent)
    SetTooltip(str, heirExpBar)
  end
  heirExpBar:SetHandler("OnEnter", OnEnterExpBar)
  local OnLeave = function()
    HideTooltip()
  end
  heirExpBar:SetHandler("OnLeave", OnLeave)
  local levelUpBtn = frame.levelUpBtn
  function OnClickLevelUp(self, arg)
    if arg == "LeftButton" then
      X2Ability:AskHeirLevelUp()
    end
  end
  levelUpBtn:SetHandler("OnClick", OnClickLevelUp)
end
local function CreateHeirLevelSection(parent, wnd)
  local heirLevelFrame = wnd:CreateChildWidget("emptywidget", "heirLevelFrame", 0, true)
  heirLevelFrame:SetExtent(parent:GetWidth(), 126)
  heirLevelFrame:AddAnchor("TOP", wnd, "TOP", 0, 15)
  local levelTitle = heirLevelFrame:CreateChildWidget("label", "levelTitle", 0, true)
  levelTitle:AddAnchor("TOPLEFT", heirLevelFrame, 2, 6)
  levelTitle:SetAutoResize(true)
  levelTitle:SetHeight(FONT_SIZE.LARGE)
  levelTitle.style:SetShadow(false)
  levelTitle.style:SetAlign(ALIGN_LEFT)
  levelTitle.style:SetFontSize(FONT_SIZE.LARGE)
  levelTitle:SetText(GetCommonText("heir_level") .. ":")
  ApplyTextColor(levelTitle, F_COLOR.GetColor("middle_title"))
  local heirIcon = heirLevelFrame:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor", "background")
  heirIcon:AddAnchor("LEFT", levelTitle, "RIGHT", 3, 0)
  local levelLabel = heirLevelFrame:CreateChildWidget("label", "levelLabel", 0, true)
  levelLabel:AddAnchor("LEFT", heirIcon, "RIGHT", 2, 0)
  levelLabel:SetAutoResize(true)
  levelLabel:SetHeight(FONT_SIZE.LARGE)
  levelLabel.style:SetShadow(false)
  levelLabel.style:SetAlign(ALIGN_LEFT)
  levelLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(levelLabel, F_COLOR.GetColor("successor_deep"))
  local levelUpBtn = heirLevelFrame:CreateChildWidget("button", "levelUpBtn", 0, true)
  ApplyButtonSkin(levelUpBtn, BUTTON_CONTENTS.HEIR_LEVEL_UP)
  levelUpBtn:AddAnchor("TOPRIGHT", heirLevelFrame, -2, 3)
  local heirExpBar = W_BAR.CreateHeirExpBar(heirLevelFrame)
  heirExpBar:AddAnchor("TOPLEFT", levelTitle, "BOTTOMLEFT", -1, 6)
  heirExpBar:AddAnchor("BOTTOMRIGHT", heirLevelFrame, "TOPRIGHT", -1, 38)
  heirExpBar:SetMinMaxValues(0, 1000)
  heirLevelFrame.heirExpBar = heirExpBar
  SetHeirSectionHandlers(heirLevelFrame)
  local descBg = CreateContentBackground(heirLevelFrame, "TYPE2", "default")
  local descLabel = heirLevelFrame:CreateChildWidget("label", "descLabel", 0, true)
  descLabel:AddAnchor("CENTER", descBg, "CENTER", 0, 0)
  descLabel:SetHeight(FONT_SIZE.LARGE)
  descLabel:SetAutoResize(true)
  descLabel.style:SetAlign(ALIGN_LEFT)
  descLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(descLabel, FONT_COLOR.RED)
  heirLevelFrame.descLabel = descLabel
  local descAbilTitle = heirLevelFrame:CreateChildWidget("label", "descAbilTitle", 0, true)
  descAbilTitle:AddAnchor("TOPLEFT", heirExpBar, "BOTTOMLEFT", 1, 13)
  descAbilTitle:SetHeight(FONT_SIZE.LARGE)
  descAbilTitle:SetAutoResize(true)
  descAbilTitle.style:SetAlign(ALIGN_LEFT)
  descAbilTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(descAbilTitle, F_COLOR.GetColor("middle_title"))
  descAbilTitle:SetText(GetCommonText("char_status"))
  heirLevelFrame.descAbilTitle = descAbilTitle
  local descAbil = {}
  for i = 1, 4 do
    descAbil[i] = heirLevelFrame:CreateChildWidget("label", "descAbil" .. tostring(i), 0, true)
    descAbil[i]:AddAnchor("TOP", heirExpBar, "BOTTOM", 0, 40 + 21 * math.floor((i - 1) / 2))
    descAbil[i]:AddAnchor("LEFT", heirLevelFrame, 26 + 319 * math.fmod(i - 1, 2), 0)
    descAbil[i]:SetHeight(FONT_SIZE.MIDDLE)
    descAbil[i]:SetAutoResize(true)
    descAbil[i].style:SetAlign(ALIGN_LEFT)
    descAbil[i].style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(descAbil[i], F_COLOR.GetColor("default"))
    descAbil[i].dingbat = W_ICON.DrawDingbat(descAbil[i], -5)
  end
  heirLevelFrame.descAbil = descAbil
  function heirLevelFrame:Update()
    local heirExpInfo = X2Player:GetHeirExpInfo()
    if heirExpInfo == nil then
      UIParent:Warning(string.format("[Lua Error] can't get heir exp info.."))
      return nil
    end
    if heirExpInfo.level > 0 then
      heirExpBar:ChangeStatusBarColor({
        255,
        208,
        63
      })
    else
      heirExpBar:ChangeStatusBarDefaultColor()
    end
    local levelUpItemInfo = X2Ability:HeirLevelUpItemInfo()
    if levelUpItemInfo == nil then
      levelUpBtn:Show(false)
    else
      levelUpBtn:Show(true)
      levelUpBtn:Enable(X2Ability:NeedHeirLevelUpItem())
    end
    levelLabel:SetText(tostring(heirExpInfo.level))
    local percent = heirExpInfo.exp / heirExpInfo.totalExp * 1000
    heirExpBar:SetValue(percent)
    charInfoStat = X2Unit:UnitHeirIncreases("player")
    for i = 1, 4 do
      descAbil[i]:SetText(X2Locale:LocalizeUiText(ATTRIBUTE_VARIATION_TEXT, string.format("%s_%s", DescAbilSet(i).postfix, DescAbilSet(i).text), GetModifierCalcValue(DescAbilSet(i).text, DescAbilSet(i).value)))
    end
  end
  function heirLevelFrame:SetDesc(info)
    local str
    if info.activeType == 1 then
      str = string.format("%s", GetCommonText("not_enough_heir_level_desc"))
    elseif info.activeType == 2 then
      str = string.format("%s", GetCommonText("heir_level_desc", info.startHeirLevel))
    end
    if str ~= nil then
      ApplyTextColor(descLabel, FONT_COLOR.RED)
      descLabel:SetText(str)
      descLabel:Show(true)
      descBg:RemoveAllAnchors()
      descBg:AddAnchor("TOPLEFT", heirLevelFrame, -5, 40)
      descBg:AddAnchor("BOTTOMRIGHT", heirLevelFrame, 5, 0)
      descAbilTitle:Show(false)
      for i = 1, 4 do
        descAbil[i]:Show(false)
        descAbil[i].dingbat:Show(false)
      end
      return
    end
    descLabel:Show(false)
    descAbilTitle:Show(true)
    for i = 1, 4 do
      descAbil[i]:Show(true)
      descAbil[i].dingbat:Show(true)
    end
    descBg:RemoveAllAnchors()
    descBg:AddAnchor("TOPLEFT", descAbilTitle, "BOTTOMLEFT", -7, 0)
    descBg:AddAnchor("BOTTOMRIGHT", heirLevelFrame, 5, 0)
  end
  return heirLevelFrame
end
local selectHeirSkillSlotFunc = function(arg)
  X2HeirSkill:ResetHeirSkillForSlot(arg)
end
local SetSelectSlotHandler = function(slot)
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
  function slot:OnClick()
    slot.ClickFunc(self:GetSkillType())
  end
  slot:SetHandler("OnClick", slot.OnClick)
end
local GetColorAbility = function(defaultColor, ability)
  local info = X2Ability:IsAcitveAbilityForHeir(ability)
  if info.active then
    return defaultColor
  end
  return FONT_COLOR.GRAY
end
local function MakeCategoryInfo()
  local categoryInfo = {}
  for index = 1, COMBAT_ABILITY_MAX - 1 do
    categoryInfo[index] = {
      text = GetAbilityName(index),
      value = index,
      defaultColor = GetColorAbility(FONT_COLOR.DEFAULT, index),
      selectColor = FONT_COLOR.BLUE,
      overColor = FONT_COLOR.BLUE,
      useColor = true,
      subColor = GetColorAbility(FONT_COLOR.BLUE, index)
    }
  end
  return categoryInfo
end
local function CreateAbilityListWnd(id, parent, wnd)
  local wnd = W_CTRL.CreateScrollListBox(id, parent, wnd)
  wnd.content.itemStyle:SetFontSize(FONT_SIZE.MIDDLE)
  wnd.content:SetHeight(FONT_SIZE.MIDDLE)
  wnd.content.itemStyle:SetAlign(ALIGN_LEFT)
  wnd.content.itemStyleSub:SetFontSize(FONT_SIZE.MIDDLE)
  wnd.content:SetTreeTypeIndent(true, 10, 10)
  wnd.content:SetSubTextOffset(20, 0, false)
  wnd.scroll:Show(false)
  function wnd:SetStyle(size)
    local line = wnd.content:CreateSeparatorImageDrawable(TEXTURE_PATH.DEFAULT, "background")
    line:SetTextureInfo("line_02", "default")
    line:SetExtent(size, 3)
  end
  function wnd:SetInfo(info, categoryFunc, initialIndex)
    wnd.infos = info
    wnd.categoryFunc = categoryFunc
    wnd.content:SetItemTrees(info)
    wnd.content:InitializeSelect(initialIndex)
  end
  function wnd:OnSelChanged()
    local index = self.content:GetSelectedIndex()
    local value = self.content:GetSelectedValue()
    if wnd.categoryFunc ~= nil then
      wnd.categoryFunc(index + 1, value)
    end
  end
  local ScrollChanged = function(self, _value)
    self:OnSliderChanged(_value)
  end
  wnd.scroll.vs:SetHandler("OnSliderChanged", ScrollChanged)
  function wnd:Update(info)
    local infos = self.content:GetViewItemsInfo()
    for i = 1, #infos do
      local value = infos[i].value
      local datas = {
        indexing = infos[i].indexing,
        subtext = ""
      }
      if value ~= 0 then
        datas.defaultColor = GetColorAbility(FONT_COLOR.DEFAULT, value)
        datas.subColor = GetColorAbility(FONT_COLOR.BLUE, value)
      end
      self.content:UpdateItem(datas)
    end
  end
  return wnd
end
local SetSquareWidth = function(parent, widget, startX, startY, offset, i)
  widget[i]:AddAnchor("TOPLEFT", parent, startX, startY)
  xOffset = startX + widget[i]:GetWidth() + offset
  widget[i + 1]:AddAnchor("TOPLEFT", parent, xOffset, startY)
end
local SetSquareHeight = function(parent, widget, startX, startY, offset, i)
  widget[i]:AddAnchor("TOPLEFT", parent, startX, startY)
  yOffset = startY + widget[i]:GetWidth() + offset
  widget[i + 1]:AddAnchor("TOPLEFT", parent, startX, yOffset)
end
local CreateSkillSlotBg = function(parent, key)
  local skillSlotBg = parent:CreateDrawable(TEXTURE_PATH.HEIR_SKILL, key, "background")
  skillSlotBg:AddAnchor("CENTER", parent, 0, 0)
  function skillSlotBg:ChangeTexture(key, yOffset)
    local bgCoords = GetTextureInfo(TEXTURE_PATH.HEIR_SKILL, key).coords
    skillSlotBg:SetTextureInfo(key)
    skillSlotBg:AddAnchor("CENTER", parent, 0, yOffset)
  end
  return skillSlotBg
end
local function CreateSkillSlot(widget, id, kind, count, xOffset)
  widget.skillBtns = {}
  widget.skillBtsBg = {}
  widget.skillBtsEmpty = {}
  function widget:SetInfo(buttonFunc)
    widget.buttonFunc = buttonFunc
  end
  local yOffset = 0
  local iconSize = ICON_SIZE.DEFAULT
  if kind == ISLOT_ORIGIN_SKILL_VIEW then
    iconSize = ICON_SIZE.DEFAULT - 2
  end
  for i = 1, count do
    local button = CreateActionSlot(widget, id, kind, i, iconSize)
    button:Show(false)
    if kind == ISLOT_HEIR_SKILL_VIEW then
      widget.skillBtsBg[i] = CreateSkillSlotBg(button, "slot_properties")
      widget.skillBtsEmpty[i] = CreateSkillSlotBg(button, "over_icon_empty")
      widget.skillBtsBg[i]:Show(true)
    end
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
    function button:OnClick()
      if widget.buttonFunc == nil then
        return
      end
      widget.buttonFunc(self.slotType, self.slotIdx + widget.offset)
    end
    button:SetHandler("OnClick", button.OnClick)
    widget.skillBtns[i] = button
  end
  if kind == ISLOT_ORIGIN_SKILL_VIEW then
    for i = 1, count do
      xOffset = (i - 1) * (ICON_SIZE.LARGE - 1)
      widget.skillBtns[i]:AddAnchor("TOPLEFT", widget, xOffset, yOffset)
    end
  else
    SetSquareWidth(widget, widget.skillBtns, 85, 0, HEIR_SKILL_WIDTH, 1)
    SetSquareHeight(widget, widget.skillBtns, 290, 88, HEIR_SKILL_WIDTH - 7, 3)
    local startX = 85 + iconSize + HEIR_SKILL_WIDTH
    local startY = 81 + iconSize + HEIR_SKILL_WIDTH
    local offSet = HEIR_SKILL_WIDTH + iconSize * 2
    SetSquareWidth(widget, widget.skillBtns, startX, 282, -offSet, 5)
    SetSquareHeight(widget, widget.skillBtns, -8, startY, -offSet + 7, 7)
  end
end
local SYMBOL_KEY_STRING = {
  {
    "icon_default_fire",
    "icon_selected_fire"
  },
  {
    "icon_default_life",
    "icon_selected_life"
  },
  {
    "icon_default_earthquake",
    "icon_selected_earthquake"
  },
  {
    "icon_default_rock",
    "icon_selected_rock"
  },
  {
    "icon_default_wave",
    "icon_selected_wave"
  },
  {
    "icon_default_fog",
    "icon_selected_fog"
  },
  {
    "icon_default_gust",
    "icon_selected_gust"
  },
  {
    "icon_default_lightning",
    "icon_selected_lightning"
  }
}
local SYMBOL_SELECTED_KEY_STRING = {
  "icon_selected_fire_small",
  "icon_selected_life_small",
  "icon_selected_earthquake_small",
  "icon_selected_rock_small",
  "icon_selected_wave_small",
  "icon_selected_fog_small",
  "icon_selected_gust_small",
  "icon_selected_lightning_small"
}
local function CreateHeirSkillSymbol(parent, id, kind, maxCount)
  local widget = parent:CreateChildWidget("emptywidget", id .. ".skill_symbol_wnd", 0, true)
  widget:Show(false)
  local iconSize = 24
  widget.symbol = {}
  local bgCoords, bgExtents
  for i = 1, maxCount do
    local key = kind == ISLOT_HEIR_SKILL_VIEW and SYMBOL_KEY_STRING[i][1] or SYMBOL_SELECTED_KEY_STRING[i]
    local symbol = widget:CreateChildWidget("emptywidget", id .. ".skill_symbol", i, true)
    local bg = symbol:CreateDrawable(TEXTURE_PATH.HEIR_SKILL, key, "background")
    bg:AddAnchor("TOPLEFT", symbol, 0, 0)
    symbol.bg = bg
    symbol:SetExtent(bg:GetExtent())
    widget.symbol[i] = symbol
  end
  if kind == ISLOT_HEIR_SKILL_VIEW then
    SetSquareWidth(widget, widget.symbol, 36, 0, HEIR_SKILL_SYMBOL_WIDTH, 1)
    SetSquareHeight(widget, widget.symbol, 136, 40, HEIR_SKILL_SYMBOL_WIDTH - 8, 3)
    local startX = 36 + iconSize + HEIR_SKILL_SYMBOL_WIDTH
    local startY = 32 + iconSize + HEIR_SKILL_SYMBOL_WIDTH
    local offSet = HEIR_SKILL_SYMBOL_WIDTH + iconSize * 2
    SetSquareWidth(widget, widget.symbol, startX, 136, -offSet, 5)
    SetSquareHeight(widget, widget.symbol, 0, startY, -offSet + 8, 7)
  end
  function widget:UpdateHeirSkill(index)
    for i = 1, MAX_HEIR_SKILL do
      local bgType = 1
      local symbol = self.symbol[i]
      local info = X2HeirSkill:FindHeirSkill(selectAbility, index, i)
      if info ~= nil and info.hasHeirSkill then
        bgType = 2
      end
      local bgCoords = GetTextureInfo(TEXTURE_PATH.HEIR_SKILL, SYMBOL_KEY_STRING[i][bgType]).coords
      local bgExtents = GetTextureInfo(TEXTURE_PATH.HEIR_SKILL, SYMBOL_KEY_STRING[i][bgType]).extent
      F_TEXTURE.ApplyCoordAndAnchor(symbol.bg, bgCoords, nil, 0, 0, bgExtents)
      symbol:Show(true)
    end
  end
  return widget
end
local function CreateHeirSkillSlot(id, parent, kind, maxCount, xOffset)
  local widget = parent:CreateChildWidget("emptywidget", id .. ".skill_wnd", 0, true)
  widget:Show(false)
  if kind == ISLOT_ORIGIN_SKILL_VIEW then
    local originSkillBackground = CreateContentBackground(parent, "TYPE10", "brown_3")
    originSkillBackground:AddAnchor("TOPLEFT", parent, -8, -8)
    originSkillBackground:AddAnchor("BOTTOMRIGHT", parent, -2, 10)
  end
  CreateSkillSlot(widget, id .. ".slot", kind, maxCount, xOffset)
  local symbolWnd = CreateHeirSkillSymbol(widget, id, kind, maxCount)
  widget.kind = kind
  widget.offset = 0
  function widget:Update(index)
    if widget.kind == ISLOT_ORIGIN_SKILL_VIEW then
      widget:UpdateOrigin(index)
    else
      widget:UpdateHeir(index)
    end
  end
  function widget:UpdateOrigin(index)
    X2HeirSkill:SetOriginSkill(index)
    local count = X2HeirSkill:GetOriginSkillCount()
    symbolWnd:Show(true)
    for i = 1, maxCount do
      local button = self.skillBtns[i]
      local buttonBg = self.skillBtsBg[i]
      local buttonEmpty = self.skillBtsEmpty[i]
      button.useView = true
      button.showSavedSkills = false
      local symbol = symbolWnd.symbol[i]
      symbol:Show(false)
      if count >= i + widget.offset then
        button:EstablishSlot(ISLOT_ORIGIN_SKILL_VIEW, i + widget.offset)
        local bgType = X2HeirSkill:GetHeirSkillPos(index, i + widget.offset)
        if bgType ~= nil and bgType ~= 0 then
          local bgCoords = GetTextureInfo(TEXTURE_PATH.HEIR_SKILL, SYMBOL_SELECTED_KEY_STRING[bgType]).coords
          local bgExtents = GetTextureInfo(TEXTURE_PATH.HEIR_SKILL, SYMBOL_SELECTED_KEY_STRING[bgType]).extent
          F_TEXTURE.ApplyCoordAndAnchor(symbol.bg, bgCoords, nil, 0, 0, bgExtents)
          symbol:AddAnchor("TOPLEFT", button, "TOPLEFT", -4, -7)
          symbol:Show(true)
        end
      else
        button:ResetSlot()
      end
      button:CheckStateImage()
      button:Show(true)
      if count > widget.offset + maxCount then
        parent.originSkillRightButton:Enable(true)
      else
        parent.originSkillRightButton:Enable(false)
      end
      if widget.offset > 0 then
        parent.originSkillLeftButton:Enable(true)
      else
        parent.originSkillLeftButton:Enable(false)
      end
    end
  end
  function widget:UpdateHeir(index)
    local count = 1
    X2HeirSkill:SetHeirSkill(selectAbility, index)
    for i = 1, maxCount do
      local button = self.skillBtns[i]
      local buttonBg = self.skillBtsBg[i]
      local buttonEmpty = self.skillBtsEmpty[i]
      button.useView = true
      button.showSavedSkills = false
      local info = X2HeirSkill:FindHeirSkill(selectAbility, index, i)
      if info ~= nil and info.activeType ~= SAT_HIDE then
        button:EstablishSlot(ISLOT_HEIR_SKILL_VIEW, i)
        button:SetHighlightColor(1, 1, 1, 1)
        buttonEmpty:Show(false)
        if info.hasHeirSkill then
          buttonBg:ChangeTexture("slot_selected", -2)
        else
          buttonBg:ChangeTexture("slot_properties", 0)
        end
      else
        button:SetHighlightColor(0, 0, 0, 0)
        button:ResetSlot()
        buttonEmpty:Show(true)
        buttonBg:ChangeTexture("slot_properties", 0)
      end
      button:CheckStateImage()
      button:Show(true)
    end
  end
  return widget
end
local LINE_KEY_STRING = {
  "line_01",
  "line_01_right",
  "line_02_right",
  "line_02_right_bottom",
  "line_01_right_bottom",
  "line_01_bottom",
  "line_02_bottom",
  "line_02"
}
local function CreateHeirSkillLine(parent)
  local widget = parent:CreateChildWidget("emptywidget", "heir_skill_line_wnd", 0, true)
  widget:Show(false)
  widget.line = {}
  for i = 1, MAX_HEIR_SKILL do
    local line = widget:CreateChildWidget("emptywidget", "heir_skill_line", i, true)
    local bg = line:CreateDrawable(TEXTURE_PATH.HEIR_SKILL, LINE_KEY_STRING[i], "background")
    bg:AddAnchor("TOPLEFT", line, 0, 0)
    widget.line[i] = line
  end
  widget.line[1]:AddAnchor("TOPLEFT", widget, 120, 62)
  widget.line[2]:AddAnchor("TOPLEFT", widget, 184, 62)
  widget.line[3]:AddAnchor("TOPLEFT", widget, 196, 125)
  widget.line[4]:AddAnchor("TOPLEFT", widget, 196, 184)
  widget.line[5]:AddAnchor("TOPLEFT", widget, 184, 195)
  widget.line[6]:AddAnchor("TOPLEFT", widget, 120, 195)
  widget.line[7]:AddAnchor("TOPLEFT", widget, 59, 184)
  widget.line[8]:AddAnchor("TOPLEFT", widget, 59, 125)
  function widget:Update(index)
    for i = 1, MAX_HEIR_SKILL do
      local line = self.line[i]
      line:Show(false)
      local info = X2HeirSkill:FindHeirSkill(selectAbility, index, i)
      if info ~= nil and info.hasHeirSkill then
        line:Show(true)
      end
    end
  end
  return widget
end
local function CreateHeirSkillSection(parent, wnd)
  local heirSkillFrame = parent:CreateChildWidget("emptywidget", "heirSkillFrame", 0, true)
  heirSkillFrame:SetExtent(parent:GetWidth(), 430)
  heirSkillFrame:AddAnchor("TOPLEFT", parent.heirLevelSection, "BOTTOMLEFT", 0, 10)
  local abilityListWnd = CreateAbilityListWnd("ablityListWnd", heirSkillFrame, wnd)
  abilityListWnd:SetWidth(220)
  abilityListWnd:AddAnchor("TOPLEFT", heirSkillFrame, 0, 8)
  abilityListWnd:AddAnchor("BOTTOMLEFT", heirSkillFrame, 0, -MARGIN.WINDOW_SIDE / 2)
  abilityListWnd:SetStyle(195)
  local originSkillInfoWnd = parent:CreateChildWidget("emptywidget", "originSkillInfoWnd", 0, true)
  originSkillInfoWnd:SetExtent(404, 42)
  originSkillInfoWnd:AddAnchor("TOPLEFT", abilityListWnd, "TOPRIGHT", 22, -8)
  local originSkillRightButton = originSkillInfoWnd:CreateChildWidget("button", "originSkillRightButton", 0, true)
  ApplyButtonSkin(originSkillRightButton, BUTTON_CONTENTS.HEIR_SKILL_RIGHT)
  originSkillRightButton:AddAnchor("RIGHT", originSkillInfoWnd, -11, -(originSkillRightButton:GetHeight() / 2 + 3))
  local originSkillLeftButton = originSkillInfoWnd:CreateChildWidget("button", "originSkillLeftButton", 0, true)
  ApplyButtonSkin(originSkillLeftButton, BUTTON_CONTENTS.HEIR_SKILL_LEFT)
  originSkillLeftButton:AddAnchor("RIGHT", originSkillInfoWnd, -11, originSkillLeftButton:GetHeight() / 2 + 1)
  local originSkillSlotWnd = CreateHeirSkillSlot("origin", originSkillInfoWnd, ISLOT_ORIGIN_SKILL_VIEW, MAX_ORIGIN_SKILL, 0)
  originSkillSlotWnd:AddAnchor("TOPLEFT", originSkillInfoWnd, 0, 0)
  originSkillSlotWnd:AddAnchor("TOPRIGHT", originSkillInfoWnd, 0, 0)
  function originSkillRightButton:OnClick()
    originSkillSlotWnd.offset = originSkillSlotWnd.offset + 1
    heirSkillFrame:SkillSlotWndUpdate()
  end
  originSkillRightButton:SetHandler("OnClick", originSkillRightButton.OnClick)
  function originSkillLeftButton:OnClick(self, arg)
    originSkillSlotWnd.offset = originSkillSlotWnd.offset - 1
    if originSkillSlotWnd.offset < 0 then
      originSkillSlotWnd.offset = 0
    end
    heirSkillFrame:SkillSlotWndUpdate()
  end
  originSkillLeftButton:SetHandler("OnClick", originSkillLeftButton.OnClick)
  local skillNameLabel = parent:CreateChildWidget("label", "skillNameLabel", 0, true)
  skillNameLabel:AddAnchor("TOPLEFT", originSkillInfoWnd, "BOTTOMLEFT", 0, 13)
  skillNameLabel:SetHeight(FONT_SIZE.MIDDLE)
  skillNameLabel:SetAutoResize(true)
  skillNameLabel.style:SetAlign(ALIGN_LEFT)
  skillNameLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(skillNameLabel, FONT_COLOR.TITLE)
  local heirSkillInfoBgWnd = parent:CreateChildWidget("emptywidget", "heirSkillInfoBgWnd", 0, true)
  heirSkillInfoBgWnd:SetExtent(376, 376)
  heirSkillInfoBgWnd:AddAnchor("TOPLEFT", originSkillInfoWnd, "BOTTOMLEFT", 10, 13)
  local heirSkillInfoBg = heirSkillInfoBgWnd:CreateDrawable(TEXTURE_PATH.HEIR_SKILL, "magic_circle", "background")
  heirSkillInfoBg:AddAnchor("TOPLEFT", heirSkillInfoBgWnd, 0, 0)
  local heirSkillInfoWnd = parent:CreateChildWidget("emptywidget", "heirSkillInfoWnd", 0, true)
  heirSkillInfoWnd:SetExtent(330, 330)
  heirSkillInfoWnd:AddAnchor("TOPLEFT", heirSkillInfoBg, 23, 23)
  local heirSkillSlotWnd = CreateHeirSkillSlot("heir", heirSkillInfoWnd, ISLOT_HEIR_SKILL_VIEW, MAX_HEIR_SKILL, HEIR_SKILL_START_X_POS)
  heirSkillSlotWnd:AddAnchor("TOPLEFT", heirSkillInfoWnd, 0, 0)
  heirSkillSlotWnd:AddAnchor("TOPRIGHT", heirSkillInfoWnd, 0, 0)
  local heirSkillLine = CreateHeirSkillLine(heirSkillInfoBgWnd)
  heirSkillLine:AddAnchor("TOPLEFT", heirSkillInfoBgWnd, 0, 0)
  heirSkillLine:AddAnchor("TOPRIGHT", heirSkillInfoBgWnd, 0, 0)
  local heirSkillSymbolWnd = heirSkillInfoWnd:CreateChildWidget("emptywidget", "heirSkillSymbolWnd", 0, true)
  heirSkillSymbolWnd:SetExtent(160, 160)
  heirSkillSymbolWnd:AddAnchor("TOPLEFT", heirSkillInfoWnd, 85, 85)
  local heirSkillSymbol = CreateHeirSkillSymbol(heirSkillSymbolWnd, "heirSkill", ISLOT_HEIR_SKILL_VIEW, MAX_HEIR_SKILL)
  heirSkillSymbol:AddAnchor("TOPLEFT", heirSkillSymbolWnd, 0, 0)
  heirSkillSymbol:AddAnchor("TOPRIGHT", heirSkillSymbolWnd, 0, 0)
  local selectedHeirSkillSlot = CreateActionSlot(heirSkillInfoWnd, "selectedHeirSkillSlot", ISLOT_ORIGIN_SKILL_VIEW, 1)
  selectedHeirSkillSlot:AddAnchor("TOPLEFT", heirSkillInfoWnd, "CENTER", -21, -22)
  selectedHeirSkillSlot.useView = true
  selectedHeirSkillSlot.ClickFunc = selectHeirSkillSlotFunc
  SetSelectSlotHandler(selectedHeirSkillSlot)
  local heirSkillSlotBg = CreateSkillSlotBg(selectedHeirSkillSlot, "slot_properties")
  local heirSkillSlotEmptyBg = CreateSkillSlotBg(selectedHeirSkillSlot, "over_icon_empty")
  local resetBtn = parent:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:AddAnchor("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
  resetBtn:SetText(GetCommonText("init"))
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.DEFAULT)
  function OnClick(self, arg)
    if arg == "LeftButton" then
      X2HeirSkill:ResetHeirSkill(selectAbility, selectOriginSkillIndex)
    end
  end
  resetBtn:SetHandler("OnClick", OnClick)
  function heirSkillFrame:SkillSlotWndUpdate()
    originSkillSlotWnd:Update(selectAbility)
    originSkillSlotWnd:Show(true)
    heirSkillSlotWnd:Update(selectOriginSkillIndex)
    heirSkillSlotWnd:Show(true)
    heirSkillSymbol:UpdateHeirSkill(selectOriginSkillIndex)
    heirSkillSymbol:Show(true)
    heirSkillLine:Update(selectOriginSkillIndex)
    heirSkillLine:Show(true)
    local str = ""
    local isShow = true
    local slotInfo = X2HeirSkill:GetSelectedOriginSkillInfo(selectAbility, selectOriginSkillIndex)
    if slotInfo ~= nil then
      selectedHeirSkillSlot:EstablishSkillSlot(ISLOT_ORIGIN_SKILL_VIEW, slotInfo.skill)
      selectedHeirSkillSlot:Enable(true)
      str = string.format("%s > %s", GetAbilityName(selectAbility), slotInfo.name)
      skillNameLabel:SetText(str)
      heirSkillSlotBg:ChangeTexture("slot_yellow", 0)
      heirSkillSlotEmptyBg:Show(false)
    else
      selectedHeirSkillSlot:ResetSlot()
      selectedHeirSkillSlot:Enable(false)
      heirSkillSlotBg:ChangeTexture("slot_properties", 0)
      heirSkillSlotEmptyBg:Show(true)
      isShow = false
    end
    skillNameLabel:SetText(str)
    skillNameLabel:Show(isShow)
  end
  local function CategorySelectFunc(index, value)
    originSkillSlotWnd.offset = 0
    if selectAbility ~= index then
      selectOriginSkillIndex = 1
    end
    selectAbility = index
    heirSkillFrame:SkillSlotWndUpdate()
    local str = ""
    local info = X2Ability:IsAcitveAbilityForHeir(selectAbility)
    parent.heirLevelFrame:SetDesc(info)
    local isEnable = info.active
    local slotInfo = X2HeirSkill:GetSelectedOriginSkillInfo(selectAbility, selectOriginSkillIndex)
    if slotInfo == nil then
      isEnable = false
    end
    resetBtn:Enable(isEnable)
  end
  local categoryInfo = MakeCategoryInfo()
  abilityListWnd:SetInfo(categoryInfo, CategorySelectFunc, 0)
  local function OriginSkillSlotButtonFunc(kind, index)
    if kind == ISLOT_HEIR_SKILL_VIEW or selectOriginSkillIndex == index then
      return
    end
    local slotInfo = X2HeirSkill:GetSelectedOriginSkillInfo(selectAbility, index)
    if slotInfo == nil then
      return
    end
    selectOriginSkillIndex = index
    heirSkillFrame:SkillSlotWndUpdate()
  end
  originSkillSlotWnd:SetInfo(OriginSkillSlotButtonFunc)
  function heirSkillFrame:Update()
    abilityListWnd:Update()
    heirSkillFrame:SkillSlotWndUpdate()
  end
  return heirSkillFrame
end
function CreataeHeirWindow(id, parent, tab)
  local group = parent:CreateChildWidget("emptywidget", id, 0, true)
  group:SetExtent(parent:GetWidth(), parent:GetHeight() - 39)
  local alarm = tab:CreateDrawable(TEXTURE_PATH.SKILL, "up_alarm", "overlay")
  alarm:AddAnchor("LEFT", tab.selectedButton[SKILL_WND_TAB.HEIR.index], "LEFT", 1, -10)
  alarm:Show(X2Ability:NeedHeirLevelUpItem())
  group.heirLevelSection = CreateHeirLevelSection(parent, group)
  group.heirSkillSection = CreateHeirSkillSection(group, parent)
  main_menu_bar.heirAlarmIcon:Show(X2Ability:NeedHeirLevelUpItem())
  guideText = CreateGuidePart(group, "heir", "heir_skill_guide_tooltip")
  group.guide:RemoveAllAnchors()
  guideText:RemoveAllAnchors()
  group.guide:AddAnchor("BOTTOMLEFT", parent, 5, 0)
  guideText:AddAnchor("LEFT", group.guide, "RIGHT", 5, 0)
  local openTab = false
  function group:Update()
    group.heirLevelSection:Update()
    group.heirSkillSection:Update()
    alarm:Show(false)
    main_menu_bar.heirAlarmIcon:Show(false)
    if false == openTab then
      alarm:Show(X2Ability:NeedHeirLevelUpItem())
      main_menu_bar.heirAlarmIcon:Show(X2Ability:NeedHeirLevelUpItem())
    end
  end
  local function OnShow()
    if true == X2Ability:NeedHeirLevelUpItem() then
      openTab = true
    end
    group:Update()
  end
  parent:SetHandler("OnShow", OnShow)
  group.Event = {
    HEIR_LEVEL_UP = function()
      group:Update()
    end,
    EXP_CHANGED = function()
      if false == X2Ability:NeedHeirLevelUpItem() then
        openTab = false
      end
      group:Update()
    end,
    HEIR_SKILL_UPDATE = function()
      group:Update()
    end
  }
  group:SetHandler("OnEvent", function(this, event, ...)
    group.Event[event](...)
  end)
  RegistUIEvent(group, group.Event)
  return group
end
