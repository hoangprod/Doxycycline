W_BTN = {}
function DrawTabSkin(tab, tabWindow, selectedButton, styleInfo)
  if styleInfo == nil then
    styleInfo = {lineType = "TYPE2", useBg = true}
  end
  local firstLine, secondLine = CreateLine(tab, styleInfo.lineType, "background")
  firstLine:AddAnchor("TOPLEFT", tabWindow, -17, -3)
  firstLine:AddAnchor("TOPRIGHT", selectedButton, "BOTTOMLEFT", 2, 0)
  tab.firstLine = firstLine
  secondLine:AddAnchor("TOPLEFT", selectedButton, "BOTTOMRIGHT", -2, -3)
  secondLine:AddAnchor("TOPRIGHT", tabWindow, 15, 0)
  tab.secondLine = secondLine
  if styleInfo.useBg then
    local bg = tab:CreateDrawable(TEXTURE_PATH.TAB_LIST, "tab_bg", "background")
    bg:AddAnchor("TOPLEFT", tab, -16, 29)
    bg:AddAnchor("BOTTOMRIGHT", tab, 16, 0)
  end
end
function ReAnhorTabLine(widget, index, style)
  if style == "customizing_pupil_range" then
    if widget.firstLine ~= nil then
      if index == 1 then
        widget.firstLine:SetVisible(false)
      else
        widget.firstLine:SetVisible(true)
        widget.firstLine:RemoveAllAnchors()
        widget.firstLine:AddAnchor("TOPLEFT", widget.window[index], 0, 0)
        widget.firstLine:AddAnchor("TOPRIGHT", widget.selectedButton[index], "BOTTOMLEFT", 1, 0)
      end
    end
    if widget.secondLine ~= nil then
      widget.secondLine:RemoveAllAnchors()
      widget.secondLine:AddAnchor("TOPLEFT", widget.selectedButton[index], "BOTTOMRIGHT", -1, 0)
      widget.secondLine:AddAnchor("TOPRIGHT", widget.window[index], 1, 0)
    end
  else
    if widget.firstLine ~= nil then
      widget.firstLine:RemoveAllAnchors()
      widget.firstLine:AddAnchor("TOPLEFT", widget.window[index], -15, -3)
      widget.firstLine:AddAnchor("TOPRIGHT", widget.selectedButton[index], "BOTTOMLEFT", 2, 0)
    end
    if widget.secondLine ~= nil then
      widget.secondLine:RemoveAllAnchors()
      widget.secondLine:AddAnchor("TOPLEFT", widget.selectedButton[index], "BOTTOMRIGHT", -2, -3)
      widget.secondLine:AddAnchor("TOPRIGHT", widget.window[index], 15, 0)
    end
  end
end
function W_BTN.CreateTab(id, parent, style)
  local tab = parent:CreateChildWidget("tab", id, 0, true)
  tab:AddAnchor("TOPLEFT", parent, MARGIN.WINDOW_SIDE, MARGIN.WINDOW_TITLE)
  tab:AddAnchor("BOTTOMRIGHT", parent, -MARGIN.WINDOW_SIDE, -MARGIN.WINDOW_SIDE)
  tab:SetCorner("TOPLEFT")
  tab.tabButtonMaxWidth = 0
  tab.style = style
  local GetTabStyleInfo = function(style)
    local styles = {
      default = {
        selected = BUTTON_BASIC.TAB_SELECT,
        unselected = BUTTON_BASIC.TAB_UNSELECT,
        lineType = "TYPE2",
        useBg = true,
        fixedWidth = 0,
        tabGap = -1
      },
      uthstin_page_tab = {
        selected = BUTTON_BASIC.TAB_SELECT,
        unselected = BUTTON_BASIC.TAB_UNSELECT,
        lineType = "TYPE2",
        useBg = false,
        fixedWidth = 64,
        tabGap = -1
      },
      equip_slot_reinforce_detail_info_tab = {
        selected = BUTTON_BASIC.TAB_SELECT_FONT_MIDDLE,
        unselected = BUTTON_BASIC.TAB_UNSELECT_FONT_MIDDLE,
        lineType = "TYPE2",
        useBg = false,
        fixedWidth = 73,
        tabGap = -1
      },
      ingameshop = {
        selected = BUTTON_BASIC.TAB_SELECT_FONT_MIDDLE,
        unselected = BUTTON_BASIC.TAB_UNSELECT_FONT_MIDDLE,
        lineType = "TYPE2",
        useBg = true,
        fixedWidth = 82,
        tabGap = -1
      },
      customizing_pupil_range = {
        selected = {
          drawableType = "threePart",
          path = TEXTURE_PATH.DEFAULT_NEW,
          coordsKey = "tab_selected",
          autoResize = true,
          fontColor = {
            normal = LIGHT_GRAY_FONT_COLOR,
            highlight = LIGHT_GRAY_FONT_COLOR,
            pushed = LIGHT_GRAY_FONT_COLOR,
            disabled = LIGHT_GRAY_FONT_COLOR
          },
          fontInset = {
            left = 15,
            right = 15,
            top = 0,
            bottom = 0
          },
          fontSize = FONT_SIZE.LARGE
        },
        unselected = {
          drawableType = "threePart",
          path = TEXTURE_PATH.DEFAULT_NEW,
          coordsKey = "tab_unselected",
          autoResize = true,
          fontColor = {
            normal = LIGHT_GRAY_FONT_COLOR,
            highlight = LIGHT_GRAY_FONT_COLOR,
            pushed = LIGHT_GRAY_FONT_COLOR,
            disabled = LIGHT_GRAY_FONT_COLOR
          },
          fontInset = {
            left = 15,
            right = 15,
            top = 0,
            bottom = 0
          },
          fontSize = FONT_SIZE.LARGE
        },
        lineType = "TYPE5",
        useBg = false,
        fixedWidth = 0,
        tabGap = 0
      },
      battlefield_apply = {
        selected = BUTTON_BASIC.TAB_SELECT,
        unselected = BUTTON_BASIC.TAB_UNSELECT,
        lineType = "TYPE2",
        useBg = false,
        fixedWidth = 0,
        tabGap = -1
      }
    }
    if style == nil then
      style = "default"
    end
    return styles[style]
  end
  function tab:AddTabs(textTable)
    for i = 1, #textTable do
      self:AddSimpleTab(textTable[i])
    end
    local buttonTable = {}
    local styleInfo = GetTabStyleInfo(style)
    for i = 1, #self.window do
      ApplyButtonSkin(self.selectedButton[i], styleInfo.selected)
      ApplyButtonSkin(self.unselectedButton[i], styleInfo.unselected)
      table.insert(buttonTable, tab.selectedButton[i])
      table.insert(buttonTable, tab.unselectedButton[i])
    end
    tab.tabButtonMaxWidth = AdjustBtnLongestTextWidth(buttonTable, styleInfo.fixedWidth)
    tab:SetGap(styleInfo.tabGap)
    DrawTabSkin(self, self.window[1], self.selectedButton[1], styleInfo)
    ReAnhorTabLine(self, 1, self.style)
  end
  local OnTabChanged = function(self, selected)
    ReAnhorTabLine(self, selected, self.style)
    if self.OnTabChangedProc ~= nil then
      self:OnTabChangedProc(selected)
    end
  end
  tab:SetHandler("OnTabChanged", OnTabChanged)
  function tab:GetTabButtonMaxWidth()
    return tab.tabButtonMaxWidth
  end
  function tab:EnableTab(index, enable)
    if self.window[index] == nil then
      return
    end
    self.selectedButton[index]:Enable(enable)
    self.unselectedButton[index]:Enable(enable)
  end
  return tab
end
function W_BTN.CreateImageTab(id, parent)
  local tab = parent:CreateChildWidget("tab", id, 0, true)
  tab:SetGap(0)
  tab:SetOffset(0)
  tab:SetCorner("TOPLEFT")
  tab.divisionLine = {}
  local function AnchorDivisionLine(index, needRevers)
    if index <= 0 then
      return
    end
    local divisionLine = tab.divisionLine[index]
    if divisionLine == nil then
      return
    end
    local offset = 0
    if index % 3 == 1 then
      if needRevers then
        divisionLine:SetTextureInfo("reversed_division_line_1", "default")
      else
        divisionLine:SetTextureInfo("division_line_1", "default")
      end
      offset = 9
    elseif index % 3 == 2 then
      if needRevers then
        divisionLine:SetTextureInfo("reversed_division_line_2", "default")
      else
        divisionLine:SetTextureInfo("division_line_2", "default")
      end
      offset = 1
    else
      if needRevers then
        divisionLine:SetTextureInfo("reversed_division_line_3", "default")
      else
        divisionLine:SetTextureInfo("division_line_3", "default")
      end
      offset = 16
    end
    divisionLine:RemoveAllAnchors()
    if needRevers then
      divisionLine:AddAnchor("TOPLEFT", tab, index * tab.selectedButton[1]:GetWidth() - 25, offset)
    else
      divisionLine:AddAnchor("TOPLEFT", tab, index * tab.selectedButton[1]:GetWidth() - 2, offset)
    end
  end
  function tab:AddTab(tabInfo)
    if tabInfo.tabName == nil then
      tabInfo.tabName = ""
    end
    self:AddSimpleTab(tabInfo.tabName)
    local tabSize = #self.window
    local selectedBtn = self.selectedButton[tabSize]
    local unselectedBtn = self.unselectedButton[tabSize]
    if tabInfo.defaultTab then
      selectedBtn:SetExtent(BUTTON_SIZE.IMAGE_TAB.WIDTH, BUTTON_SIZE.IMAGE_TAB.HEIGHT)
      unselectedBtn:SetExtent(BUTTON_SIZE.IMAGE_TAB.WIDTH, BUTTON_SIZE.IMAGE_TAB.HEIGHT)
      SetButtonFontColor(selectedBtn, GetButtonDefaultFontColor())
      SetButtonFontColor(unselectedBtn, GetButtonDefaultFontColor())
      selectedBtn:SetInset(0, 0, 2, 0)
      unselectedBtn:SetInset(0, 0, 2, 0)
    else
      ApplyButtonSkin(selectedBtn, tabInfo.buttonStyle)
      ApplyButtonSkin(unselectedBtn, tabInfo.buttonStyle)
    end
    local divisionLine = self:CreateDrawable(TEXTURE_PATH.TAB_LIST, "division_line_1", "artwork")
    self.divisionLine[tabSize] = divisionLine
    AnchorDivisionLine(tabSize, false)
    if tabInfo.tooltip ~= nil then
      local function OnEnter()
        SetVerticalTooltip(tabInfo.tooltip, selectedBtn)
        SetVerticalTooltip(tabInfo.tooltip, unselectedBtn)
      end
      selectedBtn:SetHandler("OnEnter", OnEnter)
      unselectedBtn:SetHandler("OnEnter", OnEnter)
    end
    if self.firstLine == nil and self.secondLine == nil then
      if styleInfo == nil then
        styleInfo = {lineType = "TYPE2", useBg = false}
      end
      DrawTabSkin(self, self.window[1], self.selectedButton[1], styleInfo)
      self.firstLine:SetVisible(false)
    end
  end
  function tab:AddTabs(tabInfos)
    for i = 1, #tabInfos do
      tab:AddTab(tabInfos[i])
    end
  end
  local prevselected = 0
  local function OnTabChanged(self, selected, viewSelcted)
    if self.OnTabChangedProc ~= nil then
      self:OnTabChangedProc(selected)
    end
    if self.firstLine == nil or self.secondLine == nil or #self.divisionLine == 0 then
      return
    end
    if viewSelcted == 1 then
      self.firstLine:SetVisible(false)
      self.secondLine:RemoveAllAnchors()
      self.secondLine:AddAnchor("TOPLEFT", self.selectedButton[1], "BOTTOMRIGHT", 0, -3)
      self.secondLine:AddAnchor("TOPRIGHT", tab, 11, 0)
      local divisionLine = self.divisionLine[viewSelcted]
      AnchorDivisionLine(1, false)
      AnchorDivisionLine(prevselected - 1, false)
    else
      local selectedBtn = self.selectedButton[viewSelcted]
      AnchorDivisionLine(viewSelcted, false)
      AnchorDivisionLine(viewSelcted - 1, true)
      AnchorDivisionLine(viewSelcted - 2, false)
      self.firstLine:SetVisible(true)
      self.firstLine:RemoveAllAnchors()
      self.firstLine:AddAnchor("TOPLEFT", self.window[1], -10, -3)
      self.firstLine:AddAnchor("TOPRIGHT", self.selectedButton[selected], "BOTTOMLEFT", 2, 0)
      self.secondLine:SetVisible(true)
      self.secondLine:RemoveAllAnchors()
      self.secondLine:AddAnchor("TOPLEFT", self.selectedButton[selected], "BOTTOMRIGHT", 2, -3)
      self.secondLine:AddAnchor("TOPRIGHT", self.window[1], 0, 0)
    end
    prevselected = selected
  end
  tab:SetHandler("OnTabChanged", OnTabChanged)
  return tab
end
