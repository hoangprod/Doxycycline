local CreateOkButton = function(parent)
  local OnButtonClick = function()
    X2BattleField:PickShip(battlefield.pickShipWindow.selectShipType)
    battlefield.pickShipWindow:Show(false)
  end
  local btn = parent:CreateChildWidget("button", "OkButton", 0, true)
  btn:SetText(locale.common.ok)
  btn:AddAnchor("BOTTOM", parent, 0, -20)
  ApplyButtonSkin(btn, BUTTON_BASIC.DEFAULT)
  ButtonOnClickHandler(btn, OnButtonClick)
  return btn
end
local CreateCountDownTextBox = function(parent)
  local countDownText = parent:CreateChildWidget("textbox", "countDownText", 0, true)
  countDownText:SetExtent(360, 25)
  countDownText.style:SetFontSize(FONT_SIZE.LARGE)
  countDownText.style:SetAlign(ALIGN_CENTER)
  countDownText:AddAnchor("TOP", parent.titleBar, "BOTTOM", 0, 0)
  ApplyTextColor(countDownText, FONT_COLOR.ROSE_PINK)
  local countDownBg = countDownText:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_LIST_BACKGROUND, "time_bg", "background")
  countDownBg:AddAnchor("TOPLEFT", countDownText, 0, 0)
  return countDownText
end
local CreateShipList = function(parent)
  local shipListWidget = W_CTRL.CreateScrollListBox("shipListWidget", parent, parent, "TYPE2")
  shipListWidget:SetExtent(214, 445)
  shipListWidget:AddAnchor("TOPLEFT", parent.titleBar, "BOTTOMLEFT", 20, 40)
  shipListWidget.content.itemStyle:SetFontSize(FONT_SIZE.MIDDLE)
  shipListWidget.content.itemStyle:SetAlign(ALIGN_LEFT)
  shipListWidget.content:SetHeight(23)
  shipListWidget.content:SetTreeTypeIndent(true, 17, -20)
  shipListWidget.content:ShowTooltip(true)
  function shipListWidget:SetStyle(size)
    local line = shipListWidget.content:CreateSeparatorImageDrawable(TEXTURE_PATH.DEFAULT, "background")
    line:SetTextureInfo("line_02", "default")
    line:SetExtent(size, 3)
  end
  local categoryInfo = {}
  local shipListInfo = X2BattleField:GetShipListInfo()
  for i = 1, #shipListInfo do
    categoryInfo[i] = {
      text = shipListInfo[i].name,
      value = shipListInfo[i].type,
      defaultColor = FONT_COLOR.DEFAULT,
      selectColor = FONT_COLOR.BLUE,
      overColor = FONT_COLOR.BLUE,
      useColor = true,
      iconPath = TEXTURE_PATH.BATTLEFIELD_SHIP_LIST_BACKGROUND,
      infoKey = "list_point"
    }
  end
  function shipListWidget:SetInfo(info, categoryFunc, initIndex)
    shipListWidget.infos = info
    shipListWidget.categoryFunc = categoryFunc
    shipListWidget.content:SetItemTrees(info)
    shipListWidget.content:InitializeSelect(initIndex)
  end
  function shipListWidget:OnSelChanged()
    parent:UpdateContent(self.content:GetSelectedValue())
  end
  shipListWidget:SetInfo(categoryInfo, nil, 0)
  shipListWidget:SetStyle(shipListWidget:GetWidth())
  local maxTop = shipListWidget.content:GetMaxTop()
  shipListWidget:SetMinMaxValues(0, maxTop)
  shipListWidget.scroll:Show(maxTop > 0)
  return shipListWidget
end
local DEFAULT_SHIP_IMAGE_PATH = "ui/battlefield/ship_1.dds"
local function CreateContent(parent)
  local contentWidget = parent:CreateChildWidget("emptywidget", "contentWidget", 0, true)
  contentWidget:AddAnchor("TOPRIGHT", parent.titleBar, "BOTTOMRIGHT", -20, 32)
  contentWidget:SetExtent(333, 453)
  local shipImg = parent:CreateDrawable(DEFAULT_SHIP_IMAGE_PATH, "ship", "overlay")
  shipImg:AddAnchor("TOPRIGHT", contentWidget, "TOPRIGHT", 0, 0)
  parent.shipImg = shipImg
  local scrollWnd = CreateScrollWindow(parent, "scrollWnd", 0)
  scrollWnd:AddAnchor("TOPLEFT", shipImg, "BOTTOMLEFT", 0, 5)
  scrollWnd:AddAnchor("BOTTOMRIGHT", contentWidget, "BOTTOMRIGHT", 0, 0)
  local scrollDescAnchorY = 12
  local scrollDesc = scrollWnd.content:CreateChildWidget("emptywidget", "scrollDesc", 0, true)
  scrollDesc:SetExtent(300, 225)
  scrollDesc:AddAnchor("TOPRIGHT", scrollWnd.content, -6, scrollDescAnchorY)
  local shipNameText = scrollDesc:CreateChildWidget("textbox", "shipNameText", 0, true)
  shipNameText:SetExtent(285, FONT_SIZE.LARGE)
  shipNameText.style:SetFontSize(FONT_SIZE.LARGE)
  shipNameText.style:SetAlign(ALIGN_LEFT)
  shipNameText:AddAnchor("TOPRIGHT", scrollDesc, "TOPRIGHT", 0, 0)
  ApplyTextColor(shipNameText, FONT_COLOR.MIDDLE_TITLE)
  local shipNameIcon = shipNameText:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_SHIP_LIST_BACKGROUND, "info_point", "overlay")
  shipNameIcon:AddAnchor("RIGHT", shipNameText, "LEFT", -4, 0)
  local shipDesc = scrollDesc:CreateChildWidget("textbox", "shipDesc", 0, true)
  shipDesc:SetWidth(300)
  shipDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
  shipDesc.style:SetAlign(ALIGN_LEFT)
  shipDesc:AddAnchor("TOPRIGHT", shipNameText, "BOTTOMRIGHT", 0, 11)
  shipDesc:SetAutoResize(true)
  ApplyTextColor(shipDesc, FONT_COLOR.DEFAULT)
  function parent:UpdateContent(shipType)
    local shipInfo = X2BattleField:GetShipInfo(shipType, false)
    if shipInfo == nil then
      shipNameText:SetText("unkown ship")
      shipDesc:SetText("unkown desc")
      shipImg:SetTexture(DEFAULT_SHIP_IMAGE_PATH)
    else
      shipNameText:SetText(shipInfo.name)
      shipDesc:SetText(shipInfo.desc)
      shipImg:SetTexture(string.format("ui/battlefield/%s.dds", shipInfo.shipImg))
    end
    local _, height = F_LAYOUT.GetExtentWidgets(shipNameText, shipDesc)
    height = height + scrollDescAnchorY + 5
    scrollDesc:SetHeight(height)
    scrollWnd.contentHeight = height
    scrollWnd:ResetScroll(height)
    scrollWnd:SetValue(0)
    parent.selectShipType = shipType
  end
end
local function CreatePickShipWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(600, 592)
  window:SetTitle(GetUIText(BATTLE_FIELD_TEXT, "pick_ship_title"))
  window:SetCloseOnEscape(false)
  window.titleBar.closeButton:Show(false)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetUILayer("dialog")
  CreateContent(window)
  window.shipListWidget = CreateShipList(window)
  window.countDownText = CreateCountDownTextBox(window)
  window.OkButton = CreateOkButton(window)
  local oldTime = 0
  local function OnUpdateTime(self, dt)
    if window.remainTime < 0 then
      return
    end
    if oldTime ~= window.remainTime then
      oldTime = window.remainTime
      local minute, second = GetMinuteSecondeFromSec(oldTime)
      window.countDownText:SetText(string.format(GetUIText(BATTLE_FIELD_TEXT, "pick_count_down"), minute, second))
    end
  end
  function window:FillInstantTimeInfo()
    local timeInfo = X2BattleField:GetProgressTimeInfo()
    if timeInfo == nil or timeInfo.state ~= "READY" then
      window:Show(false)
      return
    end
    window.remainTime = tonumber(timeInfo.remainTime)
    if window:HasHandler("OnUpdate") == false then
      window:SetHandler("OnUpdate", OnUpdateTime)
    end
  end
  local function OnHide()
    window:ReleaseHandler("OnUpdate")
    battlefield.pickShipWindow = nil
  end
  window:SetHandler("OnHide", OnHide)
  local windowEvents = {
    INSTANT_GAME_END = function()
      window:Show(false)
    end,
    INSTANT_GAME_RETIRE = function()
      window:Show(false)
    end,
    UPDATE_INSTANT_GAME_TIME = function()
      window:FillInstantTimeInfo()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    windowEvents[event](this, ...)
  end)
  RegistUIEvent(window, windowEvents)
  return window
end
local function PickShipShow()
  local show = X2BattleField:IsPossiblePickShip()
  if show and battlefield.pickShipWindow == nil then
    battlefield.pickShipWindow = CreatePickShipWindow("battlefield.pickShipWindow", "UIParent")
    battlefield.pickShipWindow:EnableHidingIsRemove(true)
    battlefield.pickShipWindow:FillInstantTimeInfo()
  end
  if battlefield.pickShipWindow ~= nil then
    battlefield.pickShipWindow:Show(show)
  end
end
UIParent:SetEventHandler("INSTANT_GAME_READY", PickShipShow)
UIParent:SetEventHandler("TEAM_MEMBERS_CHANGED", PickShipShow)
UIParent:SetEventHandler("LEFT_LOADING", PickShipShow)
