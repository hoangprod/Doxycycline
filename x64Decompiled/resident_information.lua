local RESIDENT_ICON_WIDTH = 190
local RESIDENT_ICON_HEIGHT = 190
local RESIDENT_FACTION_ICON_SIZE = 128
function SetViewOfResidentInfomation(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = parent:CreateChildWidget("emptywidget", "frame", 0, true)
  frame:Show(true)
  frame:SetExtent(parent:GetWidth(), parent:GetHeight())
  frame:AddAnchor("TOP", parent, 0, 0)
  local nameBg = frame:CreateDrawable(TEXTURE_PATH.COMMUNITY_COMMON, "text_bg", "background")
  nameBg:AddAnchor("TOP", frame, 0, 0)
  local nameLabel = frame:CreateChildWidget("label", "nameLabel", 0, true)
  nameLabel:SetAutoResize(true)
  nameLabel:SetHeight(FONT_SIZE.XXLARGE)
  nameLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  nameLabel:AddAnchor("CENTER", nameBg, "CENTER", 0, 0)
  nameLabel.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(nameLabel, FONT_COLOR.DEFAULT)
  local iconPlate = frame:CreateDrawable(TEXTURE_PATH.RESIDENT_BG, "picture", "overlay")
  iconPlate:AddAnchor("LEFT", frame, 5, 5)
  iconPlate:AddAnchor("TOP", nameBg, "BOTTOM", 0, 0)
  frame.iconPlate = iconPlate
  local factionIcon = frame:CreateImageDrawable(TEXTURE_PATH.DEFAULT, "overlay")
  factionIcon:AddAnchor("CENTER", iconPlate, 0, 0)
  factionIcon:SetVisible(false)
  factionIcon:SetCoords(0, 0, RESIDENT_FACTION_ICON_SIZE, RESIDENT_FACTION_ICON_SIZE)
  factionIcon:SetExtent(RESIDENT_FACTION_ICON_SIZE, RESIDENT_FACTION_ICON_SIZE)
  frame.factionIcon = factionIcon
  local midWin = parent:CreateChildWidget("emptywidget", "midWin", 0, true)
  midWin:SetExtent(parent:GetWidth() - iconPlate:GetWidth() - sideMargin, parent:GetHeight() - nameBg:GetHeight() + bottomMargin)
  midWin:AddAnchor("TOPLEFT", iconPlate, "TOPRIGHT", 16, 0)
  midWin:Show(true)
  parent.midWin = midWin
  local localEffect = midWin:CreateChildWidget("label", "localEffect", 0, true)
  localEffect:SetAutoResize(true)
  localEffect:SetHeight(FONT_SIZE.LARGE)
  localEffect.style:SetFontSize(FONT_SIZE.LARGE)
  localEffect:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_effect") .. " : ")
  localEffect:AddAnchor("TOPLEFT", midWin, 0, 0)
  localEffect.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(localEffect, FONT_COLOR.DEFAULT)
  local localFaction = midWin:CreateChildWidget("label", "localFaction", 0, true)
  localFaction:SetAutoResize(true)
  localFaction:SetHeight(FONT_SIZE.LARGE)
  localFaction.style:SetFontSize(FONT_SIZE.LARGE)
  localFaction:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_faction") .. " : ")
  localFaction:AddAnchor("TOPLEFT", localEffect, "BOTTOMLEFT", 0, 15)
  localFaction.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(localFaction, FONT_COLOR.DEFAULT)
  local residentCond = midWin:CreateChildWidget("label", "residentCond", 0, true)
  residentCond:SetAutoResize(true)
  residentCond:SetHeight(FONT_SIZE.LARGE)
  residentCond.style:SetFontSize(FONT_SIZE.LARGE)
  residentCond:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_status") .. " ")
  residentCond:AddAnchor("TOPLEFT", localFaction, "BOTTOMLEFT", 0, 15)
  residentCond.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(residentCond, FONT_COLOR.DEFAULT)
  local residentIcon = midWin:CreateDrawable(TEXTURE_PATH.RESIDENT_ICON, "outsider", "background")
  residentIcon:AddAnchor("LEFT", residentCond, "RIGHT", 10, 0)
  residentIcon:Show(false)
  frame.residentIcon = residentIcon
  local servicePoint = midWin:CreateChildWidget("textbox", "servicePoint", 0, true)
  servicePoint:SetExtent(180, FONT_SIZE.LARGE)
  servicePoint.style:SetFontSize(FONT_SIZE.LARGE)
  servicePoint:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_my_service_point") .. " : ")
  servicePoint:AddAnchor("TOPLEFT", residentCond, "BOTTOMLEFT", 0, 15)
  servicePoint.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(servicePoint, FONT_COLOR.DEFAULT)
  function servicePoint:OnEnter(self)
    SetTooltip(GetCommonText("resident_townhall_tooltip_service_point"), servicePoint)
  end
  servicePoint:SetHandler("OnEnter", servicePoint.OnEnter)
  function servicePoint:OnLeave()
    HideTooltip()
  end
  servicePoint:SetHandler("OnLeave", servicePoint.OnLeave)
  local memberCount = midWin:CreateChildWidget("textbox", "memberCount", 0, true)
  memberCount:SetExtent(180, FONT_SIZE.LARGE)
  memberCount.style:SetFontSize(FONT_SIZE.LARGE)
  memberCount:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_member_count") .. " : ")
  memberCount:AddAnchor("TOPLEFT", servicePoint, "BOTTOMLEFT", 0, 15)
  memberCount.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(memberCount, FONT_COLOR.DEFAULT)
  local localCharge = midWin:CreateChildWidget("label", "localCharge", 0, true)
  localCharge:SetExtent(180, FONT_SIZE.LARGE)
  localCharge.style:SetFontSize(FONT_SIZE.LARGE)
  localCharge:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_total_charge"))
  localCharge:AddAnchor("TOPLEFT", memberCount, "BOTTOMLEFT", 0, 15)
  localCharge.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(localCharge, FONT_COLOR.DEFAULT)
  function ChargeOnEnter(self)
    SetTooltip(GetCommonText("resident_townhall_tooltip_charge"), localCharge)
  end
  function ChargeOnLeave()
    HideTooltip()
  end
  localCharge:SetHandler("OnEnter", ChargeOnEnter)
  localCharge:SetHandler("OnLeave", ChargeOnLeave)
  local localChargeRight = midWin:CreateChildWidget("textbox", "localChargeRight", 0, true)
  localChargeRight:SetExtent(midWin:GetWidth() - 180, FONT_SIZE.LARGE)
  localChargeRight.style:SetFontSize(FONT_SIZE.LARGE)
  localChargeRight:AddAnchor("LEFT", localCharge, "RIGHT", 0, 0)
  localChargeRight.style:SetAlign(ALIGN_RIGHT)
  ApplyTextColor(localChargeRight, FONT_COLOR.DEFAULT)
  localChargeRight:SetHandler("OnEnter", ChargeOnEnter)
  localChargeRight:SetHandler("OnLeave", ChargeOnLeave)
  local guideButton = midWin:CreateChildWidget("button", "guideButton", 0, true)
  ApplyButtonSkin(guideButton, BUTTON_BASIC.QUESTION_MARK)
  guideButton:Show(true)
  guideButton:AddAnchor("TOPRIGHT", midWin, 0, 55)
  return frame
end
function CreateResidentInfomation(id, parent)
  local frame = SetViewOfResidentInfomation(id, parent)
  local midWin = parent.midWin
  RESIDENT_WINDOW = {
    {
      title = "resident_townhall_guide_title_1",
      content = "resident_townhall_guide_content_1"
    },
    {
      title = "resident_townhall_guide_title_2",
      content = "resident_townhall_guide_content_2"
    },
    {
      title = "resident_townhall_guide_title_3",
      content = "resident_townhall_guide_content_3"
    }
  }
  local guideWindow = CreateInfomationGuideWindow(id, residentTownhall, "resident_townhall_guide", RESIDENT_WINDOW)
  frame.guideWindow = guideWindow
  guideWindow:Show(false)
  guideWindow:AddAnchor("TOPRIGHT", parent, 0, 10)
  function midWin.guideButton:OnClick()
    if guideWindow:IsVisible() then
      guideWindow:Show(false)
    else
      guideWindow:Show(true)
    end
  end
  midWin.guideButton:SetHandler("OnClick", midWin.guideButton.OnClick)
  function parent:RefreshTab()
    local zoneGroup = X2Unit:GetCurrentZoneGroup()
    X2Resident:GetResidentDesc(zoneGroup)
  end
  function parent:OnFillData(info)
    local data = ""
    frame.nameLabel:SetText(info.name)
    if info.localEffect ~= nil then
      data = info.localEffect
    else
      data = ""
    end
    midWin.localEffect:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_effect") .. " : " .. data)
    if info.localFaction ~= nil then
      data = info.localFaction
    else
      data = ""
    end
    midWin.localFaction:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_faction") .. " : " .. data)
    if info.localFactionIcon ~= nil then
      frame.factionIcon:SetTexture(info.localFactionIcon)
      frame.factionIcon:SetVisible(true)
    else
      frame.factionIcon:SetVisible(false)
    end
    if info.isResident ~= nil then
      local checkResident = info.isResident
      if checkResident == true then
        frame.residentIcon:SetTextureInfo("resident")
        residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.MEMBERS)].isResident = true
      else
        frame.residentIcon:SetTextureInfo("outsider")
        residentTownhall.tab.window[RESIDENT_TAB_I2V(RESIDENT_TAB_IDX.MEMBERS)].isResident = false
      end
      frame.residentIcon:Show(true)
    else
      frame.residentIcon:Show(false)
    end
    if info.servicePoint ~= nil then
      data = string.format("%s%s", FONT_COLOR_HEX.BLUE, tostring(info.servicePoint))
    else
      data = ""
    end
    midWin.servicePoint:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_my_service_point") .. " : " .. data)
    if info.memberCount ~= nil then
      data = string.format("%s%s", FONT_COLOR_HEX.BLUE, tostring(info.memberCount))
    else
      data = ""
    end
    midWin.memberCount:SetText(GetUIText(COMMON_TEXT, "resident_townhall_area_member_count") .. " : " .. data)
    if info.localCharge ~= nil then
      data = string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(info.localCharge))
    else
      data = ""
    end
    midWin.localChargeRight:SetText(data)
  end
  function parent:HideWindow()
    guideWindow:Show(false)
  end
end
