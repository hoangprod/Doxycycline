local INFO_FONT_COLOR = {
  ConvertColor(219),
  ConvertColor(233),
  ConvertColor(242),
  1
}
function CreateCharacterInfoWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetExtent(399, 222)
  local bg = wnd:CreateDrawable(SELECT_TEXTURE, "info_background", "background")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local pattern = wnd:CreateDrawable(SELECT_TEXTURE, "info_pattern", "background")
  pattern:AddAnchor("TOPRIGHT", wnd, 0, 17)
  local infoWnd = wnd:CreateChildWidget("emptywidget", "infoWnd", 0, true)
  infoWnd:SetWidth(bg:GetWidth() - 40)
  infoWnd:AddAnchor("RIGHT", wnd, 0, 0)
  local featureSet = X2Player:GetFeatureSet()
  if featureSet.buyPremiuminSelChar then
    local representBtn = wnd:CreateChildWidget("button", "representBtn", 0, true)
    representBtn:AddAnchor("TOPRIGHT", wnd, -20, 19)
    ApplyButtonSkin(representBtn, BUTTON_STYLE.CHAR_SELECT_PAGE_REPRESENT_CHAR)
    local function LeftClickFunc()
      if X2LoginCharacter:IsDeleteRequestedCharacter(wnd.index) then
        ShowRepresentCharacterMsg(GetUIText(COMMON_TEXT, "waiting_delete_character_represent_character"), false)
      elseif X2LoginCharacter:IsTransferRequestedCharacter(wnd.index) then
        ShowRepresentCharacterMsg(GetUIText(COMMON_TEXT, "server_transfer_character_represent_character"), false)
      else
        ShowRepresentCharacter(wnd.index)
      end
    end
    representBtn:SetHandler("OnClick", LeftClickFunc)
  end
  local representIcon = infoWnd:CreateImageDrawable(TEXTURE_PATH.CHARACTER_SELECT, "artwork")
  representIcon:SetVisible(false)
  representIcon:SetTextureInfo("representative")
  representIcon:AddAnchor("TOPLEFT", infoWnd, 0, 0)
  infoWnd.representIcon = representIcon
  local heirIcon = infoWnd:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor", "artwork")
  heirIcon:AddAnchor("TOPLEFT", infoWnd, 0, -3)
  heirIcon:SetVisible(false)
  infoWnd.heirIcon = heirIcon
  local levelLabel = infoWnd:CreateChildWidget("label", "levelLabel", 0, true)
  levelLabel:SetHeight(FONT_SIZE.LARGE)
  levelLabel:SetAutoResize(true)
  levelLabel:AddAnchor("TOPLEFT", heirIcon, 0, 0)
  ApplyTextColor(levelLabel, F_COLOR.GetColor("white"))
  levelLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  infoWnd.levelLabel = levelLabel
  local jobLabel = infoWnd:CreateChildWidget("label", "jobLabel", 0, true)
  jobLabel:SetHeight(FONT_SIZE.LARGE)
  jobLabel:SetAutoResize(true)
  jobLabel:AddAnchor("LEFT", levelLabel, "RIGHT", 5, 0)
  ApplyTextColor(jobLabel, F_COLOR.GetColor("white"))
  jobLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  infoWnd.jobLabel = jobLabel
  function wnd:UpdateUpperInfo(index)
    self.infoWnd.levelLabel:RemoveAllAnchors()
    self.infoWnd.heirIcon:RemoveAllAnchors()
    self.infoWnd.representIcon:SetVisible(false)
    self.infoWnd.heirIcon:SetVisible(false)
    local representCharIndex = X2LoginCharacter:GetRepresentCharacterIndex()
    local isRepresentChar = representCharIndex == index
    local isHeirChar = IsHeirChar(index)
    if isRepresentChar then
      self.infoWnd.representIcon:SetVisible(true)
      if isHeirChar then
        self.infoWnd.heirIcon:SetVisible(true)
        self.infoWnd.heirIcon:AddAnchor("LEFT", self.infoWnd.representIcon, "RIGHT", 3, 0)
        self.infoWnd.levelLabel:AddAnchor("LEFT", self.infoWnd.heirIcon, "RIGHT", 0, -3)
      else
        self.infoWnd.levelLabel:AddAnchor("LEFT", self.infoWnd.representIcon, "RIGHT", 3, 0)
      end
    elseif isHeirChar then
      self.infoWnd.heirIcon:SetVisible(true)
      self.infoWnd.heirIcon:AddAnchor("TOPLEFT", infoWnd, 0, -3)
      self.infoWnd.levelLabel:AddAnchor("LEFT", self.infoWnd.heirIcon, "RIGHT", 0, 0)
    else
      self.infoWnd.levelLabel:AddAnchor("TOPLEFT", infoWnd, 0, 0)
    end
  end
  function levelLabel:UpdateInfo(index)
    local displayLevel
    local heirLevel = X2LoginCharacter:GetLoginCharacterHeirLevel(index)
    if heirLevel ~= nil and heirLevel > 0 then
      displayLevel = heirLevel
      ApplyTextColor(levelLabel, F_COLOR.GetColor("successor"))
    else
      displayLevel = X2LoginCharacter:GetLoginCharacterLevel(index)
      ApplyTextColor(levelLabel, F_COLOR.GetColor("white"))
    end
    local str = string.format("%s", X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(displayLevel)))
    levelLabel:SetText(str)
  end
  function jobLabel:UpdateInfo(index)
    local abilities = X2LoginCharacter:GetLoginCharacterAbilities(index)
    local job = F_UNIT.GetCombinedAbilityName(abilities[1], abilities[2], abilities[3])
    local str = string.format("%s", job)
    jobLabel:SetText(str)
  end
  local name = infoWnd:CreateChildWidget("label", "name", 0, true)
  name:SetHeight(FONT_SIZE.XXLARGE)
  name:SetAutoResize(true)
  name:AddAnchor("TOPLEFT", infoWnd, 0, levelLabel:GetHeight() + 7)
  ApplyTextColor(name, F_COLOR.GetColor("white"))
  name.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  function name:UpdateInfo(index)
    local nameStr = X2LoginCharacter:GetLoginCharacterName(index)
    nameStr = X2Util:UTF8StringLimit(nameStr, 12, "...")
    name:SetText(nameStr)
  end
  local ownMoney = infoWnd:CreateChildWidget("textbox", "ownMoney", 0, true)
  ownMoney:SetExtent(infoWnd:GetWidth(), FONT_SIZE.LARGE)
  ownMoney:SetAutoResize(true)
  ownMoney:AddAnchor("TOPLEFT", name, "BOTTOMLEFT", 0, 24)
  ApplyTextColor(ownMoney, F_COLOR.GetColor("light_gray"))
  ownMoney.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ownMoney.style:SetAlign(ALIGN_LEFT)
  function ownMoney:UpdateInfo(index)
    local money = X2LoginCharacter:GetLoginCharacterMoney(index)
    local str = string.format("%s|m%s;", locale.characterSelect.availableMoney, money)
    ownMoney:SetText(str)
  end
  local faction = infoWnd:CreateChildWidget("label", "faction", 0, true)
  faction:SetHeight(FONT_SIZE.LARGE)
  faction:SetAutoResize(true)
  faction:AddAnchor("TOPLEFT", ownMoney, "BOTTOMLEFT", 0, 9)
  ApplyTextColor(faction, F_COLOR.GetColor("light_gray"))
  faction.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  function faction:UpdateInfo(index)
    local factionName = ""
    local factionId = X2LoginCharacter:GetLoginCharacterFaction(index)
    if factionId == nil then
      factionName = locale.characterSelect.invalidIndex
    else
      local factionInfo = X2Faction:GetFactionInfo(factionId)
      if factionInfo ~= nil then
        factionName = factionInfo.name or locale.unknown
      else
        factionName = X2LoginCharacter:GetLoginCharacterFactionName(index)
        if string.len(factionName) == 0 then
          factionName = locale.characterSelect.unknownFactionInfo .. "(" .. tostring(chrFaction) .. ")"
        end
      end
    end
    local str = string.format("%s%s", locale.characterSelect.faction, tostring(factionName))
    faction:SetText(str)
  end
  local location = infoWnd:CreateChildWidget("label", "location", 0, true)
  location:SetHeight(FONT_SIZE.LARGE)
  location:SetAutoResize(true)
  location:AddAnchor("TOPLEFT", faction, "BOTTOMLEFT", 0, 9)
  ApplyTextColor(location, F_COLOR.GetColor("light_gray"))
  location.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  function location:UpdateInfo(index)
    local zoneName = X2LoginCharacter:GetLoginCharacterZone(index)
    if zoneName == nil then
      zoneName = locale.unknown
    end
    local str = string.format("%s%s", locale.characterSelect.position, tostring(zoneName))
    location:SetText(str)
  end
  local warning = infoWnd:CreateChildWidget("textbox", "warning", 0, true)
  warning:SetWidth(infoWnd:GetWidth())
  warning:SetAutoResize(true)
  warning:AddAnchor("TOPLEFT", location, "BOTTOMLEFT", 0, 16)
  ApplyTextColor(warning, RED_FONT_COLOR)
  warning.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  warning.style:SetAlign(ALIGN_LEFT)
  warning:SetText(GetUIText(LOGIN_TEXT, "housing_authority_open"))
  warning:Show(false)
  local deleteBtn = wnd:CreateChildWidget("button", "deleteBtn", 0, true)
  deleteBtn:AddAnchor("BOTTOMRIGHT", wnd, "BOTTOMRIGHT", -25, -10)
  ApplyButtonSkin(deleteBtn, BUTTON_STYLE.PLAIN)
  deleteBtn:SetExtent(80, 24)
  deleteBtn:SetAutoResize(true)
  deleteBtn:SetText(GetUIText(LOGIN_DELETE_TEXT, "title"))
  deleteBtn.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.MIDDLE)
  function deleteBtn:OnClick()
    if X2LoginCharacter:IsDeleteRequestedCharacter(wnd.index) then
      X2LoginCharacter:CancelCharacterDelete(wnd.index)
    else
      X2Input:SetInputLanguage("Native")
      ShowDeleteCharacter(background, wnd.index)
    end
  end
  deleteBtn:SetHandler("OnClick", deleteBtn.OnClick)
  function deleteBtn:OnEnter()
    if not deleteBtn:IsEnabled() and wnd.index ~= nil and X2LoginCharacter:IsTransferRequestedCharacter(wnd.index) then
      SetTargetAnchorTooltip(X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "delete_button_tip_transfer"), "TOPRIGHT", self, "BOTTOMRIGHT", 0, 0)
    end
  end
  deleteBtn:SetHandler("OnEnter", deleteBtn.OnEnter)
  function wnd:SetCharacterIndex(index)
    wnd.index = index
    self:UpdateUpperInfo(index)
    levelLabel:UpdateInfo(index)
    jobLabel:UpdateInfo(index)
    name:UpdateInfo(index)
    ownMoney:UpdateInfo(index)
    faction:UpdateInfo(index)
    location:UpdateInfo(index)
    local height = 0
    local _, startY = levelLabel:GetOffset()
    if X2LoginCharacter:IsDeleteRequestedCharacter(index) then
      warning:Show(true)
      local _, endY = warning:GetOffset()
      local heightY = warning:GetHeight()
      height = endY + heightY - startY
      deleteBtn:SetText(GetUIText(CHARACTER_SELECT_TEXT, "cancel_delete"))
      wnd:SetExtent(399, 275)
    else
      warning:Show(false)
      local _, endY = location:GetOffset()
      local heightY = location:GetHeight()
      height = endY + heightY - startY
      deleteBtn:SetText(GetUIText(LOGIN_DELETE_TEXT, "title"))
      wnd:SetExtent(399, 222)
    end
    if X2World:IsPreSelectCharacterPeriod() then
      deleteBtn:Enable(false)
    else
      deleteBtn:Enable(not X2LoginCharacter:IsTransferRequestedCharacter(index))
    end
    infoWnd:SetHeight(height)
    wnd:Show(true)
  end
  return wnd
end
