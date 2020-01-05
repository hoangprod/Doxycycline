local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local SUB_WINDOW_GAP = 10
local WINDOW_INSET = {
  left = 0,
  top = sideMargin,
  right = 0,
  bottom = 0
}
local contentLayout = {
  windowInset = {
    left = 0,
    top = 0,
    right = 0,
    bottom = 0
  },
  contentGap = {x = 12, y = 5},
  contentExtent = {width = 200, height = 45}
}
local function AdjustLabelWidgetExtent()
  if IsTransformablePlayer() then
    contentLayout.contentExtent.width = 245
  end
end
function CreateEmotionExpressSkillWindow(id, parent)
  local wnd = CreateEmptyWindow(id, parent)
  local contentWnd = CreateScrollWindow(wnd, "contentWnd", 0)
  contentWnd:AddAnchor("TOPLEFT", wnd, 0, 0)
  contentWnd:AddAnchor("BOTTOMRIGHT", wnd, sideMargin / 2, 0)
  contentWnd:Show(true)
  wnd.contentWnd = contentWnd
  local kind = EMOTION_SKILL
  local count = X2Ability:GetAbilitySlotCount(kind)
  local slotCount = 1
  local hideCount = 0
  contentWnd.labels = {}
  contentWnd.btns = {}
  local function CreateAbilitySlot(widget, kind, i, slotCount)
    local label = widget.content:CreateChildWidget("label", "skillLabel", slotCount, true)
    label:SetInset(50, 0, 0, 0)
    label.style:SetAlign(ALIGN_LEFT)
    label:SetExtent(contentLayout.contentExtent.width, contentLayout.contentExtent.height)
    ApplyTextColor(label, FONT_COLOR.DEFAULT)
    widget.labels[slotCount] = label
    local button = CreateActionSlot(label, "skill", ISLOT_ABILITY_VIEW, kind + i)
    button.onlyView = true
    button:Show(true)
    button:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    button:AddAnchor("TOPLEFT", label, 0, 0)
    widget.btns[slotCount] = button
    local name = X2Ability:GetAbilitySlotName(kind + i)
    if name ~= nil then
      label:SetText(name)
    end
    function button:OnEnter()
      local info = self:GetTooltip()
      if info ~= nil then
        ShowTooltip(info, self)
      end
    end
    button:SetHandler("OnEnter", button.OnEnter)
    function button:OnLeave()
      HideTooltip()
    end
    button:SetHandler("OnLeave", button.OnLeave)
  end
  for i = 1, count do
    local visible = X2Ability:GetAbilitySlotActiveType(kind + i)
    if visible ~= SAT_HIDE then
      CreateAbilitySlot(contentWnd, kind, i, slotCount)
      slotCount = slotCount + 1
    end
  end
  for i = 1, count do
    local visible = X2Ability:GetAbilitySlotActiveType(kind + i)
    if visible == SAT_HIDE then
      CreateAbilitySlot(contentWnd, kind, i, slotCount)
      contentWnd.labels[slotCount]:Show(false)
      contentWnd.btns[slotCount]:Reset()
      slotCount = slotCount + 1
      hideCount = hideCount + 1
    end
  end
  function contentWnd:UpdateScroll()
    local height = 0
    local numLabel = #self.labels - hideCount
    self:ResetScroll(height)
    if numLabel > 0 then
      local _, y = self.scroll:GetOffset()
      local lastLabel = self.labels[numLabel]
      local _, yd1 = lastLabel:GetOffset()
      local _, yd2 = lastLabel:GetExtent()
      height = yd1 + yd2 - y
      height = height + contentLayout.windowInset.bottom
    end
    local scrollRange = self:ResetScroll(height)
    self.scroll:Show(scrollRange > 0)
  end
  function contentWnd:OnBoundChanged()
    local width, _ = self.scroll:GetOffset()
    local col = 1
    if width > contentLayout.contentExtent.width then
      col = math.floor(width / contentLayout.contentExtent.width)
    end
    local x = contentLayout.windowInset.left
    local y = contentLayout.windowInset.top
    local dx = contentLayout.contentExtent.width + contentLayout.contentGap.x
    local dy = contentLayout.contentExtent.height + contentLayout.contentGap.y
    for i = 1, #self.labels do
      local label = self.labels[i]
      label:RemoveAllAnchors()
      label:AddAnchor("TOPLEFT", self.content, x, y)
      x = x + dx
      if i % col == 0 then
        x = contentLayout.windowInset.left
        y = y + dy
      end
    end
    self:UpdateScroll()
  end
  contentWnd:SetHandler("OnBoundChanged", contentWnd.OnBoundChanged)
  function wnd:Update()
    local slotCount = 1
    for i = 1, #wnd.contentWnd.btns do
      local visible = X2Ability:GetAbilitySlotActiveType(kind + i)
      if visible ~= SAT_HIDE then
        local button = wnd.contentWnd.btns[slotCount]
        local label = wnd.contentWnd.labels[slotCount]
        button:EstablishSlot(ISLOT_ABILITY_VIEW, kind + i)
        button:Show(true)
        local name = X2Ability:GetAbilitySlotName(kind + i)
        if name ~= nil then
          label:SetText(name)
        end
        label:Show(true)
        slotCount = slotCount + 1
      end
    end
    hideCount = 0
    for i = 1, #wnd.contentWnd.btns do
      local visible = X2Ability:GetAbilitySlotActiveType(kind + i)
      if visible == SAT_HIDE then
        local button = wnd.contentWnd.btns[slotCount]
        local label = wnd.contentWnd.labels[slotCount]
        button:Reset()
        label:Show(false)
        slotCount = slotCount + 1
        hideCount = hideCount + 1
      end
    end
  end
  wnd.Event = {
    UPDATE_SKILL_ACTIVE_TYPE = function()
      wnd:Update()
      wnd.contentWnd:UpdateScroll()
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    wnd.Event[event](...)
  end)
  RegistUIEvent(wnd, wnd.Event)
  return wnd
end
