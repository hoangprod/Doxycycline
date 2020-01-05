function CreateReadMailWindow(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = SetViewOfReadMailWindow(id, parent)
  local OFFSET = {
    BG = -7,
    LINE = -3,
    GUIDE_ICON = 3,
    ARROW = 6
  }
  local attachReceiveButton = window.defaultFrame.attachReceiveButton
  local moneyReceiveButton = window.defaultFrame.moneyReceiveButton
  local receiveAAPointWindow = window.defaultFrame.receiveAAPointWindow
  local receiveMoneyWindow = window.defaultFrame.receiveMoneyWindow
  local content = window.content
  local replyButton = window.replyButton
  local returnButton = window.returnButton
  local deleteButton = window.deleteButton
  local payTaxButton = window.payTaxButton
  local receiptTaxButton = window.receiptTaxButton
  local reportButton = window.reportButton
  local DATE_FORMAT_FILTER1 = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY
  local DATE_FORMAT_FILTER2 = FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY
  window.isReceivedMail = nil
  local SetMailTitle = function(mailType, titleLabel, mailTypeIcon)
    local inset = 5
    if mailTypeIcon ~= nil then
      mailTypeIcon:SetType(GetMailTypeIcon(mailType))
      if mailTypeIcon:IsVisible() then
        inset = inset + mailTypeIcon:GetWidth() + 2
      end
    end
    titleLabel:SetInset(inset, 0, 0, 0)
    SetMailHeaderColor(mailType, false, false, titleLabel, mailTypeIcon)
  end
  function window:SetIsReceivedMail(arg)
    self.isReceivedMail = arg
  end
  function window:SettingWidgets(isReceivedMail)
    local myName = X2Unit:UnitName("player")
    returnButton:Show(false)
    deleteButton:Show(false)
    replyButton:Show(false)
    payTaxButton:Show(false)
    receiptTaxButton:Show(false)
    reportButton:Show(false)
    local IsCurrentMailDeletable = function()
      if X2Mail:GetCurrentMailMoneyStr() ~= "0" or X2Mail:GetCurrentMailAttachedItemCount() ~= 0 or X2Mail:GetCurrentMailAAPointStr() ~= "0" then
        return false
      end
      return true
    end
    local function SetSystemMailMode(mailId)
      if X2Mail:IsBillingMail(mailId) == true then
        payTaxButton:Show(true)
        payTaxButton:Enable(true)
      elseif X2Mail:IsTaxRateChangedMail(mailId) == true or X2Mail:IsTaxRateChangedMail(mailId) == true then
        deleteButton:Show(true)
        deleteButton:Enable(true)
      elseif X2Mail:IsNationReceiptMail(mailId) == true then
        if X2Mail:GetAttachedItemCountById(not isReceivedMail, mailId) > 0 then
          receiptTaxButton:Show(true)
          receiptTaxButton:Enable(true)
        else
          deleteButton:Show(true)
          deleteButton:Enable(true)
        end
      else
        returnButton:Show(true)
        deleteButton:Show(true)
        replyButton:Show(true)
        returnButton:Enable(false)
        deleteButton:Enable(IsCurrentMailDeletable())
        replyButton:Enable(false)
      end
    end
    if isReceivedMail == true then
      if X2Mail:IsUserMail(self.mailId) == true then
        returnButton:Show(true)
        deleteButton:Show(true)
        replyButton:Show(true)
        local featureSet = X2Player:GetFeatureSet()
        if userTrialLocale.useMailTrail == false then
          reportButton:Show(false)
          reportButton:Enable(false)
        elseif not featureSet.newReportBaduser then
          reportButton:Show(false)
          reportButton:Enable(false)
        else
          reportButton:Show(true)
          local enable = X2Mail:IsReportedSpamMail(self.mailId)
          reportButton:Enable(enable)
        end
        local isMySelf = myName == self.sender
        returnButton:Enable(not isMySelf)
        replyButton:Enable(not isMySelf)
        local enable = IsCurrentMailDeletable()
        deleteButton:Enable(enable)
        attachReceiveButton:Enable(not enable)
      else
        SetSystemMailMode(self.mailId)
        local enable = IsCurrentMailDeletable()
        attachReceiveButton:Enable(not enable)
      end
      self.roleLabel:SetText(locale.mail.sender .. ": ")
      self:SetTitle(locale.mail.readMail)
    else
      returnButton:Show(true)
      deleteButton:Show(true)
      replyButton:Show(true)
      returnButton:Enable(false)
      deleteButton:Enable(true)
      replyButton:Enable(false)
      attachReceiveButton:Enable(false)
      self.roleLabel:SetText(locale.mail.receiver .. ": ")
      self:SetTitle(locale.mail.readSentMail)
    end
  end
  function window:ItemsClear(idx)
    for i = 1, #self.defaultFrame.itemSlots do
      if idx == nil or idx == i then
        self.defaultFrame.itemSlots[i]:Init()
      end
    end
  end
  function window:Clear()
    self.titleLimitLabel:SetText("")
    self.roleEdit:SetText("")
    content:SetText("")
    if receiveAAPointWindow ~= nil then
      receiveAAPointWindow:UpdateAAPoint("0")
    end
    receiveMoneyWindow:Update("0", false)
    self:ItemsClear()
    moneyReceiveButton:Enable(true)
    receiveMoneyWindow:Enable(true)
    if receiveAAPointWindow ~= nil then
      receiveAAPointWindow:Enable(true)
    end
    local itemSlots = self.defaultFrame.itemSlots
    for i = 1, #itemSlots do
      itemSlots[i]:Enable(true)
      itemSlots[i]:SetStack("0")
    end
    if self.body ~= nil then
      self.body:Show(false)
      self.body = nil
    end
  end
  function window:FillContents(isReceivedMail)
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local sender
    if isReceivedMail == true then
      sender = bodyInfo.sender
      local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
      self.date:SetText(str)
    else
      sender = bodyInfo.receiver
      local str = baselibLocale:GetDefaultDateString(bodyInfo.sendDate.year, bodyInfo.sendDate.month, bodyInfo.sendDate.day)
      self.date:SetText(str)
    end
    if sender == "" then
      sender = locale.mail.deletedCharacter
    end
    self.mailId = bodyInfo.mail_id
    self.sender = sender
    local replacedSender = GetMailText(sender, "sender")
    if replacedSender == "__QUEST__" then
      local questMailSender = X2Mail:GetQuestMailSender(bodyInfo.extra)
      if questMailSender ~= nil then
        replacedSender = questMailSender
      end
    end
    self.roleEdit:SetText(replacedSender)
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    self.titleLimitLabel:SetText(GetMailText(sender, bodyInfo.title))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    content:SetText(GetMailText(sender, bodyInfo.text))
  end
  function window:FillTaxMailContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local text = string.format("sender(\"%s\")", bodyInfo.zone_group_name)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = string.format("title(\"%s\")", bodyInfo.zone_group_name)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    local featureSet = X2Player:GetFeatureSet()
    if self.body == nil then
      if featureSet.taxItem then
        self.body = self:CreateBodyFrame("TYPE2", self.defaultFrame)
      else
        self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
      end
    end
    local body = self.body
    local statement = self.body.content.statement
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    local text = string.format("%s: %s%s", X2Locale:LocalizeUiText(MAIL_TEXT, "tax_subject"), FONT_COLOR_HEX.BLUE, bodyTextInfo.name)
    statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    local dfEnd = X2Time:TimeToDate(bodyTextInfo.tax_period_end)
    local text = string.format("%s: %s%s%s", X2Locale:LocalizeUiText(MAIL_TEXT, "tax_period"), FONT_COLOR_HEX.BLUE, locale.time.GetDateToDateFormat(dfEnd), locale.housing.untilTerm)
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    local _, includeSpace1 = statement:GetHeightToLastLine()
    body.bg:RemoveAllAnchors()
    body.bg:AddAnchor("TOPLEFT", statement, -sideMargin / 2, includeSpace1 + OFFSET.BG)
    local leftText = GetUIText(COMMON_TEXT, "base_tax")
    local rightText = string.format("%s%s", FONT_COLOR_HEX.BLUE, F_MONEY:GetTaxString(bodyTextInfo.basic_tax))
    local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    if bodyTextInfo.isHeavyTaxHouse == "true" then
      local leftText = GetUIText(MAIL_TEXT, "dominion_tax")
      local rightText = string.format("%s%s%%", FONT_COLOR_HEX.BLUE, bodyTextInfo.dominion_tax_rate)
      local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    end
    if bodyTextInfo.hostile_tax_rate ~= nil and 0 < tonumber(bodyTextInfo.hostile_tax_rate) then
      local leftText = GetCommonText("housing_hostile_faction_tax")
      local rightText = string.format("%s%d%%", FONT_COLOR_HEX.BLUE, bodyTextInfo.hostile_tax_rate)
      local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    end
    local desc = ""
    if bodyTextInfo.isHeavyTaxHouse == "true" then
      local leftText = GetUIText(COMMON_TEXT, "housing_possession_count")
      local rightText = string.format("%s%s", FONT_COLOR_HEX.BLUE, bodyTextInfo.heavyTaxHouseCount)
      local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      desc = locale.housing.tax_warning
    else
      desc = locale.housing.taxExemptionWarning
    end
    local leftText = X2Locale:LocalizeUiText(MAIL_TEXT, "unpaid_count")
    local rightText = string.format("%s%s", FONT_COLOR_HEX.BLUE, bodyTextInfo.unpaid_count)
    local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    local _, includeSpace2 = statement:GetHeightToLastLine()
    statement:AttachLowerSpaceLine(index, 15)
    if featureSet.taxItem then
      body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin)
      local text = string.format("%s%s", FONT_COLOR_HEX.RED, GetCommonText("housing_tax_item"))
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      statement:AttachUpperSpaceLine(index, 3)
      local _, includeSpace3 = statement:GetHeightToLastLine()
      body.itemIcon:AddAnchor("TOP", body.content, 0, includeSpace3 - 13)
      statement:AttachLowerSpaceLine(index, ICON_SIZE.DEFAULT)
      body.itemIcon:FillTaxInfo(bodyTextInfo.total_tax)
      self.taxString = X2House:CountTaxItemForTax(bodyTextInfo.total_tax)
    else
      local _, includeSpace2 = statement:GetHeightToLastLine()
      body.line:RemoveAllAnchors()
      body.line:AddAnchor("TOP", statement, 0, includeSpace2 + OFFSET.LINE + -2)
      local leftText = string.format("%s%s", FONT_COLOR_HEX.RED, X2Locale:LocalizeUiText(MAIL_TEXT, "total_tax"))
      local rightText = string.format("%s%s", FONT_COLOR_HEX.RED, string.format(F_MONEY.currency.pipeString[F_MONEY.currency.houseTax], bodyTextInfo.total_tax))
      local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
      local _, includeSpace3 = statement:GetHeightToLastLine()
      body.bg:SetHeight(includeSpace3 - includeSpace1 + sideMargin)
      statement:AttachLowerSpaceLine(index, 15)
    end
    if bodyTextInfo.unpaid_count == "1" then
      local text = string.format("%s%s", FONT_COLOR_HEX.RED, GetUIText(HOUSING_TEXT, "warning_default"))
      local index = statement:AddLine(text, "", 0, "left", ALIGN_CENTER, 0)
      statement:AttachLowerSpaceLine(index, 5)
    end
    local df = X2Time:TimeToDate(bodyTextInfo.pay_period)
    local remainDate = X2Time:PeriodTimeToDate(X2Time:GetLocalTime(), bodyTextInfo.pay_period)
    local text = ""
    local FILTER = mailBoxLocale.housingTaxFilter
    if bodyTextInfo.unpaid_count == "1" then
      text = string.format("%s: %s%s(%s%s)", locale.housing.demolishDate, FONT_COLOR_HEX.RED, locale.time.GetDateToDateFormat(df, FILTER), locale.time.GetRemainDateToDateFormat(remainDate), locale.housing.left)
    else
      text = string.format("%s: %s%s%s(%s%s)", X2Locale:LocalizeUiText(MAIL_TEXT, "pay_period"), FONT_COLOR_HEX.BLUE, locale.time.GetDateToDateFormat(df, FILTER), locale.housing.untilTerm, locale.time.GetRemainDateToDateFormat(remainDate), locale.housing.left)
    end
    local index = statement:AddLine(text, "", 0, "left", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 10)
    local text = string.format("%s%s", FONT_COLOR_HEX.GRAY, desc)
    statement:AddLine(text, "", 0, "left", ALIGN_CENTER, 0)
    body:ResetScroll(statement:GetHeight())
    self.taxString = F_MONEY:GetTaxString(bodyTextInfo.total_tax)
  end
  function window:FillNationReceiptMailContents()
    local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    self.roleEdit:SetText(locale.mail.nationalTax.sender)
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = string.format("title(\"%s\")", bodyInfo.zone_group_name)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    if self.body == nil then
      self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
    end
    local body = self.body
    local statement = self.body.content.statement
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    local lastPaidTime = X2Time:TimeToDate(bodyTextInfo.lastPaidTime)
    local curPaidTime = X2Time:TimeToDate(bodyTextInfo.curPaidTime)
    local endFilter = mailBoxLocale.MakeEndFilter(curPaidTime, lastPaidTime, DATE_FORMAT_FILTER1, DATE_FORMAT_FILTER2)
    local text = string.format("%s: %s~%s", GetCommonText("period"), locale.time.GetDateToDateFormat(lastPaidTime, DATE_FORMAT_FILTER1), locale.time.GetDateToDateFormat(curPaidTime, endFilter))
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    local _, includeSpace1 = statement:GetHeightToLastLine()
    body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
    local text = string.format("%s%s", FONT_COLOR_HEX.BLUE, locale.mail.balanceReceiptBody.total)
    local text_2 = ""
    if F_MONEY.currency.siegeAuctionBid == CURRENCY_AA_POINT then
      text_2 = string.format("%s|p%s;", FONT_COLOR_HEX.BLUE, bodyTextInfo.aaPoint)
    else
      text_2 = string.format("%s|m%s;", FONT_COLOR_HEX.BLUE, bodyTextInfo.money)
    end
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    statement:AddAnotherSideLine(index, text_2, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
    local _, includeSpace2 = statement:GetHeightToLastLine()
    body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin)
    if X2Mail:GetCurrentMailMoneyStr() == "0" and X2Mail:GetCurrentMailAttachedItemCount() == 0 and X2Mail:GetCurrentMailAAPointStr() == "0" then
      statement:AttachLowerSpaceLine(index, 15)
      local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.mail.balanceReceiptBody.alreadyReceipt)
      statement:AddLine(str, "", 0, "left", ALIGN_CENTER, 0)
      deleteButton:RemoveAllAnchors()
      deleteButton:AddAnchor("CENTER", self.buttonSetWindow, 0, 0)
    end
    body:ResetScroll(statement:GetHeight())
    self.taxString = bodyTextInfo.total_tax
  end
  function window:FillTaxRateChangedMailContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = string.format("title(\"%s\")", bodyInfo.zone_group_name)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    if self.body == nil then
      self.body = self:CreateBodyFrame("TYPE4", self.defaultFrame)
    end
    local body = self.body
    local statement = self.body.content.statement
    local index = statement:AddLine(locale.mail.taxRateChangeBody.content(bodyInfo.zone_group_name), FONT_PATH.DEFAULT, 15, "left", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 15)
    local _, includeSpace1 = statement:GetHeightToLastLine()
    body.arrow:AddAnchor("TOP", statement, -5, includeSpace1 + OFFSET.ARROW)
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    local text = string.format("%s%s%%        %s%s%%", FONT_COLOR_HEX.BLACK, bodyTextInfo.old_tax_rate, FONT_COLOR_HEX.BLUE, bodyTextInfo.new_tax_rate)
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.XLARGE, "left", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 20)
    local _, includeSpace2 = statement:GetHeightToLastLine()
    body.guideIcon:AddAnchor("TOPRIGHT", statement, 0, includeSpace2 + OFFSET.GUIDE_ICON)
    local index = statement:AddLine(locale.mail.taxRateChange.taxtations, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 10)
    local _, includeSpace3 = statement:GetHeightToLastLine()
    body.bg:AddAnchor("TOP", statement, 0, includeSpace3 + OFFSET.BG)
    local additionalTaxRate = tonumber(bodyTextInfo.new_tax_rate)
    local taxations = X2House:GetTaxations(additionalTaxRate)
    for i = 1, #taxations do
      local str = string.format("%s", taxations[i].desc)
      local index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      local str_2 = F_MONEY:GetTaxString(taxations[i].taxString)
      statement:AddAnotherSideLine(index, str_2, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    end
    local _, includeSpace4 = statement:GetHeightToLastLine()
    body.bg:SetHeight(includeSpace4 - includeSpace3 + sideMargin)
    local OnEnter = function(self)
      local info = X2House:GetTaxItem()
      SetTooltip(locale.territory.taxItemTip(FONT_COLOR_HEX.SOFT_YELLOW, info.name), self)
    end
    body.guideIcon:SetHandler("OnEnter", OnEnter)
    body:ResetScroll(statement:GetHeight() + sideMargin)
  end
  function window:FillNationTaxRateChangedMailContents(mailType)
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    self.roleEdit:SetText(locale.mail.nationalTaxRate.sender)
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    self.titleLimitLabel:SetText(locale.mail.nationalTaxRate.title)
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    if self.body == nil then
      self.body = self:CreateBodyFrame("TYPE8", self.defaultFrame)
    end
    local body = self.body
    local statement = self.body.content.statement
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    local factionName = X2Nation:GetNationName(tonumber(bodyTextInfo.factionId))
    local text = string.format("%s%s", FONT_COLOR_HEX.BLUE, factionName)
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_CENTER, 0)
    local zoneName = X2Dominion:GetZoneGroupName(tonumber(bodyTextInfo.zoneGroupType))
    local text = string.format("%s%s", FONT_COLOR_HEX.BLACK, locale.mail.nationTaxRateChangeBody(zoneName))
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 50)
    local _, includeSpace1 = statement:GetHeightToLastLine()
    body.arrow:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.ARROW)
    local text = string.format("%s%s%%         %s%s%%", FONT_COLOR_HEX.BLACK, X2Nation:ConvertNationalTaxRate(tonumber(bodyTextInfo.oldTaxRate)), FONT_COLOR_HEX.BLUE, X2Nation:ConvertNationalTaxRate(tonumber(bodyTextInfo.newTaxRate)))
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.XLARGE, "left", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 60)
    local day = X2Time:TimeToDate(bodyTextInfo.day)
    day = locale.time.GetDateToDateFormat(day)
    local text = string.format("%s%s", FONT_COLOR_HEX.BLACK, locale.mail.nationTaxRateChangeBodyDay(day))
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, 15, "left", ALIGN_CENTER, 0)
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillAuctionMailContents(mailType)
    local bodyInfo = X2Mail:GetCurrentMailBody()
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = string.format(GetMailText(bodyInfo.sender, bodyInfo.title))
    self.titleLimitLabel:SetText(text)
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    if self.body == nil then
      if mailType == MAIL_TYPE.AUCTION_BID_WIN then
        self.body = self:CreateBodyFrame("TYPE6", self.defaultFrame)
      elseif mailType == MAIL_TYPE.AUCTION_OFF_SUCCESS then
        self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
      else
        self.body = self:CreateBodyFrame("TYPE7", self.defaultFrame)
      end
    end
    local body = self.body
    local statement = self.body.content.statement
    if mailType == MAIL_TYPE.AUCTION_OFF_FAIL then
      local index = statement:AddLine(bodyTextInfo.bodyTitle, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    elseif mailType == MAIL_TYPE.AUCTION_OFF_CANCEL then
      local index = statement:AddLine(bodyTextInfo, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    elseif mailType == MAIL_TYPE.AUCTION_BID_WIN then
      if bodyTextInfo.money ~= nil then
        local index = statement:AddLine(bodyTextInfo.bodyTitle, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
        statement:AttachLowerSpaceLine(index, 15)
        local _, includeSpace1 = statement:GetHeightToLastLine()
        body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
        local index = statement:AddLine(locale.mail.bidMoney, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
        local rightText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.auctionBid], tostring(bodyTextInfo.money))
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
        local _, includeSpace2 = statement:GetHeightToLastLine()
        body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin)
      end
    elseif mailType == MAIL_TYPE.AUCTION_OFF_SUCCESS then
      if bodyTextInfo.bidMoney ~= nil then
        local text = string.format("%sx%s", X2Locale:LocalizeUiText(MAIL_TEXT, "sell_backpack_item_name", bodyTextInfo.itemName), bodyTextInfo.count)
        local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
        statement:AttachLowerSpaceLine(index, 15)
        local _, includeSpace1 = statement:GetHeightToLastLine()
        body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
        local index = statement:AddLine(locale.mail.profit, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
        if F_MONEY.currency.auctionBid == F_MONEY.currency.auctionFee then
          rightText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.auctionBid], bodyTextInfo.money)
        else
          local result = X2Util:NumberToString(tonumber(bodyTextInfo.money) - tonumber(bodyTextInfo.deposit))
          rightText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.auctionBid], result)
        end
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
        if F_MONEY.currency.auctionBid ~= F_MONEY.currency.auctionFee then
          rightText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.auctionFee], bodyTextInfo.deposit)
          index = statement:AddLine(rightText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "right", ALIGN_RIGHT, 0)
        end
        statement:AttachLowerSpaceLine(index, 10)
        local _, includeSpace2 = statement:GetHeightToLastLine()
        body.line:AddAnchor("TOP", statement, 0, includeSpace2 + OFFSET.LINE)
        local index = statement:AddLine(locale.mail.bidMoney, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format(F_MONEY.currency.pipeString[F_MONEY.currency.auctionBid], bodyTextInfo.bidMoney)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
        local index = statement:AddLine(locale.mail.deposit, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format("+ " .. F_MONEY.currency.pipeString[F_MONEY.currency.auctionFee], bodyTextInfo.deposit)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
        local charge
        if bodyTextInfo.chargePers == nil then
          charge = string.format("%s", locale.mail.charge)
        else
          charge = string.format("%s (%s)", locale.mail.charge, bodyTextInfo.chargePers)
        end
        local index = statement:AddLine(charge, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format("- " .. F_MONEY.currency.pipeString[F_MONEY.currency.auctionBid], bodyTextInfo.charge)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
        local advantage = bodyTextInfo.advantage
        if advantage ~= nil then
          local advantageNum = tonumber(advantage)
          if advantageNum > 0 then
            local kind = bodyTextInfo.serviceKind
            if kind ~= nil then
              if kind == ASK_PCBANG then
                local uiString = string.format("%s%s", FONT_COLOR_HEX.RED, X2Locale:LocalizeUiText(MAIL_TEXT, "auction_sales_advantage_pcbang", advantage))
                index = statement:AddLine(uiString, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
              elseif kind == ASK_PREMIUM then
                local uiString = string.format("%s%s", FONT_COLOR_HEX.RED, X2Locale:LocalizeUiText(MAIL_TEXT, "auction_sales_advantage_premium", advantage))
                index = statement:AddLine(uiString, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
              elseif kind == ASK_ACCOUNT_BUFF then
                local uiString = string.format("%s%s", FONT_COLOR_HEX.RED, X2Locale:LocalizeUiText(MAIL_TEXT, "auction_sales_advantage_account_buff", advantage))
                index = statement:AddLine(uiString, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
              end
            end
          end
        end
        local _, includeSpace3 = statement:GetHeightToLastLine()
        body.bg:SetHeight(includeSpace3 - includeSpace1 + sideMargin)
        statement:AttachLowerSpaceLine(index, 15)
      end
    elseif mailType == MAIL_TYPE.AUCITON_BID_FAIL then
      local index = statement:AddLine(bodyTextInfo, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    end
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillSellBackbackMailContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = GetMailText(bodyInfo.sender, bodyInfo.title)
    self.titleLimitLabel:SetText(text)
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    local featureSet = X2Player:GetFeatureSet()
    if self.body == nil then
      if featureSet.backpackProfitShare then
        self.body = self:CreateBodyFrame("TYPE5", self.defaultFrame)
      else
        self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
      end
    end
    local body = self.body
    local statement = self.body.content.statement
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    local text = string.format("%s%s|r", FONT_COLOR_HEX.BLACK, bodyTextInfo.itemName)
    local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    local OnEnter = function(self)
      if self.tooltip == nil then
        return
      end
      SetTooltip(self.tooltip, self)
    end
    body.guideIcon:SetHandler("OnEnter", OnEnter)
    local GetTooltip = function(receiverCase)
      local str = ""
      if receiverCase == 1 then
        str = string.format("%s%s|r", FONT_COLOR_HEX.SOFT_YELLOW, GetCommonText("mail_actual_gain_tip_seller_title"))
      else
        str = string.format("%s%s|r", FONT_COLOR_HEX.SOFT_YELLOW, GetCommonText("mail_actual_gain_tip_crafter_title"))
      end
      local sellerRatio = X2Store:GetSellerShareRatio()
      str = string.format([[
%s
%s]], str, X2Locale:LocalizeUiText(COMMON_TEXT, "mail_actual_gain_tip", FONT_COLOR_HEX.SOFT_YELLOW, tostring(100 - sellerRatio), tostring(sellerRatio)))
      return str
    end
    local _, includeSpace1 = statement:GetHeightToLastLine()
    body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
    local featureSet = X2Player:GetFeatureSet()
    if featureSet.backpackProfitShare and bodyTextInfo.coinType == 0 then
      local _, includeSpace1 = statement:GetHeightToLastLine()
      if bodyTextInfo.receiverCase ~= nil and bodyTextInfo.receiverCase ~= 2 and bodyTextInfo.receiverCase ~= 3 then
        local leftText = string.format("%s%s|r", FONT_COLOR_HEX.BLUE, GetCommonText("mail_actual_gain"))
        local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 23)
        local value
        if bodyTextInfo.receiverCase == 1 then
          value = bodyTextInfo.sellerCoinCount
        else
          value = bodyTextInfo.crafterCoinCount
        end
        statement:AddAnotherSideLine(index, string.format("|u%d;", value), FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
        statement:AttachLowerSpaceLine(index, mailBoxLocale.specialty.secondStateOffset)
        body.guideIcon:AddAnchor("TOPLEFT", statement, 0, includeSpace1 + OFFSET.GUIDE_ICON + mailBoxLocale.specialty.guideOffset)
        body.guideIcon.tooltip = GetTooltip(bodyTextInfo.receiverCase)
      else
        body.guideIcon:Show(false)
      end
      local index = statement:AddLine(locale.mail.totalSellBackpackMoney, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      local rightText = string.format("%s|u%d;|r", FONT_COLOR_HEX.BLUE, bodyTextInfo.crafterCoinCount + bodyTextInfo.sellerCoinCount)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
      statement:AttachLowerSpaceLine(index, 10)
      local _, includeSpace2 = statement:GetHeightToLastLine()
      body.line:AddAnchor("TOP", body, 0, includeSpace2 + OFFSET.LINE + mailBoxLocale.specialty.lineOffset)
      local index = statement:AddLine(locale.store_specialty.prices, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      local rightText = string.format("%d%%", bodyTextInfo.ratio)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      if 0 < tonumber(bodyTextInfo.freshness) then
        local index = statement:AddLine(GetCommonText("freshness"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format("%d%%", bodyTextInfo.freshness)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      end
      local index = statement:AddLine(locale.mail.interest, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      local rightText = string.format("%d%%", bodyTextInfo.interest)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      local numMerchantRatio = tonumber(bodyTextInfo.specialtyMerchantRatio)
      if numMerchantRatio ~= 0 then
        index = statement:AddLine(GetCommonText("specialty_merchant_ratio"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format("%d%%", numMerchantRatio)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      end
      local _, includeSpace3 = statement:GetHeightToLastLine()
      body.bg:SetHeight(includeSpace3 - includeSpace1 + sideMargin)
      statement:AttachLowerSpaceLine(index, 15)
      self:FillAttachMoneys(true, true)
    else
      local _, includeSpace1 = statement:GetHeightToLastLine()
      if featureSet.backpackProfitShare and bodyTextInfo.receiverCase ~= 2 and bodyTextInfo.receiverCase ~= 3 then
        local leftText = string.format("%s%s|r", FONT_COLOR_HEX.BLUE, GetCommonText("mail_actual_gain"))
        local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 23)
        statement:AddAnotherSideLine(index, bodyTextInfo.actualGain, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
        statement:AttachLowerSpaceLine(index, mailBoxLocale.specialty.secondStateOffset)
        body.guideIcon:AddAnchor("TOPLEFT", statement, 0, includeSpace1 + OFFSET.GUIDE_ICON + mailBoxLocale.specialty.guideOffset)
        body.guideIcon.tooltip = GetTooltip(bodyTextInfo.receiverCase)
      else
        _, includeSpace1 = statement:GetHeightToLastLine()
        body.guideIcon:Show(false)
      end
      local index = statement:AddLine(locale.mail.totalSellBackpackMoney, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, bodyTextInfo.totalMoney, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
      statement:AttachLowerSpaceLine(index, 10)
      local _, includeSpace2 = statement:GetHeightToLastLine()
      body.line:AddAnchor("TOP", statement, 0, includeSpace2 + OFFSET.LINE + mailBoxLocale.specialty.lineOffset)
      local index = statement:AddLine(GetCommonText("mail_sell_backpack_early_money"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, bodyTextInfo.earlyMoney, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      local extraRatio = tonumber(bodyTextInfo.extraRatio)
      local extraRatioKind = bodyTextInfo.extraRatioKind
      if extraRatio > 0 then
        if extraRatioKind == 1 then
          local index = statement:AddLine(GetCommonText("mail_sell_backpack_pcbang_ratio"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          local rightText = string.format("%d%%", extraRatio)
          statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
        elseif extraRatioKind == 2 then
          local info = X2Store:GetAccountBuffInfoUsingSpecialityConfig()
          local index = statement:AddLine(GetCommonText("mail_sell_backpack_account_buff_ratio"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
          local rightText = string.format("%d%%", extraRatio)
          statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
        end
      end
      local index = statement:AddLine(locale.store_specialty.prices, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      local rightText = string.format("%d%%", bodyTextInfo.ratio)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      if 0 < tonumber(bodyTextInfo.bargain) then
        local index = statement:AddLine(locale.mail.bargainingMoney, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        statement:AddAnotherSideLine(index, bodyTextInfo.bargainingMoney, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      end
      if 0 < tonumber(bodyTextInfo.freshness) then
        local index = statement:AddLine(GetCommonText("freshness"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format("%d%%", bodyTextInfo.freshness)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      end
      local leftText = string.format("%s%s|r", FONT_COLOR_HEX.BLACK, locale.mail.interest)
      local index = statement:AddLine(leftText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      local rightText = string.format("%d%%", bodyTextInfo.interest)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      local numMerchantRatio = tonumber(bodyTextInfo.specialtyMerchantRatio)
      if numMerchantRatio ~= 0 then
        index = statement:AddLine(GetCommonText("specialty_merchant_ratio"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
        local rightText = string.format("%d%%", numMerchantRatio)
        statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
      end
      local _, includeSpace3 = statement:GetHeightToLastLine()
      body.bg:SetHeight(includeSpace3 - includeSpace1 + sideMargin)
      statement:AttachLowerSpaceLine(index, 15)
      self:FillAttachMoneys(true, false)
    end
    if bodyTextInfo.tradegood == nil or bodyTextInfo.tradegood == 0 then
      local text = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.mail.sellBackpackTip)
      statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_CENTER, 0)
    end
    if bodyTextInfo.revenueSanction ~= nil and bodyTextInfo.revenueSanction == 1 then
      local text = string.format("%s%s", FONT_COLOR_HEX.RED, GetUIText(COMMON_TEXT, "revenue_sanction_msg"))
      statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_CENTER, 0)
    end
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillHousingSaleMailContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    local titleInfo = GetMailText(bodyInfo.sender, bodyInfo.title)
    self.titleLimitLabel:SetText(titleInfo.title)
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.roleEdit:SetText(titleInfo.sender)
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    if self.body == nil then
      if bodyInfo.sender == ".houseSellCancel" then
        self.body = self:CreateBodyFrame("TYPE7", self.defaultFrame)
      else
        self.body = self:CreateBodyFrame("TYPE6", self.defaultFrame)
      end
    end
    local body = self.body
    local statement = self.body.content.statement
    if bodyInfo.sender == ".houseSellCancel" then
      local text = string.format("%s%s|r", FONT_COLOR_HEX.BLACK, bodyTextInfo)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    elseif bodyInfo.sender == ".houseSold" then
      local text = string.format("%s: %s", GetCommonText("buyerName"), bodyTextInfo.buyerName)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      local text = string.format("%s: %s", X2Locale:LocalizeUiText(MAIL_TEXT, "tax_subject"), bodyTextInfo.houseName)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      statement:AttachLowerSpaceLine(index, 15)
      local _, includeSpace1 = statement:GetHeightToLastLine()
      body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
      local text = string.format("%s%s", FONT_COLOR_HEX.BLACK, locale.mail.housePrice)
      local text_2 = string.format("%s" .. F_MONEY.currency.pipeString[F_MONEY.currency.houseSale], FONT_COLOR_HEX.BLUE, bodyTextInfo.price)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, 15, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, text_2, FONT_PATH.DEFAULT, 15, ALIGN_RIGHT, 0)
      local _, includeSpace2 = statement:GetHeightToLastLine()
      body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin + 2)
    elseif bodyInfo.sender == ".houseBought" then
      local text = string.format("%s: %s", locale.auction.seller, bodyTextInfo.sellerName)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      local text = string.format("%s: %s", X2Locale:LocalizeUiText(MAIL_TEXT, "tax_subject"), bodyTextInfo.houseName)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      statement:AttachLowerSpaceLine(index, 15)
      local _, includeSpace1 = statement:GetHeightToLastLine()
      body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
      local text = string.format("%s%s", FONT_COLOR_HEX.BLACK, locale.mail.housePrice)
      local text_2 = string.format("%s" .. F_MONEY.currency.pipeString[F_MONEY.currency.houseSale], FONT_COLOR_HEX.BLUE, bodyTextInfo.price)
      local index = statement:AddLine(text, FONT_PATH.DEFAULT, 15, "left", ALIGN_LEFT, 0)
      statement:AddAnotherSideLine(index, text_2, FONT_PATH.DEFAULT, 15, ALIGN_RIGHT, 0)
      local _, includeSpace2 = statement:GetHeightToLastLine()
      body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin + 2)
    end
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillHeroElectionContents(mailType)
    local bodyInfo = X2Mail:GetCurrentMailBody()
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, bodyInfo.title))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    if self.body == nil then
      self.body = self:CreateBodyFrame("TYPE9", self.defaultFrame, "brown")
    end
    local body = self.body
    local statement = self.body.content.statement
    local bodyStr = bodyTextInfo.msg
    local index = statement:AddLine(bodyStr, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    if mailType == MAIL_TYPE.HERO_ELECTION_ITEM then
      statement:AttachLowerSpaceLine(index, 150)
    else
      statement:AttachLowerSpaceLine(index, 250)
    end
    local dfStart = X2Time:TimeToDate(bodyTextInfo.periodStart)
    local dfEnd = X2Time:TimeToDate(bodyTextInfo.periodEnd)
    local DATE_FORMAT_FILTER1 = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR
    local DATE_FORMAT_FILTER2 = FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY + FORMAT_FILTER.HOUR
    local endFilter = mailBoxLocale.MakeEndFilter(dfStart, dfEnd, DATE_FORMAT_FILTER1, DATE_FORMAT_FILTER2)
    local uiPeriodText = ""
    if mailType == MAIL_TYPE.HERO_ELECTION_ITEM then
      uiPeriodText = GetUIText(COMMON_TEXT, "activity_period")
    else
      uiPeriodText = GetUIText(COMMON_TEXT, "abstain_period")
    end
    local text = string.format("%s: %s%s~%s|r", uiPeriodText, FONT_COLOR_HEX.BLUE, locale.time.GetDateToDateFormat(dfStart, DATE_FORMAT_FILTER1), locale.time.GetDateToDateFormat(dfEnd, endFilter))
    statement:AddLine(text, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "center", ALIGN_CENTER, 0)
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillHousingRebuildContents(mailType)
    local bodyInfo = X2Mail:GetCurrentMailBody()
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, bodyInfo.title))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    if self.body == nil then
      self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
    end
    local body = self.body
    local statement = self.body.content.statement
    local index
    if bodyTextInfo.deposit ~= -1 then
      index = statement:AddLine(GetUIText(COMMON_TEXT, "rebuilding_mail_body_include_deposit"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    else
      index = statement:AddLine(GetUIText(COMMON_TEXT, "rebuilding_mail_body"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    end
    statement:AttachLowerSpaceLine(index, 10)
    local str = string.format("%s: %s%s|r", GetUIText(COMMON_TEXT, "existing_housing_name"), FONT_COLOR_HEX.BLUE, bodyTextInfo.existingHousingName)
    statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    str = string.format("%s: %s%s|r", GetUIText(COMMON_TEXT, "rebuilding_housing_name"), FONT_COLOR_HEX.BLUE, bodyTextInfo.rebuilngHousingName)
    index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    if bodyTextInfo.deposit ~= -1 then
      local _, includeSpace1 = statement:GetHeightToLastLine()
      body.bg:RemoveAllAnchors()
      body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
      index = statement:AddLine(GetUIText(COMMON_TEXT, "deposit_item_count"), FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
      local rightText = string.format("%s|x%d;|r", FONT_COLOR_HEX.BLUE, bodyTextInfo.deposit)
      statement:AddAnotherSideLine(index, rightText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, ALIGN_RIGHT, 0)
      local _, includeSpace2 = statement:GetHeightToLastLine()
      body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin)
    end
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillTaxInKindReceiptContents()
    local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = string.format("title(\"%s\",%s)", bodyInfo.zone_group_name, tostring(bodyInfo.is_nation))
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    if self.body == nil then
      self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
    end
    local body = self.body
    local statement = self.body.content.statement
    text = string.format("body(\"%s\",%s)", bodyInfo.zone_group_name, tostring(bodyInfo.is_nation))
    local bodyText = GetMailText(bodyInfo.sender, text)
    local index = statement:AddLine(bodyText, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillSiegeAuctionStartContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, bodyInfo.title))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    self.body = self:CreateBodyFrame("TYPE7", self.defaultFrame)
    local body = self.body
    local statement = self.body.content.statement
    local time = string.format("%s", locale.time.GetDateToDateFormat(X2Time:TimeToDate(bodyTextInfo), DATE_FORMAT_FILTER1))
    local text1 = X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_start_body")
    local text2 = X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_start_time", time)
    local text3 = X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_start_place")
    local text4 = X2Locale:LocalizeUiText(MAIL_TEXT, "siege_auction_start_comment")
    local index = statement:AddLine(text1, FONT_PATH.DEFAULT, FONT_SIZE.LARGE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 180)
    statement:AddLine(text2, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "center", ALIGN_CENTER, 0)
    index = statement:AddLine(text3, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "center", ALIGN_CENTER, 0)
    statement:AttachLowerSpaceLine(index, 16)
    statement:AddLine(text4, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "center", ALIGN_CENTER, 0)
    body:ResetScroll(statement:GetHeight())
  end
  function window:FillExpeditionImmigrationRejectContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    local text = string.format("sender(\"%s\")", bodyInfo.title)
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, X2Locale:LocalizeUiText(COMMON_TEXT, "immigration_expediton_reject_title")))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
    local statement = self.body.content.statement
    local str = GetUIText(COMMON_TEXT, "immigration_expediton_reject_body", FONT_COLOR_HEX.BLUE, bodyInfo.title)
    statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    self.body:ResetScroll(statement:GetHeight())
  end
  function window:FillResidentBalanceContents(mailType)
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    self.roleEdit:SetText(GetMailText(bodyInfo.sender, "sender"))
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    local text = string.format("title(\"%s\")", bodyInfo.zone_group_name)
    self.titleLimitLabel:SetText(GetMailText(bodyInfo.sender, text))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.body = self:CreateBodyFrame("TYPE3", self.defaultFrame)
    local statement = self.body.content.statement
    local body = self.body
    local bodyTextInfo = GetMailText(bodyInfo.sender, bodyInfo.text)
    local zoneName = string.format("%s%s", FONT_COLOR_HEX.BLUE, X2Dominion:GetZoneGroupName(tonumber(bodyTextInfo.zoneGroupType)))
    local str = GetUIText(COMMON_TEXT, "resident_balance_receipt_area", zoneName)
    local index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    local _, includeSpace1 = statement:GetHeightToLastLine()
    body.bg:RemoveAllAnchors()
    body.bg:AddAnchor("TOP", statement, 0, includeSpace1 + OFFSET.BG)
    local totalPoint = string.format("%s%s", FONT_COLOR_HEX.BLUE, tostring(bodyTextInfo.totalServicePoint))
    str = GetUIText(COMMON_TEXT, "resident_balance_receipt_total_service_point", totalPoint)
    index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    local myPoint = string.format("%s%s", FONT_COLOR_HEX.BLUE, tostring(bodyTextInfo.myServicePoint))
    str = GetUIText(COMMON_TEXT, "resident_balance_receipt_my_service_point", myPoint)
    index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    index = statement:AddLine(GetUIText(COMMON_TEXT, "resident_balance_receipt_service_point_per"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    local chargeRateStr = string.format("%s%s", FONT_COLOR_HEX.BLUE, string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(bodyTextInfo.chargeRate)))
    statement:AddAnotherSideLine(index, chargeRateStr, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    local totalChargeTitle
    if mailType == MAIL_TYPE.RESIDENT_BALANCE then
      totalChargeTitle = GetUIText(COMMON_TEXT, "resident_balance_receipt_total_charge")
    else
      totalChargeTitle = GetUIText(COMMON_TEXT, "dominion_balance_receipt_total_charge")
    end
    index = statement:AddLine(totalChargeTitle, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    local totalChargetext = string.format("%s%s", FONT_COLOR_HEX.BLUE, string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(bodyTextInfo.totalCharge)))
    statement:AddAnotherSideLine(index, totalChargetext, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    local localTaxTitle
    if mailType == MAIL_TYPE.RESIDENT_BALANCE then
      localTaxTitle = GetUIText(COMMON_TEXT, "resident_balance_receipt_local_tax")
    else
      localTaxTitle = GetUIText(COMMON_TEXT, "dominion_balance_receipt_local_tax")
    end
    index = statement:AddLine(localTaxTitle, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    local localTaxtext = string.format("%s%d %%", FONT_COLOR_HEX.BLUE, bodyInfo.system_charge / 10)
    statement:AddAnotherSideLine(index, localTaxtext, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    statement:AttachLowerSpaceLine(index, 15)
    local _, includeLine = statement:GetHeightToLastLine()
    body.line:RemoveAllAnchors()
    body.line:AddAnchor("TOP", statement, 0, includeLine + OFFSET.LINE + -2)
    index = statement:AddLine(GetUIText(COMMON_TEXT, "resident_balance_receipt_dividend"), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    local myDividendtext = string.format("%s%s", FONT_COLOR_HEX.BLUE, string.format(F_MONEY.currency.pipeString[CURRENCY_GOLD], tostring(bodyTextInfo.myDividend)))
    statement:AddAnotherSideLine(index, myDividendtext, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, ALIGN_RIGHT, 0)
    statement:AttachLowerSpaceLine(index, 2)
    local _, includeSpace2 = statement:GetHeightToLastLine()
    body.bg:SetHeight(includeSpace2 - includeSpace1 + sideMargin)
    statement:AttachLowerSpaceLine(index, 20)
    if mailType == MAIL_TYPE.RESIDENT_BALANCE then
      str = string.format("%s%s", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "resident_balance_formula_title"))
      index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
      str = string.format("%s%s", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "resident_balance_formula_body"))
      index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    else
      str = string.format("%s%s", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "dominion_balance_formula"))
      index = statement:AddLine(str, FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
    end
    self.body:ResetScroll(statement:GetHeight())
  end
  function window:FillAttachMoneys(receive, invisibleMoney)
    if invisibleMoney then
      receiveMoneyWindow:Update(0, false)
      moneyReceiveButton:Enable(false)
      return
    end
    local money = X2Mail:GetCurrentMailMoneyStr()
    local aaPoint = X2Mail:GetCurrentMailAAPointStr()
    if receiveAAPointWindow ~= nil then
      receiveAAPointWindow:UpdateAAPoint(aaPoint)
    end
    receiveMoneyWindow:Update(money, false)
    if money == "0" and aaPoint == "0" then
      moneyReceiveButton:Enable(false)
      return
    end
    moneyReceiveButton:Enable(receive)
  end
  function window:FillAttachItems(receive)
    if X2Mail:GetCurrentMailAttachedItemCount() == 0 then
      return
    end
    for idx = 1, MAX_ATTACHMENT_COUNT do
      do
        local itemSlot = self.defaultFrame.itemSlots[idx]
        local mailItemInfo = X2Mail:GetCurrentMailItem(idx)
        if mailItemInfo ~= nil then
          local stackCount = GetItemStackCount(mailItemInfo)
          itemSlot:Enable(receive)
          if receive then
          end
          itemSlot:LayoutStack({
            fontColor = {
              1,
              1,
              1,
              0.5
            }
          })
          itemSlot:SetItemInfo(mailItemInfo)
          itemSlot:SetStack(tostring(stackCount))
          function itemSlot:procOnEnter()
            local mailItemInfo = X2Mail:GetCurrentMailItem(idx)
            self:SetItemInfo(mailItemInfo)
          end
        end
      end
    end
  end
  function window:FillBattleFieldRewardContents()
    local bodyInfo = X2Mail:GetCurrentMailBody()
    local sender = bodyInfo.sender
    local findPos = string.find(bodyInfo.title, "title")
    if findPos ~= nil then
      local titleTemp = bodyInfo.title
      local l = string.find(titleTemp, "%(")
      if l == nil then
        sender = GetMailText(bodyInfo.sender, "sender")
      else
        local optionText = string.format("sender%s", string.sub(titleTemp, l, string.len(titleTemp)))
        sender = GetMailText(bodyInfo.sender, optionText)
      end
    end
    local str = baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day)
    self.date:SetText(str)
    if sender == "" then
      sender = locale.mail.deletedCharacter
    end
    self.mailId = bodyInfo.mail_id
    self.sender = bodyInfo.sender
    self.roleEdit:SetText(sender)
    SetMailTitle(bodyInfo.mail_type, self.roleEdit)
    self.titleLimitLabel:SetText(GetMailText(self.sender, bodyInfo.title))
    SetMailTitle(bodyInfo.mail_type, self.titleLimitLabel, self.titleLimitLabel.mailTypeIcon)
    self.body = self:CreateBodyFrame("TYPE1", self.defaultFrame)
    self.body:AddLine(GetMailText(self.sender, bodyInfo.text), FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE, "left", ALIGN_LEFT, 0)
  end
  function window:FillReceivedMailInfo()
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:FillContents(true)
    self:FillAttachMoneys(true)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillSendMailInfo()
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:FillContents(false)
    self:FillAttachMoneys(false)
    self:FillAttachItems(false)
    self:SettingWidgets(false)
  end
  function window:FillTaxMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillTaxMailContents()
    self:SettingWidgets(true)
  end
  function window:FillNationReceiptMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillNationReceiptMailContents()
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillTaxRateChangedMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillTaxRateChangedMailContents()
    self:SettingWidgets(true)
  end
  function window:FillNationTaxRateChangedMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillNationTaxRateChangedMailContents()
    self:SettingWidgets(true)
  end
  function window:FillAuctionSaleMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleAuctionContentFrame(mailType)
    self.defaultFrame.attachReceiveButton:Enable(false)
    self.defaultFrame.receiveMoneyWindow:Enable(true)
    if self.defaultFrame.receiveAAPointWindow ~= nil then
      self.defaultFrame.receiveAAPointWindow:Enable(true)
    end
    local itemSlots = self.defaultFrame.itemSlots
    for i = 1, #itemSlots do
      itemSlots[i]:Enable(false)
    end
    self:FillAuctionMailContents(mailType)
    self:FillAttachMoneys(true)
    self:SettingWidgets(true)
  end
  function window:FillAuctionBuyMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleAuctionContentFrame(mailType)
    self:FillAuctionMailContents(mailType)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillAuctionFailMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleAuctionContentFrame(mailType)
    self:FillAuctionMailContents(mailType)
    self:FillAttachItems(true)
    self:FillAttachMoneys(true)
    self:SettingWidgets(true)
  end
  function window:FillSellBackpackMailInfo()
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleSellBackpackContentFrame()
    self:FillSellBackbackMailContents()
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillHousingSaleMailInfo()
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleSellBackpackContentFrame()
    self:FillHousingSaleMailContents()
    self:FillAttachMoneys(true)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillHeroElectionMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillHeroElectionContents(mailType)
    if mailType == MAIL_TYPE.HERO_ELECTION_ITEM then
      self:FillAttachItems(true)
    end
    self:SettingWidgets(true)
  end
  function window:FillHousingRebuildMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:FillHousingRebuildContents(mailType)
    self:FillAttachMoneys(false)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillTaxInKindReceiptMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:FillTaxInKindReceiptContents(mailType)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillSiegeAuctionStartMailInfo(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillSiegeAuctionStartContents(mailType)
    self:FillAttachMoneys(false)
    self:FillAttachItems(false)
    self:SettingWidgets(true)
  end
  function window:FillExpeditionImmigrationReject(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillExpeditionImmigrationRejectContents(mailType)
    self:FillAttachMoneys(false)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillResidentBalance(mailType)
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:VisibleTaxContentFrame(mailType)
    self:FillResidentBalanceContents(mailType)
    self:FillAttachMoneys(true)
    self:FillAttachItems(false)
    self:SettingWidgets(true)
  end
  function window:FillBattleFieldReward()
    self:Clear()
    self:VisibleDefaultContetFrame()
    self:FillBattleFieldRewardContents()
    self:FillAttachMoneys(true)
    self:FillAttachItems(true)
    self:SettingWidgets(true)
  end
  function window:FillReadMail()
    local mailType = X2Mail:GetCurrentMailType()
    if mailType == MAIL_TYPE.BILLING then
      self:FillTaxMailInfo(mailType)
    elseif mailType == MAIL_TYPE.TAXRATE_CHANGED then
      self:FillTaxRateChangedMailInfo(mailType)
    elseif mailType == MAIL_TYPE.AUCTION_OFF_SUCCESS then
      self:FillAuctionSaleMailInfo(mailType)
    elseif mailType == MAIL_TYPE.AUCTION_BID_WIN then
      self:FillAuctionBuyMailInfo(mailType)
    elseif mailType == MAIL_TYPE.AUCTION_OFF_FAIL or mailType == MAIL_TYPE.AUCTION_OFF_CANCEL or mailType == MAIL_TYPE.AUCITON_BID_FAIL then
      self:FillAuctionFailMailInfo(mailType)
    elseif mailType == MAIL_TYPE.SYS_SELL_BACKPACK then
      self:FillSellBackpackMailInfo()
    elseif mailType == MAIL_TYPE.HOUSING_SALE then
      self:FillHousingSaleMailInfo()
    elseif mailType == MAIL_TYPE.NATION_TAX_RATE then
      self:FillNationTaxRateChangedMailInfo(mailType)
    elseif mailType == MAIL_TYPE.NATION_TAX_RECEIPT then
      self:FillNationReceiptMailInfo(mailType)
    elseif mailType == MAIL_TYPE.HERO_CANDIDATE_ALARM or mailType == MAIL_TYPE.HERO_ELECTION_ITEM then
      self:FillHeroElectionMailInfo(mailType)
    elseif mailType == MAIL_TYPE.HOUSING_REBUILD then
      self:FillHousingRebuildMailInfo(mailType)
    elseif mailType == MAIL_TYPE.TAX_IN_KIND_RECEIPT then
      self:FillTaxInKindReceiptMailInfo(mailType)
    elseif mailType == MAIL_TYPE.SIEGE_AUCTION_START then
      self:FillSiegeAuctionStartMailInfo(mailType)
    elseif mailType == MAIL_TYPE.MAIL_EXPEDITION_IMMIGRATION_REJECT then
      self:FillExpeditionImmigrationReject(mailType)
    elseif mailType == MAIL_TYPE.BALANCE_RECEIPT or mailType == MAIL_TYPE.RESIDENT_BALANCE then
      self:FillResidentBalance(mailType)
      self.content:Show(false)
    elseif mailType == MAIL_TYPE.MAIL_BATTLE_FIELD_REWARD then
      self:FillBattleFieldReward()
    else
      self:FillReceivedMailInfo()
    end
  end
  function window:GetReplyMailInfos()
    local info = {}
    info.sender = self.roleEdit:GetText()
    info.title = X2Util:UTF8StringLimit(locale.mail.reply .. self.titleLimitLabel:GetText(), 20, "...")
    return info
  end
  function replyButton:OnClick(arg)
    if arg == "LeftButton" then
      local info = window:GetReplyMailInfos()
      GetWriteMailWindow():Show(true)
      GetWriteMailWindow():FillReplyInfos(info)
    end
  end
  replyButton:SetHandler("OnClick", replyButton.OnClick)
  function returnButton:OnClick(arg)
    if arg == "LeftButton" and window.mailId ~= nil then
      local function DialogHandler(wnd, infoTable)
        function wnd:OkProc()
          X2Mail:ReturnMailById(window.mailId)
          window:Show(false)
        end
        wnd:SetTitle(locale.mail.return_title)
        wnd:SetContent(locale.mail.return_content)
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
    end
  end
  returnButton:SetHandler("OnClick", returnButton.OnClick)
  function deleteButton:OnClick(arg)
    if arg == "LeftButton" and window.mailId ~= nil then
      X2Mail:DeleteCurrentMail()
      window:Show(false)
      F_SOUND.PlayUISound("event_current_mail_delete", true)
    end
  end
  deleteButton:SetHandler("OnClick", deleteButton.OnClick)
  function reportButton:OnClick(arg)
    if arg == "LeftButton" then
      if mailBoxLocale.useSpamMailFilter == false then
        X2Trial:StartReportBadUserUI(window.sender)
      else
        X2Mail:ReportSpam(window.mailId)
        window:Show(false)
      end
    end
  end
  reportButton:SetHandler("OnClick", reportButton.OnClick)
  function reportButton:OnEnter()
    SetTooltip(GetUIText(TOOLTIP_TEXT, "report_bad_mail"), self)
  end
  reportButton:SetHandler("OnEnter", reportButton.OnEnter)
  function window:UpdateRecvAttachmentButtons()
    if X2Mail:GetCurrentMailAttachedItemCount() == 0 then
      self.defaultFrame.attachReceiveButton:Enable(false)
      self.deleteButton:Enable(true)
    else
      self.defaultFrame.attachReceiveButton:Enable(true)
      self.deleteButton:Enable(false)
    end
    self:FillAttachMoneys(true)
  end
  function payTaxButton:OnClick(arg)
    if arg == "LeftButton" and window.mailId ~= nil then
      local function DialogHandler(wnd)
        ApplyDialogStyle(wnd, "TYPE2")
        wnd:SetTitle(locale.messageBox.payTax.title)
        local content = locale.messageBox.payTax.body
        wnd:SetContentEx(content, window.taxString)
        function wnd:OkProc()
          X2Mail:PayCurrentMailChargeMoney()
          payTaxButton:Enable(false)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
    end
  end
  payTaxButton:SetHandler("OnClick", payTaxButton.OnClick)
  function receiptTaxButton:OnClick(arg)
    if arg == "LeftButton" and window.mailId ~= nil and parent.isTakeOne ~= true then
      parent.isTakeOne = true
      X2Mail:TakeAttachmentSequentially(window.mailId)
      window:Enable(false)
      receiptTaxButton:Enable(false)
      parent:WaitPage(true)
    end
  end
  receiptTaxButton:SetHandler("OnClick", receiptTaxButton.OnClick)
  function attachReceiveButton:OnClick(arg)
    if arg == "LeftButton" and window.mailId ~= nil and parent.isTakeOne ~= true then
      parent.isTakeOne = true
      X2Mail:TakeAttachmentSequentially(window.mailId)
      window:Enable(false)
      parent:WaitPage(true)
    end
  end
  attachReceiveButton:SetHandler("OnClick", attachReceiveButton.OnClick)
  function moneyReceiveButton:OnClick(arg)
    if arg == "LeftButton" and parent.isTakeOne ~= true then
      X2Mail:TakeCurrentMailMoney()
      F_SOUND.PlayUISound("event_trade_money_recv", true)
    end
  end
  moneyReceiveButton:SetHandler("OnClick", moneyReceiveButton.OnClick)
  for i = 1, MAX_ATTACHMENT_COUNT do
    do
      local item = window.defaultFrame.itemSlots[i]
      function item:OnClickProc(arg)
        if X2Mail:GetCurrentMailAttachedItemCount() == 0 then
          return
        end
        local mailItemInfo = X2Mail:GetCurrentMailItem(i)
        if mailItemInfo == nil then
          return
        end
        if parent.isTakeOne == true then
          return
        end
        X2Mail:TakeCurrentMailItem(i)
        F_SOUND.PlayUISound("event_trade_item_recv", true)
      end
    end
  end
  function window:ShowProc()
    if GetWriteMailWindow():IsVisible() then
      GetWriteMailWindow():Show(false)
    end
    X2Mail:SetReading(true)
  end
  function window:OnHide()
    self:Clear()
    X2Mail:ClearCurrentMail()
    X2DialogManager:DeleteByOwnerWindow(self:GetId())
    self.body = nil
    X2Mail:SetReading(false)
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
