local FADE_DELAY = 500
local ABILITIES = X2LoginCharacter:GetAbilityList()
if ABILITIES == nil or #ABILITIES == 0 then
  UiParent:LogAlways("[UI Error][Call by lua] no login stage abilities")
  return
end
local function GetAbilityInfo(abil_id)
  for i = 1, #ABILITIES do
    local abil = ABILITIES[i]
    if abil.id == abil_id then
      return abil
    end
  end
  return nil
end
local TENDENCY_TITLE = {
  "physical_name",
  "magical_name",
  "protect_name",
  "debuff_name",
  "enchant_name"
}
local TENDENCY_DESC = {
  "physicalAttack",
  "magicalAttack",
  "protect",
  "debuff",
  "enchant"
}
local function CreateSampleSkillWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", "SampleSkill", 0, true)
  wnd:SetHeight(40)
  wnd.skillBtns = {}
  function wnd:SetAbility(abil_id)
    local abil = GetAbilityInfo(abil_id)
    if abil == nil then
      return
    end
    local skillInfos = {
      abil.preview_skill_01,
      abil.preview_skill_02,
      abil.preview_skill_03
    }
    for i = 1, math.max(#wnd.skillBtns, #skillInfos) do
      if i > #skillInfos then
        wnd.skillBtns[i]:Show(false)
      else
        local tooltipInfo = X2LoginCharacter:GetSkillTooltip(skillInfos[i], 0)
        if i > #wnd.skillBtns then
          wnd.skillBtns[i] = CreateSlotShapeButton("skillBtn" .. i, wnd)
          wnd.skillBtns[i]:SetExtent(40, 40)
          wnd.skillBtns[i]:AddAnchor("TOPLEFT", wnd, 45 * (i - 1), 0)
          local OnEnter = function(self)
            ShowTooltip(self.tooltipInfo, self)
          end
          wnd.skillBtns[i]:SetHandler("OnEnter", OnEnter)
        end
        wnd.skillBtns[i]:Show(true)
        wnd.skillBtns[i]:SetIconPath(tooltipInfo.path)
        wnd.skillBtns[i].tooltipInfo = tooltipInfo
      end
    end
    wnd:SetWidth(#skillInfos * 45 - 5)
  end
  return wnd
end
local function CreateAbilitySelectWnd(id)
  local wnd = UIParent:CreateWidget("emptywidget", id, "UIParent")
  wnd:SetExtent(458, 318)
  wnd:Clickable(false)
  abilityBtns = {}
  local x = 0
  local y = 0
  for i = 1, #ABILITIES do
    do
      local abil = ABILITIES[i]
      local ABILITY_BUTTON_STYLE = ABILITY_BUTTON
      ABILITY_BUTTON_STYLE.coordsKey = abil.name
      local abilStr = locale.common.abilityNameWithStr(abil.name)
      local abilityBtn = characterCreateLocale:CreateAbilityButton("abilityBtn", wnd, i, abilStr, ABILITY_BUTTON_STYLE)
      abilityBtn:AddAnchor("TOPLEFT", wnd, x, y)
      abilityBtn.abil = abil
      abilityBtn.bgs[4]:SetColor(1, 1, 1, 0)
      function abilityBtn:OnClick()
        local lastAbilityId = X2LoginCharacter:GetLastAbility()
        if lastAbilityId ~= abil.id then
          SelectAbility(abil.id, true)
        end
      end
      abilityBtn:SetHandler("OnClick", abilityBtn.OnClick)
      abilityBtns[i] = abilityBtn
      local w, h = abilityBtn:GetExtent()
      x = x + w + 40
      if i % 3 == 0 then
        x = 0
        y = h + 111
      end
    end
  end
  local abilitySelected = wnd:CreateDrawable(ABILITY_TEXTURE, "fight_dis", "artwork")
  abilitySelected:Show(false)
  function wnd:Update(abil_id)
    abilitySelected:Show(false)
    for i = 1, #abilityBtns do
      local abil = abilityBtns[i].abil
      if abil.id == abil_id then
        abilityBtns[i]:Enable(false)
        SetButtonFontColor(abilityBtns[i], BTN_FONT_WHITE_COLOR)
        local textKey = string.format("%s_dis", abil.name)
        abilitySelected:SetTextureInfo(textKey)
        abilitySelected:Show(true)
        abilitySelected:AddAnchor("CENTER", abilityBtns[i], 0, 0)
      else
        abilityBtns[i]:Enable(true)
        SetButtonFontColorByKey(abilityBtns[i], "tribe_btn")
      end
    end
  end
  return wnd
end
local function CreateTendencyLabel(id, parent, index)
  local label = parent:CreateChildWidget("label", id, index, true)
  label:SetExtent(10, FONT_SIZE.XLARGE + 10)
  label.style:SetFontSize(FONT_SIZE.XLARGE)
  label:SetInset(10, 5, 10, 15)
  label:SetAutoResize(true)
  label:SetText(GetUIText(CHARACTER_CREATE_TEXT, TENDENCY_TITLE[index]))
  local alphaColor = {
    1,
    1,
    1,
    1
  }
  ApplyTextColor(label, alphaColor)
  function label:OnEnter()
    SetLoingStageTargetAnchorTooltip(locale.characterCreate.getTendencyInfo(TENDENCY_DESC[index]), "BOTTOMRIGHT", self, "TOPRIGHT", 0, 0)
  end
  label:SetHandler("OnEnter", label.OnEnter)
  return label
end
local function CreateAbilityDescWnd(id)
  local wnd = UIParent:CreateWidget("emptywidget", id, "UIParent")
  wnd:SetExtent(445, 202)
  wnd:Clickable(false)
  local abilityLabel = wnd:CreateChildWidget("label", "abilityLabel", 0, true)
  abilityLabel:SetHeight(FONT_SIZE.XXLARGE)
  abilityLabel:SetAutoResize(true)
  abilityLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(abilityLabel, F_COLOR.GetColor("white"))
  abilityLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  local abilityDesc = wnd:CreateChildWidget("textbox", "abilityDesc", 0, true)
  abilityDesc:SetWidth(450)
  abilityDesc:SetAutoResize(true)
  abilityDesc:SetAutoWordwrap(true)
  abilityDesc:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  abilityDesc:Clickable(false)
  abilityDesc:AddAnchor("TOPLEFT", abilityLabel, "BOTTOMLEFT", 0, 16)
  abilityDesc.style:SetAlign(ALIGN_LEFT)
  abilityDesc.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(abilityDesc, F_COLOR.GetColor("light_gray"))
  local sampleSkillWnd = CreateSampleSkillWnd("sampleSkillWnd", wnd)
  sampleSkillWnd:AddAnchor("TOPLEFT", abilityDesc, "BOTTOMLEFT", 0, 16)
  sampleSkillWnd:Show(false)
  function wnd:Update(abil_id)
    local abilityStr = locale.common.abilityNameWithId(abil_id)
    local desc = locale.characterCreate.abilityDescWithId(abil_id)
    abilityLabel:SetText(abilityStr)
    abilityLabel:Show(true)
    abilityDesc:SetText(desc)
    abilityDesc:Show(true)
    sampleSkillWnd:SetAbility(abil_id)
    sampleSkillWnd:Show(true)
    wnd:Show(true)
  end
  return wnd
end
local function CreateAbilityDifficultWnd(id)
  local wnd = UIParent:CreateWidget("emptywidget", id, "UIParent")
  wnd:SetExtent(420, 381)
  wnd:Clickable(false)
  local size = 75
  local gapSize = 1.04
  local rad21 = math.rad(21)
  local rad36 = math.rad(36)
  local rad54 = math.rad(54)
  local pos = {
    {x = size, y = 0},
    {
      x = size + math.cos(rad21) * size * gapSize,
      y = size - math.sin(rad21) * size * gapSize
    },
    {
      x = size + math.cos(rad54) * size,
      y = size + math.cos(rad36) * size
    },
    {
      x = size - math.cos(rad54) * size,
      y = size + math.cos(rad36) * size
    },
    {
      x = size - math.cos(rad21) * size * gapSize,
      y = size - math.sin(rad21) * size * gapSize
    }
  }
  local diagram = wnd:CreateChildWidget("circlediagram", "diagram", 0, true)
  diagram:Show(true)
  diagram:AddAnchor("TOP", wnd, 0, 25)
  diagram:SetExtent(size * 2, size * 2)
  diagram:SetDiagramColor(0.33, 0.62, 0.69, 0.7)
  diagram:SetMaxValue(15)
  for i = 1, 5 do
    diagram:AddPoint(pos[i].x, pos[i].y)
  end
  local diagramBg = diagram:CreateDrawable(ABILITY_TEXTURE, "diagram", "background")
  diagramBg:AddAnchor("CENTER", diagram, -1, -1)
  local diagramLabelAnchor = {
    "BOTTOM",
    "LEFT",
    "TOPLEFT",
    "TOPRIGHT",
    "RIGHT"
  }
  for i = 1, 5 do
    local diagramLabel = CreateTendencyLabel("physicalLabel", diagram, i)
    diagramLabel:AddAnchor(diagramLabelAnchor[i], diagram, "TOPLEFT", pos[i].x, pos[i].y)
  end
  local difficultLabel = wnd:CreateChildWidget("label", "difficultLabel", 0, true)
  difficultLabel:SetHeight(FONT_SIZE.XLARGE)
  difficultLabel:SetAutoResize(true)
  difficultLabel:AddAnchor("TOPLEFT", wnd, 0, diagramBg:GetHeight() + 66)
  ApplyTextColor(difficultLabel, F_COLOR.GetColor("white"))
  difficultLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  difficultLabel:SetText(GetCommonText("ability_difficulty_level"))
  local difficultDesc = wnd:CreateChildWidget("textbox", "difficultDesc", 0, true)
  difficultDesc:SetWidth(420)
  difficultDesc:SetAutoResize(true)
  difficultDesc:SetAutoWordwrap(true)
  difficultDesc:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  difficultDesc:Clickable(false)
  difficultDesc:AddAnchor("TOPLEFT", difficultLabel, "BOTTOMLEFT", 0, 20)
  difficultDesc.style:SetAlign(ALIGN_LEFT)
  difficultDesc.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(difficultDesc, F_COLOR.GetColor("light_gray"))
  local difficultImgs = {}
  for i = 1, 5 do
    difficultImgs[i] = wnd:CreateDrawable(ABILITY_TEXTURE, "star_empty", "artwork")
    if i == 1 then
      difficultImgs[i]:AddAnchor("LEFT", difficultLabel, "RIGHT", 13, -2)
    else
      difficultImgs[i]:AddAnchor("LEFT", difficultImgs[i - 1], "RIGHT", 0, 0)
    end
  end
  function wnd:Update(abil_id)
    local abil = GetAbilityInfo(abil_id)
    if abil == nil then
      return
    end
    local desc = string.format("ability_%s_difficulty_level", abil.name)
    difficultDesc:SetText(GetCommonText(desc))
    local score = abil.score * 2
    for i = 1, 5 do
      if score == 0 then
        difficultImgs[i]:SetTextureInfo("star_empty")
      elseif score == 1 then
        score = 0
        difficultImgs[i]:SetTextureInfo("star_half")
      else
        score = score - 2
        difficultImgs[i]:SetTextureInfo("star_full")
      end
    end
    local tendencies = {
      abil.tendency_physical,
      abil.tendency_magical,
      abil.tendency_protect,
      abil.tendency_debuff,
      abil.tendency_enchant
    }
    for i = 1, 5 do
      local point = tendencies[i]
      point = point + 5
      diagram:SetPointValue(i, point)
    end
    wnd:Show(true)
  end
  return wnd
end
local CreateSkipSkillActionWnd = function(id)
  local wnd = UIParent:CreateWidget("emptywidget", id, "UIParent")
  wnd:SetHeight(30)
  local chk = CreateCheckButton("chk", wnd, GetCommonText("skip_skill_action"))
  chk:AddAnchor("LEFT", wnd, 0, 0)
  chk.textButton.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  chk.textButton:SetAutoResize(true)
  SetButtonFontColor(chk.textButton, DEFAULT_BTN_FONT_COLOR)
  wnd.chk = chk
  function chk:CheckBtnCheckChagnedProc(checked)
    X2LoginCharacter:SkipSkillAction(checked)
  end
  wnd:SetWidth(chk:GetWidth() + chk.textButton:GetWidth())
  return wnd
end
local CreateUiAviWindow = function(id)
  if not X2Player:GetFeatureSet().uiAvi then
    return
  end
  if not characterCreateLocale.showUiAviBtn then
    return
  end
  local wnd = UIParent:CreateWidget("emptywidget", id, "UIParent")
  wnd:Show(false)
  wnd:SetExtent(100, 30)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.DEFAULT_NEW, "bg", "background")
  bg:SetTextureColor("black")
  bg:AddAnchor("TOPLEFT", wnd, -40, -15)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 40, 15)
  local rightLabel = wnd:CreateChildWidget("label", "rightLabel", 0, true)
  rightLabel:SetExtent(30, FONT_SIZE.LARGE)
  rightLabel:SetAutoResize(true)
  rightLabel:SetText(GetUIText(TUTORIAL_TEXT, "ui_avi"))
  rightLabel.style:SetFontSize(FONT_SIZE.LARGE)
  rightLabel:AddAnchor("RIGHT", wnd, 0, 0)
  ApplyTextColor(rightLabel, F_COLOR.GetColor("text_btn_df"))
  local uiAviBtn = CreatePlayButtonInLoginStage("raceCinemaBtn", wnd)
  uiAviBtn:AddAnchor("RIGHT", rightLabel, "LEFT", -10, 2)
  CreateLightAnimationInLoginStage(uiAviBtn)
  local function StartAnim(show, byCutscene)
    if not show then
      return
    end
    if byCutscene then
      return
    end
    uiAviBtn:StartAnimation()
  end
  UIParent:SetEventHandler("SHOW_CHARACTER_ABILITY_WINDOW", StartAnim)
  local leftDesc = wnd:CreateChildWidget("textbox", "leftDesc", 0, true)
  leftDesc:SetExtent(500, 50)
  leftDesc:SetText(GetUIText(COMMON_TEXT, "loginstage_abil_desc"))
  leftDesc:SetAutoResize(true)
  leftDesc:SetWidth(leftDesc:GetLongestLineWidth() + 10)
  leftDesc:AddAnchor("LEFT", wnd, 0, 0)
  ApplyTextColor(leftDesc, F_COLOR.GetColor("light_gray"))
  wnd:SetWidth(rightLabel:GetWidth() + leftDesc:GetWidth() + uiAviBtn:GetWidth() + MARGIN.WINDOW_SIDE * 1.5)
  wnd:SetHeight(math.max(uiAviBtn:GetHeight(), leftDesc:GetHeight()))
  return wnd
end
local abilitySelectWnd = CreateAbilitySelectWnd("abilitySelectWnd")
abilitySelectWnd:AddAnchor("TOPLEFT", "UIParent", "TOPLEFT", 81, 275)
abilitySelectWnd:Show(false)
local abilityDescWnd = CreateAbilityDescWnd("abilityDescWnd")
abilityDescWnd:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", -77, 236)
abilityDescWnd:Show(true)
local abilityDifficultWnd = CreateAbilityDifficultWnd("abilityDifficultWnd")
abilityDifficultWnd:AddAnchor("TOP", abilityDescWnd, "BOTTOM", 0, 24)
abilityDifficultWnd:Show(false)
local uiAviWnd = CreateUiAviWindow("uiAviWnd")
local checkSkipWnd = CreateSkipSkillActionWnd("checkSkipWnd")
local skipLabel = W_CTRL.CreateLabel("skipLabel", "UIParent")
skipLabel:SetHeight(FONT_SIZE.XXLARGE)
skipLabel:SetAutoResize(true)
skipLabel:AddAnchor("BOTTOM", "UIParent", 0, -40)
ApplyTextColor(skipLabel, GRAY_FONT_COLOR)
skipLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XXLARGE)
skipLabel:SetText(GetCommonText("tip_to_skip_skill_action"))
skipLabel:Show(false)
function SelectAbility(abil_id, action)
  abilitySelectWnd:Update(abil_id)
  abilityDescWnd:Update(abil_id)
  abilityDifficultWnd:Update(abil_id)
  UpdateNextBtnState(not action or X2LoginCharacter:IsSkipSkillAction())
  if action then
    X2LoginCharacter:ShowSkillAction(abil_id)
  end
end
function UpdateCreateAbilityUI(show)
  abilitySelectWnd:Show(show, FADE_DELAY)
  checkSkipWnd:Show(show, FADE_DELAY)
  if uiAviWnd ~= nil then
    uiAviWnd:Show(show, FADE_DELAY)
  end
  if show then
    UpdateNextBtnState(false)
    local abil_id = X2LoginCharacter:GetLastAbility()
    if abil_id ~= 0 then
      SelectAbility(abil_id, false)
    elseif X2LoginCharacter:IsRecustomizing() then
      local abil_id = X2LoginCharacter:GetEditUnitAbility()
      SelectAbility(abil_id, true)
    else
      local rand = math.random(1, #ABILITIES)
      local randAbilityId = ABILITIES[rand].id
      SelectAbility(randAbilityId, true)
    end
    checkSkipWnd.chk:SetChecked(X2LoginCharacter:IsSkipSkillAction())
    AddAnchorToNextBtn(checkSkipWnd, "RIGHT", "LEFT", -25, 0)
    if uiAviWnd ~= nil then
      AddAnchorToNextBtnBetweenPrevBtn(uiAviWnd, checkSkipWnd)
    end
  else
    abilityDifficultWnd:Show(false, FADE_DELAY)
    abilityDescWnd:Show(false, FADE_DELAY)
  end
end
function UpdateUIByCutScene(show)
  abilitySelectWnd:Show(show, FADE_DELAY)
  abilityDescWnd:Show(show, FADE_DELAY)
  abilityDifficultWnd:Show(show, FADE_DELAY)
  if uiAviWnd ~= nil then
    uiAviWnd:Show(show, FADE_DELAY)
  end
  skipLabel:Show(not show, FADE_DELAY)
  checkSkipWnd:Show(show, FADE_DELAY)
  UpdateNextBtnState(show)
end
