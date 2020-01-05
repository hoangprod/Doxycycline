local SetViewOfRoleMark = function(id, parent)
  local mark = CreateEmptyButton(id .. "leaderMark", parent)
  mark:SetExtent(19, 18)
  local bg = mark:CreateImageDrawable(TEXTURE_PATH.RAID_TYPE_ICON, "background")
  bg:AddAnchor("CENTER", mark, 0, 0)
  mark.bg = bg
  function mark:SetMarkTexture(role)
    if role == nil or role == TMROLE_NONE then
      mark:Show(false)
      return
    end
    mark:Show(true)
    local info = W_MODULE:GetRoleInfoByRole(role)
    bg:SetTextureInfo(info.image.key)
  end
  mark:SetMarkTexture(nil)
  return mark
end
function CreateRoleMark(id, parent)
  local roleMark = SetViewOfRoleMark(id, parent)
  local OnEnter = function(self)
    if self.tooltip ~= nil and self.tooltip ~= "" then
      SetTooltip(self.tooltip, self)
    end
  end
  roleMark:SetHandler("OnEnter", OnEnter)
  function roleMark:SetMark(role, showTooltip)
    self.role = role
    self:SetMarkTexture(role)
    local info = W_MODULE:GetRoleInfoByRole(role)
    self.tooltip = info.text
  end
  return roleMark
end
function SetViewOfRaidTeamManagerMember(id, parent, slot)
  local w = CreateEmptyWindow(id, parent)
  w:Show(false)
  local roleMark = CreateRoleMark(id .. ".roleMark", w)
  roleMark:AddAnchor("LEFT", w, 0, 0)
  roleMark:Show(true)
  w.roleMark = roleMark
  local leaderMark = W_ICON.CreateLeaderMark(id .. ".leaderMark", w)
  leaderMark:AddAnchor("LEFT", roleMark, "RIGHT", 0, 0)
  w.leaderMark = leaderMark
  W_ICON.CreateLootIconWidget(w)
  w.lootIcon:AddAnchor("LEFT", roleMark, "RIGHT", -1, 0)
  local eventWindow = w:CreateChildWidget("emptywidget", "eventWindow", 0, true)
  eventWindow:AddAnchor("TOPLEFT", w, 0, 0)
  eventWindow:AddAnchor("BOTTOMRIGHT", w, 0, 0)
  eventWindow:Show(true)
  w.eventWindow = eventWindow
  local bg = w:CreateDrawable(TEXTURE_PATH.RAID, "paint_bg", "artwork")
  bg:SetTextureColor("white")
  bg:AddAnchor("TOPLEFT", eventWindow, -5, -6)
  bg:AddAnchor("BOTTOMRIGHT", eventWindow, 0, 8)
  bg:SetVisible(false)
  eventWindow.bg = bg
  local levelLabel = w:CreateChildWidget("label", "levelLabel", 0, true)
  levelLabel:SetExtent(15, 13)
  levelLabel:AddAnchor("RIGHT", w, -5, 0)
  levelLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(levelLabel, FONT_COLOR.BLACK)
  local heirIcon = w:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor_small", "artwork")
  heirIcon:AddAnchor("RIGHT", levelLabel, "LEFT", -1, 0)
  w.heirIcon = heirIcon
  local nameLabel = w:CreateChildWidget("label", "nameLabel", 0, true)
  nameLabel:Show(true)
  nameLabel:SetLimitWidth(true)
  nameLabel:SetHeight(13)
  nameLabel:AddAnchor("LEFT", leaderMark, "RIGHT", 0, 0)
  nameLabel:AddAnchor("RIGHT", levelLabel, -2, 0)
  nameLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(nameLabel, FONT_COLOR.ROLE_NONE)
  eventWindow:Raise()
  roleMark:Raise()
  leaderMark:Raise()
  return w
end
