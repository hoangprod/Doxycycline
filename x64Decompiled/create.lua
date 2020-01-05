local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function SetViewOfSetSecondPasswordWnd(id, parent)
  local width = 390
  local frame = CreateWindow(id, parent)
  frame:SetExtent(430, 360)
  frame:AddAnchor("CENTER", parent, 0, 0)
  frame:EnableHidingIsRemove(true)
  frame:SetUILayer("normal")
  frame:SetWindowModal(true)
  local content = frame:CreateChildWidget("textbox", "content", 0, false)
  content:SetWidth(width)
  ApplyTextColor(content, FONT_COLOR.RED)
  content:SetText(locale.secondPassword.content)
  content.style:SetAlign(ALIGN_CENTER)
  content.style:SetFontSize(FONT_SIZE.LARGE)
  content:SetHeight(content:GetTextHeight())
  content:AddAnchor("TOP", frame, 0, titleMargin)
  local passwordTip = frame:CreateChildWidget("label", "passwordTip", 0, false)
  passwordTip:SetExtent(width, FONT_SIZE.MIDDLE)
  passwordTip:SetText(locale.secondPassword.passwordTip)
  passwordTip.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(passwordTip, FONT_COLOR.GRAY)
  passwordTip:AddAnchor("TOP", content, "BOTTOM", 0, 8)
  local passwordFrame = frame:CreateChildWidget("emptywidget", "passwordFrame", 0, true)
  passwordFrame:SetExtent(width, 140)
  passwordFrame:AddAnchor("TOP", passwordTip, "BOTTOM", 0, sideMargin / 1.5)
  local bg = CreateContentBackground(passwordFrame, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", passwordFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", passwordFrame, 0, 0)
  CreatePasswordEdit("existingPasswordEdit", frame, locale.secondPassword.curPassword, 370)
  frame.existingPasswordEdit:Show(false)
  frame.existingPasswordEdit:AddAnchor("TOPLEFT", passwordFrame, sideMargin / 1.5, sideMargin * 1.6)
  local reinputLabel = frame:CreateChildWidget("label", "reinputLabel", 0, true)
  reinputLabel:SetAutoResize(true)
  reinputLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinputLabel:AddAnchor("LEFT", frame.existingPasswordEdit, "RIGHT", 5, 0)
  ApplyTextColor(reinputLabel, FONT_COLOR.RED)
  CreatePasswordEdit("passwordEdit", frame, locale.login.password, 370)
  CreatePasswordEdit("passwordConfirmEdit", frame, locale.secondPassword.passwordConfirm, 370)
  frame.passwordConfirmEdit:AddAnchor("TOPLEFT", frame.passwordEdit, "BOTTOMLEFT", 0, sideMargin * 1.8)
  local securityTip = frame:CreateChildWidget("textbox", "securityTip", 0, false)
  securityTip:SetWidth(width)
  securityTip:SetAutoResize(true)
  securityTip:SetText(locale.secondPassword.securityTip)
  ApplyTextColor(securityTip, FONT_COLOR.GRAY)
  securityTip:AddAnchor("TOP", passwordFrame, "BOTTOM", 0, sideMargin / 2)
  local info = {
    leftButtonStr = GetCommonText("ok"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(frame, info)
  local function GetWindowHeight()
    local height = titleMargin + -bottomMargin + content:GetHeight() + passwordTip:GetHeight() + passwordFrame:GetHeight() + securityTip:GetHeight() + frame.leftButton:GetHeight()
    return height
  end
  function frame:SetCreate(isCreate)
    frame.isCreate = isCreate
    if isCreate then
      self.passwordFrame:SetExtent(width, 140)
      self.existingPasswordEdit:Show(false)
      self.reinputLabel:Show(false)
      self.passwordEdit:RemoveAllAnchors()
      self.passwordEdit:AddAnchor("TOPLEFT", self.passwordFrame, sideMargin / 1.5, sideMargin * 1.8)
      self.passwordEdit.title:SetText(locale.login.password)
      self.passwordConfirmEdit.title:SetText(locale.secondPassword.passwordConfirm)
    else
      self.passwordFrame:SetExtent(width, 195)
      self.existingPasswordEdit:Show(true)
      self.reinputLabel:Show(true)
      self.passwordEdit:RemoveAllAnchors()
      self.passwordEdit:AddAnchor("TOPLEFT", self.existingPasswordEdit, "BOTTOMLEFT", 0, sideMargin * 1.8)
      self.passwordEdit.title:SetText(locale.secondPassword.newPassword)
      self.passwordConfirmEdit.title:SetText(locale.secondPassword.newPasswordConfirm)
    end
    self:SetHeight(GetWindowHeight())
    self.leftButton:Enable(false)
  end
  function frame:GetEnableApply()
    if self.isCreate then
      if string.len(self.passwordEdit:GetText()) < 3 then
        return false
      end
      if 3 > string.len(self.passwordConfirmEdit:GetText()) then
        return false
      end
      if self.passwordEdit:GetText() ~= self.passwordConfirmEdit:GetText() then
        return false
      end
      return true
    else
      if 3 > string.len(self.existingPasswordEdit:GetText()) then
        return false
      end
      if string.len(self.passwordEdit:GetText()) < 3 then
        return false
      end
      if 3 > string.len(self.passwordConfirmEdit:GetText()) then
        return false
      end
      if self.passwordEdit:GetText() ~= self.passwordConfirmEdit:GetText() then
        return false
      end
      return true
    end
  end
  function frame:CheckApplyButton()
    self.leftButton:Enable(self:GetEnableApply())
  end
  local OnHide = function()
    secondPassword.set = nil
  end
  frame:SetHandler("OnHide", OnHide)
  return frame
end
local function CreateSetSecondPasswordWnd(id, parent)
  local frame = SetViewOfSetSecondPasswordWnd(id, parent)
  ADDON:RegisterContentWidget(UIC_SET_SECOND_PASSWORD, frame)
  function OkButtonLeftClickFunc()
    if frame.isCreate then
      local password = frame.passwordEdit:GetText()
      local passwordConfirm = frame.passwordConfirmEdit:GetText()
      X2Security:CreateSecondPassword(password, passwordConfirm)
    else
      local existingPassword = frame.existingPasswordEdit:GetText()
      local password = frame.passwordEdit:GetText()
      local passwordConfirm = frame.passwordConfirmEdit:GetText()
      X2Security:ChangeSecondPassword(existingPassword, password, passwordConfirm)
    end
    frame:Show(false)
  end
  ButtonOnClickHandler(frame.leftButton, OkButtonLeftClickFunc)
  local function CancelButtonLeftClickFunc()
    frame:Show(false)
  end
  ButtonOnClickHandler(frame.rightButton, CancelButtonLeftClickFunc)
  local function ExistingPasswordEditOnTextChanged(self)
    frame:CheckApplyButton()
  end
  local function PasswordConfirmEditOnTextChanged(self)
    if self:GetText() == frame.passwordEdit:GetText() and frame.passwordEdit:GetText() ~= "" then
      ApplyTextColor(frame.passwordConfirmEdit.status, FONT_COLOR.GREEN)
      frame.passwordConfirmEdit.status:SetText(locale.secondPassword.accordance)
    else
      ApplyTextColor(frame.passwordConfirmEdit.status, FONT_COLOR.RED)
      frame.passwordConfirmEdit.status:SetText(locale.secondPassword.discordance)
    end
    frame:CheckApplyButton()
  end
  local function PassWordEditOnTextChanged(self)
    if string.len(self:GetText()) >= 4 then
      ApplyTextColor(frame.passwordEdit.status, FONT_COLOR.GREEN)
      frame.passwordEdit.status:SetText(locale.secondPassword.usable)
    else
      ApplyTextColor(frame.passwordEdit.status, FONT_COLOR.RED)
      frame.passwordEdit.status:SetText(locale.secondPassword.unusable)
    end
    PasswordConfirmEditOnTextChanged(frame.passwordConfirmEdit)
    frame:CheckApplyButton()
  end
  frame.passwordEdit:SetHandler("OnTextChanged", PassWordEditOnTextChanged)
  frame.existingPasswordEdit:SetHandler("OnTextChanged", ExistingPasswordEditOnTextChanged)
  frame.passwordConfirmEdit:SetHandler("OnTextChanged", PasswordConfirmEditOnTextChanged)
  local function SetKeyBoardData(edit)
    for i = 1, MAX_KEYBOARD_COUNT do
      frame.keyboard[i]:FillData(testKeys, edit)
    end
  end
  function frame:ShowProc()
    self.existingPasswordEdit:SetText("")
    self.passwordEdit:SetText("")
    self.passwordConfirmEdit:SetText("")
    local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
    if maxFailCnt == 0 then
      self.reinputLabel:SetText("")
    else
      self.reinputLabel:SetText(string.format("%s(%d/%d)", locale.secondPassword.reinputCount, curFailCnt, maxFailCnt))
    end
    self.passwordEdit.status:SetText(locale.secondPassword.unusable)
    self.passwordConfirmEdit.status:SetText(locale.secondPassword.discordance)
    CreateVirtualKeyboardSet("keyboard", self)
    self.keyboard[1]:AddAnchor("TOPLEFT", self, "TOPRIGHT", sideMargin / 2, -sideMargin / 3)
    if self.isCreate then
      self.passwordEdit:SetFocus()
      SetKeyBoardData(self.passwordEdit)
    else
      self.existingPasswordEdit:SetFocus()
      SetKeyBoardData(self.existingPasswordEdit)
    end
  end
  local function AcceptFocusEditSetting(edit)
    local function OnAcceptFocus(self)
      SetKeyBoardData(self)
    end
    edit:SetHandler("OnAcceptFocus", OnAcceptFocus)
  end
  AcceptFocusEditSetting(frame.existingPasswordEdit)
  AcceptFocusEditSetting(frame.passwordEdit)
  AcceptFocusEditSetting(frame.passwordConfirmEdit)
  return frame
end
function IsVisibleSecondPasswordCreateWnd()
  if secondPassword.set == nil then
    return false
  else
    return secondPassword.set:IsVisible()
  end
end
function ShowSecondPasswordCreationWnd(keys)
  if secondPassword.set == nil then
    secondPassword.set = CreateSetSecondPasswordWnd("secondPassword.create", "UIParent")
  end
  secondPassword.set:SetCreate(true)
  secondPassword.set:Show(true)
  secondPassword.set:SetTitle(locale.secondPassword.createTitle)
end
UIParent:SetEventHandler("SECOND_PASSWORD_CREATION_STARTED", ShowSecondPasswordCreationWnd)
function ShowSecondPasswordChangeWnd(keys)
  if secondPassword.set == nil then
    secondPassword.set = CreateSetSecondPasswordWnd("secondPassword.change", "UIParent")
  end
  secondPassword.set:SetCreate(false)
  secondPassword.set:Show(true)
  secondPassword.set:SetTitle(locale.secondPassword.modifyTitle)
end
UIParent:SetEventHandler("SECOND_PASSWORD_CHANGE_STARTED", ShowSecondPasswordChangeWnd)
