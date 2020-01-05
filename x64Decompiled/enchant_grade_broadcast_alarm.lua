local CreateGradeEnchantBroadcastAlarmMessage = function(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:SetExtent(946, 180)
  frame:AddAnchor("TOP", parent, 0, 60)
  frame:SetUILayer("system")
  frame:Clickable(false)
  local bg = frame:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "bg", "background")
  bg:AddAnchor("BOTTOM", frame, 0, 0)
  local statusBg = frame:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "icon_bg", "artwork")
  statusBg:SetExtent(116.1, 74.7)
  statusBg:AddAnchor("TOP", frame, 0, 0)
  local itemBg = frame:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT_BROADCAST_ALARM, "bg", "artwork")
  itemBg:AddAnchor("CENTER", statusBg, -1, 2)
  frame.itemBg = itemBg
  local itemIcon = W_ICON.CreateItemIconImage(frame:GetId() .. ".itemIcon", frame)
  itemIcon:AddAnchor("CENTER", itemBg, 1, 2)
  frame.itemIcon = itemIcon
  local itemName = frame:CreateChildWidget("label", "itemName", 0, true)
  itemName:SetAutoResize(true)
  itemName:SetHeight(FONT_SIZE.LARGE)
  itemName.style:SetShadow(true)
  itemName.style:SetFontSize(FONT_SIZE.LARGE)
  itemName:AddAnchor("TOP", itemIcon, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 4)
  local arrow = frame:CreateDrawable(TEXTURE_PATH.HUD, "double_arrow", "overlay")
  arrow:AddAnchor("TOP", itemName, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 3.5)
  frame.arrow = arrow
  local oldGradeLabel = frame:CreateChildWidget("label", "oldGradeLabel", 0, true)
  oldGradeLabel:SetAutoResize(true)
  oldGradeLabel:SetHeight(FONT_SIZE.LARGE)
  oldGradeLabel.style:SetShadow(true)
  oldGradeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  oldGradeLabel:AddAnchor("RIGHT", arrow, "LEFT", -2, 0)
  local newGradeLabel = frame:CreateChildWidget("label", "newGradeLabel", 0, true)
  newGradeLabel:SetAutoResize(true)
  newGradeLabel:SetHeight(FONT_SIZE.LARGE)
  newGradeLabel.style:SetShadow(true)
  newGradeLabel.style:SetFontSize(FONT_SIZE.LARGE)
  newGradeLabel:AddAnchor("LEFT", arrow, "RIGHT", 4, 0)
  local content = frame:CreateChildWidget("textbox", "content", 0, true)
  content:SetHeight(FONT_SIZE.XLARGE)
  content.style:SetAlign(ALIGN_CENTER)
  content.style:SetFontSize(FONT_SIZE.XLARGE)
  content.style:SetShadow(true)
  content:AddAnchor("TOP", arrow, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 3)
  local function SetArrowTexture(resultCode)
    if resultCode == IEBCT_ENCHANT_SUCCESS or resultCode == IEBCT_EVOVING then
      frame.arrow:SetCoords(624, 364, 28, 17)
      frame.arrow:SetExtent(28, 17)
    elseif resultCode == IGER_GREAT_SUCCESS then
      frame.arrow:SetCoords(624, 364, 54, 17)
      frame.arrow:SetExtent(54, 17)
    end
  end
  local OnHide = function(self)
    self:ReleaseHandler("OnUpdate")
  end
  frame:SetHandler("OnHide", OnHide)
  local OnEndFadeOut = function(self)
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  function frame:SetResult(characterName, resultCode, itemLink, oldGrade, newGrade)
    local itemInfo = X2Item:InfoFromLink(itemLink)
    local oldGradeColor = X2Item:GradeColor(oldGrade)
    oldGradeColor = Hex2Dec(oldGradeColor)
    local oldGradeName = X2Item:GradeName(oldGrade)
    oldGradeName = string.format("[%s]", oldGradeName)
    local newGradeColor = Hex2Dec(X2Item:GradeColor(newGrade))
    local newGradeColorStr = string.format("|c%s", X2Item:GradeColor(newGrade))
    local newGradeName = X2Item:GradeName(newGrade)
    newGradeName = string.format("[%s]", newGradeName)
    ApplyTextureColor(self.itemBg, newGradeColor)
    ApplyTextureColor(self.arrow, newGradeColor)
    ApplyTextColor(self.oldGradeLabel, oldGradeColor)
    ApplyTextColor(self.newGradeLabel, newGradeColor)
    ApplyTextColor(self.itemName, newGradeColor)
    self.itemIcon:SetItemIconImage(itemInfo, newGrade)
    self.oldGradeLabel:SetText(oldGradeName)
    self.newGradeLabel:SetText(newGradeName)
    self.itemName:SetText(itemInfo.name)
    SetArrowTexture(resultCode)
    local text = ""
    if resultCode == IEBCT_ENCHANT_SUCCESS then
      text = locale.physicalEnchant.broadcast_success_alarm(FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE)
    elseif resultCode == IEBCT_ENCHANT_GREATE_SUCCESS then
      text = locale.physicalEnchant.broadcast_great_success_alarm(FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE)
    elseif resultCode == IEBCT_EVOVING then
      text = locale.physicalEnchant.broadcast_evolving_alarm(FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE, newGradeColorStr, newGradeName)
    end
    self.content:SetTextAutoWidth(1000, text, 10)
    local showTime = 0
    local function OnUpdate(self, dt)
      showTime = dt + showTime
      if showTime >= 3500 then
        self:Show(false, 1000)
        self:ReleaseHandler("OnUpdate")
      end
    end
    self:SetHandler("OnUpdate", OnUpdate)
  end
  function frame:SetScaleResult(characterName, resultCode, itemLink, oldScale, newScale)
    local itemInfo = X2Item:InfoFromLink(itemLink)
    local gradeColor = Hex2Dec(X2Item:GradeColor(itemInfo.itemGrade))
    ApplyTextureColor(self.itemBg, gradeColor)
    ApplyTextureColor(self.arrow, gradeColor)
    ApplyTextColor(self.oldGradeLabel, gradeColor)
    ApplyTextColor(self.newGradeLabel, gradeColor)
    ApplyTextColor(self.itemName, gradeColor)
    self.itemIcon:SetItemIconImage(itemInfo, itemInfo.itemGrade)
    self.oldGradeLabel:SetText(oldScale)
    self.newGradeLabel:SetText(newScale)
    self.itemName:SetText(itemInfo.name)
    SetArrowTexture(resultCode)
    local text = ""
    if resultCode == IEBCT_ENCHANT_SUCCESS then
      text = locale.physicalEnchant.broadcast_scale_success_alarm(FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE)
    elseif resultCode == IEBCT_ENCHANT_GREATE_SUCCESS then
      text = locale.physicalEnchant.broadcast_scale_great_success_alarm(FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE)
    end
    self.content:SetTextAutoWidth(1000, text, 10)
    local showTime = 0
    local function OnUpdate(self, dt)
      showTime = dt + showTime
      if showTime >= 3500 then
        self:Show(false, 1000)
        self:ReleaseHandler("OnUpdate")
      end
    end
    self:SetHandler("OnUpdate", OnUpdate)
  end
  return frame
end
local gradeEnchantBroadcastAlarm = CreateGradeEnchantBroadcastAlarmMessage("gradeEnchantBroadcastAlarm", "UIParent")
function ShowGradeEnchantBroadcastAlarmMessage(characterName, resultCode, itemLink, oldEnchantValue, newEnchantValue)
  if characterName == X2Unit:UnitName("player") then
    return false
  end
  gradeEnchantBroadcastAlarm:Show(true, 500)
  gradeEnchantBroadcastAlarm:SetResult(characterName, resultCode, itemLink, oldEnchantValue, newEnchantValue)
  gradeEnchantBroadcastAlarm:Raise()
  return true
end
function ShowScaleEnchantBroadcastAlarmMessage(characterName, resultCode, itemLink, oldEnchantValue, newEnchantValue)
  if characterName == X2Unit:UnitName("player") then
    return false
  end
  gradeEnchantBroadcastAlarm:Show(true, 500)
  gradeEnchantBroadcastAlarm:SetScaleResult(characterName, resultCode, itemLink, oldEnchantValue, newEnchantValue)
  gradeEnchantBroadcastAlarm:Raise()
  return true
end
