local WINDOW_WIDTH = 430
local WINDOW_HEIGHT = 720
local CUSTOM_TITLE_HEIGHT = 46
function CreateBlessUthstinWindow(id, parent)
  local window = CreateWindow(id, parent, "bless_uthstin")
  window:SetExtent(WINDOW_WIDTH, WINDOW_HEIGHT)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "bless_uthstin"))
  window.statsTable = {
    "str",
    "dex",
    "sta",
    "int",
    "spi"
  }
  function window:GetStatIconPath(key)
    local StatsImageTable = {
      str = "ui/icon/icon_skill_stat01.dds",
      dex = "ui/icon/icon_skill_stat02.dds",
      sta = "ui/icon/icon_skill_stat04.dds",
      int = "ui/icon/icon_skill_stat03.dds",
      spi = "ui/icon/icon_skill_stat05.dds"
    }
    return StatsImageTable[key]
  end
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("RIGHT", window.titleBar.closeButton, "BOTTOM", -15, -24)
  local function OnEnterGuide()
    SetTooltip(GetCommonText("bless_uthstin_help"), guide)
  end
  guide:SetHandler("OnEnter", OnEnterGuide)
  local OnLeaveGuide = function()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", OnLeaveGuide)
  local itemSlot = CreateItemIconButton("itemSlot", window)
  itemSlot:SetExtent(ICON_SIZE.DEFAULT + 7, ICON_SIZE.DEFAULT + 7)
  itemSlot:RegisterForClicks("RightButton")
  itemSlot:AddAnchor("TOP", window.titleBar, 0, CUSTOM_TITLE_HEIGHT + 27)
  local itemName = window:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetExtent(WINDOW_WIDTH - MARGIN.WINDOW_SIDE * 2, FONT_SIZE.MIDDLE)
  itemName.style:SetAlign(ALIGN_CENTER)
  itemName:AddAnchor("TOP", itemSlot, "BOTTOM", 0, 12)
  local btn_apply = window:CreateChildWidget("button", "btn_apply", 0, true)
  btn_apply:SetText(X2Locale:LocalizeUiText(OPTION_TEXT, "apply"))
  ApplyButtonSkin(btn_apply, BUTTON_BASIC.DEFAULT)
  btn_apply:Enable(false)
  btn_apply:AddAnchor("TOP", itemName, "BOTTOM", 0, 7)
  deco = window:CreateDrawable("ui/character/slot_red.dds", "slot_red", "artwork")
  deco:AddAnchor("CENTER", itemSlot, 0, 18)
  window.deco = deco
  local function CreateTodayUsableItemCountWidget(window, anchorWidget)
    local countWndHeight = 70
    local itemUsableCountWnd = window:CreateChildWidget("emptywidget", "itemUsableCountWnd", 0, true)
    itemUsableCountWnd:Show(true)
    itemUsableCountWnd:SetExtent(WINDOW_WIDTH - 30, countWndHeight)
    itemUsableCountWnd:AddAnchor("TOP", anchorWidget, "BOTTOM", 0, 4)
    local itemUsableCount_bg = CreateContentBackground(itemUsableCountWnd, "TYPE2", "brown")
    itemUsableCount_bg:AddAnchor("TOPLEFT", itemUsableCountWnd, 0, 0)
    itemUsableCount_bg:AddAnchor("BOTTOMRIGHT", itemUsableCountWnd, 0, 0)
    itemUsableCount_bg:SetExtent(itemUsableCountWnd:GetWidth(), itemUsableCountWnd:GetHeight())
    local infoLabel = window:CreateChildWidget("textbox", "infoLabel", 0, true)
    infoLabel:SetExtent(161, FONT_SIZE.MIDDLE)
    infoLabel.style:SetAlign(ALIGN_LEFT)
    infoLabel:AddAnchor("LEFT", itemUsableCountWnd, "LEFT", 14, 0)
    infoLabel:SetText(GetCommonText("bless_uthstin_today_usable_item_count"))
    ApplyTextColor(infoLabel, FONT_COLOR.DEFAULT)
    local dot1 = itemUsableCountWnd:CreateDrawable(TEXTURE_PATH.DINGBAT, "dot", "artwork")
    local normalItemTitleLabel = window:CreateChildWidget("textbox", "normalItemTitleLabel", 0, true)
    normalItemTitleLabel:SetExtent(118, FONT_SIZE.MIDDLE)
    normalItemTitleLabel.style:SetAlign(ALIGN_LEFT)
    normalItemTitleLabel:AddAnchor("LEFT", dot1, "RIGHT", 6, 0)
    normalItemTitleLabel:SetText(GetCommonText("bless_uthstin_normal_item_name"))
    ApplyTextColor(normalItemTitleLabel, FONT_COLOR.DEFAULT)
    local normalItemCountLabel = window:CreateChildWidget("textbox", "normalItemCountLabel", 0, true)
    normalItemCountLabel:SetExtent(69, FONT_SIZE.MIDDLE)
    normalItemCountLabel.style:SetAlign(ALIGN_RIGHT)
    normalItemCountLabel:AddAnchor("RIGHT", normalItemTitleLabel, 73, 0)
    normalItemCountLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "bless_uthstin_normal_item_count", tostring(0), tostring(0)))
    ApplyTextColor(normalItemCountLabel, FONT_COLOR.BLUE)
    local dot2 = itemUsableCountWnd:CreateDrawable(TEXTURE_PATH.DINGBAT, "dot", "artwork")
    local cashItemTitleLabel = window:CreateChildWidget("textbox", "cashItemTitleLabel", 0, true)
    cashItemTitleLabel:SetExtent(118, FONT_SIZE.MIDDLE)
    cashItemTitleLabel.style:SetAlign(ALIGN_LEFT)
    cashItemTitleLabel:AddAnchor("LEFT", dot2, "RIGHT", 6, 0)
    cashItemTitleLabel:SetText(GetCommonText("bless_uthstin_cash_item_name"))
    ApplyTextColor(cashItemTitleLabel, FONT_COLOR.DEFAULT)
    local cashItemCountLabel = window:CreateChildWidget("textbox", "cashItemCountLabel", 0, true)
    cashItemCountLabel.style:SetAlign(ALIGN_RIGHT)
    cashItemCountLabel:AddAnchor("RIGHT", cashItemTitleLabel, 73, 0)
    cashItemCountLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "bless_uthstin_cash_item_count", tostring(0), tostring(0)))
    cashItemCountLabel:SetWidth(cashItemCountLabel:GetLongestLineWidth())
    cashItemCountLabel:SetAutoWordwrap(false)
    cashItemCountLabel:SetAutoResize(true)
    ApplyTextColor(cashItemCountLabel, FONT_COLOR.BLUE)
    local cachItemGuide = W_ICON.CreateGuideIconWidget(itemUsableCountWnd)
    cachItemGuide:AddAnchor("RIGHT", cashItemCountLabel, "LEFT", -2, 0)
    local function OnEnterCashItemGuide()
      local tabNum = window.uthstinPageTabWnd.tab:GetSelectedTab()
      SetTooltip(GetCommonText("bless_uthstin_button_tooltip_cash_item", X2BlessUthstin:GetCashItemNeedCount(tabNum)), cachItemGuide)
    end
    cachItemGuide:SetHandler("OnEnter", OnEnterCashItemGuide)
    local OnLeaveCashItemGuide = function()
      HideTooltip()
    end
    cachItemGuide:SetHandler("OnLeave", OnLeaveCashItemGuide)
    local function CalcAnchorDot()
      local windowHalfHeight = countWndHeight / 2
      local textHeight1 = normalItemTitleLabel:GetTextHeight()
      local textHeight2 = cashItemTitleLabel:GetTextHeight()
      local margin = 10
      if 2 > normalItemTitleLabel:GetLineCount() and 2 > cashItemTitleLabel:GetLineCount() then
        margin = 16
      end
      dot1:AddAnchor("LEFT", infoLabel, "RIGHT", 10, -windowHalfHeight + margin + textHeight1 / 2)
      dot2:AddAnchor("LEFT", infoLabel, "RIGHT", 10, windowHalfHeight - margin - textHeight2 / 2)
    end
    CalcAnchorDot()
  end
  local function CreateRemainStats(window, anchorWidget)
    local remainStatsWnd = window:CreateChildWidget("emptywidget", "remainStatsWnd", 0, true)
    remainStatsWnd:Show(true)
    remainStatsWnd:SetExtent(WINDOW_WIDTH - 30, 40)
    remainStatsWnd:AddAnchor("TOP", anchorWidget, "BOTTOM", 0, 0)
    local remainstatsWnd_bg = CreateContentBackground(remainStatsWnd, "TYPE2", "brown")
    remainstatsWnd_bg:AddAnchor("TOPLEFT", remainStatsWnd, 0, 0)
    remainstatsWnd_bg:AddAnchor("BOTTOMRIGHT", remainStatsWnd, 0, 0)
    remainstatsWnd_bg:SetExtent(remainStatsWnd:GetWidth(), remainStatsWnd:GetHeight())
    local label_stats_max_point = window:CreateChildWidget("textbox", "label_stats_max_point", 0, true)
    label_stats_max_point:SetExtent(183, FONT_SIZE.MIDDLE)
    label_stats_max_point.style:SetAlign(ALIGN_LEFT)
    label_stats_max_point:AddAnchor("LEFT", remainStatsWnd, "LEFT", 14, 0)
    label_stats_max_point:SetText(GetCommonText("bless_uthstin_inc_max_stats"))
    ApplyTextColor(label_stats_max_point, FONT_COLOR.DEFAULT)
    local stats_max_point = window:CreateChildWidget("textbox", "stats_max_point", 0, true)
    stats_max_point:SetExtent(MARGIN.WINDOW_SIDE * 4, FONT_SIZE.MIDDLE)
    stats_max_point.style:SetAlign(ALIGN_LEFT)
    stats_max_point:AddAnchor("LEFT", label_stats_max_point, "RIGHT", 13, 0)
    stats_max_point:SetText(string.format("%s%s / %s%d", FONT_COLOR_HEX.BLUE, tostring(0), FONT_COLOR_HEX.GREEN, tostring(0)))
    ApplyTextColor(stats_max_point, FONT_COLOR.BLUE)
    local btn_stats_inc_max = window:CreateChildWidget("button", "btn_stats_inc_max", 0, true)
    btn_stats_inc_max:AddAnchor("RIGHT", remainStatsWnd, -9, 0)
    btn_stats_inc_max:Show(true)
    ApplyButtonSkin(btn_stats_inc_max, BUTTON_CONTENTS.UTHSTIN_STAT_MAX_EXPAND)
    local function OnEnterButtonIncreaseMax()
      local text = GetCommonText("bless_uthstin_button_tooltip_increase_max")
      SetTooltip(text, btn_stats_inc_max)
    end
    btn_stats_inc_max:SetHandler("OnEnter", OnEnterButtonIncreaseMax)
    local OnLeaveButtonIncreaseMax = function()
      HideTooltip()
    end
    btn_stats_inc_max:SetHandler("OnLeave", OnLeaveButtonIncreaseMax)
  end
  local function CreateUthstinPageTab(window, anchorWidget)
    local uthstinPageTabWnd = window:CreateChildWidget("emptywidget", "uthstinPageTabWnd", 0, true)
    uthstinPageTabWnd:Show(true)
    uthstinPageTabWnd:SetExtent(WINDOW_WIDTH - 40, 30)
    uthstinPageTabWnd:AddAnchor("TOP", anchorWidget, "BOTTOM", 0, 4)
    local tabs = {
      "1",
      "2",
      "3"
    }
    local tab = W_BTN.CreateTab("tab", uthstinPageTabWnd, "uthstin_page_tab")
    tab:AddAnchor("TOPLEFT", uthstinPageTabWnd, 0, 0)
    tab:AddAnchor("BOTTOMRIGHT", uthstinPageTabWnd, 0, 0)
    tab:SetCorner("TOPLEFT")
    tab:AddTabs(tabs)
    local btn_expand = window:CreateChildWidget("button", "btn_expand", 0, true)
    btn_expand:SetText("+")
    ApplyButtonSkin(btn_expand, BUTTON_BASIC.TAB_UNSELECT)
    btn_expand:AddAnchor("BOTTOMLEFT", tab.selectedButton[3], tab.selectedButton[3]:GetWidth(), 0)
    btn_expand:SetInset(13, 0, 13, 0)
    btn_expand:SetExtent(27, 25)
    btn_expand:Enable(true)
    btn_expand:Show(true)
    local OnEnterButtonExpand = function(self)
      SetTooltip(GetCommonText("expand_slot_count"), self)
    end
    btn_expand:SetHandler("OnEnter", OnEnterButtonExpand)
    local OnLeaveButtonExpand = function()
      HideTooltip()
    end
    btn_expand:SetHandler("OnLeave", OnLeaveButtonExpand)
    uthstinPageCheck = uthstinPageTabWnd:CreateDrawable(BUTTON_TEXTURE_PATH.UTHSTIN_STAT_MAX_EXPAND, "check", "overlay")
    uthstinPageCheck:AddAnchor("TOPRIGHT", tab.selectedButton[3], 0, 0)
    uthstinPageTabWnd.uthstinPageCheck = uthstinPageCheck
    local preview_text = window:CreateChildWidget("textbox", "preview_text", 0, true)
    preview_text:SetExtent(187, FONT_SIZE.MIDDLE)
    preview_text.style:SetAlign(ALIGN_RIGHT)
    preview_text:AddAnchor("RIGHT", uthstinPageTabWnd, 0, 0)
    preview_text:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "bless_uthstin_preview"))
    ApplyTextColor(preview_text, FONT_COLOR.BLUE)
  end
  local function CreateApplicableWidget(window, anchorWidget)
    local applicablestatsWnd = window:CreateChildWidget("emptywidget", "applicablestatsWnd", 0, true)
    applicablestatsWnd:Show(true)
    applicablestatsWnd:SetExtent(WINDOW_WIDTH - 30, 39)
    applicablestatsWnd:AddAnchor("TOP", anchorWidget, "BOTTOM", 0, 3)
    local applicablestats_bg = CreateContentBackground(applicablestatsWnd, "TYPE2", "brown")
    applicablestats_bg:AddAnchor("TOPLEFT", applicablestatsWnd, 0, 0)
    applicablestats_bg:AddAnchor("BOTTOMRIGHT", applicablestatsWnd, 0, 0)
    applicablestats_bg:SetExtent(applicablestatsWnd:GetWidth(), applicablestatsWnd:GetHeight())
    local applicablestatsLabel = window:CreateChildWidget("textbox", "applicablestatsLabel", 0, true)
    applicablestatsLabel:SetExtent(170, FONT_SIZE.MIDDLE)
    applicablestatsLabel.style:SetAlign(ALIGN_LEFT)
    applicablestatsLabel:AddAnchor("LEFT", applicablestatsWnd, 14, 0)
    applicablestatsLabel:SetText(GetCommonText("bless_uthstin_applicable_stats"))
    ApplyTextColor(applicablestatsLabel, FONT_COLOR.DEFAULT)
    local applicablestatsDec = window:CreateChildWidget("textbox", "applicablestatsDec", 0, true)
    applicablestatsDec:SetExtent(MARGIN.WINDOW_SIDE * 2, FONT_SIZE.MIDDLE)
    applicablestatsDec.style:SetAlign(ALIGN_RIGHT)
    applicablestatsDec:AddAnchor("RIGHT", applicablestatsWnd, "RIGHT", -50, 0)
    applicablestatsDec:SetText("-0")
    ApplyTextColor(applicablestatsDec, FONT_COLOR.RED)
    local applicablestatsInc = window:CreateChildWidget("textbox", "applicablestatsInc", 0, true)
    applicablestatsInc:SetExtent(MARGIN.WINDOW_SIDE * 2, FONT_SIZE.MIDDLE)
    applicablestatsInc.style:SetAlign(ALIGN_RIGHT)
    applicablestatsInc:AddAnchor("RIGHT", applicablestatsDec, "LEFT", -30, 0)
    applicablestatsInc:SetText("+0")
    ApplyTextColor(applicablestatsInc, FONT_COLOR.BLUE)
  end
  local CreateStatInfoSet = function(window, anchorWidget)
    for i = 1, #window.statsTable do
      local keyWord = window.statsTable[i]
      local stat_name_txt = X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, keyWord)
      local icon_frame = CreateItemIconButton("icon_frame_" .. keyWord, window)
      icon_frame:SetExtent(44, 44)
      icon_frame:AddAnchor("TOPLEFT", anchorWidget, "BOTTOMLEFT", 15, 5 + 49 * (i - 1))
      local icon_image = window:CreateImageDrawable(window:GetStatIconPath(keyWord), "overlay")
      icon_image:SetCoords(0, 0, 40, 40)
      icon_image:SetExtent(40, 40)
      icon_image:AddAnchor("TOPLEFT", icon_frame, 2, 2)
      icon_image:SetVisible(true)
      local label = window:CreateChildWidget("textbox", "stat_name_" .. keyWord, 0, true)
      label:SetExtent(170, FONT_SIZE.MIDDLE)
      label.style:SetAlign(ALIGN_LEFT)
      label:AddAnchor("LEFT", icon_frame, "RIGHT", 8, 0)
      label:SetText(stat_name_txt)
      ApplyTextColor(label, FONT_COLOR.BROWN)
      local stat_result = window:CreateChildWidget("textbox", "stat_result_" .. keyWord, 0, true)
      stat_result:SetExtent(MARGIN.WINDOW_SIDE * 2, FONT_SIZE.MIDDLE)
      stat_result.style:SetAlign(ALIGN_LEFT)
      stat_result:AddAnchor("LEFT", label, "RIGHT", 30, 0)
      stat_result:SetText("0")
      ApplyTextColor(stat_result, FONT_COLOR.BROWN)
      local stat_detail = window:CreateChildWidget("textbox", "stat_detail_" .. keyWord, 0, true)
      stat_detail:SetExtent(MARGIN.WINDOW_SIDE * 3 + 15, FONT_SIZE.MIDDLE)
      stat_detail:AddAnchor("LEFT", stat_result, "RIGHT", 30, 0)
      stat_detail.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(stat_detail, FONT_COLOR.BLUE)
      stat_detail:SetText("(+0)")
    end
  end
  CreateTodayUsableItemCountWidget(window, window.btn_apply)
  CreateRemainStats(window, window.itemUsableCountWnd)
  CreateUthstinPageTab(window, window.remainStatsWnd)
  CreateApplicableWidget(window, window.uthstinPageTabWnd)
  CreateStatInfoSet(window, window.applicablestatsWnd)
  local btn_init = window:CreateChildWidget("button", "btn_init", 0, true)
  btn_init:AddAnchor("BOTTOMLEFT", window, MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  btn_init:SetText(GetCommonText("init"))
  ApplyButtonSkin(btn_init, BUTTON_BASIC.DEFAULT)
  btn_init:Enable(false)
  btn_init:Show(true)
  local function OnEnterButtonInit()
    local item = X2BlessUthstin:GetBlessUthstinInitItemInfo()
    local itemInfo = X2Item:GetItemInfoByType(item.itemType)
    local text = GetCommonText("bless_uthstin_button_tooltip_init", itemInfo.name, item.need, item.has)
    SetTooltip(text, btn_init)
  end
  btn_init:SetHandler("OnEnter", OnEnterButtonInit)
  local OnLeaveButtonInit = function()
    HideTooltip()
  end
  btn_init:SetHandler("OnLeave", OnLeaveButtonInit)
  local btn_copy = window:CreateChildWidget("button", "btn_copy", 0, true)
  btn_copy:AddAnchor("LEFT", btn_init, "RIGHT", 0, 0)
  btn_copy:SetText(GetCommonText("copy"))
  ApplyButtonSkin(btn_copy, BUTTON_BASIC.DEFAULT)
  btn_copy:Enable(false)
  btn_copy:Show(true)
  local function OnEnterButtonCopy()
    local text = GetCommonText("bless_uthstin_button_tooltip_copy")
    SetTooltip(text, btn_copy)
  end
  btn_copy:SetHandler("OnEnter", OnEnterButtonCopy)
  local OnLeaveButtonCopy = function()
    HideTooltip()
  end
  btn_copy:SetHandler("OnLeave", OnLeaveButtonCopy)
  local btn_activate_tab = window:CreateChildWidget("button", "btn_activate_tab", 0, true)
  btn_activate_tab:AddAnchor("BOTTOMRIGHT", window, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  btn_activate_tab:SetText(GetCommonText("bless_uthstin_activation"))
  ApplyButtonSkin(btn_activate_tab, BUTTON_BASIC.DEFAULT)
  btn_activate_tab:Enable(false)
  btn_activate_tab:Show(true)
  local function OnEnterButtonActivate()
    local text = GetCommonText("bless_uthstin_button_tooltip_activate")
    SetTooltip(text, btn_activate_tab)
  end
  btn_activate_tab:SetHandler("OnEnter", OnEnterButtonActivate)
  local OnLeaveButtonActivate = function()
    HideTooltip()
  end
  btn_activate_tab:SetHandler("OnLeave", OnLeaveButtonActivate)
  local label_description = window:CreateChildWidget("textbox", "label_description", 0, true)
  label_description:SetExtent(391, FONT_SIZE.MIDDLE)
  label_description.style:SetAlign(ALIGN_CENTER)
  label_description:AddAnchor("BOTTOMLEFT", btn_init, "TOPLEFT", 0, -15)
  label_description:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "bless_uthstin_explain"))
  ApplyTextColor(label_description, FONT_COLOR.GRAY)
  function window:ApplyDialogActivationPage(dialog, infos)
    local titleContent = dialog:CreateChildWidget("textbox", "titleContent", 0, true)
    titleContent:SetWidth(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH)
    titleContent:AddAnchor("TOP", dialog, 0, MARGIN.WINDOW_TITLE)
    titleContent:SetAutoResize(true)
    titleContent:SetText(GetCommonText("bless_uthstin_acitvation_popup_desc"))
    ApplyTextColor(titleContent, FONT_COLOR.DEFAULT)
    local iconsOffset = 0
    local iconsFirstOffset = 40
    local iconsFrameSize = 44
    local iconCount = 0
    for key, value in next, infos.stats, nil do
      iconsOffset = iconsFirstOffset + (iconsFrameSize + 5) * iconCount
      iconCount = iconCount + 1
      local label = dialog:CreateChildWidget("textbox", "stat_label_" .. key, 0, true)
      label:SetExtent(95, FONT_SIZE.MIDDLE)
      label.style:SetAlign(ALIGN_LEFT)
      label:AddAnchor("TOP", titleContent, "BOTTOM", 0, iconsOffset)
      label:SetAutoResize(true)
      label:SetText(X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, key))
      ApplyTextColor(label, FONT_COLOR.BROWN)
      local icon_frame = CreateItemIconButton("icon_frame_" .. key, dialog)
      icon_frame:SetExtent(iconsFrameSize, iconsFrameSize)
      icon_frame:AddAnchor("RIGHT", label, "LEFT", -16, 0)
      local icon_image = dialog:CreateImageDrawable(self:GetStatIconPath(key), "overlay")
      icon_image:SetCoords(0, 0, 40, 40)
      icon_image:SetExtent(40, 40)
      icon_image:AddAnchor("CENTER", icon_frame, 0, 0)
      icon_image:SetVisible(true)
      local stat_result = dialog:CreateChildWidget("textbox", "stat_result_" .. key, 0, true)
      stat_result:SetExtent(MARGIN.WINDOW_SIDE * 2, FONT_SIZE.MIDDLE)
      stat_result.style:SetAlign(ALIGN_LEFT)
      stat_result:AddAnchor("LEFT", label, "RIGHT", 7, 0)
      if value < 0 then
        stat_result:SetText(string.format("%s%d", FONT_COLOR_HEX.RED, value))
      elseif value > 0 then
        stat_result:SetText(string.format("%s+%d", FONT_COLOR_HEX.BLUE, value))
      else
        stat_result:SetText(string.format("%s%d", FONT_COLOR_HEX.BLUE, value))
      end
    end
    dialog.textbox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 35)
    dialog.textbox.style:SetAlign(ALIGN_CENTER)
    dialog.textbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    dialog.textbox:SetAutoResize(true)
    dialog.textbox:AddAnchor("TOP", titleContent, "BOTTOM", 0, iconsOffset + iconsFrameSize + 14)
    ApplyTextColor(dialog.textbox, FONT_COLOR.DEFAULT)
    local bg = dialog.textbox:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
    bg:SetTextureColor("default")
    bg:SetWidth(170)
    bg:AddAnchor("CENTER", dialog.textbox, 0, 0)
    local cost = tonumber(infos.selectCost)
    dialog:SetTitle(GetCommonText("bless_uthstin_acitvation_popup_title"))
    dialog:SetContent(string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], cost))
    local function OnEnterOk()
      if tonumber(infos.selectCost) > tonumber(X2Util:GetMyMoneyString()) then
        SetTooltip(GetCommonText("bless_uthstin_message_not_enough_money"), dialog.btnOk)
      end
    end
    dialog.btnOk:SetHandler("OnEnter", OnEnterOk)
    local OnLeaveOk = function()
      HideTooltip()
    end
    dialog.btnOk:SetHandler("OnLeave", OnLeaveOk)
    dialog.btnOk:Enable(cost <= tonumber(X2Util:GetMyMoneyString()))
  end
  function window:SetDialogExpandPage(dialog)
    local maxPageCount = X2BlessUthstin:GetMaxPageCount()
    local curPageCount = X2BlessUthstin:GetPageCount()
    dialog:SetTitle(GetUIText(COMMON_TEXT, "expand_slot_count"))
    dialog:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "bless_uthstin_expand_popup_desc"))
    local changeData = {
      titleInfo = {
        title = GetUIText(COMMON_TEXT, "add_slot_count")
      },
      left = {
        UpdateValueFunc = function(leftValueWidget)
          leftValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(curPageCount)))
        end
      },
      right = {
        UpdateValueFunc = function(rightValueWidget)
          rightValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(curPageCount + 1)))
        end
      }
    }
    dialog:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeData", changeData)
    local itemType, requireItemInfo, hasCount, needCount = X2BlessUthstin:GetExpandItemInfo()
    local itemData = {
      itemInfo = requireItemInfo,
      stack = {hasCount, needCount}
    }
    dialog:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
    local textData = {
      type = "default",
      text = GetUIText(COMMON_TEXT, "expandable_count", tostring(maxPageCount - curPageCount))
    }
    dialog:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "textData", textData)
  end
  function window:ApplyDialogCopy(dialog, previewPageNum)
    local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
    local titleContent = dialog:CreateChildWidget("textBox", "titleContent", 0, true)
    titleContent:SetExtent(dialog:GetWidth() - sideMargin * 2, FONT_SIZE.MIDDLE * 3)
    titleContent.style:SetAlign(ALIGN_CENTER)
    titleContent:SetAutoResize(true)
    titleContent:AddAnchor("TOP", dialog.titleBar, "BOTTOM", 0, 0)
    titleContent:SetText(GetUIText(COMMON_TEXT, "bless_uthstin_copy_popup_desc", FONT_COLOR_HEX.RED))
    ApplyTextColor(titleContent, FONT_COLOR.BROWN)
    local maxPageCount = X2BlessUthstin:GetMaxPageCount()
    local radioTexts = {}
    for i = 1, maxPageCount do
      if 0 < X2BlessUthstin:GetTotalAppliedStats(i) then
        local item = {
          text = GetUIText(COMMON_TEXT, "bless_uthstin_copy_popup_tab_name_selected", tostring(i)),
          value = i
        }
        table.insert(radioTexts, item)
      else
        local item = {
          text = GetUIText(COMMON_TEXT, "bless_uthstin_copy_popup_tab_name", tostring(i)),
          value = i
        }
        table.insert(radioTexts, item)
      end
    end
    local radioBoxes = CreateRadioGroup("radioBoxes", dialog, "vertical")
    radioBoxes:AddAnchor("TOP", titleContent, "BOTTOM", 0, 15)
    radioBoxes:SetWidth(dialog:GetWidth() - sideMargin * 2)
    radioBoxes:SetData(radioTexts)
    dialog.radio = radioBoxes
    local pageCount = X2BlessUthstin:GetPageCount()
    local curPreviewPageNum = self.uthstinPageTabWnd.tab:GetSelectedTab()
    for i = 1, maxPageCount do
      if i > pageCount or i == curPreviewPageNum then
        radioBoxes:EnableIndex(i, false)
      end
    end
    function radioBoxes:OnRadioChanged(index, dataValue)
      local cost = X2BlessUthstin:GetCopyCost()["page" .. tostring(previewPageNum)]
      dialog.btnOk:Enable(tonumber(cost) <= tonumber(X2Util:GetMyMoneyString()))
    end
    radioBoxes:SetHandler("OnRadioChanged", radioBoxes.OnRadioChanged)
    local radioBg = CreateContentBackground(radioBoxes, "TYPE2", "brown")
    radioBg:AddAnchor("TOPLEFT", radioBoxes, -5, -5)
    radioBg:AddAnchor("BOTTOMRIGHT", radioBoxes, 5, 5)
    dialog.textbox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, 35)
    dialog.textbox.style:SetAlign(ALIGN_CENTER)
    dialog.textbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    dialog.textbox:SetAutoResize(true)
    dialog.textbox:AddAnchor("TOP", radioBoxes, "BOTTOM", 0, 20)
    ApplyTextColor(dialog.textbox, FONT_COLOR.DEFAULT)
    local bg = dialog.textbox:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "price_bg", "background")
    bg:SetTextureColor("default")
    bg:SetHeight(29)
    bg:SetWidth(170)
    bg:AddAnchor("CENTER", dialog.textbox, 0, 0)
    dialog:SetTitle(GetCommonText("bless_uthstin_copy_popup_title"))
    local cost = X2BlessUthstin:GetCopyCost()["page" .. tostring(previewPageNum)]
    cost = cost ~= nil and tonumber(cost) or 0
    dialog:SetContent(string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], cost))
    local function OnEnterOk()
      if cost > tonumber(X2Util:GetMyMoneyString()) then
        SetTooltip(GetCommonText("bless_uthstin_message_not_enough_money"), dialog.btnOk)
      end
    end
    dialog.btnOk:SetHandler("OnEnter", OnEnterOk)
    local OnLeaveOk = function()
      HideTooltip()
    end
    dialog.btnOk:SetHandler("OnLeave", OnLeaveOk)
    dialog.btnOk:Enable(false)
  end
  return window
end
function CreateApplyStatsWnd()
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow("applyStatsWnd", "UIParent")
  wnd:SetExtent(430, 273)
  wnd:AddAnchor("CENTER", "UIParent", 0, 0)
  wnd:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "bless_uthstin"))
  local ICON_OFFSET = 10
  local textbox = wnd:CreateChildWidget("textbox", "textbox", 0, true)
  textbox:SetExtent(wnd:GetWidth() - 40, FONT_SIZE.MIDDLE)
  textbox.style:SetAlign(ALIGN_CENTER)
  textbox:SetAutoResize(true)
  textbox:AddAnchor("TOP", wnd.titleBar, "BOTTOM", 0, 5)
  textbox:SetText(GetCommonText("bless_uthstin_will_apply_notice1"))
  ApplyTextColor(textbox, FONT_COLOR.BROWN)
  local textbox2 = wnd:CreateChildWidget("textbox", "textbox2", 0, true)
  textbox2:SetExtent(textbox:GetExtent())
  textbox2.style:SetAlign(ALIGN_CENTER)
  textbox2:SetAutoResize(true)
  textbox2:AddAnchor("TOP", wnd.textbox, "BOTTOM", 0, 14)
  textbox2:SetText(GetCommonText("bless_uthstin_will_apply_notice2"))
  ApplyTextColor(textbox2, FONT_COLOR.RED)
  wnd:SetExtent(430, 273 + textbox:GetHeight() + textbox2:GetHeight() - FONT_SIZE.MIDDLE)
  local label_stats_inc = wnd:CreateChildWidget("label", "label_stats_inc", 0, true)
  label_stats_inc:SetAutoResize(true)
  label_stats_inc:SetExtent(50, FONT_SIZE.MIDDLE)
  label_stats_inc.style:SetAlign(ALIGN_CENTER)
  label_stats_inc:AddAnchor("TOP", wnd.textbox2, "BOTTOM", 20, 35)
  label_stats_inc:SetText(X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "str"))
  label_stats_inc.style:SetEllipsis(true)
  ApplyTextColor(label_stats_inc, FONT_COLOR.BROWN)
  local label_stats_dec = wnd:CreateChildWidget("label", "label_stats_dec", 0, true)
  label_stats_dec:SetAutoResize(true)
  label_stats_dec:SetExtent(50, FONT_SIZE.MIDDLE)
  label_stats_dec.style:SetAlign(ALIGN_CENTER)
  label_stats_dec:AddAnchor("TOP", label_stats_inc, "BOTTOM", 0, 35)
  label_stats_dec:SetText(X2Locale:LocalizeUiText(ATTRIBUTE_TEXT, "dex"))
  label_stats_dec.style:SetEllipsis(true)
  ApplyTextColor(label_stats_dec, FONT_COLOR.BROWN)
  wnd.itemIcon = {}
  local stats_inc = CreateItemIconButton("stats_inc", wnd)
  stats_inc:SetExtent(44, 44)
  stats_inc:AddAnchor("RIGHT", label_stats_inc, "LEFT", -20, 0)
  wnd.itemIcon[1] = wnd:CreateImageDrawable("ui/icon/icon_skill_stat01.dds", "overlay")
  wnd.itemIcon[1]:SetCoords(0, 0, 40, 40)
  wnd.itemIcon[1]:SetExtent(40, 40)
  wnd.itemIcon[1]:AddAnchor("TOPLEFT", stats_inc, 2, 2)
  wnd.itemIcon[1]:SetVisible(true)
  local stats_dec = CreateItemIconButton("stats_dec", wnd)
  stats_dec:SetExtent(44, 44)
  stats_dec:AddAnchor("RIGHT", label_stats_dec, "LEFT", -20, 0)
  wnd.itemIcon[2] = wnd:CreateImageDrawable("ui/icon/icon_skill_stat01.dds", "overlay")
  wnd.itemIcon[2]:SetCoords(0, 0, 40, 40)
  wnd.itemIcon[2]:SetExtent(40, 40)
  wnd.itemIcon[2]:AddAnchor("TOPLEFT", stats_dec, 2, 2)
  wnd.itemIcon[2]:SetVisible(true)
  local label_inc_point = wnd:CreateChildWidget("textbox", "label_inc_point", 0, true)
  label_inc_point:SetExtent(50, FONT_SIZE.MIDDLE)
  label_inc_point.style:SetAlign(ALIGN_LEFT)
  label_inc_point:AddAnchor("LEFT", label_stats_inc, "RIGHT", 5, 0)
  label_inc_point:SetText("+0")
  ApplyTextColor(label_inc_point, FONT_COLOR.BLUE)
  local label_dec_point = wnd:CreateChildWidget("textbox", "label_dec_point", 0, true)
  label_dec_point:SetExtent(50, FONT_SIZE.MIDDLE)
  label_dec_point.style:SetAlign(ALIGN_LEFT)
  label_dec_point:AddAnchor("LEFT", label_stats_dec, "RIGHT", 5, 0)
  label_dec_point:SetText("-0")
  ApplyTextColor(label_dec_point, FONT_COLOR.RED)
  local cancelButton = wnd:CreateChildWidget("button", "cancelButton", 0, true)
  cancelButton:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOM", wnd, "BOTTOM", cancelButton:GetWidth() / 2 + 5, -sideMargin)
  local okButton = wnd:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.pet.okButton)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("RIGHT", cancelButton, "LEFT", -5, 0)
  local function SetItemInfo(index, statsTexture, statsName, point)
    wnd.itemIcon[index]:SetTexture(statsTexture)
    if index == 1 then
      label_stats_inc:SetText(statsName)
      if label_stats_inc:GetWidth() < 50 then
        label_stats_inc:SetAutoResize(false)
        label_stats_inc:SetWidth(50)
      elseif label_stats_inc:GetWidth() > 273 then
        label_stats_inc:SetAutoResize(false)
        label_stats_inc:SetWidth(273)
      end
      label_inc_point:SetText("+" .. tostring(point))
    else
      label_stats_dec:SetText(statsName)
      if label_stats_dec:GetWidth() < 50 then
        label_stats_dec:SetAutoResize(false)
        label_stats_dec:SetWidth(50)
      elseif label_stats_dec:GetWidth() > 273 then
        label_stats_dec:SetAutoResize(false)
        label_stats_dec:SetWidth(273)
      end
      label_dec_point:SetText("-" .. tostring(point))
    end
  end
  function wnd:SetContentEx(incstatsTexture, decstatsTexture, incstatsName, destatsName, incpoint, decpoint)
    SetItemInfo(1, incstatsTexture, incstatsName, incpoint)
    SetItemInfo(2, decstatsTexture, destatsName, decpoint)
  end
  return wnd
end
