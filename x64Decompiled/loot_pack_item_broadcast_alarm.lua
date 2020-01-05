local CreateLootPackItemBroadcastAlarmMessage = function(id, parent)
  local frame = CreateEmptyWindow(id, parent)
  frame:SetExtent(946, 180)
  frame:AddAnchor("TOP", parent, 0, 60)
  frame:SetUILayer("system")
  frame:Clickable(false)
  local bg = frame:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "bg", "background")
  bg:AddAnchor("BOTTOM", frame, 0, 0)
  local arrow = W_ICON.CreateArrowIcon(frame)
  arrow:AddAnchor("BOTTOM", bg, "TOP", 0, MARGIN.WINDOW_SIDE / 2)
  frame.arrow = arrow
  local useStatusBg = frame:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "icon_bg", "artwork")
  useStatusBg:SetExtent(116.1, 74.7)
  useStatusBg:AddAnchor("LEFT", arrow, -86, -MARGIN.WINDOW_SIDE / 2)
  local resultStatusBg = frame:CreateDrawable(TEXTURE_PATH.ALARM_DECO, "result_status_bg", "artwork")
  resultStatusBg:SetExtent(116.1, 74.7)
  resultStatusBg:AddAnchor("RIGHT", arrow, 86, -MARGIN.WINDOW_SIDE / 2)
  local useItemBg = frame:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT_BROADCAST_ALARM, "bg", "artwork")
  useItemBg:AddAnchor("LEFT", useStatusBg, 23, 0)
  frame.useItemBg = useItemBg
  local resultItemBg = frame:CreateDrawable(TEXTURE_PATH.GRADE_ENCHANT_BROADCAST_ALARM, "bg", "artwork")
  resultItemBg:AddAnchor("LEFT", resultStatusBg, 30, 0)
  frame.resultItemBg = resultItemBg
  local useItemIcon = W_ICON.CreateItemIconImage(frame:GetId() .. ".useItemIcon", frame)
  useItemIcon:AddAnchor("CENTER", useItemBg, 1, 2)
  frame.useItemIcon = useItemIcon
  local resultItemIcon = W_ICON.CreateItemIconImage(frame:GetId() .. ".resultItemIcon", frame)
  resultItemIcon:AddAnchor("CENTER", resultItemBg, 1, 2)
  frame.resultItemIcon = resultItemIcon
  local useItemName = frame:CreateChildWidget("label", "useItemName", 0, true)
  useItemName:SetAutoResize(true)
  useItemName:SetHeight(FONT_SIZE.LARGE)
  useItemName.style:SetShadow(true)
  useItemName.style:SetFontSize(FONT_SIZE.LARGE)
  useItemName:AddAnchor("TOP", useItemIcon, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 4)
  frame.useItemName = useItemName
  local resultItemName = frame:CreateChildWidget("label", "resultItemName", 0, true)
  resultItemName:SetAutoResize(true)
  resultItemName:SetHeight(FONT_SIZE.LARGE)
  resultItemName.style:SetShadow(true)
  resultItemName.style:SetFontSize(FONT_SIZE.LARGE)
  resultItemName:AddAnchor("TOP", resultItemIcon, "BOTTOM", 0, MARGIN.WINDOW_SIDE / 4)
  frame.resultItemName = resultItemName
  local content = frame:CreateChildWidget("textbox", "content", 0, true)
  content:SetHeight(FONT_SIZE.XLARGE)
  content.style:SetAlign(ALIGN_CENTER)
  content.style:SetFontSize(FONT_SIZE.XLARGE)
  content.style:SetShadow(true)
  content:AddAnchor("TOP", arrow, "BOTTOM", 0, MARGIN.WINDOW_SIDE * 1.7)
  frame.content = content
  local OnHide = function(self)
    self:ReleaseHandler("OnUpdate")
  end
  frame:SetHandler("OnHide", OnHide)
  local OnEndFadeOut = function(self)
    StartNextImgEvent()
  end
  frame:SetHandler("OnEndFadeOut", OnEndFadeOut)
  local function SetItemNameAlign()
    local width = useItemName:GetWidth()
    if width > 80 then
      useItemName:AddAnchor("RIGHT", useItemIcon, "BOTTOM", 35, MARGIN.WINDOW_SIDE / 1.5)
    end
    width = resultItemName:GetWidth()
    if width > 80 then
      resultItemName:AddAnchor("LEFT", resultItemIcon, "BOTTOM", -35, MARGIN.WINDOW_SIDE / 1.5)
    end
  end
  function frame:SetResult(characterName, useItemLink, resultItemLink)
    local useItemInfo = X2Item:InfoFromLink(useItemLink)
    local resultItemInfo = X2Item:InfoFromLink(resultItemLink)
    local oldGradeColor = X2Item:GradeColor(useItemInfo.itemGrade)
    oldGradeColor = Hex2Dec(oldGradeColor)
    local newGradeColor = X2Item:GradeColor(resultItemInfo.itemGrade)
    newGradeColor = Hex2Dec(newGradeColor)
    ApplyTextureColor(self.useItemBg, oldGradeColor)
    ApplyTextureColor(self.resultItemBg, newGradeColor)
    ApplyTextureColor(self.arrow, newGradeColor)
    ApplyTextColor(self.useItemName, oldGradeColor)
    ApplyTextColor(self.resultItemName, newGradeColor)
    self.useItemIcon:SetItemIconImage(useItemInfo, useItemInfo.itemGrade)
    self.useItemName:SetText(useItemInfo.name)
    self.resultItemIcon:SetItemIconImage(resultItemInfo, resultItemInfo.itemGrade)
    self.resultItemName:SetText(resultItemInfo.name)
    local text = X2Locale:LocalizeUiText(COMMON_TEXT, "broadcast_look_pack_item_alarm", FONT_COLOR_HEX.SOFT_YELLOW, characterName, FONT_COLOR_HEX.SKYBLUE)
    self.content:SetTextAutoWidth(1000, text, 10)
    self.content:SetHeight(self.content:GetTextHeight())
    SetItemNameAlign()
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
lootPackItemBroadcastAlarm = CreateLootPackItemBroadcastAlarmMessage("lootPackItemBroadcastAlarm", "UIParent")
function ShowLootPackItemBroadcastAlarmMessage(characterName, useItemLink, resultItemLink)
  lootPackItemBroadcastAlarm:Show(true, 500)
  lootPackItemBroadcastAlarm:SetResult(characterName, useItemLink, resultItemLink)
  lootPackItemBroadcastAlarm:Raise()
  return true
end
