local expeditionAcceptMessage
local function CreateExpeditionAcceptMessage()
  local frame = CreateCenterMessageFrame("expeditionAcceptMessage", "UIParent", "TYPE4")
  frame:EnableHidingIsRemove(true)
  frame.body:SetHeight(FONT_SIZE.LARGE)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  frame.body.style:SetShadow(true)
  frame.icon:RemoveAllAnchors()
  frame.icon:AddAnchor("CENTER", frame.iconBg, -1, -6)
  frame.icon:SetVisible(true)
  frame.icon:SetTexture(TEXTURE_PATH.EXPEDITION_ACCEPT)
  frame.icon:SetTextureInfo("approve_icon")
  frame.body:RemoveAllAnchors()
  frame.body:AddAnchor("TOP", frame.textImg, "BOTTOM", 0, 4)
  frame.body:SetWidth(1000)
  frame.body.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  frame.textImg:RemoveAllAnchors()
  frame.textImg:AddAnchor("TOP", frame.icon, "BOTTOM", 0, -5)
  frame.textImg:SetTexture(TEXTURE_PATH.EXPEDITION_ACCEPT)
  frame.textImg:SetTextureInfo("apporove_text")
  local function OnEndFadeOut()
    expeditionAcceptMessage = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowExpeditionAcceptMessage(expeditionName)
  if expeditionAcceptMessage == nil then
    expeditionAcceptMessage = CreateExpeditionAcceptMessage()
  end
  local str = baselibLocale:ChangeSequenceOfWord("%s %s", string.format("%s[%s]|r", FONT_COLOR_HEX.SKYBLUE, expeditionName), GetCommonText("applicant_accept"))
  expeditionAcceptMessage.body:SetTextAutoWidth(1000, str, 5)
  expeditionAcceptMessage.body:SetHeight(expeditionAcceptMessage.body:GetTextHeight())
  expeditionAcceptMessage:SetHandler("OnUpdate", expeditionAcceptMessage.OnUpdate)
  expeditionAcceptMessage:Show(true)
  return true
end
