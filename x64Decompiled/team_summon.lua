local summonWnd
function ShowTeamSummon(parent)
  if summonWnd == nil then
    summonWnd = SetViewOfTeamSummon("teamSummon", parent)
    summonWnd:Show(false)
    summonWnd.charName = nil
    function summonWnd:ShowProc()
      self.charName = {}
      local itemType, need, has = X2Team:GetSummonItem()
      local summonLimit = MAX_COMMUNITY_SUMMON
      local itemName = X2Item:Name(itemType)
      local info = X2Item:GetItemInfoByType(itemType)
      info.lifeSpanType = nil
      self.itemIcon:SetItemInfo(info)
      self.itemIcon:SetStack(has, need)
      if has < need then
        summonWnd.itemIcon:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.RED)
      end
    end
    local function LeftButtonClickFunc()
      X2Team:RequestSummon()
      summonWnd:Show(false)
    end
    ButtonOnClickHandler(summonWnd.leftButton, LeftButtonClickFunc)
    local function RightButtonClickFunc()
      summonWnd:Show(false)
    end
    ButtonOnClickHandler(summonWnd.rightButton, RightButtonClickFunc)
  end
  summonWnd:Show(true)
  return summonWnd
end
local summonSuggestWnd
function ShowTeamSummonSuggest(param)
  if summonSuggestWnd == nil then
    summonSuggestWnd = SetViewOfTeamSummonSuggest("teamSummonSuggest", "UIParent")
    summonSuggestWnd:Show(false)
    function summonSuggestWnd.mapBtn:OnClick()
      worldmap:ToggleMapWithPortal(summonSuggestWnd.zoneId, summonSuggestWnd.x, summonSuggestWnd.y, summonSuggestWnd.z)
    end
    summonSuggestWnd.mapBtn:SetHandler("OnClick", summonSuggestWnd.mapBtn.OnClick)
    local function LeftButtonClickFunc()
      if X2Player:PlayerInCombat() == true then
        AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "IMPOSSIBLE_COMBAT_STATE"))
        return
      end
      summonSuggestWnd.result = true
      summonSuggestWnd:Show(false)
    end
    ButtonOnClickHandler(summonSuggestWnd.leftButton, LeftButtonClickFunc)
    local function RightButtonClickFunc()
      summonSuggestWnd:Show(false)
    end
    ButtonOnClickHandler(summonSuggestWnd.rightButton, RightButtonClickFunc)
    function summonSuggestWnd.checkBtn:OnCheckChanged()
      X2Team:RequestSummonNotRecv(self:GetChecked())
    end
    summonSuggestWnd.checkBtn:SetHandler("OnCheckChanged", summonSuggestWnd.checkBtn.OnCheckChanged)
    function OnUpdate(self, dt)
      summonSuggestWnd.showTime = summonSuggestWnd.showTime - dt
      if summonSuggestWnd.showTime < 0 then
        summonSuggestWnd:Show(false)
      end
      summonSuggestWnd.remainTime:SetText(GetCommonText("remain_time", FormatTime(summonSuggestWnd.showTime, false)))
    end
    summonSuggestWnd:SetHandler("OnUpdate", OnUpdate)
    function summonSuggestWnd:OnHide()
      X2Team:RequestSummonReply(summonSuggestWnd.result, summonSuggestWnd.name)
    end
    summonSuggestWnd:SetHandler("OnHide", summonSuggestWnd.OnHide)
  end
  summonSuggestWnd.result = false
  summonSuggestWnd.showTime = 60000
  summonSuggestWnd.name = param[1]
  summonSuggestWnd.summoner:SetText(string.format("%s: %s%s", GetCommonText("expedition_summoner"), FONT_COLOR_HEX.BLUE, summonSuggestWnd.name))
  summonSuggestWnd.locationLabel:SetText(GetConvertingPosString(true, param[2]))
  summonSuggestWnd.zoneId = param[3]
  summonSuggestWnd.x = param[4]
  summonSuggestWnd.y = param[5]
  summonSuggestWnd.z = param[6]
  summonSuggestWnd:Show(true)
end
UIParent:SetEventHandler("TEAM_SUMMON_SUGGEST", ShowTeamSummonSuggest)
