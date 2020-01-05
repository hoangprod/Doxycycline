local SCREEN_WIDTH = UIParent:GetScreenWidth()
local SCREEN_HEIGHT = UIParent:GetScreenHeight()
local BG_WIDTH = 1920
local BG_HEIGHT = 1200
local titleMargin, sideMargin, bottomMargin = GetWindowMargin()
local background = CreateEmptyWindow("background", "UIParent")
background:SetUILayer("hud")
background:Show(true)
background:Clickable(false)
local function ReAnchorOnScale()
  background:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  background:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
end
background:SetHandler("OnScale", ReAnchorOnScale)
ReAnchorOnScale()
local prevBtn = background:CreateChildWidget("button", "prevBtn", 0, true)
prevBtn:AddAnchor("BOTTOMLEFT", background, 40, -40)
ApplyButtonSkin(prevBtn, BUTTON_STYLE.STAGE)
prevBtn:Show(true)
local nextBtn = background:CreateChildWidget("button", "nextBtn", 0, true)
nextBtn:AddAnchor("BOTTOMRIGHT", background, -40, -40)
ApplyButtonSkin(nextBtn, BUTTON_STYLE.STAGE)
nextBtn:Show(true)
local stageTitle = background:CreateDrawable(RACE_TEXTURE, "page_title", "background")
stageTitle:AddAnchor("TOPLEFT", background, 20, 20)
local stageProgressWnd = CreateStageProgressWnd("stageProgressWnd", background)
stageProgressWnd:AddAnchor("TOPRIGHT", background, -25, 19)
local MakeParamFromUnit = function()
  local unit = X2LoginCharacter:GetCustomizingUnit()
  unit:InitCustomizerControl()
end
local MakeUnitFromParam = function()
  local unit = X2LoginCharacter:GetCustomizingUnit()
  unit:ApplyCustomizerParamToUnit()
  RefreshCustomizingContentUI()
end
local customSaveLoadWnd = CreateCustomSaveLoadWnd("customSaveLoadWnd", "UIParent")
customSaveLoadWnd:AddAnchor("RIGHT", nextBtn, "LEFT", -20, 0)
customSaveLoadWnd:Show(false)
customSaveLoadWnd:SetPreSaveFunc(MakeParamFromUnit)
customSaveLoadWnd:SetPreLoadFunc(MakeParamFromUnit)
customSaveLoadWnd:SetPostLoadFunc(MakeUnitFromParam)
local IsFrozen = function()
  return X2LoginCharacter:IsFrozen()
end
local SetFreeze = function(frozen)
  X2LoginCharacter:SetFreeze(frozen)
end
local freezewnd = CreateCustomFreezeWnd("freezewnd", background)
freezewnd:AddAnchor("TOPRIGHT", background, -(stageProgressWnd:GetWidth() + 20), 10)
freezewnd:Show(false)
freezewnd.getFunc = IsFrozen
freezewnd.setFunc = SetFreeze
local authMessage = CreateAuthMessageWindow("authMessage", background)
authMessage:AddAnchor("TOP", background, 0, 20)
local prevText = {
  GetUIText(CHARACTER_SELECT_TEXT, "cancelCreate"),
  GetCommonText("prev"),
  GetCommonText("prev")
}
local nextText = {
  GetCommonText("next"),
  GetCommonText("next"),
  GetUIText(CHARACTER_CREATE_TEXT, "toCompleteCreation")
}
if X2LoginCharacter:IsRecustomizing() then
  prevText[1] = GetCommonText("modification_cancel")
  nextText[3] = GetCommonText("modification_complete")
end
local ShowCreateConfirmPopup = function()
  ShowCreateCharacter()
  UpdateNextBtnState(true)
end
local stage
function prevBtn:OnClick()
  prevBtn:Enable(false)
  if stage == STAGE_CREATE then
    X2LoginCharacter:GotoCharacterSelect()
  elseif stage == STAGE_ABILITY then
    X2LoginCharacter:EndCharacterAbility(false)
  elseif stage == STAGE_CUSTOMIZE then
    X2LoginCharacter:EndCharacterCustomize(false)
  end
end
prevBtn:SetHandler("OnClick", prevBtn.OnClick)
function nextBtn:OnClick()
  nextBtn:Enable(false)
  if stage == STAGE_CREATE then
    X2LoginCharacter:EndCharacterCreate(true)
  elseif stage == STAGE_ABILITY then
    X2LoginCharacter:EndCharacterAbility(true)
  elseif stage == STAGE_CUSTOMIZE then
    ShowCreateConfirmPopup()
  end
end
nextBtn:SetHandler("OnClick", nextBtn.OnClick)
local function SetStage(newStage)
  if stage == newStage then
    return
  end
  stage = newStage
  if stage == STAGE_CREATE then
    prevBtn:SetText(prevText[1])
    nextBtn:SetText(nextText[1])
    ApplyButtonSkin(nextBtn, BUTTON_STYLE.STAGE)
    stageTitle:SetTexture(RACE_TEXTURE)
    stageTitle:SetTextureInfo("page_title")
    customSaveLoadWnd:Show(false)
    freezewnd:Show(false)
    stageProgressWnd:SetPage(1)
  elseif stage == STAGE_ABILITY then
    prevBtn:SetText(prevText[2])
    nextBtn:SetText(nextText[2])
    ApplyButtonSkin(nextBtn, BUTTON_STYLE.STAGE)
    stageTitle:SetTexture(ABILITY_TEXTURE)
    stageTitle:SetTextureInfo("title")
    customSaveLoadWnd:Show(false)
    freezewnd:Show(false)
    stageProgressWnd:SetPage(2)
  elseif stage == STAGE_CUSTOMIZE then
    prevBtn:SetText(prevText[3])
    nextBtn:SetText(nextText[3])
    nextBtn:SetWidth(LOGIN_STAGE_LOGEST_BUTTON_WIDTH)
    stageTitle:SetTexture(TEXTURE_PATH.CUSTOMIZING)
    stageTitle:SetTextureInfo("page_title")
    customSaveLoadWnd:Show(true)
    freezewnd:Show(true)
    stageProgressWnd:SetPage(3)
  end
end
local function UpdateCreateStageUI(newStage, show)
  prevBtn:Enable(show)
  UpdateNextBtnState(show)
  SetStage(newStage)
  if stage == STAGE_CREATE then
    UpdateCreateRaceUI(show)
  elseif stage == STAGE_ABILITY then
    UpdateCreateAbilityUI(show)
  elseif stage == STAGE_CUSTOMIZE then
    UpdateCreateCustomizingUI(show)
  end
end
local eventHandler = {
  SHOW_CHARACTER_CREATE_WINDOW = function(show)
    UpdateCreateStageUI(STAGE_CREATE, show)
  end,
  SHOW_CHARACTER_CUSTOMIZE_WINDOW = function(show)
    UpdateCreateStageUI(STAGE_CUSTOMIZE, show)
  end,
  SHOW_CHARACTER_ABILITY_WINDOW = function(show, byCutscene)
    if byCutscene then
      UpdateUIByCutScene(show)
      prevBtn:Show(show, 500)
      nextBtn:Show(show, 500)
    else
      UpdateCreateStageUI(STAGE_ABILITY, show)
    end
  end,
  CREATE_CHARACTER_FAILED = function(msg)
    local function DialogNoticeHandler(wnd)
      local data = locale.messageBox[msg]
      wnd:SetTitle(data.title)
      local strBody = data.body
      if type(data.body) == "function" then
        local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
        strBody = data.body(namePolicyInfo)
      end
      wnd:SetContent(strBody)
      function wnd:OkProc()
        if msg == "error_forbid_char_creation" then
          X2LoginCharacter:EndCharacterCreate(false)
        else
          ShowCreateCharacter()
        end
      end
    end
    X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, background:GetId())
  end,
  CHANGE_PAY_INFO = function(oldPayMethod, newPayMethod, oldPayLocation, newPayLocation)
    if not X2Player:GetFeatureSet().nexonPcRoom and oldPayLocation ~= newPayLocation and string.find(newPayLocation, "pcbang") == nil then
      local DialogHandler = function(wnd)
        wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "error_message"))
        wnd:SetContent(GetUIText(MSG_BOX_BODY_TEXT, "pcbang_advantage_off"))
      end
      X2DialogManager:RequestNoticeDialog(DialogHandler, "")
    end
  end
}
background:SetHandler("OnEvent", function(this, event, ...)
  eventHandler[event](...)
end)
background:RegisterEvent("SHOW_CHARACTER_CREATE_WINDOW")
background:RegisterEvent("SHOW_CHARACTER_CUSTOMIZE_WINDOW")
background:RegisterEvent("SHOW_CHARACTER_ABILITY_WINDOW")
background:RegisterEvent("CREATE_CHARACTER_FAILED")
background:RegisterEvent("CHANGE_PAY_INFO")
function UpdateDevWnd()
end
local function Init()
  local currentStage = X2LoginCharacter:GetCurrentStage()
  UpdateCreateStageUI(currentStage, true)
  UpdateDevWnd()
end
function UpdateNextBtnState(enable)
  if X2World:IsPreSelectCharacterPeriod() then
    if X2LoginCharacter:IsRecustomizing() then
      nextBtn:Enable(enable)
    elseif not X2World:CanPreSelectCharacter() then
      nextBtn:Enable(false)
    elseif GetRemainCreatableCharacterCount() <= 0 then
      nextBtn:Enable(false)
    else
      nextBtn:Enable(enable)
    end
  else
    nextBtn:Enable(enable)
  end
end
function AddAnchorToNextBtn(source, sAnchor, tAnchor, offsetX, offsetY)
  source:AddAnchor(sAnchor, nextBtn, tAnchor, offsetX, offsetY)
end
function AddAnchorToNextBtnBetweenPrevBtn(source, checkTarget)
  local prevBtnOffset, _ = prevBtn:GetOffset()
  prevBtnOffset = prevBtnOffset + prevBtn:GetWidth()
  local nextBtnOffset, _ = nextBtn:GetOffset()
  local offset = (prevBtnOffset + nextBtnOffset) / 2
  local calcOffset = offset + source:GetWidth()
  local checkOffset, _ = checkTarget:GetOffset()
  if calcOffset > checkOffset then
    source:AddAnchor("CENTER", prevBtn, "LEFT", offset - checkTarget:GetWidth() / 1.5, 0)
  else
    source:AddAnchor("CENTER", prevBtn, "LEFT", offset, 0)
  end
end
Init()
