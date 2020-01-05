local btnHeight = 30
local maxBtnCount = 10
local windowW = 300
local windowH = btnHeight * maxBtnCount
interactionWindow = CreateEmptyWindow("interactionWindow", "UIParent")
interactionWindow:SetExtent(windowW, windowH)
interactionWindow.button = {}
interactionWindow.simDoodadCode = "none"
local empty = CreateEmptyWindow("WorldInteractionButtonWindow", "UIParent")
interactionWindow.empty = empty
for k = 1, maxBtnCount do
  do
    local button = CreateEmptyButton("WorldInteractionButton" .. k, empty)
    ApplyButtonSkin(button, BUTTON_BASIC.DEFAULT)
    button:SetExtent(100, btnHeight)
    button:Show(false)
    button.interactionId = 0
    function button:OnClick(arg)
      if self.interactionId >= 0 then
        X2Interaction:SelectInteraction(self.interactionId)
      else
        X2Interaction:CancelInteraction()
      end
      HideAllButtons()
    end
    function button:OnUpdate(dt)
      local targetAnimTime = 200
      self.showingTime = self.showingTime + dt
      local animRate = self.showingTime / targetAnimTime
      if animRate > 1 then
        animRate = 1
      end
      button:AddAnchor("TOPLEFT", interactionWindow, "TOPLEFT", 100, btnHeight * 1.3 * k * animRate)
    end
    button:SetHandler("OnClick", button.OnClick)
    button:SetHandler("OnUpdate", button.OnUpdate)
    button:AddAnchor("TOPLEFT", interactionWindow, "TOPLEFT", 100, btnHeight * 1.3 * k)
    interactionWindow.button[k] = button
  end
end
function ResetButtonAnimations()
  for k = 1, maxBtnCount do
    interactionWindow.button[k].showingTime = 0
  end
end
ResetButtonAnimations()
function HideAllButtons()
  for k = 1, maxBtnCount do
    interactionWindow.button[k]:Show(false)
  end
end
function UpdateButton()
  local buttonCount = X2Interaction:GetInteractionSkillCount() or 0
  local interactionId = {}
  local screenSize = {}
  screenSize.x = UIParent:GetScreenWidth()
  screenSize.y = UIParent:GetScreenHeight()
  for k = 1, maxBtnCount do
    interactionWindow.button[k]:Show(false)
  end
  if buttonCount == 0 then
    return
  end
  interactionWindow.empty:Show(true)
  for k = 1, buttonCount do
    interactionId[k] = X2Interaction:GetInteractionSkillId(k)
    local interactionName = X2Interaction:GetInteractionSkillName(k)
    if interactionName == nil then
      interactionWindow.button[k]:SetText("?")
    else
      interactionWindow.button[k]:SetText(interactionName)
    end
    interactionWindow.button[k]:Show(true)
    interactionWindow.button[k].interactionId = interactionId[k]
  end
  interactionWindow.button[buttonCount + 1]:SetText(locale.common.cancel)
  interactionWindow.button[buttonCount + 1]:Show(true)
  interactionWindow.button[buttonCount + 1].interactionId = -1
end
local GetPermissionText = function(index)
  local strTable = {
    X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_0"),
    X2Locale:LocalizeUiText(COMMUNITY_TEXT, "expedition"),
    X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_2"),
    X2Locale:LocalizeUiText(HOUSING_PERMISSIONS_TEXT, "house_permissions_3")
  }
  return strTable[index]
end
local interactionEvents = {
  INTERACTION_START = function()
    local mouse = {}
    mouse.x, mouse.y = X2Input:GetMousePos()
    if mouse.y < windowH / 2 then
      mouse.y = windowH / 2
    end
    if mouse.x < windowW / 2 then
      mouse.x = windowW / 2
    end
    local screenSize = {}
    screenSize.x = UIParent:GetScreenWidth()
    screenSize.y = UIParent:GetScreenHeight()
    if mouse.x + windowW / 2 > screenSize.x then
      mouse.x = screenSize.x - windowW / 2
    end
    if mouse.y + windowH / 2 > screenSize.y then
      mouse.y = screenSize.y - windowH / 2
    end
    interactionWindow:AddAnchor("CENTER", "UIParent", "TOPLEFT", mouse.x, mouse.y)
    UpdateButton()
    ResetButtonAnimations()
  end,
  INTERACTION_END = function()
    HideAllButtons()
  end,
  DRAW_DOODAD_SIGN_TAG = function(tooltip)
    if tooltip == nil then
      HideFixedTooltip()
    else
      local texts = {}
      texts[1] = tooltip
      ClearFixedTooltip()
      FillFixedTooltipLine(texts, fixedTooltip, nil)
      ShowFixedTooltip("doodad")
    end
  end,
  DRAW_DOODAD_TOOLTIP = function(info)
    HideFixedTooltip()
    ClearFixedTooltip()
    local text, lastLineIndex
    local color = FONT_COLOR_HEX.SOFT_BROWN
    local align = ALIGN_CENTER
    if info.alignLeft ~= nil and info.alignLeft then
      align = ALIGN_LEFT
    end
    if info.name ~= nil then
      lastLineIndex = fixedTooltip:AddLine(color .. info.name, "", 0, "left", align, 0)
    end
    if info.explain ~= nil then
      lastLineIndex = fixedTooltip:AddLine(color .. info.explain, "", 0, "left", align, 0)
    end
    if info.goodsValue ~= nil and info.length ~= nil and info.weight ~= nil then
      local str = string.format("%s%s", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "tooltip_ranking_doodod"))
      lastLineIndex = fixedTooltip:AddLine(str, "", 0, "left", align, 0)
      local goodsValue = string.format("%s%s:|r %s%d", FONT_COLOR_HEX.GRAY, GetUIText(COMMON_TEXT, "tooltip_goods_value"), FONT_COLOR_HEX.SINERGY, info.goodsValue)
      lastLineIndex = fixedTooltip:AddLine(goodsValue, "", 0, "left", align, 0)
      local length = string.format("%s%.2f", F_COLOR.GetColor("original_dark_orange", true), info.length / 100)
      local weight = string.format("%s%.2f", F_COLOR.GetColor("original_dark_orange", true), info.weight / 100)
      lastLineIndex = fixedTooltip:AddLine(locale.tooltip.length(length), "", 0, "left", align, 0)
      lastLineIndex = fixedTooltip:AddLine(locale.tooltip.weight(weight), "", 0, "left", align, 0)
    end
    if info.length ~= nil and info.weight ~= nil and info.catched ~= nil then
      local length = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), math.floor(info.length))
      local weight = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), math.floor(info.weight))
      local catched = string.format("%s%s", F_COLOR.GetColor("original_dark_orange", true), locale.time.GetDateToDateFormat(info.catched))
      local fishStr = string.format("%s%s", FONT_COLOR_HEX.GRAY, locale.tooltip.length(string.format("%.2f", tonumber(info.length))))
      fishStr = string.format([[
%s
%s%s]], fishStr, FONT_COLOR_HEX.GRAY, locale.tooltip.weight(string.format("%.2f", tonumber(info.weight))))
      fishStr = string.format([[
%s
%s%s]], fishStr, FONT_COLOR_HEX.GRAY, locale.tooltip.catchedDate(catched))
      lastLineIndex = fixedTooltip:AddLine(fishStr, "", 0, "left", align, 0)
      fixedTooltip:AttachUpperSpaceLine(lastLineIndex, 3)
      fixedTooltip:AttachLowerSpaceLine(lastLineIndex, 3)
    end
    if info.owner ~= nil then
      local ownerStr = string.format("%s: %s", locale.tooltip.owner, info.owner)
      if info.dtype ~= nil and info.id ~= nil and info.ptype ~= nil then
        ownerStr = ownerStr .. " (" .. info.dtype .. "/" .. info.id .. "/" .. info.ptype .. ")"
      end
      lastLineIndex = fixedTooltip:AddLine(color .. ownerStr, "", 0, "left", align, 0)
    end
    if info.permission ~= nil then
      local str = string.format("%s: %s", X2Locale:LocalizeUiText(HOUSING_TEXT, "permission"), GetPermissionText(info.permission))
      lastLineIndex = fixedTooltip:AddLine(color .. str, "", 0, "left", align, 0)
    end
    if info.progress ~= nil then
      local str = string.format("%s: %d / %d", locale.tooltip.progressCount, info.progress.curCount, info.progress.maxCount)
      lastLineIndex = fixedTooltip:AddLine(str, "", 0, "left", align, 0)
    end
    if info.loadedItemName ~= nil then
      local str = string.format("%s%s", F_COLOR.GetColor("medium_yellow", true), info.loadedItemName)
      lastLineIndex = fixedTooltip:AddLine(str, "", 0, "left", align, 0)
    end
    if info.freshnessRemainTime ~= nil then
      local remainTime = string.format("%s", locale.time.GetRemainDateToDateFormat(info.freshnessRemainTime, DATE_FORMAT_FILTER1))
      str = string.format("%s%s", F_COLOR.GetColor("medium_yellow", true), X2Locale:LocalizeUiText(COMMON_TEXT, "freshness_remain_time", remainTime), tooltip)
      lastLineIndex = fixedTooltip:AddLine(str, "", 0, "left", align, 0)
    end
    if info.freshnessTooltip ~= nil then
      local str = string.format("%s%s", F_COLOR.GetColor("medium_yellow", true), info.freshnessTooltip)
      lastLineIndex = fixedTooltip:AddLine(str, "", 0, "left", align, 0)
    end
    if info.displayTime ~= nil and 0 < info.displayTime then
      local labelStr = info.timeLabel or locale.tooltip.leftTime
      local growingStr = string.format("%s %s", labelStr, MakeTimeString(info.displayTime))
      lastLineIndex = fixedTooltip:AddLine(color .. growingStr, "", 0, "left", align, 0)
    end
    if info.isFree ~= nil and info.isFree == true then
      lastLineIndex = fixedTooltip:AddLine(color .. locale.tooltip.freeLooting, "", 0, "left", align, 0)
    end
    if info.crafterName ~= nil then
      local str = string.format("%s: %s", locale.tooltip.crafter, info.crafterName)
      lastLineIndex = fixedTooltip:AddLine(F_COLOR.GetColor("medium_yellow", true) .. str, "", 0, "left", align, 0)
    end
    if lastLineIndex ~= nil then
      ShowFixedTooltip("doodad")
    end
  end,
  SIM_DOODAD_MSG = function(code)
    if code == nil then
      HideTooltip()
      interactionWindow.simDoodadCode = "none"
    elseif interactionWindow.simDoodadCode ~= code then
      SetTooltip(code)
      interactionWindow.simDoodadCode = code
    end
  end
}
interactionWindow:SetHandler("OnEvent", function(this, event, ...)
  interactionEvents[event](...)
end)
interactionWindow:RegisterEvent("INTERACTION_START")
interactionWindow:RegisterEvent("INTERACTION_END")
interactionWindow:RegisterEvent("DRAW_DOODAD_SIGN_TAG")
interactionWindow:RegisterEvent("DRAW_DOODAD_TOOLTIP")
interactionWindow:RegisterEvent("SIM_DOODAD_MSG")
interactionWindow:Show(false)
