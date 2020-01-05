local channelSelectWndchannelSelectWnd
local CreateIndunChannelSelect = function(id, parent)
  local anchor = WINDOW_INDUN_CHANNEL_SELECT.WINDOW.ANCHOR
  local extent = WINDOW_INDUN_CHANNEL_SELECT.WINDOW.EXTENT
  local text = WINDOW_INDUN_CHANNEL_SELECT.WINDOW.TEXT
  local width, height, fontSize
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(extent[1], extent[2])
  window:AddAnchor("CENTER", parent, anchor[1], anchor[2])
  window:SetTitle(text)
  anchor = WINDOW_INDUN_CHANNEL_SELECT.DUNGEON_TITLE.ANCHOR
  height = WINDOW_INDUN_CHANNEL_SELECT.DUNGEON_TITLE.HEIGHT
  fontSize = WINDOW_INDUN_CHANNEL_SELECT.DUNGEON_TITLE.FONT_SIZE
  local dungeonTitle = window:CreateChildWidget("label", "dungeonTitle", 0, true)
  dungeonTitle:SetAutoResize(true)
  dungeonTitle:SetHeight(height)
  dungeonTitle.style:SetFontSize(fontSize)
  dungeonTitle:AddAnchor("TOP", window, anchor[1], anchor[2])
  ApplyTextColor(dungeonTitle, FONT_COLOR.TITLE)
  width = WINDOW_INDUN_CHANNEL_SELECT.DUNGEON_TITLE_LINE.WIDTH
  anchor = WINDOW_INDUN_CHANNEL_SELECT.DUNGEON_TITLE_LINE.LEFT.ANCHOR
  local line_left, line_right = CreateLine(dungeonTitle, "TYPE2", "overlay")
  line_left:SetWidth(width)
  line_left:AddAnchor("TOP", dungeonTitle, "BOTTOM", anchor[1], anchor[2])
  anchor = WINDOW_INDUN_CHANNEL_SELECT.DUNGEON_TITLE_LINE.RIGHT.ANCHOR
  line_right:SetWidth(width)
  line_right:AddAnchor("LEFT", line_left, "RIGHT", anchor[1], anchor[2])
  extent = WINDOW_INDUN_CHANNEL_SELECT.SCROLL_LISTCTRL.EXTENT
  anchor = WINDOW_INDUN_CHANNEL_SELECT.SCROLL_LISTCTRL.ANCHOR
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", window)
  scrollListCtrl:SetExtent(extent[1], extent[2])
  scrollListCtrl:AddAnchor("TOP", dungeonTitle, "BOTTOM", anchor[1], anchor[2])
  scrollListCtrl:SetUseDoubleClick(true)
  scrollListCtrl.listCtrl:SetColumnHeight(0)
  scrollListCtrl.scroll:RemoveAllAnchors()
  scrollListCtrl.scroll:AddAnchor("TOPRIGHT", scrollListCtrl, 0, 0)
  scrollListCtrl.scroll:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 0, 0)
  scrollListCtrl.listCtrl:UseOverClickTexture()
  local NameSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local PartyDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem.icon:SetVisible(data ~= nil)
    else
      subItem.icon:SetVisible(false)
    end
  end
  local StateDataFunc = function(subItem, data, setValue)
    if setValue then
      if data.current == nil or data.restrict == nil then
        subItem.icon:SetVisible(false)
        return
      end
      subItem.icon:SetVisible(true)
      local value = data.current / data.restrict
      if value <= 0.3 then
        local coords = WINDOW_INDUN_CHANNEL_SELECT.CHANNEL_STATE_COORDS[1]
        subItem.icon:SetCoords(coords[1], coords[2], coords[3], coords[4])
      elseif value <= 0.6 then
        local coords = WINDOW_INDUN_CHANNEL_SELECT.CHANNEL_STATE_COORDS[2]
        subItem.icon:SetCoords(coords[1], coords[2], coords[3], coords[4])
      elseif value <= 0.99 then
        local coords = WINDOW_INDUN_CHANNEL_SELECT.CHANNEL_STATE_COORDS[3]
        subItem.icon:SetCoords(coords[1], coords[2], coords[3], coords[4])
      else
        local coords = WINDOW_INDUN_CHANNEL_SELECT.CHANNEL_STATE_COORDS[4]
        subItem.icon:SetCoords(coords[1], coords[2], coords[3], coords[4])
      end
    else
      subItem.icon:SetVisible(false)
    end
  end
  local NameLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(10, 0, 0, 0)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local PartyLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    local icon = subItem:CreateDrawable(TEXTURE_PATH.INDUN_CHANNEL_SELECT, "party_state", "background")
    icon:SetVisible(false)
    icon:AddAnchor("CENTER", subItem, 0, -1)
    subItem.icon = icon
  end
  local StateLayoutFunc = function(widget, rowIndex, colIndex, subItem)
    local icon = subItem:CreateDrawable(TEXTURE_PATH.INDUN_CHANNEL_SELECT, "icon_up", "background")
    icon:SetVisible(false)
    icon:AddAnchor("CENTER", subItem, 0, -1)
    subItem.icon = icon
  end
  local columnWidth = WINDOW_INDUN_CHANNEL_SELECT.COLUMN_WIDTH
  scrollListCtrl:InsertColumn("", columnWidth[1], LCCIT_STRING, NameSetFunc, nil, nil, NameLayoutFunc)
  scrollListCtrl:InsertColumn("", columnWidth[2], LCCIT_WINDOW, PartyDataFunc, nil, nil, PartyLayoutFunc)
  scrollListCtrl:InsertColumn("", columnWidth[3], LCCIT_WINDOW, StateDataFunc, nil, nil, StateLayoutFunc)
  scrollListCtrl:InsertRows(10, false)
  for i = 1, #scrollListCtrl.listCtrl.items do
    local item = scrollListCtrl.listCtrl.items[i]
    local line = CreateLine(scrollListCtrl, "TYPE1")
    line:AddAnchor("BOTTOMLEFT", item, 0, 0)
    line:AddAnchor("BOTTOMRIGHT", item, 0, 0)
  end
  local info = {
    leftButtonStr = WINDOW_INDUN_CHANNEL_SELECT.BOTTOM_BUTTON_STR.LEFT,
    rightButtonStr = WINDOW_INDUN_CHANNEL_SELECT.BOTTOM_BUTTON_STR.RIGHT,
    leftButtonLeftClickFunc = function()
      local instId = window.scrollListCtrl:GetSelectedDataKey()
      X2:EnterSystemDungeon(instId)
    end,
    rightButtonLeftClickFunc = function()
      X2:SystemDungeonStateClear()
    end
  }
  CreateWindowDefaultTextButtonSet(window, info)
  local GetTestDungeonStateInfo = function()
    local infos = {}
    for i = 1, 10 do
      infos[i] = {}
      infos[i].channel_name = string.format("%s - %d", GetCommonText("dimension"), i)
      infos[i].instance_id = i
      infos[i].members = math.random(1, 10)
      infos[i].current = math.random(1, 10)
      infos[i].restrict = math.random(1, 10)
    end
    return infos
  end
  function window:FillData()
    self.scrollListCtrl:DeleteAllDatas()
    self.leftButton:Enable(false)
    local infos = X2:GetSystemDungeonStateInfo()
    if infos == nil then
      return
    end
    for i = 1, #infos do
      local stateInfo = {
        current = infos[i].current,
        restrict = infos[i].restrict
      }
      self.scrollListCtrl:InsertData(infos[i].instance_id, 1, infos[i].channel_name)
      self.scrollListCtrl:InsertData(infos[i].instance_id, 2, infos[i].members)
      self.scrollListCtrl:InsertData(infos[i].instance_id, 3, stateInfo)
    end
    local indunName = X2:GetSystemDungeonName()
    self.dungeonTitle:SetText(indunName)
  end
  function window.scrollListCtrl:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    if selDataIdx == 0 or selDataIdx > #self.datas then
      window.leftButton:Enable(false)
      return
    end
    window.leftButton:Enable(true)
    if window.leftButton:IsEnabled() and doubleClick then
      info.leftButtonLeftClickFunc()
    end
  end
  local OnClick = function()
    X2:SystemDungeonStateClear()
  end
  window.titleBar.closeButton:SetHandler("OnClick", OnClick)
  local events = {
    INTERACTION_END = function()
      window:Show(false)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local function ShowIndunChannelSelectWnd()
  if channelSelectWnd == nil then
    channelSelectWnd = CreateIndunChannelSelect("channelSelectWnd", "UIParent")
  end
  channelSelectWnd:Show(true)
  channelSelectWnd:FillData()
end
UIParent:SetEventHandler("SYS_INDUN_STAT_UPDATED", ShowIndunChannelSelectWnd)
