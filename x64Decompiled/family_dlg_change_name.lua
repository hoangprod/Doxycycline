local wnd
function ShowFamilyDlgChangeName(familyName)
  if wnd == nil then
    wnd = SetViewOfFamilyDlgChangeName("familyDlgChangeNameWnd", "UIParent")
  end
  wnd.name:SetText(familyName)
  wnd.okButton:Enable(false)
  function wnd:ShowProc()
    local itemInfo = X2Family:GetChangeNameItem()
    self.itemBtn:SetItemInfo(itemInfo)
    self.itemBtn:SetStack(itemInfo.haveItemCount, itemInfo.useItemCount)
    self.itemTextbox:SetText(itemInfo.name)
    self.inputNameEdit:SetText("")
    self.inputNameEdit:Enable(true)
    if X2Family:GetChangeNameTime() ~= 0 or itemInfo.haveItemCount < itemInfo.useItemCount then
      self.inputNameEdit:Enable(false)
    end
  end
  function OnUpdate(dt)
    local remain = X2Family:GetChangeNameTime()
    if remain == 0 then
      wnd.rejoinWaiting:SetText("")
    else
      wnd.rejoinWaiting:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "family_name_change_waiting", tostring(MakeTimeString(remain))))
    end
  end
  wnd.rejoinWaiting:SetHandler("OnUpdate", OnUpdate)
  function OnInputNameChanged()
    local enable = X2Util:IsValidName(wnd.inputNameEdit:GetText(), VNT_FAMILY)
    wnd.okButton:Enable(enable)
  end
  wnd.inputNameEdit:SetHandler("OnTextChanged", OnInputNameChanged)
  function okButton()
    X2Family:OpenChangeName(wnd.inputNameEdit:GetText())
    wnd:Show(false)
  end
  wnd.okButton:SetHandler("OnClick", okButton)
  function cancelButton()
    wnd:Show(false)
  end
  wnd.cancelButton:SetHandler("OnClick", cancelButton)
  local show = true
  if wnd:IsVisible() then
    show = false
  end
  wnd:Show(show)
  return wnd
end
