function SetViewOfWebbrowserWindow(id, parent, width, height, offset, heightOffset, webBrowserAnchor)
  if heightOffset == nil then
    heightOffset = 0
  end
  local window = CreateEmptyWindow(id, parent)
  window:ApplyUIScale(false)
  window:SetExtent(width, height + heightOffset)
  window:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
  window:Clickable(true)
  window:Show(false)
  function window:SettingWindowSkin()
    local path = TEXTURE_PATH.DEFAULT
    local width = math.floor(self:GetWidth() + 0.5)
    local upperCoords, lowerCoords_l, lowerCoords_r, anchorValue
    if width == WINDOW_SIZE.SMALL then
      anchorValue = 10
    elseif width == 394 then
      anchorValue = 13
    elseif width == 434 then
      anchorValue = 13
    elseif width == 604 then
      anchorValue = 11
    else
      anchorValue = -20
      X2Util:RaiseLuaCallStack(string.format("invalid width - %d", width))
    end
    if width <= 445 then
      upperCoords = {
        0,
        332,
        445,
        249
      }
      lowerCoords_l = {
        727,
        0,
        221,
        246
      }
      lowerCoords_r = {
        948,
        0,
        -221,
        246
      }
    else
      upperCoords = {
        0,
        0,
        726,
        331
      }
      lowerCoords_l = {
        0,
        582,
        360,
        332
      }
      lowerCoords_r = {
        360,
        582,
        -360,
        332
      }
    end
    if self.upperTexture == nil then
      self.upperTexture = self:CreateImageDrawable(path, "background")
      self.upperTexture:SetCoords(upperCoords[1], upperCoords[2], upperCoords[3], upperCoords[4])
      self.upperTexture:SetHeight(upperCoords[4])
      self.upperTexture:AddAnchor("TOPLEFT", self, -anchorValue, -12)
      self.upperTexture:AddAnchor("TOPRIGHT", self, anchorValue, -12)
    end
    if self.lowerTexture_left == nil then
      self.lowerTexture_left = self:CreateImageDrawable(path, "background")
      self.lowerTexture_left:SetCoords(lowerCoords_l[1], lowerCoords_l[2], lowerCoords_l[3], lowerCoords_l[4])
      self.lowerTexture_left:SetExtent(width / 2 + anchorValue, lowerCoords_l[4])
      self.lowerTexture_left:AddAnchor("BOTTOMLEFT", self, -anchorValue, 12)
    end
    if self.lowerTexture_right == nil then
      self.lowerTexture_right = self:CreateImageDrawable(path, "background")
      self.lowerTexture_right:SetCoords(lowerCoords_r[1], lowerCoords_r[2], lowerCoords_r[3], lowerCoords_r[4])
      self.lowerTexture_right:SetExtent(width / 2 + anchorValue, lowerCoords_r[4])
      self.lowerTexture_right:AddAnchor("BOTTOMRIGHT", self, anchorValue, 12)
    end
    if self.colorTexture == nil then
      self.colorTexture = self:CreateDrawable(path, "modal_bg", "background")
      self.colorTexture:AddAnchor("TOPLEFT", self, -2, 0)
      self.colorTexture:AddAnchor("BOTTOMRIGHT", self, -2, 0)
    end
  end
  local webBrowser = window:CreateChildWidget(baselibLocale.webWidgetName, "webbrowser", 0, true)
  webBrowser:SetExtent(width, height)
  if webBrowserAnchor == nil then
    webBrowserAnchor = "TOP"
  end
  webBrowser:AddAnchor(webBrowserAnchor, window, 0, 0)
  webBrowser:SetEscEvent(true)
  webBrowser:Show(false)
  window.webBrowser = webBrowser
  if offset == nil then
    offset = 0
  end
  local titleBar = CreateTitleBar(id .. ".titleBar", window)
  titleBar:AddAnchor("TOPLEFT", window, offset, 0)
  window.titleBar = titleBar
  window.titleBar.closeButton:RemoveAllAnchors()
  window.titleBar.closeButton:AddAnchor("TOPRIGHT", window.titleBar, 2, -1)
  if baselibLocale.webWidgetName == "webbrowser" then
    local defaultDrawable = webBrowser:CreateColorDrawable(ConvertColor(241), ConvertColor(236), ConvertColor(225), 1, "background")
    defaultDrawable:AddAnchor("TOPLEFT", webBrowser, 0, 0)
    defaultDrawable:AddAnchor("BOTTOMRIGHT", webBrowser, 0, 0)
    defaultDrawable:SetVisible(false)
    webBrowser:SetDefaultDrawable(defaultDrawable)
  end
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
  function window:OnShow()
    self:SettingWindowSkin()
    webBrowser:Show(true)
    if self.ShowProc ~= nil then
      self:ShowProc()
    end
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:OnHide()
    webBrowser:Show(false)
    if window.clearProc ~= nil then
      window.clearProc()
    end
  end
  window:SetHandler("OnHide", window.OnHide)
  local browserEvent = {
    WEB_BROWSER_ESC_EVENT = function(browser)
      if browser == webBrowser then
        window:Show(false)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    browserEvent[event](...)
  end)
  window:RegisterEvent("WEB_BROWSER_ESC_EVENT")
  window:SetCloseOnEscape(true)
  window:EnableHidingIsRemove(true)
  webBrowser:ClearFocus()
  return window
end
