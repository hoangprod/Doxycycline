function CreateRaidCommandMsgWindow(id, parent)
  local raid_command_msg = UIParent:CreateWidget("textbox", id, parent)
  raid_command_msg.style:SetAlign(ALIGN_LEFT)
  raid_command_msg.style:SetSnap(true)
  raid_command_msg.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  raid_command_msg.style:SetColor(ConvertColor(255), ConvertColor(124), ConvertColor(28), 1)
  local bg = CreateContentBackground(raid_command_msg, "TYPE8", "black")
  bg:AddAnchor("LEFT", raid_command_msg, -45, 0)
  bg:AddAnchor("RIGHT", raid_command_msg, 45, 0)
  raid_command_msg.bg = bg
  return raid_command_msg
end
raidCommandMsgWindow = CreateRaidCommandMsgWindow("raidCommandMsgWindow", systemLayerParent)
raidCommandMsgWindow:Show(false)
raidCommandMsgWindow:SetExtent(UIParent:GetScreenWidth(), 25)
raidCommandMsgWindow:AddAnchor("TOP", "UIParent", "TOP", 0, 285)
raidCommandMsgWindow:Clickable(false)
function raidCommandMsgWindow:OnUpdate(dt)
  self.showingTime = dt + self.showingTime
  local t = self.showingTime / 3000
  if t > 1 then
    self:Show(false, 2000)
    self:ReleaseHandler("OnUpdate")
  end
end
