local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local innerFrameWidth = 313
local CreateProductFrame = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", frame, "TOPLEFT", 15, 11)
  title.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("craft_order_item"))
  local digbat = W_ICON.DrawDingbat(title)
  local titleBg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new_half", "background")
  titleBg:SetTextureColor("default")
  titleBg:AddAnchor("TOPLEFT", frame, -5, -3)
  titleBg:AddAnchor("BOTTOMRIGHT", frame, "TOPRIGHT", 5, 33)
  local item = CreateItemIconButton("item", frame)
  item:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
  item:AddAnchor("TOP", frame, 0, 42)
  frame.item = item
  local name = frame:CreateChildWidget("textbox", "name", 0, true)
  name:SetExtent(350, FONT_SIZE.LARGE)
  name:SetAutoResize(true)
  name:AddAnchor("TOP", item, "BOTTOM", 0, 7)
  name.style:SetAlign(ALIGN_CENTER)
  name.style:SetFontSize(FONT_SIZE.LARGE)
  local spinner = W_ETC.CreateSpinner("spinner", frame)
  spinner:AddAnchor("TOP", name, "BOTTOM", 0, 9)
  spinner.text.style:SetAlign(ALIGN_CENTER)
  spinner.text:SetInset(0, 0, 12, 0)
  spinner:SetValue(1)
  frame.spinner = spinner
  local buttonWidth = 73
  local maxBtn = frame:CreateChildWidget("button", "maxBtn", 0, true)
  maxBtn:SetText(locale.craft.maximum)
  maxBtn:AddAnchor("LEFT", spinner, "RIGHT", 4, 0)
  ApplyButtonSkin(maxBtn, BUTTON_BASIC.DEFAULT)
  maxBtn:SetWidth(buttonWidth)
  function maxBtn:OnEnter()
    if maxBtn.tip ~= nil then
      SetTooltip(maxBtn.tip, self)
    end
  end
  maxBtn:SetHandler("OnEnter", maxBtn.OnEnter)
  function maxBtn:OnLeave()
    HideTooltip()
  end
  maxBtn:SetHandler("OnLeave", maxBtn.OnLeave)
  local maxOrderableCount
  function frame:Clear()
    maxOrderableCount = 0
    spinner:SetValue(1)
    spinner:SetMinMaxValues(1, 1)
    spinner:Enable(false, true)
    maxBtn:Enable(false)
  end
  function frame:SetInfo(info, stack, nameStr, maxCount, gradable)
    item:SetItemInfo(info)
    item:SetStack(stack)
    name:SetText(nameStr)
    ApplyTextColor(name, Hex2Dec(info.gradeColor))
    frame:SetHeight(68 + ICON_SIZE.SLAVE + name:GetHeight() + spinner:GetHeight())
    maxBtn.tip = nil
    maxOrderableCount = maxCount
    if maxCount == 0 then
      spinner:SetValue(1)
      spinner:SetMinMaxValues(1, 1)
      spinner:Enable(false, true)
      maxBtn:Enable(false)
    elseif maxCount == 1 then
      spinner:SetValue(1)
      spinner:SetMinMaxValues(1, 1)
      spinner:Enable(false, true)
      maxBtn:Enable(false)
      if gradable then
        maxBtn.tip = GetCommonText("gradable_craft_order_tip")
      end
    else
      spinner:SetMinMaxValues(1, maxCount)
      spinner:Enable(true, true)
      maxBtn:Enable(true)
    end
  end
  function frame:GetCount()
    return spinner:GetCurValue()
  end
  local function MaxBtnFunc()
    spinner:SetValue(maxOrderableCount)
  end
  ButtonOnClickHandler(maxBtn, MaxBtnFunc)
  return frame
end
local CreateMaterialFrame = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetHeight(craftingLocale.makeCraftOrder.materialFrameHeight)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", frame, "TOPLEFT", 15, 7)
  title.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("material_item"))
  local digbat = W_ICON.DrawDingbat(title)
  local titleBg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new_half_crop", "background")
  titleBg:SetTextureColor("default")
  titleBg:AddAnchor("TOPLEFT", frame, -5, -3)
  titleBg:AddAnchor("BOTTOMRIGHT", frame, "TOPRIGHT", 5, 26)
  local offsetX = 37
  local offsetY = 36
  frame.items = {}
  for i = 1, CRAFT_MAX_COUNT.MATERIAL_ITEM do
    local item = CreateItemIconButton(string.format("item[%d]", i), frame)
    item:SetExtent(ICON_SIZE.LARGE, ICON_SIZE.LARGE)
    item:AddAnchor("TOPLEFT", frame, offsetX, offsetY)
    item:Init()
    if i == 6 then
      offsetX = 37
      offsetY = offsetY + ICON_SIZE.LARGE + 6
    else
      offsetX = offsetX + ICON_SIZE.LARGE + 6
    end
    frame.items[i] = item
  end
  function frame:Clear()
    for i = 1, #frame.items do
      frame.items[i]:Init()
    end
  end
  function frame:SetInfo(info)
    for i = 1, #info do
      if frame.items[i] ~= nil then
        local item = frame.items[i]
        local info = info[i]
        item:SetItemInfo(info.item_info)
        item:SetStack(info.count, info.amount)
        if info.count < info.amount then
          materialSatisfied = false
        end
      end
    end
  end
  return frame
end
local CreateConditionFrame = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetHeight(91)
  local title = frame:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", frame, "TOPLEFT", 15, 11)
  title.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(title, F_COLOR.GetColor("title"))
  title:SetText(GetCommonText("crafter_requirement"))
  local digbat = W_ICON.DrawDingbat(title)
  local titleBg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new_half", "background")
  titleBg:SetTextureColor("default")
  titleBg:AddAnchor("TOPLEFT", frame, -5, -3)
  titleBg:AddAnchor("BOTTOMRIGHT", frame, "TOPRIGHT", 5, 33)
  local actLabel = frame:CreateChildWidget("label", "actLabel", 0, true)
  actLabel:AddAnchor("TOPLEFT", frame, 19, 42)
  actLabel:SetExtent(85, FONT_SIZE.MIDDLE)
  actLabel.style:SetAlign(ALIGN_LEFT)
  actLabel:SetText(GetUIText(CRAFT_TEXT, "require_mastery"))
  ApplyTextColor(actLabel, F_COLOR.GetColor("default"))
  local actValue = frame:CreateChildWidget("textbox", "actValue", 0, true)
  actValue:SetExtent(270, FONT_SIZE.MIDDLE)
  actValue:AddAnchor("LEFT", actLabel, "RIGHT", 7, 0)
  ApplyTextColor(actValue, F_COLOR.GetColor("default"))
  actValue.style:SetAlign(ALIGN_LEFT)
  local lpLabel = frame:CreateChildWidget("label", "lpLabel", 0, true)
  lpLabel:AddAnchor("TOPLEFT", actLabel, "BOTTOMLEFT", 0, 7)
  lpLabel:SetExtent(85, FONT_SIZE.MIDDLE)
  lpLabel.style:SetAlign(ALIGN_LEFT)
  lpLabel:SetText(GetCommonText("consume_lp"))
  ApplyTextColor(lpLabel, F_COLOR.GetColor("default"))
  local lpBarFrame = W_BAR.CreateStatusBar("lpBarFrame", frame, "craft")
  lpBarFrame:SetExtent(270, FONT_SIZE.MIDDLE + 2)
  lpBarFrame:AddAnchor("LEFT", lpLabel, "RIGHT", 7, 0)
  lpBarFrame:SetMinMaxValues(0, 5000)
  lpBarFrame.tip = ""
  function lpBarFrame:OnEnter()
    SetTooltip(lpBarFrame.tip, self)
  end
  lpBarFrame:SetHandler("OnEnter", lpBarFrame.OnEnter)
  function lpBarFrame:OnLeave()
    HideTooltip()
  end
  lpBarFrame:SetHandler("OnLeave", lpBarFrame.OnLeave)
  local color = {
    GetTextureInfo(TEXTURE_PATH.COMMON_GAUGE, "gage"):GetColors().grade_request
  }
  lpBarFrame:SetBarColor(color[1], color[2], color[3], color[4])
  local shadowDeco = lpBarFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "gage_shadow", "artwork")
  lpBarFrame.statusBar:AddAnchorChildToBar(shadowDeco, "TOPLEFT", "TOPRIGHT", 0, 0)
  lpBarFrame.shadowDeco = shadowDeco
  shadowDeco:SetVisible(true)
  local shadowDefault = shadowDeco:GetWidth()
  local valueStr = lpBarFrame:CreateChildWidget("textbox", "valueStr", 0, true)
  valueStr:SetExtent(lpBarFrame:GetWidth(), lpBarFrame:GetHeight())
  valueStr:AddAnchor("CENTER", lpBarFrame, 0, 0)
  valueStr.style:SetFontSize(FONT_SIZE.SMALL)
  function frame:SetActabilityInfo(info)
    actValue:SetText("-")
    if info.required_actability_type ~= nil and info.required_actability_point > 0 then
      actValue:SetText(string.format("%s |,%d;", info.required_actability_name, info.required_actability_point))
    end
  end
  function frame:SetLpInfo(lp)
    lpBarFrame:SetValue(lp)
    valueStr:SetText(string.format("|,%d;/|,%d;", lp, 5000))
    local remain = lpBarFrame:GetWidth() * (5000 - lp) / 5000
    shadowDeco:SetWidth(math.min(shadowDefault, remain))
    shadowDeco:SetVisible(lp > 0)
    lpBarFrame.tip = GetCommonText("craft_order_lp_tooltip", string.format("|,%d;", lp), string.format("|,%d;", 5000), F_COLOR.GetColor("orange", true))
  end
  return frame
end
function CreateMakeOrderWnd(id, parent)
  local window = CreateWindow(id, parent, "make_craft_order")
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "make_craft_order"))
  window:SetExtent(430, 556)
  window:SetSounds("craft")
  window:SetWindowModal(true)
  local msg = window:CreateChildWidget("textbox", "msg", 0, true)
  msg:AddAnchor("TOPLEFT", window, 20, titleMargin)
  msg:AddAnchor("TOPRIGHT", window, -20, titleMargin)
  msg:SetAutoResize(true)
  ApplyTextColor(msg, F_COLOR.GetColor("default"))
  msg:SetText(GetCommonText("make_craft_order_desc", F_COLOR.GetColor("blue", true)))
  local product = CreateProductFrame("product", window)
  product:AddAnchor("TOPLEFT", msg, "BOTTOMLEFT", 0, 10)
  product:AddAnchor("TOPRIGHT", msg, "BOTTOMRIGHT", 0, 10)
  local material = CreateMaterialFrame("material", window)
  material:AddAnchor("TOPLEFT", product, "BOTTOMLEFT", 0, 0)
  material:AddAnchor("TOPRIGHT", product, "BOTTOMRIGHT", 0, 0)
  local condition = CreateConditionFrame("condition", window)
  condition:AddAnchor("TOPLEFT", material, "BOTTOMLEFT", 0, 2)
  condition:AddAnchor("TOPRIGHT", material, "BOTTOMRIGHT", 0, 2)
  condition.baseLp = 0
  local bg1 = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "artwork")
  bg1:SetTextureColor("default")
  bg1:AddAnchor("TOPLEFT", product, -5, 0)
  bg1:AddAnchor("BOTTOMRIGHT", material, 5, 0)
  local bg2 = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "artwork")
  bg2:SetTextureColor("default")
  bg2:AddAnchor("TOPLEFT", condition, -5, 0)
  bg2:AddAnchor("BOTTOMRIGHT", condition, 5, 0)
  local cost = W_MODULE:Create("cost", window, WINDOW_MODULE_TYPE.VALUE_BOX)
  cost:AddAnchor("TOP", condition, "BOTTOM", 0, 7)
  local orderBtn = window:CreateChildWidget("button", "orderBtn", 0, true)
  orderBtn:SetText(GetCommonText("ok"))
  orderBtn:AddAnchor("BOTTOMRIGHT", window, "BOTTOM", 2, -20)
  ApplyButtonSkin(orderBtn, BUTTON_BASIC.DEFAULT)
  local cancelBtn = window:CreateChildWidget("button", "cancelBtn", 0, true)
  cancelBtn:SetText(GetCommonText("cancel"))
  cancelBtn:AddAnchor("BOTTOMLEFT", window, "BOTTOM", 2, -20)
  ApplyButtonSkin(cancelBtn, BUTTON_BASIC.DEFAULT)
  local function OrderBtnFunc()
    X2Craft:MakeCraftOrderSheet(window.craftType, product:GetCount())
  end
  ButtonOnClickHandler(orderBtn, OrderBtnFunc)
  local function CancelBtnFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(cancelBtn, CancelBtnFunc)
  function product:OnTextChanged(value)
    local data = {
      type = "min_order_fee"
    }
    if value == "" or window.craftType == nil then
      data.value = 0
      condition:SetLpInfo(condition.baseLp)
    else
      data.value = F_CALC.MulNum(X2Craft:GetMinCraftOrderFee(window.craftType), tonumber(value))
      condition:SetLpInfo(condition.baseLp * tonumber(value))
    end
    cost:SetData(data)
  end
  function window:Update()
    local craftType = window.craftType
    if craftType == nil then
      return
    end
    local baseInfo = X2Craft:GetCraftBaseInfo(craftType)
    local productInfo = X2Craft:GetCraftProductInfo(craftType)
    local materialInfo = X2Craft:GetCraftMaterialInfo(craftType, 0)
    if productInfo == nil or #productInfo == 0 then
      window:Show(false)
      return
    end
    local pInfo = productInfo[1]
    local pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, NORMAL_ITEM_GRADE, IIK_IMPL)
    local pItemGrade = NORMAL_ITEM_GRADE
    if not pInfo.useGrade then
      for i, v in ipairs(materialInfo) do
        if v.mainGrade then
          pItemGrade = v.item_info.itemGrade
          break
        elseif v.item_info.item_impl == pItemInfo.item_impl and pItemGrade < v.item_info.itemGrade then
          pItemGrade = v.item_info.itemGrade
        end
      end
    else
      pItemGrade = pInfo.productGrade
    end
    pItemInfo = X2Item:GetItemInfoByType(pInfo.itemType, pItemGrade)
    pItemInfo.recommend_level = baseInfo.recommend_level
    local maxCount, gradable = X2Craft:GetCraftOrderableCount(craftType)
    product:SetInfo(pItemInfo, pInfo.amount, pInfo.item_name, maxCount, gradable)
    condition:SetActabilityInfo(baseInfo)
    condition.baseLp = baseInfo.consume_lp
    local money = 0
    local mItemInfo = {}
    for i = 1, #materialInfo do
      local mInfo = materialInfo[i]
      if mInfo.item_info.itemType == MONEY_ITEM_TYPE then
        money = mInfo.amount
      else
        mItemInfo[#mItemInfo + 1] = mInfo
      end
    end
    material:SetInfo(mItemInfo)
    product:OnTextChanged(product:GetCount())
    orderBtn:Enable(maxCount > 0)
  end
  function window:SetInfo(craftType)
    product:Clear()
    material:Clear()
    window.craftType = craftType
    window:Update()
    window:SetHeight(126 + msg:GetHeight() + product:GetHeight() + material:GetHeight() + condition:GetHeight() + orderBtn:GetHeight())
  end
  function window:OnHide()
    window.craftType = nil
    X2Craft:StopCraftOrderSkill()
  end
  window:SetHandler("OnHide", window.OnHide)
  local events = {
    CRAFTING_START = function()
      window:Show(false)
    end,
    BAG_UPDATE = function(bagId, slotId)
      if bagId ~= -1 or slotId ~= -1 then
        return
      end
      if window:IsVisible() then
        window:Update()
      end
    end,
    PLAYER_MONEY = function()
      if window:IsVisible() then
        window:Update()
      end
    end,
    CRAFT_STARTED = function()
      window:Show(false)
    end,
    CRAFT_ENDED = function()
      window:Show(false)
    end,
    CLOSE_CRAFT_ORDER = function()
      window:Show(false)
    end,
    UPDATE_CRAFT_ORDER_SKILL = function(key, fired)
      if key ~= "make" then
        return
      end
      if fired then
        orderBtn:Enable(false)
      elseif window:IsVisible() then
        window:Update()
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local makeOrderWnd = CreateMakeOrderWnd("makeOrderWnd", "UIParent")
makeOrderWnd:AddAnchor("CENTER", "UIParent", 0, 0)
makeOrderWnd:Show(false)
function ToggleMakeOrder(craftType)
  makeOrderWnd:SetInfo(craftType)
  if makeOrderWnd:IsVisible() then
    makeOrderWnd:Raise()
  else
    makeOrderWnd:Show(true)
  end
end
