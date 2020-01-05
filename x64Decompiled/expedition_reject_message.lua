local expeditionRejectMessage
local function CreateExpeditionRejectMessage()
  local frame = CreateCenterMessageFrame("expeditionRejectMessage", "UIParent", "TYPE4")
  frame:EnableHidingIsRemove(true)
  frame.body:SetHeight(FONT_SIZE.LARGE)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  frame.body.style:SetShadow(true)
  frame.icon:RemoveAllAnchors()
  frame.icon:AddAnchor("CENTER", frame.iconBg, -1, -6)
  frame.icon:SetVisible(true)
  frame.icon:SetTexture(TEXTURE_PATH.EXPEDITION_REJECT)
  frame.icon:SetTextureInfo("refusal_icon")
  frame.body:RemoveAllAnchors()
  frame.body:AddAnchor("TOP", frame.textImg, "BOTTOM", 0, 4)
  frame.body:SetWidth(1000)
  frame.body.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  frame.textImg:RemoveAllAnchors()
  frame.textImg:AddAnchor("TOP", frame.icon, "BOTTOM", 0, -5)
  frame.textImg:SetTexture(TEXTURE_PATH.EXPEDITION_REJECT)
  frame.textImg:SetTextureInfo("refusal_text")
  local function OnEndFadeOut()
    expeditionRejectMessage = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowExpeditionRejectMessage(expeditionName)
  if expeditionRejectMessage == nil then
    expeditionRejectMessage = CreateExpeditionRejectMessage()
  end
  expeditionRejectMessage.body:SetTextAutoWidth(1000, string.format("%s[%s]|r %s", FONT_COLOR_HEX.SKYBLUE, expeditionName, GetCommonText("applicant_reject")), 5)
  expeditionRejectMessage.body:SetHeight(expeditionRejectMessage.body:GetTextHeight())
  expeditionRejectMessage:SetHandler("OnUpdate", expeditionRejectMessage.OnUpdate)
  expeditionRejectMessage:Show(true)
  return true
end
