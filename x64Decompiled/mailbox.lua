mailFrame = nil
function GetReadMailWindow()
  return mailFrame.readWindow
end
function GetWriteMailWindow()
  return mailFrame.writeWindow
end
function GetMailDeleteButton()
  return mailFrame.deleteButton
end
function GetMailAllDeleteButton()
  return mailFrame.allDeleteButton
end
function GetVisibleTab()
  if mailFrame.tab.window[1]:IsVisible() then
    return mailFrame.tab.window[1]
  end
  return mailFrame.tab.window[2]
end
function IsSendMailList()
  if mailFrame.tab.window[1]:IsVisible() then
    return false
  end
  return true
end
function CreateMailFrame(id, parent)
  local frame = SetViewOfMailFrame(id, parent)
  local writeButton = frame.writeButton
  local writeWindow = frame.writeWindow
  local readWindow = frame.readWindow
  local deleteButton = frame.deleteButton
  local allDeleteButton = frame.allDeleteButton
  local takeAllAttachmentsButton = frame.takeAllAttachmentsButton
  local guide = frame.guide
  frame.isTakeOne = false
  local function DeleteButtonOnClick(self, arg)
    if arg == "RightButton" then
      return
    end
    local mailIds = GetVisibleTab():GetSelectedMailIds()
    for i = 1, #mailIds do
      local mailId = mailIds[i]
      if X2Mail:GetAttachedItemCountById(false, mailId) == 0 then
        X2Mail:DeleteMailById(IsSendMailList(), mailId)
        if not IsSendMailList() == readWindow.isReceivedMail and mailId == readWindow.mailId then
          readWindow:Show(false)
        end
      end
    end
    if #mailIds > 0 then
      F_SOUND.PlayUISound("event_mail_delete", true)
    end
    self:Enable(false)
    GetVisibleTab().listCtrl.allSelectCheck:SetChecked(false, false)
  end
  deleteButton:SetHandler("OnClick", DeleteButtonOnClick)
  local DeleteButtonOnEnter = function(self)
    SetTargetAnchorTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "delete_selected_mail_tip"), "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
  end
  deleteButton:SetHandler("OnEnter", DeleteButtonOnEnter)
  local DeleteButtonOnLeave = function(self)
    HideTooltip()
  end
  deleteButton:SetHandler("OnLeave", DeleteButtonOnLeave)
  local function AllDeleteButtonOnClick(self, arg)
    if arg == "RightButton" then
      return
    end
    local mailIds, allUnread, allHasItem, hasItem
    if GetVisibleTab() == frame.tab.window[1] then
      mailIds, allUnread, allHasItem, hasItem = GetMailListInfo("receidved")
    elseif GetVisibleTab() == frame.tab.window[2] then
      mailIds, allUnread, allHasItem, hasItem = GetMailListInfo("send")
    end
    if mailIds == nil then
      return
    end
    if not IsSendMailList() then
      if allUnread then
        X2Chat:DispatchChatMessage(CMF_SYSTEM, FONT_COLOR_HEX.RED .. locale.mail.notExistReadMail)
        AddMessageToSysMsgWindow(locale.mail.notExistReadMail)
        return
      else
        if allHasItem then
          X2Chat:DispatchChatMessage(CMF_SYSTEM, FONT_COLOR_HEX.RED .. locale.mail.allReadMailIncludeAttach)
          AddMessageToSysMsgWindow(locale.mail.allReadMailIncludeAttach)
          return
        end
        if hasItem then
          X2Chat:DispatchChatMessage(CMF_SYSTEM, locale.mail.alarmAllReadMailDelected)
          AddMessageToNotifyMessage(locale.mail.alarmAllReadMailDelected)
        end
      end
    end
    for i = 1, #mailIds do
      local mailId = mailIds[i]
      if mailId == readWindow.mailId then
        readWindow:Show(false)
      end
      X2Mail:DeleteMailById(IsSendMailList(), mailId)
    end
    if #mailIds > 0 then
      F_SOUND.PlayUISound("event_mail_delete", true)
    end
    self:Enable(false)
    GetVisibleTab().listCtrl.allSelectCheck:SetChecked(false, false)
    local function AllDeleteButtonOnUpdate(self, dt)
      allDeleteButton.enableTime = allDeleteButton.enableTime + dt
      if allDeleteButton.enableTime >= 10000 then
        allDeleteButton:Enable(GetVisibleTab():GetMailCount())
        allDeleteButton.enableTime = 0
        allDeleteButton:ReleaseHandler("OnUpdate")
        return
      end
    end
    allDeleteButton:SetHandler("OnUpdate", AllDeleteButtonOnUpdate)
  end
  allDeleteButton:SetHandler("OnClick", AllDeleteButtonOnClick)
  local function AllDeleteButtonOnEnter(self)
    if GetVisibleTab() == frame.tab.window[1] then
      SetTargetAnchorTooltip(locale.mail.readMailDeleteTip, "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
    elseif GetVisibleTab() == frame.tab.window[2] then
      SetTargetAnchorTooltip(locale.mail.allMailDeleteTip, "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
    end
  end
  allDeleteButton:SetHandler("OnEnter", AllDeleteButtonOnEnter)
  local AllDeleteButtonOnLeave = function(self)
    HideTooltip()
  end
  allDeleteButton:SetHandler("OnLeave", AllDeleteButtonOnLeave)
  local function TakeAllAttchmentsButtonOnClick(self, arg)
    if arg == "RightButton" then
      return
    end
    local receivedMailListTab = mailFrame.tab.window[1]
    if receivedMailListTab:IsVisible() == false then
      return
    end
    local mailIds = receivedMailListTab:GetSelectedMailIds()
    if #mailIds > 0 then
      frame.isTakeOne = false
      self:Enable(false)
      frame:WaitPage(true)
      X2Mail:TakeAttachmentSequentially(mailIds[1])
    end
  end
  takeAllAttachmentsButton:SetHandler("OnClick", TakeAllAttchmentsButtonOnClick)
  local TakeAllAttachmentsButtonOnEnter = function(self)
    SetTargetAnchorTooltip(X2Locale:LocalizeUiText(COMMON_TEXT, "mail_take_all_attachments_tip"), "BOTTOMLEFT", self, "TOPLEFT", 0, 0)
  end
  takeAllAttachmentsButton:SetHandler("OnEnter", TakeAllAttachmentsButtonOnEnter)
  local TakeAllAttachmentsButtonOnLeave = function(self)
    HideTooltip()
  end
  takeAllAttachmentsButton:SetHandler("OnLeave", TakeAllAttachmentsButtonOnLeave)
  local function WriteButtonOnClick(_, arg)
    if arg == "RightButton" then
      return
    end
    if X2Mail:CanSendMail() then
      writeWindow:Show(not writeWindow:IsVisible())
    else
      AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "BLOCKED_FOR_FREE_TRIAL"))
    end
  end
  writeButton:SetHandler("OnClick", WriteButtonOnClick)
  local function OnTabChanged(self, selected)
    ReAnhorTabLine(self, selected)
    local mailListKind = MAIL_LIST_END
    if selected ~= nil then
      mailListKind = self.window[selected]:FillMailList(mailListKind)
      mailBoxLocale:TabChangedFunc(allDeleteButton, selected)
      if mailListKind == MAIL_LIST_END then
        mailFrame.isTakeOne = false
        mailFrame:WaitPage(false)
        mailFrame:EnableButton(1, true)
      else
        mailFrame:WaitPageCont(true)
        mailFrame:EnableButton(1, false)
      end
    else
      LuaAssert(string.format("error - wrong index : %d", selected))
    end
    if selected == 1 then
      takeAllAttachmentsButton:Show(true)
    elseif selected == 2 then
      takeAllAttachmentsButton:Show(false)
    end
  end
  frame.tab:SetHandler("OnTabChanged", OnTabChanged)
  function frame:OnHide()
    InitLockToBagSlot()
    writeWindow:Show(false)
    readWindow:Show(false)
    mailFrame = nil
  end
  frame:SetHandler("OnHide", frame.OnHide)
  local OnEnter = function(self)
    SetTooltip(locale.mail.guide, self)
  end
  guide:SetHandler("OnEnter", OnEnter)
  function guide:OnLeave()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", guide.OnLeave)
  return frame
end
local mymailboxEvents = {
  MAIL_INBOX_UPDATE = function(read, mailListKind)
    if mailFrame == nil then
      return
    end
    local receivedMailListTab = mailFrame.tab.window[1]
    if receivedMailListTab:IsVisible() == false then
      if mailFrame.tab.window[2]:IsVisible() and mailListKind == MAIL_LIST_END then
        mailFrame.tab.window[2]:FillMailList()
      end
      return
    end
    mailListKind = receivedMailListTab:FillMailList(mailListKind)
    if mailListKind == MAIL_LIST_END or mailListKind == MAIL_LIST_INVALID or mailListKind == nil then
      mailFrame.isTakeOne = false
      mailFrame:WaitPage(false)
      mailFrame:EnableButton(1, true)
    else
      if mailListKind == MAIL_LIST_CONTINUE then
        mailFrame:WaitPageCont(true)
      end
      mailFrame:EnableButton(1, false)
    end
    if X2Mail:IsExistCurrentMailBody() == false then
      return
    end
    local wnd = GetReadMailWindow()
    if wnd.isReceivedMail ~= nil and not wnd.isReceivedMail then
      return
    end
    wnd:FillReadMail()
    if wnd:IsVisible() == true then
      F_SOUND.PlayUISound("event_mail_read_changed", true)
    end
    wnd:Show(true)
  end,
  MAIL_SENTBOX_UPDATE = function(read, mailListKind)
    if mailFrame == nil then
      return
    end
    local SendMailListTab = mailFrame.tab.window[2]
    if SendMailListTab:IsVisible() == false then
      if mailFrame.tab.window[1]:IsVisible() and mailListKind == MAIL_LIST_END then
        mailFrame.tab.window[1]:FillMailList()
      end
      return
    end
    mailListKind = SendMailListTab:FillMailList(mailListKind)
    if mailListKind == MAIL_LIST_END or mailListKind == MAIL_LIST_INVALID or mailListKind == nil then
      mailFrame.isTakeOne = false
      mailFrame:WaitPage(false)
      mailFrame:EnableButton(2, true)
    else
      if mailListKind == MAIL_LIST_CONTINUE then
        mailFrame:WaitPageCont(true)
      end
      mailFrame:EnableButton(2, false)
    end
    if X2Mail:IsExistCurrentMailBody() == false then
      return
    end
    local wnd = GetReadMailWindow()
    if wnd.isReceivedMail ~= nil and wnd.isReceivedMail then
      return
    end
    wnd:FillSendMailInfo()
    if wnd:IsVisible() == true then
      F_SOUND.PlayUISound("event_mail_read_changed", true)
    end
    wnd:Show(true)
  end,
  MAIL_RETURNED = function()
    if mailFrame == nil or mailFrame:IsVisible() == false then
      return
    end
    local tabWnd = GetVisibleTab()
    tabWnd:FillMailList()
  end,
  MAIL_SENT_SUCCESS = function()
    if mailFrame == nil or mailFrame:IsVisible() == false then
      return
    end
    local tabWnd = GetVisibleTab()
    tabWnd:FillMailList()
    GetWriteMailWindow():Show(false)
  end,
  MAIL_INBOX_ITEM_TAKEN = function(index)
    if mailFrame == nil then
      return
    end
    local receivedMailListTab = mailFrame.tab.window[1]
    if receivedMailListTab:IsVisible() == false then
      return
    end
    receivedMailListTab:FillMailList()
    local wnd = GetReadMailWindow()
    if wnd:IsVisible() == false then
      return
    end
    local item = wnd.defaultFrame.itemSlots[index]
    if item == nil then
      LuaAssert("error - received item slot is nil.")
    end
    item:Init()
    wnd:FillReadMail()
    wnd:UpdateRecvAttachmentButtons()
  end,
  MAIL_INBOX_MONEY_TAKEN = function()
    if mailFrame == nil then
      return
    end
    local receivedMailListTab = mailFrame.tab.window[1]
    if receivedMailListTab:IsVisible() == false then
      return
    end
    receivedMailListTab:FillMailList()
    local wnd = GetReadMailWindow()
    wnd:FillReadMail()
    wnd:UpdateRecvAttachmentButtons()
  end,
  MAIL_INBOX_ATTACHMENT_TAKEN_ALL = function(mailId)
    if mailFrame == nil then
      return
    end
    local receivedMailListTab = mailFrame.tab.window[1]
    if receivedMailListTab:IsVisible() == false then
      return
    end
    if mailFrame.isTakeOne == true then
      local wnd = GetReadMailWindow()
      mailFrame.isTakeOne = false
      mailFrame:WaitPage(false)
      mailFrame.readWindow:Enable(true)
      mailFrame.readWindow:FillReadMail()
      if X2Mail:GetCurrentMailType() == MAIL_TYPE.BALANCE_RECEIPT or X2Mail:GetCurrentMailType() == MAIL_TYPE.NATION_TAX_RECEIPT or X2Mail:GetCurrentMailType() == TAX_IN_KIND_RECEIPT then
        F_SOUND.PlayUISound("event_trade_money_recv", true)
      else
        F_SOUND.PlayUISound("event_trade_item_and_money_recv", true)
      end
      return
    end
    local mailIds = GetVisibleTab():GetSelectedMailIds()
    for i = 1, #mailIds - 1 do
      if mailId == mailIds[i] then
        X2Mail:TakeAttachmentSequentially(mailIds[i + 1])
        mailFrame.takeAllAttachmentsButton:Enable(false)
        break
      end
    end
    if mailId == mailIds[#mailIds] then
      receivedMailListTab:FillMailList()
      mailFrame:WaitPage(false)
      GetVisibleTab().listCtrl:CheckProc_takeAllAttachmentsButton()
      GetVisibleTab().listCtrl:CheckProc_deleteButton()
    end
  end,
  MAIL_INBOX_TAX_PAID = function()
    if mailFrame == nil or mailFrame:IsVisible() == false then
      return
    end
    GetReadMailWindow():Show(false)
  end,
  INTERACTION_END = function()
    if mailFrame == nil or mailFrame:IsVisible() == false then
      return
    end
    MAIL_DOODADID = nil
    MAIL_WITHRECEIVER = nil
    mailFrame:Show(false)
  end
}
local function ToggleMail(doodadId, receiver)
  if mailFrame ~= nil and mailFrame:IsVisible() == true then
    MAIL_DOODADID = nil
    MAIL_WITHRECEIVER = nil
    mailFrame:Show(false)
  else
    MAIL_DOODADID = doodadId
    MAIL_WITHRECEIVER = receiver
    if mailFrame == nil then
      mailFrame = CreateMailFrame("mailFrame", "UIParent")
      mailFrame:SetCloseOnEscape(true)
      mailFrame:EnableHidingIsRemove(true)
      ADDON:RegisterContentWidget(UIC_MAIL, mailFrame)
      mailFrame:SetHandler("OnEvent", function(this, event, ...)
        mymailboxEvents[event](...)
      end)
      mailFrame:RegisterEvent("MAIL_INBOX_UPDATE")
      mailFrame:RegisterEvent("MAIL_SENTBOX_UPDATE")
      mailFrame:RegisterEvent("MAIL_RETURNED")
      mailFrame:RegisterEvent("MAIL_SENT_SUCCESS")
      mailFrame:RegisterEvent("MAIL_INBOX_ITEM_TAKEN")
      mailFrame:RegisterEvent("MAIL_INBOX_MONEY_TAKEN")
      mailFrame:RegisterEvent("MAIL_INBOX_ATTACHMENT_TAKEN_ALL")
      mailFrame:RegisterEvent("MAIL_INBOX_TAX_PAID")
      mailFrame:RegisterEvent("INTERACTION_END")
    end
    mailFrame:Show(true)
    GetReadMailWindow():Show(false)
    GetWriteMailWindow():Show(false)
    mailFrame:WaitPage(true)
    mailFrame:EnableButton(1, false)
    mailFrame:EnableButton(2, false)
  end
end
UIParent:SetEventHandler("TOGGLE_MAIL", ToggleMail)
X2Mail:SetReading(false)
X2Mail:SetWriting(false)
