local grade_sound_type = {
  "",
  "",
  "event_item_uncommon_added",
  "event_item_rare_added",
  "event_item_ancient_added",
  "event_item_heroic_added",
  "event_item_unique_added",
  "event_item_artifact_added",
  "event_item_wonder_added",
  "event_item_epic_added",
  "event_item_legendary_added",
  "event_item_mythic_added"
}
local CalcMessageTextExtent = function(widget, topText, bottomText)
  local message_widget_width = widget.style:GetTextWidth(topText)
  local name_textbox_width = widget.itemName:GetLongestLineWidth()
  return math.max(message_widget_width, name_textbox_width) + ICON_SIZE.DEFAULT * 2
end
local function SetItemInfo(item)
  if item == nil then
    return
  end
  local itemType = item.itemType
  local isQuestStartItem = X2Quest:IsQuestStartItem(itemType)
  local isUseItemInActiveQuest = X2Quest:IsUseItemInActiveQuest(itemType)
  local sound_Type = "event_item_added"
  local topText = string.format("%s", locale.chatSystem.get_item)
  if isQuestStartItem == true then
    topText = string.format("%s", locale.chatSystem.get_quest_start_item)
  elseif isUseItemInActiveQuest == true then
    topText = string.format("%s", locale.chatSystem.get_use_item_in_active_quest)
  elseif item.item_impl == "weapon" or item.item_impl == "armor" or item.item_impl == "mate_armor" or item.item_impl == "accessory" then
    topText = string.format("%s", locale.chatSystem.get_quest_item)
    if item.itemGrade < 2 then
      sound_Type = grade_sound_type[item.itemGrade + 1]
    end
  else
    topText = string.format("%s", locale.chatSystem.get_quest_item)
  end
  if topText ~= "" then
    F_SOUND.PlayUISound(sound_Type, true)
    local bottomText = item.name
    addedItemWindow.itemName:SetTextAutoWidth(1000, "|c" .. item.gradeColor .. bottomText, 10)
    local width = CalcMessageTextExtent(addedItemWindow, topText, bottomText)
    addedItemWindow:SetWidth(width)
    addedItemWindow:AddMessage("|c" .. item.gradeColor .. topText)
    addedItemWindow:ResetPosition()
    addedItemWindow:Show(true)
    addedItemWindow.showingTime = 0
    addedItemWindow:SetHandler("OnUpdate", addedItemWindow.OnUpdate)
    addedItemWindow.bg:SetColor(0, 0, 0, 0.5)
    addedItemWindow.bg:SetExtent(width + 60, ICON_SIZE.DEFAULT * 2)
    addedItemWindow.bg:RemoveAllAnchors()
    addedItemWindow.bg:AddAnchor("TOPLEFT", addedItemWindow, -40, -(ICON_SIZE.DEFAULT / 1.8))
    addedItemWindow:Raise()
    addedItemWindow.itemSlot:Show(true)
    addedItemWindow.itemSlot.showingTime = 0
    addedItemWindow.itemSlot:SetItemIconImage(item)
    addedItemWindow.itemSlot:Raise()
  end
end
function ShowAddedItemMsg(item, count)
  if count <= 0 then
    return false
  end
  if addedItemWindow:IsVisible() then
    return false
  end
  if addedItemWindow.itemSlot:HasHandler("OnUpdate") then
    return false
  end
  local OnHide = function(self)
    addedItemWindow.itemSlot:SetHandler("OnUpdate", addedItemWindow.itemSlot.OnUpdate)
  end
  if not addedItemWindow:HasHandler("OnHide") then
    addedItemWindow:SetHandler("OnHide", OnHide)
  end
  local OnEndFadeOut = function(self)
    StartNextImgEvent()
  end
  if not addedItemWindow:HasHandler("OnEndFadeOut") then
    addedItemWindow:SetHandler("OnEndFadeOut", OnEndFadeOut)
  end
  SetItemInfo(item)
  return true
end
function addedItemWindow:OnUpdate(dt)
  self.showingTime = dt + self.showingTime
  local showTime = 3000
  local t = self.showingTime / showTime
  if t > 1 then
    self:Show(false, 2000)
    self:ReleaseHandler("OnUpdate")
  end
end
function LagrangeInterp(t, t0, x0, t1, x1, t2, x2)
  tt0 = t - t0
  tt1 = t - t1
  tt2 = t - t2
  t01 = t0 - t1
  t02 = t0 - t2
  t12 = t1 - t2
  return tt1 * tt2 * x0 / (t01 * t02) - tt0 * tt2 * x1 / (t01 * t12) + tt0 * tt1 * x2 / (t02 * t12)
end
local moveStartTime = 0
local moveDuration = 1000
local midPointXRatio = 0.5
local midPointY = 50
local finalSize = 20
local origSize = addedItemWindow.itemSlot:GetExtent()
local finalPointX = 0
local finalPointY = 0
function addedItemWindow.itemSlot:OnUpdate(dt)
  self.showingTime = dt + self.showingTime
  if not self.moving then
    self.moving = true
    self.x1, self.y1 = self:GetOffset()
    self.x3, self.y3 = GetMainMenuBarButton(MAIN_MENU_IDX.BAG):GetOffset()
    self.x3 = self.x3 + finalPointX
    self.y3 = self.y3 + finalPointY
    self.x2 = self.x1 + (self.x3 - self.x1) * midPointXRatio
    self.y2 = self.y1 + midPointY
  end
  if self.showingTime > moveDuration then
    self:Show(false)
    self.moving = false
    self:ReleaseHandler("OnUpdate")
  else
    local midTime = moveDuration / 2
    local endTime = moveDuration
    local x = LagrangeInterp(self.showingTime, 0, self.x1, midTime, self.x2, endTime, self.x3)
    local y = LagrangeInterp(self.showingTime, 0, self.y1, midTime, self.y2, endTime, self.y3)
    local s = finalSize + (origSize - finalSize) * (endTime - self.showingTime) / moveDuration
    self:SetExtent(s, s)
    self:MoveTo(x, y)
  end
end
