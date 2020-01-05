local SetViewOfUccRegisterWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent, "housing_ucc")
  window.parent = parent
  window:EnableHidingIsRemove(true)
  window:SetExtent(POPUP_WINDOW_WIDTH, 490)
  window:AddAnchor("LEFT", "UIParent", sideMargin, 0)
  window:SetTitle(GetUIText(HOUSING_TEXT, "housing_ucc"))
  local label_description1 = window:CreateChildWidget("textbox", "label_description1", 0, true)
  label_description1:SetExtent(260, FONT_SIZE.MIDDLE)
  label_description1.style:SetAlign(ALIGN_CENTER)
  label_description1:AddAnchor("TOP", 0, 50)
  label_description1:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_description1"))
  ApplyTextColor(label_description1, FONT_COLOR.DEFAULT)
  local housingUccTab = {}
  housingUccTab[HOUSING_UCC_TAB.APPLY_UCC] = GetUIText(HOUSING_TEXT, "housing_ucc_apply")
  housingUccTab[HOUSING_UCC_TAB.REVERT_UCC] = GetUIText(HOUSING_TEXT, "housing_ucc_remove")
  local tab = W_BTN.CreateTab("tab", window)
  tab:AddTabs(housingUccTab)
  tab:RemoveAllAnchors()
  tab:AddAnchor("TOP", label_description1, 0, label_description1:GetHeight() + 15)
  window.uccApplyWindow = CreateHousingUccApplyWindow(tab.window[HOUSING_UCC_TAB.APPLY_UCC])
  window.uccRevertWindow = CreateHousingUccRemoveWindow(tab.window[HOUSING_UCC_TAB.REVERT_UCC])
  function window:UpdateTab()
    local enable = window.uccRevertWindow:CanRemove()
    tab:EnableTab(HOUSING_UCC_TAB.REVERT_UCC, enable)
    if not enable then
      tab:SelectTab(HOUSING_UCC_TAB.APPLY_UCC)
    end
  end
  window:UpdateTab()
  local wndHeight = window:GetHeight()
  local tabHeight = tab:GetHeight()
  local diff = window.uccApplyWindow.labelPreview:GetHeight() - FONT_SIZE.MIDDLE
  window:SetHeight(wndHeight + diff)
  tab:SetHeight(tabHeight + diff)
  return window
end
local SetViewOfUccApplyWindow = function(window)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local selectPosWidget = window:CreateChildWidget("emptywidget", "selectPosWidget", 0, true)
  selectPosWidget:AddAnchor("TOP", window, 0, 10)
  selectPosWidget:SetExtent(window:GetWidth(), 75)
  local bgSelectPosWidget = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectPosWidget:SetTextureColor("bg_02")
  bgSelectPosWidget:AddAnchor("TOPLEFT", selectPosWidget, 0, 0)
  bgSelectPosWidget:AddAnchor("BOTTOMRIGHT", selectPosWidget, 0, 0)
  local selectPosTitleWidget = window:CreateChildWidget("emptywidget", "selectPosTitleWidget", 0, true)
  selectPosTitleWidget:AddAnchor("TOP", selectPosWidget, 0, 0)
  selectPosTitleWidget:SetExtent(selectPosWidget:GetWidth(), 25)
  local bgSelectPosTitle = selectPosTitleWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectPosTitle:SetTextureColor("bg_02")
  bgSelectPosTitle:AddAnchor("TOPLEFT", selectPosTitleWidget, 0, 0)
  bgSelectPosTitle:AddAnchor("BOTTOMRIGHT", selectPosTitleWidget, 0, 0)
  local labelSelectPosTitle = window:CreateChildWidget("label", "labelSelectPosTitle", 0, true)
  labelSelectPosTitle:SetExtent(245, FONT_SIZE.MIDDLE)
  labelSelectPosTitle:SetAutoResize(false)
  labelSelectPosTitle:AddAnchor("TOP", selectPosTitleWidget, 0, 5)
  labelSelectPosTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(labelSelectPosTitle, F_COLOR.GetColor("title"))
  labelSelectPosTitle:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_select_apply"))
  local comboBox = W_CTRL.CreateComboBox("comboBox", window)
  comboBox:SetWidth(260)
  comboBox:AddAnchor("BOTTOM", selectPosWidget, 0, -14)
  local datas = {}
  local infos = X2House:GetHousingUccInfo()
  for i = 1, #infos do
    local info = infos[i]
    local pos = info.position
    local data = {
      text = HOUSING_UCC_POSITION[pos].text,
      value = pos
    }
    table.insert(datas, data)
  end
  comboBox:AppendItems(datas)
  local selectItemWidget = window:CreateChildWidget("emptywidget", "selectItemWidget", 0, true)
  selectItemWidget:AddAnchor("TOP", selectPosWidget, 0, selectPosWidget:GetHeight() + 10)
  selectItemWidget:SetExtent(window:GetWidth(), 130)
  local bgSelectItemWidget = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectItemWidget:SetTextureColor("bg_02")
  bgSelectItemWidget:AddAnchor("TOPLEFT", selectItemWidget, 0, 0)
  bgSelectItemWidget:AddAnchor("BOTTOMRIGHT", selectItemWidget, 0, 0)
  local selectItemTitleWidget = window:CreateChildWidget("emptywidget", "selectItemTitleWidget", 0, true)
  selectItemTitleWidget:AddAnchor("TOP", selectItemWidget, 0, 0)
  selectItemTitleWidget:SetExtent(selectItemWidget:GetWidth(), 25)
  local bgSelectItemTitle = selectItemTitleWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectItemTitle:SetTextureColor("bg_02")
  bgSelectItemTitle:AddAnchor("TOPLEFT", selectItemTitleWidget, 0, 0)
  bgSelectItemTitle:AddAnchor("BOTTOMRIGHT", selectItemTitleWidget, 0, 0)
  local labelSelectItemTitle = window:CreateChildWidget("label", "labelSelectItemTitle", 0, true)
  labelSelectItemTitle:SetExtent(245, FONT_SIZE.MIDDLE)
  labelSelectItemTitle:SetAutoResize(false)
  labelSelectItemTitle:AddAnchor("TOP", selectItemTitleWidget, 0, 5)
  labelSelectItemTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(labelSelectItemTitle, F_COLOR.GetColor("title"))
  labelSelectItemTitle:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_use_item"))
  local itemSlot = CreateItemIconButton("itemSlot", window)
  itemSlot:SetExtent(ICON_SIZE.DEFAULT + 7, ICON_SIZE.DEFAULT + 7)
  itemSlot:RegisterForClicks("RightButton")
  itemSlot:AddAnchor("TOP", labelSelectItemTitle, "BOTTOM", 0, 20)
  local ItemButtonLeftClickFunc = function()
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2House:SetUccItemSlotFromPick()
    end
  end
  local ItemButtonRightClickFunc = function()
    X2House:ClearUccItemSlot()
  end
  ButtonOnClickHandler(itemSlot, ItemButtonLeftClickFunc, ItemButtonRightClickFunc)
  function itemSlot:procOnEnter()
    local info = self:GetInfo()
    if info == nil then
      ShowTextTooltip(self, nil, GetUIText(HOUSING_TEXT, "housing_ucc_emtpy_apply_slot_tooltip"), nil)
      return
    else
      self:SetTooltip(self.info)
    end
  end
  local itemName = window:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetExtent(225, FONT_SIZE.MIDDLE)
  itemName.style:SetAlign(ALIGN_CENTER)
  itemName:AddAnchor("TOP", itemSlot, "BOTTOM", 0, 15)
  window.isEquiped = false
  local previewWidget = window:CreateChildWidget("emptywidget", "previewWidget", 0, true)
  previewWidget:AddAnchor("TOP", selectItemWidget, 0, selectItemWidget:GetHeight() + 10)
  previewWidget:SetExtent(window:GetWidth(), 46)
  local bgpreviewWidget = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgpreviewWidget:SetTextureColor("bg_02")
  bgpreviewWidget:AddAnchor("TOPLEFT", previewWidget, 0, 0)
  bgpreviewWidget:AddAnchor("BOTTOMRIGHT", previewWidget, 0, 0)
  local previewBtn = window:CreateChildWidget("button", "previewBtn", 0, true)
  ApplyButtonSkin(previewBtn, BUTTON_CONTENTS.HOUSING_PREVIEW_MINI)
  previewBtn:AddAnchor("CENTER", previewWidget, 0, 0)
  previewBtn:SetInset(80, 0, 46, 0)
  previewBtn.style:SetAlign(ALIGN_RIGHT)
  previewBtn:SetAutoResize(true)
  previewBtn:Enable(false)
  previewBtn:SetText(GetUIText(STORE_TEXT, "preview"))
  window.previewBtn = previewBtn
  local labelPreview = window:CreateChildWidget("textbox", "labelPreview", 0, true)
  labelPreview:SetExtent(window:GetWidth(), FONT_SIZE.MIDDLE)
  labelPreview:SetAutoResize(true)
  labelPreview:AddAnchor("TOP", previewWidget, 0, previewWidget:GetHeight() + 15)
  labelPreview.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(labelPreview, FONT_COLOR.GRAY)
  labelPreview:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_description2"))
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_apply"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, -(okButton:GetWidth() / 2 + 2), -sideMargin - 5)
  okButton:Enable(false)
  window.okButton = okButton
  local cancelButton = window:CreateChildWidget("button", "cancelButton", 0, false)
  cancelButton:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOM", window, cancelButton:GetWidth() / 2 + 2, -sideMargin - 5)
  window.cancelButton = cancelButton
  return window
end
local SetViewOfUccRemoveWindow = function(window)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local selectPosWidget = window:CreateChildWidget("emptywidget", "selectPosWidget", 0, true)
  selectPosWidget:AddAnchor("TOP", window, 0, 10)
  selectPosWidget:SetExtent(window:GetWidth(), 75)
  local bgSelectPosWidget = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectPosWidget:SetTextureColor("bg_02")
  bgSelectPosWidget:AddAnchor("TOPLEFT", selectPosWidget, 0, 0)
  bgSelectPosWidget:AddAnchor("BOTTOMRIGHT", selectPosWidget, 0, 0)
  local selectPosTitleWidget = window:CreateChildWidget("emptywidget", "selectPosTitleWidget", 0, true)
  selectPosTitleWidget:AddAnchor("TOP", selectPosWidget, 0, 0)
  selectPosTitleWidget:SetExtent(selectPosWidget:GetWidth(), 25)
  local bgSelectPosTitle = selectPosTitleWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectPosTitle:SetTextureColor("bg_02")
  bgSelectPosTitle:AddAnchor("TOPLEFT", selectPosTitleWidget, 0, 0)
  bgSelectPosTitle:AddAnchor("BOTTOMRIGHT", selectPosTitleWidget, 0, 0)
  local labelSelectPosTitle = window:CreateChildWidget("label", "labelSelectPosTitle", 0, true)
  labelSelectPosTitle:SetExtent(245, FONT_SIZE.MIDDLE)
  labelSelectPosTitle:SetAutoResize(false)
  labelSelectPosTitle:AddAnchor("TOP", selectPosTitleWidget, 0, 5)
  labelSelectPosTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(labelSelectPosTitle, F_COLOR.GetColor("title"))
  labelSelectPosTitle:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_select_remove"))
  local comboBox = W_CTRL.CreateComboBox("comboBox", window)
  comboBox:SetWidth(260)
  comboBox:AddAnchor("BOTTOM", selectPosWidget, 0, -14)
  function window:SetComboboxData()
    local datas = {}
    local selectableIndex = 0
    local infos = X2House:GetHousingUccInfo()
    for i = 1, #infos do
      local info = infos[i]
      local pos = info.position
      local data = {
        text = HOUSING_UCC_POSITION[pos].text,
        value = pos,
        enable = info.canRemove == 1 and true or false
      }
      if selectableIndex == 0 and info.canRemove == 1 then
        selectableIndex = i
      end
      table.insert(datas, data)
    end
    comboBox:AppendItems(datas, false)
    if comboBox:IsEnabled() then
      comboBox:Select(selectableIndex)
    end
  end
  window:SetComboboxData()
  function window:CanRemove()
    return comboBox:IsEnabled()
  end
  local selectItemWidget = window:CreateChildWidget("emptywidget", "selectItemWidget", 0, true)
  selectItemWidget:AddAnchor("TOP", selectPosWidget, 0, selectPosWidget:GetHeight() + 10)
  selectItemWidget:SetExtent(window:GetWidth(), 130)
  local bgSelectItemWidget = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectItemWidget:SetTextureColor("bg_02")
  bgSelectItemWidget:AddAnchor("TOPLEFT", selectItemWidget, 0, 0)
  bgSelectItemWidget:AddAnchor("BOTTOMRIGHT", selectItemWidget, 0, 0)
  local selectItemTitleWidget = window:CreateChildWidget("emptywidget", "selectItemTitleWidget", 0, true)
  selectItemTitleWidget:AddAnchor("TOP", selectItemWidget, 0, 0)
  selectItemTitleWidget:SetExtent(selectItemWidget:GetWidth(), 25)
  local bgSelectItemTitle = selectItemTitleWidget:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgSelectItemTitle:SetTextureColor("bg_02")
  bgSelectItemTitle:AddAnchor("TOPLEFT", selectItemTitleWidget, 0, 0)
  bgSelectItemTitle:AddAnchor("BOTTOMRIGHT", selectItemTitleWidget, 0, 0)
  local labelSelectItemTitle = window:CreateChildWidget("label", "labelSelectItemTitle", 0, true)
  labelSelectItemTitle:SetExtent(245, FONT_SIZE.MIDDLE)
  labelSelectItemTitle:SetAutoResize(false)
  labelSelectItemTitle:AddAnchor("TOP", selectItemTitleWidget, 0, 5)
  labelSelectItemTitle.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(labelSelectItemTitle, F_COLOR.GetColor("title"))
  labelSelectItemTitle:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_use_item"))
  local itemSlot = CreateItemIconButton("itemSlot", window)
  itemSlot:SetExtent(ICON_SIZE.DEFAULT + 7, ICON_SIZE.DEFAULT + 7)
  itemSlot:RegisterForClicks("RightButton")
  itemSlot:AddAnchor("TOP", labelSelectItemTitle, "BOTTOM", 0, 20)
  local ItemButtonLeftClickFunc = function()
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2House:SetUccItemSlotFromPick()
    end
  end
  local ItemButtonRightClickFunc = function()
    X2House:ClearUccItemSlot()
  end
  ButtonOnClickHandler(itemSlot, ItemButtonLeftClickFunc, ItemButtonRightClickFunc)
  function itemSlot:procOnEnter()
    local info = self:GetInfo()
    if info == nil then
      ShowTextTooltip(self, nil, GetUIText(HOUSING_TEXT, "housing_ucc_emtpy_remove_slot_tooltip"), nil)
      return
    else
      self:SetTooltip(self.info)
    end
  end
  local itemName = window:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetExtent(225, FONT_SIZE.MIDDLE)
  itemName.style:SetAlign(ALIGN_CENTER)
  itemName:AddAnchor("TOP", itemSlot, "BOTTOM", 0, 15)
  window.isEquiped = false
  local previewWidget = window:CreateChildWidget("emptywidget", "previewWidget", 0, true)
  previewWidget:AddAnchor("TOP", selectItemWidget, 0, selectItemWidget:GetHeight() + 10)
  previewWidget:SetExtent(window:GetWidth(), 46)
  local bgpreviewWidget = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bgpreviewWidget:SetTextureColor("bg_02")
  bgpreviewWidget:AddAnchor("TOPLEFT", previewWidget, 0, 0)
  bgpreviewWidget:AddAnchor("BOTTOMRIGHT", previewWidget, 0, 0)
  local previewBtn = window:CreateChildWidget("button", "previewBtn", 0, true)
  ApplyButtonSkin(previewBtn, BUTTON_CONTENTS.HOUSING_PREVIEW_MINI)
  previewBtn:AddAnchor("CENTER", previewWidget, 0, 0)
  previewBtn:SetInset(80, 0, 46, 0)
  previewBtn.style:SetAlign(ALIGN_RIGHT)
  previewBtn:SetAutoResize(true)
  previewBtn:Enable(false)
  previewBtn:SetText(GetUIText(STORE_TEXT, "preview"))
  window.previewBtn = previewBtn
  local labelPreview = window:CreateChildWidget("textbox", "labelPreview", 0, true)
  labelPreview:SetExtent(window:GetWidth(), FONT_SIZE.MIDDLE)
  labelPreview:SetAutoResize(true)
  labelPreview:AddAnchor("TOP", previewWidget, 0, previewWidget:GetHeight() + 15)
  labelPreview.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(labelPreview, FONT_COLOR.GRAY)
  labelPreview:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_description2"))
  local okButton = window:CreateChildWidget("button", "okButton", 0, false)
  okButton:SetText(GetUIText(HOUSING_TEXT, "housing_ucc_remove"))
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  okButton:AddAnchor("BOTTOM", window, -(okButton:GetWidth() / 2 + 2), -sideMargin - 5)
  okButton:Enable(false)
  window.okButton = okButton
  local cancelButton = window:CreateChildWidget("button", "cancelButton", 0, false)
  cancelButton:SetText(GetUIText(COMMON_TEXT, "cancel"))
  ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
  cancelButton:AddAnchor("BOTTOM", window, cancelButton:GetWidth() / 2 + 2, -sideMargin - 5)
  window.cancelButton = cancelButton
  return window
end
function CreateUccRegisterWindow(id, parent)
  local window = SetViewOfUccRegisterWindow(id, parent)
  function window:ShowProc()
    ShowHousingMainTainWindow(false)
    SetHousingUccEventFunction(self)
    X2House:EnterUccApply()
    ADDON:ShowContent(UIC_BAG, true)
  end
  function window:HideProc()
    X2House:LeaveUccItem()
  end
  return window
end
function CreateHousingUccApplyWindow(parent)
  local window = SetViewOfUccApplyWindow(parent)
  function window:OnShow()
    X2House:EnterUccApply()
    window.comboBox:Select(1)
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:OnHide()
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
function CreateHousingUccRemoveWindow(parent)
  local window = SetViewOfUccRemoveWindow(parent)
  function window:OnShow()
    X2House:EnterUccRemove()
    window:SetComboboxData()
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:OnHide()
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
