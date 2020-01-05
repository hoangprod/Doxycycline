local expeditionLevelUpMessage
local function CreateExpeditionLevelUpMessage(id, parent)
  local frame = CreateCenterMessageFrame("expeditionLevelUpMessage", parent, "TYPE4")
  frame:EnableHidingIsRemove(true)
  frame.body:SetHeight(FONT_SIZE.LARGE)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  frame.body.style:SetShadow(true)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  frame.title:SetAutoResize(true)
  frame.title:SetHeight(FONT_SIZE.XLARGE)
  frame.title.style:SetFontSize(FONT_SIZE.XLARGE)
  frame.title.style:SetShadow(true)
  frame.icon:RemoveAllAnchors()
  frame.icon:AddAnchor("CENTER", frame.iconBg, -1, -6)
  function frame:FillLevelUp(title, desc)
    frame.icon:SetVisible(true)
    frame.icon:SetTexture(TEXTURE_PATH.EXPEDITION_LEVEL_UP)
    frame.icon:SetTextureInfo("angel_icon")
    frame.textImg:SetVisible(true)
    ApplyTextColor(frame.title, FONT_COLOR.WHITE)
    ApplyTextColor(frame.body, {
      ConvertColor(50),
      ConvertColor(201),
      ConvertColor(233),
      1
    })
    frame.textImg:RemoveAllAnchors()
    frame.textImg:AddAnchor("TOP", frame.icon, "BOTTOM", 0, -5)
    frame.textImg:SetTexture(TEXTURE_PATH.EXPEDITION_LEVEL_UP)
    frame.textImg:SetTextureInfo("level_up")
    frame.title:AddAnchor("TOP", frame.textImg, "BOTTOM", 0, 0)
    frame.title:SetText(title)
    frame.title:Show(true)
    frame.body:RemoveAllAnchors()
    frame.body:AddAnchor("TOP", frame.title, "BOTTOM", 0, 4)
    frame.body:SetTextAutoWidth(1000, desc, 5)
    frame.body:SetHeight(frame.body:GetTextHeight())
    frame:SetHandler("OnUpdate", frame.OnUpdate)
  end
  local function OnEndFadeOut()
    expeditionLevelUpMessage = nil
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  return frame
end
function ShowExpeditionLevelUpMessage(EVENT_TYPE, title, desc)
  if not X2Player:GetFeatureSet().expeditionLevel then
    return false
  end
  if expeditionLevelUpMessage == nil then
    expeditionLevelUpMessage = CreateExpeditionLevelUpMessage("expeditionLevelUpMessage", "UIParent")
  else
    return false
  end
  if EVENT_TYPE == "EXPEDITION_LEVEL_UP" then
    expeditionLevelUpMessage:FillLevelUp(title, desc)
  else
    return false
  end
  expeditionLevelUpMessage:Show(true)
  return true
end
