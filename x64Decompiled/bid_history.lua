function CreateAuctionBidHistoryFrame(window)
  SetViewOfAuctionBidHistoryFrame(window)
  local listCtrl = window.listCtrl
  local pageControl = window.pageControl
  local bidButton = window.bidButton
  local directButton = window.directButton
  local moneyEditsWindow = window.moneyEditsWindow
  local availableMoney = window.availableMoney
  local availableAAPoint = window.availableAAPoint
  local refreshButton = window.refreshButton
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
    pageControl:Enable(enable, true)
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
  function window:Init()
    listCtrl:ClearSelection()
    listCtrl:DeleteAllDatas()
    pageControl:Init()
    moneyEditsWindow:SetAmountStr("0")
    bidButton:Enable(false)
    directButton:Enable(false)
    EnableMarketPriceBtn(false)
    availableMoney:Update(X2Util:GetMyMoneyString(), false)
    availableAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString(), false)
  end
  function window:OnShow()
    X2Auction:SetCurTab(2)
    UIParent:LogAlways(string.format("[LOG] OnShow my bid history tab(2)"))
    self:Init()
    X2Auction:SearchMyBidList(1)
    SetSearchCoolTime()
  end
  window:SetHandler("OnShow", window.OnShow)
  function listCtrl:OnSelChanged(selIdx, doubleClick)
    if selIdx > 0 then
      bidButton:Enable(true)
      directButton:Enable(true)
      EnableMarketPriceBtn(true)
      local itemInfo = X2Auction:GetSearchedItemInfo(selIdx)
      SetMarketPriceBtn(itemInfo.itemType, itemInfo.itemGrade)
    else
      bidButton:Enable(false)
      directButton:Enable(false)
      EnableMarketPriceBtn(false)
      SetMarketPriceBtn()
    end
    local bidPrice, directPrice = X2Auction:GetSearchedItemPrice(selIdx)
    if bidPrice == nil or directPrice == nil then
      return
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
  function pageControl:OnPageChanged(pageIndex, countPerPage)
    self:Enable(false, true)
    X2Auction:SearchMyBidList(pageIndex)
  end
  function bidButton:OnClick(MBT)
    bidButtonOnClick(window, MBT)
  end
  bidButton:SetHandler("OnClick", bidButton.OnClick)
  function directButton:OnClick(MBT)
    directButtonOnClick(window, MBT)
  end
  directButton:SetHandler("OnClick", directButton.OnClick)
  local function RefreshButtonLeftButtonClickFunc()
    X2Auction:SearchMyBidList(pageControl:GetCurrentPageIndex())
    SetSearchCoolTime()
  end
  ButtonOnClickHandler(refreshButton, RefreshButtonLeftButtonClickFunc)
  return frame
end
