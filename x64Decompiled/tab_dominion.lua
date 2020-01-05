local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreateDominionInfomationGuide = function(id, parent)
  DOMINION_WINDOW = {
    {
      title = "dominion_guide_title_1",
      content = "dominion_guide_content_1"
    },
    {
      title = "dominion_guide_title_2",
      content = "dominion_guide_content_2"
    },
    {
      title = "dominion_guide_title_3",
      content = "dominion_guide_content_3"
    },
    {
      title = "dominion_guide_title_4",
      content = "dominion_guide_content_4"
    }
  }
  return CreateInfomationGuideWindow(id, parent, "dominion_point_and_charge", DOMINION_WINDOW)
end
local function CreateDomonionInfo(id, parent)
  local window = parent:CreateChildWidget("emptywidget", "dominionView", 0, true)
  window:Show(false)
  window:AddAnchor("TOPLEFT", parent, 0, 0)
  window:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local zoneSelect = window:CreateChildWidget("label", "zoneSelect", 0, true)
  zoneSelect:AddAnchor("TOPLEFT", parent, 18, 16)
  zoneSelect:SetExtent(430, FONT_SIZE.LARGE)
  zoneSelect.style:SetFontSize(FONT_SIZE.LARGE)
  zoneSelect.style:SetAlign(ALIGN_LEFT)
  zoneSelect:SetText(GetCommonText("siege_raid_register_dominions_title"))
  ApplyTextColor(zoneSelect, FONT_COLOR.MIDDLE_TITLE)
  local combo = W_CTRL.CreateComboBox("combo", window)
  combo:SetWidth(430)
  combo:AddAnchor("TOPLEFT", zoneSelect, "BOTTOMLEFT", 0, 7)
  combo:SetVisibleItemCount(8)
  CreateNationMap("originMap", window, false)
  window.originMap:SetExtent(256, 256)
  window.originMap:AddAnchor("TOP", combo, "BOTTOM", 0, 20)
  window.originMap:AddAnchor("LEFT", window, 165, 0)
  local remarkOrder = {
    1,
    3,
    5,
    2,
    4
  }
  NationRemarkList("remarkList", window, false, remarkOrder, true)
  window.remarkList:AddAnchor("TOP", combo, "BOTTOM", 0, 140)
  window.remarkList:AddAnchor("LEFT", window, 23, 0)
  local dominionName = window:CreateChildWidget("label", "dominionName", 0, true)
  dominionName:AddAnchor("TOPLEFT", parent, 18, 353)
  dominionName:SetExtent(430, FONT_SIZE.XXLARGE)
  dominionName.style:SetFontSize(FONT_SIZE.XXLARGE)
  dominionName.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(dominionName, FONT_COLOR.MIDDLE_TITLE)
  local factionName = window:CreateChildWidget("label", "factionName", 0, true)
  factionName:AddAnchor("TOPLEFT", dominionName, "BOTTOMLEFT", 0, 5)
  factionName:SetExtent(430, FONT_SIZE.LARGE)
  factionName.style:SetFontSize(FONT_SIZE.LARGE)
  factionName.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(factionName, FONT_COLOR.DEFAULT)
  local pointChargeBg = window:CreateChildWidget("emptywidget", "pointChargeBg", 0, true)
  local bg = pointChargeBg:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_02")
  bg:AddAnchor("TOPLEFT", pointChargeBg, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", pointChargeBg, 0, 0)
  pointChargeBg:AddAnchor("TOPLEFT", factionName, "BOTTOMLEFT", -12, 15)
  pointChargeBg:SetExtent(456, 30)
  local pointCharge = window:CreateChildWidget("label", "pointCharge", 0, true)
  pointCharge:AddAnchor("LEFT", pointChargeBg, 12, 0)
  pointCharge:SetExtent(400, FONT_SIZE.LARGE)
  pointCharge.style:SetFontSize(FONT_SIZE.LARGE)
  pointCharge.style:SetAlign(ALIGN_LEFT)
  pointCharge:SetText(GetCommonText("dominion_point_and_charge"))
  ApplyTextColor(pointCharge, FONT_COLOR.MIDDLE_TITLE)
  local guideButton = window:CreateChildWidget("button", "guideButton", 0, true)
  ApplyButtonSkin(guideButton, BUTTON_BASIC.QUESTION_MARK)
  guideButton:Show(true)
  guideButton:AddAnchor("LEFT", pointCharge, "RIGHT", 10, 0)
  function guideButton:OnClick()
    if dominionGuideWnd then
      dominionGuideWnd:Show(not dominionGuideWnd:IsVisible())
    else
      dominionGuideWnd = CreateDominionInfomationGuide("dominionGuideWindow", "UIParent")
      dominionGuideWnd:AddAnchor("CENTER", "UIParent", 0, 0)
      dominionGuideWnd:Show(true)
    end
  end
  guideButton:SetHandler("OnClick", guideButton.OnClick)
  local chargeLabel = window:CreateChildWidget("label", "chargeLabel", 0, true)
  chargeLabel:AddAnchor("TOPLEFT", pointChargeBg, "BOTTOMLEFT", 12, 13)
  chargeLabel:SetExtent(265, FONT_SIZE.LARGE)
  chargeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  chargeLabel.style:SetAlign(ALIGN_LEFT)
  chargeLabel:SetText(GetCommonText("dominion_charge"))
  ApplyTextColor(chargeLabel, FONT_COLOR.DEFAULT)
  local charge = window:CreateChildWidget("textbox", "charge", 0, true)
  charge:AddAnchor("LEFT", chargeLabel, "RIGHT", 6, 0)
  charge:SetExtent(160, FONT_SIZE.LARGE)
  charge.style:SetFontSize(FONT_SIZE.LARGE)
  charge.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(charge, FONT_COLOR.BLUE)
  local totalPointLabel = window:CreateChildWidget("label", "totalPointLabel", 0, true)
  totalPointLabel:AddAnchor("TOPLEFT", chargeLabel, "BOTTOMLEFT", 0, 5)
  totalPointLabel:SetExtent(320, FONT_SIZE.LARGE)
  totalPointLabel.style:SetFontSize(FONT_SIZE.LARGE)
  totalPointLabel.style:SetAlign(ALIGN_LEFT)
  totalPointLabel:SetText(GetCommonText("dominion_total_point"))
  ApplyTextColor(totalPointLabel, FONT_COLOR.DEFAULT)
  local totalPoint = window:CreateChildWidget("textbox", "totalPoint", 0, true)
  totalPoint:AddAnchor("LEFT", totalPointLabel, "RIGHT", 10, 0)
  totalPoint:SetExtent(100, FONT_SIZE.LARGE)
  totalPoint.style:SetFontSize(FONT_SIZE.LARGE)
  totalPoint.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(totalPoint, FONT_COLOR.BLUE)
  local pointLabel = window:CreateChildWidget("label", "pointLabel", 0, true)
  pointLabel:AddAnchor("TOPLEFT", totalPointLabel, "BOTTOMLEFT", 0, 16)
  pointLabel:SetExtent(320, FONT_SIZE.LARGE)
  pointLabel.style:SetFontSize(FONT_SIZE.LARGE)
  pointLabel.style:SetAlign(ALIGN_LEFT)
  pointLabel:SetText(GetCommonText("dominion_my_point"))
  ApplyTextColor(pointLabel, FONT_COLOR.DEFAULT)
  local point = window:CreateChildWidget("textbox", "point", 0, true)
  point:AddAnchor("LEFT", pointLabel, "RIGHT", 10, 0)
  point:SetExtent(100, FONT_SIZE.LARGE)
  point.style:SetFontSize(FONT_SIZE.LARGE)
  point.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(point, FONT_COLOR.BLUE)
  local dividendLabel = window:CreateChildWidget("label", "dividendLabel", 0, true)
  dividendLabel:AddAnchor("TOPLEFT", pointLabel, "BOTTOMLEFT", 0, 5)
  dividendLabel:SetExtent(265, FONT_SIZE.LARGE)
  dividendLabel.style:SetFontSize(FONT_SIZE.LARGE)
  dividendLabel.style:SetAlign(ALIGN_LEFT)
  dividendLabel:SetText(GetCommonText("dominion_dividend"))
  ApplyTextColor(dividendLabel, FONT_COLOR.DEFAULT)
  local dividend = window:CreateChildWidget("textbox", "dividend", 0, true)
  dividend:AddAnchor("LEFT", dividendLabel, "RIGHT", 5, 0)
  dividend:SetExtent(160, FONT_SIZE.LARGE)
  dividend.style:SetFontSize(FONT_SIZE.LARGE)
  dividend.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(dividend, FONT_COLOR.BLUE)
  local rightPanel = CreateScrollWindow(window, "rightPanel", 0)
  local bg = rightPanel:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", rightPanel, 0, -10)
  bg:AddAnchor("BOTTOMRIGHT", rightPanel, 10, 10)
  rightPanel:AddAnchor("TOPRIGHT", parent, -10, 10)
  rightPanel:SetExtent(375, 550)
  rightPanel.contentHeight = 0
  local housingLabel = rightPanel.content:CreateChildWidget("label", "housingLabel", 0, true)
  housingLabel:AddAnchor("TOPLEFT", rightPanel.content, 15, 16)
  housingLabel:SetExtent(320, FONT_SIZE.LARGE)
  housingLabel.style:SetFontSize(FONT_SIZE.LARGE)
  housingLabel.style:SetAlign(ALIGN_LEFT)
  housingLabel:SetText(GetCommonText("dominion_housing"))
  ApplyTextColor(housingLabel, FONT_COLOR.MIDDLE_TITLE)
  local alterPanel = rightPanel.content:CreateChildWidget("emptywidget", "alterPanel", 0, true)
  local alterBg = rightPanel.content:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  alterBg:SetTextureColor("gray")
  alterBg:AddAnchor("TOPLEFT", alterPanel, 0, 0)
  alterBg:AddAnchor("BOTTOMRIGHT", alterPanel, 0, 0)
  alterPanel:AddAnchor("TOPLEFT", housingLabel, "BOTTOMLEFT", -3, 7)
  alterPanel:SetExtent(339, 95)
  local alterIcon = rightPanel.content:CreateDrawable("ui/nation/icon_equipment.dds", "icon_altar", "background")
  alterIcon:AddAnchor("TOPLEFT", alterPanel, 0, 0)
  alterIcon:AddAnchor("BOTTOMLEFT", alterPanel, 256, 0)
  alterIcon.colored = "icon_altar"
  alterIcon.gray = "icon_altar_gray"
  local alterText = rightPanel.content:CreateChildWidget("textbox", "alterText", 0, true)
  alterText:AddAnchor("LEFT", alterPanel, 94, 0)
  alterText:SetWidth(230)
  alterText.style:SetFontSize(FONT_SIZE.LARGE)
  alterText.style:SetAlign(ALIGN_LEFT)
  alterText:SetAutoResize(true)
  alterText:SetText([[
HI
HI]])
  local line = CreateLine(rightPanel.content, "TYPE1")
  line:AddAnchor("TOPLEFT", alterPanel, "BOTTOMLEFT", 0, 9)
  line:AddAnchor("TOPRIGHT", alterPanel, "BOTTOMRIGHT", 0, 9)
  rightPanel.contentHeight = 16 + housingLabel:GetHeight() + 7 + alterPanel:GetHeight() + 20
  local housingPanel = {}
  local housingBg = {}
  local housingIcon = {}
  local housingText = {}
  for i = 2, DHG_MAX - 1 do
    housingPanel[i - 1] = rightPanel.content:CreateChildWidget("emptywidget", "housingPanel" .. tostring(i - 1), 0, true)
    housingBg[i - 1] = rightPanel.content:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
    housingBg[i - 1]:SetTextureColor("gray")
    housingBg[i - 1]:AddAnchor("TOPLEFT", housingPanel[i - 1], 0, 0)
    housingBg[i - 1]:AddAnchor("BOTTOMRIGHT", housingPanel[i - 1], 0, 0)
    housingPanel[i - 1]:SetExtent(339, 80)
    housingIcon[i - 1] = rightPanel.content:CreateDrawable("ui/nation/icon_equipment.dds", "icon_equipment_" .. tostring(i - 1), "background")
    housingIcon[i - 1]:AddAnchor("TOPLEFT", housingPanel[i - 1], 0, 0)
    housingIcon[i - 1]:AddAnchor("BOTTOMLEFT", housingPanel[i - 1], 105, 0)
    housingIcon[i - 1].colored = "icon_equipment_" .. tostring(i - 1)
    housingIcon[i - 1].gray = "icon_equipment_" .. tostring(i - 1) .. "_gray"
    housingText[i - 1] = rightPanel.content:CreateChildWidget("textbox", "housingText" .. tostring(i - 1), 0, true)
    housingText[i - 1]:AddAnchor("LEFT", housingPanel[i - 1], 94, 0)
    housingText[i - 1]:SetWidth(230)
    housingText[i - 1].style:SetFontSize(FONT_SIZE.MIDDLE)
    housingText[i - 1].style:SetAlign(ALIGN_LEFT)
    housingText[i - 1]:SetAutoResize(true)
    housingText[i - 1]:SetText([[
HI
HI]])
    if i == 2 then
      housingPanel[i - 1]:AddAnchor("TOPLEFT", alterPanel, "BOTTOMLEFT", 0, 20)
    else
      housingPanel[i - 1]:AddAnchor("TOPLEFT", housingPanel[i - 2], "BOTTOMLEFT", 0, 0)
    end
    rightPanel.contentHeight = rightPanel.contentHeight + housingPanel[i - 1]:GetHeight()
  end
  function window:Init(list)
    if #list <= 0 then
      return
    end
    local datas = {}
    for i = 1, #list do
      local type = list[i]
      local data = {
        text = string.format("%s - %s", X2Dominion:GetZoneGroupName(type), X2Dominion:GetOwnerFactionName(type)),
        value = type
      }
      table.insert(datas, data)
    end
    combo:AppendItems(datas)
  end
  function combo:SelectedProc(selIndex)
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    window:FillInfo(info.value)
  end
  function window:FillOneHousing(bg, bg_color, icon, text, name, desc_text, build_text)
    if desc_text == nil or desc_text == "" then
      icon:SetTextureInfo(icon.gray)
      bg:SetTextureColor("gray")
      text:SetText(string.format([[
%s%s
%s%s]], F_COLOR.GetColor("default", true), name, F_COLOR.GetColor("gray", true), GetCommonText("housing_not_exist")))
    else
      icon:SetTextureInfo(icon.colored)
      bg:SetTextureColor(bg_color)
      text:SetText(string.format([[
%s%s
%s
%s%s]], F_COLOR.GetColor("default", true), name, desc_text, F_COLOR.GetColor("blue", true), build_text))
    end
  end
  function window:FillInfo(zoneGroup)
    local info = X2Nation:GetNationalDominionInfo(zoneGroup)
    if info == nil then
      return
    end
    local factionId = X2Dominion:GetOwnerFaction(zoneGroup)
    window.originMap:FillMapInfo(factionId, zoneGroup)
    dominionName:SetText(X2Dominion:GetZoneGroupName(zoneGroup))
    factionName:SetText(X2Dominion:GetOwnerFactionName(zoneGroup))
    charge:SetText(string.format("|m%s;", tostring(info.charge)))
    totalPoint:SetText(CommaStr(info.totalPoint))
    point:SetText(CommaStr(info.point))
    dividend:SetText(string.format("|m%s;", tostring(info.dividend)))
    window:FillOneHousing(alterBg, "orange_2", alterIcon, alterText, GetCommonText("dominion_building_1"), info.castle[1], GetCommonText("worshiping"))
    for i = 2, #info.castle do
      window:FillOneHousing(housingBg[i - 1], "orange", housingIcon[i - 1], housingText[i - 1], GetCommonText("dominion_building_" .. tostring(i)), info.castle[i], GetCommonText("managing"))
    end
    rightPanel:ResetScroll(rightPanel.contentHeight)
  end
  return window
end
local CreateNoneDominionView = function(parent)
  local window = parent:CreateChildWidget("emptywidget", "noneDominionView", 0, true)
  window:Show(false)
  window:AddAnchor("TOPLEFT", parent, 0, 0)
  window:AddAnchor("BOTTOMRIGHT", parent, 0, 0)
  local topPanel = window:CreateChildWidget("emptywidget", "topPanel", 0, true)
  topPanel:AddAnchor("TOP", window, 0, 0)
  topPanel:SetExtent(860, 110)
  local title = topPanel:CreateChildWidget("textbox", "title", 0, true)
  title:AddAnchor("CENTER", topPanel, 0, 0)
  title:SetAutoResize(true)
  title:SetWidth(750)
  title:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, FONT_COLOR.DEFAULT)
  title:SetText(GetCommonText("nodominion_title"))
  local bottomPanel = window:CreateChildWidget("emptywidget", "bottomPanel", 0, true)
  local bg = bottomPanel:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", bottomPanel, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", bottomPanel, 0, 0)
  bottomPanel:AddAnchor("TOP", topPanel, "BOTTOM", 0, 0)
  bottomPanel:SetExtent(860, 487)
  NODOMINION_CONTEXT = {
    {
      title = "nodominion_guide_title_1",
      content = "nodominion_guide_content_1",
      align = ALIGN_CENTER
    },
    {
      title = "nodominion_guide_title_2",
      content = "nodominion_guide_content_2",
      align = ALIGN_CENTER
    },
    {
      title = "nodominion_guide_title_3",
      content = "nodominion_guide_content_3",
      align = ALIGN_CENTER
    },
    {
      title = "nodominion_guide_title_4",
      content = "nodominion_guide_content_4",
      align = ALIGN_CENTER
    }
  }
  CreateInfomationGuideContext(bottomPanel)
  bottomPanel.guideContext:SetExtent(750, 450)
  bottomPanel.guideContext:AddAnchor("CENTER", bottomPanel, 0, 0)
  bottomPanel.guideContext.scroll:RemoveAllAnchors()
  bottomPanel.guideContext.scroll:AddAnchor("RIGHT", bottomPanel, -9, 0)
  bottomPanel:FillData(NODOMINION_CONTEXT, ALIGN_CENTER)
end
function CreateDominionTabOfNationMgr(window)
  local dominionView = CreateDomonionInfo("dominionView", window)
  CreateNoneDominionView(window)
  local function NoneDominion(isNone)
    dominionView:Show(not isNone)
    window.noneDominionView:Show(isNone)
  end
  function window:Init()
    local list = X2Nation:GetDominionListAll()
    NoneDominion(#list == 0)
    dominionView:Init(list)
  end
  function window:FillInfo(zoneGroupType)
    dominionView:FillInfo(zoneGroupType)
  end
  local events = {
    NATION_DOMINION = function(zoneGroupType)
      dominionView:FillInfo(zoneGroupType)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
