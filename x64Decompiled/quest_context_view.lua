function MoveWindowTo(target, dst, moveType)
  local finalX, finalY = 0, 0
  local x, y = dst:GetOffset()
  local cx, cy = dst:GetExtent()
  local dx, dy = target:GetExtent()
  local centerX = (x + x + cx) / 2
  local width = UIParent:GetScreenWidth()
  local isLeftSide = centerX < width / 2
  if isLeftSide then
    finalX = x + cx
  else
    finalX = x - dx
  end
  local height = UIParent:GetScreenHeight()
  local isBottomCliped = height < y + dy
  if isBottomCliped then
    finalY = y - (y + dy - height)
  else
    finalY = y
  end
  target:RemoveAllAnchors()
  target:AddAnchor("TOPLEFT", "UIParent", finalX, finalY)
end
questContext = CreateEmptyWindow("questContext", "UIParent")
questContext.notifierGrid = {}
questContext.notifierGrid.height = 300
questContext.notifierGrid.taskMarkInset = {
  -10,
  2,
  0,
  0
}
questContext.notifierGrid.lastRowHeight = 0
