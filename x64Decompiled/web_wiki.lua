local wikiWindow
local OFFSET = 84
local TYPE = "NONE"
function ClearWebWiki()
  wikiWindow = nil
  TYPE = "NONE"
end
local function CreateWikiWindow(id, parent)
  local window = SetViewOfWebbrowserWindow(id, parent, webbrowserLocale.wiki.width, webbrowserLocale.wiki.height, OFFSET)
  window:SetSounds("web_wiki")
  window.clearProc = ClearWebWiki
  return window
end
function OnToggleWebWiki(show)
  if not X2:IsWebEnable() or not baselibLocale.useWebWiki then
    return
  end
  if show == nil then
    show = wikiWindow == nil and true or not wikiWindow:IsVisible()
  end
  if wikiWindow == nil then
    wikiWindow = CreateWikiWindow("wikiWindow", "UIParent")
    TYPE = "NONE"
  end
  if TYPE ~= "WIKI" then
    wikiWindow.webBrowser:RequestWiki()
  end
  wikiWindow:Show(show)
end
ADDON:RegisterContentTriggerFunc(UIC_WEB_WIKI, OnToggleWebWiki)
