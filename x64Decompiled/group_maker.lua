local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local MAX_DESC_TEXT = 24
local CreateInnerTitle = function(id, parent, text)
  local innerTitleLabel = W_CTRL.CreateLabel(id .. ".titleLabel", parent)
  innerTitleLabel:SetText(text)
  innerTitleLabel:SetExtent(10, 17)
  innerTitleLabel:AddAnchor("TOPLEFT", parent, 0, 0)
  innerTitleLabel.style:SetShadow(true)
  innerTitleLabel.style:SetAlign(ALIGN_LEFT)
  return innerTitleLabel
end
local SetViewOfItemGroupSelector = function(id, parent)
  local widget = CreateEmptyWindow(id, parent)
  widget:SetTitleText(locale.inven.itemGroupSelectorTitle)
  widget.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  widget.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  ApplyTitleFontColor(widget, FONT_COLOR.TITLE)
  local groupTypes = X2Item:GroupTypes()
  local count = #groupTypes
  local checkBtns = {}
  local xOffset, yOffset = 12, localeView.groupMaker.yOffsetValue
  local xOffsetAgmenter = localeView.groupMaker.xOffsetAgmenter
  for i = 1, count do
    local t = groupTypes[i]
    local name = X2Item:GroupName(t)
    local tip = X2Item:GroupDescription(t)
    local checkBtn = CreateCheckButton(string.format("checkBtn[%d]", i), widget, name)
    checkBtn:SetExtent(16, 16)
    checkBtn:AddAnchor("TOPLEFT", widget, xOffset, yOffset)
    checkBtn.groupType = t
    checkBtn.groupName = name
    checkBtn.textButton.tip = tip
    xOffset = xOffset + xOffsetAgmenter
    if i % 3 == 0 then
      xOffset = 12
      yOffset = yOffset + 20
    end
    if i == count and i % 3 ~= 0 then
      yOffset = yOffset + 20
    end
    function checkBtn.textButton:OnEnter()
      SetTargetAnchorTooltip(self.tip, "TOPLEFT", self, "BOTTOMRIGHT", 0, 0)
    end
    checkBtn.textButton:SetHandler("OnEnter", checkBtn.textButton.OnEnter)
    function checkBtn.textButton:OnLeave()
      HideTooltip()
    end
    checkBtn.textButton:SetHandler("OnLeave", checkBtn.textButton.OnLeave)
    checkBtns[i] = checkBtn
  end
  widget.checkBtns = checkBtns
  widget:SetExtent(315, yOffset)
  return widget
end
local CreateTabIconSelectButton = function(id, parent, imageIdx)
  local iconBtns = parent:CreateChildWidget("button", "iconBtns", imageIdx, true)
  ApplyButtonSkin(iconBtns, BUTTON_CONTENTS.BAG_ICON)
  iconBtns.icon = iconBtns:CreateDrawable(TEXTURE_PATH.INVENTORY_DEFAULT, GetTabIconCoords(imageIdx), "background")
  iconBtns.icon:AddAnchor("CENTER", iconBtns, 0, 0)
  function iconBtns:SetColor(r, g, b, a)
    self.icon:SetColor(r, g, b, a)
  end
  function iconBtns:SetImageIdx(idx)
    if idx > MAX_TAB_ICON_COORDS then
      return
    end
    iconBtns.icon:SetTextureInfo(GetTabIconCoords(idx))
  end
end
local function SetViewOfIconSelector(id, parent)
  local widget = CreateEmptyWindow(id, parent)
  widget:SetTitleText(locale.inven.iconSelectorTitle)
  widget.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  widget.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  ApplyTitleFontColor(widget, FONT_COLOR.TITLE)
  local xOffset, yOffset = 10, 0
  widget.iconBtns = {}
  for i = 1, MAX_TAB_ICON_COORDS do
    local iconId = string.format("%s.icon[%d]", id, i)
    CreateTabIconSelectButton(iconId, widget, i)
    widget.iconBtns[i]:Show(true)
    widget.iconBtns[i]:AddAnchor("TOPLEFT", widget, xOffset, yOffset + 20)
    xOffset = xOffset + 33
    if i % 9 == 0 then
      xOffset = 10
      yOffset = yOffset + 35
    end
  end
  yOffset = yOffset + 20
  widget:SetExtent(315, yOffset)
  return widget
end
local UpdateSelectedGroupName = function(groupTable, name, insert)
  if insert then
    table.insert(groupTable, name)
  else
    for i, groupName in pairs(groupTable) do
      if name == groupName then
        groupTable[i] = nil
        return
      end
    end
  end
end
local function MakeSelectedGroupName(groupTable)
  local textBuf = ""
  local count = 0
  for i, groupName in pairs(groupTable) do
    if groupName ~= nil then
      if count >= 1 then
        textBuf = textBuf .. ", " .. groupName
      else
        textBuf = textBuf .. groupName
      end
      count = count + 1
    end
  end
  if textBuf == "" then
    return ""
  end
  textBuf = X2Util:ConvertFormatString(textBuf)
  textBuf = X2Util:UTF8StringLimit(textBuf, MAX_DESC_TEXT, "...")
  return textBuf
end
local function CreateItemGroupSelector(id, parent, adapter)
  local widget = SetViewOfItemGroupSelector(id, parent)
  widget:Show(true)
  widget.selectedGroupNames = {}
  function widget:SetSelectedListener(obj)
    self.selectedListener = obj
  end
  function widget:NotifySelected()
    if self.selectedListener and self.selectedListener.OnSelectedGroup then
      self.selectedListener:OnSelectedGroup()
    end
  end
  function widget:SetCreateButtonEnableCheck()
    local btns = self.checkBtns
    for i = 1, #btns do
      local btn = btns[i]
      if btn:GetChecked() then
        return true
      end
    end
    return false
  end
  local IncludeGroup = function(groups, group)
    for i = 1, #groups do
      if groups[i] == group then
        return true
      end
    end
    return false
  end
  function widget:Init(tabIdx)
    local btns = self.checkBtns
    local checkStatus = {}
    tabIdx = tabIdx or 1
    local _, _, filterGroups = adapter:TabInfo(tabIdx)
    if filterGroups == nil then
      filterGroups = {}
    end
    local createBtn = widget:GetParent().createBtn
    for i = 1, #btns do
      local btn = btns[i]
      local checkee = IncludeGroup(filterGroups, btn.groupType)
      btn:SetChecked(checkee)
      function btn:CheckBtnCheckChagnedProc()
        UpdateSelectedGroupName(widget.selectedGroupNames, self.groupName, self:GetChecked())
        widget:NotifySelected()
        createBtn:Enable(widget:SetCreateButtonEnableCheck())
      end
      btn:SetHandler("OnCheckChanged", btn.OnCheckChanged)
    end
    self.selectedGroupNames = {}
  end
  function widget:GetSelectedGroupName()
    return MakeSelectedGroupName(widget.selectedGroupNames)
  end
  function widget:GetSelectedGroupTypes()
    local btns = self.checkBtns
    local checkStatus = {}
    for i = 1, #btns do
      if btns[i]:GetChecked() == true then
        table.insert(checkStatus, btns[i].groupType)
      end
    end
    return checkStatus
  end
  return widget
end
local function CreateIconSelector(id, parent, adapter)
  local widget = SetViewOfIconSelector(id, parent)
  function widget:ResetSelected()
    for i = 1, #self.iconBtns do
      SetBGPushed(self.iconBtns[i], false)
    end
  end
  function widget:Init(tabIdx)
    self:ResetSelected()
    local _, icons = adapter:TabInfos()
    for i = 1, #self.iconBtns do
      self.iconBtns[i]:Enable(true)
      self.iconBtns[i].icon:SetColor(1, 1, 1, 1)
    end
    for i = 1, #icons do
      local iconIdx = icons[i]
      if i + 1 ~= tabIdx then
        self.iconBtns[iconIdx]:Enable(false)
        self.iconBtns[iconIdx].icon:SetColor(1, 1, 1, 0.3)
      else
        self:Select(self.iconBtns[iconIdx].idx)
      end
    end
    if tabIdx == nil then
      for i = 1, #self.iconBtns do
        if self.iconBtns[i]:IsEnabled() then
          self:Select(i)
          self.selectedIdx = i
          break
        end
      end
    end
  end
  function widget:Select(idx)
    if idx > #self.iconBtns then
      return
    end
    SetBGPushed(self.iconBtns[idx], true)
    self.selectedIdx = idx
  end
  function widget:GetSelectedIdx()
    return self.selectedIdx
  end
  for i = 1, #widget.iconBtns do
    local iconBtn = widget.iconBtns[i]
    iconBtn.idx = i
    function iconBtn:OnClick()
      widget:Select(self.idx)
      widget:ResetSelected()
      SetBGPushed(self, true)
    end
    iconBtn:SetHandler("OnClick", iconBtn.OnClick)
  end
  widget:Show(true)
  return widget
end
local function CreateGroupDescInput(id, parent)
  local window = CreateEmptyWindow(id .. ".mainWindow", parent)
  window:Show(true)
  window:SetTitleText(locale.inven.groupDescInputTitle)
  window.titleStyle:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
  window.titleStyle:SetAlign(ALIGN_TOP_LEFT)
  ApplyTitleFontColor(window, FONT_COLOR.TITLE)
  local tabDesc = W_CTRL.CreateEdit("tabDesc", window)
  tabDesc:SetExtent(295, DEFAULT_SIZE.EDIT_HEIGHT)
  tabDesc:AddAnchor("BOTTOMLEFT", window, 12, 0)
  tabDesc:SetMaxTextLength(MAX_DESC_TEXT)
  local height = tabDesc:GetHeight() + 23
  window:SetExtent(315, height)
  window.tabDesc = tabDesc
  return window
end
function CreateItemGroupTabMaker(id, parent, adapter)
  local widget = CreateWindow(id, parent)
  widget:SetTitle(locale.inven.itemGroupTabMarkerTitle)
  widget:Show(false)
  local createBtn = widget:CreateChildWidget("button", "createBtn", 0, true)
  createBtn:Show(true)
  createBtn:AddAnchor("BOTTOM", widget, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  createBtn:SetText(locale.messageBoxBtnText.ok)
  ApplyButtonSkin(createBtn, BUTTON_BASIC.DEFAULT)
  local selector = CreateItemGroupSelector(id .. ".selector", widget, adapter)
  selector:AddAnchor("TOP", widget, 0, titleMargin)
  local width, height = 0, 0
  local w1, h1 = selector:GetExtent()
  widget.selector = selector
  height = h1
  local iconSelector = CreateIconSelector(id .. ".iconSelector", widget, adapter)
  iconSelector:AddAnchor("TOP", selector, "BOTTOM", 0, sideMargin / 1.5)
  local w2, h2 = iconSelector:GetExtent()
  widget.iconSelector = iconSelector
  height = height + h2 + sideMargin
  width = math.max(w1, w2)
  local groupDescInput = CreateGroupDescInput(id .. "groupDescInput", widget)
  groupDescInput:AddAnchor("TOP", iconSelector, "BOTTOM", 0, sideMargin / 1.5)
  local w3, h3 = groupDescInput:GetExtent()
  height = height + h3 + sideMargin
  groupDescInput.tabDesc.modified = false
  function groupDescInput.tabDesc:OnSelectedGroup()
    if self.modified == false then
      self:SetText(selector:GetSelectedGroupName())
    end
  end
  selector:SetSelectedListener(groupDescInput.tabDesc)
  function groupDescInput.tabDesc:OnKeyDown()
    self.modified = true
  end
  groupDescInput.tabDesc:SetHandler("OnKeyDown", groupDescInput.tabDesc.OnKeyDown)
  widget.groupDescInput = groupDescInput
  height = height + createBtn:GetHeight()
  function createBtn:OnClick()
    local selected = selector:GetSelectedGroupTypes()
    local selectedIdx = iconSelector:GetSelectedIdx()
    local tabDescText = widget.groupDescInput.tabDesc:GetText()
    if widget.tabIdx == nil then
      local idx = adapter:CreateTab(selectedIdx, tabDescText, selected)
      adapter:SwitchTab(idx)
    else
      adapter:EditTab(widget.tabIdx, selectedIdx, tabDescText, selected)
    end
    widget:Show(false)
  end
  createBtn:SetHandler("OnClick", createBtn.OnClick)
  function createBtn:OnEnter()
    if not self:IsEnabled() then
      SetTooltip(locale.inven.createWarning, self)
    end
  end
  createBtn:SetHandler("OnEnter", createBtn.OnEnter)
  function createBtn:OnLeave()
    HideTooltip()
  end
  createBtn:SetHandler("OnLeave", createBtn.OnLeave)
  function widget:Init(tabIdx)
    self.tabIdx = tabIdx
    self.selector:Init(tabIdx)
    self.iconSelector:Init(tabIdx)
    if tabIdx ~= nil then
      local tabDescText, _, _ = adapter:TabInfo(tabIdx)
      self.groupDescInput.tabDesc:SetText(tabDescText)
      self.groupDescInput.tabDesc.modified = true
      self.createBtn:Enable(true)
      self:SetTitle(locale.inven.itemGroupTabEditTitle)
    else
      self.groupDescInput.tabDesc:SetText("")
      self.groupDescInput.tabDesc.modified = false
      self.createBtn:Enable(false)
      self:SetTitle(locale.inven.itemGroupTabMarkerTitle)
    end
  end
  height = height + titleMargin + bottomMargin + sideMargin * 4.3
  widget:SetExtent(POPUP_WINDOW_WIDTH, height)
  return widget
end
