APPELLATION_GRADE = {
  "normal",
  "normal",
  "grand",
  "rare",
  "arcane",
  "heroic",
  "unique",
  "celestial",
  "divine",
  "epic",
  "legendary",
  "mythic",
  "arche"
}
APPELLATION_ROUTE_FILTER_SHOW_ALL = 1
local selectStampId
local LIST_ROW_COUNT = APPELLATION_LIST_INFO.LIST_ROW_COUNT
local LIST_DATA_HEIGHT = APPELLATION_LIST_INFO.LIST_DATA_HEIGHT
function SetAppellationEventFunction(window)
  function window:UpdateMyInfo()
    local showingInfo = X2Player:GetShowingAppellation()
    local effectInfo = X2Player:GetEffectAppellation()
    local levelInfo = X2Player:GetAppellationMyLevelInfo()
    local stampInfo = X2Player:GetAppellationMyStamp()
    if showingInfo ~= nil and showingInfo[APPELLATION_INFO.TYPE] ~= 0 then
      window.myinfoTitleLabel:SetText(showingInfo[APPELLATION_INFO.NAME])
      window.myinfoTitleGrade:SetTextureInfo(APPELLATION_GRADE[showingInfo[APPELLATION_INFO.GRADE] + 1])
      window.selectedNameType = showingInfo[APPELLATION_INFO.TYPE]
    else
      window.myinfoTitleLabel:SetText(GetUIText(TOOLTIP_TEXT, "nobody"))
      window.myinfoTitleGrade:SetTextureInfo(APPELLATION_GRADE[1])
      window.selectedNameType = 0
    end
    if effectInfo ~= nil and effectInfo[APPELLATION_INFO.TYPE] ~= 0 then
      if effectInfo[APPELLATION_INFO.BUFF_INFO] ~= nil then
        do
          local text = effectInfo[APPELLATION_INFO.BUFF_INFO].description
          text = string.gsub(text, "\r\n", "")
          text = string.gsub(text, "\n", "")
          window.myinfoEffectLabel:SetText(text)
          function window.myinfoEffectLabel:OnEnter()
            SetTooltip(text, self)
          end
          window.myinfoEffectLabel:SetHandler("OnEnter", window.myinfoEffectLabel.OnEnter)
        end
      else
        window.myinfoEffectLabel:SetText(GetUIText(TOOLTIP_TEXT, "nobody"))
      end
      window.myinfoEffectGrade:SetTextureInfo(APPELLATION_GRADE[effectInfo[APPELLATION_INFO.GRADE] + 1])
      window.selectedEffectType = effectInfo[APPELLATION_INFO.TYPE]
    else
      window.myinfoEffectLabel:SetText(GetUIText(TOOLTIP_TEXT, "nobody"))
      window.myinfoEffectGrade:SetTextureInfo(APPELLATION_GRADE[1])
      window.selectedEffectType = 0
    end
    window.myinfoMyGrade:SetText(GetCommonText("appellation_grade") .. levelInfo.level)
    window.myinfoExpBar:SetMinMaxValues(levelInfo.minExp, levelInfo.maxExp)
    window.myinfoExpBar:SetValue(levelInfo.exp)
    local visible = levelInfo.exp > levelInfo.minExp and levelInfo.exp < levelInfo.maxExp
    window.myinfoExpBar.shadowDeco:SetVisible(visible)
    function window.myinfoExpBar:OnEnter()
      local tooltip = CommaStr(levelInfo.exp - levelInfo.minExp) .. " / " .. CommaStr(levelInfo.maxExp - levelInfo.minExp)
      local max = levelInfo.maxExp - levelInfo.minExp
      local val = levelInfo.exp - levelInfo.minExp
      local percent = string.format(" (%.2f%%)", math.min(val / max * 100, 100))
      SetTooltip(tooltip .. percent, self)
    end
    window.myinfoExpBar:SetHandler("OnEnter", window.myinfoExpBar.OnEnter)
    function window.myinfoSlot:OnEnter()
      SetTooltip(GetCommonText("appellation_guide"), self)
    end
    window.myinfoSlot:SetHandler("OnEnter", window.myinfoSlot.OnEnter)
    if stampInfo.path ~= nil then
      local path = stampInfo.path
      path = string.gsub(path, "Game\\", "")
      window.myinfoSlotStamp:SetTexture(path)
    end
  end
  function window:UpdateList(filter, page)
    window.listWnd:DeleteAllDatas()
    window.listWnd.pageControl:SetPageByItemCount(X2Player:GetAppellationsCount(filter), APPELLATION_LIST_PER_PAGE)
    local columnCount = #window.listWnd.listCtrl.column
    local infos = X2Player:GetAppellations(filter, page)
    for i = 1, #infos do
      local info = infos[i]
      for j = 1, columnCount do
        window.listWnd:InsertData(i, j, info)
      end
    end
    window.listWnd.verticalLine1:SetExtent(3, math.min(LIST_DATA_HEIGHT * #infos, LIST_DATA_HEIGHT * LIST_ROW_COUNT))
    window.listWnd.verticalLine2:SetExtent(3, math.min(LIST_DATA_HEIGHT * #infos, LIST_DATA_HEIGHT * LIST_ROW_COUNT))
    window.listEmptyLabel:Show(#infos <= 0)
  end
  function window:UpdateRouteInfo(type)
    local routeDescription = X2Player:GetAppellationRouteInfo(type)
    if routeDescription ~= nil then
      window.routeDesc:SetText(X2Util:ApplyUIMacroString(routeDescription.routeDesc))
      if routeDescription.kind == APPELATION_ROUTE_TYPE_QUEST_CONTEXTS or routeDescription.kind == APPELATION_ROUTE_TYPE_ACHIEVEMENTS or routeDescription.kind == APPELATION_ROUTE_TYPE_MERCHANT_PACKS then
        window.popupBtn:Enable(routeDescription.routePopup)
      else
        window.popupBtn:Enable(false)
      end
    else
      window.routeDesc:SetText("")
      window.popupBtn:Enable(false)
    end
  end
  function window:routePopupProc(type)
    local routeDescription = X2Player:GetAppellationRouteInfo(type)
    local kind = routeDescription.kind
    if kind == APPELATION_ROUTE_TYPE_QUEST_CONTEXTS then
      ShowHiddenQuestReport(routeDescription.type, true)
    elseif kind == APPELATION_ROUTE_TYPE_ACHIEVEMENTS then
      ToggleAssignmentWithAcheivement(routeDescription.type)
    elseif kind == APPELATION_ROUTE_TYPE_MERCHANT_PACKS then
      DirectOpenStore(routeDescription.type)
    elseif kind == APPELATION_ROUTE_TYPE_HIDDEN then
    elseif kind == APPELATION_ROUTE_TYPE_ETC then
    end
  end
  function window.listWnd:OnPageChangedProc(pageIndex)
    local info = window.comboBox:GetSelectedInfo()
    if info == nil then
      return
    end
    window:UpdateList(info.value, pageIndex)
  end
  function window.comboBox:SelectedProc()
    window.listWnd.pageControl:SetCurrentPage(1, true)
  end
  function window:UpdateStamps()
    local stamps = X2Player:GetAppellationStampInfo()
    local myStampInfo = X2Player:GetAppellationMyStamp()
    local levelInfo = X2Player:GetAppellationMyLevelInfo()
    wnd = window.stampWnd
    scrollWnd = window.scrollWnd
    local count = #stamps
    if count < wnd.minStampNum then
      count = wnd.minStampNum
    end
    local widthCount = 5
    local ResetSelectedStamps = function()
      for i = 1, #wnd.selected do
        if wnd.selected[i]:IsVisible() then
          wnd.selected[i]:Show(false)
        end
      end
    end
    local ResetAppliedStamps = function()
      for i = 1, #wnd.applied do
        if wnd.applied[i]:IsVisible() then
          wnd.applied[i]:Show(false)
        end
      end
    end
    ResetSelectedStamps()
    ResetAppliedStamps()
    if #wnd.btns == 0 then
      for i = 1, count do
        if i == 1 then
          local stampIcon = CreateItemIconButton("stampIcon" .. i, scrollWnd.emptyWidget)
          stampIcon:AddAnchor("TOPLEFT", scrollWnd.emptyWidget, 7, 7)
          stampIcon:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
          stampIcon:AddLimitLevelWidget()
          wnd.btns[i] = stampIcon
          local selectedSlot = scrollWnd.emptyWidget:CreateDrawable(TEXTURE_PATH.APPELLATION_STAMP_SELECT, "icon_selected_yellow", "overlay")
          selectedSlot:AddAnchor("TOPLEFT", stampIcon, 1, 1)
          selectedSlot:Show(false)
          wnd.selected[i] = selectedSlot
          local appliedSlot = scrollWnd.emptyWidget:CreateDrawable(TEXTURE_PATH.APPELLATION_STAMP_APPLIED, "icon_selected", "overlay")
          appliedSlot:AddAnchor("TOPLEFT", stampIcon, 1, 1)
          appliedSlot:Show(false)
          wnd.applied[i] = appliedSlot
        else
          local offsetX = (i - 1) % widthCount * (ICON_SIZE.DEFAULT + 5)
          local offsetY = math.floor((i - 1) / widthCount) * (ICON_SIZE.DEFAULT + 5)
          local height = offsetY + ICON_SIZE.DEFAULT + 15
          if height > scrollWnd.emptyWidget:GetHeight() then
            scrollWnd.emptyWidget:SetHeight(height)
            scrollWnd:ResetScroll(height)
            scrollWnd.scroll:Show(height)
          end
          local stampIcon = CreateItemIconButton("stampIcon" .. i, scrollWnd.emptyWidget)
          stampIcon:AddAnchor("TOPLEFT", wnd.btns[1], offsetX, offsetY)
          stampIcon:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
          stampIcon:AddLimitLevelWidget()
          wnd.btns[i] = stampIcon
          local selectedSlot = scrollWnd.emptyWidget:CreateDrawable(TEXTURE_PATH.APPELLATION_STAMP_SELECT, "icon_selected_yellow", "overlay")
          selectedSlot:AddAnchor("TOPLEFT", stampIcon, 1, 1)
          selectedSlot:Show(false)
          wnd.selected[i] = selectedSlot
          local appliedSlot = scrollWnd.emptyWidget:CreateDrawable(TEXTURE_PATH.APPELLATION_STAMP_APPLIED, "icon_selected", "overlay")
          appliedSlot:AddAnchor("TOPLEFT", stampIcon, 1, 1)
          appliedSlot:Show(false)
          wnd.applied[i] = appliedSlot
        end
      end
    end
    for i = 1, #stamps do
      do
        local stamp = stamps[i]
        local btn = wnd.btns[i]
        local selected = wnd.selected[i]
        local applied = wnd.applied[i]
        if stamp.path ~= nil then
          F_SLOT.SetItemIcons(wnd.btns[i], stamp.path)
        end
        if stamp.id ~= nil and myStampInfo.id ~= nil and stamp.id == myStampInfo.id then
          ResetAppliedStamps()
          applied:Show(true)
        end
        if levelInfo.level < stamp.reqlevel then
          btn.limitLevel:Show(true)
          btn.limitLevel:SetText(tostring(stamp.reqlevel))
          btn:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.RED)
        elseif stamp.canEquip == 0 then
          btn.limitLevel:Show(false)
          btn:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.RED)
        else
          btn.limitLevel:Show(false)
          btn:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.NONE)
        end
        function btn:OnClick(arg)
          if arg == "LeftButton" then
            if levelInfo.level < stamp.reqlevel then
              return
            end
            ResetSelectedStamps()
            selected:Show(true)
            selectStampId = stamp.id
            if selectStampId == nil or selectStampId == myStampInfo.id then
              window.stampApplyBtn:Enable(false)
            else
              window.stampApplyBtn:Enable(true)
            end
          end
        end
        btn:SetHandler("OnClick", btn.OnClick)
        if stamp.id ~= 0 then
          btn:SetTooltip(stamp, self)
        end
        for j = 1, #stamp.modifier do
          local unitmodifier = stamp.modifier[j]
        end
      end
    end
    window.stampApplyBtn:Enable(false)
    scrollWnd.scroll:SetEnable(count > wnd.minStampNum)
    scrollWnd.scroll.vs.thumb:Show(count > wnd.minStampNum)
  end
  local function ApplyStamp()
    local item = X2Player:GetStampChangeItemInfo()
    if item == nil or item.itemType == nil or item.itemType == 0 or selectStampId == 0 then
      X2Player:SetAppellationStamp(selectStampId)
      return
    end
    local function DialogHandler(wnd)
      wnd:SetTitle(GetUIText(COMMON_TEXT, "change_stamp"))
      wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "appellation_change_desc"))
      local data = {
        itemInfo = X2Item:GetItemInfoByType(item.itemType),
        stack = {
          item.has,
          item.need
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
      function wnd:OkProc()
        X2Player:SetAppellationStamp(selectStampId)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
  end
  window.stampApplyBtn:SetHandler("OnClick", ApplyStamp)
  function window.stampCalcelBtn:OnClick(arg)
    if arg == "LeftButton" then
      window.stampWnd:Show(false)
    end
  end
  window.stampCalcelBtn:SetHandler("OnClick", window.stampCalcelBtn.OnClick)
  function window:OnTabSelected(selected)
    self:UpdateAll()
  end
  function window:UpdateAll()
    window:ResetRadioBtns(2)
    window:ResetRadioBtns(3)
    window.selectedNameType = nil
    window.selectedEffectType = nil
    window:UpdateMyInfo()
    local prevScrollIndex = window.listWnd.topDataIndex
    local prevPageIndex = window.listWnd:GetCurrentPageIndex()
    window.listWnd.pageControl:SetCurrentPage(prevPageIndex, true)
    window.listWnd:ScrollToDataIndex(prevScrollIndex, 1)
    window.routeDesc:SetText("")
    window:ResetSelects()
    window.clickedType = nil
    window.popupBtn:Enable(false)
    window.stampWnd:Show(false)
  end
  function window.stampWnd:ShowProc()
    window:UpdateStamps()
  end
  local function ApplyAppellation()
    if window.selectedNameType == nil or window.selectedEffectType == nil then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "appellation_cannot_change"))
      return
    end
    local showingInfo = X2Player:GetShowingAppellation()
    local effectInfo = X2Player:GetEffectAppellation()
    if showingInfo ~= nil and effectInfo ~= nil and showingInfo[APPELLATION_INFO.TYPE] == window.selectedNameType and effectInfo[APPELLATION_INFO.TYPE] == window.selectedEffectType then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "appellation_cannot_change"))
      return
    end
    local item = X2Player:GetAppellationChangeItemInfo()
    if item == nil or item.itemType == nil or item.itemType == 0 then
      X2Player:ChangeAppellation(window.selectedNameType, window.selectedEffectType)
      return
    end
    local function DialogHandler(wnd)
      wnd:SetTitle(GetUIText(COMMON_TEXT, "appellation_change"))
      wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "appellation_change_desc"))
      local data = {
        itemInfo = X2Item:GetItemInfoByType(item.itemType),
        stack = {
          item.has,
          item.need
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
      function wnd:OkProc()
        X2Player:ChangeAppellation(window.selectedNameType, window.selectedEffectType)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetParent():GetId())
  end
  window.applyBtn:SetHandler("OnClick", ApplyAppellation)
  local function OnHide()
    if not UIParent:GetPermission(UIC_APPELLATION) then
      HideHiddenQuestReport()
    end
    if window.buffWindow:IsVisible() then
      window.buffWindow:Show(false)
    end
  end
  window:SetHandler("OnHide", OnHide)
  local Events = {
    APPELLATION_GAINED = function()
      window:UpdateAll()
    end,
    APPELLATION_CHANGED = function(stringId, isChanged)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      window:UpdateAll()
    end,
    APPELLATION_STAMP_SET = function()
      window.stampWnd:Show(false)
      local stampInfo = X2Player:GetAppellationMyStamp()
      local path = stampInfo.path
      path = string.gsub(path, "Game\\", "")
      window.myinfoSlotStamp:SetTexture(path)
      window.myinfoSlotStamp:Show(true)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    Events[event](...)
  end)
  RegistUIEvent(window, Events)
end
