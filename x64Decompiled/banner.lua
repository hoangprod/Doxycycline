local banner
local CreateBanner = function(id, parent)
  local frame = SetViewBanner(id, parent)
  local exitBtn = frame.exitBtn
  local function OnClick()
    frame:ShowBannerClosedWarringDlg()
  end
  ButtonOnClickHandler(exitBtn, OnClick)
  local function OnClick(self)
    ToggleInstanceEntrance(true, 0, frame.selectedInstanceUiKindType, frame.selectedInstance)
  end
  frame.dragWindow:SetHandler("OnClick", OnClick)
  local function OnDragStart(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
    frame:StartMoving()
    self.moving = true
  end
  frame.dragWindow:SetHandler("OnDragStart", OnDragStart)
  local function OnDragStop(self)
    if self.moving == true then
      frame:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  frame.dragWindow:SetHandler("OnDragStop", OnDragStop)
  return frame
end
local function ShowBanner(show, instanceType)
  if show then
    if banner == nil then
      banner = CreateBanner("Banner", "UIParent")
    end
    if not banner:SetData(instanceType) then
      return
    end
    banner:Show(true)
  elseif banner ~= nil then
    banner:Show(false)
  end
end
UIParent:SetEventHandler("SHOW_BANNER", ShowBanner)
