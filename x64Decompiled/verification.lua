local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateSecondPasswordClearWnd(id, parent)
  local frame = CreateWindow(id, parent)
  frame:SetUILayer("normal")
  frame:SetWindowModal(true)
  frame:SetExtent(POPUP_WINDOW_WIDTH, 220)
  frame:AddAnchor("CENTER", parent, 0, 0)
  frame:SetTitle(locale.secondPassword.clearTitle)
  frame:EnableHidingIsRemove(true)
  local content = frame:CreateChildWidget("label", "content", 0, false)
  content:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  content:SetText(locale.secondPassword.clearContent)
  content:AddAnchor("TOP", frame, 0, titleMargin)
  content.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local passwordFrame = frame:CreateChildWidget("emptywidget", "passwordFrame", 0, false)
  passwordFrame:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 70)
  passwordFrame:AddAnchor("TOPLEFT", content, "BOTTOMLEFT", 0, sideMargin / 2)
  local inset = sideMargin / 1.5
  local bg = CreateContentBackground(passwordFrame, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", passwordFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", passwordFrame, 0, 0)
  CreatePasswordEdit("passwordEdit", frame, locale.login.password, 300)
  frame.passwordEdit:AddAnchor("BOTTOMLEFT", passwordFrame, sideMargin / 1.5, -sideMargin / 1.5)
  local reinputLabel = frame:CreateChildWidget("label", "reinputLabel", 0, true)
  reinputLabel:SetAutoResize(true)
  reinputLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinputLabel:AddAnchor("LEFT", frame.passwordEdit, "RIGHT", 5, 0)
  ApplyTextColor(reinputLabel, FONT_COLOR.RED)
  local function LeftButtonLeftClickFunc()
    X2Security:ClearSecondPassword(frame.passwordEdit:GetText())
    frame:Show(false)
  end
  local function RightButtonLeftClickFunc()
    frame:Show(false)
  end
  local buttonSetInfos = {
    isPopupWindow = true,
    leftButtonLeftClickFunc = LeftButtonLeftClickFunc,
    rightButtonLeftClickFunc = RightButtonLeftClickFunc
  }
  CreateWindowDefaultTextButtonSet(frame, buttonSetInfos)
  local function OnTextChanged(self)
    frame.leftButton:Enable(string.len(self:GetText()) >= 4)
  end
  frame.passwordEdit:SetHandler("OnTextChanged", OnTextChanged)
  function frame:ShowProc()
    self.passwordEdit:SetFocus()
    self.passwordEdit:SetText("")
    local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
    if maxFailCnt == 0 then
      self.reinputLabel:SetText("")
    else
      self.reinputLabel:SetText(string.format("%s(%d/%d)", locale.secondPassword.reinputCount, curFailCnt, maxFailCnt))
    end
    CreateVirtualKeyboardSet("keyboard", self)
    for i = 1, MAX_KEYBOARD_COUNT do
      self.keyboard[i]:FillData(testKeys, self.passwordEdit)
    end
    frame.keyboard[1]:AddAnchor("TOPLEFT", frame, "TOPRIGHT", sideMargin / 2, 0)
    self.leftButton:Enable(false)
  end
  local OnHide = function()
    secondPassword.clearWnd = nil
  end
  frame:SetHandler("OnHide", OnHide)
  return frame
end
local function CreateSecondPasswordCheckWnd(id, parent)
  local frame = CreateWindow(id, parent)
  frame:SetUILayer("dialog")
  frame:SetWindowModal(true)
  frame:SetExtent(POPUP_WINDOW_WIDTH, 220)
  frame:AddAnchor("CENTER", parent, 0, 0)
  frame:EnableHidingIsRemove(true)
  frame:SetTitle(locale.secondPassword.verificationTitle)
  local content = frame:CreateChildWidget("label", "content", 0, false)
  content:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  content:AddAnchor("TOP", frame, 0, titleMargin)
  content.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  content:SetText(locale.secondPassword.verificationContent)
  local passwordFrame = frame:CreateChildWidget("emptywidget", "passwordFrame", 0, false)
  passwordFrame:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 70)
  passwordFrame:AddAnchor("TOPLEFT", content, "BOTTOMLEFT", 0, sideMargin / 2)
  local inset = sideMargin / 1.5
  local bg = CreateContentBackground(passwordFrame, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", passwordFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", passwordFrame, 0, 0)
  CreatePasswordEdit("passwordEdit", frame, locale.login.password, 300)
  frame.passwordEdit:AddAnchor("BOTTOMLEFT", passwordFrame, sideMargin / 1.5, -sideMargin / 1.5)
  local reinputLabel = frame:CreateChildWidget("label", "reinputLabel", 0, true)
  reinputLabel:SetAutoResize(true)
  reinputLabel:SetHeight(FONT_SIZE.MIDDLE)
  reinputLabel:AddAnchor("LEFT", frame.passwordEdit, "RIGHT", 5, 0)
  ApplyTextColor(reinputLabel, FONT_COLOR.RED)
  frame.clickedOkButton = false
  local function LeftButtonLeftClickFunc()
    X2Security:CheckSecondPassword(frame.passwordEdit:GetText())
    frame.clickedOkButton = true
  end
  local function RightButtonLeftClickFunc()
    frame:Show(false)
  end
  local buttonSetInfos = {
    isPopupWindow = true,
    leftButtonLeftClickFunc = LeftButtonLeftClickFunc,
    rightButtonLeftClickFunc = RightButtonLeftClickFunc
  }
  CreateWindowDefaultTextButtonSet(frame, buttonSetInfos)
  function frame:ShowProc()
    self.passwordEdit:SetFocus()
    self.passwordEdit:SetText("")
    local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
    if maxFailCnt == 0 then
      self.reinputLabel:SetText("")
    else
      self.reinputLabel:SetText(string.format("%s(%d/%d)", locale.secondPassword.reinputCount, curFailCnt, maxFailCnt))
    end
    CreateVirtualKeyboardSet("keyboard", self)
    for i = 1, MAX_KEYBOARD_COUNT do
      frame.keyboard[i]:FillData(testKeys, self.passwordEdit)
    end
    frame.keyboard[1]:AddAnchor("TOPLEFT", frame, "TOPRIGHT", sideMargin / 2, 0)
    self.leftButton:Enable(false)
  end
  local function OnTextChanged(self)
    frame.leftButton:Enable(string.len(self:GetText()) >= 4)
  end
  frame.passwordEdit:SetHandler("OnTextChanged", OnTextChanged)
  local function OnHide()
    if frame.clickedOkButton == false then
      X2Security:CancelVaildation()
    end
    secondPassword.checkWnd = nil
  end
  frame:SetHandler("OnHide", OnHide)
  return frame
end
function ShowSecondPasswordClearWnd()
  if secondPassword.clearWnd == nil then
    secondPassword.clearWnd = CreateSecondPasswordClearWnd("secondPassword.clearWnd", "UIParent")
    ADDON:RegisterContentWidget(UIC_CLEAR_SECOND_PASSWORD, secondPassword.clearWnd)
  end
  secondPassword.clearWnd:Show(true)
end
UIParent:SetEventHandler("SECOND_PASSWORD_CLEAR_STARTED", ShowSecondPasswordClearWnd)
function ShowSecondPasswordCheckWnd()
  if secondPassword.checkWnd == nil then
    secondPassword.checkWnd = CreateSecondPasswordCheckWnd("secondPassword.checkWnd", "UIParent")
    ADDON:RegisterContentWidget(UIC_CHECK_SECOND_PASSWORD, secondPassword.checkWnd)
  end
  if secondPassword.checkWnd:IsVisible() then
    secondPassword.checkWnd:Raise()
  else
    secondPassword.checkWnd:Show(true)
  end
end
UIParent:SetEventHandler("SECOND_PASSWORD_CHECK_STARTED", ShowSecondPasswordCheckWnd)
