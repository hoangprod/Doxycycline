local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local FromInGameShop = function(sender)
  if string.byte(sender, 1) ~= 46 then
    return false
  end
  local code = "return locale.mail" .. sender .. ".fromInGameShop"
  local f = loadstring(code)
  if f == nil then
    return false
  end
  local found
  pcall(function()
    found = f()
  end)
  if found == nil then
    return false
  end
  return found
end
function SetViewOfReadGoodsMailWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(430, 505)
  window:SetTitle(locale.mail.commercial_read_mail_title)
  window:SetSounds("mail_read")
  CreateComercialMailUpperFrame(window)
  local mailType_texture = window:CreateDrawable(TEXTURE_PATH.COMMERCIAL_MAIL, "icon_purch", "overlay")
  mailType_texture:SetVisible(true)
  mailType_texture:AddAnchor("LEFT", window.titleLabel, "RIGHT", 0, 1)
  window.mailType_texture = mailType_texture
  local yOffset = 100
  local groupping = window:CreateChildWidget("emptywidget", "groupping", 0, true)
  groupping:SetExtent(ICON_SIZE.DEFAULT * MAX_COMERCIAL_ATTACHMENT_COUNT, ICON_SIZE.DEFAULT * 2)
  groupping:AddAnchor("TOP", window, 0, 150)
  window.itemSlots = {}
  for i = 1, MAX_COMERCIAL_ATTACHMENT_COUNT do
    local itemSlot = CreateItemIconButton(window:GetId() .. ".itemSlot" .. i, window)
    itemSlot:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    if i <= MAX_COMERCIAL_ATTACHMENT_COUNT / 2 then
      itemSlot:AddAnchor("TOPLEFT", groupping, (i - 1) * ICON_SIZE.DEFAULT, 0)
    else
      itemSlot:AddAnchor("TOPLEFT", groupping, (i - 1 - MAX_COMERCIAL_ATTACHMENT_COUNT / 2) * ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    end
    window.itemSlots[i] = itemSlot
  end
  local content = W_CTRL.CreateMultiLineEdit("content", window)
  content.bg:Show(false)
  content:SetExtent(400, 160)
  content:AddAnchor("TOP", groupping, "BOTTOM", 0, 0)
  content:SetMaxTextLength(300)
  content.style:SetColor(0, 0, 0, 1)
  content:SetReadOnly(true)
  content:SetInset(sideMargin, sideMargin, 30, sideMargin)
  local buttonSetWindow = window:CreateChildWidget("window", "buttonSetWindow", 0, true)
  buttonSetWindow:Show(true)
  buttonSetWindow:SetExtent(293, BUTTON_SIZE.DEFAULT_SMALL.HEIGHT)
  buttonSetWindow:AddAnchor("BOTTOM", window, 0, -sideMargin)
  local receiveButton = window:CreateChildWidget("button", "receiveButton", 0, true)
  receiveButton:Enable(false)
  receiveButton:AddAnchor("CENTER", buttonSetWindow, 0, 0)
  receiveButton:SetText(locale.comercialMail.btnGoodsReceive)
  ApplyButtonSkin(receiveButton, BUTTON_BASIC.DEFAULT)
  local refundDate = window:CreateChildWidget("textbox", "refundDate", 0, true)
  refundDate:Show(baselibLocale.visibleRefundInfo)
  refundDate:SetExtent(content:GetWidth() - sideMargin * 2, 80)
  refundDate:AddAnchor("BOTTOM", window.decoBg, 0, -sideMargin - 10)
  refundDate.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
  refundDate.style:SetAlign(ALIGN_TOP)
  local warringSiteText = window:CreateChildWidget("textbox", "warringSiteText", 0, true)
  warringSiteText:SetExtent(content:GetWidth() - sideMargin * 2, FONT_SIZE.MIDDLE)
  warringSiteText.style:SetAlign(ALIGN_CENTER)
  warringSiteText:AddAnchor("TOP", refundDate, "BOTTOM", 0, 5)
  ApplyTextColor(warringSiteText, FONT_COLOR.DEFAULT)
  warringSiteText:SetText(GetUIText(COMMON_TEXT, "goods_mail_warring_msg"))
  warringSiteText:SetUnderLine(true)
  warringSiteText:SetLineColor(FONT_COLOR.DEFAULT[1], FONT_COLOR.DEFAULT[2], FONT_COLOR.DEFAULT[3], FONT_COLOR.DEFAULT[4])
  warringSiteText:Show(baselibLocale.visibleRefundInfo)
  local textButton = CreateEmptyButton("textButton", window)
  textButton:AddAnchor("TOPLEFT", warringSiteText, 0, 0)
  textButton:AddAnchor("BOTTOMRIGHT", warringSiteText, 0, 0)
  textButton:Show(baselibLocale.visibleRefundInfo)
  local TextButtonOnClick = function()
    X2GoodsMail:OpenGoodMailWarringSite()
  end
  textButton:SetHandler("OnClick", TextButtonOnClick)
  function window:VisibleWarringSiteText(visible)
    if baselibLocale.visibleRefundInfo == true then
      warringSiteText:Show(visible)
      textButton:Show(visible)
    end
  end
  return window
end
function CreateReadGoodsMailWindow(id, parent)
  local window = SetViewOfReadGoodsMailWindow(id, parent)
  local content = window.content
  local refundDate = window.refundDate
  local receiveButton = window.receiveButton
  local DATE_FORMAT_FILTER1 = FORMAT_FILTER.YEAR + FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY
  local DATE_FORMAT_FILTER2 = FORMAT_FILTER.MONTH + FORMAT_FILTER.DAY
  function receiveButton:OnClick(arg)
    if arg == "LeftButton" then
      if X2GoodsMail:GetCurrentMailItemCount() == 0 then
        return
      end
      local function DialogHandler(wnd, infoTable)
        local itemInfo = X2GoodsMail:GetCurrentMailItem(1)
        local content = ""
        if window.mail_type == COMERCIAL_MAIL_TYPE.MAIL_CHARGED then
          local what = itemInfo.name
          if FromInGameShop(window.sender) == true then
            what = window.titleLimitLabel:GetText()
          end
          if not window.is_gift and window.is_refund and window.priceType == PRICE_TYPE_AA_CASH then
            content = locale.comercialMail.GetReceiveMsgContent(what)
          else
            content = locale.comercialMail.GetReceiveFreeItemMsgContent(what)
          end
        elseif window.mail_type == COMERCIAL_MAIL_TYPE.MAIL_PROMOTION then
          content = locale.comercialMail.GetReceiveFreeItemMsgContent(itemInfo.name)
        end
        wnd:SetTitle(locale.comercialMail.receiveMsgTitle)
        wnd:SetContent(content)
        function wnd:OkProc()
          X2GoodsMail:TakeAllCurrentMailItem()
          window:Show(false)
          F_SOUND.PlayUISound("event_trade_item_recv")
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetId())
    end
  end
  receiveButton:SetHandler("OnClick", receiveButton.OnClick)
  function window:Clear()
    for i = 1, MAX_COMERCIAL_ATTACHMENT_COUNT do
      self.itemSlots[i]:Init()
    end
    self.date:SetText("")
    self.roleEdit:SetText("")
    self.titleLimitLabel:SetText("")
    content:SetText("")
  end
  function window:FillContents()
    local bodyInfo = X2GoodsMail:GetCurrentMailBody()
    self.date:SetText(baselibLocale:GetDefaultDateString(bodyInfo.recvDate.year, bodyInfo.recvDate.month, bodyInfo.recvDate.day))
    local sender = bodyInfo.sender
    self.mailId = bodyInfo.mail_id
    self.sender = sender
    self.roleEdit:SetText(GetMailText(sender, "sender"))
    self.titleLimitLabel:SetText(GetMailText(sender, bodyInfo.title))
    local bodyText = X2Util:ErasePipeArgsFromText(bodyInfo.text)
    local bodyTextInfo = GetMailText(sender, bodyText)
    if type(bodyTextInfo) ~= "table" then
      content:SetText(bodyTextInfo)
    else
      content:SetText(bodyTextInfo.content)
    end
    local parseInfo = ParsePipeArgFromBody(bodyInfo)
    local enableRefund = GetEnableRefund(parseInfo.refund, parseInfo.limit_file_time)
    local str = ""
    str = GetCustomRefundMsg(parseInfo.gift, enableRefund, bodyTextInfo.priceType)
    if str == nil and enableRefund then
      str = MakeRefundLimitStrForBody(parseInfo.refund, parseInfo.limit_file_time)
    end
    if enableRefund then
      ApplyTextColor(refundDate, FONT_COLOR.BLUE)
    else
      ApplyTextColor(refundDate, FONT_COLOR.RED)
    end
    refundDate:SetText(str)
    refundDate:SetHeight(refundDate:GetTextHeight())
    window:VisibleWarringSiteText(str ~= "" and enableRefund == true)
    self.mail_type = bodyInfo.mail_type
    self.is_gift = parseInfo.gift
    self.is_refund = enableRefund
    self.priceType = bodyTextInfo.priceType
    local coords
    if bodyInfo.mail_type == COMERCIAL_MAIL_TYPE.MAIL_CHARGED then
      if parseInfo.gift then
        coords = "icon_gift"
      else
        coords = "icon_purch"
      end
    elseif bodyInfo.mail_type == COMERCIAL_MAIL_TYPE.MAIL_PROMOTION then
      coords = "icon_event"
    end
    self.mailType_texture:SetTextureInfo(coords)
    self.titleLimitLabel:SetInset(self.mailType_texture:GetWidth() + 5, 0, 0, 0)
  end
  function window:FillAttachItems()
    local count = X2GoodsMail:GetCurrentMailAttachedItemCount()
    if count == 0 then
      for i = 1, MAX_COMERCIAL_ATTACHMENT_COUNT do
        self.itemSlots[i]:Show(false)
        self.itemSlots[i]:Enable(false)
      end
      self.receiveButton:Enable(false)
      return
    end
    local countPerRow = MAX_COMERCIAL_ATTACHMENT_COUNT / 2
    local row = 1
    if count > countPerRow then
      row = 2
    end
    local col = math.min(countPerRow, count)
    self.groupping:SetExtent(col * ICON_SIZE.DEFAULT, row * ICON_SIZE.DEFAULT)
    for i = 1, MAX_COMERCIAL_ATTACHMENT_COUNT do
      local itemSlot = self.itemSlots[i]
      local mailItemInfo
      if count >= i then
        mailItemInfo = X2GoodsMail:GetCurrentMailItem(i)
      end
      if mailItemInfo ~= nil then
        local stackCount = GetItemStackCount(mailItemInfo)
        itemSlot:SetItemInfo(mailItemInfo)
        itemSlot:Show(true)
        itemSlot:Enable(true)
        itemSlot:SetStack(tostring(stackCount))
      else
        itemSlot:Show(false)
        itemSlot:Enable(false)
      end
    end
    self.receiveButton:Enable(true)
  end
  function window:FillReceivedMailInfo()
    self:Clear()
    self:FillContents()
    self:FillAttachItems()
  end
  function window:OnHide()
    self:Clear()
    X2GoodsMail:ClearCurrentMail()
  end
  window:SetHandler("OnHide", window.OnHide)
  return window
end
