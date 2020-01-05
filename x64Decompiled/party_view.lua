local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local MAX_RAID_PARTY_MEMBERS = X2Team:GetMaxPartyMembers()
function SetViewOfRaidTeamManagerParty(id, parent, party)
  local w = CreateEmptyWindow(id, parent)
  w:AddAnchor("TOPLEFT", parent, "BOTTOMLEFT", 0, 0)
  w:Show(true)
  local bg = CreateContentBackground(w, "TYPE1", "orange")
  bg:SetVisible(false)
  bg:AddAnchor("TOPLEFT", w, -sideMargin / 2, -sideMargin / 2)
  bg:AddAnchor("BOTTOMRIGHT", w, sideMargin / 3, sideMargin / 2)
  w.bg = bg
  local numberLabel = W_CTRL.CreateLabel(id .. ".numberLabel", w)
  numberLabel:SetHeight(FONT_SIZE.LARGE)
  numberLabel:AddAnchor("TOPLEFT", w, 0, 0)
  numberLabel:AddAnchor("TOPRIGHT", w, 0, 0)
  numberLabel:SetText(locale.raid.party .. tostring(party))
  numberLabel.style:SetAlign(ALIGN_LEFT)
  numberLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(numberLabel, FONT_COLOR.BLACK)
  w.numberLabel = numberLabel
  local visiblePartyBtn = CreateCheckButton(id .. ".visiblePartyBtn", w, nil, TEXTURE_PATH.CHECK_EYE_SHAPE)
  visiblePartyBtn:SetButtonStyle("eyeShape")
  visiblePartyBtn:AddAnchor("TOPRIGHT", w, 0, 1)
  w.visiblePartyBtn = visiblePartyBtn
  local eventWindow = CreateEmptyWindow(id .. ".eventWindow", w)
  eventWindow:AddAnchor("TOPLEFT", numberLabel, 0, 0)
  eventWindow:AddAnchor("BOTTOMRIGHT", w, 0, 0)
  eventWindow:Show(true)
  w.eventWindow = eventWindow
  local bg = CreateContentBackground(w, "TYPE1", "blue")
  bg:SetVisible(false)
  bg:AddAnchor("TOPLEFT", w, -sideMargin / 2, -sideMargin / 2)
  bg:AddAnchor("BOTTOMRIGHT", w, sideMargin / 3, sideMargin / 2)
  eventWindow.bg = bg
  local member = {}
  for i = 1, MAX_RAID_PARTY_MEMBERS do
    member[i] = CreateRaidTeamManagerMember(id .. ".member[" .. i .. "]", w, party, i)
  end
  for i = 1, MAX_RAID_PARTY_MEMBERS do
    if i == 1 then
      member[i]:AddAnchor("TOPLEFT", w, 0, sideMargin)
    else
      member[i]:AddAnchor("TOPLEFT", member[i - 1], "BOTTOMLEFT", 0, 0)
    end
  end
  w.member = member
  function w:OnBoundChanged()
    local width, height = self:GetExtent()
    local memberWidth = width
    local memberHeight = (height - sideMargin) / MAX_RAID_PARTY_MEMBERS
    for i = 1, MAX_RAID_PARTY_MEMBERS do
      self.member[i]:SetExtent(memberWidth, memberHeight)
    end
  end
  w:SetHandler("OnBoundChanged", w.OnBoundChanged)
  w:SetExtent(RAID_TEAM_MANAGER_PARTY_WIDTH, RAID_TEAM_MANAGER_PARTY_HEIGHT)
  visiblePartyBtn:Raise()
  return w
end
