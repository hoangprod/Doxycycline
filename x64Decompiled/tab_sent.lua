function CreateMailSentFrame(window)
  CreateMailList(window, locale.mail.receiver)
  local listCtrl = window.listCtrl
  local pageCtrl = window.pageCtrl
  function listCtrl:OnSelChanged(selectedIndex, doubleClick)
    if selectedIndex > 0 and doubleClick == true then
      GetReadMailWindow():SetIsReceivedMail(false)
      X2Mail:ReadPostedMailById(listCtrl.mailIDs[selectedIndex])
    end
  end
  listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
  function pageCtrl:OnPageChanged(pageIndex, countPerPage)
    window:FillMailList()
  end
  function window:GetDeleteEnableMailListInfo()
    local mailCount = X2Mail:GetPostedMailCount()
    local readedMailList = {}
    for i = 1, mailCount do
      local mailInfo = X2Mail:GetPostedMailTitleInfo(i)
      table.insert(readedMailList, mailInfo.mail_id)
    end
    return readedMailList
  end
  function window:GetMailCount()
    return X2Mail:GetPostedMailCount()
  end
  function window:FillMailList(mailListKind)
    local oldDatas
    if #listCtrl.checkValue >= 1 then
      oldDatas = {}
      for i = 1, #listCtrl.checkValue do
        oldDatas[i] = {}
        oldDatas[i][MAIL_COL.MAILID] = listCtrl.mailIDs[i]
        oldDatas[i][MAIL_COL.CHK] = listCtrl.checkValue[i]
      end
    end
    local function FillMailPageList(mailInfo, key, chk)
      local title = ""
      title = GetMailText(mailInfo.sender, mailInfo.title)
      firstColumnData = {}
      firstColumnData[MAIL_COL.TITLE] = title
      firstColumnData[MAIL_COL.MAILID] = mailInfo.mail_id
      firstColumnData[MAIL_COL.CHK] = chk
      firstColumnData[MAIL_COL.ISREAD] = mailInfo.is_read
      firstColumnData[MAIL_COL.MAIL_TYPE] = mailInfo.mail_type
      listCtrl:InsertData(key, 1, title)
      listCtrl:TitleDataFunc(listCtrl.items[key].subItems[1], firstColumnData, key)
      local receiver = mailInfo.receiver
      if receiver == "" then
        receiver = locale.mail.deletedCharacter
      end
      secondColumnData = {}
      secondColumnData[MAIL_COL.NAME] = receiver
      secondColumnData[MAIL_COL.ISREAD] = mailInfo.is_read
      secondColumnData[MAIL_COL.MAIL_TYPE] = mailInfo.mail_type
      listCtrl:InsertData(key, 2, receiver)
      listCtrl:NameDataFunc(listCtrl.items[key].subItems[2], secondColumnData)
    end
    listCtrl:DeleteAllDatas()
    listCtrl.mailIDs = {}
    listCtrl.checkValue = {}
    local mailCount = X2Mail:GetPostedMailCount()
    if mailCount == 0 then
      listCtrl.allSelectCheck:Enable(false)
      listCtrl.allSelectCheck:SetChecked(false)
      GetMailDeleteButton():Enable(false)
      return mailListKind
    end
    listCtrl.allSelectCheck:Enable(true)
    mailFrame.takeAllAttachmentsButton:Show(false)
    local pageCurrentIndex = pageCtrl:GetCurrentPageIndex()
    local key = 1
    mailListKind = MAIL_LIST_END
    for i = 1, PAGE_PER_MAIL_MAX_COUNT do
      local mailIndex = GetMailIdx(pageCurrentIndex, PAGE_PER_MAIL_MAX_COUNT, i)
      if mailCount < mailIndex then
        break
      end
      if mailIndex <= 0 then
        break
      end
      local mailInfo = X2Mail:GetPostedMailTitleInfo(mailIndex)
      if mailInfo ~= nil then
        local value = false
        if oldDatas ~= nil then
          for j = 1, #oldDatas do
            if mailInfo.mail_id == oldDatas[j][MAIL_COL.MAILID] then
              value = oldDatas[j][MAIL_COL.CHK]
            end
          end
        end
        FillMailPageList(mailInfo, key, value)
        key = key + 1
      else
        mailListKind = MAIL_LIST_CONTINUE
        local mailLastIndex = GetMailIdx(pageCurrentIndex, PAGE_PER_MAIL_MAX_COUNT, PAGE_PER_MAIL_MAX_COUNT)
        if mailCount < mailLastIndex then
          mailLastIndex = mailCount
        end
        X2Mail:RequestMailList(MLK_OUTBOX, mailIndex, mailLastIndex - mailIndex + 1)
        break
      end
    end
    listCtrl.allSelectCheck:SetChecked(listCtrl:IsAllChecked(), false)
    pageCtrl:SetPageByItemCount(mailCount, PAGE_PER_MAIL_MAX_COUNT)
    if mailListKind == MAIL_LIST_END then
      X2Mail:CompleteMailList()
    end
    return mailListKind
  end
end
