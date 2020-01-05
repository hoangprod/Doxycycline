local SHOW_TIME = 30
local WND_WIDTH = 300
local WND_HEIGHT = 50
function CreateSubZoneMsgWindow(id, parent)
  local subZoneMsgWindow = UIParent:CreateWidget("emptywidget", id, parent)
  subZoneMsgWindow:SetExtent(WND_WIDTH, WND_HEIGHT)
  subZoneMsgWindow:AddAnchor("BOTTOM", "UIParent", "BOTTOM", 0, -200)
  local scrollWnd = CreateScrollWindow(subZoneMsgWindow, "scrollWnd", 0)
  scrollWnd:Show(true)
  scrollWnd:Clickable(false)
  scrollWnd.content:Clickable(false)
  scrollWnd:SetExtent(WND_WIDTH, WND_HEIGHT)
  scrollWnd.scroll:Show(false)
  scrollWnd:AddAnchor("CENTER", subZoneMsgWindow, 0, 0)
  subZoneMsgWindow.scrollWnd = scrollWnd
  local message = scrollWnd.content:CreateChildWidget("label", "message", 0, true)
  message:Show(true)
  message:AddAnchor("CENTER", subZoneMsgWindow, 0, -5)
  message.style:SetSnap(true)
  message.style:SetShadow(true)
  message.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  message.style:SetColor(ConvertColor(255), ConvertColor(245), ConvertColor(93), 1)
  message:SetExtent(WND_WIDTH, FONT_SIZE.XXLARGE + 2)
  local bg = CreateContentBackground(scrollWnd.content, "TYPE7", "black")
  bg:SetExtent(100, 57)
  bg:AddAnchor("CENTER", subZoneMsgWindow, 0, 0)
  subZoneMsgWindow.bg = bg
  subZoneMsgWindow.showingTime = 0
  subZoneMsgWindow.zoneName = ""
  return subZoneMsgWindow
end
subZoneMsgWindow = CreateSubZoneMsgWindow("subZoneMsgWindow", "UIParent")
subZoneMsgWindow:Show(false)
subZoneMsgWindow:Clickable(false)
subZoneMsgWindow:SetExtent(UIParent:GetScreenWidth(), WND_HEIGHT)
subZoneMsgWindow:AddAnchor("BOTTOM", "UIParent", "BOTTOM", 0, -200)
local moveDistance = 0
local function Init()
  subZoneMsgWindow.showingTime = 0
  moveDistance = 0
  subZoneMsgWindow.zoneName = ""
  subZoneMsgWindow:ReleaseHandler("OnUpdate")
end
subZoneMsgWindow:SetHandler("OnHide", Init)
function subZoneMsgWindow:OnUpdate(dt)
  local width, _ = self.scrollWnd:GetEffectiveExtent()
  local speed = width / SHOW_TIME
  moveDistance = moveDistance + speed
  local startPosX = -width + moveDistance
  if width - moveDistance < 0 then
    startPosX = 0
    self.scrollWnd.content.message:Show(true, 500)
    self.showingTime = dt + self.showingTime
  end
  self.scrollWnd:AddAnchor("CENTER", self, "CENTER", startPosX, 0)
  if self.showingTime > 2000 then
    self:Show(false, 2000)
    self.scrollWnd.content.message:Show(false, 2000)
  end
end
function ShowZoneEnterMessage(zoneName)
  if zoneName == "" or zoneName == nil then
    return
  end
  if subZoneMsgWindow.zoneName == zoneName then
    return
  end
  Init()
  subZoneMsgWindow.scrollWnd.content.message:Show(false)
  local textWidth = subZoneMsgWindow.scrollWnd.content.message.style:GetTextWidth(zoneName) + 150
  subZoneMsgWindow:SetWidth(textWidth + 50)
  subZoneMsgWindow.scrollWnd:SetWidth(textWidth + 50)
  subZoneMsgWindow.scrollWnd.content.message:SetWidth(textWidth)
  subZoneMsgWindow.scrollWnd.content.message:SetText(zoneName)
  subZoneMsgWindow.bg:SetExtent(textWidth, 50)
  subZoneMsgWindow:Show(true)
  subZoneMsgWindow.zoneName = zoneName
  subZoneMsgWindow:SetHandler("OnUpdate", subZoneMsgWindow.OnUpdate)
  subZoneMsgWindow:Raise()
end
