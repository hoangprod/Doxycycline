ARCHE_PASS_LIST_INFO = {
  LIST_ROW_COUNT = 5,
  COLUMN_HEIGHT = 33,
  LIST_DATA_HEIGHT = 48
}
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local LIST_ROW_COUNT = ARCHE_PASS_LIST_INFO.LIST_ROW_COUNT
local COLUMN_HEIGHT = ARCHE_PASS_LIST_INFO.COLUMN_HEIGHT
local TracingBtnChecked = function(checkBtn, index)
  local checked = checkBtn:GetChecked()
  local info = X2Achievement:GetTodayAssignmentInfo(TADT_ARCHE_PASS, index)
  if info.questType ~= nil and info.questType ~= 0 then
    if checked then
      AddQuestToNotifier(info.questType)
    else
      RemoveQuestFromNotifier(info.questType)
    end
  end
end
local function TodayAssignmentDataSetFunc(subItem, index, setValue)
  local function CheckFunc(checkBtn)
    TracingBtnChecked(checkBtn, index)
  end
  function subItem:handleClick()
    return subItem.checkBtn:IsMouseOver()
  end
  if setValue then
    subItem:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_LIST, TADT_ARCHE_PASS, index, CheckFunc, TracingBtnEntered)
  else
    subItem:SetTodayAssignment()
  end
end
function CreateArchePassWnd(parent)
  parent.isArchePassWnd = true
  local CreateMyArchePassFrame = function(parent)
    local myPassInfoWnd = parent:CreateChildWidget("emptyWidget", "myPassInfoWnd", 0, true)
    myPassInfoWnd:Show(true)
    myPassInfoWnd:SetExtent(860, 61)
    myPassInfoWnd:AddAnchor("TOP", parent, "TOP", 0, 5)
    parent.myPassInfoWnd = myPassInfoWnd
    local myPassInfoBg = CreateContentBackground(myPassInfoWnd, "TYPE2", "brown")
    myPassInfoBg:AddAnchor("TOPLEFT", myPassInfoWnd, 0, 0)
    myPassInfoBg:AddAnchor("BOTTOMRIGHT", myPassInfoWnd, 0, 0)
    local myPassItemIconFrame = CreateItemIconButton("myPassItemIconFrame", parent)
    myPassItemIconFrame:SetExtent(44, 44)
    myPassItemIconFrame:AddAnchor("LEFT", myPassInfoWnd, 15, 0)
    local myPassItemIcon = parent:CreateImageDrawable("ui/icon/archepass/icon_pass_01.dds", "overlay")
    myPassItemIcon:SetExtent(40, 40)
    myPassItemIcon:AddAnchor("TOPLEFT", myPassItemIconFrame, 2, 2)
    parent.myPassItemIcon = myPassItemIcon
    local myPassNameImg = parent:CreateDrawable("ui/eventcenter/icon_text.dds", "name", "artwork")
    myPassNameImg:AddAnchor("TOPLEFT", myPassItemIcon, 65, -3)
    local myPassPeroidImg = parent:CreateDrawable("ui/eventcenter/icon_text.dds", "date", "artwork")
    myPassPeroidImg:AddAnchor("TOPLEFT", myPassItemIcon, 65, 21)
    local myPassNameLabel = parent:CreateChildWidget("textbox", "myPassNameLabel", 0, true)
    myPassNameLabel:AddAnchor("LEFT", myPassNameImg, "RIGHT", 10, 0)
    myPassNameLabel:SetExtent(600 - myPassNameImg:GetWidth() - 20, FONT_SIZE.MIDDLE)
    myPassNameLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myPassNameLabel, FONT_COLOR.DEFAULT)
    myPassNameLabel.style:SetAlign(ALIGN_LEFT)
    myPassNameLabel.style:SetEllipsis(true)
    parent.myPassNameLabel = myPassNameLabel
    local myPassPeriodLabel = parent:CreateChildWidget("textbox", "myPassPeriodLabel", 0, true)
    myPassPeriodLabel:AddAnchor("LEFT", myPassPeroidImg, "RIGHT", 10, 0)
    myPassPeriodLabel:SetExtent(600 - myPassPeroidImg:GetWidth() - 20, FONT_SIZE.MIDDLE)
    myPassPeriodLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myPassPeriodLabel, FONT_COLOR.DEFAULT)
    myPassPeriodLabel.style:SetAlign(ALIGN_LEFT)
    myPassPeriodLabel.style:SetEllipsis(true)
    parent.myPassPeriodLabel = myPassPeriodLabel
    local myPassEmptyLabel = parent:CreateChildWidget("textbox", "myPassEmptyLabel", 0, true)
    myPassEmptyLabel:AddAnchor("LEFT", myPassPeroidImg, "RIGHT", 10, -13)
    myPassEmptyLabel:SetExtent(600 - myPassPeroidImg:GetWidth() - 7, FONT_SIZE.MIDDLE)
    myPassEmptyLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myPassEmptyLabel, FONT_COLOR.DEFAULT)
    myPassEmptyLabel.style:SetAlign(ALIGN_LEFT)
    myPassEmptyLabel.style:SetEllipsis(true)
    myPassEmptyLabel:SetText(GetCommonText("arche_pass_empty_pass"))
    parent.myPassEmptyLabel = myPassEmptyLabel
    local myPassRemoveButton = parent:CreateChildWidget("button", "myPassRemoveButton", 0, true)
    myPassRemoveButton:SetText(GetUIText(COMMON_TEXT, "arche_pass_remove"))
    ApplyButtonSkin(myPassRemoveButton, BUTTON_BASIC.DEFAULT)
    myPassRemoveButton:AddAnchor("RIGHT", myPassInfoWnd, -15, 0)
    parent.myPassRemoveButton = myPassRemoveButton
    myPassRemoveButton:Show(false)
    local myPassChangeButton = parent:CreateChildWidget("button", "myPassChangeButton", 0, true)
    myPassChangeButton:SetText(GetUIText(COMMON_TEXT, "arche_pass_add_change"))
    ApplyButtonSkin(myPassChangeButton, BUTTON_BASIC.DEFAULT)
    myPassChangeButton:AddAnchor("RIGHT", myPassInfoWnd, -15, 0)
    local tierDeco = parent:CreateDrawable("ui/eventcenter/archepass.dds", "bg_level", "artwork")
    tierDeco:AddAnchor("TOPLEFT", myPassInfoWnd, 0, myPassInfoWnd:GetHeight())
    local myTierLabel = parent:CreateChildWidget("label", "myTierLabel", 0, true)
    myTierLabel:AddAnchor("TOPLEFT", tierDeco, 14, 11)
    myTierLabel:SetExtent(50, 33)
    myTierLabel.style:SetFontSize(33)
    ApplyTextColor(myTierLabel, FONT_COLOR.DEFAULT)
    myTierLabel.style:SetAlign(ALIGN_CENTER)
    parent.myTierLabel = myTierLabel
    local myPassPointBar = W_BAR.CreateArchePassBar("myPassPointBar", parent)
    myPassPointBar:AddAnchor("LEFT", myTierLabel, myTierLabel:GetWidth() + 15, 0)
    myPassPointBar:SetExtent(760, 14)
    parent.myPassPointBar = myPassPointBar
    local line = CreateLine(myPassInfoWnd, "TYPE1")
    line:AddAnchor("TOPLEFT", myPassInfoWnd, "BOTTOMLEFT", -10, 55)
    line:AddAnchor("TOPRIGHT", myPassInfoWnd, "BOTTOMRIGHT", 10, 50)
    function myPassChangeButton:OnClick(arg)
      if arg == "LeftButton" and parent.archePassRegistryWnd:IsVisible() == false then
        parent.archePassRegistryWnd:Show(true)
      end
    end
    myPassChangeButton:SetHandler("OnClick", myPassChangeButton.OnClick)
  end
  local function CreateMyArchePassRewardFrame(parent)
    local myPassRewardWnd = parent:CreateChildWidget("emptyWidget", "myPassRewardWnd", 0, true)
    myPassRewardWnd:Show(true)
    myPassRewardWnd:SetExtent(413, 325)
    myPassRewardWnd:AddAnchor("TOPLEFT", parent, 0, 133)
    parent.myPassRewardWnd = myPassRewardWnd
    local myPassEmptyRewardBg = CreateContentBackground(parent, "TYPE2", "brown")
    myPassEmptyRewardBg:AddAnchor("TOPLEFT", myPassRewardWnd, 0, 0)
    myPassEmptyRewardBg:AddAnchor("BOTTOMRIGHT", myPassRewardWnd, 0, 0)
    parent.myPassEmptyRewardBg = myPassEmptyRewardBg
    local myPassEmptyRewardLabel = parent:CreateChildWidget("textbox", "myPassEmptyRewardLabel", 0, true)
    myPassEmptyRewardLabel:AddAnchor("TOPLEFT", myPassRewardWnd, 0, 0)
    myPassEmptyRewardLabel:AddAnchor("BOTTOMRIGHT", myPassRewardWnd, 0, 0)
    myPassEmptyRewardLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
    ApplyTextColor(myPassEmptyRewardLabel, FONT_COLOR.DEFAULT)
    myPassEmptyRewardLabel.style:SetAlign(ALIGN_CENTER)
    myPassEmptyRewardLabel:SetText(GetCommonText("arche_pass_empty_pass_message"))
    parent.myPassEmptyRewardLabel = myPassEmptyRewardLabel
    local myPassRewardListWnd = W_CTRL.CreateScrollListCtrl("listWnd", parent)
    myPassRewardListWnd:SetExtent(405, 272)
    myPassRewardListWnd:AddAnchor("TOPLEFT", myPassRewardWnd, 0, 0)
    parent.myPassRewardListWnd = myPassRewardListWnd
    local TierLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
      local tier = subItem:CreateChildWidget("label", "tier", 0, true)
      tier.style:SetAlign(ALIGN_CENTER)
      subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(tier, FONT_COLOR.DEFAULT)
      tier:AddAnchor("CENTER", subItem, -1, 1)
      local line = DrawItemUnderLine(subItem, "overlay")
      line:AddAnchor("TOPLEFT", subItem, "BOTTOMLEFT", 0, 0)
      line:AddAnchor("TOPRIGHT", subItem, "BOTTOMRIGHT", 300, 0)
      line:SetVisible(false)
      subItem.line = line
    end
    local TierDataSetFunc = function(subItem, data, setValue)
      if setValue then
        subItem.tier:SetText(tostring(data.tier))
        if subItem.line ~= nil then
          subItem.line:Show(true)
        end
      else
        subItem.tier:SetText("")
        if subItem.line ~= nil then
          subItem.line:Show(false)
        end
      end
    end
    local RewardItemLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
      local rewardItemButton = CreateItemIconButton("rewardItemButton", subItem)
      rewardItemButton:AddAnchor("CENTER", subItem, -1, 1)
    end
    local RewardItemDataSetFunc = function(subItem, data, setValue)
      if setValue then
        subItem.rewardItemButton:SetItemInfo(data.rewardItemInfo)
        subItem.rewardItemButton:SetStack(data.rewardItemCount)
        subItem.rewardItemButton:Show(true)
        if data.tier <= data.lastRewardTier then
          subItem.rewardItemButton:SetAlpha(0.6)
          subItem.rewardItemButton:Enable(false)
        else
          subItem.rewardItemButton:SetAlpha(1)
          subItem.rewardItemButton:Enable(data.tier == data.nextRewardTier)
        end
        local function RewardButtonOnClick()
          if subItem.rewardItemButton:GetAlpha() == 1 and subItem.rewardItemButton:IsEnabled() == true then
            X2ArchePass:GetMyArchePassReward(data.tier, false)
          end
        end
        ButtonOnClickHandler(subItem.rewardItemButton, RewardButtonOnClick)
      else
        subItem.rewardItemButton:Init()
        subItem.rewardItemButton:Show(false)
      end
    end
    local PremiumRewardItemLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
      local rewardItemButton = CreateItemIconButton("rewardItemButton", subItem)
      rewardItemButton:AddAnchor("CENTER", subItem, -1, 1)
    end
    local PremiumRewardItemDataSetFunc = function(subItem, data, setValue)
      if setValue then
        subItem.rewardItemButton:SetItemInfo(data.premiumRewardItemInfo)
        subItem.rewardItemButton:SetStack(data.premiumRewardItemCount)
        subItem.rewardItemButton:Show(true)
        if data.tier <= data.lastPrimiumRewardTier then
          subItem.rewardItemButton:SetAlpha(0.6)
          subItem.rewardItemButton:Enable(false)
        else
          subItem.rewardItemButton:SetAlpha(1)
          subItem.rewardItemButton:Enable(data.premium and data.tier == data.nextPremiumRewardTier)
        end
        local function RewardButtonOnClick()
          if subItem.rewardItemButton:GetAlpha() == 1 and subItem.rewardItemButton:IsEnabled() == true then
            X2ArchePass:GetMyArchePassReward(data.tier, true)
          end
        end
        ButtonOnClickHandler(subItem.rewardItemButton, RewardButtonOnClick)
      else
        subItem.rewardItemButton:Init()
        subItem.rewardItemButton:Show(false)
      end
    end
    myPassRewardListWnd:InsertColumn(GetCommonText("arche_pass_tier_info"), 95, LCCIT_STRING, TierDataSetFunc, nil, nil, TierLayoutSetFunc)
    myPassRewardListWnd:InsertColumn(GetCommonText("arche_pass_normal_reward"), 145, LCCIT_WINDOW, RewardItemDataSetFunc, nil, nil, RewardItemLayoutSetFunc)
    myPassRewardListWnd:InsertColumn(GetCommonText("arche_pass_premium_reward"), 145, LCCIT_WINDOW, PremiumRewardItemDataSetFunc, nil, nil, PremiumRewardItemLayoutSetFunc)
    myPassRewardListWnd:InsertRows(LIST_ROW_COUNT, false)
    myPassRewardListWnd.listCtrl:DisuseSorting()
    DrawListCtrlUnderLine(myPassRewardListWnd.listCtrl, COLUMN_HEIGHT - 2)
    local columnBg = myPassRewardListWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    columnBg:SetTextureColor("alpha40")
    columnBg:AddAnchor("TOPLEFT", myPassRewardListWnd.listCtrl.column[1], 0, 0)
    columnBg:AddAnchor("BOTTOMRIGHT", myPassRewardListWnd.listCtrl.column[3], 27, 0)
    local listBg = myPassRewardListWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    listBg:SetTextureColor("bg_02")
    listBg:AddAnchor("TOPLEFT", myPassRewardListWnd.listCtrl, 0, myPassRewardListWnd.listCtrl.column[1]:GetHeight())
    listBg:AddAnchor("BOTTOMRIGHT", myPassRewardListWnd.listCtrl.column[3], 25, myPassRewardListWnd:GetHeight() - myPassRewardListWnd.listCtrl.column[1]:GetHeight())
    local premiumListBg = myPassRewardListWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg_crop", "background")
    premiumListBg:SetTextureColor("alpha10")
    premiumListBg:AddAnchor("TOPLEFT", myPassRewardListWnd.listCtrl.column[3], 0, myPassRewardListWnd.listCtrl.column[1]:GetHeight())
    premiumListBg:AddAnchor("BOTTOMRIGHT", myPassRewardListWnd.listCtrl.column[3], 25, myPassRewardListWnd:GetHeight() - myPassRewardListWnd.listCtrl.column[1]:GetHeight())
    local premiumListEffectBg = myPassRewardListWnd:CreateDrawable("ui/eventcenter/archepass.dds", "bg_effect", "background")
    premiumListEffectBg:AddAnchor("TOPLEFT", myPassRewardListWnd.listCtrl.column[3], 0, myPassRewardListWnd.listCtrl.column[1]:GetHeight() + 5)
    premiumListEffectBg:AddAnchor("BOTTOMRIGHT", myPassRewardListWnd.listCtrl.column[3], 0, myPassRewardListWnd.listCtrl:GetHeight() - myPassRewardListWnd.listCtrl.column[1]:GetHeight() - 5)
    for i = 1, #myPassRewardListWnd.listCtrl.column do
      SettingListColumn(myPassRewardListWnd.listCtrl, myPassRewardListWnd.listCtrl.column[i], COLUMN_HEIGHT)
      DrawListCtrlColumnSperatorLine(myPassRewardListWnd.listCtrl.column[i], #myPassRewardListWnd.listCtrl.column, i)
      SetButtonFontColor(myPassRewardListWnd.listCtrl.column[i], GetButtonDefaultFontColor_V2())
    end
    local lastRewardBg = myPassRewardWnd:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    lastRewardBg:SetTextureColor("orange")
    lastRewardBg:AddAnchor("TOPLEFT", myPassRewardListWnd, 0, myPassRewardListWnd:GetHeight() + 5)
    lastRewardBg:AddAnchor("BOTTOMRIGHT", myPassRewardWnd, 0, 0)
    local lastPremiumRewardBg = myPassRewardWnd:CreateDrawable("ui/eventcenter/archepass.dds", "bg_effect_final", "background")
    lastPremiumRewardBg:AddAnchor("TOPLEFT", myPassRewardListWnd, 239, myPassRewardListWnd:GetHeight() + 5)
    lastPremiumRewardBg:AddAnchor("BOTTOMRIGHT", myPassRewardWnd, 0, 0)
    local lastRewardLabel = myPassRewardWnd:CreateChildWidget("label", "lastRewardLabel", 0, true)
    lastRewardLabel:AddAnchor("LEFT", lastRewardBg, 10, 0)
    lastRewardLabel:SetExtent(100, FONT_SIZE.MIDDLE)
    ApplyTextColor(lastRewardLabel, FONT_COLOR.DEFAULT)
    lastRewardLabel.style:SetAlign(ALIGN_CENTER)
    lastRewardLabel:SetText(GetUIText(COMMON_TEXT, "arche_pass_last_reward"))
    local lastRewardButton = CreateItemIconButton("lastRewardButton", myPassRewardWnd)
    lastRewardButton:AddAnchor("TOPLEFT", lastRewardBg, 146, 2)
    parent.lastRewardButton = lastRewardButton
    local lastPremiumRewardButton = CreateItemIconButton("lastPremiumRewardButton", myPassRewardWnd)
    lastPremiumRewardButton:AddAnchor("TOPLEFT", lastPremiumRewardBg, 53, 2)
    parent.lastPremiumRewardButton = lastPremiumRewardButton
    local changePremiumButton = parent:CreateChildWidget("button", "changePremiumButton", 0, true)
    changePremiumButton:SetText(GetCommonText("arche_pass_premium"))
    ApplyButtonSkin(changePremiumButton, BUTTON_BASIC.DEFAULT)
    changePremiumButton:AddAnchor("BOTTOMRIGHT", lastPremiumRewardBg, 0, 38)
    parent.changePremiumButton = changePremiumButton
  end
  local CreateChangeMissionWnd = function(parent)
    local changeMissionWnd = CreateWindow("changeMissionWnd", "UIParent")
    changeMissionWnd:SetWindowModal(true)
    changeMissionWnd:SetExtent(510, 530)
    changeMissionWnd:AddAnchor("CENTER", "UIParent", 0, 0)
    changeMissionWnd:SetTitle(GetCommonText("today_assignment_reset_title"))
    changeMissionWnd:Show(false)
    changeMissionWnd.selectRealStep = 0
    parent.changeMissionWnd = changeMissionWnd
    local label = changeMissionWnd:CreateChildWidget("textbox", "label", 0, true)
    label:AddAnchor("TOP", changeMissionWnd.titleBar, "BOTTOM", 0, 5)
    label:SetExtent(470, FONT_SIZE.LARGE)
    label.style:SetFontSize(FONT_SIZE.LARGE)
    label:SetText(GetCommonText("today_assignment_reset_label"))
    ApplyTextColor(label, FONT_COLOR.DEFAULT)
    label.style:SetAlign(ALIGN_CENTER)
    local scrollListCtrl = W_CTRL.CreateScrollListCtrl("scrollListCtrl", changeMissionWnd)
    scrollListCtrl.scroll:RemoveAllAnchors()
    scrollListCtrl.scroll:AddAnchor("TOPRIGHT", scrollListCtrl, 0, 0)
    scrollListCtrl.scroll:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 0, 0)
    scrollListCtrl.listCtrl:SetColumnHeight(0)
    scrollListCtrl:SetExtent(470, 386)
    scrollListCtrl:AddAnchor("TOPLEFT", label, 0, label:GetHeight() + 13)
    changeMissionWnd.scrollListCtrl = scrollListCtrl
    local scrollListCtrlBg = CreateContentBackground(scrollListCtrl, "TYPE2", "brown_2")
    scrollListCtrlBg:AddAnchor("TOPLEFT", scrollListCtrl, -5, -5)
    scrollListCtrlBg:AddAnchor("BOTTOMRIGHT", scrollListCtrl, 5, 5)
    local calcelBtn = changeMissionWnd:CreateChildWidget("button", "calcelBtn", 0, true)
    ApplyButtonSkin(calcelBtn, BUTTON_BASIC.DEFAULT)
    calcelBtn:AddAnchor("BOTTOM", changeMissionWnd, calcelBtn:GetWidth() / 2 + 2, -MARGIN.WINDOW_SIDE)
    calcelBtn:SetText(GetCommonText("cancel"))
    changeMissionWnd.calcelBtn = calcelBtn
    local applyBtn = changeMissionWnd:CreateChildWidget("button", "applyBtn", 0, true)
    ApplyButtonSkin(applyBtn, BUTTON_BASIC.DEFAULT)
    applyBtn:AddAnchor("TOPLEFT", calcelBtn, -(calcelBtn:GetWidth() + 5), 0)
    applyBtn:SetText(GetCommonText("today_assignment_reset_apply"))
    changeMissionWnd.applyBtn = applyBtn
    local function CancelButtonOnClick()
      changeMissionWnd:Show(false)
    end
    ButtonOnClickHandler(calcelBtn, CancelButtonOnClick)
    local function ApplyButtonOnClick()
      local result = X2ArchePass:ResetTodayAssignment(TADT_ARCHE_PASS, changeMissionWnd.selectRealStep)
      changeMissionWnd:Show(false)
    end
    ButtonOnClickHandler(applyBtn, ApplyButtonOnClick)
    local LayoutFunc = function(frame, rowIndex, colIndex, subItem)
      local radiobtn = UIParent:CreateWidget("button", "radiobtn", subItem)
      radiobtn:AddAnchor("LEFT", subItem, 8, 0)
      radiobtn:SetExtent(21, 21)
      subItem.radiobtn = radiobtn
      local radiobtnImg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "editbox_df", "overlay")
      radiobtnImg:SetCoords(1009, 0, 15, 15)
      radiobtnImg:SetExtent(15, 15)
      radiobtnImg:AddAnchor("TOPLEFT", radiobtn, 3, 3)
      subItem.radiobtnImg = radiobtnImg
      local iconBg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "artwork")
      iconBg:SetExtent(54, 54)
      iconBg:AddAnchor("LEFT", radiobtn, radiobtn:GetWidth() + 8, 1)
      subItem.iconBg = iconBg
      local icon = subItem:CreateImageDrawable(INVALID_ICON_PATH, "artwork")
      icon:AddAnchor("TOPLEFT", iconBg, 2, 2)
      icon:AddAnchor("BOTTOMRIGHT", iconBg, -2, -2)
      subItem.icon = icon
      local title = subItem:CreateChildWidget("label", "title", 0, true)
      title:SetExtent(340, FONT_SIZE.MIDDLE)
      title.style:SetFontSize(FONT_SIZE.MIDDLE)
      title.style:SetAlign(ALIGN_LEFT)
      title.style:SetEllipsis(true)
      title:AddAnchor("LEFT", iconBg, iconBg:GetWidth() + 7, -10)
      ApplyTextColor(title, FONT_COLOR.HIGH_TITLE)
      subItem.title = title
      local titleLabel = subItem:CreateChildWidget("label", "titleLabel", 0, true)
      titleLabel:SetExtent(340, FONT_SIZE.MIDDLE)
      titleLabel.style:SetFontSize(FONT_SIZE.MIDDLE)
      titleLabel.style:SetAlign(ALIGN_LEFT)
      titleLabel.style:SetEllipsis(true)
      titleLabel:AddAnchor("LEFT", iconBg, iconBg:GetWidth() + 7, 10)
      ApplyTextColor(titleLabel, FONT_COLOR.DEFAULT)
      subItem.titleLabel = titleLabel
      if rowIndex ~= 1 then
        local line = CreateLine(subItem, "TYPE1")
        line:AddAnchor("TOPLEFT", subItem, 0, 0)
        line:AddAnchor("TOPRIGHT", subItem, 0, 0)
        subItem.line = line
      end
    end
    local function SetDataFunc(subItem, data, setValue)
      if setValue then
        subItem.icon:SetTexture(data.iconPath)
        subItem.icon:SetCoords(0, 0, 48, 48)
        subItem.icon:SetVisible(true)
        subItem.iconBg:SetVisible(true)
        subItem.title:SetText(data.title)
        if data.realStep == changeMissionWnd.selectRealStep then
          subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
        else
          subItem.radiobtnImg:SetTextureInfo("radio_button_df")
        end
        function subItem:OnClick(arg)
          if arg == "LeftButton" then
            changeMissionWnd:ResetRadioBtns()
            subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
            changeMissionWnd.applyBtn:Enable(true)
            changeMissionWnd.selectRealStep = data.realStep
          end
        end
        subItem:SetHandler("OnClick", subItem.OnClick)
        function subItem.radiobtn:OnClick(arg)
          if arg == "LeftButton" then
            changeMissionWnd:ResetRadioBtns()
            subItem.radiobtnImg:SetTextureInfo("radio_button_chk_df")
            changeMissionWnd.applyBtn:Enable(true)
            changeMissionWnd.selectRealStep = data.realStep
          end
        end
        subItem.radiobtn:SetHandler("OnClick", subItem.radiobtn.OnClick)
        local qInfo = MakeTodayQuestInfo(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_LIST, data.questType)
        subItem.titleLabel:SetText(qInfo.titleStr)
        if subItem.line ~= nil then
          subItem.line:Show(true)
        end
      else
        subItem.icon:Show(false)
        subItem.iconBg:Show(false)
        subItem.title:SetText("")
        subItem.titleLabel:SetText("")
        if subItem.line ~= nil then
          subItem.line:Show(false)
        end
      end
    end
    scrollListCtrl:InsertColumn("", 448, LCCIT_WINDOW, SetDataFunc, nil, nil, LayoutFunc)
    scrollListCtrl:InsertRows(6, false)
    function changeMissionWnd:ShowProc()
      changeMissionWnd.selectRealStep = 0
      scrollListCtrl:DeleteAllDatas()
      self:ResetRadioBtns()
      self.applyBtn:Enable(false)
      local maxCnt = X2Achievement:GetTodayAssignmentCount(TADT_ARCHE_PASS)
      local curCnt = 1
      for i = 1, maxCnt do
        local info = X2Achievement:GetTodayAssignmentInfo(TADT_ARCHE_PASS, i)
        if info.status == A_TODAY_STATUS.PROGRESS then
          scrollListCtrl:InsertData(curCnt, 1, info)
          curCnt = curCnt + 1
        end
      end
    end
    function changeMissionWnd:ResetRadioBtns()
      for i = 1, #changeMissionWnd.scrollListCtrl.listCtrl.items do
        subItem = changeMissionWnd.scrollListCtrl.listCtrl.items[i].subItems[1]
        subItem.radiobtnImg:SetTextureInfo("radio_button_df")
      end
    end
  end
  local function CreateMyArchePassMissionFrame(parent)
    local missionWnd = parent:CreateChildWidget("emptyWidget", "missionWnd", 0, true)
    missionWnd:Show(true)
    missionWnd:SetExtent(433, 325)
    missionWnd:AddAnchor("TOPRIGHT", parent, 0, 133)
    parent.missionWnd = missionWnd
    local function CreateTodayAssignmentListWnd(id, parent)
      local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
      local MAX_ASSIGNMENT_LIST = 20
      local subjectList = CreateASubjectListWnd("subjectList", wnd)
      subjectList:SetExtent(420, 280)
      subjectList:AddAnchor("TOPLEFT", wnd, 0, 35)
      subjectList:SetListStyle(4, MAX_ASSIGNMENT_LIST, TodayAssignmentDataSetFunc)
      subjectList:SetWndStyle(false, GetCommonText("no_achievement"))
      local bookImg = wnd:CreateDrawable(TEXTURE_PATH.EVENT_CENTER_TODAY, "book", "background")
      bookImg:AddAnchor("TOPLEFT", wnd, 0, 0)
      local title = wnd:CreateChildWidget("label", "title", 0, true)
      title:SetHeight(FONT_SIZE.LARGE)
      title:SetAutoResize(true)
      title.style:SetAlign(ALIGN_LEFT)
      title.style:SetFontSize(FONT_SIZE.LARGE)
      title:AddAnchor("LEFT", bookImg, bookImg:GetWidth(), 0)
      title:SetText(GetCommonText("arche_pass_mission_complete"))
      ApplyTextColor(title, FONT_COLOR.BROWN)
      function wnd:SetListSelectFuc(func)
        subjectList:SetListSelectFuc(func)
      end
      function wnd:Init()
        local cnt = X2Achievement:GetTodayAssignmentCount(TADT_ARCHE_PASS)
        local info = {}
        for index = 1, cnt do
          info[index] = index
        end
        subjectList:SetInfo(info)
        wnd.info = info
      end
      function wnd:Update()
        wnd:Init()
        subjectList:Update()
      end
      return wnd
    end
    local function CreateDescWnd(id, parent)
      local wnd = parent:CreateChildWidget("emptywidget", id, 0, true)
      local prevPageBtn = wnd:CreateChildWidget("button", "prevPageBtn", 0, true)
      prevPageBtn:AddAnchor("TOPLEFT", wnd, 0, 0)
      prevPageBtn:SetText(GetCommonText("prev_page"))
      ApplyButtonSkin(prevPageBtn, BUTTON_CONTENTS.PREV_PAGE)
      local subjectWnd = wnd:CreateChildWidget("emptywidget", "subjectWnd", 0, true)
      CreateASubjectWnd(subjectWnd)
      subjectWnd:AddAnchor("TOPLEFT", prevPageBtn, "BOTTOMLEFT", 0, 5)
      subjectWnd:AddAnchor("BOTTOMRIGHT", wnd, "TOPRIGHT", 0, 105)
      local descWnd = CreateAAchievementDescWnd("descWnd", wnd)
      descWnd:AddAnchor("TOPLEFT", subjectWnd, "BOTTOMLEFT", 0, 5)
      descWnd:AddAnchor("BOTTOMRIGHT", wnd, "BOTTOMRIGHT", 0, -40)
      local prevBtn = wnd:CreateChildWidget("button", "prevBtn", 0, true)
      prevBtn:AddAnchor("RIGHT", wnd, "BOTTOM", -5, -20)
      ApplyButtonSkin(prevBtn, BUTTON_BASIC.PAGE_PREV)
      local nextBtn = wnd:CreateChildWidget("button", "nextBtn", 0, true)
      nextBtn:AddAnchor("LEFT", wnd, "BOTTOM", 5, -20)
      ApplyButtonSkin(nextBtn, BUTTON_BASIC.PAGE_NEXT)
      function wnd:SetInfo(index, aList, prevPage)
        local info = X2Achievement:GetTodayAssignmentInfo(TADT_ARCHE_PASS, index)
        if info == nil then
          return
        elseif info.status == A_TODAY_STATUS.LOCKED then
          if wnd.lastQuest ~= nil then
            prevPageBtn:OnClick()
            return
          end
          if info.satisfy then
            CallUnlockTodayQuestDialog(GetUIText(COMMON_TEXT, "today_quest"), TADT_ARCHE_PASS, info)
          end
          return
        elseif info.status == A_TODAY_STATUS.READY then
          if wnd.lastQuest ~= nil then
            prevPageBtn:OnClick()
            return
          end
          X2Achievement:HandleClickTodayAssignment(TADT_ARCHE_PASS, info.realStep)
          return
        end
        wnd.viewInfo = {
          index = index,
          aList = aList,
          prevPage = prevPage
        }
        local function CheckFunc(checkBtn)
          TracingBtnChecked(checkBtn, index)
        end
        subjectWnd:SetTodayAssignment(A_SUBJECT_STYLE.TODAY_ASSIGNMENT_DESC, TADT_ARCHE_PASS, index, CheckFunc, TracingBtnEntered)
        descWnd:SetTodayAssignmentInfo(info.questType)
        wnd.lastQuest = info.questType
        local function RefreshMoveBtn()
          local cIndex = 1
          while aList[cIndex] ~= index do
            cIndex = cIndex + 1
          end
          prevBtn:Enable(false)
          for i = cIndex - 1, 1, -1 do
            local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_ARCHE_PASS, aList[i])
            if sInfo ~= nil and sInfo.status >= A_TODAY_STATUS.PROGRESS then
              prevBtn.index = aList[i]
              prevBtn:Enable(true)
              break
            end
          end
          nextBtn:Enable(false)
          for i = cIndex + 1, #aList do
            local sInfo = X2Achievement:GetTodayAssignmentInfo(TADT_ARCHE_PASS, aList[i])
            if sInfo ~= nil and sInfo.status >= A_TODAY_STATUS.PROGRESS then
              nextBtn.index = aList[i]
              nextBtn:Enable(true)
              break
            end
          end
        end
        RefreshMoveBtn()
        if prevPage ~= wnd then
          prevPage:Show(false)
          wnd:Show(true)
        end
      end
      function prevPageBtn:OnClick()
        wnd.lastQuest = nil
        wnd.viewInfo.prevPage:Update()
        wnd.viewInfo.prevPage:Show(true)
        wnd:Show(false)
        wnd.viewInfo = nil
      end
      prevPageBtn:SetHandler("OnClick", prevPageBtn.OnClick)
      function prevBtn:OnClick()
        wnd:SetInfo(prevBtn.index, wnd.viewInfo.aList, wnd.viewInfo.prevPage)
      end
      prevBtn:SetHandler("OnClick", prevBtn.OnClick)
      function nextBtn:OnClick()
        wnd:SetInfo(nextBtn.index, wnd.viewInfo.aList, wnd.viewInfo.prevPage)
      end
      nextBtn:SetHandler("OnClick", nextBtn.OnClick)
      function wnd:Update()
        if wnd.viewInfo ~= nil then
          wnd:SetInfo(wnd.viewInfo.index, wnd.viewInfo.aList, wnd.viewInfo.prevPage)
        end
      end
      function wnd:OnHide()
        wnd.viewInfo = nil
      end
      wnd:SetHandler("OnHide", wnd.OnHide)
      return wnd
    end
    local missionListWnd = CreateTodayAssignmentListWnd("missionListWnd", parent)
    missionListWnd:AddAnchor("TOPLEFT", missionWnd, 0, 0)
    missionListWnd:AddAnchor("BOTTOMRIGHT", missionWnd, 0, 0)
    parent.missionListWnd = missionListWnd
    missionListWnd:Init()
    local missionDescWnd = CreateDescWnd("missionDescWnd", parent)
    missionDescWnd:AddAnchor("TOPLEFT", missionWnd, 0, 0)
    missionDescWnd:AddAnchor("BOTTOMRIGHT", missionWnd, 0, 0)
    parent.missionDescWnd = missionDescWnd
    missionDescWnd:Show(false)
    local function ToggleDetailWnd(index, aList)
      missionDescWnd:SetInfo(index, aList, missionListWnd)
    end
    missionListWnd:SetListSelectFuc(ToggleDetailWnd)
    function parent:ToggleWithQuest(qType)
      local cnt = X2Achievement:GetTodayAssignmentCount(TADT_ARCHE_PASS)
      local info = {}
      for index = 1, cnt do
        info[index] = index
      end
      for index = 1, #info do
        local tInfo = X2Achievement:GetTodayAssignmentInfo(TADT_ARCHE_PASS, info[index])
        if tInfo ~= nil and tInfo.questType == qType then
          ToggleDetailWnd(index, info)
        end
      end
    end
    function parent:Update(force)
      if force == true or parent:IsVisible() == true then
        missionListWnd:Update()
        missionDescWnd:Update()
      end
    end
    local changeObjectButton = parent:CreateChildWidget("button", "changeObjectButton", 0, true)
    changeObjectButton:SetText(GetCommonText("today_assignment_reset_title"))
    ApplyButtonSkin(changeObjectButton, BUTTON_BASIC.DEFAULT)
    changeObjectButton:AddAnchor("BOTTOMRIGHT", missionListWnd, 0, changeObjectButton:GetHeight() + 3)
    parent.changeObjectButton = changeObjectButton
    local function ChangeMissionButtonOnClick()
      if parent.changeMissionWnd:IsVisible() == false then
        parent.changeMissionWnd:Show(true)
      else
        parent.changeMissionWnd:Show(false)
      end
    end
    ButtonOnClickHandler(parent.changeObjectButton, ChangeMissionButtonOnClick)
    local refreshButton = parent:CreateChildWidget("button", "refreshButton", 0, true)
    refreshButton:Show(true)
    refreshButton:SetExtent(34, 34)
    refreshButton:AddAnchor("BOTTOMLEFT", missionListWnd, 0, refreshButton:GetHeight() + 3)
    ApplyButtonSkin(refreshButton, BUTTON_STYLE.RESET_BIG)
    parent.refreshButton = refreshButton
    refreshButton:Show(false)
    local labelChangeCount = parent:CreateChildWidget("label", "labelChangeCount", 0, true)
    labelChangeCount:SetHeight(FONT_SIZE.MIDDLE)
    labelChangeCount:SetAutoResize(true)
    labelChangeCount.style:SetAlign(ALIGN_RIGHT)
    labelChangeCount.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelChangeCount:AddAnchor("BOTTOMLEFT", missionListWnd, 0, 25)
    labelChangeCount:SetText(GetCommonText("today_assignment_reset_count", 0, 0))
    ApplyTextColor(labelChangeCount, FONT_COLOR.BROWN)
    parent.labelChangeCount = labelChangeCount
    local labelCompletCount = parent:CreateChildWidget("label", "labelCompletCount", 0, true)
    labelCompletCount:SetHeight(FONT_SIZE.MIDDLE)
    labelCompletCount:SetAutoResize(true)
    labelCompletCount.style:SetAlign(ALIGN_RIGHT)
    labelCompletCount.style:SetFontSize(FONT_SIZE.MIDDLE)
    labelCompletCount:AddAnchor("TOPRIGHT", missionListWnd.subjectList, 0, -FONT_SIZE.MIDDLE - 12)
    labelCompletCount:SetText(GetCommonText("arche_pass_daily_complete_count", 0, 0))
    ApplyTextColor(labelCompletCount, FONT_COLOR.BROWN)
    parent.labelCompletCount = labelCompletCount
    local guide = W_ICON.CreateGuideIconWidget(parent)
    guide:AddAnchor("RIGHT", labelCompletCount, -labelCompletCount:GetWidth() - 10, 0)
    local function OnEnterGuide()
      SetTooltip(GetUIText(TOOLTIP_TEXT, "arche_pass_mission_guide"), guide)
    end
    guide:SetHandler("OnEnter", OnEnterGuide)
    local OnLeaveGuide = function()
      HideTooltip()
    end
    guide:SetHandler("OnLeave", OnLeaveGuide)
  end
  CreateMyArchePassFrame(parent)
  CreateMyArchePassRewardFrame(parent)
  CreateChangeMissionWnd(parent)
  CreateMyArchePassMissionFrame(parent)
  CreateArchePassRegistryWnd(parent)
  SetArchePassEventFunction(parent)
  parent:Update()
end
