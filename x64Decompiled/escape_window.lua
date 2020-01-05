local escapeWindow
local function CreateEscapeWindow()
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow("escapeWindow", "UIParent")
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetWindowModal(true)
  window:SetExtent(POPUP_WINDOW_WIDTH, 170)
  window:SetTitle(locale.escape.title)
  local content = window:CreateChildWidget("textbox", "content", 0, true)
  content:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 30)
  content:AddAnchor("TOP", window, 0, titleMargin + sideMargin / 2)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local cancelButton = window:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:SetText(locale.keyBinding.gameExit.cancel)
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOM", window, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local OnClick = function()
    X2:CancelEscape()
  end
  cancelButton:SetHandler("OnClick", OnClick)
  function window:OnClose()
    X2:CancelEscape()
  end
  local OnCloseByEsc = function()
    X2:CancelEscape()
  end
  window:SetHandler("OnCloseByEsc", OnCloseByEsc)
  function window:Init(waitTime)
    self.showTime = 0
    self.maxTime = waitTime * 1000
    window:SetHandler("OnUpdate", window.OnUpdate)
  end
  function window:OnUpdate(dt)
    self.showTime = self.showTime + dt
    local curTime = self.showTime / 1000
    curTime = self.maxTime - self.showTime
    if curTime < 0 then
      curTime = 0
    end
    self.content:SetText(locale.escape.content(math.floor(curTime / 1000)))
    self.content:SetHeight(self.content:GetTextHeight())
    if curTime == 0 then
      self:ReleaseHandler("OnUpdate")
    end
  end
  local function OnHide()
    escapeWindow = nil
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
function ShowEscapeWindow(show)
  if show and escapeWindow == nil then
    escapeWindow = CreateEscapeWindow()
    escapeWindow:EnableHidingIsRemove(true)
    do
      local events = {
        ESCAPE_END = function()
          ShowEscapeWindow(false)
        end
      }
      escapeWindow:SetHandler("OnEvent", function(this, event, ...)
        events[event](...)
      end)
      RegistUIEvent(escapeWindow, events)
    end
  end
  if escapeWindow ~= nil then
    escapeWindow:Show(show)
  end
end
local function EscapeStart(waitTime)
  if waitTime ~= nil then
    ShowEscapeWindow(true)
    escapeWindow:Init(waitTime)
  end
end
UIParent:SetEventHandler("ESCAPE_START", EscapeStart)
