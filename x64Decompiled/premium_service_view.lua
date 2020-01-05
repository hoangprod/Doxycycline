function SetViewOfPremiumServiceFrame(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local tabCount = 3
  if not premiumServiceLocale.pointRuleButton then
    tabCount = tabCount - 1
  end
  if not premiumServiceLocale.serviceBuyButton then
    tabCount = tabCount - 1
  end
  local window = CreateWindow(id, parent, "premium_service")
  window:SetCloseOnEscape(true, true)
  window:AddAnchor("CENTER", "UIParent", 0, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "premium_service"))
  window:SetWidth(premiumServiceLocale.premiumWndWidth)
  local tab, endTimeLabelAnchorTarget
  if premiumServiceLocale.showPcbangBenefit then
    local textTable = {
      GetUIText(PREMIUM_TEXT, "premium_service"),
      GetUIText(COMMON_TEXT, "pcbang")
    }
    local outsideTab = W_BTN.CreateTab("outsideTab", window)
    outsideTab:AddTabs(textTable)
    endTimeLabelAnchorTarget = outsideTab
    tab = outsideTab.window[1]:CreateChildWidget("tab", "tab", 0, false)
    tab:AddAnchor("TOPLEFT", outsideTab, 0, BUTTON_SIZE.TAB_SELECT.HEIGHT + sideMargin * 1.1)
    tab:AddAnchor("BOTTOMRIGHT", outsideTab, 0, 0)
    window.tab = tab
    CreatePcbangBenefit(outsideTab.window[2])
    local bg = CreateContentBackground(tab, "TYPE2", "brown")
    bg:SetExtent(tab:GetWidth(), 45)
    bg:AddAnchor("TOPLEFT", outsideTab, 0, BUTTON_SIZE.TAB_SELECT.HEIGHT + sideMargin / 2)
    tab.bg = bg
    if X2Player:GetUIScreenState() ~= SCREEN_CHARACTER_SELECT and premiumServiceLocale.pointProgressBar then
      local progressbar = SetViewOfPremiumServiceGradeFrame("progressbar", outsideTab.window[1])
      progressbar:AddAnchor("TOPLEFT", bg, "BOTTOMLEFT", (tab:GetWidth() - progressbar:GetWidth()) / 2, sideMargin)
      window.progressbar = progressbar
    end
  else
    tab = window:CreateChildWidget("tab", "tab", 0, true)
    tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
    tab:AddAnchor("BOTTOMRIGHT", window, -sideMargin, -sideMargin)
    endTimeLabelAnchorTarget = tab
    if X2Player:GetUIScreenState() ~= SCREEN_CHARACTER_SELECT and premiumServiceLocale.pointProgressBar then
      local progressbar = SetViewOfPremiumServiceGradeFrame("progressbar", window)
      progressbar:AddAnchor("TOPLEFT", tab, -sideMargin / 2, BUTTON_SIZE.TAB_SELECT.HEIGHT + sideMargin)
      window.progressbar = progressbar
    end
  end
  local OnTabChanged = function(self, selected)
    ReAnhorTabLine(self, selected)
  end
  tab:SetHandler("OnTabChanged", OnTabChanged)
  function tab:AnchorContent(content, anchorTarget)
    if anchorTarget == nil then
      anchorTarget = content:GetParent()
    end
    local offsetY = sideMargin / 2
    if premiumServiceLocale.showPcbangBenefit then
      anchorTarget = window.outsideTab.window[1]
      offsetY = tab.bg:GetHeight() + sideMargin
    end
    if premiumServiceLocale.pointProgressBar and window.progressbar ~= nil then
      anchorTarget = window.progressbar
      offsetY = window.progressbar:GetHeight() + sideMargin / 2 + premiumServiceLocale.progressBarOffsetY
    end
    content:AddAnchor("TOPLEFT", anchorTarget, 0, offsetY)
    content:AddAnchor("TOPRIGHT", anchorTarget, 0, offsetY)
  end
  local tabIndex = 1
  if premiumServiceLocale.serviceBuyButton then
    tab:AddSimpleTab(locale.store.buyAll)
    CreateServiceBuyList(tab.window[tabIndex], anchorTarget, window)
    tabIndex = tabIndex + 1
  end
  tab:AddSimpleTab(locale.premium.benefit)
  CreateBenefitList(tab.window[tabIndex], anchorTarget)
  local function OkButtonLeftClickFunc()
    window:Show(false)
  end
  tab.window[tabIndex].okBtn:SetHandler("OnClick", OkButtonLeftClickFunc)
  tabIndex = tabIndex + 1
  if premiumServiceLocale.pointRuleButton then
    tab:AddSimpleTab(locale.premium.point_rule)
    CreatePointRuleView(tab.window[tabIndex], anchorTarget)
    local function LeftClickButton()
      window:Show(false)
    end
    tab.window[tabIndex].okBtn:SetHandler("OnClick", LeftClickButton)
  end
  if premiumServiceLocale.showPcbangBenefit then
    for i = 1, tabCount do
      ApplyButtonSkin(tab.selectedButton[i], BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_SELECTED)
      tab.selectedButton[i]:SetAutoResize(true)
      ApplyButtonSkin(tab.unselectedButton[i], BUTTON_CONTENTS.INGAMESHOP_SUB_MENU_UNSELECTED)
      tab.unselectedButton[i]:SetAutoResize(true)
    end
    for j = 1, tabCount - 1 do
      local seperateLabel = tab:CreateChildWidget("label", "seperateLabel", j, false)
      seperateLabel:SetWidth(20)
      seperateLabel:SetText("|")
      seperateLabel:SetHeight(FONT_SIZE.MIDDLE)
      seperateLabel:AddAnchor("LEFT", tab.selectedButton[j], "RIGHT", 0, 0)
      local c = GetIngameShopUnselectedSubMenuButtonFontColor().normal
      ApplyTextColor(seperateLabel, c)
    end
    tab:SetGap(23)
    tab:SetOffset(15)
  else
    local buttonTable = {}
    for i = 1, tabCount do
      ApplyButtonSkin(tab.selectedButton[i], BUTTON_BASIC.TAB_SELECT)
      ApplyButtonSkin(tab.unselectedButton[i], BUTTON_BASIC.TAB_UNSELECT)
      table.insert(buttonTable, tab.selectedButton[i])
      table.insert(buttonTable, tab.unselectedButton[i])
    end
    AdjustBtnLongestTextWidth(buttonTable)
    tab:SetGap(-2)
    DrawTabSkin(tab, tab.window[1], tab.selectedButton[1])
  end
  tab:SetCorner("TOPLEFT")
  tab:SelectTab(1)
  if baselibLocale.premiumService.showEndTime then
    do
      local label = window:CreateChildWidget("label", "endtimelabel", 0, true)
      label:SetHeight(FONT_SIZE.LARGE)
      label:SetAutoResize(true)
      label.style:SetFontSize(FONT_SIZE.LARGE)
      ApplyTextColor(label, FONT_COLOR.RED)
      label:AddAnchor("TOPRIGHT", endTimeLabelAnchorTarget, 0, sideMargin / 2)
      function label:OnUpdate()
        local premiumService = X2PremiumService:IsPremiumService()
        local endTime = X2PremiumService:GetPremiumSeviceEndTime()
        local text = ""
        if premiumService and endTime ~= nil then
          text = premiumServiceLocale.GetDateToPremiumServiceFormat(endTime.payEnd)
        end
        label:SetText(text)
      end
      label:OnUpdate()
    end
  end
  local modalLoadingWindow = CreateLoadingTextureSet(window)
  modalLoadingWindow:AddAnchor("TOPLEFT", window, -1, 0)
  modalLoadingWindow:AddAnchor("BOTTOMRIGHT", window, 1, 0)
  local OnHide = function()
    X2PremiumService:SetVisiblePremiumService(false)
  end
  window:SetHandler("OnHide", OnHide)
  function window:GetContentHeight()
    local tabHeight = 0
    for i = 1, #tab.window do
      if tabHeight < tab.window[i]:GetContentHeight() then
        tabHeight = tab.window[i]:GetContentHeight()
      end
    end
    if premiumServiceLocale.showPcbangBenefit and window.outsideTab.window[2] ~= nil and tabHeight < window.outsideTab.window[2]:GetContentHeight() then
      tabHeight = window.outsideTab.window[2]:GetContentHeight()
    end
    local height = titleMargin + BUTTON_SIZE.TAB_SELECT.HEIGHT + sideMargin + tabHeight
    if premiumServiceLocale.pointProgressBar and window.progressbar ~= nil then
      height = height + window.progressbar:GetHeight() + sideMargin / 2
    end
    if premiumServiceLocale.showPcbangBenefit and tab.bg ~= nil then
      height = height + tab.bg:GetHeight() + sideMargin / 2
    end
    if premiumServiceLocale.useAAPoint then
      height = height + sideMargin * 2
    end
    return height
  end
  return window
end
