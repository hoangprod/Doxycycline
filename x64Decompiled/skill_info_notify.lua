local skillInfoNotifier
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local OnCreateWindow = function(widget)
  widget:EnableHidingIsRemove(true)
end
local function OnDestroyWindow()
  skillInfoNotifier = nil
end
local CreateUpgradedSkillTextboxWithName = function(parent, id, index)
  local textbox = parent:CreateChildWidget("textbox", id, index, true)
  textbox:Show(true)
  textbox:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  textbox:SetInset(50, 0, 0, 0)
  textbox.style:SetAlign(ALIGN_LEFT)
  textbox.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  ApplyTextColor(textbox, FONT_COLOR.TITLE)
  local skillBtn = CreateActionSlot(textbox, "skillBtn", ISLOT_CONSTANT, 0)
  skillBtn:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  skillBtn:AddAnchor("LEFT", textbox, 0, 0)
  skillBtn:Show(true)
  skillBtn.useView = true
  function textbox:SetSkillInfo(skillInfo)
    local infoText = string.format([[
%s
%s]], skillInfo.name, locale.skill.GetSkillChangedText(skillInfo.skillLevel))
    self:SetText(infoText)
    skillInfo.learn = "master"
    skillBtn:EstablishSkill(skillInfo.type)
  end
  return textbox
end
local CreateNewAbilityLabel = function(parent, id, index)
  local label = parent:CreateChildWidget("label", id, index, true)
  label:SetInset(50, 0, 0, 0)
  label.style:SetAlign(ALIGN_LEFT)
  label:SetText(locale.skill.newAbilityActivatable)
  label.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(label, FONT_COLOR.BLUE)
  local flameIcon = W_ICON.DrawSkillFlameIcon(label)
  flameIcon:AddAnchor("LEFT", label, 10, -2)
  label.flameIcon = flameIcon
  return label
end
local CreateNewSkillPointLabel = function(parent, id, index, point)
  local label = parent:CreateChildWidget("label", id, index, true)
  label:SetInset(50, 0, 0, 0)
  label.style:SetAlign(ALIGN_LEFT)
  label:SetText(locale.skill.GetNewSkillPointText(point))
  label.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(label, FONT_COLOR.BLUE)
  local flameIcon = W_ICON.DrawSkillFlameIcon(label)
  flameIcon:AddAnchor("LEFT", label, 10, -2)
  label.flameIcon = flameIcon
  return label
end
local function CreateSkillInfoNotifyWindow(id, parent)
  local wnd = CreateWindow(id, parent)
  wnd:AddAnchor("RIGHT", parent, -300, 0)
  wnd:SetExtent(POPUP_WINDOW_WIDTH, 300)
  wnd:SetTitle(locale.skill.skill_notify_title)
  ADDON:RegisterContentWidget(UIC_NOTIFY_SKILL, wnd)
  local scrollWnd = CreateScrollWindow(wnd, "scrollWnd", 0)
  scrollWnd:Show(true)
  scrollWnd:AddAnchor("TOPLEFT", wnd, sideMargin, titleMargin)
  scrollWnd:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin, bottomMargin + -sideMargin / 2)
  wnd.scrollWnd = scrollWnd
  local okBtn = wnd:CreateChildWidget("button", "okBtn", 0, true)
  okBtn:SetText(locale.common.ok)
  okBtn:AddAnchor("BOTTOMRIGHT", wnd, -sideMargin, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(okBtn, BUTTON_BASIC.DEFAULT)
  local function OkBtnLeftClickFunc()
    wnd:Show(false)
  end
  ButtonOnClickHandler(okBtn, OkBtnLeftClickFunc)
  local skillOpenBtn = wnd:CreateChildWidget("button", "skillOpenBtn", 0, true)
  skillOpenBtn:Show(true)
  skillOpenBtn:SetText(locale.skill.openSkillWindow)
  skillOpenBtn:AddAnchor("BOTTOMLEFT", wnd, sideMargin, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(skillOpenBtn, BUTTON_BASIC.DEFAULT)
  local SkillOpenBtnLeftClickFunc = function()
    ADDON:ShowContent(UIC_SKILL, true)
  end
  ButtonOnClickHandler(skillOpenBtn, SkillOpenBtnLeftClickFunc)
  local buttonTable = {skillOpenBtn, okBtn}
  AdjustBtnLongestTextWidth(buttonTable)
  wnd.children = {}
  local INSET = {
    left = 0,
    top = 0,
    right = 70,
    bottom = 10
  }
  local CONTENT_GAP = sideMargin / 1.5
  local CONTENT_HEIGHT = 50
  local ABILITY_ORDER = 1
  local POINT_ORDER = 2
  local SKILL_ORDER = 3
  function wnd:GenerateChildIndex()
    if self.childIdx == nil then
      self.childIdx = 0
    end
    self.childIdx = self.childIdx + 1
    return self.childIdx
  end
  function wnd:AddSkill(skillType, level)
    local skillInfo = X2Skill:GetSkillTooltip(skillType, 0)
    if skillInfo.type == nil then
      return
    end
    local scrollContentWnd = self.scrollWnd.content
    local index = self:GenerateChildIndex()
    local label = CreateUpgradedSkillTextboxWithName(scrollContentWnd, "upgradedSkill", index)
    label:SetSkillInfo(skillInfo)
    self:AddChild(label, SKILL_ORDER, index)
  end
  function wnd:AddAbility()
    local scrollContentWnd = self.scrollWnd.content
    local index = self:GenerateChildIndex()
    local label = CreateNewAbilityLabel(scrollContentWnd, "newAbility", index)
    self:AddChild(label, ABILITY_ORDER, index)
  end
  function wnd:AddPoint(point)
    local scrollContentWnd = self.scrollWnd.content
    local index = self:GenerateChildIndex()
    local label = CreateNewSkillPointLabel(scrollContentWnd, "newPoint", index, point)
    self:AddChild(label, POINT_ORDER, index)
  end
  function wnd:AddChild(child, order, subOrder)
    local width = self:GetWidth()
    local contentWidth = width - (INSET.left + INSET.right)
    child:SetExtent(contentWidth, CONTENT_HEIGHT)
    DrawTargetLine(child)
    child.line:RemoveAllAnchors()
    child.line:AddAnchor("TOPLEFT", child, "BOTTOMLEFT", 0, 4)
    child.line:AddAnchor("TOPRIGHT", child, "BOTTOMRIGHT", 10, 4)
    child.order = order
    child.subOrder = subOrder
    table.insert(self.children, child)
    self:SortChildren()
    self:RelocateChildren()
    self:UpdateScroll()
  end
  function wnd:SortChildren()
    local sorter = function(a, b)
      if a.order < b.order then
        return true
      elseif a.order == b.order then
        return a.subOrder < b.subOrder
      end
      return false
    end
    table.sort(self.children, sorter)
  end
  function wnd:RelocateChildren()
    if #self.children == 0 then
      return
    end
    local scrollContentWnd = self.scrollWnd.content
    self.children[1]:RemoveAllAnchors()
    self.children[1]:AddAnchor("TOPLEFT", scrollContentWnd, INSET.left, INSET.top)
    self.children[1].line:SetVisible(true)
    for i = 2, #self.children do
      local child = self.children[i]
      local target = self.children[i - 1]
      child:RemoveAllAnchors()
      child:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", 0, CONTENT_GAP)
      child.line:SetVisible(true)
    end
    local line = self.children[#self.children].line
    if line then
      line:SetVisible(false)
    end
  end
  function wnd:UpdateScroll()
    local height = 0
    local numLabel = #self.children
    self.scrollWnd:ResetScroll(0)
    if numLabel > 0 then
      local _, y = self.scrollWnd:GetOffset()
      local lastLabel = self.children[numLabel]
      local _, yd1 = lastLabel:GetOffset()
      local _, yd2 = lastLabel:GetExtent()
      height = yd1 + yd2 - y
      height = height + INSET.bottom
    end
    local scrollRange = self.scrollWnd:ResetScroll(height)
    local needScroll = scrollRange ~= 0
    self.scrollWnd.scroll:Show(needScroll)
  end
  function wnd:OnHide()
    OnDestroyWindow()
  end
  wnd:SetHandler("OnHide", wnd.OnHide)
  function wnd:OkBtn_ReanchorAndShow()
    if self.have_skill_point then
      self.skillOpenBtn:Show(true)
      self.okBtn:RemoveAllAnchors()
      self.okBtn:AddAnchor("BOTTOMRIGHT", self, -(sideMargin + 5), BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    else
      self.skillOpenBtn:Show(false)
      self.okBtn:RemoveAllAnchors()
      self.okBtn:AddAnchor("BOTTOM", self, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
    end
  end
  function wnd:ShowProc()
    self.have_skill_point = false
  end
  OnCreateWindow(wnd)
  return wnd
end
local function ShowNotifyer()
  if skillInfoNotifier == nil then
    skillInfoNotifier = CreateSkillInfoNotifyWindow("skillInfoNotifier", "UIParent")
  end
  if not skillInfoNotifier:IsVisible() then
    skillInfoNotifier:Show(true)
  end
end
function ToggleSkillNotifyer(isShow)
  if skillInfoNotifier == nil then
    return
  end
  if isShow == nil then
    isShow = not skillInfoNotifier:IsVisible()
  end
  skillInfoNotifier:Show(isShow)
end
local function AddSkillToSkillInfoNotifier(skillType)
  ShowNotifyer()
  skillInfoNotifier:AddSkill(skillType, level)
  skillInfoNotifier:OkBtn_ReanchorAndShow()
end
local function AddAbilityToSkillInfoNotifier()
  local level = X2Unit:UnitLevel("player")
  if level == ABILITY_ACTIVATION_LEVEL_2 or level == ABILITY_ACTIVATION_LEVEL_3 then
    ShowNotifyer()
    skillInfoNotifier:AddAbility()
    skillInfoNotifier:OkBtn_ReanchorAndShow()
  end
end
local function AddSkillPointToSkillInfoNotifier(point)
  ShowNotifyer()
  point = point or 1
  skillInfoNotifier:AddPoint(point)
  skillInfoNotifier.have_skill_point = true
  skillInfoNotifier:OkBtn_ReanchorAndShow()
end
UIParent:SetEventHandler("SKILL_UPGRADED", AddSkillToSkillInfoNotifier)
UIParent:SetEventHandler("NEW_SKILL_POINT", AddSkillPointToSkillInfoNotifier)
local function LevelChanged(_, stringId)
  if not W_UNIT.IsMyUnitId(stringId) then
    return
  end
  AddAbilityToSkillInfoNotifier()
end
UIParent:SetEventHandler("LEVEL_CHANGED", LevelChanged)
