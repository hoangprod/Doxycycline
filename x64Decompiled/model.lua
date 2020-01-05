local SetViewOfDyeingModelWindow = function(id, parent)
  local modelWindow = CreateWindow(id, parent)
  modelWindow:SetExtent(300, 600)
  modelWindow:AddAnchor("CENTER", "UIParent", 0, 0)
  modelWindow:SetTitle(GetUIText(COMMON_TEXT, "preview_dyeing"))
  modelWindow.titleBar.closeButton:Show(false)
  local decoBg = modelWindow:CreateDrawable("ui/dialog/dyeing.dds", "bg", "artwork")
  local modelView = CreateModelview("modelView", modelWindow)
  modelView:AddAnchor("TOP", modelWindow.titleBar, "BOTTOM", 0, 0)
  modelView.rotateLeft:AddAnchor("RIGHT", modelView, 0, 0)
  modelView.rotateRight:AddAnchor("LEFT", modelView, 0, 0)
  modelWindow.modelView = modelView
  decoBg:AddAnchor("CENTER", modelView, 0, 40)
  return modelWindow
end
function CreateDyeingModelWindow(id, parent)
  local window = SetViewOfDyeingModelWindow(id, parent)
  local info = {}
  function window:SetDyeingSample(lookType, itemGrade, r, g, b)
    info.lookType = lookType
    info.itemGrade = itemGrade
    self:UpdateColor(r, g, b)
    self.modelView:ApplyModel()
    self.modelView:PlayAnimation(RELAX_ANIMATION_NAME, true)
    self.modelView:EquipCostume(info.lookType, info.itemGrade, r, g, b)
  end
  function window:UpdateColor(r, g, b)
    if info == nil then
      return
    end
    self.modelView:UpdateDyeColor(r, g, b)
  end
  function window:ShowProc()
    self.modelView:Init("player", false)
    self.modelView:UnequipItemSlot(ES_BACKPACK)
    self.modelView:SetIngameShopMode(true)
    local adjust = GetAdjustCamera(X2Unit:UnitRace("player"), X2Unit:UnitGender("player"))
    if adjust ~= nil then
      self.modelView:AdjustCameraPos(adjust.center, adjust.zoom, adjust.height)
    end
  end
  local function OnHide()
    window.modelView:StopAnimation()
    window.modelView:ClearModel()
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
