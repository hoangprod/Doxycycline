local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local labelWidth = FORM_SLAVE_INFO_WND.WND_WIDTH - sideMargin * 2
local halfSideMargin = sideMargin / 2
SPEED_INFO_WND_HEIGHT = 65
VEHICLE_INFO_WND_HEIGHT = 145
EQUIPMENT_INFO_WND_HEIGHT = 235
SLAVE_INFO_WND_HEIGHT = 140
local function CreateCommonLine(widget, anchorWidget)
  local line = CreateLine(widget, "TYPE1")
  line:SetColor(1, 1, 1, 0.5)
  if anchorWidget == nil then
    line:AddAnchor("TOPLEFT", widget, 0, halfSideMargin)
    line:AddAnchor("TOPRIGHT", widget, 0, halfSideMargin)
  else
    line:AddAnchor("TOPLEFT", anchorWidget, "BOTTOMLEFT", 0, halfSideMargin)
    line:AddAnchor("TOPRIGHT", anchorWidget, "BOTTOMRIGHT", 0, halfSideMargin)
  end
  return line
end
local function CreateComomnTextField(widget, itemName, titleText, anchorWidget)
  local title = widget:CreateChildWidget("label", itemName .. "Title", 0, true)
  title:SetExtent(labelWidth * FORM_SLAVE_INFO_WND.WIDTH_RATIO.TITLE, FONT_SIZE.MIDDLE)
  title.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  title:AddAnchor("TOPLEFT", anchorWidget, "BOTTOMLEFT", 0, halfSideMargin)
  title:SetText(titleText)
  local value = widget:CreateChildWidget("label", itemName, 0, true)
  value:SetExtent(labelWidth * FORM_SLAVE_INFO_WND.WIDTH_RATIO.VALUE, FONT_SIZE.MIDDLE)
  value.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(value, FONT_COLOR.DEFAULT)
  value:AddAnchor("LEFT", title, "RIGHT", 0, 0)
end
local function CreateSpeedInfoPart(id, parent)
  local widget = parent:CreateChildWidget("emptyWidget", id, 0, true)
  local line = CreateCommonLine(widget)
  CreateComomnTextField(widget, "moveSpeed", locale.slave.move_speed, line)
  CreateComomnTextField(widget, "turnSpeed", locale.slave.turn_speed, widget.moveSpeedTitle)
  return widget
end
local function CreateVehicleInfoPart(id, parent)
  local widget = parent:CreateChildWidget("emptyWidget", id, 0, true)
  local line = CreateCommonLine(widget)
  CreateComomnTextField(widget, "moveSpeed", locale.slave.move_speed, line)
  CreateComomnTextField(widget, "turnSpeed", locale.slave.turn_speed, widget.moveSpeedTitle)
  local line2 = CreateCommonLine(widget, widget.turnSpeedTitle)
  CreateComomnTextField(widget, "gear", locale.slave.titleGear, line2)
  ApplyTextColor(widget.gear, FONT_COLOR.BLUE)
  CreateComomnTextField(widget, "brake", locale.slave.titleBrake, widget.gearTitle)
  CreateComomnTextField(widget, "tractionCtrl", locale.slave.titleTractionCtrl, widget.brakeTitle)
  return widget
end
local function CreateShipInfoPart(id, parent)
  local widget = parent:CreateChildWidget("emptyWidget", id, 0, true)
  local line = CreateCommonLine(widget)
  local blueColor = FONT_COLOR_HEX.SKYBLUE
  CreateComomnTextField(widget, "health", locale.attribute("health"), line)
  CreateComomnTextField(widget, "siegeDmgReduce", X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "incoming_siege_damage_mul"), widget.healthTitle)
  widget.siegeDmgReduceTitle.tooltip = GetCommonText("slave_tooltip_of_incoming_siege_damage_mul")
  local line2 = CreateCommonLine(widget, widget.siegeDmgReduceTitle)
  CreateComomnTextField(widget, "weight", locale.attribute("mass"), line2)
  CreateComomnTextField(widget, "collisionDmg", GetCommonText("ship_collision_damage"), widget.weightTitle)
  widget.collisionDmgTitle.tooltip = GetCommonText("ship_collision_damage_tooltip", blueColor)
  CreateComomnTextField(widget, "collisionAmr", GetCommonText("ship_collision_armor"), widget.collisionDmgTitle)
  widget.collisionAmrTitle.tooltip = GetCommonText("ship_collision_armor_tooltip", blueColor)
  CreateComomnTextField(widget, "moveSpeed", locale.slave.move_speed, widget.collisionAmrTitle)
  CreateComomnTextField(widget, "turnSpeed", locale.slave.turn_speed, widget.moveSpeedTitle)
  CreateComomnTextField(widget, "passengers", GetCommonText("passengers"), widget.turnSpeedTitle)
  local collisionGuide = widget:CreateChildWidget("label", "collisionGuide", 0, true)
  collisionGuide:AddAnchor("BOTTOMLEFT", widget, 0, 0)
  collisionGuide:SetHeight(FONT_SIZE.LARGE)
  collisionGuide:SetAutoResize(true)
  collisionGuide:SetText(GetCommonText("ship_collision"))
  collisionGuide.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(collisionGuide, FONT_COLOR.DEFAULT)
  local collisionGuidBtn = W_ICON.CreateGuideIconWidget(widget)
  collisionGuidBtn:AddAnchor("LEFT", collisionGuide, "RIGHT", 5, 0)
  collisionGuidBtn.tooltip = GetCommonText("ship_collision_tooltip", blueColor)
  widget.collisionGuidBtn = collisionGuidBtn
  local OnEnter = function(self)
    SetTooltip(self.tooltip, self, false)
  end
  widget.siegeDmgReduceTitle:SetHandler("OnEnter", OnEnter)
  widget.collisionDmgTitle:SetHandler("OnEnter", OnEnter)
  widget.collisionAmrTitle:SetHandler("OnEnter", OnEnter)
  collisionGuidBtn:SetHandler("OnEnter", OnEnter)
  local toggleBtn = widget:CreateChildWidget("button", "toggleBtn", 0, true)
  toggleBtn:SetText(GetCommonText("equipment_info"))
  ApplyButtonSkin(toggleBtn, BUTTON_BASIC.DEFAULT)
  toggleBtn:AddAnchor("BOTTOMRIGHT", widget, 0, 0)
  local equipmentWnd = CreateSlaveEquipmentWnd("equipmentWnd", widget)
  equipmentWnd:AddAnchor("TOPLEFT", parent, "TOPRIGHT", 5, 0)
  widget.equipmentWnd = equipmentWnd
  function equipmentWnd:ShowProc()
    X2Item:EnterSlaveEquipChangeMode()
  end
  function equipmentWnd:OnHide()
    X2Item:LeaveSlaveEquipChangeMode()
  end
  equipmentWnd:SetHandler("OnHide", equipmentWnd.OnHide)
  function toggleBtn:OnClick()
    equipmentWnd:Show(not equipmentWnd:IsVisible())
  end
  toggleBtn:SetHandler("OnClick", toggleBtn.OnClick)
  return widget
end
function SetViewOfSlaveInfoFrame(id, parent)
  local width = FORM_SLAVE_INFO_WND.WND_WIDTH
  local height = SLAVE_INFO_WND_HEIGHT
  local leftInset = 10
  local leftInset = 10
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local labelWidth = width - sideMargin * 2
  local window = CreateWindow(id, parent)
  window:SetExtent(width, height)
  window:Show(false)
  window:SetTitle(locale.slave.title)
  local name = window:CreateChildWidget("label", "name", 0, true)
  name.style:SetAlign(ALIGN_LEFT)
  name:AddAnchor("TOPLEFT", window, sideMargin, 60)
  name:SetExtent(labelWidth, 15)
  ApplyTextColor(name, FONT_COLOR.DEFAULT)
  local bg = CreateContentBackground(name, "TYPE8", "brown_2")
  bg:AddAnchor("TOPLEFT", name, -sideMargin, -sideMargin)
  bg:AddAnchor("BOTTOMRIGHT", name, halfSideMargin, halfSideMargin)
  name.bg = bg
  CreateComomnTextField(window, "kind", locale.slave.kind, name)
  CreateComomnTextField(window, "class", locale.slave.class, window.kindTitle)
  local speedInfoPart = CreateSpeedInfoPart("speedInfoPart", window)
  speedInfoPart:AddAnchor("TOPLEFT", window.classTitle, "BOTTOMLEFT", 0, 0)
  speedInfoPart:SetExtent(labelWidth, SPEED_INFO_WND_HEIGHT)
  speedInfoPart:Show(false)
  local vehicleInfoPart = CreateVehicleInfoPart("vehicleInfoPart", window)
  vehicleInfoPart:AddAnchor("TOPLEFT", window.classTitle, "BOTTOMLEFT", 0, 0)
  vehicleInfoPart:SetExtent(labelWidth, VEHICLE_INFO_WND_HEIGHT)
  vehicleInfoPart:Show(false)
  local shipInfoPart = CreateShipInfoPart("shipInfoPart", window)
  shipInfoPart:AddAnchor("TOPLEFT", window.classTitle, "BOTTOMLEFT", 0, 0)
  shipInfoPart:SetExtent(labelWidth, EQUIPMENT_INFO_WND_HEIGHT)
  shipInfoPart:Show(false)
  window:AddAnchor("CENTER", parent, 0, 0)
  return window
end
