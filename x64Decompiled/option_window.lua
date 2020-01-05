local inset = GetWindowMargin("popup")
function CreateRaidOptionFrame(id, parent)
  local w = SetViewOfRaidOptionFrame(id, parent)
  function w:OnShow()
    if X2Team:GetSimpleView() == true then
      self.modeCheckBoxes:Check(2)
    else
      self.modeCheckBoxes:Check(1)
    end
    self.partyVisibleToRaidCheckBox:SetChecked(X2Team:GetPartyFrameVisible(), false)
    self.invisibleRaidFrameCheckBox:SetChecked(X2Team:GetRaidFrameVisible(), false)
    self.refuseInvitationCheckBox:SetChecked(X2Team:GetRefuseAreaInvitation(), false)
  end
  w:SetHandler("OnShow", w.OnShow)
  function w.modeCheckBoxes:OnRadioChanged(index, dataValue)
    local simpleView = true
    if index == 1 then
      simpleView = false
    end
    X2Team:SetSimpleView(simpleView)
  end
  w.modeCheckBoxes:SetHandler("OnRadioChanged", w.modeCheckBoxes.OnRadioChanged)
  function w.partyVisibleToRaidCheckBox:CheckBtnCheckChagnedProc(visible)
    X2Team:SetPartyFrameVisible(visible)
  end
  function w.invisibleRaidFrameCheckBox:CheckBtnCheckChagnedProc(visible)
    X2Team:SetRaidFrameVisible(visible)
    if RaidFrame ~= nil and visible then
      RaidFrame:UpdateAllMembersCombatState()
    end
  end
  function w.refuseInvitationCheckBox:CheckBtnCheckChagnedProc(refuse)
    X2Team:SetRefuseAreaInvitation(refuse)
  end
  return w
end
