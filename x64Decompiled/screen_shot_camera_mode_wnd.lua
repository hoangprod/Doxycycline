function CreateScreenShotModeFrame(id)
  local frame = CreateEmptyWindow(id, "UIParent")
  frame:Show(false)
  frame:SetExtent(400, 310)
  frame:AddAnchor("BOTTOMRIGHT", -10, -20)
  local bg = CreateContentBackground(frame, "TYPE2", "white_2")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  frame.inset = {
    left = sideMargin,
    right = 75,
    item_left = 50
  }
  local titleBar = CreateTitleBar(frame:GetId() .. ".titleBar", frame)
  titleBar.closeButton:RemoveAllAnchors()
  titleBar.closeButton:AddAnchor("TOPRIGHT", titleBar, -12, 12)
  titleBar:SetTitleInset(frame.inset.left, sideMargin / 2, 0, 0)
  titleBar.titleStyle:SetAlign(ALIGN_LEFT)
  titleBar.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  titleBar:SetTitleText(locale.screenShotMode.title)
  ChangeButtonSkin(titleBar.closeButton, BUTTON_CONTENTS.SCREENSHOT_MODE_CLOSE)
  ApplyTitleFontColor(titleBar, FONT_COLOR.BLACK)
  frame.titleBar = titleBar
  frame.item = {}
  local itemTextTable = {
    locale.screenShotMode.screenShotModeToggle,
    locale.screenShotMode.item_1,
    locale.screenShotMode.dofToggle,
    locale.screenShotMode.item_2,
    locale.screenShotMode.bokehToggle,
    locale.screenShotMode.item_3,
    locale.screenShotMode.item_4
  }
  local offsetY = titleMargin
  frame.width = {item = 180, item_value = 150}
  local GetTipText = function(index)
    if index == 4 then
      return locale.screenShotMode.dofTip
    elseif index == 7 then
      return locale.screenShotMode.bokehTip
    end
  end
  local function CreateTipTextbox(parent, text)
    local tip = parent:CreateChildWidget("textbox", "tip", 0, true)
    tip:SetWidth(300)
    tip:SetText(text)
    tip:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    tip.style:SetFontSize(FONT_SIZE.SMALL)
    tip.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(tip, FONT_COLOR.GRAY)
    tip:AddAnchor("TOPLEFT", parent, "BOTTOMLEFT", 0, sideMargin / 1.5)
    local height = tip:GetTextHeight()
    tip:SetHeight(height)
  end
  for i = 1, #itemTextTable do
    local item = frame:CreateChildWidget("textbox", "item", i, true)
    item:AddAnchor("TOPLEFT", frame, frame.inset.left + 10, offsetY)
    item:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
    item:SetWidth(frame.width.item)
    item.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(item, FONT_COLOR.BLACK)
    if i == 1 or i == 2 or i == 3 or i == 5 then
      item.style:SetFontSize(FONT_SIZE.LARGE)
    end
    if i == 3 or i == 5 then
      local line = CreateLine(item, "TYPE1")
      line:SetWidth(frame.width.item + frame.width.item_value)
      line:AddAnchor("BOTTOMLEFT", item, "TOPLEFT", -sideMargin, -sideMargin / 2)
      line:SetColor(0, 0, 0, 0.3)
    end
    if i == 2 or i == 4 then
      offsetY = offsetY + sideMargin / 1.8
    end
    local itemText = ""
    for j = 1, #itemTextTable[i] do
      itemText = string.format("%s%s\n", itemText, itemTextTable[i][j])
    end
    item:SetText(itemText)
    item:SetHeight(item:GetTextHeight())
    if i == 4 or i == 7 then
      CreateTipTextbox(item, GetTipText(i))
      offsetY = offsetY + item.tip:GetTextHeight() + sideMargin
    end
    offsetY = offsetY + item:GetTextHeight() + sideMargin / 2
  end
  frame:SetExtent(360, offsetY + sideMargin)
  frame.item_value = {}
  for i = 1, #itemTextTable do
    local item_value = frame:CreateChildWidget("textbox", "item_value", i, true)
    item_value:AddAnchor("LEFT", frame.item[i], "RIGHT", sideMargin / 2, 0)
    item_value:SetHeight(frame.item[i]:GetHeight())
    item_value:SetWidth(frame.width.item_value)
    item_value:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
    item_value.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(item_value, FONT_COLOR.BLUE)
  end
  function frame:GetItemValueLongestWidth()
    local width = 0
    for i = 1, #self.item_value do
      local itemValueWidth = self.item_value[i]:GetLongestLineWidth()
      if width < itemValueWidth then
        width = itemValueWidth
      end
    end
    return width + 10
  end
  function frame:UpdateBinding()
    local PRIMARY_HOTKEY_MANAGER = 1
    local function GetItemValueText(valueTable)
      local str = ""
      for i = 1, #valueTable do
        str = string.upper(string.format("%s%s\n", str, X2Hotkey:GetBinding(valueTable[i], PRIMARY_HOTKEY_MANAGER) or ""))
      end
      return str
    end
    local item_value1 = {
      "screenshotcamera"
    }
    self.item_value[1]:SetText(GetItemValueText(item_value1))
    local moveforward_key = X2Hotkey:GetBinding("moveforward", PRIMARY_HOTKEY_MANAGER) or ""
    local moveback_key = X2Hotkey:GetBinding("moveback", PRIMARY_HOTKEY_MANAGER) or ""
    local turnleft_key = X2Hotkey:GetBinding("turnleft", PRIMARY_HOTKEY_MANAGER) or ""
    local turnright_key = X2Hotkey:GetBinding("turnright", PRIMARY_HOTKEY_MANAGER) or ""
    local move_str = string.format("[%s] [%s] [%s] [%s]", string.upper(moveforward_key), string.upper(moveback_key), string.upper(turnleft_key), string.upper(turnright_key))
    self.item_value[2]:SetText(string.format([[
%s
%s]], move_str, locale.screenShotMode.mouse_wheel))
    local item_value3 = {"dof_toggle"}
    self.item_value[3]:SetText(GetItemValueText(item_value3))
    local item_value4 = {
      "dof_auto_focus",
      "dof_add_dist",
      "dof_sub_dist",
      "dof_add_range",
      "dof_sub_range"
    }
    self.item_value[4]:SetText(GetItemValueText(item_value4))
    local item_value5 = {
      "dof_bokeh_toggle"
    }
    self.item_value[5]:SetText(GetItemValueText(item_value5))
    local item_value6 = {
      "dof_bokeh_add_size",
      "dof_bokeh_sub_size",
      "dof_bokeh_add_intensity",
      "dof_bokeh_sub_intensity"
    }
    self.item_value[6]:SetText(GetItemValueText(item_value6))
    local item_value7 = {
      "dof_bokeh_circle",
      "dof_bokeh_hexagon",
      "dof_bokeh_heart",
      "dof_bokeh_star"
    }
    self.item_value[7]:SetText(GetItemValueText(item_value7))
    local longestWidth = self:GetItemValueLongestWidth()
    for i = 1, #self.item_value do
      self.item_value[i]:SetWidth(longestWidth)
    end
    self:SetWidth(self.width.item + longestWidth + sideMargin * 3)
  end
  return frame
end
local screenShotCameraModeFrame = CreateScreenShotModeFrame("screenShotCameraModeFrame")
local function ShowScreenShotCameraModeWnd()
  screenShotCameraModeFrame:Show(true)
  screenShotCameraModeFrame:UpdateBinding()
end
local events = {
  ENTERED_SCREEN_SHOT_CAMERA_MODE = function()
    ShowScreenShotCameraModeWnd()
  end,
  LEFT_SCREEN_SHOT_CAMERA_MODE = function()
    screenShotCameraModeFrame:Show(false)
  end,
  ENTERED_WORLD = function()
    if X2Camera:IsScreenShotCameraMode() == true then
      ShowScreenShotCameraModeWnd()
    end
  end,
  UPDATE_BINDINGS = function()
    screenShotCameraModeFrame:UpdateBinding()
  end
}
screenShotCameraModeFrame:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(screenShotCameraModeFrame, events)
