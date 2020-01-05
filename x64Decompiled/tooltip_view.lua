local UI_SCALE_STEP_OFFSET = 10
function CreateSection(id, parent, useSeparate)
  if id == nil or parent == nil then
    UIParent:LogAlways("CreateTooltipSection Error")
    return
  end
  if useSeparate == nil then
    useSeparate = true
  end
  local section = parent:CreateChildWidget("emptywidget", "sections[" .. id .. "]", 0, true)
  section:Show(false)
  section:AddAnchor("TOPLEFT", parent, 30, 0)
  section:SetWidth(parent:GetWidth())
  section.useSeparate = useSeparate
  local upLine = CreateLine(section, "TYPE1")
  upLine:SetVisible(true)
  upLine:AddAnchor("TOPLEFT", section, 0, -5)
  section.upLine = upLine
  function section:SetSectionWidth(width)
    self:BindWidth(width)
    self.upLine:SetWidth(width)
  end
  return section
end
local BLUE_TOOLTIP_DEFAULT_DELAY_TIME = 200
ONLY_BASE = 1
FIRST_COMPARE = 2
SECOND_COMPARE = 3
BASE_NO_ANCHOR_OFFSET = 4
BASE_WITH_COMPARE_EXTENT = 5
ITEM_COMPARE = 1
ITEM_LINK_COMPARE = 2
SKILL_COMPARE = 3
local function CreateBlueTooltip(id, kind, compareType)
  local needCreateWindow = kind == TOOLTIP_KIND.ITEM_LINK or kind == TOOLTIP_KIND.QUEST_LINK
  local blueTooltip
  if needCreateWindow then
    blueTooltip = CreateWindow("tooltip." .. id, "UIParent")
    if compareType == nil then
      blueTooltip.titleBar:SetHeight(20)
      blueTooltip.titleBar.closeButton:RemoveAllAnchors()
      blueTooltip.titleBar.closeButton:AddAnchor("TOPRIGHT", blueTooltip.titleBar, -4, 4)
      ApplyButtonSkin(blueTooltip.titleBar.closeButton, BUTTON_BASIC.WINDOW_SMALL_CLOSE)
    else
      blueTooltip.titleBar:Show(false)
      blueTooltip:EnablePick(false)
    end
  else
    blueTooltip = CreateEmptyWindow("tooltip." .. id, "UIParent")
    blueTooltip:SetUILayer("tooltip")
    blueTooltip:EnablePick(false)
  end
  if kind == TOOLTIP_KIND.ITEM_LINK and compareType == nil then
    function blueTooltip:HideCompareTooltip()
      local group = tooltipGroups[TOOLTIP_KIND.ITEM_LINK]
      for i = 1, #group do
        if tooltip.tooltipWindows[group[i]] ~= nil and tooltip.tooltipWindows[group[i]].compareType == ITEM_LINK_COMPARE then
          tooltip.tooltipWindows[group[i]]:ShowTooltip(false)
        end
      end
    end
    function blueTooltip:OnHide()
      self:HideCompareTooltip()
    end
    blueTooltip:SetHandler("OnHide", blueTooltip.OnHide)
  end
  blueTooltip.compareType = compareType
  blueTooltip:Show(false)
  blueTooltip:SetExtent(260, 100)
  blueTooltip:AddAnchor("CENTER", "UIParent", 0, 0)
  CreateTooltipDrawable(blueTooltip)
  blueTooltip.delayTime = BLUE_TOOLTIP_DEFAULT_DELAY_TIME
  blueTooltip.fadeTime = 50
  blueTooltip.currentSections = {}
  blueTooltip.minWindowWidth = 250
  function blueTooltip:ClearSection()
    if self.currentSections == nil then
      return
    end
    for i = 1, #self.currentSections do
      self.currentSections[i]:Show(false)
    end
    self.currentSections = nil
  end
  function blueTooltip:OnShow()
    self:ResetSetctions()
  end
  blueTooltip:SetHandler("OnShow", blueTooltip.OnShow)
  function blueTooltip:GetTotalSectionHeight()
    if self.currentSections == nil then
      return
    end
    local totalHeight = 1
    for i = 1, #self.currentSections do
      local section = self.currentSections[i]
      local emptySection = false
      local height = section:GetHeight()
      totalHeight = totalHeight + height + section.anchorY
    end
    return totalHeight
  end
  function blueTooltip:ResetSetctions()
    if self.currentSections == nil then
      return
    end
    local firstSection = false
    for i = 1, #self.currentSections do
      local section = self.currentSections[i]
      local emptySection = false
      local height = section:GetHeight()
      if height == 0 then
        section:Show(false)
        emptySection = true
      end
      section.upLine:SetVisible(false)
      section:Show(false)
      if not emptySection then
        if firstSection == false then
          firstSection = true
          section:AddAnchor("TOPLEFT", self, 17, 17)
          section.anchorY = 17
          section.upLine:SetVisible(false)
        else
          section:AddAnchor("TOPLEFT", self.currentSections[#self.currentSections - 1], "BOTTOMLEFT", 0, 10)
          section.upLine:SetVisible(section.useSeparate)
          section.anchorY = 10
        end
        section:Show(true)
      end
    end
  end
  function blueTooltip:PushSection(section)
    if section == nil or section.SetInfo == nil then
      return
    end
    if self.currentSections == nil then
      self.currentSections = {}
    end
    self.currentSections[#self.currentSections + 1] = section
    if #self.currentSections == 1 then
      self:BindWidth(self.minWindowWidth)
      section:AddAnchor("TOPLEFT", self, 17, 17, false)
      section.anchorY = 17
      section:SetSectionWidth(self.minWindowWidth - 34)
      section.upLine:SetVisible(false)
    else
      section:AddAnchor("TOPLEFT", self.currentSections[#self.currentSections - 1], "BOTTOMLEFT", 0, 10, false)
      section.anchorY = 10
      section:SetSectionWidth(self.currentSections[#self.currentSections - 1]:GetWidth())
      section.upLine:SetVisible(true)
    end
    section:Show(true)
  end
  function blueTooltip:SetInfo(tipInfo, equiped)
    if self.currentSections == nil then
      return
    end
    self:ApplyUIScale(true)
    self:SetScale(UIParent:GetUIScale())
    self.tooltipItemAndSkill:ClearLines()
    for i = 1, #self.currentSections do
      if self.currentSections[i].SetInfo ~= nil then
        self.currentSections[i]:SetInfo(self.tooltipItemAndSkill, tipInfo, equiped)
      end
    end
    local count = #self.currentSections
    local _, baseY = self:GetOffset()
    local _, y = self.currentSections[1]:GetOffset()
    local _, cy = self.currentSections[count]:GetOffset()
    local _, height = self.currentSections[count]:GetExtent()
    local windowHeight = cy + height - y + (y - baseY) * 2
    self.adjustUIScale = UIParent:GetUIScale()
    while windowHeight * self.adjustUIScale > UIParent:GetScreenHeight() do
      self.adjustUIScale = F_LAYOUT.GetUIScaleValueByOptionWindowValue(F_LAYOUT.GetUIScaleValueByRealValue(self.adjustUIScale) - UI_SCALE_STEP_OFFSET)
    end
    if self.adjustUIScale ~= UIParent:GetUIScale() then
      local temp = 100 - F_LAYOUT.GetUIScaleValueByRealValue(self.adjustUIScale)
      local percent = (100 + temp) / 100
      self.minWindowWidth = self.minWindowWidth * percent
      self:SetScale(self.adjustUIScale)
      self:BindWidth(self.minWindowWidth)
      self.tooltipItemAndSkill:ClearLines()
      for i = 1, #self.currentSections do
        if self.currentSections[i].SetInfo ~= nil then
          self.currentSections[i]:SetInfo(self.tooltipItemAndSkill, tipInfo, equiped)
          self.currentSections[i]:SetSectionWidth(self.minWindowWidth - 34)
        end
      end
    end
    self:ApplyUIScale(false)
  end
  function blueTooltip:GetSize()
    local windowHeight = 5
    local windowWidth = self.minWindowWidth
    for i = 1, #self.currentSections do
      windowHeight = windowHeight + self.currentSections[i]:GetHeight() + self.currentSections[i].anchorY
      if windowWidth < self.currentSections[i]:GetWidth() then
        windowWidth = self.currentSections[i]:GetWidth()
      end
    end
    return windowWidth, windowHeight
  end
  local LeftRightlocationToAnchorSet = {
    {
      "LEFT",
      "RIGHT",
      10,
      "LEFT"
    },
    {
      "RIGHT",
      "LEFT",
      -10,
      "RIGHT"
    },
    {
      "LEFT",
      "LEFT",
      10,
      "LEFT"
    },
    {
      "RIGHT",
      "RIGHT",
      -10,
      "RIGHT"
    }
  }
  local TryLeftRightLocateTooltip = function(location, stickFrom, stickTo, windowWidth, adjustUIScale)
    local screenWidth = UIParent:GetScreenWidth()
    local tX, _ = stickTo:GetEffectiveOffset()
    local tWidth, _ = stickTo:GetEffectiveExtent()
    local fWidth, _ = stickFrom:GetEffectiveExtent()
    local emptyWidth
    if location == 1 then
      emptyWidth = tX
    elseif location == 2 then
      emptyWidth = screenWidth - (tX + tWidth)
    elseif location == 3 then
      emptyWidth = tX + fWidth
    elseif location == 4 then
      return true
    else
      return false
    end
    if windowWidth > F_LAYOUT.CalcDontApplyUIScale(emptyWidth, adjustUIScale) then
      return false
    end
    return true
  end
  local defaultTooltipAnchor = 10
  local TopBottomlocationToAnchorSet = {
    {
      "BOTTOM",
      "TOP",
      -defaultTooltipAnchor,
      "TOP"
    },
    {
      "TOP",
      "BOTTOM",
      defaultTooltipAnchor,
      "TOP"
    }
  }
  local function TryTopBottomLocateTooltip(location, stickFrom, stickTo, windowHeight, adjustUIScale)
    local screenHeight = UIParent:GetScreenHeight()
    local _, tY = stickTo:GetEffectiveOffset()
    local _, tHeight = stickTo:GetEffectiveExtent()
    local _, fHeight = stickFrom:GetEffectiveExtent()
    local emptyHeight
    if location == 1 then
      emptyHeight = screenHeight - (tY + tHeight)
    elseif location == 2 then
      emptyHeight = tY
    else
      return defaultTooltipAnchor
    end
    if windowHeight > F_LAYOUT.CalcDontApplyUIScale(emptyHeight, adjustUIScale) then
      if location == 2 then
        return F_LAYOUT.CalcDontApplyUIScale(fHeight - tY, adjustUIScale)
      else
        return 0
      end
    end
    if location == 1 then
      return -defaultTooltipAnchor
    end
    return defaultTooltipAnchor
  end
  function blueTooltip:MakeAnchorText(stickTo, windowWidth, windowHeight)
    local leftOrRight = 1
    for i = 1, #LeftRightlocationToAnchorSet do
      if TryLeftRightLocateTooltip(i, self, stickTo, windowWidth, self.adjustUIScale) then
        leftOrRight = i
        break
      end
    end
    local topOrBottom = 1
    local topBottomAnchor = defaultTooltipAnchor
    for i = 1, #TopBottomlocationToAnchorSet do
      topBottomAnchor = TryTopBottomLocateTooltip(i, self, stickTo, windowHeight, self.adjustUIScale)
      if topBottomAnchor ~= 0 then
        topOrBottom = i
        break
      end
    end
    local arrV = TopBottomlocationToAnchorSet[topOrBottom][1]
    local arrH = LeftRightlocationToAnchorSet[leftOrRight][1]
    local srrV = TopBottomlocationToAnchorSet[topOrBottom][2]
    local srrH = LeftRightlocationToAnchorSet[leftOrRight][2]
    local insetY = topBottomAnchor
    local insetX = LeftRightlocationToAnchorSet[leftOrRight][3]
    local stickMeV = TopBottomlocationToAnchorSet[topOrBottom][4]
    local stickMeH = LeftRightlocationToAnchorSet[leftOrRight][4]
    if stickType == FIRST_COMPARE then
      arrV = ""
      srrV = ""
      stickMeV, stickMeH = nil, nil
    elseif stickType == SECOND_COMPARE then
      arrH = ""
      srrH = ""
      stickMeV, stickMeH = nil, nil
    end
    local ach = arrV .. arrH
    local sch = srrV .. srrH
    self.stickMeV = stickMeV
    self.stickMeH = stickMeH
    return sch, ach, insetX, insetY
  end
  function blueTooltip:MakeAnchorCombinedTipText(stickTo, combinedExtent)
    local windowWidth, windowHeight = combinedExtent.width, combinedExtent.height
    return self:MakeAnchorText(stickTo, windowWidth, windowHeight)
  end
  function blueTooltip:MakeAnchorTextSingle(stickTo)
    local windowWidth, windowHeight = self:GetSize()
    return self:MakeAnchorText(stickTo, windowWidth, windowHeight)
  end
  function blueTooltip:SetDelayTime(ms)
    self.delayTime = ms
  end
  function blueTooltip:SetFadeingTime(ms)
    self.fadeTime = ms
  end
  function blueTooltip:ShowTooltip(wantShow, stickTo, stickType, combinedExtent)
    if wantShow == false then
      self.delayTime = BLUE_TOOLTIP_DEFAULT_DELAY_TIME
      self:Show(false)
      self.tooltipItemAndSkill:ClearLines()
      return
    end
    self.needShow = true
    self.delayDurationTime = self.delayTime
    self.fadeDurationTime = self.fadeTime
    self.delayDone = false
    self.fadeDone = false
    self:Show(true)
    local windowWidth = self.minWindowWidth
    for i = 1, #self.currentSections do
      if windowWidth < self.currentSections[i]:GetWidth() then
        windowWidth = self.currentSections[i]:GetWidth()
      end
    end
    local count = #self.currentSections
    local _, baseY = self:GetOffset()
    local _, y = self.currentSections[1]:GetOffset()
    local _, cy = self.currentSections[count]:GetOffset()
    local _, height = self.currentSections[count]:GetExtent()
    local windowHeight = cy + height - y + (y - baseY) + (y - baseY)
    self:SetExtent(self.minWindowWidth, windowHeight)
    if stickTo == nil then
      return
    end
    local posX, posY = UIParent:GetCursorPosition()
    local screenWidth = UIParent:GetScreenWidth()
    local screenHeight = UIParent:GetScreenHeight()
    local myAnchor, targetAnchor
    local insetX, insetY = 0, 0
    stickType = stickType or ONLY_BASE
    if stickType == FIRST_COMPARE then
      local stickMeV = stickTo.stickMeV
      local stickMeH = stickTo.stickMeH
      if stickMeV == nil then
        stickMeV = "TOP"
      end
      if stickMeH == nil then
        stickMeH = "LEFT"
      end
      targetAnchor = stickMeV .. stickMeH
      if stickMeH == "LEFT" then
        myAnchor = stickMeV .. "RIGHT"
      else
        myAnchor = stickMeV .. "LEFT"
      end
      self.stickMeV = stickMeV
      self.stickMeH = stickMeH
    elseif stickType == SECOND_COMPARE then
      targetAnchor = stickTo.stickMeV .. stickTo.stickMeH
      if stickTo.stickMeH == "LEFT" then
        myAnchor = stickTo.stickMeV .. "RIGHT"
      else
        myAnchor = stickTo.stickMeV .. "LEFT"
      end
    elseif stickType == BASE_NO_ANCHOR_OFFSET then
      if posY > screenHeight / 2 then
        myAnchor = "BOTTOM"
        targetAnchor = "TOP"
      else
        myAnchor = "TOP"
        targetAnchor = "BOTTOM"
      end
      if posX > screenWidth / 2 then
        myAnchor = myAnchor .. "RIGHT"
        targetAnchor = targetAnchor .. "RIGHT"
      else
        myAnchor = myAnchor .. "LEFT"
        targetAnchor = targetAnchor .. "LEFT"
      end
    elseif stickType == BASE_WITH_COMPARE_EXTENT and combinedExtent ~= nil then
      myAnchor, targetAnchor, insetX, insetY = self:MakeAnchorCombinedTipText(stickTo, combinedExtent)
    else
      myAnchor, targetAnchor, insetX, insetY = self:MakeAnchorTextSingle(stickTo)
    end
    self:RemoveAllAnchors()
    if stickTo == nil then
      self:AddAnchor("LEFT", "UIParent", 0, 0)
    else
      self:AddAnchor(myAnchor, stickTo, targetAnchor, insetX, insetY)
    end
    self:Raise()
  end
  function blueTooltip:OnUpdate(dt)
    if self.delayDurationTime == nil then
      return
    end
    if self.needShow == true then
      self:SetAlpha(0)
    end
    self.delayDurationTime = self.delayDurationTime - dt
    if self.delayDurationTime < 0 then
      self.delayDurationTime = 0
    end
    if self.delayDurationTime <= 0 and self.needShow then
      self.delayDone = true
      self.needShow = false
    end
    if self.delayDone ~= true then
      return
    end
    self.fadeDurationTime = self.fadeDurationTime - dt
    if 0 > self.fadeDurationTime then
      self.fadeDurationTime = 0
      self.fadeDone = true
    end
    local progress = self.fadeTime - self.fadeDurationTime
    self:SetAlpha(progress / self.fadeTime)
    if self.tipType ~= nil and X2Unit:GetUnitId("player") ~= nil then
      local buffInfo, skillInfo
      if self.tipType == "buff" then
        if self.bufTarget.target ~= nil and self.bufTarget.index ~= nil then
          buffInfo = X2Unit:UnitBuffTooltip(self.bufTarget.target, self.bufTarget.index, BIK_RUNTIME_TIMELEFT)
        end
      elseif self.tipType == "debuff" then
        if self.bufTarget.target ~= nil and self.bufTarget.index ~= nil then
          buffInfo = X2Unit:UnitDeBuffTooltip(self.bufTarget.target, self.bufTarget.index, BIK_RUNTIME_TIMELEFT)
        end
      elseif self.tipType == "skill" and self.skillInfo ~= nil then
        skillInfo = X2Skill:GetSkillTooltip(self.skillInfo.type, 0, SIK_DESCRIPTION)
      end
      if buffInfo ~= nil then
        self.buffInfo.timeLeft = buffInfo.timeLeft
        self.buffInfo.timeUnit = buffInfo.timeUnit
        self:SetInfo(self.buffInfo)
      end
      if skillInfo ~= nil then
        self.skillInfo.description = skillInfo.description
        self:SetInfo(self.skillInfo)
      end
    end
  end
  blueTooltip:SetHandler("OnUpdate", blueTooltip.OnUpdate)
  return blueTooltip
end
function ChangeTooltipTexture(widget, kind)
  if kind == nil then
    kind = "origin" or kind
  end
  if kind == "origin" then
    widget.bg:SetCoords(733, 185, 14, 15)
  elseif kind == "compare" then
    widget.bg:SetCoords(733, 169, 14, 15)
  elseif kind == "linked" then
    widget.bg:SetTextureInfo("tooltip_bg_blue")
  end
end
function DefaultTooltipSetting(widget)
  ApplyTextColor(widget, FONT_COLOR.SOFT_BROWN)
  widget:SetInset(10, 10, 10, 10)
  widget.style:SetSnap(true)
end
tooltip = {}
tooltip.skilNameColor = {}
tooltip.skilNameColor.general = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.fight = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.illusion = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.adamant = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.will = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.death = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.wild = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.magic = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.vocation = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.romance = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.love = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.hatred = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.predator = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.trooper = FONT_COLOR_HEX.WHITE
tooltip.skilNameColor.assassin = FONT_COLOR_HEX.WHITE
tooltip.abilityColor = {}
tooltip.abilityColor.general = "|cFFFF9C27"
tooltip.abilityColor.fight = "|cFFFF9C27"
tooltip.abilityColor.illusion = "|cFFFF9C27"
tooltip.abilityColor.adamant = "|cFFFF9C27"
tooltip.abilityColor.will = "|cFFFF9C27"
tooltip.abilityColor.death = "|cFFFF9C27"
tooltip.abilityColor.wild = "|cFFFF9C27"
tooltip.abilityColor.magic = "|cFFFF9C27"
tooltip.abilityColor.vocation = "|cFFFF9C27"
tooltip.abilityColor.romance = "|cFFFF9C27"
tooltip.abilityColor.love = "|cFFFF9C27"
tooltip.abilityColor.hatred = "|cFFFF9C27"
tooltip.abilityColor.predator = "|cFFFF9C27"
tooltip.abilityColor.trooper = "|cFFFF9C27"
tooltip.abilityColor.assassin = "|cFFFF9C27"
tooltip.rootWnd = CreateEmptyWindow("tooltipRootWnd", "UIParent")
tooltip.rootWnd:EnablePick(false)
tooltip.rootWnd:SetExtent(5, 5)
tooltip.rootWnd:AddAnchor("TOPLEFT", "UIParent", -100, 0)
tooltip.rootWnd:SetUILayer("tooltip")
ADDON:RegisterContentWidget(UIC_GAME_TOOLTIP_WND, tooltip.rootWnd)
tooltip.rootWnd:Show(true)
tooltip.window = tooltip.rootWnd:CreateChildWidget("gametooltip", "tooltip.window", 0, true)
tooltip.window:EnablePick(false)
tooltip.window:SetExtent(250, 20)
tooltip.window:AddAnchor("TOPLEFT", "UIParent", 100, 100)
tooltip.window:Show(false)
tooltip.window.style:SetAlign(ALIGN_CENTER)
DefaultTooltipSetting(tooltip.window)
CreateTooltipDrawable(tooltip.window)
tooltip.num = 9
tooltip.tooltipWindows = {}
tooltip.itemTitles = {}
tooltip.securityState = {}
tooltip.userMusicInfos = {}
tooltip.treasureInfos = {}
tooltip.locationInfos = {}
tooltip.itemLookState = {}
tooltip.itemTimeInfos = {}
tooltip.itemEvolvingExpInfos = {}
tooltip.itemInfos = {}
tooltip.specialty = {}
tooltip.attrInfos = {}
tooltip.itemSocketInfos = {}
tooltip.gearScore = {}
tooltip.itemInfosEx = {}
tooltip.descriptions = {}
tooltip.effectDescriptions = {}
tooltip.setItemsInfo = {}
tooltip.etcItemsInfo = {}
tooltip.crafterInfo = {}
tooltip.sellables = {}
tooltip.options = {}
tooltip.portalInfos = {}
tooltip.crimeInfo = {}
tooltip.mountInfo = {}
tooltip.uccViewer = {}
tooltip.skillTitles = {}
tooltip.skillSimpleInfo = {}
tooltip.skillTimeInfo = {}
tooltip.skillEffectInfo = {}
tooltip.skillDescs = {}
tooltip.skillSynergyInfos = {}
tooltip.skillBodys = {}
tooltip.buffInfos = {}
tooltip.questBody = {}
tooltip.craftOrderInfo = {}
local CreateSynergyIcons = function(parent, isLeftAnchor)
  local synergyIcon1 = parent:CreateIconImageDrawable(EMPTY_SLOT_PATH, "artwork")
  synergyIcon1:SetMask("ui/common/slot_over.dds")
  synergyIcon1:SetMaskCoords(0, 0, 40, 40)
  if isLeftAnchor then
    synergyIcon1:AddAnchor("TOPLEFT", parent, 0, 0)
  else
    synergyIcon1:AddAnchor("TOPRIGHT", parent, 0, 0)
  end
  synergyIcon1:SetExtent(30, 30)
  synergyIcon1:SetCoords(0, 0, 48, 48)
  synergyIcon1:SetColor(1, 1, 1, 1)
  parent.synergyIcon1 = synergyIcon1
  local bg = parent:CreateDrawable(TEXTURE_PATH.HUD, "buff_back", "background")
  bg:AddAnchor("TOPLEFT", synergyIcon1, -2, -2)
  bg:AddAnchor("BOTTOMRIGHT", synergyIcon1, 2, 2)
  synergyIcon1.bg = bg
  local deco = parent:CreateDrawable(TEXTURE_PATH.HUD, "debuff_deco", "overlay")
  deco:AddAnchor("TOP", synergyIcon1, 0, -2)
  synergyIcon1.deco = deco
  local synergyIcon2 = parent:CreateIconImageDrawable(EMPTY_SLOT_PATH, "artwork")
  synergyIcon2:SetMask("ui/common/slot_over.dds")
  synergyIcon2:SetMaskCoords(0, 0, 40, 40)
  synergyIcon2:AddAnchor("TOPRIGHT", synergyIcon1, "TOPLEFT", 0, 0)
  synergyIcon2:SetExtent(30, 30)
  synergyIcon2:SetCoords(0, 0, 48, 48)
  synergyIcon2:SetColor(1, 1, 1, 1)
  parent.synergyIcon2 = synergyIcon2
  local bg = parent:CreateDrawable(TEXTURE_PATH.HUD, "buff_back", "background")
  bg:AddAnchor("TOPLEFT", synergyIcon2, -2, -2)
  bg:AddAnchor("BOTTOMRIGHT", synergyIcon2, 2, 2)
  synergyIcon2.bg = bg
  local deco = parent:CreateDrawable(TEXTURE_PATH.HUD, "debuff_deco", "overlay")
  deco:AddAnchor("TOP", synergyIcon2, 0, -2)
  synergyIcon2.deco = deco
end
local function MakeTooltip(i, kind, compareType)
  tooltip.tooltipWindows[i] = CreateBlueTooltip("tooltipWindows[" .. i .. "]", kind, compareType)
  tooltip.tooltipWindows[i].tooltipItemAndSkill = tooltip.tooltipWindows[i]:CreateChildWidget("gametooltip", "tooltipItemAndSkill", 0, true)
  tooltip.tooltipWindows[i].tooltipItemAndSkill:Show(true)
  tooltip.tooltipWindows[i].tooltipItemAndSkill:AddAnchor("TOPLEFT", tooltip.tooltipWindows[i], 10, 10)
  tooltip.tooltipWindows[i].tooltipItemAndSkill:AddAnchor("TOPRIGHT", tooltip.tooltipWindows[i], -10, 10)
  tooltip.tooltipWindows[i].tooltipItemAndSkill:SetAutoWordwrap(true)
  DefaultTooltipSetting(tooltip.tooltipWindows[i].tooltipItemAndSkill)
  tooltip.tooltipWindows[i].tooltipItemAndSkill.style:SetSnap(true)
  if kind == TOOLTIP_KIND.ITEM or kind == TOOLTIP_KIND.ITEM_LINK or kind == TOOLTIP_KIND.BUFF then
    tooltip.itemTitles[i] = CreateSection("itemTitles[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.itemInfosEx[i] = CreateSection("itemInfosEx[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.specialty[i] = CreateSection("specialty[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.itemInfos[i] = CreateSection("itemInfos[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.descriptions[i] = CreateSection("descriptions[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.effectDescriptions[i] = CreateSection("effectDescriptions[" .. i .. "]", tooltip.tooltipWindows[i])
    local iconFrame = tooltip.itemTitles[i]:CreateChildWidget("emptywidget", "iconFrame", 0, true)
    iconFrame:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    iconFrame:AddAnchor("TOPLEFT", tooltip.itemTitles[i], 0, 0)
    local slotBackground = iconFrame:CreateDrawable(TEXTURE_PATH.HUD, "slot_bg", "background")
    slotBackground:AddAnchor("TOPLEFT", iconFrame, 0, 0)
    slotBackground:AddAnchor("BOTTOMRIGHT", iconFrame, 0, 0)
    local icon = iconFrame:CreateIconImageDrawable(EMPTY_SLOT_PATH, "artwork")
    icon:AddAnchor("TOPLEFT", iconFrame, 1, 1)
    icon:AddAnchor("BOTTOMRIGHT", iconFrame, -1, -1)
    iconFrame.icon = icon
    if kind == TOOLTIP_KIND.BUFF then
      tooltip.buffInfos[i] = CreateSection("buffInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.skillBodys[i] = CreateSection("skillBodys[" .. i .. "]", tooltip.tooltipWindows[i])
    else
      local anchor = tooltipLocale.equipIcon.anchor
      local offset = tooltipLocale.equipIcon.offset
      local equipIcon = iconFrame:CreateDrawable(TEXTURE_PATH.TOOLTIP, "equip", "overlay")
      equipIcon:AddAnchor(anchor, iconFrame, offset[1], offset[2])
      iconFrame.equipIcon = equipIcon
      W_ICON.CreatePackIcon(iconFrame)
      W_ICON.CreateDyeingIcon(iconFrame)
      local blackImage = iconFrame:CreateColorDrawable(0, 0, 0, 0.5, "overlay")
      blackImage:SetVisible(false)
      blackImage:SetExtent(ICON_SIZE.DEFAULT - 2, ICON_SIZE.DEFAULT - 2)
      blackImage:AddAnchor("CENTER", icon, 0, 0)
      iconFrame.blackImage = blackImage
      W_ICON.CreateDisableEnchantItemIcon(iconFrame, "artwork")
      W_ICON.CreateLockIcon(iconFrame)
      W_ICON.CreateLookIcon(iconFrame, "artwork")
      W_ICON.CreateLifeTimeIcon(iconFrame, "artwork")
      W_ICON.CreateOpenPaperItemIcon(iconFrame, "artwork")
      if baselibLocale.itemSideEffect == true then
        W_ICON.DrawItemSideEffectBackground(iconFrame)
      end
      tooltip.itemTimeInfos[i] = CreateSection("itemTimeInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.itemLookState[i] = CreateSection("itemLookState[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.securityState[i] = CreateSection("securityState[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.userMusicInfos[i] = CreateSection("userMusicInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.treasureInfos[i] = CreateSection("treasureInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.locationInfos[i] = CreateSection("locationInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.itemEvolvingExpInfos[i] = CreateSection("itemEvolvingExpInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.attrInfos[i] = CreateSection("attrInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.itemSocketInfos[i] = CreateSection("itemSocketInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.itemSocketInfos[i].socket = {}
      for index = 1, MAX_ITEM_SOCKETS do
        local btn = CreateItemIconButton("socket[" .. index .. "]", tooltip.itemSocketInfos[i])
        btn:Show(false)
        btn:SetExtent(ICON_SIZE.SOCKET, ICON_SIZE.SOCKET)
        local target = index == 1 and tooltip.itemSocketInfos[i] or tooltip.itemSocketInfos[i].socket[index - 1]
        btn:AddAnchor("TOPLEFT", target, "BOTTOMLEFT", 0, 1)
        F_SLOT.ApplySlotSkin(btn, btn.back, SLOT_STYLE.SOCKET)
        tooltip.itemSocketInfos[i].socket[index] = btn
      end
      tooltip.gearScore[i] = CreateSection("gearScore[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.setItemsInfo[i] = CreateSection("setItemsInfo[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.setItemsInfo[i].setItem = {}
      for index = 1, MAX_SET_ITEMS do
        local btn = CreateItemIconButton("setItem[" .. index .. "]", tooltip.setItemsInfo[i])
        btn:Show(false)
        btn:SetExtent(ICON_SIZE.SET_ITEM, ICON_SIZE.SET_ITEM)
        F_SLOT.ApplySlotSkin(btn, btn.back, SLOT_STYLE.SOCKET)
        if index == 1 then
          btn:AddAnchor("TOPLEFT", tooltip.setItemsInfo[i], 0, 0)
        elseif index == MAX_SET_ITEMS / 2 + 1 then
          btn:AddAnchor("TOPLEFT", tooltip.setItemsInfo[i].setItem[1], "BOTTOMLEFT", 0, 3)
        else
          btn:AddAnchor("LEFT", tooltip.setItemsInfo[i].setItem[index - 1], "RIGHT", 3, 0)
        end
        tooltip.setItemsInfo[i].setItem[index] = btn
        local itemBg = btn:CreateDrawable(TEXTURE_PATH.TOOLTIP, "icon_frame", "overlay")
        itemBg:SetVisible(false)
        itemBg:AddAnchor("TOPLEFT", btn, 0, 0)
        itemBg:AddAnchor("BOTTOMRIGHT", btn, 0, 0)
        btn.itemBg = itemBg
      end
      tooltip.etcItemsInfo[i] = CreateSection("etcItemsInfo[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.options[i] = CreateSection("options[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.portalInfos[i] = CreateSection("portalInfos[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.crimeInfo[i] = CreateSection("crimeInfo[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.crafterInfo[i] = CreateSection("crafterInfo[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.sellables[i] = CreateSection("sellables[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.sellables[i].kindImg = tooltip.sellables[i]:CreateDrawable(TEXTURE_PATH.TOOLTIP, "auction", "background")
      tooltip.sellables[i].kindImg:AddAnchor("LEFT", tooltip.sellables[i], 0, 5)
      tooltip.sellables[i].kindImg:Show(false)
      tooltip.mountInfo[i] = CreateSection("mountInfo[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.craftOrderInfo[i] = CreateSection("craftOrderInfo[" .. i .. "]", tooltip.tooltipWindows[i])
      local uccWidth = 215
      local drawableAnchorOffset = 9
      tooltip.uccViewer[i] = CreateSection("uccViewer[" .. i .. "]", tooltip.tooltipWindows[i])
      tooltip.uccViewer[i].uccWidth = uccWidth
      local group = tooltip.uccViewer[i]:CreateChildWidget("emptywidget", "group", 0, true)
      group:AddAnchor("TOP", tooltip.uccViewer[i], "TOP", 0, 0)
      group:SetExtent(uccWidth, uccWidth + FONT_SIZE.MIDDLE + drawableAnchorOffset)
      local title = group:CreateChildWidget("label", "title", 0, true)
      title.style:SetAlign(ALIGN_LEFT)
      title.style:SetFontSize(FONT_SIZE.MIDDLE)
      ApplyTextColor(title, FONT_COLOR.SOFT_BROWN)
      title:SetExtent(uccWidth, FONT_SIZE.MIDDLE)
      title:AddAnchor("TOPLEFT", group, "TOPLEFT", 0, 0)
      title:SetText(GetUIText(STORE_TEXT, "preview"))
      group.uccBack = group:CreateImageDrawable(INVALID_ICON_PATH, "background")
      group.uccBack:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, drawableAnchorOffset)
      group.uccBack:SetExtent(uccWidth, uccWidth)
      group.uccFront = group:CreateImageDrawable(INVALID_ICON_PATH, "overlay")
      group.uccFront:AddAnchor("CENTER", group.uccBack, 0, 0)
      group.uccFront:SetExtent(uccWidth / 2, uccWidth / 2)
      group:Show(false)
      tooltip.uccViewer[i]:SetHeight(group:GetHeight())
    end
  elseif kind == TOOLTIP_KIND.SKILL then
    tooltip.skillTitles[i] = CreateSection("skillTitles[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.skillTitles[i]:SetHeight(15)
    local slotBackground = tooltip.skillTitles[i]:CreateDrawable(TEXTURE_PATH.HUD, "slot_bg", "background")
    slotBackground:AddAnchor("TOPLEFT", tooltip.skillTitles[i], "TOPLEFT", 0, 0)
    slotBackground:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    tooltip.skillTitles[i].slotBackground = slotBackground
    local icon = tooltip.skillTitles[i]:CreateIconImageDrawable(EMPTY_SLOT_PATH, "artwork")
    icon:AddAnchor("TOPLEFT", slotBackground, 1, 1)
    icon:AddAnchor("BOTTOMRIGHT", slotBackground, -1, -1)
    tooltip.skillTitles[i].icon = icon
    tooltip.skillSimpleInfo[i] = CreateSection("skillSimpleInfo[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.skillSimpleInfo[i]:SetHeight(80)
    if not tooltipLocale.forclyUseLeftSection then
      CreateSynergyIcons(tooltip.skillSimpleInfo[i], false)
    end
    tooltip.skillTimeInfo[i] = CreateSection("skillTimeInfo[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.skillTimeInfo[i]:SetHeight(80)
    tooltip.skillEffectInfo[i] = CreateSection("skillEffectInfo[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.skillEffectInfo[i]:SetHeight(80)
    if tooltipLocale.forclyUseLeftSection then
      CreateSynergyIcons(tooltip.skillEffectInfo[i], true)
    end
    tooltip.skillDescs[i] = CreateSection("skillDescs[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.skillDescs[i]:SetHeight(80)
    tooltip.skillSynergyInfos[i] = {}
    tooltip.skillBodys[i] = CreateSection("skillBodys[" .. i .. "]", tooltip.tooltipWindows[i])
    tooltip.skillBodys[i]:SetHeight(35)
  elseif kind == TOOLTIP_KIND.QUEST_LINK then
    tooltip.questBody[i] = CreateSection("questBody[" .. i .. "]", tooltip.tooltipWindows[i])
  end
end
TOOLTIP_KIND = {
  ITEM = "item",
  ITEM_LINK = "itemlink",
  SKILL = "skill",
  BUFF = "buff",
  QUEST_LINK = "questlink"
}
tooltipGroups = {}
MakeTooltip(1, TOOLTIP_KIND.ITEM, nil)
MakeTooltip(2, TOOLTIP_KIND.ITEM, ITEM_COMPARE)
MakeTooltip(3, TOOLTIP_KIND.ITEM, ITEM_COMPARE)
tooltipGroups[TOOLTIP_KIND.ITEM] = {
  1,
  2,
  3
}
MakeTooltip(4, TOOLTIP_KIND.ITEM_LINK, nil)
tooltip.tooltipWindows[4]:RemoveAllAnchors()
tooltip.tooltipWindows[4]:AddAnchor("BOTTOM", "UIParent", 0, -110)
tooltip.tooltipWindows[4].titleBar:Raise()
MakeTooltip(9, TOOLTIP_KIND.ITEM_LINK, ITEM_LINK_COMPARE)
tooltipGroups[TOOLTIP_KIND.ITEM_LINK] = {4, 9}
MakeTooltip(8, TOOLTIP_KIND.QUEST_LINK, nil)
tooltip.tooltipWindows[8]:RemoveAllAnchors()
tooltip.tooltipWindows[8]:AddAnchor("BOTTOM", "UIParent", 0, -110)
tooltip.tooltipWindows[8].titleBar:Raise()
tooltipGroups[TOOLTIP_KIND.QUEST_LINK] = {8}
MakeTooltip(5, TOOLTIP_KIND.SKILL, nil)
MakeTooltip(6, TOOLTIP_KIND.SKILL, SKILL_COMPARE)
tooltipGroups[TOOLTIP_KIND.SKILL] = {5, 6}
MakeTooltip(7, TOOLTIP_KIND.BUFF, nil)
tooltipGroups[TOOLTIP_KIND.BUFF] = {7}
fixedTooltip = UIParent:CreateWidget("gametooltip", "fixedTooltip", "UIParent")
fixedTooltip:AddAnchor("TOPLEFT", "UIParent", 100, 100)
fixedTooltip:SetExtent(250, 20)
fixedTooltip:EnablePick(false)
fixedTooltip.style:SetAlign(ALIGN_CENTER)
DefaultTooltipSetting(fixedTooltip)
CreateTooltipDrawable(fixedTooltip)
function ColorFromDoodad()
  return FONT_COLOR_HEX.DOODAD
end
function ColorFromFactionAndSocial_Npc(faction, social)
  if faction == "hostile" then
    return FONT_COLOR_HEX.RED
  else
    return FONT_COLOR_HEX.FACTION_FRIENDLY_NPC
  end
end
function ColorFromFactionAndSocial_Pc(faction, social)
  if faction == "hostile" then
    return FONT_COLOR_HEX.RED
  elseif social == "party" then
    return FONT_COLOR_HEX.FACTION_PARTY
  elseif social == "raid" then
    return FONT_COLOR_HEX.FACTION_RAID
  else
    return FONT_COLOR_HEX.FACTION_FRIENDLY_PC
  end
end
function ColorFromFaction(faction)
  if faction == "hostile" then
    return FONT_COLOR_HEX.RED
  else
    return FONT_COLOR_HEX.FACTION_TEAM
  end
end
summaryTooltip = UIParent:CreateWidget("gametooltip", "summaryTooltip", "UIParent")
summaryTooltip:SetExtent(200, 10)
summaryTooltip:SetAutoWordwrap(true)
summaryTooltip:AddAnchor("TOPLEFT", "UIParent", 100, 100)
summaryTooltip.style:SetAlign(ALIGN_TOP_LEFT)
DefaultTooltipSetting(summaryTooltip)
CreateTooltipDrawable(summaryTooltip)
hotKeyOverrideTooltip = {}
hotKeyOverrideTooltip.width = 200
hotKeyOverrideTooltip.anchorOffsetRight = {-3, 0}
hotKeyOverrideTooltip.anchorOffsetLeft = {-3, 0}
hotKeyOverrideTooltip.window = CreateBlueTooltip("hotKeyOverrideTooltip.window", nil, nil)
hotKeyOverrideTooltip.window:SetExtent(hotKeyOverrideTooltip.width, 20)
hotKeyOverrideTooltip.window:SetUILayer("tooltip")
hotKeyOverrideTooltip.window:EnablePick(false)
hotKeyOverrideTooltip.window:Show(false)
hotKeyOverrideTooltip.text = UIParent:CreateWidget("gametooltip", "hotKeyOverrideTooltip.text", hotKeyOverrideTooltip.window)
hotKeyOverrideTooltip.text:Show(true)
hotKeyOverrideTooltip.text:SetAutoWordwrap(true)
hotKeyOverrideTooltip.text:AddAnchor("TOPLEFT", hotKeyOverrideTooltip.window, 11, 5)
hotKeyOverrideTooltip.text:AddAnchor("TOPRIGHT", hotKeyOverrideTooltip.window, -11, 5)
hotKeyOverrideTooltip.text.style:SetAlign(ALIGN_TOP_LEFT)
DefaultTooltipSetting(hotKeyOverrideTooltip.text)
unitFrameTooltip = UIParent:CreateWidget("unitframetooltip", "unitFrameTooltip", "UIParent")
unitFrameTooltip:EnablePick(false)
unitFrameTooltip:SetExtent(250, 20)
unitFrameTooltip:AddAnchor("TOPLEFT", "UIParent", 100, 100)
unitFrameTooltip.style:SetAlign(ALIGN_CENTER)
DefaultTooltipSetting(unitFrameTooltip)
CreateTooltipDrawable(unitFrameTooltip)
function CreateWorldInfoTooltip()
  local tooltip = UIParent:CreateWidget("gametooltip", "worldTooltip", "UIParent")
  tooltip:SetExtent(250, 20)
  tooltip:EnablePick(false)
  tooltip.style:SetAlign(ALIGN_CENTER)
  DefaultTooltipSetting(tooltip)
  CreateTooltipDrawable(tooltip)
  local worldName = tooltip:CreateChildWidget("textbox", "worldName", 0, true)
  worldName:AddAnchor("TOPLEFT", tooltip, 15, 10)
  worldName:AddAnchor("BOTTOMRIGHT", tooltip, "TOPRIGHT", -15, 10 + FONT_SIZE.LARGE)
  worldName.style:SetAlign(ALIGN_LEFT)
  worldName.style:SetFontSize(FONT_SIZE.LARGE)
  worldName:SetHeight(FONT_SIZE.LARGE)
  local line = CreateLine(tooltip, "TYPE1")
  line:SetVisible(true)
  line:AddAnchor("TOPLEFT", worldName, "BOTTOMLEFT", 0, 5)
  line:AddAnchor("TOPRIGHT", worldName, "BOTTOMRIGHT", 0, 5)
  line:SetColor(1, 1, 1, 0.5)
  local worldDescription = tooltip:CreateChildWidget("textbox", "worldDescription", 0, true)
  worldDescription:AddAnchor("TOPLEFT", line, "BOTTOMLEFT", 0, 5)
  worldDescription:AddAnchor("TOPRIGHT", line, "BOTTOMRIGHT", 0, 5)
  worldDescription.style:SetAlign(ALIGN_LEFT)
  worldDescription:SetLineSpace(TEXTBOX_LINE_SPACE.SMALL)
  worldDescription:SetAutoResize(true)
  function tooltip:SetInfo(name, description)
    tooltip:SetExtent(1000, 10)
    worldName:SetText(name)
    worldDescription:SetText(description)
    local width = math.max(worldDescription:GetLongestLineWidth(), worldName:GetLongestLineWidth()) + 32
    local height = worldName:GetHeight() + worldDescription:GetHeight() + 35
    tooltip:SetExtent(width, height)
    tooltip:Show(true)
  end
  return tooltip
end
mapTooltip = UIParent:CreateWidget("gametooltip", "mapTooltip", tooltip.rootWnd)
mapTooltip:Show(false)
mapTooltip:AddAnchor("TOPLEFT", "UIParent", 100, 100)
mapTooltip:SetExtent(250, 20)
mapTooltip:EnablePick(false)
mapTooltip.style:SetAlign(ALIGN_CENTER)
DefaultTooltipSetting(mapTooltip)
CreateTooltipDrawable(mapTooltip)
mapTooltip.line = CreateLine(mapTooltip, "TYPE1")
mapTooltip.line:SetVisible(false)
mapTooltip.line:AddAnchor("TOPLEFT", mapTooltip, 10, 28)
mapTooltip.line:AddAnchor("TOPRIGHT", mapTooltip, -10, 28)
mapTooltip.line:SetColor(1, 1, 1, 0.5)
mapTooltip.hpBar = mapTooltip:CreateChildWidget("window", "hpBar", 0, true)
mapTooltip.hpBar:AddAnchor("TOPLEFT", mapTooltip, "BOTTOMLEFT", 10, -25)
mapTooltip.hpBar:AddAnchor("BOTTOMRIGHT", mapTooltip, "BOTTOMRIGHT", -10, -10)
mapTooltip.hpBar:Show(false)
mapTooltip.hpBarBg = mapTooltip.hpBar:CreateColorDrawable(0, 0, 0, 0.3, "background")
mapTooltip.hpBarBg:AddAnchor("TOPLEFT", mapTooltip.hpBar, 0, 0)
mapTooltip.hpBarBg:AddAnchor("BOTTOMRIGHT", mapTooltip.hpBar, 0, 0)
mapTooltip.hp = mapTooltip.hpBar:CreateColorDrawable(ConvertColor(205), ConvertColor(11), 0, 1, "background")
mapTooltip.hp:AddAnchor("TOPLEFT", mapTooltip.hpBar, 0, 0)
mapTooltip.hp:AddAnchor("BOTTOMRIGHT", mapTooltip.hpBar, 0, 0)
mapTooltip.hpLabel = mapTooltip.hpBar:CreateChildWidget("label", "hpLabel", 0, true)
mapTooltip.hpLabel:AddAnchor("TOPLEFT", mapTooltip.hpBar, 0, 0)
mapTooltip.hpLabel:AddAnchor("BOTTOMRIGHT", mapTooltip.hpBar, 0, 0)
mapTooltip.hpLabel.style:SetAlign(ALIGN_CENTER)
mapTooltip.hpLabel.style:SetFontSize(FONT_SIZE.SMALL)
local CreateTextTooltip = function(id)
  local textTooltip = UIParent:CreateWidget("gametooltip", "textTooltip", tooltip.rootWnd)
  textTooltip:Show(false)
  textTooltip:EnablePick(false)
  textTooltip:SetExtent(250, 20)
  textTooltip:AddAnchor("TOPLEFT", "UIParent", 100, 100)
  textTooltip.style:SetAlign(ALIGN_CENTER)
  DefaultTooltipSetting(textTooltip)
  CreateTooltipDrawable(textTooltip)
  local titleLine = CreateLine(textTooltip, "TYPE1")
  titleLine:SetVisible(false)
  titleLine:SetColor(1, 1, 1, 0.4)
  textTooltip.titleLine = titleLine
  return textTooltip
end
textTooltip = CreateTextTooltip("textTooltip")
local CreatePremiumToolTip = function(id, parent)
  local tooltip = UIParent:CreateWidget("gametooltip", id, parent)
  tooltip:Show(false)
  tooltip:AddAnchor("TOPLEFT", "UIParent", 100, 100)
  tooltip:SetExtent(300, 20)
  tooltip:EnablePick(false)
  tooltip.style:SetAlign(ALIGN_LEFT)
  DefaultTooltipSetting(tooltip)
  CreateTooltipDrawable(tooltip)
  tooltip.titleLine = CreateLine(tooltip, "TYPE1")
  tooltip.titleLine:SetColor(1, 1, 1, 0.4)
  tooltip.infoLine = CreateLine(tooltip, "TYPE1")
  tooltip.infoLine:SetColor(1, 1, 1, 0.4)
  return tooltip
end
premiumServiceToolTip = nil
if baselibLocale.premiumService.showTooltip then
  premiumServiceToolTip = CreatePremiumToolTip("premiumToolTip", tooltip.rootWnd)
end
local tgosTooltip
function CreateTGOSToolTip(parent)
  tgosTooltip = parent:CreateChildWidget("gametooltip", "tgosTooltip", 0, true)
  tgosTooltip:EnablePick(false)
  tgosTooltip:SetExtent(250, 20)
  tgosTooltip:AddAnchor("BOTTOMRIGHT", parent, "TOPLEFT", 0, 0)
  tgosTooltip:Show(false)
  tgosTooltip.style:SetAlign(ALIGN_LEFT)
  DefaultTooltipSetting(tgosTooltip)
  CreateTooltipDrawable(tgosTooltip)
end
function ShowTGOSToolTip(text)
  if tgosTooltip ~= nil then
    tgosTooltip:ReleaseHandler("OnAlphaAnimeEnd")
    tgosTooltip:ClearLines()
    tgosTooltip:AddLine(text, "", 0, "left", ALIGN_LEFT, 0)
    tgosTooltip:SetAlphaAnimation(0, 1, 0.4, 0)
    tgosTooltip:SetStartAnimation(true, false)
    tgosTooltip:Show(true)
  end
end
function HideTGOSToolTip(callback)
  if tgosTooltip ~= nil then
    tgosTooltip:SetAlphaAnimation(1, 0, 0.4, 0)
    tgosTooltip:SetStartAnimation(true, false)
    local function OnAlphaAnimeEnd()
      tgosTooltip:Show(false)
      if callback ~= nil then
        callback()
      end
    end
    tgosTooltip:SetHandler("OnAlphaAnimeEnd", OnAlphaAnimeEnd)
  end
end
