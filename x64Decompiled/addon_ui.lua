local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateAddonFrame()
  local frame = CreateWindow("addonFrame", "UIParent")
  frame:Show(false)
  frame:SetExtent(430, 615)
  frame:SetCloseOnEscape(true)
  frame:AddAnchor("CENTER", 0, 0)
  frame:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "addon_option_tite"))
  frame:SetSounds("option")
  function frame.titleBar.closeButton:OnClick()
    if frame:IsVisible() then
      ToggleAddonFrame(false)
    end
  end
  frame.titleBar.closeButton:SetHandler("OnClick", frame.titleBar.closeButton.OnClick)
  local infos = {
    leftButtonStr = GetUIText(PORTAL_TEXT, "apply"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(frame, infos)
  local buttonTable = {okButton, cancelButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local addonList = CreateScrollWindow(frame, "addonList", 0)
  addonList:RemoveAllAnchors()
  addonList:AddAnchor("TOPLEFT", frame, sideMargin, titleMargin)
  addonList:AddAnchor("BOTTOMRIGHT", frame, -sideMargin, bottomMargin)
  local addonInfos = ADDON:GetAddonInfos()
  local height = 0
  addonList.checkButtons = {}
  for i = 1, #addonInfos do
    local checkButton = CreateCheckButton(addonList:GetId() .. ".checkButton[" .. i .. "]", addonList, addonInfos[i].name)
    checkButton:SetChecked(addonInfos[i].enable, false)
    checkButton:SetExtent(30, 30)
    checkButton.textButton.style:SetFontSize(20)
    checkButton.textButton:SetText(addonInfos[i].name)
    addonList.checkButtons[i] = checkButton
    if i == 1 then
      checkButton:AddAnchor("TOPLEFT", addonList, 0, 0)
    else
      checkButton:AddAnchor("TOPLEFT", addonList.checkButtons[i - 1], "BOTTOMLEFT", 0, 0)
    end
    height = height + checkButton:GetHeight()
  end
  addonList:ResetScroll(height)
  local RightButtonLeftClickFunc = function()
    ToggleAddonFrame(false)
  end
  ButtonOnClickHandler(frame.rightButton, RightButtonLeftClickFunc)
  local function LeftButtonLeftClickFunc()
    ToggleAddonFrame(false)
    local addonInfos = ADDON:GetAddonInfos()
    for i = 1, #addonList.checkButtons do
      local checked = addonList.checkButtons[i]:GetChecked()
      ADDON:SetAddonEnable(addonInfos[i].name, checked)
    end
    ADDON:SaveAddonInfos()
  end
  ButtonOnClickHandler(frame.leftButton, leftButtonLeftClickFunc)
  return frame
end
local addonFrame
function ToggleAddonFrame()
  if addonFrame == nil then
    addonFrame = CreateAddonFrame()
  end
  addonFrame:Show(not addonFrame:IsVisible())
end
