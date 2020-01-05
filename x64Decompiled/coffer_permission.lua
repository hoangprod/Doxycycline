local cofferPermissionWindow
local function CreateCofferPermissionWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, 180)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:EnableHidingIsRemove(true)
  local permissionsWindow = window:CreateChildWidget("window", "permissionsWindow", 0, true)
  permissionsWindow:Show(true)
  permissionsWindow:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 60)
  permissionsWindow:SetTitleInset(3, 0, 0, 0)
  permissionsWindow:AddAnchor("TOP", window, 0, titleMargin)
  permissionsWindow:SetTitleText(X2Locale:LocalizeUiText(HOUSING_TEXT, "coffer_permission"))
  permissionsWindow.titleStyle:SetSnap(true)
  permissionsWindow.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  permissionsWindow.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTitleFontColor(permissionsWindow, FONT_COLOR.TITLE)
  local checkBoxes = CreateRadioGroup("radioButton", permissionsWindow, "grid")
  checkBoxes:SetWidth(permissionsWindow:GetWidth())
  checkBoxes:AddAnchor("TOPLEFT", permissionsWindow, 2, 23)
  checkBoxes:SetData(locale.housing.permissions)
  window.checkBoxes = checkBoxes
  local infos = {
    leftButtonStr = GetUIText(PORTAL_TEXT, "apply"),
    rightButtonStr = GetCommonText("cancel")
  }
  CreateWindowDefaultTextButtonSet(window, infos)
  local function ApplyButtonLeftClickFunc()
    X2Coffer:SetHouseCofferPermission(checkBoxes:GetCheckedData())
    window:Show(false)
  end
  ButtonOnClickHandler(window.leftButton, ApplyButtonLeftClickFunc)
  local function CancelButtonLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(window.rightButton, CancelButtonLeftClickFunc)
  function window:ShowProc()
    local permission = X2Coffer:GetHouseCofferPermission() or 1
    local index = checkBoxes:GetIndexByValue(permission)
    self.checkBoxes:Check(index)
    self:SetTitle(X2Coffer:GetHouseCofferName())
  end
  local function OnHide()
    cofferPermissionWindow = nil
  end
  window:SetHandler("OnHide", OnHide)
  local events = {
    INTERACTION_END = function()
      window:Show(false)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local function ShowCofferPermissionWindow(isShow)
  if not X2Coffer:IsMyHouseCoffer() then
    return
  end
  if cofferPermissionWindow == nil then
    if isShow then
      cofferPermissionWindow = CreateCofferPermissionWindow("cofferPermissionWindow", "UIParent")
      cofferPermissionWindow:Show(true)
    else
      return
    end
  elseif isShow then
    cofferPermissionWindow:Show(true)
  else
    cofferPermissionWindow:Show(false)
  end
end
local function CofferInteractionStart()
  ShowCofferPermissionWindow(true)
end
UIParent:SetEventHandler("COFFER_INTERACTION_START", CofferInteractionStart)
