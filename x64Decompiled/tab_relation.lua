local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local MAX_ROW = 4
local CreateNationList = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  local sliderList = W_CTRL.CreateScrollListBox("sliderList", frame, parent)
  sliderList:AddAnchor("TOPLEFT", frame, 0, 0)
  sliderList:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  sliderList.content.itemStyle:SetFontSize(FONT_SIZE.LARGE)
  sliderList.content:SetTextLimit(10)
  frame.sliderList = sliderList
  frame.NationFactionIds = {}
  function frame:Init(list)
    self.sliderList.content:ClearItem()
    self.NationFactionIds = {}
    local nationList = X2Nation:GetNationList()
    if nationList == nil then
      self:SetMinMaxValues(0, 0)
      return
    end
    for i = 1, #nationList do
      if nationList[i].powerSuperior then
        self.sliderList:AppendItemTailIcon(nationList[i].name, nationList[i].factionId, "ui/nation/icon_peace.dds", "icon_blue")
      elseif nationList[i].powerInferior then
        self.sliderList:AppendItemTailIcon(nationList[i].name, nationList[i].factionId, "ui/nation/icon_peace.dds", "icon_red")
      else
        self.sliderList:AppendItem(nationList[i].name, nationList[i].factionId)
      end
      self.NationFactionIds[i] = nationList[i].factionId
    end
    self.sliderList.content:Select(0)
  end
end
local function CreateRelationNationList(id, parent, isFrendly)
  local width = parent:GetWidth()
  local listFrame = parent:CreateChildWidget("emptywidget", id, 0, true)
  listFrame:SetExtent(width, 135)
  local bg = CreateContentBackground(listFrame, "TYPE2", "brown")
  bg:AddAnchor("TOPLEFT", listFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", listFrame, 0, 0)
  local relationListCtrl = W_CTRL.CreateScrollListCtrl("relationListCtrl", listFrame)
  relationListCtrl:SetExtent(width - 5, 120)
  relationListCtrl:AddAnchor("TOPLEFT", listFrame, 0, 0)
  local LayoutHostileFunc = function(frame, rowIndex, colIndex, subItem)
    local nameLabel = subItem:CreateChildWidget("label", "nameLabel", 0, true)
    nameLabel:SetAutoResize(true)
    nameLabel:SetHeight(FONT_SIZE.MIDDLE)
    nameLabel:AddAnchor("LEFT", subItem, 0, 0)
    nameLabel:SetInset(15, 0, 0, 0)
    nameLabel.style:SetAlign(ALIGN_LEFT)
    nameLabel:Show(true)
    ApplyTextColor(nameLabel, FONT_COLOR.RED)
    local diplomacyImage = subItem:CreateDrawable("ui/nation/icon_peace.dds", "icon_peace", "overlay")
    diplomacyImage:SetVisible(false)
    diplomacyImage:AddAnchor("LEFT", nameLabel, "RIGHT", 10, 0)
    subItem.diplomacyImage = diplomacyImage
  end
  local LayoutFriendFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetInset(15, 0, 15, 0)
    subItem:SetLimitWidth(true)
    subItem:SetHeight(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.BLUE)
  end
  local LayoutRemaindTimeFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:SetInset(15, 0, 15, 0)
    subItem:SetLimitWidth(true)
    subItem:SetHeight(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subItem, FONT_COLOR.BLUE)
  end
  local SetHostileDataFunc = function(subItem, data, setValue)
    if subItem.diplomacyImage ~= nil then
      subItem.diplomacyImage:SetVisible(false)
    end
    if setValue then
      subItem.nameLabel:SetText(data.name)
      if subItem.diplomacyImage ~= nil and data.target == true then
        subItem.diplomacyImage:SetVisible(true)
      end
    else
      subItem.nameLabel:SetText("")
    end
  end
  local SetFriendDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.name)
    else
      subItem:SetText("")
    end
  end
  local SetRemainTimeDataFunc = function(subItem, data, setValue)
    if setValue then
      local period = ""
      if data.period == nil then
        period = X2Locale:LocalizeUiText(NATION_TEXT, "out_period")
      else
        period = locale.time.GetRemainDateToDateFormat(data.period)
      end
      subItem:SetText(period)
    else
      subItem:SetText("")
    end
  end
  local targetWidth = relationListCtrl.listCtrl:GetWidth()
  if isFrendly then
    relationListCtrl:InsertColumn(GetCommonText("faction_relation_changed_target"), targetWidth * 0.4, LCCIT_STRING, SetFriendDataFunc, nil, nil, LayoutFriendFunc)
    relationListCtrl:InsertColumn(locale.nationMgr.remain_period, targetWidth * 0.6, LCCIT_STRING, SetRemainTimeDataFunc, nil, nil, LayoutRemaindTimeFunc)
  else
    relationListCtrl:InsertColumn(locale.nationMgr.hostileNation, targetWidth, LCCIT_WINDOW, SetHostileDataFunc, nil, nil, LayoutHostileFunc)
  end
  relationListCtrl:InsertRows(MAX_ROW, false)
  relationListCtrl.listCtrl:UseOverClickTexture()
  for i = 1, #relationListCtrl.listCtrl.column do
    relationListCtrl.listCtrl.column[i]:Enable(false)
    SettingListColumn(relationListCtrl.listCtrl, relationListCtrl.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(relationListCtrl.listCtrl.column[i], #relationListCtrl.listCtrl.column, i)
  end
  local underLine = CreateLine(relationListCtrl, "TYPE1")
  underLine:AddAnchor("TOPLEFT", relationListCtrl.listCtrl, -sideMargin / 2, LIST_COLUMN_HEIGHT - 2)
  underLine:AddAnchor("TOPRIGHT", relationListCtrl.listCtrl, sideMargin / 1.5, LIST_COLUMN_HEIGHT - 2)
  if isFrendly then
    bg:SetTextureColor("blue")
    local guide = W_ICON.CreateGuideIconWidget(listFrame)
    guide:AddAnchor("TOPRIGHT", listFrame, -sideMargin / 1.5, sideMargin / 1.7)
    listFrame.guide = guide
    local OnEnter = function(self)
      SetTargetAnchorTooltip(GetUIText(NATION_TEXT, "hostile_setting_tip"), "TOPLEFT", self, "BOTTOMRIGHT", 0, 0)
    end
    guide:SetHandler("OnEnter", OnEnter)
    local OnLeave = function()
      HideTooltip()
    end
    guide:SetHandler("OnLeave", OnLeave)
  else
    bg:SetTextureColor("red")
  end
  for i = 1, MAX_ROW do
    do
      local subItem = relationListCtrl.listCtrl.items[i].subItems[1]
      local function OnEnter(self)
        local data = relationListCtrl:GetDataByViewIndex(i, 1)
        if data == nil then
          return
        end
        SetTargetAnchorTooltip(data.name, "TOPLEFT", self, "BOTTOMRIGHT", 0, 0)
        relationListCtrl.OnEnterItemRowIndex = i
        relationListCtrl.OnEnterItemColIndex = 1
        relationListCtrl.OnEnterWidget = self
      end
      subItem:SetHandler("OnEnter", OnEnter)
      local function OnLeave()
        HideTooltip()
        relationListCtrl.OnEnterWidget = nil
        relationListCtrl.OnEnterItemIndex = nil
        relationListCtrl.OnEnterItemColIndex = nil
      end
      subItem:SetHandler("OnLeave", OnLeave)
    end
  end
  function listFrame:ClearSelection()
    local index = self.relationListCtrl.listCtrl:GetSelectedIdx()
    if index ~= nil then
      self.relationListCtrl.listCtrl:Select(-1, false)
    end
  end
  function relationListCtrl:OnSliderChangedProc()
    if not tooltip.window:IsVisible() then
      return
    end
    if self.OnEnterWidget == nil or self.OnEnterItemRowIndex == nil or self.OnEnterItemColIndex == nil then
      return
    end
    local data = self.datas[self.OnEnterItemRowIndex + self:GetTopDataIndex() - 1]
    if data == nil then
      return
    end
    local itemData = data[self.OnEnterItemColIndex + ROWDATA_COLUMN_OFFSET]
    if itemData == nil then
      return
    end
    SetTargetAnchorTooltip(itemData.name, "TOPLEFT", self.OnEnterWidget, "BOTTOMRIGHT", 0, 0)
  end
end
local function CreateInfoFrame(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(parent:GetWidth() - parent.otherNaitonList:GetWidth() - 10, parent:GetHeight() + bottomMargin)
  CreateNationMap("nationMap", frame, false)
  frame.nationMap:AddAnchor("TOPLEFT", frame, 0, 0)
  local upperFrame = CreateNationInfos("InfoUpperFrame", frame, false)
  upperFrame:AddAnchor("TOPLEFT", frame.nationMap, "TOPRIGHT", 0, 0)
  frame.upperFrame = upperFrame
  CreateRelationNationList("friendlyList", frame, true)
  frame.friendlyList:AddAnchor("TOPLEFT", frame.nationMap, "BOTTOMLEFT", 0, 8)
  function frame.friendlyList.relationListCtrl:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    frame.hostileList:ClearSelection()
    frame:SetRelationListButton()
  end
  CreateRelationNationList("hostileList", frame, false)
  frame.hostileList:AddAnchor("TOPLEFT", frame.friendlyList, "BOTTOMLEFT", 0, 15)
  function frame.hostileList.relationListCtrl:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    frame.friendlyList:ClearSelection()
    frame:SetRelationListButton()
  end
  function frame:GetSelectFactionId()
    local index = frame.friendlyList.relationListCtrl.listCtrl:GetSelectedIdx()
    if index == nil or index == 0 then
      index = frame.hostileList.relationListCtrl.listCtrl:GetSelectedIdx()
      if index ~= nil or index ~= 0 then
        local data = frame.hostileList.relationListCtrl:GetDataByViewIndex(index, 1)
        if data == nil then
          return nil
        end
        return data.factionId
      end
    end
    local data = frame.friendlyList.relationListCtrl:GetDataByViewIndex(index, 1)
    if data == nil then
      return nil
    end
    return data.factionId
  end
  local nationRelationButton = frame:CreateChildWidget("button", "nationRelationButton", 0, true)
  nationRelationButton:SetText(GetUIText(NATION_TEXT, "friendly_setting"))
  nationRelationButton:AddAnchor("TOPRIGHT", parent, "BOTTOMRIGHT", 0, bottomMargin * 0.5)
  ApplyButtonSkin(nationRelationButton, BUTTON_BASIC.DEFAULT)
  nationRelationButton:Enable(true)
  local function NationRelationButtonClickFunc()
    if relationRequest ~= nil then
      relationRequest:Show(not relationRequest:IsVisible())
    else
      relationRequest = CreateRelationRequestWindow(id .. ".history")
      relationRequest:AddAnchor("CENTER", "UIParent", 0, 0)
    end
  end
  ButtonOnClickHandler(nationRelationButton, NationRelationButtonClickFunc)
  local nationHistoryButton = frame:CreateChildWidget("button", "nationHistoryButton", 0, true)
  nationHistoryButton:SetText(GetCommonText("faction_relation_history_title"))
  nationHistoryButton:AddAnchor("TOPRIGHT", nationRelationButton, "TOPLEFT", 0, 0)
  ApplyButtonSkin(nationHistoryButton, BUTTON_BASIC.DEFAULT)
  nationHistoryButton:Enable(true)
  local function NationHistoryButtonClickFunc()
    if relationHistory ~= nil then
      relationHistory:Show(not relationHistory:IsVisible())
    else
      relationHistory = CreateRelationHistoryWindow(id .. ".history")
      relationHistory:AddAnchor("CENTER", "UIParent", 0, 0)
    end
    local list = X2Nation:GetRelationHistoryList(true)
    if list ~= nil then
      relationHistory:FillResult(list)
    end
  end
  ButtonOnClickHandler(nationHistoryButton, NationHistoryButtonClickFunc)
  function frame:FillData()
    self.friendlyList.relationListCtrl:DeleteAllDatas()
    self.hostileList.relationListCtrl:DeleteAllDatas()
    if CUR_FACTION_ID == nil then
      return
    end
    local relationList = X2Nation:GetRelationList(CUR_FACTION_ID)
    if relationList == nil then
      return
    end
    local friendlyNationInfos = {}
    local hostileNationInfos = {}
    for i = 1, #relationList do
      if relationList[i].relation == UR_HOSTILE then
        local infos = relationList[i]
        infos.isFrendly = false
        hostileNationInfos[#hostileNationInfos + 1] = infos
      else
        local infos = relationList[i]
        infos.isFrendly = true
        friendlyNationInfos[#friendlyNationInfos + 1] = infos
      end
    end
    for i = 1, #friendlyNationInfos do
      self.friendlyList.relationListCtrl:InsertData(friendlyNationInfos[i].factionId, 1, friendlyNationInfos[i])
      self.friendlyList.relationListCtrl:InsertData(friendlyNationInfos[i].factionId, 2, friendlyNationInfos[i])
    end
    for i = 1, #hostileNationInfos do
      self.hostileList.relationListCtrl:InsertData(hostileNationInfos[i].factionId, 1, hostileNationInfos[i])
    end
    local count = self.friendlyList.relationListCtrl:GetDataCount()
    self.friendlyList.relationListCtrl.scroll:Show(count > MAX_ROW)
    count = self.hostileList.relationListCtrl:GetDataCount()
    self.hostileList.relationListCtrl.scroll:Show(count > MAX_ROW)
    nationRelationButton:Enable(X2Nation:CanDiplomacy())
  end
end
function CreateRelationTabOfNationMgr(window)
  CreateNationList("otherNaitonList", window)
  window.otherNaitonList:SetExtent(230, window:GetHeight() + bottomMargin)
  window.otherNaitonList:AddAnchor("TOPLEFT", window, 0, sideMargin)
  CreateInfoFrame("infoFrame", window)
  window.infoFrame:AddAnchor("TOPLEFT", window.otherNaitonList, "TOPRIGHT", sideMargin / 2, 0)
  function window.infoFrame:SetRelationListButton()
    local enable = false
    if X2Faction:GetMyTopLevelFaction() == CUR_FACTION_ID then
      enable = X2Hero:IsHero()
    end
    local selectFactionId = self:GetSelectFactionId()
    if selectFactionId == nil then
      enable = false
    end
    local hostileEnable = enable
    local friendEnable = enable
    if enable == true then
      hostileEnable = false
      friendEnable = false
    end
  end
  function window.otherNaitonList.sliderList:OnSelChanged()
    local index = self.content:GetSelectedIndex() + 1
    local factionId = window.otherNaitonList.NationFactionIds[index]
    if factionId == nil then
      return
    end
    ShowBelongExpeditionList(false)
    local info = X2Nation:GetNationBaseInfo(factionId)
    if info == nil then
      return
    end
    CUR_FACTION_ID = factionId
    window.infoFrame.upperFrame:Init(info, factionId)
    window.infoFrame.nationMap:FillMapInfo(factionId)
    window.infoFrame:FillData()
  end
  function window:Init()
    self.otherNaitonList:Init()
  end
  local events = {
    FACTION_RELATION_CHANGED = function()
      window.infoFrame:FillData()
    end,
    EXPEDITION_IMMIGRATION_UPDATE = function()
      window.infoFrame:FillData()
    end,
    FACTION_RELATION_HISTORY = function()
      if relationHistory ~= nil then
        local list = X2Nation:GetRelationHistoryList(false)
        if list ~= nil then
          relationHistory:FillResult(list)
        end
      end
    end,
    FACTION_RELATION_COUNT = function()
      if relationRequest ~= nil then
        relationRequest:FillData()
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
