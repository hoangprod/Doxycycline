function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do
    table.insert(keys, key)
  end
  table.sort(keys, function(a, b)
    return sortFunction(tbl[a], tbl[b])
  end)
  return keys
end
function CreateServerWnd(id)
  local wnd = CreateEmptyWindow(id, "UIParent")
  wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
  wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  wnd:Clickable(false)
  wnd:Show(false)
  local worldListWnd = CreateWorldListWnd("worldListWnd", wnd)
  worldListWnd:AddAnchor("CENTER", wnd, 0, -70)
  worldListWnd:Show(true)
  local versionLabel = worldListWnd:CreateChildWidget("label", "versionLabel", 0, true)
  versionLabel:SetExtent(10, FONT_SIZE.MIDDLE)
  versionLabel:SetAutoResize(true)
  versionLabel:AddAnchor("TOPLEFT", wnd, 10, 10)
  versionLabel:SetText(X2Util:GetVersionInfo())
  ApplyTextColor(versionLabel, F_COLOR.GetColor("version_info"))
  local authMessage = CreateAuthMessageWindow("authMessage", wnd)
  authMessage:AddAnchor("TOPLEFT", versionLabel, "BOTTOMLEFT", 0, 30)
  local tipLabel = worldListWnd:CreateChildWidget("textbox", "tipLabel", 0, true)
  tipLabel:SetExtent(800, 20)
  tipLabel:AddAnchor("BOTTOM", wnd, 0, -10)
  tipLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(tipLabel, F_COLOR.GetColor("text_btn_df"))
  local worldQueue = CreateWorldQueueWindow("queueWindow", wnd)
  worldQueue:Show(false)
  local ZONE_LIST
  local TEMP_DEV_ZONE_LIST = {}
  local TEMP_DEV_ZONE_ID = {}
  if X2Debug:GetDevMode() then
    local zoneCount = X2World:GetZoneCount()
    for i = 1, zoneCount do
      local info = X2World:GetZoneInfo(i)
      TEMP_DEV_ZONE_LIST[i] = string.format("[%03d] %s", info.id, info.name)
      TEMP_DEV_ZONE_ID[i] = info.id
    end
    local cnt = 1
    local sortedKeys = getKeysSortedByValue(TEMP_DEV_ZONE_LIST, function(a, b)
      return a < b
    end)
    local datas = {}
    for _, key in ipairs(sortedKeys) do
      local data = {
        text = TEMP_DEV_ZONE_LIST[key],
        value = TEMP_DEV_ZONE_ID[key]
      }
      table.insert(datas, data)
    end
    ZONE_LIST = W_CTRL.CreateComboBox("ZONE_LIST", wnd)
    ZONE_LIST:SetWidth(300)
    ZONE_LIST:AddAnchor("TOPLEFT", "UIParent", 10, 30)
    ZONE_LIST:AppendItems(datas, false)
    ZONE_LIST:SetVisibleItemCount(10)
    local returnToLogin = wnd:CreateChildWidget("button", "returnToLogin", 0, true)
    ApplyButtonSkin(returnToLogin, BUTTON_BASIC.DEFAULT)
    returnToLogin:AddAnchor("TOPLEFT", wnd, 0, 50)
    returnToLogin:SetText("return login")
    function returnToLogin:OnClick()
      X2:ReturnToLoginStage()
    end
    returnToLogin:SetHandler("OnClick", returnToLogin.OnClick)
  end
  function wnd:UpdateList()
    local worldInfos = GetWorldListInfos()
    independentIndices, legacyIndices = SortWorldListIndices(worldInfos)
    worldListWnd:InsertDataInfo(worldInfos, independentIndices, legacyIndices)
    return worldInfos
  end
  function wnd:OnShow()
    local worldInfos = wnd:UpdateList()
    if #worldInfos == 0 then
      return
    end
    local worldName = X2LoginCharacter:GetLastPlayedWorldInfo()
    if worldName ~= nil then
      for i = 1, #worldInfos do
        if worldName == worldInfos[i].name then
          worldListWnd:SelectByDataKey(worldInfos[i].id)
          break
        end
      end
    end
    local maxWorld = X2World:GetCharactersDefaultLimitPerWorld()
    local maxAccount = X2World:GetCharactersDefaultLimitPerAccount()
    local expandable = X2World:GetCharacterExpandableLimit()
    if expandable > 0 then
      maxWorld = math.min(maxWorld + expandable, MAX_CHARACTER_COUNT)
    end
    tipLabel:SetText(locale.server.max_character_count_warning(maxWorld, maxAccount, expandable))
    tipLabel:SetHeight(tipLabel:GetTextHeight())
  end
  wnd:SetHandler("OnShow", wnd.OnShow)
  function wnd:OnHide()
    worldListWnd:Clear()
    authMessage:Clear()
    tipLabel:SetText("")
    worldQueue:Show(false)
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  function wnd:SelectServer(worldIndex)
    if worldIndex == nil then
      return
    end
    local zoneId
    local defaultZoneStr = Console:GetAttribute("client_default_zone")
    if defaultZoneStr ~= nil then
      zoneId = tonumber(defaultZoneStr)
    end
    if ZONE_LIST ~= nil then
      local info = ZONE_LIST:GetSelectedInfo()
      if info ~= nil then
        zoneId = info.value
      end
    end
    if zoneId == nil then
      zoneId = -1
    end
    F_SOUND.PlayUISound("login_stage_world_select")
    if X2World:EnterWorld(worldIndex, zoneId) == false then
      UIParent:LogAlways(string.format("[Lua ERROR] Enter the World Failed (world id [%s], zone id [%s])", worldIndex, zoneId))
      local DialogNoticeHandler = function(dlg)
        local data = locale.messageBox.error_failed_to_connect_to_server
        dlg:SetTitle(data.title)
        dlg:SetContent(data.body)
      end
      X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
      return
    end
    worldListWnd:Enable(false, true)
  end
  function wnd:RefreshServerList()
    local worldInfos = wnd:UpdateList()
    worldListWnd:Enable(true, true)
    local worldName = X2LoginCharacter:GetLastPlayedWorldInfo()
    if worldName ~= nil then
      for i = 1, #worldInfos do
        if worldName == worldInfos[i].name then
          worldListWnd:SelectByDataKey(worldInfos[i].id)
          break
        end
      end
    end
  end
  function wnd:ReAnchorOnScale()
    wnd:AddAnchor("TOPLEFT", "UIParent", 0, 0)
    wnd:AddAnchor("BOTTOMRIGHT", "UIParent", 0, 0)
  end
  wnd:SetHandler("OnScale", wnd.ReAnchorOnScale)
  function RefreshWorldList()
    wnd:RefreshServerList()
  end
  local worldConnecting = false
  local worldSelectEvents = {
    FADE_INOUT_DONE = function(param)
      if param == "CONNECT_TO_WORLD" then
        X2LoginCharacter:ConnectToWorld()
      end
    end,
    OPEN_WORLD_QUEUE = function()
      if isConnecting then
        return
      end
      worldQueue:Show(true)
      worldQueue:SetInfo(worldListWnd:GetSelectedServerName())
      worldListWnd:Enable(false, true)
    end,
    REFRESH_WORLD_QUEUE = function()
      if isConnecting then
        return
      end
      worldQueue:SetInfo(worldListWnd:GetSelectedServerName())
    end,
    READY_TO_CONNECT_WORLD = function()
      worldQueue:Show(false)
      isConnecting = true
      X2LoginCharacter:ConnectToWorld()
      F_SOUND.PlayUISound("login_stage_ready_to_connect_world")
    end,
    SHOW_SERVER_SELECT_WINDOW = function(visible)
      if visible then
        worldQueue:Show(false)
        wnd:RefreshServerList()
      end
    end,
    ENTER_WORLD_CANCELLED = function()
      wnd:RefreshServerList()
    end,
    DISCONNECT_FROM_AUTH = function()
      if not isConnecting then
        worldQueue:Show(false)
        local DialogNoticeHandler = function(dlg)
          local data = locale.messageBox.error_disconnect_from_auth
          dlg:SetTitle(data.title)
          dlg:SetContent(data.body)
          function dlg:OkProc()
            Console:ExecuteString("quit")
          end
        end
        X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
      end
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    worldSelectEvents[event](...)
  end)
  RegistUIEvent(wnd, worldSelectEvents)
  return wnd
end
