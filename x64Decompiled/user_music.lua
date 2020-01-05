composition = {}
composition.score = nil
composition.methodWnd = nil
local width = 390
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function CreateScoreWindow(id, parent, itemLimit)
  local frame = CreateWindow(id, parent)
  frame:Show(false)
  frame:SetExtent(510, 705)
  frame:AddAnchor("CENTER", parent, 0, 0)
  frame:SetTitle(locale.composition.score)
  frame:SetSounds("composition_score")
  local guide = W_ICON.CreateGuideIconWidget(frame)
  guide:AddAnchor("TOPRIGHT", frame, -sideMargin, titleMargin + -5)
  frame.guide = guide
  local actabilityLabel = frame:CreateChildWidget("label", "actabilityLabel", 0, true)
  actabilityLabel:SetAutoResize(true)
  actabilityLabel:SetHeight(FONT_SIZE.SMALL)
  actabilityLabel:AddAnchor("RIGHT", frame.guide, "LEFT", -3, -1)
  ApplyTextColor(actabilityLabel, FONT_COLOR.DEFAULT)
  frame.limit = 0
  frame.gradeName = ""
  local infos = X2UserMusic:GetCompositionLimitInfos()
  local function SetGuideTooltip()
    local str = locale.composition.actability_tip
    local myInfo = X2Ability:GetMyActabilityInfo(33)
    for k = 1, #infos do
      local info = infos[k]
      local gradeInfo = X2Ability:GetGradeInfo(info.grade)
      str = string.format([[
%s
%s%s : %s|r]], str, string.format("|c%s", gradeInfo.colorString), info.name, info.compositionLimit)
      if myInfo.grade == info.grade then
        frame.limit = info.compositionLimit
        frame.gradeName = info.name
        if frame.limit > itemLimit then
          frame.limit = itemLimit
        end
      end
    end
    local function OnEnter(self)
      SetTooltip(str, self)
    end
    frame.guide:SetHandler("OnEnter", OnEnter)
  end
  SetGuideTooltip()
  local function SetActability()
    local info = X2Ability:GetMyActabilityInfo(33)
    if info == nil then
      return
    end
    local gradeInfo = X2Ability:GetGradeInfo(info.grade)
    local color = Hex2Dec(gradeInfo.colorString)
    if info.grade == 0 then
      color = FONT_COLOR.DEFAULT
    end
    local str = string.format("%s : %s", locale.composition.actability, frame.gradeName)
    actabilityLabel:SetText(str)
    ApplyTextColor(actabilityLabel, color)
  end
  SetActability()
  local titleEdit = W_CTRL.CreateEdit("titleEdit", frame)
  titleEdit:AddAnchor("TOPRIGHT", frame.guide, "BOTTOMRIGHT", 0, 2)
  titleEdit:SetMaxTextLength(12)
  local titleLabel = frame:CreateChildWidget("label", "titleLabel", 0, true)
  titleLabel:SetHeight(FONT_SIZE.LARGE)
  titleLabel:SetAutoResize(true)
  titleLabel:SetText(locale.mail.title)
  titleLabel:AddAnchor("RIGHT", titleEdit, "LEFT", -5, -1)
  titleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(titleLabel, FONT_COLOR.MIDDLE_TITLE)
  local contentWidth = frame:GetWidth() - sideMargin * 2
  local editWidth = contentWidth - titleLabel:GetWidth() - 10
  titleEdit:SetExtent(editWidth, DEFAULT_SIZE.EDIT_HEIGHT)
  local editScroll = CreateEditScroll(frame, "editScroll", 0)
  editScroll:AddAnchor("TOPRIGHT", titleEdit, "BOTTOMRIGHT", 0, 15)
  editScroll:SetExtent(contentWidth, 520)
  editScroll.editbox:SetExtent(editScroll.content:GetWidth() - 20, 2400)
  editScroll.editbox:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  editScroll.editbox:SetMaxTextLength(itemLimit)
  editScroll.editbox:SetInset(15, 0, 15, 0)
  editScroll.editbox.bg:SetVisible(false)
  local input_texture = editScroll:CreateDrawable(TEXTURE_PATH.DEFAULT, "mail_write_bg", "background")
  input_texture:SetColor(ConvertColor(255), ConvertColor(161), ConvertColor(38), 0.7)
  input_texture:AddAnchor("TOPLEFT", editScroll.content, 0, -5)
  local input_texture_2 = editScroll:CreateDrawable(TEXTURE_PATH.DEFAULT, "mail_write_2_bg", "background")
  input_texture_2:SetColor(ConvertColor(255), ConvertColor(161), ConvertColor(38), 0.7)
  input_texture_2:AddAnchor("BOTTOMRIGHT", editScroll.content, 0, 0)
  local inputState = frame:CreateChildWidget("textbox", "inputState", 0, false)
  inputState:SetExtent(300, FONT_SIZE.SMALL)
  inputState:AddAnchor("TOPRIGHT", editScroll, "BOTTOMRIGHT", 0, sideMargin / 2)
  inputState.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(inputState, FONT_COLOR.DEFAULT)
  inputState:SetText(string.format("%s/%s", "0", frame.limit))
  local function CheckEnableSave()
    local len = string.len(titleEdit:GetText())
    if len < 1 then
      return false
    end
    local score_len = editScroll.editbox:GetTextLength()
    if score_len < 1 then
      return false
    end
    if score_len > frame.limit then
      return false
    end
    return true
  end
  local function CheckEnableMusicSample()
    local len = string.len(editScroll.editbox:GetText())
    if len < 1 then
      return false
    end
    return true
  end
  local cancelButton = frame:CreateChildWidget("button", "cancelButton", 0, false)
  cancelButton:AddAnchor("BOTTOMRIGHT", frame, -sideMargin + 1, -sideMargin)
  cancelButton:SetText(locale.messageBoxBtnText.cancel)
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  local function CancelButtonLeftClickFunc()
    frame:Show(false)
  end
  ButtonOnClickHandler(cancelButton, CancelButtonLeftClickFunc)
  local saveButton = frame:CreateChildWidget("button", "saveButton", 0, false)
  saveButton:Enable(false)
  saveButton:AddAnchor("RIGHT", cancelButton, "LEFT", 0, 0)
  saveButton:SetText(locale.composition.saveMusic)
  ApplyButtonSkin(saveButton, BUTTON_BASIC.DEFAULT)
  local function SaveButtonLeftClickFunc()
    local titleText = titleEdit:GetText()
    local msg = editScroll.editbox:GetText()
    if X2UserMusic:PrepareToSaveMusicSheet(frame.itemIdString, titleText, msg) then
      local function DialogHandler(wnd, infoTable)
        function wnd:OkProc()
          X2UserMusic:TryToSaveMusicSheet()
          frame:Show(false)
        end
        wnd:SetTitle(locale.composition.saveMusic)
        wnd:SetContent(X2Locale:LocalizeUiText(COMPOSITION_TEXT, "save_dialog_content"))
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, frame:GetId())
    end
  end
  ButtonOnClickHandler(saveButton, SaveButtonLeftClickFunc)
  local sampleButton = frame:CreateChildWidget("button", "sampleButton", 0, false)
  sampleButton:Enable(false)
  sampleButton:AddAnchor("RIGHT", saveButton, "LEFT", 0, 0)
  sampleButton:SetText(locale.composition.musicSample)
  ApplyButtonSkin(sampleButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {
    cancelButton,
    saveButton,
    sampleButton
  }
  AdjustBtnLongestTextWidth(buttonTable, infos.fixedWidth)
  local function SampleButtonLeftClickFunc()
    local msg = editScroll.editbox:GetText()
    X2UserMusic:PlayMusicSheet(msg)
  end
  ButtonOnClickHandler(sampleButton, SampleButtonLeftClickFunc)
  local function OnTextChangedTitleEdit()
    saveButton:Enable(CheckEnableSave())
  end
  titleEdit:SetHandler("OnTextChanged", OnTextChangedTitleEdit)
  function editScroll:OnTextChangedProc()
    local len = editScroll.editbox:GetTextLength()
    local color
    if len > frame.limit then
      color = FONT_COLOR_HEX.RED
    else
      color = FONT_COLOR_HEX.DEFAULT
    end
    local str = string.format("%s%s|r/%s", color, len, frame.limit)
    inputState:SetText(str)
    saveButton:Enable(CheckEnableSave())
    sampleButton:Enable(CheckEnableMusicSample())
  end
  local methodButton = frame:CreateChildWidget("button", "methodButton", 0, false)
  methodButton:SetText(locale.composition.method)
  ApplyButtonSkin(methodButton, BUTTON_BASIC.DEFAULT)
  methodButton:AddAnchor("BOTTOMLEFT", frame, sideMargin, -sideMargin)
  local MethodButtonLeftClickFunc = function()
    ShowCompositionMethodWnd(true)
  end
  ButtonOnClickHandler(methodButton, MethodButtonLeftClickFunc)
  function frame:ShowProc()
    titleEdit:SetText("")
    titleEdit:SetFocus()
    editScroll.editbox:SetText("")
  end
  local OnHide = function()
    composition.score = nil
    composition.methodWnd = nil
    X2UserMusic:StopMusicSheet()
  end
  frame:SetHandler("OnHide", OnHide)
  local function GetContentHeight()
    local _, height = F_LAYOUT.GetExtentWidgets(frame.titleBar, inputState)
    height = height + cancelButton:GetHeight() + sideMargin + 7
    return height
  end
  frame:SetHeight(GetContentHeight())
  return frame
end
