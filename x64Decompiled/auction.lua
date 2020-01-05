auctionWindow = nil
function CreateAuctionWindow(id, parent)
  local window = SetViewOfAuctionWindow(id, parent)
  window:SetSounds("auction")
  for i = 1, #window.tab.unselectedButton do
    RegistCoolTimeButton(window.tab.unselectedButton[i], 1)
  end
  function window:Init()
    local windows = window.tab.window
    for i = 1, #windows do
      windows[i]:Init()
    end
  end
  function window:ShowProc()
    UIParent:LogAlways(string.format("[LOG] Show auction window"))
    self:Init()
    self.tab:SelectTab(1)
    X2Auction:SetCurTab(0)
    X2Auction:SetOpen(true)
  end
  function window:OnHide()
    UIParent:LogAlways(string.format("[LOG] Hide auction window"))
    while true do
      table.remove(coolTimeButtons, #coolTimeButtons)
      if #coolTimeButtons == 0 then
        break
      end
    end
    window.tab.window[1]:ClearLastSearchArticle()
    window.tab.window[2]:ClearPutupedItemList()
    window:ReleaseHandler("OnUpdate")
    X2Auction:DetachItem(false)
    X2Auction:SetOpen(false)
    auctionWindow = nil
  end
  window:SetHandler("OnHide", window.OnHide)
  function window.tab:OnTabChanged(selected)
    ReAnhorTabLine(window.tab, selected)
    if selected == 2 and X2Auction:HasPostAuthority() then
      ADDON:ShowContent(UIC_BAG, true)
    end
  end
  window.tab:SetHandler("OnTabChanged", window.tab.OnTabChanged)
  function window:OnUpdate(dt)
    CheckSearchCoolTime()
  end
  return window
end
function AttachItemToAuction(slot)
  if auctionWindow == nil then
    return
  end
  if auctionWindow:IsVisible() == false then
    return false
  end
  local tab = auctionWindow.tab
  if tab:GetSelectedTab() ~= 2 then
    tab:SelectTab(2)
  end
  X2Auction:AttachItemFromBag(slot)
  return true
end
local AttachItem = function(attached)
  if auctionWindow == nil then
    return
  end
  local putupFrame = auctionWindow.tab.window[2]
  putupFrame:AttachItem(attached)
end
local function ItemPutup(itemName)
  AttachItem(false)
  local msg = locale.auction.putupMsg(itemName)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
end
local ItemSearch = function()
  if auctionWindow == nil then
    return
  end
  local bidFrame = auctionWindow.tab.window[1]
  local putupFrame = auctionWindow.tab.window[2]
  local bidHistoryFrame = auctionWindow.tab.window[3]
  if bidFrame:IsVisible() == true then
    bidFrame:EnableSearch(false)
  elseif putupFrame:IsVisible() == true then
    putupFrame:EnableSearch(false)
  elseif bidHistoryFrame:IsVisible() == true then
    bidHistoryFrame:EnableSearch(false)
  end
end
local ItemSearched = function(clearLastSearchArticle)
  if auctionWindow == nil then
    return
  end
  local bidFrame = auctionWindow.tab.window[1]
  local putupFrame = auctionWindow.tab.window[2]
  local bidHistoryFrame = auctionWindow.tab.window[3]
  if bidFrame:IsVisible() == true then
    bidFrame:RefreshItemList()
    if clearLastSearchArticle == true then
      bidFrame:ClearLastSearchArticle()
    end
  elseif putupFrame:IsVisible() == true then
    putupFrame:RefreshItemList()
  elseif bidHistoryFrame:IsVisible() == true then
    bidHistoryFrame:RefreshItemList()
  end
end
local ItemBidded = function(itemName, moneyStr)
  local money = MakeMoneyText(moneyStr)
  local msg = locale.auction.biddedMsg(itemName, money)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
end
local ItemBought = function(itemName, moneyStr)
  local money = MakeMoneyText(moneyStr)
  local msg = locale.auction.boughtMsg(itemName, money)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
end
local ItemCanceled = function(itemName)
  local msg = locale.auction.cancelMsg(itemName)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
end
local CharacterLevelTooLow = function(errKey, level)
  local msg = locale.auction.levelTooLowMsg(errKey, tostring(level))
  AddMessageToSysMsgWindow(msg)
  X2Chat:DispatchChatMessage(CMF_TRADE_STORE_MSG, msg)
end
local MoneyUpdated = function()
  if auctionWindow == nil then
    return
  end
  auctionWindow.tab.window[1].availableMoney:Update(X2Util:GetMyMoneyString())
  auctionWindow.tab.window[2].availableMoney:Update(X2Util:GetMyMoneyString())
  auctionWindow.tab.window[3].availableMoney:Update(X2Util:GetMyMoneyString())
  auctionWindow.tab.window[1].availableAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString())
  auctionWindow.tab.window[2].availableAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString())
  auctionWindow.tab.window[3].availableAAPoint:UpdateAAPoint(X2Util:GetMyAAPointString())
end
local LowestPriceSearched = function(itemType, grade, price)
  if auctionWindow == nil then
    return
  end
  local putupFrame = auctionWindow.tab.window[2]
  putupFrame.putupItemFrame.lowestPrice:SetPrice(itemType, price)
end
local auctionWindowEvents = {}
function ToggleAuctionWindow(show)
  if show == nil then
    show = auctionWindow == nil and true or not auctionWindow:IsVisible()
  end
  if show == true and auctionWindow == nil then
    auctionWindow = CreateAuctionWindow("auctionWindow", "UIParent")
    auctionWindow:EnableHidingIsRemove(true)
    auctionWindow:SetHandler("OnEvent", function(this, event, ...)
      auctionWindowEvents[event](...)
    end, false)
    RegistUIEvent(auctionWindow, auctionWindowEvents)
  end
  if auctionWindow ~= nil then
    auctionWindow:Show(show)
  end
  return true
end
ADDON:RegisterContentTriggerFunc(UIC_AUCTION, ToggleAuctionWindow)
auctionWindowEvents = {
  AUCTION_ITEM_ATTACHMENT_STATE_CHANGED = AttachItem,
  AUCTION_ITEM_PUT_UP = ItemPutup,
  AUCTION_ITEM_SEARCH = ItemSearch,
  AUCTION_ITEM_SEARCHED = ItemSearched,
  AUCTION_BIDDED = ItemBidded,
  AUCTION_BOUGHT_BY_SOMEONE = ItemBoughtBySomeone,
  AUCTION_CANCELED = ItemCanceled,
  AUCTION_CHARACTER_LEVEL_TOO_LOW = CharacterLevelTooLow,
  PLAYER_MONEY = MoneyUpdated,
  PLAYER_AA_POINT = MoneyUpdated,
  AUCTION_LOWEST_PRICE = LowestPriceSearched
}
