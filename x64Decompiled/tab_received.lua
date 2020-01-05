function CreateMailReceivedFrame(window)
  CreateMailList(window, locale.mail.sender)
  local countLabel = window:CreateChildWidget("label", "countLabel", 0, true)
  countLabel:SetAutoResize(true)
  countLabel:SetHeight(20)
  countLabel:AddAnchor("TOPRIGHT", window, -23, -22)
  ApplyTextColor(countLabel, FONT_COLOR.BLUE)
  local mailCountLabel = window:CreateChildWidget("label", "mailCountLabel", 0, true)
  mailCountLabel:SetAutoResize(true)
  mailCountLabel:SetExtent(30, 20)
  mailCountLabel:AddAnchor("RIGHT", countLabel, "LEFT", 0, 0)
  mailCountLabel:SetText(locale.mail.unreadMailCount)
  ApplyTextColor(mailCountLabel, FONT_COLOR.DEFAULT)
  local listCtrl = window.listCtrl
  local pageCtrl = window.pageCtrl
  function listCtrl:OnSelChanged(selectedIndex, doubleClick)
    if selectedIndex > 0 and doubleClick == true then
      GetReadMailWindow():SetIsReceivedMail(true)
      X2Mail:ReadReceivedMailById(listCtrl.mailIDs[selectedIndex])
    end
  end
  listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
  function pageCtrl:OnPageChanged(pageIndex, countPerPage)
    window:FillMailList()
  end
  function window:GetMailCount()
    return X2Mail:GetReceivedMailCount()
  end
  function window:GetDeleteEnableMailListInfo()
    local mailCount = X2Mail:GetReceivedMailCount()
    local unreadMailCount = 0
    local allUnread = false
    local hasItem = false
    local hasItemMailCount = 0
    local allHasItem = false
    local readedMailList = {}
    for i = 1, mailCount do
      local mailInfo = X2Mail:GetReceivedMailTitleInfo(i)
      if mailInfo.is_read then
        if not mailInfo.hasItem then
          table.insert(readedMailList, mailInfo.mail_id)
        else
          hasItem = true
          hasItemMailCount = hasItemMailCount + 1
        end
      else
        unreadMailCount = unreadMailCount + 1
      end
    end
    if unreadMailCount == mailCount then
      allUnread = true
    end
    if hasItemMailCount == mailCount - unreadMailCount then
      allHasItem = true
    end
    return readedMailList, allUnread, allHasItem, hasItem
  end
  function window:FillMailList(mailListKind)
    local oldDatas
    if mailListKind == MAIL_LIST_END or mailListKind == MAIL_LIST_INVALID or mailListKind == nil then
      oldDatas = {}
      for i = 1, #listCtrl.checkValue do
        oldDatas[i] = {}
        oldDatas[i][MAIL_COL.MAILID] = listCtrl.mailIDs[i]
        oldDatas[i][MAIL_COL.CHK] = listCtrl.checkValue[i]
      end
    end
    local function FillMailPageList(mailInfo, key, chk)
      local title = ""
      if mailInfo.mail_type == MAIL_TYPE.BILLING or mailInfo.mail_type == MAIL_TYPE.BALANCE_RECEIPT or mailInfo.mail_type == MAIL_TYPE.TAXRATE_CHANGED or mailInfo.mail_type == MAIL_TYPE.NATION_TAX_RECEIPT or mailInfo.mail_type == MAIL_TYPE.RESIDENT_BALANCE then
        local text = string.format("title(\"%s\")", mailInfo.zone_group_name)
        title = GetMailText(mailInfo.sender, text)
      elseif mailInfo.mail_type == MAIL_TYPE.TAX_IN_KIND_RECEIPT then
        local text = string.format("title(\"%s\", %s)", mailInfo.zone_group_name, tostring(mailInfo.is_nation))
        title = GetMailText(mailInfo.sender, text)
      elseif mailInfo.mail_type == MAIL_TYPE.HOUSING_SALE then
        local saleInfo = GetMailText(mailInfo.sender, mailInfo.title)
        title = saleInfo.title
      elseif mailInfo.mail_type == MAIL_TYPE.MAIL_EXPEDITION_IMMIGRATION_REJECT then
        title = GetMailText(mailInfo.sender, X2Locale:LocalizeUiText(COMMON_TEXT, "immigration_expediton_reject_title"))
      else
        title = GetMailText(mailInfo.sender, mailInfo.title)
      end
      local firstColumnData = {}
      firstColumnData[MAIL_COL.TITLE] = title
      firstColumnData[MAIL_COL.ISREAD] = mailInfo.is_read
      firstColumnData[MAIL_COL.HASITEM] = mailInfo.hasItem
      firstColumnData[MAIL_COL.MAILID] = mailInfo.mail_id
      firstColumnData[MAIL_COL.CHK] = chk
      firstColumnData[MAIL_COL.MAIL_TYPE] = mailInfo.mail_type
      firstColumnData[MAIL_COL.ERROR] = mailInfo.failToLoadItems
      listCtrl:InsertData(key, 1, title)
      listCtrl:TitleDataFunc(listCtrl.items[key].subItems[1], firstColumnData, key)
      local senderName = ""
      if mailInfo.sender == "" then
        senderName = locale.mail.deletedCharacter
      elseif mailInfo.mail_type == MAIL_TYPE.BILLING then
        local text = string.format("sender(\"%s\")", mailInfo.zone_group_name)
        senderName = GetMailText(mailInfo.sender, text)
      elseif mailInfo.mail_type == MAIL_TYPE.HOUSING_SALE then
        local saleInfo = GetMailText(mailInfo.sender, mailInfo.title)
        senderName = saleInfo.sender
      elseif mailInfo.mail_type == MAIL_TYPE.MAIL_EXPEDITION_IMMIGRATION_REJECT then
        local text = string.format("sender(\"%s\")", mailInfo.title)
        senderName = GetMailText(mailInfo.sender, text)
      elseif mailInfo.mail_type == MAIL_TYPE.MAIL_BATTLE_FIELD_REWARD then
        local findPos = string.find(mailInfo.title, "title")
        if findPos == nil then
          senderName = GetMailText(mailInfo.sender, "sender")
        else
          local titleTemp = mailInfo.title
          local l = string.find(titleTemp, "%(")
          if l == nil then
            senderName = GetMailText(mailInfo.sender, "sender")
          else
            local optionText = string.format("sender%s", string.sub(titleTemp, l, string.len(titleTemp)))
            senderName = GetMailText(mailInfo.sender, optionText)
          end
        end
      else
        senderName = GetMailText(mailInfo.sender, "sender")
      end
      if senderName == "__QUEST__" then
        local questMailSender = X2Mail:GetQuestMailSender(mailInfo.extra)
        if questMailSender ~= nil then
          senderName = questMailSender
        end
      end
      local secondColumnData = {}
      secondColumnData[MAIL_COL.NAME] = senderName
      secondColumnData[MAIL_COL.ISREAD] = mailInfo.is_read
      secondColumnData[MAIL_COL.MAIL_TYPE] = mailInfo.mail_type
      secondColumnData[MAIL_COL.ERROR] = mailInfo.failToLoadItems
      listCtrl:InsertData(key, 2, senderName)
      listCtrl:NameDataFunc(listCtrl.items[key].subItems[2], secondColumnData)
    end
    listCtrl:DeleteAllDatas()
    listCtrl.mailIDs = {}
    listCtrl.checkValue = {}
    local mailCount = X2Mail:GetReceivedMailCount()
    countLabel:SetText(string.format("%d/%d", X2Mail:GetCountUnreadMail(), mailCount))
    if mailCount == 0 then
      listCtrl.allSelectCheck:Enable(false)
      listCtrl.allSelectCheck:SetChecked(false)
      GetMailDeleteButton():Enable(false)
      GetMailAllDeleteButton():Enable(false)
      mailFrame.takeAllAttachmentsButton:Enable(false)
      return mailListKind
    end
    listCtrl.allSelectCheck:Enable(true)
    mailFrame.takeAllAttachmentsButton:Show(true)
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
      local mailInfo = X2Mail:GetReceivedMailTitleInfo(mailIndex)
      if mailIndex <= 0 then
        break
      end
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
        X2Mail:RequestMailList(MLK_INBOX, mailIndex, mailLastIndex - mailIndex + 1)
        mailFrame.readWindow:Show(false)
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
