function CreateAuthMessageWindow(id, parent)
  local authMessage = parent:CreateChildWidget("textbox", id, 0, true)
  authMessage:Show(false)
  authMessage:SetWidth(370)
  authMessage:SetInset(0, 0, 0, 0)
  authMessage.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  authMessage.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(authMessage, F_COLOR.GetColor("customizing_df", false))
  local bg = authMessage:CreateDrawable(TEXTURE_PATH.DEFAULT_NEW, "bg", "background")
  bg:SetTextureColor("black")
  bg:AddAnchor("TOPLEFT", authMessage, -20, -5)
  bg:AddAnchor("BOTTOMRIGHT", authMessage, 20, 5)
  local fadeInTime = 1000
  local fadeOutTime = 1000
  function authMessage:Clear()
    authMessage:Show(false)
  end
  function authMessage:SetMessage(msg, remainTime)
    authMessage:SetText(msg)
    authMessage:SetHeight(authMessage:GetTextHeight() + 10)
    if remainTime > 0 then
      authMessage:Show(true, fadeInTime)
      authMessage:Raise()
    else
      authMessage:Show(false, fadeOutTime)
    end
  end
  local evnets = {
    NOTIFY_AUTH_FATIGUE_MESSAGE = function(msg, remainTime)
      authMessage:SetMessage(msg, remainTime)
    end,
    NOTIFY_AUTH_BILLING_MESSAGE = function(msg, remainTime)
      authMessage:SetMessage(msg, remainTime)
    end,
    NOTIFY_AUTH_ADVERTISING_MESSAGE = function(msg, remainTime)
      authMessage:SetMessage(msg, remainTime)
    end,
    NOTIFY_AUTH_NOTICE_MESSAGE = function(msg, remainTime, needCountdown)
      if not needCountdown then
        authMessage:SetMessage(msg, remainTime)
      end
    end,
    NOTIFY_AUTH_DISCONNECTION_MESSAGE = function(msg, remainTime)
      if remainTime <= 0 then
        return
      end
      function DisconnectDialogHandler(wnd, infoTable)
        function wnd:OkProc()
          X2World:LeaveWorld(EXIT_CLIENT)
        end
        wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "error_message"))
        wnd:SetContent(msg)
      end
      X2DialogManager:RequestNoticeDialog(DisconnectDialogHandler, "")
    end
  }
  authMessage:SetHandler("OnEvent", function(this, event, ...)
    evnets[event](...)
  end)
  RegistUIEvent(authMessage, evnets)
  return authMessage
end
