local rankingMsg
local function CreateRankingAlarmMsg(id, parent)
  local frame = CreateCenterMessageFrame(id, parent, "TYPE1")
  frame:EnableHidingIsRemove(true)
  frame.icon:SetTexture(TEXTURE_PATH.RANKING_FISHING_ALARM)
  frame.icon:SetCoords(0, 0, 64, 64)
  frame.icon:SetExtent(64, 64)
  frame.body:SetHeight(FONT_SIZE.XLARGE)
  frame.body.style:SetFontSize(FONT_SIZE.XLARGE)
  frame.body:AddAnchor("TOP", frame.iconBg, "BOTTOM", 0, 10)
  function frame:FillMsg(msg)
    self.body:SetTextAutoWidth(1000, msg, 5)
    self.body:SetHeight(self.body:GetTextHeight())
    self:SetHandler("OnUpdate", self.OnUpdate)
  end
  local function OnEndFadeOut()
    rankingMsg = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowRankingAlarmMessage(msg)
  if rankingMsg == nil then
    rankingMsg = CreateRankingAlarmMsg("rankingMsg", systemLayerParent)
  end
  rankingMsg:FillMsg(msg)
  rankingMsg:Show(true)
end
