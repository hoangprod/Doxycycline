function CreateComercialMailFrame(id, parent)
  local frame = SetViewOfComercialMailFrame(id, parent)
  function frame:OnHide()
    local goodReadMailWnd = self.readWindow
    if goodReadMailWnd:IsVisible() then
      goodReadMailWnd:Show(false)
    end
  end
  frame:SetHandler("OnHide", frame.OnHide)
  local guide = frame.guide
  local OnEnter = function(self)
    SetTargetAnchorTooltip(locale.comercialMail.guide, "TOPLEFT", self, "BOTTOMRIGHT", 0, 0)
  end
  guide:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeave)
  return frame
end
local comercialMailFrame = CreateComercialMailFrame("comercialMailFrame", "UIParent")
function ToggleComercialMailBox(show)
  if show == nil then
    show = not comercialMailFrame:IsVisible()
  end
  if show then
    comercialMailFrame:WaitPage(true)
  end
  comercialMailFrame:ShowList(show)
end
ADDON:RegisterContentTriggerFunc(UIC_COMMERCIAL_MAIL, ToggleComercialMailBox)
