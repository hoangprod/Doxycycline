local GetGradeUpLimitWithColor = function(color, upLimitValue)
  return string.format("|c%s|,%d;", color, upLimitValue)
end
local CreatePossibleUpgradeFrame = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", "id", 0, true)
  frame:SetHeight(40)
  local bg = CreateContentBackground(frame, "TYPE1", "brown")
  bg:AddAnchor("TOPLEFT", frame, 0, 0)
  bg:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  local text = frame:CreateChildWidget("textbox", "text", 0, true)
  text:AddAnchor("TOPLEFT", frame, 0, 0)
  text:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  text.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(text, FONT_COLOR.MIDDLE_TITLE)
  return frame
end
local CreateBottomFrame = function(id, parent)
  local frame = parent:CreateChildWidget("emptywidget", id, 0, true)
  frame:SetExtent(parent:GetWidth(), 60)
  local gradeInfoBtn = frame:CreateChildWidget("button", "gradeInfoBtn", 0, false)
  gradeInfoBtn:AddAnchor("TOPLEFT", frame, 0, 0)
  gradeInfoBtn:SetText(GetUIText(COMMON_TEXT, "grade_info"))
  ApplyButtonSkin(gradeInfoBtn, BUTTON_BASIC.DEFAULT)
  frame.gradeInfoWnd = nil
  local function OnClick()
    if frame.gradeInfoWnd ~= nil then
      frame.gradeInfoWnd:Show(not frame.gradeInfoWnd:IsVisible())
      return
    end
    if frame.gradeInfoWnd == nil then
      frame.gradeInfoWnd = CreateActabilityGradeInfoWnd("gradeInfoWnd", "UIParent")
      local function OnHide()
        frame.gradeInfoWnd = nil
      end
      frame.gradeInfoWnd:SetHandler("OnHide", OnHide)
    end
    frame.gradeInfoWnd:Show(true)
  end
  gradeInfoBtn:SetHandler("OnClick", OnClick)
  local expandBtn = frame:CreateChildWidget("button", "expandBtn", 0, false)
  expandBtn:AddAnchor("TOPRIGHT", frame, 0, 0)
  expandBtn:SetText(GetUIText(SKILL_TEXT, "expert_expand"))
  ApplyButtonSkin(expandBtn, BUTTON_BASIC.DEFAULT)
  local function ExpandBtnLeftClickFunc()
    local DialogHandler = function(wnd)
      local info = X2Ability:GetExpandExpertInfo()
      local maxCount = X2Ability:GetExpertMaxCount()
      wnd:SetTitle(GetUIText(SKILL_TEXT, "expert_expand"))
      wnd:UpdateDialogModule("textbox", GetUIText(SKILL_TEXT, "expand_msg1"))
      local changeData = {
        titleInfo = {
          title = GetUIText(COMMON_TEXT, "add_expert_slot")
        },
        left = {
          UpdateValueFunc = function(leftValueWidget)
            leftValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(maxCount)))
          end
        },
        right = {
          UpdateValueFunc = function(rightValueWidget)
            rightValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(maxCount + 1)))
          end
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeExpert", changeData)
      if info.requireItemType ~= nil and info.requireItemType ~= 0 then
        local itemData = {
          itemInfo = info.requireItemInfo,
          stack = {
            info.haveItemCount,
            info.requireItemCount
          }
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
      end
      if info.requireLP ~= nil and info.requireLP ~= 0 then
        local costData = {
          type = "living_point",
          currency = CURRENCY_LIVING_POINT,
          value = info.requireLP
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "costLP", costData)
      end
      local textData = {
        type = "default",
        text = GetUIText(SKILL_TEXT, "expand_msg2", tostring(info.remainExpandCnt or 0))
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "leftCountInfo", textData)
      function wnd:OkProc()
        X2Ability:ExpandExpert()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, parent:GetId())
  end
  ButtonOnClickHandler(expandBtn, ExpandBtnLeftClickFunc)
  local OnEnter = function(self)
    if self:IsEnabled() then
      return
    end
    SetTooltip(GetUIText(SKILL_TEXT, "expandWarning"), self)
  end
  expandBtn:SetHandler("OnEnter", OnEnter)
  function expandBtn:Update()
    self:Enable(X2Ability:CanExpandExpert())
  end
  local allCount = CreateActabilityExpertCountLabel("allCount", frame)
  allCount:AddAnchor("BOTTOMRIGHT", frame, 0, 0)
  allCount:Update()
  local intensifiedExpertCount = CreateActabilityExpertCountLabel("intensifiedExpertCount", frame, "intensified")
  intensifiedExpertCount:AddAnchor("BOTTOMLEFT", frame, 0, 0)
  intensifiedExpertCount:Update()
  function frame:Update()
    allCount:Update()
    expandBtn:Update()
    intensifiedExpertCount:Update()
  end
  frame:Update()
  return frame
end
local CreateItemWindow = function(parent, index, itemInfo, dialogOwner)
  local itemWindow = UIParent:CreateWidget("emptywidget", string.format("itemWindow[%d]", index), parent)
  itemWindow:Show(true)
  itemWindow:SetExtent(200, 40)
  itemWindow.itemInfo = itemInfo
  local bg = CreateContentBackground(itemWindow, "TYPE1", "brown")
  bg:AddAnchor("TOPLEFT", itemWindow, -10, -6)
  bg:AddAnchor("BOTTOMRIGHT", itemWindow, 10, 5)
  itemWindow.bg = bg
  local actabilityPoint = itemWindow:CreateChildWidget("label", "actabilityPoint", 0, true)
  actabilityPoint:SetNumberOnly(true)
  actabilityPoint:SetText(string.format("%d", itemInfo.point + itemInfo.modifyPoint))
  actabilityPoint:AddAnchor("TOPLEFT", itemWindow, 45, 21)
  actabilityPoint.style:SetAlign(ALIGN_LEFT)
  if itemInfo.modifyPoint == 0 then
    ApplyTextColor(actabilityPoint, FONT_COLOR.DEFAULT)
  else
    ApplyTextColor(actabilityPoint, FONT_COLOR.GREEN)
  end
  local upgradeButton = itemWindow:CreateChildWidget("button", "upgradeButton", 0, true)
  upgradeButton:Show(false)
  upgradeButton:AddAnchor("TOPRIGHT", itemWindow, localeView.actionPointUpgrateButton, 5)
  ApplyButtonSkin(upgradeButton, BUTTON_CONTENTS.ACTABILITY_UP)
  local downgradeButton = itemWindow:CreateChildWidget("button", "downgradeButton", 0, true)
  downgradeButton:Show(false)
  downgradeButton:AddAnchor("TOPRIGHT", itemWindow, localeView.actionPointDownGradeButton, 8)
  ApplyButtonSkin(downgradeButton, BUTTON_CONTENTS.ACTABILITY_DOWN)
  local bg = itemWindow:CreateDrawable(TEXTURE_PATH.DEFAULT, "icon_button_bg", "artwork")
  bg:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
  local itemIcon = itemWindow:CreateIconImageDrawable("Textures/Defaults/White.dds", "artwork")
  itemIcon:SetColor(1, 1, 1, 1)
  itemIcon:SetCoords(0, 0, 128, 128)
  itemIcon:SetExtent(40, 40)
  itemIcon:AddAnchor("LEFT", itemWindow, 0, 0)
  itemIcon:ClearAllTextures()
  itemWindow.itemIcon = itemIcon
  bg:AddAnchor("CENTER", itemIcon, 0, 0)
  local name = CreateActabilityGradeIconWidget("name", itemWindow)
  name:AddAnchor("TOPLEFT", itemIcon, "TOPRIGHT", 3, -2)
  itemWindow.name = name
  local gauge = W_BAR.CreateSkillBar(itemWindow:GetId() .. ".gauge", itemWindow)
  gauge:SetWidth(itemWindow:GetWidth() - ICON_SIZE.DEFAULT - 10)
  gauge:AddAnchor("BOTTOMLEFT", itemIcon, "BOTTOMRIGHT", 2, 0)
  itemWindow.minAbilityPoint = X2Ability:GetMinActabilityPoint(itemInfo.type)
  itemWindow.maxAbilityPoint = X2Ability:GetMaxActabilityPoint(itemInfo.type)
  gauge:SetMinMaxValues(itemWindow.minAbilityPoint, itemWindow.maxAbilityPoint)
  gauge:SetValue(itemInfo.point)
  itemWindow.gauge = gauge
  function itemWindow:DefaultSetting(info)
    local gradeInfo = X2Ability:GetGradeInfo(info.grade)
    local itemInfo = self.itemInfo
    local isLanguageActability = X2Ability:IsLanguageActability(info.type)
    self.gauge:ChangeStatusBarTextureOfActabilityGrade(gradeInfo.gaugeColorString)
    local nameStr = string.format("%s", itemInfo.name)
    self.name:SetGradeInfo(info.grade, nameStr, gradeInfo.colorString)
    self.upgradeButton:Show(false)
    self.downgradeButton:Show(false)
    self.actabilityPoint:SetText(string.format("%d", self.itemInfo.point + self.itemInfo.modifyPoint))
    if self.itemInfo.modifyPoint == 0 then
      ApplyTextColor(self.actabilityPoint, FONT_COLOR.DEFAULT)
    else
      ApplyTextColor(self.actabilityPoint, FONT_COLOR.GREEN)
    end
    local upgradeable = X2Ability:CanUpgradeExpert(info.type)
    local downgradeable = X2Ability:CanDowngradeExpert(info.type)
    self.upgradeButton:Enable(upgradeable and isLanguageActability == false)
    if gradeInfo.intensifiedExpertCount ~= nil then
      ApplyTextureColor(self.bg, {
        ConvertColor(98),
        ConvertColor(226),
        ConvertColor(234),
        0.4
      })
    elseif upgradeable and isLanguageActability == false then
      ApplyTextureColor(self.bg, {
        ConvertColor(132),
        ConvertColor(172),
        ConvertColor(212),
        0.4
      })
    else
      self.bg:SetTextureColor("brown")
    end
    if info.grade ~= ACTABILITY_EXPERT.GRADE.NEWBIE and info.grade ~= X2Ability:GetMaxGrade() then
      self.upgradeButton:Show(true)
      self.downgradeButton:Show(true)
    elseif info.grade == ACTABILITY_EXPERT.GRADE.NEWBIE and info.point >= self.maxAbilityPoint then
      self.upgradeButton:Show(not isLanguageActability)
    elseif info.grade == X2Ability:GetMaxGrade() then
      self.downgradeButton:Show(true)
    end
    if self.upgradeButton:IsVisible() then
      self.upgradeButton:RemoveAllAnchors()
      if self.downgradeButton:IsVisible() then
        upgradeButton:AddAnchor("TOPRIGHT", itemWindow, localeView.actionPointUpgrateButton, 5)
      else
        upgradeButton:AddAnchor("TOPRIGHT", itemWindow, localeView.actionPointDownGradeButton, 5)
      end
    end
  end
  itemWindow:DefaultSetting(itemWindow.itemInfo)
  local function OnEnter(self)
    if upgradeButton:IsMouseOver() or downgradeButton:IsMouseOver() then
      return
    end
    local info = self.itemInfo
    local GetPercent = function(grade, curPoint, minPoint, maxPoint)
      if grade > ACTABILITY_EXPERT.GRADE.NEWBIE then
        return (curPoint - minPoint) / (maxPoint - minPoint) * 100
      else
        return curPoint / maxPoint * 100
      end
    end
    local percent = GetPercent(info.grade, info.point, itemWindow.minAbilityPoint, itemWindow.maxAbilityPoint)
    local calcPoint = info.point + info.modifyPoint
    local gradeInfo = X2Ability:GetGradeInfo(info.grade)
    local str = ""
    if info.modifyPoint == 0 then
      str = string.format([[
|c%s%s [%s: %d%%]|r
|,%d;/|,%d;]], gradeInfo.colorString, info.name, gradeInfo.name, percent, info.point, itemWindow.maxAbilityPoint)
    else
      str = string.format([[
|c%s%s [%s: %d%%]|r
|,%d;%s+|,%d;|r / |,%d;]], gradeInfo.colorString, info.name, gradeInfo.name, percent, info.point, FONT_COLOR_HEX.SINERGY, info.modifyPoint, itemWindow.maxAbilityPoint)
    end
    if info.accumulatedPoint ~= nil then
      local nextGradeInfo = X2Ability:GetGradeInfo(info.grade + 1)
      str = F_TEXT.SetEnterString(str, string.format("%s%s %s: %d", ACTABILITY_EXPERT.COMMON_COLOR, nextGradeInfo.name, GetUIText(COMMON_TEXT, "accumulated_actability_point"), info.accumulatedPoint), 2)
    end
    SetTooltip(str, self)
  end
  itemWindow:SetHandler("OnEnter", OnEnter)
  function itemWindow:Update(info)
    self.itemInfo = info
    gauge:SetValue(info.point)
    self:DefaultSetting(info)
  end
  function itemWindow:ChangeGrade(info, minAbilityPoint, maxAbilityPoint)
    self.minAbilityPoint = minAbilityPoint
    self.maxAbilityPoint = maxAbilityPoint
    self.itemInfo = info
    gauge:SetMinMaxValues(minAbilityPoint, maxAbilityPoint)
    gauge:SetValue(info.point)
    self:DefaultSetting(info)
  end
  local GetUpgradeButtonTooltip = function(upgradeButton)
    local GetAllUseActabilityStr = function(name, count, isMaster)
      if isMaster then
        return X2Locale:LocalizeUiText(SKILL_TEXT, "sample_tip_master", name, tostring(count))
      else
        return X2Locale:LocalizeUiText(SKILL_TEXT, "sample_tip_under_master", name, tostring(count))
      end
    end
    if upgradeButton:IsEnabled() then
      return GetUIText(COMMON_TEXT, "expert_upgrade_default_tooltip")
    else
      local info = upgradeButton:GetParent().itemInfo
      if X2Ability:CanUpgradeExpert(info.type) then
        return
      end
      local nextGradeInfo = X2Ability:GetGradeInfo(info.grade + 1)
      local maxAbilityPoint = upgradeButton:GetParent().maxAbilityPoint
      local remainCount = X2Ability:GetRemainCountToNextGrade(info.grade, info.viewGroupType, false)
      if remainCount == 0 then
        if nextGradeInfo.intensifiedExpertCount == nil then
          if info.grade == ACTABILITY_EXPERT.GRADE.NEWBIE then
            return GetUIText(COMMON_TEXT, "expert_count_limit_tooltip_for_newbie")
          else
            return GetAllUseActabilityStr(nextGradeInfo.name, nextGradeInfo.expertLimit, nextGradeInfo.grade == X2Ability:GetMaxGrade())
          end
        else
          local expertCount = nextGradeInfo.intensifiedExpertCount
          local categoryCount = expertCount[info.viewGroupType] or 0
          return GetAllUseActabilityStr(nextGradeInfo.name, categoryCount, nextGradeInfo.grade == X2Ability:GetMaxGrade())
        end
      else
        return GetUIText(SKILL_TEXT, "warning_more_actability")
      end
    end
  end
  local function OnEnter(self)
    SetTooltip(GetUpgradeButtonTooltip(self), self)
  end
  upgradeButton:SetHandler("OnEnter", OnEnter)
  local OnEnter = function(self)
    SetTooltip(GetUIText(COMMON_TEXT, "expert_downgrade_default_tooltip"), self)
  end
  downgradeButton:SetHandler("OnEnter", OnEnter)
  local function LeftClickFuncUpgradeBtn(self)
    X2DialogManager:DeleteByOwnerWindow(dialogOwner:GetId())
    local function DialogHandler(wnd, infoTable)
      local prevGrade = itemWindow.itemInfo.grade
      local nextGrade = itemWindow.itemInfo.grade + 1
      local prevGradeInfo = X2Ability:GetGradeInfo(prevGrade)
      local nextGradeInfo = X2Ability:GetGradeInfo(nextGrade)
      local remainCount = X2Ability:GetRemainCountToNextGrade(prevGrade, itemWindow.itemInfo.viewGroupType, true)
      wnd:SetTitle(GetUIText(SKILL_TEXT, "upgrade_title"))
      wnd:UpdateDialogModule("textbox", GetUIText(SKILL_TEXT, "upgrade_content", itemWindow.itemInfo.name))
      local changeData = {
        titleInfo = {
          title = GetUIText(COMMON_TEXT, "change_expert_grade")
        },
        left = {
          CreateValueFunc = function(id, parent)
            return CreateActabilityGradeIconWidget("prevGrade", parent)
          end,
          UpdateValueFunc = function(leftValueWidget)
            leftValueWidget:SetGradeInfo(prevGrade, prevGradeInfo.name, prevGradeInfo.colorString)
          end
        },
        right = {
          CreateValueFunc = function(id, parent)
            return CreateActabilityGradeIconWidget("nextGrade", parent)
          end,
          UpdateValueFunc = function(rightValueWidget)
            rightValueWidget:SetGradeInfo(nextGrade, nextGradeInfo.name, nextGradeInfo.colorString)
          end
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeUpgrade", changeData)
      if tonumber(prevGradeInfo.upPrice) ~= 0 and prevGradeInfo.upPrice ~= nil then
        local costData = {
          type = "cost",
          currency = prevGradeInfo.upCurrency,
          value = prevGradeInfo.upPrice
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "upgradeCost", costData)
      end
      local textData = {type = "default"}
      if nextGradeInfo.intensifiedExpertCount == nil then
        textData.text = GetUIText(SKILL_TEXT, "upgrade_warning", nextGradeInfo.name, tostring(remainCount))
      else
        local name = X2Ability:GetActabilityViewGroupName(itemWindow.itemInfo.viewGroupType)
        textData.text = GetUIText(SKILL_TEXT, "upgrade_warning", name, tostring(remainCount))
      end
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warningUpgrade", textData)
      function wnd:OkProc()
        X2Ability:UpgradeExpert(itemWindow.itemInfo.type)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, dialogOwner:GetId())
  end
  ButtonOnClickHandler(upgradeButton, LeftClickFuncUpgradeBtn)
  local function LeftClickFuncDowngradeBtn(self)
    X2DialogManager:DeleteByOwnerWindow(dialogOwner:GetId())
    local function DialogHandler(wnd, infoTable)
      local prevGrade = itemWindow.itemInfo.grade
      local nextGrade = itemWindow.itemInfo.grade - 1
      local prevGradeInfo = X2Ability:GetGradeInfo(prevGrade)
      local nextGradeInfo = X2Ability:GetGradeInfo(nextGrade)
      wnd:SetTitle(GetUIText(SKILL_TEXT, "downgrade_title"))
      wnd:UpdateDialogModule("textbox", GetUIText(SKILL_TEXT, "downgrade_content", itemWindow.itemInfo.name))
      local changeData = {
        titleInfo = {
          title = GetUIText(COMMON_TEXT, "change_expert_grade")
        },
        left = {
          CreateValueFunc = function(id, parent)
            return CreateActabilityGradeIconWidget("prevGrade", parent)
          end,
          UpdateValueFunc = function(leftValueWidget)
            leftValueWidget:SetGradeInfo(prevGrade, prevGradeInfo.name, prevGradeInfo.colorString)
          end
        },
        right = {
          CreateValueFunc = function(id, parent)
            return CreateActabilityGradeIconWidget("nextGrade", parent)
          end,
          UpdateValueFunc = function(rightValueWidget)
            rightValueWidget:SetGradeInfo(nextGrade, nextGradeInfo.name, nextGradeInfo.colorString)
          end
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeDowngrade", changeData)
      local itemType, requireItemInfo, hasCount, needCount = X2Ability:GetDownGradeItemInfo()
      if prevGradeInfo.intensifiedExpertCount ~= nil then
        local itemData = {
          itemInfo = requireItemInfo,
          stack = {hasCount, needCount}
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
      end
      if prevGradeInfo.intensifiedExpertCount == nil then
        local textData = {
          type = "warning",
          text = GetUIText(SKILL_TEXT, "downgrade_warning")
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
      else
        local textData = {
          type = "warning",
          text = GetUIText(COMMON_TEXT, "guide_downgrade_intensified_actability")
        }
        wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "warning", textData)
      end
      function wnd:OkProc()
        X2Ability:DowngradeExpert(itemWindow.itemInfo.type)
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, dialogOwner:GetId())
  end
  ButtonOnClickHandler(downgradeButton, LeftClickFuncDowngradeBtn)
  return itemWindow
end
function CreateActabilityPage(parent)
  local possibleUpgradeFrame = CreatePossibleUpgradeFrame("possibleUpgradeFrame", parent)
  possibleUpgradeFrame:AddAnchor("TOPLEFT", parent, 0, MARGIN.WINDOW_SIDE / 2)
  possibleUpgradeFrame:AddAnchor("TOPRIGHT", parent, 0, MARGIN.WINDOW_SIDE / 2)
  local scrollContent = CreateScrollWindow(parent, "scrollContent", 0)
  scrollContent:AddAnchor("TOPLEFT", possibleUpgradeFrame, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 2)
  local bottomFrame = CreateBottomFrame("bottomFrame", parent)
  bottomFrame:AddAnchor("TOPLEFT", scrollContent, "BOTTOMLEFT", 0, MARGIN.WINDOW_SIDE / 2)
  scrollContent:SetExtent(parent:GetWidth(), parent:GetHeight() - possibleUpgradeFrame:GetHeight() - bottomFrame:GetHeight() - MARGIN.WINDOW_SIDE * 3)
  function possibleUpgradeFrame:Update()
    local count = 0
    for i = 1, #scrollContent.actabilityItem do
      local item = scrollContent.actabilityItem[i]
      if item.upgradeButton:IsEnabled() then
        count = count + 1
      end
    end
    self.text:SetText(string.format("%s: %s%d", GetUIText(COMMON_TEXT, "possible_expert_upgrade_count_title"), FONT_COLOR_HEX.BLUE, count))
  end
  scrollContent.actabilityItem = {}
  local function CreateSection(id, titleStr, elemInfos)
    local section = UIParent:CreateWidget("emptywidget", id, scrollContent.content)
    local title = section:CreateChildWidget("label", "title", 0, false)
    title:SetAutoResize(true)
    title:SetHeight(FONT_SIZE.LARGE)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    title:AddAnchor("TOPLEFT", section, 0, 0)
    title:SetText(titleStr)
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    if id == 4 then
      local titleDesc = section:CreateChildWidget("label", "titleDesc", 0, false)
      titleDesc:SetAutoResize(true)
      titleDesc:SetHeight(FONT_SIZE.MIDDLE)
      titleDesc.style:SetFontSize(FONT_SIZE.MIDDLE)
      titleDesc:AddAnchor("TOPLEFT", title, "TOPRIGHT", 10, 0)
      titleDesc:SetText(GetCommonText("language_desc"))
      ApplyTextColor(titleDesc, FONT_COLOR.GRAY)
    end
    local index = 1
    local x = 0
    local y = MARGIN.WINDOW_SIDE + 2
    section.item = {}
    for i = 1, #elemInfos do
      local elemInfo = elemInfos[i]
      local acInfo = X2Ability:GetMyActabilityInfo(elemInfo.actabilityGroupType)
      local info = X2Craft:GetActabilityGroupInfoByGroupType(elemInfo.actabilityGroupType)
      local item = CreateItemWindow(section, i, acInfo, parent)
      item:AddAnchor("TOPLEFT", section, x, y)
      if info.skill_page_visible == true then
        item.itemIcon:AddTexture(info.icon_path)
      end
      scrollContent.actabilityItem[#scrollContent.actabilityItem + 1] = item
      x = x + item:GetWidth() + 5
      if i % 3 == 0 then
        x = 0
        y = y + 55
      end
    end
    section:SetHeight(math.floor(#elemInfos / 3 + 0.5) * 55 + MARGIN.WINDOW_SIDE)
    return section
  end
  local infos = X2Ability:GetActabilityViewInfo()
  local y = 0
  for i = 1, #infos do
    local info = infos[i]
    local section = CreateSection(string.format("section[%d]", info.id), info.name, info.elems)
    section:AddAnchor("TOPLEFT", scrollContent.content, 0, y)
    section:AddAnchor("TOPRIGHT", scrollContent.content, 0, y)
    y = y + section:GetHeight()
    if i ~= #infos then
      local line = CreateLine(section, "TYPE1")
      line:AddAnchor("TOPLEFT", section, "BOTTOMLEFT", 0, 0)
      line:AddAnchor("TOPRIGHT", section, "BOTTOMRIGHT", 0, 0)
      y = y + MARGIN.WINDOW_SIDE - 5
    end
  end
  scrollContent.height = y
  possibleUpgradeFrame:Update()
  local OnBoundChanged = function(self)
    self:ResetScroll(self.height)
  end
  scrollContent:SetHandler("OnBoundChanged", OnBoundChanged)
  function scrollContent:Update(actabilityId)
    for i = 1, #scrollContent.actabilityItem do
      local item = scrollContent.actabilityItem[i]
      if item.itemInfo.type == actabilityId then
        local info = X2Ability:GetMyActabilityInfo(actabilityId)
        item:Update(info)
        possibleUpgradeFrame:Update()
        return
      end
    end
  end
  function scrollContent:GradeChange(actabilityId)
    for i = 1, #scrollContent.actabilityItem do
      local item = scrollContent.actabilityItem[i]
      if actabilityId ~= nil and item.itemInfo.type == actabilityId then
        local info = X2Ability:GetMyActabilityInfo(actabilityId)
        local minAbilityPoint = X2Ability:GetMinActabilityPoint(actabilityId)
        local maxAbilityPoint = X2Ability:GetMaxActabilityPoint(actabilityId)
        item:ChangeGrade(info, minAbilityPoint, maxAbilityPoint)
      else
        item:DefaultSetting(item.itemInfo)
      end
    end
    possibleUpgradeFrame:Update()
  end
  function scrollContent:UpdateAll()
    for i = 1, #scrollContent.actabilityItem do
      local item = scrollContent.actabilityItem[i]
      local info = X2Ability:GetMyActabilityInfo(item.itemInfo.type)
      if info ~= nil then
        item:Update(info)
      end
    end
    possibleUpgradeFrame:Update()
  end
  function scrollContent:UpdateActabilityPoint()
    for i = 1, #scrollContent.actabilityItem do
      local item = scrollContent.actabilityItem[i]
      local info = X2Ability:GetMyActabilityInfo(item.itemInfo.type)
      item.itemInfo = info
      item.actabilityPoint:SetText(string.format("%d", item.itemInfo.point + item.itemInfo.modifyPoint))
      if item.itemInfo.modifyPoint == 0 then
        ApplyTextColor(item.actabilityPoint, FONT_COLOR.DEFAULT)
      else
        ApplyTextColor(item.actabilityPoint, FONT_COLOR.GREEN)
      end
    end
  end
  function parent:HideGradeInfo()
    if bottomFrame.gradeInfoWnd ~= nil and bottomFrame.gradeInfoWnd:IsVisible() then
      bottomFrame.gradeInfoWnd:Show(false)
    end
  end
  local events = {
    ACTABILITY_EXPERT_CHANGED = function(actabilityId)
      scrollContent:Update(actabilityId)
      bottomFrame:Update()
    end,
    ACTABILITY_EXPERT_GRADE_CHANGED = function(actabilityId)
      scrollContent:GradeChange(actabilityId)
      bottomFrame:Update()
    end,
    ACTABILITY_MODIFIER_UPDATE = function()
      scrollContent:UpdateAll()
    end,
    UNIT_EQUIPMENT_CHANGED = function()
      scrollContent:UpdateAll()
    end,
    CHANGE_ACTABILITY_DECO_NUM = function()
      scrollContent:UpdateAll()
    end,
    ACTABILITY_REFRESH_ALL = function()
      scrollContent:UpdateAll()
      bottomFrame:Update()
      possibleUpgradeFrame:Update()
    end,
    ACTABILITY_EXPERT_EXPANDED = function()
      scrollContent:UpdateAll()
      bottomFrame:Update()
      possibleUpgradeFrame:Update()
    end
  }
  scrollContent:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(scrollContent, events)
  return scrollContent
end
