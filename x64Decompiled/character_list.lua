local GetToolTipText = function(index, reason)
  local requestTransfer = X2LoginCharacter:IsTransferRequestedCharacter(index)
  local forceNameChange = X2LoginCharacter:IsForceNameChangedCharacter(index)
  local canStart = X2LoginCharacter:IsInEnableStartingLocation(index)
  local str
  if requestTransfer then
    str = X2Locale:LocalizeUiText(CHARACTER_SELECT_TEXT, "transfer_icon_tip")
    if X2Player:GetFeatureSet().forbidTransferChar then
      str = GetCommonText("transfer_icon_tip")
    end
  elseif forceNameChange then
    str = locale.characterSelect.character_name_force_changed
  elseif reason ~= nil then
    str = reason
  end
  return str
end
local function CharacteListLayoutFunc(widget, rowIndex, colIndex, subItem)
  local btn = subItem:CreateChildWidget("button", "btn", rowIndex, true)
  ApplyButtonSkin(btn, BUTTON_STYLE.CHAR_LIST_BLUE_SLOT)
  btn:AddAnchor("TOPLEFT", subItem, 0, 2)
  subItem.btn = btn
  local raceSymbol = btn:CreateDrawable(TEXTURE_PATH.CHARACTER_SELECT, "nuian_symbol", "artwork")
  raceSymbol:AddAnchor("RIGHT", btn, 0, 0)
  subItem.raceSymbol = raceSymbol
  local representIcon = btn:CreateImageDrawable(TEXTURE_PATH.CHARACTER_SELECT, "artwork")
  representIcon:SetVisible(false)
  representIcon:SetTextureInfo("representative")
  representIcon:AddAnchor("TOPLEFT", subItem, 15, 17)
  subItem.representIcon = representIcon
  local heirIcon = btn:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "successor", "artwork")
  heirIcon:AddAnchor("TOPLEFT", subItem, 15, 17)
  heirIcon:SetVisible(false)
  subItem.heirIcon = heirIcon
  local levelLabel = btn:CreateChildWidget("label", "levelLabel", 0, true)
  levelLabel:SetHeight(FONT_SIZE.LARGE)
  levelLabel:SetAutoResize(true)
  levelLabel:AddAnchor("TOPLEFT", subItem, 15, 17)
  ApplyTextColor(levelLabel, F_COLOR.GetColor("character_slot_df"))
  levelLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  levelLabel.style:SetAlign(ALIGN_LEFT)
  subItem.levelLabel = levelLabel
  local jobLabel = btn:CreateChildWidget("label", "jobLabel", 0, true)
  jobLabel:SetHeight(FONT_SIZE.LARGE)
  jobLabel:SetAutoResize(true)
  jobLabel:AddAnchor("LEFT", levelLabel, "RIGHT", 5, 0)
  ApplyTextColor(jobLabel, F_COLOR.GetColor("character_slot_df"))
  jobLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  subItem.jobLabel = jobLabel
  local exInfo = btn:CreateChildWidget("label", "remainTime", 0, true)
  exInfo:SetHeight(FONT_SIZE.LARGE)
  exInfo:SetAutoResize(true)
  exInfo:AddAnchor("TOPRIGHT", btn, -10, 15)
  exInfo.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  exInfo.style:SetAlign(ALIGN_RIGHT)
  exInfo:Show(false)
  subItem.exInfo = exInfo
  local selectBg = btn:CreateDrawable(TEXTURE_PATH.CHARACTER_SELECT, "blue_slot_over_img", "overlay")
  selectBg:AddAnchor("TOPLEFT", btn, 0, 0)
  selectBg:Show(false)
  subItem.selectBg = selectBg
  local renameBtn = widget:CreateChildWidget("button", "renameBtn", rowIndex, true)
  ApplyButtonSkin(renameBtn, BUTTON_STYLE.PLAIN)
  renameBtn.style:SetFontSize(FONT_SIZE.LARGE)
  renameBtn:SetExtent(84, 34)
  renameBtn:SetAutoResize(true)
  renameBtn:SetText(locale.characterSelect.renameCharacter.title)
  renameBtn:AddAnchor("RIGHT", subItem, "LEFT", -15, 0)
  subItem.renameBtn = renameBtn
  local BtnLeftClickFunc = function(self)
    SelectCharacter(self.index)
  end
  btn:SetHandler("OnClick", BtnLeftClickFunc)
  local function RenameBtnLeftClickFunc(self)
    if btn.index ~= nil then
      local name = X2LoginCharacter:GetLoginCharacterName(btn.index)
      ShowRenameCharacter(btn.index, name)
    end
  end
  renameBtn:SetHandler("OnClick", RenameBtnLeftClickFunc)
  local delay = 300
  function exInfo:OnUpdate(dt)
    delay = delay + dt
    if delay > 300 then
      delay = 0
      local remain = X2LoginCharacter:GetCharacterDeleteWaitingTime(btn.index)
      if remain == nil then
        exInfo:SetText("???")
      else
        local remainStr = GetRemainTimeString(remain)
        exInfo:SetText(remainStr)
        if subItem.onEnter then
          local str = GetUIText(LOGIN_TEXT, "remain_time", remainStr)
          SetLoingStageTargetAnchorTooltip(str, "BOTTOMRIGHT", subItem, "TOPRIGHT", -10, 15)
        end
      end
    end
  end
  function exInfo:OnShow()
    local requestDelete = X2LoginCharacter:IsDeleteRequestedCharacter(btn.index)
    local requestTransfer = X2LoginCharacter:IsTransferRequestedCharacter(btn.index)
    if requestDelete then
      exInfo:SetHandler("OnUpdate", exInfo.OnUpdate)
    elseif requestTransfer then
      exInfo:SetText(GetCommonText("waiting_char_transfer"))
    end
  end
  exInfo:SetHandler("OnShow", exInfo.OnShow)
  function exInfo:OnHide()
    exInfo:SetText("")
    exInfo:ReleaseHandler("OnUpdate")
  end
  exInfo:SetHandler("OnHide", exInfo.OnHide)
  function btn:OnEnter()
    if not subItem.selected then
      ApplyTextColor(jobLabel, F_COLOR.GetColor("character_slot_ov"))
      if subItem.levelInfo ~= nil then
        if subItem.levelInfo.isHeirChar then
          ApplyTextColor(levelLabel, F_COLOR.GetColor("character_slot_successor_ov"))
        else
          ApplyTextColor(levelLabel, F_COLOR.GetColor("character_slot_ov"))
        end
      end
    end
    if subItem.showTooltip == true or subItem.reason ~= nil then
      str = GetToolTipText(btn.index, subItem.reason)
      SetLoingStageTargetAnchorTooltip(str, "BOTTOMRIGHT", subItem, "TOPRIGHT", -10, 15)
    end
    subItem.onEnter = true
    subItem.selectBg:Show(true)
  end
  btn:SetHandler("OnEnter", btn.OnEnter)
  function btn:OnLeave()
    if not subItem.selected then
      ApplyTextColor(jobLabel, F_COLOR.GetColor("character_slot_df"))
      if subItem.levelInfo ~= nil then
        if subItem.levelInfo.isHeirChar then
          ApplyTextColor(levelLabel, F_COLOR.GetColor("character_slot_successor_df"))
        else
          ApplyTextColor(levelLabel, F_COLOR.GetColor("character_slot_df"))
        end
      end
    end
    subItem.onEnter = false
    subItem.selectBg:Show(false)
  end
  btn:SetHandler("OnLeave", btn.OnLeave)
end
local raceSymnolInfo = {
  nuian = "nuian_symbol",
  elf = "elf_symbol",
  dwarf = "dwarf_symbol",
  ferre = "ferre_symbol",
  hariharan = "hariharan_symbol",
  warborn = "warborn_symbol"
}
local function CharacteListDataFunc(subItem, index, setValue)
  if setValue then
    subItem.btn:Show(true)
    subItem.btn:Enable(true)
    subItem.selectBg:SetTextureInfo("blue_slot_over_img")
    subItem.selectBg:Show(false)
    subItem.renameBtn:Show(false)
    subItem.exInfo:Show(false)
    subItem.heirIcon:SetVisible(false)
    subItem.levelLabel:Show(false)
    subItem.jobLabel:Show(false)
    subItem.raceSymbol:Show(false)
    subItem.representIcon:SetVisible(false)
    subItem.heirIcon:RemoveAllAnchors()
    subItem.levelLabel:RemoveAllAnchors()
    subItem.btn.index = index
    subItem.selected = false
    subItem.showTooltip = false
    subItem.reason = nil
    subItem.onEnter = false
    local charIndex = X2LoginCharacter:GetLastPlayedCharacterIndex()
    local charCount = X2LoginCharacter:GetNumLoginCharacters()
    local remain = GetRemainCreatableCharacterCount()
    local representCharIndex = X2LoginCharacter:GetRepresentCharacterIndex()
    if index <= charCount then
      local heirLevel = X2LoginCharacter:GetLoginCharacterHeirLevel(index)
      local isRepresentChar = representCharIndex == index
      local isHeirChar = heirLevel ~= nil and heirLevel > 0
      local levelInfo = {
        level = isHeirChar and heirLevel or X2LoginCharacter:GetLoginCharacterLevel(index),
        isHeirChar = isHeirChar
      }
      subItem.levelInfo = levelInfo
      if isHeirChar then
        ApplyTextColor(subItem.levelLabel, F_COLOR.GetColor("character_slot_successor_df"))
      else
        ApplyTextColor(subItem.levelLabel, F_COLOR.GetColor("character_slot_df"))
      end
      local str = string.format("%s", X2Locale:LocalizeUiText(COMMON_TEXT, "character_level", tostring(levelInfo.level)))
      subItem.levelLabel:SetText(str)
      subItem.levelLabel:Show(true)
      ApplyTextColor(subItem.jobLabel, F_COLOR.GetColor("character_slot_df"))
      local abilities = X2LoginCharacter:GetLoginCharacterAbilities(index)
      local job = F_UNIT.GetCombinedAbilityName(abilities[1], abilities[2], abilities[3])
      local str = string.format("%s", job)
      subItem.jobLabel:SetText(str)
      subItem.jobLabel:Show(true)
      local name = X2LoginCharacter:GetLoginCharacterName(index)
      subItem.btn:SetText(name)
      local requestDelete = X2LoginCharacter:IsDeleteRequestedCharacter(index)
      local requestTransfer = X2LoginCharacter:IsTransferRequestedCharacter(index)
      local forceNameChange = X2LoginCharacter:IsForceNameChangedCharacter(index)
      local canStart = X2LoginCharacter:IsInEnableStartingLocation(index)
      if forceNameChange or requestDelete or requestTransfer and X2Player:GetFeatureSet().forbidTransferChar then
        subItem.selectBg:SetTextureInfo("red_slot_over_img")
        if charIndex == index then
          ApplyButtonSkin(subItem.btn, LIST_BUTTON.SELECT_RED_SLOT)
        else
          ApplyButtonSkin(subItem.btn, LIST_BUTTON.RED_SLOT)
        end
        subItem.showTooltip = true
      elseif not canStart then
        subItem.reason = locale.characterCreate.race_congestion_warning
        subItem.selectBg:SetTextureInfo("red_slot_over_img")
        if charIndex == index then
          ApplyButtonSkin(subItem.btn, LIST_BUTTON.SELECT_RED_SLOT)
        else
          ApplyButtonSkin(subItem.btn, LIST_BUTTON.RED_SLOT)
        end
      elseif charIndex == index then
        ChangeButtonSkin(subItem.btn, BUTTON_STYLE.CHAR_LIST_SELECT_BLUE_SLOT)
      else
        ChangeButtonSkin(subItem.btn, BUTTON_STYLE.CHAR_LIST_BLUE_SLOT)
      end
      if requestTransfer then
        ApplyTextColor(subItem.exInfo, F_COLOR.GetColor("light_blue"))
        subItem.exInfo:Show(true)
      elseif requestDelete then
        ApplyTextColor(subItem.exInfo, F_COLOR.GetColor("light_red"))
        subItem.exInfo:Show(true)
      end
      if charIndex == index then
        if isHeirChar then
          ApplyTextColor(subItem.levelLabel, F_COLOR.GetColor("character_slot_successor_ov"))
        else
          ApplyTextColor(subItem.levelLabel, F_COLOR.GetColor("white"))
        end
        ApplyTextColor(subItem.jobLabel, F_COLOR.GetColor("white"))
        SetButtonFontColorByKey(subItem.btn, "white", true)
        subItem.selected = true
      end
      subItem.representIcon:SetVisible(isRepresentChar)
      subItem.heirIcon:SetVisible(isHeirChar)
      if isRepresentChar then
        if isHeirChar then
          subItem.heirIcon:AddAnchor("LEFT", subItem.representIcon, "RIGHT", 3, -1)
          subItem.levelLabel:AddAnchor("LEFT", subItem.heirIcon, "RIGHT", 0, 0)
        else
          subItem.levelLabel:AddAnchor("LEFT", subItem.representIcon, "RIGHT", 3, -1)
        end
      elseif isHeirChar then
        subItem.heirIcon:AddAnchor("TOPLEFT", subItem, 13, 15)
        subItem.levelLabel:AddAnchor("LEFT", subItem.heirIcon, "RIGHT", 0, 0)
      else
        subItem.levelLabel:AddAnchor("TOPLEFT", subItem, 13, 15)
      end
      local raceStr = X2LoginCharacter:GetLoginCharacterRace(index)
      subItem.raceSymbol:SetTextureInfo(raceSymnolInfo[raceStr])
      subItem.raceSymbol:Show(true)
      subItem.renameBtn:Show(forceNameChange)
    elseif X2World:ForbidCharCreation() then
      ApplyButtonSkin(subItem.btn, LIST_BUTTON.IMPOSSIBLE_SLOT)
      subItem.btn:Enable(false)
      subItem.btn:SetText(GetCommonText("impossible_to_create_character"))
      subItem.reason = GetUIText(LOGIN_CROWDED_TEXT, "no_create_race")
    elseif X2World:IsPreSelectCharacterPeriod() then
      if X2World:CanPreSelectCharacter() then
        ApplyButtonSkin(subItem.btn, LIST_BUTTON.POSSIBLE_SLOT)
        subItem.btn:SetText(GetUIText(CHARACTER_SELECT_TEXT, "create"))
      else
        ApplyButtonSkin(subItem.btn, LIST_BUTTON.IMPOSSIBLE_SLOT)
        subItem.btn:Enable(false)
        subItem.btn:SetText(GetCommonText("impossible_to_create_character"))
      end
    elseif index <= charCount + remain then
      ApplyButtonSkin(subItem.btn, LIST_BUTTON.POSSIBLE_SLOT)
      subItem.btn:SetText(GetUIText(CHARACTER_SELECT_TEXT, "create"))
    else
      ApplyButtonSkin(subItem.btn, LIST_BUTTON.IMPOSSIBLE_SLOT)
      subItem.btn:Enable(false)
      subItem.btn:SetText(GetCommonText("impossible_to_create_character"))
      if not X2World:IsPreSelectCharacterPeriod() then
        if charCount ~= X2World:GetCharactersCountPerWorld(X2:GetCurrentWorldId()) then
          subItem.reason = locale.characterSelect.character_count_not_match
        elseif 0 < X2World:GetCharacterExpandableLimit() - X2World:GetExpandedCharacterCount() then
          subItem.reason = locale.characterSelect.max_character_count_warning2
        else
          subItem.reason = locale.characterSelect.max_character_count_warning
        end
      end
    end
  else
    subItem.btn:Show(false)
  end
end
function CreateCharacterListWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd:SetExtent(376, 90 * MAX_CHARACTER_COUNT)
  local list = W_CTRL.CreateScrollListCtrl("list", wnd)
  list:SetExtent(376, 90 * MAX_CHARACTER_COUNT)
  list:AddAnchor("TOPLEFT", wnd, 0, 0)
  list:HideColumnButtons()
  list:InsertColumn("", list.listCtrl:GetWidth(), LCCIT_WINDOW, CharacteListDataFunc, nil, nil, CharacteListLayoutFunc)
  list:InsertRows(MAX_CHARACTER_COUNT, false)
  list.scroll:RemoveAllAnchors()
  list.scroll:AddAnchor("TOPRIGHT", list, 0, 2)
  list.scroll:AddAnchor("BOTTOMRIGHT", list, 0, -10)
  list.scroll.vs:RemoveAllAnchors()
  list.scroll.vs:AddAnchor("TOPLEFT", list.scroll.upButton, "BOTTOMLEFT", -1, 0)
  list.scroll.vs:AddAnchor("BOTTOMRIGHT", list.scroll.downButton, "TOPRIGHT", 1, 0)
  ApplyButtonSkin(list.scroll.upButton, CUSTOM_SCROLL_WND.TOP)
  ApplyButtonSkin(list.scroll.downButton, CUSTOM_SCROLL_WND.BOTTOM)
  ApplyButtonSkin(list.scroll.vs.thumb, CUSTOM_SCROLL_WND.THUMB)
  list.scroll.bg:SetTexture(TEXTURE_PATH.DEFAULT_NEW)
  list.scroll.bg:SetTextureInfo("scroll_bar")
  list.scroll:SetBgColor(GetTextureInfo(TEXTURE_PATH.DEFAULT_NEW, "scroll_bar"):GetColors().default)
  list.scroll.bg:AddAnchor("TOPLEFT", list.scroll.vs, 5, -5)
  list.scroll.bg:AddAnchor("BOTTOMRIGHT", list.scroll.vs, -5, 5)
  list.scroll:SetWidth(16)
  local init = false
  local tmpMaxCharSlot = X2World:GetTmpMaxCharSlot() or 0
  function wnd:RefreshList()
    list:UpdateView()
    local charCount = X2LoginCharacter:GetNumLoginCharacters()
    local worldLimit = X2World:GetCharactersDefaultLimitPerWorld()
    local expandable = X2World:GetCharacterExpandableLimit()
    local tmpMaxCharSlot = X2World:GetTmpMaxCharSlot() or 0
    if tmpMaxCharSlot > 0 then
      worldLimit = math.min(tmpMaxCharSlot, worldLimit)
      expandable = 0
      for i = tmpMaxCharSlot + 1, #list.listCtrl.items do
        list.listCtrl.items[i]:Show(false)
      end
    else
      for i = 1, #list.listCtrl.items do
        list.listCtrl.items[i]:Show(true)
      end
    end
    local worldSlotCount = math.max(worldLimit + expandable, MAX_CHARACTER_COUNT)
    if charCount > worldSlotCount then
      worldSlotCount = charCount
    end
    local scrollMax = math.max(0, charCount - MAX_CHARACTER_COUNT)
    if charCount >= MAX_CHARACTER_COUNT and worldLimit - charCount > 0 then
      scrollMax = scrollMax + 1
    end
    list:SetMinMaxValues(0, scrollMax)
    list:Lock(scrollMax == 0)
  end
  local function Init()
    local charCount = X2LoginCharacter:GetNumLoginCharacters()
    local worldLimit = X2World:GetCharactersDefaultLimitPerWorld()
    local expandable = X2World:GetCharacterExpandableLimit()
    local tmpMaxCharSlot = X2World:GetTmpMaxCharSlot() or 0
    if tmpMaxCharSlot > 0 then
      worldLimit = math.min(tmpMaxCharSlot, worldLimit)
      expandable = 0
      for i = tmpMaxCharSlot + 1, #list.listCtrl.items do
        list.listCtrl.items[i]:Show(false)
      end
    else
      for i = 1, #list.listCtrl.items do
        list.listCtrl.items[i]:Show(true)
      end
    end
    local worldSlotCount = math.max(worldLimit + expandable, MAX_CHARACTER_COUNT)
    if charCount > worldSlotCount then
      worldSlotCount = charCount
    end
    local scrollMax = math.max(0, charCount - MAX_CHARACTER_COUNT)
    if charCount >= MAX_CHARACTER_COUNT and worldLimit - charCount > 0 then
      scrollMax = scrollMax + 1
    end
    list:DeleteAllDatas()
    for index = 1, worldSlotCount do
      list:InsertData(index, 1, index)
    end
    list:SetMinMaxValues(0, scrollMax)
    list:Lock(scrollMax == 0)
    local selectIndex = X2LoginCharacter:GetLastPlayedCharacterIndex()
    if selectIndex ~= nil and selectIndex > MAX_CHARACTER_COUNT then
      list:ScrollToDataIndex(selectIndex, math.min(selectIndex, MAX_CHARACTER_COUNT))
    end
  end
  Init()
  function wnd:UpdateList()
    list:UpdateView()
  end
  return wnd
end
