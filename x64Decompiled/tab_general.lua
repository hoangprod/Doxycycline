local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local SUB_WINDOW_GAP = 10
local WINDOW_INSET = {
  left = 0,
  top = sideMargin,
  right = 10,
  bottom = 0
}
local contentLayout = {
  windowInset = {
    left = 10,
    top = 0,
    right = 0,
    bottom = 10
  },
  contentGap = {x = 20, y = 5},
  contentExtent = {width = 160, height = 44},
  useBackground = true
}
local GENERAL_VIEW_KIND = {
  ATTACK_SKILL,
  GENERAL_SKILL,
  JOB_SKILL
}
local CATEGORY_TEXT = {
  locale.skill.attackSkill,
  locale.skill.generalSkill,
  locale.skill.jobRaceSkill
}
local GENERAL_VIEW_COUNT = #GENERAL_VIEW_KIND
local function CreateGeneralSkillWidget(id, parent, index)
  local wnd = CreateEmptyWindow(id, parent)
  wnd:Show(true)
  local bg = CreateContentBackground(wnd, "TYPE3", "brown")
  bg:AddAnchor("TOPLEFT", wnd, -sideMargin, -sideMargin)
  bg:AddAnchor("BOTTOMRIGHT", wnd, sideMargin, sideMargin * 2)
  local skillBookCategory = wnd:CreateChildWidget("label", "skillBookCategory", 0, true)
  skillBookCategory:SetText(CATEGORY_TEXT[index])
  skillBookCategory:SetHeight(20)
  skillBookCategory:AddAnchor("TOPLEFT", wnd, 0, 0)
  skillBookCategory:AddAnchor("TOPRIGHT", wnd, 0, 0)
  skillBookCategory.style:SetFontSize(FONT_SIZE.XLARGE)
  ApplyTextColor(skillBookCategory, FONT_COLOR.HIGH_TITLE)
  local contentWnd = CreateScrollWindow(wnd, "contentWnd", 0)
  contentWnd:AddAnchor("TOPLEFT", skillBookCategory, "BOTTOMLEFT", 0, sideMargin / 2)
  contentWnd:AddAnchor("BOTTOMRIGHT", wnd, 0, 0)
  contentWnd:Show(true)
  contentWnd.skillLabels = {}
  wnd.contentWnd = contentWnd
  local kind = GENERAL_VIEW_KIND[index]
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
    label:SetLimitWidth(true)
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
    local width, _ = self:GetEffectiveExtent()
    local col = 1
    if width > contentLayout.contentExtent.width then
      col = math.floor(width / contentLayout.contentExtent.width)
    end
    local x = contentLayout.windowInset.left
    local y = contentLayout.windowInset.top
    local dx = contentLayout.contentExtent.width + contentLayout.contentGap.x
    local dy = contentLayout.contentExtent.height + contentLayout.contentGap.y
    for i = 1, #contentWnd.labels do
      local label = contentWnd.labels[i]
      label:RemoveAllAnchors()
      label:AddAnchor("TOPLEFT", contentWnd.content, x, y)
      x = x + dx
      if i % col == 0 then
        x = contentLayout.windowInset.left
        y = y + dy
      end
    end
    self:UpdateScroll()
  end
  contentWnd:SetHandler("OnBoundChanged", contentWnd.OnBoundChanged)
  function wnd:Update(kind)
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
  return wnd
end
function CreateGeneralSkillWindow(id, parent)
  local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
  wnd.child = {}
  for i = 1, GENERAL_VIEW_COUNT do
    local child = CreateGeneralSkillWidget(string.format("child[%d]", i), parent, i)
    wnd.child[i] = child
  end
  function wnd:OnBoundChanged()
    local x = WINDOW_INSET.left
    local y = WINDOW_INSET.top
    local width = (wnd:GetWidth() - (GENERAL_VIEW_COUNT - 1) * SUB_WINDOW_GAP) / GENERAL_VIEW_COUNT
    local height = wnd:GetHeight() - (WINDOW_INSET.top + WINDOW_INSET.bottom)
    for i = 1, GENERAL_VIEW_COUNT do
      local child = self.child[i]
      child:RemoveAllAnchors()
      child:AddAnchor("TOPLEFT", self, x, y)
      child:SetExtent(width, height)
      x = x + width + SUB_WINDOW_GAP
      wnd.child[i] = child
    end
  end
  wnd:SetHandler("OnBoundChanged", wnd.OnBoundChanged)
  wnd.Event = {
    UPDATE_SKILL_ACTIVE_TYPE = function()
      for i = 1, GENERAL_VIEW_COUNT do
        wnd.child[i]:Update(GENERAL_VIEW_KIND[i])
        wnd.child[i].contentWnd:UpdateScroll()
      end
    end
  }
  wnd:SetHandler("OnEvent", function(this, event, ...)
    wnd.Event[event](...)
  end)
  RegistUIEvent(wnd, wnd.Event)
  return wnd
end
