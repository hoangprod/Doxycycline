local CreateDeathAndResurrectionWindow = function(id)
  local MESSAGE_BOX_HEIGHT = 200
  local TEXT_BOX_HEIGHT = 60
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow(id, "UIParent")
  wnd:Show(false)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, MESSAGE_BOX_HEIGHT)
  wnd:AddAnchor("CENTER", "UIParent", 0, -150)
  wnd:SetUILayer("dialog")
  wnd.titleBar.closeButton:Show(false)
  wnd:SetTitle(locale.graveyard.title)
  local btnResurrection = wnd:CreateChildWidget("button", "btnResurrection", 0, true)
  local btnGraveyard = wnd:CreateChildWidget("button", "btnGraveyard", 0, true)
  local textBox = wnd:CreateChildWidget("textbox", "textBox", 0, true)
  textBox:Show(true)
  textBox:AddAnchor("TOP", wnd, 0, titleMargin + sideMargin / 2)
  textBox:SetExtent(300, TEXT_BOX_HEIGHT)
  textBox.style:SetAlign(ALIGN_CENTER)
  textBox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(textBox, FONT_COLOR.RED)
  local bg = textBox:CreateDrawable(TEXTURE_PATH.DEATH, "death", "background")
  bg:AddAnchor("CENTER", textBox, 0, 0)
  bg:SetColor(1, 1, 1, 0.7)
  local additionalTextbox = wnd:CreateChildWidget("textbox", "additionalTextbox", 0, true)
  additionalTextbox:Show(false)
  additionalTextbox:AddAnchor("TOP", textBox, "BOTTOM", 0, sideMargin / 2.5)
  additionalTextbox:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  additionalTextbox:SetExtent(300, TEXT_BOX_HEIGHT)
  additionalTextbox.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(additionalTextbox, FONT_COLOR.GRAY)
  wnd:SetWindowModal(false)
  wnd:SetCloseOnEscape(false)
  wnd.titleBar.closeButton:Enable(false)
  local STATE = {DEATH = 1, RESURRECTION = 2}
  local function ResizeWnd(wnd)
    wnd.additionalTextbox:SetExtent(300, wnd.additionalTextbox:GetTextHeight())
    local calcWndHeight = MESSAGE_BOX_HEIGHT
    if wnd.additionalTextbox:IsVisible() then
      calcWndHeight = calcWndHeight + wnd.additionalTextbox:GetTextHeight() + sideMargin / 2
    end
    wnd:SetExtent(POPUP_WINDOW_WIDTH, calcWndHeight)
  end
  local GetGraveyardBtnText = function()
    if X2BattleField:IsInInstantGame() then
      return locale.graveyard.revive_battle_field
    elseif X2Dominion:IsInSiegeTeam() then
      return locale.graveyard.revive_siege
    elseif X2Player:IsInIndunWithGraveyard() then
      return locale.graveyard.revive_indun
    elseif X2:IsInClientDrivenZone() == true then
      return GetCommonText("grave_yard_instant_resurrection")
    end
    return locale.graveyard.revive
  end
  local GetDeadMessage = function()
    if X2BattleField:IsInInstantGame() then
      return locale.graveyard.dead_battle_field_wnd_msg
    elseif X2Dominion:IsInSiegeTeam() then
      return locale.graveyard.dead_siege_wnd_msg
    elseif X2Player:IsInIndunWithGraveyard() then
      return locale.graveyard.dead_indun_wnd_msg
    elseif X2:IsInClientDrivenZone() == true then
      return locale.graveyard.dead_battle_field_wnd_msg
    end
    return locale.graveyard.dead_wnd_msg
  end
  local function ProcResurrectionBtn(btnRes, state)
    local inPlaceRemainCnt = X2Player:GetResurrectionInPlaceInfo()
    if state == STATE.DEATH then
      if X2Player:GetFeatureSet().freeResurrectionInPlace == true then
        if X2Unit:IsInResurrectPeaceArea() then
          return
        end
        if X2:IsInClientDrivenZone() then
          return
        end
        if X2BattleField:IsInInstantGame() then
          return
        end
        if X2Dominion:IsInSiegeTeam() then
          return
        end
        local myLevel = X2Unit:UnitLevel("player")
        if myLevel < 10 then
          if X2Faction:IsProtectedZone() then
            btnRes:Show(true)
          end
        else
          btnRes:Show(true)
        end
      elseif X2Player:GetFeatureSet().freeResurrectionInPlace == false and inPlaceRemainCnt ~= 0 then
        btnRes:Show(true)
      end
    elseif state == STATE.RESURRECTION then
      btnRes:Show(true)
    end
  end
  local function UpdateButtonState(wnd, state, btnResText)
    local btnRes = wnd.btnResurrection
    local btnGrv = wnd.btnGraveyard
    btnRes:SetText(btnResText)
    btnGrv:SetText(GetGraveyardBtnText())
    btnRes:RemoveAllAnchors()
    btnRes:Show(false)
    ApplyButtonSkin(btnRes, BUTTON_BASIC.DEFAULT)
    btnGrv:RemoveAllAnchors()
    btnGrv:Show(true)
    ApplyButtonSkin(btnGrv, BUTTON_BASIC.DEFAULT)
    ProcResurrectionBtn(btnRes, state)
    if btnRes:IsVisible() and btnGrv:IsVisible() then
      local buttonTable = {btnRes, btnGrv}
      local maxWidth = AdjustBtnLongestTextWidth(buttonTable)
      local offset = maxWidth / 2
      btnRes:AddAnchor("BOTTOM", wnd, -offset, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
      btnGrv:AddAnchor("BOTTOM", wnd, offset, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    else
      btnRes:AddAnchor("BOTTOM", wnd, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
      btnGrv:AddAnchor("BOTTOM", wnd, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    end
  end
  local GetContent = function(countdown, resurrectionWaitingTime, message)
    local FormatTime = function(sec)
      return string.format("%d%s", math.max(sec, 0), locale.tooltip.second)
    end
    if resurrectionWaitingTime > 0 then
      local remainTime = string.format("%s|r", FormatTime(resurrectionWaitingTime))
      local str = string.format([[
%s
%s]], locale.graveyard.dead_msg, locale.graveyard.GetResurrectionWaitingMsg(remainTime))
      return str
    end
    local remainTime = string.format("%s|r", FormatTime(countdown))
    local content = string.format([[
%s
%s %s]], locale.graveyard.dead_msg, remainTime, message)
    return content
  end
  local function UpdateContentsAndBtnState(wnd)
    local countdown, resurrectionWaitingTime, isMaxLevel = X2Player:GetResurrectionTimeInfo()
    if countdown <= 0 then
      wnd:ReleaseHandler("OnUpdate")
      X2Player:Resurrect(false)
    end
    local btnEnable = resurrectionWaitingTime <= 0 and true or false
    wnd.btnGraveyard:Enable(btnEnable)
    if isMaxLevel == true then
      wnd.btnResurrection:Show(false)
      wnd.btnResurrection:AddAnchor("BOTTOM", wnd, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
      wnd.btnGraveyard:AddAnchor("BOTTOM", wnd, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    else
      wnd.btnResurrection:Enable(btnEnable)
    end
    if wnd.updateAdditionalMsgVisibleState then
      wnd.additionalTextbox:Show(btnEnable)
      ResizeWnd(wnd)
    end
    local content = GetContent(countdown, resurrectionWaitingTime, GetDeadMessage())
    wnd.textBox:SetText(content)
  end
  local function SetEventHandlers(wnd)
    wnd:ReleaseHandler("OnUpdate")
    wnd.btnGraveyard:ReleaseHandler("OnClick")
    wnd.btnResurrection:ReleaseHandler("OnClick")
    wnd.btnResurrection:ReleaseHandler("OnEnter")
    local UseResurrectionItemDialogHandler = function(wnd)
      local _, inPlaceMaxCnt, resurrectionItem = X2Player:GetResurrectionInPlaceInfo()
      wnd:SetTitle(GetUIText(GRAVE_YARD_TEXT, "inplace_resurrection"))
      wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "need_item_msg_for_resurrection"))
      local data = {
        itemInfo = X2Item:GetItemInfoByType(resurrectionItem),
        stack = {
          X2Bag:CountBagItemByItemType(resurrectionItem),
          1
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
      function wnd:OkProc()
        X2Player:Resurrect(true)
      end
    end
    local function OnResurrection()
      if X2Player:GetFeatureSet().freeResurrectionInPlace == true then
        local inPlaceRemainCnt = X2Player:GetResurrectionInPlaceInfo()
        if inPlaceRemainCnt == 0 then
          X2DialogManager:RequestDefaultDialog(UseResurrectionItemDialogHandler, wnd:GetId())
        else
          X2Player:Resurrect(true)
        end
      else
        X2Player:Resurrect(true)
      end
    end
    wnd.btnResurrection:SetHandler("OnClick", function(_, arg)
      if arg == "LeftButton" then
        OnResurrection()
      end
    end)
    local OnGraveyard = function()
      X2Player:Resurrect(false)
    end
    wnd.btnGraveyard:SetHandler("OnClick", function(_, arg)
      if arg == "LeftButton" then
        OnGraveyard()
      end
    end)
    local inPlaceRemainCnt, inPlaceMaxCnt = X2Player:GetResurrectionInPlaceInfo()
    if X2Player:GetFeatureSet().freeResurrectionInPlace == true and inPlaceRemainCnt >= 0 then
      local function OnEnter(self)
        SetTooltip(GetCommonText("inplace_resurrection_tooltip", inPlaceMaxCnt, inPlaceMaxCnt + 1), self)
      end
      wnd.btnResurrection:SetHandler("OnEnter", OnEnter)
    end
    local function OnUpdate(_, dt)
      UpdateContentsAndBtnState(wnd)
    end
    wnd:SetHandler("OnUpdate", OnUpdate)
  end
  local function ProcShowWindow(wnd, windowMode, btnResText)
    UpdateButtonState(wnd, windowMode, btnResText)
    SetEventHandlers(wnd)
    ResizeWnd(wnd)
    wnd:Show(true)
  end
  local GetPenaltyText = function(lostExpStr, durabilityLossRatio)
    if X2:IsInClientDrivenZone() == true then
      return ""
    end
    lostExpStr = lostExpStr or "0"
    durabilityLossRatio = durabilityLossRatio or 0
    local lostExpMsg = ""
    local lineBreak = ""
    local expRecoverGuide = ""
    if X2Unit:UnitLevel("player") < 10 then
      lostExpMsg = locale.graveyard.notDecreaseExp
      lineBreak = "\n"
    elseif lostExpStr ~= 0 then
      lostExpMsg = locale.graveyard.GetLostExp(string.format("|,%s;", lostExpStr))
      lineBreak = "\n"
      expRecoverGuide = string.format([[


%s]], locale.graveyard.expRecoverGuide)
    end
    local durabilityLossRatioMsg = ""
    if durabilityLossRatio ~= 0 then
      durabilityLossRatioMsg = locale.graveyard.GetDurabilityLossRatio(durabilityLossRatio)
    else
      durabilityLossRatioMsg = ""
      lineBreak = ""
    end
    return string.format("%s%s%s%s", lostExpMsg, lineBreak, durabilityLossRatioMsg, expRecoverGuide)
  end
  function wnd:ShowDeathMode(lostExpStr, durabilityLossRatio)
    local inPlaceRemainCnt, inPlaceMaxCnt = X2Player:GetResurrectionInPlaceInfo()
    local btnResText = GetUIText(GRAVE_YARD_TEXT, "inplace_resurrection")
    if inPlaceRemainCnt >= 0 then
      btnResText = string.format("%s (%d/%d)", btnResText, inPlaceRemainCnt, inPlaceMaxCnt)
    end
    wnd.updateAdditionalMsgVisibleState = true
    wnd.additionalTextbox:SetText(GetPenaltyText(lostExpStr, durabilityLossRatio))
    ProcShowWindow(wnd, STATE.DEATH, btnResText)
  end
  function wnd:ShowResurrectionMode(stringId)
    local btnResText = locale.graveyard.graceRevive
    local resurrectionMessage = ""
    local playerId = X2Unit:GetUnitId("player")
    local playerLv = X2Unit:UnitLevel("player")
    stringId = stringId or ""
    if stringId ~= playerId then
      btnResText = locale.questContext.ok
      local name = X2Unit:GetUnitNameById(stringId)
      if playerLv < 10 then
        resurrectionMessage = GetUIText(COMMON_TEXT, "revive_msg_beginner", FONT_COLOR_HEX.BLUE, name, FONT_COLOR_HEX.GRAY)
      else
        resurrectionMessage = GetUIText(GRAVE_YARD_TEXT, "revive_wnd_msg", FONT_COLOR_HEX.BLUE, name, FONT_COLOR_HEX.GRAY)
      end
    end
    wnd.additionalTextbox:Show(true)
    wnd.updateAdditionalMsgVisibleState = false
    wnd.additionalTextbox:SetText(resurrectionMessage)
    ProcShowWindow(wnd, STATE.RESURRECTION, btnResText)
  end
  return wnd
end
local deathAndResurrectionWnd = CreateDeathAndResurrectionWindow("deathAndResurrectionWindow")
ADDON:RegisterContentWidget(UIC_DEATH_AND_RESURRECTION_WND, deathAndResurrectionWnd)
local events = {
  ENTERED_WORLD = function()
    if X2Unit:UnitIsDead("player") == true then
      deathAndResurrectionWnd:ShowDeathMode(0, 0)
    end
  end,
  LEFT_LOADING = function()
    if X2Unit:UnitIsDead("player") == true then
      deathAndResurrectionWnd:ShowDeathMode(0, 0)
    end
  end,
  UNIT_DEAD = function(stringId, lostExpStr, durabilityLossRatio)
    local name = X2Unit:GetUnitNameById(stringId)
    local notifyMsg = locale.graveyard.GetDeathMessage(name)
    X2Chat:DispatchChatMessage(CMF_COMBAT_DEAD, notifyMsg)
    local playerId = X2Unit:GetUnitId("player")
    if stringId ~= playerId then
      return
    end
    deathAndResurrectionWnd:ShowDeathMode(lostExpStr, durabilityLossRatio)
  end,
  PLAYER_RESURRECTION = function(stringId)
    deathAndResurrectionWnd:ShowResurrectionMode(stringId)
  end,
  PLAYER_RESURRECTED = function()
    deathAndResurrectionWnd:Show(false)
  end
}
deathAndResurrectionWnd:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(deathAndResurrectionWnd, events)
local helperWnd = UIParent:CreateWidget("emptywidget", "deathAndResurrectionWindow_helper", "UIParent")
helperWnd:Show(true)
helperWnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
helperWnd:SetExtent(0, 0)
local accTime = 0
local CHECK_INTERVAL = 5000
local function OnUpdate(_, dt)
  accTime = accTime + dt
  if accTime < CHECK_INTERVAL then
    return
  end
  accTime = 0
  if deathAndResurrectionWnd:IsVisible() == true then
    return
  end
  if X2Unit:UnitIsDead("player") == true then
    deathAndResurrectionWnd:ShowDeathMode(0, 0)
  end
end
helperWnd:SetHandler("OnUpdate", OnUpdate)
