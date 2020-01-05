function SetttingUIAnimation(window)
  local time = 0.1
  local time_2 = 0.1
  window:SetScaleAnimation(0.95, 1, time, time_2, "CENTER")
  window:SetAlphaAnimation(0, 1, time, time_2)
end
POPUP_WINDOW_WIDTH = 352
POPUP_WINDOW_DEFAULT_HEIGHT = 200
function SettingWindowSkin(window)
  local path = TEXTURE_PATH.DEFAULT
  local SetTextureVisible = function(wnd, visible)
    if wnd.colorTexture ~= nil then
      wnd.colorTexture:SetVisible(visible)
    end
    if wnd.upperTexture ~= nil then
      wnd.upperTexture:SetVisible(visible)
    end
    if wnd.lowerTexture_left ~= nil then
      wnd.lowerTexture_left:SetVisible(visible)
    end
    if wnd.lowerTexture_right ~= nil then
      wnd.lowerTexture_right:SetVisible(visible)
    end
  end
  local function SwitchPopUpWindowSkin(wnd, isPopupWnd)
    if isPopupWnd then
      if wnd.bg ~= nil then
        wnd.bg:SetVisible(true)
      end
      SetTextureVisible(wnd, false)
    else
      if wnd.bg ~= nil then
        wnd.bg:SetVisible(false)
      end
      SetTextureVisible(wnd, true)
    end
  end
  local function SettingPopUpWindowSkin(wnd)
    wnd.titleBar:SetTitleInset(0, 0, 0, 0)
    wnd.titleBar.closeButton:AddAnchor("TOPRIGHT", wnd, -2, 3)
    if wnd.bg == nil then
      wnd.bg = wnd:CreateDrawable(path, "setting_popup_window", "background")
      wnd.bg:AddAnchor("TOPLEFT", wnd, 0, 0)
      wnd.bg:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
    end
  end
  local width = math.floor(window:GetWidth() + 0.5)
  local height = math.floor(window:GetHeight() + 0.5)
  local upperCoords, lowerCoords_l, lowerCoords_r, anchorValue
  if width == POPUP_WINDOW_WIDTH or width == 310 then
    SettingPopUpWindowSkin(window)
    SwitchPopUpWindowSkin(window, true)
    return
  elseif width == WINDOW_SIZE.SMALL then
    anchorValue = 6
  elseif width == 430 then
    anchorValue = 10
  elseif width == 510 then
    anchorValue = 7
  elseif width == 600 then
    anchorValue = 8
  elseif width == 680 then
    anchorValue = 9
  elseif width == 800 then
    anchorValue = 12
  elseif width == 900 then
    anchorValue = 14
  else
    anchorValue = -20
    X2Util:RaiseLuaCallStack(string.format("invalid width - %d", width))
  end
  SwitchPopUpWindowSkin(window, false)
  window.titleBar:SetTitleInset(0, 0, 0, 10)
  if width <= 445 then
    if height < 246 then
      local temp_value = math.floor(height / 2 + 0.5) + 55
      upperCoords = {
        0,
        332,
        445,
        temp_value
      }
      lowerCoords_l = {
        727,
        246 - temp_value,
        221,
        temp_value
      }
      lowerCoords_r = {
        948,
        246 - temp_value,
        -221,
        temp_value
      }
    else
      upperCoords = {
        0,
        332,
        445,
        249
      }
      lowerCoords_l = {
        727,
        0,
        221,
        246
      }
      lowerCoords_r = {
        948,
        0,
        -221,
        246
      }
    end
  elseif height <= 331 then
    local temp_value = math.floor(height / 2 + 0.5) + 55
    upperCoords = {
      0,
      0,
      726,
      temp_value
    }
    lowerCoords_l = {
      0,
      914 - temp_value,
      360,
      temp_value
    }
    lowerCoords_r = {
      360,
      914 - temp_value,
      -360,
      temp_value
    }
  else
    upperCoords = {
      0,
      0,
      726,
      331
    }
    lowerCoords_l = {
      0,
      582,
      360,
      332
    }
    lowerCoords_r = {
      360,
      582,
      -360,
      332
    }
  end
  if window.colorTexture == nil then
    window.colorTexture = window:CreateDrawable(path, "window_color_texture_bg", "background")
    window.colorTexture:AddAnchor("TOPLEFT", window, 0, 0)
    window.colorTexture:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  end
  if window.upperTexture == nil then
    window.upperTexture = window:CreateImageDrawable(path, "background")
    window.upperTexture:SetCoords(upperCoords[1], upperCoords[2], upperCoords[3], upperCoords[4])
    window.upperTexture:SetHeight(upperCoords[4])
    window.upperTexture:AddAnchor("TOPLEFT", window, -anchorValue, -11)
    window.upperTexture:AddAnchor("TOPRIGHT", window, anchorValue, -11)
  else
    window.upperTexture:SetCoords(upperCoords[1], upperCoords[2], upperCoords[3], upperCoords[4])
    window.upperTexture:SetHeight(upperCoords[4])
    window.upperTexture:RemoveAllAnchors()
    window.upperTexture:AddAnchor("TOPLEFT", window, -anchorValue, -11)
    window.upperTexture:AddAnchor("TOPRIGHT", window, anchorValue, -11)
  end
  if window.lowerTexture_left == nil then
    window.lowerTexture_left = window:CreateImageDrawable(path, "background")
    window.lowerTexture_left:SetCoords(lowerCoords_l[1], lowerCoords_l[2], lowerCoords_l[3], lowerCoords_l[4])
    window.lowerTexture_left:SetExtent(width / 2 + anchorValue, lowerCoords_l[4])
    window.lowerTexture_left:AddAnchor("BOTTOMLEFT", window, -anchorValue, 11)
  else
    window.lowerTexture_left:SetCoords(lowerCoords_l[1], lowerCoords_l[2], lowerCoords_l[3], lowerCoords_l[4])
    window.lowerTexture_left:SetExtent(width / 2 + anchorValue, lowerCoords_l[4])
    window.lowerTexture_left:RemoveAllAnchors()
    window.lowerTexture_left:AddAnchor("BOTTOMLEFT", window, -anchorValue, 11)
  end
  if window.lowerTexture_right == nil then
    window.lowerTexture_right = window:CreateImageDrawable(path, "background")
    window.lowerTexture_right:SetCoords(lowerCoords_r[1], lowerCoords_r[2], lowerCoords_r[3], lowerCoords_r[4])
    window.lowerTexture_right:SetExtent(width / 2 + anchorValue, lowerCoords_r[4])
    window.lowerTexture_right:AddAnchor("BOTTOMRIGHT", window, anchorValue, 11)
  else
    window.lowerTexture_right:SetCoords(lowerCoords_r[1], lowerCoords_r[2], lowerCoords_r[3], lowerCoords_r[4])
    window.lowerTexture_right:SetExtent(width / 2 + anchorValue, lowerCoords_r[4])
    window.lowerTexture_right:RemoveAllAnchors()
    window.lowerTexture_right:AddAnchor("BOTTOMRIGHT", window, anchorValue, 11)
  end
end
function GetWindowMargin(style)
  local sideMargin = 20
  local titleMargin = 50
  local bottomMargin = -65
  if style == "popup" then
    sideMargin = 20
    titleMargin = 50
    bottomMargin = -30
  elseif style == "tabWindow" then
    sideMargin = 10
    titleMargin = 50
    bottomMargin = -20
  end
  return sideMargin, titleMargin, bottomMargin
end
function SetViewOfTitleBar(id, parent)
  local title = UIParent:CreateWidget("window", id, parent)
  title:Show(true)
  title:SetHeight(45)
  title:AddAnchor("TOPLEFT", parent, 0, 0)
  title:AddAnchor("TOPRIGHT", parent, 0, 0)
  title.titleStyle:SetAlign(ALIGN_CENTER)
  title.titleStyle:SetSnap(true)
  ApplyTitleFontColor(title, FONT_COLOR.TITLE)
  title.titleStyle:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  local closeButton = title:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:Show(true)
  closeButton:AddAnchor("TOPRIGHT", title, -2, 1)
  ApplyButtonSkin(closeButton, BUTTON_BASIC.WINDOW_CLOSE)
  return title
end
function SetViewOfSubOptionWindow(id, parent)
  local window = CreateEmptyWindow(id, parent)
  window:SetSounds("dialog_common")
  CreateTooltipDrawable(window)
  local closeButton = window:CreateChildWidget("button", "closeButton", 0, true)
  closeButton:AddAnchor("TOPRIGHT", window, -5, 5)
  ApplyButtonSkin(closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
  return window
end
function SetViewOfSplitItemWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(POPUP_WINDOW_WIDTH, 180)
  window:SetTitle(locale.common.split_item)
  window.titleBar.closeButton:Show(true)
  window.actor = parent
  window.storeIndex = -1
  window.current = 0
  local button = window:CreateChildWidget("button", "button", 0, true)
  button:Show(true)
  button:SetText(locale.common.ok)
  ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
  button:AddAnchor("BOTTOM", window, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  local spinner = W_ETC.CreateSpinner(window:GetId() .. ".spinner", window)
  spinner:Show(true)
  spinner:SetWidth(100)
  spinner:AddAnchor("TOP", window, 0, 60)
  spinner:UseRotateCount()
  window.spinner = spinner
  return window
end
function SetViewOfCheckGroupWindow(id, parent, info)
  local window = CreateEmptyWindow(id, parent)
  window:Show(true)
  window.checks = {}
  window.subChecks = {}
  local offsetX = 0
  local offsetY = 4
  local height = 5
  local insetY = 21
  if info.insetY ~= nil then
    insetY = info.insetY
  end
  if info.offsetX ~= nil then
    offsetX = info.offsetX
  end
  if info.offsetY ~= nil then
    offsetY = info.offsetY
  end
  if info.menuTexts ~= nil then
    for i = 1, #info.menuTexts do
      local check = CreateCheckButton(id .. ".check" .. i, window, info.menuTexts[i])
      check.id = i
      check:AddAnchor("TOPLEFT", window, offsetX, offsetY)
      if info.iconInfo ~= nil then
        local iconInfo = info.iconInfo[i]
        local icon = check:CreateImageDrawable(iconInfo.path, "background")
        if iconInfo.coord ~= nil then
          icon:SetTextureInfo(iconInfo.coord)
        else
          icon:SetCoords(iconInfo.x, iconInfo.y, iconInfo.coordWidth, iconInfo.coordHeight)
          icon:SetExtent(iconInfo.width, iconInfo.height)
        end
        icon:AddAnchor("BOTTOMLEFT", check, "BOTTOMRIGHT", iconInfo.anchorX, iconInfo.anchorY)
        check.textButton:RemoveAllAnchors()
        check.textButton:AddAnchor("LEFT", icon, "RIGHT", 2, 1)
        check.icon = icon
      end
      offsetY = offsetY + insetY
      if info.enterCount ~= nil and i % info.enterCount == 0 then
        offsetX = offsetX + info.enterCountOffsetX
        offsetY = 4
      end
      if info.enterCount ~= nil then
        if i <= info.enterCount then
          height = height + insetY
        end
      else
        height = height + insetY
      end
      window.checks[i] = check
      if info.subMenuTexts ~= nil then
        offsetY = 4
        local subOffsetX = offsetX + 18
        if info.subOffsetX ~= nil then
          subOffsetX = info.subOffsetX
        end
        for j = 1, #info.subMenuTexts do
          local subCheck = CreateCheckButton(id .. ".subCheck" .. j, window, info.subMenuTexts[j])
          subCheck.parentCheck = check
          subCheck:AddAnchor("TOPLEFT", check, "BOTTOMLEFT", subOffsetX, offsetY)
          if info.subIconInfo ~= nil then
            local iconInfo = info.subIconInfo[j]
            local icon = subCheck:CreateImageDrawable(iconInfo.path, "background")
            if iconInfo.coord ~= nil then
              icon:SetTextureInfo(iconInfo.coord)
            else
              icon:SetCoords(iconInfo.x, iconInfo.y, iconInfo.coordWidth, iconInfo.coordHeight)
              icon:SetExtent(iconInfo.width, iconInfo.height)
            end
            icon:AddAnchor("BOTTOMLEFT", subCheck, "BOTTOMRIGHT", iconInfo.anchorX, iconInfo.anchorY)
            subCheck.textButton:RemoveAllAnchors()
            subCheck.textButton:AddAnchor("LEFT", icon, "RIGHT", 2, 1)
            subCheck.icon = icon
          end
          offsetY = offsetY + insetY
          if info.enterCount ~= nil and j % info.enterCount == 0 then
            offsetX = offsetX + 140
            offsetY = 0
          end
          if info.enterCount ~= nil then
            if j <= info.enterCount then
              height = height + insetY
            end
          else
            height = height + insetY
          end
          window.subChecks[j] = subCheck
        end
      end
    end
    window:SetHeight(height)
  end
  return window
end
