local MAX_RAID_PARTIES = X2Team:GetMaxParties()
function SetViewOfRaidFrame(ownId)
  local w = UIParent:CreateWidget("window", ownId, "UIParent")
  function w:MakeOriginWindowPos(reset)
    self:RemoveAllAnchors()
    if reset then
      self:AddAnchor("TOPLEFT", "UIParent", 0, F_LAYOUT.CalcDontApplyUIScale(145))
    else
      self:AddAnchor("TOPLEFT", "UIParent", 0, 145)
    end
  end
  w:MakeOriginWindowPos()
  w:Clickable(false)
  w:Show(false)
  w:EnableDrag(true)
  w.simple = false
  w.vertical = false
  w.rowCount = 0
  w.columnCount = 0
  local troop1Btn = CreateCheckButton(w:GetId() .. ".troop1Btn", w, "1", "ui/hud/raid_tab.dds")
  troop1Btn:AddAnchor("BOTTOMLEFT", w, "TOPLEFT", 4, 5)
  troop1Btn:SetButtonStyle("raid_hud")
  w.troop1Btn = troop1Btn
  local troop2Btn = CreateCheckButton(w:GetId() .. ".troop2Btn", w, "2", "ui/hud/raid_tab.dds")
  troop2Btn:AddAnchor("LEFT", troop1Btn, "RIGHT", 5, 0)
  troop2Btn:SetButtonStyle("raid_hud")
  w.troop2Btn = troop2Btn
  local troopBtnBg = w:CreateDrawable("ui/hud/raid_tab.dds", "raid_tab_bg", "background")
  troopBtnBg:AddAnchor("TOPLEFT", w, 2, 5)
  w.troopBtnBg = troopBtnBg
  local party = {}
  for i = 1, MAX_RAID_PARTIES do
    party[i] = CreateRaidParty(w, "partyWindow", i)
    if i == 1 then
      party[i]:AddAnchor("TOPLEFT", w, 0, 0)
    else
      party[i]:AddAnchor("TOPLEFT", party[i - 1], "TOPRIGHT", PARTY_FRAME_AMONG_INSET_HORIZON, 0)
    end
  end
  w.party = party
  function w:OnBoundChanged()
    local width, height = self:GetExtent()
    local partyWidth = width / 5
    local partyHeight = (height - PARTY_FRAME_AMONG_INSET_VERTICAL) / 2
    for i = 1, MAX_RAID_PARTIES do
      self.party[i]:SetExtent(partyWidth, partyHeight)
    end
  end
  w:SetHandler("OnBoundChanged", w.OnBoundChanged)
  function w:SetSimpleMode(simple)
    self.simple = simple
    w:SetExtent(RAID_FRAME_WIDTH, RAID_FRAME_HEIGHT)
    for i = 1, MAX_RAID_PARTIES do
      self.party[i]:SetSimpleMode(simple)
    end
  end
  function w:SetVertical(vertical, feedCount)
    self.vertical = vertical
    self.rowCount = 0
    self.columnCount = 0
    for i = 1, MAX_RAID_PARTIES do
      local row = math.mod(i - 1, feedCount)
      local column = math.floor((i - 1) / feedCount)
      local party = w.party
      party[i]:UpdateMemberAnchor(vertical)
      if i == 1 then
        party[i]:RemoveAllAnchors()
        party[i]:AddAnchor("TOPLEFT", w, "TOPLEFT", 0, 0)
      elseif i > 5 then
        party[i]:RemoveAllAnchors()
        party[i]:AddAnchor("TOPLEFT", party[i - 5], "BOTTOMLEFT", 0, PARTY_FRAME_AMONG_INSET_VERTICAL)
      elseif row == 0 and column > 0 then
        party[i]:RemoveAllAnchors()
        party[i]:AddAnchor("TOPLEFT", party[(column - 1) * feedCount + 1], "TOPRIGHT", 0, 0)
      else
        party[i]:RemoveAllAnchors()
        party[i]:AddAnchor("TOPLEFT", party[i - 1], "TOPRIGHT", PARTY_FRAME_AMONG_INSET_HORIZON, 0)
      end
      self.rowCount = math.max(row + 1, self.rowCount)
      self.columnCount = math.max(column + 1, self.columnCount)
    end
  end
  w:SetVertical(false, 10)
  return w
end
