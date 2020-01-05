conquestStateWnd = nil
function CreateConquestStateWindow()
  window = CreateEmptyWindow("conquestStateWnd", "UIParent")
  window:Show(false)
  function window:MakeOriginWindowPos(reset)
    if window == nil then
      return
    end
    window:RemoveAllAnchors()
    window:SetExtent(280, 50)
    if roadmapSizeButton then
      if reset then
        window:AddAnchor("TOPRIGHT", roadmapSizeButton, "TOPLEFT", F_LAYOUT.CalcDontApplyUIScale(-45), F_LAYOUT.CalcDontApplyUIScale(5))
      else
        window:AddAnchor("TOPRIGHT", roadmapSizeButton, "TOPLEFT", -45, 5)
      end
    elseif reset then
      window:AddAnchor("TOPLEFT", "UIParent", F_LAYOUT.CalcDontApplyUIScale(UIParent:GetScreenWidth() / 2 + 170), F_LAYOUT.CalcDontApplyUIScale(10))
    else
      window:AddAnchor("TOPLEFT", "UIParent", UIParent:GetScreenWidth() / 2 + 170, 10)
    end
  end
  window:MakeOriginWindowPos()
  window.showAll = true
  local bg = CreateContentBackground(window, "TYPE2", "black_2")
  bg:AddAnchor("TOPLEFT", window, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.bg = bg
  local title = window:CreateChildWidget("label", "title", 0, true)
  title:SetHeight(FONT_SIZE.XLARGE)
  title:SetAutoResize(true)
  title:AddAnchor("TOPLEFT", window, 3, 5)
  ApplyTextColor(title, FONT_COLOR.CONQUEST_STATE_VIEW)
  title.style:SetAlign(ALIGN_LEFT)
  title.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
  title:SetText(GetCommonText("conquest_mode"))
  local infoTooltip = window:CreateChildWidget("emptyWidget", "infoTooltip", 0, true)
  local infoTooltipImg = infoTooltip:CreateDrawable(TEXTURE_PATH.HUD, "questionmark", "background")
  infoTooltipImg:SetTextureColor("alpha_45")
  infoTooltip:SetExtent(infoTooltipImg:GetExtent())
  F_LAYOUT.AttachAnchor(infoTooltipImg, infoTooltip)
  infoTooltip:AddAnchor("LEFT", title, "RIGHT", 3, 1)
  local remainTime = window:CreateChildWidget("label", "remainTime", 0, true)
  remainTime:SetExtent(50, FONT_SIZE.XLARGE)
  remainTime:AddAnchor("TOPRIGHT", window, 0, 5)
  ApplyTextColor(remainTime, FONT_COLOR.CONQUEST_STATE_VIEW)
  remainTime.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.XLARGE)
  window.remainTime = remainTime
  local clockImg = window:CreateDrawable(TEXTURE_PATH.HUD, "clock", "background")
  clockImg:AddAnchor("RIGHT", remainTime, "LEFT", 3, 0)
  local itemListFrame = window:CreateChildWidget("emptyWidget", "itemListFrame", 0, true)
  itemListFrame:SetExtent(window:GetWidth(), 20)
  itemListFrame:AddAnchor("TOPRIGHT", remainTime, "BOTTOMRIGHT", -10, 7)
  window.itemListFrame = itemListFrame
  local itemBgImg = itemListFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "my_score_back", "background")
  itemBgImg:SetTextureColor("default")
  itemBgImg:AddAnchor("TOPLEFT", itemListFrame, 0, 0)
  itemBgImg:SetVisible(false)
  window.itemListFrame.itemBgImg = itemBgImg
  local OnEnter = function(self)
    local msg = string.format([[
%s%s
%s%s]], FONT_COLOR_HEX.WHITE, GetCommonText("conquest_info_tooltip_title"), FONT_COLOR_HEX.SOFT_BROWN, GetCommonText("conquest_info_tooltip_msg", FONT_COLOR_HEX.SINERGY))
    SetTooltip(msg, self, false)
  end
  infoTooltip:SetHandler("OnEnter", OnEnter)
  local OnLeave = function()
    HideTooltip()
  end
  infoTooltip:SetHandler("OnLeave", OnLeave)
  window:EnableDrag(true)
  local OnDragStart = function(self)
    if not X2Input:IsShiftKeyDown() then
      return
    end
    window:StartMoving()
    self.moving = true
    X2Cursor:ClearCursor()
    X2Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
  end
  window:SetHandler("OnDragStart", OnDragStart)
  local OnDragStop = function(self)
    if self.moving == true then
      window:StopMovingOrSizing()
      self.moving = false
      X2Cursor:ClearCursor()
    end
  end
  window:SetHandler("OnDragStop", OnDragStop)
  itemListFrame.item = {}
  function window:MakeItem(index)
    local item = itemListFrame:CreateChildWidget("emptyWidget", "item", index, true)
    item:SetExtent(window:GetWidth() - 10, 20)
    item:AddAnchor("TOPRIGHT", itemListFrame, "TOPRIGHT", 0, (index - 1) * item:GetHeight())
    local itemRank = item:CreateChildWidget("label", "itemRank", 0, true)
    itemRank:SetExtent(item:GetWidth() * 0.04, 20)
    itemRank:AddAnchor("LEFT", item, "LEFT", 0, 0)
    itemRank.style:SetAlign(ALIGN_RIGHT)
    F_TEXT.ApplyEllipsisText(itemRank, itemRank:GetWidth())
    item.itemRank = itemRank
    local itemName = item:CreateChildWidget("label", "itemName", 0, true)
    itemName:SetExtent(item:GetWidth() * 0.7, 20)
    itemName:AddAnchor("LEFT", itemRank, "RIGHT", 10, 0)
    itemName.style:SetAlign(ALIGN_LEFT)
    F_TEXT.ApplyEllipsisText(itemName, itemName:GetWidth())
    item.itemName = itemName
    local itemScore = item:CreateChildWidget("label", "itemScore", 0, true)
    itemScore:SetExtent(item:GetWidth() * 0.15, 20)
    itemScore:AddAnchor("LEFT", itemName, "RIGHT", 0, 0)
    itemScore.style:SetAlign(ALIGN_RIGHT)
    item.itemScore = itemScore
    local itemAddScore = item:CreateChildWidget("label", "itemAddScore", 0, true)
    itemAddScore:SetExtent(item:GetWidth() - itemRank:GetWidth() - itemName:GetWidth() - itemScore:GetWidth(), 20)
    itemAddScore:AddAnchor("LEFT", itemScore, "RIGHT", -5, 0)
    itemAddScore.style:SetAlign(ALIGN_RIGHT)
    itemListFrame.item[index] = item
    return item
  end
  function window:ShowItems(isAll)
    local index = 0
    for i = 1, 6 do
      local isShow = false
      local item = itemListFrame.item[i]
      if item then
        local score = tonumber(item.itemScore:GetText())
        if not isAll then
          if i == 1 and score > 0 or item.isMyFaction then
            isShow = true
            index = index + 1
          end
        elseif 0 < string.len(item.itemName:GetText()) then
          isShow = true
          index = index + 1
        end
        item:Show(isShow)
        item:RemoveAllAnchors()
        item:AddAnchor("TOPRIGHT", itemListFrame, "TOPRIGHT", 0, (index - 1) * item:GetHeight())
      end
    end
  end
  function window:AdjustItemFrameHeight(isAll)
    local firstItem = itemListFrame.item[1]
    local lastItem
    if isAll then
      for i = 1, 6 do
        local item = itemListFrame.item[i]
        if item and item:IsVisible() then
          lastItem = item
        end
      end
    else
      for i = 1, 6 do
        local item = itemListFrame.item[i]
        if item and item.isMyFaction then
          lastItem = item
        end
      end
    end
    if lastItem == nil then
      lastItem = firstItem
    end
    local width, height = F_LAYOUT.GetExtentWidgets(firstItem, lastItem)
    itemListFrame:SetExtent(width, height)
    width, height = F_LAYOUT.GetExtentWidgets(self, itemListFrame)
    self:SetExtent(self:GetWidth(), height)
    self.bg:RemoveAllAnchors()
    self.bg:AddAnchor("TOPLEFT", self, -10, -10)
    self.bg:AddAnchor("BOTTOMRIGHT", self, 10, 10)
  end
  function window:AddItem(index, name, score, rank, addScore)
    local itemInfo = itemListFrame.item[index]
    if itemInfo == nil then
      itemInfo = self:MakeItem(index)
    end
    itemInfo.itemName:SetText(name)
    itemInfo.itemScore:SetText(tostring(score))
    itemInfo.itemRank:SetText(tostring(rank))
    if addScore == nil then
      addScore = 0
    end
    if addScore > 0 then
      itemInfo.itemAddScore:SetText(string.format("+%d", addScore))
      ApplyTextColor(itemInfo.itemAddScore, FONT_COLOR.CONQUEST_ADD_SCORE)
    elseif addScore < 0 then
      itemInfo.itemAddScore:SetText(string.format("%d", addScore))
      ApplyTextColor(itemInfo.itemAddScore, FONT_COLOR.CONQUEST_MINUS_SCORE)
    else
      itemInfo.itemAddScore:SetText("")
    end
    itemInfo.isMyFaction = false
    local topLevelId = X2Faction:GetMyTopLevelFaction()
    local topLevelFactionName = X2Faction:GetFactionName(topLevelId, true)
    if topLevelFactionName == name then
      itemInfo.isMyFaction = true
      ApplyTextColor(itemInfo.itemName, FONT_COLOR.FACTION_FRIENDLY_PC)
      ApplyTextColor(itemInfo.itemScore, FONT_COLOR.FACTION_FRIENDLY_PC)
      ApplyTextColor(itemInfo.itemRank, FONT_COLOR.CONQUEST_STATE_VIEW)
      self.itemListFrame.itemBgImg:RemoveAllAnchors()
      self.itemListFrame.itemBgImg:AddAnchor("TOPLEFT", itemInfo, -15, 0)
      self.itemListFrame.itemBgImg:AddAnchor("BOTTOMRIGHT", itemInfo, 15, 0)
      self.itemListFrame.itemBgImg:SetVisible(true)
    else
      ApplyTextColor(itemInfo.itemName, FONT_COLOR.WHITE)
      ApplyTextColor(itemInfo.itemScore, FONT_COLOR.WHITE)
      ApplyTextColor(itemInfo.itemRank, FONT_COLOR.CONQUEST_STATE_VIEW)
    end
    self:ShowItems(window.showAll)
    self:AdjustItemFrameHeight(window.showAll)
  end
  itemListFrame:SetExtent(255, 120)
  window:SetExtent(280, 151)
  window.bg:RemoveAllAnchors()
  window.bg:AddAnchor("TOPLEFT", window, -10, -10)
  window.bg:AddAnchor("BOTTOMRIGHT", window, 10, 10)
  return window
end
