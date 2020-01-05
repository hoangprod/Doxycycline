local familyLevelUpMessage
local function CreateFamilyLevelUpMessage()
  local frame = CreateCenterMessageFrame("familyLevelUpMessage", "UIParent", "TYPE4")
  frame:EnableHidingIsRemove(true)
  frame.body:SetHeight(FONT_SIZE.LARGE)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  frame.body.style:SetShadow(true)
  frame.icon:RemoveAllAnchors()
  frame.icon:AddAnchor("CENTER", frame.iconBg, -1, -6)
  frame.icon:SetVisible(true)
  frame.icon:SetTexture(TEXTURE_PATH.FAMILY_LEVEL_UP)
  frame.icon:SetTextureInfo("angel_icon")
  frame.body:RemoveAllAnchors()
  frame.body:AddAnchor("TOP", frame.textImg, "BOTTOM", 0, 4)
  frame.body:SetWidth(1000)
  frame.body.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  frame.textImg:RemoveAllAnchors()
  frame.textImg:AddAnchor("TOP", frame.icon, "BOTTOM", 0, -5)
  frame.textImg:SetTexture(TEXTURE_PATH.FAMILY_LEVEL_UP)
  frame.textImg:SetTextureInfo("level_up")
  local function OnEndFadeOut()
    familyLevelUpMessage = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowFamilyLevelUpMessage(levelName)
  if familyLevelUpMessage == nil then
    familyLevelUpMessage = CreateFamilyLevelUpMessage()
  end
  local str = string.format([[
%s
%s%s]], GetCommonText("family_levelup_notify"), FONT_COLOR_HEX.SKYBLUE, levelName)
  familyLevelUpMessage.body:SetTextAutoWidth(1000, str, 5)
  familyLevelUpMessage.body:SetHeight(familyLevelUpMessage.body:GetTextHeight())
  familyLevelUpMessage:SetHandler("OnUpdate", familyLevelUpMessage.OnUpdate)
  familyLevelUpMessage:Show(true)
  return true
end
