local SetViewOfModelview = function(id, parent)
  local modelview = parent:CreateChildWidget("modelview", id, 0, true)
  modelview:SetExtent(270, 500)
  local textureSize = 512
  modelview:SetTextureSize(textureSize, textureSize)
  local viewWidth = modelview:GetWidth() * textureSize / modelview:GetHeight()
  modelview:SetModelViewExtent(viewWidth, textureSize)
  modelview:SetModelViewCoords((textureSize - viewWidth) / 2, 0, viewWidth, textureSize)
  local rotateLeft = modelview:CreateChildWidget("button", "rotateLeft", 0, true)
  ApplyButtonSkin(rotateLeft, BUTTON_BASIC.ROTATE_LEFT)
  local rotateRight = modelview:CreateChildWidget("button", "rotateRight", 0, true)
  ApplyButtonSkin(rotateRight, BUTTON_BASIC.ROTATE_RIGHT)
  return modelview
end
function CreateModelview(id, parent)
  local modelview = SetViewOfModelview(id, parent)
  local right = false
  local left = false
  local drag = false
  local mouseX = 0
  local function OnRightMouseLeave()
    right = false
  end
  modelview.rotateRight:SetHandler("OnRightMouseLeave", OnRightMouseLeave)
  local function OnRightMouseUp(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    right = false
  end
  modelview.rotateRight:SetHandler("OnMouseUp", OnRightMouseUp)
  local function OnRightMouseDown(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    right = true
  end
  modelview.rotateRight:SetHandler("OnMouseDown", OnRightMouseDown)
  local function OnLeftMouseLeave()
    left = false
  end
  modelview.rotateLeft:SetHandler("OnLeave", OnLeftMouseLeave)
  local function OnLeftMouseDown(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    left = true
  end
  modelview.rotateLeft:SetHandler("OnMouseDown", OnLeftMouseDown)
  local function OnLeftMouseUp(self, arg)
    if arg ~= "LeftButton" then
      return
    end
    left = false
  end
  modelview.rotateLeft:SetHandler("OnMouseUp", OnLeftMouseUp)
  local function OnDragStart()
    drag = true
    mouseX = X2Input:GetMousePos()
  end
  modelview:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop()
    drag = false
  end
  modelview:SetHandler("OnDragStop", OnDragStop)
  local function OnUpdate(self, dt)
    if drag then
      local newMouseX, _ = X2Input:GetMousePos()
      local value = (newMouseX - mouseX) * 25
      self:AddRotation(value * dt / 1000)
      mouseX = newMouseX
    elseif right == true then
      self:AddRotation(170 * dt / 1000)
    elseif left == true then
      self:AddRotation(-170 * dt / 1000)
    end
  end
  modelview:SetHandler("OnUpdate", OnUpdate)
  return modelview
end
