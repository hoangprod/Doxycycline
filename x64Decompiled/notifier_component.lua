local CreateNotifierTaskMark = function(id, parent)
  local taskMark = parent:CreateChildWidget("button", id, 0, true)
  taskMark:Show(false)
  ApplyButtonSkin(taskMark, BUTTON_HUD.QUEST_TASK_MARKER)
  return taskMark
end
function CreateNotifierNavigation(id, parent)
  local frame = UIParent:CreateWidget("emptywidget", id, parent)
  frame:SetExtent(33, 40)
  local bg = frame:CreateDrawable(TEXTURE_PATH.QUEST_NOTIFIER, "circle", "background")
  bg:SetVisible(false)
  bg:SetWidth(bg:GetWidth())
  bg:AddAnchor("CENTER", frame, 1, 0)
  frame.bg = bg
  local distance = frame:CreateChildWidget("label", "distance", 0, true)
  distance:Show(false)
  distance:SetAutoResize(true)
  distance:SetHeight(FONT_SIZE.SMALL)
  distance:AddAnchor("TOP", frame, "BOTTOM", 2, 0)
  distance.style:SetShadow(true)
  ApplyTextColor(distance, FONT_COLOR.SOFT_YELLOW)
  local farDistance = frame:CreateChildWidget("emptywidget", "farDistance", 0, true)
  farDistance:Show(false)
  farDistance:AddAnchor("TOP", frame, "BOTTOM", 1, -3)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "quest_far_distance"), self)
  end
  farDistance:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  farDistance:SetHandler("OnLeave", OnLeave)
  local icon = farDistance:CreateDrawable(TEXTURE_PATH.QUEST_NOTIFIER, "transport", "background")
  icon:AddAnchor("CENTER", farDistance, 0, 0)
  farDistance:SetExtent(icon:GetExtent())
  local chk = CreateCheckButton("chk", parent)
  chk:SetAlpha(0)
  chk:SetButtonStyle("quest_notifier")
  chk:AddAnchor("CENTER", bg, 2, 0)
  frame.chk = chk
  local dingbat = frame:CreateImageDrawable(TEXTURE_PATH.MAP_ICON, "overlay")
  dingbat:AddAnchor("CENTER", bg, 0, 0)
  frame.dingbat = dingbat
  local arrow = frame:CreateEffectDrawable(TEXTURE_PATH.QUEST_NOTIFIER, "overlay")
  local coords = UIParent:GetTextureData(TEXTURE_PATH.QUEST_NOTIFIER, "direction").coords
  arrow:SetVisible(false)
  arrow:SetCoords(coords[1], coords[2], coords[3], coords[4])
  arrow:SetExtent(coords[3], coords[4])
  arrow:AddAnchor("CENTER", bg, 0, 0)
  arrow:SetEffectPriority(1, "alpha", 0, 0)
  arrow:SetEffectInitialColor(1, 1, 1, 1, 1)
  arrow:SetEffectFinalColor(1, 1, 1, 1, 1)
  arrow:SetMoveEffectType(1, "circle", 1.1, 1.4, 0.3, 0.1)
  frame.arrow = arrow
  return frame
end
local actionButtonPool = {}
local actionButtonPoolCount = 0
function GetNotifierActionButtonFromPool(parent, qtype)
  if actionButtonPool[parent] == nil then
    actionButtonPool[parent] = {}
  end
  local buttons = actionButtonPool[parent]
  local buttonCount = table.getn(buttons)
  local btn
  if qtype ~= nil then
    for i = 1, buttonCount do
      local existBtn = buttons[i]
      if existBtn.questType == qtype then
        btn = existBtn
        break
      end
    end
  end
  if btn == nil then
    for i = 1, buttonCount do
      local existBtn = buttons[i]
      if existBtn.isUsed == false then
        btn = existBtn
        break
      end
    end
  end
  if btn == nil then
    actionButtonPoolCount = actionButtonPoolCount + 1
    local id = string.format("ActionButtonPoolItem.%d", actionButtonPoolCount)
    btn = CreateItemIconButton(id, parent, "constant")
    btn:RegisterForClicks("RightButton")
    btn:RegisterForClicks("LeftButton", false)
    table.insert(buttons, btn)
  end
  btn.isUsed = true
  btn.itemType = nil
  btn.questType = qtype
  return btn
end
local function ResetNotifierActionButtonPool()
  for _, buttons in pairs(actionButtonPool) do
    for _, btn in pairs(buttons) do
      btn.isUsed = false
      btn.questType = nil
      btn.itemType = nil
      btn:Show(false)
      btn:ReleaseEventHandler()
    end
  end
end
local textboxPool = {}
local textboxPoolCount = 0
function GetNotifierTextBoxFromPool(parent, qtype)
  if textboxPool[parent] == nil then
    textboxPool[parent] = {}
  end
  local textboxs = textboxPool[parent]
  local textboxCount = table.getn(textboxs)
  local txbox
  if txbox == nil then
    for i = 1, textboxCount do
      local existLab = textboxs[i]
      if existLab.isUsed == false then
        txbox = existLab
        break
      end
    end
  end
  if txbox == nil then
    textboxPoolCount = textboxPoolCount + 1
    local id = string.format("TextboxPoolItem.%d", textboxPoolCount)
    txbox = UIParent:CreateWidget("textbox", id, parent or "UIParent")
    txbox.style:SetAlign(ALIGN_TOP_LEFT)
    txbox.style:SetSnap(true)
    txbox.style:SetShadow(true)
    txbox:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    txbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
    local prefix = txbox:CreateChildWidget("label", "prefix", 0, true)
    prefix:SetText("\194\183")
    prefix:SetExtent(5, 15)
    prefix:AddAnchor("TOPLEFT", txbox, 2, -2)
    prefix.style:SetAlign(ALIGN_CENTER)
    prefix.style:SetShadow(true)
    prefix.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    table.insert(textboxs, txbox)
  end
  txbox:SetExtent(questLocale.notifier.objectWidth, 0)
  txbox.isUsed = true
  txbox.questType = qtype
  return txbox
end
local function ResetNotifierTextBoxPool()
  for _, textboxs in pairs(textboxPool) do
    for _, txbox in pairs(textboxs) do
      txbox.isUsed = false
      txbox.questType = nil
      txbox:Show(false)
    end
  end
end
function ResetNotifierTextBoxPoolByQuestType(qtype)
  for _, textboxs in pairs(textboxPool) do
    for _, txbox in pairs(textboxs) do
      if txbox.questType == qtype then
        txbox.isUsed = false
        txbox.questType = nil
        txbox:Show(false)
      end
    end
  end
end
local labelPool = {}
local labelPoolCount = 0
function GetNotifierLabelFromPool(parent, qtype)
  if labelPool[parent] == nil then
    labelPool[parent] = {}
  end
  local labels = labelPool[parent]
  local labelCount = table.getn(labels)
  local lab
  if qtype ~= nil then
    for i = 1, labelCount do
      local existLab = labels[i]
      if existLab.questType == qtype then
        lab = existLab
        break
      end
    end
  end
  if lab == nil then
    for i = 1, labelCount do
      local existLab = labels[i]
      if existLab.isUsed == false then
        lab = existLab
        break
      end
    end
  end
  if lab == nil then
    labelPoolCount = labelPoolCount + 1
    local id = string.format("LabelPoolItem.%d", labelPoolCount)
    lab = W_CTRL.CreateLabel(id, parent)
    lab.style:SetShadow(true)
    lab.dailyMarker = CreateDailyMarker(lab)
    lab.gradeMarker = W_ICON.CreateQuestGradeMarker(lab)
    lab.repeatableMarker = CreateRepeatableQuestMarker(lab)
    table.insert(labels, lab)
  end
  lab.isUsed = true
  lab.questType = qtype
  return lab
end
local function ResetNotifierLabelPool()
  for _, labels in pairs(labelPool) do
    for _, lab in pairs(labels) do
      lab.isUsed = false
      lab.questType = nil
      if lab.ReleaseEventHandler ~= nil then
        lab:ReleaseEventHandler()
      end
    end
  end
end
local gridPool = {}
local gridPoolCount = 0
function GetNotifierGridFromPool(parent, qtype)
  if gridPool[parent] == nil then
    gridPool[parent] = {}
  end
  local grids = gridPool[parent]
  local gridCount = table.getn(grids)
  local grd
  if qtype ~= nil then
    for i = 1, gridCount do
      local existGrd = grids[i]
      if existGrd.questType == qtype then
        grd = existGrd
        break
      end
    end
  end
  if grd == nil then
    for i = 1, gridCount do
      local existGrd = grids[i]
      if existGrd.isUsed == false then
        grd = existGrd
        break
      end
    end
  end
  if grd == nil then
    local id = string.format("gridPoolItem.%d", gridCount + 1)
    grd = UIParent:CreateWidget("grid", id, parent)
    grd.navigation = CreateNotifierNavigation("navigation", grd)
    grd.taskMark = CreateNotifierTaskMark("taskMark", grd)
    table.insert(grids, grd)
  end
  grd.isUsed = true
  grd.questType = qtype
  return grd
end
local function ResetNotifierGridPool()
  for _, grids in pairs(gridPool) do
    for _, grd in pairs(grids) do
      if grd.clockWnd ~= nil then
        grd.clockWnd:Show(false)
        grd.clockWnd:ReleaseHandler("OnEvent")
      end
      grd:Show(false)
      grd:RemoveAllItems()
      grd.isUsed = false
      grd.questType = nil
      if grd.navigation.ReleaseEventHandler ~= nil then
        grd.navigation:ReleaseEventHandler()
      end
      if grd.taskMark.ReleaseEventHandler ~= nil then
        grd.taskMark:ReleaseEventHandler()
      end
      if grd.ReleaseEventHandler ~= nil then
        grd:ReleaseEventHandler()
      end
    end
  end
end
function ResetAllNotifierComponentPool()
  ResetNotifierLabelPool()
  ResetNotifierTextBoxPool()
  ResetNotifierGridPool()
  ResetNotifierActionButtonPool()
end
function UpdateAllClockVisibleInGrid()
  local parent = GetNotifierWnd()
  if parent == nil then
    return
  end
  if parent.questNotifier == nil then
    return
  end
  local grids = gridPool[parent.questNotifier.scrollWnd.content]
  if grids == nil then
    return
  end
  for _, grd in pairs(grids) do
    if grd.isUsed == true then
      local clockWnd = grd.clockWnd
      if clockWnd == nil then
        return
      end
      if clockWnd.UpdateVisible == nil then
        return
      end
      if clockWnd ~= nil and clockWnd.UpdateVisible ~= nil then
        clockWnd:UpdateVisible()
      end
    end
  end
end
