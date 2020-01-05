local lastSearchArticle
function CreateAuctionBidFrame(window)
  SetViewOfAuctionBidFrame(window)
  local conditionInitButton = window.searchFrame.conditionInitButton
  local minHeirButton = window.searchFrame.minHeirButton
  local maxHeirButton = window.searchFrame.maxHeirButton
  local searchButton = window.searchFrame.searchButton
  local nameEditbox = window.searchFrame.nameEditbox
  local gradeComboBoxButton = window.searchFrame.gradeComboBoxButton
  local minLevelEdit = window.searchFrame.minLevelEdit
  local maxLevelEdit = window.searchFrame.maxLevelEdit
  local matchWordTextbox
  if auctionLocale.viewMatchWordBox then
    matchWordTextbox = window.searchFrame.matchWordTextbox
  end
  local showDirectPriceRangeButton = window.searchFrame.showDirectPriceRangeButton
  local directPriceRangeLabel = window.searchFrame.directPriceRangeLabel
  local minDirectPriceEdit = window.searchFrame.minDirectPriceWindow.goldEdit
  local tildeLabel2 = window.searchFrame.tildeLabel2
  local maxDirectPriceEdit = window.searchFrame.maxDirectPriceWindow.goldEdit
  local categoryFrame = window.categoryFrame
  local listCtrl = window.listCtrl
  local pageControl = window.pageControl
  local refreshButton = window.refreshButton
  local availableMoney = window.availableMoney
  local availableAAPoint = window.availableAAPoint
  local moneyEditsWindow = window.moneyEditsWindow
  local bidButton = window.bidButton
  local directButton = window.directButton
  local function EnableMarketPriceBtn(enable)
    if window.marketPriceBtn == nil then
      return
    end
    window.marketPriceBtn:Enable(enable)
  end
  local function SetMarketPriceBtn(itemType, itemGrade)
    if window.marketPriceBtn == nil then
      return
    end
    if itemType == nil then
      window.marketPriceBtn:InitMarketPrice()
    end
    window.marketPriceBtn:SetMarketPrice(itemType, itemGrade)
  end
  function window:EnableSearch(enable)
    nameEditbox:Enable(enable)
    pageControl:Enable(enable, true)
    if searchCoolTime == nil then
      refreshButton:Enable(enable)
      searchButton:Enable(enable)
      EnableMarketPriceBtn(enable)
    end
    local selIdx = listCtrl:GetSelectedIdx()
    if selIdx > 0 then
      bidButton:Enable(enable)
      directButton:Enable(enable)
      EnableMarketPriceBtn(enable)
      local bidPrice, directPrice = X2Auction:GetSearchedItemPrice(selIdx)
      if bidPrice == nil or directPrice == nil then
        return
      end
      if directPrice == "0" then
        directButton:Enable(false)
      end
    else
      bidButton:Enable(false)
      directButton:Enable(false)
      EnableMarketPriceBtn(false)
    end
  end
  local function GetItemCategoryValue()
    local itemCategory = categoryFrame:GetSelectedValue()
    if itemCategory == -1 or itemCategory == nil then
      itemCategory = 0
    end
    return itemCategory
  end
  local function GetMinMaxLevel()
    local minLevel = tonumber(minLevelEdit:GetText())
    local maxLevel = tonumber(maxLevelEdit:GetText())
    if minLevel == 0 and maxLevel == 0 then
      minLevelEdit:SetText("")
      maxLevelEdit:SetText("")
      return nil, nil
    end
    if minLevel == MIN_MAX_LEVEL_INIT_VAL or minLevel == nil then
      minLevel = 0
      minLevelEdit:SetText("")
    end
    if maxLevel == MIN_MAX_LEVEL_INIT_VAL or maxLevel == nil then
      maxLevel = 0
      maxLevelEdit:SetText("")
    end
    local levelLimit = X2Player:GetFeatureSet().levelLimit
    if minHeirButton.active then
      minLevel = minLevel + X2Player:GetMinHeirLevel()
    elseif levelLimit < minLevel then
      minLevel = levelLimit
    end
    if maxHeirButton.active then
      maxLevel = maxLevel + X2Player:GetMinHeirLevel()
    elseif levelLimit < maxLevel then
      maxLevel = levelLimit
    end
    return minLevel, maxLevel
  end
  local function GetItemGrade()
    local itemGrade = gradeComboBoxButton:GetSelectedIndex()
    if itemGrade > 1 then
      itemGrade = itemGrade + 1
    end
    return itemGrade
  end
  local function GetMinMaxDirectPriceStr()
    local minDirectPriceStr = window.searchFrame.minDirectPriceWindow:GetAmountStr()
    local maxDirectPriceStr = window.searchFrame.maxDirectPriceWindow:GetAmountStr()
    return minDirectPriceStr, maxDirectPriceStr
  end
  function window:SearchItem(page)
    if IsSearchCoolTime() then
      UIParent:LogAlways(string.format("[LOG] auction search failed : remain cooltime"))
      return
    end
    if page == nil then
      page = 1
    else
      pageControl:SetCurrentPage(page, false)
    end
    local minLevel, maxLevel = GetMinMaxLevel()
    if minLevel == nil and maxLevel == nil then
      RefreshItemList(self, true)
      UIParent:LogAlways(string.format("[LOG] auction search failed : invalid level"))
      return
    end
    local itemCategory = GetItemCategoryValue()
    local itemGrade = GetItemGrade()
    local isMatchWord = false
    if auctionLocale.viewMatchWordBox then
      isMatchWord = matchWordTextbox:GetChecked()
    end
    local itemName = nameEditbox.selector:GetText()
    if minLevel == nil then
      UIParent:LogAlways(string.format("[LOG] auction search failed : invalid min level"))
      return
    end
    if itemCategory == 11 then
      X2Auction:SearchDeclareSiege(page)
      SetSearchCoolTime()
      UIParent:LogAlways(string.format("[LOG] auction search : item category 11"))
      return
    end
    local minDirectPriceStr, maxDirectPriceStr = GetMinMaxDirectPriceStr()
    if lastSearchArticle == nil then
      lastSearchArticle = {}
    end
    lastSearchArticle.page = page
    lastSearchArticle.minLevel = minLevel
    lastSearchArticle.maxLevel = maxLevel
    lastSearchArticle.itemGrade = itemGrade
    lastSearchArticle.itemCategory = itemCategory
    lastSearchArticle.isMatchWord = isMatchWord
    lastSearchArticle.itemName = itemName
    lastSearchArticle.minDirectPriceStr = minDirectPriceStr
    lastSearchArticle.maxDirectPriceStr = maxDirectPriceStr
    UIParent:LogAlways(string.format("[LOG] search by normal way.. page[%d] itemName[%s]", page, tostring(itemName)))
    X2Auction:SearchAuctionArticle(page, minLevel, maxLevel, itemGrade, itemCategory, isMatchWord, itemName, minDirectPriceStr, maxDirectPriceStr)
    SetSearchCoolTime()
  end
  function window:Init()
    nameEditbox:SetText("")
    gradeComboBoxButton:Select(1)
    availableMoney:Update(X2Util:GetMyMoneyString(), false)
    availableAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString(), false)
    listCtrl:DeleteAllDatas()
    listCtrl:ClearSelection()
    moneyEditsWindow:SetAmountStr("0")
    bidButton:Enable(false)
    directButton:Enable(false)
    EnableMarketPriceBtn(false)
    pageControl:Init()
    self:Show(false)
    minHeirButton.active = false
    maxHeirButton.active = false
    ApplyButtonSkin(minHeirButton, BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
    ApplyButtonSkin(maxHeirButton, BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
    X2Auction:ClearSearchCondition()
  end
  function window:OnShow()
    X2Auction:SetCurTab(0)
    UIParent:LogAlways(string.format("[LOG] OnShow bid tab(0)"))
    moneyEditsWindow:SetAmountStr("0")
    if lastSearchArticle ~= nil then
      UIParent:LogAlways(string.format("[LOG] search by last search info.. page[%d] itemName[%s]", lastSearchArticle.page, tostring(lastSearchArticle.itemName)))
      X2Auction:SearchAuctionArticle(lastSearchArticle.page, lastSearchArticle.minLevel, lastSearchArticle.maxLevel, lastSearchArticle.itemGrade, lastSearchArticle.itemCategory, lastSearchArticle.isMatchWord, lastSearchArticle.itemName, lastSearchArticle.minDirectPriceStr, lastSearchArticle.maxDirectPriceStr)
    end
    self:EnableSearch(true)
    SetSearchCoolTime()
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:ClearLastSearchArticle()
    lastSearchArticle = nil
  end
  function window:SetLastSearchArticlePage(page)
    lastSearchArticle.page = page
  end
  function listCtrl:OnSelChanged(selIdx, doubleClick)
    local itemInfo = X2Auction:GetSearchedItemInfo(selIdx)
    if selIdx > 0 then
      bidButton:Enable(true)
      directButton:Enable(true)
      EnableMarketPriceBtn(true)
      SetMarketPriceBtn(itemInfo.itemType, itemInfo.itemGrade)
    else
      bidButton:Enable(false)
      directButton:Enable(false)
      SetMarketPriceBtn()
      EnableMarketPriceBtn(false)
    end
    local bidPrice, directPrice = X2Auction:GetSearchedItemPrice(selIdx)
    if bidPrice == nil or directPrice == nil then
      return
    end
    if IsPartitionAuctionItem(itemInfo) then
      bidButton:Enable(false)
    end
    if directPrice == "0" then
      directButton:Enable(false)
    end
    local DEFAULT_BID_AMOUNT_DIFF = "10"
    local newPriceStr = X2Util:StrNumericAdd(bidPrice, DEFAULT_BID_AMOUNT_DIFF)
    moneyEditsWindow:SetAmountStr(newPriceStr)
    MakeItemLink(selIdx, self)
    if doubleClick then
      directButtonOnClick(window, "LeftButton")
    end
  end
  listCtrl:SetHandler("OnSelChanged", listCtrl.OnSelChanged)
  function searchButton:OnClick()
    window:ShowFirstGuide(false)
    window:SearchItem()
    nameEditbox:HideDropdown()
  end
  searchButton:SetHandler("OnClick", searchButton.OnClick)
  nameEditbox.selector:SetHandler("OnEnterPressed", searchButton.OnClick)
  function bidButton:OnClick(MBT)
    bidButtonOnClick(window, MBT)
  end
  bidButton:SetHandler("OnClick", bidButton.OnClick)
  function directButton:OnClick(MBT)
    directButtonOnClick(window, MBT)
  end
  directButton:SetHandler("OnClick", directButton.OnClick)
  local function ConditionInitButtonLeftClickFunc()
    nameEditbox:Reset()
    gradeComboBoxButton:Select(1)
    minLevelEdit:SetText("")
    maxLevelEdit:SetText("")
    if auctionLocale.viewMatchWordBox then
      matchWordTextbox:SetChecked(false)
    end
    minDirectPriceEdit:SetText("")
    maxDirectPriceEdit:SetText("")
    window.categoryFrame:ClearAllSelected()
    minHeirButton.active = false
    maxHeirButton.active = false
    ApplyButtonSkin(minHeirButton, BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
    ApplyButtonSkin(maxHeirButton, BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
  end
  ButtonOnClickHandler(conditionInitButton, ConditionInitButtonLeftClickFunc)
  local RefreshButtonLeftButtonClickFunc = function()
    X2Auction:SearchRefresh()
    SetSearchCoolTime()
  end
  ButtonOnClickHandler(refreshButton, RefreshButtonLeftButtonClickFunc)
  local function ShowDirectPriceRangeButtonLeftButtonClickFunc()
    local show = not directPriceRangeLabel:IsVisible()
    directPriceRangeLabel:Show(show)
    minDirectPriceEdit:Show(show)
    tildeLabel2:Show(show)
    maxDirectPriceEdit:Show(show)
    if show then
      ApplyButtonSkin(showDirectPriceRangeButton, BUTTON_BASIC.MINUS)
    else
      ApplyButtonSkin(showDirectPriceRangeButton, BUTTON_BASIC.PLUS)
    end
    X2Auction:SetShowDirectPriceRangeEdit(show)
  end
  ButtonOnClickHandler(showDirectPriceRangeButton, ShowDirectPriceRangeButtonLeftButtonClickFunc)
  local OnEnter = function(self)
    SetTooltip(GetCommonText("auction_search_direct_price"), self)
  end
  showDirectPriceRangeButton:SetHandler("OnEnter", OnEnter)
  local OnLeave = function(self)
    HideTooltip()
  end
  showDirectPriceRangeButton:SetHandler("OnLeave", OnLeave)
  local SearchLevelTextChanged = function(active, edit)
    local levelLimit = X2Player:GetFeatureSet().levelLimit
    local level = tonumber(edit:GetText())
    if level == MIN_MAX_LEVEL_INIT_VAL or level == nil then
      edit:ClearString()
      return
    end
    if active == true then
      levelLimit = X2Player:GetMaxHeirLevel()
    end
    if level > levelLimit then
      edit:SetText(tostring(levelLimit))
    end
  end
  local function MinLevelEditTextChanged(self)
    SearchLevelTextChanged(minHeirButton.active, self)
  end
  minLevelEdit:SetHandler("OnTextChanged", MinLevelEditTextChanged)
  local function MaxLevelEditTextChanged(self)
    SearchLevelTextChanged(maxHeirButton.active, self)
  end
  maxLevelEdit:SetHandler("OnTextChanged", MaxLevelEditTextChanged)
  local HeirButtonOnEnter = function(self)
    if self.active == true then
      return
    end
    SetTooltip(locale.auction.heirLevelSearchTooltip, self)
  end
  minHeirButton:SetHandler("OnEnter", HeirButtonOnEnter)
  maxHeirButton:SetHandler("OnEnter", HeirButtonOnEnter)
  local function MinHeirButtonLeftClickFunc()
    minHeirButton.active = not minHeirButton.active
    if minHeirButton.active == true and maxHeirButton.active == false then
      maxHeirButton.active = true
    end
    ApplyButtonSkin(minHeirButton, minHeirButton.active == true and BUTTON_BASIC.AUCTION_SEARCH_HEIR_ON or BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
    ApplyButtonSkin(maxHeirButton, maxHeirButton.active == true and BUTTON_BASIC.AUCTION_SEARCH_HEIR_ON or BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
    SearchLevelTextChanged(minHeirButton.active, minLevelEdit)
    SearchLevelTextChanged(maxHeirButton.active, maxLevelEdit)
    if minHeirButton.active == true then
      HideTooltip()
    end
  end
  ButtonOnClickHandler(minHeirButton, MinHeirButtonLeftClickFunc)
  local function MaxHeirButtonLeftClickFunc()
    maxHeirButton.active = not maxHeirButton.active
    ApplyButtonSkin(maxHeirButton, maxHeirButton.active == true and BUTTON_BASIC.AUCTION_SEARCH_HEIR_ON or BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
    SearchLevelTextChanged(maxHeirButton.active, maxLevelEdit)
    if maxHeirButton.active == true then
      HideTooltip()
    end
  end
  ButtonOnClickHandler(maxHeirButton, MaxHeirButtonLeftClickFunc)
end
