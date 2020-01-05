local FADE_DELAY = 500
function CreateLoginWnd(id)
  local wnd = CreateEmptyWindow(id, "UIParent")
  wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  wnd:Clickable(false)
  wnd:Show(false)
  local versionLabel = wnd:CreateChildWidget("label", "versionLabel", 0, true)
  versionLabel:SetExtent(10, FONT_SIZE.MIDDLE)
  versionLabel:SetAutoResize(true)
  versionLabel:AddAnchor("TOPLEFT", wnd, 10, 10)
  versionLabel:SetText(X2Util:GetVersionInfo())
  ApplyTextColor(versionLabel, F_COLOR.GetColor("version_info"))
  local biImg = wnd:CreateDrawable(BI_TEXTURE, "logo", "background")
  biImg:AddAnchor("BOTTOM", wnd, 0, -80)
  biImg:SetVisible(true)
  local bottomMenuWnd = CreateBottomMenuWnd("bottomMenuWnd", wnd)
  bottomMenuWnd:AddAnchor("BOTTOM", wnd, 0, -5)
  bottomMenuWnd:Show(not connectLocale.loginHide)
  local idPassWnd = CreateIdPassWnd("idPassWnd", wnd)
  idPassWnd:AddAnchor("BOTTOM", biImg, "TOP", 0, -70)
  idPassWnd:Show(false)
  local otpPcCertWnd = CreateOtpPcCertWnd("otpPcCertWnd", wnd)
  otpPcCertWnd:AddAnchor("BOTTOM", biImg, "TOP", 0, -70)
  otpPcCertWnd:Show(false)
  local arsCertWnd = CreateARSCertWnd("arsCertWnd", wnd)
  arsCertWnd:AddAnchor("BOTTOM", biImg, "TOP", 0, -70)
  arsCertWnd:Show(false)
  local secureCardWnd = CreateSecureCardWnd("secureCardWnd", wnd)
  secureCardWnd:AddAnchor("BOTTOM", biImg, "TOP", 0, -70)
  secureCardWnd:Show(false)
  function wnd:ReAnchorOnScale()
    wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
    wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  end
  wnd:SetHandler("OnScale", wnd.ReAnchorOnScale)
  local eventHandler = {
    SHOW_LOGIN_WINDOW = function(show)
      if not connectLocale.loginHide then
        idPassWnd:Show(show, FADE_DELAY)
      end
      local delay = show and 0 or FADE_DELAY
      arsCertWnd:Show(false, delay)
      otpPcCertWnd:Show(false, delay)
      secureCardWnd:Show(false, delay)
    end,
    OPEN_OTP = function(currentTry, maxTry, onTime)
      if onTime == true and currentTry > 1 then
        local function DialogNoticeHandler(dlg)
          dlg:SetTitle(locale.login.error_title_otp)
          dlg:SetContent(locale.login.GetErrorContentOtp(currentTry - 1, maxTry))
          dlg:SetWindowModal(true)
          otpPcCertWnd:Clear()
          function dlg:OkProc()
            otpPcCertWnd:SetOtpMode()
            dlg:Show(false)
          end
        end
        X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
      else
        idPassWnd:Show(false)
        arsCertWnd:Show(false)
        otpPcCertWnd:SetOtpMode()
        otpPcCertWnd:Show(true)
        secureCardWnd:Show(false)
      end
    end,
    OPEN_ARS = function(number, timeout)
      idPassWnd:Show(false)
      otpPcCertWnd:Show(false)
      arsCertWnd:SetInfo(number, timeout)
      arsCertWnd:Show(true)
      secureCardWnd:Show(false)
    end,
    OPEN_PCCERT = function(currentTry, maxTry, onTime)
      if onTime == true and currentTry > 1 then
        local function DialogNoticeHandler(dlg)
          dlg:SetTitle(locale.login.error_title_pc_cert)
          dlg:SetContent(locale.login.GetErrorContentPcCert(currentTry - 1, maxTry))
          dlg:SetWindowModal(true)
          otpPcCertWnd:Clear()
          function dlg:OkProc()
            otpPcCertWnd:SetPcCertMode()
            dlg:Show(false)
          end
        end
        X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
      else
        idPassWnd:Show(false)
        arsCertWnd:Show(false)
        otpPcCertWnd:SetPcCertMode()
        otpPcCertWnd:Show(true)
        secureCardWnd:Show(false)
      end
    end,
    OPEN_SECURE_CARD = function(secureCardIndex, currentTry, onTime)
      if onTime == true and currentTry > 0 then
        local function DialogNoticeHandler(dlg)
          dlg.textbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
          dlg.textbox:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
          dlg.textboxToButton = 17
          dlg:SetTitle(locale.login.error_title_secure_card)
          dlg:SetContent(locale.login.GetErrorContentSecureCard(FONT_COLOR_HEX.RED))
          dlg:SetWindowModal(true)
          secureCardWnd:Clear()
          function dlg:OkProc()
            secureCardWnd:SetInfo(secureCardIndex)
            dlg:Show(false)
          end
        end
        X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
      else
        idPassWnd:Show(false)
        arsCertWnd:Show(false)
        otpPcCertWnd:Show(false)
        secureCardWnd:SetInfo(secureCardIndex)
        secureCardWnd:Show(true)
      end
    end,
    LOGIN_DENIED = function()
      idPassWnd:Show(not connectLocale.loginHide, FADE_DELAY)
      arsCertWnd:Show(false)
      otpPcCertWnd:Show(false)
      secureCardWnd:Show(false)
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    eventHandler[event](...)
  end)
  RegistUIEvent(wnd, eventHandler)
  return wnd
end
