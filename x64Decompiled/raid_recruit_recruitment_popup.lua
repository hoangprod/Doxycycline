local wnd
function ShowRaidRecruitment(parent)
  if nil == wnd then
    wnd = SetViewOfRaidRecruitment("raidRecruitment", parent)
    wnd:Show(false)
    do
      local function FillSubType(type)
        local subTypeList = X2Team:GetRaidRecruitSubTypeList({type}, true)
        local subDatas = {}
        for i = 1, #subTypeList do
          local data = {
            text = subTypeList[i].name,
            value = subTypeList[i].subType
          }
          table.insert(subDatas, data)
        end
        wnd.subTypeComboBox:Clear()
        wnd.subTypeComboBox:AppendItems(subDatas)
      end
      function wnd:OnShow()
        wnd.typeComboBox:Select(1)
        wnd.timeComboBox:Select(1)
        wnd.headcountComboBox:Select(1)
        wnd.joinRadioBoxes:Enable(true)
        wnd.joinRadioBoxes:Check(1, false)
        if X2Team:IsRaidTeam() == true then
          local IsTeamOwner = X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex())
          if IsTeamOwner == false then
            wnd.joinRadioBoxes:Enable(false)
            wnd.joinRadioBoxes:Check(2, false)
          end
        end
        wnd.guideEdit:SetText("")
        wnd.registerButton:Enable(not X2Team:IsSiegeRaidTeam())
      end
      wnd:SetHandler("OnShow", wnd.OnShow)
      function wnd.typeComboBox:SelectedProc(index)
        local info = self:GetSelectedInfo()
        if info == nil then
          return
        end
        FillSubType(info.value)
        local RECRUIT_TYPE_ICON = GetRecruitTypeIconList()
        wnd.typeIcon:SetTextureInfo("icon_" .. RECRUIT_TYPE_ICON[index])
      end
      function wnd.subTypeComboBox:SelectedProc(index)
        local typeInfo = wnd.typeComboBox:GetSelectedInfo()
        local subInfo = self:GetSelectedInfo()
        local info = X2Team:GetRaidRecruitSubType(typeInfo.value, subInfo.value)
        if info == nil then
          return
        end
        wnd.descriptionTextbox:SetText(info.comment)
        local levelList = X2Team:GetRaidRecruitLimitLevelList()
        local levelDatas = {}
        for i = 1, #levelList do
          local current = levelList[i]
          if current >= info.level then
            local data = {value = current}
            if IsHeirLevel(current) then
              local heirLevel = current - X2Player:GetMinHeirLevel()
              data.text = GetCommonText("heir_level_with_value", heirLevel)
            else
              data.text = GetCommonText("level_with_value", current)
            end
            table.insert(levelDatas, data)
          end
        end
        wnd.levelComboBox:Clear()
        wnd.levelComboBox:AppendItems(levelDatas)
      end
      function wnd.timeComboBox:SelectedProc(index)
        local time = wnd.timeMap[index]
        local expense, useHour = X2Team:GetRaidRecruitExpense(time.hour, time.minute)
        wnd.expense:Show(expense ~= 0)
        wnd.expenseLabel:Show(expense ~= 0)
        local data = {
          type = "cost",
          showTitle = false,
          showBg = false,
          valueAlign = ALIGN_LEFT,
          value = expense
        }
        wnd.expense:SetData(data)
      end
      function wnd.headcountComboBox:SelectedProc(index)
        local memberCount = X2Team:CountTeamMembers(X2Team:GetMyTeamJointOrder())
        if memberCount == 0 or false == X2Team:IsRaidTeam() or false == X2Team:IsTeamOwner(X2Team:GetMyTeamJointOrder(), X2Team:GetTeamPlayerIndex()) then
          memberCount = 1
        end
        wnd.raidMemberCountLabel:SetText(string.format("%d / ", memberCount))
        if X2Team:IsSiegeRaidTeam() then
          wnd.registerButton:Enable(false)
        else
          local info = self:GetSelectedInfo()
          wnd.registerButton:Enable(memberCount < info.value)
        end
      end
      function wnd.guideEdit:OnTextChanged()
        wnd.guideTextLenth:SetText(string.format("%d/%d", self:GetTextLength(), self:MaxTextLength()))
      end
      wnd.guideEdit:SetHandler("OnTextChanged", wnd.guideEdit.OnTextChanged)
      function RegisterButtonClick()
        local recruitType = wnd.typeComboBox:GetSelectedInfo().value
        local recruitSubType = wnd.subTypeComboBox:GetSelectedInfo().value
        local headcount = wnd.headcountComboBox:GetSelectedInfo().value
        local limitLevel = wnd.levelComboBox:GetSelectedInfo().value
        local time = wnd.timeMap[wnd.timeComboBox:GetSelectedIndex()]
        local auto = false
        if wnd.joinRadioBoxes:GetChecked() == 1 then
          auto = true
        end
        X2Team:RaidRecruitAdd(recruitType, recruitSubType, headcount, limitLevel, auto, wnd.guideEdit:GetText(), time.hour, time.minute)
        wnd:Show(false)
      end
      wnd.registerButton:SetHandler("OnClick", RegisterButtonClick)
      function CancelButtonClick()
        wnd:Show(false)
      end
      wnd.cancelButton:SetHandler("OnClick", CancelButtonClick)
    end
  end
  wnd:Show(true)
  return wnd
end
