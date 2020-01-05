local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local SetViewOfRewardWindow = function(id, parent)
  local window = CreateWindow(id, parent)
  window:Show(false)
  window:SetExtent(POPUP_WINDOW_WIDTH, 421)
  window:SetTitle(locale.ranking.reward)
  window:SetCloseOnEscape(true)
  window:SetSounds("ranking_reward")
  local scrollList = W_CTRL.CreateScrollListCtrl("scrollList", window)
  scrollList:Show(true)
  scrollList:SetUseDoubleClick(true)
  scrollList:SetHeight(275)
  local provisionDay = window:CreateChildWidget("label", "provisionDay", 0, true)
  provisionDay:SetExtent(DEFAULT_SIZE.DIALOG_CONTENT_WIDTH, FONT_SIZE.MIDDLE)
  provisionDay:AddAnchor("TOP", scrollList, "BOTTOM", 0, 8)
  ApplyTextColor(provisionDay, FONT_COLOR.BLUE)
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("BOTTOM", window, 0, BUTTON_COMMON_INSET.MESSAGEBOX_BOTTOM)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  local function OkButtonLeftClickFunc()
    window:Show(false)
  end
  ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
  return window
end
function CreateRewardWindow(id, parent)
  local window = SetViewOfRewardWindow(id, parent)
  local scrollList = window.scrollList
  scrollList:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  scrollList:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  local GradeDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem.bg:SetVisible(false)
      subItem.icon:SetVisible(false)
      if data.grade == nil then
        return
      end
      SetRankingGradeDataFunc(subItem.bg, subItem.icon, data.grade)
      local str = string.format([[
%s
%s]], locale.common.from_to(data.scopeFrom, data.scopeTo), locale.ranking.placing)
      subItem.gradeText:SetText(str)
      subItem.gradeText:SetHeight(subItem.gradeText:GetTextHeight())
    else
      subItem.bg:SetVisible(false)
      subItem.icon:SetVisible(false)
    end
  end
  local GradeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    CommonGradeLayoutFunc(widget.listCtrl, subItem)
    local icon = subItem:CreateImageDrawable(TEXTURE_PATH.RANKING_GRADE, "overlay")
    icon:AddAnchor("CENTER", subItem, 0, -13)
    subItem.icon = icon
    local gradeText = subItem:CreateChildWidget("textbox", "gradeText", 0, true)
    gradeText:SetWidth(subItem:GetWidth() - 10)
    gradeText.style:SetFontSize(FONT_SIZE.SMALL)
    gradeText:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    gradeText:AddAnchor("TOP", subItem.icon, "BOTTOM", 0, 5)
    ApplyTextColor(gradeText, FONT_COLOR.GRAY)
  end
  local function RewardDataSetFunc(subItem, data, setValue)
    if setValue then
      subItem.appellationIcon:Show(false)
      subItem.appellationName:Show(false)
      subItem.itemIcon:Show(false)
      subItem.itemName:Show(false)
      if data.appellation ~= nil then
        if data.appellation.buffType ~= nil then
          subItem.appellationIcon:Show(true)
        end
        if data.appellation.name ~= nil then
          subItem.appellationName:Show(true)
          subItem.appellationName:SetText(data.appellation.name)
          subItem.appellationName:SetHeight(subItem.appellationName:GetTextHeight())
        end
      end
      if data.itemInfo ~= nil then
        subItem.itemIcon:Show(true)
        subItem.itemName:Show(true)
        subItem.itemIcon:SetItem(data.itemInfo.type, data.itemInfo.grade, data.itemInfo.count)
        local tip = X2Item:GetItemInfoByType(data.itemInfo.type)
        subItem.itemName:SetText(tip.name)
        subItem.itemName:SetHeight(subItem.itemName:GetTextHeight())
      end
      if subItem.appellationIcon:IsVisible() and subItem.itemIcon:IsVisible() then
        subItem.appellationIcon:RemoveAllAnchors()
        subItem.appellationIcon:AddAnchor("LEFT", subItem, sideMargin / 2, -ICON_SIZE.APPELLAITON / 1.7)
        subItem.itemIcon:RemoveAllAnchors()
        subItem.itemIcon:AddAnchor("LEFT", subItem, sideMargin / 2, ICON_SIZE.APPELLAITON / 1.7)
      elseif subItem.appellationIcon:IsVisible() and not subItem.itemIcon:IsVisible() then
        subItem.appellationIcon:RemoveAllAnchors()
        subItem.appellationIcon:AddAnchor("LEFT", subItem, sideMargin / 2, 0)
      elseif not subItem.appellationIcon:IsVisible() and subItem.appellationName:IsVisible() then
        if subItem.itemIcon:IsVisible() then
          subItem.appellationName:RemoveAllAnchors()
          subItem.appellationName:AddAnchor("LEFT", subItem, sideMargin / 2, -ICON_SIZE.APPELLAITON / 1.7)
        else
          subItem.appellationName:RemoveAllAnchors()
          subItem.appellationName:AddAnchor("LEFT", subItem, sideMargin / 2, 0)
        end
      elseif not subItem.appellationIcon:IsVisible() and subItem.itemIcon:IsVisible() then
        subItem.itemIcon:RemoveAllAnchors()
        subItem.itemIcon:AddAnchor("LEFT", subItem, sideMargin / 2, 0)
      end
    else
      subItem.appellationIcon:Show(false)
      subItem.appellationName:Show(false)
      subItem.itemIcon:Show(false)
      subItem.itemName:Show(false)
    end
  end
  local function RewardLayoutSetFunc(widget, rowIndex, colIndex, subItem)
    local appellationIcon = CreateItemIconButton(subItem:GetId() .. ".appellationIcon", subItem)
    appellationIcon:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    appellationIcon:AddAnchor("LEFT", subItem, sideMargin / 2, -ICON_SIZE.APPELLAITON / 1.7)
    subItem.appellationIcon = appellationIcon
    local appellationName = subItem:CreateChildWidget("textbox", "appellationName", 0, true)
    appellationName:SetWidth(150)
    appellationName:AddAnchor("LEFT", appellationIcon, "RIGHT", 7, 0)
    appellationName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(appellationName, FONT_COLOR.DEFAULT)
    local itemIcon = CreateSlotItemButton(subItem:GetId() .. ".itemIcon", subItem)
    itemIcon:SetExtent(ICON_SIZE.APPELLAITON, ICON_SIZE.APPELLAITON)
    itemIcon:AddAnchor("LEFT", subItem, sideMargin / 2, ICON_SIZE.APPELLAITON / 1.7)
    subItem.itemIcon = itemIcon
    local itemName = subItem:CreateChildWidget("textbox", "itemName", 0, true)
    itemName:SetWidth(150)
    itemName:AddAnchor("LEFT", itemIcon, "RIGHT", 7, 0)
    itemName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
  end
  scrollList:InsertColumn(locale.ranking.rank, 80, LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  scrollList:InsertColumn(locale.ranking.reward, 215, LCCIT_WINDOW, RewardDataSetFunc, nil, nil, RewardLayoutSetFunc)
  scrollList:InsertRows(3, false)
  DrawListCtrlUnderLine(scrollList.listCtrl)
  for i = 1, #scrollList.listCtrl.column do
    SettingListColumn(scrollList.listCtrl, scrollList.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(scrollList.listCtrl.column[i], #scrollList.listCtrl.column, i)
  end
  for i = 1, scrollList:GetRowCount() do
    ListCtrlItemGuideLine(scrollList.listCtrl.items, scrollList:GetRowCount())
  end
  function window:FillRewardInfo(rewardInfo, periodInfo)
    self.scrollList:DeleteAllDatas()
    for i = 1, self.scrollList:GetRowCount() do
      if scrollList.listCtrl.items[i].line ~= nil then
        scrollList.listCtrl.items[i].line:SetVisible(false)
      end
    end
    if rewardInfo ~= nil then
      if #rewardInfo >= self.scrollList:GetRowCount() then
        for i = 1, self.scrollList:GetRowCount() do
          if scrollList.listCtrl.items[i].line ~= nil then
            scrollList.listCtrl.items[i].line:SetVisible(true)
          end
        end
      else
        for i = 1, #rewardInfo do
          if scrollList.listCtrl.items[i].line ~= nil then
            scrollList.listCtrl.items[i].line:SetVisible(true)
          end
        end
      end
      for i = 1, #rewardInfo do
        local scopeInfo = {
          grade = i,
          scopeTo = rewardInfo[i].scopeTo,
          scopeFrom = rewardInfo[i].scopeFrom,
          scopeName = rewardInfo[i].scopeName
        }
        self.scrollList:InsertData(i, 1, scopeInfo)
        local rewardColumnInfo = {
          appellation = rewardInfo[i].appellation,
          itemInfo = rewardInfo[i].item
        }
        self.scrollList:InsertData(i, 2, rewardColumnInfo)
      end
    end
    local filter = rankingLocale.timeFilter.reward
    local str = locale.time.GetDateToDateFormat(periodInfo, filter)
    self.provisionDay:SetText(locale.ranking.rewardProvisionDay(str))
  end
  return window
end
function CreateRenewaledRewardWindow(id, parent)
  local window = SetViewOfRewardWindow(id, parent)
  window:SetHeight(452)
  local scrollList = window.scrollList
  local rankInfo
  local divisionWidget = UIParent:CreateWidget("emptywidget", "divisions", window)
  divisionWidget:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  divisionWidget:AddAnchor("TOPRIGHT", window, -sideMargin, titleMargin)
  divisionWidget:SetExtent(POPUP_WINDOW_WIDTH, 28)
  local divisionLabel = divisionWidget:CreateChildWidget("label", "divisionLabel", 0, true)
  divisionLabel:SetExtent(70, divisionWidget:GetHeight())
  divisionLabel:AddAnchor("TOPLEFT", divisionWidget, 0, 0)
  ApplyTextColor(divisionLabel, FONT_COLOR.DEFAULT)
  divisionLabel:SetText(GetUIText(COMMON_TEXT, "ranking_reward_division"))
  local divisionCombo = W_CTRL.CreateComboBox("divisionCombo", divisionWidget)
  divisionCombo:SetWidth(divisionWidget:GetWidth() - divisionLabel:GetWidth() - sideMargin)
  divisionCombo:AddAnchor("TOPLEFT", divisionLabel, "TOPRIGHT", 0, 0)
  function divisionCombo:SetComboItem(divisions)
    if #divisions <= 0 then
      return
    end
    self.divisions = {}
    local datas = {}
    for i = 1, #divisions do
      local data = {
        text = divisions[i].division == "global" and GetUIText(COMMON_TEXT, "ranking_division_global") or serverName,
        value = i
      }
      table.insert(datas, data)
      self.divisions[i] = divisions[i].division
    end
    self:AppendItems(datas, false)
  end
  function divisionCombo:SelectedProc(index)
    local rewards = X2Rank:GetRankingRewards(rankInfo.code, self.divisions[index])
    window:FillRewardInfo(rewards)
  end
  scrollList:AddAnchor("TOPLEFT", divisionWidget, "BOTTOMLEFT", 0, 5)
  scrollList:AddAnchor("TOPRIGHT", divisionWidget, "BOTTOMRIGHT", 0, 5)
  local GradeDataSetFunc = function(subItem, data, setValue)
    subItem.bg:SetVisible(false)
    subItem.icon:SetVisible(false)
    if setValue then
      if data.grade > 0 then
        SetRankingGradeDataFunc(subItem.bg, subItem.icon, data.grade)
      end
      local str = string.format([[
%s
%s]], locale.common.from_to(data._begin, data._end), locale.ranking.placing)
      subItem.gradeText:SetText(str)
      subItem.gradeText:SetHeight(subItem.gradeText:GetTextHeight())
    end
  end
  local GradeLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    CommonGradeLayoutFunc(widget.listCtrl, subItem)
    local icon = subItem:CreateImageDrawable(TEXTURE_PATH.RANKING_GRADE, "overlay")
    icon:AddAnchor("CENTER", subItem, 0, -13)
    subItem.icon = icon
    local gradeText = subItem:CreateChildWidget("textbox", "gradeText", 0, true)
    gradeText:SetWidth(subItem:GetWidth() - 10)
    gradeText.style:SetFontSize(FONT_SIZE.SMALL)
    gradeText:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
    gradeText:AddAnchor("TOP", subItem.icon, "BOTTOM", 0, 5)
    ApplyTextColor(gradeText, FONT_COLOR.GRAY)
  end
  local RewardDataSetFunc = function(subItem, data, setValue)
    local show = false
    if setValue and data.rewardItem ~= nil then
      subItem.itemIcon:SetItem(data.rewardItem, data.itemGrade, data.count)
      local tip = X2Item:GetItemInfoByType(data.rewardItem)
      subItem.itemName:SetText(tip.name)
      subItem.itemName:SetHeight(subItem.itemName:GetTextHeight())
      show = true
    end
    subItem.itemIcon:Show(show)
    subItem.itemName:Show(show)
  end
  local RewardLayoutSetFunc = function(widget, rowIndex, colIndex, subItem)
    local itemIcon = CreateSlotItemButton(subItem:GetId() .. ".itemIcon", subItem)
    itemIcon:AddAnchor("LEFT", subItem, "LEFT", 0, 0)
    subItem.itemIcon = itemIcon
    local itemName = subItem:CreateChildWidget("textbox", "itemName", 0, true)
    itemName:SetWidth(150)
    itemName:AddAnchor("LEFT", itemIcon, "RIGHT", 7, 0)
    itemName.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(itemName, FONT_COLOR.DEFAULT)
  end
  scrollList:InsertColumn(locale.ranking.rank, 80, LCCIT_WINDOW, GradeDataSetFunc, nil, nil, GradeLayoutSetFunc)
  scrollList:InsertColumn(locale.ranking.reward, 215, LCCIT_WINDOW, RewardDataSetFunc, nil, nil, RewardLayoutSetFunc)
  scrollList:InsertRows(3, false)
  DrawListCtrlUnderLine(scrollList.listCtrl)
  for i = 1, #scrollList.listCtrl.column do
    SettingListColumn(scrollList.listCtrl, scrollList.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(scrollList.listCtrl.column[i], #scrollList.listCtrl.column, i)
  end
  for i = 1, scrollList:GetRowCount() do
    ListCtrlItemGuideLine(scrollList.listCtrl.items, scrollList:GetRowCount())
  end
  function window:FillRewardInfo(rewardInfo)
    scrollList:DeleteAllDatas()
    for i = 1, scrollList:GetRowCount() do
      if scrollList.listCtrl.items[i].line ~= nil then
        scrollList.listCtrl.items[i].line:SetVisible(false)
      end
    end
    local visibleCnt = #rewardInfo >= scrollList:GetRowCount() and scrollList:GetRowCount() or #rewardInfo
    for i = 1, visibleCnt do
      if scrollList.listCtrl.items[i].line ~= nil then
        scrollList.listCtrl.items[i].line:SetVisible(true)
      end
    end
    for i = 1, #rewardInfo do
      local reward = rewardInfo[i]
      scrollList:InsertRowData(i, 2, reward)
    end
    scrollList:UpdateView()
  end
  function window:SetReward(info)
    rankInfo = info
    local divisions = X2Rank:GetRankingRewardDivisions(rankInfo.code)
    divisionCombo:SetComboItem(divisions)
    divisionCombo:Select(1)
    local seasonoffDate = X2Rank:GetRankingSeasonOffDate(rankInfo.code)
    local filter = rankingLocale.timeFilter.reward
    local str = locale.time.GetDateToDateFormat(seasonoffDate, filter)
    self.provisionDay:SetText(locale.ranking.rewardProvisionDay(str))
  end
  return window
end
