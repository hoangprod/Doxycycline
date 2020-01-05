local screenResolution = X2:GetCharacterUiData("screenResolution")
local matchedResolution
if screenResolution == nil then
  screenResolution = {}
  screenResolution.x = UIParent:GetScreenWidth()
  screenResolution.y = UIParent:GetScreenHeight()
  matchedResolution = false
elseif screenResolution.x ~= UIParent:GetScreenWidth() or screenResolution.y ~= UIParent:GetScreenHeight() then
  screenResolution.x = UIParent:GetScreenWidth()
  screenResolution.y = UIParent:GetScreenHeight()
  matchedResolution = false
else
  matchedResolution = true
end
function Global_IsMatchedResolution()
  return matchedResolution
end
X2:SetCharacterUiData("screenResolution", screenResolution)
local MakeUIboundKey = function(key)
  return string.format("ui_bound_%s", key)
end
function IsValidBoundInfo(info)
  if info == nil then
    return false
  end
  if info.bound == nil then
    return false
  end
  if info.screenResolution == nil then
    return false
  end
  return true
end
function IsMatchedResolution(resolution)
  if resolution.x ~= UIParent:GetScreenWidth() or resolution.y ~= UIParent:GetScreenHeight() then
    return false
  end
  return true
end
local uiSaveHandlers = {}
function AddUISaveHandlerByKey(key, window, checkResolution)
  if checkResolution == nil then
    checkResolution = true
  end
  key = MakeUIboundKey(key)
  local isExist = UIParent:GetUIBound(key)
  if isExist then
    window.isMoved = true
  end
  uiSaveHandlers[key] = window
  function window:OnMovedPosition()
    self.isMoved = true
    self:SaveBound()
    if self.ProcMovedSize ~= nil then
      self:ProcMovedSize()
    end
  end
  window:SetHandler("OnMovedPosition", window.OnMovedPosition)
  function window:SaveBound()
    if not self.isMoved then
      return
    end
    local bound = {}
    bound.x, bound.y = self:GetEffectiveOffset()
    bound.width, bound.height = self:GetExtent()
    local screenRes = {}
    screenRes.x = UIParent:GetScreenWidth()
    screenRes.y = UIParent:GetScreenHeight()
    screenRes.scale = UIParent:GetUIScale()
    local info = {}
    info.bound = bound
    info.screenResolution = screenRes
    UIParent:SetUIBound(key, info)
  end
  function window:GetLastWindowBound()
    return UIParent:GetUIBound(key)
  end
  function window:ApplyLastWindowOffset()
    local info = self:GetLastWindowBound()
    if IsValidBoundInfo(info) == false then
      self:SaveBound()
      return
    end
    if checkResolution == true and not IsMatchedResolution(info.screenResolution) then
      if self.ProcCorrectOffset ~= nil then
        self:ProcCorrectOffset(info)
      end
      self:SaveBound()
      return
    end
    local bound = info.bound
    self:RemoveAllAnchors()
    local IsUINotScaled = function(w)
      local curex, curey = w:GetEffectiveOffset()
      local curx, cury = w:GetOffset()
      return curex == curx and curey == cury
    end
    if IsUINotScaled(self) then
      self:AddAnchor("TOPLEFT", "UIParent", bound.x, bound.y)
    else
      self:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(bound.x), F_LAYOUT.CalcDontApplyUIScale(bound.y))
    end
  end
  function window:ApplyLastWindowExtent()
    local info = self:GetLastWindowBound()
    if IsValidBoundInfo(info) == false then
      self:SaveBound()
      return
    end
    if checkResolution == true and not IsMatchedResolution(info.screenResolution) then
      self:SaveBound()
      return
    end
    local bound = info.bound
    self:SetExtent(bound.width, bound.height)
  end
  function window:ApplyLastWindowBound()
    local info = self:GetLastWindowBound()
    if IsValidBoundInfo(info) == false then
      self:SaveBound()
      return
    end
    if checkResolution == true and not IsMatchedResolution(info.screenResolution) then
      if self.ProcCorrectBound ~= nil then
        self:ProcCorrectBound(info)
      end
      self:SaveBound()
      return
    end
    local bound = info.bound
    self:RemoveAllAnchors()
    self:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(bound.x), F_LAYOUT.CalcDontApplyUIScale(bound.y))
    self:SetExtent(bound.width, bound.height)
  end
end
function ClearUISaveHandlers()
  if ActionBar_InitValues ~= nil then
    ActionBar_InitValues(true)
  end
  if F_ACTIONBAR.RelocationDockingWindow ~= nil then
    F_ACTIONBAR.RelocationDockingWindow()
  end
  for key, window in next, uiSaveHandlers, nil do
    if window and window:IsValidUIObject() and window.MakeOriginWindowPos then
      window:MakeOriginWindowPos(true)
    end
    UIParent:ClearUIBound(key)
    window.isMoved = false
  end
end
