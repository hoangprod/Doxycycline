local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
roadmapOptionButton = {}
ROADMAP_OPTION_OFFSET_X = -182
ROADMAP_OPTION_OFFSET_Y = 2
local function CreateRoadMapOptionButton(id)
  local wnd = CreateEmptyWindow(id .. "Window", "UIParent")
  wnd:Show(true)
  wnd:SetExtent(22, 22)
  wnd:AddAnchor("TOPRIGHT", "UIParent", ROADMAP_OPTION_OFFSET_X, ROADMAP_OPTION_OFFSET_Y)
  local btn = CreateEmptyButton(id, wnd)
  btn:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyButtonSkin(btn, BUTTON_HUD.ROAD_MAP_OPTION)
  local function CreateRoadMapOptionWindow(id, parent)
    local optWnd = CreateSubOptionWindow(id, parent)
    optWnd:Show(false)
    optWnd:SetExtent(100, 100)
    optWnd:AddAnchor("TOPRIGHT", parent, "BOTTOMRIGHT", 3, 3)
    local ableChecks = {}
    local chk1 = CreateCheckButton(id .. ".checkButton", optWnd, locale.clock.visibleRodemap)
    chk1:SetButtonStyle("soft_brown")
    chk1:AddAnchor("TOPLEFT", optWnd, sideMargin - 5, sideMargin - 5)
    chk1:SetChecked(false)
    optWnd.chk1 = chk1
    table.insert(ableChecks, chk1)
    local chk2 = CreateCheckButton(id .. ".checkButton2", optWnd, locale.clock.visibleRoadmapIcon)
    chk2:SetButtonStyle("soft_brown")
    chk2:AddAnchor("TOPLEFT", chk1, "BOTTOMLEFT", 0, sideMargin / 3.5)
    chk2:SetChecked(false)
    optWnd.chk2 = chk2
    table.insert(ableChecks, chk2)
    local chk3 = CreateCheckButton(id .. ".checkButton3", optWnd, GetCommonText("show_my_sextant"))
    chk3:SetButtonStyle("soft_brown")
    chk3:AddAnchor("TOPLEFT", chk2, "BOTTOMLEFT", 0, sideMargin / 3.5)
    chk3:SetChecked(false)
    optWnd.chk3 = chk3
    local nextChk = chk3
    if baselibLocale.openedSextant then
      chk3:Show(true)
      table.insert(ableChecks, chk3)
    else
      chk3:Show(false)
      nextChk = chk2
    end
    local _, height = F_LAYOUT.GetExtentWidgets(chk1, nextChk)
    local width = 0
    for i = 1, #ableChecks do
      local textWidth = ableChecks[i].textButton:GetWidth()
      if width < textWidth then
        width = textWidth
      end
    end
    width = width + ableChecks[1]:GetWidth() + MARGIN.WINDOW_SIDE * 1.5
    optWnd:SetExtent(width, height + MARGIN.WINDOW_SIDE * 1.5)
    return optWnd
  end
  btn.wnd = CreateRoadMapOptionWindow("RoadmapOptionWindow", wnd)
  return btn
end
local CreateRoadMapPingButton = function(id, anchorWnd)
  local wnd = CreateEmptyWindow(id .. "Window", "UIParent")
  wnd:Show(true)
  wnd:SetExtent(30, 22)
  wnd:AddAnchor("RIGHT", anchorWnd, "LEFT", 0, 0)
  local PingBtn = CreateEmptyButton(id, wnd)
  PingBtn:AddAnchor("TOPLEFT", wnd, 0, 0)
  ApplyButtonSkin(PingBtn, BUTTON_HUD.ROAD_MAP_DRAWING)
  local CreateRoadMapDrawWindow = function(id, parent)
    local drawWnd = CreateSubOptionWindow(id, parent)
    drawWnd:Show(false)
    drawWnd:SetExtent(220, 40)
    drawWnd:AddAnchor("TOPRIGHT", parent, "BOTTOMRIGHT", 3, 3)
    drawWnd.btn = {}
    local pingBtn = drawWnd:CreateChildWidget("button", "pingBtn", 0, true)
    ApplyButtonSkin(pingBtn, BUTTON_CONTENTS.MAP_PING_BTN)
    pingBtn:AddAnchor("TOPLEFT", drawWnd, 5, 5)
    drawWnd.btn[PING_TYPE_PING] = pingBtn
    local OnEnter = function(self)
      local msg = string.format("%s", GetCommonText("roadmap_ping_position", tostring("|cFF7bf545")))
      SetTooltip(msg, self)
    end
    pingBtn:SetHandler("OnEnter", OnEnter)
    local enemyBtn = drawWnd:CreateChildWidget("button", "enemyBtn", 0, true)
    ApplyButtonSkin(enemyBtn, BUTTON_CONTENTS.MAP_ENEMY_BTN)
    enemyBtn:AddAnchor("TOPLEFT", pingBtn, "TOPRIGHT", 2, 0)
    drawWnd.btn[PING_TYPE_ENEMY] = enemyBtn
    local OnEnter = function(self)
      local msg = string.format("%s", GetCommonText("roadmap_ping_enemy"))
      SetTooltip(msg, self)
    end
    enemyBtn:SetHandler("OnEnter", OnEnter)
    local attackBtn = drawWnd:CreateChildWidget("button", "attackBtn", 0, true)
    ApplyButtonSkin(attackBtn, BUTTON_CONTENTS.MAP_ATTACK_BTN)
    attackBtn:AddAnchor("TOPLEFT", enemyBtn, "TOPRIGHT", 2, 0)
    drawWnd.btn[PING_TYPE_ATTACK] = attackBtn
    local OnEnter = function(self)
      local msg = string.format("%s", GetCommonText("roadmap_ping_attack"))
      SetTooltip(msg, self)
    end
    attackBtn:SetHandler("OnEnter", OnEnter)
    local lineBtn = drawWnd:CreateChildWidget("button", "lineBtn", 0, true)
    ApplyButtonSkin(lineBtn, BUTTON_CONTENTS.MAP_LINE_BTN)
    lineBtn:AddAnchor("TOPLEFT", attackBtn, "TOPRIGHT", 8, 0)
    drawWnd.btn[PING_TYPE_LINE] = lineBtn
    local OnEnter = function(self)
      local msg = string.format("%s", GetCommonText("roadmap_ping_line", tostring("|cFF7bf545")))
      SetTooltip(msg, self)
    end
    lineBtn:SetHandler("OnEnter", OnEnter)
    local eraserBtn = drawWnd:CreateChildWidget("button", "eraserBtn", 0, true)
    ApplyButtonSkin(eraserBtn, BUTTON_CONTENTS.MAP_ERASER_BTN)
    eraserBtn:AddAnchor("TOPLEFT", lineBtn, "TOPRIGHT", 8, 0)
    drawWnd.btn[PING_TYPE_ERASER] = eraserBtn
    local OnEnter = function(self)
      local msg = string.format("%s", GetCommonText("roadmap_ping_del", tostring("|cFF7bf545")))
      SetTooltip(msg, self)
    end
    eraserBtn:SetHandler("OnEnter", OnEnter)
    return drawWnd
  end
  PingBtn.wnd = CreateRoadMapDrawWindow("RoadmapDrawWindow", wnd)
  return PingBtn
end
local CreateRoadMapSizeButton = function(id, parent, anchorWnd)
  local button = CreateEmptyButton(id, parent)
  button.style:SetAlign(ALIGN_CENTER)
  button:AddAnchor("RIGHT", anchorWnd, "LEFT", 0, 0)
  ApplyButtonSkin(button, BUTTON_HUD.ROAD_SIZE_OPTION)
  button:Enable(false)
  return button
end
roadmapOptionButton = CreateRoadMapOptionButton("roadmapOptionButton")
roadmapPingButton = CreateRoadMapPingButton("roadmapPingButton", roadmapOptionButton)
roadmapSizeButton = CreateRoadMapSizeButton("roadmapSizeButton", roadmapOptionButton, roadmapPingButton)
