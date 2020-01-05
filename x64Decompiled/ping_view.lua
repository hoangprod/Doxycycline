function CreatePingFrame(id, parentMap, pingType)
  local frame = parentMap:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(M_ICON_EXTENT, M_ICON_EXTENT)
  frame:Show(false)
  local type = "ping"
  local pingCoord
  if pingType == PING_TYPE_ENEMY then
    pingCoord = "icon_enemy"
    texturePath = BUTTON_TEXTURE_PATH.MAP
  elseif pingType == PING_TYPE_ATTACK then
    pingCoord = "icon_attack"
    texturePath = BUTTON_TEXTURE_PATH.MAP
  elseif pingType == PING_TYPE_LINE then
    pingCoord = "position_x"
    texturePath = BUTTON_TEXTURE_PATH.MAP
  else
    pingCoord = X2Map:GetMapIconCoord(MST_MY_PING)
    texturePath = TEXTURE_PATH.MAP_ICON
    type = ""
  end
  local bg = parentMap:CreateDrawable(texturePath, pingCoord, "overlay")
  bg:AddAnchor("CENTER", frame, 0, 0)
  bg:SetVisible(false)
  frame.bg = bg
  frame.effect = CreateEffect(frame, bg, type)
  frame.effect:SetRepeatCount(4)
  parentMap:SetPingWidget(frame, frame.bg, pingType)
  function frame:OnShow()
    frame.bg:SetVisible(true)
    frame.effect:SetVisible(true)
  end
  frame:SetHandler("OnShow", frame.OnShow)
  function frame:OnHide()
    frame.bg:SetVisible(false)
    frame.effect:SetVisible(false)
  end
  frame:SetHandler("OnHide", frame.OnHide)
  return frame
end
