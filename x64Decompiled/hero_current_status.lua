local CreateHeroElectionRuleWindow = function(id, parent)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local window = CreateWindow(id, parent)
  window:SetExtent(900, 560)
  window:SetTitle(GetUIText(COMMON_TEXT, "hero_election"))
  local function CreateMethodSection(id, parent)
    local section = window:CreateChildWidget("emptywidget", id, 0, false)
    section:SetExtent(window:GetWidth() - MARGIN.WINDOW_SIDE, 50)
    local title = section:CreateChildWidget("label", "title", 0, false)
    title:SetExtent(section:GetWidth(), FONT_SIZE.LARGE)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    title.style:SetAlign(ALIGN_LEFT)
    title:SetText(GetUIText(COMMON_TEXT, "hero_election_method"))
    title:AddAnchor("TOPLEFT", section, 0, 0)
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    local img = section:CreateDrawable(TEXTURE_PATH.HERO_ELECTION_RULE, "graph", "background")
    img:AddAnchor("TOPLEFT", title, "BOTTOMLEFT", 0, 7)
    local offsetY = 7
    local function CreateItem(id, str, iconKey, useDingbat)
      if useDingbat == nil then
        useDingbat = true
      end
      local item = section:CreateChildWidget("textbox", id, 0, false)
      item:SetExtent(section:GetWidth() - MARGIN.WINDOW_SIDE / 2, FONT_SIZE.MIDDLE)
      item.style:SetAlign(ALIGN_LEFT)
      local width = item:GetWidth()
      local offsetX = 5
      if useDingbat then
        W_ICON.DrawRoundDingbat(item)
        item.dingbat:RemoveAllAnchors()
        item.dingbat:AddAnchor("TOPRIGHT", item, "TOPLEFT", -2, 3)
        width = item:GetWidth() - item.dingbat:GetWidth() - 3
        offsetX = offsetX + item.dingbat:GetWidth() + 3
      end
      item:SetWidth(width)
      item:SetText(str)
      item:SetHeight(item:GetTextHeight())
      item:AddAnchor("TOPLEFT", img, "BOTTOMLEFT", offsetX, offsetY)
      ApplyTextColor(item, FONT_COLOR.DEFAULT)
      if iconKey ~= nil then
        local icon = item:CreateDrawable(TEXTURE_PATH.HERO_ELECTION_ALERT, iconKey, "background")
        local lineCount = item:GetLineCount()
        local length = item:GetLineLength(lineCount)
        local requireEnter = false
        if length >= item:GetWidth() - icon:GetWidth() - item.dingbat:GetWidth() + MARGIN.WINDOW_SIDE then
          requireEnter = true
        end
        local offset = 0
        if lineCount == 1 then
          offset = item:GetLongestLineWidth() + 5
        else
          offset = length + 3
        end
        if requireEnter then
          icon:AddAnchor("TOPLEFT", item, "BOTTOMLEFT", 0, 3)
          offsetY = offsetY + icon:GetHeight() + 3
        else
          icon:AddAnchor("BOTTOMLEFT", item, offset, 3)
        end
      end
      offsetY = offsetY + item:GetHeight() + 6
      return item
    end
    local period = CreateItem("period", GetUIText(COMMON_TEXT, "hero_election_method_period"))
    local palce = CreateItem("period", GetUIText(COMMON_TEXT, "hero_election_method_place"))
    local votingRight = CreateItem("period", GetUIText(COMMON_TEXT, "hero_election_method_voting_right"), "icon_vote01")
    local checkHeroEleciton = CreateItem("period", GetUIText(COMMON_TEXT, "hero_election_method_check_hero_election"))
    local userNationHero = CreateItem("period", GetUIText(COMMON_TEXT, "hero_election_method_user_nation_hero"), nil, false)
    ApplyTextColor(userNationHero, FONT_COLOR.GREEN)
    local _, height = F_LAYOUT.GetExtentWidgets(title, userNationHero)
    section:SetHeight(height)
    return section
  end
  local methodSection = CreateMethodSection("methodSection", window)
  methodSection:AddAnchor("TOP", window, 0, titleMargin)
  local function CreateSection(id, titleStr, contentStr, imgKey)
    local section = window:CreateChildWidget("emptywidget", id, 0, false)
    section:SetExtent(window:GetWidth() - sideMargin * 2, 50)
    local title = section:CreateChildWidget("label", "title", 0, false)
    title:SetExtent(section:GetWidth(), FONT_SIZE.LARGE)
    title.style:SetFontSize(FONT_SIZE.LARGE)
    title.style:SetAlign(ALIGN_LEFT)
    title:SetText(titleStr)
    title:AddAnchor("TOPLEFT", section, 0, 0)
    ApplyTextColor(title, FONT_COLOR.MIDDLE_TITLE)
    local content = section:CreateChildWidget("textbox", "content", 0, false)
    content:SetExtent(section:GetWidth(), 30)
    content:AddAnchor("BOTTOMLEFT", section, 0, 0)
    content.style:SetAlign(ALIGN_LEFT)
    content:SetText(contentStr)
    content:SetHeight(content:GetTextHeight())
    ApplyTextColor(content, FONT_COLOR.DEFAULT)
    local height = title:GetHeight() + content:GetHeight() + sideMargin / 2
    section:SetHeight(height)
    return section
  end
  local heroEquipmentSection = CreateSection("heroEquipmentSection", GetUIText(COMMON_TEXT, "hero_equipment_provision"), GetUIText(COMMON_TEXT, "hero_equipment_provision_content"))
  heroEquipmentSection:AddAnchor("TOP", methodSection, "BOTTOM", 0, sideMargin)
  local mobilizationOrderSection = CreateSection("mobilizationOrderSection", GetUIText(COMMON_TEXT, "issuance_of_mobilization_order"), GetUIText(COMMON_TEXT, "issuance_of_mobilization_order_detail_info"))
  mobilizationOrderSection:AddAnchor("TOP", heroEquipmentSection, "BOTTOM", 0, sideMargin)
  local _, height = F_LAYOUT.GetExtentWidgets(window.titleBar, mobilizationOrderSection)
  local okButtonHeight = 60
  height = height + okButtonHeight + sideMargin
  window:SetHeight(height)
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
local SetViewOfHeroCurrentStatus = function(tabWindow)
  local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
  local factionCombobox = CreateHeroFactionCombobox("factionCombobox", tabWindow, X2Hero:GetHeroFactions())
  local heroElectionRule = tabWindow:CreateChildWidget("button", "heroElectionRule", 0, true)
  heroElectionRule:AddAnchor("TOPRIGHT", tabWindow, 0, 9)
  heroElectionRule:SetText(GetUIText(COMMON_TEXT, "hero_election_method"))
  ApplyButtonSkin(heroElectionRule, BUTTON_BASIC.DEFAULT)
  local period = W_ETC.CreatePeriodWidget("period", tabWindow, "RIGHT")
  period:UseStatusIcon(false)
  period:AddAnchor("TOPRIGHT", heroElectionRule, "BOTTOMRIGHT", 7, 9)
  tabWindow.period = period
  local kingName = tabWindow:CreateChildWidget("label", "kingName", 0, true)
  kingName:SetAutoResize(true)
  kingName:AddAnchor("TOPLEFT", factionCombobox, "BOTTOMLEFT", 0, 14)
  kingName:SetHeight(FONT_SIZE.LARGE)
  ApplyTextColor(kingName, FONT_COLOR.BLUE)
  kingName.style:SetFontSize(FONT_SIZE.LARGE)
  local emptyHeroListStr = tabWindow:CreateChildWidget("label", "emptyHeroListStr", 0, true)
  emptyHeroListStr:SetAutoResize(true)
  emptyHeroListStr:AddAnchor("CENTER", tabWindow, "TOP", 0, 240)
  emptyHeroListStr:SetHeight(FONT_SIZE.LARGE)
  ApplyTextColor(emptyHeroListStr, FONT_COLOR.BLUE)
  emptyHeroListStr.style:SetFontSize(FONT_SIZE.LARGE)
  emptyHeroListStr:SetText(GetUIText(COMMON_TEXT, "empty_hero_list"))
  local decoTexture = tabWindow:CreateDrawable(TEXTURE_PATH.HERO_CURRENT_STATUS_TEXT, "text", "background")
  decoTexture:AddAnchor("TOP", tabWindow, 0, 25)
  tabWindow.item = {}
  local function CreateItem(grade)
    local textureInfos = {
      {
        enablekey = "level_01",
        disableKey = "disable_01",
        anchor = "TOP"
      },
      {
        enablekey = "level_02",
        disableKey = "disable_01",
        anchor = "TOPRIGHT"
      },
      {
        enablekey = "level_03",
        disableKey = "disable_01",
        anchor = "TOPLEFT"
      },
      {
        enablekey = "level_04",
        disableKey = "disable_02",
        anchor = "TOP"
      },
      {
        enablekey = "level_05",
        disableKey = "disable_02",
        anchor = "TOP"
      },
      {
        enablekey = "level_06",
        disableKey = "disable_02",
        anchor = "TOP"
      }
    }
    local itemWidth = {
      262,
      285,
      285,
      250,
      250,
      250
    }
    local itemHeight = {
      129,
      106,
      106,
      105,
      105,
      105
    }
    local item = tabWindow:CreateChildWidget("emptywidget", "item", grade, true)
    item:SetWidth(itemWidth[grade])
    item.grade = grade
    local heroEmblem = W_ICON.CreateHeroGradeEmblem(item, grade, true)
    local leadershipPoint = item:CreateChildWidget("textbox", "leadershipPoint", 0, false)
    leadershipPoint:SetAutoResize(true)
    leadershipPoint:SetExtent(itemWidth[grade], FONT_SIZE.MIDDLE)
    ApplyTextColor(leadershipPoint, FONT_COLOR.DEFAULT)
    local OnEnter = function(self)
      SetTooltip(string.format("%s/%s", GetUIText(COMMON_TEXT, "leadership_point"), GetUIText(COMMON_TEXT, "accumulated_leadership_point")), self)
    end
    leadershipPoint:SetHandler("OnEnter", OnEnter)
    local expedition = item:CreateChildWidget("label", "expedition", 0, true)
    expedition:SetHeight(FONT_SIZE.MIDDLE)
    ApplyTextColor(expedition, FONT_COLOR.DEFAULT)
    item:SetHeight(itemHeight[grade] + 51)
    leadershipPoint:AddAnchor("TOP", item, 0, itemHeight[grade] + FONT_SIZE.LARGE)
    heroEmblem:AddAnchor("BOTTOM", leadershipPoint, "TOP", 0, -5)
    heroEmblem:SetExtent(item:GetWidth(), FONT_SIZE.LARGE)
    heroEmblem:SetInfo()
    expedition:AddAnchor("TOP", leadershipPoint, "BOTTOM", 0, 3)
    expedition:SetWidth(item:GetWidth())
    expedition.style:SetEllipsis(true)
    leadershipPoint.style:SetAlign(ALIGN_CENTER)
    expedition.style:SetAlign(ALIGN_CENTER)
    local OnEnter = function(self)
      if self.style:GetTextWidth(self:GetText()) < self:GetWidth() then
        return
      end
      if self.name == "" then
        return
      end
      SetTooltip(self.name, self)
    end
    expedition:SetHandler("OnEnter", OnEnter)
    function item:SetInfo(info)
      leadershipPoint:Show(false)
      expedition:Show(false)
      if info == nil or info.name == nil then
        heroEmblem:SetInfo()
        return
      end
      heroEmblem:SetInfo(info.name)
      leadershipPoint:Show(true)
      leadershipPoint:SetWidth(itemWidth[grade])
      leadershipPoint:SetText(string.format("%s : |,%d; / |sd%d;", GetUIText(COMMON_TEXT, "leadership_point"), info.score, info.leadership))
      leadershipPoint:SetWidth(leadershipPoint:GetLongestLineWidth() + 5)
      if info.expedition == nil then
        expedition:Show(false)
        expedition.name = ""
      else
        expedition:Show(true)
        expedition.name = info.expedition
        expedition:SetText(string.format("%s : %s", GetUIText(COMMON_TEXT, "expedition"), info.expedition))
      end
    end
    return item
  end
  local function GetAnchorInfo(grade)
    local info = {
      {anchor = "TOP", offsetX = 0},
      {
        anchor = "TOP",
        offsetX = -(tabWindow.item[grade]:GetWidth() / 2)
      },
      {
        anchor = "TOP",
        offsetX = tabWindow.item[grade]:GetWidth() / 2
      },
      {
        anchor = "TOP",
        offsetX = -(tabWindow.item[grade]:GetWidth() + 5)
      },
      {anchor = "TOP", offsetX = 0},
      {
        anchor = "TOP",
        offsetX = tabWindow.item[grade]:GetWidth() + 5
      }
    }
    return info[grade]
  end
  local NeedEnter = function(grade)
    if grade == 1 then
      return true, 0
    elseif grade == 3 then
      return true, 18
    end
    return false
  end
  local offsetY = 119
  for i = 1, MAX_HERO do
    local item = CreateItem(i)
    local info = GetAnchorInfo(i)
    item:AddAnchor(info.anchor, tabWindow, info.offsetX, offsetY)
    local needEnter, inset = NeedEnter(i)
    if needEnter then
      offsetY = offsetY + item:GetHeight() + inset
    end
  end
end
function CreateHeroCurrentStatus(tabWindow)
  SetViewOfHeroCurrentStatus(tabWindow)
  local heroElectionRuleWnd
  local heroElectionRule = tabWindow.heroElectionRule
  local function HeroElectionRuleFunc()
    if heroElectionRuleWnd == nil then
      heroElectionRuleWnd = CreateHeroElectionRuleWindow("heroElectionRuleWnd", "UIParent")
      heroElectionRuleWnd:Show(true)
      heroElectionRuleWnd:EnableHidingIsRemove(true)
      heroElectionRuleWnd:AddAnchor("CENTER", "UIParent", 0, 0)
      tabWindow.heroElectionRuleWnd = heroElectionRuleWnd
      local function OnHide()
        heroElectionRuleWnd = nil
        tabWindow.heroElectionRuleWnd = nil
      end
      heroElectionRuleWnd:SetHandler("OnHide", OnHide)
    else
      heroElectionRuleWnd:Show(not heroElectionRuleWnd:IsVisible())
    end
  end
  ButtonOnClickHandler(heroElectionRule, HeroElectionRuleFunc)
  local comboBox = tabWindow.factionCombobox
  local function FillPeriod()
    local periodInfo = X2Hero:GetActivedHeroPeriod(HERO_PERIOD_SCHEDULE)
    if periodInfo ~= nil then
      local periodStr = locale.common.from_to(locale.time.GetDateToDateFormat(periodInfo.periodStart, startFilter), locale.time.GetDateToDateFormat(periodInfo.periodEnd, endFilter))
      local str = string.format("%s: %s", GetUIText(COMMON_TEXT, "activity_period"), periodStr)
      tabWindow.period:SetPeriod(str, true)
    end
  end
  local function FillKingName()
    local selFactionId = comboBox:GetSelFactionId()
    if selFactionId == nil or selFactionId == 0 then
      return
    end
    local ownerName = ""
    if selFactionId == OUTLAW_FACTION_ID then
      ownerName = GetUIText(COMMON_TEXT, "outlaw_union_king_name")
    elseif selFactionId == NUIA_FACTION_ID then
      ownerName = GetUIText(COMMON_TEXT, "nuia_union_king_name")
    elseif selFactionId == HARIHARA_FACTION_ID then
      ownerName = GetUIText(COMMON_TEXT, "harihara_union_king_name")
    end
    tabWindow.kingName:SetText(string.format("%s: %s", GetUIText(NATION_TEXT, "king"), ownerName))
  end
  local function FillHeroList()
    for i = 1, MAX_HERO do
      tabWindow.item[i]:SetInfo(nil)
    end
    local selFactionId = comboBox:GetSelFactionId()
    if selFactionId == nil or selFactionId == 0 then
      tabWindow.emptyHeroListStr:Show(true)
      return
    else
      tabWindow.emptyHeroListStr:Show(false)
    end
    local heroList = X2Hero:GetHeroList(selFactionId)
    if heroList == nil then
      return
    end
    for i = 1, MAX_HERO do
      local info = heroList[i] or nil
      tabWindow.item[i]:SetInfo(info)
    end
  end
  local function FillPage()
    FillPeriod()
    FillKingName()
    FillHeroList()
  end
  FillPage()
  function comboBox:SelectedProc()
    FillPage()
  end
end
