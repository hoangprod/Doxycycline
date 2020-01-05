ANCHOR_ORDER = {
  CENTER = 1,
  TOP = 2,
  BOTTOM = 3,
  MAX = 4
}
AnchorManager = {}
AnchorManager.infos = {}
function AnchorManager:Exist(key)
  local info = self.infos[key]
  return info ~= nil
end
function AnchorManager:Register(key, offset)
  self.infos[key] = {
    target = {
      [ANCHOR_ORDER.CENTER] = nil,
      [ANCHOR_ORDER.TOP] = nil,
      [ANCHOR_ORDER.BOTTOM] = nil
    },
    offset = offset
  }
end
function AnchorManager:Unregister(key, widget)
  local info = self.infos[key]
  if info == nil then
    return
  end
  for key, value in pairs(info.target) do
    if value == widget then
      info.target[key] = nil
      return
    end
  end
end
function AnchorManager:Place(key, widget)
  local info = self.infos[key]
  if info == nil then
    return
  end
  for i = 1, ANCHOR_ORDER.MAX - 1 do
    local offset = info.offset[i]
    if info.target[i] == nil then
      info.target[i] = widget
      widget:RemoveAllAnchors()
      widget:AddAnchor("RIGHT", offset.x, offset.y)
      return
    end
  end
end
