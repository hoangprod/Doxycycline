function CreateMailListCtrl(id, parent, columnText, sideMargin)
  local listCtrl = W_CTRL.CreateListCtrl("listCtrl", parent)
  listCtrl:Show(true)
  listCtrl:AddAnchor("TOPLEFT", parent, 0, 5)
  listCtrl:AddAnchor("BOTTOMRIGHT", parent, 0, -75)
  listCtrl:SetUseDoubleClick(true)
  listCtrl:InsertColumn(240, LCCIT_STRING)
  listCtrl.column[1]:SetText(locale.mail.title)
  listCtrl:InsertColumn(listCtrl:GetWidth() - listCtrl.column[1]:GetWidth(), LCCIT_STRING)
  listCtrl.column[2]:SetText(columnText)
  listCtrl:InsertRows(PAGE_PER_MAIL_MAX_COUNT, false)
  DrawListCtrlUnderLine(listCtrl)
  listCtrl:UseOverClickTexture()
  listCtrl.mailIDs = {}
  listCtrl.hasItem = {}
  listCtrl.canTakeItemsAtOnce = {}
  listCtrl.checkValue = {}
  local allSelectCheck = CreateCheckButton(listCtrl:GetId() .. ".allSelectCheck", listCtrl)
  allSelectCheck:AddAnchor("LEFT", listCtrl.column[1], 0, 1)
  listCtrl.allSelectCheck = allSelectCheck
  function allSelectCheck:SetCheckedAll(check)
    for i = 1, #listCtrl.checkValue do
      local selectCheck = listCtrl.items[i].subItems[1].checkbox
      if selectCheck:IsEnabled() then
        listCtrl.checkValue[i] = check
      else
        listCtrl.checkValue[i] = false
      end
    end
    for i = 1, PAGE_PER_MAIL_MAX_COUNT do
      local selectCheck = listCtrl.items[i].subItems[1].checkbox
      if selectCheck:IsVisible() and selectCheck:IsEnabled() then
        selectCheck:SetChecked(check, false)
      end
    end
  end
  function allSelectCheck:CheckBtnCheckChagnedProc()
    self:SetCheckedAll(self:GetChecked())
    listCtrl:CheckProc_takeAllAttachmentsButton()
    listCtrl:CheckProc_deleteButton()
  end
  local CreateAttachItemIconWidget = function(widget)
    local icon = widget:CreateChildWidget("emptywidget", "icon", 0, true)
    icon:SetExtent(13, 16)
    icon:Raise()
    local iconTexture = icon:CreateDrawable(TEXTURE_PATH.MONEY_WINDOW, "pouch", "background")
    iconTexture:AddAnchor("TOPLEFT", icon, 0, 0)
    iconTexture:AddAnchor("BOTTOMRIGHT", icon, 0, 0)
    local OnEnter = function(self)
      SetTooltip(locale.mail.haveAttachItem, self)
    end
    icon:SetHandler("OnEnter", OnEnter)
    return icon
  end
  local function DefaultMailTitleLayoutFunc(frame, rowIndex, colIndex, subItem)
    local checkbox = CreateCheckButton(subItem:GetId() .. ".checkbox", subItem)
    checkbox:AddAnchor("LEFT", subItem, 0, 1)
    subItem.checkbox = checkbox
    function checkbox:CheckBtnCheckChagnedProc(checked)
      frame:UpdateData(rowIndex, colIndex, "chk", checked)
      if not checked then
        frame.allSelectCheck:SetChecked(false, false)
      else
        frame.allSelectCheck:SetChecked(frame:IsAllChecked(), false)
      end
      if frame.CheckProc_DeleteButton ~= nil then
        frame:CheckProc_DeleteButton()
      end
    end
    local icon = CreateAttachItemIconWidget(subItem)
    icon:Show(false)
    icon:AddAnchor("LEFT", checkbox, "RIGHT", 0, 0)
    local mailTypeIcon = CreateMailTypeIconWidget("mailTypeIcon", subItem)
    mailTypeIcon:Show(false)
    mailTypeIcon:AddAnchor("LEFT", icon, "RIGHT", 2, 0)
    subItem:SetInset(checkbox:GetWidth(), 0, 0, 0)
    subItem:SetLimitWidth(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local OnEnter = function(self)
      if CheckInputTextVisible(self) then
        return
      end
      SetTooltip(self:GetText(), self)
    end
    subItem:SetHandler("OnEnter", OnEnter)
  end
  function DefaultMailNameLayoutFunc(frame, rowIndex, colIndex, subItem)
    subItem:SetLimitWidth(true)
    subItem:SetInset(10, 0, 11, 0)
    subItem.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
  end
  local rowCount = #listCtrl.items
  for i = 1, rowCount do
    DefaultMailTitleLayoutFunc(listCtrl, i, 1, listCtrl.items[i].subItems[1])
    DefaultMailNameLayoutFunc(listCtrl, i, 2, listCtrl.items[i].subItems[2])
  end
  local columCount = #listCtrl.column
  for i = 1, columCount do
    listCtrl.column[i]:Enable(false)
  end
  for i = 1, columCount do
    SettingListColumn(listCtrl, listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(listCtrl.column[i], #listCtrl.column, i)
  end
  function listCtrl:GetSelctedCheckValue()
  end
  function listCtrl:CheckTakeAllButtonEnable()
    local mailIds = GetVisibleTab():GetSelectedMailIds()
    for i = 1, #mailIds do
      if self.hasItem[mailIds[i]] then
        return true
      end
    end
    return false
  end
  function listCtrl:CheckDeleteButtonEnable()
    local mailIds = GetVisibleTab():GetSelectedMailIds()
    for i = 1, #mailIds do
      if not self.hasItem[mailIds[i]] then
        return true
      end
    end
    return false
  end
  function listCtrl:CheckProc_takeAllAttachmentsButton()
    mailFrame.takeAllAttachmentsButton:Enable(self:CheckTakeAllButtonEnable())
  end
  function listCtrl:CheckProc_deleteButton()
    GetMailDeleteButton():Enable(self:CheckDeleteButtonEnable())
  end
  function listCtrl:IsAllChecked()
    local isAllDisable = true
    for i = 1, #self.checkValue do
      local selectCheck = listCtrl.items[i].subItems[1].checkbox
      if selectCheck:IsEnabled() then
        isAllDisable = false
        if not self.checkValue[i] then
          return false
        end
      end
    end
    self.allSelectCheck:Enable(not isAllDisable)
    return not isAllDisable
  end
  function listCtrl:TitleDataFunc(subItem, data, key)
    if data[MAIL_COL.CHK] == nil or data[MAIL_COL.ERROR] == true then
      data[MAIL_COL.CHK] = false
    end
    subItem.checkbox:SetChecked(data[MAIL_COL.CHK], false)
    if data[MAIL_COL.HASITEM] and data[MAIL_COL.MAIL_TYPE] ~= MAIL_TYPE.BILLING and data[MAIL_COL.MAIL_TYPE] ~= MAIL_TYPE.BALANCE_RECEIPT and data[MAIL_COL.MAIL_TYPE] ~= MAIL_TYPE.NATION_TAX_RECEIPT then
      subItem.icon:Show(true)
    else
      subItem.icon:Show(false)
    end
    if data[MAIL_COL.MAIL_TYPE] == MAIL_TYPE.BILLING or data[MAIL_COL.MAIL_TYPE] == MAIL_TYPE.BALANCE_RECEIPT or data[MAIL_COL.MAIL_TYPE] == MAIL_TYPE.NATION_TAX_RECEIPT or data[MAIL_COL.ERROR] == true then
      subItem.checkbox:Enable(false)
    else
      subItem.checkbox:Enable(true)
    end
    subItem.mailTypeIcon:SetType(GetMailTypeIcon(data[MAIL_COL.MAIL_TYPE]))
    local inset = subItem.checkbox:GetWidth()
    local offset = 2
    local visibleCount = 0
    if subItem.icon:IsVisible() then
      inset = inset + subItem.icon:GetWidth()
      visibleCount = visibleCount + 1
      subItem.mailTypeIcon:RemoveAllAnchors()
      subItem.mailTypeIcon:AddAnchor("LEFT", subItem.icon, "RIGHT", offset, 0)
    else
      subItem.mailTypeIcon:RemoveAllAnchors()
      subItem.mailTypeIcon:AddAnchor("LEFT", subItem.icon, "LEFT", 0)
    end
    if subItem.mailTypeIcon:IsVisible() then
      inset = inset + subItem.mailTypeIcon:GetWidth()
      visibleCount = visibleCount + 1
    end
    if visibleCount > 0 then
      inset = inset + visibleCount * offset
    end
    SetMailHeaderColor(data[MAIL_COL.MAIL_TYPE], data[MAIL_COL.ISREAD], data[MAIL_COL.ERROR], subItem, subItem.mailTypeIcon)
    subItem:SetInset(inset, 0, 0, 0)
    subItem:SetText(data[MAIL_COL.TITLE] or "")
    self.mailIDs[key] = data[MAIL_COL.MAILID]
    self.hasItem[data[MAIL_COL.MAILID]] = data[MAIL_COL.HASITEM]
    self.checkValue[key] = subItem.checkbox:GetChecked()
    function subItem.checkbox:CheckBtnCheckChagnedProc(checked)
      listCtrl.checkValue[key] = checked
      if not checked then
        listCtrl.allSelectCheck:SetChecked(false, false)
      else
        listCtrl.allSelectCheck:SetChecked(listCtrl:IsAllChecked(), false)
      end
      if listCtrl.CheckProc_takeAllAttachmentsButton ~= nil then
        listCtrl:CheckProc_takeAllAttachmentsButton()
      end
      if listCtrl.CheckProc_deleteButton ~= nil then
        listCtrl:CheckProc_deleteButton()
      end
    end
  end
  function listCtrl:NameDataFunc(subItem, data)
    subItem:SetText(data[MAIL_COL.NAME])
    SetMailHeaderColor(data[MAIL_COL.MAIL_TYPE], data[MAIL_COL.ISREAD], data[MAIL_COL.ERROR], subItem)
  end
  return listCtrl
end
