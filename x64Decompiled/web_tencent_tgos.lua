if X2Util:GetGameProvider() == TENCENT then
  do
    local tgosWindow
    local WIDTH = 680
    local HEIGHT = 560
    local BROWSER_WIDTH = 640
    local BROWSER_HEIGHT = 448
    function ClearWebHelp()
      tgosWindow = nil
    end
    local function CreateTGOSWindow(id, parent)
      local window = CreateWindow(id, parent)
      window:ApplyUIScale(false)
      window:SetExtent(WIDTH, HEIGHT)
      window:AddAnchor("CENTER", "UIParent", 0, 0)
      window:Clickable(true)
      window:Show(false)
      window:SetSounds("web_play_diary")
      window.titleBar:SetHeight(85)
      window.titleBar.image = window.titleBar:CreateDrawable(TEXTURE_PATH.TGOS_TITLE, "text", "background")
      window.titleBar.image:AddAnchor("CENTER", window.titleBar, 0, 0)
      window.titleBar.image:Show(true)
      local webBrowser = window:CreateChildWidget("webview", "webBrowser", 0, true)
      window.webBrowser:SetExtent(BROWSER_WIDTH, BROWSER_HEIGHT)
      window.webBrowser:RemoveAllAnchors()
      window.webBrowser:AddAnchor("TOP", window, 0, 85)
      function window:SetFocusHandler()
        function webBrowser:OnEnter()
          webBrowser:SetFocus()
        end
        webBrowser:SetHandler("OnEnter", webBrowser.OnEnter)
        function webBrowser:OnLeave()
          webBrowser:ClearFocus()
        end
        webBrowser:SetHandler("OnLeave", webBrowser.OnLeave)
      end
      window.clearProc = ClearWebHelp
      return window
    end
    function OnToggleTencentTGOS(arg)
      if X2:IsWebEnable() and X2Player:GetFeatureSet().useTGOS then
        if tgosWindow == nil then
          tgosWindow = CreateTGOSWindow("tgosWindow", "UIParent")
        end
        if arg == nil then
          tgosWindow:Show(not tgosWindow:IsVisible())
        else
          tgosWindow:Show(arg)
        end
        if tgosWindow then
          tgosWindow.webBrowser:RequestTGOS(1)
        end
      end
    end
    ADDON:RegisterContentTriggerFunc(UIC_TGOS, OnToggleTencentTGOS)
    function ForcePopupTGOS()
      if X2Player:GetFeatureSet().forcePopupTGOS then
        OnToggleTencentTGOS(true)
      end
    end
    UIParent:SetEventHandler("ENTERED_WORLD", ForcePopupTGOS)
  end
end
