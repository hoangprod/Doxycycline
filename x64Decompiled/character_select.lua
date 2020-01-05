local background = CreateEmptyWindow("background", "UIParent")
background:Show(true)
background:Clickable(false)
local titleBg = background:CreateDrawable(SELECT_TEXTURE, "title", "background")
titleBg:AddAnchor("TOPLEFT", background, 20, 20)
local serverName = background:CreateChildWidget("label", "serverName", 0, true)
serverName:SetExtent(10, FONT_SIZE.LARGE)
serverName:SetAutoResize(true)
serverName:SetText(X2World:GetCurrentWorldName())
serverName:AddAnchor("TOPLEFT", titleBg, "TOPRIGHT", 10, 0)
serverName.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.MIDDLE)
ApplyTextColor(serverName, F_COLOR.GetColor("text_btn_dis"))
local accountInfo = CreateAccountInfoWnd("accountInfo", background)
accountInfo:AddAnchor("TOP", background, 0, 10)
local characterInfo = CreateCharacterInfoWnd("characterInfo", background)
characterInfo:AddAnchor("LEFT", background, 20, 0)
characterInfo:Show(false)
local characterList = CreateCharacterListWnd("characterList", background)
local menuWnd = CreateMenuWnd("menuWnd", background)
menuWnd:AddAnchor("TOPRIGHT", background, -20, 20)
local serverBtn = background:CreateChildWidget("button", "serverBtn", 0, true)
serverBtn:AddAnchor("BOTTOMLEFT", background, 40, -40)
serverBtn:SetText(GetCommonText("server_select"))
ApplyButtonSkin(serverBtn, BUTTON_STYLE.STAGE)
local reviewBtn = background:CreateChildWidget("button", "reviewBtn", 0, true)
reviewBtn:SetText(GetUIText(QUEST_TEXT, "replay"))
ApplyButtonSkin(reviewBtn, BUTTON_STYLE.STAGE)
if characterSelectLocale.showReturnServer then
  serverBtn:Show(true)
  reviewBtn:AddAnchor("LEFT", serverBtn, "RIGHT", 15, 0)
  AdjustBtnLongestTextWidth({serverBtn, reviewBtn})
else
  serverBtn:Show(false)
  reviewBtn:AddAnchor("BOTTOMLEFT", background, 40, -40)
end
local startBtn = background:CreateChildWidget("button", "startBtn", 0, true)
startBtn:AddAnchor("BOTTOMRIGHT", background, -40, -40)
ApplyButtonSkin(startBtn, BUTTON_STYLE.STAGE)
startBtn:SetWidth(LOGIN_STAGE_LOGEST_BUTTON_WIDTH)
if X2World:IsPreSelectCharacterPeriod() then
  startBtn:SetText(GetUIText(CHARACTER_CREATE_TEXT, "confirmEditTitle"))
else
  startBtn:SetText(GetUIText(CHARACTER_SELECT_TEXT, "gameStart"))
end
local authMessage = CreateAuthMessageWindow("authMessage", background)
authMessage:AddAnchor("BOTTOMLEFT", characterInfo, "TOPLEFT", 10, -25)
local queueWindow = CreateCharacterSelectQueueWindow("CreateWorldQueueWindow", background)
local function UpdateQueue()
  local waitingLength = X2LoginCharacter:GetWorldQueuePosition()
  if waitingLength > 0 then
    queueWindow:UpdateWaitingInfo()
    queueWindow:Show(true)
  else
    queueWindow:Show(false)
  end
  characterList:UpdateList()
end
UpdateQueue()
local function ReAnchorOnScale()
  background:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  background:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  local _, sOffsetY = startBtn:GetOffset()
  local _, sExtentY = startBtn:GetExtent()
  local _, mOffsetY = menuWnd:GetOffset()
  local _, mExtentY = menuWnd:GetExtent()
  local _, cExtentY = characterList:GetExtent()
  local offsetY = math.max(10, (sOffsetY - mOffsetY - mExtentY - cExtentY) / 2)
  characterList:AddAnchor("TOPRIGHT", menuWnd, "BOTTOMRIGHT", 10, offsetY)
end
background:SetHandler("OnScale", ReAnchorOnScale)
ReAnchorOnScale()
if X2World:IsPreSelectCharacterPeriod() then
  local preSelectPeriodWnd = CreatePreSelectPeriodWnd("preSelectPeriodWnd", background)
  preSelectPeriodWnd:AddAnchor("TOPLEFT", titleBg, "BOTTOMLEFT", -10, 15)
  preSelectPeriodWnd:Show(true)
end
function serverBtn:OnClick()
  if X2World:LeaveWorld(EXIT_TO_WORLD_LIST) then
    background:Enable(false, true)
  end
end
serverBtn:SetHandler("OnClick", serverBtn.OnClick)
function reviewBtn:OnClick()
  X2LoginCharacter:ReviewMovie()
end
reviewBtn:SetHandler("OnClick", reviewBtn.OnClick)
local function TryToEnterGame(index, skipPrologue)
  X2LoginCharacter:SelectCharacter(index, skipPrologue)
  background:Enable(false, true)
  F_SOUND.PlayUISound("login_stage_start_game")
end
function SelectCharacter(index)
  local charIndex = X2LoginCharacter:GetLastPlayedCharacterIndex()
  local charCount = X2LoginCharacter:GetNumLoginCharacters()
  local remain = GetRemainCreatableCharacterCount()
  local canStart = X2LoginCharacter:IsInEnableStartingLocation(index)
  local requestDelete = X2LoginCharacter:IsDeleteRequestedCharacter(index)
  local requestTransfer = X2LoginCharacter:IsTransferRequestedCharacter(index)
  local forceNameChange = X2LoginCharacter:IsForceNameChangedCharacter(index)
  if index <= charCount then
    if index == charIndex then
      if X2World:IsPreSelectCharacterPeriod() then
        X2LoginCharacter:EditCharacter(index)
        background:Enable(false, true)
      elseif not canStart or forceNameChange or requestDelete or requestTransfer and X2Player:GetFeatureSet().forbidTransferChar then
        return
      elseif X2LoginCharacter:CanShowClientDrivenSkipDialog(index) then
        local function DialogHandler(wnd)
          wnd:SetTitle(X2Locale:LocalizeUiText(MSG_BOX_TITLE_TEXT, "error_message"))
          wnd:SetContent(GetCommonText("client_driven_skip_enable_msg"))
          local OnClick = function()
            X2DialogManager:Delete(DLG_TASK_DEFAULT)
          end
          wnd.titleBar.closeButton:SetHandler("OnClick", OnClick)
          function wnd:OkProc()
            TryToEnterGame(index, true)
          end
          function wnd:CancelProc()
            TryToEnterGame(index, false)
          end
        end
        X2DialogManager:RequestDefaultDialog(DialogHandler, background:GetId())
      else
        TryToEnterGame(index, false)
      end
    else
      ShowCharacter(index, true)
    end
  elseif index <= charCount + remain then
    if X2World:IsPreSelectCharacterPeriod() and not X2World:CanPreSelectCharacter() then
      return
    end
    X2LoginCharacter:CreateCharacter()
    background:Enable(false, true)
  else
    return
  end
end
function startBtn:OnClick()
  local charIndex = X2LoginCharacter:GetLastPlayedCharacterIndex()
  SelectCharacter(charIndex)
end
startBtn:SetHandler("OnClick", startBtn.OnClick)
function ShowCharacter(index, showCharacter)
  if showCharacter == true then
    X2LoginCharacter:ShowSelectedCharacter(index)
  end
  characterList:UpdateList()
  characterInfo:SetCharacterIndex(index)
  local waitingQueue = X2LoginCharacter:GetWorldQueuePosition() > 0
  local canStart = X2LoginCharacter:IsInEnableStartingLocation(index)
  local requestDelete = X2LoginCharacter:IsDeleteRequestedCharacter(index)
  local requestTransfer = X2LoginCharacter:IsTransferRequestedCharacter(index)
  local forceNameChange = X2LoginCharacter:IsForceNameChangedCharacter(index)
  if waitingQueue or not canStart or forceNameChange or requestDelete or requestTransfer and X2Player:GetFeatureSet().forbidTransferChar then
    startBtn:Enable(false)
  else
    startBtn:Enable(true)
  end
end
function background:Refresh()
  characterList:RefreshList()
  local charIndex = X2LoginCharacter:GetLastPlayedCharacterIndex()
  local charCount = X2LoginCharacter:GetNumLoginCharacters()
  if charIndex == nil then
    if charCount > 0 then
      ShowCharacter(1, true)
      charIndex = 1
    else
      startBtn:Enable(false)
    end
  else
    ShowCharacter(charIndex, false)
  end
  accountInfo:Update()
end
background:Refresh()
local freshTime = 0
function background:OnUpdate(dt)
  freshTime = freshTime + dt
  if freshTime > 15000 then
    X2LoginCharacter:RequestCharacterListRefresh(false)
    freshTime = 0
  end
end
background:SetHandler("OnUpdate", background.OnUpdate)
if X2LoginCharacter:GetNumLoginCharacters() == 0 then
  if X2World:ForbidCharCreation() then
    local DialogNoticeHandler = function(dlg)
      dlg:SetTitle(GetCommonText("impossible_to_create_character"))
      dlg:SetContent(GetUIText(LOGIN_CROWDED_TEXT, "no_create_race"))
    end
    X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
  elseif not GetEnableCreateCharacter_worldSelect() then
    local DialogNoticeHandler = function(dlg)
      local data = locale.messageBox.error_to_connect_world
      dlg:SetTitle(GetCommonText("impossible_to_create_character"))
      dlg:SetContent(data.body(FONT_COLOR_HEX.RED))
    end
    X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
  end
end
local eventHandler = {
  SHOW_CHARACTER_SELECT_WINDOW = function(visible)
    background:Show(visible, 300)
  end,
  ACCOUNT_ATTRIBUTE_UPDATED = function()
    accountInfo:Update()
  end,
  RENAME_CHARACTER_FAILED = function(status)
    local function DialogNoticeHandler(wnd)
      local data = locale.messageBox[status]
      wnd:SetTitle(data.title)
      wnd:SetContent(data.body)
      function wnd.OkProc()
        if renameCharIndex ~= nil then
          charButtonList[CalcCharacterButtonIndex(renameCharIndex)].renameBtn:OnClick()
        end
      end
    end
    X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, background:GetId())
  end,
  LOGIN_CHARACTER_UPDATED = function(status, characterIndex)
    if status ~= "refreshed" then
      background:Enable(true, true)
    end
    if status == "error_character_delete_failed" or status == "error_char_name_mismatch" or status == "error_cancel_character_delete_failed" or status == "error_already_requested_character_delete" or status == "error_already_requested_character_transfer" or status == "error_character_connection_restrict" or status == "error_character_expedition_owner" or status == "error_character_faction_owner" or status == "error_character_expedition" or status == "error_character_faction" or status == "cannot_delete_char_while_on_play" or status == "cannot_delete_char_while_penalty" or status == "cannot_delete_char_while_bot_suspected" or status == "cannot_delete_has_comercial_mail_item" then
      local function DialogNoticeHandler(wnd)
        local data = locale.messageBox[status]
        wnd:SetTitle(data.title)
        wnd:SetContent(data.body)
      end
      X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, background:GetId())
    elseif status == "error_delete_represent_char" then
      ShowRepresentCharacterMsg(GetUIText(ERROR_MSG, "delete_represent_character"), true)
    elseif status == "select_fail" then
      local DialogNoticeHandler = function(wnd)
        local titleStr = GetUIText(MSG_BOX_TITLE_TEXT, "error_character_connection_restrict")
        local bodyStr = GetUIText(CHARACTER_CREATE_TEXT, "high_race_congestion_warning")
        wnd:SetTitle(titleStr)
        wnd:SetContent(bodyStr)
      end
      X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, background:GetId())
    end
    background:Refresh()
  end,
  SECOND_PASSWORD_CHECK_COMPLETED = function(success)
    if success then
      return
    end
    local DialogHandler = function(wnd, infoTable)
      wnd:SetTitle(locale.messageBox.secondPasswordConfirmFail.title)
      local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
      wnd:SetContent(locale.messageBox.secondPasswordConfirmFail.body(FONT_COLOR_HEX.RED, curFailCnt, maxFailCnt))
    end
    X2DialogManager:RequestNoticeDialog(DialogHandler, background:GetId())
  end,
  SECOND_PASSWORD_CHECK_OVER_FAILED = function()
    local DialogHandler = function(wnd, infoTable)
      wnd:SetTitle(locale.messageBox.secondPasswordCheckOverFailed.title)
      local curFailCnt, maxFailCnt = X2Security:GetSecondPasswordFailedCount()
      wnd:SetContent(locale.secondPassword.account_lock(maxFailCnt))
    end
    X2DialogManager:RequestNoticeDialog(DialogHandler, background:GetId())
  end,
  SECOND_PASSWORD_ACCOUNT_LOCKED = function()
    local DialogHandler = function(wnd, infoTable)
      local GetSecondPasswordUnlockRemainTime = function()
        local remainDate = X2Security:GetSecondPasswordUnlockRemainTime()
        local msg = locale.time.GetRemainDateToDateFormat(remainDate)
        return locale.secondPassword.lock_state_played(msg)
      end
      wnd:SetTitle(locale.messageBox.second_password_account_locked.title)
      local msg = GetSecondPasswordUnlockRemainTime()
      wnd:SetContent(msg)
    end
    X2DialogManager:RequestNoticeDialog(DialogHandler, background:GetId())
  end,
  OPEN_WORLD_QUEUE = function()
    UpdateQueue()
  end,
  REFRESH_WORLD_QUEUE = function()
    UpdateQueue()
  end,
  REPRESENT_CHARACTER_RESULT = function(isLoginLoad, success, isClearRequest)
    local representCharIndex = X2LoginCharacter:GetRepresentCharacterIndex()
    if isLoginLoad == false then
      local msg
      if success then
        if isClearRequest then
          msg = GetUIText(COMMON_TEXT, "clear_represent_character_success")
        else
          local representCharName = X2Player:GetPremiumItemReceiveCharacterName()
          if representCharName ~= nil then
            msg = GetUIText(COMMON_TEXT, "represent_character_success", representCharName)
          end
        end
      else
        msg = GetUIText(COMMON_TEXT, "represent_character_fail")
      end
      ShowRepresentCharacterMsg(msg)
    end
    characterList:UpdateList()
    characterInfo:UpdateUpperInfo(characterInfo.index)
  end,
  CHANGE_PAY_INFO = function(oldPayMethod, newPayMethod, oldPayLocation, newPayLocation)
    if not X2Player:GetFeatureSet().nexonPcRoom and oldPayLocation ~= newPayLocation and string.find(newPayLocation, "pcbang") == nil then
      local DialogHandler = function(wnd)
        wnd:SetTitle(GetUIText(MSG_BOX_TITLE_TEXT, "error_message"))
        wnd:SetContent(GetUIText(MSG_BOX_BODY_TEXT, "pcbang_advantage_off"))
      end
      X2DialogManager:RequestNoticeDialog(DialogHandler, "")
    end
  end
}
background:SetHandler("OnEvent", function(this, event, ...)
  eventHandler[event](...)
end)
RegistUIEvent(background, eventHandler)
