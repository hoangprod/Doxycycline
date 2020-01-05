local squadRecruitWnd, selectedInstance
function ShowSquadRecruit(parent, instanceType)
  selectedInstance = instanceType
  if squadRecruitWnd == nil then
    squadRecruitWnd = SetViewOfSquadRecruit("squadRecruitWnd", parent)
  end
  squadRecruitWnd:Show(true)
  squadRecruitWnd:Raise()
  squadRecruitWnd.partyInvitationCheckBox:SetChecked(false)
  function squadRecruitWnd.OnShow()
    squadRecruitWnd.openTypeRadioBoxes:Check(1)
    squadRecruitWnd.explanationEdit:SetText("")
  end
  squadRecruitWnd:SetHandler("OnShow", squadRecruitWnd.OnShow)
  function squadRecruitWnd.explanationEdit:OnTextChanged()
    squadRecruitWnd.explanationTextLenth:SetText(string.format("%d/%d", self:GetTextLength(), self:MaxTextLength()))
  end
  squadRecruitWnd.explanationEdit:SetHandler("OnTextChanged", squadRecruitWnd.explanationEdit.OnTextChanged)
  function RegisterButtonClick()
    X2Squad:CreateSquad(selectedInstance, squadRecruitWnd.openTypeRadioBoxes:GetChecked() - 1, squadRecruitWnd.explanationEdit:GetText(), squadRecruitWnd.partyInvitationCheckBox:GetChecked())
    squadRecruitWnd:Show(false)
  end
  squadRecruitWnd.registerButton:SetHandler("OnClick", RegisterButtonClick)
  function CancelButtonClick()
    squadRecruitWnd:Show(false)
  end
  squadRecruitWnd.cancelButton:SetHandler("OnClick", CancelButtonClick)
  parent.squadRecruitWnd = squadRecruitWnd
end
