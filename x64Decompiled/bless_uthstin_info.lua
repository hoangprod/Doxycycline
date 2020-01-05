local blessUthstinInfo
local function GetBlessUthstinDefault(key)
  return blessUthstinInfo["default_" .. key]
end
local function GetBlessUthstinApplied(key)
  return blessUthstinInfo["applied_" .. key]
end
local function GetBlessUthstinTotalAppliedStats()
  return blessUthstinInfo.totalappliedStats
end
local function GetBlessUthstinMaxStats()
  return blessUthstinInfo.MaxStats
end
local function GetBlessUthstinApplyCount()
  return blessUthstinInfo.applyCount
end
local function GetBlessUthstinApplySpecialCount()
  return blessUthstinInfo.applySpecialCount
end
local function GetBlessUthstinExtendMaxStatsLimit()
  return blessUthstinInfo.extendMaxStatsLimit
end
local function GetBlessUthstinApplyCountLimit()
  return blessUthstinInfo.applyCountLimit
end
function SetBlessUthstinEventFunction(window)
  local Events = {
    BLESS_UTHSTIN_UPDATE_STATS = function()
      window:Update()
    end,
    BLESS_UTHSTIN_ITEM_SLOT_SET = function(msgapplycountlimit)
      window:SetSlot()
      if msgapplycountlimit ~= nil then
        AddMessageToSysMsgWindow(GetCommonText("bless_uthstin_limit_appy_count"))
      end
    end,
    BLESS_UTHSTIN_ITEM_SLOT_CLEAR = function()
      window:ClearSlot()
    end,
    BLESS_UTHSTIN_WILL_APPLY_STATS = function(skilltype, incStatsKind, decStatsKind, incStatsPoint, decStatsPoint)
      window.willskilltype = skilltype
      window.willincStatsKind = incStatsKind
      window.willdecStatsKind = decStatsKind
      window.willincStatsPoint = incStatsPoint
      window.willdecStatsPoint = decStatsPoint
      window:WillApplyStats()
    end,
    BLESS_UTHSTIN_EXTEND_MAX_STATS = function()
      window:Update()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    Events[event](...)
  end)
  RegistUIEvent(window, Events)
  function window:Update()
    self:UpdateStats()
    self:UpdateTextUthstinMaxStats()
    self:UpdateTabVisible()
    self:UpdateTabPreviewText()
    self:UpdatePageSelectCheckImagePos()
    self:UpdatePageExpandButtonPos()
    self:UpdateButtonCopyEnable()
    self:UpdateButtonInitEnable()
    self:UpdateButtonExtendStatMax()
    self:UpdateButtonActivation()
    self:UpdateLabelUthstinDesc()
    self:UpdateItemCountInfo()
    local tabNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
    X2BlessUthstin:SetPreviewPageNumber(tabNum)
  end
  function window:OnTabChanged(idx)
    self:Update()
    X2BlessUthstin:SetPreviewPageNumber(idx)
    window:ClearSlot()
    X2BlessUthstin:ClearItemSlot()
  end
  function window:UpdateLabelUthstinDesc()
    if GetBlessUthstinApplyCount() >= GetBlessUthstinApplyCountLimit() then
      ApplyTextColor(self.label_description, FONT_COLOR.RED)
      self.label_description:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "bless_uthstin_limit_appy_count"))
    else
      ApplyTextColor(self.label_description, FONT_COLOR.GRAY)
      self.label_description:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "bless_uthstin_explain"))
    end
  end
  function window:UpdateButtonInitEnable()
    if GetBlessUthstinTotalAppliedStats() <= 0 then
      self.btn_init:Enable(false)
    else
      self.btn_init:Enable(true)
    end
  end
  function window:UpdateButtonExtendStatMax()
    if GetBlessUthstinMaxStats() >= GetBlessUthstinExtendMaxStatsLimit() then
      self.btn_stats_inc_max:Enable(false)
    else
      self.btn_stats_inc_max:Enable(true)
    end
  end
  function window:UpdateTextUthstinMaxStats()
    self.stats_max_point:SetText(string.format("%s%d / %s%d", FONT_COLOR_HEX.BLUE, GetBlessUthstinTotalAppliedStats(), FONT_COLOR_HEX.GREEN, GetBlessUthstinMaxStats()))
  end
  function window:UpdateItemCountInfo()
    self.normalItemCountLabel:SetText(GetCommonText("bless_uthstin_normal_item_count", GetBlessUthstinApplyCount(), GetBlessUthstinApplyCountLimit()))
    self.cashItemCountLabel:SetText(GetCommonText("bless_uthstin_cash_item_count", GetBlessUthstinApplySpecialCount()))
  end
  function window:UpdateStats()
    local tabNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
    blessUthstinInfo = X2Unit:GetBlessUthstinInfo("player", tabNum)
    for i = 1, #self.statsTable do
      self:UpdateDefaultStats(self.statsTable[i])
      self:UpdateAppliedStats(self.statsTable[i])
    end
  end
  function window:SetSlot()
    if window:IsVisible() == false then
      window:Update()
      window:Show(true)
    end
    local itemInfo = X2BlessUthstin:GetBlessUthstinItemInfo()
    if itemInfo ~= nil then
      local color = Hex2Dec(itemInfo.gradeColor)
      self.itemName.style:SetColor(color[1], color[2], color[3], color[4])
      self.itemName:SetText(itemInfo.name)
      self.itemSlot:SetItemInfo(itemInfo)
      self.itemSlot:SetStack(itemInfo.hasCount, itemInfo.needCount)
      self.applicablestatsInc:SetText("+" .. tostring(itemInfo.incpoint))
      self.applicablestatsDec:SetText("-" .. tostring(itemInfo.decpoint))
      if itemInfo.itemfunction == 0 then
        self.deco:SetTexture("ui/character/slot_red.dds")
      else
        self.deco:SetTexture("ui/character/slot_blue.dds")
      end
      self.btn_apply:Enable(true)
    else
      self.itemSlot:Init()
      self.itemName:SetText("")
      self.btn_apply:Enable(false)
      window.deco:SetTexture("ui/character/slot_red.dds")
    end
  end
  function window.itemSlot:procOnEnter()
    local info = self:GetInfo()
    if info == nil then
      ShowTextTooltip(self, X2Locale:LocalizeUiText(TOOLTIP_TEXT, "uthstion_item_slot_tooltip_title"), X2Locale:LocalizeUiText(TOOLTIP_TEXT, "uthstion_item_slot_tooltip_desc"), nil)
      return
    end
  end
  function window:ClearSlot()
    self.itemSlot:Init()
    self.itemName:SetText("")
    self.btn_apply:Enable(false)
    self.applicablestatsInc:SetText("+0")
    self.applicablestatsDec:SetText("-0")
    window.deco:SetTexture("ui/character/slot_red.dds")
  end
  function window:UpdateAppliedStats(statsKind)
    local incValue = GetBlessUthstinApplied(statsKind)
    local defaultValue = GetBlessUthstinDefault(statsKind)
    local stats_inc_control = self["stat_detail_" .. statsKind]
    local applyvaluecolor = FONT_COLOR_HEX.BLUE
    local strPlus = "+"
    if tonumber(incValue) < 0 then
      strPlus = ""
      applyvaluecolor = FONT_COLOR_HEX.RED
    end
    stats_inc_control:SetText(string.format("%s(%s %s%s%s%s)", FONT_COLOR_HEX.DEFAULT, defaultValue, applyvaluecolor, strPlus, incValue, FONT_COLOR_HEX.DEFAULT))
  end
  function window:UpdateDefaultStats(statsKind)
    local curValue = GetBlessUthstinApplied(statsKind) + GetBlessUthstinDefault(statsKind)
    local stat_inc_control = self["stat_result_" .. statsKind]
    stat_inc_control:SetText(string.format("%d", curValue))
    ApplyTextColor(stat_inc_control, FONT_COLOR.BROWN)
  end
  function window:UpdateButtonCopyEnable()
    local pageCount = X2BlessUthstin:GetPageCount()
    self.btn_copy:Enable(pageCount > 1)
  end
  function window:UpdateButtonActivation()
    local tabNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
    local activatedPageNum = X2BlessUthstin:GetActivatedPageNumber()
    self.btn_activate_tab:Enable(tabNum ~= activatedPageNum)
  end
  function window:UpdateTabVisible()
    local pageCount = X2BlessUthstin:GetPageCount()
    local tabNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
    for i = 2, X2BlessUthstin:GetMaxPageCount() do
      local selectedTab = tabNum == i
      local isExpandPage = i <= pageCount
      if isExpandPage then
        self.uthstinPageTabWnd.tab.selectedButton[i]:Show(selectedTab)
        self.uthstinPageTabWnd.tab.unselectedButton[i]:Show(not selectedTab)
      else
        self.uthstinPageTabWnd.tab.selectedButton[i]:Show(false)
        self.uthstinPageTabWnd.tab.unselectedButton[i]:Show(false)
      end
    end
  end
  function window:UpdateTabPreviewText()
    local activatedPageNum = X2BlessUthstin:GetActivatedPageNumber()
    local tabNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
    self.preview_text:Show(characetInfoLocale.showPreviewText and tabNum ~= activatedPageNum)
  end
  function window:UpdatePageSelectCheckImagePos()
    local activatedPageNum = X2BlessUthstin:GetActivatedPageNumber()
    local tab = self.uthstinPageTabWnd.tab
    self.uthstinPageTabWnd.uthstinPageCheck:AddAnchor("TOPRIGHT", tab.selectedButton[activatedPageNum], 0, 0)
  end
  function window:UpdatePageExpandButtonPos()
    local pageCount = X2BlessUthstin:GetPageCount()
    if pageCount < X2BlessUthstin:GetMaxPageCount() then
      local tab = self.uthstinPageTabWnd.tab
      self.btn_expand:Show(true)
      self.btn_expand:AddAnchor("BOTTOMLEFT", tab.selectedButton[pageCount], tab.selectedButton[pageCount]:GetWidth(), 0)
    else
      self.btn_expand:Show(false)
    end
  end
  function window.uthstinPageTabWnd.tab:OnTabChangedProc(idx)
    window:OnTabChanged(idx)
  end
  local OpenInitDialog = function(openFromCopyDialog, initTabNumber)
    local function DialogHandler(wnd)
      wnd:SetTitle(GetCommonText("bless_uthstin_init_stats"))
      local content = GetCommonText("bless_uthstin_init_stats_notice")
      if openFromCopyDialog then
        content = GetCommonText("bless_uthstin_init_for_copy")
      end
      wnd:UpdateDialogModule("textbox", content)
      local initInfo = X2BlessUthstin:GetBlessUthstinInitItemInfo()
      local itemData = {
        itemInfo = X2Item:GetItemInfoByType(initInfo.itemType),
        stack = {
          initInfo.has,
          initInfo.need
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
      local textData = {
        type = "warning",
        text = GetCommonText("bless_uthstin_init_stats_warning")
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
      function wnd:OkProc()
        X2BlessUthstin:UseBlessUthstinInitStats(initTabNumber)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
  end
  local function InitButtonLeftClickFunc()
    local initTabNumber = window.uthstinPageTabWnd.tab:GetSelectedTab()
    OpenInitDialog(false, initTabNumber)
  end
  window.btn_init:SetHandler("OnClick", InitButtonLeftClickFunc)
  local function IncMaxButtonLeftClickFunc()
    local DialogHandler = function(wnd)
      wnd:SetTitle(GetUIText(COMMON_TEXT, "bless_uthstin_inc_max_stats2"))
      wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "bless_uthstin_inc_max_notice2"))
      local item = X2BlessUthstin:GetBlessUthstinIncreaseMax()
      local data = {
        itemInfo = X2Item:GetItemInfoByType(item.itemType),
        stack = {
          item.has,
          item.need
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
      function wnd:OkProc()
        X2BlessUthstin:UseBlessUthstinExtendMaxStats()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetParent():GetId())
  end
  window.btn_stats_inc_max:SetHandler("OnClick", IncMaxButtonLeftClickFunc)
  local function OnClickCopy()
    local function DialogHandler(wnd, infoTable)
      local previewPageNum = window.uthstinPageTabWnd.tab:GetSelectedTab()
      window:ApplyDialogCopy(wnd, previewPageNum)
      function wnd:OkProc()
        local pageNum = wnd.radio:GetChecked()
        if pageNum ~= previewPageNum then
          if X2BlessUthstin:GetTotalAppliedStats(pageNum) > 0 then
            OpenInitDialog(true, pageNum)
          else
            X2BlessUthstin:CopyBlessUthstinPage(previewPageNum, pageNum)
          end
        end
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
  end
  window.btn_copy:SetHandler("OnClick", OnClickCopy)
  local function OnClickActivation()
    local function DialogHandler(wnd, infoTable)
      local activatedPageNum = X2BlessUthstin:GetActivatedPageNumber()
      local selectCost = X2BlessUthstin:GetSelectCost()["page" .. tostring(activatedPageNum)]
      local infos = {}
      infos.selectCost = selectCost
      infos.stats = {}
      local valueTable = {}
      for i = 1, #window.statsTable do
        local incValue = GetBlessUthstinApplied(window.statsTable[i])
        infos.stats[window.statsTable[i]] = incValue
      end
      window:ApplyDialogActivationPage(wnd, infos)
      function wnd:OkProc()
        local tabNum = window.uthstinPageTabWnd.tab:GetSelectedTab()
        X2BlessUthstin:SelectBlessUthstinPage(tabNum)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
  end
  window.btn_activate_tab:SetHandler("OnClick", OnClickActivation)
  local function OnClickExpandPage()
    local function DialogHandler(wnd, infoTable)
      window:SetDialogExpandPage(wnd)
      function wnd:OkProc()
        X2BlessUthstin:ExpandBlessUthstinPage()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
  end
  window.btn_expand:SetHandler("OnClick", OnClickExpandPage)
  local ItemButtonLeftClickFunc = function()
    if X2Cursor:GetCursorPickedBagItemIndex() == 0 or X2BlessUthstin:SetBlessUthstinItemSlotFromPick() then
    end
  end
  local ItemButtonRightClickFunc = function()
    X2BlessUthstin:ClearItemSlot()
  end
  ButtonOnClickHandler(window.itemSlot, ItemButtonLeftClickFunc, ItemButtonRightClickFunc)
  local function ApplyStatsButtonClickFunc()
    local errorType
    local itemInfo = X2BlessUthstin:GetBlessUthstinItemInfo()
    if itemInfo ~= nil then
      local defaultStatsTable = {
        "default_str",
        "default_dex",
        "default_sta",
        "default_int",
        "default_spi"
      }
      local appliedStatsTable = {
        "applied_str",
        "applied_dex",
        "applied_sta",
        "applied_int",
        "applied_spi"
      }
      local defaultUnderCount = 0
      local dropStatKindCount = 0
      local dropOnlyOneKind = -1
      for i = 1, #defaultStatsTable do
        if 0 > blessUthstinInfo[defaultStatsTable[i]] + blessUthstinInfo[appliedStatsTable[i]] - itemInfo.decpoint then
          defaultUnderCount = defaultUnderCount + 1
        elseif 0 < itemInfo.weight[i].drop then
          dropStatKindCount = dropStatKindCount + 1
          dropOnlyOneKind = i
        end
      end
      if dropStatKindCount <= 0 then
        errorType = 1
      end
      if dropStatKindCount > 1 then
        dropOnlyOneKind = -1
      end
      if defaultUnderCount > 3 then
        errorType = 1
      end
      if dropOnlyOneKind >= 0 then
        if 0 > blessUthstinInfo[defaultStatsTable[dropOnlyOneKind]] + blessUthstinInfo[appliedStatsTable[dropOnlyOneKind]] - itemInfo.decpoint then
          errorType = 1
        end
        if 0 < itemInfo.weight[dropOnlyOneKind].rise then
          errorType = 2
        end
      end
      if GetBlessUthstinTotalAppliedStats() + itemInfo.incpoint > GetBlessUthstinMaxStats() then
        errorType = 3
      end
      if errorType ~= nil then
        local function DialogHandler(wnd)
          wnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "bless_uthstin"))
          local content
          if errorType == 1 then
            content = GetCommonText("bless_uthstin_cannot_appy")
          elseif errorType == 2 then
            content = GetCommonText("bless_uthstin_wrong_item_data")
          elseif errorType == 3 then
            content = GetCommonText("bless_uthstin_cannot_appy_overflow")
          end
          wnd:SetContent(content)
          function wnd:OkProc()
            wnd:Show(false)
          end
        end
        X2DialogManager:RequestNoticeDialog(DialogHandler, window:GetParent():GetId())
      elseif GetBlessUthstinTotalAppliedStats() >= GetBlessUthstinMaxStats() then
        local DialogHandler = function(wnd)
          wnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "bless_uthstin"))
          local content = GetCommonText("bless_uthstin_cannot_appy_max_stats")
          wnd:SetContent(content)
          function wnd:OkProc()
            wnd:Show(false)
          end
        end
        X2DialogManager:RequestNoticeDialog(DialogHandler, window:GetParent():GetId())
      else
        do
          local tabNum = window.uthstinPageTabWnd.tab:GetSelectedTab()
          local item = X2BlessUthstin:GetApplyStatsItemInfo(tabNum)
          if item == nil then
            return
          end
          local function DialogHandler(wnd)
            wnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "bless_uthstin"))
            wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "bless_uthstin_apply_notice", tostring(item.need)))
            local data = {
              itemInfo = X2Item:GetItemInfoByType(item.itemType),
              stack = {
                item.has,
                item.need
              }
            }
            wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
            function wnd:OkProc()
              X2BlessUthstin:UseApplyStatsItem(tabNum)
            end
          end
          X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetParent():GetId())
        end
      end
    end
  end
  ButtonOnClickHandler(window.btn_apply, ApplyStatsButtonClickFunc)
  function window:WillApplyStats()
    local wnd = CreateApplyStatsWnd()
    wnd:EnableHidingIsRemove(true)
    wnd:Show(true)
    self.popUp = wnd
    self.btn_apply:Enable(false)
    self.btn_init:Enable(false)
    wnd:SetContentEx(self:GetStatIconPath(self.statsTable[self.willincStatsKind]), self:GetStatIconPath(self.statsTable[self.willdecStatsKind]), X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, self.statsTable[self.willincStatsKind]), X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, self.statsTable[self.willdecStatsKind]), self.willincStatsPoint, self.willdecStatsPoint)
    local function WillApplyCancelButtonLeftClickFunc()
      local function DialogHandler(popupwnd)
        popupwnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "bless_uthstin"))
        local content = GetCommonText("bless_uthstin_cancel_apply_notice1")
        content = string.format([[
%s

%s%s]], content, FONT_COLOR_HEX.RED, GetCommonText("bless_uthstin_cancel_apply_notice2"))
        popupwnd:SetContent(content)
        function popupwnd:OkProc()
          local tabNum = window.uthstinPageTabWnd.tab:GetSelectedTab()
          X2BlessUthstin:ApplyStats(false, window.willskilltype, window.willincStatsKind, window.willdecStatsKind, window.willincStatsPoint, window.willdecStatsPoint, tabNum)
          wnd:Show(false)
          window:SetSlot()
          window:Update()
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, "")
    end
    ButtonOnClickHandler(wnd.cancelButton, WillApplyCancelButtonLeftClickFunc)
    local function WillApplyOkButtonLeftClickFunc()
      local tabNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
      X2BlessUthstin:ApplyStats(true, self.willskilltype, self.willincStatsKind, self.willdecStatsKind, self.willincStatsPoint, self.willdecStatsPoint, tabNum)
      wnd:Show(false)
      window:ClearSlot()
    end
    ButtonOnClickHandler(wnd.okButton, WillApplyOkButtonLeftClickFunc)
    local function OnHide()
      self.popUp = nil
      self:UpdateButtonInitEnable()
    end
    wnd:SetHandler("OnHide", OnHide)
  end
  function window:OnHide()
    self.btn_apply:Enable(false)
    self.applicablestatsInc:SetText("+0")
    self.applicablestatsDec:SetText("-0")
    window:ClearSlot()
    if self.popUp ~= nil then
      self.popUp:Show(false)
    end
    X2BlessUthstin:ClearItemSlot()
    X2BlessUthstin:LeaveBlessUthstin()
  end
  window:SetHandler("OnHide", window.OnHide)
  function window:ShowProc()
    X2BlessUthstin:EnterBlessUthstin()
    local activatedPageNum = X2BlessUthstin:GetActivatedPageNumber()
    self.uthstinPageTabWnd.tab:SelectTab(activatedPageNum)
  end
end
