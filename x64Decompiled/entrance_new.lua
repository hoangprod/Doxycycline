local featureSet = X2Player:GetFeatureSet()
local function SetViewOfEntranceWindow(id, parent)
  local window = CreateWindow(id, parent)
  window:SetExtent(680, 711)
  window:SetTitle(GetCommonText("instance_entrance_title"))
  local kindList = X2BattleField:GetInstanceUiKindList()
  local tabNames = {}
  local kindInfo = {}
  for i, v in ipairs(kindList) do
    tabNames[i] = v.name
    kindInfo[i] = {
      path = v.listButtonPath,
      type = v.type,
      showHonorStore = v.showHonorStore and battleFieldLocale.showHonorStore
    }
  end
  function window:GetKindInfo(index)
    return kindInfo[index]
  end
  function window:GetTabIndexByKindType(kindType)
    if kindType == nil then
      return 0
    end
    for i, v in ipairs(kindInfo) do
      if v.type == kindType then
        return i
      end
    end
    return 0
  end
  local tab = W_BTN.CreateTab("tab", window)
  tab:AddTabs(tabNames)
  tab:SetCorner("TOPLEFT")
  tab:AddAnchor("TOPLEFT", window, 20, 50)
  window.tabs = tab
  local contentHeight = 515
  local rightWidth = 510
  local titleHeight = 39
  local function CreateLeftList(id, parent)
    local leftList = W_CTRL.CreateScrollListCtrl(id, parent)
    leftList:SetExtent(123, contentHeight)
    leftList:HideColumnButtons()
    leftList.listCtrl:SetUseDoubleClick(true)
    leftList.scroll:RemoveAllAnchors()
    leftList.scroll:AddAnchor("TOPRIGHT", leftList, 0, 5)
    leftList.scroll:AddAnchor("BOTTOMRIGHT", leftList, 0, -5)
    local DataFunc = function(subItem, data, setValue)
      if setValue then
        subItem.bg:SetVisible(true)
        subItem.bg:SetTexture(data.path)
        subItem.bg:SetTextureInfo(string.lower(data.zoneName))
        subItem.globalIcon:SetVisible(data.globalField)
        if data.memberCount ~= nil then
          local str = ""
          local count = #data.memberCount
          for i = 1, count do
            if str == "" then
              str = tostring(data.memberCount[i])
            end
            if i > 1 then
              str = string.format("%s : %d", str, data.memberCount[i])
            end
          end
          subItem.memberCount:Show(true)
          subItem.memberCount:SetText(str)
        end
      else
        subItem.bg:SetVisible(false)
        subItem.festivalIcon:SetVisible(false)
        subItem.globalIcon:SetVisible(false)
        subItem.memberCount:Show(false)
      end
    end
    local LayoutFunc = function(widget, rowIndex, colIndex, subItem)
      local bg = subItem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_LIST_BUTTON, "instance_training_camp", "background")
      bg:AddAnchor("CENTER", subItem, 2, 0)
      subItem.bg = bg
      local festivalIcon = subItem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_COMMON_LIST_BUTTON, "icon_festival", "overlay")
      festivalIcon:SetVisible(false)
      subItem.festivalIcon = festivalIcon
      local globalIcon = subItem:CreateDrawable(TEXTURE_PATH.BATTLEFIELD_COMMON_LIST_BUTTON, "icon_combine", "overlay")
      globalIcon:AddAnchor("TOPRIGHT", bg, "TOPRIGHT", -5, 5)
      subItem.globalIcon = globalIcon
      local memberCount = subItem:CreateChildWidget("label", "memberCount", 0, true)
      memberCount:AddAnchor("BOTTOM", bg, 0, -4)
      memberCount:SetExtent(10, FONT_SIZE.SMALL)
      memberCount.style:SetFontSize(FONT_SIZE.SMALL)
      memberCount:SetAutoResize(true)
      ApplyTextColor(memberCount, FONT_COLOR.WHITE)
    end
    local textureInfo = UIParent:GetTextureData(TEXTURE_PATH.BATTLEFIELD_COMMON_LIST_BUTTON, "frame_ov")
    local overedImage = leftList.listCtrl:CreateOveredImage()
    overedImage:SetTexture(TEXTURE_PATH.BATTLEFIELD_COMMON_LIST_BUTTON)
    overedImage:SetCoords(textureInfo.coords[1], textureInfo.coords[2], textureInfo.coords[3], textureInfo.coords[4])
    overedImage:SetInset(textureInfo.inset[1], textureInfo.inset[2], textureInfo.inset[3], textureInfo.inset[4])
    leftList.listCtrl:SetOveredImageOffset(1, 2, -2, -2)
    textureInfo = UIParent:GetTextureData(TEXTURE_PATH.BATTLEFIELD_COMMON_LIST_BUTTON, "frame_on")
    local selectedImage = leftList.listCtrl:CreateSelectedImage()
    selectedImage:SetTexture(TEXTURE_PATH.BATTLEFIELD_COMMON_LIST_BUTTON)
    selectedImage:SetCoords(textureInfo.coords[1], textureInfo.coords[2], textureInfo.coords[3], textureInfo.coords[4])
    selectedImage:SetInset(textureInfo.inset[1], textureInfo.inset[2], textureInfo.inset[3], textureInfo.inset[4])
    leftList.listCtrl:SetSelectedImageOffset(-5, -3, 4, 3)
    leftList:InsertColumn("", 96, LCCIT_WINDOW, DataFunc, nil, nil, LayoutFunc)
    leftList:InsertRows(6, false)
    return leftList
  end
  local function CreateDeatilTitle(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(rightWidth, titleHeight)
    local bg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    bg:SetTextureColor("bg_01")
    bg:AddAnchor("TOPLEFT", frame, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
    local titleWidget = frame:CreateChildWidget("label", "titleWidget", 0, false)
    titleWidget:SetExtent(frame:GetWidth() - 40, frame:GetHeight())
    titleWidget:AddAnchor("TOPLEFT", frame, 20, 0)
    titleWidget.style:SetAlign(ALIGN_LEFT)
    titleWidget.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.XXLARGE)
    titleWidget.style:SetEllipsis(true)
    ApplyTextColor(titleWidget, FONT_COLOR.MIDDLE_TITLE)
    function frame:SetTitle(text)
      titleWidget:SetText(text)
    end
    return frame
  end
  local function CreateDetailInfo(id, parent)
    local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
    frame:SetExtent(rightWidth, contentHeight - titleHeight)
    local bgImg = frame:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    bgImg:SetTextureColor("bg_01")
    bgImg:AddAnchor("TOPLEFT", frame, 0, -titleHeight)
    bgImg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
    local defaultPreview = string.format("%s/%s.dds", TEXTURE_PATH.BATTLEFIELD_PREVIEW_PREFIX, "instance_training_camp_1on1")
    local preview = frame:CreateDrawable(defaultPreview, "image", "background")
    preview:AddAnchor("TOP", frame, 0, 5)
    local scrollWnd = CreateScrollWindow(frame, "scroll", 0)
    scrollWnd:SetExtent(484, 283)
    scrollWnd:AddAnchor("TOP", preview, "BOTTOM", 0, 8)
    scrollWnd:AddAnchor("LEFT", frame, 20, 0)
    local targetParent = scrollWnd.content
    local contentWidth = targetParent:GetWidth()
    local balanceLevel = targetParent:CreateChildWidget("label", "balanceLevel", 0, false)
    balanceLevel:SetExtent(contentWidth, FONT_SIZE.LARGE)
    balanceLevel:AddAnchor("TOPLEFT", targetParent, 0, 0)
    balanceLevel:SetText(GetUIText(COMMON_TEXT, "on_balance_level_battlefield"))
    balanceLevel.style:SetFont(FONT_PATH.LEEYAGI, FONT_SIZE.LARGE)
    balanceLevel.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(balanceLevel, FONT_COLOR.BLUE)
    local description = targetParent:CreateChildWidget("textbox", "description", 0, false)
    description:SetExtent(contentWidth, 30)
    description:SetAutoResize(true)
    description.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(description, FONT_COLOR.DEFAULT)
    local additionalInfo = targetParent:CreateChildWidget("textbox", "additionalInfo", 0, true)
    additionalInfo:SetExtent(contentWidth, 30)
    additionalInfo:AddAnchor("TOPLEFT", description, "BOTTOMLEFT", 0, 15)
    additionalInfo:SetAutoResize(true)
    additionalInfo.style:SetAlign(ALIGN_LEFT)
    additionalInfo.style:SetFontSize(FONT_SIZE.LARGE)
    ApplyTextColor(additionalInfo, FONT_COLOR.RED)
    local victoryFrame = targetParent:CreateChildWidget("emptywidget", "victoryFrame", 0, false)
    victoryFrame:SetExtent(contentWidth, 30)
    victoryFrame:AddAnchor("TOPLEFT", additionalInfo, "BOTTOMLEFT", -3, 8)
    local bg = CreateContentBackground(victoryFrame, "TYPE2", "brown")
    bg:AddAnchor("TOPLEFT", victoryFrame, 0, 0)
    bg:AddAnchor("BOTTOMRIGHT", victoryFrame, 0, 0)
    local calcWidth = contentWidth - 40
    local victoryTitle = victoryFrame:CreateChildWidget("label", "victoryTitle", 0, false)
    victoryTitle:SetExtent(calcWidth, FONT_SIZE.LARGE)
    victoryTitle:SetText(locale.battlefield.winCondition.title)
    victoryTitle:AddAnchor("TOPLEFT", victoryFrame, 20, 15)
    victoryTitle.style:SetFontSize(FONT_SIZE.LARGE)
    victoryTitle.style:SetAlign(ALIGN_LEFT)
    ApplyTextColor(victoryTitle, FONT_COLOR.MIDDLE_TITLE)
    local victoryTitleGuide = W_ICON.CreateGuideIconWidget(victoryTitle)
    victoryTitleGuide:AddAnchor("TOPRIGHT", victoryTitle, 0, -2)
    local OnEnter = function(self)
      SetTooltip(locale.battlefield.winCondition.tip, self)
    end
    victoryTitleGuide:SetHandler("OnEnter", OnEnter)
    local line = CreateLine(victoryFrame, "TYPE1", "background")
    line:SetWidth(victoryFrame:GetWidth())
    line:AddAnchor("TOP", victoryTitle, "BOTTOM", 0, 7)
    local function CreateGoal(id, iconKey, text)
      local goal = victoryFrame:CreateChildWidget("label", id, 0, false)
      goal:SetExtent(calcWidth, FONT_SIZE.MIDDLE)
      goal.style:SetFontSize(FONT_SIZE.LARGE)
      goal.style:SetAlign(ALIGN_LEFT)
      ApplyTextColor(goal, FONT_COLOR.BLUE)
      if text ~= nil then
        goal:SetText(text)
      end
      local icon = CreateWinConditionIcon(goal, iconKey)
      icon:AddAnchor("LEFT", goal, 0, 0)
      goal:SetInset(icon:GetWidth() + 5, 0, 0, 0)
      return goal
    end
    local scoreGoal = CreateGoal("scoreGoal", "score")
    local killCountGoal = CreateGoal("killCountGoal", "killcount")
    local winCountGoal = CreateGoal("winCountGoal", "roundwincount")
    local targetDestoryGoal = CreateGoal("targetDestoryGoal", "destruction", locale.battlefield.winCondition.targetDestruction)
    local rankGoal = CreateGoal("rankGoal", "timeOut")
    local honorStore = frame:CreateChildWidget("button", "honorStore", 0, false)
    honorStore:SetText(locale.battlefield.shop)
    ApplyButtonSkin(honorStore, BUTTON_BASIC.DEFAULT)
    honorStore:AddAnchor("BOTTOMLEFT", tab, 0, 0)
    local OnClick = function(self)
      DirectOpenStore(4)
    end
    honorStore:SetHandler("OnClick", OnClick)
    function frame:ShowHonorStore(show)
      honorStore:Show(show)
    end
    local entranceButton = frame:CreateChildWidget("button", "entranceButton", 0, true)
    entranceButton:SetText(GetUIText(BATTLE_FIELD_TEXT, "random_entrance"))
    ApplyButtonSkin(entranceButton, BUTTON_BASIC.DEFAULT)
    ButtonOnClickHandler(entranceButton, OnClick_EntranceButton)
    entranceButton:AddAnchor("BOTTOMRIGHT", tab, 0, 0)
    local cancelButton = frame:CreateChildWidget("button", "cancelButton", 0, true)
    cancelButton:Show(false)
    cancelButton:SetText(locale.battlefield.cancelEntrance)
    ApplyButtonSkin(cancelButton, BUTTON_BASIC.DEFAULT)
    cancelButton:AddAnchor("BOTTOMRIGHT", tab, 0, 0)
    local switchSquadListBtn = frame:CreateChildWidget("button", "switchSquadListBtn", 0, true)
    switchSquadListBtn:SetText(GetCommonText("squad_recruit_and_search"))
    ApplyButtonSkin(switchSquadListBtn, BUTTON_BASIC.DEFAULT)
    switchSquadListBtn:AddAnchor("RIGHT", entranceButton, "LEFT", 0, 0)
    local buttonTable = {
      entranceButton,
      cancelButton,
      switchSquadListBtn
    }
    AdjustBtnLongestTextWidth(buttonTable)
    local enterCount = frame:CreateChildWidget("textbox", "enterCount", 0, true)
    enterCount:SetAutoWordwrap(false)
    enterCount:SetAutoResize(true)
    enterCount:AddAnchor("TOPRIGHT", frame, "BOTTOMRIGHT", -5, 11)
    enterCount:Show(featureSet.indunPortal)
    ApplyTextColor(enterCount, FONT_COLOR.DEFAULT)
    local enterCountGuide = W_ICON.CreateGuideIconWidget(enterCount)
    enterCountGuide:AddAnchor("RIGHT", enterCount, "LEFT", -3, 0)
    local OnEnter = function(self)
      SetTooltip(GetUIText(COMMON_TEXT, "Battlefield_entrance_count_info"), self)
    end
    enterCountGuide:SetHandler("OnEnter", OnEnter)
    local resetCount = frame:CreateChildWidget("textbox", "enterCount", 0, true)
    resetCount:SetAutoWordwrap(false)
    resetCount:SetAutoResize(true)
    resetCount:AddAnchor("TOPRIGHT", enterCount, "BOTTOMRIGHT", 0, 5)
    ApplyTextColor(resetCount, FONT_COLOR.DEFAULT)
    function frame:SetPreview(zoneName)
      preview:SetTexture(string.format("%s/%s.dds", TEXTURE_PATH.BATTLEFIELD_PREVIEW_PREFIX, zoneName))
      preview:SetTextureInfo("image")
    end
    function frame:SetBalanceLevel(level)
      description:RemoveAllAnchors()
      if level == nil or level == 0 then
        balanceLevel:Show(false)
        description:AddAnchor("TOPLEFT", targetParent, 0, 0)
      else
        balanceLevel:Show(true)
        description:AddAnchor("TOPLEFT", balanceLevel, "BOTTOMLEFT", 0, 8)
      end
    end
    function frame:SetDescription(desc)
      description:SetText(desc)
    end
    function frame:SetAdditionalInfo(info)
      local str = ""
      local totalPlayTime = locale.time.GetRemainDate(0, 0, 0, 0, info.playingTime, 0)
      local valueTime = ""
      if info.playRoundCount ~= nil and 0 < info.playRoundCount then
        valueTime = string.format("%s %s", totalPlayTime, locale.battlefield.playTimeDetail(info.playRoundCount, info.roundTime))
      else
        valueTime = totalPlayTime
      end
      str = F_TEXT.SetColonFormat(locale.battlefield.playTime, valueTime)
      local strMinLevel = GetLevelToString(info.levelMin)
      local strMaxLevel = GetLevelToString(info.levelMax)
      local levelStr = F_TEXT.SetColonFormat(GetCommonText("raid_level_limit"), string.format("%s - %s", strMinLevel, strMaxLevel))
      str = F_TEXT.SetEnterString(str, levelStr)
      local gearStr = ""
      if 0 < info.gearScore then
        gearStr = F_TEXT.SetColonFormat(GetCommonText("gear_score_limit"), info.gearScore)
      else
        gearStr = GetCommonText("gear_score_no_limit")
      end
      str = F_TEXT.SetEnterString(str, gearStr)
      local timeStr = F_TEXT.SetColonFormat(GetCommonText("battle_field_available_time"), GetCommonText("real_time"))
      str = F_TEXT.SetEnterString(str, timeStr)
      local timeDeatilStr = GetEntranceTime(info.entranceTime)
      str = F_TEXT.SetEnterString(str, timeDeatilStr)
      if info.maxPlayerCount ~= nil then
        local maxStr = F_TEXT.SetColonFormat(GetCommonText("instance_max_enter_player"), tostring(info.maxPlayerCount))
        str = F_TEXT.SetEnterString(str, maxStr)
      end
      additionalInfo:SetText(str)
    end
    function frame:SetVictoryInfo(info)
      if info == nil then
        victoryFrame:Show(false)
        victoryFrame:SetHeight(0)
      else
        victoryFrame:Show(true)
        scoreGoal:Show(false)
        killCountGoal:Show(false)
        winCountGoal:Show(false)
        targetDestoryGoal:Show(false)
        rankGoal:Show(false)
        local lastTarget = victoryTitle
        local function PushVictoryGoal(widget, text, anchorTarget)
          widget:Show(true)
          widget:AddAnchor("TOPLEFT", anchorTarget, "BOTTOMLEFT", 0, anchorTarget == victoryTitle and 20 or 7)
          if text ~= nil then
            widget:SetText(text)
          end
        end
        local score = info.victoryScore
        if score ~= nil and score > 0 then
          PushVictoryGoal(scoreGoal, locale.battlefield.winCondition.scoreAttainment(score), lastTarget)
          lastTarget = scoreGoal
        end
        local killCount = info.victoryKillCount
        if killCount ~= nil and killCount > 0 then
          PushVictoryGoal(killCountGoal, locale.battlefield.winCondition.killCountAttainment(killCount), lastTarget)
          lastTarget = killCount
        end
        local winCount = info.victoryRoundWinCount
        if winCount ~= nil and winCount > 0 then
          PushVictoryGoal(winCountGoal, locale.battlefield.winCondition.roundWinCountAttainment(winCount), lastTarget)
          lastTarget = winCountGoal
        end
        local targetDestroy = info.victoryTarget ~= 0
        if targetDestroy then
          PushVictoryGoal(targetDestoryGoal, nil, lastTarget)
          lastTarget = targetDestoryGoal
        end
        local timeOut = info.victoryDefault
        local rankScope = info.victoryRankScope
        if timeOut == BFER_TIMEOVER_COMPARE_SCORE and rankScope ~= nil then
          PushVictoryGoal(rankGoal, locale.battlefield.winCondition.timeoverScopeRank(rankScope), lastTarget)
        else
          PushVictoryGoal(rankGoal, locale.battlefield.winCondition.scoreSuperiority, lastTarget)
        end
        lastTarget = rankGoal
        if lastTarget ~= nil then
          local _, height = F_LAYOUT.GetExtentWidgets(victoryTitle, lastTarget)
          victoryFrame:SetHeight(height + 30)
        end
      end
    end
    function frame:SetEnterCount(cur, max)
      local str = ""
      local color = FONT_COLOR.DEFAULT
      if max == 1000 then
        str = GetUIText(COMMON_TEXT, "Battlefield_entrance_unlimited")
      elseif cur < max then
        str = F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "Battlefield_entrance_condition"), string.format("%s/%s", tostring(cur), tostring(max)))
      else
        str = F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "Battlefield_entrance_condition"), string.format("%s/%s", tostring(cur), tostring(max)))
        str = string.format("%s %s", str, GetUIText(COMMON_TEXT, "Battlefield_entrance_reset_time"))
        color = FONT_COLOR_HEX.RED
      end
      ApplyTextColor(enterCount, color)
      enterCount:SetText(str)
    end
    function frame:SetResetCount(hasResetItem, cur, max)
      local resetAvailable = hasResetItem and max > 0
      local maxReset = max <= cur
      if not resetAvailable then
        resetCount:Show(false)
        return
      end
      local color = max <= cur and FONT_COLOR.RED or FONT_COLOR.DEFAULT
      resetCount:Show(true)
      resetCount:SetText(F_TEXT.SetColonFormat(GetUIText(COMMON_TEXT, "Battlefield_reset_condition"), string.format("%s/%s", tostring(cur), tostring(max))))
    end
    function frame:UpdateButtonWhenFillDetail(available, squadCreatable, hasSquad)
      entranceButton:Enable(available and not hasSquad)
      switchSquadListBtn:Enable(available and squadCreatable)
    end
    function frame:UpdateButtonWithApplyInfo(apply)
      entranceButton:Show(not apply)
      cancelButton:Show(apply)
    end
    function frame:SetScrollValue(value)
      scrollWnd:SetValue(value)
    end
    function frame:ResetScroll()
      local startTarget = balanceLevel:IsVisible() and balanceLevel or description
      local endTarget = victoryFrame:IsVisible() and victoryFrame or additionalInfo
      local _, startPos = startTarget:GetOffset()
      local _, endPos = endTarget:GetOffset()
      local scrollHeight = endPos + endTarget:GetHeight() - startPos + 15
      scrollWnd:ResetScroll(scrollHeight)
    end
    return frame
  end
  local leftList = CreateLeftList("leftList", window)
  leftList:AddAnchor("TOPLEFT", tab, 0, 40)
  window.leftList = leftList
  local rightDetail = CreateDetailInfo("rightDetail", window)
  local rightTitle = CreateDeatilTitle("rightTitle", window)
  rightTitle:AddAnchor("TOPLEFT", leftList, "TOPRIGHT", 10, 0)
  rightDetail:AddAnchor("TOPLEFT", rightTitle, "BOTTOMLEFT", 0, 0)
  local squadList = CreateSquadList("squadList", window, rightWidth, contentHeight, titleHeight)
  squadList:AddAnchor("TOPLEFT", rightTitle, "BOTTOMLEFT", 0, 0)
  squadList:Show(false)
  return window
end
local function CreateEntranceWindow(id, parent)
  local window = SetViewOfEntranceWindow(id, parent)
  local tab = window.tab
  local leftList = window.leftList
  local rightTitle = window.rightTitle
  local rightDetail = window.rightDetail
  local squadList = window.squadList
  local selectedInstance
  local activatedInstances = {}
  function window:GetSelectedInstance()
    return selectedInstance
  end
  local function OnClickEntranceBtn()
    if X2Squad:HasMySquad() or X2Team:IsSiegeRaidTeam() then
      return
    end
    if selectedInstance == nil then
      return
    end
    X2BattleField:RequestInstanceGame(selectedInstance)
  end
  rightDetail.entranceButton:SetHandler("OnClick", OnClickEntranceBtn)
  local OnClickCancelBtn = function()
    if X2Squad:HasMySquad() then
      return
    end
    X2BattleField:CancelInstanceGame()
  end
  rightDetail.cancelButton:SetHandler("OnClick", OnClickCancelBtn)
  local function SwitchPage(showSquadList)
    if showSquadList then
      if not featureSet.squad and UIParent:GetPermission(UIC_SQUAD) then
        return
      end
      if selectedInstance == nil then
        return
      end
      squadList:SetCurrentInstance(selectedInstance)
      rightDetail:Show(false)
      squadList:Show(true)
      X2Squad:GetSquadList(selectedInstance, 0)
    else
      squadList:SetCurrentInstance(nil)
      rightDetail:Show(true)
      squadList:Show(false)
    end
  end
  local function OnClickSwitchSqustListBtn()
    SwitchPage(true)
  end
  ButtonOnClickHandler(rightDetail.switchSquadListBtn, OnClickSwitchSqustListBtn)
  local function OnClickBackButton()
    SwitchPage(false)
  end
  ButtonOnClickHandler(squadList.backButton, OnClickBackButton)
  local function SetEnableTabButtonsByApplyStatus(apply)
    if apply then
      local selectTab = tab:GetSelectedTab()
      for i = 1, #tab.window do
        if selectTab ~= i then
          local tabButton = tab.unselectedButton[i]
          tabButton:Enable(not apply)
        end
      end
    else
      window:ChangeEnablementTabButtons()
    end
  end
  local function SetEnableLeftList(enable)
    leftList.listCtrl:Enable(enable, true)
  end
  function window:UpdateApplyInfo(tabChanged)
    local apply = X2BattleField:IsApplyInstance()
    if not apply then
      rightDetail:UpdateButtonWithApplyInfo(false)
      if tabChanged ~= true then
        SetEnableTabButtonsByApplyStatus(false)
        SetEnableLeftList(true)
      end
      return
    end
    SetEnableTabButtonsByApplyStatus(true)
    SetEnableLeftList(false)
    local addCondition = X2Squad:HasMySquad() or X2Team:IsSiegeRaidTeam()
    if addCondition then
      rightDetail:UpdateButtonWithApplyInfo(false)
    else
      rightDetail:UpdateButtonWithApplyInfo(true)
    end
  end
  function window:FillList(info)
    leftList:DeleteAllDatas()
    local list = activatedInstances[info.type]
    if list == nil then
      return false
    end
    for i = 1, #list do
      local curInfo = list[i]
      curInfo.path = info.path
      leftList:InsertData(list[i].type, 1, curInfo)
    end
    return true
  end
  function window:SelectByInstanceType(instanceType)
    leftList:SelectByDataKey(instanceType)
  end
  function window:FillDetail(instanceType)
    local info = X2BattleField:GetDetailInstanceInfo(instanceType)
    if info == nil then
      return
    end
    SwitchPage(false)
    rightDetail:SetScrollValue(0)
    rightTitle:SetTitle(info.name)
    rightDetail:SetPreview(info.zoneName)
    rightDetail:SetBalanceLevel(info.balanceLevel)
    rightDetail:SetDescription(info.desc)
    rightDetail:SetAdditionalInfo(info)
    rightDetail:SetVictoryInfo(X2BattleField:GetVictoryInfo(instanceType))
    rightDetail:ResetScroll()
    rightDetail:SetEnterCount(info.enterCount, info.maxEnterCount)
    rightDetail:SetResetCount(info.resetItem, info.resetCount, info.resetLimit)
    rightDetail:UpdateButtonWhenFillDetail(info.available, info.squadCreatable, info.hasSquad)
  end
  function leftList:SelChangedProc(selDataViewIdx, selDataIdx, selDataKey, doubleClick)
    if selDataViewIdx == 0 or selDataKey == nil then
      return
    end
    window:FillDetail(selDataKey)
    selectedInstance = selDataKey
  end
  function window:ChangeEnablementTabButtons()
    local activatedCount = 0
    local activatedFirstTab = 0
    for i = 1, #tab.window do
      local info = window:GetKindInfo(i)
      local selectedButton = tab.selectedButton[i]
      local unselectedButton = tab.unselectedButton[i]
      local list = X2BattleField:GetInstanceListByKind(info.type)
      if list == nil or #list == 0 then
        selectedButton:Enable(false)
        unselectedButton:Enable(false)
      else
        selectedButton:Enable(true)
        unselectedButton:Enable(true)
        activatedInstances[info.type] = list
        activatedCount = activatedCount + 1
        if activatedFirstTab == 0 then
          activatedFirstTab = i
        end
      end
    end
    return activatedCount, activatedFirstTab
  end
  function window.tab:OnTabChangedProc(selected)
    local info = window:GetKindInfo(selected)
    SwitchPage(false)
    rightDetail:ShowHonorStore(info.showHonorStore)
    local result = window:FillList(info)
    if result then
      leftList.listCtrl:Select(0, true)
    end
  end
  window:ChangeEnablementTabButtons()
  window.tab:OnTabChangedProc(1)
  local events = {
    LEVEL_CHANGED = function(_, stringId)
      if not W_UNIT.IsMyUnitId(stringId) then
        return
      end
      window:ChangeEnablementTabButtons()
    end,
    LEFT_LOADING = function()
      window:Show(false)
    end,
    ENTERED_INSTANT_GAME_ZONE = function()
      window:Show(false)
    end,
    UPDATE_INSTANT_GAME_STATE = function()
      window:UpdateApplyInfo(false)
      ShowBattleFieldEntranceAlarm(true)
    end,
    INSTANT_GAME_JOIN_APPLY = function()
      window:UpdateApplyInfo(false)
      ShowBattleFieldEntranceAlarm(true)
    end,
    INSTANT_GAME_JOIN_CANCEL = function()
      window:FillDetail(selectedInstance)
      window:UpdateApplyInfo(false)
      ShowBattleFieldEntranceAlarm(false)
    end,
    INSTANT_GLOBAL_MATCH_STATUES_UPDATE = function(state)
      local data = leftList:GetDataByKey(selectedInstance, 1)
      data.globalField = true
      leftList:UpdateData(selectedInstance, 1, data)
    end,
    INSTANT_GAME_VISIT_COUNT_RESET = function(state)
      window:FillDetail(selectedInstance)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
instanceEntrance = CreateEntranceWindow("entrance", "UIParent")
instanceEntrance:AddAnchor("LEFT", "UIParent", 0, 0)
function ToggleInstanceEntrance(show, num, instanceUiKindType, instanceType)
  if not X2Player:IsInSeamlessZone() then
    AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "instant_game_hud_button_disable_tooltip"))
    return false
  end
  if X2Team:IsSiegeRaidTeam() then
    AddMessageToSysMsgWindow(X2Locale:LocalizeUiText(ERROR_MSG, "DO_NOT_USABLE_INDUN_IN_SIEGE_RAID_TEAM"))
    return false
  end
  local activatedCount, activatedFirstTab = 0, 0
  if show == true then
    activatedCount, activatedFirstTab = instanceEntrance:ChangeEnablementTabButtons()
    if activatedCount == 0 then
      AddMessageToSysMsgWindow(GetUIText(COMMON_TEXT, "battle_field_list_none"))
      return false
    end
  end
  local isVisible = instanceEntrance:IsVisible()
  if byInteraction and isVisible then
    return true
  end
  isVisible = not isVisible
  if isVisible then
    if instanceUiKindType == nil or instanceType == nil then
      local info = X2BattleField:GetApplyInstanceInfo()
      if info ~= nil then
        instanceUiKindType = info.instanceUiKindType
        instanceType = info.instanceType
      end
    end
    local selectableTab = instanceEntrance:GetTabIndexByKindType(instanceUiKindType)
    if selectableTab == 0 then
      selectableTab = activatedFirstTab or 1
    end
    instanceEntrance.tabs:SelectTab(selectableTab)
    local selectableInstance = instanceType
    if instanceType == nil then
      selectableInstance = instanceEntrance:GetSelectedInstance()
    end
    instanceEntrance:SelectByInstanceType(selectableInstance)
    instanceEntrance:UpdateApplyInfo()
  end
  instanceEntrance:Show(isVisible)
  return true
end
local ToggleInstant = function(instanceUiKindType, instanceType)
  ToggleInstanceEntrance(true, 0, instanceUiKindType, instanceType)
end
UIParent:SetEventHandler("TOGGLE_INSTANT", ToggleInstant)
