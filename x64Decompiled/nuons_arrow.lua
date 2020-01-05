local NUONS_ARROW_WINDOW_WIDTH = 510
local NUONS_ARROW_WINDOW_HEIGHT = 480
local NUONS_ARROW_LIST_WIDTH = 455
local NUONS_ARROW_LIST_HEIGHT = 330
local NUONS_ARROW_ROW_COUNT = 10
local function CreateNuonsArrowListCtrl(id, parent)
  local widget = W_CTRL.CreateScrollListCtrl(id, parent, 0)
  widget:Show(true)
  widget:SetExtent(NUONS_ARROW_LIST_WIDTH, NUONS_ARROW_LIST_HEIGHT)
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data.name)
    else
      subItem:SetText("")
    end
  end
  local StepDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data)
    else
      subItem:SetText("")
    end
  end
  local ChargeDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(data)))
    else
      subItem:SetText("")
    end
  end
  local NameLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem.style:SetEllipsis(true)
  end
  local StepLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem.style:SetEllipsis(true)
  end
  local ChargeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_RIGHT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  widget:InsertColumn(NUONS_ARROW_INFO[NUONS_ARROW_IDX.NAME].text, NUONS_ARROW_INFO[NUONS_ARROW_IDX.NAME].width, LCCIT_STRING, NameDataSetFunc, nil, nil, NameLayoutSetFunc)
  widget:InsertColumn(NUONS_ARROW_INFO[NUONS_ARROW_IDX.STEP].text, NUONS_ARROW_INFO[NUONS_ARROW_IDX.STEP].width, LCCIT_STRING, StepDataSetFunc, nil, nil, StepLayoutSetFunc)
  widget:InsertColumn(NUONS_ARROW_INFO[NUONS_ARROW_IDX.CHARGE].text, NUONS_ARROW_INFO[NUONS_ARROW_IDX.CHARGE].width, LCCIT_TEXTBOX, ChargeDataSetFunc, nil, nil, ChargeLayoutSetFunc)
  widget:InsertRows(NUONS_ARROW_ROW_COUNT, false)
  widget.listCtrl:DisuseSorting()
  widget.listCtrl:UseOverClickTexture("red")
  DrawListCtrlUnderLine(widget.listCtrl)
  for i = 1, #widget.listCtrl.column do
    SettingListColumn(widget.listCtrl, widget.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(widget.listCtrl.column[i], #widget.listCtrl.column, i)
  end
  return widget
end
function CreateNuonsArrow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(NUONS_ARROW_WINDOW_WIDTH, NUONS_ARROW_WINDOW_HEIGHT)
  window:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "resident_nuons_title"))
  window:AddAnchor("CENTER", parent, 0, 0)
  local zone = CreateNuonsArrowListCtrl("listCtrl", window)
  zone:AddAnchor("TOP", window, 0, 50)
  window.zone = zone
  local info = {
    leftButtonStr = GetUIText(COMMON_TEXT, "resident_nuons_attack")
  }
  CreateWindowDefaultTextButtonSet(window, info)
  local explainLabel = window:CreateChildWidget("label", "explainLabel", 0, true)
  explainLabel:SetAutoResize(true)
  explainLabel:SetHeight(FONT_SIZE.MIDDLE)
  explainLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  explainLabel:SetText(GetUIText(COMMON_TEXT, "resident_nuons_explain"))
  explainLabel:AddAnchor("TOP", zone, "BOTTOM", 0, 24)
  explainLabel.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(explainLabel, FONT_COLOR.DEFAULT)
  ListCtrlItemGuideLine(zone.listCtrl.items, NUONS_ARROW_ROW_COUNT)
  function window:OnFillData(data)
    zone:DeleteAllDatas()
    for i = 1, #data do
      data[i].name = data[i].name or ""
      data[i].step = data[i].step or ""
      zone:InsertData(i, 1, data[i])
      zone:InsertData(i, 2, data[i].step)
      zone:InsertData(i, 3, data[i].charge)
    end
    for i = 1, NUONS_ARROW_ROW_COUNT - 1 do
      local item = zone.listCtrl.items[i]
      item.line:SetVisible(true)
    end
    window:Show(true)
  end
  function window:OnHide()
    window:Show(false)
  end
  local function LeftButtonLeftClickFunc()
    local index = zone:GetSelectedDataIndex()
    local data
    if index > 0 then
      data = zone:GetDataByDataIndex(index, 1)
    end
    if data ~= nil then
      local zoneGroup = data.zoneGroup
      X2Resident:FireNuonsArrow(zoneGroup)
    else
      AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "NUONS_ARROW_TARGET_NOT_SELECTED"))
    end
    window:Show(false)
  end
  window.leftButton:SetHandler("OnClick", LeftButtonLeftClickFunc)
  window.rightButton:SetHandler("OnClick", window.OnHide)
  return window
end
nuonsArrow = CreateNuonsArrow("nuonsArrow", "UIParent")
nuonsArrow:Show(false)
local events = {
  NUONS_ARROW_SHOW = function(visible)
    visible = visible or true
    if nuonsArrow:IsVisible() == visible then
      return
    end
    nuonsArrow:Show(visible)
    local zoneGroup = X2Unit:GetCurrentZoneGroup()
    X2Resident:GetResidentZoneList(zoneGroup)
  end,
  NUONS_ARROW_UPDATE = function(data)
    if nuonsArrow:IsVisible() == false then
      return
    end
    nuonsArrow:OnFillData(data)
  end
}
nuonsArrow:SetHandler("OnEvent", function(this, event, ...)
  events[event](...)
end)
RegistUIEvent(nuonsArrow, events)
