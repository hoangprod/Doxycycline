local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local CreateHowToWnd = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local titleDescAnchorY = craftingLocale.tabMylist.titleDescAnchorY
  local addedAnchorY = craftingLocale.tabMylist.addedAnchorY
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.LARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOP", window, 0, 0)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("how_to_post_craft_order"))
  local desc = window:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetExtent(300, FONT_SIZE.MIDDLE)
  desc:SetAutoResize(true)
  desc:SetAutoWordwrap(true)
  desc:AddAnchor("TOP", title, "BOTTOM", 0, titleDescAnchorY + addedAnchorY)
  desc.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(desc, F_COLOR.GetColor("default"))
  desc:SetText(GetCommonText("how_to_post_craft_order_desc"))
  function MakeSubDesc(parent, index, titleStr, descStr)
    local subWnd = window:CreateChildWidget("emptywidget", "subWnd", index, true)
    local subTitle = subWnd:CreateChildWidget("label", "title", index, true)
    subTitle:AddAnchor("TOP", subWnd, 0, 0)
    subTitle:SetHeight(FONT_SIZE.LARGE)
    subTitle:SetAutoResize(true)
    subTitle.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(subTitle, F_COLOR.GetColor("title"))
    subTitle:SetText(titleStr)
    local subDesc = subWnd:CreateChildWidget("textbox", "subDesc", index, true)
    subDesc:SetExtent(300, FONT_SIZE.MIDDLE)
    subDesc:AddAnchor("TOP", subTitle, "BOTTOM", 0, 4)
    subDesc:SetAutoResize(true)
    subDesc:SetAutoWordwrap(true)
    subDesc.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(subDesc, F_COLOR.GetColor("default"))
    subDesc:SetText(descStr)
    subWnd:SetExtent(300, subTitle:GetHeight() + subDesc:GetHeight() + 4)
    return subWnd
  end
  local key = X2Hotkey:GetBinding("toggle_craft_book", 1)
  if key ~= "" then
    key = GetCommonText("hotkey_to_toggle_craft_order", string.upper(key))
  end
  local sub1 = MakeSubDesc(window, 1, GetCommonText("how_to_post_craft_order_title_1"), GetCommonText("how_to_post_craft_order_desc_1", key))
  sub1:AddAnchor("TOP", desc, "BOTTOM", 0, 41 + addedAnchorY)
  local sub2 = MakeSubDesc(window, 2, GetCommonText("how_to_post_craft_order_title_2"), GetCommonText("how_to_post_craft_order_desc_2"))
  sub2:AddAnchor("TOP", sub1, "BOTTOM", 0, 39 + addedAnchorY)
  local sub3 = MakeSubDesc(window, 3, GetCommonText("how_to_post_craft_order_title_3"), GetCommonText("how_to_post_craft_order_desc_3"))
  sub3:AddAnchor("TOP", sub2, "BOTTOM", 0, 39 + addedAnchorY)
  local warning = window:CreateChildWidget("textbox", "warning", 0, true)
  warning:AddAnchor("TOP", sub3, "BOTTOM", 0, 41 + addedAnchorY)
  warning:SetExtent(300, FONT_SIZE.MIDDLE)
  warning:SetAutoWordwrap(true)
  warning:SetAutoResize(true)
  warning.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(warning, F_COLOR.GetColor("red"))
  warning:SetText(GetCommonText("how_to_post_craft_order_warning"))
  local height = title:GetHeight() + desc:GetHeight() + sub1:GetHeight() + sub2:GetHeight() + sub3:GetHeight() + warning:GetHeight() + 160 + titleDescAnchorY + addedAnchorY * 5
  window:SetExtent(300, height)
  return window
end
local CreateEntryInfoFrame = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local itemWnd = window:CreateChildWidget("emptywidget", "itemWnd", 0, true)
  itemWnd:AddAnchor("TOPLEFT", window, 0, 0)
  itemWnd:SetExtent(320, 35)
  local itemBg = itemWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  itemBg:SetTextureColor("bg_02")
  itemBg:AddAnchor("TOPLEFT", itemWnd, 0, 0)
  itemBg:AddAnchor("BOTTOMRIGHT", itemWnd, 0, 0)
  local itemTitle = itemWnd:CreateChildWidget("label", "itemTitle", 0, true)
  itemTitle:SetHeight(FONT_SIZE.LARGE)
  itemTitle:SetAutoResize(true)
  itemTitle:AddAnchor("TOPLEFT", itemWnd, 19, 11)
  itemTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(itemTitle, F_COLOR.GetColor("title"))
  itemTitle:SetText(GetCommonText("craft_order_item"))
  local itemDigbat = W_ICON.DrawDingbat(itemTitle)
  itemDigbat:AddAnchor("RIGHT", itemTitle, "LEFT", -5, 0)
  local item = CreateItemIconButton("item", itemWnd)
  item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  item:AddAnchor("TOP", itemWnd, 0, 55)
  itemWnd.item = item
  local itemName = itemWnd:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetExtent(300, FONT_SIZE.LARGE * 2 + 6)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  itemName:SetAutoResize(true)
  itemName:SetAutoWordwrap(true)
  itemName:AddAnchor("TOP", item, "BOTTOM", 0, 15)
  itemName.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(itemName, F_COLOR.GetColor("default"))
  local condWnd = window:CreateChildWidget("emptywidget", "condWnd", 0, true)
  condWnd:AddAnchor("TOPLEFT", itemName, "BOTTOMLEFT", -10, 25)
  condWnd:SetExtent(320, 35)
  local condBg = condWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  condBg:SetTextureColor("bg_02")
  condBg:AddAnchor("TOPLEFT", condWnd, 0, 0)
  condBg:AddAnchor("BOTTOMRIGHT", condWnd, 0, 0)
  local condTitle = condWnd:CreateChildWidget("label", "condTitle", 0, true)
  condTitle:SetHeight(FONT_SIZE.LARGE)
  condTitle:SetAutoResize(true)
  condTitle:AddAnchor("TOPLEFT", condWnd, 19, 11)
  condTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(condTitle, F_COLOR.GetColor("title"))
  condTitle:SetText(GetCommonText("craft_order_condition"))
  local condDigbat = W_ICON.DrawDingbat(condTitle)
  condDigbat:AddAnchor("RIGHT", condTitle, "LEFT", -5, 0)
  local actLabel = condWnd:CreateChildWidget("label", "actLabel", 0, true)
  actLabel:SetExtent(93, FONT_SIZE.MIDDLE)
  actLabel:AddAnchor("TOPLEFT", condWnd, "BOTTOMLEFT", 19, 12)
  actLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(actLabel, F_COLOR.GetColor("default"))
  actLabel.style:SetAlign(ALIGN_LEFT)
  actLabel:SetText(GetUIText(CRAFT_TEXT, "require_mastery"))
  local actValue = condWnd:CreateChildWidget("textbox", "actValue", 0, true)
  actValue:SetExtent(177, FONT_SIZE.MIDDLE)
  actValue:AddAnchor("LEFT", actLabel, "RIGHT", 13, 0)
  actValue.style:SetFontSize(FONT_SIZE.MIDDLE)
  actValue.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(actValue, F_COLOR.GetColor("default"))
  local countLabel = condWnd:CreateChildWidget("label", "countLabel", 0, true)
  countLabel:SetExtent(93, FONT_SIZE.MIDDLE)
  countLabel:AddAnchor("TOPLEFT", actLabel, "BOTTOMLEFT", 0, 8)
  countLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(countLabel, F_COLOR.GetColor("default"))
  countLabel.style:SetAlign(ALIGN_LEFT)
  countLabel:SetText(GetCommonText("craft_order_count"))
  local countValue = condWnd:CreateChildWidget("label", "countValue", 0, true)
  countValue:SetExtent(177, FONT_SIZE.MIDDLE)
  countValue:AddAnchor("LEFT", countLabel, "RIGHT", 13, 0)
  countValue.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(countValue, F_COLOR.GetColor("default"))
  countValue.style:SetAlign(ALIGN_LEFT)
  local durLabel = condWnd:CreateChildWidget("label", "durLabel", 0, true)
  durLabel:SetExtent(93, FONT_SIZE.MIDDLE)
  durLabel:AddAnchor("TOPLEFT", countLabel, "BOTTOMLEFT", 0, 8)
  durLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(durLabel, F_COLOR.GetColor("default"))
  durLabel.style:SetAlign(ALIGN_LEFT)
  durLabel:SetText(GetCommonText("craft_order_duration"))
  local durValue = condWnd:CreateChildWidget("label", "durValue", 0, true)
  durValue:SetExtent(177, FONT_SIZE.MIDDLE)
  durValue:AddAnchor("LEFT", durLabel, "RIGHT", 13, 0)
  durValue.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(durValue, F_COLOR.GetColor("default"))
  durValue.style:SetAlign(ALIGN_LEFT)
  local feeWnd = window:CreateChildWidget("emptywidget", "feeWnd", 0, true)
  feeWnd:AddAnchor("TOPLEFT", durLabel, "BOTTOMLEFT", -19, 13)
  feeWnd:SetExtent(320, 35)
  local feeBg = feeWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  feeBg:SetTextureColor("bg_02")
  feeBg:AddAnchor("TOPLEFT", feeWnd, 0, 0)
  feeBg:AddAnchor("BOTTOMRIGHT", feeWnd, 0, 0)
  local feeTitle = feeWnd:CreateChildWidget("label", "feeTitle", 0, true)
  feeTitle:SetHeight(FONT_SIZE.LARGE)
  feeTitle:SetAutoResize(true)
  feeTitle:AddAnchor("TOPLEFT", feeWnd, 19, 11)
  feeTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(feeTitle, F_COLOR.GetColor("title"))
  feeTitle:SetText(GetCommonText("craft_order_fee"))
  local feeDigbat = W_ICON.DrawDingbat(feeTitle)
  feeDigbat:AddAnchor("RIGHT", feeTitle, "LEFT", -5, 0)
  local feeDesc = feeWnd:CreateChildWidget("label", "feeDesc", 0, true)
  feeDesc:SetHeight(FONT_SIZE.MIDDLE)
  feeDesc:SetAutoResize(true)
  feeDesc:AddAnchor("TOPLEFT", feeWnd, "BOTTOMLEFT", 19, 11)
  feeDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(feeDesc, F_COLOR.GetColor("default"))
  feeDesc:SetText(GetCommonText("craft_order_fee_recently"))
  local minLabel = feeWnd:CreateChildWidget("label", "minLabel", 0, true)
  minLabel:SetExtent(133, FONT_SIZE.MIDDLE)
  minLabel:AddAnchor("TOPLEFT", feeDesc, "BOTTOMLEFT", 0, 8)
  minLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(minLabel, F_COLOR.GetColor("default"))
  minLabel.style:SetAlign(ALIGN_LEFT)
  minLabel:SetText(GetCommonText("lowest"))
  local minValue = W_MONEY.CreateDefaultMoneyWindow("minValue", feeWnd, 140, FONT_SIZE.MIDDLE)
  minValue:AddAnchor("LEFT", minLabel, "RIGHT", 15, 0)
  local maxLabel = feeWnd:CreateChildWidget("label", "maxLabel", 0, true)
  maxLabel:SetExtent(133, FONT_SIZE.MIDDLE)
  maxLabel:AddAnchor("TOPLEFT", minLabel, "BOTTOMLEFT", 0, 8)
  maxLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(maxLabel, F_COLOR.GetColor("default"))
  maxLabel.style:SetAlign(ALIGN_LEFT)
  maxLabel:SetText(GetCommonText("highest"))
  local maxValue = W_MONEY.CreateDefaultMoneyWindow("maxValue", feeWnd, 140, FONT_SIZE.MIDDLE)
  maxValue:AddAnchor("LEFT", maxLabel, "RIGHT", 15, 0)
  local inputWnd = window:CreateChildWidget("emptywidget", "inputWnd", 0, true)
  inputWnd:AddAnchor("TOPLEFT", maxLabel, "BOTTOMLEFT", -19, 11)
  inputWnd:SetExtent(320, 106)
  local feeLabel = inputWnd:CreateChildWidget("label", "feeLabel", 0, true)
  feeLabel:SetHeight(FONT_SIZE.MIDDLE)
  feeLabel:SetAutoResize(true)
  feeLabel:AddAnchor("TOPLEFT", inputWnd, 19, 8)
  feeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(feeLabel, F_COLOR.GetColor("default"))
  feeLabel:SetText(GetCommonText("input_craft_order_fee"))
  local feeValue = W_MONEY.CreateMoneyEditsWindow(inputWnd:GetId() .. ".feeValue", inputWnd)
  feeValue:AddAnchor("TOPRIGHT", inputWnd, -13, 26)
  feeValue:SetWidth(167)
  local curFeeValue = W_MONEY.CreateDefaultMoneyWindow("curFeeValue", inputWnd, 200, FONT_SIZE.MIDDLE)
  curFeeValue:AddAnchor("TOPRIGHT", inputWnd, -13, 26)
  local totalLabel = inputWnd:CreateChildWidget("label", "totalLabel", 0, true)
  totalLabel:SetHeight(FONT_SIZE.MIDDLE)
  totalLabel:SetAutoResize(true)
  totalLabel:AddAnchor("TOPLEFT", feeLabel, "BOTTOMLEFT", 0, 40)
  totalLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(totalLabel, F_COLOR.GetColor("default"))
  totalLabel:SetText(GetCommonText("total_craft_order_fee"))
  local totalValue = W_MONEY.CreateDefaultMoneyWindow("totalValue", inputWnd, 200, FONT_SIZE.MIDDLE)
  totalValue:AddAnchor("TOPRIGHT", feeValue, "BOTTOMRIGHT", 0, 27)
  local line1 = inputWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line1:SetExtent(0, 3)
  line1:AddAnchor("BOTTOMLEFT", inputWnd, "TOPLEFT", 0, 0)
  line1:AddAnchor("BOTTOMRIGHT", inputWnd, "TOPRIGHT", 0, 0)
  local line2 = inputWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line2:SetExtent(0, 3)
  line2:AddAnchor("BOTTOMLEFT", inputWnd, 0, 0)
  line2:AddAnchor("BOTTOMRIGHT", inputWnd, 0, 0)
  function window:Clear()
    item:Init()
    local height = itemName:GetHeight()
    itemName:SetText("")
    itemName:SetHeight(height > 1 and height or FONT_SIZE.LARGE)
    actValue:SetText("-")
    countValue:SetText("-")
    durValue:SetText("-")
    minValue:Show(false)
    maxValue:Show(false)
    feeValue:Show(false)
    feeValue:SetAmountStr(0)
    curFeeValue:Show(false)
    totalValue:Show(false)
    parent:UpdateBtnStatus()
  end
  function window:SetInfo(info)
    if X2Craft:IsCraftOrderMode() and info == nil then
      window:Clear()
      return
    end
    if info == nil then
      return
    end
    local craftType = info.craftType
    local count = info.craftCount
    local grade = info.craftGrade
    local baseInfo = X2Craft:GetCraftBaseInfo(craftType)
    local productInfo = X2Craft:GetCraftProductInfo(craftType)
    local pInfo = productInfo[1]
    local pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, grade)
    item:SetItemInfo(pItemInfo)
    item:SetStack(pInfo.amount)
    ApplyTextColor(itemName, Hex2Dec(pItemInfo.gradeColor))
    itemName:SetText(pInfo.item_name)
    if baseInfo.required_actability_type ~= nil then
      actValue:SetText(string.format("%s |,%d;", baseInfo.required_actability_name, baseInfo.required_actability_point))
    else
      actValue:SetText("-")
    end
    countValue:SetText(tostring(count))
    minValue:SetText("-")
    minValue:Show(true)
    maxValue:SetText("-")
    maxValue:Show(true)
    if info.fee == nil then
      durValue:SetText(GetCommonText("craft_order_48hour"))
      feeValue:SetAmountStr(0)
      totalValue:Update(0)
      totalValue.count = count
      local limit = feeValue:GetSystemCurrencyAmountLimit()
      feeValue:SetCurrencyAmountLimit(X2Util:DivideNumberString(limit, tostring(count)))
      feeValue:Show(true)
      curFeeValue:Show(false)
    else
      local leftTimeStr, timeWarning = CheckLeftTime(info.remainTime)
      durValue:SetText(leftTimeStr)
      curFeeValue:Update(X2Util:DivideNumberString(info.fee, tostring(count)))
      totalValue:Update(info.fee)
      feeValue:Show(false)
      curFeeValue:Show(true)
    end
    totalValue:Show(true)
    X2Craft:RequestCraftOrderFee(craftType)
    parent:UpdateBtnStatus()
  end
  function feeValue.MoneyEditProc()
    totalValue:Update(F_CALC.MulNum(feeValue:GetAmountStr(), tostring(totalValue.count)))
    parent:UpdateBtnStatus(minValue.amount, feeValue:GetAmountStr())
  end
  function window:UpdateFeeInfo(minFee, maxFee)
    minValue:Update(minFee)
    maxValue:Update(maxFee)
    if feeValue:IsVisible() then
      feeValue:SetAmountStr(minFee)
    end
  end
  local SetCraftOrderItemSlot = function()
    if X2Cursor:GetCursorPickedBagItemIndex() ~= 0 then
      X2Craft:SetCraftOrderItemSlotFromPick()
    end
  end
  local function ClearCraftOrderItemSlot()
    if item:GetInfo() ~= nil then
      X2Craft:ClearCraftOrderItemSlot()
    end
  end
  ButtonOnClickHandler(item, SetCraftOrderItemSlot, ClearCraftOrderItemSlot)
  return window
end
local function CreatePostFrame(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_02")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local postBtn = window:CreateChildWidget("button", "postBtn", 0, true)
  postBtn:SetText(GetUIText(AUCTION_TEXT, "putup_item"))
  postBtn:AddAnchor("BOTTOM", window, 0, 0)
  ApplyButtonSkin(postBtn, BUTTON_BASIC.DEFAULT)
  postBtn:Enable(false)
  local entryInfo = CreateEntryInfoFrame("entryInfo", window)
  entryInfo:AddAnchor("TOPLEFT", window, 0, 0)
  entryInfo:AddAnchor("TOPRIGHT", window, 0, 0)
  entryInfo:AddAnchor("BOTTOM", postBtn, "TOP", 0, 0)
  local backBtn = entryInfo:CreateChildWidget("button", "backBtn", 0, true)
  backBtn:AddAnchor("BOTTOMLEFT", window, 5, 0)
  ApplyButtonSkin(backBtn, BUTTON_STYLE.BACK)
  backBtn:Enable(true)
  local howTo = CreateHowToWnd("howTo", window)
  local hMargin = 510 - howTo:GetHeight()
  howTo:AddAnchor("TOP", window, 0, hMargin / 2)
  function window:Init()
    howTo:Show(true)
    entryInfo:Show(false)
    postBtn:Enable(false)
    backBtn:Show(true)
  end
  local function BackBtnFunc()
    window:Init()
    X2Craft:LeaveCraftOrderMode()
  end
  ButtonOnClickHandler(backBtn, BackBtnFunc)
  local function PostBtnFunc()
    if postBtn.curFee ~= nil then
      X2Craft:PostCraftOrder(postBtn.curFee)
    end
  end
  ButtonOnClickHandler(postBtn, PostBtnFunc)
  function window:UpdateBtnStatus(minFee, curFee)
    if minFee == nil then
      postBtn.curFee = nil
      postBtn:Enable(false)
    else
      postBtn.curFee = curFee
      postBtn:Enable(X2Util:StrNumericComp(curFee, minFee) >= 0)
    end
  end
  function window:SetInfo(info, btnShow)
    if info == nil and not X2Craft:IsCraftOrderMode() then
      window:Init()
      return
    end
    howTo:Show(false)
    entryInfo:SetInfo(info)
    entryInfo:Show(true)
    postBtn:Show(btnShow)
  end
  local events = {
    UPDATE_CRAFT_ORDER_ITEM_FEE = function(info)
      entryInfo:UpdateFeeInfo(info.minFee, info.maxFee)
    end,
    POST_CRAFT_ORDER = function(result)
      if result then
        window:Init()
        X2Craft:LeaveCraftOrderMode()
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local CreateMyListFrame = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_02")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local refreshBtn = window:CreateChildWidget("button", "refreshBtn", 0, true)
  refreshBtn:AddAnchor("TOPRIGHT", window, "TOPRIGHT", 0, 0)
  refreshBtn:Show(true)
  ApplyButtonSkin(refreshBtn, BUTTON_STYLE.RESET_BIG)
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:AddAnchor("TOPLEFT", window, 0, 0)
  title:AddAnchor("BOTTOMRIGHT", refreshBtn, "TOPLEFT", 0, 35)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("craft_order_list", "0", "5"))
  local titleBg = title:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  titleBg:SetTextureColor("bg_02")
  titleBg:AddAnchor("TOPLEFT", title, 0, 0)
  titleBg:AddAnchor("BOTTOMRIGHT", title, refreshBtn:GetWidth(), 0)
  local line = title:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line:SetExtent(0, 3)
  line:AddAnchor("BOTTOMLEFT", title, 0, 0)
  line:AddAnchor("BOTTOMRIGHT", title, 0, 0)
  local DataSetFunc = function(subItem, info, setValue)
    local emptyLabel = subItem.emptyLabel
    local infoWnd = subItem.infoWnd
    local item = infoWnd.item
    local itemName = infoWnd.itemName
    local timeValue = infoWnd.timeValue
    local countValue = infoWnd.countValue
    local feeValue = infoWnd.feeValue
    local findBtn = subItem.findBtn
    local cancelBtn = subItem.cancelBtn
    local detailBtn = subItem.detailBtn
    local completeBtn = subItem.completeBtn
    if setValue and info ~= "" then
      emptyLabel:Show(false)
      infoWnd:Show(true)
      findBtn:Show(false)
      cancelBtn:Show(true)
      detailBtn:Show(true)
      completeBtn:Show(true)
      subItem.entryId = info.entryId
      local craftType = info.craftType
      local count = info.craftCount
      local grade = info.craftGrade
      local remainTime = info.remainTime
      local fee = info.fee
      local baseInfo = X2Craft:GetCraftBaseInfo(craftType)
      local productInfo = X2Craft:GetCraftProductInfo(craftType)
      local materialInfo = X2Craft:GetCraftMaterialInfo(craftType, 0)
      local pInfo = productInfo[1]
      local pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, grade)
      item:SetItemInfo(pItemInfo)
      item:SetStack(pInfo.amount)
      ApplyTextColor(itemName, Hex2Dec(pItemInfo.gradeColor))
      itemName:SetText(pInfo.item_name)
      subItem.itemInfo = pItemInfo
      subItem.productInfo = pInfo
      subItem.itemCount = count
      subItem.info = info
      local leftTimeStr, timeWarning = CheckLeftTime(remainTime)
      timeValue:SetText(leftTimeStr)
      if timeWarning then
        ApplyTextColor(timeValue, F_COLOR.GetColor("red"))
      else
        ApplyTextColor(timeValue, F_COLOR.GetColor("default"))
      end
      countValue:SetText(tostring(count))
      feeValue:Update(tostring(fee))
    else
      subItem.entryId = nil
      emptyLabel:Show(true)
      infoWnd:Show(false)
      findBtn:Show(true)
      cancelBtn:Show(false)
      detailBtn:Show(false)
      completeBtn:Show(false)
    end
  end
  local function LayoutSetFunc(widget, rowIndex, colIndex, subItem)
    local findBtn = subItem:CreateChildWidget("button", "findBtn", 0, true)
    findBtn:AddAnchor("RIGHT", subItem, -4, 0)
    ApplyButtonSkin(findBtn, BUTTON_STYLE.REQUEST_CRAFT_ORDER)
    findBtn:Enable(true)
    local emptyLabel = subItem:CreateChildWidget("label", "emptyLabel", 0, true)
    emptyLabel:SetHeight(FONT_SIZE.MIDDLE)
    emptyLabel:SetAutoResize(true)
    emptyLabel:AddAnchor("CENTER", subItem, -(findBtn:GetWidth() / 2), 0)
    ApplyTextColor(emptyLabel, F_COLOR.GetColor("beige"))
    emptyLabel:SetText(GetCommonText("possible_to_post_craft_order"))
    local infoWnd = subItem:CreateChildWidget("emptywidget", "infoWnd", 0, true)
    infoWnd:AddAnchor("TOPLEFT", subItem, 0, 0)
    infoWnd:AddAnchor("BOTTOMRIGHT", subItem, 0, 0)
    local cancelBtn = subItem:CreateChildWidget("button", "cancelBtn", 0, true)
    cancelBtn:AddAnchor("TOPRIGHT", subItem, "TOPRIGHT", -7, 16)
    ApplyButtonSkin(cancelBtn, BUTTON_STYLE.CANCEL)
    cancelBtn:Enable(true)
    local detailBtn = subItem:CreateChildWidget("button", "detailBtn", 0, true)
    detailBtn:AddAnchor("BOTTOMRIGHT", subItem, "BOTTOMRIGHT", -4, -8)
    ApplyButtonSkin(detailBtn, BUTTON_ICON.SEARCH)
    detailBtn:Enable(true)
    local completeBtn = subItem:CreateChildWidget("button", "completeBtn", 0, true)
    completeBtn:AddAnchor("BOTTOMRIGHT", detailBtn, "TOPRIGHT", 0, 0)
    ApplyButtonSkin(completeBtn, BUTTON_ICON.COMPLETE)
    completeBtn:Enable(true)
    local item = CreateItemIconButton("item", infoWnd)
    item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    item:AddAnchor("TOPLEFT", infoWnd, 15, 10)
    infoWnd.item = item
    local itemName = infoWnd:CreateChildWidget("textbox", "itemName", 0, true)
    itemName:SetExtent(300, FONT_SIZE.MIDDLE * 2 + 6)
    itemName.style:SetFontSize(FONT_SIZE.MIDDLE)
    itemName:SetAutoResize(true)
    itemName:SetAutoWordwrap(true)
    itemName:AddAnchor("LEFT", item, "RIGHT", 5, 0)
    itemName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(itemName, F_COLOR.GetColor("defualt"))
    local countLabel = infoWnd:CreateChildWidget("label", "countLabel", 0, true)
    countLabel:SetExtent(103, FONT_SIZE.MIDDLE)
    countLabel:AddAnchor("TOPLEFT", item, "BOTTOMLEFT", 0, 10)
    countLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(countLabel, F_COLOR.GetColor("default"))
    countLabel.style:SetAlign(ALIGN_LEFT)
    countLabel:SetText(GetCommonText("craft_order_count"))
    local countValue = infoWnd:CreateChildWidget("label", "countValue", 0, true)
    countValue:SetHeight(FONT_SIZE.MIDDLE)
    countValue:SetAutoResize(true)
    countValue:AddAnchor("LEFT", countLabel, "RIGHT", 26, 0)
    ApplyTextColor(countValue, F_COLOR.GetColor("default"))
    ApplyTextColor(countValue, F_COLOR.GetColor("default"))
    local timeLabel = infoWnd:CreateChildWidget("label", "timeLabel", 0, true)
    timeLabel:SetExtent(103, FONT_SIZE.MIDDLE)
    timeLabel:AddAnchor("TOPLEFT", countLabel, "BOTTOMLEFT", 0, 5)
    timeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(timeLabel, F_COLOR.GetColor("default"))
    timeLabel.style:SetAlign(ALIGN_LEFT)
    timeLabel:SetText(GetUIText(AUCTION_TEXT, "left_time"))
    local timeValue = infoWnd:CreateChildWidget("label", "timeValue", 0, true)
    timeValue:SetHeight(FONT_SIZE.MIDDLE)
    timeValue:SetAutoResize(true)
    timeValue:AddAnchor("LEFT", timeLabel, "RIGHT", 26, 0)
    ApplyTextColor(timeValue, F_COLOR.GetColor("default"))
    ApplyTextColor(timeValue, F_COLOR.GetColor("default"))
    local feeLabel = infoWnd:CreateChildWidget("label", "feeLabel", 0, true)
    feeLabel:SetExtent(103, FONT_SIZE.MIDDLE)
    feeLabel:AddAnchor("TOPLEFT", timeLabel, "BOTTOMLEFT", 0, 5)
    feeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(feeLabel, F_COLOR.GetColor("default"))
    feeLabel.style:SetAlign(ALIGN_LEFT)
    feeLabel:SetText(GetCommonText("craft_order_fee"))
    local feeValue = W_MONEY.CreateDefaultMoneyWindow("feeValue", infoWnd, 175, 27)
    feeValue:AddAnchor("BOTTOMLEFT", infoWnd, 137, -7)
    infoWnd.feeValue = feeValue
    local bg = feeValue:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
    bg:SetTextureColor("money")
    bg:AddAnchor("TOPLEFT", feeValue, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", feeValue, 8, 0)
    local FindBtnFunc = function()
      X2Craft:EnterCraftOrderMode()
    end
    ButtonOnClickHandler(findBtn, FindBtnFunc)
    local function CancelBtnFunc()
      local function DialogHandler(wnd, infoTable)
        wnd:SetTitle(GetUIText(COMMON_TEXT, "cancel_craft_order"))
        wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "cancel_craft_order_desc"))
        local itemData = {
          itemInfo = subItem.itemInfo,
          stack = subItem.productInfo.amount
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        local textData = {
          type = "default",
          text = GetUIText(COMMON_TEXT, "craft_order_count_msg", tostring(subItem.itemCount))
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "period", textData)
        function wnd:OkProc()
          X2Craft:CancelCraftOrder(subItem.entryId)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, GetCraftOrderBoard():GetId())
    end
    ButtonOnClickHandler(cancelBtn, CancelBtnFunc)
    local function DetailBtnFunc()
      parent:UpdatePostFrame(subItem.info, false)
    end
    ButtonOnClickHandler(detailBtn, DetailBtnFunc)
    local function CompleteBtnFunc()
      local function DialogHandler(wnd)
        local info = X2Craft:GetMyCraftOrderInstantEntry(subItem.entryId)
        wnd:SetTitle(GetUIText(COMMON_TEXT, "craft_order_instant"))
        wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "craft_order_instant_dlg_desc"))
        local itemData = {
          itemInfo = info.itemInfo,
          stack = {
            info.couponMyCnt,
            info.couponReqCnt
          }
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        local costData = {
          type = "craft_order_instant_additional_fee",
          currency = CURRENCY_GOLD,
          value = tostring(info.additionalFee)
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", costData)
        local textData = {
          type = "warning",
          text = GetUIText(COMMON_TEXT, "craft_order_instant_dlg_tip")
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
        function wnd:OkProc()
          X2Craft:ProcessCraftOrderInstant(subItem.entryId)
        end
      end
      X2DialogManager:RequestDefaultDialog(DialogHandler, GetCraftOrderBoard():GetId())
    end
    ButtonOnClickHandler(completeBtn, CompleteBtnFunc)
    function findBtn:OnEnter()
      SetTooltip(GetCommonText("find_craft_order_sheet"), self)
    end
    findBtn:SetHandler("OnEnter", findBtn.OnEnter)
    function findBtn:OnLeave()
      HideTooltip()
    end
    findBtn:SetHandler("OnLeave", findBtn.OnLeave)
    function cancelBtn:OnEnter()
      SetTooltip(GetCommonText("cancel_craft_order_tooltip"), self)
    end
    cancelBtn:SetHandler("OnEnter", cancelBtn.OnEnter)
    function cancelBtn:OnLeave()
      HideTooltip()
    end
    cancelBtn:SetHandler("OnLeave", cancelBtn.OnLeave)
    function detailBtn:OnEnter()
      SetTooltip(GetCommonText("show_craft_order"), self)
    end
    detailBtn:SetHandler("OnEnter", detailBtn.OnEnter)
    function detailBtn:OnLeave()
      HideTooltip()
    end
    detailBtn:SetHandler("OnLeave", detailBtn.OnLeave)
    function completeBtn:OnEnter()
      SetTooltip(GetCommonText("craft_order_instant_btn_tooltip"), self)
    end
    completeBtn:SetHandler("OnEnter", completeBtn.OnEnter)
    function completeBtn:OnLeave()
      HideTooltip()
    end
    completeBtn:SetHandler("OnLeave", completeBtn.OnLeave)
  end
  local myList = W_CTRL.CreateScrollListCtrl("myList", window)
  myList:AddAnchor("TOPLEFT", window, 0, 35)
  myList:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  myList:HideColumnButtons()
  myList:InsertColumn("", 413, LCCIT_WINDOW, DataSetFunc, nil, nil, LayoutSetFunc)
  myList:InsertRows(4, false)
  myList.scroll:AddAnchor("TOPRIGHT", myList, 0, 0)
  myList.listCtrl:DrawListLine(nil, false, true)
  function window:Refresh()
    myList:DeleteAllDatas()
    local cnt = 0
    local entries = X2Craft:GetMyCraftOrderEntry()
    for i = 1, math.max(CRAFT_ORDER_ENTRY_PER_CHARACTER, #entries) do
      if entries[i] ~= nil then
        myList:InsertData(i, 1, entries[i])
        cnt = cnt + 1
      else
        myList:InsertData(i, 1, "")
      end
    end
    title:SetText(GetCommonText("craft_order_list", tostring(cnt), tostring(CRAFT_ORDER_ENTRY_PER_CHARACTER)))
  end
  ButtonOnClickHandler(refreshBtn, window.Refresh)
  local events = {
    INSERT_CRAFT_ORDER = function()
      window:Refresh()
    end,
    DELETE_CRAFT_ORDER = function()
      window:Refresh()
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function CreateCraftOrderMyListTab(window)
  local postFrame = CreatePostFrame("postFrame", window)
  postFrame:AddAnchor("TOPLEFT", window, 0, 10)
  postFrame:AddAnchor("BOTTOMRIGHT", window, "BOTTOMLEFT", 320, -20)
  local myListFrame = CreateMyListFrame("myListFrame", window)
  myListFrame:AddAnchor("TOPLEFT", postFrame, "TOPRIGHT", 5, 0)
  myListFrame:AddAnchor("BOTTOMRIGHT", window, 0, -20)
  local guide = W_ICON.CreateGuideIconWidget(window)
  guide:AddAnchor("BOTTOMLEFT", window, 6, 0)
  local guideLabel = window:CreateChildWidget("label", "guideLabel", 0, true)
  guideLabel:Show(true)
  guideLabel:SetHeight(FONT_SIZE.MIDDLE)
  guideLabel:AddAnchor("LEFT", guide, "RIGHT", 3, 0)
  guideLabel.style:SetAlign(ALIGN_LEFT)
  guideLabel:SetText(X2Locale:LocalizeUiText(COMMON_TEXT, "craft_order_instant_btn_tooltip"))
  ApplyTextColor(guideLabel, F_COLOR.GetColor("default"))
  function guide:OnEnter()
    SetTooltip(GetCommonText("craft_order_instant_tooltip"), self)
  end
  guide:SetHandler("OnEnter", guide.OnEnter)
  function guide:OnLeave()
    HideTooltip()
  end
  guide:SetHandler("OnLeave", guide.OnLeave)
  function window:OnHide()
    X2Craft:LeaveCraftOrderMode()
  end
  window:SetHandler("OnHide", window.OnHide)
  function window:OnShow()
    myListFrame:Refresh()
    postFrame:Init()
  end
  window:SetHandler("OnShow", window.OnShow)
  function window:UpdatePostFrame(info, btnShow)
    postFrame:SetInfo(info, btnShow)
  end
  local events = {
    UPDATE_CRAFT_ORDER_ITEM_SLOT = function(info)
      window:UpdatePostFrame(info, true)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
