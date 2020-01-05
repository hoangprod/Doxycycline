local selectRace, selectGender
local RACE_DATA = {}
local function MakeRaceData()
  RACE_DATA[RACE_NUIAN] = {
    race = RACE_NUIAN,
    enable = false,
    side_str = "left",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.NUIAN,
    btn_style_selected = SELECTED_RACE_BUTTON.NUIAN
  }
  RACE_DATA[RACE_ELF] = {
    race = RACE_ELF,
    enable = false,
    side_str = "left",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.ELF,
    btn_style_selected = SELECTED_RACE_BUTTON.ELF
  }
  RACE_DATA[RACE_FERRE] = {
    race = RACE_FERRE,
    enable = false,
    side_str = "right",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.FERRE,
    btn_style_selected = SELECTED_RACE_BUTTON.FERRE
  }
  RACE_DATA[RACE_HARIHARAN] = {
    race = RACE_HARIHARAN,
    enable = false,
    side_str = "right",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.HARIHARAN,
    btn_style_selected = SELECTED_RACE_BUTTON.HARIHARAN
  }
  RACE_DATA[RACE_DWARF] = {
    race = RACE_DWARF,
    enable = false,
    side_str = "left",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.DWARF,
    btn_style_selected = SELECTED_RACE_BUTTON.DWARF
  }
  RACE_DATA[RACE_WARBORN] = {
    race = RACE_WARBORN,
    enable = false,
    side_str = "right",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.WARBORN,
    btn_style_selected = SELECTED_RACE_BUTTON.WARBORN
  }
  RACE_DATA[RACE_FAIRY] = {
    race = RACE_FAIRY,
    enable = false,
    side_str = "left",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.FAIRY,
    btn_style_selected = SELECTED_RACE_BUTTON.FAIRY
  }
  RACE_DATA[RACE_RETURNED] = {
    race = RACE_RETURNED,
    enable = false,
    side_str = "right",
    genders = {false, false},
    btn_style_normal = RACE_BUTTON.RETURNED,
    btn_style_selected = SELECTED_RACE_BUTTON.RETURNED
  }
  local raceList = X2LoginCharacter:GetRaceList()
  for i = 1, #raceList do
    local race = raceList[i].race
    local gender = raceList[i].gender
    RACE_DATA[race].enable = true
    RACE_DATA[race].genders[gender] = true
  end
end
MakeRaceData()
local GetSortedRaces = function(sideStr)
  if sideStr == "right" then
    return {
      RACE_RETURNED,
      RACE_WARBORN,
      RACE_FERRE,
      RACE_HARIHARAN
    }
  else
    return {
      RACE_NUIAN,
      RACE_ELF,
      RACE_DWARF,
      RACE_FAIRY
    }
  end
end
local BLUE_GENDER_BUTTON_STYLE = {}
BLUE_GENDER_BUTTON_STYLE[GENDER_MALE] = GENDER_BUTTON.BLUE.MALE
BLUE_GENDER_BUTTON_STYLE[GENDER_FEMALE] = GENDER_BUTTON.BLUE.FEMALE
local BLUD_SELECTED_GENDER = {}
BLUD_SELECTED_GENDER[GENDER_MALE] = "man_blue_selected"
BLUD_SELECTED_GENDER[GENDER_FEMALE] = "woman_blue_selected"
local GREEN_GENDER_BUTTON_STYLE = {}
GREEN_GENDER_BUTTON_STYLE[GENDER_MALE] = GENDER_BUTTON.GREEN.MALE
GREEN_GENDER_BUTTON_STYLE[GENDER_FEMALE] = GENDER_BUTTON.GREEN.FEMALE
local GREEN_SELECTED_GENDER = {}
GREEN_SELECTED_GENDER[GENDER_MALE] = "man_green_selected"
GREEN_SELECTED_GENDER[GENDER_FEMALE] = "woman_green_selected"
local GetRaceBtnOffset = function(count)
  if count == 4 then
    return {
      0,
      -20,
      457
    }
  elseif count == 3 then
    return {
      0,
      20,
      457
    }
  else
    return {
      13,
      50,
      442
    }
  end
end
local CanMakeRace = function(congetion)
  if congetion == HIGH_CONGESTION or congetion == FULL_CONGESTION then
    return false
  end
  return true
end
local CanPlayRace = function(congetion)
  if congetion == MIDDLE_CONGESTION or congetion == FULL_CONGESTION then
    return false
  end
  return true
end
local CreateRaceSkillWnd = function(parent, titleStr)
  local wnd = parent:CreateChildWidget("emptywidget", "skillWnd", 0, true)
  wnd:Show(false)
  local titleLabel = wnd:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(FONT_SIZE.LARGE)
  titleLabel:SetAutoResize(true)
  titleLabel:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyTextColor(titleLabel, F_COLOR.GetColor("light_gray"))
  titleLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  titleLabel:SetText(titleStr)
  local skillBtns = {}
  function wnd:SetInfo(skillInfos)
    for i = 1, math.max(#skillBtns, #skillInfos) do
      if i > #skillInfos then
        skillBtns[i]:Show(false)
      else
        if i > #skillBtns then
          skillBtns[i] = CreateSlotShapeButton("skillBtn" .. i, wnd)
          skillBtns[i]:SetExtent(40, 40)
          skillBtns[i]:AddAnchor("BOTTOMLEFT", wnd, 45 * (i - 1), 0)
          local OnEnter = function(self)
            ShowTooltip(self.info, self)
          end
          skillBtns[i]:SetHandler("OnEnter", OnEnter)
        end
        skillBtns[i]:Show(true)
        skillBtns[i]:SetIconPath(skillInfos[i].path)
        skillBtns[i].info = skillInfos[i]
      end
    end
    wnd:SetExtent(155, titleLabel:GetHeight() + 45)
  end
  return wnd
end
local function CreateRaceSelectWnd(sideStr, titleStr)
  local wnd = CreateEmptyWindow(sideStr .. "Wnd", "UIParent")
  wnd:Clickable(false)
  local title = wnd:CreateDrawable(RACE_TEXTURE, "nuia_title", "background")
  if sideStr == "left" then
    title:AddAnchor("BOTTOMLEFT", wnd, "TOPLEFT", -27, -42)
  else
    title:SetTextureInfo("harani_title")
    title:AddAnchor("BOTTOMRIGHT", wnd, "TOPRIGHT", 27, -42)
  end
  title:SetVisible(true)
  local tooltip = CreateInfoTooltip("congestionTooltip", wnd)
  tooltip:Show(false)
  local raceBtns = {}
  local selectedBtns = {}
  local races = {}
  for _, v in ipairs(GetSortedRaces(sideStr)) do
    if RACE_DATA[v].enable then
      table.insert(races, v)
    end
  end
  local raceBtnOffset = GetRaceBtnOffset(#races)
  local offset = sideStr == "left" and raceBtnOffset[1] or -raceBtnOffset[1]
  for i = 1, #races do
    do
      local race = races[i]
      local raceStr = X2Unit:GetRaceStr(race)
      local btnAnchorSide = sideStr == "left" and "TOPLEFT" or "TOPRIGHT"
      local raceBtn = wnd:CreateChildWidget("button", raceStr .. "Btn", 0, true)
      raceBtn.style:SetAlign(ALIGN_BOTTOM)
      raceBtn:SetText(tostring(locale.raceText[race]))
      ApplyButtonSkin(raceBtn, RACE_DATA[race].btn_style_normal)
      raceBtn:AddAnchor(btnAnchorSide, wnd, offset, 0)
      raceBtn.race = race
      function raceBtn:OnClick()
        SelectRaceGender(race, selectGender)
      end
      raceBtn:SetHandler("OnClick", raceBtn.OnClick)
      function raceBtn:OnEnter()
        if raceBtn.congestion ~= nil and (not CanPlayRace(raceBtn.congestion) or not CanMakeRace(raceBtn.congestion)) then
          local tipText
          if not CanPlayRace(raceBtn.congestion) then
            tipText = locale.characterCreate.race_congestion_warning
          else
            local congestion = raceBtn.congestion + 1
            tipText = locale.loginCrowded.tip[congestion]
          end
          tooltip:ClearLines()
          tooltip:AddLine(tipText, "", 0, "left", ALIGN_LEFT, 0)
          tooltip:RemoveAllAnchors()
          if sideStr == "left" then
            tooltip:AddAnchor("BOTTOMLEFT", raceBtn, "TOP", 0, 0)
          else
            tooltip:AddAnchor("BOTTOMRIGHT", raceBtn, "TOP", 0, 0)
          end
          tooltip:Show(true)
        end
      end
      raceBtn:SetHandler("OnEnter", raceBtn.OnEnter)
      function raceBtn:OnLeave()
        tooltip:Show(false)
      end
      raceBtn:SetHandler("OnLeave", raceBtn.OnLeave)
      raceBtns[i] = raceBtn
      local selectedRaceBtn = wnd:CreateChildWidget("button", raceStr .. "SelectedBtn", 0, true)
      selectedRaceBtn.style:SetAlign(ALIGN_BOTTOM)
      selectedRaceBtn:SetText(tostring(locale.raceText[race]))
      ApplyButtonSkin(selectedRaceBtn, RACE_DATA[race].btn_style_selected)
      selectedRaceBtn:AddAnchor(btnAnchorSide, wnd, offset, -30)
      selectedRaceBtn.race = race
      selectedRaceBtn[i] = selectedRaceBtn
      selectedRaceBtn[i]:Show(true)
      SetButtonFontColor(selectedRaceBtn, BTN_FONT_WHITE_COLOR)
      selectedRaceBtn:Clickable(false)
      selectedBtns[i] = selectedRaceBtn
      if sideStr == "left" then
        offset = offset + raceBtn:GetWidth() + raceBtnOffset[2]
      else
        offset = offset - raceBtn:GetWidth() - raceBtnOffset[2]
      end
      height = raceBtn:GetHeight()
    end
  end
  wnd:SetExtent(raceBtnOffset[3], 500)
  local genderOffset = 11
  local genderWnd = wnd:CreateChildWidget("emptywidget", "genderWnd", 0, true)
  genderWnd.btns = {}
  local genders = {GENDER_MALE, GENDER_FEMALE}
  for i = 1, #genders do
    do
      local gender = genders[i]
      local genderStr = X2Unit:GetGenderStr(gender)
      local genderBtn = genderWnd:CreateChildWidget("button", genderStr .. "Btn", 0, true)
      if sideStr == "left" then
        ApplyButtonSkin(genderBtn, BLUE_GENDER_BUTTON_STYLE[gender])
      else
        ApplyButtonSkin(genderBtn, GREEN_GENDER_BUTTON_STYLE[gender])
      end
      genderBtn:AddAnchor("TOPLEFT", genderWnd, genderWnd:GetWidth(), 0)
      genderBtn.gender = gender
      function genderBtn:OnClick()
        SelectRaceGender(selectRace, gender)
      end
      genderBtn:SetHandler("OnClick", genderBtn.OnClick)
      genderWnd.btns[i] = genderBtn
      genderWnd:SetExtent(genderWnd:GetWidth() + genderBtn:GetWidth() + genderOffset, genderBtn:GetHeight())
    end
  end
  genderWnd:SetWidth(genderWnd:GetWidth() - genderOffset)
  local offY = raceBtns[1]:GetHeight() + 31 + FONT_SIZE.XXLARGE + genderWnd:GetHeight() + 46 + 5
  local raceLabel = wnd:CreateChildWidget("label", "raceLabel", 0, true)
  raceLabel:SetHeight(FONT_SIZE.XXLARGE)
  raceLabel:SetAutoResize(true)
  raceLabel:AddAnchor("TOPLEFT", wnd, 0, offY)
  ApplyTextColor(raceLabel, F_COLOR.GetColor("white"))
  raceLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  local raceCinemaBtn = CreatePlayButtonInLoginStage("raceCinemaBtn", wnd)
  ApplyButtonSkin(raceCinemaBtn, RACE_MOVIE_BUTTON)
  raceCinemaBtn:AddAnchor("LEFT", raceLabel, "RIGHT", 13, 0)
  raceCinemaBtn:Show(false)
  local RaceCinemaBtnOnEnter = function(self)
    SetLoingStageTooltip(GetUIText(COMMON_TEXT, "race_cinema_btn_tooltip"), self)
  end
  raceCinemaBtn:SetHandler("OnEnter", RaceCinemaBtnOnEnter)
  local modelChangeBtn = wnd:CreateChildWidget("button", "modelChangeBtn", 0, true)
  ApplyButtonSkin(modelChangeBtn, MODEL_CHANGE_BUTTON)
  modelChangeBtn:AddAnchor("LEFT", raceLabel, "RIGHT", 13, 0)
  modelChangeBtn:Show(false)
  CreateLightAnimationInLoginStage(modelChangeBtn)
  local ModelChangeBtnOnEnter = function(self)
    SetLoingStageTooltip(GetUIText(COMMON_TEXT, "model_change_btn_tooltip"), self)
  end
  modelChangeBtn:SetHandler("OnEnter", ModelChangeBtnOnEnter)
  local function OnShow()
    modelChangeBtn:StartAnimation()
  end
  modelChangeBtn:SetHandler("OnShow", OnShow)
  local raceDesc = wnd:CreateChildWidget("textbox", "raceDesc", 0, true)
  raceDesc:SetWidth(395)
  raceDesc:SetAutoResize(true)
  raceDesc:SetAutoWordwrap(true)
  raceDesc:Clickable(false)
  raceDesc:AddAnchor("TOPLEFT", raceLabel, "BOTTOMLEFT", 0, 17)
  raceDesc.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(raceDesc, F_COLOR.GetColor("light_gray"))
  raceDesc.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  local skillWnd = CreateRaceSkillWnd(wnd, GetUIText(SKILL_TEXT, "category_job_race"))
  skillWnd:AddAnchor("TOPLEFT", raceDesc, "BOTTOMLEFT", 0, 16)
  function raceCinemaBtn:OnClick()
    X2LoginCharacter:StartRaceIntroMovie()
  end
  raceCinemaBtn:SetHandler("OnClick", raceCinemaBtn.OnClick)
  function modelChangeBtn:OnClick()
    X2LoginCharacter:DoTransform()
  end
  modelChangeBtn:SetHandler("OnClick", modelChangeBtn.OnClick)
  local genderSelected = wnd:CreateDrawable(RACE_TEXTURE, "man_blue_selected", "overlay")
  genderSelected:SetVisible(false)
  function wnd:UpdateRaceBtn()
    if X2LoginCharacter:IsRecustomizing() then
      local race = X2LoginCharacter:GetEditUnitRace()
      for i = 1, #raceBtns do
        raceBtns[i]:Enable(raceBtns[i].race == race)
      end
      return
    end
    local congestions = X2:GetRaceCongestions()
    local _, race, _ = X2LoginCharacter:GetCustomizingUnit()
    for i = 1, #raceBtns do
      raceBtns[i].congestion = congestions[raceBtns[i].race]
      if raceBtns[i].race == race then
        raceBtns[i]:Enable(true)
      elseif not CanMakeRace(congestions[raceBtns[i].race]) then
        raceBtns[i]:Enable(false)
      else
        raceBtns[i]:Enable(true)
      end
    end
  end
  function wnd:Update(race, gender)
    wnd:UpdateRaceBtn()
    for j = 1, #genderWnd.btns do
      local isSelectedGender = genderWnd.btns[j].gender == gender
      local genderExist = RACE_DATA[race].genders[genderWnd.btns[j].gender]
      if isSelectedGender and genderExist then
        genderWnd.btns[j]:SetButtonState("PUSHED")
        genderWnd.btns[j]:Clickable(false)
        genderSelected:AddAnchor("CENTER", genderWnd.btns[j], 0, 0)
        if sideStr == "left" then
          genderSelected:SetTextureInfo(BLUD_SELECTED_GENDER[gender])
        else
          genderSelected:SetTextureInfo(GREEN_SELECTED_GENDER[gender])
        end
      else
        genderWnd.btns[j]:SetButtonState("NORMAL")
        genderWnd.btns[j]:Clickable(genderExist)
        genderWnd.btns[j]:Enable(genderExist)
        genderWnd.btns[j]:Show(genderExist)
      end
    end
    if race ~= selectRace then
      genderWnd:Show(false)
      genderSelected:SetVisible(false)
      raceLabel:Show(false)
      raceDesc:Show(false)
      raceCinemaBtn:Show(false)
      modelChangeBtn:Show(false)
      skillWnd:Show(false)
      for i = 1, #raceBtns do
        if raceBtns[i].race == race then
          local raceStr = X2Unit:GetRaceStr(race)
          local genderStr = X2Unit:GetGenderStr(gender)
          local genderExist = RACE_DATA[race].genders[gender]
          raceBtns[i]:Show(false)
          raceBtns[i]:Clickable(false)
          selectedBtns[i]:Show(true)
          genderWnd:AddAnchor("TOP", selectedBtns[i], "BOTTOM", 0, 5 + characterCreateLocale.raceBtnFontSizeLocale)
          genderWnd:Show(true)
          genderSelected:SetVisible(genderExist)
          raceLabel:SetText(tostring(locale.raceText[race]))
          raceLabel:Show(true)
          local descStr = GetUIText(RACE_DETAIL_DESCRIPTION_TEXT, raceStr)
          raceDesc:SetText(descStr)
          raceDesc:Show(true)
          if race == RACE_WARBORN or race == RACE_DWARF then
            raceCinemaBtn:Show(false)
            modelChangeBtn:Show(true)
          else
            raceCinemaBtn:Show(true)
          end
          local skillInfo = {}
          local skillCount = X2Ability:GetRaceSkillCount(raceStr, genderStr)
          if skillCount ~= nil then
            for j = 1, skillCount do
              local skillType = X2Ability:GetRaceSkillType(raceStr, genderStr, j)
              skillInfo[j] = X2LoginCharacter:GetSkillTooltip(skillType, 0)
            end
            skillWnd:SetInfo(skillInfo)
            skillWnd:Show(skillCount > 0)
          end
        else
          raceBtns[i]:Show(true)
          selectedBtns[i]:Show(false)
          raceBtns[i]:Clickable(true)
          raceBtns[i]:SetButtonState("NORMAL")
          SetButtonFontColorByKey(raceBtns[i], "tribe_btn")
        end
      end
    end
    local _, startOffsetY = raceBtns[1]:GetOffset()
    local _, endOffsetY = skillWnd:GetOffset()
    local endExtentY = skillWnd:GetHeight()
    wnd:SetHeight(endOffsetY + endExtentY - startOffsetY)
  end
  return wnd
end
local SCREEN_HEIGHT = UIParent:GetScreenHeight()
local leftMenu = CreateRaceSelectWnd("left", GetUIText(COMMUNITY_TEXT, "west"))
leftMenu:AddAnchor("TOPLEFT", "UIParent", 101, (SCREEN_HEIGHT - 430) / 2)
leftMenu:Show(false)
local rightMenu = CreateRaceSelectWnd("right", GetUIText(COMMUNITY_TEXT, "east"))
rightMenu:AddAnchor("TOPRIGHT", "UIParent", -101, (SCREEN_HEIGHT - 430) / 2)
rightMenu:Show(false)
local desc = leftMenu:CreateChildWidget("textbox", "desc", 0, true)
desc:SetWidth(580)
desc:SetAutoResize(true)
desc:SetAutoWordwrap(true)
desc:SetText(GetCommonText("RACE_CONTINENT_DESC"))
desc:AddAnchor("BOTTOM", "UIParent", 0, -45)
desc.style:SetAlign(ALIGN_CENTER)
ApplyTextColor(desc, F_COLOR.GetColor("original_light_gray", false))
local function UpdateRaceButtons(race, gender)
  leftMenu:Update(race, gender)
  rightMenu:Update(race, gender)
end
function UpdateCreateRaceUI(show)
  leftMenu:Show(show, 500)
  rightMenu:Show(show, 500)
  if show then
    local customizingUnit, _, _ = X2LoginCharacter:GetCustomizingUnit()
    if customizingUnit ~= nil then
      InitializeCreateRace()
    else
      leftMenu:SetHandler("OnEndFadeIn", InitializeCreateRace)
    end
  else
    leftMenu:ReleaseHandler("OnEndFadeIn")
  end
end
function SelectRaceGender(race, gender)
  if RACE_DATA[race].genders[gender] == false then
    gender = gender == GENDER_MALE and GENDER_FEMALE or GENDER_MALE
  end
  local raceStr = X2Unit:GetRaceStr(race)
  local genderStr = X2Unit:GetGenderStr(gender)
  X2LoginCharacter:ShowPreviewRaceGender(raceStr, genderStr)
  UpdateRaceButtons(race, gender)
  selectRace = race
  selectGender = gender
  UpdateDevWnd()
end
function InitializeCreateRace()
  local customizingUnit, race, gender = X2LoginCharacter:GetCustomizingUnit()
  if customizingUnit ~= nil then
    SelectRaceGender(race, gender)
    return
  end
  if X2LoginCharacter:IsRecustomizing() then
    race = X2LoginCharacter:GetEditUnitRace()
    gender = X2LoginCharacter:GetEditUnitGender()
    SelectRaceGender(race, gender)
    return
  end
  local raceList = {}
  local congestion = X2:GetRaceCongestions()
  for i = 1, #RACE_DATA do
    if RACE_DATA[i].enable then
      local race = RACE_DATA[i].race
      if CanMakeRace(congestion[race]) then
        raceList[#raceList + 1] = race
      end
    end
  end
  race = raceList[math.random(#raceList)]
  local genderList = {GENDER_MALE, GENDER_FEMALE}
  gender = genderList[math.random(#genderList)]
  SelectRaceGender(race, gender)
end
