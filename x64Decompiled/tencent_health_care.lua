tencentHealthCare = nil
function CreateTencentHealthCareWindow(id, parent, width, height)
  local window = CreateWindow(id, parent)
  window:SetExtent(width, height)
  window:Show(true)
  window:SetTitle(GetCommonText("warring"))
  window:SetCloseOnEscape(true)
  window.titleBar.closeButton:Show(true)
  window:AddAnchor("CENTER", parent, 0, 0)
  local webBrowser = window:CreateChildWidget("webbrowser", "tencentHealthCare", 0, true)
  webBrowser:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
  webBrowser:SetExtent(width - MARGIN.WINDOW_SIDE * 2, height - MARGIN.WINDOW_TITLE - MARGIN.WINDOW_SIDE)
  webBrowser:SetEscEvent(true)
  window.webBrowser = webBrowser
  webBrowser:SetHandler("OnEnter", function()
    webBrowser:SetFocus()
  end)
  webBrowser:SetHandler("OnLeave", function()
    webBrowser:ClearFocus()
  end)
  local events = {
    WEB_BROWSER_ESC_EVENT = function(browser)
      if browser == webBrowser then
        tencentHealthCare:Show(false)
      end
    end
  }
  webBrowser:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  webBrowser:RegisterEvent("WEB_BROWSER_ESC_EVENT")
  function window:OnHide()
    webBrowser:Show(false)
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
function ShowTencentHealthCareWindow(url, width, height)
  ChatLog("url " .. tostring(url) .. " width " .. tostring(width) .. " height " .. tostring(height))
  if tencentHealthCare == nil then
    tencentHealthCare = CreateTencentHealthCareWindow("tencentHealthCare", "UIParent", width, height)
  end
  tencentHealthCare:Show(true)
  tencentHealthCare.webBrowser:Show(true)
  tencentHealthCare.webBrowser:RequestSensitiveOperationVerify(url)
end
UIParent:SetEventHandler("TENCENT_HEALTH_CARE_URL", ShowTencentHealthCareWindow)
