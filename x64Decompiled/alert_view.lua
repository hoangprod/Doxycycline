function CreateAlertManager(id, parent)
  local manager = parent:CreateChildWidget("emptywidget", id, 0, false)
  function manager:HasActiveAlerts()
    if self.alertWidgets == nil then
      return false
    end
    for _, widget in pairs(self.alertWidgets) do
      if widget ~= nil and widget:IsVisible() then
        return true
      end
    end
    return false
  end
  function manager:AdjustHeight()
    if self.alertWidgets == nil then
      return
    end
    local longestHeight = 0
    for _, widget in pairs(self.alertWidgets) do
      if widget ~= nil then
        local curHeight = widget:GetHeight()
        if not (longestHeight > curHeight) or not longestHeight then
          longestHeight = curHeight
        end
      end
    end
    self:SetHeight(longestHeight + FONT_SIZE.MIDDLE)
  end
  return manager
end
