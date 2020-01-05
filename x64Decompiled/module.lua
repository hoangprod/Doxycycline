function CreateWindowModuleTitleBox(id, window)
  local titleFontSize = FONT_SIZE.LARGE
  local titleInset = {
    MARGIN.WINDOW_SIDE,
    10,
    MARGIN.WINDOW_SIDE,
    7
  }
  local bodyInset = {
    MARGIN.WINDOW_SIDE,
    13,
    MARGIN.WINDOW_SIDE,
    15
  }
  local width = window:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local contentWidth = width - MARGIN.WINDOW_SIDE * 2
  local titleWidth = width - MARGIN.WINDOW_SIDE * 2
  local moduleFrame = window:CreateChildWidget("emptywidget", id, 0, true)
  local bodyBg = moduleFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  bodyBg:SetTextureColor("default")
  bodyBg:AddAnchor("TOPLEFT", moduleFrame, 0, 0)
  bodyBg:AddAnchor("BOTTOMRIGHT", moduleFrame, 0, 0)
  local titleBg = moduleFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new_half", "background")
  titleBg:SetTextureColor("default")
  titleBg:AddAnchor("TOPLEFT", moduleFrame, 0, 0)
  local title = moduleFrame:CreateChildWidget("label", "title", 0, false)
  title.style:SetFontSize(titleFontSize)
  ApplyTextColor(title, FONT_COLOR.TITLE)
  function moduleFrame:SetData(data)
    if data == nil then
      return
    end
    if data.title_inset ~= nil then
      titleInset = data.title_inset
    end
    if data.body_inset ~= nil then
      bodyInset = data.body_inset
    end
    title:AddAnchor("TOPLEFT", titleBg, titleInset[1], titleInset[2])
    local moduleHeight = titleInset[2] + titleFontSize + titleInset[4] + bodyInset[2] + bodyInset[4]
    if data.body_bg ~= nil then
      bodyBg:SetTextureInfo(data.body_bg.coords, data.body_bg.color)
    end
    if data.title_bg ~= nil then
      titleBg:SetTextureInfo(data.title_bg.coords, data.title_bg.color)
    end
    title:SetText(data.title)
    if data.align ~= nil then
      title.style:SetAlign(data.align)
    end
    if data.fix_width ~= nil then
      width = data.fix_width
    end
    contentWidth = width - bodyInset[1] - bodyInset[3]
    titleWidth = width - titleInset[1] - titleInset[3]
    if data.title_ellipsis ~= nil then
      title.style:SetEllipsis(data.title_ellipsis)
    end
    self:SetExtent(width, moduleHeight)
    title:SetExtent(titleWidth, titleFontSize)
    titleBg:SetExtent(width, title:GetHeight() + titleInset[2] + titleInset[4])
    self:Refresh()
  end
  moduleFrame.bodies = {}
  function moduleFrame:AddBody(widget, autoResize, anchorInfo)
    moduleFrame.bodies[#moduleFrame.bodies + 1] = widget
    if autoResize ~= false then
      widget:SetWidth(contentWidth)
    end
    if anchorInfo ~= nil then
      local target = #moduleFrame.bodies == 1 and title or moduleFrame.bodies[#moduleFrame.bodies - 1]
      for i, v in ipairs(anchorInfo) do
        widget:AddAnchor(v.myAnchor, target, v.targetAnchor, v.x, v.y)
      end
    elseif #moduleFrame.bodies == 1 then
      widget:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", bodyInset[1] - titleInset[1], titleInset[4] + bodyInset[2])
    else
      widget:AddAnchor("TOP", moduleFrame.bodies[#moduleFrame.bodies - 1], "BOTTOM", 0, MARGIN.WINDOW_SIDE / 2)
    end
    moduleFrame:Refresh()
  end
  function moduleFrame:Refresh()
    if #moduleFrame.bodies == 0 then
      return
    end
    local _, yOffset = F_LAYOUT.GetExtentWidgets(title, moduleFrame.bodies[#moduleFrame.bodies])
    if yOffset == nil then
      return
    end
    local moduleHeight = yOffset + titleInset[2] + bodyInset[4]
    self:SetHeight(moduleHeight)
  end
  return moduleFrame
end
function CreateWindowModuleValueBox(id, window)
  local moduleFrame = window:CreateChildWidget("emptywidget", id, 0, true)
  moduleFrame:SetExtent(290, 24)
  local bg = moduleFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
  bg:SetTextureColor("alpha40")
  bg:AddAnchor("TOPLEFT", moduleFrame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", moduleFrame, 0, 0)
  local LEFT_INSET = 20
  local RIGHT_INSET = 20
  local GUIDE_INSET = 5
  local title = moduleFrame:CreateChildWidget("label", "title", 0, true)
  title:SetAutoResize(true)
  title:SetHeight(FONT_SIZE.MIDDLE)
  title:AddAnchor("LEFT", moduleFrame, LEFT_INSET, 0)
  ApplyTextColor(title, FONT_COLOR.DEFAULT)
  local value = moduleFrame:CreateChildWidget("textbox", "value", 0, false)
  value:SetAutoWordwrap(false)
  value:SetAutoResize(true)
  value:SetHeight(FONT_SIZE.MIDDLE)
  ApplyTextColor(value, FONT_COLOR.DEFAULT)
  local titles = {
    cost = GetUIText(STABLER_TEXT, "cost"),
    labor_power = GetUIText(ATTRIBUTE_TEXT, "labor_power"),
    skill_point = GetUIText(LEARNING_TEXT, "point"),
    recovery_skill_point = GetUIText(COMMON_TEXT, "recovery_skill_point"),
    exp = GetUIText(COMMON_TEXT, "exp"),
    fund_in_hand = GetUIText(REPAIR_TEXT, "myMoney"),
    exchange_fee = GetUIText(COMMON_TEXT, "currency_exchange_fee"),
    min_order_fee = GetUIText(COMMON_TEXT, "min_order_fee"),
    craft_order_instant_additional_fee = GetUIText(COMMON_TEXT, "craft_order_instant_additional_fee"),
    living_point = GetUIText(MONEY_TEXT, "living_point")
  }
  local printIcon = {
    cost = true,
    labor_power = false,
    skill_point = false,
    recovery_skill_point = false,
    exp = false,
    fund_in_hand = true,
    exchange_fee = true,
    min_order_fee = true,
    craft_order_instant_additional_fee = true,
    living_point = true
  }
  local function JustPrintNumber(type)
    return not printIcon[type]
  end
  local guideIcon
  function moduleFrame:SetData(data)
    if data == nil then
      return
    end
    value:RemoveAllAnchors()
    local useGuide = data.guideTooltip ~= nil and data.guideTooltip ~= ""
    if useGuide then
      if guideIcon == nil then
        guideIcon = W_ICON.CreateGuideIconWidget(moduleFrame)
        local OnEnter = function(self)
          if self.tooltip ~= nil and self.tooltip ~= "" then
            SetTooltip(self.tooltip, self)
          end
        end
        guideIcon:SetHandler("OnEnter", OnEnter)
      end
      guideIcon:RemoveAllAnchors()
      guideIcon.tooltip = data.guideTooltip
    end
    if guideIcon ~= nil then
      guideIcon:Show(useGuide)
    end
    if data.showTitle ~= false then
      local titleStr = ""
      if data.type == "cost" and data.currency == CURRENCY_AA_POINT then
        titleStr = GetUIText(INGAMESHOP_TEXT, "myAAPoint")
      else
        titleStr = titles[data.type]
      end
      title:Show(true)
      title:SetText(titleStr)
      if useGuide then
        guideIcon:AddAnchor("RIGHT", moduleFrame, -RIGHT_INSET, 0)
        value:AddAnchor("RIGHT", guideIcon, "LEFT", -GUIDE_INSET, 0)
      else
        value:AddAnchor("RIGHT", moduleFrame, -RIGHT_INSET, 0)
      end
      value.style:SetAlign(ALIGN_RIGHT)
    else
      title:Show(false)
      local alignment = data.valueAlign or ALIGN_RIGHT
      value.style:SetAlign(alignment)
      if alignment == ALIGN_LEFT then
        local inset = data.showBg and LEFT_INSET or 0
        value:AddAnchor("LEFT", moduleFrame, inset, 0)
        if useGuide then
          guideIcon:AddAnchor("LEFT", value, "RIGHT", RIGHT_INSET, 0)
        end
      elseif alignment == ALIGN_RIGHT then
        if useGuide then
          guideIcon:AddAnchor("RIGHT", moduleFrame, -RIGHT_INSET, 0)
          value:AddAnchor("RIGHT", guideIcon, "LEFT", -GUIDE_INSET, 0)
        else
          value:AddAnchor("RIGHT", moduleFrame, -RIGHT_INSET, 0)
        end
      else
        UIParent:LogAlways("[UI] value box module check please. data valueAlign")
      end
    end
    bg:SetVisible(data.showBg == nil and true or data.showBg)
    local valueStr = ""
    if JustPrintNumber(data.type) then
      valueStr = CommaStr(tonumber(data.value))
    elseif data.itemType ~= nil then
      valueStr = F_MONEY:SettingPriceText(data.value, PRICE_TYPE_ITEM, nil, data.itemType)
    else
      valueStr = F_MONEY:GetCostStringByCurrency(data.currency or CURRENCY_GOLD, data.value)
    end
    value:SetText(valueStr)
  end
  return moduleFrame
end
function CreateWindowModuleVerticalHeaderTable(id, window)
  local width = window:GetWidth() - MARGIN.WINDOW_SIDE * 2
  local headerWidth = 170
  local contentWidth = width - headerWidth
  local moduleFrame = window:CreateChildWidget("emptywidget", id, 0, true)
  local headerBg = moduleFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
  headerBg:SetTextureColor("brown")
  headerBg:AddAnchor("TOPLEFT", moduleFrame, 0, 0)
  local headerColor = FONT_COLOR.DEFAULT
  local contentColor = FONT_COLOR.BLUE
  local headerAlign = ALIGN_CENTER
  local contentAlign = ALIGN_LEFT
  local fontSize = FONT_SIZE.MIDDLE
  local lineSpace = 8
  local header = moduleFrame:CreateChildWidget("textbox", "header", 0, false)
  header:SetAutoResize(true)
  local content = moduleFrame:CreateChildWidget("textbox", "content", 0, false)
  content:SetAutoResize(true)
  function moduleFrame:SetData(data)
    if data == nil then
      return
    end
    if data.fix_width ~= nil then
      width = data.fix_width
    end
    if data.header_width ~= nil then
      headerWidth = data.header_width
    end
    contentWidth = width - headerWidth - 2
    if data.font_size ~= nil then
      fontSize = data.font_size
    end
    if data.line_space ~= nil then
      lineSpace = data.line_space
    end
    headerBg:AddAnchor("BOTTOMRIGHT", moduleFrame, "BOTTOMLEFT", headerWidth, 0)
    header:SetExtent(headerWidth, fontSize)
    content:SetExtent(contentWidth, fontSize)
    header.style:SetFontSize(fontSize)
    content.style:SetFontSize(fontSize)
    header:SetLineSpace(lineSpace)
    content:SetLineSpace(lineSpace)
    if data.header_color ~= nil then
      headerColor = data.header_color
    end
    if data.content_color ~= nil then
      contentColor = data.content_color
    end
    if data.header ~= nil then
      header:SetText(data.header)
    end
    if data.content ~= nil then
      content:SetText(data.content)
    end
    header:AddAnchor("TOPLEFT", moduleFrame, 0, 10)
    content:AddAnchor("TOPLEFT", header, "TOPRIGHT", 2, 0)
    local height = 10 + math.max(header:GetHeight(), content:GetHeight()) + 10
    header.style:SetAlign(headerAlign)
    content.style:SetAlign(contentAlign)
    ApplyTextColor(header, headerColor)
    ApplyTextColor(content, contentColor)
    self:SetExtent(width, height)
  end
  return moduleFrame
end
local moduleCreater = {
  [WINDOW_MODULE_TYPE.TITLE_BOX] = CreateWindowModuleTitleBox,
  [WINDOW_MODULE_TYPE.VALUE_BOX] = CreateWindowModuleValueBox,
  [WINDOW_MODULE_TYPE.VERTICAL_HEADER_TABLE] = CreateWindowModuleVerticalHeaderTable
}
W_MODULE = {}
function W_MODULE:Create(id, parent, moduleType, data)
  if moduleCreater[moduleType] == nil then
    return
  end
  local module = moduleCreater[moduleType](id, parent)
  module:SetData(data)
  return module
end
function W_MODULE:CreateFundInHand(id, parent, currency)
  if currency ~= CURRENCY_GOLD and currency ~= CURRENCY_AA_POINT then
    return
  end
  local module = W_MODULE:Create(id, parent, WINDOW_MODULE_TYPE.VALUE_BOX)
  module:SetWidth(235)
  if currency == CURRENCY_GOLD then
    do
      local function moneyEvent(...)
        local data = {
          type = "fund_in_hand",
          value = X2Util:GetMyMoneyString()
        }
        module:SetData(data)
      end
      module:SetHandler("OnEvent", function(this, event, ...)
        moneyEvent(...)
      end)
      module:RegisterEvent("PLAYER_MONEY")
      module:RegisterEvent("ENTERED_WORLD")
      module:RegisterEvent("LEFT_LOADING")
      moneyEvent()
    end
  else
    do
      local function aaPointEvent(...)
        local data = {
          type = "cost",
          currency = CURRENCY_AA_POINT,
          value = X2Util:GetMyAAPointString()
        }
        module:SetData(data)
        if module.Procedure ~= nil then
          module.Procedure()
        end
      end
      module:SetHandler("OnEvent", function(this, event, ...)
        aaPointEvent(...)
      end)
      module:RegisterEvent("PLAYER_AA_POINT")
      aaPointEvent()
    end
  end
  return module
end
