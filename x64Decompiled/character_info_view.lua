local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local max_width = characetInfoLocale.windowWidth - sideMargin * 2
local item_width = max_width - 10
local item_height = 16
local item_offset = 20
local group_inset = sideMargin / 1.4
characterInfo = {}
characterInfo.mainWindow = CreateWindow("characterInfo.mainWindow", "UIParent")
characterInfo.mainWindow:Show(false)
characterInfo.mainWindow:SetExtent(characetInfoLocale.windowWidth, 450)
characterInfo.mainWindow:AddAnchor("TOPLEFT", "UIParent", 28, 60)
characterInfo.mainWindow:SetTitle(locale.character_mainWindowTitle)
characterInfo.mainWindow:SetSounds("character_info")
local emptyWindow = characterInfo.mainWindow:CreateChildWidget("emptywidget", "emptyWindow", 0, true)
emptyWindow:Show(true)
emptyWindow:AddAnchor("TOPLEFT", characterInfo.mainWindow, sideMargin, titleMargin)
emptyWindow:AddAnchor("BOTTOMRIGHT", characterInfo.mainWindow, -sideMargin, -sideMargin)
characterInfo.mainWindow.group = {}
for i = 1, #baseWindowSubTitle do
  local group = characterInfo.mainWindow:CreateChildWidget("emptywidget", "group", i, true)
  group:SetWidth(max_width)
  if i == GROUP_DEFAULTINFO then
    group:AddAnchor("TOPLEFT", emptyWindow, 0, 0)
  elseif i == GROUP_COMMUNITY then
    group:AddAnchor("TOPLEFT", characterInfo.mainWindow.group[i - 1], "BOTTOMLEFT", 0, sideMargin / 2)
  else
    group:AddAnchor("TOPLEFT", characterInfo.mainWindow.group[i - 1], "BOTTOMLEFT", 0, sideMargin)
  end
  if i ~= GROUP_DEFAULTINFO and i ~= GROUP_SPEED then
    local line = CreateLine(group, "TYPE1")
    line:SetColor(1, 1, 1, 0.5)
    line:AddAnchor("TOPLEFT", group, "BOTTOMLEFT", 0, sideMargin / 2)
    line:AddAnchor("TOPRIGHT", group, "BOTTOMRIGHT", 0, sideMargin / 2)
  end
end
local group = {}
group.defaultInfo = characterInfo.mainWindow.group[1]
group.community = characterInfo.mainWindow.group[2]
group.gamePoint = characterInfo.mainWindow.group[3]
group.contentsPoint = characterInfo.mainWindow.group[4]
group.combatDefaultInfo = characterInfo.mainWindow.group[5]
group.baseStats = characterInfo.mainWindow.group[6]
group.speed = characterInfo.mainWindow.group[7]
characterInfo.window = {}
characterInfo.subtitle = {}
characterInfo.value = {}
local itemIndex = 1
for i = 1, #baseWindowSubTitle do
  for k = 1, #baseWindowSubTitle[i] do
    local subTitleInfo = baseWindowSubTitle[i][k]
    local window = CreateEmptyWindow("character.window." .. itemIndex, characterInfo.mainWindow)
    window:Show(true)
    window:SetExtent(item_width, item_height)
    local label = window:CreateChildWidget("label", "label." .. itemIndex, 0, true)
    label:Show(true)
    label:SetExtent(item_width / 2, item_height)
    label:AddAnchor("LEFT", window, 0, 0)
    local strTitle
    if subTitleInfo.category then
      strTitle = X2Locale:LocalizeUiText(subTitleInfo.category, subTitleInfo.key)
    else
      strTitle = locale.attribute(subTitleInfo.key)
    end
    label:SetText(strTitle)
    ApplyTextColor(label, FONT_COLOR.MIDDLE_TITLE)
    label.style:SetAlign(ALIGN_LEFT)
    label.tooltipText = GetCharInfoTooltip(subTitleInfo.key)
    local value
    if subTitleInfo.createFunc then
      value = subTitleInfo.createFunc(window, item_width / 2, item_height)
    else
      value = CreateDefaultSubTitle("value" .. itemIndex, window, item_width / 2, item_height)
    end
    value:Show(true)
    value:AddAnchor("TOPLEFT", label, "TOPRIGHT", 0, 0)
    if subTitleInfo.key ~= "appellation" then
      if subTitleInfo.color then
        ApplyTextColor(value, subTitleInfo.color)
      else
        ApplyTextColor(value, FONT_COLOR.DEFAULT)
      end
    end
    characterInfo.window[itemIndex] = window
    characterInfo.subtitle[itemIndex] = label
    characterInfo.value[itemIndex] = value
    itemIndex = itemIndex + 1
  end
end
SetTooltipHandlers(characterInfo.subtitle)
SetExtraTooltipHandlers(characterInfo.value)
group.defaultInfo:SetHeight(45)
local bg = CreateContentBackground(group.defaultInfo, "TYPE8", "brown_2")
bg:AddAnchor("TOPLEFT", group.defaultInfo, -sideMargin, -sideMargin)
bg:AddAnchor("BOTTOMRIGHT", group.defaultInfo, sideMargin / 2, sideMargin / 2)
group.defaultInfo.bg = bg
characterInfo.level = W_UNIT.CreateLevelLabel("characterInfo.level", group.defaultInfo, true)
characterInfo.level:Show(true)
characterInfo.level:AddAnchor("LEFT", group.defaultInfo, 0, 0)
characterInfo.level:SettingUseForInfoWindow()
characterInfo.characterName = group.defaultInfo:CreateChildWidget("label", "characterName", 0, true)
characterInfo.characterName:SetExtent(0, 15)
characterInfo.characterName:SetAutoResize(true)
characterInfo.characterName.style:SetFontSize(FONT_SIZE.LARGE)
characterInfo.characterName:AddAnchor("BOTTOMLEFT", characterInfo.level, "BOTTOMRIGHT", 5, 0)
ApplyTextColor(characterInfo.characterName, FONT_COLOR.GREEN)
characterInfo.job = group.defaultInfo:CreateChildWidget("label", "job", 0, true)
characterInfo.job:SetExtent(0, 15)
characterInfo.job:SetAutoResize(true)
characterInfo.job:AddAnchor("TOPLEFT", characterInfo.level, "TOPRIGHT", 5, 0)
ApplyTextColor(characterInfo.job, FONT_COLOR.DEFAULT)
local groupSubtitleX = 0
function UpdateLabelAnchors(target, startIndex, endIndex, visibilitys, itemHeight)
  local yOffset
  local height = 0
  local skip = 0
  for i = startIndex, endIndex do
    yOffset = (i - (startIndex + skip)) * itemHeight
    characterInfo.window[i]:AddAnchor("TOPLEFT", target, "TOPLEFT", groupSubtitleX, yOffset)
    characterInfo.window[i]:Show(visibilitys[i])
    characterInfo.subtitle[i]:Show(visibilitys[i])
    characterInfo.value[i]:Show(visibilitys[i])
    if visibilitys[i] == true then
      height = height + itemHeight
    else
      skip = skip + 1
    end
  end
  return height
end
function UpadateBodyAnchors(visibilitys)
  if visibilitys == nil then
    return
  end
  local totalHeight = titleMargin + -bottomMargin / 2 + group.defaultInfo:GetHeight()
  local startIndex = 1
  local endIndex = #baseWindowSubTitle[GROUP_COMMUNITY]
  local height = UpdateLabelAnchors(group.community, startIndex, endIndex, visibilitys, item_offset)
  group.community:SetHeight(height)
  totalHeight = totalHeight + height + group_inset
  startIndex = endIndex + 1
  endIndex = startIndex + #baseWindowSubTitle[GROUP_GAME_POINT] - 1
  height = UpdateLabelAnchors(group.gamePoint, startIndex, endIndex, visibilitys, item_offset)
  group.gamePoint:SetHeight(height)
  totalHeight = totalHeight + height + group_inset
  startIndex = endIndex + 1
  endIndex = startIndex + #baseWindowSubTitle[GROUP_CONTENTS_POINT] - 1
  height = UpdateLabelAnchors(group.contentsPoint, startIndex, endIndex, visibilitys, item_offset)
  group.contentsPoint:SetHeight(height)
  totalHeight = totalHeight + height + group_inset
  startIndex = endIndex + 1
  endIndex = startIndex + #baseWindowSubTitle[GROUP_COMBAT_STAT] - 1
  height = UpdateLabelAnchors(group.combatDefaultInfo, startIndex, endIndex, visibilitys, item_offset)
  group.combatDefaultInfo:SetHeight(height)
  totalHeight = totalHeight + height + group_inset
  group.baseStats:SetHeight(60)
  local startIndex = endIndex + 1
  local endIndex = startIndex + #baseWindowSubTitle[GROUP_BASE_STAT] - 1
  for i = startIndex, endIndex do
    local x, y
    if i < endIndex - 1 then
      x = 0
      y = (i - startIndex) * item_offset
    else
      x = item_width / 2
      y = (i - (endIndex - 1)) * item_offset
    end
    characterInfo.window[i]:SetExtent(item_width / 2, item_height)
    characterInfo.window[i]:AddAnchor("TOPLEFT", group.baseStats, "TOPLEFT", x, y)
    characterInfo.subtitle[i]:SetExtent(item_width / 4 - 5, item_height)
    characterInfo.value[i]:SetExtent(item_width / 4, item_height)
  end
  totalHeight = totalHeight + group.baseStats:GetHeight() + group_inset
  local startIndex = endIndex + 1
  local endIndex = startIndex + #baseWindowSubTitle[GROUP_SPEED] - 1
  height = UpdateLabelAnchors(group.speed, startIndex, endIndex, visibilitys, item_offset)
  group.speed:SetHeight(height)
  local width, _ = characterInfo.mainWindow:GetExtent()
  totalHeight = totalHeight + height + group_inset
  characterInfo.mainWindow:SetExtent(width, totalHeight)
end
characterInfo.popupBtn = CreateEmptyButton("characterInfo.popupBtn", characterInfo.mainWindow)
characterInfo.popupBtn:AddAnchor("BOTTOMRIGHT", characterInfo.mainWindow, -sideMargin / 2, -sideMargin / 2)
ApplyButtonSkin(characterInfo.popupBtn, BUTTON_CONTENTS.CHARACTER_INFO_DETAIL)
local subWindow = CreateCharacterInfoSubWindow("characterInfo.popupWindow", characterInfo.mainWindow)
subWindow:Show(false)
subWindow:AddAnchor("TOPLEFT", characterInfo.mainWindow, "TOPRIGHT", 0, -3)
characterInfo.mainWindow.subWindow = subWindow
if X2Player:GetFeatureSet().blessuthstin then
  local blessuthstinLable = characterInfo.subtitle[INDEX_BLESS_UTHSTIN]
  local blessuthstinPopupBtn = blessuthstinLable:CreateChildWidget("button", "blessuthstinPopupBtn", 0, true)
  blessuthstinPopupBtn:Enable(true)
  blessuthstinPopupBtn:AddAnchor("LEFT", characterInfo.window[23], "RIGHT", 0, 0)
  ApplyButtonSkin(blessuthstinPopupBtn, BUTTON_CONTENTS.UTHSTIN_OPEN)
  blessuthstinPopupBtn:SetExtent(20, 20)
  blessuthstinWindow = CreateBlessUthstinWindow("characterInfo.blessuthstinWindow", "UIParent")
  blessuthstinWindow:Show(false)
  ADDON:RegisterContentWidget(UIC_BLESS_UTHSTIN, blessuthstinWindow)
  characterInfo.mainWindow.blessuthstinWindow = blessuthstinWindow
  SetBlessUthstinEventFunction(blessuthstinWindow)
end
if X2Player:GetFeatureSet().shopOnUI then
  local livingPointLable = characterInfo.subtitle[INDEX_LIVING_POINT]
  local livingPointPopupBtn = livingPointLable:CreateChildWidget("button", "livingPointPopupBtn", 0, true)
  livingPointPopupBtn:Enable(true)
  livingPointPopupBtn:AddAnchor("LEFT", characterInfo.window[INDEX_LIVING_POINT], "RIGHT", 0, 0)
  ApplyButtonSkin(livingPointPopupBtn, BUTTON_CONTENTS.CHARACTER_INFO_SHOP)
  livingPointPopupBtn:SetExtent(20, 20)
  local honorPointLable = characterInfo.subtitle[INDEX_HONOR_POINT]
  local honorPointPopupBtn = honorPointLable:CreateChildWidget("button", "honorPointPopupBtn", 0, true)
  honorPointPopupBtn:Enable(true)
  honorPointPopupBtn:AddAnchor("LEFT", characterInfo.window[INDEX_HONOR_POINT], "RIGHT", 0, 0)
  ApplyButtonSkin(honorPointPopupBtn, BUTTON_CONTENTS.CHARACTER_INFO_SHOP)
  honorPointPopupBtn:SetExtent(20, 20)
end
