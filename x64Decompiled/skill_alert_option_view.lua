local skillAlertOptionWnd
local function CreateSkillAlertOptionWnd()
  local skillBlackList = {}
  local skillWhiteList = {}
  skillAlertOptionWnd = CreateWindow("skill_alert_option_view", "UIParent")
  skillAlertOptionWnd:SetExtent(430, 575)
  skillAlertOptionWnd:AddAnchor("CENTER", "UIParent", "CENTER", 0, 0)
  skillAlertOptionWnd:SetTitle(X2Locale:LocalizeUiText(COMMON_TEXT, "skill_alert_option_popup_title"))
  local filterBtn = W_CTRL.CreateComboBox("filterBtn", skillAlertOptionWnd)
  filterBtn:AddAnchor("TOP", skillAlertOptionWnd, "TOP", 0, 55)
  filterBtn:SetWidth(260)
  function filterBtn:SelectedProc(index)
    local info = self:GetSelectedInfo()
    if info == nil then
      return
    end
    skillAlertOptionWnd:UpdateSkillAlertAbilitySkillList(info.value)
  end
  skillAlertOptionWnd.filterBtn = filterBtn
  local skillListBgLabel = skillAlertOptionWnd:CreateChildWidget("textbox", "helpMsgLaskillListBgLabelbel1", 0, false)
  skillListBgLabel:AddAnchor("TOPLEFT", skillAlertOptionWnd, "TOPLEFT", 40, 105)
  skillListBgLabel:SetExtent(330, 302)
  skillListBgLabel.style:SetAlign(ALIGN_CENTER)
  skillListBgLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(skillListBgLabel, FONT_COLOR.DEFAULT)
  skillListBgLabel:SetText(GetUIText(COMMON_TEXT, "not_exist_skill_alert"))
  skillAlertOptionWnd.skillListBgLabel = skillListBgLabel
  local skillList = W_CTRL.CreateScrollListCtrl("listCtrl", skillAlertOptionWnd)
  skillList.scroll:RemoveAllAnchors()
  skillList.scroll:AddAnchor("TOPRIGHT", skillList, 0, 0)
  skillList.scroll:AddAnchor("BOTTOMRIGHT", skillList, 0, 0)
  skillList:SetExtent(382, 336)
  skillList:AddAnchor("TOP", filterBtn, "BOTTOM", 0, 10)
  skillList:AddAnchor("LEFT", skillAlertOptionWnd, "LEFT", MARGIN.WINDOW_SIDE, 0)
  skillList:HideColumnButtons()
  skillAlertOptionWnd.skillList = skillList
  local skillListBg = CreateContentBackground(skillList, "TYPE2", "default")
  skillListBg:AddAnchor("TOPLEFT", skillList, 0, -5)
  skillListBg:AddAnchor("BOTTOMRIGHT", skillList, 8, 5)
  local function LayoutFunc(frame, rowIndex, colIndex, subItem)
    local checkBox = CreateCheckButton("checkBox", subItem)
    checkBox:AddAnchor("LEFT", subItem, 20, 0)
    subItem.checkBox = checkBox
    function checkBox:CheckBtnCheckChagnedProc(checked)
      local data = skillAlertOptionWnd.skillList:GetDataByViewIndex(rowIndex, colIndex)
      if data ~= nil then
        data.use = checked
        if checked == false then
          table.insert(skillBlackList, data.skillType)
        else
          table.insert(skillWhiteList, data.skillType)
        end
      end
      skillAlertOptionWnd.skillList:UpdateView()
    end
    local skillIcon = CreateItemIconButton("skillIcon", subItem)
    skillIcon:SetExtent(ICON_SIZE.AUCTION, ICON_SIZE.AUCTION)
    skillIcon:AddAnchor("LEFT", subItem, "LEFT", 47, 0)
    subItem.skillIcon = skillIcon
    function skillIcon:OnEnter()
      local info = X2SkillAlert:GetTooltip(subItem.skillType)
      if info ~= nil then
        ShowTooltip(info, self)
      end
    end
    skillIcon:SetHandler("OnEnter", skillIcon.OnEnter)
    function skillIcon:OnLeave()
      HideTooltip()
    end
    skillIcon:SetHandler("OnLeave", skillIcon.OnLeave)
    subItem.style:SetFontSize(FONT_SIZE.MIDDLE)
    subItem.style:SetAlign(ALIGN_LEFT)
    subItem:SetInset(93, 0, 0, 0)
    ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
    local topLine = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "line_01", "background")
    topLine:SetExtent(359, 3)
    topLine:AddAnchor("TOPRIGHT", subItem, "TOPRIGHT")
    subItem.topLine = topLine
    topLine:Show(false)
    local existSlotBg = subItem:CreateDrawable(TEXTURE_PATH.DEFAULT, "common_bg", "background")
    existSlotBg:SetTextureColor("green")
    existSlotBg:SetExtent(390, 36)
    existSlotBg:AddAnchor("LEFT", skillIcon, "RIGHT")
    subItem.existSlotBg = existSlotBg
    existSlotBg:Show(false)
  end
  local SetDataFunc = function(subItem, data, setValue)
    if setValue then
      subItem.skillType = data.skillType
      subItem.checkBox:SetChecked(data.use, false)
      F_SLOT.SetIconBackGround(subItem.skillIcon, data.iconPath)
      if data.use then
        ApplyTextColor(subItem, FONT_COLOR.DEFAULT)
      else
        ApplyTextColor(subItem, F_COLOR.GetColor("off_gray"))
      end
      subItem:SetText(data.name)
      subItem.existSlotBg:Show(data.existSlot)
    else
      subItem.skillType = 0
      subItem:SetText("")
      subItem.checkBox:SetChecked(false)
    end
  end
  skillList:InsertColumn("", 185, LCCIT_STRING, SetDataFunc, nil, nil, LayoutFunc)
  skillList:InsertRows(7, false)
  ListCtrlItemGuideLine(skillList.listCtrl.items, skillList:GetRowCount() + 1)
  for i = 1, #skillList.listCtrl.items do
    local item = skillList.listCtrl.items[i]
    item.line:SetVisible(true)
  end
  local labelWidth = 372
  local helpMsgLabel1 = skillAlertOptionWnd:CreateChildWidget("textbox", "helpMsgLabel1", 0, false)
  helpMsgLabel1:SetAutoResize(true)
  helpMsgLabel1.style:SetAlign(ALIGN_LEFT)
  helpMsgLabel1.style:SetFontSize(FONT_SIZE.MIDDLE)
  helpMsgLabel1:SetText(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg1"))
  local len = helpMsgLabel1.style:GetTextWidth(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg1"))
  local offset = math.floor(len / labelWidth)
  helpMsgLabel1:SetExtent(labelWidth, FONT_SIZE.MIDDLE + FONT_SIZE.MIDDLE * offset)
  helpMsgLabel1:AddAnchor("TOPLEFT", skillList, "BOTTOMLEFT", 20, 12)
  ApplyTextColor(helpMsgLabel1, FONT_COLOR.DEFAULT)
  local dingbat = W_ICON.DrawDingbat(helpMsgLabel1)
  dingbat:AddAnchor("TOPRIGHT", helpMsgLabel1, "TOPLEFT", -5, 4)
  local helpMsgLabel2 = skillAlertOptionWnd:CreateChildWidget("textbox", "helpMsgLabel2", 0, false)
  helpMsgLabel2:SetExtent(labelWidth, FONT_SIZE.MIDDLE)
  helpMsgLabel2:SetAutoResize(true)
  helpMsgLabel2.style:SetAlign(ALIGN_LEFT)
  helpMsgLabel2.style:SetFontSize(FONT_SIZE.MIDDLE)
  helpMsgLabel2:SetText(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg2"))
  len = helpMsgLabel2.style:GetTextWidth(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg2"))
  offset = math.floor(len / labelWidth)
  helpMsgLabel2:SetExtent(labelWidth, FONT_SIZE.MIDDLE + FONT_SIZE.MIDDLE * offset)
  helpMsgLabel2:AddAnchor("TOPLEFT", helpMsgLabel1, "BOTTOMLEFT", 0, 5)
  ApplyTextColor(helpMsgLabel2, FONT_COLOR.DEFAULT)
  W_ICON.DrawDingbat(helpMsgLabel2, -5)
  local helpMsgLabel3 = skillAlertOptionWnd:CreateChildWidget("textbox", "helpMsgLabel3", 0, false)
  helpMsgLabel3:SetExtent(labelWidth, FONT_SIZE.MIDDLE)
  helpMsgLabel3:SetAutoResize(true)
  helpMsgLabel3.style:SetAlign(ALIGN_LEFT)
  helpMsgLabel3.style:SetFontSize(FONT_SIZE.MIDDLE)
  helpMsgLabel3:SetText(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg3"))
  len = helpMsgLabel3.style:GetTextWidth(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg3"))
  offset = math.floor(len / labelWidth)
  helpMsgLabel3:SetExtent(labelWidth, FONT_SIZE.MIDDLE + FONT_SIZE.MIDDLE * offset)
  helpMsgLabel3:AddAnchor("TOPLEFT", helpMsgLabel2, "BOTTOMLEFT", 0, 5)
  helpMsgLabel3:SetText(GetUIText(COMMON_TEXT, "skill_alert_option_popup_help_msg3"))
  ApplyTextColor(helpMsgLabel3, FONT_COLOR.DEFAULT)
  W_ICON.DrawDingbat(helpMsgLabel3, -5)
  local totalMsgHeight = helpMsgLabel1:GetHeight() + helpMsgLabel2:GetHeight() + helpMsgLabel3:GetHeight()
  skillAlertOptionWnd:SetHeight(570 + totalMsgHeight - FONT_SIZE.MIDDLE * 3)
  local buttonSetInfo = {
    leftButtonLeftClickFunc = function()
      skillAlertOptionWnd:SaveSkillAlertBlackList()
      skillAlertOptionWnd:Show(false)
      AddMessageToSysMsgWindow(GetUIText(ERROR_MSG, "OPTION_SKILL_ALERT_SAVE_SUCCESS"))
    end,
    rightButtonLeftClickFunc = function()
      skillAlertOptionWnd:Show(false)
    end
  }
  CreateWindowDefaultTextButtonSet(skillAlertOptionWnd, buttonSetInfo)
  function skillAlertOptionWnd:UpdateSkillAlertAbilitySkillList(ability)
    skillBlackList = {}
    skillWhiteList = {}
    self.skillList:DeleteAllDatas()
    local infoTable = X2SkillAlert:GetAbilitySkillList(ability)
    if #infoTable == 0 then
      self.skillListBgLabel:Show(true)
      self.skillList.listCtrl:Show(false)
      return
    end
    self.skillListBgLabel:Show(false)
    self.skillList.listCtrl:Show(true)
    for i = 1, #infoTable do
      self.skillList:InsertData(i, 1, infoTable[i])
    end
  end
  function skillAlertOptionWnd:SaveSkillAlertBlackList()
    X2SkillAlert:SaveSkillBlackList(skillBlackList, skillWhiteList)
  end
end
if skillAlertOptionWnd == nil then
  CreateSkillAlertOptionWnd()
end
function ShowSkillAlertOptionWnd(show)
  if show == true then
    local myAbilityInfo = X2Ability:GetActiveAbilityForSkillAlert()
    local datas = {}
    for i = 1, #myAbilityInfo do
      local data = {
        text = locale.common.abilityNameWithId(myAbilityInfo[i].type),
        value = myAbilityInfo[i].type
      }
      table.insert(datas, data)
    end
    skillAlertOptionWnd.filterBtn:AppendItems(datas)
    skillAlertOptionWnd:Show(true)
  else
    skillAlertOptionWnd:Show(false)
  end
end
