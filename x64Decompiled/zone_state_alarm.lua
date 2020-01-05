local DELAY = 5000
local SHOW_DELAY = 500
local HIDE_DELAY = 500
local WND_HEIGHT = 160
local function CreateZoneStateAlarmWindow(id, parent)
  local wnd = UIParent:CreateWidget("window", id, parent)
  wnd:SetExtent(450, WND_HEIGHT)
  wnd:EnableHidingIsRemove(true)
  wnd:SetUILayer("system")
  wnd:Clickable(true)
  local bottomBg = CreateContentBackground(wnd, "TYPE1", "black")
  bottomBg:AddAnchor("TOPLEFT", wnd, 0, -10)
  bottomBg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  local closeBtn = wnd:CreateChildWidget("button", "closeBtn", 0, true)
  ApplyButtonSkin(closeBtn, BUTTON_HUD.RISK_ALARM_CLOSE)
  closeBtn:AddAnchor("TOPRIGHT", wnd, -MARGIN.WINDOW_SIDE, MARGIN.WINDOW_SIDE / 4)
  function closeBtn:OnClick()
    wnd:Show(false)
  end
  closeBtn:SetHandler("OnClick", closeBtn.OnClick)
  local title = wnd:CreateChildWidget("label", "title", 0, true)
  title:SetText("")
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.XXLARGE)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  title:AddAnchor("TOP", wnd, 0, MARGIN.WINDOW_SIDE)
  title.style:SetColor(0.99, 1, 0.62, 1)
  local statusWnd = wnd:CreateChildWidget("emptywidget", "statusWnd", 0, true)
  statusWnd:SetHeight(FONT_SIZE.XXLARGE)
  statusWnd:AddAnchor("TOP", title, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  local bg = statusWnd:CreateDrawable(TEXTURE_PATH.RISK_ALARM, "risk_alarm_back02", "background")
  local icon = statusWnd:CreateDrawable(TEXTURE_PATH.RISK_ALARM, "peace", "background")
  icon:AddAnchor("LEFT", statusWnd, 0, 0)
  local label = statusWnd:CreateChildWidget("label", "label", 0, true)
  label:SetAutoResize(true)
  label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
  label:AddAnchor("LEFT", icon, "RIGHT", 0, 0)
  local desc = wnd:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetWidth(wnd:GetWidth() - MARGIN.WINDOW_SIDE * 2)
  desc:AddAnchor("TOP", statusWnd, "BOTTOM", 0, MARGIN.WINDOW_SIDE)
  desc:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  desc:SetAutoResize(true)
  desc.style:SetFontSize(FONT_SIZE.LARGE)
  local accumulate = 0
  function wnd:OnUpdate(dt)
    accumulate = accumulate + dt
    if accumulate > DELAY then
      wnd:Show(false, HIDE_DELAY)
    end
  end
  function wnd:Resize()
    statusWnd:SetWidth(icon:GetWidth() + label:GetWidth())
    bg:RemoveAllAnchors()
    bg:AddAnchor("CENTER", statusWnd, 0, 0)
    local _, wOffsetY = wnd:GetOffset()
    local _, dOffsetY = desc:GetOffset()
    local dHeight = desc:GetHeight()
    local diff = wOffsetY + WND_HEIGHT - (dOffsetY + dHeight)
    if diff >= 30 then
      wnd:SetHeight(WND_HEIGHT)
    else
      wnd:SetHeight(WND_HEIGHT + 30 - diff)
    end
  end
  function wnd:SetInfo(zoneInfo)
    if zoneInfo == nil then
      return
    end
    local color = GetMsgZoneStateFontColor(zoneInfo)
    if color ~= nil then
      ApplyTextColor(label, color)
      icon:SetColor(color[1], color[2], color[3], color[4])
    end
    title:SetText(zoneInfo.zoneName)
    if zoneInfo.isFestivalZone then
      icon:SetTextureInfo("festival")
      label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
      label:SetText(GetCommonText("festival_zone"))
      desc:SetText(GetCommonText("festival_zone_msg_desc"))
    elseif zoneInfo.isConflictZone then
      local isDangerState = zoneInfo.conflictState < HPWS_BATTLE
      if isDangerState then
        icon:SetWidth(0)
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
        label:SetText(locale.honorPointWar.getZoneState(zoneInfo.conflictState))
        desc:SetText(GetCommonText("low_conflict_zone_msg_desc"))
      elseif zoneInfo.conflictState == HPWS_BATTLE then
        icon:SetTextureInfo("war")
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
        label:SetText(locale.honorPointWar.getZoneStateHud(zoneInfo.conflictState))
        if zoneInfo.warChaos or zoneInfo.nonPeaceState then
          desc:SetText(GetCommonText("conflict_zone_msg_desc"))
        else
          desc:SetText(GetCommonText("middle_conflict_zone_msg_desc"))
        end
      elseif zoneInfo.conflictState == HPWS_WAR then
        icon:SetTextureInfo("war")
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
        label:SetText(locale.honorPointWar.getZoneStateHud(zoneInfo.conflictState))
        if zoneInfo.warChaos then
          desc:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "chaos_zone_msg_desc", GetHexColorForString(Dec2Hex(color))))
        elseif zoneInfo.nonPeaceState then
          desc:SetText(GetCommonText("conflict_zone_msg_desc"))
        else
          local zoneText = X2Locale:LocalizeUiText(COMMON_TEXT, "high_conflict_zone_msg_desc", tostring(zoneInfo.dropRate - 100), tostring(zoneInfo.goldRate - 100))
          desc:SetText(zoneText)
        end
      elseif zoneInfo.conflictState == HPWS_PEACE then
        icon:SetTextureInfo("peace")
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
        label:SetText(locale.honorPointWar.getZoneStateHud(zoneInfo.conflictState))
        local zoneText = X2Locale:LocalizeUiText(COMMON_TEXT, "peace_conflict_zone_msg_desc", tostring(100 - zoneInfo.dropRate), tostring(100 - zoneInfo.goldRate))
        desc:SetText(zoneText)
      end
    elseif zoneInfo.isSiegeZone then
      icon:SetTextureInfo("war")
      label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
      label:SetText(GetCommonText("conflict_zone"))
      desc:SetText(GetCommonText("conflict_zone_msg_desc"))
    else
      label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
      if zoneInfo.isNuiaProtectedZone then
        icon:SetWidth(0)
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
        label:SetText(GetCommonText("nuia_protection_zone"))
        desc:SetText(GetCommonText("nuia_protection_zone_msg_desc"))
      elseif zoneInfo.isHariharaProtectedZone then
        icon:SetWidth(0)
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
        label:SetText(GetCommonText("harihara_protection_zone"))
        desc:SetText(GetCommonText("harihara_protection_zone_msg_desc"))
      elseif zoneInfo.isPeaceZone then
        icon:SetTextureInfo("peace")
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
        label:SetText(GetCommonText("non_pvp_zone"))
        desc:SetText(GetCommonText("non_pvp_zone_msg_desc"))
      else
        icon:SetTextureInfo("war")
        label.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
        label:SetText(GetCommonText("conflict_zone"))
        desc:SetText(GetCommonText("conflict_zone_msg_desc"))
      end
    end
    accumulate = 0
    self:Resize()
  end
  return wnd
end
local windowWidth = UIParent:GetScreenWidth()
local windowHeight = UIParent:GetScreenHeight()
local zoneStateAlarmWnd
function ShowZoneStateAlarmWindow(zoneInfo)
  if zoneStateAlarmWnd == nil then
    zoneStateAlarmWnd = CreateZoneStateAlarmWindow("zoneStateAlarmWnd", "UIParent")
    zoneStateAlarmWnd:AddAnchor("TOP", "UIParent", "TOPLEFT", windowWidth * 3 / 4, windowHeight / 4)
    function zoneStateAlarmWnd:OnHide()
      zoneStateAlarmWnd = nil
    end
    zoneStateAlarmWnd:SetHandler("OnHide", zoneStateAlarmWnd.OnHide)
    zoneStateAlarmWnd:SetHandler("OnUpdate", zoneStateAlarmWnd.OnUpdate)
  end
  zoneStateAlarmWnd:SetInfo(zoneInfo)
  zoneStateAlarmWnd:Show(true, SHOW_DELAY)
end
