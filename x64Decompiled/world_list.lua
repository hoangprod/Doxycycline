local LABEL_ICON_TYPE = {
  "serverCharacter",
  "serverState",
  "raceCreationImpossibility",
  "integrationInfo"
}
local LABEL_ICON_LONGEST_TEXT_WIDTH = {}
local INSET = 20
local COMMON_WIDTH = INSET * 2
for i = 1, #connectLocale.serverColumn do
  COMMON_WIDTH = COMMON_WIDTH + connectLocale.serverColumn[i]
end
local serverInfoIconStr = {}
for i = 1, #connectLocale.serverInfo do
  local item = connectLocale.serverInfo[i]
  serverInfoIconStr[#serverInfoIconStr + 1] = item.iconStr
end
local IsAvailableWorld = function(data)
  if data.available == WAT_DISABLE then
    return false
  elseif data.entry == WET_REJECTED then
    return false
  elseif X2Util:AND(data.type, WT_PREPARE_FOR_LAUNCH) ~= 0 then
    return false
  elseif X2Util:AND(data.type, WT_CHAR_NAME_PRESELECT) ~= 0 then
    return data.congestion ~= FULL_CONGESTION
  end
  return true
end
local function CreateLabelIcon(id, parent, labelIconType)
  local label = parent:CreateChildWidget("label", id, 0, true)
  local function GetLongestTextWidth(type)
    if LABEL_ICON_LONGEST_TEXT_WIDTH[type] == nil then
      local texts = {
        [LABEL_ICON_TYPE[1]] = {
          GetUIText(COMMON_TEXT, "integration"),
          GetUIText(COMMON_TEXT, "newWorld"),
          GetUIText(COMMON_TEXT, "combatWorld"),
          GetUIText(COMMON_TEXT, "remasterWorld"),
          GetUIText(COMMON_TEXT, "recommendWorld")
        },
        [LABEL_ICON_TYPE[2]] = {
          GetUIText(SERVER_TEXT, "checking"),
          GetUIText(SERVER_TEXT, "popHigh"),
          GetUIText(SERVER_TEXT, "popMiddle"),
          GetUIText(SERVER_TEXT, "popLow"),
          GetUIText(SERVER_TEXT, "prepare_for_launch"),
          GetUIText(SERVER_TEXT, "char_name_preselect")
        },
        [LABEL_ICON_TYPE[3]] = {
          GetUIText(COMMON_TEXT, "race_impossible_nuian"),
          GetUIText(COMMON_TEXT, "race_impossible_dwarf"),
          GetUIText(COMMON_TEXT, "race_impossible_elf"),
          GetUIText(COMMON_TEXT, "race_impossible_hariharan"),
          GetUIText(COMMON_TEXT, "race_impossible_ferre"),
          GetUIText(COMMON_TEXT, "race_impossible_warborn")
        },
        [LABEL_ICON_TYPE[4]] = serverInfoIconStr
      }
      for i = 1, #LABEL_ICON_TYPE do
        local longestWidth = 0
        for j = 1, #texts[LABEL_ICON_TYPE[i]] do
          local width = label.style:GetTextWidth(texts[LABEL_ICON_TYPE[i]][j])
          if longestWidth < width then
            longestWidth = width
          end
        end
        LABEL_ICON_LONGEST_TEXT_WIDTH[LABEL_ICON_TYPE[i]] = longestWidth
      end
    end
    return LABEL_ICON_LONGEST_TEXT_WIDTH[type] + 12
  end
  label:SetExtent(GetLongestTextWidth(labelIconType), 18)
  label.style:SetAlign(ALIGN_CENTER)
  local bg = label:CreateNinePartDrawable(TEXTURE_PATH.SERVER_SELECT, "background")
  bg:AddAnchor("TOPLEFT", label, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", label, 0, 0)
  function label:SetInfo(key, colorKey, text)
    bg:SetTextureInfo(key, colorKey)
    label:SetText(text)
    bg:SetVisible(true)
  end
  function label:Clear()
    bg:SetVisible(false)
    label:SetText("")
  end
  return label
end
local function CreateServerInfo(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(connectLocale.serverInfoExtent.w, connectLocale.serverInfoExtent.h)
  local bg = frame:CreateNinePartDrawable(TEXTURE_PATH.DEFAULT_NEW, "background")
  bg:SetTextureInfo("bg", "black_server_info")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetExtent(10, 40)
  title:AddAnchor("TOPLEFT", frame, MARGIN.WINDOW_SIDE, 0)
  title.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(title, F_COLOR.GetColor("text_btn_df"))
  title:SetText(GetUIText(COMMON_TEXT, "new_world_open_notice"))
  local offset = title:GetHeight()
  local line = CreateLine(frame, "TYPE6")
  line:AddAnchor("TOPLEFT", frame, 0, offset)
  line:AddAnchor("TOPRIGHT", frame, 0, offset)
  local rowHeight = 0
  local function CreateRow(id, key, colorKey, iconStr, mainStr)
    local row = frame:CreateChildWidget("emptywidget", id, 0, true)
    row:SetWidth(frame:GetWidth() - MARGIN.WINDOW_SIDE * 2)
    local labelIcon = CreateLabelIcon(id, row, LABEL_ICON_TYPE[4])
    labelIcon:SetInfo(key, colorKey, iconStr)
    labelIcon:AddAnchor("TOPLEFT", row, 0, 0)
    local offset = 10
    local str = row:CreateChildWidget("textbox", "str", 0, true)
    str:SetExtent(row:GetWidth() - labelIcon:GetWidth() - offset, labelIcon:GetHeight())
    str:SetAutoResize(true)
    str:SetText(mainStr)
    str.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(str, F_COLOR.GetColor("light_gray"))
    if str:GetHeight() < labelIcon:GetHeight() then
      str:AddAnchor("LEFT", labelIcon, "RIGHT", offset, 0)
    else
      str:AddAnchor("TOPLEFT", labelIcon, "TOPRIGHT", offset, 0)
    end
    row:SetHeight(math.max(labelIcon:GetHeight(), str:GetHeight()))
    rowHeight = rowHeight + row:GetHeight() + 10
    return row
  end
  local target = title
  for i = 1, #connectLocale.serverInfo do
    local item = connectLocale.serverInfo[i]
    local row = CreateRow(string.format("row[%d]", i), item.key, item.colorKey, item.iconStr, item.mainStr)
    row:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", 0, 10)
    target = row
  end
  frame:SetHeight(title:GetHeight() + rowHeight + 15)
  return frame
end
local function CreateWorldList(id, parent, index, size, isIndependentWorld)
  local authId = X2World:GetAuthId()
  local widget = W_CTRL.CreateScrollListCtrl(id, parent, index)
  widget:Show(true)
  widget:SetExtent(COMMON_WIDTH - INSET, 345)
  widget:SetUseDoubleClick(true)
  widget:Lock(true)
  local worldTooltip = CreateWorldTooltip("worldTooltip", widget)
  worldTooltip:Show(false)
  local function ServerNameDataSetFunc(subItem, data, setValue)
    if setValue then
      if data.parentId == 0 then
        subItem:SetText(data.name)
      else
        subItem:SetText(string.format("\226\148\148%s", data.name))
      end
      local colorStr = string.format("world_name_%d", data.colorIndex)
      if data.colorIndex == 0 then
        if IsAvailableWorld(data) then
          ApplyTextColor(subItem, F_COLOR.GetColor(colorStr))
        else
          ApplyTextColor(subItem, F_COLOR.GetColor("dark_gray"))
        end
      else
        ApplyTextColor(subItem, F_COLOR.GetColor(colorStr))
      end
      subItem.labelIcon:Show(false)
      subItem.ageIcon:Show(false)
      if X2Util:AND(data.type, WT_REMASTER) ~= 0 and connectLocale.serverIconShow[WT_REMASTER] == true then
        subItem.labelIcon:SetInfo("icon_server", "new", GetUIText(COMMON_TEXT, "remasterWorld"))
        subItem.labelIcon:Show(true)
      elseif X2Util:AND(data.type, WT_RECOMMEND) ~= 0 and connectLocale.serverIconShow[WT_RECOMMEND] == true then
        subItem.labelIcon:SetInfo("icon_server", "recommend", GetUIText(COMMON_TEXT, "recommendWorld"))
        subItem.labelIcon:Show(true)
      elseif X2Util:AND(data.type, WT_NEW) ~= 0 and connectLocale.serverIconShow[WT_NEW] == true then
        subItem.labelIcon:SetInfo("icon_server", "new", GetUIText(COMMON_TEXT, "newWorld"))
        subItem.labelIcon:Show(true)
      elseif X2Util:AND(data.type, WT_LEGACY) ~= 0 and connectLocale.serverIconShow[WT_LEGACY] == true then
        subItem.labelIcon:SetInfo("icon_server", "legacy", GetUIText(COMMON_TEXT, "legacyWorld"))
        subItem.labelIcon:Show(true)
      elseif X2Util:AND(data.type, WT_COMBAT) ~= 0 and connectLocale.serverIconShow[WT_COMBAT] == true then
        subItem.labelIcon:SetInfo("icon_server", "war", GetUIText(COMMON_TEXT, "combatWorld"))
        subItem.labelIcon:Show(true)
      elseif X2Util:AND(data.type, WT_INTEGRATION) ~= 0 and connectLocale.serverIconShow[WT_INTEGRATION] == true then
        local worldIds = GetIntegrationWorldIds()
        for i = 1, #worldIds do
          if worldIds[i] == data.id then
            local str = GetUIText(COMMON_TEXT, "integration")
            if #worldIds > 1 then
              str = string.format("%s %d", str, i)
            end
            subItem.labelIcon:SetInfo("icon_server", "integrated", str)
            subItem.labelIcon:Show(true)
            break
          end
        end
      end
      if X2Util:AND(data.type, WT_RESTRICT_AGE) ~= 0 and connectLocale.serverIconShow[WT_RESTRICT_AGE] == true then
        subItem.ageIcon:SetTextureInfo("icon_15")
        local nameWidth = subItem.style:GetTextWidth(subItem:GetText())
        local left, top, right, bottom = subItem:GetInset()
        subItem.ageIcon:AddAnchor("LEFT", subItem, left + nameWidth + 5, 0)
        subItem.ageIcon:Show(true)
      end
    else
      subItem:SetText("")
      subItem.labelIcon:Show(false)
      subItem.ageIcon:Show(false)
    end
  end
  local CharacterCountSetFunc = function(subItem, data, setValue, item)
    if setValue then
      if data > MAX_CHARACTER_COUNT then
        data = MAX_CHARACTER_COUNT
      end
      for i = 1, MAX_CHARACTER_COUNT do
        local icon = subItem.iconFrame.characerCountIcon[i]
        if i <= data then
          icon:AddAnchor("LEFT", subItem.iconFrame, (i - 1) * 14, 1)
        else
          icon:RemoveAllAnchors()
        end
        icon:SetVisible(i <= data)
      end
      subItem.iconFrame:SetWidth(data * 14)
      subItem.iconFrame:Show(data ~= 0)
    else
      subItem.iconFrame:SetWidth(0)
      subItem.iconFrame:Show(false)
    end
  end
  local CheckRaceCongestionFull = function(congestion)
    for i = 1, #RACE_TYPE do
      if congestion[X2Unit:GetRaceStr(RACE_TYPE[i])] < HIGH_CONGESTION then
        return false
      end
    end
    return true
  end
  local ServerStateSetFunc = function(subItem, data, setValue)
    if setValue then
      if data.available == WAT_DISABLE then
        subItem.labelIcon:SetInfo("icon", "situation_04", GetUIText(SERVER_TEXT, "checking"))
      elseif X2Util:AND(data.type, WT_PREPARE_FOR_LAUNCH) ~= 0 then
        subItem.labelIcon:SetInfo("icon", "situation_05", GetUIText(SERVER_TEXT, "prepare_for_launch"))
      elseif X2Util:AND(data.type, WT_CHAR_NAME_PRESELECT) ~= 0 then
        subItem.labelIcon:SetInfo("icon", "situation_06", GetUIText(SERVER_TEXT, "char_name_preselect"))
      elseif data.congestion == FULL_CONGESTION or data.congestion == HIGH_CONGESTION then
        subItem.labelIcon:SetInfo("icon", "situation_03", GetUIText(SERVER_TEXT, "popHigh"))
      elseif data.congestion == MIDDLE_CONGESTION then
        subItem.labelIcon:SetInfo("icon", "situation_02", GetUIText(SERVER_TEXT, "popMiddle"))
      elseif data.congestion == LOW_CONGESTION then
        subItem.labelIcon:SetInfo("icon", "situation_01", GetUIText(SERVER_TEXT, "popLow"))
      end
    else
      subItem.labelIcon:Clear()
      subItem:SetText("")
    end
  end
  local RaceCreationImpossibilityDataSetFunc = function(subItem, data, setValue)
    if setValue then
      if data == nil then
        subItem.iconFrame:Show(false)
        return
      end
      subItem.iconFrame:Show(true)
      local iconVisibleCount = 1
      for i = 1, #subItem.iconFrame.raceIcon do
        subItem.iconFrame.raceIcon[i]:Show(false)
      end
      local RACE_ICON = {
        [RACE_NUIAN] = GetUIText(COMMON_TEXT, "race_impossible_nuian"),
        [RACE_DWARF] = GetUIText(COMMON_TEXT, "race_impossible_dwarf"),
        [RACE_ELF] = GetUIText(COMMON_TEXT, "race_impossible_elf"),
        [RACE_HARIHARAN] = GetUIText(COMMON_TEXT, "race_impossible_hariharan"),
        [RACE_FERRE] = GetUIText(COMMON_TEXT, "race_impossible_ferre"),
        [RACE_WARBORN] = GetUIText(COMMON_TEXT, "race_impossible_warborn")
      }
      for i = 1, #RACE_TYPE do
        local race = RACE_TYPE[i]
        local str = X2Unit:GetRaceStr(race)
        if data[str] == HIGH_CONGESTION or data[str] == FULL_CONGESTION then
          subItem.iconFrame.raceIcon[iconVisibleCount]:Show(true)
          subItem.iconFrame.raceIcon[iconVisibleCount]:SetInfo("icon", "race", RACE_ICON[race])
          iconVisibleCount = iconVisibleCount + 1
        end
      end
      if iconVisibleCount > 1 then
        subItem.iconFrame:SetWidth((iconVisibleCount - 1) * (subItem.iconFrame.raceIcon[1]:GetWidth() + 2))
      end
    else
      subItem.iconFrame:Show(false)
    end
  end
  local function ServerListTooltipHandler(frame, item, rowIndex)
    local GetRaceCongestionText = function(race, congestion)
      if congestion ~= HIGH_CONGESTION and congestion ~= FULL_CONGESTION then
        return ""
      end
      return string.format("%s%s %s", F_COLOR.GetColor("soft_red", true), locale.raceText[race], locale.server.race_congestion_high)
    end
    function item:OnEnter()
      local data = frame:GetDataByViewIndex(rowIndex, 1)
      if data == nil then
        return
      end
      uiTextKey = string.format("worldDescription_%d_%d", authId, data.id)
      local descriptionStr
      local congestionStr = ""
      if data.available == WAT_ENABLE then
        for i = 1, #RACE_TYPE do
          local race = RACE_TYPE[i]
          local raceName = X2Unit:GetRaceStr(race)
          local congestion = data.raceCongestions[raceName]
          local str = string.format("%s", GetRaceCongestionText(race, congestion))
          if str ~= "" then
            congestionStr = string.format("%s%s\n", congestionStr, str)
          end
        end
      end
      if descriptionStr ~= nil or congestionStr ~= "" then
        local name = data.name
        if connectLocale.combatWorldInfo ~= nil then
          for i = 1, #connectLocale.combatWorldInfo do
            if data.id == connectLocale.combatWorldInfo[i].worldId then
              name = string.format("%s %s(%s)", name, F_COLOR.GetColor("soft_red", true), GetCommonText("combatWorld"))
              break
            end
          end
        end
        local description = ""
        if congestionStr ~= "" then
          if descriptionStr ~= nil then
            description = string.format([[
%s

%s]], descriptionStr, congestionStr)
          else
            description = congestionStr
          end
        else
          description = descriptionStr
        end
        worldTooltip:RemoveAllAnchors()
        worldTooltip:AddAnchor("TOPLEFT", item.subItems[1], "RIGHT", 10, 0)
        worldTooltip:SetInfo(name, description)
      end
    end
    item:SetHandler("OnEnter", item.OnEnter)
    function item:OnLeave()
      if worldTooltip ~= nil then
        worldTooltip:Show(false)
      end
    end
    item:SetHandler("OnLeave", item.OnLeave)
  end
  local function ServerNameLayoutFunc(frame, rowIndex, colIndex, subItem)
    ServerListTooltipHandler(frame, subItem:GetParent(), rowIndex)
    local labelIcon = CreateLabelIcon("labelIcon", subItem, LABEL_ICON_TYPE[1])
    labelIcon:AddAnchor("LEFT", subItem, 0, 0)
    subItem.labelIcon = labelIcon
    local ageIcon = subItem:CreateImageDrawable(TEXTURE_PATH.SERVER_SELECT, "background")
    ageIcon:AddAnchor("LEFT", subItem, 0, 0)
    subItem.ageIcon = ageIcon
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(labelIcon:GetWidth() + 10, 0, 0, 0)
    ApplyTextColor(subItem, F_COLOR.GetColor("light_gray"))
  end
  local function ServerStateLayoutFunc(frame, rowIndex, colIndex, subItem)
    local labelIcon = CreateLabelIcon("serverStateIcon", subItem, LABEL_ICON_TYPE[2])
    labelIcon:AddAnchor("CENTER", subItem, 0, 0)
    subItem.labelIcon = labelIcon
  end
  local CharacterCountLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local iconFrame = subItem:CreateChildWidget("emptywidget", "iconFrame", 0, true)
    iconFrame:Show(false)
    iconFrame:SetExtent(90, 22)
    iconFrame:AddAnchor("CENTER", subItem, 0, 0)
    iconFrame.characerCountIcon = {}
    for i = 1, MAX_CHARACTER_COUNT do
      local characerCountIcon = iconFrame:CreateImageDrawable(TEXTURE_PATH.SERVER_SELECT, "background")
      characerCountIcon:SetTextureInfo("character")
      characerCountIcon:SetVisible(false)
      iconFrame.characerCountIcon[i] = characerCountIcon
    end
  end
  local function RaceCreationImpossibilityLayoutFunc(frame, rowIndex, colIndex, subItem)
    local iconFrame = subItem:CreateChildWidget("emptywidget", "iconFrame", 0, true)
    iconFrame:Show(false)
    iconFrame:SetExtent(90, 21)
    iconFrame:AddAnchor("CENTER", subItem, 0, 0)
    iconFrame.raceIcon = {}
    for i = 1, #RACE_TYPE do
      local raceIcon = CreateLabelIcon(string.format("raceIcon[%s]", X2Unit:GetRaceStr(i)), subItem, LABEL_ICON_TYPE[3])
      raceIcon:Show(false)
      if i == 1 then
        raceIcon:AddAnchor("LEFT", iconFrame, 0, 0)
      else
        raceIcon:AddAnchor("LEFT", iconFrame.raceIcon[i - 1], "RIGHT", 2, 0)
      end
      iconFrame.raceIcon[i] = raceIcon
    end
  end
  if isIndependentWorld then
    widget:InsertColumn(GetUIText(SERVER_TEXT, "name_independent"), connectLocale.serverColumn[1], LCCIT_STRING, ServerNameDataSetFunc, nil, nil, ServerNameLayoutFunc, false)
  else
    widget:InsertColumn(locale.server.name, connectLocale.serverColumn[1], LCCIT_STRING, ServerNameDataSetFunc, nil, nil, ServerNameLayoutFunc, false)
  end
  widget:InsertColumn(locale.server.character, connectLocale.serverColumn[2], LCCIT_WINDOW, CharacterCountSetFunc, nil, nil, CharacterCountLayoutFunc, false)
  widget:InsertColumn(locale.server.pre_select_cant_create, connectLocale.serverColumn[3], LCCIT_WINDOW, RaceCreationImpossibilityDataSetFunc, nil, nil, RaceCreationImpossibilityLayoutFunc, false)
  widget:InsertColumn(locale.server.state, connectLocale.serverColumn[4], LCCIT_WINDOW, ServerStateSetFunc, nil, nil, ServerStateLayoutFunc, false)
  local titleBottomInset = 5
  for i = 1, 4 do
    widget.listCtrl.column[i].curSortFunc = nil
    SetButtonFontColorByKey(widget.listCtrl.column[i], "dark_gray", true)
    widget.listCtrl.column[i].style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
    widget.listCtrl.column[i]:SetInset(0, 0, 0, titleBottomInset)
  end
  local titleBg = widget.listCtrl:CreateNinePartDrawable(TEXTURE_PATH.DEFAULT_NEW, "background")
  titleBg:SetTextureInfo("bg", "black")
  titleBg:AddAnchor("TOPLEFT", widget.listCtrl.column[1], 0, 0)
  titleBg:AddAnchor("BOTTOMRIGHT", widget.listCtrl.column[4], 0, -titleBottomInset + 2)
  function widget:SetRowCount(count)
    local preCount = self:GetRowCount()
    if count > preCount then
      self:InsertRows(count - preCount, false)
    end
  end
  widget:SetRowCount(size)
  widget:SetColumnHeight(25 + titleBottomInset)
  widget.listCtrl:UseOverClickTexture("server_select")
  widget.listCtrl:ChangeSortMartTexture()
  widget.listCtrl:DrawListLine("TYPE6", true, true)
  widget:SetSortMarkOffsetY()
  return widget
end
function CreateWorldListWnd(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local tooltip = CreateInfoTooltip("tooltip", wnd, 0)
  local bg = wnd:CreateNinePartDrawable(TEXTURE_PATH.SERVER_SELECT, "background")
  bg:SetTextureInfo("server_bg")
  bg:AddAnchor("TOPLEFT", wnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetExtent(30, FONT_SIZE.XXLARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", wnd, 0, MARGIN.WINDOW_SIDE)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  title:SetText(GetUIText(COMMON_TEXT, "server_select"))
  ApplyTextColor(title, F_COLOR.GetColor("sky_gray"))
  local refreshBtn = wnd:CreateChildWidget("button", "refreshBtn", 0, true)
  refreshBtn:AddAnchor("LEFT", title, "RIGHT", 10, 1)
  ApplyButtonSkin(refreshBtn, REFRESH_BUTTON)
  function wnd:Clear()
    self.tooltip:Show(false)
    self.selectBtn:Enable(false)
  end
  function refreshBtn:OnEnter()
    tooltip:ClearLines()
    if self:IsEnabled() then
      tooltip:AddLine(locale.server.refresh, "", 0, "left", ALIGN_LEFT, 0)
    else
      tooltip:AddLine(locale.server.refresh_diable, "", 0, "left", ALIGN_LEFT, 0)
    end
    tooltip:AddAnchor("BOTTOMLEFT", self, "TOP", 0, 5)
    tooltip:Show(true)
  end
  refreshBtn:SetHandler("OnEnter", refreshBtn.OnEnter)
  function refreshBtn:OnLeave()
    tooltip:Show(false)
  end
  refreshBtn:SetHandler("OnLeave", refreshBtn.OnLeave)
  function refreshBtn:OnUpdate(dt)
    self.time = dt + self.time
    if self.time > 15000 then
      self:Enable(true)
      self:ReleaseHandler("OnUpdate")
    end
  end
  function refreshBtn:OnClick()
    X2World:RequestWorldListRefresh()
    self:Enable(false)
    self.time = 0
    self:SetHandler("OnUpdate", self.OnUpdate)
  end
  refreshBtn:SetHandler("OnClick", refreshBtn.OnClick)
  local worldTipLabel = wnd:CreateChildWidget("textbox", "worldTipLabel", 0, true)
  worldTipLabel:SetExtent(800, 20)
  worldTipLabel:AddAnchor("BOTTOM", wnd, 0, -95)
  worldTipLabel.style:SetFontSize(FONT_SIZE.LARGE)
  worldTipLabel:SetText(GetUIText(SERVER_TEXT, "independent_world_help"))
  worldTipLabel:SetHeight(worldTipLabel:GetTextHeight())
  worldTipLabel:Show(connectLocale.showWorldTipLabel)
  local selectBtn = wnd:CreateChildWidget("button", "selectBtn", 0, true)
  selectBtn:AddAnchor("BOTTOM", wnd, 0, -MARGIN.WINDOW_SIDE)
  selectBtn:SetText(GetUIText(SERVER_TEXT, "enter"))
  ApplyButtonSkin(selectBtn, BUTTON_STYLE.STAGE)
  selectBtn:Enable(false)
  function selectBtn:OnClick()
    if not GetEnableCreateCharacter_worldSelect() and X2World:GetCharactersCountPerWorld(wnd:GetSelectedDataKey()) == 0 then
      local DialogNoticeHandler = function(dlg)
        local data = locale.messageBox.error_to_connect_world
        dlg:SetTitle(data.title)
        dlg:SetContent(data.body(FONT_COLOR_HEX.RED))
      end
      X2DialogManager:RequestNoticeDialog(DialogNoticeHandler, "")
    else
      parent:SelectServer(wnd:GetSelectedDataKey())
    end
  end
  selectBtn:SetHandler("OnClick", selectBtn.OnClick)
  if 0 < table.getn(connectLocale.serverInfo) then
    local serverInfo = CreateServerInfo("serverInfo", wnd)
    serverInfo:AddAnchor("TOP", wnd, "BOTTOM", connectLocale.serverInfoAnchor.x, connectLocale.serverInfoAnchor.y)
  end
  local worldList = {legacy = nil, independent = nil}
  function wnd:InsertDataInfo(worldInfos, independentIndices, legacyIndices)
    for k, v in pairs(worldList) do
      v:Show(false)
      v:DeleteAllDatas()
    end
    local function MakeLayout(worldInfos, independentIndices, legacyIndices)
      local LEGACY_WORLD_LIST_ROWS = math.min(math.max(#legacyIndices, 8), 15)
      local INDEPENDENT_WORLD_LIST_ROWS = 2
      if #independentIndices ~= 0 then
        LEGACY_WORLD_LIST_ROWS = math.min(math.max(#legacyIndices, 9), 13)
      end
      LAYOUT = {INDEPENDENT_FIRST = 0, LEGACY_FIRST = 1}
      local function MakeWorldList()
        local function CreateWorldListWithFunctions(name, parent, idx, size, isIndependentWorld)
          local list = CreateWorldList(name, parent, idx, size, isIndependentWorld)
          function list:InsertDataInfo(infos, indices, offset)
            local maxRows = self:GetRowCount()
            local cnt = 0
            local insertCnt = 0
            for _, k in ipairs(indices) do
              cnt = cnt + 1
              if offset <= cnt then
                local serverId = infos[k].id
                list:InsertData(serverId, 1, infos[k])
                list:InsertData(serverId, 2, infos[k].chCount)
                list:InsertData(serverId, 3, infos[k].raceCongestions)
                list:InsertData(serverId, 4, infos[k])
                insertCnt = insertCnt + 1
                if maxRows <= insertCnt then
                  return
                end
              end
            end
          end
          function list:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
            if selDataIdx > 0 and selDataIdx <= #self.datas then
              local data = self:GetDataByDataIndex(selDataIdx, 1)
              local characterCount = self:GetDataByDataIndex(selDataIdx, 2)
              local enable = IsAvailableWorld(data)
              selectBtn:Enable(enable)
              wnd:UnselectOtherList(self)
            end
            if selectBtn:IsEnabled() and doubleClick then
              selectBtn:OnClick()
            end
          end
          return list
        end
        local column_heihgt = 30
        local itemHeight = 25
        local line_offsetY = 5
        if worldList.legacy == nil then
          worldList.legacy = CreateWorldListWithFunctions("legacyWorldList", wnd, 1, LEGACY_WORLD_LIST_ROWS, false)
          worldList.legacy:SetHeight(column_heihgt + itemHeight * worldList.legacy:GetRowCount() + line_offsetY)
          worldList.legacy:Show(false)
        end
        if worldList.independent == nil then
          worldList.independent = CreateWorldListWithFunctions("independentWorldList", wnd, 2, INDEPENDENT_WORLD_LIST_ROWS, true)
          worldList.independent:SetHeight(column_heihgt + itemHeight * worldList.independent:GetRowCount() + line_offsetY)
          worldList.independent:Show(false)
        end
      end
      local DecideLayout = function(worldInfos)
        layout = nil
        existIndependence = false
        for i = 1, #worldInfos do
          local info = worldInfos[i]
          if X2Util:AND(info.type, WT_INDEPENDENCE) ~= 0 then
            existIndependence = true
          end
          if info.chCount ~= 0 then
            layout = LAYOUT.LEGACY_FIRST
            break
          end
        end
        if layout == nil then
          if existIndependence then
            layout = LAYOUT.INDEPENDENT_FIRST
          else
            layout = LAYOUT.LEGACY_FIRST
          end
        end
        return layout
      end
      MakeWorldList()
      local layout = DecideLayout(worldInfos)
      local insertInfos = {}
      if layout == LAYOUT.LEGACY_FIRST then
        insertInfos[#insertInfos + 1] = {
          widget = worldList.legacy,
          indices = legacyIndices,
          offset = 1
        }
        if #independentIndices > 0 then
          insertInfos[#insertInfos + 1] = {
            widget = worldList.independent,
            indices = independentIndices,
            offset = 1
          }
        end
      else
        insertInfos[#insertInfos + 1] = {
          widget = worldList.independent,
          indices = independentIndices,
          offset = 1
        }
        if #legacyIndices > 0 then
          insertInfos[#insertInfos + 1] = {
            widget = worldList.legacy,
            indices = legacyIndices,
            offset = 1
          }
        end
      end
      return insertInfos
    end
    local insertInfos = MakeLayout(worldInfos, independentIndices, legacyIndices)
    local sectionMargin = 9
    local heightMargin = 0
    for _, v in pairs(insertInfos) do
      v.widget:InsertDataInfo(worldInfos, v.indices, v.offset)
      v.widget:AddAnchor("TOPLEFT", wnd, 20, 62 + heightMargin)
      v.widget:Show(true)
      heightMargin = heightMargin + v.widget:GetHeight() + sectionMargin
    end
    local defaultMargin = 165 + worldTipLabel:GetHeight()
    wnd:SetExtent(COMMON_WIDTH, defaultMargin + heightMargin)
  end
  function wnd:UnselectOtherList(list)
    for k, v in pairs(worldList) do
      if list ~= v then
        v:ClearSelection()
      end
    end
  end
  function wnd:GetSelectedDataKey()
    for k, v in pairs(worldList) do
      local key = v:GetSelectedDataKey()
      if key ~= nil then
        return key
      end
    end
  end
  function wnd:SelectByDataKey(key)
    for k, v in pairs(worldList) do
      v:SelectByDataKey(key)
    end
  end
  function wnd:GetSelectedServerName()
    local key = self:GetSelectedDataKey()
    local list = GetWorldListInfos()
    local data
    for i = 1, #list do
      if list[i].id == key then
        data = list[i]
        break
      end
    end
    if data == nil then
      return "invalid"
    end
    return data.name
  end
  return wnd
end
