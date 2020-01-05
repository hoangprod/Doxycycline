local SetViewOfPageControl = function(id, parent, style)
  local widget = parent:CreateChildWidget("emptywidget", id, 0, true)
  widget:SetExtent(150, 32)
  local firstPageButton = widget:CreateChildWidget("button", "firstPageButton", 0, true)
  ApplyButtonSkin(firstPageButton, BUTTON_BASIC.PAGE_FIRST)
  local prevPageButton = widget:CreateChildWidget("button", "prevPageButton", 0, true)
  ApplyButtonSkin(prevPageButton, BUTTON_BASIC.PAGE_PREV)
  local nextPageButton = widget:CreateChildWidget("button", "nextPageButton", 0, true)
  ApplyButtonSkin(nextPageButton, BUTTON_BASIC.PAGE_NEXT)
  local lastPageButton = widget:CreateChildWidget("button", "lastPageButton", 0, true)
  ApplyButtonSkin(lastPageButton, BUTTON_BASIC.PAGE_LAST)
  local pageLabel = widget:CreateChildWidget("label", "pageLabel", 0, true)
  pageLabel:SetExtent(80, 30)
  pageLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
  ApplyTextColor(pageLabel, FONT_COLOR.TITLE)
  pageLabel.defaultColor = FONT_COLOR.TITLE
  function widget:SetPageStyle(style)
    if tostring(style) == "ucc_pattern" then
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("TOP", widget, 0, 0)
      pageLabel:SetAutoResize(true)
      pageLabel:SetHeight(20)
      pageLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:AddAnchor("LEFT", widget, 0, 13)
      firstPageButton:Show(false)
      firstPageButton:RemoveAllAnchors()
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("RIGHT", widget, 0, 13)
      lastPageButton:Show(false)
      lastPageButton:RemoveAllAnchors()
      widget.labelStyle = "ucc_pattern"
    elseif tostring(style) == "ucc_sample" then
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("TOP", widget, -26, 0)
      pageLabel:SetAutoResize(true)
      pageLabel:SetHeight(20)
      pageLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:AddAnchor("LEFT", widget, 0, 13)
      firstPageButton:Show(false)
      firstPageButton:RemoveAllAnchors()
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("RIGHT", widget, 0, 13)
      lastPageButton:Show(false)
      lastPageButton:RemoveAllAnchors()
    elseif tostring(style) == "loginStage" then
      pageLabel:Show(false)
      lastPageButton:Show(false)
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("RIGHT", widget, 0, 0)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:AddAnchor("LEFT", widget, 0, 0)
    elseif tostring(style) == "craft" or tostring(style) == "ingameshop_cart" then
      pageLabel:Show(false)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:AddAnchor("LEFT", widget, 0, 0)
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("RIGHT", widget, 0, 0)
      lastPageButton:Show(false)
    elseif tostring(style) == "actionBar" then
      widget:SetExtent(20, 35)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:AddAnchor("TOP", widget, 0, 0)
      ChangeButtonSkin(prevPageButton, BUTTON_HUD.ACTIONBAR_PAGE_UP)
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("TOP", prevPageButton, "BOTTOM", 0, 3)
      pageLabel:SetInset(0, 0, 1, 0)
      pageLabel:SetExtent(20, FONT_SIZE.MIDDLE)
      pageLabel.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.MIDDLE)
      ApplyTextColor(pageLabel, FONT_COLOR.WHITE)
      if pageLabel.bg == nil then
        local bg = pageLabel:CreateDrawable(TEXTURE_PATH.HUD, "page_label_bg", "background")
        bg:SetTextureColor("default")
        bg:SetExtent(18, 18)
        bg:AddAnchor("CENTER", pageLabel, 0, 0)
      end
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("BOTTOM", widget, 0, 0)
      ChangeButtonSkin(nextPageButton, BUTTON_HUD.ACTIONBAR_PAGE_DOWN)
      lastPageButton:Show(false)
    elseif tostring(style) == "tutorial" then
      widget:SetExtent(95, 30)
      firstPageButton:Show(false)
      lastPageButton:Show(false)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:AddAnchor("LEFT", widget, 0, 0)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("RIGHT", widget, 0, 0)
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("LEFT", prevPageButton, "RIGHT", 5, 0)
      pageLabel:AddAnchor("RIGHT", nextPageButton, "LEFT", -5, 0)
    elseif tostring(style) == "mail" then
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("CENTER", widget, "CENTER", 0, 0)
      pageLabel:SetWidth(60)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      prevPageButton:AddAnchor("RIGHT", pageLabel, "LEFT", 0, 0)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:AddAnchor("RIGHT", prevPageButton, "LEFT", 0, 0)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("LEFT", pageLabel, "RIGHT", 0, 0)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(true)
      lastPageButton:AddAnchor("LEFT", nextPageButton, "RIGHT", 0, 0)
    elseif tostring(style) == "ingameshop" then
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("CENTER", widget, "CENTER", 0, 0)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      prevPageButton:AddAnchor("RIGHT", pageLabel, "LEFT", 0, 0)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:Show(true)
      nextPageButton:AddAnchor("LEFT", pageLabel, "RIGHT", 0, 0)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(false)
      widget.labelStyle = "ingameshop"
    elseif tostring(style) == "note" then
      pageLabel:RemoveAllAnchors()
      pageLabel:Show(false)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      prevPageButton:AddAnchor("BOTTOMLEFT", parent, 15, -15)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:Show(true)
      nextPageButton:AddAnchor("BOTTOMRIGHT", parent, -15, -15)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(false)
      ChangeButtonSkin(prevPageButton, BUTTON_CONTENTS.BOOK_PREV)
      ChangeButtonSkin(nextPageButton, BUTTON_CONTENTS.BOOK_NEXT)
    elseif tostring(style) == "itemGuide" then
      pageLabel:RemoveAllAnchors()
      pageLabel:Show(false)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:Show(true)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(false)
      ChangeButtonSkin(prevPageButton, BUTTON_BASIC.EQUIP_ITEM_GUIDE_MOVE_LEFT)
      ChangeButtonSkin(nextPageButton, BUTTON_BASIC.EQUIP_ITEM_GUIDE_MOVE_RIGHT)
      prevPageButton:AddAnchor("TOPRIGHT", widget, 0, 12)
      nextPageButton:AddAnchor("TOPRIGHT", prevPageButton, "BOTTOMRIGHT", 0, 2)
    elseif tostring(style) == "characterList" then
      widget:SetExtent(170, 48)
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("CENTER", widget, "CENTER", 0, 0)
      pageLabel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XLARGE)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      prevPageButton:AddAnchor("RIGHT", pageLabel, "LEFT", 0, 0)
      ChangeButtonSkin(prevPageButton, BUTTON_CONTENTS.PAGE_FIRST)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:AddAnchor("RIGHT", prevPageButton, "LEFT", 0, 0)
      ChangeButtonSkin(firstPageButton, BUTTON_CONTENTS.PAGE_PREV)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("LEFT", pageLabel, "RIGHT", 0, 0)
      ChangeButtonSkin(nextPageButton, BUTTON_CONTENTS.PAGE_NEXT)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(true)
      lastPageButton:AddAnchor("LEFT", nextPageButton, "RIGHT", 0, 0)
      ChangeButtonSkin(lastPageButton, BUTTON_CONTENTS.PAGE_LAST)
    elseif tostring(style) == "battleShip" then
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("CENTER", widget, "CENTER", 0, 0)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      prevPageButton:AddAnchor("RIGHT", pageLabel, "LEFT", 0, 0)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:Show(false)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:Show(true)
      nextPageButton:AddAnchor("LEFT", pageLabel, "RIGHT", 0, 0)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(false)
      ApplyButtonSkin(prevPageButton, BUTTON_BASIC.PAGE_PREV)
      ApplyButtonSkin(nextPageButton, BUTTON_BASIC.PAGE_NEXT)
    else
      pageLabel:RemoveAllAnchors()
      pageLabel:AddAnchor("CENTER", widget, "CENTER", 0, 0)
      prevPageButton:RemoveAllAnchors()
      prevPageButton:Show(true)
      prevPageButton:AddAnchor("RIGHT", pageLabel, "LEFT", 0, 0)
      firstPageButton:RemoveAllAnchors()
      firstPageButton:AddAnchor("RIGHT", prevPageButton, "LEFT", 0, 0)
      nextPageButton:RemoveAllAnchors()
      nextPageButton:AddAnchor("LEFT", pageLabel, "RIGHT", 0, 0)
      lastPageButton:RemoveAllAnchors()
      lastPageButton:Show(true)
      lastPageButton:AddAnchor("LEFT", nextPageButton, "RIGHT", 0, 0)
      ApplyButtonSkin(firstPageButton, BUTTON_BASIC.PAGE_FIRST)
      ApplyButtonSkin(prevPageButton, BUTTON_BASIC.PAGE_PREV)
      ApplyButtonSkin(lastPageButton, BUTTON_BASIC.PAGE_LAST)
      ApplyButtonSkin(lastPageButton, BUTTON_BASIC.PAGE_LAST)
    end
  end
  widget:SetPageStyle(style)
  return widget
end
function W_CTRL.CreatePageControl(id, parent, style)
  local widget = SetViewOfPageControl(id, parent, style)
  function widget:ShowPageButtons(show)
    self.firstPageButton:Show(show)
    self.prevPageButton:Show(show)
    self.lastPageButton:Show(show)
    self.nextPageButton:Show(show)
  end
  function widget:Init()
    self.currentPage = 1
    self.maxPage = 1
    self.countPerPage = 1
    self.labelStyle = "normal"
    self.title = ""
    self.rotatePage = false
    self.firstPageButton:Enable(false)
    self.prevPageButton:Enable(false)
    self.lastPageButton:Enable(false)
    self.nextPageButton:Enable(false)
    self:SetCurrentPage(1, false)
  end
  function widget:SetTitleStyle(text, style)
    self.title = text
    if style == nil then
      style = "normal"
    end
    widget.labelStyle = style
  end
  function widget:UpdatePageLabel()
    if widget.labelStyle == "normal" then
      local str = string.format("%d / %d", self.currentPage, self.maxPage)
      self.pageLabel:SetText(str)
    elseif widget.labelStyle == "actionBar" then
      local str = string.format("%d", self.currentPage)
      self.pageLabel:SetText(str)
    elseif widget.labelStyle == "ucc" then
      local str = string.format("%s (%d / %d)", self.title, self.currentPage, self.maxPage)
      self.pageLabel:SetText(str)
    end
  end
  function widget:SetPageCount(count, countPerPage, notify)
    if count == nil or count < 1 then
      count = 1
    end
    if notify == nil then
      notify = true
    end
    self.countPerPage = countPerPage
    self.maxPage = count
    if self.currentPage > self.maxPage then
      self:SetCurrentPage(self.maxPage, notify)
    end
    self:UpdatePageLabel()
  end
  local function UpdatePageButton()
    widget.firstPageButton:Enable(true)
    widget.prevPageButton:Enable(true)
    widget.lastPageButton:Enable(true)
    widget.nextPageButton:Enable(true)
    if widget.rotatePage then
      return
    end
    if widget.currentPage <= 1 and widget.currentPage >= widget.maxPage then
      widget.firstPageButton:Enable(false)
      widget.prevPageButton:Enable(false)
      widget.lastPageButton:Enable(false)
      widget.nextPageButton:Enable(false)
    elseif widget.currentPage >= widget.maxPage then
      widget.lastPageButton:Enable(false)
      widget.nextPageButton:Enable(false)
    elseif widget.currentPage <= 1 then
      widget.firstPageButton:Enable(false)
      widget.prevPageButton:Enable(false)
    end
  end
  function widget:UseActionBarPageRotate()
    self.rotatePage = true
    UpdatePageButton()
  end
  function widget:Enable(isEnable)
    self.firstPageButton:Enable(isEnable)
    self.lastPageButton:Enable(isEnable)
    self.prevPageButton:Enable(isEnable)
    self.nextPageButton:Enable(isEnable)
    if isEnable then
      ApplyTextColor(self.pageLabel, self.pageLabel.defaultColor)
    else
      ApplyTextColor(self.pageLabel, FONT_COLOR.GRAY)
    end
    if isEnable then
      UpdatePageButton()
    end
  end
  function widget:SetPageByItemCount(itemCount, countPerPage, notify)
    if itemCount == nil then
      itemCount = 0
    end
    if notify == nil then
      notify = true
    end
    local pageCount = math.floor(itemCount / countPerPage)
    if itemCount % countPerPage ~= 0 then
      pageCount = pageCount + 1
    end
    self:SetPageCount(pageCount, countPerPage, notify)
    UpdatePageButton()
  end
  function widget:SetCurrentPage(index, notify)
    self.currentPage = index
    if self.currentPage < 1 then
      self.currentPage = 1
      notify = false
    elseif self.currentPage > self.maxPage then
      self.currentPage = self.maxPage
      notify = false
    end
    self:UpdatePageLabel()
    UpdatePageButton()
    if notify ~= false then
      self:CallPageChangedHanlder()
    end
  end
  function widget:GetCurrentPageIndex()
    return self.currentPage
  end
  function widget:GetTotalPageCount()
    return self.maxPage
  end
  function widget:GetCountPerPage()
    return self.countPerPage
  end
  function widget:Refresh()
    self:UpdatePageLabel()
    self:CallPageChangedHanlder()
  end
  function widget:CallPageChangedHanlder()
    self:OnPageChanged(self.currentPage, self.countPerPage)
  end
  function widget:MoveFirstPage()
    self:SetCurrentPage(1)
    UpdatePageButton()
  end
  function widget:MoveLastPage()
    self:SetCurrentPage(self.maxPage)
    UpdatePageButton()
  end
  function widget:MovePrevPage()
    if self.rotatePage and self.currentPage == 1 then
      self:SetCurrentPage(self.maxPage)
    else
      self:SetCurrentPage(self.currentPage - 1)
    end
    UpdatePageButton()
  end
  function widget:MoveNextPage()
    if self.rotatePage and self.currentPage == self.maxPage then
      self:SetCurrentPage(1)
    else
      self:SetCurrentPage(self.currentPage + 1)
    end
    UpdatePageButton()
  end
  function widget.firstPageButton:OnClick(arg)
    if arg == "LeftButton" then
      widget:MoveFirstPage()
    end
  end
  widget.firstPageButton:SetHandler("OnClick", widget.firstPageButton.OnClick)
  function widget.prevPageButton:OnClick(arg)
    if arg == "LeftButton" then
      widget:MovePrevPage()
    end
  end
  widget.prevPageButton:SetHandler("OnClick", widget.prevPageButton.OnClick)
  function widget.nextPageButton:OnClick(arg)
    if arg == "LeftButton" then
      widget:MoveNextPage()
    end
  end
  widget.nextPageButton:SetHandler("OnClick", widget.nextPageButton.OnClick)
  function widget.lastPageButton:OnClick(arg)
    if arg == "LeftButton" then
      widget:MoveLastPage()
    end
  end
  widget.lastPageButton:SetHandler("OnClick", widget.lastPageButton.OnClick)
  function widget:OnPageChanged(pageIndex, countPerPage)
    if self.ProcOnPageChanged ~= nil then
      self:ProcOnPageChanged(pageIndex, countPerPage)
    end
  end
  widget:Init()
  return widget
end
