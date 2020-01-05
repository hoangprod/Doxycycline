function SetViewOfSquadRecruit(id, parent)
  local wnd = CreateWindow(id, "UIParent")
  wnd:SetExtent(510, 289)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetCommonText("squad_recruit_title"))
  wnd:Show(true)
  local openTypeLabel = wnd:CreateChildWidget("label", "openTypeLabel", 0, true)
  openTypeLabel:AddAnchor("TOPLEFT", wnd, "TOPLEFT", 25, 67)
  openTypeLabel:SetHeight(FONT_SIZE.MIDDLE)
  openTypeLabel.style:SetAlign(ALIGN_LEFT)
  openTypeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(openTypeLabel, FONT_COLOR.DEFAULT)
  openTypeLabel:SetText(GetCommonText("squad_open_type"))
  local radioData = {
    {
      text = GetCommonText("squad_open_type_public"),
      value = 1
    },
    {
      text = GetCommonText("squad_open_type_private"),
      value = 2
    }
  }
  local openTypeRadioBoxes = CreateRadioGroup("openTypeRadioBoxes", wnd, "horizen")
  openTypeRadioBoxes:SetData(radioData)
  openTypeRadioBoxes:AddAnchor("LEFT", openTypeLabel, "RIGHT", 155, 0)
  openTypeRadioBoxes:Check(1)
  wnd.openTypeRadioBoxes = openTypeRadioBoxes
  local partyInvitationCheckBox = CreateCheckButton("partyInvitationCheckBox", wnd, "")
  partyInvitationCheckBox:AddAnchor("TOPLEFT", openTypeLabel, "BOTTOMLEFT", 0, 15)
  wnd.partyInvitationCheckBox = partyInvitationCheckBox
  local partyInvitationLabel = wnd:CreateChildWidget("label", "partyInvitationLabel", 0, true)
  partyInvitationLabel:AddAnchor("LEFT", partyInvitationCheckBox, "RIGHT", 1, 0)
  partyInvitationLabel:SetHeight(FONT_SIZE.MIDDLE)
  partyInvitationLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(partyInvitationLabel, FONT_COLOR.DEFAULT)
  partyInvitationLabel:SetText(GetCommonText("squad_recruit_create_and_party_invitation"))
  local explanationLabel = wnd:CreateChildWidget("label", "explanationLabel ", 0, true)
  explanationLabel:SetAutoResize(true)
  explanationLabel:SetHeight(FONT_SIZE.LARGE)
  explanationLabel.style:SetAlign(ALIGN_LEFT)
  explanationLabel.style:SetFontSize(FONT_SIZE.LARGE)
  explanationLabel:AddAnchor("TOPLEFT", partyInvitationCheckBox, "BOTTOMLEFT", 0, 27)
  explanationLabel:SetText(GetCommonText("squad_explanation"))
  ApplyTextColor(explanationLabel, FONT_COLOR.DEFAULT)
  local explanationEdit = W_CTRL.CreateMultiLineEdit("explanationEdit", wnd)
  explanationEdit:SetExtent(wnd:GetWidth() - 35, 59)
  explanationEdit:SetInset(10, 10, 15, 10)
  explanationEdit.textLength = 50
  explanationEdit:SetMaxTextLength(explanationEdit.textLength)
  explanationEdit:AddAnchor("TOPLEFT", explanationLabel, "BOTTOMLEFT", -7, 5)
  ApplyTextColor(explanationEdit, FONT_COLOR.DEFAULT)
  wnd.explanationEdit = explanationEdit
  local explanationTextLenth = wnd:CreateChildWidget("label", "explanationTextLenth", 0, true)
  explanationTextLenth:SetHeight(FONT_SIZE.MIDDLE)
  explanationTextLenth:SetAutoResize(true)
  explanationTextLenth.style:SetAlign(ALIGN_RIGHT)
  explanationTextLenth.style:SetFontSize(FONT_SIZE.MIDDLE)
  explanationTextLenth:AddAnchor("BOTTOMRIGHT", explanationEdit, "TOPRIGHT", -4, -2)
  ApplyTextColor(explanationTextLenth, FONT_COLOR.DEFAULT)
  local registerButton = wnd:CreateChildWidget("button", "registerButton", 0, true)
  registerButton:SetText(GetCommonText("register"))
  ApplyButtonSkin(registerButton, BUTTON_BASIC.DEFAULT)
  registerButton:AddAnchor("BOTTOMLEFT", wnd, "BOTTOMLEFT", wnd:GetWidth() / 2 - registerButton:GetWidth(), -20)
  local cancelButton = wnd:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:SetText(GetCommonText("cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOMLEFT", registerButton, "BOTTOMRIGHT", 0, 0)
  return wnd
end
