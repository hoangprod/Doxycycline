local putupItemList
function CreateAuctionPutupFrame(window)
  SetViewOfAuctionPutupFrame(window)
  local putupItemFrame = window.putupItemFrame
  local timeCheckBoxes = putupItemFrame.timeCheckBoxes
  local itemButton = putupItemFrame.itemButton
  local itemNameLabel = putupItemFrame.itemNameLabel
  local startPriceEditsWindow = putupItemFrame.startPriceEditsWindow
  local directPriceEditsWindow = putupItemFrame.directPriceEditsWindow
  local directBundlePrice = putupItemFrame.directBundlePrice
  local directBundleAmountLabel = putupItemFrame.directBundleAmountLabel
  local lowestPrice = putupItemFrame.lowestPrice
  local putupButton = putupItemFrame.putupButton
  local deposit = putupItemFrame.deposit
  local depositMoney = putupItemFrame.depositMoney
  local chargeText = putupItemFrame.chargeText
  local chargePrice = putupItemFrame.chargePrice
  local chargeDisPrice = putupItemFrame.chargeDisPrice
  local listCtrl = window.listCtrl
  local pageControl = window.pageControl
  local refreshButton = window.refreshButton
  local availableMoney = window.availableMoney
  local availableAAPoint = window.availableAAPoint
  local cancelBidButton = window.cancelBidButton
  local leftMarketPriceBtn = putupItemFrame.marketPriceBtn
  local rightMarketPriceBtn = window.rightMarketPriceBtn
  local postTypeButton = putupItemFrame.postTypeButton
  local minStackCountButtons = putupItemFrame.minStackCountButtons
  local spinner = putupItemFrame.spinner
  local depositGuide = putupItemFrame.depositGuide
  local chargeGuide = putupItemFrame.chargeGuide
  local EnableMarketPriceBtn = function(button, enable)
    if button == nil then
      return
    end
    button:Enable(enable)
  end
  local function SetMarketPriceBtn(button, itemType, itemGrade)
    if button == nil then
      return
    end
    if itemType == nil then
      button:InitMarketPrice()
      EnableMarketPriceBtn(button, false)
    end
    button:SetMarketPrice(itemType, itemGrade)
    EnableMarketPriceBtn(button, true)
  end
  window.attachedItemStackCnt = 0
  window.attachedItemType = 0
  window.attachedItemGrade = 0
  function window:EnableSearch(enable)
    pageControl:Enable(enable, true)
    EnableMarketPriceBtn(rightMarketPriceBtn, listCtrl:GetSelectedIdx() > 0)
  end
  local function OnEnter(self)
    if self:IsEnabled() then
      SetTooltip(locale.auction.bidSuccesfullyCommission, self)
    elseif depositMoney:IsVisible() then
      SetTooltip(locale.auction.lowDirectPrice, self)
    end
  end
  putupButton:SetHandler("OnEnter", OnEnter)
  local function SetPostTypeMode(postType)
    if X2Player:GetFeatureSet().auctionPartialBuy == false then
      postType = PT_BID
    end
    local postTypeLabel = putupItemFrame.postTypeLabel
    local postTypeFrame = putupItemFrame.postTypeFrame
    if postType == PT_BID then
      X2Auction:SetPostType(PT_BID)
      postTypeFrame[1]:Show(true)
      postTypeFrame[2]:Show(false)
      postTypeLabel:SetText(locale.auction.startPrice)
    else
      X2Auction:SetPostType(PT_PARTITION)
      postTypeFrame[1]:Show(false)
      postTypeFrame[2]:Show(true)
      postTypeLabel:SetText(locale.auction.sellPartition)
      local attachItem = X2Auction:GetAttachedItemInfo()
      if attachItem == nil then
        spinner:SetMinMaxValues(0, 0)
        spinner:SetValue(0)
      else
        spinner:SetMinMaxValues(1, GetItemStackCount(attachItem))
        spinner:SetValue(1)
      end
    end
    window:CalcDeposit()
  end
  for i = 1, #minStackCountButtons do
    do
      local function MinStackLeftClickFunc()
        local stackCount = PartitionStack[i]
        local spinnerNum = tonumber(spinner:GetValue())
        if spinnerNum ~= nil and spinnerNum ~= 1 then
          stackCount = spinnerNum + PartitionStack[i]
        end
        spinner:SetValue(stackCount)
      end
      ButtonOnClickHandler(minStackCountButtons[i], MinStackLeftClickFunc)
    end
  end
  function window:Init()
    itemButton:Init()
    timeCheckBoxes:Check(1)
    itemNameLabel:SetText("")
    availableMoney:Update(X2Util:GetMyMoneyString(), false)
    availableAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString(), false)
    startPriceEditsWindow:SetAmountStr("0")
    directPriceEditsWindow:SetAmountStr("0")
    directPriceEditsWindow:SetCurrencyAmountLimit(directPriceEditsWindow:GetSystemCurrencyAmountLimit())
    directBundlePrice:Update(0)
    directBundleAmountLabel:Update("-")
    window.attachedItemStackCnt = 0
    window.attachedItemType = 0
    window.attachedItemGrade = 0
    listCtrl:ClearSelection()
    listCtrl:DeleteAllDatas()
    cancelBidButton:Enable(false)
    EnableMarketPriceBtn(rightMarketPriceBtn, false)
    EnableMarketPriceBtn(leftMarketPriceBtn, false)
    pageControl:Init()
    self:UpdateLowestPrice()
    X2Auction:ClearSearchCondition()
    SetPostTypeMode(X2Auction:GetPostType())
  end
  function window:AttachItem(attached)
    if attached == true then
      local itemInfo = X2Auction:GetAttachedItemInfo()
      if itemInfo ~= nil then
        local color = Hex2Dec(itemInfo.gradeColor)
        itemNameLabel.style:SetColor(color[1], color[2], color[3], color[4])
        itemNameLabel:SetText(itemInfo.name)
        local stackCount = GetItemStackCount(itemInfo)
        window.attachedItemStackCnt = stackCount
        window.attachedItemType = itemInfo.itemType
        window.attachedItemGrade = itemInfo.itemGrade
        itemButton:SetItemInfo(itemInfo)
        itemButton:SetStack(stackCount)
        if stackCount > 1 then
          SetPostTypeMode(PT_PARTITION)
          postTypeButton:Enable(true)
        else
          SetPostTypeMode(PT_BID)
          postTypeButton:Enable(false)
        end
        local costStr = X2Util:NumberToString(itemInfo.refund * (tonumber(stackCount) or itemInfo.stack))
        startPriceEditsWindow:SetAmountStr(costStr)
        startPriceEditsWindow.goldEdit:SetFocus()
        directPriceEditsWindow:SetAmountStr("0")
        X2Auction:SetPrice(costStr, "0")
        directPriceEditsWindow:SetCurrencyAmountLimit(X2Util:DivideNumberString(directPriceEditsWindow:GetSystemCurrencyAmountLimit(), tostring(stackCount)))
        directBundlePrice:Update(0)
        directBundleAmountLabel:Update(stackCount)
        depositGuide:Show(true)
        deposit:Show(true)
        depositMoney:Show(true)
        self:CalcDeposit()
        chargeGuide:Show(true)
        chargeText:Show(true)
        chargePrice:Show(true)
        self:CalcCharge()
        putupButton:Enable(true)
        self:FillAttachedItemPriceInfo(window.attachedItemType, window.attachedItemGrade, window.attachedItemStackCnt)
        self:UpdateLowestPrice()
        SetMarketPriceBtn(leftMarketPriceBtn, itemInfo.itemType, itemInfo.itemGrade)
      end
    else
      window.attachedItemStackCnt = 0
      window.attachedItemType = 0
      window.attachedItemGrade = 0
      itemButton:Init()
      itemNameLabel:SetText("")
      depositGuide:Show(false)
      deposit:Show(false)
      depositMoney:Show(false)
      chargeGuide:Show(false)
      chargeText:Show(false)
      chargePrice:Show(false)
      chargeDisPrice:Show(false)
      timeCheckBoxes:Check(1)
      putupButton:Enable(false)
      startPriceEditsWindow:SetAmountStr("0")
      directPriceEditsWindow:SetAmountStr("0")
      directPriceEditsWindow:SetCurrencyAmountLimit(directPriceEditsWindow:GetSystemCurrencyAmountLimit())
      directBundlePrice:Update(0)
      directBundleAmountLabel:Update("-")
      SetMarketPriceBtn(leftMarketPriceBtn)
      self:UpdateLowestPrice()
      SetPostTypeMode(PT_PARTITION)
    end
  end
  function window:CalcDeposit()
    local startPriceStr = startPriceEditsWindow:GetAmountStr()
    local directPriceStr = directBundlePrice.amount
    local duration = timeCheckBoxes:GetChecked()
    local depositPrice = X2Auction:CalcDeposit(startPriceStr, directPriceStr, duration)
    local str
    if F_MONEY.currency.auctionFee == CURRENCY_AA_POINT then
      str = string.format("|p%d;", depositPrice)
    else
      str = string.format("|m%d;", depositPrice)
    end
    depositMoney:SetText(str)
    local postType = X2Auction:GetPostType()
    if postType == PT_PARTITION then
      if X2Auction:GetAttachedItemInfo() == nil then
        putupButton:Enable(false)
      else
        putupButton:Enable(true)
      end
    elseif depositMoney:IsVisible() then
      if directPriceStr ~= "0" and X2Util:CompareMoneyString(startPriceStr, directPriceStr) > 0 then
        putupButton:Enable(false)
        EnableMarketPriceBtn(leftMarketPriceBtn, false)
      else
        putupButton:Enable(true)
        EnableMarketPriceBtn(leftMarketPriceBtn, true)
      end
    end
  end
  function window:CalcCharge()
    local chargePers = X2Auction:CalcCharge(window.attachedItemType)
    local chargePersModified = X2Auction:IsChargeChanged(window.attachedItemType)
    local chargeInfo = X2Auction:GetChargeInfo(window.attachedItemType)
    local priceStr
    local disPriceStr = ""
    if chargePersModified then
      priceStr = string.format("%s%s", FONT_COLOR_HEX.BLUE, chargePers)
    else
      priceStr = chargePers
    end
    chargeDisPrice:Show(false)
    chargePrice:SetStrikeThrough(false)
    if chargeInfo.auctionChargeDefault == false or chargeInfo.auctionServiceKind == ASK_PCBANG or chargeInfo.auctionServiceKind == ASK_ACCOUNT_BUFF then
      chargePrice:SetStrikeThrough(true)
      chargeDisPrice:Show(true)
      local lineColoe = FONT_COLOR.TITLE
      priceStr = chargeInfo.defaultRatio
      if chargePersModified then
        lineColoe = FONT_COLOR.BLUE
        disPriceStr = string.format("%s%s", FONT_COLOR_HEX.BLUE, chargePers)
      else
        disPriceStr = chargePers
      end
      chargePrice:SetLineColor(lineColoe[1], lineColoe[2], lineColoe[3], lineColoe[4])
    end
    chargePrice:SetText(priceStr)
    chargeDisPrice:SetText(disPriceStr)
  end
  function startPriceEditsWindow:MoneyEditProc()
    window:CalcDeposit()
  end
  function directPriceEditsWindow:MoneyEditProc()
    local each = directPriceEditsWindow:GetAmountStr()
    local cnt = window.attachedItemStackCnt
    local bundel = X2Util:MultiplyNumberString(tostring(each), tostring(cnt))
    directBundlePrice:Update(bundel)
    window:CalcDeposit()
  end
  function timeCheckBoxes:OnRadioChanged(index, dataValue)
    window:CalcDeposit()
  end
  timeCheckBoxes:SetHandler("OnRadioChanged", timeCheckBoxes.OnRadioChanged)
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    self:Enable(false, true)
    X2Auction:SearchMyAuctionArticles(pageIndex)
  end
  function window:OnShow()
    X2Auction:SetCurTab(1)
    UIParent:LogAlways(string.format("[LOG] OnShow putup tab(1)"))
    pageControl:Init()
    listCtrl:DeleteAllDatas()
    X2Auction:DetachItem(false)
    timeCheckBoxes:Check(1)
    X2Auction:SearchMyAuctionArticles(0)
    SetSearchCoolTime()
    EnableMarketPriceBtn(leftMarketPriceBtn, false)
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:OnHide()
    X2Auction:DetachItem(false)
  end
  window:SetHandler("OnHide", window.OnHide)
  function window:ClearPutupedItemList()
    if putupItemList == nil then
      return
    end
    while true do
      table.remove(putupItemList, #putupItemList)
      if #putupItemList == 0 then
        break
      end
    end
    putupItemList = nil
  end
  function window:GetPutupedItemList(itemType, itemGrade)
    if putupItemList == nil then
      return nil
    end
    for i = 1, #putupItemList do
      if putupItemList[i].itemType == itemType and putupItemList[i].itemGrade == itemGrade then
        return putupItemList[i]
      end
    end
    return nil
  end
  function window:SaveAttachedItemPriceInfo()
    if putupItemList == nil then
      putupItemList = {}
    end
    local itemInfo = self:GetPutupedItemList(window.attachedItemType, window.attachedItemGrade)
    if itemInfo == nil then
      itemInfo = {}
    end
    itemInfo.itemType = window.attachedItemType
    itemInfo.itemGrade = window.attachedItemGrade
    itemInfo.duration = timeCheckBoxes:GetChecked()
    itemInfo.stackCount = window.attachedItemStackCnt
    if itemInfo.stackCount == 0 then
      UIParent:LogAlways(string.format("[ERROR] SaveAttachedItemPriceInfo()... stackCount is 0 !!"))
      return
    end
    itemInfo.bidPrice = tonumber(startPriceEditsWindow:GetAmountStr()) / itemInfo.stackCount
    itemInfo.directPrice = tonumber(directPriceEditsWindow:GetAmountStr())
    table.insert(putupItemList, itemInfo)
  end
  function window:FillAttachedItemPriceInfo(itemType, itemGrade, nowStackCount)
    local itemInfo = self:GetPutupedItemList(itemType, itemGrade)
    if itemInfo == nil then
      return
    end
    startPriceEditsWindow:SetAmountStr(itemInfo.bidPrice * nowStackCount)
    directPriceEditsWindow:SetAmountStr(itemInfo.directPrice)
    timeCheckBoxes:Check(itemInfo.duration)
  end
  function window:UpdateLowestPrice()
    if window.attachedItemType == 0 then
      lowestPrice:SetPrice(nil, nil)
    else
      local price = X2Auction:GetLowestPrice(window.attachedItemType, window.attachedItemGrade)
      lowestPrice:SetPrice(window.attachedItemType, price)
    end
  end
  function directPriceEditsWindow:SetLowestPrice(price)
    local itemType = window.attachedItemType
    local itemGrade = window.attachedItemGrade
    local itemInfo = window:GetPutupedItemList(itemType, itemGrade)
    if itemInfo == nil then
      directPriceEditsWindow:SetAmountStr(price)
    end
  end
  function lowestPrice:SetPrice(itemType, price)
    if itemType == nil and price == nil then
      lowestPrice.style:SetAlign(ALIGN_CENTER)
      lowestPrice:SetText("-")
    elseif itemType == window.attachedItemType then
      if price == nil then
        lowestPrice.style:SetAlign(ALIGN_CENTER)
        lowestPrice:SetText(locale.auction.searching)
      elseif price == "0" then
        lowestPrice.style:SetAlign(ALIGN_CENTER)
        lowestPrice:SetText(locale.auction.no_lowest_price)
        directPriceEditsWindow:SetLowestPrice("0")
      else
        lowestPrice.style:SetAlign(ALIGN_RIGHT)
        lowestPrice:Update(price)
        directPriceEditsWindow:SetLowestPrice(price)
      end
    end
  end
  local itemButton = putupItemFrame.itemButton
  local ItemButtonLeftClickFunc = function()
    local exist = X2Auction:GetAttachedItemExist()
    if exist == true and X2Cursor:GetCursorPickedBagItemIndex() == 0 then
      X2Auction:DetachItem(true)
    else
      X2Auction:AttachItemFromPick()
    end
  end
  local ItemButtonRightClickFunc = function()
    local exist = X2Auction:GetAttachedItemExist()
    if exist == true and X2Cursor:GetCursorPickedBagItemIndex() == 0 then
      X2Auction:DetachItem(true)
    end
  end
  ButtonOnClickHandler(itemButton, ItemButtonLeftClickFunc, ItemButtonRightClickFunc)
  local function PutupButtonLeftButtonClickFunc()
    window:SaveAttachedItemPriceInfo()
    X2Auction:SetDuration(timeCheckBoxes:GetChecked())
    local bidPriceStr = startPriceEditsWindow:GetAmountStr()
    local directPriceStr = directBundlePrice.amount
    local minStack = 0
    local maxStack = 0
    if X2Auction:GetPostType() == PT_PARTITION then
      minStack = tonumber(spinner:GetValue())
      if minStack == nil then
        minStack = 0
      end
      maxStack = GetItemStackCount(X2Auction:GetAttachedItemInfo())
      X2Auction:SetPricePartition(directPriceStr, maxStack)
    else
      X2Auction:SetPrice(bidPriceStr, directPriceStr)
    end
    X2Auction:SetPartitionBuyMinMaxCount(minStack, maxStack)
    X2Auction:AskAuctionArticle()
  end
  ButtonOnClickHandler(putupButton, PutupButtonLeftButtonClickFunc)
  local function CancelBidButtonLeftButtonClickFunc()
    local selIdx = listCtrl:GetSelectedIdx()
    local articleId = X2Auction:GetSearchedItemArticleId(selIdx)
    local itemInfo = X2Auction:GetSearchedItemInfo(selIdx)
    if articleId == nil then
      return
    end
    listCtrl:ClearSelection()
    local function DialogHandler(wnd)
      wnd:SetTitle(locale.auction.cancelBid)
      wnd:UpdateDialogModule("textbox", GetUIText(AUCTION_TEXT, "ask_cancel_message"))
      local data = {
        itemInfo = itemInfo,
        stack = itemInfo.stackCount
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
      local data = {
        type = "cost",
        currency = F_MONEY.currency.auctionFee,
        value = itemInfo.depositStr
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
      function wnd:OkProc()
        X2Auction:CancelAuctionArticle(articleId)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, window:GetParent():GetParent():GetId())
  end
  ButtonOnClickHandler(cancelBidButton, CancelBidButtonLeftButtonClickFunc)
  function listCtrl:OnSelChanged(selIdx)
    if selIdx > 0 then
      local itemInfo = X2Auction:GetSearchedItemInfo(selIdx)
      local isEmptyBidder = itemInfo.bidState == BID_STATE.BS_NOBID
      cancelBidButton:Enable(isEmptyBidder)
      SetMarketPriceBtn(rightMarketPriceBtn, itemInfo.itemType, itemInfo.itemGrade)
    else
      cancelBidButton:Enable(false)
      SetMarketPriceBtn(rightMarketPriceBtn)
    end
  end
  listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
  local RefreshButtonLeftButtonClickFunc = function()
    X2Auction:SearchRefresh()
    SetSearchCoolTime()
  end
  ButtonOnClickHandler(refreshButton, RefreshButtonLeftButtonClickFunc)
  local function PostTypeLeftClickFunc()
    local postType = X2Auction:GetPostType()
    if postType == PT_BID then
      SetPostTypeMode(PT_PARTITION)
    else
      SetPostTypeMode(PT_BID)
    end
  end
  ButtonOnClickHandler(postTypeButton, PostTypeLeftClickFunc)
  local OnEnterPostTypeButton = function(self)
    SetTooltip(X2Locale:LocalizeUiText(AUCTION_TEXT, "partition_btn_tooltip"), self)
  end
  postTypeButton:SetHandler("OnEnter", OnEnterPostTypeButton)
  local function OnEnterDepositGuide()
    local depositRatioTexts = {}
    for i = 1, #putupItemFrame.timeTexts do
      depositRatioTexts[i] = locale.auction.depositTooltipRateByTime(putupItemFrame.timeTexts[i].text, tostring(X2Auction:GetDepositRatioValue(i)))
    end
    ShowTextTooltip(depositGuide, locale.auction.depositTooltipTitle, locale.auction.depositTooltipInfo(depositRatioTexts, locale.auction.depositTooltipMaxPrice(X2Auction:GetMaxDepositValue())))
  end
  depositGuide:SetHandler("OnEnter", OnEnterDepositGuide)
  local function OnEnterChargeGuide()
    local chargeInfo = X2Auction:GetChargeInfo(window.attachedItemType)
    local title = locale.auction.chargeTooltipTitle(tostring(chargeInfo.chargeRate)) .. "\n"
    local titleExplan = locale.auction.chargeTooltipTitleNormal
    if chargeInfo.auctionChargeDefault == false then
      titleExplan = locale.auction.chargeTooltipTitleItemCharge(tostring(chargeInfo.gapChargeToDefaultRate))
    elseif chargeInfo.auctionServiceKind == ASK_PCBANG then
      titleExplan = locale.auction.chargeTooltipTitlePcbang(tostring(chargeInfo.gapChargeToDefaultRate))
    elseif chargeInfo.auctionServiceKind == ASK_ACCOUNT_BUFF then
      titleExplan = locale.auction.chargeTooltipTitlePeriodBuff(tostring(chargeInfo.gapChargeToDefaultRate))
    end
    title = title .. locale.auction.chargeTooltipTitleExplan(titleExplan)
    ShowTextTooltip(chargeGuide, title, locale.auction.chargeTooltipInfo)
  end
  chargeGuide:SetHandler("OnEnter", OnEnterChargeGuide)
end
