local CreateSecondPasswordDialog = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, 150)
  window:SetTitle(GetUIText(SECOND_PASSWORD_TEXT, "setting_second_password"))
  window:AddAnchor("CENTER", parent, 0, 0)
  window:EnableHidingIsRemove(true)
  local content = window:CreateChildWidget("textbox", "content", 0, false)
  content:SetText(locale.secondPassword.setting_content)
  content:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  content:AddAnchor("TOP", window, 0, titleMargin)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local liftButton = window:CreateChildWidget("button", "liftButton", 0, true)
  liftButton:SetText(GetUIText(SECOND_PASSWORD_TEXT, "password_lift"))
  liftButton:AddAnchor("BOTTOM", window, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(liftButton, BUTTON_BASIC.DEFAULT)
  local function StartSecondPasswordClear()
    window:Show(false)
    X2Security:StartSecondPasswordClear()
  end
  ButtonOnClickHandler(liftButton, StartSecondPasswordClear, nil)
  local modifyButton = window:CreateChildWidget("button", "modifyButton", 0, true)
  modifyButton:SetText(GetUIText(SECOND_PASSWORD_TEXT, "password_modify"))
  modifyButton:AddAnchor("RIGHT", liftButton, "LEFT", 0, 0)
  ApplyButtonSkin(modifyButton, BUTTON_BASIC.DEFAULT)
  local function StartSecondPasswordChange()
    window:Show(false)
    X2Security:StartSecondPasswordChange()
  end
  ButtonOnClickHandler(modifyButton, StartSecondPasswordChange, nil)
  local buttonTable = {liftButton, modifyButton}
  if secondPasswordLocale.webLift then
    local webLiftButton = window:CreateChildWidget("button", "webLiftButton", 0, true)
    webLiftButton:SetText(locale.secondPassword.passwordWebLift)
    webLiftButton:AddAnchor("LEFT", liftButton, "RIGHT", 0, 0)
    ApplyButtonSkin(webLiftButton, BUTTON_BASIC.DEFAULT)
    local function StartSecondPasswordWebClear()
      window:Show(false)
      X2Security:StartSecondPasswordWebClear()
    end
    ButtonOnClickHandler(webLiftButton, StartSecondPasswordWebClear, nil)
    buttonTable = {
      liftButton,
      modifyButton,
      webLiftButton
    }
  else
    liftButton:AddAnchor("BOTTOM", window, 50, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    modifyButton:AddAnchor("RIGHT", liftButton, "LEFT", -20, 0)
  end
  AdjustBtnLongestTextWidth(buttonTable)
  local OnHide = function()
    secondPassword.dialog = nil
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
function ShowSecondPasswordDialog()
  if secondPassword.dialog == nil then
    secondPassword.dialog = CreateSecondPasswordDialog("secondPassword.dialog", "UIParent")
    ADDON:RegisterContentWidget(UIC_INTERACT_SECOND_PASSWORD, secondPassword.dialog)
  end
  secondPassword.dialog:Show(true)
end
local ShowRecommentUsingSecondPasswordDialog = function()
  local DecorateFunc = function(wnd, infoTable)
    wnd:SetTitle(locale.secondPassword.recommendSecondPasswordTitle)
    wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "second_password_content"))
  end
  X2DialogManager:RequestNoticeDialog(DecorateFunc, "")
end
UIParent:SetEventHandler("SHOW_RECOMMEND_USING_SECOND_PASSWORD", ShowRecommentUsingSecondPasswordDialog)
