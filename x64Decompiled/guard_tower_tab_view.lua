local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
MAX_GUARD_TOWER_STEP = 6
local function CreateGuardTowerStepInfoItem(subItem)
  local stepImg = subItem:CreateDrawable(TEXTURE_PATH.TERRITORY, "step_1", "overlay")
  stepImg:SetVisible(false)
  stepImg:AddAnchor("LEFT", subItem, 0, 3)
  subItem.stepImg = stepImg
  local buffName = subItem:CreateChildWidget("label", "buffName", 0, true)
  buffName:SetHeight(FONT_SIZE.LARGE)
  buffName:AddAnchor("LEFT", subItem, 65, 0)
  ApplyTextColor(buffName, FONT_COLOR.MIDDLE_TITLE)
  buffName.style:SetFontSize(FONT_SIZE.LARGE)
  buffName.style:SetSnap(true)
  buffName.style:SetAlign(ALIGN_LEFT)
  local info = subItem:CreateChildWidget("textbox", "info", 0, true)
  info:SetHeight(FONT_SIZE.MIDDLE)
  info:AddAnchor("LEFT", buffName, "RIGHT", sideMargin / 2, 0)
  info.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(info, FONT_COLOR.DEFAULT)
  local buffIconBtn = CreateItemIconButton("buffIconBtn", subItem)
  buffIconBtn:Show(false)
  buffIconBtn:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
  buffIconBtn:AddAnchor("RIGHT", subItem, -5, 0)
  F_SLOT.ApplySlotSkin(buffIconBtn, buffIconBtn.back, SLOT_STYLE.BAG_DEFAULT)
  subItem.buffIconBtn = buffIconBtn
  local bg = subItem:CreateDrawable(TEXTURE_PATH.TAB_LIST, "enchant_info_bg", "background")
  bg:SetVisible(false)
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", subItem, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
  subItem.bg = bg
  local restWidth = subItem:GetWidth() - stepImg:GetWidth() - buffIconBtn:GetWidth() - sideMargin * 1.7
  buffName:SetWidth(restWidth * 0.55)
  info:SetWidth(restWidth * 0.45)
end
function SetViewOfGuardTowerFrame(window)
  local contentWidth = window:GetWidth()
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", window)
  listCtrl:Show(true)
  listCtrl:RemoveAllAnchors()
  listCtrl:AddAnchor("TOPLEFT", window, 0, 15)
  listCtrl:SetExtent(contentWidth, 414)
  listCtrl:SetColumnHeight(0)
  listCtrl:InsertColumn(contentWidth, LCCIT_WINDOW)
  listCtrl:InsertRows(MAX_GUARD_TOWER_STEP, false)
  for i = 1, #listCtrl.items do
    if i ~= #listCtrl.items then
      local line = DrawItemUnderLine(listCtrl.items[i])
      line:SetColor(1, 1, 1, 0.5)
      line:SetVisible(false)
      listCtrl.items[i].line = line
    end
    for j = 1, #listCtrl.column do
      local subItem = listCtrl.items[i].subItems[j]
      CreateGuardTowerStepInfoItem(subItem)
    end
  end
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, 0, 0)
  window.okButton = okButton
  local maxInfo = window:CreateChildWidget("label", "maxInfo", 0, true)
  maxInfo:SetHeight(FONT_SIZE.MIDDLE)
  maxInfo:SetAutoResize(true)
  maxInfo:AddAnchor("BOTTOM", window, 0, bottomMargin + sideMargin)
  ApplyTextColor(maxInfo, FONT_COLOR.GRAY)
end
