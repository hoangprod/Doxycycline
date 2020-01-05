local MAX_SAVE_SLOT = 3
local savedAbilList, selectedIndex
local usableCount = 0
local controls = {}
local GetAbilCategoryName = function(name)
  if name == "predator" or name == "trooper" then
    return nil
  end
  return locale.common.abilityNameWithStr(name)
end
local IsValidAbil = function(abilNum)
  return abilNum > ABILITY_GENERAL and abilNum < COMBAT_ABILITY_MAX
end
local function IsExistSavedJob(index)
  if index < MAX_SAVE_SLOT + 1 and index > usableCount then
    return nil
  end
  if savedAbilList then
    local savedAbility = savedAbilList[index]
    return savedAbility and (IsValidAbil(savedAbility[1]) or IsValidAbil(savedAbility[2]) or IsValidAbil(savedAbility[3]))
  end
  return false
end
local function GetNowUseSlotCount()
  local validJobCnt = 0
  for i = 1, usableCount do
    if IsExistSavedJob(i) then
      validJobCnt = validJobCnt + 1
    end
  end
  return validJobCnt
end
local function UseAllMaxSaveSlot()
  return GetNowUseSlotCount() == MAX_SAVE_SLOT
end
local function UseAllUsableSlot()
  return usableCount > 0 and MAX_SAVE_SLOT > usableCount and GetNowUseSlotCount() == usableCount
end
local function GetValidAbilCount(abils)
  local total = 0
  for i = 1, 3 do
    if IsValidAbil(abils[i]) then
      total = total + 1
    end
  end
  return total
end
local function GetJobName(abils)
  local newJobName = F_UNIT.GetCombinedAbilityName(abils[1], abils[2], abils[3])
  local abilName = GetAbilCategoryName(X2Ability:GetAbilityStr(abils[1]))
  local abil2Name = GetAbilCategoryName(X2Ability:GetAbilityStr(abils[2]))
  local abil3Name = GetAbilCategoryName(X2Ability:GetAbilityStr(abils[3]))
  if abil2Name then
    abilName = string.format("%s, %s", abilName, abil2Name)
  end
  if abil3Name then
    abilName = string.format("%s, %s", abilName, abil3Name)
  end
  abilName = string.format("%s - %s", newJobName, abilName)
  return abilName
end
local function ActiveSavedAbilitiesDialogHandler(dialogWnd)
  dialogWnd:SetTitle(GetCommonText("change_abilities"))
  dialogWnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "change_saved_job_confirm_msg", GetJobName(savedAbilList[selectedIndex])))
  local usedFreeCnt, maxFreeCnt = X2Ability:GetAbilitySetFreeActivationCountInfo()
  local isRemainFreeCount = not (maxFreeCnt <= usedFreeCnt)
  if isRemainFreeCount then
    ApplyDialogStyle(dialogWnd, "TYPE2")
    local freeCountInfo = dialogWnd:CreateChildWidget("label", "freeCountInfo", 0, true)
    freeCountInfo:SetExtent(dialogWnd.textbox:GetWidth(), FONT_SIZE.MIDDLE)
    freeCountInfo:AddAnchor("TOP", dialogWnd.valueTextBox, "BOTTOM", 0, 5)
    ApplyTextColor(freeCountInfo, FONT_COLOR.GRAY)
    freeCountInfo:SetText(GetCommonText("ability_set_free_count_info"))
    valueText = string.format("%s %s%d/%d", GetCommonText("ability_set_free_count"), FONT_COLOR_HEX.BLUE, usedFreeCnt, maxFreeCnt)
    dialogWnd.valueTextBox:RemoveAllAnchors()
    dialogWnd.valueTextBox:AddAnchor("TOP", dialogWnd.textbox, "BOTTOM", 0, 10)
    dialogWnd.valueTextBox.bg:Show(not isRemainFreeCount)
    dialogWnd:RegistBottomWidget(freeCountInfo)
    dialogWnd:SetContentEx(content, valueText)
  else
    local data = {
      type = "cost",
      currency = F_MONEY.currency.abilitySetChange,
      value = X2Ability:GetAbilitySetChangeCost()
    }
    dialogWnd:CreateDialogModule(DIALOG_MODULE_TYPE.VALUE_BOX, "cost", data)
  end
  function dialogWnd:OkProc()
    X2Ability:ActiveAbilitySet(selectedIndex - 1)
  end
end
local function DeleteSavedAbilitiesDialogHandler(dialogWnd)
  ApplyDialogStyle(dialogWnd, DIALOG_STYLE.INCLUDE_SEPERATE_TEXT)
  dialogWnd:SetTitle(GetCommonText("delete_saved_job_title"))
  dialogWnd:SetTextColor(FONT_COLOR.DEFAULT, FONT_COLOR.BLUE)
  dialogWnd:SetContent(GetCommonText("delete_saved_job_confirm_msg"), GetJobName(savedAbilList[selectedIndex]))
  function dialogWnd:OkProc()
    X2Ability:DeleteAbilitySet(selectedIndex - 1)
  end
end
local function UpdatePreviewSkillSlots(skillWnd, abils, isSelectCurrentJob)
  if not isSelectCurrentJob then
    skillWnd.savedSkills = X2Ability:GetSavedSkillSet(selectedIndex)
    skillWnd.savedPassiveBuffs = X2Ability:GetSavedPassiveBuffSet(selectedIndex)
  else
    skillWnd.savedSkills = nil
    skillWnd.savedPassiveBuffs = nil
  end
  for i = 1, 3 do
    local combatSkillList = skillWnd.children[i]
    if IsValidAbil(abils[i]) then
      X2Ability:SetAbilityToView(i, abils[i])
      if isSelectCurrentJob then
        combatSkillList:Update()
      else
        combatSkillList:UpdateSavedSkillSetPreview(selectedIndex)
      end
    else
      X2Ability:SetAbilityToView(i, ABILITY_MAX)
      combatSkillList:Update(selectedIndex)
    end
  end
  if skillWnd.UpdateJobName then
    skillWnd:UpdateJobName()
    if isSelectCurrentJob then
      skillWnd:UpdateSkillPoint()
    else
      skillWnd:UpdateSkillPoint(selectedIndex)
    end
  end
end
local function SetEventHandlersBottomPannel(pannel, infoPreviewLabel)
  local jobListCombo = pannel.jobListCombo
  local saveDeleteBtn = pannel.saveDeleteBtn
  local applyBtn = pannel.applyBtn
  local guide = pannel.guide
  local expandBtn = pannel.expandBtn
  local saveDeleteBtnTooltipMsg
  function jobListCombo:SelectedProc(selIndex)
    selectedIndex = selIndex
    local selectedAbils
    local currentJobIndex = X2Ability:GetIndexCurrentJobInSavedJobList()
    if currentJobIndex == nil then
      currentJobIndex = -1
    end
    X2Ability:SelectAbilitySetIndex(selectedIndex, currentJobIndex)
    local info = self:GetSelectedInfo()
    local selectedString = info.text
    local selectedJobNotInJobList = selectedString == GetCommonText("current_use")
    local selectedEmptySlot = not IsExistSavedJob(selectedIndex)
    local curMyAbilInfo = X2Unit:GetTargetAbilityTemplates("player")
    local curMyAbilIndexes = {
      curMyAbilInfo[1].index,
      curMyAbilInfo[2].index,
      curMyAbilInfo[3].index
    }
    if selectedJobNotInJobList then
      selectedAbils = curMyAbilIndexes
      jobListCombo:SetText(GetJobName(selectedAbils))
    else
      jobListCombo:SetText(selectedString)
    end
    if selectedEmptySlot or selectedJobNotInJobList then
      selectedAbils = curMyAbilIndexes
    else
      selectedAbils = savedAbilList[selectedIndex]
    end
    local isSelectCurrentJob = currentJobIndex + 1 == selectedIndex or selectedJobNotInJobList or selectedEmptySlot
    UpdatePreviewSkillSlots(pannel:GetParent(), selectedAbils, isSelectCurrentJob)
    local isAllExpand = usableCount == MAX_SAVE_SLOT
    infoPreviewLabel:Show(not isSelectCurrentJob)
    applyBtn:Enable(not isSelectCurrentJob)
    expandBtn:Enable(not isAllExpand and UIParent:GetPermission(UIC_EXPAND_JOB))
    if selectedEmptySlot or selectedJobNotInJobList then
      ApplyButtonSkin(saveDeleteBtn, BUTTON_CONTENTS.SKILL_ABILITY_SAVE)
      if UseAllMaxSaveSlot() then
        saveDeleteBtn:Enable(false)
        saveDeleteBtnTooltipMsg = GetCommonText("warning_max_saved_job", MAX_SAVE_SLOT)
      elseif UseAllUsableSlot() then
        saveDeleteBtn:Enable(false)
        saveDeleteBtnTooltipMsg = GetCommonText("lack_of_saved_job_slot")
      else
        local canSave = selectedIndex == MAX_SAVE_SLOT + 1 or not (selectedIndex > usableCount)
        canSave = canSave and X2Ability:GetNumSkills() > 0 and GetNowUseSlotCount() < usableCount and GetValidAbilCount(selectedAbils) == 3
        saveDeleteBtn:Enable(canSave)
        saveDeleteBtnTooltipMsg = GetCommonText("save_job")
      end
    else
      ApplyButtonSkin(saveDeleteBtn, BUTTON_CONTENTS.SKILL_ABILITY_DELETE)
      saveDeleteBtn:Enable(true)
      saveDeleteBtnTooltipMsg = GetCommonText("delete")
    end
  end
  local function ProcSaveDeleteBtn()
    if IsExistSavedJob(selectedIndex) then
      X2DialogManager:RequestDefaultDialog(DeleteSavedAbilitiesDialogHandler, pannel:GetParent():GetId())
    else
      X2Ability:SaveAbilitySet(selectedIndex - 1)
    end
  end
  saveDeleteBtn:SetHandler("OnClick", ProcSaveDeleteBtn)
  local function ProcApply()
    X2DialogManager:RequestDefaultDialog(ActiveSavedAbilitiesDialogHandler, pannel:GetParent():GetId())
  end
  applyBtn:SetHandler("OnClick", ProcApply)
  local function ProcExpand()
    local function DialogHandler(wnd)
      wnd:SetTitle(GetCommonText("expand_slot_count"))
      wnd:UpdateDialogModule("textbox", GetUIText(COMMON_TEXT, "add_saved_job_slot_confirm_msg"))
      local info = X2Ability:GetExpandAbilitySetSlotInfo()
      local data = {
        titleInfo = {
          title = GetUIText(COMMON_TEXT, "add_slot_count")
        },
        left = {
          UpdateValueFunc = function(leftValueWidget)
            leftValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(usableCount)))
          end
        },
        right = {
          UpdateValueFunc = function(rightValueWidget)
            rightValueWidget:SetText(GetUIText(COMMON_TEXT, "amount", tostring(usableCount + 1)))
          end
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.CHANGE_BOX_A, "changeBox", data)
      local itemData = {
        itemInfo = X2Item:GetItemInfoByType(info.itemType),
        stack = {
          info.curCount,
          info.needCount
        }
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ITEM_ICON_VERTICAL, "itemIcon", itemData)
      local textData = {
        type = "default",
        text = GetUIText(COMMON_TEXT, "expandable_count", tostring(MAX_SAVE_SLOT - usableCount))
      }
      wnd:CreateDialogModule(DIALOG_MODULE_TYPE.ADDITIONAL_TEXTBOX, "count", textData)
      function wnd:OkProc()
        X2Ability:RequestExpandAbilitySetSlot()
      end
    end
    X2DialogManager:RequestDefaultDialog(DialogHandler, "UIParent")
  end
  expandBtn:SetHandler("OnClick", ProcExpand)
  local OnGuideEnter = function(self)
    local title = GetCommonText("tooltip_save_job_info_title")
    local msg1 = GetCommonText("tooltip_save_job_info_msg1")
    local msg2 = GetCommonText("tooltip_save_job_info_msg4")
    local msg3 = GetCommonText("tooltip_save_job_info_msg2")
    local msg4 = GetCommonText("tooltip_save_job_info_msg3")
    local resultMsg = string.format([[
%s
%s
%s
%s
%s]], title, msg1, msg2, msg3, msg4)
    SetTooltip(resultMsg, self, false, 500)
  end
  guide:SetHandler("OnEnter", OnGuideEnter)
  local OnExpandBtnEnter = function(self)
    SetTooltip(GetCommonText("expand_slot_count"), self)
  end
  expandBtn:SetHandler("OnEnter", OnExpandBtnEnter)
  local function OnSaveDeleteBtnEnter(self)
    SetTooltip(saveDeleteBtnTooltipMsg, self)
  end
  saveDeleteBtn:SetHandler("OnEnter", OnSaveDeleteBtnEnter)
  local OnApplyBtnEnter = function(self)
    SetTooltip(GetCommonText("activation"), self)
  end
  applyBtn:SetHandler("OnEnter", OnApplyBtnEnter)
end
function CreateSaveAbilitiesWidget(wnd)
  if X2Player:GetFeatureSet().useSavedAbilities == false then
    return
  end
  local bgWidth = wnd:GetParent():GetWidth()
  local bottomPannel = wnd:CreateChildWidget("emptyWidget", "bottomPannel", 0, true)
  bottomPannel:SetExtent(bgWidth, 50)
  local bottomPannelOffSetY = 0
  local guideOffSetY = -8
  bottomPannel:AddAnchor("BOTTOM", wnd, "BOTTOM", 0, bottomPannelOffSetY)
  wnd.bottomPannel = bottomPannel
  local bottomPannelBg = CreateContentBackground(bottomPannel, "TYPE10", "brown_4")
  bottomPannelBg:SetExtent(bgWidth, 36)
  bottomPannelBg:AddAnchor("TOPLEFT", bottomPannel, 0, -5)
  local guide = W_ICON.CreateGuideIconWidget(bottomPannel)
  guide:AddAnchor("LEFT", bottomPannel, "LEFT", 10, 6 + guideOffSetY)
  bottomPannel.guide = guide
  local saveJobTitle = bottomPannel:CreateChildWidget("label", "saveJobTitle", 0, true)
  local width = bgWidth / 4
  saveJobTitle:SetExtent(width, 24)
  saveJobTitle:AddAnchor("LEFT", guide, "RIGHT", 5, 0)
  saveJobTitle.style:SetAlign(ALIGN_LEFT)
  saveJobTitle.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(saveJobTitle, FONT_COLOR.TITLE)
  saveJobTitle:SetText(GetCommonText("tooltip_save_job_info_title"))
  local expandBtn = bottomPannel:CreateChildWidget("button", "expandBtn", 0, true)
  expandBtn:AddAnchor("LEFT", saveJobTitle, "RIGHT", 5, 1)
  ApplyButtonSkin(expandBtn, BUTTON_CONTENTS.INVENTORY_EXPAND)
  expandBtn:SetExtent(expandBtn:GetWidth() * 0.6, expandBtn:GetHeight() * 0.6)
  bottomPannel.expandBtn = expandBtn
  table.insert(controls, bottomPannel.expandBtn)
  local jobListCombo = W_CTRL.CreateComboBox("jobListCombo", bottomPannel)
  jobListCombo:SetWidth(198)
  jobListCombo:AddAnchor("LEFT", expandBtn, "RIGHT", 5, 0)
  jobListCombo:SetEllipsis(true, {
    "LEFT",
    jobListCombo,
    "RIGHT",
    0,
    jobListCombo:GetHeight() + 8
  })
  jobListCombo:ShowDropdownTooltip(true)
  table.insert(controls, bottomPannel.jobListCombo)
  local saveDeleteBtn = bottomPannel:CreateChildWidget("button", "saveDelete", 0, true)
  saveDeleteBtn:AddAnchor("LEFT", jobListCombo, "RIGHT", 5, 0)
  bottomPannel.saveDeleteBtn = saveDeleteBtn
  ApplyButtonSkin(saveDeleteBtn, BUTTON_CONTENTS.SKILL_ABILITY_SAVE)
  table.insert(controls, bottomPannel.saveDeleteBtn)
  local applyBtn = bottomPannel:CreateChildWidget("button", "applyBtn", 0, true)
  applyBtn:AddAnchor("LEFT", saveDeleteBtn, "RIGHT", 5, 0)
  bottomPannel.applyBtn = applyBtn
  ApplyButtonSkin(applyBtn, BUTTON_CONTENTS.SKILL_ABILITY_APPLY)
  table.insert(controls, bottomPannel.applyBtn)
  local infoPreviewLabel = bottomPannel:CreateChildWidget("label", "infoPreviewLabel", 0, true)
  infoPreviewLabel:SetExtent(120, FONT_SIZE.LARGE)
  infoPreviewLabel:AddAnchor("LEFT", applyBtn, "RIGHT", 0, 0)
  infoPreviewLabel.style:SetAlign(ALIGN_RIGHT)
  infoPreviewLabel.style:SetFontSize(FONT_SIZE.LARGE)
  ApplyTextColor(infoPreviewLabel, FONT_COLOR.BLUE)
  infoPreviewLabel:SetText(GetCommonText("preview_saved_job"))
  infoPreviewLabel:Show(false)
  SetEventHandlersBottomPannel(bottomPannel, infoPreviewLabel)
  local function GetJobComboStringList(currentJobNotInList)
    local jobList = {}
    for i = 1, MAX_SAVE_SLOT do
      local data = {value = i}
      if IsExistSavedJob(i) then
        local savedAbilItem = savedAbilList[i]
        jobName = string.format("%d. %s", i, GetJobName(savedAbilItem))
        data.text = jobName
        data.enable = true
      else
        local msgKey
        if i > usableCount then
          msgKey = "disable_job_slot"
          data.enable = false
        else
          msgKey = "savable_abilities"
          data.enable = true
        end
        data.text = string.format("%d. %s", i, GetCommonText(msgKey))
      end
      table.insert(jobList, data)
    end
    if currentJobNotInList then
      local data = {
        text = GetCommonText("current_use"),
        color = FONT_COLOR.DEFAULT,
        disableColor = FONT_COLOR.GRAY,
        value = #jobList + 1,
        useColor = true,
        enable = true
      }
      table.insert(jobList, data)
    end
    return jobList
  end
  function wnd:UpdateJobComboList()
    savedAbilList, usableCount = X2Ability:GetSavedAbilitySets()
    local currentJobIndex = X2Ability:GetIndexCurrentJobInSavedJobList()
    if currentJobIndex == nil then
      currentJobIndex = -1
    end
    local currentJobNotInList = currentJobIndex < 0
    local jobList = GetJobComboStringList(currentJobNotInList)
    jobListCombo:AppendItems(jobList, false)
    if currentJobNotInList then
      currentJobIndex = #jobList
      jobListCombo:Select(currentJobIndex)
    else
      jobListCombo:Select(currentJobIndex + 1)
    end
  end
  function wnd:UpdateControlsEnable(caster, enable)
    if caster ~= "player" then
      return
    end
    for i = 1, #controls do
      if i == 2 then
        controls[i]:SetEnable(enable)
      else
        controls[i]:Enable(enable)
      end
    end
    if enable then
      controls[2]:Select(selectedIndex)
    end
  end
  function wnd:UpdateByInstantGame()
    if not UIParent:GetPermission(UIC_EXPAND_JOB) then
      controls[1]:Enable(false)
    else
      controls[1]:Enable(usableCount < MAX_SAVE_SLOT)
    end
  end
  wnd:UpdateJobComboList()
end
