local factionRelationMessage
local CreateFactionRelationChangeMessage = function(id, parent)
  local frame = CreateCenterMessageFrame(id, parent, "TYPE1")
  frame.iconBg:RemoveAllAnchors()
  frame.iconBg:AddAnchor("BOTTOM", frame.bg, "TOP", 0, MARGIN.WINDOW_SIDE)
  local title = frame:CreateChildWidget("textbox", "title", 0, true)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", frame.bg, 0, MARGIN.WINDOW_SIDE)
  title:SetExtent(frame:GetWidth(), FONT_SIZE.XLARGE)
  title.style:SetFontSize(FONT_SIZE.XLARGE)
  title.style:SetShadow(true)
  frame.body:SetWidth(1000)
  frame.body:SetLineSpace(8)
  frame.body:AddAnchor("TOP", title, "BOTTOM", 0, 8)
  frame.body.style:SetFontSize(FONT_SIZE.LARGE)
  local elapsed = 0
  function frame:OnUpdate(dt)
    elapsed = elapsed + dt
    if elapsed > 5000 then
      frame:Show(false, 200)
      frame:ReleaseHandler("OnUpdate")
      return
    end
  end
  local OnEndFadeOut = function()
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  function frame:FillMsg(isHostile, f1Name, f2Name)
    local titleStr = ""
    local contentStr = ""
    local iconPath = ""
    local iconKey = ""
    if isHostile then
      iconPath = "ui/nation/hostile.dds"
      iconKey = "hostile"
      titleStr = GetUIText(COMMON_TEXT, "faction_relation_center_hostile_title")
      contentStr = GetUIText(COMMON_TEXT, "faction_relation_center_hostile_body", f1Name, f2Name)
    else
      iconPath = "ui/nation/friendship.dds"
      iconKey = "friendship"
      titleStr = GetUIText(COMMON_TEXT, "faction_relation_center_friendly_title")
      contentStr = GetUIText(COMMON_TEXT, "faction_relation_center_friendly_body", f1Name, f2Name)
    end
    self.title:SetText(titleStr)
    self.icon:SetTexture(iconPath)
    self.icon:SetTextureInfo(iconKey)
    self.body:SetTextAutoWidth(1000, contentStr, 5)
    self.body:SetHeight(self.body:GetTextHeight())
    elapsed = 0
    self:SetHandler("OnUpdate", self.OnUpdate)
  end
  return frame
end
function ShowFactionRelationChangeMessage(isHostile, f1Name, f2Name)
  if factionRelationMessage == nil then
    factionRelationMessage = CreateFactionRelationChangeMessage("factionRelationChangeMessage", "UIParent")
    function factionRelationMessage:OnHide()
      factionRelationMessage = nil
    end
    factionRelationMessage:SetHandler("OnHide", factionRelationMessage.OnHide)
  end
  factionRelationMessage:FillMsg(isHostile, f1Name, f2Name)
  factionRelationMessage:Show(true, 200)
  factionRelationMessage:Raise()
  return true
end
