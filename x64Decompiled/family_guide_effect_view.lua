function SetViewOfFamilyGuideEffect(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(430, 360)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(GetCommonText("family_level_effect"))
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(GetCommonText("ok"))
  okButton:AddAnchor("BOTTOM", window, "BOTTOM", 0, -MARGIN.WINDOW_SIDE)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local levelList = window:CreateChildWidget("emptywidget", "levelList", 0, true)
  W_CTRL.CreateListCtrl("listCtrl", levelList)
  levelList:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  levelList:AddAnchor("BOTTOMRIGHT", window, "BOTTOMRIGHT", -sideMargin, -(okButton:GetHeight() + MARGIN.WINDOW_SIDE + 33))
  local LayoutFunc = function(widget, rowIndex, colIndex, subItem)
    local icon = subItem:CreateDrawable(TEXTURE_PATH.FAMILY_LEVEL, "level_01", "background")
    icon:AddAnchor("LEFT", subItem, 15, 0)
    subItem.icon = icon
    subItem.style:SetEllipsis(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(100, 0, 0, 0)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local buffIconBtn = CreateItemIconButton("buffIconBtn", subItem)
    buffIconBtn:Show(false)
    buffIconBtn:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    buffIconBtn:AddAnchor("RIGHT", subItem, "RIGHT", -38, 0)
    F_SLOT.ApplySlotSkin(buffIconBtn, buffIconBtn.back, SLOT_STYLE.BAG_DEFAULT)
    subItem.buffIconBtn = buffIconBtn
  end
  local SetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.icon:SetTextureInfo(string.format("level_0%d", data.level))
      subItem.icon:Show(true)
      subItem:SetText(data.levelName)
      subItem:Show(true)
      subItem.buffIconBtn:Show(false)
      if data.path ~= nil then
        subItem.buffIconBtn:Show(true)
        subItem.buffIconBtn:SetTooltip(data)
        F_SLOT.SetIconBackGround(subItem.buffIconBtn, data.path)
      end
    else
      subItem.icon:Show(false)
      subItem:Show(false)
      subItem.buffIconBtn:Show(false)
    end
  end
  levelList:InsertColumn("", levelList:GetWidth(), LCCIT_STRING, LayoutFunc, SetFunc)
  levelList:HideColumnButtons()
  levelList:InsertRows(3, false)
  return window
end
