local CreateCharRankList = function(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(430, 468)
  window:SetTitle(GetUIText(COMMON_TEXT, "battlefield_char_rank_list_title"))
  window:SetCloseOnEscape(true)
  window.titleBar.closeButton:Show(true)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local contentWidth = window:GetWidth() - sideMargin * 2
  local scrollList = W_CTRL.CreateScrollListCtrl("scrollList", window)
  scrollList:SetWidth(contentWidth)
  scrollList:SetHeight(350)
  scrollList:HideColumnButtons()
  scrollList:AddAnchor("TOPLEFT", window, sideMargin, titleMargin + 5)
  window.scrollList = scrollList
  function window:FillRankInfos(rankInfos)
    self.scrollList:DeleteAllDatas()
    for i = 1, self.scrollList:GetRowCount() do
      if self.scrollList.listCtrl.items[i].line ~= nil then
        self.scrollList.listCtrl.items[i].line:SetVisible(false)
      end
    end
    if rankInfos == nil then
      return
    end
    local visibleCnt = #rankInfos >= scrollList:GetRowCount() and scrollList:GetRowCount() or #rankInfos
    for i = 1, visibleCnt do
      if self.scrollList.listCtrl.items[i].line ~= nil then
        self.scrollList.listCtrl.items[i].line:SetVisible(true)
      end
    end
    for i = 1, #rankInfos do
      self.scrollList:InsertData(i, 1, rankInfos[i])
      self.scrollList:InsertData(i, 2, rankInfos[i])
      self.scrollList:InsertData(i, 3, rankInfos[i])
    end
  end
  local RankDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.rank))
      subItem.style:SetAlign(ALIGN_CENTER)
      if data.highRanker == true then
        ApplyTextColor(subItem, FONT_COLOR.BLUE)
      else
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
    else
      subItem:SetText("")
    end
  end
  local NameDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.name))
      subItem:SetInset(10, 0, 0, 0)
      subItem.style:SetAlign(ALIGN_LEFT)
      if data.highRanker == true then
        ApplyTextColor(subItem, FONT_COLOR.BLUE)
      else
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
    else
      subItem:SetText("")
    end
  end
  local ScoreDataSetFunc = function(subItem, data, setValue)
    if setValue then
      subItem:SetText(tostring(data.score))
      subItem.style:SetAlign(ALIGN_CENTER)
      if data.highRanker == true then
        ApplyTextColor(subItem, FONT_COLOR.BLUE)
      else
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      end
    else
      subItem:SetText("")
    end
  end
  scrollList:InsertColumn(locale.ranking.placing, 65, LCCIT_STRING, RankDataSetFunc, nil, nil, nil)
  scrollList:InsertColumn(locale.common.name, 230, LCCIT_CHARACTER_NAME, NameDataSetFunc, nil, nil, nil)
  scrollList:InsertColumn(GetUIText(COMMON_TEXT, "score"), 76, LCCIT_STRING, ScoreDataSetFunc, nil, nil, nil)
  scrollList:InsertRows(12, false)
  DrawListCtrlUnderLine(scrollList)
  for i = 1, #scrollList.listCtrl.column do
    SettingListColumn(scrollList.listCtrl, scrollList.listCtrl.column[i])
    DrawListCtrlColumnSperatorLine(scrollList.listCtrl.column[i], #scrollList.listCtrl.column, i)
  end
  local okButton = window:CreateChildWidget("button", "okButton", 0, true)
  okButton:SetText(locale.common.ok)
  okButton:AddAnchor("BOTTOM", window, 0, -20)
  ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
  window.okButton = okButton
  local OkButtonClickFunc = function()
    CharRankListFunc(false)
  end
  ButtonOnClickHandler(okButton, OkButtonClickFunc)
  window.titleBar.closeButton:SetHandler("OnClick", OkButtonClickFunc)
  window:SetHandler("OnCloseByEsc", OkButtonClickFunc)
  local events = {
    INSTANT_GAME_END = function()
      CharRankListFunc(false)
    end,
    INSTANT_GAME_RETIRE = function()
      CharRankListFunc(false)
    end,
    UPDATE_INSTANT_GAME_SCORES = function()
      window:FillRankInfos(X2BattleField:GetProgressRankInfo())
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
function CharRankListFunc(arg)
  if arg == true then
    if battlefield.charRankList == nil then
      battlefield.charRankList = CreateCharRankList("charRankList", "UIParent")
      battlefield.charRankList:Show(true)
      battlefield.charRankList:EnableHidingIsRemove(true)
      battlefield.charRankList:FillRankInfos(X2BattleField:GetProgressRankInfo())
    else
      battlefield.charRankList:Show(true)
    end
  else
    battlefield.charRankList:Show(false)
    battlefield.charRankList = nil
  end
end
function ToggleCharRankListFunc()
  if battlefield.charRankList == nil then
    CharRankListFunc(true)
  else
    local visible = battlefield.charRankList:IsVisible()
    CharRankListFunc(not visible)
  end
end
