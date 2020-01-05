local INVALID_SHEET_ICON = "Game\\ui\\icon\\icon_item_4362.dds"
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateOrderInfoFrame(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_02")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local titleWnd = window:CreateChildWidget("emptywidget", "titleWnd", 0, true)
  titleWnd:AddAnchor("TOPLEFT", window, 0, 0)
  titleWnd:SetExtent(320, 35)
  local titleBg = titleWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  titleBg:SetTextureColor("bg_02")
  titleBg:AddAnchor("TOPLEFT", titleWnd, 0, 0)
  titleBg:AddAnchor("BOTTOMRIGHT", titleWnd, 0, 0)
  local title = titleWnd:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.LARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", titleWnd, 19, 11)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("craft_order_sheet_info"))
  local dingbat = W_ICON.DrawDingbat(title)
  dingbat:AddAnchor("RIGHT", title, "LEFT", -5, 0)
  local item = CreateItemIconButton("item", window)
  item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  item:AddAnchor("TOP", titleWnd, "BOTTOM", 0, 20)
  local itemName = window:CreateChildWidget("textbox", "itemName", 0, true)
  itemName:SetExtent(300, FONT_SIZE.LARGE * 2 + 6)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  itemName:SetAutoResize(true)
  itemName:SetAutoWordwrap(true)
  itemName:AddAnchor("TOP", item, "BOTTOM", 0, 15)
  itemName.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(itemName, F_COLOR.GetColor("default"))
  local line = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line:SetExtent(0, 3)
  line:AddAnchor("TOPLEFT", itemName, "BOTTOMLEFT", 0, 25)
  line:AddAnchor("TOPRIGHT", itemName, "BOTTOMRIGHT", 0, 25)
  local actAnchorY = craftingLocale.tabRestore.orderInfoActLableAnchorY
  local actLabel = window:CreateChildWidget("label", "actLabel", 0, true)
  actLabel:SetExtent(93, FONT_SIZE.MIDDLE)
  actLabel:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 0, actAnchorY)
  actLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(actLabel, F_COLOR.GetColor("default"))
  actLabel.style:SetAlign(ALIGN_LEFT)
  actLabel:SetText(GetUIText(CRAFT_TEXT, "require_mastery"))
  local actValue = window:CreateChildWidget("textbox", "actValue", 0, true)
  actValue:SetExtent(177, FONT_SIZE.MIDDLE)
  actValue:AddAnchor("LEFT", actLabel, "RIGHT", 13, 0)
  actValue.style:SetFontSize(FONT_SIZE.MIDDLE)
  actValue.style:SetAlign(ALIGN_LEFT)
  ApplyTextColor(actValue, F_COLOR.GetColor("default"))
  local countLabel = window:CreateChildWidget("label", "countLabel", 0, true)
  countLabel:SetExtent(93, FONT_SIZE.MIDDLE)
  countLabel:AddAnchor("TOPLEFT", actLabel, "BOTTOMLEFT", 0, 8)
  countLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(countLabel, F_COLOR.GetColor("default"))
  countLabel.style:SetAlign(ALIGN_LEFT)
  countLabel:SetText(GetCommonText("craft_order_count"))
  local countValue = window:CreateChildWidget("label", "countValue", 0, true)
  countValue:SetExtent(177, FONT_SIZE.MIDDLE)
  countValue:AddAnchor("LEFT", countLabel, "RIGHT", 13, 0)
  countValue.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(countValue, F_COLOR.GetColor("default"))
  countValue.style:SetAlign(ALIGN_LEFT)
  function window:ReHeight()
    window:SetHeight(craftingLocale.tabRestore.orderInfoHeight + itemName:GetHeight())
  end
  window:ReHeight()
  function window:Clear()
    item:Init()
    local height = itemName:GetHeight()
    itemName:SetText("")
    itemName:SetHeight(height > 1 and height or FONT_SIZE.LARGE)
    actValue:SetText("-")
    countValue:SetText("-")
    window:ReHeight()
  end
  function window:SetInfo(info)
    if info == nil then
      return
    end
    local craftType = info.craftType
    local count = info.craftCount
    local grade = info.craftGrade
    if craftType == nil then
      F_SLOT.SetItemIcons(item, INVALID_SHEET_ICON)
      ApplyTextColor(itemName, F_COLOR.GetColor("default"))
      itemName:SetText(GetCommonText("invalid_craft_order_sheet"))
      countValue:SetText("-")
      actValue:SetText("-")
    else
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
    end
    window:ReHeight()
  end
  return window
end
local CreateMaterialInfoFrame = function(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("bg_02")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  local titleWnd = window:CreateChildWidget("emptywidget", "titleWnd", 0, true)
  titleWnd:AddAnchor("TOPLEFT", window, 0, 0)
  titleWnd:SetExtent(320, 35)
  local titleBg = titleWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  titleBg:SetTextureColor("bg_02")
  titleBg:AddAnchor("TOPLEFT", titleWnd, 0, 0)
  titleBg:AddAnchor("BOTTOMRIGHT", titleWnd, 0, 0)
  local title = titleWnd:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.LARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", titleWnd, 19, 11)
  title.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("material_item"))
  local dingbat = W_ICON.DrawDingbat(title)
  dingbat:AddAnchor("RIGHT", title, "LEFT", -5, 0)
  local height = craftingLocale.tabRestore.materialWndHeight
  local anchorY = craftingLocale.tabRestore.materialWndAnchorY
  local materialWnd = window:CreateChildWidget("emptywidget", "materialWnd", 0, true)
  materialWnd:SetExtent((ICON_SIZE.LARGE + 3) * 6 - 3, height)
  materialWnd:AddAnchor("TOP", titleWnd, "BOTTOM", 0, anchorY)
  local offsetX = 0
  local offsetY = 0
  materials = {}
  for i = 1, CRAFT_MAX_COUNT.MATERIAL_ITEM do
    local item = CreateItemIconButton(string.format("item[%d]", i), materialWnd)
    item:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
    item:AddAnchor("TOPLEFT", materialWnd, offsetX, offsetY)
    item:Init()
    if i == 6 then
      offsetX = 0
      offsetY = ICON_SIZE.LARGE + 3
    else
      offsetX = offsetX + ICON_SIZE.LARGE + 3
    end
    materials[i] = item
  end
  window:SetHeight(titleWnd:GetHeight() + anchorY * 2 + materialWnd:GetHeight())
  function window:Clear()
    for i = 1, #materials do
      materials[i]:Init()
    end
  end
  function window:SetInfo(info)
    for i = 1, #materials do
      if info ~= nil and info[i] ~= nil then
        materials[i]:SetItemInfo(info[i])
        materials[i]:SetStack(info[i].stack)
      else
        materials[i]:Init()
      end
    end
  end
  return window
end
local function CreateRestoreFrame(id, parent)
  local window = parent:CreateChildWidget("emptywidget", id, 0, true)
  local restoreBtn = window:CreateChildWidget("button", "restoreBtn", 0, true)
  restoreBtn:SetText(GetCommonText("ok"))
  restoreBtn:AddAnchor("BOTTOMRIGHT", window, "BOTTOM", 0, -3)
  ApplyButtonSkin(restoreBtn, BUTTON_BASIC.DEFAULT)
  restoreBtn:Enable(false)
  local cancelBtn = window:CreateChildWidget("button", "cancelBtn", 0, true)
  cancelBtn:SetText(GetCommonText("cancel"))
  cancelBtn:AddAnchor("BOTTOMLEFT", window, "BOTTOM", 0, -3)
  ApplyButtonSkin(cancelBtn, BUTTON_BASIC.DEFAULT)
  cancelBtn:Enable(true)
  local orderInfo = CreateOrderInfoFrame("restoreOrderInfo", window)
  orderInfo:AddAnchor("TOPLEFT", window, 0, 0)
  orderInfo:AddAnchor("TOPRIGHT", window, 0, 0)
  local arrowAnchorY = craftingLocale.tabRestore.arrowAnchorY
  local arrow = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "down_arrow", "artwork")
  arrow:AddAnchor("TOP", orderInfo, "BOTTOM", 0, arrowAnchorY)
  ApplyTextureColor(arrow, F_COLOR.GetColor("title"))
  local materialInfo = CreateMaterialInfoFrame("materialInfo", window)
  materialInfo:AddAnchor("TOPLEFT", orderInfo, "BOTTOMLEFT", 0, 26 + arrowAnchorY * 2)
  materialInfo:AddAnchor("TOPRIGHT", orderInfo, "BOTTOMRIGHT", 0, 26 + arrowAnchorY * 2)
  local desc = window:CreateChildWidget("textbox", "desc", 0, true)
  desc:SetExtent(300, FONT_SIZE.MIDDLE)
  desc:SetAutoResize(true)
  desc:SetAutoWordwrap(true)
  desc.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(desc, F_COLOR.GetColor("default"))
  desc:AddAnchor("TOP", materialInfo, "BOTTOM", 0, 26)
  local descHeight = 0
  local descStr = craftingLocale.tabRestore.descStr
  if type(descStr) == "table" then
    desc:AddAnchor("TOP", materialInfo, "BOTTOM", 0, 17)
    desc:SetText(descStr[1])
    local desc2 = window:CreateChildWidget("textbox", "desc2", 0, true)
    desc2:SetExtent(300, FONT_SIZE.MIDDLE)
    desc2:SetAutoResize(true)
    desc2:SetAutoWordwrap(true)
    desc2.style:SetAlign(ALIGN_CENTER)
    ApplyTextColor(desc2, F_COLOR.GetColor("red"))
    desc2:AddAnchor("TOP", desc, "BOTTOM", 0, 11)
    desc2:SetText(descStr[2])
    descHeight = desc:GetHeight() + desc2:GetHeight() + 11
  else
    desc:SetText(descStr)
    descHeight = desc:GetHeight()
  end
  function window:Init()
    orderInfo:Clear()
    materialInfo:Clear()
    restoreBtn:Enable(false)
    cancelBtn:Enable(false)
    local _, mY = materialInfo:GetOffset()
    local _, rY = restoreBtn:GetOffset()
    local y = (rY - mY - materialInfo:GetHeight() - descHeight) / 2
    desc:AddAnchor("TOP", materialInfo, "BOTTOM", 0, y)
    self.info = nil
  end
  function CancelBtnFunc()
    window:Init()
    X2Craft:StopCraftOrderSkill()
  end
  ButtonOnClickHandler(cancelBtn, CancelBtnFunc)
  local function RestoreBtnFunc()
    local function DialogHandler(wnd, infoTable)
      wnd:SetTitle(GetUIText(COMMON_TEXT, "restore_craft_order_sheet"))
      wnd:UpdateDialogModule("textbox", craftingLocale.tabRestore.popupContentStr)
      local info = window.info
      if info.craftType == nil then
        local descStr = GetUIText(COMMON_TEXT, "craft_order_count", "-")
        local textData = {type = "default", text = descStr}
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "period", textData)
      else
        local productInfo = X2Craft:GetCraftProductInfo(info.craftType)
        local pInfo = productInfo[1]
        local itemData = {
          itemInfo = X2Item:GetItemInfoByType(pInfo.itemType, info.craftGrade),
          stack = pInfo.amount
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
        local textData = {
          type = "default",
          text = GetUIText(COMMON_TEXT, "craft_order_count_msg", tostring(info.craftCount))
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "period", textData)
      end
      function wnd:OkProc()
        X2Craft:RestoreCraftOrderSheet()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, GetCraftOrderBoard():GetId())
  end
  ButtonOnClickHandler(restoreBtn, RestoreBtnFunc)
  function window:SetInfo(info)
    window:Init()
    window.info = info
    if info ~= nil then
      orderInfo:SetInfo(info)
      cancelBtn:Enable(true)
    end
  end
  function window:SetMaterialInfo(infos)
    materialInfo:SetInfo(infos)
    restoreBtn:Enable(true)
  end
  local events = {
    UPDATE_RESTORE_CRAFT_ORDER_ITEM_SLOT = function(info)
      window:SetInfo(info)
    end,
    UPDATE_RESTORE_CRAFT_ORDER_ITEM_MATERIAL = function(infos)
      window:SetMaterialInfo(infos)
    end,
    UPDATE_CRAFT_ORDER_SKILL = function(key, fired)
      if key ~= "restore" then
        return
      end
      if fired then
        restoreBtn:Enable(false)
      elseif window.info ~= nil then
        restoreBtn:Enable(true)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local function CreateMyListFrame(id, parent)
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
  title:SetText(GetCommonText("my_craft_order_sheet"))
  local titleBg = title:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  titleBg:SetTextureColor("bg_02")
  titleBg:AddAnchor("TOPLEFT", title, 0, 0)
  titleBg:AddAnchor("BOTTOMRIGHT", title, refreshBtn:GetWidth(), 0)
  local line = title:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line:SetExtent(0, 3)
  line:AddAnchor("BOTTOMLEFT", title, 0, 0)
  line:AddAnchor("BOTTOMRIGHT", title, 0, 0)
  local function DataSetFunc(subItem, info, setValue)
    local item = subItem.item
    local itemName = subItem.itemName
    local countValue = subItem.countValue
    local actValue = subItem.actValue
    if setValue and info ~= "" then
      subItem.slotIndex = info.slotIndex
      item:Init()
      subItem:Show(true)
      local craftType = info.craftType
      local count = info.craftCount
      local grade = info.craftGrade
      if craftType == nil then
        F_SLOT.SetItemIcons(item, INVALID_SHEET_ICON)
        ApplyTextColor(itemName, F_COLOR.GetColor("default"))
        itemName:SetText(GetCommonText("invalid_craft_order_sheet"))
        countValue:SetText("-")
        actValue:SetText("-")
      else
        local baseInfo = X2Craft:GetCraftBaseInfo(craftType)
        local productInfo = X2Craft:GetCraftProductInfo(craftType)
        local pInfo = productInfo[1]
        local pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, grade)
        item:SetItemInfo(pItemInfo)
        item:SetStack(pInfo.amount)
        ApplyTextColor(itemName, Hex2Dec(pItemInfo.gradeColor))
        itemName:SetText(pInfo.item_name)
        countValue:SetText(tostring(count))
        if baseInfo.required_actability_type ~= nil then
          actValue:SetText(string.format("%s |,%d;", baseInfo.required_actability_name, baseInfo.required_actability_point))
        else
          actValue:SetText("-")
        end
      end
    else
      subItem.slotIndex = nil
      subItem:Show(false)
    end
  end
  local LayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local item = CreateItemIconButton("item", subItem)
    item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    item:AddAnchor("TOPLEFT", subItem, 15, 7)
    subItem.item = item
    local itemName = subItem:CreateChildWidget("textbox", "itemName", 0, true)
    itemName:SetExtent(300, FONT_SIZE.MIDDLE * 2 + 6)
    itemName.style:SetFontSize(FONT_SIZE.MIDDLE)
    itemName:SetAutoResize(true)
    itemName:SetAutoWordwrap(true)
    itemName:AddAnchor("LEFT", item, "RIGHT", 5, 0)
    itemName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(itemName, F_COLOR.GetColor("default"))
    local countLabel = subItem:CreateChildWidget("label", "countLabel", 0, true)
    countLabel:SetExtent(103, FONT_SIZE.MIDDLE)
    countLabel:AddAnchor("TOPLEFT", item, "BOTTOMLEFT", 0, 9)
    countLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(countLabel, F_COLOR.GetColor("default"))
    countLabel.style:SetAlign(ALIGN_LEFT)
    countLabel:SetText(GetCommonText("craft_order_count"))
    local countValue = subItem:CreateChildWidget("label", "countValue", 0, true)
    countValue:SetHeight(FONT_SIZE.MIDDLE)
    countValue:SetAutoResize(true)
    countValue:AddAnchor("LEFT", countLabel, "RIGHT", 26, 0)
    ApplyTextColor(countValue, F_COLOR.GetColor("default"))
    local actLabel = subItem:CreateChildWidget("label", "actLabel", 0, true)
    actLabel:SetExtent(103, FONT_SIZE.MIDDLE)
    actLabel:AddAnchor("TOPLEFT", countLabel, "BOTTOMLEFT", 0, 5)
    actLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(actLabel, F_COLOR.GetColor("default"))
    actLabel.style:SetAlign(ALIGN_LEFT)
    actLabel:SetText(GetCommonText("actability"))
    local actValue = subItem:CreateChildWidget("textbox", "actValue", 0, true)
    actValue:SetExtent(200, FONT_SIZE.MIDDLE)
    actValue:AddAnchor("LEFT", actLabel, "RIGHT", 26, 0)
    actValue.style:SetFontSize(FONT_SIZE.MIDDLE)
    actValue.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(actValue, F_COLOR.GetColor("default"))
    local detailBtn = subItem:CreateChildWidget("button", "detailBtn", 0, true)
    detailBtn:AddAnchor("RIGHT", subItem, -4, 0)
    ApplyButtonSkin(detailBtn, BUTTON_ICON.SEARCH)
    detailBtn:Enable(true)
    local function DetailBtnFunc()
      X2Craft:SetRestoreCraftOrderSlot(subItem.slotIndex)
    end
    ButtonOnClickHandler(detailBtn, DetailBtnFunc)
    function detailBtn:OnEnter()
      SetTooltip(GetCommonText("show_craft_order"), self)
    end
    detailBtn:SetHandler("OnEnter", detailBtn.OnEnter)
    function detailBtn:OnLeave()
      HideTooltip()
    end
    detailBtn:SetHandler("OnLeave", detailBtn.OnLeave)
  end
  local myList = W_CTRL.CreateScrollListCtrl("myList", window)
  myList:AddAnchor("TOPLEFT", window, 0, 35)
  myList:AddAnchor("BOTTOMRIGHT", window, 0, -5)
  myList:HideColumnButtons()
  myList:InsertColumn("", 413, LCCIT_WINDOW, DataSetFunc, nil, nil, LayoutSetFunc)
  myList:InsertRows(5, false)
  myList.scroll:AddAnchor("TOPRIGHT", myList, 0, 0)
  myList.listCtrl:DrawListLine(nil, true, true)
  function window:Refresh()
    myList:DeleteAllDatas()
    local cnt = 0
    local items = X2Craft:GetMyCraftOrderSheet()
    for i = 1, #items do
      myList:InsertData(i, 1, items[i])
    end
  end
  ButtonOnClickHandler(refreshBtn, window.Refresh)
  return window
end
function CreateCraftOrdeRestoreTab(window)
  local restoreFrame = CreateRestoreFrame("restoreFrame", window)
  restoreFrame:AddAnchor("TOPLEFT", window, 0, 10)
  restoreFrame:AddAnchor("BOTTOMRIGHT", window, "BOTTOMLEFT", 320, -20)
  local myListFrame = CreateMyListFrame("myListFrame", window)
  myListFrame:AddAnchor("TOPLEFT", restoreFrame, "TOPRIGHT", 5, 0)
  myListFrame:AddAnchor("BOTTOMRIGHT", window, 0, -20)
  function window:OnShow()
    X2Craft:SetRestoreCraftOrderSlot(-1)
    myListFrame:Refresh()
    restoreFrame:Init()
  end
  window:SetHandler("OnShow", window.OnShow)
  local events = {
    BAG_UPDATE = function(bagId, slotId)
      if bagId ~= -1 or slotId ~= -1 then
        return
      end
      if window:IsVisible() then
        myListFrame:Refresh()
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
end
