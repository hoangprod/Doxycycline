ROUND_INFO_TEXTURE_INFO = {
  NORMAL = {
    PATH = "ui/battlefield/wave_info_normal.dds",
    KEY = "wave_info_normal"
  },
  BOSS = {
    PATH = "ui/battlefield/wave_info_boss.dds",
    KEY = "wave_info_boss"
  }
}
function CreateRoundFrame(id)
  local frame = UIParent:CreateWidget("emptywidget", id, "UIParent")
  local DEFAULT_ROUND_TEXTURE = ROUND_INFO_TEXTURE_INFO.NORMAL
  local bg = frame:CreateDrawable(DEFAULT_ROUND_TEXTURE.PATH, DEFAULT_ROUND_TEXTURE.KEY, "background")
  bg:AddAnchor("LEFT", frame, 0, 0)
  bg:AddAnchor("RIGHT", frame, 0, 0)
  frame.bg = bg
  frame:SetHeight(bg:GetHeight())
  local roundNumber = frame:CreateChildWidget("label", "roundNumber", 0, true)
  roundNumber:SetHeight(FONT_SIZE.XXLARGE)
  roundNumber:SetAutoResize(true)
  roundNumber.style:SetFontSize(FONT_SIZE.XXLARGE)
  roundNumber.style:SetShadow(true)
  local roundOffset = 9
  local roundInset = 6
  local roundString = frame:CreateChildWidget("label", "roundString", 0, true)
  roundString:SetHeight(FONT_SIZE.MIDDLE)
  roundString:SetAutoResize(true)
  roundString:SetText(GetUIText(COMMON_TEXT, "round"))
  roundString.style:SetShadow(true)
  if baselibLocale.needChangeWordOrder then
    roundString:AddAnchor("RIGHT", roundNumber, "LEFT", -roundInset, 2)
    roundNumber:AddAnchor("TOP", frame, roundString:GetWidth() / 2, roundOffset)
  else
    roundString:AddAnchor("LEFT", roundNumber, "RIGHT", roundInset, 2)
    roundNumber:AddAnchor("TOP", frame, -(roundString:GetWidth() / 2), roundOffset)
  end
  frame.totalRound = nil
  local timeInset = 4
  local timeIcon = frame:CreateDrawable(TEXTURE_PATH.HUD, "clock", "background")
  timeIcon:SetVisible(false)
  frame.timeIcon = timeIcon
  local timeString = frame:CreateChildWidget("label", "timeString", 0, true)
  timeString:Show(false)
  timeString:SetAutoResize(true)
  timeString:SetHeight(FONT_SIZE.LARGE)
  timeString.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(timeString, FONT_COLOR.MEDIUM_YELLOW)
  timeIcon:AddAnchor("RIGHT", timeString, "LEFT", -timeInset, 0)
  timeString:AddAnchor("TOP", frame, timeIcon:GetWidth() / 2, roundNumber:GetHeight() + roundOffset + 20)
  return frame
end
