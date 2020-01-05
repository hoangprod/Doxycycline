local recruitmentWnd
function ShowRecruitment(id, parent)
  if nil == recruitmentWnd then
    recruitmentWnd = SetViewOfRecruitment(id, parent)
    recruitmentWnd:Show(false)
    function recruitmentWnd:OnShow()
      for i = 1, #self.interestChks do
        self.interestChks[i]:SetChecked(true)
      end
      self.ownerLabel:SetText(X2Faction:GetMyExpeditionOwnerName())
      self.nameLabal:SetText(X2Faction:GetFactionName(X2Faction:GetMyExpeditionId(), false))
      self.levelLabal:SetText(tostring(X2Faction:GetMyExpeditionLevel()))
      self.introduce:SetText("")
      local online, total = X2Faction:GetExpeditionMemberCount()
      self.numberOfPeopleLabel:SetText(tostring(total))
      recruitmentWnd.radioBoxes:Check(1, true)
    end
    recruitmentWnd:SetHandler("OnShow", recruitmentWnd.OnShow)
    local function OnRadioChanged(self, index, dataValue)
      local costs = X2Faction:GetExpeditionRecruitmentPeriodCost()
      local data = {
        type = "cost",
        showBg = false,
        showTitle = false,
        valueAlign = ALIGN_LEFT,
        value = costs[index]
      }
      recruitmentWnd.cost:SetData(data)
    end
    recruitmentWnd.radioBoxes:SetHandler("OnRadioChanged", OnRadioChanged)
    function recruitmentWnd.registerButton:OnClick()
      local value = {}
      local IR = GetInterestList()
      for i = 1, #IR do
        if recruitmentWnd.interestChks[i]:GetChecked() then
          value[i] = 1
        else
          value[i] = 0
        end
      end
      X2Faction:RequestExpeditionRecruitmentAdd(value, recruitmentWnd.radioBoxes:GetCheckedData(), recruitmentWnd.introduce:GetText())
      recruitmentWnd:Show(false)
    end
    recruitmentWnd.registerButton:SetHandler("OnClick", recruitmentWnd.registerButton.OnClick)
    function recruitmentWnd.cancelButton:OnClick()
      recruitmentWnd:Show(false)
    end
    recruitmentWnd.cancelButton:SetHandler("OnClick", recruitmentWnd.cancelButton.OnClick)
    function recruitmentWnd.introduce:OnTextChanged()
      recruitmentWnd.introduceTextLenth:SetText(string.format("%d/%d", self:GetTextLength(), self:MaxTextLength()))
    end
    recruitmentWnd.introduce:SetHandler("OnTextChanged", recruitmentWnd.introduce.OnTextChanged)
  end
  recruitmentWnd:Show(true)
  return recruitmentWnd
end
