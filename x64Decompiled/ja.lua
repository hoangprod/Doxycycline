if X2Util:GetGameProvider() == GAMEON then
  function webbrowserLocale.OnToggleEventWindow(eventWindow, url)
    if X2:IsWebEnable() and localeView.useWebContent and url ~= nil then
      if eventWindow == nil then
        eventWindow = CreateEventWindow("promotion_eventWindow", "UIParent")
        eventWindow.webBrowser:SetURL(url)
        eventWindow:Show(true)
      elseif eventWindow:IsVisible() then
        eventWindow:Show(false)
      end
    end
  end
end
