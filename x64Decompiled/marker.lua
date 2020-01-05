W_MARKER = {}
W_MARKER.MARKER_KEY = {
  "mark_01",
  "mark_02",
  "mark_03",
  "mark_04",
  "mark_05",
  "mark_06",
  "mark_07",
  "mark_08",
  "mark_09",
  "mark_heart",
  "mark_star",
  "mark_x"
}
if #W_MARKER.MARKER_KEY < 1 or #W_MARKER.MARKER_KEY > MAX_OVER_HEAD_MARKER then
  UIParent:LogAlways("[UI ERROR] W_MARKER.MARKER_KEY has invalid count(%d), please check.", #W_MARKER.MARKER_KEY)
end
function W_MARKER.GetMarkerTextureKey(index)
  if index == nil then
    return
  end
  if tonumber(index) < 1 or tonumber(index) > MAX_OVER_HEAD_MARKER then
    return
  end
  return W_MARKER.MARKER_KEY[index]
end
function W_MARKER.GetMarkerTexture(index)
  local key = W_MARKER.GetMarkerTextureKey(index)
  if key == nil then
    return
  end
  return GetTextureInfo(TEXTURE_PATH.MAP_ICON, key)
end
function W_MARKER.SetMarkerTexture(drawable, index, size)
  if drawable == nil then
    return false
  end
  if index == nil then
    return false
  end
  local key = W_MARKER.GetMarkerTextureKey(index)
  if key == nil then
    return false
  end
  drawable:SetTextureInfo(key)
  if size ~= nil then
    drawable:SetExtent(size, size)
  end
  return true
end
local SetViewOfMarker = function(parent)
  local marker = parent:CreateDrawable(TEXTURE_PATH.MAP_ICON, "mark_01", "overlay")
  marker:SetVisible(false)
  return marker
end
function W_MARKER.CreateMarker(parent)
  marker = SetViewOfMarker(parent)
  function marker:SetMarker(index, size)
    return W_MARKER.SetMarkerTexture(self, index, size)
  end
  return marker
end
