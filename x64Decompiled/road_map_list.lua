roadmap:InitMapData()
function UpdateRoadmapAnchor(file, key)
  local imgData = GetTextureInfo(file, key)
  if imgData then
    local offset = imgData:GetOffset()
    local coords = {
      imgData:GetCoords()
    }
    local extentX, extentY = roadmapWindow:GetExtent()
    local anchorX = extentX - (offset[1] + (coords[3] - coords[1]))
    local anchorY = offset[2]
    roadmapWindow:RemoveAllAnchors()
    roadmapWindow:AddAnchor("TOPRIGHT", "UIParent", "TOPRIGHT", ROADMAP_OFFSET_X + anchorX, ROADMAP_OFFSET_Y - anchorY)
  end
end
