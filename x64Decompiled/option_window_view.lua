local SetWidetTip = function(widget, tip)
  local function OnEnter(self)
    SetTooltip(tip, self)
  end
  widget:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  widget:SetHandler("OnLeave", OnLeave)
end
function SetViewOfRaidOptionFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local offset = sideMargin
  local window = CreateSubOptionWindow(id, parent)
  window:AddAnchor("TOPRIGHT", parent, "TOPLEFT", 0, 0)
  local section = {}
  local sectionHeight = {
    45,
    62,
    40
  }
  for i = 1, 3 do
    section[i] = CreateEmptyWindow(id .. ".section" .. i, window)
    section[i]:Show(true)
    section[i]:SetHeight(sectionHeight[i])
    section[i]:AddAnchor("TOPLEFT", window, sideMargin, offset)
    section[i]:AddAnchor("TOPRIGHT", window, -sideMargin, offset)
    offset = offset + sectionHeight[i] + sideMargin / 2
  end
  local left_inset = sideMargin / 2 - 5
  local raidModeTitle = window:CreateChildWidget("label", "raidModeTitle", 0, false)
  raidModeTitle:SetHeight(20)
  raidModeTitle:SetText(locale.raid.setMode)
  raidModeTitle:AddAnchor("TOPLEFT", section[1], 0, 0)
  raidModeTitle:AddAnchor("TOPRIGHT", section[1], 0, 0)
  raidModeTitle.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(raidModeTitle, FONT_COLOR.MIDDLE_BROWN)
  local radioItems = {
    {
      text = locale.raid.normalMode
    },
    {
      text = locale.raid.simpleMode
    }
  }
  local modeCheckBoxes = CreateRadioGroup(window:GetId() .. ".modeCheckBoxes", raidModeTitle, "horizen")
  modeCheckBoxes:SetFontColor(FONT_COLOR.SOFT_BROWN)
  modeCheckBoxes:SetData(radioItems)
  modeCheckBoxes:Check(1, true)
  modeCheckBoxes:AddAnchor("TOPLEFT", raidModeTitle, "BOTTOMLEFT", 0, 5)
  window.modeCheckBoxes = modeCheckBoxes
  local raidArrayModeTitle = window:CreateChildWidget("label", "raidArrayModeTitle", 0, false)
  raidArrayModeTitle:SetHeight(20)
  raidArrayModeTitle:SetText(locale.raid.setArray)
  raidArrayModeTitle:AddAnchor("TOPLEFT", section[2], 0, 0)
  raidArrayModeTitle:AddAnchor("TOPRIGHT", section[2], 0, 0)
  raidArrayModeTitle.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(raidArrayModeTitle, FONT_COLOR.MIDDLE_BROWN)
  local partyVisibleToRaidCheckBox = CreateCheckButton(id .. ".partyVisibleToRaidCheckBox", section[2], locale.raid.partyVisibleToRaid)
  partyVisibleToRaidCheckBox:AddAnchor("TOPLEFT", raidArrayModeTitle, "BOTTOMLEFT", left_inset, 2)
  partyVisibleToRaidCheckBox:SetButtonStyle("soft_brown")
  window.partyVisibleToRaidCheckBox = partyVisibleToRaidCheckBox
  local invisibleRaidFrameCheckBox = CreateCheckButton(id .. "invisibleRaidFrameCheckBox", section[2], locale.raid.invisibleRaidFrame)
  invisibleRaidFrameCheckBox:AddAnchor("TOPLEFT", partyVisibleToRaidCheckBox, "BOTTOMLEFT", 0, 2)
  invisibleRaidFrameCheckBox:SetButtonStyle("soft_brown")
  window.invisibleRaidFrameCheckBox = invisibleRaidFrameCheckBox
  local invitationTitle = window:CreateChildWidget("label", "invitationTitle", 0, false)
  invitationTitle:SetHeight(20)
  invitationTitle:SetText(locale.raid.setInvitation)
  invitationTitle:AddAnchor("TOPLEFT", section[3], 0, 0)
  invitationTitle:AddAnchor("TOPRIGHT", section[3], 0, 0)
  invitationTitle.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(invitationTitle, FONT_COLOR.MIDDLE_BROWN)
  local refuseInvitationCheckBox = CreateCheckButton(id .. ".refuseInvitationCheckBox", section[3], locale.raid.refuseInvitation)
  refuseInvitationCheckBox:SetExtent(16, 16)
  refuseInvitationCheckBox:AddAnchor("BOTTOMLEFT", section[3], left_inset, 0)
  refuseInvitationCheckBox:SetButtonStyle("soft_brown")
  window.refuseInvitationCheckBox = refuseInvitationCheckBox
  SetWidetTip(refuseInvitationCheckBox.textButton, X2Locale:LocalizeUiText(TOOLTIP_TEXT, "range_invite_tip"))
  offset = offset + sideMargin / 2
  window:SetExtent(215, offset)
  return window
end
