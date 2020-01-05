local folderList = {
  {
    id = "structureFolder",
    saveName = "STRUCTURE_SHOW",
    title = GetUIText(MAP_TEXT, "M_STRUCTURE"),
    filterType = FILTER_STRUCTURE
  },
  {
    id = "houseFolder",
    saveName = "HOUSE_SHOW",
    title = GetUIText(MAP_TEXT, "M_HOUSE"),
    filterType = FILTER_HOUSE
  },
  {
    id = "npcFolder",
    saveName = "NPC_SHOW",
    title = GetUIText(MAP_TEXT, "M_NPC"),
    filterType = FILTER_NPC
  },
  {
    id = "doodadFolder",
    saveName = "DOODAD_SHOW",
    title = GetUIText(MAP_TEXT, "M_DOODAD"),
    filterType = FILTER_DOODAD
  }
}
function GetFilterFolderList()
  return folderList
end
function CreateFilterCheckGroupWindow(id, parent, folderTable)
  local info = {}
  info.insetY = 23
  info.offsetY = 5
  info.menuTexts = {}
  local filterTable = {}
  local isNoramlTable = folderTable == nil
  if isNoramlTable then
    filterTable = X2Map:GetCheckList(FILTER_INVALID)
    info.iconInfo = {}
  else
    filterTable = folderTable
    table.insert(info.menuTexts, locale.map.allIcon)
    info.subMenuTexts = {}
    info.subIconInfo = {}
    info.subOffsetX = 0
    info.offsetX = -7
  end
  for i = 1, #filterTable do
    if isNoramlTable then
      local symbol = X2Map:GetMapIconText(filterTable[i])
      symbol = string.format("m_%s", symbol)
      info.menuTexts[i] = GetUIText(MAP_TEXT, string.upper(symbol))
      info.iconInfo[i] = {}
      info.iconInfo[i].path = TEXTURE_PATH.MAP_ICON
      info.iconInfo[i].width = M_ICON_EXTENT * 0.9
      info.iconInfo[i].height = M_ICON_EXTENT * 0.9
      info.iconInfo[i].coord = X2Map:GetMapIconCoord(filterTable[i])
      info.iconInfo[i].anchorX = -3
      info.iconInfo[i].anchorY = 1
    else
      local symbol = X2Map:GetMapIconText(filterTable[i])
      symbol = string.format("m_%s", symbol)
      info.subMenuTexts[i] = GetUIText(MAP_TEXT, string.upper(symbol))
      info.subIconInfo[i] = {}
      info.subIconInfo[i].path = TEXTURE_PATH.MAP_ICON
      info.subIconInfo[i].width = M_ICON_EXTENT * 0.9
      info.subIconInfo[i].height = M_ICON_EXTENT * 0.9
      info.subIconInfo[i].coord = X2Map:GetMapIconCoord(filterTable[i])
      info.subIconInfo[i].anchorX = -3
      info.subIconInfo[i].anchorY = 2
    end
  end
  local window = CreateCheckGroupWindow(id, parent, info)
  if isNoramlTable and info.menuTexts ~= nil then
    for i = 1, #filterTable do
      window.checks[i].iconType = filterTable[i]
      attachParam = {
        "RIGHT",
        window.checks[i],
        "LEFT",
        0,
        0
      }
      F_TEXT.ApplyEllipsisText(window.checks[i].textButton, 120, attachParam)
    end
  end
  if not isNoramlTable and info.subMenuTexts ~= nil then
    for i = 1, #filterTable do
      local subChecks = window.subChecks[i]
      subChecks.iconType = filterTable[i]
      attachParam = {
        "RIGHT",
        subChecks,
        "LEFT",
        0,
        0
      }
      F_TEXT.ApplyEllipsisText(subChecks.textButton, 120, attachParam)
    end
  end
  return window
end
local CreateFolderButton = function(parent)
  local openButton = parent:CreateChildWidget("button", "openButton", 0, true)
  openButton:AddAnchor("TOPRIGHT", parent, 0, 1)
  ApplyButtonSkin(openButton, BUTTON_CONTENTS.MAP_FILTER_OPEN)
  local closeButton = parent:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", parent, 0, 1)
  ApplyButtonSkin(closeButton, BUTTON_CONTENTS.MAP_FILTER_CLOSE)
  return openButton, closeButton
end
local CreateDetailGroupCheckWindow = function(id, parent, subCheckList)
  local window = parent:CreateChildWidget("window", id, 0, true)
  window:Show(true)
  window:SetHeight(#subCheckList * 20)
  local group = CreateFilterCheckGroupWindow(window:GetId() .. ".group", window, subCheckList)
  group:AddAnchor("TOPLEFT", window, 15, 0)
  window.group = group
  return window
end
local SetFolderControlHandler_2 = function(widget, folder)
  widget.folder = folder
  local scrollWindow = folder:GetParent()
  scrollWindow = scrollWindow:GetParent()
  function widget:OnClick()
    if self.folder == nil then
      return
    end
    self.folder:ToggleState()
    scrollWindow:ResetScroll(mapFrame:GetScrollHeight())
  end
  widget:SetHandler("OnClick", widget.OnClick)
end
local function CreateCheckFolder(id, parent, text, subCheckList)
  local folder = UIParent:CreateWidget("folder", id, parent)
  folder:SetExtent(170, 16)
  folder.height = parent.height
  folder.flexibleHeight = parent.height
  local allCheck = CreateCheckButton("allCheck", folder)
  allCheck:AddAnchor("TOPLEFT", folder, 0, 1)
  allCheck:Raise()
  folder.allCheck = allCheck
  SetFolderControlHandler_2(allCheck, folder)
  local openButton, closeButton = CreateFolderButton(folder)
  folder:SetOpenStateButton(openButton)
  folder:SetCloseStateButton(closeButton)
  folder:UseAnimation(true)
  folder:SetTitleHeight(19)
  folder:SetAnimateStep(1.5)
  folder:SetExtendLength((#subCheckList + 1) * 23 + 5)
  folder.openHeight = (#subCheckList + 1) * 23 + 27
  folder.closeHeight = 22
  SetFolderControlHandler_2(openButton, folder)
  SetFolderControlHandler_2(closeButton, folder)
  local textButton = folder:CreateChildWidget("button", "textButton", 0, true)
  textButton:Show(true)
  textButton:SetText(text)
  textButton.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  SetButtonFontColor(textButton, GetTitleButtonFontColor())
  textButton.style:SetAlign(ALIGN_LEFT)
  textButton.style:SetSnap(true)
  folder:SetInset(20, 0, -20, 0)
  folder:SetTitleButtonWidget(textButton)
  SetFolderControlHandler_2(textButton, folder)
  local detailCheck = CreateDetailGroupCheckWindow(folder:GetId() .. ".detailCheck", folder, subCheckList)
  folder:SetChildWidget(detailCheck)
  folder.detailCheck = detailCheck
  return folder
end
local function SetViewOfScrollFilterWindow(id, parent)
  local window = CreateScrollWindow(parent, id, 0)
  window:SetExtent(195, 440)
  local title = parent:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.LARGE)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  title:SetText(locale.map.showIcon)
  title:AddAnchor("BOTTOMLEFT", window, "TOPLEFT", 0, -7)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  local normalCheckGroup = CreateFilterCheckGroupWindow("normalCheckGroup", window.content, nil)
  normalCheckGroup:AddAnchor("TOPLEFT", window.content, 0, -2)
  window.normalCheckGroup = normalCheckGroup
  window.firstHeight = normalCheckGroup:GetHeight()
  for i = 1, #folderList do
    local info = folderList[i]
    local folder = CreateCheckFolder(info.id, window.content, info.title, X2Map:GetCheckList(info.filterType))
    if i == 1 then
      folder:AddAnchor("TOPLEFT", normalCheckGroup, "BOTTOMLEFT", 0, 0)
    else
      folder:AddAnchor("TOPLEFT", window[folderList[i - 1].id], "BOTTOMLEFT", 0, 3)
    end
    window[info.id] = folder
  end
  return window
end
local function CreateScrollFilterWindow(id, parent)
  local window = SetViewOfScrollFilterWindow(id, parent)
  return window
end
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local scrollFilterWindow = CreateScrollFilterWindow("scrollFilterWindow", mapFrame)
scrollFilterWindow:AddAnchor("TOPLEFT", mapWindow, "TOPRIGHT", sideMargin / 1.5, 15)
function mapFrame:GetScrollHeight()
  local height = mapFrame.scrollFilterWindow.firstHeight
  for i = 1, #folderList do
    local folderInfo = folderList[i]
    local folder = mapFrame.scrollFilterWindow[folderInfo.id]
    if folder:GetState() == "opening" or folder:GetState() == "open" then
      height = height + folder.openHeight
    else
      height = height + folder.closeHeight
    end
  end
  return height
end
scrollFilterWindow:ResetScroll(mapFrame:GetScrollHeight())
