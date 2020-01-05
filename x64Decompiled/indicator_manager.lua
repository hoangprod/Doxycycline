local stackRule = {
  [1] = {widgetName = "clockBar"},
  [2] = {
    widgetName = "zoneNameInformer",
    getAnchorSource = function(widget)
      if widget.attachedWidget ~= nil then
        return widget.attachedWidget
      end
      return widget
    end,
    getAnchorTarget = function(widget)
      if widget.attachedWidget ~= nil then
        return widget.attachedWidget
      end
      return widget
    end,
    customOffset = {-3, 0}
  },
  [3] = {
    widgetName = "zoneStateInformer",
    getAnchorTarget = function(widget)
      if widget.warStateWindow:IsVisible() then
        return widget.warStateWindow
      end
      return nil
    end,
    customOffset = {0, 3}
  },
  [4] = {
    widgetName = "sextantWindow",
    getAnchorTarget = function(widget)
      if baselibLocale.openedSextant == true and widget.coordinateLabel:IsVisible() == true then
        return widget.coordinateLabel
      end
      return nil
    end,
    customOffset = {-3, 3}
  },
  [5] = {
    widgetName = "instanceRoundFrame",
    getAnchorTarget = function(widget)
      if widget:IsVisible() then
        return widget
      end
      return nil
    end,
    customOffset = {0, 4}
  },
  [6] = {
    widgetName = "alertManager",
    getAnchorTarget = function(widget)
      if widget:HasActiveAlerts() then
        return widget
      end
      return nil
    end
  }
}
local function CreateIndicatorManager()
  local managerWindow = CreateEmptyWindow("indicatorManager", "UIParent")
  managerWindow:SetUILayer("game")
  managerWindow:AddAnchor("TOPRIGHT", "UIParent", 0, 0)
  managerWindow:Show(true)
  local clockBar = CreateClockBar("clockBar", managerWindow)
  local fpsInfo = CreateFpsAlertInfo("fpsInfo", managerWindow)
  local zoneNameInformer = CreateZoneNameInformer(managerWindow)
  local zoneStateInformer = CreateZoneStateInformer(managerWindow)
  local sextantWindow = baselibLocale.openedSextant == true and CreateSextantWindow("sextantWindow", managerWindow) or nil
  local instanceRoundFrame = CreateRoundFrame("roundFrame")
  local alertManager = CreateAlertManager("alertManager", managerWindow)
  local managedIndicators = {}
  managedIndicators.clockBar = clockBar
  managedIndicators.fpsInfo = fpsInfo
  managedIndicators.zoneNameInformer = zoneNameInformer
  managedIndicators.zoneStateInformer = zoneStateInformer
  managedIndicators.sextantWindow = sextantWindow
  managedIndicators.instanceRoundFrame = instanceRoundFrame
  managedIndicators.alertManager = alertManager
  managerWindow.managedIndicators = managedIndicators
  function managerWindow:RunStackRule()
    local SUCCESS = 0
    local TARGET_NIL = 1
    local SOURCE_NIL = 2
    local function TryAttachToTarget(targetIdx, myIdx)
      local targetRule = stackRule[targetIdx]
      local myRule = stackRule[myIdx]
      local targetWidget = self.managedIndicators[targetRule.widgetName]
      local myWidget = self.managedIndicators[myRule.widgetName]
      if myRule.getAnchorSource ~= nil then
        myWidget = myRule.getAnchorSource(myWidget)
      end
      if myWidget == nil then
        return SOURCE_NIL
      end
      local anchorTarget
      if targetRule.getAnchorTarget ~= nil then
        anchorTarget = targetRule.getAnchorTarget(targetWidget)
      else
        anchorTarget = targetWidget
      end
      if anchorTarget == nil or anchorTarget:IsVisible() == false then
        return TARGET_NIL
      end
      myWidget:RemoveAllAnchors()
      local myOffset = myRule.customOffset
      local targetOffset = targetRule.customOffset
      if myOffset ~= nil then
        if targetOffset ~= nil then
          myWidget:AddAnchor("TOPRIGHT", anchorTarget, "BOTTOMRIGHT", myOffset[1] - targetOffset[1], myOffset[2])
        else
          myWidget:AddAnchor("TOPRIGHT", anchorTarget, "BOTTOMRIGHT", myOffset[1], myOffset[2])
        end
      else
        local DEFAULT_OFFSET_Y = 5
        if targetOffset ~= nil then
          myWidget:AddAnchor("TOPRIGHT", anchorTarget, "BOTTOMRIGHT", -targetOffset[1], DEFAULT_OFFSET_Y)
        else
          myWidget:AddAnchor("TOPRIGHT", anchorTarget, "BOTTOMRIGHT", 0, DEFAULT_OFFSET_Y)
        end
      end
      return SUCCESS
    end
    for i = 2, #stackRule do
      for j = i - 1, 1, -1 do
        local attachResult = TryAttachToTarget(j, i)
        if attachResult == SUCCESS or attachResult == SOURCE_NIL then
          break
        end
      end
    end
  end
  managerWindow:RunStackRule()
  return managerWindow
end
local indicatorManager = CreateIndicatorManager()
function GetIndicators()
  return indicatorManager.managedIndicators
end
function RunIndicatorStackRule()
  indicatorManager:RunStackRule()
end
