function SetViewOfDyeingWindow(id, parent)
  local window = CreateWindow(id, parent, "preview_dyeing")
  window:SetSounds("dyeing")
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "dyeing"))
  window:SetExtent(430, 300)
  window:AddAnchor("LEFT", 30, 0)
  CreateWindowDefaultTextButtonSet(window)
  local commonWidth = 380
  local content = window:CreateChildWidget("textbox", "content", 0, true)
  content:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
  content:SetAutoResize(true)
  content:AddAnchor("TOP", window.titleBar, "BOTTOM", 0, 0)
  ApplyTextColor(content, FONT_COLOR.DEFAULT)
  local function CreateSection(id, titleStr)
    local frame = window:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetWidth(commonWidth)
    local bg = CreateContentBackground(frame, "TYPE2", "brown_3", "artwork")
    bg:AddAnchor("TOPLEFT", frame, -5, 0)
    bg:AddAnchor("BOTTOMRIGHT", frame, 5, 0)
    local width = frame:GetWidth() - 20
    local title = frame:CreateChildWidget("label", "title", 0, true)
    title:SetExtent(width, FONT_SIZE.LARGE)
    title:AddAnchor("TOP", frame, 0, 12)
    title:SetText(titleStr)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    local line = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "slim_line_01", "background")
    line:SetExtent(width, 1)
    line:AddAnchor("TOP", title, "BOTTOM", 0, 6)
    frame.line = line
    return frame
  end
  local itemSection = CreateSection("itemSection", GetUIText(COMMON_TEXT, "dyeing_target_item"))
  itemSection:SetHeight(120)
  itemSection:AddAnchor("TOP", content, "BOTTOM", 0, 9)
  local inset = 7
  local itemIcon = CreateItemIconButton("itemIcon", itemSection)
  itemIcon:AddAnchor("TOP", itemSection.line, "BOTTOM", 0, inset)
  itemSection.itemIcon = itemIcon
  local itemName = itemSection:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetExtent(itemSection.title:GetWidth(), FONT_SIZE.LARGE)
  itemName:SetAutoResize(true)
  itemName.style:SetAlign(ALIGN_CENTER)
  itemName:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 6)
  local palletteSection = CreateSection("palletteSection", GetUIText(COMMON_TEXT, "pallette"))
  palletteSection:SetHeight(185)
  palletteSection:AddAnchor("TOP", itemSection, "BOTTOM", 0, 5)
  local pallette = W_PALLECT.CreatePallette("pallette", palletteSection, "default")
  pallette:AddAnchor("TOP", palletteSection.line, "BOTTOM", 0, inset + 2)
  palletteSection.pallette = pallette
  local resetBtn = palletteSection:CreateChildWidget("button", "resetBtn", 0, true)
  resetBtn:AddAnchor("TOPRIGHT", palletteSection, 0, 5)
  ApplyButtonSkin(resetBtn, BUTTON_BASIC.RESET)
  local modelWindow = CreateDyeingModelWindow("modelWindow", window)
  modelWindow:Show(false)
  window.modelWindow = modelWindow
  function window:AdjustHeight()
    local _, totalHeight = F_LAYOUT.GetExtentWidgets(window.titleBar, window.palletteSection)
    window:SetExtent(430, totalHeight + MARGIN.WINDOW_SIDE * 1.5 + window.leftButton:GetHeight())
  end
  return window
end
