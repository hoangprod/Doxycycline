function SetViewOfRolePolicy(id, wnd)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  wnd.roles = {}
  ROLE_BUTTON_STYLE_TABLE = {
    BUTTON_CONTENTS.EXPEDITION_ROLE_1,
    BUTTON_CONTENTS.EXPEDITION_ROLE_2,
    BUTTON_CONTENTS.EXPEDITION_ROLE_3,
    BUTTON_CONTENTS.EXPEDITION_ROLE_4,
    BUTTON_CONTENTS.EXPEDITION_ROLE_5
  }
  local MAX_ROLE = 5
  for i = 1, MAX_ROLE do
    local roles = wnd:CreateChildWidget("button", "roles", i, true)
    roles:AddAnchor("TOPLEFT", wnd, 0, sideMargin + (i - 1) * 60)
    ApplyButtonSkinTable(roles, ROLE_BUTTON_STYLE_TABLE[i])
  end
  local innerWnd = wnd:CreateChildWidget("window", "innerWnd", 0, true)
  innerWnd:Show(true)
  innerWnd:AddAnchor("TOPLEFT", wnd, sideMargin * 5.5, sideMargin)
  innerWnd:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  CreateRoleIconDrawable(innerWnd)
  innerWnd.roleIcon:SetExtent(40, 40)
  local innerBg = wnd:CreateDrawable(TEXTURE_PATH.EXPEDITION_AUTHORITY, "bg", "background")
  innerBg:AddAnchor("BOTTOMRIGHT", wnd, -44, -29)
  local roleName = innerWnd:CreateChildWidget("label", "roleName", 0, true)
  roleName:SetHeight(40)
  roleName:SetAutoResize(true)
  roleName:AddAnchor("LEFT", innerWnd.roleIcon, "RIGHT", 3, 0)
  roleName.style:SetAlign(ALIGN_LEFT)
  roleName.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(roleName, FONT_COLOR.TITLE)
  local underLine_1 = innerWnd:CreateDrawable("ui/common/tab_list.dds", "underline_1", "artwork")
  underLine_1:SetExtent(200, 3)
  underLine_1:AddAnchor("TOPLEFT", innerWnd, 0, 40)
  local underLine_2 = innerWnd:CreateDrawable("ui/common/tab_list.dds", "underline_2", "artwork")
  underLine_2:SetExtent(200, 3)
  underLine_2:AddAnchor("LEFT", underLine_1, "RIGHT", 0, 0)
  local editRoleName = W_CTRL.CreateEdit("editRoleName", innerWnd)
  editRoleName:Show(false)
  editRoleName:SetExtent(350, 35)
  editRoleName:SetMaxTextLength(12)
  editRoleName:AddAnchor("LEFT", innerWnd.roleIcon, "RIGHT", 3, 0)
  editRoleName.style:SetFontSize(FONT_SIZE.XLARGE)
  local changeRoleName = innerWnd:CreateChildWidget("button", "changeRoleName", 0, true)
  changeRoleName:Show(false)
  changeRoleName:AddAnchor("TOPRIGHT", innerWnd, 0, 0)
  changeRoleName:SetText(locale.expedition.changeName)
  ApplyButtonSkin(changeRoleName, BUTTON_BASIC.DEFAULT)
  local changeComplete = innerWnd:CreateChildWidget("button", "changeComplete", 0, true)
  changeComplete:Show(false)
  changeComplete:AddAnchor("TOPRIGHT", innerWnd, 0, 0)
  changeComplete:SetText(locale.expedition.changeComplete)
  ApplyButtonSkin(changeComplete, BUTTON_BASIC.DEFAULT)
  innerWnd:SetTitleText(locale.expedition.changeRole)
  innerWnd:SetTitleInset(10, 55, 0, 0)
  innerWnd.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  innerWnd.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  innerWnd.titleStyle:SetColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], 1)
  local rolePolicyTexts = {
    locale.expedition.inviteMember,
    locale.expedition.expel,
    locale.expedition.promote
  }
  innerWnd.chks = {}
  for i = 1, #rolePolicyTexts do
    local chk = CreateCheckButton(string.format("%s.chks[%d]", id, i), wnd, rolePolicyTexts[i])
    chk:AddAnchor("TOPLEFT", innerWnd, 15, (i - 1) * 25 + 80)
    innerWnd.chks[i] = chk
  end
  local cancelButton = innerWnd:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:Show(false)
  cancelButton:SetText(locale.common.cancel)
  cancelButton:AddAnchor("BOTTOMRIGHT", innerWnd, 0, 0)
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  local applyButton = innerWnd:CreateChildWidget("button", "applyButton", 0, true)
  applyButton:Show(false)
  applyButton:SetText(locale.expedition.apply)
  applyButton:AddAnchor("RIGHT", cancelButton, "LEFT", 0, 0)
  ApplyButtonSkin(applyButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {cancelButton, applyButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local delegateButton = innerWnd:CreateChildWidget("button", "delegateButton", 0, true)
  delegateButton:Show(false)
  delegateButton:SetText(locale.expedition.delegate)
  delegateButton:AddAnchor("BOTTOMLEFT", innerWnd, 0, 0)
  ApplyButtonSkin(delegateButton, BUTTON_BASIC.DEFAULT)
  local dismissButton = innerWnd:CreateChildWidget("button", "dismissButton", 0, true)
  dismissButton:Show(false)
  dismissButton:AddAnchor("LEFT", delegateButton, "RIGHT", 0, 0)
  dismissButton:SetText(locale.expedition.dismiss)
  ApplyButtonSkin(dismissButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {delegateButton, dismissButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local leaveButton = innerWnd:CreateChildWidget("button", "leaveButton", 0, true)
  leaveButton:Show(false)
  leaveButton:SetText(locale.expedition.leave)
  leaveButton:AddAnchor("BOTTOMLEFT", innerWnd, 0, 0)
  ApplyButtonSkin(leaveButton, BUTTON_BASIC.DEFAULT)
end
