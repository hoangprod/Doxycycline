worldmapSkillMapEffect = {}
roadmapSkillMapEffect = {}
function CreateSkillMapEffect(id, parentMap, index)
  local frame = parentMap:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(M_ICON_EXTENT, M_ICON_EXTENT)
  frame:Show(false)
  local bg = parentMap:CreateDrawable(TEXTURE_PATH.MAP_ICON, "skill_effect", "overlay")
  bg:AddAnchor("CENTER", frame, 0, 0)
  bg:SetVisible(false)
  frame.bg = bg
  frame.effect = CreateEffect(frame, bg, "")
  frame.effect:SetRepeatCount(20)
  parentMap:SetSkillEffectWidget(frame, frame.bg, index)
  function frame:SetBgColor(color)
    frame.bg:SetColor(color[1], color[2], color[3], 1)
  end
  function frame:OnShow()
    frame.bg:SetVisible(true)
    frame.effect:SetVisible(true)
    frame.effect:SetStartEffect(true)
    frame.effect:SetStartEffect(true)
  end
  frame:SetHandler("OnShow", frame.OnShow)
  function frame:OnHide()
    frame.bg:SetVisible(false)
    frame.effect:SetVisible(false)
  end
  frame:SetHandler("OnHide", frame.OnHide)
  return frame
end
function OnSkillMapEffect(info)
  if worldmapSkillMapEffect[info.index] == nil then
    worldmapSkillMapEffect[info.index] = CreateSkillMapEffect("worlmapSkillEffect" .. info.index, worldmap, info.index)
  end
  if roadmapSkillMapEffect[info.index] == nil then
    roadmapSkillMapEffect[info.index] = CreateSkillMapEffect("roadmapSkillEffect" .. info.index, roadmap, info.index)
  end
  local index = info.index
  local color = {
    info.r,
    info.g,
    info.b,
    info.a
  }
  worldmap:ShowSkillMapEffect(info.x, info.y, info.z, index)
  roadmap:ShowSkillMapEffect(info.x, info.y, info.z, index)
  worldmapSkillMapEffect[index]:SetBgColor(color)
  roadmapSkillMapEffect[index]:SetBgColor(color)
  worldmapSkillMapEffect[index].effect:SetEffectColor(color)
  roadmapSkillMapEffect[index].effect:SetEffectColor(color)
  worldmapSkillMapEffect[index].effect:SetRepeatCount(info.time / 1000 + 1)
  roadmapSkillMapEffect[index].effect:SetRepeatCount(info.time / 1000 + 1)
end
UIParent:SetEventHandler("SKILL_MAP_EFFECT", OnSkillMapEffect)
function OnHideMapEffect(index)
  worldmapSkillMapEffect[index]:Show(false)
  roadmapSkillMapEffect[index]:Show(false)
  worldmapSkillMapEffect[index].effect:SetStartEffect(false)
  roadmapSkillMapEffect[index].effect:SetStartEffect(false)
end
UIParent:SetEventHandler("HIDE_SKILL_MAP_EFFECT", OnHideMapEffect)
