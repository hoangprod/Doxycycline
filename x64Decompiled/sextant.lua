local sextantWindow = GetIndicators().sextantWindow
if sextantWindow ~= nil then
  do
    local coordinateLabel = sextantWindow.coordinateLabel
    function ToggleSextantWindow(toggle)
      if sextantWindow ~= nil and baselibLocale.openedSextant == true then
        sextantWindow.toggle = toggle
        coordinateLabel:Show(toggle)
      end
    end
    function coordinateLabel:OnToggle()
      RunIndicatorStackRule()
    end
    coordinateLabel:SetHandler("OnShow", coordinateLabel.OnToggle)
    coordinateLabel:SetHandler("OnHide", coordinateLabel.OnToggle)
    function sextantWindow:OnUpdate(dt)
      if sextantWindow ~= nil then
        local isShow = false
        if worldmap ~= nil then
          local sextantInfo = worldmap:GetPlayerSextants()
          if sextantInfo ~= nil and sextantWindow.toggle == true then
            sextantWindow:Update(sextantInfo)
            isShow = true
          end
        end
        coordinateLabel:Show(isShow)
      end
    end
    sextantWindow:SetHandler("OnUpdate", sextantWindow.OnUpdate)
  end
end
