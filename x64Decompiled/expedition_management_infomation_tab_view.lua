local EXPEDITION_ICON_WIDTH = 100
local EXPEDITION_ICON_HEIGHT = 100
local EXPEDITION_WIDTH = 856
local EXPEDITION_HEIGHT = 579
function SetViewOfExpeditionExpBar(frame, anchor)
  local window = frame:CreateChildWidget("emptywidget", "expBar", 0, true)
  window:Show(true)
  window:SetExtent(575, 14)
  window:AddAnchor("LEFT", anchor, "RIGHT", 94, 0)
  local dailyBar = W_BAR.CreateStatusBar("dailyBar", window, "item_evolving_material")
  dailyBar:AddAnchor("TOPLEFT", window, 1, 1)
  dailyBar:AddAnchor("BOTTOMRIGHT", window, -1, -1)
  dailyBar:SetMinMaxValues(0, 1000)
  dailyBar:SetBarColor({
    ConvertColor(195),
    ConvertColor(244),
    ConvertColor(138),
    1
  })
  window.dailyBar = dailyBar
  local statusBar = W_BAR.CreateStatusBar("statusBar", window, "item_evolving_target")
  statusBar:AddAnchor("TOPLEFT", window, 1, 1)
  statusBar:AddAnchor("BOTTOMRIGHT", window, -1, -1)
  statusBar:SetBarColor({
    ConvertColor(121),
    ConvertColor(177),
    ConvertColor(102),
    1
  })
  statusBar:SetMinMaxValues(0, 1000)
  window.statusBar = statusBar
  local barEnd = window:CreateDrawable(TEXTURE_PATH.COMMUNITY_COMMON, "gage_bar", "overlay")
  window.barEnd = barEnd
  return window
end
function SetViewOfExpeditionInfomation(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = parent:CreateChildWidget("emptywidget", "frame", 0, true)
  frame:Show(true)
  frame:SetExtent(EXPEDITION_WIDTH, EXPEDITION_HEIGHT)
  frame:AddAnchor("TOPLEFT", parent, 0, 0)
  local nameBg = frame:CreateDrawable(TEXTURE_PATH.COMMUNITY_COMMON, "text_bg", "background")
  nameBg:AddAnchor("TOP", frame, 0, 0)
  local nameLabel = frame:CreateChildWidget("label", "nameLabel", 0, true)
  nameLabel:SetAutoResize(true)
  nameLabel:SetHeight(FONT_SIZE.XXLARGE)
  nameLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  nameLabel:AddAnchor("CENTER", nameBg, "CENTER", 0, 0)
  nameLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(nameLabel, FONT_COLOR.DEFAULT)
  local iconPlate = frame:CreateDrawable(TEXTURE_PATH.EXPEDITION_MAIN, "picture", "overlay")
  iconPlate:AddAnchor("LEFT", frame, 0, 0)
  iconPlate:AddAnchor("TOP", nameBg, "BOTTOM", 0, 0)
  frame.iconPlate = iconPlate
  local midWin = parent:CreateChildWidget("emptywidget", "midWin", 0, true)
  midWin:SetExtent(EXPEDITION_WIDTH - 180, 156)
  midWin:AddAnchor("TOPLEFT", iconPlate, "TOPRIGHT", 17, 0)
  midWin:Show(true)
  parent.midWin = midWin
  local bossLabel = frame:CreateChildWidget("label", "bossLabel", 0, true)
  bossLabel:SetAutoResize(true)
  bossLabel:SetHeight(FONT_SIZE.LARGE)
  bossLabel.style:SetFontSize(FONT_SIZE.LARGE)
  bossLabel:AddAnchor("TOPLEFT", midWin, 0, 0)
  bossLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(bossLabel, FONT_COLOR.DEFAULT)
  local factionLabel = frame:CreateChildWidget("label", "factionLabel", 0, true)
  factionLabel:SetAutoResize(true)
  factionLabel:SetHeight(FONT_SIZE.LARGE)
  factionLabel.style:SetFontSize(FONT_SIZE.LARGE)
  factionLabel:AddAnchor("TOPLEFT", bossLabel, "BOTTOMLEFT", 0, 9)
  factionLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(factionLabel, FONT_COLOR.DEFAULT)
  local immigrationIcon = midWin:CreateChildWidget("emptywidget", "immigrationIcon", 0, true)
  immigrationIcon:Show(true)
  immigrationIcon:SetExtent(70, 19)
  immigrationIcon:AddAnchor("LEFT", factionLabel, "RIGHT", 5, 0)
  local immigrationImage = frame:CreateDrawable(TEXTURE_PATH.EXPEDITION_COMBAT_COND, "immigration", "overlay")
  immigrationImage:AddAnchor("LEFT", immigrationIcon, "LEFT", 0, 0)
  frame.immigrationImage = immigrationImage
  local immigrationLabel = frame:CreateChildWidget("label", "immigrationLabel", 0, true)
  immigrationLabel:SetAutoResize(true)
  immigrationLabel:SetHeight(FONT_SIZE.LARGE)
  immigrationLabel.style:SetFontSize(FONT_SIZE.LARGE)
  immigrationLabel:AddAnchor("LEFT", immigrationImage, "RIGHT", 5, 0)
  immigrationLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(immigrationLabel, FONT_COLOR.BLUE)
  local interestLabel = frame:CreateChildWidget("label", "interestLabel", 0, true)
  interestLabel:SetAutoResize(true)
  interestLabel:SetHeight(FONT_SIZE.LARGE)
  interestLabel.style:SetFontSize(FONT_SIZE.LARGE)
  interestLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_interest") .. " ")
  interestLabel:AddAnchor("TOPLEFT", factionLabel, "BOTTOMLEFT", 0, 9)
  interestLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(interestLabel, FONT_COLOR.DEFAULT)
  frame.interestIcon = {}
  local IR = GetInterestList()
  for i = 1, #IR do
    local icon = midWin:CreateChildWidget("emptywidget", "icon", i, true)
    icon:Raise()
    local iconTexture = icon:CreateDrawable(TEXTURE_PATH.EXPEDITION_RECRUIT, "icon_" .. IR[i], "background")
    icon:SetExtent(iconTexture:GetWidth(), iconTexture:GetHeight())
    iconTexture:AddAnchor("TOPLEFT", icon, 0, 0)
    iconTexture:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
    icon:Show(false)
    frame.interestIcon[i] = icon
  end
  local contributionLabel = midWin:CreateChildWidget("textbox", "contributionLabel", 0, true)
  contributionLabel:SetExtent(135, FONT_SIZE.LARGE)
  contributionLabel.style:SetFontSize(FONT_SIZE.LARGE)
  contributionLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_contribution") .. " : ")
  contributionLabel:AddAnchor("TOPLEFT", interestLabel, "BOTTOMLEFT", 0, 9)
  contributionLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(contributionLabel, FONT_COLOR.DEFAULT)
  local midLine = CreateLine(midWin, "TYPE1")
  midLine:AddAnchor("TOPLEFT", contributionLabel, "BOTTOMLEFT", 0, 10)
  midLine:AddAnchor("RIGHT", midWin, 0, 0)
  local guideButton = midWin:CreateChildWidget("button", "guideButton", 0, true)
  ApplyButtonSkin(guideButton, BUTTON_BASIC.QUESTION_MARK)
  guideButton:Show(true)
  guideButton:AddAnchor("TOPRIGHT", midLine, "BOTTOMRIGHT", 0, 3)
  local battleLabel = frame:CreateChildWidget("label", "battleLabel", 0, true)
  battleLabel:SetAutoResize(true)
  battleLabel:SetHeight(FONT_SIZE.LARGE)
  battleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  battleLabel:SetText(GetUIText(COMMON_TEXT, "expedition_my_battle_score") .. " : " .. tostring(1) .. GetUIText(INSTANT_GAME_TEXT, "win") .. " / " .. tostring(4) .. GetUIText(INSTANT_GAME_TEXT, "lose") .. " ")
  battleLabel:AddAnchor("TOPLEFT", midLine, "BOTTOMLEFT", 0, 10)
  battleLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(battleLabel, FONT_COLOR.DEFAULT)
  local battleCond = frame:CreateDrawable(TEXTURE_PATH.EXPEDITION_COMBAT_COND, "combat_possible", "overlay")
  battleCond:AddAnchor("TOPLEFT", battleLabel, "BOTTOMLEFT", 0, 6)
  frame.battleCond = battleCond
  local battleRemain = frame:CreateChildWidget("label", "battleRemain", 0, true)
  battleRemain:SetAutoResize(true)
  battleRemain:SetHeight(FONT_SIZE.LARGE)
  battleRemain.style:SetFontSize(FONT_SIZE.LARGE)
  battleRemain:SetText(" " .. locale.comercialMail.GetLimitM(59))
  battleRemain:AddAnchor("LEFT", battleCond, "RIGHT", 0, 0)
  battleRemain.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(battleRemain, FONT_COLOR.BLUE)
  frame.battleRemain = battleRemain
  local battleHistoryButton = midWin:CreateChildWidget("button", "battleHistoryButton", 0, true)
  battleHistoryButton:AddAnchor("TOPRIGHT", guideButton, "BOTTOMRIGHT", 0, 3)
  battleHistoryButton:SetText(GetUIText(COMMON_TEXT, "expedition_my_battle_history"))
  ApplyButtonSkin(battleHistoryButton, BUTTON_BASIC.DEFAULT)
  frame.battleHistoryButton = battleHistoryButton
  local disableProtectButton = midWin:CreateChildWidget("button", "disableProtectButton", 0, true)
  disableProtectButton:AddAnchor("BOTTOMRIGHT", battleHistoryButton, "BOTTOMLEFT", -2, 0)
  disableProtectButton:SetText(GetUIText(COMMON_TEXT, "expedition_my_disable_protect"))
  ApplyButtonSkin(disableProtectButton, BUTTON_BASIC.DEFAULT)
  disableProtectButton:Show(false)
  frame.disableProtectButton = disableProtectButton
  local shopButton = midWin:CreateChildWidget("button", "shopButton", 0, true)
  shopButton:AddAnchor("BOTTOMRIGHT", guideButton, "TOPRIGHT", 0, -10)
  shopButton:SetText(GetUIText(COMMON_TEXT, "expedition_my_shop"))
  ApplyButtonSkin(shopButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {battleHistoryButton, shopButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local controlButton = midWin:CreateChildWidget("button", "controlButton", 0, true)
  ApplyButtonSkin(controlButton, BUTTON_CONTENTS.APPELLATION_OPTION)
  controlButton:AddAnchor("LEFT", interestLabel, "RIGHT", 12, 0)
  frame.controlButton = controlButton
  local interestBg = CreateContentBackground(midWin, "TYPE2", "orange")
  interestBg:AddAnchor("TOPLEFT", interestLabel, "TOPRIGHT", -1, -9)
  interestBg:AddAnchor("BOTTOMRIGHT", controlButton, 11, 7)
  frame.interestBg = interestBg
  local memberCountLabel = midWin:CreateChildWidget("textbox", "memberCountLabel", 0, true)
  memberCountLabel:SetExtent(120, FONT_SIZE.LARGE)
  memberCountLabel.style:SetFontSize(FONT_SIZE.LARGE)
  memberCountLabel:AddAnchor("BOTTOMRIGHT", shopButton, "TOPRIGHT", 0, -46)
  memberCountLabel.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(memberCountLabel, FONT_COLOR.DEFAULT)
  local upgradeButton = frame:CreateChildWidget("button", "upgradeButton", 0, true)
  upgradeButton:SetText(GetUIText(COMMON_TEXT, "expedition_my_levelup"))
  upgradeButton:Show(false)
  upgradeButton:Enable(false)
  upgradeButton:AddAnchor("TOPRIGHT", iconPlate, "BOTTOMRIGHT", 0, 7)
  ApplyButtonSkin(upgradeButton, BUTTON_BASIC.DEFAULT)
  upgradeButton.waiting = false
  local level = frame:CreateChildWidget("label", "level", 0, true)
  level:Show(true)
  level:SetHeight(FONT_SIZE.LARGE)
  level.style:SetFontSize(FONT_SIZE.LARGE)
  level:AddAnchor("TOPLEFT", battleCond, "BOTTOMLEFT", 0, 18)
  level.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(level, FONT_COLOR.DEFAULT)
  frame.level = level
  local expBar = SetViewOfExpeditionExpBar(frame, upgradeButton)
  frame.expBar = expBar
  local effectInfoButton = midWin:CreateChildWidget("button", "effectInfoButton", 0, true)
  ApplyButtonSkin(effectInfoButton, BUTTON_BASIC.QUESTION_MARK)
  effectInfoButton:AddAnchor("LEFT", expBar, "RIGHT", 4, 0)
  effectInfoButton:Enable(true)
  local writeButton = frame:CreateChildWidget("button", "writeButton", 0, true)
  ApplyButtonSkin(writeButton, BUTTON_CONTENTS.EXPEDITION_INFO_WRITE)
  writeButton:Show(true)
  writeButton:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local botWin = parent:CreateChildWidget("emptywidget", "botWin", 0, true)
  botWin:SetExtent(EXPEDITION_WIDTH, 235)
  botWin:AddAnchor("BOTTOMRIGHT", writeButton, "TOPRIGHT", 0, -10)
  botWin:Show(true)
  parent.botWin = botWin
  local botBg = CreateContentBackground(botWin, "TYPE2", "orange")
  botBg:AddAnchor("TOPLEFT", botWin, 0, 0)
  botBg:AddAnchor("BOTTOMRIGHT", botWin, 0, 0)
  local motdTitle = W_CTRL.CreateMultiLineEdit("motdTitle", parent)
  motdTitle:SetExtent(765, 80)
  motdTitle:AddAnchor("TOPLEFT", botWin, 10, 10)
  ApplyTextColor(motdTitle, FONT_COLOR.BLUE)
  local inset = expeditionLocale.inset.infoMultiline
  motdTitle:SetInset(inset[1], inset[2], inset[3], inset[4])
  motdTitle.textLength = 136
  motdTitle:SetMaxTextLength(motdTitle.textLength)
  motdTitle:Enable(false)
  motdTitle:SetReadOnly(true)
  motdTitle.bg:Show(false)
  local motdTitleLabel = frame:CreateChildWidget("textbox", "motdTitleLabel", 0, true)
  motdTitleLabel:SetHeight(FONT_SIZE.LARGE)
  motdTitleLabel.style:SetFontSize(FONT_SIZE.LARGE)
  motdTitleLabel:AddAnchor("TOPRIGHT", botWin, -13, 15)
  motdTitleLabel:AddAnchor("LEFT", motdTitle, "RIGHT", 0, 0)
  motdTitleLabel.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(motdTitleLabel, FONT_COLOR.SOFT_BROWN)
  motdTitleLabel:Show(false)
  local botLine = CreateLine(midWin, "TYPE1")
  botLine:AddAnchor("TOP", motdTitle, "BOTTOM", 0, 10)
  botLine:AddAnchor("LEFT", botWin, 0, 0)
  botLine:AddAnchor("RIGHT", botWin, 0, 0)
  local motdContent = W_CTRL.CreateMultiLineEdit("motdContent", parent)
  motdContent:SetExtent(765, 110)
  motdContent:AddAnchor("TOPLEFT", botLine, "BOTTOMLEFT", 10, 10)
  motdContent.textLength = 200
  motdContent:SetMaxTextLength(motdContent.textLength)
  local inset = expeditionLocale.inset.infoMultiline
  motdContent:SetInset(inset[1], inset[2], inset[3], inset[4])
  motdContent:Enable(false)
  motdContent:SetReadOnly(true)
  motdContent.bg:Show(false)
  local motdContentLabel = frame:CreateChildWidget("textbox", "motdContentLabel", 0, true)
  motdContentLabel:SetHeight(FONT_SIZE.LARGE)
  motdContentLabel.style:SetFontSize(FONT_SIZE.LARGE)
  motdContentLabel:AddAnchor("TOPRIGHT", botLine, "BOTTOMRIGHT", -13, 10)
  motdContentLabel:AddAnchor("LEFT", motdContent, "RIGHT", 0, 0)
  motdContentLabel.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(motdContentLabel, FONT_COLOR.SOFT_BROWN)
  motdContentLabel:Show(false)
end
