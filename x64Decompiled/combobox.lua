local SetViewOfSliderList = function(id, parent)
  local window = UIParent:CreateWidget("window", id, parent)
  window:Show(false)
  local list = W_CTRL.CreateList(id .. ".list", window)
  list:AddAnchor("TOPLEFT", window, 0, 0)
  list:AddAnchor("BOTTOMRIGHT", window, -15, 0)
  list:SetInset(5, 7, 5, 7)
  list:SetStyle(nil)
  list.bg:RemoveAllAnchors()
  list.bg:AddAnchor("TOPLEFT", window, 0, 0)
  list.bg:AddAnchor("BOTTOMRIGHT", window, 0, 0)
  window.list = list
  local scroll = W_CTRL.CreateScroll("scroll", window)
  scroll:AddAnchor("TOPRIGHT", window, -4, 8)
  scroll:AddAnchor("BOTTOMRIGHT", window, -4, -8)
  window.scroll = scroll
  return window
end
local function CreateSliderList(id, parent)
  local window = SetViewOfSliderList(id, parent)
  local list = window.list
  local scroll = window.scroll
  local function OnSliderChanged(self, arg)
    list:SetTop(arg)
  end
  scroll.vs:SetHandler("OnSliderChanged", OnSliderChanged)
  function list:OnSelChanged()
    widget:SetText(list:GetSelectedText())
    list:Show(false)
  end
  return window
end
local function CreateDropdown()
  local dropdown = CreateSliderList("dropDownSliderList", "UIParent")
  dropdown:SetMinMaxValues(0, 0)
  local OnHide = function(self)
    self.OnSelChanged = nil
    self:SetHeight(0)
    self:ClearItem()
    self.scroll:Show(false)
  end
  dropdown:SetHandler("OnHide", OnHide)
  function dropdown:Hide(target)
    self:Show(false)
    target:DetachWidget()
  end
  return dropdown
end
local DEFAULT_DROPDOWN_LAYER = "normal"
local commonDropdown = CreateDropdown()
commonDropdown:SetUILayer(DEFAULT_DROPDOWN_LAYER)
commonDropdown:SetCloseOnEscape(true)
ADDON:RegisterContentWidget(UIC_DROPDOWN_LIST, commonDropdown)
function W_CTRL.CreateComboBox(id, parent)
  local comboBox = parent:CreateChildWidget("button", id, 0, true)
  ButtonInit(comboBox)
  comboBox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, DEFAULT_SIZE.COMBOBOX_HEIGHT)
  comboBox:SetInset(7, 1, 21, 0)
  comboBox.style:SetAlign(ALIGN_LEFT)
  comboBox.dropdownLayer = parent:GetUILayer()
  local bg = comboBox:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  bg:AddAnchor("TOPLEFT", comboBox, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", comboBox, 0, 0)
  comboBox.bg = bg
  local button = CreateEmptyButton(comboBox:GetId() .. ".button", comboBox)
  button:AddAnchor("RIGHT", comboBox, -2, 2)
  ApplyButtonSkin(button, BUTTON_BASIC.FOLDER_CLOSE)
  local selectedIndex = 0
  local guideStr = ""
  local dropdownInfo
  local showDropdownTooltip = false
  local prevSelectedIndex = 0
  local visibleItemCount = 0
  local maxItemCount = 0
  local guideTextAlwaysShow = false
  function comboBox:Clear()
    selectedIndex = 0
    dropdownInfo = nil
    guideStr = ""
    showDropdownTooltip = false
    prevSelectedIndex = 0
    visibleItemCount = 0
    maxItemCount = 0
    self:SetEnable(false, true)
    self:SetText("")
    if self:GetAttachedWidget() == commonDropdown then
      commonDropdown:ClearItem()
    end
  end
  function comboBox:GetSelectedIndex()
    return selectedIndex
  end
  function comboBox:SetGuideText(str, alwaysShow)
    guideStr = str
    if selectedIndex == 0 then
      self:SetText(guideStr)
    end
    guideTextAlwaysShow = alwaysShow
  end
  function comboBox:SetEnable(enable)
    self:Enable(enable, true)
    if enable then
      self.bg:SetColor(1, 1, 1, 1)
      self:SetAlpha(1)
    else
      self.bg:SetColor(0.5, 0.5, 0.5, 0.7)
      self:SetAlpha(0.7)
    end
  end
  function comboBox:GetPrevSelectedIndex()
    return prevSelectedIndex
  end
  function comboBox:GetSelectedInfo()
    if dropdownInfo == nil then
      return
    end
    if selectedIndex == 0 or #dropdownInfo < selectedIndex then
      return
    end
    return dropdownInfo[selectedIndex]
  end
  function comboBox:GetIndexByValue(value)
    if dropdownInfo == nil then
      return 0
    end
    for i = 1, #dropdownInfo do
      if dropdownInfo[i].value == value then
        return i
      end
    end
    return 0
  end
  function comboBox:IsSelected()
    return selectedIndex ~= 0
  end
  function comboBox:AppendItems(info, defaultSelectFirstItem)
    if info == nil then
      return
    end
    if type(info) ~= "table" then
      return
    end
    if #info == 0 then
      return
    end
    dropdownInfo = info
    maxItemCount = #info
    if visibleItemCount == 0 then
      visibleItemCount = #info
    end
    local enableCount = 0
    for i, v in ipairs(info) do
      if v.enable == nil or v.enable ~= nil and v.enable ~= false then
        enableCount = enableCount + 1
      end
    end
    self:SetEnable(enableCount > 0, true)
    if defaultSelectFirstItem ~= false then
      self:Select(1)
    end
  end
  function comboBox:ShowDropdownTooltip(show)
    showDropdownTooltip = show
  end
  function comboBox:SetVisibleItemCount(count)
    visibleItemCount = count
  end
  function comboBox:OnSelChanged()
    local selIndex = commonDropdown:GetSelectedIndex()
    comboBox:Select(selIndex)
    commonDropdown:Hide(comboBox)
  end
  function comboBox:Select(index, callProc)
    if callProc == nil then
      callProc = true
    end
    if dropdownInfo == nil then
      return
    end
    if index == 0 then
      return
    end
    if index > #dropdownInfo then
      return
    end
    if self:GetAttachedWidget() == commonDropdown then
      commonDropdown:Select(index - 1, false)
    end
    prevSelectedIndex = selectedIndex
    selectedIndex = index
    local str = ""
    local color = FONT_COLOR.DEFAULT
    if guideTextAlwaysShow then
      str = guideStr
    else
      str = dropdownInfo[index].text
      if dropdownInfo[index].useColor then
        color = dropdownInfo[index].color
      end
    end
    self:SetText(str)
    SetButtonFontOneColor(self, color)
    if callProc and comboBox.SelectedProc ~= nil then
      comboBox:SelectedProc(selectedIndex)
    end
  end
  function comboBox:SetEllipsis(isEllipsis, attachParam)
    comboBox.style:SetEllipsis(isEllipsis)
    commonDropdown.list.itemStyle:SetEllipsis(isEllipsis)
    if isEllipsis then
      if attachParam == nil then
        attachParam = {
          "LEFT",
          self,
          "RIGHT",
          -25,
          0
        }
      end
      F_TEXT.ApplyEllipsisText(self, self:GetWidth(), attachParam)
    end
  end
  function comboBox:OnClick(arg)
    if arg ~= "LeftButton" then
      return
    end
    if comboBox:GetAttachedWidget() == commonDropdown then
      local visible = not commonDropdown:IsVisible()
      if visible then
        commonDropdown:SetUILayer(comboBox.dropdownLayer)
      end
      commonDropdown:Show(visible)
    else
      commonDropdown:SetUILayer(comboBox.dropdownLayer)
      comboBox:AttachWidget(commonDropdown)
      commonDropdown:Show(true)
    end
    if commonDropdown:IsVisible() then
      commonDropdown:AddAnchor("TOPLEFT", comboBox, "BOTTOMLEFT", 0, 0)
      commonDropdown:AddAnchor("TOPRIGHT", comboBox, "BOTTOMRIGHT", 0, 0)
      for i = 1, #dropdownInfo do
        commonDropdown.list:AppendItemByTable(dropdownInfo[i])
      end
      local left, top, right, bottom = commonDropdown.list:GetInset()
      if maxItemCount > visibleItemCount then
        commonDropdown.scroll:Show(true)
        commonDropdown:SetHeight(visibleItemCount * commonDropdown.list:GetHeight() + top + bottom)
        commonDropdown:SetMinMaxValues(0, commonDropdown:GetMaxTop())
      else
        commonDropdown.scroll:Show(false)
        commonDropdown:SetHeight(maxItemCount * commonDropdown.list:GetHeight() + top + bottom)
      end
      if selectedIndex ~= 0 then
        comboBox:Select(selectedIndex, false)
      end
      commonDropdown.OnSelChanged = comboBox.OnSelChanged
      commonDropdown.list:ShowTooltip(showDropdownTooltip)
    else
      if comboBox.HideDropDown ~= nil then
        comboBox:HideDropDown()
      end
      comboBox:DetachWidget()
    end
  end
  button:SetHandler("OnClick", comboBox.OnClick)
  comboBox:SetHandler("OnClick", comboBox.OnClick)
  local comboBoxEvents = {
    MOUSE_DOWN = function(widgetId)
      if comboBox:GetAttachedWidget() ~= commonDropdown then
        return
      end
      if comboBox:GetId() == widgetId then
        return
      end
      if comboBox:IsDescendantWidget(widgetId) then
        return
      end
      if not commonDropdown:IsVisible() then
        return
      end
      if commonDropdown:IsDescendantWidget(widgetId) then
        return
      end
      commonDropdown:Hide(comboBox)
    end
  }
  comboBox:SetHandler("OnEvent", function(this, event, ...)
    comboBoxEvents[event](...)
  end)
  comboBox:RegisterEvent("MOUSE_DOWN")
  comboBox:Clear()
  return comboBox
end
function W_CTRL.CreateAutocomplete(id, parent)
  local comboBox = parent:CreateChildWidget("combobox", id, 0, true)
  comboBox:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, DEFAULT_SIZE.COMBOBOX_HEIGHT)
  comboBox:SetEditable(true)
  InitEdit(comboBox.selector)
  function comboBox:CreateGuideText(msg, align, inset)
    self.selector:SetGuideText(msg)
    if inset ~= nil then
      self.selector:SetGuideTextInset(inset[1], inset[2], inset[3], inset[4])
    end
    self.selector.guideTextStyle:SetColor(0, 0, 0, 0.5)
    if align == nil then
      align = ALIGN_LEFT
    end
    self.selector.guideTextStyle:SetAlign(align)
  end
  InitList(comboBox.dropdown)
  local bg = comboBox.dropdown:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "background")
  bg:AddAnchor("TOPLEFT", comboBox.dropdown, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", comboBox.dropdown, 0, 0)
  function comboBox:HideDropdown()
    comboBox.dropdown:Show(false)
    comboBox.selector:ClearFocus()
  end
  function comboBox:Reset()
    comboBox.selector:SetText("")
  end
  function comboBox:LinkText(str)
    self:PauseAutocomplete(true)
    self.selector:SetText(str)
    if str == self.selector:GetText() then
      self:PauseAutocomplete(false)
    end
  end
  return comboBox
end
