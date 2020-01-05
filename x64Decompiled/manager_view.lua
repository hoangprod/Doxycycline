local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local MAX_RAID_PARTIES = X2Team:GetMaxParties()
function SetViewOfRaidTeamManagerFrame(id, parent)
  local w = CreateWindow(id, parent)
  w:Show(false)
  w:SetExtent(600, 410)
  w:AddAnchor("CENTER", "UIParent", 0, 0)
  w:SetTitle(locale.raid.title)
  w:SetCloseOnEscape(true)
  w:SetSounds("raid_team")
  local tab = W_BTN.CreateTab("tab", w)
  tab:AddAnchor("TOPLEFT", w, sideMargin, titleMargin)
  tab:AddAnchor("RIGHT", w, -sideMargin, 0)
  local tabTexts = {}
  table.insert(tabTexts, GetCommonText("raid_joint_name", 1))
  table.insert(tabTexts, GetCommonText("raid_joint_name", 2))
  tab:AddTabs(tabTexts)
  w.tab = tab
  local dismissRaidBtn = w:CreateChildWidget("button", "dismissRaidBtn", 0, true)
  dismissRaidBtn:AddAnchor("BOTTOMRIGHT", w, -sideMargin, -sideMargin)
  dismissRaidBtn:SetText(locale.raid.dismissRaid)
  ApplyButtonSkin(dismissRaidBtn, BUTTON_BASIC.DEFAULT)
  dismissRaidBtn:Show(false)
  local changeToRaidBtn = w:CreateChildWidget("button", "changeToRaidBtn", 0, true)
  changeToRaidBtn:AddAnchor("BOTTOMRIGHT", w, -sideMargin, -sideMargin)
  changeToRaidBtn:SetText(GetUIText(TEAM_TEXT, "change_to_raid"))
  ApplyButtonSkin(changeToRaidBtn, BUTTON_BASIC.DEFAULT)
  local rangeInviteBtn = w:CreateChildWidget("button", "rangeInviteBtn", 0, true)
  rangeInviteBtn:AddAnchor("RIGHT", changeToRaidBtn, "LEFT", 0, 0)
  rangeInviteBtn:SetText(GetUIText(TEAM_TEXT, "range_invite"))
  ApplyButtonSkin(rangeInviteBtn, BUTTON_BASIC.DEFAULT)
  local searchBtn = w:CreateChildWidget("button", "searchBtn", 0, true)
  searchBtn:AddAnchor("RIGHT", rangeInviteBtn, "LEFT", -8, 0)
  ApplyButtonSkin(searchBtn, BUTTON_ICON.SEARCH)
  local buttonTable = {
    dismissRaidBtn,
    changeToRaidBtn,
    rangeInviteBtn
  }
  AdjustBtnLongestTextWidth(buttonTable)
  local raidOptionBtn = w:CreateChildWidget("button", "raidOptionBtn", 0, true)
  raidOptionBtn:AddAnchor("BOTTOMLEFT", w, sideMargin, -sideMargin)
  raidOptionBtn:SetText(locale.raid.option)
  ApplyButtonSkin(raidOptionBtn, BUTTON_BASIC.DEFAULT)
  local raidRoleBtn = w:CreateChildWidget("button", "raidRoleBtn", 0, true)
  raidRoleBtn:AddAnchor("LEFT", raidOptionBtn, "RIGHT", 0, 0)
  raidRoleBtn:SetText(locale.raid.setMyRole)
  ApplyButtonSkin(raidRoleBtn, BUTTON_BASIC.DEFAULT)
  local buttonTable = {raidOptionBtn, raidRoleBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  local summonBtn = w:CreateChildWidget("button", "summonBtn", 0, true)
  summonBtn:AddAnchor("TOPRIGHT", w, -sideMargin, 45)
  summonBtn:SetText(GetCommonText("team_summon"))
  ApplyButtonSkin(summonBtn, BUTTON_BASIC.DEFAULT)
  local raidOptionFrame = CreateRaidOptionFrame(id .. ".raidOptionFrame", raidOptionBtn)
  w.raidOptionFrame = raidOptionFrame
  local raidRoleFrame = CreateRoleFrame("raidRoleFrame", raidRoleBtn)
  raidRoleFrame:AddAnchor("TOPLEFT", raidRoleBtn, "TOPRIGHT", 0, 0)
  function raidRoleFrame:GetMyRole()
    local myIndex = X2Team:GetTeamPlayerIndex()
    local myJointOrder = X2Team:GetMyTeamJointOrder()
    local role = X2Team:GetRole(myJointOrder, myIndex)
    return role
  end
  function raidRoleFrame:SetMyRole(role)
    X2Team:SetRole(role)
  end
  w.raidRoleFrame = raidRoleFrame
  local party = {}
  for i = 1, MAX_RAID_PARTIES do
    party[i] = CreateRaidTeamManagerParty(id .. ".party[" .. i .. "]", w, i)
    if i < 6 then
      party[i]:AddAnchor("TOPLEFT", tab.selectedButton[1], "BOTTOMLEFT", (i - 1) * (RAID_TEAM_MANAGER_PARTY_WIDTH + sideMargin / 1.3), 16)
    else
      party[i]:AddAnchor("TOPLEFT", party[i - 5], "BOTTOMLEFT", 0, sideMargin * 1.5)
    end
  end
  w.party = party
  return w
end
