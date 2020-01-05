function CreatePcbangBenefit(tabWnd)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local info = X2PremiumService:GetPcbangBenefitList()
  local rowCount = math.min(#info, 15)
  local rowHeight = premiumServiceLocale.pcbangBenefitRowHeight
  local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", tabWnd)
  scrollListCtrl:SetExtent(tabWnd:GetWidth(), rowCount * rowHeight + 30)
  scrollListCtrl:AddAnchor("TOPLEFT", tabWnd, 0, sideMargin)
  local contentWidth = scrollListCtrl.listCtrl:GetWidth()
  for i = 1, #premiumServiceLocale.pcbangBenefit do
    do
      local benefit = premiumServiceLocale.pcbangBenefit[i]
      local DataSetFunc = function(subItem, data, setValue)
        if setValue then
          subItem:SetText(data)
        end
      end
      local function LayoutFunc(widget, rowIndex, colIndex, subItem)
        subItem.style:SetAlign(benefit.align)
        ApplyTextColor(subItem, benefit.color)
      end
      scrollListCtrl:InsertColumn(benefit.title, contentWidth * benefit.width, LCCIT_STRING, DataSetFunc, nil, nil, LayoutFunc)
    end
  end
  scrollListCtrl:InsertRows(rowCount, false)
  scrollListCtrl.scroll:RemoveAllAnchors()
  scrollListCtrl.scroll:AddAnchor("TOPRIGHT", scrollListCtrl, -7, 35)
  scrollListCtrl.scroll:AddAnchor("BOTTOMRIGHT", scrollListCtrl, -7, -10)
  DrawPremiumBackground(scrollListCtrl)
  for i = 1, #scrollListCtrl.listCtrl.items - 1 do
    local item = scrollListCtrl.listCtrl.items[i]
    local line = CreateLine(item, "TYPE1")
    line:AddAnchor("TOPLEFT", item, "BOTTOMLEFT", -sideMargin / 2, -2)
    line:AddAnchor("TOPRIGHT", item, "BOTTOMRIGHT", sideMargin, -2)
  end
  for i = 1, #info do
    local data = info[i]
    local colCount = math.min(#data, #premiumServiceLocale.pcbangBenefit)
    for j = 1, colCount do
      scrollListCtrl:InsertData(i, j, data[j], false)
    end
  end
  if premiumServiceLocale.showPcbangBenefitLabel then
    local label = tabWnd:CreateChildWidget("textbox", "label", 0, true)
    label:SetExtent(contentWidth, FONT_SIZE.MIDDLE)
    label:SetText(GetUIText(COMMON_TEXT, "checkable_pcbang_coin_item"))
    label:SetHeight(label:GetTextHeight())
    label:AddAnchor("TOPLEFT", scrollListCtrl, "BOTTOMLEFT", 0, sideMargin / 2)
    label:SetInset(sideMargin / 2, 0, 0, 0)
    label.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(label, FONT_COLOR.BLUE)
  end
  function tabWnd:GetContentHeight()
    return scrollListCtrl:GetHeight() + (label and label:GetHeight() + sideMargin / 2 or 0)
  end
end
