function SetViewOfBlockTabWindow(window)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local frame = W_CTRL.CreateScrollListCtrl("frame", window)
  frame:Show(true)
  frame:AddAnchor("TOPLEFT", window, 0, sideMargin / 2)
  frame:AddAnchor("BOTTOMRIGHT", window, 0, bottomMargin)
  frame:SetUseDoubleClick(true)
  local DataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(data[BLOCK_COL.NAME])
    end
  end
  local columnWidth = relationshipLocale.blockTab.columnWidth
  frame:InsertColumn(locale.faction.name, columnWidth.name, LCCIT_STRING, DataSetFunc, NameAscendingSortFunc, NameDescendingSortFunc, LayoutSetFunc)
  frame:InsertRows(10, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  frame.listCtrl:UseOverClickTexture()
  for i = 1, #frame.listCtrl.column do
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
    if i == #frame.listCtrl.column then
      frame.listCtrl.column[i]:Enable(false)
    end
  end
  local namePolicyInfo = X2Util:GetNamePolicyInfo(VNT_CHAR)
  local inputNameExtent = relationshipLocale.blockTab.inputName.extent
  local inputName = W_CTRL.CreateEdit("inputName", window)
  inputName:SetExtent(inputNameExtent[1], inputNameExtent[2])
  inputName:AddAnchor("BOTTOMLEFT", window, 0, 0)
  inputName:SetMaxTextLength(namePolicyInfo.max)
  inputName:CreateGuideText(locale.common.input_name_guide, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  local addBlockButton = window:CreateChildWidget("button", "addBlockButton", 0, true)
  addBlockButton:Enable(false)
  addBlockButton:SetText(locale.block.add)
  addBlockButton:AddAnchor("BOTTOMLEFT", inputName, "BOTTOMRIGHT", 3, 1)
  ApplyButtonSkin(addBlockButton, BUTTON_BASIC.DEFAULT)
end
