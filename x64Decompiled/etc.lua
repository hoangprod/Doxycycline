function CreateTodChoiceWnd(id, parent)
  local wnd
  if parent == "UIParent" then
    wnd = CreateEmptyWindow(id, "UIParent")
  else
    wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  end
  wnd:Clickable(false)
  local label = wnd:CreateChildWidget("label", "label", 0, true)
  label:SetHeight(FONT_SIZE.LARGE)
  label:SetAutoResize(true)
  label:AddAnchor("LEFT", wnd, 10, 0)
  ApplyTextColor(label, F_COLOR.GetColor("original_light_gray", false))
  label.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  label:SetText(GetCommonText("setting_tod"))
  local btns = {}
  local morning = wnd:CreateChildWidget("button", "morning", 0, true)
  ApplyButtonSkin(morning, TOD_WND_BUTTON.MORNING)
  morning:AddAnchor("LEFT", label, "RIGHT", 15, 0)
  morning.time = {hour = 6, minute = 30}
  btns[1] = morning
  local MorningOnEnter = function(self)
    SetLoingStageTooltip(GetUIText(COMMON_TEXT, "dawn"), self)
  end
  morning:SetHandler("OnEnter", MorningOnEnter)
  local noon = wnd:CreateChildWidget("button", "noon", 0, true)
  ApplyButtonSkin(noon, TOD_WND_BUTTON.NOON)
  noon:AddAnchor("LEFT", morning, "RIGHT", 5, 0)
  noon.time = {hour = 13, minute = 30}
  btns[2] = noon
  local NoonOnEnter = function(self)
    SetLoingStageTooltip(GetUIText(COMMON_TEXT, "daytime"), self)
  end
  noon:SetHandler("OnEnter", NoonOnEnter)
  local night = wnd:CreateChildWidget("button", "night", 0, true)
  ApplyButtonSkin(night, TOD_WND_BUTTON.NIGHT)
  night:AddAnchor("LEFT", noon, "RIGHT", 5, 0)
  night.time = {hour = 0, minute = 0}
  btns[3] = night
  local NightOnEnter = function(self)
    SetLoingStageTooltip(GetUIText(COMMON_TEXT, "night"), self)
  end
  night:SetHandler("OnEnter", NightOnEnter)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.CUSTOMIZING, "tod_bg", "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local width = label:GetWidth() + morning:GetWidth() + noon:GetWidth() + night:GetWidth() + 40
  local height = night:GetHeight() + 10
  wnd:SetExtent(width, height)
  local hour, minute
  local function SetTime(self)
    hour = self.time.hour
    minute = self.time.minute
    X2LoginCharacter:SetLoginStageTOD(hour, minute)
    X2LoginCharacter:SetCustomizingLight(self == morning)
    wnd:Update()
  end
  morning:SetHandler("OnClick", SetTime)
  noon:SetHandler("OnClick", SetTime)
  night:SetHandler("OnClick", SetTime)
  function wnd:Update()
    for i = 1, #btns do
      if btns[i].time.hour == hour and btns[i].time.minute == minute then
        btns[i]:Enable(false)
      else
        btns[i]:Enable(true)
      end
    end
  end
  function wnd:OnShow()
    hour, minute = X2LoginCharacter:GetLoginStageTOD()
    wnd:Update()
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  return wnd
end
function CreateNameEditWnd(id)
  local wnd = CreateEmptyWindow(id, "UIParent")
  wnd:Clickable(false)
  local nameEdit = W_CTRL.CreateEdit("nameEdit", wnd)
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  nameEdit:SetExtent(256, FONT_SIZE.MIDDLE + 20)
  nameEdit:AddAnchor("TOPRIGHT", wnd, 0, 0)
  nameEdit:SetMaxTextLength(namePolicyInfo.max)
  nameEdit.bg:SetTexture(TEXTURE_PATH.CUSTOMIZING)
  nameEdit.bg:SetTextureInfo("input_box")
  nameEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  nameEdit:SetInset(15, 5, 10, 5)
  nameEdit:SetSounds("edit_box")
  nameEdit.style:SetColor(0, 0, 0, 0.7)
  nameEdit:CreateGuideText(GetUIText(CHARACTER_CREATE_TEXT, "makeName"), ALIGN_LEFT, {
    15,
    5,
    10,
    5
  })
  nameEdit:SetText("")
  ApplyTextColor(nameEdit, FONT_COLOR.GRAY)
  nameEdit.guideTextStyle:SetColor(FONT_COLOR.GRAY[1], FONT_COLOR.GRAY[2], FONT_COLOR.GRAY[3], FONT_COLOR.GRAY[4])
  local offsetX = 8
  local offsetY = 4
  local guide = wnd:CreateChildWidget("label", "guide", 0, true)
  guide:SetExtent(nameEdit:GetWidth(), FONT_SIZE.SMALL)
  guide:AddAnchor("TOPLEFT", nameEdit, "BOTTOMLEFT", offsetX, offsetY)
  guide:SetAutoResize(true)
  guide:SetText(F_TEXT.GetLimitInfoText(namePolicyInfo))
  guide.style:SetFontSize(FONT_SIZE.SMALL)
  guide.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(guide, FONT_COLOR.GRAY)
  local width = nameEdit:GetWidth()
  local height = nameEdit:GetHeight()
  wnd:SetExtent(width, height)
  function nameEdit:TextChangedFunc()
    if wnd:IsVisible() then
      if string.len(nameEdit:GetText()) > 0 then
        UpdateNextBtnState(true)
      else
        UpdateNextBtnState(false)
      end
    end
  end
  function wnd:GetName()
    return nameEdit:GetText()
  end
  function wnd:SetName(name)
    nameEdit:SetText(name)
  end
  function wnd:OnShow()
    nameEdit:TextChangedFunc()
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  return wnd
end
function CreateStageProgressWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local PATH = "ui/login_stage/page.dds"
  local pageBg = wnd:CreateDrawable(PATH, "page_bg", "background")
  pageBg:AddAnchor("TOPLEFT", wnd, 0, 0)
  pageBg:SetVisible(true)
  wnd:SetExtent(pageBg:GetExtent())
  local progressImg = {}
  for i = 1, 2 do
    progressImg[i] = wnd:CreateDrawable(PATH, "page_previous", "background")
    progressImg[i]:SetVisible(false)
    progressImg[i]:AddAnchor("LEFT", wnd, progressImg[i]:GetWidth() * (i - 1), 0)
  end
  local pageSelected = wnd:CreateDrawable(PATH, "page_selected", "background")
  pageSelected:SetVisible(true)
  function wnd:SetPage(index)
    for i = 1, 2 do
      progressImg[i]:Show(i < index)
    end
    if index == 1 then
      pageSelected:RemoveAllAnchors()
      pageSelected:AddAnchor("LEFT", wnd, -10, 0)
    elseif index == 2 then
      pageSelected:RemoveAllAnchors()
      pageSelected:AddAnchor("CENTER", wnd, 0, 0)
    else
      pageSelected:RemoveAllAnchors()
      pageSelected:AddAnchor("RIGHT", wnd, 10, 0)
    end
  end
  return wnd
end
function CreatePlayButtonInLoginStage(id, parent)
  local button = parent:CreateChildWidget("button", id, 0, true)
  ApplyButtonSkin(button, RACE_MOVIE_BUTTON)
  local OnClick = function()
    ADDON:ToggleContent(UIC_UI_AVI)
  end
  button:SetHandler("OnClick", OnClick)
  return button
end
function CreateLightAnimationInLoginStage(parent)
  local path = TEXTURE_PATH.LOGIN_STAGE_ANIMATION
  local lightDrawable = parent:CreateEffectDrawable(path, "background")
  F_TEXTURE.ApplyCoordAndAnchor(lightDrawable, GetTextureInfo(path, "light").coords, parent, -10, -10)
  lightDrawable:SetVisible(true)
  lightDrawable:SetEffectPriority(1, "rotate", 0.3, 0.3)
  lightDrawable:SetEffectInitialColor(1, 1, 1, 1, 0)
  lightDrawable:SetEffectFinalColor(1, 1, 1, 1, 1)
  lightDrawable:SetEffectRotate(1, 0, -180)
  lightDrawable:SetEffectPriority(2, "rotate", 0.5, 0.5)
  lightDrawable:SetEffectInitialColor(2, 1, 1, 1, 1)
  lightDrawable:SetEffectFinalColor(2, 1, 1, 1, 1)
  lightDrawable:SetEffectRotate(2, -180, -360)
  lightDrawable:SetEffectPriority(3, "rotate", 0.8, 0.8)
  lightDrawable:SetEffectInitialColor(3, 1, 1, 1, 1)
  lightDrawable:SetEffectFinalColor(3, 1, 1, 1, 0)
  lightDrawable:SetEffectRotate(3, -360, -630)
  lightDrawable:SetEffectInterval(3, 2)
  lightDrawable:SetRepeatCount(5)
  parent.lightDrawable = lightDrawable
  function parent:StartAnimation()
    lightDrawable:SetStartEffect(true)
  end
end
