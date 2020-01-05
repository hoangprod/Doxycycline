local helpWindow
local OFFSET = 84
local TYPE = "NONE"
function ClearWebHelp()
  helpWindow = nil
  TYPE = "NONE"
end
function CreateHelpNotifier(id, parent)
  local widget = UIParent:CreateWidget("emptywidget", id, parent)
  widget:ApplyUIScale(false)
  widget:Show(false)
  local bg = widget:CreateDrawable(TEXTURE_PATH.HUD, "yellow_balloon", "background")
  bg:AddAnchor("TOPLEFT", widget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  local textbox = widget:CreateChildWidget("textbox", "textbox", 0, true)
  textbox:Show(true)
  textbox:SetText(locale.infobar.inquireNotify)
  textbox:SetExtent(105, 30)
  textbox:AddAnchor("TOPLEFT", widget, 13, 8)
  textbox.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(textbox, FONT_COLOR.INQUIRE_NOTIFY)
  local closeButton = widget:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", widget, -3, 3)
  ApplyButtonSkin(closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  widget:SetExtent(textbox:GetWidth() + closeButton:GetWidth(), 55)
  function closeButton:OnClick()
    widget:Show(false)
  end
  closeButton:SetHandler("OnClick", closeButton.OnClick)
  function widget:OnClick()
    OnToggleWebHelp()
    widget:Show(false)
  end
  widget:SetHandler("OnClick", widget.OnClick)
  function widget:OnEvent(event, msgType, _, countStr)
    if event == "SET_UI_MESSAGE" then
      if msgType ~= 1 then
        return
      end
      if countStr ~= nil then
        local count = tonumber(countStr) or 0
        widget:Show(count > 0)
      end
    end
  end
  widget:SetHandler("OnEvent", widget.OnEvent)
  widget:RegisterEvent("SET_UI_MESSAGE")
  return widget
end
local notifier = CreateHelpNotifier("helpNotifier", "UIParent")
notifier:AddAnchor("BOTTOMRIGHT", GetMainMenuBarButton(MAIN_MENU_IDX.SYSTEM), "TOPRIGHT", 0, 0)
local function CreateHelpWindow(id, parent)
  local window = SetViewOfWebbrowserWindow(id, parent, webbrowserLocale.wiki.width, webbrowserLocale.wiki.height, OFFSET)
  window:SetSounds("web_play_diary")
  window.clearProc = ClearWebHelp
  function window:ShowProc()
    notifier:Show(false)
  end
  return window
end
function OnToggleWebHelp(show)
  if not X2:IsWebEnable() or not localeView.useWebContent or not baselibLocale.useWebInquire then
    return
  end
  if show == nil then
    show = helpWindow == nil and true or not helpWindow:IsVisible()
  end
  if show then
    if webbrowserLocale.help.useEmbededWebBrowser then
      if helpWindow == nil then
        helpWindow = CreateHelpWindow("helpWindow", "UIParent")
        X2Player:RequestHelp(helpWindow.webBrowser:GetId())
      end
      helpWindow:Show(show)
    else
      X2Player:RequestHelp("")
    end
  elseif helpWindow ~= nil then
    helpWindow:Show(show)
  end
end
ADDON:RegisterContentTriggerFunc(UIC_WEB_HELP, OnToggleWebHelp)
