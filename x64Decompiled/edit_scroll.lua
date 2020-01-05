function CreateEditScroll(parent, ownId, index)
  local frame = CreateScrollWindow(parent, ownId, index)
  frame:Show(true)
  frame.scrollInset = 0
  function frame:SetScrollInset(inset)
    frame.scrollInset = inset
  end
  local editbox = W_CTRL.CreateMultiLineEdit("editbox", frame.content)
  editbox:AddAnchor("TOPLEFT", frame.content, 0, 0)
  editbox:SetExtent(frame.content:GetWidth(), 1000)
  frame.editbox = editbox
  local function OnTextChanged()
    if frame.OnTextChangedProc ~= nil then
      frame.OnTextChangedProc()
    end
    frame:ResetScroll(editbox:GetTextHeight() + 10)
  end
  editbox:SetHandler("OnTextChanged", OnTextChanged)
  local function OnCursorMovedScoreEdit()
    local min, max = frame.scroll.vs:GetMinMaxValues()
    local cursor = editbox:GetCursorPosY() / UIParent:GetUIScale()
    if cursor >= frame:GetHeight() + frame.scroll.vs:GetValue() - 23 then
      local vs = cursor - frame:GetHeight() + 23
      if max < vs then
        frame:ResetScroll(vs + frame:GetHeight())
      end
      frame:SetValue(vs)
    elseif cursor - 1 < frame.scroll.vs:GetValue() then
      frame:SetValue(cursor)
    end
  end
  editbox:SetHandler("OnCursorMoved", OnCursorMovedScoreEdit)
  return frame
end
