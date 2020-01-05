local RP = GetRolePolicyList()
local function CanChangePolicy(myPolicy, otherPolicy)
  if myPolicy[RP.SET_POLICY] == true and myPolicy[RP.ROLE] > otherPolicy[RP.ROLE] then
    return true
  end
  return false
end
function CreateRolePolicy(id, wnd)
  SetViewOfRolePolicy(id, wnd)
  local innerWnd = wnd.innerWnd
  function wnd:OnChangePolicy()
    local rolePolicies = GetRolePolicy("all")
    table.sort(rolePolicies, function(lhs, rhs)
      return lhs[RP.ROLE] > rhs[RP.ROLE] and true or false
    end)
    local myRolePolicy = GetRolePolicy("my")
    local function ResetChangeRoleName(editable)
      innerWnd.changeRoleName:Show(editable)
      innerWnd.changeComplete:Show(false)
      innerWnd.roleName:Show(true)
      innerWnd.editRoleName:Show(false)
      innerWnd.editRoleName:SetText("")
    end
    local function SetSeletedRoleButton(index)
      for i = 1, #rolePolicies do
        if i == index then
          SetBGHighlighted_table(wnd.roles[i], true, ROLE_BUTTON_STYLE_TABLE[i])
        else
          SetBGHighlighted_table(wnd.roles[i], false, ROLE_BUTTON_STYLE_TABLE[i])
        end
      end
    end
    local function SetRoleInfo(btn, roleId, roleName, count)
      function btn:OnClick(arg)
        if arg == "LeftButton" then
          local rolePolicy = GetRolePolicy(roleId)
          SetSeletedRoleButton(count)
          innerWnd.roleName:SetText(roleName)
          innerWnd.roleIcon:SetRoleIcon(roleId)
          for i = 1, #innerWnd.chks do
            if rolePolicy[RP.NAME + i] ~= nil then
              innerWnd.chks[i]:SetChecked(rolePolicy[RP.NAME + i])
            end
          end
          local editable = CanChangePolicy(myRolePolicy, rolePolicy)
          for i = 1, #innerWnd.chks do
            innerWnd.chks[i]:SetEnableCheckButton(editable)
            innerWnd.chks[i]:SetButtonStyle("normal")
          end
          btn.rolePolicy = rolePolicy
          wnd.curRoleBtn = btn
          if editable then
            innerWnd.titleStyle:SetColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], 1)
          else
            innerWnd.titleStyle:SetColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], 0.5)
          end
          innerWnd.applyButton:Show(editable)
          innerWnd.cancelButton:Show(editable)
          if myRolePolicy[RP.ROLE] == 255 then
            ResetChangeRoleName(true)
          else
            ResetChangeRoleName(editable)
          end
        end
      end
      btn:SetHandler("OnClick", btn.OnClick)
    end
    for i = 1, #rolePolicies do
      SetRoleInfo(wnd.roles[i], rolePolicies[i][RP.ROLE], rolePolicies[i][RP.NAME], i)
    end
    function innerWnd.applyButton:OnClick(arg)
      if arg == "LeftButton" then
        local policy = {}
        for i = 1, RP.MAX - 1 do
          policy[i] = wnd.curRoleBtn.rolePolicy[i]
        end
        for i = 1, #innerWnd.chks do
          policy[RP.NAME + i] = innerWnd.chks[i]:GetChecked()
        end
        X2Faction:ChangeExpeditionRolePolicy(policy)
      end
    end
    innerWnd.applyButton:SetHandler("OnClick", innerWnd.applyButton.OnClick)
    function innerWnd.cancelButton:OnClick(arg)
      if arg == "LeftButton" then
        wnd.curRoleBtn:OnClick("LeftButton")
      end
    end
    innerWnd.cancelButton:SetHandler("OnClick", innerWnd.cancelButton.OnClick)
    local function DelegateButtonLeftClickFunc()
      ShowExpeditionDelegate(wnd)
    end
    ButtonOnClickHandler(innerWnd.delegateButton, DelegateButtonLeftClickFunc)
    function innerWnd.dismissButton:OnClick(arg)
      if arg == "LeftButton" then
        X2Faction:DismissExpedition()
        ResetChangeRoleName(true)
      end
    end
    innerWnd.dismissButton:SetHandler("OnClick", innerWnd.dismissButton.OnClick)
    function innerWnd.leaveButton:OnClick(arg)
      if arg == "LeftButton" then
        X2Faction:LeaveExpedition()
      end
    end
    innerWnd.leaveButton:SetHandler("OnClick", innerWnd.leaveButton.OnClick)
    local owner = myRolePolicy[RP.ROLE] == 255 and true or false
    innerWnd.delegateButton:Show(owner)
    innerWnd.dismissButton:Show(owner)
    innerWnd.leaveButton:Show(not owner)
    if wnd.curRoleBtn == nil then
      wnd.roles[1]:OnClick("LeftButton")
    else
      wnd.curRoleBtn:OnClick("LeftButton")
    end
  end
  function wnd:RefreshTab()
    if X2Faction:IsExpedInfoLoaded() == false then
      return
    end
    self:OnChangePolicy()
  end
  function wnd:SetChangeRoleNameHandler()
    local function SetEditMode(editMode)
      innerWnd.changeComplete:Show(editMode)
      innerWnd.editRoleName:SetText("")
      innerWnd.editRoleName:Show(editMode)
      if editMode == true then
        innerWnd.editRoleName:SetFocus()
      end
      innerWnd.changeRoleName:Show(not editMode)
      innerWnd.roleName:Show(not editMode)
    end
    innerWnd.editRoleName:SetHandler("OnEscapePressed", function()
      SetEditMode(false)
    end)
    local function ChangeExpeditionRoleName(policy, newRoleName)
      if newRoleName ~= "" and newRoleName ~= policy[RP.NAME] then
        policy[RP.NAME] = newRoleName
        X2Faction:ChangeExpeditionRolePolicy(policy)
      end
    end
    function innerWnd.editRoleName:OnEnterPressed(arg)
      ChangeExpeditionRoleName(wnd.curRoleBtn.rolePolicy, innerWnd.editRoleName:GetText())
      SetEditMode(false)
    end
    innerWnd.editRoleName:SetHandler("OnEnterPressed", innerWnd.editRoleName.OnEnterPressed)
    function innerWnd.changeRoleName:OnClick(arg)
      if arg == "LeftButton" then
        SetEditMode(true)
      end
    end
    innerWnd.changeRoleName:SetHandler("OnClick", innerWnd.changeRoleName.OnClick)
    function innerWnd.changeComplete:OnClick(arg)
      if arg == "LeftButton" then
        ChangeExpeditionRoleName(wnd.curRoleBtn.rolePolicy, innerWnd.editRoleName:GetText())
        SetEditMode(false)
      end
    end
    innerWnd.changeComplete:SetHandler("OnClick", innerWnd.changeComplete.OnClick)
  end
  wnd:SetChangeRoleNameHandler()
end
