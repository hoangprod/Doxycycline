local summonWnd
function ShowExpeditionSummon(parent)
  if summonWnd == nil then
    local expedMgrWnd = parent:GetParent():GetParent()
    summonWnd = SetViewOfExpeditionSummon("expeditionSummon", expedMgrWnd)
    summonWnd:Show(false)
    summonWnd.charName = nil
    function summonWnd:ShowProc()
      self.charName = {}
      local itemType, need, has = X2Faction:GetExpeditionSummonItem()
      local summonLimit = X2Faction:GetExpeditionSummonLimit()
      local itemName = X2Item:Name(itemType)
      local info = X2Item:GetItemInfoByType(itemType)
      self.itemIcon:SetItemInfo(info)
      self.itemIcon:SetStack(has, need)
      if has < need then
        summonWnd.itemIcon:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.RED)
      end
      local memberWnd = GetExpeditionTabWindow(EXPEDITION_TAB_MENU_IDX.MEMBERS)
      local memberFrame = memberWnd.frame
      local count = 1
      for i = 1, memberFrame:GetDataCount() do
        local data = memberFrame:GetDataByDataIndex(i, 1)
        if data[EXPEDITION_MEMBER_COL.ONLINE] and data[EXPEDITION_MEMBER_COL.CHK] then
          self.charName[count] = data[EXPEDITION_MEMBER_COL.NAME]
          count = count + 1
          if summonLimit < count then
            break
          end
        end
      end
      self.tryCount:SetText(string.format("%s: %s%d/%d", GetCommonText("try_member_count"), FONT_COLOR_HEX.BLUE, #self.charName, summonLimit))
    end
    local function LeftButtonClickFunc()
      if #summonWnd.charName == 0 then
        summonWnd:Show(false)
        return
      end
      X2Faction:RequestExpeditionSummon(#summonWnd.charName, summonWnd.charName)
      summonWnd:Show(false)
      ToggleCommunityWindow(false)
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
function ShowExpeditionSummonSuggest(param)
  if summonSuggestWnd == nil then
    summonSuggestWnd = SetViewOfExpeditionSummonSuggest("expeditionSummonSuggest", "UIParent")
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
      X2Faction:RequestExpeditionSummonNotRecv(self:GetChecked())
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
      X2Faction:RequestExpeditionSummonReply(summonSuggestWnd.result, summonSuggestWnd.name)
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
UIParent:SetEventHandler("EXPEDITION_SUMMON_SUGGEST", ShowExpeditionSummonSuggest)
