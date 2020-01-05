local PAGE = 1
local COUNT_PER_PAGE = 10
portal.listWnd = nil
local portalInfoSort
local selectedTabIndex = TAB_RETURN_PORTAL
local CompareForSorting = function(a, b, sortPriority, orderBy)
  for i = 1, #sortPriority do
    if a[sortPriority[i]] > b[sortPriority[i]] then
      return not orderBy
    elseif a[sortPriority[i]] < b[sortPriority[i]] then
      return orderBy
    end
  end
  return false
end
function CreatePortalWindow(id, parent)
  local window = SetViewOfPortalWindow(id, parent)
  local spawnButton = window.spawnButton
  local deleteButton = window.deleteButton
  local renameButton = window.renameButton
  local function GetPortalInfo()
    local index = window.tab:GetSelectedTab()
    local listCtrl = window.tab.window[index].listCtrl
    local selIdx = listCtrl:GetSelectedIdx()
    local startIndex = (PAGE - 1) * COUNT_PER_PAGE
    local portalId = portalInfoSort[startIndex + selIdx].portal_id
    local portalType = portalInfoSort[startIndex + selIdx].portal_type
    local portalName = portalInfoSort[startIndex + selIdx].name
    local zoneid = portalInfoSort[startIndex + selIdx].zone_id
    local exist = portalInfoSort[startIndex + selIdx].exist
    local levelLimit
    if window.tab:GetSelectedTab() == TAB_INDUN_PORTAL then
      levelLimit = portalInfoSort[startIndex + selIdx].min_level > X2Unit:UnitLevel("player")
    end
    return portalId, portalType, portalName, zoneid, exist, levelLimit
  end
  for i = 1, #window.tab.window do
    do
      local tab = window.tab.window[i]
      local listCtrl = tab.listCtrl
      local pageCtrl = tab.pageCtrl
      function tab.searchGroup.resetButton:OnClick()
        tab.searchGroup.editBox:SetText("")
        if tab.searchGroup.comboBox ~= nil then
          tab.searchGroup.comboBox:Select(1)
        end
        pageCtrl:Refresh()
      end
      tab.searchGroup.resetButton:SetHandler("OnClick", tab.searchGroup.resetButton.OnClick)
      function tab.searchGroup.searchButton:OnClick()
        pageCtrl:Refresh()
      end
      tab.searchGroup.searchButton:SetHandler("OnClick", tab.searchGroup.searchButton.OnClick)
      function tab.searchGroup.editBox:OnEnterPressed()
        pageCtrl:Refresh()
      end
      tab.searchGroup.editBox:SetHandler("OnEnterPressed", tab.searchGroup.editBox.OnEnterPressed)
      for ci = 1, #listCtrl.column do
        local column = listCtrl.column[ci]
        function column:OnClick()
          local curSortPriorityKey = listCtrl:GetSortPriorityKey(listCtrl.currentSortPriority)
          local newSortPriorityKey = listCtrl:GetSortPriorityKey(self.sortPriority)
          listCtrl.currentSortPriority = self.sortPriority
          if curSortPriorityKey == newSortPriorityKey then
            listCtrl.currentSortOrderBy = not listCtrl.currentSortOrderBy
          end
          SerializePortalSortUiData(true, PORTAL_TAB_NAMES[i], newSortPriorityKey, listCtrl.currentSortOrderBy)
          pageCtrl:Refresh()
        end
        column:SetHandler("OnClick", column.OnClick)
        if column.favoriteIcon ~= nil then
          function column.favoriteIcon:OnEnter()
            SetTooltip(GetCommonText("favorite_portal_tooltip", X2Warp:GetFavoritePortalCountInfos()), self)
          end
          column.favoriteIcon:SetHandler("OnEnter", column.favoriteIcon.OnEnter)
          function column.favoriteIcon:OnLeave()
            HideTooltip()
          end
          column.favoriteIcon:SetHandler("OnLeave", column.favoriteIcon.OnLeave)
        end
        if listCtrl:GetSortPriorityKey(column.sortPriority) == "db" then
          function column:OnEnter()
            SetTooltip(GetCommonText("order_by_db"), self)
          end
          column:SetHandler("OnEnter", column.OnEnter)
          function column:OnLeave()
            HideTooltip()
          end
          column:SetHandler("OnLeave", column.OnLeave)
        end
      end
      function tab:Init()
        listCtrl:DeleteAllDatas()
        listCtrl:ClearSelection()
        pageCtrl:Init()
      end
      function listCtrl:OnSelChanged(selIdx)
        local tabIndex = window.tab:GetSelectedTab()
        if selIdx > 0 then
          local portalId, portalType, portalName, zoneid, exist, levelLimit = GetPortalInfo()
          local spawn = false
          local delete = false
          local changeName = false
          if tabIndex == TAB_RETURN_PORTAL then
            spawn = true
            if portalId ~= X2Warp:GetBoundPortalId() then
              delete = true
            end
          elseif tabIndex == TAB_INDUN_PORTAL then
            if exist and levelLimit == false then
              spawn = true
            end
          elseif tabIndex == TAB_FAVORITE_PORTAL then
            spawn = true
          else
            spawn = true
            delete = true
            changeName = true
          end
          spawnButton:Enable(spawn)
          deleteButton:Enable(delete)
          renameButton:Enable(changeName)
        else
          spawnButton:Enable(false)
          deleteButton:Enable(false)
          renameButton:Enable(false)
        end
        deleteButton:Show(tabIndex ~= TAB_FAVORITE_PORTAL)
        renameButton:Show(tabIndex ~= TAB_FAVORITE_PORTAL)
      end
      listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
      function pageCtrl:OnPageChanged(pageIndex, countPerPage)
        PAGE = pageIndex
        tab:FillPortalList(pageIndex)
      end
      function tab:FillPortalList(page)
        if window.tab:GetSelectedTab() == TAB_INDUN_PORTAL then
          tab:FillIndunPortalList(page)
          return
        end
        listCtrl:DeleteAllDatas()
        listCtrl:ClearSelection()
        local selectedInfo = tab.searchGroup.comboBox:GetSelectedInfo()
        if selectedInfo == nil then
          return
        end
        portalInfoSort = tab:getList(tab.searchGroup.editBox:GetText(), selectedInfo.value)
        local totalCount = 0
        if portalInfoSort ~= nil then
          totalCount = #portalInfoSort
        end
        local function Sort(a, b)
          return CompareForSorting(a, b, listCtrl.currentSortPriority, listCtrl.currentSortOrderBy)
        end
        table.sort(portalInfoSort, Sort)
        if page == nil then
          page = 1
        end
        local pageCount = math.floor(totalCount / COUNT_PER_PAGE)
        local startIndex = (page - 1) * COUNT_PER_PAGE
        local count = 0
        if page <= pageCount then
          count = COUNT_PER_PAGE
        else
          startIndex = pageCount * COUNT_PER_PAGE
          count = totalCount - startIndex
        end
        for j = 1, count do
          do
            local subItem = listCtrl.items[j].subItems[1]
            if i == TAB_RETURN_PORTAL and portalInfoSort[startIndex + j].portal_id == X2Warp:GetBoundPortalId() then
              subItem.returnIcon:Show(true)
              subItem.returnIcon:Raise()
            else
              subItem.returnIcon:Show(false)
            end
            subItem.favoriteButton.portalType = portalInfoSort[startIndex + j].portal_type
            subItem.favoriteButton.portalId = portalInfoSort[startIndex + j].portal_id
            if i == TAB_FAVORITE_PORTAL then
              function subItem.favoriteButton.RefreshProc()
                pageCtrl:Refresh()
              end
            end
            subItem.favoriteButton:SetChecked(portalInfoSort[startIndex + j].is_favorite, false)
            listCtrl:InsertData(portalInfoSort[startIndex + j].portal_index, 1, portalInfoSort[startIndex + j].name)
            listCtrl:InsertData(portalInfoSort[startIndex + j].portal_index, 2, portalInfoSort[startIndex + j].zone_name)
            listCtrl:InsertData(portalInfoSort[startIndex + j].portal_index, 3, portalInfoSort[startIndex + j].world_name)
            listCtrl.showMap[j]:Show(true)
            function listCtrl:ShowPortal()
              worldmap:ToggleMapWithPortal(portalInfoSort[startIndex + j].zone_id, portalInfoSort[startIndex + j].x, portalInfoSort[startIndex + j].y, portalInfoSort[startIndex + j].z)
            end
            listCtrl.showMap[j]:SetHandler("OnClick", listCtrl.ShowPortal)
          end
        end
        pageCtrl:SetPageByItemCount(totalCount, COUNT_PER_PAGE)
      end
      function tab:FillIndunPortalList(page)
        listCtrl:DeleteAllDatas()
        listCtrl:ClearSelection()
        portalInfoSort = tab:getList(tab.searchGroup.editBox:GetText())
        if page == nil then
          page = 1
        end
        local function Sort(a, b)
          return CompareForSorting(a, b, listCtrl.currentSortPriority, listCtrl.currentSortOrderBy)
        end
        table.sort(portalInfoSort, Sort)
        local pageCount = math.floor(#portalInfoSort / COUNT_PER_PAGE)
        local startIndex = (page - 1) * COUNT_PER_PAGE
        local count = 0
        if page <= pageCount then
          count = COUNT_PER_PAGE
        else
          startIndex = pageCount * COUNT_PER_PAGE
          count = #portalInfoSort - startIndex
        end
        for i = 1, COUNT_PER_PAGE do
          local items = listCtrl.items[i]
          items:ReleaseHandler("OnEnter")
        end
        for j = 1, count do
          for k = 1, #listCtrl.items[j].subItems do
            ApplyTextColor(listCtrl.items[j].subItems[k], FONT_COLOR.DEFAULT)
          end
          do
            local portalInfo = portalInfoSort[startIndex + j]
            local subItem1 = listCtrl.items[j].subItems[1]
            listCtrl:InsertData(portalInfo.portal_index, 1, portalInfo.name)
            local subItem2 = listCtrl.items[j].subItems[2]
            local party = portalInfo.party and X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_condition_party") or ""
            local str
            local playerLevel = X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player")
            local color
            if playerLevel < portalInfo.min_level then
              color = FONT_COLOR_HEX.GRAY
            end
            local minLevelStr = GetLevelToString(portalInfo.min_level, color, color == FONT_COLOR_HEX.GRAY)
            if playerLevel > portalInfo.max_level then
              color = FONT_COLOR_HEX.GRAY
            end
            local maxLevelStr = GetLevelToString(portalInfo.max_level, color, color == FONT_COLOR_HEX.GRAY)
            str = string.format("%s-%s%s", minLevelStr, maxLevelStr, party)
            listCtrl:InsertData(portalInfo.portal_index, 2, str)
            listCtrl:InsertData(portalInfo.portal_index, 3, tostring(portalInfo.max_player))
            if X2Player:GetFeatureSet().indunDailyLimit then
              if portalInfo.exist == false and portalInfo.weekendIndun then
                listCtrl:InsertData(portalInfo.portal_index, 4, "-")
              elseif portalInfo.maxEnterCount == 1000 then
                listCtrl:InsertData(portalInfo.portal_index, 4, X2Locale:LocalizeUiText(COMMON_TEXT, "portal_indun_entrance_unlimited"))
              else
                listCtrl:InsertData(portalInfo.portal_index, 4, string.format("%d/%d", portalInfo.visitCount, portalInfo.maxEnterCount))
                if portalInfo.visitCount >= portalInfo.maxEnterCount then
                  ApplyTextColor(listCtrl.items[j].subItems[4], FONT_COLOR.RED)
                end
              end
              listCtrl:InsertData(portalInfo.portal_index, 5, portalInfo.world_name)
            else
              listCtrl:InsertData(portalInfo.portal_index, 4, portalInfo.world_name)
            end
            listCtrl.showMap[j]:Show(true)
            listCtrl.showMap[j]:Enable(false)
            if portalInfo.exist then
              listCtrl.showMap[j]:Enable(true)
            end
            if portalInfo.min_level > X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player") then
              for i = 1, #listCtrl.items[j].subItems do
                ApplyTextColor(listCtrl.items[j].subItems[i], FONT_COLOR.GRAY)
              end
              subItem1.style:SetColor(FONT_COLOR.GRAY[1], FONT_COLOR.GRAY[2], FONT_COLOR.GRAY[3], FONT_COLOR.GRAY[4])
            end
            function listCtrl:ShowPortal()
              worldmap:ToggleMapWithPortal(portalInfo.portal_zone_id, portalInfo.x, portalInfo.y, portalInfo.z)
            end
            listCtrl.showMap[j]:SetHandler("OnClick", listCtrl.ShowPortal)
            local items = listCtrl.items[j]
            function items:OnEnter()
              if portalInfo.min_level > X2Unit:UnitLevel("player") + X2Unit:UnitHeirLevel("player") then
                SetTooltip(GetCommonText("indun_portal_level_limit_tooltip"), subItem2)
              end
            end
            items:SetHandler("OnEnter", items.OnEnter)
            local OnLeave = function()
              HideTooltip()
            end
            items:SetHandler("OnLeave", OnLeave)
          end
        end
        pageCtrl:SetPageByItemCount(#portalInfoSort, COUNT_PER_PAGE)
      end
      function tab:OnShow()
        pageCtrl:Refresh()
      end
      tab:SetHandler("OnShow", tab.OnShow)
    end
  end
  function spawnButton:OnEnter()
    if window.tab:GetSelectedTab() == TAB_INDUN_PORTAL then
      local tab = window.tab.window[TAB_INDUN_PORTAL]
      local listCtrl = tab.listCtrl
      if listCtrl:GetSelectedIdx() ~= 0 then
        local portalId, portalType, portalName, zoneid, exist, levelLimit = GetPortalInfo()
        if not exist or levelLimit then
          SetTooltip(GetCommonText("not_exist_indun_portal"), spawnButton)
          return
        end
      end
    end
    SetTooltip(locale.icon_shape_button_tooltip.portal_spawn, spawnButton)
  end
  spawnButton:SetHandler("OnEnter", spawnButton.OnEnter)
  function spawnButton:OnLeave()
    HideTooltip()
  end
  spawnButton:SetHandler("OnLeave", spawnButton.OnLeave)
  function window:Init()
    for i = 1, #window.tab.window do
      window.tab.window[i]:Init()
    end
  end
  function window:OnHide()
    window.Init()
    HideEditDialog(portal.listWnd)
    portal.listWnd = nil
    X2Warp:EndPortalInteraction()
  end
  window:SetHandler("OnHide", window.OnHide)
  function spawnButton:OnClick(arg)
    local index = window.tab:GetSelectedTab()
    local listCtrl = window.tab.window[index].listCtrl
    if arg == "LeftButton" then
      local portalId, portalType, portalName, zoneid = GetPortalInfo()
      if portal == nil or portalType == nil or portalName == nil then
        return
      end
      listCtrl:ClearSelection()
      if index == TAB_INDUN_PORTAL then
        X2Warp:OpenIndunPortal(zoneid)
      else
        X2Warp:OpenPortal(portalType, portalId, portalName)
      end
      window:Show(false)
    end
  end
  spawnButton:SetHandler("OnClick", spawnButton.OnClick)
  function deleteButton:OnClick(arg)
    if arg == "LeftButton" then
      do
        local portalId, portalType, portalName = GetPortalInfo()
        if portalId == X2Warp:GetBoundPortalId() then
          return
        end
        local function DialogDeletePortalHandler(wnd, infoTable)
          infoTable.title = locale.portal.title
          infoTable.content = locale.portal.ask_delete(portalName)
          wnd:SetTitle(infoTable.title)
          wnd:SetContent(infoTable.content)
          function wnd:OkProc()
            local index = window.tab:GetSelectedTab()
            local listCtrl = window.tab.window[index].listCtrl
            X2Warp:DeletePortal(portalType, portalId)
            listCtrl:DeleteData(portalId)
            window.tab.window[index]:FillPortalList(PAGE)
            listCtrl:ClearSelection()
          end
        end
        X2DialogManager:RequestDefaultDialog(DialogDeletePortalHandler, window:GetId())
      end
    end
  end
  deleteButton:SetHandler("OnClick", deleteButton.OnClick)
  function renameButton:OnClick()
    renameButton:Enable(false)
    local portalId, _, portalName = GetPortalInfo()
    local index = window.tab:GetSelectedTab()
    local listCtrl = window.tab.window[index].listCtrl
    listCtrl:ClearSelection()
    ShowChangePortalName(portal.listWnd, portalId, portalName)
  end
  renameButton:SetHandler("OnClick", renameButton.OnClick)
  function window:ShowProc()
    self:Init()
    portal.listWnd.tab:SelectTab(selectedTabIndex)
    portal.listWnd.tab.window[selectedTabIndex]:FillPortalList()
  end
  function window.tab:OnTabChanged(selected)
    selectedTabIndex = selected
    ReAnhorTabLine(window.tab, selected)
  end
  window.tab:SetHandler("OnTabChanged", window.tab.OnTabChanged)
  window:EnableHidingIsRemove(true)
  return window
end
local events = {}
local function OnTogglePortal(addPortal, abc)
  if portal.listWnd == nil then
    portal.listWnd = CreatePortalWindow("portal.window", "UIParent")
    portal.listWnd:SetCloseOnEscape(true)
    portal.listWnd:SetHandler("OnEvent", function(this, event, ...)
      events[event](...)
    end)
    portal.listWnd:RegisterEvent("SAVE_PORTAL")
    portal.listWnd:RegisterEvent("DELETE_PORTAL")
    portal.listWnd:RegisterEvent("RENAME_PORTAL")
    portal.listWnd:RegisterEvent("INTERACTION_END")
    portal.listWnd:Init()
    portal.listWnd:Show(true)
    local pageCtrl = portal.listWnd.tab.window[selectedTabIndex].pageCtrl
    pageCtrl:SetCurrentPage(1, false)
    pageCtrl:Refresh()
  end
  if addPortal then
    ShowRegisterPotal(portal.listWnd)
  end
end
UIParent:SetEventHandler("TOGGLE_PORTAL_DIALOG", OnTogglePortal)
local OnSavePortal = function()
  if portal.listWnd == nil then
    return
  end
  local tabWnd = portal.listWnd.tab.window[TAB_USER_PORTAL]
  portal.listWnd.tab:SelectTab(TAB_USER_PORTAL)
  tabWnd.pageCtrl:Refresh()
  tabWnd.pageCtrl:MoveLastPage()
end
local OnDeletePortal = function()
  if portal.listWnd == nil then
    return
  end
  local index = portal.listWnd.tab:GetSelectedTab()
  local pageCtrl = portal.listWnd.tab.window[index].pageCtrl
  pageCtrl:Refresh()
end
local OnRenamePortal = function()
  if portal.listWnd == nil then
    return
  end
  local index = portal.listWnd.tab:GetSelectedTab()
  local pageCtrl = portal.listWnd.tab.window[index].pageCtrl
  pageCtrl:Refresh()
end
events = {
  SAVE_PORTAL = OnSavePortal,
  DELETE_PORTAL = OnDeletePortal,
  RENAME_PORTAL = OnRenamePortal,
  INTERACTION_END = function()
    if portal.listWnd ~= nil then
      portal.listWnd:Show(false)
    end
  end
}
