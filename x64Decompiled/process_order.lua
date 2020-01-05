local CreateFeeLayout = function(id, parent)
  local feeInfo = parent:CreateChildWidget("emptywidget", id, 0, true)
  feeInfo:SetExtent(380, 84)
  feeInfo:AddAnchor("TOP", parent.lpLabel, "BOTTOM", 0, 8)
  local feeBg = feeInfo:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  feeBg:SetTextureColor("alpha40")
  feeBg:AddAnchor("TOPLEFT", feeInfo, 0, -5)
  feeBg:AddAnchor("BOTTOMRIGHT", feeInfo, 0, 5)
  local totalLabel = feeInfo:CreateChildWidget("label", "totalLabel", 0, true)
  totalLabel:SetExtent(180, FONT_SIZE.LARGE)
  totalLabel:AddAnchor("TOPLEFT", feeInfo, 15, 10)
  totalLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(totalLabel, F_COLOR.GetColor("title"))
  totalLabel.style:SetAlign(ALIGN_LEFT)
  totalLabel:SetText(GetCommonText("total_gain_money"))
  local totalValue = W_MONEY.CreateDefaultMoneyWindow("totalValue", feeInfo, 150, FONT_SIZE.MIDDLE)
  totalValue:AddAnchor("TOPRIGHT", feeInfo, "TOPRIGHT", -14, 11)
  local line = feeInfo:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "overlay")
  line:SetExtent(0, 3)
  line:AddAnchor("TOPLEFT", feeInfo, 5, 30)
  line:AddAnchor("TOPRIGHT", feeInfo, -5, 30)
  local regLabel = feeInfo:CreateChildWidget("label", "regLabel", 0, true)
  regLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  regLabel:AddAnchor("TOPLEFT", totalLabel, "BOTTOMLEFT", 0, 14)
  regLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(regLabel, F_COLOR.GetColor("default"))
  regLabel.style:SetAlign(ALIGN_LEFT)
  regLabel:SetText(GetCommonText("reg_order_fee"))
  local regValue = W_MONEY.CreateDefaultMoneyWindow("regValue", feeInfo, 150, FONT_SIZE.MIDDLE)
  regValue:AddAnchor("TOPRIGHT", totalValue, "BOTTOMRIGHT", 0, 15)
  local chargeLabel = feeInfo:CreateChildWidget("label", "chargeLabel", 0, true)
  chargeLabel:SetExtent(180, FONT_SIZE.MIDDLE)
  chargeLabel:AddAnchor("TOPLEFT", regLabel, "BOTTOMLEFT", 0, 7)
  chargeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(chargeLabel, F_COLOR.GetColor("default"))
  chargeLabel.style:SetAlign(ALIGN_LEFT)
  chargeLabel:SetText(GetCommonText("craft_order_charge", tostring(math.floor(X2Craft:GetCraftOrderCharge() / 100))))
  local chargeValue = W_MONEY.CreateDefaultMoneyWindow("chargeValue", feeInfo, 150, FONT_SIZE.MIDDLE)
  chargeValue:AddAnchor("TOPRIGHT", regValue, "BOTTOMRIGHT", 0, 7)
  function feeInfo:Update(info)
    if info == nil then
      return
    end
    regValue:Update(info.fee)
    chargeValue:Update(info.chargeFee)
    totalValue:Update(info.totalFee)
  end
  return feeInfo
end
local CreateAdditionalFeeLayout = function(id, parent)
  local additionalFeeInfo = parent:CreateChildWidget("emptywidget", id, 0, true)
  additionalFeeInfo:SetExtent(316, 37)
  additionalFeeInfo:AddAnchor("TOP", parent.name, "BOTTOM", 0, 9)
  local additionalFeeBg = additionalFeeInfo:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  additionalFeeBg:SetTextureColor("alpha40")
  additionalFeeBg:AddAnchor("TOPLEFT", additionalFeeInfo, 0, 0)
  additionalFeeBg:AddAnchor("BOTTOMRIGHT", additionalFeeInfo, 0, 0)
  local additionalFeeLabel = additionalFeeInfo:CreateChildWidget("label", "additionalFeeLabel", 0, true)
  additionalFeeLabel:SetExtent(125, FONT_SIZE.MIDDLE)
  additionalFeeLabel:AddAnchor("TOPLEFT", additionalFeeInfo, "TOPLEFT", 9, 12)
  additionalFeeLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
  ApplyTextColor(additionalFeeLabel, F_COLOR.GetColor("default"))
  additionalFeeLabel.style:SetAlign(ALIGN_LEFT)
  additionalFeeLabel:SetText(GetCommonText("craft_order_instant_additional_fee"))
  local additionalFeeValue = W_MONEY.CreateDefaultMoneyWindow("additionalFeeValue", additionalFeeInfo, 150, FONT_SIZE.MIDDLE)
  additionalFeeValue:AddAnchor("TOPRIGHT", additionalFeeInfo, "TOPRIGHT", -5, 12)
  function additionalFeeInfo:Update(info)
    if info == nil then
      return
    end
    additionalFeeValue:Update(info.additionalFee)
  end
  return additionalFeeInfo
end
local function CreateOrderInfoFrame(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  local bg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bg:SetTextureColor("default")
  bg:AddAnchor("TOPLEFT", frame, -5, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 5, 0)
  local item = CreateItemIconButton("item", frame)
  item:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  item:AddAnchor("TOP", frame, 0, 11)
  frame.item = item
  local name = frame:CreateChildWidget("textbox", "name", 0, true)
  name:SetAutoResize(true)
  name.style:SetAlign(ALIGN_CENTER)
  name.style:SetFontSize(FONT_SIZE.MIDDLE)
  name:SetExtent(232, FONT_SIZE.MIDDLE)
  name:AddAnchor("TOP", item, "BOTTOM", 0, 7)
  local actLabel = frame:CreateChildWidget("textbox", "actLabel", 0, true)
  actLabel:AddAnchor("TOP", name, "BOTTOM", 0, 21)
  actLabel:SetExtent(350, FONT_SIZE.MIDDLE)
  ApplyTextColor(actLabel, F_COLOR.GetColor("default"))
  actLabel.style:SetAlign(ALIGN_LEFT)
  local lpLabel = frame:CreateChildWidget("textbox", "lpLabel", 0, true)
  lpLabel:AddAnchor("TOPLEFT", actLabel, "BOTTOMLEFT", 0, 5)
  lpLabel:SetExtent(350, FONT_SIZE.MIDDLE)
  ApplyTextColor(lpLabel, F_COLOR.GetColor("default"))
  lpLabel.style:SetAlign(ALIGN_LEFT)
  local feeInfo = CreateFeeLayout("feeInfo", frame)
  local additionalFeeInfo = CreateAdditionalFeeLayout("additionalFeeInfo", frame)
  local ftData = {
    [PROCESS_DEFAULT_TYPE] = {
      actLabelShow = true,
      lpLabelShow = true,
      feeShow = true,
      additionalFeeShow = false
    },
    [PROCESS_INSTANT_TYPE] = {
      actLabelShow = false,
      lpLabelShow = false,
      feeShow = false,
      additionalFeeShow = true
    }
  }
  function frame:ChangeProcessType(processType)
    frame.processType = processType
    local processTypeData = ftData[processType]
    actLabel:Show(processTypeData.actLabelShow)
    lpLabel:Show(processTypeData.lpLabelShow)
    feeInfo:Show(processTypeData.feeShow)
    additionalFeeInfo:Show(processTypeData.additionalFeeShow)
  end
  function frame:SetInfo(info)
    local craftType = info.craftType
    local count = info.craftCount
    local grade = info.craftGrade
    local craftBaseInfo = X2Craft:GetCraftBaseInfo(craftType)
    local pProductInfo = X2Craft:GetCraftProductInfo(craftType)[1]
    local pProductItemInfo = X2Item:GetItemInfoByType(pProductInfo.itemType, grade)
    parent:SetResult(pProductItemInfo, pProductInfo.amount * count, pProductInfo.item_name, Hex2Dec(pProductItemInfo.gradeColor))
    item:Init()
    local lastWidget
    local margin = 20
    if frame.processType == PROCESS_DEFAULT_TYPE then
      item:SetItemInfo(pProductItemInfo)
      item:SetStack(pProductInfo.amount * count)
      name:SetText(pProductInfo.item_name)
      ApplyTextColor(name, Hex2Dec(pProductItemInfo.gradeColor))
      if craftBaseInfo.required_actability_type ~= nil then
        actLabel:SetText(string.format("%s: %s |,%d;", GetUIText(CRAFT_TEXT, "require_mastery"), craftBaseInfo.required_actability_name, craftBaseInfo.required_actability_point))
      end
      local fColor = info.enableLp and (info.consumeLp > info.requireLp and F_COLOR.GetColor("green", true) or F_COLOR.GetColor("default", true)) or F_COLOR.GetColor("red", true)
      lpLabel:SetText(string.format("%s%s|,%d;", fColor, GetUIText(CRAFT_TEXT, "require_labor_power"), info.requireLp))
      feeInfo:Update(info)
      margin = 30
      lastWidget = feeInfo
    elseif frame.processType == PROCESS_INSTANT_TYPE then
      NORMAL_GRADE = 0
      local pItemInfo = X2Item:GetItemInfoByType(info.couponItemType, NORMAL_GRADE)
      item:SetItemInfo(pItemInfo)
      item:SetStack(info.couponMyCnt, info.couponReqCnt)
      name:SetText(string.format("[%s]", info.couponName))
      ApplyTextColor(name, Hex2Dec(pItemInfo.gradeColor))
      additionalFeeInfo:Update(info)
      lastWidget = additionalFeeInfo
    end
    local _, height = F_LAYOUT.GetExtentWidgets(frame.item, lastWidget)
    frame:SetHeight(height + margin)
  end
  return frame
end
function CreateProcessOrderWnd(id, parent)
  local window = CreateWindow(id, parent)
  window:SetSounds("craft")
  window:SetWindowModal(true)
  local msg = window:CreateChildWidget("textbox", "msg", 0, true)
  msg:AddAnchor("TOP", window, 0, 50)
  msg:SetHeight(FONT_SIZE.MIDDLE)
  msg:SetAutoResize(true)
  msg:SetAutoWordwrap(true)
  msg.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(msg, F_COLOR.GetColor("default"))
  local orderInfo = CreateOrderInfoFrame("processOrderInfo", window)
  local notice = window:CreateChildWidget("textbox", "notice", 0, true)
  notice:SetAutoResize(true)
  notice:SetAutoWordwrap(true)
  notice.style:SetAlign(ALIGN_CENTER)
  ApplyTextColor(notice, F_COLOR.GetColor("gray"))
  local processBtn = window:CreateChildWidget("button", "processBtn", 0, true)
  processBtn:SetText(GetUIText(COMMON_TEXT, "ok"))
  processBtn:AddAnchor("TOPRIGHT", notice, "BOTTOM", -3, 14)
  ApplyButtonSkin(processBtn, BUTTON_BASIC.DEFAULT)
  local function ProcessBtnFunc()
    if processBtn.processType == PROCESS_DEFAULT_TYPE then
      X2Craft:ProcessCraftOrder(processBtn.entryId)
    elseif processBtn.processType == PROCESS_INSTANT_TYPE then
      X2Craft:ProcessCraftOrderInstant(processBtn.entryId)
    end
  end
  ButtonOnClickHandler(processBtn, ProcessBtnFunc)
  local cancelBtn = window:CreateChildWidget("button", "cancelBtn", 0, true)
  cancelBtn:SetText(GetUIText(COMMON_TEXT, "cancel"))
  cancelBtn:AddAnchor("TOPLEFT", notice, "BOTTOM", 3, 14)
  ApplyButtonSkin(cancelBtn, BUTTON_BASIC.DEFAULT)
  local function CancelBtnFunc()
    window:Show(false)
    X2Craft:StopCraftOrderSkill()
  end
  ButtonOnClickHandler(cancelBtn, CancelBtnFunc)
  function processBtn:OnEnter()
    SetTooltip(processBtn.tip, self)
  end
  processBtn:SetHandler("OnEnter", processBtn.OnEnter)
  function processBtn:OnLeave()
    HideTooltip()
  end
  processBtn:SetHandler("OnLeave", processBtn.OnLeave)
  local buttonTable = {processBtn, cancelBtn}
  AdjustBtnLongestTextWidth(buttonTable, 73)
  local wtData = {
    [PROCESS_DEFAULT_TYPE] = {
      wndTitle = GetCommonText("craft_order_sheet"),
      wndExtent = {430, 455},
      msgText = GetCommonText("process_craft_order_sheet_desc"),
      msgExtent = {
        390,
        FONT_SIZE.MIDDLE
      },
      orderInfoAnchor = {
        "TOP",
        msg,
        "BOTTOM",
        0,
        15
      },
      orderInfoExtent = {390, 250},
      noticeExtent = {
        390,
        FONT_SIZE.MIDDLE
      },
      noticeAnchor = {
        "TOP",
        orderInfo,
        "BOTTOM",
        0,
        13
      },
      noticeText = GetCommonText("process_craft_order_sheet_tip"),
      processBtnText = GetUIText(WINDOW_TITLE_TEXT, "craft"),
      cancelBtnText = GetUIText(QUEST_INTERACTION_TEXT, "craft_cancel")
    },
    [PROCESS_INSTANT_TYPE] = {
      wndTitle = GetCommonText("craft_order_instant"),
      wndExtent = {352, 319},
      msgText = GetCommonText("craft_order_instant_dlg_desc"),
      msgExtent = {
        312,
        FONT_SIZE.MIDDLE
      },
      orderInfoAnchor = {
        "TOP",
        msg,
        "BOTTOM",
        0,
        4
      },
      orderInfoExtent = {322, 127},
      noticeExtent = {
        312,
        FONT_SIZE.MIDDLE
      },
      noticeAnchor = {
        "TOP",
        orderInfo,
        "BOTTOM",
        0,
        9
      },
      noticeText = GetCommonText("craft_order_instant_dlg_tip"),
      processBtnText = GetUIText(COMMON_TEXT, "ok"),
      cancelBtnText = GetUIText(COMMON_TEXT, "cancel")
    }
  }
  function window:ChangeProcessType(processType)
    if window.processType == processType then
      return
    end
    window.processType = processType
    local wndTypeData = wtData[processType]
    window:SetTitle(wndTypeData.wndTitle)
    window:SetExtent(wndTypeData.wndExtent[1], wndTypeData.wndExtent[2])
    msg:SetWidth(wndTypeData.msgExtent[1])
    msg:SetText(wndTypeData.msgText)
    orderInfo:RemoveAllAnchors()
    orderInfo:SetExtent(wndTypeData.orderInfoExtent[1], wndTypeData.orderInfoExtent[2])
    orderInfo:AddAnchor(wndTypeData.orderInfoAnchor[1], wndTypeData.orderInfoAnchor[2], wndTypeData.orderInfoAnchor[3], wndTypeData.orderInfoAnchor[4], wndTypeData.orderInfoAnchor[5])
    orderInfo:ChangeProcessType(processType)
    notice:RemoveAllAnchors()
    notice:SetWidth(wndTypeData.noticeExtent[1])
    notice:AddAnchor(wndTypeData.noticeAnchor[1], wndTypeData.noticeAnchor[2], wndTypeData.noticeAnchor[3], wndTypeData.noticeAnchor[4], wndTypeData.noticeAnchor[5])
    notice:SetText(wndTypeData.noticeText)
    processBtn:SetText(wndTypeData.processBtnText)
    cancelBtn:SetText(wndTypeData.cancelBtnText)
  end
  function window:SetInfo(info)
    window.info = info
    orderInfo:SetInfo(info)
    processBtn.entryId = info.entryId
    processBtn.processType = window.processType
    local enable = false
    local tip
    if window.processType == "process" then
      enable = info.enableLp
      if enable == false then
        tip = GetUIText(ERROR_MSG, "NOT_ENOUGH_LABOR_POWER")
      end
    elseif window.processType == "process_instant" then
      enable = info.enableItem
      if enable == false then
        tip = GetUIText(ERROR_MSG, "NOT_ENOUGH_ITEM")
      end
    end
    local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, window.processBtn)
    local margin = 20
    window:SetHeight(height + margin)
    processBtn:Enable(enable)
    processBtn.tip = tip
  end
  function window:SetResult(itemInfo, stack, itemName, gradeColor)
    window.itemInfo = itemInfo
    window.stack = stack
    window.itemName = itemName
    window.gradeColor = gradeColor
  end
  local events = {
    PROCESS_CRAFT_ORDER = function(result)
      if result then
        window:Show(false)
        local function DialogHandler(wnd)
          wnd:SetTitle(GetUIText(COMMON_TEXT, "complete_process_craft_order"))
          wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "complete_process_craft_order_desc"))
          local data = {
            itemInfo = window.itemInfo,
            stack = window.stack
          }
          wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", data)
        end
        X2DialogManager:RequestNoticeDialog(DialogHandler, GetCraftOrderBoard():GetId())
      end
    end,
    UPDATE_CRAFT_ORDER_SKILL = function(key, fired)
      if key ~= PROCESS_DEFAULT_TYPE and key ~= PROCESS_INSTANT_TYPE then
        return
      end
      if fired then
        processBtn:Enable(false)
      elseif window:IsVisible() then
        window:SetInfo(window.info)
      end
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local processOrderWnd
function ToggleProcessOrder(info, processType)
  if info == nil then
    UIParent:LogAlways(string.format("invalid craft order info data"))
    return
  end
  if processOrderWnd == nil then
    processOrderWnd = CreateProcessOrderWnd("processOrderWnd", "UIParent")
    processOrderWnd:AddAnchor("CENTER", "UIParent", 0, 0)
  end
  processOrderWnd:ChangeProcessType(processType)
  processOrderWnd:SetInfo(info)
  if processOrderWnd:IsVisible() then
    processOrderWnd:Raise()
  else
    processOrderWnd:Show(true)
  end
end
function HideProcessOrder()
  if processOrderWnd ~= nil then
    processOrderWnd:Show(false)
  end
end
