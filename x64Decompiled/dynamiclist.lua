function CreateDynamicListWindow(parent, id)
  local frame = parent:CreateChildWidget("dynamiclist", id, 0, true)
  frame:Show(true)
  function frame:UseOverTexture(style)
    if style == nil or style == "" then
      frame.overedImage = self:CreateOveredImage("overlay")
      frame.overedImage:SetTexture(TEXTURE_PATH.TAB_LIST)
      frame.overedImage:SetCoords(0, 65, 134, 11)
      frame.overedImage:SetInset(66, 5, 67, 5)
      frame.overedImage:SetColor(ConvertColor(150), ConvertColor(197), ConvertColor(220), 0.4)
    elseif style == "achievement" then
      frame.overedImage = self:CreateOveredImage("overlay")
      frame.overedImage:SetTexture(TEXTURE_PATH.ACHIEVEMENT)
      frame.overedImage:SetTextureInfo("slot_ov")
    end
  end
  local scroll = W_CTRL.CreateScroll("scroll", frame)
  scroll:AddAnchor("TOPLEFT", frame, "TOPRIGHT", 0, 0)
  scroll:AddAnchor("BOTTOMLEFT", frame, "BOTTOMRIGHT", 0, 0)
  scroll:SetWheelMoveStep(40)
  scroll:SetButtonMoveStep(5)
  scroll:AlwaysScrollShow()
  frame.scroll = scroll
  frame.content:AddAnchor("RIGHT", scroll, "LEFT", 0, 0)
  local function OnDynamicListUpdatedView(self)
    frame:UpdateScroll()
  end
  frame:SetHandler("OnDynamicListUpdatedView", OnDynamicListUpdatedView)
  function frame:SetEnable(enable)
    self:Enable(enable)
    scroll:SetEnable(enable)
  end
  function frame:UpdateScroll()
    local max = frame:GetScrollMaxValue()
    frame:SetMinMaxValues(0, max)
    local v = frame:GetCurrentHeight()
    frame.scroll.vs:SetValue(v, false)
  end
  local function OnSliderChanged(self, value)
    frame:MoveHeight(value)
  end
  scroll.vs:SetHandler("OnSliderChanged", OnSliderChanged)
  local pageControl = W_CTRL.CreatePageControl(id, frame)
  pageControl:Show(false)
  pageControl:RemoveAllAnchors()
  pageControl:AddAnchor("TOP", frame, "BOTTOM", 0, 0)
  frame.pageControl = pageControl
  local _pageData = {}
  local _visiblePageData = {}
  function frame:ClearPageData()
    _pageData = {}
    _visiblePageData = {}
    frame:ClearData()
  end
  function frame:DeletePageData(index, forceUpdate)
    if index == nil then
      return
    end
    if index <= 0 or index > #_pageData then
      return
    end
    table.remove(_pageData, index)
    if forceUpdate then
      local countPerPage = frame.pageControl:GetCountPerPage()
      local currentPage = frame.pageControl:GetCurrentPageIndex()
      if currentPage == nil or countPerPage == nil or countPerPage == 0 then
        return
      end
      local targetPage = math.floor((index - 1) / countPerPage + 1)
      if targetPage == nil then
        return
      end
      if currentPage > targetPage then
        self:EraseData(1)
        local pageStartIndex = (currentPage - 1) * countPerPage + 1
        local currentLastIndex = pageStartIndex + countPerPage - 1
        if currentLastIndex <= #_pageData then
          local visibleLastData = _pageData[currentLastIndex]
          if visibleLastData == nil or visibleLastData.main == nil or visibleLastData.subList == nil then
            return
          end
          self:InsertData(countPerPage, visibleLastData.main, visibleLastData.subList)
        end
      elseif targetPage == currentPage then
        local pageStartIndex = (currentPage - 1) * countPerPage + 1
        local targetIndex = index - pageStartIndex + 1
        self:EraseData(targetIndex)
        local currentLastIndex = pageStartIndex + countPerPage - 1
        if currentLastIndex <= #_pageData then
          local visibleLastData = _pageData[currentLastIndex]
          if visibleLastData == nil or visibleLastData.main == nil or visibleLastData.subList == nil then
            return
          end
          self:InsertData(countPerPage, visibleLastData.main, visibleLastData.subList)
        end
      elseif currentPage < targetPage then
      end
      frame.pageControl:SetPageByItemCount(#_pageData, countPerPage)
      self:UpdateView()
    end
  end
  function frame:InsertPageData(index, mainKey, subKeyList, forceUpdate)
    if index == nil or mainKey == nil then
      return
    end
    if index <= 0 or index > #_pageData + 1 then
      return
    end
    if subKeyList == nil then
      subKeyList = {}
    end
    local data = {main = mainKey, subList = subKeyList}
    table.insert(_pageData, index, data)
    if forceUpdate then
      local countPerPage = frame.pageControl:GetCountPerPage()
      local currentPage = frame.pageControl:GetCurrentPageIndex()
      if currentPage == nil or countPerPage == nil or countPerPage == 0 then
        return
      end
      local targetPage = math.floor((index - 1) / countPerPage + 1)
      if targetPage == nil then
        return
      end
      if currentPage > targetPage then
        local pageStartIndex = (currentPage - 1) * countPerPage + 1
        local visibleFirstData = _pageData[pageStartIndex]
        if visibleFirstData == nil or visibleFirstData.main == nil or visibleFirstData.subList == nil then
          return
        end
        self:InsertData(1, visibleFirstData.main, visibleFirstData.subList)
        self:EraseData(countPerPage + 1)
      elseif targetPage == currentPage then
        local pageStartIndex = (currentPage - 1) * countPerPage + 1
        local targetIndex = index - pageStartIndex + 1
        self:InsertData(targetIndex, data.main, data.subList)
        self:EraseData(countPerPage + 1)
      elseif currentPage < targetPage then
      end
      frame.pageControl:SetPageByItemCount(#_pageData, countPerPage)
      self:UpdateView()
    end
  end
  function frame:PushPageData(mainKey, subKeyList, forceUpdate)
    frame:InsertPageData(#_pageData + 1, mainKey, subKeyList, forceUpdate)
  end
  function frame:UpdatePageView()
    if #_visiblePageData <= 0 then
      frame:UpdateScroll()
      return
    end
    frame:ClearData()
    for i = 1, #_visiblePageData do
      local mainKey = _visiblePageData[i].main
      local subKeyList = _visiblePageData[i].subList
      if subKeyList == nil then
        subKeyList = {}
      end
      self:PushData(mainKey, subKeyList)
    end
    self:UpdateView()
  end
  function frame:UpdateVisiblePageData()
    if #_pageData <= 0 then
      return
    end
    local countPerPage = frame.pageControl:GetCountPerPage()
    local currentPage = frame.pageControl:GetCurrentPageIndex()
    local startIndex = (currentPage - 1) * countPerPage + 1
    local endIndex = startIndex + countPerPage - 1
    if countPerPage == nil or currentPage == nil then
      return
    end
    _visiblePageData = {}
    for i = startIndex, endIndex do
      if _pageData[i] == nil then
        break
      end
      table.insert(_visiblePageData, _pageData[i])
    end
  end
  function pageControl:ProcOnPageChanged(pageIndex, countPerPage)
    frame.scroll.vs:SetValue(0, false)
    if #_pageData <= 0 then
      frame:UpdateScroll()
      return
    end
    frame:UpdateVisiblePageData()
    frame:UpdatePageView()
  end
  function frame:FindData(mainIndex)
    if _pageData == nil then
      return nil
    end
    return _pageData[mainIndex]
  end
  function frame:FindIndex(mainKey)
    if mainKey == nil then
      return nil
    end
    for i = 1, #_pageData do
      if _pageData[i].main == mainKey then
        return i
      end
    end
    return nil
  end
  function frame:FindIndexFromSubKey(subKey)
    for mainIndex = 1, #_pageData do
      local subKeyList = _pageData[mainIndex].subList
      if subKeyList ~= nil then
        for subIndex = 1, #subKeyList do
          if subKeyList[subIndex] == subKey then
            return mainIndex
          end
        end
      end
    end
    return nil
  end
  function frame:IsVisibleIndex(index)
    if #_visiblePageData <= 0 then
      return false
    end
    local countPerPage = frame.pageControl:GetCountPerPage()
    local currentPage = frame.pageControl:GetCurrentPageIndex()
    local descPage = math.ceil((index - 1) / countPerPage)
    if currentPage == descPage then
      return true
    end
    return false
  end
  local _currentPageIndex
  function frame:SaveCurrentPage()
    self:SaveItemList()
    _currentPageIndex = frame.pageControl:GetCurrentPageIndex()
  end
  function frame:LoadCurrentPage()
    if _currentPageIndex ~= nil then
      frame.pageControl:SetCurrentPage(_currentPageIndex, true)
      self:LoadItemList()
    end
  end
  function frame:UpdateDatas(mainKey, subKeyList)
    if mainKey == nil then
      return
    end
    if subKeyList == nil then
      subKeyList = {}
    end
    self:UpdateData(mainKey, subKeyList)
    self:UpdateView()
  end
  function frame:MoveIndexScroll(index, anchorHeight, open)
    if index == nil then
      return
    end
    local countPerPage = frame.pageControl:GetCountPerPage()
    local currentPage = frame.pageControl:GetCurrentPageIndex()
    local descPage = math.ceil((index - 1) / countPerPage)
    if currentPage ~= descPage then
      frame.pageControl:SetCurrentPage(descPage, true)
    end
    local dataIndex = (index - 1) % countPerPage
    if anchorHeight == nil then
      anchorHeight = 0
    end
    if open == nil then
      open = false
    end
    self:MoveIndex(dataIndex, anchorHeight, open)
  end
  return frame
end
