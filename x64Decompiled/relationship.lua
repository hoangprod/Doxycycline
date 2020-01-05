local relationshipFrame
function CreateRelationshipFrame(id, parent)
  local frame = SetViewOfRelationshipFrame(id, parent)
  function frame.tab:OnTabChangedProc(selected)
    if selected == 1 then
      self.window[1]:ShowFreindTab()
    end
  end
  frame.tab:OnTabChangedProc(1)
  function parent:OnShow()
    local idx = frame.tab:GetSelectedTab()
    frame.tab:OnTabChangedProc(idx)
  end
  frame:SetHandler("OnShow", frame.OnShow)
  relationshipFrame = frame
  return relationshipFrame
end
function ToggleRelationshipUI(show)
  ToggleCommunityWindow(show, COMMUNITY.RELATION)
end
ADDON:RegisterContentTriggerFunc(UIC_FRIEND, ToggleRelationshipUI)
