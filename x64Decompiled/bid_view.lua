MIN_MAX_LEVEL_INIT_VAL = -1
local CreateSearchFrame = function(window)
  local frame = window:CreateChildWidget("emptywidget", "searchFrame", 0, true)
  local width, _ = window:GetExtent()
  frame:SetExtent(width, 25)
  frame:AddAnchor("TOPLEFT", window, 0, 15)
  local bg = CreateContentBackground(frame, "TYPE5", "brown_2")
  bg:AddAnchor("TOPLEFT", frame, 50, -8)
  bg:AddAnchor("BOTTOMRIGHT", frame, 10, 8)
  local function CreateSearchFrameLabel(strId, msg)
    local label = frame:CreateChildWidget("label", strId, 0, true)
    label:SetHeight(FONT_SIZE.MIDDLE)
    label:SetAutoResize(true)
    label:SetText(msg)
    ApplyTextColor(label, FONT_COLOR.TITLE)
    return label
  end
  local conditionInitButton = frame:CreateChildWidget("button", "conditionInitButton", 0, true)
  conditionInitButton:Show(true)
  conditionInitButton:AddAnchor("LEFT", frame, 5, 0)
  ApplyButtonSkin(conditionInitButton, BUTTON_STYLE.RESET_BIG)
  local OnEnterConditionInitButton = function(self)
    SetTooltip(locale.auction.searchConditionInit, self)
  end
  conditionInitButton:SetHandler("OnEnter", OnEnterConditionInitButton)
  local levelRangeLabel = CreateSearchFrameLabel("levelRangeLabel", locale.auction.levelRange)
  levelRangeLabel:AddAnchor("LEFT", conditionInitButton, "RIGHT", 8, 0)
  local minHeirButton = frame:CreateChildWidget("button", "minHeirButton", 0, true)
  minHeirButton:Show(true)
  minHeirButton:AddAnchor("LEFT", levelRangeLabel, "RIGHT", 5, 0)
  ApplyButtonSkin(minHeirButton, BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
  minHeirButton.active = false
  local minLevelEdit = W_CTRL.CreateEdit("minLevelEdit", frame)
  minLevelEdit:AddAnchor("LEFT", minHeirButton, "RIGHT", 2, 0)
  minLevelEdit:SetExtent(35, DEFAULT_SIZE.EDIT_HEIGHT)
  minLevelEdit:SetDigit(true)
  minLevelEdit:SetMaxTextLength(2)
  minLevelEdit:SetInitVal(MIN_MAX_LEVEL_INIT_VAL)
  local tildeLabel = CreateSearchFrameLabel("tildeLabel", "~")
  tildeLabel:AddAnchor("LEFT", minLevelEdit, "RIGHT", 2, 0)
  local maxHeirButton = frame:CreateChildWidget("button", "maxHeirButton", 0, true)
  maxHeirButton:Show(true)
  maxHeirButton:AddAnchor("LEFT", tildeLabel, "RIGHT", 3, 0)
  ApplyButtonSkin(maxHeirButton, BUTTON_BASIC.AUCTION_SEARCH_HEIR_OFF)
  maxHeirButton.active = false
  local maxLevelEdit = W_CTRL.CreateEdit("maxLevelEdit", frame)
  maxLevelEdit:AddAnchor("LEFT", maxHeirButton, "RIGHT", 2, 0)
  maxLevelEdit:SetExtent(35, DEFAULT_SIZE.EDIT_HEIGHT)
  maxLevelEdit:SetDigit(true)
  maxLevelEdit:SetMaxTextLength(2)
  maxLevelEdit:SetInitVal(MIN_MAX_LEVEL_INIT_VAL)
  local gradeLabel = CreateSearchFrameLabel("gradeLabel", locale.auction.itemGrade)
  gradeLabel:AddAnchor("LEFT", maxLevelEdit, "RIGHT", 15, 0)
  local gradeComboBoxButton = W_ETC.CreateGradeCombobox("gradeComboBoxButton", frame)
  gradeComboBoxButton:SetWidth(auctionLocale.width.bidGradeCombobox)
  gradeComboBoxButton:AddAnchor("LEFT", gradeLabel, "RIGHT", 2, 0)
  local nameEditbox = W_CTRL.CreateAutocomplete("nameEditbox", frame)
  nameEditbox:AddAnchor("LEFT", gradeComboBoxButton, "RIGHT", 5, 0)
  nameEditbox:SetExtent(170, DEFAULT_SIZE.EDIT_HEIGHT)
  nameEditbox.selector:SetMaxTextLength(150)
  nameEditbox:CreateGuideText(locale.auction.guideText, ALIGN_LEFT, EDITBOX_GUIDE_INSET)
  nameEditbox:SetAutocomplete("item", "auctionable")
  local searchButton = frame:CreateChildWidget("button", "searchButton", 0, true)
  searchButton:AddAnchor("LEFT", nameEditbox, "RIGHT", 3, 0)
  searchButton:Show(true)
  searchButton:SetText(GetCommonText("search"))
  ApplyButtonSkin(searchButton, BUTTON_BASIC.DEFAULT)
  local matchWordTextbox
  if auctionLocale.viewMatchWordBox then
    matchWordTextbox = CreateCheckButton("matchWordTextbox", frame, locale.auction.matchWord)
    matchWordTextbox:AddAnchor("LEFT", searchButton, "RIGHT", 5, 0)
  end
  frame.matchWordTextbox = matchWordTextbox
  local showDirectPriceRangeEdit = X2Auction:IsShowDirectPriceRangeEdit()
  local showDirectPriceRangeButton = frame:CreateChildWidget("button", "showDirectPriceRangeButton", 0, true)
  showDirectPriceRangeButton:AddAnchor("RIGHT", frame, 0, 0)
  showDirectPriceRangeButton:Show(true)
  if showDirectPriceRangeEdit then
    ApplyButtonSkin(showDirectPriceRangeButton, BUTTON_BASIC.MINUS)
  else
    ApplyButtonSkin(showDirectPriceRangeButton, BUTTON_BASIC.PLUS)
  end
  showDirectPriceRangeButton:Show(true)
  if F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
    frame.minDirectPriceWindow = W_MONEY.CreateAAPointEditsWindow(frame:GetId() .. ".minDirectPriceEdit", frame)
  else
    frame.minDirectPriceWindow = W_MONEY.CreateMoneyEditsWindow(frame:GetId() .. ".minDirectPriceEdit", frame)
  end
  frame.minDirectPriceWindow.goldEdit:Show(showDirectPriceRangeEdit)
  frame.minDirectPriceWindow.silverEdit:Show(false)
  frame.minDirectPriceWindow.copperEdit:Show(false)
  frame.minDirectPriceWindow:SetExtentByMultiplier(1, 0.85)
  frame.minDirectPriceWindow:SetMoneyFontSize(FONT_SIZE.SMALL)
  frame.minDirectPriceWindow:AddAnchor("TOPLEFT", nameEditbox, "BOTTOMLEFT", 0, 5)
  local tildeLabel2 = CreateSearchFrameLabel("tildeLabel2", "~")
  tildeLabel2:AddAnchor("LEFT", frame.minDirectPriceWindow.goldEdit, "RIGHT", 2, 0)
  tildeLabel2:Show(showDirectPriceRangeEdit)
  if F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
    frame.maxDirectPriceWindow = W_MONEY.CreateAAPointEditsWindow(frame:GetId() .. ".maxDirectPriceEdit", frame)
  else
    frame.maxDirectPriceWindow = W_MONEY.CreateMoneyEditsWindow(frame:GetId() .. ".maxDirectPriceEdit", frame)
  end
  frame.maxDirectPriceWindow.goldEdit:Show(X2Auction:IsShowDirectPriceRangeEdit())
  frame.maxDirectPriceWindow.silverEdit:Show(false)
  frame.maxDirectPriceWindow.copperEdit:Show(false)
  frame.maxDirectPriceWindow:SetExtentByMultiplier(1, 0.85)
  frame.maxDirectPriceWindow:SetMoneyFontSize(FONT_SIZE.SMALL)
  frame.maxDirectPriceWindow:AddAnchor("TOPLEFT", frame.minDirectPriceWindow.goldEdit, "TOPRIGHT", tildeLabel2:GetWidth() + 4, 0)
  local directPriceRangeLabel = CreateSearchFrameLabel("directPriceRangeLabel", GetCommonText("auction_search_direct_price_per_one"))
  directPriceRangeLabel.style:SetAlign(ALIGN_RIGHT)
  directPriceRangeLabel:AddAnchor("RIGHT", frame.minDirectPriceWindow.goldEdit, "LEFT", -5, 0)
  directPriceRangeLabel:Show(showDirectPriceRangeEdit)
  RegistCoolTimeButton(searchButton, 1)
end
local CreateCategoryFrame = function(window)
  local categoryFrame = W_CTRL.CreateScrollListBox(window:GetId() .. ".categoryFrame", window, window)
  categoryFrame.content:EnableSelectionToggle(true)
  categoryFrame:Show(true)
  categoryFrame:SetExtent(auctionLocale.width.bidCategory, 484)
  categoryFrame:AddAnchor("TOPLEFT", window.searchFrame, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE + 10)
  categoryFrame.content:ShowTooltip(auctionLocale.categoryTooltip)
  window.categoryFrame = categoryFrame
  categoryFrame:SetTreeImage()
  local MakeCategoryID = function(depth1_id, depth2_id, depth3_id)
    local idStr = string.format("%02d%02d%02d", depth1_id, depth2_id, depth3_id)
    local idNum = tonumber(idStr)
    if idNum == nil then
      UIParent:LogAlways(string.format("[ERROR - bid_view.lua] MakeCategoryID().. can't make id"))
      return 0
    end
    return idNum
  end
  local itemCategoryTable = {}
  for depth1 = 1, #auctionLocale.auctionCategories do
    itemCategoryTable[depth1] = {}
    local depth1_table = itemCategoryTable[depth1]
    local depth1_categories = auctionLocale.auctionCategories[depth1]
    depth1_table.text = depth1_categories.name
    depth1_table.value = MakeCategoryID(depth1_categories.id, 0, 0)
    if depth1_categories.useColor ~= nil then
      depth1_table.useColor = depth1_categories.useColor
      depth1_table.defaultColor = depth1_categories.defaultColor
      depth1_table.selectColor = depth1_categories.selectColor
      depth1_table.overColor = depth1_categories.overColor
    end
    if depth1_categories.iconPath ~= nil then
      depth1_table.iconPath = depth1_categories.iconPath
      depth1_table.infoKey = depth1_categories.infoKey
    end
    if depth1_categories.child ~= nil then
      depth1_table.child = {}
      for depth2 = 1, #depth1_categories.child do
        depth1_table.child[depth2] = {}
        local depth2_table = depth1_table.child[depth2]
        local depth2_categories = depth1_categories.child[depth2]
        depth2_table.text = depth2_categories.name
        depth2_table.value = MakeCategoryID(depth1_categories.id, depth2_categories.id, 0)
        if depth2_categories.child ~= nil then
          depth2_table.child = {}
          for depth3 = 1, #depth2_categories.child do
            depth2_table.child[depth3] = {}
            local depth3_table = depth2_table.child[depth3]
            local depth3_categories = depth2_categories.child[depth3]
            depth3_table.text = depth3_categories.name
            depth3_table.value = MakeCategoryID(depth1_categories.id, depth2_categories.id, depth3_categories.id)
          end
        end
      end
    end
  end
  categoryFrame:SetItemTrees(itemCategoryTable)
end
local CreateItemListFrame = function(window)
  local listInfos = {
    width = auctionLocale.width.bidListCtrl,
    height = 475,
    anchorWidget = window.categoryFrame,
    columns = {
      {
        name = locale.auction.name,
        width = auctionLocale.width.bidNameCol,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemName,
        sortKinds = {
          columnSortKind[5]
        },
        limitLen = auctionLocale.nameColLimitLen.bidTab
      },
      {
        name = locale.auction.level,
        width = auctionLocale.width.bidLevelCol,
        itemType = LCCIT_STRING,
        itemPropFunc = CreateItemLevel,
        sortKinds = {
          columnSortKind[6]
        }
      },
      {
        name = locale.auction.leftTime,
        width = auctionLocale.width.bidTimeCol,
        itemType = LCCIT_STRING,
        itemPropFunc = CreateItemLeftTime,
        sortKinds = {
          columnSortKind[7]
        }
      },
      {
        name = locale.auction.bidState,
        width = auctionLocale.width.bidStateCol,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemBiddingState
      },
      {
        name = locale.auction.bidPrice,
        width = auctionLocale.width.bidBidPrice,
        itemType = LCCIT_WINDOW,
        itemPropFunc = CreateItemBiddingPrice,
        sortKinds = {
          columnSortKind[1],
          columnSortKind[2],
          columnSortKind[3],
          columnSortKind[4]
        },
        defaultSortKinds = 3
      }
    }
  }
  CreateAuctionItemList(window, listInfos)
  window.listCtrl.column[4]:Enable(false)
end
local CreateCenterGuideFrame = function(window)
  local center_guide = window:CreateChildWidget("label", "center_guide", 0, true)
  center_guide:Show(false)
  center_guide:SetAutoResize(true)
  center_guide:SetHeight(FONT_SIZE.XLARGE)
  center_guide.style:SetFontSize(FONT_SIZE.XLARGE)
  center_guide:AddAnchor("CENTER", window.listCtrl, 0, 0)
  ApplyTextColor(center_guide, FONT_COLOR.DEFAULT)
  function window:ShowFirstGuide(visible)
    self.center_guide:Show(visible)
    if visible then
      self.center_guide:SetText(locale.auction.first_search_guide)
    end
  end
  function window:ShowNoneSearchResult(visible)
    self.center_guide:Show(visible)
    if visible then
      self.center_guide:SetText(locale.auction.none_search_result)
    end
  end
end
local CreateBottomFrame = function(window)
  local availableMoney = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".availableMoney", window, nil, "vertical")
  availableMoney:Show(true)
  availableMoney:AddAnchor("BOTTOMLEFT", window, 0, 0)
  window.availableMoney = availableMoney
  local availableAAPoint = W_MONEY.CreateTitleMoneyWindow(window:GetId() .. ".availableAAPoint", window, GetUIText(MONEY_TEXT, "aa_point"), "vertical")
  if F_MONEY.currency.auctionFee ~= CURRENCY_GOLD or F_MONEY.currency.auctionBid ~= CURRENCY_GOLD then
    availableAAPoint:Show(true)
  else
    availableAAPoint:Show(false)
  end
  availableAAPoint:AddAnchor("LEFT", availableMoney, "RIGHT", 20, 0)
  window.availableAAPoint = availableAAPoint
  if baselibLocale.showMoneyTooltip then
    local OnEnter = function(self)
      SetTooltip(locale.moneyTooltip.money, self)
    end
    availableMoney:SetHandler("OnEnter", OnEnter)
    local OnEnter = function(self)
      SetTooltip(locale.moneyTooltip.aapoint, self)
    end
    availableAAPoint:SetHandler("OnEnter", OnEnter)
  end
  local marketPriceBtn = CreateMarketPriceBtn("marketPriceBtn", window)
  window.marketPriceBtn = marketPriceBtn
  local directButton = window:CreateChildWidget("button", "directButton", 0, true)
  directButton:SetText(locale.auction.buy)
  ApplyButtonSkin(directButton, BUTTON_BASIC.DEFAULT)
  if marketPriceBtn == nil then
    directButton:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  else
    marketPriceBtn:AddAnchor("BOTTOMRIGHT", window, 0, 0)
    directButton:AddAnchor("BOTTOMRIGHT", marketPriceBtn, "BOTTOMLEFT", -5, 0)
  end
  local bidButton = window:CreateChildWidget("button", "bidButton", 0, true)
  bidButton:AddAnchor("BOTTOMRIGHT", directButton, "BOTTOMLEFT", 0, 0)
  bidButton:SetText(locale.auction.bid_money)
  ApplyButtonSkin(bidButton, BUTTON_BASIC.DEFAULT)
  local buttonTable = {directButton, bidButton}
  AdjustBtnLongestTextWidth(buttonTable)
  local moneyEditsWindow
  if F_MONEY.currency.auctionBid == CURRENCY_AA_POINT then
    moneyEditsWindow = W_MONEY.CreateAAPointEditsWindow(window:GetId() .. ".moneyEditsWindow", window)
  else
    moneyEditsWindow = W_MONEY.CreateMoneyEditsWindow(window:GetId() .. ".moneyEditsWindow", window)
  end
  moneyEditsWindow:AddAnchor("BOTTOMRIGHT", bidButton, "BOTTOMLEFT", 0, -5)
  window.moneyEditsWindow = moneyEditsWindow
end
function SetViewOfAuctionBidFrame(window)
  CreateSearchFrame(window)
  CreateCategoryFrame(window)
  CreateItemListFrame(window)
  CreateCenterGuideFrame(window)
  window:ShowFirstGuide(true)
  CreateBottomFrame(window)
end
