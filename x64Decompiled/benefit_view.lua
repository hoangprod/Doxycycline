function CreateBenefitList(wnd, anchorTarget)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local BENEFIT_LISTCTRL_OFFSET_X = premiumServiceLocale.premiumWndWidth - 20 - sideMargin * 2
  local BENEFIT_LISTCTRL_GRADE_X = 60
  local ADD_BG_EXTENT_WIDTH = 30
  local okBtn = wnd:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:SetText(GetCommonText("ok"))
  okBtn:AddAnchor("BOTTOM", wnd, 0, 0)
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  local listCtrl = W_CTRL.CreateScrollListCtrl("benefitListCtrl", wnd)
  listCtrl.scroll:RemoveAllAnchors()
  listCtrl.scroll:AddAnchor("TOPRIGHT", listCtrl, -7, 35)
  listCtrl.scroll:AddAnchor("BOTTOMRIGHT", listCtrl, -7, -7)
  local tab = wnd:GetParent()
  tab:AnchorContent(listCtrl, anchorTarget)
  local SetLayoutForEachField = function(frame, rowIndex, colIndex, subItem)
    subItem:SetHeight(FONT_SIZE.MIDDLE)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local SetMenuName = function(subItem, data)
    subItem:SetText(tostring(data.menuName) or "")
  end
  local SetModifierValue = function(subItem, data)
    subItem:SetText(tostring(data.modifierValue or "0"))
  end
  function wnd:GetContentHeight()
    return listCtrl:GetHeight() + okBtn:GetHeight() + sideMargin
  end
  local maxRow = 8
  local benefitMenuCount = X2PremiumService:GetPremiumServiceBenefitMenuCount()
  if maxRow > benefitMenuCount then
    maxRow = benefitMenuCount
  end
  if maxRow == 0 then
    listCtrl:Show(false)
    return
  end
  local maxGrade = X2PremiumService:GetPremiumMaxGrade()
  if maxGrade == 1 then
    listCtrl:InsertColumn(locale.premium.benefit, BENEFIT_LISTCTRL_OFFSET_X - BENEFIT_LISTCTRL_GRADE_X * 3 - 20, LCCIT_STRING, SetMenuName, nil, nil, SetLayoutForEachField)
    listCtrl:InsertColumn(locale.premium.premium_apply_effect, BENEFIT_LISTCTRL_GRADE_X * 3, LCCIT_STRING, SetModifierValue, nil, nil, SetLayoutForEachField)
  else
    listCtrl:InsertColumn(locale.premium.benefit, BENEFIT_LISTCTRL_OFFSET_X - BENEFIT_LISTCTRL_GRADE_X * maxGrade - 20, LCCIT_STRING, SetMenuName, nil, nil, SetLayoutForEachField)
    for i = 2, maxGrade + 1 do
      listCtrl:InsertColumn(locale.premium.grade(tostring(i - 1)), BENEFIT_LISTCTRL_GRADE_X, LCCIT_STRING, SetModifierValue, nil, nil, SetLayoutForEachField)
    end
  end
  listCtrl:InsertRows(maxRow, false)
  listCtrl:SetHeight(32 * maxRow)
  DrawPremiumBackground(listCtrl)
  for i = 1, listCtrl:GetRowCount() - 1 do
    local line = CreateLine(listCtrl.listCtrl.items[i], "TYPE1", "overlay")
    line:AddAnchor("TOPLEFT", listCtrl.listCtrl.items[i], "BOTTOMLEFT", 0, -2)
    line:AddAnchor("TOPRIGHT", listCtrl.listCtrl.items[i], "BOTTOMRIGHT", 0, 0)
  end
  for i = 1, benefitMenuCount do
    local menuName = X2PremiumService:GetPremiumServiceBenefitMenuName(i)
    local modifierValue = X2PremiumService:GetPremiumServiceBenefitMenuData(i)
    for j = 1, maxGrade + 1 do
      if j == 1 then
        local menuColumnData = {}
        menuColumnData.menuName = menuName
        listCtrl:InsertData(i, j, menuColumnData, false)
      else
        local modifierColumnData = {}
        modifierColumnData.modifierValue = modifierValue["benefitValueName" .. tostring(j - 1)]
        listCtrl:InsertData(i, j, modifierColumnData, false)
      end
    end
  end
end
