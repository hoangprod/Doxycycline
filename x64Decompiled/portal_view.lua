portal = {}
TAB_RETURN_PORTAL = 1
TAB_USER_PORTAL = 2
TAB_FAVORITE_PORTAL = 3
TAB_INDUN_PORTAL = 4
PORTAL_TAB_NAMES = {
  "return",
  "portal",
  "favorite",
  "indun"
}
if portalLocale == nil then
  portalLocale = {}
end
portalLocale.width = {
  window = 800,
  column = {
    255,
    260,
    165,
    80
  },
  columnIndun = {
    230,
    170,
    110,
    150,
    90
  },
  columnIndunUseDaily = {
    200,
    140,
    90,
    150,
    120,
    60
  },
  searchGroup = 644,
  searchEditBox = 340,
  searchCategory = 133
}
function SerializePortalSortUiData(isWriting, tabName, sortPriorityKey, sortOrderBy)
  if isWriting then
    if sortPriorityKey ~= nil and sortOrderBy ~= nil then
      local sortData = {sortPriorityKey = sortPriorityKey, sortOrderBy = sortOrderBy}
      ADDON:SetPortalSortUiData(tabName, sortData)
    end
  else
    local data = ADDON:GetPortalSortUiData(tabName)
    if data == nil then
      return sortPriorityKey, sortOrderBy
    else
      return data.sortPriorityKey, data.sortOrderBy
    end
  end
end
local COUNT_PER_PAGE = 10
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreatePortalNameWindow = function(widget, useFavoriteIcon)
  local returnIcon = W_CTRL.CreateLabel(widget:GetId() .. "portalPage.returnIcon", widget)
  returnIcon:Show(false)
  returnIcon:SetExtent(21, 17)
  returnIcon:AddAnchor("RIGHT", widget, -3, 1)
  widget.returnIcon = returnIcon
  local bg = returnIcon:CreateDrawable("ui/portal.dds", "name_bg", "background")
  bg:AddAnchor("TOPLEFT", returnIcon, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", returnIcon, 0, 0)
  function returnIcon:OnEnter()
    SetTooltip(locale.portal.returnPlace, self)
  end
  returnIcon:SetHandler("OnEnter", returnIcon.OnEnter)
  function returnIcon:OnLeave()
    HideTooltip()
  end
  returnIcon:SetHandler("OnLeave", returnIcon.OnLeave)
  widget:SetInset(26, 2, 7, 0)
  widget:SetLimitWidth(true)
  widget.style:SetSnap(true)
  widget.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(widget, FONT_COLOR.DEFAULT)
  if useFavoriteIcon then
    local favoriteButton = widget:CreateChildWidget("checkbutton", "favoriteButton", 0, true)
    favoriteButton:AddAnchor("LEFT", widget, 0, 0)
    ApplyButtonSkin(favoriteButton, BUTTON_CONTENTS.FAVORITE_PORTAL)
    local selectedDrawable = favoriteButton:CreateDrawable(TEXTURE_PATH.PORTAL, "bookmark_se", "overlay")
    selectedDrawable:AddAnchor("CENTER", favoriteButton, 0, 0)
    favoriteButton:SetCheckedBackground(selectedDrawable)
    function favoriteButton:OnCheckChanged()
      if not X2Warp:SetFavoritePortal(self.portalType, self.portalId, self:GetChecked()) then
        AddMessageToSysMsgWindow(GetCommonText("favorite_portal_full"))
        self:SetChecked(not self:GetChecked(), false)
      end
      if self.RefreshProc ~= nil then
        self:RefreshProc()
      end
    end
    favoriteButton:SetHandler("OnCheckChanged", favoriteButton.OnCheckChanged)
  end
end
ORDER_BY_ASC = true
ORDER_BY_DESC = false
local sortPriorities = {
  name = {
    "name",
    "zone_name",
    "world_name",
    "portal_index",
    "portal_type"
  },
  zone = {
    "zone_name",
    "name",
    "world_name",
    "portal_index",
    "portal_type"
  },
  world = {
    "world_name",
    "name",
    "zone_name",
    "portal_index",
    "portal_type"
  },
  db = {
    "portal_index",
    "portal_type"
  }
}
local indunSortPriorities = {
  name = {
    "name",
    "min_level",
    "max_player",
    "maxEnterCount",
    "world_name",
    "portal_index"
  },
  level = {
    "min_level",
    "name",
    "max_player",
    "maxEnterCount",
    "world_name",
    "portal_index"
  },
  playerCount = {
    "max_player",
    "min_level",
    "name",
    "maxEnterCount",
    "world_name",
    "portal_index"
  },
  enterCount = {
    "maxEnterCount",
    "min_level",
    "name",
    "max_player",
    "world_name",
    "portal_index"
  },
  world = {
    "world_name",
    "min_level",
    "name",
    "max_player",
    "maxEnterCount",
    "portal_index"
  },
  db = {
    "portal_index"
  }
}
function CreatePortalFrameWindow(window, tabIndex)
  local searchGroup = window:CreateChildWidget("emptywidget", "searchGroup", 0, true)
  searchGroup:SetExtent(window:GetWidth(), 33)
  searchGroup:AddAnchor("TOPLEFT", window, 0, 10)
  local resetButton = searchGroup:CreateChildWidget("button", "resetButton", 0, true)
  resetButton:AddAnchor("LEFT", searchGroup, "LEFT", 0, 0)
  resetButton:Show(true)
  resetButton:SetText(GetUIText(AUCTION_TEXT, "search_condition_init"))
  ApplyButtonSkin(resetButton, BUTTON_BASIC.DEFAULT)
  local info = {
    {
      GetCommonText("all"),
      PSC_ALL
    },
    {
      locale.portal.location_name,
      PSC_NAME
    },
    {
      locale.portal.zone_name,
      PSC_ZONE
    },
    {
      locale.portal.world_name,
      PSC_WORLD
    }
  }
  local datas = {}
  for i = 1, #info do
    local data = {
      text = info[i][1],
      value = info[i][2]
    }
    table.insert(datas, data)
  end
  local inset = 4
  local comboBox = W_CTRL.CreateComboBox("comboBox", searchGroup)
  comboBox:AppendItems(datas)
  comboBox:SetWidth(portalLocale.width.searchCategory)
  comboBox:AddAnchor("LEFT", resetButton, "RIGHT", inset, 0)
  local searchButton = searchGroup:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:AddAnchor("RIGHT", searchGroup, "RIGHT", 0, 0)
  searchButton:Show(true)
  searchButton:SetText(GetCommonText("search"))
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  local editBoxWidth = searchGroup:GetWidth() - resetButton:GetWidth() - portalLocale.width.searchCategory - searchButton:GetWidth() - inset - inset - inset
  local editBox = W_CTRL.CreateEdit("editBox", searchGroup)
  editBox:SetExtent(editBoxWidth, 29)
  editBox:AddAnchor("LEFT", comboBox, "RIGHT", inset, 0)
  editBox:SetMaxTextLength(25)
  editBox:CreateGuideText(GetCommonText("input_name_guide"), ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", window)
  listCtrl:AddAnchor("TOPLEFT", window, 0, sideMargin / 2 + searchGroup:GetHeight())
  listCtrl:AddAnchor("BOTTOMRIGHT", window, 0, -sideMargin / 2)
  function listCtrl:GetSortPriorityKey(compareSortPriority)
    for k, v in pairs(sortPriorities) do
      if v == compareSortPriority then
        return k
      end
    end
    return nil
  end
  loadedSortPriorityKey, loadedSortOrderBy = SerializePortalSortUiData(false, PORTAL_TAB_NAMES[tabIndex], listCtrl:GetSortPriorityKey(sortPriorities.db), ORDER_BY_ASC)
  listCtrl.currentSortOrderBy = loadedSortOrderBy
  listCtrl.currentSortPriority = sortPriorities[loadedSortPriorityKey]
  listCtrl:InsertColumn(portalLocale.width.column[1], LCCIT_STRING)
  listCtrl.column[1]:SetText(locale.portal.location_name)
  listCtrl.column[1].sortPriority = sortPriorities.name
  listCtrl:InsertColumn(portalLocale.width.column[2], LCCIT_STRING)
  listCtrl.column[2]:SetText(locale.portal.zone_name)
  listCtrl.column[2].sortPriority = sortPriorities.zone
  listCtrl:InsertColumn(portalLocale.width.column[3], LCCIT_STRING)
  listCtrl.column[3]:SetText(locale.portal.world_name)
  listCtrl.column[3].sortPriority = sortPriorities.world
  listCtrl:InsertColumn(portalLocale.width.column[4], LCCIT_BUTTON)
  listCtrl.column[4]:SetText(locale.portal.map_location)
  listCtrl.column[4].sortPriority = sortPriorities.db
  listCtrl:InsertRows(COUNT_PER_PAGE, false)
  DrawListCtrlUnderLine(listCtrl)
  listCtrl:UseOverClickTexture()
  for i = 1, #listCtrl.column do
    SettingListColumn(listCtrl, listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(listCtrl.column[i], #listCtrl.column, i)
    if i == 1 then
      local column = listCtrl.column[i]
      local favoriteIcon = column:CreateChildWidget("emptywidget", "favoriteIcon", 0, true)
      favoriteIcon:AddAnchor("LEFT", column, 0, 0)
      favoriteIcon:SetExtent(10, 10)
      favoriteIcon.bg = favoriteIcon:CreateDrawable(TEXTURE_PATH.PORTAL, "bookmark_se", "background")
      favoriteIcon.bg:AddAnchor("LEFT", favoriteIcon, 0, 0)
      local width, height = favoriteIcon.bg:GetExtent()
      favoriteIcon:SetExtent(width, height)
    end
  end
  listCtrl.showMap = {}
  for i = 1, COUNT_PER_PAGE do
    for j = 1, #listCtrl.column do
      local subItem = listCtrl.items[i].subItems[j]
      if j == 1 then
        CreatePortalNameWindow(subItem, true)
      elseif j == 2 then
        subItem:SetInset(10, 2, 10, 0)
        subItem:SetLimitWidth(true)
        subItem.style:SetSnap(true)
        subItem.style:SetAlign(ALIGN_LEFT)
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
        local OnEnter = function(self)
          local text = self:GetText()
          local textWidth = self.style:GetTextWidth(text)
          if textWidth < self:GetWidth() then
            return
          end
          SetTooltip(text, self)
        end
        subItem:SetHandler("OnEnter", OnEnter)
      elseif j == 4 then
        subItem:Show(false)
        subItem:Enable(true)
        ApplyButtonSkin(subItem, BUTTON_CONTENTS.MAP_OPEN)
        listCtrl.showMap[i] = subItem
      else
        subItem:SetInset(0, 2, 0, 0)
        subItem.style:SetSnap(true)
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
    end
  end
  local pageCtrl = W_CTRL.CreatePageControl(window:GetId() .. ".pageControl", window)
  pageCtrl:Show(true)
  pageCtrl:AddAnchor("BOTTOM", window, 0, sideMargin * 2)
  window.pageCtrl = pageCtrl
end
function CreatePortalIndunFrameWindow(window, tabIndex)
  local searchGroup = window:CreateChildWidget("emptywidget", "searchGroup", 0, true)
  searchGroup:SetExtent(window:GetWidth(), 33)
  searchGroup:AddAnchor("TOPLEFT", window, 0, 10)
  local resetButton = searchGroup:CreateChildWidget("button", "resetButton", 0, true)
  resetButton:AddAnchor("LEFT", searchGroup, "LEFT", 0, 0)
  resetButton:Show(true)
  resetButton:SetText(GetUIText(AUCTION_TEXT, "search_condition_init"))
  ApplyButtonSkin(resetButton, BUTTON_BASIC.DEFAULT)
  local inset = 4
  local searchButton = searchGroup:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:AddAnchor("RIGHT", searchGroup, "RIGHT", 0, 0)
  searchButton:Show(true)
  searchButton:SetText(GetCommonText("search"))
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  local editBox = W_CTRL.CreateEdit("editBox", searchGroup)
  local editBoxWidth = searchGroup:GetWidth() - resetButton:GetWidth() - searchButton:GetWidth() - inset - inset
  editBox:SetExtent(editBoxWidth, 29)
  editBox:AddAnchor("LEFT", resetButton, "RIGHT", inset, 0)
  editBox:SetMaxTextLength(25)
  editBox:CreateGuideText(GetCommonText("input_name_guide"), ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", window)
  listCtrl:AddAnchor("TOPLEFT", window, 0, sideMargin / 2 + searchGroup:GetHeight())
  listCtrl:AddAnchor("BOTTOMRIGHT", window, 0, -sideMargin / 2)
  local featureSet = X2Player:GetFeatureSet()
  local colIdx = 0
  function listCtrl:GetSortPriorityKey(compareSortPriority)
    for k, v in pairs(indunSortPriorities) do
      if v == compareSortPriority then
        return k
      end
    end
    return nil
  end
  loadedSortPriorityKey, loadedSortOrderBy = SerializePortalSortUiData(false, PORTAL_TAB_NAMES[tabIndex], listCtrl:GetSortPriorityKey(indunSortPriorities.level), ORDER_BY_ASC)
  listCtrl.currentSortOrderBy = loadedSortOrderBy
  listCtrl.currentSortPriority = indunSortPriorities[loadedSortPriorityKey]
  local function AddColumn(str, viewType, sortPriority)
    local widthTable = portalLocale.width.columnIndun
    if featureSet.indunDailyLimit then
      widthTable = portalLocale.width.columnIndunUseDaily
    end
    colIdx = colIdx + 1
    listCtrl:InsertColumn(widthTable[colIdx], viewType)
    listCtrl.column[colIdx]:SetText(str)
    listCtrl.column[colIdx].sortPriority = sortPriority
  end
  AddColumn(locale.portal.indun_name, LCCIT_STRING, indunSortPriorities.name)
  AddColumn(locale.portal.enter_condition, LCCIT_TEXTBOX, indunSortPriorities.level)
  AddColumn(locale.portal.player_count, LCCIT_STRING, indunSortPriorities.playerCount)
  if featureSet.indunDailyLimit then
    AddColumn(locale.portal.daily_use, LCCIT_STRING, indunSortPriorities.enterCount)
  end
  AddColumn(locale.portal.world_name, LCCIT_STRING, indunSortPriorities.world)
  AddColumn(locale.portal.location, LCCIT_BUTTON, indunSortPriorities.db)
  listCtrl:InsertRows(COUNT_PER_PAGE, false)
  DrawListCtrlUnderLine(listCtrl)
  listCtrl:UseOverClickTexture()
  for i = 1, #listCtrl.column do
    SettingListColumn(listCtrl, listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(listCtrl.column[i], #listCtrl.column, i)
  end
  listCtrl.showMap = {}
  for i = 1, COUNT_PER_PAGE do
    for j = 1, #listCtrl.column do
      local subItem = listCtrl.items[i].subItems[j]
      if j == 1 then
        CreatePortalNameWindow(subItem, false)
      elseif j == colIdx then
        local showMap = subItem:CreateChildWidget("button", "okButton", 0, true)
        showMap:Show(false)
        showMap:Enable(false)
        showMap:AddAnchor("CENTER", subItem, 0, 1)
        ApplyButtonSkin(showMap, BUTTON_CONTENTS.MAP_OPEN)
        listCtrl.showMap[i] = showMap
      else
        subItem:SetInset(0, 2, 0, 0)
        subItem.style:SetSnap(true)
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
    end
  end
  local pageCtrl = W_CTRL.CreatePageControl(window:GetId() .. ".pageControl", window)
  pageCtrl:Show(true)
  pageCtrl:AddAnchor("BOTTOM", window, 0, sideMargin * 2)
  window.pageCtrl = pageCtrl
end
function SetViewOfPortalWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(portalLocale.width.window, 487)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(locale.portal.title)
  window:SetSounds("portal")
  local spawnButton = window:CreateChildWidget("button", "spawnButton", 0, true)
  spawnButton:Enable(false)
  spawnButton:AddAnchor("BOTTOMRIGHT", window, -sideMargin + 5, -(sideMargin / 2))
  ApplyButtonSkin(spawnButton, BUTTON_ICON.PORTAL_SPAWN)
  SetButtonTooltip(spawnButton, locale.icon_shape_button_tooltip.portal_spawn)
  window.spawnButton = spawnButton
  local deleteButton = window:CreateChildWidget("button", "deleteButton", 0, true)
  deleteButton:Enable(false)
  deleteButton:AddAnchor("BOTTOMLEFT", window, sideMargin - 5, -(sideMargin / 2))
  ApplyButtonSkin(deleteButton, BUTTON_ICON.PORTAL_DELETE)
  SetButtonTooltip(deleteButton, locale.icon_shape_button_tooltip.portal_delete)
  local renameButton = window:CreateChildWidget("button", "renameButton", 0, true)
  renameButton:Enable(false)
  renameButton:AddAnchor("LEFT", deleteButton, "RIGHT", 5, 0)
  ApplyButtonSkin(renameButton, BUTTON_ICON.PORTAL_RENAME)
  SetButtonTooltip(renameButton, locale.icon_shape_button_tooltip.portal_rename)
  local tab = window:CreateChildWidget("tab", "tab", 0, true)
  tab:Show(false)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  tab:SetHeight(335)
  tab:Show(true)
  window.tab = tab
  tab:AddSimpleTab(locale.portal.menu[TAB_RETURN_PORTAL])
  tab:AddSimpleTab(locale.portal.menu[TAB_USER_PORTAL])
  tab:AddSimpleTab(locale.portal.menu[TAB_FAVORITE_PORTAL])
  if X2Player:GetFeatureSet().indunPortal then
    tab:AddSimpleTab(locale.portal.menu[TAB_INDUN_PORTAL])
  end
  local buttonTable = {}
  for i = 1, #tab.window do
    ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
    ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
    table.insert(buttonTable, tab.selectedButton[i])
    table.insert(buttonTable, tab.unselectedButton[i])
  end
  AdjustBtnLongestTextWidth(buttonTable)
  tab:SetGap(1)
  DrawTabSkin(tab, tab.window[TAB_RETURN_PORTAL], tab.selectedButton[TAB_RETURN_PORTAL])
  CreatePortalFrameWindow(tab.window[TAB_RETURN_PORTAL], TAB_RETURN_PORTAL)
  CreatePortalFrameWindow(tab.window[TAB_USER_PORTAL], TAB_USER_PORTAL)
  CreatePortalFrameWindow(tab.window[TAB_FAVORITE_PORTAL], TAB_FAVORITE_PORTAL)
  tab.window[TAB_RETURN_PORTAL].getList = X2Warp.GetReturnList
  tab.window[TAB_USER_PORTAL].getList = X2Warp.GetPortalList
  tab.window[TAB_FAVORITE_PORTAL].getList = X2Warp.GetFavoritePortalList
  if X2Player:GetFeatureSet().indunPortal then
    CreatePortalIndunFrameWindow(tab.window[TAB_INDUN_PORTAL], TAB_INDUN_PORTAL)
    tab.window[TAB_INDUN_PORTAL].getList = X2Warp.GetIndunPortalList
  end
  return window
end
