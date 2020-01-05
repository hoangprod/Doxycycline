APPELLATION_INFO = {
  TYPE = 1,
  NAME = 2,
  GRADE = 3,
  ISHAVE = 4,
  ORDER = 5,
  BUFF_INFO = 6
}
APPELLATION_LIST_INFO = {
  LIST_ROW_COUNT = 7,
  COLUMN_HEIGHT = 25,
  LIST_DATA_HEIGHT = 24
}
local LIST_ROW_COUNT = APPELLATION_LIST_INFO.LIST_ROW_COUNT
local COLUMN_HEIGHT = APPELLATION_LIST_INFO.COLUMN_HEIGHT
function CreateAppellation(tabWindow)
  local CreateAppelationInfoFrame = function(tabWindow)
    local myinfoWnd = tabWindow:CreateChildWidget("emptyWidget", "myinfoWnd", 0, true)
    myinfoWnd:Show(true)
    myinfoWnd:SetExtent(772, 120)
    myinfoWnd:AddAnchor("TOP", tabWindow, "TOP", 0, 5)
    tabWindow.myinfoWnd = myinfoWnd
    local myinfoBg = CreateContentBackground(myinfoWnd, "TYPE2", "brown")
    myinfoBg:AddAnchor("TOPLEFT", myinfoWnd, 0, 0)
    myinfoBg:AddAnchor("BOTTOMRIGHT", myinfoWnd, 0, 0)
    local myinfoLabel = tabWindow:CreateChildWidget("textbox", "myinfoLabel", 0, true)
    myinfoLabel:AddAnchor("TOPLEFT", myinfoWnd, 10, 12)
    myinfoLabel:SetExtent(480, FONT_SIZE.MIDDLE)
    myinfoLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myinfoLabel, FONT_COLOR.DEFAULT)
    myinfoLabel:SetText(GetCommonText("my_appellation"))
    myinfoLabel.style:SetAlign(ALIGN_LEFT)
    local guide = W_ICON.CreateGuideIconWidget(tabWindow)
    guide:AddAnchor("TOPRIGHT", myinfoWnd, -guide:GetWidth() * 0.5, guide:GetHeight() * 0.5)
    local function OnEnterGuide()
      SetTooltip(GetCommonText("appellation_help"), guide)
    end
    guide:SetHandler("OnEnter", OnEnterGuide)
    local OnLeaveGuide = function()
      HideTooltip()
    end
    guide:SetHandler("OnLeave", OnLeaveGuide)
    local myinfoLine = CreateLine(myinfoWnd, "TYPE1")
    myinfoLine:AddAnchor("TOPLEFT", myinfoLabel, "BOTTOMLEFT", -10, 5)
    myinfoLine:AddAnchor("TOPRIGHT", myinfoWnd, "BOTTOMRIGHT", 10, 0)
    local myinfoSlot = myinfoWnd:CreateChildWidget("button", "myinfoSlot", 0, true)
    myinfoSlot:AddAnchor("TOPLEFT", myinfoLabel, "BOTTOMLEFT", 5, 12)
    myinfoSlot:SetExtent(50, 50)
    ApplyButtonSkin(myinfoSlot, BUTTON_CONTENTS.APPELLATION_SLOT)
    tabWindow.myinfoSlot = myinfoSlot
    local myinfoSlotStamp = tabWindow:CreateImageDrawable("ui/icon/icon_title_empty.dds", "artwork")
    myinfoSlotStamp:SetCoords(0, 0, 48, 48)
    myinfoSlotStamp:SetExtent(48, 48)
    myinfoSlotStamp:AddAnchor("TOPLEFT", myinfoSlot, 1, 1)
    myinfoSlotStamp:SetVisible(true)
    tabWindow.myinfoSlotStamp = myinfoSlotStamp
    local myinfoTitle = tabWindow:CreateDrawable(TEXTURE_PATH.APPELLATION_SLOT, "icon_title", "artwork")
    myinfoTitle:AddAnchor("TOPLEFT", myinfoSlot, 65, 2)
    local myinfoEffect = tabWindow:CreateDrawable(TEXTURE_PATH.APPELLATION_SLOT, "icon_effect", "artwork")
    myinfoEffect:AddAnchor("TOPLEFT", myinfoSlot, 65, 25)
    local myinfoTitleGrade = tabWindow:CreateDrawable(TEXTURE_PATH.RANKING_GRADE, "normal", "artwork")
    myinfoTitleGrade:AddAnchor("LEFT", myinfoTitle, "RIGHT", 2, 0)
    tabWindow.myinfoTitleGrade = myinfoTitleGrade
    local myinfoEffectGrade = tabWindow:CreateDrawable(TEXTURE_PATH.RANKING_GRADE, "normal", "artwork")
    myinfoEffectGrade:AddAnchor("LEFT", myinfoEffect, "RIGHT", 2, 0)
    tabWindow.myinfoEffectGrade = myinfoEffectGrade
    local myinfoTitleLabel = tabWindow:CreateChildWidget("textbox", "myinfoTitleLabel", 0, true)
    myinfoTitleLabel:AddAnchor("LEFT", myinfoTitleGrade, "RIGHT", 5, 0)
    myinfoTitleLabel:SetExtent(665 - myinfoTitleGrade:GetWidth() - myinfoTitle:GetWidth() - 7, FONT_SIZE.MIDDLE)
    myinfoTitleLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myinfoTitleLabel, FONT_COLOR.DEFAULT)
    myinfoTitleLabel.style:SetAlign(ALIGN_LEFT)
    local myinfoEffectLabel = tabWindow:CreateChildWidget("textbox", "myinfoEffectLabel", 0, true)
    myinfoEffectLabel:AddAnchor("LEFT", myinfoEffectGrade, "RIGHT", 5, 0)
    myinfoEffectLabel:SetExtent(665 - myinfoEffectGrade:GetWidth() - myinfoEffect:GetWidth() - 7, FONT_SIZE.MIDDLE)
    myinfoEffectLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myinfoEffectLabel, FONT_COLOR.DEFAULT)
    myinfoEffectLabel.style:SetAlign(ALIGN_LEFT)
    myinfoEffectLabel.style:SetEllipsis(true)
    local myinfoMyGrade = tabWindow:CreateChildWidget("textbox", "myinfoMyGrade", 0, true)
    myinfoMyGrade:AddAnchor("BOTTOM", myinfoSlot, 0, FONT_SIZE.LARGE + 7)
    myinfoMyGrade:SetExtent(80, FONT_SIZE.LARGE)
    myinfoMyGrade.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(myinfoMyGrade, FONT_COLOR.DEFAULT)
    myinfoMyGrade.style:SetAlign(ALIGN_CENTER)
    myinfoMyGrade:SetText("LEVEL")
    tabWindow.myinfoMyGrade = myinfoMyGrade
    local myinfoExpBar = W_BAR.CreateAppellationBar(tabWindow:GetName() .. ".myinfoExpBar", tabWindow)
    myinfoExpBar:AddAnchor("LEFT", myinfoMyGrade, myinfoMyGrade:GetWidth() + 1, 0)
    myinfoExpBar:SetExtent(655, 14)
    tabWindow.myinfoExpBar = myinfoExpBar
    local effectInfoButton = tabWindow:CreateChildWidget("button", "effectInfoButton", 0, true)
    ApplyButtonSkin(effectInfoButton, BUTTON_BASIC.QUESTION_MARK)
    effectInfoButton:AddAnchor("LEFT", myinfoExpBar, "RIGHT", 4, 0)
    effectInfoButton:Enable(true)
    function effectInfoButton:OnClick()
      tabWindow.buffWindow:Show(not tabWindow.buffWindow:IsVisible())
    end
    effectInfoButton:SetHandler("OnClick", effectInfoButton.OnClick)
    function myinfoSlot:OnClick(arg)
      if arg == "LeftButton" then
        if tabWindow.stampWnd:IsVisible() == false then
          tabWindow.stampWnd:Show(true)
        else
          tabWindow.stampWnd:Show(false)
        end
      end
    end
    myinfoSlot:SetHandler("OnClick", myinfoSlot.OnClick)
  end
  local function CreateAppelationListFrame(tabWindow)
    local listWnd = W_CTRL.CreatePageScrollListCtrl("listWnd", tabWindow)
    listWnd:SetExtent(760, 198)
    listWnd:AddAnchor("TOPLEFT", tabWindow.myinfoWnd, 0, tabWindow.myinfoWnd:GetHeight() + 34)
    tabWindow.listWnd = listWnd
    listWnd.scroll:AddAnchor("TOPRIGHT", listWnd, 0, COLUMN_HEIGHT)
    listWnd.scroll:AddAnchor("BOTTOMRIGHT", listWnd, 0, 0)
    tabWindow.selectedNameType = nil
    tabWindow.selectedEffectType = nil
    tabWindow.clickedType = nil
    local listTitleLabel = tabWindow:CreateChildWidget("textbox", "listTitleLabel", 0, true)
    listTitleLabel:AddAnchor("TOPLEFT", listWnd, 15, -(FONT_SIZE.MIDDLE + 5))
    listTitleLabel:SetExtent(395, FONT_SIZE.MIDDLE)
    ApplyTextColor(listTitleLabel, FONT_COLOR.DEFAULT)
    listTitleLabel.style:SetAlign(ALIGN_LEFT)
    listTitleLabel:SetText(GetCommonText("appellation_list"))
    local listEmptyLabel = tabWindow:CreateChildWidget("textbox", "listEmptyLabel", 0, true)
    listEmptyLabel:AddAnchor("CENTER", listWnd, 0, 0)
    listEmptyLabel:SetExtent(700, FONT_SIZE.MIDDLE * 2)
    ApplyTextColor(listEmptyLabel, FONT_COLOR.DEFAULT)
    listEmptyLabel.style:SetAlign(ALIGN_CENTER)
    listEmptyLabel:SetText(GetCommonText("appellation_empty_guide1"))
    listEmptyLabel:Show(false)
    tabWindow.listEmptyLabel = listEmptyLabel
    local comboBox = W_CTRL.CreateComboBox("comboBox", tabWindow)
    comboBox:SetWidth(196)
    comboBox:AddAnchor("TOPRIGHT", listWnd, -22, -(comboBox:GetHeight() + 5))
    local datas = {}
    local firstData = {
      text = GetCommonText("show_all"),
      value = APPELATION_ROUTE_TYPE_MAX,
      color = FONT_COLOR.DEFAULT,
      disableColor = FONT_COLOR.GRAY,
      useColor = true,
      enable = true
    }
    table.insert(datas, firstData)
    local filterList = X2Player:GetUnitAppellationRouteList()
    for i = 1, #filterList do
      local info = filterList[i]
      if info.value ~= nil and info.value ~= "hidden" then
        local data = {
          text = GetCommonText(info.value),
          value = info.key
        }
        table.insert(datas, data)
      end
    end
    comboBox:AppendItems(datas)
    function tabWindow:ResetRadioBtns(colIndex)
      for i = 1, #tabWindow.listWnd.listCtrl.items do
        subItem = tabWindow.listWnd.listCtrl.items[i].subItems[colIndex]
        subItem.radiobtnImg:SetTextureInfo("radio_button_df")
      end
    end
    function tabWindow:ResetSelects()
      for i = 1, #tabWindow.listWnd.listCtrl.items do
        subItem = tabWindow.listWnd.listCtrl.items[i].subItems[2]
        subItem.selectImage:SetVisible(false)
        subItem = tabWindow.listWnd.listCtrl.items[i].subItems[3]
        subItem.selectImage:SetVisible(false)
      end
    end
    local function NameLayoutFunc(frame, rowIndex, colIndex, subItem)
      subItem.type = nil
      local radiobtn = UIParent:CreateWidget("button", "radiobtn", subItem)
      radiobtn:AddAnchor("TOPLEFT", subItem, 0, 0)
      radiobtn:SetExtent(21, 21)
      subItem.radiobtn = radiobtn
      local line = DrawItemUnderLine(subItem, "overlay")
      line:SetVisible(false)
      line:AddAnchor("TOPLEFT", subItem, "BOTTOMLEFT", -70, 0)
      line:AddAnchor("TOPRIGHT", subItem, "BOTTOMRIGHT", 336, 0)
      subItem.line = line
      local radiobtnImg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "radio_button_df", "overlay")
      radiobtnImg:AddAnchor("TOPLEFT", subItem, 3, 3)
      subItem.radiobtnImg = radiobtnImg
      local name = subItem:CreateChildWidget("label", "name", 0, true)
      name.style:SetAlign(ALIGN_LEFT)
      subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(name, FONT_COLOR.BLUE)
      name:AddAnchor("LEFT", subItem, "LEFT", 20, 0)
      name:AddAnchor("RIGHT", subItem, "RIGHT", 0, 0)
      name.style:SetEllipsis(true)
      local overImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
      overImage:SetTextureColor("bg_02")
      overImage:SetExtent(subItem:GetWidth(), subItem:GetHeight())
      overImage:AddAnchor("TOPLEFT", subItem, -70, 0)
      overImage:AddAnchor("BOTTOMRIGHT", subItem, 336, 0)
      overImage:SetVisible(false)
      subItem.overImage = overImage
      local disableImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
      disableImage:SetExtent(subItem:GetWidth(), subItem:GetHeight())
      disableImage:SetTextureColor("list_dis")
      disableImage:AddAnchor("TOPLEFT", subItem, -70, 0)
      disableImage:AddAnchor("BOTTOMRIGHT", subItem, 336, 0)
      disableImage:SetVisible(false)
      subItem.disableImage = disableImage
      local selectImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
      selectImage:SetExtent(subItem:GetWidth(), subItem:GetHeight())
      selectImage:SetTextureColor("list_ov")
      selectImage:AddAnchor("TOPLEFT", subItem, -70, 0)
      selectImage:AddAnchor("BOTTOMRIGHT", subItem, 336, 0)
      selectImage:SetVisible(false)
      subItem.selectImage = selectImage
      local appliedImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "list_title_select", "background")
      appliedImage:AddAnchor("TOPLEFT", subItem, -70, 0)
      appliedImage:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
      appliedImage:SetTextureColor("default")
      appliedImage:SetVisible(false)
      subItem.appliedImage = appliedImage
      function subItem:OnEnter()
        SetTooltip(name:GetText(), self)
        overImage:SetVisible(true)
      end
      subItem:SetHandler("OnEnter", subItem.OnEnter)
      function subItem:OnLeave()
        HideTooltip()
        overImage:SetVisible(false)
      end
      subItem:SetHandler("OnLeave", subItem.OnLeave)
      function subItem:OnClick(arg)
        if arg == "LeftButton" then
          tabWindow:ResetSelects()
          selectImage:SetVisible(true)
          tabWindow.clickedType = subItem.type
          if subItem.disableImage:IsVisible() == false then
            tabWindow:ResetRadioBtns(2)
            subItem.radiobtnImg:SetCoords(994, 0, 15, 15)
            tabWindow.selectedNameType = subItem.type
          end
          tabWindow:UpdateRouteInfo(subItem.type)
        end
      end
      subItem:SetHandler("OnClick", subItem.OnClick)
      function subItem.radiobtn:OnClick(arg)
        if arg == "LeftButton" then
          tabWindow:ResetSelects()
          selectImage:SetVisible(true)
          if subItem.disableImage:IsVisible() == false then
            tabWindow:ResetRadioBtns(2)
            subItem.radiobtnImg:SetCoords(994, 0, 15, 15)
            tabWindow.selectedNameType = subItem.type
          end
          tabWindow:UpdateRouteInfo(subItem.type)
        end
      end
      subItem.radiobtn:SetHandler("OnClick", subItem.radiobtn.OnClick)
    end
    local function NameDataSetFunc(subItem, data, setValue)
      if setValue then
        subItem.type = data[APPELLATION_INFO.TYPE]
        if data[APPELLATION_INFO.TYPE] ~= nil and data[APPELLATION_INFO.TYPE] ~= 0 then
          subItem.name:SetText(data[APPELLATION_INFO.NAME])
        else
          subItem.name:SetText(GetCommonText("appellation_unable"))
        end
        subItem.radiobtnImg:Show(true)
        if data[APPELLATION_INFO.ISHAVE] == 0 then
          subItem.disableImage:SetVisible(true)
          subItem.line:SetVisible(false)
          ApplyTextColor(subItem.name, ORIGINAL_LIGHT_GRAY_FONT_COLOR)
        else
          subItem.disableImage:SetVisible(false)
          subItem.line:SetVisible(true)
          if data[APPELLATION_INFO.TYPE] == 0 then
            ApplyTextColor(subItem.name, FONT_COLOR.BLUE)
          else
            ApplyTextColor(subItem.name, FONT_COLOR.DEFAULT)
          end
        end
        local showingInfo = X2Player:GetShowingAppellation()
        if showingInfo ~= nil and showingInfo[APPELLATION_INFO.TYPE] == data[APPELLATION_INFO.TYPE] then
          subItem.appliedImage:SetVisible(true)
        else
          subItem.appliedImage:SetVisible(false)
          subItem.selectImage:SetVisible(false)
        end
        if tabWindow.selectedNameType == data[APPELLATION_INFO.TYPE] then
          subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
        else
          subItem.radiobtnImg:SetTextureInfo("radio_button_df")
        end
        if tabWindow.clickedType == data[APPELLATION_INFO.TYPE] then
          subItem.selectImage:SetVisible(true)
        else
          subItem.selectImage:SetVisible(false)
        end
      else
        subItem.name:SetText("")
        subItem.radiobtnImg:Show(false)
        subItem.appliedImage:SetVisible(false)
        subItem.disableImage:SetVisible(false)
        subItem.line:SetVisible(false)
      end
      subItem:SetText("")
    end
    local function EffectLayoutFunc(frame, rowIndex, colIndex, subItem)
      subItem.type = nil
      local radiobtn = UIParent:CreateWidget("button", "radiobtn", subItem)
      radiobtn:AddAnchor("TOPLEFT", subItem, 0, 0)
      radiobtn:SetExtent(21, 21)
      subItem.radiobtn = radiobtn
      local radiobtnImg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "radio_button_df", "overlay")
      radiobtnImg:AddAnchor("TOPLEFT", subItem, 3, 3)
      subItem.radiobtnImg = radiobtnImg
      local effect = subItem:CreateChildWidget("label", "effect", 0, true)
      effect.style:SetAlign(ALIGN_LEFT)
      subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(effect, FONT_COLOR.DEFAULT)
      effect:AddAnchor("LEFT", subItem, "LEFT", radiobtnImg:GetWidth() + 5, 0)
      effect:AddAnchor("RIGHT", subItem, "RIGHT", 0, 0)
      effect.style:SetEllipsis(true)
      subItem.tooltip = nil
      local overImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
      overImage:SetExtent(subItem:GetWidth(), subItem:GetHeight())
      overImage:SetTextureColor("list_ov")
      overImage:AddAnchor("TOPLEFT", subItem, -405, 0)
      overImage:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
      overImage:SetVisible(false)
      subItem.overImage = overImage
      local disableImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
      disableImage:SetExtent(subItem:GetWidth(), subItem:GetHeight())
      disableImage:SetTextureColor("list_dis")
      disableImage:AddAnchor("TOPLEFT", subItem, -405, 0)
      disableImage:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
      disableImage:SetVisible(false)
      subItem.disableImage = disableImage
      local selectImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
      selectImage:SetExtent(subItem:GetWidth(), subItem:GetHeight())
      selectImage:SetTextureColor("list_ov")
      selectImage:AddAnchor("TOPLEFT", subItem, -405, 0)
      selectImage:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
      selectImage:SetVisible(false)
      subItem.selectImage = selectImage
      local appliedImage = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "list_effect_select", "background")
      appliedImage:AddAnchor("TOPLEFT", subItem, 0, 0)
      appliedImage:AddAnchor("BOTTOMRIGHT", subItem, -5, 0)
      appliedImage:SetTextureColor("default")
      appliedImage:SetVisible(false)
      subItem.appliedImage = appliedImage
      function subItem:OnEnter()
        SetTooltip(subItem.tooltip, self)
        overImage:SetVisible(true)
      end
      subItem:SetHandler("OnEnter", subItem.OnEnter)
      function subItem:OnLeave()
        HideTooltip()
        overImage:SetVisible(false)
      end
      subItem:SetHandler("OnLeave", subItem.OnLeave)
      function subItem:OnClick(arg)
        if arg == "LeftButton" then
          tabWindow:ResetSelects()
          selectImage:SetVisible(true)
          tabWindow.clickedType = subItem.type
          if subItem.disableImage:IsVisible() == false then
            tabWindow:ResetRadioBtns(3)
            subItem.radiobtnImg:SetCoords(994, 0, 15, 15)
            tabWindow.selectedEffectType = subItem.type
          end
          tabWindow:UpdateRouteInfo(subItem.type)
        end
      end
      subItem:SetHandler("OnClick", subItem.OnClick)
      function subItem.radiobtn:OnClick(arg)
        tabWindow:ResetSelects()
        selectImage:SetVisible(true)
        if arg == "LeftButton" then
          if subItem.disableImage:IsVisible() == false then
            tabWindow:ResetRadioBtns(3)
            subItem.radiobtnImg:SetCoords(994, 0, 15, 15)
            tabWindow.selectedEffectType = subItem.type
          end
          tabWindow:UpdateRouteInfo(subItem.type)
        end
      end
      subItem.radiobtn:SetHandler("OnClick", subItem.radiobtn.OnClick)
    end
    local function EffectDataSetFunc(subItem, data, setValue)
      if setValue then
        subItem.type = data[APPELLATION_INFO.TYPE]
        if data[APPELLATION_INFO.TYPE] ~= nil and data[APPELLATION_INFO.TYPE] ~= 0 then
          if data[APPELLATION_INFO.BUFF_INFO] ~= nil then
            subItem.tooltip = data[APPELLATION_INFO.BUFF_INFO].description
            local text = subItem.tooltip
            text = string.gsub(text, "|nc;", "")
            text = string.gsub(text, "|r", "")
            text = string.gsub(text, "|cFFFF9C27", "")
            subItem.effect:SetText(text)
          else
            subItem.tooltip = ""
            subItem.effect:SetText(GetUIText(TOOLTIP_TEXT, "nobody"))
          end
        else
          subItem.tooltip = GetCommonText("appellation_effect_unable")
          subItem.effect:SetText(GetCommonText("appellation_effect_unable"))
        end
        subItem.radiobtnImg:Show(true)
        if data[APPELLATION_INFO.ISHAVE] == 0 then
          subItem.disableImage:SetVisible(true)
          ApplyTextColor(subItem.effect, ORIGINAL_LIGHT_GRAY_FONT_COLOR)
        else
          subItem.disableImage:SetVisible(false)
          if data[APPELLATION_INFO.TYPE] == 0 then
            ApplyTextColor(subItem.effect, FONT_COLOR.BLUE)
          else
            ApplyTextColor(subItem.effect, FONT_COLOR.DEFAULT)
          end
        end
        local effectInfo = X2Player:GetEffectAppellation()
        if effectInfo ~= nil and effectInfo[APPELLATION_INFO.TYPE] == data[APPELLATION_INFO.TYPE] then
          subItem.appliedImage:SetVisible(true)
        else
          subItem.appliedImage:SetVisible(false)
          subItem.selectImage:SetVisible(false)
        end
        if tabWindow.selectedEffectType == data[APPELLATION_INFO.TYPE] then
          subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
        else
          subItem.radiobtnImg:SetTextureInfo("radio_button_df")
        end
        if tabWindow.clickedType == data[APPELLATION_INFO.TYPE] then
          subItem.selectImage:SetVisible(true)
        else
          subItem.selectImage:SetVisible(false)
        end
      else
        subItem.effect:SetText("")
        subItem.radiobtnImg:Show(false)
        subItem.appliedImage:SetVisible(false)
        subItem.disableImage:SetVisible(false)
      end
      subItem:SetText("")
    end
    local GradeLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
      local icon = subItem:CreateDrawable(TEXTURE_PATH.RANKING_GRADE, "normal", "overlay")
      icon:AddAnchor("CENTER", subItem, 2, 0)
      subItem.icon = icon
    end
    local GradeDataSetFunc = function(subItem, data, setValue)
      if setValue then
        if data[APPELLATION_INFO.GRADE] >= 0 then
          subItem.icon:SetVisible(true)
          subItem.icon:SetTextureInfo(APPELLATION_GRADE[data[APPELLATION_INFO.GRADE] + 1])
        end
      elseif subItem.icon ~= nil then
        subItem.icon:SetVisible(false)
      end
    end
    listWnd:InsertColumn(X2Locale:LocalizeUiText(RANKING_TEXT, "rank"), 70, LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
    listWnd:InsertColumn(GetCommonText("appellation_title"), 335, LCCIT_STRING, NameDataSetFunc, nil, nil, NameLayoutFunc)
    listWnd:InsertColumn(GetCommonText("effect"), 336, LCCIT_STRING, EffectDataSetFunc, nil, nil, EffectLayoutFunc)
    listWnd:InsertRows(LIST_ROW_COUNT, false)
    listWnd.listCtrl:DisuseSorting()
    DrawListCtrlUnderLine(listWnd.listCtrl, COLUMN_HEIGHT - 2)
    local titleBg = listWnd.listCtrl:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    titleBg:SetTextureColor("list_title")
    titleBg:AddAnchor("TOPLEFT", listWnd.listCtrl.column[1], 0, 0)
    titleBg:AddAnchor("BOTTOMRIGHT", listWnd.listCtrl.column[3], 0, 0)
    local listBg = listWnd.listCtrl:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    listBg:SetTextureColor("bg_01")
    listBg:AddAnchor("TOPLEFT", listWnd.listCtrl, 0, listWnd.listCtrl.column[1]:GetHeight() - 10)
    listBg:AddAnchor("BOTTOMRIGHT", listWnd.listCtrl, 0, 0)
    local verticalLine1 = listWnd:CreateDrawable(TEXTURE_PATH.TAB_LIST, "vertical_line", "overlay")
    verticalLine1:SetTextureColor("default")
    verticalLine1:AddAnchor("TOPLEFT", listWnd.listCtrl.column[2], -1, listWnd.listCtrl.column[2]:GetHeight() - 5)
    verticalLine1:SetExtent(3, COLUMN_HEIGHT * LIST_ROW_COUNT)
    listWnd.verticalLine1 = verticalLine1
    local verticalLine2 = listWnd:CreateDrawable(TEXTURE_PATH.TAB_LIST, "vertical_line", "overlay")
    verticalLine2:SetTextureColor("default")
    verticalLine2:AddAnchor("TOPLEFT", listWnd.listCtrl.column[3], -1, listWnd.listCtrl.column[3]:GetHeight() - 5)
    verticalLine2:SetExtent(3, COLUMN_HEIGHT * LIST_ROW_COUNT)
    listWnd.verticalLine2 = verticalLine2
    for i = 1, #listWnd.listCtrl.column do
      SettingListColumn(listWnd.listCtrl, listWnd.listCtrl.column[i], COLUMN_HEIGHT)
      DrawListCtrlColumnSperatorLine(listWnd.listCtrl.column[i], #listWnd.listCtrl.column, i)
      SetButtonFontColor(listWnd.listCtrl.column[i], GetButtonDefaultFontColor_V2())
    end
  end
  local CreateAppelationRouteFrame = function(tabWindow)
    local routeWnd = tabWindow:CreateChildWidget("emptyWidget", "routeWnd", 0, true)
    routeWnd:Show(true)
    routeWnd:SetExtent(772, 84)
    routeWnd:AddAnchor("TOPLEFT", tabWindow.listWnd, 0, tabWindow.listWnd:GetHeight() + 10 + 32)
    tabWindow.routeWnd = routeWnd
    local routeBg = CreateContentBackground(routeWnd, "TYPE2", "brown")
    routeBg:AddAnchor("TOPLEFT", routeWnd, 0, 0)
    routeBg:AddAnchor("BOTTOMRIGHT", routeWnd, 0, 0)
    local routeLabel = tabWindow:CreateChildWidget("textbox", "routeLabel", 0, true)
    routeLabel:AddAnchor("TOPLEFT", routeWnd, 15, 12)
    routeLabel:SetExtent(480, FONT_SIZE.MIDDLE)
    ApplyTextColor(routeLabel, FONT_COLOR.DEFAULT)
    routeLabel:SetText(GetCommonText("hero_bonus_conditon"))
    routeLabel.style:SetAlign(ALIGN_LEFT)
    local routeLine = CreateLine(routeWnd, "TYPE1")
    routeLine:AddAnchor("TOPLEFT", routeLabel, "BOTTOMLEFT", -10, 5)
    routeLine:AddAnchor("TOPRIGHT", routeWnd, "BOTTOMRIGHT", 10, 0)
    local routeDesc = tabWindow:CreateChildWidget("textbox", "routeDesc", 0, true)
    routeDesc:AddAnchor("TOPLEFT", routeLine, "BOTTOMLEFT", 15, 5)
    routeDesc:SetExtent(742, 35)
    ApplyTextColor(routeDesc, FONT_COLOR.DEFAULT)
    routeDesc.style:SetAlign(ALIGN_LEFT)
    tabWindow.routeDesc = routeDesc
    local popupBtn = tabWindow:CreateChildWidget("button", "popupBtn", 0, true)
    popupBtn:AddAnchor("BOTTOMRIGHT", routeDesc, 0, popupBtn:GetWidth() * 0.5)
    ApplyButtonSkin(popupBtn, BUTTON_BASIC.EQUIP_ITEM_GUIDE_CRAFT)
    tabWindow.popupBtn = popupBtn
    function popupBtn:OnClick(arg)
      if arg == "LeftButton" then
        tabWindow:routePopupProc(tabWindow.clickedType)
      end
    end
    popupBtn:SetHandler("OnClick", popupBtn.OnClick)
    local applyBtn = tabWindow:CreateChildWidget("button", "applyBtn", 0, true)
    applyBtn:AddAnchor("TOPRIGHT", routeWnd, "BOTTOMRIGHT", 0, 7)
    applyBtn:SetText(X2Locale:LocalizeUiText(OPTION_TEXT, "apply"))
    ApplyButtonSkin(applyBtn, BUTTON_BASIC.DEFAULT)
    tabWindow.applyBtn = applyBtn
  end
  local CreateAppellationStampWindow = function(tabWindow)
    local stampWnd = CreateWindow("stampWnd", tabWindow)
    stampWnd:SetExtent(310, 430)
    stampWnd:AddAnchor("CENTER", "UIParent", 0, 0)
    stampWnd:SetTitle(GetCommonText("appellation_stamp"))
    tabWindow.stampWnd = stampWnd
    tabWindow.stampWnd:Show(false)
    tabWindow.stampWnd.minStampNum = 25
    local label = stampWnd:CreateChildWidget("textbox", "label", 0, true)
    label:AddAnchor("TOP", stampWnd.titleBar, "BOTTOM", 0, 0)
    label:SetExtent(261, FONT_SIZE.MIDDLE)
    label.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(label, FONT_COLOR.DEFAULT)
    label:SetText(GetCommonText("appellation_select_stamp"))
    label.style:SetAlign(ALIGN_CENTER)
    local scrollWnd = CreateScrollWindow(stampWnd, "scrollWnd", 0)
    scrollWnd:AddAnchor("TOPLEFT", label, -5, label:GetHeight() + 12)
    scrollWnd:SetExtent(271, 248)
    scrollWnd:Show(true)
    local emptyWidget = UIParent:CreateWidget("emptywidget", scrollWnd:GetId() .. ".emptywidget", scrollWnd.content)
    emptyWidget:SetExtent(scrollWnd.content:GetWidth(), scrollWnd.content:GetHeight())
    emptyWidget:AddAnchor("TOPLEFT", scrollWnd.content, 0, 0)
    emptyWidget:Show(true)
    scrollWnd.emptyWidget = emptyWidget
    local scrollWndBg = CreateContentBackground(scrollWnd, "TYPE2", "brown_2")
    scrollWndBg:AddAnchor("TOPLEFT", scrollWnd, -5, -5)
    scrollWndBg:AddAnchor("BOTTOMRIGHT", scrollWnd, 5, 5)
    tabWindow.scrollWnd = scrollWnd
    stampWnd.btns = {}
    stampWnd.selected = {}
    stampWnd.applied = {}
    local guide = stampWnd:CreateChildWidget("textbox", "guide", 0, true)
    guide:AddAnchor("BOTTOM", scrollWnd, 0, FONT_SIZE.MIDDLE * 2 + 20)
    guide:SetExtent(230, FONT_SIZE.MIDDLE * 2)
    guide.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(guide, FONT_COLOR.GRAY)
    guide:SetText(GetCommonText("appellation_stamp_guide"))
    guide.style:SetAlign(ALIGN_CENTER)
    guide:Show(true)
    local calcelBtn = stampWnd:CreateChildWidget("button", "calcelBtn", 0, true)
    ApplyButtonSkin(calcelBtn, BUTTON_BASIC.DEFAULT)
    calcelBtn:AddAnchor("BOTTOM", stampWnd, calcelBtn:GetWidth() / 2 + 2, -MARGIN.WINDOW_SIDE)
    calcelBtn:SetText(GetCommonText("cancel"))
    tabWindow.stampCalcelBtn = calcelBtn
    local applyBtn = stampWnd:CreateChildWidget("button", "applyBtn", 0, true)
    ApplyButtonSkin(applyBtn, BUTTON_BASIC.DEFAULT)
    applyBtn:AddAnchor("TOPLEFT", calcelBtn, -(calcelBtn:GetWidth() + 5), 0)
    applyBtn:SetText(X2Locale:LocalizeUiText(OPTION_TEXT, "apply"))
    tabWindow.stampApplyBtn = applyBtn
  end
  local CreateInfomationBuff = function(tabWindow)
    local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
    local max_width = 430 - sideMargin * 2
    local buffWindow = CreateWindow(tabWindow:GetId() .. ".buffWindow", tabWindow)
    buffWindow:AddAnchor("CENTER", "UIParent", 0, 0)
    buffWindow:SetExtent(430, 500)
    buffWindow:SetTitle(GetCommonText("appellation_buff_info_title"))
    buffWindow:SetCloseOnEscape(true)
    tabWindow.buffWindow = buffWindow
    local okButton = buffWindow:CreateChildWidget("button", "okButton", 0, false)
    okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
    ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
    okButton:AddAnchor("BOTTOM", buffWindow, 0, -20)
    function okButton:OnClick()
      buffWindow:Show(false)
    end
    okButton:SetHandler("OnClick", okButton.OnClick)
    local ment = buffWindow:CreateChildWidget("textbox", "ment", 0, true)
    ment:SetAutoResize(true)
    ment:AddAnchor("BOTTOM", okButton, "TOP", 0, -20)
    ment:AddAnchor("LEFT", buffWindow, sideMargin + 20, 0)
    ment:AddAnchor("RIGHT", buffWindow, -sideMargin - 20, 0)
    ment.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(ment, FONT_COLOR.GRAY)
    ment:SetText(GetCommonText("appellation_buff_info_description"))
    local buffList = W_CTRL.CreateScrollListCtrl("listCtrl", buffWindow)
    buffList.scroll:RemoveAllAnchors()
    buffList.scroll:AddAnchor("TOPRIGHT", buffList, 0, 0)
    buffList.scroll:AddAnchor("BOTTOMRIGHT", buffList, 0, 0)
    buffList.listCtrl:SetColumnHeight(0)
    buffList:SetExtent(389, 322)
    buffList:AddAnchor("TOP", buffWindow, 0, 50)
    buffList:Show(true)
    local SetDataFunc = function(subItem, data, setValue)
      if setValue then
        local levelStr = GetCommonText("appellation_buff_info_grade") .. "  : " .. tostring(data[2])
        local buffInfo = X2Ability:GetBuffTooltip(data[1], 1)
        subItem.levelIconTexture:SetTextureInfo(string.format("level_%02d", data[2]))
        subItem.levelIcon:Show(true)
        subItem.levelText:SetText(levelStr)
        subItem.levelText:Show(true)
        subItem.buff:Show(true)
        if buffInfo ~= nil then
          subItem.buff:SetTooltip(buffInfo)
          F_SLOT.SetIconBackGround(subItem.buff, buffInfo.path)
        else
          subItem.buff:Show(false)
        end
        if subItem.line ~= nil then
          subItem.line:Show(true)
        end
      else
        subItem.levelIcon:Show(false)
        subItem.levelText:Show(false)
        subItem.buff:Show(false)
        if subItem.line ~= nil then
          subItem.line:Show(false)
        end
      end
    end
    local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
      local levelIcon = subItem:CreateChildWidget("emptywidget", "levelIcon", 0, true)
      levelIcon:AddAnchor("TOPLEFT", subItem, 2, 2)
      levelIcon:AddAnchor("BOTTOM", subItem, 0, 0)
      local iconTexture = levelIcon:CreateDrawable(TEXTURE_PATH.EXPEDITION_GRADE, "level_01", "background")
      iconTexture:AddAnchor("TOPLEFT", levelIcon, 0, 0)
      iconTexture:AddAnchor("BOTTOMRIGHT", levelIcon, 0, 0)
      levelIcon:Show(false)
      subItem.levelIconTexture = iconTexture
      subItem.levelIcon = levelIcon
      local levelText = subItem:CreateChildWidget("label", "levelText", 0, true)
      levelText:SetHeight(FONT_SIZE.LARGE)
      levelText:SetAutoResize(true)
      levelText.style:SetAlign(ALIGN_LEFT)
      levelText.style:SetFontSize(FONT_SIZE.LARGE)
      levelText:AddAnchor("LEFT", levelIcon, "RIGHT", 5, 0)
      levelText:AddAnchor("TOP", subItem, 0, 24)
      levelText:SetText(GetCommonText("expedition") .. " " .. GetCommonText("level"))
      ApplyTextColor(levelText, FONT_COLOR.DEFAULT)
      levelText:Show(false)
      subItem.levelText = levelText
      local buff = CreateItemIconButton("buff", subItem)
      buff:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
      buff:AddAnchor("TOPRIGHT", subItem, -19, 17)
      buff:AddAnchor("BOTTOM", subItem, 0, -17)
      buff:Show(false)
      F_SLOT.ApplySlotSkin(buff, buff.back, SLOT_STYLE.BUFF)
      subItem.buff = buff
      local buffDeco = buff:CreateDrawable(TEXTURE_PATH.HUD, "buff_deco", "overlay")
      buffDeco:SetTextureColor("buff")
      buffDeco:AddAnchor("BOTTOM", buff, 0, 0)
      if rowIndex ~= 1 then
        local line = CreateLine(subItem, "TYPE1")
        line:AddAnchor("TOPLEFT", subItem, 0, 0)
        line:AddAnchor("TOPRIGHT", subItem, 0, 0)
        subItem.line = line
      end
    end
    buffList:InsertColumn("", 369, LCCIT_WINDOW, SetDataFunc, nil, nil, LayoutFunc)
    buffList:InsertRows(5, false)
    local buffInfo = X2Player:GetAppellationBuffInfoByLevels()
    for i = 1, #buffInfo do
      local buff = buffInfo[i]
      if buff ~= nil then
        local info = {}
        info[1] = buff.buff
        info[2] = i
        buffList:InsertData(i, 1, info)
      end
    end
  end
  CreateAppelationInfoFrame(tabWindow)
  CreateAppelationListFrame(tabWindow)
  CreateAppelationRouteFrame(tabWindow)
  CreateAppellationStampWindow(tabWindow)
  CreateInfomationBuff(tabWindow)
  SetAppellationEventFunction(tabWindow)
  return tabWindow
end
