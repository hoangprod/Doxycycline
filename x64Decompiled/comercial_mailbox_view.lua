local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function SetViewOfComercialMailFrame(id, parent)
  local window = CreateWindow(id, parent, "commercial_mail")
  window:SetExtent(430, 505)
  window:AddAnchor("LEFT", "UIParent", 25, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "commercial_mail"))
  window:SetSounds("mail")
  local guide = W_ICON.CreateGuideIconWidget(window)
  window.guide = guide
  local modalLoadingWindow = CreateLoadingTextureSet(window)
  modalLoadingWindow:AddAnchor("TOPLEFT", window, 2, titleMargin)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", window, -3, bottomMargin + 65)
  CreateGoodsMailFrame(window)
  guide:AddAnchor("TOPRIGHT", window.goodMailList, 12, 9)
  return window
end
