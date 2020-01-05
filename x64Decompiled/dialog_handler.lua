local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local SetDialogTexts = function(wnd, infoTexts)
  if infoTexts.resize == nil then
    infoTexts.resize = true
  end
  if infoTexts.title ~= nil then
    wnd:SetTitle(infoTexts.title)
  end
  if infoTexts.content ~= nil then
    wnd:SetContent(infoTexts.content, infoTexts.resize)
  end
end
local MakeItemDesc = function(gradeColor, name, count)
  if count > 1 then
    return string.format("|c%s[%s]|rx%s", gradeColor, name, count)
  else
    return string.format("|c%s[%s]", gradeColor, name)
  end
end
local function DialogJoinFamilyHandler(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_family_invite")
  if infoTable.familyTitle == "" then
    infoTable.content = GetCommonText("family_invitee_content", FONT_COLOR_HEX.BLUE, infoTable.invitorName)
  else
    infoTable.content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_family_invite", string.format("%s%s|r", FONT_COLOR_HEX.BLUE, infoTable.invitorName), string.format("%s", infoTable.familyTitle))
  end
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_TASK_JOIN_FAMILY, DialogJoinFamilyHandler)
local function DialogJoinInstantGameHandler(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_to_join_instant_game")
  infoTable.content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_to_join_instant_game", infoTable.name)
  if infoTable.isIndunZone then
    infoTable.title = GetCommonText("indun_entrance_title")
    infoTable.content = X2Locale:LocalizeUiText(COMMON_TEXT, "ask_to_join_indun_entrance", infoTable.name)
  end
  SetDialogTexts(wnd, infoTable)
  local checkTime = infoTable.autoCancelTime
  local function OnUpdate(self, dt)
    if self:IsVisible() == false then
      return
    end
    checkTime = checkTime - dt
    if checkTime > 0 then
      return
    end
    X2DialogManager:OnCancel(wnd:GetId())
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
end
X2DialogManager:SetHandler(DLG_TASK_JOIN_INSTANT_GAME, DialogJoinInstantGameHandler)
local function DialogJoinInstantGameInvitationHandler(wnd, infoTable)
  infoTable.title = GetCommonText("ask_to_join_instant_game_title_for_squad")
  infoTable.content = GetCommonText("ask_to_join_instant_game_content_for_squad", FONT_COLOR_HEX.RED)
  local joinSquadInfoBox = wnd:CreateChildWidget("emptywidget", "joinSquadInfoBox", 0, true)
  joinSquadInfoBox:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  joinSquadInfoBox:SetExtent(430, 110)
  wnd.joinSquadInfoBox = joinSquadInfoBox
  local fieldNameLabel = joinSquadInfoBox:CreateChildWidget("label", "fieldNameLabel", 0, true)
  fieldNameLabel:AddAnchor("TOPLEFT", joinSquadInfoBox, "TOPLEFT", 20, 0)
  fieldNameLabel.style:SetAlign(ALIGN_CENTER)
  fieldNameLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  fieldNameLabel:SetExtent(172, 25)
  ApplyTextColor(fieldNameLabel, FONT_COLOR.DEFAULT)
  fieldNameLabel:SetText(GetCommonText("entrance_battle_field"))
  local fieldNameText = joinSquadInfoBox:CreateChildWidget("label", "fieldNameText", 0, true)
  fieldNameText:AddAnchor("LEFT", fieldNameLabel, "RIGHT", 5, 0)
  fieldNameText.style:SetAlign(ALIGN_LEFT)
  fieldNameText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  fieldNameText:SetExtent(172, 25)
  ApplyTextColor(fieldNameText, FONT_COLOR.BLUE)
  fieldNameText:SetText(infoTable.name)
  local entranceCountLabel = joinSquadInfoBox:CreateChildWidget("label", "entranceCountLabel", 0, true)
  entranceCountLabel:AddAnchor("TOPLEFT", fieldNameLabel, "BOTTOMLEFT", 0, 0)
  entranceCountLabel.style:SetAlign(ALIGN_CENTER)
  entranceCountLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  entranceCountLabel:SetExtent(172, 25)
  ApplyTextColor(entranceCountLabel, FONT_COLOR.DEFAULT)
  entranceCountLabel:SetText(GetCommonText("entrance_enable_count"))
  local entranceCountText = joinSquadInfoBox:CreateChildWidget("label", "entranceCountText", 0, true)
  entranceCountText:AddAnchor("LEFT", entranceCountLabel, "RIGHT", 5, 0)
  entranceCountText.style:SetAlign(ALIGN_LEFT)
  entranceCountText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  entranceCountText:SetExtent(172, 25)
  ApplyTextColor(entranceCountText, FONT_COLOR.BLUE)
  entranceCountText:SetText(string.format("%d / %d", infoTable.enterCount, infoTable.maxEnterCount))
  local bgImg = joinSquadInfoBox:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bgImg:SetTextureColor("darksand")
  bgImg:AddAnchor("TOPLEFT", fieldNameLabel, 0, -5)
  bgImg:AddAnchor("BOTTOMRIGHT", entranceCountLabel, 0, 5)
  local waitingCountLabel = joinSquadInfoBox:CreateChildWidget("label", "waitingCountLabel", 0, true)
  waitingCountLabel:AddAnchor("TOPLEFT", entranceCountLabel, "BOTTOMLEFT", 0, 5)
  waitingCountLabel.style:SetAlign(ALIGN_CENTER)
  waitingCountLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  waitingCountLabel:SetExtent(172, 25)
  ApplyTextColor(waitingCountLabel, FONT_COLOR.DEFAULT)
  waitingCountLabel:SetText(GetCommonText("entrance_waiting_count"))
  local waitingCountText = joinSquadInfoBox:CreateChildWidget("label", "waitingCountText", 0, true)
  waitingCountText:AddAnchor("LEFT", waitingCountLabel, "RIGHT", 5, 0)
  waitingCountText.style:SetAlign(ALIGN_LEFT)
  waitingCountText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  waitingCountText:SetExtent(172, 25)
  ApplyTextColor(waitingCountText, FONT_COLOR.BLUE)
  waitingCountText:SetText(string.format("%d / %d", infoTable.accept, infoTable.entrySize))
  local remainTimeLabel = joinSquadInfoBox:CreateChildWidget("label", "remainTimeLabel", 0, true)
  remainTimeLabel:AddAnchor("TOPLEFT", waitingCountLabel, "BOTTOMLEFT", 0, 0)
  remainTimeLabel.style:SetAlign(ALIGN_CENTER)
  remainTimeLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  remainTimeLabel:SetExtent(172, 25)
  ApplyTextColor(remainTimeLabel, FONT_COLOR.DEFAULT)
  remainTimeLabel:SetText(locale.tooltip.leftTime)
  local remainTimeText = joinSquadInfoBox:CreateChildWidget("label", "remainTimeText", 0, true)
  remainTimeText:AddAnchor("LEFT", remainTimeLabel, "RIGHT", 5, 0)
  remainTimeText.style:SetAlign(ALIGN_LEFT)
  remainTimeText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  remainTimeText:SetExtent(172, 25)
  ApplyTextColor(remainTimeText, FONT_COLOR.BLUE)
  remainTimeText:SetText("")
  local bgImg2 = joinSquadInfoBox:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bgImg2:SetTextureColor("darksand")
  bgImg2:AddAnchor("TOPLEFT", waitingCountLabel, 0, -5)
  bgImg2:AddAnchor("BOTTOMRIGHT", remainTimeLabel, 0, 5)
  wnd.btnOk:AddAnchor("BOTTOM", wnd, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local btnCancel = wnd:CreateChildWidget("button", "btnCancel", 0, false)
  btnCancel:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(btnCancel, BUTTON_BASIC.DEFAULT)
  btnCancel:AddAnchor("BOTTOM", wnd, BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  wnd:RegistBottomWidget(joinSquadInfoBox)
  SetDialogTexts(wnd, infoTable)
  wnd:SetWidth(430)
  local checkTime = infoTable.autoCancelTime
  local function OnUpdate(self, dt)
    if self:IsVisible() == false then
      return
    end
    remainTimeText:SetText(string.format("%d", checkTime / 1000))
    checkTime = checkTime - dt
    if checkTime > 0 then
      return
    end
    X2DialogManager:OnCustom(wnd:GetId(), 2)
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
  local function OkBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), 0)
  end
  wnd.btnOk:SetHandler("OnClick", OkBtnClickFunc)
  local function CancelBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), 1)
  end
  btnCancel:SetHandler("OnClick", CancelBtnClickFunc)
  local events = {
    UPDATE_INSTANT_GAME_INVITATION_COUNT = function(accept, totalSize)
      waitingCountText:SetText(string.format("%d / %d", accept, totalSize))
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_JOIN_INSTANT_GAME_INVITATION, DialogJoinInstantGameInvitationHandler)
function DialogJoinInstantGameInvitationWaitingHandler(wnd, infoTable)
  infoTable.title = GetCommonText("view_entrance_waiting_title")
  infoTable.content = GetCommonText("view_entrance_waiting_content")
  local waitingInfoBox = wnd:CreateChildWidget("emptywidget", "waitingInfoBox", 0, true)
  waitingInfoBox:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  waitingInfoBox:SetExtent(430, 55)
  wnd.waitingInfoBox = waitingInfoBox
  local fieldNameLabel = waitingInfoBox:CreateChildWidget("label", "fieldNameLabel", 0, true)
  fieldNameLabel:AddAnchor("TOPLEFT", waitingInfoBox, "TOPLEFT", 20, 0)
  fieldNameLabel.style:SetAlign(ALIGN_CENTER)
  fieldNameLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  fieldNameLabel:SetExtent(162, 25)
  ApplyTextColor(fieldNameLabel, FONT_COLOR.DEFAULT)
  fieldNameLabel:SetText(GetCommonText("entrance_battle_field"))
  local fieldNameText = waitingInfoBox:CreateChildWidget("label", "fieldNameText", 0, true)
  fieldNameText:AddAnchor("LEFT", fieldNameLabel, "RIGHT", 5, 0)
  fieldNameText.style:SetAlign(ALIGN_LEFT)
  fieldNameText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  fieldNameText:SetExtent(200, 25)
  ApplyTextColor(fieldNameText, FONT_COLOR.BLUE)
  fieldNameText:SetText(infoTable.name)
  local countLabel = waitingInfoBox:CreateChildWidget("label", "countLabel", 0, true)
  countLabel:AddAnchor("TOPLEFT", fieldNameLabel, "BOTTOMLEFT", 0, 0)
  countLabel.style:SetAlign(ALIGN_CENTER)
  countLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  countLabel:SetExtent(162, 25)
  ApplyTextColor(countLabel, FONT_COLOR.DEFAULT)
  countLabel:SetText(GetCommonText("entrance_waiting_count"))
  local countText = waitingInfoBox:CreateChildWidget("textbox", "countText", 0, true)
  countText:SetExtent(200, 25)
  countText.style:SetAlign(ALIGN_LEFT)
  countText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  countText:AddAnchor("LEFT", countLabel, "RIGHT", 5, 0)
  ApplyTextColor(countText, FONT_COLOR.BLUE)
  countText:SetText("0 / 0")
  local remainTimeLabel = waitingInfoBox:CreateChildWidget("label", "remainTimeLabel", 0, true)
  remainTimeLabel:AddAnchor("TOPLEFT", countLabel, "BOTTOMLEFT", 0, 0)
  remainTimeLabel.style:SetAlign(ALIGN_CENTER)
  remainTimeLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  remainTimeLabel:SetExtent(162, 25)
  ApplyTextColor(remainTimeLabel, FONT_COLOR.DEFAULT)
  remainTimeLabel:SetText(locale.tooltip.leftTime)
  local remainTimeText = waitingInfoBox:CreateChildWidget("label", "remainTimeText", 0, true)
  remainTimeText:AddAnchor("LEFT", remainTimeLabel, "RIGHT", 5, 0)
  remainTimeText.style:SetAlign(ALIGN_LEFT)
  remainTimeText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  remainTimeText:SetExtent(200, 25)
  ApplyTextColor(remainTimeText, FONT_COLOR.BLUE)
  remainTimeText:SetText("")
  local bgImg = waitingInfoBox:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgImg:SetTextureColor("bg_01")
  bgImg:AddAnchor("TOPLEFT", fieldNameLabel, 0, -5)
  bgImg:AddAnchor("BOTTOMRIGHT", remainTimeLabel, 0, 5)
  wnd.btnOk:Enable(false)
  wnd.btnOk:Show(false)
  wnd.btnOk:RemoveAllAnchors()
  wnd.btnCancel:Enable(false)
  wnd.btnCancel:Show(false)
  wnd.btnCancel:RemoveAllAnchors()
  wnd:RegistBottomWidget(wnd.waitingInfoBox)
  SetDialogTexts(wnd, infoTable)
  wnd:SetExtent(430, wnd:GetHeight() - wnd.btnOk:GetHeight())
  local checkTime = infoTable.remainTime
  local function OnUpdate(self, dt)
    if self:IsVisible() == false then
      return
    end
    remainTimeText:SetText(string.format("%d", checkTime / 1000))
    checkTime = checkTime - dt
    if checkTime > 0 then
      return
    end
    X2DialogManager:OnCancel(wnd:GetId())
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
  local events = {
    UPDATE_INSTANT_GAME_INVITATION_COUNT = function(accept, totalSize)
      countText:SetText(string.format("%d / %d", accept, totalSize))
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_JOIN_INSTANT_GAME_INVITATION_WAITING, DialogJoinInstantGameInvitationWaitingHandler)
local DialogBattleFieldConfirmApply = function(wnd, infoTable)
  local resetBox = wnd:CreateChildWidget("emptywidget", "resetBox", 0, true)
  resetBox:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  resetBox:SetExtent(253, 57)
  wnd.resetBox = resetBox
  local resetBoxBg = resetBox:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  resetBoxBg:SetTextureColor("bg_03")
  resetBoxBg:AddAnchor("TOPLEFT", wnd.resetBox, 0, 0)
  resetBoxBg:AddAnchor("BOTTOMRIGHT", wnd.resetBox, 0, 0)
  local resetText = resetBox:CreateChildWidget("label", "resetText", 0, true)
  resetText:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  resetText:SetAutoResize(true)
  ApplyTextColor(resetText, FONT_COLOR.BLUE)
  local resetBtn = resetBox:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:AddAnchor("LEFT", resetText, "RIGHT", 5, 0)
  ApplyButtonSkin(resetBtn, BUTTON_CONTENTS.ARROW)
  wnd:RegistBottomWidget(wnd.resetBox)
  local resetAvailable = infoTable.resetAvailable
  local interactionNPC = infoTable.interactionNPC
  local battleFieldType = infoTable.battleFieldType
  local content = GetUIText(COMMON_TEXT, "Battlefield_no_reward_warning_content", FONT_COLOR_HEX.RED, FONT_COLOR_HEX.DEFAULT)
  local value = GetUIText(COMMON_TEXT, "Battlefield_recharge_reward_content")
  resetText:SetText(value)
  local resetTextWidth = resetText:GetWidth()
  local resetBtnWidth = resetBtn:GetWidth()
  local horizontalOffset = (resetTextWidth + resetBtnWidth + 5) / 2
  resetText:AddAnchor("LEFT", resetBox, "CENTER", -horizontalOffset, 0)
  resetBtn:Enable(resetAvailable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "Battlefield_entrance"))
  wnd:SetContent(content)
  local function OnClick_ResetBtn()
    X2DialogManager:OnCancel(wnd:GetId())
    X2BattleField:RequestResetVisitCountInstantGame(battleFieldType)
  end
  resetBtn:SetHandler("OnClick", OnClick_ResetBtn)
  local OnEnter_ResetButton = function(eventObj)
    SetTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "Battlefield_cannot_recharge_tooltip"), eventObj)
  end
  local OnLeave_ResetButton = function()
    HideTooltip()
  end
  if not resetAvailable then
    resetBtn:SetHandler("OnEnter", OnEnter_ResetButton)
    resetBtn:SetHandler("OnLeave", OnLeave_ResetButton)
  end
end
X2DialogManager:SetHandler(DLG_TASK_CONFIRM_APPLY_INSTANT_GAME, DialogBattleFieldConfirmApply)
local DialogBattleFieldResetVisitCount = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "Battlefield_reset_visit_count_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "battlefield_reset_visit_count_content"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = {
      infoTable.haveItemCount,
      infoTable.requiredCount
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  local textData = {
    type = "period",
    text = GetUIText(COMMON_TEXT, "battlefield_reset_count_info", tostring(infoTable.resetCount), tostring(infoTable.resetLimit))
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "period", textData)
end
X2DialogManager:SetHandler(DLG_TASK_BATTLE_FIELD_RESET_VISIT_COUNT, DialogBattleFieldResetVisitCount)
local function DialogInviteJuryHandler(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_invite_jury")
  infoTable.content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_invite_jury", string.format("|cFFFF8C00%s|r", infoTable.defendantName))
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_TASK_INVITE_JURY, DialogInviteJuryHandler)
local function DialogImprisionOrTrialHandler(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_imprison_trial")
  infoTable.content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_imprison_trial", tostring(infoTable.crimeValue), string.format("%s%d|r", FONT_COLOR_HEX.RED, infoTable.jailMinutes))
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_TASK_IMPRISION_OR_TRIAL, DialogImprisionOrTrialHandler)
local DialogPerchaseCoinHandler = function(wnd, infoTable)
  wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "confirm_purchase_title"))
  wnd:UpdateDialogModule("textbox", X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "confirm_purchase_coin_body"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = infoTable.itemCount
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  if F_MONEY:IsPrintableCostFormat(infoTable.coinType) then
    local costData = {
      type = "cost",
      itemType = infoTable.coinType,
      value = infoTable.coinCount
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
  end
  local events = {
    INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_PURCHASE_COIN, DialogPerchaseCoinHandler)
local function DialogDoodadPhaseChangeByItemHandler(wnd, infoTable)
  if infoTable.title ~= nil then
    wnd:SetTitle(infoTable.title)
  end
  local datas = {}
  local additionlInfo = {}
  local list = infoTable.list
  for i = 1, #list do
    local itemInfo = list[i].itemInfo
    local need = list[i].need
    local hasCount = list[i].hasCount
    local data = {
      text = string.format(string.format("[%s]x%d", itemInfo.name, need)),
      value = list[i].index,
      color = FONT_COLOR.DEFAULT,
      disableColor = FONT_COLOR.GRAY,
      enable = need <= hasCount,
      useColor = true
    }
    table.insert(datas, data)
    local info = {
      itemInfo = itemInfo,
      hasCount = hasCount,
      need = need,
      requireLaborPower = list[i].requireLaborPower
    }
    table.insert(additionlInfo, info)
  end
  local desc = wnd:CreateChildWidget("textbox", "desc", 0, false)
  desc:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 30)
  desc:AddAnchor("TOP", wnd, 0, titleMargin)
  ApplyTextColor(desc, FONT_COLOR.DEFAULT)
  if infoTable.desc ~= nil then
    desc:SetText(infoTable.desc)
    desc:SetHeight(desc:GetTextHeight())
  end
  local itemIcon = CreateItemIconButton("itemIcon", wnd)
  itemIcon:AddAnchor("TOP", desc, "BOTTOM", 0, sideMargin / 2)
  local comboBox = W_CTRL.CreateComboBox("comboBox", wnd)
  comboBox:AddAnchor("TOP", itemIcon, "BOTTOM", 0, sideMargin / 2)
  comboBox:AppendItems(datas, false)
  comboBox:SetVisibleItemCount(10)
  comboBox:SetGuideText(GetUIText(TOOLTIP_TEXT, "selectMaterialItem"))
  local requireLaborPower = wnd:CreateChildWidget("label", "requireLaborPower", 0, false)
  requireLaborPower:Show(false)
  requireLaborPower:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  requireLaborPower:AddAnchor("TOP", comboBox, "BOTTOM", 0, sideMargin / 2)
  ApplyTextColor(requireLaborPower, FONT_COLOR.DEFAULT)
  local function FillRequireLaborPower(amount)
    if amount == 0 then
      requireLaborPower:Show(false)
      return
    end
    requireLaborPower:Show(true)
    requireLaborPower:SetText(string.format("%s%d", GetUIText(CRAFT_TEXT, "require_labor_power"), amount))
  end
  wnd.btnOk:AddAnchor("BOTTOM", wnd, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  wnd.btnOk:Enable(false)
  local btnCancel = wnd:CreateChildWidget("button", "btnCancel", 0, true)
  btnCancel:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(btnCancel, BUTTON_BASIC.DEFAULT)
  btnCancel:AddAnchor("BOTTOM", wnd, BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  wnd:RegistBottomWidget(requireLaborPower)
  local index = 0
  function comboBox:SelectedProc(selIdx)
    if additionlInfo[selIdx] ~= nil then
      local info = additionlInfo[selIdx]
      FillRequireLaborPower(info.requireLaborPower)
      itemIcon:SetItemInfo(info.itemInfo)
      itemIcon:SetStack(info.hasCount, info.need)
      local haveLp = X2Player:GetTotalLaborPower()
      wnd.btnOk:Enable(info.hasCount >= info.need and haveLp >= info.requireLaborPower)
      local selectedInfo = self:GetSelectedInfo()
      index = selectedInfo.value
    end
  end
  local function OkBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), index)
  end
  wnd.btnOk:SetHandler("OnClick", OkBtnClickFunc)
  local function CancelBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), 0)
  end
  btnCancel:SetHandler("OnClick", CancelBtnClickFunc)
  local events = {
    INTERACTION_END = function()
      CancelBtnClickFunc()
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_DOODAD_PHASE_CHANGE_BY_ITEM, DialogDoodadPhaseChangeByItemHandler)
local DialogConvertItemHandler = function(wnd, infoTable)
  wnd:SetTitle(infoTable.title)
  wnd:UpdateDialogModule("textbox", infoTable.content)
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  if infoTable.autoReuse then
    local textData = {
      type = "warning",
      text = GetUIText(COMMON_TEXT, "convert_dialog_info_text")
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
  end
  function wnd:GetOkSound()
    return "message_box_convert_item"
  end
end
X2DialogManager:SetHandler(DLG_TASK_CONVERT_ITEM, DialogConvertItemHandler)
local DialogRechargeItemHandler = function(wnd, infoTable)
  wnd:SetSounds("wash")
  local itemRechargeTypes = infoTable.rechargeTypes
  local checkTime = 30000
  local function OnUpdate(self, dt)
    local UpdateRemainTime = function(info, rechargeType)
      local remainTime, rechargeString
      if rechargeType == IRT_BUFF then
        remainTime = info.rechargeBuff.remainTime
        rechargeString = locale.tooltip.equip_effect
      elseif rechargeType == IRT_SKILL then
        remainTime = info.rechargeSkill.remainTime
        rechargeString = locale.tooltip.use_effect
      elseif rechargeType == IRT_RND_ATTR_UNIT_MODIFIER then
        remainTime = info.evolvingInfo.remainTime
        rechargeString = X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_effect")
      elseif rechargeType == IRT_PROC then
        remainTime = info.rechargeProc.remainTime
        rechargeString = locale.tooltip.proc
      else
        return nil
      end
      if remainTime == nil then
        return nil
      end
      local stringTime = ""
      if locale.time.IsEmptyDateFormat(remainTime) then
        stringTime = string.format("%s%s: %s|r", FONT_COLOR_HEX.GRAY, rechargeString, X2Locale:LocalizeUiText(TOOLTIP_TEXT, "expiration"))
      else
        stringTime = locale.time.GetRemainDateToDateFormat(remainTime)
        stringTime = string.format("%s: %s %s", rechargeString, stringTime, locale.housing.left)
      end
      return stringTime
    end
    checkTime = checkTime + dt
    if checkTime < 30000 then
      return
    end
    local info = infoTable.itemInfo
    if info == nil then
      return
    end
    local periodTextboxStr = ""
    for i = 1, #itemRechargeTypes do
      local itemRechargeType = itemRechargeTypes[i]
      local timeString = UpdateRemainTime(info, itemRechargeType)
      if timeString ~= nil then
        periodTextboxStr = F_TEXT.SetEnterString(periodTextboxStr, timeString)
      end
    end
    if periodTextboxStr ~= "" then
      local textData = {type = "period", text = periodTextboxStr}
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "period", textData)
    end
  end
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "ask_recharge_item"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_recharge_item"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  wnd:SetHandler("OnUpdate", OnUpdate)
  OnUpdate(wnd, 0)
end
X2DialogManager:SetHandler(DLG_TASK_RECHARGE_ITEM, DialogRechargeItemHandler)
local SecurityLockItemWithMoney = function(wnd, value)
  local costHeight = 10
  local costOffsetX = 20
  local valueTextbox = wnd:CreateChildWidget("textbox", "valueTextbox", 0, true)
  valueTextbox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH / 2, 35)
  valueTextbox.style:SetAlign(ALIGN_RIGHT)
  valueTextbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  valueTextbox:AddAnchor("TOPRIGHT", wnd.itemTextbox, "BOTTOMRIGHT", -costOffsetX, costHeight)
  ApplyTextColor(valueTextbox, FONT_COLOR.TITLE)
  local valueBg = CreateContentBackground(valueTextbox, "TYPE7", "brown", "background")
  valueBg:AddAnchor("TOP", wnd.itemTextbox, "BOTTOM", 0, costHeight)
  wnd.valueBg = valueBg
  local cost = wnd:CreateChildWidget("textbox", "costLabel", 0, true)
  cost:SetExtent(40, 35)
  cost.style:SetAlign(ALIGN_CENTER)
  cost.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  cost:AddAnchor("TOPLEFT", wnd.itemTextbox, "BOTTOMLEFT", costOffsetX, costHeight)
  ApplyTextColor(cost, FONT_COLOR.TITLE)
  cost:SetText(locale.stabler.cost)
  valueTextbox:SetText(value)
  valueBg:SetExtent(valueTextbox:GetLongestLineWidth() + 260, valueTextbox:GetTextHeight() + 20)
  wnd:RegistBottomWidget(valueTextbox)
end
local SecurityLockItemWithDescription = function(wnd, description)
  local anchorTarget = wnd.itemTextbox
  if wnd.valueBg ~= nil then
    anchorTarget = wnd.valueBg
  end
  local descriptionTextBox = wnd:CreateChildWidget("textbox", "descriptionTextBox", 0, true)
  descriptionTextBox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 35)
  descriptionTextBox.style:SetAlign(ALIGN_CENTER)
  descriptionTextBox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  descriptionTextBox:AddAnchor("TOP", anchorTarget, "BOTTOM", 0, 15)
  ApplyTextColor(descriptionTextBox, FONT_COLOR.DEFAULT)
  descriptionTextBox:SetText(description)
  wnd:RegistBottomWidget(descriptionTextBox)
end
local DialogSecurityLockItem = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "item_lock"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_lock_item"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  if infoTable.amount > 0 then
    local costData = {
      type = "cost",
      value = infoTable.amount
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
  end
  local delayMin = X2Item:GetSecurityUnlockDelayTime()
  if delayMin == 0 then
    local textData = {
      type = "warning",
      text = GetUIText(MSG_BOX_BODY_TEXT, "lock_item_not_delay_time")
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
  else
    local textData = {
      type = "warning",
      text = GetUIText(MSG_BOX_BODY_TEXT, "lock_item", tostring(delayMin / 60))
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
  end
end
X2DialogManager:SetHandler(DLG_TASK_SECURITY_LOCK_ITEM, DialogSecurityLockItem)
local DialogIndunEntrance = function(wnd, infoTable)
  local minLevelStr = GetLevelToString(infoTable.minLevel)
  local maxLevelStr = GetLevelToString(infoTable.maxLevel)
  local partyStr = infoTable.party and string.format("%s%s", FONT_COLOR_HEX.DARK_GRAY, X2Locale:LocalizeUiText(COMMON_TEXT, "indun_entrance_condition_party")) or ""
  local condition = GetUIText(COMMON_TEXT, "indun_entrance_condition", FONT_COLOR_HEX.DARK_GRAY, minLevelStr, maxLevelStr, partyStr)
  local player = GetUIText(COMMON_TEXT, "indun_entrance_max_player", FONT_COLOR_HEX.DARK_GRAY, tostring(infoTable.maxPlayer))
  local reset = string.format("%s", GetUIText(COMMON_TEXT, "indun_entrance_reset"))
  if infoTable.visitCount < infoTable.maxEnterCount then
    ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_VALUE_TEXT_EX)
    local content = GetUIText(COMMON_TEXT, "indun_entrance_question", FONT_COLOR_HEX.BLUE, infoTable.zoneName)
    local valueText1 = string.format([[
%s
%s]], condition, player)
    local dailycount
    if infoTable.maxEnterCount == 1000 then
      dailycount = GetUIText(COMMON_TEXT, "indun_entrance_daily_count_unlimited", FONT_COLOR_HEX.BLUE)
    else
      dailycount = GetUIText(COMMON_TEXT, "indun_entrance_daily_count", FONT_COLOR_HEX.BLUE, tostring(infoTable.visitCount), tostring(infoTable.maxEnterCount))
    end
    local valueText2 = ""
    if X2Player:GetFeatureSet().indunDailyLimit then
      valueText2 = string.format([[
%s
%s]], dailycount, reset)
    end
    wnd:SetTitle(GetUIText(COMMON_TEXT, "indun_entrance_title"))
    wnd:SetContentEx(content, valueText1, valueText2)
  else
    ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_ITEM_ICON_VALUE_TEXT_EX)
    local title = ""
    local content = ""
    if infoTable.maxEnterCount == 0 then
      reset = ""
      title = GetUIText(COMMON_TEXT, "indun_entrance_title")
      content = GetUIText(COMMON_TEXT, "indun_entrance_question", FONT_COLOR_HEX.BLUE, infoTable.zoneName)
    else
      title = GetUIText(COMMON_TEXT, "indun_entrance_item_title")
      content = GetUIText(COMMON_TEXT, "indun_entrance_item_question", FONT_COLOR_HEX.BLUE, infoTable.zoneName, tostring(infoTable.maxEnterCount))
    end
    local itemDesc = string.format([[
[%s]
%d/1]], infoTable.itemInfo.name, infoTable.haveItemCount)
    local valueText1 = string.format([[
%s
%s]], condition, player)
    wnd:SetTitle(title)
    wnd:SetContentEx(content, infoTable.itemInfo, 0, itemDesc, valueText1, reset)
  end
  local events = {
    INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_INDUN_ENTRANCE, DialogIndunEntrance)
local DialogSoulBindItemHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "ask_equip_soul_bind_item"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_equip_soul_bind_item"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  local textData = {
    type = "warning",
    text = GetUIText(COMMON_TEXT, "item_bind_alert")
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
end
X2DialogManager:SetHandler(DLG_TASK_SOUL_BIND_ITEM, DialogSoulBindItemHandler)
local DialogConvertFishHandler = function(wnd, infoTable)
  ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_ITEM_AND_DESCRIPTION)
  local title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_convert_fish")
  local content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_convert_fish", infoTable.itemInfo.name)
  local description = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_convert_fish_description")
  wnd:SetTitle(title)
  wnd:SetContentEx(content, infoTable.itemInfo, infoTable.itemCount, description)
  local events = {
    INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_CONVERT_FISH, DialogConvertFishHandler)
local DialogExpandCharacterCountHandler = function(wnd, infoTable)
  local title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_expand_character_count")
  local content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_expand_character_count")
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_EXPAND_CHARACTER_COUNT, DialogExpandCharacterCountHandler)
local DialogExpandedCharacterCountHandler = function(wnd, infoTable)
  local title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "expanded_character_count")
  local content
  if infoTable.result == true then
    content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "expanded_character_count")
  else
    content = infoTable.errorMsg
  end
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_EXPANDED_CHARACTER_COUNT, DialogExpandedCharacterCountHandler)
local function DialogNoticeExpireIndunTicket(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "confirm_thief_action_title")
  infoTable.content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "instance_zone_warning")
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_NOTICE_EXPIRE_INSTANCE_TICKET, DialogNoticeExpireIndunTicket)
local DialogRenameNationHandler = function(wnd, infoTable)
  local title = X2Locale:LocalizeUiText(NATION_TEXT, "rename_title")
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_FACTION)
  local guide = F_TEXT.GetLimitInfoText(namePolicyInfo)
  local content = X2Locale:LocalizeUiText(NATION_TEXT, "rename_content")
  ApplyEditDialogStyle(wnd, infoTable.nationName, guide, false, VNT_FACTION)
  wnd:SetTitle(title)
  wnd:SetContent(content)
  function wnd:OkProc()
    local newName = wnd.editbox:GetText()
    X2Faction:RenameNation(newName)
  end
end
X2DialogManager:SetHandler(DLG_TASK_RENAME_NATION, DialogRenameNationHandler)
local DialogIndependenceFactionNameHandler = function(wnd, infoTable)
  local title = X2Locale:LocalizeUiText(FACTION_TEXT, "independence_title")
  local content = X2Locale:LocalizeUiText(FACTION_TEXT, "independence_content")
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_FACTION)
  local guide = F_TEXT.GetLimitInfoText(namePolicyInfo)
  ApplyEditDialogStyle(wnd, "", guide, false, VNT_FACTION)
  wnd:SetTitle(title)
  wnd:SetContent(content)
  function wnd:OkProc()
    local name = wnd.editbox:GetText()
    X2Nation:DeclareIndependence(name)
  end
end
X2DialogManager:SetHandler(DLG_TASK_INDEPENDENCE_FACTION_NAME, DialogIndependenceFactionNameHandler)
local function DialogAskUseAAPoint(wnd, infoTable)
  infoTable.title = GetUIText(MONEY_TEXT, "aa_point")
  infoTable.content = GetUIText(MONEY_TEXT, "ask_use_aa_point")
  local autoUseAAPoint = CreateCheckButton("autoUseAAPoint", wnd, locale.money.autoUseAAPoint)
  local offsetX = autoUseAAPoint.textButton:GetWidth() / 2
  autoUseAAPoint:AddAnchor("TOP", wnd.textbox, "BOTTOM", -offsetX, 10)
  function wnd:OkProc()
    local checked = autoUseAAPoint:GetChecked()
    if checked then
      X2Bag:SetAutoUseAAPoint(checked)
    end
  end
  SetDialogTexts(wnd, infoTable)
  local height = wnd:GetHeight()
  wnd:SetHeight(height + autoUseAAPoint:GetHeight() + 10)
end
X2DialogManager:SetHandler(DLG_TASK_ASK_USE_AA_POINT, DialogAskUseAAPoint)
local function DialogAskChargeAAPoint(wnd, infoTable)
  infoTable.title = GetUIText(MONEY_TEXT, "aa_point")
  infoTable.content = GetUIText(MONEY_TEXT, "ask_charge_aa_point")
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_TASK_ASK_CHARGE_AA_POINT, DialogAskChargeAAPoint)
local DialogNationalTaxRateHandler = function(wnd, infoTable)
  local title = GetUIText(NATION_TEXT, "change_tax")
  local content = GetUIText(NATION_TEXT, "change_tax_dlg", tostring(infoTable.zoneName), tostring(infoTable.prevTaxRate), tostring(infoTable.taxRate))
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_NATIONAL_TAXRATE, DialogNationalTaxRateHandler)
local DialogFactionImmigrateInviteHandler = function(wnd, infoTable)
  local title = locale.nationMgr.peopleInvite
  local content = locale.nationMgr.peopleInviteDlg(infoTable.invitorName, infoTable.nationName)
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_FACTION_INVITE, DialogFactionImmigrateInviteHandler)
local DialogImmigrateToOriginFactionHandler = function(wnd, infoTable)
  local title = locale.nationMgr.withdrawNation
  local content = locale.nationMgr.withdrawNationDlg(infoTable.nationName)
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_FACTION_IMMIGRATE_TO_ORIGIN, DialogImmigrateToOriginFactionHandler)
local function DialogWarnCraftItemHandler(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "warning_craft_title"))
  local CreateWarningGradeView = function(window, info)
    local materialGrade = info.warningGrade.materialGrade
    local resultGrade = info.warningGrade.resultGrade
    window:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "warning_craft_title"))
    window:UpdateDialogModule("textbox", X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "warning_craft_grade"))
    local itemData = {
      itemInfo = info.itemInfo[1],
      stack = 1
    }
    window:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
    local changeData = {
      titleInfo = {
        title = GetUIText(COMMON_TEXT, "warning_craft_downgrade")
      },
      left = {
        UpdateValueFunc = function(leftValueWidget)
          leftValueWidget:SetText(materialGrade.grade)
          ApplyTextColor(leftValueWidget, Hex2Dec(materialGrade.gradeColor))
        end
      },
      right = {
        UpdateValueFunc = function(rightValueWidget)
          rightValueWidget:SetText(resultGrade.grade)
          ApplyTextColor(rightValueWidget, Hex2Dec(resultGrade.gradeColor))
        end
      }
    }
    window:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeData", changeData)
    local textData = {
      type = "warning",
      text = GetUIText(MSG_BOX_BODY_TEXT, "warning_craft_grade_desc")
    }
    window:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
  end
  if infoTable.warningGrade ~= nil then
    CreateWarningGradeView(wnd, infoTable)
    return
  end
  local itemIconWnd = wnd:CreateChildWidget("emptywidget", "itemIconWnd", 0, true)
  itemIconWnd:AddAnchor("TOP", wnd, 0, 50)
  itemIconWnd:SetHeight(ICON_SIZE.DEFAULT)
  function itemIconWnd:SetInfo(itemInfo)
    self.itemIcon = {}
    for i = 1, #itemInfo do
      local item = CreateItemIconButton(string.format("item[%d]", i), itemIconWnd)
      item:SetItemInfo(itemInfo[i])
      item:AddAnchor("TOPLEFT", itemIconWnd, (ICON_SIZE.DEFAULT + 10) * (i - 1), 0)
    end
    self:SetWidth((ICON_SIZE.DEFAULT + 10) * #itemInfo - 10)
  end
  itemIconWnd:SetInfo(infoTable.itemInfo)
  local warningWnd = wnd:CreateChildWidget("textbox", "warningWnd", 0, true)
  warningWnd:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 25)
  warningWnd:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH)
  local warningBg = CreateContentBackground(warningWnd, "TYPE2", "white")
  warningBg:AddAnchor("TOPLEFT", warningWnd, 0, -sideMargin / 1.2)
  warningBg:AddAnchor("BOTTOMRIGHT", warningWnd, 0, sideMargin / 1.2)
  function warningWnd:SetInfo(info)
    local str = FONT_COLOR_HEX.RED
    if info.warningGem ~= nil and info.warningGem then
      str = string.format("%s%s\n", str, GetUIText(MSG_BOX_BODY_TEXT, "warning_gem"))
    end
    if info.warningSocket ~= nil and info.warningSocket then
      str = string.format("%s%s\n", str, GetUIText(MSG_BOX_BODY_TEXT, "warning_crescent_stone"))
    end
    if info.warningLook ~= nil and info.warningLook then
      str = string.format("%s%s\n", str, GetUIText(MSG_BOX_BODY_TEXT, "warning_look"))
    end
    if info.warningSkinized ~= nil and info.warningSkinized then
      str = string.format("%s%s\n", str, GetUIText(MSG_BOX_BODY_TEXT, "warning_skinized"))
    end
    warningWnd:SetText(str)
    local warningHeight = warningWnd:GetTextHeight()
    warningWnd:SetHeight(warningHeight)
  end
  warningWnd:SetInfo(infoTable)
  local helper = wnd:CreateChildWidget("textbox", "helper", 0, true)
  helper:SetAutoResize(true)
  helper:AddAnchor("TOP", warningWnd, "BOTTOM", 0, 25)
  helper:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH)
  helper.style:SetFontSize(FONT_SIZE.SMALL)
  ApplyTextColor(helper, FONT_COLOR.GRAY)
  helper:SetText(GetUIText(MSG_BOX_BODY_TEXT, "warning_craft_helper"))
  wnd:RegistBottomWidget(helper)
  wnd:SetContent(GetUIText(MSG_BOX_BODY_TEXT, "warning_remove"))
  wnd.textbox:RemoveAllAnchors()
  wnd.textbox:AddAnchor("TOP", itemIconWnd, "BOTTOM", 0, 10)
end
X2DialogManager:SetHandler(DLG_TASK_WARN_CRAFT_ITEM, DialogWarnCraftItemHandler)
local DialogGenderTransferHandler = function(wnd, infoTable)
  wnd:SetSounds("dialog_gender_transfer")
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "genderTransfer_title"))
  local itemType, has, need = X2Customizer:GetBeautyShopConfigInfo()
  local contextMsg = GetUIText(MSG_BOX_BODY_TEXT, "genderTransfer_body")
  if infoTable.bypass then
    contextMsg = F_TEXT.SetEnterString(contextMsg, GetUIText(MSG_BOX_BODY_TEXT, "genderTransfer_bypass_tip"))
  else
    contextMsg = F_TEXT.SetEnterString(contextMsg, GetUIText(MSG_BOX_BODY_TEXT, "genderTransfer_tip", tostring(X2Item:Name(itemType)), tostring(need)))
  end
  wnd:UpdateDialogModule("textbox", contextMsg)
  local playerGender = X2Unit:UnitGender("player")
  local prevGender, prevGenderColor, nextGender, nextGenderColor
  if playerGender == "male" then
    prevGender = GetUIText(COMMON_TEXT, "male_with_special_character")
    prevGenderColor = FONT_COLOR.GENDER_MALE
    nextGender = GetUIText(COMMON_TEXT, "female_with_special_character")
    nextGenderColor = FONT_COLOR.GENDER_FEMALE
  else
    prevGender = GetUIText(COMMON_TEXT, "female_with_special_character")
    prevGenderColor = FONT_COLOR.GENDER_FEMALE
    nextGender = GetUIText(COMMON_TEXT, "male_with_special_character")
    nextGenderColor = FONT_COLOR.GENDER_MALE
  end
  local changeData = {
    titleInfo = {
      title = GetUIText(MSG_BOX_TITLE_TEXT, "genderTransfer_title")
    },
    left = {
      UpdateValueFunc = function(leftValueWidget)
        leftValueWidget:SetText(prevGender)
        ApplyTextColor(leftValueWidget, prevGenderColor)
      end
    },
    right = {
      UpdateValueFunc = function(rightValueWidget)
        rightValueWidget:SetText(nextGender)
        ApplyTextColor(rightValueWidget, nextGenderColor)
      end
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeData", changeData)
  if infoTable.itemType ~= nil then
    local itemData = {
      itemInfo = infoTable.itemInfo,
      stack = {
        infoTable.has,
        infoTable.needs
      }
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  end
  local textData = {
    type = "warning",
    text = GetUIText(MSG_BOX_BODY_TEXT, "genderTransfer_desc")
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
  local events = {
    NPC_INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_CONFIRM_GENDER_TRANSEFR, DialogGenderTransferHandler)
local DialogEnterBeautyShopHandler = function(wnd, infoTable)
  wnd:SetSounds("dialog_enter_beautyshop")
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "enter_beautyshop_title"))
  local bodyStr = GetUIText(MSG_BOX_BODY_TEXT, "enter_beautyshop_body")
  if infoTable.bypass then
    bodyStr = string.format([[
%s

%s]], bodyStr, GetUIText(MSG_BOX_BODY_TEXT, "enter_beautyshop_body_bypass"))
  end
  wnd:SetContent(bodyStr)
  local events = {
    NPC_INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_CONFIRM_ENTER_BEAUTYSHOP, DialogEnterBeautyShopHandler)
local DialogRevertLookItemHandler = function(wnd, infoTable)
  ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_TWO_ITEM_ICON_AND_ONE_NAME)
  local title = GetUIText(MSG_BOX_TITLE_TEXT, "revert_item_look_title")
  local scroll = string.format("|c%s[%s]|r", X2Item:GradeColor(infoTable.scrollGrade), X2Item:Name(infoTable.scrollType))
  local content = string.format([[
%s
%s%s]], GetUIText(MSG_BOX_BODY_TEXT, "revert_item_look_body", scroll), FONT_COLOR_HEX.DARK_GRAY, GetUIText(MSG_BOX_BODY_TEXT, "revert_item_look_desc"))
  local itemInfo1 = infoTable.itemInfo
  local itemInfo2 = infoTable.revertItemInfo
  local itemContent = string.format("|c%s[%s]", itemInfo1.gradeColor, itemInfo1.name)
  wnd:SetTitle(title)
  wnd:SetContentEx(content, itemInfo1, itemInfo2, itemContent)
end
X2DialogManager:SetHandler(DLG_TASK_REVERT_LOOK_ITEM, DialogRevertLookItemHandler)
local DialogUnpackItemHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "unpack_item_title"))
  local str
  if infoTable.isSoulBound then
    str = GetUIText(MSG_BOX_BODY_TEXT, "soul_bound_unpack_item_body")
  else
    str = GetUIText(MSG_BOX_BODY_TEXT, "unpack_item_body")
  end
  wnd:SetContent(str)
end
X2DialogManager:SetHandler(DLG_TASK_ITEM_UNPACK, DialogUnpackItemHandler)
local DialogInviteToBeginnerExpeditionHandler = function(wnd, infoTable)
  local title = GetUIText(MSG_BOX_TITLE_TEXT, "apply_beginner_expedition")
  local content1 = GetUIText(MSG_BOX_BODY_TEXT, "suggest_beginner_expedition")
  local bindKey = string.upper(infoTable.bindKey)
  if string.len(bindKey) == 0 then
    bindKey = string.format("%s - %s", X2Locale:LocalizeUiText(TEMP_TEXT, "text5"), X2Locale:LocalizeUiText(COMMUNITY_TEXT, "expedition"))
  end
  local content2 = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "beginner_expedition_guide", bindKey)
  local contents = string.format([[
%s

%s]], content1, content2)
  wnd:SetTitle(title)
  wnd:SetContent(contents)
end
X2DialogManager:SetHandler(DLG_TASK_INVITE_TO_BEGINNER_EXPEDITION, DialogInviteToBeginnerExpeditionHandler)
function ShowResultBuyAAPoint(result, moneyString)
  local function ResultBuyAAPoint(wnd, infoTable)
    function wnd:OkProc()
      wnd:Show(false)
    end
    wnd:SetTitle(locale.inGameShop.chargeAAPoint)
    if result then
      wnd:SetContent(GetUIText(INGAMESHOP_TEXT, "buy_success_aa_point", F_MONEY:SettingPriceText(moneyString, PRICE_TYPE_AA_POINT)), true)
    else
      wnd:SetContent(GetUIText(ERROR_MSG, "INGAME_SHOP_BUY_FAIL_AA_POINT"), true)
    end
  end
  X2DialogManager:RequestNoticeDialog(ResultBuyAAPoint, "UIParent")
end
UIParent:SetEventHandler("BUY_RESULT_AA_POINT", ShowResultBuyAAPoint)
function ShowAntibotPunishMessage(message)
  local function AntibotPunishMessage(wnd, infoTable)
    wnd:SetContent(message)
  end
  X2DialogManager:RequestNoticeDialog(AntibotPunishMessage, "UIParent")
end
UIParent:SetEventHandler("ANTIBOT_PUNISH", ShowAntibotPunishMessage)
local alreadyShowRequestBuyLaborPowerDialog = false
local function AskBuyLaborPower()
  if alreadyShowRequestBuyLaborPowerDialog then
    return
  end
  local timeStampKey = "request_buy_labor_power_one_day_hide"
  local localData = X2Time:GetLocalDate()
  local stamp = string.format("%s-%s-%s", localData.year, localData.month, localData.day)
  local savedStamp = UI:GetUIStamp(timeStampKey)
  if savedStamp == stamp then
    return
  end
  local function DecorateBuyLaborPowerNotifyFunc(wnd, infoTable)
    local title = GetUIText(COMMON_TEXT, "not_enough_labor_power")
    local content = string.format([[
%s
%s
%s]], GetUIText(ERROR_MSG, "NOT_ENOUGH_LABOR_POWER"), GetUIText(COMMON_TEXT, "can_buy_labor_power_potion"), GetUIText(COMMON_TEXT, "ask_open_ingameshop"))
    local addHeight = 10
    wnd:SetTitle(title)
    wnd:SetContent(content)
    wnd.btnOk:AddAnchor("BOTTOM", wnd, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM - addHeight)
    wnd.btnCancel:AddAnchor("BOTTOM", wnd, BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM - addHeight)
    wnd:SetHeight(wnd:GetHeight() + addHeight)
    local text = GetUIText(COMMON_TEXT, "hide_window")
    local checkButton = CreateCheckButton(wnd:GetId() .. ".checkButton", wnd, text)
    checkButton:AddAnchor("BOTTOMLEFT", wnd, 10, -10)
    function wnd:ShowProc()
      alreadyShowRequestBuyLaborPowerDialog = true
    end
    function wnd:OkProc()
      local checked = checkButton:GetChecked()
      if checked then
        UI:SetUIStamp(timeStampKey, stamp)
      end
      ToggleInGameShop()
      wnd:Show(false)
      alreadyShowRequestBuyLaborPowerDialog = false
    end
    function wnd:CancelProc()
      local checked = checkButton:GetChecked()
      if checked then
        UI:SetUIStamp(timeStampKey, stamp)
      end
      wnd:Show(false)
      alreadyShowRequestBuyLaborPowerDialog = false
    end
  end
  X2DialogManager:RequestDefaultDialog(DecorateBuyLaborPowerNotifyFunc, "")
end
UIParent:SetEventHandler("ASK_BUY_LABOR_POWER_POTION", AskBuyLaborPower)
function ShowUnfinishedBuildHouse(message)
  local function UnfinishedBuildHouse(wnd, infoTable)
    function wnd:OkProc()
      wnd:Show(false)
    end
    wnd:SetTitle(GetUIText(COMMON_TEXT, "diglog_title_of_unifinished_build_house"))
    wnd:SetContent(message)
  end
  X2DialogManager:RequestNoticeDialog(UnfinishedBuildHouse, "")
end
UIParent:SetEventHandler("UNFINISHED_BUILD_HOUSE", ShowUnfinishedBuildHouse)
local ShowDeclarationExpeditionWarDialog = function(id, name, money)
  local function DialogHandler(wnd, infoTable)
    function wnd:OkProc()
      X2Faction:DeclareExpeditionWar(id, money)
    end
    wnd:SetTitle(GetCommonText("declare_expedition_war"))
    wnd:SetExtent(352, 265)
    local sideMargin = 20
    local heightMargin = 5
    local contentWidth = 352 - sideMargin * 2
    local nameLabel = wnd:CreateChildWidget("label", "nameLabel", 0, false)
    nameLabel:SetExtent(contentWidth, FONT_SIZE.LARGE)
    nameLabel:SetText(name)
    nameLabel.style:SetFontSize(FONT_SIZE.LARGE)
    nameLabel:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, heightMargin)
    ApplyTextColor(nameLabel, FONT_COLOR.BLUE)
    local askContent = wnd:CreateChildWidget("textbox", "askContent", 0, false)
    askContent:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
    askContent:AddAnchor("TOP", nameLabel, "BOTTOM", 0, heightMargin + TEXTBOX_LINE_SPACE.MIDDLE)
    askContent.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(askContent, FONT_COLOR.DEFAULT)
    askContent:SetText(GetCommonText("ask_declare_expedition_war"))
    askContent:SetHeight(askContent:GetTextHeight())
    local cost = W_MONEY.CreateTitleMoneyWindow("cost", wnd, "", "horizon")
    cost:SetWidth(150)
    cost:NotUseTitle()
    cost:AddAnchor("TOP", askContent, "BOTTOM", 0, 13)
    local featureSet = X2Player:GetFeatureSet()
    if featureSet.aaPoint then
      cost:UpdateAAPoint(money)
    else
      cost:Update(money)
    end
    wnd.textbox:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
    wnd.textbox:RemoveAllAnchors()
    wnd.textbox:AddAnchor("TOP", cost, "BOTTOM", 0, 14)
    wnd.textbox.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(wnd.textbox, FONT_COLOR.RED)
    wnd.textbox:SetText(GetCommonText("alert_declaration_cost_per_expedition_war"))
    wnd.textbox:SetHeight(wnd.textbox:GetTextHeight())
  end
  X2DialogManager:RequestDefaultDialog(DialogHandler, "")
end
UIParent:SetEventHandler("EXPEDITION_WAR_DECLARATION_MONEY", ShowDeclarationExpeditionWarDialog)
function ShowCancelProtectionDialog()
  local DialogHandler = function(wnd, infoTable)
    function wnd:OkProc()
      X2Faction:RequestCancelProtection()
    end
    function wnd:CancelProc()
      wnd:Show(false)
    end
    wnd:SetTitle(GetCommonText("expedition_my_disable_protect"))
    wnd:SetExtent(352, 265)
    local sideMargin = 20
    local heightMargin = 15
    local contentWidth = 352 - sideMargin * 2
    wnd.textbox:SetExtent(contentWidth, FONT_SIZE.LARGE)
    wnd.textbox:RemoveAllAnchors()
    wnd.textbox:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, heightMargin)
    wnd.textbox.style:SetFontSize(FONT_SIZE.LARGE)
    wnd.textbox.style:SetAlign(ALIGN_CENTER)
    wnd.textbox:SetText(GetCommonText("ask_cancel_protection_for_expedition"))
    wnd.textbox:SetHeight(wnd.textbox:GetTextHeight())
    local subContent = wnd:CreateChildWidget("textbox", "subContent", 0, false)
    subContent:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
    subContent:SetText(GetCommonText("result_cancel_protection"))
    subContent.style:SetFontSize(FONT_SIZE.MIDDLE)
    subContent:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, heightMargin)
    ApplyTextColor(subContent, FONT_COLOR.GRAY)
    subContent:SetHeight(subContent:GetTextHeight())
    wnd:RegistBottomWidget(subContent)
  end
  X2DialogManager:RequestDefaultDialog(DialogHandler, "")
end
local function DialogZonePermissionHandler(wnd, infoTable)
  wnd.window = infoTable.window
  infoTable.resize = false
  local function GetNumText(waitNum)
    if infoTable.window == 3 then
      return GetCommonText("zp_wait_num_expel")
    elseif infoTable.permission == 4 then
      return GetCommonText("zp_wait_num_reserve")
    else
      return GetUIText(COMMON_TEXT, "zp_wait_num", tostring(waitNum))
    end
  end
  local zoneText = infoTable.zoneName .. "\r" .. infoTable.waitName
  local timeText = GetUIText(COMMON_TEXT, "zp_out_time") .. " : " .. tostring(infoTable.waitTime) .. GetUIText(CHARACTER_SUBTITLE_INFO_TOOLTIP_TEXT, "sec")
  local numText = GetNumText(infoTable.waitNum)
  wnd.waitPrefixString = infoTable.zoneName .. " " .. infoTable.waitName .. "\r"
  wnd.waitNum = infoTable.waitNum
  wnd.titleBar.closeButton:Show(false)
  wnd.textbox.style:SetFontSize(FONT_SIZE.MIDDLE)
  local upperContent = wnd:CreateChildWidget("textbox", "upperContent", 0, true)
  upperContent:SetExtent(wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2, 60)
  ApplyTextColor(upperContent, FONT_COLOR.BLUE)
  upperContent.style:SetFontSize(FONT_SIZE.LARGE)
  local downContent = wnd:CreateChildWidget("textbox", "downContent", 0, true)
  downContent:SetExtent(wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2, 60)
  ApplyTextColor(downContent, FONT_COLOR.BLUE)
  downContent.style:SetFontSize(FONT_SIZE.MIDDLE)
  downContent:SetText(timeText)
  if infoTable.window == 0 or infoTable.window == 1 then
    upperContent:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, 10)
    upperContent:SetText(zoneText)
    upperContent:SetHeight(upperContent:GetTextHeight())
    wnd.textbox:RemoveAllAnchors()
    wnd.textbox:AddAnchor("TOP", upperContent, "BOTTOM", 0, 19)
    infoTable.content = GetUIText(COMMON_TEXT, "zp_enter_text")
    downContent:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 19)
    if infoTable.window == 1 then
      if infoTable.permission == 4 then
        infoTable.content = GetUIText(COMMON_TEXT, "zp_reserve_text")
      else
        infoTable.content = GetUIText(COMMON_TEXT, "zp_wait_text")
      end
      downContent:SetText(numText)
      wnd.btnCancel:SetText(GetUIText(COMMON_TEXT, "zp_wait_cancel"))
    end
    downContent:SetHeight(downContent:GetTextHeight())
    wnd:RegistBottomWidget(downContent)
  elseif infoTable.window == 2 or infoTable.window == 3 then
    wnd.textbox:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, 16)
    wnd.textbox.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(wnd.textbox, FONT_COLOR.RED)
    local bg = CreateContentBackground(wnd.textbox, "TYPE2", "brown")
    bg:SetExtent(390, 70)
    bg:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, 0)
    downContent:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 8)
    downContent:SetHeight(downContent:GetTextHeight())
    local scroll = CreateScrollWindow(wnd, "scroll", 0)
    scroll:SetHeight(266)
    scroll:AddAnchor("TOPLEFT", bg, "BOTTOMLEFT", 0, 10)
    scroll:AddAnchor("TOPRIGHT", bg, "BOTTOMRIGHT", 0, 10)
    local scrollContent1 = scroll.content:CreateChildWidget("textbox", "scrollontent1", 0, true)
    scrollContent1:SetExtent(scroll.content:GetWidth(), 30)
    scrollContent1:AddAnchor("TOPLEFT", scroll.content, 0, 0)
    scrollContent1:SetAutoResize(true)
    scrollContent1.style:SetAlign(ALIGN_TOP_LEFT)
    scrollContent1.style:SetFontSize(FONT_SIZE.LARGE)
    scrollContent1:SetText(wnd.waitPrefixString .. numText)
    ApplyTextColor(scrollContent1, FONT_COLOR.BLUE)
    wnd.scrollContent1 = scrollContent1
    local scrollContent2 = scroll.content:CreateChildWidget("textbox", "scrollontent2", 0, true)
    scrollContent2:SetExtent(scroll.content:GetWidth(), 30)
    scrollContent2:AddAnchor("TOPLEFT", scrollContent1, "BOTTOMLEFT", 0, 30)
    scrollContent2:SetAutoResize(true)
    scrollContent2.style:SetAlign(ALIGN_LEFT)
    scrollContent2.style:SetFontSize(FONT_SIZE.MIDDLE)
    scrollContent2:SetText(GetUIText(COMMON_TEXT, "zp_out_scroll"))
    ApplyTextColor(scrollContent2, FONT_COLOR.DEFAULT)
    scroll:ResetScroll(scrollContent1:GetHeight() + scrollContent2:GetHeight() + 30)
    infoTable.content = GetUIText(COMMON_TEXT, "zp_out_text")
    wnd.btnOk:SetText(GetUIText(COMMON_TEXT, "zp_out_now_button"))
    wnd.btnOk:RemoveAllAnchors()
    if wnd.btnCancel ~= nil then
      wnd.btnCancel:SetText(GetUIText(COMMON_TEXT, "zp_out_wait_button"))
      wnd.btnCancel:RemoveAllAnchors()
      ReanchorDefaultTextButtonSet({
        wnd.btnOk,
        wnd.btnCancel
      }, wnd, -MARGIN.WINDOW_SIDE)
    else
      wnd.btnOk:AddAnchor("BOTTOM", wnd, 0, -MARGIN.WINDOW_SIDE)
    end
    wnd:SetWidth(430)
    wnd:RegistBottomWidget(scroll)
  end
  local delay = 0
  local function OnUpdate(self, dt)
    delay = delay + dt
    if wnd.window ~= 1 and delay > 500 then
      local condition = X2Player:GetZonePermissionCondition()
      downContent:SetText(GetUIText(TOOLTIP_TEXT, "wait_time") .. tostring(condition.waitTime) .. GetUIText(CHARACTER_SUBTITLE_INFO_TOOLTIP_TEXT, "sec"))
      delay = 0
      if wnd.waitNum ~= condition.waitNum and wnd.scrollContent1 ~= nil then
        local numText = GetNumText(condition.waitNum)
        wnd.scrollContent1:SetText(wnd.waitPrefixString .. numText)
        wnd.waitNum = condition.waitNum
      end
    end
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_TASK_ZONE_PERMISSION, DialogZonePermissionHandler)
local DialogZonePermissionExpelledHandler = function(wnd, infoTable)
  wnd:SetTitle(GetCommonText("zp_out_title"))
  if infoTable.reason == 1 then
    wnd:SetContent(GetCommonText("zp_out_text_level"), true)
  elseif infoTable.reason == 2 then
    wnd:SetContent(GetCommonText("zp_out_text_idle"), true)
  elseif infoTable.reason == 3 then
    wnd:SetContent(GetCommonText("zp_out_text_quest"), true)
  else
    wnd:SetContent(GetUIText(COMMON_TEXT, "zp_out_text_faction", X2Unit:GetFactionName("player")), true)
  end
end
X2DialogManager:SetHandler(DLG_TASK_ZONE_PERMISSION_EXPELLED, DialogZonePermissionExpelledHandler)
local DialogExpeditionImmigrationRequestHandler = function(wnd, infoTable)
  ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_ITEM_ICON_VALUE_TEXT)
  wnd:SetWidth(430)
  wnd.textbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  wnd.valueTextbox:SetWidth(390)
  wnd.valueTextbox.style:SetAlign(ALIGN_LEFT)
  wnd.valueTextbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  wnd.valueTextbox:SetLineSpace(TEXTBOX_LINE_SPACE.LARGE)
  local notice1 = GetUIText(COMMON_TEXT, "immigration_expediton_request_notice_1", FONT_COLOR_HEX.BLUE, infoTable.nationName)
  local notice2 = GetUIText(COMMON_TEXT, "immigration_expediton_request_notice_2", infoTable.factionName)
  local notice3 = GetUIText(COMMON_TEXT, "immigration_expediton_request_notice_3", FONT_COLOR_HEX.BLUE, infoTable.nationName)
  local notice4 = GetUIText(COMMON_TEXT, "immigration_expediton_request_notice_4", FONT_COLOR_HEX.BLUE, infoTable.nationName)
  local notice5 = GetCommonText("immigration_expediton_limit_level")
  local notice6 = GetCommonText("immigration_expediton_pirate")
  local notice7 = GetCommonText("immigration_expediton_hero")
  local color = FONT_COLOR_HEX.BLUE
  if infoTable.itemInfo.haveItemCount < infoTable.itemInfo.maxItemCount then
    color = FONT_COLOR_HEX.RED
  end
  local itemDesc = string.format([[
[%s]
%s%d/%d]], infoTable.itemInfo.name, color, infoTable.itemInfo.haveItemCount, infoTable.itemInfo.maxItemCount)
  local notice = string.format([[
%s- %s|r
- %s
- %s
- %s
- %s
- %s
]], FONT_COLOR_HEX.RED, notice2, notice3, notice4, notice5, notice6, notice7)
  wnd:SetTitle(GetCommonText("immigration_expediton_request"))
  wnd:SetContentEx(notice1, infoTable.itemInfo, 0, itemDesc, notice)
end
X2DialogManager:SetHandler(DLG_TASK_EXPEDITON_IMMIGRATION_REQUEST, DialogExpeditionImmigrationRequestHandler)
local DialogExpeditionImmigrationCancelHandler = function(wnd, infoTable)
  local title = GetCommonText("immigration_expediton_cancel")
  local content = string.format([[
%s%s|r
%s]], FONT_COLOR_HEX.BLUE, infoTable.nationName, GetCommonText("immigration_expediton_cancel_content"))
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_EXPEDITON_IMMIGRATION_CANCEL, DialogExpeditionImmigrationCancelHandler)
local DialogEquipSlotReinforceLevelUpHandler = function(wnd, infoTable)
  wnd:SetTitle(GetCommonText("equip_slot_reinforce_msg_levelup_title"))
  if infoTable.itemType then
    ApplyDialogStyle(wnd, "TYPE1")
    local content = GetUIText(COMMON_TEXT, "equip_slot_reinforce_msg_levelup_desc", GetSlotText(infoTable.equipSlot), tostring(infoTable.level + 1))
    local itemInfo = X2Item:GetItemInfoByType(infoTable.itemType)
    local itemContent = string.format("|c%s[%s]", itemInfo.gradeColor, itemInfo.name)
    local stackTable = {
      infoTable.has,
      infoTable.count
    }
    wnd:SetContentEx(content, itemInfo, stackTable, itemContent)
    wnd.btnOk:Enable(infoTable.has >= infoTable.count)
  else
    wnd:SetContent(content)
    wnd.btnOk:Enable(true)
  end
end
X2DialogManager:SetHandler(DLG_TASK_EQUIP_SLOT_REINFORCE_LEVEL_UP, DialogEquipSlotReinforceLevelUpHandler)
local DialogFamilyLeaveHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "family_leave"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "family_leave_content"))
  local haveCount = X2Bag:GetCountInBag(infoTable.itemInfo.itemType)
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = {
      infoTable.itemInfo.haveItemCount,
      infoTable.itemInfo.maxItemCount
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  local textData = {
    type = "warning",
    text = GetUIText(COMMON_TEXT, "family_leave_warning")
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
end
X2DialogManager:SetHandler(DLG_TASK_FAMILY_LEAVE, DialogFamilyLeaveHandler)
local DialogFamilyKickHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "family_kick"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "family_kick_content", infoTable.name))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = {
      infoTable.itemInfo.haveItemCount,
      infoTable.itemInfo.maxItemCount
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  local textData = {
    type = "warning",
    text = GetUIText(COMMON_TEXT, "family_kick_warning")
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
end
X2DialogManager:SetHandler(DLG_TASK_FAMILY_KICK, DialogFamilyKickHandler)
local DialogRaidRecruitDelHandler = function(wnd, infoTable)
  wnd:SetTitle(GetCommonText("raid_recruit_delete_title"))
  wnd:UpdateDialogModule("textbox", GetCommonText("raid_recruit_delete_notify"))
end
X2DialogManager:SetHandler(DLG_TASK_RAID_RECRUIT_DEL, DialogRaidRecruitDelHandler)
local function NpcInteractionSpecialtyTrade(dlgWnd, infoTable)
  local coinType = infoTable.coinType
  local featureSet = X2Player:GetFeatureSet()
  local function GetTitle(coinType)
    if coinType ~= nil then
      if featureSet.backpackProfitShare then
        return GetCommonText("npc_store_goods")
      else
        return locale.store_specialty.delphinad_title
      end
    else
      return locale.store_specialty.title
    end
  end
  local GetContent = function(featureSet, coinType, refund, backpackType)
    local result = ""
    if featureSet then
      if coinType ~= nil and refund < 0 then
        result = GetCommonText("sell_backpack_next_time")
      else
        if backpackType == BPT_TRADEGOODS then
          local interest = X2Store:GetSpecialtyInterest(backpackType)
          local labor = X2Store:GetBackPackSellLabor(BPT_TRADEGOODS)
          result = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_content_tradegoods", tostring(interest), tostring(labor))
        else
          local sellerRatio = X2Store:GetSellerShareRatio()
          result = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_content", FONT_COLOR_HEX.BLUE, tostring(100 - sellerRatio), tostring(sellerRatio))
        end
        if coinType == nil or coinType == 0 then
          local ratio = 0
          local extraResult = ""
          if X2Player:GetPayLocation() == "pcbang" then
            local pcBangRatio = X2Store:GetPCBangRatio()
            if ratio < pcBangRatio then
              ratio = pcBangRatio
              extraResult = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_at_pcbang", FONT_COLOR_HEX.RED, FONT_COLOR_HEX.RED, tostring(pcBangRatio))
            end
          end
          if X2Player:HasAccountBuffUsingSpecialityConfig() then
            local info = X2Store:GetAccountBuffInfoUsingSpecialityConfig()
            if ratio < info.ratio then
              ratio = info.ratio
              extraResult = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_with_account_buff", FONT_COLOR_HEX.RED, info.buffName, FONT_COLOR_HEX.RED, tostring(info.ratio))
            end
          end
          return string.format("%s%s", result, extraResult)
        end
      end
    elseif coinType ~= nil then
      if refund > 0 then
        result = locale.store_specialty.delphinad_bodyText
      else
        result = locale.store_specialty.bodyTextFull
      end
    else
      result = locale.store_specialty.bodyText
      local ratio = 0
      local extraResult = ""
      if X2Player:GetPayLocation() == "pcbang" then
        local pcBangRatio = X2Store:GetPCBangRatio()
        if ratio < pcBangRatio then
          ratio = pcBangRatio
          extraResult = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_at_pcbang", FONT_COLOR_HEX.RED, FONT_COLOR_HEX.RED, tostring(pcBangRatio))
        end
      end
      if X2Player:HasAccountBuffUsingSpecialityConfig() then
        local info = X2Store:GetAccountBuffInfoUsingSpecialityConfig()
        if ratio < info.ratio then
          ratio = info.ratio
          extraResult = X2Locale:LocalizeUiText(COMMON_TEXT, "sell_backpack_with_account_buff", FONT_COLOR_HEX.RED, info.buffName, FONT_COLOR_HEX.RED, tostring(info.ratio))
        end
      end
      return string.format("%s%s", result, extraResult)
    end
    return result
  end
  local GetRatioStr = function()
    return string.format("%s: %d%%", locale.store_specialty.prices, tonumber(X2Store:GetSpecialtyRatio()))
  end
  dlgWnd.btnOk:Enable(false)
  if featureSet.backpackProfitShare then
    do
      local upperContent = dlgWnd:CreateChildWidget("label", "upperContent", 0, false)
      upperContent:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.LARGE)
      upperContent.style:SetFontSize(FONT_SIZE.LARGE)
      ApplyTextColor(upperContent, FONT_COLOR.DEFAULT)
      upperContent:SetAutoResize(true)
      upperContent:AddAnchor("TOP", dlgWnd, 0, titleMargin)
      dlgWnd.textbox:RemoveAllAnchors()
      dlgWnd.textbox.style:SetAlign(ALIGN_LEFT)
      local function CreateInfoFrame(id, titleText)
        local width = (DEFAULT_SIZE.DIALOG_CONTENT_WIDTH - MARGIN.WINDOW_SIDE / 2) / 2
        local frame = UIParent:CreateWidget("emptywidget", id, dlgWnd)
        frame:Show(true)
        frame:SetExtent(width, 110)
        local bg = CreateContentBackground(frame, "TYPE10", "brown_2")
        bg:AddAnchor("TOPLEFT", frame, 0, 0)
        bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
        local title = frame:CreateChildWidget("label", "title", 0, true)
        title:SetHeight(FONT_SIZE.MIDDLE)
        title:SetAutoResize(true)
        title:SetText(titleText)
        title:AddAnchor("TOP", frame, 0, MARGIN.WINDOW_SIDE / 2)
        ApplyTextColor(title, FONT_COLOR.HIGH_TITLE)
        local itemIcon = CreateSlotItemButton(frame:GetId() .. ".itemIcon", frame)
        itemIcon:AddAnchor("TOP", title, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
        frame.itemIcon = itemIcon
        return frame
      end
      local leftInfoFrame = CreateInfoFrame("leftInfoFrame", GetCommonText("sell_backpack_goods"))
      local rightInfoFrame = CreateInfoFrame("rightInfoFrame", GetCommonText("sell_backpack_price"))
      if featureSet.specialtyTradeGoods then
        leftInfoFrame:AddAnchor("TOP", upperContent, "BOTTOM", 0, sideMargin / 1.5)
        leftInfoFrame:AddAnchor("LEFT", dlgWnd, sideMargin, 0)
        rightInfoFrame:AddAnchor("TOP", upperContent, "BOTTOM", 0, sideMargin / 1.5)
        rightInfoFrame:AddAnchor("RIGHT", dlgWnd, -sideMargin, 0)
        dlgWnd.textbox:AddAnchor("TOPLEFT", leftInfoFrame, "BOTTOMLEFT", 0, 10)
      else
        dlgWnd.textbox:AddAnchor("TOP", upperContent, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
        leftInfoFrame:AddAnchor("TOPLEFT", dlgWnd.textbox, "BOTTOMLEFT", 0, sideMargin / 1.5)
        rightInfoFrame:AddAnchor("TOPRIGHT", dlgWnd.textbox, "BOTTOMRIGHT", 0, sideMargin / 1.5)
      end
      local ratioLabel = rightInfoFrame:CreateChildWidget("label", "ratioLabel", 0, true)
      ratioLabel:SetAutoResize(true)
      ratioLabel:SetHeight(FONT_SIZE.MIDDLE)
      ratioLabel:AddAnchor("TOP", rightInfoFrame.itemIcon, "BOTTOM", 0, 7)
      ApplyTextColor(ratioLabel, FONT_COLOR.DEFAULT)
      if featureSet.specialtyTradeGoods then
        local itemName = leftInfoFrame:CreateChildWidget("textbox", "itemName", 0, true)
        itemName:SetAutoResize(true)
        itemName:SetWidth(leftInfoFrame:GetWidth() - MARGIN.WINDOW_SIDE)
        itemName:SetHeight(FONT_SIZE.MIDDLE)
        itemName:AddAnchor("TOP", leftInfoFrame.itemIcon, "BOTTOM", 0, 7)
        ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
      end
      local textbox = rightInfoFrame:CreateChildWidget("textbox", "textbox", 0, true)
      textbox:Show(false)
      textbox:SetWidth(rightInfoFrame:GetWidth())
      textbox:SetHeight(FONT_SIZE.LARGE)
      textbox.style:SetFontSize(FONT_SIZE.LARGE)
      ApplyTextColor(textbox, FONT_COLOR.BLUE)
      function dlgWnd:FillInfo(refund, itemType, itemGrade)
        local upperStr = ""
        local refundNumber = tonumber(refund)
        local backpackInfo = X2Item:GetItemInfoByType(itemType)
        if coinType ~= nil and refundNumber <= 0 then
          upperStr = GetCommonText("sell_backpack_sell_goods_full")
        elseif backpackInfo.backpackType == BPT_TRADEGOODS then
          upperStr = GetCommonText("sell_backpack_ask_sell_tradegoods")
        else
          upperStr = GetCommonText("sell_backpack_ask_sell_goods")
        end
        upperContent:SetText(upperStr)
        local extraHeight = 0
        leftInfoFrame.itemIcon:SetItem(itemType, itemGrade, 1)
        rightInfoFrame.ratioLabel:SetText(GetRatioStr())
        if leftInfoFrame.itemName ~= nil then
          printName = string.format("[%s]", backpackInfo.name)
          leftInfoFrame.itemName:SetText(printName)
          extraHeight = leftInfoFrame.itemName:GetHeight() - FONT_SIZE.MIDDLE
        end
        if coinType ~= nil and coinType ~= 0 then
          rightInfoFrame.itemIcon:Show(true)
          local info = X2Item:GetItemInfoByType(coinType)
          rightInfoFrame.itemIcon:SetItem(info.itemType, info.itemGrade, refund)
          leftInfoFrame:SetHeight(115 + extraHeight)
          rightInfoFrame:SetHeight(115 + extraHeight)
        else
          rightInfoFrame.itemIcon:Show(false)
          rightInfoFrame.textbox:Show(true)
          rightInfoFrame.textbox:AddAnchor("TOP", rightInfoFrame.title, "BOTTOM", 0, sideMargin / 1.5)
          local refundStr = ""
          if coinType ~= nil and coinType ~= 0 then
            refundStr = string.format("x %s", refund)
          else
            refundStr = string.format("|m%s;", refund)
          end
          rightInfoFrame.textbox:SetText(refundStr)
          rightInfoFrame.textbox:SetWidth(rightInfoFrame.textbox:GetLongestLineWidth() + 5)
          leftInfoFrame:SetHeight(95)
          rightInfoFrame:SetHeight(95)
        end
        if refundNumber <= 0 then
          rightInfoFrame.itemIcon:Show(false)
          rightInfoFrame.textbox:Show(false)
        end
        dlgWnd:SetTitle(GetTitle(coinType))
        dlgWnd:SetContent(GetContent(featureSet.backpackProfitShare, coinType, refundNumber, backpackInfo.backpackType))
        dlgWnd.btnOk:Enable(true)
      end
      function dlgWnd:Resize()
        local height = self:GetFrameHeight()
        if featureSet.specialtyTradeGoods then
          height = height + 8
        else
          height = height + upperContent:GetHeight() + leftInfoFrame:GetHeight() + MARGIN.WINDOW_SIDE
        end
        self:SetExtent(POPUP_WINDOW_WIDTH, height)
      end
      dlgWnd:Resize()
    end
  else
    ApplyDialogStyle(dlgWnd, "TYPE1")
    do
      local ratioLabel = dlgWnd:CreateChildWidget("label", "ratioLabel", 0, false)
      ratioLabel:SetHeight(FONT_SIZE.MIDDLE)
      ratioLabel:SetAutoResize(true)
      ApplyTextColor(ratioLabel, FONT_COLOR.DEFAULT)
      ratioLabel:AddAnchor("TOP", dlgWnd.itemTextbox, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2.5)
      function dlgWnd:Resize()
        local height = self:GetFrameHeight()
        height = height + ratioLabel:GetHeight() + self.itemTextbox.bg:GetHeight() + MARGIN.WINDOW_SIDE + self.itemIcon:GetHeight()
        self:SetExtent(POPUP_WINDOW_WIDTH, height)
      end
      dlgWnd:Resize()
      function dlgWnd:FillInfo(refund)
        if refund <= 0 then
          dlgWnd.itemTextbox:Show(false)
        end
        if coinType ~= nil then
          backpackInfo = X2Item:GetItemInfoByType(coinType)
        end
        ratioLabel:SetText(GetRatioStr())
        dlgWnd:SetContentEx(GetContent(featureSet.backpackProfitShare, coinType, refund), backpackInfo, 1, price)
        local enable = false
        if coinType == nil then
          enable = true
        elseif refund ~= nil and refund > 0 then
          enable = true
        end
        dlgWnd:SetTitle(GetTitle(coinType))
        dlgWnd.btnOk:Enable(enable)
      end
    end
  end
  local events = {
    UPDATE_SPECIALTY_RATIO = function(refund, itemType, itemGrade, coinType)
      if infoTable.itemType ~= itemType or infoTable.itemGrade ~= itemGrade or infoTable.coinType ~= coinType then
        X2DialogManager:OnCancel(dlgWnd:GetId())
        return
      end
      dlgWnd:FillInfo(refund, itemType, itemGrade)
    end,
    UNIT_EQUIPMENT_CHANGED = function()
      if equipSlot == ES_BACKPACK then
        X2DialogManager:OnCancel(dlgWnd:GetId())
      end
    end,
    SELL_SPECIALTY_CONTENT_INFO = function(sellTable)
      local itemType = sellTable[1].item.itemType
      local itemGrade = sellTable[1].item.itemGrade
      if infoTable.itemType ~= itemType or infoTable.itemGrade ~= itemGrade or infoTable.coinType ~= 0 then
        X2DialogManager:OnCancel(dlgWnd:GetId())
        return
      end
      dlgWnd:FillInfo(sellTable[1].refund, itemType, itemGrade)
    end
  }
  dlgWnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(dlgWnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_SPECIALTY_TRADE, NpcInteractionSpecialtyTrade)
local DialogActiveHeirSkillHandler = function(wnd, infoTable)
  ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_THREE_VALUE_TEXT)
  local title = GetCommonText("active_heir_skill_title")
  local content = string.format("%s%s", FONT_COLOR_HEX.BLUE, GetCommonText("active_heir_skill_desc"))
  local valueText1 = locale.skillTrainingMsg.heir_skill_training_msg
  local valueText2 = ""
  wnd:SetTitle(title)
  wnd:SetContentEx(content, valueText1, valueText2, GetCommonText("active_skill_desc"))
end
X2DialogManager:SetHandler(DLG_TASK_ACTIVE_HEIR_SKILL, DialogActiveHeirSkillHandler)
local DialogAskExitIndunHandler = function(wnd, infoTable)
  local title = GetCommonText("exit_indun_dlg_title")
  local content = GetCommonText("exit_indun_dlg_desc")
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_ASK_EXIT_INDUN, DialogAskExitIndunHandler)
local DialogReportBadworduserHandler = function(wnd, infoTable)
  local title = X2Locale:LocalizeUiText(COMMON_TEXT, "report_badword_user")
  local content = X2Locale:LocalizeUiText(COMMON_TEXT, "report_badword_user_content", infoTable.charName)
  wnd:SetTitle(title)
  wnd:SetContent(content)
end
X2DialogManager:SetHandler(DLG_TASK_REPORT_BADWORD_USER, DialogReportBadworduserHandler)
local DialogRenameCharacterByItemHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "rename_character_by_item_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "rename_character_by_item_desc1", infoTable.charName))
  local haveCount = X2Bag:GetCountInBag(infoTable.itemInfo.itemType)
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = {haveCount, 1}
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  local textData = {
    type = "warning",
    text = GetUIText(COMMON_TEXT, "rename_character_by_item_desc2")
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
end
X2DialogManager:SetHandler(DLG_TASK_RENAME_CHARACTER_BY_ITEM, DialogRenameCharacterByItemHandler)
local DialogDisbandSquad = function(wnd, infoTable)
  wnd:SetTitle(GetCommonText("squad_disband_dlg_title"))
  wnd:SetContent(GetCommonText("squad_disband_dlg_content"))
end
X2DialogManager:SetHandler(DLG_TASK_DISBAND_SQUAD, DialogDisbandSquad)
local DialogDisbandSquadInRecruitList = function(wnd, infoTable)
  wnd:SetTitle(GetCommonText("squad_disband_recruit_list_dlg_title"))
  wnd:SetContent(GetCommonText("squad_disband_recruit_list_dlg_content"))
end
X2DialogManager:SetHandler(DLG_TASK_DISBAND_SQUAD_IN_RECRUIT_LIST, DialogDisbandSquadInRecruitList)
local DialogInviteSquadMember = function(wnd, infoTable)
  local content = X2Locale:LocalizeUiText(COMMON_TEXT, "squad_invited_dlg_content", infoTable.inviterCharName .. "@" .. infoTable.worldName)
  wnd:SetTitle(GetCommonText("squad_invited_dlg_title"))
  wnd:SetContent(content)
  wnd.btnOk:AddAnchor("BOTTOM", wnd, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local btnCancel = wnd:CreateChildWidget("button", "btnCancel", 0, false)
  btnCancel:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(btnCancel, BUTTON_BASIC.DEFAULT)
  btnCancel:AddAnchor("BOTTOM", wnd, BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local checkTime = infoTable.timeOut
  local function OnUpdate(self, dt)
    if self:IsVisible() == false then
      return
    end
    checkTime = checkTime - dt
    if checkTime > 0 then
      return
    end
    X2DialogManager:OnCustom(wnd:GetId(), 2)
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
  local function OkBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), 0)
  end
  wnd.btnOk:SetHandler("OnClick", OkBtnClickFunc)
  local function CancelBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), 1)
  end
  btnCancel:SetHandler("OnClick", CancelBtnClickFunc)
end
X2DialogManager:SetHandler(DLG_TASK_INVITE_SQUAD_MEMBER, DialogInviteSquadMember)
local DialogItemEvolvingConfirm = function(wnd, infoTable)
  ApplyDialogStyle(wnd, "TYPE1")
  wnd.itemTextbox.bg:SetTexture(TEXTURE_PATH.DEFAULT)
  wnd.itemTextbox.bg:SetTextureInfo("common_bg", "brown")
  local itemDesc = string.format("|c%s[%s]", infoTable.itemInfo.gradeColor, infoTable.itemInfo.name)
  wnd:SetTitle(GetCommonText("change_evolving_effect"))
  wnd:SetContentEx(GetCommonText("item_evolving_confirm"), infoTable.itemInfo, 1, itemDesc)
  local changeAttr = wnd:CreateChildWidget("emptywidget", "changeAttr", 0, true)
  changeAttr:SetWidth(390)
  changeAttr:AddAnchor("TOP", wnd.itemTextbox, "BOTTOM", 0, 9)
  local bg = changeAttr:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", changeAttr, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", changeAttr, 0, 0)
  local bg1 = changeAttr:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg1:SetTextureColor("default")
  bg1:SetWidth(100 + LOCALE_ATTR_INFO_WIDTH_ADJUST)
  bg1:AddAnchor("TOPLEFT", changeAttr, 0, 0)
  bg1:AddAnchor("BOTTOMLEFT", changeAttr, 0, 0)
  local CreateAttrTitle = function(parent, name, text)
    local attrTitle = parent:CreateChildWidget("textbox", name, 0, true)
    attrTitle:SetWidth(80 + LOCALE_ATTR_INFO_WIDTH_ADJUST)
    attrTitle:SetHeight(FONT_SIZE.LARGE)
    attrTitle:SetAutoWordwrap(true)
    attrTitle:SetAutoResize(true)
    attrTitle:SetText(text)
    attrTitle.style:SetAlign(ALIGN_CENTER)
    attrTitle.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    ApplyTextColor(attrTitle, FONT_COLOR.EVOLVING_GRAY)
    local attrInfo = attrTitle:CreateChildWidget("textbox", name .. "Info", 0, true)
    attrInfo:SetWidth(275 - LOCALE_ATTR_INFO_WIDTH_ADJUST)
    attrInfo:SetAutoWordwrap(true)
    attrInfo:SetAutoResize(true)
    attrInfo:SetHeight(FONT_SIZE.LARGE)
    attrInfo.style:SetAlign(ALIGN_CENTER)
    attrInfo.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    attrInfo:AddAnchor("LEFT", attrTitle, "RIGHT", 14, 0)
    attrTitle.attrInfo = attrInfo
    function attrTitle:SetAttrInfo(text, color)
      attrInfo:SetText(text)
      ApplyTextColor(attrInfo, color)
    end
    return attrTitle
  end
  local GetAttrStr = function(name, value)
    return string.format("%s %s", locale.attribute(name), GetModifierCalcValue(name, value))
  end
  local beforeAttr = CreateAttrTitle(changeAttr, "beforeAttr", GetCommonText("evolving_dialog_before_attr_title"))
  beforeAttr:AddAnchor("TOPLEFT", changeAttr, "TOPLEFT", 10, 17)
  beforeAttr:SetAttrInfo(GetAttrStr(infoTable.beforeChange.name, infoTable.beforeChange.value), FONT_COLOR.TITLE)
  local afterAttr = CreateAttrTitle(changeAttr, "afterAttr", GetCommonText("evolving_dialog_after_attr_title"))
  afterAttr:AddAnchor("BOTTOMLEFT", changeAttr, "BOTTOMLEFT", 10, -17)
  afterAttr:SetAttrInfo(GetAttrStr(infoTable.afterChange.name, infoTable.afterChange.value), FONT_COLOR.SEA_BLUE)
  changeAttr:SetHeight(beforeAttr:GetHeight() + afterAttr:GetHeight() + ATTR_INFO_HEIGHT_ADJUST)
  local arrow = beforeAttr:CreateChildWidget("label", "arrow", 0, true)
  arrow:SetHeight(FONT_SIZE.LARGE)
  arrow:SetAutoResize(true)
  arrow:SetText("\226\150\188")
  arrow.style:SetAlign(ALIGN_CENTER)
  arrow.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  local _, startPos = beforeAttr.attrInfo:GetOffset()
  startPos = startPos + beforeAttr.attrInfo:GetHeight()
  local _, endPos = afterAttr.attrInfo:GetOffset()
  local arrowOffsetY = (endPos - startPos - arrow:GetHeight()) / 2
  arrow:AddAnchor("TOP", beforeAttr.attrInfo, "BOTTOM", 0, arrowOffsetY)
  ApplyTextColor(arrow, FONT_COLOR.SEA_BLUE)
  local remainTime = wnd:CreateChildWidget("textbox", "remainTime", 0, true)
  remainTime:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 15)
  remainTime.style:SetAlign(ALIGN_CENTER)
  remainTime.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  remainTime:AddAnchor("TOP", changeAttr, "BOTTOM", 0, 20)
  ApplyTextColor(remainTime, FONT_COLOR.DEFAULT)
  wnd:SetWidth(430)
  wnd:RegistBottomWidget(remainTime)
  local checkTime = infoTable.remainTime
  local function OnUpdate(self, dt)
    if self:IsVisible() == false then
      return
    end
    checkTime = math.min(checkTime, checkTime - dt)
    local secondTime = math.max(0, checkTime / 1000)
    local time = X2Locale:LocalizeUiText(COMMON_TEXT, "item_evolving_confirm_remain_time", string.format("%02d", secondTime / 60), string.format("%02d", secondTime % 60), string.format("|c%s", Dec2Hex(FONT_COLOR.BLUE)))
    remainTime:SetText(time)
    if checkTime > 0 then
      return
    end
    X2DialogManager:OnCancel(wnd:GetId())
    infoTable.remainTime = 0
  end
  wnd:SetHandler("OnUpdate", OnUpdate)
end
X2DialogManager:SetHandler(DLG_TASK_ITEM_EVOLVING_CONFIRM, DialogItemEvolvingConfirm)
local CreateCheckDialog = function(wnd, infoTable, title, content, checkText, color)
  wnd:SetTitle(title)
  wnd:SetContent(content)
  local btnBetweenWndDiff = 20
  local textBetweenCheckDiff = 23
  local textButton = CreateCheckButton("textButton", wnd, checkText)
  textButton:AddAnchor("TOP", wnd.textbox, "BOTTOM", -(textButton.textButton:GetWidth() / 2), textBetweenCheckDiff)
  SetButtonFontColor(textButton.textButton, color)
  wnd.textButton = textButton
  wnd:RegistBottomWidget(textButton)
end
local isVisibleForceAttack = false
local function DialogToggleForceAttack(forceAttackLevel)
  local timeStampKey = "request_force_attack_hide"
  local localData = X2Time:GetLocalDate()
  local stamp = string.format("%s-%s-%s", localData.year, localData.month, localData.day)
  local savedStamp = UI:GetUIStamp(timeStampKey)
  if savedStamp == stamp then
    X2Player:ToggleForceAttack()
    return
  end
  if isVisibleForceAttack == true then
    return
  end
  local function AskForceAttack(wnd, infoTable)
    isVisibleForceAttack = true
    local title = X2Locale:LocalizeUiText(COMMON_TEXT, "force_attack")
    local content = X2Locale:LocalizeUiText(COMMON_TEXT, "force_attack_warring_msg", tostring(forceAttackLevel + 1), FONT_COLOR_HEX.RED)
    local checkText = X2Locale:LocalizeUiText(COMMON_TEXT, "hide_window")
    local color = {
      normal = FONT_COLOR.GRAY,
      highlight = FONT_COLOR.GRAY,
      pushed = FONT_COLOR.GRAY,
      disabled = FONT_COLOR.GRAY
    }
    CreateCheckDialog(wnd, nil, title, content, checkText, color)
    function wnd:OkProc()
      local checked = wnd.textButton:GetChecked()
      if checked == true then
        UI:SetUIStamp(timeStampKey, stamp)
      end
      X2Player:ToggleForceAttack()
      isVisibleForceAttack = false
    end
    function wnd:CancelProc()
      isVisibleForceAttack = false
    end
  end
  X2DialogManager:RequestDefaultDialog(AskForceAttack, "UIParent")
end
UIParent:SetEventHandler("ASK_FORCE_ATTACK", DialogToggleForceAttack)
local function DialogRechargeLaborPowerByItemHandler(wnd, infoTable)
  ApplyDialogStyle(wnd, DIALOG_STYLE.INCLUDE_ITEM_ICON_VALUE_TEXT_VERTICAL)
  local title = GetCommonText("recharge_lp_by_item_title")
  local itemInfo = infoTable.itemInfo
  local itemDesc = MakeItemDesc(itemInfo.gradeColor, itemInfo.name, 1)
  local laborPowerStr = {
    GetCommonText("account_labor_power"),
    GetCommonText("local_labor_power")
  }
  local content = X2Locale:LocalizeUiText(COMMON_TEXT, "recharge_lp_by_item_desc1", string.format("%s%s|r", F_COLOR.GetColor("bright_green", true), laborPowerStr[infoTable.kind]))
  local content2 = X2Locale:LocalizeUiText(COMMON_TEXT, "recharge_lp_by_item_desc2", string.format("%s%s|r", F_COLOR.GetColor("bright_green", true), laborPowerStr[infoTable.kind]))
  local content3 = X2Locale:LocalizeUiText(COMMON_TEXT, "cur_labor_power", laborPowerStr[infoTable.kind])
  content3 = string.format("%s: %s|,%d;|r / |,%d;", content3, F_COLOR.GetColor("bright_green", true), infoTable.lp, infoTable.maxLp)
  content = string.format([[
%s
%s

%s]], content, content2, content3)
  local rechargeLpStr = string.format("%s %s|,%d;|r", GetCommonText("recharge_labor_power"), F_COLOR.GetColor("blue", true), infoTable.rechargeLp)
  local curCount = X2Bag:GetCountInBag(itemInfo.itemType)
  local stackTable = {curCount, 1}
  wnd:SetTitle(title)
  wnd:SetContentEx(content, itemInfo, stackTable, itemDesc, rechargeLpStr, FONT_SIZE.MIDDLE)
  wnd.btnOk:Enable(curCount >= 1)
end
X2DialogManager:SetHandler(DLG_TASK_RECHARGE_LP_BY_ITEM, DialogRechargeLaborPowerByItemHandler)
local function DialogRechargeLaborPowerWarringHandler(wnd, infoTable)
  local itemInfo = infoTable.itemInfo
  local laborPowerStr = {
    GetCommonText("account_labor_power"),
    GetCommonText("local_labor_power")
  }
  local content1 = X2Locale:LocalizeUiText(COMMON_TEXT, "recharge_lp_by_item_warring1", laborPowerStr[infoTable.kind])
  local content2 = X2Locale:LocalizeUiText(COMMON_TEXT, "recharge_lp_by_item_warring2", laborPowerStr[infoTable.kind])
  local content3 = GetCommonText("recharge_lp_by_item_warring3")
  infoTable.title = X2Locale:LocalizeUiText(COMMON_TEXT, "recharge_lp_by_item_title")
  infoTable.content = string.format([[
%s
%s
%s]], content1, content2, content3)
  SetDialogTexts(wnd, infoTable)
end
X2DialogManager:SetHandler(DLG_TASK_RECHARGE_LP_WARRING, DialogRechargeLaborPowerWarringHandler)
local DialogRerollEvolvingWarringHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "reroll_chance_have_dlg_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "reroll_chance_have_dlg_info"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  local textData = {
    type = "warning",
    text = X2Locale:LocalizeUiText(COMMON_TEXT, "reroll_chance_have_dlg_warning", tostring(infoTable.evolveChance))
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
end
X2DialogManager:SetHandler(DLG_TASK_ITEM_REROLL_EVOLVING, DialogRerollEvolvingWarringHandler)
local function DialogRerollEvolvinChanceOverHandler(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "warning_craft_title")
  infoTable.content = X2Locale:LocalizeUiText(COMMON_TEXT, "reroll_chance_dlg_info")
  SetDialogTexts(wnd, infoTable)
  local CreateChanceInfo = function(parent, name)
    local chanceText = parent:CreateChildWidget("textbox", name, 0, true)
    chanceText:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 30)
    chanceText.style:SetAlign(ALIGN_CENTER)
    chanceText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
    chanceText:SetAutoResize(true)
    ApplyTextColor(chanceText, FONT_COLOR.DEFAULT)
    local bg = chanceText:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
    bg:SetTextureColor("default")
    bg:AddAnchor("TOPLEFT", chanceText, 0, -11)
    bg:AddAnchor("BOTTOMRIGHT", chanceText, 0, 11)
    return chanceText
  end
  local curChance = CreateChanceInfo(wnd, "curChance")
  curChance:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 19)
  local maxChance = CreateChanceInfo(wnd, "maxChance")
  maxChance:AddAnchor("TOP", curChance, "BOTTOM", 0, 22)
  local str = string.format([[
%s + %s
%d %s+ %d]], GetCommonText("reroll_chance_dlg_cur_chance"), GetCommonText("reroll_chance_dlg_add_chance"), infoTable.curChance, FONT_COLOR_HEX.GREEN, infoTable.addChance)
  curChance:SetText(str)
  str = string.format([[
%s
%d]], GetCommonText("reroll_chance_dlg_max_chance"), infoTable.maxChance)
  maxChance:SetText(str)
  local warning = wnd:CreateChildWidget("textbox", "warning", 0, true)
  warning:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 30)
  warning.style:SetAlign(ALIGN_CENTER)
  warning.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  warning:SetAutoResize(true)
  ApplyTextColor(warning, FONT_COLOR.RED)
  warning:AddAnchor("TOP", maxChance, "BOTTOM", 0, 18)
  warning:SetText(GetCommonText("reroll_chance_dlg_warning"))
  local textButton = CreateCheckButton("textButton", wnd, GetCommonText("hide_window"))
  textButton:AddAnchor("TOP", warning, "BOTTOM", -(textButton.textButton:GetWidth() / 2), 20)
  wnd.textButton = textButton
  local color = {
    normal = FONT_COLOR.DEFAULT,
    highlight = FONT_COLOR.DEFAULT,
    pushed = FONT_COLOR.DEFAULT,
    disabled = FONT_COLOR.GRAY
  }
  SetButtonFontColor(textButton.textButton, color)
  wnd:RegistBottomWidget(textButton)
  function wnd:OkProc()
    local checked = wnd.textButton:GetChecked()
    if checked == true then
      local localData = X2Time:GetLocalDate()
      local stamp = string.format("%s-%s-%s", localData.year, localData.month, localData.day)
      UI:SetUIStamp(infoTable.stampKey, stamp)
    end
    wnd:Show(false)
  end
end
X2DialogManager:SetHandler(DLG_TASK_ITEM_REROLL_CHANCE_OVER, DialogRerollEvolvinChanceOverHandler)
local function DialogEvolvingWarningHandler(wnd, infoTable)
  infoTable.title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "warning_craft_title")
  infoTable.content = X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_dlg_info1")
  SetDialogTexts(wnd, infoTable)
  wnd:SetHeight(500)
  wnd.textbox:SetAutoResize(true)
  local warningWidget = wnd:CreateChildWidget("emptywidget", "warningWidget", 0, true)
  warningWidget:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 140)
  warningWidget:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 11)
  local bg = warningWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", warningWidget, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", warningWidget, 0, 0)
  local offsetX = 18
  for i = 1, MAX_ITEM_EVOLVE_MATERIAL_SLOT do
    local materialSlot = CreateItemIconButton("materialSlot" .. i, warningWidget)
    materialSlot:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    materialSlot:AddAnchor("TOPLEFT", warningWidget, offsetX, 19)
    offsetX = offsetX + materialSlot:GetWidth() + 5
    local slotInfo = infoTable.slotInfos[i]
    if slotInfo ~= nil then
      UpdateSlot(materialSlot, slotInfo, true)
      materialSlot:Enable(not slotInfo.isDimSlot)
    else
      materialSlot:Enable(false)
    end
  end
  local warningItemText = warningWidget:CreateChildWidget("textbox", "warningItemText", 0, true)
  warningItemText:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  warningItemText.style:SetAlign(ALIGN_CENTER)
  warningItemText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  warningItemText:AddAnchor("TOP", warningWidget, 0, ICON_SIZE.DEFAULT + 32)
  warningItemText:SetAutoResize(true)
  ApplyTextColor(warningItemText, FONT_COLOR.RED)
  local strWarning = ""
  if 0 < infoTable.gemCnt then
    strWarning = string.format("%s%s", strWarning, X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_dlg_gem", tostring(infoTable.gemCnt)))
  end
  if 0 < infoTable.socketCnt then
    if 0 < string.len(strWarning) then
      strWarning = string.format("%s\n", strWarning)
    end
    strWarning = string.format("%s%s", strWarning, X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_dlg_socket", tostring(infoTable.socketCnt)))
  end
  if 0 < infoTable.lookCnt then
    if 0 < string.len(strWarning) then
      strWarning = string.format("%s\n", strWarning)
    end
    strWarning = string.format("%s%s", strWarning, X2Locale:LocalizeUiText(COMMON_TEXT, "evolving_dlg_look", tostring(infoTable.lookCnt)))
  end
  warningItemText:SetText(strWarning)
  warningWidget:SetHeight(ICON_SIZE.DEFAULT + warningItemText:GetHeight() + 48)
  local contentText = wnd:CreateChildWidget("textbox", "contentText", 0, true)
  contentText:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  contentText.style:SetAlign(ALIGN_CENTER)
  contentText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  contentText:AddAnchor("TOP", warningWidget, "BOTTOM", 0, 11)
  contentText:SetAutoResize(true)
  contentText:SetText(GetCommonText("evolving_dlg_info2"))
  ApplyTextColor(contentText, FONT_COLOR.DEFAULT)
  wnd:RegistBottomWidget(contentText)
end
X2DialogManager:SetHandler(DLG_TASK_ITEM_EVOLVING_WARNING, DialogEvolvingWarningHandler)
local DialogFamilyJoinHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "family_join"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "family_join_content", infoTable.name))
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = {
      infoTable.itemInfo.haveItemCount,
      infoTable.itemInfo.maxItemCount
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_FAMILY_JOIN, DialogFamilyJoinHandler)
local DialogExpandInventoryHandler = function(wnd, infoTable)
  local title = ""
  local body = ""
  local changeboxTitle = ""
  local prevCount = 0
  local nextCount = 0
  if infoTable.kind == "bag" then
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_expand_bag")
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_expand_bag")
    changeboxTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "expand_bag")
    prevCount = X2Bag:GetBagNumSlots(1)
    nextCount = X2Bag:ExpandedSlotCount()
  elseif infoTable.kind == "bank" then
    title = X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "ask_expand_bank")
    body = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "ask_expand_bank")
    changeboxTitle = X2Locale:LocalizeUiText(COMMON_TEXT, "expand_bank")
    prevCount = X2Bank:Capacity()
    nextCount = X2Bank:ExpandedSlotCount()
  else
    return
  end
  wnd:SetTitle(title)
  wnd:UpdateDialogModule("textbox", body)
  local changeData = {
    titleInfo = {title = changeboxTitle},
    left = {
      UpdateValueFunc = function(leftValueWidget)
        leftValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(prevCount)))
      end
    },
    right = {
      UpdateValueFunc = function(rightValueWidget)
        rightValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(nextCount)))
      end
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeData", changeData)
  if infoTable.dialog == "money" then
    local data = {
      type = "cost",
      currency = infoTable.currency,
      value = infoTable.cost
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
  elseif infoTable.dialog == "item" then
    local data = {
      itemInfo = X2Item:GetItemInfoByType(infoTable.itemType),
      stack = {
        X2Bag:GetCountInBag(infoTable.itemType),
        infoTable.itemCount
      }
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
  elseif infoTable.dialog == "item_money" then
    local data = {
      itemInfo = X2Item:GetItemInfoByType(infoTable.itemType),
      stack = {
        X2Bag:GetCountInBag(infoTable.itemType),
        infoTable.itemCount
      }
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
    local data = {
      type = "cost",
      currency = infoTable.currency,
      value = infoTable.cost
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
  end
end
X2DialogManager:SetHandler(DLG_TASK_EXPAND_INVENTORY, DialogExpandInventoryHandler)
local DialogIndunDirectTel = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "portal_indun_tel"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "portal_indun_tel_content", infoTable.zoneText))
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = {
      infoTable.haveItemCount,
      infoTable.useItemCount
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_INDUN_DIRECT_TEL, DialogIndunDirectTel)
local DialogFamilyIncreaseMemberHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "family_increase_member"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "family_increase_member_content"))
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = {
      infoTable.itemInfo.haveItemCount,
      infoTable.itemInfo.maxItemCount
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_FAMILY_INCREASE_MEMBER, DialogFamilyIncreaseMemberHandler)
local DialogDestroyItemHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "ask_item_destroy"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_item_destroy"))
  local itemData = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
  if infoTable.affectQuest ~= 0 then
    local questTitle = X2Quest:GetQuestContextMainTitle(infoTable.affectQuest)
    if questTitle ~= nul or questTitle ~= "" then
      local textData = {
        type = "warning",
        text = GetUIText(MSG_BOX_BODY_TEXT, "ask_quest_item_destroy", questTitle)
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
    end
  end
  function wnd:GetOkSound()
    return "event_message_box_item_destroy_onok"
  end
end
X2DialogManager:SetHandler(DLG_TASK_DESTROY_ITEM, DialogDestroyItemHandler)
function CallUnlockTodayQuestDialog(title, todayQuestType, info)
  local function DialogUnlockTodayQuestHandler(dlg)
    dlg:SetTitle(title)
    if info.requireItem ~= nil and info.requireItem ~= 0 and 0 < info.requireItemCount then
      local itemInfo = X2Item:GetItemInfoByType(info.requireItem)
      dlg:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "unlock_today_quest_use_item", info.title))
      local data = {
        itemInfo = itemInfo,
        stack = info.requireItemCount
      }
      dlg:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
    else
      local content = X2Locale:LocalizeUiText(MSG_BOX_BODY_TEXT, "unlock_today_quest", info.title)
      dlg:UpdateDialogModule("textbox", content)
    end
    function dlg:OkProc()
      X2Achievement:HandleClickTodayAssignment(todayQuestType, info.realStep)
    end
  end
  X2DialogManager:RequestDefaultDialog(DialogUnlockTodayQuestHandler, "")
end
local DialogRestoreDisableEnchantItemHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "ask_restore_disable_enchant"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_restore_disable_enchant"))
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_RESTORE_DISABLE_ENCHANT_ITEM, DialogRestoreDisableEnchantItemHandler)
local DialogHeirLevelUpHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "heir_level_up"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "heir_level_up_confirm_msg"))
  if infoTable.itemType ~= nil and infoTable.itemType ~= 0 then
    local data = {
      itemInfo = X2Item:GetItemInfoByType(infoTable.itemType),
      stack = {
        infoTable.has,
        infoTable.need
      }
    }
    wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
  end
end
X2DialogManager:SetHandler(DLG_TASK_HEIR_LEVEL_UP, DialogHeirLevelUpHandler)
local DialogSkinizeItemHandler = function(wnd, infoTable)
  local needItemName = GetUIText(COMMON_TEXT, "item_name_in_dialog", X2Item:GradeColor(infoTable.scrollGrade), X2Item:Name(infoTable.scrollType))
  local content = GetUIText(MSG_BOX_BODY_TEXT, "skinizeItem_body", needItemName)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "skinizeItem_title"))
  wnd:UpdateDialogModule("textbox", content)
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_SKINIZE_ITEM, DialogSkinizeItemHandler)
local DialogGetHeirSkillHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "get_heir_skill_title"))
  wnd:UpdateDialogModule("textbox", locale.skillTrainingMsg.heir_skill_training_msg)
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = {
      X2Bag:GetCountInBag(infoTable.itemInfo.itemType),
      1
    }
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_GET_HEIR_SKILL, DialogGetHeirSkillHandler)
local DialogSecurityUnlockItem = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(INVEN_TEXT, "unlock_item"))
  local delayMin = X2Item:GetSecurityUnlockDelayTime()
  if delayMin == 0 then
    wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_unlock_item"))
  else
    wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "ask_unlock_item_with_delay", tostring(delayMin / 60)))
  end
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
end
X2DialogManager:SetHandler(DLG_TASK_SECURITY_UNLOCK_ITEM, DialogSecurityUnlockItem)
local GetLearnAbilityName = function(name)
  return locale.common.abilityNameWithStr(name) or name
end
local GetLearnSkillContent = function(abilityName, skillName)
  return X2Locale:LocalizeUiText(SKILL_TRAINING_MSG_TEXT, "training_msg_2", abilityName, skillName)
end
local function DialogLearnSkillHandler(wnd, infoTable)
  wnd:SetTitle(GetUIText(LEARNING_TEXT, "title"))
  local skillInfo = X2Skill:Info(infoTable.skillType)
  local abilityName = GetLearnAbilityName(skillInfo.abilityName)
  local content = GetLearnSkillContent(abilityName, skillInfo.name)
  wnd:UpdateDialogModule("textbox", content)
  local data = {
    type = "skill_point",
    value = skillInfo.skillPoints
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "skillPoint", data)
end
X2DialogManager:SetHandler(DLG_TASK_LEARN_SKILL, DialogLearnSkillHandler)
local function DialogLearnBuffHandler(wnd, infoTable)
  wnd:SetTitle(GetUIText(LEARNING_TEXT, "title"))
  local passiveBuffInfo = X2Ability:GetPassiveBuffInfo(infoTable.passiveBuffType)
  local buffInfo = X2Ability:GetBuffTooltip(passiveBuffInfo.buffType, 1)
  local abilityName = GetLearnAbilityName(passiveBuffInfo.abilityName)
  local content = GetLearnSkillContent(abilityName, buffInfo.name)
  wnd:UpdateDialogModule("textbox", content)
  local data = {
    type = "skill_point",
    value = passiveBuffInfo.skillPoints
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "skillPoint", data)
end
X2DialogManager:SetHandler(DLG_TASK_LEARN_BUFF, DialogLearnBuffHandler)
local DialogResetSkillsHandler = function(wnd, infoTable)
  wnd:SetTitle(locale.icon_shape_button_tooltip.resetSkill)
  wnd:UpdateDialogModule("textbox", GetUIText(SKILL_TRAINING_MSG_TEXT, "skill_init_msg_2"))
  local data = {
    type = "cost",
    currency = F_MONEY.currency.skillsReset,
    value = infoTable.cost
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
  local data = {
    type = "recovery_skill_point",
    value = infoTable.count
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "recorverySkillPoint", data)
end
X2DialogManager:SetHandler(DLG_TASK_RESET_SKILLS, DialogResetSkillsHandler)
local NpcInteractionPriestRecoverExp = function(wnd, infoTable)
  wnd:SetTitle(locale.priest.title)
  wnd:UpdateDialogModule("textbox", GetUIText(PRIEST_TEXT, "recover_exp"))
  local data = {
    type = "labor_power",
    value = infoTable.laborPowerCost
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "laborPower", data)
  local data = {
    type = "exp",
    value = X2Player:GetRecoverableExp()
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "exp", data)
end
X2DialogManager:SetHandler(DLG_TASK_PRIEST_RECOVER_EXP, NpcInteractionPriestRecoverExp)
local NpcInteractionPriestDivineBlessingExp = function(wnd, infoTable)
  wnd:SetTitle(locale.priest.title)
  wnd:UpdateDialogModule("textbox", GetUIText(PRIEST_TEXT, "confirm_buy_buff"))
  local data = {
    type = "cost",
    value = infoTable.cost
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
end
X2DialogManager:SetHandler(DLG_TASK_PRIEST_DIVINE_BLESSING, NpcInteractionPriestDivineBlessingExp)
local DialogChangeHeirSkillHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "change_heir_skill_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "change_heir_skill"))
  local data = {
    type = "cost",
    currency = F_MONEY.currency.heirSkillsReset,
    value = infoTable.cost
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
end
X2DialogManager:SetHandler(DLG_TASK_CHANGE_HEIR_SKILL, DialogChangeHeirSkillHandler)
local DialogBuildShipyardHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "confirm_locate_shipyard_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "confirm_locate_shipyard_body"))
  local data = {
    type = "cost",
    currency = F_MONEY.currency.houseTax,
    value = infoTable.tax
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
end
X2DialogManager:SetHandler(DLG_TASK_BUILD_SHIPYARD, DialogBuildShipyardHandler)
local DialogResetHeirSkillsForSlotHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(COMMON_TEXT, "reset_heir_skill_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "reset_heir_skill"))
  local data = {
    type = "cost",
    currency = F_MONEY.currency.heirSkillsReset,
    value = infoTable.cost
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
end
X2DialogManager:SetHandler(DLG_TASK_RESET_HEIR_SKILL_FOR_SLOT, DialogResetHeirSkillsForSlotHandler)
local function DialogResetHeirSkillsHandler(wnd, infoTable)
  local title = GetCommonText("reset_heir_skill_title")
  local content = GetCommonText("reset_heir_skill")
  local desc = string.format("%s%s", FONT_COLOR_HEX.RED, GetCommonText("reset_skill_desc"))
  local info = X2HeirSkill:GetResetSkillInfo(3)
  local valueText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.heirSkillsReset], tostring(info.cost))
  wnd:SetTitle(title)
  content = string.format([[
%s
%s]], content, desc)
  wnd:SetContent(content)
  local textTable = {
    {
      text = string.format("%s: %s", GetCommonText("reset_all_heir_ability"), locale.common.GetAmount(infoTable.allCount)),
      value = 1
    },
    {
      text = string.format("%s: %s", GetCommonText("reset_one_heir_ability", GetAbilityName(info.ability)), locale.common.GetAmount(infoTable.abilityCount)),
      value = 2
    },
    {
      text = string.format("%s: %s", info.skill, locale.common.GetAmount(infoTable.count)),
      value = 3
    }
  }
  local resetRadioButton = CreateRadioGroup("resetRadio", wnd, "vertical")
  resetRadioButton:SetWidth(wnd:GetWidth() - sideMargin * 2)
  resetRadioButton:AddAnchor("TOPLEFT", wnd.textbox, "BOTTOMLEFT", 0, 10)
  resetRadioButton:SetData(textTable)
  resetRadioButton:Check(3)
  local radiobg = CreateContentBackground(resetRadioButton, "TYPE2", "brown")
  radiobg:AddAnchor("TOPLEFT", resetRadioButton, -5, -5)
  radiobg:AddAnchor("BOTTOMRIGHT", resetRadioButton, 5, 5)
  local moneyText = wnd:CreateChildWidget("textbox", "moneyText", 0, true)
  moneyText:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 15)
  moneyText.style:SetAlign(ALIGN_CENTER)
  moneyText.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  moneyText:AddAnchor("TOP", resetRadioButton, "BOTTOM", 0, 15)
  moneyText:SetText(valueText)
  moneyText:Show(true)
  ApplyTextColor(moneyText, FONT_COLOR.TITLE)
  local bg = CreateContentBackground(moneyText, "TYPE7", "brown", "background")
  bg:SetExtent(moneyText:GetLongestLineWidth() + 70, moneyText:GetHeight())
  bg:AddAnchor("CENTER", moneyText, 0, 5)
  wnd.btnOk:AddAnchor("BOTTOM", wnd, -BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local btnCancel = wnd:CreateChildWidget("button", "btnCancel", 0, true)
  btnCancel:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(btnCancel, BUTTON_BASIC.DEFAULT)
  btnCancel:AddAnchor("BOTTOM", wnd, BUTTON_COMMON_INSET.TWO_BUTTON_BETEEN, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  wnd:RegistBottomWidget(moneyText)
  local function OkBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), resetRadioButton:GetChecked())
  end
  wnd.btnOk:SetHandler("OnClick", OkBtnClickFunc)
  local function CancelBtnClickFunc()
    X2DialogManager:OnCustom(wnd:GetId(), 0)
  end
  btnCancel:SetHandler("OnClick", CancelBtnClickFunc)
  function resetRadioButton:OnRadioChanged(checkedIndex)
    local info = X2HeirSkill:GetResetSkillInfo(checkedIndex)
    local valueText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.heirSkillsReset], tostring(info.cost))
    moneyText:SetText(valueText)
  end
  resetRadioButton:SetHandler("OnRadioChanged", resetRadioButton.OnRadioChanged)
end
X2DialogManager:SetHandler(DLG_TASK_RESET_HEIR_SKILL, DialogResetHeirSkillsHandler)
local DialogPerchaseHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "confirm_purchase_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "ask_buy_item"))
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = infoTable.itemCount
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
  local data = {
    type = "cost",
    currency = infoTable.currency,
    value = infoTable.moneyString
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
  local events = {
    INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_PURCHASE, DialogPerchaseHandler)
local DialogBuyFishHandler = function(wnd, infoTable)
  wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "confirm_buy_fish_title"))
  wnd:UpdateDialogModule("textbox", GetUIText(MSG_BOX_BODY_TEXT, "confirm_buy_fish_body"))
  local data = {
    itemInfo = infoTable.itemInfo,
    stack = 1
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
  local data = {
    type = "cost",
    value = infoTable.itemInfo.refund
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
  local data = {
    type = "labor_power",
    value = infoTable.laborPower
  }
  wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "laborPower", data)
  local events = {
    INTERACTION_END = function()
      X2DialogManager:OnCancel(wnd:GetId())
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(wnd, events)
end
X2DialogManager:SetHandler(DLG_TASK_BUY_FISH, DialogBuyFishHandler)
local DialogWarnExcutepHandler = function(wnd, infoTable)
  wnd:SetTitle(infoTable.title)
  local content = infoTable.content
  if popupInfo and popupInfo ~= "" then
    content = string.format([[
%s
%s%s]], FONT_COLOR_HEX.RED, infoTable.popupInfo)
  end
  wnd:UpdateDialogModule("textbox", content)
end
X2DialogManager:SetHandler(DLG_TASK_WARN_EXECUTE, DialogWarnExcutepHandler)
local DialogCustomRoleSelectHandler = function(wnd, infoTable)
  local radioData = {}
  for i = 1, infoTable.roleCount do
    local keyRole = string.format("role%d", i)
    local keyIcon = string.format("icon%d", i)
    local item = {
      text = infoTable[keyRole],
      value = i
    }
    if infoTable[keyIcon] ~= nil then
      item.image = {
        path = TEXTURE_PATH.RAID_TYPE_ICON,
        key = infoTable[keyIcon],
        anchor = "left"
      }
    end
    table.insert(radioData, item)
  end
  local radioBoxes = CreateRadioGroup("radioBoxes", wnd, "vertical")
  radioBoxes:SetGapWidth(10)
  radioBoxes:SetAutoWidth(true)
  radioBoxes:SetData(radioData)
  radioBoxes:AddAnchor("TOPLEFT", wnd, MARGIN.WINDOW_SIDE / 1.5, MARGIN.WINDOW_SIDE * 1.5)
  radioBoxes:Check(1)
  X2BattleField:SetCustomRoleSelect(1)
  wnd.radioBoxes = radioBoxes
  function radioBoxes:OnRadioChanged(index, dataValue)
    if index then
      X2BattleField:SetCustomRoleSelect(index)
    end
  end
  radioBoxes:SetHandler("OnRadioChanged", radioBoxes.OnRadioChanged)
end
X2DialogManager:SetHandler(DLG_TASK_CUSTOM_ROLE_SELECT, DialogCustomRoleSelectHandler)
local DialogFamilyChangeNameHandler = function(wnd, infoTable)
  wnd:SetTitle(GetCommonText("family_name_change"))
  wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "family_name_change_question", infoTable.changeName, tostring(MakeTimeString(infoTable.waitTime))))
end
X2DialogManager:SetHandler(DLG_TASK_FAMILY_CHANGE_NAME, DialogFamilyChangeNameHandler)
