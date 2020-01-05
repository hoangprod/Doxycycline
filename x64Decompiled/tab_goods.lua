local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
function SetViewOfGoodsMailListFrame(window)
  local countLabel = window:CreateChildWidget("label", "countLabel", 0, true)
  countLabel:SetAutoResize(true)
  countLabel:SetHeight(20)
  countLabel:AddAnchor("BOTTOMLEFT", window, sideMargin, -sideMargin)
  ApplyTextColor(countLabel, FONT_COLOR.BLUE)
  local readWindow = CreateReadGoodsMailWindow(window:GetId() .. ".readWindow", window)
  readWindow:Show(false)
  readWindow:AddAnchor("TOPLEFT", window, "TOPRIGHT", 20, -80)
  window.readWindow = readWindow
end
function CreateGoodsMailFrame(window)
  CreateGoodsMailList(window)
  SetViewOfGoodsMailListFrame(window)
  local pageControl = window.goodMailList.pageControl
  local frame = window.goodMailList
  local listCtrl = window.goodMailList.listCtrl
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    window:FillMailList()
  end
  function frame:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    if selDataIdx > 0 and doubleClick == true then
      local data = frame:GetDataByViewIndex(selDataViewIdx, 2)
      X2GoodsMail:ReadReceivedMailById(data[COMERCIAL_MAIL_COL.MAILID])
    end
  end
  function window:ShowMail(mailId)
    window.readWindow:Show(true)
  end
  function window:UpdateUnreadCount()
    local str = locale.comercialMail.GetUnconfirmedGoodsText(X2GoodsMail:GetCountUnreadMail(), X2GoodsMail:GetReceivedMailCount())
    self.countLabel:SetText(str)
  end
  function window:FillMailList()
    frame:DeleteAllDatas()
    self:UpdateUnreadCount()
    local mailListKind = MAIL_LIST_END
    local mailCount = X2GoodsMail:GetReceivedMailCount()
    if mailCount == 0 then
      window:WaitPage(false)
      return
    end
    local pageCurrentIndex = pageControl:GetCurrentPageIndex()
    local key = 1
    for i = 1, PAGE_PER_MAIL_MAX_COUNT do
      local mailIndex = GetMailIdx(pageCurrentIndex, PAGE_PER_MAIL_MAX_COUNT, i)
      if mailCount < mailIndex then
        break
      end
      if mailIndex <= 0 then
        break
      end
      local mailInfo = X2GoodsMail:GetReceivedMailTitleInfo(mailIndex)
      local bodyInfo = X2GoodsMail:GetCacheBodyInfo(false, mailIndex)
      if mailInfo == nil or bodyInfo == nil then
        mailListKind = MAIL_LIST_CONTINUE
        local mailLastIndex = GetMailIdx(pageCurrentIndex, PAGE_PER_MAIL_MAX_COUNT, PAGE_PER_MAIL_MAX_COUNT)
        if mailCount < mailLastIndex then
          mailLastIndex = mailCount
        end
        X2Mail:RequestMailList(MLK_COMMERCIAL, mailIndex, mailLastIndex - mailIndex + 1)
        break
      end
      local parseInfo = ParsePipeArgFromBody(bodyInfo)
      local mailId = mailInfo.mail_id
      local firColData = {}
      firColData[COMERCIAL_MAIL_COL.MAIL_TYPE] = mailInfo.mail_type
      firColData[COMERCIAL_MAIL_COL.GIFT] = parseInfo.gift
      local secColData = {}
      secColData[COMERCIAL_MAIL_COL.TITLE] = GetMailText(mailInfo.sender, mailInfo.title)
      secColData[COMERCIAL_MAIL_COL.MAILID] = mailId
      secColData[COMERCIAL_MAIL_COL.ISREAD] = mailInfo.is_read
      local thiColData = {}
      thiColData[COMERCIAL_MAIL_COL.RECV_DATE] = bodyInfo.recvDate
      thiColData[COMERCIAL_MAIL_COL.REFUND_LIMIT_FILE_TIME] = parseInfo.limit_file_time
      thiColData[COMERCIAL_MAIL_COL.REFUND] = parseInfo.refund
      thiColData[COMERCIAL_MAIL_COL.ISREAD] = mailInfo.is_read
      thiColData[COMERCIAL_MAIL_COL.MAILID] = mailId
      frame:InsertData(mailId, 1, firColData)
      frame:InsertData(mailId, 2, secColData)
      frame:InsertData(mailId, 3, thiColData)
    end
    pageControl:SetPageByItemCount(mailCount, PAGE_PER_MAIL_MAX_COUNT)
    if mailListKind == MAIL_LIST_END then
      X2GoodsMail:CompleteMailList()
      window:WaitPage(false)
    end
    if mailListKind == MAIL_LIST_CONTINUE then
      window:WaitPageCont(true)
    end
  end
  function window:ShowList(show)
    if show then
      window:WaitPage(true)
      window:FillMailList()
    end
    window:Show(show)
  end
  local goodsMailEvents = {
    GOODS_MAIL_INBOX_UPDATE = function(read)
      if window:IsVisible() == false then
        return
      end
      window:FillMailList()
      if read == false then
        return
      end
      window.readWindow:FillReceivedMailInfo()
      window.readWindow:Show(true)
      F_SOUND.PlayUISound("event_mail_read_changed", true)
    end,
    GOODS_MAIL_INBOX_ITEM_TAKEN = function(index)
      if window:IsVisible() == false then
        return
      end
      local wnd = window.readWindow
      if wnd:IsVisible() == false then
      else
        wnd:Show(false)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    goodsMailEvents[event](...)
  end)
  RegistUIEvent(window, goodsMailEvents)
end
function SetViewOfGoodsMailList(window)
  local frame = CreatePageListCtrl(window, "goodMailList", 0)
  frame:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  frame:AddAnchor("BOTTOMRIGHT", window, -sideMargin, bottomMargin + 10)
  frame:SetUseDoubleClick(true)
  function frame:CheckProc_DeleteButton()
    GetMailDeleteButton():Enable(window:GetSelctedCheckBoxs())
  end
  local CategoryLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    local typeDrawable = subItem:CreateDrawable(TEXTURE_PATH.COMMERCIAL_MAIL, "icon_purch", "background")
    typeDrawable:SetVisible(false)
    typeDrawable:AddAnchor("CENTER", subItem, 0, 0)
    subItem.typeDrawable = typeDrawable
  end
  local TitleLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem:Show(true)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(10, 0, 10, 0)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    subItem:SetLimitWidth(true)
  end
  local DateLayoutFunc = function(frame, rowIndex, colIndex, subItem)
    subItem.style:SetAlign(ALIGN_CENTER)
    subItem.style:SetSnap(true)
    ApplyTextColor(subItem, FONT_COLOR.BLUE)
  end
  local CategoryDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem.typeDrawable:SetVisible(true)
      local coords
      if data[COMERCIAL_MAIL_COL.MAIL_TYPE] == COMERCIAL_MAIL_TYPE.MAIL_CHARGED then
        if data[COMERCIAL_MAIL_COL.GIFT] then
          coords = "icon_gift"
        else
          coords = "icon_purch"
        end
      elseif data[COMERCIAL_MAIL_COL.MAIL_TYPE] == COMERCIAL_MAIL_TYPE.MAIL_PROMOTION then
        coords = "icon_event"
      end
      subItem.typeDrawable:SetTextureInfo(coords)
    else
      subItem.typeDrawable:SetVisible(false)
    end
  end
  local TitleDataFunc = function(subItem, data, setValue)
    if setValue then
      if data[COMERCIAL_MAIL_COL.ISREAD] then
        ApplyTextColor(subItem, FONT_COLOR.GRAY)
      else
        ApplyTextColor(subItem, FONT_COLOR.BLUE)
      end
      if data[COMERCIAL_MAIL_COL.TITLE] ~= nil then
        subItem:SetText(data[COMERCIAL_MAIL_COL.TITLE])
      end
    else
      subItem:SetText("")
    end
  end
  local DateDataFunc = function(subItem, data, setValue, sortMode)
    mailBoxLocale.comercialMail:DateDataFunc(subItem, data, setValue, sortMode)
  end
  local colWidth = FORM_MAILBOX.COMMERCIAL_MAIL.COLUMN_WIDTH
  frame:InsertColumn(locale.comercialMail.goodsCategory, colWidth[1], LCCIT_WINDOW, CategoryDataFunc, nil, nil, CategoryLayoutFunc)
  frame:InsertColumn(locale.comercialMail.goodsTitle, colWidth[2], LCCIT_STRING, TitleDataFunc, nil, nil, TitleLayoutFunc)
  frame:InsertColumn(locale.comercialMail.goodsRemain, colWidth[3], LCCIT_STRING, DateDataFunc, nil, nil, DateLayoutFunc)
  frame:InsertRows(PAGE_PER_MAIL_MAX_COUNT, false)
  DrawListCtrlUnderLine(frame.listCtrl)
  frame.listCtrl:UseOverClickTexture()
  for i = 1, #frame.listCtrl.column do
    frame.listCtrl.column[i]:Enable(false)
    SettingListColumn(frame.listCtrl, frame.listCtrl.column[i])
    frame.listCtrl.column[i].style:SetAlign(ALIGN_CENTER)
    DrawListCtrlColumnSperatorLine(frame.listCtrl.column[i], #frame.listCtrl.column, i)
  end
  return frame
end
function CreateGoodsMailList(window)
  SetViewOfGoodsMailList(window)
  function window:GetEnabledCheckBoxs()
    return false
  end
  function window:GetVisibleCheckCount()
    return 0
  end
  function window:GetSelctedCheckBoxs()
    return false
  end
  function window:GetSelectedMailIds()
    local selectedMailIds = {}
    return selectedMailIds
  end
end
