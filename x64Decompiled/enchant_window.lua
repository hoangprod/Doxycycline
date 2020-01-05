local featureSet = X2Player:GetFeatureSet()
local ENCHANT_PAGE_KEY = {
  "grade",
  "socket",
  "gem",
  "evolving",
  "refurbishment",
  "smelting",
  "awaken"
}
local ENCHANT_PAGE_ACTIVE_STATUS = {
  [ENCHANT_PAGE_KEY[1]] = featureSet.itemGradeEnchant,
  [ENCHANT_PAGE_KEY[2]] = true,
  [ENCHANT_PAGE_KEY[3]] = true,
  [ENCHANT_PAGE_KEY[4]] = featureSet.itemEvolving,
  [ENCHANT_PAGE_KEY[5]] = featureSet.itemCapScale,
  [ENCHANT_PAGE_KEY[6]] = featureSet.itemSmelting,
  [ENCHANT_PAGE_KEY[7]] = featureSet.itemChangeMapping
}
local ENCHANT_PAGE_NUM = {}
for i, v in ipairs(ENCHANT_PAGE_KEY) do
  if ENCHANT_PAGE_ACTIVE_STATUS[v] then
    ENCHANT_PAGE_NUM[#ENCHANT_PAGE_NUM + 1] = v
  end
end
function GetEnchantTabIndex(key)
  for i, v in ipairs(ENCHANT_PAGE_NUM) do
    if v == key then
      return i
    end
  end
  return -1
end
local sideMargin, titleMargin, bottomMargin = GetWindowMargin()
local function CreateEnchantWindow(id, parent)
  local extent, anchor, text
  local window = CreateWindow(id, parent, "enchant")
  window:Show(false)
  window:SetExtent(510, inventoryLocale.enchantWindowHeight)
  window:AddAnchor("CENTER", parent, 0, 0)
  window:SetTitle(GetUIText(WINDOW_TITLE_TEXT, "enchant"))
  window:SetSounds("item_enchant")
  local OnHide = function()
    X2ItemEnchant:LeaveItemEnchantMode()
  end
  window:SetHandler("OnHide", OnHide)
  window:SetHandler("OnRestricted", OnHide)
  local tab = W_BTN.CreateImageTab("tab", window)
  tab:AddAnchor("TOPLEFT", window, sideMargin, titleMargin)
  tab:AddAnchor("BOTTOMRIGHT", window, -sideMargin, 0)
  local tabInfos = {
    grade = {
      tooltip = GetUIText(COMMON_TEXT, "grade_enchant"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_GRADE
    },
    socket = {
      tooltip = GetUIText(COMMON_TEXT, "socket"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_SOCKET
    },
    gem = {
      tooltip = GetUIText(COMMON_TEXT, "gem_enchant"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_GEM
    },
    evolving = {
      tooltip = GetUIText(COMMON_TEXT, "evolving"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_EVOLVING
    },
    refurbishment = {
      tooltip = GetUIText(COMMON_TEXT, "item_scale"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_SCALE
    },
    smelting = {
      tooltip = GetCommonText("smelting"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_SMELTING
    },
    awaken = {
      tooltip = GetCommonText("awaken"),
      buttonStyle = BUTTON_CONTENTS.ENCHANT_TAB_AWAKEN
    }
  }
  local acitveTabInfos = {}
  for i, v in ipairs(ENCHANT_PAGE_NUM) do
    if v then
      acitveTabInfos[#acitveTabInfos + 1] = tabInfos[v]
    end
  end
  tab:AddTabs(acitveTabInfos)
  if ENCHANT_PAGE_ACTIVE_STATUS.grade then
    CreateEnchantGradeWindow(window.tab.window[GetEnchantTabIndex("grade")])
  end
  CreateSocketEnchantWindow(window.tab.window[GetEnchantTabIndex("socket")])
  CreateGemEnchantWindow(window.tab.window[GetEnchantTabIndex("gem")])
  if ENCHANT_PAGE_ACTIVE_STATUS.evolving then
    CreateEvolvingEnchantWindow(window.tab.window[GetEnchantTabIndex("evolving")])
  end
  if ENCHANT_PAGE_ACTIVE_STATUS.refurbishment then
    CreateRefurbishmentWindow(window.tab.window[GetEnchantTabIndex("refurbishment")])
  end
  if ENCHANT_PAGE_ACTIVE_STATUS.smelting then
    CreateSmeltWindow(window.tab.window[GetEnchantTabIndex("smelting")])
  end
  if ENCHANT_PAGE_ACTIVE_STATUS.awaken then
    CreateAwakenWindow(window.tab.window[GetEnchantTabIndex("awaken")])
  end
  function tab:OnTabChangedProc(selected)
    if selected == GetEnchantTabIndex("grade") then
      X2ItemEnchant:SwitchItemEnchantGradeMode()
    elseif selected == GetEnchantTabIndex("socket") then
      if window.isEnterMode then
        window.isEnterMode = false
        return
      end
      X2ItemEnchant:SwitchItemEnchantSocketInsertMode()
    elseif selected == GetEnchantTabIndex("gem") then
      X2ItemEnchant:SwitchItemEnchantGemMode()
    elseif selected == GetEnchantTabIndex("evolving") then
      if window.isEnterMode then
        window.isEnterMode = false
        return
      end
      X2ItemEnchant:SwitchItemEnchantEvolvingMode()
    elseif selected == GetEnchantTabIndex("refurbishment") then
      X2ItemEnchant:SwitchItemRefurbishmentMode()
    elseif selected == GetEnchantTabIndex("smelting") then
      X2ItemEnchant:SwitchItemSmeltingMode()
    elseif selected == GetEnchantTabIndex("awaken") then
      X2ItemEnchant:SwitchItemAwakenMode()
    end
  end
  function window:SelectMode(mode)
    if mode == "grade" then
      window.tab.window[GetEnchantTabIndex("grade")]:SlotAllUpdate(false)
    elseif mode == "socket_insert" then
      window.tab.window[GetEnchantTabIndex("socket")].tabSubMenu.subMenuButtons[1]:OnClick()
      window.tab.window[GetEnchantTabIndex("socket")]:SlotAllUpdate(false)
    elseif mode == "socket_remove" then
      window.tab.window[GetEnchantTabIndex("socket")].tabSubMenu.subMenuButtons[2]:OnClick()
      window.tab.window[GetEnchantTabIndex("socket")]:SlotAllUpdate(false)
    elseif mode == "socket_extract" then
      window.tab.window[GetEnchantTabIndex("socket")].tabSubMenu.subMenuButtons[3]:OnClick()
      window.tab.window[GetEnchantTabIndex("socket")]:SlotAllUpdate(false)
    elseif mode == "socket_upgrade" then
      window.tab.window[GetEnchantTabIndex("socket")].tabSubMenu.subMenuButtons[4]:OnClick()
      window.tab.window[GetEnchantTabIndex("socket")]:SlotAllUpdate(false)
    elseif mode == "gem" then
      window.tab.window[GetEnchantTabIndex("gem")]:SlotAllUpdate(false)
    elseif mode == "evolving" then
      if ENCHANT_PAGE_ACTIVE_STATUS.evolving then
        window.tab.window[GetEnchantTabIndex("evolving")].tabSubMenu.subMenuButtons[1]:OnClick()
        window.tab.window[GetEnchantTabIndex("evolving")]:SlotAllUpdate(false)
      end
    elseif mode == "evolving_re_roll" then
      if ENCHANT_PAGE_ACTIVE_STATUS.evolving and featureSet.itemEvolvingReRoll then
        window.tab.window[GetEnchantTabIndex("evolving")].tabSubMenu.subMenuButtons[2]:OnClick()
        window.tab.window[GetEnchantTabIndex("evolving")]:SlotAllUpdate(false)
      end
    elseif mode == "refurbishment" then
      if ENCHANT_PAGE_ACTIVE_STATUS.refurbishment then
        window.tab.window[GetEnchantTabIndex("refurbishment")]:SlotAllUpdate(false)
      end
    elseif mode == "smelting" then
      if ENCHANT_PAGE_ACTIVE_STATUS.smelting then
        window.tab.window[GetEnchantTabIndex("smelting")]:SlotAllUpdate(false)
        if window.tab.window[GetEnchantTabIndex("smelting")].spinnerWnd ~= nil then
          window.tab.window[GetEnchantTabIndex("smelting")].spinnerWnd:SetValue(1)
        end
      end
    elseif mode == "awaken" and ENCHANT_PAGE_ACTIVE_STATUS.awaken then
      window.tab.window[GetEnchantTabIndex("awaken")]:SlotAllUpdate(false)
    end
  end
  local evolvingResultWnd
  local function CreateEvolvingResultWnd(id, parent)
    local window = CreateWindow(id, parent)
    window:SetTitle(GetUIText(COMMON_TEXT, "item_grade_up"))
    window:EnableHidingIsRemove(true)
    window:SetExtent(430, 460)
    local commonWidth = window:GetWidth() - MARGIN.WINDOW_SIDE * 2
    local gradeBg = window:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "artwork")
    gradeBg:SetTextureColor("default")
    gradeBg:SetExtent(commonWidth, 44)
    gradeBg:AddAnchor("TOP", window, 0, MARGIN.WINDOW_TITLE)
    local grade = window:CreateChildWidget("textbox", "grade", 0, false)
    grade:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
    grade:AddAnchor("CENTER", gradeBg, 0, 0)
    grade.style:SetFontSize(FONT_SIZE.MIDDLE)
    local gradeArrow = window:CreateDrawable(TEXTURE_PATH.HUD, "single_arrow", "artwork")
    gradeArrow:AddAnchor("CENTER", gradeBg, 0, 0)
    local gradeLeft = window:CreateChildWidget("textbox", "gradeLeft", 0, false)
    gradeLeft:SetExtent(165, FONT_SIZE.MIDDLE)
    gradeLeft:AddAnchor("RIGHT", gradeArrow, "LEFT", -5, 0)
    gradeLeft.style:SetFontSize(FONT_SIZE.MIDDLE)
    gradeLeft.style:SetAlign(ALIGN_RIGHT)
    local gradeRight = window:CreateChildWidget("textbox", "gradeRight", 0, false)
    gradeRight:SetExtent(165, FONT_SIZE.MIDDLE)
    gradeRight:AddAnchor("LEFT", gradeArrow, "RIGHT", 5, 0)
    gradeRight.style:SetFontSize(FONT_SIZE.MIDDLE)
    gradeRight.style:SetAlign(ALIGN_LEFT)
    local itemIcon = CreateItemIconButton("itemIcon", window)
    itemIcon:SetExtent(ICON_SIZE.DEFAULT, ICON_SIZE.DEFAULT)
    itemIcon:AddAnchor("TOP", gradeBg, "BOTTOM", 0, 10)
    local itemNameBg = CreateContentBackground(window, "TYPE11", "brown", "artwork")
    itemNameBg:AddAnchor("TOP", itemIcon, "BOTTOM", 0, 5)
    itemNameBg:SetExtent(commonWidth, 35)
    local itemName = window:CreateChildWidget("textbox", "itemName", 0, false)
    itemName:SetExtent(commonWidth, FONT_SIZE.MIDDLE)
    itemName:AddAnchor("CENTER", itemNameBg, 0, 0)
    local function CreateAttrFrame(parent, name)
      local attrFrame = parent:CreateChildWidget("emptywidget", name, 0, true)
      attrFrame:SetWidth(commonWidth)
      if name == "expFrame" then
        do
          local bg = attrFrame:CreateDrawable(TEXTURE_PATH.COSPLAY_ENCHANT_RESULT, "exp_bg", "artwork")
          bg:AddAnchor("CENTER", attrFrame, 0, 0)
          attrFrame:SetHeight(bg:GetHeight())
          attrFrame.bg = bg
          function attrFrame:SetAdjustHeight(height)
            self.bg:SetHeight(height)
            self:SetHeight(bg:GetHeight())
          end
        end
      else
        local bg = attrFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
        bg:SetTextureColor("default")
        bg:AddAnchor("TOPLEFT", attrFrame, 0, 0)
        bg:AddAnchor("BOTTOMRIGHT", attrFrame, 0, 0)
        local bg1 = attrFrame:CreateDrawable(TEXTURE_PATH.DEFAULT, "type02_new", "background")
        bg1:SetTextureColor("default")
        bg1:SetWidth(100 + LOCALE_ATTR_INFO_WIDTH_ADJUST)
        bg1:AddAnchor("TOPLEFT", attrFrame, 0, 0)
        bg1:AddAnchor("BOTTOMLEFT", attrFrame, 0, 0)
      end
      return attrFrame
    end
    local CreateAttrInfo = function(parent, name, text, infoColor)
      local attrTitle = parent:CreateChildWidget("textbox", name, 0, true)
      attrTitle:SetWidth(80 + LOCALE_ATTR_INFO_WIDTH_ADJUST)
      attrTitle:SetHeight(FONT_SIZE.LARGE)
      attrTitle:SetAutoWordwrap(true)
      attrTitle:SetAutoResize(true)
      attrTitle:SetText(text)
      attrTitle.style:SetAlign(ALIGN_CENTER)
      attrTitle.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
      ApplyTextColor(attrTitle, FONT_COLOR.EVOLVING_GRAY)
      local attrInfo = attrTitle:CreateChildWidget("textbox", name .. "Info", 0, true)
      attrInfo:SetWidth(275 - LOCALE_ATTR_INFO_WIDTH_ADJUST)
      attrInfo:SetAutoWordwrap(true)
      attrInfo:SetAutoResize(true)
      attrInfo:SetHeight(FONT_SIZE.LARGE)
      attrInfo.style:SetAlign(ALIGN_CENTER)
      attrInfo.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
      attrInfo:AddAnchor("LEFT", attrTitle, "RIGHT", 14, 0)
      ApplyTextColor(attrInfo, infoColor)
      attrTitle.attrInfo = attrInfo
      function attrTitle:SetAttrInfo(text)
        self.attrInfo:SetText(text)
      end
      return attrTitle
    end
    local GetAttrStr = function(name, value)
      return string.format("%s %s", locale.attribute(name), GetModifierCalcValue(name, value))
    end
    local resultAnchor = window:CreateChildWidget("emptywidget", "resultAnchor", 0, true)
    resultAnchor:SetExtent(commonWidth, 0)
    resultAnchor:AddAnchor("TOP", itemNameBg, "BOTTOM", 0, 9)
    local changeAttrFrame = CreateAttrFrame(window, "changeAttrFrame")
    local beforeAttr = CreateAttrInfo(changeAttrFrame, "beforeAttr", GetCommonText("evolving_dialog_before_attr_title"), FONT_COLOR.TITLE)
    beforeAttr:AddAnchor("TOPLEFT", changeAttrFrame, "TOPLEFT", 10, 17)
    local afterAttr = CreateAttrInfo(changeAttrFrame, "afterAttr", GetCommonText("evolving_dialog_after_attr_title"), FONT_COLOR.SEA_BLUE)
    afterAttr:AddAnchor("BOTTOMLEFT", changeAttrFrame, "BOTTOMLEFT", 10, -17)
    changeAttrFrame:SetHeight(beforeAttr:GetHeight() + afterAttr:GetHeight() + ATTR_INFO_HEIGHT_ADJUST)
    local arrow = beforeAttr:CreateChildWidget("label", "arrow", 0, true)
    arrow:SetHeight(FONT_SIZE.LARGE)
    arrow:SetAutoResize(true)
    arrow:SetText("\226\150\188")
    arrow.style:SetAlign(ALIGN_CENTER)
    arrow.style:SetFont(FONT_PATH.DEFAULT, FONT_SIZE.LARGE)
    ApplyTextColor(arrow, FONT_COLOR.SEA_BLUE)
    local addAttrFrame = CreateAttrFrame(window, "addAttrFrame")
    local addAttr = CreateAttrInfo(addAttrFrame, "addAttr", GetCommonText("addition"), FONT_COLOR.SEA_BLUE)
    addAttr:AddAnchor("LEFT", addAttrFrame, 10, 0)
    addAttrFrame:SetHeight(addAttr:GetHeight() + 36)
    local expFrame = CreateAttrFrame(window, "expFrame")
    local expInfo = CreateAttrInfo(expFrame, "expInfo", GetCommonText("exp"), FONT_COLOR.SEA_BLUE)
    expInfo:AddAnchor("LEFT", expFrame, "LEFT", 10, 0)
    expFrame.expInfo = expInfo
    local okButton = window:CreateChildWidget("button", "okButton", 0, false)
    okButton:SetText(GetUIText(COMMON_TEXT, "ok"))
    ApplyButtonSkin(okButton, BUTTON_BASIC.DEFAULT)
    local function OkButtonLeftClickFunc()
      window:Show(false)
    end
    ButtonOnClickHandler(okButton, OkButtonLeftClickFunc)
    function window:UpdateInfo(isEvolving, itemInfo, oldGrade, newGrade, beforeStr, afterStr, addStr, bonusStr)
      if isEvolving then
        window:SetTitle(GetCommonText("item_grade_up"))
      else
        window:SetTitle(GetCommonText("change_evolving_effect"))
        oldGrade = newGrade
      end
      local sameGrade = oldGrade == newGrade
      grade:Show(sameGrade)
      gradeLeft:Show(not sameGrade)
      gradeRight:Show(not sameGrade)
      gradeArrow:Show(not sameGrade)
      if sameGrade then
        grade:SetText(string.format("|c%s[%s]", X2Item:GradeColor(oldGrade), X2Item:GradeName(oldGrade)))
      else
        gradeLeft:SetText(string.format("|c%s[%s]", X2Item:GradeColor(oldGrade), X2Item:GradeName(oldGrade)))
        gradeRight:SetText(string.format("|c%s[%s]", X2Item:GradeColor(newGrade), X2Item:GradeName(newGrade)))
        local arrowColor = Hex2Dec(X2Item:GradeColor(newGrade))
        gradeArrow:SetColor(arrowColor[1], arrowColor[2], arrowColor[3], arrowColor[4])
      end
      local gradeColor = X2Item:GradeColor(itemInfo.itemGrade)
      ApplyTextColor(itemName, Hex2Dec(gradeColor))
      itemIcon:SetItemInfo(itemInfo)
      itemName:SetText("[" .. itemInfo.name .. "]")
      itemName:SetHeight(itemName:GetTextHeight())
      itemNameBg:SetWidth(itemName:GetLongestLineWidth() + 40)
      changeAttrFrame:Show(false)
      addAttrFrame:Show(false)
      expFrame:Show(false)
      local anchorObj = resultAnchor
      if beforeStr ~= nil and afterStr ~= nil then
        changeAttrFrame:Show(true)
        changeAttrFrame:AddAnchor("TOP", anchorObj, "BOTTOM", 0, 0)
        anchorObj = changeAttrFrame
        beforeAttr:SetAttrInfo(beforeStr)
        afterAttr:SetAttrInfo(afterStr)
        local _, startPos = beforeAttr.attrInfo:GetOffset()
        startPos = startPos + beforeAttr.attrInfo:GetHeight()
        local _, endPos = afterAttr.attrInfo:GetOffset()
        local arrowOffsetY = (endPos - startPos - arrow:GetHeight()) / 2
        arrow:AddAnchor("TOP", beforeAttr.attrInfo, "BOTTOM", 0, arrowOffsetY)
      end
      if addStr ~= nil then
        addAttrFrame:Show(true)
        addAttrFrame:AddAnchor("TOP", anchorObj, "BOTTOM", 0, 0)
        anchorObj = addAttrFrame
        addAttr:SetAttrInfo(addStr)
        addAttrFrame:SetHeight(math.max(addAttr.attrInfo:GetHeight(), addAttr:GetHeight()) + 36)
      end
      if bonusStr ~= nil then
        expFrame:Show(true)
        expFrame:AddAnchor("TOP", anchorObj, "BOTTOM", 0, -2)
        anchorObj = expFrame
        expInfo:SetAttrInfo(bonusStr)
        expFrame:SetAdjustHeight(math.max(expInfo.attrInfo:GetHeight(), expInfo:GetHeight()) + 26)
      end
      okButton:AddAnchor("TOP", anchorObj, "BOTTOM", 0, 23)
      local _, startPos = window:GetOffset()
      local _, endPos = okButton:GetOffset()
      endPos = endPos + okButton:GetHeight() + 20
      window:SetExtent(window:GetWidth(), endPos - startPos)
    end
    local function OnEndFadeOut()
      evolvingResultWnd = nil
    end
    window:SetHandler("OnEndFadeOut", OnEndFadeOut)
    return window
  end
  local function UnlockAllTab()
    for i = 1, #window.tab.window do
      window.tab.selectedButton[i]:Enable(true)
      window.tab.unselectedButton[i]:Enable(true)
    end
  end
  local function SelectTab(mode)
    if mode == "grade" then
      window.tab:SelectTab(GetEnchantTabIndex("grade"))
    elseif mode == "socket_insert" or mode == "socket_remove" or mode == "socket_extract" or mode == "socket_upgrade" then
      if mode == "socket_extract" and not featureSet.socketExtract then
        return false
      end
      if mode == "socket_upgrade" and not featureSet.socketChange then
        return false
      end
      window.isEnterMode = true
      window.tab:SelectTab(GetEnchantTabIndex("socket"))
    elseif mode == "gem" then
      window.tab:SelectTab(GetEnchantTabIndex("gem"))
    elseif mode == "evolving" then
      if not ENCHANT_PAGE_ACTIVE_STATUS.evolving then
        return false
      end
      window.tab:SelectTab(GetEnchantTabIndex("evolving"))
    elseif mode == "evolving_re_roll" then
      if not ENCHANT_PAGE_ACTIVE_STATUS.evolving or not featureSet.itemEvolvingReRoll then
        return false
      end
      window.isEnterMode = true
      window.tab:SelectTab(GetEnchantTabIndex("evolving"))
    elseif mode == "refurbishment" then
      if not ENCHANT_PAGE_ACTIVE_STATUS.refurbishment then
        return false
      end
      window.tab:SelectTab(GetEnchantTabIndex("refurbishment"))
    elseif mode == "smelting" then
      if not ENCHANT_PAGE_ACTIVE_STATUS.smelting then
        return false
      end
      window.tab:SelectTab(GetEnchantTabIndex("smelting"))
    elseif mode == "awaken" then
      window.tab:SelectTab(GetEnchantTabIndex("awaken"))
    end
    return true
  end
  local events = {
    LEFT_LOADING = function()
      window:Show(false)
    end,
    ENTER_ENCHANT_ITEM_MODE = function(mode)
      local success = SelectTab(mode)
      if not success then
        UIParent:LogAlways(string.format("failed select tab, mode: %s", mode))
        window:Show(false)
        return
      end
      window:SelectMode(mode)
    end,
    SWITCH_ENCHANT_ITEM_MODE = function(mode)
      window:SelectMode(mode)
    end,
    LEAVE_ENCHANT_ITEM_MODE = function()
      for i = 1, #window.tab.window do
        window.tab.window[i]:SlotAllUpdate(false)
      end
      window.tab.window[GetEnchantTabIndex("socket")]:UnlockSubMenu()
      UnlockAllTab()
      window:Show(false)
    end,
    UPDATE_ENCHANT_ITEM_MODE = function(isExcutable, isLock)
      local function GetVisibleTabWindow()
        for i = 1, #window.tab.window do
          if window.tab.window[i]:IsVisible() then
            return window.tab.window[i]
          end
        end
      end
      GetVisibleTabWindow():SlotAllUpdate(isExcutable, isLock)
      if not isLock then
        window.tab.window[GetEnchantTabIndex("socket")]:UnlockSubMenu()
        UnlockAllTab()
      end
    end,
    ITEM_EVOLVING_RESULT = function(linkText, isEvolving, oldGrade, newGrade, infos)
      if infos == nil then
        return
      end
      if isEvolving == true and oldGrade == newGrade and (infos.bonusExp == nil or infos.bonusExp < 1) then
        return
      end
      if isEvolving == false and infos.changeAttrFrame == false then
        return
      end
      local itemInfo = X2Item:InfoFromLink(linkText)
      if itemInfo == nil then
        return
      end
      if evolvingResultWnd == nil then
        evolvingResultWnd = CreateEvolvingResultWnd("evolvingResultWnd", "UIParent")
        evolvingResultWnd:Show(true)
        evolvingResultWnd:AddAnchor("CENTER", "UIParent", 0, 0)
      end
      local GetAttrStr = function(name, value)
        return string.format("%s %s", locale.attribute(name), GetModifierCalcValue(name, value))
      end
      local beforeStr, afterStr
      if infos.changeAttr then
        beforeStr = GetAttrStr(infos.beforeChange.name, infos.beforeChange.value)
        afterStr = GetAttrStr(infos.afterChange.name, infos.afterChange.value)
      end
      local addStr
      for i = 1, infos.addCount do
        local item = infos.add[i]
        local itemStr = GetAttrStr(item.name, item.value)
        if addStr == nil then
          addStr = ""
        end
        addStr = F_TEXT.SetEnterString(addStr, itemStr)
      end
      local bonusStr
      if infos.bonusExp and infos.bonusExp > 0 then
        bonusStr = GetUIText(COMMON_TEXT, "bonus_evolving_exp", tostring(infos.bonusPer), CommaStr(X2Util:NumberToString(infos.bonusExp)))
        F_SOUND.PlayUISound("item_synthesis_result", true)
      end
      evolvingResultWnd:UpdateInfo(isEvolving, itemInfo, oldGrade, newGrade, beforeStr, afterStr, addStr, bonusStr)
    end
  }
  window:SetHandler("OnEvent", function(this, event, ...)
    events[event](...)
  end)
  RegistUIEvent(window, events)
  return window
end
local enchantWnd = CreateEnchantWindow("enchantWnd", "UIParent")
ADDON:RegisterContentWidget(UIC_ENCHANT, enchantWnd)
function ToggleEnchantWindow()
  enchantWnd:Show(not enchantWnd:IsVisible())
  if enchantWnd:IsVisible() then
    X2ItemEnchant:EnterItemEnchantMode()
  end
end
function GetEnchantWindow()
  return enchantWnd
end
function LockUnvisibleTab()
  if GetEnchantWindow() == nil then
    return
  end
  for i = 1, #enchantWnd.tab.window do
    if not enchantWnd.tab.window[i]:IsVisible() then
      enchantWnd.tab.selectedButton[i]:Enable(false)
      enchantWnd.tab.unselectedButton[i]:Enable(false)
    end
  end
end
