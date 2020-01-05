local dayEvnetAlarmWnd
local GetDayInfo = function(day)
  if day == "monday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "monday_title_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "monday_title_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "monday_title_3")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "monday_content_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "monday_content_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "monday_content_3")
    }
    return dayInfoTable
  elseif day == "tuesday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "tuesday_title_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "tuesday_title_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "tuesday_title_3")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "tuesday_content_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "tuesday_content_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "tuesday_content_3")
    }
    return dayInfoTable
  elseif day == "wednesday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "wendesday_title_1")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "wendesday_content_1")
    }
    return dayInfoTable
  elseif day == "thursday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "thursday_title_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "thursday_title_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "thursday_title_3")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "thursday_content_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "thursday_content_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "thursday_content_3")
    }
    return dayInfoTable
  elseif day == "friday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "friday_title_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "friday_title_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "friday_title_3")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "friday_content_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "friday_content_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "friday_content_3")
    }
    return dayInfoTable
  elseif day == "saturday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "saturday_title_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "saturday_title_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "saturday_title_3")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "saturday_content_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "saturday_content_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "saturday_content_3")
    }
    return dayInfoTable
  elseif day == "sunday" then
    local dayInfoTable = {}
    dayInfoTable.title = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "sunday_title_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "sunday_title_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "sunday_title_3")
    }
    dayInfoTable.contents = {
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "sunday_content_1"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "sunday_content_2"),
      X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "sunday_content_3")
    }
    return dayInfoTable
  end
  return
end
local function CreateDayEventAlarmWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(WINDOW_SIZE.SMALL, 360)
  window:EnableHidingIsRemove(true)
  window:SetTitle(X2Locale:LocalizeUiText(DAY_EVENT_TEXT, "title"))
  window:AddAnchor("TOPLEFT", parent, 60, 160)
  function window:FillData()
    local dayInfos = GetDayInfo(X2Time:GetLocalWeek())
    for i = 1, #dayInfos.title do
      local frame = self:CreateChildWidget("window", "contentFame", i, true)
      frame:SetExtent(260, 30)
      frame:SetTitleText(dayInfos.title[i])
      frame.titleStyle:SetAlign(ALIGN_TOP_LEFT)
      frame.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
      ApplyTitleFontColor(frame, FONT_COLOR.TITLE)
      if i == 1 then
        frame:AddAnchor("TOP", self, 0, titleMargin)
      else
        frame:AddAnchor("TOP", window.contentFame[i - 1], "BOTTOM", 0, sideMargin)
      end
      if i ~= #dayInfos.title then
        local line = CreateLine(frame, "TYPE1")
        line:SetWidth(280)
        line:AddAnchor("TOP", frame, "BOTTOM", 0, sideMargin / 2 - 2)
      end
      local content = self:CreateChildWidget("textbox", "content", i, false)
      content:SetExtent(260, FONT_SIZE.MIDDLE)
      content:SetText(dayInfos.contents[i])
      content.style:SetAlign(ALIGN_LEFT)
      content:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
      ApplyTextColor(content, FONT_COLOR.DEFAULT)
      local contentHeight = content:GetTextHeight()
      content:SetHeight(contentHeight)
      content:AddAnchor("TOPLEFT", frame, 0, sideMargin)
      frame:SetHeight(sideMargin + contentHeight)
    end
  end
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("BOTTOM", window, 0, -sideMargin)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc(self)
    window:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  local function OnHide()
    dayEvnetAlarmWnd = nil
  end
  window:SetHandler("OnHide", OnHide)
  return window
end
function ToggleDayEventAlarmWindow()
  if dayEvnetAlarmWnd ~= nil then
    dayEvnetAlarmWnd:Show(not dayEvnetAlarmWnd:IsVisible())
  else
    dayEvnetAlarmWnd = CreateDayEventAlarmWindow("dayEvnetAlarmWnd", "UIParent")
    dayEvnetAlarmWnd:Show(true)
    dayEvnetAlarmWnd:FillData()
  end
end
