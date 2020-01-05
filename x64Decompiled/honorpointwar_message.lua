function CreateHonorPointWarWindow(id, parent)
  local mainTextBox = UIParent:CreateWidget("textbox", id, parent)
  mainTextBox:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  mainTextBox.style:SetAlign(ALIGN_BOTTOM)
  mainTextBox.style:SetSnap(true)
  mainTextBox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  ApplyTextColor(mainTextBox, FONT_COLOR.RED)
  local subTextBox = mainTextBox:CreateChildWidget("textbox", "subHonorPointWarWnd", 0, true)
  subTextBox:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  subTextBox.style:SetAlign(ALIGN_TOP)
  subTextBox.style:SetSnap(true)
  subTextBox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(subTextBox, FONT_COLOR.WHITE)
  mainTextBox.subTextBox = subTextBox
  return mainTextBox
end
honorPointWarWnd = CreateHonorPointWarWindow("honorPointWarWnd", systemLayerParent)
honorPointWarWnd:Show(false)
honorPointWarWnd:SetExtent(UIParent:GetScreenWidth(), FONT_SIZE.XLARGE)
honorPointWarWnd:AddAnchor("TOP", "UIParent", "TOP", 0, 80)
local bg = CreateContentBackground(honorPointWarWnd, "TYPE8", "black")
bg:SetVisible(false)
honorPointWarWnd.bg = bg
honorPointWarWnd.subTextBox:SetExtent(UIParent:GetScreenWidth(), FONT_SIZE.LARGE)
honorPointWarWnd.subTextBox:AddAnchor("TOP", honorPointWarWnd, "BOTTOM", 0, 7)
honorPointWarWnd:Show(true)
honorPointWarWnd:Clickable(false)
honorPointWarWnd.subTextBox:Clickable(false)
function honorPointWarWnd:OnUpdate(dt)
  self.showingTime = dt + self.showingTime
  local t = self.showingTime / 3000
  if t > 1 then
    self:Show(false, 2000)
    self:ReleaseHandler("OnUpdate")
  end
end
