local CreateEmptyWnd = function(id, parent, key, bgColor)
  local emptyWnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = emptyWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, key, "background")
  bg:SetTextureColor(bgColor)
  bg:AddAnchor("TOPLEFT", emptyWnd, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", emptyWnd, 0, 0)
  return emptyWnd
end
function SetViewOfCommanderAppointWnd(parent, info)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local wnd = CreateWindow("CommanderAppointWnd", parent)
  wnd:SetExtent(510, 380)
  wnd:AddAnchor("CENTER", parent, 0, 0)
  wnd:SetTitle(locale.siegeRaid.appointWindowTitle)
  wnd:SetCloseOnEscape(true)
  wnd:EnableHidingIsRemove(true)
  local subTitle = wnd:CreateChildWidget("textbox", "subTitle", 0, true)
  subTitle:SetExtent(440, FONT_SIZE.MIDDLE)
  subTitle:AddAnchor("TOP", wnd, 0, 50)
  subTitle:SetLineSpace(TEXTBOX_LINE_SPACE.MIDDLE)
  subTitle:SetAutoResize(true)
  subTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  subTitle.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(subTitle, FONT_COLOR.DEFAULT)
  local desc = ""
  if info then
    local factionName = ""
    local commnaderName = ""
    if info.factionId then
      factionName = X2Nation:GetNationName(info.factionId)
    end
    if info.defender then
      commnaderName = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_defender_commander")
    else
      commnaderName = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_attacker_commander")
    end
    desc = X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_appoint_window_desc", factionName, commnaderName)
  end
  subTitle:SetText(desc)
  local data = {
    title = locale.siegeRaid.teamSuggestionsTitle
  }
  local alertTitle = W_MODULE:Create("alertTitle", wnd, WINDOW_MODULE_TYPE.TITLE_BOX, data)
  alertTitle:AddAnchor("TOP", subTitle, "BOTTOM", 0, 8)
  local alertDesc = alertTitle:CreateChildWidget("textbox", "alertDesc", 0, true)
  alertDesc:SetExtent(440, 220)
  alertDesc:SetAutoResize(true)
  alertDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
  alertDesc.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(alertDesc, FONT_COLOR.RED)
  alertDesc:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "siege_raid_team_suggestions_desc", tostring(X2Player:GetForceAttackLimitLevel())))
  alertTitle:AddBody(alertDesc)
  local confirmBtn = wnd:CreateChildWidget("button", "confirmBtn", 0, true)
  confirmBtn:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "ok"))
  confirmBtn:AddAnchor("TOP", alertTitle, "BOTTOM", 0, 10)
  ApplyButtonSkin(confirmBtn, BUTTON_BASIC.DEFAULT)
  local _, height = F_LAYOUT.GetExtentWidgets(wnd.titleBar, alertTitle)
  wnd:SetHeight(height + confirmBtn:GetHeight() + 30)
  return wnd
end
