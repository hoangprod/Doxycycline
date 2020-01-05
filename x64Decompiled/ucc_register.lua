function SetHousingUccEventFunction(window)
  local Events = {
    HOUSING_UCC_LEAVE = function()
      if not X2House:IsMyHouse() then
        return
      end
      window:ClearSlot()
    end,
    HOUSING_UCC_ITEM_SLOT_SET = function()
      if not X2House:IsMyHouse() then
        return
      end
      window:SetSlot()
    end,
    HOUSING_UCC_ITEM_SLOT_CLEAR = function()
      if not X2House:IsMyHouse() then
        return
      end
      window:ClearSlot()
    end,
    HOUSING_UCC_UPDATED = function()
      if not X2House:IsMyHouse() then
        return
      end
      local infos = X2House:GetHousingUccInfo()
      local revertWnd = window.uccRevertWindow
      revertWnd:SetComboboxData()
      window:UpdateTab()
    end,
    HOUSING_UCC_CLOSE = function()
      window:Show(false)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    Events[event](...)
  end)
  RegistUIEvent(window, Events)
  local function GetCurrentWindow()
    if window.uccApplyWindow:IsVisible() then
      return window.uccApplyWindow
    elseif window.uccRevertWindow:IsVisible() then
      return window.uccRevertWindow
    else
      return nil
    end
  end
  function window:SetSlot()
    local wnd = GetCurrentWindow()
    if wnd == nil then
      return
    end
    local itemInfo = X2House:GetHousingUccItemInfo()
    if itemInfo ~= nil then
      local color = Hex2Dec(itemInfo.gradeColor)
      wnd.itemName.style:SetColor(color[1], color[2], color[3], color[4])
      wnd.itemName:SetText(itemInfo.name)
      wnd.itemSlot:SetItemInfo(itemInfo)
      wnd.okButton:Enable(true)
      wnd.previewBtn:Enable(true)
      wnd.isEquiped = true
    else
      wnd.itemSlot:Init()
      wnd.itemName:SetText("")
      wnd.isEquiped = false
      wnd.okButton:Enable(false)
      wnd.previewBtn:Enable(false)
    end
  end
  function window:ClearSlot()
    local wnd = GetCurrentWindow()
    if wnd == nil then
      return
    end
    wnd.itemSlot:Init()
    wnd.itemName:SetText("")
    wnd.isEquiped = false
    wnd.okButton:Enable(false)
    wnd.previewBtn:Enable(false)
  end
  local function Preview()
    local wnd = GetCurrentWindow()
    if wnd == nil then
      return
    end
    local info = window.uccApplyWindow.comboBox:GetSelectedInfo()
    if info == nil then
      return
    end
    if wnd.isEquiped == false then
      return
    end
    X2House:Preview(info.value, false)
  end
  window.uccApplyWindow.previewBtn:SetHandler("OnClick", Preview)
  local function Preview()
    local wnd = GetCurrentWindow()
    if wnd == nil then
      return
    end
    local info = window.uccRevertWindow.comboBox:GetSelectedInfo()
    if info == nil then
      return
    end
    if wnd.isEquiped == false then
      return
    end
    X2House:Preview(info.value, true)
  end
  window.uccRevertWindow.previewBtn:SetHandler("OnClick", Preview)
  local function OkButtonLeftClickFunc()
    local function OpenInitDialog(pos)
      local info = GetCurrentWindow().comboBox:GetSelectedInfo()
      if info == nil then
        return
      end
      local function DialogHandler(wnd)
        wnd:SetTitle(GetUIText(HOUSING_TEXT, "housing_ucc"))
        wnd:UpdateDialogModule("textbox", GetUIText(HOUSING_TEXT, "housing_ucc_apply_description"))
        local item = X2House:GetHousingUccItemInfo()
        local itemData = {
          itemInfo = X2Item:GetItemInfoByType(item.itemType),
          stack = 1
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        local textData = {
          type = "warning",
          text = GetUIText(HOUSING_TEXT, "housing_ucc_use_item_description")
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
        function wnd:OkProc()
          X2House:UseApplyUccItem(info.value, false)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, GetCurrentWindow():GetId())
    end
    local wnd = GetCurrentWindow()
    if wnd == nil then
      return
    end
    OpenInitDialog(wnd.comboBox:GetSelectedIndex())
  end
  window.uccApplyWindow.okButton:SetHandler("OnClick", OkButtonLeftClickFunc)
  local function OkButtonLeftClickFunc()
    local function OpenInitDialog(pos)
      local function DialogHandler(wnd)
        wnd:SetTitle(GetUIText(HOUSING_TEXT, "housing_ucc"))
        wnd:UpdateDialogModule("textbox", GetUIText(HOUSING_TEXT, "housing_ucc_remove_description"))
        local item = X2House:GetHousingUccItemInfo()
        local itemData = {
          itemInfo = X2Item:GetItemInfoByType(item.itemType),
          stack = 1
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        local textData = {
          type = "warning",
          text = GetUIText(HOUSING_TEXT, "housing_ucc_use_item_description")
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
        function wnd:OkProc()
          X2House:UseApplyUccItem(pos, true)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, GetCurrentWindow():GetId())
    end
    local wnd = GetCurrentWindow()
    if wnd == nil then
      return
    end
    OpenInitDialog(wnd.comboBox:GetSelectedIndex())
  end
  window.uccRevertWindow.okButton:SetHandler("OnClick", OkButtonLeftClickFunc)
  local function CancelButtonLeftClickFunc()
    window:Show(false)
  end
  window.uccApplyWindow.cancelButton:SetHandler("OnClick", CancelButtonLeftClickFunc)
  local function CancelButtonLeftClickFunc()
    window:Show(false)
  end
  window.uccRevertWindow.cancelButton:SetHandler("OnClick", CancelButtonLeftClickFunc)
end
