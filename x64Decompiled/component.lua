function CreateLogoWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  local bg = wnd:CreateColorDrawable(0, 0, 0, 1, "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  return wnd
end
function CreateGameHealthWnd(id, parent)
  local wnd
  if parent == "UIParent" then
    wnd = UIParent:CreateWidget("emptywidget", id, parent)
  else
    wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  end
  wnd:Clickable(false)
  wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  local bg = wnd:CreateImageDrawable(LOGIN_STAGE_TEXTURE_PATH.HEALTH_NOTICE, "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local TIME = 0
  local SHOW_TIME = 4000
  function wnd:OnUpdate(dt)
    TIME = TIME + dt
    if TIME > SHOW_TIME then
      X2LoginCharacter:EndCurrentLoginStage()
      wnd:ReleaseHandler("OnUpdate")
    end
  end
  function wnd:OnShow()
    TIME = 0
    wnd:SetHandler("OnUpdate", wnd.OnUpdate)
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  function wnd:OnHide()
    wnd:ReleaseHandler("OnUpdate")
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  function wnd:ReAnchorOnScale()
    wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
    wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  end
  wnd:SetHandler("OnScale", wnd.ReAnchorOnScale)
  return wnd
end
function CreateGameRatingWnd(id, parent)
  local wnd
  if parent == "UIParent" then
    wnd = UIParent:CreateWidget("emptywidget", id, parent)
  else
    wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  end
  wnd:Clickable(false)
  wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  local bg = wnd:CreateImageDrawable(LOGIN_STAGE_TEXTURE_PATH.GAME_GRADE_BG, "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local TIME = 0
  local SHOW_TIME = 4000
  function wnd:OnUpdate(dt)
    TIME = TIME + dt
    if TIME > SHOW_TIME then
      X2LoginCharacter:EndCurrentLoginStage()
      wnd:ReleaseHandler("OnUpdate")
    end
  end
  function wnd:OnShow()
    TIME = 0
    wnd:SetHandler("OnUpdate", wnd.OnUpdate)
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  function wnd:OnHide()
    wnd:ReleaseHandler("OnUpdate")
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  function wnd:ReAnchorOnScale()
    wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
    wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  end
  wnd:SetHandler("OnScale", wnd.ReAnchorOnScale)
  return wnd
end
local cursorColor = EDITBOX_CURSOR.LOGIN_STAGE
function CreateIdPassWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:Clickable(false)
  wnd:SetExtent(325, 143)
  local bg = wnd:CreateDrawable(TEXTURE_PATH.DEFAULT_NEW, "window_login", "background")
  bg:SetTextureColor("default")
  bg:SetExtent(325, 143)
  bg:AddAnchor("CENTER", wnd, 0, 0)
  bg:SetVisible(true)
  local idEdit = W_CTRL.CreateEdit("idEdit ", wnd)
  idEdit:SetExtent(244, 34)
  idEdit:SetEnglish(true)
  idEdit:SetMaxTextLength(32)
  idEdit:AddAnchor("TOP", wnd, 0, 30)
  idEdit:SetSounds("edit_box")
  idEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  idEdit:SetInset(12, 0, 12, 2)
  ApplyTextColor(idEdit, F_COLOR.GetColor("character_slot_df"))
  idEdit:SetCursorColor(cursorColor[1], cursorColor[2], cursorColor[3], cursorColor[4])
  idEdit:CreateGuideText(locale.login.id, ALIGN_CENTER)
  idEdit.guideTextStyle:SetFontSize(FONT_SIZE.LARGE)
  local color = F_COLOR.GetColor("character_slot_df")
  idEdit.guideTextStyle:SetColor(color[1], color[2], color[3], color[4])
  idEdit.guideTextStyle:SetShadow(false)
  local passwdEdit = W_CTRL.CreateEdit("passwdEdit", wnd)
  passwdEdit:SetExtent(244, 34)
  passwdEdit:SetEnglish(true)
  passwdEdit:SetMaxTextLength(16)
  passwdEdit:SetPassword(true)
  passwdEdit:AddAnchor("TOP", idEdit, "BOTTOM", 0, 15)
  passwdEdit:SetSounds("edit_box")
  passwdEdit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  passwdEdit:SetInset(12, 0, 12, 2)
  ApplyTextColor(passwdEdit, F_COLOR.GetColor("character_slot_df"))
  passwdEdit:SetCursorColor(cursorColor[1], cursorColor[2], cursorColor[3], cursorColor[4])
  passwdEdit:CreateGuideText(locale.login.password, ALIGN_CENTER)
  passwdEdit.guideTextStyle:SetFontSize(FONT_SIZE.LARGE)
  local color = F_COLOR.GetColor("character_slot_df")
  passwdEdit.guideTextStyle:SetColor(color[1], color[2], color[3], color[4])
  passwdEdit.guideTextStyle:SetShadow(false)
  local loginBtn = wnd:CreateChildWidget("button", "loginBtn", 0, true)
  loginBtn:Enable(false)
  loginBtn:EnableFocus(true)
  ApplyButtonSkin(loginBtn, BUTTON_STYLE.STAGE)
  loginBtn:SetExtent(120, 40)
  loginBtn:SetText(locale.login.login)
  loginBtn.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  loginBtn:AddAnchor("TOP", wnd, "BOTTOM", 0, 20)
  function passwdEdit:OnEvent(event)
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage ~= "English" then
      X2Input:SetInputLanguage("English")
    end
  end
  passwdEdit:SetHandler("OnEvent", passwdEdit.OnEvent)
  passwdEdit:RegisterEvent("IME_STATUS_CHANGED")
  local tryingLogin = false
  local function Trylogin()
    if tryingLogin then
      return
    end
    local idLen = string.len(idEdit:GetText())
    local passwdLen = string.len(passwdEdit:GetText())
    if idLen < 4 then
      idEdit:SetFocus()
    elseif passwdLen < 6 then
      passwdEdit:SetFocus()
    else
      X2:ConnectToServer("", idEdit:GetText(), passwdEdit:GetText())
      passwdEdit:SetText("")
      F_SOUND.PlayUISound("login_stage_try_login", true)
    end
  end
  idEdit:SetHandler("OnEnterPressed", Trylogin)
  passwdEdit:SetHandler("OnEnterPressed", Trylogin)
  loginBtn:SetHandler("OnEnterPressed", Trylogin)
  loginBtn:SetHandler("OnClick", Trylogin)
  function loginBtn:OnEnter()
    if self:IsEnabled() == false then
      SetLoingStageTargetAnchorTooltip(locale.login.loginTip, "TOP", self, "BOTTOM", 0, 5)
    end
  end
  loginBtn:SetHandler("OnEnter", loginBtn.OnEnter)
  function loginBtn:UpdateStatus()
    loginBtn:Enable(true)
    local idLen = string.len(idEdit:GetText())
    local passwdLen = string.len(passwdEdit:GetText())
    if tryingLogin then
      loginBtn:Enable(false)
    elseif idLen < 4 then
      loginBtn:Enable(false)
    elseif passwdLen < 6 then
      loginBtn:Enable(false)
    end
  end
  idEdit:SetHandler("OnTextChanged", loginBtn.UpdateStatus)
  passwdEdit:SetHandler("OnTextChanged", loginBtn.UpdateStatus)
  function wnd:SetEnable(enable)
    tryingLogin = not enable
    loginBtn:UpdateStatus()
  end
  function wnd:OnShow()
    local name = Console:GetAttribute("cl_account")
    if string.len(name) > 0 then
      idEdit:SetText(name)
      passwdEdit:SetFocus()
    else
      idEdit:SetFocus()
    end
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  return wnd
end
function CreateBottomMenuWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetExtent(215, 20)
  wnd:Clickable(false)
  local joinBtn = wnd:CreateChildWidget("button", "joinBtn", 0, true)
  joinBtn:SetExtent(45, 20)
  joinBtn:SetText(locale.login.join)
  SetButtonFontColor(joinBtn, GetLoginStageDefaultFontColor())
  joinBtn:AddAnchor("LEFT", wnd, 0, 0)
  ApplyTextColor(joinBtn, GRAY_FONT_COLOR)
  function joinBtn:OnClick()
    X2:RequestJoin()
  end
  joinBtn:SetHandler("OnClick", joinBtn.OnClick)
  local sepa1 = wnd:CreateChildWidget("label", "sepa1", 0, true)
  sepa1:SetExtent(20, 20)
  sepa1:SetText(" / ")
  sepa1:AddAnchor("LEFT", joinBtn, "RIGHT", 0, 0)
  ApplyTextColor(sepa1, GRAY_FONT_COLOR)
  local findIdBtn = wnd:CreateChildWidget("button", "findIdBtn", 0, true)
  findIdBtn:SetExtent(60, 20)
  findIdBtn:SetText(locale.login.findId)
  SetButtonFontColor(findIdBtn, GetLoginStageDefaultFontColor())
  findIdBtn:AddAnchor("LEFT", sepa1, "RIGHT", 0, 0)
  ApplyTextColor(findIdBtn, GRAY_FONT_COLOR)
  function findIdBtn:OnClick()
    X2:RequestFindId()
  end
  findIdBtn:SetHandler("OnClick", findIdBtn.OnClick)
  local sepa2 = wnd:CreateChildWidget("label", "sepa2", 0, true)
  sepa2:SetExtent(20, 20)
  sepa2:SetText(" / ")
  sepa2:AddAnchor("LEFT", findIdBtn, "RIGHT", 0, 0)
  ApplyTextColor(sepa2, GRAY_FONT_COLOR)
  local findPwBtn = wnd:CreateChildWidget("button", "findPwBtn", 0, true)
  findPwBtn:SetExtent(70, 20)
  findPwBtn:SetText(locale.login.findPassword)
  SetButtonFontColor(findPwBtn, GetLoginStageDefaultFontColor())
  findPwBtn:AddAnchor("LEFT", sepa2, "RIGHT", 0, 0)
  ApplyTextColor(findPwBtn, GRAY_FONT_COLOR)
  function findPwBtn:OnClick()
    X2:RequestFindPassword()
  end
  findPwBtn:SetHandler("OnClick", findPwBtn.OnClick)
  return wnd
end
function CreateOtpPcCertWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:Clickable(false)
  wnd:SetExtent(325, 143)
  local bg = wnd:CreateNinePartDrawable(TEXTURE_PATH.DEFAULT_NEW, "background")
  bg:SetTextureInfo("window")
  bg:SetExtent(325, 143)
  bg:AddAnchor("CENTER", wnd, 0, 0)
  bg:SetVisible(true)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:Raise()
  title:SetExtent(244, FONT_SIZE.LARGE)
  title:AddAnchor("TOP", wnd, 0, 40)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(title, GRAY_FONT_COLOR)
  local edit = W_CTRL.CreateEdit("edit", wnd)
  edit:SetExtent(244, 34)
  edit:AddAnchor("TOP", title, "BOTTOM", 0, 25)
  edit:SetSounds("edit_box")
  edit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  edit:SetInset(12, 0, 12, 2)
  ApplyTextColor(edit, GRAY_FONT_COLOR)
  edit:SetCursorColor(cursorColor[1], cursorColor[2], cursorColor[3], cursorColor[4])
  local btn = wnd:CreateChildWidget("button", "btn", 0, true)
  btn:Enable(false)
  btn:EnableFocus(true)
  btn:SetExtent(170, 50)
  btn:SetText(locale.login.login)
  ApplyButtonSkin(btn, BUTTON_STYLE.STAGE)
  btn:SetExtent(120, 40)
  if connectLocale.returnToLogin then
    btn:AddAnchor("TOPRIGHT", wnd, "BOTTOM", -5, 20)
  else
    btn:AddAnchor("TOP", wnd, "BOTTOM", 0, 20)
  end
  btn.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  local returnToLogin
  if connectLocale.returnToLogin then
    returnToLogin = wnd:CreateChildWidget("button", "returnToLogin", 0, true)
    returnToLogin:EnableFocus(true)
    returnToLogin:SetExtent(170, 50)
    returnToLogin:SetText(GetUIText(LOGIN_TEXT, "btn_return_to_login"))
    ApplyButtonSkin(returnToLogin, BUTTON_STYLE.STAGE)
    returnToLogin:SetExtent(120, 40)
    returnToLogin:AddAnchor("LEFT", btn, "RIGHT", 5, 0)
    returnToLogin.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  end
  function edit:OnEscapePressed()
  end
  edit:SetHandler("OnEscapePressed", edit.OnEscapePressed)
  function edit:OnEvent(event)
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage ~= "English" then
      X2Input:SetInputLanguage("English")
    end
  end
  edit:SetHandler("OnEvent", edit.OnEvent)
  edit:RegisterEvent("IME_STATUS_CHANGED")
  local isOtp = false
  local isPcCert = false
  local tryingCert = false
  local pcCertLength = 8
  local otpLength = connectLocale.otpLength
  local function TryCert()
    if tryingCert then
      return
    end
    local valueLength = pcCertLength
    if isOtp then
      valueLength = otpLength
    end
    local len = string.len(edit:GetText())
    if valueLength > len then
      edit:SetFocus()
    else
      if isOtp then
        X2:SendOtpNumber(edit:GetText())
      elseif isPcCert then
        X2:SendPcCertNumber(edit:GetText())
      end
      edit:SetText("")
      btn:SetText(locale.login.certing)
      F_SOUND.PlayUISound("login_stage_try_login", true)
      if connectLocale.returnToLogin then
        returnToLogin:Enable(false)
      end
    end
  end
  edit:SetHandler("OnEnterPressed", TryCert)
  btn:SetHandler("OnEnterPressed", TryCert)
  btn:SetHandler("OnClick", TryCert)
  function btn:UpdateStatus()
    local valueLength = pcCertLength
    if isOtp then
      valueLength = otpLength
    end
    local len = string.len(edit:GetText())
    if valueLength > len then
      btn:Enable(false)
    else
      btn:Enable(true)
    end
  end
  edit:SetHandler("OnTextChanged", btn.UpdateStatus)
  if connectLocale.returnToLogin then
    function returnToLogin:OnClick()
      X2:ReturnToLoginStage()
    end
    returnToLogin:SetHandler("OnClick", returnToLogin.OnClick)
  end
  function wnd:Clear()
    edit:ClearFocus()
  end
  function wnd:SetOtpMode()
    title:SetText(locale.login.title_otp)
    btn:SetText(locale.login.btn_otp)
    edit:SetText("")
    edit:SetMaxTextLength(otpLength)
    edit:SetFocus()
    tryingCert = false
    isOtp = true
    isPcCert = false
    if connectLocale.returnToLogin then
      returnToLogin:Enable(true)
    end
  end
  function wnd:SetPcCertMode()
    title:SetText(locale.login.title_pc_cert)
    btn:SetText(locale.login.btn_pc_cert)
    edit:SetText("")
    edit:SetMaxTextLength(pcCertLength)
    edit:SetFocus()
    tryingCert = false
    isOtp = false
    isPcCert = true
    if connectLocale.returnToLogin then
      returnToLogin:Enable(true)
    end
  end
  return wnd
end
function CreateARSCertWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:Clickable(false)
  wnd:SetExtent(325, 143)
  local bg = wnd:CreateNinePartDrawable(TEXTURE_PATH.DEFAULT_NEW, "background")
  bg:SetTextureInfo("window")
  bg:SetExtent(325, 143)
  bg:AddAnchor("CENTER", wnd, 0, 0)
  bg:SetVisible(true)
  local title = wnd:CreateChildWidget("textbox", "title", 0, true)
  title:SetWidth(280)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", wnd, 0, 40)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(title, GRAY_FONT_COLOR)
  local arsNumber = wnd:CreateChildWidget("label", "arsNumber", 0, true)
  arsNumber:Raise()
  arsNumber:SetAutoResize(true)
  arsNumber:SetHeight(FONT_SIZE.XXLARGE)
  arsNumber:AddAnchor("TOP", title, "BOTTOM", 0, 15)
  arsNumber.style:SetFontSize(FONT_SIZE.XXLARGE)
  arsNumber.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(arsNumber, FONT_COLOR.SOFT_YELLOW)
  local btn = wnd:CreateChildWidget("button", "arsButton", 0, true)
  btn:Enable(false)
  btn:EnableFocus(true)
  btn:SetText(GetUIText(LOGIN_TEXT, "certing"))
  btn:AddAnchor("TOP", wnd, "BOTTOM", 0, 20)
  ApplyButtonSkin(btn, BUTTON_STYLE.STAGE)
  btn:SetExtent(120, 40)
  btn.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  local showTime = 0
  local maxTime = 0
  function wnd:OnUpdate(dt)
    showTime = showTime + dt
    local curTime = math.max(maxTime - showTime, 0)
    if curTime > 0 then
      title:SetText(locale.login.GetContentArsWithTimeOut(math.floor(curTime / 1000)))
    else
      wnd:ReleaseHandler("OnUpdate")
      title:SetText(locale.login.GetContentArs())
    end
  end
  function wnd:SetInfo(number, timeout)
    local msg
    if timeout > 0 then
      showTime = 0
      maxTime = timeout + 1000
      msg = locale.login.GetContentArsWithTimeOut(math.floor(timeout / 1000))
      wnd:SetHandler("OnUpdate", wnd.OnUpdate)
    else
      msg = locale.login.GetContentArs()
    end
    title:SetText(msg)
    arsNumber:SetText(tostring(number))
  end
  return wnd
end
function CreateSecureCardWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:Clickable(false)
  wnd:SetExtent(325, 143)
  local bg = wnd:CreateNinePartDrawable(TEXTURE_PATH.DEFAULT_NEW, "background")
  bg:SetTextureInfo("window")
  bg:SetExtent(325, 143)
  bg:AddAnchor("CENTER", wnd, 0, 0)
  bg:SetVisible(true)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:Raise()
  title:SetExtent(305, FONT_SIZE.LARGE)
  title:SetText(GetCommonText("please_input_secure_card_number"))
  title:AddAnchor("TOP", wnd, 0, 40)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(title, FONT_COLOR.DEFAULT_GRAY)
  local info = wnd:CreateChildWidget("label", "info", 0, true)
  info:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 25)
  info:SetExtent(110, FONT_SIZE.LARGE)
  info.style:SetFontSize(FONT_SIZE.LARGE)
  info.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(info, FONT_COLOR.DEFAULT_GRAY)
  local valueLenth = 4
  local edit = W_CTRL.CreateEdit("edit", wnd)
  edit:SetExtent(186, 34)
  edit:SetMaxTextLength(valueLenth)
  edit:AddAnchor("LEFT", info, "RIGHT", 7, 0)
  edit:SetSounds("edit_box")
  edit.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  edit:SetInset(12, 0, 12, 2)
  ApplyTextColor(edit, GRAY_FONT_COLOR)
  edit:SetCursorColor(cursorColor[1], cursorColor[2], cursorColor[3], cursorColor[4])
  edit:SetEnglish(true)
  local tryButton = wnd:CreateChildWidget("button", "tryButton", 0, true)
  tryButton:Enable(false)
  tryButton:EnableFocus(true)
  tryButton:SetExtent(170, 50)
  tryButton:SetText(GetUIText(LOGIN_TEXT, "btn_secure_card"))
  ApplyButtonSkin(tryButton, BUTTON_STYLE.STAGE)
  tryButton:SetExtent(120, 40)
  if connectLocale.returnToLogin then
    tryButton:AddAnchor("TOPRIGHT", wnd, "BOTTOM", -5, 20)
  else
    tryButton:AddAnchor("TOP", wnd, "BOTTOM", 0, 20)
  end
  tryButton.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  local returnToLogin
  if connectLocale.returnToLogin then
    returnToLogin = wnd:CreateChildWidget("button", "returnToLogin", 0, true)
    returnToLogin:EnableFocus(true)
    returnToLogin:SetExtent(170, 50)
    returnToLogin:SetText(GetUIText(LOGIN_TEXT, "btn_return_to_login"))
    ApplyButtonSkin(returnToLogin, BUTTON_STYLE.STAGE)
    returnToLogin:SetExtent(120, 40)
    returnToLogin:AddAnchor("LEFT", tryButton, "RIGHT", 10, 0)
    returnToLogin.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  end
  function edit:OnEscapePressed()
  end
  edit:SetHandler("OnEscapePressed", edit.OnEscapePressed)
  function edit:OnEvent(event)
    local inputLanguage = X2Input:GetInputLanguage()
    if inputLanguage ~= "English" then
      X2Input:SetInputLanguage("English")
    end
  end
  edit:SetHandler("OnEvent", edit.OnEvent)
  edit:RegisterEvent("IME_STATUS_CHANGED")
  local tryingCert = false
  local function TryCert()
    if tryingCert then
      return
    end
    local len = string.len(edit:GetText())
    if len < valueLenth then
      edit:SetFocus()
    else
      if connectLocale.returnToLogin then
        returnToLogin:Enable(false)
      end
      X2:SendSecureCardNumber(edit:GetText())
      tryingCert = true
      edit:SetText("")
      tryButton:SetText(locale.login.certing)
      F_SOUND.PlayUISound("login_stage_try_login", true)
    end
  end
  edit:SetHandler("OnEnterPressed", TryCert)
  tryButton:SetHandler("OnEnterPressed", TryCert)
  tryButton:SetHandler("OnClick", TryCert)
  function tryButton:UpdateStatus()
    local len = string.len(edit:GetText())
    if len < valueLenth then
      tryButton:Enable(false)
    else
      tryButton:Enable(true)
    end
  end
  edit:SetHandler("OnTextChanged", tryButton.UpdateStatus)
  if connectLocale.returnToLogin then
    function returnToLogin:OnClick()
      X2:ReturnToLoginStage()
    end
    returnToLogin:SetHandler("OnClick", returnToLogin.OnClick)
  end
  function wnd:Clear()
    edit:ClearFocus()
  end
  function wnd:SetInfo(secureCardIndex)
    info:SetText(GetCommonText("secure_card_index", tostring(secureCardIndex)))
    tryButton:SetText(GetUIText(LOGIN_TEXT, "btn_secure_card"))
    edit:SetText("")
    edit:SetFocus()
    tryingCert = false
    if connectLocale.returnToLogin then
      returnToLogin:Enable(true)
    end
  end
  return wnd
end
