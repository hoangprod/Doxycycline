local CreateEtcEnchantAlarmMessage = function(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:SetExtent(370, 95)
  local closeButton = frame:CreateChildWidget("button", "closeBtn", 0, true)
  ApplyButtonSkin(closeButton, BUTTON_HUD.RISK_ALARM_CLOSE)
  closeButton:AddAnchor("TOPRIGHT", frame, -MARGIN.WINDOW_SIDE / 4, MARGIN.WINDOW_SIDE / 4)
  function closeButton:OnClick()
    frame:Show(false)
  end
  closeButton:SetHandler("OnClick", closeButton.OnClick)
  local bg = CreateContentBackground(frame, "TYPE1", "black")
  bg:AddAnchor("TOPLEFT", frame, -12, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 18, 0)
  local icon = W_ICON.CreateItemIconImage(frame:GetId() .. ".icon", frame)
  icon:SetExtent(ICON_SIZE.SLAVE, ICON_SIZE.SLAVE)
  icon:AddAnchor("LEFT", frame, MARGIN.WINDOW_SIDE, 0)
  frame.icon = icon
  local failTexture = icon:CreateDrawable(TEXTURE_PATH.ITEM_DIAGONAL_LINE, "line", "overlay")
  failTexture:SetTextureColor("red")
  failTexture:SetVisible(false)
  failTexture:AddAnchor("CENTER", icon, 0, 0)
  icon.failTexture = failTexture
  local topText = frame:CreateChildWidget("label", "topText", 0, true)
  topText:SetHeight(FONT_SIZE.XLARGE)
  topText.style:SetFontSize(FONT_SIZE.XLARGE)
  topText.style:SetShadow(true)
  topText:SetAutoResize(true)
  local middleText = frame:CreateChildWidget("textbox", "middleText", 0, true)
  middleText:SetExtent(1000, FONT_SIZE.LARGE)
  middleText.style:SetFontSize(FONT_SIZE.LARGE)
  middleText.style:SetShadow(true)
  middleText:SetAutoResize(true)
  middleText.style:SetAlign(ALIGN_LEFT)
  local bottomText = frame:CreateChildWidget("label", "bottomText", 0, true)
  bottomText:SetHeight(FONT_SIZE.LARGE)
  bottomText.style:SetFontSize(FONT_SIZE.LARGE)
  bottomText.style:SetShadow(true)
  bottomText:SetAutoResize(true)
  local OnHide = function(self)
    self:ReleaseHandler("OnUpdate")
  end
  frame:SetHandler("OnHide", OnHide)
  local function GetTopText(resultCode, enchantType)
    if enchantType == "smelting" then
      if resultCode == 1 then
        return GetCommonText("item_smelting_top_text_success")
      elseif resultCode == 2 then
        return GetCommonText("item_smelting_top_text_great_success")
      else
        return GetCommonText("item_smelting_top_text_fail")
      end
    elseif resultCode == 1 then
      ApplyTextColor(topText, FONT_COLOR.SKYBLUE)
      local texts = {
        socket = GetCommonText("socket_enchant_success"),
        gem = GetCommonText("gem_enchant_success"),
        refurbishment = GetCommonText("refurbishment_success"),
        socket_upgrade = GetCommonText("item_socket_upgrade_success")
      }
      if texts[enchantType] == nil then
        return ""
      end
      return texts[enchantType]
    else
      ApplyTextColor(topText, FONT_COLOR.RED)
      return GetCommonText("socket_enchant_fail")
    end
  end
  local function GetMiddleText(resultCode, resultInfo)
    if resultInfo.enchantType == "socket" then
      if resultCode ~= 2 then
        return ""
      end
      ApplyTextColor(middleText, FONT_COLOR.WHITE)
      return GetCommonText("socket_enchant_fail_desc")
    elseif resultInfo.enchantType == "smelting" then
      return ""
    end
    return ""
  end
  local function GetBottomText(resultCode, info)
    local color = Hex2Dec(info.gradeColor)
    ApplyTextColor(bottomText, color)
    return string.format("[%s]", info.name)
  end
  local function GetWidth()
    local width = math.max(frame.topText:GetWidth(), frame.bottomText:GetWidth())
    if middleText:GetText() ~= "" then
      width = math.max(width, middleText:GetText())
    end
    width = frame.icon:GetWidth() + width + MARGIN.WINDOW_SIDE * 2.5 + closeButton:GetWidth()
    return math.min(math.max(width, 220), 720)
  end
  local showTime = 0
  function frame:SetResult(resultCode, itemType, resultInfo)
    local itemInfo = X2Item:GetItemInfoByType(itemType)
    if itemInfo == nil then
      return
    end
    icon:Show(false)
    topText:Show(false)
    middleText:Show(false)
    bottomText:Show(false)
    bg:SetVisible(false)
    self:Show(true, 300)
    local isFailed = (resultCode == 0 or resultCode == 2) and true or false
    if resultInfo.enchantType == "smelting" then
      isFailed = false
    end
    self.icon:SetItemIconImage(itemInfo, itemInfo.itemGrade)
    self.icon.failTexture:SetVisible(isFailed)
    self.icon:SetOverlayColor(ICON_BUTTON_OVERLAY_COLOR.BLACK)
    self.icon.overlay:SetVisible(isFailed)
    self.topText:SetText(GetTopText(resultCode, resultInfo.enchantType))
    self.bottomText:SetText(GetBottomText(resultCode, itemInfo))
    local middleStr = GetMiddleText(resultCode, resultInfo)
    if middleStr == "" then
      middleText:SetText("")
      topText:AddAnchor("TOPLEFT", icon, "TOPRIGHT", 5, 7)
      bottomText:AddAnchor("TOPLEFT", topText, "BOTTOMLEFT", 0, 5)
    else
      middleText:SetTextAutoWidth(1000, middleStr, 20)
      topText:AddAnchor("TOPLEFT", icon, "TOPRIGHT", 5, 7 - middleText:GetHeight() / 2)
      middleText:AddAnchor("TOPLEFT", topText, "BOTTOMLEFT", 0, 3)
      bottomText:AddAnchor("TOPLEFT", middleText, "BOTTOMLEFT", 0, 3)
    end
    self:SetWidth(GetWidth())
    local width = math.max(frame.topText:GetWidth(), frame.bottomText:GetWidth()) + self.icon:GetWidth() + 5
    self.icon:AddAnchor("LEFT", frame, (frame:GetWidth() - width) / 2 - 25, 0)
    showTime = 0
    local visibleTime = 300
    local function OnUpdate(self, dt)
      icon:Show(true, visibleTime)
      topText:Show(true, visibleTime)
      if middleStr ~= "" then
        middleText:Show(true, visibleTime)
      end
      bottomText:Show(true, visibleTime)
      bg:SetVisible(true)
      showTime = dt + showTime
      if showTime >= 4000 then
        self:Show(false, 500)
        self:ReleaseHandler("OnUpdate")
      end
    end
    self:SetHandler("OnUpdate", OnUpdate)
  end
  return frame
end
etcEnchantAlarm = CreateEtcEnchantAlarmMessage("etcEnchantAlarm", "UIParent")
function ShowEtcEnchantAlarmMessage(resultCode, itemType, resultInfo)
  etcEnchantAlarm:SetResult(resultCode, itemType, resultInfo)
  etcEnchantAlarm:Raise()
  etcEnchantAlarm:RemoveAllAnchors()
  etcEnchantAlarm:AddAnchor("TOP", "UIParent", 0, 70)
end
